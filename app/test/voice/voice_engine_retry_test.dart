// เทสต์พื้นฐานของ Dev รอบ 3 (BUG-VOICE-2) — DECIDED (owner 2026-11-12, V-11, V-12)
// V-11: engine ไม่พร้อม → ไม่บันทึกช่วงที่มีบทพูดว่า "พูดแล้ว" · ปิดเสียง → บันทึกตาม Q-08
// V-12: prepare() false → ลองใหม่เมื่อเข้า dashboard / resumed · true แล้วไม่เรียกซ้ำ
//       · พร้อมแล้วพูดบทที่ค้าง water → steps → food
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/dashboard/screens/dashboard_screen.dart';
import 'package:petpal_health/features/voice/voice_controller.dart';
import 'package:petpal_health/features/voice/voice_models.dart';
import 'package:petpal_health/features/voice/voice_repository.dart';
import 'package:petpal_health/features/voice/voice_rules.dart';

import '../dashboard/dashboard_test_helpers.dart' as dh;
import 'fake_voice_tts_engine.dart';

Future<void> flush() async {
  for (var i = 0; i < 10; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

/// prepare() ค้างจนกว่าเทสต์สั่ง [finishPrepare]
class GatedPrepareEngine extends FakeVoiceTtsEngine {
  final List<Completer<bool>> pending = [];

  @override
  Future<bool> prepare() {
    prepareCount++;
    final c = Completer<bool>();
    pending.add(c);
    return c.future;
  }

  void finishPrepare(bool value) {
    for (final c in pending) {
      if (!c.isCompleted) c.complete(value);
    }
  }
}

InMemoryVoiceRepository onRepo({bool master = true}) => InMemoryVoiceRepository(
    VoiceState(permissionStatus: VoicePermissionStatus.on, masterVoice: master));

void main() {
  DateTime clock() => DateTime(2026, 11, 12, 10);

  VoiceController make(FakeVoiceTtsEngine e, InMemoryVoiceRepository repo) =>
      VoiceController(repository: repo, engine: e, clock: clock);

  // water 2 → waterLow · steps 3,499/10,000 → stepsLazy · food ไม่เกิน → NONE
  final pendingInput = voiceInput(cups: 2, steps: 3499);

  group('V-11', () {
    test('DECIDED_V11_engine_unavailable_does_not_record_line_bands', () async {
      final e = FakeVoiceTtsEngine(available: false);
      final repo = onRepo();
      final c = make(e, repo);
      await c.load();
      c.evaluate(pendingInput);
      await flush();
      expect(e.spoken, isEmpty);
      expect(c.dayBands?.bands[VoiceTopic.water], isNull);
      expect(c.dayBands?.bands[VoiceTopic.steps], isNull);
      // ช่วงที่ไม่มีบทพูดยังบันทึก
      expect(c.dayBands?.bands[VoiceTopic.food], VoiceRules.noLineBandCode);
      expect(repo.state.dayBands?.bands.containsKey(VoiceTopic.water), isFalse);
      expect(repo.state.dayBands?.bands.containsKey(VoiceTopic.steps), isFalse);
      c.dispose();
    });

    test('DECIDED_V11_master_off_still_records_bands_without_prepare',
        () async {
      final e = FakeVoiceTtsEngine(available: false);
      final repo = onRepo(master: false);
      final c = make(e, repo);
      await c.load();
      c.evaluate(pendingInput);
      await flush();
      expect(e.prepareCount, 0);
      expect(repo.state.dayBands?.bands[VoiceTopic.water], 'voice_water_low');
      expect(repo.state.dayBands?.bands[VoiceTopic.steps], 'voice_steps_lazy');
      c.dispose();
    });

    test('DECIDED_V11_unrecorded_lines_survive_app_restart', () async {
      final repo = onRepo();
      final c1 = make(FakeVoiceTtsEngine(available: false), repo);
      await c1.load();
      c1.evaluate(pendingInput);
      await flush();
      c1.dispose();
      final e2 = FakeVoiceTtsEngine();
      final c2 = make(e2, repo);
      await c2.load();
      c2.evaluate(pendingInput);
      await flush();
      expect(e2.spoken, [VoiceRules.waterLowText, VoiceRules.stepsLazyText]);
      c2.dispose();
    });
  });

  group('V-12', () {
    test('DECIDED_V12_false_is_not_retried_without_retry_call', () async {
      final e = FakeVoiceTtsEngine(available: false);
      final c = make(e, onRepo());
      await c.load();
      c.evaluate(pendingInput);
      await flush();
      e.available = true;
      c.evaluate(pendingInput); // ค่าเปลี่ยน / Timer alert — ไม่ลองใหม่
      c.evaluate(pendingInput);
      await flush();
      expect(e.prepareCount, 1);
      expect(e.spoken, isEmpty);
      c.dispose();
    });

    test('DECIDED_V12_retry_after_engine_ready_speaks_pending_once_in_order',
        () async {
      final e = FakeVoiceTtsEngine(available: false);
      final repo = onRepo();
      final c = make(e, repo);
      await c.load();
      c.evaluate(voiceInput(cups: 2, steps: 3499, overLimit: true));
      await flush();
      e.available = true;
      c.retryEngineIfUnavailable();
      c.evaluate(voiceInput(cups: 2, steps: 3499, overLimit: true));
      await flush();
      expect(e.prepareCount, 2);
      expect(e.spoken, [
        VoiceRules.waterLowText,
        VoiceRules.stepsLazyText,
        VoiceRules.foodOvereatingText,
      ]);
      expect(repo.state.dayBands?.bands[VoiceTopic.water], 'voice_water_low');
      // ครั้งต่อไปไม่พูดซ้ำ
      c.retryEngineIfUnavailable();
      c.evaluate(voiceInput(cups: 2, steps: 3499, overLimit: true));
      await flush();
      expect(e.spoken.length, 3);
      c.dispose();
    });

    test('DECIDED_V12_prepare_true_is_never_called_again', () async {
      final e = FakeVoiceTtsEngine();
      final c = make(e, onRepo());
      await c.load();
      c.evaluate(voiceInput(cups: 2));
      await flush();
      c.retryEngineIfUnavailable();
      c.evaluate(voiceInput(cups: 8));
      c.retryEngineIfUnavailable();
      c.evaluate(voiceInput(cups: 5));
      await flush();
      expect(e.prepareCount, 1);
      expect(e.spoken, [VoiceRules.waterLowText, VoiceRules.waterSuccessText]);
      c.dispose();
    });

    test('DECIDED_V12_concurrent_evaluate_and_retry_share_one_prepare',
        () async {
      final e = GatedPrepareEngine();
      final c = make(e, onRepo());
      await c.load();
      c.evaluate(pendingInput);
      c.retryEngineIfUnavailable(); // กำลัง prepare → ไม่เรียกซ้อน
      c.evaluate(pendingInput);
      c.evaluate(pendingInput);
      await flush();
      expect(e.prepareCount, 1);
      e.finishPrepare(true);
      await flush();
      expect(e.spoken, [VoiceRules.waterLowText, VoiceRules.stepsLazyText]);
      expect(e.maxActive, 1);
      c.dispose();
    });

    test('DECIDED_V12_stop_during_prepare_does_not_speak_and_keeps_pending',
        () async {
      final e = GatedPrepareEngine();
      final repo = onRepo();
      final c = make(e, repo);
      await c.load();
      c.evaluate(pendingInput);
      await flush();
      await c.stopAndClear(); // ออกจาก dashboard / paused ระหว่าง prepare
      e.finishPrepare(true);
      await flush();
      expect(e.spoken, isEmpty);
      expect(repo.state.dayBands?.bands.containsKey(VoiceTopic.water), isFalse);
      // เข้า dashboard ใหม่ → พูดบทที่ค้าง (prepare true จำไว้แล้ว ไม่เรียกซ้ำ)
      c.retryEngineIfUnavailable();
      c.evaluate(pendingInput);
      await flush();
      expect(e.prepareCount, 1);
      expect(e.spoken, [VoiceRules.waterLowText, VoiceRules.stepsLazyText]);
      c.dispose();
    });

    test('DECIDED_V12_master_off_during_prepare_does_not_speak', () async {
      final e = GatedPrepareEngine();
      final c = VoiceController(
        repository: onRepo(),
        engine: e,
        clock: clock,
        timerFactory: dh.FakeTimers().create,
      );
      await c.load();
      c.evaluate(pendingInput);
      await flush();
      c.setMasterVoice(false);
      e.finishPrepare(true);
      await flush();
      expect(e.spoken, isEmpty);
      expect(c.currentLine, isNull);
      c.dispose();
    });

    test('DECIDED_V12_dispose_during_prepare_is_safe', () async {
      final e = GatedPrepareEngine();
      final c = make(e, onRepo());
      await c.load();
      c.evaluate(pendingInput);
      await flush();
      c.dispose();
      e.finishPrepare(true);
      await flush();
      expect(e.spoken, isEmpty);
    });
  });

  group('V-12 dashboard', () {
    Future<dh.Sources> sources() async {
      final s = dh.makeSources(
        clock: () => dh.t(14, 10),
        water: dh.water14(2),
        steps: dh.steps14(3499, goal: 10000),
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

    Future<void> frames(WidgetTester tester, [int n = 6]) async {
      for (var i = 0; i < n; i++) {
        await tester.pump();
      }
    }

    testWidgets('DECIDED_V12_resumed_on_dashboard_retries_and_speaks_once',
        (tester) async {
      final s = await sources();
      final engine = FakeVoiceTtsEngine(available: false);
      final repo = onRepo();
      final voice = VoiceController(
          repository: repo, engine: engine, clock: () => dh.t(14, 10));
      await tester.pumpWidget(dashboard(s, voice));
      await frames(tester);
      expect(engine.spoken, isEmpty);
      expect(find.byKey(const Key('voice_speech_bubble')), findsNothing);
      expect(repo.state.dayBands?.bands.containsKey(VoiceTopic.water), isFalse);

      // ผู้ใช้ลงเสียงไทยระหว่างแอปเปิด → กลับเข้าแอป
      engine.available = true;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await frames(tester);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await frames(tester);
      expect(engine.spoken, [VoiceRules.waterLowText, VoiceRules.stepsLazyText]);
      expect(engine.prepareCount, 2);

      // resumed อีกครั้ง → ไม่พูดซ้ำ ไม่ prepare ซ้ำ
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await frames(tester);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await frames(tester);
      expect(engine.spoken.length, 2);
      expect(engine.prepareCount, 2);

      await tester.pumpWidget(const SizedBox());
      await frames(tester, 2);
    });

    testWidgets('DECIDED_V12_reenter_dashboard_retries_and_speaks_once',
        (tester) async {
      final s = await sources();
      final engine = FakeVoiceTtsEngine(available: false);
      final voice = VoiceController(
          repository: onRepo(), engine: engine, clock: () => dh.t(14, 10));
      await tester.pumpWidget(dashboard(s, voice));
      await frames(tester);
      expect(engine.spoken, isEmpty);
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await frames(tester);

      engine.available = true;
      await tester.pumpWidget(dashboard(s, voice));
      await frames(tester);
      expect(engine.spoken, [VoiceRules.waterLowText, VoiceRules.stepsLazyText]);

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await frames(tester);
      await tester.pumpWidget(dashboard(s, voice));
      await frames(tester);
      expect(engine.spoken.length, 2);
      expect(engine.prepareCount, 2);

      await tester.pumpWidget(const SizedBox());
      await frames(tester, 2);
    });
  });
}
