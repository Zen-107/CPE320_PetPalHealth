// Widget tests: S-1..S-7 ของ signup (ux-flow.md §2–§4, ui-spec.md keys)
// ข้อความคาดหวังคัดลอกจาก ux-flow.md / requirements.md ตรงตัว
// เวลาควบคุมผ่าน FakeAuthRepository.latency + tester.pump — ไม่มี sleep/เวลาจริง
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/signup/screens/signup_new_password_screen.dart';
import 'package:petpal_health/features/signup/signup_controller.dart';
import 'package:petpal_health/features/signup/signup_models.dart';
import 'package:petpal_health/features/signup/signup_repository.dart';
import 'package:petpal_health/features/water/water_controller.dart';
import 'package:petpal_health/features/water/water_models.dart';
import 'package:petpal_health/features/water/water_repository.dart';
import 'package:petpal_health/main.dart';

Finder k(String key) => find.byKey(Key(key));

// ข้อความจากเอกสาร
const pwShortS2 = 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร'; // AC-1, ux-flow S-2
const pwShortS5 = 'รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร'; // AC-3, ux-flow S-5
const emailInUse = 'อีเมลนี้ถูกใช้งานแล้ว'; // AC-2, EC-5
const genderWarn = 'ไม่สามารถคำนวณจำนวนแคลอรี่ที่เหมาะสมต่อวันได้'; // AC-6
const metricWarn = 'จะไม่มีการแนะนำแคลอรี่ที่เหมาะสมต่อวัน'; // AC-7

WaterController waterController() => WaterController(
      repository: InMemoryWaterRepository(WaterState.initial),
      clock: () => DateTime(2026, 10, 30, 10, 0),
    );

Future<void> pumpApp(WidgetTester tester, SignupController c) async {
  await tester.pumpWidget(
      PetPalApp(waterController: waterController(), signupController: c));
  await tester.pumpAndSettle();
}

/// เข้าสู่ S-6 ด้วยบัญชีใหม่ (สมัครผ่าน controller ก่อน pump แอป)
Future<(FakeAuthRepository, SignupController)> pumpOnboarding(
  WidgetTester tester, {
  String email = 'alexander@email.com',
  FakeAuthRepository? repo,
}) async {
  final r = repo ?? FakeAuthRepository();
  final c = SignupController(repository: r);
  await c.load();
  await c.signUpWithEmail(email, 'secret1');
  await pumpApp(tester, c);
  expect(k('signup_onboarding_header_text'), findsOneWidget);
  return (r, c);
}

bool enabled(WidgetTester tester, Finder f) =>
    tester.widget<ButtonStyleButton>(f).enabled;

String textOf(WidgetTester tester, Finder f) {
  final w = tester.widget(f);
  if (w is Text) return w.data!;
  // warning ใต้ฟิลด์เป็น SignupWarningText (ห่อ Text) — อ่านข้อความจาก Text ข้างใน
  return tester
      .widget<Text>(find.descendant(of: f, matching: find.byType(Text)))
      .data!;
}

String fieldText(WidgetTester tester, String key) =>
    tester.widget<TextField>(k(key)).controller!.text;

Future<void> enter(WidgetTester tester, String key, String text) async {
  await tester.ensureVisible(k(key));
  await tester.enterText(k(key), text);
  await tester.pump();
}

Future<void> tapKey(WidgetTester tester, String key) async {
  await tester.ensureVisible(k(key));
  await tester.pump();
  await tester.tap(k(key));
  await tester.pumpAndSettle();
}

Future<void> openSignupS2(WidgetTester tester) async {
  await tester.tap(k('signup_email_signup_button'));
  await tester.pumpAndSettle();
}

