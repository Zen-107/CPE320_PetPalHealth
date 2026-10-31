/// logic ของฟีเจอร์ 7day (pure Dart — ไม่ขึ้นกับ widget, รับเวลาปัจจุบันเป็นพารามิเตอร์)
///
/// อ่านอย่างเดียวจาก state ของ water / steps / food (ui-spec §2.2, DECIDED owner D-5) —
/// ไม่เก็บข้อมูลซ้ำ ไม่อ่าน shared_preferences เอง
/// ใช้รอบวัน (logicalDay / state.day) และฟังก์ชัน format เดิมของฟีเจอร์อื่น
library;

import '../food/food_models.dart';
import '../steps/steps_logic.dart';
import '../steps/steps_models.dart';
import '../water/water_logic.dart';
import '../water/water_models.dart';
import 'seven_day_models.dart';
import 'seven_day_rules.dart';

class SevenDayLogic {
  SevenDayLogic._();

  // ---------------------------------------------------------------------------
  // รอบวัน (US-3, EC-4 — DECIDED owner D-4: 05:00 เวลาเครื่อง เหมือนทุกฟีเจอร์)
  // ---------------------------------------------------------------------------

  /// วันตามรอบ 05:00 ของ [now] — ฟังก์ชันเดิมของ water (ไม่เขียนรอบวันใหม่)
  static DateTime logicalDay(DateTime now) => WaterLogic.logicalDay(now);

  /// Day 0 ของหน้าต่าง 7 วัน
  ///
  /// = วันล่าสุดในบรรดา `state.day` ของ steps / food (รอบวันที่ controller เดิมคำนวณจากนาฬิกาของ
  /// ตัวเองแล้ว) — ถ้ายังไม่มีทั้งคู่ใช้ `logicalDay(now)`
  // ASSUMPTION: ui-spec §2.2 ให้ใช้ "logical day แบบเดียวกับฟีเจอร์เดิม" แต่ไม่บอกว่ายึดนาฬิกาตัวไหน
  // เลือกยึด state.day ของ controller เดิมเพื่อให้ Day 0 ตรงกับค่า "วันนี้" ที่ steps / food ถืออยู่เสมอ
  // (กรณีนาฬิกาเครื่องย้อน steps / food ไม่ย้อนรอบวัน — 7day ก็ไม่ย้อนตาม) และไม่ต้องมีนาฬิกาแยก
  // ที่อาจไม่ตรงกับ controller · ข้าม 05:00 → controller เดิม rollover → Day 0 เลื่อนตาม (EC-4)
  static DateTime currentDay({
    required DateTime now,
    DateTime? stepsDay,
    DateTime? foodDay,
  }) {
    DateTime? latest;
    for (final d in [stepsDay, foodDay]) {
      if (d == null) continue;
      final day = _dateOnly(d);
      if (latest == null || day.isAfter(latest)) latest = day;
    }
    return latest ?? logicalDay(now);
  }

  /// Day −[offset] = `DateTime(today.year, today.month, today.day - offset)` (ui-spec §2.2)
  static DateTime dayAt(DateTime today, int offset) =>
      DateTime(today.year, today.month, today.day - offset);

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // ---------------------------------------------------------------------------
  // ข้อมูลรายวัน (ui-spec §2.2)
  // ---------------------------------------------------------------------------

  /// ข้อมูล 7 วัน Day 0 → Day −6 (AC-1)
  ///
  /// - water: `history` record ของวันนั้น → `cups` (history รวมวันนี้ — upsert ทุกครั้งที่บันทึก)
  /// - steps / food: วันที่ตรงกับ `state.day` ใช้ค่าปัจจุบัน (`steps` / `totalCalories` / meals)
  ///   วันอื่นใช้ `history` · ไม่มี record = 0
  /// - [foodCurrentOverLimit] = `FoodController.isOverLimit` (ป้าย Overeating ของวันปัจจุบันของ food)
  static List<SevenDayEntry> buildDays({
    required DateTime today,
    required List<DailyWaterRecord> waterHistory,
    required StepsState steps,
    required FoodState food,
    required bool foodCurrentOverLimit,
  }) {
    return List.unmodifiable([
      for (var i = 0; i < SevenDayRules.maxHistoryDays; i++)
        _entryFor(
          offset: i,
          date: dayAt(today, i),
          waterHistory: waterHistory,
          steps: steps,
          food: food,
          foodCurrentOverLimit: foodCurrentOverLimit,
        ),
    ]);
  }

