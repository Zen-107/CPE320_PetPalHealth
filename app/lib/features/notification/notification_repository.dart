/// การเก็บสถานะของฟีเจอร์แจ้งเตือนในเครื่อง (ui-spec §2.5) — shared_preferences เท่านั้น
/// ไม่มี network (requirements §5)
library;

import 'package:shared_preferences/shared_preferences.dart';

import 'notification_models.dart';

/// ชื่อ key ตรง game-rules §1.2 (แบบ WaterStorageKeys) + `notification_day_plan` (ui-spec Q-21)
// DECIDED (owner 2026-11-08, D-3): ไม่มี key last_manual_move_timestamp
class NotificationStorageKeys {
  NotificationStorageKeys._();

  static const String consentStatus = 'consent_status';
  static const String masterSwitch = 'notification_master_switch';
  static const String systemPermissionStatus = 'system_permission_status';
  static const String sentNotificationCount = 'sent_notification_count';
  static const String lastNotificationTimestamp = 'last_notification_timestamp';
  static const String walkNearGoalSentToday = 'walk_near_goal_sent_today';
  static const String lastStepsIncreasedTimestamp =
      'last_steps_increased_timestamp';

  // ASSUMPTION: ui-spec Q-21 — key ใหม่ (ไม่มีใน game-rules) เก็บแผนที่ตั้งไว้ของรอบวัน
  static const String dayPlan = 'notification_day_plan';

  static const String switchOn = 'ON';
  static const String switchOff = 'OFF';

  static const List<String> all = [
    consentStatus,
    masterSwitch,
    systemPermissionStatus,
    sentNotificationCount,
    lastNotificationTimestamp,
    walkNearGoalSentToday,
    lastStepsIncreasedTimestamp,
    dayPlan,
  ];
}

abstract class NotificationRepository {
  /// อ่านสถานะ — throw ได้เมื่ออ่านไม่สำเร็จ (controller จัดการ ux-flow §4 S-1 ERROR)
  Future<NotificationState> load();

  /// บันทึกสถานะทั้งหมด — throw ได้เมื่อบันทึกไม่สำเร็จ
  Future<void> save(NotificationState state);
}

/// เก็บในหน่วยความจำ (เทสต์ / แพลตฟอร์มที่ไม่ต้องการเก็บถาวร)
class InMemoryNotificationRepository implements NotificationRepository {
  InMemoryNotificationRepository([this._state = NotificationState.initial]);

  NotificationState _state;

  /// สถานะล่าสุดที่บันทึก (ให้เทสต์ตรวจ)
  NotificationState get state => _state;

  @override
  Future<NotificationState> load() async => _state;

  @override
  Future<void> save(NotificationState state) async => _state = state;
}

class SharedPrefsNotificationRepository implements NotificationRepository {
  SharedPrefsNotificationRepository([Future<SharedPreferences>? prefs])
      : _prefs = prefs ?? SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefs;

  @override
  Future<NotificationState> load() async {
    final prefs = await _prefs;
    // แบบ SharedPrefsWaterRepository: อ่านทีละคีย์ ค่าผิดชนิด / อ่านไม่ได้ = ค่าเริ่มต้น
    final masterRaw = _readString(prefs, NotificationStorageKeys.masterSwitch);
    return NotificationState(
      consentStatus: NotificationConsentStatus.fromCode(
          _readString(prefs, NotificationStorageKeys.consentStatus)),
      masterSwitch: masterRaw == NotificationStorageKeys.switchOn,
      systemPermission: NotificationSystemPermission.fromCode(
          _readString(prefs, NotificationStorageKeys.systemPermissionStatus)),
      sentNotificationCount:
          _readInt(prefs, NotificationStorageKeys.sentNotificationCount) ?? 0,
      lastNotificationTimestamp: _readDate(
          prefs, NotificationStorageKeys.lastNotificationTimestamp),
      walkNearGoalSentToday:
          _readBool(prefs, NotificationStorageKeys.walkNearGoalSentToday) ??
              false,
      lastStepsIncreasedTimestamp: _readDate(
          prefs, NotificationStorageKeys.lastStepsIncreasedTimestamp),
      dayPlan: NotificationDayPlan.fromJsonString(
          _readString(prefs, NotificationStorageKeys.dayPlan)),
    );
  }

  @override
  Future<void> save(NotificationState state) async {
    final prefs = await _prefs;
    await prefs.setString(
        NotificationStorageKeys.consentStatus, state.consentStatus.code);
    await prefs.setString(
      NotificationStorageKeys.masterSwitch,
      state.masterSwitch
          ? NotificationStorageKeys.switchOn
          : NotificationStorageKeys.switchOff,
    );
    await prefs.setString(NotificationStorageKeys.systemPermissionStatus,
        state.systemPermission.code);
    await prefs.setInt(NotificationStorageKeys.sentNotificationCount,
        state.sentNotificationCount);
    await _setDate(prefs, NotificationStorageKeys.lastNotificationTimestamp,
        state.lastNotificationTimestamp);
    await prefs.setBool(NotificationStorageKeys.walkNearGoalSentToday,
        state.walkNearGoalSentToday);
    await _setDate(prefs, NotificationStorageKeys.lastStepsIncreasedTimestamp,
        state.lastStepsIncreasedTimestamp);
    final plan = state.dayPlan;
    if (plan == null) {
      await prefs.remove(NotificationStorageKeys.dayPlan);
    } else {
      await prefs.setString(
          NotificationStorageKeys.dayPlan, plan.toJsonString());
    }
  }

  static Future<void> _setDate(
      SharedPreferences prefs, String key, DateTime? value) async {
    if (value == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value.toIso8601String());
    }
  }

  static String? _readString(SharedPreferences prefs, String key) {
    try {
      final v = prefs.get(key);
      return v is String ? v : null;
    } catch (_) {
      return null;
    }
  }

  static int? _readInt(SharedPreferences prefs, String key) {
    try {
      final v = prefs.get(key);
      return v is int ? v : null;
    } catch (_) {
      return null;
    }
  }

  static bool? _readBool(SharedPreferences prefs, String key) {
    try {
      final v = prefs.get(key);
      return v is bool ? v : null;
    } catch (_) {
      return null;
    }
  }

  static DateTime? _readDate(SharedPreferences prefs, String key) {
    final raw = _readString(prefs, key);
    return raw == null ? null : DateTime.tryParse(raw);
  }
}
