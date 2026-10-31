/// โมเดลของฟีเจอร์ dashboard — ไม่มีข้อมูลที่เก็บลงเครื่อง (ค่าทั้งหมดอ่านจาก controller เดิม)
library;

import 'dashboard_rules.dart';

/// อารมณ์สัตว์เลี้ยงตาม totalScore (game-rules.md §2)
enum DashboardPetMood {
  crying,
  dazed,
  bubbly,
  cheerful;

  /// ใช้ใน key `dashboard_pet_image_<keyName>`
  String get keyName => name;

  /// ชื่อไทย (game-rules §2) — semanticLabel ของสัตว์เลี้ยง
  String get label => switch (this) {
        DashboardPetMood.crying => DashboardRules.moodCryingLabel,
        DashboardPetMood.dazed => DashboardRules.moodDazedLabel,
        DashboardPetMood.bubbly => DashboardRules.moodBubblyLabel,
        DashboardPetMood.cheerful => DashboardRules.moodCheerfulLabel,
      };
}

/// ข้อความใน Dynamic Alert Queue (game-rules.md §1.1) — เรียงตาม Priority 1 → 4
enum DashboardAlert {
  overeating(1, DashboardRules.alertOvereatingText),
  drinkWater(2, DashboardRules.alertDrinkWaterText),
  moveBody(3, DashboardRules.alertMoveBodyText),
  hungry(4, DashboardRules.alertHungryText);

  const DashboardAlert(this.priority, this.text);

  /// 1 = สำคัญสูงสุด
  final int priority;

  /// ข้อความบนจอ (ตรงตัว)
  final String text;
}

/// ค่าดิบที่ dashboard อ่านจาก controller เดิม ณ ขณะหนึ่ง (ไม่คำนวณ/เก็บซ้ำ)
class DashboardInput {
  const DashboardInput({
    required this.cups,
    required this.steps,
    required this.stepsGoal,
    required this.totalCalories,
    required this.targetCalories,
    required this.isFoodOverLimit,
    required this.hasMealsToday,
  });

  /// WaterController.cups
  final int cups;

  /// StepsController.steps
  final int steps;

  /// StepsController.activeGoal
  final int stepsGoal;

  /// FoodController.totalCalories
  final int totalCalories;

  /// FoodController.targetCalories (null = ไม่มีเป้า / ข้ามโปรไฟล์)
  final int? targetCalories;

  /// FoodController.isOverLimit (Priority 1 / หลอดแดง)
  final bool isFoodOverLimit;

  /// FoodController.state.meals ไม่ว่าง
  final bool hasMealsToday;
}

/// ผลคำนวณของ dashboard ณ ขณะหนึ่ง
class DashboardSnapshot {
  const DashboardSnapshot({
    required this.waterScore,
    required this.stepsScore,
    required this.foodScore,
    required this.totalScore,
    required this.mood,
    required this.isFoodOverLimit,
    required this.alerts,
  });

  final int waterScore;
  final int stepsScore;

  /// null = ไม่คิดคะแนน (ไม่มีเป้าอาหาร — D-3)
  final int? foodScore;
  final int totalScore;
  final DashboardPetMood mood;

  /// แถบอาหารสีแดง (Priority 1)
  final bool isFoodOverLimit;

  /// คิวข้อความที่ trigger อยู่ เรียง Priority 1 → 4
  final List<DashboardAlert> alerts;

  bool get hasFoodScore => foodScore != null;
}
