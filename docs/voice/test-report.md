# Test report: เสียงพากย์น้องอ๊บ (voice) — QA รอบ 1

> วันที่ 2026-11-12 · ผู้ทดสอบ: QA agent · worktree `claude/voice-feature-setup-f3e514` (ไม่ commit)
> อ้างอิง: requirements.md, ux-flow.md, game-rules.md, ui-spec.md (§0, §2.4.3 VT-1..VT-16, §7), logs/20261112-1043_owner_voice.md (V-1..V-10 ชนะเอกสาร), logs/20261112-1113_dev_voice.md
> ค่าคาดหวังทั้งหมดพิมพ์จากเอกสารใน `app/test/voice/voice_qa_docs.dart` (ไม่ import ค่าจาก `VoiceRules`) · TTS ใช้ `FakeVoiceTtsEngine` เท่านั้น · เวลาใช้ clock ที่ส่งเข้า + `FakeTimers` / `tester.pump(Duration)`

## ไฟล์เทสต์ของ QA

| ไฟล์ | ชนิด | จำนวนเทสต์ |
|---|---|---|
| `app/test/voice/voice_qa_logic_test.dart` | unit (logic + controller + SharedPrefs repository) | 76 |
| `app/test/voice/voice_qa_screens_test.dart` | widget (S-1 dialog, S-2 dashboard, S-3 หน้าตั้งค่า) | 45 |
| `app/test/voice/voice_qa_static_test.dart` | ตรวจไฟล์โปรเจกต์ (pubspec, manifest, ไม่มี network/asset, ไม่สร้าง engine จริงในเทสต์) | 12 |
| `app/test/voice/voice_qa_docs.dart` | ค่าคาดหวังจากเอกสาร (ไม่ใช่ไฟล์เทสต์) | — |
| เทสต์เดิมของ Dev (`voice_logic_controller_test.dart`, `voice_screens_test.dart`) | ไม่แก้ | 26 |

## ตาราง AC / EC → เทสต์

