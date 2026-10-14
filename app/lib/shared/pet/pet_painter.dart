import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'pet_constants.dart';
import 'pet_pose.dart';

/// Draws the PetPal frog for one frame (character.md).
///
/// Pure function of its fields — the widget [PetCharacter] feeds it the
/// animation values each tick. Tests can read every field and the derived
/// getters from the `painter` of the `CustomPaint`
/// found by `PetKeys.painter`, cast to [PetCharacterPainter]
/// (`find.byKey(PetKeys.painter)` → `CustomPaint` → `painter`).
class PetCharacterPainter extends CustomPainter {
  const PetCharacterPainter({
    required this.pose,
    this.breath = 0,
    this.blink = 0,
    this.action = PetAction.none,
    this.actionProgress = 0,
    this.animated = false,
  });

  /// Expression + body shape.
  final PetPose pose;

  /// Breathing phase 0..1 (0 = rest / static frame).
  final double breath;

  /// Eyelid closure from blinking 0..1 (1 = fully closed).
  final double blink;

  /// One-shot reaction being played.
  final PetAction action;

  /// Progress of [action] 0..1.
  final double actionProgress;

  /// Whether the owning widget is animating (false = static frame).
  final bool animated;

  // ---------------------------------------------------------------- getters
  PetExpression get expression => pose.expression;
  PetBodyShape get bodyShape => pose.body;
  PetBodySpec get bodySpec => PetProportions.bodies[pose.body]!;

  bool get isJumping => action == PetAction.jump;
  bool get isCheering => action == PetAction.cheer;

  /// Eyes are (almost) fully closed by a blink this frame.
  bool get isBlinking => action == PetAction.none && blink >= 0.5;

  /// Sweat drops are drawn (low states: tired / critical).
  bool get showsSweat => pose.isLowState;

  /// Half-closed droopy eyes are drawn this frame.
  bool get hasDroopyEyes =>
      pose.isLowState && face != PetFace.blink && action == PetAction.none;

  /// Sparkles are drawn this frame.
  bool get showsSparkles =>
      isCheering ||
      (action == PetAction.none &&
          (expression == PetExpression.happy ||
              expression == PetExpression.proud));

  /// The face actually drawn this frame.
  PetFace get face {
    switch (action) {
      case PetAction.jump:
        return PetFace.funny;
      case PetAction.cheer:
        return PetFace.cheer;
      case PetAction.none:
        break;
    }
    if (blink >= 0.5) return PetFace.blink;
    return _expressionFace;
  }

  /// Face ignoring blinks (mouth, leaf and cheeks keep the mood while the
  /// eyes blink).
  PetFace get _mouthFace => face == PetFace.blink ? _expressionFace : face;

  PetFace get _expressionFace {
    return switch (expression) {
      PetExpression.happy => PetFace.happy,
      PetExpression.content => PetFace.content,
      PetExpression.proud => PetFace.proud,
      PetExpression.tired => PetFace.tired,
      PetExpression.critical => PetFace.critical,
    };
  }

  bool get _critical => expression == PetExpression.critical;
  Color get _bodyColor => _critical ? PetColors.bodyCritical : PetColors.body;

