# Test report: signup

> ผู้ทดสอบ: QA agent · วันที่ 2026-10-30 · อ้างอิง: requirements.md, game-rules.md, ux-flow.md, ui-spec.md, logs/20261030-1035_dev_signup.md, logs/20261030-1112_dev_signup.md (dev v2)
> เทสต์อยู่ใน `app/test/signup/` (3 ไฟล์) · รันด้วย `flutter test` จาก `app/` · ไม่ได้แก้โค้ดใน `app/lib/`
> **รอบ 2 (QA v2, 11:14–11:18):** dev แก้ BUG-1 และช่องอายุ (D-c) แล้ว — QA เพิ่ม 16 เทสต์ เปลี่ยนชื่อ 1 เทสต์ ไม่ได้เปลี่ยนค่าคาดหวังของเทสต์เดิม

## 0. ข้อตัดสิน (DECIDED)

| รหัส | สถานะ | เนื้อหา | ปิดคำถาม/ASSUMPTION |
|---|---|---|---|
| D-a | **DECIDED (owner ชั่วคราว)** รอทีมยืนยัน | Display Name จากอีเมลบันทึกชื่อหน้า @ เต็ม ไม่ตัด · ลิมิต 20 ตัวใช้เฉพาะ Display Name ที่ผู้ใช้พิมพ์เอง (EC-3) · AC-5 ย่อตอนแสดงผลจากชื่อเต็ม | คำถาม §5 ข้อ 1–2, BUG-1 |
| D-b | **DECIDED (owner ชั่วคราว)** รอทีมยืนยัน | ใช้ตามที่ dev ทำ: session บันทึกตอน signup/login, shared_preferences, ชื่อ 9 ตัวย่อตามกฎ (`alex...er`), PetCharacter แทน DEFAULT_PET | คำถาม §5 ข้อ 3–6, §4 ข้อ 1/7/9 |
| D-c | **DECIDED (ทีม)** | ในฟีเจอร์ signup อายุต้องเป็นจำนวนเต็มเท่านั้น | EC-2 ช่องอายุ |

## 1. สรุปตัวเลข

| รายการ | ค่า |
|---|---|
| เทสต์ signup | 114 (unit logic 36 · unit repository/controller 28 · widget 50) — รอบ 1 มี 98, รอบ 2 เพิ่ม 16 |
| ผ่าน / ไม่ผ่าน (signup) | 114 / 0 |
| `flutter test` ทั้งแอป | 410 เทสต์: ผ่าน 410 / ไม่ผ่าน 0 (เทสต์นอก signup 296 ผ่านทั้งหมด) |
| `flutter analyze test/signup` | No issues found |
| AC ทั้งหมด 8 ข้อ | 8 มีเทสต์ · ผ่านครบ 8 |
| EC ทั้งหมด 5 ข้อ | 5 มีเทสต์ · ผ่านทั้ง 5 |
| AC/EC ที่ยังไม่มีเทสต์ | ไม่มี |
| Bug | รวม 1 (BUG-1) — **แก้แล้ว (Fixed, QA verified รอบ 2)** · bug ใหม่รอบ 2: 0 |
| คำถามถึงเอกสาร | เดิม 6 → DECIDED ทั้ง 6 (D-a/D-b ชั่วคราว) · ใหม่ค้าง 1 (§5 ข้อ 7) |

ไฟล์: `signup_logic_test.dart` (L), `signup_repository_test.dart` (R), `signup_screens_test.dart` (W)

## 2. ตาราง AC/EC → เทสต์

