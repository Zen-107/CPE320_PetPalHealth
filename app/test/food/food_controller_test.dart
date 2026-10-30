// Unit tests: FoodController + repository + profile source
// เวลา: clock ที่ควบคุมได้ + FakeTimers (ไม่มี sleep/เวลาจริง) · AC-1 timeout ใช้ testWidgets
// (fake async ของ flutter_test) แล้วเลื่อนเวลาด้วย tester.pump(Duration)
// อ้างอิง requirements.md AC/EC, game-rules.md §1–§4 และข้อตัดสิน owner (DECIDED ชั่วคราว)
import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/food/food_controller.dart';
import 'package:petpal_health/features/food/food_menu_table.dart';
import 'package:petpal_health/features/food/food_models.dart';
import 'package:petpal_health/features/food/food_nutrition_parser.dart';
import 'package:petpal_health/features/food/food_profile_source.dart';
import 'package:petpal_health/features/food/food_repository.dart';
import 'package:petpal_health/features/signup/signup_controller.dart';
import 'package:petpal_health/features/signup/signup_models.dart';
import 'package:petpal_health/features/signup/signup_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'food_test_helpers.dart';

/// repository ที่อ่านไม่ได้เลย (ข้อมูลเสีย/หาย)
class ThrowingFoodRepository implements FoodRepository {
  @override
  Future<FoodState> load() async => throw const FoodStorageException('boom');
  @override
  Future<void> save(FoodState state) async =>
      throw const FoodStorageException('boom');
}

const testMenu = [
  FoodMenuItem(['ข้าวมันไก่'], 400, null, true, false), // ตัวอย่าง AC-1
  FoodMenuItem(['เมนูช่วง'], 400, 600), // ช่วงตัวเลข AC-2
];

