/// Pose model for the PetPal frog (character.md §4–5).
library;

import 'package:flutter/foundation.dart';

/// Base facial expression (the "mood" the feature asks for).
///
/// Named `PetExpression` (not `PetMood`) so it never clashes with
/// `PetMood` in features/water/water_models.dart.
enum PetExpression {
  /// Big shiny eyes, open smile, sparkles. (water happy, steps LEAN)
  happy,

  /// Calm open eyes, small smile with tongue "blep". (steps CHUBBY)
  content,

  /// Determined brows, wide grin, sparkles. (steps MUSCLE)
  proud,

  /// Half-closed droopy eyes, panting tongue, sweat. (water tired, steps FAT)
  tired,

  /// Very droopy eyes looking down, wobbly mouth, limp tongue, wilted
  /// leaf, pale body, 2 sweat drops, slower breath. (water critical)
  critical,
}

/// Body shape (character.md §3). Water always uses [normal].
enum PetBodyShape { normal, fat, chubby, lean, muscle }

/// One-shot reaction currently playing.
enum PetAction {
  none,

  /// Tap on the body → jump + funny face.
  jump,

  /// Feature added water / steps → two happy hops, arms up.
  cheer,
}

/// The face actually drawn this frame (expression + blink/action overrides).
enum PetFace { happy, content, proud, tired, critical, blink, funny, cheer }

/// Expression + body shape. Use the static presets for each feature state.
@immutable
class PetPose {
  const PetPose({
    required this.expression,
    this.body = PetBodyShape.normal,
  });

  final PetExpression expression;
  final PetBodyShape body;

  // water — docs/water/game-rules.md §2
  /// 7+ cups.
  static const PetPose waterHappy = PetPose(expression: PetExpression.happy);

  /// 4–6 cups.
  static const PetPose waterTired = PetPose(expression: PetExpression.tired);

  /// 0–3 cups.
  static const PetPose waterCritical =
      PetPose(expression: PetExpression.critical);

  // steps — docs/steps/game-rules.md §2
  /// [0, 35) %.
  static const PetPose stepsFat =
      PetPose(expression: PetExpression.tired, body: PetBodyShape.fat);

  /// [35, 70) %.
  static const PetPose stepsChubby =
      PetPose(expression: PetExpression.content, body: PetBodyShape.chubby);

  /// [70, 100) %.
  static const PetPose stepsLean =
      PetPose(expression: PetExpression.happy, body: PetBodyShape.lean);

  /// 100 % and up.
  static const PetPose stepsMuscle =
      PetPose(expression: PetExpression.proud, body: PetBodyShape.muscle);

  /// Low states show sweat drops, droopy eyes and breathe slower.
  bool get isLowState =>
      expression == PetExpression.tired ||
      expression == PetExpression.critical;

  /// Stable id, e.g. `normal_happy`, `fat_tired`.
  String get id => '${body.name}_${expression.name}';

  PetPose copyWith({PetExpression? expression, PetBodyShape? body}) =>
      PetPose(
        expression: expression ?? this.expression,
        body: body ?? this.body,
      );

  @override
  bool operator ==(Object other) =>
      other is PetPose &&
      other.expression == expression &&
      other.body == body;

  @override
  int get hashCode => Object.hash(expression, body);

  @override
  String toString() => 'PetPose($id)';
}
