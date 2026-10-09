// Unit tests: logic เกมของฟีเจอร์ water
// ตัวเลขคาดหวังทั้งหมดมาจาก docs/water/requirements.md, game-rules.md, ux-flow.md
// (ไม่ได้ลอกจากโค้ด) — เวลาใช้ค่าคงที่ส่งเข้า logic ไม่ใช้เวลาจริง
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/water/water_logic.dart';
import 'package:petpal_health/features/water/water_models.dart';

/// เวลาในเดือน ต.ค. 2026 (ปรับวัน/ชั่วโมง/นาที/วินาทีได้)
DateTime t(int day, int hour, int minute, [int second = 0]) =>
    DateTime(2026, 10, day, hour, minute, second);

/// สร้างสถานะที่มี x แก้ว บันทึกล่าสุดที่เวลา last
WaterState stateWith(int cups, DateTime? last,
        [List<DailyWaterRecord> history = const []]) =>
    WaterState(cups: cups, lastLoggedAt: last, history: history);

DailyWaterRecord rec(int month, int day, int cups) =>
    DailyWaterRecord(date: DateTime(2026, month, day), cups: cups);

/// กดบันทึก n ครั้ง ห่างกันครั้งละ 5 นาที เริ่มที่ start
WaterState logTimes(int n, DateTime start) {
  var s = WaterState.initial;
  for (var i = 0; i < n; i++) {
    final r = WaterLogic.logWater(s, start.add(Duration(minutes: 5 * i)));
    expect(r.outcome, LogWaterOutcome.logged);
    s = r.state;
  }
  return s;
}

