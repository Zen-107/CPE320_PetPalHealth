import 'dart:async';

import 'package:flutter/material.dart';

import '../water_controller.dart';
import '../water_logic.dart';
import '../water_models.dart';
import '../water_rules.dart';
import '../widgets/asset_image_or_icon.dart';
import '../widgets/pet_avatar.dart';
import 'monthly_report_screen.dart';

/// S-1 หน้าจอหลัก (Home / Water Tracker) — ux-flow.md §2
class WaterHomeScreen extends StatefulWidget {
  const WaterHomeScreen({super.key, required this.controller});

  final WaterController controller;

  @override
  State<WaterHomeScreen> createState() => _WaterHomeScreenState();
}

class _WaterHomeScreenState extends State<WaterHomeScreen>
    with WidgetsBindingObserver {
  Timer? _resetTimer;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetPal Health'),
        actions: [
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
            const Spacer(),
            // Pet Avatar / Status (AC-2)
            Center(
              // วาดด้วย CustomPainter หรือใช้ PNG ถ้ามี (game-rules.md §2)
              child: PetAvatar(
                key: ValueKey('water_pet_image_${mood.name}'),
                mood: mood,
                size: 160,
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
