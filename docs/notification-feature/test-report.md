# Test report: notification-feature — แจ้งเตือนจากน้องอ๊บ (QA รอบที่ 1–3 + re-check Q-09)

> **Re-check Q-09 heads-up (2026-11-09 11:38–11:42 · DECIDED owner 2026-11-09):** notification 159 เทสต์ **ผ่าน 159 / 0** · ทั้งแอป **956 ผ่าน / 0** · analyze No issues · bug ใหม่ 0 · ยังต้องยืนยันการเด้งบนเครื่อง Android จริง — ดู §11

> **รอบ 3 (20:26–20:31 หลัง Dev รอบ 4):** notification 158 เทสต์ **ผ่าน 158 / ไม่ผ่าน 0** · ทั้งแอป **955 ผ่าน / 0** · analyze No issues · BUG-NOTI-1 **ปิด** · BUG-NOTI-2 ปิด · bug ที่ยังเปิด 0 — ดู §10

> **รอบ 2 (17:06–17:10 หลัง Dev รอบ 3):** notification 151 เทสต์ **ผ่าน 147 / ไม่ผ่าน 4** · ทั้งแอป **944 ผ่าน / 4 ไม่ผ่าน** · analyze No issues · BUG-NOTI-2 **ปิด** · BUG-NOTI-1 **ยังเปิด (แก้บางส่วน)** — ดู §9 (§0–§8 คือผลรอบ 1)

> สรุป: notification มี 139 เทสต์ **ผ่าน 135 / ไม่ผ่าน 4** · ทั้งแอป **932 ผ่าน / 4 ไม่ผ่าน** (ทั้ง 4 ข้อเป็นเทสต์ notification ที่ล้มเพราะบั๊ก) · `flutter analyze` No issues found! · **พบบั๊ก 2 ข้อ** (BUG-NOTI-1 ความรุนแรงปานกลาง, BUG-NOTI-2 ต่ำ) · AC ที่อยู่ในขอบเขต 39/39 มีเทสต์ (AC-15 ตัดออกตาม D-3 มีเทสต์ DECIDED แทน) · EC 14/14 มีเทสต์ (EC-12 ตัดออกตาม D-3) · T-1..T-18 ครบ

> ผู้ทดสอบ: QA agent · วันที่ 2026-11-08 (16:42–17:02) · โค้ดที่ทดสอบ: `app/lib/features/notification/` (10 ไฟล์) + ไฟล์เดิมที่ Dev แก้ (`main.dart`, `water_home_screen.dart`, `dashboard_screen.dart`, `signup_controller.dart`, manifest, pubspec) — Dev รอบ 1–2 `logs/20261108-1633_dev_notification-feature.md`
> อ้างอิง: requirements.md (AC-1..AC-40, EC-1..EC-15), game-rules.md, ux-flow.md, ui-spec.md (§0, §2.4.4 T-1..T-18, §6, §7) และข้อตัดสิน owner ด้านล่าง — ค่าคาดหวังมาจากเอกสาร/ข้อตัดสิน ไม่ได้ลอกจากโค้ด
> เทสต์: `app/test/notification/notification_logic_test.dart` (L), `notification_controller_test.dart` (C), `notification_screens_test.dart` (W) + ตัวช่วย `notification_test_helpers.dart` (FakeNotificationScheduler, FakeDayTimers, FakeNotificationAvatarSource, repository เสีย/ค้าง, `Harness`, ใช้ `makeSources` ของ dashboard)
> ไม่เรียก plugin จริง (`LocalNotificationScheduler` ไม่ถูกสร้างในเทสต์) · ไม่ต่อเน็ต · เวลาใช้ clock ที่ส่งเข้า controller ทั้ง 4 ตัว + `tester.pump(Duration)` · ไม่ได้แก้ `app/lib/` · ไม่ได้ commit / push

## 0. ข้อตัดสิน owner — DECIDED (owner) 2026-11-08

ข้อตัดสินชนะเอกสารเมื่อขัดกัน เทสต์ที่อิงข้อตัดสินมี `DECIDED_` ในชื่อ

| รหัส | เนื้อหา | มีผลต่อเทสต์ |
|---|---|---|
| D-1 | ไม่มี PNG — `PetCharacter(pose: PetPose.notificationProfile)` บน S-1 · avatar Android เรนเดอร์จาก painter 192×192 ครอปวงกลม พื้นโปร่งใส แคช | `DECIDED_D1_card_pet_is_PetCharacter_notificationProfile_wink_120`, `DECIDED_D1_AC36_avatar_png_192_circle_transparent_cached`, `DECIDED_D1_D5_no_png_no_asset_no_network_no_hex_in_notification_code` |
| D-2 | ทางเข้า S-2 = ปุ่มตั้งค่าบน AppBar dashboard · AppBar water คง 5 ปุ่ม | `DECIDED_D2_*` (4 เทสต์ + 360×640 ×2) |
| D-3 | "เดิน: บันทึกเอง" ตัดออก (AC-15 / EC-12) · `isTrackingLocked` = ไม่มีข้อความเดินเลย | `DECIDED_D3_AC15_EC12_no_manual_move_message_text_or_key`, `T12_DECIDED_D3_*`, `DECIDED_D3_tracking_locked_user_gets_no_walk_message` |
| D-4 | EC-3 ค่าติดลบ / `daily_goal` = 0 → ระงับเรื่องนั้นทั้งรอบวัน (เฉพาะ notification) | `T16_EC3_DECIDED_D4_*`, `T16_EC3_negative_*` |
| D-5 | `flutter_local_notifications` + `timezone` + `flutter_timezone` ในเครื่องเท่านั้น วางแผนล่วงหน้า/ตั้งใหม่ทุกครั้งที่ข้อมูลเปลี่ยน | `DECIDED_D5_D6_manifest_pubspec_main_setup` · เทสต์ "วางแผนซ้ำ" ของ T-18 |
| D-6 | `inexactAllowWhileIdle` ไม่ขอ exact alarm → เทสต์ตรวจเวลาที่ "ตั้ง" (`scheduledAt`) | ทุกเทสต์เวลาตรวจ `scheduledAt` · `AC36_AC37_DECIDED_D6_*` |
| Q-03..Q-27 | ใช้ค่าที่ ui-spec §7 เลือก (ป้ายสวิตช์ Q-03, tooltip Q-04, DENIED ขอซ้ำ Q-05, ตัดขั้นที่เลยเวลา Q-06, ใกล้เป้า dueAt = ตอนตรวจพบ Q-08, deep link ค้างในหน่วยความจำ Q-16, popUntil Q-17, ระงับทั้งวัน Q-20, `notification_day_plan` Q-21, PopScope Q-22, master คงไว้ Q-23, id FNV Q-25 ฯลฯ) | `DECIDED_Q03_*`, `Q05_*`, `T18_EC14_Q06_*`, `*_Q08`, `EC13_Q16_*`, `Q21_*`, `*_Q23_*`, `Q25_*` |
| EC-9 | วางแผนเมื่อการ์ดถูกตอบแล้ว (ทางใดก็ได้) + สวิตช์ ON + สิทธิ์ GRANTED | `DECIDED_EC9_AC6_deny_then_switch_on_requests_and_schedules` (C), `DECIDED_EC9_AC6_tap_switch_on_requests_and_schedules` (W) |
| Q-28 | logout → `cancelAll` + ล้างแผนวัน ไม่เปลี่ยน consent/สวิตช์ · เข้าระบบใหม่วันเดียวกันได้เพิ่มถึง 6 (ยอมรับ) | `DECIDED_Q28_*` (C 2, W 1) |
| pin | `flutter_local_notifications` 22.3.3 | `DECIDED_D5_D6_manifest_pubspec_main_setup` |
| AC-37 | iOS ตรวจได้แค่ระดับ details ใน Dart (ไม่มี `app/ios/`) | `AC36_AC37_DECIDED_D6_local_scheduler_details_in_source` (ตรวจซอร์ส) |

## 1. สรุปตัวเลข

