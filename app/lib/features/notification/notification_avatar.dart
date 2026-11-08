/// Person icon ของแจ้งเตือนแบบแชตบน Android (AC-36) — ui-spec §2.3.2
///
/// DECIDED (owner 2026-11-08, D-1): ไม่มี PNG ใน assets — เรนเดอร์จาก
/// `PetCharacterPainter(pose: PetPose.notificationProfile)` ตอนรันแอป
/// 192 × 192 px ครอปวงกลมเต็มกรอบ (ไม่ซูม) พื้นโปร่งใส แล้วแคชไว้
library;

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:petpal_health/shared/pet/pet.dart';

import 'notification_rules.dart';

abstract class NotificationAvatarSource {
  /// PNG bytes ของ avatar — เรนเดอร์ไม่สำเร็จ = null (แจ้งเตือนยังเป็นแชต มีชื่อ + ข้อความ)
  Future<Uint8List?> avatarPng();
}

class PainterNotificationAvatarSource implements NotificationAvatarSource {
  PainterNotificationAvatarSource();

  Future<Uint8List?>? _cache;

  /// เรนเดอร์ครั้งแรกแล้วใช้ Future เดิมตลอด process (ui-spec §2.3.2)
  @override
  Future<Uint8List?> avatarPng() => _cache ??= _render();

  static Future<Uint8List?> _render() async {
    try {
      const px = NotificationRules.avatarSizePx;
      final s = px.toDouble();
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      // ครอปวงกลมเต็มกรอบ ไม่ซูม · ไม่เติมพื้น (โปร่งใส — ASSUMPTION: ui-spec Q-11)
      canvas.clipPath(Path()..addOval(Rect.fromLTWH(0, 0, s, s)));
      // ภาพนิ่ง (breath 0) — แจ้งเตือนไม่เปลี่ยนอารมณ์ (game-rules §2)
      const PetCharacterPainter(pose: PetPose.notificationProfile)
          .paint(canvas, Size.square(s));
      final image = await recorder.endRecording().toImage(px, px);
      try {
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        return data?.buffer.asUint8List();
      } finally {
        image.dispose();
      }
    } catch (_) {
      return null;
    }
  }
}
