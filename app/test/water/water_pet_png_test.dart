// Tests (QA v3): ภาพสัตว์เลี้ยง PNG ตาม game-rules.md §2 + ข้อตัดสิน Zen-107 2026-10-08
// "ถ้ามีไฟล์ PNG ตามชื่อในคอลัมน์ 'ไฟล์ภาพ' อยู่ใน app/assets/images/ ให้ใช้ PNG แทนภาพที่วาดด้วยโค้ด"
//
// - งาน 1: หน้าจอหลัก S-1 แสดง PNG ถูกไฟล์ตามจำนวนแก้ว 0–3 critical / 4–6 tired / 7+ happy
// - งาน 2: โหลด PNG ไม่ได้ (bundle โยน error / ไบต์เสีย) → กลับไปใช้ CustomPainter ไม่ crash
// - งาน 3: ไฟล์ทั้ง 3 มีจริง เป็น PNG และขนาด 512×512
//
// ข้อจำกัดการทดสอบ (ดู test-report.md): PetAvatar เก็บ AssetManifest ไว้ใน static Future
// ครั้งเดียวต่อ isolate — Future ผูกกับ zone ที่สร้างมัน ถ้าสร้างใน fake-async zone ของเทสต์แรก
// เทสต์ถัดไปจะไม่ได้รับผล manifest เลย (แสดง painter ตลอด) จึงต้อง "อุ่น" manifest
// ใน real zone ผ่าน tester.runAsync ก่อนทุกเทสต์ (_warmManifest, idempotent)
//
// เวลาควบคุมผ่าน clock ของ WaterController — ไม่ใช้เวลาจริง (runAsync ใช้แค่รอ IO/decode ภาพ)
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/water/water_controller.dart';
import 'package:petpal_health/features/water/water_models.dart';
import 'package:petpal_health/features/water/water_repository.dart';
import 'package:petpal_health/features/water/widgets/pet_avatar.dart';
import 'package:petpal_health/features/water/widgets/pet_painter.dart';
import 'package:petpal_health/main.dart';

DateTime dt(int day, int hour, int minute) =>
    DateTime(2026, 10, day, hour, minute);

// ชื่อไฟล์จาก game-rules.md §2 คอลัมน์ "ไฟล์ภาพ"
const pngCritical = 'assets/images/pet_critical.png';
const pngTired = 'assets/images/pet_tired.png';
const pngHappy = 'assets/images/pet_happy.png';
const docPng = {
  PetMood.critical: pngCritical,
  PetMood.tired: pngTired,
  PetMood.happy: pngHappy,
};

// ข้อความสถานะตาม game-rules.md §2
const statusByMood = {
  PetMood.critical: 'เหี่ยวเฉา ป่วย ใกล้ตาย',
  PetMood.tired: 'เริ่มเพลีย อ่อนแรง แลบลิ้น',
  PetMood.happy: 'สดชื่น ร่าเริง มีความสุข',
};

final logButton = find.byKey(const Key('water_log_button'));
final countText = find.byKey(const Key('water_count_text'));
final statusText = find.byKey(const Key('water_pet_status_text'));

Finder petWrapper(PetMood m) => find.byKey(ValueKey('water_pet_image_${m.name}'));

/// bundle ปลอม: ทุกอย่างส่งต่อ rootBundle ยกเว้นไฟล์ pet_*.png
/// - throwOnPng: โยน error ตอนโหลด (เช่นไฟล์หาย/อ่านไม่ได้)
/// - ไม่งั้น: คืนไบต์ที่ไม่ใช่ภาพ (ไฟล์เสีย) → decode ล้ม
class _BrokenPetBundle extends AssetBundle {
  _BrokenPetBundle({required this.throwOnPng});

  final bool throwOnPng;
  final List<String> petRequests = [];

  bool _isPet(String key) => key.startsWith('assets/images/pet_');

