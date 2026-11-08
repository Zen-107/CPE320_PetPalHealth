// Controller tests: NotificationController + FakeNotificationScheduler + 3 controller จริง
// (water / steps / food ใช้ clock เดียวกัน — ui-spec §2.4.6) · ไม่เรียก plugin จริง ไม่ต่อเน็ต
// ค่าคาดหวังจาก requirements AC/EC, game-rules §1–§4, ux-flow §2/§4 และข้อตัดสิน owner
// (DECIDED 2026-11-08: EC-9 ตอบการ์ดแล้ว + ON + GRANTED, Q-28 logout, Q-03..Q-27 ตาม ui-spec)
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/food/food_models.dart';
import 'package:petpal_health/features/notification/notification_logic.dart';
import 'package:petpal_health/features/notification/notification_models.dart';
import 'package:petpal_health/features/notification/notification_repository.dart';
import 'package:petpal_health/features/notification/notification_rules.dart';
import 'package:petpal_health/features/signup/signup_controller.dart';
import 'package:petpal_health/features/signup/signup_repository.dart';
import 'package:petpal_health/features/steps/steps_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_test_helpers.dart';

typedef M = NotificationMessage;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DateTime now;
  setUp(() => now = t(today, 5, 30));

  Harness h({
    NotificationState state = NotificationState.initial,
    NotificationRepository? repo,
    int cups = 0,
    DateTime? waterAt,
    StepsTrackingStatus tracking = StepsTrackingStatus.available,
    int? steps,
    int? kcal,
    FakeNotificationScheduler? scheduler,
  }) =>
      makeHarness(
        clock: () => now,
        state: state,
        repo: repo,
        water: waterOn(cups, waterAt),
        steps: steps == null ? null : stepsOn(today, steps),
        food: kcal == null ? null : foodOn(today, kcal),
        tracking: tracking,
        scheduler: scheduler,
      );

  /// T-1 (ui-spec §2.4.4) — แผนเต็มวันเมื่อเปิด 05:30 ไม่มีข้อมูล เป้าก้าว 8,000 มีเป้าอาหาร
  final t1 = [
    (M.waterFirst, t(today, 8)),
    (M.waterSecond, t(today, 10)),
    (M.walkInactive, t(today, 10, 30)),
    (M.foodUnlogged, t(today, 12)),
    (M.foodUnlogged, t(today, 15)),
    (M.foodUnlogged, t(today, 18)),
  ];

  // =========================================================================
  // S-1 คำตอบบนการ์ด (AC-2, AC-3, AC-5) + EC-9
  // =========================================================================
  group('S-1 consent', () {
    test('AC2_allow_saves_ALLOWED_ON_requests_once_and_schedules_T1', () async {
      final x = h();
      await x.controller.start();
      expect(x.controller.consentStatus, NotificationConsentStatus.unanswered);
      expect(x.scheduler.requestCount, 0, reason: 'ไม่ขอสิทธิ์ก่อนผู้ใช้ตอบ');
      expect(x.scheduler.active, isEmpty, reason: 'ยังไม่ตอบการ์ด = ไม่ตั้งเวลา');
      await x.controller.answerConsent(allowed: true);
      expect(x.scheduler.requestCount, 1);
      expect(x.mem.state.consentStatus, NotificationConsentStatus.allowed);
      expect(x.mem.state.masterSwitch, isTrue);
      expect(x.mem.state.systemPermission, NotificationSystemPermission.granted);
      expect(slotsOf(x.scheduler.pendingAt(now)), t1);
    });

    test('AC3_deny_saves_DENIED_OFF_no_request_no_schedule_even_after_data_change',
        () async {
      final x = h();
      await x.controller.start();
      await x.controller.answerConsent(allowed: false);
      expect(x.scheduler.requestCount, 0);
      expect(x.mem.state.consentStatus, NotificationConsentStatus.denied);
      expect(x.mem.state.masterSwitch, isFalse);
      expect(x.scheduler.scheduledLog, isEmpty);
      now = t(today, 9);
      await x.sources.water.logWater();
      await x.controller.onAppResumed();
      await pumpEventQueue();
      expect(x.scheduler.requestCount, 0, reason: 'ไม่ถามซ้ำเอง');
      expect(x.scheduler.scheduledLog, isEmpty);
    });

    test('AC4_answer_only_once_second_answer_ignored', () async {
      final x = h();
      await x.controller.start();
      await x.controller.answerConsent(allowed: false);
      await x.controller.answerConsent(allowed: true);
      expect(x.controller.consentStatus, NotificationConsentStatus.denied);
      expect(x.scheduler.requestCount, 0);
    });

    test('AC5_switch_reflects_card_answer', () async {
      final a = h();
      await a.controller.start();
      await a.controller.answerConsent(allowed: true);
      expect(a.controller.isSwitchOn, isTrue);
      final b = h();
      await b.controller.start();
      await b.controller.answerConsent(allowed: false);
      expect(b.controller.isSwitchOn, isFalse);
    });

    test('DECIDED_EC9_AC6_deny_then_switch_on_requests_and_schedules', () async {
      final x = h();
      await x.controller.start();
      await x.controller.answerConsent(allowed: false);
      await x.controller.setMasterSwitch(true);
      expect(x.scheduler.requestCount, 1, reason: 'ครั้งแรกของผู้ที่กดไม่อนุญาต');
      expect(x.controller.systemPermission, NotificationSystemPermission.granted);
      expect(x.controller.isSwitchOn, isTrue);
      expect(slotsOf(x.scheduler.pendingAt(now)), t1);
    });

    test('Q05_DENIED_switch_on_requests_again_still_denied_shows_off', () async {
      final x = h(
          state: const NotificationState(
              consentStatus: NotificationConsentStatus.allowed,
              masterSwitch: false,
              systemPermission: NotificationSystemPermission.denied),
          scheduler: FakeNotificationScheduler(
              checkResult: NotificationSystemPermission.denied,
              requestResult: NotificationSystemPermission.denied));
      await x.controller.start();
      await x.controller.setMasterSwitch(true);
      expect(x.scheduler.requestCount, 1);
      expect(x.controller.isSwitchOn, isFalse);
      expect(x.scheduler.active, isEmpty);
    });

    test('EDGE_S1_ERROR_storage_unreadable_no_request_no_schedule_can_enable_in_S2',
        () async {
      final x = h(repo: BrokenLoadNotificationRepository());
      await x.controller.start();
      expect(x.controller.isLoaded, isTrue);
      expect(x.controller.consentStatus, isNot(NotificationConsentStatus.unanswered),
          reason: 'ไม่แสดงการ์ด');
      expect(x.controller.isSwitchOn, isFalse);
      expect(x.scheduler.requestCount, 0);
      expect(x.scheduler.active, isEmpty);
      await x.controller.setMasterSwitch(true);
      expect(x.scheduler.requestCount, 1);
      expect(x.scheduler.active, isNotEmpty);
    });

    test('EDGE_S1_ERROR_save_fails_after_allow_treated_as_denied_temporarily',
        () async {
      final x = h(repo: BrokenSaveNotificationRepository());
      await x.controller.start();
      await x.controller.answerConsent(allowed: true);
      expect(x.scheduler.requestCount, 0);
      expect(x.scheduler.active, isEmpty);
      expect(x.controller.isSwitchOn, isFalse);
    });
  });

  // =========================================================================
  // S-2 สวิตช์ (AC-6, AC-7, AC-8, EC-1, EC-10)
  // =========================================================================
  group('S-2 switch / permission', () {
    test('AC6_switch_on_not_determined_requests_permission', () async {
      final x = h(
          state: const NotificationState(
              consentStatus: NotificationConsentStatus.denied));
      await x.controller.start();
      expect(x.scheduler.requestCount, 0);
      await x.controller.setMasterSwitch(true);
      expect(x.scheduler.requestCount, 1);
      expect(x.mem.state.masterSwitch, isTrue);
    });

    test('AC7_switch_off_cancels_every_pending_keeps_committed_no_cancelAll',
        () async {
      now = t(today, 7);
      final x = h(state: grantedOn);
      await x.controller.start();
      final planned = x.scheduler.pendingAt(now);
      expect(planned, isNotEmpty);
      now = t(today, 8, 15); // waterFirst 08:00 ส่งแล้ว
      await x.controller.setMasterSwitch(false);
      final sent = planned.where((i) => !i.scheduledAt.isAfter(now)).toList();
      final pend = planned.where((i) => i.scheduledAt.isAfter(now)).toList();
      expect(sent.map((i) => i.message), [M.waterFirst]);
      expect(x.scheduler.cancelledLog.toSet(), pend.map((i) => i.id).toSet());
      expect(x.scheduler.cancelledLog, isNot(contains(sent.single.id)));
      expect(x.scheduler.cancelAllCount, 0);
      expect(x.scheduler.pendingAt(now), isEmpty);
      expect(x.mem.state.masterSwitch, isFalse);
      // ไม่ตั้งใหม่จนกว่าจะเปิด
      final before = x.scheduler.scheduledLog.length;
      await x.sources.water.logWater();
      await x.controller.onAppResumed();
      await pumpEventQueue();
      expect(x.scheduler.scheduledLog.length, before);
      await x.controller.setMasterSwitch(true);
      expect(x.scheduler.pendingAt(now), isNotEmpty);
      expect(x.scheduler.requestCount, 0, reason: 'GRANTED แล้วไม่ต้องขอซ้ำ');
    });

    test('AC8_EC10_system_denies_on_request_switch_off_nothing_scheduled', () async {
      final x = h(
          scheduler: FakeNotificationScheduler(
              requestResult: NotificationSystemPermission.denied));
      await x.controller.start();
      await x.controller.answerConsent(allowed: true);
      expect(x.controller.systemPermission, NotificationSystemPermission.denied);
      expect(x.mem.state.systemPermission, NotificationSystemPermission.denied);
      expect(x.controller.isSwitchOn, isFalse);
      expect(x.scheduler.active, isEmpty);
    });

    test('EC10_DECIDED_Q23_resume_denied_cancels_then_granted_reschedules',
        () async {
      now = t(today, 7);
      final x = h(state: grantedOn);
      await x.controller.start();
      final planned = slotsOf(x.scheduler.pendingAt(now));
      expect(planned, isNotEmpty);
      x.scheduler.checkResult = NotificationSystemPermission.denied;
      await x.controller.onAppResumed();
      expect(x.controller.systemPermission, NotificationSystemPermission.denied);
      expect(x.controller.isSwitchOn, isFalse);
      expect(x.controller.masterSwitch, isTrue, reason: 'Q-23 เก็บ master ไว้');
      expect(x.scheduler.pendingAt(now), isEmpty);
      x.scheduler.checkResult = NotificationSystemPermission.granted;
      await x.controller.onAppResumed();
      expect(x.controller.isSwitchOn, isTrue);
      expect(slotsOf(x.scheduler.pendingAt(now)), planned);
      expect(x.scheduler.requestCount, 0, reason: 'resume ไม่แสดงกล่อง');
    });

    test('EC1_rapid_toggle_ends_off_no_pending_storage_off', () async {
      now = t(today, 7);
      final x = h(state: grantedOn);
      await x.controller.start();
      await Future.wait([
        x.controller.setMasterSwitch(false),
        x.controller.setMasterSwitch(true),
        x.controller.setMasterSwitch(false),
        x.controller.setMasterSwitch(true),
        x.controller.setMasterSwitch(false),
      ]);
      await pumpEventQueue();
      expect(x.controller.isSwitchOn, isFalse);
      expect(x.mem.state.masterSwitch, isFalse);
      expect(x.scheduler.pendingAt(now), isEmpty);
    });

    test('EC1_rapid_toggle_ends_on_exactly_one_copy_of_plan', () async {
      now = t(today, 7);
      final x = h(state: grantedOn);
      await x.controller.start();
      final planned = slotsOf(x.scheduler.pendingAt(now));
      await Future.wait([
        x.controller.setMasterSwitch(false),
        x.controller.setMasterSwitch(true),
        x.controller.setMasterSwitch(false),
        x.controller.setMasterSwitch(true),
      ]);
      await pumpEventQueue();
      expect(x.controller.isSwitchOn, isTrue);
      expect(slotsOf(x.scheduler.pendingAt(now)), planned);
      expect(x.scheduler.active.length, planned.length);
    });

    test('EC1_rapid_toggle_while_os_dialog_open_last_state_off_wins', () async {
      final sched = FakeNotificationScheduler()
        ..requestGate = Completer<NotificationSystemPermission>();
      final x = h(
          state: const NotificationState(
              consentStatus: NotificationConsentStatus.denied),
          scheduler: sched);
      await x.controller.start();
      final first = x.controller.setMasterSwitch(true);
      await pumpEventQueue();
      expect(sched.requestCount, 1, reason: 'กล่องของ OS เปิดอยู่');
      expect(x.controller.isSwitchOn, isTrue, reason: 'ระหว่างรอแสดงค่าที่เพิ่งกด');
      final fs = [
        first,
        x.controller.setMasterSwitch(false),
        x.controller.setMasterSwitch(true),
        x.controller.setMasterSwitch(false),
      ];
      await pumpEventQueue();
      expect(sched.requestCount, 1, reason: 'ระหว่างรอ ห้ามขอซ้ำ');
      sched.requestGate!.complete(NotificationSystemPermission.granted);
      await Future.wait(fs);
      await pumpEventQueue();
      expect(x.controller.isSwitchOn, isFalse);
      expect(x.mem.state.masterSwitch, isFalse);
      expect(sched.pendingAt(now), isEmpty);
    });
  });

  // =========================================================================
  // วางแผนจากข้อมูลจริงของ 3 ฟีเจอร์ (AC-9..AC-34)
  // =========================================================================
  group('planning from sources', () {
    test('T17_AC34_EC6_water_log_cancels_old_waterFirst_schedules_new_anchor',
        () async {
      now = t(today, 8);
      final x = h(
          state: grantedOn,
          cups: 3,
          waterAt: t(today, 8),
          tracking: StepsTrackingStatus.permissionDenied,
          kcal: 2000);
      await x.controller.start();
      expect(slotsOf(x.scheduler.pendingAt(now)), [
        (M.waterFirst, t(today, 10)),
        (M.waterSecond, t(today, 12)),
      ]);
      final old = x.scheduler.pendingAt(now).map((i) => i.id).toSet();
      now = t(today, 9);
      await x.sources.water.logWater();
      await pumpEventQueue();
      expect(x.scheduler.cancelledLog.toSet(), old);
      final neo = x.scheduler.pendingAt(now);
      expect(slotsOf(neo), [
        (M.waterFirst, t(today, 11)),
        (M.waterSecond, t(today, 13)),
      ]);
      expect(neo.every((i) => i.anchor == t(today, 9)), isTrue);
    });

    test('AC19_eighth_cup_stops_water_for_the_day', () async {
      now = t(today, 8);
      final x = h(
          state: grantedOn,
          cups: 7,
          waterAt: t(today, 7),
          tracking: StepsTrackingStatus.noHardware,
          kcal: 2000);
      await x.controller.start();
      expect(x.scheduler.pendingAt(now), hasLength(2));
      await x.sources.water.logWater();
      await pumpEventQueue();
      expect(x.sources.water.cups, docWaterGoal);
      expect(x.scheduler.pendingAt(now), isEmpty);
    });

    test('AC34_food_log_cancels_remaining_food_unlogged', () async {
      now = t(today, 9);
      final x = h(
          state: grantedOn,
          cups: 8,
          waterAt: t(today, 8),
          tracking: StepsTrackingStatus.permissionDenied);
      await x.controller.start();
      expect(slotsOf(x.scheduler.pendingAt(now)).map((s) => s.$1),
          [M.foodUnlogged, M.foodUnlogged, M.foodUnlogged, M.foodNight]);
      await x.sources.food.logNutrition(const FoodNutrition(calories: 500));
      await pumpEventQueue();
      expect(slotsOf(x.scheduler.pendingAt(now)), [(M.foodNight, t(today, 21))]);
    });

    test('AC9_AC34_new_steps_cancels_walkInactive_restarts_4h_and_stores_time',
        () async {
      now = t(today, 8);
      final x = h(state: grantedOn, cups: 8, waterAt: t(today, 7), steps: 1000,
          kcal: 2000);
      await x.controller.start();
      expect(slotsOf(x.scheduler.pendingAt(now)), [(M.walkInactive, t(today, 10))]);
      now = t(today, 9);
      await x.sources.steps.addSteps();
      await pumpEventQueue();
      expect(x.controller.lastStepsIncreasedAt, t(today, 9));
      expect(x.mem.state.lastStepsIncreasedTimestamp, t(today, 9));
      expect(slotsOf(x.scheduler.pendingAt(now)), [(M.walkInactive, t(today, 13))]);
    });

    test('AC11_steps_reach_80_percent_near_goal_scheduled_once', () async {
      now = t(today, 13);
      // ก้าวล่าสุด 12:30 (เก็บไว้ในเครื่อง) → เดิน: ไม่ขยับ ครบ 16:30 ไม่ชนคิว 13:00
      final x = h(
          state: NotificationState(
              consentStatus: NotificationConsentStatus.allowed,
              masterSwitch: true,
              systemPermission: NotificationSystemPermission.granted,
              lastStepsIncreasedTimestamp: t(today, 12, 30)),
          cups: 8,
          waterAt: t(today, 12),
          steps: 5400,
          kcal: 2000);
      await x.controller.start();
      // เป้า 8,000: 5,400 → 6,400 = 80.00% พอดี
      await x.sources.steps.addSteps();
      await pumpEventQueue();
      expect(x.sources.steps.steps, 6400);
      final near = x.scheduler.scheduledLog.where((i) => i.message == M.walkNearGoal);
      expect(near.map((i) => i.scheduledAt), [t(today, 13)]);
      // วางแผนซ้ำหลังส่งแล้ว → ไม่ตั้งอีก
      now = t(today, 14);
      await x.sources.steps.addSteps(); // 7,400 = 92.5%
      await pumpEventQueue();
      expect(x.scheduler.scheduledLog.where((i) => i.message == M.walkNearGoal),
          hasLength(1));
      expect(x.mem.state.walkNearGoalSentToday, isTrue);
    });

    test('DECIDED_D3_tracking_locked_user_gets_no_walk_message', () async {
      final x = h(state: grantedOn, tracking: StepsTrackingStatus.permissionDenied);
      await x.controller.start();
      expect(x.scheduler.scheduledLog.where((i) => i.topic == NotificationTopic.walk),
          isEmpty);
      expect(x.scheduler.scheduledLog, isNotEmpty);
    });

    test('AC17_waterFirst_not_rescheduled_after_sent_in_same_cycle', () async {
      now = t(today, 8);
      final x = h(state: grantedOn, cups: 3, waterAt: t(today, 8),
          tracking: StepsTrackingStatus.permissionDenied, kcal: 2000);
      await x.controller.start();
      for (final m in [10, 30, 50]) {
        now = t(today, 10, m);
        await x.controller.onAppResumed();
      }
      expect(x.scheduler.scheduledLog.where((i) => i.message == M.waterFirst),
          hasLength(1));
    });

    test('AC28_EC15_never_more_than_6_for_the_day_and_stored_count_6', () async {
      final x = h(state: grantedOn);
      await x.controller.start();
      expect(x.scheduler.active.length, docCap);
      for (final hh in [9, 11, 13, 16, 19, 22]) {
        now = t(today, hh);
        await x.controller.onAppResumed();
        expect(x.scheduler.active.length, lessThanOrEqualTo(docCap));
      }
      expect(x.scheduler.scheduledLog.map((i) => i.id).toSet().length, docCap);
      expect(x.mem.state.sentNotificationCount, docCap);
      expect(x.mem.state.lastNotificationTimestamp, t(today, 18));
    });

    test('EC14_open_app_new_day_plans_today_T18', () async {
      final old = planOf(d(today - 2), [sentItem(M.foodNight, t(today - 2, 21))]);
      now = t(today, 14);
      final x = h(
          state: NotificationState(
              consentStatus: NotificationConsentStatus.allowed,
              masterSwitch: true,
              systemPermission: NotificationSystemPermission.granted,
              sentNotificationCount: 1,
              dayPlan: old));
      await x.controller.start();
      expect(x.controller.plan!.day, d(today));
      expect(slotsOf(x.scheduler.scheduledLog), [
        (M.foodUnlogged, t(today, 14)),
        (M.waterSecond, t(today, 14, 30)),
        (M.foodUnlogged, t(today, 15)),
        (M.walkInactive, t(today, 15, 30)),
        (M.foodUnlogged, t(today, 18)),
        (M.foodNight, t(today, 21)),
      ]);
    });

    test('R2_BUG1_replan_1400_1405_1610_no_extra_schedule_or_cancel', () async {
      now = t(today, 14);
      final x = h(state: grantedOn);
      await x.controller.start();
      final t18 = [
        (M.foodUnlogged, t(today, 14)),
        (M.waterSecond, t(today, 14, 30)),
        (M.foodUnlogged, t(today, 15)),
        (M.walkInactive, t(today, 15, 30)),
        (M.foodUnlogged, t(today, 18)),
        (M.foodNight, t(today, 21)),
      ];
      expect(slotsOf(x.scheduler.scheduledLog), t18);
      expect(x.scheduler.cancelledLog, isEmpty);
      for (final at in [t(today, 14), t(today, 14, 5), t(today, 16, 10)]) {
        now = at;
        await x.controller.onAppResumed();
        await pumpEventQueue();
        expect(slotsOf(x.scheduler.scheduledLog), t18, reason: 'schedule เพิ่มที่ $at');
        expect(x.scheduler.cancelledLog, isEmpty, reason: 'cancel ที่ $at');
      }
    });

    for (final start in [t(today, 14), t(today, 21)]) {
      test('R3_BUG1_INVARIANT_controller_resume_every_5min_no_extra_calls_from_${start.hour}',
          () async {
        now = start;
        final x = h(state: grantedOn);
        await x.controller.start();
        final first = [...x.scheduler.scheduledLog];
        expect(first, isNotEmpty);
        expect(x.scheduler.cancelledLog, isEmpty);
        final end = t(today + 1, 4, 55);
        var n = 0;
        for (var at = start.add(const Duration(minutes: 5));
            !at.isAfter(end);
            at = at.add(const Duration(minutes: 5))) {
          now = at;
          await x.controller.onAppResumed();
          n++;
        }
        await pumpEventQueue();
        expect(n, greaterThan(90));
        expect(x.scheduler.scheduledLog, first, reason: 'ไม่มี schedule เพิ่ม');
        expect(x.scheduler.cancelledLog, isEmpty, reason: 'ไม่มี cancel');
        expect(x.scheduler.cancelAllCount, 0);
      });
    }

    test('DECIDED_R2_first_open_2100_schedules_only_foodNight', () async {
      now = t(today, 21);
      final x = h(
          state: grantedOn,
          cups: 8,
          waterAt: t(today, 20),
          tracking: StepsTrackingStatus.permissionDenied);
      await x.controller.start();
      expect(slotsOf(x.scheduler.scheduledLog), [(M.foodNight, t(today, 21))]);
    });

    test('AC35_EC8_day_tick_0500_resets_count_and_near_goal', () async {
      final six = [
        sentItem(M.walkNearGoal, t(today, 6), anchor: t(today, 6)),
        for (var k = 1; k < 6; k++)
          sentItem(M.walkInactive, t(today, 6 + k), anchor: t(today, k)),
      ];
      now = t(today + 1, 4, 59, 59);
      final x = h(
          state: NotificationState(
              consentStatus: NotificationConsentStatus.allowed,
              masterSwitch: true,
              systemPermission: NotificationSystemPermission.granted,
              dayPlan: planOf(d(today), six)));
      await x.controller.start();
      expect(x.timers.lastInterval, NotificationRules.dayCheckInterval);
      expect(x.mem.state.sentNotificationCount, docCap);
      expect(x.mem.state.walkNearGoalSentToday, isTrue);
      expect(x.scheduler.scheduledLog, isEmpty, reason: 'ชนเพดานแล้ว');
      x.timers.tick(); // 04:59:59 ยังรอบวันเดิม
      await pumpEventQueue();
      expect(x.controller.plan!.day, d(today));
      now = t(today + 1, 5);
      x.timers.tick();
      await pumpEventQueue();
      expect(x.controller.plan!.day, d(today + 1));
      expect(x.mem.state.sentNotificationCount, 0);
      expect(x.mem.state.walkNearGoalSentToday, isFalse);
      expect(x.mem.state.lastNotificationTimestamp, isNull);
      expect(x.scheduler.pendingAt(now), isNotEmpty, reason: 'วางแผนวันใหม่');
      expect(
          x.scheduler.pendingAt(now).every(
              (i) => NotificationLogic.logicalDay(i.scheduledAt) == d(today + 1)),
          isTrue);
    });

    test('EDGE_start_twice_one_timer_no_duplicate_schedule_stop_cancels', () async {
      final x = h(state: grantedOn);
      await x.controller.start();
      await x.controller.start();
      expect(x.timers.activeCount, 1);
      expect(x.scheduler.scheduledLog.length, docCap);
      x.controller.stop();
      expect(x.timers.activeCount, 0);
      final before = x.scheduler.scheduledLog.length;
      now = t(today, 9);
      await x.sources.water.logWater();
      await pumpEventQueue();
      expect(x.scheduler.scheduledLog.length, before,
          reason: 'ถอด listener แล้ว');
      x.controller.dispose();
    });
  });

  // =========================================================================
  // Q-28 ออกจากระบบ (DECIDED owner 2026-11-08)
  // =========================================================================
  group('Q-28 logout', () {
    test('DECIDED_Q28_logout_cancelAll_clears_plan_keeps_consent_switch', () async {
      final x = h(state: grantedOn);
      await x.controller.start();
      expect(x.scheduler.active.length, docCap);
      final signup = SignupController(
          repository:
              FakeAuthRepository(registeredAccounts: {'a@b.com': 'secret1'}));
      await signup.load();
      await signup.signInWithEmail('a@b.com', 'secret1');
      signup.onSignedOut = x.controller.onSignedOut; // แบบ main.dart
      now = t(today, 18, 30);
      await signup.signOut();
      expect(x.scheduler.cancelAllCount, 1);
      expect(x.scheduler.active, isEmpty);
      expect(x.controller.plan, isNull);
      expect(x.mem.state.dayPlan, isNull);
      expect(x.mem.state.consentStatus, NotificationConsentStatus.allowed);
      expect(x.mem.state.masterSwitch, isTrue);
      expect(x.mem.state.systemPermission, NotificationSystemPermission.granted);
      // ระหว่างออกจากระบบ: ข้อมูลเปลี่ยนก็ไม่ตั้งเวลา
      final before = x.scheduler.scheduledLog.length;
      await x.sources.water.logWater();
      await x.controller.onAppResumed();
      await pumpEventQueue();
      expect(x.scheduler.scheduledLog.length, before);
    });

    test('DECIDED_Q28_relogin_same_day_new_plan_up_to_6_more', () async {
      final x = h(state: grantedOn);
      await x.controller.start();
      now = t(today, 18, 30); // 6 ข้อความของ T-1 ส่งแล้วทั้งหมด
      await x.controller.onAppResumed();
      expect(x.mem.state.sentNotificationCount, docCap);
      await x.controller.onSignedOut();
      await x.controller.start(); // เข้า Home ใหม่
      final pend = x.scheduler.pendingAt(now);
      expect(pend, isNotEmpty, reason: 'ยอมรับ: ได้เพิ่มหลังเข้าระบบใหม่');
      expect(x.controller.plan!.items.length, lessThanOrEqualTo(docCap));
    });
  });

  // =========================================================================
  // Storage (game-rules §1.2, ui-spec §2.5)
  // =========================================================================
  group('storage', () {
    test('EDGE_first_open_empty_prefs_defaults', () async {
      SharedPreferences.setMockInitialValues({});
      final s = await SharedPrefsNotificationRepository().load();
      expect(s.consentStatus, NotificationConsentStatus.unanswered);
      expect(s.masterSwitch, isFalse);
      expect(s.systemPermission, NotificationSystemPermission.notDetermined);
      expect(s.sentNotificationCount, 0);
      expect(s.lastNotificationTimestamp, isNull);
      expect(s.walkNearGoalSentToday, isFalse);
      expect(s.lastStepsIncreasedTimestamp, isNull);
      expect(s.dayPlan, isNull);
    });

    test('EDGE_corrupt_prefs_wrong_types_fall_back_to_defaults', () async {
      SharedPreferences.setMockInitialValues({
        'consent_status': 5,
        'notification_master_switch': true,
        'system_permission_status': 'MAYBE',
        'sent_notification_count': 'six',
        'last_notification_timestamp': 'not a date',
        'walk_near_goal_sent_today': 'YES',
        'notification_day_plan': '{broken',
      });
      final s = await SharedPrefsNotificationRepository().load();
      expect(s.consentStatus, NotificationConsentStatus.unanswered);
      expect(s.masterSwitch, isFalse);
      expect(s.systemPermission, NotificationSystemPermission.notDetermined);
      expect(s.sentNotificationCount, 0);
      expect(s.lastNotificationTimestamp, isNull);
      expect(s.walkNearGoalSentToday, isFalse);
      expect(s.dayPlan, isNull);
    });

    test('GR12_storage_keys_and_codes_match_game_rules', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = SharedPrefsNotificationRepository();
      final x = h(repo: repo);
      await x.controller.start();
      await x.controller.answerConsent(allowed: true);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('consent_status'), 'ALLOWED');
      expect(prefs.getString('notification_master_switch'), 'ON');
      expect(prefs.getString('system_permission_status'), 'GRANTED');
      expect(prefs.getInt('sent_notification_count'), 0);
      expect(prefs.getBool('walk_near_goal_sent_today'), isFalse);
      expect(prefs.containsKey('last_notification_timestamp'), isFalse);
      expect(prefs.getString('notification_day_plan'), isNotNull);
      // อ่านกลับด้วย controller ตัวใหม่ (เปิดแอปครั้งที่ 2)
      final back = await SharedPrefsNotificationRepository().load();
      expect(back.consentStatus, NotificationConsentStatus.allowed);
      expect(back.masterSwitch, isTrue);
      expect(back.dayPlan!.items.length, docCap);
    });
  });
}
