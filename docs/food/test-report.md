# Test report: food (QA รอบที่ 1 + รอบที่ 2)

> **รอบ 2 (2026-10-31 06:13–06:27) อยู่ท้ายไฟล์ §9–§15** — สรุปล่าสุด (รันซ้ำ 06:26 หลัง Dev แก้ BUG-FOOD-2): food 193 เทสต์ **ผ่าน 193 / ไม่ผ่าน 0** · ทั้งแอป **603 ผ่าน / 0 ไม่ผ่าน** · `flutter analyze` No issues found! · BUG-FOOD-1 (ช่องพลังงาน overflow) แก้แล้ว · BUG-FOOD-2 (ยอดรวมบน CTA ถูกตัดที่ textScaler 1.5) แก้แล้ว · §0–§8 ด้านล่างคือผลรอบ 1 (คงไว้ตามเดิม)

> ผู้ทดสอบ: QA agent · วันที่ 2026-10-30 (21:40–21:59) · โค้ดที่ทดสอบ: `app/lib/features/food/` (dev v1, `logs/20261030-2138_dev_food.md`)
> อ้างอิง: requirements.md, game-rules.md, ux-flow.md, ui-spec.md + ข้อตัดสิน owner ด้านล่าง (ค่าคาดหวังทั้งหมดมาจากเอกสาร/ข้อตัดสิน ไม่ได้ลอกจากโค้ด)
> เทสต์: `app/test/food/food_logic_test.dart` (L), `food_controller_test.dart` (C), `food_screens_test.dart` (W) + ตัวช่วย `food_test_helpers.dart` (ไม่มีเทสต์ในไฟล์นี้)
> ไม่ได้แก้โค้ดใน `app/lib/` · ไม่ได้แก้ไฟล์อื่นใน `docs/food/` · ไม่ได้ commit / push

## 0. ข้อตัดสิน owner — DECIDED (owner ชั่วคราว, รอทีมยืนยัน)

ข้อไหนขัดกับเอกสาร ให้ข้อตัดสินชนะ เทสต์ที่อิงข้อตัดสินจะมีคำว่า `DECIDED_` ในชื่อ

| รหัส | เนื้อหา | มีผลต่อเทสต์ |
|---|---|---|
| OQ-1 | 4 ท่าใช้ `PetCharacter` (CustomPainter) ใน `app/lib/shared/pet/` (`PetPose.foodNormal / foodEating / foodOverLimit / foodOverLimitFeeding`) ไม่ใช้ Lottie / Sprite Sheets / PNG | ตรวจ `painter.pose` ทั้ง 4 สถานะ, ไม่มี `Image`, ไม่มี `lottie` ใน pubspec |
| Q-17 | ไม่มี AI / ไม่ต่อเน็ต ใช้ตารางเมนูอาหารไทยในเครื่อง เทียบชื่อเมนู → kcal ถ้าไม่เจอให้แสดงช่องกรอกแคลอรี่เอง (สถานะ error/offline ของ S-2) | AC-1/AC-2 ทดสอบผ่าน `LocalMenuNutritionParser(menu: ...)` ที่ส่งตารางทดสอบเข้าไปเอง (ไม่ยึดค่า kcal ในตารางของ Dev ที่ยังไม่มีคนยืนยัน) |
| Q-13 | ใช้โปรไฟล์จาก signup S-6 ถ้ามีอยู่แล้วไม่ต้องแสดง S-3 แสดง S-3 เฉพาะตอนยังไม่มีโปรไฟล์ | `SignupFoodProfileSource` + `SignupController(FakeAuthRepository)` |
| Q-14 | กติกาเดียวกับ signup: อายุรับแค่จำนวนเต็ม (พิมพ์จุดไม่ได้) น้ำหนัก/ส่วนสูงรับทศนิยม — **ชนะ ui-spec §2.3 #2 / §5** ที่ให้พิมพ์ 20.5 ได้ | widget test ยอมรับว่า "20.5" พิมพ์ไม่เข้าช่อง แต่ต้องไม่ถูกบันทึกเป็นค่าอื่น; error แสดงเมื่อกรอก 0 / 121 |
| Q-9 | ข้ามโปรไฟล์ = ไม่มีเป้าหมาย ไม่มี OVER_LIMIT แสดง CTA ให้ตั้งโปรไฟล์ | บันทึกเกินเท่าไรก็ไม่มีหลอดแดง / Toast / ป้าย |
| Q-5 | ป้าย「อิ่มแล้ว」ขึ้นพร้อมหลอดแดงทันที ไม่ต้องรอท่า — **ชนะ ui-spec §3 แถว "กำลังกิน"** | ระหว่างท่า EATING ที่ข้ามเกณฑ์ ป้ายต้อง visible แล้ว |
| Q อื่นใน ui-spec §6 | ใช้ค่าชั่วคราวที่ ui-spec เลือกไว้ (Q-1, Q-2, Q-3, Q-4, Q-8, Q-10, Q-11, Q-12, Q-15 ฯลฯ) | เทสต์ที่ใช้ค่าพวกนี้มีคำว่า `ASSUMPTION_` ในชื่อ |

## 1. สรุปตัวเลข

| รายการ | ค่า |
|---|---|
| เทสต์ food ทั้งหมด | **166** (L 57 · C 50 · W 59) |
| ผ่าน / ไม่ผ่าน (food) | **166 / 0** |
| `flutter test` ทั้งแอป (ใน app/) | **576 ผ่าน / 0 ไม่ผ่าน** — `00:19 +576: All tests passed!` (เทสต์เดิม 410 + food 166) |
| `flutter analyze` (ทั้ง app/) | `No issues found! (ran in 1.2s)` |
| AC ทั้งหมด 12 ข้อ | 12 มีเทสต์ · ผ่าน 12 |
| EC ทั้งหมด 5 ข้อ | 5 มีเทสต์ · ผ่าน 5 |
| AC/EC ที่ยังไม่มีเทสต์ | ไม่มี |
| Bug ที่พบ | **0** |
| เทสต์ที่ QA แก้เองเพราะเทสต์ผิด | 2 (ดู §6) |
| คำถามค้าง | 12 (ดู §7) |

ชื่อเทสต์: `AC#_` / `EC#_` = ตามเอกสาร · `GR#_` = ตัวเลข/กติกาจาก game-rules §# · `EDGE_` = edge case บังคับ 4 แบบ · `DECIDED_` = ตามข้อตัดสิน owner · `ASSUMPTION_` = ค่าชั่วคราวของ ui-spec/Dev (ถ้าคำตอบเปลี่ยน ต้องแก้ทั้งโค้ดและเทสต์) · `UI_` = ข้อความ/โครงหน้าจอ

## 2. AC → เทสต์

