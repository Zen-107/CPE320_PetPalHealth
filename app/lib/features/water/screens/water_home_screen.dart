import 'dart:async';

import 'package:flutter/material.dart';
import 'package:petpal_health/shared/pet/pet.dart';

import '../../signup/signup_rules.dart';
import '../../steps/screens/steps_dashboard_screen.dart';
import '../../steps/steps_controller.dart';
import '../../steps/steps_external.dart';
import '../../steps/steps_repository.dart';
import '../../steps/steps_rules.dart';
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
    this.animatePet,
    this.welcomeName,
  });

  final WaterController controller;

  /// `PetCharacter.animate` — null = [kPetAnimateByDefault] (แอปจริง animate,
  /// ระหว่าง flutter test เป็นภาพนิ่ง)
  final bool? animatePet;

  /// ทางเข้าฟีเจอร์ steps (docs/steps/ui-spec.md §2.0) — null = สร้างเองเมื่อกดปุ่มครั้งแรก
  final StepsController? stepsController;

  /// signup S-7 แบนเนอร์ต้อนรับ (docs/signup/ui-spec.md §2.7) — Display Name ที่
  /// ประมวลผลแล้ว (AC-5); null = ไม่แสดงแบนเนอร์ (พฤติกรรมเดิมของ water)
  final String? welcomeName;

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

  // ASSUMPTION: ตรวจรีเซ็ต 05:00 น. ทุก 1 นาทีระหว่างเปิดแอปค้างไว้
  // (AC-5 กำหนดเฉพาะตอนเปิดแอป ส่วนนี้ทำให้หน้าจอรีเซ็ตเองแม้แอปเปิดค้างข้าม 05:00 น.)
  static const Duration _resetCheckInterval = Duration(minutes: 1);

  WaterController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!_controller.isLoaded) {
      _controller.load();
    } else {
      _controller.refreshDailyReset();
    }
    _resetTimer = Timer.periodic(
      _resetCheckInterval,
      (_) => _controller.refreshDailyReset(),
    );
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _ownedStepsController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // กลับมาเปิดแอปอีกครั้ง → ตรวจรีเซ็ตทันที (AC-5, EC-2)
    if (state == AppLifecycleState.resumed) {
      _controller.refreshDailyReset();
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
    final steps = widget.stepsController ??
        (_ownedStepsController ??= StepsController(
          repository: SharedPrefsStepsRepository(),
          waterHistory: ControllerWaterHistorySource(_controller),
        ));
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StepsDashboardScreen(controller: steps),
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
          TextButton.icon(
            key: const Key('water_monthly_report_button'),
            onPressed: _openMonthlyReport,
            icon: const AssetImageOrIcon(
              assetPath: WaterRules.calendarReportIcon,
              fallbackIcon: Icons.calendar_month,
            ),
            label: const Text(WaterRules.monthlyReportButtonText),
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
