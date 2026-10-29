// QA pet (2026-10-14): เทสต์ shared PetCharacter (app/lib/shared/pet/)
//
// ค่าคาดหวังทุกตัวมาจาก docs/_design/character.md (§3 สัดส่วน, §4 สีหน้า, §5 ตาราง preset,
// §6 อนิเมชัน/เวลา, §7 วิธีใช้/การตรวจในเทสต์) — ไม่ลอกจาก pet_constants.dart
// เวลาเดินด้วย tester.pump(Duration) (fake async) เท่านั้น ไม่ใช้เวลาจริง/sleep
// animate: true → สัตว์เลี้ยงหายใจตลอด จึงห้ามใช้ pumpAndSettle ในเทสต์กลุ่มนั้น
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/shared/pet/pet.dart';

// ---------------------------------------------------------------------------
// ค่าจาก character.md
// ---------------------------------------------------------------------------
const docJumpMs = 650; // §6 jump
const docCheerMs = 900; // §6 cheer
const docBlinkMs = 180; // §4/§6 blink นาน 180 ms
const docBlinkGapMinMs = 1800; // §6 ห่างกัน 1800 + random(0..3200)
const docBlinkGapRangeMs = 3200;
const docSize = 160.0; // §3 บนหน้าจอ s = 160

/// §5 ตาราง preset → (สีหน้า, รูปร่าง, หน้าที่วาดตอนนิ่ง (§4), id)
final docPresets = <String, (PetPose, PetExpression, PetBodyShape, PetFace)>{
  'waterHappy': (
    PetPose.waterHappy,
    PetExpression.happy,
    PetBodyShape.normal,
    PetFace.happy
  ),
  'waterTired': (
    PetPose.waterTired,
    PetExpression.tired,
    PetBodyShape.normal,
    PetFace.tired
  ),
  'waterCritical': (
    PetPose.waterCritical,
    PetExpression.critical,
    PetBodyShape.normal,
    PetFace.critical
  ),
  'stepsFat': (
    PetPose.stepsFat,
    PetExpression.tired,
    PetBodyShape.fat,
    PetFace.tired
  ),
  'stepsChubby': (
    PetPose.stepsChubby,
    PetExpression.content,
    PetBodyShape.chubby,
    PetFace.content
  ),
  'stepsLean': (
    PetPose.stepsLean,
    PetExpression.happy,
    PetBodyShape.lean,
    PetFace.happy
  ),
  'stepsMuscle': (
    PetPose.stepsMuscle,
    PetExpression.proud,
    PetBodyShape.muscle,
    PetFace.proud
  ),
};

/// §4: tired = หยดเหงื่อ 1 หยด + หนังตาตก, critical = เหงื่อ 2 หยด + หนังตาตกมาก
/// → preset ที่ใช้สีหน้า tired/critical คือ "สถานะต่ำ"
const docLowStates = {'waterTired', 'waterCritical', 'stepsFat'};

/// §3 กว้าง × สูงตัว
const docBodySize = {
  PetBodyShape.normal: (0.74, 0.58),
  PetBodyShape.fat: (0.94, 0.52),
  PetBodyShape.chubby: (0.78, 0.64),
  PetBodyShape.lean: (0.56, 0.62),
  PetBodyShape.muscle: (0.60, 0.60),
};

PetCharacterPainter painterOf(WidgetTester tester, [Finder? within]) {
  final f = within == null
      ? find.byKey(PetKeys.painter)
      : find.descendant(of: within, matching: find.byKey(PetKeys.painter));
  return tester.widget<CustomPaint>(f).painter! as PetCharacterPainter;
}

Widget host(Widget child) =>
    Directionality(textDirection: TextDirection.ltr, child: Center(child: child));

/// โฮสต์ที่เปลี่ยน cheerTrigger ได้จากภายนอก
class CheerHost extends StatefulWidget {
  const CheerHost({super.key, required this.pose, this.animate = true});
  final PetPose pose;
  final bool animate;
  @override
  State<CheerHost> createState() => CheerHostState();
}

class CheerHostState extends State<CheerHost> {
  int trigger = 0;
  void cheer() => setState(() => trigger++);
  @override
  Widget build(BuildContext context) => host(PetCharacter(
        pose: widget.pose,
        animate: widget.animate,
        random: Random(1),
        cheerTrigger: trigger,
      ));
}

