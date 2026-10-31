/// โมเดลข้อมูลของฟีเจอร์ food (pure Dart)
library;

/// สถานะ/ท่าของสัตว์เลี้ยง 4 ท่า (game-rules §2)
enum FoodPetState {
  /// ท่าหิว / ปกติ — `total <= target + OVER_LIMIT_THRESHOLD` (หรือไม่มีเป้าหมาย)
  normal('NORMAL', 'normal'),

  /// ท่ากำลังกิน — ชั่วคราว EATING_ANIMATION_DURATION หลังบันทึกสำเร็จ
  eating('EATING', 'eating'),

  /// ท่าอิ่มพุงกาง — `total > target + OVER_LIMIT_THRESHOLD`
  overLimit('OVER_LIMIT', 'over_limit'),

  /// ท่าอิ่มพุงกางแต่ยังกิน — ชั่วคราว เมื่อบันทึกซ้ำขณะเกินเป้า
  overLimitFeeding('OVER_LIMIT_FEEDING', 'over_limit_feeding');

  const FoodPetState(this.code, this.keyName);

  /// รหัสใน game-rules §2
  final String code;

  /// ส่วนท้ายของ key `food_pet_image_<keyName>` (ui-spec §4)
  final String keyName;

  bool get isTransient =>
      this == FoodPetState.eating || this == FoodPetState.overLimitFeeding;
}

/// ผลโภชนาการของ 1 มื้อ (AC-1: `{"calories": 400, "high_sodium": true, "high_sugar": false}`)
class FoodNutrition {
  const FoodNutrition({
    required this.calories,
    this.highSodium = false,
    this.highSugar = false,
  });

  final int calories;
  final bool highSodium;
  final bool highSugar;

  Map<String, dynamic> toJson() => {
    'calories': calories,
    'high_sodium': highSodium,
    'high_sugar': highSugar,
  };

  @override
  bool operator ==(Object other) =>
      other is FoodNutrition &&
      other.calories == calories &&
      other.highSodium == highSodium &&
      other.highSugar == highSugar;

  @override
  int get hashCode => Object.hash(calories, highSodium, highSugar);

  @override
  String toString() => 'FoodNutrition(${toJson()})';
}

/// วันที่รูปแบบ YYYY-MM-DD (requirements §6 `date`)
String formatFoodDateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

DateTime? parseFoodDateKey(Object? raw) {
  if (raw is! String) return null;
  final d = DateTime.tryParse(raw);
  return d == null ? null : DateTime(d.year, d.month, d.day);
}

/// Log การบันทึก 1 มื้อของรอบวันปัจจุบัน (AC-3: `date` = รอบวันตามตัดรอบ 05:00)
class FoodMealEntry {
  const FoodMealEntry({
    required this.date,
    required this.loggedAt,
    required this.calories,
    this.highSodium = false,
    this.highSugar = false,
    this.manual = false,
  });

  /// รอบวัน (ตัดรอบ 05:00) — ไม่ใช่วันที่ตามปฏิทินของ [loggedAt]
  final DateTime date;
  final DateTime loggedAt;
  final int calories;
  final bool highSodium;
  final bool highSugar;

  /// true = มาจากฟอร์มกรอกเอง (EC-1)
  final bool manual;

  Map<String, dynamic> toJson() => {
    'date': formatFoodDateKey(date),
    'logged_at': loggedAt.toIso8601String(),
    'calories': calories,
    'high_sodium': highSodium,
    'high_sugar': highSugar,
    'manual': manual,
  };

  factory FoodMealEntry.fromJson(Map<String, dynamic> json) {
    final date = parseFoodDateKey(json['date']);
    final loggedAt = DateTime.tryParse(json['logged_at'] as String? ?? '');
    final calories = json['calories'];
    if (date == null || loggedAt == null || calories is! int || calories < 0) {
      throw const FormatException('invalid FoodMealEntry');
    }
    return FoodMealEntry(
      date: date,
      loggedAt: loggedAt,
      calories: calories,
      highSodium: json['high_sodium'] == true,
      highSugar: json['high_sugar'] == true,
      manual: json['manual'] == true,
    );
  }
}

