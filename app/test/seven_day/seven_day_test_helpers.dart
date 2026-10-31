// ตัวช่วยร่วมของเทสต์ 7day (ไม่ใช่ไฟล์เทสต์ — ไม่มี main)
// ค่าคาดหวังทั้งหมดในเทสต์มาจาก docs/7day/requirements.md, game-rules.md, ux-flow.md, ui-spec.md
// และข้อตัดสิน owner (รอบ 1: OQ-01, OQ-02, food 30 วัน, 7 วันรวมวันนี้ 05:00 เวลาเครื่อง, ดึงจาก
// controller เดิม · รอบ 2: Q-19, Q-1, Q-2..Q-20 ตาม ui-spec · รอบ 3: สมมติฐาน dev ข้อ 1–4)
// — ไม่ได้ลอกจากโค้ด · ฟังก์ชัน format ในไฟล์นี้เขียนเองจากเอกสาร ไม่เรียกโค้ด Dev
import 'dart:async';

import 'package:petpal_health/features/food/food_models.dart';
import 'package:petpal_health/features/steps/steps_models.dart';
import 'package:petpal_health/features/water/water_models.dart';

import '../dashboard/dashboard_test_helpers.dart'
    show Sources, makeSources, FakeTimers;

export '../dashboard/dashboard_test_helpers.dart'
    show
        Sources,
        makeSources,
        FakeTimers,
        BrokenWaterRepository,
        BrokenStepsRepository,
        BrokenFoodRepository,
        PendingWaterRepository;

/// วันที่/เวลาที่ควบคุมได้ (ไม่มีเวลาจริง) — ตุลาคม 2026
DateTime t(int day, int h, [int m = 0, int s = 0, int ms = 0]) =>
    DateTime(2026, 10, day, h, m, s, ms);
DateTime d(int day) => DateTime(2026, 10, day);

/// วันอ้างอิงหลักของเทสต์: เสาร์ 31 ต.ค. 2026 (เปิดหน้า 10:00) → Day 0 = 31, Day −6 = 25
const int today = 31;

/// Day −[offset] ของวันอ้างอิง (ต.ค. 2026 — 31 − 6 = 25 ยังอยู่ในเดือน)
DateTime dayOff(int offset, [int base = today]) => d(base - offset);

// ---- ค่าจากเอกสาร (game-rules §1 / ข้อตัดสิน) ----
/// MAX_HISTORY_DAYS (AC-1) · DECIDED รอบ 1 นับรวมวันนี้ Day 0..Day −6
const int docMaxHistoryDays = 7;

/// DATE_NORMALIZER_HOUR (US-3, EC-4) · DECIDED รอบ 1 05:00 เวลาเครื่อง
const int docDateNormalizerHour = 5;

/// WATER_GOAL_THRESHOLD (AC-4)
const double docWaterThreshold = 8.0;

/// STEPS_GOAL_THRESHOLD (AC-5)
const double docStepsThreshold = 8000.0;

/// LOCAL_CACHE_RETENTION_DAYS (EC-5) · DECIDED Q-19 food เท่านั้น
const int docRetentionDays = 30;

/// DECIDED OQ-01 Accordion 250 ms
const Duration docAccordion = Duration(milliseconds: 250);

/// ui-spec §1.3 ตรวจรอบวันทุก 1 วินาที (Q-2..Q-20 ใช้ค่าที่ ui-spec เลือก)
const Duration docDayCheck = Duration(seconds: 1);

/// ui-spec §1.3 ไอคอน EMPTY 48
const double docEmptyIconSize = 48;

/// food AC-5: ชาย 25 ปี BMI ปกติ → 2,000 kcal (profileOf() ค่า default) · Overeating > +100
const int docFoodTarget = 2000;
const int docOverLimitKcal = 100;

// ---- ข้อความ (ตรงตัวจาก ux-flow §2 / game-rules §1.1 — ไม่รวม `"` ตัวคั่น: ui-spec §2) ----
const screenTitle = 'ประวัติสุขภาพ 7 วัน';
const summaryTitle = 'สรุปภาพรวมรอบ 7 วัน';
const entryTooltip = 'ประวัติ 7 วัน'; // ux-flow §3 ข้อ 1 · DECIDED Q-1
const prefixText = 'มีการบันทึกไม่สม่ำเสมอ จากข้อมูลการบันทึกเท่าที่มีพบว่า...';
String lowWaterText(String val) =>
    'ดื่มน้ำเฉลี่ยวันละ $val แก้ว น้อยไปน้า พยายามกินน้ำมากกว่านี้ แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ';
