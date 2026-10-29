/// ตัวกลางระหว่าง logic เกมกับ UI ของฟีเจอร์ steps
library;

import 'package:flutter/foundation.dart';

import '../water/water_models.dart' show DailyWaterRecord;
import 'steps_external.dart';
import 'steps_logic.dart';
import 'steps_models.dart';
import 'steps_repository.dart';
import 'steps_rules.dart';

typedef StepsClock = DateTime Function();

class StepsController extends ChangeNotifier {
  StepsController({
    required this._repository,
    WaterHistorySource? waterHistory,
    StepsReportExporter? exporter,
    StepsClock? clock,
    this._trackingStatus = StepsTrackingStatus.available,
    this._isOffline = false,
  })  : _waterHistory = waterHistory ?? FixedWaterHistorySource(),
        _exporter = exporter ?? FileStepsReportExporter(),
        _clock = clock ?? DateTime.now;

  final StepsRepository _repository;
  final WaterHistorySource _waterHistory;
  final StepsReportExporter _exporter;
  final StepsClock _clock;

  StepsState _state = StepsState.initial;
  bool _isLoaded = false;
  bool _savingGoal = false;
  int _petCheerCount = 0;
  List<DailyWaterRecord> _waterRecords = const [];

  StepsTrackingStatus _trackingStatus;
  bool _isOffline;

  // ---------------------------------------------------------------------------
  // ค่าสำหรับ UI
  // ---------------------------------------------------------------------------

  StepsState get state => _state;
  bool get isLoaded => _isLoaded;

  int get steps => _state.steps;

  /// เป้าหมายที่ใช้คำนวณ % Goal ของรอบวันปัจจุบัน
  int get activeGoal => _state.activeGoal;

  /// เป้าหมายล่าสุดที่บันทึก (รวมที่รอมีผลรอบวันถัดไป) — ใช้เลือกชิปบน S-2
  int get latestGoal => _state.latestGoal;

  double get percentGoal => StepsLogic.percentGoal(steps, activeGoal);
  String get percentText => '${StepsLogic.formatPercent(steps, activeGoal)}%';
  double get energyBarFraction =>
      StepsLogic.energyBarFraction(steps, activeGoal);
  StepsPetStatus get petStatus => StepsLogic.statusFor(steps, activeGoal);
  String get countText => StepsLogic.countText(steps, activeGoal);

  /// จำนวนครั้งที่เพิ่มก้าวสำเร็จ (outcome == added) ตั้งแต่สร้าง controller
  /// ส่งเป็น `PetCharacter.cheerTrigger` — ค่าเปลี่ยน = สัตว์เลี้ยงเล่นท่าดีใจ 1 ครั้ง
  /// เก็บไว้ใน controller (ไม่ใช่ใน widget) เพื่อให้ rebuild ไม่ทำให้เล่นท่าดีใจเอง
  /// และไม่บันทึกลงเครื่อง (เป็นค่าการแสดงผล ไม่ใช่ข้อมูลเกม)
  int get petCheerCount => _petCheerCount;

  bool get canChangeGoal => StepsLogic.canChangeGoal(_state, _clock());
  int get remainingGoalQuota =>
      StepsLogic.remainingGoalQuota(_state, _clock());

  /// EC-1 / EC-6 — ล็อกฟังก์ชันนับก้าว
  StepsTrackingStatus get trackingStatus => _trackingStatus;
  bool get isTrackingLocked =>
      _trackingStatus != StepsTrackingStatus.available;

  /// ux-flow S-1 Disabled (ออฟไลน์) — MVP ไม่มี network จึงเป็น false เว้นแต่ inject
  // ASSUMPTION: ui-spec Q-5 — ไม่มีเงื่อนไข trigger จริงใน MVP เปิดได้ผ่าน flag นี้เท่านั้น
  bool get isOffline => _isOffline;

  set trackingStatus(StepsTrackingStatus value) {
    if (value == _trackingStatus) return;
    _trackingStatus = value;
    notifyListeners();
  }

