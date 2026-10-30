/// การยืนยันตัวตนและเก็บโปรไฟล์ของ signup
///
/// DECIDED (owner): MVP ยังไม่มี backend — ใช้ [FakeAuthRepository] จำลองในเครื่อง
/// (ไม่มี network, ไม่ลง google_sign_in) โดยแยก [AuthRepository] เป็น interface
/// ไว้ต่อ backend จริงภายหลัง
library;

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signup_logic.dart';
import 'signup_models.dart';
import 'signup_rules.dart';

/// interface ของระบบยืนยันตัวตน — ทุกเมธอด throw [AuthException] เมื่อไม่สำเร็จ
abstract class AuthRepository {
  /// อ่าน session ที่เก็บไว้ในเครื่อง (AC-8) — null = ยังไม่ได้เข้าสู่ระบบ
  Future<AuthSession?> restoreSession();

  /// US-1 — throw [EmailAlreadyInUseException] (AC-2, EC-5), [AuthNetworkException]
  Future<AuthSession> signUpWithEmail(String email, String password);

  /// S-2 โหมดเข้าสู่ระบบ — throw [InvalidCredentialsException], [AuthNetworkException]
  Future<AuthSession> signInWithEmail(String email, String password);

  /// US-2 / AC-2 — throw [AuthNetworkException] (EC-1)
  Future<GoogleSignInResult> signInWithGoogle();

  /// US-3 S-3
  Future<void> requestPasswordReset(String email);

  /// US-3 S-5 / AC-3 — throw [ArgumentError] ถ้ารหัสผ่านสั้นกว่า min_password_length
  Future<void> resetPassword(String email, String newPassword);

  /// US-4 S-6 — throw [AuthNetworkException] (EC-4), [NotSignedInException]
  Future<AuthSession> saveProfile(UserProfile profile);

  Future<void> signOut();
}

// -----------------------------------------------------------------------------
// ที่เก็บข้อมูลในเครื่อง (key-value)
// -----------------------------------------------------------------------------

abstract class AuthLocalStore {
  Future<String?> read(String key);

  /// value = null → ลบ key
  Future<void> write(String key, String? value);
}

class InMemoryAuthLocalStore implements AuthLocalStore {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String? value) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }
}

/// เก็บด้วย shared_preferences
// ASSUMPTION: requirements §6 / AC-8 ให้เก็บ Token ใน Secure Storage แต่ owner สั่งใช้
// shared_preferences ในรอบนี้ — เปลี่ยนเป็น secure storage ได้โดยเขียน AuthLocalStore ใหม่
class SharedPrefsAuthLocalStore implements AuthLocalStore {
  SharedPrefsAuthLocalStore([Future<SharedPreferences>? prefs])
      : _prefs = prefs ?? SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefs;

