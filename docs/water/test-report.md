# Test report: บันทึกการกินน้ำ (water)

> ผู้ทดสอบ: QA agent · วันที่ 2026-10-08 · branch "don't-fuck-my-Branch.-Bitch!!!!!" · โค้ดที่ทดสอบ: commit aaa9b44
> เอกสารอ้างอิง: requirements.md, game-rules.md, ux-flow.md (ฉบับ commit 82c3d21) + คำตัดสินทีม 2026-10-08
> คำสั่ง: `flutter test test/water` (รันใน app/) · Flutter 3.47.6

## สรุปตัวเลข

| รายการ | ค่า |
|---|---|
| จำนวนเทสต์ทั้งหมด | 67 (unit logic 35 · unit controller/storage 15 · widget 17) |
| ผ่าน | 67 |
| ไม่ผ่าน | 0 |
| AC ทั้งหมด / ผ่าน / ไม่ผ่าน | 6 / 6 / 0 |
| EC (requirements §5) ทั้งหมด / ผ่าน | 3 / 3 |
| AC ที่ยังไม่มีเทสต์ | ไม่มี |
| Bug ที่พบ | 0 |
| `flutter analyze test/water` | No issues found |

ไฟล์เทสต์:
- app/test/water/water_logic_test.dart
- app/test/water/water_controller_test.dart
- app/test/water/water_screens_test.dart

## ตาราง AC → เทสต์

| AC | ชื่อเทสต์ | ผล |
|---|---|---|
| AC-1 | AC1_first_log_of_day_0_to_1_cup_12_5_percent | ผ่าน |
| AC-1 | AC1_energy_formula_cups_x_12_5_for_0_to_8_cups | ผ่าน |
| AC-1 | AC1_each_successful_log_adds_exactly_1_cup_and_12_5_percent | ผ่าน |
| AC-1 | AC1_controller_log_adds_1_cup_and_12_5_percent | ผ่าน |
| AC-1 | AC1_S1_tap_plus_shows_1_cup_and_12_5_percent (widget) | ผ่าน |
| AC-2 | AC2_3_cups_critical_then_4_cups_tired_immediately | ผ่าน |
| AC-2 | AC2_mood_images_match_game_rules_section_2 | ผ่าน |
| AC-2 | AC2_S1_3_to_4_cups_status_changes_critical_to_tired (widget) | ผ่าน |
| AC-3 | AC3_log_10_00_then_10_03_is_blocked_and_cups_unchanged | ผ่าน |
| AC-3 / AC-4 | AC3_AC4_controller_blocks_10_03_allows_10_05 | ผ่าน |
| AC-3 | AC3_S1_tap_within_5_min_shows_toast_and_count_unchanged (widget) | ผ่าน |
| AC-3 | AC3_S1_toast_disappears_after_2_seconds (widget, คำตัดสินทีม) | ผ่าน |
| AC-4 | AC4_log_10_00_then_10_05_is_allowed_and_last_log_is_10_05 | ผ่าน |
| AC-4 | AC4_S1_tap_after_5_min_logs_successfully (widget) | ผ่าน |
| AC-5 | AC5_5_cups_at_04_59_stay_5_then_reset_to_0_at_05_00 | ผ่าน |
| AC-5 | AC5_controller_refresh_at_05_00_resets_to_0 | ผ่าน |
| AC-5 | AC5_S1_open_app_after_05_00_shows_0_cups_0_percent (widget) | ผ่าน |
| AC-5 | AC5_S1_open_at_04_59_still_shows_5_cups (widget) | ผ่าน |
| AC-5 | AC5_S1_app_left_open_across_05_00_resets_on_screen (widget) | ผ่าน |
| AC-6 | AC6_average_5_and_4_over_2_logged_days_is_4_5 | ผ่าน |
| AC-6 | AC6_days_without_logs_are_not_in_divisor (คำตัดสินทีม) | ผ่าน |
| AC-6 | AC6_average_one_decimal_13_over_3_is_4_3 | ผ่าน |
| AC-6 | AC6_average_one_decimal_20_over_3_is_6_7 | ผ่าน |
| AC-6 | AC6_whole_number_average_shows_one_decimal_8_0 | ผ่าน |
| AC-6 | AC6_other_months_are_excluded | ผ่าน |
| AC-6 | AC6_history_list_has_date_and_cups_per_day_sorted | ผ่าน |
| AC-6 | AC6_S2_average_4_5_and_daily_history_list (widget) | ผ่าน |
| EC-1 | EC1_12_cups_bar_stops_at_100_but_count_is_12 | ผ่าน |
| EC-1 | EC1_S1_12_cups_bar_full_100_but_count_12 (widget) | ผ่าน |
| EC-2 | EC2_device_off_overnight_across_05_00_resets_on_open | ผ่าน |
| EC-2 | EC2_device_off_several_days_resets_on_open | ผ่าน |
| EC-2 | EC2_controller_load_after_05_00_resets_and_saves_0 | ผ่าน |
| EC-2 | EC2_storage_reopen_next_day_after_05_00_shows_0 | ผ่าน |
| EC-3 | EC3_rapid_taps_only_first_is_logged | ผ่าน |
| EC-3 | EC3_controller_rapid_taps_without_await_log_only_once | ผ่าน |
| EC-3 | EC3_S1_rapid_double_tap_logs_once_and_shows_toast (widget) | ผ่าน |

