# Test report: บันทึกการกินน้ำ (water)

> ผู้ทดสอบ: QA agent · รอบ QA v3 · วันที่ 2026-10-08 · branch "don't-fuck-my-Branch.-Bitch!!!!!" · โค้ดที่ทดสอบ: commit 456661a + ไฟล์ PNG ที่ยังไม่ commit (app/assets/images/pet_critical.png, pet_tired.png, pet_happy.png สร้างจาก tools/gen_pet_images.py)
> เอกสารอ้างอิง: requirements.md, game-rules.md, ux-flow.md (ฉบับ commit e64adff) + ข้อตัดสินทีม 2026-10-08 + ข้อตัดสินโดย Zen-107 2026-10-08
> คำสั่ง: `flutter test` และ `flutter analyze` (รันใน app/) · Flutter 3.47.6
> รอบก่อน: QA v1 (commit 300dc15) 67 เทสต์ ผ่าน 67 · QA v2 (commit d4df00f) 114 เทสต์ ผ่าน 114
> เหตุของรอบ v3: มีไฟล์ PNG จริงแล้ว → ตาม game-rules §2 แอปต้องแสดง PNG แทนภาพวาด (เทสต์ v2 1 ตัวพังเพราะเงื่อนไขเปลี่ยน ไม่ใช่ bug)

## สรุปตัวเลข

| รายการ | ค่า |
|---|---|
| จำนวนเทสต์ทั้งหมด | 135 (เดิม 114 + ใหม่ 21) |
| ผ่าน | 135 |
| ไม่ผ่าน | 0 |
| AC ทั้งหมด / ผ่าน / ไม่ผ่าน | 6 / 6 / 0 |
| EC (requirements §5) ทั้งหมด / ผ่าน | 3 / 3 |
| ข้อตัดสิน Zen-107 2026-10-08 ทั้งหมด / มีเทสต์ / ผ่าน | 6 / 6 / 6 |
| ภาพ PNG (game-rules §2, v3) งาน 1 / งาน 2 / งาน 3 — ผ่าน/ทั้งหมด | 9/9 · 6/6 (+ PetPainter ตรง 2/2) · 4/4 |
| AC ที่ยังไม่มีเทสต์ | ไม่มี |
| Bug ที่พบ | 0 |
| เทสต์ที่ปรับเพราะเอกสารเปลี่ยน | 1 (Toast, v2) |
| เทสต์ที่ปรับเพราะเงื่อนไขเปลี่ยน (มี assets แล้ว, v3) | 4 เปลี่ยนชื่อ + วิธีตรวจ (1 ตัวพัง, 3 ตัวผ่านด้วยผลข้างเคียง) · อีก 2 ตัวได้ helper ใหม่โดยไม่เปลี่ยนชื่อ |
| เทสต์ที่ QA แก้เองเพราะเทสต์ผิด | 1 helper (v3: เทสต์ใหม่ของ QA เอง 2 ตัว ก่อนผ่านครั้งแรก) |
| `flutter analyze` (ทั้ง app/) | No issues found |

ไฟล์เทสต์ (app/test/water/):

