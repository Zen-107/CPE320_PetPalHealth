# บันทึกการออกแบบ agent: product — เจ้าของ: เพื่อน A

| เวอร์ชัน | hash (จาก log) | วันที่ | แก้อะไร | ทำไม (เห็นปัญหาอะไรในผลรอบก่อน) | log ที่ใช้ทดสอบ | ผลหลังแก้ |
|---|---|---|---|---|---|---|
| v1 | 7eab1747 | 2026-10-08 | ออกแบบเวอร์ชันแรก | กำหนดบทบาท Product Manager และสร้าง requirements | 20261008-1159_product_water.md | สร้าง requirements.md แต่ยังมีข้อสงสัยเรื่อง Energy Decay และช่วงพลังงานหลวมไป |
| v2 | 59b6e2b6 | 2026-10-08 | ตัดระบบ Energy Decay ออก และกำหนดช่วงแก้วน้ำชัดเจน (Exact Matching) | ระบบ Decay ทำให้เป้าหมาย 8 แก้วไม่เต็ม 100% ระหว่างวัน และช่วง % หลวมเกินไป | 20261008-1604_product_water.md | สร้าง requirements.md ชัดเจน ไร้ความกุมกวม มีเงื่อนไขรีเซ็ตตอน 05:00 น. และกำหนดแก้วน้ำเป๊ะ |
| v3 | adbc4c4c | 2026-10-09 | ปรับ Prompt เป็น Generic Template ({feature}) และแยกโครงสร้าง Technical Rules กับ Edge Cases ให้ชัดเจน | เปลี่ยนมาทำฟีเจอร์การเดิน (steps) และต้องการสร้าง requirements.md ที่ครอบคลุม Edge Cases ครบ 5 ข้อตาม Checklist | 20261013-1035_product_steps.md | ได้เอกสาร docs/steps/requirements.md ที่สมบูรณ์ มีสเปก Goal 3 กลุ่ม, ตัดรอบ 05:00 น., Pet Mapping 4 ระดับ, สรุป PNG Card รายเดือน และมี Edge Cases ครบ 5 ข้อ