  @override
  Future<String?> read(String key) async {
    try {
      final v = (await _prefs).get(key);
      return v is String ? v : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(String key, String? value) async {
    final prefs = await _prefs;
    final ok = value == null
        ? await prefs.remove(key)
        : await prefs.setString(key, value);
    if (!ok) throw const AuthNetworkException('local storage write failed');
  }
}

class SignupStorageKeys {
  SignupStorageKeys._();

  static const String accounts = 'signup_accounts';
  static const String session = 'signup_session';
}

// -----------------------------------------------------------------------------
// Fake repository
// -----------------------------------------------------------------------------

class _Account {
  _Account({
    required this.email,
    this.salt,
    this.passwordHash,
    Set<AuthProvider>? providers,
    this.profile,
  }) : providers = providers ?? {};

  final String email;
  String? salt;
  String? passwordHash;
  final Set<AuthProvider> providers;
  UserProfile? profile;

  Map<String, dynamic> toJson() => {
        'email': email,
        'salt': salt,
        'passwordHash': passwordHash,
        'providers': [for (final p in providers) p.name],
        'profile': profile?.toJson(),
      };

  static _Account fromJson(Map<String, dynamic> json) => _Account(
        email: json['email'] as String,
        salt: json['salt'] as String?,
        passwordHash: json['passwordHash'] as String?,
        providers: {
          for (final p in (json['providers'] as List? ?? const []))
            ...AuthProvider.values.where((v) => v.name == p),
        },
        profile: json['profile'] is Map<String, dynamic>
            ? UserProfile.fromJson(json['profile'] as Map<String, dynamic>)
            : null,
      );
}

/// ระบบยืนยันตัวตนจำลองในเครื่อง (ไม่มี network)
///
/// สำหรับ QA:
/// - [registeredEmails] / [registeredAccounts] — อีเมลที่สมัครไว้แล้วตั้งแต่ต้น
///   (ใช้ทดสอบอีเมลซ้ำ AC-2/EC-5 และ Account Linking)
/// - [failGoogleSignIn] = true → `signInWithGoogle` throw [AuthNetworkException] (EC-1)
/// - [failSaveProfile] = true → `saveProfile` throw [AuthNetworkException] (EC-4)
/// - [failEmailAuth] = true → สมัคร/เข้าสู่ระบบด้วยอีเมล throw [AuthNetworkException]
/// - [googleAccountEmail] — อีเมลที่ "บัญชี Google จำลอง" คืนมา
/// - [latency] — หน่วงทุกการเรียก (ดูสถานะ loading ได้ด้วย `tester.pump(latency)`)
/// flag ทั้งหมดแก้ระหว่างเทสต์ได้ (เช่น ตั้ง false แล้วกด Retry)
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    AuthLocalStore? store,
    Iterable<String> registeredEmails = const [],
    Map<String, String> registeredAccounts = const {},
    this.googleAccountEmail = defaultGoogleAccountEmail,
    this.failGoogleSignIn = false,
    this.failSaveProfile = false,
    this.failEmailAuth = false,
    this.latency = Duration.zero,
    Random? random,
  })  : _store = store ?? InMemoryAuthLocalStore(),
        _random = random ?? Random.secure() {
    // บัญชีตั้งต้น: ไม่มีรหัสผ่าน (เข้าสู่ระบบด้วยอีเมลไม่ได้ แต่ซ้ำ/เชื่อมบัญชีได้)
    for (final e in registeredEmails) {
      final email = SignupLogic.normalizeEmail(e);
      _seed[email] = _Account(email: email, providers: {AuthProvider.email});
    }
    registeredAccounts.forEach((e, password) {
      final email = SignupLogic.normalizeEmail(e);
      final account = _Account(email: email, providers: {AuthProvider.email});
      _setPassword(account, password);
      _seed[email] = account;
    });
  }

  // ASSUMPTION: ไม่มี Google SDK — บัญชี Google จำลองใช้อีเมลนี้ (ข้อมูลสมมติ)
  static const String defaultGoogleAccountEmail = 'petpal.demo@gmail.com';

  final AuthLocalStore _store;
  final Random _random;
  final Map<String, _Account> _seed = {};

  String googleAccountEmail;
  bool failGoogleSignIn;
  bool failSaveProfile;
  bool failEmailAuth;
  Duration latency;

  Map<String, _Account>? _accounts;
  AuthSession? _session;

  /// จำนวนครั้งที่ขอรีเซ็ตรหัสผ่าน (ตรวจได้ในเทสต์ — ไม่มีอีเมลจริงถูกส่ง)
  int passwordResetRequests = 0;

  /// อีเมลที่ลงทะเบียนแล้วทั้งหมด (normalize แล้ว)
  Future<Set<String>> registeredEmailSet() async =>
      (await _loadAccounts()).keys.toSet();

  /// โปรไฟล์ที่บันทึกของอีเมลนี้ (null = ยังไม่มี)
  Future<UserProfile?> profileFor(String email) async =>
      (await _loadAccounts())[SignupLogic.normalizeEmail(email)]?.profile;

  @override
  Future<AuthSession?> restoreSession() async {
    await _delay();
    final accounts = await _loadAccounts();
    final raw = await _store.read(SignupStorageKeys.session);
    if (raw == null) return _session = null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final token = json['token'] as String;
      final email = json['email'] as String;
      final account = accounts[email];
      // ASSUMPTION: session ที่ชี้ไปบัญชีที่ไม่มีแล้ว / ข้อมูลเสีย → ถือว่ายังไม่เข้าสู่ระบบ
      if (account == null || token.isEmpty) return _session = null;
      return _session =
          AuthSession(token: token, email: email, profile: account.profile);
    } catch (_) {
      return _session = null;
    }
  }

  @override
  Future<AuthSession> signUpWithEmail(String email, String password) async {
    await _delay();
    if (failEmailAuth) throw const AuthNetworkException();
    _checkPassword(password);
    final accounts = await _loadAccounts();
    final key = SignupLogic.normalizeEmail(email);
    if (accounts.containsKey(key)) throw const EmailAlreadyInUseException();
    final account = _Account(email: key, providers: {AuthProvider.email});
    _setPassword(account, password);
    accounts[key] = account;
    await _saveAccounts();
    return _startSession(account);
  }

  @override
  Future<AuthSession> signInWithEmail(String email, String password) async {
    await _delay();
    if (failEmailAuth) throw const AuthNetworkException();
    final accounts = await _loadAccounts();
    final account = accounts[SignupLogic.normalizeEmail(email)];
    if (account == null ||
        account.salt == null ||
        account.passwordHash != _hash(account.salt!, password)) {
      throw const InvalidCredentialsException();
    }
    return _startSession(account);
  }

  @override
  Future<GoogleSignInResult> signInWithGoogle() async {
    await _delay();
    if (failGoogleSignIn) throw const AuthNetworkException();
    final accounts = await _loadAccounts();
    final key = SignupLogic.normalizeEmail(googleAccountEmail);
    var account = accounts[key];
    var linked = false;
    if (account == null) {
      account = _Account(email: key, providers: {AuthProvider.google});
      accounts[key] = account;
    } else if (!account.providers.contains(AuthProvider.google)) {
      // AC-2 Account Linking: อีเมลนี้เคยสมัครแบบปกติ → เชื่อม Google เข้าบัญชีเดิม
      account.providers.add(AuthProvider.google);
      linked = true;
    }
    await _saveAccounts();
    final session = await _startSession(account);
    return GoogleSignInResult(session: session, linked: linked);
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await _delay();
    // ASSUMPTION: ไม่มีอีเมลจริง — นับคำขอไว้เท่านั้น และตอบสำเร็จเสมอไม่ว่ามีบัญชีหรือไม่
    // (ไม่เปิดเผยว่าอีเมลใดมีบัญชี; ux-flow ไม่มีสถานะ error ของ S-3 — ui-spec Q-7)
    passwordResetRequests++;
  }

  @override
  Future<void> resetPassword(String email, String newPassword) async {
    await _delay();
    _checkPassword(newPassword); // AC-3 ปฏิเสธการบันทึกรหัสผ่านสั้น
    final accounts = await _loadAccounts();
    final account = accounts[SignupLogic.normalizeEmail(email)];
    // ASSUMPTION: อีเมลที่ไม่มีบัญชี → ไม่ทำอะไร (ตอบสำเร็จ) แบบเดียวกับ S-3
    if (account == null) return;
    _setPassword(account, newPassword);
    account.providers.add(AuthProvider.email);
    await _saveAccounts();
  }

  @override
  Future<AuthSession> saveProfile(UserProfile profile) async {
    await _delay();
    if (failSaveProfile) throw const AuthNetworkException();
    final session = _session;
    final accounts = await _loadAccounts();
    final account = session == null ? null : accounts[session.email];
    if (session == null || account == null) {
      throw const NotSignedInException();
    }
    // EC-2 / D-c: กันชั้นสุดท้าย — โปรไฟล์ที่ไม่ผ่าน SignupLogic.buildProfile บันทึกไม่ได้
    if (!SignupLogic.isAgeInRange(profile.age)) {
      throw ArgumentError.value(profile.age, 'age',
          'must be ${SignupRules.minAge}-${SignupRules.maxAge}');
    }
    account.profile = profile;
    await _saveAccounts();
    return _session = session.copyWith(profile: profile);
  }

  @override
  Future<void> signOut() async {
    _session = null;
    await _store.write(SignupStorageKeys.session, null);
  }

  // ---------------------------------------------------------------------------

  Future<void> _delay() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
  }

  void _checkPassword(String password) {
    if (!SignupLogic.isPasswordLongEnough(password)) {
      throw ArgumentError(
          'password must be at least ${SignupRules.minPasswordLength} characters');
    }
  }

  Future<AuthSession> _startSession(_Account account) async {
    final session = AuthSession(
      token: _newToken(),
      email: account.email,
      profile: account.profile,
    );
    // AC-8: เก็บ token ไว้ในเครื่อง เปิดแอปใหม่ไม่ต้องเข้าสู่ระบบอีก
    await _store.write(
      SignupStorageKeys.session,
      jsonEncode({'token': session.token, 'email': session.email}),
    );
    return _session = session;
  }

  Future<Map<String, _Account>> _loadAccounts() async {
    final cached = _accounts;
    if (cached != null) return cached;
    final accounts = <String, _Account>{};
    final raw = await _store.read(SignupStorageKeys.accounts);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List;
        for (final item in list) {
          try {
            final a = _Account.fromJson(item as Map<String, dynamic>);
            accounts[a.email] = a;
          } catch (_) {
            // ข้ามรายการที่เสีย
          }
        }
      } catch (_) {
        // ASSUMPTION: ข้อมูลบัญชีในเครื่องเสีย → เริ่มว่าง ไม่ทำให้แอปล่ม
      }
    }
    for (final entry in _seed.entries) {
      accounts.putIfAbsent(entry.key, () => entry.value);
    }
    return _accounts = accounts;
  }

  Future<void> _saveAccounts() async {
    final accounts = await _loadAccounts();
    await _store.write(
      SignupStorageKeys.accounts,
      jsonEncode([for (final a in accounts.values) a.toJson()]),
    );
  }

  /// requirements §6: เก็บรหัสผ่านแบบ hash (SHA-256 + salt ต่อบัญชี) ไม่เก็บตัวจริง
  void _setPassword(_Account account, String password) {
    final salt = base64Url.encode(_randomBytes(16));
    account
      ..salt = salt
      ..passwordHash = _hash(salt, password);
  }

  static String _hash(String salt, String password) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();

  String _newToken() => base64Url.encode(_randomBytes(32));

  List<int> _randomBytes(int n) => [for (var i = 0; i < n; i++) _random.nextInt(256)];
}
