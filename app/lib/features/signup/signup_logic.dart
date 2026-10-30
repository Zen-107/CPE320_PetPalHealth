/// กติกาของฟีเจอร์ signup — pure Dart ไม่ขึ้นกับ widget (QA ทดสอบตรงได้)
library;

import 'signup_models.dart';
import 'signup_rules.dart';

/// ปลายทางของแอปตามสถานะ session (ux-flow §3, AC-8)
enum SignupRoute {
  /// กำลังอ่าน Token (ui-spec §2.0)
  loading,

  /// S-1
  welcome,

  /// S-6
  onboarding,

  /// S-7
  home,
}

/// ผลตรวจฟิลด์ตัวเลขของ S-6
enum NumberFieldStatus {
  /// ว่าง
  empty,

  /// อยู่ในขอบเขต
  valid,

  /// นอกขอบเขตหรืออ่านไม่ออก (EC-2)
  outOfRange,
}

/// ผลตรวจฟอร์ม S-6 ทั้งหน้า
class OnboardingValidation {
  const OnboardingValidation({
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
  });

  final NumberFieldStatus age;
  final NumberFieldStatus weight;
  final NumberFieldStatus height;
  final SignupGender gender;

  bool get showAgeError => age == NumberFieldStatus.outOfRange;
  bool get showWeightError => weight == NumberFieldStatus.outOfRange;
  bool get showHeightError => height == NumberFieldStatus.outOfRange;

  /// AC-7: เตือนใต้ช่องที่ว่างเท่านั้น
  bool get showWeightWarning => weight == NumberFieldStatus.empty;
  bool get showHeightWarning => height == NumberFieldStatus.empty;

  /// AC-6
  bool get showGenderWarning => SignupLogic.showsGenderWarning(gender);

  /// EC-2: ทุกช่องตัวเลขที่กรอกต้องอยู่ในขอบเขต; warning ไม่บล็อก (fallback ux-flow §6)
  // ASSUMPTION: อายุว่าง → บันทึกไม่ได้ (ui-spec Q-11 ตาม brief: อายุบังคับกรอก)
  // โดยไม่แสดงข้อความ
  bool get canSave =>
      age == NumberFieldStatus.valid &&
      weight != NumberFieldStatus.outOfRange &&
      height != NumberFieldStatus.outOfRange;
}

class SignupLogic {
  SignupLogic._();

  // ---------------------------------------------------------------------------
  // S-2 / S-5 อีเมลและรหัสผ่าน
  // ---------------------------------------------------------------------------

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  /// ทำอีเมลให้เป็นรูปแบบเดียวกันก่อนเทียบ/บันทึก
  // ASSUMPTION: อีเมลไม่สนตัวพิมพ์เล็ก-ใหญ่ และตัดช่องว่างหัวท้าย (A@x.com = a@x.com)
  static String normalizeEmail(String email) => email.trim().toLowerCase();

  /// ใช้ตัดสินว่าปุ่ม S-2 enabled ได้หรือไม่ (ui-spec §3 S-2 disabled)
  // ASSUMPTION: ตรวจรูปแบบอีเมลแบบพื้นฐาน "x@y.z" (ui-spec Q-3) ไม่มีข้อความ error
  static bool isValidEmail(String email) =>
      _emailPattern.hasMatch(email.trim());

  /// AC-1, AC-3: ความยาว >= min_password_length
  static bool isPasswordLongEnough(String password) =>
      password.length >= SignupRules.minPasswordLength;

  /// AC-1 / AC-3: แสดง error เมื่อยาว 1 ถึง min-1 ตัว — ช่องว่าง (0) ไม่ใช่ error (ui-spec Q-3)
  // ASSUMPTION: นับความยาวรหัสผ่านเป็น UTF-16 code unit (String.length) — ui-spec Q-19
  static bool showsPasswordError(String password) =>
      password.isNotEmpty && !isPasswordLongEnough(password);