String lowStepsText(String val) =>
    'เดินเฉลี่ยวันละ $val ก้าว ขยับอีกนิดน้าเพื่อสุขภาพที่แข็งแรง แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ';
const emptyText = 'ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้';
const noDataText = 'ไม่มีข้อมูล';
const todayLabel = 'วันนี้';

// ui-spec (owner รอบ 2 ใช้ค่าที่ ui-spec เลือก)
const yesterdayLabel = 'เมื่อวาน'; // Q-11
const thaiWeekday = {
  DateTime.monday: 'วันจันทร์',
  DateTime.tuesday: 'วันอังคาร',
  DateTime.wednesday: 'วันพุธ',
  DateTime.thursday: 'วันพฤหัสบดี',
  DateTime.friday: 'วันศุกร์',
  DateTime.saturday: 'วันเสาร์',
  DateTime.sunday: 'วันอาทิตย์',
}; // Q-11
const tagSodium = 'โซเดียมสูง'; // requirements §6
const tagSugar = 'น้ำตาลสูง';
const tagOver = 'Overeating'; // Q-18

/// ui-spec §2.1.1 b/c/d (Q-8: หมวดไม่มีข้อมูล → `…: ไม่มีข้อมูล`)
String avgWaterLine(String? v) => 'ค่าเฉลี่ยการดื่มน้ำ: ${v == null ? noDataText : '$v แก้ว'}';
String avgStepsLine(String? v) => 'ค่าเฉลี่ยการเดิน: ${v == null ? noDataText : '$v ก้าว'}';
String avgFoodLine(String? v) => 'ค่าเฉลี่ยแคลอรี: ${v == null ? noDataText : '$v kcal'}';

/// ux-flow §2 DAY_CARD (ui-spec §2.1.3)
String dayStepsLine(int n) => 'การเดิน: ${fmt(n)} ก้าว';
String dayWaterLine(int n) => 'การดื่มน้ำ: $n แก้ว';
String dayFoodLine(int n) => 'แคลอรี: ${fmt(n)} kcal';

/// Q-14 แถบสรุปตอนพับ
String collapsedLine(int steps, int cups, int kcal) =>
    '${fmt(steps)} ก้าว · $cups แก้ว · ${fmt(kcal)} kcal';

/// Q-11 `{date_str}` = dd/MM/yyyy
String dateStr(DateTime x) =>
    '${x.day.toString().padLeft(2, '0')}/${x.month.toString().padLeft(2, '0')}/${x.year}';

/// หัวการ์ด Day −[offset] (Day 0 วันนี้ · −1 เมื่อวาน · −2..−6 ชื่อวันไทย)
String titleFor(int offset, DateTime date) {
  final label = offset == 0
      ? todayLabel
      : offset == 1
          ? yesterdayLabel
          : thaiWeekday[date.weekday]!;
  return '$label, ${dateStr(date)}';
}

/// คั่นหลักพัน (จำนวนเต็ม)
String fmt(int n) {
  final s = n.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return n < 0 ? '-$b' : b.toString();
}

/// AC-3 ทศนิยม 1 ตำแหน่ง + Q-12 คั่นหลักพัน — ใส่สตริงที่คาดหวังเองในเทสต์เป็นหลัก

// ---- ข้อมูลตั้งต้น ----

/// ข้อมูลรายวัน 1 วัน (null/0 = ไม่มีบันทึกหมวดนั้น)
class DayData {
  const DayData({
    this.cups = 0,
    this.steps = 0,
    this.kcal = 0,
    this.sodium = false,
    this.sugar = false,
    this.over = false,
    this.stepsRecordZero = false,
  });
  final int cups;
  final int steps;
  final int kcal;
  final bool sodium;
  final bool sugar;

  /// isOverTarget ของวันก่อน (Q-20) — Day 0 ใช้ kcal > target + 100 แทน
  final bool over;

  /// ใส่ steps record 0 ก้าวไว้ (rollover วันที่เปิดแอปแต่ไม่เดิน — ui-spec §2.2)
  final bool stepsRecordZero;
}

