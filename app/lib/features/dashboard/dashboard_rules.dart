/// ค่าคงที่กติกาเกม + สูตรคะแนนของฟีเจอร์ dashboard (คะแนนสุขภาพรวมและอารมณ์สัตว์เลี้ยง)
///
/// ตัวเลขกติกามาจาก docs/dashboard/game-rules.md §1, §1.1, §2 และ requirements.md AC-1..AC-5
/// สูตรคะแนนรายหมวดมาจากข้อตัดสิน owner D-3 / D-4 / Q-1 (docs/dashboard/ui-spec.md §0, §6)
/// ขนาด/ระยะหน้าจอมาจาก ui-spec.md §1.3 · ข้อความบนจอมาจาก ux-flow.md §2 / game-rules.md §1.1
/// (ตรงตัว) และ ui-spec ("เสนอ — รอยืนยัน")
///
/// dashboard ไม่มีข้อมูล/รอบวันของตัวเอง — อ่านค่าจาก WaterController / StepsController /
/// FoodController เท่านั้น (D-2) ไฟล์นี้จึงมีแค่สูตรแปลงค่าเหล่านั้นเป็นคะแนน 0–100
library;

import 'dart:math' as math;

import '../water/water_rules.dart';

class DashboardRules {
  DashboardRules._();

  // ---------------------------------------------------------------------------
  // game-rules.md §1 ค่าหลัก — ช่วงคะแนน
  // ---------------------------------------------------------------------------

  /// คะแนนต่ำสุดของทุกหมวด / คะแนนรวม (EC-4: ติดลบหรือ Null → 0)
  static const int minScore = 0;

  /// คะแนนสูงสุดของทุกหมวด / คะแนนรวม (AC-1, EC-1: Cap 100%)
  static const int maxScore = 100;

  /// alertInterval — หมุนข้อความแจ้งเตือนทุก 5 วินาที (US-3, AC-3)
  static const int alertIntervalSeconds = 5;

  /// resetHour — ไม่มีรอบวันของ dashboard เอง: ใช้ 05:00 ของ water / steps / food (D-2)
  /// ค่านี้อ้างอิงค่าเดียวกับ WaterRules (ไม่ตั้งเลขใหม่) เพื่อเอกสารเท่านั้น
  static const int resetHour = WaterRules.dailyResetHour;

  // ---------------------------------------------------------------------------
  // game-rules.md §2 อารมณ์สัตว์เลี้ยง — ขอบบน "รวม" ของแต่ละช่วง (คิดจาก totalScore หลังปัด)
  // CRYING [0, 30] · DAZED (30, 60] · BUBBLY (60, 80] · CHEERFUL (80, 100]  (AC-2, Q-13)
  // ---------------------------------------------------------------------------
  static const int cryingMaxScore = 30;
  static const int dazedMaxScore = 60;
  static const int bubblyMaxScore = 80;

  // ---------------------------------------------------------------------------
  // game-rules.md §1.1 Dynamic Alert Queue — เกณฑ์ trigger
  // ---------------------------------------------------------------------------

  /// Priority 1: "Overeating > 100 kcal / หลอดอาหารแสดงสีแดง" — ใช้ FoodController.isOverLimit
  /// ตัวเดียวกับหลอดแดงของ food (เกณฑ์ 100 kcal อยู่ที่ FoodRules.overLimitThreshold —
  /// ไม่ตั้งเลขซ้ำที่นี่)

  /// Priority 2 / 3: อยู่ในคิวเมื่อคะแนน "ต่ำกว่า" ค่านี้ (`waterScore < 100%`, `stepsScore < 100%`)
  // DECIDED (owner ชั่วคราว รอบ 2, Q-4): ยึด game-rules (< 100) ไม่ใช่ brief (< 80)
  static const int waterAlertBelowScore = 100;
  static const int stepsAlertBelowScore = 100;

  /// Priority 4: "คะแนนอาหารต่ำกว่าเกณฑ์" = foodScore < 50
  // ASSUMPTION: DECIDED (owner ชั่วคราว, รอทีมยืนยัน) D-4 — เกณฑ์ 50
  static const int foodHungryBelowScore = 50;

  // ---------------------------------------------------------------------------
  // Q-14 เป้าน้ำ (แก้ว)
  // ---------------------------------------------------------------------------

