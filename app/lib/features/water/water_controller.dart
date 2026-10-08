/// ตัวกลางระหว่าง logic เกมกับ UI ของฟีเจอร์ water
library;

import 'package:flutter/foundation.dart';

import 'water_logic.dart';
import 'water_models.dart';
import 'water_repository.dart';

typedef Clock = DateTime Function();

class WaterController extends ChangeNotifier {
  WaterController({required this._repository, Clock? clock})
      : _clock = clock ?? DateTime.now;

  final WaterRepository _repository;
  final Clock _clock;

  WaterState _state = WaterState.initial;
  bool _isLoaded = false;

  WaterState get state => _state;
  bool get isLoaded => _isLoaded;

  int get cups => _state.cups;
  double get displayEnergyPercentage =>
      WaterLogic.displayEnergyPercentage(_state.cups);
  double get displayEnergyFraction =>
      WaterLogic.displayEnergyFraction(_state.cups);
  PetMood get mood => WaterLogic.moodFor(_state.cups);

  /// โหลดข้อมูลจากเครื่อง แล้วตรวจรีเซ็ต 05:00 น. ทันที (AC-5, EC-2)
  Future<void> load() async {
    final loaded = await _repository.load();
    _state = loaded;
    _isLoaded = true;
    await refreshDailyReset();
    notifyListeners();
  }

  /// ตรวจว่าข้ามเวลา 05:00 น. ของวันใหม่หรือยัง ถ้าใช่ รีเซ็ตเป็น 0 และบันทึกลงเครื่อง
  /// เรียกตอนเปิดแอป, ตอนแอปกลับมาหน้าจอ และเป็นระยะระหว่างเปิดแอป
  Future<void> refreshDailyReset() async {
    if (!_isLoaded) return;
    final next = WaterLogic.applyDailyReset(_state, _clock());
    if (identical(next, _state)) return;
    _state = next;
    notifyListeners();
    await _repository.save(_state);
  }

  /// กดบันทึกน้ำ 1 แก้ว (AC-1, AC-3, AC-4, EC-3)
  ///
  /// อัปเดตสถานะในหน่วยความจำแบบ synchronous ก่อนบันทึกลงเครื่อง
  /// เพื่อให้การกดรัวในเสี้ยววินาทีเห็นเวลาบันทึกล่าสุดแล้วถูกบล็อก (EC-3)
  Future<LogWaterOutcome> logWater() async {
    if (!_isLoaded) {
      // ASSUMPTION: ยังโหลดข้อมูลไม่เสร็จ ถือว่ายังบันทึกไม่ได้ (กันข้อมูลทับกัน)
      return LogWaterOutcome.notReady;
    }
    final result = WaterLogic.logWater(_state, _clock());
    final changed = !identical(result.state, _state);
    _state = result.state;
    if (changed) notifyListeners();
    if (changed) await _repository.save(_state);
    return result.outcome;
  }

  /// รายงานของเดือนปัจจุบัน (AC-6)
  MonthlyWaterReport monthlyReport() =>
      WaterLogic.monthlyReport(_state.history, _clock());
}