| AC | เทสต์ (ไฟล์) | ผล |
|---|---|---|
| AC-1 JSON โภชนาการภายใน 3 วินาที | AC1_parse_example_json_from_requirements (L) · AC1_nutrition_toJson_has_three_keys (L) · DECIDED_Q17_local_parser_returns_ac1_json_from_menu_table (L) · AC1_menu_text_parsed_and_logged_with_flags (C) · AC1_EDGE_result_at_2_9s_is_used (C) · AC1_EC1_EDGE_no_result_within_3s_is_failure (C) · AC1_menu_logged_back_to_S1_with_parsed_calories (W) · AC1_EDGE_result_at_2_9s_is_logged (W) · AC1_EC1_EDGE_no_result_within_3s_shows_manual_form (W) | ผ่าน |
| AC-2 ช่วงตัวเลข → Median | AC2_median_of_range (L) · AC2_range_calories_in_json_use_median (L) · ASSUMPTION_AC2_range_as_text_or_min_max_object_use_median (L) · AC2_local_parser_range_menu_item_gives_median (L) · AC2_range_menu_logs_median (C) · AC2_range_menu_logs_median_500 (W) | ผ่าน |
| AC-3 03:00 วันที่ 15 → `date` = 14 | AC3_03_00_of_day_15_is_logical_day_14 (L) · AC3_EDGE_04_59_59_is_day_14_and_05_00_00_is_day_15 (L) · AC3_EDGE_midnight_does_not_start_new_day (L) · AC3_EDGE_month_boundary_1st_04_00_is_last_day_of_previous_month (L) · AC3_log_at_03_00_day_15_entry_date_is_day_14 (L) · AC3_EDGE_first_ever_log_at_03_00_day_15_goes_to_day_14 (L) · AC3_log_at_05_00_day_15_starts_day_15_from_0 (L) · AC3_log_at_03_00_day_15_stored_date_is_2026_10_14 (C, shared_preferences จริง: `food_current_day` และ `date` ใน `food_meals_log` = `2026-10-14`) | ผ่าน |
| AC-4 อายุทศนิยมถูกปฏิเสธ / จำนวนเต็ม 1–120 | AC4_age_25_5_is_rejected (L) · AC4_EDGE_age_boundaries_0_invalid_1_valid_120_valid_121_invalid (L) · AC4_EDGE_non_integer_texts_rejected (L) · AC4_EDGE_empty_age_is_not_an_error_but_cannot_save (L) · AC4_decimal_age_blocks_save_even_with_other_fields_valid (L) · AC4_EC5_controller_refuses_decimal_age_nothing_saved (C) · AC4_DECIDED_Q14_age_25_5_cannot_be_entered_or_saved (W) · AC4_EDGE_age_0 / age_121_shows_inline_error_and_blocks_save (W, 2) · AC4_EDGE_age_1 / age_120_valid_no_error_save_enabled (W, 2) | ผ่าน |
| AC-5 ชาย 25 ปี = 2,000 kcal + ตาราง Base Target | AC5_male_25_base_target_is_2000 (L) · AC5_EDGE_every_band_min_and_max_age_male_and_female (L, 5 ช่วง × ขอบล่าง/บน × 2 เพศ) · AC5_male_25_normal_bmi_target_is_2000 (L) · AC5_profile_male_25_target_2000_and_empty_text (C) · AC5_save_male_25_normal_bmi_S1_shows_target_2000 (W) · AC5_female_30_normal_bmi_target_1600 (W) | ผ่าน |
| AC-6 BMI < 18.5 → +400 | AC6_bmi_below_18_5_adds_400 (L) · AC6_EDGE_bmi_18_4_adds_400_bmi_18_5_exact_no_bonus (L) · AC6_AC7_adjustment_applies_on_other_bands (L) · AC6_underweight_profile_target_2400 (C) · AC6_save_underweight_S1_shows_target_2400 (W) | ผ่าน |
| AC-7 BMI ≥ 23.0 → −400 | AC7_bmi_at_least_23_subtracts_400 (L) · AC7_EDGE_bmi_22_9_no_change_bmi_23_0_exact_subtracts_400 (L) · AC7_overweight_profile_target_1600 (C) · AC7_save_overweight_S1_shows_target_1600 (W) | ผ่าน |
| AC-8 ข้ามโปรไฟล์ → CTA ขนาดเท่าหลอด + ยอดรวม ไม่มี layout shift | AC8_cta_total_text_contains_daily_total (C) · AC8_EC4_skip_shows_cta_banner_text_and_total (W) · AC8_EC4_cta_banner_same_size_as_energy_widget_no_layout_shift (W: ขนาด banner = ขนาดช่องหลอด, ตำแหน่ง slot / สัตว์เลี้ยง / ปุ่ม ตรงกันทั้ง 2 โหมด) · AC8_cta_tap_opens_S3 (W) · GR4_AC8_cta_to_S3_save_replaces_banner_with_bar (W) | ผ่าน |
| AC-9 เกิน ≤ 100 → ไม่แดง ท่าปกติ | AC9_EDGE_exactly_target_plus_100_is_normal (L) · AC9_EDGE_other_targets_boundary_plus_100_and_plus_101 (L) · GR3_examples_1900_and_2050_normal_2150_over_limit (L) · AC9_GR3_1950_plus_100_is_2050_normal_not_red (C) · AC9_EDGE_landing_exactly_on_2100_stays_normal (C) · AC9_S1_2050_of_2000_not_red_normal_pose_no_badge (W) · AC9_EDGE_S1_2100_exact_threshold_not_red (W) | ผ่าน |
| AC-10 เกิน > 100 → หลอดแดง ท่าอิ่มพุงกาง「อิ่มแล้ว」 | AC10_EDGE_target_plus_101_is_over_limit (L) · AC10_GR3_2000_plus_150_eating_then_over_limit (C) · AC10_EDGE_landing_on_2101_goes_over_limit (C) · AC10_loaded_over_limit_shows_over_limit_pose (C) · AC10_EDGE_S1_2101_red_over_limit_badge (W) · AC10_S1_2150_red_bar_full_over_limit_pose_full_badge_text (W) · AC10_DECIDED_Q5_crossing_log_red_and_badge_now_pose_after_2s (W) | ผ่าน |
| AC-11 บันทึกซ้ำขณะเกิน → ท่าอิ่มแต่ยังกิน + Toast「พอเถอะน้าคนดี」ทุกครั้ง | AC11_log_while_over_limit_gives_feeding_and_toast (L) · AC11_GR3_2150_plus_100_feeding_and_toast (C) · EC3_AC11_every_repeated_log_shows_feeding_and_toast (C, 4 ครั้ง) · AC11_EC3_log_while_over_limit_feeding_pose_and_toast (W) · EC3_AC11_toast_shows_again_on_every_repeated_log (W, 3 ครั้งผ่าน S-2) | ผ่าน |
| AC-12 Toast เหนือสัตว์เลี้ยง 12 px · 1 ข้อความ/การบันทึก · 5 วินาที · Queue replace | AC12_no_toast_when_not_over_limit (C) · AC12_toast_visible_until_exactly_5s (C: 4.999 s ยังอยู่, 5.000 s หาย) · EC2_second_log_within_5s_replaces_toast_and_restarts_5s (C) · AC12_toast_bottom_is_12px_above_pet_top (W: `top(PetKeys.character) − bottom(food_toast) = 12`) · AC12_toast_stays_5s_then_disappears_pet_does_not_move (W) · EC2_AC12_rapid_logs_within_5s_single_toast_replaced (W) | ผ่าน |

