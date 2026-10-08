/// Logic เกมของฟีเจอร์ water — pure Dart ไม่ขึ้นกับ widget
///
/// ทุกฟังก์ชันที่เกี่ยวกับเวลารับ `now` เป็นพารามิเตอร์ เพื่อให้ QA ทดสอบได้
library;

import 'water_models.dart';
import 'water_rules.dart';

class WaterLogic {
  WaterLogic._();

  // ---------------------------------------------------------------------------
  // พลังงาน (AC-1, EC-1)
  // ---------------------------------------------------------------------------

  /// พลังงานจริงตามสูตร `จำนวนแก้ว x 12.5%` (ไม่ตัดเพดาน — ใช้เก็บเป็น
  /// water_energy_percentage เช่น 12 แก้ว = 150%)
  static double energyPercentage(int cups) =>
      cups * WaterRules.energyIncrementPercentage;

  /// พลังงานสำหรับแสดงบนหลอด ตัดเพดานที่ 100% (EC-1)
  static double displayEnergyPercentage(int cups) {
    final raw = energyPercentage(cups);
    if (raw < 0) return 0;
    if (raw > WaterRules.energyMaxDisplayPercentage) {
      return WaterRules.energyMaxDisplayPercentage;
    }
    return raw;
  }

  /// สัดส่วน 0.0-1.0 สำหรับ widget หลอดพลังงาน
  static double displayEnergyFraction(int cups) =>
      displayEnergyPercentage(cups) / WaterRules.energyMaxDisplayPercentage;

  // ---------------------------------------------------------------------------
  // สถานะสัตว์เลี้ยง (AC-2, game-rules.md §2)
  // ---------------------------------------------------------------------------

  static PetMood moodFor(int cups) {
    if (cups >= WaterRules.happyMinCups) return PetMood.happy;
    if (cups >= WaterRules.tiredMinCups) return PetMood.tired;
    return PetMood.critical;
  }

  static String moodText(PetMood mood) {
    switch (mood) {
      case PetMood.critical:
        return WaterRules.statusCriticalText;
      case PetMood.tired:
        return WaterRules.statusTiredText;
      case PetMood.happy:
        return WaterRules.statusHappyText;
    }
  }

  static String moodImage(PetMood mood) {
    switch (mood) {
      case PetMood.critical:
        return WaterRules.petCriticalImage;
      case PetMood.tired:
        return WaterRules.petTiredImage;
      case PetMood.happy:
        return WaterRules.petHappyImage;
    }
  }

  // ---------------------------------------------------------------------------
  // รอบวัน 05:00 น. (US-5, AC-5, EC-2)
  // ---------------------------------------------------------------------------

