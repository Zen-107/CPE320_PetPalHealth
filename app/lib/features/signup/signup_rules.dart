/// ค่าคงที่กติกาของฟีเจอร์ signup (สมัครสมาชิก / เข้าสู่ระบบ / Onboarding)
///
/// ตัวเลขกติกาทุกตัวมาจาก docs/signup/game-rules.md §1 (และ AC ใน requirements.md)
/// ข้อความบนจอมาจาก docs/signup/ux-flow.md §2 / ui-spec.md §2–§3
/// ค่าที่เอกสารไม่ได้กำหนดจะมีคอมเมนต์ ASSUMPTION กำกับ
class SignupRules {
  SignupRules._();

  // ---------------------------------------------------------------------------
  // game-rules.md §1 ค่าหลัก
  // ---------------------------------------------------------------------------

  /// min_password_length — ความยาวขั้นต่ำของรหัสผ่าน (AC-1, AC-3)
  static const int minPasswordLength = 6;

  /// max_display_name_length — ความยาวสูงสุดของ Display Name (EC-3)
  static const int maxDisplayNameLength = 20;

  /// display_name_truncation_limit — ชื่อหน้าอีเมลยาว "เกิน" ค่านี้จึงตัดคำ (AC-5)
  static const int displayNameTruncationLimit = 8;

  /// min_age / max_age — ช่วงอายุที่รองรับ รวมขอบทั้งสองด้าน (EC-2, game-rules §4)
  static const int minAge = 1;
  static const int maxAge = 120;

  /// min_weight / max_weight — กิโลกรัม รวมขอบ (EC-2, game-rules §4)
  static const double minWeight = 1.0;
  static const double maxWeight = 300.0;

  /// min_height / max_height — เซนติเมตร รวมขอบ (EC-2, game-rules §4)
  static const double minHeight = 1.0;
  static const double maxHeight = 250.0;

  /// default_health_goal — เป้าหมายสุขภาพเริ่มต้น (requirements §6)
  static const String defaultHealthGoal = 'ดูแลสุขภาพ';

  /// default_gender = UNSPECIFIED — ดู `SignupGender.defaultValue` (ux-flow S-6)
  static const String defaultGenderCode = 'UNSPECIFIED';

  // ---------------------------------------------------------------------------
  // AC-5 รูปแบบการตัดคำชื่อหน้าอีเมล: 4 ตัวแรก + "..." + 2 ตัวท้าย
  // (ตัวเลขอยู่ใน AC-5 ของ requirements.md — game-rules §1 มีแค่ limit 8)
  // ---------------------------------------------------------------------------
  static const int truncatedHeadLength = 4;
  static const int truncatedTailLength = 2;
  static const String truncationEllipsis = '...';

  // ---------------------------------------------------------------------------
  // ui-spec §1.3 ภาพ / ขนาด / Toast
  // ---------------------------------------------------------------------------
  static const String welcomeLogo = 'assets/images/signup/s1_logo.png';
  static const String resetSentImage = 'assets/images/signup/s4_email_sent.png';

  /// ขนาดโลโก้ S-1 / ภาพ S-4 (ui-spec §1.3 — เท่าขนาด PetCharacter default)
  static const double heroImageSize = 160;

  /// ระยะแสดง SnackBar (ui-spec §1.3 — เท่า water / steps)
  static const int toastSeconds = 2;

  // ---------------------------------------------------------------------------
  // ข้อความบนหน้าจอ (ux-flow.md §2 ตรงตัว / ui-spec "เสนอ — รอยืนยัน")
  // ---------------------------------------------------------------------------

  static const String backButtonText = 'ย้อนกลับ'; // ui-spec §2.2 (เท่า steps/water)

  // S-1
  static const String appTitle = 'PetPal Health';
  static const String welcomeTagline =
      'เพื่อนซี้สุขภาพดี พาคุณและสัตว์เลี้ยงมีความสุขไปด้วยกัน';
  static const String googleButtonText = 'เข้าสู่ระบบด้วย Google';
  static const String orText = 'หรือ';
  static const String emailSignupButtonText = 'สมัครสมาชิกด้วยอีเมล';
  static const String haveAccountLinkText = 'มีบัญชีอยู่แล้ว? เข้าสู่ระบบ';

  // S-2
  static const String signupHeader = 'สร้างบัญชีผู้ใช้';
  // ASSUMPTION: ui-spec Q-2 (เสนอ — รอยืนยัน) title โหมดเข้าสู่ระบบ
  static const String loginHeader = 'เข้าสู่ระบบ';
  static const String emailHint = 'กรอกอีเมลของคุณ';
  static const String passwordHint = 'รหัสผ่าน (อย่างน้อย 6 ตัวอักษร)';
  static const String passwordTooShortError = 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
  static const String emailInUseError = 'อีเมลนี้ถูกใช้งานแล้ว';
  // ASSUMPTION: ui-spec Q-2 — โหมดสมัคร = 「สมัครสมาชิก」, โหมดเข้าสู่ระบบ = 「ดำเนินการต่อ」
  static const String signupSubmitText = 'สมัครสมาชิก';
  static const String loginSubmitText = 'ดำเนินการต่อ';
  static const String forgotPasswordLinkText = 'ลืมรหัสผ่าน?';
  // ASSUMPTION: ค่าชั่วคราว รอคำตอบ — เอกสารไม่มีข้อความเมื่อเข้าสู่ระบบด้วย
  // อีเมล/รหัสผ่านที่ไม่ตรงกับบัญชีใด
  static const String invalidCredentialsError = 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';