| ไฟล์ | ชนิด | จำนวน |
|---|---|---|
| water_logic_test.dart | unit logic (v1) | 35 |
| water_controller_test.dart | unit controller/storage (v1) | 15 |
| water_screens_test.dart | widget (v1, ปรับ 1 เทสต์ใน v2) | 17 |
| water_decisions_logic_test.dart | unit logic (v2 ใหม่) | 14 |
| water_decisions_storage_test.dart | unit controller/storage (v2 ใหม่) | 20 |
| water_decisions_screens_test.dart | widget (v2 ใหม่, ปรับใน v3) | 13 |
| water_pet_png_test.dart | widget + unit ไฟล์ภาพ (v3 ใหม่) | 19 |
| water_pet_no_manifest_test.dart | widget (v3 ใหม่, แยก isolate) | 2 |

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
| AC-2 | AC2_S1_pet_mood_3_cups_critical_then_4_cups_tired (widget, v2 — เปลี่ยนชื่อ/วิธีตรวจใน v3) | ผ่าน |
| AC-2 | PNG_S1_3_cups_shows_pet_critical_png · PNG_S1_4_cups_shows_pet_tired_png · PNG_S1_3_to_4_cups_switches_critical_png_to_tired_png (widget, v3) | ผ่าน |
| AC-2 | FALLBACK_S1_png_load_throws_3_cups_painter_critical_then_4_tired · FALLBACK_S1_no_asset_manifest_3_to_4_cups_painter_no_crash (widget, v3) | ผ่าน |
| AC-3 | AC3_log_10_00_then_10_03_is_blocked_and_cups_unchanged | ผ่าน |
| AC-3 / AC-4 | AC3_AC4_controller_blocks_10_03_allows_10_05 | ผ่าน |
| AC-3 | AC3_S1_tap_within_5_min_shows_toast_and_count_unchanged (widget) | ผ่าน |
| AC-3 | AC3_S1_toast_disappears_2s_after_fully_shown_excluding_animation (widget, ปรับใน v2) | ผ่าน |
| AC-4 | AC4_log_10_00_then_10_05_is_allowed_and_last_log_is_10_05 | ผ่าน |
| AC-4 | AC4_S1_tap_after_5_min_logs_successfully (widget) | ผ่าน |
| AC-5 | AC5_5_cups_at_04_59_stay_5_then_reset_to_0_at_05_00 | ผ่าน |
| AC-5 | AC5_controller_refresh_at_05_00_resets_to_0 | ผ่าน |
| AC-5 | AC5_S1_open_app_after_05_00_shows_0_cups_0_percent (widget) | ผ่าน |
| AC-5 | AC5_S1_open_at_04_59_still_shows_5_cups (widget) | ผ่าน |
| AC-5 | AC5_S1_app_left_open_across_05_00_resets_on_screen (widget) | ผ่าน |
| AC-6 | AC6_average_5_and_4_over_2_logged_days_is_4_5 | ผ่าน |
| AC-6 | AC6_days_without_logs_are_not_in_divisor | ผ่าน |
| AC-6 | AC6_average_one_decimal_13_over_3_is_4_3 | ผ่าน |
| AC-6 | AC6_average_one_decimal_20_over_3_is_6_7 | ผ่าน |
| AC-6 | AC6_whole_number_average_shows_one_decimal_8_0 | ผ่าน |
| AC-6 | AC6_other_months_are_excluded | ผ่าน |
| AC-6 | AC6_history_list_has_date_and_cups_per_day_sorted | ผ่าน |
| AC-6 | AC6_S2_average_4_5_and_daily_history_list (widget) | ผ่าน |
| AC-6 ขอบเดือน (v2) | AC6_log_04_59_on_1st_goes_to_history_as_last_day_of_previous_month | ผ่าน |
| AC-6 ขอบเดือน (v2) | AC6_log_05_00_on_1st_goes_to_history_as_new_month | ผ่าน |
| AC-6 ขอบเดือน (v2) | AC6_log_04_59_then_05_04_on_1st_split_into_two_months | ผ่าน |
| AC-6 ขอบเดือน (v2) | AC6_report_at_04_59_on_1st_is_previous_month | ผ่าน |
| AC-6 ขอบเดือน (v2) | AC6_report_at_05_00_on_1st_is_new_month | ผ่าน |
| AC-6 ขอบเดือน (v2) | AC6_year_boundary_01_01_04_59_is_december_previous_year | ผ่าน |
| AC-6 ขอบเดือน (v2) | AC6_controller_log_04_59_on_1st_report_shows_previous_month | ผ่าน |
| AC-6 ขอบเดือน (v2) | AC6_controller_report_at_05_00_on_1st_switches_to_new_month | ผ่าน |
| AC-6 ขอบเดือน (v2) | AC6_storage_history_key_saves_04_59_as_previous_day | ผ่าน |
| AC-6 ขอบเดือน (v2) | AC6_S2_log_04_59_on_1st_shown_as_31_10_in_october_report (widget) | ผ่าน |
| AC-6 ขอบเดือน (v2) | AC6_S2_log_05_00_on_1st_shown_as_01_11_in_november_report (widget) | ผ่าน |
| AC-6 ขอบเดือน (v2) | AC6_S2_open_at_05_00_on_1st_with_only_october_data_is_empty (widget) | ผ่าน |

## ตาราง EC → เทสต์ (requirements §5)

| EC | ชื่อเทสต์ | ผล |
|---|---|---|
| EC-1 | EC1_12_cups_bar_stops_at_100_but_count_is_12 | ผ่าน |
| EC-1 | EC1_S1_12_cups_bar_full_100_but_count_12 (widget) | ผ่าน |
| EC-2 | EC2_device_off_overnight_across_05_00_resets_on_open | ผ่าน |
| EC-2 | EC2_device_off_several_days_resets_on_open | ผ่าน |
| EC-2 | EC2_controller_load_after_05_00_resets_and_saves_0 | ผ่าน |
| EC-2 | EC2_storage_reopen_next_day_after_05_00_shows_0 | ผ่าน |
| EC-3 | EC3_rapid_taps_only_first_is_logged | ผ่าน |
| EC-3 | EC3_controller_rapid_taps_without_await_log_only_once | ผ่าน |
| EC-3 | EC3_S1_rapid_double_tap_logs_once_and_shows_toast (widget) | ผ่าน |

## ข้อตัดสินโดย Zen-107 2026-10-08 → เทสต์ (QA v2)