| AC / EC (ตามที่ DECIDED แทนที่แล้ว) | ชื่อเทสต์ (QA) | ผล |
|---|---|---|
| AC-1 dialog ครั้งแรก, บันทึก, ไม่แสดงซ้ำ | `AC1_UX_S1_exact_texts_and_button_types`, `AC1_enable_saves_true_true_closes_not_shown_again`, `AC1_disable_saves_false_false_closes_not_shown_again`, `AC1_shared_prefs_persisted_dialog_not_shown_after_restart`, `UX_S1_barrier_tap_and_back_do_not_dismiss`, `MAXMIN_S1_double_tap_saves_once`, `DECIDED_V1_V9_dialog_pet_is_PetCharacter_no_png`, `DECIDED_V5_Q17_after_notification_allow_then_voice_dialog`, `GR3_row1_answer_enable_sets_true_true`, `GR3_row2_answer_disable_sets_false_false`, `AC1_saves_bool_keys_and_round_trips`, `AC1_disable_saves_false_false` | ผ่าน |
| AC-2 steps < 35% → lazy | `GR3_steps_34.99% → lazy (AC-2)`, `GR2_steps_0.00%_is_lazy`, `AC2_steps_34.99pct_speaks_lazy_exact`, `AC2_steps_34.99pct_bubble_and_speech_exact`, `AC2_steps_0pct_bubble_and_speech_exact` | ผ่าน |
| AC-3 steps 70–99.99% → encouraging | `GR3_steps_70.00% / 99.00% / 99.99%`, `AC3_steps_70pct_speaks_encouraging_exact`, `AC3_steps_99.99pct_speaks_encouraging_exact`, `AC3_steps_70.00pct_bubble_and_speech_exact`, `AC3_steps_99.99pct_bubble_and_speech_exact` | ผ่าน |
| AC-4 steps ≥ 100% → success | `GR3_steps_100.00% / 125.00%`, `MAXMIN_steps_far_above_goal_still_success`, `AC4_steps_100pct_speaks_success_exact`, `AC4_steps_100.00pct_bubble_and_speech_exact`, `AC4_steps_125pct_bubble_and_speech_exact` | ผ่าน |
| AC-5 food > 100 kcal → overeating | `GR3_food_over_limit_overeating (AC-5)`, `AC5_food_over_speaks_overeating_exact`, `AC5_food_excess_101kcal_bubble_and_speech_exact` (FoodController จริง เป้า 2,000 → 2,101), `GR3_food_excess_exactly_100kcal_no_trigger_no_bubble` (2,100), `DECIDED_V10_Q19_no_food_target_5000kcal_no_food_line` | ผ่าน |
| AC-6 water < 3 → low | `GR3_water_0_cups`, `GR3_water_2_cups`, `DECIDED_V10_Q20_negative_water_is_low`, `AC6_water_2_speaks_low_exact`, `AC6_water_2/0_bubble_and_speech_exact` | ผ่าน |
| AC-7 water ≥ 8 → success | `GR3_water_8_cups`, `GR3_water_12_cups`, `AC7_water_8_speaks_success_exact`, `AC7_water_8_bubble_and_speech_exact` | ผ่าน |
| AC-2..7 ปิดเสียง = ไม่พูด | `AC2_7_master_off_never_speaks_any_line`, `AC2_7_master_off_no_speech_no_bubble` | ผ่าน |
| AC-8 (V-2, V-3) หน้าเดียวมีสวิตช์ 2 ตัว ใช้ได้ บันทึก | `AC8_DECIDED_V2_two_switches_voice_on_top_exact_labels`, `AC8_EC5_voice_switch_toggles_and_saves_after_300ms`, `AC8_DECIDED_V3_notification_switch_works_no_300ms_debounce` | ผ่าน |
| EC-1 Mute (Q-22 — แอปตรวจ Mute ไม่ได้) | `EC1_mute_speak_completes_silently_no_crash_normal_flow` (ตรวจได้แค่ว่าไหลตามปกติไม่แครช — เสียงจริงต้องดูบน emulator) | ผ่าน |
| EC-2 คิว FIFO ไม่ทับ, Cooldown 0 | `EC2_GR3_last_row_water8_steps100_fifo_water_then_steps_no_overlap`, `EC2_DECIDED_V10_Q10_three_topics_order_water_steps_food`, `EC2_fifo_across_separate_evaluations (detection order)`, `EC2_VT8_bubble_water_then_steps_fifo`, `MAXMIN_repeat_evaluate_same_input_does_not_grow_queue` | ผ่าน |
| EC-3 (V-6a) ไม่มีเสียงไทย / TTS error → ข้ามเงียบ | `EC3_DECIDED_V6a_no_thai_voice_silent_skip_no_bubble_ever`, `EC3_DECIDED_V6a_prepare_throws_silent_skip`, `EC3_prepare_called_once_per_controller`, `EC3_DECIDED_V6a_speak_error_on_first_skips_to_next`, `EC3_stop_throws_does_not_crash_on_master_off`, `EC3_DECIDED_V6a_no_thai_voice_dashboard_no_bubble_no_crash`, `EC3_speak_throws_dashboard_no_crash_next_line` | ผ่าน |
| EC-4 (V-6a) ไม่ต่อเน็ต | `EC4_DECIDED_V6a_no_network_code_in_features_voice`, `EC4_DECIDED_V7_no_new_network_package_in_pubspec`, `DECIDED_V6a_voice_logic_is_pure_no_flutter_plugin_prefs` | ผ่าน |
| EC-5 debounce 300 ms (สวิตช์เสียงเท่านั้น — V-3) | `EC5_single_toggle_saves_at_exactly_300ms_not_299`, `EC5_each_tap_restarts_300ms_window`, `EC5_VT15_four_taps_end_same_value_zero_saves`, `EC5_taps_spaced_over_300ms_each_saved`, `EC5_dispose_during_debounce_flushes_last_value`, `EC5_flushPendingSave_saves_immediately_once`, `EC5_rapid_4_taps_end_on_zero_saves_3_taps_one_save_false`, `EC5_back_before_300ms_flushes_value`, `MAXMIN_set_same_value_repeatedly_no_save_no_notify` | ผ่าน |
| game-rules §1.1 ล้างคิวเมื่อปิดเสียง | `GR11_master_off_while_speaking_stops_and_clears_queue`, `GR11_cleared_lines_not_replayed_after_turning_back_on`, `GR11_after_clear_queue_works_again_for_new_band`, `GR11_turn_off_in_settings_while_dashboard_speaking_clears` | ผ่าน |
| V-4 จังหวะพูด / ข้ามวัน 05:00 | `DECIDED_V4_same_band_twice_no_repeat`, `DECIDED_V4_none_band_counts_low_none_low_speaks_again`, `DECIDED_V4_low_to_success_speaks_success`, `DAY_midnight_is_not_a_new_day`, `DAY_04:59_same_day_05:00_new_day_speaks_again`, `DAY_new_day_in_none_band_no_speak_but_band_recorded`, `DAY_bands_older_than_one_day`, `DAY_controller_speaks_same_band_again_after_05:00`, `DAY_stored_bands_from_yesterday_do_not_block_today`, `DECIDED_V4_restart_same_day_no_repeat`, `DECIDED_V4_restart_same_day_shared_prefs_no_repeat_next_day_repeats`, `DECIDED_V4_value_change_while_open_speaks_new_band`, `DECIDED_V4_reopen_dashboard_same_values_no_repeat`, `DECIDED_V10_Q08_bands_recorded_while_off_no_backfill_on_enable` | ผ่าน |
| V-6 ค่า TTS (th-TH, pitch 1.5, volume 0.80) | `DECIDED_V6_tts_language_pitch_volume_values`, `DECIDED_V6_engine_applies_th_TH_pitch_volume_in_order_no_speech_rate`, `DECIDED_V6_six_lines_ids_without_mp3_and_exact_texts` | ผ่าน |
| V-6b / V-1 ไม่มี assets/audio, mp3, PNG | `DECIDED_V6b_no_assets_audio_folder_no_mp3_files`, `DECIDED_V6b_pubspec_has_no_audio_asset_entry`, `DECIDED_V1_no_png_or_asset_image_in_voice_code` | ผ่าน |
| V-7 pin flutter_tts / ไม่มี uses-permission ใหม่ / `<queries>` TTS | `DECIDED_V7_flutter_tts_pinned_single_exact_version` (pubspec `4.2.5` = lock `4.2.5`), `DECIDED_V7_no_new_uses_permission_in_manifest`, `DECIDED_V7_tts_service_query_intent_inside_queries` | ผ่าน |
| V-5 null controller = พฤติกรรมเดิม | `DECIDED_V5_null_controller_no_dialog_on_home`, `DECIDED_V5_PetPalApp_without_voice_no_dialog`, `DECIDED_V5_null_controller_dashboard_unchanged`, `DECIDED_V5_settings_without_voice_one_switch_via_gear` + เทสต์เดิมทั้งแอปผ่าน (รวม `DECIDED_D2_*` และ `find.byType(Switch), findsOneWidget` ของ notification) | ผ่าน |
| V-9 / Q-07 เสียงไม่เปลี่ยนท่า ไม่ขยับ layout | `DECIDED_V9_Q07_pet_pose_and_position_unchanged_while_speaking` | ผ่าน |
| Q-13 แอปไป background = หยุด + ล้างคิว | `DECIDED_V10_Q13_app_paused_stops_and_clears` | ผ่าน |
| ux-flow §4 S-3 ERROR บันทึกไม่สำเร็จ | `UX_S3_ERROR_save_fails_revert_and_toast_2s` | ผ่าน |
| ข้อมูลว่าง / เสีย (EMPTY / CORRUPT) | `EMPTY_first_launch_defaults_unanswered_master_off`, `EMPTY_load_twice_reads_repository_once`, `EMPTY_no_keys_unanswered_false_null`, `CORRUPT_wrong_types_treated_as_missing`, `CORRUPT_day_bands_bad_day_or_not_object_is_null`, `CORRUPT_day_bands_corrupt_then_controller_still_speaks`, `EMPTY_UX_S1_ERROR_load_throws_dialog_still_shown`, `EMPTY_UX_S1_ERROR_corrupt_prefs_dialog_shown`, `DECIDED_V10_Q16_answer_save_fails_keeps_memory_no_throw`, `evaluate_before_load_does_nothing` | ผ่าน |
| storage keys (V-3, V-6b) | `DECIDED_V3_V6b_only_voice_keys_written_no_shortcut_or_path_key` | ผ่าน |
| ui-spec §2.4.5 ห้ามสร้าง FlutterTtsVoiceEngine ในเทสต์ | `NO_FlutterTtsVoiceEngine_constructed_in_any_test` | ผ่าน |

