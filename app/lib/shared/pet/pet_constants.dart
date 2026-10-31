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

  /// Rice ball the frog eats (food EATING / OVER_LIMIT_FEEDING) + crumbs.
  static const Color rice = Color(0xFFFFFCF2);

  /// Seaweed band on the rice ball.
  static const Color nori = Color(0xFF34473A);

  /// Burp puff (food OVER_LIMIT).
  static const Color burp = Color(0xFFF2F6EE);
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
    // food: both pupils turn IN and DOWN = cross-eyed at the rice ball
    PetExpression.eating: (
      PetEyeSpec(lid: 0.0, pupilDx: 0.24, pupilDy: 0.30, pupil: 0.60),
      PetEyeSpec(lid: 0.30, pupilDx: -0.22, pupilDy: 0.34, pupil: 0.48),
    ),
    // food coma: both lids shut (drawn as closed "‿" eyes, no derpy pupils)
    PetExpression.full: (
      PetEyeSpec(lid: 1.0, pupilDx: 0.0, pupilDy: 0.0, pupil: 0.0),
      PetEyeSpec(lid: 1.0, pupilDx: 0.0, pupilDy: 0.0, pupil: 0.0),
    ),
    // stuffed but still eating: heavy lids on BOTH eyes (>= 0.45, like the
    // low states) + cross-eyed at the food
    PetExpression.overfed: (
      PetEyeSpec(lid: 0.48, pupilDx: 0.22, pupilDy: 0.36, pupil: 0.56),
      PetEyeSpec(lid: 0.58, pupilDx: -0.20, pupilDy: 0.40, pupil: 0.46),
    ),
  };

  /// Lid at or above this = the eye is drawn closed.
  static const double closedLid = 0.92;

  /// Every lid at or above this on an open-eye face = heavy, droopy eyes
  /// (tired / critical / overfed) — never reached by the single half-lid.
  static const double droopyLidMin = 0.45;

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
    this.bellyBulge = false,
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

  /// Round taut belly bulging out of the lower body, outlined + shine
  /// (STUFFED only, food OVER_LIMIT*).
  final bool bellyBulge;
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
    PetBodyShape.stuffed: PetBodySpec(
      width: 0.80,
      height: 0.60,
      bellyWidth: 0.62,
      bellyHeight: 0.38,
      thighWidth: 0.16,
      thighHeight: 0.14,
      footSpread: 0.19,
      toeRadius: 0.028,
      bellyBulge: true,
    ),
  };

  /// STUFFED: the lower body is widened by a paunch oval of
  /// (width × this, [paunchHeight]) so the silhouette becomes pear / ball.
  static const double paunchWidthFactor = 1.06;
  static const double paunchHeight = 0.36;

  /// Rice ball (food) width; height = width × 0.92.
  static const double foodSize = 0.20;

  /// Puffed chewing cheek bulge radius.
  static const double cheekPuffRadius = 0.058;
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

  /// One chomp of the chew loop (food eating faces, repeats while the pose
  /// is eating). How long EATING lasts is the feature's rule, not the pet's.
  static const Duration chew = Duration(milliseconds: 420);
}

/// Predictable keys for tests (character.md §7).
abstract final class PetKeys {
  /// Root of [PetCharacter] (the tappable box).
  static const ValueKey<String> character = ValueKey('pet_character');

  /// The `CustomPaint` whose `painter` is a `PetCharacterPainter`.
  static const ValueKey<String> painter = ValueKey('pet_painter');
}
