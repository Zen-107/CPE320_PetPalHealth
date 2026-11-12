// QA (รอบ 1) — widget test ของฟีเจอร์ voice: S-1 dialog, S-2 dashboard (ฟองบทพูด), S-3 หน้าตั้งค่า
// ข้อความคัดลอกตรงตัวจาก ux-flow.md §2 / game-rules.md §1.1 (ไม่รวม `"` และ `[ ]` — ui-spec Q-04)
// ข้อตัดสิน owner V-1..V-10 → ชื่อเทสต์มี DECIDED_ · ห้ามสร้าง FlutterTtsVoiceEngine (ใช้ fake)
// เวลา: clock ที่ส่งให้ทุก controller + tester.pump(Duration) — ไม่ใช้เวลาจริง
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/dashboard/screens/dashboard_screen.dart';
import 'package:petpal_health/features/voice/voice_controller.dart';
import 'package:petpal_health/features/voice/voice_models.dart';
import 'package:petpal_health/features/voice/voice_repository.dart';
import 'package:petpal_health/features/water/screens/water_home_screen.dart';
import 'package:petpal_health/features/water/water_controller.dart';
import 'package:petpal_health/features/water/water_models.dart';
import 'package:petpal_health/features/water/water_repository.dart';
import 'package:petpal_health/main.dart';
import 'package:petpal_health/shared/pet/pet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard/dashboard_test_helpers.dart' as dh;
import '../notification/notification_test_helpers.dart' as nh;
import 'fake_voice_tts_engine.dart';
import 'voice_qa_docs.dart';

Finder k(String key) => find.byKey(Key(key));

Future<void> frames(WidgetTester tester, [int n = 6]) async {
  for (var i = 0; i < n; i++) {
    await tester.pump();
  }
}

/// รอ transition (≤ 300 ms ของ Material) ด้วยเวลาที่ควบคุมได้
Future<void> settle(WidgetTester tester) async {
  await frames(tester);
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await frames(tester, 3);
}

VoiceController voiceWith(VoiceRepository repo, FakeVoiceTtsEngine engine,
        DateTime Function() clock) =>
    VoiceController(repository: repo, engine: engine, clock: clock);

InMemoryVoiceRepository onRepo() => InMemoryVoiceRepository(const VoiceState(
    permissionStatus: VoicePermissionStatus.on, masterVoice: true));