### game-rules §3 ตัวเลขขอบ (ทุกแถว)

| ค่า | ผลที่คาด (เอกสาร) | เทสต์ | ผล |
|---|---|---|---|
| steps 34.99% (3,499/10,000) | lazy | `GR3_steps_34.99% → lazy (AC-2)` + widget `AC2_steps_34.99pct_*` | ผ่าน |
| steps 35.00% (3,500) | ไม่พูด | `GR3_steps_35.00% → no trigger` + widget `GR3_steps_35.00pct_no_trigger_no_bubble` | ผ่าน |
| steps 69.99% (6,999) | ไม่พูด | `GR3_steps_69.99% → no trigger` + widget | ผ่าน |
| steps 70.00% (7,000) | encouraging | `GR3_steps_70.00% → encouraging (AC-3)` + widget | ผ่าน |
| steps 99.00% / 99.99% | encouraging | `GR3_steps_99.00%`, `GR3_steps_99.99%` + widget | ผ่าน |
| steps 100.00% | success | `GR3_steps_100.00% → success (AC-4)` + widget | ผ่าน |
| steps 125.00% | success | `GR3_steps_125.00% → success` + widget | ผ่าน |
| steps ขอบที่เป้าไม่กลม (8,000 / 3,333) | ตามเกณฑ์ % | `GR3_steps_non_round_goal_8000_boundaries`, `GR3_steps_fractional_percent_goal_3333` | ผ่าน |
| food เกิน 100 kcal พอดี (2,100 / เป้า 2,000) | ไม่พูด | `GR3_food_excess_exactly_100kcal_no_trigger_no_bubble` | ผ่าน |
| food เกิน 100.01 → ทดสอบที่ 101 kcal (2,101) | overeating | `AC5_food_excess_101kcal_bubble_and_speech_exact` | ผ่าน (ดูคำถาม Q-QA-1) |
| water 2 / 3 / 7 / 8 แก้ว | low / ไม่พูด / ไม่พูด / success | `GR3_water_2/3/7/8_cups` + widget `AC6_water_2_*`, `GR3_water_3/7_*`, `AC7_water_8_*` | ผ่าน |
| water 8 + steps 100% พร้อมกัน | water ก่อน แล้ว steps ทันที | `EC2_GR3_last_row_*`, `EC2_VT8_bubble_water_then_steps_fifo` | ผ่าน |
| สวิตช์ ON→OFF หลัง debounce 300 ms | บันทึก false | `EC5_single_toggle_saves_at_exactly_300ms_not_299` | ผ่าน |