void main() {
  // =========================================================================
  // §5 preset ทั้ง 7 → สีหน้า / รูปร่าง / หน้าที่วาด
  // =========================================================================
  group('§5 preset 7 ท่า', () {
    for (final e in docPresets.entries) {
      final (pose, expr, body, face) = e.value;
      test('POSE_${e.key}_is_${expr.name}_${body.name}', () {
        expect(pose.expression, expr);
        expect(pose.body, body);
        expect(pose.id, '${body.name}_${expr.name}');
        expect(pose.isLowState, docLowStates.contains(e.key));
      });

      testWidgets('PAINT_${e.key}_static_face_${face.name}', (tester) async {
        await tester.pumpWidget(
            host(PetCharacter(pose: pose, animate: false)));
        final p = painterOf(tester);
        expect(p.pose, pose);
        expect(p.expression, expr);
        expect(p.bodyShape, body);
        expect(p.face, face);
        expect(p.animated, isFalse);
        expect(p.isJumping, isFalse);
        expect(p.isCheering, isFalse);
        expect(p.isBlinking, isFalse);
        expect(tester.getSize(find.byKey(PetKeys.character)),
            const Size(docSize, docSize),
            reason: 'ขนาดเริ่มต้น 160 (§3, §7)');
        expect(tester.takeException(), isNull, reason: 'วาดได้ไม่ error');
      });
    }

    test('POSE_all_7_presets_are_distinct', () {
      final poses = docPresets.values.map((v) => v.$1).toSet();
      expect(poses.length, 7);
    });

    test('POSE_equality_and_copyWith', () {
      expect(const PetPose(expression: PetExpression.tired, body: PetBodyShape.fat),
          PetPose.stepsFat);
      expect(PetPose.waterHappy.copyWith(body: PetBodyShape.lean),
          PetPose.stepsLean);
      expect(const PetPose(expression: PetExpression.happy).body,
          PetBodyShape.normal,
          reason: '§7 body = normal เป็นค่าเริ่มต้น');
    });
  });

  // =========================================================================
  // §4 สถานะต่ำ: เหงื่อ + ตาปรือ, สถานะอื่นไม่มี
  // =========================================================================
  group('§4 สถานะต่ำ เหงื่อ/ตาปรือ', () {
    for (final e in docPresets.entries) {
      final low = docLowStates.contains(e.key);
      testWidgets('LOW_${e.key}_sweat_${low}_droopy_$low', (tester) async {
        await tester.pumpWidget(
            host(PetCharacter(pose: e.value.$1, animate: false)));
        final p = painterOf(tester);
        expect(p.showsSweat, low);
        expect(p.hasDroopyEyes, low);
      });
    }

    test('LOW_sparkles_only_on_happy_and_proud_faces', () {
      // §4: happy / proud มีประกาย 2 ดวง, cheer มีประกาย 5 ดวง
      for (final e in docPresets.entries) {
        final p = PetCharacterPainter(pose: e.value.$1);
        final face = e.value.$4;
        expect(p.showsSparkles, face == PetFace.happy || face == PetFace.proud,
            reason: e.key);
      }
      expect(
          const PetCharacterPainter(
                  pose: PetPose.waterCritical, action: PetAction.cheer)
              .showsSparkles,
          isTrue);
    });

    test('LOW_blink_keeps_mood_but_closes_eyes', () {
      // §4 blink: ตาปิด, ปาก/ใบไม้/แก้มคงตามสีหน้าเดิม
      const p = PetCharacterPainter(pose: PetPose.waterTired, blink: 1);
      expect(p.face, PetFace.blink);
      expect(p.isBlinking, isTrue);
      expect(p.hasDroopyEyes, isFalse, reason: 'ตาปิดทั้งหมดขณะกะพริบ');
      expect(p.showsSweat, isTrue, reason: 'เหงื่อยังอยู่ตามสีหน้า tired');
    });

    test('LOW_action_faces_override_expression', () {
      // §4: funny (แตะตัว), cheer (เพิ่มน้ำ/ก้าว)
      const jump =
          PetCharacterPainter(pose: PetPose.waterCritical, action: PetAction.jump);
      expect(jump.face, PetFace.funny);
      expect(jump.isJumping, isTrue);
      expect(jump.hasDroopyEyes, isFalse);
      const cheer =
          PetCharacterPainter(pose: PetPose.stepsFat, action: PetAction.cheer);
      expect(cheer.face, PetFace.cheer);
      expect(cheer.isCheering, isTrue);
    });
  });

  // =========================================================================
  // §3 รูปร่าง
  // =========================================================================
  group('§3 รูปร่าง', () {
    test('BODY_dimensions_match_character_md_table', () {
      for (final e in docBodySize.entries) {
        final spec = PetCharacterPainter(
                pose: PetPose(expression: PetExpression.happy, body: e.key))
            .bodySpec;
        expect(spec.width, closeTo(e.value.$1, 1e-9), reason: e.key.name);
        expect(spec.height, closeTo(e.value.$2, 1e-9), reason: e.key.name);
      }
    });

    test('BODY_all_5_shapes_have_different_size', () {
      final sizes = docBodySize.keys
          .map((b) => PetCharacterPainter(
                  pose: PetPose(expression: PetExpression.happy, body: b))
              .bodySpec)
          .map((s) => (s.width, s.height))
          .toSet();
      expect(sizes.length, 5);
    });

    test('BODY_fat_is_widest_and_flattest_lean_is_narrowest', () {
      final specs = {
        for (final b in PetBodyShape.values)
          b: PetCharacterPainter(
                  pose: PetPose(expression: PetExpression.happy, body: b))
              .bodySpec
      };
      for (final b in PetBodyShape.values.where((b) => b != PetBodyShape.fat)) {
        expect(specs[PetBodyShape.fat]!.width, greaterThan(specs[b]!.width),
            reason: 'FAT กว้างกว่า ${b.name}');
        expect(specs[PetBodyShape.fat]!.height, lessThan(specs[b]!.height),
            reason: 'FAT เตี้ยแบนกว่า ${b.name}');
      }
      for (final b in PetBodyShape.values.where((b) => b != PetBodyShape.lean)) {
        expect(specs[PetBodyShape.lean]!.width, lessThan(specs[b]!.width),
            reason: 'LEAN ผอมกว่า ${b.name}');
      }
      // CHUBBY "กลมเกือบเป็นวงกลม" และสูงที่สุด (0.64)
      for (final b
          in PetBodyShape.values.where((b) => b != PetBodyShape.chubby)) {
        expect(specs[PetBodyShape.chubby]!.height,
            greaterThan(specs[b]!.height));
      }
    });

    test('BODY_fat_hides_thighs_and_has_belly_roll', () {
      // §3 FAT: พุง 0.68 × 0.36 + เส้นพุงพับ, ต้นขาหลัง "ซ่อน"
      final fat = PetCharacterPainter(pose: PetPose.stepsFat).bodySpec;
      expect(fat.bellyRoll, isTrue);
      expect(fat.thighWidth, 0);
      expect(fat.thighHeight, 0);
      expect(fat.bellyWidth, closeTo(0.68, 1e-9));
      expect(fat.bellyHeight, closeTo(0.36, 1e-9));
      for (final p in [
        PetPose.waterHappy,
        PetPose.stepsChubby,
        PetPose.stepsLean,
        PetPose.stepsMuscle
      ]) {
        expect(PetCharacterPainter(pose: p).bodySpec.bellyRoll, isFalse,
            reason: p.id);
      }
    });

    test('BODY_muscle_has_big_muscle_thighs_others_not', () {
      // §3 MUSCLE: ต้นขาหลัง 0.25 × 0.27 อยู่หน้าตัว + เงาเสี้ยว/เส้นกล้าม
      final m = PetCharacterPainter(pose: PetPose.stepsMuscle).bodySpec;
      expect(m.muscle, isTrue);
      expect(m.thighWidth, closeTo(0.25, 1e-9));
      expect(m.thighHeight, closeTo(0.27, 1e-9));
      for (final b
          in PetBodyShape.values.where((b) => b != PetBodyShape.muscle)) {
        final s = PetCharacterPainter(
                pose: PetPose(expression: PetExpression.happy, body: b))
            .bodySpec;
        expect(s.muscle, isFalse, reason: b.name);
        expect(s.thighWidth, lessThan(m.thighWidth),
            reason: 'ต้นขา MUSCLE ใหญ่สุด (เทียบ ${b.name})');
        expect(s.thighHeight, lessThan(m.thighHeight));
      }
    });

    test('BODY_lean_has_long_thin_thighs', () {
      // §3 LEAN: ต้นขาหลัง 0.12 × 0.22 (เรียวยาว)
      final l = PetCharacterPainter(pose: PetPose.stepsLean).bodySpec;
      expect(l.thighWidth, closeTo(0.12, 1e-9));
      expect(l.thighHeight, closeTo(0.22, 1e-9));
      expect(l.thighHeight, greaterThan(l.thighWidth));
    });
  });

  // =========================================================================
  // §6 / §7 animate: false
  // =========================================================================
  group('animate: false (ภาพนิ่ง)', () {
    testWidgets('STATIC_no_tickers_no_timers_pumpAndSettle_completes',
        (tester) async {
      await tester.pumpWidget(
          host(const PetCharacter(pose: PetPose.waterHappy, animate: false)));
      expect(tester.binding.transientCallbackCount, 0,
          reason: 'ไม่มี AnimationController ทำงาน');
      expect(tester.hasRunningAnimations, isFalse);
      final frames = await tester.pumpAndSettle();
      expect(frames, 1, reason: 'settle ทันทีไม่มีเฟรมค้าง');
      // เดินเวลาไปไกลกว่าช่วงกะพริบสูงสุด (5000 ms + 180) → ต้องไม่กะพริบ (ไม่มี Timer)
      await tester.pump(const Duration(seconds: 10));
      final p = painterOf(tester);
      expect(p.animated, isFalse);
      expect(p.breath, 0);
      expect(p.blink, 0);
      expect(p.action, PetAction.none);
    });

    testWidgets('STATIC_tap_calls_onTap_but_no_jump', (tester) async {
      var taps = 0;
      await tester.pumpWidget(host(PetCharacter(
          pose: PetPose.stepsChubby, animate: false, onTap: () => taps++)));
      await tester.tap(find.byKey(PetKeys.character));
      await tester.pumpAndSettle();
      expect(taps, 1, reason: '§7 onTap ถูกเรียกเสมอ แม้ animate: false');
      final p = painterOf(tester);
      expect(p.isJumping, isFalse);
      expect(p.face, PetFace.content);
    });

    testWidgets('STATIC_cheerTrigger_change_does_not_animate', (tester) async {
      final key = GlobalKey<CheerHostState>();
      await tester.pumpWidget(
          CheerHost(key: key, pose: PetPose.waterTired, animate: false));
      key.currentState!.cheer();
      await tester.pumpAndSettle();
      final p = painterOf(tester);
      expect(p.isCheering, isFalse);
      expect(p.face, PetFace.tired);
      expect(tester.binding.transientCallbackCount, 0);
    });
  });

  // =========================================================================
  // §6 / §7 animate: true — ใช้ pump(Duration) เท่านั้น
  // =========================================================================
  group('animate: true', () {
    testWidgets('ANIM_breathes_and_painter_animated_true', (tester) async {
      await tester.pumpWidget(host(
          PetCharacter(pose: PetPose.waterHappy, random: Random(7))));
      expect(painterOf(tester).animated, isTrue);
      expect(tester.hasRunningAnimations, isTrue, reason: 'หายใจตลอด');
      await tester.pump(const Duration(milliseconds: 600));
      expect(painterOf(tester).breath, greaterThan(0),
          reason: 'ผ่านไป 600 ms ของรอบหายใจ 2400 ms ต้องยืดตัวแล้ว');
    });

    testWidgets('ANIM_tap_jump_funny_then_none_after_650ms', (tester) async {
      var taps = 0;
      await tester.pumpWidget(host(PetCharacter(
          pose: PetPose.waterCritical,
          random: Random(3),
          onTap: () => taps++)));
      await tester.tap(find.byKey(PetKeys.character));
      await tester.pump(); // เฟรมแรกของการกระโดด
      await tester.pump(const Duration(milliseconds: 200));
      var p = painterOf(tester);
      expect(taps, 1);
      expect(p.isJumping, isTrue, reason: '§7 แตะแล้ว pump(200ms) → isJumping');
      expect(p.face, PetFace.funny);
      // ยังอยู่ในช่วง 650 ms
      await tester.pump(const Duration(milliseconds: 400)); // 600 ms
      expect(painterOf(tester).isJumping, isTrue, reason: '600 ms < 650 ms');
      await tester.pump(const Duration(milliseconds: 60)); // 660 ms
      p = painterOf(tester);
      expect(p.action, PetAction.none, reason: 'เกิน 650 ms → none');
      expect(p.face, PetFace.critical, reason: 'กลับสีหน้าเดิม');
    });

    testWidgets('ANIM_reactToTap_false_no_jump_but_onTap_called',
        (tester) async {
      var taps = 0;
      await tester.pumpWidget(host(PetCharacter(
          pose: PetPose.waterHappy,
          random: Random(3),
          reactToTap: false,
          onTap: () => taps++)));
      await tester.tap(find.byKey(PetKeys.character));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(taps, 1);
      expect(painterOf(tester).isJumping, isFalse);
    });

    testWidgets('ANIM_cheerTrigger_change_cheers_then_ends_after_900ms',
        (tester) async {
      final key = GlobalKey<CheerHostState>();
      await tester.pumpWidget(CheerHost(key: key, pose: PetPose.stepsFat));
      expect(painterOf(tester).isCheering, isFalse,
          reason: 'ค่าเริ่มต้นไม่ใช่การเปลี่ยนค่า → ไม่ cheer');
      key.currentState!.cheer();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      var p = painterOf(tester);
      expect(p.isCheering, isTrue, reason: '§7 cheerTrigger เปลี่ยน + 100ms');
      expect(p.face, PetFace.cheer);
      expect(p.showsSparkles, isTrue, reason: '§4 cheer มีประกาย');
      await tester.pump(const Duration(milliseconds: 750)); // 850 ms
      expect(painterOf(tester).isCheering, isTrue, reason: '850 < 900 ms');
      await tester.pump(const Duration(milliseconds: 60)); // 910 ms
      p = painterOf(tester);
      expect(p.action, PetAction.none);
      expect(p.face, PetFace.tired);
    });

    testWidgets('ANIM_cheerTrigger_decrease_also_cheers', (tester) async {
      // §7: เล่น cheer ทุกครั้งที่ค่า "เปลี่ยน" (ไม่ใช่แค่เพิ่ม)
      Widget pet(int t) => host(PetCharacter(
          pose: PetPose.waterHappy, random: Random(1), cheerTrigger: t));
      await tester.pumpWidget(pet(5));
      await tester.pumpWidget(pet(4));
      await tester.pump(const Duration(milliseconds: 100));
      expect(painterOf(tester).isCheering, isTrue);
      await tester.pump(const Duration(milliseconds: 900));
      expect(painterOf(tester).isCheering, isFalse);
    });

    testWidgets('ANIM_same_cheerTrigger_on_rebuild_does_not_cheer',
        (tester) async {
      Widget pet(PetPose pose) => host(PetCharacter(
          pose: pose, random: Random(1), cheerTrigger: 3));
      await tester.pumpWidget(pet(PetPose.waterTired));
      await tester.pumpWidget(pet(PetPose.waterHappy)); // rebuild, ค่าเดิม
      await tester.pump(const Duration(milliseconds: 100));
      final p = painterOf(tester);
      expect(p.isCheering, isFalse);
      expect(p.pose, PetPose.waterHappy, reason: 'เปลี่ยนท่าทันที');
    });

    testWidgets('ANIM_tap_during_cheer_does_not_interrupt', (tester) async {
      // §6 ระหว่าง cheer แตะตัวจะไม่ขัดจังหวะ
      final key = GlobalKey<CheerHostState>();
      await tester.pumpWidget(CheerHost(key: key, pose: PetPose.waterHappy));
      key.currentState!.cheer();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.byKey(PetKeys.character));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final p = painterOf(tester);
      expect(p.isCheering, isTrue);
      expect(p.isJumping, isFalse);
    });

    testWidgets('ANIM_toggle_animate_true_to_false_stops_tickers',
        (tester) async {
      Widget pet(bool a) => host(PetCharacter(
          pose: PetPose.waterHappy, animate: a, random: Random(1)));
      await tester.pumpWidget(pet(true));
      expect(tester.hasRunningAnimations, isTrue);
      await tester.pumpWidget(pet(false));
      expect(tester.binding.transientCallbackCount, 0);
      await tester.pumpAndSettle();
      expect(painterOf(tester).animated, isFalse);
    });
  });

  // =========================================================================
  // §6 กะพริบตาสุ่มด้วย Random(seed)
  // =========================================================================
  group('กะพริบตา (Random seed)', () {
    /// เดินเวลาครั้งละ 20 ms เป็นเวลา totalMs เก็บเวลา (ms) ที่เห็นตาปิด (isBlinking)
    Future<List<int>> blinkFrames(WidgetTester tester, int seed,
        {int totalMs = 12000}) async {
      await tester.pumpWidget(host(PetCharacter(
          key: ValueKey('seed_$seed'),
          pose: PetPose.stepsChubby,
          random: Random(seed))));
      final seen = <int>[];
      for (var t = 20; t <= totalMs; t += 20) {
        await tester.pump(const Duration(milliseconds: 20));
        if (painterOf(tester).isBlinking) seen.add(t);
      }
      await tester.pumpWidget(const SizedBox());
      return seen;
    }

    testWidgets('BLINK_same_seed_same_blink_timeline', (tester) async {
      final a = await blinkFrames(tester, 42);
      final b = await blinkFrames(tester, 42);
      expect(a, isNotEmpty, reason: 'ใน 12 s ต้องกะพริบอย่างน้อย 1 ครั้ง');
      expect(b, a, reason: 'seed เดียวกัน → จังหวะกะพริบเหมือนกัน');
    });

    testWidgets('BLINK_first_blink_within_doc_gap_and_short', (tester) async {
      for (final seed in [1, 42, 2026]) {
        final frames = await blinkFrames(tester, seed, totalMs: 6000);
        expect(frames, isNotEmpty, reason: 'seed $seed: ต้องกะพริบภายใน 5000+180 ms');
        // ครั้งแรกเกิดหลังช่องว่างขั้นต่ำ 1800 ms และไม่ช้ากว่า 1800+3200 (+เวลาตาปิด)
        expect(frames.first, greaterThanOrEqualTo(docBlinkGapMinMs),
            reason: 'seed $seed');
        expect(frames.first,
            lessThanOrEqualTo(docBlinkGapMinMs + docBlinkGapRangeMs + docBlinkMs),
            reason: 'seed $seed');
        // ตาปิดสนิท (>= 0.5) อยู่ไม่เกินเวลากะพริบ 180 ms
        final firstRun =
            frames.takeWhile((t) => t - frames.first < docBlinkMs + 20).toList();
        expect(firstRun.last - firstRun.first, lessThan(docBlinkMs),
            reason: 'seed $seed');
        // และต้องลืมตาก่อนครั้งถัดไป (ห่างอย่างน้อย 1800 ms)
        final next = frames.skip(firstRun.length);
        if (next.isNotEmpty) {
          expect(next.first - firstRun.last,
              greaterThanOrEqualTo(docBlinkGapMinMs - docBlinkMs));
        }
      }
    });
  });

  // =========================================================================
  // dispose
  // =========================================================================
  group('dispose', () {
    testWidgets('DISPOSE_animated_pet_leaves_no_tickers_or_timers',
        (tester) async {
      // ถ้า Timer กะพริบตายังค้างหลัง dispose → flutter_test fail
      // "A Timer is still pending even after the widget tree was disposed"
      await tester.pumpWidget(host(
          PetCharacter(pose: PetPose.waterCritical, random: Random(9))));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byKey(PetKeys.character)); // กำลังกระโดดอยู่ตอน dispose
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpWidget(const SizedBox());
      expect(find.byKey(PetKeys.character), findsNothing);
      expect(tester.binding.transientCallbackCount, 0);
      expect(tester.hasRunningAnimations, isFalse);
      // เดินเวลาเกินช่วงกะพริบสูงสุด — ไม่มี callback ค้างมา throw
      await tester.pump(const Duration(seconds: 6));
      expect(tester.takeException(), isNull);
    });

    testWidgets('DISPOSE_while_cheering_no_exception', (tester) async {
      final key = GlobalKey<CheerHostState>();
      await tester.pumpWidget(CheerHost(key: key, pose: PetPose.stepsMuscle));
      key.currentState!.cheer();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
      expect(tester.binding.transientCallbackCount, 0);
    });
  });
}
