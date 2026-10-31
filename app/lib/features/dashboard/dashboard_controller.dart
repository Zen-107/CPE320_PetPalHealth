/// ตัวกลางระหว่าง logic ของ dashboard กับ UI
///
/// ไม่มี repository / ไม่เก็บข้อมูลเอง — อ่านค่าจาก WaterController / StepsController /
/// FoodController ตัวเดียวกับที่หน้า water ใช้ (D-2) แล้วคำนวณ snapshot สดทุกครั้ง
/// controller นี้ถือเฉพาะสถานะการแสดงผลของ Dynamic Alert Banner (ข้อความที่แสดง + Timer 5 วินาที)
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../food/food_controller.dart';
import '../steps/steps_controller.dart';
import '../water/water_controller.dart';
import 'dashboard_logic.dart';
import 'dashboard_models.dart';
import 'dashboard_rules.dart';

/// สร้าง Timer — inject ตัวปลอมในเทสต์ที่ไม่ใช่ widget test เพื่อสั่งให้หมดเวลาเองได้
/// (แบบ FoodTimerFactory)
typedef DashboardTimerFactory = Timer Function(
  Duration duration,
  void Function() callback,
);

Timer _defaultTimer(Duration d, void Function() cb) => Timer(d, cb);

class DashboardController extends ChangeNotifier {
  DashboardController({
    required this.water,
    required this.steps,
    required this.food,
    DashboardTimerFactory? timerFactory,
  }) : _timer = timerFactory ?? _defaultTimer {
    for (final c in _sources) {
      c.addListener(_onSourceChanged);
    }
    _queue = snapshot.alerts;
    _daySignature = _currentDaySignature();
    _setCurrent(DashboardLogic.nextAlert(_queue, null));
  }

  final WaterController water;
  final StepsController steps;
  final FoodController food;
  final DashboardTimerFactory _timer;

  List<ChangeNotifier> get _sources => [water, steps, food];

  List<DashboardAlert> _queue = const [];
  DashboardAlert? _current;
  Timer? _alertTimer;
  Object? _daySignature;
  bool _disposed = false;

  // ---------------------------------------------------------------------------
  // ค่าสำหรับ UI
  // ---------------------------------------------------------------------------

  /// ทั้ง 3 controller โหลดจากเครื่องเสร็จแล้ว
  bool get isLoaded => water.isLoaded && steps.isLoaded && food.isLoaded;

  /// ค่าดิบจาก controller เดิม ณ ตอนนี้
  DashboardInput get input => DashboardInput(
        cups: water.cups,
        steps: steps.steps,
        stepsGoal: steps.activeGoal,
        totalCalories: food.totalCalories,
        targetCalories: food.targetCalories,
        isFoodOverLimit: food.isOverLimit,
        hasMealsToday: food.state.meals.isNotEmpty,
      );

  /// คะแนน / อารมณ์ / คิว — คำนวณสดจาก controller เดิม (ไม่ cache ข้อมูลซ้ำ)
  DashboardSnapshot get snapshot => DashboardLogic.snapshot(input);

  /// ข้อความที่แสดงในฟองตอนนี้ (null = คิวว่าง → ซ่อนฟอง)
  DashboardAlert? get currentAlert => _current;

  // ---------------------------------------------------------------------------
  // โหลด / รอบวัน (AC-5, EC-3 — ใช้รอบ 05:00 ของ controller เดิม, D-2)
  // ---------------------------------------------------------------------------

  /// เรียกตอนเปิดหน้า: โหลด controller ที่ยังไม่โหลด / ตรวจรอบวันของตัวที่โหลดแล้ว
  Future<void> start() async {
    await Future.wait([
      water.isLoaded ? water.refreshDailyReset() : water.load(),
      steps.isLoaded ? steps.refreshDay() : steps.load(),
      // แบบ FoodDashboardScreen: เข้าหน้าแล้วอ่านโปรไฟล์ใหม่ (เป้า kcal อาจเปลี่ยนจาก signup)
      food.isLoaded ? _refreshFood() : food.load(),
    ]);
  }

  Future<void> _refreshFood() async {
    await food.refreshDay();
    await food.refreshProfile();
  }

  /// ตรวจข้าม 05:00 ของทั้ง 3 controller — เรียกเป็นระยะขณะเปิดหน้าค้าง และตอนแอป resume
  Future<void> refreshDay() async {
    await Future.wait([
      water.refreshDailyReset(),
      steps.refreshDay(),
      food.refreshDay(),
    ]);
  }

  // ---------------------------------------------------------------------------
  // Dynamic Alert Banner (AC-3, EC-2)
  // ---------------------------------------------------------------------------

  /// รอบวันตามที่ controller เดิมเก็บไว้ (steps / food มี `state.day` จาก logicalDay 05:00)
  Object _currentDaySignature() =>
      Object.hash(steps.state.day, food.state.day);

  void _onSourceChanged() {
    if (_disposed) return;
    final previous = _queue;
    _queue = snapshot.alerts;
    final signature = _currentDaySignature();
    final dayChanged = signature != _daySignature;
    _daySignature = signature;
    final next = DashboardLogic.resolveAlert(
      previousQueue: previous,
      queue: _queue,
      current: _current,
      dayChanged: dayChanged,
    );
    if (next != _current || dayChanged) {
      _setCurrent(next);
    } else if (_current != null && _alertTimer == null) {
      _restartTimer();
    }
    notifyListeners();
  }

  /// เปลี่ยนข้อความที่แสดง แล้วเริ่มนับ alertInterval ใหม่ (Q-19)
  void _setCurrent(DashboardAlert? alert) {
    _current = alert;
    _alertTimer?.cancel();
    _alertTimer = null;
    if (alert != null) _restartTimer();
  }

  void _restartTimer() {
    _alertTimer?.cancel();
    _alertTimer = _timer(
      const Duration(seconds: DashboardRules.alertIntervalSeconds),
      _onAlertTick,
    );
  }

  void _onAlertTick() {
    _alertTimer = null;
    if (_disposed) return;
    _setCurrent(DashboardLogic.nextAlert(_queue, _current));
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _alertTimer?.cancel();
    _alertTimer = null;
    for (final c in _sources) {
      c.removeListener(_onSourceChanged);
    }
    super.dispose();
  }
}
