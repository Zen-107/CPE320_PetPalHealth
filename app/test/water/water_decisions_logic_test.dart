// Unit tests (QA v2): ข้อตัดสินโดย Zen-107 2026-10-08
// ตัวเลข/ผลคาดหวังมาจาก requirements.md AC-6, game-rules.md §2 §4, ux-flow.md S-2
// (commit e64adff) — ไม่ได้ลอกจากโค้ด · เวลาส่งเข้า logic เป็นค่าคงที่ ไม่ใช้เวลาจริง
//
// หมายเหตุ: เอกสารไม่ได้กำหนดว่าตอนนาฬิกาย้อนกลับ "กดบันทึกได้ทันทีหรือไม่"
// (Dev ASSUMPTION: บล็อกจนครบ 5 นาทีหลังบันทึกล่าสุด) จึงไม่ assert ผลลัพธ์ logged/blocked
// แต่ตรวจเฉพาะสิ่งที่เอกสารกำหนด: ไม่ crash, นับเป็นวันเดียวกับบันทึกล่าสุด, ห้ามลบข้อมูล
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/water/water_logic.dart';
import 'package:petpal_health/features/water/water_models.dart';

DateTime dt(int month, int day, int hour, int minute, [int second = 0]) =>
    DateTime(2026, month, day, hour, minute, second);

DailyWaterRecord rec(int month, int day, int cups) =>
    DailyWaterRecord(date: DateTime(2026, month, day), cups: cups);

int? cupsOn(List<DailyWaterRecord> history, int month, int day) {
  for (final r in history) {
    if (r.date == DateTime(2026, month, day)) return r.cups;
  }
  return null;
}

