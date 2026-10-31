# Test report: 7day — ประวัติสุขภาพ 7 วันและสรุปภาพรวมสัปดาห์ (QA รอบที่ 1)

> สรุป: 7day มี 77 เทสต์ **ผ่าน 77 / ไม่ผ่าน 0** · ทั้งแอป **797 ผ่าน / 0 ไม่ผ่าน** · `flutter analyze` No issues found! · **ไม่พบบั๊ก** · AC 6/6 และ EC 5/5 มีเทสต์และผ่าน · เทสต์ food 3 ตัวปรับตาม Q-19 (+1 ใหม่ ดู `docs/food/test-report.md` §16–§18)

> ผู้ทดสอบ: QA agent · วันที่ 2026-10-31 (15:27–15:43) · โค้ดที่ทดสอบ: `app/lib/features/seven_day/` + `seven_day_entry_button` ใน `app/lib/features/water/screens/water_home_screen.dart` + `FoodRules.historyRetentionDays` (dev รอบ 1 `logs/20261031-1521_dev_7day.md`)
> อ้างอิง: requirements.md, game-rules.md, ux-flow.md, ui-spec.md (+ `logs/20261031-1510_ui_7day.md`) และข้อตัดสิน owner ด้านล่าง ค่าคาดหวังทั้งหมดมาจากเอกสารหรือข้อตัดสิน ไม่ได้ลอกจากโค้ด
> เทสต์: `app/test/seven_day/seven_day_logic_test.dart` (L), `seven_day_controller_test.dart` (C), `seven_day_screens_test.dart` (W) + ตัวช่วย `seven_day_test_helpers.dart` (ไม่มีเทสต์ในไฟล์นี้ ใช้ `Sources` / `makeSources` / `FakeTimers` / repository เสียจาก `app/test/dashboard/dashboard_test_helpers.dart` และมี `FakePeriodicTimers` ของตัวเอง)
> ไม่ได้แก้โค้ดใน `app/lib/` · ไม่ได้แก้ไฟล์อื่นใน `docs/` นอกจากไฟล์นี้และ `docs/food/test-report.md` · ไม่ได้ commit / push

## 0. ข้อตัดสิน owner — DECIDED (owner ชั่วคราว, รอทีมยืนยัน)

ถ้าข้อตัดสินขัดกับเอกสาร ให้ถือข้อตัดสิน เทสต์ที่อิงข้อตัดสินจะมีคำว่า `DECIDED_` ในชื่อ