## สรุปตัวเลข (จากการรันจริงรอบสุดท้าย)

| รายการ | ค่า |
|---|---|
| `flutter analyze` (app/) | No issues found! |
| `flutter test` ทั้งแอป (app/) | **1115 ทั้งหมด / 1115 ผ่าน / 0 ไม่ผ่าน** (`01:47 +1115: All tests passed!`) |
| ในจำนวนนี้: เทสต์ voice | 159 = Dev 26 + QA 133 |
| เทสต์เดิมของแอปก่อน QA (Dev log) | 982 → +133 ของ QA = 1115 |
| AC ที่ยังไม่มีเทสต์ | **0** (AC-1..AC-8, EC-1..EC-5 มีเทสต์ทุกข้อ) |
| ข้อจำกัด | EC-1 (Mute) และเสียงจริงของ TTS/เสียงไทยบนเครื่อง ตรวจใน `flutter test` ไม่ได้ (ไม่มี platform channel) — ต้องดูบน emulator ตามลำดับงาน |

## รายการ bug

ไม่พบ bug ในรอบนี้ (0) — ทุกเทสต์ที่ล้มระหว่างทางเป็นความผิดของเทสต์เอง (ดูด้านล่าง)

## เทสต์ที่ QA แก้เองเพราะเทสต์ผิด (5)

