/// Logic เกมของฟีเจอร์ dashboard — pure Dart ไม่ขึ้นกับ widget
///
/// สูตรคะแนน / เกณฑ์อยู่ใน DashboardRules — ไฟล์นี้ประกอบผล (snapshot), สร้างคิวข้อความ
/// และเลือกข้อความที่แสดงในการหมุนเวียน
library;

import '../../shared/pet/pet_pose.dart' show PetPose;
import 'dashboard_models.dart';
import 'dashboard_rules.dart';

class DashboardLogic {
  DashboardLogic._();

  // ---------------------------------------------------------------------------
  // คะแนน + อารมณ์ (AC-1, AC-2, EC-1, EC-4, EC-5)
  // ---------------------------------------------------------------------------

  static DashboardSnapshot snapshot(DashboardInput input) {
    final water = DashboardRules.waterScore(input.cups);
    final steps = DashboardRules.stepsScore(input.steps, input.stepsGoal);
    final food = DashboardRules.foodScore(
      input.totalCalories,
      input.targetCalories,
    );
    final total = DashboardRules.totalScore(
      waterScore: water,
      stepsScore: steps,
      foodScore: food,
    );
    // Q-2: ไม่มีเป้า → isOverLimit เป็น false อยู่แล้ว (FoodLogic.isOverLimit)
    final overLimit = input.isFoodOverLimit && input.targetCalories != null;
    return DashboardSnapshot(
      waterScore: water,
      stepsScore: steps,
      foodScore: food,
      totalScore: total,
      mood: moodFor(total),
      isFoodOverLimit: overLimit,
      alerts: alertQueue(
        waterScore: water,
        stepsScore: steps,
        foodScore: food,
        isFoodOverLimit: overLimit,
        hasMealsToday: input.hasMealsToday,
        isFoodOverTarget: input.targetCalories != null &&
            input.totalCalories > input.targetCalories!,
      ),
    );
  }

  /// CRYING [0,30] · DAZED (30,60] · BUBBLY (60,80] · CHEERFUL (80,100] — จาก totalScore หลังปัด
  static DashboardPetMood moodFor(int totalScore) {
    if (totalScore <= DashboardRules.cryingMaxScore) {
      return DashboardPetMood.crying;
    }
    if (totalScore <= DashboardRules.dazedMaxScore) {
      return DashboardPetMood.dazed;
    }
    if (totalScore <= DashboardRules.bubblyMaxScore) {
      return DashboardPetMood.bubbly;
    }
    return DashboardPetMood.cheerful;
  }

  /// อารมณ์ → ท่าของ shared pet (D-1, ui-spec §4)
  // DECIDED (owner ชั่วคราว, รอบ 2): BUBBLY ใช้หน้าเดิม (dashboardBubbly == waterHappy)
  static PetPose poseFor(DashboardPetMood mood) => switch (mood) {
        DashboardPetMood.crying => PetPose.dashboardCrying,
        DashboardPetMood.dazed => PetPose.dashboardDazed,
        DashboardPetMood.bubbly => PetPose.dashboardBubbly,
        DashboardPetMood.cheerful => PetPose.dashboardCheerful,
      };

  // ---------------------------------------------------------------------------
  // Dynamic Alert Queue (AC-3, EC-2, game-rules §1.1)
  // ---------------------------------------------------------------------------

  /// คิวข้อความที่ trigger อยู่ เรียง Priority 1 → 4 — ประเมินสดจากค่าปัจจุบันทุกครั้ง
  /// ("คัดออกทันทีเมื่อแก้ปัญหาสำเร็จ" = เงื่อนไขไม่เป็นจริงแล้วจึงไม่อยู่ในคิว)
  static List<DashboardAlert> alertQueue({
    required int waterScore,
    required int stepsScore,
    required int? foodScore,
    required bool isFoodOverLimit,
    required bool hasMealsToday,
    required bool isFoodOverTarget,
  }) {
    return List.unmodifiable([
      // P1: เกินเป้า > 100 kcal (FoodController.isOverLimit) — ค้างจนตัดรอบ 05:00 (Q-2)
      if (isFoodOverLimit) DashboardAlert.overeating,
      if (waterScore < DashboardRules.waterAlertBelowScore)
        DashboardAlert.drinkWater,
      if (stepsScore < DashboardRules.stepsAlertBelowScore)
        DashboardAlert.moveBody,
      if (isHungry(
        foodScore: foodScore,
        hasMealsToday: hasMealsToday,
        isFoodOverTarget: isFoodOverTarget,
      ))
        DashboardAlert.hungry,
    ]);
  }

