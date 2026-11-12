// เทสต์พื้นฐานของ Dev (QA จะเขียนเพิ่ม) — voice ui-spec §2.4.3 VT-1..VT-15
// ค่าคาดหวังมาจาก docs/voice/game-rules.md §1, §3 และข้อตัดสิน owner V-4, V-6a
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/voice/voice_controller.dart';
import 'package:petpal_health/features/voice/voice_logic.dart';
import 'package:petpal_health/features/voice/voice_models.dart';
import 'package:petpal_health/features/voice/voice_repository.dart';
import 'package:petpal_health/features/voice/voice_rules.dart';

import '../food/food_test_helpers.dart' show FakeTimers;
import 'fake_voice_tts_engine.dart';

DateTime t(int day, int h, [int m = 0]) => DateTime(2026, 11, day, h, m);

Future<void> flush() async {
  for (var i = 0; i < 10; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

List<VoiceLine> firstEval(int steps, {int goal = 10000}) =>
    VoiceLogic.evaluate(
      input: voiceInput(steps: steps, goal: goal),
      previous: null,
      now: t(12, 10),
    ).lines.where((l) => l.topic == VoiceTopic.steps).toList();

void main() {
  group('VoiceLogic', () {
    test('VT-1 steps bands (goal 10,000)', () {
      expect(firstEval(3499), [VoiceLine.stepsLazy]);
      expect(firstEval(3500), isEmpty);
      expect(firstEval(6999), isEmpty);
      expect(firstEval(7000), [VoiceLine.stepsEncouraging]);
      expect(firstEval(9999), [VoiceLine.stepsEncouraging]);
      expect(firstEval(10000), [VoiceLine.stepsSuccess]);
      expect(firstEval(12500), [VoiceLine.stepsSuccess]);
      expect(firstEval(0), [VoiceLine.stepsLazy]);
      expect(firstEval(5000, goal: 0), [VoiceLine.stepsLazy]);
    });

    test('VT-2 food uses isFoodOverLimit', () {
      expect(VoiceLogic.lineForFood(false), isNull);
      expect(VoiceLogic.lineForFood(true), VoiceLine.foodOvereating);
    });

    test('VT-3 water bands', () {
      expect(VoiceLogic.lineForWater(0), VoiceLine.waterLow);
      expect(VoiceLogic.lineForWater(2), VoiceLine.waterLow);
      expect(VoiceLogic.lineForWater(3), isNull);
      expect(VoiceLogic.lineForWater(7), isNull);
      expect(VoiceLogic.lineForWater(8), VoiceLine.waterSuccess);
      expect(VoiceLogic.lineForWater(12), VoiceLine.waterSuccess);
    });

    test('VT-4/VT-5 same band does not repeat; NONE counts as a band', () {
      final a = VoiceLogic.evaluate(
          input: voiceInput(cups: 2), previous: null, now: t(12, 10));
      expect(a.lines, [VoiceLine.waterLow]);
      final b = VoiceLogic.evaluate(
          input: voiceInput(cups: 2), previous: a.bands, now: t(12, 11));
      expect(b.lines, isEmpty);
      final c = VoiceLogic.evaluate(
          input: voiceInput(cups: 5), previous: b.bands, now: t(12, 12));
      expect(c.lines, isEmpty);
      expect(c.bands.bands[VoiceTopic.water], VoiceRules.noLineBandCode);
      final d = VoiceLogic.evaluate(
          input: voiceInput(cups: 2), previous: c.bands, now: t(12, 13));
      expect(d.lines, [VoiceLine.waterLow]);
    });

    test('VT-6 new logical day (05:00) starts over', () {
      final a = VoiceLogic.evaluate(
          input: voiceInput(cups: 2), previous: null, now: t(12, 10));
      final b = VoiceLogic.evaluate(
          input: voiceInput(cups: 2), previous: a.bands, now: t(13, 4, 59));
      expect(b.lines, isEmpty);
      final c = VoiceLogic.evaluate(
          input: voiceInput(cups: 2), previous: b.bands, now: t(13, 5));
      expect(c.lines, [VoiceLine.waterLow]);
    });

    test('day bands JSON round trip / corrupt = null', () {
      final bands = VoiceDayBands(day: t(12, 0), bands: {
        VoiceTopic.water: 'voice_water_low',
        VoiceTopic.steps: 'NONE',
      });
      expect(VoiceDayBands.fromJsonString(bands.toJsonString()), bands);
      expect(VoiceDayBands.fromJsonString('{oops'), isNull);
      expect(VoiceDayBands.fromJsonString('[1]'), isNull);
    });
  });

  group('VoiceController', () {
    VoiceController make(
      FakeVoiceTtsEngine engine, {
      VoiceRepository? repo,
      bool master = true,
      FakeTimers? timers,
    }) =>
        VoiceController(
          repository: repo ??
              InMemoryVoiceRepository(VoiceState(
                  permissionStatus: VoicePermissionStatus.on,
                  masterVoice: master)),
          engine: engine,
          clock: () => t(12, 10),
          timerFactory: timers?.create,
        );

    test('VT-7 new controller with same repository does not repeat', () async {
      final repo = InMemoryVoiceRepository(const VoiceState(
          permissionStatus: VoicePermissionStatus.on, masterVoice: true));
      final e1 = FakeVoiceTtsEngine();
      final c1 = make(e1, repo: repo);
      await c1.load();
      c1.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e1.spoken, [VoiceRules.waterLowText]);
      final e2 = FakeVoiceTtsEngine();
      final c2 = make(e2, repo: repo);
      await c2.load();
      c2.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e2.spoken, isEmpty);
    });

    test('VT-8 FIFO water → steps, one at a time', () async {
      final e = FakeVoiceTtsEngine(autoComplete: false);
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 8, steps: 10000));
      await flush();
      expect(c.currentLine, VoiceLine.waterSuccess);
      expect(c.queue, [VoiceLine.stepsSuccess]);
      expect(e.spoken, [VoiceRules.waterSuccessText]);
      e.completeCurrent();
      await flush();
      expect(c.currentLine, VoiceLine.stepsSuccess);
      expect(e.maxActive, 1);
      e.completeCurrent();
      await flush();
      expect(c.currentLine, isNull);
      expect(e.spoken,
          [VoiceRules.waterSuccessText, VoiceRules.stepsSuccessText]);
    });

    test('VT-9 master off: no speak but bands recorded', () async {
      final e = FakeVoiceTtsEngine();
      final c = make(e, master: false);
      await c.load();
      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e.spoken, isEmpty);
      expect(c.dayBands!.bands[VoiceTopic.water], 'voice_water_low');
      c.answerPermission(enabled: true);
      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e.spoken, isEmpty);
    });

    test('VT-10 switching off while speaking stops and clears', () async {
      final e = FakeVoiceTtsEngine(autoComplete: false);
      final timers = FakeTimers();
      final c = make(e, timers: timers);
      await c.load();
      c.evaluate(voiceInput(cups: 8, steps: 10000));
      await flush();
      c.setMasterVoice(false);
      await flush();
      expect(e.stopCount, greaterThanOrEqualTo(1));
      expect(c.queue, isEmpty);
      expect(c.currentLine, isNull);
      expect(e.spoken, [VoiceRules.waterSuccessText]);
    });

    test('VT-11 no th-TH voice → silent skip, bands recorded', () async {
      final e = FakeVoiceTtsEngine(available: false);
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 2));
      await flush();
      expect(e.spoken, isEmpty);
      expect(c.currentLine, isNull);
      expect(c.dayBands, isNotNull);
    });

    test('VT-12 speak throws → next line', () async {
      final e = FakeVoiceTtsEngine()..throwOnSpeak = true;
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 8, steps: 10000));
      await flush();
      expect(e.spoken.length, 2);
      expect(c.currentLine, isNull);
    });

    testWidgets('VT-13 speak never completes → timeout 20 s', (tester) async {
      final e = _NeverCompletesEngine();
      final c = make(e);
      await c.load();
      c.evaluate(voiceInput(cups: 8, steps: 10000));
      await tester.pump();
      expect(c.currentLine, VoiceLine.waterSuccess);
      await tester.pump(VoiceRules.speakTimeout);
      await tester.pump();
      expect(c.currentLine, VoiceLine.stepsSuccess);
      await tester.pump(VoiceRules.speakTimeout);
      await tester.pump();
      expect(c.currentLine, isNull);
      c.dispose();
    });

    test('VT-15 debounce: rapid toggles save once with last value', () async {
      final timers = FakeTimers();
      final repo = InMemoryVoiceRepository(const VoiceState(
          permissionStatus: VoicePermissionStatus.on, masterVoice: true));
      final c = make(FakeVoiceTtsEngine(), repo: repo, timers: timers);
      await c.load();
      c.setMasterVoice(false);
      c.setMasterVoice(true);
      c.setMasterVoice(false);
      c.setMasterVoice(true);
      expect(c.masterVoice, isTrue);
      timers.advance(VoiceRules.toggleDebounce);
      await flush();
      expect(repo.saveMasterVoiceCount, 0);
      c.setMasterVoice(false);
      c.setMasterVoice(true);
      c.setMasterVoice(false);
      timers.advance(const Duration(milliseconds: 299));
      await flush();
      expect(repo.saveMasterVoiceCount, 0);
      timers.advance(const Duration(milliseconds: 1));
      await flush();
      expect(repo.savedMasterVoiceValues, [false]);
    });

    test('save failure reverts and bumps saveFailureCount', () async {
      final timers = FakeTimers();
      final repo = ThrowingVoiceRepository(
        state: const VoiceState(
            permissionStatus: VoicePermissionStatus.on, masterVoice: true),
        throwOnSaveMaster: true,
      );
      final c = make(FakeVoiceTtsEngine(), repo: repo, timers: timers);
      await c.load();
      c.setMasterVoice(false);
      timers.advance(VoiceRules.toggleDebounce);
      await flush();
      expect(c.masterVoice, isTrue);
      expect(c.saveFailureCount, 1);
    });

    test('load error → unanswered / false', () async {
      final c = make(FakeVoiceTtsEngine(),
          repo: ThrowingVoiceRepository(throwOnLoad: true));
      await c.load();
      expect(c.isLoaded, isTrue);
      expect(c.permissionStatus, VoicePermissionStatus.unanswered);
      expect(c.masterVoice, isFalse);
    });

    test('answerPermission saves both values, no speak', () async {
      final repo = InMemoryVoiceRepository();
      final e = FakeVoiceTtsEngine();
      final c = make(e, repo: repo);
      await c.load();
      await c.answerPermission(enabled: true);
      expect(repo.state.permissionStatus, VoicePermissionStatus.on);
      expect(repo.state.masterVoice, isTrue);
      expect(e.spoken, isEmpty);
    });
  });
}

class _NeverCompletesEngine extends FakeVoiceTtsEngine {
  @override
  Future<void> speak(String text) {
    spoken.add(text);
    // ไม่ complete เลย (ไม่มี Timer ค้าง)
    return Completer<void>().future;
  }
}
