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
    final SharedPreferences prefs;
    try {
      prefs = await _prefs;
    } catch (_) {
      // DECIDED: Zen-107 2026-10-08 — ข้อมูลในเครื่องเสีย → เริ่มใหม่เป็นค่าว่าง
      // แอปห้าม crash (game-rules.md §4)
      return WaterState.initial;
    }
    // DECIDED: Zen-107 2026-10-08 — ข้อมูลเก็บผิดชนิด (เช่น daily_water_count เป็น
    // String) ให้เริ่มใหม่เป็นค่าว่าง แอปห้าม crash (game-rules.md §4)
    // getInt/getString จะ throw ถ้าค่าในเครื่องเป็นชนิดอื่น จึงอ่านผ่าน _readInt/_readString
    // ASSUMPTION: "เริ่มใหม่เป็นค่าว่าง" ทำทีละคีย์ — คีย์ที่เสียกลับเป็นค่าว่าง
    // คีย์อื่นที่ยังอ่านได้เก็บไว้ (ไม่ลบข้อมูลที่ยังดีทิ้ง)
    final cups = _readInt(prefs, WaterStorageKeys.dailyWaterCount) ?? 0;
    final lastRaw = _readString(prefs, WaterStorageKeys.lastLoggedTimestamp);
    final historyRaw = _readString(prefs, WaterStorageKeys.dailyHistoryLog);
    return WaterState(
      cups: cups < 0 ? 0 : cups,
      lastLoggedAt: lastRaw == null ? null : DateTime.tryParse(lastRaw),
      history: _decodeHistory(historyRaw),
    );
  }

  /// อ่านค่า int แบบไม่ throw — ไม่มีคีย์ หรือเก็บผิดชนิด → null
  static int? _readInt(SharedPreferences prefs, String key) {
    try {
      final value = prefs.get(key);
      return value is int ? value : null;
    } catch (_) {
      return null;
    }
  }

  /// อ่านค่า String แบบไม่ throw — ไม่มีคีย์ หรือเก็บผิดชนิด → null
  static String? _readString(SharedPreferences prefs, String key) {
    try {
      final value = prefs.get(key);
      return value is String ? value : null;
    } catch (_) {
      return null;
    }
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
    } catch (_) {
      // DECIDED: Zen-107 2026-10-08 — ข้อมูลประวัติในเครื่องเสียหรือผิดชนิด
      // ให้เริ่มใหม่เป็นค่าว่าง แอปห้าม crash (game-rules.md §4)
      return const [];
    }
  }
}
