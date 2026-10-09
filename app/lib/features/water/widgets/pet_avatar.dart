import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../water_logic.dart';
import '../water_models.dart';
import 'pet_painter.dart';

/// ภาพสัตว์เลี้ยงตามอารมณ์ (game-rules.md §2, AC-2)
///
/// - ถ้ามีไฟล์ PNG ตามชื่อใน game-rules.md (เช่น assets/images/pet_happy.png)
///   ลงทะเบียนอยู่ใน asset bundle → แสดง PNG
/// - ถ้าไม่มี (หรือโหลด PNG ไม่สำเร็จ) → วาดด้วย [PetPainter]
///
/// Key สำหรับ QA:
/// - ตัว widget นี้รับ key จากผู้เรียก (หน้าจอหลักใช้ `ValueKey('water_pet_image_<mood>')`)
/// - ภาพวาด: `CustomPaint` key = `ValueKey('water_pet_painter_<mood>')`
///   และ `painter` เป็น [PetPainter] ที่มีฟิลด์ `mood`
/// - ภาพ PNG: `Image` key = `ValueKey('water_pet_png_<mood>')`
// DECIDED: Zen-107 2026-10-08 — วาดด้วย CustomPainter ถ้ามี PNG ตามชื่อใน
// app/assets/images/ ให้ใช้ PNG แทน (game-rules.md §2)
class PetAvatar extends StatefulWidget {
  const PetAvatar({super.key, required this.mood, this.size = 160});

  final PetMood mood;
  final double size;

  static ValueKey<String> painterKey(PetMood mood) =>
      ValueKey('water_pet_painter_${mood.name}');
  static ValueKey<String> pngKey(PetMood mood) =>
      ValueKey('water_pet_png_${mood.name}');

  /// รายชื่อ asset ที่มีจริงใน bundle (โหลดครั้งเดียวต่อการรันแอป)
  static Future<Set<String>>? _availableAssets;

  static Future<Set<String>> _loadAvailableAssets() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      return manifest.listAssets().toSet();
    } catch (_) {
      // ไม่มี manifest หรืออ่านไม่ได้ → ใช้ภาพวาดอย่างเดียว ไม่ทำให้แอปล่ม
      return const <String>{};
    }
  }

  @override
  State<PetAvatar> createState() => _PetAvatarState();
}

class _PetAvatarState extends State<PetAvatar> {
  Set<String> _assets = const {};

  @override
  void initState() {
    super.initState();
    PetAvatar._availableAssets ??= PetAvatar._loadAvailableAssets();
    PetAvatar._availableAssets!.then((assets) {
      if (!mounted || assets.isEmpty) return;
      setState(() => _assets = assets);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mood = widget.mood;
    final painted = _buildPainted(mood);
    final png = WaterLogic.moodImage(mood);
    // แสดงภาพวาดก่อนเสมอ จนกว่าจะรู้ว่ามี PNG ใน bundle จริง
    if (!_assets.contains(png)) return painted;
    return Image.asset(
      png,
      key: PetAvatar.pngKey(mood),
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => painted,
    );
  }

  Widget _buildPainted(PetMood mood) {
    return CustomPaint(
      key: PetAvatar.painterKey(mood),
      size: Size.square(widget.size),
      painter: PetPainter(mood: mood),
    );
  }
}
