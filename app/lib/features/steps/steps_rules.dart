/// ค่าคงที่กติกาเกมของฟีเจอร์ steps (นับก้าวและตั้งเป้าหมายประจำวัน)
///
/// ตัวเลขกติกาทุกตัวมาจาก docs/steps/game-rules.md (และ AC ใน requirements.md)
/// ข้อความบนจอมาจาก docs/steps/ux-flow.md / ui-spec.md
/// ค่าที่เอกสารไม่ได้กำหนดจะมีคอมเมนต์ ASSUMPTION กำกับ
class StepsRules {
  StepsRules._();

  // ---------------------------------------------------------------------------
  // game-rules.md §1 ค่าหลัก
  // ---------------------------------------------------------------------------

  /// DEFAULT_DAILY_GOAL — เป้าหมายเริ่มต้น (AC-2, game-rules §1, §5 ข้อ 1)
  static const int defaultDailyGoal = 8000;

  /// MIN_DAILY_GOAL — เป้าหมายต่ำสุดที่เลือกได้ (AC-2)
  static const int minDailyGoal = 6000;

  /// MAX_DAILY_GOAL — เป้าหมายสูงสุดที่เลือกได้ (AC-2)
  static const int maxDailyGoal = 15000;

  /// DAILY_GOAL_QUOTA — เปลี่ยนเป้าหมายได้สูงสุดกี่ครั้งต่อรอบวัน (AC-3)
  static const int dailyGoalQuota = 1;

  /// RESET_CUTOFF_HOUR — เวลาตัดรอบ 05:00:00 น. (AC-4, AC-6)
  static const int resetCutoffHour = 5;

  /// RESET_CUTOFF_HOUR — ส่วนนาทีของ 05:00:00 น. (AC-4, AC-6)
  static const int resetCutoffMinute = 0;

  /// STEP_TOLERANCE_PCT — ความคลาดเคลื่อนเซนเซอร์สูงสุด (AC-1)
  /// MVP กรอกก้าวด้วยมือ (ui-spec D-1) จึงไม่มีความคลาดเคลื่อนจากฮาร์ดแวร์ — เก็บค่าไว้อ้างอิง
  static const int stepTolerancePct = 5;

  // ---------------------------------------------------------------------------
  // AC-2 / ux-flow.md S-2 ตัวเลือกเป้าหมาย 3 กลุ่ม (อยู่ในช่วง MIN..MAX)
  // ---------------------------------------------------------------------------
  static const List<int> generalGoals = [6000, 7000, 8000];
  static const List<int> weightControlGoals = [9000, 10000, 11000, 12000];
  static const List<int> athleteGoals = [13000, 14000, 15000];

  static const List<int> allGoals = [
    ...generalGoals,
    ...weightControlGoals,
    ...athleteGoals,
  ];

  // ---------------------------------------------------------------------------
  // game-rules.md §2 สถานะสัตว์เลี้ยง (% Goal, ขอบล่างรวม ขอบบนไม่รวม)
  // FAT [0, 35) · CHUBBY [35, 70) · LEAN [70, 100) · MUSCLE [100, ∞)
  // ---------------------------------------------------------------------------
  static const double chubbyMinPercent = 35;
  static const double leanMinPercent = 70;
  static const double muscleMinPercent = 100;

  static const String statusFatText = 'อ้วนอืด';
  static const String statusChubbyText = 'จ่ำม่ำ';
  static const String statusLeanText = 'หุ่นลีน (สมส่วน)';
  static const String statusMuscleText = 'มีกล้ามขา';

  static const String petFatImage = 'assets/images/pet_fat.png';
  static const String petChubbyImage = 'assets/images/pet_chubby.png';
  static const String petLeanImage = 'assets/images/pet_lean.png';
  static const String petMuscleImage = 'assets/images/pet_muscle.png';

  // ---------------------------------------------------------------------------
  // ui-spec D-1 / Q-2 ปุ่มเพิ่มก้าวเดินด้วยมือ
  // ---------------------------------------------------------------------------

  // ASSUMPTION: ค่าชั่วคราว รอคำตอบ — จำนวนก้าวที่เพิ่มต่อการกดปุ่ม 1 ครั้ง
  // ไม่มีใน game-rules.md (ui-spec Q-2) เลือก 1,000 ให้ทดลองเห็นครบ 4 สถานะได้ในไม่กี่ครั้ง
  static const int stepsPerTap = 1000;

