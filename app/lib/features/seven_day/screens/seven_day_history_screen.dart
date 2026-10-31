import 'package:flutter/material.dart';

import '../../food/food_controller.dart';
import '../../steps/steps_controller.dart';
import '../../water/water_controller.dart';
import '../seven_day_controller.dart';
import '../seven_day_logic.dart';
import '../seven_day_models.dart';
import '../seven_day_rules.dart';

/// S-1 หน้าประวัติสุขภาพ 7 วัน — ux-flow §2 S-1, ui-spec §2.1
/// AC-1..AC-6, EC-1..EC-5
///
/// รับ controller ตัวเดียวกับที่หน้า water ส่งให้ steps / food / dashboard (ui-spec §2.0, D-5)
/// หน้าจอไม่เก็บ/คำนวณข้อมูลเอง — ค่าทั้งหมดจาก SevenDayLogic
/// ไม่มีสัตว์เลี้ยง (requirements §5, D-6) · ไม่มี UI ออฟไลน์ (D-2)
class SevenDayHistoryScreen extends StatefulWidget {
  const SevenDayHistoryScreen({
    super.key,
    required this.waterController,
    required this.stepsController,
    required this.foodController,
    this.clock,
    this.timerFactory,
  });

  final WaterController waterController;
  final StepsController stepsController;
  final FoodController foodController;

  /// นาฬิกาสำรอง — ใช้เฉพาะตอน steps / food ยังไม่มีรอบวัน (null = DateTime.now)
  final SevenDayClock? clock;

  /// Timer ตรวจรอบวันทุก 1 วินาที — null = `Timer.periodic` จริง (widget test ใช้ `pump(Duration)`)
  final SevenDayPeriodicTimerFactory? timerFactory;

  @override
  State<SevenDayHistoryScreen> createState() => _SevenDayHistoryScreenState();
}

class _SevenDayHistoryScreenState extends State<SevenDayHistoryScreen>
    with WidgetsBindingObserver {
  late final SevenDayController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = SevenDayController(
      water: widget.waterController,
      steps: widget.stepsController,
      food: widget.foodController,
      clock: widget.clock,
      timerFactory: widget.timerFactory,
    );
    _controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // ui-spec §1.3 ตรวจรอบวันเมื่อแอป resume (EC-4)
    if (state == AppLifecycleState.resumed) _controller.refreshDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          SevenDayRules.screenTitle,
          key: Key('seven_day_header_text'),
        ),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (!_controller.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildContent(context, _controller.snapshot);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, SevenDaySnapshot s) {
    return SafeArea(
      // ใช้ SingleChildScrollView + Column (ไม่ใช่ ListView.builder) — การ์ดทั้ง 7 อยู่ใน tree (ui-spec §2.1)
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // #1 SUMMARY_CARD / #2 EMPTY_STATE_CONTAINER (AC-6, EC-3 — ซ่อน summary: Q-3)
              if (s.isEmpty)
                const _EmptyState()
              else
                _SummaryCard(snapshot: s),
              const SizedBox(height: 16),
              // #3 DAY_CARD_0 … DAY_CARD_6 (AC-1) — key ตาม Day 0 → ข้ามรอบแล้วกลับค่าเริ่มต้น (EC-4)
              KeyedSubtree(
                key: ValueKey(SevenDayLogic.windowKey(s.today)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final e in s.days) ...[
                      if (e.offset > 0) const SizedBox(height: 8),
                      _DayCard(entry: e),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ui-spec §2.1.1 SUMMARY_CARD — ไม่มี maxLines / ไม่ล็อกความสูง
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.snapshot});

  final SevenDaySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final s = snapshot;
    final lineStyle =
        theme.textTheme.bodyLarge?.copyWith(color: scheme.onPrimaryContainer);
    final coachingStyle =
        theme.textTheme.bodyMedium?.copyWith(color: scheme.onPrimaryContainer);
    final waterLine = SevenDayLogic.lowWaterText(s);
    final stepsLine = SevenDayLogic.lowStepsText(s);

    // coaching เรียง prefix → น้ำ → ก้าว คั่น 4 (ui-spec §2.1.1 e/f/g)
    final coaching = <Widget>[
      if (s.showsInconsistentPrefix)
        Text(
          SevenDayRules.prefixInconsistent,
          key: const Key('seven_day_coaching_prefix_text'),
          style: coachingStyle,
        ),
      if (waterLine != null)
        Text(
          waterLine,
          key: const Key('seven_day_coaching_water_text'),
          style: coachingStyle,
        ),
      if (stepsLine != null)
        Text(
          stepsLine,
          key: const Key('seven_day_coaching_steps_text'),
          style: coachingStyle,
        ),
    ];

    return Container(
      key: const Key('seven_day_summary_card'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            SevenDayRules.summaryTitle,
            key: const Key('seven_day_summary_title_text'),
            style: theme.textTheme.titleMedium
                ?.copyWith(color: scheme.onPrimaryContainer),
          ),
          const SizedBox(height: 8),
          Text(
            SevenDayLogic.avgWaterText(s),
            key: const Key('seven_day_avg_water_text'),
            style: lineStyle,
          ),
          Text(
            SevenDayLogic.avgStepsText(s),
            key: const Key('seven_day_avg_steps_text'),
            style: lineStyle,
          ),
          Text(
            SevenDayLogic.avgFoodText(s),
            key: const Key('seven_day_avg_food_text'),
            style: lineStyle,
          ),
          if (coaching.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (var i = 0; i < coaching.length; i++) ...[
              if (i > 0) const SizedBox(height: 4),
              coaching[i],
            ],
          ],
        ],
      ),
    );
  }
}