  // ------------------------------------------------------------------ paint
  @override
  void paint(Canvas canvas, Size size) {
    final s = math.min(size.width, size.height);
    if (s <= 0) return;
    canvas.save();
    canvas.translate((size.width - s) / 2, (size.height - s) / 2);
    // Everything below is drawn in unit space 0..1.
    canvas.scale(s);

    final spec = bodySpec;
    const ground = PetProportions.groundY;

    // --- motion: breathing + jump / cheer
    var lift = 0.0;
    var sx = 1.0;
    var sy = 1.0;
    final amp = PetProportions.breathAmplitude * (_critical ? 0.6 : 1.0);
    sy *= 1 + amp * breath;
    sx *= 1 - amp * 0.5 * breath;
    if (_critical) {
      // sagging, a bit flattened
      sy *= 0.96;
      sx *= 1.03;
    }
    final t = actionProgress.clamp(0.0, 1.0);
    if (isJumping) {
      if (t < 0.15) {
        final k = t / 0.15;
        sy *= 1 - 0.12 * k;
        sx *= 1 + 0.08 * k;
      } else if (t < 0.75) {
        final k = math.sin(math.pi * (t - 0.15) / 0.6);
        lift = k * PetProportions.jumpHeight;
        sy *= 1 + 0.06 * k;
        sx *= 1 - 0.03 * k;
      } else {
        final k = math.sin(math.pi * (t - 0.75) / 0.25) * 0.10;
        sy *= 1 - k;
        sx *= 1 + k * 0.7;
      }
    } else if (isCheering) {
      lift = (math.sin(2 * math.pi * t)).abs() * PetProportions.cheerHopHeight;
    }

    // --- ground shadow (shrinks while airborne)
    final shadowScale = 1 - (lift / PetProportions.jumpHeight) * 0.35;
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(0.5, ground + 0.015),
        width: spec.width * 0.85 * shadowScale,
        height: 0.05 * shadowScale,
      ),
      Paint()..color = PetColors.shadow,
    );

    canvas.save();
    canvas.translate(0.5, ground - lift);
    canvas.scale(sx, sy);
    canvas.translate(-0.5, -ground);
    _paintFrog(canvas, spec);
    canvas.restore();

    canvas.restore();
  }

  void _paintFrog(Canvas canvas, PetBodySpec spec) {
    final g = _Geo(spec);
    final stroke = _stroke(PetProportions.stroke);
    final bodyFill = Paint()..color = _bodyColor;

    // 1. back haunches behind the body
    if (!spec.muscle && spec.thighWidth > 0) {
      for (final side in const [-1.0, 1.0]) {
        final r = Rect.fromCenter(
          center: Offset(
            g.cx + side * (g.w / 2 - spec.thighWidth * 0.3),
            g.bottom - spec.thighHeight / 2 - 0.005,
          ),
          width: spec.thighWidth,
          height: spec.thighHeight,
        );
        canvas.drawOval(r, bodyFill);
        canvas.drawOval(r, stroke);
      }
    }

    // 2. leaf stem goes behind the head
    // 3. body blob (head+torso) with eye bumps
    final bodyPath = Path.combine(
      PathOperation.union,
      Path()
        ..addRRect(RRect.fromLTRBAndCorners(
          g.cx - g.w / 2,
          g.top,
          g.cx + g.w / 2,
          g.bottom,
          topLeft: Radius.elliptical(g.w / 2, g.h * 0.62),
          topRight: Radius.elliptical(g.w / 2, g.h * 0.62),
          bottomLeft: Radius.elliptical(g.w * 0.42, g.h * 0.38),
          bottomRight: Radius.elliptical(g.w * 0.42, g.h * 0.38),
        )),
      Path()
        ..addOval(Rect.fromCircle(
            center: g.leftEye, radius: PetProportions.bumpRadius))
        ..addOval(Rect.fromCircle(
            center: g.rightEye, radius: PetProportions.bumpRadius)),
    );
    canvas.drawPath(bodyPath, bodyFill);
    canvas.drawPath(bodyPath, stroke);

    // 4. belly
    final bellyRect = Rect.fromCenter(
      center: Offset(g.cx, g.bottom - spec.bellyHeight / 2 - 0.025),
      width: spec.bellyWidth,
      height: spec.bellyHeight,
    );
    canvas.drawOval(bellyRect, Paint()..color = PetColors.belly);
    if (spec.bellyRoll) {
      final y = bellyRect.center.dy + spec.bellyHeight * 0.12;
      final hw = spec.bellyWidth * 0.36;
      canvas.drawPath(
        Path()
          ..moveTo(g.cx - hw, y)
          ..quadraticBezierTo(g.cx, y + 0.05, g.cx + hw, y),
        _stroke(0.012, PetColors.outline.withValues(alpha: 0.45)),
      );
      // belly button
      canvas.drawArc(
        Rect.fromCenter(
            center: Offset(g.cx, y + 0.065), width: 0.03, height: 0.02),
        0,
        math.pi,
        false,
        _stroke(0.010, PetColors.outline.withValues(alpha: 0.5)),
      );
    }

    // 7. arms
    _paintArms(canvas, g);

    // 7b. muscular haunches in front of everything below the face (MUSCLE)
    if (spec.muscle) _paintMuscleThighs(canvas, g, spec, bodyFill, stroke);

    // 7c. front feet (always in front of the haunches)
    for (final side in const [-1.0, 1.0]) {
      _paintFoot(canvas, Offset(g.cx + side * spec.footSpread, g.bottom),
          spec.toeRadius);
    }

    // 8. cheeks
    final cheekAlpha = switch (expression) {
      PetExpression.critical => 0.30,
      PetExpression.tired => 0.55,
      _ => 0.9,
    };
    final cheekPaint = Paint()
      ..color = PetColors.cheek.withValues(
          alpha: face == PetFace.cheer || face == PetFace.funny
              ? 0.95
              : cheekAlpha);
    for (final side in const [-1.0, 1.0]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(g.cx + side * (g.eyeOff + 0.045), g.eyeY + 0.125),
          width: 0.085,
          height: 0.05,
        ),
        cheekPaint,
      );
    }

    // 9. eyes (+ brows / eye bags)
    _paintEyes(canvas, g);

    // 10. mouth + tongue
    _paintMouth(canvas, g);

    // 11. leaf on the head
    _paintLeaf(canvas, g);

    // 12. sweat drops
    if (showsSweat) _paintSweat(canvas, g);

    // 13. sparkles
    if (showsSparkles) _paintSparkles(canvas, g);
  }

  // ------------------------------------------------------------ body parts
  void _paintMuscleThighs(Canvas canvas, _Geo g, PetBodySpec spec,
      Paint bodyFill, Paint stroke) {
    for (final side in const [-1.0, 1.0]) {
      final c = Offset(
        g.cx + side * (g.w / 2 - spec.thighWidth * 0.12),
        g.bottom - spec.thighHeight / 2 + 0.005,
      );
      final r = Rect.fromCenter(
          center: c, width: spec.thighWidth, height: spec.thighHeight);
      // volume: darker crescent on the outer-bottom side
      canvas.drawOval(r, Paint()..color = PetColors.muscleShade);
      canvas.save();
      canvas.clipPath(Path()..addOval(r));
      canvas.drawOval(
        r.shift(Offset(-side * spec.thighWidth * 0.16,
            -spec.thighHeight * 0.14)),
        bodyFill,
      );
      canvas.restore();
      canvas.drawOval(r, stroke);
      // quad definition line
      canvas.drawPath(
        Path()
          ..moveTo(c.dx - side * spec.thighWidth * 0.28,
              c.dy - spec.thighHeight * 0.32)
          ..quadraticBezierTo(
            c.dx + side * spec.thighWidth * 0.12,
            c.dy - spec.thighHeight * 0.10,
            c.dx - side * spec.thighWidth * 0.02,
            c.dy + spec.thighHeight * 0.30,
          ),
        _stroke(0.016),
      );
      // shine on the bulge
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(c.dx - side * spec.thighWidth * 0.12,
              c.dy - spec.thighHeight * 0.22),
          width: spec.thighWidth * 0.26,
          height: spec.thighHeight * 0.14,
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.45),
      );
    }
  }

  void _paintFoot(Canvas canvas, Offset c, double toe) {
    final path = Path()
      ..addOval(Rect.fromCenter(
          center: c.translate(0, -toe * 0.5),
          width: toe * 4.2,
          height: toe * 2.0));
    for (final dx in const [-1.5, 0.0, 1.5]) {
      path.addOval(Rect.fromCircle(
          center: c.translate(dx * toe, dx == 0 ? toe * 0.15 : 0),
          radius: toe));
    }
    final foot = Path.combine(PathOperation.union, path, Path());
    canvas.drawPath(foot, Paint()..color = PetColors.feet);
    canvas.drawPath(foot, _stroke(PetProportions.stroke * 0.85));
  }

  void _paintArms(Canvas canvas, _Geo g) {
    const thick = 0.055;
    for (final side in const [-1.0, 1.0]) {
      final shoulder =
          Offset(g.cx + side * (g.w / 2 - 0.075), g.top + g.h * 0.55);
      final List<Offset> joints;
      if (isCheering) {
        joints = [
          Offset(g.cx + side * (g.w / 2 + 0.06), g.top + g.h * 0.12),
        ];
      } else if (isJumping) {
        joints = [
          Offset(g.cx + side * (g.w / 2 + 0.05), g.top + g.h * 0.40),
        ];
      } else if (expression == PetExpression.proud) {
        // flexing biceps: elbow out, fist up
        joints = [
          Offset(g.cx + side * (g.w / 2 + 0.05), g.top + g.h * 0.56),
          Offset(g.cx + side * (g.w / 2 + 0.06), g.top + g.h * 0.30),
        ];
      } else if (pose.isLowState) {
        joints = [
          Offset(g.cx + side * (g.w / 2 - 0.08), g.top + g.h * 0.80),
        ];
      } else {
        joints = [
          Offset(g.cx + side * (g.w / 2 - 0.17), g.top + g.h * 0.72),
        ];
      }
      final pts = [shoulder, ...joints];
      Path line(List<Offset> ps) {
        final path = Path()..moveTo(ps.first.dx, ps.first.dy);
        for (final p in ps.skip(1)) {
          path.lineTo(p.dx, p.dy);
        }
        return path;
      }

      // The outline starts half-way along the upper arm and the fill starts
      // at the shoulder, so the outline tapers off and the arm looks like it
      // grows out of the body.
      final emerge = Offset.lerp(pts[0], pts[1], 0.5)!;
      canvas.drawPath(line([emerge, ...pts.skip(1)]),
          _stroke(thick + PetProportions.stroke * 2));
      canvas.drawPath(line(pts), _stroke(thick, _bodyColor));
      final hand = pts.last;
      canvas.drawCircle(hand, 0.032, Paint()..color = PetColors.feet);
      canvas.drawCircle(hand, 0.032, _stroke(PetProportions.stroke * 0.8));
    }
  }

  // ------------------------------------------------------------------ eyes
  void _paintEyes(Canvas canvas, _Geo g) {
    final r = PetProportions.bumpRadius * PetProportions.scleraFactor;
    final f = face;
    for (final side in const [-1.0, 1.0]) {
      final e = side < 0 ? g.leftEye : g.rightEye;
      switch (f) {
        case PetFace.cheer:
          // ^ ^
          canvas.drawArc(
            Rect.fromCenter(
                center: e.translate(0, r * 0.35),
                width: r * 1.5,
                height: r * 1.3),
            math.pi * 1.1,
            math.pi * 0.8,
            false,
            _stroke(0.03),
          );
        case PetFace.funny:
          // > <  (left eye '>', right eye '<')
          final dir = -side;
          final p = Path()
            ..moveTo(e.dx - dir * r * 0.55, e.dy - r * 0.55)
            ..lineTo(e.dx + dir * r * 0.55, e.dy)
            ..lineTo(e.dx - dir * r * 0.55, e.dy + r * 0.55);
          canvas.drawPath(p, _stroke(0.03));
        case PetFace.blink:
          _closedEye(canvas, e, r);
        case PetFace.happy:
          _openEye(canvas, e, r, lid: 0, pupilDy: 0.05, pupil: 0.64);
        case PetFace.content:
          _openEye(canvas, e, r, lid: 0.15, pupilDy: 0.12, pupil: 0.58);
        case PetFace.proud:
          _openEye(canvas, e, r, lid: 0.0, pupilDy: -0.02, pupil: 0.60);
          // determined brows (inner end lower)
          canvas.drawLine(
            Offset(e.dx + side * r * 0.75, e.dy - r - 0.050),
            Offset(e.dx - side * r * 0.55, e.dy - r - 0.012),
            _stroke(0.026),
          );
        case PetFace.tired:
          _openEye(canvas, e, r, lid: 0.45, pupilDy: 0.30, pupil: 0.56);
        case PetFace.critical:
          _openEye(canvas, e, r, lid: 0.62, pupilDy: 0.45, pupil: 0.48);
          // eye bags
          canvas.drawArc(
            Rect.fromCenter(
                center: e.translate(0, r + 0.005),
                width: r * 1.3,
                height: 0.035),
            0.15 * math.pi,
            0.7 * math.pi,
            false,
            _stroke(0.010, PetColors.outline.withValues(alpha: 0.55)),
          );
      }
    }
  }

  void _openEye(Canvas canvas, Offset e, double r,
      {required double lid, required double pupilDy, required double pupil}) {
    final effLid = math.max(lid, blink.clamp(0.0, 1.0));
    if (effLid >= 0.92) {
      _closedEye(canvas, e, r);
      return;
    }
    final sclera = Rect.fromCircle(center: e, radius: r);
    canvas.drawOval(sclera, Paint()..color = PetColors.eyeWhite);
    final pc = e.translate(0, pupilDy * r);
    final pr = r * pupil;
    canvas.drawCircle(pc, pr, Paint()..color = PetColors.pupil);
    final hi = Paint()..color = PetColors.eyeWhite;
    canvas.drawCircle(pc.translate(-pr * 0.35, -pr * 0.38), pr * 0.34, hi);
    canvas.drawCircle(pc.translate(pr * 0.38, pr * 0.32), pr * 0.15, hi);
    if (effLid > 0) {
      final lidY = e.dy - r + 2 * r * effLid;
      canvas.save();
      canvas.clipPath(Path()..addOval(sclera));
      canvas.drawRect(Rect.fromLTRB(e.dx - r, e.dy - r - 0.01, e.dx + r, lidY),
          Paint()..color = _bodyColor);
      canvas.restore();
      final dy = lidY - e.dy;
      final hw = math.sqrt(math.max(0, r * r - dy * dy));
      canvas.drawLine(Offset(e.dx - hw, lidY), Offset(e.dx + hw, lidY),
          _stroke(0.02));
    }
    canvas.drawOval(sclera, _stroke(0.014));
  }

  void _closedEye(Canvas canvas, Offset e, double r) {
    canvas.drawArc(
      Rect.fromCenter(center: e, width: r * 1.5, height: r * 1.0),
      0.1 * math.pi,
      0.8 * math.pi,
      false,
      _stroke(0.026),
    );
  }

  // ----------------------------------------------------------------- mouth
  void _paintMouth(Canvas canvas, _Geo g) {
    final cx = g.cx;
    final my = g.mouthY;
    switch (_mouthFace) {
      case PetFace.blink: // unreachable: _mouthFace never returns blink
        break;
      case PetFace.happy:
        _openSmile(canvas, cx, my, 0.11, 0.085);
      case PetFace.cheer:
        _openSmile(canvas, cx, my, 0.13, 0.11);
      case PetFace.content:
        _tongueBlep(canvas, Offset(cx + 0.012, my + 0.022), 0.058, 0.05);
        canvas.drawPath(
          Path()
            ..moveTo(cx - 0.10, my)
            ..quadraticBezierTo(cx, my + 0.065, cx + 0.10, my),
          _stroke(0.02),
        );
      case PetFace.proud:
        _tongueBlep(canvas, Offset(cx + 0.05, my + 0.03), 0.058, 0.055);
        canvas.drawPath(
          Path()
            ..moveTo(cx - 0.13, my - 0.02)
            ..quadraticBezierTo(cx, my + 0.085, cx + 0.13, my - 0.02),
          _stroke(0.022),
        );
        // dimples at the corners
        for (final side in const [-1.0, 1.0]) {
          canvas.drawLine(
            Offset(cx + side * 0.13, my - 0.02),
            Offset(cx + side * 0.145, my - 0.035),
            _stroke(0.016),
          );
        }
      case PetFace.tired:
        final mouth = Rect.fromCenter(
            center: Offset(cx, my + 0.01), width: 0.09, height: 0.065);
        canvas.drawOval(mouth, Paint()..color = PetColors.mouth);
        canvas.drawOval(mouth, _stroke(0.016));
        // panting tongue hanging out
        _tongueBlep(
            canvas, Offset(cx + 0.01 * breath, my + 0.028), 0.064, 0.10);
      case PetFace.critical:
        // limp tongue drooping to one side
        canvas.save();
        canvas.translate(cx + 0.035, my + 0.012);
        canvas.rotate(0.45);
        _tongueBlep(canvas, Offset.zero, 0.052, 0.075);
        canvas.restore();
        // wobbly mouth
        final p = Path()..moveTo(cx - 0.09, my + 0.012);
        const n = 4;
        for (var i = 0; i < n; i++) {
          final x0 = cx - 0.09 + 0.18 * i / n;
          final x1 = cx - 0.09 + 0.18 * (i + 1) / n;
          p.quadraticBezierTo((x0 + x1) / 2,
              my + 0.012 + (i.isEven ? -0.022 : 0.022), x1, my + 0.012);
        }
        canvas.drawPath(p, _stroke(0.018));
      case PetFace.funny:
        final mouth = Rect.fromCenter(
            center: Offset(cx, my + 0.02), width: 0.13, height: 0.10);
        canvas.drawOval(mouth, Paint()..color = PetColors.mouth);
        canvas.drawOval(mouth, _stroke(0.018));
        canvas.save();
        canvas.translate(cx + 0.015, my + 0.045);
        canvas.rotate(-0.55);
        _tongueBlep(canvas, Offset.zero, 0.066, 0.15);
        canvas.restore();
    }
  }

  /// Open "D" smile with the tongue inside.
  void _openSmile(Canvas canvas, double cx, double my, double hw, double d) {
    final path = Path()
      ..moveTo(cx - hw, my)
      ..quadraticBezierTo(cx, my + 0.02, cx + hw, my)
      ..quadraticBezierTo(cx, my + d * 2, cx - hw, my)
      ..close();
    canvas.drawPath(path, Paint()..color = PetColors.mouth);
    canvas.save();
    canvas.clipPath(path);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx + hw * 0.1, my + d * 1.05),
          width: hw * 1.2,
          height: d * 1.1),
      Paint()..color = PetColors.tongue,
    );
    canvas.restore();
    canvas.drawPath(path, _stroke(0.02));
  }

  /// Tongue hanging down from [top] (top centre), width [w], length [l].
  void _tongueBlep(Canvas canvas, Offset top, double w, double l) {
    final rr = RRect.fromRectAndCorners(
      Rect.fromLTWH(top.dx - w / 2, top.dy, w, l),
      bottomLeft: Radius.circular(w / 2),
      bottomRight: Radius.circular(w / 2),
    );
    canvas.drawRRect(rr, Paint()..color = PetColors.tongue);
    canvas.drawRRect(rr, _stroke(0.014));
    canvas.drawLine(
      top.translate(0, l * 0.25),
      top.translate(0, l * 0.65),
      _stroke(0.010, PetColors.mouth.withValues(alpha: 0.6)),
    );
  }

  // ------------------------------------------------------------------ leaf
  void _paintLeaf(Canvas canvas, _Geo g) {
    final angle = switch (_mouthFace) {
      PetFace.critical => 1.25,
      PetFace.tired => 0.55,
      PetFace.cheer => -0.05 + 0.25 * math.sin(actionProgress * math.pi * 4),
      PetFace.funny => -0.5,
      _ => -0.28 + 0.06 * breath,
    };
    const len = 0.17;
    const half = 0.065;
    canvas.save();
    canvas.translate(g.cx, g.top + 0.02);
    canvas.rotate(angle);
    // stem
    canvas.drawLine(const Offset(0, 0.01), const Offset(0, -0.03),
        _stroke(0.018, PetColors.leafVein));
    final leaf = Path()
      ..moveTo(0, -0.025)
      ..quadraticBezierTo(-half * 1.6, -0.025 - len * 0.45, 0, -0.025 - len)
      ..quadraticBezierTo(half * 1.6, -0.025 - len * 0.45, 0, -0.025)
      ..close();
    canvas.drawPath(
        leaf,
        Paint()
          ..color = _critical ? PetColors.leafWilted : PetColors.leaf);
    canvas.drawPath(leaf, _stroke(PetProportions.stroke * 0.85));
    canvas.drawLine(const Offset(0, -0.035), const Offset(0, -0.025 - len * 0.8),
        _stroke(0.010, PetColors.leafVein));
    canvas.restore();
  }

  // --------------------------------------------------------------- effects
  void _paintSweat(Canvas canvas, _Geo g) {
    final phase = breath;
    _drop(
      canvas,
      Offset(g.cx + g.eyeOff + PetProportions.bumpRadius * 0.95,
          g.eyeY - 0.02 + phase * 0.05),
      0.07,
      1 - phase * 0.4,
    );
    if (_critical) {
      _drop(
        canvas,
        Offset(g.cx - g.eyeOff - PetProportions.bumpRadius * 1.0,
            g.eyeY + 0.03 + (1 - phase) * 0.04),
        0.06,
        0.6 + phase * 0.4,
      );
    }
  }

  void _drop(Canvas canvas, Offset top, double size, double alpha) {
    final p = Path()
      ..moveTo(top.dx, top.dy)
      ..quadraticBezierTo(top.dx + size * 0.55, top.dy + size * 0.75,
          top.dx, top.dy + size)
      ..quadraticBezierTo(
          top.dx - size * 0.55, top.dy + size * 0.75, top.dx, top.dy)
      ..close();
    canvas.drawPath(
        p, Paint()..color = PetColors.sweat.withValues(alpha: alpha));
    canvas.drawPath(
        p,
        _stroke(0.008,
            const Color(0xFF4A90C2).withValues(alpha: alpha * 0.8)));
  }

  void _paintSparkles(Canvas canvas, _Geo g) {
    final tw = 0.8 + 0.2 * breath;
    final pts = <(Offset, double)>[
      (Offset(g.cx + g.w / 2 + 0.05, g.top + 0.0), 0.05 * tw),
      (Offset(g.cx - g.w / 2 - 0.03, g.top + 0.12), 0.034 * tw),
    ];
    if (isCheering) {
      final k = 0.7 + 0.3 * math.sin(actionProgress * math.pi * 6).abs();
      pts
        ..add((Offset(g.cx - g.w / 2 - 0.06, g.top - 0.06), 0.045 * k))
        ..add((Offset(g.cx + g.w / 2 + 0.07, g.top + 0.18), 0.04 * k))
        ..add((Offset(g.cx + 0.2, g.top - 0.12), 0.03 * k));
    }
    final paint = Paint()..color = PetColors.sparkle;
    for (final (c, r) in pts) {
      final x = c.dx.clamp(0.05, 0.95);
      final y = c.dy.clamp(0.05, 0.95);
      final p = Path()
        ..moveTo(x, y - r)
        ..quadraticBezierTo(x, y, x + r, y)
        ..quadraticBezierTo(x, y, x, y + r)
        ..quadraticBezierTo(x, y, x - r, y)
        ..quadraticBezierTo(x, y, x, y - r)
        ..close();
      canvas.drawPath(p, paint);
    }
  }

  // ---------------------------------------------------------------- helper
  Paint _stroke(double width, [Color color = PetColors.outline]) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  @override
  bool shouldRepaint(PetCharacterPainter oldDelegate) =>
      oldDelegate.pose != pose ||
      oldDelegate.breath != breath ||
      oldDelegate.blink != blink ||
      oldDelegate.action != action ||
      oldDelegate.actionProgress != actionProgress ||
      oldDelegate.animated != animated;
}

/// Derived geometry in unit space for one body shape.
class _Geo {
  _Geo(PetBodySpec spec)
      : w = spec.width,
        h = spec.height,
        bottom = PetProportions.groundY,
        eyeOff = (spec.width * PetProportions.eyeSpreadFactor).clamp(
            PetProportions.eyeSpreadMin, PetProportions.eyeSpreadMax);

  final double cx = 0.5;
  final double w;
  final double h;
  final double bottom;
  final double eyeOff;

  double get top => bottom - h;
  double get eyeY => top + 0.045;
  double get mouthY => eyeY + 0.165;
  Offset get leftEye => Offset(cx - eyeOff, eyeY);
  Offset get rightEye => Offset(cx + eyeOff, eyeY);
}
