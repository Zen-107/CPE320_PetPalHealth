// Widget tests: S-1 หน้าจอแดชบอร์ดหลัก + ทางเข้าจากหน้า water
// ข้อความบนจอคัดลอกตรงตัวจาก docs/dashboard/ux-flow.md §2 / game-rules.md §1.1
// ValueKey / ขนาด / ระยะ / สี จาก docs/dashboard/ui-spec.md · ข้อความ "(เสนอ — รอยืนยัน)" ของ ui-spec
// ใช้ตามข้อตัดสิน owner (Q-1, Q-8) ชื่อเทสต์ขึ้นต้น DECIDED_
// เวลา: clock ของ 3 controller + tester.pump(Duration) — ไม่ใช้เวลาจริง ห้าม pumpAndSettle บน S-1
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/dashboard/screens/dashboard_screen.dart';
import 'package:petpal_health/features/food/food_models.dart';
import 'package:petpal_health/features/food/screens/food_profile_screen.dart';
import 'package:petpal_health/main.dart';
import 'package:petpal_health/shared/pet/pet.dart';

import 'dashboard_test_helpers.dart';

Finder k(String key) => find.byKey(Key(key));
Finder petImage(String mood) => k('dashboard_pet_image_$mood');

String textOf(WidgetTester tester, Finder f) => tester.widget<Text>(f).data!;

ColorScheme schemeOf(WidgetTester tester) =>
    Theme.of(tester.element(k('dashboard_total_score_card'))).colorScheme;

LinearProgressIndicator bar(WidgetTester tester, String name) =>
    tester.widget<LinearProgressIndicator>(k('dashboard_${name}_bar'));

PetPose painterPose(WidgetTester tester) =>
    (tester.widget<CustomPaint>(find.byKey(PetKeys.painter).last).painter!
            as PetCharacterPainter)
        .pose;

/// กล่องสัตว์เลี้ยงของ dashboard (เปิดจาก water แล้วมี 2 ตัว → ตัวหลังสุด)
Finder dashPet() => find.byKey(PetKeys.character).last;

void set360(WidgetTester tester, {double textScale = 1.0}) {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
}