| รายการ | ค่า |
|---|---|
| เทสต์ notification ทั้งหมด | **139** (L 54 · C 31 · W 54) |
| ผ่าน / ไม่ผ่าน (notification) | **135 / 4** (L 52/2 · C 30/1 · W 53/1) |
| `flutter test` ทั้งแอป (ใน app/) | **932 ผ่าน / 4 ไม่ผ่าน** (`00:17 +932 -4: Some tests failed.`) — เทสต์เดิม 797 ผ่านทั้งหมด |
| `flutter analyze` | **No issues found! (ran in 1.9s)** |
| AC ในขอบเขต มีเทสต์ | 39/39 (AC-15 ตัดออก D-3 → มีเทสต์ DECIDED ยืนยันว่าไม่มี) |
| EC ในขอบเขต มีเทสต์ | 14/14 (EC-12 ตัดออก D-3) |
| AC/EC ที่ยังไม่มีเทสต์ | **0** (AC-37 ตรวจได้เฉพาะซอร์ส Dart — ไม่มีเครื่อง iOS / `app/ios/`) |
| T-1..T-18 ของ ui-spec | 18/18 มีเทสต์ชื่อ `T1_`..`T18_` · ผ่านทั้งหมดเมื่อวางแผนครั้งเดียว · T-18 ล้มเมื่อวางแผนซ้ำ (BUG-NOTI-1) |
| Bug | **2** (BUG-NOTI-1, BUG-NOTI-2) · Dev แก้แล้ว 0 |
| เทสต์ที่ QA แก้เองเพราะเทสต์ผิด | **6** (+ แก้ compile 1 ครั้ง — §6) |
| คำถามค้าง | 4 (§7) |

## 2. AC → เทสต์

| AC | เทสต์ (ไฟล์) | ผล |
|---|---|---|
| AC-1 การ์ดแสดงทับ Home ครั้งแรก | `AC1_first_home_shows_card_over_home_exact_texts`, `AC1_card_shown_once_even_when_sources_notify`, `WIRING_PetPalApp_passes_notification_controller`, `EDGE_loading_no_card_until_loaded` (W) | ผ่าน |
| AC-2 อนุญาต → กล่องขอสิทธิ์ | `AC2_allow_saves_ALLOWED_ON_requests_once_and_schedules_T1` (C), `AC2_allow_closes_card_then_requests_once_saves_and_schedules` (W — ตรวจว่าการ์ดปิดก่อนเรียก `requestPermission`) | ผ่าน |
| AC-3 ไม่อนุญาต → ไม่ขอสิทธิ์ ไม่ถามซ้ำ | `AC3_deny_saves_DENIED_OFF_no_request_no_schedule_even_after_data_change` (C), `AC3_deny_closes_card_no_request_no_schedule` (W) | ผ่าน |
| AC-4 เข้า Home ครั้งที่ 2 ไม่แสดง | `AC4_second_home_visit_no_card` (W), `AC4_answer_only_once_second_answer_ignored` (C) | ผ่าน |
| AC-5 สวิตช์ตรงกับคำตอบ | `AC5_switch_reflects_card_answer` (C), `AC5_NORMAL_on_granted_switch_on_no_banner`, `AC5_EMPTY_denied_on_card_switch_off_no_banner_no_pending` (W) | ผ่าน |
| AC-6 เปิดสวิตช์ขณะยังไม่ได้สิทธิ์ → ขอสิทธิ์ | `AC6_switch_on_not_determined_requests_permission` (C), `DECIDED_EC9_AC6_*` (C, W), `AC6_request_denied_switch_back_off_banner_shown` (W) | ผ่าน |
| AC-7 ปิดสวิตช์ → ยกเลิกทั้งหมด ไม่ตั้งใหม่จนเปิด | `AC7_switch_off_cancels_every_pending_keeps_committed_no_cancelAll` (C), `AC7_tap_switch_off_cancels_pending` (W) | ผ่าน |
| AC-8 ระบบปฏิเสธ → ปิด + ข้อความ | `AC8_EC10_system_denies_on_request_switch_off_nothing_scheduled` (C), `AC8_EC10_PERMISSION_DENIED_switch_off_banner_exact_text_colors` (W) | ผ่าน |
| AC-9 เดิน: ไม่ขยับ 4 ชม. | `T4_AC9_steps_increase_0800_walkInactive_1200`, `AC9_no_steps_counts_from_0600_due_1000_exact_4h`, `AC9_walkInactive_still_scheduled_at_100_percent`, `AC9_new_steps_restart_counter_AC34` (L), `AC9_AC34_new_steps_cancels_walkInactive_restarts_4h_and_stores_time` (C) | ผ่าน |
| AC-10..AC-13 79.99/80.00/99.99/100.00% | `T10_AC10_AC11_AC12_AC13_near_goal_7999_8000_9999_10000`, `T10_isNearGoal_integer_boundaries` (L), `AC11_steps_reach_80_percent_near_goal_scheduled_once` (C) | ผ่าน |
| AC-14 ข้าม 80% → ≥ 100% ในรอบเดียว | `T11_AC14_EC11_jump_7000_to_10000_no_near_goal` (L) | ผ่าน |
| AC-15 เดิน: บันทึกเอง | **ตัดออก (D-3)** — `DECIDED_D3_AC15_EC12_no_manual_move_message_text_or_key` (L) ยืนยันว่าไม่มีข้อความ/คีย์ · `T12_DECIDED_D3_*` (L), `DECIDED_D3_tracking_locked_user_gets_no_walk_message` (C) | ผ่าน |
| AC-16 น้ำ: 2 ชม. | `T2_water_last_0800_three_cups_first_1000_second_1200`, `AC16_exactly_2h_after_0600_when_no_log` (L) | ผ่าน |
| AC-17 ไม่ส่งซ้ำในรอบนับ | `AC17_waterFirst_once_per_cycle` (L), `AC17_waterFirst_not_rescheduled_after_sent_in_same_cycle` (C) | ผ่าน |
| AC-18 น้ำ: 4 ชม. | `T2_*`, `AC18_waterSecond_exactly_4h` (L) | ผ่าน |
| AC-19 ครบ 8 แก้วหยุดเรื่องน้ำ | `T13_AC19_EC4_water_7_has_8_and_12_none`, `T13_AC19_water_7_to_8_cancels_pending_water` (L), `AC19_eighth_cup_stops_water_for_the_day` (C) | ผ่าน |
| AC-20 อาหาร: ยังไม่กิน 12/15/18 | `T1_*`, `T14_AC20_AC21_*` (L) | ผ่าน |
| AC-21 บันทึกแล้วยกเลิกรอบที่เหลือ | `T14_AC20_AC21_food_1200_committed_then_500kcal_1230_cancels_15_18`, `AC21_breakfast_logged_no_food_unlogged_all_day`, `AC34_food_log_removes_pending_food_unlogged` (L), `AC34_food_log_cancels_remaining_food_unlogged` (C) | ผ่าน |
| AC-22..AC-25 อาหาร: 21:00 | `T15_AC22_AC23_AC24_AC25_food_night_2100` (L — 1,500 / 1,999 / 2,000 / ไม่มีเป้า 0 / 350) | ผ่าน |
| AC-26 ช่วงห้ามเตือน 23:00:00–05:59:59 | `T7_AC26_EC7_*`, `AC26_no_items_when_planning_in_quiet_hours`, `AC26_EC7_isQuietTime_boundaries`, `AC26_near_goal_detected_0530_scheduled_060000` (L) | ผ่าน |
| AC-27 น้ำ 22:30 → เริ่ม 06:00 ส่ง 08:00 | `T3_AC27_water_2230_yesterday_now_0510_first_0800_anchor_0600` (L) | ผ่าน |
| AC-28 เพดาน 6 | `T9_AC28_six_committed_no_pending_five_committed_one_more`, `AC28_EC15_cap_reached_before_2100_foodNight_dropped` (L), `AC28_EC15_never_more_than_6_for_the_day_and_stored_count_6` (C) | ผ่าน |
| AC-29 / AC-30 29:59 เลื่อน / 30:00 ส่ง | `T5_AC29_AC30_gap_2959_delayed_to_3000` (L) | ผ่าน |
| AC-31 อาหาร > น้ำ > เดิน | `AC31_priority_food_gt_water_gt_walk`, `T6_AC31_EC5_*`, `AC31_EC5_three_topics_due_together_food_water_walk`, `T1_*` (L) | ผ่าน |
| AC-32 ถูกเลื่อนแล้วส่งทีหลัง | `AC32_delayed_item_sent_later_not_dropped` (L) | ผ่าน |
| AC-33 ถูกเลื่อนถึง 23:00:00 → ยกเลิก | `T8_AC33_delayed_until_230000_cancelled` (L) | ผ่าน |
| AC-34 ทำกิจกรรมแล้วยกเลิกเรื่องนั้น | `T17_AC34_EC6_*` (L, C), `AC34_*` (L 2, C 1), `AC9_AC34_*` (C) | ผ่าน |
| AC-35 รีเซ็ต 05:00:00 | `AC35_EC8_reset_at_0500_count_and_near_goal` (L), `AC35_EC8_day_tick_0500_resets_count_and_near_goal` (C — Timer ปลอม 04:59:59 ไม่รีเซ็ต / 05:00:00 รีเซ็ต) | ผ่าน |
| AC-36 Android แชต 3 ส่วน | `DECIDED_D1_AC36_avatar_png_192_circle_transparent_cached` (W), `AC36_AC37_DECIDED_D6_local_scheduler_details_in_source` (W, ตรวจซอร์ส), `UX_S3_six_message_texts_exact_and_topics` (L) | ผ่าน |
| AC-37 iOS ปกติ 2 ส่วน | `AC36_AC37_DECIDED_D6_local_scheduler_details_in_source` (title null บน iOS, `DarwinNotificationDetails(presentBanner: true)`, ไม่มี attachment) — ระดับซอร์ส Dart เท่านั้น | ผ่าน |
| AC-38 / AC-39 / AC-40 deep link 3 เรื่อง × 3 สถานะแอป | `AC38_walk_FOREGROUND_from_S2_opens_walk`, `AC38_walk_BACKGROUND_opens_walk`, `AC38_EC13_walk_TERMINATED_launch_payload_opens_walk` และชุดเดียวกันของ `AC39_water_*`, `AC40_food_*` (W 9 เทสต์), `AC38_AC39_AC40_payload_round_trip_topic` (L) | ผ่าน |

