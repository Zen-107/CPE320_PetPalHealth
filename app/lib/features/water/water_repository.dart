/// การเก็บข้อมูลน้ำในเครื่อง (Local Storage เท่านั้น — requirements.md §6, §7)
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'water_logic.dart';
import 'water_models.dart';

/// ชื่อ key ตาม requirements.md §7
class WaterStorageKeys {
  WaterStorageKeys._();

  static const String dailyWaterCount = 'daily_water_count';
  static const String waterEnergyPercentage = 'water_energy_percentage';
  static const String lastLoggedTimestamp = 'last_logged_timestamp';
  static const String dailyHistoryLog = 'daily_history_log';
}

/// interface สำหรับโหลด/บันทึกสถานะ — แยกไว้ให้ QA สลับเป็นตัวปลอมได้
abstract class WaterRepository {
  Future<WaterState> load();
  Future<void> save(WaterState state);
}

/// เก็บในหน่วยความจำ (ใช้ทดสอบหรือ fallback) ไม่บันทึกลงเครื่อง
class InMemoryWaterRepository implements WaterRepository {
  InMemoryWaterRepository([WaterState initial = WaterState.initial])
      : _state = initial;

  WaterState _state;

  @override
  Future<WaterState> load() async => _state;

  @override
  Future<void> save(WaterState state) async => _state = state;
}

/// เก็บด้วย shared_preferences ในเครื่อง
class SharedPrefsWaterRepository implements WaterRepository {
  SharedPrefsWaterRepository([Future<SharedPreferences>? prefs])
      : _prefs = prefs ?? SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefs;

  @override
  Future<WaterState> load() async {
    final prefs = await _prefs;
    final cups = prefs.getInt(WaterStorageKeys.dailyWaterCount) ?? 0;
    final lastRaw = prefs.getString(WaterStorageKeys.lastLoggedTimestamp);
    final historyRaw = prefs.getString(WaterStorageKeys.dailyHistoryLog);
    return WaterState(
      cups: cups < 0 ? 0 : cups,
      lastLoggedAt: lastRaw == null ? null : DateTime.tryParse(lastRaw),
      history: _decodeHistory(historyRaw),
    );
  }

  @override
  Future<void> save(WaterState state) async {
    final prefs = await _prefs;
    await prefs.setInt(WaterStorageKeys.dailyWaterCount, state.cups);
    await prefs.setDouble(
      WaterStorageKeys.waterEnergyPercentage,
      WaterLogic.energyPercentage(state.cups),
    );
    final last = state.lastLoggedAt;
    if (last == null) {
      await prefs.remove(WaterStorageKeys.lastLoggedTimestamp);
    } else {
      // ISO 8601 ตาม requirements.md §7
      await prefs.setString(
        WaterStorageKeys.lastLoggedTimestamp,
        last.toIso8601String(),
      );
    }
    await prefs.setString(
      WaterStorageKeys.dailyHistoryLog,
      jsonEncode([for (final r in state.history) r.toJson()]),
    );
  }

  static List<DailyWaterRecord> _decodeHistory(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      final records = <DailyWaterRecord>[];
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          records.add(DailyWaterRecord.fromJson(item));
        }
      }
      records.sort((a, b) => a.date.compareTo(b.date));
      return List.unmodifiable(records);
    } on FormatException {
      // ASSUMPTION: ถ้าข้อมูลประวัติในเครื่องเสีย ให้เริ่มประวัติใหม่ (ไม่ทำให้แอปล่ม)
      return const [];
    } on TypeError {
      return const [];
    }
  }
}
