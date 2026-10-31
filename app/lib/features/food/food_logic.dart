/// Logic เกมของฟีเจอร์ food — pure Dart ไม่ขึ้นกับ widget
///
/// ทุกฟังก์ชันที่เกี่ยวกับเวลารับ `now` เป็นพารามิเตอร์ เพื่อให้ QA ทดสอบได้
library;

import 'dart:convert';

import '../../shared/pet/pet_pose.dart' show PetPose;
import '../signup/signup_logic.dart' show NumberFieldStatus, SignupLogic;
import '../signup/signup_models.dart' show SignupGender, UserProfile;
import '../steps/steps_logic.dart' show StepsLogic;
import 'food_models.dart';
import 'food_rules.dart';

class FoodLogic {
  FoodLogic._();

  // ---------------------------------------------------------------------------
  // รอบวัน 05:00 น. (AC-3, US-5, game-rules §4 Foreground Crossing)
  // ---------------------------------------------------------------------------

  /// วันที่ "ตามรอบวัน" ที่เริ่ม 05:00 น. — AC-3: 15 ต.ค. 03:00 → 14 ต.ค.
  static DateTime logicalDay(DateTime now) {
    // ใช้ constructor ของ DateTime (ไม่ใช่ subtract Duration) กัน DST ทำให้วันเพี้ยน
    final shifted = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour - FoodRules.dailyResetHour,
      now.minute - FoodRules.dailyResetMinute,
    );
    return DateTime(shifted.year, shifted.month, shifted.day);
  }

  /// เวลาที่ใช้คำนวณกติกา: ไม่ถอยหลังกว่าเวลาล่าสุดที่ระบบเคยเห็น
  // ASSUMPTION: นาฬิกาเครื่องย้อน → ใช้เวลาล่าสุดที่เคยเห็น (ไม่ย้อนรอบวัน ไม่ลบข้อมูล)
  // แนวเดียวกับ StepsLogic.effectiveNow / WaterLogic — เอกสาร food ไม่กำหนด
  static DateTime effectiveNow(DateTime? lastSeenAt, DateTime now) =>
      lastSeenAt != null && now.isBefore(lastSeenAt) ? lastSeenAt : now;

  /// ตรวจและปรับรอบวัน ณ `now`:
  /// - ครั้งแรก (day == null) → ตั้งรอบวันปัจจุบัน 0 kcal
  /// - ข้าม 05:00 น. → เก็บรอบวันเดิมลงประวัติ แล้วรีเซ็ตเป็น 0 kcal
  /// - ตัดประวัติที่เก่ากว่า HISTORY_RETENTION_DAYS
  /// [targetCalories] = เป้าหมายปัจจุบัน ใช้คำนวณ `is_over_target` ของวันที่ถูกเก็บ
  /// คืน object เดิม (identical) ถ้าไม่มีอะไรเปลี่ยน
  static FoodState applyDayRollover(
    FoodState state,
    DateTime now, {
    int? targetCalories,
  }) {
    final effective = effectiveNow(state.lastSeenAt, now);
    final today = logicalDay(effective);
    final day = state.day;
    if (day == null) {
      return state.copyWith(
        day: today,
        totalCalories: 0,
        meals: const [],
        lastSeenAt: effective,
      );
    }
    if (!today.isAfter(day)) return state;
    final record = DailyFoodRecord(
      date: day,
      totalCalories: state.totalCalories,
      targetCalories: targetCalories,
      isOverTarget: isOverLimit(state.totalCalories, targetCalories),
      highSodium: state.todayHighSodium,
      highSugar: state.todayHighSugar,
    );
    return state.copyWith(
      day: today,
      totalCalories: 0,
      meals: const [],
      history: pruneHistory(upsertHistory(state.history, record), today),
      lastSeenAt: effective,
    );
  }

  /// ใส่/แทนที่ประวัติวันเดียวกัน แล้วเรียงเก่า → ใหม่
  static List<DailyFoodRecord> upsertHistory(
    List<DailyFoodRecord> history,
    DailyFoodRecord record,
  ) {
    final next = [
      for (final r in history)
        if (r.date != record.date) r,
      record,
    ]..sort((a, b) => a.date.compareTo(b.date));
    return List.unmodifiable(next);
  }

  /// เก็บเฉพาะวันที่อยู่ใน HISTORY_RETENTION_DAYS วันล่าสุด (นับรวม [today])
  static List<DailyFoodRecord> pruneHistory(
    List<DailyFoodRecord> history,
    DateTime today,
  ) {
    final oldest = DateTime(
      today.year,
      today.month,
      today.day - (FoodRules.historyRetentionDays - 1),
    );
    return List.unmodifiable([
      for (final r in history)
        if (!r.date.isBefore(oldest) && r.date.isBefore(today)) r,
    ]);
  }

  /// บันทึก 1 มื้อ ณ `now` (ตรวจรอบวันก่อน — AC-3) — total เพิ่มทันที
  static FoodState logMeal(
    FoodState state,
    FoodNutrition nutrition,
    DateTime now, {
    int? targetCalories,
    bool manual = false,
  }) {
    final rolled = applyDayRollover(state, now, targetCalories: targetCalories);
    final effective = effectiveNow(rolled.lastSeenAt, now);
    final calories = nutrition.calories < 0 ? 0 : nutrition.calories;
    final entry = FoodMealEntry(
      date: rolled.day!,
      loggedAt: effective,
      calories: calories,
      highSodium: nutrition.highSodium,
      highSugar: nutrition.highSugar,
      manual: manual,
    );
    return rolled.copyWith(
      totalCalories: rolled.totalCalories + calories,
      meals: List.unmodifiable([...rolled.meals, entry]),
      lastSeenAt: effective,
    );
  }

  // ---------------------------------------------------------------------------
  // เป้าหมายแคลอรี่ (AC-5, AC-6, AC-7, Base Target Reference Table)
  // ---------------------------------------------------------------------------

  /// Base Target ตามอายุและเพศ — null = คำนวณไม่ได้ (เพศไม่ระบุ / อายุนอก AGE_MIN..AGE_MAX)
  static int? baseTarget(int age, SignupGender gender) {
    if (!isAgeInRange(age)) return null;
    final bool male;
    switch (gender) {
      case SignupGender.male:
        male = true;
      case SignupGender.female:
        male = false;
      case SignupGender.unspecified:
        // ASSUMPTION: เพศ UNSPECIFIED (จาก signup S-6) ไม่มีในตาราง → ไม่มีเป้าหมาย
        // (signup AC-6 "ไม่สามารถคำนวณจำนวนแคลอรี่ที่เหมาะสมต่อวันได้") → แสดง CTA Banner
        return null;
    }
    if (age >= FoodRules.ageBand51upMin) {
      return male
          ? FoodRules.maleBaseTarget51up
          : FoodRules.femaleBaseTarget51up;
    }
    if (age >= FoodRules.ageBand19to50Min) {
      return male
          ? FoodRules.maleBaseTarget19to50
          : FoodRules.femaleBaseTarget19to50;
    }
    if (age >= FoodRules.ageBand16to18Min) {
      return male
          ? FoodRules.maleBaseTarget16to18
          : FoodRules.femaleBaseTarget16to18;
    }
    if (age >= FoodRules.ageBand13to15Min) {
      return male
          ? FoodRules.maleBaseTarget13to15
          : FoodRules.femaleBaseTarget13to15;
    }
    if (age >= FoodRules.ageBand10to12Min) {
      return male
          ? FoodRules.maleBaseTarget10to12
          : FoodRules.femaleBaseTarget10to12;
    }
    // อายุ 1–9 ปี — fallback ของ Design (game-rules §5)
    return male
        ? FoodRules.fallbackBaseTargetAge1to9Male
        : FoodRules.fallbackBaseTargetAge1to9Female;
  }

  /// BMI_FORMULA = weight_kg / ((height_cm / 100) ^ 2) — null ถ้าค่าไม่บวก
  /// คำนวณเป็น `weight * 10000 / (height * height)` (หารครั้งเดียว ลด floating error ที่ขอบ)
  // ASSUMPTION: เทียบเกณฑ์ด้วยค่า BMI จริง ไม่ปัดเป็นทศนิยม 1 ตำแหน่งก่อนเทียบ
  // ("Float 1 ตำแหน่ง" ใน game-rules ถือเป็นรูปแบบของค่าเกณฑ์)
  static double? bmi(double weightKg, double heightCm) {
    if (weightKg <= 0 || heightCm <= 0) return null;
    return weightKg * 10000 / (heightCm * heightCm);
  }

  /// ส่วนปรับตาม BMI: < 18.5 → +400 (AC-6), ≥ 23.0 → −400 (AC-7), อื่น ๆ → 0
  static int bmiAdjustment(double bmi) {
    if (bmi < FoodRules.bmiUnderweightThreshold) {
      return FoodRules.bmiUnderweightBonus;
    }
    if (bmi >= FoodRules.bmiOverweightThreshold) {
      return -FoodRules.bmiOverweightPenalty;
    }
    return 0;
  }

  /// `target_calories` — null = ไม่มีเป้าหมาย (แสดง CTA Banner, ไม่มี OVER_LIMIT — Q-9)
  static int? targetCalories({
    required int age,
    required SignupGender gender,
    required double? weightKg,
    required double? heightCm,
  }) {
    final base = baseTarget(age, gender);
    if (base == null || weightKg == null || heightCm == null) {
      // ASSUMPTION: โปรไฟล์ signup ที่ไม่มีน้ำหนัก/ส่วนสูง คำนวณ BMI ไม่ได้ → ไม่มีเป้าหมาย
      // (signup AC-7 "จะไม่มีการแนะนำแคลอรี่ที่เหมาะสมต่อวัน")
      return null;
    }
    final b = bmi(weightKg, heightCm);
    if (b == null) return null;
    return base + bmiAdjustment(b);
  }

  /// เป้าหมายจากโปรไฟล์ของ signup (Q-13) — null = ไม่มีโปรไฟล์ / ไม่ครบ
  static int? targetForProfile(UserProfile? profile) {
    if (profile == null) return null;
    return targetCalories(
      age: profile.age,
      gender: profile.gender,
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
    );
  }

  // ---------------------------------------------------------------------------
  // สถานะสัตว์เลี้ยง / หลอดพลังงาน (AC-9, AC-10, AC-11, game-rules §2)
  // ---------------------------------------------------------------------------

  /// `total > target + OVER_LIMIT_THRESHOLD` — ไม่มีเป้าหมาย → false เสมอ (Q-9)
  static bool isOverLimit(int total, int? target) =>
      target != null && total > target + FoodRules.overLimitThreshold;

  /// สถานะคงที่ (ไม่รวมท่าชั่วคราว)
  static FoodPetState basePetState(int total, int? target) =>
      isOverLimit(total, target) ? FoodPetState.overLimit : FoodPetState.normal;

  /// ท่าชั่วคราวหลังบันทึกสำเร็จ — [wasOverLimit] = ก่อนบันทึกอยู่ในสถานะเกินเป้าแล้ว
  /// (AC-11 / EC-3 → OVER_LIMIT_FEEDING, อื่น ๆ → EATING)
  static FoodPetState transientStateForLog({required bool wasOverLimit}) =>
      wasOverLimit ? FoodPetState.overLimitFeeding : FoodPetState.eating;

  /// ระยะของท่าชั่วคราว
  static Duration transientDuration(FoodPetState state) =>
      state == FoodPetState.overLimitFeeding
      ? const Duration(seconds: FoodRules.overLimitFeedingSeconds)
      : const Duration(seconds: FoodRules.eatingAnimationSeconds);

  /// Toast หลังบันทึก — AC-11: บันทึกขณะเกินเป้า → 「พอเถอะน้าคนดี」 ทุกครั้ง; อื่น ๆ → null
  static String? toastForLog({required bool wasOverLimit}) =>
      wasOverLimit ? FoodRules.overLimitToastText : null;

  /// สถานะ → ท่าของ shared pet (OQ-1 DECIDED: PetCharacter แทน Lottie/PNG)
  static PetPose poseFor(FoodPetState state) => switch (state) {
    FoodPetState.normal => PetPose.foodNormal,
    FoodPetState.eating => PetPose.foodEating,
    FoodPetState.overLimit => PetPose.foodOverLimit,
    FoodPetState.overLimitFeeding => PetPose.foodOverLimitFeeding,
  };

  /// สัดส่วนหลอด 0.0–1.0 (ui-spec §2.1 #9a: clamp)
  static double energyFraction(int total, int target) {
    if (target <= 0 || total <= 0) return 0;
    final f = total / target;
    return f > 1 ? 1 : f;
  }

  /// `'<total> / <target> kcal'` เช่น `1,900 / 2,000 kcal` (ไม่ clamp)
  static String calorieText(int total, int target) =>
      '${StepsLogic.formatThousands(total)} / '
      '${StepsLogic.formatThousands(target)} ${FoodRules.kcalUnit}';

  /// ยอดรวมบน CTA Banner เช่น `1,250 kcal` (ui-spec Q-8)
  static String ctaTotalText(int total) =>
      '${StepsLogic.formatThousands(total)} ${FoodRules.kcalUnit}';

  // ---------------------------------------------------------------------------
  // ผล "AI Parsing" (AC-1, AC-2, EC-1)
  // ---------------------------------------------------------------------------

  /// ค่ากึ่งกลาง (Median) ของชุดตัวเลข (AC-2) — ช่วง [a, b] = (a + b) / 2
  // ASSUMPTION: ผลไม่ลงตัวปัดเป็นจำนวนเต็มที่ใกล้สุด (.5 ปัดขึ้น) เพราะ total_calories
  // เป็น Integer (requirements §6) — เอกสารไม่กำหนดวิธีปัด
  static int medianCalories(List<num> values) {
    if (values.isEmpty) throw ArgumentError('values must not be empty');
    final sorted = [...values]..sort();
    final mid = sorted.length ~/ 2;
    final median = sorted.length.isOdd
        ? sorted[mid].toDouble()
        : (sorted[mid - 1] + sorted[mid]) / 2;
    return median.round();
  }

  static final RegExp _rangeText = RegExp(
    r'^\s*(\d+(?:\.\d+)?)\s*[-–~]\s*(\d+(?:\.\d+)?)\s*$',
  );

  /// อ่าน JSON โภชนาการ (AC-1) — `calories` เป็นตัวเลข, ช่วงตัวเลข (`[a, b]`, `"a-b"`,
  /// `{"min": a, "max": b}`) → ใช้ Median (AC-2) · คืน null ถ้าอ่านไม่ได้ (EC-1)
  static FoodNutrition? parseNutritionJson(String raw) {
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (_) {
      return null;
    }
    if (decoded is! Map) return null;
    final calories = _readCalories(decoded['calories']);
    if (calories == null || calories < 0) return null;
    return FoodNutrition(
      calories: calories,
      highSodium: decoded['high_sodium'] == true,
      highSugar: decoded['high_sugar'] == true,
    );
  }

  static int? _readCalories(Object? v) {
    if (v is num) return v.isFinite ? v.round() : null;
    if (v is List) {
      if (v.isEmpty || v.any((e) => e is! num)) return null;
      return medianCalories(v.cast<num>());
    }
    if (v is Map) {
      final min = v['min'];
      final max = v['max'];
      if (min is num && max is num) return medianCalories([min, max]);
      return null;
    }
    if (v is String) {
      final m = _rangeText.firstMatch(v);
      if (m != null) {
        return medianCalories([
          double.parse(m.group(1)!),
          double.parse(m.group(2)!),
        ]);
      }
      final n = num.tryParse(v.trim());
      return n == null || !n.isFinite ? null : n.round();
    }
    return null;
  }

  /// ค่าแคลอรี่จากฟอร์มกรอกเอง (EC-1) — ว่าง → FALLBACK_DEFAULT_CALORIES (300)
  /// คืน null ถ้าไม่ใช่จำนวนเต็มล้วน (UI กรองด้วย digitsOnly อยู่แล้ว)
  static int? manualCalories(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return FoodRules.fallbackDefaultCalories;
    if (!SignupLogic.isWholeNumberText(text)) return null;
    return int.tryParse(text);
  }

  // ---------------------------------------------------------------------------
  // S-3 ฟอร์มโปรไฟล์ (AC-4, EC-5, Q-14 DECIDED: กติกาเดียวกับ signup)
  // ---------------------------------------------------------------------------

  /// AGE_MIN ≤ age ≤ AGE_MAX
  static bool isAgeInRange(int age) =>
      age >= FoodRules.ageMin && age <= FoodRules.ageMax;

  /// อายุต้องเป็นจำนวนเต็มล้วน 1–120 — "25.5", "-3", "abc" = invalid (AC-4, EC-5)
  static FoodFieldStatus ageStatus(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return FoodFieldStatus.empty;
    if (!SignupLogic.isWholeNumberText(text)) return FoodFieldStatus.invalid;
    final v = int.tryParse(text);
    if (v == null || !isAgeInRange(v)) return FoodFieldStatus.invalid;
    return FoodFieldStatus.valid;
  }

  /// น้ำหนัก/ส่วนสูงรับทศนิยม (Q-14)
  // ASSUMPTION: ใช้ช่วงที่ signup รับ (น้ำหนัก 1–300 kg, ส่วนสูง 1–250 cm —
  // SignupLogic.weightStatus/heightStatus) เพราะโปรไฟล์บันทึกผ่าน signup (Q-13);
  // นอกช่วง = บันทึกไม่ได้ (ปุ่ม disabled) โดยไม่มีข้อความ error (ui-spec Q-15)
  static FoodFieldStatus weightStatus(String raw) =>
      _fromSignup(SignupLogic.weightStatus(raw));

  static FoodFieldStatus heightStatus(String raw) =>
      _fromSignup(SignupLogic.heightStatus(raw));

  static FoodFieldStatus _fromSignup(NumberFieldStatus status) =>
      switch (status) {
        NumberFieldStatus.empty => FoodFieldStatus.empty,
        NumberFieldStatus.valid => FoodFieldStatus.valid,
        NumberFieldStatus.outOfRange => FoodFieldStatus.invalid,
      };

  static FoodProfileValidation validateProfile({
    required String age,
    required SignupGender? gender,
    required String weight,
    required String height,
  }) => FoodProfileValidation(
    age: ageStatus(age),
    weight: weightStatus(weight),
    height: heightStatus(height),
    hasGender: gender == SignupGender.male || gender == SignupGender.female,
  );
}
