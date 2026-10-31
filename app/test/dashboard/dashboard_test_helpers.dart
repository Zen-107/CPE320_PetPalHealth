// ตัวช่วยร่วมของเทสต์ dashboard (ไม่ใช่ไฟล์เทสต์ — ไม่มี main)
// ค่าคาดหวังทั้งหมดในเทสต์มาจาก docs/dashboard/requirements.md, game-rules.md, ux-flow.md,
// ui-spec.md และข้อตัดสิน owner (D-1..D-4, Q-1, Q-14, Q-3/16/19/20/21/8 ตาม ui-spec,
// Q-4/5/17, Q-7, Q-2, Q-11 — DECIDED ชั่วคราว) — ไม่ได้ลอกจากโค้ด
import 'dart:async';

import 'package:petpal_health/features/food/food_controller.dart';
import 'package:petpal_health/features/food/food_models.dart';
import 'package:petpal_health/features/food/food_profile_source.dart';
import 'package:petpal_health/features/food/food_repository.dart';
import 'package:petpal_health/features/steps/steps_controller.dart';
import 'package:petpal_health/features/steps/steps_models.dart';
import 'package:petpal_health/features/steps/steps_repository.dart';
import 'package:petpal_health/features/water/water_controller.dart';
import 'package:petpal_health/features/water/water_models.dart';
import 'package:petpal_health/features/water/water_repository.dart';
import 'package:petpal_health/features/signup/signup_models.dart';

import '../food/food_test_helpers.dart' show FakeTimers, profileOf;

export '../food/food_test_helpers.dart' show FakeTimers, FakeTimer, profileOf;

/// วันที่/เวลาที่ควบคุมได้ (ไม่มีเวลาจริง) — ตุลาคม 2026
DateTime t(int day, int h, [int m = 0, int s = 0, int ms = 0]) =>
    DateTime(2026, 10, day, h, m, s, ms);
DateTime d(int day) => DateTime(2026, 10, day);

// ---- ค่าจากเอกสาร ----
/// game-rules §1 alertInterval = 5 วินาที
const int docAlertIntervalSeconds = 5;

/// game-rules §1 resetHour = 05:00 (D-2 เวลาเครื่อง)
const int docResetHour = 5;

/// game-rules §2 ขอบบนของช่วงอารมณ์ (รวมขอบ)
const int docCryingMax = 30;
const int docDazedMax = 60;
const int docBubblyMax = 80;

/// D-4 Priority 4 "คะแนนอาหารต่ำกว่าเกณฑ์" = foodScore < 50
const int docHungryBelow = 50;

/// Q-14: เป้าน้ำ = 8 แก้ว (water_rules: 100% / 12.5% ต่อแก้ว)
const int docWaterTargetCups = 8;

/// steps game-rules: เป้าเริ่มต้น 8,000 ก้าว
const int docStepsDefaultGoal = 8000;

/// food AC-5: ชาย 25 ปี BMI ปกติ → 2,000 kcal (profileOf() ค่า default)
const int docFoodTarget = 2000;

/// game-rules §1.1 Priority 1: Overeating > 100 kcal (food game-rules OVER_LIMIT_THRESHOLD)
const int docOverLimitKcal = 100;

/// ui-spec §1.3
const double docPetSize = 200;
const double docAlertAnchor = 12;

// ---- ข้อความ (ตรงตัวจาก game-rules §1.1 / ux-flow §2 — ไม่รวม `"` ตัวคั่น: Q-21) ----
const p1Text = 'แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว';
const p2Text = 'ดื่มน้ำๆ';
const p3Text = 'ขยับร่างกายหน่อย อีกนิดๆ';
const p4Text = 'ฉันหิว';

/// ux-flow §2 รูปแบบ `คะแนนสุขภาพรวม: [Integer]%` ฯลฯ
String totalText(int n) => 'คะแนนสุขภาพรวม: $n%';
String foodText(int n) => 'คะแนนอาหาร: $n%';
String stepsText(int n) => 'คะแนนการก้าวเดิน: $n%';
String waterText(int n) => 'คะแนนการดื่มน้ำ: $n%';

/// Q-1 (ui-spec เสนอ — owner ใช้ตาม ui-spec)
const foodNoTargetText = 'คะแนนอาหาร: ยังไม่มีเป้าหมาย';

