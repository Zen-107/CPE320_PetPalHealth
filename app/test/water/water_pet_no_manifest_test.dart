// Tests (QA v3): อ่าน AssetManifest ไม่ได้ → ใช้ CustomPainter ไม่ crash (game-rules.md §2:
// วาดด้วย CustomPainter, ใช้ PNG แทน "ถ้ามี" — ถ้าแอปหา PNG ไม่เจอต้องยังมีภาพสัตว์เลี้ยง)
//
// แยกไฟล์เพราะ PetAvatar อ่าน manifest จาก rootBundle ครั้งเดียวต่อ isolate (static cache)
// ไฟล์นี้จึงต้อง mock ช่อง 'flutter/assets' ก่อนที่ PetAvatar ตัวแรกจะถูกสร้าง
// (flutter test รันแต่ละไฟล์ใน isolate แยก — static ไม่ปนกับไฟล์อื่น)
// เวลาควบคุมผ่าน clock ของ WaterController — ไม่ใช้เวลาจริง
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/water/water_controller.dart';
import 'package:petpal_health/features/water/water_models.dart';
import 'package:petpal_health/features/water/water_repository.dart';
import 'package:petpal_health/features/water/widgets/pet_avatar.dart';
import 'package:petpal_health/features/water/widgets/pet_painter.dart';
import 'package:petpal_health/main.dart';

DateTime dt(int day, int hour, int minute) =>
    DateTime(2026, 10, day, hour, minute);

final logButton = find.byKey(const Key('water_log_button'));
final countText = find.byKey(const Key('water_count_text'));

void main() {
  late DateTime now;
  final assetRequests = <String>[];

  Future<void> pumpHome(WidgetTester tester, int cups) async {
    // ช่อง asset ตอบ null ทุกคีย์ = อ่าน AssetManifest ไม่ได้ (rootBundle จะโยน error)
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets', (msg) async {
      assetRequests.add(utf8.decode(msg!.buffer.asUint8List()));
      return null;
    });
    final c = WaterController(
        repository: InMemoryWaterRepository(WaterState(
            cups: cups, lastLoggedAt: dt(8, 9, 0), history: const [])),
        clock: () => now);
    // สร้าง PetAvatar ตัวแรกใน real zone ให้ static manifest Future ทำงานจบจริง
    await tester.runAsync(() async {
      await tester.pumpWidget(PetPalApp(waterController: c));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)));
    await tester.pump();
  }

  void expectPainterOnly(WidgetTester tester, PetMood mood) {
    expect(tester.takeException(), isNull);
    final cp = find.byKey(PetAvatar.painterKey(mood));
    expect(cp, findsOneWidget);
    expect((tester.widget<CustomPaint>(cp).painter! as PetPainter).mood, mood);
    final wrapper = find.byKey(ValueKey('water_pet_image_${mood.name}'));
    expect(find.descendant(of: wrapper, matching: find.byType(Image)),
        findsNothing,
        reason: 'ไม่มี manifest → ไม่สร้าง Image ของสัตว์เลี้ยง ใช้ภาพวาดตรง ๆ');
    expect(find.byKey(PetAvatar.pngKey(mood)), findsNothing);
    for (final other in PetMood.values.where((m) => m != mood)) {
      expect(find.byKey(PetAvatar.painterKey(other)), findsNothing);
    }
  }

  testWidgets('FALLBACK_S1_no_asset_manifest_3_to_4_cups_painter_no_crash',
      (tester) async {
    now = dt(8, 10, 0);
    await pumpHome(tester, 3);
    expect(assetRequests.where((k) => k.startsWith('AssetManifest')),
        isNotEmpty,
        reason: 'PetAvatar ต้องพยายามอ่าน manifest จริง');
    expectPainterOnly(tester, PetMood.critical);
    await tester.tap(logButton);
    await tester.pump();
    expect(tester.widget<Text>(countText).data, 'จำนวนน้ำ: 4 แก้ว');
    expectPainterOnly(tester, PetMood.tired);
  });

  testWidgets('FALLBACK_S1_no_asset_manifest_6_to_7_cups_painter_no_crash',
      (tester) async {
    now = dt(8, 10, 0);
    await pumpHome(tester, 6);
    expectPainterOnly(tester, PetMood.tired);
    await tester.tap(logButton);
    await tester.pump();
    expect(tester.widget<Text>(countText).data, 'จำนวนน้ำ: 7 แก้ว');
    expectPainterOnly(tester, PetMood.happy);
  });
}