| AC/EC | ชื่อเทสต์ (ไฟล์) | ผล |
|---|---|---|
| AC-1 | AC1_password_5_chars_abcde_shows_error_and_cannot_submit (L) | ผ่าน |
| AC-1 | AC1_password_1_char_shows_error (L) | ผ่าน |
| AC-1 | AC1_EDGE_password_exactly_6_no_error_can_submit (L) | ผ่าน |
| AC-1 | AC1_repository_rejects_signup_with_5_char_password (R) | ผ่าน |
| AC-1 | AC1_password_abcde_shows_error_immediately_button_disabled (W) | ผ่าน |
| AC-1 | AC1_EDGE_password_6_chars_no_error_button_enabled (W) | ผ่าน |
| AC-2 | AC2_signup_same_email_twice_second_is_rejected (R) | ผ่าน |
| AC-2 | AC2_google_with_email_registered_normally_links_and_goes_onboarding (R) | ผ่าน |
| AC-2 | AC2_google_link_goes_onboarding_even_if_profile_exists (R) | ผ่าน |
| AC-2 | AC2_route_onboarding_when_google_linked_even_with_profile (L) | ผ่าน |
| AC-2, EC-5 | AC2_EC5_registered_email_shows_email_in_use_stays_on_S2 (W) | ผ่าน |
| AC-2 | AC2_google_with_registered_email_links_and_goes_onboarding (W) | ผ่าน |
| AC-3 | AC3_new_password_5_rejected_6_accepted (L) | ผ่าน |
| AC-3 | AC3_controller_rejects_5_char_new_password_old_password_still_works (R) | ผ่าน |
| AC-3 | AC3_repository_rejects_short_password (R) | ผ่าน |
| AC-3 | AC3_EDGE_new_password_exactly_6_saved_and_usable (R) | ผ่าน |
| AC-3 | AC3_new_password_5_chars_shows_warning_and_save_rejected (W) | ผ่าน |
| AC-3 | AC3_EDGE_new_password_6_chars_saves_and_goes_S2_with_message (W) | ผ่าน |
| AC-4 | AC4_empty_display_name_uses_email_local_part (L) | ผ่าน |
| AC-4 | AC4_typed_display_name_is_kept (L) | ผ่าน |
| AC-4 | AC4_save_without_display_name_stores_email_local_part (R) | ผ่าน |
| AC-4, AC-5 | AC4_AC5_empty_display_name_alexander_banner_shows_alex_dots_er (W) | ผ่าน |
| AC-5 | AC5_alexander_truncates_to_alex_dots_er (L) | ผ่าน |
| AC-5 | AC5_EDGE_email_name_exactly_8_chars_not_truncated (L) | ผ่าน |
| AC-5 | AC5_EDGE_email_name_9_chars_truncated_4_dots_2 (L) | ผ่าน |
| AC-5 | AC5_display_for_ui_profile_from_email_alexander (L) | ผ่าน |
| AC-5 | AC5_long_email_name_over_20_shows_first4_dots_last2_of_email_name (L) | ผ่าน (รอบ 1 ไม่ผ่าน = BUG-1 → แก้แล้ว) |
| AC-4, AC-5, D-a | DECIDED_Da_email_name_over_20_saved_full_not_capped (L) — **ใหม่** | ผ่าน |
| AC-4, AC-5, D-a | DECIDED_Da_long_email_name_saved_full_home_shows_abcd_dots_yz (R) — **ใหม่** | ผ่าน |
| AC-4, AC-5, D-a | DECIDED_Da_long_email_name_banner_abcd_dots_yz_repo_stores_full (W) — **ใหม่** | ผ่าน |
| AC-5 | AC5_EDGE_email_name_8_chars_banner_shows_full_name (W) | ผ่าน |
| AC-6 | AC6_unspecified_gender_shows_warning_male_female_do_not (L) | ผ่าน |
| AC-6 | AC6_select_unspecified_shows_warning_male_hides_it (W) | ผ่าน |
| AC-6, AC-7 | AC6_AC7_warnings_do_not_block_save_values_stay_null (L) | ผ่าน |
| AC-6, AC-7 | AC6_AC7_warnings_do_not_block_save (W) | ผ่าน |
| AC-7 | AC7_empty_weight_only_warns_weight (L) | ผ่าน |
| AC-7 | AC7_empty_height_only_warns_height (L) | ผ่าน |
| AC-7 | AC7_empty_weight_warns_only_under_weight (W) | ผ่าน |
| AC-7 | AC7_empty_height_warns_only_under_height (W) | ผ่าน |
| AC-8 | AC8_route_loading_then_welcome_without_session (L) | ผ่าน |
| AC-8 | AC8_route_home_when_session_with_profile (L) | ผ่าน |
| AC-8 | AC8_reopen_with_same_store_restores_session_and_goes_home (R) | ผ่าน |
| AC-8 | AC8_token_is_stored_on_device_not_empty (R) | ผ่าน |
| AC-8 | AC8_reopen_app_skips_login_and_shows_home (W) | ผ่าน |
| AC-8 | UI_auth_loading_spinner_while_reading_token (W) | ผ่าน |
| EC-1 | EC1_google_network_error_then_retry_succeeds (R) | ผ่าน |
| EC-1 | EC1_google_network_error_shows_retry_then_retry_succeeds (W) | ผ่าน |
| EC-1 | EC1_retry_while_still_offline_shows_retry_again (W) | ผ่าน |
| EC-2 | EC2_age_1_and_120_valid (L) | ผ่าน |
| EC-2 | EC2_age_0_and_121_out_of_range (L) | ผ่าน |
| EC-2 | EC2_weight_1_and_300_valid_0_and_301_out_of_range (L) | ผ่าน |
| EC-2 | EC2_weight_float_just_outside_bounds_out_of_range (L) | ผ่าน |
| EC-2 | EC2_height_1_and_250_valid_0_and_251_out_of_range (L) | ผ่าน |
| EC-2 | EC2_any_out_of_range_field_blocks_save (L) | ผ่าน |
| EC-2 | EC2_controller_refuses_out_of_range_profile (R) | ผ่าน |
| EC-2 | EC2_age_0_shows_error_and_blocks_save (W) | ผ่าน |
| EC-2 | EC2_EDGE_age_120_ok_121_error (W) | ผ่าน |
| EC-2 | EC2_EDGE_age_1_ok (W) | ผ่าน |
| EC-2 | EC2_EDGE_weight_300_ok_301_error (W) | ผ่าน |
| EC-2 | EC2_EDGE_weight_1_ok_0_error (W) | ผ่าน |
| EC-2 | EC2_EDGE_height_250_ok_251_error (W) | ผ่าน |
| EC-2 | EC2_EDGE_height_1_ok_0_error (W) | ผ่าน |
| EC-2, D-c | DECIDED_Dc_age_non_integer_text_is_not_valid (L) — **ใหม่** ("25.5", "2.5", "-3", "abc", "+25", "0x19" → ไม่ valid / outOfRange, canSave = false) | ผ่าน |
| EC-2, D-c | DECIDED_Dc_buildProfile_non_integer_age_returns_null (L) — **ใหม่** (6 ค่าเดียวกัน → null) | ผ่าน |
| EC-2, D-c | DECIDED_Dc_EDGE_integer_age_25_still_valid (L) — **ใหม่** (คู่เทียบ "25" → valid, age 25) | ผ่าน |
| EC-2, D-c | DECIDED_Dc_controller_refuses_non_integer_age (R) — **ใหม่** (6 ค่า → SaveProfileOutcome.invalid, `profileFor` = null, ยังอยู่ S-6) | ผ่าน |
| EC-2, D-c | EDGE_Dc_stored_fractional_age_not_rounded_on_load (R) — **ใหม่** (ข้อมูลที่เก็บไว้ age 25.5 ต้องไม่ถูกโหลดเป็น 25/26, ไม่ค้าง loading) | ผ่าน |
| EC-2, D-c | DECIDED_Dc_age_field_rejects_"25.5"_not_changed_cannot_save (W) — **ใหม่** | ผ่าน |
| EC-2, D-c | DECIDED_Dc_age_field_rejects_"2.5"_not_changed_cannot_save (W) — **ใหม่** | ผ่าน |
| EC-2, D-c | DECIDED_Dc_age_field_rejects_"-3"_not_changed_cannot_save (W) — **ใหม่** | ผ่าน |
| EC-2, D-c | DECIDED_Dc_age_field_rejects_"abc"_not_changed_cannot_save (W) — **ใหม่** | ผ่าน |
| EC-2, D-c | DECIDED_Dc_age_field_existing_30_then_paste_2_5_never_saves_25 (W) — **ใหม่** | ผ่าน |
| EC-2, D-c | DECIDED_Dc_EDGE_age_field_integer_25_saves_25 (W) — **ใหม่** (คู่เทียบ) | ผ่าน |
| EC-3 | EC3_display_name_20_chars_accepted_21st_blocked (W) | ผ่าน |
| EC-3, D-a | DECIDED_Da_EC3_typed_display_name_20_kept_21_capped_to_20 (L) — **ใหม่** | ผ่าน |
| EC-3, D-a | DECIDED_Da_EC3_typed_20_char_name_saved_as_typed (W) — **ใหม่** | ผ่าน |
| EC-4 | EC4_save_network_error_keeps_onboarding_then_retry_saves (R) | ผ่าน |
| EC-4 | EC4_save_network_error_shows_retry_and_keeps_all_values (W) | ผ่าน |
| EC-4 | EC4_retry_after_network_back_saves_and_goes_home (W) | ผ่าน |
| EC-5 | EC5_signup_with_registered_email_returns_email_in_use (R) | ผ่าน |