## 3. EC และ edge บังคับ

| EC / edge | เทสต์ | ผล |
|---|---|---|
| EC-1 กดสวิตช์รัว | `EC1_rapid_toggle_ends_off_no_pending_storage_off`, `EC1_rapid_toggle_ends_on_exactly_one_copy_of_plan`, `EC1_rapid_toggle_while_os_dialog_open_last_state_off_wins` (C), `EC1_rapid_taps_last_state_wins` (W) | ผ่าน |
| EC-2 กดแจ้งเตือนเดิมซ้ำ | `EC2_walk/water/food_same_notification_tapped_3_times_one_page` (W 3), `EC2_from_steps_page_food_tap_replaces_not_stacks` (W) | ผ่าน |
| EC-3 ค่าติดลบ / goal 0 | `T16_EC3_DECIDED_D4_*`, `T16_EC3_negative_water_or_calories_suppress_that_topic` (L) | ผ่าน |
| EC-4 น้ำ 12 แก้ว | `T13_AC19_EC4_*` (L) | ผ่าน |
| EC-5 ครบกำหนดพร้อมกัน | `T6_AC31_EC5_*`, `AC31_EC5_*` (L) | ผ่าน |
| EC-6 ทำกิจกรรมระหว่างรอส่ง | `T17_AC34_EC6_*` (L, C) | ผ่าน |
| EC-7 ครบกำหนดในช่วงห้ามเตือน | `T7_AC26_EC7_*`, `EC7_water_log_2130_due_2330_none_next_day_0800`, `AC26_EC7_isQuietTime_boundaries` (L) | ผ่าน |
| EC-8 ข้ามรอบ 05:00 | `AC35_EC8_*` (L, C) | ผ่าน |
| EC-9 ไม่อนุญาตแล้วเปิดสวิตช์ | `DECIDED_EC9_AC6_*` (C, W) | ผ่าน |
| EC-10 ระบบปฏิเสธสิทธิ์ | `AC8_EC10_*` (C, W), `EC10_DECIDED_Q23_resume_denied_cancels_then_granted_reschedules` (C), `EC10_DECIDED_Q23_resume_updates_open_S2_live` (W) | ผ่าน |
| EC-11 ข้าม 80/100 | `T11_AC14_EC11_*` (L) | ผ่าน |
| EC-12 ตรวจก้าวไม่ได้ → บันทึกเอง | **ตัดออก (D-3)** — `DECIDED_D3_*` ยืนยันไม่มีข้อความเดินเลย | ผ่าน |
| EC-13 เปิดจากสถานะปิดสนิท | `AC38/39/40_EC13_*_TERMINATED_*` (W 3) ผ่าน · `EC13_Q16_TERMINATED_with_unanswered_card_navigates_after_answer` (W) **ไม่ผ่าน → BUG-NOTI-2** | 3 ผ่าน / 1 ไม่ผ่าน |
| EC-14 ไม่เปิดแอปข้ามวัน | `T18_EC14_Q06_first_open_1400_no_data` (L) ผ่าน · `EC14_open_app_new_day_plans_today_T18` (C) **ไม่ผ่าน → BUG-NOTI-1** · `T18_Q06_replan_same_minute_keeps_T18_plan`, `T18_Q06_replan_at_1405_keeps_T18_plan` (L) **ไม่ผ่าน → BUG-NOTI-1** | 1 ผ่าน / 3 ไม่ผ่าน |
| EC-15 ครบ 6 ก่อน 21:00 | `AC28_EC15_*` (L, C), `T1_*` | ผ่าน |
| edge 1 ค่าเกณฑ์พอดี | 79.99/80.00/99.99/100.00% (T10 + เป้า 8,000: 6,399/6,400/7,999/8,000) · 29:59/30:00 (T5) · 22:59:59/23:00:00 (T7, T8 ขอบ committed 22:29:59) · 05:59:59/06:00:00 (isQuietTime, ใกล้เป้า 05:30 → 06:00:00) · 04:59:59/05:00:00 (AC35 L, C) · เพดาน 5→6 (T9) · น้ำ 7/8/12 (T13) · อาหาร 1,999/2,000 (T15) · 4:00:00 / 2:00:00 พอดี (AC9, AC16) | ผ่าน |
| edge 2 ข้ามวัน/รีเซ็ต | AC35 (L, C Timer ปลอม), EC7 วันถัดไป, T3 น้ำเมื่อวาน, T16 ระงับหมดอายุวันถัดไป, `EDGE_previous_plan_of_other_day_treated_empty`, EC14 | ผ่าน ยกเว้น EC14 (C) |
| edge 3 เพดาน / ติดลบ / กดรัว | `expectInvariants` (≤ 6, ไม่อยู่ในช่วงห้าม, ห่าง ≥ 30:00) ใน 9 เทสต์ + `EDGE_invariants_hold_across_many_inputs` (48 ชุด) · `EDGE_rapid_replan_same_inputs_idempotent` (20 รอบ) · `AC28_EC15_never_more_than_6_*` · T16 ค่าติดลบ · EC1 / EC2 กดรัว · `EDGE_start_twice_one_timer_no_duplicate_schedule_stop_cancels` | ผ่าน |
| edge 4 ไม่มีข้อมูล / สิทธิ์ถูกปฏิเสธ / ข้อมูลเสีย | T1/T18 ไม่มีข้อมูล · `EDGE_empty_inputs_first_open_inputsFor_all_null` · `EDGE_first_open_empty_prefs_defaults` · `EDGE_corrupt_prefs_wrong_types_fall_back_to_defaults` · `EDGE_corrupt_plan_json_null_or_skips_bad_items` · `EDGE_S1_ERROR_*` (C 2, W 1) · `EDGE_payload_unreadable_returns_null` / `EDGE_unreadable_payload_no_navigation` · AC8/EC10 | ผ่าน |
| Q-28 logout | `DECIDED_Q28_logout_cancelAll_clears_plan_keeps_consent_switch` (ผ่าน `SignupController.onSignedOut` แบบ main.dart), `DECIDED_Q28_relogin_same_day_new_plan_up_to_6_more` (C), `DECIDED_Q28_home_disposed_stops_timer_and_listeners` (W) | ผ่าน |
| widget 360×640 textScaler 1.0 / 1.5 | `UI_360x640_scale_{1.0,1.5}_card_no_overflow_buttons_reachable`, `UI_360x640_scale_*_card_alone_no_exception`, `UI_360x640_scale_*_S2_NORMAL/PERMISSION_DENIED_no_overflow`, `UI_360x640_scale_*_dashboard_appbar_no_overflow` (W 10) | ผ่าน |

ข้อสังเกต (ไม่ใช่บั๊ก notification): หน้า Home (`WaterHomeScreen` เดิม) ที่ 360×640 textScaler 1.5 มี RenderFlex overflow แนวตั้งอยู่ก่อนฟีเจอร์นี้ (dev log คำถาม 5 — 68 px) · เทสต์ Home + S-1 จึงเก็บ error เองแล้วกรองเฉพาะ error ที่มาจาก widget ของ notification (`Notification` / `notification_` / `Dialog`) แบบเทสต์ dashboard/7day — ไม่พบ error ของ notification · การ์ดเดี่ยว ๆ ที่ 1.5 ไม่มี exception (เลื่อนได้)