void main() {
  // dashboard helpers: 14 ต.ค. 2026 10:00 · เป้าอาหาร 2,000 kcal (profileOf)
  DateTime clock() => dh.t(14, 10);

  // =========================================================================
  // S-1 First Launch Permission Dialog (AC-1)
  // =========================================================================
  group('S-1 dialog', () {
    Future<WaterController> pumpHome(WidgetTester tester, VoiceController? voice,
        {WaterController? water}) async {
      final w = water ??
          WaterController(
              repository: InMemoryWaterRepository(WaterState.initial),
              clock: clock);
      await tester.pumpWidget(MaterialApp(
        home: WaterHomeScreen(
            controller: w, voiceController: voice, animatePet: false),
      ));
      await settle(tester);
      return w;
    }

    testWidgets('AC1_UX_S1_exact_texts_and_button_types', (tester) async {
      await pumpHome(tester,
          voiceWith(InMemoryVoiceRepository(), FakeVoiceTtsEngine(), clock));
      expect(k('voice_permission_dialog'), findsOneWidget);
      expect(tester.widget<Text>(k('voice_permission_title_text')).data,
          docDialogTitle);
      expect(tester.widget<Text>(k('voice_permission_body_text')).data,
          docDialogBody);
      expect(tester.widget(k('voice_permission_enable_button')),
          isA<FilledButton>());
      expect(tester.widget(k('voice_permission_disable_button')),
          isA<OutlinedButton>());
      expect(
          find.descendant(
              of: k('voice_permission_enable_button'),
              matching: find.text(docEnableLabel)),
          findsOneWidget);
      expect(
          find.descendant(
              of: k('voice_permission_disable_button'),
              matching: find.text(docDisableLabel)),
          findsOneWidget);
    });

    testWidgets('DECIDED_V1_V9_dialog_pet_is_PetCharacter_no_png',
        (tester) async {
      await pumpHome(tester,
          voiceWith(InMemoryVoiceRepository(), FakeVoiceTtsEngine(), clock));
      final pet = find.descendant(
          of: k('voice_permission_pet_image'),
          matching: find.byType(PetCharacter));
      expect(pet, findsOneWidget);
      expect(tester.widget<PetCharacter>(pet).pose, PetPose.dashboardCheerful);
      expect(
          find.descendant(
              of: k('voice_permission_dialog'), matching: find.byType(Image)),
          findsNothing);
    });

    testWidgets('AC1_enable_saves_true_true_closes_not_shown_again',
        (tester) async {
      final repo = InMemoryVoiceRepository();
      final engine = FakeVoiceTtsEngine();
      final water = await pumpHome(tester, voiceWith(repo, engine, clock));
      await tester.tap(k('voice_permission_enable_button'));
      await settle(tester);
      expect(k('voice_permission_dialog'), findsNothing);
      expect(repo.state.permissionStatus, VoicePermissionStatus.on);
      expect(repo.state.masterVoice, isTrue);
      expect(engine.spoken, isEmpty, reason: 'V-4 ไม่พูดบน Home');
      // เปิดแอปใหม่ (controller ใหม่ repository เดิม)
      await tester.pumpWidget(const SizedBox());
      await pumpHome(tester, voiceWith(repo, FakeVoiceTtsEngine(), clock),
          water: water);
      expect(k('voice_permission_dialog'), findsNothing);
    });

    testWidgets('AC1_disable_saves_false_false_closes_not_shown_again',
        (tester) async {
      final repo = InMemoryVoiceRepository();
      await pumpHome(tester, voiceWith(repo, FakeVoiceTtsEngine(), clock));
      await tester.tap(k('voice_permission_disable_button'));
      await settle(tester);
      expect(k('voice_permission_dialog'), findsNothing);
      expect(repo.state.permissionStatus, VoicePermissionStatus.off);
      expect(repo.state.masterVoice, isFalse);
      await tester.pumpWidget(const SizedBox());
      await pumpHome(tester, voiceWith(repo, FakeVoiceTtsEngine(), clock));
      expect(k('voice_permission_dialog'), findsNothing);
    });

    testWidgets('AC1_shared_prefs_persisted_dialog_not_shown_after_restart',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      await pumpHome(tester,
          voiceWith(SharedPrefsVoiceRepository(), FakeVoiceTtsEngine(), clock));
      await tester.tap(k('voice_permission_enable_button'));
      await settle(tester);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.get(keyPermission), true);
      expect(prefs.get(keyMaster), true);
      await tester.pumpWidget(const SizedBox());
      await pumpHome(tester,
          voiceWith(SharedPrefsVoiceRepository(), FakeVoiceTtsEngine(), clock));
      expect(k('voice_permission_dialog'), findsNothing);
    });

    testWidgets('UX_S1_barrier_tap_and_back_do_not_dismiss', (tester) async {
      final repo = InMemoryVoiceRepository();
      await pumpHome(tester, voiceWith(repo, FakeVoiceTtsEngine(), clock));
      await tester.tapAt(const Offset(4, 4));
      await settle(tester);
      expect(k('voice_permission_dialog'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await settle(tester);
      expect(k('voice_permission_dialog'), findsOneWidget);
      expect(repo.savePermissionCount, 0);
    });

    testWidgets('MAXMIN_S1_double_tap_saves_once', (tester) async {
      final repo = InMemoryVoiceRepository();
      await pumpHome(tester, voiceWith(repo, FakeVoiceTtsEngine(), clock));
      await tester.tap(k('voice_permission_enable_button'));
      await tester.pump();
      await tester.tap(k('voice_permission_disable_button'),
          warnIfMissed: false);
      await settle(tester);
      expect(repo.savePermissionCount, 1);
      expect(repo.state.permissionStatus, VoicePermissionStatus.on);
    });

    testWidgets('EMPTY_UX_S1_ERROR_load_throws_dialog_still_shown',
        (tester) async {
      await pumpHome(
          tester,
          voiceWith(ThrowingVoiceRepository(throwOnLoad: true),
              FakeVoiceTtsEngine(), clock));
      expect(k('voice_permission_dialog'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('EMPTY_UX_S1_ERROR_corrupt_prefs_dialog_shown', (tester) async {
      SharedPreferences.setMockInitialValues(
          {keyPermission: 'broken', keyMaster: 'x'});
      await pumpHome(tester,
          voiceWith(SharedPrefsVoiceRepository(), FakeVoiceTtsEngine(), clock));
      expect(k('voice_permission_dialog'), findsOneWidget);
    });

    testWidgets('DECIDED_V5_null_controller_no_dialog_on_home', (tester) async {
      await pumpHome(tester, null);
      expect(k('voice_permission_dialog'), findsNothing);
    });

    testWidgets('DECIDED_V5_PetPalApp_without_voice_no_dialog', (tester) async {
      await tester.pumpWidget(PetPalApp(
        waterController: WaterController(
            repository: InMemoryWaterRepository(WaterState.initial),
            clock: clock),
      ));
      await settle(tester);
      expect(k('voice_permission_dialog'), findsNothing);
    });

    testWidgets('DECIDED_V5_Q17_after_notification_allow_then_voice_dialog',
        (tester) async {
      final x = nh.makeHarness(clock: () => nh.t(nh.today, 7));
      final voice = voiceWith(
          InMemoryVoiceRepository(), FakeVoiceTtsEngine(), () => nh.t(nh.today, 7));
      await tester.pumpWidget(MaterialApp(
        home: WaterHomeScreen(
          controller: x.sources.water,
          stepsController: x.sources.steps,
          foodController: x.sources.food,
          notificationController: x.controller,
          voiceController: voice,
          animatePet: false,
        ),
      ));
      await settle(tester);
      expect(k('notification_consent_card'), findsOneWidget);
      expect(k('voice_permission_dialog'), findsNothing);
      await tester.tap(k('notification_consent_allow_button'));
      await settle(tester);
      expect(k('notification_consent_card'), findsNothing);
      expect(k('voice_permission_dialog'), findsOneWidget,
          reason: 'หลังกล่องขอสิทธิ์ OS จบ dialog เสียงต้องขึ้น');
      expect(find.byType(Dialog), findsOneWidget, reason: 'ไม่มี dialog ซ้อน');
    });
  });

  // =========================================================================
  // S-2 Dashboard — AC-2..AC-7 ฟองบทพูด + เสียง (game-rules §3 ขอบ)
  // =========================================================================
  group('S-2 dashboard', () {
    Future<(FakeVoiceTtsEngine, VoiceController, dh.Sources)> pumpDash(
      WidgetTester tester, {
      int cups = 5,
      int steps = 5000,
      int goal = 10000,
      int kcal = 0,
      bool master = true,
      bool autoComplete = false,
    }) async {
      final s = dh.makeSources(
          clock: clock,
          water: dh.water14(cups),
          steps: dh.steps14(steps, goal: goal),
          food: dh.food14(kcal));
      await s.loadAll();
      final engine = FakeVoiceTtsEngine(autoComplete: autoComplete);
      final voice = voiceWith(
          InMemoryVoiceRepository(VoiceState(
              permissionStatus:
                  master ? VoicePermissionStatus.on : VoicePermissionStatus.off,
              masterVoice: master)),
          engine,
          clock);
      await tester.pumpWidget(MaterialApp(
        home: DashboardScreen(
          waterController: s.water,
          stepsController: s.steps,
          foodController: s.food,
          voiceController: voice,
          animatePet: false,
        ),
      ));
      await frames(tester);
      return (engine, voice, s);
    }

    String? bubbleText(WidgetTester tester) {
      final f = k('voice_speech_text');
      if (f.evaluate().isEmpty) return null;
      return tester.widget<Text>(f).data;
    }

    Future<void> teardown(WidgetTester tester) async {
      await tester.pumpWidget(const SizedBox());
      await frames(tester, 2);
    }

    final speakCases = <(String, int, int, int, String)>[
      // (ชื่อ, cups, steps (goal 10,000), kcal (เป้า 2,000), ข้อความ)
      ('AC2_steps_34.99pct', 5, 3499, 0, docStepsLazy),
      ('AC2_steps_0pct', 5, 0, 0, docStepsLazy),
      ('AC3_steps_70.00pct', 5, 7000, 0, docStepsEncouraging),
      ('AC3_steps_99.99pct', 5, 9999, 0, docStepsEncouraging),
      ('AC4_steps_100.00pct', 5, 10000, 0, docStepsSuccess),
      ('AC4_steps_125pct', 5, 12500, 0, docStepsSuccess),
      // food: target 2,000 + 100 = ขอบ → 2,101 = เกิน 101 kcal (หน่วยเล็กสุดของ int kcal)
      ('AC5_food_excess_101kcal', 5, 5000, dh.docFoodTarget + 101,
          docFoodOvereating),
      ('AC6_water_2', 2, 5000, 0, docWaterLow),
      ('AC6_water_0', 0, 5000, 0, docWaterLow),
      ('AC7_water_8', 8, 5000, 0, docWaterSuccess),
    ];
    for (final (name, cups, steps, kcal, text) in speakCases) {
      testWidgets('${name}_bubble_and_speech_exact', (tester) async {
        final (engine, _, _) =
            await pumpDash(tester, cups: cups, steps: steps, kcal: kcal);
        expect(engine.spoken, [text]);
        expect(bubbleText(tester), text);
        expect(
            find.descendant(
                of: k('dashboard_alert_slot'),
                matching: k('voice_speech_bubble')),
            findsOneWidget);
        expect(k('dashboard_alert_banner'), findsNothing,
            reason: 'หนึ่งเฟรมมีฟองเดียว');
        engine.completeCurrent();
        await frames(tester);
        expect(k('voice_speech_bubble'), findsNothing);
        expect(find.text(text), findsNothing);
        await teardown(tester);
      });
    }

    final silentCases = <(String, int, int, int)>[
      ('GR3_steps_35.00pct', 5, 3500, 0),
      ('GR3_steps_69.99pct', 5, 6999, 0),
      ('GR3_food_excess_exactly_100kcal', 5, 5000, dh.docFoodTarget + 100),
      ('GR3_water_3', 3, 5000, 0),
      ('GR3_water_7', 7, 5000, 0),
    ];
    for (final (name, cups, steps, kcal) in silentCases) {
      testWidgets('${name}_no_trigger_no_bubble', (tester) async {
        final (engine, _, _) =
            await pumpDash(tester, cups: cups, steps: steps, kcal: kcal);
        expect(engine.spoken, isEmpty);
        expect(k('voice_speech_bubble'), findsNothing);
        await teardown(tester);
      });
    }

    testWidgets('DECIDED_V10_Q19_no_food_target_5000kcal_no_food_line',
        (tester) async {
      final s = dh.makeSources(
          clock: clock,
          water: dh.water14(5),
          steps: dh.steps14(5000, goal: 10000),
          food: dh.food14(5000, skipped: true),
          noProfile: true);
      await s.loadAll();
      final engine = FakeVoiceTtsEngine();
      await tester.pumpWidget(MaterialApp(
        home: DashboardScreen(
          waterController: s.water,
          stepsController: s.steps,
          foodController: s.food,
          voiceController: voiceWith(onRepo(), engine, clock),
          animatePet: false,
        ),
      ));
      await frames(tester);
      expect(engine.spoken, isEmpty);
      await teardown(tester);
    });

    testWidgets('AC2_7_master_off_no_speech_no_bubble', (tester) async {
      final (engine, _, _) =
          await pumpDash(tester, cups: 2, steps: 3499, master: false);
      expect(engine.spoken, isEmpty);
      expect(k('voice_speech_bubble'), findsNothing);
      await teardown(tester);
    });

    testWidgets('EC2_VT8_bubble_water_then_steps_fifo', (tester) async {
      final (engine, _, _) = await pumpDash(tester, cups: 8, steps: 10000);
      expect(bubbleText(tester), docWaterSuccess);
      expect(engine.spoken, [docWaterSuccess]);
      engine.completeCurrent();
      await frames(tester);
      expect(bubbleText(tester), docStepsSuccess);
      expect(engine.maxActive, 1);
      engine.completeCurrent();
      await frames(tester);
      expect(bubbleText(tester), isNull);
      await teardown(tester);
    });

    testWidgets('DECIDED_V4_value_change_while_open_speaks_new_band',
        (tester) async {
      final (engine, _, s) =
          await pumpDash(tester, cups: 7, steps: 5000, autoComplete: true);
      expect(engine.spoken, isEmpty);
      await s.water.logWater(); // 7 → 8 แก้ว
      await frames(tester);
      expect(s.water.cups, 8);
      expect(engine.spoken, [docWaterSuccess]);
      await teardown(tester);
    });

    testWidgets('DECIDED_V4_reopen_dashboard_same_values_no_repeat',
        (tester) async {
      final s = dh.makeSources(
          clock: clock,
          water: dh.water14(2),
          steps: dh.steps14(5000, goal: 10000),
          food: dh.food14(0));
      await s.loadAll();
      final engine = FakeVoiceTtsEngine();
      final voice = voiceWith(onRepo(), engine, clock);
      Widget dash() => MaterialApp(
            home: DashboardScreen(
              waterController: s.water,
              stepsController: s.steps,
              foodController: s.food,
              voiceController: voice,
              animatePet: false,
            ),
          );
      await tester.pumpWidget(dash());
      await frames(tester);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(dash());
      await frames(tester);
      // Timer alert 5 วินาที notify ซ้ำ → ต้องไม่พูดซ้ำ
      await tester.pump(const Duration(seconds: 11));
      await frames(tester);
      expect(engine.spoken, [docWaterLow]);
      await teardown(tester);
    });

    testWidgets('DECIDED_V9_Q07_pet_pose_and_position_unchanged_while_speaking',
        (tester) async {
      final (engine, _, _) = await pumpDash(tester, cups: 2);
      expect(k('voice_speech_bubble'), findsOneWidget);
      final rectSpeaking = tester.getRect(find.byKey(PetKeys.character));
      final poseSpeaking =
          tester.widget<PetCharacter>(find.byType(PetCharacter)).pose;
      engine.completeCurrent();
      await frames(tester);
      expect(k('voice_speech_bubble'), findsNothing);
      expect(tester.getRect(find.byKey(PetKeys.character)), rectSpeaking);
      expect(tester.widget<PetCharacter>(find.byType(PetCharacter)).pose,
          poseSpeaking);
      await teardown(tester);
    });

    testWidgets('EC3_DECIDED_V6a_no_thai_voice_dashboard_no_bubble_no_crash',
        (tester) async {
      final s = dh.makeSources(
          clock: clock,
          water: dh.water14(2),
          steps: dh.steps14(3499, goal: 10000),
          food: dh.food14(0));
      await s.loadAll();
      final engine = FakeVoiceTtsEngine(available: false);
      await tester.pumpWidget(MaterialApp(
        home: DashboardScreen(
          waterController: s.water,
          stepsController: s.steps,
          foodController: s.food,
          voiceController: voiceWith(onRepo(), engine, clock),
          animatePet: false,
        ),
      ));
      await frames(tester);
      expect(engine.spoken, isEmpty);
      expect(k('voice_speech_bubble'), findsNothing);
      expect(tester.takeException(), isNull);
      await teardown(tester);
    });

    testWidgets('EC3_speak_throws_dashboard_no_crash_next_line', (tester) async {
      final s = dh.makeSources(
          clock: clock,
          water: dh.water14(8),
          steps: dh.steps14(10000, goal: 10000),
          food: dh.food14(0));
      await s.loadAll();
      final engine = FakeVoiceTtsEngine()..throwOnSpeak = true;
      await tester.pumpWidget(MaterialApp(
        home: DashboardScreen(
          waterController: s.water,
          stepsController: s.steps,
          foodController: s.food,
          voiceController: voiceWith(onRepo(), engine, clock),
          animatePet: false,
        ),
      ));
      await frames(tester);
      expect(engine.spoken, [docWaterSuccess, docStepsSuccess]);
      expect(k('voice_speech_bubble'), findsNothing);
      expect(tester.takeException(), isNull);
      await teardown(tester);
    });

    testWidgets('DECIDED_V10_Q13_app_paused_stops_and_clears', (tester) async {
      final (engine, voice, _) = await pumpDash(tester, cups: 8, steps: 10000);
      expect(voice.currentLine, isNotNull);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await frames(tester);
      expect(voice.currentLine, isNull);
      expect(voice.queue, isEmpty);
      expect(engine.stopCount, greaterThanOrEqualTo(1));
      expect(k('voice_speech_bubble'), findsNothing);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await frames(tester);
      expect(engine.spoken, [docWaterSuccess], reason: 'resume: ช่วงเดิมไม่พูดซ้ำ');
      await teardown(tester);
    });

    testWidgets('DECIDED_V5_null_controller_dashboard_unchanged',
        (tester) async {
      final s = dh.makeSources(
          clock: clock,
          water: dh.water14(2),
          steps: dh.steps14(3499, goal: 10000),
          food: dh.food14(0));
      await s.loadAll();
      await tester.pumpWidget(MaterialApp(
        home: DashboardScreen(
          waterController: s.water,
          stepsController: s.steps,
          foodController: s.food,
          animatePet: false,
        ),
      ));
      await frames(tester);
      expect(k('voice_speech_bubble'), findsNothing);
      expect(find.text(docWaterLow), findsNothing);
      await teardown(tester);
    });
  });

  // =========================================================================
  // S-3 = หน้าตั้งค่าแจ้งเตือนเดิม + สวิตช์เสียง (AC-8, EC-5, V-2, V-3)
  // =========================================================================
  group('S-3 settings via dashboard gear', () {
    DateTime nclock() => nh.t(nh.today, 7);

    Future<(nh.Harness, VoiceController, InMemoryVoiceRepository,
            FakeVoiceTtsEngine)>
        pumpToSettings(WidgetTester tester,
            {InMemoryVoiceRepository? repo,
            bool autoComplete = true,
            int cups = 0}) async {
      final x = nh.makeHarness(
          clock: nclock,
          state: nh.grantedOn,
          water: nh.waterOn(cups, null));
      final r = repo ?? onRepo();
      final engine = FakeVoiceTtsEngine(autoComplete: autoComplete);
      final voice = voiceWith(r, engine, nclock);
      await tester.pumpWidget(MaterialApp(
        home: WaterHomeScreen(
          controller: x.sources.water,
          stepsController: x.sources.steps,
          foodController: x.sources.food,
          notificationController: x.controller,
          voiceController: voice,
          animatePet: false,
        ),
      ));
      await settle(tester);
      await tester.tap(k('dashboard_entry_button'));
      await settle(tester);
      await tester.tap(k('notification_settings_entry_button'));
      await settle(tester);
      return (x, voice, r, engine);
    }

    testWidgets('AC8_DECIDED_V2_two_switches_voice_on_top_exact_labels',
        (tester) async {
      await pumpToSettings(tester);
      expect(find.byType(Switch), findsNWidgets(2));
      expect(tester.widget<Text>(k('voice_master_switch_label')).data,
          docMasterVoiceLabel);
      expect(tester.widget<Text>(k('notification_master_switch_label')).data,
          docNotificationSwitchLabel);
      expect(tester.widget<Text>(k('notification_settings_header_text')).data,
          docSettingsTitle);
      expect(tester.getRect(k('voice_master_switch')).top,
          lessThan(tester.getRect(k('notification_master_switch')).top));
      expect(tester.widget<SwitchListTile>(k('voice_master_switch')).value,
          isTrue);
      expect(k('push_notification_shortcut_toggle'), findsNothing);
    });

    testWidgets('AC8_EC5_voice_switch_toggles_and_saves_after_300ms',
        (tester) async {
      final (_, voice, repo, _) = await pumpToSettings(tester);
      await tester.tap(k('voice_master_switch'));
      await tester.pump();
      expect(tester.widget<SwitchListTile>(k('voice_master_switch')).value,
          isFalse);
      await tester.pump(const Duration(milliseconds: 250));
      expect(repo.saveMasterVoiceCount, 0);
      await tester.pump(docDebounce);
      expect(repo.savedMasterVoiceValues, [false]);
      expect(voice.masterVoice, isFalse);
      // เปิดกลับ
      await tester.tap(k('voice_master_switch'));
      await tester.pump();
      await tester.pump(docDebounce);
      expect(repo.savedMasterVoiceValues, [false, true]);
    });

    testWidgets('AC8_DECIDED_V3_notification_switch_works_no_300ms_debounce',
        (tester) async {
      final (x, _, repo, _) = await pumpToSettings(tester);
      expect(
          tester.widget<SwitchListTile>(k('notification_master_switch')).value,
          isTrue);
      await tester.tap(k('notification_master_switch'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));
      expect(
          tester.widget<SwitchListTile>(k('notification_master_switch')).value,
          isFalse);
      expect(x.mem.state.masterSwitch, isFalse,
          reason: 'บันทึกก่อนครบ 300 ms (ไม่มี debounce — V-3)');
      expect(repo.saveMasterVoiceCount, 0, reason: 'สวิตช์เสียงไม่ถูกแตะ');
    });

    testWidgets('EC5_rapid_4_taps_end_on_zero_saves_3_taps_one_save_false',
        (tester) async {
      final (_, _, repo, _) = await pumpToSettings(tester);
      for (var i = 0; i < 4; i++) {
        await tester.tap(k('voice_master_switch'));
        await tester.pump(const Duration(milliseconds: 20));
      }
      expect(tester.widget<SwitchListTile>(k('voice_master_switch')).value,
          isTrue);
      await tester.pump(docDebounce);
      expect(repo.saveMasterVoiceCount, 0);
      for (var i = 0; i < 3; i++) {
        await tester.tap(k('voice_master_switch'));
        await tester.pump(const Duration(milliseconds: 20));
      }
      await tester.pump(docDebounce);
      expect(repo.savedMasterVoiceValues, [false]);
    });

    testWidgets('EC5_back_before_300ms_flushes_value', (tester) async {
      final (_, _, repo, _) = await pumpToSettings(tester);
      await tester.tap(k('voice_master_switch'));
      await tester.pump(const Duration(milliseconds: 50));
      // ถอดหน้าทิ้งทันที (dispose) ที่ 50 ms — ยังไม่ครบ debounce
      // (pop ผ่าน Navigator ใช้ transition 300 ms จึงแยกไม่ออกจาก debounce ปกติ)
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      expect(repo.savedMasterVoiceValues, [false],
          reason: 'ui-spec §2.3: ออกจากหน้าระหว่างรอ debounce → บันทึกทันที');
      await tester.pump(docDebounce);
      expect(repo.saveMasterVoiceCount, 1, reason: 'ไม่บันทึกซ้ำ');
    });

    testWidgets('GR11_turn_off_in_settings_while_dashboard_speaking_clears',
        (tester) async {
      // water 0 → waterLow กำลังพูดบน dashboard (autoComplete false)
      final (_, voice, _, engine) =
          await pumpToSettings(tester, autoComplete: false);
      expect(voice.currentLine, isNotNull,
          reason: 'เปิดหน้าตั้งค่าทับไม่หยุดเสียง (Q-13)');
      final stops = engine.stopCount;
      await tester.tap(k('voice_master_switch'));
      await tester.pump();
      expect(voice.currentLine, isNull);
      expect(voice.queue, isEmpty);
      expect(engine.stopCount, greaterThan(stops));
      await tester.binding.handlePopRoute();
      await settle(tester);
      expect(k('voice_speech_bubble'), findsNothing);
    });

    testWidgets('UX_S3_ERROR_save_fails_revert_and_toast_2s', (tester) async {
      final repo = ThrowingVoiceRepository(
        state: const VoiceState(
            permissionStatus: VoicePermissionStatus.on, masterVoice: true),
        throwOnSaveMaster: true,
      );
      final (_, voice, _, _) = await pumpToSettings(tester, repo: repo);
      await tester.tap(k('voice_master_switch'));
      await tester.pump();
      await tester.pump(docDebounce);
      await tester.pump();
      expect(tester.widget<SwitchListTile>(k('voice_master_switch')).value,
          isTrue, reason: 'คงค่าเดิมก่อนกด');
      expect(voice.saveFailureCount, 1);
      final toast = find.byKey(const ValueKey('voice_save_error_toast'));
      expect(toast, findsOneWidget);
      expect(find.text(docSaveErrorText), findsOneWidget);
      // หายเองใน 2 วินาที นับจากแสดงเต็มจอ (แบบเดียวกับ water toast — ไม่นับ animation)
      Animation<double> anim() =>
          tester.widgetList<SnackBar>(toast).first.animation!;
      var entryMs = 0;
      while (anim().status != AnimationStatus.completed) {
        await tester.pump(const Duration(milliseconds: 10));
        entryMs += 10;
        expect(entryMs, lessThan(3000), reason: 'animation เข้าไม่ควรนานเกิน');
      }
      await tester.pump(const Duration(milliseconds: 1990));
      expect(anim().status, AnimationStatus.completed,
          reason: 'ยังไม่ครบ 2 วินาทีนับจากแสดงเต็มจอ');
      await tester.pump(const Duration(milliseconds: 10));
      await tester.pump();
      expect(anim().status, AnimationStatus.reverse,
          reason: 'ครบ 2 วินาที ต้องเริ่มหาย');
      await settle(tester);
      expect(toast, findsNothing);
    });

    testWidgets('DECIDED_V5_settings_without_voice_one_switch_via_gear',
        (tester) async {
      final x = nh.makeHarness(clock: nclock, state: nh.grantedOn);
      await tester.pumpWidget(MaterialApp(
        home: WaterHomeScreen(
          controller: x.sources.water,
          stepsController: x.sources.steps,
          foodController: x.sources.food,
          notificationController: x.controller,
          animatePet: false,
        ),
      ));
      await settle(tester);
      await tester.tap(k('dashboard_entry_button'));
      await settle(tester);
      await tester.tap(k('notification_settings_entry_button'));
      await settle(tester);
      expect(find.byType(Switch), findsOneWidget);
      expect(k('voice_master_switch'), findsNothing);
    });
  });
}
