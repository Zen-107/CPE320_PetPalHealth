import 'package:flutter/material.dart';

import '../water_controller.dart';
import '../water_logic.dart';
import '../water_models.dart';
import '../water_rules.dart';

/// S-2 หน้าจอรายงานรายเดือน (Monthly Report) — ux-flow.md §2, AC-6
class MonthlyReportScreen extends StatelessWidget {
  const MonthlyReportScreen({super.key, required this.controller});

  final WaterController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('water_report_back_button'),
          icon: const Icon(Icons.arrow_back),
          tooltip: WaterRules.backButtonText,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(WaterRules.monthlyReportHeader),
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => _buildBody(context, controller.monthlyReport()),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MonthlyWaterReport report) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            WaterRules.monthlyAverageText(
              WaterLogic.formatAverage(report.average),
            ),
            key: const Key('water_monthly_average_text'),
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: report.isEmpty
                ? const Center(
                    child: Text(
                      WaterRules.monthlyEmptyText,
                      key: Key('water_monthly_empty_text'),
                    ),
                  )
                : ListView.separated(
                    key: const Key('water_monthly_history_list'),
                    itemCount: report.records.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final record = report.records[index];
                      return ListTile(
                        // DECIDED: Zen-107 2026-10-08 — วันที่รูปแบบ dd/MM/yyyy
                        // (ux-flow.md S-2)
                        title: Text(
                          WaterLogic.formatHistoryDate(record.date),
                          key: ValueKey(
                            'water_history_date_${formatDateKey(record.date)}',
                          ),
                        ),
                        trailing: Text('${record.cups} แก้ว'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