| ข้อ | ข้อตัดสิน (อ้างเอกสาร) | ชื่อเทสต์ | ผล |
|---|---|---|---|
| 1 | ขอบเดือน: 04:59 ของวันที่ 1 = วันสุดท้ายของเดือนก่อน / 05:00 = เดือนใหม่ ทั้งประวัติและรายงาน (requirements AC-6) | 12 เทสต์ "AC-6 ขอบเดือน (v2)" ในตาราง AC ด้านบน (logic 6 · controller/storage 3 · widget 3) | ผ่าน 12/12 |
| 2 | นาฬิกาย้อนกลับ: ไม่ crash, นับเป็นวันเดียวกับบันทึกล่าสุด, ห้ามลบข้อมูล (game-rules §4) | EDGE_clock_back_to_previous_calendar_day_no_reset_same_day · EDGE_clock_back_before_05_00_same_date_no_reset · EDGE_clock_back_1_second_no_crash_no_reset · EDGE_clock_back_log_attempt_does_not_delete_data_and_counts_same_day · EDGE_clock_back_monthly_report_uses_same_day_as_last_log · EDGE_clock_back_then_forward_next_day_after_05_00_resets_normally · EDGE_clock_back_open_app_no_crash_no_reset_keeps_data · EDGE_clock_back_refresh_and_log_do_not_delete_stored_history · EDGE_clock_back_monthly_report_is_month_of_last_log · EDGE_clock_back_then_restored_same_day_keeps_cups · EDGE_S1_clock_back_opens_without_crash_and_keeps_cups (widget) · EDGE_S1_clock_back_tap_no_crash_and_no_data_loss (widget) · EDGE_S2_clock_back_report_shows_month_of_last_log (widget) | ผ่าน 13/13 |
| 3 | ข้อมูลเสีย/เก็บผิดชนิดใน SharedPreferences: เริ่มใหม่เป็นค่าว่าง ห้าม crash (game-rules §4) | EDGE_bad_type_count_as_string_starts_0_no_crash · EDGE_bad_type_count_as_double_starts_0_no_crash · EDGE_bad_type_count_as_bool_starts_0_no_crash · EDGE_bad_type_timestamp_as_int_treated_empty_can_log · EDGE_bad_type_history_as_int_starts_empty · EDGE_bad_type_history_as_string_list_starts_empty · EDGE_bad_type_history_json_object_not_list_starts_empty · EDGE_bad_type_history_item_cups_as_string_starts_empty · EDGE_bad_type_history_item_null_fields_starts_empty · EDGE_all_keys_bad_type_starts_empty_state · EDGE_bad_type_after_recovery_log_saves_correct_types · EDGE_repository_load_throws_controller_starts_empty_no_crash · EDGE_prefs_instance_fails_repository_returns_empty · EDGE_S1_bad_type_prefs_opens_empty_state_no_crash (widget) · EDGE_S2_bad_history_prefs_shows_empty_report_no_crash (widget) | ผ่าน 15/15 |
| 4 | วันที่หน้าประวัติ dd/MM/yyyy (ux-flow S-2) | UI_history_date_format_dd_MM_yyyy_with_leading_zeros · UI_S2_history_dates_shown_as_dd_MM_yyyy (widget) · (และวันที่ใน widget ข้อ 1/2 เช่น "31/10/2026", "01/11/2026") | ผ่าน 2/2 |
| 5 | อารมณ์ตามจำนวนแก้ว 0–3 critical / 4–6 tired / 7+ happy ขอบ 3/4 และ 6/7 วาดด้วย CustomPainter ใช้ PNG แทนถ้ามี (game-rules §2) | EDGE_mood_ranges_all_values_0_to_12 · EDGE_S1_pet_mood_0_cups_critical (widget) · AC2_S1_pet_mood_3_cups_critical_then_4_cups_tired (widget) · EDGE_S1_pet_mood_6_cups_tired_then_7_cups_happy (widget) · EDGE_S1_pet_mood_after_05_00_reset_back_to_critical (widget) — 4 ตัวหลังเปลี่ยนชื่อจาก `..._painter_...` ใน v3 · ทาง PNG/ภาพสำรองแบบบังคับ ดูส่วน "ภาพ PNG (QA v3)" | ผ่าน 5/5 |
| 6 | Toast หายใน 2 วินาที นับตั้งแต่แสดงเต็มจอ ไม่นับ animation (ux-flow §6) | AC3_S1_toast_disappears_2s_after_fully_shown_excluding_animation (widget, ปรับจาก v1) | ผ่าน 1/1 |

วิธีตรวจภาพสัตว์เลี้ยงใน water_decisions_screens_test.dart (ข้อ 5, ปรับใน v3): helper `expectPetMood` ตรวจว่า `PetAvatar` key `water_pet_image_<mood>` มี `mood` ถูก และข้างในมีภาพของ mood นั้น — ถ้าเป็น PNG (`water_pet_png_<mood>`) ชื่อ asset ต้องตรง game-rules §2, ถ้าเป็นภาพวาด (`water_pet_painter_<mood>`) ต้องเป็น `PetPainter(mood)` — และไม่มี key ของอารมณ์อื่น (png/painter/image) ค้าง เหตุที่รับได้ทั้ง 2 ทาง: ไฟล์นี้ไม่ได้อุ่น static manifest cache (ข้อจำกัด 1 ในส่วน PNG) จึงเห็น PNG เฉพาะเทสต์แรกของไฟล์ ทางที่แสดงแบบบังคับ/แน่นอนอยู่ใน water_pet_png_test.dart และ water_pet_no_manifest_test.dart