  @override
  Future<ByteData> load(String key) async {
    if (_isPet(key)) {
      petRequests.add(key);
      if (throwOnPng) {
        throw FlutterError('QA: simulated load failure for $key');
      }
      return ByteData.sublistView(
          Uint8List.fromList(List<int>.generate(64, (i) => i)));
    }
    return rootBundle.load(key);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) =>
      rootBundle.loadString(key, cache: cache);
}

void main() {
  late DateTime now;

  /// อุ่น static manifest cache ของ PetAvatar ใน real zone (ทำครั้งเดียวต่อไฟล์ ไม่มีผลถ้าซ้ำ)
  Future<void> warmManifest(WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const Directionality(
          textDirection: TextDirection.ltr,
          child: PetAvatar(mood: PetMood.critical)));
      await Future<void>.delayed(const Duration(milliseconds: 20));
    });
    await tester.pumpWidget(const SizedBox());
  }

  /// ปล่อยให้ IO/decode ภาพจริงทำงาน แล้ว pump เฟรม (ไม่เกี่ยวกับนาฬิกาของเกม)
  Future<void> settleImages(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump();
    }
  }

  Future<WaterController> pumpHome(WidgetTester tester, WaterState s,
      {AssetBundle? bundle}) async {
    await warmManifest(tester);
    final c = WaterController(
        repository: InMemoryWaterRepository(s), clock: () => now);
    Widget app = PetPalApp(waterController: c);
    if (bundle != null) app = DefaultAssetBundle(bundle: bundle, child: app);
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    await settleImages(tester);
    return c;
  }

  Future<void> tapLog(WidgetTester tester) async {
    await tester.tap(logButton);
    await tester.pump();
    await settleImages(tester);
  }

  WaterState stateWith(int cups) =>
      WaterState(cups: cups, lastLoggedAt: dt(8, 9, 0), history: const []);

  /// หน้าจอหลักแสดง PNG ของ mood ถูกไฟล์ (key + assetName) ไม่มีภาพวาดหรือ mood อื่นค้าง
  /// และภาพ decode ได้จริง (RawImage มีภาพ 512×512)
  void expectPng(WidgetTester tester, PetMood mood) {
    final img = find.byKey(PetAvatar.pngKey(mood));
    expect(img, findsOneWidget, reason: 'ต้องแสดง PNG ของ ${mood.name}');
    expect(find.descendant(of: petWrapper(mood), matching: img), findsOneWidget);
    final provider = tester.widget<Image>(img).image;
    expect(provider, isA<AssetImage>());
    expect((provider as AssetImage).assetName, docPng[mood]);
    expect(find.byKey(PetAvatar.painterKey(mood)), findsNothing,
        reason: 'มี PNG แล้วต้องไม่ใช้ภาพวาด (และไม่ตกไป errorBuilder)');
    final raw = tester.widget<RawImage>(
        find.descendant(of: img, matching: find.byType(RawImage)));
    expect(raw.image, isNotNull, reason: 'PNG ต้อง decode สำเร็จ');
    expect(raw.image!.width, 512);
    expect(raw.image!.height, 512);
    for (final other in PetMood.values.where((m) => m != mood)) {
      expect(find.byKey(PetAvatar.pngKey(other)), findsNothing);
      expect(find.byKey(PetAvatar.painterKey(other)), findsNothing);
      expect(petWrapper(other), findsNothing);
    }
    expect(tester.widget<Text>(statusText).data, statusByMood[mood]);
  }

  /// หน้าจอหลักกลับไปใช้ภาพวาด (errorBuilder) ของ mood ถูกต้อง ไม่ crash
  void expectPainterFallback(WidgetTester tester, PetMood mood) {
    expect(tester.takeException(), isNull);
    final cp = find.byKey(PetAvatar.painterKey(mood));
    expect(cp, findsOneWidget, reason: 'โหลด PNG ไม่ได้ ต้องใช้ภาพวาด ${mood.name}');
    // painter อยู่ใต้ Image (มาจาก errorBuilder ไม่ใช่ทางที่ไม่มี PNG ใน manifest)
    expect(find.descendant(of: find.byKey(PetAvatar.pngKey(mood)), matching: cp),
        findsOneWidget);
    final painter = tester.widget<CustomPaint>(cp).painter;
    expect(painter, isA<PetPainter>());
    expect((painter! as PetPainter).mood, mood);
    for (final other in PetMood.values.where((m) => m != mood)) {
      expect(find.byKey(PetAvatar.painterKey(other)), findsNothing);
      expect(petWrapper(other), findsNothing);
    }
    expect(tester.widget<Text>(statusText).data, statusByMood[mood]);
  }

  group('งาน 1: S-1 แสดง PNG ถูกไฟล์ตามจำนวนแก้ว (game-rules §2)', () {
    final cases = <int, PetMood>{
      0: PetMood.critical,
      3: PetMood.critical,
      4: PetMood.tired,
      6: PetMood.tired,
      7: PetMood.happy,
      12: PetMood.happy,
    };
    cases.forEach((cups, mood) {
      testWidgets('PNG_S1_${cups}_cups_shows_pet_${mood.name}_png',
          (tester) async {
        now = dt(8, 10, 0);
        await pumpHome(tester, cups == 0 ? WaterState.initial : stateWith(cups));
        expect(tester.widget<Text>(countText).data, 'จำนวนน้ำ: $cups แก้ว');
        expectPng(tester, mood);
      });
    });

    testWidgets('PNG_S1_3_to_4_cups_switches_critical_png_to_tired_png',
        (tester) async {
      now = dt(8, 10, 0);
      await pumpHome(tester, stateWith(3));
      expectPng(tester, PetMood.critical);
      await tapLog(tester);
      expect(tester.widget<Text>(countText).data, 'จำนวนน้ำ: 4 แก้ว');
      expectPng(tester, PetMood.tired);
    });

    testWidgets('PNG_S1_6_to_7_cups_switches_tired_png_to_happy_png',
        (tester) async {
      now = dt(8, 10, 0);
      await pumpHome(tester, stateWith(6));
      expectPng(tester, PetMood.tired);
      await tapLog(tester);
      expect(tester.widget<Text>(countText).data, 'จำนวนน้ำ: 7 แก้ว');
      expectPng(tester, PetMood.happy);
    });

    testWidgets('PNG_S1_after_05_00_reset_happy_png_back_to_critical_png',
        (tester) async {
      now = dt(8, 4, 59);
      await pumpHome(tester,
          WaterState(cups: 7, lastLoggedAt: dt(8, 4, 0), history: const []));
      expectPng(tester, PetMood.happy);
      now = dt(8, 5, 0);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      await settleImages(tester);
      expect(tester.widget<Text>(countText).data, 'จำนวนน้ำ: 0 แก้ว');
      expectPng(tester, PetMood.critical);
    });
  });

  group('งาน 2: โหลด PNG ไม่ได้ → CustomPainter ไม่ crash', () {
    testWidgets(
        'FALLBACK_S1_png_load_throws_3_cups_painter_critical_then_4_tired',
        (tester) async {
      now = dt(8, 10, 0);
      final bundle = _BrokenPetBundle(throwOnPng: true);
      await pumpHome(tester, stateWith(3), bundle: bundle);
      expect(bundle.petRequests, contains(pngCritical),
          reason: 'ต้องพยายามโหลด PNG ก่อน (มีใน manifest) แล้วจึง fallback');
      expectPainterFallback(tester, PetMood.critical);
      await tapLog(tester);
      expect(tester.widget<Text>(countText).data, 'จำนวนน้ำ: 4 แก้ว');
      expect(bundle.petRequests, contains(pngTired));
      expectPainterFallback(tester, PetMood.tired);
    });

    testWidgets('FALLBACK_S1_png_load_throws_6_cups_painter_tired_then_7_happy',
        (tester) async {
      now = dt(8, 10, 0);
      final bundle = _BrokenPetBundle(throwOnPng: true);
      await pumpHome(tester, stateWith(6), bundle: bundle);
      expectPainterFallback(tester, PetMood.tired);
      await tapLog(tester);
      expect(tester.widget<Text>(countText).data, 'จำนวนน้ำ: 7 แก้ว');
      expect(bundle.petRequests, contains(pngHappy));
      expectPainterFallback(tester, PetMood.happy);
    });

    testWidgets('FALLBACK_S1_png_corrupt_bytes_0_cups_painter_critical',
        (tester) async {
      now = dt(8, 10, 0);
      final bundle = _BrokenPetBundle(throwOnPng: false);
      await pumpHome(tester, WaterState.initial, bundle: bundle);
      expect(bundle.petRequests, contains(pngCritical));
      expectPainterFallback(tester, PetMood.critical);
      // ปุ่มยังใช้งานได้หลัง fallback
      await tapLog(tester);
      expect(tester.widget<Text>(countText).data, 'จำนวนน้ำ: 1 แก้ว');
      expectPainterFallback(tester, PetMood.critical);
    });

    testWidgets('FALLBACK_S1_png_corrupt_bytes_12_cups_painter_happy',
        (tester) async {
      now = dt(8, 10, 0);
      final bundle = _BrokenPetBundle(throwOnPng: false);
      await pumpHome(tester, stateWith(12), bundle: bundle);
      expect(bundle.petRequests, contains(pngHappy));
      expectPainterFallback(tester, PetMood.happy);
    });
  });

  group('PetPainter โดยตรง (ภาพวาดยังใช้เป็นภาพสำรอง)', () {
    testWidgets('PAINTER_draws_all_3_moods_without_error', (tester) async {
      for (final mood in PetMood.values) {
        await tester.pumpWidget(Center(
            child: CustomPaint(
                key: ValueKey('qa_${mood.name}'),
                size: const Size.square(160),
                painter: PetPainter(mood: mood))));
        expect(tester.takeException(), isNull);
        final cp = tester.widget<CustomPaint>(find.byKey(ValueKey('qa_${mood.name}')));
        expect((cp.painter! as PetPainter).mood, mood);
      }
    });

    test('PAINTER_repaints_only_when_mood_changes', () {
      for (final a in PetMood.values) {
        for (final b in PetMood.values) {
          expect(PetPainter(mood: a).shouldRepaint(PetPainter(mood: b)), a != b);
        }
      }
    });
  });

  group('งาน 3: ไฟล์ PNG ใน app/assets/images/', () {
    // flutter test รันจากโฟลเดอร์ app/ → path สัมพัทธ์จาก app/
    final files = docPng.values.toList();

    test('FILE_pet_pngs_exist_in_app_assets_images', () {
      for (final f in files) {
        expect(File(f).existsSync(), isTrue, reason: 'ต้องมี app/$f');
      }
    });

    test('FILE_pet_pngs_have_png_signature', () {
      const sig = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
      for (final f in files) {
        final b = File(f).readAsBytesSync();
        expect(b.length, greaterThan(33), reason: f);
        expect(b.sublist(0, 8), sig, reason: '$f ต้องขึ้นต้นด้วย PNG signature');
        expect(String.fromCharCodes(b.sublist(12, 16)), 'IHDR', reason: f);
      }
    });

    test('FILE_pet_pngs_ihdr_is_512x512', () {
      for (final f in files) {
        final bd = ByteData.sublistView(File(f).readAsBytesSync());
        expect(bd.getUint32(16), 512, reason: '$f width');
        expect(bd.getUint32(20), 512, reason: '$f height');
      }
    });

    testWidgets('FILE_pet_pngs_decode_to_512x512_and_registered_in_bundle',
        (tester) async {
      await tester.runAsync(() async {
        final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
        for (final f in files) {
          expect(manifest.listAssets(), contains(f),
              reason: '$f ต้องลงทะเบียนใน pubspec (assets/images/)');
          final data = await rootBundle.load(f);
          final codec =
              await ui.instantiateImageCodec(data.buffer.asUint8List());
          final frame = await codec.getNextFrame();
          expect(frame.image.width, 512, reason: f);
          expect(frame.image.height, 512, reason: f);
          frame.image.dispose();
          codec.dispose();
        }
      });
    });
  });
}
