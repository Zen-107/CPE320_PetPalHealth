// เทสต์พื้นฐานของ Dev (QA จะเขียนเพิ่ม) — voice ui-spec §2.1–§2.3
// FlutterTtsVoiceEngine ไม่ถูกสร้าง — ใช้ FakeVoiceTtsEngine
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/dashboard/screens/dashboard_screen.dart';
import 'package:petpal_health/features/notification/notification_models.dart';
import 'package:petpal_health/features/notification/screens/notification_settings_screen.dart';
import 'package:petpal_health/features/voice/voice_controller.dart';
import 'package:petpal_health/features/voice/voice_models.dart';
import 'package:petpal_health/features/voice/voice_repository.dart';
import 'package:petpal_health/features/voice/voice_rules.dart';
import 'package:petpal_health/features/water/screens/water_home_screen.dart';
import 'package:petpal_health/features/water/water_controller.dart';
import 'package:petpal_health/features/water/water_models.dart';
import 'package:petpal_health/features/water/water_repository.dart';

import '../dashboard/dashboard_test_helpers.dart' hide t;
import '../notification/notification_test_helpers.dart' show makeHarness;
import 'fake_voice_tts_engine.dart';

const dialogTitle =
    'ให้น้องอ๊บส่งเสียงทักทายและคอยเป็นกำลังใจให้คุณทุกวันไหมคะ?';
const masterLabel = 'เปิด/ปิดเสียงพากย์น้องอ๊บ (Master Voice)';

VoiceController voiceOf(VoiceRepository repo, FakeVoiceTtsEngine engine,
        DateTime Function() clock) =>
    VoiceController(repository: repo, engine: engine, clock: clock);

