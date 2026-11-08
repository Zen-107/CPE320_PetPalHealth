// Widget tests: S-1 การ์ดขอความยินยอม, S-2 หน้าตั้งค่า, ปุ่มบน dashboard, deep link (S-3)
// ข้อความคัดลอกตรงตัวจาก ux-flow.md §2 · Key / โครง / ขนาด จาก ui-spec.md §2 / §6
// ข้อตัดสิน owner (DECIDED 2026-11-08) ชื่อเทสต์มี DECIDED_ · ห้ามเรียก plugin จริง (fake scheduler)
// เวลา: clock ที่ส่งให้ทุก controller + tester.pump(Duration) — ไม่ใช้เวลาจริง
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/dashboard/screens/dashboard_screen.dart';
import 'package:petpal_health/features/food/screens/food_dashboard_screen.dart';
import 'package:petpal_health/features/notification/notification_avatar.dart';
import 'package:petpal_health/features/notification/notification_models.dart';
import 'package:petpal_health/features/notification/notification_repository.dart';
import 'package:petpal_health/features/notification/screens/notification_settings_screen.dart';
import 'package:petpal_health/features/notification/widgets/notification_consent_card.dart';
import 'package:petpal_health/features/steps/screens/steps_dashboard_screen.dart';
import 'package:petpal_health/features/water/screens/water_home_screen.dart';
import 'package:petpal_health/main.dart';
import 'package:petpal_health/shared/pet/pet.dart';

import 'notification_test_helpers.dart';

Finder k(String key) => find.byKey(Key(key));
String textOf(WidgetTester tester, Finder f) => tester.widget<Text>(f).data!;

void setSize(WidgetTester tester,
    {double w = 360, double h = 640, double textScale = 1.0}) {
  tester.view.physicalSize = Size(w, h);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
}

/// ติดตาม stack ของ Navigator หลัก (ui-spec §6: stack = [Home, ปลายทาง])
class StackObserver extends NavigatorObserver {
  final List<Route<dynamic>> routes = [];
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      routes.add(route);
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      routes.remove(route);
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      routes.remove(route);
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final i = oldRoute == null ? -1 : routes.indexOf(oldRoute);
    if (i >= 0 && newRoute != null) routes[i] = newRoute;
  }
}

Future<void> frames(WidgetTester tester, [int n = 8]) async {
  for (var i = 0; i < n; i++) {
    await tester.pump();
  }
}

/// รอ transition ของ dialog / route (≤ 300 ms ของ Material) ด้วยเวลาที่ควบคุมได้
Future<void> settle(WidgetTester tester) async {
  await frames(tester);
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 250));
  }
  await frames(tester, 3);
}

