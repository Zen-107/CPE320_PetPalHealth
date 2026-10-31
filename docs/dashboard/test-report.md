# Test report: dashboard (QA รอบที่ 1 + รอบที่ 3)

> **รอบ 3 (2026-10-31 09:22–09:31) อยู่ท้ายไฟล์ §10–§15**: ผลล่าสุดหลังข้อตัดสิน owner รอบ 3 และ dev r3 (`logs/20261031-0921_dev_dashboard_r3.md`) คือ dashboard 116 เทสต์ **ผ่าน 116 / ไม่ผ่าน 0** · ทั้งแอป **719 ผ่าน / 0 ไม่ผ่าน** · `flutter analyze` No issues found! · BUG-DASH-1 ปิดแล้ว (owner ยึด A-7) · ปรับเทสต์ 12 ตัวเพราะข้อตัดสินใหม่ เพิ่มเทสต์ใหม่ 10 ตัว · ไม่พบบั๊กใหม่ · §0–§9 ด้านล่างเป็นผลรอบ 1 (คงไว้ตามเดิม)

> ผู้ทดสอบ: QA agent · วันที่ 2026-10-31 (08:26–08:47) · โค้ดที่ทดสอบ: `app/lib/features/dashboard/` + `dashboard_entry_button` ใน `app/lib/features/water/screens/water_home_screen.dart` (dev v1, `logs/20261031-0824_dev_dashboard.md`)
> อ้างอิง: requirements.md, game-rules.md, ux-flow.md, ui-spec.md + ข้อตัดสิน owner ด้านล่าง (ค่าคาดหวังทั้งหมดมาจากเอกสาร/ข้อตัดสิน ไม่ได้ลอกจากโค้ด)
> เทสต์: `app/test/dashboard/dashboard_logic_test.dart` (L), `dashboard_controller_test.dart` (C), `dashboard_screens_test.dart` (W) + ตัวช่วย `dashboard_test_helpers.dart` (ไม่มีเทสต์ในไฟล์นี้ ใช้ `FakeTimers` / `profileOf` จาก `app/test/food/food_test_helpers.dart`)
> ไม่ได้แก้โค้ดใน `app/lib/` · ไม่ได้แก้ไฟล์อื่นใน `docs/dashboard/` · ไม่ได้ commit / push

## 0. ข้อตัดสิน owner — DECIDED (owner ชั่วคราว, รอทีมยืนยัน)

ข้อไหนขัดกับเอกสาร ให้ข้อตัดสินชนะ เทสต์ที่อิงข้อตัดสินจะมีคำว่า `DECIDED_` ในชื่อ

| รหัส | เนื้อหา | มีผลต่อเทสต์ |
|---|---|---|
| D-1 | สัตว์เลี้ยงใช้ `PetCharacter`: CRYING [0,30] → `PetPose.dashboardCrying`, DAZED (30,60] → `dashboardDazed`, BUBBLY (60,80] → `dashboardBubbly` (= `waterHappy`), CHEERFUL (80,100] → `dashboardCheerful` ไม่ใช้ PNG | ตรวจ `painter.pose` ทุกช่วง, ไม่มี `Image`, ขนาด 200 (ui-spec Q-9) |
| D-2 | เวลาเครื่อง ตัดรอบ 05:00 แบบ water/steps/food ไม่มี Server Time | ใช้ `clock` ของ 3 controller (dashboard ไม่มี clock) |
| D-3 | Water, Steps = `round(min(actual/target,1)×100)`; Food ถึงเป้า = `kcal/target×100`, เกินเป้า = `max(0, 100 − ส่วนที่เกิน/target×100)`, ไม่มีเป้า = ไม่คิดคะแนน | ตัวเลขคะแนนรายหมวดทุกเทสต์ |
| D-4 | Priority 4 "คะแนนอาหารต่ำกว่าเกณฑ์" = `foodScore < 50` | ขอบ 49/50, กรณีกินเกินเป้ามาก (BUG-DASH-1) |
| Q-1 | ไม่มีเป้าอาหาร → total = `round((Steps + Water)/2)` แถบอาหาร「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 | `DECIDED_Q1_*` |
| Q-14 | เป้าน้ำ = 8 แก้ว (100% / 12.5% ต่อแก้ว ของ water_rules) | `DECIDED_Q14_*` (7 แก้ว = 88 ตาม ui-spec) |
| Q-3, Q-16, Q-19, Q-20, Q-21, Q-8 | ใช้ตามที่ ui-spec เลือก: P4 ประเมินสด, ปัด foodScore ก่อนเฉลี่ย, เริ่มที่ Priority สูงสุด + นับ 5 วิใหม่เมื่อข้อความเปลี่ยน, ไม่มี cheerTrigger, ไม่รวม `"`, หัวข้อ/tooltip「แดชบอร์ด」 | `DECIDED_Q3_* / Q16 / Q19 / Q20 / Q8` |
| Q-4 / Q-5 / Q-17 | ยึด game-rules + D-3: P2/P3 เมื่อ `< 100`, แถบอาหารเกินเป้าแสดงคะแนนจริง (93%), ตัดออกจากคิวทันที | AC-3/EC-2 |
| Q-7 | water ยังเป็นหน้าแรก เข้า dashboard ผ่าน `dashboard_entry_button` | `DECIDED_Q7_*` + เทสต์เดิมของ signup/water ต้องผ่าน |
| Q-2 / Q-11 / BUBBLY | ไม่มีการลบมื้อ; ไม่แสดงจำนวนจริง/ป้ายโซเดียม-น้ำตาล; BUBBLY ใช้หน้าเดิม | EC-2 ของ P1 ทดสอบผ่านการเปลี่ยนเป้า (ดู §7 ข้อ 5) |

## 1. สรุปตัวเลข