วิธีตรวจ Toast (ข้อ 6): ใช้ `SnackBar.animation.status` — pump ทีละ 10 ms จนสถานะเป็น `completed` (แสดงเต็มจอ) แล้วตรวจว่า ณ +1.99 วินาทียัง `completed` และ ณ +2.00 วินาทีเปลี่ยนเป็น `reverse` (เริ่มหาย) จากนั้นรอ animation ออกจบแล้ว Toast ต้องไม่อยู่บนจอ

## ภาพ PNG (QA v3) — game-rules §2 + ข้อตัดสิน Zen-107 "ใช้ PNG แทนถ้ามีใน app/assets/images/"

### งาน 1: หน้าจอหลัก S-1 แสดง PNG ถูกไฟล์ตามจำนวนแก้ว (water_pet_png_test.dart)

ตรวจ: key `water_pet_png_<mood>` (อยู่ใต้ `water_pet_image_<mood>`), `Image.image` เป็น `AssetImage` ที่ `assetName` ตรงคอลัมน์ "ไฟล์ภาพ" ของ game-rules §2, ไม่มีภาพวาดหรืออารมณ์อื่นค้าง, ภาพ decode สำเร็จจริง (`RawImage.image` 512×512 = ไม่ได้ตกไป errorBuilder) และข้อความสถานะตรง §2

| จำนวนแก้ว | ไฟล์ที่คาด (game-rules §2) | ชื่อเทสต์ | ผล |
|---|---|---|---|
| 0 | assets/images/pet_critical.png | PNG_S1_0_cups_shows_pet_critical_png | ผ่าน |
| 3 (ขอบบน critical) | assets/images/pet_critical.png | PNG_S1_3_cups_shows_pet_critical_png | ผ่าน |
| 4 (ขอบล่าง tired) | assets/images/pet_tired.png | PNG_S1_4_cups_shows_pet_tired_png | ผ่าน |
| 6 (ขอบบน tired) | assets/images/pet_tired.png | PNG_S1_6_cups_shows_pet_tired_png | ผ่าน |
| 7 (ขอบล่าง happy) | assets/images/pet_happy.png | PNG_S1_7_cups_shows_pet_happy_png | ผ่าน |
| 12 (เกินเพดาน EC-1) | assets/images/pet_happy.png | PNG_S1_12_cups_shows_pet_happy_png | ผ่าน |
| 3 → 4 กดบันทึก | critical → tired | PNG_S1_3_to_4_cups_switches_critical_png_to_tired_png | ผ่าน |
| 6 → 7 กดบันทึก | tired → happy | PNG_S1_6_to_7_cups_switches_tired_png_to_happy_png | ผ่าน |
| 7 แก้ว 04:59 → 05:00 รีเซ็ต | happy → critical | PNG_S1_after_05_00_reset_happy_png_back_to_critical_png | ผ่าน |

### งาน 2: โหลดภาพไม่ได้ → กลับไปใช้ CustomPainter ไม่ crash

| กรณี | ชื่อเทสต์ | ผล |
|---|---|---|
| bundle โยน error ตอนโหลด PNG, 3 → 4 แก้ว | FALLBACK_S1_png_load_throws_3_cups_painter_critical_then_4_tired | ผ่าน |
| bundle โยน error ตอนโหลด PNG, 6 → 7 แก้ว | FALLBACK_S1_png_load_throws_6_cups_painter_tired_then_7_happy | ผ่าน |
| PNG เป็นไบต์เสีย (decode ไม่ได้), 0 แก้ว + กดบันทึกต่อได้ | FALLBACK_S1_png_corrupt_bytes_0_cups_painter_critical | ผ่าน |
| PNG เป็นไบต์เสีย, 12 แก้ว | FALLBACK_S1_png_corrupt_bytes_12_cups_painter_happy | ผ่าน |
| อ่าน AssetManifest ไม่ได้, 3 → 4 แก้ว | FALLBACK_S1_no_asset_manifest_3_to_4_cups_painter_no_crash (water_pet_no_manifest_test.dart) | ผ่าน |
| อ่าน AssetManifest ไม่ได้, 6 → 7 แก้ว | FALLBACK_S1_no_asset_manifest_6_to_7_cups_painter_no_crash (water_pet_no_manifest_test.dart) | ผ่าน |
| PetPainter วาดได้ครบ 3 อารมณ์ (เรียกตรง ไม่ผ่าน PetAvatar) | PAINTER_draws_all_3_moods_without_error | ผ่าน |
| PetPainter วาดใหม่เมื่อ mood เปลี่ยนเท่านั้น | PAINTER_repaints_only_when_mood_changes | ผ่าน |

