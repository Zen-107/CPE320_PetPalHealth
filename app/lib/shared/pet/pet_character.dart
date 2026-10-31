import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'pet_constants.dart';
import 'pet_painter.dart';
import 'pet_pose.dart';

/// The ONE pet of PetPal Health — a chubby frog with a leaf on its head
/// (docs/_design/character.md). Every feature uses this widget.
///
/// ```dart
/// // in the screen's State:
/// final GlobalKey _petKey = GlobalKey(debugLabel: 'water_pet');
/// ...
/// KeyedSubtree(
///   key: ValueKey('water_pet_image_${mood.name}'), // feature key (changes)
///   child: PetCharacter(
///     key: _petKey, // stable for the life of the screen
///     pose: PetPose.waterHappy,
///     size: 160,
///     cheerTrigger: _cupsAddedCount, // increment → happy cheer
///   ),
/// )
/// ```
///
/// - Do NOT put the per-state feature key (`water_pet_image_<mood>`,
///   `steps_pet_image_<status>`) on [PetCharacter] itself: when the state
///   changes the key changes, Flutter disposes the old State and creates a
///   new one, so the cheer that the same tap started is dropped (BUG-PET-1).
///   Put that key on a `KeyedSubtree` wrapper and give [PetCharacter] a
///   `GlobalKey` held in the screen's State — the GlobalKey lets the same
///   State move under the new wrapper and keep playing.
///
/// - [animate] false → one static frame, no AnimationController / Timer
///   is created (use in widget tests and previews).
/// - With [animate] true the pet breathes forever, so tests must use
///   `tester.pump(duration)` instead of `pumpAndSettle()`.
/// - Tests: find the painter with `find.byKey(PetKeys.painter)` and read
///   `(tester.widget<CustomPaint>(...).painter as PetCharacterPainter)`.
class PetCharacter extends StatefulWidget {
  const PetCharacter({
    super.key,
    required this.pose,
    this.size = 160,
    this.animate = true,
    this.random,
    this.cheerTrigger = 0,
    this.reactToTap = true,
    this.onTap,
    this.semanticLabel,
  });

  /// Expression + body shape. Use the presets, e.g. [PetPose.waterTired],
  /// [PetPose.stepsMuscle], [PetPose.foodEating], [PetPose.dashboardCrying].
  /// Eating poses ([PetPose.isEating]) also run a chew loop and bouncing
  /// poses ([PetPose.isBouncing], dashboard CHEERFUL) a hop loop while
  /// animating.
  final PetPose pose;

  /// Side of the square box in logical px (screens use 160).
  final double size;

  /// false = static frame, no tickers.
  final bool animate;

  /// Source of randomness for blink timing (pass `Random(seed)` in tests).
  final math.Random? random;

  /// Every time this value changes the pet plays a cheer (2 happy hops,
  /// arms up). Features increment it when water / steps are added.
  final int cheerTrigger;

  /// Tap on the pet → jump + funny face.
  final bool reactToTap;

  /// Extra callback on tap (called even when [animate] is false).
  final VoidCallback? onTap;

  /// Optional accessibility label (e.g. the status text).
  final String? semanticLabel;

  @override
  State<PetCharacter> createState() => _PetCharacterState();
}

