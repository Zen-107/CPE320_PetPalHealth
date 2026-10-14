import 'package:flutter/material.dart';

import '../steps_controller.dart';
import '../steps_logic.dart';
import '../steps_models.dart';
import '../steps_rules.dart';
import '../widgets/steps_toast.dart';

/// S-2 หน้าตั้งเป้าหมายประจำวัน (Daily Goal Settings) — ux-flow.md §2, ui-spec §2.2
class StepsGoalScreen extends StatefulWidget {
  const StepsGoalScreen({super.key, required this.controller});

  final StepsController controller;

  @override
  State<StepsGoalScreen> createState() => _StepsGoalScreenState();
}

class _StepsGoalScreenState extends State<StepsGoalScreen> {
  late int _selected;
  bool _saving = false;

  StepsController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    // ชิปที่เลือกไว้ = เป้าหมายล่าสุดที่บันทึก (ผู้ใช้ใหม่ = DEFAULT_DAILY_GOAL 8,000)
    // ASSUMPTION: ถ้ามีเป้าหมายที่รอมีผลรอบวันถัดไป (AC-4) ให้แสดงค่านั้นเป็นชิปที่เลือก
    _selected = _controller.latestGoal;
    // ASSUMPTION: ui-spec Q-11 — แสดง Toast โควต้าทันทีเมื่อเข้า S-2 ขณะโควต้าหมด
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _controller.isLoaded && !_controller.canChangeGoal) {
        _showQuotaToast();
      }
    });
  }

  void _showQuotaToast() => showStepsToast(
      context, 'steps_goal_quota_toast', StepsRules.goalQuotaMessage);

  Future<void> _onSave() async {
    if (_saving) return;
    setState(() => _saving = true);
    final outcome = await _controller.saveGoal(_selected);
    if (!mounted) return;
    setState(() => _saving = false);
    switch (outcome) {
      case SaveGoalOutcome.quotaExceeded:
        _showQuotaToast();
      case SaveGoalOutcome.storageError:
        showStepsToast(
            context, 'steps_goal_error_toast', StepsRules.goalErrorMessage);
      case SaveGoalOutcome.appliedNow:
      case SaveGoalOutcome.appliedNextDay:
      case SaveGoalOutcome.invalidGoal:
      case SaveGoalOutcome.notReady:
        // ASSUMPTION: ui-spec Q-12 — บันทึกสำเร็จไม่มีข้อความยืนยัน และอยู่ที่ S-2 ต่อ
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('steps_goal_back_button'),
          icon: const Icon(Icons.arrow_back),
          tooltip: StepsRules.backButtonText,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          StepsRules.goalTitle,
          key: Key('steps_goal_header_text'),
        ),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final enabled = _controller.isLoaded && _controller.canChangeGoal;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    Widget group(String keyName, String title, List<int> goals) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, key: Key(keyName), style: titleStyle),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final goal in goals)
                  ChoiceChip(
                    key: Key('steps_goal_chip_$goal'),
                    label: Text(StepsLogic.goalChipText(goal)),
                    selected: _selected == goal,
                    onSelected: enabled
                        ? (_) => setState(() => _selected = goal)
                        : null,
                  ),
              ],
            ),
          ],
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
                  group('steps_goal_group_general', StepsRules.goalGroupGeneral,
                      StepsRules.generalGoals),
                  const SizedBox(height: 24),
                  group('steps_goal_group_weight', StepsRules.goalGroupWeight,
                      StepsRules.weightControlGoals),
                  const SizedBox(height: 24),
                  group('steps_goal_group_athlete', StepsRules.goalGroupAthlete,
                      StepsRules.athleteGoals),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // ปุ่มที่ disabled กดไม่ได้ → ห่อด้วย GestureDetector เพื่อแสดง Toast (ui-spec Q-11)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: enabled ? null : _showQuotaToast,
            child: FilledButton(
              key: const Key('steps_goal_save_button'),
              onPressed: enabled && !_saving ? _onSave : null,
              child: const Text(StepsRules.saveGoalButtonText),
            ),
          ),
        ],
      ),
    );
  }
}
