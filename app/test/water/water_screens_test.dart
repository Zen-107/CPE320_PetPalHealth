// Widget tests: S-1 หน้าจอหลัก และ S-2 รายงานรายเดือน (ux-flow.md §2, §4)
// เวลาควบคุมผ่าน clock ของ WaterController — ไม่ใช้เวลาจริง
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/water/water_controller.dart';
import 'package:petpal_health/features/water/water_models.dart';
import 'package:petpal_health/features/water/water_repository.dart';
import 'package:petpal_health/main.dart';

DateTime t(int day, int hour, int minute, [int second = 0]) =>
    DateTime(2026, 10, day, hour, minute, second);

const toastText = 'กรุณารอสักครู่ (1 แก้วต่อ 5 นาที)';
const critical = 'เหี่ยวเฉา ป่วย ใกล้ตาย';
const tired = 'เริ่มเพลีย อ่อนแรง แลบลิ้น';
const happy = 'สดชื่น ร่าเริง มีความสุข';

final logButton = find.byKey(const Key('water_log_button'));
final countText = find.byKey(const Key('water_count_text'));
final statusText = find.byKey(const Key('water_pet_status_text'));
final energyBar = find.byKey(const Key('water_energy_bar'));
final energyText = find.byKey(const Key('water_energy_text'));
final toast = find.byKey(const Key('water_anti_spam_toast'));
final reportButton = find.byKey(const Key('water_monthly_report_button'));