  // ---------------------------------------------------------------------------
  // ux-flow.md §5 / ui-spec §2.1 ภาพและไอคอน
  // ---------------------------------------------------------------------------
  static const String dashboardBackground = 'assets/images/bg_dashboard.png';
  static const String targetIcon = 'assets/icons/ic_target.png';
  static const String reportIcon = 'assets/icons/ic_report.png';

  // ---------------------------------------------------------------------------
  // ระยะแสดง Toast
  // ---------------------------------------------------------------------------

  // ASSUMPTION: เอกสารไม่กำหนดระยะแสดง Toast ของ steps — ใช้ 2 วินาทีเท่า water
  // ตาม ui-spec §1.3 / Q-8
  static const int toastSeconds = 2;

  // ASSUMPTION: ค่าเฉลี่ยรายวันในรายงานแสดงทศนิยม 1 ตำแหน่ง เท่า water (ui-spec Q-10)
  static const int monthlyAverageDecimals = 1;

  // ---------------------------------------------------------------------------
  // ข้อความบนหน้าจอ (ux-flow.md §2, §4 / ui-spec §2–§3)
  // ---------------------------------------------------------------------------

  // S-1
  static const String dashboardTitle = 'ก้าวเดินประจำวัน';
  static const String entryButtonText = dashboardTitle; // ui-spec §2.0 (Q-3)
  static const String setGoalButtonText = 'ตั้งเป้าหมาย';
  static const String monthlyReportButtonText = 'รายงานสรุปรายเดือน';
  // ASSUMPTION: ข้อความเสนอใน ui-spec (Q-1) รอยืนยัน
  static const String addStepsButtonText = 'เพิ่มก้าวเดิน';
  // ASSUMPTION: ข้อความเสนอใน ui-spec (Q-5) รอยืนยัน
  static const String offlineTooltip = 'ออฟไลน์';
  // ASSUMPTION: ข้อความเสนอใน ui-spec (Q-4) รอยืนยัน
  static const String sensorErrorTitle = 'ไม่สามารถนับก้าวเดินได้';
  static const String sensorErrorContent =
      'กรุณาอนุญาตสิทธิ์เซนเซอร์นับก้าวในหน้า Settings ของเครื่อง';
  static const String openSettingsButtonText = 'ไปที่ Settings';

  // S-2
  static const String goalTitle = 'ตั้งเป้าหมายก้าวเดินประจำวัน';
  static const String goalGroupGeneral = 'กลุ่มเป้าหมายทั่วไป';
  static const String goalGroupWeight = 'กลุ่มควบคุมน้ำหนัก';
  static const String goalGroupAthlete = 'กลุ่มนักกีฬา';
  static const String saveGoalButtonText = 'บันทึกเป้าหมาย';
  static const String goalQuotaMessage =
      'คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวัน';
  static const String goalErrorMessage =
      'ไม่สามารถบันทึกเป้าหมายได้ กรุณาลองใหม่อีกครั้ง';

  // S-3
  static const String reportTitle = 'รายงานสุขภาพประจำเดือน';
  static const String reportTotalStepsLabel = 'ก้าวเดินรวมประจำเดือน';
  static const String reportTotalWaterLabel = 'ปริมาณน้ำดื่มรวมประจำเดือน';
  static const String reportAverageLabel = 'ค่าเฉลี่ยก้าวเดินรายวัน';
  static const String reportGoalDaysLabel = 'จำนวนวันที่ทำเป้าหมายสำเร็จ';
  static const String reportEmptyText = 'ยังไม่มีข้อมูลสรุปผลในเดือนนี้';
  static const String exportButtonText = 'ดาวน์โหลดรายงาน (PNG)';
  static const String exportingText = 'กำลังสร้างรายงาน...';
  static const String exportErrorMessage =
      'ไม่สามารถสร้างไฟล์ภาพรายงานได้ในขณะนี้';
  static const String retryButtonText = 'ลองใหม่อีกครั้ง';

  static const String backButtonText = 'ย้อนกลับ';

  // ASSUMPTION: หน่วยในการ์ดรายงาน (ui-spec Q-10) — น้ำใช้ "แก้ว" เท่าฟีเจอร์ water
  static const String stepsUnit = 'ก้าว';
  static const String waterUnit = 'แก้ว';
  static const String averageUnit = 'ก้าว/วัน';
  static const String daysUnit = 'วัน';
}
