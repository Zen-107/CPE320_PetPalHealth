// Unit tests: logic เกมของฟีเจอร์ steps (StepsLogic — pure Dart)
//
// ค่าคาดหวังทุกตัวมาจากเอกสาร (docs/steps/requirements.md, game-rules.md, ux-flow.md,
// ui-spec.md) — ไม่ลอกจากโค้ด เวลาส่งเข้า logic ทุกครั้ง ไม่ใช้เวลาจริง
// ชื่อเทสต์ที่มีคำว่า ASSUMPTION = ทดสอบการตีความของ Dev ในจุดที่เอกสารไม่ชัด (ไม่ใช่สเปก)
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/steps/steps_logic.dart';
import 'package:petpal_health/features/steps/steps_models.dart';
import 'package:petpal_health/features/steps/steps_rules.dart';
import 'package:petpal_health/features/water/water_models.dart';

// ---------------------------------------------------------------------------
// ค่าจากเอกสาร (game-rules.md §1, AC-2, ux-flow S-2)
// ---------------------------------------------------------------------------
const docDefaultGoal = 8000; // DEFAULT_DAILY_GOAL
const docMinGoal = 6000; // MIN_DAILY_GOAL
const docMaxGoal = 15000; // MAX_DAILY_GOAL
const docQuota = 1; // DAILY_GOAL_QUOTA
const docGoalOptions = [
  6000, 7000, 8000, // กลุ่มทั่วไป
  9000, 10000, 11000, 12000, // กลุ่มควบคุมน้ำหนัก
  13000, 14000, 15000, // กลุ่มนักกีฬา
];

/// เวลาในเดือน ต.ค. 2026
DateTime t(int day, int h, [int m = 0, int s = 0]) =>
    DateTime(2026, 10, day, h, m, s);
DateTime d(int day, [int month = 10]) => DateTime(2026, month, day);

/// รอบวัน [day] มีก้าว [steps] เป้าหมาย [goal] — ผู้ใช้ตั้งเป้าหมายเองแล้ว
StepsState dayState(
  DateTime day,
  int steps, {
  int goal = docDefaultGoal,
  DateTime? lastSeenAt,
  bool hasUserGoal = true,
  List<DailyStepsRecord> history = const [],
}) =>
    StepsState.initial.copyWith(
      day: day,
      steps: steps,
      activeGoal: goal,
      hasUserGoal: hasUserGoal,
      lastSeenAt: lastSeenAt,
      history: history,
    );

