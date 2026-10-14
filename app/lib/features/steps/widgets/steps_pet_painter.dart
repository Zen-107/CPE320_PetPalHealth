import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../steps_models.dart';

/// วาดสัตว์เลี้ยงตามสถานะ steps 4 แบบ (ui-spec §4.2) สไตล์เดียวกับ PetPainter ของ water
/// - fat: ตัวกว้าง ม่วงเทาซีด ตาปรือ ปากเปิด หูตก มีเหงื่อ
/// - chubby: ตัวกว้างพอดี พีชอ่อน ตาจุด ยิ้มเล็ก แก้มแดง
/// - lean: ตัวสมส่วน มิ้นต์ ตายิ้ม ยิ้มกว้าง แก้มแดง
/// - muscle: แบบ lean + ขามีกล้าม 2 ข้าง + ประกาย
/// สัดส่วนเป็นค่าการแสดงผลตาม ui-spec ไม่ใช่ตัวเลขกติกาเกม
class StepsPetPainter extends CustomPainter {
  const StepsPetPainter({required this.status});

  /// สถานะที่วาด — QA ตรวจได้จาก `(customPaint.painter as StepsPetPainter).status`
  final StepsPetStatus status;

  // สีเดียวกับ PetPainter ของ water (ui-spec §1.1) — ห้ามเปลี่ยนค่า
  static const Color _criticalBody = Color(0xFFD9D4E7); // PetPainter._criticalBody
  static const Color _tiredBody = Color(0xFFFFE0B2); // PetPainter._tiredBody
  static const Color _happyBody = Color(0xFFB9F2D0); // PetPainter._happyBody
  static const Color _outline = Color(0xFF6D6875); // PetPainter._outline
  static const Color _cheek = Color(0xFFFFB5C2); // PetPainter._cheek
  static const Color _sweat = Color(0xFFA8D8FF); // PetPainter._sweat
  static const Color _sparkle = Color(0xFFFFE57F); // PetPainter._sparkle

  Color get bodyColor => switch (status) {
        StepsPetStatus.fat => _criticalBody,
        StepsPetStatus.chubby => _tiredBody,
        StepsPetStatus.lean || StepsPetStatus.muscle => _happyBody,
      };

  /// ความกว้าง/สูงของตัว (สัดส่วนของ s) ตาม ui-spec §4.2
  double get _bodyWidth => switch (status) {
        StepsPetStatus.fat => 0.92,
        StepsPetStatus.chubby => 0.84,
        StepsPetStatus.lean || StepsPetStatus.muscle => 0.72,
      };

  double get _bodyHeight => status == StepsPetStatus.muscle ? 0.62 : 0.68;

  /// ยกตัวขึ้นเล็กน้อยเมื่อมีขา (muscle)
  double get _bodyCenterY => status == StepsPetStatus.muscle ? 0.53 : 0.56;

  @override
  void paint(Canvas canvas, Size size) {
    final s = math.min(size.width, size.height);
    canvas.save();
    canvas.translate((size.width - s) / 2, (size.height - s) / 2);

    final stroke = Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.025
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = bodyColor;

    if (status == StepsPetStatus.muscle) _drawLegs(canvas, s, fill, stroke);
    _drawEars(canvas, s, fill, stroke);
    _drawBody(canvas, s, fill, stroke);
    _drawFace(canvas, s, stroke);

    canvas.restore();
  }

  void _drawBody(Canvas canvas, double s, Paint fill, Paint stroke) {
    final body = Rect.fromCenter(
      center: Offset(s * 0.5, s * _bodyCenterY),
      width: s * _bodyWidth,
      height: s * _bodyHeight,
    );
    canvas.drawOval(body, fill);
    canvas.drawOval(body, stroke);
  }

  void _drawEars(Canvas canvas, double s, Paint fill, Paint stroke) {
    final droop = status == StepsPetStatus.fat ? 0.07 : 0.0;
    for (final side in [-1.0, 1.0]) {
      final baseX = s * 0.5 + side * s * 0.22;
      final ear = Path()
        ..moveTo(baseX - side * s * 0.12, s * 0.32)
        ..lineTo(baseX + side * s * (0.10 + droop), s * (0.08 + droop))
        ..lineTo(baseX + side * s * 0.14, s * 0.36)
        ..close();
      canvas.drawPath(ear, fill);
      canvas.drawPath(ear, stroke);
    }
  }

