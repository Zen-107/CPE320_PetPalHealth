/// การเก็บข้อมูล food ในเครื่อง
///
/// requirements §6 ระบุ "Database" แต่ MVP ไม่มี network/server — เก็บใน
/// shared_preferences เท่านั้น (ข้อมูลไม่ออกนอกเครื่อง)
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'food_models.dart';

/// ชื่อ key ใน shared_preferences
class FoodStorageKeys {
  FoodStorageKeys._();

  /// รอบวันปัจจุบัน YYYY-MM-DD (AC-3 `date`)
  static const String currentDay = 'food_current_day';

  /// `total_calories` ของรอบวันปัจจุบัน
  static const String totalCalories = 'food_total_calories';

  /// Log มื้อของรอบวันปัจจุบัน (JSON list ของ FoodMealEntry)
  static const String mealsLog = 'food_meals_log';

  /// ประวัติรายวัน (JSON list ของ DailyFoodRecord) ไม่เกิน HISTORY_RETENTION_DAYS
  static const String historyLog = 'food_history_log';
  static const String lastSeenAt = 'food_last_seen_at';

  /// ผู้ใช้กด「ข้ามไปก่อน」(US-3)
  static const String profileSkipped = 'food_profile_skipped';

  static const List<String> all = [
    currentDay,
    totalCalories,
    mealsLog,
    historyLog,
    lastSeenAt,
    profileSkipped,
  ];
}

class FoodStorageException implements Exception {
  const FoodStorageException(this.message);
  final String message;
  @override
  String toString() => 'FoodStorageException: $message';
}

/// interface โหลด/บันทึก — แยกไว้ให้ QA สลับเป็นตัวปลอมได้
abstract class FoodRepository {
  Future<FoodState> load();

  /// throw ถ้าบันทึกไม่สำเร็จ
  Future<void> save(FoodState state);
}

/// เก็บในหน่วยความจำ (ใช้ทดสอบ) — [failSaves] = true จำลองบันทึกไม่สำเร็จ
class InMemoryFoodRepository implements FoodRepository {
  InMemoryFoodRepository([FoodState initial = FoodState.initial])
    : _state = initial;

  FoodState _state;
  bool failSaves = false;
  int saveCount = 0;

  FoodState get stored => _state;

  @override
  Future<FoodState> load() async => _state;

  @override
  Future<void> save(FoodState state) async {
    if (failSaves) throw const FoodStorageException('simulated save failure');
    saveCount++;
    _state = state;
  }
}

/// เก็บด้วย shared_preferences
class SharedPrefsFoodRepository implements FoodRepository {
  SharedPrefsFoodRepository([Future<SharedPreferences>? prefs])
    : _prefs = prefs ?? SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefs;

  @override
  Future<FoodState> load() async {
    final SharedPreferences prefs;
    try {
      prefs = await _prefs;
    } catch (_) {
      // ASSUMPTION: อ่านข้อมูลในเครื่องไม่ได้ → เริ่มเป็นค่าว่าง แอปไม่ล่ม (แนวเดียวกับ water/steps)
      return FoodState.initial;
    }
    // ASSUMPTION: คีย์ที่เสีย/ผิดชนิด → ใช้ค่าว่างเฉพาะคีย์นั้น (แนวเดียวกับ water/steps)
    final total = _read<int>(prefs, FoodStorageKeys.totalCalories) ?? 0;
    final lastSeen = _read<String>(prefs, FoodStorageKeys.lastSeenAt);
    return FoodState(
      day: parseFoodDateKey(_read<String>(prefs, FoodStorageKeys.currentDay)),
      totalCalories: total < 0 ? 0 : total,
      meals: _decodeList(
        _read<String>(prefs, FoodStorageKeys.mealsLog),
        FoodMealEntry.fromJson,
      ),
      history: _decodeList(
        _read<String>(prefs, FoodStorageKeys.historyLog),
        DailyFoodRecord.fromJson,
      )..sort((a, b) => a.date.compareTo(b.date)),
      lastSeenAt: lastSeen == null ? null : DateTime.tryParse(lastSeen),
      profileSkipped:
          _read<bool>(prefs, FoodStorageKeys.profileSkipped) ?? false,
    );
  }

  @override
  Future<void> save(FoodState state) async {
    final SharedPreferences prefs;
    try {
      prefs = await _prefs;
    } catch (e) {
      throw FoodStorageException('cannot open storage: $e');
    }
    final results = <bool>[
      state.day == null
          ? await prefs.remove(FoodStorageKeys.currentDay)
          : await prefs.setString(
              FoodStorageKeys.currentDay,
              formatFoodDateKey(state.day!),
            ),
      await prefs.setInt(FoodStorageKeys.totalCalories, state.totalCalories),
      await prefs.setString(
        FoodStorageKeys.mealsLog,
        jsonEncode([for (final m in state.meals) m.toJson()]),
      ),
      await prefs.setString(
        FoodStorageKeys.historyLog,
        jsonEncode([for (final r in state.history) r.toJson()]),
      ),
      state.lastSeenAt == null
          ? await prefs.remove(FoodStorageKeys.lastSeenAt)
          : await prefs.setString(
              FoodStorageKeys.lastSeenAt,
              state.lastSeenAt!.toIso8601String(),
            ),
      await prefs.setBool(FoodStorageKeys.profileSkipped, state.profileSkipped),
    ];
    if (results.contains(false)) {
      throw const FoodStorageException('shared_preferences write failed');
    }
  }

  static T? _read<T>(SharedPreferences prefs, String key) {
    try {
      final v = prefs.get(key);
      return v is T ? v : null;
    } catch (_) {
      return null;
    }
  }

  static List<T> _decodeList<T>(
    String? raw,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (raw == null || raw.isEmpty) return <T>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return <T>[];
      final out = <T>[];
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          try {
            out.add(fromJson(item));
          } catch (_) {
            // ข้ามรายการที่เสีย เก็บรายการที่ยังอ่านได้
          }
        }
      }
      return out;
    } catch (_) {
      return <T>[];
    }
  }
}