## Edge case เสี่ยง 4 แบบ

| แบบ | ชื่อเทสต์ | ผล |
|---|---|---|
| 1 ค่าเกณฑ์พอดี (สถานะ 3/4, 6/7) | EDGE_threshold_0_and_3_critical_4_tired · EDGE_threshold_6_tired_7_happy_8_happy · EDGE_S1_6_to_7_cups_status_changes_tired_to_happy (widget) | ผ่าน |
| 1 ค่าเกณฑ์พอดี (Anti-Spam 5 นาที) | EDGE_threshold_4m59s_blocked_5m00s_allowed_6m_allowed · EDGE_blocked_attempt_does_not_restart_5_minute_window | ผ่าน |
| 2 ข้ามวัน/รีเซ็ต (เที่ยงคืนไม่ใช่เวลารีเซ็ต) | EDGE_midnight_is_not_reset_boundary · EDGE_log_23_58_then_00_01_blocked_00_03_counts_on_same_day | ผ่าน |
| 2 ข้ามวัน/รีเซ็ต (หลังรีเซ็ต) | EDGE_after_05_00_reset_first_log_starts_from_1_cup · EDGE_reset_keeps_previous_day_in_history | ผ่าน |
| 2 Anti-Spam ข้าม 05:00 (คำตัดสินทีม, game-rules §4) | EDGE_antispam_across_05_00_log_04_58_tap_05_01_blocked · EDGE_antispam_across_05_00_05_02_59_blocked_05_03_allowed · EDGE_antispam_across_05_00_survives_app_restart · EDGE_S1_log_04_58_tap_05_01_shows_toast_after_reset (widget) | ผ่าน |
| 3 เพดาน max/min | EDGE_cap_8_cups_exactly_100_and_9_cups_still_100 · EDGE_count_keeps_increasing_past_cap_9_to_10 · EDGE_min_0_cups_is_0_percent_never_negative · EDGE_negative_stored_count_clamped_to_0 | ผ่าน |
| 4 เปิดแอปครั้งแรก/ข้อมูลว่าง | EDGE_first_open_initial_state_0_cups_0_percent_critical · EDGE_first_ever_log_is_allowed_without_previous_timestamp · EDGE_first_open_empty_storage_0_cups_critical · EDGE_S1_first_open_shows_0_cups_0_percent_critical (widget) · EDGE_empty_history_average_0_0_and_empty · EDGE_S2_empty_history_shows_empty_text_and_0_0 (widget) | ผ่าน |
| 4 ข้อมูลเสีย/หาย | EDGE_corrupted_history_json_does_not_crash_starts_fresh · EDGE_corrupted_history_item_missing_fields_starts_fresh · EDGE_corrupted_timestamp_treated_as_never_logged · EDGE_missing_count_key_defaults_to_0 | ผ่าน |

