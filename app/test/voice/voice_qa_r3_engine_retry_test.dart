// QA (รอบ 3) — re-check BUG-VOICE-2: สถานการณ์จริงบน emulator ตั้งแต่ต้นจนจบ
//
// DECIDED (owner 2026-11-12, รอบ 3):
// - V-11: engine ไม่พร้อม → ห้ามบันทึกช่วงที่มีบทพูดว่า "พูดแล้ว" · Master Voice ปิด → ยังบันทึกตาม Q-08
// - V-12: prepare() false → ลองใหม่เมื่อเข้า dashboard และเมื่อ resumed ขณะอยู่ dashboard ·
//   true แล้วไม่เรียกซ้ำ · พร้อมแล้วประเมินช่วงแล้วพูดบทที่ค้างตามลำดับ water → steps → food
//
// ค่าคาดหวังจากเอกสาร (voice_qa_docs.dart): ข้อความ Exact String game-rules §1.1 · id บทพูด (V-6) ·
// key `voice_day_bands` (ui-spec §2.5) · เกณฑ์ game-rules §1 (น้ำ < 3 แก้ว = low, ≥ 8 = success;
// ก้าว ≥ 100% = success) · ไม่ import VoiceRules
// ใช้ SharedPreferences จริง (mock store ของ plugin) — restart = สร้าง repository/controller ใหม่จากข้อมูลเดิม
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/dashboard/screens/dashboard_screen.dart';
import 'package:petpal_health/features/voice/voice_controller.dart';
import 'package:petpal_health/features/voice/voice_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard/dashboard_test_helpers.dart' as dh;
import 'fake_voice_tts_engine.dart';
import 'voice_qa_docs.dart';

const _bubble = Key('voice_speech_bubble');
const _bubbleText = Key('voice_speech_text');

/// เปิดเสียงแล้ว (ตอบ S-1 ว่าเปิด) — ข้อมูลอื่นว่าง (ยังไม่เคยบันทึกช่วง)
Map<String, Object> _voiceOn({bool master = true}) => {
      keyPermission: true,
      keyMaster: master,
    };

Future<Map<String, Object>> _snapshotPrefs() async {
  final p = await SharedPreferences.getInstance();
  return {for (final k in p.getKeys()) k: p.get(k)!};
}

/// ปิดแอปแล้วเปิดใหม่: storage คงเดิม แต่ instance ใหม่ทั้งหมด
Future<void> _restartStorage() async {
  final snap = await _snapshotPrefs();
  SharedPreferences.setMockInitialValues(snap);
}

Future<String?> _storedBands() async =>
    (await SharedPreferences.getInstance()).getString(keyDayBands);

