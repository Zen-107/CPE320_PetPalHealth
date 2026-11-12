import 'dart:async';

import 'package:flutter/material.dart';
import 'package:petpal_health/shared/pet/pet.dart';

import '../../dashboard/dashboard_rules.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../food/food_controller.dart';
import '../../food/food_repository.dart';
import '../../food/food_rules.dart';
import '../../food/screens/food_dashboard_screen.dart';
import '../../notification/notification_controller.dart';
import '../../notification/notification_models.dart';
import '../../notification/widgets/notification_consent_card.dart';
import '../../seven_day/screens/seven_day_history_screen.dart';
import '../../seven_day/seven_day_rules.dart';
import '../../signup/signup_rules.dart';
import '../../steps/screens/steps_dashboard_screen.dart';
import '../../steps/steps_controller.dart';
import '../../steps/steps_external.dart';
import '../../steps/steps_repository.dart';
import '../../steps/steps_rules.dart';
import '../../voice/voice_controller.dart';
import '../../voice/voice_models.dart';
import '../../voice/widgets/voice_permission_dialog.dart';
import '../water_controller.dart';
import '../water_logic.dart';
import '../water_models.dart';
import '../water_rules.dart';
import '../widgets/asset_image_or_icon.dart';
import 'monthly_report_screen.dart';

/// S-1 หน้าจอหลัก (Home / Water Tracker) — ux-flow.md §2
class WaterHomeScreen extends StatefulWidget {
  const WaterHomeScreen({
    super.key,
    required this.controller,
    this.stepsController,
    this.foodController,
    this.animatePet,
    this.welcomeName,
    this.notificationController,
    this.voiceController,
  });

  final WaterController controller;

  /// `PetCharacter.animate` — null = [kPetAnimateByDefault] (แอปจริง animate,
  /// ระหว่าง flutter test เป็นภาพนิ่ง)
  final bool? animatePet;

  /// ทางเข้าฟีเจอร์ steps (docs/steps/ui-spec.md §2.0) — null = สร้างเองเมื่อกดปุ่มครั้งแรก
  final StepsController? stepsController;

  /// ทางเข้าฟีเจอร์ food (docs/food/ui-spec.md §2.0, D-2) — null = สร้างเองเมื่อกดปุ่มครั้งแรก
  final FoodController? foodController;

  /// signup S-7 แบนเนอร์ต้อนรับ (docs/signup/ui-spec.md §2.7) — Display Name ที่
  /// ประมวลผลแล้ว (AC-5); null = ไม่แสดงแบนเนอร์ (พฤติกรรมเดิมของ water)
  final String? welcomeName;

  /// ฟีเจอร์แจ้งเตือน (notification ui-spec §2.1, §2.2, §2.3.3) — S-1 การ์ดขอความยินยอม,
  /// deep link จากการกดแจ้งเตือน, เช็กสิทธิ์ตอน resume และส่งต่อให้ dashboard (ปุ่ม S-2)
  /// null = ไม่มีการ์ด / deep link (พฤติกรรมเดิมของ water)
  final NotificationController? notificationController;

  /// ฟีเจอร์เสียงพากย์ (voice ui-spec §2.1, §2.2) — S-1 dialog ขอเปิดเสียงครั้งแรก และส่งต่อให้
  /// dashboard (พูด) / หน้าตั้งค่า (สวิตช์เสียง)
  /// DECIDED (owner 2026-11-12, V-5): null = ไม่มี dialog / ไม่มีสวิตช์เสียง / ไม่พูด (พฤติกรรมเดิม)
  final VoiceController? voiceController;

  @override
  State<WaterHomeScreen> createState() => _WaterHomeScreenState();
}