## เทสต์อื่น (UI ตาม ux-flow.md / Local Storage ตาม requirements §7)

| ชื่อเทสต์ | ผล |
|---|---|
| UI_S1_button_label_and_plus_icon_per_ux_flow (ปุ่ม "ดื่มน้ำ 1 แก้ว" + ไอคอน "+", ปุ่ม "รายงานรายเดือน") | ผ่าน |
| UI_S2_open_from_S1_shows_header_and_back_returns (หัวข้อ "รายงานการดื่มน้ำประจำเดือน", ปุ่ม "ย้อนกลับ" กลับ S-1) | ผ่าน |
| STORAGE_save_uses_keys_from_requirements_section_7 | ผ่าน |
| STORAGE_data_survives_reopen_same_day | ผ่าน |

## รายการ bug

ไม่พบ bug ในรอบนี้

## เทสต์ที่ QA แก้เองเพราะเทสต์ผิด

ไม่มี (ก่อนรันรอบแรกได้ลบโค้ดเศษที่ไม่ได้ใช้ออกจาก AC3_S1_toast_disappears_after_2_seconds — ยังไม่เคยรัน จึงไม่นับเป็นการแก้เทสต์ที่ผิด)

## คำถามถึงเอกสาร (ไม่นับเป็น bug)

1. **Toast "หายเองใน 2 วินาที" นับจากตอนไหน** (game-rules §4) — โค้ดใช้ SnackBar duration 2 วินาที ซึ่งนับหลังแอนิเมชันเข้าเสร็จ เทสต์ยืนยันว่า Toast ยังอยู่ที่ 1.9 วินาที และหายหลังครบ 2 วินาทีบวกแอนิเมชันออก ถ้านับตั้งแต่กดปุ่ม ช่วงที่เห็นบนจอทั้งหมดจะประมาณ 2.5 วินาที (แอนิเมชันเข้า/ออกของ Flutter อย่างละประมาณ 250 ms) ขอให้ทีมยืนยันว่านับแบบนี้ได้หรือไม่
2. **"เดือนนี้" ของรายงาน** (AC-6) — เอกสารไม่ได้ระบุว่าช่วง 00:00-04:59 ของวันที่ 1 นับเป็นเดือนไหน Dev ใช้รอบวัน 05:00 (ASSUMPTION) จึงยังไม่ได้เทสต์กรณีนี้
3. **นาฬิกาเครื่องถูกตั้งย้อน** — เอกสารไม่ได้กำหนด Dev ให้ไม่รีเซ็ตและอนุญาตให้บันทึก (ASSUMPTION) จึงยังไม่ได้เทสต์
4. **ข้อมูลในเครื่องเสียแบบชนิดข้อมูลผิด** (เช่น daily_water_count เก็บเป็นข้อความ) — เอกสารไม่ได้กำหนดผลที่คาด จึงยังไม่ได้เทสต์ ส่วนที่เทสต์แล้วคือ JSON ประวัติเสีย, timestamp เสีย, key หาย และค่าติดลบ
5. **ภาพสัตว์เลี้ยง** (ux-flow §5) — ไฟล์ assets/images/*.png ยังไม่มีใน repo (Dev ASSUMPTION 6) เทสต์จึงตรวจได้แค่ path ของภาพใน logic และ key ของ widget ภาพตามสถานะ ยังตรวจภาพจริงไม่ได้
6. **รูปแบบวันที่ในรายการประวัติ** — เอกสารไม่ได้กำหนด (Dev ใช้ yyyy-MM-dd) เทสต์จึงตรวจแค่จำนวนแก้วของแต่ละวันและจำนวนรายการ