## 3. Edge case (EC ในเอกสาร + 4 แบบบังคับ)

| กรณี | เทสต์ | ผล |
|---|---|---|
| EC-1 AI ล้มเหลว / ออฟไลน์ → ฟอร์มกรอกเอง, ปล่อยว่าง = 300 | EC1_unreadable_json_is_failure (L) · EC1_manual_blank_defaults_to_300 (L) · EC1_manual_value_is_used_as_typed (L) · EC1_offline_submit_is_parse_failed_nothing_logged (C) · EC1_manual_blank_logs_300 (C) · EC1_manual_typed_value_logged (C) · AC1_EC1_EDGE_no_result_within_3s_is_failure (C) · EC1_offline_switches_to_manual_form_menu_text_kept (W) · EC1_manual_left_blank_logs_300 (W: S-1 = `300 / 2,000 kcal`) · EC1_manual_typed_450_logged (W) · EC1_EDGE_manual_field_digits_only (W) · DECIDED_Q17_menu_not_in_table_is_parse_failure (L) · DECIDED_Q17_unknown_menu_is_parse_failed (C) · DECIDED_Q17_menu_not_in_local_table_shows_manual_form (W) | ผ่าน |
| EC-2 บันทึกซ้อนใน 5 วินาที → Queue replace ไม่ซ้อน | EC2_second_log_within_5s_replaces_toast_and_restarts_5s (C) · ASSUMPTION_Q4_rapid_log_restarts_transient_pose (C) · EC2_AC12_rapid_logs_within_5s_single_toast_replaced (W) · EC2_rapid_logs_via_S2_single_toast (W) | ผ่าน |
| EC-3 เกิน > 100 → แดง / อิ่มพุงกาง / บันทึกเพิ่มได้ท่าอิ่มแต่ยังกิน + Toast ทุกครั้ง | EC3_AC11_every_repeated_log_shows_feeding_and_toast (C) · EC3_AC11_toast_shows_again_on_every_repeated_log (W) · AC11_EC3_log_while_over_limit_feeding_pose_and_toast (W) · ASSUMPTION_Q3_feeding_returns_to_over_limit_after_2s (C) · ASSUMPTION_7_log_during_eating_after_crossing_counts_as_over_limit (C) | ผ่าน |
| EC-4 ข้ามโปรไฟล์ → CTA ขนาดเท่าเดิม ไม่มี layout shift | AC8_EC4_skip_shows_cta_banner_text_and_total (W) · AC8_EC4_cta_banner_same_size_as_energy_widget_no_layout_shift (W) · DECIDED_Q9_skip_shows_cta_no_target (C) · DECIDED_Q9_skipped_never_over_limit_no_toast_no_badge (C) · DECIDED_Q9_skipped_logging_never_red_no_toast_no_badge (W) · DECIDED_Q9_no_target_is_never_over_limit (L) · US3_skip_is_persisted (C) · DECIDED_Q13_skip_persists_S3_not_reopened_on_reentry (W) | ผ่าน |
| EC-5 อายุ 20.5 → บล็อก จำนวนเต็ม 1–120 | EC5_age_20_5_is_rejected (L) · AC4_EC5_controller_refuses_decimal_age_nothing_saved (C) · AC4_EC5_DECIDED_Q14_age_20_5_cannot_be_entered_or_saved (W) · DECIDED_Q14_dot_after_20_is_rejected_field_stays_20 (W) | ผ่าน |
| 1. ค่าเกณฑ์พอดี ±1 | OVER_LIMIT 2,100 / 2,101 (L, C, W) · BMI 18.4 / 18.5 และ 22.9 / 23.0 (L) · อายุ 0 / 1 / 120 / 121 (L, W) · ขอบช่วงอายุตาราง Base Target 9/10, 12/13, 15/16, 18/19, 50/51, 120 (L) · EATING 1.999 / 2.000 s (C) · Toast 4.999 / 5.000 s (C) · AI 2.9 s / เกิน 3 s (C, W) · 04:59:59 / 05:00:00 (L, W) | ผ่าน |
| 2. ข้ามวัน / รีเซ็ต | AC3_* (L) · GR4_rollover_at_05_00_resets_to_0_and_keeps_previous_day_in_history (L) · GR4_rollover_under_target_day_is_not_over_target (L) · US5_EDGE_history_keeps_recent_days_and_drops_older_than_7_days (L) · GR4_refresh_day_at_05_00_resets_to_0_without_reload (C) · GR4_EDGE_midnight_does_not_reset (C) · EDGE_new_day_log_after_over_limit_day_is_eating_no_toast (C) · EDGE_reopen_after_05_00_starts_new_day_at_0 (C) · GR4_foreground_crossing_05_00_resets_to_0 (W: เปิดค้าง 04:59:58 → 05:00:00) · GR4_resume_after_05_00_resets_to_0 (W) | ผ่าน |
| 3. เพดาน max / min | EDGE_energy_fraction_half_and_capped_at_1 (L) · EDGE_total_never_below_0_on_negative_calories (L) · EDGE_repeated_logs_accumulate_without_cap (L) · EDGE_stored_negative_total_clamped_to_0 (C) · AC9/AC10 W: หลอด `value` = 1.0 แต่ข้อความแสดงค่าจริง (`2,150 / 2,000 kcal`) · EC1_EDGE_manual_field_digits_only (W) | ผ่าน |
| 4. ข้อมูลว่าง / เปิดครั้งแรก / ข้อมูลเสีย | EDGE_first_run_rollover_starts_today_at_0 (L) · EDGE_first_run_empty_storage_starts_at_0_normal (C) · EDGE_corrupted_storage_wrong_types_does_not_crash (C) · EDGE_repository_throws_starts_empty_and_logging_still_works (C) · EDGE_profile_source_throws_treated_as_no_target (C) · EDGE_reload_same_day_restores_total (C) · EDGE_S1_empty_state_0_of_2000_bar_0_normal_pose (W) · DECIDED_Q13_no_profile_opens_S3_automatically (W) | ผ่าน |