| รายการ | ค่า |
|---|---|
| เทสต์ dashboard ทั้งหมด | **106** (L 45 · C 18 · W 43) |
| ผ่าน / ไม่ผ่าน (dashboard) | **105 / 1** |
| `flutter test` ทั้งแอป (ใน app/) | **708 ผ่าน / 1 ไม่ผ่าน** — `02:37 +708 -1: Some tests failed.` (เทสต์เดิม 603 ผ่านครบ + dashboard 106) |
| `flutter analyze` (ทั้ง app/) | `No issues found! (ran in 5.9s)` |
| AC ทั้งหมด 5 ข้อ | 5 มีเทสต์ · ผ่าน 4 · **AC-3 ไม่ผ่าน 1 เทสต์** (BUG-DASH-1) |
| EC ทั้งหมด 5 ข้อ | 5 มีเทสต์ · ผ่าน 5 |
| AC/EC ที่ยังไม่มีเทสต์ | ไม่มี |
| Bug ที่พบ | **1** (BUG-DASH-1) |
| เทสต์ที่ QA แก้เองเพราะเทสต์ผิด | 1 (ดู §6) |
| คำถามค้าง | 11 (ดู §7) |

ชื่อเทสต์: `AC#_` / `EC#_` = ตามเอกสาร · `GR#_` = ตัวเลขจาก game-rules §# · `EDGE_` = edge case บังคับ 4 แบบ · `DECIDED_` = ตามข้อตัดสิน owner · `UI_` = โครงหน้าจอตาม ui-spec

## 2. AC → เทสต์

| AC | เทสต์ (ไฟล์) | ผล |
|---|---|---|
| AC-1 คะแนนรวม (F+S+W)/3, cap 100, จำนวนเต็ม | GR3_row1_food60_steps90_water60_total70_bubbly (L) · GR3_row2_EC5_food70_steps60_water67_total66_bubbly (L) · GR4_EC1_food100_steps100_water160_cap100_cheerful (L) · EC1_all_categories_over_target_snapshot_total_100 (L) · EC5_total_is_integer_rounded_65_67_to_66_and_65_33_to_65 (L) · DECIDED_Q16_total_from_rounded_category_scores (L) · AC1_GR3_row1_equivalent_60_100_50_shows_70_bubbly (W) · AC1_EC5_total_text_is_integer_no_decimal (W) · UI_realtime_update_when_source_changes (W) | ผ่าน |
| AC-2 อารมณ์ 4 ช่วง | AC2_EDGE_mood_at_0/30/31/60/61/80/81/100 (L, 8) · AC2_EDGE_boundaries_via_snapshot_30_31_60_61_80_81 (L) · DECIDED_Q13_mood_from_rounded_total_30_4_crying_30_5_dazed (L) · DECIDED_D1_pose_mapping_PetCharacter (L) · AC2_EDGE_total_0/30/31/60/61/80/81/100_is_<mood> (W, 8: key `dashboard_pet_image_<mood>` + `painter.pose`) · DECIDED_D1_PetCharacter_size_200_no_png (W) · DECIDED_Q20_no_cheerTrigger_and_state_kept_on_mood_change (W) · AC2_animated_cheerful_runs_with_pump_duration (W) | ผ่าน |
| AC-3 ข้อความวนทุก 5 วิ ตรงตัว + Dynamic Queue | AC3_exact_strings_4_priorities (L) · AC3_empty_day_queue_P2_P3_P4_in_priority_order (L) · GR3_row1_example_queue_P2_P3_only (L) · AC3_EDGE_P1_overeat_threshold_2100_not_2101_yes (L) · DECIDED_Q2_no_target_never_P1 (L) · AC3_EDGE_P2_water_7_cups_in_8_cups_out (L) · AC3_EDGE_P3_steps_99pct_in_100pct_out (L) · DECIDED_D4_EDGE_P4_food_score_49_in_50_out (L) · DECIDED_Q3_P4_no_meal_in_even_with_target (L) · DECIDED_Q3_P4_logged_but_still_below_50_stays (L) · DECIDED_Q3_P4_no_target_only_no_meal_rule (L) · **DECIDED_D4_P4_far_over_target_food_score_below_50_in_queue (L)** · AC3_queue_empty_when_all_resolved (L) · AC3_next_alert_loops_in_priority_order (L) · AC3_starts_at_highest_priority_P2_on_empty_day (C) · AC3_EDGE_rotation_exactly_at_5s_not_4_999s_and_loops (C) · AC3_P1_queue_rotates_P1_P2_P3_back_to_P1 (C) · AC3_single_item_queue_stays_on_same_text (C) · AC3_EDGE_empty_queue_no_alert (C) · DECIDED_Q3_P4_removed_when_meal_logged_reaches_50 (C) · DECIDED_Q19_new_P1_enters_queue_shows_highest_priority (C) · AC3_rotates_every_5s_P2_P3_P4_P2 (W: 4.9 s ยังเดิม / 5.0 s เปลี่ยน) · AC3_P1_exact_text_shown_once_red_food_bar_93 (W) · AC3_EDGE_P1_2100_not_red_2101_red (W) · AC3_EDGE_empty_queue_hides_banner_keeps_slot (W) | **ไม่ผ่าน 1** (BUG-DASH-1) · อื่นผ่าน |
| AC-4 UI ครบ 3 ส่วน | AC4_total_card_pet_and_three_bars_present (W) · UI_layout_order_card_alert_pet_food_steps_water (W) · UI_bar_labels_format_and_bar_value_equals_score (W) · UI_card_and_bubble_colors_from_color_scheme (W) · UI_loading_shows_only_progress_indicator (W) · DECIDED_Q8_header_title (W) | ผ่าน |
| AC-5 ตัดรอบ 05:00 (D-2 เวลาเครื่อง) | AC5_EC3_EDGE_04_59_59_keeps_day_05_00_00_resets_all (C) · AC5_open_after_05_00_with_yesterday_data_shows_new_day (C) · AC5_EC3_EDGE_open_04_59_59_then_05_00_00_resets_screen (W) · AC5_resume_after_05_00_resets (W) | ผ่าน |

