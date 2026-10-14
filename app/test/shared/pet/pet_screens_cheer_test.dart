// QA pet (2026-10-14): PetCharacter บนหน้าจอจริงของ water / steps
//
// - character.md §6/§7: cheerTrigger เปลี่ยนเมื่อบันทึกน้ำ/เพิ่มก้าว "สำเร็จ" → สัตว์เลี้ยงดีใจ (cheer 900 ms)
// - water game-rules §3 / AC-3: กดซ้ำภายใน 5 นาทีถูกบล็อก → ไม่ใช่การบันทึกสำเร็จ → ไม่ดีใจ
// - steps game-rules §4: Permission Denied / No Hardware ล็อกการนับก้าว → เพิ่มไม่ได้ → ไม่ดีใจ
// - animatePet: null → kPetAnimateByDefault (false ระหว่าง flutter test) [ASSUMPTION 1 ของ Dev]
// เวลาควบคุมผ่าน clock ของ controller + tester.pump(Duration) — ไม่ใช้เวลาจริง
// animatePet: true → ห้าม pumpAndSettle (สัตว์เลี้ยงหายใจตลอด)
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/steps/screens/steps_dashboard_screen.dart';
import 'package:petpal_health/features/steps/steps_controller.dart';
import 'package:petpal_health/features/steps/steps_external.dart';
import 'package:petpal_health/features/steps/steps_models.dart';
import 'package:petpal_health/features/steps/steps_repository.dart';
import 'package:petpal_health/features/steps/steps_rules.dart';
import 'package:petpal_health/features/water/screens/water_home_screen.dart';
import 'package:petpal_health/features/water/water_controller.dart';
import 'package:petpal_health/features/water/water_models.dart';
import 'package:petpal_health/features/water/water_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petpal_health/shared/pet/pet.dart';

DateTime dt(int day, int hour, int minute, [int second = 0]) =>
    DateTime(2026, 10, day, hour, minute, second);

final waterLog = find.byKey(const Key('water_log_button'));
final waterCount = find.byKey(const Key('water_count_text'));
final waterToast = find.byKey(const Key('water_anti_spam_toast'));
final stepsAdd = find.byKey(const Key('steps_add_button'));
final stepsCount = find.byKey(const Key('steps_count_text'));

PetCharacter petIn(WidgetTester tester) =>
    tester.widget<PetCharacter>(find.byType(PetCharacter));

PetCharacterPainter painterOf(WidgetTester tester) =>
    tester.widget<CustomPaint>(find.byKey(PetKeys.painter)).painter!
        as PetCharacterPainter;