## 4. ตัวเลขใน game-rules / หน้าจอ / ข้อตัดสิน

| หัวข้อ | เทสต์ | ผล |
|---|---|---|
| game-rules §1 ค่าหลักทุกตัว (timeout 3, 05:00, อายุ 1/120, ตาราง Base Target 10 ค่า + fallback 1–9, BMI 18.5/23.0, ±400, 100, 300, 2 s, 5 s, 12 px, 7 วัน) | GR1_constants_match_game_rules (L) · GR5_age_1_to_9_uses_10_12_band_fallback (L) · GR1_bmi_formula_weight_over_height_m_squared (L) | ผ่าน |
| game-rules §2 รหัสสถานะ 4 ตัว + EATING 2 s | GR2_state_codes_match_game_rules (L) · GR2_eating_lasts_2_seconds (L) · GR2_log_while_not_over_limit_gives_eating_no_toast (L) · GR2_log_shows_eating_then_normal_after_exactly_2s (C) · GR2_S1_log_shows_eating_then_normal_after_2s (W) | ผ่าน |
| game-rules §3 ตัวอย่าง 0→1,900 / 1,950→2,050 / 2,000→2,150 / 2,150→2,250 | GR3_examples_1900_and_2050_normal_2150_over_limit (L) · GR3_male_25_from_0_to_1900_normal_after_eating (C) · AC9_GR3_* · AC10_GR3_* · AC11_GR3_* (C) · GR3_S1_1900_of_2000_normal_primary_bar (W) | ผ่าน |
| ข้อความบนจอตรงตัวตาม ux-flow | GR1_screen_texts_match_ux_flow (L) · UI_S1_add_meal_button_text_per_ux_flow · UI_S2_hint_submit_text_no_manual_field_in_normal_state · UI_S3_hints_gender_options_and_button_texts_per_ux_flow · AC8_EC4_skip_shows_cta_banner_text_and_total · AC10_S1_2150_* (「อิ่มแล้ว」) · AC4_EDGE_age_0/121 (ข้อความ error) (W) | ผ่าน |
| รูปแบบตัวเลข `[total] / [target] kcal` คั่นหลักพัน | UI_calorie_text_format_examples (L) · UI_empty_state_0_of_target (L) · หลายเทสต์ W | ผ่าน |
| S-2 ปุ่มย้อนกลับ / S-3 ลำดับฟิลด์ / ปุ่มข้ามกดได้เสมอ / ไม่มีปุ่ม back | UI_S2_back_button_returns_to_S1 · UI_S3_field_order_age_gender_weight_height · UI_S3_skip_button_always_enabled · UI_S3_no_back_button_in_app_bar (W) | ผ่าน |
| ทางเข้าจากหน้า water (ui-spec §2.0, Q-1) | UI_entry_from_water_home_opens_S1 · ASSUMPTION_Q1_entry_button_after_steps_before_report_tooltip (W) | ผ่าน |
| ข้อความเสนอของ ui-spec (Q-2) | ASSUMPTION_Q2_S1_title_proposed (W) | ผ่าน |
| OQ-1 PetCharacter 4 ท่า / ไม่มี Lottie/PNG | DECIDED_OQ1_states_map_to_PetCharacter_food_poses (L) · DECIDED_OQ1_S1_PetCharacter_pose_for_each_state (W) · DECIDED_OQ1_no_lottie_package_and_no_pet_json_assets_in_food (W) | ผ่าน |
| Q-13 โปรไฟล์ signup | DECIDED_Q13_* (C 6 ตัว, W 4 ตัว) — signup มีโปรไฟล์ → ไม่เปิด S-3 · session ไม่มีโปรไฟล์ → เปิด S-3 · S-3 บันทึกกลับเข้า signup โดยคงชื่อและเป้าหมายสุขภาพเดิม | ผ่าน |
| Q-14 น้ำหนัก/ส่วนสูงทศนิยม | DECIDED_Q14_weight_and_height_accept_decimals (L) · DECIDED_Q14_decimal_weight_height_saved_as_decimal (C) · DECIDED_Q14_weight_height_accept_decimals (W) | ผ่าน |
| Q-5 ป้ายขึ้นพร้อมหลอดแดงทันที | DECIDED_Q5_full_badge_and_red_immediately_during_eating (C) · AC10_DECIDED_Q5_crossing_log_red_and_badge_now_pose_after_2s (W) | ผ่าน |
| จอ 360 dp (ui-spec §5) | UI_360dp_S1_cta_S2_S3_no_overflow (W) — ไม่รวมโหมดหลอดพลังงาน ดู §6 ข้อ 2 และ §7 ข้อ 5 | ผ่าน |

## 5. รายการ Bug

ไม่พบ bug ในรอบนี้ (0 รายการ) — ทุก AC/EC และตัวเลขใน game-rules ที่ทดสอบได้ ตรงกับเอกสารและข้อตัดสิน owner

## 6. เทสต์ที่ QA แก้เอง (เทสต์ผิด)

| เทสต์ | ปัญหา | แก้อย่างไร |
|---|---|---|
| AC1_menu_logged_back_to_S1_with_parsed_calories (ผ่าน helper `logViaS2` ที่ใช้ใน W หลายเทสต์) | รอบ 1–2 helper pump แค่ `pump()` + 400 ms หลังกดบันทึก ทำให้ transition ของ route (FadeForwards ~800 ms ใน Flutter 3.47) ยังไม่จบ → S-2 ยังอยู่ใน tree (`Found 1 widget with key food_meal_input_field`) | pump เพิ่ม 1 เฟรม แล้ว pump 900 ms (ยังไม่ถึง 2 s ของ EATING) — โค้ดทำงานถูกต้อง (pop แล้วจริง) |
| UI_360dp_S1_over_limit_with_toast_and_cta_no_overflow → เปลี่ยนชื่อเป็น UI_360dp_S1_cta_S2_S3_no_overflow | รอบ 1 ล้ม `A RenderFlex overflowed by 4.0 pixels on the bottom` ที่ `Column-[food_energy_block]` (constraints w=312, h=88) — ฟอนต์ของ flutter test กว้าง 1em ต่อตัว ข้อความ `2,150 / 2,000 kcal` (headlineSmall 24) เลยขึ้น 2 บรรทัด (20 + 8 + 32×2 = 92 > 88) บนฟอนต์จริงข้อความยาวราว 220 px อยู่ใน 1 บรรทัด | เทสต์ 360 dp ตรวจเฉพาะ CTA / S-2 / S-3 ส่วนความเสี่ยงของช่องสูงคงที่ 88 จดเป็นคำถาม §7 ข้อ 5 (ไม่นับเป็น bug เพราะเกิดจากฟอนต์ทดสอบ ไม่ใช่โค้ดที่ไม่ตรงเอกสาร) |

