/// ตารางเมนูอาหารไทยที่ใช้บ่อย (ข้อมูลในเครื่อง) + ตัวจับคู่ชื่อเมนู — pure Dart
///
/// Q-17 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน): MVP ไม่มี AI และไม่ต่อเน็ต ใช้ตารางนี้
/// เทียบชื่อเมนู → kcal แทน AI Parsing ถ้าไม่เจอเมนูในตาราง = AI Parsing Failure (EC-1)
/// → S-2 แสดงช่องกรอกแคลอรี่เอง
///
// ASSUMPTION: ค่าชั่วคราว รอคำตอบ — ค่า kcal / ธงโซเดียม-น้ำตาลในตารางเป็นค่าประมาณ
// ต่อ 1 จาน/ชาม/แก้ว/ชิ้น จากตารางแคลอรี่อาหารไทยทั่วไป ไม่ได้มาจาก game-rules.md
// (เอกสารไม่มีตารางเมนู) ให้ Product/โภชนากรยืนยันหรือแทนที่ทั้งตาราง
// บางเมนูเก็บเป็น "ช่วง" (minKcal–maxKcal) เพื่อให้ผลเป็นช่วงตัวเลขแบบที่ AC-2 กล่าวถึง
// (ระบบจะใช้ค่ากึ่งกลาง — FoodLogic.medianCalories)
library;

import 'food_rules.dart';

/// เมนู 1 รายการในตาราง
class FoodMenuItem {
  const FoodMenuItem(
    this.names,
    this.minKcal, [
    int? maxKcal,
    this.highSodium = false,
    this.highSugar = false,
  ]) : maxKcal = maxKcal ?? minKcal;

  /// ชื่อเรียก (ชื่อแรก = ชื่อหลัก) — จับคู่แบบ "มีข้อความนี้อยู่ในประโยค"
  final List<String> names;
  final int minKcal;
  final int maxKcal;
  final bool highSodium;
  final bool highSugar;

  bool get isRange => maxKcal != minKcal;
  String get name => names.first;
}

/// เมนูที่จับคู่ได้ 1 ครั้งในข้อความ
class FoodMenuMatch {
  const FoodMenuMatch({
    required this.item,
    required this.alias,
    required this.start,
    required this.quantity,
  });

  final FoodMenuItem item;

  /// ชื่อที่พบจริงในข้อความ
  final String alias;

  /// ตำแหน่งในข้อความที่ normalize แล้ว
  final int start;
  final int quantity;

  int get minKcal => item.minKcal * quantity;
  int get maxKcal => item.maxKcal * quantity;
}

const bool _s = true; // high_sodium = true
const bool _n =
    false; // high_sodium = false (ใช้เมื่อต้องระบุ high_sugar ต่อท้าย)

/// ตารางเมนู — (ชื่อเรียก, kcal ต่ำสุด, kcal สูงสุด, โซเดียมสูง, น้ำตาลสูง)
const List<FoodMenuItem> kFoodMenuTable = [
  // จานเดียว
  FoodMenuItem(['ข้าวมันไก่ทอด'], 690, null, _s),
  FoodMenuItem(['ข้าวมันไก่'], 596, null, _s),
  FoodMenuItem(['ข้าวขาหมู'], 690, null, _s),
  FoodMenuItem(['ข้าวหมูแดง'], 540, null, _s, true),
  FoodMenuItem(['ข้าวหมูกรอบ'], 650, null, _s),
  FoodMenuItem(
    ['ข้าวผัดกะเพรา', 'ข้าวกะเพรา', 'กะเพรา', 'กระเพรา'],
    550,
    650,
    _s,
  ),
  FoodMenuItem(['ข้าวผัด'], 550, 650, _s),
  FoodMenuItem(['ข้าวไข่เจียว'], 450, 550),
  FoodMenuItem(['ข้าวไข่ดาว'], 380),
  FoodMenuItem(['ผัดไทย'], 450, 550, _s, true),
  FoodMenuItem(['ผัดซีอิ๊ว'], 600, 700, _s),
  FoodMenuItem(['ราดหน้า'], 400, 450, _s),
  FoodMenuItem(['สุกี้'], 300, 400, _s),
  FoodMenuItem(['ก๋วยเตี๋ยวต้มยำ'], 350, 450, _s),
  FoodMenuItem(['ก๋วยเตี๋ยวเรือ'], 200, 300, _s),
  FoodMenuItem(['ก๋วยเตี๋ยว'], 300, 400, _s),
  FoodMenuItem(['บะหมี่กึ่งสำเร็จรูป', 'มาม่า'], 300, null, _s),
  FoodMenuItem(['ขนมจีนน้ำยา', 'ขนมจีน'], 350, 450, _s),
  FoodMenuItem(['โจ๊ก'], 160, 250, _s),
  FoodMenuItem(['ข้าวต้ม'], 220, 300, _s),
  FoodMenuItem(['ข้าวมันส้มตำ'], 450, 550, _s, true),
  // กับข้าว / อีสาน
  FoodMenuItem(['ส้มตำ'], 60, 120, _s, true),
  FoodMenuItem(['ไก่ย่าง'], 160, 250, _s),
  FoodMenuItem(['คอหมูย่าง'], 300, 400, _s),
  FoodMenuItem(['หมูปิ้ง'], 100, 150, _n, true),
  FoodMenuItem(['ลาบ'], 200, 250, _s),
  FoodMenuItem(['น้ำตก'], 220, 250, _s),
  FoodMenuItem(['ต้มยำ'], 100, 250, _s),
  FoodMenuItem(['แกงเขียวหวาน'], 240, 300, _s),
  FoodMenuItem(['ไข่เจียว'], 250),
  FoodMenuItem(['ไข่ดาว'], 120),
  FoodMenuItem(['ไข่ต้ม'], 75),
  FoodMenuItem(['หมูกระทะ'], 800, 1200, _s),
  // ข้าวเปล่า
  FoodMenuItem(['ข้าวเหนียว'], 300, 350),
  FoodMenuItem(['ข้าวสวย', 'ข้าวเปล่า'], 240),
  // เครื่องดื่ม / ของว่าง
  FoodMenuItem(['ชานมไข่มุก'], 300, 450, _n, true),
  FoodMenuItem(['ชาเย็น', 'ชาไทย'], 250, 300, _n, true),
  FoodMenuItem(['กาแฟเย็น'], 200, 250, _n, true),
  FoodMenuItem(['น้ำอัดลม'], 140, 160, _n, true),
  FoodMenuItem(['โรตี'], 300, 400, _n, true),
  FoodMenuItem(['กล้วยทอด'], 200, 250, _n, true),
  FoodMenuItem(['ปาท่องโก๋'], 150, 200),
];