## 3. Edge case (EC ในเอกสาร + 4 แบบบังคับ)

| กรณี | เทสต์ | ผล |
|---|---|---|
| EC-1 เฉลี่ยเกิน 100 → 100% | GR4_EC1_food100_steps100_water160_cap100_cheerful (L) · EC1_all_categories_over_target_snapshot_total_100 (L) · EC1_GR4_over_target_everywhere_capped_100_cheerful (W: 13 แก้ว / 20,000 ก้าว / 2,000 kcal → `คะแนนสุขภาพรวม: 100%`, แถบ ≤ 1.0, cheerful) | ผ่าน |
| EC-2 แก้ปัญหาขณะแสดง → ตัดออกทันที ไม่รอ 5 วิ | EC2_GR4_P1_removed_while_showing_next_is_P2 (L) · EC2_last_item_removed_wraps_to_head (L) · EC2_only_item_removed_queue_empty_null (L) · EC2_P2_resolved_by_logging_water_switches_to_P3_immediately (C) · DECIDED_Q19_after_removal_next_rotation_counts_5s_anew (C) · EC2_P3_resolved_by_steps_switches_to_P4_immediately (C) · EC2_GR4_P1_removed_while_showing_switches_to_P2_immediately (C) · EC2_last_problem_resolved_queue_empty_alert_hidden (C) · EC2_resolve_shown_P2_switches_without_waiting (W) | ผ่าน |
| EC-3 ข้าม 05:00 ขณะเปิดค้าง | AC5_EC3_EDGE_04_59_59_keeps_day_05_00_00_resets_all (C) · EC3_rollover_clears_P1_and_red_bar (C) · AC5_EC3_EDGE_open_04_59_59_then_05_00_00_resets_screen (W: 100% cheerful → pump 1 s ที่ 04:59:59 ยัง 100% → 05:00:00 pump 1 s → ทุกแถบ 0%, total 0%, crying, 「ดื่มน้ำๆ」, ไม่มี SnackBar/AlertDialog) | ผ่าน |
| EC-4 ติดลบ / Null → 0 | GR3_row3_EC4_food_minus10_steps90_water90_food0_total60_dazed (L) · EC4_null_and_negative_category_become_0 (L) · EC4_GR3_row3_negative_food_shows_0_total_60_dazed (W) · EC4_EDGE_corrupt_storage_all_three_fallback_zero (C) · EC4_EDGE_corrupt_storage_no_crash_all_0 (W) | ผ่าน |
| EC-5 ทศนิยม → จำนวนเต็ม (65.66 → 66) | GR3_row2_EC5_food70_steps60_water67_total66_bubbly (L) · EC5_total_is_integer_rounded_65_67_to_66_and_65_33_to_65 (L) · EC5_GR3_row2_equivalent_65_67_shows_66_bubbly (W) · AC1_EC5_total_text_is_integer_no_decimal (W) | ผ่าน |
| 1. ค่าเกณฑ์พอดี ±1 | อารมณ์ 30/31, 60/61, 80/81 (L, W) · Priority 1 2,100 / 2,101 kcal (L, W) · P2 7/8 แก้ว (L) · P3 99%/100% (L) · P4 foodScore 49/50 (L) · หมุนข้อความ 4.999 / 5.000 s (C), 4.9 / 5.0 s (W) · 04:59:59 / 05:00:00 (C, W) | ผ่าน |
| 2. ข้ามวัน / รีเซ็ต | AC5_* / EC3_* ข้างบน · resume หลัง 05:00 (W) · เปิดหลัง 05:00 ด้วยข้อมูลเมื่อวาน (C) | ผ่าน |
| 3. เพดาน max / min | EDGE_category_min_max_0_and_100_never_outside (L) · DECIDED_Q14_water_target_8_cups_score_per_cup (9 แก้ว = 100) · DECIDED_D3_steps_ratio_round_and_cap (16,000 = 100) · EDGE_D3_food_far_over_target_floor_0_not_negative (4,001 / 9,000 kcal = 0) · EC1_* (W: แถบ ≤ 1.0) | ผ่าน |
| 4. ข้อมูลว่าง / เปิดครั้งแรก / ข้อมูลเสีย | EDGE_empty_first_open_all_zero_crying (L) · EDGE_first_open_no_data_all_zero_P2_first (C) · EC4_EDGE_corrupt_storage_all_three_fallback_zero (C: repository ทั้ง 3 throw) · EDGE_EC4_first_open_empty_all_0_crying_P2 (W) · EC4_EDGE_corrupt_storage_no_crash_all_0 (W) · UI_loading_shows_only_progress_indicator (W) | ผ่าน |

## 4. ตัวเลขใน game-rules / หน้าจอ / ข้อตัดสิน