  /// เป้าน้ำประจำวัน (แก้ว) สำหรับสูตร D-3 `actual / target`
  // ASSUMPTION: DECIDED (owner ชั่วคราว รอบ 2, Q-14) — water ไม่มีค่าคงที่ "เป้าแก้ว" ตรง ๆ
  // จึง derive จากค่าคงที่ของ water: energyMaxDisplayPercentage / energyIncrementPercentage
  // = 100 / 12.5 = 8 แก้ว (ไม่พิมพ์เลข 8 เอง)
  // DECIDED (owner รอบ 3, QD-1): ใช้ 8 แก้วจากค่าคงที่ของ water ต่อ
  // หมายเหตุ: สัตว์เลี้ยงของ water ร่าเริงตั้งแต่ 7 แก้ว แต่ที่ 7 แก้ว waterScore = 87 (floor)
  static int get waterTargetCups => (WaterRules.energyMaxDisplayPercentage /
          WaterRules.energyIncrementPercentage)
      .round();

  // ---------------------------------------------------------------------------
  // สูตรคะแนน (D-3, Q-1, EC-4) — pure ฟังก์ชัน
  //
  // DECIDED (owner รอบ 3, 2026-10-31): ปัดคะแนน "ลง" (floor) ทุกตัว — แทน round ของ D-3 / Q-1 /
  // ui-spec Q-16 · Water / Steps / Food / total ได้ 100 ก็ต่อเมื่อถึงเป้าจริงเท่านั้น
  // (เช่น 7,999 / 8,000 ก้าว = 99) · ใช้เลขจำนวนเต็ม (`~/`) ทั้งหมด ไม่มีเศษ floating point
  // ผลต่อตัวอย่าง game-rules §3: (70, 60, 67) → 197 / 3 = 65.66 → **65** (เอกสาร/EC-5 เขียน 66)
  // ---------------------------------------------------------------------------

  /// EC-4: ค่าติดลบ / Null → 0 และไม่เกิน 100 (ค่าทศนิยมปัดลง — owner รอบ 3)
  static int clampScore(num? value) {
    if (value == null || value.isNaN || value < minScore) return minScore;
    if (value > maxScore) return maxScore;
    return value.floor();
  }

  /// Water / Steps = `floor(min(actual / target, 1) × 100)`
  // ASSUMPTION: DECIDED (owner ชั่วคราว) D-3 + รอบ 3 (floor แทน round)
  // คำนวณ `actual × 100 ~/ target` (จำนวนเต็ม) · target ≤ 0 → 0 (กันหารศูนย์) · actual ≤ 0 → 0 (EC-4)
  static int ratioScore(int actual, int target) {
    if (target <= 0 || actual <= 0) return minScore;
    return clampScore(actual * 100 ~/ target);
  }

  /// waterScore จากจำนวนแก้วของรอบวันปัจจุบัน (WaterController.cups)
  static int waterScore(int cups) => ratioScore(cups, waterTargetCups);

  /// stepsScore จากก้าวและเป้าที่ใช้อยู่ (StepsController.steps / activeGoal)
  static int stepsScore(int steps, int activeGoal) =>
      ratioScore(steps, activeGoal);

  /// foodScore จาก kcal รวมวันนี้และเป้า (FoodController.totalCalories / targetCalories)
  /// - ไม่มีเป้า (ข้ามโปรไฟล์) → null = "ไม่คิดคะแนน"
  /// - ถึงเป้า (kcal ≤ target) → `floor((kcal / target) × 100)` (= 100 เฉพาะ kcal == target)
  /// - เกินเป้า → `floor(max(0, 100 − (ส่วนที่เกิน / target × 100)))` (เกิน 1 kcal ก็ < 100)
  // ASSUMPTION: DECIDED (owner ชั่วคราว) D-3 + รอบ 3 (floor แทน round)
  // ASSUMPTION: target ≤ 0 (ไม่ควรเกิดจาก FoodLogic) ถือเป็น "ไม่มีเป้า" กันหารศูนย์
  static int? foodScore(int totalCalories, int? targetCalories) {
    if (targetCalories == null || targetCalories <= 0) return null;
    final kcal = math.max(0, totalCalories); // EC-4
    if (kcal <= targetCalories) {
      return clampScore(kcal * 100 ~/ targetCalories);
    }
    // floor(100 − x) = 100 − ceil(x) โดย x = ส่วนที่เกิน × 100 / target
    final overScaled = (kcal - targetCalories) * 100;
    final overCeil = (overScaled + targetCalories - 1) ~/ targetCalories;
    return clampScore(maxScore - overCeil);
  }