  static SevenDayEntry _entryFor({
    required int offset,
    required DateTime date,
    required List<DailyWaterRecord> waterHistory,
    required StepsState steps,
    required FoodState food,
    required bool foodCurrentOverLimit,
  }) {
    // water
    var cups = 0;
    for (final r in waterHistory) {
      if (_sameDay(r.date, date)) cups = r.cups;
    }

    // steps
    var stepCount = 0;
    final stepsDay = steps.day;
    if (stepsDay != null && _sameDay(stepsDay, date)) {
      stepCount = steps.steps;
    } else {
      for (final r in steps.history) {
        if (_sameDay(r.date, date)) stepCount = r.steps;
      }
    }

    // food
    var kcal = 0;
    var sodium = false;
    var sugar = false;
    var over = false;
    final foodDay = food.day;
    if (foodDay != null && _sameDay(foodDay, date)) {
      kcal = food.totalCalories;
      sodium = food.todayHighSodium;
      sugar = food.todayHighSugar;
      over = foodCurrentOverLimit;
    } else {
      for (final r in food.history) {
        if (!_sameDay(r.date, date)) continue;
        kcal = r.totalCalories;
        sodium = r.highSodium;
        sugar = r.highSugar;
        // ASSUMPTION: ui-spec Q-20 — ใช้ isOverTarget ที่เก็บไว้ตอนตัดรอบ (ไม่คำนวณย้อนหลัง)
        over = r.isOverTarget;
      }
    }

    return SevenDayEntry(
      offset: offset,
      date: date,
      // EC-4 ของ dashboard: ค่าติดลบ (ข้อมูลเสีย) ไม่ควรเกิด — กันไว้ให้เป็น 0
      waterCups: cups < 0 ? 0 : cups,
      steps: stepCount < 0 ? 0 : stepCount,
      calories: kcal < 0 ? 0 : kcal,
      highSodium: sodium,
      highSugar: sugar,
      overeating: over,
    );
  }

  // ---------------------------------------------------------------------------
  // ค่าเฉลี่ย + coaching (AC-2..AC-6, game-rules §1.1, §3, §4)
  // ---------------------------------------------------------------------------

  /// `sum(values) / count(values > 0)` — ไม่มีค่า > 0 เลย → null (AC-2, AC-3, EC-2)
  // ASSUMPTION: ui-spec Q-2 / Q-16 (owner รอบ 2) — ตัวหารรายหมวด = วันที่หมวดนั้น > 0 และนับ Day 0
  // เมื่อหมวดนั้น > 0
  static double? averageOfRecorded(Iterable<int> values) {
    var sum = 0;
    var count = 0;
    for (final v in values) {
      if (v <= 0) continue;
      sum += v;
      count++;
    }
    if (count == 0) return null;
    return sum / count;
  }

  /// ค่าเฉลี่ยหลังปัดทศนิยม 1 ตำแหน่ง — ค่าเดียวกับที่แสดงบนจอ
  static double roundedAverage(double average) =>
      double.parse(average.toStringAsFixed(SevenDayRules.averageDecimals));

  /// `avg_water < 8.0` เทียบค่าที่ปัดแล้ว — null (ไม่มีข้อมูล) = ไม่เตือน
  // ASSUMPTION: ui-spec Q-10 — เทียบค่าที่ปัด 1 ตำแหน่ง (7.96 → 8.0 ไม่เตือน) · Q-8 ไม่มีข้อมูล = ไม่เตือน
  static bool isLowWater(double? avgWater) =>
      avgWater != null &&
      roundedAverage(avgWater) < SevenDayRules.waterGoalThreshold;