/// จับคู่ข้อความเมนูกับตาราง
///
/// วิธีจับคู่ (Q-17):
/// 1. normalize: ตัดช่องว่างหัวท้าย, เปลี่ยนตัวพิมพ์ใหญ่เป็นเล็ก, ยุบช่องว่างหลายช่องเป็นช่องเดียว
/// 2. ไล่ชื่อเรียกทุกชื่อจาก "ยาวที่สุด" ไป "สั้นที่สุด" หาทุกตำแหน่งที่พบในข้อความ
///    ตำแหน่งที่จับคู่แล้วถูกกันไว้ ชื่อที่สั้นกว่าจับซ้ำทับไม่ได้
///    (เช่น "ข้าวมันไก่ทอด" ไม่ถูกนับเป็น "ข้าวมันไก่" อีกรอบ, "ไข่เจียว" ใน "ข้าวไข่เจียว" ไม่ถูกนับซ้ำ)
/// 3. ถ้ามีตัวเลขตามหลังชื่อเมนู (ช่องว่างคั่นได้) เช่น "ข้าวมันไก่ 2 จาน" → คูณจำนวน
///    ไม่มีตัวเลข / เลข 0 → 1 ที่
/// 4. คืนรายการเรียงตามตำแหน่งในข้อความ — ว่าง = ไม่เจอเมนู
class FoodMenuMatcher {
  FoodMenuMatcher._();

  static String normalize(String text) =>
      text.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  static final RegExp _quantity = RegExp(
    '^ ?([0-9]{1,${FoodRules.menuQuantityMaxDigits}})(?![0-9])',
  );

  static List<FoodMenuMatch> match(
    String text, {
    List<FoodMenuItem> menu = kFoodMenuTable,
  }) {
    final normalized = normalize(text);
    if (normalized.isEmpty) return const [];
    final aliases = <({String alias, FoodMenuItem item})>[
      for (final item in menu)
        for (final name in item.names)
          if (normalize(name).isNotEmpty) (alias: normalize(name), item: item),
    ]..sort((a, b) => b.alias.length.compareTo(a.alias.length));

    final taken = List<bool>.filled(normalized.length, false);
    final matches = <FoodMenuMatch>[];
    for (final a in aliases) {
      var from = 0;
      while (true) {
        final i = normalized.indexOf(a.alias, from);
        if (i < 0) break;
        final end = i + a.alias.length;
        from = i + 1;
        var free = true;
        for (var k = i; k < end; k++) {
          if (taken[k]) {
            free = false;
            break;
          }
        }
        if (!free) continue;
        for (var k = i; k < end; k++) {
          taken[k] = true;
        }
        final q = _quantity.firstMatch(normalized.substring(end));
        final qty = q == null ? 1 : int.parse(q.group(1)!);
        matches.add(
          FoodMenuMatch(
            item: a.item,
            alias: a.alias,
            start: i,
            quantity: qty < 1 ? 1 : qty,
          ),
        );
        from = end;
      }
    }
    matches.sort((x, y) => x.start.compareTo(y.start));
    return List.unmodifiable(matches);
  }
}
