/// "AI Parsing" ของเมนูอาหาร (AC-1, AC-2, EC-1)
///
/// Q-17 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน): ไม่มี AI / ไม่ต่อเน็ต — ตัวที่ใช้จริงคือ
/// [LocalMenuNutritionParser] เทียบชื่อเมนูกับตารางในเครื่อง (food_menu_table.dart)
/// แยก [FoodNutritionParser] เป็น interface ไว้ต่อ AI จริงภายหลัง และให้ QA สลับตัวปลอมได้
library;

import 'dart:convert';

import 'food_menu_table.dart';

/// ประมวลผลข้อความเมนู → JSON โภชนาการ (AC-1)
///
/// คืนสตริง JSON เช่น `{"calories": 400, "high_sodium": true, "high_sugar": false}`
/// `calories` อาจเป็นช่วง `[min, max]` (AC-2 — FoodLogic เลือก Median)
/// throw [FoodParseException] เมื่อประมวลผลไม่ได้ / ออฟไลน์ (EC-1)
/// ผู้เรียก (FoodController) จำกัดเวลาด้วย AI_PARSING_TIMEOUT
abstract class FoodNutritionParser {
  Future<String> parse(String text);
}

/// ประมวลผลไม่สำเร็จ / ออฟไลน์ (EC-1)
class FoodParseException implements Exception {
  const FoodParseException(this.message);
  final String message;
  @override
  String toString() => 'FoodParseException: $message';
}

/// ตัวประมวลผลในเครื่องจากตารางเมนู (ไม่มี network)
///
/// สำหรับ QA:
/// - [offline] = true → throw [FoodParseException] ทุกครั้ง (จำลองเน็ตหลุด EC-1)
/// - [latency] — หน่วงก่อนตอบ (เกิน AI_PARSING_TIMEOUT 3 วินาที = failure ตาม AC-1)
/// - [menu] — ใช้ตารางอื่นแทน [kFoodMenuTable]
/// flag แก้ระหว่างเทสต์ได้
class LocalMenuNutritionParser implements FoodNutritionParser {
  LocalMenuNutritionParser({
    this.offline = false,
    this.latency = Duration.zero,
    this.menu = kFoodMenuTable,
  });

  bool offline;
  Duration latency;
  List<FoodMenuItem> menu;

  /// จำนวนครั้งที่ถูกเรียก (ตรวจได้ในเทสต์)
  int callCount = 0;

  @override
  Future<String> parse(String text) async {
    callCount++;
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    if (offline) throw const FoodParseException('offline');
    return jsonEncode(nutritionJsonFor(text, menu: menu));
  }

  /// ผลแบบ synchronous (pure) — throw [FoodParseException] ถ้าไม่เจอเมนูในตาราง
  static Map<String, dynamic> nutritionJsonFor(
    String text, {
    List<FoodMenuItem> menu = kFoodMenuTable,
  }) {
    final matches = FoodMenuMatcher.match(text, menu: menu);
    if (matches.isEmpty) throw const FoodParseException('menu not found');
    var min = 0;
    var max = 0;
    for (final m in matches) {
      min += m.minKcal;
      max += m.maxKcal;
    }
    return {
      // ผลรวมเป็นช่วงเมื่อมีเมนูใดเป็นช่วง → FoodLogic ใช้ Median (AC-2)
      'calories': min == max ? min : [min, max],
      'high_sodium': matches.any((m) => m.item.highSodium),
      'high_sugar': matches.any((m) => m.item.highSugar),
    };
  }
}