วิธีทดสอบ fallback:
- errorBuilder: ห่อ `PetPalApp` ด้วย `DefaultAssetBundle(bundle: _BrokenPetBundle)` — bundle ปลอมส่งต่อ `rootBundle` ทุกคีย์ ยกเว้น `assets/images/pet_*` ที่ (ก) โยน `FlutterError` หรือ (ข) คืน 64 ไบต์ที่ไม่ใช่ภาพ manifest ของ PetAvatar (อ่านจาก `rootBundle`) ยังบอกว่ามี PNG จึงสร้าง `Image.asset` จริง แล้ว `Image` โหลดผ่าน bundle ปลอมล้ม → errorBuilder รอโหลด/decode ด้วย `tester.runAsync` เทสต์ตรวจว่า (1) bundle ปลอมถูกขอไฟล์ PNG ของ mood นั้นจริง (2) `CustomPaint` key `water_pet_painter_<mood>` อยู่ **ใต้** `Image` key `water_pet_png_<mood>` = มาจาก errorBuilder ไม่ใช่ทาง "ไม่มี PNG" (3) `PetPainter.mood` ถูก (4) `tester.takeException()` เป็น null (5) ข้อความสถานะถูก และปุ่มยังบันทึกได้
- ไม่มี manifest: ไฟล์แยก (isolate ใหม่) mock ช่อง `flutter/assets` ให้ตอบ null ทุกคีย์ก่อนสร้าง PetAvatar ตัวแรก ตรวจว่ามีการขอ `AssetManifest*` จริง, ใต้ `water_pet_image_<mood>` ไม่มี `Image` เลย, เป็น `PetPainter(mood)` และไม่ crash

ข้อจำกัดของการทดสอบ (ไม่ใช่ bug, ไม่ได้แก้ app/lib/):
1. `PetAvatar._availableAssets` เป็น static Future สร้างครั้งเดียวต่อ isolate และผูกกับ zone ที่สร้าง — ใน widget test แต่ละเทสต์มี fake-async zone ของตัวเอง ถ้า Future ถูกสร้างในเทสต์แรก เทสต์ถัด ๆ ไปในไฟล์เดียวกันจะไม่ได้รับผล manifest (callback ถูกตั้งคิวใน zone ของเทสต์แรกที่จบไปแล้ว) จึงแสดงภาพวาดตลอด — นี่คือเหตุที่รอบนี้มีแค่เทสต์แรกของ water_decisions_screens_test.dart ที่เห็น PNG และพัง ส่วนอีก 3 เทสต์ painter ผ่านเพราะผลข้างเคียงนี้ ไม่ใช่เพราะแอปใช้ภาพวาด วิธีแก้ในเทสต์: `warmManifest` สร้าง PetAvatar ตัวแรกใน `tester.runAsync` (real zone) ทุกเทสต์ใน water_pet_png_test.dart (ทำซ้ำได้ ไม่มีผลข้างเคียง) ทำให้ทุกเทสต์เห็น PNG แน่นอน ในแอปจริงมี zone เดียวจึงไม่เกิดปัญหานี้
2. manifest อ่านจาก `rootBundle` ตรง ๆ (ไม่ใช่ `DefaultAssetBundle`) และ cache ตลอด isolate → ทดสอบ "อ่าน manifest ไม่ได้" ได้เฉพาะในไฟล์แยก และทำได้ 1 สถานการณ์ต่อไฟล์ (เช่นทดสอบ "manifest อ่านได้แต่ไม่มี PNG" ต้องเพิ่มอีกไฟล์ — รอบนี้ไม่ได้ทำ เพราะผลบนจอเหมือนกรณีอ่านไม่ได้)
3. ทาง "อ่าน manifest ไม่ได้" แสดงภาพวาดเหมือนช่วงก่อน manifest โหลดเสร็จ — เทสต์ยืนยันได้ว่ามีการอ่าน manifest จริงและไม่ crash แต่แยกจากหน้าจออย่างเดียวไม่ได้ว่า catch ทำงานแล้วหรือยังรออยู่ (ลดความเสี่ยงโดยรอใน `runAsync` ก่อนตรวจ)
4. ตอนเปิดจอ แอปแสดงภาพวาดก่อนจน manifest โหลดเสร็จแล้วจึงสลับเป็น PNG (Dev ตั้งใจ ตามคอมเมนต์ใน pet_avatar.dart) เทสต์ตรวจเฉพาะสถานะหลังโหลดเสร็จ

### งาน 3: ไฟล์ภาพใน app/assets/images/

| ตรวจ | ชื่อเทสต์ | ผล |
|---|---|---|
| มีไฟล์ pet_critical.png, pet_tired.png, pet_happy.png | FILE_pet_pngs_exist_in_app_assets_images | ผ่าน |
| 8 ไบต์แรกเป็น PNG signature `89 50 4E 47 0D 0A 1A 0A` และ chunk แรกเป็น IHDR | FILE_pet_pngs_have_png_signature | ผ่าน |
| IHDR width/height = 512×512 | FILE_pet_pngs_ihdr_is_512x512 | ผ่าน |
| ลงทะเบียนใน AssetManifest (pubspec `assets/images/`) และ decode ผ่าน engine ได้ 512×512 | FILE_pet_pngs_decode_to_512x512_and_registered_in_bundle | ผ่าน |