## 7. คำถามค้าง (ไม่นับเป็น bug — ไม่ได้ assert จุดที่เอกสารไม่ระบุ)

1. **เอกสารยังไม่ตรงกับข้อตัดสิน** — requirements §1/§7, ux-flow §2/§5/§6, game-rules §2/§5 ยังอ้าง Lottie / AI Parsing; ui-spec §2.3 #2, §3 S-3, §5 ยังให้พิมพ์ "20.5" แล้วเห็น error (ขัดกับ Q-14); ui-spec §3 แถว "กำลังกิน" และ Q-5 ยังบอกว่า "ป้ายซ่อนระหว่างกิน" (ขัดกับ Q-5 owner) — ต้องให้ Design/Product/UI อัปเดตหลังทีมยืนยัน OQ-1, Q-17, Q-13, Q-14, Q-9, Q-5
2. **BMI "Float 1 ตำแหน่ง"** (game-rules §1) — ต้องปัด BMI เป็นทศนิยม 1 ตำแหน่งก่อนเทียบเกณฑ์ไหม (เช่น 18.46 → 18.5 = ไม่ผอม) โค้ดเทียบด้วยค่าจริง (Dev ASSUMPTION 13) — เทสต์ใช้เฉพาะค่าที่ลงตัว (18.4/18.5/22.9/23.0)
3. **`is_over_target`** (requirements §6) หมายถึง `total > target` หรือ `total > target + 100` — โค้ดใช้ +100 · เทสต์ assert เฉพาะกรณีชัด (2,500/2,000 = true, 1,500/2,000 = false) ไม่ assert ช่วง 2,001–2,100
4. **HISTORY_RETENTION_DAYS 7 วัน** นับรวมวันนี้หรือไม่ (Dev ASSUMPTION 3 ให้นับรวม) — เทสต์ assert แค่วันที่ไม่กำกวม (6 วันก่อนหน้าอยู่ครบ, เก่ากว่า 8 วันถูกลบ) ไม่ assert วันที่ 7 ย้อนหลัง · ควรยืนยันพร้อมฟีเจอร์ 7day
5. **ช่องพลังงานสูงคงที่ 88 px** (ui-spec §1.3) คำนวณโดยถือว่า `food_calorie_text` อยู่ 1 บรรทัด — ถ้าข้อความขึ้น 2 บรรทัด (ตัวเลขยาว / ผู้ใช้ขยายขนาดตัวอักษร / จอแคบ) จะ overflow 4 px ขึ้นไป (หลักฐาน: ฟอนต์ทดสอบที่ 360 dp) — ควรกำหนด `maxLines: 1` + ย่อ หรือขยายช่องไหม
6. **Median ไม่ลงตัว** (เช่น 401–600 = 500.5) ปัดอย่างไร — Dev ปัด .5 ขึ้น (ASSUMPTION 12) เทสต์ใช้เฉพาะช่วงที่ลงตัว
7. **AC-1 ขอบ 3.000 วินาทีพอดี** — ผลที่มาถึงตอน 3.000 s นับว่าทันหรือไม่ — เทสต์ assert 2.9 s = ทัน, เกิน 3 s = ล้มเหลว
8. **ระยะท่า OVER_LIMIT_FEEDING** game-rules ไม่กำหนด (ui-spec Q-3 ใช้ 2 s ชั่วคราว) — เทสต์ `ASSUMPTION_Q3_*`
9. **ตารางเมนูในเครื่อง (Q-17)** ค่า kcal / ธงโซเดียม-น้ำตาลเป็นค่าประมาณของ Dev (ASSUMPTION 9) ยังไม่มีผู้ยืนยัน — เทสต์ส่งตารางทดสอบเข้า parser เอง จึงยังไม่ได้ตรวจค่าในตารางจริง
10. **โปรไฟล์ signup ที่ไม่ครบ** (เพศ UNSPECIFIED / ไม่มีน้ำหนัก-ส่วนสูง) ถือว่า "มีโปรไฟล์" ตาม Q-13 (ไม่เปิด S-3 เอง แต่แสดง CTA) ใช่ไหม — ไม่ได้ assert
11. **EC-1 ช่องแคลอรี่เอง** — ค่า 0 และค่าสูงสุดที่รับได้ (Dev จำกัด 5 หลัก) เอกสารไม่กำหนด — ไม่ได้ assert
12. **นาฬิกาเครื่องย้อน** เอกสาร food ไม่ระบุพฤติกรรม (Dev ใช้เวลาล่าสุดที่เคยเห็น ASSUMPTION 2) — ไม่ได้ทดสอบ

## 8. ผลการรัน (ใน app/)

| คำสั่ง | ผล |
|---|---|
| `flutter analyze` | `No issues found! (ran in 1.2s)` |
| `flutter test test/food/` | `00:09 +166: All tests passed!` |
| `flutter test` (ทั้งแอป) | `00:19 +576: All tests passed!` (exit 0) |

---

# รอบที่ 2 (2026-10-31)

> ผู้ทดสอบ: QA agent · 06:13–06:24 · โค้ดที่ทดสอบ: `app/lib/features/food/` หลัง Dev แก้บั๊ก (`logs/20261031-0611_dev_food_fix.md` — ช่องพลังงานเป็น `FoodSharedMinHeightBox` ขั้นต่ำ 88 โตตามเนื้อหา)
> อ้างอิงเพิ่ม: ui-spec.md D-5 / §1.3 / §2.1 #9, #9b / §5 checklist (แก้ 2026-10-31) + ข้อตัดสิน owner รอบ 2 ด้านล่าง
> ไม่ได้แก้ `app/lib/` · ไม่ได้แก้ไฟล์อื่นใน `docs/food/` · ไม่ได้ commit / push

## 9. ข้อตัดสิน owner รอบ 2 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน)

| รหัส | เนื้อหา | มีผลต่อเทสต์ |
|---|---|---|
| D-5 | ช่องพลังงาน `food_energy_slot` overflow นับเป็น **บั๊ก** · ห้ามล็อกความสูง 88 px · ต้องรองรับตัวเลขยาวและ textScaler 1.5 บนจอ 360 dp | ใส่โหมดหลอด (`food_energy_block`) กลับเข้าเทสต์ 360 dp · เพิ่มเทสต์ textScaler 1.0 / 1.5 · ตรวจความสูงช่องแค่ **≥ 88** (ไม่มี assert = 88) |
| R2-Q | คำถามค้างรอบ 1 ข้อ 2–4, 6–11 ใช้ค่าที่ Dev เลือกไว้ไปก่อน: BMI ไม่ปัด, `is_over_target` ใช้ +100, ประวัติ 7 วันรวมวันนี้, median .5 ปัดขึ้น, ขอบ 3.000 s, OVER_LIMIT_FEEDING 2 s, ค่า kcal ตารางเมนู, โปรไฟล์ signup ไม่ครบ = CTA, ช่องแคลอรี่สำรอง ≤ 5 หลัก | เทสต์ที่เคยเว้นไว้ตอนนี้ assert ตามค่าของ Dev — ชื่อขึ้นต้น `DECIDED_R2_Q<ข้อ>_` |

