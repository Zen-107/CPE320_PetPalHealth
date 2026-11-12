/// TTS ตัวจริงผ่าน `flutter_tts` (ui-spec §2.4.5) — Android / iOS เท่านั้น
///
/// DECIDED (owner 2026-11-12, V-6, V-6a): ใช้ engine ในเครื่องเท่านั้น ห้าม cloud TTS
/// · ไม่มีเสียงไทยในเครื่อง / error → prepare() คืน false (controller ข้ามเงียบ — EC-3)
/// **ห้ามสร้างในเทสต์** (ไม่มี platform channel) — เทสต์ใช้ fake ที่ implement [VoiceTtsEngine]
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'voice_logic.dart';
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

  static bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<bool> prepare() async {
    try {
      if (_isAndroid) {
        if (!await _prepareAndroidOfflineThai()) return false;
      } else {
        // iOS: voice ของระบบอยู่ในเครื่อง — isLanguageAvailable พอ (BUG-VOICE-1 ผลที่คาด)
        final available =
            await _tts.isLanguageAvailable(VoiceRules.ttsLanguage);
        if (available != true) return false;
        await _tts.setLanguage(VoiceRules.ttsLanguage);
      }
      await _tts.setPitch(VoiceRules.ttsPitch);
      await _tts.setVolume(VoiceRules.defaultAudioVolumeGain);
      // speak() รอจนพูดจบ → คิวเล่นทีละบท (EC-2)
      await _tts.awaitSpeakCompletion(true);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// DECIDED (owner 2026-11-12, V-6a / BUG-VOICE-1): บน Android `isLanguageAvailable` คืน true ได้
  /// แม้มีแต่ voice ที่ต้องใช้เน็ต (server voice ของ Google TTS) จึงต้อง
  /// 1. `isLanguageInstalled('th-TH') == true` (plugin เช็ก voice locale ตรง + ไม่ต้องใช้เน็ต +
  ///    ติดตั้งแล้ว)
  /// 2. เลือก voice ไทยที่ `network_required == "0"` จาก `getVoices` แล้ว `setVoice` ระบุตัว
  ///    (ไม่ปล่อยให้ engine เลือก voice เริ่มต้นเอง ซึ่งอาจเป็น server voice)
  /// ไม่ผ่านข้อใด → false (ข้ามเงียบ)
  Future<bool> _prepareAndroidOfflineThai() async {
    final installed = await _tts.isLanguageInstalled(VoiceRules.ttsLanguage);
    if (installed != true) return false;
    final voice = VoiceLogic.pickOfflineThaiVoice(await _tts.getVoices);
    if (voice == null) return false;
    // setLanguage ก่อน (engine อาจเลือก voice เริ่มต้นของภาษา) แล้ว setVoice ทับด้วยตัวในเครื่อง
    await _tts.setLanguage(VoiceRules.ttsLanguage);
    final set = await _tts.setVoice(voice);
    // plugin คืน 1 = ตั้งสำเร็จ, 0 = ไม่พบ voice
    // ASSUMPTION: BUG-VOICE-1 — ค่าอื่นที่ไม่ใช่ 1 ถือว่าไม่สำเร็จ (ปลอดภัยไว้ก่อน)
    return set == 1;
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