/// สร้าง state ของ 3 ฟีเจอร์จาก map offset → ข้อมูล (Day 0 = วัน [base])
/// - water: history record เฉพาะวันที่ cups > 0 (รวมวันนี้ — upsert ตอนบันทึก) · cups วันนี้
/// - steps: วันนี้ `state.steps` + `state.day`, วันก่อนใน history
/// - food: วันนี้ meals + totalCalories, วันก่อนเป็น DailyFoodRecord
({WaterState water, StepsState steps, FoodState food}) statesFor(
  Map<int, DayData> data, {
  int base = today,
  int nowHour = 10,
  List<DailyWaterRecord> extraWater = const [],
  List<DailyStepsRecord> extraSteps = const [],
  List<DailyFoodRecord> extraFood = const [],
}) {
  final day0 = d(base);
  final seen = DateTime(day0.year, day0.month, day0.day, nowHour < 5 ? 4 : nowHour - 1);
  final t0 = data[0] ?? const DayData();
  final waterHistory = <DailyWaterRecord>[
    ...extraWater,
    for (final e in data.entries)
      if (e.value.cups > 0) DailyWaterRecord(date: d(base - e.key), cups: e.value.cups),
  ]..sort((a, b) => a.date.compareTo(b.date));
  final stepsHistory = <DailyStepsRecord>[
    ...extraSteps,
    for (final e in data.entries)
      if (e.key > 0 && (e.value.steps != 0 || e.value.stepsRecordZero))
        DailyStepsRecord(date: d(base - e.key), steps: e.value.steps, goal: 8000),
  ]..sort((a, b) => a.date.compareTo(b.date));
  final foodHistory = <DailyFoodRecord>[
    ...extraFood,
    for (final e in data.entries)
      if (e.key > 0 && (e.value.kcal != 0 || e.value.sodium || e.value.sugar || e.value.over))
        DailyFoodRecord(
          date: d(base - e.key),
          totalCalories: e.value.kcal,
          targetCalories: docFoodTarget,
          isOverTarget: e.value.over,
          highSodium: e.value.sodium,
          highSugar: e.value.sugar,
        ),
  ]..sort((a, b) => a.date.compareTo(b.date));
  final meals = <FoodMealEntry>[
    if (t0.kcal != 0 || t0.sodium || t0.sugar)
      FoodMealEntry(
        date: day0,
        loggedAt: seen,
        calories: t0.kcal,
        highSodium: t0.sodium,
        highSugar: t0.sugar,
      ),
  ];
  return (
    water: WaterState(
      cups: t0.cups,
      lastLoggedAt: t0.cups > 0 ? seen : null,
      history: waterHistory,
    ),
    steps: StepsState.initial.copyWith(
      steps: t0.steps,
      day: day0,
      lastSeenAt: seen,
      history: stepsHistory,
    ),
    food: FoodState(
      day: day0,
      totalCalories: t0.kcal,
      meals: meals,
      history: foodHistory,
      lastSeenAt: seen,
    ),
  );
}

/// ชุด controller (InMemory + clock ร่วม) จากข้อมูลรายวัน
Sources sourcesFor(
  Map<int, DayData> data, {
  required DateTime Function() clock,
  int base = today,
  int nowHour = 10,
  FakeTimers? foodTimers,
}) {
  final s = statesFor(data, base: base, nowHour: nowHour);
  return makeSources(
    clock: clock,
    water: s.water,
    steps: s.steps,
    food: s.food,
    foodTimers: foodTimers,
  );
}

/// ทั้ง 7 วันมีบันทึก (count = 7) ค่าเดียวกันทุกวัน
Map<int, DayData> allDays(DayData x) => {for (var i = 0; i < 7; i++) i: x};

/// Timer.periodic ปลอม (SevenDayPeriodicTimerFactory) — tick เฉพาะเมื่อเรียก [advance]
class FakePeriodicTimers {
  Duration elapsed = Duration.zero;
  final List<FakePeriodicTimer> timers = [];

  Timer create(Duration interval, void Function() onTick) {
    final x = FakePeriodicTimer._(interval, elapsed + interval, onTick);
    timers.add(x);
    return x;
  }

  void advance(Duration duration) {
    final target = elapsed + duration;
    while (true) {
      final due = timers.where((x) => x.isActive && x._next <= target).toList()
        ..sort((a, b) => a._next.compareTo(b._next));
      if (due.isEmpty) break;
      final x = due.first;
      elapsed = x._next;
      x._next += x.interval;
      x._ticks++;
      x._onTick();
    }
    elapsed = target;
  }

  int get activeCount => timers.where((x) => x.isActive).length;
}

class FakePeriodicTimer implements Timer {
  FakePeriodicTimer._(this.interval, this._next, this._onTick);
  final Duration interval;
  Duration _next;
  final void Function() _onTick;
  bool _active = true;
  int _ticks = 0;

  @override
  void cancel() => _active = false;
  @override
  bool get isActive => _active;
  @override
  int get tick => _ticks;
}