## 4. ตัวเลข game-rules ที่ตรวจ

| ค่า (game-rules §1 / §3) | ค่าที่ตรวจ | เทสต์ |
|---|---|---|
| `DAILY_RESET_TIME` 05:00:00 | 04:59:59 ยังวันเดิม (count 6, ใกล้เป้า YES) / 05:00:00 รีเซ็ต 0 / NO | AC35 (L, C) |
| `QUIET_HOURS_START_TIME` 23:00:00 | 22:59:59 ส่ง · 23:00:00 ไม่ส่ง · เลื่อนถึง 23:00:00 ยกเลิก | T7, T8 |
| `QUIET_HOURS_END_TIME` 05:59:59 / `ACTIVE_HOURS_START_TIME` 06:00:00 | 05:59:59 quiet · 06:00:00 ส่งได้ · ตรวจพบ 05:30 → ตั้ง 06:00:00 | AC26 ×3 |
| `DAILY_NOTIFICATION_CAP` 6 | T-1 = 6 ไม่มี 21:00 · committed 6 → pending 0 · committed 5 → +1 | T1, T9, AC28 |
| `MIN_NOTIFICATION_INTERVAL_MINUTES` 30 | 12:00 → 12:29:59 เลื่อนเป็น 12:30:00 · 12:30:00 ส่ง | T5 |
| `WALK_INACTIVITY_HOURS` 4 | 08:00 → 12:00 · 06:00 → 10:00 · 08:00:01 → 12:00:01 | T4, AC9 |
| `WALK_NEAR_GOAL_*` 80.00 / 100.00 | 7,999 / 8,000 / 9,999 / 10,000 จาก 10,000 · 7,000 → 10,000 | T10, T11 |
| `WATER_INACTIVITY_FIRST/SECOND_HOURS` 2 / 4 | 08:00 → 10:00 / 12:00 · 09:15 → 13:15 | T2, AC16, AC18 |
| `WATER_DAILY_GOAL_GLASSES` 8 | 7 มี · 8 ไม่มี · 12 ไม่มี · 7 → 8 ยกเลิก | T13 ×2, AC19 (C) |
| `FOOD_UNLOGGED_TIME_1/2/3` 12/15/18 | 0 kcal มีครบ 3 · 500 kcal ตอน 12:30 → เหลือ 12:00 ที่ส่งแล้ว | T14 |
| `FOOD_NIGHT_REMINDER_TIME` 21:00 | เป้า 2,000: 1,500 / 1,999 ส่ง · 2,000 ไม่ส่ง · ไม่มีเป้า: 0 ส่ง · 350 ไม่ส่ง | T15 |
| ค่าคงที่ทั้งหมดใน `NotificationRules` | ตรงตาราง game-rules §1 (ยกเว้น `WALK_MANUAL_INACTIVITY_HOURS` ตัดตาม D-3) | `GR1_constants_match_game_rules` |
| Storage keys / codes §1.2 | `consent_status`='ALLOWED', `notification_master_switch`='ON', `system_permission_status`='GRANTED', `sent_notification_count`, `walk_near_goal_sent_today`, `last_notification_timestamp` · ค่าเริ่มต้นเมื่อว่าง/เสีย | `GR12_*`, `EDGE_first_open_*`, `EDGE_corrupt_prefs_*` |

## 5. รายการ Bug

### BUG-NOTI-1 — วางแผนซ้ำแล้วขั้น "น้ำ: 2 ชม." ที่ถูกตัด (Q-06) กลับมา ทำให้แผน T-18 เปลี่ยนและ "อาหาร: 21:00" หลุดเพดาน (ความรุนแรง: ปานกลาง)

- เทสต์ที่ล้ม (3): `T18_Q06_replan_same_minute_keeps_T18_plan`, `T18_Q06_replan_at_1405_keeps_T18_plan` (L), `EC14_open_app_new_day_plans_today_T18` (C)
- ขั้นตอนทำซ้ำ (logic): `inputs` ไม่มีข้อมูลใด ๆ (น้ำ 0, ก้าว 0 เป้า 8,000, ตรวจก้าวได้, 0 kcal มีเป้า 2,000) · `p1 = buildPlan(inputs, null, 14:00)` → ได้แผน T-18 ถูกต้อง · `p2 = buildPlan(inputs, p1, 14:00)` (หรือ 14:05)
- ขั้นตอนทำซ้ำ (แอป): consent ALLOWED + ON + GRANTED, ไม่มีบันทึกของวันนี้, เปิดแอปครั้งแรกของวันตอน 14:00 → `start()` วางแผน 1 รอบ แล้ว listener ของ water/steps/food (ตอนโหลด) / resume / บันทึกอะไรก็ตาม เรียก sync ซ้ำ
- ผลที่คาด (ui-spec §2.4.4 T-18 + DECIDED Q-06 "เก็บเฉพาะขั้นล่าสุดที่เลยเวลาของแต่ละสาย" + D-5 "ตั้งใหม่ทุกครั้งที่ข้อมูลเปลี่ยน" → แผนต้องคงเดิมเมื่อข้อมูลไม่เปลี่ยน): `foodUnlogged` 14:00 · `waterSecond` 14:30 · `foodUnlogged` 15:00 · `walkInactive` 15:30 · `foodUnlogged` 18:00 · `foodNight` 21:00 · ไม่มี `waterFirst`
- ผลจริง (replan 14:05): `foodUnlogged` 14:00 · **`waterFirst` 14:30** · `foodUnlogged` 15:00 · `waterSecond` 15:30 · `walkInactive` 16:00 · `foodUnlogged` 18:00 → **ไม่มี `foodNight`** (ชนเพดาน 6) · controller: fake scheduler ได้ `schedule()` เพิ่ม `waterFirst` 14:30, `waterSecond` 15:30, `walkInactive` 16:00 (และ `foodNight` ถูกยกเลิก) ทันทีหลัง `start()`
- ผลกระทบ: ผู้ใช้ที่เปิดแอปครั้งแรกของวันหลังเวลาครบกำหนด ได้ทั้ง "น้ำ: 2 ชม." และ "น้ำ: 4 ชม." ติดกัน และอาจไม่ได้ "อาหาร: 21:00" · แผนไม่คงที่ระหว่างการ sync
- จุดที่สงสัย: `app/lib/features/notification/notification_logic.dart` `_dropStaleSteps` (~บรรทัด 305–329) — `isStale(c) = c.dueAt.isBefore(now) && !wasPending(c)` · รอบที่ 2 `waterSecond` อยู่ใน pending ของแผนเดิม จึงไม่นับว่า "เลยเวลา" → สาย `water` เหลือขั้นเลยเวลาแค่ `waterFirst` 1 ตัว (`stale.length > 1` ไม่จริง) → ไม่ถูกตัด · แนวทาง: ตัดขั้นก่อนหน้าของสายเมื่อมีขั้นหลังที่เลยเวลา "หรืออยู่ในแผนแล้ว" (เช่น นับรวมรายการที่ wasPending ในการเลือก "ขั้นล่าสุด" แต่ไม่ตัดตัวที่ wasPending เอง) — ตัดสินใจวิธีแก้โดย Dev

### BUG-NOTI-2 — deep link ค้างไม่ถูกนำทางหลังตอบการ์ด S-1 ถ้าผลขอสิทธิ์กลับมาทันที (ความรุนแรง: ต่ำ)

