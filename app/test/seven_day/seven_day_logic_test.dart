// Unit tests: SevenDayLogic / SevenDayRules (pure Dart — ส่งเวลาเข้า logic เอง ไม่ใช้เวลาจริง)
// ค่าคาดหวังมาจาก docs/7day/requirements.md AC-1..AC-6 / EC-1..EC-5, game-rules.md §1, §1.1, §3, §4,
// ux-flow.md §2, ui-spec.md §2.2/§3/§6 และข้อตัดสิน owner (รอบ 1–3) — ไม่ได้ลอกจากโค้ด
// ชื่อเทสต์: AC#_ / EC#_ ตามเอกสาร · GR#_ ตัวเลขจาก game-rules §# · EDGE_ edge case บังคับ ·
// DECIDED_ ตามข้อตัดสิน owner (Q-x = ค่าที่ ui-spec เลือก, R3_A# = สมมติฐาน dev ที่ owner รับรอบ 3)
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/food/food_models.dart';
import 'package:petpal_health/features/seven_day/seven_day_logic.dart';
import 'package:petpal_health/features/seven_day/seven_day_models.dart';
import 'package:petpal_health/features/seven_day/seven_day_rules.dart';
import 'package:petpal_health/features/steps/steps_logic.dart';
import 'package:petpal_health/features/steps/steps_models.dart';
import 'package:petpal_health/features/water/water_logic.dart';
import 'package:petpal_health/features/water/water_models.dart';

import 'seven_day_test_helpers.dart';

/// snapshot ณ เวลา [now] จากข้อมูลรายวัน (Day 0 = [base]) — Day 0 ป้าย Overeating = kcal > 2,100
SevenDaySnapshot snap(
  Map<int, DayData> data, {
  int base = today,
  DateTime? now,
  List<DailyWaterRecord> extraWater = const [],
  List<DailyStepsRecord> extraSteps = const [],
  List<DailyFoodRecord> extraFood = const [],
}) {
  final s = statesFor(data,
      base: base,
      extraWater: extraWater,
      extraSteps: extraSteps,
      extraFood: extraFood);
  final k0 = data[0]?.kcal ?? 0;
  return SevenDayLogic.snapshot(
    now: now ?? t(base, 10),
    waterHistory: s.water.history,
    steps: s.steps,
    food: s.food,
    foodCurrentOverLimit: k0 > docFoodTarget + docOverLimitKcal,
  );
}

String avgW(SevenDaySnapshot s) => SevenDayLogic.avgWaterText(s);
String avgS(SevenDaySnapshot s) => SevenDayLogic.avgStepsText(s);
String avgF(SevenDaySnapshot s) => SevenDayLogic.avgFoodText(s);

