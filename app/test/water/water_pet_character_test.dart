// QA pet (2026-10-14): แทน water_pet_png_test.dart + water_pet_no_manifest_test.dart (เลิกใช้)
//
// owner ตัดสิน 2026-10-14: ทั้งแอปใช้สัตว์เลี้ยงตัวเดียว = PetCharacter (docs/_design/character.md)
// PNG สัตว์เลี้ยงเดิมย้ายไป app/assets/images/legacy/ และ "ไม่" bundle เข้าแอป
// → พฤติกรรม PNG / fallback manifest ไม่มีแล้ว เหลือส่วนที่ยังมีความหมาย:
//   1) ขอบสถานะ game-rules §2 (0–3 / 4–6 / 7+) บนหน้าจอ → preset ของ character.md §5
//   2) รีเซ็ต 05:00 → กลับเป็น critical
//   3) ไฟล์ legacy มีอยู่ แต่ไม่อยู่ใน bundle และไม่มีโค้ดอ้าง pet_*.png
// เวลาควบคุมผ่าน clock ของ WaterController — ไม่ใช้เวลาจริง
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/water/water_controller.dart';
import 'package:petpal_health/features/water/water_models.dart';
import 'package:petpal_health/features/water/water_repository.dart';
import 'package:petpal_health/main.dart';
import 'package:petpal_health/shared/pet/pet.dart';

DateTime dt(int day, int hour, int minute) =>
    DateTime(2026, 10, day, hour, minute);

// game-rules §2 ข้อความสถานะ + character.md §5 preset/สีหน้า
const docByMood = {
  PetMood.critical: ('เหี่ยวเฉา ป่วย ใกล้ตาย', PetPose.waterCritical, PetFace.critical),
  PetMood.tired: ('เริ่มเพลีย อ่อนแรง แลบลิ้น', PetPose.waterTired, PetFace.tired),
  PetMood.happy: ('สดชื่น ร่าเริง มีความสุข', PetPose.waterHappy, PetFace.happy),
};

// ชื่อไฟล์เดิมใน game-rules §2 (ตอนนี้อยู่ใน legacy/)
const legacyNames = ['pet_critical.png', 'pet_tired.png', 'pet_happy.png'];

final logButton = find.byKey(const Key('water_log_button'));
final countText = find.byKey(const Key('water_count_text'));
final statusText = find.byKey(const Key('water_pet_status_text'));

