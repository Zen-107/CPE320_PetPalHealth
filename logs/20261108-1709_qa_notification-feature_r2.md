# QA log: notification-feature (รอบ 2 — re-check bug-fix loop 1/3)

- บทบาท: QA · worktree `.claude/worktrees/petpal-remote-control-c717e2` (ใช้ branch เดิม ไม่ได้สลับ) · ไม่ได้ commit / push · ไม่ได้แก้ `app/lib/` · แก้ `docs/notification-feature/test-report.md` (เพิ่ม §9 + บรรทัดสรุปที่หัวไฟล์) · ไม่พบ hook ที่บล็อก
- อ่าน: `logs/20261108-1633_dev_notification-feature.md` ส่วน "รอบ 3" · `notification_logic.dart` (`_dropStaleSteps`, `schedule()`) · `water_home_screen.dart` `_showConsentCard`
- ไฟล์ที่แก้: `app/test/notification/notification_logic_test.dart` (ลบ `QUESTION_QA1_*`, +9 เทสต์) · `notification_controller_test.dart` (+2) · `notification_screens_test.dart` (+2)
- flutter แก้ `app/windows/` ทุกครั้งที่รัน → `git checkout -- app/windows/` คืนทุกครั้ง

## DECIDED (owner) 2026-11-08 รอบ 2
- ตั้งแต่ 21:00:00 ไม่ส่ง foodUnlogged (ตัดขั้นที่เลยเวลา และเอารายการที่ถูกคิวเลื่อนไปถึง ≥ 21:00 ออก) ส่งได้เฉพาะ foodNight · เปิดแอปครั้งแรก 21:00 → foodNight 21:00:00 ไม่มี foodUnlogged
- ค่า derive ในเครื่องอัปเดตตอน sync เท่านั้น — รับตามเดิม

## ตัวเลขการทำงาน (จากการรันจริง)
- เวลา: เริ่ม 17:06 (`date` → 20261108-1706) ถึง 17:09 (`date` → 20261108-1709) — รวมเขียน report/log จบราว 17:10
- จำนวนรอบที่รัน `flutter test`: **10** + `flutter analyze` **1**
  1. 17:07:19 logic → `+59 -3`
  2–4. logic `--plain-name` 3 ข้อ (เก็บผลจริง)
  5. 17:07:55 test/notification → `+147 -4`
  6. controller `--plain-name R2_BUG1` → ล้มที่ 16:10
  7. 17:08:27 ทั้งแอป → `00:22 +944 -4: Some tests failed.`
  8–10. แยกไฟล์ → logic `+59 -3` · controller `+32 -1` · screens `00:05 +56: All tests passed!`
  - analyze 17:08:24 → `No issues found! (ran in 1.5s)` (หลังจากนั้นแก้แค่ลบบรรทัด `openDashboard` 1 บรรทัดในเทสต์ BUG2 ก่อนรอบ 7 — รอบ 7–10 รันหลังแก้แล้ว)
- เทสต์ notification: **151** (L 62 · C 33 · W 56) · ผ่าน 147 · ไม่ผ่าน 4 · ทั้งแอป 944 / 4
- เทสต์ใหม่: 12 ข้อ (+ 1 ข้อเขียนใหม่ตาม DECIDED)
- Bug: รวม 2 ข้อจากรอบ 1 · Dev แก้แล้วปิดได้ **1** (BUG-NOTI-2) · ยังเปิด **1** (BUG-NOTI-1 แก้บางส่วน — waterFirst กลับมาหลังส่ง waterSecond ไปแล้ว) · bug ใหม่ 0
- เทสต์ที่ QA แก้เองเพราะเทสต์ผิด (รอบ 2): **0**
- คำถามค้าง: 2 (ข้อ 1–2 ปิดด้วย DECIDED)
