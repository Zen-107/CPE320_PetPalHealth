# Review: บันทึกการกินน้ำ (water)

> ผู้ตรวจ: Reviewer agent · ตรวจทานโดย: เพื่อน A · ไฟล์ที่ตรวจ: docs/water/requirements.md, docs/water/ux-flow.md, docs/water/game-rules.md, docs/water/test-report.md, logs/20261008-2135_dev_water.md, logs/20261008-2315_qa_water.md, app/pubspec.yaml, app/lib/main.dart, app/lib/features/water/water_controller.dart, app/lib/features/water/water_logic.dart, app/lib/features/water/water_models.dart, app/lib/features/water/water_repository.dart, app/lib/features/water/water_rules.dart, app/lib/features/water/screens/water_home_screen.dart, app/lib/features/water/screens/monthly_report_screen.dart, app/lib/features/water/widgets/pet_avatar.dart, app/lib/features/water/widgets/pet_painter.dart, app/lib/features/water/widgets/asset_image_or_icon.dart, app/test/water/

## 1. Checklist

| # | หัวข้อ | ผล (ผ่าน/ไม่ผ่าน/ตรวจไม่ได้) | เหตุผล |
|---|---|---|---|
| 1 | user story รูปแบบ ในฐานะ/ฉันอยาก/เพื่อ | ผ่าน | มี US-1 ถึง US-5 ครบถ้วนตามรูปแบบใน `docs/water/requirements.md` Section 3 |
| 2 | acceptance criteria เป็นตัวเลข/เงื่อนไขที่ทดสอบได้ และอ้าง US | ผ่าน | มี AC-1 ถึง AC-6 ระบุเงื่อนไข ก่อน/เมื่อ/แล้ว และค่าที่ทดสอบได้ชัดเจน พร้อมอ้างอิง US-1 ถึง US-5 ใน `requirements.md` Section 4 |
| 3 | มี edge cases พร้อมผลที่คาดหวัง | ผ่าน | มี EC-1 ถึง EC-3 พร้อมระบุสถานการณ์และผลที่คาดหวังใน `requirements.md` Section 5 และครอบคลุมขอบเขตเพิ่มเติมใน `game-rules.md` Section 4 |
| 4 | มีสิ่งที่ไม่ทำในรอบนี้ | ผ่าน | ระบุ Out of scope ชัดเจนใน `requirements.md` Section 6 เช่น ไม่มีระบบลดพลังงานตามเวลา และไม่ต่อ Backend |
| 5 | กติกาเกมเป็นตารางตัวเลขครบ รวมพฤติกรรมที่ขอบเขต | ผ่าน | มีตารางค่าหลัก ช่วงสถานะสัตว์เลี้ยง เหตุการณ์ และพฤติกรรมที่ขอบเขตครบถ้วนใน `docs/water/game-rules.md` |
| 6 | ตัวเลขตรงกันทุกไฟล์ | ผ่าน | ตรวจสอบตัวเลข เช่น การเพิ่มพลังงาน 12.5% ต่อแก้ว, Anti-Spam 5 นาที, รีเซ็ต 05:00 น., และขอบเขตแก้วน้ำ 0-3 / 4-6 / 7+ ตรงกันทุกไฟล์เอกสารและโค้ด |
| 7 | ทุกหน้าจอโยงกับ US และมีสถานะผิดพลาด/ว่าง | ผ่าน | ใน `docs/water/ux-flow.md` มีการระบุหน้าจอ S-1 และ S-2 โยงกับ US และระบุสถานะปกติ, ว่าง, ผิดพลาด (Anti-Spam Triggered) ชัดเจน |
| 8 | มีชื่อไฟล์ภาพ assets ครบทุกสถานะ | ผ่าน | ระบุชื่อไฟล์ PNG ครบถ้วนใน `ux-flow.md` Section 5 และ `game-rules.md` Section 2 (`pet_critical.png`, `pet_tired.png`, `pet_happy.png`, `water_plus.png`, `calendar_report.png`) |
| 9 | ใช้ข้อมูลสมมติ ไม่มีคำแนะนำทางการแพทย์ | ผ่าน | ระบุการใช้ข้อมูลสมมติใน Local Storage (`daily_water_count`, `water_energy_percentage`, ฯลฯ) ไม่มีคำแนะนำทางการแพทย์ |
| 10 | ขอบเขตทำทันเวลา | ผ่าน | เอกสารและโค้ดถูกพัฒนาและทดสอบครบถ้วนตามข้อกำหนดของรอบ MVP พร้อมหลักฐาน test-report และ log ครบถ้วน |

## 2. รีวิวโค้ดใน app/
โค้ดใน `app/lib/features/water/` ทำงานสอดคล้องกับ AC และกติกาเกมใน `game-rules.md` อย่างครบถ้วน โดยอ้างอิงจากหลักฐานการทดสอบจริงใน `test-report.md` ซึ่งระบุว่ามีการรันเทสต์ผ่านทั้งหมด 135/135 เทสต์ (รวม Unit logic, Controller/Storage, Widget screens, Decision logic/storage/screens, และ PNG asset tests) โดย `flutter analyze` รายงาน `No issues found!`. เทสต์มีความครอบคลุมทั้ง AC-1 ถึง AC-6, Edge cases (EC-1 ถึง EC-3), ข้อตัดสินพิเศษของ Zen-107 (ขอบเดือน, นาฬิกาย้อนกลับ, ข้อมูลเสียใน SharedPreferences, การแสดงผลภาพ PNG และ Fallback ไปยัง CustomPainter เมื่อโหลดภาพไม่ได้, และ Toast 2 วินาที)

## 3. ปัญหาที่พบ

| # | ความรุนแรง (สูง/กลาง/ต่ำ) | ไฟล์ / หัวข้อ | ปัญหา | ข้อเสนอแก้ |
|---|---|---|---|---|
| - | - | ไม่มี | ไม่พบบั๊กหรือข้อผิดพลาดจากการตรวจสอบโค้ดและหลักฐานการทดสอบ (135 เทสต์ผ่านทั้งหมด และ analyze ผ่าน) | - |

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
| 20261008-1804_review_water.md | review | 2f1432d8 | gemini / gemini-3.5-flash-lite | ok | 6.2 | 1 | 11478 | - |
| 20261009-1549_review_water.md | review | e9c44e01 | gemini / gemini-3.5-flash-lite | ok | 9.1 | 1 | 43213 | - |
| 20261009-1620_review_water.md | review | 484690ad | gemini / gemini-3.5-flash-lite | ok | 29.2 | 1 | 43822 | - |

## 5. สรุป
**ผล: พร้อมส่ง Dev**

สิ่งที่ต้องแก้ก่อนส่ง Dev:
- ไม่มี
