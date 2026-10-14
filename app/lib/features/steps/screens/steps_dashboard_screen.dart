import 'dart:async';

import 'package:flutter/material.dart';

import '../../water/widgets/asset_image_or_icon.dart';
import '../steps_controller.dart';
import '../steps_logic.dart';
import '../steps_rules.dart';
import '../widgets/steps_pet_avatar.dart';
import 'steps_goal_screen.dart';
import 'steps_monthly_report_screen.dart';

/// S-1 หน้าหลักแดชบอร์ดก้าวเดิน (Steps Dashboard) — ux-flow.md §2, ui-spec §2.1
class StepsDashboardScreen extends StatefulWidget {
  const StepsDashboardScreen({
    super.key,
    required this.controller,
    this.onOpenSettings,
    this.reportCapture,
  });

  final StepsController controller;

  /// Shortcut ไปหน้า Settings ของเครื่อง (EC-1, EC-6)
  // ASSUMPTION: MVP ไม่มีเซนเซอร์/สิทธิ์จริง (ui-spec D-1, Q-4) และไม่เพิ่ม package
  // เปิดหน้า Settings — ค่าเริ่มต้นจึงแค่ปิด Pop-up; inject ได้เมื่อมีการเชื่อมต่อจริง
  final Future<void> Function()? onOpenSettings;

  /// ส่งต่อให้ S-3 (ใช้แทนการจับภาพจริงในเทสต์)
  final StepsReportCapture? reportCapture;

  @override
  State<StepsDashboardScreen> createState() => _StepsDashboardScreenState();
}

class _StepsDashboardScreenState extends State<StepsDashboardScreen>
    with WidgetsBindingObserver {
  // ASSUMPTION: ตรวจรอบวันทุก 1 วินาทีขณะเปิดหน้าค้าง เพื่อรีเซ็ต ณ 05:00:00 (AC-6, EC-5)
  // โดยไม่ต้อง Restart — เอกสารไม่กำหนดความถี่ (ตรวจเป็นเพียงการเทียบวันที่ ไม่หนัก)
  static const Duration _dayCheckInterval = Duration(seconds: 1);

  Timer? _dayTimer;
  bool _sensorDialogOpen = false;
  bool _wasLocked = false;

  StepsController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.addListener(_onControllerChanged);
    if (!_controller.isLoaded) {
      _controller.load();
    } else {
      _controller.refreshDay();
      WidgetsBinding.instance.addPostFrameCallback((_) => _onControllerChanged());
    }
    _dayTimer =
        Timer.periodic(_dayCheckInterval, (_) => _controller.refreshDay());
  }

  @override
  void dispose() {
    _dayTimer?.cancel();
    _controller.removeListener(_onControllerChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller.refreshDay();
      _wasLocked = false; // กลับจาก Settings แล้วยังล็อกอยู่ → แสดง Pop-up อีกครั้ง
      _onControllerChanged();
    }
  }

  /// แสดง Pop-up เมื่อถูกล็อก (EC-1, EC-6) — แสดงครั้งเดียวต่อการเข้าสู่สถานะล็อก
  void _onControllerChanged() {
    if (!mounted || !_controller.isLoaded) return;
    final locked = _controller.isTrackingLocked;
    if (locked && !_wasLocked && !_sensorDialogOpen) {
      _wasLocked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _showSensorDialog());
    } else if (!locked) {
      _wasLocked = false;
    }
  }

  Future<void> _showSensorDialog() async {
    if (!mounted || _sensorDialogOpen) return;
    _sensorDialogOpen = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        key: const Key('steps_sensor_error_dialog'),
        title: const Text(StepsRules.sensorErrorTitle),
        content: const Text(StepsRules.sensorErrorContent),
        actions: [
          FilledButton(
            key: const Key('steps_open_settings_button'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              widget.onOpenSettings?.call();
            },
            child: const Text(StepsRules.openSettingsButtonText),
          ),
        ],
      ),
    );
    _sensorDialogOpen = false;
  }

  Future<void> _onAddPressed() async {
    await _controller.addSteps();
  }

  void _openGoal() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StepsGoalScreen(controller: _controller),
      ),
    );
  }

  void _openReport() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StepsMonthlyReportScreen(
          controller: _controller,
          capture: widget.reportCapture,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text(
            StepsRules.dashboardTitle,
            key: Key('steps_header_text'),
          ),
          actions: [
            if (_controller.isOffline)
              Tooltip(
                message: StepsRules.offlineTooltip,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    Icons.cloud_off,
                    key: const Key('steps_offline_icon'),
                    size: 24,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
        body: !_controller.isLoaded
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  // พื้นหลัง (ux-flow §5) — ไม่มีไฟล์ก็ใช้พื้น surface ตามปกติ
                  Positioned.fill(
                    child: Image.asset(
                      StepsRules.dashboardBackground,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                  _buildContent(context),
                ],
              ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final status = _controller.petStatus;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    // รูปสัตว์เลี้ยง (AC-5)
                    Center(
                      child: StepsPetAvatar(
                        key: StepsPetAvatar.imageKey(status),
                        status: status,
                        size: 160,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // ป้ายสถานะ (AC-5)
                    Center(
                      child: Container(
                        key: const Key('steps_status_badge'),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: scheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          StepsLogic.statusText(status),
                          style: theme.textTheme.titleMedium
                              ?.copyWith(color: scheme.onSecondaryContainer),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // หลอดพลังงาน (AC-5, AC-6)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        key: const Key('steps_energy_bar'),
                        value: _controller.energyBarFraction,
                        minHeight: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _controller.percentText,
                      key: const Key('steps_percent_text'),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _controller.countText,
                      key: const Key('steps_count_text'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall,
                    ),
                    const Spacer(),
                    // ปุ่มเพิ่มก้าวด้วยมือ (ui-spec D-1) — ล็อกเมื่อ EC-1/EC-6
                    FilledButton.icon(
                      key: const Key('steps_add_button'),
                      onPressed:
                          _controller.isTrackingLocked ? null : _onAddPressed,
                      icon: const Icon(Icons.directions_walk),
                      label: const Text(StepsRules.addStepsButtonText),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            key: const Key('steps_set_goal_button'),
                            onPressed: _openGoal,
                            icon: const AssetImageOrIcon(
                              assetPath: StepsRules.targetIcon,
                              fallbackIcon: Icons.flag,
                            ),
                            label: const Text(StepsRules.setGoalButtonText),
                          ),
                        ),
                        Expanded(
                          child: TextButton.icon(
                            key: const Key('steps_monthly_report_button'),
                            onPressed: _openReport,
                            icon: const AssetImageOrIcon(
                              assetPath: StepsRules.reportIcon,
                              fallbackIcon: Icons.bar_chart,
                            ),
                            label:
                                const Text(StepsRules.monthlyReportButtonText),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
