# QA log: notification-feature (รอบ 1)

- บทบาท: QA · feature: notification-feature · worktree `.claude/worktrees/petpal-remote-control-c717e2` (branch `claude/petpal-remote-control-c717e2` — ไม่ได้สลับ) · ไม่ได้ commit / push · ไม่ได้แก้ `app/lib/` · ไม่ได้แก้ `docs/` นอกจาก `docs/notification-feature/test-report.md` (สร้างใหม่) · ไม่พบ hook หรือสิทธิ์บล็อก
- อ่านแล้ว: docs/notification-feature/requirements.md, game-rules.md, ux-flow.md, ui-spec.md (§0, §2.4.4, §6, §7) · logs/20261108-1633_dev_notification-feature.md (รอบ 1–2) · โค้ด `app/lib/features/notification/` (10 ไฟล์) + diff ของ main.dart, water_home_screen.dart, dashboard_screen.dart, signup_controller.dart · รูปแบบ docs/7day/test-report.md, logs/20261031-1545_qa_7day.md, app/test/dashboard + seven_day
- ไฟล์ที่สร้าง: `app/test/notification/notification_test_helpers.dart`, `notification_logic_test.dart`, `notification_controller_test.dart`, `notification_screens_test.dart` · `docs/notification-feature/test-report.md` · log นี้
- ไฟล์ชั่วคราว: `app/test/notification/tmp_debug_test.dart` (ไล่สาเหตุ BUG-NOTI-2, 2 รอบ — ลบแล้ว) · ผล `flutter test` ทั้งแอปเก็บใน scratchpad (นอก repo)
- `app/windows/flutter/*` ถูก flutter แก้ทุกครั้งที่รัน → `git checkout -- app/windows/` คืนทุกครั้ง (git status สุดท้ายไม่มี app/windows/)

## ข้อตัดสิน owner — DECIDED (owner) 2026-11-08

- D-1..D-6 ตาม ui-spec §0 · Q-03..Q-27 ใช้ค่าที่ ui-spec §7 เลือก
- Q-28 logout → cancelAll + ล้างแผนวัน ไม่เปลี่ยน consent/สวิตช์ · เข้าระบบใหม่วันเดียวกันได้เพิ่มถึง 6 (ยอมรับ)
- EC-9 วางแผนเมื่อการ์ดถูกตอบแล้ว (ทางใดก็ได้) + ON + GRANTED
- flutter_local_notifications pin 22.3.3 · inexact → ตรวจเวลาที่ตั้ง
- AC-15 / EC-12 ตัดออก (เทสต์ DECIDED ยืนยันว่าไม่มี) · AC-37 ตรวจระดับ Dart

## ตัวเลขการทำงาน (จากการรันจริง)

- เวลา: เริ่ม 16:42 (`date` → 20261108-1642) ถึง 17:02 (`date` → 20261108-1702) ≈ 20 นาที
- จำนวนรอบที่รัน `flutter test`: **19 รอบ** (รวมไล่บั๊กชั่วคราว 2 รอบ) + `flutter analyze` **1 รอบ**
  1. 16:50:05 logic → `+50 -2` (เทสต์ผิด 2: D3 เจอคอมเมนต์, T9 scheduledAt == now)
  2. logic `--plain-name DECIDED_D3` → `-1` (ดูรายละเอียด)
  3. logic `--plain-name T9_` → `-1` (ดูรายละเอียด)
  4. logic → `+52: All tests passed!`
  5. 16:52:57 controller → `+29 -2` (เทสต์ผิด 1: EC1 dialog gate · พบ BUG-NOTI-1 ที่ EC14)
  6. logic + controller (เพิ่มเทสต์ T-18 วางแผนซ้ำ) → `+82 -3` (BUG-NOTI-1 ×3)
  7. logic `--plain-name T18_Q06_replan_at_1405` → `-1` (เก็บผลจริงลง report)
  8. 16:56:35 screens → compile ไม่ผ่าน (ลืม import)
  9. screens → `+50 -4` (เทสต์ผิด 3: Image ทั้งจอ, substring inexact, คอมเมนต์ manifest · BUG-NOTI-2)
  10. tmp_debug_test (ชั่วคราว) → pendingDeepLink ค้างหลังการ์ดปิด
  11. tmp_debug_test (ชั่วคราว) → notify ครั้งถัดไปจึงนำทาง
  12. 16:58:26 test/notification → `+135 -4`
  13. 16:58:56–16:59:16 `flutter test` ทั้งแอป → `00:17 +932 -4: Some tests failed.`
  14–16. แยกไฟล์ logic / controller / screens (ดูชื่อเทสต์ที่ล้ม)
  17–19. แยกไฟล์ (ดูจำนวน) → logic `+52 -2` · controller `+30 -1` · screens `00:05 +53 -1` (17:00:04)
  - analyze: 16:58:44 `flutter analyze` → `No issues found! (ran in 1.9s)` (หลังจากนั้นไม่ได้แก้โค้ดเทสต์อีก)
- เทสต์ notification: **139** (L 54 · C 31 · W 54) · ผ่าน **135** · ไม่ผ่าน **4**
- ทั้งแอป: **932 ผ่าน / 4 ไม่ผ่าน** (ก่อนเริ่มตาม dev log: 797 ผ่าน / 0 → เทสต์เดิมยังผ่านทั้งหมด, 4 ที่ล้มเป็นเทสต์ใหม่ของ notification)
- AC ในขอบเขต มีเทสต์ 39/39 (AC-15 ตัดออก D-3) · EC 14/14 (EC-12 ตัดออก D-3) · T-1..T-18 18/18 · AC/EC ที่ยังไม่มีเทสต์: 0
- Bug ที่เจอ: **2** (BUG-NOTI-1 ปานกลาง — วางแผนซ้ำแล้ว waterFirst ที่ถูกตัดตาม Q-06 กลับมา / foodNight หลุด · BUG-NOTI-2 ต่ำ — deep link ค้างหลังตอบการ์ด S-1) · Bug ที่ Dev แก้แล้ว: **0** (ยังไม่ส่งกลับ Dev)
- เทสต์ที่ QA แก้เองเพราะเทสต์ผิด: **6** — `DECIDED_D3_AC15_EC12_no_manual_move_message_text_or_key`, `T9_AC28_six_committed_no_pending_five_committed_one_more`, `EC1_rapid_toggle_while_os_dialog_open_last_state_off_wins`, `DECIDED_D1_card_pet_is_PetCharacter_notificationProfile_wink_120`, `AC36_AC37_DECIDED_D6_local_scheduler_details_in_source`, `DECIDED_D5_D6_manifest_pubspec_main_setup` (+ compile fix 1 ครั้ง: import ที่ขาด)
- คำถามค้าง: 4 (test-report §7) — ข้อใหม่ของ QA 2 ข้อ (21:00 กับ Q-06, ค่า derive ในเครื่องอัปเดตตอน sync)
