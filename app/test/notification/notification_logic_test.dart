// Unit tests: logic เกมของฟีเจอร์แจ้งเตือน (NotificationLogic — pure, ส่ง now เข้าไปเอง)
// ค่าคาดหวังจาก game-rules.md §1/§3/§4, requirements.md AC/EC และตาราง T-1..T-18 ของ
// ui-spec.md §2.4.4 · ข้อตัดสิน owner (DECIDED 2026-11-08) ชื่อเทสต์มี DECIDED_
// D-6: ตรวจ "เวลาที่ตั้ง" (scheduledAt) ไม่ใช่เวลาที่ OS ยิงจริง
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/notification/notification_logic.dart';
import 'package:petpal_health/features/notification/notification_models.dart';
import 'package:petpal_health/features/notification/notification_repository.dart';
import 'package:petpal_health/features/notification/notification_rules.dart';

import 'notification_test_helpers.dart';

typedef M = NotificationMessage;

NotificationDayPlan build(NotificationInputs i, DateTime now,
        [NotificationDayPlan? previous]) =>
    NotificationLogic.buildPlan(i, previous, now);

/// ตรวจ invariant ของ game-rules §1 ทุกแผน: ไม่อยู่ในช่วงห้ามเตือน, ห่าง ≥ 30:00, ≤ 6
void expectInvariants(NotificationDayPlan p) {
  final items = [...p.items]..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  expect(items.length, lessThanOrEqualTo(docCap), reason: '$items');
  final day = p.day;
  for (final i in items) {
    expect(i.scheduledAt.isBefore(DateTime(day.year, day.month, day.day, docActiveHour)),
        isFalse, reason: 'ก่อน 06:00:00 $i');
    expect(
        i.scheduledAt
            .isBefore(DateTime(day.year, day.month, day.day, docQuietStartHour)),
        isTrue,
        reason: 'ถึง 23:00:00 $i');
    expect(i.scheduledAt.isBefore(i.dueAt), isFalse, reason: 'ก่อนครบกำหนด $i');
  }
  for (var k = 1; k < items.length; k++) {
    expect(
        items[k].scheduledAt.difference(items[k - 1].scheduledAt) >=
            const Duration(minutes: docIntervalMinutes),
        isTrue,
        reason: 'ห่าง < 30:00 ${items[k - 1]} → ${items[k]}');
  }
}