  // S-3
  static const String forgotHeader = 'ลืมรหัสผ่าน';
  static const String forgotDescription =
      'กรอกอีเมลที่คุณใช้สมัคร เพื่อรับลิงก์ตั้งค่ารหัสผ่านใหม่';
  static const String forgotSubmitText = 'ส่งลิงก์รีเซ็ตรหัสผ่าน';

  // S-4
  static const String resetSentHeader = 'ตรวจสอบอีเมลของคุณ';
  static const String resetSentMessage =
      'เราได้ส่งลิงก์สำหรับตั้งรหัสผ่านใหม่ไปที่อีเมลของคุณแล้ว กรุณาตรวจสอบกล่องข้อความ';
  static const String backToLoginText = 'กลับสู่หน้าเข้าสู่ระบบ';

  // S-5
  static const String newPasswordHeader = 'ตั้งรหัสผ่านใหม่';
  static const String newPasswordHint = 'รหัสผ่านใหม่ (อย่างน้อย 6 ตัวอักษร)';
  // ux-flow S-5 ตรงตัว (ต่างจาก S-2 — ui-spec Q-5)
  static const String newPasswordTooShortError =
      'รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร';
  static const String newPasswordSaveText = 'บันทึกรหัสผ่านใหม่';
  // ASSUMPTION: ui-spec Q-6 (เสนอ — รอยืนยัน)
  static const String passwordResetSuccessMessage = 'บันทึกรหัสผ่านใหม่เรียบร้อยแล้ว';

  // S-6
  static const String onboardingHeader = 'ข้อมูลสุขภาพเบื้องต้นของคุณ';
  static const String onboardingDescription =
      'โปรดกรอกข้อมูลเพื่อให้ PetPal Health ช่วยแนะนำการดูแลสุขภาพที่เหมาะสม';
  static const String displayNameHint = 'ชื่อที่ใช้แสดง (สูงสุด 20 ตัวอักษร)';
  static const String ageHint = 'อายุ (ปี)';
  // ASSUMPTION: ui-spec Q-9 (เสนอ — รอยืนยัน)
  static const String genderLabel = 'เพศ';
  static const String genderMaleText = 'ชาย';
  static const String genderFemaleText = 'หญิง';
  static const String genderUnspecifiedText = 'ไม่ระบุ';
  static const String genderWarning = 'ไม่สามารถคำนวณจำนวนแคลอรี่ที่เหมาะสมต่อวันได้';
  static const String weightHint = 'น้ำหนัก (กิโลกรัม)';
  static const String heightHint = 'ส่วนสูง (เซนติเมตร)';
  static const String bodyMetricMissingWarning = 'จะไม่มีการแนะนำแคลอรี่ที่เหมาะสมต่อวัน';
  // ASSUMPTION: ui-spec Q-10 (เสนอ — รอยืนยัน)
  static const String healthGoalLabel = 'เป้าหมายสุขภาพ';
  static const String onboardingSaveText = 'บันทึกและเริ่มต้นใช้งาน';

  // ASSUMPTION: ui-spec Q-11 (เสนอ — รอยืนยัน) ตัวเลขดึงจากค่าคงที่ด้านบน
  static String get ageRangeError => 'อายุต้องอยู่ระหว่าง $minAge–$maxAge ปี';
  static String get weightRangeError =>
      'น้ำหนักต้องอยู่ระหว่าง ${_n(minWeight)}–${_n(maxWeight)} กิโลกรัม';
  static String get heightRangeError =>
      'ส่วนสูงต้องอยู่ระหว่าง ${_n(minHeight)}–${_n(maxHeight)} เซนติเมตร';

  // S-7
  // ASSUMPTION: ui-spec Q-12 (เสนอ — รอยืนยัน) แสดงทุกครั้งที่อยู่ S-7
  static String homeWelcomeText(String displayName) => 'สวัสดี $displayName';

  // dialog เครือข่ายขัดข้อง (EC-1, EC-4)
  // ASSUMPTION: ui-spec Q-16 (เสนอ — รอยืนยัน)
  static const String networkErrorMessage = 'การเชื่อมต่อขัดข้อง กรุณาลองใหม่อีกครั้ง';
  static const String retryButtonText = 'ลองใหม่อีกครั้ง'; // เท่า StepsRules

  /// ui-spec §2.6: เลข 1.0 แสดงเป็น "1" เพื่ออ่านง่าย
  static String _n(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
}
