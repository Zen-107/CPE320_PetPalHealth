// Widget tests (QA v2): ข้อตัดสินโดย Zen-107 2026-10-08
// - ข้อ 1 ขอบเดือน AC-6 บนหน้า S-2
// - ข้อ 2 นาฬิกาย้อนกลับ: เปิด S-1 / กดปุ่ม / เปิด S-2 ไม่ crash ไม่ลบข้อมูล (game-rules §4)
// - ข้อ 3 ข้อมูลเสีย/ผิดชนิด: S-1/S-2 แสดงสถานะว่าง ไม่ crash (game-rules §4, ux-flow §4)
// - ข้อ 4 วันที่หน้าประวัติ dd/MM/yyyy (ux-flow S-2)
// - ข้อ 5 ภาพสัตว์เลี้ยงตามอารมณ์ 0–3 / 4–6 / 7+ (game-rules §2) — QA v3: มี PNG แล้ว
//   ตรวจทั้งทาง PNG และภาพวาด (ดู expectPetMood)
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
import 'package:shared_preferences/shared_preferences.dart';

DateTime dt(int month, int day, int hour, int minute, [int second = 0]) =>
    DateTime(2026, month, day, hour, minute, second);

DailyWaterRecord rec(int month, int day, int cups) =>
    DailyWaterRecord(date: DateTime(2026, month, day), cups: cups);

const critical = 'เหี่ยวเฉา ป่วย ใกล้ตาย';
const tired = 'เริ่มเพลีย อ่อนแรง แลบลิ้น';
const happy = 'สดชื่น ร่าเริง มีความสุข';
// ชื่อไฟล์ภาพจาก game-rules.md §2
const pngByMood = {
  PetMood.critical: 'assets/images/pet_critical.png',
  PetMood.tired: 'assets/images/pet_tired.png',
  PetMood.happy: 'assets/images/pet_happy.png',
};
const emptyText = 'ยังไม่มีประวัติการดื่มน้ำในเดือนนี้';

final logButton = find.byKey(const Key('water_log_button'));
final countText = find.byKey(const Key('water_count_text'));
final statusText = find.byKey(const Key('water_pet_status_text'));
final energyText = find.byKey(const Key('water_energy_text'));
final reportButton = find.byKey(const Key('water_monthly_report_button'));
final historyList = find.byKey(const Key('water_monthly_history_list'));
final averageText = find.byKey(const Key('water_monthly_average_text'));