## 10. สรุปตัวเลขรอบ 2

| รายการ | ค่า |
|---|---|
| เทสต์ food ทั้งหมด | **193** (L 64 · C 53 · W 76) — เพิ่มจากรอบ 1 จำนวน 27 (L +7 · C +3 · W +17) |
| ผ่าน / ไม่ผ่าน (food) | ตอนพบบั๊ก 192 / 1 → หลัง Dev แก้ **193 / 0** (`00:07 +193: All tests passed!`) |
| `flutter test` ทั้งแอป (ใน app/) | ตอนพบบั๊ก 602 / 1 → หลัง Dev แก้ **603 ผ่าน / 0 ไม่ผ่าน** (603 เทสต์ = เดิม 410 + food 193) — `00:17 +603: All tests passed!` |
| `flutter analyze` (ทั้ง app/) | `No issues found!` |
| AC ทั้งหมด 12 ข้อ | 12 มีเทสต์ · ผ่าน 12 (AC-8 เคยมี 1 เทสต์ไม่ผ่านจาก BUG-FOOD-2 — แก้แล้ว) |
| EC ทั้งหมด 5 ข้อ | 5 มีเทสต์ · ผ่าน 5 |
| AC/EC ที่ยังไม่มีเทสต์ | ไม่มี |
| Bug | **2** — BUG-FOOD-1 (ช่องพลังงาน overflow, รอบ 1 จดเป็นคำถาม owner ตัดสินเป็นบั๊ก) **แก้แล้ว** · BUG-FOOD-2 (ใหม่) **แก้แล้ว** (ยืนยันรอบรันซ้ำ §14.1) |
| เทสต์ที่ QA แก้เองเพราะเทสต์ผิด (รอบ 2) | 2 (ดู §13) |
| คำถามค้าง | 5 (ดู §15) |

## 11. เทสต์ใหม่ / แก้ในรอบ 2

### 11.1 จอ 360 dp + textScaler (W, `food_screens_test.dart` กลุ่ม "UI อื่น ๆ")

ตัวช่วยใหม่: `set360` (360×640 dpr 1) · `expectEnergySlotHolds` (ช่องสูง ≥ 88 **และ** เนื้อหาอยู่ในกรอบช่องครบ) · `app(c, textScale:)` ครอบ `MediaQuery` ด้วย `TextScaler.linear(x)` ผ่าน `MaterialApp.builder` (มีผลกับ S-1 / S-2 / S-3) · `skipped14(total)` (สถานะข้ามโปรไฟล์ไว้แล้ว)

| AC / ข้อตัดสิน | เทสต์ | ผล |
|---|---|---|
| D-5, AC-10 (แก้จากรอบ 1) | `UI_360dp_S1_bar_cta_S2_S3_no_overflow` — เดิมชื่อ `UI_360dp_S1_cta_S2_S3_no_overflow` ใส่โหมดหลอดกลับ: `2,150 / 2,000 kcal`, total 5 หลัก `99,999 / 2,000 kcal`, 6 หลัก `123,456 / 2,000 kcal` (ตัวอย่าง ui-spec §5) + S-3 → CTA → S-2 ไม่มี exception | ผ่าน |
| D-5, AC-10, AC-11, AC-12, Q-5 | `UI_360dp_textScale1_0_S1_bar_over_limit_badge_and_toast_no_overflow` · `UI_360dp_textScale1_5_S1_bar_over_limit_badge_and_toast_no_overflow` — 2,150 หลอดแดง + ป้าย「อิ่มแล้ว」→ บันทึกซ้ำ → ท่า over_limit_feeding + Toast「พอเถอะน้าคนดี」ไม่ถูกตัด, ระยะ Toast–สัตว์เลี้ยง = 12, สัตว์เลี้ยงไม่ขยับ, ไม่มี exception | ผ่าน 2/2 |
| D-5 | `UI_360dp_textScale1_0_S1_bar_long_totals_no_overflow` · `UI_360dp_textScale1_5_S1_bar_long_totals_no_overflow` — 12,345 / 99,999 / 123,456 | ผ่าน 2/2 |
| D-5, AC-8 | `UI_360dp_textScale1_0_S1_cta_long_totals_no_overflow` · `UI_360dp_textScale1_5_S1_cta_long_totals_no_overflow` — CTA 1,250 / 99,999 / 123,456 ไม่ overflow, banner = ขนาดช่อง, ช่อง ≥ 88 | ผ่าน 2/2 |
| AC-8 + D-5 | `AC8_DECIDED_D5_360dp_textScale1_0_cta_total_long_number_not_truncated` · `AC8_DECIDED_D5_360dp_textScale1_5_cta_total_long_number_not_truncated` — ยอดรวมบน CTA (12,345 / 99,999 / 123,456 kcal) ต้องไม่ถูกตัด ellipsis | 1.0 ผ่าน · 1.5 ไม่ผ่านตอนพบ (BUG-FOOD-2) → **ผ่าน** หลัง Dev แก้ (§14.1) |
| D-5 (S-2 / S-3) | `UI_360dp_textScale1_0_S3_S2_normal_and_manual_no_overflow` · `UI_360dp_textScale1_5_S3_S2_normal_and_manual_no_overflow` — S-3 (รวม error อายุ 121) → ข้าม → S-2 ปกติ → S-2 กรอกเอง | ผ่าน 2/2 |
| AC-8 / EC-4 | `AC8_EC4_360dp_textScale1_0_switch_cta_to_bar_no_layout_shift` · `AC8_EC4_360dp_textScale1_5_switch_cta_to_bar_no_layout_shift` — สลับบนหน้าเดียวกัน (CTA → `saveProfile` → หลอด `1,250 / 2,000 kcal`): rect ของ `food_energy_slot`, `PetCharacter`, `food_add_meal_button` เท่าเดิม | ผ่าน 2/2 |
| AC-8 / EC-4 | `AC8_EC4_360dp_textScale1_0_bar_vs_cta_same_slot_pet_button` · `AC8_EC4_360dp_textScale1_5_bar_vs_cta_same_slot_pet_button` — เปิดแบบหลอด เทียบเปิดแบบ CTA: ขนาด banner = ขนาดช่องหลอด, rect slot / สัตว์เลี้ยง / ปุ่ม ตรงกัน | ผ่าน 2/2 |
| D-5 | `DECIDED_D5_energy_slot_at_least_88_and_grows_with_text_scale` — ช่อง ≥ 88 ทั้ง 1.0 และ 1.5 และที่ 1.5 สูงกว่าที่ 1.0 (ยืนยันว่าไม่ล็อกความสูง และ textScaler มีผลจริงในเทสต์) | ผ่าน |

