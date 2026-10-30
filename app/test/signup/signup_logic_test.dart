// Unit tests: กติกา signup (pure Dart) — ค่าคาดหวังทุกตัวมาจาก
// docs/signup/requirements.md (AC/EC) และ docs/signup/game-rules.md (§1, §3, §4)
// ไม่ได้ลอกจากโค้ด: ตัวเลขถูกพิมพ์ตรงในเทสต์ตามเอกสาร
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/signup/signup_logic.dart';
import 'package:petpal_health/features/signup/signup_models.dart';
import 'package:petpal_health/features/signup/signup_rules.dart';

UserProfile? build({
  String email = 'user@email.com',
  String displayName = '',
  String age = '30',
  SignupGender gender = SignupGender.unspecified,
  String weight = '',
  String height = '',
  String healthGoal = 'ดูแลสุขภาพ',
}) =>
    SignupLogic.buildProfile(
      email: email,
      displayName: displayName,
      age: age,
      gender: gender,
      weight: weight,
      height: height,
      healthGoal: healthGoal,
    );

void main() {
  group('game-rules §1 ค่าหลัก', () {
    test('RULES_game_rules_s1_constants_match_doc', () {
      expect(SignupRules.minPasswordLength, 6); // min_password_length
      expect(SignupRules.maxDisplayNameLength, 20); // max_display_name_length
      expect(SignupRules.displayNameTruncationLimit, 8); // display_name_truncation_limit
      expect(SignupRules.minAge, 1);
      expect(SignupRules.maxAge, 120);
      expect(SignupRules.minWeight, 1.0);
      expect(SignupRules.maxWeight, 300.0);
      expect(SignupRules.minHeight, 1.0);
      expect(SignupRules.maxHeight, 250.0);
      expect(SignupRules.defaultHealthGoal, 'ดูแลสุขภาพ');
      expect(SignupGender.defaultValue.code, 'UNSPECIFIED'); // default_gender
    });
  });

  group('AC-1 / AC-3 ความยาวรหัสผ่าน (min_password_length = 6)', () {
    test('AC1_password_5_chars_abcde_shows_error_and_cannot_submit', () {
      // game-rules §3: password = "abcde" → Error แสดงผล, button = disabled
      expect(SignupLogic.showsPasswordError('abcde'), isTrue);
      expect(SignupLogic.canSubmitCredentials('new@email.com', 'abcde'), isFalse);
    });

    test('AC1_password_1_char_shows_error', () {
      expect(SignupLogic.showsPasswordError('a'), isTrue);
      expect(SignupLogic.canSubmitCredentials('new@email.com', 'a'), isFalse);
    });

    test('AC1_EDGE_password_exactly_6_no_error_can_submit', () {
      expect(SignupLogic.showsPasswordError('abcdef'), isFalse);
      expect(SignupLogic.isPasswordLongEnough('abcdef'), isTrue);
      expect(SignupLogic.canSubmitCredentials('new@email.com', 'abcdef'), isTrue);
    });

    test('AC3_new_password_5_rejected_6_accepted', () {
      expect(SignupLogic.isPasswordLongEnough('abcde'), isFalse);
      expect(SignupLogic.isPasswordLongEnough('abcdef'), isTrue);
    });

    test('ASSUMPTION_Q3_empty_password_no_error_but_cannot_submit', () {
      // ui-spec Q-3: ช่องว่าง = สถานะว่าง ไม่ใช่ error (ปุ่มยัง disabled ตาม ux-flow §4 S-2 ปกติ)
      expect(SignupLogic.showsPasswordError(''), isFalse);
      expect(SignupLogic.canSubmitCredentials('new@email.com', ''), isFalse);
    });
  });

  group('AC-4 / AC-5 Display Name จากหน้าอีเมล', () {
    test('AC4_empty_display_name_uses_email_local_part', () {
      final r = SignupLogic.resolveDisplayName('', 'alexander@email.com');
      expect(r.name, 'alexander');
      expect(r.fromEmail, isTrue);
    });

    test('AC4_typed_display_name_is_kept', () {
      final r = SignupLogic.resolveDisplayName('Mali', 'alexander@email.com');
      expect(r.name, 'Mali');
      expect(r.fromEmail, isFalse);
    });

    test('AC5_alexander_truncates_to_alex_dots_er', () {
      // requirements AC-5 / game-rules §3
      expect(SignupLogic.truncateEmailName('alexander'), 'alex...er');
    });

    test('AC5_EDGE_email_name_exactly_8_chars_not_truncated', () {
      // "ยาวเกิน 8" จึงตัด → ยาว 8 พอดีแสดงเต็ม
      expect(SignupLogic.truncateEmailName('abcdefgh'), 'abcdefgh');
    });

    test('AC5_EDGE_email_name_9_chars_truncated_4_dots_2', () {
      expect(SignupLogic.truncateEmailName('abcdefghi'), 'abcd...hi');
    });

    test('AC5_display_for_ui_profile_from_email_alexander', () {
      final p = build(email: 'alexander@email.com')!;
      expect(p.displayName, 'alexander'); // AC-4 บันทึกชื่อหน้าอีเมล
      expect(SignupLogic.displayNameForUi(p), 'alex...er'); // AC-5 แสดงบน UI
    });

    test('AC5_long_email_name_over_20_shows_first4_dots_last2_of_email_name',
        () {
      // AC-5: "4 ตัวแรก + ... + 2 ตัวท้าย" ของชื่อหน้าอีเมล
      // ชื่อหน้าอีเมล = abcdefghijklmnopqrstuvwxyz (26 ตัว) → 2 ตัวท้าย = "yz"
      final p = build(email: 'abcdefghijklmnopqrstuvwxyz@email.com')!;
      expect(SignupLogic.displayNameForUi(p), 'abcd...yz');
    });

    test('DECIDED_Da_email_name_over_20_saved_full_not_capped', () {
      // D-a (owner ชั่วคราว): ชื่อจากอีเมลบันทึกชื่อหน้า @ เต็ม ไม่ตัดที่ 20
      const full = 'abcdefghijklmnopqrstuvwxyz'; // 26 ตัว
      final r = SignupLogic.resolveDisplayName('', '$full@email.com');
      expect(r.name, full);
      expect(r.fromEmail, isTrue);
      final p = build(email: '$full@email.com')!;
      expect(p.displayName, full);
      expect(p.displayName.length, 26);
      expect(p.displayNameFromEmail, isTrue);
      // AC-5 ย่อตอนแสดงผลจากชื่อเต็ม
      expect(SignupLogic.displayNameForUi(p), 'abcd...yz');
    });

    test('DECIDED_Da_EC3_typed_display_name_20_kept_21_capped_to_20', () {
      // D-a: ลิมิต 20 (max_display_name_length, EC-3) ใช้กับชื่อที่ผู้ใช้พิมพ์เอง
      const twenty = 'abcdefghijklmnopqrst'; // 20 ตัว
      final r20 = SignupLogic.resolveDisplayName(twenty, 'x@email.com');
      expect(r20.name, twenty);
      expect(r20.fromEmail, isFalse);
      final r21 = SignupLogic.resolveDisplayName('${twenty}u', 'x@email.com');
      expect(r21.name, twenty);
      expect(r21.name.length, 20);
      final p = build(displayName: 'abcdefghijklmnopqrstuvwxyz')!;
      expect(p.displayName, twenty);
      expect(p.displayNameFromEmail, isFalse);
    });
  });

  group('AC-6 / AC-7 คำเตือน (ไม่บล็อกการบันทึก — fallback game-rules §5)', () {
    test('AC6_unspecified_gender_shows_warning_male_female_do_not', () {
      expect(SignupLogic.showsGenderWarning(SignupGender.unspecified), isTrue);
      expect(SignupLogic.showsGenderWarning(SignupGender.male), isFalse);
      expect(SignupLogic.showsGenderWarning(SignupGender.female), isFalse);
    });

    test('AC7_empty_weight_only_warns_weight', () {
      final v = SignupLogic.validateOnboarding(
          age: '30', weight: '', height: '170', gender: SignupGender.male);
      expect(v.showWeightWarning, isTrue);
      expect(v.showHeightWarning, isFalse);
      expect(v.canSave, isTrue);
    });

    test('AC7_empty_height_only_warns_height', () {
      final v = SignupLogic.validateOnboarding(
          age: '30', weight: '60', height: '', gender: SignupGender.male);
      expect(v.showWeightWarning, isFalse);
      expect(v.showHeightWarning, isTrue);
      expect(v.canSave, isTrue);
    });

    test('AC6_AC7_warnings_do_not_block_save_values_stay_null', () {
      // game-rules §3: weight = null, height = null หลังบันทึก; gender = UNSPECIFIED
      final p = build(gender: SignupGender.unspecified)!;
      expect(p.weightKg, isNull);
      expect(p.heightCm, isNull);
      expect(p.gender, SignupGender.unspecified);
    });
  });

  group('EC-2 ขอบเขตตัวเลข (game-rules §1, §4 — รวมขอบ)', () {
    test('EC2_age_1_and_120_valid', () {
      expect(SignupLogic.ageStatus('1'), NumberFieldStatus.valid);
      expect(SignupLogic.ageStatus('120'), NumberFieldStatus.valid);
    });

    test('EC2_age_0_and_121_out_of_range', () {
      expect(SignupLogic.ageStatus('0'), NumberFieldStatus.outOfRange);
      expect(SignupLogic.ageStatus('121'), NumberFieldStatus.outOfRange);
    });

    test('EC2_weight_1_and_300_valid_0_and_301_out_of_range', () {
      expect(SignupLogic.weightStatus('1'), NumberFieldStatus.valid);
      expect(SignupLogic.weightStatus('300'), NumberFieldStatus.valid);
      expect(SignupLogic.weightStatus('300.0'), NumberFieldStatus.valid);
      expect(SignupLogic.weightStatus('0'), NumberFieldStatus.outOfRange);
      expect(SignupLogic.weightStatus('301'), NumberFieldStatus.outOfRange);
    });

    test('EC2_weight_float_just_outside_bounds_out_of_range', () {
      // Float 1.0 - 300.0 → 0.9 และ 300.1 อยู่นอกขอบ
      expect(SignupLogic.weightStatus('0.9'), NumberFieldStatus.outOfRange);
      expect(SignupLogic.weightStatus('300.1'), NumberFieldStatus.outOfRange);
    });

    test('EC2_height_1_and_250_valid_0_and_251_out_of_range', () {
      expect(SignupLogic.heightStatus('1'), NumberFieldStatus.valid);
      expect(SignupLogic.heightStatus('250'), NumberFieldStatus.valid);
      expect(SignupLogic.heightStatus('0'), NumberFieldStatus.outOfRange);
      expect(SignupLogic.heightStatus('251'), NumberFieldStatus.outOfRange);
      expect(SignupLogic.heightStatus('250.1'), NumberFieldStatus.outOfRange);
    });

    test('EC2_any_out_of_range_field_blocks_save', () {
      bool canSave(String a, String w, String h) => SignupLogic.validateOnboarding(
              age: a, weight: w, height: h, gender: SignupGender.male)
          .canSave;
      expect(canSave('30', '60', '170'), isTrue);
      expect(canSave('0', '60', '170'), isFalse);
      expect(canSave('121', '60', '170'), isFalse);
      expect(canSave('30', '301', '170'), isFalse);
      expect(canSave('30', '60', '251'), isFalse);
      expect(build(age: '121'), isNull);
    });

    test('DECIDED_Dc_age_non_integer_text_is_not_valid', () {
      // D-c (ทีม): อายุต้องเป็นจำนวนเต็มเท่านั้น — ทศนิยม/เครื่องหมาย/ตัวอักษร/ฐาน 16 ไม่ผ่าน
      for (final a in ['25.5', '2.5', '-3', 'abc', '+25', '0x19']) {
        expect(SignupLogic.ageStatus(a), isNot(NumberFieldStatus.valid),
            reason: 'age "$a"');
        expect(SignupLogic.ageStatus(a), NumberFieldStatus.outOfRange,
            reason: 'age "$a" ต้องแสดง error และบล็อกการบันทึก');
        expect(
            SignupLogic.validateOnboarding(
                    age: a, weight: '60', height: '170', gender: SignupGender.male)
                .canSave,
            isFalse,
            reason: 'age "$a"');
      }
    });

    test('DECIDED_Dc_buildProfile_non_integer_age_returns_null', () {
      for (final a in ['25.5', '2.5', '-3', 'abc', '+25', '0x19']) {
        expect(build(age: a), isNull, reason: 'age "$a"');
      }
    });

    test('DECIDED_Dc_EDGE_integer_age_25_still_valid', () {
      // ค่าคู่เทียบ: จำนวนเต็มในช่วงยังบันทึกได้และไม่เปลี่ยนค่า
      expect(SignupLogic.ageStatus('25'), NumberFieldStatus.valid);
      expect(build(age: '25')!.age, 25);
    });

    test('ASSUMPTION_Q11_empty_age_blocks_save', () {
      expect(SignupLogic.ageStatus(''), NumberFieldStatus.empty);
      expect(build(age: ''), isNull);
    });
  });

  group('ค่าเริ่มต้น / Onboarding (game-rules §1)', () {
    test('DEFAULT_health_goal_saved_as_dulae_sukkhaphap', () {
      final p = build()!;
      expect(p.healthGoal, 'ดูแลสุขภาพ');
    });

    test('ASSUMPTION_Q10_cleared_health_goal_saves_default', () {
      expect(build(healthGoal: '   ')!.healthGoal, 'ดูแลสุขภาพ');
    });

    test('ASSUMPTION_unknown_gender_code_falls_back_to_unspecified', () {
      expect(SignupGender.fromCode('???'), SignupGender.unspecified);
      expect(SignupGender.fromCode(null), SignupGender.unspecified);
    });
  });

  group('การนำทาง (ux-flow §3, AC-2, AC-8)', () {
    const noProfile = AuthSession(token: 't', email: 'a@b.com');
    final withProfile = noProfile.copyWith(profile: build());

    test('AC8_route_loading_then_welcome_without_session', () {
      expect(SignupLogic.routeFor(isLoaded: false, session: null),
          SignupRoute.loading);
      expect(SignupLogic.routeFor(isLoaded: true, session: null),
          SignupRoute.welcome);
    });

    test('AC8_route_home_when_session_with_profile', () {
      expect(SignupLogic.routeFor(isLoaded: true, session: withProfile),
          SignupRoute.home);
    });

    test('AC2_route_onboarding_when_google_linked_even_with_profile', () {
      expect(
          SignupLogic.routeFor(
              isLoaded: true, session: withProfile, forceOnboarding: true),
          SignupRoute.onboarding);
    });

    test('UXFLOW_step4_new_account_without_profile_goes_onboarding', () {
      expect(SignupLogic.routeFor(isLoaded: true, session: noProfile),
          SignupRoute.onboarding);
    });
  });
}