void main() {
  late DateTime now;

  Future<WaterController> pumpApp(WidgetTester tester, WaterRepository repo) async {
    final c = WaterController(repository: repo, clock: () => now);
    await tester.pumpWidget(PetPalApp(waterController: c));
    await tester.pumpAndSettle();
    return c;
  }

  Future<WaterController> pumpWith(WidgetTester tester, WaterState s) =>
      pumpApp(tester, InMemoryWaterRepository(s));

  String textOf(WidgetTester tester, Finder f) => tester.widget<Text>(f).data!;

  Future<void> tapLog(WidgetTester tester) async {
    await tester.tap(logButton);
    await tester.pump();
  }

  Future<void> openReport(WidgetTester tester) async {
    await tester.tap(reportButton);
    await tester.pumpAndSettle();
  }

  /// ตรวจว่าสัตว์เลี้ยงแสดงอารมณ์ `mood` และไม่มีอารมณ์อื่นค้าง (QA v3: ปรับเพราะมี PNG แล้ว)
  ///
  /// game-rules §2: มี PNG ใน app/assets/images/ → ใช้ PNG แทนภาพวาด ไฟล์นี้ไม่ได้อุ่น
  /// static manifest cache ของ PetAvatar ใน real zone จึงอาจเห็นทางใดทางหนึ่ง
  /// (เทสต์แรกของไฟล์เห็น PNG, เทสต์ถัดไปเห็นภาพวาดระหว่างรอ manifest) — ตรวจว่าทางที่แสดง
  /// ถูกอารมณ์: PNG ต้องชื่อไฟล์ตาม §2 / ภาพวาดต้องเป็น PetPainter ของ mood นั้น
  /// ทาง PNG แบบบังคับดู water_pet_png_test.dart · ทางภาพวาด fallback ดู water_pet_png_test.dart
  /// และ water_pet_no_manifest_test.dart
  void expectPetMood(WidgetTester tester, PetMood mood) {
    final wrapper = find.byKey(ValueKey('water_pet_image_${mood.name}'));
    expect(wrapper, findsOneWidget);
    expect(tester.widget<PetAvatar>(wrapper).mood, mood);
    final png = find.descendant(
        of: wrapper, matching: find.byKey(PetAvatar.pngKey(mood)));
    final painter = find.descendant(
        of: wrapper, matching: find.byKey(PetAvatar.painterKey(mood)));
    final pngCount = png.evaluate().length;
    final painterCount = painter.evaluate().length;
    expect(pngCount + painterCount, greaterThan(0),
        reason: 'ต้องมีภาพ PNG หรือภาพวาดของ ${mood.name}');
    if (pngCount > 0) {
      expect(pngCount, 1);
      final provider = tester.widget<Image>(png).image as AssetImage;
      expect(provider.assetName, pngByMood[mood]);
    }
    if (painterCount > 0) {
      expect(painterCount, 1);
      final cp = tester.widget<CustomPaint>(painter);
      expect(cp.painter, isA<PetPainter>());
      expect((cp.painter! as PetPainter).mood, mood);
    }
    for (final other in PetMood.values.where((m) => m != mood)) {
      expect(find.byKey(PetAvatar.painterKey(other)), findsNothing);
      expect(find.byKey(PetAvatar.pngKey(other)), findsNothing);
      expect(find.byKey(ValueKey('water_pet_image_${other.name}')),
          findsNothing);
    }
  }

  group('ข้อตัดสิน 5: ภาพสัตว์เลี้ยงตามอารมณ์ (PNG หรือ painter) ขอบ 3/4 และ 6/7', () {
    testWidgets('EDGE_S1_pet_mood_0_cups_critical', (tester) async {
      now = dt(10, 8, 10, 0);
      await pumpWith(tester, WaterState.initial);
      expectPetMood(tester, PetMood.critical);
      expect(textOf(tester, statusText), critical);
    });

    testWidgets('AC2_S1_pet_mood_3_cups_critical_then_4_cups_tired',
        (tester) async {
      now = dt(10, 8, 10, 0);
      await pumpWith(tester,
          WaterState(cups: 3, lastLoggedAt: dt(10, 8, 9, 0), history: const []));
      expectPetMood(tester, PetMood.critical);
      await tapLog(tester);
      expect(textOf(tester, countText), 'จำนวนน้ำ: 4 แก้ว');
      expectPetMood(tester, PetMood.tired);
      expect(textOf(tester, statusText), tired);
    });

    testWidgets('EDGE_S1_pet_mood_6_cups_tired_then_7_cups_happy',
        (tester) async {
      now = dt(10, 8, 10, 0);
      await pumpWith(tester,
          WaterState(cups: 6, lastLoggedAt: dt(10, 8, 9, 0), history: const []));
      expectPetMood(tester, PetMood.tired);
      await tapLog(tester);
      expect(textOf(tester, countText), 'จำนวนน้ำ: 7 แก้ว');
      expectPetMood(tester, PetMood.happy);
      expect(textOf(tester, statusText), happy);
    });

    testWidgets('EDGE_S1_pet_mood_after_05_00_reset_back_to_critical',
        (tester) async {
      now = dt(10, 8, 4, 59);
      await pumpWith(tester,
          WaterState(cups: 7, lastLoggedAt: dt(10, 8, 4, 0), history: const []));
      expectPetMood(tester, PetMood.happy);
      now = dt(10, 8, 5, 0);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expectPetMood(tester, PetMood.critical);
    });
  });

  group('ข้อตัดสิน 4: วันที่หน้าประวัติ dd/MM/yyyy', () {
    testWidgets('UI_S2_history_dates_shown_as_dd_MM_yyyy', (tester) async {
      now = dt(10, 8, 10, 0);
      await pumpWith(
          tester,
          WaterState(
              cups: 4,
              lastLoggedAt: dt(10, 8, 9, 0),
              history: [rec(10, 1, 5), rec(10, 3, 4), rec(10, 8, 4)]));
      await openReport(tester);
      for (final d in ['01/10/2026', '03/10/2026', '08/10/2026']) {
        expect(find.descendant(of: historyList, matching: find.text(d)),
            findsOneWidget,
            reason: 'ต้องแสดง $d');
      }
      expect(find.text('2026-10-01'), findsNothing);
      expect(find.textContaining('2026-10'), findsNothing);
    });
  });

  group('ข้อตัดสิน 1: ขอบเดือน AC-6 บนหน้า S-2', () {
    testWidgets('AC6_S2_log_04_59_on_1st_shown_as_31_10_in_october_report',
        (tester) async {
      now = dt(11, 1, 4, 59);
      await pumpWith(tester, WaterState.initial);
      await tapLog(tester);
      await openReport(tester);
      expect(find.descendant(of: historyList, matching: find.text('31/10/2026')),
          findsOneWidget);
      expect(find.text('01/11/2026'), findsNothing);
      expect(textOf(tester, averageText), 'ค่าเฉลี่ย: 1.0 แก้ว/วัน');
    });

    testWidgets('AC6_S2_log_05_00_on_1st_shown_as_01_11_in_november_report',
        (tester) async {
      now = dt(11, 1, 5, 0);
      await pumpWith(
          tester,
          WaterState(
              cups: 6,
              lastLoggedAt: dt(10, 31, 21, 0),
              history: [rec(10, 31, 6)]));
      await tapLog(tester);
      await openReport(tester);
      expect(find.descendant(of: historyList, matching: find.text('01/11/2026')),
          findsOneWidget);
      expect(find.text('31/10/2026'), findsNothing,
          reason: '31 ต.ค. เป็นเดือนก่อน');
      expect(textOf(tester, averageText), 'ค่าเฉลี่ย: 1.0 แก้ว/วัน');
    });

    testWidgets('AC6_S2_open_at_05_00_on_1st_with_only_october_data_is_empty',
        (tester) async {
      now = dt(11, 1, 5, 0);
      await pumpWith(
          tester,
          WaterState(
              cups: 1,
              lastLoggedAt: dt(11, 1, 4, 59),
              history: [rec(10, 30, 4), rec(10, 31, 1)]));
      await openReport(tester);
      expect(find.text(emptyText), findsOneWidget);
      expect(textOf(tester, averageText), 'ค่าเฉลี่ย: 0.0 แก้ว/วัน');
    });
  });

  group('ข้อตัดสิน 2: นาฬิกาย้อนกลับ บนหน้าจอ', () {
    final stored = WaterState(
        cups: 3,
        lastLoggedAt: dt(10, 8, 10, 0),
        history: [rec(10, 7, 6), rec(10, 8, 3)]);

    testWidgets('EDGE_S1_clock_back_opens_without_crash_and_keeps_cups',
        (tester) async {
      now = dt(10, 7, 9, 0);
      await pumpWith(tester, stored);
      expect(tester.takeException(), isNull);
      expect(textOf(tester, countText), 'จำนวนน้ำ: 3 แก้ว');
      expect(textOf(tester, energyText), '37.5%');
      expectPetMood(tester, PetMood.critical);
    });

    testWidgets('EDGE_S1_clock_back_tap_no_crash_and_no_data_loss',
        (tester) async {
      now = dt(10, 7, 9, 0);
      final c = await pumpWith(tester, stored);
      await tapLog(tester);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(tester.takeException(), isNull);
      // ไม่ assert ว่าบันทึกได้หรือไม่ (เอกสารไม่กำหนด) — ตรวจเฉพาะห้ามลบ/ลดข้อมูล
      expect(c.cups, anyOf(3, 4));
      expect(textOf(tester, countText), 'จำนวนน้ำ: ${c.cups} แก้ว');
      expect(c.state.history.first, rec(10, 7, 6));
      expect(c.state.history.last.date, DateTime(2026, 10, 8));
      expect(c.state.history.last.cups, c.cups);
    });

    testWidgets('EDGE_S2_clock_back_report_shows_month_of_last_log',
        (tester) async {
      now = dt(10, 30, 12, 0);
      await pumpWith(
          tester,
          WaterState(
              cups: 2,
              lastLoggedAt: dt(11, 1, 6, 0),
              history: [rec(10, 31, 5), rec(11, 1, 2)]));
      await openReport(tester);
      expect(tester.takeException(), isNull);
      expect(find.descendant(of: historyList, matching: find.text('01/11/2026')),
          findsOneWidget);
      expect(find.text('31/10/2026'), findsNothing);
      expect(textOf(tester, averageText), 'ค่าเฉลี่ย: 2.0 แก้ว/วัน');
    });
  });

  group('ข้อตัดสิน 3: ข้อมูลเสีย/ผิดชนิด บนหน้าจอ', () {
    testWidgets('EDGE_S1_bad_type_prefs_opens_empty_state_no_crash',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'daily_water_count': 'abc',
        'water_energy_percentage': 'abc',
        'last_logged_timestamp': 123,
        'daily_history_log': 3.14,
      });
      now = dt(10, 8, 10, 0);
      await pumpApp(tester, SharedPrefsWaterRepository());
      expect(tester.takeException(), isNull);
      expect(textOf(tester, countText), 'จำนวนน้ำ: 0 แก้ว');
      expect(textOf(tester, energyText), '0%');
      expect(textOf(tester, statusText), critical);
      expectPetMood(tester, PetMood.critical);
      await tapLog(tester);
      expect(textOf(tester, countText), 'จำนวนน้ำ: 1 แก้ว');
    });

    testWidgets('EDGE_S2_bad_history_prefs_shows_empty_report_no_crash',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'daily_history_log': jsonEncode([
          {'date': 20261007, 'cups': 'six'},
        ]),
      });
      now = dt(10, 8, 10, 0);
      await pumpApp(tester, SharedPrefsWaterRepository());
      await openReport(tester);
      expect(tester.takeException(), isNull);
      expect(find.text(emptyText), findsOneWidget);
      expect(textOf(tester, averageText), 'ค่าเฉลี่ย: 0.0 แก้ว/วัน');
    });
  });
}