1. `DECIDED_V6b_no_assets_audio_folder_no_mp3_files` — สแกน `.` ทั้งโฟลเดอร์แล้วเจอ `PathNotFoundException` ใน `build/` (ไฟล์ generated) → จำกัดการสแกนเฉพาะ `lib/ test/ assets/ android/app/src/ web/`
2. `DECIDED_V7_flutter_tts_pinned_single_exact_version` — regex อ่าน `pubspec.lock` ไม่เจอเพราะไฟล์เป็น CRLF → แปลง `\r\n` เป็น `\n` ก่อนอ่าน
3. `EC5_back_before_300ms_flushes_value` — `pageBack()` เจอปุ่มย้อนกลับ 2 ปุ่ม (dashboard + หน้าตั้งค่า) และการ pop ผ่าน Navigator ใช้ transition 300 ms จึงแยกจาก debounce ไม่ได้ → เปลี่ยนเป็นถอดหน้าออกทันทีที่ 50 ms แล้วตรวจว่าบันทึกทันที 1 ครั้ง
4. `GR11_turn_off_in_settings_while_dashboard_speaking_clears` — `pageBack()` กำกวมแบบเดียวกัน → ใช้ `handlePopRoute()` (ปุ่ม back ของระบบ)
5. `UX_S3_ERROR_save_fails_revert_and_toast_2s` — `pump(1900ms)` ครั้งเดียวทำให้ timer ของ SnackBar เริ่มช้าในเทสต์ (timer เริ่มที่เฟรมหลัง animation เข้าเสร็จ) → วัดแบบเทสต์ water เดิม: รอ animation เข้าเสร็จ (วัดได้ 260 ms) → 1,990 ms ยังแสดง → 2,000 ms เริ่มหาย

(นอกจากนี้แก้ syntax ที่สคริปต์แก้ไฟล์ของ QA ทำพัง 1 ครั้ง และลบ import ที่ไม่ใช้ 2 บรรทัดตาม `flutter analyze` — ไม่นับเป็นเทสต์ผิด)

## คำถามถึงเอกสาร (ไม่นับเป็น bug — ใช้ค่าชั่วคราวแล้ว)

| # | ประเด็น | ทางที่ QA เลือกชั่วคราว |
|---|---|---|
| Q-QA-1 | game-rules §3 ใช้ `food_excess = 100.01 kcal` แต่แคลอรี่ในแอปเป็นจำนวนเต็ม (`FoodController.totalCalories: int`) จึงสร้าง 100.01 ไม่ได้ | ทดสอบ 100 (ไม่พูด) กับ 101 (พูด) = ขอบ + 1 หน่วยเล็กสุด · "เกิน" นับจาก `total > target + 100` ตาม Q-19 |
| Q-QA-2 | ux-flow S-3 / game-rules §3 แถวสุดท้ายยังเขียนว่าสวิตช์ Push Notification มี debounce 300 ms แต่ V-3 บอกว่าใช้กับสวิตช์เสียงเท่านั้น | ทดสอบตาม V-3: สวิตช์แจ้งเตือนบันทึกก่อนครบ 300 ms (`AC8_DECIDED_V3_*`) · ขอ Design แก้เอกสาร (ui-spec Q-27) |
| Q-QA-3 | V-6a "ห้ามต่อเน็ต": โค้ดไม่มี network และไม่เรียก `setEngine` แต่บน Android engine ของ Google อาจเลือกเสียงที่ต้องใช้เน็ตได้เอง (เสียงแบบ network) — `flutter test` ตรวจไม่ได้ | ยอมรับตามโค้ดตอนนี้ · ขอให้รอบ emulator ลองปิดเน็ตแล้วฟังว่าพูดได้ / ถ้าต้องการบังคับเสียง offline ให้ owner ตัดสิน (เช่นเลือก voice ที่ไม่ต้องใช้เน็ต) |
| Q-QA-4 | EC-1 Mute / เสียงสื่อเป็น 0 — ตรวจใน unit/widget test ไม่ได้ | ตรวจแค่ว่าไหลตามปกติไม่แครช (Q-22) · ต้องตรวจบน emulator |
| Q-QA-5 | ui-spec §6 ขอเช็ก overflow ที่ 360×640 textScaler 1.0/1.5 (S-1, dashboard ขณะพูด, S-3) — ไม่ใช่ AC จึงไม่ได้ทำรอบนี้ | ไม่ได้ทดสอบ — เสนอเพิ่มรอบถัดไปถ้าต้องการ |