  /// วันที่ "ตามรอบวัน" ที่เริ่มเวลา 05:00 น.
  /// เช่น 2026-10-08 04:59 → 2026-10-07, 2026-10-08 05:00 → 2026-10-08
  static DateTime logicalDay(DateTime now) {
    // ใช้ constructor ของ DateTime (ไม่ใช่ subtract Duration) เพื่อไม่ให้
    // การเปลี่ยนเวลาออมแสง (DST) ทำให้วันเพี้ยน
    final shifted = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour - WaterRules.dailyResetHour,
      now.minute - WaterRules.dailyResetMinute,
    );
    return DateTime(shifted.year, shifted.month, shifted.day);
  }

  /// ต้องรีเซ็ตหรือไม่: รีเซ็ตเมื่อรอบวันปัจจุบันอยู่ "หลัง" รอบวันของการบันทึกล่าสุด
  static bool needsDailyReset(WaterState state, DateTime now) {
    final last = state.lastLoggedAt;
    if (last == null) return false;
    // ASSUMPTION: ถ้านาฬิกาเครื่องถูกตั้งย้อนกลับไปก่อนรอบวันของการบันทึกล่าสุด
    // จะไม่รีเซ็ต (ไม่ลบข้อมูลของวันนี้ทิ้ง) — เอกสารไม่ได้กำหนดกรณีนี้
    return logicalDay(now).isAfter(logicalDay(last));
  }

  /// คืนสถานะหลังตรวจรีเซ็ตรายวัน: จำนวนแก้ว (และพลังงาน) กลับเป็น 0
  /// ประวัติรายวันและเวลาบันทึกล่าสุดยังเก็บไว้
  static WaterState applyDailyReset(WaterState state, DateTime now) {
    if (!needsDailyReset(state, now)) return state;
    return WaterState(
      cups: 0,
      // DECIDED: team 2026-10-08 — ห้ามกดซ้ำ 5 นาทียังนับต่อแม้ข้ามเวลารีเซ็ต
      // 05:00 จึงเก็บ last_logged_timestamp ไว้หลังรีเซ็ต (game-rules.md §4
      // เช่น บันทึก 04:58 กด 05:01 ถูกบล็อก บันทึกได้ตั้งแต่ 05:03)
      lastLoggedAt: state.lastLoggedAt,
      history: state.history,
    );
  }

  // ---------------------------------------------------------------------------
  // Anti-Spam (US-4, AC-3, AC-4, EC-3)
  // ---------------------------------------------------------------------------

  static const Duration antiSpamInterval =
      Duration(minutes: WaterRules.antiSpamIntervalMinutes);

  /// บันทึกได้หรือไม่ — ต้องผ่านไปแล้ว "อย่างน้อย" 5 นาที (AC-4: 10:00 → 10:05 ได้)
  static bool canLog(DateTime? lastLoggedAt, DateTime now) {
    if (lastLoggedAt == null) return true;
    final elapsed = now.difference(lastLoggedAt);
    // ASSUMPTION: ถ้าเวลาปัจจุบันอยู่ก่อนเวลาบันทึกล่าสุด (นาฬิกาเครื่องถูกตั้งย้อน)
    // ให้อนุญาตบันทึก เพื่อไม่ให้ผู้ใช้ถูกล็อกนานผิดปกติ — เอกสารไม่ได้กำหนดกรณีนี้
    if (elapsed.isNegative) return true;
    return elapsed >= antiSpamInterval;
  }

  /// เวลาที่เหลือก่อนบันทึกได้อีกครั้ง (Duration.zero ถ้าบันทึกได้แล้ว)
  static Duration remainingCooldown(DateTime? lastLoggedAt, DateTime now) {
    if (canLog(lastLoggedAt, now)) return Duration.zero;
    return antiSpamInterval - now.difference(lastLoggedAt!);
  }

  // ---------------------------------------------------------------------------
  // บันทึกน้ำ (AC-1, AC-3, AC-4)
  // ---------------------------------------------------------------------------

  /// กดบันทึกน้ำ 1 ครั้ง ณ เวลา `now`
  /// - ตรวจรีเซ็ตรายวันก่อน (EC-2)
  /// - ถ้าติด Anti-Spam: จำนวนแก้วและเวลาบันทึกล่าสุดไม่เปลี่ยน (AC-3)
  /// - ถ้าผ่าน: +1 แก้ว, อัปเดตเวลาบันทึกล่าสุด = now, อัปเดตประวัติของวันนี้ (AC-1, AC-4)
  static LogWaterResult logWater(WaterState state, DateTime now) {
    final current = applyDailyReset(state, now);
    if (!canLog(current.lastLoggedAt, now)) {
      return LogWaterResult(LogWaterOutcome.blockedBySpam, current);
    }
    final newCups = current.cups + WaterRules.waterIncrementPerCup;
    final next = WaterState(
      cups: newCups,
      lastLoggedAt: now,
      history: upsertHistory(current.history, logicalDay(now), newCups),
    );
    return LogWaterResult(LogWaterOutcome.logged, next);
  }

  /// ใส่/แทนที่จำนวนแก้วของวันที่กำหนดในประวัติ (คืน list ใหม่ เรียงตามวันที่)
  static List<DailyWaterRecord> upsertHistory(
    List<DailyWaterRecord> history,
    DateTime day,
    int cups,
  ) {
    final dayOnly = DateTime(day.year, day.month, day.day);
    final result = [
      for (final r in history)
        if (r.date != dayOnly) r,
      DailyWaterRecord(date: dayOnly, cups: cups),
    ]..sort((a, b) => a.date.compareTo(b.date));
    return List.unmodifiable(result);
  }

  // ---------------------------------------------------------------------------
  // รายงานรายเดือน (US-3, AC-6)
  // ---------------------------------------------------------------------------

  /// รายงานของเดือนตามรอบวันของ `now`
  /// ค่าเฉลี่ย = (ผลรวมน้ำตลอดเดือน) / (จำนวนวันที่บันทึก)
  static MonthlyWaterReport monthlyReport(
    List<DailyWaterRecord> history,
    DateTime now,
  ) {
    // ASSUMPTION: "เดือนนี้" ใช้เดือนของรอบวัน 05:00 น. (เช่น 1 พ.ย. 03:00 ยังนับเป็นเดือน ต.ค.)
    final today = logicalDay(now);
    // DECIDED: team 2026-10-08 — "จำนวนวันที่บันทึก" นับเฉพาะวันที่มีการบันทึก
    // (cups > 0) วันที่ไม่ได้บันทึกเลยไม่นำมาหาร (requirements.md AC-6, §8)
    final records = history
        .where((r) =>
            r.date.year == today.year &&
            r.date.month == today.month &&
            r.cups > 0)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final total = records.fold<int>(0, (sum, r) => sum + r.cups);
    final average = records.isEmpty ? 0.0 : total / records.length;
    return MonthlyWaterReport(
      year: today.year,
      month: today.month,
      records: List.unmodifiable(records),
      totalCups: total,
      average: average,
    );
  }

  /// แสดงค่าเฉลี่ยทศนิยม 1 ตำแหน่ง (AC-6) เช่น 4.5, 0.0
  static String formatAverage(double average) =>
      average.toStringAsFixed(WaterRules.monthlyAverageDecimals);
}
