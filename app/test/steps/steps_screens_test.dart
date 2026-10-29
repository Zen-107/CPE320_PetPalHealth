// Widget tests: S-1 / S-2 / S-3 ของฟีเจอร์ steps
// ข้อความบนจอคัดลอกตรงตัวจาก docs/steps/ux-flow.md ; ValueKey จาก docs/steps/ui-spec.md
// ข้อความที่ ui-spec ระบุ "(เสนอ — รอยืนยัน)" ใช้ชื่อเทสต์ขึ้นต้น/มีคำว่า ASSUMPTION
// เวลาควบคุมผ่าน clock ของ StepsController + tester.pump(Duration) — ไม่ใช้เวลาจริง
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/steps/screens/steps_dashboard_screen.dart';
import 'package:petpal_health/features/steps/screens/steps_monthly_report_screen.dart';
import 'package:petpal_health/features/steps/steps_controller.dart';
import 'package:petpal_health/features/steps/steps_external.dart';
import 'package:petpal_health/features/steps/steps_models.dart';
import 'package:petpal_health/features/steps/steps_repository.dart';
import 'package:petpal_health/features/steps/steps_rules.dart';
import 'package:petpal_health/features/water/water_controller.dart';
import 'package:petpal_health/features/water/water_models.dart';
import 'package:petpal_health/features/water/water_repository.dart';
import 'package:petpal_health/main.dart';

DateTime t(int day, int h, [int m = 0, int s = 0]) =>
    DateTime(2026, 10, day, h, m, s);
DateTime d(int day, [int month = 10]) => DateTime(2026, month, day);

/// คั่นหลักพันแบบที่ ux-flow ใช้ ("5,500") — เขียนเองในเทสต์ ไม่เรียกโค้ดของ Dev
String fmt(int n) {
  final s = n.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return b.toString();
}

// ---- ข้อความจาก ux-flow.md ----
const s1Title = 'ก้าวเดินประจำวัน';
const setGoalText = 'ตั้งเป้าหมาย';
const reportBtnText = 'รายงานสรุปรายเดือน';
const s2Title = 'ตั้งเป้าหมายก้าวเดินประจำวัน';
const saveGoalText = 'บันทึกเป้าหมาย';
const quotaToastText = 'คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวัน';
const goalErrorText = 'ไม่สามารถบันทึกเป้าหมายได้ กรุณาลองใหม่อีกครั้ง';
const s3Title = 'รายงานสุขภาพประจำเดือน';
const reportLabels = [
  'ก้าวเดินรวมประจำเดือน',
  'ปริมาณน้ำดื่มรวมประจำเดือน',
  'ค่าเฉลี่ยก้าวเดินรายวัน',
  'จำนวนวันที่ทำเป้าหมายสำเร็จ',
];
const exportText = 'ดาวน์โหลดรายงาน (PNG)';
const exportingText = 'กำลังสร้างรายงาน...';
const exportErrorText = 'ไม่สามารถสร้างไฟล์ภาพรายงานได้ในขณะนี้';
const retryText = 'ลองใหม่อีกครั้ง';
const emptyReportText = 'ยังไม่มีข้อมูลสรุปผลในเดือนนี้';
const statusLabels = {
  StepsPetStatus.fat: 'อ้วนอืด',
  StepsPetStatus.chubby: 'จ่ำม่ำ',
  StepsPetStatus.lean: 'หุ่นลีน (สมส่วน)',
  StepsPetStatus.muscle: 'มีกล้ามขา',
};
// ---- ข้อความเสนอใน ui-spec (รอยืนยัน) ----
const addStepsTextProposed = 'เพิ่มก้าวเดิน'; // Q-1
const sensorTitleProposed = 'ไม่สามารถนับก้าวเดินได้'; // Q-4
const sensorContentProposed =
    'กรุณาอนุญาตสิทธิ์เซนเซอร์นับก้าวในหน้า Settings ของเครื่อง'; // Q-4
