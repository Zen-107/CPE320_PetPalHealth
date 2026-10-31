/// ค่าคงที่กติกาเกมของฟีเจอร์ food (บันทึกการให้อาหารสัตว์เลี้ยงและโภชนาการ)
///
/// ตัวเลขกติกาทุกตัวมาจาก docs/food/game-rules.md §1 (และ AC / Base Target Reference
/// Table ใน requirements.md §3) · ขนาด/ระยะของหน้าจอมาจาก docs/food/ui-spec.md §1.3
/// ข้อความบนจอมาจาก docs/food/ux-flow.md §2, §4 (ตรงตัว) / ui-spec §2 ("เสนอ — รอยืนยัน")
/// ค่าที่เอกสารไม่ได้กำหนดจะมีคอมเมนต์ ASSUMPTION กำกับ
///
/// ตารางเมนูอาหาร (kcal ต่อเมนู) แยกอยู่ที่ food_menu_table.dart — เป็นข้อมูลโภชนาการ
/// ไม่ใช่ตัวเลขกติกาเกม (Q-17 DECIDED owner ชั่วคราว)
class FoodRules {
  FoodRules._();

  // ---------------------------------------------------------------------------
  // game-rules.md §1 ค่าหลัก
  // ---------------------------------------------------------------------------

  /// AI_PARSING_TIMEOUT — รอผลประมวลผลเมนูได้นานสุด (วินาที) (AC-1)
  /// เกินเวลานี้ถือเป็น AI Parsing Failure → ฟอร์มกรอกแคลอรี่เอง (EC-1)
  static const int aiParsingTimeoutSeconds = 3;

  /// DAILY_RESET_HOUR — ตัดรอบวันใหม่ 05:00 น. (AC-3, US-5)
  // ASSUMPTION: ใช้เวลาท้องถิ่นของเครื่อง (ถือว่าเครื่องตั้งเขต ICT) แบบเดียวกับ water/steps
  // — MVP ไม่มี network/server time
  static const int dailyResetHour = 5;

  /// DAILY_RESET_HOUR — ส่วนนาทีของ 05:00 น.
  static const int dailyResetMinute = 0;

  /// AGE_MIN / AGE_MAX — อายุจำนวนเต็ม รวมขอบทั้งสองด้าน (AC-4, EC-5)
  static const int ageMin = 1;
  static const int ageMax = 120;

  // Base Target Reference Table (requirements §3, game-rules §1) — kcal
  /// MALE_BASE_TARGET_10_12 / FEMALE_BASE_TARGET_10_12
  static const int maleBaseTarget10to12 = 1700;
  static const int femaleBaseTarget10to12 = 1600;

  /// MALE_BASE_TARGET_13_15 / FEMALE_BASE_TARGET_13_15 (Growth Spurt)
  static const int maleBaseTarget13to15 = 2100;
  static const int femaleBaseTarget13to15 = 1800;

  /// MALE_BASE_TARGET_16_18 / FEMALE_BASE_TARGET_16_18
  static const int maleBaseTarget16to18 = 2300;
  static const int femaleBaseTarget16to18 = 1850;

  /// MALE_BASE_TARGET_19_50 / FEMALE_BASE_TARGET_19_50 (ผู้ใหญ่) — AC-5: ชาย 25 ปี = 2,000
  static const int maleBaseTarget19to50 = 2000;
  static const int femaleBaseTarget19to50 = 1600;

  /// MALE_BASE_TARGET_51_UP / FEMALE_BASE_TARGET_51_UP
  static const int maleBaseTarget51up = 1800;
  static const int femaleBaseTarget51up = 1400;

  /// FALLBACK_BASE_TARGET_AGE_1_9_MALE / _FEMALE — อายุ 1–9 ปีใช้ค่ากลุ่ม 10–12
  /// (game-rules §1, §5 กติกาชั่วคราวของ Design)
  static const int fallbackBaseTargetAge1to9Male = 1700;
  static const int fallbackBaseTargetAge1to9Female = 1600;

