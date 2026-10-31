// Unit tests: logic เกมของ dashboard (คะแนน / อารมณ์ / คิวข้อความ)
// ค่าคาดหวังมาจาก docs/dashboard/game-rules.md §1–§4, requirements.md AC-1..AC-3, EC-1/4/5
// และข้อตัดสิน owner D-1, D-3, D-4, Q-1, Q-3, Q-14, Q-16 — ไม่ได้ลอกจากโค้ด
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/dashboard/dashboard_logic.dart';
import 'package:petpal_health/features/dashboard/dashboard_models.dart';
import 'package:petpal_health/features/dashboard/dashboard_rules.dart';
import 'package:petpal_health/shared/pet/pet.dart';

import 'dashboard_test_helpers.dart';

/// input สมมติ: เป้าก้าว 8,000, เป้าอาหาร 2,000 (มีโปรไฟล์)
DashboardInput input({
  int cups = 0,
  int steps = 0,
  int stepsGoal = docStepsDefaultGoal,
  int kcal = 0,
  int? target = docFoodTarget,
  bool? overLimit,
  bool? hasMeals,
}) =>
    DashboardInput(
      cups: cups,
      steps: steps,
      stepsGoal: stepsGoal,
      totalCalories: kcal,
      targetCalories: target,
      // ใช้นิยามเอกสาร: Overeating > 100 kcal เหนือเป้า
      isFoodOverLimit:
          overLimit ?? (target != null && kcal > target + docOverLimitKcal),
      hasMealsToday: hasMeals ?? kcal > 0,
    );

DashboardSnapshot snap(DashboardInput i) => DashboardLogic.snapshot(i);

List<String> texts(DashboardSnapshot s) => s.alerts.map((a) => a.text).toList();