void main() {
  late DateTime now;
  setUp(() => now = t(today, 7));

  Harness harness({
    NotificationState state = NotificationState.initial,
    NotificationRepository? repo,
    FakeNotificationScheduler? scheduler,
  }) =>
      makeHarness(
          clock: () => now, state: state, repo: repo, scheduler: scheduler);

  late StackObserver obs;

  Widget home(Harness x) {
    obs = StackObserver();
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue)),
      navigatorObservers: [obs],
      home: WaterHomeScreen(
        controller: x.sources.water,
        notificationController: x.controller,
        animatePet: false,
      ),
    );
  }

  Future<Harness> pumpHome(WidgetTester tester,
      {NotificationState state = NotificationState.initial,
      NotificationRepository? repo,
      FakeNotificationScheduler? scheduler}) async {
    final x = harness(state: state, repo: repo, scheduler: scheduler);
    await tester.pumpWidget(home(x));
    await settle(tester);
    return x;
  }

  Finder card() => k('notification_consent_card');

  Future<void> openDashboard(WidgetTester tester) async {
    await tester.tap(k('dashboard_entry_button'));
    await settle(tester);
  }

  Future<void> openS2(WidgetTester tester) async {
    await openDashboard(tester);
    await tester.tap(k('notification_settings_entry_button'));
    await settle(tester);
  }

  // =========================================================================
  // S-1 การ์ดขอความยินยอม (AC-1..AC-5)
  // =========================================================================
  group('S-1 consent card', () {
    testWidgets('AC1_first_home_shows_card_over_home_exact_texts', (tester) async {
      await pumpHome(tester);
      expect(card(), findsOneWidget);
      expect(tester.widget(card()), isA<Dialog>());
      expect(textOf(tester, k('notification_consent_title_text')), consentTitleDoc);
      expect(textOf(tester, k('notification_consent_body_text')), consentBodyDoc);
      expect(
          find.descendant(
              of: k('notification_consent_allow_button'), matching: find.text(allowDoc)),
          findsOneWidget);
      expect(
          find.descendant(
              of: k('notification_consent_deny_button'), matching: find.text(denyDoc)),
          findsOneWidget);
      expect(tester.widget(k('notification_consent_allow_button')), isA<FilledButton>());
      expect(tester.widget(k('notification_consent_deny_button')), isA<OutlinedButton>());
      // ทับหน้า Home (Home ยังอยู่ด้านหลัง)
      expect(k('water_log_button'), findsOneWidget);
    });

    testWidgets('DECIDED_D1_card_pet_is_PetCharacter_notificationProfile_wink_120',
        (tester) async {
      await pumpHome(tester);
      final painterFinder = find.descendant(
          of: k('notification_consent_pet_image'), matching: find.byKey(PetKeys.painter));
      final painter = tester.widget<CustomPaint>(painterFinder).painter!
          as PetCharacterPainter;
      expect(painter.pose, PetPose.notificationProfile);
      expect(painter.isWinking, isTrue);
      expect(painter.showsKissHeart, isTrue);
      final pet = tester.widget<PetCharacter>(find.descendant(
          of: k('notification_consent_pet_image'), matching: find.byType(PetCharacter)));
      expect(pet.size, docConsentPetSize);
      expect(pet.reactToTap, isFalse);
      // ux-flow: รูปไม่มีผลเมื่อกด
      await tester.tap(k('notification_consent_pet_image'));
      await frames(tester);
      expect(card(), findsOneWidget);
      expect(
          (tester.widget<CustomPaint>(painterFinder).painter! as PetCharacterPainter)
              .isWinking,
          isTrue);
      expect(find.descendant(of: card(), matching: find.byType(Image)), findsNothing,
          reason: 'D-1 ไม่ใช้ PNG');
    });

    testWidgets('UI_card_order_pet_title_body_allow_deny', (tester) async {
      await pumpHome(tester);
      double top(String key) => tester.getTopLeft(k(key)).dy;
      final order = [
        top('notification_consent_pet_image'),
        top('notification_consent_title_text'),
        top('notification_consent_body_text'),
        top('notification_consent_allow_button'),
        top('notification_consent_deny_button'),
      ];
      expect([...order]..sort(), order);
      expect(tester.getSize(k('notification_consent_allow_button')).width,
          tester.getSize(k('notification_consent_deny_button')).width,
          reason: 'ปุ่มเต็มความกว้างซ้อนแนวตั้ง');
    });

    testWidgets('UX_S1_barrier_tap_and_back_do_not_close_card', (tester) async {
      await pumpHome(tester);
      final depth = obs.routes.length;
      await tester.tapAt(const Offset(5, 5)); // ฉากหลัง / ตำแหน่ง AppBar
      await settle(tester);
      expect(card(), findsOneWidget);
      await tester.binding.handlePopRoute(); // ปุ่ม back ของระบบ
      await settle(tester);
      expect(card(), findsOneWidget);
      expect(obs.routes.length, depth, reason: 'ไม่มีการนำทาง');
    });

    testWidgets('AC2_allow_closes_card_then_requests_once_saves_and_schedules',
        (tester) async {
      final sched = FakeNotificationScheduler();
      int? depthAtRequest;
      sched.onRequest = () => depthAtRequest = obs.routes.length;
      final x = await pumpHome(tester, scheduler: sched);
      await tester.tap(k('notification_consent_allow_button'));
      await settle(tester);
      expect(card(), findsNothing);
      expect(sched.requestCount, 1);
      expect(depthAtRequest, 1, reason: 'การ์ดปิดก่อนกล่องของ OS');
      expect(x.mem.state.consentStatus, NotificationConsentStatus.allowed);
      expect(x.mem.state.masterSwitch, isTrue);
      expect(sched.pendingAt(now), isNotEmpty);
    });

    testWidgets('AC3_deny_closes_card_no_request_no_schedule', (tester) async {
      final x = await pumpHome(tester);
      await tester.tap(k('notification_consent_deny_button'));
      await settle(tester);
      expect(card(), findsNothing);
      expect(x.scheduler.requestCount, 0);
      expect(x.mem.state.consentStatus, NotificationConsentStatus.denied);
      expect(x.mem.state.masterSwitch, isFalse);
      expect(x.scheduler.scheduledLog, isEmpty);
    });

    testWidgets('AC4_second_home_visit_no_card', (tester) async {
      final x = await pumpHome(tester);
      await tester.tap(k('notification_consent_deny_button'));
      await settle(tester);
      // เปิดแอปใหม่ (controller ใหม่ อ่านจาก repository เดิม)
      await tester.pumpWidget(const SizedBox());
      final y = makeHarness(clock: () => now, repo: x.repo);
      await tester.pumpWidget(home(y));
      await settle(tester);
      expect(card(), findsNothing);
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('AC1_card_shown_once_even_when_sources_notify', (tester) async {
      final x = await pumpHome(tester);
      expect(card(), findsOneWidget);
      x.sources.water.logWater();
      x.controller.onAppResumed();
      await settle(tester);
      expect(card(), findsOneWidget);
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('EDGE_S1_ERROR_unreadable_storage_no_card_no_error_dialog',
        (tester) async {
      final x = await pumpHome(tester, repo: BrokenLoadNotificationRepository());
      expect(card(), findsNothing);
      expect(find.byType(Dialog), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
      expect(x.scheduler.requestCount, 0);
      expect(x.scheduler.scheduledLog, isEmpty);
      expect(tester.takeException(), isNull);
    });

    testWidgets('EDGE_loading_no_card_until_loaded', (tester) async {
      final repo = PendingNotificationRepository();
      await pumpHome(tester, repo: repo);
      expect(card(), findsNothing);
      repo.c.complete(NotificationState.initial);
      await settle(tester);
      expect(card(), findsOneWidget);
    });

    testWidgets('WIRING_PetPalApp_passes_notification_controller', (tester) async {
      final x = harness();
      await tester.pumpWidget(PetPalApp(
          waterController: x.sources.water, notificationController: x.controller));
      await settle(tester);
      expect(card(), findsOneWidget);
    });

    for (final scale in [1.0, 1.5]) {
      testWidgets('UI_360x640_scale_${scale}_card_no_overflow_buttons_reachable',
          (tester) async {
        setSize(tester, textScale: scale);
        final errors = <FlutterErrorDetails>[];
        final old = FlutterError.onError;
        FlutterError.onError = errors.add;
        final x = harness();
        await tester.pumpWidget(home(x));
        await settle(tester);
        FlutterError.onError = old;
        // หน้า water ล้นแนวตั้งที่ 1.5 อยู่เดิม (dev log คำถาม 5) — กรองเฉพาะ error ของ notification
        final mine = errors
            .map((e) => e.toString())
            .where((s) =>
                s.contains('Notification') ||
                s.contains('notification_') ||
                s.contains('Dialog'))
            .toList();
        expect(mine, isEmpty, reason: '$mine');
        expect(
            MediaQuery.textScalerOf(tester.element(card())).scale(10),
            closeTo(10 * scale, 0.001));
        final r = tester.getRect(card());
        expect(r.left >= 0 && r.right <= 360, isTrue, reason: '$r');
        await tester.ensureVisible(k('notification_consent_deny_button'));
        await frames(tester);
        await tester.tap(k('notification_consent_deny_button'));
        await settle(tester);
        expect(card(), findsNothing);
        expect(x.mem.state.consentStatus, NotificationConsentStatus.denied);
      });

      testWidgets('UI_360x640_scale_${scale}_card_alone_no_exception',
          (tester) async {
        setSize(tester, textScale: scale);
        final x = harness();
        await tester.pumpWidget(MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  key: const Key('open'),
                  onPressed: () => showNotificationConsentCard(context, x.controller,
                      animatePet: false),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ));
        await tester.tap(k('open'));
        await settle(tester);
        expect(card(), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  // =========================================================================
  // ปุ่มบน dashboard (D-2) + AppBar water เดิม
  // =========================================================================
  group('DECIDED_D2 entry button', () {
    testWidgets('DECIDED_D2_dashboard_settings_button_opens_S2', (tester) async {
      await pumpHome(tester, state: grantedOn);
      await openDashboard(tester);
      final btn = k('notification_settings_entry_button');
      expect(btn, findsOneWidget);
      final b = tester.widget<IconButton>(btn);
      expect(b.tooltip, settingsTitleDoc);
      final icon = tester.widget<Icon>(find.descendant(of: btn, matching: find.byType(Icon)));
      expect(icon.icon, Icons.settings);
      expect(icon.size, docEntryIconSize);
      await tester.tap(btn);
      await settle(tester);
      expect(k('notification_settings_header_text'), findsOneWidget);
      expect(find.byType(NotificationSettingsScreen), findsOneWidget);
    });

    testWidgets('DECIDED_D2_dashboard_without_controller_has_no_button',
        (tester) async {
      final x = harness();
      await tester.pumpWidget(MaterialApp(
          home: DashboardScreen(
              waterController: x.sources.water,
              stepsController: x.sources.steps,
              foodController: x.sources.food,
              animatePet: false)));
      await settle(tester);
      expect(k('notification_settings_entry_button'), findsNothing);
    });

    testWidgets('DECIDED_D2_water_appbar_still_5_buttons', (tester) async {
      await pumpHome(tester, state: grantedOn);
      final bar = find.byType(AppBar).first;
      expect(find.descendant(of: bar, matching: find.byType(IconButton)),
          findsNWidgets(5));
      expect(k('notification_settings_entry_button'), findsNothing);
    });

    for (final scale in [1.0, 1.5]) {
      testWidgets('UI_360x640_scale_${scale}_dashboard_appbar_no_overflow',
          (tester) async {
        setSize(tester, textScale: scale);
        final errors = <FlutterErrorDetails>[];
        final old = FlutterError.onError;
        FlutterError.onError = errors.add;
        await pumpHome(tester, state: grantedOn);
        await openDashboard(tester);
        FlutterError.onError = old;
        final bar = errors
            .map((e) => e.toString())
            .where((s) => s.contains('AppBar') || s.contains('NavigationToolbar'))
            .toList();
        expect(bar, isEmpty, reason: '$bar');
        final r = tester.getRect(k('notification_settings_entry_button'));
        expect(r.right <= 360 && r.left >= 0, isTrue, reason: '$r');
      });
    }
  });

  // =========================================================================
  // S-2 หน้าตั้งค่า (AC-5..AC-8, EC-1, EC-9, EC-10)
  // =========================================================================
  group('S-2 settings', () {
    Future<Harness> pumpS2(WidgetTester tester, NotificationState state,
        {FakeNotificationScheduler? scheduler}) async {
      final x = await pumpHome(tester, state: state, scheduler: scheduler);
      await openS2(tester);
      return x;
    }

    bool switchValue(WidgetTester tester) =>
        tester.widget<SwitchListTile>(k('notification_master_switch')).value;

    testWidgets('UX_S2_header_and_DECIDED_Q03_switch_label', (tester) async {
      await pumpS2(tester, grantedOn);
      expect(textOf(tester, k('notification_settings_header_text')), settingsTitleDoc);
      expect(textOf(tester, k('notification_master_switch_label')), masterSwitchLabelQ03);
      expect(find.byType(Switch), findsOneWidget, reason: 'สวิตช์ 1 อัน');
    });

    testWidgets('AC5_NORMAL_on_granted_switch_on_no_banner', (tester) async {
      await pumpS2(tester, grantedOn);
      expect(switchValue(tester), isTrue);
      expect(k('notification_permission_denied_banner'), findsNothing);
    });

    testWidgets('AC5_EMPTY_denied_on_card_switch_off_no_banner_no_pending',
        (tester) async {
      final x = await pumpS2(
          tester,
          const NotificationState(
              consentStatus: NotificationConsentStatus.denied));
      expect(switchValue(tester), isFalse);
      expect(k('notification_permission_denied_banner'), findsNothing);
      expect(x.scheduler.pendingAt(now), isEmpty);
    });

    testWidgets('AC8_EC10_PERMISSION_DENIED_switch_off_banner_exact_text_colors',
        (tester) async {
      final x = await pumpS2(
          tester,
          const NotificationState(
              consentStatus: NotificationConsentStatus.allowed,
              masterSwitch: true,
              systemPermission: NotificationSystemPermission.denied),
          scheduler: FakeNotificationScheduler(
              checkResult: NotificationSystemPermission.denied));
      expect(switchValue(tester), isFalse);
      expect(k('notification_permission_denied_banner'), findsOneWidget);
      expect(textOf(tester, k('notification_permission_denied_text')), permissionDeniedDoc);
      final scheme =
          Theme.of(tester.element(k('notification_permission_denied_banner'))).colorScheme;
      final box = tester.widget<Container>(k('notification_permission_denied_banner'));
      expect((box.decoration! as BoxDecoration).color, scheme.errorContainer);
      expect(tester.widget<Text>(k('notification_permission_denied_text')).style!.color,
          scheme.onErrorContainer);
      expect(x.scheduler.scheduledLog, isEmpty);
    });

    testWidgets('DECIDED_EC9_AC6_tap_switch_on_requests_and_schedules',
        (tester) async {
      final x = await pumpS2(
          tester,
          const NotificationState(
              consentStatus: NotificationConsentStatus.denied));
      await tester.tap(k('notification_master_switch'));
      await settle(tester);
      expect(x.scheduler.requestCount, 1);
      expect(switchValue(tester), isTrue);
      expect(x.scheduler.pendingAt(now), isNotEmpty);
    });

    testWidgets('AC6_request_denied_switch_back_off_banner_shown', (tester) async {
      final x = await pumpS2(
          tester,
          const NotificationState(consentStatus: NotificationConsentStatus.denied),
          scheduler: FakeNotificationScheduler(
              requestResult: NotificationSystemPermission.denied));
      await tester.tap(k('notification_master_switch'));
      await settle(tester);
      expect(x.scheduler.requestCount, 1);
      expect(switchValue(tester), isFalse);
      expect(k('notification_permission_denied_banner'), findsOneWidget);
    });

    testWidgets('AC7_tap_switch_off_cancels_pending', (tester) async {
      final x = await pumpS2(tester, grantedOn);
      final pend = x.scheduler.pendingAt(now);
      expect(pend, isNotEmpty);
      await tester.tap(k('notification_master_switch'));
      await settle(tester);
      expect(switchValue(tester), isFalse);
      expect(x.scheduler.pendingAt(now), isEmpty);
      expect(x.scheduler.cancelAllCount, 0);
      expect(x.scheduler.cancelledLog.toSet(), pend.map((i) => i.id).toSet());
    });

    testWidgets('EC1_rapid_taps_last_state_wins', (tester) async {
      final x = await pumpS2(tester, grantedOn);
      for (var i = 0; i < 4; i++) {
        await tester.tap(k('notification_master_switch'));
        await tester.pump();
      }
      await tester.tap(k('notification_master_switch')); // 5 ครั้ง → OFF
      await settle(tester);
      expect(switchValue(tester), isFalse);
      expect(x.mem.state.masterSwitch, isFalse);
      expect(x.scheduler.pendingAt(now), isEmpty);
    });

    testWidgets('EC10_DECIDED_Q23_resume_updates_open_S2_live', (tester) async {
      final x = await pumpS2(tester, grantedOn);
      x.scheduler.checkResult = NotificationSystemPermission.denied;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await settle(tester);
      expect(k('notification_permission_denied_banner'), findsOneWidget);
      expect(switchValue(tester), isFalse);
      expect(x.scheduler.pendingAt(now), isEmpty);
      x.scheduler.checkResult = NotificationSystemPermission.granted;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await settle(tester);
      expect(k('notification_permission_denied_banner'), findsNothing);
      expect(switchValue(tester), isTrue);
      expect(x.scheduler.pendingAt(now), isNotEmpty);
    });

    testWidgets('EDGE_S2_loading_shows_progress', (tester) async {
      final x = harness(repo: PendingNotificationRepository());
      x.controller.load();
      await tester.pumpWidget(
          MaterialApp(home: NotificationSettingsScreen(controller: x.controller)));
      await frames(tester);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(k('notification_master_switch'), findsNothing);
    });

    for (final scale in [1.0, 1.5]) {
      for (final denied in [false, true]) {
        testWidgets(
            'UI_360x640_scale_${scale}_S2_${denied ? 'PERMISSION_DENIED' : 'NORMAL'}_no_overflow',
            (tester) async {
          setSize(tester, textScale: scale);
          final x = harness(
              state: denied
                  ? const NotificationState(
                      consentStatus: NotificationConsentStatus.allowed,
                      masterSwitch: true,
                      systemPermission: NotificationSystemPermission.denied)
                  : grantedOn,
              scheduler: FakeNotificationScheduler(
                  checkResult: denied
                      ? NotificationSystemPermission.denied
                      : NotificationSystemPermission.granted));
          await x.controller.load();
          await tester.pumpWidget(MaterialApp(
              home: NotificationSettingsScreen(controller: x.controller)));
          await settle(tester);
          expect(tester.takeException(), isNull);
          expect(k('notification_permission_denied_banner'),
              denied ? findsOneWidget : findsNothing);
          if (denied) {
            final r = tester.getRect(k('notification_permission_denied_text'));
            expect(r.right <= 360 && r.bottom <= 640, isTrue, reason: '$r');
          }
        });
      }
    }
  });

  // =========================================================================
  // Deep link 3 เรื่อง × 3 สถานะแอป (AC-38..AC-40, EC-2, EC-13)
  // =========================================================================
  group('deep link', () {
    const payloads = {
      'walk': 'walk|walkInactive',
      'water': 'water|waterFirst',
      'food': 'food|foodUnlogged',
    };
    const acs = {'walk': 'AC38', 'water': 'AC39', 'food': 'AC40'};

    void expectAt(WidgetTester tester, Harness x, String topic) {
      switch (topic) {
        case 'walk':
          expect(find.byType(StepsDashboardScreen), findsOneWidget);
          expect(
              identical(
                  tester.widget<StepsDashboardScreen>(find.byType(StepsDashboardScreen))
                      .controller,
                  x.controller.steps),
              isTrue,
              reason: 'controller ตัวเดียวกับ _openSteps (D-9)');
          expect(obs.routes.length, 2, reason: 'stack = [Home, Steps]');
        case 'food':
          expect(find.byType(FoodDashboardScreen), findsOneWidget);
          expect(
              identical(
                  tester.widget<FoodDashboardScreen>(find.byType(FoodDashboardScreen))
                      .controller,
                  x.controller.food),
              isTrue);
          expect(obs.routes.length, 2, reason: 'stack = [Home, Food]');
        case 'water':
          expect(obs.routes.length, 1, reason: 'stack = [Home]');
          expect(k('water_log_button'), findsOneWidget);
      }
      expect(find.byType(StepsDashboardScreen, skipOffstage: false),
          topic == 'walk' ? findsOneWidget : findsNothing);
      expect(find.byType(FoodDashboardScreen, skipOffstage: false),
          topic == 'food' ? findsOneWidget : findsNothing);
      expect(find.byType(NotificationSettingsScreen, skipOffstage: false), findsNothing);
      expect(find.byType(DashboardScreen, skipOffstage: false), findsNothing);
    }

    for (final topic in payloads.keys) {
      final payload = payloads[topic]!;

      testWidgets('${acs[topic]}_${topic}_FOREGROUND_from_S2_opens_$topic',
          (tester) async {
        final x = await pumpHome(tester, state: grantedOn);
        await openS2(tester);
        expect(obs.routes.length, 3);
        x.controller.handleNotificationTap(payload);
        await settle(tester);
        expectAt(tester, x, topic);
      });

      testWidgets('${acs[topic]}_${topic}_BACKGROUND_opens_$topic', (tester) async {
        final x = harness(state: grantedOn);
        await x.scheduler.initialize(onTap: x.controller.handleNotificationTap);
        await tester.pumpWidget(home(x));
        await settle(tester);
        await openDashboard(tester);
        final b = tester.binding;
        b.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
        b.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
        b.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        x.scheduler.onTap!(payload); // plugin callback (onDidReceiveNotificationResponse)
        b.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
        b.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
        b.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        await settle(tester);
        expectAt(tester, x, topic);
      });

      testWidgets('${acs[topic]}_EC13_${topic}_TERMINATED_launch_payload_opens_$topic',
          (tester) async {
        final x = harness(
            state: grantedOn,
            scheduler: FakeNotificationScheduler(
                checkResult: NotificationSystemPermission.granted, launch: payload));
        // แบบ main(): initialize → launchPayload → handleNotificationTap ก่อน runApp
        await x.scheduler.initialize(onTap: x.controller.handleNotificationTap);
        x.controller.handleNotificationTap(await x.scheduler.launchPayload());
        await tester.pumpWidget(home(x));
        await settle(tester);
        expectAt(tester, x, topic);
      });

      testWidgets('EC2_${topic}_same_notification_tapped_3_times_one_page',
          (tester) async {
        final x = await pumpHome(tester, state: grantedOn);
        for (var i = 0; i < 3; i++) {
          x.controller.handleNotificationTap(payload);
        }
        await settle(tester);
        expectAt(tester, x, topic);
        for (var i = 0; i < 3; i++) {
          x.controller.handleNotificationTap(payload);
          await settle(tester);
        }
        expectAt(tester, x, topic);
      });
    }

    testWidgets('EC2_from_steps_page_food_tap_replaces_not_stacks', (tester) async {
      final x = await pumpHome(tester, state: grantedOn);
      await tester.tap(k('steps_entry_button'));
      await settle(tester);
      x.controller.handleNotificationTap(payloads['food']);
      await settle(tester);
      expectAt(tester, x, 'food');
    });

    testWidgets('R2_BUG2_EC13_TERMINATED_unanswered_card_deny_then_navigates',
        (tester) async {
      final x = harness();
      x.controller.handleNotificationTap(payloads['walk']);
      await tester.pumpWidget(home(x));
      await settle(tester);
      expect(card(), findsOneWidget);
      await tester.tap(k('notification_consent_deny_button'));
      await settle(tester);
      expect(card(), findsNothing);
      expect(x.controller.pendingDeepLink, isNull);
      expectAt(tester, x, 'walk');
      expect(x.scheduler.requestCount, 0);
    });

    testWidgets('R2_BUG2_EC13_TERMINATED_unanswered_card_allow_immediate_water',
        (tester) async {
      final x = harness();
      await tester.pumpWidget(home(x));
      await settle(tester);
      expect(card(), findsOneWidget);
      x.controller.handleNotificationTap(payloads['water']);
      await settle(tester);
      expect(card(), findsOneWidget, reason: 'deep link รอการ์ดปิดก่อน');
      await tester.tap(k('notification_consent_allow_button'));
      await settle(tester);
      expect(card(), findsNothing);
      expect(x.controller.pendingDeepLink, isNull);
      expectAt(tester, x, 'water');
    });

    testWidgets('EDGE_unreadable_payload_no_navigation', (tester) async {
      final x = await pumpHome(tester, state: grantedOn);
      await openDashboard(tester);
      for (final p in [null, '', 'garbage', 'zzz|waterFirst']) {
        x.controller.handleNotificationTap(p);
      }
      await settle(tester);
      expect(obs.routes.length, 2);
      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('EC13_Q16_TERMINATED_with_unanswered_card_navigates_after_answer',
        (tester) async {
      final x = harness();
      x.controller.handleNotificationTap(payloads['food']);
      await tester.pumpWidget(home(x));
      await settle(tester);
      expect(card(), findsOneWidget, reason: 'การ์ดขึ้นก่อน (ไม่ถูก popUntil ปิด)');
      expect(find.byType(FoodDashboardScreen, skipOffstage: false), findsNothing);
      await tester.tap(k('notification_consent_allow_button'));
      await settle(tester);
      expect(card(), findsNothing);
      expectAt(tester, x, 'food');
    });
  });

  // =========================================================================
  // S-3 รูปแบบบน OS (AC-36, AC-37) — ตรวจได้ระดับ Dart เท่านั้น (ไม่เรียก plugin)
  // =========================================================================
  group('S-3 details (Dart level)', () {
    testWidgets('DECIDED_D1_AC36_avatar_png_192_circle_transparent_cached',
        (tester) async {
      await tester.runAsync(() async {
        final src = PainterNotificationAvatarSource();
        final f1 = src.avatarPng();
        expect(identical(f1, src.avatarPng()), isTrue, reason: 'แคช Future เดียว');
        final bytes = (await f1)!;
        expect(bytes.sublist(0, 8), [137, 80, 78, 71, 13, 10, 26, 10], reason: 'PNG');
        final codec = await ui.instantiateImageCodec(bytes);
        final image = (await codec.getNextFrame()).image;
        expect(image.width, docAvatarPx);
        expect(image.height, docAvatarPx);
        final rgba = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
        int alpha(int x, int y) => rgba.getUint8((y * docAvatarPx + x) * 4 + 3);
        expect(alpha(0, 0), 0, reason: 'มุมนอกวงกลมโปร่งใส');
        expect(alpha(docAvatarPx - 1, docAvatarPx - 1), 0);
        expect(alpha(docAvatarPx ~/ 2, docAvatarPx ~/ 2), greaterThan(0),
            reason: 'มีตัวกบตรงกลาง');
        image.dispose();
      });
    });

    test('AC36_AC37_DECIDED_D6_local_scheduler_details_in_source', () {
      final src =
          File('lib/features/notification/notification_local_scheduler.dart')
              .readAsStringSync();
      // Android แชต 3 ส่วน: ชื่อผู้ส่ง + รูป + ข้อความ
      expect(src, contains('MessagingStyleInformation('));
      expect(src, contains('name: NotificationRules.senderName'));
      expect(src, contains('ByteArrayAndroidIcon('));
      expect(src, contains('NotificationRules.androidChannelId'));
      // iOS ปกติ 2 ส่วน: title null, presentBanner, ไม่มี attachment
      expect(src, contains('_isAndroid ? NotificationRules.senderName : null'));
      expect(src, contains('DarwinNotificationDetails('));
      expect(src, contains('presentBanner: true'));
      expect(src, isNot(contains('attachments')));
      // D-6 inexact
      expect(src, contains('AndroidScheduleMode.inexactAllowWhileIdle'));
      expect(RegExp(r'AndroidScheduleMode\.(exact|alarmClock)').hasMatch(src), isFalse);
    });

    test('DECIDED_D5_D6_manifest_pubspec_main_setup', () {
      final manifest =
          File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
      expect(manifest, contains('android.permission.POST_NOTIFICATIONS'));
      expect(manifest, contains('android.permission.RECEIVE_BOOT_COMPLETED'));
      expect(manifest, contains('ScheduledNotificationReceiver'));
      expect(manifest, contains('ScheduledNotificationBootReceiver'));
      expect(manifest, contains('android:launchMode="singleTop"'));
      for (final banned in [
        'SCHEDULE_EXACT_ALARM',
        'USE_EXACT_ALARM',
        'USE_FULL_SCREEN_INTENT'
      ]) {
        // คอมเมนต์ใน manifest อ้างชื่อได้ — ตรวจเฉพาะการประกาศสิทธิ์
        expect(manifest, isNot(contains('android:name="android.permission.$banned"')),
            reason: banned);
      }
      final pubspec = File('pubspec.yaml').readAsStringSync();
      expect(pubspec, contains('flutter_local_notifications: 22.3.3'));
      expect(pubspec, contains('timezone:'));
      expect(pubspec, contains('flutter_timezone:'));
      expect(pubspec, isNot(contains('workmanager')));
      final main = File('lib/main.dart').readAsStringSync();
      final launch = main.indexOf('launchPayload()');
      expect(launch, greaterThan(0));
      expect(launch, lessThan(main.indexOf('runApp(')), reason: 'EC-13');
      expect(main, contains('signupController.onSignedOut = notificationController.onSignedOut'),
          reason: 'Q-28');
    });

    test('DECIDED_D1_D5_no_png_no_asset_no_network_no_hex_in_notification_code', () {
      for (final f in Directory('lib/features/notification')
          .listSync(recursive: true)
          .whereType<File>()) {
        final s = f.readAsStringSync();
        for (final banned in [
          'pet_profile_frog.png',
          'Image.asset',
          'AssetImage',
          'DrawableResourceAndroidBitmap',
          'package:http',
          'HttpClient',
          'Color(0x',
        ]) {
          expect(s.contains(banned), isFalse, reason: '${f.path}: $banned');
        }
      }
    });
  });

  // =========================================================================
  // Q-28 logout (widget: ออกจาก Home → stop)
  // =========================================================================
  group('Q-28 widget', () {
    testWidgets('DECIDED_Q28_home_disposed_stops_timer_and_listeners',
        (tester) async {
      final x = await pumpHome(tester, state: grantedOn);
      expect(x.timers.activeCount, 1);
      await x.controller.onSignedOut();
      await tester.pumpWidget(const SizedBox()); // SignupGate ถอด Home
      await frames(tester);
      expect(x.timers.activeCount, 0);
      expect(x.scheduler.cancelAllCount, 1);
      expect(x.scheduler.active, isEmpty);
      final before = x.scheduler.scheduledLog.length;
      now = t(today, 9);
      await x.sources.water.logWater();
      await frames(tester);
      expect(x.scheduler.scheduledLog.length, before);
    });
  });
}
