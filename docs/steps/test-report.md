# Test report: steps (QA รอบที่ 1)

> ผู้ทดสอบ: QA agent · วันที่ 2026-10-14 · โค้ดที่ทดสอบ: app/lib/features/steps/ (dev v1, logs/20261014-0942_dev_steps.md)
> อ้างอิง: requirements.md, game-rules.md, ux-flow.md, ui-spec.md (ค่าคาดหวังทั้งหมดมาจากเอกสาร ไม่ได้ลอกจากโค้ด)
> เทสต์: app/test/steps/steps_logic_test.dart, steps_controller_test.dart, steps_screens_test.dart

## 1. สรุปตัวเลข

| รายการ | จำนวน |
|---|---|
| เทสต์ steps ทั้งหมด | 100 (logic 40 · controller/storage 21 · widget 39) |
| ผ่าน | 100 |
| ไม่ผ่าน | 0 |
| เทสต์ทั้งชุด (`flutter test` ใน app/ รวม water) | 235 ผ่าน / 0 ไม่ผ่าน — `00:32 +235: All tests passed!` |
| AC ที่ยังไม่มีเทสต์ | 0 (AC-1 ทดสอบตาม MVP D-1 = ปุ่มเพิ่มก้าว; ค่าคลาดเคลื่อน 5% ของเซนเซอร์ทดสอบไม่ได้ใน MVP — ดูคำถาม) |
| EC ที่ยังไม่มีเทสต์ | 1 (EC-4 Multi-device Sync — ทำไม่ได้แบบ offline) |
| Bug ที่พบ | 0 |
| จำนวนรอบที่ส่งกลับให้ Dev | 0 |
| เทสต์ที่ QA แก้เองเพราะเทสต์ผิด | 1 |

เทสต์ที่ชื่อมีคำว่า `ASSUMPTION` = ทดสอบการตีความของ Dev ในจุดที่เอกสารไม่ชัด (ไม่ใช่สเปก ถ้าเจ้าของตอบต่างออกไปต้องแก้ทั้งโค้ดและเทสต์)
จำนวนก้าวต่อการกด 1 ครั้งทดสอบผ่านค่าคงที่ `StepsRules.stepsPerTap` (ค่าชั่วคราว 1,000 ของ Dev — ui-spec Q-2) ไม่ใช่ตัวเลขจากสเปก

## 2. AC → เทสต์

| AC | เทสต์ | ผล |
|---|---|---|
| AC-1 (MVP: กรอกก้าวด้วยมือ ui-spec D-1) | AC1_add_steps_increments_by_steps_per_tap_and_persists · AC1_add_before_load_is_ignored · AC1_tap_add_increases_steps_realtime · UI_S1_ASSUMPTION_Q1_add_button_label_and_icon | ผ่าน |
| AC-2 บันทึกเป้าหมาย 3 กลุ่ม มีผลทันที + ลงฐานข้อมูล | AC2_goal_options_are_the_three_groups_from_ux_flow · AC2_every_goal_option_can_be_saved · AC2_ASSUMPTION_first_goal_new_user_applies_immediately · AC2_saved_goal_written_to_storage_and_used_for_percent · AC2_save_new_goal_updates_S1_percent_immediately · ASSUMPTION_AC2_change_before_05_00_applies_immediately | ผ่าน |
| AC-3 โควต้า 1 ครั้ง/วัน ปุ่ม Disabled + Toast | AC3_second_change_same_day_is_rejected · AC3_quota_still_used_at_04_59_59_and_resets_at_05_00_00 · AC3_second_save_same_day_not_written · AC3_after_save_button_disabled_and_tap_shows_quota_toast · AC3_ASSUMPTION_Q11_reenter_S2_shows_toast_and_chips_locked · AC3_quota_resets_at_05_00_save_enabled_again | ผ่าน |
| AC-4 เปลี่ยนหลัง 05:00 มีผลรอบวันถัดไป | AC4_change_after_05_00_applies_from_next_day_05_00 · AC4_change_after_05_00_applies_next_day_05_00_on_S1 | ผ่าน |
| AC-5 % Goal → FAT/CHUBBY/LEAN/MUSCLE | AC5_percent_formula_game_rules_example_2800_of_8000_is_35 · AC5_percent_not_capped_8500_of_8000_is_106_25 · AC5_status_for_percent_exact_boundaries · AC5_enum_codes_thai_labels_and_images_per_docs · AC5_tap_add_crosses_35_percent_changes_pet_immediately · EDGE_AC5_S1_{2799,2800,5599,5600,7999,8000,8001}_of_8000_shows_<status> (7 เทสต์) · REQ7_pet_status_enum_stored_with_doc_codes | ผ่าน |
| AC-6 รีเซ็ต 05:00:00 | AC6_logical_day_changes_exactly_at_05_00_00 · AC6_game_rules_example_8500_resets_to_0_at_05_00_00 · AC6_midnight_does_not_reset · AC6_previous_day_kept_in_history_after_reset · AC6_several_days_closed_resets_to_0 · AC6_steps_added_after_05_00_count_only_for_new_day · EC2_AC6_reopen_after_05_00_starts_new_day_at_0 · EC5_refresh_day_resets_at_05_00_00_without_reload · EC5_AC6_foreground_crossing_05_00_resets_without_restart | ผ่าน |
| AC-7 รายงาน PNG 4 ตัวแปร | AC7_four_values_total_steps_water_average_goal_days · AC7_goal_day_boundary_7999_not_counted_8000_counted · AC7_month_follows_05_00_cutoff · AC7_report_file_is_png · ASSUMPTION_Q6_average_divides_by_days_with_steps · ASSUMPTION_Q7_goal_days_use_goal_of_that_day · AC7_export_passes_png_bytes_to_exporter · AC7_export_failure_throws_for_ui_error_state · AC7_S3_card_shows_four_values_from_storage · AC7_export_png_of_report_area_saved_once | ผ่าน |