วิธีตรวจช่องอายุ (widget, D-c): หลัง `enterText` ลง `signup_age_field` ยอมรับ 2 แบบที่ไม่ขัด D-c คือ (ก) ปฏิเสธ ช่องคงค่าเดิม หรือ (ข) แสดงตามที่พิมพ์พร้อม `signup_age_error_text` — ห้ามกลายเป็นค่าอื่น ("255", "25", "3", ...) และปุ่มบันทึกต้อง disabled, กดแล้ว `repo.profileFor(...)` ต้องเป็น null และยังอยู่ S-6 โค้ดปัจจุบันเป็นแบบ (ก)

### เทสต์อื่น (ข้อความ UI ตาม ux-flow, flow, edge case ข้อมูลว่าง/เสีย, regression) — ผ่านทั้งหมด
- กติกา: RULES_game_rules_s1_constants_match_doc (L), DEFAULT_health_goal_saved_as_dulae_sukkhaphap (L), UXFLOW_step4_new_account_without_profile_goes_onboarding (L), US4_save_stores_all_fields (R), REQ6_password_is_stored_hashed_not_plain (R)
- ข้อความ/การนำทางตาม ux-flow: UI_S1_texts_per_ux_flow_and_first_open_shows_welcome, UI_S1_email_button_opens_S2_signup_mode, UI_S1_have_account_link_opens_S2, UI_S2_hints_and_initial_state_button_disabled_no_error, UI_S2_back_button_returns_to_S1, UXFLOW_happy_path_signup_goes_to_onboarding_S6, US3_forgot_flow_S2_to_S3_to_S4_and_back_to_S2, UI_S3_back_button_returns_to_S2, UI_S5_texts_and_initial_disabled, UI_S6_texts_and_defaults_gender_unspecified_goal_default (W), US3_request_password_reset_is_recorded, LOGIN_registered_account_without_profile_goes_onboarding (R)
- ข้อมูลว่าง/เสีย/เปิดครั้งแรก: EDGE_first_open_empty_storage_goes_welcome, EDGE_corrupt_session_data_goes_welcome_without_crash, EDGE_session_for_missing_account_goes_welcome, EDGE_Dc_stored_fractional_age_not_rounded_on_load (ใหม่), US5_sign_out_clears_session_reopen_goes_welcome (R), EDGE_corrupt_stored_session_opens_S1_without_crash (W)
- Regression: REGRESSION_no_signup_controller_goes_straight_to_water (W)

