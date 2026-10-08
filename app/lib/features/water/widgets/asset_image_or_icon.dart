import 'package:flutter/material.dart';

/// แสดงภาพจาก assets ตามชื่อไฟล์ใน ux-flow.md §5
/// ถ้ายังไม่มีไฟล์ภาพ จะแสดงไอคอนสำรองแทน (ไม่ทำให้แอปล่ม)
// ASSUMPTION: ไฟล์ไอคอนใน assets/icons ยังไม่มีใน repo จึงยังไม่ประกาศใน
// pubspec.yaml และใช้ไอคอน Material เป็นภาพสำรอง (ภาพสัตว์เลี้ยงใช้ PetAvatar แทน)
class AssetImageOrIcon extends StatelessWidget {
  const AssetImageOrIcon({
    super.key,
    required this.assetPath,
    required this.fallbackIcon,
    this.size = 24,
    this.color,
  });

  final String assetPath;
  final IconData fallbackIcon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) =>
          Icon(fallbackIcon, size: size, color: color),
    );
  }
}