void main() {
  DateTime clock() => DateTime(2026, 10, 14, 10);

  group('S-1 dialog', () {
    testWidgets('shows on Home when unanswered (no notification) and saves',
        (tester) async {
      final repo = InMemoryVoiceRepository();
      final voice = voiceOf(repo, FakeVoiceTtsEngine(), clock);
      final water = WaterController(
          repository: InMemoryWaterRepository(WaterState.initial),
          clock: clock);
      await tester.pumpWidget(MaterialApp(
        home: WaterHomeScreen(controller: water, voiceController: voice),
      ));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('voice_permission_dialog')), findsOneWidget);
      expect(find.text(dialogTitle), findsOneWidget);
      await tester.tap(find.byKey(const Key('voice_permission_enable_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('voice_permission_dialog')), findsNothing);
      expect(repo.state.permissionStatus, VoicePermissionStatus.on);
      expect(repo.state.masterVoice, isTrue);
      expect(repo.savePermissionCount, 1);
    });

    testWidgets('not shown when already answered', (tester) async {
      final repo = InMemoryVoiceRepository(const VoiceState(
          permissionStatus: VoicePermissionStatus.off));
      final voice = voiceOf(repo, FakeVoiceTtsEngine(), clock);
      final water = WaterController(
          repository: InMemoryWaterRepository(WaterState.initial),
          clock: clock);
      await tester.pumpWidget(MaterialApp(
        home: WaterHomeScreen(controller: water, voiceController: voice),
      ));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('voice_permission_dialog')), findsNothing);
    });

    testWidgets('waits for notification consent card first', (tester) async {
      final h = makeHarness(clock: clock);
      final s = h.sources;
      final notification = h.controller;
      final voice = voiceOf(InMemoryVoiceRepository(), FakeVoiceTtsEngine(), clock);
      await tester.pumpWidget(MaterialApp(
        home: WaterHomeScreen(
          controller: s.water,
          stepsController: s.steps,
          foodController: s.food,
          notificationController: notification,
          voiceController: voice,
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('notification_consent_card')), findsOneWidget);
      expect(find.byKey(const Key('voice_permission_dialog')), findsNothing);
      await tester.tap(find.byKey(const Key('notification_consent_deny_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('notification_consent_card')), findsNothing);
      expect(find.byKey(const Key('voice_permission_dialog')), findsOneWidget);
    });
  });

  group('S-2 dashboard', () {
    testWidgets('speech bubble replaces alert while speaking', (tester) async {
      final s = makeSources(
          clock: clock, water: water14(2), steps: steps14(4000), food: food14(0));
      await s.loadAll();
      final engine = FakeVoiceTtsEngine(autoComplete: false);
      final voice = voiceOf(
          InMemoryVoiceRepository(const VoiceState(
              permissionStatus: VoicePermissionStatus.on, masterVoice: true)),
          engine,
          clock);
      await tester.pumpWidget(MaterialApp(
        home: DashboardScreen(
          waterController: s.water,
          stepsController: s.steps,
          foodController: s.food,
          voiceController: voice,
        ),
      ));
      await tester.pump();
      await tester.pump();
      expect(find.byKey(const Key('voice_speech_bubble')), findsOneWidget);
      expect(find.text(VoiceRules.waterLowText), findsOneWidget);
      expect(find.byKey(const Key('dashboard_alert_banner')), findsNothing);
      expect(
          find.descendant(
              of: find.byKey(const Key('dashboard_alert_slot')),
              matching: find.byKey(const Key('voice_speech_text'))),
          findsOneWidget);
      engine.completeCurrent();
      await tester.pump();
      await tester.pump();
      expect(find.byKey(const Key('voice_speech_bubble')), findsNothing);
      expect(find.byKey(const Key('dashboard_alert_banner')), findsOneWidget);
      // pop dashboard → stop
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      expect(engine.stopCount, greaterThanOrEqualTo(1));
      expect(voice.currentLine, isNull);
    });

    testWidgets('voice null = no bubble', (tester) async {
      final s = makeSources(
          clock: clock, water: water14(2), steps: steps14(4000), food: food14(0));
      await s.loadAll();
      await tester.pumpWidget(MaterialApp(
        home: DashboardScreen(
          waterController: s.water,
          stepsController: s.steps,
          foodController: s.food,
        ),
      ));
      await tester.pump();
      expect(find.byKey(const Key('voice_speech_bubble')), findsNothing);
    });
  });

  group('S-3 settings', () {
    Future<(VoiceController, InMemoryVoiceRepository)> pumpSettings(
      WidgetTester tester, {
      VoiceRepository? repo,
    }) async {
      final notification = makeHarness(
              clock: clock,
              state: const NotificationState(
                  consentStatus: NotificationConsentStatus.allowed))
          .controller;
      await notification.load();
      final r = repo ??
          InMemoryVoiceRepository(const VoiceState(
              permissionStatus: VoicePermissionStatus.on, masterVoice: true));
      final voice = voiceOf(r, FakeVoiceTtsEngine(), clock);
      await tester.pumpWidget(MaterialApp(
        home: NotificationSettingsScreen(
          controller: notification,
          voiceController: voice,
        ),
      ));
      await tester.pumpAndSettle();
      return (voice, r as InMemoryVoiceRepository);
    }

    testWidgets('DECIDED_V2_voice_switch_on_top', (tester) async {
      await pumpSettings(tester);
      expect(find.byType(Switch), findsNWidgets(2));
      expect(find.text(masterLabel), findsOneWidget);
      final voiceTop =
          tester.getRect(find.byKey(const Key('voice_master_switch'))).top;
      final notiTop = tester
          .getRect(find.byKey(const Key('notification_master_switch')))
          .top;
      expect(voiceTop, lessThan(notiTop));
      expect(find.byKey(const Key('push_notification_shortcut_toggle')),
          findsNothing);
    });

    testWidgets('EC-5 rapid toggles save once after 300 ms', (tester) async {
      final (voice, repo) = await pumpSettings(tester);
      final sw = find.byKey(const Key('voice_master_switch'));
      await tester.tap(sw);
      await tester.pump(const Duration(milliseconds: 20));
      await tester.tap(sw);
      await tester.pump(const Duration(milliseconds: 20));
      await tester.tap(sw);
      await tester.pump(const Duration(milliseconds: 20));
      expect(voice.masterVoice, isFalse);
      expect(repo.saveMasterVoiceCount, 0);
      await tester.pump(VoiceRules.toggleDebounce);
      expect(repo.savedMasterVoiceValues, [false]);
    });

    testWidgets('save failure → revert + toast', (tester) async {
      final repo = ThrowingVoiceRepository(
        state: const VoiceState(
            permissionStatus: VoicePermissionStatus.on, masterVoice: true),
        throwOnSaveMaster: true,
      );
      final (voice, _) = await pumpSettings(tester, repo: repo);
      await tester.tap(find.byKey(const Key('voice_master_switch')));
      await tester.pump(VoiceRules.toggleDebounce);
      await tester.pump();
      expect(voice.masterVoice, isTrue);
      expect(find.byKey(const ValueKey('voice_save_error_toast')),
          findsOneWidget);
      expect(find.text(VoiceRules.saveErrorText), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('voice null = one switch', (tester) async {
      final notification = makeHarness(clock: clock).controller;
      await notification.load();
      await tester.pumpWidget(MaterialApp(
        home: NotificationSettingsScreen(controller: notification),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Switch), findsOneWidget);
    });
  });
}