| รอบ | รหัส | เนื้อหา | มีผลต่อเทสต์ |
|---|---|---|---|
| 1 | OQ-01 | Accordion มี animation 250ms (ไม่ใช้ Instant Toggle) | `DECIDED_OQ01_*`: duration = 250 ms, ความสูงกลาง animation อยู่ระหว่างค่าเริ่มกับค่าสุดท้าย, จบที่ 250 ms |
| 1 | OQ-02 | ใช้ข้อมูลในเครื่องเท่านั้น ไม่มี Server Cache ไม่มีสถานะ OFFLINE | EC-5 = ทำงานปกติจากข้อมูลในเครื่อง · ไม่มี UI ออฟไลน์ · ไม่สร้าง `HttpClient` |
| 1 | — | food เก็บประวัติ 30 วัน | เทสต์ food 3 ตัวเปลี่ยน + 1 ใหม่ (`docs/food/test-report.md` §16–§18) |
| 1 | D-4 | นับ 7 วันรวมวันนี้ (Day 0..Day −6) ตัดรอบ 05:00 ตามเวลาเครื่อง | เวลาใช้ `clock` ร่วมของ 3 controller · ขอบ 04:59:59 / 05:00:00 |
| 1 | D-5 | ดึงข้อมูลจาก controller เดิม ห้ามเก็บซ้ำ | S-1 รับ controller ตัวเดียวกับหน้า water · ไม่มี key `shared_preferences` ใหม่ · ไม่ import storage |
| 2 | Q-19 | เก็บ 30 วันเฉพาะ food ส่วน water / steps ไม่ตัดประวัติ | `DECIDED_Q19_water_steps_history_not_pruned_at_30_days` |
| 2 | Q-1 | ปุ่มไอคอนตัวที่ 5 `seven_day_entry_button` (`Icons.history`, tooltip「ประวัติ 7 วัน」) | `DECIDED_Q1_*` |
| 2 | Q-2..Q-20 | ใช้ค่าที่ ui-spec เลือกไว้ | Q-2 ตัวหารรายหมวด · Q-3 EMPTY ซ่อน SUMMARY · Q-4 ข้ามรอบแล้วการ์ดกลับค่าเริ่มต้น · Q-7 ไม่มี coaching กรณีปกติ · Q-8 หมวดไม่มีข้อมูล → 「ไม่มีข้อมูล」 · Q-9 prefix แยกบรรทัด · Q-10 เทียบค่าที่ปัดแล้ว · Q-11 dd/MM/yyyy + เมื่อวาน / ชื่อวันไทย · Q-12 คั่นหลักพัน · Q-14 แถบสรุปตอนพับ · Q-15 พับ/ขยายแต่ละใบอิสระ · Q-16 นับ Day 0 · Q-18 「แคลอรี」/「Overeating」 · Q-20 ใช้ `isOverTarget` ที่เก็บไว้ |
| 3 | A1–A4 | สมมติฐาน dev: (1) Day 0 ยึด `state.day` ของ steps / food (2) 30 วันนับรวมวันนี้ (3) ไม่มี PNG ใช้ไอคอน Material (4) ค่าติดลบนับเป็น 0 | `DECIDED_R3_A1_*`, `DECIDED_R3_A4_*` · food (`docs/food/test-report.md` §17) · EMPTY ใช้ `Icons.inbox_outlined` 48 |

## 1. สรุปตัวเลข

| รายการ | ค่า |
|---|---|
| เทสต์ 7day ทั้งหมด | **77** (L 35 · C 8 · W 34) |
| ผ่าน / ไม่ผ่าน (7day) | **77 / 0** (`00:07 +77: All tests passed!`) |
| เทสต์ food ที่ปรับตามข้อตัดสิน | 3 ตัว + 1 ตัวใหม่ · food ทั้งหมด **194 ผ่าน / 0** |
| `flutter test` ทั้งแอป (ใน app/) | **797 ผ่าน / 0 ไม่ผ่าน** (`00:24 +797: All tests passed!`) = 719 เทสต์เดิม (716 + 3 ตัว food ที่ปรับ) + food ใหม่ 1 + 7day 77 |
| `flutter analyze` (ทั้ง app/) | `No issues found! (ran in 1.4s)` |
| AC ทั้งหมด 6 ข้อ | 6 ข้อมีเทสต์ · ผ่าน 6 |
| EC ทั้งหมด 5 ข้อ | 5 ข้อมีเทสต์ · ผ่าน 5 |
| AC/EC ที่ยังไม่มีเทสต์ | ไม่มี |
| Bug ที่พบ | **0** |
| เทสต์ที่ QA แก้เองเพราะเทสต์ผิด | 3 (ดู §6) |
| คำถามค้าง | 8 (ดู §7) |

ความหมายของชื่อเทสต์: `AC#_` / `EC#_` / `US#_` = ตามเอกสาร · `GR#_` = ตัวเลขจาก game-rules §# · `EDGE_` = edge case บังคับ 4 แบบ · `DECIDED_` = ตามข้อตัดสิน owner · `UI_` = โครงหน้าจอตาม ui-spec

## 2. AC → เทสต์