/// ประวัติรายวัน (requirements §6 Food History Schema)
// ASSUMPTION: ไม่เก็บ `user_id` — ข้อมูลอยู่ในเครื่องเดียวสำหรับผู้ใช้คนเดียว (แบบ water/steps)
class DailyFoodRecord {
  const DailyFoodRecord({
    required this.date,
    required this.totalCalories,
    required this.targetCalories,
    required this.isOverTarget,
    this.highSodium = false,
    this.highSugar = false,
  });

  final DateTime date;
  final int totalCalories;

  /// null = ไม่มีเป้าหมาย (ข้ามโปรไฟล์ / โปรไฟล์ไม่ครบ)
  final int? targetCalories;

  /// `total > target + OVER_LIMIT_THRESHOLD` (false เมื่อไม่มีเป้าหมาย)
  final bool isOverTarget;
  final bool highSodium;
  final bool highSugar;

  Map<String, dynamic> toJson() => {
    'date': formatFoodDateKey(date),
    'total_calories': totalCalories,
    'target_calories': targetCalories,
    'is_over_target': isOverTarget,
    'high_sodium': highSodium,
    'high_sugar': highSugar,
  };

  factory DailyFoodRecord.fromJson(Map<String, dynamic> json) {
    final date = parseFoodDateKey(json['date']);
    final total = json['total_calories'];
    final target = json['target_calories'];
    if (date == null || total is! int || total < 0) {
      throw const FormatException('invalid DailyFoodRecord');
    }
    return DailyFoodRecord(
      date: date,
      totalCalories: total,
      targetCalories: target is int ? target : null,
      isOverTarget: json['is_over_target'] == true,
      highSodium: json['high_sodium'] == true,
      highSugar: json['high_sugar'] == true,
    );
  }
}

/// สถานะทั้งหมดของ food ที่เก็บลงเครื่อง
class FoodState {
  const FoodState({
    this.day,
    this.totalCalories = 0,
    this.meals = const [],
    this.history = const [],
    this.lastSeenAt,
    this.profileSkipped = false,
  });

  static const FoodState initial = FoodState();

  /// รอบวันปัจจุบัน (null = ยังไม่เคยเปิด)
  final DateTime? day;

  /// `total_calories` ของรอบวันปัจจุบัน
  final int totalCalories;

  /// Log มื้อของรอบวันปัจจุบัน
  final List<FoodMealEntry> meals;

  /// ประวัติรอบวันก่อนหน้า (เก่า → ใหม่) ไม่เกิน HISTORY_RETENTION_DAYS (รวมวันนี้)
  final List<DailyFoodRecord> history;

  /// เวลาล่าสุดที่ระบบเห็น (กันนาฬิกาย้อน)
  final DateTime? lastSeenAt;

  /// ผู้ใช้กด「ข้ามไปก่อน」ใน S-3 (US-3)
  final bool profileSkipped;

  bool get todayHighSodium => meals.any((m) => m.highSodium);
  bool get todayHighSugar => meals.any((m) => m.highSugar);

  FoodState copyWith({
    DateTime? day,
    int? totalCalories,
    List<FoodMealEntry>? meals,
    List<DailyFoodRecord>? history,
    DateTime? lastSeenAt,
    bool? profileSkipped,
  }) => FoodState(
    day: day ?? this.day,
    totalCalories: totalCalories ?? this.totalCalories,
    meals: meals ?? this.meals,
    history: history ?? this.history,
    lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    profileSkipped: profileSkipped ?? this.profileSkipped,
  );
}

/// ผลตรวจช่องตัวเลขของ S-3
enum FoodFieldStatus { empty, valid, invalid }

/// ผลตรวจฟอร์ม S-3 ทั้งหน้า
class FoodProfileValidation {
  const FoodProfileValidation({
    required this.age,
    required this.weight,
    required this.height,
    required this.hasGender,
  });

  final FoodFieldStatus age;
  final FoodFieldStatus weight;
  final FoodFieldStatus height;
  final bool hasGender;

  /// AC-4, EC-5 — ช่องว่างไม่แสดง error
  bool get showAgeError => age == FoodFieldStatus.invalid;

  /// ui-spec §3 S-3: ต้องครบทั้ง 4 ค่าและถูกต้อง (Q-15)
  bool get canSave =>
      age == FoodFieldStatus.valid &&
      weight == FoodFieldStatus.valid &&
      height == FoodFieldStatus.valid &&
      hasGender;
}