  /// `avg_steps < 8000.0` เทียบค่าที่ปัดแล้ว — null = ไม่เตือน
  // ASSUMPTION: ui-spec Q-10 / Q-8 (เหมือน isLowWater)
  static bool isLowSteps(double? avgSteps) =>
      avgSteps != null &&
      roundedAverage(avgSteps) < SevenDayRules.stepsGoalThreshold;

  /// count → สถานะ (ux-flow §4)
  static SevenDayStatus statusFor(int recordedDays) {
    if (recordedDays <= 0) return SevenDayStatus.empty;
    if (recordedDays < SevenDayRules.maxHistoryDays) {
      return SevenDayStatus.inconsistent;
    }
    return SevenDayStatus.normal;
  }

  /// สรุปจาก 7 วันที่สร้างแล้ว
  static SevenDaySnapshot summarize(DateTime today, List<SevenDayEntry> days) {
    final count = days.where((d) => d.hasRecord).length;
    final status = statusFor(count);
    final avgWater = averageOfRecorded(days.map((d) => d.waterCups));
    final avgSteps = averageOfRecorded(days.map((d) => d.steps));
    final avgKcal = averageOfRecorded(days.map((d) => d.calories));
    // ASSUMPTION: ui-spec Q-3 — EMPTY ซ่อน SUMMARY_CARD จึงไม่มี coaching ใด ๆ
    final isEmpty = status == SevenDayStatus.empty;
    return SevenDaySnapshot(
      today: today,
      days: days,
      recordedDays: count,
      status: status,
      avgWater: avgWater,
      avgSteps: avgSteps,
      avgCalories: avgKcal,
      showsInconsistentPrefix: status == SevenDayStatus.inconsistent,
      showsLowWater: !isEmpty && isLowWater(avgWater),
      showsLowSteps: !isEmpty && isLowSteps(avgSteps),
    );
  }

  /// ทั้งหน้า ณ เวลา [now] จาก state ของ 3 ฟีเจอร์
  static SevenDaySnapshot snapshot({
    required DateTime now,
    required List<DailyWaterRecord> waterHistory,
    required StepsState steps,
    required FoodState food,
    required bool foodCurrentOverLimit,
  }) {
    final today =
        currentDay(now: now, stepsDay: steps.day, foodDay: food.day);
    final days = buildDays(
      today: today,
      waterHistory: waterHistory,
      steps: steps,
      food: food,
      foodCurrentOverLimit: foodCurrentOverLimit,
    );
    return summarize(today, days);
  }

  // ---------------------------------------------------------------------------
  // ข้อความบนจอ (ใช้ฟังก์ชัน format เดิม — ui-spec §2 "รูปแบบตัวเลข")
  // ---------------------------------------------------------------------------

  /// ค่าเฉลี่ยทศนิยม 1 ตำแหน่ง + comma (`StepsLogic.formatAverage`) เช่น 6.5, 7,240.5
  // ASSUMPTION: ui-spec Q-12 — comma ทุกหมวด
  static String formatAverage(double average) =>
      StepsLogic.formatAverage(average);

  static String? _avgOrNull(double? avg) =>
      avg == null ? null : formatAverage(avg);

  static String avgWaterText(SevenDaySnapshot s) =>
      SevenDayRules.avgWaterText(_avgOrNull(s.avgWater));
  static String avgStepsText(SevenDaySnapshot s) =>
      SevenDayRules.avgStepsText(_avgOrNull(s.avgSteps));
  static String avgFoodText(SevenDaySnapshot s) =>
      SevenDayRules.avgFoodText(_avgOrNull(s.avgCalories));