/// ui-spec §2.1.2 EMPTY_STATE_CONTAINER (เฉพาะ EMPTY) — ไอคอนกล่องเปล่าแทน PNG (Q-6) ไม่มีสัตว์เลี้ยง
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      key: const Key('seven_day_empty_state'),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_outlined,
            key: const Key('seven_day_empty_icon'),
            size: SevenDayRules.emptyIconSize,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            SevenDayRules.statusEmpty7Days,
            key: const Key('seven_day_empty_text'),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

/// ui-spec §2.1.3 DAY_CARD — Accordion 250 ms (D-1) · Day 0 ขยาย อีก 6 พับ (AC-1)
/// สถานะพับ/ขยายเก็บใน State ของการ์ด — ออกจากหน้า / ข้ามรอบ = ค่าเริ่มต้น · แต่ละใบอิสระ (Q-15)
class _DayCard extends StatefulWidget {
  const _DayCard({required this.entry});

  final SevenDayEntry entry;

  @override
  State<_DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<_DayCard> {
  late bool _expanded = widget.entry.isToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final e = widget.entry;
    final i = e.offset;
    final mutedStyle =
        theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant);

    return Card(
      key: Key('seven_day_day_card_$i'),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        key: Key('seven_day_day_tile_$i'),
        initiallyExpanded: e.isToday,
        expansionAnimationStyle:
            const AnimationStyle(duration: SevenDayRules.accordionDuration),
        shape: const Border(),
        collapsedShape: const Border(),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.centerLeft,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        onExpansionChanged: (value) => setState(() => _expanded = value),
        title: Text(
          SevenDayLogic.dayTitle(e),
          key: Key('seven_day_day_title_$i'),
          style: theme.textTheme.titleMedium,
        ),
        // แถบสรุปเฉพาะตอนพับ (ui-spec §2.1.3, Q-14)
        subtitle: _expanded
            ? null
            : Text(
                SevenDayLogic.collapsedSummary(e),
                key: Key('seven_day_day_summary_$i'),
                style: mutedStyle,
              ),
        children: [
          Column(
            key: Key('seven_day_day_body_$i'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: e.hasRecord
                ? _recordLines(context, e)
                : [
                    // AC-2 วันไม่มีบันทึก
                    Text(
                      SevenDayRules.statusNoDailyData,
                      key: Key('seven_day_day_no_data_$i'),
                      style: mutedStyle,
                    ),
                  ],
          ),
        ],
      ),
    );
  }

  List<Widget> _recordLines(BuildContext context, SevenDayEntry e) {
    final i = e.offset;
    final style = Theme.of(context).textTheme.bodyMedium;
    return [
      Text(
        SevenDayLogic.dayStepsText(e),
        key: Key('seven_day_day_steps_$i'),
        style: style,
      ),
      const SizedBox(height: 8),
      Text(
        SevenDayLogic.dayWaterText(e),
        key: Key('seven_day_day_water_$i'),
        style: style,
      ),
      const SizedBox(height: 8),
      Text(
        SevenDayLogic.dayFoodText(e),
        key: Key('seven_day_day_food_$i'),
        style: style,
      ),
      if (e.hasTags) ...[
        const SizedBox(height: 8),
        Wrap(
          key: Key('seven_day_day_tags_$i'),
          spacing: 8,
          runSpacing: 8,
          children: [
            if (e.highSodium)
              _Tag(
                key: Key('seven_day_tag_high_sodium_$i'),
                text: SevenDayRules.tagHighSodium,
              ),
            if (e.highSugar)
              _Tag(
                key: Key('seven_day_tag_high_sugar_$i'),
                text: SevenDayRules.tagHighSugar,
              ),
            if (e.overeating)
              _Tag(
                key: Key('seven_day_tag_overeating_$i'),
                text: SevenDayRules.tagOvereating,
              ),
          ],
        ),
      ],
    ];
  }
}

/// ป้ายเตือนพิเศษ (ui-spec §1.1, §1.3) — errorContainer, padding 8/4, มุม 8
class _Tag extends StatelessWidget {
  const _Tag({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelLarge
            ?.copyWith(color: scheme.onErrorContainer),
      ),
    );
  }
}
