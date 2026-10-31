/// ค่าคงที่กติกา + ข้อความบนจอทั้งหมดของฟีเจอร์ 7day (ประวัติสุขภาพ 7 วันและสรุปภาพรวมสัปดาห์)
///
/// ตัวเลขกติกามาจาก docs/7day/game-rules.md §1, §1.1 และ requirements.md AC-1..AC-6
/// ขนาด/ระยะ/เวลาหน้าจอมาจาก docs/7day/ui-spec.md §1.3 · ข้อความบนจอมาจาก ux-flow.md §2 /
/// game-rules.md §1.1 (ตรงตัว ไม่รวม `"` ตัวคั่น — ui-spec §2) และ ui-spec ("เสนอ — รอยืนยัน")
///
/// 7day ไม่มีข้อมูล / repository / รอบวันของตัวเอง — อ่านจาก WaterController / StepsController /
/// FoodController ตัวเดียวกับหน้า water (DECIDED owner D-5) ไฟล์นี้จึงมีแค่เกณฑ์ + ข้อความ
///
/// ชื่อโฟลเดอร์/คลาสขึ้นต้นด้วย "seven" เพราะ Dart identifier ขึ้นต้นด้วยตัวเลขไม่ได้ (ui-spec §2)
library;

import '../food/food_rules.dart';
import '../water/water_rules.dart';

class SevenDayRules {
  SevenDayRules._();

  // ---------------------------------------------------------------------------
  // game-rules.md §1 ค่าหลัก
  // ---------------------------------------------------------------------------

  /// MAX_HISTORY_DAYS — จำนวนวันที่แสดง (AC-1)
  // DECIDED (owner รอบ 1, D-4): นับรวมวันนี้ Day 0 ถึง Day −6
  static const int maxHistoryDays = 7;

  /// DATE_NORMALIZER_HOUR — ตัดรอบวัน 05:00 (US-3, EC-4)
  // DECIDED (owner รอบ 1, D-4): ตัดรอบ 05:00 "เวลาเครื่อง" เหมือนทุกฟีเจอร์ (แทน ICT / Server Time)
  // อ้างค่าเดียวกับ water (= 5) เพื่อให้รอบวันตรงกับข้อมูลที่อ่านมาเสมอ — logic ใช้
  // WaterLogic.logicalDay และ state.day ของ steps / food (ไม่มีรอบวันของ 7day เอง)
  static const int dateNormalizerHour = WaterRules.dailyResetHour;

  /// WATER_GOAL_THRESHOLD — น้ำเฉลี่ย "ต่ำกว่า" ค่านี้ → WARNING_LOW_WATER (AC-4)
  static const double waterGoalThreshold = 8.0;

  /// STEPS_GOAL_THRESHOLD — ก้าวเฉลี่ย "ต่ำกว่า" ค่านี้ → WARNING_LOW_STEPS (AC-5)
  static const double stepsGoalThreshold = 8000.0;

  /// LOCAL_CACHE_RETENTION_DAYS — เก็บประวัติ 30 วัน (EC-5)
  // DECIDED (owner รอบ 1, D-3 + รอบ 2, Q-19): ใช้กับ food เท่านั้น (FoodRules.historyRetentionDays)
  // water / steps ไม่ตัดประวัติเหมือนเดิม · 7day ไม่เก็บข้อมูลเอง จึงอ้างค่าของ food (ไม่ตั้งเลขซ้ำ)
  static const int localCacheRetentionDays = FoodRules.historyRetentionDays;

  /// ทศนิยมของค่าเฉลี่ย (AC-3 "ทศนิยม 1 ตำแหน่ง") — format ด้วย StepsLogic.formatAverage
  static const int averageDecimals = 1;

  // ---------------------------------------------------------------------------
  // ui-spec §1.3 ขนาด / ระยะ / เวลา (ค่าหน้าตา)
  // ---------------------------------------------------------------------------

  /// Accordion พับ/ขยาย 250 ms
  // DECIDED (owner รอบ 1, OQ-01 / D-1): Accordion 250 ms ตาม ux-flow §6 ข้อ 1 — ไม่ใช้ Instant Toggle
  static const Duration accordionDuration = Duration(milliseconds: 250);

  /// ความถี่ตรวจรอบวันขณะเปิดหน้าค้าง (EC-4) + ตรวจเมื่อแอป resume
  // ASSUMPTION: ui-spec §1.3 (Q-2/Q-3..Q-20 owner รอบ 2 ใช้ค่าที่ ui-spec เลือก) — เอกสารไม่กำหนด
  // ความถี่ ใช้ 1 วินาทีแบบ DashboardRules.dayCheckIntervalSeconds
  static const int dayCheckIntervalSeconds = 1;

  /// ขนาดไอคอนกล่องเปล่าใน EMPTY_STATE_CONTAINER (แทน empty_history_illustration.png)
  // ASSUMPTION: ui-spec §1.3 / Q-6 — PNG ไม่มีใน repo ใช้ Icons.inbox_outlined 48
  static const double emptyIconSize = 48;

  /// ขนาดไอคอนปุ่มทางเข้าบน AppBar ของ water (เท่าปุ่มเดิม)
  static const double entryIconSize = 24;

  // ---------------------------------------------------------------------------
  // ข้อความบนจอ
  // ---------------------------------------------------------------------------

  /// ux-flow §3 ข้อ 1 เมนู 「ประวัติ 7 วัน」 — tooltip ปุ่มไอคอนบน AppBar ของ water
  // DECIDED (owner รอบ 2, Q-1): IconButton ตัวที่ 5
  static const String entryTooltip = 'ประวัติ 7 วัน';

  /// ux-flow §2 APP_BAR_TITLE
  static const String screenTitle = 'ประวัติสุขภาพ 7 วัน';

