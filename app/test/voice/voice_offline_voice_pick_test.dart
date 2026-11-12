// เทสต์พื้นฐานของ Dev รอบ 2 (BUG-VOICE-1) — เลือก voice ไทยที่อยู่ในเครื่องเท่านั้น
// DECIDED (owner 2026-11-12, V-6a): ห้าม cloud TTS · รูปแบบ map ตาม flutter_tts 4.2.5 Android
// (name / locale / network_required "0"|"1" / features คั่นด้วย tab)
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/voice/voice_logic.dart';

Map<String, String> v(String name, String locale, String networkRequired,
        {String features = ''}) =>
    {
      'name': name,
      'locale': locale,
      'quality': 'normal',
      'latency': 'normal',
      'network_required': networkRequired,
      'features': features,
    };

void main() {
  group('VoiceLogic.pickOfflineThaiVoice', () {
    test('DECIDED_V6a_picks_only_thai_offline_voice', () {
      final picked = VoiceLogic.pickOfflineThaiVoice([
        v('en-us-x-iog-server', 'en-US', '1'),
        v('th-th-x-mol-network', 'th-TH', '1'),
        v('th-th-x-mol-local', 'th-TH', '0'),
      ]);
      expect(picked, {'name': 'th-th-x-mol-local', 'locale': 'th-TH'});
    });

    test('DECIDED_V6a_only_network_thai_voices_returns_null', () {
      expect(
        VoiceLogic.pickOfflineThaiVoice([
          v('th-th-x-mol-network', 'th-TH', '1'),
          v('th-th-x-tha-network', 'th-TH', '1'),
          v('en-us-x-sfg-local', 'en-US', '0'),
        ]),
        isNull,
      );
    });

    test('DECIDED_V6a_no_thai_voice_returns_null', () {
      expect(
        VoiceLogic.pickOfflineThaiVoice([
          v('en-us-x-iog-server', 'en-US', '1'),
          v('en-us-x-sfg-local', 'en-US', '0'),
          v('ja-jp-x-htm-local', 'ja-JP', '0'),
        ]),
        isNull,
      );
      expect(VoiceLogic.pickOfflineThaiVoice(const []), isNull);
    });

    test('DECIDED_V6a_missing_or_unknown_network_flag_is_not_picked', () {
      expect(
        VoiceLogic.pickOfflineThaiVoice([
          {'name': 'th-a', 'locale': 'th-TH'},
          v('th-b', 'th-TH', ''),
          v('th-c', 'th-TH', 'false'),
        ]),
        isNull,
      );
    });

    test('DECIDED_V6a_not_installed_voice_is_skipped', () {
      expect(
        VoiceLogic.pickOfflineThaiVoice([
          v('th-th-x-mol-local', 'th-TH', '0',
              features: 'networkTimeoutMs\tnotInstalled'),
        ]),
        isNull,
      );
    });

    test('DECIDED_V6a_prefers_exact_th_TH_over_other_thai_locale', () {
      final picked = VoiceLogic.pickOfflineThaiVoice([
        v('th-generic', 'th', '0'),
        v('th-th-x-mol-local', 'th-TH', '0'),
      ]);
      expect(picked, {'name': 'th-th-x-mol-local', 'locale': 'th-TH'});
      expect(
        VoiceLogic.pickOfflineThaiVoice([v('th-generic', 'th', '0')]),
        {'name': 'th-generic', 'locale': 'th'},
      );
    });

    test('DECIDED_V6a_locale_prefix_th_only_not_lookalike', () {
      expect(
        VoiceLogic.pickOfflineThaiVoice([v('thx', 'thx-XX', '0')]),
        isNull,
      );
    });

    test('DECIDED_V6a_malformed_input_returns_null_without_throwing', () {
      expect(VoiceLogic.pickOfflineThaiVoice(null), isNull);
      expect(VoiceLogic.pickOfflineThaiVoice('voices'), isNull);
      expect(
        VoiceLogic.pickOfflineThaiVoice([1, 'x', null, {'name': 5}]),
        isNull,
      );
    });
  });
}
