// QA (รอบ 2) — re-check BUG-VOICE-1: ลำดับการเรียกใน FlutterTtsVoiceEngine.prepare()
//
// DECIDED (owner 2026-11-12, รอบ 2): อนุญาตสร้าง FlutterTtsVoiceEngine ในไฟล์นี้เท่านั้น โดย mock
// `MethodChannel('flutter_tts')` ผ่าน TestDefaultBinaryMessengerBinding +
// `debugDefaultTargetPlatformOverride` — ข้อยกเว้นของ ui-spec §2.4.5 (ไม่มี plugin จริงทำงาน)
//
// ค่าคาดหวังมาจากเอกสาร / ข้อตัดสิน ไม่ใช่จากโค้ด:
// - V-6: ภาษา th-TH · pitch 1.5 · volume 0.80 (voice_qa_docs.dart)
// - V-6a: engine ในเครื่องเท่านั้น ห้าม cloud · ไม่มีเสียงไทยในเครื่อง / error → ข้ามเงียบ ไม่แครช
// - ui-spec §2.4.5: speak() "Future จบเมื่อพูดเสร็จ" → ต้องเปิด awaitSpeakCompletion(true)
// - BUG-VOICE-1 (owner): Android ต้องไม่เชื่อ isLanguageAvailable อย่างเดียว
// - ชื่อ method / รูปแบบ map: API สาธารณะของ flutter_tts 4.2.5 (Dart: isLanguageInstalled,
//   getVoices, setVoice(Map name/locale) คืน 1/0 · Android readVoiceProperties: network_required "1"/"0")
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/voice/voice_flutter_tts_engine.dart';

import 'voice_qa_docs.dart';

const _channel = MethodChannel('flutter_tts');

/// voice map ตามรูปแบบ Android ของ flutter_tts (readVoiceProperties)
Map<String, String> _voice(String name, String locale, String networkRequired,
        {String features = ''}) =>
    {
      'name': name,
      'locale': locale,
      'quality': 'normal',
      'latency': 'normal',
      'network_required': networkRequired,
      'features': features,
    };

/// platform channel ปลอม — จดทุก call ตามลำดับ · ตอบตาม [responses] · method ใน [throwOn] → PlatformException
class _FakeTtsChannel {
  _FakeTtsChannel(this.responses, {this.throwOn = const {}});

  final Map<String, Object?> responses;
  final Set<String> throwOn;
  final List<MethodCall> calls = [];

  List<String> get methods => calls.map((c) => c.method).toList();

  Object? argOf(String method) =>
      calls.firstWhere((c) => c.method == method).arguments;

  Future<Object?> handle(MethodCall call) async {
    calls.add(call);
    if (throwOn.contains(call.method)) {
      throw PlatformException(code: 'TTS_ERROR', message: call.method);
    }
    // method ที่ไม่ได้ระบุ → 1 (ค่าสำเร็จของ plugin) เพื่อไม่ให้กลายเป็น MissingPluginException
    return responses.containsKey(call.method) ? responses[call.method] : 1;
  }
}