class _WaterHomeScreenState extends State<WaterHomeScreen>
    with WidgetsBindingObserver {
  // BUG-PET-1 (fix round 1): PetCharacter ต้องมีตัวตนคงที่ข้ามการเปลี่ยนสถานะ
  // ไม่เช่นนั้น State ใหม่จะเห็น cheerTrigger ที่เพิ่มแล้วใน initState และไม่เล่น cheer
  // (character.md §6) — key ฟีเจอร์ที่เปลี่ยนตามสถานะย้ายไปอยู่ที่ KeyedSubtree ที่ห่อไว้
  // GlobalKey ทำให้ State ของ PetCharacter ถูกย้าย (reparent) ไปใต้ wrapper ใหม่ได้
  final GlobalKey _petKey = GlobalKey(debugLabel: 'water_pet');
  Timer? _resetTimer;
  StepsController? _ownedStepsController;
  FoodController? _ownedFoodController;

  // notification ui-spec §2.1 — กันเปิดการ์ด S-1 ซ้อน (rebuild ระหว่างการ์ดเปิดอยู่)
  bool _consentDialogOpen = false;
  bool _deepLinkScheduled = false;

  // voice ui-spec §2.1 — กันเปิด dialog เสียงซ้อน
  bool _voiceDialogOpen = false;

  // ASSUMPTION: ตรวจรีเซ็ต 05:00 น. ทุก 1 นาทีระหว่างเปิดแอปค้างไว้
  // (AC-5 กำหนดเฉพาะตอนเปิดแอป ส่วนนี้ทำให้หน้าจอรีเซ็ตเองแม้แอปเปิดค้างข้าม 05:00 น.)
  static const Duration _resetCheckInterval = Duration(minutes: 1);

  WaterController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final Future<void> waterReady;
    if (!_controller.isLoaded) {
      waterReady = _controller.load();
    } else {
      waterReady = _controller.refreshDailyReset();
    }
    _resetTimer = Timer.periodic(
      _resetCheckInterval,
      (_) => _controller.refreshDailyReset(),
    );
    final notification = widget.notificationController;
    if (notification != null) {
      notification.addListener(_onNotificationChanged);
      _controller.addListener(_onNotificationChanged);
      // เข้า Home → วางแผนรอบวันปัจจุบัน (EC-14) หลัง water โหลดเสร็จ (ไม่โหลด water ซ้อน)
      // DECIDED (owner 2026-11-08, Q-28): หลังออกจากระบบ วางแผนใหม่เมื่อเข้า Home อีกครั้ง
      waterReady.then((_) {
        if (mounted) notification.start();
      });
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _onNotificationChanged());
    }
    final voice = widget.voiceController;
    if (voice != null) {
      voice.addListener(_onVoiceChanged);
      notification?.addListener(_onVoiceChanged);
      voice.load();
      WidgetsBinding.instance.addPostFrameCallback((_) => _onVoiceChanged());
    }
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _ownedStepsController?.dispose();
    _ownedFoodController?.dispose();
    final notification = widget.notificationController;
    if (notification != null) {
      notification.removeListener(_onNotificationChanged);
      _controller.removeListener(_onNotificationChanged);
      notification.stop();
    }
    final voice = widget.voiceController;
    if (voice != null) {
      voice.removeListener(_onVoiceChanged);
      notification?.removeListener(_onVoiceChanged);
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // กลับมาเปิดแอปอีกครั้ง → ตรวจรีเซ็ตทันที (AC-5, EC-2)
    if (state == AppLifecycleState.resumed) {
      _controller.refreshDailyReset();
      // notification ui-spec §2.2: อ่านสิทธิ์ใหม่ตอนกลับมา (EC-10, Q-23)
      widget.notificationController?.onAppResumed();
    }
  }

  // ---------------------------------------------------------------------------
  // notification: S-1 การ์ดขอความยินยอม + deep link (ui-spec §2.1, §2.3.3)
  // ---------------------------------------------------------------------------

  void _onNotificationChanged() {
    final notification = widget.notificationController;
    if (notification == null || !mounted) return;
    // AC-1 / AC-4: แสดงเฉพาะ consent_status == UNANSWERED (เปลี่ยนครั้งเดียวเมื่อกดปุ่ม)
    if (notification.isLoaded &&
        notification.consentStatus == NotificationConsentStatus.unanswered &&
        !_consentDialogOpen) {
      _consentDialogOpen = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _showConsentCard());
      WidgetsBinding.instance.ensureVisualUpdate();
    }
    // ASSUMPTION: ui-spec Q-16 — deep link ค้างไว้จน Home โหลดเสร็จ · รอการ์ด S-1 ปิดก่อน
    // (popUntil จะปิดการ์ดโดยไม่มีคำตอบ)
    // voice ui-spec §2.1: รอ dialog เสียงปิดด้วย (popUntil จะปิด dialog โดยไม่มีคำตอบ)
    if (notification.pendingDeepLink != null &&
        _controller.isLoaded &&
        !_consentDialogOpen &&
        !_voiceDialogOpen &&
        !_deepLinkScheduled) {
      _deepLinkScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _deepLinkScheduled = false;
        _openDeepLink();
      });
      WidgetsBinding.instance.ensureVisualUpdate();
    }
  }

  Future<void> _showConsentCard() async {
    final notification = widget.notificationController;
    if (!mounted ||
        notification == null ||
        notification.consentStatus != NotificationConsentStatus.unanswered) {
      _consentDialogOpen = false;
      // BUG-NOTI-2 (Dev รอบ 3): ตอบการ์ดแล้ว → ตรวจ deep link ที่ค้างอีกครั้ง (Q-16, EC-13)
      if (mounted) _onNotificationChanged();
      // voice ui-spec §2.1: การ์ดแจ้งเตือนตอบแล้ว → dialog เสียงขึ้นต่อ
      if (mounted) _onVoiceChanged();
      return;
    }
    await showNotificationConsentCard(
      context,
      notification,
      animatePet: widget.animatePet,
    );
    _consentDialogOpen = false;
    if (mounted) _onNotificationChanged();
    // voice ui-spec §2.1: dialog เสียงขึ้นต่อหลังการ์ดแจ้งเตือนปิด
    if (mounted) _onVoiceChanged();
  }

  // ---------------------------------------------------------------------------
  // voice: S-1 dialog ขอเปิดเสียงครั้งแรก (voice ui-spec §2.1)
  // ---------------------------------------------------------------------------

  /// DECIDED (owner 2026-11-12, V-5): แสดงทับหน้า Home เมื่อ voice_permission_status ยังไม่ตอบ
  // ASSUMPTION: voice ui-spec Q-17 — การ์ดแจ้งเตือนขึ้นก่อนเสมอ → รอกล่องขอสิทธิ์ OS ปิด
  // → dialog เสียง · ไม่มี dialog ซ้อน
  void _onVoiceChanged() {
    final voice = widget.voiceController;
    if (voice == null || !mounted) return;
    if (!voice.isLoaded ||
        voice.permissionStatus != VoicePermissionStatus.unanswered ||
        _voiceDialogOpen ||
        _consentDialogOpen) {
      return;
    }
    final notification = widget.notificationController;
    if (notification != null &&
        (!notification.isLoaded ||
            notification.consentStatus ==
                NotificationConsentStatus.unanswered ||
            notification.isRequestingPermission ||
            _awaitingOsPermission(notification))) {
      return;
    }
    _voiceDialogOpen = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _showVoiceDialog());
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  /// ช่วงหลังกด「อนุญาต」บนการ์ดแจ้งเตือนจนกล่องขอสิทธิ์ OS จบ: สวิตช์แสดง ON ทั้งที่ระบบยังไม่
  /// อนุญาต (`isSwitchOn` = master && (granted || รอผลกล่องขอสิทธิ์)) — อ่านจาก getter เดิม
  /// ไม่แก้ NotificationController
  static bool _awaitingOsPermission(NotificationController n) =>
      n.isSwitchOn &&
      n.systemPermission != NotificationSystemPermission.granted;

  Future<void> _showVoiceDialog() async {
    final voice = widget.voiceController;
    if (!mounted ||
        voice == null ||
        voice.permissionStatus != VoicePermissionStatus.unanswered) {
      _voiceDialogOpen = false;
      if (mounted) _onNotificationChanged();
      return;
    }
    await showVoicePermissionDialog(
      context,
      voice,
      animatePet: widget.animatePet,
    );
    _voiceDialogOpen = false;
    // deep link ของ notification ที่ค้างทำงานต่อ
    if (mounted) _onNotificationChanged();
  }

  /// ui-spec §2.3.3 — กันหน้าซ้อน (EC-2): popUntil(isFirst) แล้ว push ไม่เกิน 1 หน้า
  /// stack หลังกด = [Home] (น้ำ) หรือ [Home, ปลายทาง] (เดิน / อาหาร) เสมอ
  // ASSUMPTION: ui-spec Q-17 — หน้าที่เปิดค้างอยู่ (เช่น S-2, dashboard) ถูกปิด
  void _openDeepLink() {
    final notification = widget.notificationController;
    if (!mounted ||
        notification == null ||
        !_controller.isLoaded ||
        _consentDialogOpen ||
        _voiceDialogOpen) {
      return;
    }
    final topic = notification.takePendingDeepLink();
    if (topic == null) return;
    final navigator = Navigator.of(context);
    navigator.popUntil((route) => route.isFirst);
    switch (topic) {
      case NotificationTopic.walk:
        navigator.push(
          MaterialPageRoute<void>(
            builder: (_) => StepsDashboardScreen(controller: _stepsController()),
          ),
        );
      case NotificationTopic.water:
        // หน้าน้ำ = หน้าแรก (ui-spec D-10) — popUntil อย่างเดียว
        break;
      case NotificationTopic.food:
        navigator.push(
          MaterialPageRoute<void>(
            builder: (_) => FoodDashboardScreen(controller: _foodController()),
          ),
        );
    }
  }

  Future<void> _onLogPressed() async {
    final outcome = await _controller.logWater();
    if (!mounted) return;
    if (outcome == LogWaterOutcome.blockedBySpam) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      // DECIDED: Zen-107 2026-10-08 — Toast หายเองใน 2 วินาที นับตั้งแต่แสดงเต็มจอ
      // ไม่นับเวลา animation (ux-flow.md §6): ScaffoldMessenger เริ่มจับเวลา
      // `duration` เมื่อ animation เข้าเสร็จ (แสดงเต็มจอ) และ persist: false
      // บังคับให้หายเองเสมอ
      messenger.showSnackBar(
        const SnackBar(
          key: Key('water_anti_spam_toast'),
          content: Text(WaterRules.antiSpamMessage),
          duration: Duration(seconds: WaterRules.antiSpamToastSeconds),
          persist: false,
        ),
      );
    }
  }

  void _openMonthlyReport() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MonthlyReportScreen(controller: _controller),
      ),
    );
  }

  /// เปิด S-1 ของ steps (docs/steps/ui-spec.md §2.0, D-3)
  void _openSteps() {
    final steps = _stepsController();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StepsDashboardScreen(controller: steps),
      ),
    );
  }

  /// เปิด S-1 ของ food (docs/food/ui-spec.md §2.0, D-2)
  // ASSUMPTION: ไม่ได้ inject FoodController (เช่น เทสต์ที่ไม่มี signup) → โปรไฟล์อยู่ใน
  // หน่วยความจำ (InMemoryFoodProfileSource) ข้อมูลอาหารยังเก็บด้วย shared_preferences
  void _openFood() {
    final food = _foodController();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FoodDashboardScreen(controller: food),
      ),
    );
  }

  /// StepsController ตัวเดียวกันทั้งหน้า steps และ dashboard — null = สร้างเองครั้งแรกที่ใช้
  /// notification: ใช้ตัวเดียวกับ NotificationController ถ้าไม่ได้ inject (D-9)
  StepsController _stepsController() =>
      widget.stepsController ??
      widget.notificationController?.steps ??
      (_ownedStepsController ??= StepsController(
        repository: SharedPrefsStepsRepository(),
        waterHistory: ControllerWaterHistorySource(_controller),
      ));

  /// FoodController ตัวเดียวกันทั้งหน้า food และ dashboard — null = สร้างเองครั้งแรกที่ใช้
  FoodController _foodController() =>
      widget.foodController ??
      widget.notificationController?.food ??
      (_ownedFoodController ??= FoodController(
        repository: SharedPrefsFoodRepository(),
      ));

  /// เปิด S-1 ของ dashboard (docs/dashboard/ui-spec.md §2.0, D-5) — ส่ง controller ตัวเดียวกับ
  /// ที่หน้านี้ส่งให้ steps / food เพื่อให้คะแนนตรงกับข้อมูลจริง
  void _openDashboard() {
    final steps = _stepsController();
    final food = _foodController();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DashboardScreen(
          waterController: _controller,
          stepsController: steps,
          foodController: food,
          animatePet: widget.animatePet,
          // notification ui-spec §2.0 (DECIDED owner 2026-11-08, D-2) — ปุ่มตั้งค่าบน AppBar
          notificationController: widget.notificationController,
          // voice ui-spec §2.2 — ประเมิน/พูดบน dashboard เท่านั้น (V-4)
          voiceController: widget.voiceController,
        ),
      ),
    );
  }

  /// เปิด S-1 ของ 7day (docs/7day/ui-spec.md §2.0, D-5) — controller ตัวเดียวกับที่ส่งให้
  /// steps / food / dashboard (7day ไม่เก็บข้อมูลเอง)
  void _openSevenDay() {
    final steps = _stepsController();
    final food = _foodController();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SevenDayHistoryScreen(
          waterController: _controller,
          stepsController: steps,
          foodController: food,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetPal Health'),
        actions: [
          // ui-spec §2.0: ใช้ IconButton + tooltip แทน TextButton.icon เพราะ AppBar
          // มีปุ่มข้อความไทย 2 ปุ่มจะล้นบนจอแคบ 360 dp
          IconButton(
            key: const Key('steps_entry_button'),
            onPressed: _openSteps,
            icon: const Icon(Icons.directions_walk, size: 24),
            tooltip: StepsRules.entryButtonText,
          ),
          // food ui-spec §2.0: ต่อจาก steps_entry_button ก่อน water_monthly_report_button
          IconButton(
            key: const Key('food_entry_button'),
            onPressed: _openFood,
            icon: const Icon(Icons.restaurant, size: 24),
            tooltip: FoodRules.entryTooltip,
          ),
          // dashboard ui-spec §2.0: ต่อจาก food_entry_button ก่อน water_monthly_report_button
          IconButton(
            key: const Key('dashboard_entry_button'),
            onPressed: _openDashboard,
            icon: const Icon(Icons.dashboard, size: 24),
            tooltip: DashboardRules.entryTooltip,
          ),
          // 7day ui-spec §2.0: ต่อจาก dashboard_entry_button ก่อน water_monthly_report_button
          // DECIDED (owner 7day รอบ 2, Q-1): IconButton ตัวที่ 5 — 5 × 48 = 240 dp ไม่ล้นที่ 360 dp
          // (IconButton ไม่ขยายตาม textScaler · title ตัด ellipsis ตาม default ของ AppBar)
          IconButton(
            key: const Key('seven_day_entry_button'),
            onPressed: _openSevenDay,
            icon: const Icon(Icons.history, size: SevenDayRules.entryIconSize),
            tooltip: SevenDayRules.entryTooltip,
          ),
          // DECIDED (owner dashboard รอบ 3 ข้อ 7): ปุ่มรายงานเป็นปุ่มไอคอน + tooltip
          // 「รายงานรายเดือน」 (key เดิม) — AppBar 4 ปุ่มไอคอนไม่ล้นจอ 360 dp ทุก textScaler
          IconButton(
            key: const Key('water_monthly_report_button'),
            onPressed: _openMonthlyReport,
            icon: const AssetImageOrIcon(
              assetPath: WaterRules.calendarReportIcon,
              fallbackIcon: Icons.calendar_month,
            ),
            tooltip: WaterRules.monthlyReportButtonText,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (!_controller.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildContent(context);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final mood = _controller.mood;
    final percent = _controller.displayEnergyPercentage;
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // signup S-7 แบนเนอร์ต้อนรับ (signup ui-spec §2.7) — แสดงเมื่อได้รับชื่อเท่านั้น
            if (widget.welcomeName != null)
              Text(
                SignupRules.homeWelcomeText(widget.welcomeName!),
                key: const Key('signup_home_welcome_text'),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
            const Spacer(),
            // Pet Avatar / Status (AC-2)
            Center(
              // DECIDED (owner 2026-10-14): ทั้งแอปใช้สัตว์เลี้ยงตัวเดียว = shared
              // PetCharacter (docs/_design/character.md) — ไม่ใช้ PNG
              // ภาพ PNG ตาม game-rules.md §2 อีกต่อไป · ท่าต่ออารมณ์ = WaterLogic.poseFor
              // (ไฟล์เดิมย้ายไป assets/images/legacy/ และไม่ถูก bundle)
              // key ฟีเจอร์ water_pet_image_<mood> อยู่บน wrapper (BUG-PET-1)
              child: KeyedSubtree(
                key: ValueKey('water_pet_image_${mood.name}'),
                child: PetCharacter(
                  key: _petKey,
                  pose: WaterLogic.poseFor(mood),
                  size: 160,
                  animate: widget.animatePet ?? kPetAnimateByDefault,
                  cheerTrigger: _controller.petCheerCount,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              WaterLogic.moodText(mood),
              key: const Key('water_pet_status_text'),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            // Energy Bar (AC-1, EC-1)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                key: const Key('water_energy_bar'),
                value: _controller.displayEnergyFraction,
                minHeight: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_formatPercent(percent)}%',
              key: const Key('water_energy_text'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Water Count Display
            Text(
              WaterRules.waterCountText(_controller.cups),
              key: const Key('water_count_text'),
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            const Spacer(),
            // ปุ่ม "+" (Water Log Button)
            FilledButton.icon(
              key: const Key('water_log_button'),
              onPressed: _onLogPressed,
              icon: const AssetImageOrIcon(
                assetPath: WaterRules.waterPlusIcon,
                fallbackIcon: Icons.add,
              ),
              label: const Text(WaterRules.logButtonText),
            ),
          ],
        ),
      ),
    );
  }

  /// 12.5 → "12.5", 100 → "100"
  static String _formatPercent(double value) {
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(1);
  }
}
