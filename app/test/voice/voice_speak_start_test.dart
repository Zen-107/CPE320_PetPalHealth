// ฟองบทพูดขึ้นพร้อมเสียง + เตรียม engine ล่วงหน้า (แก้อาการข้อความขึ้นก่อนเสียง 5–6 วินาที)
// engine ที่ implement VoiceSpeakStartAware → ฟองรอสัญญาณเสียงเริ่ม · engine อื่น → ฟองขึ้นทันที
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/voice/voice_controller.dart';
import 'package:petpal_health/features/voice/voice_models.dart';
import 'package:petpal_health/features/voice/voice_repository.dart';
import 'package:petpal_health/features/voice/voice_tts_engine.dart';

import 'fake_voice_tts_engine.dart';

DateTime t(int day, int h, [int m = 0]) => DateTime(2026, 11, day, h, m);

Future<void> flush() async {
  for (var i = 0; i < 10; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

/// fake ที่แยกจังหวะ "สั่งพูด" ออกจาก "เสียงเริ่ม" — เทสต์เรียก [startSound] เอง
class StartAwareFakeEngine extends FakeVoiceTtsEngine
    implements VoiceSpeakStartAware {
  StartAwareFakeEngine() : super(autoComplete: false);

  void Function()? _onStart;

  @override
  set onSpeakStart(void Function()? callback) => _onStart = callback;

  bool get hasStartListener => _onStart != null;

  void startSound() => _onStart?.call();
}

/// fake ที่อุ่นเครื่องได้ — นับจำนวนครั้งและลำดับเทียบกับ prepare()
class PrimerFakeEngine extends FakeVoiceTtsEngine implements VoiceEnginePrimer {
  PrimerFakeEngine({super.available, this.throwOnPrime = false});

  bool throwOnPrime;
  int primeCount = 0;
  int prepareCountAtPrime = 0;

  @override
  Future<void> prime() async {
    primeCount++;
    prepareCountAtPrime = prepareCount;
    if (throwOnPrime) throw StateError('prime failed');
  }
}

VoiceController make(
  FakeVoiceTtsEngine engine, {
  bool master = true,
}) =>
    VoiceController(
      repository: InMemoryVoiceRepository(VoiceState(
          permissionStatus: VoicePermissionStatus.on, masterVoice: master)),
      engine: engine,
      clock: () => t(12, 10),
    );

void main() {
  group('bubble follows sound start', () {
    test('start-aware engine: no bubble until sound starts', () async {
      final e = StartAwareFakeEngine();
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e.spoken.length, 1, reason: 'สั่งพูดแล้ว');
      expect(c.currentLine, isNull, reason: 'เสียงยังไม่เริ่ม → ยังไม่มีฟอง');

      e.startSound();
      expect(c.currentLine, VoiceLine.waterLow);

      e.completeCurrent();
      await flush();
      expect(c.currentLine, isNull, reason: 'พูดจบ → ฟองหาย');
      expect(e.hasStartListener, isFalse);
      c.dispose();
    });

    test('start-aware engine: each queued line waits for its own start',
        () async {
      final e = StartAwareFakeEngine();
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 8, steps: 10000));
      await flush();
      e.startSound();
      expect(c.currentLine, VoiceLine.waterSuccess);

      e.completeCurrent();
      await flush();
      expect(e.spoken.length, 2);
      expect(c.currentLine, isNull, reason: 'บทที่สองยังไม่มีเสียง');
      e.startSound();
      expect(c.currentLine, VoiceLine.stepsSuccess);

      e.completeCurrent();
      await flush();
      expect(c.currentLine, isNull);
      c.dispose();
    });

    test('start signal after stopAndClear does not show a bubble', () async {
      final e = StartAwareFakeEngine();
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 2));
      await flush();
      final lateStart = e.startSound;
      await c.stopAndClear();
      await flush();
      lateStart();
      expect(c.currentLine, isNull);
      c.dispose();
    });

    test('plain engine keeps showing the bubble immediately', () async {
      final e = FakeVoiceTtsEngine(autoComplete: false);
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(c.currentLine, VoiceLine.waterLow);
      e.completeCurrent();
      await flush();
      expect(c.currentLine, isNull);
      c.dispose();
    });
  });

  group('warmUp', () {
    test('prepares the engine once when voice is on', () async {
      final e = FakeVoiceTtsEngine();
      final c = make(e);
      await c.warmUp();
      expect(e.prepareCount, 1);
      expect(e.spoken, isEmpty, reason: 'warmUp ไม่พูดอะไร');

      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e.prepareCount, 1, reason: 'ไม่ prepare ซ้ำ');
      expect(e.spoken.length, 1);
      c.dispose();
    });

    test('does not touch the engine when voice is off', () async {
      final e = FakeVoiceTtsEngine();
      final c = make(e, master: false);
      await c.warmUp();
      expect(e.prepareCount, 0);
      c.dispose();
    });

    test('unavailable engine at warmUp is retried by the dashboard', () async {
      final e = FakeVoiceTtsEngine(available: false);
      final c = make(e);
      await c.warmUp();
      e.available = true;
      c.retryEngineIfUnavailable();
      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e.prepareCount, 2);
      expect(e.spoken.length, 1);
      c.dispose();
    });
  });

  group('silent prime after prepare', () {
    test('primes once after prepare succeeds, before the first line', () async {
      final e = PrimerFakeEngine();
      final c = make(e);
      await c.warmUp();
      expect(e.primeCount, 1);
      expect(e.prepareCountAtPrime, 1, reason: 'prime หลัง prepare');
      expect(e.spoken, isEmpty, reason: 'prime ไม่นับเป็นบทพูด');

      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e.primeCount, 1, reason: 'ไม่อุ่นเครื่องซ้ำ');
      expect(e.spoken.length, 1);
      c.dispose();
    });

    test('does not prime when prepare fails', () async {
      final e = PrimerFakeEngine(available: false);
      final c = make(e);
      await c.warmUp();
      expect(e.primeCount, 0);
      c.dispose();
    });

    test('prime failure still leaves the engine ready to speak', () async {
      final e = PrimerFakeEngine(throwOnPrime: true);
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e.primeCount, 1);
      expect(e.spoken.length, 1);
      c.dispose();
    });
  });
}
