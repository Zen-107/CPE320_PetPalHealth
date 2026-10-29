/// การเก็บข้อมูล steps ในเครื่อง
///
/// requirements.md §7 ระบุ "Server Database" แต่ MVP ไม่มี network/server (ui-spec D-2)
/// จึงเก็บทุกอย่างใน Local Storage (shared_preferences) เท่านั้น
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'steps_logic.dart';
import 'steps_models.dart';
import 'steps_rules.dart';

/// ชื่อ key ใน shared_preferences (ตามข้อมูลใน requirements.md §7)
class StepsStorageKeys {
  StepsStorageKeys._();

  static const String currentSteps = 'steps_current_steps';
  static const String currentDay = 'steps_current_day';
  static const String dailyGoal = 'steps_daily_goal';
  static const String pendingGoal = 'steps_pending_goal';
  static const String pendingGoalDay = 'steps_pending_goal_day';
  static const String hasUserGoal = 'steps_has_user_goal';
  static const String goalChangeDay = 'steps_goal_change_day';
  static const String goalChangeCount = 'steps_goal_change_count';
  static const String lastSeenAt = 'steps_last_seen_at';
  static const String petStatus = 'steps_pet_status';
  static const String historyLog = 'steps_history_log';

  static const List<String> all = [
    currentSteps,
    currentDay,
    dailyGoal,
    pendingGoal,
    pendingGoalDay,
    hasUserGoal,
    goalChangeDay,
    goalChangeCount,
    lastSeenAt,
    petStatus,
    historyLog,
  ];
}

/// เขียนลงเครื่องไม่สำเร็จ (ui-spec Q-6 → S-2 Error)
class StepsStorageException implements Exception {
  const StepsStorageException(this.message);
  final String message;
  @override
  String toString() => 'StepsStorageException: $message';
}

/// interface โหลด/บันทึก — แยกไว้ให้ QA สลับเป็นตัวปลอมได้
abstract class StepsRepository {
  Future<StepsState> load();

  /// throw ถ้าบันทึกไม่สำเร็จ
  Future<void> save(StepsState state);
}

/// เก็บในหน่วยความจำ (ใช้ทดสอบ) — ตั้ง [failSaves] = true เพื่อจำลองบันทึกไม่สำเร็จ
class InMemoryStepsRepository implements StepsRepository {
  InMemoryStepsRepository([StepsState initial = StepsState.initial])
      : _state = initial;

  StepsState _state;
  bool failSaves = false;
  int saveCount = 0;

  StepsState get stored => _state;

  @override
  Future<StepsState> load() async => _state;

  @override
  Future<void> save(StepsState state) async {
    if (failSaves) {
      throw const StepsStorageException('simulated save failure');
    }
    saveCount++;
    _state = state;
  }
}

/// เก็บด้วย shared_preferences ในเครื่อง
class SharedPrefsStepsRepository implements StepsRepository {
  SharedPrefsStepsRepository([Future<SharedPreferences>? prefs])
      : _prefs = prefs ?? SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefs;

  @override
  Future<StepsState> load() async {
    final SharedPreferences prefs;
    try {
      prefs = await _prefs;
    } catch (_) {
      // ASSUMPTION: อ่านข้อมูลในเครื่องไม่ได้ → เริ่มเป็นค่าว่าง แอปไม่ล่ม (แนวเดียวกับ water)
      return StepsState.initial;
    }
    // ASSUMPTION: คีย์ที่เสีย/ผิดชนิด → ใช้ค่าว่างเฉพาะคีย์นั้น (แนวเดียวกับ water)
    final steps = _readInt(prefs, StepsStorageKeys.currentSteps) ?? 0;
    final goal = _readInt(prefs, StepsStorageKeys.dailyGoal);
    final pending = _readInt(prefs, StepsStorageKeys.pendingGoal);
    final changeCount = _readInt(prefs, StepsStorageKeys.goalChangeCount) ?? 0;
    return StepsState(
      steps: steps < 0 ? 0 : steps,
      day: _readDate(prefs, StepsStorageKeys.currentDay),
      activeGoal: goal != null && StepsLogic.isValidGoal(goal)
          ? goal
          : StepsRules.defaultDailyGoal,
      pendingGoal:
          pending != null && StepsLogic.isValidGoal(pending) ? pending : null,
      pendingGoalDay: _readDate(prefs, StepsStorageKeys.pendingGoalDay),
      hasUserGoal: _readBool(prefs, StepsStorageKeys.hasUserGoal) ?? false,
      goalChangeDay: _readDate(prefs, StepsStorageKeys.goalChangeDay),
      goalChangeCount: changeCount < 0 ? 0 : changeCount,
      lastSeenAt: _readDateTime(prefs, StepsStorageKeys.lastSeenAt),
      history: _decodeHistory(_readString(prefs, StepsStorageKeys.historyLog)),
    );
  }