## Edge case เสี่ยง 4 แบบ

| แบบ | ชื่อเทสต์ | ผล |
|---|---|---|
| 1 ค่าเกณฑ์พอดี (สถานะ 3/4, 6/7) | EDGE_threshold_0_and_3_critical_4_tired · EDGE_threshold_6_tired_7_happy_8_happy · EDGE_S1_6_to_7_cups_status_changes_tired_to_happy (widget) · EDGE_mood_ranges_all_values_0_to_12 (v2) · EDGE_S1_pet_mood_6_cups_tired_then_7_cups_happy (v2 widget) · AC2_S1_pet_mood_3_cups_critical_then_4_cups_tired (v2 widget) · PNG ขอบ 3/4/6/7 + สลับ 3→4, 6→7 (v3, 6 เทสต์) · FALLBACK ภาพวาด 3→4, 6→7 (v3, 4 เทสต์) | ผ่าน |
| 1 ค่าเกณฑ์พอดี (Anti-Spam 5 นาที) | EDGE_threshold_4m59s_blocked_5m00s_allowed_6m_allowed · EDGE_blocked_attempt_does_not_restart_5_minute_window | ผ่าน |
| 1 ค่าเกณฑ์พอดี (Toast 2 วินาที) | AC3_S1_toast_disappears_2s_after_fully_shown_excluding_animation (1.99 s ยังแสดง / 2.00 s เริ่มหาย) | ผ่าน |
| 2 ข้ามวัน/รีเซ็ต (เที่ยงคืนไม่ใช่เวลารีเซ็ต) | EDGE_midnight_is_not_reset_boundary · EDGE_log_23_58_then_00_01_blocked_00_03_counts_on_same_day | ผ่าน |
| 2 ข้ามวัน/รีเซ็ต (หลังรีเซ็ต) | EDGE_after_05_00_reset_first_log_starts_from_1_cup · EDGE_reset_keeps_previous_day_in_history · EDGE_S1_pet_mood_after_05_00_reset_back_to_critical (v2 widget) · PNG_S1_after_05_00_reset_happy_png_back_to_critical_png (v3) | ผ่าน |
| 2 Anti-Spam ข้าม 05:00 (คำตัดสินทีม, game-rules §4) | EDGE_antispam_across_05_00_log_04_58_tap_05_01_blocked · EDGE_antispam_across_05_00_05_02_59_blocked_05_03_allowed · EDGE_antispam_across_05_00_survives_app_restart · EDGE_S1_log_04_58_tap_05_01_shows_toast_after_reset (widget) | ผ่าน |
| 2 ข้ามเดือน/ปี ตามรอบวัน 05:00 (v2 ข้อ 1) | 12 เทสต์ AC-6 ขอบเดือน (รวมขอบปี 1 ม.ค. 04:59 → ธ.ค. ปีก่อน) | ผ่าน |
| 2 นาฬิกาย้อนกลับ (v2 ข้อ 2) | 13 เทสต์ในข้อตัดสิน 2 | ผ่าน |
| 3 เพดาน max/min | PNG_S1_12_cups_shows_pet_happy_png · FALLBACK_S1_png_corrupt_bytes_12_cups_painter_happy (v3) · EDGE_cap_8_cups_exactly_100_and_9_cups_still_100 · EDGE_count_keeps_increasing_past_cap_9_to_10 · EDGE_min_0_cups_is_0_percent_never_negative · EDGE_negative_stored_count_clamped_to_0 | ผ่าน |
| 4 เปิดแอปครั้งแรก/ข้อมูลว่าง | EDGE_first_open_initial_state_0_cups_0_percent_critical · EDGE_first_ever_log_is_allowed_without_previous_timestamp · EDGE_first_open_empty_storage_0_cups_critical · EDGE_S1_first_open_shows_0_cups_0_percent_critical (widget) · EDGE_S1_pet_mood_0_cups_critical (v2 widget) · PNG_S1_0_cups_shows_pet_critical_png (v3) · EDGE_empty_history_average_0_0_and_empty · EDGE_S2_empty_history_shows_empty_text_and_0_0 (widget) | ผ่าน |
| 4 ข้อมูลเสีย/หาย | EDGE_corrupted_history_json_does_not_crash_starts_fresh · EDGE_corrupted_history_item_missing_fields_starts_fresh · EDGE_corrupted_timestamp_treated_as_never_logged · EDGE_missing_count_key_defaults_to_0 · + 15 เทสต์ข้อมูลผิดชนิดในข้อตัดสิน 3 (v2) · ไฟล์ภาพเสีย/โหลดไม่ได้/ไม่มี manifest 6 เทสต์ FALLBACK (v3) | ผ่าน |

## เทสต์อื่น (UI ตาม ux-flow.md / Local Storage ตาม requirements §7)

