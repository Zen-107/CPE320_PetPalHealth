/// TTS ตัวจริงผ่าน `flutter_tts` (ui-spec §2.4.5) — Android / iOS เท่านั้น
///
/// DECIDED (owner 2026-11-12, V-6, V-6a): ใช้ engine ในเครื่องเท่านั้น ห้าม cloud TTS
/// · ไม่มีเสียงไทย / error → prepare() คืน false (controller ข้ามเงียบ)
/// **ห้ามสร้างในเทสต์** (ไม่มี platform channel) — เทสต์ใช้ fake ที่ implement [VoiceTtsEngine]
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'voice_rules.dart';
import 'voice_tts_engine.dart';

class FlutterTtsVoiceEngine implements VoiceTtsEngine {
  FlutterTtsVoiceEngine([FlutterTts? tts]) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;

  /// แพลตฟอร์มที่ตัวนี้รองรับ — อื่น ๆ ใช้ NoopVoiceTtsEngine (ASSUMPTION: voice ui-spec Q-31)
  static bool get isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Future<bool> prepare() async {
    try {
      final available = await _tts.isLanguageAvailable(VoiceRules.ttsLanguage);
      if (available != true) return false;
      await _tts.setLanguage(VoiceRules.ttsLanguage);
      await _tts.setPitch(VoiceRules.ttsPitch);
      await _tts.setVolume(VoiceRules.defaultAudioVolumeGain);
      // speak() รอจนพูดจบ → คิวเล่นทีละบท (EC-2)
      await _tts.awaitSpeakCompletion(true);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ASSUMPTION: voice ui-spec Q-21 — ไม่เรียก setSpeechRate (ใช้ค่าเครื่อง)
  @override
  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }
}