/// Android เครื่องที่มีเสียงไทยออฟไลน์พร้อม (กรณีควรพูด)
Map<String, Object?> _androidReady({Object? voices, Object? setVoice = 1}) => {
      'isLanguageInstalled': true,
      'isLanguageAvailable': true,
      'getVoices': voices ??
          [
            _voice('th-th-x-mol-network', 'th-TH', '1'),
            _voice('th-th-x-mol-local', 'th-TH', '0'),
            _voice('en-us-x-sfg-local', 'en-US', '0'),
          ],
      'setVoice': setVoice,
    };

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late _FakeTtsChannel fake;

  void install(_FakeTtsChannel f) {
    fake = f;
    messenger.setMockMethodCallHandler(_channel, f.handle);
  }

  tearDown(() {
    messenger.setMockMethodCallHandler(_channel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  group('DECIDED_R2 Android prepare() (BUG-VOICE-1 / V-6a)', () {
    setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.android);

    test('DECIDED_R2_android_not_installed_returns_false_no_setVoice_no_speak',
        () async {
      // BUG-VOICE-1: isLanguageAvailable true แต่ไม่มี voice ไทยในเครื่อง
      install(_FakeTtsChannel({
        ..._androidReady(),
        'isLanguageInstalled': false,
      }));
      final ok = await FlutterTtsVoiceEngine().prepare();
      expect(ok, isFalse);
      expect(fake.methods, contains('isLanguageInstalled'));
      expect(fake.argOf('isLanguageInstalled'), docTtsLanguage);
      expect(fake.methods, isNot(contains('setVoice')));
      expect(fake.methods, isNot(contains('speak')));
    });

    test('DECIDED_R2_android_isLanguageAvailable_true_alone_is_not_enough',
        () async {
      // อาการที่ owner พบ: Available = true, Installed = false → ต้องไม่พร้อมพูด
      install(_FakeTtsChannel({
        'isLanguageAvailable': true,
        'isLanguageInstalled': false,
        'getVoices': [_voice('th-th-x-mol-network', 'th-TH', '1')],
      }));
      expect(await FlutterTtsVoiceEngine().prepare(), isFalse);
      expect(fake.methods, isNot(contains('setPitch')));
      expect(fake.methods, isNot(contains('awaitSpeakCompletion')));
    });

    test('DECIDED_R2_android_installed_but_only_network_voices_returns_false',
        () async {
      install(_FakeTtsChannel(_androidReady(voices: [
        _voice('th-th-x-mol-network', 'th-TH', '1'),
        _voice('th-th-x-tha-network', 'th-TH', '1'),
        _voice('en-us-x-sfg-local', 'en-US', '0'),
      ])));
      expect(await FlutterTtsVoiceEngine().prepare(), isFalse);
      expect(fake.methods, contains('getVoices'));
      expect(fake.methods, isNot(contains('setVoice')));
      expect(fake.methods, isNot(contains('speak')));
    });

    test('DECIDED_R2_android_offline_thai_voice_full_sequence_returns_true',
        () async {
      install(_FakeTtsChannel(_androidReady()));
      final ok = await FlutterTtsVoiceEngine().prepare();
      expect(ok, isTrue);

      final m = fake.methods;
      // ลำดับ: ตรวจในเครื่อง → รายชื่อ voice → ตั้งภาษา → ตั้ง voice ระบุตัว
      expect(m.indexOf('isLanguageInstalled'), greaterThanOrEqualTo(0));
      expect(m.indexOf('getVoices'), greaterThan(m.indexOf('isLanguageInstalled')));
      expect(m.indexOf('setLanguage'), greaterThan(m.indexOf('getVoices')));
      expect(m.indexOf('setVoice'), greaterThan(m.indexOf('setLanguage')));
      // V-6: ภาษา / pitch / volume
      expect(fake.argOf('setLanguage'), docTtsLanguage);
      expect(fake.argOf('setVoice'),
          {'name': 'th-th-x-mol-local', 'locale': docTtsLanguage});
      expect(fake.argOf('setPitch'), docTtsPitch);
      expect(fake.argOf('setVolume'), docTtsVolume);
      // ui-spec §2.4.5: speak รอจนพูดจบ
      expect(fake.argOf('awaitSpeakCompletion'), isTrue);
      // ไม่มี setLanguage ซ้ำหลัง setVoice (จะทำให้ engine เลือก voice เริ่มต้นใหม่ซึ่งอาจเป็น server)
      expect(m.lastIndexOf('setLanguage'), lessThan(m.indexOf('setVoice')));
      expect(m, isNot(contains('clearVoice')));
      expect(m, isNot(contains('speak')));
      expect(m.where((x) => x == 'setVoice').length, 1);
    });

    test('DECIDED_R2_android_network_voice_listed_first_still_picks_local',
        () async {
      install(_FakeTtsChannel(_androidReady(voices: [
        _voice('th-th-x-tha-network', 'th-TH', '1'),
        _voice('th-th-x-mol-network', 'th-TH', '1'),
        _voice('th-th-x-tha-local', 'th-TH', '0'),
      ])));
      expect(await FlutterTtsVoiceEngine().prepare(), isTrue);
      expect((fake.argOf('setVoice') as Map)['name'], 'th-th-x-tha-local');
    });

    test('DECIDED_R2_android_setVoice_returns_0_returns_false', () async {
      install(_FakeTtsChannel(_androidReady(setVoice: 0)));
      expect(await FlutterTtsVoiceEngine().prepare(), isFalse);
      expect(fake.methods, contains('setVoice'));
      expect(fake.methods, isNot(contains('speak')));
    });

    test('DECIDED_R2_android_setVoice_returns_null_returns_false', () async {
      install(_FakeTtsChannel(_androidReady(setVoice: null)));
      expect(await FlutterTtsVoiceEngine().prepare(), isFalse);
    });

    test('DECIDED_R2_android_isLanguageInstalled_non_bool_returns_false',
        () async {
      // ค่าเกณฑ์: ต้องเป็น true เท่านั้น (null / 1 / "true" ไม่นับ)
      for (final v in <Object?>[null, 1, 'true']) {
        install(_FakeTtsChannel({..._androidReady(), 'isLanguageInstalled': v}));
        expect(await FlutterTtsVoiceEngine().prepare(), isFalse,
            reason: 'isLanguageInstalled = $v');
        expect(fake.methods, isNot(contains('setVoice')));
      }
    });

    test('DECIDED_R2_android_empty_or_missing_voice_list_returns_false',
        () async {
      for (final v in <Object?>[<Object?>[], null, 'corrupt']) {
        install(_FakeTtsChannel({..._androidReady(), 'getVoices': v}));
        expect(await FlutterTtsVoiceEngine().prepare(), isFalse,
            reason: 'getVoices = $v');
        expect(fake.methods, isNot(contains('setVoice')));
      }
    });

    test('DECIDED_R2_android_not_downloaded_thai_voice_returns_false',
        () async {
      install(_FakeTtsChannel(_androidReady(voices: [
        _voice('th-th-x-mol-local', 'th-TH', '0',
            features: 'networkTimeoutMs\tnotInstalled'),
      ])));
      expect(await FlutterTtsVoiceEngine().prepare(), isFalse);
      expect(fake.methods, isNot(contains('setVoice')));
    });

    for (final method in [
      'isLanguageInstalled',
      'getVoices',
      'setLanguage',
      'setVoice',
      'setPitch',
      'setVolume',
      'awaitSpeakCompletion',
    ]) {
      test('DECIDED_R2_android_${method}_throws_returns_false_no_throw',
          () async {
        install(_FakeTtsChannel(_androidReady(), throwOn: {method}));
        // ถ้า prepare() throw ออกมา เทสต์จะล้มเอง → ผ่าน = ไม่ throw
        final ok = await FlutterTtsVoiceEngine().prepare();
        expect(ok, isFalse);
        expect(fake.methods, contains(method));
        expect(fake.methods, isNot(contains('speak')));
      });
    }

    test('DECIDED_R2_android_no_plugin_handler_returns_false_no_throw',
        () async {
      // ไม่มี handler → MissingPluginException
      messenger.setMockMethodCallHandler(_channel, null);
      expect(await FlutterTtsVoiceEngine().prepare(), isFalse);
    });

    test('DECIDED_R2_android_speak_sends_exact_string_after_prepare',
        () async {
      install(_FakeTtsChannel(_androidReady()));
      final engine = FlutterTtsVoiceEngine();
      expect(await engine.prepare(), isTrue);
      await engine.speak(docWaterLow);
      final arg = fake.argOf('speak');
      final text = arg is Map ? arg['text'] : arg;
      expect(text, docWaterLow);
      // หลัง setVoice ต้องไม่มีการเปลี่ยนภาษา / voice ก่อนพูด
      final m = fake.methods;
      final between = m.sublist(m.indexOf('setVoice') + 1, m.indexOf('speak'));
      expect(between, isNot(contains('setLanguage')));
      expect(between, isNot(contains('clearVoice')));
    });
  });

  group('DECIDED_R2 iOS prepare()', () {
    setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.iOS);

    test('DECIDED_R2_ios_uses_isLanguageAvailable_true_returns_true', () async {
      install(_FakeTtsChannel({'isLanguageAvailable': true}));
      expect(await FlutterTtsVoiceEngine().prepare(), isTrue);
      expect(fake.argOf('isLanguageAvailable'), docTtsLanguage);
      expect(fake.methods, isNot(contains('isLanguageInstalled')));
      expect(fake.argOf('setLanguage'), docTtsLanguage);
      expect(fake.argOf('setPitch'), docTtsPitch);
      expect(fake.argOf('setVolume'), docTtsVolume);
      expect(fake.argOf('awaitSpeakCompletion'), isTrue);
      expect(fake.methods, isNot(contains('speak')));
    });

    test('DECIDED_R2_ios_isLanguageAvailable_false_returns_false', () async {
      install(_FakeTtsChannel({'isLanguageAvailable': false}));
      expect(await FlutterTtsVoiceEngine().prepare(), isFalse);
      expect(fake.methods, isNot(contains('setLanguage')));
      expect(fake.methods, isNot(contains('setPitch')));
    });

    test('DECIDED_R2_ios_throw_returns_false_no_throw', () async {
      install(_FakeTtsChannel({'isLanguageAvailable': true},
          throwOn: {'isLanguageAvailable'}));
      expect(await FlutterTtsVoiceEngine().prepare(), isFalse);
    });
  });

  group('DECIDED_R2 platform gate', () {
    test('DECIDED_R2_isSupportedPlatform_android_ios_only', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(FlutterTtsVoiceEngine.isSupportedPlatform, isTrue);
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(FlutterTtsVoiceEngine.isSupportedPlatform, isTrue);
      for (final p in [
        TargetPlatform.windows,
        TargetPlatform.macOS,
        TargetPlatform.linux,
        TargetPlatform.fuchsia,
      ]) {
        debugDefaultTargetPlatformOverride = p;
        expect(FlutterTtsVoiceEngine.isSupportedPlatform, isFalse,
            reason: '$p');
      }
    });
  });
}
