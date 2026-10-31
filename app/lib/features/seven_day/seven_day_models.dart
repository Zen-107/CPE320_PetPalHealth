/// โมเดลของฟีเจอร์ 7day — ไม่มีข้อมูลที่เก็บลงเครื่อง (ค่าทั้งหมดอ่านจาก controller เดิม — D-5)
library;

/// สถานะหน้าจอ S-1 (ux-flow §4 · ui-spec §3) — ไม่มี OFFLINE (DECIDED owner D-2)
enum SevenDayStatus {
  /// `count == 7`
  normal,

  /// `0 < count < 7` (AC-3, EC-1)
  inconsistent,

  /// `count == 0` (AC-6, EC-3)
  empty,
}

/// ข้อมูล 1 วันในหน้าต่าง 7 วัน (Day 0 … Day −6)
class SevenDayEntry {
  const SevenDayEntry({
    required this.offset,
    required this.date,
    required this.waterCups,
    required this.steps,
    required this.calories,
    this.highSodium = false,
    this.highSugar = false,
    this.overeating = false,
  });

  /// 0 = วันนี้ (Day 0), 1 = เมื่อวาน (Day −1) … 6 (Day −6) — ใช้เป็น index ของ key `<i>`
  final int offset;

  /// วันตามรอบ 05:00 (ปี/เดือน/วัน)
  final DateTime date;

  /// แก้ว (`DailyWaterRecord.cups`) — ไม่มี record = 0
  final int waterCups;

  /// ก้าว — ไม่มี record = 0
  final int steps;

  /// kcal — ไม่มี record = 0
  final int calories;

  /// ป้าย 「โซเดียมสูง」
  final bool highSodium;

  /// ป้าย 「น้ำตาลสูง」
  final bool highSugar;

  /// ป้าย 「Overeating」
  final bool overeating;

  bool get isToday => offset == 0;

  /// "วันที่มีบันทึก" — หมวดใดหมวดหนึ่ง > 0
  // ASSUMPTION: ui-spec Q-2 (owner รอบ 2 ใช้ค่าที่ ui-spec เลือก) — ค่า 0 (เช่น steps record 0 ก้าว)
  // = ไม่มีบันทึก
  bool get hasRecord => waterCups > 0 || steps > 0 || calories > 0;

  bool get hasTags => highSodium || highSugar || overeating;

  @override
  String toString() =>
      'SevenDayEntry(-$offset $date water=$waterCups steps=$steps kcal=$calories '
      'sodium=$highSodium sugar=$highSugar over=$overeating)';
}

/// ผลคำนวณของหน้า 7day ณ ขณะหนึ่ง
class SevenDaySnapshot {
  const SevenDaySnapshot({
    required this.today,
    required this.days,
    required this.recordedDays,
    required this.status,
    required this.avgWater,
    required this.avgSteps,
    required this.avgCalories,
    required this.showsInconsistentPrefix,
    required this.showsLowWater,
    required this.showsLowSteps,
  });

  /// Day 0 (วันตามรอบ 05:00)
  final DateTime today;

  /// 7 วัน เรียง Day 0 (index 0) → Day −6 (index 6)
  final List<SevenDayEntry> days;

  /// `count` — จำนวนวันที่มีบันทึก (ใช้ตัดสินสถานะ)
  final int recordedDays;

  final SevenDayStatus status;

  /// ค่าเฉลี่ยดิบรายหมวด (ยังไม่ปัด) — null = หมวดนั้นไม่มีวันที่มีบันทึกเลย
  final double? avgWater;
  final double? avgSteps;
  final double? avgCalories;

  /// PREFIX_INCONSISTENT (AC-3)
  final bool showsInconsistentPrefix;

  /// WARNING_LOW_WATER (AC-4)
  final bool showsLowWater;

  /// WARNING_LOW_STEPS (AC-5)
  final bool showsLowSteps;

  bool get isEmpty => status == SevenDayStatus.empty;

  bool get hasCoaching =>
      showsInconsistentPrefix || showsLowWater || showsLowSteps;
}