  void _drawLegs(Canvas canvas, double s, Paint fill, Paint stroke) {
    for (final x in [0.36, 0.64]) {
      final leg = Rect.fromCenter(
          center: Offset(s * x, s * 0.88), width: s * 0.18, height: s * 0.16);
      canvas.drawOval(leg, fill);
      canvas.drawOval(leg, stroke);
      // เส้นโค้งกล้ามขา
      canvas.drawArc(
        Rect.fromCenter(
            center: Offset(s * x, s * 0.87), width: s * 0.09, height: s * 0.07),
        math.pi * 1.1,
        math.pi * 0.8,
        false,
        stroke,
      );
    }
  }

  void _drawFace(Canvas canvas, double s, Paint stroke) {
    final eyeY = s * (_bodyCenterY - 0.04);
    final leftEye = Offset(s * 0.37, eyeY);
    final rightEye = Offset(s * 0.63, eyeY);
    final eyeR = s * 0.045;
    final mouth = Offset(s * 0.5, s * (_bodyCenterY + 0.10));

    switch (status) {
      case StepsPetStatus.fat:
        // ตาปรือ + ปากเปิด (ไม่แลบลิ้น)
        for (final eye in [leftEye, rightEye]) {
          canvas.drawLine(
              eye.translate(-eyeR, 0), eye.translate(eyeR, 0), stroke);
          canvas.drawArc(Rect.fromCircle(center: eye, radius: eyeR), 0,
              math.pi, false, stroke);
        }
        canvas.drawOval(
          Rect.fromCenter(center: mouth, width: s * 0.14, height: s * 0.06),
          Paint()..color = _outline,
        );
        _drawSweat(canvas, Offset(s * 0.84, s * 0.38), s);
      case StepsPetStatus.chubby:
        // ตาจุดกลม + ยิ้มเล็ก
        final dot = Paint()..color = _outline;
        canvas.drawCircle(leftEye, s * 0.035, dot);
        canvas.drawCircle(rightEye, s * 0.035, dot);
        canvas.drawArc(
          Rect.fromCenter(center: mouth, width: s * 0.12, height: s * 0.08),
          0,
          math.pi,
          false,
          stroke,
        );
        _drawCheeks(canvas, s);
      case StepsPetStatus.lean:
      case StepsPetStatus.muscle:
        // ตายิ้ม (^ ^) + ยิ้มกว้าง
        for (final eye in [leftEye, rightEye]) {
          canvas.drawArc(
              Rect.fromCircle(
                  center: eye.translate(0, eyeR * 0.5), radius: eyeR),
              math.pi,
              math.pi,
              false,
              stroke);
        }
        canvas.drawArc(
          Rect.fromCenter(center: mouth, width: s * 0.20, height: s * 0.12),
          0,
          math.pi,
          false,
          stroke,
        );
        _drawCheeks(canvas, s);
        if (status == StepsPetStatus.muscle) {
          // ตำแหน่งเดียวกับ happy ของ water
          _drawSparkle(canvas, Offset(s * 0.86, s * 0.22), s * 0.06);
          _drawSparkle(canvas, Offset(s * 0.13, s * 0.30), s * 0.04);
        }
    }
  }

  void _drawCheeks(Canvas canvas, double s) {
    final cheek = Paint()..color = _cheek.withValues(alpha: 0.8);
    final y = s * (_bodyCenterY + 0.06);
    final dx = s * _bodyWidth * 0.32;
    canvas.drawCircle(Offset(s * 0.5 - dx, y), s * 0.045, cheek);
    canvas.drawCircle(Offset(s * 0.5 + dx, y), s * 0.045, cheek);
  }

  void _drawSweat(Canvas canvas, Offset top, double s) {
    final drop = Path()
      ..moveTo(top.dx, top.dy)
      ..quadraticBezierTo(
          top.dx + s * 0.05, top.dy + s * 0.08, top.dx, top.dy + s * 0.10)
      ..quadraticBezierTo(
          top.dx - s * 0.05, top.dy + s * 0.08, top.dx, top.dy)
      ..close();
    canvas.drawPath(drop, Paint()..color = _sweat);
  }

  void _drawSparkle(Canvas canvas, Offset c, double r) {
    final star = Path()
      ..moveTo(c.dx, c.dy - r)
      ..quadraticBezierTo(c.dx, c.dy, c.dx + r, c.dy)
      ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy + r)
      ..quadraticBezierTo(c.dx, c.dy, c.dx - r, c.dy)
      ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy - r)
      ..close();
    canvas.drawPath(star, Paint()..color = _sparkle);
  }

  @override
  bool shouldRepaint(StepsPetPainter oldDelegate) =>
      oldDelegate.status != status;
}
