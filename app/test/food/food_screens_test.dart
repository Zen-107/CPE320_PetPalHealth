// Widget tests: S-1 / S-2 / S-3 ของฟีเจอร์ food + ทางเข้าจากหน้า water
// ข้อความบนจอคัดลอกตรงตัวจาก docs/food/ux-flow.md ; ValueKey จาก docs/food/ui-spec.md
// ข้อความที่ ui-spec ระบุ "(เสนอ — รอยืนยัน)" ใช้ชื่อเทสต์ที่มีคำว่า ASSUMPTION
// เวลา: clock ของ FoodController + tester.pump(Duration) — ไม่ใช้เวลาจริง
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/food/food_controller.dart';
import 'package:petpal_health/features/food/food_menu_table.dart';
import 'package:petpal_health/features/food/food_models.dart';
import 'package:petpal_health/features/food/food_nutrition_parser.dart';
import 'package:petpal_health/features/food/food_profile_source.dart';
import 'package:petpal_health/features/food/food_repository.dart';
import 'package:petpal_health/features/food/screens/food_dashboard_screen.dart';
import 'package:petpal_health/features/signup/signup_controller.dart';
import 'package:petpal_health/features/signup/signup_models.dart';
import 'package:petpal_health/features/signup/signup_repository.dart';
import 'package:petpal_health/features/water/water_controller.dart';
import 'package:petpal_health/features/water/water_repository.dart';
import 'package:petpal_health/main.dart';
import 'package:petpal_health/shared/pet/pet.dart';

import 'food_test_helpers.dart';

Finder k(String key) => find.byKey(Key(key));
Finder petImage(String state) => k('food_pet_image_$state');

const testMenu = [
  FoodMenuItem(['ข้าวมันไก่'], 400, null, true, false), // ตัวอย่าง AC-1
  FoodMenuItem(['เมนูช่วง'], 400, 600), // ช่วงตัวเลข AC-2 → median 500
  FoodMenuItem(['ขนม50'], 50),
  FoodMenuItem(['ขนม150'], 150),
];

String textOf(WidgetTester tester, Finder f) => tester.widget<Text>(f).data!;

ColorScheme schemeOf(WidgetTester tester) =>
    Theme.of(tester.element(k('food_energy_slot'))).colorScheme;

bool badgeVisible(WidgetTester tester) =>
    tester.widget<Visibility>(k('food_full_badge_visibility')).visible;

PetPose painterPose(WidgetTester tester) =>
    (tester.widget<CustomPaint>(find.byKey(PetKeys.painter)).painter!
            as PetCharacterPainter)
        .pose;

String fieldText(WidgetTester tester, String key) =>
    tester.widget<TextField>(k(key)).controller!.text;

FoodState day14(int total) =>
    FoodState(day: d(14), totalCalories: total, lastSeenAt: t(14, 9));

/// ข้ามโปรไฟล์ไว้แล้ว (US-3) — เปิด S-1 แล้วเห็น CTA ทันทีโดยไม่เปิด S-3
FoodState skipped14(int total) => FoodState(
    day: d(14), totalCalories: total, lastSeenAt: t(14, 9), profileSkipped: true);

/// ui-spec §1.3 / D-5: ช่องพลังงานสูง "อย่างน้อย" 88 (ห้าม assert ว่าเท่ากับ 88)
const double docEnergySlotMinHeight = 88;