void main() {
  group('game-rules §1 ค่าหลัก', () {
    test('GR1_constants_match_game_rules', () {
      expect(StepsRules.defaultDailyGoal, docDefaultGoal);
      expect(StepsRules.minDailyGoal, docMinGoal);
      expect(StepsRules.maxDailyGoal, docMaxGoal);
      expect(StepsRules.dailyGoalQuota, docQuota);
      expect(StepsRules.resetCutoffHour, 5);
      expect(StepsRules.resetCutoffMinute, 0);
      expect(StepsRules.stepTolerancePct, 5);
    });

    test('AC2_goal_options_are_the_three_groups_from_ux_flow', () {
      expect(StepsRules.generalGoals, [6000, 7000, 8000]);
      expect(StepsRules.weightControlGoals, [9000, 10000, 11000, 12000]);
      expect(StepsRules.athleteGoals, [13000, 14000, 15000]);
      expect(StepsRules.allGoals, docGoalOptions);
    });
  });

  // -------------------------------------------------------------------------
  // AC-5 % Goal และสถานะสัตว์เลี้ยง (game-rules §2) — ค่าเกณฑ์พอดี ±1 ก้าว
  // -------------------------------------------------------------------------
  group('AC-5 % Goal → สถานะ', () {
    test('AC5_percent_formula_game_rules_example_2800_of_8000_is_35', () {
      expect(StepsLogic.percentGoal(2800, 8000), 35.0);
      expect(StepsLogic.statusFor(2800, 8000), StepsPetStatus.chubby);
    });

    test('AC5_percent_not_capped_8500_of_8000_is_106_25', () {
      expect(StepsLogic.percentGoal(8500, 8000), 106.25);
      expect(StepsLogic.statusFor(8500, 8000), StepsPetStatus.muscle);
    });

    test('AC5_status_for_percent_exact_boundaries', () {
      expect(StepsLogic.statusForPercent(0), StepsPetStatus.fat);
      expect(StepsLogic.statusForPercent(34.99), StepsPetStatus.fat);
      expect(StepsLogic.statusForPercent(35), StepsPetStatus.chubby);
      expect(StepsLogic.statusForPercent(69.99), StepsPetStatus.chubby);
      expect(StepsLogic.statusForPercent(70), StepsPetStatus.lean);
      expect(StepsLogic.statusForPercent(99.99), StepsPetStatus.lean);
      expect(StepsLogic.statusForPercent(100), StepsPetStatus.muscle);
      expect(StepsLogic.statusForPercent(250), StepsPetStatus.muscle);
    });

    test('EDGE_threshold_plus_minus_1_step_goal_8000', () {
      const cases = <int, StepsPetStatus>{
        0: StepsPetStatus.fat,
        2799: StepsPetStatus.fat,
        2800: StepsPetStatus.chubby,
        2801: StepsPetStatus.chubby,
        5599: StepsPetStatus.chubby,
        5600: StepsPetStatus.lean,
        5601: StepsPetStatus.lean,
        7999: StepsPetStatus.lean,
        8000: StepsPetStatus.muscle,
        8001: StepsPetStatus.muscle,
      };
      cases.forEach((steps, status) {
        expect(StepsLogic.statusFor(steps, 8000), status,
            reason: '$steps / 8000');
      });
    });

    test('EDGE_threshold_plus_minus_1_step_every_goal_option', () {
      for (final g in docGoalOptions) {
        final t35 = g * 35 ~/ 100;
        final t70 = g * 70 ~/ 100;
        expect(StepsLogic.statusFor(t35 - 1, g), StepsPetStatus.fat,
            reason: '${t35 - 1}/$g');
        expect(StepsLogic.statusFor(t35, g), StepsPetStatus.chubby,
            reason: '$t35/$g');
        expect(StepsLogic.statusFor(t70 - 1, g), StepsPetStatus.chubby,
            reason: '${t70 - 1}/$g');
        expect(StepsLogic.statusFor(t70, g), StepsPetStatus.lean,
            reason: '$t70/$g');
        expect(StepsLogic.statusFor(g - 1, g), StepsPetStatus.lean,
            reason: '${g - 1}/$g');
        expect(StepsLogic.statusFor(g, g), StepsPetStatus.muscle,
            reason: '$g/$g');
        expect(StepsLogic.statusFor(g + 1, g), StepsPetStatus.muscle,
            reason: '${g + 1}/$g');
      }
    });

    test('AC5_enum_codes_thai_labels_and_images_per_docs', () {
      // requirements §7 Enum + AC-5 ป้ายไทย + game-rules §2 ไฟล์ภาพ
      expect(StepsPetStatus.values.map((s) => s.code).toList(),
          ['FAT', 'CHUBBY', 'LEAN', 'MUSCLE']);
      expect(StepsLogic.statusText(StepsPetStatus.fat), 'อ้วนอืด');
      expect(StepsLogic.statusText(StepsPetStatus.chubby), 'จ่ำม่ำ');
      expect(StepsLogic.statusText(StepsPetStatus.lean), 'หุ่นลีน (สมส่วน)');
      expect(StepsLogic.statusText(StepsPetStatus.muscle), 'มีกล้ามขา');
      expect(StepsLogic.statusImage(StepsPetStatus.fat),
          'assets/images/pet_fat.png');
      expect(StepsLogic.statusImage(StepsPetStatus.chubby),
          'assets/images/pet_chubby.png');
      expect(StepsLogic.statusImage(StepsPetStatus.lean),
          'assets/images/pet_lean.png');
      expect(StepsLogic.statusImage(StepsPetStatus.muscle),
          'assets/images/pet_muscle.png');
    });
  });

  // -------------------------------------------------------------------------
  // ข้อความ S-1 (ux-flow S-1, ui-spec §2.1)
  // -------------------------------------------------------------------------
  group('ข้อความ S-1', () {
    test('S1_count_text_format_ux_flow_example_5500_of_8000', () {
      expect(StepsLogic.countText(5500, 8000), '5,500 / 8,000 ก้าว');
      expect(StepsLogic.countText(0, 8000), '0 / 8,000 ก้าว');
      expect(StepsLogic.countText(12345, 15000), '12,345 / 15,000 ก้าว');
    });

    test('S1_percent_text_examples_from_ui_spec', () {
      expect(StepsLogic.formatPercent(0, 8000), '0'); // ux-flow S-1 ว่าง 0%
      expect(StepsLogic.formatPercent(2800, 8000), '35'); // ui-spec Q-7
      expect(StepsLogic.formatPercent(8500, 8000), '106.25'); // ui-spec §2.1 #9
    });

    test('ASSUMPTION_Q7_percent_truncated_never_shows_100_while_lean', () {
      // ui-spec Q-7 (ชั่วคราว): ตัดทิ้งไม่ปัด — 7,999/8,000 = 99.9875% ต้องไม่แสดง 100
      expect(StepsLogic.formatPercent(7999, 8000), '99.98');
      expect(StepsLogic.formatPercent(2799, 8000), '34.98');
    });
  });

  // -------------------------------------------------------------------------
  // ค่าติดเพดาน max/min
  // -------------------------------------------------------------------------
  group('EDGE max/min', () {
    test('EDGE_energy_bar_capped_at_1_while_percent_exceeds_100', () {
      expect(StepsLogic.energyBarFraction(8500, 8000), 1.0);
      expect(StepsLogic.energyBarFraction(30000, 6000), 1.0);
      expect(StepsLogic.percentGoal(30000, 6000), 500.0);
      expect(StepsLogic.energyBarFraction(4000, 8000), 0.5);
      expect(StepsLogic.energyBarFraction(0, 8000), 0.0);
    });

    test('EDGE_add_zero_or_negative_steps_never_decreases_below_0', () {
      final s = dayState(d(14), 0, lastSeenAt: t(14, 9));
      expect(StepsLogic.addSteps(s, 0, t(14, 10)).steps, 0);
      expect(StepsLogic.addSteps(s, -500, t(14, 10)).steps, 0);
      final s2 = dayState(d(14), 1200, lastSeenAt: t(14, 9));
      expect(StepsLogic.addSteps(s2, -5000, t(14, 10)).steps, 1200);
      expect(StepsLogic.percentGoal(0, 8000), 0);
    });

    test('EDGE_goal_bounds_6000_15000_accepted_outside_rejected', () {
      expect(StepsLogic.isValidGoal(docMinGoal), isTrue);
      expect(StepsLogic.isValidGoal(docMaxGoal), isTrue);
      expect(StepsLogic.isValidGoal(docMinGoal - 1), isFalse);
      expect(StepsLogic.isValidGoal(docMaxGoal + 1), isFalse);
      expect(StepsLogic.isValidGoal(0), isFalse);
      expect(StepsLogic.isValidGoal(-8000), isFalse);
      for (final g in docGoalOptions) {
        expect(StepsLogic.isValidGoal(g), isTrue, reason: '$g');
      }
    });

    test('EDGE_invalid_goal_rejected_and_quota_not_consumed', () {
      final s = dayState(d(14), 0, lastSeenAt: t(14, 9));
      for (final bad in [docMinGoal - 1, docMaxGoal + 1]) {
        final r = StepsLogic.saveGoal(s, bad, t(14, 10));
        expect(r.outcome, SaveGoalOutcome.invalidGoal, reason: '$bad');
        expect(r.state.activeGoal, docDefaultGoal);
        expect(StepsLogic.remainingGoalQuota(r.state, t(14, 10)), docQuota);
      }
    });

    test('EDGE_quota_never_below_0', () {
      final s = dayState(d(14), 0, lastSeenAt: t(14, 9))
          .copyWith(goalChangeDay: d(14), goalChangeCount: 5);
      expect(StepsLogic.remainingGoalQuota(s, t(14, 10)), 0);
      final r = StepsLogic.saveGoal(s, 10000, t(14, 10));
      expect(r.outcome, SaveGoalOutcome.quotaExceeded);
      expect(StepsLogic.remainingGoalQuota(r.state, t(14, 10)), 0);
    });
  });

  // -------------------------------------------------------------------------
  // AC-6 / EC-5 รีเซ็ต 05:00:00 (เวลาข้ามวัน)
  // -------------------------------------------------------------------------
  group('AC-6 ตัดรอบ 05:00:00', () {
    test('AC6_logical_day_changes_exactly_at_05_00_00', () {
      expect(StepsLogic.logicalDay(t(14, 4, 59, 59)), d(13));
      expect(StepsLogic.logicalDay(t(14, 5, 0, 0)), d(14));
      expect(StepsLogic.logicalDay(t(14, 0, 0, 0)), d(13));
      expect(StepsLogic.logicalDay(t(14, 23, 59, 59)), d(14));
    });

    test('AC6_game_rules_example_8500_resets_to_0_at_05_00_00', () {
      final s = dayState(d(13), 8500, lastSeenAt: t(13, 22));
      expect(StepsLogic.percentGoal(s.steps, s.activeGoal), 106.25);

      final before = StepsLogic.applyDayRollover(s, t(14, 4, 59, 59));
      expect(before.steps, 8500, reason: '04:59:59 ยังไม่รีเซ็ต');
      expect(before.day, d(13));

      final after = StepsLogic.applyDayRollover(s, t(14, 5, 0, 0));
      expect(after.steps, 0);
      expect(after.day, d(14));
      expect(StepsLogic.percentGoal(after.steps, after.activeGoal), 0);
      expect(StepsLogic.statusFor(after.steps, after.activeGoal),
          StepsPetStatus.fat);
    });

    test('AC6_midnight_does_not_reset', () {
      final s = dayState(d(13), 3000, lastSeenAt: t(13, 23));
      expect(StepsLogic.applyDayRollover(s, t(14, 0, 0, 0)).steps, 3000);
    });

    test('AC6_previous_day_kept_in_history_after_reset', () {
      final s = dayState(d(13), 8500, lastSeenAt: t(13, 22));
      final after = StepsLogic.applyDayRollover(s, t(14, 5));
      expect(after.history,
          [DailyStepsRecord(date: d(13), steps: 8500, goal: 8000)]);
    });

    test('AC6_several_days_closed_resets_to_0', () {
      final s = dayState(d(10), 4000, lastSeenAt: t(10, 20));
      final after = StepsLogic.applyDayRollover(s, t(14, 10));
      expect(after.steps, 0);
      expect(after.day, d(14));
    });

    test('AC6_steps_added_after_05_00_count_only_for_new_day', () {
      final s = dayState(d(13), 7000, lastSeenAt: t(13, 22));
      final after = StepsLogic.addSteps(s, 500, t(14, 5, 0, 0));
      expect(after.day, d(14));
      expect(after.steps, 500);
    });

    test('EDGE_first_run_no_data_starts_day_with_0_steps', () {
      final s = StepsLogic.applyDayRollover(StepsState.initial, t(14, 10));
      expect(s.day, d(14));
      expect(s.steps, 0);
      expect(s.activeGoal, docDefaultGoal);
      expect(StepsLogic.statusFor(s.steps, s.activeGoal), StepsPetStatus.fat);
      expect(StepsLogic.remainingGoalQuota(s, t(14, 10)), docQuota);
    });
  });

  // -------------------------------------------------------------------------
  // AC-2 / AC-3 / AC-4 เป้าหมายและโควต้า
  // -------------------------------------------------------------------------
  group('AC-2/AC-3/AC-4 เป้าหมาย', () {
    test('AC2_ASSUMPTION_first_goal_new_user_applies_immediately', () {
      // ux-flow §3 ข้อ 4–5: ผู้ใช้ใหม่บันทึก → อัปเดต % Goal ทันที + หักโควต้า
      final s = StepsState.initial
          .copyWith(day: d(14), steps: 5000, lastSeenAt: t(14, 9));
      final r = StepsLogic.saveGoal(s, 10000, t(14, 10));
      expect(r.outcome, SaveGoalOutcome.appliedNow);
      expect(r.state.activeGoal, 10000);
      expect(StepsLogic.percentGoal(r.state.steps, r.state.activeGoal), 50);
      expect(StepsLogic.remainingGoalQuota(r.state, t(14, 10)), 0);
    });

    test('AC2_every_goal_option_can_be_saved', () {
      for (final g in docGoalOptions) {
        final s = StepsState.initial.copyWith(day: d(14), lastSeenAt: t(14, 9));
        final r = StepsLogic.saveGoal(s, g, t(14, 10));
        expect(r.isSaved, isTrue, reason: '$g');
        expect(r.state.latestGoal, g);
      }
    });

    test('AC3_second_change_same_day_is_rejected', () {
      final s = StepsState.initial.copyWith(day: d(14), lastSeenAt: t(14, 9));
      final first = StepsLogic.saveGoal(s, 10000, t(14, 10));
      expect(first.isSaved, isTrue);
      expect(StepsLogic.canChangeGoal(first.state, t(14, 10, 1)), isFalse);
      final second = StepsLogic.saveGoal(first.state, 12000, t(14, 10, 1));
      expect(second.outcome, SaveGoalOutcome.quotaExceeded);
      expect(second.state.latestGoal, 10000, reason: 'ไม่ให้บันทึกค่าซ้ำ');
    });

    test('AC3_quota_still_used_at_04_59_59_and_resets_at_05_00_00', () {
      final s = StepsState.initial.copyWith(day: d(14), lastSeenAt: t(14, 9));
      final saved = StepsLogic.saveGoal(s, 10000, t(14, 10)).state;
      expect(StepsLogic.canChangeGoal(saved, t(15, 4, 59, 59)), isFalse);
      expect(StepsLogic.canChangeGoal(saved, t(15, 5, 0, 0)), isTrue);
      expect(StepsLogic.remainingGoalQuota(saved, t(15, 5, 0, 0)), docQuota);
    });

    test('AC4_change_after_05_00_applies_from_next_day_05_00', () {
      // ผู้ใช้เดิม (เคยตั้งเป้าหมายแล้ว) เปลี่ยน 8,000 → 12,000 เวลา 10:00
      final s = dayState(d(14), 6000, lastSeenAt: t(14, 9));
      final r = StepsLogic.saveGoal(s, 12000, t(14, 10));
      expect(r.outcome, SaveGoalOutcome.appliedNextDay);
      expect(r.state.activeGoal, 8000, reason: 'รอบวันปัจจุบันยังใช้ค่าเดิม');
      expect(StepsLogic.percentGoal(r.state.steps, r.state.activeGoal), 75);

      final at0459 = StepsLogic.applyDayRollover(r.state, t(15, 4, 59, 59));
      expect(at0459.activeGoal, 8000);
      final at0500 = StepsLogic.applyDayRollover(r.state, t(15, 5, 0, 0));
      expect(at0500.activeGoal, 12000);
      expect(at0500.steps, 0);
      // วันที่ผ่านไปเก็บเป้าหมายเดิม
      expect(at0500.history.last,
          DailyStepsRecord(date: d(14), steps: 6000, goal: 8000));
    });

    test('ASSUMPTION_AC2_change_before_05_00_applies_immediately', () {
      // brief.md §2 ตีความโดย Dev: เปลี่ยนช่วง 00:00–04:59 → มีผลรอบวันปัจจุบันทันที
      final s = dayState(d(13), 4000, lastSeenAt: t(14, 3));
      final r = StepsLogic.saveGoal(s, 10000, t(14, 4, 59, 59));
      expect(r.outcome, SaveGoalOutcome.appliedNow);
      expect(r.state.activeGoal, 10000);
    });
  });

  // -------------------------------------------------------------------------
  // EC-3 นาฬิกาย้อน
  // -------------------------------------------------------------------------
  group('EC-3 นาฬิกาย้อน', () {
    test('EC3_clock_back_before_cutoff_does_not_reset_steps', () {
      final s = dayState(d(14), 3000, lastSeenAt: t(14, 10));
      // ปรับนาฬิกาย้อนไป 04:00 (รอบวัน 13) แล้วกลับมา 05:00 ไม่ทำให้รีเซ็ต
      final back = StepsLogic.applyDayRollover(s, t(14, 4));
      expect(back.steps, 3000);
      expect(back.day, d(14));
      final back2 = StepsLogic.applyDayRollover(back, t(14, 5, 0, 0));
      expect(back2.steps, 3000);
      final yesterday = StepsLogic.applyDayRollover(s, t(13, 10));
      expect(yesterday.steps, 3000);
      expect(yesterday.day, d(14));
    });

    test('EC3_clock_back_does_not_restore_goal_quota', () {
      final s = StepsState.initial.copyWith(day: d(14), lastSeenAt: t(14, 9));
      final saved = StepsLogic.saveGoal(s, 10000, t(14, 10)).state;
      expect(StepsLogic.canChangeGoal(saved, t(13, 10)), isFalse);
      expect(StepsLogic.saveGoal(saved, 12000, t(13, 10)).outcome,
          SaveGoalOutcome.quotaExceeded);
    });

    test('EC3_clock_back_does_not_overwrite_previous_day_history', () {
      final s = dayState(d(14), 3000,
          lastSeenAt: t(14, 10),
          history: [DailyStepsRecord(date: d(13), steps: 5000, goal: 8000)]);
      final after = StepsLogic.addSteps(s, 1000, t(13, 12));
      expect(after.day, d(14));
      expect(after.steps, 4000);
      expect(after.history,
          [DailyStepsRecord(date: d(13), steps: 5000, goal: 8000)]);
    });

    test('EC3_real_cutoff_after_clock_back_still_resets', () {
      final s = dayState(d(14), 3000, lastSeenAt: t(14, 10));
      final back = StepsLogic.applyDayRollover(s, t(13, 10));
      final next = StepsLogic.applyDayRollover(back, t(15, 5, 0, 0));
      expect(next.steps, 0);
      expect(next.day, d(15));
    });
  });

  // -------------------------------------------------------------------------
  // AC-7 รายงานรายเดือน 4 ตัวแปร
  // -------------------------------------------------------------------------
  group('AC-7 รายงานรายเดือน', () {
    // ต.ค. 1–3 มีก้าวทุกวัน (ตัวหารค่าเฉลี่ยตีความแบบไหนก็ได้ 3) + ข้อมูล ก.ย. ที่ต้องไม่ถูกนับ
    StepsState octState() => dayState(d(3), 6000,
            lastSeenAt: t(3, 9),
            history: [
              DailyStepsRecord(date: d(30, 9), steps: 9000, goal: 8000),
              DailyStepsRecord(date: d(1), steps: 8000, goal: 8000),
              DailyStepsRecord(date: d(2), steps: 4000, goal: 8000),
            ]);
    final water = [
      DailyWaterRecord(date: d(30, 9), cups: 8),
      DailyWaterRecord(date: d(1), cups: 6),
      DailyWaterRecord(date: d(2), cups: 7),
      DailyWaterRecord(date: d(3), cups: 3),
    ];

    test('AC7_four_values_total_steps_water_average_goal_days', () {
      final r = StepsLogic.monthlyReport(octState(), water, t(3, 10));
      expect(r.year, 2026);
      expect(r.month, 10);
      expect(r.totalSteps, 18000); // 8000 + 4000 + 6000
      expect(r.totalWaterCups, 16); // 6 + 7 + 3
      expect(r.averageDailySteps, 6000); // 18000 / 3
      expect(r.goalAchievedDays, 1); // 1 ต.ค. 8000/8000 = 100% พอดี
      expect(r.isEmpty, isFalse);
    });

    test('AC7_goal_day_boundary_7999_not_counted_8000_counted', () {
      final s = dayState(d(3), 0, lastSeenAt: t(3, 9), history: [
        DailyStepsRecord(date: d(1), steps: 7999, goal: 8000),
        DailyStepsRecord(date: d(2), steps: 8000, goal: 8000),
      ]);
      expect(StepsLogic.monthlyReport(s, const [], t(3, 10)).goalAchievedDays,
          1);
    });

    test('AC7_month_follows_05_00_cutoff', () {
      final s = dayState(d(31), 5000, lastSeenAt: t(31, 22), history: [
        DailyStepsRecord(date: d(30), steps: 3000, goal: 8000),
      ]);
      final before = StepsLogic.monthlyReport(
          s, const [], DateTime(2026, 11, 1, 4, 59, 59));
      expect(before.month, 10);
      expect(before.totalSteps, 8000);

      final rolled = StepsLogic.applyDayRollover(s, DateTime(2026, 11, 1, 5));
      final after =
          StepsLogic.monthlyReport(rolled, const [], DateTime(2026, 11, 1, 5));
      expect(after.month, 11);
      expect(after.totalSteps, 0);
    });

    test('EDGE_empty_report_all_zero', () {
      final r = StepsLogic.monthlyReport(StepsState.initial, const [], t(14, 10));
      expect(r.totalSteps, 0);
      expect(r.totalWaterCups, 0);
      expect(r.averageDailySteps, 0);
      expect(r.goalAchievedDays, 0);
      expect(r.isEmpty, isTrue);
    });

    test('ASSUMPTION_Q6_average_divides_by_days_with_steps', () {
      // dev log Q6: ตัวหาร = จำนวนวันที่มีก้าว > 0 (ไม่ใช่จำนวนวันที่ผ่านไป)
      final s = dayState(d(4), 0, lastSeenAt: t(4, 9), history: [
        DailyStepsRecord(date: d(1), steps: 6000, goal: 8000),
        DailyStepsRecord(date: d(3), steps: 3000, goal: 8000),
      ]);
      expect(
          StepsLogic.monthlyReport(s, const [], t(4, 10)).averageDailySteps,
          4500);
    });

    test('ASSUMPTION_Q7_goal_days_use_goal_of_that_day', () {
      final s = dayState(d(3), 0, goal: 15000, lastSeenAt: t(3, 9), history: [
        DailyStepsRecord(date: d(1), steps: 6000, goal: 6000),
        DailyStepsRecord(date: d(2), steps: 9000, goal: 10000),
      ]);
      expect(StepsLogic.monthlyReport(s, const [], t(3, 10)).goalAchievedDays,
          1);
    });

    test('AC7_report_file_is_png', () {
      expect(StepsLogic.reportFileName(2026, 10), endsWith('.png'));
    });
  });
}
