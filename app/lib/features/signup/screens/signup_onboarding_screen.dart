import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../signup_controller.dart';
import '../signup_logic.dart';
import '../signup_models.dart';
import '../signup_rules.dart';
import '../widgets/signup_widgets.dart';
import 'signup_gate.dart';

/// S-6 หน้า Onboarding (ux-flow §2 S-6, ui-spec §2.6)
/// AC-4, AC-5 (ผ่าน SignupLogic), AC-6, AC-7, EC-2, EC-3, EC-4
class SignupOnboardingScreen extends StatefulWidget {
  const SignupOnboardingScreen({super.key, required this.controller});

  final SignupController controller;

  @override
  State<SignupOnboardingScreen> createState() => _SignupOnboardingScreenState();
}

class _SignupOnboardingScreenState extends State<SignupOnboardingScreen> {
  late final TextEditingController _displayName;
  late final TextEditingController _age;
  late final TextEditingController _weight;
  late final TextEditingController _height;
  late final TextEditingController _healthGoal;
  late SignupGender _gender;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // ASSUMPTION: บัญชีที่มีโปรไฟล์อยู่แล้วแต่ถูกพามา S-6 (AC-2 Account Linking)
    // → เติมค่าเดิมไว้ในฟอร์ม เพื่อไม่ให้ข้อมูลเดิมถูกทับด้วยค่าว่าง
    final existing = widget.controller.session?.profile;
    _displayName = TextEditingController(
        text: existing == null || existing.displayNameFromEmail
            ? ''
            : existing.displayName);
    _age = TextEditingController(text: existing?.age.toString() ?? '');
    _weight = TextEditingController(text: _fmt(existing?.weightKg));
    _height = TextEditingController(text: _fmt(existing?.heightCm));
    // default_health_goal เป็นข้อความจริงในช่อง (ไม่ใช่ hint) — ui-spec §2.6 #16
    _healthGoal = TextEditingController(
        text: existing?.healthGoal ?? SignupRules.defaultHealthGoal);
    _gender = existing?.gender ?? SignupGender.defaultValue;
  }

  static String _fmt(double? v) {
    if (v == null) return '';
    return v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
  }

  @override
  void dispose() {
    _displayName.dispose();
    _age.dispose();
    _weight.dispose();
    _height.dispose();
    _healthGoal.dispose();
    super.dispose();
  }

  OnboardingValidation get _validation => SignupLogic.validateOnboarding(
        age: _age.text,
        weight: _weight.text,
        height: _height.text,
        gender: _gender,
      );

  Future<void> _save() async {
    if (_saving || !_validation.canSave) return;
    setState(() => _saving = true);
    final outcome = await widget.controller.saveProfile(
      displayName: _displayName.text,
      age: _age.text,
      gender: _gender,
      weight: _weight.text,
      height: _height.text,
      healthGoal: _healthGoal.text,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    switch (outcome) {
      case SaveProfileOutcome.success:
        // SignupGate เปลี่ยนหน้ารากเป็น S-7
        popToSignupRoot(context);
      case SaveProfileOutcome.networkError:
        // EC-4: ฟอร์มยังอยู่ใต้ dialog ค่าทุกช่องคงเดิม
        final retry = await showSignupNetworkErrorDialog(
          context,
          dialogKey: 'signup_onboarding_error_dialog',
          retryKey: 'signup_onboarding_retry_button',
        );
        if (retry && mounted) await _save();
      case SaveProfileOutcome.invalid:
        break;
    }
  }

  void _onChanged(String _) => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final v = _validation;
    final enabled = !_saving;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          SignupRules.onboardingHeader,
          key: Key('signup_onboarding_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                SignupRules.onboardingDescription,
                key: Key('signup_onboarding_description_text'),
              ),
              const SizedBox(height: 16),
              // EC-3: บล็อกตัวที่ 21 ในระดับ UI; ตัวนับ n/20 เป็น default ของ maxLength
              // ASSUMPTION: ui-spec Q-19 — นับตัวอักษรแบบ grapheme ของ TextField.maxLength
              TextField(
                key: const Key('signup_display_name_field'),
                controller: _displayName,
                enabled: enabled,
                maxLength: SignupRules.maxDisplayNameLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                onChanged: _onChanged,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: SignupRules.displayNameHint,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_age_field'),
                controller: _age,
                enabled: enabled,
                keyboardType: TextInputType.number,
                // D-c: จำนวนเต็มเท่านั้น — การพิมพ์/วางที่มีอักขระอื่นปน ("25.5", "-3",
                // "abc") ถูกปฏิเสธทั้งก้อนก่อนถึง digitsOnly จึงไม่เปลี่ยนค่าเงียบ ๆ
                inputFormatters: [
                  const SignupWholeNumberInputFormatter(),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: _onChanged,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.ageHint,
                  error: v.showAgeError
                      ? Text(SignupRules.ageRangeError,
                          key: const Key('signup_age_error_text'))
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                SignupRules.genderLabel,
                key: const Key('signup_gender_label'),
                style: theme.textTheme.titleMedium,
              ),
              RadioGroup<SignupGender>(
                key: const Key('signup_gender_group'),
                groupValue: _gender,
                onChanged: (g) {
                  if (g == null || !enabled) return;
                  setState(() => _gender = g);
                },
                child: Column(
                  children: [
                    for (final g in SignupGender.values)
                      RadioListTile<SignupGender>(
                        key: Key('signup_gender_${g.name}'),
                        value: g,
                        enabled: enabled,
                        contentPadding: EdgeInsets.zero,
                        title: Text(g.label),
                      ),
                  ],
                ),
              ),
              // AC-6: เตือนทันทีเมื่อเลือก UNSPECIFIED — ไม่บล็อกการบันทึก
              if (v.showGenderWarning)
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: SignupWarningText(
                    SignupRules.genderWarning,
                    key: Key('signup_gender_warning_text'),
                  ),
                ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_weight_field'),
                controller: _weight,
                enabled: enabled,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: _onChanged,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.weightHint,
                  // AC-7 warning (ไม่บล็อก) / EC-2 error (บล็อก) — error แทนที่ helper เอง
                  helper: v.showWeightWarning
                      ? const SignupWarningText(
                          SignupRules.bodyMetricMissingWarning,
                          key: Key('signup_weight_warning_text'),
                        )
                      : null,
                  error: v.showWeightError
                      ? Text(SignupRules.weightRangeError,
                          key: const Key('signup_weight_error_text'))
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_height_field'),
                controller: _height,
                enabled: enabled,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: _onChanged,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.heightHint,
                  helper: v.showHeightWarning
                      ? const SignupWarningText(
                          SignupRules.bodyMetricMissingWarning,
                          key: Key('signup_height_warning_text'),
                        )
                      : null,
                  error: v.showHeightError
                      ? Text(SignupRules.heightRangeError,
                          key: const Key('signup_height_error_text'))
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_health_goal_field'),
                controller: _healthGoal,
                enabled: enabled,
                minLines: 3,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: SignupRules.healthGoalLabel,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('signup_onboarding_save_button'),
                onPressed: enabled && v.canSave ? _save : null,
                child: SignupButtonLabel(
                  text: SignupRules.onboardingSaveText,
                  loading: _saving,
                  indicatorKey: 'signup_onboarding_loading_indicator',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
