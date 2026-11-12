/// การเก็บสถานะของฟีเจอร์เสียงในเครื่อง (ui-spec §2.5) — shared_preferences เท่านั้น
/// ไม่มี network (V-6a)
library;

import 'package:shared_preferences/shared_preferences.dart';

import 'voice_models.dart';

/// ชื่อ key ตรง game-rules §1.2 + `voice_day_bands` (ui-spec Q-09)
// DECIDED (owner 2026-11-12, V-3, V-6b): ไม่มี key push_notification_shortcut_toggle /
// audio_file_path
class VoiceStorageKeys {
  VoiceStorageKeys._();

  /// bool — true = ON, false = OFF, ไม่มีคีย์ = UNANSWERED
  static const String permissionStatus = 'voice_permission_status';

  /// bool — ไม่มีคีย์ = false
  static const String masterVoice = 'master_voice_toggle';

  // ASSUMPTION: voice ui-spec Q-09 — key ใหม่ (ไม่มีใน game-rules) เก็บช่วงล่าสุดของรอบวัน
  static const String dayBands = 'voice_day_bands';

  static const List<String> all = [permissionStatus, masterVoice, dayBands];
}

abstract class VoiceRepository {
  /// อ่านสถานะ — throw ได้ (controller ถือเป็นค่าเริ่มต้น — ux-flow §4 S-1 ERROR)
  Future<VoiceState> load();

  /// S-1 — บันทึก `voice_permission_status` และ `master_voice_toggle` เป็นค่าเดียวกัน
  Future<void> savePermission({required bool enabled});

  /// S-3 — throw ได้ (SnackBar ui-spec §2.3)
  Future<void> saveMasterVoice(bool on);

  Future<void> saveDayBands(VoiceDayBands bands);
}

/// เก็บในหน่วยความจำ (เทสต์) — เปิด [state] และตัวนับการบันทึกให้เทสต์ตรวจ
class InMemoryVoiceRepository implements VoiceRepository {
  InMemoryVoiceRepository([this._state = VoiceState.initial]);

  VoiceState _state;

  VoiceState get state => _state;

  int savePermissionCount = 0;
  int saveMasterVoiceCount = 0;
  int saveDayBandsCount = 0;

  /// ค่าที่ส่งให้ saveMasterVoice ตามลำดับ
  final List<bool> savedMasterVoiceValues = [];

  @override
  Future<VoiceState> load() async => _state;

  @override
  Future<void> savePermission({required bool enabled}) async {
    savePermissionCount++;
    _state = _state.copyWith(
      permissionStatus:
          enabled ? VoicePermissionStatus.on : VoicePermissionStatus.off,
      masterVoice: enabled,
    );
  }

  @override
  Future<void> saveMasterVoice(bool on) async {
    saveMasterVoiceCount++;
    savedMasterVoiceValues.add(on);
    _state = _state.copyWith(masterVoice: on);
  }

  @override
  Future<void> saveDayBands(VoiceDayBands bands) async {
    saveDayBandsCount++;
    _state = _state.copyWith(dayBands: bands);
  }
}

class SharedPrefsVoiceRepository implements VoiceRepository {
  SharedPrefsVoiceRepository([Future<SharedPreferences>? prefs])
      : _prefs = prefs ?? SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefs;

  @override
  Future<VoiceState> load() async {
    final prefs = await _prefs;
    // แบบ SharedPrefsNotificationRepository: อ่านทีละคีย์ ค่าผิดชนิด = ไม่มีคีย์
    final permission = _readBool(prefs, VoiceStorageKeys.permissionStatus);
    return VoiceState(
      permissionStatus: switch (permission) {
        true => VoicePermissionStatus.on,
        false => VoicePermissionStatus.off,
        null => VoicePermissionStatus.unanswered,
      },
      masterVoice: _readBool(prefs, VoiceStorageKeys.masterVoice) ?? false,
      dayBands: VoiceDayBands.fromJsonString(
          _readString(prefs, VoiceStorageKeys.dayBands)),
    );
  }

  @override
  Future<void> savePermission({required bool enabled}) async {
    final prefs = await _prefs;
    await prefs.setBool(VoiceStorageKeys.permissionStatus, enabled);
    await prefs.setBool(VoiceStorageKeys.masterVoice, enabled);
  }

  @override
  Future<void> saveMasterVoice(bool on) async {
    final prefs = await _prefs;
    await prefs.setBool(VoiceStorageKeys.masterVoice, on);
  }

  @override
  Future<void> saveDayBands(VoiceDayBands bands) async {
    final prefs = await _prefs;
    await prefs.setString(VoiceStorageKeys.dayBands, bands.toJsonString());
  }

  static String? _readString(SharedPreferences prefs, String key) {
    try {
      final v = prefs.get(key);
      return v is String ? v : null;
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
}