| AC | เทสต์ (ไฟล์) | ผล |
|---|---|---|
| AC-1 7 การ์ดเรียงจาก Day 0 บนสุด, Day 0 expanded, Day −1..−6 collapsed | AC1_DECIDED_seven_days_day0_is_today_then_back_6_days (L) · AC1_EDGE_day_older_than_day_minus_6_not_in_window (L) · EDGE_cross_month_window_dates (L) · UI_day_titles_today_yesterday_thai_weekday_date_str (L) · AC1_seven_cards_day0_top_expanded_others_collapsed (W: มีการ์ด 0–6 ไม่มีการ์ด 7, ตำแหน่งบนลงล่าง, มี `body_0`, ไม่มี `body_1..6`, `initiallyExpanded` เป็นจริงเฉพาะใบ 0, SUMMARY อยู่เหนือการ์ด) · AC1_titles_today_yesterday_weekday_date (W) · AC1_day0_body_lines_order_and_tags_order (W) · UI_collapsed_summary_and_expanded_past_day_from_history (W) · DECIDED_Q15_cards_toggle_independently (W) · DECIDED_Q1_D5_tap_opens_S1_same_controllers_back_resets (W: ออกจากหน้าแล้วเข้าใหม่ = ค่าเริ่มต้น) | ผ่าน |
| AC-2 วันไม่มีข้อมูล → 「ไม่มีข้อมูล」 และไม่นับเป็นตัวหาร | GR3_row1_water_7_8_9_over_3_days_avg_8_0_not_divided_by_7 (L) · GR3_row2_steps_5000_6000_over_2_days_avg_5500_0 (L) · GR3_row3_AC2_no_record_day_no_data_and_not_counted (L) · DECIDED_Q2_per_category_divisor_days_with_that_category (L) · DECIDED_Q2_steps_record_zero_is_no_record (L) · DECIDED_Q8_category_without_data_shows_no_data_and_no_warning (L) · AC2_GR3_no_data_cards_and_averages_divide_by_recorded_days (W) · AC2_expanded_no_data_day_shows_only_no_data_text (W) | ผ่าน |
| AC-3 ค่าเฉลี่ย Σ/Count ทศนิยม 1 ตำแหน่ง + prefix เมื่อ Count < 7 | AC3_examples_6_5_cups_and_7_240_5_steps (L) · AC3_one_decimal_always_and_food_comma (L) · AC3_EC1_status_normal_7_inconsistent_1_to_6_empty_0 (L) · AC3_EDGE_count_7_no_prefix_count_6_prefix (L) · DECIDED_Q16_day0_counted_only_when_category_above_0 (L) · GR1_1_order_prefix_then_water_then_steps (L) · AC3_AC4_AC5_exact_coaching_prefix_water_steps_separate_lines (W) · AC3_NORMAL_count_7_no_prefix_no_coaching (W) · AC3_INCONSISTENT_count_6_prefix_only (W) | ผ่าน |
| AC-4 น้ำเฉลี่ย < 8.0 → ข้อความตรงตัว `{val}` ทศนิยม 1 ตำแหน่ง | AC4_EDGE_normal_7_days_55_cups_7_9_warns_56_cups_8_0_not (L) · DECIDED_Q10_EDGE_water_7_96_shows_8_0_no_warning_7_94_shows_7_9_warns (L) · AC4_AC5_val_in_warning_equals_average_line (L) · AC3_AC4_AC5_exact_coaching_prefix_water_steps_separate_lines (W) · AC4_EDGE_NORMAL_55_cups_7_9_warns_56_cups_8_0_not (W) | ผ่าน |
| AC-5 ก้าวเฉลี่ย < 8,000 → ข้อความตรงตัว | AC5_EDGE_normal_7_days_55999_steps_7999_9_warns_56000_not (L) · DECIDED_Q10_EDGE_steps_7999_96_shows_8000_0_no_warning (L) · GR3_row2_* (L) · AC3_AC4_AC5_* (W) · AC5_EDGE_NORMAL_55999_steps_7999_9_warns (W) | ผ่าน |
| AC-6 ไม่มีข้อมูลเลย 7 วัน → 「ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้」 | GR3_row4_AC6_all_empty_sum0_count0_empty_status (L) · AC6_EC3_empty_state_text_once_summary_hidden_7_cards (W: ข้อความเจอ 1 ครั้ง, ไม่มี SUMMARY (Q-3), ไอคอน `inbox_outlined` 48, ยังมีการ์ด 7 ใบ, Day 0 ขยายแสดง「ไม่มีข้อมูล」, ไม่มีสัตว์เลี้ยง) | ผ่าน |

