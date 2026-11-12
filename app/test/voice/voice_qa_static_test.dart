// QA (รอบ 1) — ตรวจโครงโปรเจกต์ตามข้อตัดสิน owner (อ่านไฟล์ ไม่เรียก plugin)
// V-6 ค่า TTS · V-6a ไม่มี network / cloud TTS (EC-4) · V-6b ไม่มี assets/audio/
// V-7 flutter_tts pin เวอร์ชันเดียว + ไม่มี uses-permission ใหม่ · ui-spec §2.4.5 ห้ามสร้าง
// FlutterTtsVoiceEngine ในเทสต์ · ค่าคาดหวังจาก voice_qa_docs.dart (เอกสาร) — รันจากโฟลเดอร์ app/
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/voice/voice_rules.dart';

import 'voice_qa_docs.dart';

String read(String path) =>
    File(path).readAsStringSync().replaceAll('\r\n', '\n');

List<File> dartFilesUnder(String dir) => Directory(dir)
    .listSync(recursive: true)
    .whereType<File>()
    .where((f) => f.path.endsWith('.dart'))
    .toList();

/// ตัดคอมเมนต์ `//` ออก (คอมเมนต์อธิบายเช่น "ห้าม cloud TTS" ไม่ใช่โค้ด)
String codeOnly(String src) => src
    .split('\n')
    .map((l) {
      final i = l.indexOf('//');
      return i < 0 ? l : l.substring(0, i);
    })
    .join('\n');

/// uses-permission ของแอปก่อนฟีเจอร์ voice (main `0c2df47`: notification)
const baselinePermissions = {
  'android.permission.POST_NOTIFICATIONS',
  'android.permission.RECEIVE_BOOT_COMPLETED',
};