void main() {
  // =========================================================================
  // AC-1 / EC-1 / EC-5 คะแนนรวม
  // =========================================================================
  group('AC-1 คะแนนรวม = (Food + Steps + Water) / 3', () {
    test('GR3_row1_food60_steps90_water60_total70_bubbly', () {
      final total = DashboardRules.totalScore(
          waterScore: 60, stepsScore: 90, foodScore: 60);
      expect(total, 70);
      expect(DashboardLogic.moodFor(total), DashboardPetMood.bubbly);
    });

    // R3: owner ข้อ 2 (floor) ชนะ game-rules §3 แถว 2 / EC-5 — เดิมคาด 66
    test('DECIDED_R3_GR3_row2_EC5_food70_steps60_water67_total65_bubbly', () {
      // (70 + 60 + 67) / 3 = 65.66 → floor 65
      final total = DashboardRules.totalScore(
          waterScore: 67, stepsScore: 60, foodScore: 70);
      expect(total, 65);
      expect(DashboardLogic.moodFor(total), DashboardPetMood.bubbly);
    });

    test('GR3_row3_EC4_food_minus10_steps90_water90_food0_total60_dazed', () {
      expect(DashboardRules.clampScore(-10), 0);
      final total = DashboardRules.totalScore(
          waterScore: 90, stepsScore: 90, foodScore: -10);
      expect(total, 60);
      expect(DashboardLogic.moodFor(total), DashboardPetMood.dazed);
    });

    test('GR4_EC1_food100_steps100_water160_cap100_cheerful', () {
      // เฉลี่ยดิบ 120% → Cap 100
      final total = DashboardRules.totalScore(
          waterScore: 160, stepsScore: 100, foodScore: 100);
      expect(total, 100);
      expect(DashboardLogic.moodFor(total), DashboardPetMood.cheerful);
    });

    test('EC1_all_categories_over_target_snapshot_total_100', () {
      // ดื่ม 13 แก้ว (เป้า 8), เดิน 20,000 (เป้า 8,000), อาหารพอดีเป้า 2,000
      final s = snap(input(cups: 13, steps: 20000, kcal: docFoodTarget));
      expect(s.waterScore, 100);
      expect(s.stepsScore, 100);
      expect(s.foodScore, 100);
      expect(s.totalScore, 100);
      expect(s.mood, DashboardPetMood.cheerful);
    });

    // R3: owner ข้อ 2 (floor) — เดิมคาด 65.67 → 66
    test('DECIDED_R3_EC5_total_is_integer_floor_65_67_and_65_33_to_65', () {
      expect(
          DashboardRules.totalScore(
              waterScore: 63, stepsScore: 63, foodScore: 71),
          65); // 197 / 3 = 65.67 → floor 65
      expect(
          DashboardRules.totalScore(
              waterScore: 63, stepsScore: 63, foodScore: 70),
          65); // 196 / 3 = 65.33
    });

    test('EC4_null_and_negative_category_become_0', () {
      expect(DashboardRules.clampScore(null), 0);
      expect(DashboardRules.clampScore(-1), 0);
      expect(DashboardRules.clampScore(0), 0);
      // ข้อมูลดิบติดลบ (ข้อมูลเสีย) ทั้ง 3 หมวด → 0
      final s = snap(input(cups: -3, steps: -500, kcal: -10, hasMeals: true));
      expect(s.waterScore, 0);
      expect(s.stepsScore, 0);
      expect(s.foodScore, 0);
      expect(s.totalScore, 0);
      expect(s.mood, DashboardPetMood.crying);
    });

    test('EDGE_empty_first_open_all_zero_crying', () {
      final s = snap(input());
      expect(s.waterScore, 0);
      expect(s.stepsScore, 0);
      expect(s.foodScore, 0);
      expect(s.totalScore, 0);
      expect(s.mood, DashboardPetMood.crying);
    });

    test('EDGE_category_min_max_0_and_100_never_outside', () {
      for (final v in [-1000, -1, 0, 1, 99, 100, 101, 1000]) {
        final c = DashboardRules.clampScore(v);
        expect(c, inInclusiveRange(0, 100), reason: 'v=$v');
      }
      expect(DashboardRules.clampScore(101), 100);
      expect(DashboardRules.clampScore(1000), 100);
    });
  });

  // =========================================================================
  // D-3 / Q-14 / Q-16 คะแนนรายหมวด
  // =========================================================================
  group('D-3 คะแนนรายหมวด', () {
    test('DECIDED_Q14_water_target_8_cups_score_per_cup', () {
      // round(min(cups / 8, 1) × 100)
      expect(snap(input(cups: 0)).waterScore, 0);
      expect(snap(input(cups: 2)).waterScore, 25);
      expect(snap(input(cups: 4)).waterScore, 50);
      expect(snap(input(cups: 6)).waterScore, 75);
      // R3: owner ข้อ 2 (floor) — เดิม 88 ตาม ui-spec Q-14
      expect(snap(input(cups: 7)).waterScore, 87, reason: '87.5 → floor 87');
      expect(snap(input(cups: 8)).waterScore, 100);
      expect(snap(input(cups: 9)).waterScore, 100, reason: 'min(…, 1)');
    });

    test('DECIDED_D3_steps_ratio_round_and_cap', () {
      expect(snap(input(steps: 4000)).stepsScore, 50);
      expect(snap(input(steps: 7200)).stepsScore, 90);
      expect(snap(input(steps: 7920)).stepsScore, 99);
      expect(snap(input(steps: 8000)).stepsScore, 100);
      expect(snap(input(steps: 8001)).stepsScore, 100);
      expect(snap(input(steps: 16000)).stepsScore, 100);
      // เป้าที่ผู้ใช้ตั้งเอง (steps feature) — 6,000 ก้าว จาก 12,000 = 50
      expect(snap(input(steps: 6000, stepsGoal: 12000)).stepsScore, 50);
    });

    test('DECIDED_D3_food_up_to_target_kcal_over_target_x100', () {
      expect(snap(input(kcal: 1200)).foodScore, 60);
      // R3: owner ข้อ 2 (floor) — เดิม 100
      expect(snap(input(kcal: 1999)).foodScore, 99, reason: '99.95 → floor 99');
      expect(snap(input(kcal: 2000)).foodScore, 100);
    });

    test('DECIDED_D3_food_over_target_100_minus_over_percent', () {
      // 2,100: เกิน 100 = 5% → 95 · 2,150: 100 − ceil(7.5) = 92 (R3 owner ข้อ 2 — เดิม 93)
      expect(snap(input(kcal: 2100)).foodScore, 95);
      expect(snap(input(kcal: 2150)).foodScore, 92);
      expect(snap(input(kcal: 3000)).foodScore, 50);
      expect(snap(input(kcal: 4000)).foodScore, 0);
    });

    test('EDGE_D3_food_far_over_target_floor_0_not_negative', () {
      expect(snap(input(kcal: 4001)).foodScore, 0);
      expect(snap(input(kcal: 9000)).foodScore, 0);
    });

    test('DECIDED_D3_Q1_food_no_target_not_scored_total_avg_of_2', () {
      final s = snap(input(cups: 4, steps: 8000, kcal: 1500, target: null));
      expect(s.foodScore, isNull, reason: 'ไม่มีเป้า = ไม่คิดคะแนน');
      // round((100 + 50) / 2) = 75
      expect(s.totalScore, 75);
      expect(s.mood, DashboardPetMood.bubbly);
    });

    test('DECIDED_Q1_no_target_can_reach_100_cheerful', () {
      final s = snap(input(cups: 8, steps: 8000, kcal: 3000, target: null));
      expect(s.totalScore, 100);
      expect(s.mood, DashboardPetMood.cheerful);
    });

    // R3: owner ข้อ 2 (floor) แทน Q-16 (round) — เดิมคาด 86
    test('DECIDED_R3_total_floor_of_floored_category_scores', () {
      // Food 2150 → 92, Steps 7200 → 90, Water 6 → 75 · (92 + 90 + 75) / 3 = 85.67 → 85
      final s = snap(input(cups: 6, steps: 7200, kcal: 2150));
      expect(s.foodScore, 92);
      expect(s.totalScore, 85);
    });

    // R3 ใหม่: owner ข้อ 2 — ได้ 100 เฉพาะเมื่อถึงเป้าจริง
    test('DECIDED_R3_EDGE_100_only_when_target_reached', () {
      expect(snap(input(cups: 7)).waterScore, 87);
      expect(snap(input(cups: 8)).waterScore, 100);
      expect(snap(input(steps: 7999)).stepsScore, 99);
      expect(snap(input(steps: 8000)).stepsScore, 100);
      expect(snap(input(kcal: 1999)).foodScore, 99);
      expect(snap(input(kcal: 2000)).foodScore, 100);
      expect(snap(input(kcal: 2001)).foodScore, 99, reason: '100 − ceil(0.05)');
      expect(snap(input(kcal: 2101)).foodScore, 94, reason: '100 − ceil(5.05)');
      // 7,999 ก้าว = 99 → 「ขยับร่างกายหน่อย อีกนิดๆ」ยังอยู่ในคิว
      expect(texts(snap(input(steps: 7999))), contains(p3Text));
      // total 99.67 → 99 ไม่ใช่ 100
      expect(snap(input(cups: 8, steps: 7999, kcal: 2000)).totalScore, 99);
    });

    test('DECIDED_R3_Q1_no_target_total_floor_of_half', () {
      // Steps 100 (8,000) + Water 87 (7 แก้ว) = 187 / 2 = 93.5 → floor 93
      expect(snap(input(cups: 7, steps: 8000, target: null)).totalScore, 93);
    });
  });

  // =========================================================================
  // AC-2 อารมณ์ + ขอบช่วง
  // =========================================================================
  group('AC-2 อารมณ์สัตว์เลี้ยง', () {
    final cases = <int, DashboardPetMood>{
      0: DashboardPetMood.crying,
      30: DashboardPetMood.crying,
      31: DashboardPetMood.dazed,
      60: DashboardPetMood.dazed,
      61: DashboardPetMood.bubbly,
      80: DashboardPetMood.bubbly,
      81: DashboardPetMood.cheerful,
      100: DashboardPetMood.cheerful,
    };
    cases.forEach((score, mood) {
      test('AC2_EDGE_mood_at_$score', () {
        expect(DashboardLogic.moodFor(score), mood);
      });
    });

    test('AC2_EDGE_boundaries_via_snapshot_30_31_60_61_80_81', () {
      // Water 0, Steps 0, Food 90 → 30 · Food 93 → 31
      expect(snap(input(kcal: kcalForFoodScore(90))).totalScore, 30);
      expect(snap(input(kcal: kcalForFoodScore(90))).mood, DashboardPetMood.crying);
      expect(snap(input(kcal: kcalForFoodScore(93))).totalScore, 31);
      expect(snap(input(kcal: kcalForFoodScore(93))).mood, DashboardPetMood.dazed);
      // Food 100 + Steps 80 → 60 · Steps 83 → 61
      final s60 = snap(input(kcal: 2000, steps: stepsForScore(80)));
      expect([s60.totalScore, s60.mood], [60, DashboardPetMood.dazed]);
      final s61 = snap(input(kcal: 2000, steps: stepsForScore(83)));
      expect([s61.totalScore, s61.mood], [61, DashboardPetMood.bubbly]);
      // Food 90 + Steps 100 + Water 50 → 80 · Food 93 → 81
      final s80 = snap(input(kcal: kcalForFoodScore(90), steps: 8000, cups: 4));
      expect([s80.totalScore, s80.mood], [80, DashboardPetMood.bubbly]);
      final s81 = snap(input(kcal: kcalForFoodScore(93), steps: 8000, cups: 4));
      expect([s81.totalScore, s81.mood], [81, DashboardPetMood.cheerful]);
    });

    // R3: owner ข้อ 2 (floor) ชนะ Q-13 เดิม — เดิมคาด Food 92 (30.67) = DAZED
    test('DECIDED_R3_mood_from_floored_total_30_67_is_crying', () {
      // Food 91 → 30.33 → 30 crying · Food 92 → 30.67 → floor 30 → crying · Food 93 → 31 dazed
      expect(snap(input(kcal: kcalForFoodScore(91))).mood, DashboardPetMood.crying);
      expect(snap(input(kcal: kcalForFoodScore(92))).totalScore, 30);
      expect(snap(input(kcal: kcalForFoodScore(92))).mood, DashboardPetMood.crying);
      expect(snap(input(kcal: kcalForFoodScore(93))).mood, DashboardPetMood.dazed);
    });

    test('DECIDED_D1_pose_mapping_PetCharacter', () {
      expect(DashboardLogic.poseFor(DashboardPetMood.crying), PetPose.dashboardCrying);
      expect(DashboardLogic.poseFor(DashboardPetMood.dazed), PetPose.dashboardDazed);
      expect(DashboardLogic.poseFor(DashboardPetMood.bubbly), PetPose.dashboardBubbly);
      expect(DashboardLogic.poseFor(DashboardPetMood.cheerful),
          PetPose.dashboardCheerful);
      expect(PetPose.dashboardBubbly, PetPose.waterHappy, reason: 'BUBBLY ใช้หน้าเดิม');
    });
  });

  // =========================================================================
  // AC-3 Dynamic Alert Queue — trigger
  // =========================================================================
  group('AC-3 คิวข้อความ (trigger / removal)', () {
    test('AC3_exact_strings_4_priorities', () {
      expect(DashboardAlert.overeating.text, p1Text);
      expect(DashboardAlert.drinkWater.text, p2Text);
      expect(DashboardAlert.moveBody.text, p3Text);
      expect(DashboardAlert.hungry.text, p4Text);
      expect([for (final a in DashboardAlert.values) a.priority], [1, 2, 3, 4]);
    });

    test('AC3_empty_day_queue_P2_P3_P4_in_priority_order', () {
      expect(texts(snap(input())), [p2Text, p3Text, p4Text]);
    });

    test('GR3_row1_example_queue_P2_P3_only', () {
      // ui-spec §3: Food 60 / Steps 90 / Water ~ → P4 ไม่อยู่เพราะ 60 ≥ 50 และมีมื้อ
      final s = snap(input(kcal: 1200, steps: 7200, cups: 4));
      expect(texts(s), [p2Text, p3Text]);
    });

    test('AC3_EDGE_P1_overeat_threshold_2100_not_2101_yes', () {
      final at = snap(input(kcal: docFoodTarget + docOverLimitKcal));
      expect(at.isFoodOverLimit, isFalse);
      expect(texts(at), isNot(contains(p1Text)));
      final over = snap(input(kcal: docFoodTarget + docOverLimitKcal + 1));
      expect(over.isFoodOverLimit, isTrue);
      expect(texts(over).first, p1Text);
    });

    test('DECIDED_Q2_no_target_never_P1', () {
      final s = snap(input(kcal: 5000, target: null, overLimit: false));
      expect(texts(s), isNot(contains(p1Text)));
      expect(s.isFoodOverLimit, isFalse);
    });

    test('AC3_EDGE_P2_water_7_cups_in_8_cups_out', () {
      expect(texts(snap(input(cups: 7))), contains(p2Text));
      expect(texts(snap(input(cups: 8))), isNot(contains(p2Text)));
    });

    test('AC3_EDGE_P3_steps_99pct_in_100pct_out', () {
      expect(texts(snap(input(steps: 7920))), contains(p3Text));
      expect(texts(snap(input(steps: 8000))), isNot(contains(p3Text)));
    });

    test('DECIDED_D4_EDGE_P4_food_score_49_in_50_out', () {
      expect(texts(snap(input(kcal: kcalForFoodScore(49)))), contains(p4Text));
      expect(texts(snap(input(kcal: kcalForFoodScore(50)))), isNot(contains(p4Text)));
    });

    test('DECIDED_Q3_P4_no_meal_in_even_with_target', () {
      expect(texts(snap(input(kcal: 0, hasMeals: false))), contains(p4Text));
    });

    test('DECIDED_Q3_P4_logged_but_still_below_50_stays', () {
      // บันทึกแล้ว 500 kcal = 25% → ยังต่ำกว่าเกณฑ์ → ยังอยู่ในคิว
      expect(texts(snap(input(kcal: 500))), contains(p4Text));
    });

    test('DECIDED_Q3_P4_no_target_only_no_meal_rule', () {
      expect(texts(snap(input(target: null, kcal: 0, hasMeals: false))),
          contains(p4Text));
      expect(texts(snap(input(target: null, kcal: 200, hasMeals: true))),
          isNot(contains(p4Text)));
    });

    // R3: owner ข้อ 1 ยึด A-7 (BUG-DASH-1 / QD-2 ปิด) — เดิมชื่อ
    // DECIDED_D4_P4_far_over_target_food_score_below_50_in_queue คาด [P1, P2, P3, P4]
    test('DECIDED_R3_A7_P4_far_over_target_food_score_below_50_not_in_queue', () {
      // 3,500 kcal เป้า 2,000 → foodScore = 100 − 75 = 25 แต่กินเกินเป้า → ไม่ขึ้น「ฉันหิว」
      final s = snap(input(kcal: 3500));
      expect(s.foodScore, 25);
      expect(texts(s), [p1Text, p2Text, p3Text]);
    });

    test('AC3_queue_empty_when_all_resolved', () {
      final s = snap(input(cups: 8, steps: 8000, kcal: 2000));
      expect(s.alerts, isEmpty);
    });
  });

  // =========================================================================
  // AC-3 / EC-2 / Q-19 การเลือกข้อความ (pure)
  // =========================================================================
  group('AC-3 / EC-2 การหมุนเวียน (pure)', () {
    const all = [
      DashboardAlert.overeating,
      DashboardAlert.drinkWater,
      DashboardAlert.moveBody,
      DashboardAlert.hungry,
    ];

    test('AC3_next_alert_loops_in_priority_order', () {
      var cur = DashboardLogic.nextAlert(all, null);
      final seen = <DashboardAlert?>[cur];
      for (var i = 0; i < 4; i++) {
        cur = DashboardLogic.nextAlert(all, cur);
        seen.add(cur);
      }
      expect(seen, [
        DashboardAlert.overeating,
        DashboardAlert.drinkWater,
        DashboardAlert.moveBody,
        DashboardAlert.hungry,
        DashboardAlert.overeating,
      ]);
    });

    test('EC2_GR4_P1_removed_while_showing_next_is_P2', () {
      final next = DashboardLogic.resolveAlert(
        previousQueue: all,
        queue: all.sublist(1),
        current: DashboardAlert.overeating,
      );
      expect(next, DashboardAlert.drinkWater);
    });

    test('EC2_last_item_removed_wraps_to_head', () {
      final next = DashboardLogic.resolveAlert(
        previousQueue: const [DashboardAlert.drinkWater, DashboardAlert.hungry],
        queue: const [DashboardAlert.drinkWater],
        current: DashboardAlert.hungry,
      );
      expect(next, DashboardAlert.drinkWater);
    });

    test('EC2_only_item_removed_queue_empty_null', () {
      expect(
          DashboardLogic.resolveAlert(
            previousQueue: const [DashboardAlert.drinkWater],
            queue: const [],
            current: DashboardAlert.drinkWater,
          ),
          isNull);
      expect(DashboardLogic.nextAlert(const [], null), isNull);
    });
  });
}