  @override
  Future<void> save(StepsState state) async {
    final SharedPreferences prefs;
    try {
      prefs = await _prefs;
    } catch (e) {
      throw StepsStorageException('cannot open storage: $e');
    }
    final results = <bool>[
      await prefs.setInt(StepsStorageKeys.currentSteps, state.steps),
      await _setOrRemove(prefs, StepsStorageKeys.currentDay,
          state.day == null ? null : formatStepsDateKey(state.day!)),
      await prefs.setInt(StepsStorageKeys.dailyGoal, state.activeGoal),
      state.pendingGoal == null
          ? await prefs.remove(StepsStorageKeys.pendingGoal)
          : await prefs.setInt(StepsStorageKeys.pendingGoal, state.pendingGoal!),
      await _setOrRemove(
          prefs,
          StepsStorageKeys.pendingGoalDay,
          state.pendingGoalDay == null
              ? null
              : formatStepsDateKey(state.pendingGoalDay!)),
      await prefs.setBool(StepsStorageKeys.hasUserGoal, state.hasUserGoal),
      await _setOrRemove(
          prefs,
          StepsStorageKeys.goalChangeDay,
          state.goalChangeDay == null
              ? null
              : formatStepsDateKey(state.goalChangeDay!)),
      await prefs.setInt(
          StepsStorageKeys.goalChangeCount, state.goalChangeCount),
      await _setOrRemove(prefs, StepsStorageKeys.lastSeenAt,
          state.lastSeenAt?.toIso8601String()),
      // Pet Status Enum (requirements.md §7) — เก็บไว้อ้างอิง คำนวณใหม่ทุกครั้งที่แสดงผล
      await prefs.setString(
        StepsStorageKeys.petStatus,
        StepsLogic.statusFor(state.steps, state.activeGoal).code,
      ),
      await prefs.setString(
        StepsStorageKeys.historyLog,
        jsonEncode([for (final r in state.history) r.toJson()]),
      ),
    ];
    if (results.contains(false)) {
      throw const StepsStorageException('shared_preferences write failed');
    }
  }

  static Future<bool> _setOrRemove(
      SharedPreferences prefs, String key, String? value) {
    if (value == null) return prefs.remove(key);
    return prefs.setString(key, value);
  }

  static Object? _raw(SharedPreferences prefs, String key) {
    try {
      return prefs.get(key);
    } catch (_) {
      return null;
    }
  }

  static int? _readInt(SharedPreferences prefs, String key) {
    final v = _raw(prefs, key);
    return v is int ? v : null;
  }

  static bool? _readBool(SharedPreferences prefs, String key) {
    final v = _raw(prefs, key);
    return v is bool ? v : null;
  }

  static String? _readString(SharedPreferences prefs, String key) {
    final v = _raw(prefs, key);
    return v is String ? v : null;
  }

  static DateTime? _readDateTime(SharedPreferences prefs, String key) {
    final raw = _readString(prefs, key);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  static DateTime? _readDate(SharedPreferences prefs, String key) {
    final d = _readDateTime(prefs, key);
    return d == null ? null : DateTime(d.year, d.month, d.day);
  }

  static List<DailyStepsRecord> _decodeHistory(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      final records = <DailyStepsRecord>[];
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          try {
            records.add(DailyStepsRecord.fromJson(item));
          } catch (_) {
            // ข้ามรายการที่เสีย เก็บรายการที่ยังอ่านได้
          }
        }
      }
      records.sort((a, b) => a.date.compareTo(b.date));
      return List.unmodifiable(records);
    } catch (_) {
      return const [];
    }
  }
}
