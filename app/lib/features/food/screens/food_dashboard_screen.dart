import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:petpal_health/shared/pet/pet.dart';

import '../food_controller.dart';
import '../food_logic.dart';
import '../food_rules.dart';
import '../widgets/food_profile_cta_banner.dart';
import '../widgets/food_shared_min_height_box.dart';
import '../widgets/food_toast.dart';
import 'food_meal_screen.dart';
import 'food_profile_screen.dart';

/// S-1 หน้าหลักแดชบอร์ดสัตว์เลี้ยงและโภชนาการ — ux-flow §2 S-1, ui-spec §2.1
/// AC-8, AC-9, AC-10, AC-11, AC-12, EC-2, EC-3, EC-4
class FoodDashboardScreen extends StatefulWidget {
  const FoodDashboardScreen({
    super.key,
    required this.controller,
    this.animatePet,
  });

  final FoodController controller;

  /// `PetCharacter.animate` — null = [kPetAnimateByDefault] (แอปจริง animate,
  /// ระหว่าง flutter test เป็นภาพนิ่ง)
  final bool? animatePet;

  @override
  State<FoodDashboardScreen> createState() => _FoodDashboardScreenState();
}

class _FoodDashboardScreenState extends State<FoodDashboardScreen>
    with WidgetsBindingObserver {
  // PetCharacter มีตัวตนคงที่ข้ามการเปลี่ยนสถานะ (BUG-PET-1) — key ฟีเจอร์อยู่บน KeyedSubtree
  final GlobalKey _petKey = GlobalKey(debugLabel: 'food_pet');

  // ASSUMPTION: ตรวจรอบวันทุก 1 วินาทีขณะเปิดหน้าค้าง (game-rules §4 Foreground Crossing)
  // เอกสารไม่กำหนดความถี่ — แบบเดียวกับ steps
  static const Duration _dayCheckInterval = Duration(seconds: 1);

  Timer? _dayTimer;
  bool _profilePrompted = false;

  FoodController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.addListener(_maybePromptProfile);
    if (!_controller.isLoaded) {
      _controller.load();
    } else {
      _controller.refreshDay();
      _controller.refreshProfile();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _maybePromptProfile(),
      );
    }
    _dayTimer = Timer.periodic(
      _dayCheckInterval,
      (_) => _controller.refreshDay(),
    );
  }

  @override
  void dispose() {
    _dayTimer?.cancel();
    _controller.removeListener(_maybePromptProfile);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _controller.refreshDay();
  }

  /// Q-13 DECIDED: ยังไม่มีโปรไฟล์ (และยังไม่เคยกดข้าม) → เปิด S-3 ให้ 1 ครั้งต่อการเข้าหน้า
  void _maybePromptProfile() {
    if (_profilePrompted || !mounted || !_controller.needsProfileSetup) return;
    _profilePrompted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _openProfile();
    });
  }

  void _openMeal() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FoodMealScreen(controller: _controller),
      ),
    );
  }

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FoodProfileScreen(controller: _controller),
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
            FoodRules.dashboardTitle,
            key: Key('food_header_text'),
          ),
        ),
        body: !_controller.isLoaded
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final petState = _controller.petState;
    final toast = _controller.toastMessage;

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
                    // #3 ช่อง Toast สูงคงที่ — Toast ไม่ดันสัตว์เลี้ยง (AC-12)
                    SizedBox(
                      key: const Key('food_toast_slot'),
                      height: FoodRules.toastSlotHeight,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: toast == null
                            ? const SizedBox.shrink()
                            // ValueKey ตาม serial: ข้อความใหม่แทนที่อันเดิมทันที (EC-2)
                            : KeyedSubtree(
                                key: ValueKey(
                                  'food_toast_${_controller.toastSerial}',
                                ),
                                child: FoodToast(message: toast),
                              ),
                      ),
                    ),
                    // #4 ระยะ anchor = TOAST_ANCHOR_OFFSET (AC-12)
                    const SizedBox(height: FoodRules.toastAnchorOffset),
                    // #5 สัตว์เลี้ยง — OQ-1 DECIDED: PetCharacter แทน Lottie/PNG
                    // ไม่ส่ง cheerTrigger (ท่ากินคือ reaction — ui-spec §4)
                    Center(
                      child: KeyedSubtree(
                        key: ValueKey('food_pet_image_${petState.keyName}'),
                        child: PetCharacter(
                          key: _petKey,
                          pose: _controller.petPose,
                          size: FoodRules.petSize,
                          animate: widget.animatePet ?? kPetAnimateByDefault,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // #7 ป้าย「อิ่มแล้ว」 — Q-5 DECIDED: ขึ้นพร้อมหลอดแดงทันที
                    Center(
                      child: Visibility(
                        key: const Key('food_full_badge_visibility'),
                        visible: _controller.showsFullBadge,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: Container(
                          key: const Key('food_full_badge'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            FoodRules.fullBadgeText,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: scheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // #9 ช่องพลังงาน — หลอดหรือ CTA Banner (AC-8, EC-4)
                    // ไม่ล็อกความสูงตายตัว (แก้บั๊ก overflow บนจอ 360 dp): ช่องสูงอย่างน้อย
                    // max(88, ความสูงที่หลอดต้องใช้, ความสูงที่ CTA ต้องใช้) ที่ความกว้าง/ฟอนต์/
                    // textScaler จริง → สองแบบสูงเท่ากันเสมอ (ไม่มี layout shift ตอนสลับ) และ
                    // ถ้าเนื้อหาจริงสูงกว่าที่วัดได้ ช่องก็โตตามได้ ไม่ overflow
                    FoodSharedMinHeightBox(
                      key: const Key('food_energy_slot'),
                      minHeightFor: _energySlotMinHeightFor(context),
                      child: _controller.showsProfileCta
                          ? _buildCtaBanner(context)
                          : _buildEnergyBlock(context),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      key: const Key('food_add_meal_button'),
                      onPressed: _openMeal,
                      icon: const Icon(Icons.restaurant, size: 24),
                      label: const Text(FoodRules.addMealButtonText),
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

  // ขนาดภายในช่องพลังงาน (ui-spec §1.3 / §2.1 #9a, #9b) — ใช้ทั้งตอนสร้าง widget และตอนวัด
  // ความสูงขั้นต่ำร่วม เพื่อให้สองที่ตรงกันเสมอ
  static const double _barHeight = 20;
  static const double _barTextGap = 8;
  static const double _ctaPadH = FoodProfileCtaBanner.padH;
  static const double _ctaPadV = FoodProfileCtaBanner.padV;
  static const double _ctaIconGap = FoodProfileCtaBanner.iconGap;
  static const double _ctaIconSize = FoodProfileCtaBanner.iconSize;

  // ASSUMPTION: ตอนแสดง CTA (ยังไม่มีเป้า) จองที่ให้ข้อความหลอดด้วยเป้าตัวแทน 4 หลัก
  // "9,999" ซึ่งกว้างไม่น้อยกว่าเป้าจริงทุกค่า (ตาราง Base Target + BMI สูงสุด 2,700) — เพื่อให้
  // ตอนตั้งโปรไฟล์แล้วสลับเป็นหลอดไม่เกิด layout shift · เป็นค่าหน้าตา ไม่ใช่ตัวเลขกติกา
  static const int _placeholderTarget = 9999;

  /// ความสูงขั้นต่ำร่วมของช่องพลังงาน = max(88, หลอด, CTA) ที่ความกว้าง [width] — AC-8
  MinHeightForWidth _energySlotMinHeightFor(BuildContext context) {
    final theme = Theme.of(context);
    final base = DefaultTextStyle.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    final locale = Localizations.maybeLocaleOf(context);
    final barText =
        _controller.calorieText ??
        FoodLogic.calorieText(_controller.totalCalories, _placeholderTarget);
    final ctaTotal = _controller.ctaTotalText;

    double textHeight(
      String text,
      TextStyle? style,
      double maxWidth, {
      int? maxLines,
      TextAlign align = TextAlign.start,
    }) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: base.style.merge(style)),
        textAlign: align,
        textDirection: direction,
        textScaler: scaler,
        maxLines: maxLines,
        ellipsis: maxLines == null ? null : '…',
        locale: locale,
        textHeightBehavior: base.textHeightBehavior,
        textWidthBasis: base.textWidthBasis,
      )..layout(maxWidth: math.max(0, maxWidth));
      final h = painter.height;
      painter.dispose();
      return h;
    }

    return (width) {
      final bar =
          _barHeight +
          _barTextGap +
          textHeight(
            barText,
            theme.textTheme.headlineSmall,
            width,
            align: TextAlign.center,
          );
      final ctaTextWidth = width - _ctaPadH * 2 - _ctaIconGap - _ctaIconSize;
      final ctaTexts =
          textHeight(
            FoodRules.profileCtaText,
            theme.textTheme.bodyMedium,
            ctaTextWidth,
            maxLines: 2,
          ) +
          textHeight(
            // BUG-FOOD-2 (D-5): ยอดรวมไม่จำกัดบรรทัด — วัดแบบเดียวกับ widget
            ctaTotal,
            theme.textTheme.titleMedium,
            ctaTextWidth,
          );
      final cta = _ctaPadV * 2 + math.max(ctaTexts, _ctaIconSize);
      return math.max(FoodRules.energySlotMinHeight, math.max(bar, cta));
    };
  }

  /// #9a หลอดพลังงาน (มีโปรไฟล์) — AC-9 / AC-10
  Widget _buildEnergyBlock(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      key: const Key('food_energy_block'),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            key: const Key('food_energy_bar'),
            value: _controller.energyFraction,
            minHeight: _barHeight,
            color: _controller.isOverLimit ? scheme.error : scheme.primary,
          ),
        ),
        const SizedBox(height: _barTextGap),
        Text(
          _controller.calorieText ?? '',
          key: const Key('food_calorie_text'),
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
      ],
    );
  }

  /// #9b CTA Banner (ข้ามโปรไฟล์ / ไม่มีเป้าหมาย) — กว้าง×สูงเต็มช่องพลังงาน (AC-8)
  /// กว้างเต็มเพราะ Column หน้า S-1 เป็น stretch · สูงอย่างน้อยเท่าขั้นต่ำของช่อง
  /// (min height จาก ConstrainedBox ของช่อง) และโตตามเนื้อหาได้ — แทน SizedBox.expand
  /// ที่ใช้ไม่ได้เมื่อช่องไม่มีความสูงตายตัว
  Widget _buildCtaBanner(BuildContext context) => FoodProfileCtaBanner(
    totalText: _controller.ctaTotalText,
    onTap: _openProfile,
  );

}
