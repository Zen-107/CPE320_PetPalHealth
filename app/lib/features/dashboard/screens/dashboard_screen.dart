import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:petpal_health/shared/pet/pet.dart';

import '../../food/food_controller.dart';
import '../../food/screens/food_profile_screen.dart';
import '../../food/widgets/food_profile_cta_banner.dart';
import '../../food/widgets/food_shared_min_height_box.dart';
import '../../steps/steps_controller.dart';
import '../../water/water_controller.dart';
import '../dashboard_controller.dart';
import '../dashboard_logic.dart';
import '../dashboard_models.dart';
import '../dashboard_rules.dart';

/// S-1 หน้าจอแดชบอร์ดหลัก — ux-flow §2 S-1, ui-spec §2.1
/// AC-1, AC-2, AC-3, AC-4, AC-5, EC-1..EC-5
///
/// รับ controller ตัวเดียวกับที่หน้า water ใช้ (ui-spec §2.0) — หน้าจอไม่เก็บ/คำนวณข้อมูลเอง
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.waterController,
    required this.stepsController,
    required this.foodController,
    this.animatePet,
    this.timerFactory,
  });

  final WaterController waterController;
  final StepsController stepsController;
  final FoodController foodController;

  /// `PetCharacter.animate` — null = [kPetAnimateByDefault] (แอปจริง animate,
  /// ระหว่าง flutter test เป็นภาพนิ่ง)
  final bool? animatePet;

  /// Timer หมุนข้อความ (alertInterval) — null = `Timer` จริง (widget test ใช้ `pump(Duration)`)
  final DashboardTimerFactory? timerFactory;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  // PetCharacter มีตัวตนคงที่ข้ามการเปลี่ยนอารมณ์ (BUG-PET-1) — key ฟีเจอร์อยู่บน KeyedSubtree
  final GlobalKey _petKey = GlobalKey(debugLabel: 'dashboard_pet');

  late final DashboardController _controller;
  Timer? _dayTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = DashboardController(
      water: widget.waterController,
      steps: widget.stepsController,
      food: widget.foodController,
      timerFactory: widget.timerFactory,
    );
    _controller.start();
    // ui-spec §3 ข้ามช่วงเวลา: ตรวจรอบวัน 05:00 ของทั้ง 3 controller ขณะเปิดหน้าค้าง (EC-3)
    _dayTimer = Timer.periodic(
      const Duration(seconds: DashboardRules.dayCheckIntervalSeconds),
      (_) => _controller.refreshDay(),
    );
  }

  @override
  void dispose() {
    _dayTimer?.cancel();
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// CTA → S-3 ตั้งโปรไฟล์ของ food (FoodController ตัวเดียวกัน — บันทึกแล้วคะแนนอาหารขึ้นทันที)
  void _openFoodProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FoodProfileScreen(controller: widget.foodController),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _controller.refreshDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          DashboardRules.screenTitle,
          key: Key('dashboard_header_text'),
        ),
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final s = _controller.snapshot;

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
                    // #1 Total Score Card (AC-1, EC-1, EC-5)
                    Container(
                      key: const Key('dashboard_total_score_card'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        DashboardRules.totalScoreText(s.totalScore),
                        key: const Key('dashboard_total_score_text'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // #3 Dynamic Alert Banner (AC-3, EC-2)
                    _buildAlertSlot(context, _controller.currentAlert),
                    // #4 ระยะ anchor
                    const SizedBox(height: DashboardRules.alertAnchorOffset),
                    // #5 Pet Character Display (AC-2) — D-1: PetCharacter ไม่ใช่ PNG
                    // ไม่ส่ง cheerTrigger (Q-20) — CHEERFUL กระโดดวนเองจาก preset
                    Center(
                      child: KeyedSubtree(
                        key: ValueKey('dashboard_pet_image_${s.mood.keyName}'),
                        child: PetCharacter(
                          key: _petKey,
                          pose: DashboardLogic.poseFor(s.mood),
                          size: DashboardRules.petSize,
                          animate: widget.animatePet ?? kPetAnimateByDefault,
                          semanticLabel: s.mood.label,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // #7 Food Progress Bar (AC-4) — แดงเมื่อ Priority 1
                    _buildBarRow(
                      context,
                      name: 'food',
                      label: s.foodScore == null
                          ? DashboardRules.foodNoTargetText
                          : DashboardRules.foodScoreText(s.foodScore!),
                      labelColor:
                          s.foodScore == null ? scheme.onSurfaceVariant : null,
                      score: s.foodScore ?? DashboardRules.minScore,
                      color: s.isFoodOverLimit ? scheme.error : scheme.primary,
                    ),
                    // DECIDED (owner รอบ 3 ข้อ 5): ไม่มีเป้าอาหาร → ใช้ CTA Banner เดิมของ food
                    // (FoodProfileCtaBanner — keys `food_profile_cta_banner` ฯลฯ) พาไป S-3
                    // ASSUMPTION: วางใต้แถบอาหาร ห่าง 8 (ระยะในแถวเดียวกัน ui-spec §2.1.2) และคงป้าย
                    // 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 + แถบ 0 ไว้ตาม ui-spec §3 (Q-1) — ui-spec ไม่มีตำแหน่ง CTA
                    if (!s.hasFoodScore) ...[
                      const SizedBox(height: 8),
                      FoodProfileCtaBanner(
                        totalText: widget.foodController.ctaTotalText,
                        onTap: _openFoodProfile,
                      ),
                    ],
                    const SizedBox(height: 16),
                    // #9 Steps Progress Bar (AC-4)
                    _buildBarRow(
                      context,
                      name: 'steps',
                      label: DashboardRules.stepsScoreText(s.stepsScore),
                      score: s.stepsScore,
                      color: scheme.primary,
                    ),
                    const SizedBox(height: 16),
                    // #11 Water Progress Bar (AC-4)
                    _buildBarRow(
                      context,
                      name: 'water',
                      label: DashboardRules.waterScoreText(s.waterScore),
                      score: s.waterScore,
                      color: scheme.primary,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ui-spec §2.1.1 — ช่องจองที่สูงเท่าฟองข้อความ Priority 1 (ยาวสุด) ที่ความกว้าง/textScaler จริง
  /// ไม่ล็อกความสูงคงที่ (บทเรียน food BUG-FOOD-1/2) · คิวว่าง = ไม่มีฟองแต่ยังจองที่ (Q-10)
  // ASSUMPTION: ui-spec เสนอ Stack + Visibility(maintainSize) ที่มีข้อความ Priority 1 ซ่อนอยู่ แต่
  // วิธีนั้นทำให้ข้อความ P1 อยู่ใน widget tree เสมอ (find.text เจอ 2 ตัวตอน P1 แสดง / เจอแม้คิวว่าง)
  // จึงวัดความสูงฟอง P1 ด้วย TextPainter แล้วใช้เป็น "ความสูงขั้นต่ำ" ผ่าน FoodSharedMinHeightBox
  // (ของเดิมของ food — รองรับ IntrinsicHeight) ผลบนจอเท่ากัน: ช่องสูงเท่าฟอง P1 เสมอ และโตได้ถ้าจำเป็น
  Widget _buildAlertSlot(BuildContext context, DashboardAlert? alert) {
    return FoodSharedMinHeightBox(
      key: const Key('dashboard_alert_slot'),
      minHeightFor: _alertSlotMinHeightFor(context),
      child: alert == null
          ? const SizedBox.shrink()
          : Center(
              child: SizedBox(
                width: double.infinity,
                child: _AlertBubble(
                  key: const Key('dashboard_alert_banner'),
                  textKey: const Key('dashboard_alert_text'),
                  message: alert.text,
                ),
              ),
            ),
    );
  }

  /// ความสูงฟองข้อความ Priority 1 ที่ความกว้าง [width] (padding 16/8 + ข้อความ bodyMedium)
  MinHeightForWidth _alertSlotMinHeightFor(BuildContext context) {
    final theme = Theme.of(context);
    final base = DefaultTextStyle.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    final locale = Localizations.maybeLocaleOf(context);
    return (width) {
      final painter = TextPainter(
        text: TextSpan(
          text: DashboardAlert.overeating.text,
          style: base.style.merge(theme.textTheme.bodyMedium),
        ),
        textAlign: TextAlign.center,
        textDirection: direction,
        textScaler: scaler,
        locale: locale,
        textHeightBehavior: base.textHeightBehavior,
        textWidthBasis: base.textWidthBasis,
      )..layout(maxWidth: math.max(0, width - _AlertBubble.padH * 2));
      final h = painter.height + _AlertBubble.padV * 2;
      painter.dispose();
      return h;
    };
  }

  /// ui-spec §2.1.2 แถวแถบรายหมวด
  Widget _buildBarRow(
    BuildContext context, {
    required String name,
    required String label,
    required int score,
    required Color color,
    Color? labelColor,
  }) {
    return Column(
      key: Key('dashboard_${name}_row'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          key: Key('dashboard_${name}_label_text'),
          textAlign: TextAlign.start,
          style: labelColor == null ? null : TextStyle(color: labelColor),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            key: Key('dashboard_${name}_bar'),
            value: (score / DashboardRules.maxScore).clamp(0.0, 1.0),
            minHeight: DashboardRules.barMinHeight,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// ฟองข้อความแจ้งเตือน (ui-spec §2.1.1) — ไม่มี maxLines / ellipsis
class _AlertBubble extends StatelessWidget {
  const _AlertBubble({super.key, required this.message, this.textKey});

  /// ui-spec §1.3 padding ในกล่อง แนวนอน 16 แนวตั้ง 8
  static const double padH = 16;
  static const double padV = 8;

  final String message;
  final Key? textKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        key: textKey,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: scheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