## 3. Edge case (EC ในเอกสาร + 4 แบบบังคับ)

| กรณี | เทสต์ | ผล |
|---|---|---|
| EC-1 ข้อมูลไม่ครบ 7 วัน: หารเฉพาะวันที่บันทึก + prefix | EC1_new_user_single_day_inconsistent_avg_from_1_day (L: 1 วัน → prefix, น้ำ 3.0, ก้าว 2,500.0 เรียง 3 บรรทัด) · AC3_EC1_status_* (L) · AC3_INCONSISTENT_count_6_prefix_only (W) | ผ่าน |
| EC-2 วันไม่มีข้อมูล ไม่นำไปรวมใน sum / count | GR3_row1/row3 (L) · AC2_GR3_* (W) | ผ่าน |
| EC-3 ว่างทั้ง 7 วัน | GR3_row4_* (L) · EDGE_first_open_no_data_empty_status (C) · AC6_EC3_* (W) | ผ่าน |
| EC-4 เปิดค้างข้าม 05:00 | US3_EDGE_logical_day_04_59_59_previous_05_00_00_new (L) · EC4_windowKey_changes_with_day0 (L) · EC4_EDGE_04_59_59_keeps_window_05_00_00_shifts_day0 (C) · EC4_timer_interval_is_1_second_and_ticks_repeat (C) · EC4_refreshDay_after_05_00_shifts_without_timer (C) · **EC4_EDGE_04_59_59_to_05_00_00_new_day0_top_expanded_others_collapsed** (W: เปิด 04:59:59 รอบ 30 ต.ค. แล้วกางการ์ด Day −2 → pump 1 s ยังเป็น「วันนี้, 30/10/2026」 → 05:00:00 pump 1 s → การ์ดบนสุด「วันนี้, 31/10/2026」 ขยายและแสดง「ไม่มีข้อมูล」, 「เมื่อวาน, 30/10/2026」 พับแสดง `4,000 ก้าว · 3 แก้ว · 1,200 kcal`, การ์ด 1–6 พับทั้งหมดรวมใบที่เคยกาง (Q-4), key `seven_day_window_2026-10-31`, มี prefix, ไม่มี SnackBar / AlertDialog) · EC4_resume_after_05_00_refreshes (W) | ผ่าน |
| EC-5 ออฟไลน์ (D-2 ข้อมูลในเครื่อง) | DECIDED_OQ02_EC5_no_offline_ui_no_http_client (W: สร้าง `HttpClient` 0 ครั้งใน 3 วินาที, ไม่มีข้อความ ออฟไลน์ / อินเทอร์เน็ต / เครือข่าย / Offline, ไม่มีไอคอน wifi_off / cloud_off, ไม่มี dialog / SnackBar / MaterialBanner) · DECIDED_OQ02_D5_source_has_no_network_storage_or_pet (โค้ด 7day ไม่มี `dart:io` / `http` / `HttpClient` / `connectivity` / `shared_preferences` / `shared/pet`) · EC5_EDGE_corrupt_storage_all_three_no_crash_empty (C) · EDGE_EC5_corrupt_storage_shows_empty_no_crash (W) | ผ่าน |
| 1. ค่าเกณฑ์พอดี / เกิน 1 หน่วย | น้ำ 56 / 7 = 8.0 ไม่เตือน, 55 / 7 → 7.9 เตือน (L, W) · ก้าว 56,000 / 7 = 8,000.0 ไม่เตือน, 55,999 / 7 → 7,999.9 เตือน (L, W) · Q-10: 7.96 → `8.0` ไม่เตือน, 7.94 → `7.9` เตือน, 7,999.96 → `8,000.0` ไม่เตือน, 7,999.94 → `7,999.9` เตือน (L — ดู §7 ข้อ 1) · Count 7 ไม่มี prefix / 6 มี prefix (L, W) · Overeating 2,100 ไม่มีป้าย / 2,101 มีป้าย (L, W) · 04:59:59 / 05:00:00 (L, C, W) | ผ่าน |
| 2. ข้ามวัน / รีเซ็ต | EC-4 ข้างบน · EDGE_cross_month_window_dates (L: Day 0 = 2 พ.ย. → Day −6 = 27 ต.ค.) · resume (W) · food 30 วัน 04:59:59 / 05:00:00 (`DECIDED_Q19_EDGE_day_30_back_kept_day_31_dropped_rolling`) | ผ่าน |
| 3. ค่าติดเพดาน max / min | DECIDED_R3_A4_EDGE_negative_values_count_as_0 (L: น้ำ −3, ก้าว −500, kcal −10 → 0 และไม่นับเป็นวันที่บันทึก) · EDGE_max_count_never_above_7_with_30_days_of_data (L: ข้อมูล 30 วัน → การ์ด 7 ใบ, count 7) · AC1_EDGE_day_older_than_day_minus_6_not_in_window (L) · ตัวเลขยาว 123,456 / 99 / 12,345 (W 360 dp) | ผ่าน |
| 4. ข้อมูลว่าง / เปิดแอปครั้งแรก / ข้อมูลเสีย | EDGE_first_open_no_state_day_uses_logical_day_and_empty (L) · EDGE_first_open_no_data_empty_status (C) · EC5_EDGE_corrupt_storage_all_three_no_crash_empty (C: repository ทั้ง 3 ตัว throw) · EDGE_EC5_corrupt_storage_shows_empty_no_crash (W) · UI_loading_shows_only_progress_indicator (W) | ผ่าน |

