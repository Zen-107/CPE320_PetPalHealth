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

  /// Holds a rice ball, cross-eyed at the food, puffed chewing cheeks,
  /// "ω" munching mouth, crumbs. (food EATING)
  eating,

  /// Food coma: blissful closed eyes, satisfied smile licking the lips,
  /// hands patting the belly, burp puff. (food OVER_LIMIT)
  full,

  /// Still eating while stuffed: heavy lids on both eyes cross-eyed at the
  /// food, worried brows, puffed cheeks, sweat drop. (food OVER_LIMIT_FEEDING)
  overfed,
}

/// Body shape (character.md §3). Water always uses [normal].
/// [stuffed] = round bulging "พุงกาง" belly (food OVER_LIMIT*).
enum PetBodyShape { normal, fat, chubby, lean, muscle, stuffed }

/// One-shot reaction currently playing.
enum PetAction {
  none,

  /// Tap on the body → jump + funny face.
  jump,

  /// Feature added water / steps → two happy hops, arms up.
  cheer,
}

/// The face actually drawn this frame (expression + blink/action overrides).
enum PetFace {
  happy,
  content,
  proud,
  tired,
  critical,
  blink,
  funny,
  cheer,
  eating,
  full,
  overfed,
}

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

  // food — docs/food/game-rules.md §2
  /// `NORMAL` (hungry / normal): reuses the existing content face
  /// (blep tongue + drool bubble reads as "hungry") on the normal body.
  static const PetPose foodNormal =
      PetPose(expression: PetExpression.content);

  /// `EATING` (transient, shown while the feature is in EATING).
  static const PetPose foodEating = PetPose(expression: PetExpression.eating);

  /// `OVER_LIMIT` (อิ่มพุงกาง).
  static const PetPose foodOverLimit =
      PetPose(expression: PetExpression.full, body: PetBodyShape.stuffed);

  /// `OVER_LIMIT_FEEDING` (อิ่มพุงกางแต่ยังกิน, transient).
  static const PetPose foodOverLimitFeeding =
      PetPose(expression: PetExpression.overfed, body: PetBodyShape.stuffed);

  /// Eating faces hold food and chew (the widget runs a chew loop).
  bool get isEating =>
      expression == PetExpression.eating ||
      expression == PetExpression.overfed;

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