const openSettingsProposed = 'ไปที่ Settings'; // Q-4

// ---- ValueKey จาก ui-spec.md ----
Finder k(String key) => find.byKey(Key(key));
final countText = k('steps_count_text');
final percentText = k('steps_percent_text');
final energyBar = k('steps_energy_bar');
final badge = k('steps_status_badge');
final addButton = k('steps_add_button');
final setGoalButton = k('steps_set_goal_button');
final reportButton = k('steps_monthly_report_button');
final saveButton = k('steps_goal_save_button');
final exportButton = k('steps_report_export_button');

final pngBytes = Uint8List.fromList([137, 80, 78, 71, 13, 10, 26, 10]);

StepsState dayState(DateTime day, int steps,
        {int goal = 8000,
        DateTime? lastSeenAt,
        List<DailyStepsRecord> history = const []}) =>
    StepsState.initial.copyWith(
        day: day,
        steps: steps,
        activeGoal: goal,
        hasUserGoal: true,
        lastSeenAt: lastSeenAt,
        history: history);

void main() {
  late DateTime now;
  late InMemoryStepsRepository repo;
  late FixedWaterHistorySource water;
  late InMemoryStepsReportExporter exporter;

  setUp(() {
    now = t(14, 10);
    water = FixedWaterHistorySource();
    exporter = InMemoryStepsReportExporter();
  });

  StepsController makeController(StepsState initial,
      {StepsTrackingStatus tracking = StepsTrackingStatus.available,
      bool offline = false}) {
    repo = InMemoryStepsRepository(initial);
    return StepsController(
      repository: repo,
      waterHistory: water,
      exporter: exporter,
      clock: () => now,
      trackingStatus: tracking,
      isOffline: offline,
    );
  }

  Future<StepsController> pumpS1(
    WidgetTester tester, {
    StepsState initial = StepsState.initial,
    StepsTrackingStatus tracking = StepsTrackingStatus.available,
    bool offline = false,
    StepsReportCapture? capture,
    Future<void> Function()? onOpenSettings,
  }) async {
    final c = makeController(initial, tracking: tracking, offline: offline);
    await tester.pumpWidget(MaterialApp(
      home: StepsDashboardScreen(
        controller: c,
        reportCapture: capture ?? (_) async => pngBytes,
        onOpenSettings: onOpenSettings,
      ),
    ));
    await tester.pumpAndSettle();
    return c;
  }

  String textOf(WidgetTester tester, Finder f) => tester.widget<Text>(f).data!;
  double barValue(WidgetTester tester) =>
      tester.widget<LinearProgressIndicator>(energyBar).value!;
  bool enabled(WidgetTester tester, Finder f) =>
      tester.widget<ButtonStyleButton>(f).onPressed != null;
  Finder badgeText(String s) =>
      find.descendant(of: badge, matching: find.text(s));
  bool chipSelected(WidgetTester tester, int goal) =>
      tester.widget<ChoiceChip>(k('steps_goal_chip_$goal')).selected;

  void expectStatus(WidgetTester tester, StepsPetStatus status) {
    expect(k('steps_pet_image_${status.name}'), findsOneWidget,
        reason: 'ภาพ ${status.name}');
    expect(badgeText(statusLabels[status]!), findsOneWidget,
        reason: 'ป้าย ${statusLabels[status]}');
  }

  // =========================================================================
  // S-1
  // =========================================================================
  group('S-1 แดชบอร์ด', () {
    testWidgets('UI_S1_texts_and_buttons_per_ux_flow', (tester) async {
      await pumpS1(tester);
      expect(textOf(tester, k('steps_header_text')), s1Title);
      expect(find.descendant(of: setGoalButton, matching: find.text(setGoalText)),
          findsOneWidget);
      expect(
          find.descendant(of: reportButton, matching: find.text(reportBtnText)),
          findsOneWidget);
      expect(addButton, findsOneWidget);
      expect(energyBar, findsOneWidget);
    });

    testWidgets('UI_S1_ASSUMPTION_Q1_add_button_label_and_icon',
        (tester) async {
      await pumpS1(tester);
      expect(
          find.descendant(
              of: addButton, matching: find.text(addStepsTextProposed)),
          findsOneWidget);
      expect(
          find.descendant(
              of: addButton, matching: find.byIcon(Icons.directions_walk)),
          findsOneWidget);
    });

    testWidgets('EDGE_S1_empty_first_run_0_steps_0_percent_fat',
        (tester) async {
      await pumpS1(tester);
      expect(textOf(tester, countText), '0 / 8,000 ก้าว');
      expect(textOf(tester, percentText), '0%');
      expect(barValue(tester), 0.0);
      expectStatus(tester, StepsPetStatus.fat);
      expect(k('steps_offline_icon'), findsNothing);
      expect(k('steps_sensor_error_dialog'), findsNothing);
      expect(enabled(tester, addButton), isTrue);
    });

    testWidgets('AC1_tap_add_increases_steps_realtime', (tester) async {
      final c = await pumpS1(tester);
      await tester.tap(addButton);
      await tester.pump();
      const per = StepsRules.stepsPerTap; // ค่าชั่วคราว (ui-spec Q-2)
      expect(textOf(tester, countText), '${fmt(per)} / 8,000 ก้าว');
      expect(c.steps, per);
      expect(barValue(tester), closeTo(per / 8000 > 1 ? 1 : per / 8000, 1e-9));
    });

    testWidgets('AC5_tap_add_crosses_35_percent_changes_pet_immediately',
        (tester) async {
      const per = StepsRules.stepsPerTap;
      // เริ่มต่ำกว่า 2,800 (35% ของ 8,000) อยู่ 1 ก้าวหลังกด → กดแล้วต้องถึง/เกิน 2,800
      final start = 2800 - per < 0 ? 0 : 2800 - per;
      await pumpS1(tester, initial: dayState(d(14), start, lastSeenAt: t(14, 9)));
      expectStatus(tester, start * 100 / 8000 >= 35
          ? StepsPetStatus.chubby
          : StepsPetStatus.fat);
      await tester.tap(addButton);
      await tester.pump();
      expectStatus(tester, StepsPetStatus.chubby);
    });

    // ค่าเกณฑ์พอดี ±1 ก้าว ที่เป้าหมาย 8,000 (game-rules §2)
    const thresholdCases = <(int, StepsPetStatus, String?)>[
      (2799, StepsPetStatus.fat, null),
      (2800, StepsPetStatus.chubby, '35%'),
      (5599, StepsPetStatus.chubby, null),
      (5600, StepsPetStatus.lean, '70%'),
      (7999, StepsPetStatus.lean, null),
      (8000, StepsPetStatus.muscle, '100%'),
      (8001, StepsPetStatus.muscle, null),
    ];
    for (final (steps, status, pct) in thresholdCases) {
      testWidgets('EDGE_AC5_S1_${steps}_of_8000_shows_${status.name}',
          (tester) async {
        await pumpS1(tester,
            initial: dayState(d(14), steps, lastSeenAt: t(14, 9)));
        expectStatus(tester, status);
        expect(textOf(tester, countText), '${fmt(steps)} / 8,000 ก้าว');
        if (pct != null) expect(textOf(tester, percentText), pct);
        if (status != StepsPetStatus.muscle) {
          expect(textOf(tester, percentText), isNot('100%'),
              reason: 'ยังไม่ถึง 100% ห้ามแสดง 100%');
        }
      });
    }

    testWidgets('EDGE_S1_over_100_bar_full_text_106_25', (tester) async {
      await pumpS1(tester, initial: dayState(d(14), 8500, lastSeenAt: t(14, 9)));
      expect(textOf(tester, percentText), '106.25%');
      expect(barValue(tester), 1.0);
      expectStatus(tester, StepsPetStatus.muscle);
    });

    testWidgets('EC5_AC6_foreground_crossing_05_00_resets_without_restart',
        (tester) async {
      now = t(14, 4, 59, 58);
      await pumpS1(tester, initial: dayState(d(13), 8500, lastSeenAt: t(13, 22)));
      expect(textOf(tester, countText), '8,500 / 8,000 ก้าว');
      expect(textOf(tester, percentText), '106.25%');

      now = t(14, 4, 59, 59);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(textOf(tester, countText), '8,500 / 8,000 ก้าว',
          reason: '04:59:59 ยังไม่รีเซ็ต');

      now = t(14, 5, 0, 0);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(textOf(tester, countText), '0 / 8,000 ก้าว');
      expect(textOf(tester, percentText), '0%');
      expect(barValue(tester), 0.0);
      expectStatus(tester, StepsPetStatus.fat);
      expect(repo.stored.steps, 0);
    });

    for (final status in [
      StepsTrackingStatus.permissionDenied,
      StepsTrackingStatus.noHardware,
    ]) {
      testWidgets('EC1_EC6_${status.name}_popup_settings_shortcut_and_lock',
          (tester) async {
        var opened = 0;
        await pumpS1(tester,
            tracking: status, onOpenSettings: () async => opened++);
        expect(k('steps_sensor_error_dialog'), findsOneWidget);
        expect(k('steps_open_settings_button'), findsOneWidget);
        expect(enabled(tester, addButton), isFalse, reason: 'ล็อกการนับก้าว');
        // barrierDismissible: false
        await tester.tapAt(const Offset(5, 5));
        await tester.pumpAndSettle();
        expect(k('steps_sensor_error_dialog'), findsOneWidget);
        await tester.tap(k('steps_open_settings_button'));
        await tester.pumpAndSettle();
        expect(opened, 1);
        expect(k('steps_sensor_error_dialog'), findsNothing);
        expect(enabled(tester, addButton), isFalse);
      });
    }

    testWidgets('EC1_ASSUMPTION_Q4_popup_proposed_texts', (tester) async {
      await pumpS1(tester, tracking: StepsTrackingStatus.permissionDenied);
      final dialog = k('steps_sensor_error_dialog');
      expect(find.descendant(of: dialog, matching: find.text(sensorTitleProposed)),
          findsOneWidget);
      expect(
          find.descendant(of: dialog, matching: find.text(sensorContentProposed)),
          findsOneWidget);
      expect(
          find.descendant(
              of: k('steps_open_settings_button'),
              matching: find.text(openSettingsProposed)),
          findsOneWidget);
    });

    testWidgets('S1_disabled_offline_icon_and_last_stored_values',
        (tester) async {
      await pumpS1(tester,
          offline: true, initial: dayState(d(14), 4200, lastSeenAt: t(14, 9)));
      expect(k('steps_offline_icon'), findsOneWidget);
      expect(textOf(tester, countText), '4,200 / 8,000 ก้าว');
    });

    testWidgets('UI_S1_navigation_to_S2_and_S3_and_back', (tester) async {
      await pumpS1(tester);
      await tester.tap(setGoalButton);
      await tester.pumpAndSettle();
      expect(textOf(tester, k('steps_goal_header_text')), s2Title);
      await tester.tap(k('steps_goal_back_button'));
      await tester.pumpAndSettle();
      expect(textOf(tester, k('steps_header_text')), s1Title);

      await tester.tap(reportButton);
      await tester.pumpAndSettle();
      expect(textOf(tester, k('steps_report_header_text')), s3Title);
      await tester.tap(k('steps_report_back_button'));
      await tester.pumpAndSettle();
      expect(textOf(tester, k('steps_header_text')), s1Title);
    });

    testWidgets('UI_D3_entry_from_water_home_opens_S1', (tester) async {
      final c = makeController(StepsState.initial);
      final waterController = WaterController(
          repository: InMemoryWaterRepository(), clock: () => now);
      await tester.pumpWidget(
          PetPalApp(waterController: waterController, stepsController: c));
      await tester.pumpAndSettle();
      await tester.tap(k('steps_entry_button'));
      await tester.pumpAndSettle();
      expect(textOf(tester, k('steps_header_text')), s1Title);
    });
  });

  // =========================================================================
  // S-2
  // =========================================================================
  group('S-2 ตั้งเป้าหมาย', () {
    Future<StepsController> openS2(WidgetTester tester,
        {StepsState initial = StepsState.initial}) async {
      final c = await pumpS1(tester, initial: initial);
      await tester.tap(setGoalButton);
      await tester.pumpAndSettle();
      return c;
    }

    Future<void> back(WidgetTester tester) async {
      await tester.tap(k('steps_goal_back_button'));
      await tester.pumpAndSettle();
    }

    testWidgets('UI_S2_title_chips_and_save_button_texts_per_ux_flow',
        (tester) async {
      await openS2(tester);
      expect(textOf(tester, k('steps_goal_header_text')), s2Title);
      const goals = {
        6000: '6,000 ก้าว',
        7000: '7,000 ก้าว',
        8000: '8,000 ก้าว',
        9000: '9,000 ก้าว',
        10000: '10,000 ก้าว',
        11000: '11,000 ก้าว',
        12000: '12,000 ก้าว',
        13000: '13,000 ก้าว',
        14000: '14,000 ก้าว',
        15000: '15,000 ก้าว',
      };
      expect(find.byType(ChoiceChip), findsNWidgets(goals.length));
      goals.forEach((g, label) {
        expect(
            find.descendant(
                of: k('steps_goal_chip_$g'), matching: find.text(label)),
            findsOneWidget,
            reason: label);
      });
      expect(find.descendant(of: saveButton, matching: find.text(saveGoalText)),
          findsOneWidget);
      expect(k('steps_goal_back_button'), findsOneWidget);
      expect(find.descendant(
              of: k('steps_goal_back_button'),
              matching: find.byIcon(Icons.arrow_back)),
          findsOneWidget);
    });

    testWidgets('UI_S2_ASSUMPTION_Q9_group_headers', (tester) async {
      await openS2(tester);
      expect(textOf(tester, k('steps_goal_group_general')), 'กลุ่มเป้าหมายทั่วไป');
      expect(textOf(tester, k('steps_goal_group_weight')), 'กลุ่มควบคุมน้ำหนัก');
      expect(textOf(tester, k('steps_goal_group_athlete')), 'กลุ่มนักกีฬา');
    });

    testWidgets('EDGE_S2_first_entry_8000_preselected_only', (tester) async {
      await openS2(tester);
      for (final g in [6000, 7000, 9000, 10000, 11000, 12000, 13000, 14000, 15000]) {
        expect(chipSelected(tester, g), isFalse, reason: '$g');
      }
      expect(chipSelected(tester, 8000), isTrue);
      expect(enabled(tester, saveButton), isTrue);
    });

    testWidgets('S2_only_one_chip_selected_across_groups', (tester) async {
      await openS2(tester);
      await tester.tap(k('steps_goal_chip_13000'));
      await tester.pump();
      expect(chipSelected(tester, 13000), isTrue);
      expect(chipSelected(tester, 8000), isFalse);
      await tester.tap(k('steps_goal_chip_6000'));
      await tester.pump();
      expect(chipSelected(tester, 6000), isTrue);
      expect(chipSelected(tester, 13000), isFalse);
    });

    testWidgets('AC2_save_new_goal_updates_S1_percent_immediately',
        (tester) async {
      // ผู้ใช้ใหม่ (ux-flow §3 ข้อ 4–5) มี 3,000 ก้าว เลือก 10,000 แล้วบันทึก
      final c = await openS2(tester,
          initial: StepsState.initial
              .copyWith(day: d(14), steps: 3000, lastSeenAt: t(14, 9)));
      await tester.tap(k('steps_goal_chip_10000'));
      await tester.pump();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(c.activeGoal, 10000);
      expect(repo.stored.activeGoal, 10000, reason: 'อัปเดตในฐานข้อมูล');
      await back(tester);
      expect(textOf(tester, countText), '3,000 / 10,000 ก้าว');
      expect(textOf(tester, percentText), '30%');
    });

    testWidgets('AC3_after_save_button_disabled_and_tap_shows_quota_toast',
        (tester) async {
      await openS2(tester);
      await tester.tap(k('steps_goal_chip_10000'));
      await tester.pump();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(enabled(tester, saveButton), isFalse, reason: 'Disabled สีเทาจาง');
      final saves = repo.saveCount;

      await tester.tap(saveButton, warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      final toast = k('steps_goal_quota_toast');
      expect(toast, findsOneWidget);
      expect(find.descendant(of: toast, matching: find.text(quotaToastText)),
          findsOneWidget);
      expect(repo.saveCount, saves, reason: 'ไม่ให้บันทึกค่าซ้ำ');
      expect(repo.stored.latestGoal, 10000);
    });

    testWidgets('AC3_ASSUMPTION_Q11_reenter_S2_shows_toast_and_chips_locked',
        (tester) async {
      await openS2(tester);
      await tester.tap(saveButton); // บันทึก 8,000 (pre-selected)
      await tester.pumpAndSettle();
      await back(tester);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      await tester.tap(setGoalButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      final toast = k('steps_goal_quota_toast');
      expect(toast, findsOneWidget);
      expect(find.descendant(of: toast, matching: find.text(quotaToastText)),
          findsOneWidget);
      expect(enabled(tester, saveButton), isFalse);
      expect(tester.widget<ChoiceChip>(k('steps_goal_chip_12000')).onSelected,
          isNull);
      expect(chipSelected(tester, 8000), isTrue);
    });

    testWidgets('S2_error_toast_on_save_failure_retry_allowed',
        (tester) async {
      await openS2(tester);
      repo.failSaves = true;
      await tester.tap(k('steps_goal_chip_12000'));
      await tester.pump();
      await tester.tap(saveButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      final toast = k('steps_goal_error_toast');
      expect(toast, findsOneWidget);
      expect(find.descendant(of: toast, matching: find.text(goalErrorText)),
          findsOneWidget);
      expect(enabled(tester, saveButton), isTrue);
      expect(chipSelected(tester, 12000), isTrue);

      // QA fix รอบ 1: SnackBar อยู่ล่างจอทับปุ่มบันทึก → รอ Toast หายก่อนกดซ้ำ
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(toast, findsNothing);
      repo.failSaves = false;
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(repo.stored.activeGoal, 12000);
    });

    testWidgets('AC4_change_after_05_00_applies_next_day_05_00_on_S1',
        (tester) async {
      final c = await openS2(tester,
          initial: dayState(d(14), 6000, lastSeenAt: t(14, 9)));
      await tester.tap(k('steps_goal_chip_12000'));
      await tester.pump();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      await back(tester);
      expect(textOf(tester, countText), '6,000 / 8,000 ก้าว',
          reason: 'รอบวันปัจจุบันยังใช้ค่าเดิม');
      expect(textOf(tester, percentText), '75%');

      now = t(15, 4, 59, 59);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(textOf(tester, countText), '6,000 / 8,000 ก้าว');

      now = t(15, 5, 0, 0);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(textOf(tester, countText), '0 / 12,000 ก้าว');
      expect(c.activeGoal, 12000);
    });

    testWidgets('AC3_quota_resets_at_05_00_save_enabled_again',
        (tester) async {
      await openS2(tester);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      await back(tester);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      now = t(15, 4, 59, 59);
      await tester.tap(setGoalButton);
      await tester.pumpAndSettle();
      expect(enabled(tester, saveButton), isFalse);
      await back(tester);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      now = t(15, 5, 0, 0);
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(setGoalButton);
      await tester.pumpAndSettle();
      expect(enabled(tester, saveButton), isTrue);
      expect(k('steps_goal_quota_toast'), findsNothing);
    });
  });

  // =========================================================================
  // S-3
  // =========================================================================
  group('S-3 รายงานรายเดือน', () {
    // ต.ค. 1–3 มีก้าวทุกวัน + ข้อมูล ก.ย. ที่ต้องไม่ถูกนับ
    StepsState octState() => dayState(d(3), 6000,
            lastSeenAt: t(3, 9),
            history: [
              DailyStepsRecord(date: d(30, 9), steps: 9000, goal: 8000),
              DailyStepsRecord(date: d(1), steps: 8000, goal: 8000),
              DailyStepsRecord(date: d(2), steps: 4000, goal: 8000),
            ]);
    List<DailyWaterRecord> octWater() => [
          DailyWaterRecord(date: d(30, 9), cups: 8),
          DailyWaterRecord(date: d(1), cups: 6),
          DailyWaterRecord(date: d(2), cups: 7),
          DailyWaterRecord(date: d(3), cups: 3),
        ];

    Future<StepsController> openS3(WidgetTester tester,
        {StepsState initial = StepsState.initial,
        StepsReportCapture? capture}) async {
      final c = await pumpS1(tester, initial: initial, capture: capture);
      await tester.tap(reportButton);
      await tester.pumpAndSettle();
      return c;
    }

    testWidgets('UI_S3_title_labels_and_export_button_per_ux_flow',
        (tester) async {
      await openS3(tester);
      expect(textOf(tester, k('steps_report_header_text')), s3Title);
      final card = k('steps_report_summary_card');
      for (final label in reportLabels) {
        expect(find.descendant(of: card, matching: find.text(label)),
            findsOneWidget,
            reason: label);
      }
      expect(find.descendant(of: exportButton, matching: find.text(exportText)),
          findsOneWidget);
      expect(enabled(tester, exportButton), isTrue);
      expect(k('steps_report_back_button'), findsOneWidget);
    });

    testWidgets('AC7_S3_card_shows_four_values_from_storage', (tester) async {
      now = t(3, 10);
      water.history = octWater();
      await openS3(tester, initial: octState());
      expect(textOf(tester, k('steps_report_total_steps')), contains('18,000'));
      expect(textOf(tester, k('steps_report_total_water')), startsWith('16'));
      expect(textOf(tester, k('steps_report_avg_steps')), startsWith('6,000'));
      expect(textOf(tester, k('steps_report_goal_days')),
          matches(RegExp(r'^1(\s|$)')));
      expect(k('steps_report_empty_text'), findsNothing);
    });

    testWidgets('EDGE_S3_empty_month_zero_values_and_empty_text',
        (tester) async {
      await openS3(tester);
      expect(textOf(tester, k('steps_report_empty_text')), emptyReportText);
      for (final key in [
        'steps_report_total_steps',
        'steps_report_total_water',
        'steps_report_avg_steps',
        'steps_report_goal_days',
      ]) {
        expect(textOf(tester, k(key)), matches(RegExp(r'^0(\.0+)?(\s|$)')),
            reason: key);
      }
      expect(enabled(tester, exportButton), isTrue);
    });

    testWidgets('AC7_export_png_of_report_area_saved_once', (tester) async {
      now = t(3, 10);
      water.history = octWater();
      RenderRepaintBoundary? captured;
      await openS3(tester, initial: octState(), capture: (b) async {
        captured = b;
        return pngBytes;
      });
      // พื้นที่ export (1 หน้า) มีครบ 4 ตัวแปร
      final area = k('steps_report_capture');
      for (final key in [
        'steps_report_total_steps',
        'steps_report_total_water',
        'steps_report_avg_steps',
        'steps_report_goal_days',
      ]) {
        expect(find.descendant(of: area, matching: k(key)), findsOneWidget,
            reason: key);
      }
      await tester.tap(exportButton);
      await tester.pumpAndSettle();
      expect(captured, same(tester.renderObject(area)));
      expect(exporter.saved, hasLength(1));
      expect(exporter.saved.single, pngBytes);
      expect(k('steps_report_error_dialog'), findsNothing);
      expect(enabled(tester, exportButton), isTrue);
    });

    testWidgets('S3_exporting_button_disabled_with_spinner_text',
        (tester) async {
      final pending = Completer<Uint8List>();
      await openS3(tester, capture: (_) => pending.future);
      await tester.tap(exportButton);
      await tester.pump();
      await tester.pump();
      expect(enabled(tester, exportButton), isFalse);
      expect(find.descendant(of: exportButton, matching: find.text(exportingText)),
          findsOneWidget);
      expect(k('steps_report_exporting_indicator'), findsOneWidget);
      expect(find.descendant(
              of: exportButton,
              matching: find.byType(CircularProgressIndicator)),
          findsOneWidget);

      pending.complete(pngBytes);
      await tester.pumpAndSettle();
      expect(enabled(tester, exportButton), isTrue);
      expect(find.descendant(of: exportButton, matching: find.text(exportText)),
          findsOneWidget);
      expect(exporter.saved, hasLength(1));
    });

    testWidgets('S3_export_error_dialog_and_retry_succeeds', (tester) async {
      await openS3(tester);
      exporter.fail = true;
      await tester.tap(exportButton);
      await tester.pumpAndSettle();
      final dialog = k('steps_report_error_dialog');
      expect(dialog, findsOneWidget);
      expect(find.descendant(of: dialog, matching: find.text(exportErrorText)),
          findsOneWidget);
      expect(
          find.descendant(
              of: k('steps_report_retry_button'), matching: find.text(retryText)),
          findsOneWidget);
      expect(exporter.saved, isEmpty);

      exporter.fail = false;
      await tester.tap(k('steps_report_retry_button'));
      await tester.pumpAndSettle();
      expect(dialog, findsNothing);
      expect(exporter.saved, hasLength(1));
    });

    testWidgets('S3_capture_failure_shows_error_dialog', (tester) async {
      await openS3(tester,
          capture: (_) async => throw StateError('render failed'));
      await tester.tap(exportButton);
      await tester.pumpAndSettle();
      expect(k('steps_report_error_dialog'), findsOneWidget);
      expect(exporter.saved, isEmpty);
    });

    testWidgets('S3_load_failure_shows_error_dialog_retry_recovers',
        (tester) async {
      water.fail = true;
      await openS3(tester);
      expect(k('steps_report_error_dialog'), findsOneWidget);
      expect(find.text(exportErrorText), findsOneWidget);
      water.fail = false;
      await tester.tap(k('steps_report_retry_button'));
      await tester.pumpAndSettle();
      expect(k('steps_report_error_dialog'), findsNothing);
    });
  });

  // =========================================================================
  // จอแคบ 360 dp (ui-spec §5 checklist)
  // =========================================================================
  group('UI จอ 360 dp', () {
    testWidgets('UI_360dp_S1_S2_S3_no_overflow', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      now = t(3, 10);
      water.history = [DailyWaterRecord(date: d(1), cups: 12345)];
      await pumpS1(tester,
          initial: dayState(d(3), 123456,
              goal: 15000,
              lastSeenAt: t(3, 9),
              history: [
                DailyStepsRecord(date: d(1), steps: 99999, goal: 15000),
              ]));
      expect(tester.takeException(), isNull);
      await tester.tap(setGoalButton);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(k('steps_goal_back_button'));
      await tester.pumpAndSettle();
      await tester.tap(reportButton);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