void main() {
  group('V-6 TTS settings', () {
    test('DECIDED_V6_tts_language_pitch_volume_values', () {
      expect(VoiceRules.ttsLanguage, docTtsLanguage);
      expect(VoiceRules.ttsPitch, docTtsPitch);
      expect(VoiceRules.defaultAudioVolumeGain, docTtsVolume);
      expect(VoiceRules.toggleDebounce, docDebounce);
    });

    test('DECIDED_V6_engine_applies_th_TH_pitch_volume_in_order_no_speech_rate',
        () {
      final src = codeOnly(read('lib/features/voice/voice_flutter_tts_engine.dart'));
      final avail = src.indexOf('isLanguageAvailable(VoiceRules.ttsLanguage)');
      final lang = src.indexOf('setLanguage(VoiceRules.ttsLanguage)');
      final pitch = src.indexOf('setPitch(VoiceRules.ttsPitch)');
      final vol = src.indexOf('setVolume(VoiceRules.defaultAudioVolumeGain)');
      final await_ = src.indexOf('awaitSpeakCompletion(true)');
      for (final (name, i) in [
        ('isLanguageAvailable', avail),
        ('setLanguage', lang),
        ('setPitch', pitch),
        ('setVolume', vol),
        ('awaitSpeakCompletion', await_),
      ]) {
        expect(i, greaterThanOrEqualTo(0), reason: '$name ต้องถูกเรียก');
      }
      expect(avail < lang && lang < pitch && pitch < vol && vol < await_,
          isTrue,
          reason: 'ui-spec §6: isLanguageAvailable → setLanguage → setPitch → '
              'setVolume → awaitSpeakCompletion');
      expect(src.contains('setSpeechRate'), isFalse, reason: 'Q-21');
      expect(src.contains('setEngine'), isFalse,
          reason: 'ไม่เลือก engine ที่อาจต้องโหลดจากเน็ต (V-6a)');
    });
  });

  group('EC-4 / V-6a offline — ไม่มีโค้ด network / cloud TTS ใน features/voice', () {
    final banned = <String, RegExp>{
      'http(s) URL': RegExp(r'''['"]https?:'''),
      'package:http': RegExp(r'package:http/'),
      'package:dio': RegExp(r'package:dio/'),
      'HttpClient': RegExp(r'\bHttpClient\b'),
      'Socket': RegExp(r'\b(Raw)?Socket\b'),
      'WebSocket': RegExp(r'WebSocket'),
      'dart:io': RegExp(r'''import\s+['"]dart:io['"]'''),
      'cloud TTS SDK': RegExp(
          r'google_cloud|cloud_text_to_speech|googleapis|aws_polly|azure',
          caseSensitive: false),
      'Uri network': RegExp(r'Uri\.(https?|parse)\('),
    };
    test('EC4_DECIDED_V6a_no_network_code_in_features_voice', () {
      final files = dartFilesUnder('lib/features/voice');
      expect(files, isNotEmpty);
      final hits = <String>[];
      for (final f in files) {
        final src = codeOnly(f.readAsStringSync());
        banned.forEach((name, re) {
          if (re.hasMatch(src)) hits.add('${f.path}: $name');
        });
      }
      expect(hits, isEmpty);
    });

    test('EC4_DECIDED_V7_no_new_network_package_in_pubspec', () {
      final pub = read('pubspec.yaml');
      for (final p in ['http:', 'dio:', 'web_socket_channel:', 'googleapis:']) {
        expect(RegExp('^\\s+${RegExp.escape(p)}', multiLine: true).hasMatch(pub),
            isFalse,
            reason: p);
      }
    });

    test('DECIDED_V6a_voice_logic_is_pure_no_flutter_plugin_prefs', () {
      final src = read('lib/features/voice/voice_logic.dart');
      for (final banned in [
        'package:flutter/',
        'package:flutter_tts',
        'package:shared_preferences',
      ]) {
        expect(src.contains(banned), isFalse, reason: banned);
      }
    });
  });

  group('V-6b ไม่มี assets/audio', () {
    test('DECIDED_V6b_no_assets_audio_folder_no_mp3_files', () {
      expect(Directory('assets/audio').existsSync(), isFalse);
      // สแกนเฉพาะโฟลเดอร์ต้นฉบับ (build/ .dart_tool/ เป็นไฟล์ generated)
      final mp3 = <String>[];
      for (final dir in ['lib', 'test', 'assets', 'android/app/src', 'web']) {
        final d = Directory(dir);
        if (!d.existsSync()) continue;
        mp3.addAll(d
            .listSync(recursive: true, followLinks: false)
            .whereType<File>()
            .where((f) => f.path.toLowerCase().endsWith('.mp3'))
            .map((f) => f.path));
      }
      expect(mp3, isEmpty);
    });

    test('DECIDED_V6b_pubspec_has_no_audio_asset_entry', () {
      final pub = read('pubspec.yaml');
      expect(pub.contains('assets/audio'), isFalse);
    });

    test('DECIDED_V1_no_png_or_asset_image_in_voice_code', () {
      final hits = <String>[];
      for (final f in dartFilesUnder('lib/features/voice')) {
        final src = codeOnly(f.readAsStringSync());
        for (final b in [
          'Image.asset',
          'AssetImage',
          'pet_avatar_dialog.png',
          'pet_avatar_happy.png',
          'icon_settings_gear.png',
          '.mp3',
        ]) {
          if (src.contains(b)) hits.add('${f.path}: $b');
        }
      }
      expect(hits, isEmpty);
    });
  });

  group('V-7 package + Android', () {
    test('DECIDED_V7_flutter_tts_pinned_single_exact_version', () {
      final pub = read('pubspec.yaml');
      final lines = RegExp(r'^\s+flutter_tts:\s*(.*)$', multiLine: true)
          .allMatches(pub)
          .toList();
      expect(lines.length, 1, reason: 'ประกาศครั้งเดียว');
      final spec = lines.single.group(1)!.trim();
      expect(RegExp(r'^\d+\.\d+\.\d+$').hasMatch(spec), isTrue,
          reason: 'pin แบบไม่มี ^ / ~ / ช่วง — ได้ "$spec"');
      expect(spec, docFlutterTtsVersion);
      // lock ต้องตรงกัน
      final lock = read('pubspec.lock');
      final m = RegExp(r'\n  flutter_tts:\n(?:    .*\n)*?    version: "([^"]+)"')
          .firstMatch(lock);
      expect(m, isNotNull);
      expect(m!.group(1), spec);
    });

    test('DECIDED_V7_no_new_uses_permission_in_manifest', () {
      final xml = read('android/app/src/main/AndroidManifest.xml');
      final perms = RegExp(r'<uses-permission[^>]*android:name="([^"]+)"')
          .allMatches(xml)
          .map((m) => m.group(1)!)
          .toSet();
      expect(perms, baselinePermissions);
      expect(perms.contains('android.permission.INTERNET'), isFalse);
      expect(perms.contains('android.permission.RECORD_AUDIO'), isFalse);
    });

    test('DECIDED_V7_tts_service_query_intent_inside_queries', () {
      final xml = read('android/app/src/main/AndroidManifest.xml');
      final q = RegExp(r'<queries>([\s\S]*?)</queries>').firstMatch(xml);
      expect(q, isNotNull);
      expect(q!.group(1)!.contains('android.intent.action.TTS_SERVICE'), isTrue);
      expect(RegExp('<queries>').allMatches(xml).length, 1);
    });
  });

  group('ui-spec §2.4.5 fake engine only in tests', () {
    test('NO_FlutterTtsVoiceEngine_constructed_in_any_test', () {
      // สร้าง pattern แบบต่อสตริง เพื่อไม่ให้ไฟล์นี้จับตัวเอง
      final ctor = RegExp('FlutterTts' 'VoiceEngine\\s*\\(');
      final rawTts = RegExp('FlutterTts' '\\s*\\(\\)');
      // DECIDED (owner 2026-11-12, รอบ 2): ยกเว้นไฟล์เดียวที่ mock MethodChannel('flutter_tts')
      // (ไม่มี plugin จริงทำงาน) — ไฟล์อื่นยังห้ามเหมือนเดิม
      const r2Allowed = 'voice_qa_r2_engine_channel_test.dart';
      final hits = <String>[];
      for (final f in dartFilesUnder('test')) {
        if (f.uri.pathSegments.last == r2Allowed) continue;
        final src = codeOnly(f.readAsStringSync());
        if (ctor.hasMatch(src) || rawTts.hasMatch(src)) hits.add(f.path);
      }
      expect(hits, isEmpty);
    });
  });
}