void main() {
  group('ข้อตัดสิน 1: ขอบเดือน AC-6 (00:00–04:59 ของวันที่ 1 = วันสุดท้ายของเดือนก่อน)',
      () {
    test('AC6_log_04_59_on_1st_goes_to_history_as_last_day_of_previous_month',
        () {
      final r = WaterLogic.logWater(WaterState.initial, dt(11, 1, 4, 59));
      expect(r.outcome, LogWaterOutcome.logged);
      expect(r.state.history, [rec(10, 31, 1)]);
    });

    test('AC6_log_05_00_on_1st_goes_to_history_as_new_month', () {
      final r = WaterLogic.logWater(WaterState.initial, dt(11, 1, 5, 0));
      expect(r.outcome, LogWaterOutcome.logged);
      expect(r.state.history, [rec(11, 1, 1)]);
    });

    test('AC6_log_04_59_then_05_04_on_1st_split_into_two_months', () {
      // 04:59 → 31 ต.ค. / 05:04 (ครบ 5 นาที) → รีเซ็ตแล้วเป็น 1 พ.ย.
      final a = WaterLogic.logWater(WaterState.initial, dt(11, 1, 4, 59));
      final b = WaterLogic.logWater(a.state, dt(11, 1, 5, 4));
      expect(b.outcome, LogWaterOutcome.logged);
      expect(b.state.cups, 1, reason: 'รอบวันใหม่เริ่มที่ 05:00');
      expect(b.state.history, [rec(10, 31, 1), rec(11, 1, 1)]);
    });

    test('AC6_report_at_04_59_on_1st_is_previous_month', () {
      final history = [rec(10, 30, 4), rec(10, 31, 6), rec(11, 1, 8)];
      final rep = WaterLogic.monthlyReport(history, dt(11, 1, 4, 59));
      expect(rep.year, 2026);
      expect(rep.month, 10);
      expect(rep.records, [rec(10, 30, 4), rec(10, 31, 6)]);
      expect(WaterLogic.formatAverage(rep.average), '5.0'); // (4+6)/2
    });

    test('AC6_report_at_05_00_on_1st_is_new_month', () {
      final history = [rec(10, 30, 4), rec(10, 31, 6), rec(11, 1, 8)];
      final rep = WaterLogic.monthlyReport(history, dt(11, 1, 5, 0));
      expect(rep.year, 2026);
      expect(rep.month, 11);
      expect(rep.records, [rec(11, 1, 8)]);
      expect(WaterLogic.formatAverage(rep.average), '8.0');
    });

    test('AC6_year_boundary_01_01_04_59_is_december_previous_year', () {
      final r = WaterLogic.logWater(
          WaterState.initial, DateTime(2027, 1, 1, 4, 59));
      expect(r.state.history,
          [DailyWaterRecord(date: DateTime(2026, 12, 31), cups: 1)]);
      final rep =
          WaterLogic.monthlyReport(r.state.history, DateTime(2027, 1, 1, 4, 59));
      expect(rep.year, 2026);
      expect(rep.month, 12);
      expect(rep.records.length, 1);
      final repNew =
          WaterLogic.monthlyReport(r.state.history, DateTime(2027, 1, 1, 5, 0));
      expect(repNew.year, 2027);
      expect(repNew.month, 1);
      expect(repNew.isEmpty, isTrue);
    });
  });

  group('ข้อตัดสิน 2: นาฬิกาย้อนกลับ (game-rules §4)', () {
    // บันทึกล่าสุด 8 ต.ค. 10:00 มี 3 แก้ว ประวัติ 7 ต.ค. = 6, 8 ต.ค. = 3
    final last = dt(10, 8, 10, 0);
    final history = [rec(10, 7, 6), rec(10, 8, 3)];
    final state = WaterState(cups: 3, lastLoggedAt: last, history: history);

    test('EDGE_clock_back_to_previous_calendar_day_no_reset_same_day', () {
      final s = WaterLogic.applyDailyReset(state, dt(10, 7, 9, 0));
      expect(WaterLogic.needsDailyReset(state, dt(10, 7, 9, 0)), isFalse);
      expect(s.cups, 3);
      expect(s.history, history);
      expect(s.lastLoggedAt, last);
    });

    test('EDGE_clock_back_before_05_00_same_date_no_reset', () {
      // 8 ต.ค. 04:00 อยู่ในรอบวัน 7 ต.ค. แต่ต้องนับเป็นวันเดียวกับบันทึกล่าสุด (8 ต.ค.)
      expect(WaterLogic.needsDailyReset(state, dt(10, 8, 4, 0)), isFalse);
      final s = WaterLogic.applyDailyReset(state, dt(10, 8, 4, 0));
      expect(s.cups, 3);
      expect(s.history, history);
    });

    test('EDGE_clock_back_1_second_no_crash_no_reset', () {
      final now = last.subtract(const Duration(seconds: 1));
      final s = WaterLogic.applyDailyReset(state, now);
      expect(s.cups, 3);
      expect(s.history, history);
    });

    test('EDGE_clock_back_log_attempt_does_not_delete_data_and_counts_same_day',
        () {
      // ไม่ assert ว่าบันทึกได้หรือถูกบล็อก (เอกสารไม่กำหนด → คำถาม)
      for (final now in [
        dt(10, 7, 9, 0), // ย้อนไปวันก่อน
        dt(10, 8, 4, 0), // ย้อนไปก่อน 05:00 ของวันเดียวกัน
        dt(10, 8, 9, 59), // ย้อน 1 นาที
        dt(9, 30, 12, 0), // ย้อนไปเดือนก่อน
      ]) {
        final r = WaterLogic.logWater(state, now);
        final s = r.state;
        expect(cupsOn(s.history, 10, 7), 6,
            reason: '$now: ประวัติ 7 ต.ค. ห้ามถูกเขียนทับ/ลบ');
        expect(s.history.where((h) => h.date.isBefore(DateTime(2026, 10, 8))),
            [rec(10, 7, 6)],
            reason: '$now: ห้ามสร้าง/แก้ประวัติวันก่อนหน้าวันบันทึกล่าสุด');
        if (r.outcome == LogWaterOutcome.logged) {
          expect(s.cups, 4, reason: '$now: นับต่อจากวันเดียวกัน');
          expect(cupsOn(s.history, 10, 8), 4);
        } else {
          expect(s.cups, 3);
          expect(cupsOn(s.history, 10, 8), 3);
        }
      }
    });

    test('EDGE_clock_back_monthly_report_uses_same_day_as_last_log', () {
      // บันทึกล่าสุด 1 พ.ย. 06:00 แล้วนาฬิกาย้อนเป็น 30 ต.ค.
      // นับเป็นวันเดียวกับบันทึกล่าสุด (1 พ.ย.) → รายงานเดือน พ.ย.
      final last = dt(11, 1, 6, 0);
      final now = dt(10, 30, 12, 0);
      final rep = WaterLogic.monthlyReport(
        [rec(10, 31, 5), rec(11, 1, 2)],
        WaterLogic.effectiveNow(last, now),
      );
      expect(rep.month, 11);
      expect(rep.records, [rec(11, 1, 2)]);
    });

    test('EDGE_clock_back_then_forward_next_day_after_05_00_resets_normally',
        () {
      // ตรวจว่าหลังนาฬิกากลับมาปกติ กติกา 05:00 ยังทำงาน และประวัติยังอยู่
      final back = WaterLogic.applyDailyReset(state, dt(10, 7, 9, 0));
      final next = WaterLogic.applyDailyReset(back, dt(10, 9, 5, 0));
      expect(next.cups, 0);
      expect(next.history, history);
    });
  });

  group('ข้อตัดสิน 4: วันที่หน้าประวัติ dd/MM/yyyy (ux-flow S-2)', () {
    test('UI_history_date_format_dd_MM_yyyy_with_leading_zeros', () {
      expect(WaterLogic.formatHistoryDate(DateTime(2026, 10, 8)), '08/10/2026');
      expect(WaterLogic.formatHistoryDate(DateTime(2026, 1, 5)), '05/01/2026');
      expect(WaterLogic.formatHistoryDate(DateTime(2026, 12, 31)), '31/12/2026');
    });
  });

  group('ข้อตัดสิน 5: อารมณ์ 0–3 / 4–6 / 7+ (game-rules §2) ขอบ 3/4 และ 6/7', () {
    test('EDGE_mood_ranges_all_values_0_to_12', () {
      for (var c = 0; c <= 12; c++) {
        final expected = c <= 3
            ? PetMood.critical
            : c <= 6
                ? PetMood.tired
                : PetMood.happy;
        expect(WaterLogic.moodFor(c), expected, reason: '$c แก้ว');
      }
    });
  });
}