  /// ขอบล่างของแต่ละช่วงอายุในตาราง Base Target (รวมขอบ) — requirements §3
  /// 1–9 (fallback) · 10–12 · 13–15 · 16–18 · 19–50 · 51 ขึ้นไป
  static const int ageBand10to12Min = 10;
  static const int ageBand13to15Min = 13;
  static const int ageBand16to18Min = 16;
  static const int ageBand19to50Min = 19;
  static const int ageBand51upMin = 51;

  /// BMI_UNDERWEIGHT_THRESHOLD — BMI "ต่ำกว่า" ค่านี้ = ผอม (AC-6)
  static const double bmiUnderweightThreshold = 18.5;

  /// BMI_UNDERWEIGHT_BONUS — บวกเพิ่มจาก Base Target เมื่อผอม (AC-6)
  static const int bmiUnderweightBonus = 400;

  /// BMI_OVERWEIGHT_THRESHOLD — BMI "ตั้งแต่" ค่านี้ = อ้วน/น้ำหนักเกิน (AC-7)
  static const double bmiOverweightThreshold = 23.0;

  /// BMI_OVERWEIGHT_PENALTY — หักออกจาก Base Target เมื่อน้ำหนักเกิน (AC-7)
  static const int bmiOverweightPenalty = 400;

  /// OVER_LIMIT_THRESHOLD — เกินเป้า "มากกว่า" ค่านี้จึงเข้าสถานะเกินเป้า (AC-9, AC-10, EC-3)
  static const int overLimitThreshold = 100;

  /// FALLBACK_DEFAULT_CALORIES — ฟอร์มกรอกเองแต่ปล่อยว่าง (EC-1)
  static const int fallbackDefaultCalories = 300;

  /// EATING_ANIMATION_DURATION — ท่า EATING ชั่วคราว (วินาที) (game-rules §2, Brief #3)
  static const int eatingAnimationSeconds = 2;

  /// ระยะท่า OVER_LIMIT_FEEDING ก่อนกลับเป็น OVER_LIMIT (วินาที)
  // ASSUMPTION: ค่าชั่วคราว รอคำตอบ — game-rules ไม่กำหนด (ui-spec Q-3) ใช้ค่าเดียวกับ
  // EATING_ANIMATION_DURATION ตามที่ ui-spec เลือกไว้ชั่วคราว
  static const int overLimitFeedingSeconds = eatingAnimationSeconds;

  /// TOAST_DURATION — Toast ค้าง (วินาที) (AC-12)
  static const int toastSeconds = 5;

  /// TOAST_ANCHOR_OFFSET — ระยะขอบล่าง Toast ↔ ขอบบนกล่องสัตว์เลี้ยง (px) (AC-12)
  static const double toastAnchorOffset = 12;

  /// HISTORY_RETENTION_DAYS — จำนวนวันประวัติย้อนหลัง (US-1, US-5)
  // ASSUMPTION: 7 วันนับรวมรอบวันปัจจุบัน (วันนี้ + 6 วันก่อนหน้า) ให้ตรงกับโครง
  // Day 0–Day 6 ของฟีเจอร์ 7day — ประวัติที่เก่ากว่านั้นถูกลบตอนตัดรอบวัน
  static const int historyRetentionDays = 7;

  // ---------------------------------------------------------------------------
  // ui-spec §1.3 ขนาด / ระยะ (ไม่ใช่กติกาเกม — ค่าหน้าตา)
  // ---------------------------------------------------------------------------

  /// ขนาดสัตว์เลี้ยง (ui-spec §1.3 = PetCharacter default)
  static const double petSize = 160;

  /// ความสูงช่อง Toast คงที่ (ui-spec §1.3)
  static const double toastSlotHeight = 48;

  /// ความสูง "ขั้นต่ำ" ของช่องพลังงาน ใช้ร่วมกันระหว่างหลอดพลังงานและ CTA Banner
  /// (ui-spec §1.3 = 88, AC-8) — ที่ textScaler 1.0 ทั้งสองแบบพอดีใน 88 จึงสูง 88 เท่ากัน
  /// (ไม่มี layout shift) ตอนใช้จริงค่านี้ถูกคูณด้วย textScaler ของเครื่อง และช่องโตเกินได้
  /// เมื่อเนื้อหาสูงกว่านี้ (ตัวเลขยาว / ตัวอักษรใหญ่) เพื่อไม่ให้ overflow
  // DECIDED (owner ชั่วคราว, รอบแก้บั๊ก): ห้ามล็อกความสูง 88 คงที่ — ใช้เป็น min height แทน
  static const double energySlotMinHeight = 88;

