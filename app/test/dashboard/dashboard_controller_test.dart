// Unit tests: DashboardController — หมุนข้อความทุก 5 วินาที, คัดออกจากคิวทันที, ข้าม 05:00
// ค่าคาดหวังมาจาก docs/dashboard/game-rules.md §1 (alertInterval 5 s, resetHour 05:00),
// §1.1 + หมายเหตุ Dynamic Queue, §4, requirements AC-3, AC-5, EC-2, EC-3
// และข้อตัดสิน owner D-2, D-3, Q-2, Q-17, Q-19 — ไม่ได้ลอกจากโค้ด
// เวลา: FakeTimers (alert timer) + clock ของ 3 controller — ไม่ใช้เวลาจริง
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/dashboard/dashboard_controller.dart';
import 'package:petpal_health/features/dashboard/dashboard_models.dart';
import 'package:petpal_health/features/food/food_models.dart';

import 'dashboard_test_helpers.dart';

void main() {
  late DateTime now;
  late FakeTimers timers; // timer ของ dashboard (alertInterval)
  late FakeTimers foodTimers; // ท่าชั่วคราว / Toast ของ food (ไม่เกี่ยวกับ dashboard)
  DashboardController? dash;

  setUp(() {
    now = t(14, 10);
    timers = FakeTimers();
    foodTimers = FakeTimers();
  });

  tearDown(() {
    dash?.dispose();
    dash = null;
  });

  Future<(Sources, DashboardController)> make({
    int cups = 0,
    int steps = 0,
    int kcal = 0,
  }) async {
    final s = makeSources(
      clock: () => now,
      water: water14(cups),
      steps: steps14(steps),
      food: food14(kcal),
      foodTimers: foodTimers,
    );
    await s.loadAll();
    final c = DashboardController(
        water: s.water, steps: s.steps, food: s.food, timerFactory: timers.create);
    dash = c;
    return (s, c);
  }

  String? shown(DashboardController c) => c.currentAlert?.text;
  const interval = Duration(seconds: docAlertIntervalSeconds);
  const ms1 = Duration(milliseconds: 1);

  group('AC-3 หมุนเวียนทุก alertInterval = 5 วินาที', () {
    test('AC3_starts_at_highest_priority_P2_on_empty_day', () async {
      final (_, c) = await make();
      expect(shown(c), p2Text);
    });

    test('AC3_EDGE_rotation_exactly_at_5s_not_4_999s_and_loops', () async {
      final (_, c) = await make();
      timers.advance(interval - ms1);
      expect(shown(c), p2Text, reason: '4.999 s ยังไม่เปลี่ยน');
      timers.advance(ms1);
      expect(shown(c), p3Text, reason: 'ครบ 5 s');
      timers.advance(interval);
      expect(shown(c), p4Text);
      timers.advance(interval);
      expect(shown(c), p2Text, reason: 'วนกลับต้นคิว');
    });

    test('AC3_P1_queue_rotates_P1_P2_P3_back_to_P1', () async {
      // 2,150 kcal: P1 (เกิน 150) · foodScore 93 ≥ 50 และมีมื้อ → ไม่มี P4
      final (_, c) = await make(kcal: 2150);
      expect(c.snapshot.alerts.map((a) => a.text), [p1Text, p2Text, p3Text]);
      expect(shown(c), p1Text);
      timers.advance(interval);
      expect(shown(c), p2Text);
      timers.advance(interval);
      expect(shown(c), p3Text);
      timers.advance(interval);
      expect(shown(c), p1Text);
    });

    test('AC3_single_item_queue_stays_on_same_text', () async {
      // น้ำครบ, ก้าวครบ, อาหาร 500 kcal (25 < 50) → เหลือ P4 อย่างเดียว
      final (_, c) = await make(cups: 8, steps: 8000, kcal: 500);
      expect(shown(c), p4Text);
      timers.advance(interval * 3);
      expect(shown(c), p4Text);
    });

    test('AC3_EDGE_empty_queue_no_alert', () async {
      final (_, c) = await make(cups: 8, steps: 8000, kcal: 2000);
      expect(c.currentAlert, isNull);
      timers.advance(interval * 2);
      expect(c.currentAlert, isNull);
    });
  });

  group('AC-3 / EC-2 คัดออกจากคิวทันที (Q-17: ไม่รอ 5 วินาที)', () {
    test('EC2_P2_resolved_by_logging_water_switches_to_P3_immediately',
        () async {
      final (s, c) = await make(cups: 7);
      timers.advance(const Duration(seconds: 2));
      expect(shown(c), p2Text);
      await s.water.logWater(); // 8 แก้ว = 100% (บันทึกล่าสุด 09:00 ผ่าน 5 นาทีแล้ว)
      expect(c.snapshot.waterScore, 100);
      expect(shown(c), p3Text, reason: 'ไม่ต้องรอครบ 5 วินาที');
      expect(c.snapshot.alerts.map((a) => a.text), isNot(contains(p2Text)));
    });

    test('DECIDED_Q19_after_removal_next_rotation_counts_5s_anew', () async {
      final (s, c) = await make(cups: 7);
      timers.advance(const Duration(seconds: 2));
      await s.water.logWater();
      expect(shown(c), p3Text);
      timers.advance(interval - ms1);
      expect(shown(c), p3Text);
      timers.advance(ms1);
      expect(shown(c), p4Text);
    });

    test('EC2_P3_resolved_by_steps_switches_to_P4_immediately', () async {
      final (s, c) = await make(cups: 8, steps: 7000);
      expect(shown(c), p3Text);
      timers.advance(const Duration(seconds: 3));
      await s.steps.addSteps(1000); // 8,000 = 100%
      expect(shown(c), p4Text);
    });

    test('EC2_GR4_P1_removed_while_showing_switches_to_P2_immediately',
        () async {
      // Q-2: แอปไม่มีการลบ/แก้มื้อ — จำลอง "แก้ปัญหาอาหารสำเร็จ" ด้วยเป้าที่เปลี่ยนจากโปรไฟล์
      // (ชาย 25 ปี 50 kg 175 cm → BMI 16.3 → 2,400 kcal) ทำให้ 2,150 ไม่เกินเป้า > 100 อีก
      final (s, c) = await make(kcal: 2150);
      timers.advance(const Duration(seconds: 1));
      expect(shown(c), p1Text);
      s.profileSource.profile = profileOf(weightKg: 50);
      await s.food.refreshProfile();
      expect(s.food.isOverLimit, isFalse);
      expect(shown(c), p2Text, reason: 'game-rules §4: ข้ามไป P2 ทันที');
    });

    test('EC2_last_problem_resolved_queue_empty_alert_hidden', () async {
      final (s, c) = await make(cups: 7, steps: 8000, kcal: 2000);
      expect(shown(c), p2Text);
      await s.water.logWater();
      expect(c.currentAlert, isNull);
    });

    test('DECIDED_Q3_P4_removed_when_meal_logged_reaches_50', () async {
      final (s, c) = await make(cups: 8, steps: 8000);
      expect(shown(c), p4Text);
      await s.food.logNutrition(const FoodNutrition(calories: 500));
      expect(shown(c), p4Text, reason: 'บันทึกแล้วแต่ 25% < 50 → ยังอยู่ (Q-3)');
      await s.food.logNutrition(const FoodNutrition(calories: 500));
      expect(s.food.totalCalories, 1000);
      expect(c.currentAlert, isNull, reason: '50% → หลุดคิว');
    });

    test('DECIDED_Q19_new_P1_enters_queue_shows_highest_priority', () async {
      final (s, c) = await make(kcal: 2000);
      expect(shown(c), p2Text);
      await s.food.logNutrition(const FoodNutrition(calories: 150)); // 2,150
      expect(shown(c), p1Text);
    });
  });

  group('AC-5 / EC-3 ข้าม 05:00 (D-2 เวลาเครื่อง)', () {
    test('AC5_EC3_EDGE_04_59_59_keeps_day_05_00_00_resets_all', () async {
      now = t(15, 4, 59, 59);
      final (_, c) = await make(cups: 8, steps: 8000, kcal: 2000);
      await c.refreshDay();
      expect(c.snapshot.totalScore, 100, reason: '04:59:59 ยังเป็นรอบวันเดิม');
      expect(c.currentAlert, isNull);
      now = t(15, 5);
      await c.refreshDay();
      final s = c.snapshot;
      expect([s.foodScore, s.stepsScore, s.waterScore, s.totalScore],
          [0, 0, 0, 0]);
      expect(s.mood, DashboardPetMood.crying);
      expect(shown(c), p2Text, reason: 'วันใหม่เริ่มที่ข้อความลำดับแรกของคิว');
    });

    test('EC3_rollover_clears_P1_and_red_bar', () async {
      final (_, c) = await make(cups: 3, kcal: 2150);
      expect(c.snapshot.isFoodOverLimit, isTrue);
      expect(shown(c), p1Text);
      now = t(15, 5);
      await c.refreshDay();
      expect(c.snapshot.isFoodOverLimit, isFalse);
      expect(c.snapshot.alerts.first, DashboardAlert.drinkWater);
      expect(shown(c), p2Text);
    });

    test('AC5_open_after_05_00_with_yesterday_data_shows_new_day', () async {
      now = t(15, 6);
      final (_, c) = await make(cups: 8, steps: 8000, kcal: 2000);
      expect(c.snapshot.totalScore, 0);
      expect(c.snapshot.mood, DashboardPetMood.crying);
    });
  });

  group('EDGE ข้อมูลว่าง / เสีย / timer', () {
    test('EDGE_first_open_no_data_all_zero_P2_first', () async {
      final s = makeSources(clock: () => now, foodTimers: foodTimers);
      await s.loadAll();
      final c = DashboardController(
          water: s.water, steps: s.steps, food: s.food, timerFactory: timers.create);
      dash = c;
      expect(c.snapshot.totalScore, 0);
      expect(c.snapshot.alerts.map((a) => a.text), [p2Text, p3Text, p4Text]);
      expect(shown(c), p2Text);
    });

    test('EC4_EDGE_corrupt_storage_all_three_fallback_zero', () async {
      final s = makeSources(
        clock: () => now,
        foodTimers: foodTimers,
        waterRepo: BrokenWaterRepository(),
        stepsRepo: BrokenStepsRepository(),
        foodRepo: BrokenFoodRepository(),
      );
      await s.loadAll();
      final c = DashboardController(
          water: s.water, steps: s.steps, food: s.food, timerFactory: timers.create);
      dash = c;
      expect(c.isLoaded, isTrue);
      expect(c.snapshot.totalScore, 0);
      expect(c.snapshot.mood, DashboardPetMood.crying);
    });

    test('UI_dispose_cancels_alert_timer', () async {
      final (_, c) = await make();
      expect(timers.activeCount, 1);
      c.dispose();
      dash = null;
      expect(timers.activeCount, 0);
    });
  });
}