## 4. ตัวเลขใน game-rules / หน้าจอ / ข้อตัดสิน

| หัวข้อ | เทสต์ | ผล |
|---|---|---|
| game-rules §1 (7, 5, 8.0, 8000.0, 30) + 250 ms, 1 s, 48 | GR1_constants_match_game_rules_and_decisions (L) | ผ่าน |
| game-rules §1.1 ข้อความตรงตัว (prefix, น้ำต่ำ, ก้าวต่ำ, empty, ไม่มีข้อมูล — ไม่มี `"` ครอบ) | GR1_1_coaching_texts_exact (L) · AC3_AC4_AC5_exact_coaching_* (W: เทียบสตริงเต็มของน้ำ 6.5 และก้าว 7,240.5) · AC6_EC3_* (W) · AC2_* (W) | ผ่าน |
| §1.1 หมายเหตุ: prefix → น้ำ → ก้าว คนละบรรทัด | GR1_1_order_prefix_then_water_then_steps (L) · AC3_AC4_AC5_* (W: เป็น `Text` 3 ตัว, ขอบล่างของบรรทัดบน ≤ ขอบบนของบรรทัดล่าง, อยู่ใน SUMMARY_CARD ใต้ค่าเฉลี่ย) | ผ่าน |
| §3 แถว 1: น้ำ 7.0 / 8.0 / 9.0 → 8.0 | GR3_row1_* (L) · AC2_GR3_* (W: `ค่าเฉลี่ยการดื่มน้ำ: 8.0 แก้ว` ไม่มีบรรทัดเตือนน้ำ) | ผ่าน |
| §3 แถว 2: ก้าว 5000 / 6000 → 5500.0 | GR3_row2_* (L) · AC2_GR3_* (W: `ค่าเฉลี่ยการเดิน: 5,500.0 ก้าว` + 「เดินเฉลี่ยวันละ 5,500.0 ก้าว …」) | ผ่าน |
| §3 แถว 3: null → 「ไม่มีข้อมูล」 ไม่นับ | GR3_row3_* (L) · AC2_* (W) | ผ่าน |
| §3 แถว 4: Sum 0 Count 0 → ข้อความว่าง | GR3_row4_* (L) · AC6_EC3_* (W) | ผ่าน |
| AC-3 ตัวอย่าง 6.5 แก้ว / 7,240.5 ก้าว · ui-spec 1,850.0 kcal | AC3_examples_* (L) · AC3_one_decimal_* (L) · AC3_AC4_AC5_* (W) | ผ่าน |
| สถานะ NORMAL (count = 7) / INCONSISTENT (0 < count < 7) / EMPTY (count = 0) | AC3_EC1_status_* (L) · AC3_EDGE_count_7_no_prefix_count_6_prefix (L) · AC3_NORMAL_* / AC3_INCONSISTENT_* / AC6_EC3_* (W) | ผ่าน |
| ux-flow §2 DAY_CARD: หัวการ์ด, บรรทัด การเดิน → การดื่มน้ำ → แคลอรี, ป้าย | AC1_titles_* · AC1_day0_body_lines_order_and_tags_order · UI_no_tags_no_wrap_* · UI_collapsed_summary_* (W) · UI_tags_day0_meals_and_over_limit_past_from_record (L) | ผ่าน |
| OQ-01 Accordion 250 ms | DECIDED_OQ01_animation_style_250ms_all_cards · DECIDED_OQ01_expand_animates_over_250ms_not_instant (ที่ 125 ms ความสูงอยู่ระหว่างค่าเริ่มกับค่าสุดท้าย และไม่เปลี่ยนแล้วหลัง 250 ms) · DECIDED_OQ01_collapse_day0_after_250ms_body_gone (W) | ผ่าน |
| D-5 ใช้ controller เดิม ไม่เก็บซ้ำ | DECIDED_D5_* (L, C) · DECIDED_Q1_D5_tap_opens_S1_same_controllers_back_resets (W: `logWater()` บน controller ของหน้า water แล้ว S-1 เปลี่ยน 3 → 4 แก้วทันที) · DECIDED_D5_no_new_shared_preferences_keys (W) | ผ่าน |
| Q-1 ทางเข้า | DECIDED_Q1_entry_button_icon_tooltip_position (W: เป็น `IconButton`, `Icons.history`, tooltip「ประวัติ 7 วัน」, ไม่มีข้อความบนปุ่ม, ลำดับ steps → food → dashboard → seven_day → report) | ผ่าน |
| AppBar หน้า water 5 ปุ่มที่ 360 dp | DECIDED_Q1_water_appbar_5_buttons_360_scale_1.0_no_overflow · …_1.5_no_overflow (W: ไม่มี error ของ AppBar / NavigationToolbar, ปุ่มทั้ง 5 อยู่ใน 0–360) | ผ่าน 2/2 |
| จอ 360×640 textScaler 1.0 / 1.5 | UI_360_scale_{1.0,1.5}_NORMAL_long_numbers_3_tags_all_expanded_no_overflow (`123,456 ก้าว · 99 แก้ว · 12,345 kcal`, ป้ายครบ 3 ทุกใบ, ขยายครบ 7 ใบ, ป้ายอยู่ใน 0–360, ไม่ถูกตัด, ยืนยันว่า textScaler เท่ากับ 1.5 จริง) · UI_360_scale_{1.0,1.5}_INCONSISTENT_3_coaching_lines_full (coaching 3 บรรทัดไม่ถูกตัด, ไม่มี `maxLines`) · UI_360_scale_{1.0,1.5}_EMPTY_no_overflow (W) | ผ่าน 6/6 |
| Timer ตรวจรอบวันถูก cancel | UI_dispose_cancels_day_timer (C) · W ทุกตัวไม่มี "Timer still pending" | ผ่าน |
| Q-19 water / steps ไม่ตัดประวัติ | DECIDED_Q19_water_steps_history_not_pruned_at_30_days (L: record 1 ก.ย. ยังอยู่หลังบันทึก / ข้ามรอบ) | ผ่าน |
| เทสต์เดิม (signup, water, steps, food, dashboard, pet) ไม่กระทบ | `flutter test` ทั้งแอป 797 ผ่าน | ผ่าน |

