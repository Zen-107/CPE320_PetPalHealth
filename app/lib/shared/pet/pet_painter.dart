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
    this.chew = 0,
    this.hop = 0,
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

  /// Chew-loop phase 0..1 of the eating faces (0 = static frame: mouth
  /// closed "ω", cheeks fully puffed). See [chewOpen].
  final double chew;

  /// Hop-loop phase 0..1 of the bouncing face (dashboard CHEERFUL; 0 =
  /// static frame: standing on the ground, arms up). See [hopLift].
  final double hop;

  // ---------------------------------------------------------------- getters
  PetExpression get expression => pose.expression;
  PetBodyShape get bodyShape => pose.body;
  PetBodySpec get bodySpec => PetProportions.bodies[pose.body]!;

  bool get isJumping => action == PetAction.jump;
  bool get isCheering => action == PetAction.cheer;

  /// Eyes are (almost) fully closed by a blink this frame.
  bool get isBlinking => action == PetAction.none && blink >= 0.5;

  /// Sweat drops are drawn (low states tired / critical, and overfed).
  bool get showsSweat =>
      pose.isLowState || expression == PetExpression.overfed;

  /// Both eyes are open but heavy-lidded (every lid >=
  /// [PetDerpy.droopyLidMin]) this frame: tired, critical, overfed.
  bool get hasDroopyEyes {
    if (!isDerpyEye) return false;
    final (l, r) = eyeSpecs;
    return math.min(l.lid, r.lid) >= PetDerpy.droopyLidMin;
  }

  /// The derpy open eyes (cross-eyed pupils of different sizes, character.md
  /// §4.1) are drawn this frame — any open-eye mood face, not blink / funny /
  /// cheer, and not the closed food-coma eyes of `full`.
  bool get isDerpyEye =>
      action == PetAction.none && face != PetFace.blink && !_eyesShut;

  /// The expression itself keeps both eyes shut (`full`).
  bool get _eyesShut {
    final (l, r) = eyeSpecs;
    return l.lid >= PetDerpy.closedLid && r.lid >= PetDerpy.closedLid;
  }

  /// Rice ball held in both hands (eating / overfed; kept while blinking,
  /// hidden during jump / cheer).
  bool get showsFood => action == PetAction.none && pose.isEating;

  /// Hamster-like puffed chewing cheeks bulge out of the face.
  bool get showsPuffedCheeks => showsFood;

  /// Little burp puff next to the mouth (full).
  bool get showsBurpPuff =>
      action == PetAction.none && expression == PetExpression.full;

  /// Worried brows (inner ends up) — overfed (open eyes only) and crying
  /// (eyes squeezed shut, kept while blinking).
  bool get showsWorriedBrows =>
      (isDerpyEye && expression == PetExpression.overfed) ||
      (action == PetAction.none && expression == PetExpression.crying);

  /// Tear streams down both cheeks + a falling tear (crying; hidden during
  /// jump / cheer).
  bool get showsTears =>
      action == PetAction.none && expression == PetExpression.crying;

  /// Floating "..." dots next to the head (dazed; hidden during jump /
  /// cheer).
  bool get showsThoughtDots =>
      action == PetAction.none && expression == PetExpression.dazed;

  /// Height (fraction of `s`) of the continuous hop this frame (cheerful,
  /// only when no one-shot action plays; 0 in the static frame).
  double get hopLift => action == PetAction.none && pose.isBouncing
      ? math.sin(math.pi * hop.clamp(0.0, 1.0)) * PetProportions.hopHeight
      : 0;

  /// Arms raised above the head: cheer reaction and the cheerful face.
  bool get _armsUp =>
      isCheering || (action == PetAction.none && pose.isBouncing);

  /// How open the chewing mouth is 0 (closed "ω") .. 1 (open bite).
  double get chewOpen => math.sin(math.pi * chew.clamp(0.0, 1.0));

  /// Left / right eye spec of the current expression (character.md §4.1).
  (PetEyeSpec, PetEyeSpec) get eyeSpecs => PetDerpy.eyes[expression]!;

  /// Exactly one eye is half-lidded (the derpy default look of the healthy
  /// faces happy / content / proud). Low states use [hasDroopyEyes] instead.
  bool get hasHalfLidEye {
    if (!isDerpyEye || pose.isLowState) return false;
    final (l, r) = eyeSpecs;
    return (l.lid > 0) != (r.lid > 0) &&
        math.max(l.lid, r.lid) <= PetDerpy.halfLidMax;
  }

  /// The little drool bubble at the mouth corner is drawn this frame
  /// (happy / content only; kept while blinking; hidden during jump/cheer).
  bool get showsDroolBubble =>
      action == PetAction.none &&
      PetDerpy.droolExpressions.contains(expression);

  /// Sparkles are drawn this frame.
  bool get showsSparkles =>
      isCheering ||
      (action == PetAction.none &&
          (expression == PetExpression.happy ||
              expression == PetExpression.proud ||
              expression == PetExpression.cheerful));

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
      PetExpression.eating => PetFace.eating,
      PetExpression.full => PetFace.full,
      PetExpression.overfed => PetFace.overfed,
      PetExpression.crying => PetFace.crying,
      PetExpression.dazed => PetFace.dazed,
      PetExpression.cheerful => PetFace.cheerful,
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
    } else if (pose.isBouncing && hop > 0) {
      // continuous hop: stretch in the air, squash near the ground
      lift = hopLift;
      final k = lift / PetProportions.hopHeight; // 0 ground .. 1 apex
      sy *= 1 + 0.05 * k - 0.06 * (1 - k) * (1 - k);
      sx *= 1 - 0.025 * k + 0.04 * (1 - k) * (1 - k);
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
    var bodyPath = Path.combine(
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
    // STUFFED: a paunch oval widens the lower body (pear / ball silhouette)
    if (spec.bellyBulge) {
      bodyPath = Path.combine(
        PathOperation.union,
        bodyPath,
        Path()
          ..addOval(Rect.fromCenter(
            center: Offset(g.cx, g.bottom - PetProportions.paunchHeight / 2),
            width: g.w * PetProportions.paunchWidthFactor,
            height: PetProportions.paunchHeight,
          )),
      );
    }
    canvas.drawPath(bodyPath, bodyFill);
    canvas.drawPath(bodyPath, stroke);

    // 4. belly (STUFFED: lower, bulging, outlined)
    final bellyRect = Rect.fromCenter(
      center: Offset(
          g.cx,
          g.bottom -
              spec.bellyHeight / 2 +
              (spec.bellyBulge ? 0.005 : -0.025)),
      width: spec.bellyWidth,
      height: spec.bellyHeight,
    );
    canvas.drawOval(bellyRect, Paint()..color = PetColors.belly);
    if (spec.bellyBulge) _paintBellyBulge(canvas, bellyRect);
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

    // 7. arms (eating: arms -> rice ball -> hands on top of the ball)
    final hands = _paintArms(canvas, g, hands: !showsFood);
    if (showsFood) {
      _paintFood(canvas, g);
      for (final h in hands) {
        _paintHand(canvas, h);
      }
    }

    // 7b. muscular haunches in front of everything below the face (MUSCLE)
    if (spec.muscle) _paintMuscleThighs(canvas, g, spec, bodyFill, stroke);

    // 7c. front feet (always in front of the haunches)
    for (final side in const [-1.0, 1.0]) {
      _paintFoot(canvas, Offset(g.cx + side * spec.footSpread, g.bottom),
          spec.toeRadius);
    }

    // 8. cheeks (eating: puffed bulges first, blush sits on the bulge)
    final puffs = showsPuffedCheeks ? _paintCheekPuffs(canvas, g) : null;
    final cheekAlpha = switch (expression) {
      PetExpression.critical => 0.30,
      PetExpression.tired => 0.55,
      _ => 0.9,
    };
    final cheekPaint = Paint()
      ..color = PetColors.cheek.withValues(
          alpha: face == PetFace.cheer ||
                  face == PetFace.funny ||
                  _mouthFace == PetFace.cheerful
              ? 0.95
              : cheekAlpha);
    for (final side in const [-1.0, 1.0]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: puffs != null
              ? puffs[side < 0 ? 0 : 1].translate(-side * 0.012, -0.004)
              : Offset(g.cx + side * (g.eyeOff + 0.045), g.eyeY + 0.125),
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

    // 10a. tear streams + falling tear (crying) — over the cheeks
    if (showsTears) _paintTears(canvas, g);

    // 10b. drool bubble (derpy, happy / content / dazed)
    if (showsDroolBubble) _paintDrool(canvas, g);

    // 10c. crumbs (eating / overfed) and burp puff (full)
    if (showsFood) _paintCrumbs(canvas, g);
    if (showsBurpPuff) _paintBurp(canvas, g);

    // 10d. floating "..." (dazed)
    if (showsThoughtDots) _paintThoughtDots(canvas, g);

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

  /// Draws both arms; returns the hand centres (left, right). With
  /// [hands] false the hands are left to the caller (eating: drawn on top
  /// of the rice ball).
  List<Offset> _paintArms(Canvas canvas, _Geo g, {bool hands = true}) {
    const thick = 0.055;
    final out = <Offset>[];
    for (final side in const [-1.0, 1.0]) {
      final shoulder =
          Offset(g.cx + side * (g.w / 2 - 0.075), g.top + g.h * 0.55);
      final List<Offset> joints;
      if (_armsUp) {
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
      } else if (showsFood) {
        // both hands hold the rice ball under the mouth
        final f = _foodCenter(g);
        joints = [
          Offset(g.cx + side * (g.w / 2 - 0.11), g.top + g.h * 0.76),
          Offset(f.dx + side * PetProportions.foodSize * 0.40,
              f.dy + PetProportions.foodSize * 0.12),
        ];
      } else if (expression == PetExpression.full) {
        // patting the round belly
        joints = [
          Offset(g.cx + side * (g.w / 2 - 0.09),
              g.top + g.h * 0.70 + 0.008 * breath),
        ];
      } else if (pose.isLowState ||
          expression == PetExpression.crying) {
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
      out.add(pts.last);
      if (hands) _paintHand(canvas, pts.last);
    }
    return out;
  }

  void _paintHand(Canvas canvas, Offset hand) {
    canvas.drawCircle(hand, 0.032, Paint()..color = PetColors.feet);
    canvas.drawCircle(hand, 0.032, _stroke(PetProportions.stroke * 0.8));
  }

  // ------------------------------------------------------------------ food
  /// Rice ball centre: under the mouth, lifted toward it on each bite.
  Offset _foodCenter(_Geo g) =>
      Offset(g.cx, g.mouthY + 0.135 - 0.025 * chewOpen);

  /// Rounded-triangle rice ball with a nori band and a bite taken out.
  void _paintFood(Canvas canvas, _Geo g) {
    final c = _foodCenter(g);
    const w = PetProportions.foodSize;
    const h = w * 0.92;
    final top = c.translate(0, -h / 2);
    final bl = c.translate(-w / 2, h / 2);
    final br = c.translate(w / 2, h / 2);
    Offset l(Offset a, Offset b, double t) => Offset.lerp(a, b, t)!;
    const k = 0.22;
    final tri = Path()
      ..moveTo(l(top, bl, k).dx, l(top, bl, k).dy)
      ..quadraticBezierTo(
          top.dx, top.dy, l(top, br, k).dx, l(top, br, k).dy)
      ..lineTo(l(br, top, k).dx, l(br, top, k).dy)
      ..quadraticBezierTo(br.dx, br.dy, l(br, bl, k).dx, l(br, bl, k).dy)
      ..lineTo(l(bl, br, k).dx, l(bl, br, k).dy)
      ..quadraticBezierTo(bl.dx, bl.dy, l(bl, top, k).dx, l(bl, top, k).dy)
      ..close();
    // bite out of the upper-right edge
    final rice = Path.combine(
      PathOperation.difference,
      tri,
      Path()
        ..addOval(Rect.fromCircle(
            center: l(top, br, 0.36).translate(0.022, -0.014),
            radius: 0.036)),
    );
    canvas.drawPath(rice, Paint()..color = PetColors.rice);
    canvas.save();
    canvas.clipPath(rice);
    canvas.drawRect(
      Rect.fromCenter(
          center: c.translate(0, h * 0.30), width: w * 0.42, height: h * 0.5),
      Paint()..color = PetColors.nori,
    );
    canvas.restore();
    canvas.drawPath(rice, _stroke(0.016));
  }

  /// Two rice crumbs flying off the mouth corners.
  void _paintCrumbs(Canvas canvas, _Geo g) {
    final my = g.mouthY;
    final o = chewOpen;
    for (final (c, a) in [
      (Offset(g.cx - 0.085, my + 0.020 - 0.018 * o), -0.5),
      (Offset(g.cx + 0.090, my + 0.045 - 0.012 * o), 0.6),
    ]) {
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(a);
      final r =
          Rect.fromCenter(center: Offset.zero, width: 0.024, height: 0.015);
      canvas.drawOval(r, Paint()..color = PetColors.rice);
      canvas.drawOval(r, _stroke(0.006));
      canvas.restore();
    }
  }

  /// Puffed chewing cheeks bulging out of the face outline. Returns the
  /// bulge centres (left, right). They deflate a bit when the mouth opens.
  List<Offset> _paintCheekPuffs(Canvas canvas, _Geo g) {
    final y = g.mouthY + 0.005;
    // half-width of the body blob (top ellipse) at that height
    final ry = g.h * 0.62;
    final dy = (g.top + ry) - y;
    final hw = dy > 0
        ? g.w / 2 * math.sqrt(math.max(0, 1 - (dy / ry) * (dy / ry)))
        : g.w / 2;
    final rad = PetProportions.cheekPuffRadius * (1 - 0.3 * chewOpen);
    final out = <Offset>[];
    for (final side in const [-1.0, 1.0]) {
      final c = Offset(g.cx + side * (hw - rad * 0.55), y);
      final rect = Rect.fromCircle(center: c, radius: rad);
      canvas.drawOval(rect, Paint()..color = _bodyColor);
      // outline only on the outer side so the bulge merges into the face
      canvas.drawArc(rect, side > 0 ? -0.45 * math.pi : 0.55 * math.pi,
          0.9 * math.pi, false, _stroke(PetProportions.stroke));
      out.add(c);
    }
    return out;
  }

  /// Taut STUFFED belly: faint outline, navel and a shine.
  void _paintBellyBulge(Canvas canvas, Rect belly) {
    canvas.drawOval(
        belly, _stroke(0.012, PetColors.outline.withValues(alpha: 0.40)));
    canvas.drawOval(
      Rect.fromCenter(
        center:
            belly.center.translate(-belly.width * 0.24, -belly.height * 0.22),
        width: belly.width * 0.24,
        height: belly.height * 0.14,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.75),
    );
    canvas.drawCircle(belly.center.translate(0, belly.height * 0.12), 0.009,
        Paint()..color = PetColors.outline.withValues(alpha: 0.45));
  }

  /// Small burp cloud rising from the mouth corner (full).
  void _paintBurp(Canvas canvas, _Geo g) {
    final base = Offset(g.cx + 0.15, g.mouthY + 0.005 - 0.015 * breath);
    final cloud = Path.combine(
      PathOperation.union,
      Path()..addOval(Rect.fromCircle(center: base, radius: 0.026)),
      Path()
        ..addOval(Rect.fromCircle(
            center: base.translate(0.036, -0.026), radius: 0.021))
        ..addOval(Rect.fromCircle(
            center: base.translate(0.064, -0.058), radius: 0.015)),
    );
    canvas.drawPath(cloud, Paint()..color = PetColors.burp);
    canvas.drawPath(
        cloud, _stroke(0.007, PetColors.outline.withValues(alpha: 0.55)));
  }

  // ------------------------------------------------------------------ eyes
  void _paintEyes(Canvas canvas, _Geo g) {
    final r = PetProportions.bumpRadius * PetProportions.scleraFactor;
    // faces whose eyes are shut anyway keep their own eyes during a blink
    final f = face == PetFace.blink && _eyesShut ? _expressionFace : face;
    for (final side in const [-1.0, 1.0]) {
      final e = side < 0 ? g.leftEye : g.rightEye;
      final (left, right) = eyeSpecs;
      final spec = side < 0 ? left : right;
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
        case PetFace.content:
          _openEye(canvas, e, r, spec, side);
        case PetFace.proud:
          _openEye(canvas, e, r, spec, side);
          // determined brows (inner end lower)
          canvas.drawLine(
            Offset(e.dx + side * r * 0.75, e.dy - r - 0.050),
            Offset(e.dx - side * r * 0.55, e.dy - r - 0.012),
            _stroke(0.026),
          );
        case PetFace.tired:
          _openEye(canvas, e, r, spec, side);
        case PetFace.eating:
          _openEye(canvas, e, r, spec, side);
        case PetFace.full:
          // food coma: blissful closed eyes
          _closedEye(canvas, e, r);
        case PetFace.overfed:
          _openEye(canvas, e, r, spec, side);
          _worriedBrow(canvas, e, r, side);
        case PetFace.crying:
          // squeezed shut: a wide arch tilted sad (outer end lower)
          canvas.drawPath(
            Path()
              ..moveTo(e.dx - side * r * 0.85, e.dy + r * 0.05)
              ..quadraticBezierTo(e.dx - side * r * 0.05, e.dy - r * 0.45,
                  e.dx + side * r * 0.85, e.dy + r * 0.30),
            _stroke(0.032),
          );
          if (showsWorriedBrows) _worriedBrow(canvas, e, r, side, low: true);
        case PetFace.dazed:
          _openEye(canvas, e, r, spec, side);
        case PetFace.cheerful:
          // ^ ^ (same as the cheer reaction)
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
        case PetFace.critical:
          _openEye(canvas, e, r, spec, side);
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

  /// Worried brow (inner end higher — mirror of the proud brow).
  /// [low] sits the brow closer to the eye (crying: the eye is a line).
  void _worriedBrow(Canvas canvas, Offset e, double r, double side,
      {bool low = false}) {
    final d = low ? 0.052 : 0.0;
    canvas.drawLine(
      Offset(e.dx - side * r * 0.55, e.dy - r - 0.062 + d),
      Offset(e.dx + side * r * 0.75, e.dy - r - 0.010 + d),
      _stroke(0.024),
    );
  }

  /// One derpy open eye: pupil offset/size and upper lid from [spec]
  /// (character.md §4.1). [side] −1 = left, +1 = right (lid droops outward).
  void _openEye(Canvas canvas, Offset e, double r, PetEyeSpec spec,
      double side) {
    final effLid = math.max(spec.lid, blink.clamp(0.0, 1.0));
    if (effLid >= PetDerpy.closedLid) {
      _closedEye(canvas, e, r);
      return;
    }
    final sclera = Rect.fromCircle(center: e, radius: r);
    canvas.drawOval(sclera, Paint()..color = PetColors.eyeWhite);
    canvas.save();
    canvas.clipPath(Path()..addOval(sclera));
    final pc = e.translate(spec.pupilDx * r, spec.pupilDy * r);
    final pr = r * spec.pupil;
    canvas.drawCircle(pc, pr, Paint()..color = PetColors.pupil);
    final hi = Paint()..color = PetColors.eyeWhite;
    canvas.drawCircle(pc.translate(-pr * 0.35, -pr * 0.38), pr * 0.34, hi);
    canvas.drawCircle(pc.translate(pr * 0.38, pr * 0.32), pr * 0.15, hi);
    Path? lidEdge;
    if (effLid > 0) {
      final lidY = e.dy - r + 2 * r * effLid;
      final dy = lidY - e.dy;
      final hw = math.sqrt(math.max(0, r * r - dy * dy));
      final x0 = e.dx - hw - PetDerpy.lidOvershoot;
      final x1 = e.dx + hw + PetDerpy.lidOvershoot;
      // droopy lid: the outer end hangs a bit lower, the middle bulges up
      final yIn = lidY + PetDerpy.lidDroop * 0.3;
      final yOut = lidY + PetDerpy.lidDroop;
      final yl = side < 0 ? yOut : yIn;
      final yr = side < 0 ? yIn : yOut;
      lidEdge = Path()
        ..moveTo(x0, yl)
        ..quadraticBezierTo(e.dx, lidY - PetDerpy.lidDroop, x1, yr);
      // the lid fill is clipped to a slightly bigger circle (hidden under the
      // sclera outline) so no white hairline shows above the lid
      canvas.restore();
      canvas.save();
      canvas.clipPath(Path()..addOval(sclera.inflate(0.006)));
      canvas.drawPath(
        Path.from(lidEdge)
          ..lineTo(x1, e.dy - r - 0.02)
          ..lineTo(x0, e.dy - r - 0.02)
          ..close(),
        Paint()..color = _bodyColor,
      );
    }
    canvas.restore();
    canvas.drawOval(sclera, _stroke(0.014));
    if (lidEdge != null) canvas.drawPath(lidEdge, _stroke(0.022));
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
      case PetFace.cheerful:
        _openSmile(canvas, cx, my, 0.13, 0.11);
      case PetFace.crying:
        // wailing: wide open mouth, corners pulled down, tongue inside
        final wail = Path()
          ..moveTo(cx - 0.105, my + 0.050)
          ..quadraticBezierTo(cx, my - 0.045, cx + 0.105, my + 0.050)
          ..quadraticBezierTo(cx + 0.090, my + 0.120, cx, my + 0.122)
          ..quadraticBezierTo(cx - 0.090, my + 0.120, cx - 0.105, my + 0.050)
          ..close();
        canvas.drawPath(wail, Paint()..color = PetColors.mouth);
        canvas.save();
        canvas.clipPath(wail);
        canvas.drawOval(
          Rect.fromCenter(
              center: Offset(cx, my + 0.118), width: 0.12, height: 0.06),
          Paint()..color = PetColors.tongue,
        );
        canvas.restore();
        canvas.drawPath(wail, _stroke(0.02));
      case PetFace.dazed:
        // small blank "o", a bit off-centre
        final o = Rect.fromCenter(
            center: Offset(cx - 0.012, my + 0.022), width: 0.05, height: 0.04);
        canvas.drawOval(o, Paint()..color = PetColors.mouth);
        canvas.drawOval(o, _stroke(0.016));
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
      case PetFace.eating:
        _chewMouth(canvas, cx, my);
      case PetFace.overfed:
        _chewMouth(canvas, cx, my, droop: 0.016);
      case PetFace.full:
        // satisfied wide smile, tongue licking the left corner
        canvas.save();
        canvas.translate(cx - 0.085, my + 0.012);
        canvas.rotate(0.55);
        _tongueBlep(canvas, Offset.zero, 0.042, 0.04);
        canvas.restore();
        canvas.drawPath(
          Path()
            ..moveTo(cx - 0.11, my - 0.005)
            ..quadraticBezierTo(cx, my + 0.065, cx + 0.11, my - 0.005),
          _stroke(0.02),
        );
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

  /// Chewing mouth: closed "ω" munch while [chewOpen] < 0.3, otherwise a
  /// small open bite with the tongue showing. [droop] pulls the ω ends down
  /// (overfed: chewing reluctantly).
  void _chewMouth(Canvas canvas, double cx, double my, {double droop = 0}) {
    final o = chewOpen;
    if (o < 0.3) {
      const hw = 0.072;
      canvas.drawPath(
        Path()
          ..moveTo(cx - hw, my + droop)
          ..quadraticBezierTo(cx - hw * 0.55, my + 0.05, cx, my + 0.008)
          ..quadraticBezierTo(cx + hw * 0.55, my + 0.05, cx + hw, my + droop),
        _stroke(0.022),
      );
      return;
    }
    final mouth = Rect.fromCenter(
        center: Offset(cx, my + 0.016), width: 0.085, height: 0.025 + 0.05 * o);
    canvas.drawOval(mouth, Paint()..color = PetColors.mouth);
    canvas.save();
    canvas.clipPath(Path()..addOval(mouth));
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, mouth.bottom), width: 0.06, height: 0.04),
      Paint()..color = PetColors.tongue,
    );
    canvas.restore();
    canvas.drawOval(mouth, _stroke(0.018));
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

  /// Light-blue drool bubble with a highlight next to the tongue / mouth
  /// corner (character.md §4.1).
  void _paintDrool(Canvas canvas, _Geo g) {
    final c = switch (expression) {
      // hangs under the right corner of the open "D" smile
      PetExpression.happy => Offset(g.cx + 0.118, g.mouthY + 0.036),
      // dangles from the right edge of the small "o"
      PetExpression.dazed => Offset(g.cx + 0.030, g.mouthY + 0.050),
      // next to the tip of the "blep" tongue
      _ => Offset(g.cx + 0.068, g.mouthY + 0.066),
    };
    final rad = PetDerpy.droolRadius * (1 + PetDerpy.droolBreathGrow * breath);
    canvas.drawCircle(c, rad, Paint()..color = PetColors.drool);
    canvas.drawCircle(c, rad, _stroke(0.008, PetColors.droolOutline));
    canvas.drawCircle(c.translate(-rad * 0.35, -rad * 0.35), rad * 0.30,
        Paint()..color = PetColors.eyeWhite);
  }

  // ------------------------------------------------------------------ leaf
  void _paintLeaf(Canvas canvas, _Geo g) {
    final angle = switch (_mouthFace) {
      PetFace.critical => 1.25,
      PetFace.tired => 0.55,
      PetFace.cheer => -0.05 + 0.25 * math.sin(actionProgress * math.pi * 4),
      PetFace.funny => -0.5,
      PetFace.overfed => 0.55,
      PetFace.full => 0.32 + 0.05 * breath,
      PetFace.eating => -0.28 + 0.10 * chewOpen,
      PetFace.crying => 1.05,
      PetFace.dazed => 0.20 + 0.10 * breath,
      PetFace.cheerful => -0.05 + 0.22 * math.sin(hop * math.pi * 2),
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

  /// Two tear streams from the outer eye corners down the cheeks, and a
  /// tear that falls off the left eye with the breath (crying).
  void _paintTears(Canvas canvas, _Geo g) {
    final r = PetProportions.bumpRadius * PetProportions.scleraFactor;
    final fill = Paint()..color = PetColors.tear;
    final rim = _stroke(0.008, PetColors.tearOutline.withValues(alpha: 0.85));
    for (final side in const [-1.0, 1.0]) {
      final e = side < 0 ? g.leftEye : g.rightEye;
      final x0 = e.dx + side * r * 0.40;
      final y0 = e.dy + r * 0.32;
      final y1 = g.mouthY + 0.13;
      final x1 = x0 + side * 0.016;
      const wTop = 0.036;
      const wBot = 0.054;
      final stream = Path()
        ..moveTo(x0 - wTop / 2, y0)
        ..quadraticBezierTo(x0 - wTop / 2 + side * 0.010, (y0 + y1) / 2,
            x1 - wBot / 2, y1)
        ..arcToPoint(Offset(x1 + wBot / 2, y1),
            radius: const Radius.circular(wBot / 2), clockwise: false)
        ..quadraticBezierTo(x0 + wTop / 2 + side * 0.010, (y0 + y1) / 2,
            x0 + wTop / 2, y0)
        ..close();
      canvas.drawPath(stream, fill);
      canvas.drawPath(stream, rim);
      // shine line down the stream
      canvas.drawLine(
          Offset(x0 - wTop * 0.15, y0 + 0.02),
          Offset(x1 - wBot * 0.18, y1 - 0.02),
          _stroke(0.006, PetColors.eyeWhite.withValues(alpha: 0.8)));
    }
    // falling tear off the outer side of the left eye
    final e = g.leftEye;
    _drop(
      canvas,
      Offset(e.dx - r * 1.05, e.dy + r * 0.2 + breath * 0.06),
      0.055,
      1 - breath * 0.35,
      PetColors.tear,
    );
  }

  /// Three "..." dots floating up-right of the head, bobbing with the
  /// breath (dazed).
  void _paintThoughtDots(Canvas canvas, _Geo g) {
    final base = Offset(
        g.cx + g.eyeOff + PetProportions.bumpRadius + 0.02, g.top - 0.03);
    final paint = Paint()..color = PetColors.dazedDots;
    for (var i = 0; i < 3; i++) {
      final c = base.translate(0.045 * i,
          -0.030 * i - 0.012 * math.sin(math.pi * (breath + i / 3)));
      canvas.drawCircle(
          Offset(c.dx.clamp(0.03, 0.97), c.dy.clamp(0.03, 0.97)),
          0.016 + 0.003 * i,
          paint);
    }
  }

  void _drop(Canvas canvas, Offset top, double size, double alpha,
      [Color color = PetColors.sweat]) {
    final p = Path()
      ..moveTo(top.dx, top.dy)
      ..quadraticBezierTo(top.dx + size * 0.55, top.dy + size * 0.75,
          top.dx, top.dy + size)
      ..quadraticBezierTo(
          top.dx - size * 0.55, top.dy + size * 0.75, top.dx, top.dy)
      ..close();
    canvas.drawPath(p, Paint()..color = color.withValues(alpha: alpha));
    canvas.drawPath(
        p,
        _stroke(0.008, PetColors.tearOutline.withValues(alpha: alpha * 0.8)));
  }

  void _paintSparkles(Canvas canvas, _Geo g) {
    final tw = 0.8 + 0.2 * breath;
    final pts = <(Offset, double)>[
      (Offset(g.cx + g.w / 2 + 0.05, g.top + 0.0), 0.05 * tw),
      (Offset(g.cx - g.w / 2 - 0.03, g.top + 0.12), 0.034 * tw),
    ];
    if (isCheering || pose.isBouncing) {
      final phase = isCheering ? actionProgress * 6 : hop * 2;
      final k = 0.7 + 0.3 * math.sin(phase * math.pi).abs();
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
      oldDelegate.animated != animated ||
      oldDelegate.chew != chew ||
      oldDelegate.hop != hop;
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
