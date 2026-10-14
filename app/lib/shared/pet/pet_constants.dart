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
