// QA (รอบ 1) — unit test ของ logic + controller ฟีเจอร์ voice
// ค่าคาดหวังทั้งหมดพิมพ์จากเอกสาร (game-rules §1, §1.1, §3 · ux-flow §2 · ui-spec §2.4 / §2.5 / §7)
// และข้อตัดสิน owner V-1..V-10 (logs/20261112-1043_owner_voice.md) — ไม่ได้อ่านค่าจาก VoiceRules
// เทสต์ที่อิงข้อตัดสินมี DECIDED_ ในชื่อ · เวลา: clock ที่ส่งเข้า (ไม่มี sleep / เวลาจริง)
// TTS: FakeVoiceTtsEngine เท่านั้น (ห้ามสร้าง FlutterTtsVoiceEngine)

import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/voice/voice_controller.dart';
import 'package:petpal_health/features/voice/voice_logic.dart';
import 'package:petpal_health/features/voice/voice_models.dart';
import 'package:petpal_health/features/voice/voice_repository.dart';
import 'package:petpal_health/features/voice/voice_tts_engine.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../food/food_test_helpers.dart' show FakeTimers;
import 'fake_voice_tts_engine.dart';
import 'voice_qa_docs.dart';

DateTime t(int day, int h, [int m = 0]) => DateTime(2026, 11, day, h, m);