  // ---------------------------------------------------------------------------
  // ค่าที่เอกสารไม่ได้กำหนด
  // ---------------------------------------------------------------------------

  // ASSUMPTION: ค่าชั่วคราว รอคำตอบ — ช่องแคลอรี่สำรองรับเลขได้ไม่เกิน 5 หลัก (≤ 99,999 kcal)
  // กัน int ล้น/ค่าเพี้ยน เอกสารไม่กำหนดค่าสูงสุด
  static const int manualCaloriesMaxDigits = 5;

  // ASSUMPTION: ค่าชั่วคราว รอคำตอบ — จำนวนที่ตามหลังชื่อเมนู (เช่น "ข้าวมันไก่ 2 จาน")
  // คูณแคลอรี่ได้สูงสุด 2 หลัก (1–99) ไม่มีในเอกสาร (Q-17 ใช้ตารางเมนูในเครื่องแทน AI)
  static const int menuQuantityMaxDigits = 2;

  // ---------------------------------------------------------------------------
  // ข้อความบนหน้าจอ (ux-flow.md §2, §4 ตรงตัว / ui-spec "เสนอ — รอยืนยัน")
  // ---------------------------------------------------------------------------

  static const String kcalUnit = 'kcal';
  static const String backButtonText =
      'ย้อนกลับ'; // ui-spec §2.2 (เท่า steps/signup)

  // ทางเข้าจากหน้า water (ui-spec §2.0)
  // ASSUMPTION: ui-spec Q-1 (เสนอ — รอยืนยัน)
  static const String entryTooltip = 'โภชนาการ';

  // S-1
  // ASSUMPTION: ui-spec Q-2 (เสนอ — รอยืนยัน)
  static const String dashboardTitle = 'โภชนาการ';
  static const String addMealButtonText = 'บันทึกมื้ออาหาร';
  static const String fullBadgeText = 'อิ่มแล้ว';
  static const String overLimitToastText = 'พอเถอะน้าคนดี';
  static const String profileCtaText =
      'ตั้งค่าโปรไฟล์สุขภาพเพื่อรับเป้าหมายแคลอรี่ที่แม่นยำ';

  // S-2
  // ASSUMPTION: ui-spec Q-2 (เสนอ — ยืมข้อความปุ่ม S-1)
  static const String mealTitle = addMealButtonText;
  static const String mealInputHint =
      'พิมพ์เมนูอาหารที่คุณทานวันนี้ เช่น ข้าวมันไก่ 1 จาน...';
  static const String manualCalorieHint = 'ระบุแคลอรี่ (kcal)';
  // ASSUMPTION: ui-spec Q-10 (เสนอ — รอยืนยัน)
  static const String manualCalorieHelper =
      'ไม่สามารถประมวลผลเมนูอัตโนมัติได้ กรุณาระบุแคลอรี่เอง';
  static const String mealSubmitText = 'บันทึกข้อมูล';

  // S-3
  // ASSUMPTION: ui-spec Q-2 (เสนอ — รอยืนยัน)
  static const String profileTitle = 'ตั้งค่าโปรไฟล์สุขภาพ';
  static const String ageHint = 'ระบุอายุ (ปี)';
  // ASSUMPTION: ui-spec Q-15 (เสนอ — ข้อความเดียวกับ signup_gender_label)
  static const String genderLabel = 'เพศ';
  static const String genderMaleText = 'ชาย';
  static const String genderFemaleText = 'หญิง';
  static const String weightHint = 'น้ำหนัก (kg)';
  static const String heightHint = 'ส่วนสูง (cm)';
  static const String profileSaveText = 'บันทึกและคำนวณเป้าหมาย';
  static const String profileSkipText = 'ข้ามไปก่อน';

  /// ux-flow §4 S-3 Error — ตัวเลขมาจาก AGE_MIN / AGE_MAX
  static String get ageError =>
      'กรุณากรอกอายุเป็นจำนวนเต็มระหว่าง $ageMin - $ageMax ปี';
}