void main() {
  late DateTime now;
  late FakeTimers timers;
  late InMemoryFoodRepository repo;
  late InMemoryFoodProfileSource profiles;

  setUp(() {
    now = t(14, 10);
    timers = FakeTimers();
  });

  Future<FoodController> make({
    FoodState? initial,
    Object? profile = const _Default(),
    FoodNutritionParser? parser,
    FoodRepository? repository,
    FoodProfileSource? profileSource,
  }) async {
    repo = InMemoryFoodRepository(
        initial ?? FoodState(day: d(14), lastSeenAt: t(14, 9)));
    profiles = InMemoryFoodProfileSource(
        profile: profile is _Default ? profileOf() : profile as UserProfile?);
    final c = FoodController(
      repository: repository ?? repo,
      profileSource: profileSource ?? profiles,
      parser: parser ?? LocalMenuNutritionParser(menu: testMenu),
      clock: () => now,
      timerFactory: timers.create,
    );
    await c.load();
    return c;
  }

  FoodState day14(int total) =>
      FoodState(day: d(14), totalCalories: total, lastSeenAt: t(14, 9));

  group('AC-5..7 เป้าหมายจากโปรไฟล์ (Q-13)', () {
    test('AC5_profile_male_25_target_2000_and_empty_text', () async {
      final c = await make();
      expect(c.targetCalories, 2000);
      expect(c.showsProfileCta, isFalse);
      expect(c.calorieText, calText(0, 2000));
      expect(c.energyFraction, 0);
    });

    test('AC6_underweight_profile_target_2400', () async {
      final c = await make(profile: profileOf(weightKg: 50, heightCm: 175));
      expect(c.targetCalories, 2400);
    });

    test('AC7_overweight_profile_target_1600', () async {
      final c = await make(profile: profileOf(weightKg: 80, heightCm: 170));
      expect(c.targetCalories, 1600);
    });

    test('DECIDED_Q13_existing_profile_does_not_need_S3', () async {
      final c = await make();
      expect(c.needsProfileSetup, isFalse);
    });

    test('DECIDED_Q13_no_profile_needs_S3', () async {
      final c = await make(profile: null);
      expect(c.needsProfileSetup, isTrue);
      expect(c.showsProfileCta, isTrue);
    });

    test('DECIDED_Q13_save_from_S3_computes_target_and_closes_setup', () async {
      final c = await make(profile: null);
      final r = await c.saveProfile(
          age: '25', gender: SignupGender.male, weight: '65', height: '175');
      expect(r, FoodProfileSaveOutcome.saved);
      expect(c.targetCalories, 2000);
      expect(c.needsProfileSetup, isFalse);
      expect(c.showsProfileCta, isFalse);
    });

    test('AC4_EC5_controller_refuses_decimal_age_nothing_saved', () async {
      final c = await make(profile: null);
      for (final age in ['25.5', '20.5', '0', '121']) {
        final r = await c.saveProfile(
            age: age, gender: SignupGender.male, weight: '65', height: '175');
        expect(r, FoodProfileSaveOutcome.invalid, reason: age);
      }
      expect(profiles.saveCount, 0);
      expect(c.profile, isNull);
    });

    test('DECIDED_Q14_decimal_weight_height_saved_as_decimal', () async {
      final c = await make(profile: null);
      await c.saveProfile(
          age: '30',
          gender: SignupGender.female,
          weight: '52.5',
          height: '160.5');
      expect(c.profile!.weightKg, 52.5);
      expect(c.profile!.heightCm, 160.5);
      expect(c.profile!.age, 30);
    });
  });

  group('DECIDED Q-13 โปรไฟล์จาก signup S-6 (SignupFoodProfileSource)', () {
    Future<SignupController> signupWith({bool withProfile = true}) async {
      final s = SignupController(repository: FakeAuthRepository());
      await s.load();
      await s.signUpWithEmail('mali@email.com', 'secret1');
      if (withProfile) {
        final r = await s.saveProfile(
          displayName: 'มะลิ',
          age: '25',
          gender: SignupGender.male,
          weight: '65',
          height: '175',
          healthGoal: 'ลดน้ำหนัก',
        );
        expect(r, SaveProfileOutcome.success);
      }
      return s;
    }

    test('DECIDED_Q13_signup_profile_gives_target_without_S3', () async {
      final s = await signupWith();
      final c = await make(profileSource: SignupFoodProfileSource(s));
      expect(c.needsProfileSetup, isFalse);
      expect(c.targetCalories, 2000);
    });

    test('DECIDED_Q13_signup_session_without_profile_needs_S3', () async {
      final s = await signupWith(withProfile: false);
      final c = await make(profileSource: SignupFoodProfileSource(s));
      expect(c.needsProfileSetup, isTrue);
    });

    test('DECIDED_Q13_S3_saves_back_to_signup_profile_keeps_name_and_goal',
        () async {
      final s = await signupWith();
      final c = await make(profileSource: SignupFoodProfileSource(s));
      final r = await c.saveProfile(
          age: '40', gender: SignupGender.female, weight: '52.5', height: '160');
      expect(r, FoodProfileSaveOutcome.saved);
      final p = s.session!.profile!;
      expect(p.age, 40);
      expect(p.gender, SignupGender.female);
      expect(p.weightKg, 52.5);
      expect(p.heightCm, 160);
      expect(p.displayName, 'มะลิ');
      expect(p.healthGoal, 'ลดน้ำหนัก');
      // หญิง 40 ปี 1,600 · BMI 52.5/1.6² = 20.5 → 1,600
      expect(c.targetCalories, 1600);
    });
  });

  group('DECIDED Q-9 / US-3 ข้ามโปรไฟล์', () {
    test('DECIDED_Q9_skip_shows_cta_no_target', () async {
      final c = await make(profile: null);
      await c.skipProfile();
      expect(c.profileSkipped, isTrue);
      expect(c.needsProfileSetup, isFalse);
      expect(c.showsProfileCta, isTrue);
      expect(c.targetCalories, isNull);
    });

    test('DECIDED_Q9_skipped_never_over_limit_no_toast_no_badge', () async {
      final c = await make(profile: null);
      await c.skipProfile();
      for (var i = 0; i < 3; i++) {
        await c.logNutrition(const FoodNutrition(calories: 2000));
        expect(c.toastMessage, isNull);
        expect(c.isOverLimit, isFalse);
        expect(c.showsFullBadge, isFalse);
        expect(c.petState, FoodPetState.eating);
      }
      expect(c.totalCalories, 6000);
      timers.advance(const Duration(seconds: docEatingSeconds));
      expect(c.petState, FoodPetState.normal);
    });

    test('AC8_cta_total_text_contains_daily_total', () async {
      final c = await make(profile: null, initial: day14(1250));
      await c.skipProfile();
      expect(c.ctaTotalText, contains('1,250'));
    });

    test('US3_skip_is_persisted', () async {
      final c = await make(profile: null);
      await c.skipProfile();
      expect(repo.stored.profileSkipped, isTrue);
    });
  });

  group('GR2 ท่าชั่วคราว EATING 2 วินาที', () {
    test('GR2_log_shows_eating_then_normal_after_exactly_2s', () async {
      final c = await make(initial: day14(1000));
      await c.logNutrition(const FoodNutrition(calories: 500));
      expect(c.petState, FoodPetState.eating);
      expect(c.totalCalories, 1500); // หลอดอัปเดตทันที (ui-spec Q-5)
      timers.advance(const Duration(milliseconds: docEatingSeconds * 1000 - 1));
      expect(c.petState, FoodPetState.eating);
      timers.advance(const Duration(milliseconds: 1));
      expect(c.petState, FoodPetState.normal);
    });

    test('GR3_male_25_from_0_to_1900_normal_after_eating', () async {
      final c = await make(initial: day14(0));
      await c.logNutrition(const FoodNutrition(calories: 1900));
      timers.advance(const Duration(seconds: 2));
      expect(c.petState, FoodPetState.normal);
      expect(c.isOverLimit, isFalse);
      expect(c.calorieText, calText(1900, 2000));
    });

    test('AC12_no_toast_when_not_over_limit', () async {
      final c = await make(initial: day14(0));
      await c.logNutrition(const FoodNutrition(calories: 500));
      expect(c.toastMessage, isNull);
    });
  });

  group('AC-9 / AC-10 / AC-11 / EC-3 เกินเป้า', () {
    test('AC9_GR3_1950_plus_100_is_2050_normal_not_red', () async {
      final c = await make(initial: day14(1950));
      await c.logNutrition(const FoodNutrition(calories: 100));
      expect(c.totalCalories, 2050);
      expect(c.isOverLimit, isFalse);
      expect(c.showsFullBadge, isFalse);
      expect(c.toastMessage, isNull);
      timers.advance(const Duration(seconds: 2));
      expect(c.petState, FoodPetState.normal);
    });

    test('AC9_EDGE_landing_exactly_on_2100_stays_normal', () async {
      final c = await make(initial: day14(2000));
      await c.logNutrition(const FoodNutrition(calories: 100));
      timers.advance(const Duration(seconds: 2));
      expect(c.isOverLimit, isFalse);
      expect(c.petState, FoodPetState.normal);
    });

    test('AC10_GR3_2000_plus_150_eating_then_over_limit', () async {
      final c = await make(initial: day14(2000));
      await c.logNutrition(const FoodNutrition(calories: 150));
      expect(c.totalCalories, 2150);
      // ครั้งที่ข้ามเกณฑ์: ก่อนบันทึกยังไม่เกิน → EATING ก่อน (game-rules §2/§3)
      expect(c.petState, FoodPetState.eating);
      expect(c.toastMessage, isNull);
      timers.advance(const Duration(seconds: 2));
      expect(c.petState, FoodPetState.overLimit);
      expect(c.isOverLimit, isTrue);
      expect(c.energyFraction, 1.0);
    });

    test('AC10_EDGE_landing_on_2101_goes_over_limit', () async {
      final c = await make(initial: day14(2000));
      await c.logNutrition(const FoodNutrition(calories: 101));
      timers.advance(const Duration(seconds: 2));
      expect(c.petState, FoodPetState.overLimit);
    });

    test('DECIDED_Q5_full_badge_and_red_immediately_during_eating', () async {
      final c = await make(initial: day14(2000));
      await c.logNutrition(const FoodNutrition(calories: 150));
      expect(c.petState, FoodPetState.eating);
      expect(c.isOverLimit, isTrue);
      expect(c.showsFullBadge, isTrue);
    });

    test('AC10_loaded_over_limit_shows_over_limit_pose', () async {
      final c = await make(initial: day14(2150));
      expect(c.petState, FoodPetState.overLimit);
      expect(c.showsFullBadge, isTrue);
      expect(c.calorieText, calText(2150, 2000));
    });

    test('AC11_GR3_2150_plus_100_feeding_and_toast', () async {
      final c = await make(initial: day14(2150));
      await c.logNutrition(const FoodNutrition(calories: 100));
      expect(c.totalCalories, 2250);
      expect(c.petState, FoodPetState.overLimitFeeding);
      expect(c.toastMessage, overLimitToast);
      expect(c.calorieText, '2,250 / 2,000 kcal');
    });

    test('EC3_AC11_every_repeated_log_shows_feeding_and_toast', () async {
      final c = await make(initial: day14(2150));
      for (var i = 0; i < 4; i++) {
        final serialBefore = c.toastSerial;
        // ปล่อยให้ toast และท่าเดิมหมดเวลาก่อน แล้วบันทึกซ้ำ
        timers.advance(const Duration(seconds: 6));
        expect(c.toastMessage, isNull);
        expect(c.petState, FoodPetState.overLimit);
        await c.logNutrition(const FoodNutrition(calories: 50));
        expect(c.petState, FoodPetState.overLimitFeeding, reason: 'ครั้งที่ $i');
        expect(c.toastMessage, overLimitToast, reason: 'ครั้งที่ $i');
        expect(c.toastSerial, serialBefore + 1, reason: '1 ข้อความ / 1 การบันทึก');
      }
    });

    test('ASSUMPTION_Q3_feeding_returns_to_over_limit_after_2s', () async {
      final c = await make(initial: day14(2150));
      await c.logNutrition(const FoodNutrition(calories: 100));
      timers.advance(const Duration(milliseconds: 1999));
      expect(c.petState, FoodPetState.overLimitFeeding);
      timers.advance(const Duration(milliseconds: 1));
      expect(c.petState, FoodPetState.overLimit);
    });

    test('ASSUMPTION_7_log_during_eating_after_crossing_counts_as_over_limit',
        () async {
      final c = await make(initial: day14(2000));
      await c.logNutrition(const FoodNutrition(calories: 150));
      timers.advance(const Duration(milliseconds: 500));
      await c.logNutrition(const FoodNutrition(calories: 50));
      expect(c.petState, FoodPetState.overLimitFeeding);
      expect(c.toastMessage, overLimitToast);
    });
  });

  group('AC-12 / EC-2 Toast 5 วินาที + Queue replace', () {
    test('AC12_toast_visible_until_exactly_5s', () async {
      final c = await make(initial: day14(2150));
      await c.logNutrition(const FoodNutrition(calories: 10));
      timers.advance(const Duration(milliseconds: docToastSeconds * 1000 - 1));
      expect(c.toastMessage, overLimitToast);
      timers.advance(const Duration(milliseconds: 1));
      expect(c.toastMessage, isNull);
    });

    test('EC2_second_log_within_5s_replaces_toast_and_restarts_5s', () async {
      final c = await make(initial: day14(2150));
      await c.logNutrition(const FoodNutrition(calories: 10));
      final first = c.toastSerial;
      timers.advance(const Duration(seconds: 3));
      await c.logNutrition(const FoodNutrition(calories: 10));
      expect(c.toastSerial, first + 1);
      expect(c.toastMessage, overLimitToast);
      // เดิมจะหายที่ 5 s — ต้องยังอยู่เพราะนับใหม่จากครั้งที่ 2 (3 s + 5 s = 8 s)
      timers.advance(const Duration(milliseconds: 4999));
      expect(c.toastMessage, overLimitToast);
      timers.advance(const Duration(milliseconds: 1));
      expect(c.toastMessage, isNull);
    });

    test('ASSUMPTION_Q4_rapid_log_restarts_transient_pose', () async {
      final c = await make(initial: day14(0));
      await c.logNutrition(const FoodNutrition(calories: 100));
      timers.advance(const Duration(milliseconds: 1500));
      await c.logNutrition(const FoodNutrition(calories: 100));
      timers.advance(const Duration(milliseconds: 1000));
      expect(c.petState, FoodPetState.eating);
      timers.advance(const Duration(milliseconds: 1000));
      expect(c.petState, FoodPetState.normal);
    });
  });

  group('AC-1 / AC-2 / EC-1 ประมวลผลเมนู', () {
    test('AC1_menu_text_parsed_and_logged_with_flags', () async {
      final c = await make(initial: day14(0));
      final r = await c.submitMeal('ข้าวมันไก่ 1 จาน');
      expect(r, MealSubmitOutcome.logged);
      expect(c.totalCalories, 400);
      expect(c.state.meals.single.highSodium, isTrue);
      expect(c.state.meals.single.highSugar, isFalse);
      expect(c.state.meals.single.manual, isFalse);
    });

    test('AC2_range_menu_logs_median', () async {
      final c = await make(initial: day14(0));
      await c.submitMeal('เมนูช่วง');
      expect(c.totalCalories, 500);
    });

    test('EC1_offline_submit_is_parse_failed_nothing_logged', () async {
      final c = await make(
          initial: day14(0),
          parser: LocalMenuNutritionParser(offline: true, menu: testMenu));
      final r = await c.submitMeal('ข้าวมันไก่');
      expect(r, MealSubmitOutcome.parseFailed);
      expect(c.totalCalories, 0);
      expect(c.state.meals, isEmpty);
    });

    test('DECIDED_Q17_unknown_menu_is_parse_failed', () async {
      final c = await make(initial: day14(0));
      expect(await c.submitMeal('พิซซ่าดาวอังคาร'),
          MealSubmitOutcome.parseFailed);
      expect(c.totalCalories, 0);
    });

    test('EC1_manual_blank_logs_300', () async {
      final c = await make(initial: day14(0));
      final r = await c.submitManual('');
      expect(r, MealSubmitOutcome.logged);
      expect(c.totalCalories, docFallbackCalories);
      expect(c.state.meals.single.manual, isTrue);
      expect(c.petState, FoodPetState.eating);
    });

    test('EC1_manual_typed_value_logged', () async {
      final c = await make(initial: day14(100));
      await c.submitManual('450');
      expect(c.totalCalories, 550);
    });

    testWidgets('AC1_EDGE_result_at_2_9s_is_used', (tester) async {
      final c = FoodController(
        repository: InMemoryFoodRepository(day14(0)),
        profileSource: InMemoryFoodProfileSource(profile: profileOf()),
        parser: LocalMenuNutritionParser(
            menu: testMenu, latency: const Duration(milliseconds: 2900)),
        clock: () => now,
        timerFactory: timers.create,
      );
      await c.load();
      MealSubmitOutcome? out;
      unawaited(c.submitMeal('ข้าวมันไก่').then((v) => out = v));
      await tester.pump(const Duration(milliseconds: 2950));
      expect(out, MealSubmitOutcome.logged);
      expect(c.totalCalories, 400);
    });

    testWidgets('AC1_EC1_EDGE_no_result_within_3s_is_failure', (tester) async {
      final c = FoodController(
        repository: InMemoryFoodRepository(day14(0)),
        profileSource: InMemoryFoodProfileSource(profile: profileOf()),
        parser: LocalMenuNutritionParser(
            menu: testMenu, latency: const Duration(seconds: 10)),
        clock: () => now,
        timerFactory: timers.create,
      );
      await c.load();
      MealSubmitOutcome? out;
      unawaited(c.submitMeal('ข้าวมันไก่').then((v) => out = v));
      await tester.pump(const Duration(milliseconds: 2900));
      expect(out, isNull, reason: 'ยังไม่ถึง 3 วินาที');
      await tester.pump(const Duration(milliseconds: 200));
      expect(out, MealSubmitOutcome.parseFailed,
          reason: 'เกิน AI_PARSING_TIMEOUT 3 วินาที = failure (EC-1)');
      expect(c.totalCalories, 0);
      await tester.pump(const Duration(seconds: 8)); // ปล่อย delayed ของ parser
    });
  });

  group('AC-3 / Foreground crossing / storage', () {
    test('AC3_log_at_03_00_day_15_stored_date_is_2026_10_14', () async {
      SharedPreferences.setMockInitialValues({});
      now = t(14, 21);
      final c = FoodController(
        repository: SharedPrefsFoodRepository(),
        profileSource: InMemoryFoodProfileSource(profile: profileOf()),
        parser: LocalMenuNutritionParser(menu: testMenu),
        clock: () => now,
        timerFactory: timers.create,
      );
      await c.load();
      now = t(15, 3);
      await c.logNutrition(const FoodNutrition(calories: 400));
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(FoodStorageKeys.currentDay), '2026-10-14');
      final meals =
          jsonDecode(prefs.getString(FoodStorageKeys.mealsLog)!) as List;
      expect((meals.single as Map)['date'], '2026-10-14');
      expect(prefs.getInt(FoodStorageKeys.totalCalories), 400);
    });

    test('GR4_refresh_day_at_05_00_resets_to_0_without_reload', () async {
      final c = await make(initial: day14(2500));
      now = t(15, 4, 59, 59);
      await c.refreshDay();
      expect(c.totalCalories, 2500);
      now = t(15, 5);
      await c.refreshDay();
      expect(c.totalCalories, 0);
      expect(c.petState, FoodPetState.normal);
      expect(c.showsFullBadge, isFalse);
      expect(c.state.history.single.date, d(14));
      expect(c.state.history.single.totalCalories, 2500);
      expect(repo.stored.totalCalories, 0);
    });

    test('GR4_EDGE_midnight_does_not_reset', () async {
      final c = await make(initial: day14(1500));
      now = t(15, 0);
      await c.refreshDay();
      expect(c.totalCalories, 1500);
    });

    test('EDGE_new_day_log_after_over_limit_day_is_eating_no_toast', () async {
      final c = await make(initial: day14(2500));
      now = t(15, 6);
      await c.logNutrition(const FoodNutrition(calories: 100));
      expect(c.totalCalories, 100);
      expect(c.petState, FoodPetState.eating);
      expect(c.toastMessage, isNull);
    });

    test('EDGE_reload_same_day_restores_total', () async {
      SharedPreferences.setMockInitialValues({});
      FoodController build() => FoodController(
            repository: SharedPrefsFoodRepository(),
            profileSource: InMemoryFoodProfileSource(profile: profileOf()),
            clock: () => now,
            timerFactory: timers.create,
          );
      final c1 = build();
      await c1.load();
      await c1.logNutrition(const FoodNutrition(calories: 700));
      final c2 = build();
      await c2.load();
      expect(c2.totalCalories, 700);
    });

    test('EDGE_reopen_after_05_00_starts_new_day_at_0', () async {
      SharedPreferences.setMockInitialValues({});
      FoodController build() => FoodController(
            repository: SharedPrefsFoodRepository(),
            profileSource: InMemoryFoodProfileSource(profile: profileOf()),
            clock: () => now,
            timerFactory: timers.create,
          );
      final c1 = build();
      await c1.load();
      await c1.logNutrition(const FoodNutrition(calories: 700));
      now = t(15, 5, 0, 1);
      final c2 = build();
      await c2.load();
      expect(c2.totalCalories, 0);
      expect(c2.state.history.single.totalCalories, 700);
    });

    test('EDGE_first_run_empty_storage_starts_at_0_normal', () async {
      SharedPreferences.setMockInitialValues({});
      final c = FoodController(
        repository: SharedPrefsFoodRepository(),
        profileSource: InMemoryFoodProfileSource(profile: profileOf()),
        clock: () => now,
        timerFactory: timers.create,
      );
      await c.load();
      expect(c.isLoaded, isTrue);
      expect(c.totalCalories, 0);
      expect(c.state.day, d(14));
      expect(c.petState, FoodPetState.normal);
      expect(c.calorieText, calText(0, 2000));
      expect(c.toastMessage, isNull);
    });

    test('EDGE_corrupted_storage_wrong_types_does_not_crash', () async {
      SharedPreferences.setMockInitialValues({
        FoodStorageKeys.currentDay: 12345,
        FoodStorageKeys.totalCalories: 'abc',
        FoodStorageKeys.mealsLog: '{not json',
        FoodStorageKeys.historyLog: '[{"date": 5}]',
        FoodStorageKeys.lastSeenAt: 'yesterday',
        FoodStorageKeys.profileSkipped: 'yes',
      });
      final c = FoodController(
        repository: SharedPrefsFoodRepository(),
        profileSource: InMemoryFoodProfileSource(profile: profileOf()),
        clock: () => now,
        timerFactory: timers.create,
      );
      await c.load();
      expect(c.isLoaded, isTrue);
      expect(c.totalCalories, 0);
      expect(c.state.history, isEmpty);
      await c.logNutrition(const FoodNutrition(calories: 200));
      expect(c.totalCalories, 200);
    });

    test('EDGE_stored_negative_total_clamped_to_0', () async {
      SharedPreferences.setMockInitialValues({
        FoodStorageKeys.currentDay: '2026-10-14',
        FoodStorageKeys.totalCalories: -500,
      });
      final c = FoodController(
        repository: SharedPrefsFoodRepository(),
        profileSource: InMemoryFoodProfileSource(profile: profileOf()),
        clock: () => now,
        timerFactory: timers.create,
      );
      await c.load();
      expect(c.totalCalories, 0);
    });

    test('EDGE_repository_throws_starts_empty_and_logging_still_works',
        () async {
      final c = await make(repository: ThrowingFoodRepository());
      expect(c.isLoaded, isTrue);
      expect(c.totalCalories, 0);
      await c.logNutrition(const FoodNutrition(calories: 300));
      expect(c.totalCalories, 300);
    });

    test('EDGE_profile_source_throws_treated_as_no_target', () async {
      final c = await make(profileSource: _ThrowingProfileSource());
      expect(c.isLoaded, isTrue);
      expect(c.showsProfileCta, isTrue);
    });
  });

  // รอบ 2: DECIDED (owner ชั่วคราว 2026-10-31) — คำถามค้างรอบ 1 ข้อ 8 (ขอบ 1.999 / 2.000 s), 10
  group('R2 DECIDED ค่าที่ Dev เลือก (controller)', () {
    test('DECIDED_R2_Q10_signup_profile_gender_unspecified_is_cta_not_S3',
        () async {
      final c = await make(profile: profileOf(gender: SignupGender.unspecified));
      expect(c.needsProfileSetup, isFalse, reason: 'มีโปรไฟล์แล้ว ไม่เปิด S-3 เอง');
      expect(c.targetCalories, isNull);
      expect(c.showsProfileCta, isTrue);
    });

    test('DECIDED_R2_Q10_signup_profile_without_weight_height_is_cta_not_S3',
        () async {
      final c = await make(profile: profileOf(weightKg: null, heightCm: null));
      expect(c.needsProfileSetup, isFalse);
      expect(c.targetCalories, isNull);
      expect(c.showsProfileCta, isTrue);
    });

    test('DECIDED_R2_Q8_over_limit_feeding_lasts_2s_then_over_limit',
        () async {
      final c = await make(initial: day14(2150));
      await c.logNutrition(const FoodNutrition(calories: 10));
      expect(c.petState, FoodPetState.overLimitFeeding);
      timers.advance(const Duration(milliseconds: 1999));
      expect(c.petState, FoodPetState.overLimitFeeding);
      timers.advance(const Duration(milliseconds: 1));
      expect(c.petState, FoodPetState.overLimit);
    });
  });
}

class _Default {
  const _Default();
}

class _ThrowingProfileSource implements FoodProfileSource {
  @override
  Future<UserProfile?> load() async => throw StateError('broken');
  @override
  Future<UserProfile?> save(FoodProfileInput input) async => null;
}
