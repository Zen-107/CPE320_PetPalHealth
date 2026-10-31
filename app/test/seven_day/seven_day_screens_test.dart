// Widget tests: S-1 หน้าประวัติสุขภาพ 7 วัน + ทางเข้าจากหน้า water
// ข้อความบนจอคัดลอกตรงตัวจาก docs/7day/ux-flow.md §2 / game-rules.md §1.1 (ไม่รวม `"` ตัวคั่น)
// ValueKey / โครง / ขนาด / เวลา จาก docs/7day/ui-spec.md · ข้อความ "(เสนอ — รอยืนยัน)" ของ ui-spec
// ใช้ตามข้อตัดสิน owner รอบ 2 (Q-2..Q-20) ชื่อเทสต์ขึ้นต้น DECIDED_
// เวลา: clock ร่วมของ 3 controller + tester.pump(Duration) — ไม่ใช้เวลาจริง ห้าม pumpAndSettle บน S-1
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/seven_day/screens/seven_day_history_screen.dart';
import 'package:petpal_health/main.dart';
import 'package:petpal_health/shared/pet/pet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'seven_day_test_helpers.dart';

Finder k(String key) => find.byKey(Key(key));
String textOf(WidgetTester tester, Finder f) => tester.widget<Text>(f).data!;

void set360(WidgetTester tester, {double textScale = 1.0}) {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
}

bool expanded(int i) => k('seven_day_day_body_$i').evaluate().isNotEmpty;

/// นับการสร้าง HttpClient (EC-5 / D-2: ต้องไม่มี network)
class _CountingHttpOverrides extends HttpOverrides {
  int created = 0;
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    created++;
    return super.createHttpClient(context);
  }
}