---

# QA รอบ 2 — re-check BUG-VOICE-1 (2026-11-12)

| รายการ | ค่า |
|---|---|
| บั๊ก | BUG-VOICE-1 (owner พบบน emulator): Android `prepare()` เช็กแค่ `isLanguageAvailable('th-TH')` ซึ่งคืน true ได้แม้มีแต่ server voice → อาจพูดผ่าน cloud ขัด V-6a |
| ที่ Dev แก้ | `app/lib/features/voice/voice_flutter_tts_engine.dart` (Android: `isLanguageInstalled` → `getVoices` → `pickOfflineThaiVoice` → `setLanguage` → `setVoice` ต้องคืน 1) · `VoiceLogic.pickOfflineThaiVoice` · ค่าคงที่ใน `voice_rules.dart` (logs/20261112-1200_dev_voice_r2.md) |
| ข้อตัดสินที่ใช้ | DECIDED (owner 2026-11-12, รอบ 2): เทสต์ `FlutterTtsVoiceEngine` ได้โดย mock `MethodChannel('flutter_tts')` + `debugDefaultTargetPlatformOverride` — ข้อยกเว้นของ ui-spec §2.4.5 · ชื่อเทสต์ `DECIDED_R2_*` |
| ไฟล์ใหม่ | `app/test/voice/voice_qa_r2_engine_channel_test.dart` — 23 เทสต์ |
| ไฟล์ที่ QA แก้ | `app/test/voice/voice_qa_static_test.dart` — `NO_FlutterTtsVoiceEngine_constructed_in_any_test` ยกเว้นไฟล์ R2 ไฟล์เดียว (ตามข้อตัดสินรอบ 2 ไม่ใช่เพราะเทสต์ผิด) |
| ผล | **BUG-VOICE-1 ปิด** · บั๊กใหม่ **0** |

ที่มาของค่าคาดหวัง: `th-TH` / pitch `1.5` / volume `0.80` จาก V-6 (`voice_qa_docs.dart`) · "ไม่มีเสียงไทยในเครื่อง / error → ข้ามเงียบ ไม่แครช" จาก V-6a · `awaitSpeakCompletion(true)` จาก ui-spec §2.4.5 ("Future จบเมื่อพูดเสร็จ") · ชื่อ method และรูปแบบ map (`network_required "1"/"0"`, `setVoice` คืน 1/0) จาก API ของ flutter_tts 4.2.5 (`lib/flutter_tts.dart`, `FlutterTtsPlugin.kt`) ซึ่ง QA เปิดอ่านจาก pub cache เอง ไม่ได้ลอกจากโค้ดแอป

## ตาราง ข้อกำหนด → เทสต์ (รอบ 2)