## 3. Edge case (EC ในเอกสาร + 4 แบบบังคับ)

| กรณี | เทสต์ | ผล |
|---|---|---|
| EC-1 ปฏิเสธสิทธิ์ | EC1_EC6_permissionDenied_locks_step_counting · EC1_EC6_permissionDenied_popup_settings_shortcut_and_lock · EC1_unlock_after_permission_granted_allows_counting · EC1_ASSUMPTION_Q4_popup_proposed_texts | ผ่าน |
| EC-2 แบตหมด/ปิดเครื่อง → ดึงจาก Local Storage | EC2_reload_same_day_shows_last_saved_steps · EC2_reopen_at_04_59_59_still_previous_day_steps · EC2_AC6_reopen_after_05_00_starts_new_day_at_0 · S1_disabled_offline_icon_and_last_stored_values | ผ่าน |
| EC-3 นาฬิกาย้อน (MVP: ไม่ย้อนเวลาที่เคยเห็น — ASSUMPTION Dev ข้อ 4) | EC3_clock_back_before_cutoff_does_not_reset_steps · EC3_clock_back_does_not_restore_goal_quota · EC3_clock_back_does_not_overwrite_previous_day_history · EC3_real_cutoff_after_clock_back_still_resets | ผ่าน |
| EC-4 Multi-device Sync | — ไม่มีเทสต์ (ไม่มี server/network ใน MVP ui-spec D-2) | ไม่ได้ทดสอบ |
| EC-5 เปิดค้างข้าม 05:00 | EC5_AC6_foreground_crossing_05_00_resets_without_restart (widget: เปลี่ยน clock แล้ว pump 1 วินาที) · EC5_refresh_day_resets_at_05_00_00_without_reload | ผ่าน |
| EC-6 ไม่มีฮาร์ดแวร์ | EC1_EC6_noHardware_locks_step_counting · EC1_EC6_noHardware_popup_settings_shortcut_and_lock | ผ่าน |
| 1. ค่าเกณฑ์พอดี ±1 (35/70/100%) | EDGE_threshold_plus_minus_1_step_goal_8000 · EDGE_threshold_plus_minus_1_step_every_goal_option (ครบ 10 เป้าหมาย) · EDGE_AC5_S1_* (7) · ASSUMPTION_Q7_percent_truncated_never_shows_100_while_lean | ผ่าน |
| 2. ข้ามวัน/รีเซ็ต (05:00:00 vs 04:59:59, เที่ยงคืน, โควต้า) | AC6_* · AC3_quota_still_used_at_04_59_59_and_resets_at_05_00_00 · EC5_* · AC4_* · AC7_month_follows_05_00_cutoff | ผ่าน |
| 3. เพดาน max/min | EDGE_energy_bar_capped_at_1_while_percent_exceeds_100 · EDGE_S1_over_100_bar_full_text_106_25 · EDGE_add_zero_or_negative_steps_never_decreases_below_0 · EDGE_goal_bounds_6000_15000_accepted_outside_rejected · EDGE_invalid_goal_rejected_and_quota_not_consumed · EDGE_quota_never_below_0 · EDGE_stored_negative_steps_clamped_to_0 · EDGE_ASSUMPTION_stored_goal_outside_6000_15000_falls_back_to_default | ผ่าน |
| 4. ข้อมูลว่าง/เปิดครั้งแรก/ข้อมูลเสีย | EDGE_first_run_no_data_starts_day_with_0_steps · EDGE_first_run_empty_storage_shows_initial_state · EDGE_S1_empty_first_run_0_steps_0_percent_fat · EDGE_S2_first_entry_8000_preselected_only · EDGE_S3_empty_month_zero_values_and_empty_text · EDGE_empty_report_all_zero · EDGE_corrupted_storage_wrong_types_does_not_crash · EDGE_corrupted_history_items_skipped_valid_items_kept · EDGE_repository_throws_starts_empty_without_crash | ผ่าน |