### เทสต์ ASSUMPTION_ — ตรวจรอบ 2 เทียบ D-a / D-b / D-c
ไม่มีเทสต์ ASSUMPTION_ ตัวใดขัดกับข้อตัดสิน จึงไม่ได้เปลี่ยนค่าคาดหวังของเทสต์ใด

| เทสต์ (ไฟล์) | ผลตรวจ | การเปลี่ยนแปลง |
|---|---|---|
| ASSUMPTION_19_reopen_before_onboarding_goes_onboarding (R) | ตัดสินแล้วโดย D-b (session บันทึกตอน signup/login) | **เปลี่ยนชื่อ** → `DECIDED_Db_19_session_saved_at_signup_reopen_before_onboarding_goes_onboarding` (ผ่าน, ค่าคาดหวังเดิม) |
| ASSUMPTION_Q11_empty_age_blocks_save (L) | D-c ตัดสินเรื่องจำนวนเต็ม ไม่ได้ตัดสินกรณีอายุว่าง | คงเดิม (ผ่าน) |
| ASSUMPTION_Q3_empty_password_no_error_but_cannot_submit, ASSUMPTION_Q10_cleared_health_goal_saves_default, ASSUMPTION_unknown_gender_code_falls_back_to_unspecified (L) | ไม่เกี่ยวกับ D-a/b/c | คงเดิม (ผ่าน) |
| ASSUMPTION_7_email_duplicate_is_case_insensitive, ASSUMPTION_2_wrong_password_returns_invalid_credentials (R) | ไม่เกี่ยว | คงเดิม (ผ่าน) |
| ASSUMPTION_Q4_email_in_use_error_clears_when_email_edited, ASSUMPTION_Q15_loading_spinner_and_disabled_while_submitting, ASSUMPTION_3_S2_network_error_dialog_retry_succeeds, ASSUMPTION_Q16_retry_dialog_texts (W) | ไม่เกี่ยว | คงเดิม (ผ่าน) |