- เทสต์ที่ล้ม (1): `EC13_Q16_TERMINATED_with_unanswered_card_navigates_after_answer` (W)
- ขั้นตอนทำซ้ำ: `consent_status = UNANSWERED` · `handleNotificationTap('food|foodUnlogged')` ก่อนเปิด Home (แบบ `main()` TERMINATED) · เปิด `WaterHomeScreen` → การ์ด S-1 ขึ้น (ถูกต้อง — dev สมมติฐาน 13 รอการ์ดปิดก่อน) · กด 「อนุญาต」 โดย `requestPermission()` คืนผลทันที (เช่น Android < 13 ไม่มีกล่อง — Q-15; หรือกด 「ไม่อนุญาต」 ซึ่งไม่ขอสิทธิ์เลย)
- ผลที่คาด (EC-13 / AC-40 "ไปที่หน้าอาหารทันที" + dev สมมติฐาน 13 "รอให้การ์ด S-1 ปิดก่อน"): การ์ดปิดแล้วนำทางไป `FoodDashboardScreen` (stack = [Home, Food])
- ผลจริง: การ์ดปิด แต่ `pendingDeepLink` ยังเป็น `food` และไม่มีการนำทาง จนกว่าจะมี `notifyListeners()` ครั้งถัดไป (ทดลองเรียก `onAppResumed()` แล้วจึงนำทาง)
- จุดที่สงสัย: `app/lib/features/water/screens/water_home_screen.dart` `_showConsentCard` (บรรทัด 171–186) — หลังการ์ด pop, `_consentDialogOpen = false; _onNotificationChanged()` ทำงานก่อน `answerConsent` เปลี่ยน consent (ยัง UNANSWERED) → กิ่งการ์ดตั้ง `_consentDialogOpen = true` และนัด `_showConsentCard` ใหม่ ส่วนกิ่ง deep link ถูกบล็อก · เฟรมถัดไป `_showConsentCard` เห็น consent ไม่ใช่ UNANSWERED แล้ว → `_consentDialogOpen = false; return;` (บรรทัด 176–177) **โดยไม่เรียก `_onNotificationChanged()` อีก** → deep link ค้าง
- ความเป็นไปได้ในการใช้งานจริง: ต่ำ — ต้องมี payload ค้างขณะยังไม่ตอบการ์ด (ปกติยังไม่มีแจ้งเตือนก่อนตอบการ์ด) แต่เป็นทางเดียวกับที่ dev ออกแบบไว้ (สมมติฐาน 13)

## 6. เทสต์ที่ QA แก้เอง (เทสต์ผิด)

| # | เทสต์ | เดิม (ผิด) | แก้เป็น |
|---|---|---|---|
| 1 | `DECIDED_D3_AC15_EC12_no_manual_move_message_text_or_key` (L) | ค้นคำ `last_manual_move_timestamp` ทั้งไฟล์ → เจอในคอมเมนต์อธิบาย D-3 ของ `notification_repository.dart` | ตรวจเฉพาะ string literal `'last_manual_move_timestamp'` |
| 2 | `T9_AC28_six_committed_no_pending_five_committed_one_more` (L) | นับรายการใหม่จาก `pending()` — แต่รายการที่ตั้ง `scheduledAt == now` (11:30) ถือว่าส่งแล้ว (dev สมมติฐาน 7) | นับรายการใหม่จาก `items` ที่ไม่ใช่ 5 รายการเดิม = 1 และรวม = 6 |
| 3 | `EC1_rapid_toggle_while_os_dialog_open_last_state_off_wins` (C) | ยิง ON/OFF/ON/OFF พร้อมกันแล้วคาด `requestPermission` = 1 — แต่สถานะสุดท้ายเป็น OFF ก่อน sync เริ่ม จึงไม่ขอสิทธิ์เลย (ถูกตาม EC-1) | ON ก่อนให้กล่อง OS เปิดค้าง (request = 1) แล้วกด OFF/ON/OFF ระหว่างรอ → ไม่ขอซ้ำ, จบ OFF ไม่มี pending |
| 4 | `DECIDED_D1_card_pet_is_PetCharacter_notificationProfile_wink_120` (W) | `find.byType(Image)` ทั้งจอ → เจอไอคอน PNG เดิมของหน้า water | จำกัดเฉพาะใต้ `notification_consent_card` |
| 5 | `AC36_AC37_DECIDED_D6_local_scheduler_details_in_source` (W) | `isNot(contains('exactAllowWhileIdle,'))` → เป็น substring ของ `inexactAllowWhileIdle,` | regex `AndroidScheduleMode\.(exact|alarmClock)` |
| 6 | `DECIDED_D5_D6_manifest_pubspec_main_setup` (W) | ห้ามมีคำ `SCHEDULE_EXACT_ALARM` ทั้งไฟล์ → เจอในคอมเมนต์ DECIDED ของ manifest | ตรวจการประกาศ `android:name="android.permission.<…>"` เท่านั้น |

อื่น ๆ: `notification_screens_test.dart` compile ไม่ผ่านรอบแรก (ลืม import `notification_repository.dart`) — แก้แล้ว · ก่อนรันครั้งแรกปรับการออกแบบ `AC11_steps_reach_80_percent_near_goal_scheduled_once` ให้ "เดิน: ไม่ขยับ" ไม่ชนคิว 13:00 (ยังไม่เคยรัน ไม่นับ)

## 7. คำถามค้าง (ไม่นับเป็น bug)

1. **(QA → Product/Design) ที่ 21:00:00 กับขั้นอาหารที่เลยเวลา (Q-06)** — game-rules §1.1 / requirements: "ที่ 21:00:00 ส่งเฉพาะ อาหาร: 21:00" แต่ถ้าผู้ใช้เปิดแอปครั้งแรกของวันตอน 21:00:00 โดยยังไม่บันทึกอาหาร แผนจริงคือ `foodUnlogged` 21:00:00 (ขั้น 18:00 ที่เลยเวลา ตาม DECIDED Q-06) แล้ว `foodNight` ถูกเลื่อนเป็น 21:30:00 (เรียงตาม dueAt ของ ui-spec §2.4.4) · เอกสารสองชุดให้ผลต่างกัน — เทสต์ `QUESTION_QA1_*` ตรวจเฉพาะส่วนที่ตรงกัน (มี foodNight 1 รายการ, invariant ครบ) · ขอยืนยันว่าควรให้ `foodNight` ได้ 21:00:00 ก่อนหรือไม่
2. **(QA → owner) ค่า `sent_notification_count` / `last_notification_timestamp` ที่เก็บในเครื่องอัปเดตเฉพาะตอน sync** — derive จากแผนตอนบันทึก ถ้าไม่มี sync หลังรายการถึงเวลา ค่าในเครื่องจะยังเก่า (logic ใช้แผนเป็นหลักจึงไม่กระทบพฤติกรรม) · รับได้หรือไม่
3. (ซ้ำ ui-spec Q-13/Q-14, dev คำถาม 6) requirements AC-15 / EC-12, game-rules/ux-flow ยังมี "เดิน: บันทึกเอง" และ `pet_profile_frog.png` — ขอ Product/Design ย้ายเข้า Out of scope / อัปเดตเอกสาร
4. (ซ้ำ ui-spec Q-12) AC-37 iOS ตรวจได้เฉพาะซอร์ส Dart — ยังไม่มี `app/ios/` จึงไม่มีการทดสอบบนเครื่อง iOS · AC-36 ตรวจ avatar + ซอร์ส แต่ยังไม่ได้ดูหน้าตาบนเครื่อง Android จริง

## 8. ผลการรัน

- `flutter analyze` (app/, 16:58:44): **No issues found! (ran in 1.9s)**
- `flutter test` ทั้งแอป (app/, 16:58:56–16:59:16): **`00:17 +932 -4: Some tests failed.`** — ล้ม 4: `EC14_open_app_new_day_plans_today_T18`, `T18_Q06_replan_at_1405_keeps_T18_plan`, `T18_Q06_replan_same_minute_keeps_T18_plan`, `EC13_Q16_TERMINATED_with_unanswered_card_navigates_after_answer`
- `test/notification/` แยกไฟล์ (17:00): logic `+52 -2` · controller `+30 -1` · screens `00:05 +53 -1`
- `flutter` แก้ `app/windows/flutter/generated_plugin_registrant.cc/.h`, `generated_plugins.cmake` ทุกครั้งที่รัน → `git checkout -- app/windows/` คืนทุกครั้ง (ไม่แตะ app/windows/)

## 9. รอบที่ 2 — re-check หลัง Dev รอบ 3 (2026-11-08 17:06–17:10)

อ่าน `logs/20261108-1633_dev_notification-feature.md` ส่วน "รอบ 3" · Dev แก้ `notification_logic.dart` (`_dropStaleSteps`, `schedule()`) และ `water_home_screen.dart` (`_showConsentCard`) · QA ไม่ได้แก้ `app/lib/`

### 9.1 ข้อตัดสินใหม่ — DECIDED (owner) 2026-11-08 รอบ 2 (ตอบคำถาม §7 ข้อ 1–2)