## 5. รายการ Bug

**ไม่พบ** — โค้ดตรงกับเอกสารและข้อตัดสินในทุกจุดที่ทดสอบ

## 6. เทสต์ที่ QA แก้เอง (เทสต์ผิด)

| เทสต์ | ปัญหา | แก้อย่างไร |
|---|---|---|
| DECIDED_OQ01_collapse_day0_after_250ms_body_gone | ร่างแรกคาดว่า body ของการ์ดหายจาก tree ด้วย `pump()` ที่ไม่เดินเวลาหลัง 250 ms แต่ `ExpansionTile` (maintainState: false) ถอด body ออกในเฟรมถัดไปที่เวลาเดินหลัง animation จบ ตรวจด้วยเทสต์ชั่วคราวแล้ว: ความสูงถึงค่าสุดท้ายที่ 250 ms พอดี (164 → 101 ที่ 125 ms → 72 ที่ 250 ms) จึงไม่ใช่บั๊ก | หลัง 250 ms ให้ `pump(16 ms)` แล้วจึงตรวจว่า body หาย · เพิ่มการตรวจความสูง (กลาง animation < ความสูงตอนเปิด, > ความสูงที่ 250 ms, ความสูงไม่เปลี่ยนแล้วหลัง 250 ms) |
| DECIDED_Q15_cards_toggle_independently | สาเหตุเดียวกัน (ตัวช่วย `toggle` ใช้ `pump()` ที่ไม่เดินเวลา) → การ์ดที่เพิ่งพับยังถูกนับว่าขยาย | ตัวช่วย `toggle` ใช้ `pump(250 ms)` + `pump(16 ms)` |
| DECIDED_OQ02_D5_source_has_no_network_storage_or_pet | ร่างแรกค้นคำในไฟล์ทั้งไฟล์ เลยเจอคำว่า `shared_preferences` ในคอมเมนต์ของ `seven_day_logic.dart` ("ไม่อ่าน shared_preferences เอง") ซึ่งไม่ใช่การใช้งานจริง | ค้นเฉพาะบรรทัดที่เป็นโค้ด (ข้ามบรรทัดที่ขึ้นต้นด้วย `//`) |