เทสต์ AC เดิมที่ตอนนี้ยืนยันข้อตัดสินด้วย (ไม่เปลี่ยนชื่อเพราะเป็นเทสต์ AC ตรง): `AC5_EDGE_email_name_9_chars_truncated_4_dots_2` และ `AC5_alexander_truncates_to_alex_dots_er` (D-b ชื่อ 9 ตัวย่อตามกฎ), `AC8_token_is_stored_on_device_not_empty` (D-b — เทสต์ใช้ InMemoryAuthLocalStore ไม่ได้ตรวจชนิด storage), `AC5_long_email_name_over_20_...` (D-a)

## 3. Bug

### BUG-1 (ความรุนแรง: ต่ำ) — สถานะ: **แก้แล้ว (Fixed by dev v2, QA verified รอบ 2 เวลา 11:16)** — AC-5 ตัดคำผิดเมื่อชื่อหน้าอีเมลยาวเกิน 20 ตัว
- ขั้นตอนทำซ้ำ: สมัครด้วย `abcdefghijklmnopqrstuvwxyz@email.com` (ชื่อหน้าอีเมล 26 ตัว) → S-6 เว้น Display Name ว่าง กรอกอายุ 30 → บันทึก → ดูแบนเนอร์ S-7 (`signup_home_welcome_text`) / หรือเรียก `SignupLogic.displayNameForUi(profile)`
- ผลที่คาด (requirements AC-5 + D-a): บันทึก `abcdefghijklmnopqrstuvwxyz` เต็ม และแสดง `abcd...yz`
- ผลจริงรอบ 1: `abcd...st` (ชื่อถูกตัดเหลือ 20 ตัวก่อนบันทึก)
- ผลจริงรอบ 2: แสดง `abcd...yz` และ `profile.displayName == 'abcdefghijklmnopqrstuvwxyz'` — ยืนยันด้วย `AC5_long_...` (L), `DECIDED_Da_email_name_over_20_saved_full_not_capped` (L), `DECIDED_Da_long_email_name_saved_full_home_shows_abcd_dots_yz` (R), `DECIDED_Da_long_email_name_banner_abcd_dots_yz_repo_stores_full` (W)

### Bug ใหม่รอบ 2
ไม่พบ — ช่องอายุ "25.5", "2.5", "-3", "abc" ไม่ถูกเปลี่ยนค่าและบันทึกไม่ได้ · logic ปฏิเสธ "+25", "0x19" ด้วย · Display Name ที่พิมพ์เองยังจำกัด 20 ตัว