/// จอ 360 dp (ui-spec §5)
void set360(WidgetTester tester) {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// ช่องพลังงานสูง ≥ 88 และ [content] อยู่ในช่องครบ (ไม่ล้น/ไม่ถูกตัด)
void expectEnergySlotHolds(WidgetTester tester, Finder content) {
  final slot = tester.getRect(k('food_energy_slot'));
  expect(slot.height, greaterThanOrEqualTo(docEnergySlotMinHeight));
  final r = tester.getRect(content);
  const eps = 0.01;
  expect(
      r.top >= slot.top - eps &&
          r.bottom <= slot.bottom + eps &&
          r.left >= slot.left - eps &&
          r.right <= slot.right + eps,
      isTrue,
      reason: '$content $r ต้องอยู่ในช่องพลังงาน $slot');
}

void main() {
  late DateTime now;

  setUp(() => now = t(14, 10));

  FoodController makeController({
    FoodState? initial,
    UserProfile? profile,
    bool noProfile = false,
    FoodNutritionParser? parser,
    FoodProfileSource? source,
  }) =>
      FoodController(
        repository: InMemoryFoodRepository(initial ?? day14(0)),
        profileSource: source ??
            InMemoryFoodProfileSource(
                profile: noProfile ? null : (profile ?? profileOf())),
        parser: parser ?? LocalMenuNutritionParser(menu: testMenu),
        clock: () => now,
      );

  /// [textScale] = null → ใช้ MediaQuery ตามปกติ · มีค่า → ครอบ MediaQuery ด้วย
  /// `TextScaler.linear(textScale)` (มีผลกับทุก route: S-1 / S-2 / S-3)
  Widget app(FoodController c, {double? textScale}) => MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue)),
        builder: textScale == null
            ? null
            : (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(textScale)),
                  child: child!,
                ),
        home: FoodDashboardScreen(controller: c, animatePet: false),
      );

  Future<FoodController> pumpS1(
    WidgetTester tester, {
    FoodState? initial,
    UserProfile? profile,
    bool noProfile = false,
    FoodNutritionParser? parser,
    FoodProfileSource? source,
    double? textScale,
  }) async {
    final c = makeController(
        initial: initial,
        profile: profile,
        noProfile: noProfile,
        parser: parser,
        source: source);
    await tester.pumpWidget(app(c, textScale: textScale));
    await tester.pumpAndSettle();
    return c;
  }

  /// ปล่อยให้ท่าชั่วคราว (2 s) และ Toast (5 s) หมดเวลา — กัน "Timer still pending"
  Future<void> drain(WidgetTester tester) =>
      tester.pump(const Duration(seconds: 6));

  /// S-1 → S-2 → พิมพ์เมนู → 「บันทึกข้อมูล」 → กลับ S-1 (ยังไม่ถึง 2 วินาที)
  Future<void> logViaS2(WidgetTester tester, String menu) async {
    await tester.tap(k('food_add_meal_button'));
    await tester.pumpAndSettle();
    await tester.enterText(k('food_meal_input_field'), menu);
    await tester.tap(k('food_meal_submit_button'));
    await tester.pump(); // ประมวลผล + Navigator.pop
    await tester.pump(); // เฟรมแรกของ transition
    // จบ transition ของ route (FadeForwards ~800 ms ใน Flutter รุ่นนี้) — ยังไม่ถึง 2 s
    await tester.pump(const Duration(milliseconds: 900));
  }

  // =========================================================================
  // S-1
  // =========================================================================
  group('S-1 แดชบอร์ด', () {
    testWidgets('UI_S1_add_meal_button_text_per_ux_flow', (tester) async {
      await pumpS1(tester);
      expect(
          find.descendant(
              of: k('food_add_meal_button'), matching: find.text(addMealText)),
          findsOneWidget);
      await drain(tester);
    });

    testWidgets('ASSUMPTION_Q2_S1_title_proposed', (tester) async {
      await pumpS1(tester);
      expect(textOf(tester, k('food_header_text')), 'โภชนาการ');
    });

    testWidgets('EDGE_S1_empty_state_0_of_2000_bar_0_normal_pose',
        (tester) async {
      await pumpS1(tester);
      expect(textOf(tester, k('food_calorie_text')), '0 / 2,000 kcal');
      expect(
          tester.widget<LinearProgressIndicator>(k('food_energy_bar')).value, 0);
      expect(petImage('normal'), findsOneWidget);
      expect(badgeVisible(tester), isFalse);
      expect(k('food_toast'), findsNothing);
      expect(k('food_profile_cta_banner'), findsNothing);
    });

    testWidgets('GR3_S1_1900_of_2000_normal_primary_bar', (tester) async {
      await pumpS1(tester, initial: day14(1900));
      expect(textOf(tester, k('food_calorie_text')), '1,900 / 2,000 kcal');
      final bar = tester.widget<LinearProgressIndicator>(k('food_energy_bar'));
      expect(bar.value, closeTo(0.95, 1e-9));
      expect(bar.color, schemeOf(tester).primary);
      expect(petImage('normal'), findsOneWidget);
    });

    testWidgets('AC9_S1_2050_of_2000_not_red_normal_pose_no_badge',
        (tester) async {
      await pumpS1(tester, initial: day14(2050));
      expect(textOf(tester, k('food_calorie_text')), '2,050 / 2,000 kcal');
      final bar = tester.widget<LinearProgressIndicator>(k('food_energy_bar'));
      expect(bar.color, isNot(schemeOf(tester).error));
      expect(bar.value, 1.0);
      expect(petImage('normal'), findsOneWidget);
      expect(petImage('over_limit'), findsNothing);
      expect(badgeVisible(tester), isFalse);
    });

    testWidgets('AC9_EDGE_S1_2100_exact_threshold_not_red', (tester) async {
      await pumpS1(tester, initial: day14(2100));
      expect(tester.widget<LinearProgressIndicator>(k('food_energy_bar')).color,
          isNot(schemeOf(tester).error));
      expect(petImage('normal'), findsOneWidget);
      expect(badgeVisible(tester), isFalse);
    });

    testWidgets('AC10_EDGE_S1_2101_red_over_limit_badge', (tester) async {
      await pumpS1(tester, initial: day14(2101));
      expect(tester.widget<LinearProgressIndicator>(k('food_energy_bar')).color,
          schemeOf(tester).error);
      expect(petImage('over_limit'), findsOneWidget);
      expect(badgeVisible(tester), isTrue);
    });

    testWidgets('AC10_S1_2150_red_bar_full_over_limit_pose_full_badge_text',
        (tester) async {
      await pumpS1(tester, initial: day14(2150));
      final bar = tester.widget<LinearProgressIndicator>(k('food_energy_bar'));
      expect(bar.color, schemeOf(tester).error);
      expect(bar.value, 1.0);
      expect(textOf(tester, k('food_calorie_text')), '2,150 / 2,000 kcal');
      expect(petImage('over_limit'), findsOneWidget);
      expect(badgeVisible(tester), isTrue);
      expect(
          find.descendant(
              of: k('food_full_badge'), matching: find.text(fullBadgeText)),
          findsOneWidget);
      expect(k('food_toast'), findsNothing, reason: 'Toast เฉพาะตอนบันทึกซ้ำ');
    });

    testWidgets('DECIDED_OQ1_S1_PetCharacter_pose_for_each_state',
        (tester) async {
      final c = await pumpS1(tester, initial: day14(2000));
      expect(painterPose(tester), PetPose.foodNormal);
      await c.logNutrition(const FoodNutrition(calories: 150));
      await tester.pump();
      expect(painterPose(tester), PetPose.foodEating);
      await tester.pump(const Duration(seconds: 2));
      expect(painterPose(tester), PetPose.foodOverLimit);
      await c.logNutrition(const FoodNutrition(calories: 10));
      await tester.pump();
      expect(painterPose(tester), PetPose.foodOverLimitFeeding);
      expect(find.byType(PetCharacter), findsOneWidget);
      expect(find.byType(Image), findsNothing, reason: 'ไม่ใช้ PNG/Sprite');
      await drain(tester);
    });

    testWidgets('GR2_S1_log_shows_eating_then_normal_after_2s',
        (tester) async {
      await pumpS1(tester, initial: day14(1000));
      await logViaS2(tester, 'ข้าวมันไก่');
      expect(petImage('eating'), findsOneWidget);
      expect(textOf(tester, k('food_calorie_text')), '1,400 / 2,000 kcal');
      expect(k('food_toast'), findsNothing);
      await tester.pump(const Duration(seconds: 2));
      expect(petImage('normal'), findsOneWidget);
      expect(petImage('eating'), findsNothing);
      await drain(tester);
    });

    testWidgets('AC10_DECIDED_Q5_crossing_log_red_and_badge_now_pose_after_2s',
        (tester) async {
      await pumpS1(tester, initial: day14(2000));
      await logViaS2(tester, 'ขนม150');
      // Q-5: ป้าย「อิ่มแล้ว」ขึ้นพร้อมหลอดแดงทันที ไม่รอท่า
      expect(petImage('eating'), findsOneWidget);
      expect(tester.widget<LinearProgressIndicator>(k('food_energy_bar')).color,
          schemeOf(tester).error);
      expect(badgeVisible(tester), isTrue);
      expect(textOf(tester, k('food_calorie_text')), '2,150 / 2,000 kcal');
      await tester.pump(const Duration(seconds: 2));
      expect(petImage('over_limit'), findsOneWidget);
      await drain(tester);
    });

    testWidgets('AC11_EC3_log_while_over_limit_feeding_pose_and_toast',
        (tester) async {
      await pumpS1(tester, initial: day14(2150));
      await logViaS2(tester, 'ขนม150');
      expect(petImage('over_limit_feeding'), findsOneWidget);
      expect(k('food_toast'), findsOneWidget);
      expect(textOf(tester, k('food_over_limit_toast')), overLimitToast);
      expect(badgeVisible(tester), isTrue);
      expect(textOf(tester, k('food_calorie_text')), '2,300 / 2,000 kcal');
      await drain(tester);
    });

    testWidgets('EC3_AC11_toast_shows_again_on_every_repeated_log',
        (tester) async {
      await pumpS1(tester, initial: day14(2150));
      for (var i = 0; i < 3; i++) {
        await logViaS2(tester, 'ขนม50');
        expect(find.text(overLimitToast), findsOneWidget, reason: 'ครั้งที่ $i');
        expect(petImage('over_limit_feeding'), findsOneWidget);
        await drain(tester);
        expect(k('food_toast'), findsNothing);
        expect(petImage('over_limit'), findsOneWidget);
      }
    });

    testWidgets('AC12_toast_bottom_is_12px_above_pet_top', (tester) async {
      final c = await pumpS1(tester, initial: day14(2150));
      await c.logNutrition(const FoodNutrition(calories: 10));
      await tester.pump();
      final toastBottom = tester.getBottomLeft(k('food_toast')).dy;
      final petTop = tester.getTopLeft(find.byKey(PetKeys.character)).dy;
      expect(petTop - toastBottom, docToastAnchor);
      // Toast อยู่เหนือสัตว์เลี้ยง และจัดกลางแนวนอนเหนือสัตว์เลี้ยง
      expect(tester.getCenter(k('food_toast')).dx,
          closeTo(tester.getCenter(find.byKey(PetKeys.character)).dx, 0.5));
      await drain(tester);
    });

    testWidgets('AC12_toast_stays_5s_then_disappears_pet_does_not_move',
        (tester) async {
      final c = await pumpS1(tester, initial: day14(2150));
      final petBefore = tester.getTopLeft(find.byKey(PetKeys.character));
      await c.logNutrition(const FoodNutrition(calories: 10));
      await tester.pump();
      expect(k('food_toast'), findsOneWidget);
      expect(tester.getTopLeft(find.byKey(PetKeys.character)), petBefore);
      await tester.pump(const Duration(milliseconds: 4900));
      expect(k('food_toast'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 200));
      expect(k('food_toast'), findsNothing);
      expect(tester.getTopLeft(find.byKey(PetKeys.character)), petBefore);
      await drain(tester);
    });

    testWidgets('EC2_AC12_rapid_logs_within_5s_single_toast_replaced',
        (tester) async {
      final c = await pumpS1(tester, initial: day14(2150));
      await c.logNutrition(const FoodNutrition(calories: 10));
      await tester.pump(const Duration(seconds: 3));
      await c.logNutrition(const FoodNutrition(calories: 10));
      await tester.pump();
      expect(k('food_toast'), findsOneWidget, reason: 'ไม่ค้างซ้อนกัน');
      expect(find.text(overLimitToast), findsOneWidget);
      // เลย 5 วินาทีของ Toast แรก (3 + 2.5 = 5.5 s) แต่ยังไม่ถึง 5 s ของ Toast ใหม่
      await tester.pump(const Duration(milliseconds: 2500));
      expect(k('food_toast'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 2600));
      expect(k('food_toast'), findsNothing);
      await drain(tester);
    });

    testWidgets('EC2_rapid_logs_via_S2_single_toast', (tester) async {
      await pumpS1(tester, initial: day14(2150));
      await logViaS2(tester, 'ขนม50');
      await logViaS2(tester, 'ขนม50');
      await logViaS2(tester, 'ขนม50');
      expect(k('food_toast'), findsOneWidget);
      await drain(tester);
    });

    testWidgets('GR4_foreground_crossing_05_00_resets_to_0', (tester) async {
      now = t(15, 4, 59, 58);
      await pumpS1(tester,
          initial: FoodState(
              day: d(14), totalCalories: 2500, lastSeenAt: t(15, 4, 59)));
      expect(textOf(tester, k('food_calorie_text')), '2,500 / 2,000 kcal');
      expect(petImage('over_limit'), findsOneWidget);
      now = t(15, 4, 59, 59);
      await tester.pump(const Duration(seconds: 1));
      expect(textOf(tester, k('food_calorie_text')), '2,500 / 2,000 kcal');
      now = t(15, 5);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(textOf(tester, k('food_calorie_text')), '0 / 2,000 kcal');
      expect(petImage('normal'), findsOneWidget);
      expect(badgeVisible(tester), isFalse);
    });

    testWidgets('GR4_resume_after_05_00_resets_to_0', (tester) async {
      await pumpS1(tester, initial: day14(1500));
      now = t(15, 6);
      tester.binding
          .handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      await tester.pump();
      expect(textOf(tester, k('food_calorie_text')), '0 / 2,000 kcal');
    });

    testWidgets('ASSUMPTION_Q1_entry_button_after_steps_before_report_tooltip',
        (tester) async {
      final water = WaterController(
          repository: InMemoryWaterRepository(), clock: () => now);
      await tester.pumpWidget(
          PetPalApp(waterController: water, foodController: makeController()));
      await tester.pumpAndSettle();
      final steps = tester.getCenter(k('steps_entry_button')).dx;
      final food = tester.getCenter(k('food_entry_button')).dx;
      final report = tester.getCenter(k('water_monthly_report_button')).dx;
      expect(food, greaterThan(steps));
      expect(food, lessThan(report));
      expect(tester.widget<IconButton>(k('food_entry_button')).tooltip,
          'โภชนาการ');
    });

    testWidgets('UI_entry_from_water_home_opens_S1', (tester) async {
      final c = makeController();
      final water = WaterController(
          repository: InMemoryWaterRepository(), clock: () => now);
      await tester.pumpWidget(PetPalApp(waterController: water, foodController: c));
      await tester.pumpAndSettle();
      await tester.tap(k('food_entry_button'));
      await tester.pumpAndSettle();
      expect(k('food_add_meal_button'), findsOneWidget);
      expect(k('food_energy_slot'), findsOneWidget);
    });
  });

  // =========================================================================
  // AC-8 / EC-4 / Q-9 / Q-13 โปรไฟล์ & CTA
  // =========================================================================
  group('AC-8 / EC-4 CTA Banner', () {
    testWidgets('DECIDED_Q13_no_profile_opens_S3_automatically',
        (tester) async {
      await pumpS1(tester, noProfile: true);
      expect(k('food_profile_save_button'), findsOneWidget);
      expect(k('food_profile_skip_button'), findsOneWidget);
    });

    testWidgets('DECIDED_Q13_existing_profile_does_not_open_S3',
        (tester) async {
      await pumpS1(tester);
      expect(k('food_profile_save_button'), findsNothing);
      expect(k('food_energy_bar'), findsOneWidget);
    });

    testWidgets('DECIDED_Q13_signup_profile_shows_bar_without_S3',
        (tester) async {
      final signup = SignupController(repository: FakeAuthRepository());
      await tester.runAsync(() async {
        await signup.load();
        await signup.signUpWithEmail('mali@email.com', 'secret1');
        await signup.saveProfile(
            displayName: 'มะลิ',
            age: '25',
            gender: SignupGender.male,
            weight: '50',
            height: '175',
            healthGoal: 'ดูแลสุขภาพ');
      });
      await pumpS1(tester, source: SignupFoodProfileSource(signup));
      expect(k('food_profile_save_button'), findsNothing);
      // ชาย 25 ปี BMI 16.3 → 2,000 + 400
      expect(textOf(tester, k('food_calorie_text')), '0 / 2,400 kcal');
    });

    testWidgets('AC8_EC4_skip_shows_cta_banner_text_and_total',
        (tester) async {
      await pumpS1(tester, noProfile: true, initial: day14(1250));
      await tester.tap(k('food_profile_skip_button'));
      await tester.pumpAndSettle();
      expect(k('food_profile_cta_banner'), findsOneWidget);
      expect(textOf(tester, k('food_cta_text')), ctaText);
      expect(textOf(tester, k('food_cta_total_text')), contains('1,250'));
      expect(k('food_energy_bar'), findsNothing);
      expect(k('food_calorie_text'), findsNothing);
    });

    testWidgets('AC8_EC4_cta_banner_same_size_as_energy_widget_no_layout_shift',
        (tester) async {
      // แบบมีโปรไฟล์ (หลอดพลังงาน)
      await pumpS1(tester, initial: day14(1250));
      final barSlot = tester.getRect(k('food_energy_slot'));
      final barPet = tester.getRect(find.byKey(PetKeys.character));
      final barButton = tester.getRect(k('food_add_meal_button'));
      // แบบข้ามโปรไฟล์ (CTA)
      await tester.pumpWidget(const SizedBox());
      await pumpS1(tester, noProfile: true, initial: day14(1250));
      await tester.tap(k('food_profile_skip_button'));
      await tester.pumpAndSettle();
      final banner = tester.getRect(k('food_profile_cta_banner'));
      expect(banner.size, barSlot.size);
      expect(tester.getRect(k('food_energy_slot')), barSlot);
      expect(tester.getRect(find.byKey(PetKeys.character)), barPet);
      expect(tester.getRect(k('food_add_meal_button')), barButton);
    });

    testWidgets('GR4_AC8_cta_to_S3_save_replaces_banner_with_bar',
        (tester) async {
      await pumpS1(tester, noProfile: true, initial: day14(1250));
      await tester.tap(k('food_profile_skip_button'));
      await tester.pumpAndSettle();
      await tester.tap(k('food_profile_cta_banner'));
      await tester.pumpAndSettle();
      await tester.enterText(k('food_age_field'), '25');
      await tester.tap(k('food_gender_male'));
      await tester.enterText(k('food_weight_field'), '65');
      await tester.enterText(k('food_height_field'), '175');
      await tester.pump();
      await tester.tap(k('food_profile_save_button'));
      await tester.pumpAndSettle();
      expect(k('food_profile_cta_banner'), findsNothing);
      expect(textOf(tester, k('food_calorie_text')), '1,250 / 2,000 kcal');
    });

    testWidgets('AC8_cta_tap_opens_S3', (tester) async {
      await pumpS1(tester, noProfile: true);
      await tester.tap(k('food_profile_skip_button'));
      await tester.pumpAndSettle();
      await tester.tap(k('food_profile_cta_banner'));
      await tester.pumpAndSettle();
      expect(k('food_profile_save_button'), findsOneWidget);
    });

    testWidgets('DECIDED_Q9_skipped_logging_never_red_no_toast_no_badge',
        (tester) async {
      await pumpS1(tester, noProfile: true, initial: day14(5000));
      await tester.tap(k('food_profile_skip_button'));
      await tester.pumpAndSettle();
      await logViaS2(tester, 'ข้าวมันไก่');
      expect(petImage('eating'), findsOneWidget);
      expect(k('food_toast'), findsNothing);
      expect(badgeVisible(tester), isFalse);
      expect(textOf(tester, k('food_cta_total_text')), contains('5,400'));
      await tester.pump(const Duration(seconds: 2));
      expect(petImage('normal'), findsOneWidget);
      await drain(tester);
    });

    testWidgets('DECIDED_Q13_skip_persists_S3_not_reopened_on_reentry',
        (tester) async {
      final c = makeController(noProfile: true);
      await tester.pumpWidget(app(c));
      await tester.pumpAndSettle();
      await tester.tap(k('food_profile_skip_button'));
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(app(c));
      await tester.pumpAndSettle();
      expect(k('food_profile_save_button'), findsNothing);
      expect(k('food_profile_cta_banner'), findsOneWidget);
    });
  });

  // =========================================================================
  // S-2
  // =========================================================================
  group('S-2 เพิ่มเมนูอาหาร', () {
    Future<FoodController> openS2(WidgetTester tester,
        {FoodNutritionParser? parser, FoodState? initial}) async {
      final c = await pumpS1(tester, parser: parser, initial: initial);
      await tester.tap(k('food_add_meal_button'));
      await tester.pumpAndSettle();
      return c;
    }

    testWidgets('UI_S2_hint_submit_text_no_manual_field_in_normal_state',
        (tester) async {
      await openS2(tester);
      expect(find.text(mealHint), findsOneWidget);
      expect(
          find.descendant(
              of: k('food_meal_submit_button'), matching: find.text(submitText)),
          findsOneWidget);
      expect(k('food_manual_calorie_field'), findsNothing);
      expect(tester.widget<TextField>(k('food_meal_input_field')).maxLines,
          isNull, reason: 'Text Area / Multiline');
    });

    testWidgets('UI_S2_back_button_returns_to_S1', (tester) async {
      await openS2(tester);
      await tester.tap(k('food_meal_back_button'));
      await tester.pumpAndSettle();
      expect(k('food_add_meal_button'), findsOneWidget);
      expect(k('food_meal_input_field'), findsNothing);
    });

    testWidgets('AC1_menu_logged_back_to_S1_with_parsed_calories',
        (tester) async {
      await pumpS1(tester);
      await logViaS2(tester, 'ข้าวมันไก่ 1 จาน');
      expect(k('food_meal_input_field'), findsNothing);
      expect(textOf(tester, k('food_calorie_text')), '400 / 2,000 kcal');
      expect(petImage('eating'), findsOneWidget);
      await drain(tester);
    });

    testWidgets('AC2_range_menu_logs_median_500', (tester) async {
      await pumpS1(tester);
      await logViaS2(tester, 'เมนูช่วง');
      expect(textOf(tester, k('food_calorie_text')), '500 / 2,000 kcal');
      await drain(tester);
    });

    testWidgets('EC1_offline_switches_to_manual_form_menu_text_kept',
        (tester) async {
      await openS2(tester,
          parser: LocalMenuNutritionParser(offline: true, menu: testMenu));
      await tester.enterText(k('food_meal_input_field'), 'ข้าวมันไก่');
      await tester.tap(k('food_meal_submit_button'));
      await tester.pumpAndSettle();
      expect(k('food_manual_calorie_field'), findsOneWidget);
      expect(find.text(manualHint), findsOneWidget);
      expect(fieldText(tester, 'food_manual_calorie_field'), '',
          reason: 'ช่องว่าง ไม่เติม 300 ลงช่อง (ui-spec §2.2)');
      expect(fieldText(tester, 'food_meal_input_field'), 'ข้าวมันไก่');
      expect(k('food_meal_header_text'), findsOneWidget, reason: 'ยังอยู่ S-2');
    });

    testWidgets('EC1_manual_left_blank_logs_300', (tester) async {
      await openS2(tester,
          parser: LocalMenuNutritionParser(offline: true, menu: testMenu));
      await tester.enterText(k('food_meal_input_field'), 'ข้าวมันไก่');
      await tester.tap(k('food_meal_submit_button'));
      await tester.pumpAndSettle();
      await tester.tap(k('food_meal_submit_button'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));
      expect(textOf(tester, k('food_calorie_text')), '300 / 2,000 kcal');
      expect(petImage('eating'), findsOneWidget);
      await drain(tester);
    });

    testWidgets('EC1_manual_typed_450_logged', (tester) async {
      await openS2(tester,
          parser: LocalMenuNutritionParser(offline: true, menu: testMenu));
      await tester.tap(k('food_meal_submit_button'));
      await tester.pumpAndSettle();
      await tester.enterText(k('food_manual_calorie_field'), '450');
      await tester.tap(k('food_meal_submit_button'));
      await tester.pumpAndSettle();
      expect(textOf(tester, k('food_calorie_text')), '450 / 2,000 kcal');
      await drain(tester);
    });

    testWidgets('EC1_EDGE_manual_field_digits_only', (tester) async {
      await openS2(tester,
          parser: LocalMenuNutritionParser(offline: true, menu: testMenu));
      await tester.tap(k('food_meal_submit_button'));
      await tester.pumpAndSettle();
      await tester.enterText(k('food_manual_calorie_field'), '-12.5');
      await tester.pump();
      expect(fieldText(tester, 'food_manual_calorie_field'),
          isNot(contains('-')));
      expect(fieldText(tester, 'food_manual_calorie_field'),
          isNot(contains('.')));
    });

    // รอบ 2: DECIDED owner — คำถามค้างข้อ 11 ใช้ค่าของ Dev (ASSUMPTION 23): ≤ 5 หลัก, 0 บันทึกได้
    testWidgets('DECIDED_R2_Q11_manual_field_max_5_digits', (tester) async {
      await openS2(tester,
          parser: LocalMenuNutritionParser(offline: true, menu: testMenu));
      await tester.tap(k('food_meal_submit_button'));
      await tester.pumpAndSettle();
      await tester.enterText(k('food_manual_calorie_field'), '123456');
      await tester.pump();
      expect(fieldText(tester, 'food_manual_calorie_field'), '12345');
    });

    testWidgets('DECIDED_R2_Q11_manual_0_is_logged_as_0', (tester) async {
      await openS2(tester,
          parser: LocalMenuNutritionParser(offline: true, menu: testMenu),
          initial: day14(1000));
      await tester.tap(k('food_meal_submit_button'));
      await tester.pumpAndSettle();
      await tester.enterText(k('food_manual_calorie_field'), '0');
      await tester.tap(k('food_meal_submit_button'));
      await tester.pumpAndSettle();
      expect(k('food_meal_input_field'), findsNothing);
      expect(textOf(tester, k('food_calorie_text')), '1,000 / 2,000 kcal',
          reason: '0 ไม่ถูกแทนด้วย 300');
      await drain(tester);
    });

    testWidgets('DECIDED_Q17_menu_not_in_local_table_shows_manual_form',
        (tester) async {
      await openS2(tester);
      await tester.enterText(k('food_meal_input_field'), 'พิซซ่าดาวอังคาร');
      await tester.tap(k('food_meal_submit_button'));
      await tester.pumpAndSettle();
      expect(k('food_manual_calorie_field'), findsOneWidget);
    });

    testWidgets('AC1_EC1_EDGE_no_result_within_3s_shows_manual_form',
        (tester) async {
      await openS2(tester,
          parser: LocalMenuNutritionParser(
              menu: testMenu, latency: const Duration(seconds: 10)));
      await tester.enterText(k('food_meal_input_field'), 'ข้าวมันไก่');
      await tester.tap(k('food_meal_submit_button'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 2900));
      expect(k('food_manual_calorie_field'), findsNothing);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump();
      expect(k('food_manual_calorie_field'), findsOneWidget);
      await tester.pump(const Duration(seconds: 8));
    });

    testWidgets('AC1_EDGE_result_at_2_9s_is_logged', (tester) async {
      await openS2(tester,
          parser: LocalMenuNutritionParser(
              menu: testMenu, latency: const Duration(milliseconds: 2900)));
      await tester.enterText(k('food_meal_input_field'), 'ข้าวมันไก่');
      await tester.tap(k('food_meal_submit_button'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 2950));
      await tester.pumpAndSettle();
      expect(k('food_manual_calorie_field'), findsNothing);
      expect(textOf(tester, k('food_calorie_text')), '400 / 2,000 kcal');
      await drain(tester);
    });
  });

  // =========================================================================
  // S-3
  // =========================================================================
  group('S-3 ตั้งค่าโปรไฟล์', () {
    Future<FoodController> openS3(WidgetTester tester) =>
        pumpS1(tester, noProfile: true);

    Future<void> fill(WidgetTester tester,
        {String age = '25',
        String gender = 'food_gender_male',
        String weight = '65',
        String height = '175'}) async {
      await tester.enterText(k('food_age_field'), age);
      await tester.tap(k(gender));
      await tester.enterText(k('food_weight_field'), weight);
      await tester.enterText(k('food_height_field'), height);
      await tester.pump();
    }

    bool saveEnabled(WidgetTester tester) =>
        tester.widget<FilledButton>(k('food_profile_save_button')).onPressed !=
        null;

    testWidgets('UI_S3_hints_gender_options_and_button_texts_per_ux_flow',
        (tester) async {
      await openS3(tester);
      expect(find.text(ageHint), findsOneWidget);
      expect(find.text(weightHint), findsOneWidget);
      expect(find.text(heightHint), findsOneWidget);
      expect(
          find.descendant(
              of: k('food_gender_male'), matching: find.text(maleText)),
          findsOneWidget);
      expect(
          find.descendant(
              of: k('food_gender_female'), matching: find.text(femaleText)),
          findsOneWidget);
      expect(
          find.descendant(
              of: k('food_profile_save_button'),
              matching: find.text(saveProfileText)),
          findsOneWidget);
      expect(
          find.descendant(
              of: k('food_profile_skip_button'), matching: find.text(skipText)),
          findsOneWidget);
      expect(k('food_age_error_text'), findsNothing);
      expect(saveEnabled(tester), isFalse);
    });

    testWidgets('UI_S3_field_order_age_gender_weight_height', (tester) async {
      await openS3(tester);
      final ys = [
        'food_age_field',
        'food_gender_male',
        'food_weight_field',
        'food_height_field',
        'food_profile_save_button',
        'food_profile_skip_button',
      ].map((key) => tester.getTopLeft(k(key)).dy).toList();
      for (var i = 1; i < ys.length; i++) {
        expect(ys[i], greaterThan(ys[i - 1]));
      }
    });

    testWidgets('AC4_EC5_DECIDED_Q14_age_20_5_cannot_be_entered_or_saved',
        (tester) async {
      final c = await openS3(tester);
      await fill(tester, age: '20.5');
      expect(fieldText(tester, 'food_age_field'), isNot('20.5'));
      expect(fieldText(tester, 'food_age_field'), isNot(contains('.')));
      if (saveEnabled(tester)) {
        await tester.tap(k('food_profile_save_button'));
        await tester.pumpAndSettle();
      }
      expect(c.profile?.age, isNot(anyOf(20, 205)),
          reason: 'ห้ามบันทึกค่าอื่นแทน 20.5');
      expect(c.profile, isNull);
    });

    testWidgets('AC4_DECIDED_Q14_age_25_5_cannot_be_entered_or_saved',
        (tester) async {
      final c = await openS3(tester);
      await fill(tester, age: '25.5');
      expect(fieldText(tester, 'food_age_field'), isNot(contains('.')));
      if (saveEnabled(tester)) {
        await tester.tap(k('food_profile_save_button'));
        await tester.pumpAndSettle();
      }
      expect(c.profile, isNull);
    });

    testWidgets('DECIDED_Q14_dot_after_20_is_rejected_field_stays_20',
        (tester) async {
      await openS3(tester);
      await tester.enterText(k('food_age_field'), '20');
      await tester.enterText(k('food_age_field'), '20.');
      await tester.pump();
      expect(fieldText(tester, 'food_age_field'), '20');
    });

    for (final age in ['0', '121']) {
      testWidgets('AC4_EDGE_age_${age}_shows_inline_error_and_blocks_save',
          (tester) async {
        await openS3(tester);
        await fill(tester, age: age);
        expect(textOf(tester, k('food_age_error_text')), ageErrorText);
        expect(saveEnabled(tester), isFalse);
      });
    }

    for (final age in ['1', '120']) {
      testWidgets('AC4_EDGE_age_${age}_valid_no_error_save_enabled',
          (tester) async {
        await openS3(tester);
        await fill(tester, age: age);
        expect(k('food_age_error_text'), findsNothing);
        expect(saveEnabled(tester), isTrue);
      });
    }

    testWidgets('DECIDED_Q14_weight_height_accept_decimals', (tester) async {
      final c = await openS3(tester);
      await fill(tester, weight: '65.5', height: '175.5');
      expect(fieldText(tester, 'food_weight_field'), '65.5');
      expect(fieldText(tester, 'food_height_field'), '175.5');
      await tester.tap(k('food_profile_save_button'));
      await tester.pumpAndSettle();
      expect(c.profile!.weightKg, 65.5);
      expect(c.profile!.heightCm, 175.5);
    });

    testWidgets('AC5_save_male_25_normal_bmi_S1_shows_target_2000',
        (tester) async {
      await openS3(tester);
      await fill(tester);
      await tester.tap(k('food_profile_save_button'));
      await tester.pumpAndSettle();
      expect(k('food_profile_save_button'), findsNothing);
      expect(textOf(tester, k('food_calorie_text')), '0 / 2,000 kcal');
    });

    testWidgets('AC6_save_underweight_S1_shows_target_2400', (tester) async {
      await openS3(tester);
      await fill(tester, weight: '50', height: '175');
      await tester.tap(k('food_profile_save_button'));
      await tester.pumpAndSettle();
      expect(textOf(tester, k('food_calorie_text')), '0 / 2,400 kcal');
    });

    testWidgets('AC7_save_overweight_S1_shows_target_1600', (tester) async {
      await openS3(tester);
      await fill(tester, weight: '80', height: '170');
      await tester.tap(k('food_profile_save_button'));
      await tester.pumpAndSettle();
      expect(textOf(tester, k('food_calorie_text')), '0 / 1,600 kcal');
    });

    testWidgets('AC5_female_30_normal_bmi_target_1600', (tester) async {
      await openS3(tester);
      await fill(
          tester,
          age: '30',
          gender: 'food_gender_female',
          weight: '55',
          height: '165');
      await tester.tap(k('food_profile_save_button'));
      await tester.pumpAndSettle();
      expect(textOf(tester, k('food_calorie_text')), '0 / 1,600 kcal');
    });

    testWidgets('UI_S3_skip_button_always_enabled', (tester) async {
      await openS3(tester);
      await tester.enterText(k('food_age_field'), '0');
      await tester.pump();
      expect(
          tester.widget<TextButton>(k('food_profile_skip_button')).onPressed,
          isNotNull);
    });

    testWidgets('UI_S3_no_back_button_in_app_bar', (tester) async {
      await openS3(tester);
      expect(find.byType(BackButton), findsNothing);
    });
  });

  // =========================================================================
  // ความกว้างจอ / textScaler / OQ-1 asset
  // =========================================================================
  group('UI อื่น ๆ', () {
    // รอบ 2 (2026-10-31): DECIDED owner (D-5) — overflow ของช่องพลังงานเป็นบั๊ก ห้ามล็อก 88 px
    // ต้องรองรับตัวเลขยาวและ textScaler 1.5 บนจอ 360 dp → ใส่โหมดหลอดพลังงานกลับเข้ามา
    // (รอบ 1 ตัดออกเพราะ overflow 4 px ใน food_energy_block)
    testWidgets('UI_360dp_S1_bar_cta_S2_S3_no_overflow', (tester) async {
      set360(tester);
      // S-1 โหมดหลอด: "2,150 / 2,000 kcal" (ตัวอย่างที่ล้มรอบ 1)
      await pumpS1(tester, initial: day14(2150));
      expect(tester.takeException(), isNull);
      expect(k('food_energy_block'), findsOneWidget);
      expect(textOf(tester, k('food_calorie_text')), '2,150 / 2,000 kcal');
      expectEnergySlotHolds(tester, k('food_energy_block'));
      expectEnergySlotHolds(tester, k('food_calorie_text'));
      // ตัวเลขยาว total 5 หลัก และ 6 หลัก (ui-spec §5 checklist: 123,456 / 2,000 kcal)
      for (final total in [99999, 123456]) {
        await tester.pumpWidget(const SizedBox());
        await pumpS1(tester, initial: day14(total));
        expect(tester.takeException(), isNull, reason: 'total $total');
        expect(textOf(tester, k('food_calorie_text')), calText(total, 2000));
        expectEnergySlotHolds(tester, k('food_energy_block'));
        expectEnergySlotHolds(tester, k('food_calorie_text'));
      }
      // S-3 → CTA → S-2
      await tester.pumpWidget(const SizedBox());
      await pumpS1(tester, noProfile: true);
      expect(tester.takeException(), isNull);
      await tester.tap(k('food_profile_skip_button'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expectEnergySlotHolds(tester, k('food_profile_cta_banner'));
      await tester.tap(k('food_add_meal_button'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    for (final scale in [1.0, 1.5]) {
      final tag = 'textScale${scale.toString().replaceAll('.', '_')}';

      testWidgets(
          'UI_360dp_${tag}_S1_bar_over_limit_badge_and_toast_no_overflow',
          (tester) async {
        set360(tester);
        final c =
            await pumpS1(tester, initial: day14(2150), textScale: scale);
        expect(tester.takeException(), isNull);
        expect(textOf(tester, k('food_calorie_text')), '2,150 / 2,000 kcal');
        expect(
            tester.widget<LinearProgressIndicator>(k('food_energy_bar')).color,
            schemeOf(tester).error);
        expect(badgeVisible(tester), isTrue);
        expect(
            find.descendant(
                of: k('food_full_badge'), matching: find.text(fullBadgeText)),
            findsOneWidget);
        expectEnergySlotHolds(tester, k('food_energy_block'));
        expectEnergySlotHolds(tester, k('food_calorie_text'));
        final petBefore = tester.getRect(find.byKey(PetKeys.character));
        // บันทึกซ้ำขณะเกินเป้า → ท่าอิ่มแต่ยังกิน + Toast (AC-11 / AC-12)
        await c.logNutrition(const FoodNutrition(calories: 10));
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(petImage('over_limit_feeding'), findsOneWidget);
        expect(textOf(tester, k('food_over_limit_toast')), overLimitToast);
        expect(
            tester
                .renderObject<RenderParagraph>(k('food_over_limit_toast'))
                .didExceedMaxLines,
            isFalse,
            reason: 'ข้อความ Toast ต้องไม่ถูกตัด');
        expect(textOf(tester, k('food_calorie_text')), '2,160 / 2,000 kcal');
        expect(
            tester.getTopLeft(find.byKey(PetKeys.character)).dy -
                tester.getBottomLeft(k('food_toast')).dy,
            docToastAnchor);
        expect(tester.getRect(find.byKey(PetKeys.character)), petBefore,
            reason: 'Toast ไม่ดันสัตว์เลี้ยง');
        expectEnergySlotHolds(tester, k('food_energy_block'));
        await drain(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('UI_360dp_${tag}_S1_bar_long_totals_no_overflow',
          (tester) async {
        set360(tester);
        for (final total in [12345, 99999, 123456]) {
          await tester.pumpWidget(const SizedBox());
          await pumpS1(tester, initial: day14(total), textScale: scale);
          expect(tester.takeException(), isNull, reason: 'total $total');
          expect(textOf(tester, k('food_calorie_text')), calText(total, 2000));
          expectEnergySlotHolds(tester, k('food_energy_block'));
          expectEnergySlotHolds(tester, k('food_calorie_text'));
          expect(badgeVisible(tester), isTrue);
        }
      });

      testWidgets('UI_360dp_${tag}_S1_cta_long_totals_no_overflow',
          (tester) async {
        set360(tester);
        for (final total in [1250, 99999, 123456]) {
          await tester.pumpWidget(const SizedBox());
          final c =
              makeController(noProfile: true, initial: skipped14(total));
          await tester.pumpWidget(app(c, textScale: scale));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: 'total $total');
          expect(k('food_profile_cta_banner'), findsOneWidget);
          expect(
              textOf(tester, k('food_cta_total_text')), contains(fmt(total)));
          expectEnergySlotHolds(tester, k('food_profile_cta_banner'));
          expect(tester.getSize(k('food_profile_cta_banner')),
              tester.getSize(k('food_energy_slot')));
        }
      });

      // AC-8: CTA ต้องแสดงยอดรวมแคลอรี่วันนี้ + D-5: ต้องรองรับตัวเลขยาวและ textScaler 1.5
      // → ยอดรวมต้องอ่านได้ครบ ไม่ถูกตัด ellipsis (ui-spec §2.1 #9b ไม่ได้กำหนด maxLines/ellipsis
      // ให้ยอดรวม — กำหนดเฉพาะข้อความชวน maxLines 2)
      testWidgets('AC8_DECIDED_D5_360dp_${tag}_cta_total_long_number_not_truncated',
          (tester) async {
        set360(tester);
        for (final total in [12345, 99999, 123456]) {
          await tester.pumpWidget(const SizedBox());
          final c =
              makeController(noProfile: true, initial: skipped14(total));
          await tester.pumpWidget(app(c, textScale: scale));
          await tester.pumpAndSettle();
          expect(
              textOf(tester, k('food_cta_total_text')), contains(fmt(total)));
          expect(
              tester
                  .renderObject<RenderParagraph>(k('food_cta_total_text'))
                  .didExceedMaxLines,
              isFalse,
              reason: 'ยอดรวม ${fmt(total)} kcal ถูกตัด (ellipsis) ที่ textScaler $scale');
        }
      });

      testWidgets('UI_360dp_${tag}_S3_S2_normal_and_manual_no_overflow',
          (tester) async {
        set360(tester);
        await pumpS1(tester, noProfile: true, textScale: scale);
        expect(k('food_profile_save_button'), findsOneWidget, reason: 'S-3');
        expect(tester.takeException(), isNull);
        // S-3 กรอกค่าผิด (error inline) ก็ต้องไม่ overflow
        await tester.enterText(k('food_age_field'), '121');
        await tester.pump();
        expect(k('food_age_error_text'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(k('food_profile_skip_button'));
        await tester.pumpAndSettle();
        await tester.tap(k('food_profile_skip_button'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(k('food_add_meal_button'));
        await tester.pumpAndSettle();
        await tester.tap(k('food_add_meal_button'));
        await tester.pumpAndSettle();
        expect(k('food_meal_input_field'), findsOneWidget, reason: 'S-2');
        expect(tester.takeException(), isNull);
        // S-2 สถานะกรอกเอง (เมนูไม่อยู่ในตาราง — Q-17)
        await tester.enterText(k('food_meal_input_field'), 'พิซซ่าดาวอังคาร');
        await tester.ensureVisible(k('food_meal_submit_button'));
        await tester.pumpAndSettle();
        await tester.tap(k('food_meal_submit_button'));
        await tester.pumpAndSettle();
        expect(k('food_manual_calorie_field'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      // AC-8 / EC-4: สลับ CTA → หลอดบนหน้าเดียวกัน (ตั้งโปรไฟล์หลังข้าม) ต้องไม่มี layout shift
      testWidgets('AC8_EC4_360dp_${tag}_switch_cta_to_bar_no_layout_shift',
          (tester) async {
        set360(tester);
        final c = makeController(noProfile: true, initial: skipped14(1250));
        await tester.pumpWidget(app(c, textScale: scale));
        await tester.pumpAndSettle();
        expect(k('food_profile_cta_banner'), findsOneWidget);
        final ctaSlot = tester.getRect(k('food_energy_slot'));
        final ctaPet = tester.getRect(find.byKey(PetKeys.character));
        final ctaButton = tester.getRect(k('food_add_meal_button'));
        expect(tester.getSize(k('food_profile_cta_banner')), ctaSlot.size);
        expect(ctaSlot.height, greaterThanOrEqualTo(docEnergySlotMinHeight));

        final out = await c.saveProfile(
            age: '25', gender: SignupGender.male, weight: '65', height: '175');
        expect(out, FoodProfileSaveOutcome.saved);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(k('food_profile_cta_banner'), findsNothing);
        expect(textOf(tester, k('food_calorie_text')), '1,250 / 2,000 kcal');
        expect(tester.getRect(k('food_energy_slot')), ctaSlot);
        expect(tester.getRect(find.byKey(PetKeys.character)), ctaPet);
        expect(tester.getRect(k('food_add_meal_button')), ctaButton);
        expectEnergySlotHolds(tester, k('food_energy_block'));
      });

      // AC-8 / EC-4: เปิดแบบมีโปรไฟล์ (หลอด) เทียบกับเปิดแบบข้ามโปรไฟล์ (CTA)
      testWidgets('AC8_EC4_360dp_${tag}_bar_vs_cta_same_slot_pet_button',
          (tester) async {
        set360(tester);
        await pumpS1(tester, initial: day14(1250), textScale: scale);
        final barSlot = tester.getRect(k('food_energy_slot'));
        final barPet = tester.getRect(find.byKey(PetKeys.character));
        final barButton = tester.getRect(k('food_add_meal_button'));
        expect(barSlot.height, greaterThanOrEqualTo(docEnergySlotMinHeight));
        await tester.pumpWidget(const SizedBox());
        final c = makeController(noProfile: true, initial: skipped14(1250));
        await tester.pumpWidget(app(c, textScale: scale));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(tester.getSize(k('food_profile_cta_banner')), barSlot.size);
        expect(tester.getRect(k('food_energy_slot')), barSlot);
        expect(tester.getRect(find.byKey(PetKeys.character)), barPet);
        expect(tester.getRect(k('food_add_meal_button')), barButton);
      });
    }

    testWidgets('DECIDED_D5_energy_slot_at_least_88_and_grows_with_text_scale',
        (tester) async {
      // D-5: ห้ามล็อก 88 — ตรวจแค่ "≥ 88" และช่องต้องไม่เตี้ยลงเมื่อขยายตัวอักษร
      set360(tester);
      await pumpS1(tester, initial: day14(2150), textScale: 1.0);
      final h10 = tester.getSize(k('food_energy_slot')).height;
      await tester.pumpWidget(const SizedBox());
      await pumpS1(tester, initial: day14(2150), textScale: 1.5);
      final h15 = tester.getSize(k('food_energy_slot')).height;
      expect(h10, greaterThanOrEqualTo(docEnergySlotMinHeight));
      expect(h15, greaterThanOrEqualTo(docEnergySlotMinHeight));
      expect(h15, greaterThan(h10),
          reason: 'ยืนยันว่า textScaler 1.5 มีผลจริงในเทสต์ (ช่องโตตามเนื้อหา ไม่ล็อกความสูง)');
      expect(tester.takeException(), isNull);
    });

    test('DECIDED_OQ1_no_lottie_package_and_no_pet_json_assets_in_food', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      expect(pubspec, isNot(contains('lottie')));
      final dir = Directory('lib/features/food');
      for (final f in dir.listSync(recursive: true).whereType<File>()) {
        final src = f.readAsStringSync();
        expect(src, isNot(contains('assets/images/pet/')), reason: f.path);
        expect(src, isNot(contains('Image.asset')), reason: f.path);
      }
    });
  });
}