| ชื่อเทสต์ | ผล |
|---|---|
| UI_S1_button_label_and_plus_icon_per_ux_flow (ปุ่ม "ดื่มน้ำ 1 แก้ว" + ไอคอน "+", ปุ่ม "รายงานรายเดือน") | ผ่าน |
| UI_S2_open_from_S1_shows_header_and_back_returns (หัวข้อ "รายงานการดื่มน้ำประจำเดือน", ปุ่ม "ย้อนกลับ" กลับ S-1) | ผ่าน |
| STORAGE_save_uses_keys_from_requirements_section_7 | ผ่าน |
| STORAGE_data_survives_reopen_same_day | ผ่าน |

## รายการ bug

ไม่พบ bug ในรอบ v3 — เทสต์ที่พัง 1 ตัวตอนเริ่มรอบ (EDGE_S1_painter_0_cups_critical) แอปทำถูกตาม game-rules §2 (มี PNG แล้วแสดง PNG) เทสต์ต้องปรับตามเงื่อนไขที่เปลี่ยน
(v2: ไม่พบ bug, 114 เทสต์ผ่านทั้งหมด)

## เทสต์ที่ปรับเพราะเอกสารเปลี่ยน (ไม่ใช่ bug, ไม่ใช่เทสต์ผิด)

| เทสต์เดิม (v1) | เทสต์ใหม่ (v2) | เหตุผล |
|---|---|---|
| AC3_S1_toast_disappears_after_2_seconds | AC3_S1_toast_disappears_2s_after_fully_shown_excluding_animation | ux-flow §6 (commit e64adff) กำหนดจุดเริ่มนับ = Toast แสดงเต็มจอ และไม่นับ animation — v1 ตรวจแค่ "ยังอยู่ที่ 1.9 s / หายหลัง 2 s + animation" แบบคร่าว ๆ ปรับให้วัดจุดเริ่มนับจาก `animation.status == completed` และตรวจขอบ 1.99 s / 2.00 s ชัดเจน (เทสต์ v1 ไม่ได้ fail ก่อนปรับ) |

## เทสต์ที่ปรับเพราะเงื่อนไขเปลี่ยน — มี assets แล้ว (QA v3, ไม่ใช่ bug, ไม่ใช่เทสต์ผิด)

| เทสต์เดิม (v2) | เทสต์ใหม่ (v3) | เหตุผล |
|---|---|---|
| EDGE_S1_painter_0_cups_critical | EDGE_S1_pet_mood_0_cups_critical | พังตอนเริ่มรอบ: แอปแสดง `water_pet_png_critical` (ถูกตาม game-rules §2) แต่เทสต์บังคับว่าต้องเป็นภาพวาด → helper `expectPetMood` ใหม่ตรวจทางที่แสดงอยู่ว่าถูกอารมณ์ (PNG ต้องชื่อไฟล์ตาม §2 / ภาพวาดต้องเป็น PetPainter mood ถูก) และไม่มีอารมณ์อื่นค้าง |
| AC2_S1_painter_3_cups_critical_then_4_cups_tired | AC2_S1_pet_mood_3_cups_critical_then_4_cups_tired | ไม่ได้พัง แต่ผ่านเพราะผลข้างเคียงของ static cache (ข้อจำกัด 1) ไม่ใช่เพราะแอปใช้ภาพวาด → ใช้ helper ใหม่และเปลี่ยนชื่อ ขอบ 3/4 แบบบังคับทาง PNG/ภาพสำรองเพิ่มใน water_pet_png_test.dart, water_pet_no_manifest_test.dart |
| EDGE_S1_painter_6_cups_tired_then_7_cups_happy | EDGE_S1_pet_mood_6_cups_tired_then_7_cups_happy | เหมือนข้างบน (ขอบ 6/7) |
| EDGE_S1_painter_after_05_00_reset_back_to_critical | EDGE_S1_pet_mood_after_05_00_reset_back_to_critical | เหมือนข้างบน |

เทสต์อีก 2 ตัวในไฟล์เดียวกันที่เรียก helper `expectPetMood` จึงได้วิธีตรวจใหม่โดยไม่เปลี่ยนชื่อ: EDGE_S1_clock_back_opens_without_crash_and_keeps_cups · EDGE_S1_bad_type_prefs_opens_empty_state_no_crash

ความครอบคลุมขอบ 3/4 และ 6/7 ไม่ลดลง: ยังอยู่ใน water_decisions_screens_test.dart (2 เทสต์) + ทาง PNG แบบบังคับ 6 เทสต์ (3, 4, 6, 7, 3→4, 6→7) + ทางภาพสำรองแบบบังคับ 4 เทสต์ (errorBuilder 2, ไม่มี manifest 2)

## เทสต์ที่ QA แก้เองเพราะเทสต์ผิด