## 4. หน้าจอ (ux-flow §2/§4, ui-spec §2–§3)

| หน้าจอ / สถานะ | เทสต์ | ผล |
|---|---|---|
| S-1 ข้อความ/ปุ่ม/key | UI_S1_texts_and_buttons_per_ux_flow · UI_S1_navigation_to_S2_and_S3_and_back · UI_D3_entry_from_water_home_opens_S1 | ผ่าน |
| S-1 Empty / Error / Disabled | EDGE_S1_empty_first_run_0_steps_0_percent_fat · EC1_EC6_* (popup) · S1_disabled_offline_icon_and_last_stored_values | ผ่าน |
| S-2 ข้อความ/ชิป 10 ตัว/ปุ่ม | UI_S2_title_chips_and_save_button_texts_per_ux_flow · UI_S2_ASSUMPTION_Q9_group_headers · S2_only_one_chip_selected_across_groups | ผ่าน |
| S-2 Empty / Error / Disabled | EDGE_S2_first_entry_8000_preselected_only · S2_error_storage_failure_keeps_goal_and_quota_then_retry_works · S2_error_toast_on_save_failure_retry_allowed · AC3_after_save_button_disabled_and_tap_shows_quota_toast | ผ่าน |
| S-3 ข้อความ/การ์ด 4 แถว/ปุ่ม | UI_S3_title_labels_and_export_button_per_ux_flow · AC7_S3_card_shows_four_values_from_storage | ผ่าน |
| S-3 Empty / Error (+ลองใหม่) / Disabled (กำลังสร้างรายงาน...) | EDGE_S3_empty_month_zero_values_and_empty_text · S3_export_error_dialog_and_retry_succeeds · S3_capture_failure_shows_error_dialog · S3_load_failure_shows_error_dialog_retry_recovers · S3_exporting_button_disabled_with_spinner_text | ผ่าน |
| จอ 360 dp ไม่ overflow (ui-spec §5) | UI_360dp_S1_S2_S3_no_overflow | ผ่าน |
| ค่าหลัก game-rules §1 | GR1_constants_match_game_rules | ผ่าน |
| รูปแบบข้อความ S-1 | S1_count_text_format_ux_flow_example_5500_of_8000 · S1_percent_text_examples_from_ui_spec | ผ่าน |

## 5. รายการ Bug

ไม่พบ bug ในรอบนี้ (0 รายการ)

## 6. เทสต์ที่ QA แก้เอง (เทสต์ผิด)

| เทสต์ | ปัญหา | แก้อย่างไร |
|---|---|---|
| S2_error_toast_on_save_failure_retry_allowed | รอบ 1 กดปุ่มบันทึกซ้ำขณะ SnackBar error ยังแสดงอยู่ SnackBar ลอยทับปุ่ม (ล่างจอ) จึงแตะโดน Toast ไม่โดนปุ่ม → `Expected 12000, Actual 8000` | รอ Toast หาย (pump 3 วินาที) แล้วจึงกดซ้ำ — พฤติกรรมโค้ดถูกตามเอกสาร (ดูข้อสังเกตในคำถามข้อ 10) |

## 7. คำถามถึงเอกสาร (ไม่นับเป็น bug)

