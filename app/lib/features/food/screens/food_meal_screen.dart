import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../signup/widgets/signup_widgets.dart'
    show SignupButtonLabel, SignupWarningText;
import '../food_controller.dart';
import '../food_rules.dart';

/// S-2 หน้าจอเพิ่มเมนูอาหาร — ux-flow §2 S-2, ui-spec §2.2
/// AC-1, AC-2 (ผ่าน FoodController / FoodLogic), AC-3, EC-1
class FoodMealScreen extends StatefulWidget {
  const FoodMealScreen({super.key, required this.controller});

  final FoodController controller;

  @override
  State<FoodMealScreen> createState() => _FoodMealScreenState();
}

class _FoodMealScreenState extends State<FoodMealScreen> {
  final TextEditingController _menu = TextEditingController();
  final TextEditingController _manual = TextEditingController();

  /// S-2 Error / Offline (EC-1) — แสดงช่องกรอกแคลอรี่สำรอง
  bool _fallback = false;

  /// กำลังประมวลผล (ui-spec Q-11)
  bool _loading = false;

  @override
  void dispose() {
    _menu.dispose();
    _manual.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    setState(() => _loading = true);
    // ASSUMPTION: ในสถานะผิดพลาด/ออฟไลน์ กดบันทึก = บันทึกค่าที่กรอกเอง (ว่าง = 300 kcal)
    // ไม่ส่งข้อความเมนูไปประมวลผลซ้ำ (ux-flow S-2 "หรือบันทึกค่า Manual หากออฟไลน์")
    final outcome = _fallback
        ? await widget.controller.submitManual(_manual.text)
        : await widget.controller.submitMeal(_menu.text);
    if (!mounted) return;
    switch (outcome) {
      case MealSubmitOutcome.logged:
        // ux-flow S-2: กลับ S-1 (S-1 แสดงท่ากิน) — ไม่มีข้อความยืนยัน
        Navigator.of(context).pop();
        return;
      case MealSubmitOutcome.parseFailed:
        setState(() {
          _loading = false;
          _fallback = true;
        });
      case MealSubmitOutcome.invalidCalories:
      case MealSubmitOutcome.notReady:
        setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = !_loading;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('food_meal_back_button'),
          icon: const Icon(Icons.arrow_back),
          tooltip: FoodRules.backButtonText,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          FoodRules.mealTitle,
          key: Key('food_meal_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('food_meal_input_field'),
                controller: _menu,
                enabled: enabled,
                minLines: 3,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: FoodRules.mealInputHint,
                ),
              ),
              if (_fallback) ...[
                const SizedBox(height: 16),
                // EC-1: ช่องว่างเปล่า (ไม่เติม 300) — ค่า default ใช้ตอนบันทึก
                TextField(
                  key: const Key('food_manual_calorie_field'),
                  controller: _manual,
                  enabled: enabled,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    // ASSUMPTION: จำกัดจำนวนหลัก (FoodRules.manualCaloriesMaxDigits)
                    LengthLimitingTextInputFormatter(
                      FoodRules.manualCaloriesMaxDigits,
                    ),
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: FoodRules.manualCalorieHint,
                    helper: SignupWarningText(
                      FoodRules.manualCalorieHelper,
                      key: Key('food_manual_calorie_helper_text'),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('food_meal_submit_button'),
                onPressed: enabled ? _submit : null,
                child: SignupButtonLabel(
                  text: FoodRules.mealSubmitText,
                  loading: _loading,
                  indicatorKey: 'food_meal_submit_loading_indicator',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