void main() {
  late DateTime now;

  Future<void> pumpWith(WidgetTester tester, WaterState s) async {
    final c = WaterController(
        repository: InMemoryWaterRepository(s), clock: () => now);
    await tester.pumpWidget(PetPalApp(waterController: c));
    await tester.pumpAndSettle();
  }

  void expectMood(WidgetTester tester, PetMood mood) {
    final (text, pose, face) = docByMood[mood]!;
    final w = find.byKey(ValueKey('water_pet_image_${mood.name}'));
    expect(w, findsOneWidget, reason: mood.name);
    // QA pet รอบ 2: key ฟีเจอร์อยู่ที่ KeyedSubtree ที่ห่อ PetCharacter (แก้ BUG-PET-1)
    expect(
        tester
            .widget<PetCharacter>(
                find.descendant(of: w, matching: find.byType(PetCharacter)))
            .pose,
        pose);
    final painter = tester
        .widget<CustomPaint>(
            find.descendant(of: w, matching: find.byKey(PetKeys.painter)))
        .painter! as PetCharacterPainter;
    expect(painter.pose, pose);
    expect(painter.face, face);
    expect(painter.showsSweat, mood != PetMood.happy,
        reason: 'character.md §4: tired/critical มีเหงื่อ');
    expect(tester.widget<Text>(statusText).data, text);
    expect(find.byType(PetCharacter), findsOneWidget);
    expect(find.descendant(of: w, matching: find.byType(Image)), findsNothing);
  }

  group('S-1 ขอบสถานะ (game-rules §2) แสดงท่าของ PetCharacter', () {
    const cases = <int, PetMood>{
      0: PetMood.critical,
      3: PetMood.critical,
      4: PetMood.tired,
      6: PetMood.tired,
      7: PetMood.happy,
      12: PetMood.happy,
    };
    cases.forEach((cups, mood) {
      testWidgets('POSE_S1_${cups}_cups_shows_${mood.name}', (tester) async {
        now = dt(14, 10, 0);
        await pumpWith(
            tester,
            cups == 0
                ? WaterState.initial
                : WaterState(
                    cups: cups, lastLoggedAt: dt(14, 9, 0), history: const []));
        expectMood(tester, mood);
      });
    });

    testWidgets('POSE_S1_3_to_4_cups_switches_critical_to_tired',
        (tester) async {
      now = dt(14, 10, 0);
      await pumpWith(tester,
          WaterState(cups: 3, lastLoggedAt: dt(14, 9, 0), history: const []));
      expectMood(tester, PetMood.critical);
      await tester.tap(logButton);
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(countText).data, 'จำนวนน้ำ: 4 แก้ว');
      expectMood(tester, PetMood.tired);
    });

    testWidgets('POSE_S1_6_to_7_cups_switches_tired_to_happy', (tester) async {
      now = dt(14, 10, 0);
      await pumpWith(tester,
          WaterState(cups: 6, lastLoggedAt: dt(14, 9, 0), history: const []));
      expectMood(tester, PetMood.tired);
      await tester.tap(logButton);
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(countText).data, 'จำนวนน้ำ: 7 แก้ว');
      expectMood(tester, PetMood.happy);
    });

    testWidgets('POSE_S1_after_05_00_reset_happy_back_to_critical',
        (tester) async {
      now = dt(14, 4, 59);
      await pumpWith(tester,
          WaterState(cups: 7, lastLoggedAt: dt(14, 4, 0), history: const []));
      expectMood(tester, PetMood.happy);
      now = dt(14, 5, 0);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expectMood(tester, PetMood.critical);
    });
  });

  group('PNG สัตว์เลี้ยงเดิม (legacy) ไม่ถูกใช้/ไม่ถูก bundle', () {
    // flutter test รันจากโฟลเดอร์ app/
    test('LEGACY_files_kept_in_assets_images_legacy', () {
      for (final n in legacyNames) {
        expect(File('assets/images/legacy/$n').existsSync(), isTrue,
            reason: 'เก็บไว้ใน legacy/: $n');
      }
    });

    test('LEGACY_no_pet_png_in_top_level_assets_images', () {
      final top = Directory('assets/images')
          .listSync()
          .whereType<File>()
          .map((f) => f.uri.pathSegments.last)
          .where((n) => n.startsWith('pet_') && n.endsWith('.png'));
      expect(top, isEmpty);
    });

    test('LEGACY_pubspec_does_not_register_legacy_or_pet_png', () {
      final pubspec = File('pubspec.yaml').readAsLinesSync();
      // เฉพาะบรรทัดที่ไม่ใช่คอมเมนต์
      final active = pubspec
          .map((l) => l.split('#').first)
          .where((l) => l.trim().isNotEmpty);
      expect(active.where((l) => l.contains('legacy')), isEmpty);
      expect(active.where((l) => l.contains('pet_')), isEmpty);
    });

    test('LEGACY_lib_has_no_pet_png_reference', () {
      final pattern = RegExp(r'pet_\w*\.png');
      final hits = <String>[];
      for (final f in Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))) {
        final lines = f.readAsLinesSync();
        for (var i = 0; i < lines.length; i++) {
          if (pattern.hasMatch(lines[i])) hits.add('${f.path}:${i + 1}');
        }
      }
      expect(hits, isEmpty, reason: 'ห้ามอ้าง pet_*.png ใน lib/');
    });

    testWidgets('LEGACY_asset_manifest_has_no_pet_png_and_load_fails',
        (tester) async {
      final manifest = await tester.runAsync(
          () => AssetManifest.loadFromAssetBundle(rootBundle));
      final assets = manifest!.listAssets();
      expect(assets.where((a) => a.contains('legacy/')), isEmpty);
      expect(
          assets.where((a) => RegExp(r'pet_\w*\.png$').hasMatch(a)), isEmpty);
      for (final n in legacyNames) {
        Object? error;
        await tester.runAsync(() async {
          try {
            await rootBundle.load('assets/images/legacy/$n');
          } catch (e) {
            error = e;
          }
        });
        expect(error, isNotNull, reason: 'legacy/$n ต้องไม่อยู่ใน bundle');
      }
    });
  });
}