void main() {
  // =========================================================================
  // ค่าคงที่ (game-rules §1) + ข้อความตรงตัว (ux-flow §2 S-3)
  // =========================================================================
  group('GR ค่าหลักและข้อความ', () {
    test('GR1_constants_match_game_rules', () {
      expect(NotificationRules.dailyResetHour, docResetHour);
      expect(NotificationRules.dailyResetMinute, 0);
      expect(
          [
            NotificationRules.quietHoursStartHour,
            NotificationRules.quietHoursStartMinute,
            NotificationRules.quietHoursStartSecond
          ],
          [docQuietStartHour, 0, 0]);
      expect(
          [
            NotificationRules.quietHoursEndHour,
            NotificationRules.quietHoursEndMinute,
            NotificationRules.quietHoursEndSecond
          ],
          docQuietEnd);
      expect(
          [
            NotificationRules.activeHoursStartHour,
            NotificationRules.activeHoursStartMinute,
            NotificationRules.activeHoursStartSecond
          ],
          [docActiveHour, 0, 0]);
      expect(NotificationRules.dailyNotificationCap, docCap);
      expect(NotificationRules.minNotificationIntervalMinutes, docIntervalMinutes);
      expect(NotificationRules.walkInactivityHours, docWalkHours);
      expect(NotificationRules.walkMaxDelayMinutes, docWalkMaxDelayMinutes);
      expect(NotificationRules.walkNearGoalMinPercent, docNearGoalMin);
      expect(NotificationRules.walkNearGoalMaxExclusivePercent,
          docNearGoalMaxExclusive);
      expect(NotificationRules.waterInactivityFirstHours, docWaterFirstHours);
      expect(NotificationRules.waterInactivitySecondHours, docWaterSecondHours);
      expect(NotificationRules.waterDailyGoalGlasses, docWaterGoal);
      expect(NotificationRules.foodUnloggedHours, docFoodHours);
      expect(NotificationRules.foodNightReminderHour, docFoodNightHour);
    });

    test('UX_S3_six_message_texts_exact_and_topics', () {
      expect(M.walkInactive.text, walkInactiveDoc);
      expect(M.walkNearGoal.text, walkNearGoalDoc);
      expect(M.waterFirst.text, waterFirstDoc);
      expect(M.waterSecond.text, waterSecondDoc);
      expect(M.foodUnlogged.text, foodUnloggedDoc);
      expect(M.foodNight.text, foodNightDoc);
      expect([for (final m in M.values) m.topic], [
        NotificationTopic.walk,
        NotificationTopic.walk,
        NotificationTopic.water,
        NotificationTopic.water,
        NotificationTopic.food,
        NotificationTopic.food,
      ]);
      expect(NotificationRules.senderName, senderNameDoc);
    });

    test('AC31_priority_food_gt_water_gt_walk', () {
      expect(NotificationTopic.food.priority,
          greaterThan(NotificationTopic.water.priority));
      expect(NotificationTopic.water.priority,
          greaterThan(NotificationTopic.walk.priority));
    });

    test('DECIDED_D3_AC15_EC12_no_manual_move_message_text_or_key', () {
      expect(M.values.length, 6);
      expect(M.values.map((m) => m.text), isNot(contains(walkManualDoc)));
      expect(NotificationStorageKeys.all,
          isNot(contains('last_manual_move_timestamp')));
      final dir = Directory('lib/features/notification');
      for (final f in dir.listSync(recursive: true).whereType<File>()) {
        final src = f.readAsStringSync();
        expect(src.contains(walkManualDoc), isFalse, reason: f.path);
        // ตรวจเฉพาะ string literal (คอมเมนต์อธิบาย D-3 อ้างชื่อ key ได้)
        expect(src.contains("'last_manual_move_timestamp'"), isFalse,
            reason: f.path);
      }
    });
  });

  // =========================================================================
  // T-1 .. T-18 (ui-spec §2.4.4)
  // =========================================================================
  group('T-1..T-18 ตารางจัดคิว', () {
    test('T1_new_day_0530_no_data_full_plan_six_no_foodNight', () {
      final now = t(today, 5, 30);
      final p = build(
          inp(water: 0, steps: 0, goal: 8000, locked: false, kcal: 0, target: 2000),
          now);
      expect(allSlots(p), [
        (M.waterFirst, t(today, 8)),
        (M.waterSecond, t(today, 10)),
        (M.walkInactive, t(today, 10, 30)),
        (M.foodUnlogged, t(today, 12)),
        (M.foodUnlogged, t(today, 15)),
        (M.foodUnlogged, t(today, 18)),
      ]);
      expect(slotsOfMessage(p, M.foodNight), isEmpty);
      expectInvariants(p);
    });

    test('T2_water_last_0800_three_cups_first_1000_second_1200', () {
      final now = t(today, 8);
      final p = build(inp(water: 3, waterAt: t(today, 8)), now);
      expect(allSlots(p), [
        (M.waterFirst, t(today, 10)),
        (M.waterSecond, t(today, 12)),
      ]);
    });

    test('T3_AC27_water_2230_yesterday_now_0510_first_0800_anchor_0600', () {
      final now = t(today, 5, 10);
      final i = NotificationLogic.inputsFor(
        now: now,
        waterCups: 5,
        waterLastLoggedAt: t(today - 1, 22, 30),
        steps: 0,
        stepsDay: d(today),
        stepsGoal: 10000,
        isTrackingLocked: true,
        lastStepsIncreasedAt: null,
        totalCalories: 2000,
        foodDay: d(today),
        targetCalories: 2000,
      );
      expect(i.waterCount, 0, reason: 'ค่าเมื่อวานถือเป็น 0 ของรอบวันใหม่');
      expect(i.waterLastLoggedAt, isNull);
      final p = build(i, now);
      final first = p.items.firstWhere((x) => x.message == M.waterFirst);
      expect(first.anchor, t(today, 6));
      expect(first.scheduledAt, t(today, 8));
    });

    test('T4_AC9_steps_increase_0800_walkInactive_1200', () {
      final now = t(today, 8);
      final p = build(
          inp(locked: false, steps: 1000, stepsAt: t(today, 8)), now);
      expect(allSlots(p), [(M.walkInactive, t(today, 12))]);
    });

    test('T5_AC29_AC30_gap_2959_delayed_to_3000', () {
      final committed = sentItem(M.foodUnlogged, t(today, 12));
      // ผู้สมัคร dueAt 12:29:59 → เลื่อนเป็น 12:30:00
      final c1 = sentItem(M.waterFirst, t(today, 12, 29, 59),
          anchor: t(today, 10, 29, 59));
      expect(
          slotsOf(NotificationLogic.schedule([c1],
              day: d(today), now: t(today, 12), committed: [committed])),
          [(M.waterFirst, t(today, 12, 30))]);
      // dueAt 12:30:00 พอดี → ส่งได้ที่ 12:30:00
      final c2 = sentItem(M.waterFirst, t(today, 12, 30), anchor: t(today, 10, 30));
      expect(
          slotsOf(NotificationLogic.schedule([c2],
              day: d(today), now: t(today, 12), committed: [committed])),
          [(M.waterFirst, t(today, 12, 30))]);
      // ผ่าน buildPlan: น้ำล่าสุด 10:29:59 → waterFirst ครบ 12:29:59 แต่ถูกเลื่อนเป็น 12:30:00
      final p = build(inp(water: 3, waterAt: t(today, 10, 29, 59)), t(today, 12),
          planOf(d(today), [committed]));
      expect(slotsOfMessage(p, M.waterFirst), [(M.waterFirst, t(today, 12, 30))]);
    });

    test('T6_AC31_EC5_food_and_water_due_1200_food_first_water_1230', () {
      final p = build(
          inp(water: 3, waterAt: t(today, 10), kcal: 0, target: 2000), t(today, 11));
      final s = allSlots(p);
      expect(s.take(2).toList(), [
        (M.foodUnlogged, t(today, 12)),
        (M.waterFirst, t(today, 12, 30)),
      ]);
      expectInvariants(p);
    });

    test('T7_AC26_EC7_single_candidate_225959_sent_230000_not', () {
      final ok = build(inp(water: 3, waterAt: t(today, 20, 59, 59)), t(today, 21));
      expect(allSlots(ok), [(M.waterFirst, t(today, 22, 59, 59))]);
      final no = build(inp(water: 3, waterAt: t(today, 21)), t(today, 21));
      expect(allSlots(no), isEmpty);
      // เดิน: ก้าวล่าสุด 18:59:59 / 19:00:00
      expect(
          allSlots(build(inp(locked: false, steps: 100, stepsAt: t(today, 18, 59, 59)),
              t(today, 19))),
          [(M.walkInactive, t(today, 22, 59, 59))]);
      expect(
          allSlots(build(
              inp(locked: false, steps: 100, stepsAt: t(today, 19)), t(today, 19))),
          isEmpty);
    });

    test('T8_AC33_delayed_until_230000_cancelled', () {
      final c = sentItem(M.waterFirst, t(today, 22, 40), anchor: t(today, 20, 40));
      // committed 22:30:00 → t = 23:00:00 → ไม่มีรายการ
      expect(
          NotificationLogic.schedule([c],
              day: d(today),
              now: t(today, 22, 30),
              committed: [sentItem(M.foodNight, t(today, 22, 30))]),
          isEmpty);
      // ขอบ: committed 22:29:59 → t = 22:59:59 ส่งได้
      expect(
          slotsOf(NotificationLogic.schedule([c],
              day: d(today),
              now: t(today, 22, 29, 59),
              committed: [sentItem(M.foodNight, t(today, 22, 29, 59))])),
          [(M.waterFirst, t(today, 22, 59, 59))]);
    });

    test('T9_AC28_six_committed_no_pending_five_committed_one_more', () {
      final six = [
        for (var k = 0; k < 6; k++)
          sentItem(M.walkInactive, t(today, 6 + k), anchor: t(today, 2 + k)),
      ];
      final now = t(today, 11, 30);
      final p6 = build(inp(kcal: 0, water: 0, locked: false), now, planOf(d(today), six));
      expect(NotificationLogic.pending(p6, now), isEmpty);
      expect(NotificationLogic.sentCount(p6, now), docCap);
      // ขอบ: ส่งไป 5 → ได้อีก 1 พอดี (รวม 6)
      final p5 = build(inp(kcal: 0, water: 0, locked: false), now,
          planOf(d(today), six.take(5).toList()));
      // รายการใหม่ที่ scheduledAt == now ถือว่าส่งแล้ว (dev log สมมติฐาน 7) → นับจาก items
      expect(p5.items.where((i) => !six.take(5).contains(i)).length, 1);
      expect(p5.items.length, docCap);
    });

    test('T10_AC10_AC11_AC12_AC13_near_goal_7999_8000_9999_10000', () {
      final now = t(today, 13);
      List<Slot> near(int steps) => slotsOfMessage(
          build(inp(locked: false, steps: steps, goal: 10000, stepsAt: now), now),
          M.walkNearGoal);
      expect(near(7999), isEmpty, reason: '79.99% ไม่ส่ง');
      expect(near(8000), [(M.walkNearGoal, t(today, 13))], reason: '80.00% ส่ง');
      expect(near(9999), [(M.walkNearGoal, t(today, 13))], reason: '99.99% ส่ง');
      expect(near(10000), isEmpty, reason: '100.00% ไม่ส่ง');
      // ส่งแล้ววันนี้ → ไม่มีอีก (วันละ 1 ครั้ง)
      final sent = planOf(d(today), [
        sentItem(M.walkNearGoal, t(today, 13), anchor: t(today, 6)),
      ]);
      final later = build(
          inp(locked: false, steps: 9000, goal: 10000, stepsAt: t(today, 14)),
          t(today, 14),
          sent);
      expect(slotsOfMessage(later, M.walkNearGoal), [(M.walkNearGoal, t(today, 13))],
          reason: 'มีเฉพาะรายการที่ส่งแล้ว');
      expect(NotificationLogic.walkNearGoalSentToday(later, t(today, 14)), isTrue);
    });

    test('T10_isNearGoal_integer_boundaries', () {
      expect(NotificationLogic.isNearGoal(7999, 10000), isFalse);
      expect(NotificationLogic.isNearGoal(8000, 10000), isTrue);
      expect(NotificationLogic.isNearGoal(9999, 10000), isTrue);
      expect(NotificationLogic.isNearGoal(10000, 10000), isFalse);
      // เป้า 8,000: 6,400 = 80.00% พอดี / 6,399 = 79.99%
      expect(NotificationLogic.isNearGoal(6399, 8000), isFalse);
      expect(NotificationLogic.isNearGoal(6400, 8000), isTrue);
      expect(NotificationLogic.isNearGoal(7999, 8000), isTrue);
      expect(NotificationLogic.isNearGoal(8000, 8000), isFalse);
    });

    test('T11_AC14_EC11_jump_7000_to_10000_no_near_goal', () {
      final p1 = build(
          inp(locked: false, steps: 7000, goal: 10000, stepsAt: t(today, 12)),
          t(today, 12));
      expect(slotsOfMessage(p1, M.walkNearGoal), isEmpty);
      final p2 = build(
          inp(locked: false, steps: 10000, goal: 10000, stepsAt: t(today, 12, 30)),
          t(today, 12, 30),
          p1);
      expect(slotsOfMessage(p2, M.walkNearGoal), isEmpty);
    });

    test('T12_DECIDED_D3_tracking_locked_no_walk_messages', () {
      final now = t(today, 5, 30);
      final p = build(
          inp(locked: true, steps: 8500, goal: 10000, water: 0, kcal: 0), now);
      expect(p.items.where((i) => i.topic == NotificationTopic.walk), isEmpty);
      expect(p.items, isNotEmpty, reason: 'น้ำ/อาหารยังมี');
    });

    test('T13_AC19_EC4_water_7_has_8_and_12_none', () {
      final now = t(today, 8);
      List<Slot> water(int cups) => allSlots(build(
              inp(water: cups, waterAt: t(today, 7, 30)), now))
          .where((s) => s.$1.topic == NotificationTopic.water)
          .toList();
      expect(water(7), [
        (M.waterFirst, t(today, 9, 30)),
        (M.waterSecond, t(today, 11, 30)),
      ]);
      expect(water(8), isEmpty, reason: '>= 8 แก้ว หยุดเรื่องน้ำ');
      expect(water(12), isEmpty, reason: 'EC-4 12 แก้ว');
    });

    test('T13_AC19_water_7_to_8_cancels_pending_water', () {
      final p1 = build(inp(water: 7, waterAt: t(today, 7, 30)), t(today, 8));
      expect(NotificationLogic.pending(p1, t(today, 8)), hasLength(2));
      final p2 = build(inp(water: 8, waterAt: t(today, 8, 5)), t(today, 8, 5), p1);
      expect(NotificationLogic.pending(p2, t(today, 8, 5)), isEmpty);
    });

    test('T14_AC20_AC21_food_1200_committed_then_500kcal_1230_cancels_15_18', () {
      final p1 = build(inp(kcal: 0, target: 2000), t(today, 11));
      expect(slotsOfMessage(p1, M.foodUnlogged), [
        (M.foodUnlogged, t(today, 12)),
        (M.foodUnlogged, t(today, 15)),
        (M.foodUnlogged, t(today, 18)),
      ]);
      final now = t(today, 12, 30);
      final p2 = build(inp(kcal: 500, target: 2000), now, p1);
      expect(slotsOfMessage(p2, M.foodUnlogged), [(M.foodUnlogged, t(today, 12))]);
      expect(NotificationLogic.committed(p2, now).map((i) => i.message),
          [M.foodUnlogged]);
    });

    test('T15_AC22_AC23_AC24_AC25_food_night_2100', () {
      final now = t(today, 20);
      List<Slot> night(int kcal, {bool noTarget = false}) => slotsOfMessage(
          build(inp(kcal: kcal, target: 2000, noTarget: noTarget), now),
          M.foodNight);
      expect(night(1500), [(M.foodNight, t(today, 21))], reason: 'AC-22');
      expect(night(2000), isEmpty, reason: 'AC-24 ถึงเป้า');
      expect(night(1999), [(M.foodNight, t(today, 21))], reason: 'ขอบ < เป้า');
      expect(night(0, noTarget: true), [(M.foodNight, t(today, 21))], reason: 'AC-23');
      expect(night(350, noTarget: true), isEmpty, reason: 'AC-25');
    });

    test('T16_EC3_DECIDED_D4_goal_0_or_negative_steps_no_walk_all_day', () {
      final now = t(today, 8);
      final p1 = build(
          inp(locked: false, goal: 0, water: 0, kcal: 0, stepsAt: now), now);
      expect(p1.items.where((i) => i.topic == NotificationTopic.walk), isEmpty);
      expect(p1.items.where((i) => i.topic == NotificationTopic.water), isNotEmpty);
      expect(p1.items.where((i) => i.topic == NotificationTopic.food), isNotEmpty);
      expect(p1.suppressedTopics, contains(NotificationTopic.walk));
      // ค่ากลับมาถูกแล้วก็ไม่มี (Q-20 ระงับทั้งรอบวัน)
      final p2 = build(
          inp(locked: false, goal: 10000, steps: 8500, water: 0, kcal: 0,
              stepsAt: t(today, 9)),
          t(today, 9),
          p1);
      expect(p2.items.where((i) => i.topic == NotificationTopic.walk), isEmpty);
      // current_steps < 0
      final p3 = build(
          inp(locked: false, steps: -1, water: 0, kcal: 0, stepsAt: now), now);
      expect(p3.items.where((i) => i.topic == NotificationTopic.walk), isEmpty);
      // รอบวันถัดไป → กลับมาส่งได้
      final next = build(inp(locked: false, steps: 100, stepsAt: t(today + 1, 8)),
          t(today + 1, 8), p2);
      expect(next.items.where((i) => i.topic == NotificationTopic.walk), isNotEmpty);
    });

    test('T16_EC3_negative_water_or_calories_suppress_that_topic', () {
      final now = t(today, 5, 30);
      final pw = build(inp(water: -1, kcal: 0, locked: false), now);
      expect(pw.items.where((i) => i.topic == NotificationTopic.water), isEmpty);
      expect(pw.items.where((i) => i.topic == NotificationTopic.food), isNotEmpty);
      final pf = build(inp(water: 0, kcal: -5, locked: true), now);
      expect(pf.items.where((i) => i.topic == NotificationTopic.food), isEmpty);
      expect(pf.items.where((i) => i.topic == NotificationTopic.water), isNotEmpty);
    });

    test('T17_AC34_EC6_water_log_new_anchor_new_id_old_removed', () {
      final p1 = build(inp(water: 3, waterAt: t(today, 8)), t(today, 8));
      final old = p1.items.firstWhere((i) => i.message == M.waterFirst);
      final p2 = build(inp(water: 4, waterAt: t(today, 9)), t(today, 9), p1);
      final neo = p2.items.firstWhere((i) => i.message == M.waterFirst);
      expect(neo.scheduledAt, t(today, 11));
      expect(neo.anchor, t(today, 9));
      expect(neo.id, isNot(old.id));
      expect(p2.items.map((i) => i.id), isNot(contains(old.id)));
    });

    test('T18_EC14_Q06_first_open_1400_no_data', () {
      final now = t(today, 14);
      final p = build(
          inp(water: 0, steps: 0, goal: 8000, locked: false, kcal: 0, target: 2000),
          now);
      expect(allSlots(p), [
        (M.foodUnlogged, t(today, 14)),
        (M.waterSecond, t(today, 14, 30)),
        (M.foodUnlogged, t(today, 15)),
        (M.walkInactive, t(today, 15, 30)),
        (M.foodUnlogged, t(today, 18)),
        (M.foodNight, t(today, 21)),
      ]);
      expect(slotsOfMessage(p, M.waterFirst), isEmpty, reason: 'Q-06 ตัดขั้นที่เลยเวลา');
      expectInvariants(p);
    });
  });

  group('T-18 วางแผนซ้ำ (แอปวางแผนใหม่ทุกครั้งที่ข้อมูลเปลี่ยน / resume — D-5)', () {
    final t18 = [
      (M.foodUnlogged, t(today, 14)),
      (M.waterSecond, t(today, 14, 30)),
      (M.foodUnlogged, t(today, 15)),
      (M.walkInactive, t(today, 15, 30)),
      (M.foodUnlogged, t(today, 18)),
      (M.foodNight, t(today, 21)),
    ];
    NotificationInputs noData() =>
        inp(water: 0, steps: 0, goal: 8000, locked: false, kcal: 0, target: 2000);

    test('T18_Q06_replan_same_minute_keeps_T18_plan', () {
      final p1 = build(noData(), t(today, 14));
      expect(allSlots(p1), t18);
      final p2 = build(noData(), t(today, 14), p1);
      expect(allSlots(p2), t18, reason: 'ขั้น waterFirst ที่ถูกตัด (Q-06) ต้องไม่กลับมา');
    });

    test('T18_R2_BUG1_replan_later_1610_after_some_sent_keeps_T18_plan', () {
      final p1 = build(noData(), t(today, 14));
      final p2 = build(noData(), t(today, 14, 5), p1);
      final p3 = build(noData(), t(today, 16, 10), p2);
      expect(allSlots(p3), t18, reason: 'waterFirst ต้องไม่กลับมาหลัง waterSecond ส่งแล้ว');
      expect(slotsOfMessage(p3, M.waterFirst), isEmpty);
      expectInvariants(p3);
    });

    test('T18_R2_BUG1_replan_after_every_slot_keeps_T18_plan', () {
      var p = build(noData(), t(today, 14));
      for (final at in [
        t(today, 14, 31), t(today, 15, 1), t(today, 15, 31), t(today, 16, 10),
        t(today, 18, 1), t(today, 20), t(today, 21, 1), t(today, 22, 59),
      ]) {
        p = build(noData(), at, p);
        expect(allSlots(p), t18, reason: 'at $at');
      }
    });

    test('Q06_R2_deferred_waterFirst_dropped_when_waterSecond_overdue', () {
      // ผลข้างเคียงที่ Dev จดไว้ (รอบ 3): waterFirst ถูกเลื่อน (pending 10:30) แต่ขั้นถัดไปของสาย
      // (waterSecond ครบ 10:00) เลยเวลาแล้ว → Q-06 เก็บเฉพาะขั้นล่าสุดที่เลยเวลา = waterSecond
      final deferred = PlannedNotification(
        id: NotificationLogic.notificationId(d(today), M.waterFirst, t(today, 6)),
        message: M.waterFirst,
        anchor: t(today, 6),
        dueAt: t(today, 8),
        scheduledAt: t(today, 10, 30),
      );
      final prev = planOf(d(today), [deferred]);
      final now = t(today, 10, 15);
      final p = build(inp(water: 0), now, prev);
      expect(allSlots(p), [(M.waterSecond, t(today, 10, 15))]);
      // แผนนี้วางซ้ำแล้วคงเดิม
      expect(allSlots(build(inp(water: 0), t(today, 10, 20), p)),
          [(M.waterSecond, t(today, 10, 15))]);
    });

    test('T18_Q06_replan_at_1405_keeps_T18_plan', () {
      final p1 = build(noData(), t(today, 14));
      final p2 = build(noData(), t(today, 14, 5), p1);
      expect(allSlots(p2), t18);
      expect(slotsOfMessage(p2, M.waterFirst), isEmpty);
    });
  });

  // =========================================================================
  // รอบ 3: invariant วางแผนซ้ำ (BUG-NOTI-1) + สาย Q-06 ตามเวลาคิว
  // =========================================================================
  group('R3 replan invariant + Q-06 chains', () {
    /// วางแผนแรกที่ [start] แล้ววางแผนซ้ำทุก 5 นาทีต่อจากแผนก่อนหน้า จนถึง 04:55 วันถัดไป
    int sweep(NotificationInputs i, DateTime start, [NotificationDayPlan? prev]) {
      final p0 = build(i, start, prev);
      var p = p0;
      var n = 0;
      final end = DateTime(start.year, start.month, start.day + 1, 4, 55);
      for (var at = start.add(const Duration(minutes: 5));
          !at.isAfter(end);
          at = at.add(const Duration(minutes: 5))) {
        p = build(i, at, p);
        expect(p.items, p0.items, reason: 'แผนเปลี่ยนที่ $at');
        n++;
      }
      return n;
    }

    NotificationInputs noData() =>
        inp(water: 0, steps: 0, goal: 8000, locked: false, kcal: 0, target: 2000);

    test('R3_BUG1_INVARIANT_T18_replan_every_5min_until_0455', () {
      expect(sweep(noData(), t(today, 14)), greaterThan(150));
    });

    test('R3_BUG1_INVARIANT_T1_mixed_2100_and_water_chain_scenarios', () {
      sweep(noData(), t(today, 5, 30)); // T-1
      sweep(inp(kcal: 0, target: 2000), t(today, 21)); // เปิดครั้งแรก 21:00
      sweep(inp(water: 3, waterAt: t(today, 10), locked: false, steps: 100,
          stepsAt: t(today, 8), kcal: 0), t(today, 11)); // มีการเลื่อน
      // สายน้ำเลยเวลา 10:15 (waterFirst ถูกเลื่อนค้าง 10:30)
      final deferred = PlannedNotification(
        id: NotificationLogic.notificationId(d(today), M.waterFirst, t(today, 6)),
        message: M.waterFirst,
        anchor: t(today, 6),
        dueAt: t(today, 8),
        scheduledAt: t(today, 10, 30),
      );
      sweep(inp(water: 0), t(today, 10, 15), planOf(d(today), [deferred]));
    });

    test('R3_AC16_AC18_new_water_log_starts_new_chain_waterFirst_again', () {
      // ส่ง waterSecond ของรอบนับ 06:00 แล้ว → บันทึกน้ำ 16:00 = รอบนับใหม่
      final sent = planOf(d(today), [
        sentItem(M.waterFirst, t(today, 8), anchor: t(today, 6)),
        sentItem(M.waterSecond, t(today, 10), anchor: t(today, 6)),
      ]);
      final p = build(inp(water: 1, waterAt: t(today, 16)), t(today, 16), sent);
      expect(pendingSlots(p, t(today, 16)), [
        (M.waterFirst, t(today, 18)),
        (M.waterSecond, t(today, 20)),
      ]);
      // ไม่บันทึกน้ำใหม่ → รอบนับเดิม ขั้นแรกไม่กลับมา
      final same = build(inp(water: 0), t(today, 16), sent);
      expect(pendingSlots(same, t(today, 16)), isEmpty);
    });

    test('R3_Q06_foodUnlogged12_deferred_to_1500_dropped_15_sent_boundary', () {
      final fu12 = sentItem(M.foodUnlogged, t(today, 12));
      final fu15 = sentItem(M.foodUnlogged, t(today, 15));
      // คิวเดินถึง 15:00:00 พอดี → ขั้น 12 ถูกแทนด้วยขั้น 15
      expect(
          slotsOf(NotificationLogic.schedule([fu12, fu15],
              day: d(today),
              now: t(today, 14, 30),
              committed: [sentItem(M.walkInactive, t(today, 14, 30))])),
          [(M.foodUnlogged, t(today, 15))]);
      // ขอบ: 14:59:59 ขั้น 12 ยังส่งได้ แล้วขั้น 15 ตามมา 30:00
      expect(
          slotsOf(NotificationLogic.schedule([fu12, fu15],
              day: d(today),
              now: t(today, 14, 29, 59),
              committed: [sentItem(M.walkInactive, t(today, 14, 29, 59))])),
          [(M.foodUnlogged, t(today, 14, 59, 59)), (M.foodUnlogged, t(today, 15, 29, 59))]);
    });

    test('R3_AC20_AC21_food_12_15_sent_replan_1600_only_18_then_log_cancels', () {
      final p0 = build(inp(kcal: 0), t(today, 11));
      expect(slotsOfMessage(p0, M.foodUnlogged).map((s) => s.$2),
          [t(today, 12), t(today, 15), t(today, 18)]);
      final p1 = build(inp(kcal: 0), t(today, 16), p0);
      expect(pendingSlots(p1, t(today, 16)).where((s) => s.$1 == M.foodUnlogged),
          [(M.foodUnlogged, t(today, 18))]);
      final p2 = build(inp(kcal: 400), t(today, 16, 30), p1);
      expect(pendingSlots(p2, t(today, 16, 30)).where((s) => s.$1 == M.foodUnlogged),
          isEmpty);
      expect(slotsOfMessage(p2, M.foodUnlogged).length, 2, reason: '12/15 ส่งแล้วคงอยู่');
    });
  });

  // =========================================================================
  // AC อื่น ๆ ที่เป็น logic
  // =========================================================================
  group('AC logic', () {
    test('AC9_no_steps_counts_from_0600_due_1000_exact_4h', () {
      final p = build(inp(locked: false, steps: 0), t(today, 6));
      expect(allSlots(p), [(M.walkInactive, t(today, 10))]);
      final p2 = build(inp(locked: false, steps: 10, stepsAt: t(today, 8, 0, 1)),
          t(today, 8, 0, 1));
      expect(allSlots(p2), [(M.walkInactive, t(today, 12, 0, 1))]);
    });

    test('AC9_walkInactive_still_scheduled_at_100_percent', () {
      final p = build(
          inp(locked: false, steps: 10000, goal: 10000, stepsAt: t(today, 9)),
          t(today, 9));
      expect(allSlots(p), [(M.walkInactive, t(today, 13))]);
    });

    test('AC9_new_steps_restart_counter_AC34', () {
      final p1 = build(inp(locked: false, steps: 100, stepsAt: t(today, 8)), t(today, 8));
      final p2 = build(inp(locked: false, steps: 1100, stepsAt: t(today, 9)),
          t(today, 9), p1);
      expect(allSlots(p2), [(M.walkInactive, t(today, 13))]);
    });

    test('AC16_exactly_2h_after_0600_when_no_log', () {
      final p = build(inp(water: 0), t(today, 6));
      expect(allSlots(p), [
        (M.waterFirst, t(today, 8)),
        (M.waterSecond, t(today, 10)),
      ]);
    });

    test('AC17_waterFirst_once_per_cycle', () {
      final p1 = build(inp(water: 3, waterAt: t(today, 8)), t(today, 8));
      final now = t(today, 11);
      final p2 = build(inp(water: 3, waterAt: t(today, 8)), now, p1);
      expect(slotsOfMessage(p2, M.waterFirst), [(M.waterFirst, t(today, 10))]);
      expect(NotificationLogic.committed(p2, now).map((i) => i.message),
          [M.waterFirst]);
      // วางแผนซ้ำอีกหลายรอบ ไม่เพิ่ม waterFirst
      var p = p2;
      for (var k = 0; k < 5; k++) {
        p = build(inp(water: 3, waterAt: t(today, 8)), t(today, 11, k), p);
      }
      expect(slotsOfMessage(p, M.waterFirst), hasLength(1));
    });

    test('AC18_waterSecond_exactly_4h', () {
      final p = build(inp(water: 2, waterAt: t(today, 9, 15)), t(today, 9, 15));
      expect(slotsOfMessage(p, M.waterSecond), [(M.waterSecond, t(today, 13, 15))]);
    });

    test('AC21_breakfast_logged_no_food_unlogged_all_day', () {
      final p = build(inp(kcal: 300, target: 2000), t(today, 8));
      expect(slotsOfMessage(p, M.foodUnlogged), isEmpty);
      expect(slotsOfMessage(p, M.foodNight), [(M.foodNight, t(today, 21))]);
    });

    test('AC26_no_items_when_planning_in_quiet_hours', () {
      // 23:30 ของรอบวันเดียวกัน / 02:00 (ยังเป็นรอบวันเดิม) / 05:30 (รอบวันใหม่ ก่อน 06:00)
      final full = inp(water: 0, kcal: 0, locked: false);
      expect(build(full, t(today, 23, 30)).items, isEmpty);
      expect(build(full, t(today + 1, 2)).items, isEmpty);
      final morning = build(full, t(today, 5, 30));
      expect(morning.items, isNotEmpty);
      expectInvariants(morning);
    });

    test('AC26_EC7_isQuietTime_boundaries', () {
      expect(NotificationLogic.isQuietTime(t(today, 22, 59, 59)), isFalse);
      expect(NotificationLogic.isQuietTime(t(today, 23)), isTrue);
      expect(NotificationLogic.isQuietTime(t(today + 1, 4, 59, 59)), isTrue);
      expect(NotificationLogic.isQuietTime(t(today, 5)), isTrue);
      expect(NotificationLogic.isQuietTime(t(today, 5, 59, 59)), isTrue);
      expect(NotificationLogic.isQuietTime(t(today, 6)), isFalse);
    });

    test('AC26_near_goal_detected_0530_scheduled_060000', () {
      final now = t(today, 5, 30);
      final p = build(
          inp(locked: false, steps: 8000, goal: 10000, stepsAt: now), now);
      expect(slotsOfMessage(p, M.walkNearGoal), [(M.walkNearGoal, t(today, 6))]);
    });

    test('EC7_water_log_2130_due_2330_none_next_day_0800', () {
      final p = build(inp(water: 3, waterAt: t(today, 21, 30)), t(today, 21, 30));
      expect(p.items, isEmpty);
      final next = build(inp(water: 0), t(today + 1, 5, 0), p);
      expect(slotsOfMessage(next, M.waterFirst), [(M.waterFirst, t(today + 1, 8))]);
    });

    test('AC28_EC15_cap_reached_before_2100_foodNight_dropped', () {
      // ใช้ T-1: 6 รายการก่อน 21:00 → อาหาร: 21:00 ไม่ถูกตั้ง
      final p = build(inp(water: 0, goal: 8000, locked: false, kcal: 0), t(today, 5, 30));
      expect(p.items.length, docCap);
      expect(p.items.every((i) => i.scheduledAt.isBefore(t(today, 21))), isTrue);
      expect(slotsOfMessage(p, M.foodNight), isEmpty);
    });

    test('AC31_EC5_three_topics_due_together_food_water_walk', () {
      final p = build(
          inp(water: 3, waterAt: t(today, 10), locked: false, steps: 100,
              stepsAt: t(today, 8), kcal: 0),
          t(today, 11));
      expect(allSlots(p).take(3).toList(), [
        (M.foodUnlogged, t(today, 12)),
        (M.waterFirst, t(today, 12, 30)),
        (M.walkInactive, t(today, 13)),
      ]);
      expectInvariants(p);
    });

    test('AC32_delayed_item_sent_later_not_dropped', () {
      // T-1: walkInactive ครบ 10:00 ถูกเลื่อน (ชนน้ำ) → ส่ง 10:30
      final p = build(inp(water: 0, goal: 8000, locked: false, kcal: 0), t(today, 5, 30));
      final walk = p.items.firstWhere((i) => i.message == M.walkInactive);
      expect(walk.dueAt, t(today, 10));
      expect(walk.scheduledAt, t(today, 10, 30));
      // วางแผนใหม่ตอน 10:15 (ระหว่างถูกเลื่อน) ยังอยู่ที่ 10:30
      final again = build(
          inp(water: 0, goal: 8000, locked: false, kcal: 0), t(today, 10, 15), p);
      expect(slotsOfMessage(again, M.walkInactive),
          [(M.walkInactive, t(today, 10, 30))]);
    });

    test('AC34_food_log_removes_pending_food_unlogged', () {
      final p1 = build(inp(kcal: 0), t(today, 9));
      final p2 = build(inp(kcal: 400), t(today, 9, 10), p1);
      expect(slotsOfMessage(p2, M.foodUnlogged), isEmpty);
    });

    test('AC34_near_goal_pending_then_100_percent_removed_Q08', () {
      final p1 = build(
          inp(locked: false, steps: 8000, goal: 10000, stepsAt: t(today, 12)),
          t(today, 12),
          planOf(d(today), [sentItem(M.foodUnlogged, t(today, 11, 50))]));
      // committed 11:50 → walkNearGoal เลื่อนเป็น 12:20 (pending)
      expect(pendingSlots(p1, t(today, 12)),
          contains((M.walkNearGoal, t(today, 12, 20))));
      final p2 = build(
          inp(locked: false, steps: 10000, goal: 10000, stepsAt: t(today, 12, 10)),
          t(today, 12, 10),
          p1);
      expect(slotsOfMessage(p2, M.walkNearGoal), isEmpty);
    });

    test('AC35_EC8_reset_at_0500_count_and_near_goal', () {
      final six = [
        sentItem(M.walkNearGoal, t(today, 6), anchor: t(today, 6)),
        for (var k = 1; k < 6; k++)
          sentItem(M.walkInactive, t(today, 6 + k), anchor: t(today, k)),
      ];
      final plan = planOf(d(today), six);
      final before = t(today + 1, 4, 59, 59);
      final at = t(today + 1, 5);
      expect(NotificationLogic.logicalDay(before), d(today));
      expect(NotificationLogic.logicalDay(at), d(today + 1));
      final p0459 = NotificationLogic.planForToday(plan, before);
      expect(NotificationLogic.sentCount(p0459, before), docCap);
      expect(NotificationLogic.walkNearGoalSentToday(p0459, before), isTrue);
      final p0500 = NotificationLogic.planForToday(plan, at);
      expect(NotificationLogic.sentCount(p0500, at), 0);
      expect(NotificationLogic.walkNearGoalSentToday(p0500, at), isFalse);
      expect(NotificationLogic.lastSentAt(p0500, at), isNull);
      // วางแผนวันใหม่ได้เต็มเพดานอีกครั้ง
      final fresh = build(inp(water: 0, goal: 8000, locked: false, kcal: 0), at, plan);
      expect(fresh.day, d(today + 1));
      expect(fresh.items.length, docCap);
    });

    test('EDGE_rapid_replan_same_inputs_idempotent', () {
      final i = inp(water: 1, waterAt: t(today, 7), locked: false, steps: 500,
          stepsAt: t(today, 7), kcal: 0);
      var p = build(i, t(today, 7));
      final first = p.items;
      for (var k = 0; k < 20; k++) {
        p = build(i, t(today, 7), p);
      }
      expect(p.items, first);
      expectInvariants(p);
    });

    test('EDGE_invariants_hold_across_many_inputs', () {
      for (final h in [5, 6, 9, 12, 15, 18, 20, 22]) {
        for (final water in [0, 3, 7]) {
          for (final kcal in [0, 300]) {
            final now = t(today, h, 7);
            final p = build(
                inp(water: water, waterAt: water == 0 ? null : t(today, 6, 30),
                    locked: false, steps: 8100, goal: 10000,
                    stepsAt: t(today, 6, 40), kcal: kcal),
                now);
            expectInvariants(p);
          }
        }
      }
    });

    test('EDGE_empty_inputs_first_open_inputsFor_all_null', () {
      final now = t(today, 7);
      final i = NotificationLogic.inputsFor(
        now: now,
        waterCups: 0,
        waterLastLoggedAt: null,
        steps: 0,
        stepsDay: null,
        stepsGoal: 8000,
        isTrackingLocked: false,
        lastStepsIncreasedAt: null,
        totalCalories: 0,
        foodDay: null,
        targetCalories: null,
      );
      expect(i.waterCount, 0);
      expect(i.steps, 0);
      expect(i.totalCalories, 0);
      final p = build(i, now);
      expect(p.items, isNotEmpty);
      expectInvariants(p);
    });

    test('EDGE_previous_plan_of_other_day_treated_empty', () {
      final old = planOf(d(today - 3), [sentItem(M.foodNight, t(today - 3, 21))],
          suppressed: {NotificationTopic.water});
      final p = NotificationLogic.planForToday(old, t(today, 9));
      expect(p.day, d(today));
      expect(p.items, isEmpty);
      expect(p.suppressedTopics, isEmpty);
    });
  });

  // =========================================================================
  // payload / id / json
  // =========================================================================
  group('payload / id / storage json', () {
    test('AC38_AC39_AC40_payload_round_trip_topic', () {
      expect(NotificationLogic.encodePayload(M.waterFirst), 'water|waterFirst');
      expect(NotificationLogic.encodePayload(M.walkNearGoal), 'walk|walkNearGoal');
      expect(NotificationLogic.encodePayload(M.foodNight), 'food|foodNight');
      for (final m in M.values) {
        expect(NotificationLogic.decodePayload(NotificationLogic.encodePayload(m)),
            m.topic, reason: m.name);
      }
    });

    test('EDGE_payload_unreadable_returns_null', () {
      for (final p in [null, '', 'xyz', 'water', 'unknown|waterFirst', 'a|b|c']) {
        expect(NotificationLogic.decodePayload(p), isNull, reason: '$p');
      }
    });

    test('Q25_id_deterministic_unique_and_31bit', () {
      final a = NotificationLogic.notificationId(d(today), M.waterFirst, t(today, 8));
      expect(NotificationLogic.notificationId(d(today), M.waterFirst, t(today, 8)), a);
      final others = {
        NotificationLogic.notificationId(d(today + 1), M.waterFirst, t(today, 8)),
        NotificationLogic.notificationId(d(today), M.waterSecond, t(today, 8)),
        NotificationLogic.notificationId(d(today), M.waterFirst, t(today, 9)),
      };
      expect(others, isNot(contains(a)));
      expect(others.length, 3);
      for (final id in [a, ...others]) {
        expect(id, inInclusiveRange(0, 0x7fffffff));
      }
    });

    test('Q21_day_plan_json_round_trip', () {
      final p = build(inp(water: 0, goal: 8000, locked: false, kcal: 0),
          t(today, 5, 30));
      final back = NotificationDayPlan.fromJsonString(p.toJsonString())!;
      expect(back.day, p.day);
      expect(back.items, p.items);
      expect(back.suppressedTopics, p.suppressedTopics);
    });

    test('EDGE_corrupt_plan_json_null_or_skips_bad_items', () {
      expect(NotificationDayPlan.fromJsonString(null), isNull);
      expect(NotificationDayPlan.fromJsonString('{bad json'), isNull);
      expect(NotificationDayPlan.fromJsonString('[1,2]'), isNull);
      expect(NotificationDayPlan.fromJsonString('{"items":[]}'), isNull);
      final p = NotificationDayPlan.fromJsonString(
          '{"day":"2026-11-10","items":[{"id":"x"},{"id":1,"message":"waterFirst",'
          '"anchor":"2026-11-10T06:00:00.000","dueAt":"2026-11-10T08:00:00.000",'
          '"scheduledAt":"2026-11-10T08:00:00.000"}],"suppressedTopics":["walk","zzz"]}')!;
      expect(p.items.length, 1);
      expect(p.items.single.message, M.waterFirst);
      expect(p.suppressedTopics, {NotificationTopic.walk});
    });
  });

  // =========================================================================
  // คำถาม (เอกสารขัดกัน) — ดู test-report §7
  // =========================================================================
  // =========================================================================
  // DECIDED (owner 2026-11-08, รอบ 2 — ตอบ QA คำถาม 1): ตั้งแต่ 21:00:00 ไม่ส่ง foodUnlogged
  // =========================================================================
  group('DECIDED 21:00 food', () {
    test('DECIDED_R2_first_open_2100_only_foodNight_at_210000', () {
      final now = t(today, docFoodNightHour);
      final p = build(inp(kcal: 0, target: 2000), now);
      expect(slotsOfMessage(p, M.foodUnlogged), isEmpty);
      expect(allSlots(p), [(M.foodNight, t(today, 21))]);
      expectInvariants(p);
    });

    test('DECIDED_R2_first_open_205959_foodUnlogged_allowed_before_2100', () {
      final now = t(today, 20, 59, 59);
      final p = build(inp(kcal: 0, target: 2000), now);
      expect(allSlots(p), [
        (M.foodUnlogged, t(today, 20, 59, 59)), // ขั้น 18:00 ที่เลยเวลา (Q-06) ก่อน 21:00
        (M.foodNight, t(today, 21, 29, 59)), // ห่าง 30:00
      ]);
      expectInvariants(p);
    });

    test('DECIDED_R2_first_open_after_2100_no_foodUnlogged_no_target', () {
      final p = build(inp(kcal: 0, noTarget: true), t(today, 21, 40));
      expect(slotsOfMessage(p, M.foodUnlogged), isEmpty);
      expect(allSlots(p), [(M.foodNight, t(today, 21, 40))]);
    });

    test('DECIDED_R2_foodUnlogged_deferred_by_interval_to_2100_removed', () {
      // ส่งล่าสุด 20:30:00 → t = 21:00:00 → foodUnlogged (ขั้น 18) ถูกเอาออก เหลือ foodNight 21:00
      final sent = planOf(d(today), [
        sentItem(M.walkInactive, t(today, 20, 30), anchor: t(today, 16, 30)),
      ]);
      final p = build(inp(kcal: 0), t(today, 20, 30), sent);
      expect(pendingSlots(p, t(today, 20, 30)), [(M.foodNight, t(today, 21))]);
      expect(slotsOfMessage(p, M.foodUnlogged), isEmpty);
    });

    test('DECIDED_R2_foodUnlogged_deferred_to_205959_still_sent_boundary', () {
      final sent = planOf(d(today), [
        sentItem(M.walkInactive, t(today, 20, 29, 59), anchor: t(today, 16, 29, 59)),
      ]);
      final p = build(inp(kcal: 0), t(today, 20, 29, 59), sent);
      expect(pendingSlots(p, t(today, 20, 29, 59)), [
        (M.foodUnlogged, t(today, 20, 59, 59)),
        (M.foodNight, t(today, 21, 29, 59)),
      ]);
    });

    test('DECIDED_R2_pure_schedule_removes_foodUnlogged_when_queue_reaches_2100', () {
      final fu = sentItem(M.foodUnlogged, t(today, 18));
      final fn = sentItem(M.foodNight, t(today, 21));
      final out = NotificationLogic.schedule([fu, fn],
          day: d(today),
          now: t(today, 20, 30),
          committed: [sentItem(M.waterFirst, t(today, 20, 30), anchor: t(today, 18, 30))]);
      expect(slotsOf(out), [(M.foodNight, t(today, 21))]);
    });
  });
}