## 4. ASSUMPTION ของ Dev ที่เกี่ยวกับ AC/EC (ไม่นับเป็น bug)
1. **DECIDED (owner ชั่วคราว D-b)** AC-8 / requirements §6 กำหนด Token ใน "Secure Storage" แต่โค้ดเก็บใน shared_preferences — เทสต์ AC-8 ตรวจว่า token ถูกเก็บในเครื่องและเปิดใหม่ข้าม Login ได้ ไม่ได้ตรวจชนิด storage
2. AC-1 "5 ตัวหรือน้อยกว่า" — ช่องว่าง (0 ตัว) ไม่แสดง error แต่ปุ่ม disabled (ui-spec Q-3)
3. EC-2 ข้อความ error ช่วงค่า และอายุว่างบล็อกการบันทึกโดยไม่มีข้อความ (ui-spec Q-11) — เทสต์ EC-2 ตรวจแค่ key ของ error ไม่ตรวจข้อความ
4. EC-1/EC-4 ข้อความ dialog และปุ่ม 「ลองใหม่อีกครั้ง」 (ui-spec Q-16)
5. AC-2 Google linking พาไป S-6 แม้บัญชีมีโปรไฟล์แล้ว (Dev คำถาม 4) — เทสต์ยึด AC-2 ตรงตัว "พาไปหน้า Onboarding ทันที"
6. แบนเนอร์ 「สวัสดี <ชื่อ>」 (ui-spec Q-12) — เทสต์ตรวจแค่ว่ามีชื่อที่ประมวลผลแล้วอยู่ในข้อความ
7. **DECIDED (owner ชั่วคราว D-b)** Session ถูกบันทึกตั้งแต่สมัคร/ล็อกอิน ไม่ใช่ตอนจบ Onboarding (Dev ASSUMPTION 19) — เทสต์เปลี่ยนชื่อเป็น `DECIDED_Db_19_...`
8. ข้อความเข้าสู่ระบบผิด 「อีเมลหรือรหัสผ่านไม่ถูกต้อง」 เป็นค่าชั่วคราวของ Dev (ASSUMPTION 2)
9. **DECIDED (owner ชั่วคราว D-b)** DEFAULT_PET (game-rules §2) ใช้ PetCharacter ไม่ใช้ PNG — ไม่ได้ทดสอบภาพ
10. (ใหม่ dev v2) ช่องอายุปฏิเสธการพิมพ์/วางที่มีอักขระที่ไม่ใช่ตัวเลขทั้งก้อนโดยไม่แสดงข้อความ — เทสต์ widget ยอมรับทั้งแบบปฏิเสธและแบบแสดง error จึงไม่ผูกกับ assumption นี้
11. (ใหม่ dev v2) ข้อความอายุที่ไม่ใช่จำนวนเต็ม (ทาง logic) ใช้สถานะ `outOfRange` (แสดง error ช่วงอายุ) — เทสต์ logic ตรวจทั้ง "ไม่ valid" (ตาม D-c) และ `outOfRange` (สถานะเดียวที่บล็อกการบันทึกใน `NumberFieldStatus`)

## 5. คำถามถึงเอกสาร
> รอบ 2: ข้อ 1–2 → **DECIDED (owner ชั่วคราว D-a)** · ข้อ 3–6 → **DECIDED (owner ชั่วคราว D-b)** — ยังต้องให้ทีมยืนยัน และปรับเอกสารให้ตรงข้อตัดสิน (requirements §6 Display Name Max 20, game-rules §3 `display_name = "alex...er"`, game-rules §2 DEFAULT_PET, ux-flow §3 ข้อ 6, requirements AC-8 Secure Storage)

