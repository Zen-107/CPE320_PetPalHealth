// Unit tests: FakeAuthRepository + SignupController (US-1..US-5)
// อ้างอิง requirements.md AC/EC, game-rules.md §4 — ไม่มีเวลาจริง/ไม่มี network
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/signup/signup_controller.dart';
import 'package:petpal_health/features/signup/signup_logic.dart';
import 'package:petpal_health/features/signup/signup_models.dart';
import 'package:petpal_health/features/signup/signup_repository.dart';

Future<SaveProfileOutcome> save(
  SignupController c, {
  String displayName = '',
  String age = '30',
  SignupGender gender = SignupGender.unspecified,
  String weight = '',
  String height = '',
  String healthGoal = 'ดูแลสุขภาพ',
}) =>
    c.saveProfile(
      displayName: displayName,
      age: age,
      gender: gender,
      weight: weight,
      height: height,
      healthGoal: healthGoal,
    );

void main() {
  group('AC-2 / EC-5 อีเมลซ้ำ', () {
    test('EC5_signup_with_registered_email_returns_email_in_use', () async {
      final repo = FakeAuthRepository(registeredEmails: ['taken@email.com']);
      final c = SignupController(repository: repo);
      await c.load();
      expect(await c.signUpWithEmail('taken@email.com', 'secret1'),
          EmailAuthOutcome.emailInUse);
      expect(c.session, isNull);
      expect(await repo.registeredEmailSet(), {'taken@email.com'});
    });

    test('AC2_signup_same_email_twice_second_is_rejected', () async {
      final repo = FakeAuthRepository();
      await repo.signUpWithEmail('new@email.com', 'secret1');
      await expectLater(repo.signUpWithEmail('new@email.com', 'other12'),
          throwsA(isA<EmailAlreadyInUseException>()));
      expect((await repo.registeredEmailSet()).length, 1);
    });

    test('ASSUMPTION_7_email_duplicate_is_case_insensitive', () async {
      final repo = FakeAuthRepository(registeredEmails: ['taken@email.com']);
      await expectLater(repo.signUpWithEmail(' Taken@Email.COM ', 'secret1'),
          throwsA(isA<EmailAlreadyInUseException>()));
    });

    test('AC2_google_with_email_registered_normally_links_and_goes_onboarding',
        () async {
      final repo = FakeAuthRepository(
        registeredAccounts: {'mali@email.com': 'secret1'},
        googleAccountEmail: 'mali@email.com',
      );
      final c = SignupController(repository: repo);
      await c.load();
      expect(await c.signInWithGoogle(), GoogleAuthOutcome.success);
      expect(c.session?.email, 'mali@email.com');
      expect(c.route, SignupRoute.onboarding);
      // เชื่อมเข้าบัญชีเดิม ไม่สร้างบัญชีที่สอง
      expect(await repo.registeredEmailSet(), {'mali@email.com'});
      // บัญชีเดิมยังเข้าสู่ระบบด้วยรหัสผ่านได้
      await repo.signInWithEmail('mali@email.com', 'secret1');
    });

    test('AC2_google_link_goes_onboarding_even_if_profile_exists', () async {
      final repo = FakeAuthRepository(
        registeredAccounts: {'mali@email.com': 'secret1'},
        googleAccountEmail: 'mali@email.com',
      );
      final c = SignupController(repository: repo);
      await c.load();
      await c.signInWithEmail('mali@email.com', 'secret1');
      expect(await save(c, displayName: 'Mali'), SaveProfileOutcome.success);
      expect(c.route, SignupRoute.home);
      await c.signOut();
      await c.signInWithGoogle();
      expect(c.route, SignupRoute.onboarding); // "พาไปหน้า Onboarding ทันที"
    });
  });

  group('AC-3 รีเซ็ตรหัสผ่าน', () {
    test('AC3_controller_rejects_5_char_new_password_old_password_still_works',
        () async {
      final repo = FakeAuthRepository(registeredAccounts: {'a@b.com': 'secret1'});
      final c = SignupController(repository: repo);
      await c.load();
      expect(await c.resetPassword('a@b.com', 'abcde'), isFalse);
      // ไม่ถูกบันทึก: รหัสผ่านเดิมยังใช้ได้ รหัสใหม่ใช้ไม่ได้
      await repo.signInWithEmail('a@b.com', 'secret1');
      await expectLater(repo.signInWithEmail('a@b.com', 'abcde'),
          throwsA(isA<InvalidCredentialsException>()));
    });

    test('AC3_repository_rejects_short_password', () async {
      final repo = FakeAuthRepository(registeredAccounts: {'a@b.com': 'secret1'});
      await expectLater(
          repo.resetPassword('a@b.com', 'abcde'), throwsA(isA<ArgumentError>()));
    });

    test('AC3_EDGE_new_password_exactly_6_saved_and_usable', () async {
      final repo = FakeAuthRepository(registeredAccounts: {'a@b.com': 'secret1'});
      final c = SignupController(repository: repo);
      await c.load();
      expect(await c.resetPassword('a@b.com', 'abcdef'), isTrue);
      await repo.signInWithEmail('a@b.com', 'abcdef');
      await expectLater(repo.signInWithEmail('a@b.com', 'secret1'),
          throwsA(isA<InvalidCredentialsException>()));
    });

    test('US3_request_password_reset_is_recorded', () async {
      final repo = FakeAuthRepository();
      final c = SignupController(repository: repo);
      await c.requestPasswordReset('a@b.com');
      expect(repo.passwordResetRequests, 1);
    });

    test('AC1_repository_rejects_signup_with_5_char_password', () async {
      final repo = FakeAuthRepository();
      await expectLater(repo.signUpWithEmail('new@email.com', 'abcde'),
          throwsA(isA<ArgumentError>()));
      expect(await repo.registeredEmailSet(), isEmpty);
    });
  });

  group('AC-4 / US-4 บันทึกโปรไฟล์', () {
    test('AC4_save_without_display_name_stores_email_local_part', () async {
      final repo = FakeAuthRepository();
      final c = SignupController(repository: repo);
      await c.load();
      await c.signUpWithEmail('alexander@email.com', 'secret1');
      expect(await save(c), SaveProfileOutcome.success);
      final p = (await repo.profileFor('alexander@email.com'))!;
      expect(p.displayName, 'alexander');
      expect(c.homeDisplayName, 'alex...er'); // AC-5
      expect(c.route, SignupRoute.home);
    });

    test('US4_save_stores_all_fields', () async {
      final repo = FakeAuthRepository();
      final c = SignupController(repository: repo);
      await c.load();
      await c.signUpWithEmail('mali@email.com', 'secret1');
      expect(
          await save(c,
              displayName: 'Mali',
              age: '25',
              gender: SignupGender.female,
              weight: '55.5',
              height: '160',
              healthGoal: 'ลดน้ำหนัก'),
          SaveProfileOutcome.success);
      final p = (await repo.profileFor('mali@email.com'))!;
      expect(p.displayName, 'Mali');
      expect(p.age, 25);
      expect(p.gender, SignupGender.female);
      expect(p.weightKg, 55.5);
      expect(p.heightCm, 160.0);
      expect(p.healthGoal, 'ลดน้ำหนัก');
    });

    test('EC2_controller_refuses_out_of_range_profile', () async {
      final repo = FakeAuthRepository();
      final c = SignupController(repository: repo);
      await c.load();
      await c.signUpWithEmail('mali@email.com', 'secret1');
      expect(await save(c, age: '121'), SaveProfileOutcome.invalid);
      expect(await save(c, weight: '301'), SaveProfileOutcome.invalid);
      expect(await save(c, height: '251'), SaveProfileOutcome.invalid);
      expect(await repo.profileFor('mali@email.com'), isNull);
    });

    test('DECIDED_Dc_controller_refuses_non_integer_age', () async {
      // D-c: อายุจำนวนเต็มเท่านั้น — ไม่บันทึกโปรไฟล์ที่อายุถูกปัด/ตัดค่า
      final repo = FakeAuthRepository();
      final c = SignupController(repository: repo);
      await c.load();
      await c.signUpWithEmail('mali@email.com', 'secret1');
      for (final a in ['25.5', '2.5', '-3', 'abc', '+25', '0x19']) {
        expect(await save(c, age: a), SaveProfileOutcome.invalid,
            reason: 'age "$a"');
      }
      expect(await repo.profileFor('mali@email.com'), isNull);
      expect(c.route, SignupRoute.onboarding);
    });

    test('DECIDED_Da_long_email_name_saved_full_home_shows_abcd_dots_yz',
        () async {
      // D-a: ชื่อจากอีเมลบันทึกเต็ม, AC-5 ย่อตอนแสดงผลจากชื่อเต็ม
      final repo = FakeAuthRepository();
      final c = SignupController(repository: repo);
      await c.load();
      await c.signUpWithEmail('abcdefghijklmnopqrstuvwxyz@email.com', 'secret1');
      expect(await save(c), SaveProfileOutcome.success);
      final p =
          (await repo.profileFor('abcdefghijklmnopqrstuvwxyz@email.com'))!;
      expect(p.displayName, 'abcdefghijklmnopqrstuvwxyz');
      expect(c.homeDisplayName, 'abcd...yz');
    });
  });

  group('EC-1 / EC-4 เน็ตหลุด แล้ว Retry', () {
    test('EC1_google_network_error_then_retry_succeeds', () async {
      final repo = FakeAuthRepository(failGoogleSignIn: true);
      final c = SignupController(repository: repo);
      await c.load();
      expect(await c.signInWithGoogle(), GoogleAuthOutcome.networkError);
      expect(c.session, isNull);
      expect(c.route, SignupRoute.welcome);
      repo.failGoogleSignIn = false;
      expect(await c.signInWithGoogle(), GoogleAuthOutcome.success);
      expect(c.route, SignupRoute.onboarding);
    });

    test('EC4_save_network_error_keeps_onboarding_then_retry_saves', () async {
      final repo = FakeAuthRepository(failSaveProfile: true);
      final c = SignupController(repository: repo);
      await c.load();
      await c.signUpWithEmail('mali@email.com', 'secret1');
      expect(await save(c, displayName: 'Mali'), SaveProfileOutcome.networkError);
      expect(c.route, SignupRoute.onboarding);
      expect(await repo.profileFor('mali@email.com'), isNull);
      repo.failSaveProfile = false;
      expect(await save(c, displayName: 'Mali'), SaveProfileOutcome.success);
      expect((await repo.profileFor('mali@email.com'))!.displayName, 'Mali');
    });
  });

  group('AC-8 Session / เปิดแอปใหม่ (US-5)', () {
    test('AC8_reopen_with_same_store_restores_session_and_goes_home', () async {
      final store = InMemoryAuthLocalStore();
      final c1 = SignupController(repository: FakeAuthRepository(store: store));
      await c1.load();
      await c1.signUpWithEmail('alexander@email.com', 'secret1');
      await save(c1);
      // "ปิดแอป" แล้วเปิดใหม่: repository/controller ใหม่ ใช้ storage เดิม
      final c2 = SignupController(repository: FakeAuthRepository(store: store));
      expect(c2.route, SignupRoute.loading);
      await c2.load();
      expect(c2.route, SignupRoute.home);
      expect(c2.session?.email, 'alexander@email.com');
      expect(c2.homeDisplayName, 'alex...er');
    });

    test('AC8_token_is_stored_on_device_not_empty', () async {
      final store = InMemoryAuthLocalStore();
      final c = SignupController(repository: FakeAuthRepository(store: store));
      await c.load();
      await c.signUpWithEmail('a@b.com', 'secret1');
      final raw = store.values[SignupStorageKeys.session];
      expect(raw, isNotNull);
      final json = jsonDecode(raw!) as Map<String, dynamic>;
      expect((json['token'] as String).isNotEmpty, isTrue);
      expect(json['token'], c.session!.token);
    });

    test('REQ6_password_is_stored_hashed_not_plain', () async {
      final store = InMemoryAuthLocalStore();
      final repo = FakeAuthRepository(store: store);
      await repo.signUpWithEmail('a@b.com', 'MyS3cretPw');
      for (final v in store.values.values) {
        expect(v.contains('MyS3cretPw'), isFalse);
      }
    });

    test('EDGE_first_open_empty_storage_goes_welcome', () async {
      final c = SignupController(
          repository: FakeAuthRepository(store: InMemoryAuthLocalStore()));
      await c.load();
      expect(c.isLoaded, isTrue);
      expect(c.session, isNull);
      expect(c.route, SignupRoute.welcome);
    });

    test('EDGE_corrupt_session_data_goes_welcome_without_crash', () async {
      final store = InMemoryAuthLocalStore()
        ..values[SignupStorageKeys.session] = '{not json'
        ..values[SignupStorageKeys.accounts] = '###';
      final c = SignupController(repository: FakeAuthRepository(store: store));
      await c.load();
      expect(c.route, SignupRoute.welcome);
    });

    test('EDGE_session_for_missing_account_goes_welcome', () async {
      final store = InMemoryAuthLocalStore()
        ..values[SignupStorageKeys.session] =
            jsonEncode({'token': 'abc', 'email': 'ghost@email.com'});
      final c = SignupController(repository: FakeAuthRepository(store: store));
      await c.load();
      expect(c.route, SignupRoute.welcome);
    });

    test('EDGE_Dc_stored_fractional_age_not_rounded_on_load', () async {
      // ข้อมูลที่เก็บไว้เสีย (age เป็นทศนิยม) — D-c: ต้องไม่ถูกปัดเป็นจำนวนเต็มเงียบ ๆ และไม่ crash
      final store = InMemoryAuthLocalStore();
      final c1 = SignupController(repository: FakeAuthRepository(store: store));
      await c1.load();
      await c1.signUpWithEmail('a@b.com', 'secret1');
      await save(c1, age: '25');
      final raw = store.values[SignupStorageKeys.accounts]!;
      expect(raw.contains('"age":25'), isTrue);
      store.values[SignupStorageKeys.accounts] =
          raw.replaceFirst('"age":25', '"age":25.5');
      final repo2 = FakeAuthRepository(store: store);
      final c2 = SignupController(repository: repo2);
      await c2.load();
      final p = await repo2.profileFor('a@b.com');
      expect(p == null || (p.age != 25 && p.age != 26), isTrue,
          reason: 'age 25.5 ถูกโหลดเป็น ${p?.age}');
      expect(c2.route, isNot(SignupRoute.loading));
    });

    test('US5_sign_out_clears_session_reopen_goes_welcome', () async {
      final store = InMemoryAuthLocalStore();
      final c1 = SignupController(repository: FakeAuthRepository(store: store));
      await c1.load();
      await c1.signUpWithEmail('a@b.com', 'secret1');
      await save(c1);
      await c1.signOut();
      final c2 = SignupController(repository: FakeAuthRepository(store: store));
      await c2.load();
      expect(c2.route, SignupRoute.welcome);
    });

    test('DECIDED_Db_19_session_saved_at_signup_reopen_before_onboarding_goes_onboarding', () async {
      final store = InMemoryAuthLocalStore();
      final c1 = SignupController(repository: FakeAuthRepository(store: store));
      await c1.load();
      await c1.signUpWithEmail('a@b.com', 'secret1');
      final c2 = SignupController(repository: FakeAuthRepository(store: store));
      await c2.load();
      expect(c2.route, SignupRoute.onboarding);
    });
  });

  group('S-2 โหมดเข้าสู่ระบบ', () {
    test('LOGIN_registered_account_without_profile_goes_onboarding', () async {
      final repo = FakeAuthRepository(registeredAccounts: {'a@b.com': 'secret1'});
      final c = SignupController(repository: repo);
      await c.load();
      expect(await c.signInWithEmail('a@b.com', 'secret1'),
          EmailAuthOutcome.success);
      expect(c.route, SignupRoute.onboarding);
    });

    test('ASSUMPTION_2_wrong_password_returns_invalid_credentials', () async {
      final repo = FakeAuthRepository(registeredAccounts: {'a@b.com': 'secret1'});
      final c = SignupController(repository: repo);
      await c.load();
      expect(await c.signInWithEmail('a@b.com', 'wrong12'),
          EmailAuthOutcome.invalidCredentials);
      expect(c.session, isNull);
    });
  });
}
