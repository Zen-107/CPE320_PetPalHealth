// Unit tests: logic เกมของ food (pure Dart)
// อ้างอิง requirements.md §3–§4 (AC/EC), game-rules.md §1–§4 และข้อตัดสิน owner
// (OQ-1, Q-9, Q-13, Q-14, Q-17 — DECIDED owner ชั่วคราว) · เวลาเป็นค่าที่ส่งเข้า logic เท่านั้น
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/food/food_logic.dart';
import 'package:petpal_health/features/food/food_menu_table.dart';
import 'package:petpal_health/features/food/food_models.dart';
import 'package:petpal_health/features/food/food_nutrition_parser.dart';
import 'package:petpal_health/features/food/food_rules.dart';
import 'package:petpal_health/features/signup/signup_models.dart';
import 'package:petpal_health/shared/pet/pet.dart';

import 'food_test_helpers.dart';

int? target(int age, SignupGender g, double w, double h) =>
    FoodLogic.targetCalories(age: age, gender: g, weightKg: w, heightCm: h);

/// ส่วนสูง 200 cm → (h/100)² = 4 → BMI = w / 4 (ได้ค่าขอบพอดีโดยไม่มีเศษทศนิยม)
double wForBmi(double bmi) => bmi * 4;

void main() {
  group('GR1 ค่าหลัก game-rules §1', () {
    test('GR1_constants_match_game_rules', () {
      expect(FoodRules.aiParsingTimeoutSeconds, docAiTimeoutSeconds);
      expect(FoodRules.dailyResetHour, docResetHour);
      expect(FoodRules.dailyResetMinute, 0);
      expect(FoodRules.ageMin, docAgeMin);
      expect(FoodRules.ageMax, docAgeMax);
      expect(FoodRules.maleBaseTarget10to12, 1700);
      expect(FoodRules.femaleBaseTarget10to12, 1600);
      expect(FoodRules.maleBaseTarget13to15, 2100);
      expect(FoodRules.femaleBaseTarget13to15, 1800);
      expect(FoodRules.maleBaseTarget16to18, 2300);
      expect(FoodRules.femaleBaseTarget16to18, 1850);
      expect(FoodRules.maleBaseTarget19to50, 2000);
      expect(FoodRules.femaleBaseTarget19to50, 1600);
      expect(FoodRules.maleBaseTarget51up, 1800);
      expect(FoodRules.femaleBaseTarget51up, 1400);
      expect(FoodRules.fallbackBaseTargetAge1to9Male, 1700);
      expect(FoodRules.fallbackBaseTargetAge1to9Female, 1600);
      expect(FoodRules.bmiUnderweightThreshold, docBmiUnder);
      expect(FoodRules.bmiUnderweightBonus, docBmiBonus);
      expect(FoodRules.bmiOverweightThreshold, docBmiOver);
      expect(FoodRules.bmiOverweightPenalty, docBmiPenalty);
      expect(FoodRules.overLimitThreshold, docOverLimitThreshold);
      expect(FoodRules.fallbackDefaultCalories, docFallbackCalories);
      expect(FoodRules.eatingAnimationSeconds, docEatingSeconds);
      expect(FoodRules.toastSeconds, docToastSeconds);
      expect(FoodRules.toastAnchorOffset, docToastAnchor);
      // DECIDED 7day Q-19: food เก็บประวัติ 30 วัน (เดิม 7)
      expect(FoodRules.historyRetentionDays, docHistoryDays);
    });

    test('GR1_screen_texts_match_ux_flow', () {
      expect(FoodRules.addMealButtonText, addMealText);
      expect(FoodRules.profileCtaText, ctaText);
      expect(FoodRules.overLimitToastText, overLimitToast);
      expect(FoodRules.fullBadgeText, fullBadgeText);
      expect(FoodRules.mealInputHint, mealHint);
      expect(FoodRules.manualCalorieHint, manualHint);
      expect(FoodRules.mealSubmitText, submitText);
      expect(FoodRules.ageHint, ageHint);
      expect(FoodRules.weightHint, weightHint);
      expect(FoodRules.heightHint, heightHint);
      expect(FoodRules.profileSkipText, skipText);
      expect(FoodRules.profileSaveText, saveProfileText);
      expect(FoodRules.ageError, ageErrorText);
    });
  });

  group('AC-3 / US-5 รอบตัดวัน 05:00', () {
    test('AC3_03_00_of_day_15_is_logical_day_14', () {
      expect(FoodLogic.logicalDay(t(15, 3)), d(14));
    });

    test('AC3_EDGE_04_59_59_is_day_14_and_05_00_00_is_day_15', () {
      expect(FoodLogic.logicalDay(t(15, 4, 59, 59)), d(14));
      expect(FoodLogic.logicalDay(t(15, 4, 59, 59, 999)), d(14));
      expect(FoodLogic.logicalDay(t(15, 5)), d(15));
      expect(FoodLogic.logicalDay(t(15, 5, 0, 1)), d(15));
    });

    test('AC3_EDGE_midnight_does_not_start_new_day', () {
      expect(FoodLogic.logicalDay(t(14, 23, 59, 59)), d(14));
      expect(FoodLogic.logicalDay(t(15, 0)), d(14));
    });

    test('AC3_EDGE_month_boundary_1st_04_00_is_last_day_of_previous_month', () {
      expect(FoodLogic.logicalDay(DateTime(2026, 11, 1, 4)), DateTime(2026, 10, 31));
    });

    test('AC3_log_at_03_00_day_15_entry_date_is_day_14', () {
      final s = FoodState(day: d(14), totalCalories: 500, lastSeenAt: t(14, 22));
      final next = FoodLogic.logMeal(
          s, const FoodNutrition(calories: 400), t(15, 3),
          targetCalories: 2000);
      expect(next.day, d(14));
      expect(next.meals.single.date, d(14));
      expect(next.meals.single.toJson()['date'], '2026-10-14');
      expect(next.totalCalories, 900);
    });

    test('AC3_EDGE_first_ever_log_at_03_00_day_15_goes_to_day_14', () {
      final next = FoodLogic.logMeal(FoodState.initial,
          const FoodNutrition(calories: 400), t(15, 3));
      expect(next.day, d(14));
      expect(next.meals.single.date, d(14));
      expect(next.totalCalories, 400);
    });

    test('AC3_log_at_05_00_day_15_starts_day_15_from_0', () {
      final s = FoodState(day: d(14), totalCalories: 1800, lastSeenAt: t(15, 3));
      final next = FoodLogic.logMeal(
          s, const FoodNutrition(calories: 400), t(15, 5),
          targetCalories: 2000);
      expect(next.day, d(15));
      expect(next.totalCalories, 400);
      expect(next.meals.single.date, d(15));
    });

    test('GR4_rollover_at_05_00_resets_to_0_and_keeps_previous_day_in_history',
        () {
      final s = FoodState(day: d(14), totalCalories: 2500, lastSeenAt: t(14, 21));
      final before = FoodLogic.applyDayRollover(s, t(15, 4, 59, 59),
          targetCalories: 2000);
      expect(before.totalCalories, 2500);
      expect(before.day, d(14));
      final after =
          FoodLogic.applyDayRollover(s, t(15, 5), targetCalories: 2000);
      expect(after.day, d(15));
      expect(after.totalCalories, 0);
      expect(after.meals, isEmpty);
      final rec = after.history.singleWhere((r) => r.date == d(14));
      expect(rec.totalCalories, 2500);
      expect(rec.targetCalories, 2000);
      // 2,500 เกินเป้า 2,000 ชัดเจน (ทั้ง > target และ > target+100)
      expect(rec.isOverTarget, isTrue);
      final json = rec.toJson();
      expect(json['date'], '2026-10-14');
      expect(json['total_calories'], 2500);
      expect(json['is_over_target'], true);
    });

    test('GR4_rollover_under_target_day_is_not_over_target', () {
      final s = FoodState(day: d(14), totalCalories: 1500, lastSeenAt: t(14, 21));
      final after =
          FoodLogic.applyDayRollover(s, t(15, 6), targetCalories: 2000);
      expect(after.history.single.isOverTarget, isFalse);
    });

    test('US5_EDGE_DECIDED_Q19_history_keeps_recent_30_days_and_drops_older',
        () {
      // DECIDED (owner 7day รอบ 1 + รอบ 2 Q-19 + รอบ 3 ข้อ 2): food เก็บประวัติ 30 วันนับรวมวันนี้
      // วันปัจจุบัน 30 ต.ค. มีประวัติ 20 ก.ย.–29 ต.ค. → ตัดรอบเข้าวันที่ 31 ต.ค.
      // 30 วันรวมวันนี้ = 2–31 ต.ค. → ประวัติ (ไม่รวมวันนี้) = 2–30 ต.ค. · 20 ก.ย.–1 ต.ค. ถูกลบ
      final history = [
        for (var day = 20; day <= 30; day++)
          DailyFoodRecord(
              date: DateTime(2026, 9, day),
              totalCalories: day * 10,
              targetCalories: 2000,
              isOverTarget: false),
        for (var day = 1; day <= 29; day++)
          DailyFoodRecord(
              date: d(day),
              totalCalories: day * 10,
              targetCalories: 2000,
              isOverTarget: false),
      ];
      final s = FoodState(
          day: d(30), totalCalories: 1900, history: history, lastSeenAt: t(30, 20));
      final after =
          FoodLogic.applyDayRollover(s, t(31, 6), targetCalories: 2000);
      final days = after.history.map((r) => r.date).toSet();
      for (var day = 2; day <= 30; day++) {
        expect(days, contains(d(day)), reason: 'day $day ต้องยังอยู่');
      }
      expect(days, isNot(contains(d(1))), reason: '1 ต.ค. = วันที่ 31 ย้อนหลัง ต้องถูกลบ');
      for (var day = 20; day <= 30; day++) {
        expect(days, isNot(contains(DateTime(2026, 9, day))),
            reason: '$day ก.ย. ต้องถูกลบ');
      }
      expect(after.history.length, lessThanOrEqualTo(docHistoryDays));
    });
  });

  group('AC-4 / EC-5 อายุจำนวนเต็ม 1–120', () {
    test('AC4_age_25_5_is_rejected', () {
      expect(FoodLogic.ageStatus('25.5'), FoodFieldStatus.invalid);
    });

    test('EC5_age_20_5_is_rejected', () {
      expect(FoodLogic.ageStatus('20.5'), FoodFieldStatus.invalid);
    });

    test('AC4_EDGE_age_boundaries_0_invalid_1_valid_120_valid_121_invalid', () {
      expect(FoodLogic.ageStatus('0'), FoodFieldStatus.invalid);
      expect(FoodLogic.ageStatus('1'), FoodFieldStatus.valid);
      expect(FoodLogic.ageStatus('120'), FoodFieldStatus.valid);
      expect(FoodLogic.ageStatus('121'), FoodFieldStatus.invalid);
    });

    test('AC4_EDGE_non_integer_texts_rejected', () {
      for (final raw in ['25.0', '-3', 'abc', '2.5', '1e2']) {
        expect(FoodLogic.ageStatus(raw), FoodFieldStatus.invalid,
            reason: raw);
      }
    });

    test('AC4_EDGE_empty_age_is_not_an_error_but_cannot_save', () {
      expect(FoodLogic.ageStatus(''), FoodFieldStatus.empty);
      final v = FoodLogic.validateProfile(
          age: '', gender: SignupGender.male, weight: '65', height: '175');
      expect(v.showAgeError, isFalse);
      expect(v.canSave, isFalse);
    });

    test('AC4_decimal_age_blocks_save_even_with_other_fields_valid', () {
      final v = FoodLogic.validateProfile(
          age: '25.5', gender: SignupGender.male, weight: '65', height: '175');
      expect(v.showAgeError, isTrue);
      expect(v.canSave, isFalse);
      final ok = FoodLogic.validateProfile(
          age: '25', gender: SignupGender.male, weight: '65', height: '175');
      expect(ok.showAgeError, isFalse);
      expect(ok.canSave, isTrue);
    });

    test('DECIDED_Q14_weight_and_height_accept_decimals', () {
      final v = FoodLogic.validateProfile(
          age: '25',
          gender: SignupGender.female,
          weight: '52.5',
          height: '160.5');
      expect(v.weight, FoodFieldStatus.valid);
      expect(v.height, FoodFieldStatus.valid);
      expect(v.canSave, isTrue);
    });
  });

  group('AC-5 Base Target Reference Table', () {
    test('AC5_male_25_base_target_is_2000', () {
      expect(FoodLogic.baseTarget(25, SignupGender.male), 2000);
    });

    test('AC5_EDGE_every_band_min_and_max_age_male_and_female', () {
      for (final (lo, hi, male, female) in docBaseTable) {
        for (final age in [lo, hi]) {
          expect(FoodLogic.baseTarget(age, SignupGender.male), male,
              reason: 'male $age');
          expect(FoodLogic.baseTarget(age, SignupGender.female), female,
              reason: 'female $age');
        }
      }
    });

    test('GR5_age_1_to_9_uses_10_12_band_fallback', () {
      for (final age in [1, 5, 9]) {
        expect(FoodLogic.baseTarget(age, SignupGender.male), 1700);
        expect(FoodLogic.baseTarget(age, SignupGender.female), 1600);
      }
    });

    test('AC5_male_25_normal_bmi_target_is_2000', () {
      // 65 / 1.75² = 21.2 → ไม่ปรับ
      expect(target(25, SignupGender.male, 65, 175), 2000);
    });
  });

  group('AC-6 / AC-7 ปรับตาม BMI', () {
    test('GR1_bmi_formula_weight_over_height_m_squared', () {
      expect(FoodLogic.bmi(70, 175), closeTo(70 / (1.75 * 1.75), 1e-9));
      expect(FoodLogic.bmi(74, 200), closeTo(18.5, 1e-9));
    });

    test('AC6_bmi_below_18_5_adds_400', () {
      // 50 / 1.75² = 16.3
      expect(target(25, SignupGender.male, 50, 175), 2000 + 400);
      // หญิง 30 ปี 45 / 1.65² = 16.5 → 1,600 + 400
      expect(target(30, SignupGender.female, 45, 165), 1600 + 400);
    });

    test('AC6_EDGE_bmi_18_4_adds_400_bmi_18_5_exact_no_bonus', () {
      expect(target(25, SignupGender.male, wForBmi(18.4), 200), 2400);
      expect(target(25, SignupGender.male, wForBmi(18.5), 200), 2000);
    });

    test('AC7_bmi_at_least_23_subtracts_400', () {
      // 80 / 1.70² = 27.7
      expect(target(25, SignupGender.male, 80, 170), 2000 - 400);
      // หญิง 30 ปี 70 / 1.60² = 27.3 → 1,600 − 400
      expect(target(30, SignupGender.female, 70, 160), 1600 - 400);
    });

    test('AC7_EDGE_bmi_22_9_no_change_bmi_23_0_exact_subtracts_400', () {
      expect(target(25, SignupGender.male, wForBmi(22.9), 200), 2000);
      expect(target(25, SignupGender.male, wForBmi(23.0), 200), 1600);
    });

    test('AC6_AC7_adjustment_applies_on_other_bands', () {
      // ชาย 16 ปี (2,300) ผอม → 2,700 ; หญิง 60 ปี (1,400) อ้วน → 1,000
      expect(target(16, SignupGender.male, wForBmi(17), 200), 2700);
      expect(target(60, SignupGender.female, wForBmi(25), 200), 1000);
    });
  });

  group('AC-9 / AC-10 / EC-3 เกณฑ์ OVER_LIMIT (> target + 100)', () {
    test('GR3_examples_1900_and_2050_normal_2150_over_limit', () {
      expect(FoodLogic.isOverLimit(1900, 2000), isFalse);
      expect(FoodLogic.basePetState(1900, 2000), FoodPetState.normal);
      expect(FoodLogic.isOverLimit(2050, 2000), isFalse);
      expect(FoodLogic.basePetState(2050, 2000), FoodPetState.normal);
      expect(FoodLogic.isOverLimit(2150, 2000), isTrue);
      expect(FoodLogic.basePetState(2150, 2000), FoodPetState.overLimit);
    });

    test('AC9_EDGE_exactly_target_plus_100_is_normal', () {
      expect(FoodLogic.isOverLimit(2100, 2000), isFalse);
      expect(FoodLogic.basePetState(2100, 2000), FoodPetState.normal);
    });

    test('AC10_EDGE_target_plus_101_is_over_limit', () {
      expect(FoodLogic.isOverLimit(2101, 2000), isTrue);
      expect(FoodLogic.basePetState(2101, 2000), FoodPetState.overLimit);
    });

    test('AC9_EDGE_other_targets_boundary_plus_100_and_plus_101', () {
      for (final tg in [1000, 1600, 2400]) {
        expect(FoodLogic.isOverLimit(tg + 100, tg), isFalse, reason: '$tg');
        expect(FoodLogic.isOverLimit(tg + 101, tg), isTrue, reason: '$tg');
      }
    });

    test('DECIDED_Q9_no_target_is_never_over_limit', () {
      expect(FoodLogic.isOverLimit(99999, null), isFalse);
      expect(FoodLogic.basePetState(99999, null), FoodPetState.normal);
    });

    test('AC11_log_while_over_limit_gives_feeding_and_toast', () {
      expect(FoodLogic.transientStateForLog(wasOverLimit: true),
          FoodPetState.overLimitFeeding);
      expect(FoodLogic.toastForLog(wasOverLimit: true), overLimitToast);
    });

    test('GR2_log_while_not_over_limit_gives_eating_no_toast', () {
      expect(FoodLogic.transientStateForLog(wasOverLimit: false),
          FoodPetState.eating);
      expect(FoodLogic.toastForLog(wasOverLimit: false), isNull);
    });

    test('GR2_eating_lasts_2_seconds', () {
      expect(FoodLogic.transientDuration(FoodPetState.eating),
          const Duration(seconds: docEatingSeconds));
    });

    test('ASSUMPTION_Q3_over_limit_feeding_lasts_same_as_eating', () {
      expect(FoodLogic.transientDuration(FoodPetState.overLimitFeeding),
          const Duration(seconds: FoodRules.eatingAnimationSeconds));
    });

    test('GR2_state_codes_match_game_rules', () {
      expect(FoodPetState.normal.code, 'NORMAL');
      expect(FoodPetState.eating.code, 'EATING');
      expect(FoodPetState.overLimit.code, 'OVER_LIMIT');
      expect(FoodPetState.overLimitFeeding.code, 'OVER_LIMIT_FEEDING');
    });

    test('DECIDED_OQ1_states_map_to_PetCharacter_food_poses', () {
      expect(FoodLogic.poseFor(FoodPetState.normal), PetPose.foodNormal);
      expect(FoodLogic.poseFor(FoodPetState.eating), PetPose.foodEating);
      expect(FoodLogic.poseFor(FoodPetState.overLimit), PetPose.foodOverLimit);
      expect(FoodLogic.poseFor(FoodPetState.overLimitFeeding),
          PetPose.foodOverLimitFeeding);
    });
  });

  group('หลอดพลังงาน / ข้อความ S-1', () {
    test('UI_calorie_text_format_examples', () {
      expect(FoodLogic.calorieText(1900, 2000), calText(1900, 2000));
      expect(FoodLogic.calorieText(1900, 2000), '1,900 / 2,000 kcal');
      expect(FoodLogic.calorieText(2250, 2000), '2,250 / 2,000 kcal');
    });

    test('UI_empty_state_0_of_target', () {
      expect(FoodLogic.calorieText(0, 2000), '0 / 2,000 kcal');
      expect(FoodLogic.energyFraction(0, 2000), 0);
    });

    test('EDGE_energy_fraction_half_and_capped_at_1', () {
      expect(FoodLogic.energyFraction(1000, 2000), closeTo(0.5, 1e-9));
      expect(FoodLogic.energyFraction(2000, 2000), 1.0);
      expect(FoodLogic.energyFraction(2250, 2000), 1.0);
    });
  });

  group('AC-1 / AC-2 / EC-1 ผลโภชนาการ', () {
    test('AC1_parse_example_json_from_requirements', () {
      expect(
          FoodLogic.parseNutritionJson(
              '{"calories": 400, "high_sodium": true, "high_sugar": false}'),
          const FoodNutrition(calories: 400, highSodium: true, highSugar: false));
    });

    test('AC1_nutrition_toJson_has_three_keys', () {
      expect(
          const FoodNutrition(calories: 400, highSodium: true).toJson(),
          {'calories': 400, 'high_sodium': true, 'high_sugar': false});
    });

    test('DECIDED_Q17_local_parser_returns_ac1_json_from_menu_table', () {
      const menu = [FoodMenuItem(['ข้าวมันไก่'], 400, null, true, false)];
      final json =
          LocalMenuNutritionParser.nutritionJsonFor('ข้าวมันไก่ 1 จาน', menu: menu);
      expect(json, {'calories': 400, 'high_sodium': true, 'high_sugar': false});
      // ส่งผ่าน jsonEncode / parse ได้เป็น JSON
      expect(FoodLogic.parseNutritionJson(jsonEncode(json))!.calories, 400);
    });

    test('DECIDED_Q17_menu_not_in_table_is_parse_failure', () {
      expect(
          () => LocalMenuNutritionParser.nutritionJsonFor('พิซซ่าดาวอังคาร'),
          throwsA(isA<FoodParseException>()));
    });

    test('AC2_median_of_range', () {
      expect(FoodLogic.medianCalories([500, 700]), 600);
      expect(FoodLogic.medianCalories([400, 600]), 500);
      expect(FoodLogic.medianCalories([300, 400, 800]), 400);
    });

    test('AC2_range_calories_in_json_use_median', () {
      expect(FoodLogic.parseNutritionJson('{"calories": [500, 700]}')!.calories,
          600);
    });

    test('ASSUMPTION_AC2_range_as_text_or_min_max_object_use_median', () {
      expect(FoodLogic.parseNutritionJson('{"calories": "500-700"}')!.calories,
          600);
      expect(
          FoodLogic.parseNutritionJson('{"calories": {"min": 500, "max": 700}}')!
              .calories,
          600);
    });

    test('AC2_local_parser_range_menu_item_gives_median', () {
      const menu = [FoodMenuItem(['เมนูช่วง'], 400, 600)];
      final raw = jsonEncode(
          LocalMenuNutritionParser.nutritionJsonFor('เมนูช่วง', menu: menu));
      expect(FoodLogic.parseNutritionJson(raw)!.calories, 500);
    });

    test('EC1_unreadable_json_is_failure', () {
      expect(FoodLogic.parseNutritionJson('not json'), isNull);
      expect(FoodLogic.parseNutritionJson('{"foo": 1}'), isNull);
      expect(FoodLogic.parseNutritionJson('[]'), isNull);
    });

    test('EC1_manual_blank_defaults_to_300', () {
      expect(FoodLogic.manualCalories(''), docFallbackCalories);
      expect(FoodLogic.manualCalories('   '), docFallbackCalories);
    });

    test('EC1_manual_value_is_used_as_typed', () {
      expect(FoodLogic.manualCalories('450'), 450);
    });
  });

  group('EDGE เพดาน / ค่าต่ำสุด', () {
    test('EDGE_total_never_below_0_on_negative_calories', () {
      final s = FoodState(day: d(14), totalCalories: 100, lastSeenAt: t(14, 10));
      final next = FoodLogic.logMeal(
          s, const FoodNutrition(calories: -500), t(14, 11));
      expect(next.totalCalories, greaterThanOrEqualTo(0));
    });

    test('EDGE_repeated_logs_accumulate_without_cap', () {
      var s = FoodState(day: d(14), lastSeenAt: t(14, 8));
      for (var i = 0; i < 10; i++) {
        s = FoodLogic.logMeal(s, const FoodNutrition(calories: 500), t(14, 9));
      }
      expect(s.totalCalories, 5000);
      expect(s.meals.length, 10);
    });

    test('EDGE_first_run_rollover_starts_today_at_0', () {
      final s = FoodLogic.applyDayRollover(FoodState.initial, t(14, 10));
      expect(s.day, d(14));
      expect(s.totalCalories, 0);
      expect(s.history, isEmpty);
    });
  });
  // รอบ 2: DECIDED (owner ชั่วคราว 2026-10-31) — คำถามค้างรอบ 1 ข้อ 2–4, 6, 9, 11
  // "ใช้ค่าที่ Dev เลือกไว้ไปก่อน" (logs/20261030-2138_dev_food.md ASSUMPTION 3, 9, 12, 13, 23)
  group('R2 DECIDED ค่าที่ Dev เลือก (เดิมไม่ได้ assert)', () {
    test('DECIDED_R2_Q2_bmi_not_rounded_18_46_counts_as_underweight', () {
      // 170 cm → 1.7² = 2.89 · 53.35 / 2.89 = 18.46 (ถ้าปัด 1 ตำแหน่ง = 18.5 → ไม่ผอม)
      expect(FoodLogic.bmi(53.35, 170)!, closeTo(18.46, 0.005));
      expect(target(25, SignupGender.male, 53.35, 170), 2000 + docBmiBonus);
    });

    test('DECIDED_R2_Q2_bmi_not_rounded_22_96_counts_as_normal', () {
      // 66.35 / 2.89 = 22.96 (ถ้าปัด 1 ตำแหน่ง = 23.0 → −400)
      expect(FoodLogic.bmi(66.35, 170)!, closeTo(22.96, 0.005));
      expect(target(25, SignupGender.male, 66.35, 170), 2000);
    });

    test('DECIDED_R2_Q3_is_over_target_uses_plus_100_threshold', () {
      bool overOf(int total) {
        final s = FoodState(
            day: d(14), totalCalories: total, lastSeenAt: t(14, 20));
        final after =
            FoodLogic.applyDayRollover(s, t(15, 6), targetCalories: 2000);
        return after.history.single.isOverTarget;
      }

      expect(overOf(2001), isFalse);
      expect(overOf(2100), isFalse);
      expect(overOf(2101), isTrue);
    });

    test('DECIDED_R2_Q4_Q19_history_30_days_includes_today', () {
      // เดิม (food R2-Q4) 7 วันรวมวันนี้ → DECIDED 7day Q-19: 30 วันรวมวันนี้ (วันนี้ + 29 วันก่อนหน้า)
      // ตัดรอบเข้าวันที่ 31 ต.ค. → 30 วันรวมวันนี้ = 2–31 ต.ค. · ประวัติเก็บ 2–30 ต.ค. (29 วัน)
      // 1 ต.ค. และ ก.ย. ถูกลบ
      final history = [
        for (var day = 25; day <= 30; day++)
          DailyFoodRecord(
              date: DateTime(2026, 9, day),
              totalCalories: 1000,
              targetCalories: 2000,
              isOverTarget: false),
        for (var day = 1; day <= 29; day++)
          DailyFoodRecord(
              date: d(day),
              totalCalories: 1000,
              targetCalories: 2000,
              isOverTarget: false),
      ];
      final s = FoodState(
          day: d(30), totalCalories: 1900, history: history, lastSeenAt: t(30, 20));
      final after =
          FoodLogic.applyDayRollover(s, t(31, 6), targetCalories: 2000);
      final days = after.history.map((r) => r.date).toList();
      expect(days, [for (var day = 2; day <= 30; day++) d(day)]);
      expect(days, isNot(contains(d(1))));
      expect(after.day, d(31));
      expect(days.length + 1, docHistoryDays,
          reason: 'ประวัติ 29 วัน + วันนี้ = 30');
    });

    test('DECIDED_Q19_EDGE_day_30_back_kept_day_31_dropped_rolling', () {
      // ขอบ: วันนี้ 31 ต.ค. → วันที่ 30 ย้อนหลัง (รวมวันนี้) = 2 ต.ค. ยังอยู่ · วันที่ 31 = 1 ต.ค. ถูกตัด
      DailyFoodRecord rec(DateTime date) => DailyFoodRecord(
          date: date, totalCalories: 1000, targetCalories: 2000, isOverTarget: false);
      final s = FoodState(
          day: d(30),
          totalCalories: 1500,
          history: [rec(d(1)), rec(d(2))],
          lastSeenAt: t(30, 20));
      final oct31 =
          FoodLogic.applyDayRollover(s, t(31, 6), targetCalories: 2000);
      var days = oct31.history.map((r) => r.date).toSet();
      expect(days, contains(d(2)), reason: 'วันที่ 30 ย้อนหลัง (รวมวันนี้) ต้องยังอยู่');
      expect(days, isNot(contains(d(1))), reason: 'วันที่ 31 ย้อนหลัง ต้องถูกตัด');
      expect(days, contains(d(30)));

      // 1 พ.ย. 04:59:59 ยังเป็นรอบวัน 31 ต.ค. → 2 ต.ค. ยังเป็นวันที่ 30 ย้อนหลัง ยังอยู่
      final before = FoodLogic.applyDayRollover(
          oct31, DateTime(2026, 11, 1, 4, 59, 59), targetCalories: 2000);
      days = before.history.map((r) => r.date).toSet();
      expect(days, contains(d(2)), reason: '04:59:59 ยังไม่ข้ามรอบ');

      // 1 พ.ย. 05:00:00 ข้ามรอบ → 2 ต.ค. กลายเป็นวันที่ 31 ย้อนหลัง ถูกตัด · 30 ต.ค. ยังอยู่
      final nov1 = FoodLogic.applyDayRollover(
          before, DateTime(2026, 11, 1, 5), targetCalories: 2000);
      days = nov1.history.map((r) => r.date).toSet();
      expect(nov1.day, DateTime(2026, 11, 1));
      expect(days, isNot(contains(d(2))), reason: 'เลื่อนหน้าต่าง 30 วันตามวันใหม่');
      expect(days, contains(d(30)));
    });

    test('DECIDED_R2_Q6_median_half_rounds_up', () {
      expect(FoodLogic.medianCalories([401, 600]), 501); // 500.5 → 501
      expect(FoodLogic.parseNutritionJson('{"calories": [401, 600]}')!.calories,
          501);
      expect(FoodLogic.medianCalories([400, 601]), 501); // 500.5 → 501
      expect(FoodLogic.medianCalories([400, 600]), 500);
    });

    test('DECIDED_R2_Q9_dev_menu_table_values_used', () {
      // ค่าในตารางเมนูของ Dev (ASSUMPTION 9) ใช้ไปก่อนตามข้อตัดสิน owner
      final rice = LocalMenuNutritionParser.nutritionJsonFor('ข้าวมันไก่ 1 จาน');
      expect(rice['calories'], 596);
      final fried = LocalMenuNutritionParser.nutritionJsonFor('ข้าวมันไก่ทอด');
      expect(fried['calories'], 690, reason: 'ชื่อยาวก่อน ไม่นับข้าวมันไก่ซ้ำ');
    });

    test('DECIDED_R2_Q11_manual_calories_0_is_accepted', () {
      expect(FoodLogic.manualCalories('0'), 0);
      expect(FoodLogic.manualCalories('99999'), 99999);
    });
  });
}
