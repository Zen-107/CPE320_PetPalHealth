# Review: dashboard (dashboard)

> ผู้ตรวจ: Reviewer agent · ตรวจทานโดย: เพื่อน C · ไฟล์ที่ตรวจ: docs/dashboard/requirements.md, docs/dashboard/ux-flow.md, docs/dashboard/game-rules.md, docs/dashboard/ui-spec.md, docs/dashboard/test-report.md, app/lib/features/dashboard/ และ app/test/dashboard/

## 1. Checklist

| # | หัวข้อ | ผล (ผ่าน/ไม่ผ่าน/ตรวจไม่ได้) | เหตุผล |
|---|---|---|---|
| 1 | user story รูปแบบ ในฐานะ/ฉันอยาก/เพื่อ | ผ่าน | มีตาราง User stories ครบถ้วน 5 US ใน requirements.md |
| 2 | acceptance criteria เป็นตัวเลข/เงื่อนไขที่ทดสอบได้ และอ้าง US | ผ่าน | มี Acceptance criteria ครบถ้วน 5 AC พร้อมเงื่อนไขก่อน/เมื่อ/แล้ว และอ้างอิง US |
| 3 | มี edge cases พร้อมผลที่คาดหวัง | ผ่าน | มี Edge cases ครบถ้วน 5 ข้อ (EC-1 ถึง EC-5) และหลักฐานการทดสอบครอบคลุม |
| 4 | มีสิ่งที่ไม่ทำในรอบนี้ | ผ่าน | มีหัวข้อสิ่งที่ไม่ทำในรอบนี้ (Out of scope) ชัดเจนใน requirements.md §5 |
| 5 | กติกาเกมเป็นตารางตัวเลขครบ รวมพฤติกรรมที่ขอบเขต | ผ่าน | มี game-rules.md ระบุตารางค่าหลัก Dynamic Alert Queue และสถานะอารมณ์สัตว์เลี้ยงครบถ้วน |
| 6 | ตัวเลขตรงกันทุกไฟล์ | ผ่าน | ตัวเลขสูตรคำนวณ คะแนน Cap ขอบอารมณ์ และเวลาตัดรอบ 05:00 น. ตรงกันทุกเอกสารและโค้ด (หลังผ่านรอบข้อตัดสินและ Dev รอบ 3) |
| 7 | ทุกหน้าจอโยงกับ US และมีสถานะผิดพลาด/ว่าง | ผ่าน | ux-flow.md ระบุ S-1 หน้าแดชบอร์ดหลัก โยงกับ US และมีสถานะปกติ, ว่าง/ข้อมูลไม่สมบูรณ์, และผิดพลาด/ข้ามช่วงเวลา |
| 8 | มีชื่อไฟล์ภาพ assets ครบทุกสถานะ | ผ่าน | ux-flow.md ระบุไฟล์ assets (pet_crying.png, pet_dazed.png, pet_bubbly.png, pet_cheerful.png) และมีข้อตัดสิน D-1 รองรับการใช้ PetCharacter |
| 9 | ใช้ข้อมูลสมมติ ไม่มีคำแนะนำทางการแพทย์ | ผ่าน | ใช้ข้อมูลสมมติในเครื่อง (Local Storage / Session) ไม่มีคำแนะนำทางการแพทย์ |
| 10 | ขอบเขตทำทันเวลา | ผ่าน | ดำเนินการตามแผนงาน ครอบคลุมการพัฒนาและทดสอบผ่าน 116/116 เทสต์ในรอบที่ 3 |

## 2. รีวิวโค้ดใน app/
โค้ดใน app/lib/features/dashboard/ และการเชื่อมต่อใน app/lib/features/water/screens/water_home_screen.dart ทำตาม Acceptance Criteria และกติกาใน game-rules.md อย่างถูกต้องครบถ้วนตามข้อตัดสินของ owner ในรอบที่ 3 (การปัดลง/floor คะแนนทุกหมวด, เงื่อนไข Priority 4 「ฉันหิว」, การแสดงผล CTA Banner เมื่อไม่มีเป้าหมายอาหาร, และปุ่มรายงานของหน้า water เป็น IconButton พร้อม tooltip) หลักฐานจาก test-report.md ยืนยันว่าเทสต์ dashboard ทั้งหมด 116 เทสต์ผ่าน 100% (ผ่าน 116 / ไม่ผ่าน 0), เทสต์ทั้งแอปผ่าน 719 / ไม่ผ่าน 0 และ `flutter analyze` ไม่พบข้อผิดพลาด (No issues found!)

## 3. ปัญหาที่พบ

| # | ความรุนแรง (สูง/กลาง/ต่ำ) | ไฟล์ / หัวข้อ | ปัญหา | ข้อเสนอแก้ |
|---|---|---|---|---|
| - | - | - | ไม่พบปัญหา (PASS) อ้างอิงผลทดสอบรอบที่ 3 ที่ผ่านทุกเทสต์ | - |

## 4. ตารางผลวัด agent

| ไฟล์ log | บทบาท | agent เวอร์ชัน | ผู้ให้บริการ / รุ่น | สถานะ | เวลา (วินาที) | จำนวนเรียก LLM | tokens | ต้องแก้มือ (คนกรอก) |
|---|---|---|---|---|---|---|---|---|
| 20261030-1313_product_dashboard.md | product | 75d978ad | gemini / gemini-3.5-flash-lite | ok | 9.8 | 1 | 3162 | - |
| 20261030-1421_design_dashboard.md | design | 18116912 | gemini / gemini-3.5-flash-lite | ok | 13.2 | 2 | 13713 | - |
| 20261030-1626_design_dashboard.md | design | 0a643e01 | gemini / gemini-3.5-flash-lite | ok | 13.5 | 2 | 14452 | - |
| 20261030-1650_design_dashboard.md | design | 0a643e01 | gemini / gemini-3.5-flash-lite | ok | 58.1 | 2 | 14156 | - |
| 20261030-1757_design_review_dashboard.md | design_review | ac395134 | gemini / gemini-3.5-flash-lite | ok | 7.0 | 1 | 13484 | - |

## 5. สรุป
**ผล: พร้อมส่ง Dev**

สิ่งที่ต้องแก้ก่อนส่ง Dev:
- ไม่มี