| ข้อ | ข้อตัดสิน | เทสต์ |
|---|---|---|
| §7-1 21:00 กับ Q-06 | game-rules ชนะ: ตั้งแต่ 21:00:00 ไม่ส่ง `foodUnlogged` เลย — ขั้น 12/15/18 ที่เลยเวลาถูกตัด และ `foodUnlogged` ที่คิวเลื่อนไปถึง ≥ 21:00 ถูกเอาออก · ส่งได้เฉพาะ `foodNight` · เปิดแอปครั้งแรก 21:00 ยังไม่บันทึกอาหาร → `foodNight` 21:00:00 และไม่มี `foodUnlogged` | `DECIDED_R2_*` (L 6, C 1) — แทน `QUESTION_QA1_*` (ลบออก) |
| §7-2 ค่า derive อัปเดตตอน sync | รับตามเดิม | ไม่มีเทสต์ใหม่ (ปิดคำถาม) |

### 9.2 สถานะบั๊ก

| Bug | สถานะ | หลักฐาน |
|---|---|---|
| BUG-NOTI-1 | **ยังเปิด (แก้ได้บางส่วน)** | เทสต์รอบ 1 ทั้ง 3 ข้อผ่านแล้ว (`T18_Q06_replan_same_minute_*`, `T18_Q06_replan_at_1405_*`, `EC14_open_app_new_day_plans_today_T18`) · controller ที่ 14:00 / 14:05 ไม่มี schedule/cancel เพิ่ม · **แต่ที่ 16:10 (หลังส่ง `waterSecond` ไปแล้ว) `waterFirst` กลับมา** — เทสต์ใหม่ล้ม 4 ข้อ (ด้านล่าง) |
| BUG-NOTI-2 | **ปิด** | `EC13_Q16_TERMINATED_with_unanswered_card_navigates_after_answer` (อนุญาต + ผลขอสิทธิ์กลับทันที) ผ่าน · regression ใหม่ `R2_BUG2_EC13_TERMINATED_unanswered_card_deny_then_navigates` (ไม่อนุญาต → หน้าเดิน, ไม่ขอสิทธิ์) และ `R2_BUG2_EC13_TERMINATED_unanswered_card_allow_immediate_water` (กดแจ้งเตือนขณะการ์ดเปิด → รอ → อนุญาต → [Home]) ผ่าน |

#### BUG-NOTI-1 (ยังเปิด) — หลังส่งขั้นล่าสุดของสายไปแล้ว ขั้นก่อนหน้าที่ Q-06 ตัดไว้กลับมาเมื่อวางแผนซ้ำ

- เทสต์ที่ล้ม (4): `T18_R2_BUG1_replan_later_1610_after_some_sent_keeps_T18_plan`, `T18_R2_BUG1_replan_after_every_slot_keeps_T18_plan`, `Q06_R2_deferred_waterFirst_dropped_when_waterSecond_overdue` (L), `R2_BUG1_replan_1400_1405_1610_no_extra_schedule_or_cancel` (C)
- ขั้นตอนทำซ้ำ: inputs ไม่มีข้อมูล (แบบ T-18) · `p1 = buildPlan(inputs, null, 14:00)` · `p2 = buildPlan(inputs, p1, 14:05)` (ผ่าน — ได้แผนเดิม) · `p3 = buildPlan(inputs, p2, 16:10)`
- ผลที่คาด (T-18 + DECIDED Q-06 + D-5 ข้อมูลเดิม = แผนเดิม): `foodUnlogged` 14:00 · `waterSecond` 14:30 · `foodUnlogged` 15:00 · `walkInactive` 15:30 · `foodUnlogged` 18:00 · `foodNight` 21:00 · ไม่มี `waterFirst`
- ผลจริงที่ 16:10: … `walkInactive` 15:30 · **`waterFirst` 16:10** · `foodUnlogged` 18:00 → **ไม่มี `foodNight`** (ชนเพดาน 6) · วางแผนซ้ำหลังผ่านแต่ละช่วงเวลา (15:01): `waterFirst` 15:30, `walkInactive` 16:00 · controller: `onAppResumed()` ที่ 16:10 → `schedule()` `waterFirst` 16:10 เพิ่ม
- ผลข้างเคียงที่ Dev จดไว้: แผนเดิมมี `waterFirst` ถูกเลื่อนอยู่ (pending 10:30, dueAt 08:00) · วางแผนที่ 10:15 → ได้ `waterSecond` 10:15 และตัด `waterFirst` (**ตรงกับ Q-06 — ส่วนนี้ถูกต้อง**) · แต่พอวางแผนซ้ำตอน 10:20 (ส่ง `waterSecond` ไปแล้ว) → `waterFirst` 10:45 กลับมา
- จุดที่สงสัย: `app/lib/features/notification/notification_logic.dart` — `candidates()` → `add()` ข้ามรายการที่ committed แล้ว (`if (isCommitted(m, anchor)) return;`) ก่อนเรียก `_dropStaleSteps(out, day, now)` (~บรรทัด 316) · `_dropStaleSteps` (~บรรทัด 318–352) เห็นเฉพาะผู้สมัคร จึงไม่รู้ว่าขั้นหลังของสาย (`waterSecond` anchor เดียวกัน) ถูกส่งไปแล้ว → สายน้ำเหลือขั้นที่เลยเวลาแค่ 1 ตัว (`waterFirst`) → `stale.length > 1` เป็นเท็จ → ไม่ถูกตัด · แนวทาง: ให้ `_dropStaleSteps` นับขั้นของสายที่ committed แล้วด้วย (ถ้าขั้นหลังเลยเวลาหรือส่งไปแล้ว ให้ตัดขั้นก่อนหน้า) · สาย `foodUnlogged` ใช้โครงเดียวกัน และแต่ละขั้นมี anchor ต่างกัน จึงต้องเทียบตามสาย ไม่ใช่ตาม anchor

### 9.3 เทสต์ใหม่รอบ 2 (12 ข้อ + 1 ข้อที่เขียนใหม่แทนข้อเดิม)

| เทสต์ | ไฟล์ | ผล |
|---|---|---|
| `DECIDED_R2_first_open_2100_only_foodNight_at_210000` (แทน `QUESTION_QA1_*`) | L | ผ่าน |
| `DECIDED_R2_first_open_205959_foodUnlogged_allowed_before_2100` (20:59:59 → `foodUnlogged` 20:59:59, `foodNight` 21:29:59) | L | ผ่าน |
| `DECIDED_R2_first_open_after_2100_no_foodUnlogged_no_target` | L | ผ่าน |
| `DECIDED_R2_foodUnlogged_deferred_by_interval_to_2100_removed` (ส่งล่าสุด 20:30:00 → เหลือ `foodNight` 21:00) | L | ผ่าน |
| `DECIDED_R2_foodUnlogged_deferred_to_205959_still_sent_boundary` (ส่งล่าสุด 20:29:59 → `foodUnlogged` 20:59:59) | L | ผ่าน |
| `DECIDED_R2_pure_schedule_removes_foodUnlogged_when_queue_reaches_2100` | L | ผ่าน |
| `DECIDED_R2_first_open_2100_schedules_only_foodNight` | C | ผ่าน |
| `T18_R2_BUG1_replan_later_1610_after_some_sent_keeps_T18_plan` | L | **ไม่ผ่าน** (BUG-NOTI-1) |
| `T18_R2_BUG1_replan_after_every_slot_keeps_T18_plan` | L | **ไม่ผ่าน** (BUG-NOTI-1) |
| `Q06_R2_deferred_waterFirst_dropped_when_waterSecond_overdue` | L | **ไม่ผ่าน** (BUG-NOTI-1 — ส่วนผลข้างเคียงของ Dev ตรง Q-06 แล้ว ล้มที่การวางแผนซ้ำ) |
| `R2_BUG1_replan_1400_1405_1610_no_extra_schedule_or_cancel` | C | **ไม่ผ่าน** ที่ 16:10 (14:00 / 14:05 ผ่าน) |
| `R2_BUG2_EC13_TERMINATED_unanswered_card_deny_then_navigates` | W | ผ่าน |
| `R2_BUG2_EC13_TERMINATED_unanswered_card_allow_immediate_water` | W | ผ่าน |

เทสต์ที่ QA แก้เองเพราะเทสต์ผิด (รอบ 2): **0** · ปรับ 1 ข้อตาม DECIDED ใหม่ (`QUESTION_QA1_*` → `DECIDED_R2_first_open_2100_*`) ซึ่งไม่ใช่เทสต์ผิด · ปรับการออกแบบ `Q06_R2_*` ก่อนรันครั้งแรก 1 ครั้ง (ยังไม่เคยรัน จึงไม่นับ)

### 9.4 ตัวเลขรอบ 2