| ข้อกำหนด | เทสต์ | ผล |
|---|---|---|
| Android: `isLanguageInstalled` false → false, ไม่เรียก setVoice / speak | `DECIDED_R2_android_not_installed_returns_false_no_setVoice_no_speak` | ผ่าน |
| อาการเดิมของบั๊ก: Available true แต่ Installed false → ไม่พร้อม ไม่ตั้ง pitch / await | `DECIDED_R2_android_isLanguageAvailable_true_alone_is_not_enough` | ผ่าน |
| Installed แต่ getVoices มีแต่ th-TH `network_required "1"` → false | `DECIDED_R2_android_installed_but_only_network_voices_returns_false` | ผ่าน |
| มี th-TH `"0"` → ลำดับ isLanguageInstalled < getVoices < setLanguage(th-TH) < setVoice(voice นั้น) · setPitch 1.5 · setVolume 0.80 · awaitSpeakCompletion(true) → true · ไม่ setLanguage ซ้ำหลัง setVoice · ไม่ clearVoice · ไม่ speak ตอน prepare | `DECIDED_R2_android_offline_thai_voice_full_sequence_returns_true` | ผ่าน |
| server voice อยู่ก่อนในรายการ → ยังเลือกตัว local | `DECIDED_R2_android_network_voice_listed_first_still_picks_local` | ผ่าน |
| `setVoice` คืน 0 → false | `DECIDED_R2_android_setVoice_returns_0_returns_false` | ผ่าน |
| `setVoice` คืน null → false | `DECIDED_R2_android_setVoice_returns_null_returns_false` | ผ่าน |
| ค่าเกณฑ์: `isLanguageInstalled` ต้องเป็น `true` เท่านั้น (null / 1 / "true" → false) | `DECIDED_R2_android_isLanguageInstalled_non_bool_returns_false` | ผ่าน |
| ข้อมูลว่าง / เสีย: getVoices `[]` / null / `"corrupt"` → false | `DECIDED_R2_android_empty_or_missing_voice_list_returns_false` | ผ่าน |
| voice ไทย `"0"` แต่ features มี `notInstalled` → false | `DECIDED_R2_android_not_downloaded_thai_voice_returns_false` | ผ่าน |
| method throw (PlatformException) → false ไม่ throw — 7 method | `DECIDED_R2_android_{isLanguageInstalled,getVoices,setLanguage,setVoice,setPitch,setVolume,awaitSpeakCompletion}_throws_returns_false_no_throw` (7) | ผ่าน 7/7 |
| ไม่มี plugin (MissingPluginException) → false | `DECIDED_R2_android_no_plugin_handler_returns_false_no_throw` | ผ่าน |
| หลัง prepare: speak ส่ง Exact String · ไม่มี setLanguage / clearVoice ระหว่าง setVoice กับ speak | `DECIDED_R2_android_speak_sends_exact_string_after_prepare` | ผ่าน |
| iOS ใช้ `isLanguageAvailable` (ไม่เรียก isLanguageInstalled) → setLanguage th-TH / pitch / volume / await → true | `DECIDED_R2_ios_uses_isLanguageAvailable_true_returns_true` | ผ่าน |
| iOS Available false → false ไม่ตั้งค่า | `DECIDED_R2_ios_isLanguageAvailable_false_returns_false` | ผ่าน |
| iOS throw → false | `DECIDED_R2_ios_throw_returns_false_no_throw` | ผ่าน |
| `isSupportedPlatform` = Android / iOS เท่านั้น (ui-spec §2.4 ไฟล์ใหม่) | `DECIDED_R2_isSupportedPlatform_android_ios_only` | ผ่าน |

**ตรวจว่าเทสต์จับบั๊กได้จริง (mutation check):** เอา engine ก่อนแก้จาก commit `4f0cdfe` ไปไว้ใน `test/zz_mut/` ชั่วคราว (ไม่แตะ `app/lib/`) แล้วรันเทสต์ชุด R2 → **ล้ม 14 / 23** (เทสต์ Android ทั้งหมดที่เกี่ยวกับลำดับ / voice · iOS 3 + platform gate + throw ของ setLanguage/setPitch/setVolume/await + no plugin ผ่านเพราะพฤติกรรมไม่เปลี่ยน) → ลบโฟลเดอร์ทิ้งแล้ว

## ตรวจเทสต์ `DECIDED_V6a_*` ของ Dev (8 ข้อ ใน `voice_offline_voice_pick_test.dart`)