| รอบ | เทสต์ | ผิดอะไร / แก้อะไร |
|---|---|---|
| v3 | FALLBACK_S1_no_asset_manifest_3_to_4_cups_painter_no_crash, FALLBACK_S1_no_asset_manifest_6_to_7_cups_painter_no_crash (helper `expectPainterOnly` ตัวเดียว) | เทสต์ใหม่ของ QA รันครั้งแรกพัง: ตรวจ `find.byType(Image)` ทั้งจอว่าต้องไม่มี แต่หน้า S-1 มีไอคอนปุ่ม `assets/icons/water_plus.png`, `calendar_report.png` เป็น `Image` อยู่แล้ว → แก้ให้ตรวจเฉพาะใต้ `water_pet_image_<mood>` และไม่มี key `water_pet_png_<mood>` (แก้ 1 จุดใน helper) |

## คำถามเดิม (QA v1) ที่ปิดแล้ว

1. ~~Toast "หายเองใน 2 วินาที" นับจากตอนไหน~~ → ปิด: นับตั้งแต่แสดงเต็มจอ ไม่นับ animation (ux-flow §6) — เทสต์แล้ว (ข้อตัดสิน 6)
2. ~~"เดือนนี้" ของรายงาน ช่วง 00:00-04:59 ของวันที่ 1~~ → ปิด: นับเป็นวันสุดท้ายของเดือนก่อน (requirements AC-6) — เทสต์แล้ว (ข้อตัดสิน 1)
3. ~~นาฬิกาเครื่องถูกตั้งย้อน~~ → ปิด: ไม่ crash, นับเป็นวันเดียวกับบันทึกล่าสุด, ห้ามลบข้อมูล (game-rules §4) — เทสต์แล้ว (ข้อตัดสิน 2) เหลือคำถามย่อยข้อ 1 ด้านล่าง
4. ~~ข้อมูลในเครื่องเก็บผิดชนิด~~ → ปิด: เริ่มใหม่เป็นค่าว่าง ห้าม crash (game-rules §4) — เทสต์แล้ว (ข้อตัดสิน 3) เหลือคำถามย่อยข้อ 2 ด้านล่าง
5. ~~ภาพสัตว์เลี้ยง~~ → ปิด: วาดด้วย CustomPainter ใช้ PNG แทนถ้ามี (game-rules §2) — เทสต์ทั้งทางภาพวาดและ PNG แล้ว (ข้อตัดสิน 5 + ส่วนภาพ PNG v3)
6. ~~รูปแบบวันที่ในรายการประวัติ~~ → ปิด: dd/MM/yyyy (ux-flow S-2) — เทสต์แล้ว (ข้อตัดสิน 4)

## คำถามถึงเอกสาร (ยังเปิด, ไม่นับเป็น bug)

1. **นาฬิกาย้อนกลับแล้วกดบันทึกได้ทันทีหรือไม่** (game-rules §4 กำหนดแค่ไม่ crash / วันเดียวกัน / ห้ามลบข้อมูล) — Dev ASSUMPTION: บล็อกด้วย Anti-Spam จนนาฬิกาเดินถึง 5 นาทีหลังบันทึกล่าสุด (water_logic.dart `canLog`) ถ้าย้อนนาน ผู้ใช้จะบันทึกไม่ได้จนเวลาตามทัน เทสต์ของ QA จึงไม่ assert ว่า logged หรือ blocked — ตรวจแค่ว่าไม่ว่าผลไหน ข้อมูลไม่หาย และถ้าบันทึกได้ต้องนับเข้าวันของบันทึกล่าสุด
2. **ข้อมูลเสียบางคีย์: ล้างเฉพาะคีย์ที่เสีย หรือล้างทั้งหมด** (game-rules §4 "เริ่มใหม่เป็นค่าว่าง") — Dev ASSUMPTION: ล้างทีละคีย์ (water_repository.dart `load`) และถ้าประวัติมีรายการเสียแม้รายการเดียว ประวัติทั้งก้อนจะว่าง เทสต์ของ QA ตรวจเฉพาะว่าคีย์ที่เสียกลายเป็นค่าว่างและไม่ crash ไม่ได้ assert ว่าคีย์อื่นถูกเก็บหรือถูกล้าง

## คำถาม QA v2 ที่ปิดในรอบ v3

3. ~~ทางแสดง PNG ยังทดสอบไม่ได้ (ยังไม่มี app/assets/images/pet_*.png)~~ → ปิด: มีไฟล์ PNG 3 ไฟล์แล้ว (สร้างจาก tools/gen_pet_images.py) — เทสต์ทาง `water_pet_png_<mood>`, fallback และตัวไฟล์แล้ว (ส่วน "ภาพ PNG (QA v3)") หมายเหตุ: ณ เวลาทดสอบไฟล์ PNG และ tools/ ยังไม่ commit — ถ้า commit โดยไม่มี PNG เทสต์งาน 1 (9) และงาน 3 (4) จะพัง

## คำถามใหม่ QA v3

ไม่มีคำถามถึงเอกสาร — game-rules §2 ชัดเจนเรื่องชื่อไฟล์และช่วงแก้ว (ข้อสังเกต: ภาพวาดแสดงก่อนแล้วสลับเป็น PNG ตอนเปิดจอ ดูข้อจำกัด 4 — เอกสารไม่ได้กำหนด ไม่ขัดเอกสาร)
