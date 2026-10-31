/// ตัวกลางระหว่าง logic ของ 7day กับ UI
///
/// ไม่มี repository / ไม่เก็บข้อมูลเอง — อ่านค่าจาก WaterController / StepsController /
/// FoodController ตัวเดียวกับที่หน้า water ใช้ (DECIDED owner D-5) แล้วคำนวณ snapshot สดทุกครั้ง
/// controller นี้ถือแค่ Timer ตรวจรอบวัน (EC-4) — แบบ DashboardController
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../food/food_controller.dart';
import '../steps/steps_controller.dart';
import '../water/water_controller.dart';
import 'seven_day_logic.dart';
import 'seven_day_models.dart';
import 'seven_day_rules.dart';

typedef SevenDayClock = DateTime Function();

/// สร้าง Timer แบบเป็นระยะ — inject ตัวปลอมในเทสต์ที่ไม่ใช่ widget test เพื่อสั่ง tick เองได้
/// (แบบ FoodTimerFactory / DashboardTimerFactory)
typedef SevenDayPeriodicTimerFactory = Timer Function(
  Duration interval,
  void Function() onTick,
);

Timer _defaultPeriodic(Duration d, void Function() cb) =>
    Timer.periodic(d, (_) => cb());

class SevenDayController extends ChangeNotifier {
  SevenDayController({
    required this.water,
    required this.steps,
    required this.food,
    SevenDayClock? clock,
    SevenDayPeriodicTimerFactory? timerFactory,
  })  : _clock = clock ?? DateTime.now,
        _timerFactory = timerFactory ?? _defaultPeriodic {
    for (final c in _sources) {
      c.addListener(_onSourceChanged);
    }
  }

  final WaterController water;
  final StepsController steps;
  final FoodController food;

  /// ใช้เฉพาะตอนที่ steps / food ยังไม่มี `state.day` (ดู SevenDayLogic.currentDay)
  final SevenDayClock _clock;
  final SevenDayPeriodicTimerFactory _timerFactory;

  Timer? _dayTimer;
  bool _disposed = false;

  List<ChangeNotifier> get _sources => [water, steps, food];

  // ---------------------------------------------------------------------------
  // ค่าสำหรับ UI
  // ---------------------------------------------------------------------------

  /// ทั้ง 3 controller โหลดจากเครื่องเสร็จแล้ว (D-2 ข้อมูลในเครื่องเท่านั้น)
  bool get isLoaded => water.isLoaded && steps.isLoaded && food.isLoaded;

  /// คำนวณสดจาก controller เดิม (ไม่ cache ข้อมูลซ้ำ)
  SevenDaySnapshot get snapshot => SevenDayLogic.snapshot(
        now: _clock(),
        waterHistory: water.state.history,
        steps: steps.state,
        food: food.state,
        foodCurrentOverLimit: food.isOverLimit,
      );

  // ---------------------------------------------------------------------------
  // โหลด / รอบวัน (US-3, EC-4 — รอบ 05:00 ของ controller เดิม, D-4)
  // ---------------------------------------------------------------------------

  /// เรียกตอนเปิดหน้า: โหลด controller ที่ยังไม่โหลด / ตรวจรอบวันของตัวที่โหลดแล้ว
  /// แล้วเริ่มตรวจรอบวันทุก [SevenDayRules.dayCheckIntervalSeconds] วินาที
  Future<void> start() async {
    _dayTimer ??= _timerFactory(
      const Duration(seconds: SevenDayRules.dayCheckIntervalSeconds),
      () {
        if (!_disposed) refreshDay();
      },
    );
    await Future.wait([
      water.isLoaded ? water.refreshDailyReset() : water.load(),
      steps.isLoaded ? steps.refreshDay() : steps.load(),
      // แบบ DashboardController: เข้าหน้าแล้วอ่านโปรไฟล์ใหม่ (เป้า kcal ใช้ตัดสินป้าย Overeating)
      food.isLoaded ? _refreshFood() : food.load(),
    ]);
  }

  Future<void> _refreshFood() async {
    await food.refreshDay();
    await food.refreshProfile();
  }

  /// ตรวจข้าม 05:00 ของทั้ง 3 controller — เรียกเป็นระยะขณะเปิดหน้าค้าง และตอนแอป resume
  /// controller เดิม rollover แล้ว notify → snapshot ใหม่ (Day 0 เลื่อน) — EC-4
  Future<void> refreshDay() async {
    if (_disposed) return;
    await Future.wait([
      water.refreshDailyReset(),
      steps.refreshDay(),
      food.refreshDay(),
    ]);
  }

  void _onSourceChanged() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _dayTimer?.cancel();
    _dayTimer = null;
    for (final c in _sources) {
      c.removeListener(_onSourceChanged);
    }
    super.dispose();
  }
}
