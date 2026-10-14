/// Character constants for the PetPal frog — the ONE place for colours,
/// proportions, timings and test keys. Must match docs/_design/character.md.
library;

import 'package:flutter/widgets.dart';

import 'pet_pose.dart';

/// Palette (character.md §2). Display values only, not game rules.
abstract final class PetColors {
  /// Main body (healthy).
  static const Color body = Color(0xFF9ED98C);

  /// Body when wilted / critical (paler, greyer green).
  static const Color bodyCritical = Color(0xFFBCCDAA);

  /// Feet, hands and leaf.
  static const Color feet = Color(0xFF6FB86A);

  /// Leaf on the head (same green as feet).
  static const Color leaf = Color(0xFF6FB86A);

  /// Leaf when wilted (critical).
  static const Color leafWilted = Color(0xFFB3B26A);

  /// Leaf vein / stem.
  static const Color leafVein = Color(0xFF4E8F4B);

  /// Belly patch.
  static const Color belly = Color(0xFFF4F1D8);

  /// Blush cheeks.
  static const Color cheek = Color(0xFFF7A8B0);

  /// Tongue.
  static const Color tongue = Color(0xFFF27E8D);

  /// Inside of an open mouth.
  static const Color mouth = Color(0xFF7A3341);

  /// Outline for body, limbs, mouth lines.
  static const Color outline = Color(0xFF3F5E3A);

  /// Pupils.
  static const Color pupil = Color(0xFF26331F);

  /// Eye whites and highlights.
  static const Color eyeWhite = Color(0xFFFFFFFF);

  /// Shading crescent on MUSCLE thighs (volume).
  static const Color muscleShade = Color(0xFF7CC46B);

  /// Sweat drops (low states).
  static const Color sweat = Color(0xFF8FD3FF);

  /// Sparkles (happy / proud / cheer).
  static const Color sparkle = Color(0xFFFFD95A);

  /// Ground shadow.
  static const Color shadow = Color(0x22000000);

  /// Drool bubble fill (derpy look, happy / content only).
  static const Color drool = Color(0xFFD4EEFB);

  /// Drool bubble rim.
  static const Color droolOutline = Color(0xFF86C3E3);
}

/// One eye of the derpy look (character.md §4.1). Values are fractions of
/// the sclera radius `r`.
@immutable
class PetEyeSpec {
  const PetEyeSpec({
    required this.lid,
    required this.pupilDx,
    required this.pupilDy,
    required this.pupil,
  });

  /// Upper-lid closure 0 (open) .. 1 (closed).
  final double lid;

  /// Pupil offset from the eye centre (+x = right, +y = down).
  final double pupilDx;
  final double pupilDy;

  /// Pupil radius.
  final double pupil;
}

/// The derpy charm layered on every open-eye face (character.md §4.1):
/// cross-eyed pupils of different sizes, one half-lidded eye in the
/// non-low faces, and a drool bubble at the mouth corner.
abstract final class PetDerpy {
  /// (left eye, right eye) per expression. The right eye is always the
  /// sleepier, smaller-pupil one; the left eye looks up-and-out.
  /// Low states keep BOTH lids >= 0.45 so they stay clearly droopier than
  /// the single half-lid (<= 0.38) of the healthy faces.
  static const Map<PetExpression, (PetEyeSpec, PetEyeSpec)> eyes = {
    PetExpression.happy: (
      PetEyeSpec(lid: 0.0, pupilDx: -0.18, pupilDy: -0.10, pupil: 0.62),
      PetEyeSpec(lid: 0.30, pupilDx: 0.20, pupilDy: 0.24, pupil: 0.50),
    ),
    PetExpression.content: (
      PetEyeSpec(lid: 0.0, pupilDx: -0.16, pupilDy: -0.04, pupil: 0.58),
      PetEyeSpec(lid: 0.38, pupilDx: 0.22, pupilDy: 0.28, pupil: 0.46),
    ),
    PetExpression.proud: (
      PetEyeSpec(lid: 0.0, pupilDx: -0.14, pupilDy: -0.12, pupil: 0.60),
      PetEyeSpec(lid: 0.24, pupilDx: 0.18, pupilDy: 0.14, pupil: 0.50),
    ),
    PetExpression.tired: (
      PetEyeSpec(lid: 0.45, pupilDx: -0.12, pupilDy: 0.30, pupil: 0.56),
      PetEyeSpec(lid: 0.55, pupilDx: 0.16, pupilDy: 0.36, pupil: 0.48),
    ),
    PetExpression.critical: (
      PetEyeSpec(lid: 0.62, pupilDx: -0.10, pupilDy: 0.45, pupil: 0.48),
      PetEyeSpec(lid: 0.70, pupilDx: 0.14, pupilDy: 0.50, pupil: 0.42),
    ),
  };

  /// Lid at or below this on a non-low face = the derpy single half-lid.
  static const double halfLidMax = 0.40;

  /// The lid line overshoots the sclera on both sides and its ends droop.
  static const double lidOvershoot = 0.014;
  static const double lidDroop = 0.012;