void main() {
  late DateTime now;

  setUp(() => now = t(14, 10));

  Sources sources({
    int cups = 0,
    int steps = 0,
    int kcal = 0,
    bool noProfile = false,
  }) =>
      makeSources(
        clock: () => now,
        water: water14(cups),
        steps: steps14(steps),
        food: food14(kcal, skipped: noProfile),
        noProfile: noProfile,
      );

  Widget app(Sources s) => MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue)),
        home: DashboardScreen(
          waterController: s.water,
          stepsController: s.steps,
          foodController: s.food,
          animatePet: false,
        ),
      );

  /// เปิด S-1 ตรง ๆ (controller ยังไม่โหลด — S-1 โหลดเอง)
  Future<Sources> pumpS1(
    WidgetTester tester, {
    int cups = 0,
    int steps = 0,
    int kcal = 0,
    bool noProfile = false,
  }) async {
    final s = sources(cups: cups, steps: steps, kcal: kcal, noProfile: noProfile);
    await tester.pumpWidget(app(s));
    for (var i = 0; i < 3; i++) {
      await tester.pump();
    }
    return s;
  }

  /// เปิดหน้า water (หน้าแรก — Q-7) แล้วกด dashboard_entry_button
  Future<Sources> pumpViaWater(
    WidgetTester tester, {
    int cups = 0,
    int steps = 0,
    int kcal = 0,
    bool noProfile = false,
  }) async {
    final s = sources(cups: cups, steps: steps, kcal: kcal, noProfile: noProfile);
    await tester.pumpWidget(PetPalApp(
        waterController: s.water,
        stepsController: s.steps,
        foodController: s.food));
    await tester.pumpAndSettle(); // หน้า water ยังไม่มีลูปไม่สิ้นสุด
    await tester.tap(k('dashboard_entry_button'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900)); // transition ของ route
    return s;
  }

  String totalOnScreen(WidgetTester tester) =>
      textOf(tester, k('dashboard_total_score_text'));
  String? alertOnScreen(WidgetTester tester) =>
      k('dashboard_alert_text').evaluate().isEmpty
          ? null
          : textOf(tester, k('dashboard_alert_text'));

  // =========================================================================
  // AC-4 องค์ประกอบครบ + ลำดับ
  // =========================================================================
  group('AC-4 องค์ประกอบของ S-1', () {
    testWidgets('AC4_total_card_pet_and_three_bars_present', (tester) async {
      await pumpS1(tester);
      expect(k('dashboard_total_score_card'), findsOneWidget);
      expect(k('dashboard_total_score_text'), findsOneWidget);
      expect(find.byKey(PetKeys.character), findsOneWidget);
      for (final n in ['food', 'steps', 'water']) {
        expect(k('dashboard_${n}_row'), findsOneWidget, reason: n);
        expect(k('dashboard_${n}_label_text'), findsOneWidget, reason: n);
        expect(k('dashboard_${n}_bar'), findsOneWidget, reason: n);
      }
      expect(k('dashboard_alert_slot'), findsOneWidget);
    });

    testWidgets('UI_layout_order_card_alert_pet_food_steps_water',
        (tester) async {
      await pumpS1(tester);
      double top(Finder f) => tester.getTopLeft(f).dy;
      final order = [
        top(k('dashboard_total_score_card')),
        top(k('dashboard_alert_slot')),
        top(find.byKey(PetKeys.character)),
        top(k('dashboard_food_row')),
        top(k('dashboard_steps_row')),
        top(k('dashboard_water_row')),
      ];
      for (var i = 1; i < order.length; i++) {
        expect(order[i], greaterThan(order[i - 1]), reason: 'ลำดับที่ $i');
      }
    });

    testWidgets('DECIDED_Q8_header_title', (tester) async {
      await pumpS1(tester);
      expect(textOf(tester, k('dashboard_header_text')), screenTitleText);
    });

    testWidgets('UI_bar_labels_format_and_bar_value_equals_score',
        (tester) async {
      // Food 1,200 = 60 · Steps 7,200 = 90 · Water 6 แก้ว = 75
      await pumpS1(tester, kcal: 1200, steps: 7200, cups: 6);
      expect(textOf(tester, k('dashboard_food_label_text')), foodText(60));
      expect(textOf(tester, k('dashboard_steps_label_text')), stepsText(90));
      expect(textOf(tester, k('dashboard_water_label_text')), waterText(75));
      expect(bar(tester, 'food').value, closeTo(0.60, 1e-9));
      expect(bar(tester, 'steps').value, closeTo(0.90, 1e-9));
      expect(bar(tester, 'water').value, closeTo(0.75, 1e-9));
      final cs = schemeOf(tester);
      for (final n in ['food', 'steps', 'water']) {
        expect(bar(tester, n).color, cs.primary, reason: n);
        expect(bar(tester, n).minHeight, 12, reason: 'ui-spec §1.3');
      }
    });

    testWidgets('UI_card_and_bubble_colors_from_color_scheme', (tester) async {
      await pumpS1(tester);
      final cs = schemeOf(tester);
      final card = tester.widget<Container>(k('dashboard_total_score_card'));
      expect((card.decoration! as BoxDecoration).color, cs.primaryContainer);
      // ui-spec ไม่ได้บังคับว่า key ของฟองต้องอยู่บน Container (ต่างจากการ์ดที่ระบุ "บน Container")
      final bubble = tester.widget<Container>(find
          .descendant(
              of: k('dashboard_alert_banner'), matching: find.byType(Container))
          .first);
      expect((bubble.decoration! as BoxDecoration).color, cs.secondaryContainer);
    });

    testWidgets('UI_loading_shows_only_progress_indicator', (tester) async {
      final pending = PendingWaterRepository();
      final s = makeSources(clock: () => now, waterRepo: pending);
      await tester.pumpWidget(app(s));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(k('dashboard_total_score_card'), findsNothing);
      pending.complete();
      await tester.pump();
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(totalOnScreen(tester), totalText(0));
    });
  });

  // =========================================================================
  // AC-1 / EC-1 / EC-4 / EC-5 คะแนนรวมบนจอ
  // =========================================================================
  group('AC-1 คะแนนรวมบนจอ', () {
    testWidgets('AC1_GR3_row1_equivalent_60_100_50_shows_70_bubbly',
        (tester) async {
      // game-rules §3 แถว 1 รวม 210 / 3 = 70 (น้ำทำ 60% ไม่ได้ด้วยเป้า 8 แก้ว จึงใช้ชุดที่ผลรวมเท่ากัน)
      await pumpS1(tester, kcal: 1200, steps: 8000, cups: 4);
      expect(totalOnScreen(tester), totalText(70));
      expect(petImage('bubbly'), findsOneWidget);
    });

    // R3: owner ข้อ 2 (floor) ชนะ EC-5 — เดิมคาด 66
    testWidgets('DECIDED_R3_EC5_GR3_row2_equivalent_65_67_shows_65_bubbly',
        (tester) async {
      // Food 71 (1,420) + Steps 76 (6,080) + Water 50 (4) = 197 / 3 = 65.67 → floor 65
      await pumpS1(tester, kcal: 1420, steps: 6080, cups: 4);
      expect(totalOnScreen(tester), totalText(65));
      expect(petImage('bubbly'), findsOneWidget);
    });

    testWidgets('EC4_GR3_row3_negative_food_shows_0_total_60_dazed',
        (tester) async {
      // Food −10 → 0, Steps 80 (6,400), Water 100 (8) → 180 / 3 = 60 → DAZED
      await pumpS1(tester, kcal: -10, steps: 6400, cups: 8);
      expect(textOf(tester, k('dashboard_food_label_text')), foodText(0));
      expect(bar(tester, 'food').value, 0);
      expect(totalOnScreen(tester), totalText(60));
      expect(petImage('dazed'), findsOneWidget);
    });

    testWidgets('EC1_GR4_over_target_everywhere_capped_100_cheerful',
        (tester) async {
      await pumpS1(tester, cups: 13, steps: 20000, kcal: 2000);
      expect(totalOnScreen(tester), totalText(100));
      expect(textOf(tester, k('dashboard_water_label_text')), waterText(100));
      expect(textOf(tester, k('dashboard_steps_label_text')), stepsText(100));
      for (final n in ['food', 'steps', 'water']) {
        expect(bar(tester, n).value, lessThanOrEqualTo(1.0), reason: n);
      }
      expect(petImage('cheerful'), findsOneWidget);
    });

    testWidgets('AC1_EC5_total_text_is_integer_no_decimal', (tester) async {
      await pumpS1(tester, kcal: 1420, steps: 6080, cups: 4);
      expect(RegExp(r'^คะแนนสุขภาพรวม: \d{1,3}%$').hasMatch(totalOnScreen(tester)),
          isTrue);
    });

    testWidgets('EDGE_EC4_first_open_empty_all_0_crying_P2', (tester) async {
      final s = makeSources(clock: () => now);
      await tester.pumpWidget(app(s));
      await tester.pump();
      await tester.pump();
      expect(totalOnScreen(tester), totalText(0));
      expect(textOf(tester, k('dashboard_food_label_text')), foodText(0));
      expect(textOf(tester, k('dashboard_steps_label_text')), stepsText(0));
      expect(textOf(tester, k('dashboard_water_label_text')), waterText(0));
      expect(petImage('crying'), findsOneWidget);
      expect(alertOnScreen(tester), p2Text);
    });

    testWidgets('EC4_EDGE_corrupt_storage_no_crash_all_0', (tester) async {
      final s = makeSources(
        clock: () => now,
        waterRepo: BrokenWaterRepository(),
        stepsRepo: BrokenStepsRepository(),
        foodRepo: BrokenFoodRepository(),
      );
      await tester.pumpWidget(app(s));
      await tester.pump();
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(totalOnScreen(tester), totalText(0));
      expect(petImage('crying'), findsOneWidget);
    });

    testWidgets('UI_realtime_update_when_source_changes', (tester) async {
      final s = await pumpS1(tester, cups: 3);
      // R3: owner ข้อ 2 (floor) — 3 แก้ว 37.5 → 37 (เดิมคาด 38)
      expect(textOf(tester, k('dashboard_water_label_text')), waterText(37));
      await s.water.logWater(); // 4 แก้ว
      await tester.pump();
      expect(textOf(tester, k('dashboard_water_label_text')), waterText(50));
    });
  });

  // =========================================================================
  // AC-2 อารมณ์สัตว์เลี้ยงบนจอ (D-1 PetCharacter)
  // =========================================================================
  group('AC-2 อารมณ์สัตว์เลี้ยง', () {
    // (kcal, steps, cups) → total, mood · เป้าอาหาร 2,000 / ก้าว 8,000 / น้ำ 8
    final cases = <(int, int, int, int, String, PetPose)>[
      (0, 0, 0, 0, 'crying', PetPose.dashboardCrying),
      (1800, 0, 0, 30, 'crying', PetPose.dashboardCrying), // 90/3
      (1860, 0, 0, 31, 'dazed', PetPose.dashboardDazed), // 93/3
      (2000, 6400, 0, 60, 'dazed', PetPose.dashboardDazed), // 180/3
      (2000, 6640, 0, 61, 'bubbly', PetPose.dashboardBubbly), // 183/3
      (1800, 8000, 4, 80, 'bubbly', PetPose.dashboardBubbly), // 240/3
      (1860, 8000, 4, 81, 'cheerful', PetPose.dashboardCheerful), // 243/3
      (2000, 8000, 8, 100, 'cheerful', PetPose.dashboardCheerful),
    ];
    for (final (kcal, steps, cups, total, mood, pose) in cases) {
      testWidgets('AC2_EDGE_total_${total}_is_$mood', (tester) async {
        await pumpS1(tester, kcal: kcal, steps: steps, cups: cups);
        expect(totalOnScreen(tester), totalText(total));
        expect(petImage(mood), findsOneWidget);
        expect(painterPose(tester), pose);
        expect(
            find.descendant(
                of: petImage(mood), matching: find.byKey(PetKeys.character)),
            findsOneWidget);
      });
    }

    testWidgets('DECIDED_D1_PetCharacter_size_200_no_png', (tester) async {
      await pumpS1(tester);
      expect(find.byType(PetCharacter), findsOneWidget);
      expect(find.byType(Image), findsNothing, reason: 'D-1 ไม่ใช้ PNG');
      expect(tester.getSize(find.byKey(PetKeys.character)),
          const Size(docPetSize, docPetSize));
    });

    testWidgets('DECIDED_Q20_no_cheerTrigger_and_state_kept_on_mood_change',
        (tester) async {
      final s = await pumpS1(tester, steps: 8000, cups: 8, kcal: 0);
      // (0 + 100 + 100) / 3 = 67 → bubbly
      expect(petImage('bubbly'), findsOneWidget);
      final before = tester.state(find.byType(PetCharacter));
      expect(tester.widget<PetCharacter>(find.byType(PetCharacter)).cheerTrigger,
          0);
      await s.food.logNutrition(const FoodNutrition(calories: 2000));
      await tester.pump();
      expect(petImage('cheerful'), findsOneWidget);
      expect(painterPose(tester), PetPose.dashboardCheerful);
      expect(identical(tester.state(find.byType(PetCharacter)), before), isTrue,
          reason: 'GlobalKey — State เดิมถูกใช้ต่อ');
      expect(tester.widget<PetCharacter>(find.byType(PetCharacter)).cheerTrigger,
          0);
      await tester.pump(const Duration(seconds: 6)); // ปล่อยท่าชั่วคราว/Toast ของ food
    });

    testWidgets('AC2_animated_cheerful_runs_with_pump_duration',
        (tester) async {
      final s = sources(cups: 8, steps: 8000, kcal: 2000);
      await tester.pumpWidget(MaterialApp(
          home: DashboardScreen(
              waterController: s.water,
              stepsController: s.steps,
              foodController: s.food,
              animatePet: true)));
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      expect(petImage('cheerful'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  // =========================================================================
  // AC-3 / EC-2 ฟองข้อความ
  // =========================================================================
  group('AC-3 ฟองข้อความ', () {
    testWidgets('AC3_rotates_every_5s_P2_P3_P4_P2', (tester) async {
      await pumpS1(tester);
      expect(alertOnScreen(tester), p2Text);
      await tester.pump(const Duration(milliseconds: 4900));
      expect(alertOnScreen(tester), p2Text);
      await tester.pump(const Duration(milliseconds: 100));
      expect(alertOnScreen(tester), p3Text);
      await tester.pump(const Duration(seconds: docAlertIntervalSeconds));
      expect(alertOnScreen(tester), p4Text);
      await tester.pump(const Duration(seconds: docAlertIntervalSeconds));
      expect(alertOnScreen(tester), p2Text);
      expect(k('dashboard_alert_banner'), findsOneWidget);
    });

    // R3: owner ข้อ 2 — 2,150 kcal = 100 − ceil(7.5) = 92 (เดิมคาด 93) — เดิมชื่อ ..._93
    testWidgets('AC3_P1_exact_text_shown_once_red_food_bar_DECIDED_R3_92',
        (tester) async {
      await pumpS1(tester, kcal: 2150);
      expect(alertOnScreen(tester), p1Text);
      expect(find.text(p1Text), findsOneWidget);
      expect(k('dashboard_alert_banner'), findsOneWidget);
      expect(bar(tester, 'food').color, schemeOf(tester).error);
      expect(textOf(tester, k('dashboard_food_label_text')), foodText(92));
      expect(bar(tester, 'food').value, closeTo(0.92, 1e-9), reason: 'Q-5');
      final txt = tester.widget<Text>(k('dashboard_alert_text'));
      expect(txt.maxLines, isNull);
      expect(txt.overflow, isNot(TextOverflow.ellipsis));
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('AC3_EDGE_P1_2100_not_red_2101_red', (tester) async {
      final s = await pumpS1(tester, kcal: 2100);
      expect(bar(tester, 'food').color, schemeOf(tester).primary);
      expect(alertOnScreen(tester), isNot(p1Text));
      expect(textOf(tester, k('dashboard_food_label_text')), foodText(95));
      await s.food.logNutrition(const FoodNutrition(calories: 1));
      await tester.pump();
      expect(bar(tester, 'food').color, schemeOf(tester).error);
      expect(alertOnScreen(tester), p1Text, reason: 'Q-19: ข้อความใหม่ Priority สูงสุด');
      await tester.pump(const Duration(seconds: 6));
    });

    testWidgets('EC2_resolve_shown_P2_switches_without_waiting',
        (tester) async {
      final s = await pumpS1(tester, cups: 7);
      await tester.pump(const Duration(seconds: 1));
      expect(alertOnScreen(tester), p2Text);
      await s.water.logWater();
      await tester.pump();
      expect(alertOnScreen(tester), p3Text);
      expect(textOf(tester, k('dashboard_water_label_text')), waterText(100));
    });

    testWidgets('AC3_EDGE_empty_queue_hides_banner_keeps_slot',
        (tester) async {
      final s = await pumpS1(tester, cups: 7, steps: 8000, kcal: 2000);
      expect(alertOnScreen(tester), p2Text);
      final slotBefore = tester.getSize(k('dashboard_alert_slot'));
      final petBefore = tester.getTopLeft(find.byKey(PetKeys.character));
      await s.water.logWater();
      await tester.pump();
      expect(k('dashboard_alert_banner'), findsNothing);
      expect(k('dashboard_alert_text'), findsNothing);
      expect(k('dashboard_alert_slot'), findsOneWidget);
      expect(tester.getSize(k('dashboard_alert_slot')), slotBefore);
      expect(tester.getTopLeft(find.byKey(PetKeys.character)), petBefore);
    });

    testWidgets('UI_slot_height_constant_and_pet_still_while_rotating',
        (tester) async {
      await pumpS1(tester, kcal: 2150); // P1 → P2 → P3
      final sizes = <Size>[];
      final pets = <Offset>[];
      for (var i = 0; i < 3; i++) {
        sizes.add(tester.getSize(k('dashboard_alert_slot')));
        pets.add(tester.getTopLeft(find.byKey(PetKeys.character)));
        await tester.pump(const Duration(seconds: docAlertIntervalSeconds));
      }
      expect(sizes.toSet().length, 1, reason: '$sizes');
      expect(pets.toSet().length, 1, reason: '$pets');
    });

    testWidgets('UI_alert_slot_bottom_12px_above_pet_box', (tester) async {
      await pumpS1(tester);
      final slot = tester.getRect(k('dashboard_alert_slot'));
      final pet = tester.getRect(find.byKey(PetKeys.character));
      expect(pet.top - slot.bottom, closeTo(docAlertAnchor, 0.01));
      final banner = tester.getRect(k('dashboard_alert_banner'));
      expect(banner.top >= slot.top - 0.01 && banner.bottom <= slot.bottom + 0.01,
          isTrue);
    });
  });

  // =========================================================================
  // Q-1 ไม่มีเป้าอาหาร
  // =========================================================================
  group('DECIDED_Q1 ไม่มีเป้าอาหาร', () {
    testWidgets('DECIDED_Q1_no_target_label_color_bar0_total_avg2',
        (tester) async {
      await pumpS1(tester, noProfile: true, kcal: 5000, steps: 8000, cups: 4);
      expect(textOf(tester, k('dashboard_food_label_text')), foodNoTargetText);
      expect(tester.widget<Text>(k('dashboard_food_label_text')).style?.color,
          schemeOf(tester).onSurfaceVariant);
      expect(bar(tester, 'food').value, 0);
      expect(bar(tester, 'food').color, schemeOf(tester).primary);
      // round((100 + 50) / 2) = 75
      expect(totalOnScreen(tester), totalText(75));
      expect(petImage('bubbly'), findsOneWidget);
      expect(find.text(p1Text), findsNothing, reason: 'Q-2');
    });
  });

  // =========================================================================
  // AC-5 / EC-3 ข้าม 05:00 ขณะเปิดหน้าค้าง
  // =========================================================================
  group('AC-5 / EC-3 ข้าม 05:00', () {
    testWidgets('AC5_EC3_EDGE_open_04_59_59_then_05_00_00_resets_screen',
        (tester) async {
      now = t(15, 4, 59, 59);
      await pumpS1(tester, kcal: 2000, steps: 8000, cups: 8);
      expect(totalOnScreen(tester), totalText(100));
      expect(petImage('cheerful'), findsOneWidget);
      expect(k('dashboard_alert_banner'), findsNothing);
      await tester.pump(const Duration(seconds: 1));
      expect(totalOnScreen(tester), totalText(100), reason: 'ยัง 04:59:59');
      now = t(15, 5);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(totalOnScreen(tester), totalText(0));
      expect(textOf(tester, k('dashboard_food_label_text')), foodText(0));
      expect(textOf(tester, k('dashboard_steps_label_text')), stepsText(0));
      expect(textOf(tester, k('dashboard_water_label_text')), waterText(0));
      expect(petImage('crying'), findsOneWidget);
      expect(alertOnScreen(tester), p2Text);
      expect(find.byType(SnackBar), findsNothing);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('AC5_resume_after_05_00_resets', (tester) async {
      await pumpS1(tester, kcal: 2000, steps: 8000, cups: 8);
      expect(totalOnScreen(tester), totalText(100));
      now = t(15, 6);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      await tester.pump();
      expect(totalOnScreen(tester), totalText(0));
    });
  });

  // =========================================================================
  // ทางเข้าจากหน้า water (Q-7, ui-spec §2.0)
  // =========================================================================
  group('ทางเข้าจาก water', () {
    testWidgets('DECIDED_Q7_entry_button_icon_tooltip_position',
        (tester) async {
      final s = sources();
      await tester.pumpWidget(PetPalApp(
          waterController: s.water,
          stepsController: s.steps,
          foodController: s.food));
      await tester.pumpAndSettle();
      final btn = tester.widget<IconButton>(k('dashboard_entry_button'));
      expect(btn.tooltip, screenTitleText);
      expect((btn.icon as Icon).icon, Icons.dashboard);
      final food = tester.getCenter(k('food_entry_button')).dx;
      final dash = tester.getCenter(k('dashboard_entry_button')).dx;
      final report = tester.getCenter(k('water_monthly_report_button')).dx;
      expect(dash, greaterThan(food));
      expect(dash, lessThan(report));
      expect(k('dashboard_header_text'), findsNothing, reason: 'water ยังเป็นหน้าแรก');
    });

    testWidgets('DECIDED_Q7_tap_opens_S1_with_same_controllers_and_back',
        (tester) async {
      final s = sources(cups: 3, steps: 7200, kcal: 1200);
      await s.loadAll();
      await s.water.logWater(); // 4 แก้ว บนหน้า water
      await tester.pumpWidget(PetPalApp(
          waterController: s.water,
          stepsController: s.steps,
          foodController: s.food));
      await tester.pumpAndSettle();
      await tester.tap(k('dashboard_entry_button'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));
      expect(textOf(tester, k('dashboard_header_text')), screenTitleText);
      expect(textOf(tester, k('dashboard_water_label_text')), waterText(50));
      expect(textOf(tester, k('dashboard_steps_label_text')), stepsText(90));
      expect(textOf(tester, k('dashboard_food_label_text')), foodText(60));
      expect(find.byType(BackButton), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));
      expect(k('dashboard_header_text'), findsNothing);
    });
  });

  // =========================================================================
  // R3 ข้อ 5: ไม่มีเป้าอาหาร → CTA เดิมของ food ใต้แถบอาหาร → S-3 ของ food
  // =========================================================================
  group('DECIDED_R3 CTA ตั้งโปรไฟล์', () {
    testWidgets('DECIDED_R3_Q5_no_target_shows_food_cta_under_food_bar',
        (tester) async {
      await pumpS1(tester, noProfile: true, kcal: 300);
      expect(k('food_profile_cta_banner'), findsOneWidget);
      expect(
          find.descendant(
              of: k('food_profile_cta_banner'), matching: find.text(foodCtaText)),
          findsOneWidget);
      final barRect = tester.getRect(k('dashboard_food_bar'));
      final cta = tester.getRect(k('food_profile_cta_banner'));
      final steps = tester.getRect(k('dashboard_steps_row'));
      expect(cta.top, greaterThanOrEqualTo(barRect.bottom), reason: 'ใต้แถบอาหาร');
      expect(cta.bottom, lessThanOrEqualTo(steps.top), reason: 'ก่อนแถบก้าว');
    });

    testWidgets('DECIDED_R3_Q5_with_target_no_cta', (tester) async {
      await pumpS1(tester, kcal: 300);
      expect(k('food_profile_cta_banner'), findsNothing);
    });

    testWidgets('DECIDED_R3_Q5_tap_cta_opens_food_profile_screen',
        (tester) async {
      await pumpS1(tester, noProfile: true);
      await tester.ensureVisible(k('food_profile_cta_banner'));
      await tester.tap(k('food_profile_cta_banner'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));
      expect(find.byType(FoodProfileScreen), findsOneWidget);
      expect(k('food_profile_save_button'), findsOneWidget);
    });

    for (final scale in [1.0, 1.5]) {
      testWidgets('DECIDED_R3_Q5_360_scale_${scale}_cta_no_overflow',
          (tester) async {
        set360(tester, textScale: scale);
        await pumpS1(tester, noProfile: true, kcal: 1500);
        expect(tester.takeException(), isNull);
        expect(k('food_profile_cta_banner'), findsOneWidget);
        final r = tester.getRect(k('food_profile_cta_banner'));
        expect(r.left >= 0 && r.right <= 360, isTrue, reason: '$r');
        final total = tester.renderObject<RenderParagraph>(find
            .descendant(
                of: k('food_cta_total_text'), matching: find.byType(RichText))
            .first);
        expect(total.didExceedMaxLines, isFalse, reason: 'ยอดรวมต้องไม่ถูกตัด');
        final tr = tester.getRect(k('food_cta_total_text'));
        expect(tr.top >= r.top && tr.bottom <= r.bottom, isTrue,
            reason: '$tr in $r');
      });
    }
  });

  // =========================================================================
  // R3 ข้อ 7: ปุ่มรายงานของ water เป็นปุ่มไอคอน · AppBar ไม่ล้นที่ 360 dp
  // =========================================================================
  group('DECIDED_R3 AppBar หน้า water', () {
    testWidgets('DECIDED_R3_Q7_report_button_icon_only_tooltip',
        (tester) async {
      final s = sources();
      await tester.pumpWidget(PetPalApp(
          waterController: s.water,
          stepsController: s.steps,
          foodController: s.food));
      await tester.pumpAndSettle();
      final report = k('water_monthly_report_button');
      expect(tester.widget(report), isA<IconButton>());
      expect(tester.widget<IconButton>(report).tooltip, 'รายงานรายเดือน');
      expect(find.descendant(of: report, matching: find.text('รายงานรายเดือน')),
          findsNothing, reason: 'ไม่มีข้อความบนปุ่ม');
    });

    for (final scale in [1.0, 1.5]) {
      testWidgets('DECIDED_R3_Q7_water_appbar_360_scale_${scale}_no_overflow',
          (tester) async {
        set360(tester, textScale: scale);
        // เก็บ error เอง: body ของหน้า water ล้นแนวตั้งที่ 1.5 (ของเดิมก่อน dashboard —
        // test-report §8) เทสต์นี้ตรวจเฉพาะ AppBar
        final errors = <FlutterErrorDetails>[];
        final old = FlutterError.onError;
        FlutterError.onError = errors.add;
        final s = sources();
        await tester.pumpWidget(PetPalApp(
            waterController: s.water,
            stepsController: s.steps,
            foodController: s.food));
        await tester.pumpAndSettle();
        FlutterError.onError = old;
        final appBarErrors = errors
            .where((e) =>
                e.toString().contains('AppBar') ||
                e.toString().contains('NavigationToolbar'))
            .map((e) => e.exceptionAsString())
            .toList();
        expect(appBarErrors, isEmpty, reason: '$appBarErrors');
        for (final key in [
          'steps_entry_button',
          'food_entry_button',
          'dashboard_entry_button',
          'water_monthly_report_button',
        ]) {
          final r = tester.getRect(k(key));
          expect(r.left >= 0 && r.right <= 360, isTrue, reason: '$key $r');
        }
      });
    }
  });

  // =========================================================================
  // จอ 360×640 — textScaler 1.0 / 1.5
  // =========================================================================
  group('จอ 360×640', () {
    /// ข้อความ [f] แสดงครบ ไม่ถูกตัด และอยู่ในกรอบ [container] และในความกว้างจอ
    void expectNotClipped(WidgetTester tester, Finder f, Finder container) {
      final p = tester.renderObject<RenderParagraph>(
          find.descendant(of: f, matching: find.byType(RichText)).first);
      expect(p.didExceedMaxLines, isFalse, reason: '$f ถูกตัดบรรทัด');
      final r = tester.getRect(f);
      final c = tester.getRect(container);
      const eps = 0.01;
      expect(
          r.left >= c.left - eps &&
              r.right <= c.right + eps &&
              r.top >= c.top - eps &&
              r.bottom <= c.bottom + eps,
          isTrue,
          reason: '$f $r ต้องอยู่ใน $c');
      expect(r.left >= -eps && r.right <= 360 + eps, isTrue, reason: '$r');
      final w = tester.widget(f);
      if (w is Text) {
        expect(w.overflow, isNot(anyOf(TextOverflow.ellipsis, TextOverflow.fade)));
      }
    }

    testWidgets('UI_360_scale_1_0_via_water_P1_full_no_overflow',
        (tester) async {
      set360(tester);
      await pumpViaWater(tester, kcal: 2150);
      expect(tester.takeException(), isNull);
      expect(alertOnScreen(tester), p1Text);
      expectNotClipped(tester, k('dashboard_alert_text'), k('dashboard_alert_banner'));
      expectNotClipped(tester, k('dashboard_alert_banner'), k('dashboard_alert_slot'));
      expect(tester.getSize(dashPet()), const Size(docPetSize, docPetSize));
      await tester.pump(const Duration(seconds: docAlertIntervalSeconds));
      expect(tester.takeException(), isNull);
    });

    testWidgets('UI_360_scale_1_0_water_appbar_three_icons_no_overflow',
        (tester) async {
      set360(tester);
      final s = sources();
      await tester.pumpWidget(PetPalApp(
          waterController: s.water,
          stepsController: s.steps,
          foodController: s.food));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(k('dashboard_entry_button'), findsOneWidget);
      expect(k('water_monthly_report_button'), findsOneWidget);
    });

    testWidgets('UI_360_scale_1_5_P1_full_no_overflow', (tester) async {
      set360(tester, textScale: 1.5);
      await pumpS1(tester, kcal: 2150);
      expect(tester.takeException(), isNull);
      expect(alertOnScreen(tester), p1Text);
      expectNotClipped(tester, k('dashboard_alert_text'), k('dashboard_alert_banner'));
      expectNotClipped(tester, k('dashboard_alert_banner'), k('dashboard_alert_slot'));
      final slot = tester.getRect(k('dashboard_alert_slot'));
      final pet = tester.getRect(find.byKey(PetKeys.character));
      expect(pet.top - slot.bottom, closeTo(docAlertAnchor, 0.01));
      // หมุนครบรอบ — ช่องไม่ขยับ ไม่มี exception
      final h = slot.height;
      await tester.pump(const Duration(seconds: docAlertIntervalSeconds));
      expect(tester.getSize(k('dashboard_alert_slot')).height, h);
      expect(tester.takeException(), isNull);
    });

    for (final scale in [1.0, 1.5]) {
      testWidgets('DECIDED_Q1_360_scale_${scale}_no_target_label_no_overflow',
          (tester) async {
        set360(tester, textScale: scale);
        await pumpS1(tester, noProfile: true);
        expect(tester.takeException(), isNull);
        expect(textOf(tester, k('dashboard_food_label_text')), foodNoTargetText);
        expectNotClipped(
            tester, k('dashboard_food_label_text'), k('dashboard_food_row'));
      });
    }

    testWidgets('UI_360_scale_1_5_can_scroll_to_water_bar', (tester) async {
      set360(tester, textScale: 1.5);
      await pumpS1(tester);
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pump();
      expect(tester.takeException(), isNull);
      final r = tester.getRect(k('dashboard_water_bar'));
      expect(r.bottom, lessThanOrEqualTo(640));
    });
  });
}