void main() {
  late DateTime now;

  Future<WaterController> pumpApp(WidgetTester tester,
      [WaterState initial = WaterState.initial]) async {
    final c = WaterController(
      repository: InMemoryWaterRepository(initial),
      clock: () => now,
    );
    await tester.pumpWidget(PetPalApp(waterController: c));
    await tester.pumpAndSettle();
    return c;
  }

  String textOf(WidgetTester tester, Finder f) =>
      tester.widget<Text>(f).data!;

  double barValue(WidgetTester tester) =>
      tester.widget<LinearProgressIndicator>(energyBar).value!;

  Future<void> tapLog(WidgetTester tester) async {
    await tester.tap(logButton);
    await tester.pump();
  }

  group('S-1 หน้าจอหลัก', () {
    testWidgets('UI_S1_button_label_and_plus_icon_per_ux_flow', (tester) async {
      now = t(8, 10, 0);
      await pumpApp(tester);
      expect(find.descendant(of: logButton, matching: find.text('ดื่มน้ำ 1 แก้ว')),
          findsOneWidget);
      expect(find.descendant(of: logButton, matching: find.byIcon(Icons.add)),
          findsOneWidget);
      expect(
          find.descendant(of: reportButton, matching: find.text('รายงานรายเดือน')),
          findsOneWidget);
    });

    testWidgets('EDGE_S1_first_open_shows_0_cups_0_percent_critical',
        (tester) async {
      now = t(8, 10, 0);
      await pumpApp(tester);
      expect(textOf(tester, countText), 'จำนวนน้ำ: 0 แก้ว');
      expect(barValue(tester), 0.0);
      expect(textOf(tester, energyText), '0%');
      expect(textOf(tester, statusText), critical);
    });

    testWidgets('AC1_S1_tap_plus_shows_1_cup_and_12_5_percent', (tester) async {
      now = t(8, 10, 0);
      await pumpApp(tester);
      await tapLog(tester);
      expect(textOf(tester, countText), 'จำนวนน้ำ: 1 แก้ว');
      expect(barValue(tester), closeTo(0.125, 1e-9));
      expect(textOf(tester, energyText), '12.5%');
    });

    testWidgets('AC2_S1_3_to_4_cups_status_changes_critical_to_tired',
        (tester) async {
      now = t(8, 10, 0);
      await pumpApp(tester,
          WaterState(cups: 3, lastLoggedAt: t(8, 9, 0), history: const []));
      expect(textOf(tester, statusText), critical);
      expect(find.byKey(const ValueKey('water_pet_image_critical')),
          findsOneWidget);
      await tapLog(tester);
      expect(textOf(tester, countText), 'จำนวนน้ำ: 4 แก้ว');
      expect(textOf(tester, energyText), '50%');
      expect(textOf(tester, statusText), tired);
      expect(find.byKey(const ValueKey('water_pet_image_tired')),
          findsOneWidget);
    });

    testWidgets('EDGE_S1_6_to_7_cups_status_changes_tired_to_happy',
        (tester) async {
      now = t(8, 10, 0);
      await pumpApp(tester,
          WaterState(cups: 6, lastLoggedAt: t(8, 9, 0), history: const []));
      expect(textOf(tester, statusText), tired);
      await tapLog(tester);
      expect(textOf(tester, energyText), '87.5%');
      expect(textOf(tester, statusText), happy);
      expect(find.byKey(const ValueKey('water_pet_image_happy')),
          findsOneWidget);
    });

    testWidgets('AC3_S1_tap_within_5_min_shows_toast_and_count_unchanged',
        (tester) async {
      now = t(8, 10, 0);
      await pumpApp(tester);
      await tapLog(tester);
      now = t(8, 10, 3);
      await tapLog(tester);
      await tester.pump(const Duration(milliseconds: 300));
      expect(toast, findsOneWidget);
      expect(find.text(toastText), findsOneWidget);
      expect(textOf(tester, countText), 'จำนวนน้ำ: 1 แก้ว');
      expect(textOf(tester, energyText), '12.5%');
    });

    testWidgets('AC3_S1_toast_disappears_after_2_seconds', (tester) async {
      // game-rules §4 / คำตัดสินทีม: Toast หายเองใน 2 วินาที
      now = t(8, 10, 0);
      await pumpApp(tester);
      await tapLog(tester);
      now = t(8, 10, 1);
      await tapLog(tester);
      await tester.pumpAndSettle(); // แสดงเต็มแล้ว
      expect(find.text(toastText), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1900));
      expect(find.text(toastText), findsOneWidget,
          reason: 'ยังไม่ครบ 2 วินาที');
      await tester.pump(const Duration(milliseconds: 100)); // ครบ 2 วินาที
      await tester.pumpAndSettle();
      expect(find.text(toastText), findsNothing);
    });

    testWidgets('AC4_S1_tap_after_5_min_logs_successfully', (tester) async {
      now = t(8, 10, 0);
      final c = await pumpApp(tester);
      await tapLog(tester);
      now = t(8, 10, 5);
      await tapLog(tester);
      await tester.pump(const Duration(milliseconds: 300));
      expect(textOf(tester, countText), 'จำนวนน้ำ: 2 แก้ว');
      expect(toast, findsNothing);
      expect(c.state.lastLoggedAt, t(8, 10, 5));
    });

    testWidgets('EC3_S1_rapid_double_tap_logs_once_and_shows_toast',
        (tester) async {
      now = t(8, 10, 0);
      await pumpApp(tester);
      await tester.tap(logButton);
      await tester.tap(logButton);
      await tester.tap(logButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(textOf(tester, countText), 'จำนวนน้ำ: 1 แก้ว');
      expect(find.text(toastText), findsOneWidget);
    });

    testWidgets('AC5_S1_open_app_after_05_00_shows_0_cups_0_percent',
        (tester) async {
      now = t(8, 5, 0);
      await pumpApp(tester,
          WaterState(cups: 5, lastLoggedAt: t(8, 4, 30), history: const []));
      expect(textOf(tester, countText), 'จำนวนน้ำ: 0 แก้ว');
      expect(barValue(tester), 0.0);
      expect(textOf(tester, energyText), '0%');
      expect(textOf(tester, statusText), critical);
    });

    testWidgets('AC5_S1_open_at_04_59_still_shows_5_cups', (tester) async {
      now = t(8, 4, 59);
      await pumpApp(tester,
          WaterState(cups: 5, lastLoggedAt: t(8, 4, 30), history: const []));
      expect(textOf(tester, countText), 'จำนวนน้ำ: 5 แก้ว');
      expect(textOf(tester, energyText), '62.5%');
    });

    testWidgets('AC5_S1_app_left_open_across_05_00_resets_on_screen',
        (tester) async {
      now = t(8, 4, 59);
      await pumpApp(tester,
          WaterState(cups: 5, lastLoggedAt: t(8, 4, 30), history: const []));
      expect(textOf(tester, countText), 'จำนวนน้ำ: 5 แก้ว');
      now = t(8, 5, 0);
      // จำลองแอปกลับมา foreground (ux-flow §3 ข้อ 1 ระบบตรวจเวลา)
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(textOf(tester, countText), 'จำนวนน้ำ: 0 แก้ว');
      expect(textOf(tester, energyText), '0%');
    });

    testWidgets('EDGE_S1_log_04_58_tap_05_01_shows_toast_after_reset',
        (tester) async {
      now = t(8, 5, 1);
      await pumpApp(tester,
          WaterState(cups: 3, lastLoggedAt: t(8, 4, 58), history: const []));
      expect(textOf(tester, countText), 'จำนวนน้ำ: 0 แก้ว');
      await tapLog(tester);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text(toastText), findsOneWidget);
      expect(textOf(tester, countText), 'จำนวนน้ำ: 0 แก้ว');
      await tester.pumpAndSettle(const Duration(seconds: 3));
      now = t(8, 5, 3);
      await tapLog(tester);
      expect(textOf(tester, countText), 'จำนวนน้ำ: 1 แก้ว');
    });

    testWidgets('EC1_S1_12_cups_bar_full_100_but_count_12', (tester) async {
      now = t(8, 20, 0);
      await pumpApp(tester,
          WaterState(cups: 11, lastLoggedAt: t(8, 19, 0), history: const []));
      await tapLog(tester);
      expect(textOf(tester, countText), 'จำนวนน้ำ: 12 แก้ว');
      expect(barValue(tester), 1.0);
      expect(textOf(tester, energyText), '100%');
      expect(textOf(tester, statusText), happy);
    });
  });

  group('S-2 รายงานรายเดือน', () {
    WaterState withHistory(List<DailyWaterRecord> h) =>
        WaterState(cups: 4, lastLoggedAt: t(8, 9, 0), history: h);

    DailyWaterRecord rec(int m, int d, int cups) =>
        DailyWaterRecord(date: DateTime(2026, m, d), cups: cups);

    testWidgets('UI_S2_open_from_S1_shows_header_and_back_returns',
        (tester) async {
      now = t(8, 10, 0);
      await pumpApp(tester);
      await tester.tap(reportButton);
      await tester.pumpAndSettle();
      expect(find.text('รายงานการดื่มน้ำประจำเดือน'), findsOneWidget);
      final back = find.byKey(const Key('water_report_back_button'));
      expect(back, findsOneWidget);
      expect(find.byTooltip('ย้อนกลับ'), findsOneWidget);
      await tester.tap(back);
      await tester.pumpAndSettle();
      expect(logButton, findsOneWidget);
      expect(find.text('รายงานการดื่มน้ำประจำเดือน'), findsNothing);
    });

    testWidgets('AC6_S2_average_4_5_and_daily_history_list', (tester) async {
      now = t(8, 10, 0);
      await pumpApp(tester,
          withHistory([rec(10, 1, 5), rec(10, 2, 0), rec(10, 3, 4)]));
      await tester.tap(reportButton);
      await tester.pumpAndSettle();
      expect(
          tester
              .widget<Text>(find.byKey(const Key('water_monthly_average_text')))
              .data,
          'ค่าเฉลี่ย: 4.5 แก้ว/วัน');
      final list = find.byKey(const Key('water_monthly_history_list'));
      expect(list, findsOneWidget);
      expect(find.descendant(of: list, matching: find.byType(ListTile)),
          findsNWidgets(2));
      expect(find.descendant(of: list, matching: find.text('5 แก้ว')),
          findsOneWidget);
      expect(find.descendant(of: list, matching: find.text('4 แก้ว')),
          findsOneWidget);
    });

    testWidgets('EDGE_S2_empty_history_shows_empty_text_and_0_0',
        (tester) async {
      now = t(8, 10, 0);
      await pumpApp(tester);
      await tester.tap(reportButton);
      await tester.pumpAndSettle();
      expect(find.text('ยังไม่มีประวัติการดื่มน้ำในเดือนนี้'), findsOneWidget);
      expect(find.text('ค่าเฉลี่ย: 0.0 แก้ว/วัน'), findsOneWidget);
    });
  });
}