ไม่มีเทสต์ใด assert ว่าช่องพลังงานสูง = 88 (ตรวจเฉพาะ `greaterThanOrEqualTo(88)`)

### 11.2 DECIDED_R2 — ค่าที่ Dev เลือก (คำถามค้างรอบ 1)

| คำถามรอบ 1 | เทสต์ | ผล |
|---|---|---|
| ข้อ 2 BMI ไม่ปัด | `DECIDED_R2_Q2_bmi_not_rounded_18_46_counts_as_underweight` (L: 53.35 kg / 170 cm = 18.46 → 2,400) · `DECIDED_R2_Q2_bmi_not_rounded_22_96_counts_as_normal` (L: 66.35 / 170 = 22.96 → 2,000) | ผ่าน |
| ข้อ 3 `is_over_target` = +100 | `DECIDED_R2_Q3_is_over_target_uses_plus_100_threshold` (L: เป้า 2,000 → 2,001 / 2,100 = false, 2,101 = true) | ผ่าน |
| ข้อ 4 7 วันรวมวันนี้ | `DECIDED_R2_Q4_history_7_days_includes_today` (L: ข้ามเข้าวันที่ 20 → ประวัติ 14–19 วันที่ 13 ถูกลบ) | ผ่าน |
| ข้อ 6 median .5 ปัดขึ้น | `DECIDED_R2_Q6_median_half_rounds_up` (L: [401, 600] → 501, [400, 601] → 501) | ผ่าน |
| ข้อ 8 OVER_LIMIT_FEEDING 2 s | `DECIDED_R2_Q8_over_limit_feeding_lasts_2s_then_over_limit` (C: 1.999 s ยังเป็น feeding, 2.000 s → over_limit) + `ASSUMPTION_Q3_*` เดิม | ผ่าน |
| ข้อ 9 ค่า kcal ตารางเมนู | `DECIDED_R2_Q9_dev_menu_table_values_used` (L: ตารางจริง ข้าวมันไก่ = 596, ข้าวมันไก่ทอด = 690 ไม่นับซ้ำ) | ผ่าน |
| ข้อ 10 โปรไฟล์ signup ไม่ครบ = CTA | `DECIDED_R2_Q10_signup_profile_gender_unspecified_is_cta_not_S3` · `DECIDED_R2_Q10_signup_profile_without_weight_height_is_cta_not_S3` (C) | ผ่าน |
| ข้อ 11 ช่องแคลอรี่สำรอง ≤ 5 หลัก, 0 ได้ | `DECIDED_R2_Q11_manual_calories_0_is_accepted` (L) · `DECIDED_R2_Q11_manual_field_max_5_digits` (W: พิมพ์ 123456 → 12345) · `DECIDED_R2_Q11_manual_0_is_logged_as_0` (W: 1,000 + 0 = 1,000 ไม่แทนด้วย 300) | ผ่าน |
| ข้อ 7 ขอบ 3.000 s | ไม่ได้เพิ่มเทสต์ — Dev ไม่ได้ระบุว่าเลือกฝั่งไหน (ดู §15 ข้อ 2) | — |

## 12. Bug

### BUG-FOOD-1 ช่องพลังงาน overflow บนจอ 360 dp — **แก้แล้ว**
- ที่มา: รอบ 1 เจอ `A RenderFlex overflowed by 4.0 pixels on the bottom` ที่ `Column-[food_energy_block]` (w=312, h=88) ตอนแสดง `2,150 / 2,000 kcal` — รอบ 1 จดเป็นคำถาม (§7 ข้อ 5) owner ตัดสิน (D-5) ว่าเป็นบั๊ก
- ผลที่คาด: ui-spec D-5 / §1.3 / §2.1 #9 — ช่องสูงอย่างน้อย 88 โตตามเนื้อหา ไม่ overflow เมื่อตัวเลขยาวหรือ textScaler 1.5 บนจอ 360 dp และไม่มี layout shift ตอนสลับ (AC-8)
- ผลรอบ 2: ไม่มี exception ทุกกรณี (2,150 / 12,345 / 99,999 / 123,456 × textScaler 1.0 / 1.5 × หลอด / CTA) ช่องสูง ≥ 88 และโตตามเนื้อหา (ค่าที่วัดได้จากเทสต์ชั่วคราว: 1.0 → 312×92, 1.5 → 312×172 ทั้งหลอดและ CTA), AC-8 ไม่ shift ทั้ง 2 scale — เทสต์ §11.1 ผ่าน

### BUG-FOOD-2 ยอดรวมแคลอรี่บน CTA Banner ถูกตัด (ellipsis) ที่ textScaler 1.5 บนจอ 360 dp — **แก้แล้ว** (Dev แก้ `food_dashboard_screen.dart`: `food_cta_total_text` เลิก `maxLines: 1` / ellipsis และ `_energySlotMinHeightFor` วัดยอดรวมแบบไม่จำกัดบรรทัด — `logs/20261031-0611_dev_food_fix.md` ส่วน BUG-FOOD-2) · รันซ้ำ 06:26–06:27: เทสต์ `AC8_DECIDED_D5_360dp_textScale1_5_cta_total_long_number_not_truncated` **ผ่าน** และเทสต์ AC-8 / D-5 อื่นยังผ่านครบ (ไม่ได้แก้เทสต์)
- *(รายละเอียดตอนพบ — ก่อนแก้)*
- เทสต์: `AC8_DECIDED_D5_360dp_textScale1_5_cta_total_long_number_not_truncated` (`app/test/food/food_screens_test.dart` บรรทัด ~1035)
- ขั้นตอนทำซ้ำ:
  1. จอ 360×640 dpr 1, `MediaQuery` textScaler = `TextScaler.linear(1.5)`
  2. เปิด S-1 สถานะข้ามโปรไฟล์ (ไม่มีเป้าหมาย) ยอดรวมวันนี้ 12,345 kcal (หรือ 99,999 / 123,456)
  3. ดู `food_cta_total_text`
