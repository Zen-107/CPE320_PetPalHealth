# Log: Dev — ฟีเจอร์แจ้งเตือน (notification-feature) · Q-09 เด้งบนจอ (heads-up)

- สถานะ: **สำเร็จ** · `flutter analyze` No issues · `flutter test test/notification` 159 ผ่านทั้งหมด
- วันที่: 2026-11-09 ~11:20–11:35 · worktree `.claude/worktrees/petpal-remote-control-c717e2` (branch `claude/petpal-remote-control-c717e2`) · ไม่ commit / push
- **DECIDED (owner 2026-11-09): เปลี่ยน ui-spec Q-09 — แจ้งเตือนต้องเด้งบนจอ (heads-up) · channel Android `petpal_reminders` ใช้ importance HIGH (เดิม `defaultImportance` = มีเสียง ไม่เด้ง)**
- แก้ docs/ เฉพาะ `docs/notification-feature/ui-spec.md` (เป็นของทีม UI) · ไฟล์อื่นใน docs/notification-feature/ ไม่แตะ

## ไฟล์ที่แก้ (4 ไฟล์ · ไม่มีไฟล์ใหม่ใน app/)

| ไฟล์ | สิ่งที่แก้ |
|---|---|
| `app/lib/features/notification/notification_local_scheduler.dart` | `createNotificationChannel`: `importance: Importance.high` + คอมเมนต์ `// DECIDED (owner 2026-11-09): Q-09 เปลี่ยน — เด้งบนจอ (heads-up) importance high` แทน ASSUMPTION Q-09 เดิม + หมายเหตุ channel เดิมไม่อัปเดต · `AndroidNotificationDetails`: `importance: Importance.high`, `priority: Priority.high` |
| `docs/notification-feature/ui-spec.md` | §2.3.2 โค้ดตัวอย่าง → `Importance.high` / `Priority.high` (DECIDED) + bullet อธิบาย channel / heads-up / การล้างข้อมูลแอป · §7 Q-09 → importance DECIDED (owner 2026-11-09) high, heads-up, มีเสียง |
| `app/test/notification/notification_screens_test.dart` | เพิ่มเทสต์ 1 ข้อในกลุ่ม `S-3 details (Dart level)`: `DECIDED_2026_11_09_Q09_channel_and_details_importance_high_heads_up` (ตรวจ source: `importance: Importance.high` 2 ที่, `Priority.high`, ไม่มี `defaultImportance` / `defaultPriority`) — ตามที่ผู้สั่งงานขอ · ไม่มีเทสต์เดิมที่ตรวจ importance เก่า |
| `logs/20261109-1135_dev_notification-q09-heads-up.md` | log นี้ |

- `app/windows/flutter/*` ถูก Flutter สร้างใหม่ตอนรัน → `git checkout -- app/windows` แล้ว

## สมมติฐาน (ASSUMPTION)

- ไม่ย้ายค่า importance ไปไว้ใน `NotificationRules` — ไฟล์ rules เป็น pure Dart (ไม่ import plugin) การย้ายต้องเพิ่ม import `flutter_local_notifications` ใน rules หรือสร้าง enum ซ้ำ → เก็บไว้ใน scheduler (แก้น้อยที่สุด)
- channel id คง `petpal_reminders` — Android ไม่เปลี่ยน importance ของ channel ที่สร้างแล้ว เครื่องที่ติดตั้งรุ่นก่อนต้องล้างข้อมูลแอป / ติดตั้งใหม่ (จดในคอมเมนต์โค้ด + ui-spec) · ไม่ทำโค้ดย้าย channel
- iOS ไม่เปลี่ยน (`presentBanner: true` อยู่แล้ว)

## package ที่เพิ่ม

- ไม่มี

## คำถามที่ค้าง

- ไม่มี (ข้อสังเกต: ผู้ใช้ที่ติดตั้งรุ่นก่อนจะยังไม่เด้งจนกว่าจะล้างข้อมูล — ถ้าต้องการให้เด้งทันทีโดยไม่ล้าง ต้องเปลี่ยน channel id หรือลบ channel เดิม ซึ่งต้องให้ owner ตัดสิน)
- เทสต์ที่ตรวจ heads-up ทำได้ระดับ source เท่านั้น — `LocalNotificationScheduler` เรียก plugin จริง เทสต์หน่วยไม่ได้ (ui-spec §2.4.6) · การเด้งจริงต้องทดสอบบนเครื่อง Android

## ตัวเลขการทำงาน

- เวลา: ~15 นาที
- ไฟล์สร้าง 1 (log) · แก้ 3 (scheduler, ui-spec, test)
- สมมติฐาน: 3 · คำถาม: 0

## ผล analyze / test

- `flutter analyze` (ใน app/): **No issues found!**
- `flutter test test/notification`: **All tests passed! (159)**