| หัวข้อ | เทสต์ | ผล |
|---|---|---|
| game-rules §3 แถว 1 (60, 90, 60 → 70 BUBBLY) | GR3_row1_* (L ค่าตรงตามตาราง) · AC1_GR3_row1_equivalent_60_100_50_shows_70_bubbly (W — น้ำ 60% ทำไม่ได้ด้วยเป้า 8 แก้ว จึงใช้ชุดผลรวม 210 เท่ากัน) | ผ่าน |
| game-rules §3 แถว 2 (70, 60, 67 → 66 BUBBLY) | GR3_row2_* (L) · EC5_GR3_row2_equivalent_65_67_shows_66_bubbly (W — 71 + 76 + 50 = 197 → 65.67 → 66) | ผ่าน |
| game-rules §3 แถว 3 (−10, 90, 90 → Food 0, 60 DAZED) | GR3_row3_* (L) · EC4_GR3_row3_negative_food_shows_0_total_60_dazed (W — −10 kcal → `คะแนนอาหาร: 0%`, 0 + 80 + 100 = 180 → 60) | ผ่าน |
| game-rules §4 แถว 1 (100, 100, 160 → 120 → 100 CHEERFUL) | GR4_EC1_* (L) · EC1_GR4_* (W) | ผ่าน |
| game-rules §4 แถว 2 (P1 หลุดขณะแสดง → P2 ทันที) | EC2_GR4_P1_removed_while_showing_next_is_P2 (L) · EC2_GR4_P1_removed_while_showing_switches_to_P2_immediately (C) | ผ่าน |
| game-rules §4 แถว 3 (ข้าม 05:00 → ทุกคะแนนเป็นค่าวันใหม่) | AC5_EC3_* (C, W) | ผ่าน |
| alertInterval = 5 วินาที | AC3_EDGE_rotation_exactly_at_5s_not_4_999s_and_loops (C) · AC3_rotates_every_5s_P2_P3_P4_P2 (W) | ผ่าน |
| ข้อความ alert 4 ข้อตรงตัว (ไม่รวม `"` — Q-21) | AC3_exact_strings_4_priorities (L) · AC3_P1_exact_text_shown_once_red_food_bar_93 (W: `find.text(P1)` เจอ 1, ไม่มี maxLines/ellipsis, ไม่ใช่ SnackBar) · AC3_rotates_every_5s_* (W) | ผ่าน |
| D-3 สูตรรายหมวด | DECIDED_Q14_water_target_8_cups_score_per_cup · DECIDED_D3_steps_ratio_round_and_cap · DECIDED_D3_food_up_to_target_kcal_over_target_x100 · DECIDED_D3_food_over_target_100_minus_over_percent (2,100 = 95, 2,150 = 93, 3,000 = 50, 4,000 = 0) (L) | ผ่าน |
| Q-1 ไม่มีเป้าอาหาร | DECIDED_D3_Q1_food_no_target_not_scored_total_avg_of_2 · DECIDED_Q1_no_target_can_reach_100_cheerful (L) · DECIDED_Q1_no_target_label_color_bar0_total_avg2 (W: ป้าย, สี `onSurfaceVariant`, แถบ 0 สี primary, total 75, ไม่มี P1) | ผ่าน |
| ui-spec ช่องข้อความ: ห่างกล่องสัตว์เลี้ยง 12 px, สูงคงที่เมื่อหมุน/คิวว่าง, สัตว์เลี้ยงไม่ขยับ | UI_alert_slot_bottom_12px_above_pet_box · UI_slot_height_constant_and_pet_still_while_rotating · AC3_EDGE_empty_queue_hides_banner_keeps_slot (W) | ผ่าน |
| ทางเข้าจาก water (Q-7, ui-spec §2.0) | DECIDED_Q7_entry_button_icon_tooltip_position (ไอคอน `Icons.dashboard`, tooltip「แดชบอร์ด」, อยู่หลัง food ก่อนรายงาน, water ยังเป็นหน้าแรก) · DECIDED_Q7_tap_opens_S1_with_same_controllers_and_back (W) | ผ่าน |
| จอ 360×640 textScaler 1.0 | UI_360_scale_1_0_via_water_P1_full_no_overflow (เข้าทางปุ่มบน water, P1 ไม่ถูกตัด, ไม่มี exception) · UI_360_scale_1_0_water_appbar_three_icons_no_overflow · DECIDED_Q1_360_scale_1.0_no_target_label_no_overflow (W) | ผ่าน |
| จอ 360×640 textScaler 1.5 | UI_360_scale_1_5_P1_full_no_overflow (P1 ไม่ถูกตัด, อยู่ในฟองและช่อง, ช่องห่าง 12 px, หมุนแล้วช่องไม่เปลี่ยน) · DECIDED_Q1_360_scale_1.5_no_target_label_no_overflow · UI_360_scale_1_5_can_scroll_to_water_bar (W) — เปิด S-1 ตรง ไม่ผ่านหน้า water เพราะหน้า water overflow เองที่ 1.5 (§8) | ผ่าน |
| Timer ถูก cancel | UI_dispose_cancels_alert_timer (C) · ทุก W ไม่มี "Timer still pending" | ผ่าน |
| เทสต์เดิม (signup S-7, water, steps, food) ไม่กระทบ | `flutter test` ทั้งแอป: 603 เทสต์เดิมผ่านครบ | ผ่าน |

## 5. รายการ Bug

### BUG-DASH-1 — 「ฉันหิว」(Priority 4) ไม่เข้าคิวเมื่อกินเกินเป้ามากจน foodScore < 50

- **ความรุนแรง:** ต่ำ (มีผลเฉพาะกินเกินเป้า > 50% เช่น > 3,000 kcal ที่เป้า 2,000) · **เทสต์:** `DECIDED_D4_P4_far_over_target_food_score_below_50_in_queue` (dashboard_logic_test.dart)
- **ขั้นตอนทำซ้ำ:** เป้า 2,000 kcal (ชาย 25 ปี BMI ปกติ) · บันทึกอาหาร 3,500 kcal (1 มื้อ) · น้ำ 0 แก้ว · ก้าว 0 → ดูคิวข้อความ (`DashboardLogic.snapshot(...).alerts`)
- **ผลที่คาด (อ้างเอกสาร):** foodScore = max(0, 100 − 1,500/2,000×100) = 25 (D-3) → 25 < 50 ⇒ trigger P4 ตาม game-rules §1.1 Priority 4 「ยังไม่ได้บันทึกอาหารมื้อใดๆ **หรือ**คะแนนอาหารต่ำกว่าเกณฑ์」 + D-4 (`foodScore < 50`) + ui-spec Q-3 (owner ใช้ตาม ui-spec: 「อยู่ในคิวเมื่อ … **หรือ** (มี foodScore และ `< 50`)」) → คิว = [P1, P2, P3, P4]
- **ผลจริง:**
  ```
  Expected: [P1 'แต่วันนี้ฉันอิ่ม…', 'ดื่มน้ำๆ', 'ขยับร่างกายหน่อย อีกนิดๆ', 'ฉันหิว']
    Actual: [P1 'แต่วันนี้ฉันอิ่ม…', 'ดื่มน้ำๆ', 'ขยับร่างกายหน่อย อีกนิดๆ']
     Which: at location [3] … shorter than expected
  ```
  สาเหตุ: `DashboardLogic.isHungry` คืน `false` เมื่อ `isFoodOverTarget` (Dev ASSUMPTION A-7 "นับ foodScore < 50 เฉพาะตอน kcal ≤ target") — เป็นเงื่อนไขที่ไม่มีในเอกสาร/ข้อตัดสิน