void main() {
  DateTime clock() => dh.t(14, 10);

  // emulator: steps ≥ 100% (10,000 / 10,000) และน้ำ 2 แก้ว · อาหาร 0 kcal (ไม่เกิน → ไม่มีบท)
  Future<dh.Sources> sources({int cups = 2, int steps = 10000}) async {
    final s = dh.makeSources(
      clock: clock,
      water: dh.water14(cups),
      steps: dh.steps14(steps, goal: 10000),
      food: dh.food14(0),
    );
    await s.loadAll();
    return s;
  }

  Widget dashboard(dh.Sources s, VoiceController voice) => MaterialApp(
        home: DashboardScreen(
          waterController: s.water,
          stepsController: s.steps,
          foodController: s.food,
          voiceController: voice,
          animatePet: false,
        ),
      );

  Future<void> frames(WidgetTester tester, [int n = 8]) async {
    for (var i = 0; i < n; i++) {
      await tester.pump();
    }
  }

  Future<void> background(WidgetTester tester) async {
    final b = tester.binding;
    b.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    b.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    b.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await frames(tester);
  }

  Future<void> foreground(WidgetTester tester) async {
    final b = tester.binding;
    b.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    b.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    b.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await frames(tester);
  }

  String? bubble(WidgetTester tester) {
    final f = find.byKey(_bubbleText);
    if (f.evaluate().isEmpty) return null;
    return tester.widget<Text>(f).data;
  }

  Future<void> leave(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await frames(tester, 3);
  }

  Future<void> teardown(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await frames(tester, 2);
  }

  group('DECIDED_R3 emulator flow (BUG-VOICE-2)', () {
    testWidgets(
        'DECIDED_R3_e2e_engine_false_then_resumed_speaks_water_low_then_steps_success_once',
        (tester) async {
      SharedPreferences.setMockInitialValues(_voiceOn());
      final s = await sources();
      // autoComplete false → ตรวจฟองทีละบท
      final engine = FakeVoiceTtsEngine(available: false, autoComplete: false);
      final voice = VoiceController(
          repository: SharedPrefsVoiceRepository(), engine: engine, clock: clock);

      // 1) เข้า dashboard ขณะเครื่องยังไม่มีเสียงไทยออฟไลน์
      await tester.pumpWidget(dashboard(s, voice));
      await frames(tester);
      expect(engine.spoken, isEmpty);
      expect(find.byKey(_bubble), findsNothing, reason: 'Q-11 ไม่มีฟอง');
      final silent = await _storedBands();
      // V-11: ไม่บันทึกช่วงที่มีบทพูด
      expect(silent ?? '', isNot(contains(idWaterLow)));
      expect(silent ?? '', isNot(contains(idStepsSuccess)));

      // 2) resumed แต่ยังไม่ได้ลงเสียง → ลองใหม่ (V-12) แต่ยังเงียบ ยังไม่บันทึก
      await background(tester);
      await foreground(tester);
      expect(engine.prepareCount, 2, reason: 'V-12 ลอง prepare ใหม่เมื่อ resumed');
      expect(engine.spoken, isEmpty);
      expect(await _storedBands() ?? '', isNot(contains(idWaterLow)));

      // 3) ผู้ใช้ลงเสียงไทยออฟไลน์ระหว่างแอปอยู่ background → กลับมา
      await background(tester);
      engine.available = true;
      await foreground(tester);
      expect(engine.prepareCount, 3);
      // ลำดับ water → steps (V-12 / EC-2 FIFO) · ฟองแสดงบทแรกก่อน
      expect(engine.spoken, [docWaterLow]);
      expect(bubble(tester), docWaterLow);
      engine.completeCurrent();
      await frames(tester);
      expect(engine.spoken, [docWaterLow, docStepsSuccess]);
      expect(bubble(tester), docStepsSuccess);
      engine.completeCurrent();
      await frames(tester);
      expect(find.byKey(_bubble), findsNothing);
      expect(engine.maxActive, 1, reason: 'EC-2 ไม่พูดซ้อน');
      // พูดแล้ว → บันทึกช่วง
      final spokenBands = await _storedBands();
      expect(spokenBands, contains(idWaterLow));
      expect(spokenBands, contains(idStepsSuccess));

      // 4) resumed ซ้ำ → ไม่พูดซ้ำ และไม่ prepare ซ้ำ (true แล้วไม่เรียกซ้ำ)
      await background(tester);
      await foreground(tester);
      await background(tester);
      await foreground(tester);
      expect(engine.spoken, [docWaterLow, docStepsSuccess]);
      expect(engine.prepareCount, 3);

      // 5) ออกจาก dashboard แล้วเข้าใหม่ → ไม่พูดซ้ำ
      await leave(tester);
      await tester.pumpWidget(dashboard(s, voice));
      await frames(tester);
      expect(engine.spoken.length, 2);
      expect(engine.prepareCount, 3);
      expect(find.byKey(_bubble), findsNothing);

      await teardown(tester);
      voice.dispose();
    });

    testWidgets(
        'DECIDED_R3_reenter_dashboard_after_engine_ready_speaks_pending_once',
        (tester) async {
      SharedPreferences.setMockInitialValues(_voiceOn());
      final s = await sources();
      final engine = FakeVoiceTtsEngine(available: false);
      final voice = VoiceController(
          repository: SharedPrefsVoiceRepository(), engine: engine, clock: clock);
      await tester.pumpWidget(dashboard(s, voice));
      await frames(tester);
      expect(engine.spoken, isEmpty);
      await leave(tester);

      engine.available = true;
      await tester.pumpWidget(dashboard(s, voice));
      await frames(tester);
      expect(engine.spoken, [docWaterLow, docStepsSuccess]);
      await leave(tester);
      await tester.pumpWidget(dashboard(s, voice));
      await frames(tester);
      expect(engine.spoken, [docWaterLow, docStepsSuccess]);

      await teardown(tester);
      voice.dispose();
    });

    testWidgets(
        'DECIDED_R3_restart_during_silent_period_then_engine_ready_speaks',
        (tester) async {
      SharedPreferences.setMockInitialValues(_voiceOn());

      // ครั้งที่ 1: ไม่มีเสียงไทย
      final s1 = await sources();
      final e1 = FakeVoiceTtsEngine(available: false);
      final v1 = VoiceController(
          repository: SharedPrefsVoiceRepository(), engine: e1, clock: clock);
      await tester.pumpWidget(dashboard(s1, v1));
      await frames(tester);
      expect(e1.spoken, isEmpty);
      await teardown(tester);
      v1.dispose();

      // ปิดแอป → ลงเสียงไทย → เปิดใหม่
      await _restartStorage();
      final stored = await _storedBands();
      expect(stored ?? '', isNot(contains(idWaterLow)));
      expect(stored ?? '', isNot(contains(idStepsSuccess)));

      final s2 = await sources();
      final e2 = FakeVoiceTtsEngine();
      final v2 = VoiceController(
          repository: SharedPrefsVoiceRepository(), engine: e2, clock: clock);
      await tester.pumpWidget(dashboard(s2, v2));
      await frames(tester);
      expect(e2.spoken, [docWaterLow, docStepsSuccess]);
      expect(e2.prepareCount, 1);
      await teardown(tester);
      v2.dispose();

      // เปิดใหม่อีกครั้งวันเดียวกัน → ไม่พูดซ้ำ (บันทึกลงเครื่องแล้ว)
      await _restartStorage();
      final s3 = await sources();
      final e3 = FakeVoiceTtsEngine();
      final v3 = VoiceController(
          repository: SharedPrefsVoiceRepository(), engine: e3, clock: clock);
      await tester.pumpWidget(dashboard(s3, v3));
      await frames(tester);
      expect(e3.spoken, isEmpty);
      await teardown(tester);
      v3.dispose();
    });

    testWidgets(
        'DECIDED_R3_corrupt_day_bands_and_engine_false_then_ready_speaks_no_crash',
        (tester) async {
      // ข้อมูลเสีย (edge 4): voice_day_bands อ่านไม่ได้
      SharedPreferences.setMockInitialValues(
          {..._voiceOn(), keyDayBands: '{not json'});
      final s1 = await sources();
      final e1 = FakeVoiceTtsEngine(available: false);
      final v1 = VoiceController(
          repository: SharedPrefsVoiceRepository(), engine: e1, clock: clock);
      await tester.pumpWidget(dashboard(s1, v1));
      await frames(tester);
      expect(tester.takeException(), isNull);
      expect(e1.spoken, isEmpty);
      await teardown(tester);
      v1.dispose();

      await _restartStorage();
      final s2 = await sources();
      final e2 = FakeVoiceTtsEngine();
      final v2 = VoiceController(
          repository: SharedPrefsVoiceRepository(), engine: e2, clock: clock);
      await tester.pumpWidget(dashboard(s2, v2));
      await frames(tester);
      expect(e2.spoken, [docWaterLow, docStepsSuccess]);
      await teardown(tester);
      v2.dispose();
    });

    testWidgets('DECIDED_R3_master_off_still_records_bands_Q08_no_backfill',
        (tester) async {
      SharedPreferences.setMockInitialValues(_voiceOn(master: false));
      final s = await sources();
      final engine = FakeVoiceTtsEngine();
      final voice = VoiceController(
          repository: SharedPrefsVoiceRepository(),
          engine: engine,
          clock: clock,
          timerFactory: dh.FakeTimers().create);
      await tester.pumpWidget(dashboard(s, voice));
      await frames(tester);
      expect(engine.spoken, isEmpty);
      expect(find.byKey(_bubble), findsNothing);
      // Q-08: ปิดเสียง → ยังบันทึกช่วง
      final bands = await _storedBands();
      expect(bands, contains(idWaterLow));
      expect(bands, contains(idStepsSuccess));

      // เปิดเสียงทีหลัง + resumed / เข้าใหม่ → ไม่พูดย้อน
      voice.setMasterVoice(true);
      await background(tester);
      await foreground(tester);
      await leave(tester);
      await tester.pumpWidget(dashboard(s, voice));
      await frames(tester);
      expect(engine.spoken, isEmpty);

      await teardown(tester);
      voice.dispose();
    });

    testWidgets(
        'DECIDED_R3_value_moves_to_no_line_band_while_silent_then_ready_speaks_current_band_only',
        (tester) async {
      // เงียบตอนน้ำ 2 แก้ว (low) → ผู้ใช้ดื่มจนเป็น 3 แก้ว (ขอบ: ไม่มีบท) → engine พร้อม
      // คาดหวัง: ประเมินช่วงปัจจุบันแล้วพูด (V-12) → น้ำ 3 แก้วไม่มีบท · ก้าวยัง ≥ 100% → พูด steps
      SharedPreferences.setMockInitialValues(_voiceOn());
      final s2 = await sources(cups: 2);
      final engine = FakeVoiceTtsEngine(available: false);
      final voice = VoiceController(
          repository: SharedPrefsVoiceRepository(), engine: engine, clock: clock);
      await tester.pumpWidget(dashboard(s2, voice));
      await frames(tester);
      expect(engine.spoken, isEmpty);
      await leave(tester);

      engine.available = true;
      final s3 = await sources(cups: 3);
      await tester.pumpWidget(dashboard(s3, voice));
      await frames(tester);
      expect(engine.spoken, [docStepsSuccess]);
      expect(engine.spoken, isNot(contains(docWaterLow)));

      await teardown(tester);
      voice.dispose();
    });

    testWidgets(
        'DECIDED_R3_values_change_while_silent_on_dashboard_do_not_retry',
        (tester) async {
      // V-12 ระบุจุดลองใหม่ 2 จุดเท่านั้น (เข้า dashboard / resumed)
      SharedPreferences.setMockInitialValues(_voiceOn());
      final s = await sources(cups: 2, steps: 5000);
      final engine = FakeVoiceTtsEngine(available: false);
      final voice = VoiceController(
          repository: SharedPrefsVoiceRepository(), engine: engine, clock: clock);
      await tester.pumpWidget(dashboard(s, voice));
      await frames(tester);
      final afterEnter = engine.prepareCount;
      expect(afterEnter, 1);
      engine.available = true;
      await s.water.logWater(); // 3 แก้ว — ค่าเปลี่ยนขณะอยู่ dashboard
      await frames(tester);
      expect(s.water.cups, 3);
      await frames(tester);
      expect(engine.prepareCount, afterEnter);
      expect(engine.spoken, isEmpty);
      // resumed → ลองใหม่ → พูดตามช่วงปัจจุบัน (น้ำ 3 = ไม่มีบท, ก้าว 50% = ไม่มีบท)
      await background(tester);
      await foreground(tester);
      expect(engine.prepareCount, afterEnter + 1);
      expect(engine.spoken, isEmpty);

      await teardown(tester);
      voice.dispose();
    });
  });

  group('DECIDED_R3 controller (รอบวัน)', () {
    test('DECIDED_R3_silent_yesterday_ready_after_0500_speaks_for_new_day_once',
        () async {
      SharedPreferences.setMockInitialValues(_voiceOn());
      var now = DateTime(2026, 11, 12, 23, 59);
      final engine = FakeVoiceTtsEngine(available: false);
      final voice = VoiceController(
          repository: SharedPrefsVoiceRepository(),
          engine: engine,
          clock: () => now);
      await voice.load();
      voice.evaluate(voiceInput(cups: 2, steps: 10000));
      await pumpEventQueue();
      expect(engine.spoken, isEmpty);

      // 04:59 ยังเป็นรอบวันเดิม (ตัดรอบ 05:00 — A-3)
      now = DateTime(2026, 11, 13, 4, 59);
      engine.available = true;
      voice.retryEngineIfUnavailable();
      voice.evaluate(voiceInput(cups: 2, steps: 10000));
      await pumpEventQueue();
      expect(engine.spoken, [docWaterLow, docStepsSuccess]);

      // 05:00 รอบวันใหม่ → นับใหม่ พูดได้อีกครั้งเดียว
      now = DateTime(2026, 11, 13, 5, 0);
      voice.retryEngineIfUnavailable();
      voice.evaluate(voiceInput(cups: 2, steps: 10000));
      await pumpEventQueue();
      expect(engine.spoken,
          [docWaterLow, docStepsSuccess, docWaterLow, docStepsSuccess]);
      voice.evaluate(voiceInput(cups: 2, steps: 10000));
      await pumpEventQueue();
      expect(engine.spoken.length, 4);
      expect(engine.prepareCount, 2);
      voice.dispose();
    });

    test('DECIDED_R3_steps_threshold_9999_vs_10000_while_silent_then_ready',
        () async {
      // ขอบ AC-3/AC-4: 99.99% = encouraging · 100.00% = success
      SharedPreferences.setMockInitialValues(_voiceOn());
      final engine = FakeVoiceTtsEngine(available: false);
      final voice = VoiceController(
          repository: SharedPrefsVoiceRepository(),
          engine: engine,
          clock: () => DateTime(2026, 11, 12, 10));
      await voice.load();
      voice.evaluate(voiceInput(cups: 5, steps: 9999));
      await pumpEventQueue();
      voice.evaluate(voiceInput(cups: 5, steps: 10000));
      await pumpEventQueue();
      expect(engine.spoken, isEmpty);
      engine.available = true;
      voice.retryEngineIfUnavailable();
      voice.evaluate(voiceInput(cups: 5, steps: 10000));
      await pumpEventQueue();
      // ค่าปัจจุบัน 100% → พูด success บทเดียว ไม่พูด encouraging ที่ผ่านไปแล้ว
      expect(engine.spoken, [docStepsSuccess]);
      voice.dispose();
    });
  });
}