ไม่ได้เปลี่ยนค่าคาดหวังใดให้ตรงกับโค้ด

## 7. คำถามค้าง (ไม่นับเป็น bug — ไม่ได้ assert จุดที่เอกสารไม่ระบุ)

1. **Q-10 ค่า 7.96 / 7,999.96 เกิดจากข้อมูลจริงไม่ได้**: แก้วและก้าวเป็นจำนวนเต็ม และตัวหารมีได้ไม่เกิน 7 เศษทศนิยมจึงเป็นได้แค่ k/n (n ≤ 7) ไม่มีทางได้ ≥ .95 ที่ทำให้ปัดขึ้นถึงเกณฑ์ เทสต์ 7.96 → `8.0` ไม่เตือน, 7.94 → `7.9` เตือน, 7,999.96 → `8,000.0` ไม่เตือน จึงทดสอบได้แค่ระดับ logic (`formatAverage` / `isLowWater` / `isLowSteps`) ส่วนบนจอทดสอบขอบที่เกิดขึ้นได้จริง (55 / 56 แก้ว, 55,999 / 56,000 ก้าว) ถ้าในอนาคตน้ำเป็น Float ตาม requirements §6 จะต้องทดสอบ Q-10 บนจอเพิ่ม
2. **เอกสารยังไม่ได้อัปเดตตามข้อตัดสิน**: requirements §6 / ux-flow §3 ข้อ 3 ยังเขียน "Server Cache", ux-flow §4 ยังมีแถว OFFLINE, US-3 / game-rules ยังเขียน ICT (D-4 = เวลาเครื่อง), ux-flow §5 ยังอ้าง PNG 4 ไฟล์ที่ไม่มีอยู่จริง (R3 ข้อ 3), requirements §6 ระบุ Water เป็น Float แต่โค้ดเก็บเป็น int (Q-13)
3. **ux-flow §3 ข้อ 5 「Collapsed = false」** น่าจะพิมพ์ผิด (Q-17) — เทสต์ยึด AC-1 ที่เขียนว่า `expanded = false`
4. **ไม่มีข้อความ coaching สำหรับกรณีปกติ** (Q-7) — ถ้าเป็น INCONSISTENT แต่ไม่เข้าเกณฑ์เตือนจะเหลือแค่ prefix ที่ลงท้ายด้วย "..." เฉย ๆ เทสต์ assert ตามที่ ui-spec เลือก แต่ในมุม UX ยังค้างอยู่
5. **ป้าย Overeating ของ Day 0** ใช้เงื่อนไข `> target + 100` (ui-spec §2.2 = หลอดแดงของ food) ขณะที่ brief / requirements ไม่ได้นิยามเกณฑ์ Overeating ของ 7day ไว้เอง เทสต์ assert ตาม ui-spec (2,100 ไม่มีป้าย / 2,101 มีป้าย)
6. **ทางเข้าปุ่มที่ 6 ในอนาคต** (Q-1) — ที่ 360 dp ตอนนี้มีปุ่มไอคอน 5 ปุ่มแล้ว ถ้ามีฟีเจอร์ต่อไปต้องเลือกทาง (ก) / (ข) ตาม ui-spec Q-1
7. **body หน้า water ล้นแนวตั้งราว 68 px ที่ textScaler 1.5** (ปัญหาเดิม — dashboard test-report §8) — เทสต์ AppBar 5 ปุ่มกรองเฉพาะ error ของ AppBar / NavigationToolbar ตามแบบเทสต์ dashboard ส่วนเทสต์ 360 dp ของ S-1 เปิด S-1 ตรง ๆ จึงไม่ติด error นี้
8. **Day 0 ยึด `state.day` ของ steps / food** (R3 A1) — ถ้า controller ตัวหนึ่ง rollover ก่อนอีกตัวในช่วงเสี้ยววินาที เทสต์ยืนยันแค่ว่าใช้วันล่าสุดของทั้งสองตัว ไม่ได้ทดสอบกรณีนาฬิกาเครื่องย้อนกลับ เพราะเอกสาร 7day ไม่ได้ระบุ

