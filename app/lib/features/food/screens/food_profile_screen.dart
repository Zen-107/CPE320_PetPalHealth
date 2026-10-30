import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../signup/signup_models.dart' show SignupGender;
import '../../signup/widgets/signup_widgets.dart'
    show SignupButtonLabel, SignupWholeNumberInputFormatter;
import '../food_controller.dart';
import '../food_logic.dart';
import '../food_rules.dart';

/// S-3 หน้าจอตั้งค่าโปรไฟล์สุขภาพเบื้องต้น — ux-flow §2 S-3, ui-spec §2.3
/// AC-4, AC-5, AC-6, AC-7 (ผ่าน FoodLogic), EC-5, US-3
///
/// Q-13 DECIDED: บันทึกเข้าโปรไฟล์ของ signup · Q-14 DECIDED: กติกาเดียวกับ signup —
/// อายุรับจำนวนเต็มเท่านั้น (ปฏิเสธการพิมพ์จุด), น้ำหนัก/ส่วนสูงรับทศนิยม
class FoodProfileScreen extends StatefulWidget {
  const FoodProfileScreen({super.key, required this.controller});

  final FoodController controller;

  @override
  State<FoodProfileScreen> createState() => _FoodProfileScreenState();
}

class _FoodProfileScreenState extends State<FoodProfileScreen> {
  late final TextEditingController _age;
  late final TextEditingController _weight;
  late final TextEditingController _height;
  SignupGender? _gender;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // ASSUMPTION: มีโปรไฟล์ signup แต่ไม่ครบ (เช่น เพศไม่ระบุ / ไม่มีน้ำหนัก) แล้วกด CTA →
    // เติมค่าเดิมไว้ในฟอร์ม (แบบ signup S-6) · ไม่มีโปรไฟล์ = ฟอร์มว่าง ไม่เลือกเพศไว้ก่อน
    final p = widget.controller.profile;
    _age = TextEditingController(text: p?.age.toString() ?? '');
    _weight = TextEditingController(text: _fmt(p?.weightKg));
    _height = TextEditingController(text: _fmt(p?.heightCm));
    final g = p?.gender;
    _gender = g == SignupGender.male || g == SignupGender.female ? g : null;
  }

  static String _fmt(double? v) {
    if (v == null) return '';
    return v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
  }

  @override
  void dispose() {
    _age.dispose();
    _weight.dispose();
    _height.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final outcome = await widget.controller.saveProfile(
      age: _age.text,
      gender: _gender,
      weight: _weight.text,
      height: _height.text,
    );
    if (!mounted) return;
    if (outcome == FoodProfileSaveOutcome.saved) {
      Navigator.of(context).pop();
      return;
    }
    // ASSUMPTION: บันทึกไม่สำเร็จ — ux-flow ไม่มีสถานะ error ของ S-3 → อยู่หน้าเดิม ค่าคงเดิม
    // กดบันทึกซ้ำได้ (ไม่แสดงข้อความใหม่)
    setState(() => _saving = false);
  }

  Future<void> _skip() async {
    await widget.controller.skipProfile();
    if (mounted) Navigator.of(context).pop();
  }

  void _onChanged(String _) => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final v = FoodLogic.validateProfile(
      age: _age.text,
      gender: _gender,
      weight: _weight.text,
      height: _height.text,
    );
    final enabled = !_saving;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          FoodRules.profileTitle,
          key: Key('food_profile_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('food_age_field'),
                controller: _age,
                enabled: enabled,
                keyboardType: TextInputType.number,
                // Q-14 DECIDED (owner): กติกาเดียวกับ signup — ปฏิเสธการพิมพ์/วางที่ไม่ใช่
                // เลขล้วน ("20.5" ไม่เข้าช่อง) แทนตัวกรอง [0-9.] ของ ui-spec §2.3 #2
                inputFormatters: [
                  const SignupWholeNumberInputFormatter(),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: _onChanged,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: FoodRules.ageHint,
                  // AC-4, EC-5: ไม่ใช่จำนวนเต็ม 1–120 → error + บล็อกการบันทึก
                  error: v.showAgeError
                      ? Text(
                          FoodRules.ageError,
                          key: const Key('food_age_error_text'),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                FoodRules.genderLabel,
                key: const Key('food_gender_label'),
                style: theme.textTheme.titleMedium,
              ),
              RadioGroup<SignupGender>(
                key: const Key('food_gender_group'),
                groupValue: _gender,
                onChanged: (g) {
                  if (g == null || !enabled) return;
                  setState(() => _gender = g);
                },
                child: Column(
                  children: [
                    RadioListTile<SignupGender>(
                      key: const Key('food_gender_male'),
                      value: SignupGender.male,
                      enabled: enabled,
                      contentPadding: EdgeInsets.zero,
                      title: const Text(FoodRules.genderMaleText),
                    ),
                    RadioListTile<SignupGender>(
                      key: const Key('food_gender_female'),
                      value: SignupGender.female,
                      enabled: enabled,
                      contentPadding: EdgeInsets.zero,
                      title: const Text(FoodRules.genderFemaleText),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('food_weight_field'),
                controller: _weight,
                enabled: enabled,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: _onChanged,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: FoodRules.weightHint,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('food_height_field'),
                controller: _height,
                enabled: enabled,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: _onChanged,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: FoodRules.heightHint,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('food_profile_save_button'),
                onPressed: enabled && v.canSave ? _save : null,
                // ASSUMPTION: ระหว่างบันทึกแสดง spinner ในปุ่มแบบ signup (ui-spec ไม่ระบุ loading)
                child: SignupButtonLabel(
                  text: FoodRules.profileSaveText,
                  loading: _saving,
                  indicatorKey: 'food_profile_save_loading_indicator',
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  key: const Key('food_profile_skip_button'),
                  // ui-spec §3 S-3: enabled เสมอ
                  onPressed: _skip,
                  child: const Text(FoodRules.profileSkipText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
