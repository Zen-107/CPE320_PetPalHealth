import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../steps_controller.dart';
import '../steps_logic.dart';
import '../steps_models.dart';
import '../steps_rules.dart';

/// จับภาพ PNG จาก RepaintBoundary — inject ได้เพื่อให้เทสต์ไม่ต้องเรนเดอร์ภาพจริง
typedef StepsReportCapture = Future<Uint8List> Function(
    RenderRepaintBoundary boundary);

/// จับภาพจริงด้วย `RenderRepaintBoundary.toImage()` → PNG (AC-7)
Future<Uint8List> captureBoundaryPng(
  RenderRepaintBoundary boundary, {
  double pixelRatio = 2,
}) async {
  final image = await boundary.toImage(pixelRatio: pixelRatio);
  try {
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    if (data == null) throw StateError('PNG encode failed');
    return data.buffer.asUint8List();
  } finally {
    image.dispose();
  }
}

/// S-3 หน้ารายงานสรุปผลรายเดือน (Monthly Report Export) — ux-flow.md §2, ui-spec §2.3
class StepsMonthlyReportScreen extends StatefulWidget {
  const StepsMonthlyReportScreen({
    super.key,
    required this.controller,
    this.capture,
  });

  final StepsController controller;

  /// null = จับภาพจริงด้วย [captureBoundaryPng]
  final StepsReportCapture? capture;

  @override
  State<StepsMonthlyReportScreen> createState() =>
      _StepsMonthlyReportScreenState();
}

class _StepsMonthlyReportScreenState extends State<StepsMonthlyReportScreen> {
  final GlobalKey _captureContentKey = GlobalKey();
  bool _exporting = false;

  StepsController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  /// โหลดข้อมูลล่าสุด (รอบวัน + น้ำจาก water) — ไม่สำเร็จ → Pop-up (ux-flow S-3 Error)
  Future<void> _reload() async {
    if (!_controller.isLoaded) await _controller.load();
    await _controller.refreshDay();
    final ok = await _controller.refreshWaterHistory();
    if (!ok && mounted) await _showError(retry: _reload);
  }

  Future<void> _export() async {
    if (_exporting) return;
    setState(() => _exporting = true);
    var failed = false;
    try {
      // รอให้ frame ที่แสดงสถานะ "กำลังสร้างรายงาน..." วาดเสร็จก่อนจับภาพ
      await WidgetsBinding.instance.endOfFrame;
      final boundary = _captureContentKey.currentContext
          ?.findAncestorRenderObjectOfType<RenderRepaintBoundary>();
      if (boundary == null) throw StateError('report boundary not found');
      final capture = widget.capture ?? captureBoundaryPng;
      final bytes = await capture(boundary);
      await _controller.exportMonthlyReportPng(bytes);
    } catch (_) {
      failed = true;
    }
    if (!mounted) return;
    setState(() => _exporting = false);
    // ASSUMPTION: ui-spec Q-14 — export สำเร็จไม่แสดงข้อความ (ux-flow ไม่กำหนด)
    if (failed) await _showError(retry: _export);
  }

  Future<void> _showError({required Future<void> Function() retry}) async {
    final shouldRetry = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        key: const Key('steps_report_error_dialog'),
        content: const Text(StepsRules.exportErrorMessage),
        actions: [
          FilledButton(
            key: const Key('steps_report_retry_button'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(StepsRules.retryButtonText),
          ),
        ],
      ),
    );
    if (shouldRetry == true && mounted) await retry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('steps_report_back_button'),
          icon: const Icon(Icons.arrow_back),
          tooltip: StepsRules.backButtonText,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          StepsRules.reportTitle,
          key: Key('steps_report_header_text'),
        ),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) =>
            _buildBody(context, _controller.monthlyReport()),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MonthlyStepsReport report) {
    final theme = Theme.of(context);
    final valueStyle = theme.textTheme.titleLarge;

    // ค่าใน trailing จำกัดไม่เกินครึ่งความกว้างการ์ดและย่อตัวอักษรเมื่อยาวเกิน
    // เพื่อไม่ให้ ListTile ล้นบนจอแคบ 360 dp (ui-spec §5)
    Widget row(String label, String valueKey, String value) => LayoutBuilder(
          builder: (context, constraints) => ListTile(
            title: Text(label),
            trailing: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: constraints.maxWidth * 0.5),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(value, key: Key(valueKey), style: valueStyle),
              ),
            ),
          ),
        );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // พื้นที่ที่ export เป็น PNG (สิ่งที่ export = สิ่งที่เห็น)
                  RepaintBoundary(
                    key: const Key('steps_report_capture'),
                    child: Container(
                      key: _captureContentKey,
                      color: theme.colorScheme.surface,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(StepsRules.reportTitle,
                              style: theme.textTheme.titleLarge),
                          const SizedBox(height: 16),
                          Card(
                            key: const Key('steps_report_summary_card'),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                row(
                                  StepsRules.reportTotalStepsLabel,
                                  'steps_report_total_steps',
                                  '${StepsLogic.formatThousands(report.totalSteps)} '
                                      '${StepsRules.stepsUnit}',
                                ),
                                const Divider(height: 1),
                                row(
                                  StepsRules.reportTotalWaterLabel,
                                  'steps_report_total_water',
                                  '${StepsLogic.formatThousands(report.totalWaterCups)} '
                                      '${StepsRules.waterUnit}',
                                ),
                                const Divider(height: 1),
                                row(
                                  StepsRules.reportAverageLabel,
                                  'steps_report_avg_steps',
                                  '${StepsLogic.formatAverage(report.averageDailySteps)} '
                                      '${StepsRules.averageUnit}',
                                ),
                                const Divider(height: 1),
                                row(
                                  StepsRules.reportGoalDaysLabel,
                                  'steps_report_goal_days',
                                  '${report.goalAchievedDays} '
                                      '${StepsRules.daysUnit}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (report.isEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      StepsRules.reportEmptyText,
                      key: Key('steps_report_empty_text'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            key: const Key('steps_report_export_button'),
            onPressed: _exporting ? null : _export,
            icon: _exporting
                ? const SizedBox(
                    key: Key('steps_report_exporting_indicator'),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download),
            label: Text(_exporting
                ? StepsRules.exportingText
                : StepsRules.exportButtonText),
          ),
        ],
      ),
    );
  }
}