| รายการ | ค่า |
|---|---|
| เทสต์ notification | **151** (L 62 · C 33 · W 56) · ผ่าน **147** / ไม่ผ่าน **4** (L 59/3 · C 32/1 · W 56/0) |
| `flutter test` ทั้งแอป (17:08:27) | **`00:22 +944 -4: Some tests failed.`** — เทสต์เดิม 797 ข้อยังผ่านทั้งหมด |
| `flutter analyze` (17:08:24) | **No issues found! (ran in 1.5s)** |
| AC/EC ที่ยังไม่มีเทสต์ | 0 |
| Bug เปิด / ปิด | เปิด 1 (BUG-NOTI-1 แก้บางส่วน) · ปิด 1 (BUG-NOTI-2) · ใหม่ 0 |
| คำถามค้าง | 2 (§7 ข้อ 3–4) — ข้อ 1–2 ปิดด้วย DECIDED รอบ 2 |

## 10. รอบที่ 3 — re-check หลัง Dev รอบ 4 (2026-11-08 20:26–20:31)

อ่าน `logs/20261108-1633_dev_notification-feature.md` ส่วน "รอบ 4" · Dev แก้ `notification_logic.dart` อย่างเดียว ดังนี้
- เพิ่ม `_chainKey` (~บรรทัด 322) — สายน้ำแยกตาม anchor · สาย `foodUnlogged` ใช้ทั้งรอบวัน
- เปลี่ยน `_dropStaleSteps` เป็น `_dropSupersededByCommitted` (~บรรทัด 333)
- เพิ่ม `_supersededInChain` ใน `schedule()` (~บรรทัด 359 / 450)

QA ไม่ได้แก้ `app/lib/`

### 10.1 สถานะบั๊ก

| Bug | สถานะ | หลักฐาน |
|---|---|---|
| BUG-NOTI-1 | **ปิด** | ผ่านทั้ง 4 เทสต์ของรอบ 2: `T18_R2_BUG1_replan_later_1610_*`, `T18_R2_BUG1_replan_after_every_slot_*`, `Q06_R2_deferred_waterFirst_dropped_when_waterSecond_overdue`, `R2_BUG1_replan_1400_1405_1610_*` · ผ่าน regression ถาวรของ invariant ด้วย (§10.2) |
| BUG-NOTI-2 | ปิด (ไม่ถดถอย) | ผ่านทั้ง `EC13_Q16_*`, `R2_BUG2_*` ×2 |
| ใหม่ | 0 | — |

### 10.2 เทสต์ใหม่รอบ 3 (7 ข้อ — ผ่านทั้งหมด)

| เทสต์ | ไฟล์ | ตรวจอะไร |
|---|---|---|
| `R3_BUG1_INVARIANT_T18_replan_every_5min_until_0455` | L | T-18 เปิดแอป 14:00 แล้ววางแผนซ้ำทุก 5 นาที ต่อจากแผนก่อนหน้า จนถึง 04:55 วันถัดไป (178 ครั้ง) → `items` เท่าแผนแรกทุกครั้ง |
| `R3_BUG1_INVARIANT_T1_mixed_2100_and_water_chain_scenarios` | L | ตรวจ invariant เดียวกันกับ 4 สถานการณ์: T-1 (05:30) · เปิดครั้งแรก 21:00 · กรณีมีการเลื่อนคิว (น้ำ 10:00 + เดิน 08:00 + อาหาร 0, เปิด 11:00) · สายน้ำเลยเวลา 10:15 (`waterFirst` ถูกเลื่อนค้างไว้ 10:30) |
| `R3_BUG1_INVARIANT_controller_resume_every_5min_no_extra_calls_from_14` / `_from_21` | C | controller: `start()` แล้ว `onAppResumed()` ทุก 5 นาทีถึง 04:55 → `scheduledLog` เท่ารอบแรก · `cancelledLog` ว่าง · `cancelAll` = 0 |
| `R3_AC16_AC18_new_water_log_starts_new_chain_waterFirst_again` | L | ส่ง `waterSecond` ของรอบนับ 06:00 ไปแล้ว + บันทึกน้ำ 16:00 → ได้ `waterFirst` 18:00 และ `waterSecond` 20:00 ใหม่ · ถ้าไม่บันทึกน้ำ ขั้นแรกไม่กลับมา |
| `R3_Q06_foodUnlogged12_deferred_to_1500_dropped_15_sent_boundary` | L | คิวเดินถึง 15:00:00 พอดี → ขั้น 12 ถูกตัด เหลือขั้น 15 ที่ 15:00 · ขอบ 14:59:59 → ขั้น 12 ส่ง 14:59:59 แล้วขั้น 15 ส่ง 15:29:59 |
| `R3_AC20_AC21_food_12_15_sent_replan_1600_only_18_then_log_cancels` | L | วางแผนซ้ำ 16:00 → เหลือ `foodUnlogged` 18:00 รายการเดียวที่รอส่ง · บันทึก 400 kcal ตอน 16:30 → ไม่มี `foodUnlogged` ที่รอส่ง · ขั้น 12/15 ที่ส่งแล้วยังอยู่ในแผน |

- เวลาที่ใช้: เทสต์ sweep ทั้ง 4 ข้อใช้รวมไม่ถึง 1 วินาที (`--plain-name R3_BUG1` → `00:00 +2` ต่อไฟล์)
- เทสต์ที่ QA แก้เองเพราะเทสต์ผิด (รอบ 3): **0**

### 10.3 เทียบพฤติกรรมใหม่กับเอกสาร

- **Q-06 (DECIDED ตาม ui-spec §7):** เก็บเฉพาะขั้นล่าสุดที่เลยเวลาของแต่ละสาย — **ตรง**
  - T-18 ยังได้ผลเดิม
  - ขั้นที่ถูกตัดไม่กลับมาเมื่อวางแผนซ้ำ
  - Dev ขยายกฎให้ตัดสินที่ "เวลาคิว t" แทน "now" (ASSUMPTION ใหม่ของ Dev) — ดูคำถาม §10.4 ข้อ 1
- **AC-16 / AC-17 / AC-18:**
  - 2 ชม. / 4 ชม. ตรงทุกเทสต์เดิม (T2, AC16, AC18)
  - "ไม่ส่งซ้ำในรอบนับเดียวกัน" ตรง (AC17 + invariant)
  - บันทึกน้ำ = รอบนับใหม่ → `waterFirst` กลับมาได้ (`R3_AC16_AC18_*`) — **ตรง** นิยาม "รอบนับ" ใต้ตาราง requirements §3
- **AC-19:** 7/8/12 แก้ว — ตรง (T13 ×2, AC19 C)
- **AC-20 / AC-21:** 12/15/18 เมื่อ 0 kcal และบันทึกแล้วยกเลิกรอบที่เหลือ — ตรง (T14, AC21, AC34, `R3_AC20_AC21_*`)
- **DECIDED 21:00:** ตั้งแต่ 21:00:00 ไม่มี `foodUnlogged` — `DECIDED_R2_*` ทั้ง 7 ข้อผ่าน และ sweep ของสถานการณ์ "เปิด 21:00" คงแผน `foodNight` 21:00 อย่างเดียว

### 10.4 คำถามค้างใหม่ (ไม่นับเป็น bug)

1. **(QA → owner) AC-32 กับ Q-06 ที่ตัดสินตามเวลาคิว**
   - AC-32 / game-rules §1.1: ข้อความที่ถูกเลื่อนเพราะระยะห่างหรือลำดับ "ส่งทีหลังได้ถ้ายังเข้าเงื่อนไข"
   - โค้ดรอบ 4: ถ้าขั้นก่อนหน้าถูกเลื่อนจนถึงเวลาครบกำหนดของขั้นถัดไปในสายเดียวกัน ขั้นก่อนหน้าจะถูกตัด เช่น `foodUnlogged` 12:00 ที่ถูกเลื่อนถึง 15:00:00 จะไม่ถูกส่ง และส่งขั้น 15 แทน
   - ผลคือผู้ใช้ได้ข้อความน้อยลง 1 ข้อความ และเป็นข้อความเดียวกันอยู่แล้ว จึงไม่ขัด US-5
   - ในทางปฏิบัติแทบไม่เกิด เพราะต้องถูกเลื่อน ≥ 2–3 ชม.
   - ขอยืนยันว่ารับการตีความนี้ (เทสต์ `R3_Q06_*` ยึดตามพฤติกรรมนี้ไว้ ถ้า owner ไม่รับต้องปรับเทสต์)