- **หมายเหตุ:** Dev ยกเป็นคำถาม QD-2 ไว้แล้ว (ข้อความ「ฉันหิว」ขัดความหมายกับ P1「อิ่มและอืดเกินไป」) — ถ้า owner ยืนยัน A-7 ให้แก้ game-rules §1.1 / D-4 ก่อน แล้ว QA จะปรับเทสต์ตามเอกสารใหม่ (ดู §7 ข้อ 4) · ยังไม่แก้ตามโค้ด

## 6. เทสต์ที่ QA แก้เอง (เทสต์ผิด)

| เทสต์ | ปัญหา | แก้อย่างไร |
|---|---|---|
| UI_card_and_bubble_colors_from_color_scheme | รอบแรก `_TypeError` — เทสต์สมมติว่า key `dashboard_alert_banner` อยู่บน `Container` เอง แต่ ui-spec กำหนด "(บน `Container`)" เฉพาะการ์ดคะแนน (`dashboard_total_score_card`) ไม่ได้บังคับชนิด widget ของฟองข้อความ | หา `Container` ที่เป็นลูกของ `dashboard_alert_banner` แล้วตรวจสี `secondaryContainer` (ค่าคาดหวังเดิม) |

## 7. คำถามค้าง (ไม่นับเป็น bug — ไม่ได้ assert จุดที่เอกสารไม่ระบุ)