/// pump ทีละช่วงจนโหลดเสร็จ (ห้าม pumpAndSettle เมื่อ animate: true)
Future<void> settleLoad(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  // =========================================================================
  // water
  // =========================================================================
  group('water S-1', () {
    late DateTime now;

    Future<WaterController> pumpWater(WidgetTester tester, WaterState s,
        {bool? animatePet = true}) async {
      final c = WaterController(
          repository: InMemoryWaterRepository(s), clock: () => now);
      await tester.pumpWidget(MaterialApp(
          home: WaterHomeScreen(controller: c, animatePet: animatePet)));
      await settleLoad(tester);
      return c;
    }

    testWidgets('CHEER_water_log_success_increments_trigger_and_pet_cheers',
        (tester) async {
      now = dt(14, 10, 0);
      final c = await pumpWater(tester, WaterState.initial);
      expect(petIn(tester).animate, isTrue);
      expect(petIn(tester).cheerTrigger, 0);
      expect(c.petCheerCount, 0);

      await tester.tap(waterLog);
      await tester.pump();
      expect(tester.widget<Text>(waterCount).data, 'จำนวนน้ำ: 1 แก้ว');
      expect(c.petCheerCount, 1);
      expect(petIn(tester).cheerTrigger, 1);
      await tester.pump(const Duration(milliseconds: 100));
      expect(painterOf(tester).isCheering, isTrue);
      expect(painterOf(tester).face, PetFace.cheer);
      await tester.pump(const Duration(milliseconds: 900));
      expect(painterOf(tester).isCheering, isFalse);
      expect(painterOf(tester).face, PetFace.critical,
          reason: '1 แก้ว = critical (game-rules §2)');
    });

    testWidgets('CHEER_water_3_to_4_cups_cheers_and_switches_to_tired_pose',
        (tester) async {
      now = dt(14, 10, 0);
      await pumpWater(tester,
          WaterState(cups: 3, lastLoggedAt: dt(14, 9, 0), history: const []));
      expect(petIn(tester).pose, PetPose.waterCritical);
      await tester.tap(waterLog);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byKey(const ValueKey('water_pet_image_tired')),
          findsOneWidget);
      final p = painterOf(tester);
      expect(p.pose, PetPose.waterTired);
      expect(p.isCheering, isTrue);
      await tester.pump(const Duration(seconds: 1));
      expect(painterOf(tester).face, PetFace.tired);
    });

    testWidgets('CHEER_water_6_to_7_cups_cheers_and_switches_to_happy_pose',
        (tester) async {
      now = dt(14, 10, 0);
      await pumpWater(tester,
          WaterState(cups: 6, lastLoggedAt: dt(14, 9, 0), history: const []));
      expect(petIn(tester).pose, PetPose.waterTired);
      await tester.tap(waterLog);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(petIn(tester).pose, PetPose.waterHappy);
      expect(petIn(tester).cheerTrigger, 1);
      expect(painterOf(tester).isCheering, isTrue,
          reason: 'บันทึกสำเร็จต้องดีใจ แม้อารมณ์เปลี่ยนในครั้งเดียวกัน');
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('CHEER_water_4_to_5_cups_same_mood_cheers', (tester) async {
      // ควบคุม: บันทึกสำเร็จโดยอารมณ์ไม่เปลี่ยน (tired → tired)
      now = dt(14, 10, 0);
      await pumpWater(tester,
          WaterState(cups: 4, lastLoggedAt: dt(14, 9, 0), history: const []));
      await tester.tap(waterLog);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(petIn(tester).pose, PetPose.waterTired);
      expect(painterOf(tester).isCheering, isTrue);
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('STATE_water_3_to_4_cups_pet_state_survives_and_keeps_breathing',
        (tester) async {
      // BUG-PET-1 (แก้แล้ว): สัตว์เลี้ยงเป็นตัวเดิมเมื่ออารมณ์เปลี่ยน — State เดิม,
      // จังหวะหายใจไม่เริ่มใหม่ (character.md §6 หายใจตลอดเวลา)
      now = dt(14, 10, 0);
      await pumpWater(tester,
          WaterState(cups: 3, lastLoggedAt: dt(14, 9, 0), history: const []));
      await tester.pump(const Duration(milliseconds: 600));
      final before = tester.state(find.byType(PetCharacter));
      final breathBefore = painterOf(tester).breath;
      expect(breathBefore, greaterThan(0));
      await tester.tap(waterLog);
      await tester.pump();
      expect(find.byKey(const ValueKey('water_pet_image_tired')), findsOneWidget);
      expect(find.byKey(const ValueKey('water_pet_image_critical')),
          findsNothing);
      expect(identical(tester.state(find.byType(PetCharacter)), before), isTrue,
          reason: 'ต้องเป็น State เดิม ไม่สร้างใหม่');
      expect(painterOf(tester).breath, greaterThan(0),
          reason: 'หายใจต่อเนื่อง ไม่กลับไปเริ่ม 0');
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('CHEER_water_blocked_by_anti_spam_does_not_cheer',
        (tester) async {
      // game-rules §3: 2 แก้ว กดซ้ำภายใน 3 นาที → ยัง 2 แก้ว (บล็อก + Toast)
      now = dt(14, 10, 3);
      final c = await pumpWater(tester,
          WaterState(cups: 2, lastLoggedAt: dt(14, 10, 0), history: const []));
      await tester.tap(waterLog);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.widget<Text>(waterCount).data, 'จำนวนน้ำ: 2 แก้ว');
      expect(waterToast, findsOneWidget, reason: 'ถูกบล็อกจริง');
      expect(c.petCheerCount, 0);
      expect(petIn(tester).cheerTrigger, 0);
      expect(painterOf(tester).isCheering, isFalse);
      // ปล่อยให้ Toast หายก่อนจบเทสต์
      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('CHEER_water_after_5_minutes_cheers_again_count_2',
        (tester) async {
      // game-rules §3 / AC-4: ผ่านไป 5 นาที บันทึกได้
      now = dt(14, 10, 0);
      final c = await pumpWater(tester, WaterState.initial);
      await tester.tap(waterLog);
      await tester.pump(const Duration(seconds: 1));
      now = dt(14, 10, 2); // บล็อก
      await tester.tap(waterLog);
      await tester.pump(const Duration(seconds: 5));
      expect(c.petCheerCount, 1);
      now = dt(14, 10, 5); // ครบ 5 นาที
      await tester.tap(waterLog);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(c.cups, 2);
      expect(c.petCheerCount, 2);
      expect(petIn(tester).cheerTrigger, 2);
      expect(painterOf(tester).isCheering, isTrue);
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('DEFAULT_water_animatePet_null_is_static_under_flutter_test',
        (tester) async {
      now = dt(14, 10, 0);
      await pumpWater(tester, WaterState.initial, animatePet: null);
      await tester.pumpAndSettle(); // ใช้ได้เพราะภาพนิ่ง
      expect(petIn(tester).animate, kPetAnimateByDefault);
      expect(kPetAnimateByDefault, isFalse);
      expect(painterOf(tester).animated, isFalse);
      await tester.tap(waterLog);
      await tester.pumpAndSettle();
      expect(petIn(tester).cheerTrigger, 1,
          reason: 'ตัวนับยังเพิ่มแม้ภาพนิ่ง');
      expect(painterOf(tester).isCheering, isFalse);
    });
  });

  // =========================================================================
  // steps
  // =========================================================================
  group('steps S-1', () {
    late DateTime now;
    final pngBytes = Uint8List.fromList([137, 80, 78, 71, 13, 10, 26, 10]);

    Future<StepsController> pumpSteps(WidgetTester tester,
        {StepsState initial = StepsState.initial,
        StepsTrackingStatus tracking = StepsTrackingStatus.available}) async {
      final c = StepsController(
        repository: InMemoryStepsRepository(initial),
        waterHistory: FixedWaterHistorySource(),
        exporter: InMemoryStepsReportExporter(),
        clock: () => now,
        trackingStatus: tracking,
      );
      await tester.pumpWidget(MaterialApp(
          home: StepsDashboardScreen(
              controller: c,
              reportCapture: (_) async => pngBytes,
              animatePet: true)));
      await settleLoad(tester);
      return c;
    }

    testWidgets('CHEER_steps_add_success_increments_trigger_and_pet_cheers',
        (tester) async {
      now = dt(14, 10, 0);
      final c = await pumpSteps(tester);
      expect(petIn(tester).animate, isTrue);
      expect(petIn(tester).pose, PetPose.stepsFat,
          reason: '0 ก้าว = FAT (game-rules §2)');
      expect(c.petCheerCount, 0);
      await tester.tap(stepsAdd);
      await tester.pump();
      expect(c.petCheerCount, 1);
      expect(petIn(tester).cheerTrigger, 1);
      await tester.pump(const Duration(milliseconds: 100));
      expect(painterOf(tester).isCheering, isTrue);
      await tester.pump(const Duration(milliseconds: 900));
      expect(painterOf(tester).isCheering, isFalse);
    });

    testWidgets('CHEER_steps_two_adds_count_2', (tester) async {
      now = dt(14, 10, 0);
      final c = await pumpSteps(tester);
      await tester.tap(stepsAdd);
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(stepsAdd);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(c.petCheerCount, 2);
      expect(petIn(tester).cheerTrigger, 2);
      expect(painterOf(tester).isCheering, isTrue);
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('CHEER_steps_add_crossing_35_percent_cheers_and_shows_chubby',
        (tester) async {
      // game-rules §2/§3: ถึง 2,800/8,000 (35%) → CHUBBY; character.md §6: เพิ่มก้าวสำเร็จ → cheer
      // stepsPerTap เป็นค่าชั่วคราวของ Dev (ui-spec Q-2) จึงคำนวณจุดเริ่มจากค่านั้น
      const per = StepsRules.stepsPerTap;
      now = dt(14, 10, 0);
      final c = await pumpSteps(tester,
          initial: StepsState.initial.copyWith(
              day: DateTime(2026, 10, 14),
              steps: 2800 - per,
              activeGoal: 8000,
              hasUserGoal: true,
              lastSeenAt: dt(14, 9, 0)));
      expect(petIn(tester).pose, PetPose.stepsFat);
      await tester.tap(stepsAdd);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(c.steps, 2800);
      expect(c.petCheerCount, 1);
      expect(petIn(tester).pose, PetPose.stepsChubby);
      expect(petIn(tester).cheerTrigger, 1);
      expect(painterOf(tester).isCheering, isTrue,
          reason: 'เพิ่มก้าวสำเร็จต้องดีใจ แม้สถานะเปลี่ยนในครั้งเดียวกัน');
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('STATE_steps_crossing_35_percent_pet_state_survives',
        (tester) async {
      const per = StepsRules.stepsPerTap;
      now = dt(14, 10, 0);
      await pumpSteps(tester,
          initial: StepsState.initial.copyWith(
              day: DateTime(2026, 10, 14),
              steps: 2800 - per,
              activeGoal: 8000,
              hasUserGoal: true,
              lastSeenAt: dt(14, 9, 0)));
      await tester.pump(const Duration(milliseconds: 600));
      final before = tester.state(find.byType(PetCharacter));
      await tester.tap(stepsAdd);
      await tester.pump();
      expect(find.byKey(const ValueKey('steps_pet_image_chubby')),
          findsOneWidget);
      expect(identical(tester.state(find.byType(PetCharacter)), before), isTrue,
          reason: 'ต้องเป็น State เดิม ไม่สร้างใหม่');
      expect(painterOf(tester).breath, greaterThan(0));
      await tester.pump(const Duration(seconds: 1));
    });

    for (final status in [
      StepsTrackingStatus.permissionDenied,
      StepsTrackingStatus.noHardware,
    ]) {
      testWidgets('CHEER_steps_locked_${status.name}_add_does_not_cheer',
          (tester) async {
        now = dt(14, 10, 0);
        final c = await pumpSteps(tester, tracking: status);
        // ปุ่มถูกปิด → เรียก addSteps ตรง ๆ เพื่อพิสูจน์ว่าการเพิ่มที่ไม่สำเร็จไม่ดีใจ
        final outcome = await c.addSteps();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(outcome, AddStepsOutcome.locked);
        expect(c.steps, 0);
        expect(c.petCheerCount, 0);
        expect(petIn(tester).cheerTrigger, 0);
        final cheering = tester
            .widgetList<CustomPaint>(find.byKey(PetKeys.painter))
            .map((cp) => (cp.painter! as PetCharacterPainter).isCheering);
        expect(cheering, everyElement(isFalse));
      });
    }

    // ขอบสถานะ game-rules §2 ที่ 8,000 → ท่า (character.md §5)
    const cases = <(int, StepsPetStatus, PetPose)>[
      (2799, StepsPetStatus.fat, PetPose.stepsFat),
      (2800, StepsPetStatus.chubby, PetPose.stepsChubby),
      (5599, StepsPetStatus.chubby, PetPose.stepsChubby),
      (5600, StepsPetStatus.lean, PetPose.stepsLean),
      (7999, StepsPetStatus.lean, PetPose.stepsLean),
      (8000, StepsPetStatus.muscle, PetPose.stepsMuscle),
    ];
    for (final (steps, status, pose) in cases) {
      testWidgets('POSE_steps_${steps}_of_8000_is_${pose.id}', (tester) async {
        now = dt(14, 10, 0);
        await pumpSteps(tester,
            initial: StepsState.initial.copyWith(
                day: DateTime(2026, 10, 14),
                steps: steps,
                activeGoal: 8000,
                hasUserGoal: true,
                lastSeenAt: dt(14, 9, 0)));
        final w = find.byKey(ValueKey('steps_pet_image_${status.name}'));
        expect(w, findsOneWidget);
        // QA pet รอบ 2: key ฟีเจอร์อยู่ที่ KeyedSubtree ที่ห่อ PetCharacter (แก้ BUG-PET-1)
        final pet = tester.widget<PetCharacter>(
            find.descendant(of: w, matching: find.byType(PetCharacter)));
        expect(pet.pose, pose);
        expect(pet.size, 160);
        expect(painterOf(tester).bodyShape, pose.body);
        expect(find.byType(PetCharacter), findsOneWidget,
            reason: 'สัตว์เลี้ยงตัวเดียวบนหน้าจอ');
      });
    }
  });
}
