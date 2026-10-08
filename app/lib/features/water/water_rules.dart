/// ค่าคงที่กติกาเกมของฟีเจอร์ water (บันทึกการกินน้ำ)
///
/// ตัวเลขทุกตัวมาจาก docs/water/game-rules.md — ห้ามแก้ตัวเลขที่นี่โดยไม่แก้เอกสารก่อน
/// ค่าที่เอกสารไม่ได้กำหนดจะมีคอมเมนต์ ASSUMPTION กำกับ
class WaterRules {
  WaterRules._();

  // ---------------------------------------------------------------------------
  // game-rules.md §1 ค่าหลัก
  // ---------------------------------------------------------------------------

  /// water_increment_per_cup — จำนวนแก้วที่เพิ่มต่อการกดบันทึก 1 ครั้ง (US-1, AC-1)
  static const int waterIncrementPerCup = 1;

  /// energy_increment_percentage — % พลังงานที่เพิ่มต่อ 1 แก้ว (AC-1)
  static const double energyIncrementPercentage = 12.5;

  /// energy_max_display_percentage — % สูงสุดของหลอดพลังงานบน UI (AC-1, EC-1)
  static const double energyMaxDisplayPercentage = 100;

  /// anti_spam_interval_minutes — ระยะป้องกันการกดซ้ำ (US-4, AC-3, AC-4)
  static const int antiSpamIntervalMinutes = 5;

  /// daily_reset_hour — เวลารีเซ็ตรายวัน 05:00 น. (US-5, AC-5)
  static const int dailyResetHour = 5;

  /// daily_reset_hour — ส่วนนาทีของ 05:00 น. (US-5, AC-5)
  static const int dailyResetMinute = 0;

  // ---------------------------------------------------------------------------
  // game-rules.md §2 สถานะ/อารมณ์ของสัตว์เลี้ยง (ช่วงรวมขอบ)
  // ---------------------------------------------------------------------------

  /// เหี่ยวเฉา ป่วย ใกล้ตาย: 0 ถึง 3 แก้ว (รวมขอบ) → ขั้นต่ำของสถานะถัดไปคือ 4
  /// เริ่มเพลีย อ่อนแรง แลบลิ้น: 4 ถึง 6 แก้ว (รวมขอบ) (AC-2)
  static const int tiredMinCups = 4;

  /// สดชื่น ร่าเริง มีความสุข: 7 แก้วขึ้นไป (รวม 7)
  static const int happyMinCups = 7;

  static const String statusCriticalText = 'เหี่ยวเฉา ป่วย ใกล้ตาย';
  static const String statusTiredText = 'เริ่มเพลีย อ่อนแรง แลบลิ้น';
  static const String statusHappyText = 'สดชื่น ร่าเริง มีความสุข';

  static const String petCriticalImage = 'assets/images/pet_critical.png';
  static const String petTiredImage = 'assets/images/pet_tired.png';
  static const String petHappyImage = 'assets/images/pet_happy.png';

  // ---------------------------------------------------------------------------
  // ux-flow.md §5 ไอคอน
  // ---------------------------------------------------------------------------
  static const String waterPlusIcon = 'assets/icons/water_plus.png';
  static const String calendarReportIcon = 'assets/icons/calendar_report.png';

  // ---------------------------------------------------------------------------
  // AC-6 / ux-flow.md S-2 — ค่าเฉลี่ยแสดงทศนิยม 1 ตำแหน่ง
  // ---------------------------------------------------------------------------
  static const int monthlyAverageDecimals = 1;

  // ---------------------------------------------------------------------------
  // ค่าที่เอกสารยังไม่กำหนด
  // ---------------------------------------------------------------------------

  /// ระยะเวลาแสดง Toast Anti-Spam
  // ASSUMPTION: ค่าชั่วคราว รอคำตอบ — ux-flow.md §6 และ game-rules.md §5 ถาม Product
  // ไว้ว่า 2-3 วินาทีหรือไม่ ยังไม่มีคำตอบ ใช้ 2 วินาทีไปก่อน
  static const int antiSpamToastSeconds = 2;

  // ---------------------------------------------------------------------------
  // ข้อความบนหน้าจอ (ux-flow.md §2, §4)
  // ---------------------------------------------------------------------------
  static const String antiSpamMessage = 'กรุณารอสักครู่ (1 แก้วต่อ 5 นาที)';
  static const String logButtonText = 'ดื่มน้ำ 1 แก้ว';
  static const String monthlyReportButtonText = 'รายงานรายเดือน';
  static const String monthlyReportHeader = 'รายงานการดื่มน้ำประจำเดือน';
  static const String monthlyEmptyText = 'ยังไม่มีประวัติการดื่มน้ำในเดือนนี้';
  static const String backButtonText = 'ย้อนกลับ';

  static String waterCountText(int cups) => 'จำนวนน้ำ: $cups แก้ว';
  static String monthlyAverageText(String average) =>
      'ค่าเฉลี่ย: $average แก้ว/วัน';
}