ค่าคาดหวังเป็น map / null ที่เขียนตรง ๆ ไม่ได้อ่านจาก `VoiceRules` หรือเรียกโค้ดมาคำนวณ → ไม่ได้ลอกโค้ด

| เทสต์ | ที่มาของค่าคาดหวัง | สรุป |
|---|---|---|
| `picks_only_thai_offline_voice` | V-6a (ในเครื่องเท่านั้น) | ถูก |
| `only_network_thai_voices_returns_null` | V-6a | ถูก |
| `no_thai_voice_returns_null` | V-6a ("ไม่มีเสียงไทย → ข้าม") + ข้อมูลว่าง | ถูก |
| `not_installed_voice_is_skipped` | V-6a + ความหมาย `notInstalled` ของ Android (ยังไม่อยู่ในเครื่อง) | ถูก |
| `missing_or_unknown_network_flag_is_not_picked` | ASSUMPTION 1 ของ Dev (ไม่ชัวร์ = ถือว่าใช้เน็ต) — สอดคล้องกับ V-6a แต่ไม่ได้เขียนในข้อตัดสิน | ยอมรับ · ดู Q-QA-6 |
| `prefers_exact_th_TH_over_other_thai_locale` | ASSUMPTION 3 ของ Dev | ยอมรับ · ดู Q-QA-6 |
| `locale_prefix_th_only_not_lookalike` | ASSUMPTION 3 ของ Dev | ยอมรับ · ดู Q-QA-6 |
| `malformed_input_returns_null_without_throwing` | V-6a "ไม่แครช" + ASSUMPTION 6 | ถูก |

## สรุปตัวเลขรอบ 2 (จากการรันจริง)

| รายการ | ค่า |
|---|---|
| `flutter analyze` (app/) | `No issues found! (ran in 3.7s)` |
| `flutter test` ทั้งแอป (app/) | **1146 ทั้งหมด / 1146 ผ่าน / 0 ไม่ผ่าน** (`00:50 +1146: All tests passed!`) |
| ที่มาของจำนวน | 1115 (รอบ 1) + Dev 8 (`DECIDED_V6a_*`) = 1123 + QA รอบ 2 23 = 1146 |
| เทสต์ voice | 159 + 8 + 23 = 190 |
| ข้อกำหนดของ BUG-VOICE-1 ที่ยังไม่มีเทสต์ | 0 |
| bug ใหม่ | 0 |
| ข้อจำกัด | การทดสอบนี้จำลอง platform channel — ยังต้องยืนยันบน emulator 2 กรณี: มีเสียงไทยออฟไลน์ (ควรพูด) / มีแต่ server voice หรือปิดเน็ต (ควรเงียบ ไม่มีฟอง) |

## คำถามถึงเอกสาร รอบ 2 (ไม่นับเป็น bug)

| # | ประเด็น | ทางที่ QA เลือกชั่วคราว |
|---|---|---|
| Q-QA-3 | (รอบ 1) เสียง network บน Android | **ปิดด้วย BUG-VOICE-1** ในระดับโค้ด · ยังต้องยืนยันบน emulator |
| Q-QA-6 | เทสต์ Dev 3 ข้อ (`missing_or_unknown_network_flag`, `prefers_exact_th_TH`, `locale_prefix_th_only`) ใช้ชื่อ `DECIDED_` แต่ค่ามาจาก ASSUMPTION ของ Dev ไม่ได้อยู่ในข้อตัดสิน owner | ยอมรับค่าตามนั้น (ปลอดภัยต่อ V-6a) · ขอ owner ยืนยันตอนรีวิว PR หรือเปลี่ยนชื่อเป็น `ASSUMPTION_` |
| Q-QA-7 | prepare() คืน false ครั้งเดียวแล้ว — ถ้าผู้ใช้ไปดาวน์โหลดเสียงไทยภายหลังขณะแอปเปิดอยู่ จะพูดเมื่อไหร่ (เอกสารไม่กล่าวถึง) | ไม่ทดสอบ · ถือว่าเริ่มแอปใหม่แล้วพูดได้ |