void main() {
  group('AC-1 กด + แล้ว +1 แก้ว และพลังงาน +12.5% (game-rules §1, §3)', () {
    test('AC1_first_log_of_day_0_to_1_cup_12_5_percent', () {
      final r = WaterLogic.logWater(WaterState.initial, t(8, 10, 0));
      expect(r.outcome, LogWaterOutcome.logged);
      expect(r.state.cups, 1);
      expect(WaterLogic.energyPercentage(r.state.cups), 12.5);
      expect(WaterLogic.displayEnergyPercentage(r.state.cups), 12.5);
    });

    test('AC1_energy_formula_cups_x_12_5_for_0_to_8_cups', () {
      // จำนวนแก้ว x 12.5%
      const expected = {
        0: 0.0, 1: 12.5, 2: 25.0, 3: 37.5, 4: 50.0,
        5: 62.5, 6: 75.0, 7: 87.5, 8: 100.0,
      };
      expected.forEach((cups, pct) {
        expect(WaterLogic.displayEnergyPercentage(cups), pct,
            reason: '$cups แก้ว ต้องได้ $pct%');
      });
    });

    test('AC1_each_successful_log_adds_exactly_1_cup_and_12_5_percent', () {
      final s2 = logTimes(2, t(8, 10, 0));
      final r = WaterLogic.logWater(s2, t(8, 10, 10));
      expect(r.state.cups, s2.cups + 1);
      expect(
        WaterLogic.energyPercentage(r.state.cups) -
            WaterLogic.energyPercentage(s2.cups),
        12.5,
      );
    });
  });

  group('AC-2 สถานะสัตว์เลี้ยงตามช่วง (requirements §2, game-rules §2)', () {
    test('AC2_3_cups_critical_then_4_cups_tired_immediately', () {
      final s3 = logTimes(3, t(8, 10, 0));
      expect(s3.cups, 3);
      expect(WaterLogic.moodFor(3), PetMood.critical);
      expect(WaterLogic.moodText(WaterLogic.moodFor(3)), 'เหี่ยวเฉา ป่วย ใกล้ตาย');
      final r = WaterLogic.logWater(s3, t(8, 10, 15));
      expect(r.state.cups, 4);
      expect(WaterLogic.displayEnergyPercentage(4), 50.0);
      expect(WaterLogic.moodFor(r.state.cups), PetMood.tired);
      expect(WaterLogic.moodText(PetMood.tired), 'เริ่มเพลีย อ่อนแรง แลบลิ้น');
    });

    // Edge 1: ค่าเกณฑ์พอดี + เกิน 1 หน่วย ทุกขอบ
    test('EDGE_threshold_0_and_3_critical_4_tired', () {
      expect(WaterLogic.moodFor(0), PetMood.critical);
      expect(WaterLogic.moodFor(3), PetMood.critical);
      expect(WaterLogic.moodFor(4), PetMood.tired);
    });

    test('EDGE_threshold_6_tired_7_happy_8_happy', () {
      expect(WaterLogic.moodFor(6), PetMood.tired);
      expect(WaterLogic.moodFor(7), PetMood.happy);
      expect(WaterLogic.moodFor(8), PetMood.happy);
      expect(WaterLogic.moodText(PetMood.happy), 'สดชื่น ร่าเริง มีความสุข');
    });

    test('AC2_mood_images_match_game_rules_section_2', () {
      expect(WaterLogic.moodImage(WaterLogic.moodFor(3)),
          'assets/images/pet_critical.png');
      expect(WaterLogic.moodImage(WaterLogic.moodFor(4)),
          'assets/images/pet_tired.png');
      expect(WaterLogic.moodImage(WaterLogic.moodFor(6)),
          'assets/images/pet_tired.png');
      expect(WaterLogic.moodImage(WaterLogic.moodFor(7)),
          'assets/images/pet_happy.png');
    });
  });

  group('AC-3 / AC-4 Anti-Spam 1 แก้วต่อ 5 นาที', () {
    test('AC3_log_10_00_then_10_03_is_blocked_and_cups_unchanged', () {
      // game-rules §3: 2 แก้ว (25%) กดซ้ำภายใน 3 นาที → ยัง 2 แก้ว (25%)
      final s = stateWith(2, t(8, 10, 0));
      final r = WaterLogic.logWater(s, t(8, 10, 3));
      expect(r.outcome, LogWaterOutcome.blockedBySpam);
      expect(r.state.cups, 2);
      expect(WaterLogic.displayEnergyPercentage(r.state.cups), 25.0);
      expect(r.state.lastLoggedAt, t(8, 10, 0));
    });

    test('AC4_log_10_00_then_10_05_is_allowed_and_last_log_is_10_05', () {
      // game-rules §3: 2 แก้ว (25%) → 3 แก้ว (37.5%) หลังผ่านไป 5 นาที
      final s = stateWith(2, t(8, 10, 0));
      final r = WaterLogic.logWater(s, t(8, 10, 5));
      expect(r.outcome, LogWaterOutcome.logged);
      expect(r.state.cups, 3);
      expect(WaterLogic.displayEnergyPercentage(r.state.cups), 37.5);
      expect(r.state.lastLoggedAt, t(8, 10, 5));
    });

    // Edge 1: ค่าเกณฑ์พอดี 5 นาที (ขาด 1 วินาที / พอดี / เกิน 1 นาที)
    test('EDGE_threshold_4m59s_blocked_5m00s_allowed_6m_allowed', () {
      final s = stateWith(1, t(8, 10, 0));
      expect(WaterLogic.logWater(s, t(8, 10, 4, 59)).outcome,
          LogWaterOutcome.blockedBySpam);
      expect(WaterLogic.logWater(s, t(8, 10, 5)).outcome,
          LogWaterOutcome.logged);
      expect(WaterLogic.logWater(s, t(8, 10, 6)).outcome,
          LogWaterOutcome.logged);
    });

    test('EDGE_blocked_attempt_does_not_restart_5_minute_window', () {
      // ux-flow §3 ข้อ 4: นับ 5 นาทีจาก "การบันทึกครั้งล่าสุด" (ที่สำเร็จ)
      var s = stateWith(1, t(8, 10, 0));
      s = WaterLogic.logWater(s, t(8, 10, 3)).state; // ถูกบล็อก
      final r = WaterLogic.logWater(s, t(8, 10, 5));
      expect(r.outcome, LogWaterOutcome.logged);
      expect(r.state.cups, 2);
    });

    test('EC3_rapid_taps_only_first_is_logged', () {
      var s = WaterState.initial;
      final outcomes = <LogWaterOutcome>[];
      for (var ms = 0; ms < 500; ms += 100) {
        final r = WaterLogic.logWater(
            s, t(8, 10, 0).add(Duration(milliseconds: ms)));
        outcomes.add(r.outcome);
        s = r.state;
      }
      expect(outcomes.first, LogWaterOutcome.logged);
      expect(outcomes.skip(1),
          everyElement(LogWaterOutcome.blockedBySpam));
      expect(s.cups, 1);
    });
  });

  group('AC-5 / EC-2 รีเซ็ตเวลา 05:00 น.', () {
    test('AC5_5_cups_at_04_59_stay_5_then_reset_to_0_at_05_00', () {
      // game-rules §3: 5 แก้ว (62.5%) → 0 แก้ว (0.0%)
      final s = stateWith(5, t(8, 4, 30));
      final at0459 = WaterLogic.applyDailyReset(s, t(8, 4, 59));
      expect(at0459.cups, 5);
      expect(WaterLogic.displayEnergyPercentage(at0459.cups), 62.5);
      final at0500 = WaterLogic.applyDailyReset(s, t(8, 5, 0));
      expect(at0500.cups, 0);
      expect(WaterLogic.displayEnergyPercentage(at0500.cups), 0.0);
    });

    // Edge 2: ข้ามวัน — เที่ยงคืนไม่ใช่เวลารีเซ็ต
    test('EDGE_midnight_is_not_reset_boundary', () {
      final s = stateWith(5, t(7, 23, 50));
      expect(WaterLogic.applyDailyReset(s, t(8, 0, 0)).cups, 5);
      expect(WaterLogic.applyDailyReset(s, t(8, 0, 1)).cups, 5);
      expect(WaterLogic.applyDailyReset(s, t(8, 4, 59, 59)).cups, 5);
      expect(WaterLogic.applyDailyReset(s, t(8, 5, 0)).cups, 0);
    });

    test('EDGE_log_23_58_then_00_01_blocked_00_03_counts_on_same_day', () {
      final s = stateWith(5, t(7, 23, 58));
      final blocked = WaterLogic.logWater(s, t(8, 0, 1));
      expect(blocked.outcome, LogWaterOutcome.blockedBySpam);
      expect(blocked.state.cups, 5);
      final ok = WaterLogic.logWater(s, t(8, 0, 3));
      expect(ok.outcome, LogWaterOutcome.logged);
      expect(ok.state.cups, 6, reason: 'ยังไม่ถึง 05:00 จึงสะสมต่อจากวันเดิม');
    });

    test('EC2_device_off_overnight_across_05_00_resets_on_open', () {
      final s = stateWith(5, t(7, 22, 0));
      expect(WaterLogic.applyDailyReset(s, t(8, 8, 0)).cups, 0);
    });

    test('EC2_device_off_several_days_resets_on_open', () {
      final s = stateWith(9, t(3, 12, 0));
      expect(WaterLogic.applyDailyReset(s, t(8, 9, 0)).cups, 0);
    });

    test('EDGE_after_05_00_reset_first_log_starts_from_1_cup', () {
      final s = stateWith(5, t(7, 20, 0), [rec(10, 7, 5)]);
      final r = WaterLogic.logWater(s, t(8, 7, 0));
      expect(r.outcome, LogWaterOutcome.logged);
      expect(r.state.cups, 1);
      expect(WaterLogic.displayEnergyPercentage(r.state.cups), 12.5);
    });

    test('EDGE_reset_keeps_previous_day_in_history', () {
      final s = stateWith(5, t(7, 20, 0), [rec(10, 7, 5)]);
      final r = WaterLogic.logWater(s, t(8, 7, 0));
      final report = WaterLogic.monthlyReport(r.state.history, t(8, 7, 1));
      expect(report.records.map((e) => e.cups).toList(), [5, 1]);
    });

    // คำตัดสินทีม 2026-10-08 / game-rules §4: ห้ามกดซ้ำ 5 นาทียังนับต่อข้าม 05:00
    test('EDGE_antispam_across_05_00_log_04_58_tap_05_01_blocked', () {
      final s = stateWith(3, t(8, 4, 58));
      final r = WaterLogic.logWater(s, t(8, 5, 1));
      expect(r.outcome, LogWaterOutcome.blockedBySpam);
      expect(r.state.cups, 0, reason: 'รีเซ็ต 05:00 แล้ว แต่ไม่บันทึกเพิ่ม');
    });

    test('EDGE_antispam_across_05_00_05_02_59_blocked_05_03_allowed', () {
      final s = stateWith(3, t(8, 4, 58));
      expect(WaterLogic.logWater(s, t(8, 5, 2, 59)).outcome,
          LogWaterOutcome.blockedBySpam);
      final r = WaterLogic.logWater(s, t(8, 5, 3));
      expect(r.outcome, LogWaterOutcome.logged);
      expect(r.state.cups, 1);
      expect(r.state.lastLoggedAt, t(8, 5, 3));
    });
  });

  group('EC-1 / ค่าติดเพดาน max/min', () {
    test('EC1_12_cups_bar_stops_at_100_but_count_is_12', () {
      final s = logTimes(12, t(8, 6, 0));
      expect(s.cups, 12);
      expect(WaterLogic.displayEnergyPercentage(s.cups), 100.0);
      expect(WaterLogic.displayEnergyFraction(s.cups), 1.0);
    });

    test('EDGE_cap_8_cups_exactly_100_and_9_cups_still_100', () {
      expect(WaterLogic.displayEnergyPercentage(8), 100.0);
      expect(WaterLogic.displayEnergyPercentage(9), 100.0);
    });

    test('EDGE_min_0_cups_is_0_percent_never_negative', () {
      expect(WaterLogic.displayEnergyPercentage(0), 0.0);
      expect(WaterLogic.displayEnergyFraction(0), 0.0);
      // reset ซ้ำหลายครั้งไม่ทำให้ต่ำกว่า 0
      var s = stateWith(0, t(6, 10, 0));
      s = WaterLogic.applyDailyReset(s, t(7, 10, 0));
      s = WaterLogic.applyDailyReset(s, t(8, 10, 0));
      expect(s.cups, 0);
    });

    test('EDGE_count_keeps_increasing_past_cap_9_to_10', () {
      final s9 = logTimes(9, t(8, 6, 0));
      final r = WaterLogic.logWater(s9, t(8, 9, 0));
      expect(r.state.cups, 10);
      expect(WaterLogic.displayEnergyPercentage(r.state.cups), 100.0);
    });
  });

  group('AC-6 รายงานรายเดือน (ค่าเฉลี่ยทศนิยม 1 ตำแหน่ง)', () {
    test('AC6_average_5_and_4_over_2_logged_days_is_4_5', () {
      final rep = WaterLogic.monthlyReport(
          [rec(10, 1, 5), rec(10, 3, 4)], t(8, 12, 0));
      expect(rep.totalCups, 9);
      expect(rep.records.length, 2);
      expect(WaterLogic.formatAverage(rep.average), '4.5');
    });

    test('AC6_days_without_logs_are_not_in_divisor', () {
      // คำตัดสินทีม: หารด้วยจำนวนวันที่มีการบันทึกเท่านั้น (1 และ 3 ต.ค.; 2 ต.ค. 0 แก้ว)
      final rep = WaterLogic.monthlyReport(
          [rec(10, 1, 5), rec(10, 2, 0), rec(10, 3, 4)], t(8, 12, 0));
      expect(WaterLogic.formatAverage(rep.average), '4.5');
    });

    test('AC6_average_one_decimal_13_over_3_is_4_3', () {
      final rep = WaterLogic.monthlyReport(
          [rec(10, 1, 5), rec(10, 2, 4), rec(10, 5, 4)], t(8, 12, 0));
      expect(WaterLogic.formatAverage(rep.average), '4.3');
    });

    test('AC6_average_one_decimal_20_over_3_is_6_7', () {
      final rep = WaterLogic.monthlyReport(
          [rec(10, 1, 7), rec(10, 2, 7), rec(10, 3, 6)], t(8, 12, 0));
      expect(WaterLogic.formatAverage(rep.average), '6.7');
    });

    test('AC6_whole_number_average_shows_one_decimal_8_0', () {
      final rep = WaterLogic.monthlyReport(
          [rec(10, 1, 8), rec(10, 2, 8)], t(8, 12, 0));
      expect(WaterLogic.formatAverage(rep.average), '8.0');
    });

    test('AC6_other_months_are_excluded', () {
      final rep = WaterLogic.monthlyReport(
          [rec(9, 30, 12), rec(10, 1, 4), rec(10, 2, 6)], t(8, 12, 0));
      expect(rep.records.length, 2);
      expect(WaterLogic.formatAverage(rep.average), '5.0');
    });

    test('AC6_history_list_has_date_and_cups_per_day_sorted', () {
      final rep = WaterLogic.monthlyReport(
          [rec(10, 3, 4), rec(10, 1, 5)], t(8, 12, 0));
      expect(rep.records, [rec(10, 1, 5), rec(10, 3, 4)]);
    });

    // Edge 4: ไม่มีข้อมูล → ux-flow §4 S-2 ว่าง: ค่าเฉลี่ย "0.0"
    test('EDGE_empty_history_average_0_0_and_empty', () {
      final rep = WaterLogic.monthlyReport(const [], t(8, 12, 0));
      expect(rep.isEmpty, isTrue);
      expect(WaterLogic.formatAverage(rep.average), '0.0');
    });
  });

  group('Edge 4 เปิดแอปครั้งแรก (ux-flow §4 S-1 ว่าง)', () {
    test('EDGE_first_open_initial_state_0_cups_0_percent_critical', () {
      final s = WaterLogic.applyDailyReset(WaterState.initial, t(8, 9, 0));
      expect(s.cups, 0);
      expect(WaterLogic.displayEnergyPercentage(s.cups), 0.0);
      expect(WaterLogic.moodFor(s.cups), PetMood.critical);
    });

    test('EDGE_first_ever_log_is_allowed_without_previous_timestamp', () {
      final r = WaterLogic.logWater(WaterState.initial, t(8, 4, 59));
      expect(r.outcome, LogWaterOutcome.logged);
      expect(r.state.cups, 1);
    });
  });
}