  /// บรรทัด coaching น้ำ (null = ไม่แสดง) — {val} = ค่าเดียวกับบรรทัดค่าเฉลี่ย
  static String? lowWaterText(SevenDaySnapshot s) => s.showsLowWater
      ? SevenDayRules.warningLowWater(formatAverage(s.avgWater!))
      : null;

  /// บรรทัด coaching ก้าว (null = ไม่แสดง)
  static String? lowStepsText(SevenDaySnapshot s) => s.showsLowSteps
      ? SevenDayRules.warningLowSteps(formatAverage(s.avgSteps!))
      : null;

  /// ข้อความ coaching เรียง prefix → น้ำ → ก้าว (game-rules §1.1 หมายเหตุ) — คนละบรรทัด
  // ASSUMPTION: ui-spec Q-9 — prefix เป็นบรรทัดของตัวเอง · Q-7 ไม่มีข้อความกรณีปกติ
  static List<String> coachingLines(SevenDaySnapshot s) => [
        if (s.showsInconsistentPrefix) SevenDayRules.prefixInconsistent,
        ?lowWaterText(s),
        ?lowStepsText(s),
      ];

  /// ก้าว / kcal = จำนวนเต็ม + comma (`StepsLogic.formatThousands`)
  static String formatCount(int value) => StepsLogic.formatThousands(value);

  /// แก้ว = จำนวนเต็มไม่มี comma (water เก็บ int)
  // ASSUMPTION: ui-spec Q-13 — แสดงแก้วรายวันเป็นจำนวนเต็ม
  static String formatCups(int cups) => '$cups';

  /// `{date_str}` = dd/MM/yyyy (`WaterLogic.formatHistoryDate`)
  // ASSUMPTION: ui-spec Q-11
  static String formatDate(DateTime date) => WaterLogic.formatHistoryDate(date);

  /// `{day_label}` — Day 0 「วันนี้」, Day −1 「เมื่อวาน」, Day −2…−6 ชื่อวันไทย
  static String dayLabel(SevenDayEntry e) {
    if (e.offset == 0) return SevenDayRules.todayLabel;
    if (e.offset == 1) return SevenDayRules.yesterdayLabel;
    return SevenDayRules.weekdayLabels[e.date.weekday]!;
  }

  /// หัวการ์ด `วันนี้, 31/10/2026` / `เมื่อวาน, 30/10/2026` / `วันอังคาร, 27/10/2026`
  static String dayTitle(SevenDayEntry e) =>
      SevenDayRules.dayTitleText(dayLabel(e), formatDate(e.date));

  /// แถบสรุปตอนพับ — วันไม่มีบันทึก = 「ไม่มีข้อมูล」 (AC-2)
  static String collapsedSummary(SevenDayEntry e) => e.hasRecord
      ? SevenDayRules.collapsedSummaryText(
          formatCount(e.steps), formatCups(e.waterCups), formatCount(e.calories))
      : SevenDayRules.statusNoDailyData;

  // ASSUMPTION: ui-spec Q-8 — หมวดที่ไม่มีบันทึกในวันที่หมวดอื่นมี แสดง 0
  static String dayStepsText(SevenDayEntry e) =>
      SevenDayRules.dayStepsText(formatCount(e.steps));
  static String dayWaterText(SevenDayEntry e) =>
      SevenDayRules.dayWaterText(formatCups(e.waterCups));
  static String dayFoodText(SevenDayEntry e) =>
      SevenDayRules.dayFoodText(formatCount(e.calories));

  /// `seven_day_window_<yyyy-MM-dd ของ Day 0>` — เปลี่ยนเมื่อข้ามรอบ → การ์ดกลับค่าเริ่มต้น (EC-4)
  // ASSUMPTION: ui-spec Q-4 — ข้ามรอบแล้วการ์ดทั้งชุดกลับค่าเริ่มต้น
  static String windowKey(DateTime today) =>
      'seven_day_window_${formatDateKey(today)}';
}