  /// Expressions that show the drool bubble (static, not during
  /// jump / cheer). Low states don't drool: their blue element is sweat
  /// and drooling would read as "sick".
  static const Set<PetExpression> droolExpressions = {
    PetExpression.happy,
    PetExpression.content,
  };

  /// Drool bubble radius (grows up to +15 % with the breath).
  static const double droolRadius = 0.028;
  static const double droolBreathGrow = 0.15;
}

/// Body proportions per shape, as fractions of the square side `s`
/// (character.md §3).
@immutable
class PetBodySpec {
  const PetBodySpec({
    required this.width,
    required this.height,
    required this.bellyWidth,
    required this.bellyHeight,
    required this.thighWidth,
    required this.thighHeight,
    required this.footSpread,
    required this.toeRadius,
    this.muscle = false,
    this.bellyRoll = false,
  });

  /// Body (head+torso blob) width.
  final double width;

  /// Body height.
  final double height;

  /// Belly patch size.
  final double bellyWidth;
  final double bellyHeight;

  /// Back-leg haunch size (0 = hidden under the body).
  final double thighWidth;
  final double thighHeight;

  /// Horizontal distance of each front foot from the centre line.
  final double footSpread;

  /// Toe radius of the front feet.
  final double toeRadius;

  /// Muscular thighs drawn in front of the body with muscle lines.
  final bool muscle;

  /// Belly roll line (FAT only).
  final bool bellyRoll;
}

abstract final class PetProportions {
  /// Bottom of the body (feet line) as a fraction of `s`.
  static const double groundY = 0.88;

  /// Eye bump radius.
  static const double bumpRadius = 0.12;

  /// Sclera radius relative to bump radius.
  static const double scleraFactor = 0.80;

  /// Eye centre distance from the centre line = clamp(width * 0.3, min, max).
  static const double eyeSpreadFactor = 0.30;
  static const double eyeSpreadMin = 0.17;
  static const double eyeSpreadMax = 0.22;

  /// Outline stroke width.
  static const double stroke = 0.022;

  /// Max jump height (tap reaction).
  static const double jumpHeight = 0.10;

  /// Max hop height (cheer, 2 hops).
  static const double cheerHopHeight = 0.06;

  /// Breathing scale amplitude (y), x shrinks by half of it.
  static const double breathAmplitude = 0.03;

  static const Map<PetBodyShape, PetBodySpec> bodies = {
    PetBodyShape.normal: PetBodySpec(
      width: 0.74,
      height: 0.58,
      bellyWidth: 0.42,
      bellyHeight: 0.30,
      thighWidth: 0.17,
      thighHeight: 0.15,
      footSpread: 0.15,
      toeRadius: 0.030,
    ),
    PetBodyShape.fat: PetBodySpec(
      width: 0.94,
      height: 0.52,
      bellyWidth: 0.68,
      bellyHeight: 0.36,
      thighWidth: 0.0,
      thighHeight: 0.0,
      footSpread: 0.24,
      toeRadius: 0.024,
      bellyRoll: true,
    ),
    PetBodyShape.chubby: PetBodySpec(
      width: 0.78,
      height: 0.64,
      bellyWidth: 0.50,
      bellyHeight: 0.36,
      thighWidth: 0.16,
      thighHeight: 0.14,
      footSpread: 0.16,
      toeRadius: 0.028,
    ),
    PetBodyShape.lean: PetBodySpec(
      width: 0.56,
      height: 0.62,
      bellyWidth: 0.26,
      bellyHeight: 0.30,
      thighWidth: 0.12,
      thighHeight: 0.22,
      footSpread: 0.12,
      toeRadius: 0.030,
    ),
    PetBodyShape.muscle: PetBodySpec(
      width: 0.60,
      height: 0.60,
      bellyWidth: 0.30,
      bellyHeight: 0.28,
      thighWidth: 0.25,
      thighHeight: 0.27,
      footSpread: 0.20,
      toeRadius: 0.036,
      muscle: true,
    ),
  };
}

/// Animation timings (character.md §6).
abstract final class PetTiming {
  /// One full breath (in + out) when healthy.
  static const Duration breath = Duration(milliseconds: 2400);

  /// Slower breath in low states (tired / critical).
  static const Duration breathLow = Duration(milliseconds: 3400);

  /// Eye blink (close + open).
  static const Duration blink = Duration(milliseconds: 180);

  /// Random gap between blinks: min + random(0..range).
  static const int blinkGapMinMs = 1800;
  static const int blinkGapRangeMs = 3200;

  /// Tap → jump + funny face.
  static const Duration jump = Duration(milliseconds: 650);

  /// Cheer (water / steps added).
  static const Duration cheer = Duration(milliseconds: 900);
}

/// Predictable keys for tests (character.md §7).
abstract final class PetKeys {
  /// Root of [PetCharacter] (the tappable box).
  static const ValueKey<String> character = ValueKey('pet_character');

  /// The `CustomPaint` whose `painter` is a `PetCharacterPainter`.
  static const ValueKey<String> painter = ValueKey('pet_painter');
}
