import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../water_models.dart';

/// วาดสัตว์เลี้ยงด้วยโค้ด แบบเรียบง่าย น่ารัก สีอ่อน (pastel)
/// มีอารมณ์ครบ 3 สถานะตาม game-rules.md §2
/// - critical (0–3 แก้ว): ตัวซีด ตาเป็นกากบาท ปากคว่ำ หูตก มีหยดเหงื่อ
/// - tired (4–6 แก้ว): ตาปรือ ปากเปิด แลบลิ้น มีหยดเหงื่อ
/// - happy (7+ แก้ว): ตายิ้ม ปากยิ้มกว้าง แก้มแดง มีประกาย
// DECIDED: Zen-107 2026-10-08 — ภาพสัตว์เลี้ยงวาดด้วย CustomPainter แบบเรียบง่าย
// น่ารัก สี pastel มีอารมณ์ครบ 3 สถานะ (game-rules.md §2)
class PetPainter extends CustomPainter {
  const PetPainter({required this.mood});

  /// อารมณ์ที่วาด — QA ตรวจได้จาก `(customPaint.painter as PetPainter).mood`
  final PetMood mood;

  // สีพื้นตัวตามอารมณ์ (pastel) — เป็นค่าการแสดงผล ไม่ใช่ตัวเลขกติกาเกม
  static const Color _criticalBody = Color(0xFFD9D4E7); // ม่วงเทาซีด
  static const Color _tiredBody = Color(0xFFFFE0B2); // พีชอ่อน
  static const Color _happyBody = Color(0xFFB9F2D0); // มิ้นต์อ่อน

  static const Color _outline = Color(0xFF6D6875);
  static const Color _cheek = Color(0xFFFFB5C2);
  static const Color _tongue = Color(0xFFFF8FA3);
  static const Color _sweat = Color(0xFFA8D8FF);
  static const Color _sparkle = Color(0xFFFFE57F);

  Color get bodyColor {
    switch (mood) {
      case PetMood.critical:
        return _criticalBody;
      case PetMood.tired:
        return _tiredBody;
      case PetMood.happy:
        return _happyBody;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = math.min(size.width, size.height);
    // วาดในกรอบสี่เหลี่ยมจัตุรัสตรงกลาง
    canvas.save();
    canvas.translate((size.width - s) / 2, (size.height - s) / 2);

    final stroke = Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.025
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = bodyColor;

    _drawEars(canvas, s, fill, stroke);
    _drawBody(canvas, s, fill, stroke);
    _drawFace(canvas, s, stroke);

    canvas.restore();
  }

  void _drawBody(Canvas canvas, double s, Paint fill, Paint stroke) {
    final body = Rect.fromCenter(
      center: Offset(s * 0.5, s * 0.56),
      width: s * 0.78,
      height: s * 0.68,
    );
    canvas.drawOval(body, fill);
    canvas.drawOval(body, stroke);
  }

  void _drawEars(Canvas canvas, double s, Paint fill, Paint stroke) {
    // หูตกเมื่อป่วย, หูตั้งเมื่อสดชื่น
    final droop = switch (mood) {
      PetMood.critical => 0.14,
      PetMood.tired => 0.07,
      PetMood.happy => 0.0,
    };
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

  void _drawFace(Canvas canvas, double s, Paint stroke) {
    final leftEye = Offset(s * 0.37, s * 0.52);
    final rightEye = Offset(s * 0.63, s * 0.52);
    final eyeR = s * 0.045;
    final mouth = Offset(s * 0.5, s * 0.66);

    switch (mood) {
      case PetMood.critical:
        for (final eye in [leftEye, rightEye]) {
          _drawCross(canvas, eye, eyeR, stroke);
        }
        // ปากคว่ำ
        canvas.drawArc(
          Rect.fromCenter(
              center: mouth.translate(0, s * 0.04),
              width: s * 0.16,
              height: s * 0.10),
          math.pi,
          math.pi,
          false,
          stroke,
        );
        _drawSweat(canvas, Offset(s * 0.78, s * 0.38), s);
      case PetMood.tired:
        // ตาปรือ (เส้นครึ่งวงล่าง)
        for (final eye in [leftEye, rightEye]) {
          canvas.drawLine(
              eye.translate(-eyeR, 0), eye.translate(eyeR, 0), stroke);
          canvas.drawArc(Rect.fromCircle(center: eye, radius: eyeR), 0,
              math.pi, false, stroke);
        }
        // ปากเปิด + แลบลิ้น
        final mouthRect =
            Rect.fromCenter(center: mouth, width: s * 0.14, height: s * 0.06);
        canvas.drawOval(mouthRect, Paint()..color = _outline);
        final tongue = RRect.fromRectAndCorners(
          Rect.fromLTWH(
              mouth.dx - s * 0.045, mouth.dy, s * 0.09, s * 0.10),
          bottomLeft: Radius.circular(s * 0.045),
          bottomRight: Radius.circular(s * 0.045),
        );
        canvas.drawRRect(tongue, Paint()..color = _tongue);
        canvas.drawLine(
          Offset(mouth.dx, mouth.dy + s * 0.02),
          Offset(mouth.dx, mouth.dy + s * 0.07),
          Paint()
            ..color = _outline
            ..strokeWidth = s * 0.012
            ..strokeCap = StrokeCap.round,
        );
        _drawSweat(canvas, Offset(s * 0.80, s * 0.40), s);
      case PetMood.happy:
        // ตายิ้ม (^ ^)
        for (final eye in [leftEye, rightEye]) {
          canvas.drawArc(
              Rect.fromCircle(center: eye.translate(0, eyeR * 0.5),
                  radius: eyeR),
              math.pi,
              math.pi,
              false,
              stroke);
        }
        // ยิ้มกว้าง
        canvas.drawArc(
          Rect.fromCenter(center: mouth, width: s * 0.20, height: s * 0.12),
          0,
          math.pi,
          false,
          stroke,
        );
        // แก้มแดง
        final cheek = Paint()..color = _cheek.withValues(alpha: 0.8);
        canvas.drawCircle(Offset(s * 0.27, s * 0.62), s * 0.045, cheek);
        canvas.drawCircle(Offset(s * 0.73, s * 0.62), s * 0.045, cheek);
        _drawSparkle(canvas, Offset(s * 0.86, s * 0.22), s * 0.06);
        _drawSparkle(canvas, Offset(s * 0.13, s * 0.30), s * 0.04);
    }
  }

  void _drawCross(Canvas canvas, Offset c, double r, Paint stroke) {
    canvas.drawLine(c.translate(-r, -r), c.translate(r, r), stroke);
    canvas.drawLine(c.translate(-r, r), c.translate(r, -r), stroke);
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
  bool shouldRepaint(PetPainter oldDelegate) => oldDelegate.mood != mood;
}