2. ยังค้างจากรอบ 1: §7 ข้อ 3 (เอกสารยังอ้าง "เดิน: บันทึกเอง" / PNG) และข้อ 4 (ยังไม่ได้ทดสอบบนเครื่อง iOS / Android จริง)

### 10.5 ตาราง AC/EC (ยังครบ)

ตาราง §2 (AC) และ §3 (EC) ยังใช้ได้ทั้งหมด แต่ผลเปลี่ยนจากรอบ 1 ดังนี้
- **EC-13:** 4/4 ผ่าน (BUG-NOTI-2 ปิด) และเพิ่ม `R2_BUG2_*` ×2
- **EC-14:** ผ่านทุกข้อ (BUG-NOTI-1 ปิด)
- **AC-20 / AC-21:** เพิ่ม `R3_AC20_AC21_*`
- **AC-16 / AC-18:** เพิ่ม `R3_AC16_AC18_*`
- **AC-22..AC-25 / 21:00:** เพิ่ม `DECIDED_R2_*`
- **AC-32:** เพิ่ม `R3_Q06_*` (ดูคำถาม 10.4-1)

ความครอบคลุม:
- AC ในขอบเขต 39/39 ผ่านทั้งหมด (AC-15 ตัดออกตาม D-3 — มีเทสต์ DECIDED ยืนยัน)
- EC ในขอบเขต 14/14 ผ่านทั้งหมด (EC-12 ตัดออกตาม D-3)
- T-1..T-18 ผ่าน 18/18
- AC/EC ที่ยังไม่มีเทสต์: **0** (AC-37 ตรวจได้เฉพาะระดับซอร์ส Dart)

### 10.6 ตัวเลขสุดท้าย (รอบ 3)

| รายการ | ค่า |
|---|---|
| เทสต์ notification | **158** (L 67 · C 35 · W 56) · **ผ่าน 158 / ไม่ผ่าน 0** (`00:21 +158: All tests passed!`) |
| `flutter test` ทั้งแอป (20:29:07) | **`00:55 +955: All tests passed!`** (เทสต์เดิม 797 + notification 158) |
| `flutter analyze` (20:29:01) | **No issues found! (ran in 2.3s)** |
| Bug | รวมทั้งหมด 2 · ปิด 2 (BUG-NOTI-1 ปิดในรอบนี้, BUG-NOTI-2 ปิดตั้งแต่รอบ 2) · ยังเปิด 0 · ใหม่ 0 |
| ถดถอยจากรอบ 1–2 | 0 — BUG-NOTI-2 และ `DECIDED_R2_*` (21:00) ผ่านทั้งหมด |
| คำถามค้าง | 3 (10.4-1 ใหม่ · §7 ข้อ 3–4) |

## 11. Re-check Q-09 — เด้งบนจอ (heads-up) (2026-11-09 11:38–11:42)

**DECIDED (owner 2026-11-09): Q-09** — แจ้งเตือน Android ต้องเด้งบนจอ (heads-up) · channel `petpal_reminders` ใช้ `Importance.high` · `AndroidNotificationDetails` ใช้ `Importance.high` + `Priority.high` (แทน `defaultImportance` / `defaultPriority` เดิม)

อ่าน `logs/20261109-1135_dev_notification-q09-heads-up.md` · QA ไม่ได้แก้ `app/lib/`

### 11.1 ตรวจ diff

- `notification_local_scheduler.dart`: เปลี่ยน 2 จุดเท่านั้น
  - `AndroidNotificationChannel` → `importance: Importance.high`
  - `AndroidNotificationDetails` → `importance: Importance.high`, `priority: Priority.high`
  - นอกนั้นเปลี่ยนแค่คอมเมนต์ (ASSUMPTION Q-09 เดิม → DECIDED) · channel id / ชื่อ / คำอธิบาย / category / icon / color / MessagingStyle / iOS / inexact schedule **ไม่เปลี่ยน** — ตรงข้อตัดสิน
- `ui-spec.md` §2.3.2 (โค้ดตัวอย่าง + bullet channel) และ §7 Q-09 สอดคล้องกันและสอดคล้องกับโค้ด · ไม่เหลือ `defaultImportance` / `defaultPriority` ใน ui-spec

### 11.2 เทสต์

- `DECIDED_2026_11_09_Q09_channel_and_details_importance_high_heads_up` (Dev เพิ่ม, `notification_screens_test.dart`) — QA **ปรับให้เข้มขึ้น**
  - เดิมนับ `importance: Importance.high` รวม 2 ที่ทั้งไฟล์ ซึ่งยังผ่านได้แม้ค่าไปอยู่ผิด constructor
  - ตอนนี้ตรวจแยกทีละ constructor (`AndroidNotificationChannel(` มี `Importance.high` · `AndroidNotificationDetails(` มี `Importance.high` + `Priority.high`) และตรวจว่า `NotificationRules.androidChannelId == 'petpal_reminders'` ตาม ui-spec Q-09
  - ยังเก็บเงื่อนไขเดิมไว้ (มี 2 ที่ · ไม่มี `defaultImportance` / `defaultPriority`)
- Mutation check บนสำเนาใน scratchpad (ไม่แตะ `app/lib/`)
  - คืน channel เป็น `defaultImportance` → regex channel = false
  - คืน priority เป็น `defaultPriority` → regex details = false
  - เทสต์จับได้ทั้ง 2 กรณี
- ข้อจำกัด: เป็นการตรวจระดับซอร์สเท่านั้น เพราะ `LocalNotificationScheduler` เรียก plugin จริงและเทสต์หน่วยไม่ได้ (ui-spec §2.4.6)

| AC / ข้อตัดสิน | ชื่อเทสต์ | ผล |
|---|---|---|
| DECIDED Q-09 (owner 2026-11-09) heads-up | `DECIDED_2026_11_09_Q09_channel_and_details_importance_high_heads_up` | ผ่าน |
| AC-36 / AC-37 / D-6 (ถดถอย) | `AC36_AC37_DECIDED_D6_local_scheduler_details_in_source` | ผ่าน |

### 11.3 ผลการรัน

| รายการ | ค่า |
|---|---|
| `flutter analyze` (11:39:54) | **No issues found! (ran in 2.4s)** |
| `flutter test test/notification` (11:39:59) | **`00:12 +159: All tests passed!`** (158 เดิม + 1 Q-09) |
| `flutter test` ทั้งแอป (11:40:18) | **`01:21 +956: All tests passed!`** (955 เดิม + 1) |
| Bug ใหม่ | 0 · bug ที่ยังเปิด 0 |
| เทสต์ที่ QA แก้เองเพราะเทสต์ผิด | 0 (ปรับเทสต์ Dev ให้เข้มขึ้น 1 ข้อ — ไม่ได้ผิด) |

- รอบแรกของ QA มี analyze error 1 ข้อ (`Undefined name 'NotificationRules'`) เพราะ QA ลืม import ในเทสต์ที่แก้ ทำให้ไฟล์โหลดไม่ขึ้น · เพิ่ม import `notification_rules.dart` แล้วผ่าน · ไม่ใช่ bug ของโค้ด

### 11.4 ข้อสังเกต / คำถามค้าง (ไม่นับเป็น bug)

1. **ยังต้องยืนยันบนเครื่อง Android จริงหรือ emulator** ว่าแจ้งเตือนเด้งบนจอ (heads-up) และมีเสียง — เทสต์อัตโนมัติตรวจได้แค่ค่าในซอร์ส
   - ระบบอาจไม่เด้ง แม้ตั้ง high แล้ว เช่น เมื่อเปิดห้ามรบกวน (DND) หรือเมื่อผู้ใช้ปิด "แสดงบนหน้าจอ" ของ channel
2. **เครื่องที่ติดตั้งรุ่นก่อนต้องล้างข้อมูลแอปหรือติดตั้งใหม่**
   - Android 8+ ไม่ให้แอปเปลี่ยน importance ของ channel ที่สร้างไปแล้ว (id `petpal_reminders` คงเดิม) จึงยังเป็นแบบไม่เด้งจนกว่าจะล้างข้อมูล
   - ตอนทดสอบบนเครื่อง ให้ล้างข้อมูลแอปหรือติดตั้งใหม่ก่อน
   - ถ้าต้องการให้ผู้ใช้เดิมเด้งโดยไม่ต้องล้าง ต้องเปลี่ยน channel id หรือลบ channel เดิม — owner เป็นคนตัดสิน (Dev log ระบุไว้แล้ว)
3. ยังค้างจากรอบก่อน: §10.4-1 (AC-32 / Q-06) และ §7 ข้อ 3–4