1. **ค่าชั่วคราว** — กดปุ่มเพิ่มก้าว 1 ครั้งเพิ่มกี่ก้าว (ui-spec Q-2; Dev ใช้ 1,000) — เทสต์ใช้ค่าคงที่ จึงไม่ต้องแก้เทสต์เมื่อเปลี่ยนค่า
2. **AC-2 vs AC-4 vs game-rules §3** — AC-2 "นำไปคำนวณ % Goal ทันที" และ game-rules §3 "บันทึกเปลี่ยนเป้าหมายครั้งที่ 1 ของวัน … อัปเดต % Goal ทันที" ขัดกับ AC-4 "ปรับหลัง 05:00 มีผลรอบวันถัดไป" (ทุกเวลาในรอบวันอยู่หลัง 05:00) — Dev ตีความ: ตั้งครั้งแรกหรือช่วง 00:00–04:59 มีผลทันที, 05:00–23:59 มีผลวันถัดไป (เทสต์ `*ASSUMPTION*` ครอบไว้) ต้องการคำยืนยันและให้ย้ายกติกาลง game-rules.md
3. การตั้งเป้าหมายครั้งแรกหักโควต้า — ux-flow §3 ข้อ 5 และ game-rules §3 สนับสนุนการตีความของ Dev (นับ) — ขอยืนยันเพื่อปิดคำถาม
4. EC-3 ยอมรับ "ไม่ย้อนกว่าเวลาล่าสุดที่เคยเห็น" แทน Network/Server Time ใน MVP ได้หรือไม่
5. EC-4 Multi-device Sync ทดสอบ/ทำไม่ได้แบบ offline — ตัดออกจาก MVP หรือไม่
6. AC-1 "คลาดเคลื่อนไม่เกิน 5% จากฮาร์ดแวร์" (STEP_TOLERANCE_PCT) ไม่มีความหมายใน MVP ที่กรอกด้วยมือ (D-1) — ควรปรับ AC-1 สำหรับ MVP
7. ค่าเฉลี่ยรายวัน (AC-7) หารด้วยจำนวนวันที่มีก้าว > 0 (ที่ทำ) หรือจำนวนวันที่ผ่านไปของเดือน
8. "วันที่ทำเป้าหมายสำเร็จ" เทียบกับเป้าหมายของวันนั้น (ที่ทำ) ใช่หรือไม่
9. AC-2 เขียนกลุ่มควบคุมน้ำหนักเป็นช่วง "9,000 - 12,000" / นักกีฬา "13,000 - 15,000" แต่ ux-flow ให้เป็นชิปทีละ 1,000 — โค้ดปฏิเสธค่าระหว่างชิป (เช่น 9,500) ยืนยันว่าเลือกได้เฉพาะชิปหรือไม่
10. (ข้อสังเกต UX) SnackBar ของ S-2 (Toast error/โควต้า) ลอยทับปุ่ม "บันทึกเป้าหมาย" ประมาณ 2 วินาที ผู้ใช้ต้องรอ Toast หายจึง "ลองกดบันทึกซ้ำ" ได้ — เอกสารไม่ได้ห้าม แต่ควรพิจารณา (เช่น `SnackBarBehavior.floating`)
11. ข้อความที่ ui-spec เสนอรอยืนยัน: Pop-up สิทธิ์และปุ่ม 「ไปที่ Settings」 (Q-4), tooltip 「ออฟไลน์」 และเงื่อนไข trigger (Q-5), ปุ่ม 「เพิ่มก้าวเดิน」 (Q-1), หัวกลุ่ม S-2 (Q-9), หน่วยในการ์ด S-3 (Q-10), จังหวะ Toast โควต้า (Q-11), รูปแบบ % ตัดทิ้ง 2 ตำแหน่ง (Q-7)
12. ข้อมูลในเครื่องเสีย (เช่นเป้าหมายนอกช่วง 6,000–15,000) → กลับเป็น 8,000 ทีละคีย์ — เอกสาร steps ไม่ได้กำหนดพฤติกรรมข้อมูลเสีย (water กำหนดว่า "เริ่มใหม่เป็นค่าว่าง") ขอยืนยัน
13. PNG บันทึกในโฟลเดอร์ Documents ของแอปพอหรือต้องลง Gallery/Downloads และต้องมีข้อความแจ้งเมื่อสำเร็จหรือไม่ (ui-spec Q-14) — เทสต์ยืนยันได้เพียงว่า bytes PNG ถูกส่งให้ exporter 1 ครั้ง (ใช้ exporter ปลอม)