void main() {
  late DateTime now;

  setUp(() => now = t(today, 10));

  Widget app(Sources s) => MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue)),
        home: SevenDayHistoryScreen(
          waterController: s.water,
          stepsController: s.steps,
          foodController: s.food,
        ),
      );

  /// เปิด S-1 ตรง ๆ (controller ยังไม่โหลด — S-1 โหลดเอง)
  Future<Sources> pumpS1(WidgetTester tester, Map<int, DayData> data,
      {int base = today}) async {
    final s = sourcesFor(data, clock: () => now, base: base);
    await tester.pumpWidget(app(s));
    for (var i = 0; i < 3; i++) {
      await tester.pump();
    }
    return s;
  }

  /// แตะหัวการ์ด i แล้วรอ Accordion 250 ms จบ
  Future<void> toggle(WidgetTester tester, int i) async {
    await tester.ensureVisible(k('seven_day_day_title_$i'));
    await tester.pump();
    await tester.tap(k('seven_day_day_title_$i'));
    await tester.pump();
    await tester.pump(docAccordion);
    // body ถูกถอดออกจาก tree ในเฟรมถัดไปหลัง animation จบ (maintainState: false) — ต้องมีเวลาเดิน
    await tester.pump(const Duration(milliseconds: 16));
  }

  /// เปิดหน้า water (หน้าแรก) → กด seven_day_entry_button
  Future<Sources> pumpViaWater(WidgetTester tester, Map<int, DayData> data) async {
    final s = sourcesFor(data, clock: () => now);
    await tester.pumpWidget(PetPalApp(
        waterController: s.water,
        stepsController: s.steps,
        foodController: s.food));
    await tester.pumpAndSettle(); // หน้า water ยังไม่มีลูปไม่สิ้นสุด
    await tester.tap(k('seven_day_entry_button'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900)); // transition ของ route
    return s;
  }

  // =========================================================================
  // AC-1 7 การ์ด Day 0 บนสุด ขยาย / Day −1..−6 พับ
  // =========================================================================
  group('AC-1 การ์ดรายวัน', () {
    testWidgets('AC1_seven_cards_day0_top_expanded_others_collapsed',
        (tester) async {
      await pumpS1(tester, {0: const DayData(cups: 2), 3: const DayData(steps: 3000)});
      double top(int i) => tester.getTopLeft(k('seven_day_day_card_$i')).dy;
      for (var i = 0; i < 7; i++) {
        expect(k('seven_day_day_card_$i'), findsOneWidget, reason: 'card $i');
        if (i > 0) expect(top(i), greaterThan(top(i - 1)), reason: 'ลำดับ $i');
      }
      expect(k('seven_day_day_card_7'), findsNothing);
      expect(expanded(0), isTrue, reason: 'Day 0 expanded = true');
      expect(k('seven_day_day_summary_0'), findsNothing);
      for (var i = 1; i < 7; i++) {
        expect(expanded(i), isFalse, reason: 'Day -$i expanded = false');
        expect(k('seven_day_day_summary_$i'), findsOneWidget);
      }
      for (var i = 0; i < 7; i++) {
        expect(tester.widget<ExpansionTile>(k('seven_day_day_tile_$i')).initiallyExpanded,
            i == 0);
      }
      // การ์ดสรุปอยู่เหนือการ์ดรายวัน
      expect(tester.getBottomLeft(k('seven_day_summary_card')).dy,
          lessThan(top(0)));
    });

    testWidgets('AC1_titles_today_yesterday_weekday_date', (tester) async {
      await pumpS1(tester, {});
      for (var i = 0; i < 7; i++) {
        expect(textOf(tester, k('seven_day_day_title_$i')), titleFor(i, dayOff(i)));
      }
      expect(textOf(tester, k('seven_day_day_title_0')), 'วันนี้, 31/10/2026');
      expect(textOf(tester, k('seven_day_day_title_1')), 'เมื่อวาน, 30/10/2026');
      expect(textOf(tester, k('seven_day_day_title_6')), 'วันอาทิตย์, 25/10/2026');
      expect(textOf(tester, k('seven_day_header_text')), screenTitle);
    });

    testWidgets('AC1_day0_body_lines_order_and_tags_order', (tester) async {
      await pumpS1(tester, {
        0: const DayData(
            cups: 6,
            steps: 5500,
            kcal: docFoodTarget + docOverLimitKcal + 1,
            sodium: true,
            sugar: true),
      });
      expect(textOf(tester, k('seven_day_day_steps_0')), dayStepsLine(5500));
      expect(textOf(tester, k('seven_day_day_water_0')), dayWaterLine(6));
      expect(textOf(tester, k('seven_day_day_food_0')), dayFoodLine(2101));
      expect(textOf(tester, k('seven_day_day_food_0')), 'แคลอรี: 2,101 kcal');
      double y(String key) => tester.getTopLeft(k(key)).dy;
      expect(y('seven_day_day_steps_0'), lessThan(y('seven_day_day_water_0')));
      expect(y('seven_day_day_water_0'), lessThan(y('seven_day_day_food_0')));
      expect(y('seven_day_day_food_0'), lessThan(y('seven_day_day_tags_0')));
      for (final (key, txt) in [
        ('seven_day_tag_high_sodium_0', tagSodium),
        ('seven_day_tag_high_sugar_0', tagSugar),
        ('seven_day_tag_overeating_0', tagOver),
      ]) {
        expect(find.descendant(of: k(key), matching: find.text(txt)), findsOneWidget,
            reason: key);
      }
      double x(String key) => tester.getTopLeft(k(key)).dx;
      expect(x('seven_day_tag_high_sodium_0'), lessThan(x('seven_day_tag_high_sugar_0')));
      expect(x('seven_day_tag_high_sugar_0'), lessThan(x('seven_day_tag_overeating_0')));
    });

    testWidgets('UI_no_tags_no_wrap_and_overeating_threshold_2100', (tester) async {
      await pumpS1(tester, {0: const DayData(kcal: docFoodTarget + docOverLimitKcal)});
      expect(k('seven_day_day_tags_0'), findsNothing, reason: '2,100 ไม่เกิน +100');
      expect(find.text(tagOver), findsNothing);
    });

    testWidgets('UI_collapsed_summary_and_expanded_past_day_from_history',
        (tester) async {
      await pumpS1(tester, {
        1: const DayData(cups: 5, steps: 5500, kcal: 1250, sodium: true, over: true),
      });
      expect(textOf(tester, k('seven_day_day_summary_1')),
          '5,500 ก้าว · 5 แก้ว · 1,250 kcal');
      expect(find.descendant(of: k('seven_day_day_card_1'), matching: find.text(tagSodium)),
          findsNothing, reason: 'Q-14 ไม่แสดงป้ายตอนพับ');
      await toggle(tester, 1);
      expect(expanded(1), isTrue);
      expect(k('seven_day_day_summary_1'), findsNothing, reason: 'ขยายแล้วไม่มี subtitle');
      expect(textOf(tester, k('seven_day_day_steps_1')), dayStepsLine(5500));
      expect(textOf(tester, k('seven_day_day_water_1')), dayWaterLine(5));
      expect(textOf(tester, k('seven_day_day_food_1')), dayFoodLine(1250));
      expect(k('seven_day_tag_high_sodium_1'), findsOneWidget);
      expect(k('seven_day_tag_high_sugar_1'), findsNothing);
      expect(k('seven_day_tag_overeating_1'), findsOneWidget, reason: 'Q-20 isOverTarget');
    });
  });

  // =========================================================================
  // OQ-01 Accordion 250 ms / พับ-ขยายอิสระ (Q-15)
  // =========================================================================
  group('DECIDED_OQ01 Accordion 250ms', () {
    testWidgets('DECIDED_OQ01_animation_style_250ms_all_cards', (tester) async {
      await pumpS1(tester, {});
      for (var i = 0; i < 7; i++) {
        expect(
            tester
                .widget<ExpansionTile>(k('seven_day_day_tile_$i'))
                .expansionAnimationStyle
                ?.duration,
            docAccordion,
            reason: 'tile $i');
      }
    });

    testWidgets('DECIDED_OQ01_expand_animates_over_250ms_not_instant',
        (tester) async {
      await pumpS1(tester, {1: const DayData(cups: 4, steps: 4000, kcal: 900)});
      final card = k('seven_day_day_card_1');
      final h0 = tester.getSize(card).height;
      await tester.ensureVisible(k('seven_day_day_title_1'));
      await tester.pump();
      await tester.tap(k('seven_day_day_title_1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 125));
      final hMid = tester.getSize(card).height;
      expect(expanded(1), isTrue, reason: 'body อยู่ใน tree ระหว่าง animation');
      await tester.pump(const Duration(milliseconds: 125));
      await tester.pump();
      final hEnd = tester.getSize(card).height;
      await tester.pump(const Duration(milliseconds: 200));
      final hAfter = tester.getSize(card).height;
      expect(hMid, greaterThan(h0), reason: 'ไม่ใช่ค่าเดิมกลาง animation');
      expect(hMid, lessThan(hEnd), reason: 'ไม่ใช่ Instant Toggle');
      expect(hAfter, hEnd, reason: 'จบภายใน 250 ms');
      expect(tester.takeException(), isNull);
    });

    testWidgets('DECIDED_OQ01_collapse_day0_after_250ms_body_gone',
        (tester) async {
      await pumpS1(tester, {0: const DayData(cups: 3)});
      expect(expanded(0), isTrue);
      final card = k('seven_day_day_card_0');
      final hOpen = tester.getSize(card).height;
      await tester.tap(k('seven_day_day_title_0'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 125));
      final hMid = tester.getSize(card).height;
      expect(expanded(0), isTrue, reason: 'ยังพับไม่เสร็จที่ 125 ms');
      await tester.pump(const Duration(milliseconds: 125));
      final h250 = tester.getSize(card).height;
      await tester.pump(const Duration(milliseconds: 16));
      expect(expanded(0), isFalse, reason: 'พับเสร็จแล้ว body ออกจาก tree');
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.getSize(card).height, h250, reason: 'ความสูงสุดท้ายถึงที่ 250 ms');
      expect(hMid, lessThan(hOpen));
      expect(hMid, greaterThan(h250), reason: 'ไม่ใช่ Instant Toggle');
      expect(textOf(tester, k('seven_day_day_summary_0')), collapsedLine(0, 3, 0));
    });

    testWidgets('DECIDED_Q15_cards_toggle_independently', (tester) async {
      await pumpS1(tester, {});
      await toggle(tester, 1);
      await toggle(tester, 3);
      await toggle(tester, 6);
      expect([for (var i = 0; i < 7; i++) expanded(i)],
          [true, true, false, true, false, false, true]);
      await toggle(tester, 3);
      expect([for (var i = 0; i < 7; i++) expanded(i)],
          [true, true, false, false, false, false, true]);
    });
  });

  // =========================================================================
  // AC-2 / EC-2 วันไม่มีข้อมูล + game-rules §3
  // =========================================================================
  group('AC-2 / EC-2 / GR3 วันไม่มีข้อมูล', () {
    testWidgets('AC2_GR3_no_data_cards_and_averages_divide_by_recorded_days',
        (tester) async {
      // น้ำ 7 / 8 / 9 (3 วัน) · ก้าว 5,000 / 6,000 (2 วัน) · วัน −1, −3, −5, −6 ไม่มีบันทึก
      await pumpS1(tester, {
        0: const DayData(cups: 7, steps: 5000),
        2: const DayData(cups: 8, steps: 6000),
        4: const DayData(cups: 9, stepsRecordZero: true),
      });
      expect(textOf(tester, k('seven_day_avg_water_text')), avgWaterLine('8.0'));
      expect(textOf(tester, k('seven_day_avg_steps_text')), avgStepsLine('5,500.0'));
      expect(textOf(tester, k('seven_day_avg_food_text')), avgFoodLine(null));
      expect(k('seven_day_coaching_water_text'), findsNothing, reason: '8.0 ไม่ < 8.0');
      expect(textOf(tester, k('seven_day_coaching_steps_text')), lowStepsText('5,500.0'));
      expect(textOf(tester, k('seven_day_coaching_prefix_text')), prefixText,
          reason: 'count = 3 < 7');
      for (final i in [1, 3, 5, 6]) {
        expect(textOf(tester, k('seven_day_day_summary_$i')), noDataText, reason: 'Day -$i');
      }
      expect(textOf(tester, k('seven_day_day_summary_2')), collapsedLine(6000, 8, 0));
      expect(textOf(tester, k('seven_day_day_summary_4')), collapsedLine(0, 9, 0));
    });

    testWidgets('AC2_expanded_no_data_day_shows_only_no_data_text',
        (tester) async {
      await pumpS1(tester, {0: const DayData(cups: 2)});
      await toggle(tester, 1);
      expect(textOf(tester, k('seven_day_day_no_data_1')), noDataText);
      for (final key in ['steps', 'water', 'food', 'tags']) {
        expect(k('seven_day_day_${key}_1'), findsNothing, reason: key);
      }
    });
  });

  // =========================================================================
  // AC-3..AC-5 ค่าเฉลี่ย + coaching ตรงตัว / ลำดับ / สถานะ
  // =========================================================================
  group('AC-3..AC-5 SUMMARY_CARD', () {
    testWidgets('AC3_AC4_AC5_exact_coaching_prefix_water_steps_separate_lines',
        (tester) async {
      await pumpS1(tester, {
        0: const DayData(cups: 6, steps: 7240, kcal: 1700),
        1: const DayData(cups: 7, steps: 7241, kcal: 2000),
      });
      expect(textOf(tester, k('seven_day_summary_title_text')), summaryTitle);
      expect(textOf(tester, k('seven_day_avg_water_text')), avgWaterLine('6.5'));
      expect(textOf(tester, k('seven_day_avg_steps_text')), avgStepsLine('7,240.5'));
      expect(textOf(tester, k('seven_day_avg_food_text')), avgFoodLine('1,850.0'));
      final prefix = k('seven_day_coaching_prefix_text');
      final water = k('seven_day_coaching_water_text');
      final steps = k('seven_day_coaching_steps_text');
      expect(textOf(tester, prefix), prefixText);
      expect(textOf(tester, water), lowWaterText('6.5'));
      expect(textOf(tester, steps), lowStepsText('7,240.5'));
      expect(textOf(tester, water),
          'ดื่มน้ำเฉลี่ยวันละ 6.5 แก้ว น้อยไปน้า พยายามกินน้ำมากกว่านี้ แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ');
      expect(textOf(tester, steps),
          'เดินเฉลี่ยวันละ 7,240.5 ก้าว ขยับอีกนิดน้าเพื่อสุขภาพที่แข็งแรง แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ');
      // คนละบรรทัด เรียง prefix → น้ำ → ก้าว อยู่ใน SUMMARY_CARD
      final rp = tester.getRect(prefix);
      final rw = tester.getRect(water);
      final rs = tester.getRect(steps);
      expect(rp.bottom, lessThanOrEqualTo(rw.top));
      expect(rw.bottom, lessThanOrEqualTo(rs.top));
      final card = tester.getRect(k('seven_day_summary_card'));
      for (final r in [rp, rw, rs]) {
        expect(card.contains(r.topLeft) && card.contains(r.bottomRight - const Offset(0.01, 0.01)),
            isTrue, reason: '$r ใน $card');
      }
      expect(rp.top, greaterThan(tester.getRect(k('seven_day_avg_food_text')).bottom - 0.01),
          reason: 'coaching อยู่ใต้ค่าเฉลี่ย');
    });

    testWidgets('AC3_NORMAL_count_7_no_prefix_no_coaching', (tester) async {
      await pumpS1(tester, allDays(const DayData(cups: 8, steps: 8000, kcal: 1800)));
      expect(k('seven_day_summary_card'), findsOneWidget);
      expect(k('seven_day_coaching_prefix_text'), findsNothing);
      expect(k('seven_day_coaching_water_text'), findsNothing);
      expect(k('seven_day_coaching_steps_text'), findsNothing);
      expect(find.text(prefixText), findsNothing);
      expect(k('seven_day_empty_state'), findsNothing);
      expect(textOf(tester, k('seven_day_avg_water_text')), avgWaterLine('8.0'));
      expect(textOf(tester, k('seven_day_avg_steps_text')), avgStepsLine('8,000.0'));
    });

    testWidgets('AC3_INCONSISTENT_count_6_prefix_only', (tester) async {
      await pumpS1(tester, {
        for (var i = 0; i < 6; i++) i: const DayData(cups: 8, steps: 8000),
      });
      expect(textOf(tester, k('seven_day_coaching_prefix_text')), prefixText);
      expect(k('seven_day_coaching_water_text'), findsNothing);
      expect(k('seven_day_coaching_steps_text'), findsNothing);
      expect(textOf(tester, k('seven_day_day_summary_6')), noDataText);
    });

    testWidgets('AC4_EDGE_NORMAL_55_cups_7_9_warns_56_cups_8_0_not',
        (tester) async {
      await pumpS1(tester, {
        for (var i = 0; i < 7; i++) i: DayData(cups: i == 0 ? 7 : 8, steps: 8000),
      });
      expect(textOf(tester, k('seven_day_avg_water_text')), avgWaterLine('7.9'));
      expect(textOf(tester, k('seven_day_coaching_water_text')), lowWaterText('7.9'));
      expect(k('seven_day_coaching_prefix_text'), findsNothing, reason: 'count = 7');
      expect(k('seven_day_coaching_steps_text'), findsNothing);
    });

    testWidgets('AC5_EDGE_NORMAL_55999_steps_7999_9_warns', (tester) async {
      await pumpS1(tester, {
        for (var i = 0; i < 7; i++) i: DayData(cups: 8, steps: i == 0 ? 7999 : 8000),
      });
      expect(textOf(tester, k('seven_day_avg_steps_text')), avgStepsLine('7,999.9'));
      expect(textOf(tester, k('seven_day_coaching_steps_text')), lowStepsText('7,999.9'));
      expect(k('seven_day_coaching_water_text'), findsNothing);
    });
  });

  // =========================================================================
  // AC-6 / EC-3 EMPTY
  // =========================================================================
  group('AC-6 / EC-3 EMPTY', () {
    testWidgets('AC6_EC3_empty_state_text_once_summary_hidden_7_cards',
        (tester) async {
      await pumpS1(tester, {});
      expect(k('seven_day_empty_state'), findsOneWidget);
      expect(textOf(tester, k('seven_day_empty_text')), emptyText);
      expect(find.text(emptyText), findsOneWidget);
      expect(k('seven_day_summary_card'), findsNothing, reason: 'Q-3 ซ่อน SUMMARY');
      final icon = tester.widget<Icon>(k('seven_day_empty_icon'));
      expect(icon.icon, Icons.inbox_outlined);
      expect(icon.size, docEmptyIconSize);
      for (var i = 0; i < 7; i++) {
        expect(k('seven_day_day_card_$i'), findsOneWidget);
      }
      expect(expanded(0), isTrue);
      expect(textOf(tester, k('seven_day_day_no_data_0')), noDataText);
      for (var i = 1; i < 7; i++) {
        expect(textOf(tester, k('seven_day_day_summary_$i')), noDataText);
      }
      expect(find.byKey(PetKeys.character), findsNothing, reason: 'requirements §5 ไม่มีสัตว์เลี้ยง');
    });

    testWidgets('EDGE_EC5_corrupt_storage_shows_empty_no_crash', (tester) async {
      final s = makeSources(
        clock: () => now,
        waterRepo: BrokenWaterRepository(),
        stepsRepo: BrokenStepsRepository(),
        foodRepo: BrokenFoodRepository(),
      );
      await tester.pumpWidget(app(s));
      for (var i = 0; i < 3; i++) {
        await tester.pump();
      }
      expect(tester.takeException(), isNull);
      expect(textOf(tester, k('seven_day_empty_text')), emptyText);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('UI_loading_shows_only_progress_indicator', (tester) async {
      final pending = PendingWaterRepository();
      final s = makeSources(clock: () => now, waterRepo: pending);
      await tester.pumpWidget(app(s));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(k('seven_day_day_card_0'), findsNothing);
      expect(k('seven_day_summary_card'), findsNothing);
      expect(k('seven_day_empty_state'), findsNothing);
      pending.complete();
      await tester.pump();
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(k('seven_day_day_card_0'), findsOneWidget);
    });
  });

  // =========================================================================
  // EC-4 ข้าม 05:00 ขณะเปิดค้าง (D-4, Q-4)
  // =========================================================================
  group('EC-4 ข้าม 05:00', () {
    testWidgets('EC4_EDGE_04_59_59_to_05_00_00_new_day0_top_expanded_others_collapsed',
        (tester) async {
      now = t(31, 4, 59, 59); // รอบวัน 30 ต.ค.
      await pumpS1(tester, {
        0: const DayData(cups: 3, steps: 4000, kcal: 1200),
        2: const DayData(cups: 5),
      }, base: 30);
      expect(textOf(tester, k('seven_day_day_title_0')), 'วันนี้, 30/10/2026');
      expect(textOf(tester, k('seven_day_day_steps_0')), dayStepsLine(4000));
      await toggle(tester, 2); // ผู้ใช้กางการ์ด Day −2 ไว้
      expect(expanded(2), isTrue);

      await tester.pump(docDayCheck);
      await tester.pump();
      expect(textOf(tester, k('seven_day_day_title_0')), 'วันนี้, 30/10/2026',
          reason: 'ยัง 04:59:59');
      expect(k('seven_day_window_2026-10-30'), findsOneWidget);

      now = t(31, 5);
      await tester.pump(docDayCheck);
      await tester.pump();
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(k('seven_day_window_2026-10-31'), findsOneWidget);
      expect(k('seven_day_window_2026-10-30'), findsNothing);
      expect(textOf(tester, k('seven_day_day_title_0')), 'วันนี้, 31/10/2026');
      expect(expanded(0), isTrue, reason: 'Day 0 ใหม่ expanded อัตโนมัติ');
      expect(textOf(tester, k('seven_day_day_no_data_0')), noDataText);
      expect(tester.getTopLeft(k('seven_day_day_card_0')).dy,
          lessThan(tester.getTopLeft(k('seven_day_day_card_1')).dy));
      expect(textOf(tester, k('seven_day_day_title_1')), 'เมื่อวาน, 30/10/2026');
      expect(textOf(tester, k('seven_day_day_summary_1')), collapsedLine(4000, 3, 1200));
      for (var i = 1; i < 7; i++) {
        expect(expanded(i), isFalse, reason: 'Day -$i พับ (Q-4 กลับค่าเริ่มต้น)');
      }
      expect(textOf(tester, k('seven_day_day_title_3')), 'วันพุธ, 28/10/2026');
      expect(textOf(tester, k('seven_day_day_summary_3')), collapsedLine(0, 5, 0));
      expect(textOf(tester, k('seven_day_coaching_prefix_text')), prefixText);
      expect(find.byType(SnackBar), findsNothing);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('EC4_resume_after_05_00_refreshes', (tester) async {
      await pumpS1(tester, {0: const DayData(cups: 2)});
      expect(textOf(tester, k('seven_day_day_title_0')), 'วันนี้, 31/10/2026');
      now = DateTime(2026, 11, 1, 6);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      await tester.pump();
      expect(textOf(tester, k('seven_day_day_title_0')), 'วันนี้, 01/11/2026');
      expect(textOf(tester, k('seven_day_day_title_1')), 'เมื่อวาน, 31/10/2026');
      expect(textOf(tester, k('seven_day_day_summary_1')), collapsedLine(0, 2, 0));
    });
  });

  // =========================================================================
  // EC-5 / D-2 ไม่มี UI ออฟไลน์ / ไม่มี network · D-5 ไม่เก็บข้อมูลซ้ำ
  // =========================================================================
  group('EC-5 / D-2 ข้อมูลในเครื่องเท่านั้น', () {
    testWidgets('DECIDED_OQ02_EC5_no_offline_ui_no_http_client', (tester) async {
      final http = _CountingHttpOverrides();
      final old = HttpOverrides.current;
      HttpOverrides.global = http;
      addTearDown(() => HttpOverrides.global = old);
      await pumpS1(tester, {0: const DayData(cups: 4), 1: const DayData(steps: 3000)});
      await tester.pump(const Duration(seconds: 3));
      expect(http.created, 0, reason: 'ไม่มีการเรียก network');
      for (final w in ['ออฟไลน์', 'อินเทอร์เน็ต', 'เครือข่าย', 'Offline', 'offline']) {
        expect(find.textContaining(w), findsNothing, reason: w);
      }
      expect(find.byIcon(Icons.wifi_off), findsNothing);
      expect(find.byIcon(Icons.cloud_off), findsNothing);
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
      expect(find.byType(MaterialBanner), findsNothing);
      expect(textOf(tester, k('seven_day_day_summary_1')), collapsedLine(3000, 0, 0));
    });

    test('DECIDED_OQ02_D5_source_has_no_network_storage_or_pet', () {
      final dir = Directory('lib/features/seven_day');
      final files = dir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList();
      expect(files, isNotEmpty);
      for (final f in files) {
        // ตรวจเฉพาะโค้ด (ตัดบรรทัดคอมเมนต์ // และ /// ออก — คอมเมนต์อธิบายว่า "ไม่อ่าน shared_preferences")
        final src = f
            .readAsLinesSync()
            .where((l) => !l.trimLeft().startsWith('//'))
            .join('\n');
        for (final banned in [
          'dart:io',
          'package:http',
          'HttpClient',
          'connectivity',
          'shared_preferences',
          'SharedPreferences',
          'shared/pet',
          'PetCharacter',
        ]) {
          expect(src.contains(banned), isFalse, reason: '${f.path} มี $banned');
        }
      }
    });

    testWidgets('DECIDED_D5_no_new_shared_preferences_keys', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await pumpViaWater(tester, {0: const DayData(cups: 1)});
      await tester.pump(const Duration(seconds: 2));
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getKeys().where((x) => x.contains('seven') || x.contains('7day')),
          isEmpty);
    });
  });

  // =========================================================================
  // ทางเข้าจากหน้า water (DECIDED Q-1) + AppBar 5 ปุ่มที่ 360 dp
  // =========================================================================
  group('DECIDED_Q1 ทางเข้า / AppBar หน้า water', () {
    testWidgets('DECIDED_Q1_entry_button_icon_tooltip_position', (tester) async {
      final s = sourcesFor({}, clock: () => now);
      await tester.pumpWidget(PetPalApp(
          waterController: s.water,
          stepsController: s.steps,
          foodController: s.food));
      await tester.pumpAndSettle();
      final btn = k('seven_day_entry_button');
      expect(tester.widget(btn), isA<IconButton>());
      final ib = tester.widget<IconButton>(btn);
      expect(ib.tooltip, entryTooltip);
      expect((ib.icon as Icon).icon, Icons.history);
      expect(find.descendant(of: btn, matching: find.byType(Text)), findsNothing,
          reason: 'ไม่มีข้อความบนปุ่ม');
      double x(String key) => tester.getTopLeft(k(key)).dx;
      final order = [
        'steps_entry_button',
        'food_entry_button',
        'dashboard_entry_button',
        'seven_day_entry_button',
        'water_monthly_report_button',
      ];
      for (var i = 1; i < order.length; i++) {
        expect(x(order[i]), greaterThan(x(order[i - 1])), reason: order[i]);
      }
    });

    testWidgets('DECIDED_Q1_D5_tap_opens_S1_same_controllers_back_resets',
        (tester) async {
      final s = await pumpViaWater(tester, {0: const DayData(cups: 3, steps: 2500)});
      expect(textOf(tester, k('seven_day_header_text')), screenTitle);
      expect(find.byType(BackButton), findsOneWidget);
      expect(textOf(tester, k('seven_day_day_water_0')), dayWaterLine(3));
      expect(textOf(tester, k('seven_day_day_steps_0')), dayStepsLine(2500));
      // controller ตัวเดียวกับหน้า water — บันทึกน้ำแล้ว S-1 อัปเดตทันที
      now = t(31, 11);
      await s.water.logWater();
      await tester.pump();
      expect(textOf(tester, k('seven_day_day_water_0')), dayWaterLine(4));
      await toggle(tester, 1);
      expect(expanded(1), isTrue);
      await tester.tap(find.byType(BackButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));
      expect(k('seven_day_header_text'), findsNothing);
      await tester.tap(k('seven_day_entry_button'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));
      expect(expanded(0), isTrue);
      expect(expanded(1), isFalse, reason: 'เข้าหน้าใหม่ = ค่าเริ่มต้น');
    });

    for (final scale in [1.0, 1.5]) {
      testWidgets('DECIDED_Q1_water_appbar_5_buttons_360_scale_${scale}_no_overflow',
          (tester) async {
        set360(tester, textScale: scale);
        // เก็บ error เอง: body ของหน้า water ล้นแนวตั้งที่ 1.5 (ปัญหาเดิม — dashboard test-report §8)
        // เทสต์นี้ตรวจเฉพาะ AppBar
        final errors = <FlutterErrorDetails>[];
        final old = FlutterError.onError;
        FlutterError.onError = errors.add;
        final s = sourcesFor({}, clock: () => now);
        await tester.pumpWidget(PetPalApp(
            waterController: s.water,
            stepsController: s.steps,
            foodController: s.food));
        await tester.pumpAndSettle();
        FlutterError.onError = old;
        final appBarErrors = errors
            .where((e) =>
                e.toString().contains('AppBar') ||
                e.toString().contains('NavigationToolbar'))
            .map((e) => e.exceptionAsString())
            .toList();
        expect(appBarErrors, isEmpty, reason: '$appBarErrors');
        for (final key in [
          'steps_entry_button',
          'food_entry_button',
          'dashboard_entry_button',
          'seven_day_entry_button',
          'water_monthly_report_button',
        ]) {
          final r = tester.getRect(k(key));
          expect(r.left >= 0 && r.right <= 360, isTrue, reason: '$key $r');
        }
      });
    }
  });

  // =========================================================================
  // จอ 360×640 — textScaler 1.0 / 1.5
  // =========================================================================
  group('จอ 360×640', () {
    void expectNotClipped(WidgetTester tester, Finder f) {
      final p = tester.renderObject<RenderParagraph>(
          find.descendant(of: f, matching: find.byType(RichText)).first);
      expect(p.didExceedMaxLines, isFalse, reason: '$f ถูกตัดบรรทัด');
      final r = tester.getRect(f);
      expect(r.left >= -0.01 && r.right <= 360.01, isTrue, reason: '$f $r');
      final w = tester.widget(f);
      if (w is Text) {
        expect(w.maxLines, isNull, reason: '$f');
        expect(w.overflow, isNot(anyOf(TextOverflow.ellipsis, TextOverflow.fade)));
      }
    }

    for (final scale in [1.0, 1.5]) {
      testWidgets('UI_360_scale_${scale}_NORMAL_long_numbers_3_tags_all_expanded_no_overflow',
          (tester) async {
        set360(tester, textScale: scale);
        await pumpS1(
            tester,
            allDays(const DayData(
                cups: 99, steps: 123456, kcal: 12345, sodium: true, sugar: true, over: true)));
        expect(tester.takeException(), isNull);
        // ยืนยันว่า textScaler มีผลจริงในเทสต์
        expect(
            MediaQuery.textScalerOf(tester.element(k('seven_day_summary_card'))).scale(10),
            closeTo(10 * scale, 0.001));
        expect(textOf(tester, k('seven_day_day_summary_1')),
            '123,456 ก้าว · 99 แก้ว · 12,345 kcal');
        expectNotClipped(tester, k('seven_day_day_summary_1'));
        for (var i = 1; i < 7; i++) {
          await toggle(tester, i);
          expect(tester.takeException(), isNull, reason: 'ขยาย $i');
        }
        for (var i = 0; i < 7; i++) {
          expect(expanded(i), isTrue, reason: 'card $i');
          await tester.ensureVisible(k('seven_day_day_tags_$i'));
          await tester.pump();
          for (final tag in ['high_sodium', 'high_sugar', 'overeating']) {
            final r = tester.getRect(k('seven_day_tag_${tag}_$i'));
            expect(r.left >= 0 && r.right <= 360, isTrue, reason: '$tag $i $r');
          }
          expectNotClipped(tester, k('seven_day_day_steps_$i'));
          expectNotClipped(tester, k('seven_day_day_food_$i'));
        }
        expect(textOf(tester, k('seven_day_avg_steps_text')), avgStepsLine('123,456.0'));
        expect(textOf(tester, k('seven_day_avg_food_text')), avgFoodLine('12,345.0'));
        expect(tester.takeException(), isNull);
      });

      testWidgets('UI_360_scale_${scale}_INCONSISTENT_3_coaching_lines_full',
          (tester) async {
        set360(tester, textScale: scale);
        await pumpS1(tester, {
          0: const DayData(cups: 6, steps: 7240, kcal: 1700),
          1: const DayData(cups: 7, steps: 7241, kcal: 2000),
        });
        expect(tester.takeException(), isNull);
        for (final key in [
          'seven_day_coaching_prefix_text',
          'seven_day_coaching_water_text',
          'seven_day_coaching_steps_text',
        ]) {
          await tester.ensureVisible(k(key));
          await tester.pump();
          expectNotClipped(tester, k(key));
        }
        expect(textOf(tester, k('seven_day_coaching_steps_text')), lowStepsText('7,240.5'));
        for (var i = 1; i < 7; i++) {
          await toggle(tester, i);
        }
        expect(tester.takeException(), isNull);
      });

      testWidgets('UI_360_scale_${scale}_EMPTY_no_overflow', (tester) async {
        set360(tester, textScale: scale);
        await pumpS1(tester, {});
        expect(tester.takeException(), isNull);
        expectNotClipped(tester, k('seven_day_empty_text'));
        await toggle(tester, 6);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
