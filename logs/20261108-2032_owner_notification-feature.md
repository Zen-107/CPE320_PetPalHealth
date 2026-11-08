# Log: owner · notification-feature · 2026-11-08 20:32

| รายการ | ค่า |
|---|---|
| สถานะ | สำเร็จ — Dev + QA ครบ 3 รอบ QA (bug-fix loop 2/3) ไม่มีบั๊กค้าง |
| ผู้บันทึก | owner (ผ่าน Claude Code — session หลักที่สั่ง sub-agent) |
| branch | `don't-fuck-my-Branch.-Bitch!!!!!` (งานทำใน worktree `claude/petpal-remote-control-c717e2` แล้ว fast-forward กลับ เพราะ session นี้แก้ไฟล์ใน main folder ตรง ๆ ไม่ได้) |

## ข้อตัดสิน owner — DECIDED (owner) 2026-11-08

ทีมให้ owner ตัดสินไปก่อน ทีมตรวจตอนรีวิว PR ข้อตัดสินชนะเอกสาร (ไม่ได้แก้ไฟล์เดิมใน docs/notification-feature/)

| ข้อ | เนื้อหา | ที่มา |
|---|---|---|
| D-1 | รูปโปรไฟล์กบ = `PetPose.notificationProfile` (PetCharacter) ไม่มี PNG · Person icon Android เรนเดอร์ 192 px ตอนรันแอป | design-review Q-01, ข้อตกลง PetCharacter |
| D-2 | ทางเข้า S-2 = ปุ่มตั้งค่าบน AppBar หน้า dashboard (`notification_settings_entry_button`) | AppBar water เต็ม 5 ปุ่ม |
| D-3 | ตัด "เดิน: บันทึกเอง" (AC-15 / EC-12) — steps ไม่มีปุ่มบันทึกขยับเอง | |
| D-4 | ค่าติดลบ / `daily_goal` = 0 → ไม่ส่งเรื่องนั้นในรอบวัน (EC-3) เฉพาะ notification ไม่เปลี่ยน A4 ของ 7day | |
| D-5 | Package `flutter_local_notifications` 22.3.3 (pin — 23.x ต้อง compileSdk 37 ที่ไม่มีในเครื่อง), `timezone` 0.11.2, `flutter_timezone` 5.1.1 | dev รอบ 2 |
| D-6 | ตั้งเวลาแบบไม่เป๊ะ `inexactAllowWhileIdle` ไม่ขอ exact alarm | |
| Q-03..Q-27 | ใช้ค่าชั่วคราวใน ui-spec §7 ทุกข้อ | |
| Q-28 | logout → ยกเลิกแจ้งเตือนทั้งหมด (cancelAll + ล้างแผนวัน) ไม่เปลี่ยน consent/สวิตช์ · เข้าระบบใหม่วันเดียวกันได้รับเพิ่มได้ถึง 6 ข้อความ (ยอมรับ) | |
| EC-9 | วางแผนเมื่อการ์ดถูกตอบแล้ว (ทางใดก็ได้) + สวิตช์ ON + สิทธิ์ GRANTED | dev คำถาม 3 |
| windows | ไฟล์ generated ใน `app/windows/` ไม่ commit (คืนค่าทุกครั้ง) | คำสั่งผู้ใช้ |
| 21:00 | ตั้งแต่ 21:00:00 ไม่ส่ง "อาหาร: ยังไม่กิน" เลย ส่งได้เฉพาะ "อาหาร: 21:00" (game-rules ชนะ) | QA รอบ 1 คำถาม 1 |
| QA r1 Q2 | จำนวน/เวลาข้อความล่าสุดที่เก็บในเครื่องอัปเดตเฉพาะตอน sync (ยอมรับ) | QA รอบ 1 คำถาม 2 |
| QA r3 Q1 | ยอมรับการตีความ Q-06 ระดับคิว: ถ้าคิวเลื่อนข้อความขั้นก่อนไปจนถึงเวลาครบกำหนดของขั้นถัดไปในสายเดียวกัน (น้ำ 2→4 ชม., อาหาร 12→15→18) ให้ตัดขั้นก่อนและส่งขั้นถัดไปแทน — ถือว่า "ยังเข้าเงื่อนไข" ของ AC-32 หมดเมื่อขั้นถัดไปของสายครบกำหนด · เทสต์ `R3_Q06_*` ยึดตามนี้ | QA รอบ 3 คำถาม 1 |

## วงจร Dev ↔ QA

| รอบ | ผล |
|---|---|
| Dev 1–2 | เขียนฟีเจอร์ · pin plugin 22.3.3 · `flutter build apk --debug` ผ่าน |
| QA 1 | 135/139 · BUG-NOTI-1 (re-plan ทำให้ waterFirst กลับมา), BUG-NOTI-2 (deep link ค้างหลังตอบการ์ด) |
| Dev 3 / QA 2 | BUG-NOTI-2 ปิด · BUG-NOTI-1 แก้บางส่วน (147/151) · เพิ่มกติกา 21:00 |
| Dev 4 / QA 3 | BUG-NOTI-1 ปิด (แก้ที่ต้นเหตุ + เทสต์ invariant re-plan ทุก 5 นาที) · 158/158 |

## ผลรันสุดท้าย (owner รันเอง 20:32 ใน app/)

| คำสั่ง | ผล |
|---|---|
| `flutter analyze` | `No issues found! (ran in 2.0s)` |
| `flutter test` | `00:52 +955: All tests passed!` (เดิม 797 + notification 158) |

## คำถามค้าง (ไม่ block)

1. ux-flow / game-rules / requirements ยังอ้าง `pet_profile_frog.png` และ "เดิน: บันทึกเอง" — Product/Design อัปเดตตาม D-1 / D-3
2. ไอคอนเล็ก monochrome บนแถบสถานะ Android (Q-10) — งาน Art
3. ยังไม่ได้ทดสอบบนเครื่องจริง Android / iOS · repo ไม่มี `app/ios/`
4. หน้า water ล้นแนวตั้ง ~68 px ที่ textScaler 1.5 (ปัญหาเดิม ไม่ใช่จาก notification)