## 8. ผลการรัน (ใน app/)

| เวลา | คำสั่ง | ผล |
|---|---|---|
| 15:31 | `flutter test test/food/food_logic_test.dart` | `+65: All tests passed!` |
| 15:31–15:40* | `flutter test test/seven_day/seven_day_logic_test.dart` | `+34: All tests passed!` |
| 15:31–15:40* | `flutter test test/seven_day/seven_day_controller_test.dart` | `+8: All tests passed!` |
| 15:31–15:40* | `flutter test test/seven_day/seven_day_screens_test.dart` (ร่างแรก) | `+31 -3: Some tests failed.` (เป็นเทสต์ผิดทั้ง 3 ตัว — §6) |
| 15:31–15:40* | (เทสต์ชั่วคราว `tmp_debug_test.dart` 2 รอบ วัดเวลาการพับ — ลบไฟล์แล้ว) | — |
| 15:31–15:40* | `flutter test test/seven_day/seven_day_screens_test.dart` | โหลดไม่ผ่าน (string literal ที่สคริปต์แก้ไฟล์ทำพัง — แก้แล้ว) |
| 15:31–15:40* | `flutter test test/seven_day/seven_day_screens_test.dart` | `+34: All tests passed!` |
| 15:40 | `flutter analyze` | `No issues found! (ran in 1.5s)` |
| 15:40 | `flutter test` (ทั้งแอป) | `00:25 +796: All tests passed!` |
| 15:40 | `flutter test test/seven_day` / `test/food` | `+76` / `+194: All tests passed!` |
| 15:41 | `flutter test test/seven_day/seven_day_logic_test.dart` (เพิ่ม Q-19 water/steps) | `+35: All tests passed!` |
| 15:42 | `flutter analyze` | `No issues found! (ran in 1.4s)` |
| 15:42 | `flutter test` (ทั้งแอป) — **ผลสุดท้าย** | `00:24 +797: All tests passed!` |
| 15:42 | `flutter test test/seven_day` | `00:07 +77: All tests passed!` |

\* ไม่ได้จดเวลาแยกของแต่ละรอบในช่วงนี้ — ลำดับตามตารางคือลำดับที่รันจริง
