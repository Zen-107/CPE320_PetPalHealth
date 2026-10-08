# Review: บันทึกการกินน้ำ (water)

> ผู้ตรวจ: Reviewer agent · ตรวจทานโดย: เพื่อน C · ไฟล์ที่ตรวจ: docs/water/requirements.md, docs/water/ux-flow.md, docs/water/game-rules.md, app/pubspec.yaml, app/lib/main.dart, app/test/widget_test.dart

## 1. Checklist

| # | หัวข้อ | ผล (ผ่าน/ไม่ผ่าน/ตรวจไม่ได้) | เหตุผล |
|---|---|---|---|
| 1 | user story รูปแบบ ในฐานะ/ฉันอยาก/เพื่อ | ผ่าน | requirements.md มีตาราง User stories ครบถ้วนตามรูปแบบ US-1 ถึง US-5 ในฐานะ/ฉันอยาก/เพื่อ |
| 2 | acceptance criteria เป็นตัวเลข/เงื่อนไขที่ทดสอบได้ และอ้าง US | ผ่าน | requirements.md มี AC-1 ถึง AC-6 ที่ระบุเงื่อนไขและตัวเลขชัดเจนพร้อมอ้างอิง US |
| 3 | มี edge cases พร้อมผลที่คาดหวัง | ผ่าน | requirements.md มี EC-1 ถึง EC-3 ระบุสถานการณ์และผลที่คาดหวังครบถ้วน |
| 4 | มีสิ่งที่ไม่ทำในรอบนี้ | ผ่าน | requirements.md มี Section 6 ระบุสิ่งที่ไม่ได้ทำในรอบนี้ชัดเจน |
| 5 | กติกาเกมเป็นตารางตัวเลขครบ รวมพฤติกรรมที่ขอบเขต | ผ่าน | game-rules.md มีตารางค่าหลัก สถานะสัตว์เลี้ยง เหตุการณ์ และพฤติกรรมขอบเขตครบถ้วน |
| 6 | ตัวเลขตรงกันทุกไฟล์ | ผ่าน | ตัวเลขการเพิ่มขึ้นของแก้ว (1 แก้ว), พลังงาน (12.5%), Anti-Spam (5 นาที) และเวลารีเซ็ต (05:00 น.) ตรงกันใน requirements.md, ux-flow.md และ game-rules.md |
| 7 | ทุกหน้าจอโยงกับ US และมีสถานะผิดพลาด/ว่าง | ผ่าน | ux-flow.md ระบุหน้าจอ S-1 และ S-2 โยงกับ US ครบถ้วน พร้อมสถานะปกติ ว่าง และผิดพลาด (Anti-Spam) |
| 8 | มีชื่อไฟล์ภาพ assets ครบทุกสถานะ | ผ่าน | ux-flow.md ระบุชื่อไฟล์ภาพ assets ครบทุกสถานะ ทั้ง pet_critical.png, pet_tired.png, pet_happy.png และไอคอน |
| 9 | ใช้ข้อมูลสมมติ ไม่มีคำแนะนำทางการแพทย์ | ผ่าน | ข้อมูลทั้งหมดใน requirements.md เป็นข้อมูลสมมติสำหรับติดตามการดื่มน้ำและไม่มีคำแนะนำทางการแพทย์ |
| 10 | ขอบเขตทำทันเวลา | ผ่าน | ขอบเขตงานชัดเจน เหมาะสมกับรอบการพัฒนา |

## 2. รีวิวโค้ดใน app/ (ถ้ามี)
ยังไม่มีโค้ดฟีเจอร์ water ใน app/lib/ โค้ดปัจจุบันเป็นโครงสร้างแอปเริ่มต้น (Counter app) และเทสต์ใน app/test/widget_test.dart ทดสอบเฉพาะปุ่ม Counter พื้นฐาน ยังไม่ครอบคลุม Acceptance Criteria ของฟีเจอร์ water

## 3. ปัญหาที่พบ

| # | ความรุนแรง (สูง/กลาง/ต่ำ) | ไฟล์ / หัวข้อ | ปัญหา | ข้อเสนอแก้ |
|---|---|---|---|---|
| 1 | สูง | app/lib/ main.dart | โค้ดใน app/ ยังเป็นโค้ดเริ่มต้น (Counter app) ยังไม่ได้พัฒนา UI และ Business Logic ตาม requirements, ux-flow และ game-rules ของฟีเจอร์ water | พัฒนาโค้ด Flutter สำหรับหน้าจอ S-1 (Home / Water Tracker) และ S-2 (Monthly Report) พร้อมระบบ Local Storage และ Anti-Spam ตามเอกสารออกแบบ |

## 4. ตารางผลวัด agent

| ไฟล์ log | บทบาท | agent เวอร์ชัน | ผู้ให้บริการ / รุ่น | สถานะ | เวลา (วินาที) | จำนวนเรียก LLM | tokens | ต้องแก้มือ (คนกรอก) |
|---|---|---|---|---|---|---|---|---|
| 20261008-1159_product_water.md | product | 7eab1747 | gemini / gemini-3.5-flash-lite | ok | 6.9 | 1 | 2715 | - |
| 20261008-1305_product_water.md | product | 7eab1747 | gemini / gemini-3.5-flash-lite | ok | 12.1 | 1 | 2699 | - |
| 20261008-1322_product_water.md | product | 7eab1747 | gemini / gemini-3.5-flash-lite | ok | 11.7 | 1 | 2871 | - |
| 20261008-1417_product_water.md | product | 7eab1747 | gemini / gemini-3.5-flash-lite | ok | 6.5 | 1 | 2941 | - |
| 20261008-1429_product_water.md | product | 7eab1747 | gemini / gemini-3.5-flash-lite | ok | 7.1 | 1 | 2921 | - |
| 20261008-1440_product_water.md | product | 7eab1747 | gemini / gemini-3.5-flash-lite | ok | 5.8 | 1 | 2859 | - |
| 20261008-1448_product_water.md | product | 10566ba7 | gemini / gemini-3.5-flash-lite | ok | 5.1 | 1 | 2858 | - |
| 20261008-1458_product_water.md | product | 10566ba7 | gemini / gemini-3.5-flash-lite | ok | 5.8 | 1 | 2937 | - |
| 20261008-1519_product_water.md | product | f259cf3a | gemini / gemini-3.5-flash-lite | ok | 7.0 | 1 | 3377 | - |
| 20261008-1604_product_water.md | product | 59b6e2b6 | gemini / gemini-3.5-flash-lite | ok | 6.7 | 1 | 3472 | - |
| 20261008-1659_design_water.md | design | 834ab1f9 | gemini / gemini-3.5-flash-lite | ok | 13.4 | 2 | 9814 | - |
| 20261008-1700_review_water.md | review | 2f1432d8 | gemini / gemini-3.5-flash-lite | ok | 6.0 | 1 | 8536 | - |

## 5. สรุป
**ผล: ต้องแก้**

สิ่งที่ต้องแก้ก่อนส่ง Dev:
- พัฒนาโค้ดใน app/lib/ และเพิ่ม Unit/Widget tests ให้สอดคล้องกับ Requirements, UX Flow และ Game Rules ของฟีเจอร์ water เนื่องจากปัจจุบันยังมีเพียงโค้ดเริ่มต้น (Counter app) เท่านั้น