void main() {
  // =========================================================================
  // GR1 ค่าหลัก + ข้อความตรงตัว
  // =========================================================================
  group('GR1 ค่าหลัก game-rules §1 / ข้อความ §1.1', () {
    test('GR1_constants_match_game_rules_and_decisions', () {
      expect(SevenDayRules.maxHistoryDays, docMaxHistoryDays);
      expect(SevenDayRules.dateNormalizerHour, docDateNormalizerHour);
      expect(SevenDayRules.waterGoalThreshold, docWaterThreshold);
      expect(SevenDayRules.stepsGoalThreshold, docStepsThreshold);
      expect(SevenDayRules.localCacheRetentionDays, docRetentionDays);
      expect(SevenDayRules.averageDecimals, 1);
      expect(SevenDayRules.accordionDuration, docAccordion);
      expect(Duration(seconds: SevenDayRules.dayCheckIntervalSeconds), docDayCheck);
      expect(SevenDayRules.emptyIconSize, docEmptyIconSize);
    });

    test('GR1_1_coaching_texts_exact', () {
      expect(SevenDayRules.prefixInconsistent, prefixText);
      expect(SevenDayRules.warningLowWater('6.5'), lowWaterText('6.5'));
      expect(SevenDayRules.warningLowSteps('7,240.5'), lowStepsText('7,240.5'));
      expect(SevenDayRules.statusEmpty7Days, emptyText);
      expect(SevenDayRules.statusNoDailyData, noDataText);
      expect(SevenDayRules.screenTitle, screenTitle);
      expect(SevenDayRules.summaryTitle, summaryTitle);
      expect(SevenDayRules.entryTooltip, entryTooltip);
      // ไม่มี " ครอบข้อความ (ui-spec §2)
      for (final x in [
        SevenDayRules.prefixInconsistent,
        SevenDayRules.statusEmpty7Days,
        SevenDayRules.statusNoDailyData,
      ]) {
        expect(x.contains('"'), isFalse, reason: x);
      }
    });
  });

  // =========================================================================
  // AC-1 7 วันรวมวันนี้ / Date Normalizer 05:00 (US-3, D-4)
  // =========================================================================
  group('AC-1 / US-3 หน้าต่าง 7 วัน', () {
    test('AC1_DECIDED_seven_days_day0_is_today_then_back_6_days', () {
      final s = snap({});
      expect(s.days.length, docMaxHistoryDays);
      expect(s.today, d(31));
      for (var i = 0; i < 7; i++) {
        expect(s.days[i].offset, i);
        expect(s.days[i].date, d(31 - i), reason: 'Day -$i');
      }
      expect(s.days.first.isToday, isTrue);
      expect(s.days.skip(1).any((e) => e.isToday), isFalse);
    });

    test('AC1_EDGE_day_older_than_day_minus_6_not_in_window', () {
      // Day −7 (24 ต.ค.) มีข้อมูล → ไม่อยู่ใน 7 วัน ไม่นับใน count / ค่าเฉลี่ย
      final s = snap({0: const DayData(cups: 8)},
          extraWater: [DailyWaterRecord(date: d(24), cups: 1)],
          extraSteps: [DailyStepsRecord(date: d(24), steps: 100, goal: 8000)],
          extraFood: [
            DailyFoodRecord(
                date: d(24), totalCalories: 50, targetCalories: 2000, isOverTarget: false)
          ]);
      expect(s.days.map((e) => e.date), isNot(contains(d(24))));
      expect(s.recordedDays, 1);
      expect(avgW(s), avgWaterLine('8.0'));
      expect(avgS(s), avgStepsLine(null));
      expect(avgF(s), avgFoodLine(null));
    });

    test('US3_EDGE_logical_day_04_59_59_previous_05_00_00_new', () {
      // ไม่มี state.day ของ steps / food → ใช้รอบ 05:00 ของ now
      expect(SevenDayLogic.currentDay(now: t(31, 4, 59, 59)), d(30));
      expect(SevenDayLogic.currentDay(now: t(31, 5)), d(31));
      expect(SevenDayLogic.currentDay(now: t(31, 0)), d(30));
      expect(SevenDayLogic.currentDay(now: t(31, 23, 59, 59)), d(31));
    });

    test('DECIDED_R3_A1_day0_follows_state_day_of_steps_food', () {
      // สมมติฐาน dev ข้อ 1 (owner รอบ 3): Day 0 ยึด state.day ล่าสุดของ steps / food
      expect(
          SevenDayLogic.currentDay(
              now: t(31, 10), stepsDay: d(30), foodDay: d(31)),
          d(31));
      expect(
          SevenDayLogic.currentDay(
              now: t(31, 10), stepsDay: d(31), foodDay: d(30)),
          d(31));
    });

    test('EDGE_cross_month_window_dates', () {
      // Day 0 = 2 พ.ย. → Day −6 = 27 ต.ค.
      final s = SevenDayLogic.buildDays(
        today: DateTime(2026, 11, 2),
        waterHistory: const [],
        steps: StepsState.initial,
        food: const FoodState(),
        foodCurrentOverLimit: false,
      );
      expect(s.map((e) => e.date).toList(), [
        DateTime(2026, 11, 2),
        DateTime(2026, 11, 1),
        d(31),
        d(30),
        d(29),
        d(28),
        d(27),
      ]);
    });

    test('UI_day_titles_today_yesterday_thai_weekday_date_str', () {
      // Q-11: Day 0 วันนี้, Day −1 เมื่อวาน, −2..−6 ชื่อวันไทย · dd/MM/yyyy
      final s = snap({});
      final expected = [
        'วันนี้, 31/10/2026',
        'เมื่อวาน, 30/10/2026',
        'วันพฤหัสบดี, 29/10/2026',
        'วันพุธ, 28/10/2026',
        'วันอังคาร, 27/10/2026',
        'วันจันทร์, 26/10/2026',
        'วันอาทิตย์, 25/10/2026',
      ];
      expect(s.days.map(SevenDayLogic.dayTitle).toList(), expected);
    });
  });

  // =========================================================================
  // AC-2 / EC-2 วันไม่มีข้อมูล — ไม่นับเป็นตัวหาร (game-rules §3)
  // =========================================================================
  group('AC-2 / EC-2 / GR3 วันไม่มีข้อมูล', () {
    test('GR3_row1_water_7_8_9_over_3_days_avg_8_0_not_divided_by_7', () {
      final s = snap({
        0: const DayData(cups: 7),
        2: const DayData(cups: 8),
        5: const DayData(cups: 9),
      });
      // Count = 3, Sum = 24.0 → 8.0 (ถ้าหาร 7 จะได้ 3.4)
      expect(s.avgWater, 8.0);
      expect(avgW(s), avgWaterLine('8.0'));
      expect(s.showsLowWater, isFalse, reason: '8.0 ไม่ < 8.0');
    });

    test('GR3_row2_steps_5000_6000_over_2_days_avg_5500_0', () {
      final s = snap({
        1: const DayData(steps: 5000),
        4: const DayData(steps: 6000),
      });
      expect(s.avgSteps, 5500.0);
      // Q-12 คั่นหลักพัน
      expect(avgS(s), avgStepsLine('5,500.0'));
      expect(s.showsLowSteps, isTrue);
      expect(SevenDayLogic.lowStepsText(s), lowStepsText('5,500.0'));
    });

    test('GR3_row3_AC2_no_record_day_no_data_and_not_counted', () {
      final s = snap({
        0: const DayData(cups: 6),
        3: const DayData(cups: 7),
      });
      expect(s.recordedDays, 2);
      for (final i in [1, 2, 4, 5, 6]) {
        expect(s.days[i].hasRecord, isFalse, reason: 'Day -$i');
        expect(SevenDayLogic.collapsedSummary(s.days[i]), noDataText);
      }
      expect(avgW(s), avgWaterLine('6.5'), reason: '13 / 2 (ไม่ใช่ 13 / 7)');
    });

    test('GR3_row4_AC6_all_empty_sum0_count0_empty_status', () {
      final s = snap({});
      expect(s.recordedDays, 0);
      expect(s.status, SevenDayStatus.empty);
      expect(s.isEmpty, isTrue);
      expect(s.showsInconsistentPrefix, isFalse);
      expect(s.showsLowWater, isFalse);
      expect(s.showsLowSteps, isFalse);
      expect(SevenDayLogic.coachingLines(s), isEmpty, reason: 'Q-3 EMPTY ซ่อน SUMMARY');
    });

    test('DECIDED_Q2_per_category_divisor_days_with_that_category', () {
      // Q-2: count = วันที่หมวดใด > 0 · ตัวหารรายหมวด = วันที่หมวดนั้น > 0
      final s = snap({
        0: const DayData(cups: 4, steps: 0, kcal: 1000),
        1: const DayData(cups: 0, steps: 9000, kcal: 0),
        2: const DayData(cups: 6, steps: 7000, kcal: 2000),
      });
      expect(s.recordedDays, 3);
      expect(avgW(s), avgWaterLine('5.0'), reason: '(4 + 6) / 2');
      expect(avgS(s), avgStepsLine('8,000.0'), reason: '(9000 + 7000) / 2');
      expect(avgF(s), avgFoodLine('1,500.0'), reason: '(1000 + 2000) / 2');
    });

    test('DECIDED_Q2_steps_record_zero_is_no_record', () {
      // ui-spec §2.2: steps record 0 ก้าว (เปิดแอปแต่ไม่เดิน) → ไม่มีบันทึก
      final s = snap({
        0: const DayData(cups: 8),
        1: const DayData(stepsRecordZero: true),
      });
      expect(s.days[1].hasRecord, isFalse);
      expect(s.recordedDays, 1);
      expect(avgS(s), avgStepsLine(null));
    });

    test('DECIDED_Q8_category_without_data_shows_no_data_and_no_warning', () {
      // มีแต่อาหาร → น้ำ / ก้าว ไม่มีข้อมูล → 「ไม่มีข้อมูล」 และไม่เตือน (ไม่ใช่ 0.0 < 8.0)
      final s = snap({0: const DayData(kcal: 1500)});
      expect(avgW(s), avgWaterLine(null));
      expect(avgS(s), avgStepsLine(null));
      expect(avgF(s), avgFoodLine('1,500.0'));
      expect(s.showsLowWater, isFalse);
      expect(s.showsLowSteps, isFalse);
      expect(SevenDayLogic.coachingLines(s), [prefixText]);
      // ในวันที่มีบันทึก หมวดที่ไม่มีแสดง 0
      expect(SevenDayLogic.dayStepsText(s.days[0]), dayStepsLine(0));
      expect(SevenDayLogic.dayWaterText(s.days[0]), dayWaterLine(0));
      expect(SevenDayLogic.dayFoodText(s.days[0]), dayFoodLine(1500));
    });

    test('DECIDED_Q16_day0_counted_only_when_category_above_0', () {
      // Day 0 ยังไม่บันทึกน้ำ → ไม่ดึงค่าเฉลี่ยลง · บันทึกแล้วนับ
      final before = snap({
        0: const DayData(steps: 100),
        1: const DayData(cups: 8),
        2: const DayData(cups: 8),
      });
      expect(avgW(before), avgWaterLine('8.0'));
      final after = snap({
        0: const DayData(cups: 2, steps: 100),
        1: const DayData(cups: 8),
        2: const DayData(cups: 8),
      });
      expect(avgW(after), avgWaterLine('6.0'), reason: '(2 + 8 + 8) / 3');
    });
  });

  // =========================================================================
  // AC-3 / EC-1 ค่าเฉลี่ย ทศนิยม 1 ตำแหน่ง + prefix / สถานะ
  // =========================================================================
  group('AC-3 / EC-1 ค่าเฉลี่ย + สถานะ', () {
    test('AC3_examples_6_5_cups_and_7_240_5_steps', () {
      // AC-3 ตัวอย่าง "6.5 แก้ว, 7,240.5 ก้าว": 6 + 7 = 13 / 2 · 7,240 + 7,241 = 14,481 / 2
      final s = snap({
        0: const DayData(cups: 6, steps: 7240),
        1: const DayData(cups: 7, steps: 7241),
      });
      expect(avgW(s), avgWaterLine('6.5'));
      expect(avgS(s), avgStepsLine('7,240.5'));
    });

    test('AC3_one_decimal_always_and_food_comma', () {
      // ui-spec §5: 1,850.0 kcal · ทศนิยม 1 ตำแหน่งแม้ลงตัว
      final s = snap({
        0: const DayData(cups: 9, kcal: 1700),
        1: const DayData(cups: 9, kcal: 2000),
      });
      expect(avgW(s), avgWaterLine('9.0'));
      expect(avgF(s), avgFoodLine('1,850.0'));
      // ปัด 1 ตำแหน่ง: 10 / 3 = 3.333 → 3.3 · 20 / 3 = 6.667 → 6.7
      expect(SevenDayLogic.formatAverage(10 / 3), '3.3');
      expect(SevenDayLogic.formatAverage(20 / 3), '6.7');
      expect(SevenDayLogic.formatAverage(1234567 / 2), '617,283.5');
    });

    test('AC3_EC1_status_normal_7_inconsistent_1_to_6_empty_0', () {
      expect(SevenDayLogic.statusFor(7), SevenDayStatus.normal);
      for (var c = 1; c <= 6; c++) {
        expect(SevenDayLogic.statusFor(c), SevenDayStatus.inconsistent, reason: '$c');
      }
      expect(SevenDayLogic.statusFor(0), SevenDayStatus.empty);
    });

    test('AC3_EDGE_count_7_no_prefix_count_6_prefix', () {
      final full = snap(allDays(const DayData(cups: 8, steps: 8000)));
      expect(full.recordedDays, 7);
      expect(full.status, SevenDayStatus.normal);
      expect(full.showsInconsistentPrefix, isFalse);
      expect(SevenDayLogic.coachingLines(full), isEmpty, reason: 'Q-7 ไม่มี coaching กรณีปกติ');

      final six = snap({
        for (var i = 0; i < 6; i++) i: const DayData(cups: 8, steps: 8000),
      });
      expect(six.recordedDays, 6);
      expect(six.status, SevenDayStatus.inconsistent);
      expect(SevenDayLogic.coachingLines(six), [prefixText],
          reason: 'Q-7: ไม่เข้าเกณฑ์เตือน → prefix อย่างเดียว');
    });

    test('EC1_new_user_single_day_inconsistent_avg_from_1_day', () {
      final s = snap({0: const DayData(cups: 3, steps: 2500)});
      expect(s.recordedDays, 1);
      expect(s.status, SevenDayStatus.inconsistent);
      expect(avgW(s), avgWaterLine('3.0'));
      expect(avgS(s), avgStepsLine('2,500.0'));
      expect(SevenDayLogic.coachingLines(s),
          [prefixText, lowWaterText('3.0'), lowStepsText('2,500.0')]);
    });

    test('GR1_1_order_prefix_then_water_then_steps', () {
      final s = snap({
        0: const DayData(cups: 6, steps: 7240),
        1: const DayData(cups: 7, steps: 7241),
      });
      expect(SevenDayLogic.coachingLines(s),
          [prefixText, lowWaterText('6.5'), lowStepsText('7,240.5')]);
    });
  });

  // =========================================================================
  // AC-4 / AC-5 เกณฑ์ < 8.0 / < 8,000.0 (Q-10: เทียบค่าที่ปัดแล้ว)
  // =========================================================================
  group('AC-4 / AC-5 เกณฑ์เตือน', () {
    test('AC4_EDGE_normal_7_days_55_cups_7_9_warns_56_cups_8_0_not', () {
      // 55 / 7 = 7.857 → 7.9 < 8.0 เตือน · 56 / 7 = 8.0 ไม่เตือน (± 1 แก้ว)
      final low = snap({
        for (var i = 0; i < 7; i++) i: DayData(cups: i == 0 ? 7 : 8, steps: 8000),
      });
      expect(low.status, SevenDayStatus.normal);
      expect(avgW(low), avgWaterLine('7.9'));
      expect(SevenDayLogic.coachingLines(low), [lowWaterText('7.9')]);

      final ok = snap(allDays(const DayData(cups: 8, steps: 8000)));
      expect(avgW(ok), avgWaterLine('8.0'));
      expect(ok.showsLowWater, isFalse);
    });

    test('AC5_EDGE_normal_7_days_55999_steps_7999_9_warns_56000_not', () {
      // 55,999 / 7 = 7,999.857 → 7,999.9 เตือน · 56,000 / 7 = 8,000.0 ไม่เตือน (± 1 ก้าว)
      final low = snap({
        for (var i = 0; i < 7; i++) i: DayData(cups: 8, steps: i == 0 ? 7999 : 8000),
      });
      expect(avgS(low), avgStepsLine('7,999.9'));
      expect(SevenDayLogic.coachingLines(low), [lowStepsText('7,999.9')]);

      final ok = snap(allDays(const DayData(cups: 8, steps: 8000)));
      expect(avgS(ok), avgStepsLine('8,000.0'));
      expect(ok.showsLowSteps, isFalse);
    });

    test('DECIDED_Q10_EDGE_water_7_96_shows_8_0_no_warning_7_94_shows_7_9_warns', () {
      expect(SevenDayLogic.formatAverage(7.96), '8.0');
      expect(SevenDayLogic.isLowWater(7.96), isFalse);
      expect(SevenDayLogic.formatAverage(7.94), '7.9');
      expect(SevenDayLogic.isLowWater(7.94), isTrue);
      expect(SevenDayLogic.isLowWater(8.0), isFalse);
      expect(SevenDayLogic.isLowWater(7.9), isTrue);
      expect(SevenDayLogic.isLowWater(null), isFalse, reason: 'Q-8');
    });

    test('DECIDED_Q10_EDGE_steps_7999_96_shows_8000_0_no_warning', () {
      expect(SevenDayLogic.formatAverage(7999.96), '8,000.0');
      expect(SevenDayLogic.isLowSteps(7999.96), isFalse);
      expect(SevenDayLogic.formatAverage(7999.94), '7,999.9');
      expect(SevenDayLogic.isLowSteps(7999.94), isTrue);
      expect(SevenDayLogic.isLowSteps(8000.0), isFalse);
      expect(SevenDayLogic.isLowSteps(null), isFalse, reason: 'Q-8');
    });

    test('AC4_AC5_val_in_warning_equals_average_line', () {
      final s = snap({
        0: const DayData(cups: 1, steps: 100),
        1: const DayData(cups: 2, steps: 201),
        2: const DayData(cups: 2, steps: 300),
      });
      // 5 / 3 = 1.667 → 1.7 · 601 / 3 = 200.333 → 200.3
      expect(avgW(s), avgWaterLine('1.7'));
      expect(SevenDayLogic.lowWaterText(s), lowWaterText('1.7'));
      expect(avgS(s), avgStepsLine('200.3'));
      expect(SevenDayLogic.lowStepsText(s), lowStepsText('200.3'));
    });
  });

  // =========================================================================
  // ข้อมูลรายวัน / ป้าย / แหล่งข้อมูล (ui-spec §2.2, D-5)
  // =========================================================================
  group('ข้อมูลรายวัน (ui-spec §2.2)', () {
    test('DECIDED_D5_day0_from_current_state_past_from_history', () {
      final s = snap({
        0: const DayData(cups: 3, steps: 4321, kcal: 1234),
        1: const DayData(cups: 5, steps: 5500, kcal: 1250),
      });
      final d0 = s.days[0];
      expect([d0.waterCups, d0.steps, d0.calories], [3, 4321, 1234]);
      final d1 = s.days[1];
      expect([d1.waterCups, d1.steps, d1.calories], [5, 5500, 1250]);
      expect(SevenDayLogic.collapsedSummary(d1), collapsedLine(5500, 5, 1250));
      expect(SevenDayLogic.collapsedSummary(d1), '5,500 ก้าว · 5 แก้ว · 1,250 kcal');
    });

    test('UI_tags_day0_meals_and_over_limit_past_from_record', () {
      final s = snap({
        0: const DayData(kcal: docFoodTarget + docOverLimitKcal + 1, sodium: true, sugar: true),
        1: const DayData(kcal: 2500, sodium: true, over: true),
        2: const DayData(kcal: 1000, sugar: true),
      });
      final d0 = s.days[0];
      expect([d0.highSodium, d0.highSugar, d0.overeating], [true, true, true]);
      final d1 = s.days[1];
      expect([d1.highSodium, d1.highSugar, d1.overeating], [true, false, true],
          reason: 'Q-20 ใช้ isOverTarget ที่เก็บไว้');
      final d2 = s.days[2];
      expect([d2.highSodium, d2.highSugar, d2.overeating], [false, true, false]);
      expect(s.days[3].hasTags, isFalse);
    });

    test('EDGE_food_over_limit_threshold_2100_no_tag_2101_tag', () {
      // food OVER_LIMIT: > target + 100 (Overeating ใช้เงื่อนไขเดียวกับหลอดแดงของ food — ui-spec §2.2)
      expect(snap({0: const DayData(kcal: 2100)}).days[0].overeating, isFalse);
      expect(snap({0: const DayData(kcal: 2101)}).days[0].overeating, isTrue);
    });

    test('DECIDED_R3_A4_EDGE_negative_values_count_as_0', () {
      // สมมติฐาน dev ข้อ 4 (owner รอบ 3): ค่าติดลบนับเป็น 0 → ไม่ใช่วันที่มีบันทึก
      final s = snap({0: const DayData(cups: 8)},
          extraWater: [DailyWaterRecord(date: d(30), cups: -3)],
          extraSteps: [DailyStepsRecord(date: d(29), steps: -500, goal: 8000)],
          extraFood: [
            DailyFoodRecord(
                date: d(28), totalCalories: -10, targetCalories: 2000, isOverTarget: false)
          ]);
      expect(s.days[1].waterCups, 0);
      expect(s.days[2].steps, 0);
      expect(s.days[3].calories, 0);
      for (final i in [1, 2, 3]) {
        expect(s.days[i].hasRecord, isFalse, reason: 'Day -$i');
      }
      expect(s.recordedDays, 1);
      expect(avgW(s), avgWaterLine('8.0'));
      expect(avgS(s), avgStepsLine(null));
      expect(avgF(s), avgFoodLine(null));
    });

    test('EDGE_max_count_never_above_7_with_30_days_of_data', () {
      // ข้อมูล 30 วัน (retention food) → หน้าต่างยังมีแค่ 7 วัน count ≤ 7
      final s = snap({for (var i = 0; i < 30; i++) i: const DayData(cups: 8, steps: 8000, kcal: 2000)});
      expect(s.days.length, 7);
      expect(s.recordedDays, 7);
      expect(s.status, SevenDayStatus.normal);
    });

    test('EDGE_first_open_no_state_day_uses_logical_day_and_empty', () {
      // เปิดแอปครั้งแรก: steps / food ยังไม่มี state.day · ไม่มีประวัติ
      final s = SevenDayLogic.snapshot(
        now: t(31, 4, 59, 59),
        waterHistory: const [],
        steps: StepsState.initial,
        food: const FoodState(),
        foodCurrentOverLimit: false,
      );
      expect(s.today, d(30));
      expect(s.status, SevenDayStatus.empty);
      expect(s.days.every((e) => !e.hasRecord), isTrue);
    });

    test('DECIDED_Q19_water_steps_history_not_pruned_at_30_days', () {
      // Q-19: เก็บ 30 วันเฉพาะ food — water / steps ไม่ตัดประวัติ (record 60 วันก่อนยังอยู่หลังข้ามรอบ)
      final old = DateTime(2026, 9, 1);
      final water = WaterLogic.logWater(
          WaterState(
              cups: 2,
              lastLoggedAt: t(30, 9),
              history: [DailyWaterRecord(date: old, cups: 5), DailyWaterRecord(date: d(30), cups: 2)]),
          t(31, 9));
      expect(water.state.history.map((r) => r.date), containsAll([old, d(30), d(31)]));
      final steps = StepsLogic.applyDayRollover(
          StepsState.initial.copyWith(
              steps: 3000,
              day: d(30),
              lastSeenAt: t(30, 20),
              history: [DailyStepsRecord(date: old, steps: 7000, goal: 8000)]),
          t(31, 6));
      expect(steps.history.map((r) => r.date), containsAll([old, d(30)]));
    });

    test('EC4_windowKey_changes_with_day0', () {
      expect(SevenDayLogic.windowKey(d(30)), 'seven_day_window_2026-10-30');
      expect(SevenDayLogic.windowKey(d(31)), 'seven_day_window_2026-10-31');
    });
  });
}