Future<void> flush() async {
  for (var i = 0; i < 20; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

/// บทที่พูดครั้งแรกของวัน (previous = null) — id ของทุกเรื่อง
List<String> firstIds({
  int cups = 5,
  int steps = 5000,
  int goal = docGoal,
  bool over = false,
}) =>
    VoiceLogic.evaluate(
      input: voiceInput(cups: cups, steps: steps, goal: goal, overLimit: over),
      previous: null,
      now: t(12, 10),
    ).lines.map((l) => l.id).toList();

void main() {
  // =========================================================================
  // game-rules §3 ทุกแถวตัวเลข (ค่าเกณฑ์พอดี + เกิน 1 หน่วย)
  // =========================================================================
  group('game-rules §3 steps % (goal 10,000 → 1 ก้าว = 0.01%)', () {
    final cases = <(String, int, List<String>)>[
      ('34.99% → lazy (AC-2)', 3499, [idStepsLazy]),
      ('35.00% → no trigger', 3500, []),
      ('69.99% → no trigger', 6999, []),
      ('70.00% → encouraging (AC-3)', 7000, [idStepsEncouraging]),
      ('99.00% → encouraging (AC-3)', 9900, [idStepsEncouraging]),
      ('99.99% → encouraging (AC-3, Q-30)', 9999, [idStepsEncouraging]),
      ('100.00% → success (AC-4)', 10000, [idStepsSuccess]),
      ('125.00% → success (AC-4 overachievement)', 12500, [idStepsSuccess]),
    ];
    for (final (name, steps, expected) in cases) {
      test('GR3_steps_$name', () {
        // water 5 / food ไม่เกิน = ช่วงไม่มีบท → เหลือเฉพาะ steps
        expect(firstIds(steps: steps), expected);
      });
    }

    test('GR2_steps_0.00%_is_lazy (ช่วง >= 0.00% ถึง < 35.00%)', () {
      expect(firstIds(steps: 0), [idStepsLazy]);
    });

    test('GR3_steps_non_round_goal_8000_boundaries', () {
      // 35% ของ 8,000 = 2,800 · 70% = 5,600 · 100% = 8,000
      expect(firstIds(steps: 2799, goal: 8000), [idStepsLazy]); // 34.99%
      expect(firstIds(steps: 2800, goal: 8000), isEmpty); // 35.00%
      expect(firstIds(steps: 5599, goal: 8000), isEmpty); // 69.99%
      expect(firstIds(steps: 5600, goal: 8000), [idStepsEncouraging]);
      expect(firstIds(steps: 7999, goal: 8000), [idStepsEncouraging]);
      expect(firstIds(steps: 8000, goal: 8000), [idStepsSuccess]);
    });

    test('GR3_steps_fractional_percent_goal_3333', () {
      // 1,166 / 3,333 = 34.98% → lazy · 1,167 = 35.01% → ไม่มี
      expect(firstIds(steps: 1166, goal: 3333), [idStepsLazy]);
      expect(firstIds(steps: 1167, goal: 3333), isEmpty);
      // 2,333 = 69.997% → ไม่มี · 2,334 = 70.03% → encouraging
      expect(firstIds(steps: 2333, goal: 3333), isEmpty);
      expect(firstIds(steps: 2334, goal: 3333), [idStepsEncouraging]);
      // 3,332 = 99.97% → encouraging · 3,333 = 100% → success
      expect(firstIds(steps: 3332, goal: 3333), [idStepsEncouraging]);
      expect(firstIds(steps: 3333, goal: 3333), [idStepsSuccess]);
    });

    test('MAXMIN_steps_far_above_goal_still_success (ไม่ล้น)', () {
      expect(firstIds(steps: 1000000), [idStepsSuccess]);
    });

    test('DECIDED_V10_Q20_goal_zero_or_negative_steps_treated_as_0pct_lazy', () {
      expect(firstIds(steps: 5000, goal: 0), [idStepsLazy]);
      expect(firstIds(steps: -10), [idStepsLazy]);
    });
  });

  group('game-rules §3 food (> 100.00 kcal ไม่รวมขอบ)', () {
    // logic รับ isFoodOverLimit (Q-19) — ขอบ 100 vs 101 kcal ทดสอบกับ FoodController จริงใน
    // voice_qa_screens_test (AC5_*)
    test('GR3_food_not_over_limit_no_trigger', () {
      expect(firstIds(over: false), isEmpty);
    });
    test('GR3_food_over_limit_overeating (AC-5)', () {
      expect(firstIds(over: true), [idFoodOvereating]);
    });
  });

  group('game-rules §3 water (แก้ว)', () {
    final cases = <(int, List<String>)>[
      (0, [idWaterLow]),
      (2, [idWaterLow]),
      (3, []),
      (7, []),
      (8, [idWaterSuccess]),
      (12, [idWaterSuccess]),
    ];
    for (final (cups, expected) in cases) {
      test('GR3_water_${cups}_cups', () {
        expect(firstIds(cups: cups), expected);
      });
    }
    test('DECIDED_V10_Q20_negative_water_is_low', () {
      expect(firstIds(cups: -1), [idWaterLow]);
    });
  });

  group('VoiceLine ids / texts = game-rules §1.1 (V-6)', () {
    test('DECIDED_V6_six_lines_ids_without_mp3_and_exact_texts', () {
      final byId = {for (final l in VoiceLine.values) l.id: l.text};
      expect(byId, {
        idStepsLazy: docStepsLazy,
        idStepsEncouraging: docStepsEncouraging,
        idStepsSuccess: docStepsSuccess,
        idFoodOvereating: docFoodOvereating,
        idWaterLow: docWaterLow,
        idWaterSuccess: docWaterSuccess,
      });
      for (final l in VoiceLine.values) {
        expect(l.id.endsWith('.mp3'), isFalse);
        expect(l.text.startsWith('"'), isFalse);
      }
    });
  });

  // =========================================================================
  // V-4 จังหวะพูด + รอบวัน / ข้ามวัน
  // =========================================================================
  group('V-4 band change + day reset (05:00)', () {
    VoiceEvaluation ev(int cups, VoiceDayBands? prev, DateTime now) =>
        VoiceLogic.evaluate(
            input: voiceInput(cups: cups), previous: prev, now: now);

    test('DECIDED_V4_same_band_twice_no_repeat', () {
      final a = ev(2, null, t(12, 10));
      expect(a.lines.map((l) => l.id), [idWaterLow]);
      final b = ev(2, a.bands, t(12, 10, 5));
      expect(b.lines, isEmpty);
    });

    test('DECIDED_V4_none_band_counts_low_none_low_speaks_again', () {
      final a = ev(2, null, t(12, 10));
      final b = ev(3, a.bands, t(12, 11));
      expect(b.lines, isEmpty);
      expect(b.bands.bands[VoiceTopic.water], docNoneBand);
      final c = ev(2, b.bands, t(12, 12));
      expect(c.lines.map((l) => l.id), [idWaterLow]);
    });

    test('DECIDED_V4_low_to_success_speaks_success', () {
      final a = ev(2, null, t(12, 10));
      final b = ev(8, a.bands, t(12, 11));
      expect(b.lines.map((l) => l.id), [idWaterSuccess]);
    });

    test('DAY_midnight_is_not_a_new_day (23:59 → 00:01 same logical day)', () {
      final a = ev(2, null, t(12, 23, 59));
      final b = ev(2, a.bands, t(13, 0, 1));
      expect(b.lines, isEmpty, reason: 'รอบวัน 05:00 (A-3) ไม่ใช่เที่ยงคืน');
    });

    test('DAY_04:59_same_day_05:00_new_day_speaks_again', () {
      final a = ev(2, null, t(12, 10));
      final b = ev(2, a.bands, t(13, 4, 59));
      expect(b.lines, isEmpty);
      final c = ev(2, b.bands, t(13, 5, 0));
      expect(c.lines.map((l) => l.id), [idWaterLow]);
      expect(c.bands.day, DateTime(2026, 11, 13));
    });

    test('DAY_new_day_in_none_band_no_speak_but_band_recorded', () {
      final a = ev(2, null, t(12, 10));
      final b = ev(5, a.bands, t(13, 6));
      expect(b.lines, isEmpty);
      expect(b.bands.bands[VoiceTopic.water], docNoneBand);
    });

    test('DAY_bands_older_than_one_day (2 days later) start over', () {
      final a = ev(8, null, t(12, 10));
      final b = ev(8, a.bands, t(14, 10));
      expect(b.lines.map((l) => l.id), [idWaterSuccess]);
    });
  });

  // =========================================================================
  // Controller
  // =========================================================================
  group('VoiceController', () {
    late DateTime now;
    setUp(() => now = t(12, 10));

    VoiceController make(
      VoiceTtsEngine engine, {
      VoiceRepository? repo,
      bool master = true,
      FakeTimers? timers,
    }) =>
        VoiceController(
          repository: repo ??
              InMemoryVoiceRepository(VoiceState(
                  permissionStatus: master
                      ? VoicePermissionStatus.on
                      : VoicePermissionStatus.off,
                  masterVoice: master)),
          engine: engine,
          clock: () => now,
          timerFactory: (timers ?? FakeTimers()).create,
        );

    // ---- AC-2..AC-7: engine.speak ได้ข้อความตรงตัว ----
    final acCases = <(String, int, int, bool, String)>[
      ('AC2_steps_34.99pct_speaks_lazy_exact', 5, 3499, false, docStepsLazy),
      ('AC3_steps_70pct_speaks_encouraging_exact', 5, 7000, false,
          docStepsEncouraging),
      ('AC3_steps_99.99pct_speaks_encouraging_exact', 5, 9999, false,
          docStepsEncouraging),
      ('AC4_steps_100pct_speaks_success_exact', 5, 10000, false,
          docStepsSuccess),
      ('AC5_food_over_speaks_overeating_exact', 5, 5000, true,
          docFoodOvereating),
      ('AC6_water_2_speaks_low_exact', 2, 5000, false, docWaterLow),
      ('AC7_water_8_speaks_success_exact', 8, 5000, false, docWaterSuccess),
    ];
    for (final (name, cups, steps, over, text) in acCases) {
      test(name, () async {
        final e = FakeVoiceTtsEngine();
        final c = make(e);
        await c.load();
        c.evaluate(voiceInput(cups: cups, steps: steps, overLimit: over));
        await flush();
        expect(e.spoken, [text]);
        expect(c.currentLine, isNull, reason: 'พูดจบ → ฟองหาย');
        c.dispose();
      });
    }

    test('AC2_7_master_off_never_speaks_any_line', () async {
      final e = FakeVoiceTtsEngine();
      final c = make(e, master: false);
      await c.load();
      c.evaluate(voiceInput(cups: 2, steps: 3499, overLimit: true));
      await flush();
      expect(e.spoken, isEmpty);
      expect(e.prepareCount, 0);
      c.dispose();
    });

    test('evaluate_before_load_does_nothing', () async {
      final e = FakeVoiceTtsEngine();
      final c = make(e);
      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e.spoken, isEmpty);
      expect(c.dayBands, isNull);
      c.dispose();
    });

    // ---- EC-2 คิว FIFO ----
    test('EC2_GR3_last_row_water8_steps100_fifo_water_then_steps_no_overlap',
        () async {
      final e = FakeVoiceTtsEngine(autoComplete: false);
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 8, steps: 10000));
      await flush();
      expect(e.spoken, [docWaterSuccess], reason: 'บทที่ 2 ยังไม่เริ่ม');
      expect(c.queue.map((l) => l.id), [idStepsSuccess]);
      e.completeCurrent();
      await flush(); // Cooldown 0 ms: ไม่มีการเลื่อนเวลา บทถัดไปเริ่มทันที
      expect(e.spoken, [docWaterSuccess, docStepsSuccess]);
      expect(c.currentLine?.id, idStepsSuccess);
      e.completeCurrent();
      await flush();
      expect(c.currentLine, isNull);
      expect(c.queue, isEmpty);
      expect(e.maxActive, 1, reason: 'No Audio Overlap');
      c.dispose();
    });

    test('EC2_DECIDED_V10_Q10_three_topics_order_water_steps_food', () async {
      final e = FakeVoiceTtsEngine(autoComplete: false);
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 2, steps: 3499, overLimit: true));
      await flush();
      for (var i = 0; i < 3; i++) {
        e.completeCurrent();
        await flush();
      }
      expect(e.spoken, [docWaterLow, docStepsLazy, docFoodOvereating]);
      expect(e.maxActive, 1);
      c.dispose();
    });

    test('EC2_fifo_across_separate_evaluations (detection order)', () async {
      final e = FakeVoiceTtsEngine(autoComplete: false);
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 2)); // 1) waterLow
      await flush();
      c.evaluate(voiceInput(cups: 2, steps: 10000)); // 2) stepsSuccess
      c.evaluate(voiceInput(cups: 8, steps: 10000)); // 3) waterSuccess
      await flush();
      expect(c.currentLine?.id, idWaterLow);
      expect(c.queue.map((l) => l.id), [idStepsSuccess, idWaterSuccess]);
      for (var i = 0; i < 3; i++) {
        e.completeCurrent();
        await flush();
      }
      expect(e.spoken, [docWaterLow, docStepsSuccess, docWaterSuccess]);
      expect(e.maxActive, 1);
      c.dispose();
    });

    test('MAXMIN_repeat_evaluate_same_input_does_not_grow_queue', () async {
      final e = FakeVoiceTtsEngine(autoComplete: false);
      final c = make(e);
      await c.load();
      for (var i = 0; i < 5; i++) {
        c.evaluate(voiceInput(cups: 8, steps: 10000));
      }
      await flush();
      expect(c.queue.length, 1, reason: 'ช่วงเดิมไม่เข้าคิวซ้ำ');
      e.completeCurrent();
      await flush();
      e.completeCurrent();
      await flush();
      expect(e.spoken.length, 2);
      c.dispose();
    });

    // ---- ล้างคิวเมื่อปิดเสียง (game-rules §1.1) ----
    test('GR11_master_off_while_speaking_stops_and_clears_queue', () async {
      final e = FakeVoiceTtsEngine(autoComplete: false);
      final timers = FakeTimers();
      final c = make(e, timers: timers);
      await c.load();
      c.evaluate(voiceInput(cups: 2, steps: 3499, overLimit: true));
      await flush();
      expect(c.queue.length, 2);
      final stopsBefore = e.stopCount;
      c.setMasterVoice(false);
      // ทันที — ไม่ต้องรอ debounce 300 ms
      expect(c.queue, isEmpty);
      expect(c.currentLine, isNull);
      await flush();
      expect(e.stopCount, greaterThan(stopsBefore));
      e.completeCurrent();
      await flush();
      expect(e.spoken, [docWaterLow], reason: 'บทที่ 2, 3 ไม่ถูกพูด');
      c.dispose();
    });

    test('GR11_cleared_lines_not_replayed_after_turning_back_on', () async {
      final e = FakeVoiceTtsEngine(autoComplete: false);
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 2, steps: 3499));
      await flush();
      c.setMasterVoice(false);
      await flush();
      c.setMasterVoice(true);
      c.evaluate(voiceInput(cups: 2, steps: 3499));
      await flush();
      expect(e.spoken, [docWaterLow]);
      expect(c.currentLine, isNull);
      c.dispose();
    });

    test('GR11_after_clear_queue_works_again_for_new_band', () async {
      final e = FakeVoiceTtsEngine(autoComplete: false);
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 2));
      await flush();
      c.setMasterVoice(false);
      await flush();
      c.setMasterVoice(true);
      c.evaluate(voiceInput(cups: 8)); // ช่วงใหม่
      await flush();
      expect(c.currentLine?.id, idWaterSuccess);
      expect(e.spoken, [docWaterLow, docWaterSuccess]);
      e.completeCurrent();
      await flush();
      expect(c.currentLine, isNull);
      expect(e.maxActive, 1);
      c.dispose();
    });

    test('DECIDED_V10_Q08_bands_recorded_while_off_no_backfill_on_enable',
        () async {
      final repo = InMemoryVoiceRepository(const VoiceState(
          permissionStatus: VoicePermissionStatus.off, masterVoice: false));
      final e = FakeVoiceTtsEngine();
      final c = make(e, repo: repo);
      await c.load();
      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(repo.state.dayBands?.bands[VoiceTopic.water], idWaterLow);
      c.setMasterVoice(true);
      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e.spoken, isEmpty);
      c.dispose();
    });

    // ---- EC-5 debounce 300 ms ----
    test('EC5_single_toggle_saves_at_exactly_300ms_not_299', () async {
      final timers = FakeTimers();
      final repo = InMemoryVoiceRepository(const VoiceState(
          permissionStatus: VoicePermissionStatus.on, masterVoice: true));
      final c = make(FakeVoiceTtsEngine(), repo: repo, timers: timers);
      await c.load();
      c.setMasterVoice(false);
      expect(c.masterVoice, isFalse, reason: 'สวิตช์ขยับทันที (Q-14)');
      timers.advance(const Duration(milliseconds: 299));
      await flush();
      expect(repo.saveMasterVoiceCount, 0);
      timers.advance(const Duration(milliseconds: 1));
      await flush();
      expect(repo.savedMasterVoiceValues, [false]);
      expect(repo.state.masterVoice, isFalse);
      c.dispose();
    });

    test('EC5_each_tap_restarts_300ms_window', () async {
      final timers = FakeTimers();
      final repo = InMemoryVoiceRepository(const VoiceState(
          permissionStatus: VoicePermissionStatus.on, masterVoice: true));
      final c = make(FakeVoiceTtsEngine(), repo: repo, timers: timers);
      await c.load();
      c.setMasterVoice(false); // 0 ms
      timers.advance(const Duration(milliseconds: 200));
      c.setMasterVoice(true); // 200 ms
      timers.advance(const Duration(milliseconds: 200));
      c.setMasterVoice(false); // 400 ms
      timers.advance(const Duration(milliseconds: 299)); // 699 ms
      await flush();
      expect(repo.saveMasterVoiceCount, 0);
      timers.advance(const Duration(milliseconds: 1)); // 700 ms
      await flush();
      expect(repo.savedMasterVoiceValues, [false]);
      c.dispose();
    });

    test('EC5_VT15_four_taps_end_same_value_zero_saves', () async {
      final timers = FakeTimers();
      final repo = InMemoryVoiceRepository(const VoiceState(
          permissionStatus: VoicePermissionStatus.on, masterVoice: true));
      final c = make(FakeVoiceTtsEngine(), repo: repo, timers: timers);
      await c.load();
      final seen = <bool>[];
      c.addListener(() => seen.add(c.masterVoice));
      for (var i = 0; i < 4; i++) {
        c.setMasterVoice(!c.masterVoice);
        timers.advance(const Duration(milliseconds: 25));
      }
      expect(seen, [false, true, false, true], reason: 'สวิตช์เปลี่ยนทุกครั้ง');
      timers.advance(docDebounce);
      await flush();
      expect(repo.saveMasterVoiceCount, 0);
      c.dispose();
    });

    test('EC5_taps_spaced_over_300ms_each_saved', () async {
      final timers = FakeTimers();
      final repo = InMemoryVoiceRepository(const VoiceState(
          permissionStatus: VoicePermissionStatus.on, masterVoice: true));
      final c = make(FakeVoiceTtsEngine(), repo: repo, timers: timers);
      await c.load();
      c.setMasterVoice(false);
      timers.advance(docDebounce);
      await flush();
      c.setMasterVoice(true);
      timers.advance(docDebounce);
      await flush();
      expect(repo.savedMasterVoiceValues, [false, true]);
      c.dispose();
    });

    test('MAXMIN_set_same_value_repeatedly_no_save_no_notify', () async {
      final timers = FakeTimers();
      final repo = InMemoryVoiceRepository(const VoiceState(
          permissionStatus: VoicePermissionStatus.on, masterVoice: true));
      final c = make(FakeVoiceTtsEngine(), repo: repo, timers: timers);
      await c.load();
      var notified = 0;
      c.addListener(() => notified++);
      for (var i = 0; i < 5; i++) {
        c.setMasterVoice(true);
      }
      timers.advance(docDebounce);
      await flush();
      expect(notified, 0);
      expect(repo.saveMasterVoiceCount, 0);
      c.dispose();
    });

    test('EC5_dispose_during_debounce_flushes_last_value', () async {
      final timers = FakeTimers();
      final repo = InMemoryVoiceRepository(const VoiceState(
          permissionStatus: VoicePermissionStatus.on, masterVoice: true));
      final c = make(FakeVoiceTtsEngine(), repo: repo, timers: timers);
      await c.load();
      c.setMasterVoice(false);
      timers.advance(const Duration(milliseconds: 100));
      c.dispose();
      await flush();
      expect(repo.savedMasterVoiceValues, [false]);
    });

    test('EC5_flushPendingSave_saves_immediately_once', () async {
      final timers = FakeTimers();
      final repo = InMemoryVoiceRepository(const VoiceState(
          permissionStatus: VoicePermissionStatus.on, masterVoice: true));
      final c = make(FakeVoiceTtsEngine(), repo: repo, timers: timers);
      await c.load();
      c.setMasterVoice(false);
      await c.flushPendingSave();
      expect(repo.savedMasterVoiceValues, [false]);
      timers.advance(docDebounce);
      await flush();
      expect(repo.saveMasterVoiceCount, 1, reason: 'ไม่บันทึกซ้ำหลัง flush');
      c.dispose();
    });

    // ---- EC-3 (V-6a) ไม่มีเสียงไทย / TTS error → ข้ามเงียบ ----
    test('EC3_DECIDED_V6a_no_thai_voice_silent_skip_no_bubble_ever', () async {
      final e = FakeVoiceTtsEngine(available: false);
      final c = make(e);
      await c.load();
      final lines = <VoiceLine?>[];
      c.addListener(() => lines.add(c.currentLine));
      c.evaluate(voiceInput(cups: 2, steps: 10000));
      await flush();
      expect(e.spoken, isEmpty);
      expect(lines.whereType<VoiceLine>(), isEmpty, reason: 'ไม่มีฟอง (Q-11)');
      expect(c.queue, isEmpty);
      expect(c.dayBands?.bands[VoiceTopic.water], idWaterLow);
      c.dispose();
    });

    test('EC3_DECIDED_V6a_prepare_throws_silent_skip', () async {
      final e = _PrepareThrowsEngine();
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e.spoken, isEmpty);
      expect(c.currentLine, isNull);
      c.dispose();
    });

    test('EC3_prepare_called_once_per_controller', () async {
      final e = FakeVoiceTtsEngine();
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 2));
      await flush();
      c.evaluate(voiceInput(cups: 8));
      await flush();
      expect(e.prepareCount, 1);
      expect(e.spoken, [docWaterLow, docWaterSuccess]);
      c.dispose();
    });

    test('EC3_DECIDED_V6a_speak_error_on_first_skips_to_next', () async {
      final e = _ThrowFirstSpeakEngine();
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 8, steps: 10000));
      await flush();
      expect(e.spoken, [docWaterSuccess, docStepsSuccess]);
      expect(c.currentLine, isNull);
      expect(c.queue, isEmpty);
      c.dispose();
    });

    test('EC3_stop_throws_does_not_crash_on_master_off', () async {
      final e = _StopThrowsEngine(autoComplete: false);
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 2, steps: 10000));
      await flush();
      c.setMasterVoice(false);
      await flush();
      expect(c.currentLine, isNull);
      expect(c.queue, isEmpty);
      c.dispose();
    });

    test('EC1_mute_speak_completes_silently_no_crash_normal_flow', () async {
      // Q-22: แอปตรวจ Mute ไม่ได้ — engine ทำงานตามปกติ (fake จบทันทีโดยไม่มีเสียงจริง)
      final e = FakeVoiceTtsEngine();
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 2, steps: 3499, overLimit: true));
      await flush();
      expect(e.spoken, [docWaterLow, docStepsLazy, docFoodOvereating]);
      expect(c.currentLine, isNull);
      c.dispose();
    });

    // ---- ข้ามวันผ่าน controller (clock ที่เลื่อนได้) ----
    test('DAY_controller_speaks_same_band_again_after_05:00', () async {
      final e = FakeVoiceTtsEngine();
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 2));
      await flush();
      now = t(13, 4, 59);
      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e.spoken, [docWaterLow]);
      now = t(13, 5, 0);
      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e.spoken, [docWaterLow, docWaterLow]);
      c.dispose();
    });

    test('DAY_stored_bands_from_yesterday_do_not_block_today', () async {
      final repo = InMemoryVoiceRepository(VoiceState(
        permissionStatus: VoicePermissionStatus.on,
        masterVoice: true,
        dayBands: VoiceDayBands(
            day: DateTime(2026, 11, 11), bands: {VoiceTopic.water: idWaterLow}),
      ));
      final e = FakeVoiceTtsEngine();
      final c = make(e, repo: repo);
      await c.load();
      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e.spoken, [docWaterLow]);
      c.dispose();
    });

    test('DECIDED_V4_restart_same_day_no_repeat (VT-7, voice_day_bands)',
        () async {
      final repo = InMemoryVoiceRepository(const VoiceState(
          permissionStatus: VoicePermissionStatus.on, masterVoice: true));
      final e1 = FakeVoiceTtsEngine();
      final c1 = make(e1, repo: repo);
      await c1.load();
      c1.evaluate(voiceInput(cups: 8, steps: 10000));
      await flush();
      c1.dispose();
      now = t(12, 22);
      final e2 = FakeVoiceTtsEngine();
      final c2 = make(e2, repo: repo);
      await c2.load();
      c2.evaluate(voiceInput(cups: 8, steps: 10000));
      await flush();
      expect(e2.spoken, isEmpty);
      c2.dispose();
    });

    test('DECIDED_V4_restart_same_day_shared_prefs_no_repeat_next_day_repeats',
        () async {
      SharedPreferences.setMockInitialValues(
          {keyPermission: true, keyMaster: true});
      Future<List<String>> session(DateTime at, int cups) async {
        now = at;
        final e = FakeVoiceTtsEngine();
        final c = make(e, repo: SharedPrefsVoiceRepository());
        await c.load();
        c.evaluate(voiceInput(cups: cups));
        await flush();
        c.dispose();
        return e.spoken;
      }

      expect(await session(t(12, 10), 2), [docWaterLow]);
      expect(await session(t(12, 23, 59), 2), isEmpty, reason: 'วันเดียวกัน');
      expect(await session(t(13, 4, 59), 2), isEmpty, reason: 'ยังไม่ถึง 05:00');
      expect(await session(t(13, 5, 0), 2), [docWaterLow], reason: 'รอบวันใหม่');
    });

    // ---- ข้อมูลว่าง / เปิดครั้งแรก / ข้อมูลเสีย ----
    test('EMPTY_first_launch_defaults_unanswered_master_off', () async {
      final c = make(FakeVoiceTtsEngine(), repo: InMemoryVoiceRepository());
      await c.load();
      expect(c.isLoaded, isTrue);
      expect(c.permissionStatus, VoicePermissionStatus.unanswered);
      expect(c.masterVoice, isFalse);
      expect(c.dayBands, isNull);
      c.dispose();
    });

    test('EMPTY_load_twice_reads_repository_once', () async {
      final repo = _CountingRepo();
      final c = make(FakeVoiceTtsEngine(), repo: repo);
      await Future.wait([c.load(), c.load()]);
      await c.load();
      expect(repo.loadCount, 1);
      c.dispose();
    });

    test('GR3_row1_answer_enable_sets_true_true', () async {
      final repo = InMemoryVoiceRepository();
      final e = FakeVoiceTtsEngine();
      final c = make(e, repo: repo);
      await c.load();
      await c.answerPermission(enabled: true);
      expect(c.permissionStatus, VoicePermissionStatus.on);
      expect(c.masterVoice, isTrue);
      expect(repo.state.permissionStatus, VoicePermissionStatus.on);
      expect(repo.state.masterVoice, isTrue);
      expect(e.spoken, isEmpty, reason: 'V-4 ไม่พูดหลังกด');
      c.dispose();
    });

    test('GR3_row2_answer_disable_sets_false_false', () async {
      final repo = InMemoryVoiceRepository();
      final c = make(FakeVoiceTtsEngine(), repo: repo);
      await c.load();
      await c.answerPermission(enabled: false);
      expect(c.permissionStatus, VoicePermissionStatus.off);
      expect(c.masterVoice, isFalse);
      expect(repo.state.permissionStatus, VoicePermissionStatus.off);
      expect(repo.state.masterVoice, isFalse);
      c.dispose();
    });

    test('DECIDED_V10_Q16_answer_save_fails_keeps_memory_no_throw', () async {
      final repo = _SavePermissionThrowsRepo();
      final c = make(FakeVoiceTtsEngine(), repo: repo);
      await c.load();
      await c.answerPermission(enabled: true);
      expect(c.permissionStatus, VoicePermissionStatus.on);
      expect(c.masterVoice, isTrue);
      c.dispose();
    });
  });

  // =========================================================================
  // SharedPrefsVoiceRepository (ui-spec §2.5) — ข้อมูลว่าง / เสีย / ชนิดผิด
  // =========================================================================
  group('SharedPrefsVoiceRepository', () {
    test('EMPTY_no_keys_unanswered_false_null', () async {
      SharedPreferences.setMockInitialValues({});
      final s = await SharedPrefsVoiceRepository().load();
      expect(s.permissionStatus, VoicePermissionStatus.unanswered);
      expect(s.masterVoice, isFalse);
      expect(s.dayBands, isNull);
    });

    test('CORRUPT_wrong_types_treated_as_missing', () async {
      SharedPreferences.setMockInitialValues({
        keyPermission: 'yes',
        keyMaster: 1,
        keyDayBands: '{not json',
      });
      final s = await SharedPrefsVoiceRepository().load();
      expect(s.permissionStatus, VoicePermissionStatus.unanswered);
      expect(s.masterVoice, isFalse);
      expect(s.dayBands, isNull);
    });

    test('CORRUPT_day_bands_bad_day_or_not_object_is_null', () async {
      for (final raw in ['[]', '{"day":5}', '{"day":"not-a-date"}', '""']) {
        SharedPreferences.setMockInitialValues({keyDayBands: raw});
        final s = await SharedPrefsVoiceRepository().load();
        expect(s.dayBands, isNull, reason: raw);
      }
    });

    test('CORRUPT_day_bands_corrupt_then_controller_still_speaks', () async {
      SharedPreferences.setMockInitialValues({
        keyPermission: true,
        keyMaster: true,
        keyDayBands: 'garbage',
      });
      final e = FakeVoiceTtsEngine();
      final c = VoiceController(
          repository: SharedPrefsVoiceRepository(),
          engine: e,
          clock: () => t(12, 10),
          timerFactory: FakeTimers().create);
      await c.load();
      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e.spoken, [docWaterLow]);
      c.dispose();
    });

    test('AC1_saves_bool_keys_and_round_trips', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = SharedPrefsVoiceRepository();
      await repo.savePermission(enabled: true);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.get(keyPermission), true);
      expect(prefs.get(keyMaster), true);
      await repo.saveMasterVoice(false);
      expect(prefs.get(keyMaster), false);
      expect(prefs.get(keyPermission), true,
          reason: 'สวิตช์ S-3 ไม่แก้คำตอบ S-1');
      final s = await SharedPrefsVoiceRepository().load();
      expect(s.permissionStatus, VoicePermissionStatus.on);
      expect(s.masterVoice, isFalse);
    });

    test('AC1_disable_saves_false_false', () async {
      SharedPreferences.setMockInitialValues({});
      await SharedPrefsVoiceRepository().savePermission(enabled: false);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.get(keyPermission), false);
      expect(prefs.get(keyMaster), false);
    });

    test('DECIDED_V3_V6b_only_voice_keys_written_no_shortcut_or_path_key',
        () async {
      SharedPreferences.setMockInitialValues({});
      final repo = SharedPrefsVoiceRepository();
      await repo.savePermission(enabled: true);
      await repo.saveMasterVoice(false);
      await repo.saveDayBands(VoiceDayBands(
          day: DateTime(2026, 11, 12),
          bands: {VoiceTopic.water: idWaterLow, VoiceTopic.steps: docNoneBand}));
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getKeys(), {keyPermission, keyMaster, keyDayBands});
      expect(prefs.getKeys().contains('push_notification_shortcut_toggle'),
          isFalse);
      expect(prefs.getKeys().contains('audio_file_path'), isFalse);
      final back = await SharedPrefsVoiceRepository().load();
      expect(back.dayBands?.day, DateTime(2026, 11, 12));
      expect(back.dayBands?.bands[VoiceTopic.water], idWaterLow);
      expect(back.dayBands?.bands[VoiceTopic.steps], docNoneBand);
    });
  });
}