1. **เอกสารยังไม่ตรงข้อตัดสิน** — requirements AC-5/US-5/§6, ux-flow §2–§6, game-rules §1/§2/§4/§5 ยังอ้าง Server Time / ICT / Session Database / PNG 300×300 (D-1, D-2, Q-9, Q-12, Q-15) — ต้องให้ Design/Product อัปเดตหลังทีมยืนยัน
2. **คะแนนปัดถึง 100 ทั้งที่ยังไม่ถึงเป้า** — D-3 ปัดก่อนเทียบ: 7,960–7,999 ก้าว (เป้า 8,000) = stepsScore 100 → 「ขยับร่างกายหน่อย อีกนิดๆ」หลุดคิว แม้ removal ใน game-rules §1.1 เขียนว่า "เดินครบตามเป้าหมาย" (อาหาร 1,990–1,999 kcal = 100 ก็เช่นกัน) — เทสต์ใช้เฉพาะ 7,920 (99) / 8,000 (100) ไม่ assert ช่วงนี้
3. **การปัด .5** (half-up หรือ banker's) เอกสารไม่ระบุ — ค่า .5 ที่ assert มีเฉพาะที่ ui-spec ระบุเลขไว้เอง (7 แก้ว = 88 ใน Q-14, 2,150 kcal = 93 ใน §3) · ไม่ assert ค่ารวมที่ลงท้าย .5 กรณี Q-1 (หาร 2)
4. **QD-2 / BUG-DASH-1** — กินเกินเป้ามากจน foodScore < 50 ควรขึ้น「ฉันหิว」คู่กับ P1 หรือไม่ (เอกสาร/D-4 ตามตัวอักษร = ขึ้น, Dev A-7 = ไม่ขึ้น) — owner ตัดสิน
5. **EC-2 สำหรับ Priority 1** — Q-2 ไม่มีทาง "จัดการปัญหาอาหาร" ในแอป (P1 ค้างจนตัดรอบ) เทสต์ C จำลองการหลุดคิวด้วยเป้าที่เปลี่ยนจากโปรไฟล์ (2,000 → 2,400) เพื่อพิสูจน์กลไก "ข้ามไป P2 ทันที" — ถ้าการเปลี่ยนเป้าไม่ควรนับว่า "แก้ปัญหา" ต้องกำหนดเพิ่ม
6. **"ทันที" ของ EC-3** — S-1 ตรวจรอบวันทุก 1 วินาที (Dev A-9) เอกสารไม่กำหนดความหน่วงที่ยอมรับได้ — เทสต์ยอมรับการรีเซ็ตภายใน 1 วินาทีหลัง 05:00:00
7. **ข้อความที่ไม่ได้แสดงหลุดคิว / ข้อความใหม่เข้าคิว** — Q-19 ตอบแค่ "เริ่มจาก Priority สูงสุด" เทสต์ assert เฉพาะ P1 เข้าคิวแล้วขึ้นทันที (DECIDED_Q19) ไม่ assert กรณีข้อความอื่นที่ไม่ได้แสดงหลุดคิว (Dev A-8 คงข้อความเดิม)
8. **QD-1 เป้าน้ำ 8 แก้ว** — สัตว์เลี้ยงหน้า water ร่าเริงที่ 7 แก้ว แต่ dashboard ยังแสดง 88% และ「ดื่มน้ำๆ」
9. **QD-3 ปุ่ม「รายงานรายเดือน」บน AppBar ของ water** — Dev ห่อ Flexible + ellipsis เพื่อไม่ให้ AppBar ล้นที่ 360 dp (ui-spec §2.0 ประเมินว่าไม่ล้น) — เทสต์ยืนยันแค่ "ไม่มี overflow" ไม่ได้ตรวจว่าป้ายถูกตัดหรือไม่ — UI ต้องยอมรับ
10. **QD-4 ช่องข้อความ** — Dev ใช้ min-height ที่วัดจากข้อความ P1 แทน `Visibility(maintainSize)` — เทสต์ตรวจผลบนจอตาม ui-spec (12 px, ความสูงคงที่, P1 ไม่ถูกตัด, `find.text(P1)` เจอ 1) ผ่านทั้งหมด — UI ต้องยอมรับวิธี
11. **ไม่มีเป้าอาหาร + ยังไม่ผ่าน S-3** — ux-flow ไม่บอกว่า S-1 ของ dashboard ควรพาไปตั้งโปรไฟล์หรือไม่ (ui-spec: ไม่มี CTA) — ไม่ได้ assert

## 8. ข้อสังเกต: หน้า water ที่ 360×640 textScaler 1.5 (ไม่นับเป็นบั๊ก dashboard)

- **ผลบนโค้ดปัจจุบัน:** `A RenderFlex overflowed by 68 pixels on the bottom` ที่ `Column` ของ body (`water_home_screen.dart:256` — `_buildContent` → `SafeArea` → `Padding(24)` → `Column` ไม่มี scroll) · AppBar ไม่ล้น · ที่ textScaler 1.0 ไม่มี error
- **มีมาก่อนงาน dashboard:** `git diff HEAD -- app/lib/features/water/` แก้แค่ import, `_openSteps`/`_openFood` → `_stepsController()`/`_foodController()`, `_openDashboard` และ `AppBar.actions` (hunk สุดท้ายจบที่บรรทัด 189 ของ HEAD ก่อน `body:` ที่บรรทัด 193) — ไม่แตะ body · รันเทสต์ probe เดียวกันบนสำเนา HEAD (`git archive HEAD app` แตกลง scratchpad ไม่แตะ working tree) ได้ **2 error**: `RenderFlex overflowed by 79 pixels on the right` ที่ AppBar (`:164`) + `overflowed by 68 pixels on the bottom` ที่ body (`:213`) → body overflow 68 px เท่าเดิม = ของเดิม · AppBar overflow ที่ 1.5 ถูก Dev แก้ไปแล้วด้วย Flexible (ผลข้างเคียงดี)
- **ผลต่อเทสต์:** เทสต์ 360×640 ที่ 1.5 เปิด S-1 ตรง (ไม่ผ่านหน้า water) · ที่ 1.0 เปิดผ่านปุ่มบนหน้า water
- **แนะนำ:** เปิด issue แยกของ water (ห่อ body ด้วย scroll แบบ steps/food)

## 9. ผลการรัน (ใน app/)

| คำสั่ง | ผล |
|---|---|
| `flutter analyze` | `No issues found! (ran in 5.9s)` |
| `flutter test test/dashboard/dashboard_logic_test.dart` | `00:00 +44 -1: Some tests failed.` (BUG-DASH-1) |
| `flutter test test/dashboard/dashboard_controller_test.dart` | `00:00 +18: All tests passed!` |
| `flutter test test/dashboard/dashboard_screens_test.dart` | `00:13 +43: All tests passed!` |
| `flutter test` (ทั้งแอป) | `02:37 +708 -1: Some tests failed.` — ไม่ผ่านตัวเดียวคือ DECIDED_D4_P4_far_over_target_food_score_below_50_in_queue |

---

# รอบที่ 3 (2026-10-31)

> ผู้ทดสอบ: QA agent · 09:22–09:31 · โค้ดที่ทดสอบ: dev r3 (`logs/20261031-0921_dev_dashboard_r3.md`) ได้แก่ floor ทุกสูตรใน `dashboard_rules.dart`, `FoodProfileCtaBanner` บน S-1, ปุ่มรายงานของ water เป็น `IconButton`
> ไม่ได้แก้ `app/lib/` · ไม่ได้แก้ไฟล์อื่นใน `docs/dashboard/` · ไม่ได้ commit / push

## 10. ข้อตัดสิน owner รอบ 3 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน)

ข้อตัดสินรอบนี้ชนะเอกสารและข้อตัดสินรอบก่อน เทสต์ที่อิงข้อตัดสินนี้จะมี `DECIDED_R3` ในชื่อ

| ข้อ | เนื้อหา | ชนะ / แทนที่ |
|---|---|---|
| 1 | BUG-DASH-1 / QD-2: ยึด A-7 คือกินเกินเป้าไม่ต้องขึ้น「ฉันหิว」 (P4 ใช้ foodScore < 50 เฉพาะตอน kcal ≤ target) | D-4 ตามตัวอักษร, ui-spec Q-3 |
| QD-1 | เป้าน้ำ 8 แก้วจากค่าคงที่ของ water ใช้ต่อ | (ยืนยัน Q-14) |
| 2 | ปัดลง (floor) ทุกคะแนน (Water, Steps, Food, total) ได้ 100 ก็ต่อเมื่อถึงเป้าจริงเท่านั้น · Food เกินเป้า = 100 − ceil(over×100/target) | game-rules §3 แถว 2 / EC-5 (65.66 → **65** BUBBLY), round ของ D-3 / Q-1, Q-16, Q-13 (30.67 → 30 = CRYING) |
| 3, 4, 8 | A-8 (เลือกข้อความเมื่อคิวเปลี่ยน), ตรวจรอบวันทุก 1 วินาที, min-height แทน Visibility: ใช้ตามที่ dev ทำ | คำถามรอบ 1 ข้อ 6, 7, 10 |
| 5 | ไม่มีเป้าอาหาร → S-1 แสดง CTA เดิมของ food (`food_profile_cta_banner`) ใต้แถบอาหาร กดแล้วเปิด S-3 ของ food | คำถามรอบ 1 ข้อ 11, ui-spec §3 "ไม่มี CTA" |
| 7 | `water_monthly_report_button` เป็นปุ่มไอคอน + tooltip「รายงานรายเดือน」 ไม่มีข้อความบนปุ่ม | water ux-flow (ป้ายบนปุ่ม), คำถามรอบ 1 ข้อ 9 |

ค่าคาดหวังที่คำนวณเองจากข้อ 2 (ไม่ได้ลอกจากโค้ด): 7 แก้ว = floor(87.5) = 87 · 3 แก้ว = 37 · 7,999/8,000 ก้าว = 99 · 1,999/2,000 kcal = 99 · 2,001 kcal = 100 − ceil(0.05) = 99 · 2,101 = 100 − ceil(5.05) = 94 · 2,150 = 100 − ceil(7.5) = 92 · 3,500 = 25 · (70+60+67)/3 = 65.67 → 65 · (92+90+75)/3 = 85.67 → 85

## 11. สรุปตัวเลขรอบ 3

| รายการ | ค่า |
|---|---|
| เทสต์ dashboard ทั้งหมด | **116** (L 47 · C 18 · W 51) = รอบ 1 106 ตัว + ใหม่ 10 ตัว |
| ผ่าน / ไม่ผ่าน (dashboard) | **116 / 0** |
| `flutter test` ทั้งแอป | **719 ผ่าน / 0 ไม่ผ่าน** (`02:53 +719: All tests passed!`) |
| `flutter analyze` | `No issues found! (ran in 5.2s)` |
| AC 5/5 · EC 5/5 มีเทสต์และผ่าน · AC/EC ที่ยังไม่มีเทสต์ | ไม่มี |
| Bug ใหม่ | **0** · BUG-DASH-1 ปิดแล้ว (owner เปลี่ยนพฤติกรรมที่ถือว่าถูกตามข้อ 1 ไม่ได้ปิดเพราะ dev แก้โค้ด) |
| เทสต์ที่ปรับเพราะข้อตัดสินรอบ 3 | 12 ตัว (§12) ตรงกับรายชื่อ 12 ตัวใน dev log r3 ทุกตัว |
| เทสต์ที่ QA แก้เองเพราะเทสต์ผิด (รอบนี้) | 0 |
| เทสต์ใหม่ | 10 ตัว (§13) |

## 12. เทสต์ที่ปรับ (ค่าคาดหวังเปลี่ยนเพราะข้อตัดสินรอบ 3)

| # | เทสต์เดิม → ชื่อใหม่ | เดิม → ใหม่ | เพราะข้อ |
|---|---|---|---|
| 1 | GR3_row2_EC5_food70_steps60_water67_total66_bubbly → `DECIDED_R3_GR3_row2_EC5_food70_steps60_water67_total65_bubbly` (L) | 66 → 65 (ยัง BUBBLY) | 2 |
| 2 | EC5_total_is_integer_rounded_65_67_to_66_and_65_33_to_65 → `DECIDED_R3_EC5_total_is_integer_floor_65_67_and_65_33_to_65` (L) | 197/3: 66 → 65 | 2 |
| 3 | `DECIDED_Q14_water_target_8_cups_score_per_cup` (L, ชื่อเดิม) | 7 แก้ว 88 → 87 | 2 (เป้า 8 แก้วคงเดิมตาม QD-1) |
| 4 | `DECIDED_D3_food_up_to_target_kcal_over_target_x100` (L, ชื่อเดิม) | 1,999 kcal 100 → 99 | 2 |
| 5 | `DECIDED_D3_food_over_target_100_minus_over_percent` (L, ชื่อเดิม) | 2,150 kcal 93 → 92 | 2 |
| 6 | DECIDED_Q16_total_from_rounded_category_scores → `DECIDED_R3_total_floor_of_floored_category_scores` (L) | 86 → 85 (food 92) | 2 (แทน Q-16) |
| 7 | DECIDED_Q13_mood_from_rounded_total_30_4_crying_30_5_dazed → `DECIDED_R3_mood_from_floored_total_30_67_is_crying` (L) | Food 92 (30.67): DAZED → total 30 CRYING (เพิ่มเช็ก Food 93 = 31 DAZED) | 2 (แทน Q-13) |
| 8 | DECIDED_D4_P4_far_over_target_food_score_below_50_in_queue → `DECIDED_R3_A7_P4_far_over_target_food_score_below_50_not_in_queue` (L) | [P1,P2,P3,P4] → [P1,P2,P3] | 1 |
| 9 | EC5_GR3_row2_equivalent_65_67_shows_66_bubbly → `DECIDED_R3_EC5_GR3_row2_equivalent_65_67_shows_65_bubbly` (W) | `คะแนนสุขภาพรวม: 66%` → `65%` | 2 |
| 10 | `UI_realtime_update_when_source_changes` (W, ชื่อเดิม) | 3 แก้ว 38% → 37% | 2 |
| 11 | AC3_P1_exact_text_shown_once_red_food_bar_93 → `AC3_P1_exact_text_shown_once_red_food_bar_DECIDED_R3_92` (W) | `คะแนนอาหาร: 93%` / 0.93 → `92%` / 0.92 | 2 |
| 12 | `UI_S1_button_label_and_plus_icon_per_ux_flow` (`app/test/water/water_screens_test.dart`, ชื่อเดิม) | เดิมหา `Text('รายงานรายเดือน')` บนปุ่ม → ตรวจ tooltip ของ `IconButton` =「รายงานรายเดือน」และไม่มีข้อความบนปุ่ม | 7 (spec เปลี่ยนตามข้อตัดสิน ไม่ใช่ปรับตามโค้ด) |

ไม่มีเทสต์อื่นที่ค่าคาดหวังเปลี่ยน: ขอบอารมณ์ 30/31/60/61/80/81, ตัวอย่าง §3 แถว 1 และ 3, §4, P1 2,100/2,101, P4 49/50 ใช้ค่าที่หารลงตัวอยู่แล้ว จึงได้ผลเท่ากันทั้ง round และ floor

## 13. เทสต์ใหม่รอบ 3

| เทสต์ | ไฟล์ | ตรวจอะไร | ข้อ |
|---|---|---|---|
| DECIDED_R3_EDGE_100_only_when_target_reached | L | 7 แก้ว 87 / 8 แก้ว 100 · 7,999 ก้าว 99 / 8,000 ก้าว 100 · 1,999 kcal 99 / 2,000 kcal 100 / 2,001 kcal 99 / 2,101 kcal 94 · ที่ 7,999 ก้าวยังมี「ขยับร่างกายหน่อย อีกนิดๆ」 · (100+99+100)/3 = 99 | 2 |
| DECIDED_R3_Q1_no_target_total_floor_of_half | L | ไม่มีเป้า: (100 + 87)/2 = 93.5 → 93 | 2 + Q-1 |
| DECIDED_R3_Q5_no_target_shows_food_cta_under_food_bar | W | มี `food_profile_cta_banner` พร้อมข้อความ food「ตั้งค่าโปรไฟล์สุขภาพเพื่อรับเป้าหมายแคลอรี่ที่แม่นยำ」 อยู่ใต้ `dashboard_food_bar` และเหนือแถวก้าว | 5 |
| DECIDED_R3_Q5_with_target_no_cta | W | มีเป้า → ไม่มี CTA | 5 |
| DECIDED_R3_Q5_tap_cta_opens_food_profile_screen | W | กด CTA แล้วเปิด `FoodProfileScreen` (มี `food_profile_save_button`) | 5 |
| DECIDED_R3_Q5_360_scale_1.0_cta_no_overflow / _1.5_ | W (2) | 360×640 ไม่มี exception · CTA อยู่ในความกว้างจอ · ยอดรวม `food_cta_total_text` ไม่ถูกตัดและอยู่ในกรอบ CTA | 5 |
| DECIDED_R3_Q7_report_button_icon_only_tooltip | W | `water_monthly_report_button` เป็น `IconButton`, tooltip「รายงานรายเดือน」, ไม่มีข้อความบนปุ่ม | 7 |
| DECIDED_R3_Q7_water_appbar_360_scale_1.0_no_overflow / _1.5_ | W (2) | หน้า water 360×640 ไม่มี error ที่มาจาก AppBar / NavigationToolbar · ปุ่มทั้ง 4 (steps, food, dashboard, รายงาน) อยู่ในจอช่วง 0–360 · ที่ 1.5 เทสต์เก็บ error เองและกรองเฉพาะ error ของ AppBar เพราะ body ของ water ล้นแนวตั้ง 68 px ซึ่งเป็นปัญหาเดิม (§8) | 7 |

เทสต์ food เดิมทั้งหมดยังผ่านหลัง dev ย้าย CTA ไปเป็น `FoodProfileCtaBanner` (นับรวมอยู่ใน 719 ตัว)

## 14. คำถามค้าง (รอบ 3)

1. **เอกสารยังไม่ตรงข้อตัดสิน**: game-rules §3 แถว 2 / requirements EC-5 ยังเขียน 65.66 → 66 (ข้อ 2 ให้ 65, dev QD-8), game-rules §1.1 P4 ยังไม่มีข้อยกเว้นกรณีกินเกินเป้า (ข้อ 1), ui-spec §3 ยังเขียนว่าไม่มี CTA (ข้อ 5), ui-spec Q-14 ยังเขียน 88 และ §3 ยังเขียน 93% · ข้อ 1 ของรอบ 1 (Server Time / PNG) ก็ยังค้าง ต้องให้ Design / Product / UI อัปเดต
2. **QD-6 ตำแหน่ง CTA**: ตอนนี้อยู่ใต้แถบอาหาร และยังคงป้าย「คะแนนอาหาร: ยังไม่มีเป้าหมาย」+ แถบ 0 ไว้ · เทสต์ assert แค่ "ใต้แถบอาหาร ก่อนแถวก้าว" ตามข้อตัดสิน ไม่ได้ assert ระยะ 8
3. **QD-7 key ของ CTA**: ใช้ key ของ food (`food_profile_cta_banner`) ตามข้อตัดสิน "CTA เดิมของ food" · ถ้าเปลี่ยนเป็น key `dashboard_` ต้องแก้เทสต์ตาม
4. **ข้อความชวนใน CTA** (`food_cta_text`) มี `maxLines: 2` + ellipsis ตาม food ui-spec #9b · เทสต์ที่ 360 ตรวจว่ายอดรวมไม่ถูกตัด แต่ไม่ได้ assert ว่าข้อความชวนไม่ถูกตัด (food spec อนุญาตให้ตัด)
5. **EC-2 ของ P1** (คำถามรอบ 1 ข้อ 5) ยังค้าง: ทดสอบด้วยการเปลี่ยนเป้าจากโปรไฟล์ · กรณีมีเป้าแล้วกินเกินยังไม่มีทางให้ผู้ใช้ "จัดการ" ได้
6. ข้อสังเกตหน้า water (body ล้น 68 px ที่ textScaler 1.5) ยังอยู่ ควรเปิด issue แยกของ water

## 15. ผลการรันรอบ 3 (ใน app/)

| คำสั่ง | ผล |
|---|---|
| `flutter analyze` | `No issues found! (ran in 5.2s)` |
| `flutter test test/dashboard/ test/water/water_screens_test.dart` | `00:18 +133: All tests passed!` |
| `flutter test` (ทั้งแอป) | `02:53 +719: All tests passed!` (exit 0) |
| `flutter test test/dashboard/dashboard_logic_test.dart` | `00:15 +47: All tests passed!` |
| `flutter test test/dashboard/dashboard_controller_test.dart` | `00:07 +18: All tests passed!` |
| `flutter test test/dashboard/dashboard_screens_test.dart` | `00:13 +51: All tests passed!` |