  /// totalScore = `floor((Food + Steps + Water) / 3)` cap 100 (AC-1, EC-1)
  /// Food ไม่คิดคะแนน (null) → `floor((Steps + Water) / 2)`
  // ASSUMPTION: DECIDED (owner ชั่วคราว รอบ 2, Q-1) — ไม่มีเป้าอาหาร หาร 2
  // DECIDED (owner รอบ 3): floor แทน round — EC-5 (65.66 → 66) เปลี่ยนเป็น 65
  static int totalScore({
    required int waterScore,
    required int stepsScore,
    required int? foodScore,
  }) {
    final w = clampScore(waterScore);
    final s = clampScore(stepsScore);
    if (foodScore == null) return clampScore((s + w) ~/ 2);
    return clampScore((clampScore(foodScore) + s + w) ~/ 3);
  }

  // ---------------------------------------------------------------------------
  // ui-spec §1.3 ขนาด / ระยะ / เวลา (ไม่ใช่กติกาเกม — ค่าหน้าตา)
  // ---------------------------------------------------------------------------

  /// ขนาดสัตว์เลี้ยง 200 × 200 (ui-spec §1.3, Q-9 — แทน fallback 300×300 ของ PNG ตาม D-1)
  static const double petSize = 200;

  /// ระยะขอบล่างช่องข้อความ ↔ ขอบบนกล่องสัตว์เลี้ยง (ui-spec §1.3, §2.1.1)
  static const double alertAnchorOffset = 12;

  /// ความสูงแถบรายหมวด (ui-spec §1.3)
  static const double barMinHeight = 12;

  /// ความถี่ตรวจรอบวันขณะเปิดหน้าค้าง (ui-spec §3 "ข้ามช่วงเวลา")
  // ASSUMPTION: เอกสารไม่กำหนดความถี่ — 1 วินาทีแบบ _dayCheckInterval ของ steps / food
  static const int dayCheckIntervalSeconds = 1;

  // ---------------------------------------------------------------------------
  // ข้อความบนหน้าจอ
  // ---------------------------------------------------------------------------

  // ASSUMPTION: ui-spec Q-8 (เสนอ — รอยืนยัน) — หัวข้อ AppBar และ tooltip ปุ่มทางเข้า
  static const String screenTitle = 'แดชบอร์ด';
  static const String entryTooltip = 'แดชบอร์ด';

  /// game-rules §1.1 — ตรงตัว ไม่รวม `"` ตัวคั่น
  // ASSUMPTION: ui-spec Q-21 — `"` ในเอกสารเป็นตัวคั่น string ไม่ใช่ส่วนของข้อความบนจอ
  static const String alertOvereatingText =
      'แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว';
  static const String alertDrinkWaterText = 'ดื่มน้ำๆ';
  static const String alertMoveBodyText = 'ขยับร่างกายหน่อย อีกนิดๆ';
  static const String alertHungryText = 'ฉันหิว';

  /// ชื่อไทยของอารมณ์ (game-rules §2) — ใช้เป็น semanticLabel ไม่แสดงบนจอ (ui-spec §2.1 #5)
  static const String moodCryingLabel = 'ร้องไห้';
  static const String moodDazedLabel = 'เหม่อลอย';
  static const String moodBubblyLabel = 'ออรุ่มเจ๊าะ';
  static const String moodCheerfulLabel = 'ยิ้มร่าเริง';

  /// ux-flow §2 `คะแนนสุขภาพรวม: [Integer]%`
  static String totalScoreText(int score) => 'คะแนนสุขภาพรวม: $score%';

  /// ux-flow §2 `คะแนนอาหาร: [Integer]%`
  static String foodScoreText(int score) => 'คะแนนอาหาร: $score%';

  /// ux-flow §2 `คะแนนการก้าวเดิน: [Integer]%`
  static String stepsScoreText(int score) => 'คะแนนการก้าวเดิน: $score%';

  /// ux-flow §2 `คะแนนการดื่มน้ำ: [Integer]%`
  static String waterScoreText(int score) => 'คะแนนการดื่มน้ำ: $score%';

  /// ป้ายแถบอาหารเมื่อไม่มีเป้า (ไม่คิดคะแนน — D-3)
  // ASSUMPTION: ui-spec Q-1 (เสนอ — รอยืนยัน)
  static const String foodNoTargetText = 'คะแนนอาหาร: ยังไม่มีเป้าหมาย';
}