// ---------------------------------------------------------------------------
// engine / repository ปลอมเพิ่มเติม (implement VoiceTtsEngine — ไม่ใช่ตัวจริง)
// ---------------------------------------------------------------------------

class _PrepareThrowsEngine extends FakeVoiceTtsEngine {
  @override
  Future<bool> prepare() async {
    prepareCount++;
    throw StateError('engine missing');
  }
}

class _ThrowFirstSpeakEngine extends FakeVoiceTtsEngine {
  int _calls = 0;
  @override
  Future<void> speak(String text) async {
    _calls++;
    if (_calls == 1) {
      spoken.add(text);
      throw StateError('tts error');
    }
    return super.speak(text);
  }
}

class _StopThrowsEngine extends FakeVoiceTtsEngine {
  _StopThrowsEngine({super.autoComplete});
  @override
  Future<void> stop() async {
    stopCount++;
    completeCurrent();
    throw StateError('stop failed');
  }
}

class _CountingRepo extends InMemoryVoiceRepository {
  int loadCount = 0;
  @override
  Future<VoiceState> load() {
    loadCount++;
    return super.load();
  }
}

class _SavePermissionThrowsRepo extends InMemoryVoiceRepository {
  @override
  Future<void> savePermission({required bool enabled}) async {
    throw StateError('disk full');
  }
}