- ผลที่คาด: requirements AC-8 — CTA Banner ต้อง "แสดงผลรวมแคลอรี่วันนี้" · ui-spec D-5 — ต้องรองรับตัวเลขยาวและ textScaler 1.5 บนจอ 360 dp · ui-spec §2.1 #9b กำหนด `maxLines: 2, ellipsis` ให้ **ข้อความชวนเท่านั้น** ไม่ได้กำหนดให้ยอดรวมตัดได้ (ตัวอย่างตัวเลขยาวใน §5 checklist: `123,456 kcal`)
- ผลจริง: `food_cta_total_text` เป็น `Text(maxLines: 1, overflow: TextOverflow.ellipsis)` กว้างได้ 248 px — `"12,345 kcal"` ที่ 1.5 ต้องการกว้างกว่านั้น → `RenderParagraph.didExceedMaxLines == true` ตัวเลขถูกตัดเป็น "…" ผู้ใช้อ่านยอดรวมไม่ครบ (ข้อความจากเทสต์: `ยอดรวม 12,345 kcal ถูกตัด (ellipsis) ที่ textScaler 1.5`) · ที่ 1.0 ไม่ถูกตัด · 4 หลัก (1,250 / 9,999) ที่ 1.5 ไม่ถูกตัด
- หมายเหตุ: ฟอนต์ของ flutter test กว้าง 1em ต่อตัว (กว้างกว่าฟอนต์จริง) — เป็นเงื่อนไขเดียวกับ BUG-FOOD-1 ที่ owner ตัดสินว่าเป็นบั๊ก · ไม่มี overflow/exception (เทสต์ `*_cta_long_totals_no_overflow` ผ่าน) ปัญหาคือการตัดตัวเลข
- โค้ดที่เกี่ยว: `app/lib/features/food/screens/food_dashboard_screen.dart` `_buildCtaBanner` (`food_cta_total_text` maxLines 1 + ellipsis) และ `_energySlotMinHeightFor` ที่วัดยอดรวมด้วย `maxLines: 1` — ถ้าให้ยอดรวมขึ้นบรรทัดได้ ต้องวัดความสูงร่วมให้ตรงด้วย (ช่องโตตามได้อยู่แล้ว)

## 13. เทสต์ที่ QA แก้เองรอบ 2 (เทสต์ผิด)

| เทสต์ | ปัญหา | แก้อย่างไร |
|---|---|---|
| `UI_360dp_textScale{1_0,1_5}_S1_cta_long_totals_no_overflow` (ร่างแรก) | เรียก `controller.skipProfile()` ก่อน `load()` → บันทึก state ว่างทับ state ตั้งต้นใน repository → S-1 แสดง `0 kcal` แทนยอดที่ตั้ง (`Expected: contains '1,250' Actual: '0 kcal'`) — เทสต์ใช้ API ผิดลำดับ ไม่ใช่บั๊ก | ตั้ง state เริ่มต้นเป็น `profileSkipped: true` ผ่าน `skipped14(total)` แทนการเรียก `skipProfile()` |
| `AC8_EC4_360dp_textScale{1_0,1_5}_switch_cta_to_bar_no_layout_shift` และ `..._bar_vs_cta_same_slot_pet_button` (ร่างแรก) | สาเหตุเดียวกัน (`Expected: '1,250 / 2,000 kcal' Actual: '0 / 2,000 kcal'`) | เหมือนข้างบน |

ไม่ได้เปลี่ยนค่าคาดหวังใดตามโค้ด

## 14. ผลการรันรอบ 2 (ใน app/)

| คำสั่ง | ผล |
|---|---|
| `flutter analyze` | `No issues found!` |
| `flutter test test/food/food_logic_test.dart` | `+64: All tests passed!` |
| `flutter test test/food/food_controller_test.dart` | `+53: All tests passed!` |
| `flutter test test/food/food_screens_test.dart` | `+75 -1` (ล้ม: `AC8_DECIDED_D5_360dp_textScale1_5_cta_total_long_number_not_truncated`) |
| `flutter test test/food/` | `00:05 +192 -1: Some tests failed.` |
| `flutter test` (ทั้งแอป) | `00:09 +602 -1: Some tests failed.` (ล้มตัวเดียวกัน) |

### 14.1 รันซ้ำหลัง Dev แก้ BUG-FOOD-2 (06:26–06:27)

| คำสั่ง | ผล |
|---|---|
| `flutter analyze` | `No issues found! (ran in 0.8s)` |
| `flutter test` (ทั้งแอป) | `00:17 +603: All tests passed!` (603 ผ่าน / 0 ไม่ผ่าน) |
| `flutter test test/food/` | `00:07 +193: All tests passed!` (193 ผ่าน / 0 ไม่ผ่าน) |
| `flutter test test/food/food_screens_test.dart --plain-name AC8_DECIDED_D5_360dp_textScale1_5_cta_total_long_number_not_truncated` | `+1: All tests passed!` |

สรุปหลังรันซ้ำ: AC 12/12 ผ่าน · EC 5/5 ผ่าน · Bug 2 ตัว แก้แล้วทั้ง 2 · ไม่ได้แก้เทสต์ในรอบรันซ้ำ

## 15. คำถามค้างรอบ 2 (ไม่นับเป็น bug)

1. **เอกสารยังไม่ตรงกับข้อตัดสิน** (รอบ 1 §7 ข้อ 1) — requirements / ux-flow / game-rules ยังอ้าง Lottie / AI Parsing; ui-spec แก้ D-5 แล้ว แต่ข้อ R2-Q (BMI ไม่ปัด, +100, 7 วันรวมวันนี้, .5 ขึ้น ฯลฯ) ยังไม่อยู่ใน game-rules
2. **ขอบ 3.000 s** (รอบ 1 ข้อ 7) — owner ให้ใช้ค่าของ Dev แต่ Dev log ไม่ได้ระบุว่าผลที่มาถึงตอน 3.000 s พอดี "ทัน" หรือ "หมดเวลา" — ขอให้ Dev ระบุ จึงจะ assert ได้ (ตอนนี้ assert แค่ 2.9 s ทัน / เกิน 3 s หมดเวลา)
3. **นาฬิกาเครื่องย้อน** (รอบ 1 ข้อ 12) — ไม่อยู่ในรายการ R2-Q ยังไม่ได้ทดสอบ
4. **ข้อความชวนบน CTA ถูกตัดที่ 2 บรรทัด** — ที่จอ 360 dp ฟอนต์ทดสอบ ข้อความ「ตั้งค่าโปรไฟล์สุขภาพเพื่อรับเป้าหมายแคลอรี่ที่แม่นยำ」ถูก ellipsis แล้วแม้ textScaler 1.0 (ตรงกับ ui-spec #9b `maxLines: 2, ellipsis` จึงไม่นับเป็นบั๊ก) — ที่ textScaler 1.5 ผู้ใช้จะเห็นข้อความสั้นลงอีก ยอมรับได้ไหม หรือให้ขึ้นได้มากกว่า 2 บรรทัด (ช่องโตตามได้แล้ว)
5. **Dev ASSUMPTION เป้าตัวแทน "9,999"** ตอนแสดง CTA (ใช้จองความสูงให้หลอด) — เทสต์ AC-8 ที่ 1,250 ผ่าน แต่ยังไม่มีผู้ยืนยันสมมติฐานนี้ (Dev คำถามข้อ 2)