  /// ปุ่ม S-2 enabled เมื่ออีเมลถูกรูปแบบและรหัสผ่านยาวพอ
  static bool canSubmitCredentials(String email, String password) =>
      isValidEmail(email) && isPasswordLongEnough(password);

  // ---------------------------------------------------------------------------
  // S-6 / S-7 Display Name (AC-4, AC-5, EC-3)
  // ---------------------------------------------------------------------------

  /// ชื่อหน้าอีเมล เช่น alexander@email.com → alexander
  static String emailLocalPart(String email) {
    final trimmed = email.trim();
    final at = trimmed.indexOf('@');
    return at < 0 ? trimmed : trimmed.substring(0, at);
  }

  /// ค่า Display Name ที่บันทึก (AC-4) — คืน (ชื่อ, มาจากอีเมลหรือไม่)
  static ({String name, bool fromEmail}) resolveDisplayName(
    String typed,
    String email,
  ) {
    final name = typed.trim();
    if (name.isNotEmpty) {
      return (name: _cap(name), fromEmail: false);
    }
    // DECIDED (owner ชั่วคราว D-a): ชื่อหน้าอีเมลบันทึกเต็มไม่ตัด — ลิมิต
    // max_display_name_length ใช้เฉพาะชื่อที่ผู้ใช้พิมพ์เอง (EC-3); AC-5 ย่อตอนแสดงผล
    return (name: emailLocalPart(email), fromEmail: true);
  }

  /// AC-5: ชื่อจากหน้าอีเมลที่ยาวเกิน display_name_truncation_limit → 4 ตัวแรก + ... + 2 ตัวท้าย
  static String truncateEmailName(String name) {
    final chars = name.runes.toList();
    if (chars.length <= SignupRules.displayNameTruncationLimit) return name;
    final head = String.fromCharCodes(
        chars.take(SignupRules.truncatedHeadLength));
    final tail = String.fromCharCodes(
        chars.skip(chars.length - SignupRules.truncatedTailLength));
    return '$head${SignupRules.truncationEllipsis}$tail';
  }

  /// ชื่อที่แสดงบนแบนเนอร์ S-7 — ชื่อจากอีเมลถูกบันทึกเต็ม (D-a) จึงย่อจากชื่อหน้าอีเมลจริง
  // ASSUMPTION: ui-spec Q-20 — ตัดคำเฉพาะชื่อที่ได้จากหน้าอีเมล ชื่อที่ผู้ใช้พิมพ์เองแสดงเต็ม
  static String displayNameForUi(UserProfile profile) =>
      profile.displayNameFromEmail
          ? truncateEmailName(profile.displayName)
          : profile.displayName;

  static String _cap(String s) {
    final chars = s.runes.toList();
    if (chars.length <= SignupRules.maxDisplayNameLength) return s;
    return String.fromCharCodes(chars.take(SignupRules.maxDisplayNameLength));
  }

  // ---------------------------------------------------------------------------
  // S-6 ช่องตัวเลข (EC-2) และคำเตือน (AC-6, AC-7)
  // ---------------------------------------------------------------------------

  static final RegExp _wholeNumberPattern = RegExp(r'^[0-9]+$');

  /// อายุต้องเป็นจำนวนเต็มเท่านั้น (DECIDED ทีม D-c, requirements §6 Age = Integer)
  /// รับเฉพาะเลข 0-9 ล้วน — ไม่รับทศนิยม ("25.5"), เครื่องหมาย ("-3", "+25"),
  /// รูปแบบที่ int.tryParse รับได้แต่ไม่ใช่เลขฐานสิบล้วน ("0x19") หรือตัวอักษร ("abc")
  static bool isWholeNumberText(String text) =>
      _wholeNumberPattern.hasMatch(text);

  /// EC-2: อายุอยู่ในช่วง [min_age, max_age]
  static bool isAgeInRange(int age) =>
      age >= SignupRules.minAge && age <= SignupRules.maxAge;

