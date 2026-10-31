// Unit tests: SevenDayController — โหลดจาก controller เดิม, ตรวจรอบวันทุก 1 วินาที (EC-4), ข้อมูลเสีย
// ค่าคาดหวังมาจาก docs/7day/requirements.md US-3 / EC-3 / EC-4 / EC-5, game-rules.md §4,
// ui-spec.md §1.3 / §3 และข้อตัดสิน owner (D-2, D-4, D-5, รอบ 3 ข้อ 1) — ไม่ได้ลอกจากโค้ด
// เวลา: FakePeriodicTimers (Timer ตรวจรอบวัน) + clock ร่วมของ 3 controller — ไม่ใช้เวลาจริง
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/seven_day/seven_day_controller.dart';
import 'package:petpal_health/features/seven_day/seven_day_logic.dart';
import 'package:petpal_health/features/seven_day/seven_day_models.dart';

import 'seven_day_test_helpers.dart';

void main() {
  late DateTime now;
  late FakePeriodicTimers timers;
  SevenDayController? ctl;

  setUp(() {
    now = t(31, 10);
    timers = FakePeriodicTimers();
  });

  tearDown(() {
    ctl?.dispose();
    ctl = null;
  });

  SevenDayController make(Sources s) {
    final c = SevenDayController(
        water: s.water, steps: s.steps, food: s.food, timerFactory: timers.create);
    ctl = c;
    return c;
  }

  group('โหลด / แหล่งข้อมูล (D-2, D-5)', () {
    test('DECIDED_D5_start_loads_existing_controllers_and_reads_their_data', () async {
      final s = sourcesFor({
        0: const DayData(cups: 3, steps: 4000, kcal: 1200),
        1: const DayData(cups: 8, steps: 9000, kcal: 1800),
      }, clock: () => now);
      final c = make(s);
      expect(c.isLoaded, isFalse);
      await c.start();
      expect(c.isLoaded, isTrue);
      expect(s.water.isLoaded && s.steps.isLoaded && s.food.isLoaded, isTrue);
      final snap = c.snapshot;
      expect(snap.today, d(31));
      expect(snap.recordedDays, 2);
      expect([snap.days[0].waterCups, snap.days[0].steps, snap.days[0].calories],
          [3, 4000, 1200]);
      expect([snap.days[1].waterCups, snap.days[1].steps, snap.days[1].calories],
          [8, 9000, 1800]);
    });

    test('DECIDED_D5_source_change_notifies_and_snapshot_updates_live', () async {
      final s = sourcesFor({1: const DayData(cups: 8)}, clock: () => now);
      final c = make(s);
      await c.start();
      var notified = 0;
      c.addListener(() => notified++);
      expect(c.snapshot.days[0].waterCups, 0);
      await s.water.logWater();
      expect(notified, greaterThan(0));
      expect(c.snapshot.days[0].waterCups, 1);
      expect(SevenDayLogic.avgWaterText(c.snapshot), avgWaterLine('4.5'),
          reason: '(1 + 8) / 2');
    });

    test('EC5_EDGE_corrupt_storage_all_three_no_crash_empty', () async {
      final s = makeSources(
        clock: () => now,
        waterRepo: BrokenWaterRepository(),
        stepsRepo: BrokenStepsRepository(),
        foodRepo: BrokenFoodRepository(),
      );
      final c = make(s);
      await c.start();
      expect(c.isLoaded, isTrue);
      expect(c.snapshot.status, SevenDayStatus.empty);
      expect(c.snapshot.days.length, docMaxHistoryDays);
      expect(c.snapshot.today, d(31));
    });

    test('EDGE_first_open_no_data_empty_status', () async {
      final s = makeSources(clock: () => now);
      final c = make(s);
      await c.start();
      expect(c.snapshot.status, SevenDayStatus.empty);
      expect(c.snapshot.recordedDays, 0);
    });
  });

  group('EC-4 / US-3 ข้าม 05:00 ขณะเปิดค้าง (ตรวจทุก 1 วินาที)', () {
    test('EC4_EDGE_04_59_59_keeps_window_05_00_00_shifts_day0', () async {
      now = t(31, 4, 59, 59); // รอบวัน 30 ต.ค.
      final s = sourcesFor({
        0: const DayData(cups: 3, steps: 4000, kcal: 1200),
      }, clock: () => now, base: 30);
      final c = make(s);
      await c.start();
      expect(c.snapshot.today, d(30));
      expect(c.snapshot.days[0].steps, 4000);

      timers.advance(docDayCheck);
      await pumpEventQueue();
      expect(c.snapshot.today, d(30), reason: 'ยัง 04:59:59');

      now = t(31, 5);
      var notified = 0;
      c.addListener(() => notified++);
      timers.advance(docDayCheck);
      await pumpEventQueue();
      final snap = c.snapshot;
      expect(notified, greaterThan(0));
      expect(snap.today, d(31));
      expect(snap.days[0].hasRecord, isFalse, reason: 'Day 0 ใหม่ยังไม่มีบันทึก');
      expect([snap.days[1].date, snap.days[1].waterCups, snap.days[1].steps,
          snap.days[1].calories], [d(30), 3, 4000, 1200],
          reason: 'วันเดิมเลื่อนเป็น Day −1 ค่าไม่หาย');
      expect(snap.status, SevenDayStatus.inconsistent);
    });

    test('EC4_timer_interval_is_1_second_and_ticks_repeat', () async {
      final s = makeSources(clock: () => now);
      final c = make(s);
      await c.start();
      expect(timers.timers.length, 1);
      expect(timers.timers.single.interval, docDayCheck);
      timers.advance(const Duration(seconds: 3));
      await pumpEventQueue();
      expect(timers.timers.single.tick, 3);
      expect(c.isLoaded, isTrue);
    });

    test('EC4_refreshDay_after_05_00_shifts_without_timer', () async {
      final s = sourcesFor({0: const DayData(cups: 2)}, clock: () => now);
      final c = make(s);
      await c.start();
      now = DateTime(2026, 11, 1, 6);
      await c.refreshDay();
      expect(c.snapshot.today, DateTime(2026, 11, 1));
      expect(c.snapshot.days[1].date, d(31));
      expect(c.snapshot.days[1].waterCups, 2);
    });

    test('UI_dispose_cancels_day_timer', () async {
      final s = makeSources(clock: () => now);
      final c = SevenDayController(
          water: s.water, steps: s.steps, food: s.food, timerFactory: timers.create);
      await c.start();
      expect(timers.activeCount, 1);
      c.dispose();
      expect(timers.activeCount, 0);
      // tick หลัง dispose ไม่ทำให้พัง
      timers.advance(const Duration(seconds: 2));
      await pumpEventQueue();
    });
  });
}
