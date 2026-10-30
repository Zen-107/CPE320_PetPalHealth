/// ตัวกลางระหว่าง repository/logic กับ UI ของ signup
library;

import 'package:flutter/foundation.dart';

import 'signup_logic.dart';
import 'signup_models.dart';
import 'signup_repository.dart';

/// ผลของการสมัคร/เข้าสู่ระบบด้วยอีเมล (S-2)
enum EmailAuthOutcome { success, emailInUse, invalidCredentials, networkError }

/// ผลของ Google Login (S-1)
enum GoogleAuthOutcome { success, networkError }

/// ผลของการบันทึก Onboarding (S-6)
enum SaveProfileOutcome { success, networkError, invalid }

class SignupController extends ChangeNotifier {
  SignupController({required this._repository});

  final AuthRepository _repository;

  bool _isLoaded = false;
  AuthSession? _session;
  bool _forceOnboarding = false;

  bool get isLoaded => _isLoaded;
  AuthSession? get session => _session;

  /// ปลายทางปัจจุบันของแอป (ใช้โดย SignupGate)
  SignupRoute get route => SignupLogic.routeFor(
        isLoaded: _isLoaded,
        session: _session,
        forceOnboarding: _forceOnboarding,
      );

  /// ชื่อบนแบนเนอร์ S-7 (AC-5) — null ถ้ายังไม่มีโปรไฟล์
  String? get homeDisplayName {
    final profile = _session?.profile;
    return profile == null ? null : SignupLogic.displayNameForUi(profile);
  }

  /// อ่าน Token ตอนเปิดแอป (AC-8)
  Future<void> load() async {
    try {
      _session = await _repository.restoreSession();
    } catch (_) {
      // ASSUMPTION: อ่าน session ไม่ได้ → ไปหน้า S-1 (ให้เข้าสู่ระบบใหม่) แอปไม่ล่ม
      _session = null;
    }
    _isLoaded = true;
    notifyListeners();
  }

  /// S-2 โหมดสมัคร (US-1, AC-2, EC-5)
  Future<EmailAuthOutcome> signUpWithEmail(String email, String password) =>
      _emailAuth(() => _repository.signUpWithEmail(email, password));

  /// S-2 โหมดเข้าสู่ระบบ
  Future<EmailAuthOutcome> signInWithEmail(String email, String password) =>
      _emailAuth(() => _repository.signInWithEmail(email, password));

  Future<EmailAuthOutcome> _emailAuth(
      Future<AuthSession> Function() call) async {
    try {
      _session = await call();
    } on EmailAlreadyInUseException {
      return EmailAuthOutcome.emailInUse;
    } on InvalidCredentialsException {
      return EmailAuthOutcome.invalidCredentials;
    } on AuthNetworkException {
      return EmailAuthOutcome.networkError;
    }
    _forceOnboarding = false;
    notifyListeners();
    return EmailAuthOutcome.success;
  }

  /// S-1 Google Login (US-2, AC-2, EC-1)
  Future<GoogleAuthOutcome> signInWithGoogle() async {
    final GoogleSignInResult result;
    try {
      result = await _repository.signInWithGoogle();
    } on AuthNetworkException {
      return GoogleAuthOutcome.networkError;
    }
    _session = result.session;
    // AC-2: เชื่อมบัญชีแล้วพาไป Onboarding ทันที
    _forceOnboarding = result.linked;
    notifyListeners();
    return GoogleAuthOutcome.success;
  }

  /// S-3
  Future<void> requestPasswordReset(String email) =>
      _repository.requestPasswordReset(email);

  /// S-5 (AC-3) — false = รหัสผ่านสั้นเกิน (ปฏิเสธการบันทึก) หรือบันทึกไม่สำเร็จ
  Future<bool> resetPassword(String email, String newPassword) async {
    if (!SignupLogic.isPasswordLongEnough(newPassword)) return false;
    try {
      await _repository.resetPassword(email, newPassword);
      return true;
    } on AuthException {
      return false;
    }
  }

  /// S-6 บันทึก (US-4, AC-4, EC-2, EC-4)
  Future<SaveProfileOutcome> saveProfile({
    required String displayName,
    required String age,
    required SignupGender gender,
    required String weight,
    required String height,
    required String healthGoal,
  }) async {
    final session = _session;
    if (session == null) return SaveProfileOutcome.invalid;
    final profile = SignupLogic.buildProfile(
      email: session.email,
      displayName: displayName,
      age: age,
      gender: gender,
      weight: weight,
      height: height,
      healthGoal: healthGoal,
    );
    if (profile == null) return SaveProfileOutcome.invalid;
    try {
      _session = await _repository.saveProfile(profile);
    } on AuthNetworkException {
      return SaveProfileOutcome.networkError;
    } on NotSignedInException {
      return SaveProfileOutcome.invalid;
    }
    _forceOnboarding = false;
    notifyListeners();
    return SaveProfileOutcome.success;
  }

  Future<void> signOut() async {
    await _repository.signOut();
    _session = null;
    _forceOnboarding = false;
    notifyListeners();
  }
}