  static NumberFieldStatus ageStatus(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return NumberFieldStatus.empty;
    // ASSUMPTION: ข้อความที่ไม่ใช่จำนวนเต็มล้วน ถือเป็น error เดียวกับนอกขอบเขต
    // (เอกสารไม่มีข้อความเฉพาะ) → บล็อกการบันทึก
    if (!isWholeNumberText(text)) return NumberFieldStatus.outOfRange;
    final v = int.tryParse(text);
    if (v == null || !isAgeInRange(v)) return NumberFieldStatus.outOfRange;
    return NumberFieldStatus.valid;
  }

  // ASSUMPTION: ข้อความที่แปลงเป็นตัวเลขไม่ได้ (เช่น "1.2.3", "abc") ถือเป็น error
  // เดียวกับนอกขอบเขต (เอกสารไม่มีข้อความเฉพาะ); ทศนิยมไม่จำกัดหลัก (ui-spec Q-11)
  static NumberFieldStatus weightStatus(String raw) =>
      _doubleStatus(raw, SignupRules.minWeight, SignupRules.maxWeight);

  static NumberFieldStatus heightStatus(String raw) =>
      _doubleStatus(raw, SignupRules.minHeight, SignupRules.maxHeight);

  static NumberFieldStatus _doubleStatus(String raw, double min, double max) {
    final text = raw.trim();
    if (text.isEmpty) return NumberFieldStatus.empty;
    final v = double.tryParse(text);
    if (v == null || v.isNaN || v < min || v > max) {
      return NumberFieldStatus.outOfRange;
    }
    return NumberFieldStatus.valid;
  }

  /// AC-6
  static bool showsGenderWarning(SignupGender gender) =>
      gender == SignupGender.unspecified;

  static OnboardingValidation validateOnboarding({
    required String age,
    required String weight,
    required String height,
    required SignupGender gender,
  }) =>
      OnboardingValidation(
        age: ageStatus(age),
        weight: weightStatus(weight),
        height: heightStatus(height),
        gender: gender,
      );

  /// สร้างโปรไฟล์ที่จะบันทึก — คืน null ถ้าฟอร์มยังบันทึกไม่ได้ (EC-2)
  static UserProfile? buildProfile({
    required String email,
    required String displayName,
    required String age,
    required SignupGender gender,
    required String weight,
    required String height,
    required String healthGoal,
  }) {
    final v = validateOnboarding(
        age: age, weight: weight, height: height, gender: gender);
    if (!v.canSave) return null;
    final name = resolveDisplayName(displayName, email);
    final goal = healthGoal.trim();
    return UserProfile(
      displayName: name.name,
      displayNameFromEmail: name.fromEmail,
      age: int.parse(age.trim()),
      gender: gender,
      weightKg: v.weight == NumberFieldStatus.valid
          ? double.parse(weight.trim())
          : null,
      heightCm: v.height == NumberFieldStatus.valid
          ? double.parse(height.trim())
          : null,
      // ASSUMPTION: ui-spec Q-10 — ผู้ใช้ลบเป้าหมายจนว่าง → บันทึกค่าเริ่มต้น 「ดูแลสุขภาพ」
      healthGoal: goal.isEmpty ? SignupRules.defaultHealthGoal : goal,
    );
  }

  // ---------------------------------------------------------------------------
  // การนำทาง (ux-flow §3, AC-2, AC-8)
  // ---------------------------------------------------------------------------

  /// [forceOnboarding] = true หลัง Google Account Linking (AC-2 "พาไปหน้า Onboarding ทันที")
  // ASSUMPTION: มี session แต่ยังไม่มีโปรไฟล์ (เช่น ปิดแอประหว่าง Onboarding) → S-6
  static SignupRoute routeFor({
    required bool isLoaded,
    required AuthSession? session,
    bool forceOnboarding = false,
  }) {
    if (!isLoaded) return SignupRoute.loading;
    if (session == null) return SignupRoute.welcome;
    if (forceOnboarding || session.profile == null) {
      return SignupRoute.onboarding;
    }
    return SignupRoute.home;
  }
}
