import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../steps_logic.dart';
import '../steps_models.dart';
import 'steps_pet_painter.dart';

/// ภาพสัตว์เลี้ยงตามสถานะ steps (game-rules.md §2, ui-spec §4) — pattern เดียวกับ PetAvatar
///
/// - มีไฟล์ PNG ตาม game-rules (เช่น assets/images/pet_fat.png) ใน bundle → `Image.asset`
///   key `steps_pet_png_<status>` (โหลดไม่สำเร็จ → ภาพวาด)
/// - ไม่มี → `CustomPaint(painter: StepsPetPainter)` key `steps_pet_painter_<status>`
/// - ตัว widget นี้รับ key `steps_pet_image_<status>` จากหน้าจอ
class StepsPetAvatar extends StatefulWidget {
  const StepsPetAvatar({super.key, required this.status, this.size = 160});

  final StepsPetStatus status;
  final double size;

  static ValueKey<String> imageKey(StepsPetStatus status) =>
      ValueKey('steps_pet_image_${status.name}');
  static ValueKey<String> painterKey(StepsPetStatus status) =>
      ValueKey('steps_pet_painter_${status.name}');
  static ValueKey<String> pngKey(StepsPetStatus status) =>
      ValueKey('steps_pet_png_${status.name}');

  /// รายชื่อ asset ที่มีจริงใน bundle (โหลดครั้งเดียวต่อการรันแอป)
  static Future<Set<String>>? _availableAssets;

  static Future<Set<String>> _loadAvailableAssets() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      return manifest.listAssets().toSet();
    } catch (_) {
      return const <String>{};
    }
  }

  @override
  State<StepsPetAvatar> createState() => _StepsPetAvatarState();
}

class _StepsPetAvatarState extends State<StepsPetAvatar> {
  Set<String> _assets = const {};

  @override
  void initState() {
    super.initState();
    StepsPetAvatar._availableAssets ??= StepsPetAvatar._loadAvailableAssets();
    StepsPetAvatar._availableAssets!.then((assets) {
      if (!mounted || assets.isEmpty) return;
      setState(() => _assets = assets);
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.status;
    final painted = CustomPaint(
      key: StepsPetAvatar.painterKey(status),
      size: Size.square(widget.size),
      painter: StepsPetPainter(status: status),
    );
    final png = StepsLogic.statusImage(status);
    if (!_assets.contains(png)) return painted;
    return Image.asset(
      png,
      key: StepsPetAvatar.pngKey(status),
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => painted,
    );
  }
}