void main() {
  // ---------------------------------------------------------------------------
  group('S-1 หน้าต้อนรับ', () {
    testWidgets('UI_S1_texts_per_ux_flow_and_first_open_shows_welcome',
        (tester) async {
      await pumpApp(tester, SignupController(repository: FakeAuthRepository()));
      expect(textOf(tester, k('signup_welcome_title_text')), 'PetPal Health');
      expect(textOf(tester, k('signup_welcome_tagline_text')),
          'เพื่อนซี้สุขภาพดี พาคุณและสัตว์เลี้ยงมีความสุขไปด้วยกัน');
      expect(
          find.descendant(
              of: k('signup_google_button'),
              matching: find.text('เข้าสู่ระบบด้วย Google')),
          findsOneWidget);
      expect(textOf(tester, k('signup_or_text')), 'หรือ');
      expect(
          find.descendant(
              of: k('signup_email_signup_button'),
              matching: find.text('สมัครสมาชิกด้วยอีเมล')),
          findsOneWidget);
      expect(
          find.descendant(
              of: k('signup_have_account_link'),
              matching: find.text('มีบัญชีอยู่แล้ว? เข้าสู่ระบบ')),
          findsOneWidget);
      // ยังไม่เข้าสู่ระบบ → ไม่เห็นหน้า Home
      expect(k('signup_home_welcome_text'), findsNothing);
    });

    testWidgets('UI_S1_email_button_opens_S2_signup_mode', (tester) async {
      await pumpApp(tester, SignupController(repository: FakeAuthRepository()));
      await openSignupS2(tester);
      expect(textOf(tester, k('signup_email_header_text')), 'สร้างบัญชีผู้ใช้');
      expect(
          find.descendant(
              of: k('signup_submit_button'), matching: find.text('สมัครสมาชิก')),
          findsOneWidget);
    });

    testWidgets('UI_S1_have_account_link_opens_S2', (tester) async {
      await pumpApp(tester, SignupController(repository: FakeAuthRepository()));
      await tester.tap(k('signup_have_account_link'));
      await tester.pumpAndSettle();
      expect(k('signup_email_field'), findsOneWidget);
      expect(k('signup_password_field'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  group('S-2 สมัครด้วยอีเมล', () {
    testWidgets('UI_S2_hints_and_initial_state_button_disabled_no_error',
        (tester) async {
      await pumpApp(tester, SignupController(repository: FakeAuthRepository()));
      await openSignupS2(tester);
      expect(find.text('กรอกอีเมลของคุณ'), findsOneWidget);
      expect(find.text('รหัสผ่าน (อย่างน้อย 6 ตัวอักษร)'), findsOneWidget);
      expect(
          find.descendant(
              of: k('signup_forgot_password_link'),
              matching: find.text('ลืมรหัสผ่าน?')),
          findsOneWidget);
      expect(enabled(tester, k('signup_submit_button')), isFalse);
      expect(k('signup_password_error_text'), findsNothing);
      expect(k('signup_email_duplicate_error_text'), findsNothing);
    });

    testWidgets('AC1_password_abcde_shows_error_immediately_button_disabled',
        (tester) async {
      await pumpApp(tester, SignupController(repository: FakeAuthRepository()));
      await openSignupS2(tester);
      await enter(tester, 'signup_email_field', 'new@email.com');
      await enter(tester, 'signup_password_field', 'abcde');
      expect(textOf(tester, k('signup_password_error_text')), pwShortS2);
      expect(enabled(tester, k('signup_submit_button')), isFalse);
    });

    testWidgets('AC1_EDGE_password_6_chars_no_error_button_enabled',
        (tester) async {
      await pumpApp(tester, SignupController(repository: FakeAuthRepository()));
      await openSignupS2(tester);
      await enter(tester, 'signup_email_field', 'new@email.com');
      await enter(tester, 'signup_password_field', 'abcdef');
      expect(k('signup_password_error_text'), findsNothing);
      expect(enabled(tester, k('signup_submit_button')), isTrue);
      // ลบกลับเหลือ 5 ตัว → error กลับมาและปุ่ม disabled
      await enter(tester, 'signup_password_field', 'abcde');
      expect(k('signup_password_error_text'), findsOneWidget);
      expect(enabled(tester, k('signup_submit_button')), isFalse);
    });

    testWidgets('UXFLOW_happy_path_signup_goes_to_onboarding_S6',
        (tester) async {
      final repo = FakeAuthRepository();
      await pumpApp(tester, SignupController(repository: repo));
      await openSignupS2(tester);
      await enter(tester, 'signup_email_field', 'new@email.com');
      await enter(tester, 'signup_password_field', 'secret1');
      await tapKey(tester, 'signup_submit_button');
      expect(textOf(tester, k('signup_onboarding_header_text')),
          'ข้อมูลสุขภาพเบื้องต้นของคุณ');
      expect(await repo.registeredEmailSet(), {'new@email.com'});
    });

    testWidgets('AC2_EC5_registered_email_shows_email_in_use_stays_on_S2',
        (tester) async {
      final repo = FakeAuthRepository(registeredEmails: ['taken@email.com']);
      await pumpApp(tester, SignupController(repository: repo));
      await openSignupS2(tester);
      await enter(tester, 'signup_email_field', 'taken@email.com');
      await enter(tester, 'signup_password_field', 'secret1');
      await tapKey(tester, 'signup_submit_button');
      expect(textOf(tester, k('signup_email_duplicate_error_text')), emailInUse);
      expect(k('signup_onboarding_header_text'), findsNothing);
      // ค่าที่กรอกคงอยู่ (ui-spec §3 S-2)
      expect(fieldText(tester, 'signup_email_field'), 'taken@email.com');
      expect(await repo.registeredEmailSet(), {'taken@email.com'});
    });

    testWidgets('ASSUMPTION_Q4_email_in_use_error_clears_when_email_edited',
        (tester) async {
      final repo = FakeAuthRepository(registeredEmails: ['taken@email.com']);
      await pumpApp(tester, SignupController(repository: repo));
      await openSignupS2(tester);
      await enter(tester, 'signup_email_field', 'taken@email.com');
      await enter(tester, 'signup_password_field', 'secret1');
      await tapKey(tester, 'signup_submit_button');
      expect(k('signup_email_duplicate_error_text'), findsOneWidget);
      await enter(tester, 'signup_email_field', 'other@email.com');
      expect(k('signup_email_duplicate_error_text'), findsNothing);
    });

    testWidgets('ASSUMPTION_Q15_loading_spinner_and_disabled_while_submitting',
        (tester) async {
      final repo =
          FakeAuthRepository(latency: const Duration(milliseconds: 500));
      final c = SignupController(repository: repo);
      await tester.pumpWidget(
          PetPalApp(waterController: waterController(), signupController: c));
      await tester.pump(const Duration(milliseconds: 500)); // restoreSession
      await tester.pumpAndSettle();
      await openSignupS2(tester);
      await enter(tester, 'signup_email_field', 'new@email.com');
      await enter(tester, 'signup_password_field', 'secret1');
      await tester.tap(k('signup_submit_button'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(k('signup_submit_loading_indicator'), findsOneWidget);
      expect(enabled(tester, k('signup_submit_button')), isFalse);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(k('signup_onboarding_header_text'), findsOneWidget);
    });

    testWidgets('ASSUMPTION_3_S2_network_error_dialog_retry_succeeds',
        (tester) async {
      final repo = FakeAuthRepository(failEmailAuth: true);
      await pumpApp(tester, SignupController(repository: repo));
      await openSignupS2(tester);
      await enter(tester, 'signup_email_field', 'new@email.com');
      await enter(tester, 'signup_password_field', 'secret1');
      await tapKey(tester, 'signup_submit_button');
      expect(k('signup_email_error_dialog'), findsOneWidget);
      repo.failEmailAuth = false;
      await tester.tap(k('signup_email_retry_button'));
      await tester.pumpAndSettle();
      expect(k('signup_onboarding_header_text'), findsOneWidget);
    });

    testWidgets('UI_S2_back_button_returns_to_S1', (tester) async {
      await pumpApp(tester, SignupController(repository: FakeAuthRepository()));
      await openSignupS2(tester);
      await tester.tap(k('signup_email_back_button'));
      await tester.pumpAndSettle();
      expect(k('signup_welcome_title_text'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  group('S-3 / S-4 / S-5 ลืมรหัสผ่าน (US-3)', () {
    testWidgets('US3_forgot_flow_S2_to_S3_to_S4_and_back_to_S2',
        (tester) async {
      final repo = FakeAuthRepository();
      await pumpApp(tester, SignupController(repository: repo));
      await openSignupS2(tester);
      await tapKey(tester, 'signup_forgot_password_link');
      // S-3 ข้อความตาม ux-flow
      expect(textOf(tester, k('signup_forgot_header_text')), 'ลืมรหัสผ่าน');
      expect(textOf(tester, k('signup_forgot_description_text')),
          'กรอกอีเมลที่คุณใช้สมัคร เพื่อรับลิงก์ตั้งค่ารหัสผ่านใหม่');
      expect(find.text('กรอกอีเมลของคุณ'), findsOneWidget);
      expect(
          find.descendant(
              of: k('signup_forgot_submit_button'),
              matching: find.text('ส่งลิงก์รีเซ็ตรหัสผ่าน')),
          findsOneWidget);
      await enter(tester, 'signup_forgot_email_field', 'a@b.com');
      await tapKey(tester, 'signup_forgot_submit_button');
      expect(repo.passwordResetRequests, 1);
      // S-4
      expect(textOf(tester, k('signup_reset_sent_header_text')),
          'ตรวจสอบอีเมลของคุณ');
      expect(textOf(tester, k('signup_reset_sent_message_text')),
          'เราได้ส่งลิงก์สำหรับตั้งรหัสผ่านใหม่ไปที่อีเมลของคุณแล้ว กรุณาตรวจสอบกล่องข้อความ');
      expect(
          find.descendant(
              of: k('signup_back_to_login_button'),
              matching: find.text('กลับสู่หน้าเข้าสู่ระบบ')),
          findsOneWidget);
      await tapKey(tester, 'signup_back_to_login_button');
      expect(k('signup_email_field'), findsOneWidget); // S-2
    });

    testWidgets('UI_S3_back_button_returns_to_S2', (tester) async {
      await pumpApp(tester, SignupController(repository: FakeAuthRepository()));
      await openSignupS2(tester);
      await tapKey(tester, 'signup_forgot_password_link');
      await tapKey(tester, 'signup_forgot_back_button');
      expect(k('signup_email_field'), findsOneWidget);
    });

    Future<FakeAuthRepository> pumpS5(WidgetTester tester) async {
      final repo = FakeAuthRepository(registeredAccounts: {'a@b.com': 'secret1'});
      final c = SignupController(repository: repo);
      await pumpApp(tester, c);
      final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
      nav.push(SignupNewPasswordScreen.route(c, 'a@b.com'));
      await tester.pumpAndSettle();
      return repo;
    }

    testWidgets('UI_S5_texts_and_initial_disabled', (tester) async {
      await pumpS5(tester);
      expect(textOf(tester, k('signup_new_password_header_text')),
          'ตั้งรหัสผ่านใหม่');
      expect(find.text('รหัสผ่านใหม่ (อย่างน้อย 6 ตัวอักษร)'), findsOneWidget);
      expect(
          find.descendant(
              of: k('signup_new_password_save_button'),
              matching: find.text('บันทึกรหัสผ่านใหม่')),
          findsOneWidget);
      expect(enabled(tester, k('signup_new_password_save_button')), isFalse);
    });

    testWidgets('AC3_new_password_5_chars_shows_warning_and_save_rejected',
        (tester) async {
      final repo = await pumpS5(tester);
      await enter(tester, 'signup_new_password_field', 'abcde');
      expect(textOf(tester, k('signup_new_password_error_text')), pwShortS5);
      expect(enabled(tester, k('signup_new_password_save_button')), isFalse);
      await tester.tap(k('signup_new_password_save_button'));
      await tester.pumpAndSettle();
      expect(k('signup_new_password_header_text'), findsOneWidget); // ยังอยู่ S-5
      await repo.signInWithEmail('a@b.com', 'secret1'); // รหัสเดิมยังใช้ได้
    });

    testWidgets('AC3_EDGE_new_password_6_chars_saves_and_goes_S2_with_message',
        (tester) async {
      final repo = await pumpS5(tester);
      await enter(tester, 'signup_new_password_field', 'abcdef');
      expect(k('signup_new_password_error_text'), findsNothing);
      await tapKey(tester, 'signup_new_password_save_button');
      expect(k('signup_email_field'), findsOneWidget); // S-2
      expect(k('signup_password_reset_success_toast'), findsOneWidget);
      await repo.signInWithEmail('a@b.com', 'abcdef');
    });
  });

  // ---------------------------------------------------------------------------
  group('S-1 Google Login (US-2, AC-2, EC-1)', () {
    testWidgets('AC2_google_with_registered_email_links_and_goes_onboarding',
        (tester) async {
      final repo = FakeAuthRepository(
        registeredEmails: ['mali@email.com'],
        googleAccountEmail: 'mali@email.com',
      );
      await pumpApp(tester, SignupController(repository: repo));
      await tester.tap(k('signup_google_button'));
      await tester.pumpAndSettle();
      expect(k('signup_onboarding_header_text'), findsOneWidget);
      expect(k('signup_email_duplicate_error_text'), findsNothing);
      expect(await repo.registeredEmailSet(), {'mali@email.com'});
    });

    testWidgets('EC1_google_network_error_shows_retry_then_retry_succeeds',
        (tester) async {
      final repo = FakeAuthRepository(failGoogleSignIn: true);
      await pumpApp(tester, SignupController(repository: repo));
      await tester.tap(k('signup_google_button'));
      await tester.pumpAndSettle();
      expect(k('signup_google_error_dialog'), findsOneWidget);
      expect(k('signup_google_retry_button'), findsOneWidget);
      expect(k('signup_onboarding_header_text'), findsNothing);
      repo.failGoogleSignIn = false;
      await tester.tap(k('signup_google_retry_button'));
      await tester.pumpAndSettle();
      expect(k('signup_google_error_dialog'), findsNothing);
      expect(k('signup_onboarding_header_text'), findsOneWidget);
    });

    testWidgets('EC1_retry_while_still_offline_shows_retry_again',
        (tester) async {
      final repo = FakeAuthRepository(failGoogleSignIn: true);
      await pumpApp(tester, SignupController(repository: repo));
      await tester.tap(k('signup_google_button'));
      await tester.pumpAndSettle();
      await tester.tap(k('signup_google_retry_button'));
      await tester.pumpAndSettle();
      expect(k('signup_google_error_dialog'), findsOneWidget);
    });

    testWidgets('ASSUMPTION_Q16_retry_dialog_texts', (tester) async {
      final repo = FakeAuthRepository(failGoogleSignIn: true);
      await pumpApp(tester, SignupController(repository: repo));
      await tester.tap(k('signup_google_button'));
      await tester.pumpAndSettle();
      expect(find.text('การเชื่อมต่อขัดข้อง กรุณาลองใหม่อีกครั้ง'), findsOneWidget);
      expect(
          find.descendant(
              of: k('signup_google_retry_button'),
              matching: find.text('ลองใหม่อีกครั้ง')),
          findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  group('S-6 Onboarding', () {
    testWidgets('UI_S6_texts_and_defaults_gender_unspecified_goal_default',
        (tester) async {
      await pumpOnboarding(tester);
      expect(textOf(tester, k('signup_onboarding_description_text')),
          'โปรดกรอกข้อมูลเพื่อให้ PetPal Health ช่วยแนะนำการดูแลสุขภาพที่เหมาะสม');
      expect(find.text('ชื่อที่ใช้แสดง (สูงสุด 20 ตัวอักษร)'), findsOneWidget);
      expect(find.text('อายุ (ปี)'), findsOneWidget);
      expect(find.text('น้ำหนัก (กิโลกรัม)'), findsOneWidget);
      expect(find.text('ส่วนสูง (เซนติเมตร)'), findsOneWidget);
      expect(find.text('ชาย'), findsOneWidget);
      expect(find.text('หญิง'), findsOneWidget);
      expect(find.text('ไม่ระบุ'), findsOneWidget);
      expect(
          tester
              .widget<RadioGroup<SignupGender>>(k('signup_gender_group'))
              .groupValue,
          SignupGender.unspecified);
      expect(fieldText(tester, 'signup_health_goal_field'), 'ดูแลสุขภาพ');
      expect(
          find.descendant(
              of: k('signup_onboarding_save_button'),
              matching: find.text('บันทึกและเริ่มต้นใช้งาน')),
          findsOneWidget);
    });

    testWidgets('AC6_select_unspecified_shows_warning_male_hides_it',
        (tester) async {
      await pumpOnboarding(tester);
      await tapKey(tester, 'signup_gender_male');
      expect(k('signup_gender_warning_text'), findsNothing);
      await tapKey(tester, 'signup_gender_unspecified');
      expect(textOf(tester, k('signup_gender_warning_text')), genderWarn);
      await tapKey(tester, 'signup_gender_female');
      expect(k('signup_gender_warning_text'), findsNothing);
    });

    testWidgets('AC7_empty_weight_warns_only_under_weight', (tester) async {
      await pumpOnboarding(tester);
      await enter(tester, 'signup_height_field', '170');
      expect(textOf(tester, k('signup_weight_warning_text')), metricWarn);
      expect(k('signup_height_warning_text'), findsNothing);
    });

    testWidgets('AC7_empty_height_warns_only_under_height', (tester) async {
      await pumpOnboarding(tester);
      await enter(tester, 'signup_weight_field', '60');
      expect(textOf(tester, k('signup_height_warning_text')), metricWarn);
      expect(k('signup_weight_warning_text'), findsNothing);
    });

    testWidgets('AC6_AC7_warnings_do_not_block_save', (tester) async {
      final (repo, _) = await pumpOnboarding(tester);
      await enter(tester, 'signup_age_field', '30');
      expect(k('signup_gender_warning_text'), findsOneWidget);
      expect(k('signup_weight_warning_text'), findsOneWidget);
      expect(k('signup_height_warning_text'), findsOneWidget);
      expect(enabled(tester, k('signup_onboarding_save_button')), isTrue);
      await tapKey(tester, 'signup_onboarding_save_button');
      final p = (await repo.profileFor('alexander@email.com'))!;
      expect(p.gender, SignupGender.unspecified);
      expect(p.weightKg, isNull);
      expect(p.heightCm, isNull);
      expect(p.healthGoal, 'ดูแลสุขภาพ');
    });

    testWidgets('EC2_age_0_shows_error_and_blocks_save', (tester) async {
      await pumpOnboarding(tester);
      await enter(tester, 'signup_age_field', '0');
      expect(k('signup_age_error_text'), findsOneWidget);
      expect(enabled(tester, k('signup_onboarding_save_button')), isFalse);
    });

    testWidgets('EC2_EDGE_age_120_ok_121_error', (tester) async {
      await pumpOnboarding(tester);
      await enter(tester, 'signup_age_field', '120');
      expect(k('signup_age_error_text'), findsNothing);
      expect(enabled(tester, k('signup_onboarding_save_button')), isTrue);
      await enter(tester, 'signup_age_field', '121');
      expect(k('signup_age_error_text'), findsOneWidget);
      expect(enabled(tester, k('signup_onboarding_save_button')), isFalse);
    });

    testWidgets('EC2_EDGE_age_1_ok', (tester) async {
      await pumpOnboarding(tester);
      await enter(tester, 'signup_age_field', '1');
      expect(k('signup_age_error_text'), findsNothing);
      expect(enabled(tester, k('signup_onboarding_save_button')), isTrue);
    });

    testWidgets('EC2_EDGE_weight_300_ok_301_error', (tester) async {
      await pumpOnboarding(tester);
      await enter(tester, 'signup_age_field', '30');
      await enter(tester, 'signup_weight_field', '300');
      expect(k('signup_weight_error_text'), findsNothing);
      expect(enabled(tester, k('signup_onboarding_save_button')), isTrue);
      await enter(tester, 'signup_weight_field', '301');
      expect(k('signup_weight_error_text'), findsOneWidget);
      expect(enabled(tester, k('signup_onboarding_save_button')), isFalse);
    });

    testWidgets('EC2_EDGE_weight_1_ok_0_error', (tester) async {
      await pumpOnboarding(tester);
      await enter(tester, 'signup_age_field', '30');
      await enter(tester, 'signup_weight_field', '1');
      expect(k('signup_weight_error_text'), findsNothing);
      await enter(tester, 'signup_weight_field', '0');
      expect(k('signup_weight_error_text'), findsOneWidget);
      expect(enabled(tester, k('signup_onboarding_save_button')), isFalse);
    });

    testWidgets('EC2_EDGE_height_250_ok_251_error', (tester) async {
      await pumpOnboarding(tester);
      await enter(tester, 'signup_age_field', '30');
      await enter(tester, 'signup_height_field', '250');
      expect(k('signup_height_error_text'), findsNothing);
      expect(enabled(tester, k('signup_onboarding_save_button')), isTrue);
      await enter(tester, 'signup_height_field', '251');
      expect(k('signup_height_error_text'), findsOneWidget);
      expect(enabled(tester, k('signup_onboarding_save_button')), isFalse);
    });

    testWidgets('EC2_EDGE_height_1_ok_0_error', (tester) async {
      await pumpOnboarding(tester);
      await enter(tester, 'signup_age_field', '30');
      await enter(tester, 'signup_height_field', '1');
      expect(k('signup_height_error_text'), findsNothing);
      await enter(tester, 'signup_height_field', '0');
      expect(k('signup_height_error_text'), findsOneWidget);
      expect(enabled(tester, k('signup_onboarding_save_button')), isFalse);
    });

    // D-c (ทีม): อายุต้องเป็นจำนวนเต็มเท่านั้น — ช่องต้องไม่เปลี่ยนค่าที่พิมพ์/วางเป็นตัวเลขอื่นเงียบ ๆ
    // ("25.5"→"255", "2.5"→"25", "-3"→"3") และต้องบันทึกโปรไฟล์อายุผิดไม่ได้
    const mangled = {
      '25.5': ['255', '25', '5', '2'],
      '2.5': ['25', '2', '5'],
      '-3': ['3'],
      'abc': <String>[],
    };
    for (final entry in mangled.entries) {
      final input = entry.key;
      testWidgets('DECIDED_Dc_age_field_rejects_"$input"_not_changed_cannot_save',
          (tester) async {
        final (repo, _) = await pumpOnboarding(tester);
        await enter(tester, 'signup_age_field', input);
        final shown = fieldText(tester, 'signup_age_field');
        // ยอมรับได้ 2 แบบ: ปฏิเสธ (ช่องคงค่าเดิม = ว่าง) หรือแสดงตามที่พิมพ์พร้อม error
        expect(shown == '' || shown == input, isTrue,
            reason: 'ช่องอายุกลายเป็น "$shown" จาก "$input"');
        for (final bad in entry.value) {
          expect(shown, isNot(bad));
        }
        if (shown == input) {
          expect(k('signup_age_error_text'), findsOneWidget);
        }
        expect(enabled(tester, k('signup_onboarding_save_button')), isFalse);
        await tapKey(tester, 'signup_onboarding_save_button');
        expect(await repo.profileFor('alexander@email.com'), isNull);
        expect(k('signup_onboarding_header_text'), findsOneWidget);
        expect(k('signup_home_welcome_text'), findsNothing);
      });
    }

    testWidgets('DECIDED_Dc_age_field_existing_30_then_paste_2_5_never_saves_25',
        (tester) async {
      final (repo, _) = await pumpOnboarding(tester);
      await enter(tester, 'signup_age_field', '30');
      await enter(tester, 'signup_age_field', '2.5');
      final shown = fieldText(tester, 'signup_age_field');
      expect(shown, isNot('25'));
      if (enabled(tester, k('signup_onboarding_save_button'))) {
        await tapKey(tester, 'signup_onboarding_save_button');
        final p = await repo.profileFor('alexander@email.com');
        expect(p?.age, isNot(25));
        expect(p?.age, isNot(2));
      }
    });

    testWidgets('DECIDED_Dc_EDGE_age_field_integer_25_saves_25', (tester) async {
      final (repo, _) = await pumpOnboarding(tester);
      await enter(tester, 'signup_age_field', '25');
      expect(fieldText(tester, 'signup_age_field'), '25');
      expect(k('signup_age_error_text'), findsNothing);
      await tapKey(tester, 'signup_onboarding_save_button');
      expect((await repo.profileFor('alexander@email.com'))!.age, 25);
    });

    testWidgets('DECIDED_Da_EC3_typed_20_char_name_saved_as_typed',
        (tester) async {
      final (repo, _) = await pumpOnboarding(tester);
      const twenty = 'abcdefghijklmnopqrst';
      await enter(tester, 'signup_display_name_field', '${twenty}uvwxyz');
      expect(fieldText(tester, 'signup_display_name_field'), twenty);
      await enter(tester, 'signup_age_field', '30');
      await tapKey(tester, 'signup_onboarding_save_button');
      final p = (await repo.profileFor('alexander@email.com'))!;
      expect(p.displayName, twenty);
      expect(p.displayNameFromEmail, isFalse);
    });

    testWidgets('EC3_display_name_20_chars_accepted_21st_blocked',
        (tester) async {
      await pumpOnboarding(tester);
      const twenty = 'abcdefghijklmnopqrst'; // 20 ตัว
      await enter(tester, 'signup_display_name_field', twenty);
      expect(fieldText(tester, 'signup_display_name_field'), twenty);
      await enter(tester, 'signup_display_name_field', '${twenty}u'); // ตัวที่ 21
      expect(fieldText(tester, 'signup_display_name_field'), twenty);
      expect(fieldText(tester, 'signup_display_name_field').length, 20);
    });

    testWidgets('EC4_save_network_error_shows_retry_and_keeps_all_values',
        (tester) async {
      final (repo, _) = await pumpOnboarding(tester,
          email: 'mali@email.com',
          repo: FakeAuthRepository(failSaveProfile: true));
      await enter(tester, 'signup_display_name_field', 'Mali');
      await enter(tester, 'signup_age_field', '25');
      await tapKey(tester, 'signup_gender_female');
      await enter(tester, 'signup_weight_field', '55.5');
      await enter(tester, 'signup_height_field', '160');
      await enter(tester, 'signup_health_goal_field', 'ลดน้ำหนัก');
      await tapKey(tester, 'signup_onboarding_save_button');
      expect(k('signup_onboarding_error_dialog'), findsOneWidget);
      expect(k('signup_onboarding_retry_button'), findsOneWidget);
      // ปิด dialog (แตะนอกกรอบ) → ค่าทุกช่องยังอยู่
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(k('signup_onboarding_error_dialog'), findsNothing);
      expect(fieldText(tester, 'signup_display_name_field'), 'Mali');
      expect(fieldText(tester, 'signup_age_field'), '25');
      expect(fieldText(tester, 'signup_weight_field'), '55.5');
      expect(fieldText(tester, 'signup_height_field'), '160');
      expect(fieldText(tester, 'signup_health_goal_field'), 'ลดน้ำหนัก');
      expect(
          tester
              .widget<RadioGroup<SignupGender>>(k('signup_gender_group'))
              .groupValue,
          SignupGender.female);
      expect(enabled(tester, k('signup_onboarding_save_button')), isTrue);
      expect(await repo.profileFor('mali@email.com'), isNull);
    });

    testWidgets('EC4_retry_after_network_back_saves_and_goes_home',
        (tester) async {
      final (repo, _) = await pumpOnboarding(tester,
          email: 'mali@email.com',
          repo: FakeAuthRepository(failSaveProfile: true));
      await enter(tester, 'signup_display_name_field', 'Mali');
      await enter(tester, 'signup_age_field', '25');
      await enter(tester, 'signup_weight_field', '55.5');
      await tapKey(tester, 'signup_onboarding_save_button');
      expect(k('signup_onboarding_error_dialog'), findsOneWidget);
      repo.failSaveProfile = false;
      await tester.tap(k('signup_onboarding_retry_button'));
      await tester.pumpAndSettle();
      expect(k('signup_home_welcome_text'), findsOneWidget);
      final p = (await repo.profileFor('mali@email.com'))!;
      expect(p.displayName, 'Mali');
      expect(p.age, 25);
      expect(p.weightKg, 55.5);
    });
  });

  // ---------------------------------------------------------------------------
  group('S-7 Home + AC-4/AC-5/AC-8', () {
    testWidgets('AC4_AC5_empty_display_name_alexander_banner_shows_alex_dots_er',
        (tester) async {
      final (repo, _) = await pumpOnboarding(tester);
      await enter(tester, 'signup_age_field', '30');
      await tapKey(tester, 'signup_onboarding_save_button');
      expect(textOf(tester, k('signup_home_welcome_text')), contains('alex...er'));
      expect(textOf(tester, k('signup_home_welcome_text')),
          isNot(contains('alexander')));
      expect((await repo.profileFor('alexander@email.com'))!.displayName,
          'alexander');
      // S-7 = หน้า water เดิม
      expect(k('water_log_button'), findsOneWidget);
    });

    testWidgets('AC5_EDGE_email_name_8_chars_banner_shows_full_name',
        (tester) async {
      await pumpOnboarding(tester, email: 'abcdefgh@email.com');
      await enter(tester, 'signup_age_field', '30');
      await tapKey(tester, 'signup_onboarding_save_button');
      expect(textOf(tester, k('signup_home_welcome_text')), contains('abcdefgh'));
      expect(textOf(tester, k('signup_home_welcome_text')),
          isNot(contains('...')));
    });

    testWidgets('DECIDED_Da_long_email_name_banner_abcd_dots_yz_repo_stores_full',
        (tester) async {
      const full = 'abcdefghijklmnopqrstuvwxyz'; // 26 ตัว > 20
      final (repo, _) = await pumpOnboarding(tester, email: '$full@email.com');
      await enter(tester, 'signup_age_field', '30');
      await tapKey(tester, 'signup_onboarding_save_button');
      expect(textOf(tester, k('signup_home_welcome_text')), contains('abcd...yz'));
      final p = (await repo.profileFor('$full@email.com'))!;
      expect(p.displayName, full);
    });

    testWidgets('AC8_reopen_app_skips_login_and_shows_home', (tester) async {
      final store = InMemoryAuthLocalStore();
      final c1 = SignupController(repository: FakeAuthRepository(store: store));
      await c1.load();
      await c1.signUpWithEmail('alexander@email.com', 'secret1');
      await c1.saveProfile(
          displayName: '',
          age: '30',
          gender: SignupGender.male,
          weight: '70',
          height: '175',
          healthGoal: 'ดูแลสุขภาพ');
      // เปิดแอปใหม่: repository/controller ใหม่ ใช้ storage เดิม
      final c2 = SignupController(repository: FakeAuthRepository(store: store));
      await tester.pumpWidget(
          PetPalApp(waterController: waterController(), signupController: c2));
      expect(k('signup_welcome_title_text'), findsNothing); // ไม่เห็น S-1
      await tester.pumpAndSettle();
      expect(k('signup_welcome_title_text'), findsNothing);
      expect(k('signup_google_button'), findsNothing);
      expect(textOf(tester, k('signup_home_welcome_text')), contains('alex...er'));
      expect(k('water_log_button'), findsOneWidget);
    });

    testWidgets('UI_auth_loading_spinner_while_reading_token', (tester) async {
      final repo =
          FakeAuthRepository(latency: const Duration(milliseconds: 300));
      await tester.pumpWidget(PetPalApp(
          waterController: waterController(),
          signupController: SignupController(repository: repo)));
      expect(k('signup_auth_loading'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      expect(k('signup_auth_loading'), findsNothing);
      expect(k('signup_welcome_title_text'), findsOneWidget);
    });

    testWidgets('EDGE_corrupt_stored_session_opens_S1_without_crash',
        (tester) async {
      final store = InMemoryAuthLocalStore()
        ..values[SignupStorageKeys.session] = 'garbage{';
      await pumpApp(tester,
          SignupController(repository: FakeAuthRepository(store: store)));
      expect(k('signup_welcome_title_text'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('REGRESSION_no_signup_controller_goes_straight_to_water',
        (tester) async {
      await tester.pumpWidget(PetPalApp(waterController: waterController()));
      await tester.pumpAndSettle();
      expect(k('water_log_button'), findsOneWidget);
      expect(k('signup_home_welcome_text'), findsNothing);
    });
  });
}