  /// ux-flow §2 SUMMARY_CARD หัวข้อ
  static const String summaryTitle = 'สรุปภาพรวมรอบ 7 วัน';

  /// game-rules §1.1 PREFIX_INCONSISTENT (AC-3)
  static const String prefixInconsistent =
      'มีการบันทึกไม่สม่ำเสมอ จากข้อมูลการบันทึกเท่าที่มีพบว่า...';

  /// game-rules §1.1 WARNING_LOW_WATER (AC-4) — {val} = ค่าเฉลี่ยทศนิยม 1 ตำแหน่ง
  static String warningLowWater(String val) =>
      'ดื่มน้ำเฉลี่ยวันละ $val แก้ว น้อยไปน้า พยายามกินน้ำมากกว่านี้ แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ';

  /// game-rules §1.1 WARNING_LOW_STEPS (AC-5) — {val} = ค่าเฉลี่ยทศนิยม 1 ตำแหน่ง
  static String warningLowSteps(String val) =>
      'เดินเฉลี่ยวันละ $val ก้าว ขยับอีกนิดน้าเพื่อสุขภาพที่แข็งแรง แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ';

  /// game-rules §1.1 STATUS_EMPTY_7DAYS (AC-6)
  static const String statusEmpty7Days = 'ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้';

  /// game-rules §1.1 STATUS_NO_DAILY_DATA (AC-2)
  static const String statusNoDailyData = 'ไม่มีข้อมูล';

  // หน่วย (ux-flow §2)
  static const String waterUnit = 'แก้ว';
  static const String stepsUnit = 'ก้าว';
  static const String foodUnit = 'kcal';

  // บรรทัดค่าเฉลี่ยใน SUMMARY_CARD (ux-flow §2 · ui-spec §2.1.1 b/c/d)
  static const String avgWaterLabel = 'ค่าเฉลี่ยการดื่มน้ำ';
  static const String avgStepsLabel = 'ค่าเฉลี่ยการเดิน';
  // ASSUMPTION: ui-spec Q-18 — สะกด 「แคลอรี」 ตรงตัวตามเอกสาร 7day (food ใช้ 「แคลอรี่」)
  static const String avgFoodLabel = 'ค่าเฉลี่ยแคลอรี';

  /// `ค่าเฉลี่ยการดื่มน้ำ: 6.5 แก้ว` · ไม่มีข้อมูลทั้งหมวด (val == null) → `ค่าเฉลี่ยการดื่มน้ำ: ไม่มีข้อมูล`
  // ASSUMPTION: ui-spec Q-8 (เสนอ) — หมวดไม่มีบันทึกเลยใน 7 วัน แสดง 「ไม่มีข้อมูล」
  static String avgWaterText(String? val) =>
      '$avgWaterLabel: ${val == null ? statusNoDailyData : '$val $waterUnit'}';
  static String avgStepsText(String? val) =>
      '$avgStepsLabel: ${val == null ? statusNoDailyData : '$val $stepsUnit'}';
  static String avgFoodText(String? val) =>
      '$avgFoodLabel: ${val == null ? statusNoDailyData : '$val $foodUnit'}';

  // บรรทัดรายละเอียดตอนขยาย (ux-flow §2 DAY_CARD_0 — การเดิน → การดื่มน้ำ → แคลอรี)
  static String dayStepsText(String val) => 'การเดิน: $val $stepsUnit';
  static String dayWaterText(String val) => 'การดื่มน้ำ: $val $waterUnit';
  static String dayFoodText(String val) => 'แคลอรี: $val $foodUnit';

  /// แถบสรุปตอนพับ `5,500 ก้าว · 6 แก้ว · 1,250 kcal`
  // ASSUMPTION: ui-spec Q-14 (เสนอ — รอยืนยัน) — ไม่แสดงป้ายตอนพับ
  static const String collapsedSeparator = ' · ';
  static String collapsedSummaryText(String steps, String water, String food) =>
      '$steps $stepsUnit$collapsedSeparator$water $waterUnit'
      '$collapsedSeparator$food $foodUnit';

  // หัวการ์ดรายวัน `{day_label}, {date_str}` (ux-flow §2)
  static const String todayLabel = 'วันนี้';
  // ASSUMPTION: ui-spec Q-11 (เสนอ — รอยืนยัน) — Day −1 = 「เมื่อวาน」 · Day −2…−6 = ชื่อวันไทย
  static const String yesterdayLabel = 'เมื่อวาน';

  /// ชื่อวันไทยตาม `DateTime.weekday` (1 = จันทร์ … 7 = อาทิตย์) — แอปไม่มี package intl
  // ASSUMPTION: ui-spec Q-11 (เสนอ — รอยืนยัน)
  static const Map<int, String> weekdayLabels = {
    DateTime.monday: 'วันจันทร์',
    DateTime.tuesday: 'วันอังคาร',
    DateTime.wednesday: 'วันพุธ',
    DateTime.thursday: 'วันพฤหัสบดี',
    DateTime.friday: 'วันศุกร์',
    DateTime.saturday: 'วันเสาร์',
    DateTime.sunday: 'วันอาทิตย์',
  };

  static String dayTitleText(String dayLabel, String dateStr) =>
      '$dayLabel, $dateStr';

  // ป้ายเตือนพิเศษ (requirements §6 / brief §3) — เรียง โซเดียมสูง → น้ำตาลสูง → Overeating
  static const String tagHighSodium = 'โซเดียมสูง';
  static const String tagHighSugar = 'น้ำตาลสูง';
  // ASSUMPTION: ui-spec Q-18 — 「Overeating」 ภาษาอังกฤษตรงตัวตามเอกสาร
  static const String tagOvereating = 'Overeating';
}