/// food ux-flow §2 ข้อความ CTA (R3 ข้อ 5 ใช้ CTA เดิมของ food)
const foodCtaText = 'ตั้งค่าโปรไฟล์สุขภาพเพื่อรับเป้าหมายแคลอรี่ที่แม่นยำ';

/// Q-8 (ui-spec เสนอ — owner ใช้ตาม ui-spec)
const screenTitleText = 'แดชบอร์ด';

// ---- สถานะเริ่มต้นของ 3 controller (รอบวัน 14 ต.ค. — เปิดตอน 10:00) ----

WaterState water14(int cups) =>
    WaterState(cups: cups, lastLoggedAt: t(14, 9), history: const []);

StepsState steps14(int steps, {int goal = docStepsDefaultGoal}) =>
    StepsState.initial.copyWith(
        steps: steps, day: d(14), activeGoal: goal, lastSeenAt: t(14, 9));

/// ข้อมูลอาหารที่สอดคล้องกัน: kcal > 0 = มี 1 มื้อ, 0 = ยังไม่บันทึกมื้อใด
FoodState food14(int kcal, {bool skipped = false}) => FoodState(
      day: d(14),
      totalCalories: kcal,
      meals: kcal == 0
          ? const []
          : [FoodMealEntry(date: d(14), loggedAt: t(14, 9), calories: kcal)],
      lastSeenAt: t(14, 9),
      profileSkipped: skipped,
    );

/// คะแนนอาหาร n% เมื่อเป้า 2,000 kcal (ถึงเป้า: kcal / target × 100) → kcal = n × 20
int kcalForFoodScore(int n) => n * docFoodTarget ~/ 100;

/// ก้าวสำหรับคะแนน n% ของเป้า 8,000 → n × 80
int stepsForScore(int n) => n * docStepsDefaultGoal ~/ 100;

/// ชุด controller 3 ตัวที่ใช้นาฬิกาเดียวกัน (D-2: dashboard ไม่มี clock เอง)
class Sources {
  Sources({
    required this.water,
    required this.steps,
    required this.food,
    required this.profileSource,
  });

  final WaterController water;
  final StepsController steps;
  final FoodController food;
  final InMemoryFoodProfileSource profileSource;

  Future<void> loadAll() async {
    await water.load();
    await steps.load();
    await food.load();
  }
}

Sources makeSources({
  required DateTime Function() clock,
  WaterState? water,
  StepsState? steps,
  FoodState? food,
  UserProfile? profile,
  bool noProfile = false,
  FakeTimers? foodTimers,
  WaterRepository? waterRepo,
  StepsRepository? stepsRepo,
  FoodRepository? foodRepo,
}) {
  final source = InMemoryFoodProfileSource(
      profile: noProfile ? null : (profile ?? profileOf()));
  return Sources(
    water: WaterController(
      repository: waterRepo ?? InMemoryWaterRepository(water ?? WaterState.initial),
      clock: clock,
    ),
    steps: StepsController(
      repository: stepsRepo ?? InMemoryStepsRepository(steps ?? StepsState.initial),
      clock: clock,
    ),
    food: FoodController(
      repository: foodRepo ?? InMemoryFoodRepository(food ?? FoodState.initial),
      profileSource: source,
      clock: clock,
      timerFactory: foodTimers?.create,
    ),
    profileSource: source,
  );
}

// ---- repository ที่ข้อมูลเสีย / โหลดค้าง (EC-4 ข้อมูลเสีย/หาย, สถานะกำลังโหลด) ----

class BrokenWaterRepository implements WaterRepository {
  @override
  Future<WaterState> load() async => throw const FormatException('corrupt');
  @override
  Future<void> save(WaterState state) async {}
}

class BrokenStepsRepository implements StepsRepository {
  @override
  Future<StepsState> load() async => throw const FormatException('corrupt');
  @override
  Future<void> save(StepsState state) async {}
}

class BrokenFoodRepository implements FoodRepository {
  @override
  Future<FoodState> load() async => throw const FormatException('corrupt');
  @override
  Future<void> save(FoodState state) async {}
}

/// โหลดค้างจนกว่าจะเรียก [complete]
class PendingWaterRepository implements WaterRepository {
  final Completer<WaterState> _c = Completer();
  void complete([WaterState s = WaterState.initial]) => _c.complete(s);
  @override
  Future<WaterState> load() => _c.future;
  @override
  Future<void> save(WaterState state) async {}
}