1. [DECIDED D-a: บันทึก `alexander` แสดง `alex...er`] game-rules §3 แถว "ไม่กรอก Display Name … alexander@email.com" บอกค่าหลัง `display_name = "alex...er"` แต่ requirements AC-4 บอก "บันทึกค่า Display Name เป็นชื่อหน้าอีเมล" (= `alexander`) — ค่าที่บันทึกคือ `alexander` หรือ `alex...er`?
2. [DECIDED D-a: บันทึกเต็ม ลิมิต 20 ใช้กับชื่อที่พิมพ์เอง AC-5 ย่อจากชื่อเต็ม] ชื่อหน้าอีเมลยาวเกิน 20 ตัว: AC-4 บอกใช้ชื่อหน้าอีเมล แต่ requirements §6 บอก Max 20 — ควรบันทึกอย่างไร และ AC-5 ตัดคำจากชื่อเต็มหรือค่าที่บันทึก
3. [DECIDED D-b: บันทึกตอน signup/login → ปิดแอประหว่าง Onboarding เปิดใหม่ไป S-6] ux-flow §3 ข้อ 6 บอกบันทึก Token ตอนจบ Onboarding แต่ AC-8 บอก "หลังล็อกอินสำเร็จ"
4. [DECIDED D-b: shared_preferences] AC-8 "Secure Storage" ยอมรับ shared_preferences ใน MVP หรือไม่
5. [DECIDED D-b: ย่อตามกฎ] AC-5 กับชื่อ 9 ตัว ผลยาวเท่าเดิม (`alexander` 9 ตัว → `alex...er` 9 ตัว) ตั้งใจหรือไม่ (ui-spec Q-20)
6. [DECIDED D-b: PetCharacter] game-rules §2 DEFAULT_PET ใช้ PNG แต่ owner ตัดสินให้ใช้ PetCharacter — ควรปรับ game-rules ให้ตรง
7. (ใหม่รอบ 2 — ค้าง) D-c ยังไม่ถูกเขียนลงเอกสาร (เช่น EC-2 / requirements §6 "อายุจำนวนเต็มเท่านั้น") และ ui-spec §2.6 #6 ไม่ได้ระบุพฤติกรรมเมื่อพิมพ์/วางค่าอายุที่ไม่ใช่จำนวนเต็ม (ปฏิเสธเงียบ ๆ หรือแสดงข้อความ) — เทสต์ปัจจุบันยอมรับทั้งสองแบบ

## 6. ผลรันทั้งหมด

| รอบ | คำสั่ง | ผล |
|---|---|---|
| 1 | `flutter test test/signup` | 94 ผ่าน / 4 ไม่ผ่าน (3 = helper ในเทสต์ผิด, 1 = BUG-1) |
| 2 | `flutter test test/signup/signup_logic_test.dart --plain-name AC5_long` | ยืนยันรายละเอียด BUG-1 (Expected `abcd...yz`, Actual `abcd...st`) |
| 3 | `flutter test test/signup` (หลังแก้ helper) | 97 ผ่าน / 1 ไม่ผ่าน (BUG-1) |
| 4 | `flutter test` (ทั้งแอป) | 394 เทสต์: 393 ผ่าน / 1 ไม่ผ่าน (BUG-1) — เทสต์เดิม 296 ผ่านครบ |
| 5 (รอบ 2) | `flutter test test/signup` 11:15:40–11:16:03 | 114 ผ่าน / 0 ไม่ผ่าน |
| — (รอบ 2) | `flutter analyze test/signup` | No issues found |
| 6 (รอบ 2) | `flutter test` (ทั้งแอป) 11:16:16–11:17:04 | **410 เทสต์: 410 ผ่าน / 0 ไม่ผ่าน** (296 เดิม + 114 signup) |

รอบ 2: เทสต์ใหม่ 16 (L 5 · R 3 · W 8 โดย W มี 4 เทสต์ที่สร้างจาก loop เดียว) · เปลี่ยนชื่อ 1 · QA แก้เทสต์เพราะเทสต์ผิด 0 · ไม่ได้เปลี่ยนค่าคาดหวังของเทสต์เดิม

เทสต์ที่ QA แก้เอง (เทสต์ผิด) รอบ 1: 3 เทสต์ (`AC6_select_unspecified_shows_warning_male_hides_it`, `AC7_empty_weight_warns_only_under_weight`, `AC7_empty_height_warns_only_under_height`) — สาเหตุ helper `textOf` cast เป็น `Text` แต่ warning เป็น widget `SignupWarningText` (ห่อ `Text`) แก้ helper ให้อ่าน `Text` ข้างใน ไม่ได้เปลี่ยนค่าคาดหวัง
