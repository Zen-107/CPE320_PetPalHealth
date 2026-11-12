// ตัวช่วยร่วมของเทสต์ voice (ไม่ใช่ไฟล์เทสต์ — ไม่มี main) — voice ui-spec §2.4.5
// FlutterTtsVoiceEngine ห้ามถูกสร้างในเทสต์ — ใช้ fake นี้แทน
import 'dart:async';

import 'package:petpal_health/features/dashboard/dashboard_models.dart';
import 'package:petpal_health/features/voice/voice_models.dart';
import 'package:petpal_health/features/voice/voice_repository.dart';
import 'package:petpal_health/features/voice/voice_tts_engine.dart';

class FakeVoiceTtsEngine implements VoiceTtsEngine {
  FakeVoiceTtsEngine({this.available = true, this.autoComplete = true});

  /// ผลของ prepare()
  bool available;

  /// true = speak จบทันที (microtask) · false = รอ [completeCurrent]
  bool autoComplete;
  bool throwOnSpeak = false;

  final List<String> spoken = [];
  int prepareCount = 0;
  int stopCount = 0;

  /// จำนวน speak ที่ยังไม่จบ (ตรวจว่าไม่พูดซ้อน)
  int active = 0;
  int maxActive = 0;

  Completer<void>? _current;

  @override
  Future<bool> prepare() async {
    prepareCount++;
    return available;
  }

  @override
  Future<void> speak(String text) async {
    spoken.add(text);
    if (throwOnSpeak) throw StateError('tts error');
    active++;
    if (active > maxActive) maxActive = active;
    try {
      if (autoComplete) return;
      final c = Completer<void>();
      _current = c;
      await c.future;
    } finally {
      active--;
    }
  }

  void completeCurrent() {
    final c = _current;
    _current = null;
    if (c != null && !c.isCompleted) c.complete();
  }

  @override
  Future<void> stop() async {
    stopCount++;
    completeCurrent();
  }
}

/// repository ที่บันทึก/อ่านไม่ได้
class ThrowingVoiceRepository extends InMemoryVoiceRepository {
  ThrowingVoiceRepository({
    VoiceState state = VoiceState.initial,
    this.throwOnLoad = false,
    this.throwOnSaveMaster = false,
  }) : super(state);

  bool throwOnLoad;
  bool throwOnSaveMaster;

  @override
  Future<VoiceState> load() async {
    if (throwOnLoad) throw const FormatException('corrupt');
    return super.load();
  }

  @override
  Future<void> saveMasterVoice(bool on) async {
    if (throwOnSaveMaster) {
      saveMasterVoiceCount++;
      throw StateError('disk full');
    }
    return super.saveMasterVoice(on);
  }
}

DashboardInput voiceInput({
  int cups = 5,
  int steps = 5000,
  int goal = 10000,
  bool overLimit = false,
}) =>
    DashboardInput(
      cups: cups,
      steps: steps,
      stepsGoal: goal,
      totalCalories: 0,
      targetCalories: null,
      isFoodOverLimit: overLimit,
      hasMealsToday: false,
    );
