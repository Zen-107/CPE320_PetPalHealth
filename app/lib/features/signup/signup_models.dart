/// โมเดลข้อมูลของฟีเจอร์ signup (pure Dart)
library;

import 'signup_rules.dart';

/// เพศ (requirements §6) — ค่าภายในเป็น MALE / FEMALE / UNSPECIFIED (ux-flow S-6)
enum SignupGender {
  male('MALE', SignupRules.genderMaleText),
  female('FEMALE', SignupRules.genderFemaleText),
  unspecified('UNSPECIFIED', SignupRules.genderUnspecifiedText);

  const SignupGender(this.code, this.label);

  final String code;

  /// ข้อความบนจอ — แสดงเฉพาะคำไทย (ui-spec Q-8)
  final String label;

  /// default_gender (game-rules §1)
  static final SignupGender defaultValue =
      fromCode(SignupRules.defaultGenderCode);

  static SignupGender fromCode(String? code) {
    for (final g in values) {
      if (g.code == code) return g;
    }
    // ASSUMPTION: ค่าที่อ่านไม่ออก → ใช้ UNSPECIFIED (ค่าเริ่มต้นที่ปลอดภัย)
    return SignupGender.unspecified;
  }
}

/// ช่องทางที่ใช้เข้าสู่ระบบ
enum AuthProvider { email, google }

/// ข้อมูลสุขภาพ/โปรไฟล์ (requirements §6 Profiles Table)
class UserProfile {
  const UserProfile({
    required this.displayName,
    required this.displayNameFromEmail,
    required this.age,
    required this.gender,
    required this.weightKg,
    required this.heightCm,
    required this.healthGoal,
  });

  /// ค่าที่บันทึก (AC-4: เว้นว่าง → ชื่อหน้าอีเมล)
  final String displayName;

  /// true = ได้มาจากชื่อหน้าอีเมล (ใช้ตัดสินว่าต้องตัดคำตาม AC-5 หรือไม่)
  final bool displayNameFromEmail;
  final int age;
  final SignupGender gender;
  final double? weightKg;
  final double? heightCm;
  final String healthGoal;

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'displayNameFromEmail': displayNameFromEmail,
        'age': age,
        'gender': gender.code,
        'weightKg': weightKg,
        'heightCm': heightCm,
        'healthGoal': healthGoal,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        displayName: json['displayName'] as String,
        displayNameFromEmail: json['displayNameFromEmail'] as bool? ?? false,
        // D-c: อายุเป็นจำนวนเต็มเท่านั้น — ค่าที่บันทึกเป็นทศนิยม/ไม่ใช่ตัวเลขถือว่าข้อมูลเสีย
        // (throw → ผู้เรียกข้ามรายการนั้น) แทนการปัดเศษเงียบ ๆ ด้วย toInt()
        age: json['age'] as int,
        gender: SignupGender.fromCode(json['gender'] as String?),
        weightKg: (json['weightKg'] as num?)?.toDouble(),
        heightCm: (json['heightCm'] as num?)?.toDouble(),
        healthGoal:
            json['healthGoal'] as String? ?? SignupRules.defaultHealthGoal,
      );
}

/// Session ที่จัดเก็บในเครื่อง (US-5, AC-8)
class AuthSession {
  const AuthSession({
    required this.token,
    required this.email,
    this.profile,
  });

  final String token;
  final String email;

  /// null = ยังไม่ผ่าน Onboarding
  final UserProfile? profile;

  AuthSession copyWith({UserProfile? profile}) =>
      AuthSession(token: token, email: email, profile: profile ?? this.profile);
}

/// ผลของ Google Login (AC-2)
class GoogleSignInResult {
  const GoogleSignInResult({required this.session, required this.linked});

  final AuthSession session;

  /// true = อีเมลนี้เคยสมัครแบบอีเมลมาก่อน และถูกเชื่อมบัญชี (Account Linking)
  final bool linked;
}

/// ข้อผิดพลาดจาก repository
sealed class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
  @override
  String toString() => '$runtimeType: $message';
}

/// เครือข่ายขัดข้อง (EC-1, EC-4)
class AuthNetworkException extends AuthException {
  const AuthNetworkException([super.message = 'network unavailable']);
}

/// อีเมลถูกใช้แล้ว (AC-2, EC-5)
class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException([super.message = 'email already in use']);
}

/// อีเมล/รหัสผ่านไม่ตรงกับบัญชีใด (โหมดเข้าสู่ระบบ)
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException([super.message = 'invalid credentials']);
}

/// ไม่ได้เข้าสู่ระบบ (เช่น บันทึกโปรไฟล์โดยไม่มี session)
class NotSignedInException extends AuthException {
  const NotSignedInException([super.message = 'not signed in']);
}
