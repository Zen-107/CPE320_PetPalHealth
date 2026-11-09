# Review: ฟีเจอร์แจ้งเตือน (notification-feature)

> ผู้ตรวจ: Reviewer agent · ตรวจทานโดย: C (Reviewer) · ไฟล์ที่ตรวจ: docs/notification-feature/ (requirements.md, ux-flow.md, game-rules.md, test-report.md) และ app/lib/features/notification/ (10 ไฟล์) รวมถึงหลักฐานการทดสอบใน logs/

## 1. Checklist

| # | หัวข้อ | ผล (ผ่าน/ไม่ผ่าน/ตรวจไม่ได้) | เหตุผล |
|---|---|---|---|
| 1 | user story รูปแบบ ในฐานะ/ฉันอยาก/เพื่อ | ผ่าน | มีตาราง User stories ครบถ้วน 7 US (US-1 ถึง US-7) ใน requirements.md |
| 2 | acceptance criteria เป็นตัวเลข/เงื่อนไขที่ทดสอบได้ และอ้าง US | ผ่าน | มีตาราง Acceptance criteria ครบ 40 ข้อ (AC-1 ถึง AC-40) อ้างอิง US ชัดเจน |
| 3 | มี edge cases พร้อมผลที่คาดหวัง | ผ่าน | มีตาราง Edge cases ครบถ้วน 15 ข้อ (EC-1 ถึง EC-15) พร้อมผลที่คาดหวัง |
| 4 | มีสิ่งที่ไม่ทำในรอบนี้ | ผ่าน | มีหัวข้อ Out of scope ชัดเจน 10 ข้อ เช่น ไม่มี push จากเซิร์ฟเวอร์ ไม่รองรับข้ามเขตเวลา |
| 5 | กติกาเกมเป็นตารางตัวเลขครบ รวมพฤติกรรมที่ขอบเขต | ผ่าน | มีตารางค่าหลัก ตารางข้อความเงื่อนไข และตารางสถานะ/ข้อมูลที่เก็บในเครื่องครบถ้วนใน game-rules.md |
| 6 | ตัวเลขตรงกันทุกไฟล์ | ผ่าน | ตัวเลขเกณฑ์เวลา เปอร์เซ็นต์ (80.00%, 100.00%) เพดานข้อความ (6) และระยะห่าง (30 นาที) ตรงกันทุกไฟล์เอกสารและในโค้ด |
| 7 | ทุกหน้าจอโยงกับ US และมีสถานะผิดพลาด/ว่าง | ผ่าน | มีตารางหน้าจอ S-1, S-2, S-3 พร้อมสถานะ NORMAL, EMPTY, ERROR, PERMISSION_DENIED ครบถ้วนใน ux-flow.md |
| 8 | มีชื่อไฟล์ภาพ assets ครบทุกสถานะ | ผ่าน | กำหนดชื่อไฟล์ภาพ assets/images/pet_profile_frog.png สำหรับ S-1 และ Android Notification ชัดเจน |
| 9 | ใช้ข้อมูลสมมติ ไม่มีคำแนะนำทางการแพทย์ | ผ่าน | ใช้ข้อมูลสมมติทั้งหมด และมีข้อกำหนดห้ามเพิ่มคำแนะนำเรื่องปริมาณน้ำ แคลอรี่ หรือสุขภาพ |
| 10 | ขอบเขตทำทันเวลา | ผ่าน | พัฒนาและผ่านการทดสอบครบถ้วนตามหลักฐานใน test-report.md และ log |

## 2. รีวิวโค้ดใน app/
โค้ดใน app/lib/features/notification/ (10 ไฟล์: notification_rules.dart, notification_models.dart, notification_logic.dart, notification_repository.dart, notification_scheduler.dart, notification_local_scheduler.dart, notification_avatar.dart, notification_controller.dart, screens/notification_settings_screen.dart, widgets/notification_consent_card.dart) และการปรับแต่ง main.dart, water_home_screen.dart, dashboard_screen.dart, signup_controller.dart, AndroidManifest.xml, build.gradle.kts, pubspec.yaml ทำตาม Acceptance Criteria และกติกาใน game-rules.md ครบถ้วน เทสต์ใน app/test/notification/ (notification_logic_test.dart, notification_controller_test.dart, notification_screens_test.dart ร่วมกับ notification_test_helpers.dart) ครอบคลุม AC-1 ถึง AC-40 และ EC-1 ถึง EC-15 อย่างสมบูรณ์ผ่านการทดสอบ 158/158 ข้อ (ผ่านทั้งหมด ไม่มีข้อผิดพลาด)

## 3. ปัญหาที่พบ
| # | ความรุนแรง (สูง/กลาง/ต่ำ) | ไฟล์ / หัวข้อ | ปัญหา | ข้อเสนอแก้ |
|---|---|---|---|---|
| 1 | ต่ำ | test-report.md §11 | ต้องยืนยันบนเครื่อง Android จริงหรือ emulator ว่าแจ้งเตือนเด้งบนจอ (heads-up) และมีเสียง | ทดสอบบนอุปกรณ์ Android จริงก่อนเผยแพร่ |

## 4. ตารางผลวัด agent
| ไฟล์ log | บทบาท | agent เวอร์ชัน | ผู้ให้บริการ / รุ่น | สถานะ | เวลา (วินาที) | จำนวนเรียก LLM | tokens | ต้องแก้มือ (คนกรอก) |
|---|---|---|---|---|---|---|---|---|
| 20261103-0156_product_notification-feature.md | product | e698a8b2 | gemini / gemini-3.5-flash-lite | ok | 13.8 | 1 | 9673 | - |
| 20261103-0215_product_notification-feature.md | product | 2d2b3793 | gemini / gemini-3.5-flash-lite | ok | 15.7 | 1 | 13364 | - |
| 20261103-0222_product_notification-feature.md | product | ae2b4cf4 | gemini / gemini-3.5-flash-lite | ok | 14.0 | 1 | 12547 | - |
| 20261103-0232_product_notification-feature.md | product | 42ca6715 | gemini / gemini-3.5-flash-lite | ok | 12.8 | 1 | 12331 | - |
| 20261103-0241_product_notification-feature.md | product | 8ff3d98c | gemini / gemini-3.5-flash-lite | fail | 275.6 | 2 | None | - |
| 20261103-0318_product_notification-feature.md | product | 8ff3d98c | gemini / gemini-3.5-flash-lite | ok | 77.4 | 1 | 15119 | - |
| 20261104-2347_design_notification-feature.md | design | 02075db6 | gemini / gemini-3.5-flash-lite | ok | 45.6 | 2 | 24052 | - |
| 20261105-0012_design_notification-feature.md | design | 87bc2395 | gemini / gemini-3.5-flash-lite | ok | 37.9 | 2 | 28691 | - |
| 20261105-1907_design_review_notification-feature.md | design_review | ac395134 | gemini / gemini-3.5-flash-lite | ok | 22.8 | 1 | 26227 | - |

## 5. สรุป
**ผล: พร้อมส่ง Dev**

สิ่งที่ต้องแก้ก่อนส่ง Dev:
- ไม่มี (ฟีเจอร์ผ่านการพัฒนาและทดสอบครบถ้วนตามเกณฑ์ทั้งหมดแล้ว)