  /// P4 「ฉันหิว」: ยังไม่บันทึกมื้อใดวันนี้ หรือ foodScore < 50 (D-4)
  // ASSUMPTION: ui-spec Q-3 — ประเมิน trigger แบบสด: บันทึกแล้วแต่ foodScore ยัง < 50 ข้อความยังอยู่
  // · ไม่มีเป้า (foodScore null) → ใช้เฉพาะ "ยังไม่บันทึกมื้อใด"
  // ASSUMPTION: ส่วน "foodScore < 50" นับเฉพาะตอนกินยังไม่ถึงเป้า (kcal ≤ target) — กินเกินเป้า
  // มากจน foodScore < 50 ไม่ขึ้น「ฉันหิว」 (ขัดกับ P1「อิ่มและอืดเกินไป」)
  // DECIDED (owner รอบ 3, BUG-DASH-1 / QD-2): ยึดทางนี้ — กินเกินเป้าไม่ขึ้น「ฉันหิว」
  static bool isHungry({
    required int? foodScore,
    required bool hasMealsToday,
    required bool isFoodOverTarget,
  }) {
    if (!hasMealsToday) return true;
    if (foodScore == null || isFoodOverTarget) return false;
    return foodScore < DashboardRules.foodHungryBelowScore;
  }

  /// เลือกข้อความที่ควรแสดงหลังคิวเปลี่ยน (ไม่ใช่ตอนครบ 5 วินาที)
  /// - คิวว่าง → null (ซ่อนฟอง — Q-10)
  /// - ยังไม่มีข้อความ / ข้ามรอบวัน → ข้อความ Priority สูงสุด (Q-19, ui-spec §3 ข้ามช่วงเวลา)
  /// - ข้อความที่แสดงอยู่หลุดจากคิว → ข้อความลำดับถัดไปทันที (EC-2, game-rules §4) วนกลับต้นคิว
  /// - มีข้อความใหม่เข้าคิว → ข้อความ Priority สูงสุด (Q-19)
  /// - อื่น ๆ → คงข้อความเดิม
  // ASSUMPTION: ui-spec Q-19 ค่าชั่วคราว — รอ game-rules ยืนยัน
  static DashboardAlert? resolveAlert({
    required List<DashboardAlert> previousQueue,
    required List<DashboardAlert> queue,
    required DashboardAlert? current,
    bool dayChanged = false,
  }) {
    if (queue.isEmpty) return null;
    if (current == null || dayChanged) return queue.first;
    if (!queue.contains(current)) return _after(queue, current.priority);
    final added = queue.any((a) => !previousQueue.contains(a));
    if (added) return queue.first;
    return current;
  }

  /// ข้อความถัดไปเมื่อครบ alertInterval (วนลูปตามลำดับ Priority)
  static DashboardAlert? nextAlert(
    List<DashboardAlert> queue,
    DashboardAlert? current,
  ) {
    if (queue.isEmpty) return null;
    if (current == null) return queue.first;
    return _after(queue, current.priority);
  }

  /// ข้อความแรกในคิวที่ Priority ต่ำกว่า (เลขมากกว่า) [priority] — ไม่มี → วนกลับต้นคิว
  static DashboardAlert _after(List<DashboardAlert> queue, int priority) {
    for (final a in queue) {
      if (a.priority > priority) return a;
    }
    return queue.first;
  }
}