class _PetCharacterState extends State<PetCharacter>
    with TickerProviderStateMixin {
  AnimationController? _breath;
  AnimationController? _blink;
  AnimationController? _action;
  AnimationController? _chew; // only while the pose is eating
  AnimationController? _hop; // only while the pose is bouncing
  Timer? _blinkTimer;
  PetAction _currentAction = PetAction.none;
  late math.Random _random;

  @override
  void initState() {
    super.initState();
    _random = widget.random ?? math.Random();
    if (widget.animate) _start();
  }

  @override
  void didUpdateWidget(PetCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.random != oldWidget.random) {
      _random = widget.random ?? math.Random();
    }
    if (widget.animate != oldWidget.animate) {
      widget.animate ? _start() : _stop();
    } else if (widget.animate &&
        widget.pose.isLowState != oldWidget.pose.isLowState) {
      _breath!
        ..duration = _breathDuration
        ..repeat(reverse: true);
    }
    if (widget.animate && widget.pose.isEating != oldWidget.pose.isEating) {
      _syncChew();
    }
    if (widget.animate &&
        widget.pose.isBouncing != oldWidget.pose.isBouncing) {
      _syncHop();
    }
    if (widget.cheerTrigger != oldWidget.cheerTrigger) {
      _play(PetAction.cheer);
    }
  }

  Duration get _breathDuration =>
      widget.pose.isLowState ? PetTiming.breathLow : PetTiming.breath;

  void _start() {
    _breath = AnimationController(vsync: this, duration: _breathDuration)
      ..repeat(reverse: true);
    _blink = AnimationController(vsync: this, duration: PetTiming.blink);
    _action = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          setState(() => _currentAction = PetAction.none);
        }
      });
    _scheduleBlink();
    _syncChew();
    _syncHop();
  }

  /// Chew loop runs only while the pose is an eating face (food EATING /
  /// OVER_LIMIT_FEEDING) — no extra ticker in the other states.
  void _syncChew() {
    if (widget.pose.isEating) {
      _chew ??= AnimationController(vsync: this, duration: PetTiming.chew)
        ..repeat();
    } else {
      _chew?.dispose();
      _chew = null;
    }
  }

  /// Hop loop runs only while the pose is bouncing (dashboard CHEERFUL) —
  /// no extra ticker in the other states.
  void _syncHop() {
    if (widget.pose.isBouncing) {
      _hop ??= AnimationController(vsync: this, duration: PetTiming.hop)
        ..repeat();
    } else {
      _hop?.dispose();
      _hop = null;
    }
  }

  void _stop() {
    _blinkTimer?.cancel();
    _blinkTimer = null;
    _breath?.dispose();
    _blink?.dispose();
    _action?.dispose();
    _chew?.dispose();
    _hop?.dispose();
    _breath = _blink = _action = _chew = _hop = null;
    _currentAction = PetAction.none;
  }

  void _scheduleBlink() {
    _blinkTimer?.cancel();
    final gap = PetTiming.blinkGapMinMs +
        _random.nextInt(PetTiming.blinkGapRangeMs);
    _blinkTimer = Timer(Duration(milliseconds: gap), () {
      if (!mounted || _blink == null) return;
      _blink!.forward(from: 0);
      _scheduleBlink();
    });
  }

  void _play(PetAction action) {
    final c = _action;
    if (c == null) return; // static: no animation
    setState(() => _currentAction = action);
    c.duration =
        action == PetAction.jump ? PetTiming.jump : PetTiming.cheer;
    c.forward(from: 0);
  }

  void _handleTap() {
    widget.onTap?.call();
    if (!widget.reactToTap) return;
    // don't interrupt a cheer
    if (_currentAction == PetAction.cheer &&
        (_action?.isAnimating ?? false)) {
      return;
    }
    _play(PetAction.jump);
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  PetCharacterPainter _painter() {
    final blinkT = _blink?.value ?? 0;
    // A reaction counts only while its controller is running, so the frame
    // in which it completes already shows the normal face.
    final playing = _action?.isAnimating ?? false;
    final action = playing ? _currentAction : PetAction.none;
    return PetCharacterPainter(
      pose: widget.pose,
      breath: Curves.easeInOut.transform(_breath?.value ?? 0),
      // 0 → 1 → 0 over the blink
      blink: blinkT == 0 ? 0 : math.sin(math.pi * blinkT),
      action: action,
      actionProgress: action == PetAction.none ? 0 : _action!.value,
      animated: widget.animate,
      chew: _chew?.value ?? 0,
      hop: _hop?.value ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = Size.square(widget.size);
    Widget paint() => CustomPaint(
          key: PetKeys.painter,
          size: box,
          painter: _painter(),
        );

    final listenables = <Listenable>[
      ?_breath,
      ?_blink,
      ?_action,
      ?_chew,
      ?_hop,
    ];
    final Widget child = listenables.isEmpty
        ? paint()
        : AnimatedBuilder(
            animation: Listenable.merge(listenables),
            builder: (context, _) => paint(),
          );

    return Semantics(
      label: widget.semanticLabel,
      image: true,
      child: GestureDetector(
        key: PetKeys.character,
        behavior: HitTestBehavior.opaque,
        onTap: _handleTap,
        child: SizedBox.fromSize(size: box, child: child),
      ),
    );
  }
}