  set isOffline(bool value) {
    if (value == _isOffline) return;
    _isOffline = value;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // โหลด / รอบวัน (EC-2, AC-6, EC-5)
  // ---------------------------------------------------------------------------

  /// โหลดค่าล่าสุดจากเครื่อง แล้วตรวจรอบวันทันที (EC-2)
  Future<void> load() async {
    StepsState loaded;
    try {
      loaded = await _repository.load();
    } catch (_) {
      // ASSUMPTION: อ่านข้อมูลไม่ได้ → เริ่มเป็นค่าว่าง แอปไม่ล่ม
      loaded = StepsState.initial;
    }
    _state = loaded;
    _isLoaded = true;
    await refreshWaterHistory();
    await refreshDay();
    notifyListeners();
  }

  /// ตรวจว่าข้าม 05:00 น. หรือยัง ถ้าใช่ รีเซ็ตก้าวเป็น 0 แล้วบันทึกลงเครื่อง
  /// เรียกตอนเปิดหน้า, กลับมา foreground และเป็นระยะขณะเปิดหน้าค้าง (EC-5)
  Future<void> refreshDay() async {
    if (!_isLoaded) return;
    final next = StepsLogic.applyDayRollover(_state, _clock());
    if (identical(next, _state)) return;
    _state = next;
    notifyListeners();
    await _trySave(_state);
  }

  // ---------------------------------------------------------------------------
  // เพิ่มก้าวด้วยมือ (ui-spec D-1)
  // ---------------------------------------------------------------------------

  Future<AddStepsOutcome> addSteps([int amount = StepsRules.stepsPerTap]) async {
    if (!_isLoaded) return AddStepsOutcome.notReady;
    if (isTrackingLocked) return AddStepsOutcome.locked;
    _state = StepsLogic.addSteps(_state, amount, _clock());
    _petCheerCount++;
    notifyListeners();
    await _trySave(_state);
    return AddStepsOutcome.added;
  }

  // ---------------------------------------------------------------------------
  // เป้าหมาย (AC-2, AC-3, AC-4)
  // ---------------------------------------------------------------------------

  /// บันทึกเป้าหมาย — เขียนลงเครื่องก่อน สำเร็จแล้วจึงเปลี่ยนสถานะ
  /// ถ้าเขียนไม่สำเร็จ สถานะและโควต้าไม่เปลี่ยน ([SaveGoalOutcome.storageError])
  Future<SaveGoalOutcome> saveGoal(int goal) async {
    if (!_isLoaded || _savingGoal) return SaveGoalOutcome.notReady;
    final result = StepsLogic.saveGoal(_state, goal, _clock());
    if (!result.isSaved) {
      if (!identical(result.state, _state)) {
        _state = result.state;
        notifyListeners();
      }
      return result.outcome;
    }
    _savingGoal = true;
    try {
      await _repository.save(result.state);
    } catch (_) {
      return SaveGoalOutcome.storageError;
    } finally {
      _savingGoal = false;
    }
    _state = result.state;
    notifyListeners();
    return result.outcome;
  }

  // ---------------------------------------------------------------------------
  // รายงานรายเดือน (AC-7)
  // ---------------------------------------------------------------------------

  /// โหลดประวัติน้ำจากฟีเจอร์ water ใหม่ — คืน false ถ้าโหลดไม่สำเร็จ
  Future<bool> refreshWaterHistory() async {
    try {
      _waterRecords = List.unmodifiable(await _waterHistory.loadHistory());
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  MonthlyStepsReport monthlyReport() =>
      StepsLogic.monthlyReport(_state, _waterRecords, _clock());

  /// บันทึก PNG ของรายงานเดือนปัจจุบัน คืน path — throw ถ้าไม่สำเร็จ
  Future<String> exportMonthlyReportPng(Uint8List pngBytes) {
    final report = monthlyReport();
    return _exporter.savePng(pngBytes,
        year: report.year, month: report.month);
  }

  Future<void> _trySave(StepsState s) async {
    try {
      await _repository.save(s);
    } catch (_) {
      // ASSUMPTION: บันทึกก้าว/รอบวันลงเครื่องไม่สำเร็จ → คงค่าในหน่วยความจำไว้
      // แล้วบันทึกซ้ำในการเปลี่ยนแปลงครั้งถัดไป (ไม่มี UI error สำหรับกรณีนี้ใน ux-flow)
    }
  }
}
