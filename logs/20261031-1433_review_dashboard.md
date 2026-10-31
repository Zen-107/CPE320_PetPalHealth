# Log: review · dashboard · 2026-10-31 14:33

<!-- meta: {"role": "review", "feature": "dashboard", "time": "2026-10-31 14:33", "status": "ok", "provider": "gemini", "model": "gemini-3.5-flash-lite", "attempts": 1, "seconds": 7.4, "llm_calls": 1, "total_tokens": 102982, "agent_version": "484690ad"} -->

| รายการ | ค่า |
|---|---|
| สถานะ | สำเร็จ |
| ผู้ให้บริการ / รุ่น | gemini / gemini-3.5-flash-lite |
| ลำดับความพยายาม | gemini: สำเร็จ |
| เวลารวม | 7.4 วินาที |
| จำนวนครั้งที่เรียก LLM | 1 |
| tokens (prompt / completion / total) | 101634 / 1348 / 102982 |
| ไฟล์ input | docs/dashboard/requirements.md, docs/dashboard/ux-flow.md, docs/dashboard/game-rules.md, docs/dashboard/test-report.md, logs/20261031-0824_dev_dashboard.md, logs/20261031-0846_qa_dashboard.md, app/pubspec.yaml, app/lib/features/dashboard/dashboard_controller.dart, app/lib/features/dashboard/dashboard_logic.dart, app/lib/features/dashboard/dashboard_models.dart, app/lib/features/dashboard/dashboard_rules.dart, app/lib/features/dashboard/screens/dashboard_screen.dart, app/lib/features/food/food_controller.dart, app/lib/features/food/food_logic.dart, app/lib/features/food/food_menu_table.dart, app/lib/features/food/food_models.dart, app/lib/features/food/food_nutrition_parser.dart, app/lib/features/food/food_profile_source.dart, app/lib/features/food/food_repository.dart, app/lib/features/food/food_rules.dart, app/lib/features/food/screens/food_dashboard_screen.dart, app/lib/features/food/screens/food_meal_screen.dart, app/lib/features/food/screens/food_profile_screen.dart, app/lib/features/food/widgets/food_profile_cta_banner.dart, app/lib/features/food/widgets/food_shared_min_height_box.dart, app/lib/features/food/widgets/food_toast.dart, app/lib/features/signup/screens/signup_email_screen.dart, app/lib/features/signup/screens/signup_forgot_password_screen.dart, app/lib/features/signup/screens/signup_gate.dart, app/lib/features/signup/screens/signup_new_password_screen.dart, app/lib/features/signup/screens/signup_onboarding_screen.dart, app/lib/features/signup/screens/signup_reset_sent_screen.dart, app/lib/features/signup/screens/signup_welcome_screen.dart, app/lib/features/signup/signup_controller.dart, app/lib/features/signup/signup_logic.dart, app/lib/features/signup/signup_models.dart, app/lib/features/signup/signup_repository.dart, app/test/dashboard/dashboard_controller_test.dart (เฉพาะชื่อ test/group), app/test/dashboard/dashboard_logic_test.dart (เฉพาะชื่อ test/group), app/test/dashboard/dashboard_screens_test.dart (เฉพาะชื่อ test/group), app/test/dashboard/dashboard_test_helpers.dart (เฉพาะชื่อ test/group), app/test/food/food_controller_test.dart (เฉพาะชื่อ test/group), app/test/food/food_logic_test.dart (เฉพาะชื่อ test/group), app/test/food/food_screens_test.dart (เฉพาะชื่อ test/group), app/test/food/food_test_helpers.dart (เฉพาะชื่อ test/group), app/test/shared/pet/pet_character_test.dart (เฉพาะชื่อ test/group), app/test/shared/pet/pet_screens_cheer_test.dart (เฉพาะชื่อ test/group), app/test/signup/signup_logic_test.dart (เฉพาะชื่อ test/group), app/test/signup/signup_repository_test.dart (เฉพาะชื่อ test/group), app/test/signup/signup_screens_test.dart (เฉพาะชื่อ test/group), app/test/steps/steps_controller_test.dart (เฉพาะชื่อ test/group), app/test/steps/steps_logic_test.dart (เฉพาะชื่อ test/group), app/test/steps/steps_screens_test.dart (เฉพาะชื่อ test/group), app/test/water/water_controller_test.dart (เฉพาะชื่อ test/group), app/test/water/water_decisions_logic_test.dart (เฉพาะชื่อ test/group), app/test/water/water_decisions_screens_test.dart (เฉพาะชื่อ test/group), app/test/water/water_decisions_storage_test.dart (เฉพาะชื่อ test/group), app/test/water/water_logic_test.dart (เฉพาะชื่อ test/group), app/test/water/water_pet_character_test.dart (เฉพาะชื่อ test/group), app/test/water/water_screens_test.dart (เฉพาะชื่อ test/group) |
| ไฟล์ output | docs/dashboard/review.md |
| agent | agents/reviewer.md (เวอร์ชัน 484690ad) |
| --note | - |

## ความพยายามที่ 1 — gemini (gemini-3.5-flash-lite) — สำเร็จ, 7.4 วินาที

### Agent

- ไฟล์: agents/reviewer.md
- role: Software Quality Reviewer
- goal: Review the dashboard requirements, UX flow, game rules, and implementation evidence against the approved specification. Identify reproducible defects, missing requirements, inconsistencies, and test failures, then report clear evidence and actionable findings without modifying the implementation.
- backstory:

~~~~text
You are a careful and evidence-driven Software Quality Reviewer on the PetPal Health engineering team.

Your responsibility is to independently review a feature against the approved requirements, UX flow, game rules, and available implementation evidence. You check both documents and the implementation when the relevant files are provided, and you pay particular attention to inconsistencies between them.

You are strict about correctness but do not reject work based on personal preference. A feature is considered ready only when it satisfies the approved requirements and game rules, the expected UX flow is consistent with the implementation, and available test or implementation evidence supports the result. If important evidence is missing, report the missing evidence instead of assuming the feature works.

You must not modify another agent's code or documents yourself. You must not invent requirements, expected values, test results, or measurements. You must not guess the contents of files that were not provided.

For every significant finding, report:
- what was found
- what was expected
- what actually happened
- the evidence or file/location supporting the finding
- why it matters
- what should be checked or fixed

When reporting measurements or test results, use only values supported by the available evidence. Do not fabricate numbers or claim that a test passed without evidence.

Your review should balance strictness and practicality. Judge the implementation against approved project evidence and requirements, not personal preference. Do not create new requirements during a review. Do not allow real defects to pass simply to keep work moving, but do not raise issues based only on subjective preferences or requirements that were never approved.

At the end of each review, clearly distinguish between:
- PASS: no blocking issue found based on available evidence
- NEEDS_FIX: one or more requirements, rules, UX expectations, or implementation behaviors are not satisfied
- INSUFFICIENT_EVIDENCE: the available files or evidence are not enough to determine whether the feature passes

The quality of this agent is measured by whether its findings are reproducible, evidence-based, relevant to the approved specification, and useful for the developer to act on.

## Evidence Coverage and Review Limitations

Before deciding the final status, verify how much of the required evidence was actually available and reviewed.

* Distinguish test names, test/group listings, test summaries, and actual test execution results. A list of test names alone does not prove that the tests passed.
* Do not claim a test passed, a test suite completed successfully, or a specific number of tests passed unless the available evidence explicitly supports that claim.
* If input files were truncated, omitted, summarized, or only partially provided, identify the limitation and explain which conclusions may be affected.
* When logs are available, identify the relevant log files and use their actual contents as evidence. Do not assume that every log was read merely because the logs directory was included as an input.
* Check whether test evidence corresponds to the implementation being reviewed. If this cannot be verified, state the limitation explicitly.
* Separate confirmed defects from unresolved questions, missing evidence, and assumptions. Do not report an unresolved question as a confirmed defect.
* Base the final status on the evidence actually reviewed, not on the expected outcome or a previous review's conclusion.
~~~~

### Tasks (prompt ที่ main.py สร้าง)

#### Task → docs/dashboard/review.md

~~~~text
ฟีเจอร์: dashboard

งานของคุณ: รีวิวเอกสารทั้งหมด โค้ดใน app/lib/ และหลักฐานการทดสอบ (test-report.md + เทสต์ใน app/test/ + log ของ dev/qa) ด้วย checklist ใน template ทีละข้อ (ผ่าน/ไม่ผ่าน + เหตุผล), ระบุปัญหาพร้อมไฟล์/หัวข้อ/ข้อเสนอแก้, ตรวจว่าตัวเลขในทุกไฟล์ตรงกัน, สรุปผลว่า 'พร้อมส่ง Dev' หรือ 'ต้องแก้' และเติมตารางผลวัด agent จากข้อมูล log ที่ให้

ข้อมูลประกอบ:
=== docs/dashboard/requirements.md ===
# Requirements: dashboard (dashboard)

> สถานะ: draft · ผู้เขียน: Product agent · ผู้ตรวจ: เพื่อน A · อ้างอิง Issue: #101

## 1. สรุปฟีเจอร์
ฟีเจอร์ Dashboard ของแอป PetPal Health แสดงผลรวมสุขภาพประจำวันของผู้ใช้ผ่านคะแนนเฉลี่ยและสัตว์เลี้ยงเสมือนจริงที่ปรับเปลี่ยนอารมณ์ตามพฤติกรรมการบันทึกข้อมูลสุขภาพ (อาหาร, การก้าวเดิน, การดื่มน้ำ) เพื่อกระตุ้นให้ผู้ดูแลใส่ใจสุขภาพตนเองอย่างต่อเนื่อง

## 2. User stories

| ID | ในฐานะ | ฉันอยาก | เพื่อ |
|---|---|---|---|
| US-1 | ผู้ใช้แอป PetPal Health | ดูคะแนนสุขภาพรวมประจำวันบนหน้า Dashboard | ทราบสถานะสุขภาพภาพรวมของตนเองในแต่ละวัน |
| US-2 | ผู้ใช้แอป PetPal Health | เห็นสัตว์เลี้ยงเสมือนเปลี่ยนอารมณ์ตามคะแนนสุขภาพรวม | รับรู้ระดับความสุขหรือความผิดปกติของสุขภาพตนเองผ่านสัตว์เลี้ยง |
| US-3 | ผู้ใช้แอป PetPal Health | เห็นข้อความแนะนำหรือแจ้งเตือนที่หมุนเวียนแสดงผลบนหน้าจอ | ทราบสิ่งที่ต้องปรับปรุงเร่งด่วนเมื่อพฤติกรรมสุขภาพไม่เป็นไปตามเป้าหมาย |
| US-4 | ผู้ใช้แอป PetPal Health | ดูแถบความคืบหน้าและข้อมูลแยกตามหมวดหมู่ (อาหาร, การก้าวเดิน, การดื่มน้ำ) | ตรวจสอบรายละเอียดพฤติกรรมสุขภาพรายหมวดหมู่ได้ชัดเจน |
| US-5 | ผู้ใช้ระบบ | ให้ระบบตัดรอบวันใหม่และรีเซ็ตข้อมูลสุขภาพอ้างอิงตามเวลา 05:00 น. (ICT) | เริ่มต้นบันทึกและคำนวณคะแนนของวันใหม่ได้อย่างถูกต้องตาม Server Time |

## 3. Acceptance criteria

| ID | อ้างถึง | เงื่อนไข (ก่อน / เมื่อ / แล้ว) | ค่าที่ทดสอบได้ |
|---|---|---|---|
| AC-1 | US-1 | ก่อน: ผู้ใช้อยู่หน้า Dashboard และมีข้อมูลคะแนน Food, Steps, Water — เมื่อ: ระบบคำนวณคะแนนเฉลี่ย — แล้ว: แสดงคะแนนรวมคำนวณจาก (Food + Steps + Water) / 3 โดยค่าสูงสุดถูก Cap ไว้ไม่เกิน 100% และแสดงผลบน UI เป็นจำนวนเต็ม (Integer) เสมอ | คะแนนเฉลี่ยคำนวณถูกต้องตามสูตร, ค่าสูงสุดไม่เกิน 100, แสดงผลเป็น Integer |
| AC-2 | US-2 | ก่อน: คะแนนรวมถูกคำนวณแล้ว — เมื่อ: ตรวจสอบช่วงคะแนนกับอารมณ์สัตว์เลี้ยง — แล้ว: แสดงอารมณ์สัตว์เลี้ยงตรงตามตาราง (0-30% ร้องไห้, 31-60% เหม่อลอย, 61-80% ออรุ่มเจ๊าะ, 81-100% ยิ้มร่าเริง) | คะแนน 0-30 = ร้องไห้, 31-60 = เหม่อลอย, 61-80 = ออรุ่มเจ๊าะ, 81-100 = ยิ้มร่าเริง |
| AC-3 | US-3 | ก่อน: มีเงื่อนไขคำแนะนำที่ต้องแสดงตามลำดับความสำคัญ — เมื่อ: ข้อความแสดงผลบน UI — แล้ว: แสดงข้อความวนลูปทุก 5 วินาที ตาม Priority 1: `"แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว"` (พร้อมหลอดอาหารสีแดง), Priority 2: `"ดื่มน้ำๆ"`, Priority 3: `"ขยับร่างกายหน่อย อีกนิดๆ"`, Priority 4: `"ฉันหิว"` โดยมีกฎ Dynamic Queue คือคัดชื่อออกจากคิวทันทีเมื่อแก้ปัญหาสำเร็จ | ข้อความหมุนเวียนทุก 5 วินาที ตรงตาม String ที่กำหนดเป๊ะ และหลุดจากคิวทันทีที่แก้ปัญหาเสร็จ |
| AC-4 | US-4 | ก่อน: ผู้ใช้อยู่หน้า Dashboard — เมื่อ: ระบบแสดง UI Components ของฟีเจอร์ — แล้ว: แสดงผลครบถ้วนตาม 3 ฟีเจอร์หลัก (คะแนนรวม, อารมณ์สัตว์เลี้ยง, แถบความคืบหน้าแยกหมวดหมู่ Food/Steps/Water) | UI แสดงผลครบทั้ง 3 ฟีเจอร์หลัก |
| AC-5 | US-5 | ก่อน: เวลาปัจจุบันถึง 04:59 น. (ICT) — เมื่อ: นาฬิกา Server Time ถึงเวลา 05:00 น. (ICT) — แล้ว: ระบบทำการตัดรอบวันใหม่และรีเซ็ตข้อมูลสุขภาพประจำวันทันที | ตัดรอบวันและรีเซ็ตข้อมูลที่เวลา 05:00 น. (ICT) อิง Server Time |

## 4. Edge cases

| ID | สถานการณ์ | ผลที่คาดหวัง |
|---|---|---|
| EC-1 | คะแนนรวมจากการคำนวณ (Food + Steps + Water) / 3 มีค่าเกิน 100% (เช่น ได้ 120%) | ระบบทำการ Cap ค่าสูงสุดไว้ที่ 100% และแสดงผลบน UI เป็น 100% |
| EC-2 | ผู้ใช้แก้ปัญหาใน Priority 1 (Overeating หรือปัญหาอาหาร) สำเร็จในขณะที่ข้อความกำลังแสดงผลอยู่ | ระบบทำการคัดชื่อข้อความ Priority 1 ออกจาก Dynamic Queue ทันที และข้ามไปแสดงข้อความในลำดับถัดไปโดยไม่รอครบ 5 วินาที |
| EC-3 | เวลา Server Time เปลี่ยนผ่านเข้าสู่ช่วงเวลา 05:00 น. (ICT) พอดีขณะที่ผู้ใช้งานกำลังเปิดหน้า Dashboard ค้างไว้ | หน้าจอ Dashboard ทำการรีเฟรชข้อมูลและรีเซ็ตค่าสถานะสุขภาพประจำวันเป็นค่าเริ่มต้นของวันใหม่โดยอัตโนมัติทันที |
| EC-4 | ข้อมูลคะแนนในหมวดหมู่ใดหมวดหมู่หนึ่งเป็นค่าติดลบหรือข้อมูลว่าง (Null) | ระบบกำหนดให้คะแนนหมวดนั้นมีค่าเท่ากับ 0 ก่อนนำไปคำนวณสูตรเฉลี่ยหาร 3 เพื่อป้องกันข้อผิดพลาด |
| EC-5 | คะแนนรวมคำนวณออกมาเป็นทศนิยม (เช่น 65.66%) | ระบบทำการปัดเศษและแสดงผลบน UI เป็นจำนวนเต็ม (Integer) เสมอ (แสดงผลเป็น 66%) |

## 5. สิ่งที่ไม่ทำในรอบนี้ (Out of scope)
- ระบบแจ้งเตือนแบบ Push Notification ไปยังมือถือของผู้ใช้ นอกเหนือจากการแสดงข้อความวนลูปในหน้า Dashboard
- ระบบประวัติย้อนหลัง (Historical Data) เกินกว่า 1 วัน (รอบวันปัจจุบันตัดที่ 05:00 น.)
- การปรับแต่งหรือเปลี่ยนตัวละครสัตว์เลี้ยงนอกเหนือจาก 4 ระดับอารมณ์ที่กำหนด

## 6. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น)

| ข้อมูล | ชนิด/หน่วย | เก็บที่ไหน |
|---|---|---|
| คะแนนอาหาร (Food Score) | Integer (0-100) | Local Storage / Session Database |
| คะแนนการก้าวเดิน (Steps Score) | Integer (0-100) | Local Storage / Session Database |
| คะแนนการดื่มน้ำ (Water Score) | Integer (0-100) | Local Storage / Session Database |
| คะแนนสุขภาพรวม (Total Score) | Integer (0-100) | Local Storage / Session Database |
| สถานะอารมณ์สัตว์เลี้ยง (Pet Mood) | String (ร้องไห้ / เหม่อลอย / ออรุ่มเจ๊าะ / ยิ้มร่าเริง) | Local Storage / Session Database |
| คิวข้อความแจ้งเตือน (Alert Queue) | Array of Strings / Objects | Local Storage / Session Database |

## 7. คำถามที่ยังเปิดอยู่
- ทีม Design ต้องยืนยันภาพประกอบของสัตว์เลี้ยงทั้ง 4 ระดับอารมณ์ว่ารองรับขนาดหน้าจอ Responsive ทุกขนาดหรือไม่
- การซิง크 Server Time ระหว่าง Client กับ Server จะใช้ Timezone ตรงที่ 05:00 น. (ICT) เสมอสำหรับผู้ใช้ทุกคนใช่หรือไม่

=== จบ docs/dashboard/requirements.md ===

=== docs/dashboard/ux-flow.md ===
# UX flow: dashboard (dashboard)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: เพื่อน B · อ้างอิง: requirements.md

## 1. รายการหน้าจอ

| ID | ชื่อหน้าจอ | จุดประสงค์ | อ้างถึง |
|---|---|---|---|
| S-1 | หน้าจอแดชบอร์ดหลัก (Dashboard Main Screen) | แสดงคะแนนสุขภาพรวม, อารมณ์สัตว์เลี้ยงเสมือนจริง, ข้อความแนะนำวนลูป และแถบความคืบหน้าแยกตามหมวดหมู่ (อาหาร, การก้าวเดิน, การดื่มน้ำ) | US-1, US-2, US-3, US-4, US-5, AC-1, AC-2, AC-3, AC-4, AC-5 |

## 2. องค์ประกอบบนหน้าจอ

### S-1 หน้าจอแดชบอร์ดหลัก (Dashboard Main Screen)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| Total Score Card | แถบแสดงผลตัวเลข | `คะแนนสุขภาพรวม: [Integer]%` (ค่าคำจากสูตรเฉลี่ยและ Cap สูงสุด 100%) | อัปเดตแบบเรียลไทม์เมื่อคะแนน Food, Steps หรือ Water เปลี่ยนแปลง |
| Pet Character Display | รูปภาพตัวละคร (Image Asset) | ภาพตัวละครสัตว์เลี้ยงตามสถานะอารมณ์ปัจจุบัน | อัปเดตภาพทันทีเมื่อคะแนนรวมเปลี่ยนช่วงอารมณ์ (ร้องไห้, เหม่อลอย, ออรุ่มเจ๊าะ, ยิ้มร่าเริง) |
| Dynamic Alert Banner | แถบข้อความแจ้งเตือน (Banner) | ข้อความหมุนเวียน 4 ลำดับ:<br>1. `"แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว"`<br>2. `"ดื่มน้ำๆ"`<br>3. `"ขยับร่างกายหน่อย อีกนิดๆ"`<br>4. `"ฉันหิว"` | หมุนเวียนเปลี่ยนข้อความทุก 5 วินาที หรือตัดออกจากคิวทันทีเมื่อแก้ปัญหาสำเร็จ |
| Food Progress Bar | แถบความคืบหน้า (Progress Bar) | คะแนนอาหาร: `[Integer]%` (หลอดสีแดงหากเข้าเงื่อนไข Priority 1) | แสดงความคืบหน้าคะแนนหมวดอาหาร (Food Score) |
| Steps Progress Bar | แถบความคืบหน้า (Progress Bar) | คะแนนการก้าวเดิน: `[Integer]%` | แสดงความคืบหน้าคะแนนหมวดการก้าวเดิน (Steps Score) |
| Water Progress Bar | แถบความคืบหน้า (Progress Bar) | คะแนนการดื่มน้ำ: `[Integer]%` | แสดงความคืบหน้าคะแนนหมวดการดื่มน้ำ (Water Score) |

## 3. ขั้นตอนการใช้งาน (happy path)
1. ผู้ใช้เปิดแอปพลิเคชัน PetPal Health เข้าสู่หน้าแดชบอร์ดหลัก (S-1)
2. ระบบทำการตรวจสอบ Server Time และโหลดข้อมูลคะแนนสุขภาพประจำวัน (Food, Steps, Water) จาก Local Storage / Session Database
3. ระบบคำนวณคะแนนสุขภาพรวมด้วยสูตร `(Food + Steps + Water) / 3` โดยหากผลลัพธ์เกิน 100% จะถูก Cap ไว้ที่ 100% และปัดเศษเป็นจำนวนเต็ม (Integer)
4. ระบบประเมินช่วงคะแนนรวมเพื่อกำหนดสถานะอารมณ์สัตว์เลี้ยง (`CRYING`, `DAZED`, `BUBBLY`, `CHEERFUL`) และแสดงภาพ Asset ที่ตรงกัน
5. ระบบตรวจสอบเงื่อนไขคิวข้อความแจ้งเตือน (Alert Queue) และแสดงผลข้อความวนลูปทุก 5 วินาที หรืออัปเดตคิวทันทีเมื่อผู้ใช้แก้ปัญหาสำเร็จ
6. ระบบแสดงผลแถบความคืบหน้าแยกตามหมวดหมู่ (Food, Steps, Water) บนหน้าจอครบถ้วนตามข้อมูลปัจจุบัน

## 4. สถานะของหน้าจอ

| หน้าจอ | สถานะ | เงื่อนไขที่ทำให้เกิด | สิ่งที่แสดง |
|---|---|---|---|
| S-1 | ปกติ (Normal State) | ข้อมูลคะแนนสุขภาพครบถ้วน และเวลาปัจจุบันยังไม่ถึงรอบ 05:00 น. (ICT) | แสดงคะแนนรวม, สัตว์เลี้ยงตามอารมณ์จริง, ข้อความแจ้งเตือนในคิว และแถบความคืบหน้าทั้ง 3 หมวด |
| S-1 | ว่าง / ข้อมูลไม่สมบูรณ์ (Empty/Fallback State) | ข้อมูลคะแนนในหมวดหมู่ใดหมวดหมู่หนึ่งเป็นค่าติดลบหรือข้อมูลว่าง (Null) | ระบบกำหนดให้คะแนนหมวดนั้นมีค่าเท่ากับ 0 อัตโนมัติ แล้วคำนวณคะแนนรวมตามปกติ พร้อมแสดงแถบความคืบหน้าที่ 0% เพื่อป้องกันหน้าจอผิดพลาด |
| S-1 | ผิดพลาด / ข้ามช่วงเวลา (Error / Time Crossing State) | นาฬิกา Server Time ถึงเวลา 05:00 น. (ICT) พอดีขณะที่ผู้ใช้งานกำลังเปิดหน้า Dashboard ค้างไว้ | หน้าจอทำการรีเฟรชข้อมูลโดยอัตโนมัติทันที และรีเซ็ตค่าสถานะสุขภาพประจำวันเป็นค่าเริ่มต้นของวันใหม่ |

## 5. ไฟล์ภาพ assets

| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายภาพ |
|---|---|---|
| `assets/images/pet_crying.png` | S-1 / สถานะคะแนนรวม 0-30% | ภาพสัตว์เลี้ยงหน้าตาน่าสงสาร กำลังร้องไห้ แสดงถึงคะแนนสุขภาพอยู่ในระดับวิกฤต |
| `assets/images/pet_dazed.png` | S-1 / สถานะคะแนนรวม 31-60% | ภาพสัตว์เลี้ยงหน้าตาเหม่อลอย นั่งนิ่งๆ แสดงถึงคะแนนสุขภาพอยู่ในระดับปานกลางค่อนไปทางต่ำ |
| `assets/images/pet_bubbly.png` | S-1 / สถานะคะแนนรวม 61-80% | ภาพสัตว์เลี้ยงหน้าตายิ้มแย้ม สดใส ออรุ่มเจ๊าะ แสดงถึงคะแนนสุขภาพอยู่ในระดับดี |
| `assets/images/pet_cheerful.png` | S-1 / สถานะคะแนนรวม 81-100% | ภาพสัตว์เลี้ยงกระโดดโลดเต้น ยิ้มร่าเริง แสดงถึงคะแนนสุขภาพอยู่ในระดับยอดเยี่ยม |

## 6. คำถามถึง Product

1. ข้อเสนอแนะจาก Design: ทีม Design จะจัดเตรียมภาพประกอบสัตว์เลี้ยงทั้ง 4 ขนาดให้รองรับ Responsive Layout แบบ Flexbox/Grid ที่ปรับสัดส่วนอัตโนมัติเพื่อรองรับทุกขนาดหน้าจอ / กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule): ให้ Dev ใช้ภาพขนาดมาตรฐาน 300x300 pixels แบบ Scalable Image Container ไปก่อน / การประเมินสถานะการบล็อก: Blocking: ไม่ใช่ เพราะเป็นเรื่องการจัดวาง Asset บนหน้าจอซึ่งไม่กระทบตรรกะการคำนวณระบบ
2. ข้อเสนอแนะจาก Design: ยืนยันให้ใช้ Timezone มาตรฐาน `Asia/Bangkok (ICT)` เป็นเกณฑ์กลางเดียวสำหรับผู้ใช้ทุกคนในการตัดรอบเวลา 05:00 น. / กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule): ให้ Dev ตั้งค่าระบบเปรียบเทียบเวลาอิงตาม Timezone `GMT+7 (ICT)` เสมอในโค้ดฝั่ง Server/Client / การประเมินสถานะการบล็อก: Blocking: ไม่ใช่ เพราะมีความชัดเจนตามเงื่อนไข AC-5 และข้อกำหนดระบบอยู่แล้ว

=== จบ docs/dashboard/ux-flow.md ===

=== docs/dashboard/game-rules.md ===
# กติกาเกม: dashboard (dashboard)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: เพื่อน B · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ความหมาย | ค่า | หน่วย | อ้างถึง |
|---|---|---|---|---|
| `foodScore` | คะแนนอาหาร (Food Score) | 0 ถึง 100 (กรณีติดลบหรือ Null ระบบปรับเป็น 0) | เปอร์เซ็นต์ (%) | US-4, AC-1, AC-4, EC-4 |
| `stepsScore` | คะแนนการก้าวเดิน (Steps Score) | 0 ถึง 100 (กรณีติดลบหรือ Null ระบบปรับเป็น 0) | เปอร์เซ็นต์ (%) | US-4, AC-1, AC-4, EC-4 |
| `waterScore` | คะแนนการดื่มน้ำ (Water Score) | 0 ถึง 100 (กรณีติดลบหรือ Null ระบบปรับเป็น 0) | เปอร์เซ็นต์ (%) | US-4, AC-1, AC-4, EC-4 |
| `totalScore` | คะแนนสุขภาพรวมคำนวณจาก `(Food + Steps + Water) / 3` (Cap สูงสุดไม่เกิน 100% ปัดเศษเป็น Integer เสมอ) | 0 ถึง 100 | เปอร์เซ็นต์ (%) | US-1, AC-1, EC-1, EC-5 |
| `alertInterval` | ระยะเวลาในการหมุนเวียนข้อความแจ้งเตือนบนหน้า Dashboard | 5 | วินาที (Seconds) | US-3, AC-3 |
| `resetHour` | เวลาตัดรอบวันใหม่และรีเซ็ตข้อมูลสุขภาพประจำวันอิงตาม Server Time | 05:00 | น. (ICT / GMT+7) | US-5, AC-5, EC-3 |

### 1.1 ตารางลำดับความสำคัญของข้อความแจ้งเตือน (Dynamic Alert Queue Table)

| ลำดับ (Priority) | ข้อความแจ้งเตือน (Exact String) | เงื่อนไขการกระตุ้น (Trigger Condition) | เงื่อนไขการเคลียร์หลุดจากคิว (Queue Removal) |
|---|---|---|---|
| Priority 1 (สูงสุด) | `"แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว"` | ผู้ใช้บันทึกอาหารเกินเป้าหมาย (Overeating > 100 kcal / หลอดอาหารแสดงสีแดง) | ผู้ใช้จัดการปัญหาอาหาร หรือข้ามสู่รอบวันใหม่ |
| Priority 2 | `"ดื่มน้ำๆ"` | ปริมาณการดื่มน้ำยังไม่ถึงเป้าหมายประจำวัน (`waterScore < 100%`) | ผู้ใช้บันทึกการดื่มน้ำจนถึงเป้าหมาย (`waterScore >= 100%`) |
| Priority 3 | `"ขยับร่างกายหน่อย อีกนิดๆ"` | จำนวนก้าวเดินยังไม่ถึงเป้าหมายประจำวัน (`stepsScore < 100%`) | ผู้ใช้เดินครบตามเป้าหมายประจำวัน (`stepsScore >= 100%`) |
| Priority 4 | `"ฉันหิว"` | ผู้ใช้ยังไม่ได้บันทึกอาหารมื้อใดๆ หรือคะแนนอาหารต่ำกว่าเกณฑ์ | ผู้ใช้ทำการบันทึกอาหารเข้าระบบสำเร็จ |

*หมายเหตุ Dynamic Queue:* ข้อความในคิวจะหมุนเวียนแสดงผลทุก 5 วินาที หากผู้ใช้แก้ปัญหาของ Priority ใดสำเร็จ ระบบจะคัดชื่อข้อความนั้นออกจากคิวทันทีและสลับไปแสดงข้อความลำดับถัดไปโดยไม่ต้องรอครบ 5 วินาที (AC-3, EC-2)

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง

| สถานะ (Code Enum) | ช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพ (Asset / Preset) |
|---|---|---|
| `CRYING (ร้องไห้)` | มากกว่าหรือเท่ากับ 0% และน้อยกว่าหรือเท่ากับ 30% (`[0, 30]`) | `assets/images/pet_crying.png` |
| `DAZED (เหม่อลอย)` | มากกว่า 30% และน้อยกว่าหรือเท่ากับ 60% (`(30, 60]`) | `assets/images/pet_dazed.png` |
| `BUBBLY (ออรุ่มเจ๊าะ)` | มากกว่า 60% และน้อยกว่าหรือเท่ากับ 80% (`(60, 80]`) | `assets/images/pet_bubbly.png` |
| `CHEERFUL (ยิ้มร่าเริง)` | มากกว่า 80% และน้อยกว่าหรือเท่ากับ 100% (`(80, 100]`) | `assets/images/pet_cheerful.png` |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| คำนวณคะแนนรวมปกติ (Food: 60, Steps: 90, Water: 60) | Food: 60, Steps: 90, Water: 60 | Total Score: 70%, Pet Mood: `BUBBLY (ออรุ่มเจ๊าะ)` | คำนวณจาก (60 + 90 + 60) / 3 = 70 อ้างอิง AC-1, AC-2 |
| คำนวณคะแนนรวมได้ผลลัพธ์เป็นทศนิยม (Food: 70, Steps: 60, Water: 67) | Food: 70, Steps: 60, Water: 67 | Total Score: 66%, Pet Mood: `BUBBLY (ออรุ่มเจ๊าะ)` | คำนวณจาก (70 + 60 + 67) / 3 = 65.66% ปัดเศษเป็นจำนวนเต็มได้ 66% อ้างอิง EC-5 |
| ข้อมูลหมวดอาหารเป็นค่าว่างหรือติดลบ (Food: -10, Steps: 90, Water: 90) | Food: -10, Steps: 90, Water: 90 | Food: 0, Total Score: 60%, Pet Mood: `DAZED (เหม่อลอย)` | ระบบแปลงค่าติดลบเป็น 0 ก่อนคำนวณ (0 + 90 + 90) / 3 = 60 ตกในช่วง (30, 60] อ้างอิง EC-4 |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ที่ทดสอบได้ |
|---|---|
| คะแนนรวมจากการคำนวณเกิน 100% (เช่น Food: 100, Steps: 100, Water: 160 -> เฉลี่ยได้ 120%) | ระบบทำการ Cap ค่าสูงสุดของคะแนนรวมไว้ที่ 100% เสมอ และแสดงผลบน UI เป็น 100% พร้อมแสดงสถานะสัตว์เลี้ยงเป็น `CHEERFUL (ยิ้มร่าเริง)` อ้างอิง AC-1, EC-1 |
| ผู้ใช้แก้ปัญหาใน Priority 1 (Overeating หรือปัญหาอาหาร) สำเร็จในขณะที่ข้อความกำลังแสดงผลอยู่ | ระบบทำการคัดชื่อข้อความ Priority 1 ออกจาก Dynamic Queue ทันที และข้ามไปแสดงข้อความในลำดับถัดไป (Priority 2: `"ดื่มน้ำๆ"`) ทันทีโดยไม่ต้องรอให้ครบ 5 วินาที อ้างอิง AC-3, EC-2 |
| เวลา Server Time เปลี่ยนผ่านเข้าสู่ช่วงเวลา 05:00 น. (ICT) พอดีขณะที่ผู้ใช้งานกำลังเปิดหน้า Dashboard ค้างไว้ | หน้าจอ Dashboard ทำการรีเฟรชข้อมูลและรีเซ็ตค่าสถานะสุขภาพประจำวันทั้งหมด (`foodScore`, `stepsScore`, `waterScore`, `totalScore`) เป็นค่าเริ่มต้นของวันใหม่โดยอัตโนมัติทันที อ้างอิง AC-5, EC-3 |

## 5. คำถามถึง Product

1. **ข้อเสนอแนะจาก Design:** ทีม Design จะจัดเตรียมภาพประกอบสัตว์เลี้ยงทั้ง 4 ขนาดให้รองรับ Responsive Layout แบบ Flexbox/Grid ที่ปรับสัดส่วนอัตโนมัติเพื่อรองรับทุกขนาดหน้าจอ
   - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ให้ Dev ใช้ภาพขนาดมาตรฐาน 300x300 pixels แบบ Scalable Image Container ไปก่อน
   - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่ เพราะเป็นเรื่องการจัดวาง Asset บนหน้าจอซึ่งไม่กระทบตรรกะการคำนวณระบบ
2. **ข้อเสนอแนะจาก Design:** ยืนยันให้ใช้ Timezone มาตรฐาน `Asia/Bangkok (ICT)` เป็นเกณฑ์กลางเดียวสำหรับผู้ใช้ทุกคนในการตัดรอบเวลา 05:00 น.
   - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ให้ Dev ตั้งค่าระบบเปรียบเทียบเวลาอิงตาม Timezone `GMT+7 (ICT)` เสมอในโค้ดฝั่ง Server/Client
   - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่ เพราะมีความชัดเจนตามเงื่อนไข AC-5 และข้อกำหนดระบบอยู่แล้ว

=== จบ docs/dashboard/game-rules.md ===

=== docs/dashboard/test-report.md ===
# Test report: dashboard (QA รอบที่ 1 + รอบที่ 3)

> **รอบ 3 (2026-10-31 09:22–09:31) อยู่ท้ายไฟล์ §10–§15**: ผลล่าสุดหลังข้อตัดสิน owner รอบ 3 และ dev r3 (`logs/20261031-0921_dev_dashboard_r3.md`) คือ dashboard 116 เทสต์ **ผ่าน 116 / ไม่ผ่าน 0** · ทั้งแอป **719 ผ่าน / 0 ไม่ผ่าน** · `flutter analyze` No issues found! · BUG-DASH-1 ปิดแล้ว (owner ยึด A-7) · ปรับเทสต์ 12 ตัวเพราะข้อตัดสินใหม่ เพิ่มเทสต์ใหม่ 10 ตัว · ไม่พบบั๊กใหม่ · §0–§9 ด้านล่างเป็นผลรอบ 1 (คงไว้ตามเดิม)

> ผู้ทดสอบ: QA agent · วันที่ 2026-10-31 (08:26–08:47) · โค้ดที่ทดสอบ: `app/lib/features/dashboard/` + `dashboard_entry_button` ใน `app/lib/features/water/screens/water_home_screen.dart` (dev v1, `logs/20261031-0824_dev_dashboard.md`)
> อ้างอิง: requirements.md, game-rules.md, ux-flow.md, ui-spec.md + ข้อตัดสิน owner ด้านล่าง (ค่าคาดหวังทั้งหมดมาจากเอกสาร/ข้อตัดสิน ไม่ได้ลอกจากโค้ด)
> เทสต์: `app/test/dashboard/dashboard_logic_test.dart` (L), `dashboard_controller_test.dart` (C), `dashboard_screens_test.dart` (W) + ตัวช่วย `dashboard_test_helpers.dart` (ไม่มีเทสต์ในไฟล์นี้ ใช้ `FakeTimers` / `profileOf` จาก `app/test/food/food_test_helpers.dart`)
> ไม่ได้แก้โค้ดใน `app/lib/` · ไม่ได้แก้ไฟล์อื่นใน `docs/dashboard/` · ไม่ได้ commit / push

## 0. ข้อตัดสิน owner — DECIDED (owner ชั่วคราว, รอทีมยืนยัน)

ข้อไหนขัดกับเอกสาร ให้ข้อตัดสินชนะ เทสต์ที่อิงข้อตัดสินจะมีคำว่า `DECIDED_` ในชื่อ

| รหัส | เนื้อหา | มีผลต่อเทสต์ |
|---|---|---|
| D-1 | สัตว์เลี้ยงใช้ `PetCharacter`: CRYING [0,30] → `PetPose.dashboardCrying`, DAZED (30,60] → `dashboardDazed`, BUBBLY (60,80] → `dashboardBubbly` (= `waterHappy`), CHEERFUL (80,100] → `dashboardCheerful` ไม่ใช้ PNG | ตรวจ `painter.pose` ทุกช่วง, ไม่มี `Image`, ขนาด 200 (ui-spec Q-9) |
| D-2 | เวลาเครื่อง ตัดรอบ 05:00 แบบ water/steps/food ไม่มี Server Time | ใช้ `clock` ของ 3 controller (dashboard ไม่มี clock) |
| D-3 | Water, Steps = `round(min(actual/target,1)×100)`; Food ถึงเป้า = `kcal/target×100`, เกินเป้า = `max(0, 100 − ส่วนที่เกิน/target×100)`, ไม่มีเป้า = ไม่คิดคะแนน | ตัวเลขคะแนนรายหมวดทุกเทสต์ |
| D-4 | Priority 4 "คะแนนอาหารต่ำกว่าเกณฑ์" = `foodScore < 50` | ขอบ 49/50, กรณีกินเกินเป้ามาก (BUG-DASH-1) |
| Q-1 | ไม่มีเป้าอาหาร → total = `round((Steps + Water)/2)` แถบอาหาร「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 | `DECIDED_Q1_*` |
| Q-14 | เป้าน้ำ = 8 แก้ว (100% / 12.5% ต่อแก้ว ของ water_rules) | `DECIDED_Q14_*` (7 แก้ว = 88 ตาม ui-spec) |
| Q-3, Q-16, Q-19, Q-20, Q-21, Q-8 | ใช้ตามที่ ui-spec เลือก: P4 ประเมินสด, ปัด foodScore ก่อนเฉลี่ย, เริ่มที่ Priority สูงสุด + นับ 5 วิใหม่เมื่อข้อความเปลี่ยน, ไม่มี cheerTrigger, ไม่รวม `"`, หัวข้อ/tooltip「แดชบอร์ด」 | `DECIDED_Q3_* / Q16 / Q19 / Q20 / Q8` |
| Q-4 / Q-5 / Q-17 | ยึด game-rules + D-3: P2/P3 เมื่อ `< 100`, แถบอาหารเกินเป้าแสดงคะแนนจริง (93%), ตัดออกจากคิวทันที | AC-3/EC-2 |
| Q-7 | water ยังเป็นหน้าแรก เข้า dashboard ผ่าน `dashboard_entry_button` | `DECIDED_Q7_*` + เทสต์เดิมของ signup/water ต้องผ่าน |
| Q-2 / Q-11 / BUBBLY | ไม่มีการลบมื้อ; ไม่แสดงจำนวนจริง/ป้ายโซเดียม-น้ำตาล; BUBBLY ใช้หน้าเดิม | EC-2 ของ P1 ทดสอบผ่านการเปลี่ยนเป้า (ดู §7 ข้อ 5) |

## 1. สรุปตัวเลข

| รายการ | ค่า |
|---|---|
| เทสต์ dashboard ทั้งหมด | **106** (L 45 · C 18 · W 43) |
| ผ่าน / ไม่ผ่าน (dashboard) | **105 / 1** |
| `flutter test` ทั้งแอป (ใน app/) | **708 ผ่าน / 1 ไม่ผ่าน** — `02:37 +708 -1: Some tests failed.` (เทสต์เดิม 603 ผ่านครบ + dashboard 106) |
| `flutter analyze` (ทั้ง app/) | `No issues found! (ran in 5.9s)` |
| AC ทั้งหมด 5 ข้อ | 5 มีเทสต์ · ผ่าน 4 · **AC-3 ไม่ผ่าน 1 เทสต์** (BUG-DASH-1) |
| EC ทั้งหมด 5 ข้อ | 5 มีเทสต์ · ผ่าน 5 |
| AC/EC ที่ยังไม่มีเทสต์ | ไม่มี |
| Bug ที่พบ | **1** (BUG-DASH-1) |
| เทสต์ที่ QA แก้เองเพราะเทสต์ผิด | 1 (ดู §6) |
| คำถามค้าง | 11 (ดู §7) |

ชื่อเทสต์: `AC#_` / `EC#_` = ตามเอกสาร · `GR#_` = ตัวเลขจาก game-rules §# · `EDGE_` = edge case บังคับ 4 แบบ · `DECIDED_` = ตามข้อตัดสิน owner · `UI_` = โครงหน้าจอตาม ui-spec

## 2. AC → เทสต์

| AC | เทสต์ (ไฟล์) | ผล |
|---|---|---|
| AC-1 คะแนนรวม (F+S+W)/3, cap 100, จำนวนเต็ม | GR3_row1_food60_steps90_water60_total70_bubbly (L) · GR3_row2_EC5_food70_steps60_water67_total66_bubbly (L) · GR4_EC1_food100_steps100_water160_cap100_cheerful (L) · EC1_all_categories_over_target_snapshot_total_100 (L) · EC5_total_is_integer_rounded_65_67_to_66_and_65_33_to_65 (L) · DECIDED_Q16_total_from_rounded_category_scores (L) · AC1_GR3_row1_equivalent_60_100_50_shows_70_bubbly (W) · AC1_EC5_total_text_is_integer_no_decimal (W) · UI_realtime_update_when_source_changes (W) | ผ่าน |
| AC-2 อารมณ์ 4 ช่วง | AC2_EDGE_mood_at_0/30/31/60/61/80/81/100 (L, 8) · AC2_EDGE_boundaries_via_snapshot_30_31_60_61_80_81 (L) · DECIDED_Q13_mood_from_rounded_total_30_4_crying_30_5_dazed (L) · DECIDED_D1_pose_mapping_PetCharacter (L) · AC2_EDGE_total_0/30/31/60/61/80/81/100_is_<mood> (W, 8: key `dashboard_pet_image_<mood>` + `painter.pose`) · DECIDED_D1_PetCharacter_size_200_no_png (W) · DECIDED_Q20_no_cheerTrigger_and_state_kept_on_mood_change (W) · AC2_animated_cheerful_runs_with_pump_duration (W) | ผ่าน |
| AC-3 ข้อความวนทุก 5 วิ ตรงตัว + Dynamic Queue | AC3_exact_strings_4_priorities (L) · AC3_empty_day_queue_P2_P3_P4_in_priority_order (L) · GR3_row1_example_queue_P2_P3_only (L) · AC3_EDGE_P1_overeat_threshold_2100_not_2101_yes (L) · DECIDED_Q2_no_target_never_P1 (L) · AC3_EDGE_P2_water_7_cups_in_8_cups_out (L) · AC3_EDGE_P3_steps_99pct_in_100pct_out (L) · DECIDED_D4_EDGE_P4_food_score_49_in_50_out (L) · DECIDED_Q3_P4_no_meal_in_even_with_target (L) · DECIDED_Q3_P4_logged_but_still_below_50_stays (L) · DECIDED_Q3_P4_no_target_only_no_meal_rule (L) · **DECIDED_D4_P4_far_over_target_food_score_below_50_in_queue (L)** · AC3_queue_empty_when_all_resolved (L) · AC3_next_alert_loops_in_priority_order (L) · AC3_starts_at_highest_priority_P2_on_empty_day (C) · AC3_EDGE_rotation_exactly_at_5s_not_4_999s_and_loops (C) · AC3_P1_queue_rotates_P1_P2_P3_back_to_P1 (C) · AC3_single_item_queue_stays_on_same_text (C) · AC3_EDGE_empty_queue_no_alert (C) · DECIDED_Q3_P4_removed_when_meal_logged_reaches_50 (C) · DECIDED_Q19_new_P1_enters_queue_shows_highest_priority (C) · AC3_rotates_every_5s_P2_P3_P4_P2 (W: 4.9 s ยังเดิม / 5.0 s เปลี่ยน) · AC3_P1_exact_text_shown_once_red_food_bar_93 (W) · AC3_EDGE_P1_2100_not_red_2101_red (W) · AC3_EDGE_empty_queue_hides_banner_keeps_slot (W) | **ไม่ผ่าน 1** (BUG-DASH-1) · อื่นผ่าน |
| AC-4 UI ครบ 3 ส่วน | AC4_total_card_pet_and_three_bars_present (W) · UI_layout_order_card_alert_pet_food_steps_water (W) · UI_bar_labels_format_and_bar_value_equals_score (W) · UI_card_and_bubble_colors_from_color_scheme (W) · UI_loading_shows_only_progress_indicator (W) · DECIDED_Q8_header_title (W) | ผ่าน |
| AC-5 ตัดรอบ 05:00 (D-2 เวลาเครื่อง) | AC5_EC3_EDGE_04_59_59_keeps_day_05_00_00_resets_all (C) · AC5_open_after_05_00_with_yesterday_data_shows_new_day (C) · AC5_EC3_EDGE_open_04_59_59_then_05_00_00_resets_screen (W) · AC5_resume_after_05_00_resets (W) | ผ่าน |

## 3. Edge case (EC ในเอกสาร + 4 แบบบังคับ)

| กรณี | เทสต์ | ผล |
|---|---|---|
| EC-1 เฉลี่ยเกิน 100 → 100% | GR4_EC1_food100_steps100_water160_cap100_cheerful (L) · EC1_all_categories_over_target_snapshot_total_100 (L) · EC1_GR4_over_target_everywhere_capped_100_cheerful (W: 13 แก้ว / 20,000 ก้าว / 2,000 kcal → `คะแนนสุขภาพรวม: 100%`, แถบ ≤ 1.0, cheerful) | ผ่าน |
| EC-2 แก้ปัญหาขณะแสดง → ตัดออกทันที ไม่รอ 5 วิ | EC2_GR4_P1_removed_while_showing_next_is_P2 (L) · EC2_last_item_removed_wraps_to_head (L) · EC2_only_item_removed_queue_empty_null (L) · EC2_P2_resolved_by_logging_water_switches_to_P3_immediately (C) · DECIDED_Q19_after_removal_next_rotation_counts_5s_anew (C) · EC2_P3_resolved_by_steps_switches_to_P4_immediately (C) · EC2_GR4_P1_removed_while_showing_switches_to_P2_immediately (C) · EC2_last_problem_resolved_queue_empty_alert_hidden (C) · EC2_resolve_shown_P2_switches_without_waiting (W) | ผ่าน |
| EC-3 ข้าม 05:00 ขณะเปิดค้าง | AC5_EC3_EDGE_04_59_59_keeps_day_05_00_00_resets_all (C) · EC3_rollover_clears_P1_and_red_bar (C) · AC5_EC3_EDGE_open_04_59_59_then_05_00_00_resets_screen (W: 100% cheerful → pump 1 s ที่ 04:59:59 ยัง 100% → 05:00:00 pump 1 s → ทุกแถบ 0%, total 0%, crying, 「ดื่มน้ำๆ」, ไม่มี SnackBar/AlertDialog) | ผ่าน |
| EC-4 ติดลบ / Null → 0 | GR3_row3_EC4_food_minus10_steps90_water90_food0_total60_dazed (L) · EC4_null_and_negative_category_become_0 (L) · EC4_GR3_row3_negative_food_shows_0_total_60_dazed (W) · EC4_EDGE_corrupt_storage_all_three_fallback_zero (C) · EC4_EDGE_corrupt_storage_no_crash_all_0 (W) | ผ่าน |
| EC-5 ทศนิยม → จำนวนเต็ม (65.66 → 66) | GR3_row2_EC5_food70_steps60_water67_total66_bubbly (L) · EC5_total_is_integer_rounded_65_67_to_66_and_65_33_to_65 (L) · EC5_GR3_row2_equivalent_65_67_shows_66_bubbly (W) · AC1_EC5_total_text_is_integer_no_decimal (W) | ผ่าน |
| 1. ค่าเกณฑ์พอดี ±1 | อารมณ์ 30/31, 60/61, 80/81 (L, W) · Priority 1 2,100 / 2,101 kcal (L, W) · P2 7/8 แก้ว (L) · P3 99%/100% (L) · P4 foodScore 49/50 (L) · หมุนข้อความ 4.999 / 5.000 s (C), 4.9 / 5.0 s (W) · 04:59:59 / 05:00:00 (C, W) | ผ่าน |
| 2. ข้ามวัน / รีเซ็ต | AC5_* / EC3_* ข้างบน · resume หลัง 05:00 (W) · เปิดหลัง 05:00 ด้วยข้อมูลเมื่อวาน (C) | ผ่าน |
| 3. เพดาน max / min | EDGE_category_min_max_0_and_100_never_outside (L) · DECIDED_Q14_water_target_8_cups_score_per_cup (9 แก้ว = 100) · DECIDED_D3_steps_ratio_round_and_cap (16,000 = 100) · EDGE_D3_food_far_over_target_floor_0_not_negative (4,001 / 9,000 kcal = 0) · EC1_* (W: แถบ ≤ 1.0) | ผ่าน |
| 4. ข้อมูลว่าง / เปิดครั้งแรก / ข้อมูลเสีย | EDGE_empty_first_open_all_zero_crying (L) · EDGE_first_open_no_data_all_zero_P2_first (C) · EC4_EDGE_corrupt_storage_all_three_fallback_zero (C: repository ทั้ง 3 throw) · EDGE_EC4_first_open_empty_all_0_crying_P2 (W) · EC4_EDGE_corrupt_storage_no_crash_all_0 (W) · UI_loading_shows_only_progress_indicator (W) | ผ่าน |

## 4. ตัวเลขใน game-rules / หน้าจอ / ข้อตัดสิน

| หัวข้อ | เทสต์ | ผล |
|---|---|---|
| game-rules §3 แถว 1 (60, 90, 60 → 70 BUBBLY) | GR3_row1_* (L ค่าตรงตามตาราง) · AC1_GR3_row1_equivalent_60_100_50_shows_70_bubbly (W — น้ำ 60% ทำไม่ได้ด้วยเป้า 8 แก้ว จึงใช้ชุดผลรวม 210 เท่ากัน) | ผ่าน |
| game-rules §3 แถว 2 (70, 60, 67 → 66 BUBBLY) | GR3_row2_* (L) · EC5_GR3_row2_equivalent_65_67_shows_66_bubbly (W — 71 + 76 + 50 = 197 → 65.67 → 66) | ผ่าน |
| game-rules §3 แถว 3 (−10, 90, 90 → Food 0, 60 DAZED) | GR3_row3_* (L) · EC4_GR3_row3_negative_food_shows_0_total_60_dazed (W — −10 kcal → `คะแนนอาหาร: 0%`, 0 + 80 + 100 = 180 → 60) | ผ่าน |
| game-rules §4 แถว 1 (100, 100, 160 → 120 → 100 CHEERFUL) | GR4_EC1_* (L) · EC1_GR4_* (W) | ผ่าน |
| game-rules §4 แถว 2 (P1 หลุดขณะแสดง → P2 ทันที) | EC2_GR4_P1_removed_while_showing_next_is_P2 (L) · EC2_GR4_P1_removed_while_showing_switches_to_P2_immediately (C) | ผ่าน |
| game-rules §4 แถว 3 (ข้าม 05:00 → ทุกคะแนนเป็นค่าวันใหม่) | AC5_EC3_* (C, W) | ผ่าน |
| alertInterval = 5 วินาที | AC3_EDGE_rotation_exactly_at_5s_not_4_999s_and_loops (C) · AC3_rotates_every_5s_P2_P3_P4_P2 (W) | ผ่าน |
| ข้อความ alert 4 ข้อตรงตัว (ไม่รวม `"` — Q-21) | AC3_exact_strings_4_priorities (L) · AC3_P1_exact_text_shown_once_red_food_bar_93 (W: `find.text(P1)` เจอ 1, ไม่มี maxLines/ellipsis, ไม่ใช่ SnackBar) · AC3_rotates_every_5s_* (W) | ผ่าน |
| D-3 สูตรรายหมวด | DECIDED_Q14_water_target_8_cups_score_per_cup · DECIDED_D3_steps_ratio_round_and_cap · DECIDED_D3_food_up_to_target_kcal_over_target_x100 · DECIDED_D3_food_over_target_100_minus_over_percent (2,100 = 95, 2,150 = 93, 3,000 = 50, 4,000 = 0) (L) | ผ่าน |
| Q-1 ไม่มีเป้าอาหาร | DECIDED_D3_Q1_food_no_target_not_scored_total_avg_of_2 · DECIDED_Q1_no_target_can_reach_100_cheerful (L) · DECIDED_Q1_no_target_label_color_bar0_total_avg2 (W: ป้าย, สี `onSurfaceVariant`, แถบ 0 สี primary, total 75, ไม่มี P1) | ผ่าน |
| ui-spec ช่องข้อความ: ห่างกล่องสัตว์เลี้ยง 12 px, สูงคงที่เมื่อหมุน/คิวว่าง, สัตว์เลี้ยงไม่ขยับ | UI_alert_slot_bottom_12px_above_pet_box · UI_slot_height_constant_and_pet_still_while_rotating · AC3_EDGE_empty_queue_hides_banner_keeps_slot (W) | ผ่าน |
| ทางเข้าจาก water (Q-7, ui-spec §2.0) | DECIDED_Q7_entry_button_icon_tooltip_position (ไอคอน `Icons.dashboard`, tooltip「แดชบอร์ด」, อยู่หลัง food ก่อนรายงาน, water ยังเป็นหน้าแรก) · DECIDED_Q7_tap_opens_S1_with_same_controllers_and_back (W) | ผ่าน |
| จอ 360×640 textScaler 1.0 | UI_360_scale_1_0_via_water_P1_full_no_overflow (เข้าทางปุ่มบน water, P1 ไม่ถูกตัด, ไม่มี exception) · UI_360_scale_1_0_water_appbar_three_icons_no_overflow · DECIDED_Q1_360_scale_1.0_no_target_label_no_overflow (W) | ผ่าน |
| จอ 360×640 textScaler 1.5 | UI_360_scale_1_5_P1_full_no_overflow (P1 ไม่ถูกตัด, อยู่ในฟองและช่อง, ช่องห่าง 12 px, หมุนแล้วช่องไม่เปลี่ยน) · DECIDED_Q1_360_scale_1.5_no_target_label_no_overflow · UI_360_scale_1_5_can_scroll_to_water_bar (W) — เปิด S-1 ตรง ไม่ผ่านหน้า water เพราะหน้า water overflow เองที่ 1.5 (§8) | ผ่าน |
| Timer ถูก cancel | UI_dispose_cancels_alert_timer (C) · ทุก W ไม่มี "Timer still pending" | ผ่าน |
| เทสต์เดิม (signup S-7, water, steps, food) ไม่กระทบ | `flutter test` ทั้งแอป: 603 เทสต์เดิมผ่านครบ | ผ่าน |

## 5. รายการ Bug

### BUG-DASH-1 — 「ฉันหิว」(Priority 4) ไม่เข้าคิวเมื่อกินเกินเป้ามากจน foodScore < 50

- **ความรุนแรง:** ต่ำ (มีผลเฉพาะกินเกินเป้า > 50% เช่น > 3,000 kcal ที่เป้า 2,000) · **เทสต์:** `DECIDED_D4_P4_far_over_target_food_score_below_50_in_queue` (dashboard_logic_test.dart)
- **ขั้นตอนทำซ้ำ:** เป้า 2,000 kcal (ชาย 25 ปี BMI ปกติ) · บันทึกอาหาร 3,500 kcal (1 มื้อ) · น้ำ 0 แก้ว · ก้าว 0 → ดูคิวข้อความ (`DashboardLogic.snapshot(...).alerts`)
- **ผลที่คาด (อ้างเอกสาร):** foodScore = max(0, 100 − 1,500/2,000×100) = 25 (D-3) → 25 < 50 ⇒ trigger P4 ตาม game-rules §1.1 Priority 4 「ยังไม่ได้บันทึกอาหารมื้อใดๆ **หรือ**คะแนนอาหารต่ำกว่าเกณฑ์」 + D-4 (`foodScore < 50`) + ui-spec Q-3 (owner ใช้ตาม ui-spec: 「อยู่ในคิวเมื่อ … **หรือ** (มี foodScore และ `< 50`)」) → คิว = [P1, P2, P3, P4]
- **ผลจริง:**
  ```
  Expected: [P1 'แต่วันนี้ฉันอิ่ม…', 'ดื่มน้ำๆ', 'ขยับร่างกายหน่อย อีกนิดๆ', 'ฉันหิว']
    Actual: [P1 'แต่วันนี้ฉันอิ่ม…', 'ดื่มน้ำๆ', 'ขยับร่างกายหน่อย อีกนิดๆ']
     Which: at location [3] … shorter than expected
  ```
  สาเหตุ: `DashboardLogic.isHungry` คืน `false` เมื่อ `isFoodOverTarget` (Dev ASSUMPTION A-7 "นับ foodScore < 50 เฉพาะตอน kcal ≤ target") — เป็นเงื่อนไขที่ไม่มีในเอกสาร/ข้อตัดสิน
- **หมายเหตุ:** Dev ยกเป็นคำถาม QD-2 ไว้แล้ว (ข้อความ「ฉันหิว」ขัดความหมายกับ P1「อิ่มและอืดเกินไป」) — ถ้า owner ยืนยัน A-7 ให้แก้ game-rules §1.1 / D-4 ก่อน แล้ว QA จะปรับเทสต์ตามเอกสารใหม่ (ดู §7 ข้อ 4) · ยังไม่แก้ตามโค้ด

## 6. เทสต์ที่ QA แก้เอง (เทสต์ผิด)

| เทสต์ | ปัญหา | แก้อย่างไร |
|---|---|---|
| UI_card_and_bubble_colors_from_color_scheme | รอบแรก `_TypeError` — เทสต์สมมติว่า key `dashboard_alert_banner` อยู่บน `Container` เอง แต่ ui-spec กำหนด "(บน `Container`)" เฉพาะการ์ดคะแนน (`dashboard_total_score_card`) ไม่ได้บังคับชนิด widget ของฟองข้อความ | หา `Container` ที่เป็นลูกของ `dashboard_alert_banner` แล้วตรวจสี `secondaryContainer` (ค่าคาดหวังเดิม) |

## 7. คำถามค้าง (ไม่นับเป็น bug — ไม่ได้ assert จุดที่เอกสารไม่ระบุ)

1. **เอกสารยังไม่ตรงข้อตัดสิน** — requirements AC-5/US-5/§6, ux-flow §2–§6, game-rules §1/§2/§4/§5 ยังอ้าง Server Time / ICT / Session Database / PNG 300×300 (D-1, D-2, Q-9, Q-12, Q-15) — ต้องให้ Design/Product อัปเดตหลังทีมยืนยัน
2. **คะแนนปัดถึง 100 ทั้งที่ยังไม่ถึงเป้า** — D-3 ปัดก่อนเทียบ: 7,960–7,999 ก้าว (เป้า 8,000) = stepsScore 100 → 「ขยับร่างกายหน่อย อีกนิดๆ」หลุดคิว แม้ removal ใน game-rules §1.1 เขียนว่า "เดินครบตามเป้าหมาย" (อาหาร 1,990–1,999 kcal = 100 ก็เช่นกัน) — เทสต์ใช้เฉพาะ 7,920 (99) / 8,000 (100) ไม่ assert ช่วงนี้
3. **การปัด .5** (half-up หรือ banker's) เอกสารไม่ระบุ — ค่า .5 ที่ assert มีเฉพาะที่ ui-spec ระบุเลขไว้เอง (7 แก้ว = 88 ใน Q-14, 2,150 kcal = 93 ใน §3) · ไม่ assert ค่ารวมที่ลงท้าย .5 กรณี Q-1 (หาร 2)
4. **QD-2 / BUG-DASH-1** — กินเกินเป้ามากจน foodScore < 50 ควรขึ้น「ฉันหิว」คู่กับ P1 หรือไม่ (เอกสาร/D-4 ตามตัวอักษร = ขึ้น, Dev A-7 = ไม่ขึ้น) — owner ตัดสิน
5. **EC-2 สำหรับ Priority 1** — Q-2 ไม่มีทาง "จัดการปัญหาอาหาร" ในแอป (P1 ค้างจนตัดรอบ) เทสต์ C จำลองการหลุดคิวด้วยเป้าที่เปลี่ยนจากโปรไฟล์ (2,000 → 2,400) เพื่อพิสูจน์กลไก "ข้ามไป P2 ทันที" — ถ้าการเปลี่ยนเป้าไม่ควรนับว่า "แก้ปัญหา" ต้องกำหนดเพิ่ม
6. **"ทันที" ของ EC-3** — S-1 ตรวจรอบวันทุก 1 วินาที (Dev A-9) เอกสารไม่กำหนดความหน่วงที่ยอมรับได้ — เทสต์ยอมรับการรีเซ็ตภายใน 1 วินาทีหลัง 05:00:00
7. **ข้อความที่ไม่ได้แสดงหลุดคิว / ข้อความใหม่เข้าคิว** — Q-19 ตอบแค่ "เริ่มจาก Priority สูงสุด" เทสต์ assert เฉพาะ P1 เข้าคิวแล้วขึ้นทันที (DECIDED_Q19) ไม่ assert กรณีข้อความอื่นที่ไม่ได้แสดงหลุดคิว (Dev A-8 คงข้อความเดิม)
8. **QD-1 เป้าน้ำ 8 แก้ว** — สัตว์เลี้ยงหน้า water ร่าเริงที่ 7 แก้ว แต่ dashboard ยังแสดง 88% และ「ดื่มน้ำๆ」
9. **QD-3 ปุ่ม「รายงานรายเดือน」บน AppBar ของ water** — Dev ห่อ Flexible + ellipsis เพื่อไม่ให้ AppBar ล้นที่ 360 dp (ui-spec §2.0 ประเมินว่าไม่ล้น) — เทสต์ยืนยันแค่ "ไม่มี overflow" ไม่ได้ตรวจว่าป้ายถูกตัดหรือไม่ — UI ต้องยอมรับ
10. **QD-4 ช่องข้อความ** — Dev ใช้ min-height ที่วัดจากข้อความ P1 แทน `Visibility(maintainSize)` — เทสต์ตรวจผลบนจอตาม ui-spec (12 px, ความสูงคงที่, P1 ไม่ถูกตัด, `find.text(P1)` เจอ 1) ผ่านทั้งหมด — UI ต้องยอมรับวิธี
11. **ไม่มีเป้าอาหาร + ยังไม่ผ่าน S-3** — ux-flow ไม่บอกว่า S-1 ของ dashboard ควรพาไปตั้งโปรไฟล์หรือไม่ (ui-spec: ไม่มี CTA) — ไม่ได้ assert

## 8. ข้อสังเกต: หน้า water ที่ 360×640 textScaler 1.5 (ไม่นับเป็นบั๊ก dashboard)

- **ผลบนโค้ดปัจจุบัน:** `A RenderFlex overflowed by 68 pixels on the bottom` ที่ `Column` ของ body (`water_home_screen.dart:256` — `_buildContent` → `SafeArea` → `Padding(24)` → `Column` ไม่มี scroll) · AppBar ไม่ล้น · ที่ textScaler 1.0 ไม่มี error
- **มีมาก่อนงาน dashboard:** `git diff HEAD -- app/lib/features/water/` แก้แค่ import, `_openSteps`/`_openFood` → `_stepsController()`/`_foodController()`, `_openDashboard` และ `AppBar.actions` (hunk สุดท้ายจบที่บรรทัด 189 ของ HEAD ก่อน `body:` ที่บรรทัด 193) — ไม่แตะ body · รันเทสต์ probe เดียวกันบนสำเนา HEAD (`git archive HEAD app` แตกลง scratchpad ไม่แตะ working tree) ได้ **2 error**: `RenderFlex overflowed by 79 pixels on the right` ที่ AppBar (`:164`) + `overflowed by 68 pixels on the bottom` ที่ body (`:213`) → body overflow 68 px เท่าเดิม = ของเดิม · AppBar overflow ที่ 1.5 ถูก Dev แก้ไปแล้วด้วย Flexible (ผลข้างเคียงดี)
- **ผลต่อเทสต์:** เทสต์ 360×640 ที่ 1.5 เปิด S-1 ตรง (ไม่ผ่านหน้า water) · ที่ 1.0 เปิดผ่านปุ่มบนหน้า water
- **แนะนำ:** เปิด issue แยกของ water (ห่อ body ด้วย scroll แบบ steps/food)

## 9. ผลการรัน (ใน app/)

| คำสั่ง | ผล |
|---|---|
| `flutter analyze` | `No issues found! (ran in 5.9s)` |
| `flutter test test/dashboard/dashboard_logic_test.dart` | `00:00 +44 -1: Some tests failed.` (BUG-DASH-1) |
| `flutter test test/dashboard/dashboard_controller_test.dart` | `00:00 +18: All tests passed!` |
| `flutter test test/dashboard/dashboard_screens_test.dart` | `00:13 +43: All tests passed!` |
| `flutter test` (ทั้งแอป) | `02:37 +708 -1: Some tests failed.` — ไม่ผ่านตัวเดียวคือ DECIDED_D4_P4_far_over_target_food_score_below_50_in_queue |

---

# รอบที่ 3 (2026-10-31)

> ผู้ทดสอบ: QA agent · 09:22–09:31 · โค้ดที่ทดสอบ: dev r3 (`logs/20261031-0921_dev_dashboard_r3.md`) ได้แก่ floor ทุกสูตรใน `dashboard_rules.dart`, `FoodProfileCtaBanner` บน S-1, ปุ่มรายงานของ water เป็น `IconButton`
> ไม่ได้แก้ `app/lib/` · ไม่ได้แก้ไฟล์อื่นใน `docs/dashboard/` · ไม่ได้ commit / push

## 10. ข้อตัดสิน owner รอบ 3 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน)

ข้อตัดสินรอบนี้ชนะเอกสารและข้อตัดสินรอบก่อน เทสต์ที่อิงข้อตัดสินนี้จะมี `DECIDED_R3` ในชื่อ

| ข้อ | เนื้อหา | ชนะ / แทนที่ |
|---|---|---|
| 1 | BUG-DASH-1 / QD-2: ยึด A-7 คือกินเกินเป้าไม่ต้องขึ้น「ฉันหิว」 (P4 ใช้ foodScore < 50 เฉพาะตอน kcal ≤ target) | D-4 ตามตัวอักษร, ui-spec Q-3 |
| QD-1 | เป้าน้ำ 8 แก้วจากค่าคงที่ของ water ใช้ต่อ | (ยืนยัน Q-14) |
| 2 | ปัดลง (floor) ทุกคะแนน (Water, Steps, Food, total) ได้ 100 ก็ต่อเมื่อถึงเป้าจริงเท่านั้น · Food เกินเป้า = 100 − ceil(over×100/target) | game-rules §3 แถว 2 / EC-5 (65.66 → **65** BUBBLY), round ของ D-3 / Q-1, Q-16, Q-13 (30.67 → 30 = CRYING) |
| 3, 4, 8 | A-8 (เลือกข้อความเมื่อคิวเปลี่ยน), ตรวจรอบวันทุก 1 วินาที, min-height แทน Visibility: ใช้ตามที่ dev ทำ | คำถามรอบ 1 ข้อ 6, 7, 10 |
| 5 | ไม่มีเป้าอาหาร → S-1 แสดง CTA เดิมของ food (`food_profile_cta_banner`) ใต้แถบอาหาร กดแล้วเปิด S-3 ของ food | คำถามรอบ 1 ข้อ 11, ui-spec §3 "ไม่มี CTA" |
| 7 | `water_monthly_report_button` เป็นปุ่มไอคอน + tooltip「รายงานรายเดือน」 ไม่มีข้อความบนปุ่ม | water ux-flow (ป้ายบนปุ่ม), คำถามรอบ 1 ข้อ 9 |

ค่าคาดหวังที่คำนวณเองจากข้อ 2 (ไม่ได้ลอกจากโค้ด): 7 แก้ว = floor(87.5) = 87 · 3 แก้ว = 37 · 7,999/8,000 ก้าว = 99 · 1,999/2,000 kcal = 99 · 2,001 kcal = 100 − ceil(0.05) = 99 · 2,101 = 100 − ceil(5.05) = 94 · 2,150 = 100 − ceil(7.5) = 92 · 3,500 = 25 · (70+60+67)/3 = 65.67 → 65 · (92+90+75)/3 = 85.67 → 85

## 11. สรุปตัวเลขรอบ 3

| รายการ | ค่า |
|---|---|
| เทสต์ dashboard ทั้งหมด | **116** (L 47 · C 18 · W 51) = รอบ 1 106 ตัว + ใหม่ 10 ตัว |
| ผ่าน / ไม่ผ่าน (dashboard) | **116 / 0** |
| `flutter test` ทั้งแอป | **719 ผ่าน / 0 ไม่ผ่าน** (`02:53 +719: All tests passed!`) |
| `flutter analyze` | `No issues found! (ran in 5.2s)` |
| AC 5/5 · EC 5/5 มีเทสต์และผ่าน · AC/EC ที่ยังไม่มีเทสต์ | ไม่มี |
| Bug ใหม่ | **0** · BUG-DASH-1 ปิดแล้ว (owner เปลี่ยนพฤติกรรมที่ถือว่าถูกตามข้อ 1 ไม่ได้ปิดเพราะ dev แก้โค้ด) |
| เทสต์ที่ปรับเพราะข้อตัดสินรอบ 3 | 12 ตัว (§12) ตรงกับรายชื่อ 12 ตัวใน dev log r3 ทุกตัว |
| เทสต์ที่ QA แก้เองเพราะเทสต์ผิด (รอบนี้) | 0 |
| เทสต์ใหม่ | 10 ตัว (§13) |

## 12. เทสต์ที่ปรับ (ค่าคาดหวังเปลี่ยนเพราะข้อตัดสินรอบ 3)

| # | เทสต์เดิม → ชื่อใหม่ | เดิม → ใหม่ | เพราะข้อ |
|---|---|---|---|
| 1 | GR3_row2_EC5_food70_steps60_water67_total66_bubbly → `DECIDED_R3_GR3_row2_EC5_food70_steps60_water67_total65_bubbly` (L) | 66 → 65 (ยัง BUBBLY) | 2 |
| 2 | EC5_total_is_integer_rounded_65_67_to_66_and_65_33_to_65 → `DECIDED_R3_EC5_total_is_integer_floor_65_67_and_65_33_to_65` (L) | 197/3: 66 → 65 | 2 |
| 3 | `DECIDED_Q14_water_target_8_cups_score_per_cup` (L, ชื่อเดิม) | 7 แก้ว 88 → 87 | 2 (เป้า 8 แก้วคงเดิมตาม QD-1) |
| 4 | `DECIDED_D3_food_up_to_target_kcal_over_target_x100` (L, ชื่อเดิม) | 1,999 kcal 100 → 99 | 2 |
| 5 | `DECIDED_D3_food_over_target_100_minus_over_percent` (L, ชื่อเดิม) | 2,150 kcal 93 → 92 | 2 |
| 6 | DECIDED_Q16_total_from_rounded_category_scores → `DECIDED_R3_total_floor_of_floored_category_scores` (L) | 86 → 85 (food 92) | 2 (แทน Q-16) |
| 7 | DECIDED_Q13_mood_from_rounded_total_30_4_crying_30_5_dazed → `DECIDED_R3_mood_from_floored_total_30_67_is_crying` (L) | Food 92 (30.67): DAZED → total 30 CRYING (เพิ่มเช็ก Food 93 = 31 DAZED) | 2 (แทน Q-13) |
| 8 | DECIDED_D4_P4_far_over_target_food_score_below_50_in_queue → `DECIDED_R3_A7_P4_far_over_target_food_score_below_50_not_in_queue` (L) | [P1,P2,P3,P4] → [P1,P2,P3] | 1 |
| 9 | EC5_GR3_row2_equivalent_65_67_shows_66_bubbly → `DECIDED_R3_EC5_GR3_row2_equivalent_65_67_shows_65_bubbly` (W) | `คะแนนสุขภาพรวม: 66%` → `65%` | 2 |
| 10 | `UI_realtime_update_when_source_changes` (W, ชื่อเดิม) | 3 แก้ว 38% → 37% | 2 |
| 11 | AC3_P1_exact_text_shown_once_red_food_bar_93 → `AC3_P1_exact_text_shown_once_red_food_bar_DECIDED_R3_92` (W) | `คะแนนอาหาร: 93%` / 0.93 → `92%` / 0.92 | 2 |
| 12 | `UI_S1_button_label_and_plus_icon_per_ux_flow` (`app/test/water/water_screens_test.dart`, ชื่อเดิม) | เดิมหา `Text('รายงานรายเดือน')` บนปุ่ม → ตรวจ tooltip ของ `IconButton` =「รายงานรายเดือน」และไม่มีข้อความบนปุ่ม | 7 (spec เปลี่ยนตามข้อตัดสิน ไม่ใช่ปรับตามโค้ด) |

ไม่มีเทสต์อื่นที่ค่าคาดหวังเปลี่ยน: ขอบอารมณ์ 30/31/60/61/80/81, ตัวอย่าง §3 แถว 1 และ 3, §4, P1 2,100/2,101, P4 49/50 ใช้ค่าที่หารลงตัวอยู่แล้ว จึงได้ผลเท่ากันทั้ง round และ floor

## 13. เทสต์ใหม่รอบ 3

| เทสต์ | ไฟล์ | ตรวจอะไร | ข้อ |
|---|---|---|---|
| DECIDED_R3_EDGE_100_only_when_target_reached | L | 7 แก้ว 87 / 8 แก้ว 100 · 7,999 ก้าว 99 / 8,000 ก้าว 100 · 1,999 kcal 99 / 2,000 kcal 100 / 2,001 kcal 99 / 2,101 kcal 94 · ที่ 7,999 ก้าวยังมี「ขยับร่างกายหน่อย อีกนิดๆ」 · (100+99+100)/3 = 99 | 2 |
| DECIDED_R3_Q1_no_target_total_floor_of_half | L | ไม่มีเป้า: (100 + 87)/2 = 93.5 → 93 | 2 + Q-1 |
| DECIDED_R3_Q5_no_target_shows_food_cta_under_food_bar | W | มี `food_profile_cta_banner` พร้อมข้อความ food「ตั้งค่าโปรไฟล์สุขภาพเพื่อรับเป้าหมายแคลอรี่ที่แม่นยำ」 อยู่ใต้ `dashboard_food_bar` และเหนือแถวก้าว | 5 |
| DECIDED_R3_Q5_with_target_no_cta | W | มีเป้า → ไม่มี CTA | 5 |
| DECIDED_R3_Q5_tap_cta_opens_food_profile_screen | W | กด CTA แล้วเปิด `FoodProfileScreen` (มี `food_profile_save_button`) | 5 |
| DECIDED_R3_Q5_360_scale_1.0_cta_no_overflow / _1.5_ | W (2) | 360×640 ไม่มี exception · CTA อยู่ในความกว้างจอ · ยอดรวม `food_cta_total_text` ไม่ถูกตัดและอยู่ในกรอบ CTA | 5 |
| DECIDED_R3_Q7_report_button_icon_only_tooltip | W | `water_monthly_report_button` เป็น `IconButton`, tooltip「รายงานรายเดือน」, ไม่มีข้อความบนปุ่ม | 7 |
| DECIDED_R3_Q7_water_appbar_360_scale_1.0_no_overflow / _1.5_ | W (2) | หน้า water 360×640 ไม่มี error ที่มาจาก AppBar / NavigationToolbar · ปุ่มทั้ง 4 (steps, food, dashboard, รายงาน) อยู่ในจอช่วง 0–360 · ที่ 1.5 เทสต์เก็บ error เองและกรองเฉพาะ error ของ AppBar เพราะ body ของ water ล้นแนวตั้ง 68 px ซึ่งเป็นปัญหาเดิม (§8) | 7 |

เทสต์ food เดิมทั้งหมดยังผ่านหลัง dev ย้าย CTA ไปเป็น `FoodProfileCtaBanner` (นับรวมอยู่ใน 719 ตัว)

## 14. คำถามค้าง (รอบ 3)

1. **เอกสารยังไม่ตรงข้อตัดสิน**: game-rules §3 แถว 2 / requirements EC-5 ยังเขียน 65.66 → 66 (ข้อ 2 ให้ 65, dev QD-8), game-rules §1.1 P4 ยังไม่มีข้อยกเว้นกรณีกินเกินเป้า (ข้อ 1), ui-spec §3 ยังเขียนว่าไม่มี CTA (ข้อ 5), ui-spec Q-14 ยังเขียน 88 และ §3 ยังเขียน 93% · ข้อ 1 ของรอบ 1 (Server Time / PNG) ก็ยังค้าง ต้องให้ Design / Product / UI อัปเดต
2. **QD-6 ตำแหน่ง CTA**: ตอนนี้อยู่ใต้แถบอาหาร และยังคงป้าย「คะแนนอาหาร: ยังไม่มีเป้าหมาย」+ แถบ 0 ไว้ · เทสต์ assert แค่ "ใต้แถบอาหาร ก่อนแถวก้าว" ตามข้อตัดสิน ไม่ได้ assert ระยะ 8
3. **QD-7 key ของ CTA**: ใช้ key ของ food (`food_profile_cta_banner`) ตามข้อตัดสิน "CTA เดิมของ food" · ถ้าเปลี่ยนเป็น key `dashboard_` ต้องแก้เทสต์ตาม
4. **ข้อความชวนใน CTA** (`food_cta_text`) มี `maxLines: 2` + ellipsis ตาม food ui-spec #9b · เทสต์ที่ 360 ตรวจว่ายอดรวมไม่ถูกตัด แต่ไม่ได้ assert ว่าข้อความชวนไม่ถูกตัด (food spec อนุญาตให้ตัด)
5. **EC-2 ของ P1** (คำถามรอบ 1 ข้อ 5) ยังค้าง: ทดสอบด้วยการเปลี่ยนเป้าจากโปรไฟล์ · กรณีมีเป้าแล้วกินเกินยังไม่มีทางให้ผู้ใช้ "จัดการ" ได้
6. ข้อสังเกตหน้า water (body ล้น 68 px ที่ textScaler 1.5) ยังอยู่ ควรเปิด issue แยกของ water

## 15. ผลการรันรอบ 3 (ใน app/)

| คำสั่ง | ผล |
|---|---|
| `flutter analyze` | `No issues found! (ran in 5.2s)` |
| `flutter test test/dashboard/ test/water/water_screens_test.dart` | `00:18 +133: All tests passed!` |
| `flutter test` (ทั้งแอป) | `02:53 +719: All tests passed!` (exit 0) |
| `flutter test test/dashboard/dashboard_logic_test.dart` | `00:15 +47: All tests passed!` |
| `flutter test test/dashboard/dashboard_controller_test.dart` | `00:07 +18: All tests passed!` |
| `flutter test test/dashboard/dashboard_screens_test.dart` | `00:13 +51: All tests passed!` |

=== จบ docs/dashboard/test-report.md ===

=== logs/20261031-0824_dev_dashboard.md ===
# Log: dev · dashboard · 2026-10-31 08:24

| รายการ | ค่า |
|---|---|
| สถานะ | เสร็จ (รอ QA เขียน app/test/dashboard/) |
| agent | Flutter Developer |
| branch | feat/dashboard-dev (ไม่ commit / ไม่ push ตามคำสั่ง) |
| เอกสารที่อ่าน | docs/dashboard/requirements.md, ux-flow.md, game-rules.md, ui-spec.md (ครบ 4 ไฟล์) · ไม่มี review.md · บริบท: logs/20261031-0707_art_dashboard.md, logs/20261031-0745_ui_dashboard.md |

## ข้อตัดสินของ owner — DECIDED (owner ชั่วคราว, รอทีมยืนยัน)

รอบ 1
- D-1 สัตว์เลี้ยงใช้ `PetCharacter` ไม่ใช้ PNG
- D-2 เวลาเครื่อง ตัดรอบ 05:00 แบบเดียวกับ water / steps / food — ไม่มี Server Time / Session Database
- D-3 คะแนน: Water, Steps = `round(min(actual/target,1)×100)`; Food: ถึงเป้า = `(kcal/target)×100`, เกินเป้า = `max(0, 100 − (ส่วนที่เกิน/target×100))`, ไม่มีเป้า = ไม่คิดคะแนน
- D-4 Priority 4 "คะแนนอาหารต่ำกว่าเกณฑ์" = `foodScore < 50`

รอบ 2
- Q-1 Food ไม่มีเป้า → total = `round((Steps + Water) / 2)`
- Q-14 เป้าน้ำ derive จากค่าคงที่ของ water (`energyMaxDisplayPercentage / energyIncrementPercentage` = 8 แก้ว) — จดเป็นคำถามถึง Design (B)
- Q-3, Q-16, Q-19, Q-20, Q-21, Q-8: ใช้ตามที่ ui-spec เลือก
- Q-4 / Q-5 / Q-17: brief ขัดกับ game-rules → ยึด game-rules และ D-3
- Q-7: water ยังเป็นหน้าแรก เข้า dashboard ผ่านปุ่ม
- Q-2: ลบมื้ออาหารไม่อยู่ในขอบเขตรอบนี้ (P1 ค้างจนตัดรอบ 05:00)
- Q-11: ยึด ux-flow ไม่แสดงจำนวนจริง / ป้ายโซเดียม-น้ำตาล
- BUBBLY: ใช้หน้าเดิม (`dashboardBubbly == waterHappy`)
- Q อื่นใน ui-spec §6: ใช้ค่าชั่วคราวที่ ui-spec เลือก (Q-6, Q-9 = 200, Q-10, Q-12, Q-13, Q-15, Q-18)

## AC / EC → ไฟล์

| ID | ทำที่ |
|---|---|
| AC-1 / EC-1 / EC-5 คะแนนรวม (avg, cap 100, integer) | `DashboardRules.totalScore`, `clampScore` (dashboard_rules.dart) · การ์ด `dashboard_total_score_card/_text` (screens/dashboard_screen.dart) |
| AC-2 อารมณ์ 4 ช่วง | `DashboardRules.cryingMaxScore/dazedMaxScore/bubblyMaxScore` · `DashboardLogic.moodFor`, `poseFor` · `KeyedSubtree('dashboard_pet_image_<mood>')` + `PetCharacter(GlobalKey, size 200, ไม่มี cheerTrigger)` |
| AC-3 / EC-2 Dynamic Alert Queue 5 วินาที | `DashboardAlert` (dashboard_models.dart), `DashboardLogic.alertQueue / isHungry / resolveAlert / nextAlert`, `DashboardController` (Timer `alertIntervalSeconds`) · ฟอง `dashboard_alert_slot/_banner/_text` |
| AC-4 3 แถบรายหมวด | `_buildBarRow` → `dashboard_<food/steps/water>_row/_label_text/_bar` (แถบอาหารสี error เมื่อ `FoodController.isOverLimit`) |
| AC-5 / EC-3 ตัดรอบ 05:00 ขณะเปิดค้าง | ไม่มีรอบวันของตัวเอง — `DashboardController.refreshDay()` เรียก `water.refreshDailyReset()` / `steps.refreshDay()` / `food.refreshDay()` ทุก 1 วินาที + ตอน resume; ข้ามวัน (`steps.state.day`/`food.state.day` เปลี่ยน) → ฟองเริ่มที่ข้อความ Priority สูงสุด |
| EC-4 ติดลบ/Null → 0 | `DashboardRules.clampScore`, `ratioScore` |
| ui-spec §2.0 ทางเข้า | `dashboard_entry_button` ใน AppBar ของ `WaterHomeScreen` (หลัง food ก่อน report) ส่ง controller ตัวเดียวกับ steps/food |
| ui-spec §3 ไม่มีเป้าอาหาร | ป้าย 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 สี onSurfaceVariant, แถบ 0, total หาร 2 |
| ui-spec §3 กำลังโหลด | `CircularProgressIndicator` เมื่อ controller ใดยัง `!isLoaded` |

## ไฟล์

สร้าง (5)
- app/lib/features/dashboard/dashboard_rules.dart — สูตร D-3, Q-1, เกณฑ์ mood/alert, alertInterval, petSize, anchor, ข้อความทั้งหมด
- app/lib/features/dashboard/dashboard_models.dart — `DashboardPetMood`, `DashboardAlert`, `DashboardInput`, `DashboardSnapshot`
- app/lib/features/dashboard/dashboard_logic.dart — pure Dart: snapshot, moodFor, poseFor, alertQueue, resolveAlert, nextAlert
- app/lib/features/dashboard/dashboard_controller.dart — รวม 3 controller (ไม่เก็บข้อมูล) + Timer หมุนข้อความ (`DashboardTimerFactory` inject ได้)
- app/lib/features/dashboard/screens/dashboard_screen.dart — S-1

แก้ (1)
- app/lib/features/water/screens/water_home_screen.dart — เพิ่ม `dashboard_entry_button` + `_openDashboard`; แยก `_stepsController()` / `_foodController()` (โค้ดเดิมย้ายมา พฤติกรรมเดิม); ปุ่ม `water_monthly_report_button` ห่อ `Flexible` + label `maxLines: 1, ellipsis` (ดู ASSUMPTION A-10)

ไม่แก้ docs/, app/test/, app/lib/shared/pet/, pubspec

## ASSUMPTION ทั้งหมด

| # | จุด | สมมติฐาน |
|---|---|---|
| A-1 | `DashboardRules.waterTargetCups` | Q-14: derive = 100 / 12.5 = 8 แก้ว จาก `WaterRules` (ไม่พิมพ์ 8) |
| A-2 | `ratioScore` | D-3 คำนวณ `actual×100/target` หารครั้งเดียว; target ≤ 0 → 0 |
| A-3 | `foodScore` | D-3 + Q-16 ปัดเป็นจำนวนเต็ม; target ≤ 0 = ไม่มีเป้า |
| A-4 | `totalScore` | Q-1 หาร 2 เมื่อไม่มีเป้า; Q-16 เฉลี่ยจากคะแนนที่ปัดแล้ว |
| A-5 | `foodHungryBelowScore` | D-4 = 50 |
| A-6 | `isHungry` | Q-3 ประเมินสด (บันทึกแล้วแต่ < 50 ยังอยู่ในคิว); ไม่มีเป้า → ใช้แค่ "ยังไม่บันทึกมื้อ" |
| A-7 | `isHungry` | **ใหม่:** "foodScore < 50" นับเฉพาะตอน kcal ≤ target — กินเกินเป้ามากจน foodScore < 50 จะไม่ขึ้น「ฉันหิว」 (ขัดกับ P1) → คำถาม QD-2 |
| A-8 | `resolveAlert` | Q-19: เริ่ม/ข้ามวัน/มีข้อความใหม่เข้าคิว → Priority สูงสุด · ข้อความที่แสดงหลุดคิว → ข้อความลำดับถัดไปทันที (EC-2) วนกลับต้นคิว · ข้อความอื่นหลุด → คงข้อความเดิม · ข้อความเปลี่ยน = เริ่มนับ 5 วินาทีใหม่ |
| A-9 | `dayCheckIntervalSeconds` | 1 วินาที แบบ steps/food |
| A-10 | water AppBar | ui-spec §2.0 ว่า 3 ไอคอน + ปุ่มรายงานไม่ล้นที่ 360 dp แต่ตรวจจริงล้น 41 px (ฟอนต์เทสต์) → ปุ่มรายงานหดได้ + ellipsis (key/ข้อความ/ลำดับเดิม; จอกว้างเหมือนเดิม) → คำถาม QD-3 |
| A-11 | `dashboard_alert_slot` | ui-spec เสนอ Stack + Visibility(maintainSize) ซ่อนข้อความ P1 แต่ทำให้ `find.text(P1)` เจอ 2 ตัว (ตรวจแล้ว) → วัดความสูงฟอง P1 ด้วย TextPainter แล้วใช้เป็น min height ผ่าน `FoodSharedMinHeightBox` (ของเดิม) — ช่องสูงเท่าฟอง P1 เสมอ ไม่ล็อกความสูง |
| A-12 | ฟองข้อความ | ฟองเต็มความกว้าง สูงตามข้อความ จัดกลางแนวตั้งในช่อง |
| A-13 | `screenTitle` / `entryTooltip` | Q-8 「แดชบอร์ด」 |
| A-14 | `foodNoTargetText` | Q-1 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 |
| A-15 | ข้อความแจ้งเตือน | Q-21 ไม่รวม `"` |
| A-16 | `DashboardController.start` | food โหลดแล้ว → `refreshDay()` + `refreshProfile()` แบบ FoodDashboardScreen (เป้า kcal อัปเดตตามโปรไฟล์) |

## Package ที่เพิ่ม

ไม่มี (ห้ามเพิ่มตามคำสั่ง) · ไม่มี network / analytics / crash reporting

## คำถามที่ค้าง

- QD-1 (Design B, Q-14): ยืนยันเป้าน้ำ 8 แก้ว (derive จาก 100 / 12.5) — สัตว์เลี้ยง water ร่าเริงที่ 7 แก้ว แต่ waterScore = 88 และยังมี「ดื่มน้ำๆ」ในคิว
- QD-2 (Design/Product, D-4): กินเกินเป้ามากจน foodScore < 50 ควรขึ้น「ฉันหิว」ด้วยหรือไม่ — ตอนนี้ไม่ขึ้น (A-7)
- QD-3 (UI): ui-spec §2.0 ประเมินว่า AppBar ไม่ล้นที่ 360 dp แต่ล้นจริง 41 px — ยอมรับการหดป้าย「รายงานรายเดือน」ด้วย ellipsis หรือจะเปลี่ยนเป็นปุ่มไอคอน (A-10)
- QD-4 (UI): ยอมรับการวัดความสูงช่องแทน Visibility ซ่อนข้อความหรือไม่ (A-11)
- QD-5 (Design, Q-19): กฎเลือกข้อความเมื่อคิวเปลี่ยน (A-8) รอ game-rules ยืนยัน
- ข้อสังเกต (ไม่ได้แก้ — ไม่อยู่ในขอบเขต): body ของ `WaterHomeScreen` (ไม่มี scroll) overflow แนวตั้งที่ 360×640 dp + textScaler 1.5 — ของเดิมก่อนงานนี้

## ตัวเลขการทำงาน

| รายการ | ค่า |
|---|---|
| เวลาที่ใช้ | ~50 นาที (≈07:35–08:24) |
| ไฟล์สร้าง | 5 (+ log นี้) |
| ไฟล์แก้ | 1 |
| สมมติฐาน | 16 |
| คำถามค้าง | 5 (+ ข้อสังเกต 1) |

## ผล analyze / test

- `flutter analyze` (ใน app/): **No issues found!**
- `flutter test` (ใน app/): **603/603 ผ่าน** (All tests passed!)
- เช็กเองด้วยเทสต์ชั่วคราว app/tmp_dashboard_check/ (นอก app/test/, **ลบแล้ว**) 7 เคสผ่าน: ตัวอย่าง game-rules §3 (70 / 66 / 60 / cap 100), ขอบอารมณ์ 30/31/60/61/80/81, foodScore 2150/2000 = 93, ฟองหมุน P2→P3→P4→P2 ทุก 5 วินาที, บันทึกเกินเป้า → P1 ทันที + แถบแดง, ข้าม 05:00 ขณะเปิดค้าง → ทุกอย่าง 0%, ช่องข้อความห่างกล่องสัตว์เลี้ยง 12 px และสูงคงที่เมื่อข้อความหมุน, คิวว่าง → ไม่มี banner แต่ slot อยู่, ไม่มีเป้า → ป้าย「ยังไม่มีเป้าหมาย」, total 100 → cheerful, จอ 360×640 textScaler 1.0 (ผ่าน water → dashboard) และ 1.5 (dashboard ตรง) ไม่มี overflow, `find.text(P1)` เจอ 1

=== จบ logs/20261031-0824_dev_dashboard.md ===

=== logs/20261031-0846_qa_dashboard.md ===
# QA log: dashboard (รอบ 1)

- บทบาท: QA · feature: dashboard · branch feat/dashboard-dev · ไม่ได้ commit / push · ไม่ได้แก้ `app/lib/` · ไม่ได้แก้ `docs/dashboard/` นอกจากสร้าง `test-report.md`
- อ่านแล้ว: docs/dashboard/requirements.md, game-rules.md, ux-flow.md, ui-spec.md · logs/20261031-0824_dev_dashboard.md · โค้ด app/lib/features/dashboard/ (5 ไฟล์) + `git diff HEAD -- app/lib/features/water/` · controller/model ของ water/steps/food · แพทเทิร์นเทสต์ app/test/food/ (food_test_helpers.dart, FakeTimers) · docs/food/test-report.md
- ไฟล์ที่สร้าง: app/test/dashboard/dashboard_test_helpers.dart, dashboard_logic_test.dart, dashboard_controller_test.dart, dashboard_screens_test.dart · docs/dashboard/test-report.md · log นี้
- ไฟล์ชั่วคราว (นอก repo, scratchpad): เทสต์ probe overflow หน้า water + สำเนา `git archive HEAD app` สำหรับเทียบกับ HEAD — ไม่ได้แตะ working tree

## ข้อตัดสิน owner — DECIDED (owner ชั่วคราว, รอทีมยืนยัน)
- **D-1** สัตว์เลี้ยงใช้ PetCharacter: CRYING [0,30] → PetPose.dashboardCrying, DAZED (30,60] → dashboardDazed, BUBBLY (60,80] → dashboardBubbly (= waterHappy), CHEERFUL (80,100] → dashboardCheerful ไม่ใช้ PNG
- **D-2** เวลาเครื่อง ตัดรอบ 05:00 แบบเดียวกับ water/steps/food ไม่มี Server Time
- **D-3** คะแนน: Water, Steps = round(min(actual/target,1)×100); Food: ถึงเป้า = (kcal/target)×100, เกินเป้า = max(0, 100 − (ส่วนที่เกิน/target×100)), ไม่มีเป้า = ไม่คิดคะแนน
- **D-4** Priority 4 "คะแนนอาหารต่ำกว่าเกณฑ์" = foodScore < 50
- **Q-1** Food ไม่มีเป้า → total = round((Steps + Water) / 2), แถบอาหารแสดง「ยังไม่มีเป้าหมาย」
- **Q-14** เป้าน้ำใช้ค่าคงที่ของ water_rules.dart (ไม่มีตรง ๆ = 8 แก้ว)
- **Q-3, Q-16, Q-19, Q-20, Q-21, Q-8** ใช้ตามที่ ui-spec เลือก
- **Q-4 / Q-5 / Q-17** brief ขัดกับ game-rules → ยึด game-rules และ D-3 (P2/P3 ที่ < 100, ตัดออกจากคิวทันที)
- **Q-7** water ยังเป็นหน้าแรก เข้า dashboard ผ่าน `dashboard_entry_button` (ต้องไม่กระทบ signup S-7 และเทสต์เดิม)
- **Q-2** ลบมื้ออาหารไม่อยู่ในขอบเขต · **Q-11** ไม่แสดงจำนวนจริงและป้ายโซเดียม/น้ำตาล · BUBBLY ใช้หน้าเดิม

## ตาราง AC/EC → เทสต์ (ทำก่อนเขียนโค้ดเทสต์ ฉบับเต็มอยู่ใน test-report §2–§4)
AC-1 สูตรเฉลี่ย / cap / integer (L + W) · AC-2 ขอบอารมณ์ 0/30/31/60/61/80/81/100 + pose (L + W) · AC-3 ข้อความตรงตัว 4 ข้อ, trigger/removal ทุก Priority, หมุน 5 s (C + W) · AC-4 องค์ประกอบ/ลำดับ/สี/ป้าย (W) · AC-5 05:00 (C + W) · EC-1 cap (L, W) · EC-2 ตัดออกทันที (L, C, W) · EC-3 04:59:59 → 05:00:00 เปิดค้าง (C, W) · EC-4 ติดลบ/ว่าง/ข้อมูลเสีย (L, C, W) · EC-5 65.66 → 66 (L, W) · game-rules §3 ทุกแถว, §4 ทุกแถว · จอ 360×640 textScaler 1.0 / 1.5 · edge บังคับ 4 แบบ

## ตัวเลขการทำงาน (จากการรันจริง)
- เวลา: เริ่ม 08:26 (`date` ตอนเริ่มอ่านเอกสาร) ถึง 08:46 ≈ 20 นาที
- จำนวนรอบที่รัน `flutter test`: 7 รอบในโปรเจกต์ (+ probe 2 รอบใน scratchpad, + `flutter analyze` 2 รอบ)
  1. 08:35:00 `test/dashboard/` → ล้ม 2 (ผลถูก grep กรองจนเห็นไม่ครบ จึงรันซ้ำ)
  2. ~08:35:40 `test/dashboard/` → `+104 -2` (DECIDED_D4_P4_far_over_target_food_score_below_50_in_queue, UI_card_and_bubble_colors_from_color_scheme)
  - probe 1: scratchpad เทสต์หน้า water 360×640 บน working tree → 1.0: 0 error · 1.5: 1 error (body overflow 68 px)
  - probe 2: เทสต์เดียวกันบนสำเนา HEAD → 1.0: 0 error · 1.5: 2 error (AppBar 79 px + body 68 px)
  3. ~08:37 `test/dashboard/` (หลังแก้เทสต์สี) → `00:15 +105 -1`
  4. 08:39:21–~08:42 `flutter test` ทั้งแอป → `02:37 +708 -1: Some tests failed.`
  5. 08:42:49 `test/dashboard/dashboard_logic_test.dart` → (นับจำนวน) ล้ม 1
  6. ~08:43 `test/dashboard/dashboard_controller_test.dart` → `+18: All tests passed!`
  7. ~08:43 `test/dashboard/dashboard_screens_test.dart` → `00:13 +43: All tests passed!` · 08:44 logic อีกครั้ง → `00:00 +44 -1`
  - `flutter analyze`: 08:34:38 และ 08:39:21 → `No issues found!` ทั้ง 2 รอบ (5.1s / 5.9s)
- เทสต์ dashboard: 106 (L 45 · C 18 · W 43) · ผ่าน 105 · ไม่ผ่าน 1
- ทั้งแอป: 708 ผ่าน / 1 ไม่ผ่าน (เดิม 603 ผ่านครบ + dashboard 106)
- AC 5/5 มีเทสต์ (AC-3 ล้ม 1 เทสต์) · EC 5/5 มีเทสต์ ผ่านครบ · AC/EC ที่ยังไม่มีเทสต์: 0
- Bug ที่เจอ: 1 (BUG-DASH-1 「ฉันหิว」ไม่เข้าคิวเมื่อกินเกินเป้าจน foodScore < 50) · Dev แก้แล้ว: 0 (ยังไม่ส่งกลับ)
- เทสต์ที่ QA แก้เองเพราะเทสต์ผิด: 1 (UI_card_and_bubble_colors_from_color_scheme — สมมติว่า key ฟองอยู่บน Container เอง ซึ่ง ui-spec ไม่ได้บังคับ)
- คำถามค้าง: 11 (test-report §7)
- ข้อสังเกตแยก: หน้า water overflow 68 px แนวตั้งที่ 360×640 textScaler 1.5 — มีมาก่อน (ยืนยันจาก diff + probe บน HEAD) ไม่ใช่บั๊ก dashboard

## หมายเหตุ
- ค่าคาดหวังมาจากเอกสาร/ข้อตัดสินทั้งหมด · ตัวอย่าง game-rules §3 ที่น้ำ 60/67% (ทำไม่ได้ด้วยเป้า 8 แก้ว) assert ตรงตัวที่ระดับ logic และใช้ชุดค่าที่ผลรวมเท่ากันใน widget test
- จุดที่เอกสารไม่ระบุ (ปัด .5, คะแนนปัดถึง 100 ก่อนถึงเป้า, ความหน่วงของ "ทันที", ข้อความอื่นหลุดคิว) ไม่ได้ assert และจดเป็นคำถาม
- เวลาควบคุมทั้งหมด: `clock` ของ 3 controller + `FakeTimers` (C) / `tester.pump(Duration)` (W) — ไม่มี sleep / เวลาจริง / pumpAndSettle บน S-1
- เทสต์ที่ล้ม (BUG-DASH-1) ปล่อย fail ตามคำสั่ง ไม่ได้แก้ค่าคาดหวังตามโค้ด

=== จบ logs/20261031-0846_qa_dashboard.md ===

=== app/pubspec.yaml ===
name: petpal_health
description: "A new Flutter project."
# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.0+1

environment:
  sdk: ^3.13.5

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.5.6
  # signup: hash รหัสผ่านใน FakeAuthRepository (requirements §6 Password Hashed)
  crypto: ^3.0.7
  path_provider: ^2.1.6

dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^6.0.0

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter packages.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # assets/images/ — ภาพประกอบของฟีเจอร์ (เช่น bg_dashboard.png ของ steps ถ้ามี)
  # โฟลเดอร์ต้องมีอยู่จริง (assets/images/.gitkeep) ไม่งั้น build พัง
  # DECIDED (owner 2026-10-14): สัตว์เลี้ยงทั้งแอปคือ PetCharacter (lib/shared/pet/)
  # PNG สัตว์เลี้ยงเดิมย้ายไป assets/images/legacy/ และตั้งใจ "ไม่" ลงทะเบียนโฟลเดอร์นั้น
  # (รายการแบบโฟลเดอร์ของ Flutter ไม่รวมโฟลเดอร์ย่อย) จึงไม่ถูก bundle เข้าแอป
  assets:
    - assets/images/

  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/to/resolution-aware-images

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/to/asset-from-package

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/to/font-from-package

=== จบ app/pubspec.yaml ===

=== app/lib/features/dashboard/dashboard_controller.dart ===
/// ตัวกลางระหว่าง logic ของ dashboard กับ UI
///
/// ไม่มี repository / ไม่เก็บข้อมูลเอง — อ่านค่าจาก WaterController / StepsController /
/// FoodController ตัวเดียวกับที่หน้า water ใช้ (D-2) แล้วคำนวณ snapshot สดทุกครั้ง
/// controller นี้ถือเฉพาะสถานะการแสดงผลของ Dynamic Alert Banner (ข้อความที่แสดง + Timer 5 วินาที)
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../food/food_controller.dart';
import '../steps/steps_controller.dart';
import '../water/water_controller.dart';
import 'dashboard_logic.dart';
import 'dashboard_models.dart';
import 'dashboard_rules.dart';

/// สร้าง Timer — inject ตัวปลอมในเทสต์ที่ไม่ใช่ widget test เพื่อสั่งให้หมดเวลาเองได้
/// (แบบ FoodTimerFactory)
typedef DashboardTimerFactory = Timer Function(
  Duration duration,
  void Function() callback,
);

Timer _defaultTimer(Duration d, void Function() cb) => Timer(d, cb);

class DashboardController extends ChangeNotifier {
  DashboardController({
    required this.water,
    required this.steps,
    required this.food,
    DashboardTimerFactory? timerFactory,
  }) : _timer = timerFactory ?? _defaultTimer {
    for (final c in _sources) {
      c.addListener(_onSourceChanged);
    }
    _queue = snapshot.alerts;
    _daySignature = _currentDaySignature();
    _setCurrent(DashboardLogic.nextAlert(_queue, null));
  }

  final WaterController water;
  final StepsController steps;
  final FoodController food;
  final DashboardTimerFactory _timer;

  List<ChangeNotifier> get _sources => [water, steps, food];

  List<DashboardAlert> _queue = const [];
  DashboardAlert? _current;
  Timer? _alertTimer;
  Object? _daySignature;
  bool _disposed = false;

  // ---------------------------------------------------------------------------
  // ค่าสำหรับ UI
  // ---------------------------------------------------------------------------

  /// ทั้ง 3 controller โหลดจากเครื่องเสร็จแล้ว
  bool get isLoaded => water.isLoaded && steps.isLoaded && food.isLoaded;

  /// ค่าดิบจาก controller เดิม ณ ตอนนี้
  DashboardInput get input => DashboardInput(
        cups: water.cups,
        steps: steps.steps,
        stepsGoal: steps.activeGoal,
        totalCalories: food.totalCalories,
        targetCalories: food.targetCalories,
        isFoodOverLimit: food.isOverLimit,
        hasMealsToday: food.state.meals.isNotEmpty,
      );

  /// คะแนน / อารมณ์ / คิว — คำนวณสดจาก controller เดิม (ไม่ cache ข้อมูลซ้ำ)
  DashboardSnapshot get snapshot => DashboardLogic.snapshot(input);

  /// ข้อความที่แสดงในฟองตอนนี้ (null = คิวว่าง → ซ่อนฟอง)
  DashboardAlert? get currentAlert => _current;

  // ---------------------------------------------------------------------------
  // โหลด / รอบวัน (AC-5, EC-3 — ใช้รอบ 05:00 ของ controller เดิม, D-2)
  // ---------------------------------------------------------------------------

  /// เรียกตอนเปิดหน้า: โหลด controller ที่ยังไม่โหลด / ตรวจรอบวันของตัวที่โหลดแล้ว
  Future<void> start() async {
    await Future.wait([
      water.isLoaded ? water.refreshDailyReset() : water.load(),
      steps.isLoaded ? steps.refreshDay() : steps.load(),
      // แบบ FoodDashboardScreen: เข้าหน้าแล้วอ่านโปรไฟล์ใหม่ (เป้า kcal อาจเปลี่ยนจาก signup)
      food.isLoaded ? _refreshFood() : food.load(),
    ]);
  }

  Future<void> _refreshFood() async {
    await food.refreshDay();
    await food.refreshProfile();
  }

  /// ตรวจข้าม 05:00 ของทั้ง 3 controller — เรียกเป็นระยะขณะเปิดหน้าค้าง และตอนแอป resume
  Future<void> refreshDay() async {
    await Future.wait([
      water.refreshDailyReset(),
      steps.refreshDay(),
      food.refreshDay(),
    ]);
  }

  // ---------------------------------------------------------------------------
  // Dynamic Alert Banner (AC-3, EC-2)
  // ---------------------------------------------------------------------------

  /// รอบวันตามที่ controller เดิมเก็บไว้ (steps / food มี `state.day` จาก logicalDay 05:00)
  Object _currentDaySignature() =>
      Object.hash(steps.state.day, food.state.day);

  void _onSourceChanged() {
    if (_disposed) return;
    final previous = _queue;
    _queue = snapshot.alerts;
    final signature = _currentDaySignature();
    final dayChanged = signature != _daySignature;
    _daySignature = signature;
    final next = DashboardLogic.resolveAlert(
      previousQueue: previous,
      queue: _queue,
      current: _current,
      dayChanged: dayChanged,
    );
    if (next != _current || dayChanged) {
      _setCurrent(next);
    } else if (_current != null && _alertTimer == null) {
      _restartTimer();
    }
    notifyListeners();
  }

  /// เปลี่ยนข้อความที่แสดง แล้วเริ่มนับ alertInterval ใหม่ (Q-19)
  void _setCurrent(DashboardAlert? alert) {
    _current = alert;
    _alertTimer?.cancel();
    _alertTimer = null;
    if (alert != null) _restartTimer();
  }

  void _restartTimer() {
    _alertTimer?.cancel();
    _alertTimer = _timer(
      const Duration(seconds: DashboardRules.alertIntervalSeconds),
      _onAlertTick,
    );
  }

  void _onAlertTick() {
    _alertTimer = null;
    if (_disposed) return;
    _setCurrent(DashboardLogic.nextAlert(_queue, _current));
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _alertTimer?.cancel();
    _alertTimer = null;
    for (final c in _sources) {
      c.removeListener(_onSourceChanged);
    }
    super.dispose();
  }
}

=== จบ app/lib/features/dashboard/dashboard_controller.dart ===

=== app/lib/features/dashboard/dashboard_logic.dart ===
/// Logic เกมของฟีเจอร์ dashboard — pure Dart ไม่ขึ้นกับ widget
///
/// สูตรคะแนน / เกณฑ์อยู่ใน DashboardRules — ไฟล์นี้ประกอบผล (snapshot), สร้างคิวข้อความ
/// และเลือกข้อความที่แสดงในการหมุนเวียน
library;

import '../../shared/pet/pet_pose.dart' show PetPose;
import 'dashboard_models.dart';
import 'dashboard_rules.dart';

class DashboardLogic {
  DashboardLogic._();

  // ---------------------------------------------------------------------------
  // คะแนน + อารมณ์ (AC-1, AC-2, EC-1, EC-4, EC-5)
  // ---------------------------------------------------------------------------

  static DashboardSnapshot snapshot(DashboardInput input) {
    final water = DashboardRules.waterScore(input.cups);
    final steps = DashboardRules.stepsScore(input.steps, input.stepsGoal);
    final food = DashboardRules.foodScore(
      input.totalCalories,
      input.targetCalories,
    );
    final total = DashboardRules.totalScore(
      waterScore: water,
      stepsScore: steps,
      foodScore: food,
    );
    // Q-2: ไม่มีเป้า → isOverLimit เป็น false อยู่แล้ว (FoodLogic.isOverLimit)
    final overLimit = input.isFoodOverLimit && input.targetCalories != null;
    return DashboardSnapshot(
      waterScore: water,
      stepsScore: steps,
      foodScore: food,
      totalScore: total,
      mood: moodFor(total),
      isFoodOverLimit: overLimit,
      alerts: alertQueue(
        waterScore: water,
        stepsScore: steps,
        foodScore: food,
        isFoodOverLimit: overLimit,
        hasMealsToday: input.hasMealsToday,
        isFoodOverTarget: input.targetCalories != null &&
            input.totalCalories > input.targetCalories!,
      ),
    );
  }

  /// CRYING [0,30] · DAZED (30,60] · BUBBLY (60,80] · CHEERFUL (80,100] — จาก totalScore หลังปัด
  static DashboardPetMood moodFor(int totalScore) {
    if (totalScore <= DashboardRules.cryingMaxScore) {
      return DashboardPetMood.crying;
    }
    if (totalScore <= DashboardRules.dazedMaxScore) {
      return DashboardPetMood.dazed;
    }
    if (totalScore <= DashboardRules.bubblyMaxScore) {
      return DashboardPetMood.bubbly;
    }
    return DashboardPetMood.cheerful;
  }

  /// อารมณ์ → ท่าของ shared pet (D-1, ui-spec §4)
  // DECIDED (owner ชั่วคราว, รอบ 2): BUBBLY ใช้หน้าเดิม (dashboardBubbly == waterHappy)
  static PetPose poseFor(DashboardPetMood mood) => switch (mood) {
        DashboardPetMood.crying => PetPose.dashboardCrying,
        DashboardPetMood.dazed => PetPose.dashboardDazed,
        DashboardPetMood.bubbly => PetPose.dashboardBubbly,
        DashboardPetMood.cheerful => PetPose.dashboardCheerful,
      };

  // ---------------------------------------------------------------------------
  // Dynamic Alert Queue (AC-3, EC-2, game-rules §1.1)
  // ---------------------------------------------------------------------------

  /// คิวข้อความที่ trigger อยู่ เรียง Priority 1 → 4 — ประเมินสดจากค่าปัจจุบันทุกครั้ง
  /// ("คัดออกทันทีเมื่อแก้ปัญหาสำเร็จ" = เงื่อนไขไม่เป็นจริงแล้วจึงไม่อยู่ในคิว)
  static List<DashboardAlert> alertQueue({
    required int waterScore,
    required int stepsScore,
    required int? foodScore,
    required bool isFoodOverLimit,
    required bool hasMealsToday,
    required bool isFoodOverTarget,
  }) {
    return List.unmodifiable([
      // P1: เกินเป้า > 100 kcal (FoodController.isOverLimit) — ค้างจนตัดรอบ 05:00 (Q-2)
      if (isFoodOverLimit) DashboardAlert.overeating,
      if (waterScore < DashboardRules.waterAlertBelowScore)
        DashboardAlert.drinkWater,
      if (stepsScore < DashboardRules.stepsAlertBelowScore)
        DashboardAlert.moveBody,
      if (isHungry(
        foodScore: foodScore,
        hasMealsToday: hasMealsToday,
        isFoodOverTarget: isFoodOverTarget,
      ))
        DashboardAlert.hungry,
    ]);
  }

  /// P4 「ฉันหิว」: ยังไม่บันทึกมื้อใดวันนี้ หรือ foodScore < 50 (D-4)
  // ASSUMPTION: ui-spec Q-3 — ประเมิน trigger แบบสด: บันทึกแล้วแต่ foodScore ยัง < 50 ข้อความยังอยู่
  // · ไม่มีเป้า (foodScore null) → ใช้เฉพาะ "ยังไม่บันทึกมื้อใด"
  // ASSUMPTION: ส่วน "foodScore < 50" นับเฉพาะตอนกินยังไม่ถึงเป้า (kcal ≤ target) — กินเกินเป้า
  // มากจน foodScore < 50 ไม่ขึ้น「ฉันหิว」 (ขัดกับ P1「อิ่มและอืดเกินไป」)
  // DECIDED (owner รอบ 3, BUG-DASH-1 / QD-2): ยึดทางนี้ — กินเกินเป้าไม่ขึ้น「ฉันหิว」
  static bool isHungry({
    required int? foodScore,
    required bool hasMealsToday,
    required bool isFoodOverTarget,
  }) {
    if (!hasMealsToday) return true;
    if (foodScore == null || isFoodOverTarget) return false;
    return foodScore < DashboardRules.foodHungryBelowScore;
  }

  /// เลือกข้อความที่ควรแสดงหลังคิวเปลี่ยน (ไม่ใช่ตอนครบ 5 วินาที)
  /// - คิวว่าง → null (ซ่อนฟอง — Q-10)
  /// - ยังไม่มีข้อความ / ข้ามรอบวัน → ข้อความ Priority สูงสุด (Q-19, ui-spec §3 ข้ามช่วงเวลา)
  /// - ข้อความที่แสดงอยู่หลุดจากคิว → ข้อความลำดับถัดไปทันที (EC-2, game-rules §4) วนกลับต้นคิว
  /// - มีข้อความใหม่เข้าคิว → ข้อความ Priority สูงสุด (Q-19)
  /// - อื่น ๆ → คงข้อความเดิม
  // ASSUMPTION: ui-spec Q-19 ค่าชั่วคราว — รอ game-rules ยืนยัน
  static DashboardAlert? resolveAlert({
    required List<DashboardAlert> previousQueue,
    required List<DashboardAlert> queue,
    required DashboardAlert? current,
    bool dayChanged = false,
  }) {
    if (queue.isEmpty) return null;
    if (current == null || dayChanged) return queue.first;
    if (!queue.contains(current)) return _after(queue, current.priority);
    final added = queue.any((a) => !previousQueue.contains(a));
    if (added) return queue.first;
    return current;
  }

  /// ข้อความถัดไปเมื่อครบ alertInterval (วนลูปตามลำดับ Priority)
  static DashboardAlert? nextAlert(
    List<DashboardAlert> queue,
    DashboardAlert? current,
  ) {
    if (queue.isEmpty) return null;
    if (current == null) return queue.first;
    return _after(queue, current.priority);
  }

  /// ข้อความแรกในคิวที่ Priority ต่ำกว่า (เลขมากกว่า) [priority] — ไม่มี → วนกลับต้นคิว
  static DashboardAlert _after(List<DashboardAlert> queue, int priority) {
    for (final a in queue) {
      if (a.priority > priority) return a;
    }
    return queue.first;
  }
}

=== จบ app/lib/features/dashboard/dashboard_logic.dart ===

=== app/lib/features/dashboard/dashboard_models.dart ===
/// โมเดลของฟีเจอร์ dashboard — ไม่มีข้อมูลที่เก็บลงเครื่อง (ค่าทั้งหมดอ่านจาก controller เดิม)
library;

import 'dashboard_rules.dart';

/// อารมณ์สัตว์เลี้ยงตาม totalScore (game-rules.md §2)
enum DashboardPetMood {
  crying,
  dazed,
  bubbly,
  cheerful;

  /// ใช้ใน key `dashboard_pet_image_<keyName>`
  String get keyName => name;

  /// ชื่อไทย (game-rules §2) — semanticLabel ของสัตว์เลี้ยง
  String get label => switch (this) {
        DashboardPetMood.crying => DashboardRules.moodCryingLabel,
        DashboardPetMood.dazed => DashboardRules.moodDazedLabel,
        DashboardPetMood.bubbly => DashboardRules.moodBubblyLabel,
        DashboardPetMood.cheerful => DashboardRules.moodCheerfulLabel,
      };
}

/// ข้อความใน Dynamic Alert Queue (game-rules.md §1.1) — เรียงตาม Priority 1 → 4
enum DashboardAlert {
  overeating(1, DashboardRules.alertOvereatingText),
  drinkWater(2, DashboardRules.alertDrinkWaterText),
  moveBody(3, DashboardRules.alertMoveBodyText),
  hungry(4, DashboardRules.alertHungryText);

  const DashboardAlert(this.priority, this.text);

  /// 1 = สำคัญสูงสุด
  final int priority;

  /// ข้อความบนจอ (ตรงตัว)
  final String text;
}

/// ค่าดิบที่ dashboard อ่านจาก controller เดิม ณ ขณะหนึ่ง (ไม่คำนวณ/เก็บซ้ำ)
class DashboardInput {
  const DashboardInput({
    required this.cups,
    required this.steps,
    required this.stepsGoal,
    required this.totalCalories,
    required this.targetCalories,
    required this.isFoodOverLimit,
    required this.hasMealsToday,
  });

  /// WaterController.cups
  final int cups;

  /// StepsController.steps
  final int steps;

  /// StepsController.activeGoal
  final int stepsGoal;

  /// FoodController.totalCalories
  final int totalCalories;

  /// FoodController.targetCalories (null = ไม่มีเป้า / ข้ามโปรไฟล์)
  final int? targetCalories;

  /// FoodController.isOverLimit (Priority 1 / หลอดแดง)
  final bool isFoodOverLimit;

  /// FoodController.state.meals ไม่ว่าง
  final bool hasMealsToday;
}

/// ผลคำนวณของ dashboard ณ ขณะหนึ่ง
class DashboardSnapshot {
  const DashboardSnapshot({
    required this.waterScore,
    required this.stepsScore,
    required this.foodScore,
    required this.totalScore,
    required this.mood,
    required this.isFoodOverLimit,
    required this.alerts,
  });

  final int waterScore;
  final int stepsScore;

  /// null = ไม่คิดคะแนน (ไม่มีเป้าอาหาร — D-3)
  final int? foodScore;
  final int totalScore;
  final DashboardPetMood mood;

  /// แถบอาหารสีแดง (Priority 1)
  final bool isFoodOverLimit;

  /// คิวข้อความที่ trigger อยู่ เรียง Priority 1 → 4
  final List<DashboardAlert> alerts;

  bool get hasFoodScore => foodScore != null;
}

=== จบ app/lib/features/dashboard/dashboard_models.dart ===

=== app/lib/features/dashboard/dashboard_rules.dart ===
/// ค่าคงที่กติกาเกม + สูตรคะแนนของฟีเจอร์ dashboard (คะแนนสุขภาพรวมและอารมณ์สัตว์เลี้ยง)
///
/// ตัวเลขกติกามาจาก docs/dashboard/game-rules.md §1, §1.1, §2 และ requirements.md AC-1..AC-5
/// สูตรคะแนนรายหมวดมาจากข้อตัดสิน owner D-3 / D-4 / Q-1 (docs/dashboard/ui-spec.md §0, §6)
/// ขนาด/ระยะหน้าจอมาจาก ui-spec.md §1.3 · ข้อความบนจอมาจาก ux-flow.md §2 / game-rules.md §1.1
/// (ตรงตัว) และ ui-spec ("เสนอ — รอยืนยัน")
///
/// dashboard ไม่มีข้อมูล/รอบวันของตัวเอง — อ่านค่าจาก WaterController / StepsController /
/// FoodController เท่านั้น (D-2) ไฟล์นี้จึงมีแค่สูตรแปลงค่าเหล่านั้นเป็นคะแนน 0–100
library;

import 'dart:math' as math;

import '../water/water_rules.dart';

class DashboardRules {
  DashboardRules._();

  // ---------------------------------------------------------------------------
  // game-rules.md §1 ค่าหลัก — ช่วงคะแนน
  // ---------------------------------------------------------------------------

  /// คะแนนต่ำสุดของทุกหมวด / คะแนนรวม (EC-4: ติดลบหรือ Null → 0)
  static const int minScore = 0;

  /// คะแนนสูงสุดของทุกหมวด / คะแนนรวม (AC-1, EC-1: Cap 100%)
  static const int maxScore = 100;

  /// alertInterval — หมุนข้อความแจ้งเตือนทุก 5 วินาที (US-3, AC-3)
  static const int alertIntervalSeconds = 5;

  /// resetHour — ไม่มีรอบวันของ dashboard เอง: ใช้ 05:00 ของ water / steps / food (D-2)
  /// ค่านี้อ้างอิงค่าเดียวกับ WaterRules (ไม่ตั้งเลขใหม่) เพื่อเอกสารเท่านั้น
  static const int resetHour = WaterRules.dailyResetHour;

  // ---------------------------------------------------------------------------
  // game-rules.md §2 อารมณ์สัตว์เลี้ยง — ขอบบน "รวม" ของแต่ละช่วง (คิดจาก totalScore หลังปัด)
  // CRYING [0, 30] · DAZED (30, 60] · BUBBLY (60, 80] · CHEERFUL (80, 100]  (AC-2, Q-13)
  // ---------------------------------------------------------------------------
  static const int cryingMaxScore = 30;
  static const int dazedMaxScore = 60;
  static const int bubblyMaxScore = 80;

  // ---------------------------------------------------------------------------
  // game-rules.md §1.1 Dynamic Alert Queue — เกณฑ์ trigger
  // ---------------------------------------------------------------------------

  /// Priority 1: "Overeating > 100 kcal / หลอดอาหารแสดงสีแดง" — ใช้ FoodController.isOverLimit
  /// ตัวเดียวกับหลอดแดงของ food (เกณฑ์ 100 kcal อยู่ที่ FoodRules.overLimitThreshold —
  /// ไม่ตั้งเลขซ้ำที่นี่)

  /// Priority 2 / 3: อยู่ในคิวเมื่อคะแนน "ต่ำกว่า" ค่านี้ (`waterScore < 100%`, `stepsScore < 100%`)
  // DECIDED (owner ชั่วคราว รอบ 2, Q-4): ยึด game-rules (< 100) ไม่ใช่ brief (< 80)
  static const int waterAlertBelowScore = 100;
  static const int stepsAlertBelowScore = 100;

  /// Priority 4: "คะแนนอาหารต่ำกว่าเกณฑ์" = foodScore < 50
  // ASSUMPTION: DECIDED (owner ชั่วคราว, รอทีมยืนยัน) D-4 — เกณฑ์ 50
  static const int foodHungryBelowScore = 50;

  // ---------------------------------------------------------------------------
  // Q-14 เป้าน้ำ (แก้ว)
  // ---------------------------------------------------------------------------

  /// เป้าน้ำประจำวัน (แก้ว) สำหรับสูตร D-3 `actual / target`
  // ASSUMPTION: DECIDED (owner ชั่วคราว รอบ 2, Q-14) — water ไม่มีค่าคงที่ "เป้าแก้ว" ตรง ๆ
  // จึง derive จากค่าคงที่ของ water: energyMaxDisplayPercentage / energyIncrementPercentage
  // = 100 / 12.5 = 8 แก้ว (ไม่พิมพ์เลข 8 เอง)
  // DECIDED (owner รอบ 3, QD-1): ใช้ 8 แก้วจากค่าคงที่ของ water ต่อ
  // หมายเหตุ: สัตว์เลี้ยงของ water ร่าเริงตั้งแต่ 7 แก้ว แต่ที่ 7 แก้ว waterScore = 87 (floor)
  static int get waterTargetCups => (WaterRules.energyMaxDisplayPercentage /
          WaterRules.energyIncrementPercentage)
      .round();

  // ---------------------------------------------------------------------------
  // สูตรคะแนน (D-3, Q-1, EC-4) — pure ฟังก์ชัน
  //
  // DECIDED (owner รอบ 3, 2026-10-31): ปัดคะแนน "ลง" (floor) ทุกตัว — แทน round ของ D-3 / Q-1 /
  // ui-spec Q-16 · Water / Steps / Food / total ได้ 100 ก็ต่อเมื่อถึงเป้าจริงเท่านั้น
  // (เช่น 7,999 / 8,000 ก้าว = 99) · ใช้เลขจำนวนเต็ม (`~/`) ทั้งหมด ไม่มีเศษ floating point
  // ผลต่อตัวอย่าง game-rules §3: (70, 60, 67) → 197 / 3 = 65.66 → **65** (เอกสาร/EC-5 เขียน 66)
  // ---------------------------------------------------------------------------

  /// EC-4: ค่าติดลบ / Null → 0 และไม่เกิน 100 (ค่าทศนิยมปัดลง — owner รอบ 3)
  static int clampScore(num? value) {
    if (value == null || value.isNaN || value < minScore) return minScore;
    if (value > maxScore) return maxScore;
    return value.floor();
  }

  /// Water / Steps = `floor(min(actual / target, 1) × 100)`
  // ASSUMPTION: DECIDED (owner ชั่วคราว) D-3 + รอบ 3 (floor แทน round)
  // คำนวณ `actual × 100 ~/ target` (จำนวนเต็ม) · target ≤ 0 → 0 (กันหารศูนย์) · actual ≤ 0 → 0 (EC-4)
  static int ratioScore(int actual, int target) {
    if (target <= 0 || actual <= 0) return minScore;
    return clampScore(actual * 100 ~/ target);
  }

  /// waterScore จากจำนวนแก้วของรอบวันปัจจุบัน (WaterController.cups)
  static int waterScore(int cups) => ratioScore(cups, waterTargetCups);

  /// stepsScore จากก้าวและเป้าที่ใช้อยู่ (StepsController.steps / activeGoal)
  static int stepsScore(int steps, int activeGoal) =>
      ratioScore(steps, activeGoal);

  /// foodScore จาก kcal รวมวันนี้และเป้า (FoodController.totalCalories / targetCalories)
  /// - ไม่มีเป้า (ข้ามโปรไฟล์) → null = "ไม่คิดคะแนน"
  /// - ถึงเป้า (kcal ≤ target) → `floor((kcal / target) × 100)` (= 100 เฉพาะ kcal == target)
  /// - เกินเป้า → `floor(max(0, 100 − (ส่วนที่เกิน / target × 100)))` (เกิน 1 kcal ก็ < 100)
  // ASSUMPTION: DECIDED (owner ชั่วคราว) D-3 + รอบ 3 (floor แทน round)
  // ASSUMPTION: target ≤ 0 (ไม่ควรเกิดจาก FoodLogic) ถือเป็น "ไม่มีเป้า" กันหารศูนย์
  static int? foodScore(int totalCalories, int? targetCalories) {
    if (targetCalories == null || targetCalories <= 0) return null;
    final kcal = math.max(0, totalCalories); // EC-4
    if (kcal <= targetCalories) {
      return clampScore(kcal * 100 ~/ targetCalories);
    }
    // floor(100 − x) = 100 − ceil(x) โดย x = ส่วนที่เกิน × 100 / target
    final overScaled = (kcal - targetCalories) * 100;
    final overCeil = (overScaled + targetCalories - 1) ~/ targetCalories;
    return clampScore(maxScore - overCeil);
  }

  /// totalScore = `floor((Food + Steps + Water) / 3)` cap 100 (AC-1, EC-1)
  /// Food ไม่คิดคะแนน (null) → `floor((Steps + Water) / 2)`
  // ASSUMPTION: DECIDED (owner ชั่วคราว รอบ 2, Q-1) — ไม่มีเป้าอาหาร หาร 2
  // DECIDED (owner รอบ 3): floor แทน round — EC-5 (65.66 → 66) เปลี่ยนเป็น 65
  static int totalScore({
    required int waterScore,
    required int stepsScore,
    required int? foodScore,
  }) {
    final w = clampScore(waterScore);
    final s = clampScore(stepsScore);
    if (foodScore == null) return clampScore((s + w) ~/ 2);
    return clampScore((clampScore(foodScore) + s + w) ~/ 3);
  }

  // ---------------------------------------------------------------------------
  // ui-spec §1.3 ขนาด / ระยะ / เวลา (ไม่ใช่กติกาเกม — ค่าหน้าตา)
  // ---------------------------------------------------------------------------

  /// ขนาดสัตว์เลี้ยง 200 × 200 (ui-spec §1.3, Q-9 — แทน fallback 300×300 ของ PNG ตาม D-1)
  static const double petSize = 200;

  /// ระยะขอบล่างช่องข้อความ ↔ ขอบบนกล่องสัตว์เลี้ยง (ui-spec §1.3, §2.1.1)
  static const double alertAnchorOffset = 12;

  /// ความสูงแถบรายหมวด (ui-spec §1.3)
  static const double barMinHeight = 12;

  /// ความถี่ตรวจรอบวันขณะเปิดหน้าค้าง (ui-spec §3 "ข้ามช่วงเวลา")
  // ASSUMPTION: เอกสารไม่กำหนดความถี่ — 1 วินาทีแบบ _dayCheckInterval ของ steps / food
  static const int dayCheckIntervalSeconds = 1;

  // ---------------------------------------------------------------------------
  // ข้อความบนหน้าจอ
  // ---------------------------------------------------------------------------

  // ASSUMPTION: ui-spec Q-8 (เสนอ — รอยืนยัน) — หัวข้อ AppBar และ tooltip ปุ่มทางเข้า
  static const String screenTitle = 'แดชบอร์ด';
  static const String entryTooltip = 'แดชบอร์ด';

  /// game-rules §1.1 — ตรงตัว ไม่รวม `"` ตัวคั่น
  // ASSUMPTION: ui-spec Q-21 — `"` ในเอกสารเป็นตัวคั่น string ไม่ใช่ส่วนของข้อความบนจอ
  static const String alertOvereatingText =
      'แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว';
  static const String alertDrinkWaterText = 'ดื่มน้ำๆ';
  static const String alertMoveBodyText = 'ขยับร่างกายหน่อย อีกนิดๆ';
  static const String alertHungryText = 'ฉันหิว';

  /// ชื่อไทยของอารมณ์ (game-rules §2) — ใช้เป็น semanticLabel ไม่แสดงบนจอ (ui-spec §2.1 #5)
  static const String moodCryingLabel = 'ร้องไห้';
  static const String moodDazedLabel = 'เหม่อลอย';
  static const String moodBubblyLabel = 'ออรุ่มเจ๊าะ';
  static const String moodCheerfulLabel = 'ยิ้มร่าเริง';

  /// ux-flow §2 `คะแนนสุขภาพรวม: [Integer]%`
  static String totalScoreText(int score) => 'คะแนนสุขภาพรวม: $score%';

  /// ux-flow §2 `คะแนนอาหาร: [Integer]%`
  static String foodScoreText(int score) => 'คะแนนอาหาร: $score%';

  /// ux-flow §2 `คะแนนการก้าวเดิน: [Integer]%`
  static String stepsScoreText(int score) => 'คะแนนการก้าวเดิน: $score%';

  /// ux-flow §2 `คะแนนการดื่มน้ำ: [Integer]%`
  static String waterScoreText(int score) => 'คะแนนการดื่มน้ำ: $score%';

  /// ป้ายแถบอาหารเมื่อไม่มีเป้า (ไม่คิดคะแนน — D-3)
  // ASSUMPTION: ui-spec Q-1 (เสนอ — รอยืนยัน)
  static const String foodNoTargetText = 'คะแนนอาหาร: ยังไม่มีเป้าหมาย';
}

=== จบ app/lib/features/dashboard/dashboard_rules.dart ===

=== app/lib/features/dashboard/screens/dashboard_screen.dart ===
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:petpal_health/shared/pet/pet.dart';

import '../../food/food_controller.dart';
import '../../food/screens/food_profile_screen.dart';
import '../../food/widgets/food_profile_cta_banner.dart';
import '../../food/widgets/food_shared_min_height_box.dart';
import '../../steps/steps_controller.dart';
import '../../water/water_controller.dart';
import '../dashboard_controller.dart';
import '../dashboard_logic.dart';
import '../dashboard_models.dart';
import '../dashboard_rules.dart';

/// S-1 หน้าจอแดชบอร์ดหลัก — ux-flow §2 S-1, ui-spec §2.1
/// AC-1, AC-2, AC-3, AC-4, AC-5, EC-1..EC-5
///
/// รับ controller ตัวเดียวกับที่หน้า water ใช้ (ui-spec §2.0) — หน้าจอไม่เก็บ/คำนวณข้อมูลเอง
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.waterController,
    required this.stepsController,
    required this.foodController,
    this.animatePet,
    this.timerFactory,
  });

  final WaterController waterController;
  final StepsController stepsController;
  final FoodController foodController;

  /// `PetCharacter.animate` — null = [kPetAnimateByDefault] (แอปจริง animate,
  /// ระหว่าง flutter test เป็นภาพนิ่ง)
  final bool? animatePet;

  /// Timer หมุนข้อความ (alertInterval) — null = `Timer` จริง (widget test ใช้ `pump(Duration)`)
  final DashboardTimerFactory? timerFactory;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  // PetCharacter มีตัวตนคงที่ข้ามการเปลี่ยนอารมณ์ (BUG-PET-1) — key ฟีเจอร์อยู่บน KeyedSubtree
  final GlobalKey _petKey = GlobalKey(debugLabel: 'dashboard_pet');

  late final DashboardController _controller;
  Timer? _dayTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = DashboardController(
      water: widget.waterController,
      steps: widget.stepsController,
      food: widget.foodController,
      timerFactory: widget.timerFactory,
    );
    _controller.start();
    // ui-spec §3 ข้ามช่วงเวลา: ตรวจรอบวัน 05:00 ของทั้ง 3 controller ขณะเปิดหน้าค้าง (EC-3)
    _dayTimer = Timer.periodic(
      const Duration(seconds: DashboardRules.dayCheckIntervalSeconds),
      (_) => _controller.refreshDay(),
    );
  }

  @override
  void dispose() {
    _dayTimer?.cancel();
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// CTA → S-3 ตั้งโปรไฟล์ของ food (FoodController ตัวเดียวกัน — บันทึกแล้วคะแนนอาหารขึ้นทันที)
  void _openFoodProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FoodProfileScreen(controller: widget.foodController),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _controller.refreshDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          DashboardRules.screenTitle,
          key: Key('dashboard_header_text'),
        ),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (!_controller.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildContent(context);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final s = _controller.snapshot;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // #1 Total Score Card (AC-1, EC-1, EC-5)
                    Container(
                      key: const Key('dashboard_total_score_card'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        DashboardRules.totalScoreText(s.totalScore),
                        key: const Key('dashboard_total_score_text'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // #3 Dynamic Alert Banner (AC-3, EC-2)
                    _buildAlertSlot(context, _controller.currentAlert),
                    // #4 ระยะ anchor
                    const SizedBox(height: DashboardRules.alertAnchorOffset),
                    // #5 Pet Character Display (AC-2) — D-1: PetCharacter ไม่ใช่ PNG
                    // ไม่ส่ง cheerTrigger (Q-20) — CHEERFUL กระโดดวนเองจาก preset
                    Center(
                      child: KeyedSubtree(
                        key: ValueKey('dashboard_pet_image_${s.mood.keyName}'),
                        child: PetCharacter(
                          key: _petKey,
                          pose: DashboardLogic.poseFor(s.mood),
                          size: DashboardRules.petSize,
                          animate: widget.animatePet ?? kPetAnimateByDefault,
                          semanticLabel: s.mood.label,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // #7 Food Progress Bar (AC-4) — แดงเมื่อ Priority 1
                    _buildBarRow(
                      context,
                      name: 'food',
                      label: s.foodScore == null
                          ? DashboardRules.foodNoTargetText
                          : DashboardRules.foodScoreText(s.foodScore!),
                      labelColor:
                          s.foodScore == null ? scheme.onSurfaceVariant : null,
                      score: s.foodScore ?? DashboardRules.minScore,
                      color: s.isFoodOverLimit ? scheme.error : scheme.primary,
                    ),
                    // DECIDED (owner รอบ 3 ข้อ 5): ไม่มีเป้าอาหาร → ใช้ CTA Banner เดิมของ food
                    // (FoodProfileCtaBanner — keys `food_profile_cta_banner` ฯลฯ) พาไป S-3
                    // ASSUMPTION: วางใต้แถบอาหาร ห่าง 8 (ระยะในแถวเดียวกัน ui-spec §2.1.2) และคงป้าย
                    // 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 + แถบ 0 ไว้ตาม ui-spec §3 (Q-1) — ui-spec ไม่มีตำแหน่ง CTA
                    if (!s.hasFoodScore) ...[
                      const SizedBox(height: 8),
                      FoodProfileCtaBanner(
                        totalText: widget.foodController.ctaTotalText,
                        onTap: _openFoodProfile,
                      ),
                    ],
                    const SizedBox(height: 16),
                    // #9 Steps Progress Bar (AC-4)
                    _buildBarRow(
                      context,
                      name: 'steps',
                      label: DashboardRules.stepsScoreText(s.stepsScore),
                      score: s.stepsScore,
                      color: scheme.primary,
                    ),
                    const SizedBox(height: 16),
                    // #11 Water Progress Bar (AC-4)
                    _buildBarRow(
                      context,
                      name: 'water',
                      label: DashboardRules.waterScoreText(s.waterScore),
                      score: s.waterScore,
                      color: scheme.primary,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ui-spec §2.1.1 — ช่องจองที่สูงเท่าฟองข้อความ Priority 1 (ยาวสุด) ที่ความกว้าง/textScaler จริง
  /// ไม่ล็อกความสูงคงที่ (บทเรียน food BUG-FOOD-1/2) · คิวว่าง = ไม่มีฟองแต่ยังจองที่ (Q-10)
  // ASSUMPTION: ui-spec เสนอ Stack + Visibility(maintainSize) ที่มีข้อความ Priority 1 ซ่อนอยู่ แต่
  // วิธีนั้นทำให้ข้อความ P1 อยู่ใน widget tree เสมอ (find.text เจอ 2 ตัวตอน P1 แสดง / เจอแม้คิวว่าง)
  // จึงวัดความสูงฟอง P1 ด้วย TextPainter แล้วใช้เป็น "ความสูงขั้นต่ำ" ผ่าน FoodSharedMinHeightBox
  // (ของเดิมของ food — รองรับ IntrinsicHeight) ผลบนจอเท่ากัน: ช่องสูงเท่าฟอง P1 เสมอ และโตได้ถ้าจำเป็น
  Widget _buildAlertSlot(BuildContext context, DashboardAlert? alert) {
    return FoodSharedMinHeightBox(
      key: const Key('dashboard_alert_slot'),
      minHeightFor: _alertSlotMinHeightFor(context),
      child: alert == null
          ? const SizedBox.shrink()
          : Center(
              child: SizedBox(
                width: double.infinity,
                child: _AlertBubble(
                  key: const Key('dashboard_alert_banner'),
                  textKey: const Key('dashboard_alert_text'),
                  message: alert.text,
                ),
              ),
            ),
    );
  }

  /// ความสูงฟองข้อความ Priority 1 ที่ความกว้าง [width] (padding 16/8 + ข้อความ bodyMedium)
  MinHeightForWidth _alertSlotMinHeightFor(BuildContext context) {
    final theme = Theme.of(context);
    final base = DefaultTextStyle.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    final locale = Localizations.maybeLocaleOf(context);
    return (width) {
      final painter = TextPainter(
        text: TextSpan(
          text: DashboardAlert.overeating.text,
          style: base.style.merge(theme.textTheme.bodyMedium),
        ),
        textAlign: TextAlign.center,
        textDirection: direction,
        textScaler: scaler,
        locale: locale,
        textHeightBehavior: base.textHeightBehavior,
        textWidthBasis: base.textWidthBasis,
      )..layout(maxWidth: math.max(0, width - _AlertBubble.padH * 2));
      final h = painter.height + _AlertBubble.padV * 2;
      painter.dispose();
      return h;
    };
  }

  /// ui-spec §2.1.2 แถวแถบรายหมวด
  Widget _buildBarRow(
    BuildContext context, {
    required String name,
    required String label,
    required int score,
    required Color color,
    Color? labelColor,
  }) {
    return Column(
      key: Key('dashboard_${name}_row'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          key: Key('dashboard_${name}_label_text'),
          textAlign: TextAlign.start,
          style: labelColor == null ? null : TextStyle(color: labelColor),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            key: Key('dashboard_${name}_bar'),
            value: (score / DashboardRules.maxScore).clamp(0.0, 1.0),
            minHeight: DashboardRules.barMinHeight,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// ฟองข้อความแจ้งเตือน (ui-spec §2.1.1) — ไม่มี maxLines / ellipsis
class _AlertBubble extends StatelessWidget {
  const _AlertBubble({super.key, required this.message, this.textKey});

  /// ui-spec §1.3 padding ในกล่อง แนวนอน 16 แนวตั้ง 8
  static const double padH = 16;
  static const double padV = 8;

  final String message;
  final Key? textKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        key: textKey,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: scheme.onSecondaryContainer,
        ),
      ),
    );
  }
}

=== จบ app/lib/features/dashboard/screens/dashboard_screen.dart ===

=== app/lib/features/food/food_controller.dart ===
/// ตัวกลางระหว่าง logic เกมกับ UI ของฟีเจอร์ food
///
/// controller ถือสถานะชั่วคราว EATING / OVER_LIMIT_FEEDING (EATING_ANIMATION_DURATION) และ
/// Toast (TOAST_DURATION) เอง — widget สัตว์เลี้ยงไม่จับเวลา (ui-spec §4, character.md §6)
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../shared/pet/pet_pose.dart' show PetPose;
import '../signup/signup_models.dart' show SignupGender, UserProfile;
import 'food_logic.dart';
import 'food_models.dart';
import 'food_nutrition_parser.dart';
import 'food_profile_source.dart';
import 'food_repository.dart';
import 'food_rules.dart';

typedef FoodClock = DateTime Function();

/// สร้าง Timer — inject ตัวปลอมในเทสต์ที่ไม่ใช่ widget test เพื่อสั่งให้หมดเวลาเองได้
typedef FoodTimerFactory = Timer Function(
  Duration duration,
  void Function() callback,
);

Timer _defaultTimer(Duration d, void Function() cb) => Timer(d, cb);

/// ผลการกด「บันทึกข้อมูล」ใน S-2
enum MealSubmitOutcome {
  /// บันทึกแล้ว → กลับ S-1
  logged,

  /// AI Parsing Failure / Offline / เกิน AI_PARSING_TIMEOUT → S-2 Error (EC-1)
  parseFailed,

  /// ค่าแคลอรี่ที่กรอกเองอ่านไม่ได้
  invalidCalories,

  /// ยังโหลดไม่เสร็จ / กำลังบันทึกอยู่
  notReady,
}

/// ผลการบันทึก S-3
enum FoodProfileSaveOutcome { saved, invalid, failed }

class FoodController extends ChangeNotifier {
  FoodController({
    required this._repository,
    FoodProfileSource? profileSource,
    FoodNutritionParser? parser,
    FoodClock? clock,
    FoodTimerFactory? timerFactory,
  }) : _profileSource = profileSource ?? InMemoryFoodProfileSource(),
       _parser = parser ?? LocalMenuNutritionParser(),
       _clock = clock ?? DateTime.now,
       _timer = timerFactory ?? _defaultTimer;

  final FoodRepository _repository;
  final FoodProfileSource _profileSource;
  final FoodNutritionParser _parser;
  final FoodClock _clock;
  final FoodTimerFactory _timer;

  FoodState _state = FoodState.initial;
  UserProfile? _profile;
  bool _isLoaded = false;
  bool _busy = false;
  bool _disposed = false;

  FoodPetState? _transient;
  Timer? _transientTimer;
  String? _toastMessage;
  int _toastSerial = 0;
  Timer? _toastTimer;

  // ---------------------------------------------------------------------------
  // ค่าสำหรับ UI
  // ---------------------------------------------------------------------------

  FoodState get state => _state;
  bool get isLoaded => _isLoaded;

  /// โปรไฟล์จาก signup (null = ยังไม่มี)
  UserProfile? get profile => _profile;

  /// ผู้ใช้กด「ข้ามไปก่อน」(US-3)
  bool get profileSkipped => _state.profileSkipped;

  /// `target_calories` — null = ไม่มีเป้าหมาย → CTA Banner (AC-8, EC-4, Q-9)
  int? get targetCalories => FoodLogic.targetForProfile(_profile);
  bool get hasTarget => targetCalories != null;
  bool get showsProfileCta => !hasTarget;

  /// Q-13: เปิด S-3 ให้เองเฉพาะตอนยังไม่มีโปรไฟล์และยังไม่เคยกดข้าม
  bool get needsProfileSetup =>
      _isLoaded && _profile == null && !_state.profileSkipped;

  int get totalCalories => _state.totalCalories;

  /// หลอดแดง + ป้าย「อิ่มแล้ว」 — ตามข้อมูลจริงทันที (Q-5 DECIDED owner: ไม่รอท่า)
  bool get isOverLimit => FoodLogic.isOverLimit(totalCalories, targetCalories);
  bool get showsFullBadge => isOverLimit;

  /// สถานะสัตว์เลี้ยงที่แสดง (รวมท่าชั่วคราว)
  FoodPetState get petState =>
      _transient ?? FoodLogic.basePetState(totalCalories, targetCalories);
  PetPose get petPose => FoodLogic.poseFor(petState);

  double get energyFraction {
    final t = targetCalories;
    return t == null ? 0 : FoodLogic.energyFraction(totalCalories, t);
  }

  /// `'<total> / <target> kcal'` — null เมื่อไม่มีเป้าหมาย
  String? get calorieText {
    final t = targetCalories;
    return t == null ? null : FoodLogic.calorieText(totalCalories, t);
  }

  String get ctaTotalText => FoodLogic.ctaTotalText(totalCalories);

  /// Toast ที่แสดงอยู่ (null = ไม่มี) — ทีละ 1 ข้อความ (AC-12)
  String? get toastMessage => _toastMessage;

  /// เพิ่มทุกครั้งที่มี Toast ใหม่ (Queue replace — EC-2)
  int get toastSerial => _toastSerial;

  // ---------------------------------------------------------------------------
  // โหลด / รอบวัน
  // ---------------------------------------------------------------------------

  Future<void> load() async {
    FoodState loaded;
    try {
      loaded = await _repository.load();
    } catch (_) {
      // ASSUMPTION: อ่านข้อมูลไม่ได้ → เริ่มเป็นค่าว่าง แอปไม่ล่ม
      loaded = FoodState.initial;
    }
    _state = loaded;
    await _loadProfile();
    _isLoaded = true;
    await refreshDay();
    _notify();
  }

  /// อ่านโปรไฟล์จาก signup ใหม่ (เรียกตอนกลับเข้าหน้า S-1)
  Future<void> refreshProfile() async {
    await _loadProfile();
    _notify();
  }

  Future<void> _loadProfile() async {
    try {
      _profile = await _profileSource.load();
    } catch (_) {
      // ASSUMPTION: อ่านโปรไฟล์ไม่ได้ → ถือว่าไม่มีเป้าหมาย (CTA Banner)
      _profile = null;
    }
  }

  /// ตรวจว่าข้าม 05:00 น. หรือยัง ถ้าใช่รีเซ็ตเป็น 0 kcal (game-rules §4 Foreground Crossing)
  /// เรียกตอนเปิดหน้า, กลับมา foreground และเป็นระยะขณะเปิดหน้าค้าง
  Future<void> refreshDay() async {
    if (!_isLoaded) return;
    final next = FoodLogic.applyDayRollover(
      _state,
      _clock(),
      targetCalories: targetCalories,
    );
    if (identical(next, _state)) return;
    _state = next;
    _notify();
    await _trySave();
  }

  // ---------------------------------------------------------------------------
  // S-2 บันทึกมื้ออาหาร (AC-1, AC-2, AC-3, EC-1, AC-11, AC-12, EC-2, EC-3)
  // ---------------------------------------------------------------------------

  /// "AI Parsing" ภายใน AI_PARSING_TIMEOUT — null = ล้มเหลว/ออฟไลน์/หมดเวลา (EC-1)
  Future<FoodNutrition?> analyzeMeal(String text) async {
    try {
      final raw = await _parser
          .parse(text)
          .timeout(const Duration(seconds: FoodRules.aiParsingTimeoutSeconds));
      return FoodLogic.parseNutritionJson(raw);
    } catch (_) {
      return null;
    }
  }

  /// S-2 สถานะปกติ: ประมวลผลข้อความเมนูแล้วบันทึก
  // ASSUMPTION: ช่องเมนูว่าง (ui-spec Q-12 ปุ่มยัง enabled) → ประมวลผลไม่ได้ = EC-1
  Future<MealSubmitOutcome> submitMeal(String text) async {
    if (!_isLoaded || _busy) return MealSubmitOutcome.notReady;
    _busy = true;
    try {
      final nutrition = await analyzeMeal(text);
      if (nutrition == null) return MealSubmitOutcome.parseFailed;
      await _log(nutrition, manual: false);
      return MealSubmitOutcome.logged;
    } finally {
      _busy = false;
    }
  }

  /// S-2 สถานะผิดพลาด/ออฟไลน์: บันทึกค่าที่กรอกเอง — ว่าง = 300 kcal (EC-1)
  Future<MealSubmitOutcome> submitManual(String rawCalories) async {
    if (!_isLoaded || _busy) return MealSubmitOutcome.notReady;
    final calories = FoodLogic.manualCalories(rawCalories);
    if (calories == null) return MealSubmitOutcome.invalidCalories;
    _busy = true;
    try {
      await _log(FoodNutrition(calories: calories), manual: true);
      return MealSubmitOutcome.logged;
    } finally {
      _busy = false;
    }
  }

  /// บันทึกผลโภชนาการ 1 มื้อ (ใช้ตรงในเทสต์ได้)
  Future<void> logNutrition(FoodNutrition nutrition, {bool manual = false}) {
    if (!_isLoaded) return Future.value();
    return _log(nutrition, manual: manual);
  }

  Future<void> _log(FoodNutrition nutrition, {required bool manual}) async {
    final target = targetCalories;
    final now = _clock();
    // ตรวจรอบวันก่อน แล้วจึงดูว่า "ก่อนบันทึก" อยู่ในสถานะเกินเป้าหรือไม่ (AC-11)
    final rolled = FoodLogic.applyDayRollover(
      _state,
      now,
      targetCalories: target,
    );
    final wasOver = FoodLogic.isOverLimit(rolled.totalCalories, target);
    _state = FoodLogic.logMeal(
      rolled,
      nutrition,
      now,
      targetCalories: target,
      manual: manual,
    );
    // ไม่เพิ่ม cheerTrigger — ท่ากินคือ reaction (ui-spec §4)
    // Q-4 (ค่าชั่วคราว ui-spec): บันทึกซ้อนระหว่างท่าชั่วคราว → เริ่มท่าใหม่ตามการบันทึกล่าสุด
    _startTransient(FoodLogic.transientStateForLog(wasOverLimit: wasOver));
    final toast = FoodLogic.toastForLog(wasOverLimit: wasOver);
    if (toast != null) showToast(toast);
    _notify();
    await _trySave();
  }

  void _startTransient(FoodPetState state) {
    _transientTimer?.cancel();
    _transient = state;
    _transientTimer = _timer(FoodLogic.transientDuration(state), () {
      _transientTimer = null;
      _transient = null;
      _notify();
    });
  }

  /// แสดง Toast เหนือสัตว์เลี้ยง — ข้อความใหม่แทนที่ทันทีและนับ TOAST_DURATION ใหม่ (AC-12, EC-2)
  void showToast(String message) {
    _toastTimer?.cancel();
    _toastMessage = message;
    _toastSerial++;
    _toastTimer = _timer(const Duration(seconds: FoodRules.toastSeconds), () {
      _toastTimer = null;
      _toastMessage = null;
      _notify();
    });
    _notify();
  }

  // ---------------------------------------------------------------------------
  // S-3 โปรไฟล์ (AC-4..AC-7, EC-5, US-3)
  // ---------------------------------------------------------------------------

  Future<FoodProfileSaveOutcome> saveProfile({
    required String age,
    required SignupGender? gender,
    required String weight,
    required String height,
  }) async {
    final v = FoodLogic.validateProfile(
      age: age,
      gender: gender,
      weight: weight,
      height: height,
    );
    if (!v.canSave || gender == null) return FoodProfileSaveOutcome.invalid;
    UserProfile? saved;
    try {
      saved = await _profileSource.save(
        FoodProfileInput(
          age: int.parse(age.trim()),
          gender: gender,
          weightKg: double.parse(weight.trim()),
          heightCm: double.parse(height.trim()),
        ),
      );
    } catch (_) {
      saved = null;
    }
    if (saved == null) return FoodProfileSaveOutcome.failed;
    _profile = saved;
    if (_state.profileSkipped) {
      _state = _state.copyWith(profileSkipped: false);
      await _trySave();
    }
    _notify();
    return FoodProfileSaveOutcome.saved;
  }

  /// 「ข้ามไปก่อน」 — บันทึกสถานะข้ามโปรไฟล์ (US-3)
  Future<void> skipProfile() async {
    _state = _state.copyWith(profileSkipped: true);
    _notify();
    await _trySave();
  }

  // ---------------------------------------------------------------------------

  Future<void> _trySave() async {
    try {
      await _repository.save(_state);
    } catch (_) {
      // ASSUMPTION: บันทึกลงเครื่องไม่สำเร็จ → คงค่าในหน่วยความจำ แล้วบันทึกซ้ำครั้งถัดไป
      // (ux-flow ไม่มี UI error สำหรับกรณีนี้)
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _transientTimer?.cancel();
    _toastTimer?.cancel();
    super.dispose();
  }
}

=== จบ app/lib/features/food/food_controller.dart ===

=== app/lib/features/food/food_logic.dart ===
/// Logic เกมของฟีเจอร์ food — pure Dart ไม่ขึ้นกับ widget
///
/// ทุกฟังก์ชันที่เกี่ยวกับเวลารับ `now` เป็นพารามิเตอร์ เพื่อให้ QA ทดสอบได้
library;

import 'dart:convert';

import '../../shared/pet/pet_pose.dart' show PetPose;
import '../signup/signup_logic.dart' show NumberFieldStatus, SignupLogic;
import '../signup/signup_models.dart' show SignupGender, UserProfile;
import '../steps/steps_logic.dart' show StepsLogic;
import 'food_models.dart';
import 'food_rules.dart';

class FoodLogic {
  FoodLogic._();

  // ---------------------------------------------------------------------------
  // รอบวัน 05:00 น. (AC-3, US-5, game-rules §4 Foreground Crossing)
  // ---------------------------------------------------------------------------

  /// วันที่ "ตามรอบวัน" ที่เริ่ม 05:00 น. — AC-3: 15 ต.ค. 03:00 → 14 ต.ค.
  static DateTime logicalDay(DateTime now) {
    // ใช้ constructor ของ DateTime (ไม่ใช่ subtract Duration) กัน DST ทำให้วันเพี้ยน
    final shifted = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour - FoodRules.dailyResetHour,
      now.minute - FoodRules.dailyResetMinute,
    );
    return DateTime(shifted.year, shifted.month, shifted.day);
  }

  /// เวลาที่ใช้คำนวณกติกา: ไม่ถอยหลังกว่าเวลาล่าสุดที่ระบบเคยเห็น
  // ASSUMPTION: นาฬิกาเครื่องย้อน → ใช้เวลาล่าสุดที่เคยเห็น (ไม่ย้อนรอบวัน ไม่ลบข้อมูล)
  // แนวเดียวกับ StepsLogic.effectiveNow / WaterLogic — เอกสาร food ไม่กำหนด
  static DateTime effectiveNow(DateTime? lastSeenAt, DateTime now) =>
      lastSeenAt != null && now.isBefore(lastSeenAt) ? lastSeenAt : now;

  /// ตรวจและปรับรอบวัน ณ `now`:
  /// - ครั้งแรก (day == null) → ตั้งรอบวันปัจจุบัน 0 kcal
  /// - ข้าม 05:00 น. → เก็บรอบวันเดิมลงประวัติ แล้วรีเซ็ตเป็น 0 kcal
  /// - ตัดประวัติที่เก่ากว่า HISTORY_RETENTION_DAYS
  /// [targetCalories] = เป้าหมายปัจจุบัน ใช้คำนวณ `is_over_target` ของวันที่ถูกเก็บ
  /// คืน object เดิม (identical) ถ้าไม่มีอะไรเปลี่ยน
  static FoodState applyDayRollover(
    FoodState state,
    DateTime now, {
    int? targetCalories,
  }) {
    final effective = effectiveNow(state.lastSeenAt, now);
    final today = logicalDay(effective);
    final day = state.day;
    if (day == null) {
      return state.copyWith(
        day: today,
        totalCalories: 0,
        meals: const [],
        lastSeenAt: effective,
      );
    }
    if (!today.isAfter(day)) return state;
    final record = DailyFoodRecord(
      date: day,
      totalCalories: state.totalCalories,
      targetCalories: targetCalories,
      isOverTarget: isOverLimit(state.totalCalories, targetCalories),
      highSodium: state.todayHighSodium,
      highSugar: state.todayHighSugar,
    );
    return state.copyWith(
      day: today,
      totalCalories: 0,
      meals: const [],
      history: pruneHistory(upsertHistory(state.history, record), today),
      lastSeenAt: effective,
    );
  }

  /// ใส่/แทนที่ประวัติวันเดียวกัน แล้วเรียงเก่า → ใหม่
  static List<DailyFoodRecord> upsertHistory(
    List<DailyFoodRecord> history,
    DailyFoodRecord record,
  ) {
    final next = [
      for (final r in history)
        if (r.date != record.date) r,
      record,
    ]..sort((a, b) => a.date.compareTo(b.date));
    return List.unmodifiable(next);
  }

  /// เก็บเฉพาะวันที่อยู่ใน HISTORY_RETENTION_DAYS วันล่าสุด (นับรวม [today])
  static List<DailyFoodRecord> pruneHistory(
    List<DailyFoodRecord> history,
    DateTime today,
  ) {
    final oldest = DateTime(
      today.year,
      today.month,
      today.day - (FoodRules.historyRetentionDays - 1),
    );
    return List.unmodifiable([
      for (final r in history)
        if (!r.date.isBefore(oldest) && r.date.isBefore(today)) r,
    ]);
  }

  /// บันทึก 1 มื้อ ณ `now` (ตรวจรอบวันก่อน — AC-3) — total เพิ่มทันที
  static FoodState logMeal(
    FoodState state,
    FoodNutrition nutrition,
    DateTime now, {
    int? targetCalories,
    bool manual = false,
  }) {
    final rolled = applyDayRollover(state, now, targetCalories: targetCalories);
    final effective = effectiveNow(rolled.lastSeenAt, now);
    final calories = nutrition.calories < 0 ? 0 : nutrition.calories;
    final entry = FoodMealEntry(
      date: rolled.day!,
      loggedAt: effective,
      calories: calories,
      highSodium: nutrition.highSodium,
      highSugar: nutrition.highSugar,
      manual: manual,
    );
    return rolled.copyWith(
      totalCalories: rolled.totalCalories + calories,
      meals: List.unmodifiable([...rolled.meals, entry]),
      lastSeenAt: effective,
    );
  }

  // ---------------------------------------------------------------------------
  // เป้าหมายแคลอรี่ (AC-5, AC-6, AC-7, Base Target Reference Table)
  // ---------------------------------------------------------------------------

  /// Base Target ตามอายุและเพศ — null = คำนวณไม่ได้ (เพศไม่ระบุ / อายุนอก AGE_MIN..AGE_MAX)
  static int? baseTarget(int age, SignupGender gender) {
    if (!isAgeInRange(age)) return null;
    final bool male;
    switch (gender) {
      case SignupGender.male:
        male = true;
      case SignupGender.female:
        male = false;
      case SignupGender.unspecified:
        // ASSUMPTION: เพศ UNSPECIFIED (จาก signup S-6) ไม่มีในตาราง → ไม่มีเป้าหมาย
        // (signup AC-6 "ไม่สามารถคำนวณจำนวนแคลอรี่ที่เหมาะสมต่อวันได้") → แสดง CTA Banner
        return null;
    }
    if (age >= FoodRules.ageBand51upMin) {
      return male
          ? FoodRules.maleBaseTarget51up
          : FoodRules.femaleBaseTarget51up;
    }
    if (age >= FoodRules.ageBand19to50Min) {
      return male
          ? FoodRules.maleBaseTarget19to50
          : FoodRules.femaleBaseTarget19to50;
    }
    if (age >= FoodRules.ageBand16to18Min) {
      return male
          ? FoodRules.maleBaseTarget16to18
          : FoodRules.femaleBaseTarget16to18;
    }
    if (age >= FoodRules.ageBand13to15Min) {
      return male
          ? FoodRules.maleBaseTarget13to15
          : FoodRules.femaleBaseTarget13to15;
    }
    if (age >= FoodRules.ageBand10to12Min) {
      return male
          ? FoodRules.maleBaseTarget10to12
          : FoodRules.femaleBaseTarget10to12;
    }
    // อายุ 1–9 ปี — fallback ของ Design (game-rules §5)
    return male
        ? FoodRules.fallbackBaseTargetAge1to9Male
        : FoodRules.fallbackBaseTargetAge1to9Female;
  }

  /// BMI_FORMULA = weight_kg / ((height_cm / 100) ^ 2) — null ถ้าค่าไม่บวก
  /// คำนวณเป็น `weight * 10000 / (height * height)` (หารครั้งเดียว ลด floating error ที่ขอบ)
  // ASSUMPTION: เทียบเกณฑ์ด้วยค่า BMI จริง ไม่ปัดเป็นทศนิยม 1 ตำแหน่งก่อนเทียบ
  // ("Float 1 ตำแหน่ง" ใน game-rules ถือเป็นรูปแบบของค่าเกณฑ์)
  static double? bmi(double weightKg, double heightCm) {
    if (weightKg <= 0 || heightCm <= 0) return null;
    return weightKg * 10000 / (heightCm * heightCm);
  }

  /// ส่วนปรับตาม BMI: < 18.5 → +400 (AC-6), ≥ 23.0 → −400 (AC-7), อื่น ๆ → 0
  static int bmiAdjustment(double bmi) {
    if (bmi < FoodRules.bmiUnderweightThreshold) {
      return FoodRules.bmiUnderweightBonus;
    }
    if (bmi >= FoodRules.bmiOverweightThreshold) {
      return -FoodRules.bmiOverweightPenalty;
    }
    return 0;
  }

  /// `target_calories` — null = ไม่มีเป้าหมาย (แสดง CTA Banner, ไม่มี OVER_LIMIT — Q-9)
  static int? targetCalories({
    required int age,
    required SignupGender gender,
    required double? weightKg,
    required double? heightCm,
  }) {
    final base = baseTarget(age, gender);
    if (base == null || weightKg == null || heightCm == null) {
      // ASSUMPTION: โปรไฟล์ signup ที่ไม่มีน้ำหนัก/ส่วนสูง คำนวณ BMI ไม่ได้ → ไม่มีเป้าหมาย
      // (signup AC-7 "จะไม่มีการแนะนำแคลอรี่ที่เหมาะสมต่อวัน")
      return null;
    }
    final b = bmi(weightKg, heightCm);
    if (b == null) return null;
    return base + bmiAdjustment(b);
  }

  /// เป้าหมายจากโปรไฟล์ของ signup (Q-13) — null = ไม่มีโปรไฟล์ / ไม่ครบ
  static int? targetForProfile(UserProfile? profile) {
    if (profile == null) return null;
    return targetCalories(
      age: profile.age,
      gender: profile.gender,
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
    );
  }

  // ---------------------------------------------------------------------------
  // สถานะสัตว์เลี้ยง / หลอดพลังงาน (AC-9, AC-10, AC-11, game-rules §2)
  // ---------------------------------------------------------------------------

  /// `total > target + OVER_LIMIT_THRESHOLD` — ไม่มีเป้าหมาย → false เสมอ (Q-9)
  static bool isOverLimit(int total, int? target) =>
      target != null && total > target + FoodRules.overLimitThreshold;

  /// สถานะคงที่ (ไม่รวมท่าชั่วคราว)
  static FoodPetState basePetState(int total, int? target) =>
      isOverLimit(total, target) ? FoodPetState.overLimit : FoodPetState.normal;

  /// ท่าชั่วคราวหลังบันทึกสำเร็จ — [wasOverLimit] = ก่อนบันทึกอยู่ในสถานะเกินเป้าแล้ว
  /// (AC-11 / EC-3 → OVER_LIMIT_FEEDING, อื่น ๆ → EATING)
  static FoodPetState transientStateForLog({required bool wasOverLimit}) =>
      wasOverLimit ? FoodPetState.overLimitFeeding : FoodPetState.eating;

  /// ระยะของท่าชั่วคราว
  static Duration transientDuration(FoodPetState state) =>
      state == FoodPetState.overLimitFeeding
      ? const Duration(seconds: FoodRules.overLimitFeedingSeconds)
      : const Duration(seconds: FoodRules.eatingAnimationSeconds);

  /// Toast หลังบันทึก — AC-11: บันทึกขณะเกินเป้า → 「พอเถอะน้าคนดี」 ทุกครั้ง; อื่น ๆ → null
  static String? toastForLog({required bool wasOverLimit}) =>
      wasOverLimit ? FoodRules.overLimitToastText : null;

  /// สถานะ → ท่าของ shared pet (OQ-1 DECIDED: PetCharacter แทน Lottie/PNG)
  static PetPose poseFor(FoodPetState state) => switch (state) {
    FoodPetState.normal => PetPose.foodNormal,
    FoodPetState.eating => PetPose.foodEating,
    FoodPetState.overLimit => PetPose.foodOverLimit,
    FoodPetState.overLimitFeeding => PetPose.foodOverLimitFeeding,
  };

  /// สัดส่วนหลอด 0.0–1.0 (ui-spec §2.1 #9a: clamp)
  static double energyFraction(int total, int target) {
    if (target <= 0 || total <= 0) return 0;
    final f = total / target;
    return f > 1 ? 1 : f;
  }

  /// `'<total> / <target> kcal'` เช่น `1,900 / 2,000 kcal` (ไม่ clamp)
  static String calorieText(int total, int target) =>
      '${StepsLogic.formatThousands(total)} / '
      '${StepsLogic.formatThousands(target)} ${FoodRules.kcalUnit}';

  /// ยอดรวมบน CTA Banner เช่น `1,250 kcal` (ui-spec Q-8)
  static String ctaTotalText(int total) =>
      '${StepsLogic.formatThousands(total)} ${FoodRules.kcalUnit}';

  // ---------------------------------------------------------------------------
  // ผล "AI Parsing" (AC-1, AC-2, EC-1)
  // ---------------------------------------------------------------------------

  /// ค่ากึ่งกลาง (Median) ของชุดตัวเลข (AC-2) — ช่วง [a, b] = (a + b) / 2
  // ASSUMPTION: ผลไม่ลงตัวปัดเป็นจำนวนเต็มที่ใกล้สุด (.5 ปัดขึ้น) เพราะ total_calories
  // เป็น Integer (requirements §6) — เอกสารไม่กำหนดวิธีปัด
  static int medianCalories(List<num> values) {
    if (values.isEmpty) throw ArgumentError('values must not be empty');
    final sorted = [...values]..sort();
    final mid = sorted.length ~/ 2;
    final median = sorted.length.isOdd
        ? sorted[mid].toDouble()
        : (sorted[mid - 1] + sorted[mid]) / 2;
    return median.round();
  }

  static final RegExp _rangeText = RegExp(
    r'^\s*(\d+(?:\.\d+)?)\s*[-–~]\s*(\d+(?:\.\d+)?)\s*$',
  );

  /// อ่าน JSON โภชนาการ (AC-1) — `calories` เป็นตัวเลข, ช่วงตัวเลข (`[a, b]`, `"a-b"`,
  /// `{"min": a, "max": b}`) → ใช้ Median (AC-2) · คืน null ถ้าอ่านไม่ได้ (EC-1)
  static FoodNutrition? parseNutritionJson(String raw) {
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (_) {
      return null;
    }
    if (decoded is! Map) return null;
    final calories = _readCalories(decoded['calories']);
    if (calories == null || calories < 0) return null;
    return FoodNutrition(
      calories: calories,
      highSodium: decoded['high_sodium'] == true,
      highSugar: decoded['high_sugar'] == true,
    );
  }

  static int? _readCalories(Object? v) {
    if (v is num) return v.isFinite ? v.round() : null;
    if (v is List) {
      if (v.isEmpty || v.any((e) => e is! num)) return null;
      return medianCalories(v.cast<num>());
    }
    if (v is Map) {
      final min = v['min'];
      final max = v['max'];
      if (min is num && max is num) return medianCalories([min, max]);
      return null;
    }
    if (v is String) {
      final m = _rangeText.firstMatch(v);
      if (m != null) {
        return medianCalories([
          double.parse(m.group(1)!),
          double.parse(m.group(2)!),
        ]);
      }
      final n = num.tryParse(v.trim());
      return n == null || !n.isFinite ? null : n.round();
    }
    return null;
  }

  /// ค่าแคลอรี่จากฟอร์มกรอกเอง (EC-1) — ว่าง → FALLBACK_DEFAULT_CALORIES (300)
  /// คืน null ถ้าไม่ใช่จำนวนเต็มล้วน (UI กรองด้วย digitsOnly อยู่แล้ว)
  static int? manualCalories(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return FoodRules.fallbackDefaultCalories;
    if (!SignupLogic.isWholeNumberText(text)) return null;
    return int.tryParse(text);
  }

  // ---------------------------------------------------------------------------
  // S-3 ฟอร์มโปรไฟล์ (AC-4, EC-5, Q-14 DECIDED: กติกาเดียวกับ signup)
  // ---------------------------------------------------------------------------

  /// AGE_MIN ≤ age ≤ AGE_MAX
  static bool isAgeInRange(int age) =>
      age >= FoodRules.ageMin && age <= FoodRules.ageMax;

  /// อายุต้องเป็นจำนวนเต็มล้วน 1–120 — "25.5", "-3", "abc" = invalid (AC-4, EC-5)
  static FoodFieldStatus ageStatus(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return FoodFieldStatus.empty;
    if (!SignupLogic.isWholeNumberText(text)) return FoodFieldStatus.invalid;
    final v = int.tryParse(text);
    if (v == null || !isAgeInRange(v)) return FoodFieldStatus.invalid;
    return FoodFieldStatus.valid;
  }

  /// น้ำหนัก/ส่วนสูงรับทศนิยม (Q-14)
  // ASSUMPTION: ใช้ช่วงที่ signup รับ (น้ำหนัก 1–300 kg, ส่วนสูง 1–250 cm —
  // SignupLogic.weightStatus/heightStatus) เพราะโปรไฟล์บันทึกผ่าน signup (Q-13);
  // นอกช่วง = บันทึกไม่ได้ (ปุ่ม disabled) โดยไม่มีข้อความ error (ui-spec Q-15)
  static FoodFieldStatus weightStatus(String raw) =>
      _fromSignup(SignupLogic.weightStatus(raw));

  static FoodFieldStatus heightStatus(String raw) =>
      _fromSignup(SignupLogic.heightStatus(raw));

  static FoodFieldStatus _fromSignup(NumberFieldStatus status) =>
      switch (status) {
        NumberFieldStatus.empty => FoodFieldStatus.empty,
        NumberFieldStatus.valid => FoodFieldStatus.valid,
        NumberFieldStatus.outOfRange => FoodFieldStatus.invalid,
      };

  static FoodProfileValidation validateProfile({
    required String age,
    required SignupGender? gender,
    required String weight,
    required String height,
  }) => FoodProfileValidation(
    age: ageStatus(age),
    weight: weightStatus(weight),
    height: heightStatus(height),
    hasGender: gender == SignupGender.male || gender == SignupGender.female,
  );
}

=== จบ app/lib/features/food/food_logic.dart ===

=== app/lib/features/food/food_menu_table.dart ===
/// ตารางเมนูอาหารไทยที่ใช้บ่อย (ข้อมูลในเครื่อง) + ตัวจับคู่ชื่อเมนู — pure Dart
///
/// Q-17 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน): MVP ไม่มี AI และไม่ต่อเน็ต ใช้ตารางนี้
/// เทียบชื่อเมนู → kcal แทน AI Parsing ถ้าไม่เจอเมนูในตาราง = AI Parsing Failure (EC-1)
/// → S-2 แสดงช่องกรอกแคลอรี่เอง
///
// ASSUMPTION: ค่าชั่วคราว รอคำตอบ — ค่า kcal / ธงโซเดียม-น้ำตาลในตารางเป็นค่าประมาณ
// ต่อ 1 จาน/ชาม/แก้ว/ชิ้น จากตารางแคลอรี่อาหารไทยทั่วไป ไม่ได้มาจาก game-rules.md
// (เอกสารไม่มีตารางเมนู) ให้ Product/โภชนากรยืนยันหรือแทนที่ทั้งตาราง
// บางเมนูเก็บเป็น "ช่วง" (minKcal–maxKcal) เพื่อให้ผลเป็นช่วงตัวเลขแบบที่ AC-2 กล่าวถึง
// (ระบบจะใช้ค่ากึ่งกลาง — FoodLogic.medianCalories)
library;

import 'food_rules.dart';

/// เมนู 1 รายการในตาราง
class FoodMenuItem {
  const FoodMenuItem(
    this.names,
    this.minKcal, [
    int? maxKcal,
    this.highSodium = false,
    this.highSugar = false,
  ]) : maxKcal = maxKcal ?? minKcal;

  /// ชื่อเรียก (ชื่อแรก = ชื่อหลัก) — จับคู่แบบ "มีข้อความนี้อยู่ในประโยค"
  final List<String> names;
  final int minKcal;
  final int maxKcal;
  final bool highSodium;
  final bool highSugar;

  bool get isRange => maxKcal != minKcal;
  String get name => names.first;
}

/// เมนูที่จับคู่ได้ 1 ครั้งในข้อความ
class FoodMenuMatch {
  const FoodMenuMatch({
    required this.item,
    required this.alias,
    required this.start,
    required this.quantity,
  });

  final FoodMenuItem item;

  /// ชื่อที่พบจริงในข้อความ
  final String alias;

  /// ตำแหน่งในข้อความที่ normalize แล้ว
  final int start;
  final int quantity;

  int get minKcal => item.minKcal * quantity;
  int get maxKcal => item.maxKcal * quantity;
}

const bool _s = true; // high_sodium = true
const bool _n =
    false; // high_sodium = false (ใช้เมื่อต้องระบุ high_sugar ต่อท้าย)

/// ตารางเมนู — (ชื่อเรียก, kcal ต่ำสุด, kcal สูงสุด, โซเดียมสูง, น้ำตาลสูง)
const List<FoodMenuItem> kFoodMenuTable = [
  // จานเดียว
  FoodMenuItem(['ข้าวมันไก่ทอด'], 690, null, _s),
  FoodMenuItem(['ข้าวมันไก่'], 596, null, _s),
  FoodMenuItem(['ข้าวขาหมู'], 690, null, _s),
  FoodMenuItem(['ข้าวหมูแดง'], 540, null, _s, true),
  FoodMenuItem(['ข้าวหมูกรอบ'], 650, null, _s),
  FoodMenuItem(
    ['ข้าวผัดกะเพรา', 'ข้าวกะเพรา', 'กะเพรา', 'กระเพรา'],
    550,
    650,
    _s,
  ),
  FoodMenuItem(['ข้าวผัด'], 550, 650, _s),
  FoodMenuItem(['ข้าวไข่เจียว'], 450, 550),
  FoodMenuItem(['ข้าวไข่ดาว'], 380),
  FoodMenuItem(['ผัดไทย'], 450, 550, _s, true),
  FoodMenuItem(['ผัดซีอิ๊ว'], 600, 700, _s),
  FoodMenuItem(['ราดหน้า'], 400, 450, _s),
  FoodMenuItem(['สุกี้'], 300, 400, _s),
  FoodMenuItem(['ก๋วยเตี๋ยวต้มยำ'], 350, 450, _s),
  FoodMenuItem(['ก๋วยเตี๋ยวเรือ'], 200, 300, _s),
  FoodMenuItem(['ก๋วยเตี๋ยว'], 300, 400, _s),
  FoodMenuItem(['บะหมี่กึ่งสำเร็จรูป', 'มาม่า'], 300, null, _s),
  FoodMenuItem(['ขนมจีนน้ำยา', 'ขนมจีน'], 350, 450, _s),
  FoodMenuItem(['โจ๊ก'], 160, 250, _s),
  FoodMenuItem(['ข้าวต้ม'], 220, 300, _s),
  FoodMenuItem(['ข้าวมันส้มตำ'], 450, 550, _s, true),
  // กับข้าว / อีสาน
  FoodMenuItem(['ส้มตำ'], 60, 120, _s, true),
  FoodMenuItem(['ไก่ย่าง'], 160, 250, _s),
  FoodMenuItem(['คอหมูย่าง'], 300, 400, _s),
  FoodMenuItem(['หมูปิ้ง'], 100, 150, _n, true),
  FoodMenuItem(['ลาบ'], 200, 250, _s),
  FoodMenuItem(['น้ำตก'], 220, 250, _s),
  FoodMenuItem(['ต้มยำ'], 100, 250, _s),
  FoodMenuItem(['แกงเขียวหวาน'], 240, 300, _s),
  FoodMenuItem(['ไข่เจียว'], 250),
  FoodMenuItem(['ไข่ดาว'], 120),
  FoodMenuItem(['ไข่ต้ม'], 75),
  FoodMenuItem(['หมูกระทะ'], 800, 1200, _s),
  // ข้าวเปล่า
  FoodMenuItem(['ข้าวเหนียว'], 300, 350),
  FoodMenuItem(['ข้าวสวย', 'ข้าวเปล่า'], 240),
  // เครื่องดื่ม / ของว่าง
  FoodMenuItem(['ชานมไข่มุก'], 300, 450, _n, true),
  FoodMenuItem(['ชาเย็น', 'ชาไทย'], 250, 300, _n, true),
  FoodMenuItem(['กาแฟเย็น'], 200, 250, _n, true),
  FoodMenuItem(['น้ำอัดลม'], 140, 160, _n, true),
  FoodMenuItem(['โรตี'], 300, 400, _n, true),
  FoodMenuItem(['กล้วยทอด'], 200, 250, _n, true),
  FoodMenuItem(['ปาท่องโก๋'], 150, 200),
];

/// จับคู่ข้อความเมนูกับตาราง
///
/// วิธีจับคู่ (Q-17):
/// 1. normalize: ตัดช่องว่างหัวท้าย, เปลี่ยนตัวพิมพ์ใหญ่เป็นเล็ก, ยุบช่องว่างหลายช่องเป็นช่องเดียว
/// 2. ไล่ชื่อเรียกทุกชื่อจาก "ยาวที่สุด" ไป "สั้นที่สุด" หาทุกตำแหน่งที่พบในข้อความ
///    ตำแหน่งที่จับคู่แล้วถูกกันไว้ ชื่อที่สั้นกว่าจับซ้ำทับไม่ได้
///    (เช่น "ข้าวมันไก่ทอด" ไม่ถูกนับเป็น "ข้าวมันไก่" อีกรอบ, "ไข่เจียว" ใน "ข้าวไข่เจียว" ไม่ถูกนับซ้ำ)
/// 3. ถ้ามีตัวเลขตามหลังชื่อเมนู (ช่องว่างคั่นได้) เช่น "ข้าวมันไก่ 2 จาน" → คูณจำนวน
///    ไม่มีตัวเลข / เลข 0 → 1 ที่
/// 4. คืนรายการเรียงตามตำแหน่งในข้อความ — ว่าง = ไม่เจอเมนู
class FoodMenuMatcher {
  FoodMenuMatcher._();

  static String normalize(String text) =>
      text.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  static final RegExp _quantity = RegExp(
    '^ ?([0-9]{1,${FoodRules.menuQuantityMaxDigits}})(?![0-9])',
  );

  static List<FoodMenuMatch> match(
    String text, {
    List<FoodMenuItem> menu = kFoodMenuTable,
  }) {
    final normalized = normalize(text);
    if (normalized.isEmpty) return const [];
    final aliases = <({String alias, FoodMenuItem item})>[
      for (final item in menu)
        for (final name in item.names)
          if (normalize(name).isNotEmpty) (alias: normalize(name), item: item),
    ]..sort((a, b) => b.alias.length.compareTo(a.alias.length));

    final taken = List<bool>.filled(normalized.length, false);
    final matches = <FoodMenuMatch>[];
    for (final a in aliases) {
      var from = 0;
      while (true) {
        final i = normalized.indexOf(a.alias, from);
        if (i < 0) break;
        final end = i + a.alias.length;
        from = i + 1;
        var free = true;
        for (var k = i; k < end; k++) {
          if (taken[k]) {
            free = false;
            break;
          }
        }
        if (!free) continue;
        for (var k = i; k < end; k++) {
          taken[k] = true;
        }
        final q = _quantity.firstMatch(normalized.substring(end));
        final qty = q == null ? 1 : int.parse(q.group(1)!);
        matches.add(
          FoodMenuMatch(
            item: a.item,
            alias: a.alias,
            start: i,
            quantity: qty < 1 ? 1 : qty,
          ),
        );
        from = end;
      }
    }
    matches.sort((x, y) => x.start.compareTo(y.start));
    return List.unmodifiable(matches);
  }
}

=== จบ app/lib/features/food/food_menu_table.dart ===

=== app/lib/features/food/food_models.dart ===
/// โมเดลข้อมูลของฟีเจอร์ food (pure Dart)
library;

/// สถานะ/ท่าของสัตว์เลี้ยง 4 ท่า (game-rules §2)
enum FoodPetState {
  /// ท่าหิว / ปกติ — `total <= target + OVER_LIMIT_THRESHOLD` (หรือไม่มีเป้าหมาย)
  normal('NORMAL', 'normal'),

  /// ท่ากำลังกิน — ชั่วคราว EATING_ANIMATION_DURATION หลังบันทึกสำเร็จ
  eating('EATING', 'eating'),

  /// ท่าอิ่มพุงกาง — `total > target + OVER_LIMIT_THRESHOLD`
  overLimit('OVER_LIMIT', 'over_limit'),

  /// ท่าอิ่มพุงกางแต่ยังกิน — ชั่วคราว เมื่อบันทึกซ้ำขณะเกินเป้า
  overLimitFeeding('OVER_LIMIT_FEEDING', 'over_limit_feeding');

  const FoodPetState(this.code, this.keyName);

  /// รหัสใน game-rules §2
  final String code;

  /// ส่วนท้ายของ key `food_pet_image_<keyName>` (ui-spec §4)
  final String keyName;

  bool get isTransient =>
      this == FoodPetState.eating || this == FoodPetState.overLimitFeeding;
}

/// ผลโภชนาการของ 1 มื้อ (AC-1: `{"calories": 400, "high_sodium": true, "high_sugar": false}`)
class FoodNutrition {
  const FoodNutrition({
    required this.calories,
    this.highSodium = false,
    this.highSugar = false,
  });

  final int calories;
  final bool highSodium;
  final bool highSugar;

  Map<String, dynamic> toJson() => {
    'calories': calories,
    'high_sodium': highSodium,
    'high_sugar': highSugar,
  };

  @override
  bool operator ==(Object other) =>
      other is FoodNutrition &&
      other.calories == calories &&
      other.highSodium == highSodium &&
      other.highSugar == highSugar;

  @override
  int get hashCode => Object.hash(calories, highSodium, highSugar);

  @override
  String toString() => 'FoodNutrition(${toJson()})';
}

/// วันที่รูปแบบ YYYY-MM-DD (requirements §6 `date`)
String formatFoodDateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

DateTime? parseFoodDateKey(Object? raw) {
  if (raw is! String) return null;
  final d = DateTime.tryParse(raw);
  return d == null ? null : DateTime(d.year, d.month, d.day);
}

/// Log การบันทึก 1 มื้อของรอบวันปัจจุบัน (AC-3: `date` = รอบวันตามตัดรอบ 05:00)
class FoodMealEntry {
  const FoodMealEntry({
    required this.date,
    required this.loggedAt,
    required this.calories,
    this.highSodium = false,
    this.highSugar = false,
    this.manual = false,
  });

  /// รอบวัน (ตัดรอบ 05:00) — ไม่ใช่วันที่ตามปฏิทินของ [loggedAt]
  final DateTime date;
  final DateTime loggedAt;
  final int calories;
  final bool highSodium;
  final bool highSugar;

  /// true = มาจากฟอร์มกรอกเอง (EC-1)
  final bool manual;

  Map<String, dynamic> toJson() => {
    'date': formatFoodDateKey(date),
    'logged_at': loggedAt.toIso8601String(),
    'calories': calories,
    'high_sodium': highSodium,
    'high_sugar': highSugar,
    'manual': manual,
  };

  factory FoodMealEntry.fromJson(Map<String, dynamic> json) {
    final date = parseFoodDateKey(json['date']);
    final loggedAt = DateTime.tryParse(json['logged_at'] as String? ?? '');
    final calories = json['calories'];
    if (date == null || loggedAt == null || calories is! int || calories < 0) {
      throw const FormatException('invalid FoodMealEntry');
    }
    return FoodMealEntry(
      date: date,
      loggedAt: loggedAt,
      calories: calories,
      highSodium: json['high_sodium'] == true,
      highSugar: json['high_sugar'] == true,
      manual: json['manual'] == true,
    );
  }
}

/// ประวัติรายวัน (requirements §6 Food History Schema)
// ASSUMPTION: ไม่เก็บ `user_id` — ข้อมูลอยู่ในเครื่องเดียวสำหรับผู้ใช้คนเดียว (แบบ water/steps)
class DailyFoodRecord {
  const DailyFoodRecord({
    required this.date,
    required this.totalCalories,
    required this.targetCalories,
    required this.isOverTarget,
    this.highSodium = false,
    this.highSugar = false,
  });

  final DateTime date;
  final int totalCalories;

  /// null = ไม่มีเป้าหมาย (ข้ามโปรไฟล์ / โปรไฟล์ไม่ครบ)
  final int? targetCalories;

  /// `total > target + OVER_LIMIT_THRESHOLD` (false เมื่อไม่มีเป้าหมาย)
  final bool isOverTarget;
  final bool highSodium;
  final bool highSugar;

  Map<String, dynamic> toJson() => {
    'date': formatFoodDateKey(date),
    'total_calories': totalCalories,
    'target_calories': targetCalories,
    'is_over_target': isOverTarget,
    'high_sodium': highSodium,
    'high_sugar': highSugar,
  };

  factory DailyFoodRecord.fromJson(Map<String, dynamic> json) {
    final date = parseFoodDateKey(json['date']);
    final total = json['total_calories'];
    final target = json['target_calories'];
    if (date == null || total is! int || total < 0) {
      throw const FormatException('invalid DailyFoodRecord');
    }
    return DailyFoodRecord(
      date: date,
      totalCalories: total,
      targetCalories: target is int ? target : null,
      isOverTarget: json['is_over_target'] == true,
      highSodium: json['high_sodium'] == true,
      highSugar: json['high_sugar'] == true,
    );
  }
}

/// สถานะทั้งหมดของ food ที่เก็บลงเครื่อง
class FoodState {
  const FoodState({
    this.day,
    this.totalCalories = 0,
    this.meals = const [],
    this.history = const [],
    this.lastSeenAt,
    this.profileSkipped = false,
  });

  static const FoodState initial = FoodState();

  /// รอบวันปัจจุบัน (null = ยังไม่เคยเปิด)
  final DateTime? day;

  /// `total_calories` ของรอบวันปัจจุบัน
  final int totalCalories;

  /// Log มื้อของรอบวันปัจจุบัน
  final List<FoodMealEntry> meals;

  /// ประวัติรอบวันก่อนหน้า (เก่า → ใหม่) ไม่เกิน HISTORY_RETENTION_DAYS (รวมวันนี้)
  final List<DailyFoodRecord> history;

  /// เวลาล่าสุดที่ระบบเห็น (กันนาฬิกาย้อน)
  final DateTime? lastSeenAt;

  /// ผู้ใช้กด「ข้ามไปก่อน」ใน S-3 (US-3)
  final bool profileSkipped;

  bool get todayHighSodium => meals.any((m) => m.highSodium);
  bool get todayHighSugar => meals.any((m) => m.highSugar);

  FoodState copyWith({
    DateTime? day,
    int? totalCalories,
    List<FoodMealEntry>? meals,
    List<DailyFoodRecord>? history,
    DateTime? lastSeenAt,
    bool? profileSkipped,
  }) => FoodState(
    day: day ?? this.day,
    totalCalories: totalCalories ?? this.totalCalories,
    meals: meals ?? this.meals,
    history: history ?? this.history,
    lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    profileSkipped: profileSkipped ?? this.profileSkipped,
  );
}

/// ผลตรวจช่องตัวเลขของ S-3
enum FoodFieldStatus { empty, valid, invalid }

/// ผลตรวจฟอร์ม S-3 ทั้งหน้า
class FoodProfileValidation {
  const FoodProfileValidation({
    required this.age,
    required this.weight,
    required this.height,
    required this.hasGender,
  });

  final FoodFieldStatus age;
  final FoodFieldStatus weight;
  final FoodFieldStatus height;
  final bool hasGender;

  /// AC-4, EC-5 — ช่องว่างไม่แสดง error
  bool get showAgeError => age == FoodFieldStatus.invalid;

  /// ui-spec §3 S-3: ต้องครบทั้ง 4 ค่าและถูกต้อง (Q-15)
  bool get canSave =>
      age == FoodFieldStatus.valid &&
      weight == FoodFieldStatus.valid &&
      height == FoodFieldStatus.valid &&
      hasGender;
}

=== จบ app/lib/features/food/food_models.dart ===

=== app/lib/features/food/food_nutrition_parser.dart ===
/// "AI Parsing" ของเมนูอาหาร (AC-1, AC-2, EC-1)
///
/// Q-17 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน): ไม่มี AI / ไม่ต่อเน็ต — ตัวที่ใช้จริงคือ
/// [LocalMenuNutritionParser] เทียบชื่อเมนูกับตารางในเครื่อง (food_menu_table.dart)
/// แยก [FoodNutritionParser] เป็น interface ไว้ต่อ AI จริงภายหลัง และให้ QA สลับตัวปลอมได้
library;

import 'dart:convert';

import 'food_menu_table.dart';

/// ประมวลผลข้อความเมนู → JSON โภชนาการ (AC-1)
///
/// คืนสตริง JSON เช่น `{"calories": 400, "high_sodium": true, "high_sugar": false}`
/// `calories` อาจเป็นช่วง `[min, max]` (AC-2 — FoodLogic เลือก Median)
/// throw [FoodParseException] เมื่อประมวลผลไม่ได้ / ออฟไลน์ (EC-1)
/// ผู้เรียก (FoodController) จำกัดเวลาด้วย AI_PARSING_TIMEOUT
abstract class FoodNutritionParser {
  Future<String> parse(String text);
}

/// ประมวลผลไม่สำเร็จ / ออฟไลน์ (EC-1)
class FoodParseException implements Exception {
  const FoodParseException(this.message);
  final String message;
  @override
  String toString() => 'FoodParseException: $message';
}

/// ตัวประมวลผลในเครื่องจากตารางเมนู (ไม่มี network)
///
/// สำหรับ QA:
/// - [offline] = true → throw [FoodParseException] ทุกครั้ง (จำลองเน็ตหลุด EC-1)
/// - [latency] — หน่วงก่อนตอบ (เกิน AI_PARSING_TIMEOUT 3 วินาที = failure ตาม AC-1)
/// - [menu] — ใช้ตารางอื่นแทน [kFoodMenuTable]
/// flag แก้ระหว่างเทสต์ได้
class LocalMenuNutritionParser implements FoodNutritionParser {
  LocalMenuNutritionParser({
    this.offline = false,
    this.latency = Duration.zero,
    this.menu = kFoodMenuTable,
  });

  bool offline;
  Duration latency;
  List<FoodMenuItem> menu;

  /// จำนวนครั้งที่ถูกเรียก (ตรวจได้ในเทสต์)
  int callCount = 0;

  @override
  Future<String> parse(String text) async {
    callCount++;
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    if (offline) throw const FoodParseException('offline');
    return jsonEncode(nutritionJsonFor(text, menu: menu));
  }

  /// ผลแบบ synchronous (pure) — throw [FoodParseException] ถ้าไม่เจอเมนูในตาราง
  static Map<String, dynamic> nutritionJsonFor(
    String text, {
    List<FoodMenuItem> menu = kFoodMenuTable,
  }) {
    final matches = FoodMenuMatcher.match(text, menu: menu);
    if (matches.isEmpty) throw const FoodParseException('menu not found');
    var min = 0;
    var max = 0;
    for (final m in matches) {
      min += m.minKcal;
      max += m.maxKcal;
    }
    return {
      // ผลรวมเป็นช่วงเมื่อมีเมนูใดเป็นช่วง → FoodLogic ใช้ Median (AC-2)
      'calories': min == max ? min : [min, max],
      'high_sodium': matches.any((m) => m.item.highSodium),
      'high_sugar': matches.any((m) => m.item.highSugar),
    };
  }
}

=== จบ app/lib/features/food/food_nutrition_parser.dart ===

=== app/lib/features/food/food_profile_source.dart ===
/// แหล่งโปรไฟล์สุขภาพของ food — ใช้โปรไฟล์ของ signup (UserProfile / AuthRepository)
///
/// Q-13 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน): ใช้โปรไฟล์จาก signup S-6 ถ้ามีอยู่แล้ว
/// ไม่ต้องแสดง S-3 · แสดง S-3 เฉพาะตอนยังไม่มีโปรไฟล์ · S-3 บันทึกกลับเข้าโปรไฟล์ของ signup
/// (ไม่สร้างระบบโปรไฟล์ใหม่)
library;

import '../signup/signup_controller.dart';
import '../signup/signup_models.dart';
import '../signup/signup_rules.dart';

/// ค่าจากฟอร์ม S-3 ที่ผ่านการตรวจแล้ว
class FoodProfileInput {
  const FoodProfileInput({
    required this.age,
    required this.gender,
    required this.weightKg,
    required this.heightCm,
  });

  final int age;
  final SignupGender gender;
  final double weightKg;
  final double heightCm;
}

abstract class FoodProfileSource {
  /// โปรไฟล์ปัจจุบัน — null = ยังไม่มีโปรไฟล์
  Future<UserProfile?> load();

  /// บันทึกค่าจาก S-3 — คืนโปรไฟล์ที่บันทึกแล้ว หรือ null ถ้าไม่สำเร็จ
  Future<UserProfile?> save(FoodProfileInput input);
}

/// โปรไฟล์จาก [SignupController] (session ที่เข้าสู่ระบบอยู่) — ใช้ในแอปจริง
class SignupFoodProfileSource implements FoodProfileSource {
  SignupFoodProfileSource(this._signup);

  final SignupController _signup;

  @override
  Future<UserProfile?> load() async {
    if (!_signup.isLoaded) await _signup.load();
    return _signup.session?.profile;
  }

  @override
  Future<UserProfile?> save(FoodProfileInput input) async {
    final existing = _signup.session?.profile;
    // คงชื่อที่แสดง / เป้าหมายสุขภาพเดิมของ signup — food แก้เฉพาะอายุ เพศ น้ำหนัก ส่วนสูง
    final outcome = await _signup.saveProfile(
      displayName: existing == null || existing.displayNameFromEmail
          ? ''
          : existing.displayName,
      age: input.age.toString(),
      gender: input.gender,
      weight: input.weightKg.toString(),
      height: input.heightCm.toString(),
      healthGoal: existing?.healthGoal ?? SignupRules.defaultHealthGoal,
    );
    if (outcome != SaveProfileOutcome.success) return null;
    return _signup.session?.profile;
  }
}

/// โปรไฟล์ในหน่วยความจำ — ใช้ในเทสต์ และเมื่อแอปไม่มี signup (PetPalApp ไม่มี signupController)
///
/// สำหรับ QA: [profile] ค่าเริ่มต้น (null = ยังไม่มีโปรไฟล์ → S-3), [failSave] = true →
/// บันทึกไม่สำเร็จ, [latency] หน่วงทุกการเรียก
// ASSUMPTION: กรณีไม่มี signup (โหมดเดิมของเทสต์ water/steps) โปรไฟล์ไม่ถูกเก็บลงเครื่อง
// — แอปจริงผ่าน SignupGate เสมอจึงใช้ SignupFoodProfileSource
class InMemoryFoodProfileSource implements FoodProfileSource {
  InMemoryFoodProfileSource({
    this.profile,
    this.failSave = false,
    this.latency = Duration.zero,
  });

  UserProfile? profile;
  bool failSave;
  Duration latency;
  int saveCount = 0;

  @override
  Future<UserProfile?> load() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    return profile;
  }

  @override
  Future<UserProfile?> save(FoodProfileInput input) async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    if (failSave) return null;
    saveCount++;
    final existing = profile;
    return profile = UserProfile(
      displayName: existing?.displayName ?? '',
      displayNameFromEmail: existing?.displayNameFromEmail ?? false,
      age: input.age,
      gender: input.gender,
      weightKg: input.weightKg,
      heightCm: input.heightCm,
      healthGoal: existing?.healthGoal ?? SignupRules.defaultHealthGoal,
    );
  }
}

=== จบ app/lib/features/food/food_profile_source.dart ===

=== app/lib/features/food/food_repository.dart ===
/// การเก็บข้อมูล food ในเครื่อง
///
/// requirements §6 ระบุ "Database" แต่ MVP ไม่มี network/server — เก็บใน
/// shared_preferences เท่านั้น (ข้อมูลไม่ออกนอกเครื่อง)
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'food_models.dart';

/// ชื่อ key ใน shared_preferences
class FoodStorageKeys {
  FoodStorageKeys._();

  /// รอบวันปัจจุบัน YYYY-MM-DD (AC-3 `date`)
  static const String currentDay = 'food_current_day';

  /// `total_calories` ของรอบวันปัจจุบัน
  static const String totalCalories = 'food_total_calories';

  /// Log มื้อของรอบวันปัจจุบัน (JSON list ของ FoodMealEntry)
  static const String mealsLog = 'food_meals_log';

  /// ประวัติรายวัน (JSON list ของ DailyFoodRecord) ไม่เกิน HISTORY_RETENTION_DAYS
  static const String historyLog = 'food_history_log';
  static const String lastSeenAt = 'food_last_seen_at';

  /// ผู้ใช้กด「ข้ามไปก่อน」(US-3)
  static const String profileSkipped = 'food_profile_skipped';

  static const List<String> all = [
    currentDay,
    totalCalories,
    mealsLog,
    historyLog,
    lastSeenAt,
    profileSkipped,
  ];
}

class FoodStorageException implements Exception {
  const FoodStorageException(this.message);
  final String message;
  @override
  String toString() => 'FoodStorageException: $message';
}

/// interface โหลด/บันทึก — แยกไว้ให้ QA สลับเป็นตัวปลอมได้
abstract class FoodRepository {
  Future<FoodState> load();

  /// throw ถ้าบันทึกไม่สำเร็จ
  Future<void> save(FoodState state);
}

/// เก็บในหน่วยความจำ (ใช้ทดสอบ) — [failSaves] = true จำลองบันทึกไม่สำเร็จ
class InMemoryFoodRepository implements FoodRepository {
  InMemoryFoodRepository([FoodState initial = FoodState.initial])
    : _state = initial;

  FoodState _state;
  bool failSaves = false;
  int saveCount = 0;

  FoodState get stored => _state;

  @override
  Future<FoodState> load() async => _state;

  @override
  Future<void> save(FoodState state) async {
    if (failSaves) throw const FoodStorageException('simulated save failure');
    saveCount++;
    _state = state;
  }
}

/// เก็บด้วย shared_preferences
class SharedPrefsFoodRepository implements FoodRepository {
  SharedPrefsFoodRepository([Future<SharedPreferences>? prefs])
    : _prefs = prefs ?? SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefs;

  @override
  Future<FoodState> load() async {
    final SharedPreferences prefs;
    try {
      prefs = await _prefs;
    } catch (_) {
      // ASSUMPTION: อ่านข้อมูลในเครื่องไม่ได้ → เริ่มเป็นค่าว่าง แอปไม่ล่ม (แนวเดียวกับ water/steps)
      return FoodState.initial;
    }
    // ASSUMPTION: คีย์ที่เสีย/ผิดชนิด → ใช้ค่าว่างเฉพาะคีย์นั้น (แนวเดียวกับ water/steps)
    final total = _read<int>(prefs, FoodStorageKeys.totalCalories) ?? 0;
    final lastSeen = _read<String>(prefs, FoodStorageKeys.lastSeenAt);
    return FoodState(
      day: parseFoodDateKey(_read<String>(prefs, FoodStorageKeys.currentDay)),
      totalCalories: total < 0 ? 0 : total,
      meals: _decodeList(
        _read<String>(prefs, FoodStorageKeys.mealsLog),
        FoodMealEntry.fromJson,
      ),
      history: _decodeList(
        _read<String>(prefs, FoodStorageKeys.historyLog),
        DailyFoodRecord.fromJson,
      )..sort((a, b) => a.date.compareTo(b.date)),
      lastSeenAt: lastSeen == null ? null : DateTime.tryParse(lastSeen),
      profileSkipped:
          _read<bool>(prefs, FoodStorageKeys.profileSkipped) ?? false,
    );
  }

  @override
  Future<void> save(FoodState state) async {
    final SharedPreferences prefs;
    try {
      prefs = await _prefs;
    } catch (e) {
      throw FoodStorageException('cannot open storage: $e');
    }
    final results = <bool>[
      state.day == null
          ? await prefs.remove(FoodStorageKeys.currentDay)
          : await prefs.setString(
              FoodStorageKeys.currentDay,
              formatFoodDateKey(state.day!),
            ),
      await prefs.setInt(FoodStorageKeys.totalCalories, state.totalCalories),
      await prefs.setString(
        FoodStorageKeys.mealsLog,
        jsonEncode([for (final m in state.meals) m.toJson()]),
      ),
      await prefs.setString(
        FoodStorageKeys.historyLog,
        jsonEncode([for (final r in state.history) r.toJson()]),
      ),
      state.lastSeenAt == null
          ? await prefs.remove(FoodStorageKeys.lastSeenAt)
          : await prefs.setString(
              FoodStorageKeys.lastSeenAt,
              state.lastSeenAt!.toIso8601String(),
            ),
      await prefs.setBool(FoodStorageKeys.profileSkipped, state.profileSkipped),
    ];
    if (results.contains(false)) {
      throw const FoodStorageException('shared_preferences write failed');
    }
  }

  static T? _read<T>(SharedPreferences prefs, String key) {
    try {
      final v = prefs.get(key);
      return v is T ? v : null;
    } catch (_) {
      return null;
    }
  }

  static List<T> _decodeList<T>(
    String? raw,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (raw == null || raw.isEmpty) return <T>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return <T>[];
      final out = <T>[];
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          try {
            out.add(fromJson(item));
          } catch (_) {
            // ข้ามรายการที่เสีย เก็บรายการที่ยังอ่านได้
          }
        }
      }
      return out;
    } catch (_) {
      return <T>[];
    }
  }
}

=== จบ app/lib/features/food/food_repository.dart ===

=== app/lib/features/food/food_rules.dart ===
/// ค่าคงที่กติกาเกมของฟีเจอร์ food (บันทึกการให้อาหารสัตว์เลี้ยงและโภชนาการ)
///
/// ตัวเลขกติกาทุกตัวมาจาก docs/food/game-rules.md §1 (และ AC / Base Target Reference
/// Table ใน requirements.md §3) · ขนาด/ระยะของหน้าจอมาจาก docs/food/ui-spec.md §1.3
/// ข้อความบนจอมาจาก docs/food/ux-flow.md §2, §4 (ตรงตัว) / ui-spec §2 ("เสนอ — รอยืนยัน")
/// ค่าที่เอกสารไม่ได้กำหนดจะมีคอมเมนต์ ASSUMPTION กำกับ
///
/// ตารางเมนูอาหาร (kcal ต่อเมนู) แยกอยู่ที่ food_menu_table.dart — เป็นข้อมูลโภชนาการ
/// ไม่ใช่ตัวเลขกติกาเกม (Q-17 DECIDED owner ชั่วคราว)
class FoodRules {
  FoodRules._();

  // ---------------------------------------------------------------------------
  // game-rules.md §1 ค่าหลัก
  // ---------------------------------------------------------------------------

  /// AI_PARSING_TIMEOUT — รอผลประมวลผลเมนูได้นานสุด (วินาที) (AC-1)
  /// เกินเวลานี้ถือเป็น AI Parsing Failure → ฟอร์มกรอกแคลอรี่เอง (EC-1)
  static const int aiParsingTimeoutSeconds = 3;

  /// DAILY_RESET_HOUR — ตัดรอบวันใหม่ 05:00 น. (AC-3, US-5)
  // ASSUMPTION: ใช้เวลาท้องถิ่นของเครื่อง (ถือว่าเครื่องตั้งเขต ICT) แบบเดียวกับ water/steps
  // — MVP ไม่มี network/server time
  static const int dailyResetHour = 5;

  /// DAILY_RESET_HOUR — ส่วนนาทีของ 05:00 น.
  static const int dailyResetMinute = 0;

  /// AGE_MIN / AGE_MAX — อายุจำนวนเต็ม รวมขอบทั้งสองด้าน (AC-4, EC-5)
  static const int ageMin = 1;
  static const int ageMax = 120;

  // Base Target Reference Table (requirements §3, game-rules §1) — kcal
  /// MALE_BASE_TARGET_10_12 / FEMALE_BASE_TARGET_10_12
  static const int maleBaseTarget10to12 = 1700;
  static const int femaleBaseTarget10to12 = 1600;

  /// MALE_BASE_TARGET_13_15 / FEMALE_BASE_TARGET_13_15 (Growth Spurt)
  static const int maleBaseTarget13to15 = 2100;
  static const int femaleBaseTarget13to15 = 1800;

  /// MALE_BASE_TARGET_16_18 / FEMALE_BASE_TARGET_16_18
  static const int maleBaseTarget16to18 = 2300;
  static const int femaleBaseTarget16to18 = 1850;

  /// MALE_BASE_TARGET_19_50 / FEMALE_BASE_TARGET_19_50 (ผู้ใหญ่) — AC-5: ชาย 25 ปี = 2,000
  static const int maleBaseTarget19to50 = 2000;
  static const int femaleBaseTarget19to50 = 1600;

  /// MALE_BASE_TARGET_51_UP / FEMALE_BASE_TARGET_51_UP
  static const int maleBaseTarget51up = 1800;
  static const int femaleBaseTarget51up = 1400;

  /// FALLBACK_BASE_TARGET_AGE_1_9_MALE / _FEMALE — อายุ 1–9 ปีใช้ค่ากลุ่ม 10–12
  /// (game-rules §1, §5 กติกาชั่วคราวของ Design)
  static const int fallbackBaseTargetAge1to9Male = 1700;
  static const int fallbackBaseTargetAge1to9Female = 1600;

  /// ขอบล่างของแต่ละช่วงอายุในตาราง Base Target (รวมขอบ) — requirements §3
  /// 1–9 (fallback) · 10–12 · 13–15 · 16–18 · 19–50 · 51 ขึ้นไป
  static const int ageBand10to12Min = 10;
  static const int ageBand13to15Min = 13;
  static const int ageBand16to18Min = 16;
  static const int ageBand19to50Min = 19;
  static const int ageBand51upMin = 51;

  /// BMI_UNDERWEIGHT_THRESHOLD — BMI "ต่ำกว่า" ค่านี้ = ผอม (AC-6)
  static const double bmiUnderweightThreshold = 18.5;

  /// BMI_UNDERWEIGHT_BONUS — บวกเพิ่มจาก Base Target เมื่อผอม (AC-6)
  static const int bmiUnderweightBonus = 400;

  /// BMI_OVERWEIGHT_THRESHOLD — BMI "ตั้งแต่" ค่านี้ = อ้วน/น้ำหนักเกิน (AC-7)
  static const double bmiOverweightThreshold = 23.0;

  /// BMI_OVERWEIGHT_PENALTY — หักออกจาก Base Target เมื่อน้ำหนักเกิน (AC-7)
  static const int bmiOverweightPenalty = 400;

  /// OVER_LIMIT_THRESHOLD — เกินเป้า "มากกว่า" ค่านี้จึงเข้าสถานะเกินเป้า (AC-9, AC-10, EC-3)
  static const int overLimitThreshold = 100;

  /// FALLBACK_DEFAULT_CALORIES — ฟอร์มกรอกเองแต่ปล่อยว่าง (EC-1)
  static const int fallbackDefaultCalories = 300;

  /// EATING_ANIMATION_DURATION — ท่า EATING ชั่วคราว (วินาที) (game-rules §2, Brief #3)
  static const int eatingAnimationSeconds = 2;

  /// ระยะท่า OVER_LIMIT_FEEDING ก่อนกลับเป็น OVER_LIMIT (วินาที)
  // ASSUMPTION: ค่าชั่วคราว รอคำตอบ — game-rules ไม่กำหนด (ui-spec Q-3) ใช้ค่าเดียวกับ
  // EATING_ANIMATION_DURATION ตามที่ ui-spec เลือกไว้ชั่วคราว
  static const int overLimitFeedingSeconds = eatingAnimationSeconds;

  /// TOAST_DURATION — Toast ค้าง (วินาที) (AC-12)
  static const int toastSeconds = 5;

  /// TOAST_ANCHOR_OFFSET — ระยะขอบล่าง Toast ↔ ขอบบนกล่องสัตว์เลี้ยง (px) (AC-12)
  static const double toastAnchorOffset = 12;

  /// HISTORY_RETENTION_DAYS — จำนวนวันประวัติย้อนหลัง (US-1, US-5)
  // ASSUMPTION: 7 วันนับรวมรอบวันปัจจุบัน (วันนี้ + 6 วันก่อนหน้า) ให้ตรงกับโครง
  // Day 0–Day 6 ของฟีเจอร์ 7day — ประวัติที่เก่ากว่านั้นถูกลบตอนตัดรอบวัน
  static const int historyRetentionDays = 7;

  // ---------------------------------------------------------------------------
  // ui-spec §1.3 ขนาด / ระยะ (ไม่ใช่กติกาเกม — ค่าหน้าตา)
  // ---------------------------------------------------------------------------

  /// ขนาดสัตว์เลี้ยง (ui-spec §1.3 = PetCharacter default)
  static const double petSize = 160;

  /// ความสูงช่อง Toast คงที่ (ui-spec §1.3)
  static const double toastSlotHeight = 48;

  /// ความสูง "ขั้นต่ำ" ของช่องพลังงาน ใช้ร่วมกันระหว่างหลอดพลังงานและ CTA Banner
  /// (ui-spec §1.3 = 88, AC-8) — ที่ textScaler 1.0 ทั้งสองแบบพอดีใน 88 จึงสูง 88 เท่ากัน
  /// (ไม่มี layout shift) ตอนใช้จริงค่านี้ถูกคูณด้วย textScaler ของเครื่อง และช่องโตเกินได้
  /// เมื่อเนื้อหาสูงกว่านี้ (ตัวเลขยาว / ตัวอักษรใหญ่) เพื่อไม่ให้ overflow
  // DECIDED (owner ชั่วคราว, รอบแก้บั๊ก): ห้ามล็อกความสูง 88 คงที่ — ใช้เป็น min height แทน
  static const double energySlotMinHeight = 88;

  // ---------------------------------------------------------------------------
  // ค่าที่เอกสารไม่ได้กำหนด
  // ---------------------------------------------------------------------------

  // ASSUMPTION: ค่าชั่วคราว รอคำตอบ — ช่องแคลอรี่สำรองรับเลขได้ไม่เกิน 5 หลัก (≤ 99,999 kcal)
  // กัน int ล้น/ค่าเพี้ยน เอกสารไม่กำหนดค่าสูงสุด
  static const int manualCaloriesMaxDigits = 5;

  // ASSUMPTION: ค่าชั่วคราว รอคำตอบ — จำนวนที่ตามหลังชื่อเมนู (เช่น "ข้าวมันไก่ 2 จาน")
  // คูณแคลอรี่ได้สูงสุด 2 หลัก (1–99) ไม่มีในเอกสาร (Q-17 ใช้ตารางเมนูในเครื่องแทน AI)
  static const int menuQuantityMaxDigits = 2;

  // ---------------------------------------------------------------------------
  // ข้อความบนหน้าจอ (ux-flow.md §2, §4 ตรงตัว / ui-spec "เสนอ — รอยืนยัน")
  // ---------------------------------------------------------------------------

  static const String kcalUnit = 'kcal';
  static const String backButtonText =
      'ย้อนกลับ'; // ui-spec §2.2 (เท่า steps/signup)

  // ทางเข้าจากหน้า water (ui-spec §2.0)
  // ASSUMPTION: ui-spec Q-1 (เสนอ — รอยืนยัน)
  static const String entryTooltip = 'โภชนาการ';

  // S-1
  // ASSUMPTION: ui-spec Q-2 (เสนอ — รอยืนยัน)
  static const String dashboardTitle = 'โภชนาการ';
  static const String addMealButtonText = 'บันทึกมื้ออาหาร';
  static const String fullBadgeText = 'อิ่มแล้ว';
  static const String overLimitToastText = 'พอเถอะน้าคนดี';
  static const String profileCtaText =
      'ตั้งค่าโปรไฟล์สุขภาพเพื่อรับเป้าหมายแคลอรี่ที่แม่นยำ';

  // S-2
  // ASSUMPTION: ui-spec Q-2 (เสนอ — ยืมข้อความปุ่ม S-1)
  static const String mealTitle = addMealButtonText;
  static const String mealInputHint =
      'พิมพ์เมนูอาหารที่คุณทานวันนี้ เช่น ข้าวมันไก่ 1 จาน...';
  static const String manualCalorieHint = 'ระบุแคลอรี่ (kcal)';
  // ASSUMPTION: ui-spec Q-10 (เสนอ — รอยืนยัน)
  static const String manualCalorieHelper =
      'ไม่สามารถประมวลผลเมนูอัตโนมัติได้ กรุณาระบุแคลอรี่เอง';
  static const String mealSubmitText = 'บันทึกข้อมูล';

  // S-3
  // ASSUMPTION: ui-spec Q-2 (เสนอ — รอยืนยัน)
  static const String profileTitle = 'ตั้งค่าโปรไฟล์สุขภาพ';
  static const String ageHint = 'ระบุอายุ (ปี)';
  // ASSUMPTION: ui-spec Q-15 (เสนอ — ข้อความเดียวกับ signup_gender_label)
  static const String genderLabel = 'เพศ';
  static const String genderMaleText = 'ชาย';
  static const String genderFemaleText = 'หญิง';
  static const String weightHint = 'น้ำหนัก (kg)';
  static const String heightHint = 'ส่วนสูง (cm)';
  static const String profileSaveText = 'บันทึกและคำนวณเป้าหมาย';
  static const String profileSkipText = 'ข้ามไปก่อน';

  /// ux-flow §4 S-3 Error — ตัวเลขมาจาก AGE_MIN / AGE_MAX
  static String get ageError =>
      'กรุณากรอกอายุเป็นจำนวนเต็มระหว่าง $ageMin - $ageMax ปี';
}

=== จบ app/lib/features/food/food_rules.dart ===

=== app/lib/features/food/screens/food_dashboard_screen.dart ===
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:petpal_health/shared/pet/pet.dart';

import '../food_controller.dart';
import '../food_logic.dart';
import '../food_rules.dart';
import '../widgets/food_profile_cta_banner.dart';
import '../widgets/food_shared_min_height_box.dart';
import '../widgets/food_toast.dart';
import 'food_meal_screen.dart';
import 'food_profile_screen.dart';

/// S-1 หน้าหลักแดชบอร์ดสัตว์เลี้ยงและโภชนาการ — ux-flow §2 S-1, ui-spec §2.1
/// AC-8, AC-9, AC-10, AC-11, AC-12, EC-2, EC-3, EC-4
class FoodDashboardScreen extends StatefulWidget {
  const FoodDashboardScreen({
    super.key,
    required this.controller,
    this.animatePet,
  });

  final FoodController controller;

  /// `PetCharacter.animate` — null = [kPetAnimateByDefault] (แอปจริง animate,
  /// ระหว่าง flutter test เป็นภาพนิ่ง)
  final bool? animatePet;

  @override
  State<FoodDashboardScreen> createState() => _FoodDashboardScreenState();
}

class _FoodDashboardScreenState extends State<FoodDashboardScreen>
    with WidgetsBindingObserver {
  // PetCharacter มีตัวตนคงที่ข้ามการเปลี่ยนสถานะ (BUG-PET-1) — key ฟีเจอร์อยู่บน KeyedSubtree
  final GlobalKey _petKey = GlobalKey(debugLabel: 'food_pet');

  // ASSUMPTION: ตรวจรอบวันทุก 1 วินาทีขณะเปิดหน้าค้าง (game-rules §4 Foreground Crossing)
  // เอกสารไม่กำหนดความถี่ — แบบเดียวกับ steps
  static const Duration _dayCheckInterval = Duration(seconds: 1);

  Timer? _dayTimer;
  bool _profilePrompted = false;

  FoodController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.addListener(_maybePromptProfile);
    if (!_controller.isLoaded) {
      _controller.load();
    } else {
      _controller.refreshDay();
      _controller.refreshProfile();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _maybePromptProfile(),
      );
    }
    _dayTimer = Timer.periodic(
      _dayCheckInterval,
      (_) => _controller.refreshDay(),
    );
  }

  @override
  void dispose() {
    _dayTimer?.cancel();
    _controller.removeListener(_maybePromptProfile);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _controller.refreshDay();
  }

  /// Q-13 DECIDED: ยังไม่มีโปรไฟล์ (และยังไม่เคยกดข้าม) → เปิด S-3 ให้ 1 ครั้งต่อการเข้าหน้า
  void _maybePromptProfile() {
    if (_profilePrompted || !mounted || !_controller.needsProfileSetup) return;
    _profilePrompted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _openProfile();
    });
  }

  void _openMeal() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FoodMealScreen(controller: _controller),
      ),
    );
  }

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FoodProfileScreen(controller: _controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text(
            FoodRules.dashboardTitle,
            key: Key('food_header_text'),
          ),
        ),
        body: !_controller.isLoaded
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final petState = _controller.petState;
    final toast = _controller.toastMessage;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    // #3 ช่อง Toast สูงคงที่ — Toast ไม่ดันสัตว์เลี้ยง (AC-12)
                    SizedBox(
                      key: const Key('food_toast_slot'),
                      height: FoodRules.toastSlotHeight,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: toast == null
                            ? const SizedBox.shrink()
                            // ValueKey ตาม serial: ข้อความใหม่แทนที่อันเดิมทันที (EC-2)
                            : KeyedSubtree(
                                key: ValueKey(
                                  'food_toast_${_controller.toastSerial}',
                                ),
                                child: FoodToast(message: toast),
                              ),
                      ),
                    ),
                    // #4 ระยะ anchor = TOAST_ANCHOR_OFFSET (AC-12)
                    const SizedBox(height: FoodRules.toastAnchorOffset),
                    // #5 สัตว์เลี้ยง — OQ-1 DECIDED: PetCharacter แทน Lottie/PNG
                    // ไม่ส่ง cheerTrigger (ท่ากินคือ reaction — ui-spec §4)
                    Center(
                      child: KeyedSubtree(
                        key: ValueKey('food_pet_image_${petState.keyName}'),
                        child: PetCharacter(
                          key: _petKey,
                          pose: _controller.petPose,
                          size: FoodRules.petSize,
                          animate: widget.animatePet ?? kPetAnimateByDefault,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // #7 ป้าย「อิ่มแล้ว」 — Q-5 DECIDED: ขึ้นพร้อมหลอดแดงทันที
                    Center(
                      child: Visibility(
                        key: const Key('food_full_badge_visibility'),
                        visible: _controller.showsFullBadge,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: Container(
                          key: const Key('food_full_badge'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            FoodRules.fullBadgeText,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: scheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // #9 ช่องพลังงาน — หลอดหรือ CTA Banner (AC-8, EC-4)
                    // ไม่ล็อกความสูงตายตัว (แก้บั๊ก overflow บนจอ 360 dp): ช่องสูงอย่างน้อย
                    // max(88, ความสูงที่หลอดต้องใช้, ความสูงที่ CTA ต้องใช้) ที่ความกว้าง/ฟอนต์/
                    // textScaler จริง → สองแบบสูงเท่ากันเสมอ (ไม่มี layout shift ตอนสลับ) และ
                    // ถ้าเนื้อหาจริงสูงกว่าที่วัดได้ ช่องก็โตตามได้ ไม่ overflow
                    FoodSharedMinHeightBox(
                      key: const Key('food_energy_slot'),
                      minHeightFor: _energySlotMinHeightFor(context),
                      child: _controller.showsProfileCta
                          ? _buildCtaBanner(context)
                          : _buildEnergyBlock(context),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      key: const Key('food_add_meal_button'),
                      onPressed: _openMeal,
                      icon: const Icon(Icons.restaurant, size: 24),
                      label: const Text(FoodRules.addMealButtonText),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ขนาดภายในช่องพลังงาน (ui-spec §1.3 / §2.1 #9a, #9b) — ใช้ทั้งตอนสร้าง widget และตอนวัด
  // ความสูงขั้นต่ำร่วม เพื่อให้สองที่ตรงกันเสมอ
  static const double _barHeight = 20;
  static const double _barTextGap = 8;
  static const double _ctaPadH = FoodProfileCtaBanner.padH;
  static const double _ctaPadV = FoodProfileCtaBanner.padV;
  static const double _ctaIconGap = FoodProfileCtaBanner.iconGap;
  static const double _ctaIconSize = FoodProfileCtaBanner.iconSize;

  // ASSUMPTION: ตอนแสดง CTA (ยังไม่มีเป้า) จองที่ให้ข้อความหลอดด้วยเป้าตัวแทน 4 หลัก
  // "9,999" ซึ่งกว้างไม่น้อยกว่าเป้าจริงทุกค่า (ตาราง Base Target + BMI สูงสุด 2,700) — เพื่อให้
  // ตอนตั้งโปรไฟล์แล้วสลับเป็นหลอดไม่เกิด layout shift · เป็นค่าหน้าตา ไม่ใช่ตัวเลขกติกา
  static const int _placeholderTarget = 9999;

  /// ความสูงขั้นต่ำร่วมของช่องพลังงาน = max(88, หลอด, CTA) ที่ความกว้าง [width] — AC-8
  MinHeightForWidth _energySlotMinHeightFor(BuildContext context) {
    final theme = Theme.of(context);
    final base = DefaultTextStyle.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    final locale = Localizations.maybeLocaleOf(context);
    final barText =
        _controller.calorieText ??
        FoodLogic.calorieText(_controller.totalCalories, _placeholderTarget);
    final ctaTotal = _controller.ctaTotalText;

    double textHeight(
      String text,
      TextStyle? style,
      double maxWidth, {
      int? maxLines,
      TextAlign align = TextAlign.start,
    }) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: base.style.merge(style)),
        textAlign: align,
        textDirection: direction,
        textScaler: scaler,
        maxLines: maxLines,
        ellipsis: maxLines == null ? null : '…',
        locale: locale,
        textHeightBehavior: base.textHeightBehavior,
        textWidthBasis: base.textWidthBasis,
      )..layout(maxWidth: math.max(0, maxWidth));
      final h = painter.height;
      painter.dispose();
      return h;
    }

    return (width) {
      final bar =
          _barHeight +
          _barTextGap +
          textHeight(
            barText,
            theme.textTheme.headlineSmall,
            width,
            align: TextAlign.center,
          );
      final ctaTextWidth = width - _ctaPadH * 2 - _ctaIconGap - _ctaIconSize;
      final ctaTexts =
          textHeight(
            FoodRules.profileCtaText,
            theme.textTheme.bodyMedium,
            ctaTextWidth,
            maxLines: 2,
          ) +
          textHeight(
            // BUG-FOOD-2 (D-5): ยอดรวมไม่จำกัดบรรทัด — วัดแบบเดียวกับ widget
            ctaTotal,
            theme.textTheme.titleMedium,
            ctaTextWidth,
          );
      final cta = _ctaPadV * 2 + math.max(ctaTexts, _ctaIconSize);
      return math.max(FoodRules.energySlotMinHeight, math.max(bar, cta));
    };
  }

  /// #9a หลอดพลังงาน (มีโปรไฟล์) — AC-9 / AC-10
  Widget _buildEnergyBlock(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      key: const Key('food_energy_block'),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            key: const Key('food_energy_bar'),
            value: _controller.energyFraction,
            minHeight: _barHeight,
            color: _controller.isOverLimit ? scheme.error : scheme.primary,
          ),
        ),
        const SizedBox(height: _barTextGap),
        Text(
          _controller.calorieText ?? '',
          key: const Key('food_calorie_text'),
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
      ],
    );
  }

  /// #9b CTA Banner (ข้ามโปรไฟล์ / ไม่มีเป้าหมาย) — กว้าง×สูงเต็มช่องพลังงาน (AC-8)
  /// กว้างเต็มเพราะ Column หน้า S-1 เป็น stretch · สูงอย่างน้อยเท่าขั้นต่ำของช่อง
  /// (min height จาก ConstrainedBox ของช่อง) และโตตามเนื้อหาได้ — แทน SizedBox.expand
  /// ที่ใช้ไม่ได้เมื่อช่องไม่มีความสูงตายตัว
  Widget _buildCtaBanner(BuildContext context) => FoodProfileCtaBanner(
    totalText: _controller.ctaTotalText,
    onTap: _openProfile,
  );

}

=== จบ app/lib/features/food/screens/food_dashboard_screen.dart ===

=== app/lib/features/food/screens/food_meal_screen.dart ===
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../signup/widgets/signup_widgets.dart'
    show SignupButtonLabel, SignupWarningText;
import '../food_controller.dart';
import '../food_rules.dart';

/// S-2 หน้าจอเพิ่มเมนูอาหาร — ux-flow §2 S-2, ui-spec §2.2
/// AC-1, AC-2 (ผ่าน FoodController / FoodLogic), AC-3, EC-1
class FoodMealScreen extends StatefulWidget {
  const FoodMealScreen({super.key, required this.controller});

  final FoodController controller;

  @override
  State<FoodMealScreen> createState() => _FoodMealScreenState();
}

class _FoodMealScreenState extends State<FoodMealScreen> {
  final TextEditingController _menu = TextEditingController();
  final TextEditingController _manual = TextEditingController();

  /// S-2 Error / Offline (EC-1) — แสดงช่องกรอกแคลอรี่สำรอง
  bool _fallback = false;

  /// กำลังประมวลผล (ui-spec Q-11)
  bool _loading = false;

  @override
  void dispose() {
    _menu.dispose();
    _manual.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    setState(() => _loading = true);
    // ASSUMPTION: ในสถานะผิดพลาด/ออฟไลน์ กดบันทึก = บันทึกค่าที่กรอกเอง (ว่าง = 300 kcal)
    // ไม่ส่งข้อความเมนูไปประมวลผลซ้ำ (ux-flow S-2 "หรือบันทึกค่า Manual หากออฟไลน์")
    final outcome = _fallback
        ? await widget.controller.submitManual(_manual.text)
        : await widget.controller.submitMeal(_menu.text);
    if (!mounted) return;
    switch (outcome) {
      case MealSubmitOutcome.logged:
        // ux-flow S-2: กลับ S-1 (S-1 แสดงท่ากิน) — ไม่มีข้อความยืนยัน
        Navigator.of(context).pop();
        return;
      case MealSubmitOutcome.parseFailed:
        setState(() {
          _loading = false;
          _fallback = true;
        });
      case MealSubmitOutcome.invalidCalories:
      case MealSubmitOutcome.notReady:
        setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = !_loading;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('food_meal_back_button'),
          icon: const Icon(Icons.arrow_back),
          tooltip: FoodRules.backButtonText,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          FoodRules.mealTitle,
          key: Key('food_meal_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('food_meal_input_field'),
                controller: _menu,
                enabled: enabled,
                minLines: 3,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: FoodRules.mealInputHint,
                ),
              ),
              if (_fallback) ...[
                const SizedBox(height: 16),
                // EC-1: ช่องว่างเปล่า (ไม่เติม 300) — ค่า default ใช้ตอนบันทึก
                TextField(
                  key: const Key('food_manual_calorie_field'),
                  controller: _manual,
                  enabled: enabled,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    // ASSUMPTION: จำกัดจำนวนหลัก (FoodRules.manualCaloriesMaxDigits)
                    LengthLimitingTextInputFormatter(
                      FoodRules.manualCaloriesMaxDigits,
                    ),
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: FoodRules.manualCalorieHint,
                    helper: SignupWarningText(
                      FoodRules.manualCalorieHelper,
                      key: Key('food_manual_calorie_helper_text'),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('food_meal_submit_button'),
                onPressed: enabled ? _submit : null,
                child: SignupButtonLabel(
                  text: FoodRules.mealSubmitText,
                  loading: _loading,
                  indicatorKey: 'food_meal_submit_loading_indicator',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/food/screens/food_meal_screen.dart ===

=== app/lib/features/food/screens/food_profile_screen.dart ===
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../signup/signup_models.dart' show SignupGender;
import '../../signup/widgets/signup_widgets.dart'
    show SignupButtonLabel, SignupWholeNumberInputFormatter;
import '../food_controller.dart';
import '../food_logic.dart';
import '../food_rules.dart';

/// S-3 หน้าจอตั้งค่าโปรไฟล์สุขภาพเบื้องต้น — ux-flow §2 S-3, ui-spec §2.3
/// AC-4, AC-5, AC-6, AC-7 (ผ่าน FoodLogic), EC-5, US-3
///
/// Q-13 DECIDED: บันทึกเข้าโปรไฟล์ของ signup · Q-14 DECIDED: กติกาเดียวกับ signup —
/// อายุรับจำนวนเต็มเท่านั้น (ปฏิเสธการพิมพ์จุด), น้ำหนัก/ส่วนสูงรับทศนิยม
class FoodProfileScreen extends StatefulWidget {
  const FoodProfileScreen({super.key, required this.controller});

  final FoodController controller;

  @override
  State<FoodProfileScreen> createState() => _FoodProfileScreenState();
}

class _FoodProfileScreenState extends State<FoodProfileScreen> {
  late final TextEditingController _age;
  late final TextEditingController _weight;
  late final TextEditingController _height;
  SignupGender? _gender;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // ASSUMPTION: มีโปรไฟล์ signup แต่ไม่ครบ (เช่น เพศไม่ระบุ / ไม่มีน้ำหนัก) แล้วกด CTA →
    // เติมค่าเดิมไว้ในฟอร์ม (แบบ signup S-6) · ไม่มีโปรไฟล์ = ฟอร์มว่าง ไม่เลือกเพศไว้ก่อน
    final p = widget.controller.profile;
    _age = TextEditingController(text: p?.age.toString() ?? '');
    _weight = TextEditingController(text: _fmt(p?.weightKg));
    _height = TextEditingController(text: _fmt(p?.heightCm));
    final g = p?.gender;
    _gender = g == SignupGender.male || g == SignupGender.female ? g : null;
  }

  static String _fmt(double? v) {
    if (v == null) return '';
    return v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
  }

  @override
  void dispose() {
    _age.dispose();
    _weight.dispose();
    _height.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final outcome = await widget.controller.saveProfile(
      age: _age.text,
      gender: _gender,
      weight: _weight.text,
      height: _height.text,
    );
    if (!mounted) return;
    if (outcome == FoodProfileSaveOutcome.saved) {
      Navigator.of(context).pop();
      return;
    }
    // ASSUMPTION: บันทึกไม่สำเร็จ — ux-flow ไม่มีสถานะ error ของ S-3 → อยู่หน้าเดิม ค่าคงเดิม
    // กดบันทึกซ้ำได้ (ไม่แสดงข้อความใหม่)
    setState(() => _saving = false);
  }

  Future<void> _skip() async {
    await widget.controller.skipProfile();
    if (mounted) Navigator.of(context).pop();
  }

  void _onChanged(String _) => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final v = FoodLogic.validateProfile(
      age: _age.text,
      gender: _gender,
      weight: _weight.text,
      height: _height.text,
    );
    final enabled = !_saving;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          FoodRules.profileTitle,
          key: Key('food_profile_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('food_age_field'),
                controller: _age,
                enabled: enabled,
                keyboardType: TextInputType.number,
                // Q-14 DECIDED (owner): กติกาเดียวกับ signup — ปฏิเสธการพิมพ์/วางที่ไม่ใช่
                // เลขล้วน ("20.5" ไม่เข้าช่อง) แทนตัวกรอง [0-9.] ของ ui-spec §2.3 #2
                inputFormatters: [
                  const SignupWholeNumberInputFormatter(),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: _onChanged,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: FoodRules.ageHint,
                  // AC-4, EC-5: ไม่ใช่จำนวนเต็ม 1–120 → error + บล็อกการบันทึก
                  error: v.showAgeError
                      ? Text(
                          FoodRules.ageError,
                          key: const Key('food_age_error_text'),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                FoodRules.genderLabel,
                key: const Key('food_gender_label'),
                style: theme.textTheme.titleMedium,
              ),
              RadioGroup<SignupGender>(
                key: const Key('food_gender_group'),
                groupValue: _gender,
                onChanged: (g) {
                  if (g == null || !enabled) return;
                  setState(() => _gender = g);
                },
                child: Column(
                  children: [
                    RadioListTile<SignupGender>(
                      key: const Key('food_gender_male'),
                      value: SignupGender.male,
                      enabled: enabled,
                      contentPadding: EdgeInsets.zero,
                      title: const Text(FoodRules.genderMaleText),
                    ),
                    RadioListTile<SignupGender>(
                      key: const Key('food_gender_female'),
                      value: SignupGender.female,
                      enabled: enabled,
                      contentPadding: EdgeInsets.zero,
                      title: const Text(FoodRules.genderFemaleText),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('food_weight_field'),
                controller: _weight,
                enabled: enabled,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: _onChanged,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: FoodRules.weightHint,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('food_height_field'),
                controller: _height,
                enabled: enabled,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: _onChanged,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: FoodRules.heightHint,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('food_profile_save_button'),
                onPressed: enabled && v.canSave ? _save : null,
                // ASSUMPTION: ระหว่างบันทึกแสดง spinner ในปุ่มแบบ signup (ui-spec ไม่ระบุ loading)
                child: SignupButtonLabel(
                  text: FoodRules.profileSaveText,
                  loading: _saving,
                  indicatorKey: 'food_profile_save_loading_indicator',
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  key: const Key('food_profile_skip_button'),
                  // ui-spec §3 S-3: enabled เสมอ
                  onPressed: _skip,
                  child: const Text(FoodRules.profileSkipText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/food/screens/food_profile_screen.dart ===

=== app/lib/features/food/widgets/food_profile_cta_banner.dart ===
import 'package:flutter/material.dart';

import '../food_rules.dart';

/// CTA Banner ชวนตั้งโปรไฟล์ (food ui-spec §2.1 #9b, AC-8, EC-4) — แยกจาก
/// FoodDashboardScreen เพื่อใช้ซ้ำบน S-1 ของ dashboard (owner รอบ 3 ข้อ 5)
/// widget tree / keys / สไตล์ เหมือนเดิมทุกอย่าง (`food_profile_cta_banner`, `food_cta_text`,
/// `food_cta_total_text`)
class FoodProfileCtaBanner extends StatelessWidget {
  const FoodProfileCtaBanner({
    super.key,
    required this.totalText,
    required this.onTap,
  });

  /// ยอดรวมวันนี้ (FoodController.ctaTotalText)
  final String totalText;

  /// เปิด S-3 ตั้งโปรไฟล์
  final VoidCallback onTap;

  static const double padH = 16;
  static const double padV = 8;
  static const double iconGap = 8;
  static const double iconSize = 24;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fg = scheme.onSecondaryContainer;
    return Material(
      color: scheme.secondaryContainer,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        key: const Key('food_profile_cta_banner'),
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padH, vertical: padV),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FoodRules.profileCtaText,
                      key: const Key('food_cta_text'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(color: fg),
                    ),
                    Text(
                      totalText,
                      key: const Key('food_cta_total_text'),
                      // BUG-FOOD-2 (DECIDED D-5): ยอดรวมต้องแสดงครบ ห้ามตัด — ขึ้นบรรทัด
                      // ใหม่ได้ (ช่องโตตาม) · ellipsis ใช้เฉพาะข้อความชวนตาม ui-spec #9b
                      style: theme.textTheme.titleMedium?.copyWith(color: fg),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: iconGap),
              Icon(Icons.chevron_right, size: iconSize, color: fg),
            ],
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/food/widgets/food_profile_cta_banner.dart ===

=== app/lib/features/food/widgets/food_shared_min_height_box.dart ===
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// คำนวณความสูงขั้นต่ำจากความกว้างที่ได้รับจริงตอนจัด layout
typedef MinHeightForWidth = double Function(double width);

/// กล่องที่ให้ลูกสูง "อย่างน้อย" [minHeightFor] (คำนวณจากความกว้างจริง) แล้วโตต่อได้
/// ตามเนื้อหา — ใช้กับช่องพลังงาน S-1 (AC-8) เพื่อให้หลอดพลังงานและ CTA Banner ใช้
/// ความสูงขั้นต่ำร่วมกัน (ค่ามากสุดของทั้งสองแบบ) โดยไม่ต้องล็อกความสูงตายตัว
///
/// ต่างจาก LayoutBuilder ตรงที่รองรับ intrinsic size (หน้า S-1 ครอบด้วย IntrinsicHeight)
class FoodSharedMinHeightBox extends SingleChildRenderObjectWidget {
  const FoodSharedMinHeightBox({
    super.key,
    required this.minHeightFor,
    super.child,
  });

  final MinHeightForWidth minHeightFor;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderFoodSharedMinHeightBox(minHeightFor);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderFoodSharedMinHeightBox renderObject,
  ) {
    renderObject.minHeightFor = minHeightFor;
  }
}

/// RenderObject ของ [FoodSharedMinHeightBox]
class RenderFoodSharedMinHeightBox extends RenderProxyBox {
  RenderFoodSharedMinHeightBox(this._minHeightFor);

  MinHeightForWidth _minHeightFor;
  set minHeightFor(MinHeightForWidth value) {
    if (identical(value, _minHeightFor)) return;
    _minHeightFor = value;
    // closure ใหม่ทุก build (ข้อความ/สไตล์อาจเปลี่ยน) — วัดใหม่เสมอ
    markNeedsLayout();
  }

  BoxConstraints _withMin(BoxConstraints c) {
    final minH = math.max(c.minHeight, _minHeightFor(c.maxWidth));
    return c.copyWith(minHeight: math.min(minH, c.maxHeight));
  }

  @override
  double computeMinIntrinsicHeight(double width) =>
      math.max(_minHeightFor(width), super.computeMinIntrinsicHeight(width));

  @override
  double computeMaxIntrinsicHeight(double width) =>
      math.max(_minHeightFor(width), super.computeMaxIntrinsicHeight(width));

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    final c = _withMin(constraints);
    return child?.getDryLayout(c) ?? c.smallest;
  }

  @override
  void performLayout() {
    final c = _withMin(constraints);
    final child = this.child;
    if (child == null) {
      size = c.smallest;
      return;
    }
    child.layout(c, parentUsesSize: true);
    size = child.size;
  }
}

=== จบ app/lib/features/food/widgets/food_shared_min_height_box.dart ===

=== app/lib/features/food/widgets/food_toast.dart ===
import 'package:flutter/material.dart';

import '../food_rules.dart';

/// Toast ลอยเหนือสัตว์เลี้ยง (ui-spec §2.1.1) — ไม่ใช่ SnackBar เพราะต้องยึดตำแหน่งกับ
/// สัตว์เลี้ยง (AC-12) · สี inverseSurface / onInverseSurface เท่า SnackBar M3
class FoodToast extends StatelessWidget {
  const FoodToast({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Material(
      key: const Key('food_toast'),
      color: scheme.inverseSurface,
      elevation: 6,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          message,
          key: message == FoodRules.overLimitToastText
              ? const Key('food_over_limit_toast')
              : null,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onInverseSurface,
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/food/widgets/food_toast.dart ===

=== app/lib/features/signup/screens/signup_email_screen.dart ===
import 'package:flutter/material.dart';

import '../signup_controller.dart';
import '../signup_logic.dart';
import '../signup_rules.dart';
import '../widgets/signup_widgets.dart';
import 'signup_forgot_password_screen.dart';
import 'signup_gate.dart';

/// S-2 มี 2 โหมด (ui-spec Q-2)
enum SignupEmailMode { signUp, signIn }

/// S-2 หน้าสมัครสมาชิก / เข้าสู่ระบบด้วยอีเมล (ux-flow §2 S-2, ui-spec §2.2)
class SignupEmailScreen extends StatefulWidget {
  const SignupEmailScreen({
    super.key,
    required this.controller,
    this.mode = SignupEmailMode.signUp,
  });

  final SignupController controller;
  final SignupEmailMode mode;

  @override
  State<SignupEmailScreen> createState() => _SignupEmailScreenState();
}

class _SignupEmailScreenState extends State<SignupEmailScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _submitting = false;

  /// AC-2 / EC-5 — หายเมื่อแก้ข้อความในช่องอีเมล (ui-spec Q-4)
  bool _emailInUse = false;

  /// โหมดเข้าสู่ระบบ: อีเมล/รหัสผ่านไม่ตรง — หายเมื่อแก้ช่องใดช่องหนึ่ง
  bool _invalidCredentials = false;

  bool get _isSignUp => widget.mode == SignupEmailMode.signUp;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    if (_submitting || !SignupLogic.canSubmitCredentials(email, password)) {
      return;
    }
    setState(() => _submitting = true);
    final outcome = _isSignUp
        ? await widget.controller.signUpWithEmail(email, password)
        : await widget.controller.signInWithEmail(email, password);
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _emailInUse = outcome == EmailAuthOutcome.emailInUse;
      _invalidCredentials = outcome == EmailAuthOutcome.invalidCredentials;
    });
    switch (outcome) {
      case EmailAuthOutcome.success:
        // สมัครสำเร็จ → S-6 (ux-flow §3 ข้อ 4); เข้าสู่ระบบ → S-6/S-7 ตามโปรไฟล์ (Q-21)
        popToSignupRoot(context);
      case EmailAuthOutcome.networkError:
        // ASSUMPTION: ux-flow ไม่มีสถานะเน็ตหลุดของ S-2 — ใช้ dialog เดียวกับ EC-1/EC-4
        final retry = await showSignupNetworkErrorDialog(
          context,
          dialogKey: 'signup_email_error_dialog',
          retryKey: 'signup_email_retry_button',
        );
        if (retry && mounted) await _submit();
      case EmailAuthOutcome.emailInUse:
      case EmailAuthOutcome.invalidCredentials:
        break;
    }
  }

  void _openForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            SignupForgotPasswordScreen(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = _emailController.text;
    final password = _passwordController.text;
    final canSubmit =
        !_submitting && SignupLogic.canSubmitCredentials(email, password);

    Widget? passwordError;
    if (SignupLogic.showsPasswordError(password)) {
      passwordError = const Text(
        SignupRules.passwordTooShortError,
        key: Key('signup_password_error_text'),
      );
    } else if (_invalidCredentials) {
      passwordError = const Text(
        SignupRules.invalidCredentialsError,
        key: Key('signup_login_error_text'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('signup_email_back_button'),
          icon: const Icon(Icons.arrow_back),
          tooltip: SignupRules.backButtonText,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          _isSignUp ? SignupRules.signupHeader : SignupRules.loginHeader,
          key: const Key('signup_email_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('signup_email_field'),
                controller: _emailController,
                enabled: !_submitting,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                onChanged: (_) => setState(() {
                  _emailInUse = false;
                  _invalidCredentials = false;
                }),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.emailHint,
                  error: _isSignUp && _emailInUse
                      ? const Text(
                          SignupRules.emailInUseError,
                          key: Key('signup_email_duplicate_error_text'),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_password_field'),
                controller: _passwordController,
                enabled: !_submitting,
                obscureText: true,
                onChanged: (_) => setState(() => _invalidCredentials = false),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.passwordHint,
                  error: passwordError,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('signup_submit_button'),
                onPressed: canSubmit ? _submit : null,
                child: SignupButtonLabel(
                  text: _isSignUp
                      ? SignupRules.signupSubmitText
                      : SignupRules.loginSubmitText,
                  loading: _submitting,
                  indicatorKey: 'signup_submit_loading_indicator',
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  key: const Key('signup_forgot_password_link'),
                  onPressed: _submitting ? null : _openForgotPassword,
                  child: const Text(SignupRules.forgotPasswordLinkText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/signup/screens/signup_email_screen.dart ===

=== app/lib/features/signup/screens/signup_forgot_password_screen.dart ===
import 'package:flutter/material.dart';

import '../signup_controller.dart';
import '../signup_rules.dart';
import '../widgets/signup_widgets.dart';
import 'signup_reset_sent_screen.dart';

/// S-3 หน้าลืมรหัสผ่าน (ux-flow §2 S-3, ui-spec §2.3)
class SignupForgotPasswordScreen extends StatefulWidget {
  const SignupForgotPasswordScreen({super.key, required this.controller});

  final SignupController controller;

  @override
  State<SignupForgotPasswordScreen> createState() =>
      _SignupForgotPasswordScreenState();
}

class _SignupForgotPasswordScreenState
    extends State<SignupForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // ASSUMPTION: ui-spec Q-7 — ปุ่มกดได้เสมอ (รวมช่องว่าง) และไม่มีสถานะ error;
  // FakeAuthRepository ตอบสำเร็จเสมอแล้วไป S-4
  Future<void> _submit() async {
    if (_sending) return;
    setState(() => _sending = true);
    try {
      await widget.controller.requestPasswordReset(_emailController.text);
    } catch (_) {
      // ไม่มีหน้าตา error ใน ux-flow — ไปต่อที่ S-4 เหมือนสำเร็จ
    }
    if (!mounted) return;
    setState(() => _sending = false);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SignupResetSentScreen(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('signup_forgot_back_button'),
          icon: const Icon(Icons.arrow_back),
          tooltip: SignupRules.backButtonText,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          SignupRules.forgotHeader,
          key: Key('signup_forgot_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                SignupRules.forgotDescription,
                key: Key('signup_forgot_description_text'),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_forgot_email_field'),
                controller: _emailController,
                enabled: !_sending,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: SignupRules.emailHint,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('signup_forgot_submit_button'),
                onPressed: _sending ? null : _submit,
                child: SignupButtonLabel(
                  text: SignupRules.forgotSubmitText,
                  loading: _sending,
                  indicatorKey: 'signup_forgot_loading_indicator',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/signup/screens/signup_forgot_password_screen.dart ===

=== app/lib/features/signup/screens/signup_gate.dart ===
import 'package:flutter/material.dart';

import '../signup_controller.dart';
import '../signup_logic.dart';
import 'signup_onboarding_screen.dart';
import 'signup_welcome_screen.dart';

/// สร้างหน้า S-7 (Home) — [welcomeName] = Display Name ที่ประมวลผลแล้ว (AC-5)
typedef SignupHomeBuilder = Widget Function(
    BuildContext context, String? welcomeName);

/// จุดเริ่มของแอป: อ่าน Token แล้วเลือก S-1 / S-6 / S-7 (ui-spec §2.0, AC-8)
///
/// หน้าราก (root route) เปลี่ยนตาม [SignupController.route]; หน้าที่ push ซ้อน
/// (S-2…S-5) เมื่อเข้าสู่ระบบสำเร็จจะ pop กลับมาที่รากเอง
class SignupGate extends StatefulWidget {
  const SignupGate({
    super.key,
    required this.controller,
    required this.homeBuilder,
  });

  final SignupController controller;
  final SignupHomeBuilder homeBuilder;

  @override
  State<SignupGate> createState() => _SignupGateState();
}

class _SignupGateState extends State<SignupGate> {
  @override
  void initState() {
    super.initState();
    if (!widget.controller.isLoaded) widget.controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        switch (widget.controller.route) {
          case SignupRoute.loading:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  key: Key('signup_auth_loading'),
                ),
              ),
            );
          case SignupRoute.welcome:
            return SignupWelcomeScreen(controller: widget.controller);
          case SignupRoute.onboarding:
            return SignupOnboardingScreen(controller: widget.controller);
          case SignupRoute.home:
            return widget.homeBuilder(
                context, widget.controller.homeDisplayName);
        }
      },
    );
  }
}

/// กลับไปหน้าราก (ให้ SignupGate แสดงปลายทางใหม่) หลังเข้าสู่ระบบ/บันทึกสำเร็จ
void popToSignupRoot(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}

=== จบ app/lib/features/signup/screens/signup_gate.dart ===

=== app/lib/features/signup/screens/signup_new_password_screen.dart ===
import 'package:flutter/material.dart';

import '../signup_controller.dart';
import '../signup_logic.dart';
import '../signup_rules.dart';
import '../widgets/signup_widgets.dart';
import 'signup_reset_sent_screen.dart';

/// S-5 หน้าตั้งค่ารหัสผ่านใหม่ (ux-flow §2 S-5, ui-spec §2.5, AC-3)
///
/// ASSUMPTION: ui-spec Q-7 — ทางเข้า S-5 (ลิงก์จากอีเมล / deep link) ยังไม่กำหนด
/// MVP ไม่มีอีเมลจริง จึงไม่มีปุ่มใดในแอปเปิดหน้านี้ — เปิดด้วย [SignupNewPasswordScreen.route]
class SignupNewPasswordScreen extends StatefulWidget {
  const SignupNewPasswordScreen({
    super.key,
    required this.controller,
    required this.email,
  });

  final SignupController controller;

  /// อีเมลของบัญชีที่ขอรีเซ็ต (มาจากลิงก์รีเซ็ต)
  final String email;

  static Route<void> route(SignupController controller, String email) =>
      MaterialPageRoute<void>(
        builder: (_) =>
            SignupNewPasswordScreen(controller: controller, email: email),
      );

  @override
  State<SignupNewPasswordScreen> createState() =>
      _SignupNewPasswordScreenState();
}

class _SignupNewPasswordScreenState extends State<SignupNewPasswordScreen> {
  final _passwordController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final password = _passwordController.text;
    // AC-3: รหัสผ่านสั้นกว่า min_password_length → ปฏิเสธการบันทึก
    if (_saving || !SignupLogic.isPasswordLongEnough(password)) return;
    setState(() => _saving = true);
    final ok = await widget.controller.resetPassword(widget.email, password);
    if (!mounted) return;
    setState(() => _saving = false);
    // ASSUMPTION: ux-flow ไม่มีสถานะบันทึกไม่สำเร็จของ S-5 — คงอยู่หน้าเดิมให้กดใหม่
    if (!ok) return;
    final messenger = ScaffoldMessenger.of(context);
    openSignInReplacingStack(context, widget.controller);
    showSignupToast(
      messenger,
      'signup_password_reset_success_toast',
      SignupRules.passwordResetSuccessMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final password = _passwordController.text;
    final canSave = !_saving && SignupLogic.isPasswordLongEnough(password);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          SignupRules.newPasswordHeader,
          key: Key('signup_new_password_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('signup_new_password_field'),
                controller: _passwordController,
                enabled: !_saving,
                obscureText: true,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.newPasswordHint,
                  error: SignupLogic.showsPasswordError(password)
                      ? const Text(
                          SignupRules.newPasswordTooShortError,
                          key: Key('signup_new_password_error_text'),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('signup_new_password_save_button'),
                onPressed: canSave ? _save : null,
                child: SignupButtonLabel(
                  text: SignupRules.newPasswordSaveText,
                  loading: _saving,
                  indicatorKey: 'signup_new_password_loading_indicator',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/signup/screens/signup_new_password_screen.dart ===

=== app/lib/features/signup/screens/signup_onboarding_screen.dart ===
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../signup_controller.dart';
import '../signup_logic.dart';
import '../signup_models.dart';
import '../signup_rules.dart';
import '../widgets/signup_widgets.dart';
import 'signup_gate.dart';

/// S-6 หน้า Onboarding (ux-flow §2 S-6, ui-spec §2.6)
/// AC-4, AC-5 (ผ่าน SignupLogic), AC-6, AC-7, EC-2, EC-3, EC-4
class SignupOnboardingScreen extends StatefulWidget {
  const SignupOnboardingScreen({super.key, required this.controller});

  final SignupController controller;

  @override
  State<SignupOnboardingScreen> createState() => _SignupOnboardingScreenState();
}

class _SignupOnboardingScreenState extends State<SignupOnboardingScreen> {
  late final TextEditingController _displayName;
  late final TextEditingController _age;
  late final TextEditingController _weight;
  late final TextEditingController _height;
  late final TextEditingController _healthGoal;
  late SignupGender _gender;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // ASSUMPTION: บัญชีที่มีโปรไฟล์อยู่แล้วแต่ถูกพามา S-6 (AC-2 Account Linking)
    // → เติมค่าเดิมไว้ในฟอร์ม เพื่อไม่ให้ข้อมูลเดิมถูกทับด้วยค่าว่าง
    final existing = widget.controller.session?.profile;
    _displayName = TextEditingController(
        text: existing == null || existing.displayNameFromEmail
            ? ''
            : existing.displayName);
    _age = TextEditingController(text: existing?.age.toString() ?? '');
    _weight = TextEditingController(text: _fmt(existing?.weightKg));
    _height = TextEditingController(text: _fmt(existing?.heightCm));
    // default_health_goal เป็นข้อความจริงในช่อง (ไม่ใช่ hint) — ui-spec §2.6 #16
    _healthGoal = TextEditingController(
        text: existing?.healthGoal ?? SignupRules.defaultHealthGoal);
    _gender = existing?.gender ?? SignupGender.defaultValue;
  }

  static String _fmt(double? v) {
    if (v == null) return '';
    return v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
  }

  @override
  void dispose() {
    _displayName.dispose();
    _age.dispose();
    _weight.dispose();
    _height.dispose();
    _healthGoal.dispose();
    super.dispose();
  }

  OnboardingValidation get _validation => SignupLogic.validateOnboarding(
        age: _age.text,
        weight: _weight.text,
        height: _height.text,
        gender: _gender,
      );

  Future<void> _save() async {
    if (_saving || !_validation.canSave) return;
    setState(() => _saving = true);
    final outcome = await widget.controller.saveProfile(
      displayName: _displayName.text,
      age: _age.text,
      gender: _gender,
      weight: _weight.text,
      height: _height.text,
      healthGoal: _healthGoal.text,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    switch (outcome) {
      case SaveProfileOutcome.success:
        // SignupGate เปลี่ยนหน้ารากเป็น S-7
        popToSignupRoot(context);
      case SaveProfileOutcome.networkError:
        // EC-4: ฟอร์มยังอยู่ใต้ dialog ค่าทุกช่องคงเดิม
        final retry = await showSignupNetworkErrorDialog(
          context,
          dialogKey: 'signup_onboarding_error_dialog',
          retryKey: 'signup_onboarding_retry_button',
        );
        if (retry && mounted) await _save();
      case SaveProfileOutcome.invalid:
        break;
    }
  }

  void _onChanged(String _) => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final v = _validation;
    final enabled = !_saving;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          SignupRules.onboardingHeader,
          key: Key('signup_onboarding_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                SignupRules.onboardingDescription,
                key: Key('signup_onboarding_description_text'),
              ),
              const SizedBox(height: 16),
              // EC-3: บล็อกตัวที่ 21 ในระดับ UI; ตัวนับ n/20 เป็น default ของ maxLength
              // ASSUMPTION: ui-spec Q-19 — นับตัวอักษรแบบ grapheme ของ TextField.maxLength
              TextField(
                key: const Key('signup_display_name_field'),
                controller: _displayName,
                enabled: enabled,
                maxLength: SignupRules.maxDisplayNameLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                onChanged: _onChanged,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: SignupRules.displayNameHint,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_age_field'),
                controller: _age,
                enabled: enabled,
                keyboardType: TextInputType.number,
                // D-c: จำนวนเต็มเท่านั้น — การพิมพ์/วางที่มีอักขระอื่นปน ("25.5", "-3",
                // "abc") ถูกปฏิเสธทั้งก้อนก่อนถึง digitsOnly จึงไม่เปลี่ยนค่าเงียบ ๆ
                inputFormatters: [
                  const SignupWholeNumberInputFormatter(),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: _onChanged,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.ageHint,
                  error: v.showAgeError
                      ? Text(SignupRules.ageRangeError,
                          key: const Key('signup_age_error_text'))
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                SignupRules.genderLabel,
                key: const Key('signup_gender_label'),
                style: theme.textTheme.titleMedium,
              ),
              RadioGroup<SignupGender>(
                key: const Key('signup_gender_group'),
                groupValue: _gender,
                onChanged: (g) {
                  if (g == null || !enabled) return;
                  setState(() => _gender = g);
                },
                child: Column(
                  children: [
                    for (final g in SignupGender.values)
                      RadioListTile<SignupGender>(
                        key: Key('signup_gender_${g.name}'),
                        value: g,
                        enabled: enabled,
                        contentPadding: EdgeInsets.zero,
                        title: Text(g.label),
                      ),
                  ],
                ),
              ),
              // AC-6: เตือนทันทีเมื่อเลือก UNSPECIFIED — ไม่บล็อกการบันทึก
              if (v.showGenderWarning)
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: SignupWarningText(
                    SignupRules.genderWarning,
                    key: Key('signup_gender_warning_text'),
                  ),
                ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_weight_field'),
                controller: _weight,
                enabled: enabled,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: _onChanged,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.weightHint,
                  // AC-7 warning (ไม่บล็อก) / EC-2 error (บล็อก) — error แทนที่ helper เอง
                  helper: v.showWeightWarning
                      ? const SignupWarningText(
                          SignupRules.bodyMetricMissingWarning,
                          key: Key('signup_weight_warning_text'),
                        )
                      : null,
                  error: v.showWeightError
                      ? Text(SignupRules.weightRangeError,
                          key: const Key('signup_weight_error_text'))
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_height_field'),
                controller: _height,
                enabled: enabled,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: _onChanged,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.heightHint,
                  helper: v.showHeightWarning
                      ? const SignupWarningText(
                          SignupRules.bodyMetricMissingWarning,
                          key: Key('signup_height_warning_text'),
                        )
                      : null,
                  error: v.showHeightError
                      ? Text(SignupRules.heightRangeError,
                          key: const Key('signup_height_error_text'))
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_health_goal_field'),
                controller: _healthGoal,
                enabled: enabled,
                minLines: 3,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: SignupRules.healthGoalLabel,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('signup_onboarding_save_button'),
                onPressed: enabled && v.canSave ? _save : null,
                child: SignupButtonLabel(
                  text: SignupRules.onboardingSaveText,
                  loading: _saving,
                  indicatorKey: 'signup_onboarding_loading_indicator',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/signup/screens/signup_onboarding_screen.dart ===

=== app/lib/features/signup/screens/signup_reset_sent_screen.dart ===
import 'package:flutter/material.dart';

import '../../water/widgets/asset_image_or_icon.dart';
import '../signup_controller.dart';
import '../signup_rules.dart';
import 'signup_email_screen.dart';

/// S-4 หน้าจอรอการยืนยันรีเซ็ตรหัสผ่าน (ux-flow §2 S-4, ui-spec §2.4)
class SignupResetSentScreen extends StatelessWidget {
  const SignupResetSentScreen({super.key, required this.controller});

  final SignupController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Center(
                child: AssetImageOrIcon(
                  key: Key('signup_reset_sent_image'),
                  assetPath: SignupRules.resetSentImage,
                  fallbackIcon: Icons.mark_email_unread,
                  size: SignupRules.heroImageSize,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                SignupRules.resetSentHeader,
                key: const Key('signup_reset_sent_header_text'),
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                SignupRules.resetSentMessage,
                key: Key('signup_reset_sent_message_text'),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              FilledButton(
                key: const Key('signup_back_to_login_button'),
                onPressed: () => openSignInReplacingStack(context, controller),
                child: const Text(SignupRules.backToLoginText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ไป S-2 โหมดเข้าสู่ระบบ โดยล้างหน้าที่ซ้อนอยู่ทั้งหมด เหลือหน้าราก (S-1) ไว้ใต้
// ASSUMPTION: 「กลับสู่หน้าเข้าสู่ระบบ」 (S-4) และบันทึกรหัสผ่านใหม่สำเร็จ (S-5) → S-2
// โหมดเข้าสู่ระบบเสมอ ไม่ว่าก่อนหน้าเปิด S-2 โหมดใด
void openSignInReplacingStack(
    BuildContext context, SignupController controller) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(
      builder: (_) => SignupEmailScreen(
        controller: controller,
        mode: SignupEmailMode.signIn,
      ),
    ),
    (route) => route.isFirst,
  );
}

=== จบ app/lib/features/signup/screens/signup_reset_sent_screen.dart ===

=== app/lib/features/signup/screens/signup_welcome_screen.dart ===
import 'package:flutter/material.dart';

import '../../water/widgets/asset_image_or_icon.dart';
import '../signup_controller.dart';
import '../signup_rules.dart';
import '../widgets/signup_widgets.dart';
import 'signup_email_screen.dart';
import 'signup_gate.dart';

/// S-1 หน้าต้อนรับและเลือกวิธีเข้าสู่ระบบ (ux-flow §2 S-1, ui-spec §2.1)
class SignupWelcomeScreen extends StatefulWidget {
  const SignupWelcomeScreen({super.key, required this.controller});

  final SignupController controller;

  @override
  State<SignupWelcomeScreen> createState() => _SignupWelcomeScreenState();
}

class _SignupWelcomeScreenState extends State<SignupWelcomeScreen> {
  bool _googleLoading = false;

  /// US-2 / AC-2 / EC-1 — ไม่มี Google SDK: FakeAuthRepository จำลองการเข้าสู่ระบบ
  Future<void> _signInWithGoogle() async {
    if (_googleLoading) return;
    setState(() => _googleLoading = true);
    final outcome = await widget.controller.signInWithGoogle();
    if (!mounted) return;
    setState(() => _googleLoading = false);
    switch (outcome) {
      case GoogleAuthOutcome.success:
        // SignupGate เปลี่ยนหน้ารากเป็น S-6 หรือ S-7 เอง
        popToSignupRoot(context);
      case GoogleAuthOutcome.networkError:
        final retry = await showSignupNetworkErrorDialog(
          context,
          dialogKey: 'signup_google_error_dialog',
          retryKey: 'signup_google_retry_button',
        );
        if (retry && mounted) await _signInWithGoogle();
    }
  }

  void _openEmail(SignupEmailMode mode) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            SignupEmailScreen(controller: widget.controller, mode: mode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final busy = _googleLoading;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      const Center(
                        child: AssetImageOrIcon(
                          key: Key('signup_welcome_logo'),
                          assetPath: SignupRules.welcomeLogo,
                          fallbackIcon: Icons.pets,
                          size: SignupRules.heroImageSize,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        SignupRules.appTitle,
                        key: const Key('signup_welcome_title_text'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        SignupRules.welcomeTagline,
                        key: const Key('signup_welcome_tagline_text'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        key: const Key('signup_google_button'),
                        onPressed: busy ? null : _signInWithGoogle,
                        // ASSUMPTION: ui-spec Q-17 — ยังไม่มีไฟล์โลโก้ Google ใช้ Icons.login
                        icon: _googleLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  key: Key('signup_google_loading_indicator'),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.login, size: 24),
                        label: const Text(SignupRules.googleButtonText),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              SignupRules.orText,
                              key: const Key('signup_or_text'),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        key: const Key('signup_email_signup_button'),
                        onPressed: busy
                            ? null
                            : () => _openEmail(SignupEmailMode.signUp),
                        icon: const Icon(Icons.email, size: 24),
                        label: const Text(SignupRules.emailSignupButtonText),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        key: const Key('signup_have_account_link'),
                        onPressed: busy
                            ? null
                            : () => _openEmail(SignupEmailMode.signIn),
                        child: const Text(SignupRules.haveAccountLinkText),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/signup/screens/signup_welcome_screen.dart ===

=== app/lib/features/signup/signup_controller.dart ===
/// ตัวกลางระหว่าง repository/logic กับ UI ของ signup
library;

import 'package:flutter/foundation.dart';

import 'signup_logic.dart';
import 'signup_models.dart';
import 'signup_repository.dart';

/// ผลของการสมัคร/เข้าสู่ระบบด้วยอีเมล (S-2)
enum EmailAuthOutcome { success, emailInUse, invalidCredentials, networkError }

/// ผลของ Google Login (S-1)
enum GoogleAuthOutcome { success, networkError }

/// ผลของการบันทึก Onboarding (S-6)
enum SaveProfileOutcome { success, networkError, invalid }

class SignupController extends ChangeNotifier {
  SignupController({required this._repository});

  final AuthRepository _repository;

  bool _isLoaded = false;
  AuthSession? _session;
  bool _forceOnboarding = false;

  bool get isLoaded => _isLoaded;
  AuthSession? get session => _session;

  /// ปลายทางปัจจุบันของแอป (ใช้โดย SignupGate)
  SignupRoute get route => SignupLogic.routeFor(
        isLoaded: _isLoaded,
        session: _session,
        forceOnboarding: _forceOnboarding,
      );

  /// ชื่อบนแบนเนอร์ S-7 (AC-5) — null ถ้ายังไม่มีโปรไฟล์
  String? get homeDisplayName {
    final profile = _session?.profile;
    return profile == null ? null : SignupLogic.displayNameForUi(profile);
  }

  /// อ่าน Token ตอนเปิดแอป (AC-8)
  Future<void> load() async {
    try {
      _session = await _repository.restoreSession();
    } catch (_) {
      // ASSUMPTION: อ่าน session ไม่ได้ → ไปหน้า S-1 (ให้เข้าสู่ระบบใหม่) แอปไม่ล่ม
      _session = null;
    }
    _isLoaded = true;
    notifyListeners();
  }

  /// S-2 โหมดสมัคร (US-1, AC-2, EC-5)
  Future<EmailAuthOutcome> signUpWithEmail(String email, String password) =>
      _emailAuth(() => _repository.signUpWithEmail(email, password));

  /// S-2 โหมดเข้าสู่ระบบ
  Future<EmailAuthOutcome> signInWithEmail(String email, String password) =>
      _emailAuth(() => _repository.signInWithEmail(email, password));

  Future<EmailAuthOutcome> _emailAuth(
      Future<AuthSession> Function() call) async {
    try {
      _session = await call();
    } on EmailAlreadyInUseException {
      return EmailAuthOutcome.emailInUse;
    } on InvalidCredentialsException {
      return EmailAuthOutcome.invalidCredentials;
    } on AuthNetworkException {
      return EmailAuthOutcome.networkError;
    }
    _forceOnboarding = false;
    notifyListeners();
    return EmailAuthOutcome.success;
  }

  /// S-1 Google Login (US-2, AC-2, EC-1)
  Future<GoogleAuthOutcome> signInWithGoogle() async {
    final GoogleSignInResult result;
    try {
      result = await _repository.signInWithGoogle();
    } on AuthNetworkException {
      return GoogleAuthOutcome.networkError;
    }
    _session = result.session;
    // AC-2: เชื่อมบัญชีแล้วพาไป Onboarding ทันที
    _forceOnboarding = result.linked;
    notifyListeners();
    return GoogleAuthOutcome.success;
  }

  /// S-3
  Future<void> requestPasswordReset(String email) =>
      _repository.requestPasswordReset(email);

  /// S-5 (AC-3) — false = รหัสผ่านสั้นเกิน (ปฏิเสธการบันทึก) หรือบันทึกไม่สำเร็จ
  Future<bool> resetPassword(String email, String newPassword) async {
    if (!SignupLogic.isPasswordLongEnough(newPassword)) return false;
    try {
      await _repository.resetPassword(email, newPassword);
      return true;
    } on AuthException {
      return false;
    }
  }

  /// S-6 บันทึก (US-4, AC-4, EC-2, EC-4)
  Future<SaveProfileOutcome> saveProfile({
    required String displayName,
    required String age,
    required SignupGender gender,
    required String weight,
    required String height,
    required String healthGoal,
  }) async {
    final session = _session;
    if (session == null) return SaveProfileOutcome.invalid;
    final profile = SignupLogic.buildProfile(
      email: session.email,
      displayName: displayName,
      age: age,
      gender: gender,
      weight: weight,
      height: height,
      healthGoal: healthGoal,
    );
    if (profile == null) return SaveProfileOutcome.invalid;
    try {
      _session = await _repository.saveProfile(profile);
    } on AuthNetworkException {
      return SaveProfileOutcome.networkError;
    } on NotSignedInException {
      return SaveProfileOutcome.invalid;
    }
    _forceOnboarding = false;
    notifyListeners();
    return SaveProfileOutcome.success;
  }

  Future<void> signOut() async {
    await _repository.signOut();
    _session = null;
    _forceOnboarding = false;
    notifyListeners();
  }
}

=== จบ app/lib/features/signup/signup_controller.dart ===

=== app/lib/features/signup/signup_logic.dart ===
/// กติกาของฟีเจอร์ signup — pure Dart ไม่ขึ้นกับ widget (QA ทดสอบตรงได้)
library;

import 'signup_models.dart';
import 'signup_rules.dart';

/// ปลายทางของแอปตามสถานะ session (ux-flow §3, AC-8)
enum SignupRoute {
  /// กำลังอ่าน Token (ui-spec §2.0)
  loading,

  /// S-1
  welcome,

  /// S-6
  onboarding,

  /// S-7
  home,
}

/// ผลตรวจฟิลด์ตัวเลขของ S-6
enum NumberFieldStatus {
  /// ว่าง
  empty,

  /// อยู่ในขอบเขต
  valid,

  /// นอกขอบเขตหรืออ่านไม่ออก (EC-2)
  outOfRange,
}

/// ผลตรวจฟอร์ม S-6 ทั้งหน้า
class OnboardingValidation {
  const OnboardingValidation({
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
  });

  final NumberFieldStatus age;
  final NumberFieldStatus weight;
  final NumberFieldStatus height;
  final SignupGender gender;

  bool get showAgeError => age == NumberFieldStatus.outOfRange;
  bool get showWeightError => weight == NumberFieldStatus.outOfRange;
  bool get showHeightError => height == NumberFieldStatus.outOfRange;

  /// AC-7: เตือนใต้ช่องที่ว่างเท่านั้น
  bool get showWeightWarning => weight == NumberFieldStatus.empty;
  bool get showHeightWarning => height == NumberFieldStatus.empty;

  /// AC-6
  bool get showGenderWarning => SignupLogic.showsGenderWarning(gender);

  /// EC-2: ทุกช่องตัวเลขที่กรอกต้องอยู่ในขอบเขต; warning ไม่บล็อก (fallback ux-flow §6)
  // ASSUMPTION: อายุว่าง → บันทึกไม่ได้ (ui-spec Q-11 ตาม brief: อายุบังคับกรอก)
  // โดยไม่แสดงข้อความ
  bool get canSave =>
      age == NumberFieldStatus.valid &&
      weight != NumberFieldStatus.outOfRange &&
      height != NumberFieldStatus.outOfRange;
}

class SignupLogic {
  SignupLogic._();

  // ---------------------------------------------------------------------------
  // S-2 / S-5 อีเมลและรหัสผ่าน
  // ---------------------------------------------------------------------------

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  /// ทำอีเมลให้เป็นรูปแบบเดียวกันก่อนเทียบ/บันทึก
  // ASSUMPTION: อีเมลไม่สนตัวพิมพ์เล็ก-ใหญ่ และตัดช่องว่างหัวท้าย (A@x.com = a@x.com)
  static String normalizeEmail(String email) => email.trim().toLowerCase();

  /// ใช้ตัดสินว่าปุ่ม S-2 enabled ได้หรือไม่ (ui-spec §3 S-2 disabled)
  // ASSUMPTION: ตรวจรูปแบบอีเมลแบบพื้นฐาน "x@y.z" (ui-spec Q-3) ไม่มีข้อความ error
  static bool isValidEmail(String email) =>
      _emailPattern.hasMatch(email.trim());

  /// AC-1, AC-3: ความยาว >= min_password_length
  static bool isPasswordLongEnough(String password) =>
      password.length >= SignupRules.minPasswordLength;

  /// AC-1 / AC-3: แสดง error เมื่อยาว 1 ถึง min-1 ตัว — ช่องว่าง (0) ไม่ใช่ error (ui-spec Q-3)
  // ASSUMPTION: นับความยาวรหัสผ่านเป็น UTF-16 code unit (String.length) — ui-spec Q-19
  static bool showsPasswordError(String password) =>
      password.isNotEmpty && !isPasswordLongEnough(password);

  /// ปุ่ม S-2 enabled เมื่ออีเมลถูกรูปแบบและรหัสผ่านยาวพอ
  static bool canSubmitCredentials(String email, String password) =>
      isValidEmail(email) && isPasswordLongEnough(password);

  // ---------------------------------------------------------------------------
  // S-6 / S-7 Display Name (AC-4, AC-5, EC-3)
  // ---------------------------------------------------------------------------

  /// ชื่อหน้าอีเมล เช่น alexander@email.com → alexander
  static String emailLocalPart(String email) {
    final trimmed = email.trim();
    final at = trimmed.indexOf('@');
    return at < 0 ? trimmed : trimmed.substring(0, at);
  }

  /// ค่า Display Name ที่บันทึก (AC-4) — คืน (ชื่อ, มาจากอีเมลหรือไม่)
  static ({String name, bool fromEmail}) resolveDisplayName(
    String typed,
    String email,
  ) {
    final name = typed.trim();
    if (name.isNotEmpty) {
      return (name: _cap(name), fromEmail: false);
    }
    // DECIDED (owner ชั่วคราว D-a): ชื่อหน้าอีเมลบันทึกเต็มไม่ตัด — ลิมิต
    // max_display_name_length ใช้เฉพาะชื่อที่ผู้ใช้พิมพ์เอง (EC-3); AC-5 ย่อตอนแสดงผล
    return (name: emailLocalPart(email), fromEmail: true);
  }

  /// AC-5: ชื่อจากหน้าอีเมลที่ยาวเกิน display_name_truncation_limit → 4 ตัวแรก + ... + 2 ตัวท้าย
  static String truncateEmailName(String name) {
    final chars = name.runes.toList();
    if (chars.length <= SignupRules.displayNameTruncationLimit) return name;
    final head = String.fromCharCodes(
        chars.take(SignupRules.truncatedHeadLength));
    final tail = String.fromCharCodes(
        chars.skip(chars.length - SignupRules.truncatedTailLength));
    return '$head${SignupRules.truncationEllipsis}$tail';
  }

  /// ชื่อที่แสดงบนแบนเนอร์ S-7 — ชื่อจากอีเมลถูกบันทึกเต็ม (D-a) จึงย่อจากชื่อหน้าอีเมลจริง
  // ASSUMPTION: ui-spec Q-20 — ตัดคำเฉพาะชื่อที่ได้จากหน้าอีเมล ชื่อที่ผู้ใช้พิมพ์เองแสดงเต็ม
  static String displayNameForUi(UserProfile profile) =>
      profile.displayNameFromEmail
          ? truncateEmailName(profile.displayName)
          : profile.displayName;

  static String _cap(String s) {
    final chars = s.runes.toList();
    if (chars.length <= SignupRules.maxDisplayNameLength) return s;
    return String.fromCharCodes(chars.take(SignupRules.maxDisplayNameLength));
  }

  // ---------------------------------------------------------------------------
  // S-6 ช่องตัวเลข (EC-2) และคำเตือน (AC-6, AC-7)
  // ---------------------------------------------------------------------------

  static final RegExp _wholeNumberPattern = RegExp(r'^[0-9]+$');

  /// อายุต้องเป็นจำนวนเต็มเท่านั้น (DECIDED ทีม D-c, requirements §6 Age = Integer)
  /// รับเฉพาะเลข 0-9 ล้วน — ไม่รับทศนิยม ("25.5"), เครื่องหมาย ("-3", "+25"),
  /// รูปแบบที่ int.tryParse รับได้แต่ไม่ใช่เลขฐานสิบล้วน ("0x19") หรือตัวอักษร ("abc")
  static bool isWholeNumberText(String text) =>
      _wholeNumberPattern.hasMatch(text);

  /// EC-2: อายุอยู่ในช่วง [min_age, max_age]
  static bool isAgeInRange(int age) =>
      age >= SignupRules.minAge && age <= SignupRules.maxAge;

  static NumberFieldStatus ageStatus(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return NumberFieldStatus.empty;
    // ASSUMPTION: ข้อความที่ไม่ใช่จำนวนเต็มล้วน ถือเป็น error เดียวกับนอกขอบเขต
    // (เอกสารไม่มีข้อความเฉพาะ) → บล็อกการบันทึก
    if (!isWholeNumberText(text)) return NumberFieldStatus.outOfRange;
    final v = int.tryParse(text);
    if (v == null || !isAgeInRange(v)) return NumberFieldStatus.outOfRange;
    return NumberFieldStatus.valid;
  }

  // ASSUMPTION: ข้อความที่แปลงเป็นตัวเลขไม่ได้ (เช่น "1.2.3", "abc") ถือเป็น error
  // เดียวกับนอกขอบเขต (เอกสารไม่มีข้อความเฉพาะ); ทศนิยมไม่จำกัดหลัก (ui-spec Q-11)
  static NumberFieldStatus weightStatus(String raw) =>
      _doubleStatus(raw, SignupRules.minWeight, SignupRules.maxWeight);

  static NumberFieldStatus heightStatus(String raw) =>
      _doubleStatus(raw, SignupRules.minHeight, SignupRules.maxHeight);

  static NumberFieldStatus _doubleStatus(String raw, double min, double max) {
    final text = raw.trim();
    if (text.isEmpty) return NumberFieldStatus.empty;
    final v = double.tryParse(text);
    if (v == null || v.isNaN || v < min || v > max) {
      return NumberFieldStatus.outOfRange;
    }
    return NumberFieldStatus.valid;
  }

  /// AC-6
  static bool showsGenderWarning(SignupGender gender) =>
      gender == SignupGender.unspecified;

  static OnboardingValidation validateOnboarding({
    required String age,
    required String weight,
    required String height,
    required SignupGender gender,
  }) =>
      OnboardingValidation(
        age: ageStatus(age),
        weight: weightStatus(weight),
        height: heightStatus(height),
        gender: gender,
      );

  /// สร้างโปรไฟล์ที่จะบันทึก — คืน null ถ้าฟอร์มยังบันทึกไม่ได้ (EC-2)
  static UserProfile? buildProfile({
    required String email,
    required String displayName,
    required String age,
    required SignupGender gender,
    required String weight,
    required String height,
    required String healthGoal,
  }) {
    final v = validateOnboarding(
        age: age, weight: weight, height: height, gender: gender);
    if (!v.canSave) return null;
    final name = resolveDisplayName(displayName, email);
    final goal = healthGoal.trim();
    return UserProfile(
      displayName: name.name,
      displayNameFromEmail: name.fromEmail,
      age: int.parse(age.trim()),
      gender: gender,
      weightKg: v.weight == NumberFieldStatus.valid
          ? double.parse(weight.trim())
          : null,
      heightCm: v.height == NumberFieldStatus.valid
          ? double.parse(height.trim())
          : null,
      // ASSUMPTION: ui-spec Q-10 — ผู้ใช้ลบเป้าหมายจนว่าง → บันทึกค่าเริ่มต้น 「ดูแลสุขภาพ」
      healthGoal: goal.isEmpty ? SignupRules.defaultHealthGoal : goal,
    );
  }

  // ---------------------------------------------------------------------------
  // การนำทาง (ux-flow §3, AC-2, AC-8)
  // ---------------------------------------------------------------------------

  /// [forceOnboarding] = true หลัง Google Account Linking (AC-2 "พาไปหน้า Onboarding ทันที")
  // ASSUMPTION: มี session แต่ยังไม่มีโปรไฟล์ (เช่น ปิดแอประหว่าง Onboarding) → S-6
  static SignupRoute routeFor({
    required bool isLoaded,
    required AuthSession? session,
    bool forceOnboarding = false,
  }) {
    if (!isLoaded) return SignupRoute.loading;
    if (session == null) return SignupRoute.welcome;
    if (forceOnboarding || session.profile == null) {
      return SignupRoute.onboarding;
    }
    return SignupRoute.home;
  }
}

=== จบ app/lib/features/signup/signup_logic.dart ===

=== app/lib/features/signup/signup_models.dart ===
/// โมเดลข้อมูลของฟีเจอร์ signup (pure Dart)
library;

import 'signup_rules.dart';

/// เพศ (requirements §6) — ค่าภายในเป็น MALE / FEMALE / UNSPECIFIED (ux-flow S-6)
enum SignupGender {
  male('MALE', SignupRules.genderMaleText),
  female('FEMALE', SignupRules.genderFemaleText),
  unspecified('UNSPECIFIED', SignupRules.genderUnspecifiedText);

  const SignupGender(this.code, this.label);

  final String code;

  /// ข้อความบนจอ — แสดงเฉพาะคำไทย (ui-spec Q-8)
  final String label;

  /// default_gender (game-rules §1)
  static final SignupGender defaultValue =
      fromCode(SignupRules.defaultGenderCode);

  static SignupGender fromCode(String? code) {
    for (final g in values) {
      if (g.code == code) return g;
    }
    // ASSUMPTION: ค่าที่อ่านไม่ออก → ใช้ UNSPECIFIED (ค่าเริ่มต้นที่ปลอดภัย)
    return SignupGender.unspecified;
  }
}

/// ช่องทางที่ใช้เข้าสู่ระบบ
enum AuthProvider { email, google }

/// ข้อมูลสุขภาพ/โปรไฟล์ (requirements §6 Profiles Table)
class UserProfile {
  const UserProfile({
    required this.displayName,
    required this.displayNameFromEmail,
    required this.age,
    required this.gender,
    required this.weightKg,
    required this.heightCm,
    required this.healthGoal,
  });

  /// ค่าที่บันทึก (AC-4: เว้นว่าง → ชื่อหน้าอีเมล)
  final String displayName;

  /// true = ได้มาจากชื่อหน้าอีเมล (ใช้ตัดสินว่าต้องตัดคำตาม AC-5 หรือไม่)
  final bool displayNameFromEmail;
  final int age;
  final SignupGender gender;
  final double? weightKg;
  final double? heightCm;
  final String healthGoal;

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'displayNameFromEmail': displayNameFromEmail,
        'age': age,
        'gender': gender.code,
        'weightKg': weightKg,
        'heightCm': heightCm,
        'healthGoal': healthGoal,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        displayName: json['displayName'] as String,
        displayNameFromEmail: json['displayNameFromEmail'] as bool? ?? false,
        // D-c: อายุเป็นจำนวนเต็มเท่านั้น — ค่าที่บันทึกเป็นทศนิยม/ไม่ใช่ตัวเลขถือว่าข้อมูลเสีย
        // (throw → ผู้เรียกข้ามรายการนั้น) แทนการปัดเศษเงียบ ๆ ด้วย toInt()
        age: json['age'] as int,
        gender: SignupGender.fromCode(json['gender'] as String?),
        weightKg: (json['weightKg'] as num?)?.toDouble(),
        heightCm: (json['heightCm'] as num?)?.toDouble(),
        healthGoal:
            json['healthGoal'] as String? ?? SignupRules.defaultHealthGoal,
      );
}

/// Session ที่จัดเก็บในเครื่อง (US-5, AC-8)
class AuthSession {
  const AuthSession({
    required this.token,
    required this.email,
    this.profile,
  });

  final String token;
  final String email;

  /// null = ยังไม่ผ่าน Onboarding
  final UserProfile? profile;

  AuthSession copyWith({UserProfile? profile}) =>
      AuthSession(token: token, email: email, profile: profile ?? this.profile);
}

/// ผลของ Google Login (AC-2)
class GoogleSignInResult {
  const GoogleSignInResult({required this.session, required this.linked});

  final AuthSession session;

  /// true = อีเมลนี้เคยสมัครแบบอีเมลมาก่อน และถูกเชื่อมบัญชี (Account Linking)
  final bool linked;
}

/// ข้อผิดพลาดจาก repository
sealed class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
  @override
  String toString() => '$runtimeType: $message';
}

/// เครือข่ายขัดข้อง (EC-1, EC-4)
class AuthNetworkException extends AuthException {
  const AuthNetworkException([super.message = 'network unavailable']);
}

/// อีเมลถูกใช้แล้ว (AC-2, EC-5)
class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException([super.message = 'email already in use']);
}

/// อีเมล/รหัสผ่านไม่ตรงกับบัญชีใด (โหมดเข้าสู่ระบบ)
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException([super.message = 'invalid credentials']);
}

/// ไม่ได้เข้าสู่ระบบ (เช่น บันทึกโปรไฟล์โดยไม่มี session)
class NotSignedInException extends AuthException {
  const NotSignedInException([super.message = 'not signed in']);
}

=== จบ app/lib/features/signup/signup_models.dart ===

=== app/lib/features/signup/signup_repository.dart ===
/// การยืนยันตัวตนและเก็บโปรไฟล์ของ signup
///
/// DECIDED (owner): MVP ยังไม่มี backend — ใช้ [FakeAuthRepository] จำลองในเครื่อง
/// (ไม่มี network, ไม่ลง google_sign_in) โดยแยก [AuthRepository] เป็น interface
/// ไว้ต่อ backend จริงภายหลัง
library;

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signup_logic.dart';
import 'signup_models.dart';
import 'signup_rules.dart';

/// interface ของระบบยืนยันตัวตน — ทุกเมธอด throw [AuthException] เมื่อไม่สำเร็จ
abstract class AuthRepository {
  /// อ่าน session ที่เก็บไว้ในเครื่อง (AC-8) — null = ยังไม่ได้เข้าสู่ระบบ
  Future<AuthSession?> restoreSession();

  /// US-1 — throw [EmailAlreadyInUseException] (AC-2, EC-5), [AuthNetworkException]
  Future<AuthSession> signUpWithEmail(String email, String password);

  /// S-2 โหมดเข้าสู่ระบบ — throw [InvalidCredentialsException], [AuthNetworkException]
  Future<AuthSession> signInWithEmail(String email, String password);

  /// US-2 / AC-2 — throw [AuthNetworkException] (EC-1)
  Future<GoogleSignInResult> signInWithGoogle();

  /// US-3 S-3
  Future<void> requestPasswordReset(String email);

  /// US-3 S-5 / AC-3 — throw [ArgumentError] ถ้ารหัสผ่านสั้นกว่า min_password_length
  Future<void> resetPassword(String email, String newPassword);

  /// US-4 S-6 — throw [AuthNetworkException] (EC-4), [NotSignedInException]
  Future<AuthSession> saveProfile(UserProfile profile);

  Future<void> signOut();
}

// -----------------------------------------------------------------------------
// ที่เก็บข้อมูลในเครื่อง (key-value)
// -----------------------------------------------------------------------------

abstract class AuthLocalStore {
  Future<String?> read(String key);

  /// value = null → ลบ key
  Future<void> write(String key, String? value);
}

class InMemoryAuthLocalStore implements AuthLocalStore {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String? value) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }
}

/// เก็บด้วย shared_preferences
// ASSUMPTION: requirements §6 / AC-8 ให้เก็บ Token ใน Secure Storage แต่ owner สั่งใช้
// shared_preferences ในรอบนี้ — เปลี่ยนเป็น secure storage ได้โดยเขียน AuthLocalStore ใหม่
class SharedPrefsAuthLocalStore implements AuthLocalStore {
  SharedPrefsAuthLocalStore([Future<SharedPreferences>? prefs])
      : _prefs = prefs ?? SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefs;

  @override
  Future<String?> read(String key) async {
    try {
      final v = (await _prefs).get(key);
      return v is String ? v : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(String key, String? value) async {
    final prefs = await _prefs;
    final ok = value == null
        ? await prefs.remove(key)
        : await prefs.setString(key, value);
    if (!ok) throw const AuthNetworkException('local storage write failed');
  }
}

class SignupStorageKeys {
  SignupStorageKeys._();

  static const String accounts = 'signup_accounts';
  static const String session = 'signup_session';
}

// -----------------------------------------------------------------------------
// Fake repository
// -----------------------------------------------------------------------------

class _Account {
  _Account({
    required this.email,
    this.salt,
    this.passwordHash,
    Set<AuthProvider>? providers,
    this.profile,
  }) : providers = providers ?? {};

  final String email;
  String? salt;
  String? passwordHash;
  final Set<AuthProvider> providers;
  UserProfile? profile;

  Map<String, dynamic> toJson() => {
        'email': email,
        'salt': salt,
        'passwordHash': passwordHash,
        'providers': [for (final p in providers) p.name],
        'profile': profile?.toJson(),
      };

  static _Account fromJson(Map<String, dynamic> json) => _Account(
        email: json['email'] as String,
        salt: json['salt'] as String?,
        passwordHash: json['passwordHash'] as String?,
        providers: {
          for (final p in (json['providers'] as List? ?? const []))
            ...AuthProvider.values.where((v) => v.name == p),
        },
        profile: json['profile'] is Map<String, dynamic>
            ? UserProfile.fromJson(json['profile'] as Map<String, dynamic>)
            : null,
      );
}

/// ระบบยืนยันตัวตนจำลองในเครื่อง (ไม่มี network)
///
/// สำหรับ QA:
/// - [registeredEmails] / [registeredAccounts] — อีเมลที่สมัครไว้แล้วตั้งแต่ต้น
///   (ใช้ทดสอบอีเมลซ้ำ AC-2/EC-5 และ Account Linking)
/// - [failGoogleSignIn] = true → `signInWithGoogle` throw [AuthNetworkException] (EC-1)
/// - [failSaveProfile] = true → `saveProfile` throw [AuthNetworkException] (EC-4)
/// - [failEmailAuth] = true → สมัคร/เข้าสู่ระบบด้วยอีเมล throw [AuthNetworkException]
/// - [googleAccountEmail] — อีเมลที่ "บัญชี Google จำลอง" คืนมา
/// - [latency] — หน่วงทุกการเรียก (ดูสถานะ loading ได้ด้วย `tester.pump(latency)`)
/// flag ทั้งหมดแก้ระหว่างเทสต์ได้ (เช่น ตั้ง false แล้วกด Retry)
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    AuthLocalStore? store,
    Iterable<String> registeredEmails = const [],
    Map<String, String> registeredAccounts = const {},
    this.googleAccountEmail = defaultGoogleAccountEmail,
    this.failGoogleSignIn = false,
    this.failSaveProfile = false,
    this.failEmailAuth = false,
    this.latency = Duration.zero,
    Random? random,
  })  : _store = store ?? InMemoryAuthLocalStore(),
        _random = random ?? Random.secure() {
    // บัญชีตั้งต้น: ไม่มีรหัสผ่าน (เข้าสู่ระบบด้วยอีเมลไม่ได้ แต่ซ้ำ/เชื่อมบัญชีได้)
    for (final e in registeredEmails) {
      final email = SignupLogic.normalizeEmail(e);
      _seed[email] = _Account(email: email, providers: {AuthProvider.email});
    }
    registeredAccounts.forEach((e, password) {
      final email = SignupLogic.normalizeEmail(e);
      final account = _Account(email: email, providers: {AuthProvider.email});
      _setPassword(account, password);
      _seed[email] = account;
    });
  }

  // ASSUMPTION: ไม่มี Google SDK — บัญชี Google จำลองใช้อีเมลนี้ (ข้อมูลสมมติ)
  static const String defaultGoogleAccountEmail = 'petpal.demo@gmail.com';

  final AuthLocalStore _store;
  final Random _random;
  final Map<String, _Account> _seed = {};

  String googleAccountEmail;
  bool failGoogleSignIn;
  bool failSaveProfile;
  bool failEmailAuth;
  Duration latency;

  Map<String, _Account>? _accounts;
  AuthSession? _session;

  /// จำนวนครั้งที่ขอรีเซ็ตรหัสผ่าน (ตรวจได้ในเทสต์ — ไม่มีอีเมลจริงถูกส่ง)
  int passwordResetRequests = 0;

  /// อีเมลที่ลงทะเบียนแล้วทั้งหมด (normalize แล้ว)
  Future<Set<String>> registeredEmailSet() async =>
      (await _loadAccounts()).keys.toSet();

  /// โปรไฟล์ที่บันทึกของอีเมลนี้ (null = ยังไม่มี)
  Future<UserProfile?> profileFor(String email) async =>
      (await _loadAccounts())[SignupLogic.normalizeEmail(email)]?.profile;

  @override
  Future<AuthSession?> restoreSession() async {
    await _delay();
    final accounts = await _loadAccounts();
    final raw = await _store.read(SignupStorageKeys.session);
    if (raw == null) return _session = null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final token = json['token'] as String;
      final email = json['email'] as String;
      final account = accounts[email];
      // ASSUMPTION: session ที่ชี้ไปบัญชีที่ไม่มีแล้ว / ข้อมูลเสีย → ถือว่ายังไม่เข้าสู่ระบบ
      if (account == null || token.isEmpty) return _session = null;
      return _session =
          AuthSession(token: token, email: email, profile: account.profile);
    } catch (_) {
      return _session = null;
    }
  }

  @override
  Future<AuthSession> signUpWithEmail(String email, String password) async {
    await _delay();
    if (failEmailAuth) throw const AuthNetworkException();
    _checkPassword(password);
    final accounts = await _loadAccounts();
    final key = SignupLogic.normalizeEmail(email);
    if (accounts.containsKey(key)) throw const EmailAlreadyInUseException();
    final account = _Account(email: key, providers: {AuthProvider.email});
    _setPassword(account, password);
    accounts[key] = account;
    await _saveAccounts();
    return _startSession(account);
  }

  @override
  Future<AuthSession> signInWithEmail(String email, String password) async {
    await _delay();
    if (failEmailAuth) throw const AuthNetworkException();
    final accounts = await _loadAccounts();
    final account = accounts[SignupLogic.normalizeEmail(email)];
    if (account == null ||
        account.salt == null ||
        account.passwordHash != _hash(account.salt!, password)) {
      throw const InvalidCredentialsException();
    }
    return _startSession(account);
  }

  @override
  Future<GoogleSignInResult> signInWithGoogle() async {
    await _delay();
    if (failGoogleSignIn) throw const AuthNetworkException();
    final accounts = await _loadAccounts();
    final key = SignupLogic.normalizeEmail(googleAccountEmail);
    var account = accounts[key];
    var linked = false;
    if (account == null) {
      account = _Account(email: key, providers: {AuthProvider.google});
      accounts[key] = account;
    } else if (!account.providers.contains(AuthProvider.google)) {
      // AC-2 Account Linking: อีเมลนี้เคยสมัครแบบปกติ → เชื่อม Google เข้าบัญชีเดิม
      account.providers.add(AuthProvider.google);
      linked = true;
    }
    await _saveAccounts();
    final session = await _startSession(account);
    return GoogleSignInResult(session: session, linked: linked);
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await _delay();
    // ASSUMPTION: ไม่มีอีเมลจริง — นับคำขอไว้เท่านั้น และตอบสำเร็จเสมอไม่ว่ามีบัญชีหรือไม่
    // (ไม่เปิดเผยว่าอีเมลใดมีบัญชี; ux-flow ไม่มีสถานะ error ของ S-3 — ui-spec Q-7)
    passwordResetRequests++;
  }

  @override
  Future<void> resetPassword(String email, String newPassword) async {
    await _delay();
    _checkPassword(newPassword); // AC-3 ปฏิเสธการบันทึกรหัสผ่านสั้น
    final accounts = await _loadAccounts();
    final account = accounts[SignupLogic.normalizeEmail(email)];
    // ASSUMPTION: อีเมลที่ไม่มีบัญชี → ไม่ทำอะไร (ตอบสำเร็จ) แบบเดียวกับ S-3
    if (account == null) return;
    _setPassword(account, newPassword);
    account.providers.add(AuthProvider.email);
    await _saveAccounts();
  }

  @override
  Future<AuthSession> saveProfile(UserProfile profile) async {
    await _delay();
    if (failSaveProfile) throw const AuthNetworkException();
    final session = _session;
    final accounts = await _loadAccounts();
    final account = session == null ? null : accounts[session.email];
    if (session == null || account == null) {
      throw const NotSignedInException();
    }
    // EC-2 / D-c: กันชั้นสุดท้าย — โปรไฟล์ที่ไม่ผ่าน SignupLogic.buildProfile บันทึกไม่ได้
    if (!SignupLogic.isAgeInRange(profile.age)) {
      throw ArgumentError.value(profile.age, 'age',
          'must be ${SignupRules.minAge}-${SignupRules.maxAge}');
    }
    account.profile = profile;
    await _saveAccounts();
    return _session = session.copyWith(profile: profile);
  }

  @override
  Future<void> signOut() async {
    _session = null;
    await _store.write(SignupStorageKeys.session, null);
  }

  // ---------------------------------------------------------------------------

  Future<void> _delay() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
  }

  void _checkPassword(String password) {
    if (!SignupLogic.isPasswordLongEnough(password)) {
      throw ArgumentError(
          'password must be at least ${SignupRules.minPasswordLength} characters');
    }
  }

  Future<AuthSession> _startSession(_Account account) async {
    final session = AuthSession(
      token: _newToken(),
      email: account.email,
      profile: account.profile,
    );
    // AC-8: เก็บ token ไว้ในเครื่อง เปิดแอปใหม่ไม่ต้องเข้าสู่ระบบอีก
    await _store.write(
      SignupStorageKeys.session,
      jsonEncode({'token': session.token, 'email': session.email}),
    );
    return _session = session;
  }

  Future<Map<String, _Account>> _loadAccounts() async {
    final cached = _accounts;
    if (cached != null) return cached;
    final accounts = <String, _Account>{};
    final raw = await _store.read(SignupStorageKeys.accounts);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List;
        for (final item in list) {
          try {
            final a = _Account.fromJson(item as Map<String, dynamic>);
            accounts[a.email] = a;
          } catch (_) {
            // ข้ามรายการที่เสีย
          }
        }
      } catch (_) {
        // ASSUMPTION: ข้อมูลบัญชีในเครื่องเสีย → เริ่มว่าง ไม่ทำให้แอปล่ม
      }
    }
    for (final entry in _seed.entries) {
      accounts.putIfAbsent(entry.key, () => entry.value);
    }
    return _accounts = accounts;
  }

  Future<void> _saveAccounts() async {
    final accounts = await _loadAccounts();
    await _store.write(
      SignupStorageKeys.accounts,
      jsonEncode([for (final a in accounts.values) a.toJson()]),
    );
  }

  /// requirements §6: เก็บรหัสผ่านแบบ hash (SHA-256 + salt ต่อบัญชี) ไม่เก็บตัวจริง
  void _setPassword(_Account account, String password) {
    final salt = base64Url.encode(_randomBytes(16));
    account
      ..salt = salt
      ..passwordHash = _hash(salt, password);
  }

  static String _hash(String salt, String password) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();

  String _newToken() => base64Url.encode(_randomBytes(32));

  List<int> _randomBytes(int n) => [for (var i = 0; i < n; i++) _random.nextInt(256)];
}

=== จบ app/lib/features/signup/signup_repository.dart ===

(app/lib/features/signup/signup_rules.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/signup/widgets/signup_widgets.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/screens/steps_dashboard_screen.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/screens/steps_goal_screen.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/screens/steps_monthly_report_screen.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/steps_controller.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/steps_external.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/steps_logic.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/steps_models.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/steps_repository.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/steps_rules.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/widgets/steps_toast.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/water/screens/monthly_report_screen.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/water/screens/water_home_screen.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/water/water_controller.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/water/water_logic.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/water/water_models.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/water/water_repository.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/water/water_rules.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/water/widgets/asset_image_or_icon.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/main.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/shared/pet/pet.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/shared/pet/pet_animation_policy.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/shared/pet/pet_character.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/shared/pet/pet_constants.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/shared/pet/pet_painter.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/shared/pet/pet_pose.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

=== app/test/dashboard/dashboard_controller_test.dart (เฉพาะชื่อ test/group) ===
- group: AC-3 หมุนเวียนทุก alertInterval = 5 วินาที
- test: AC3_starts_at_highest_priority_P2_on_empty_day
- test: AC3_EDGE_rotation_exactly_at_5s_not_4_999s_and_loops
- test: AC3_P1_queue_rotates_P1_P2_P3_back_to_P1
- test: AC3_single_item_queue_stays_on_same_text
- test: AC3_EDGE_empty_queue_no_alert
- group: AC-3 / EC-2 คัดออกจากคิวทันที (Q-17: ไม่รอ 5 วินาที)
- test: EC2_P2_resolved_by_logging_water_switches_to_P3_immediately
- test: DECIDED_Q19_after_removal_next_rotation_counts_5s_anew
- test: EC2_P3_resolved_by_steps_switches_to_P4_immediately
- test: EC2_GR4_P1_removed_while_showing_switches_to_P2_immediately
- test: EC2_last_problem_resolved_queue_empty_alert_hidden
- test: DECIDED_Q3_P4_removed_when_meal_logged_reaches_50
- test: DECIDED_Q19_new_P1_enters_queue_shows_highest_priority
- group: AC-5 / EC-3 ข้าม 05:00 (D-2 เวลาเครื่อง)
- test: AC5_EC3_EDGE_04_59_59_keeps_day_05_00_00_resets_all
- test: EC3_rollover_clears_P1_and_red_bar
- test: AC5_open_after_05_00_with_yesterday_data_shows_new_day
- group: EDGE ข้อมูลว่าง / เสีย / timer
- test: EDGE_first_open_no_data_all_zero_P2_first
- test: EC4_EDGE_corrupt_storage_all_three_fallback_zero
- test: UI_dispose_cancels_alert_timer
=== จบ app/test/dashboard/dashboard_controller_test.dart ===

=== app/test/dashboard/dashboard_logic_test.dart (เฉพาะชื่อ test/group) ===
- group: AC-1 คะแนนรวม = (Food + Steps + Water) / 3
- test: GR3_row1_food60_steps90_water60_total70_bubbly
- test: DECIDED_R3_GR3_row2_EC5_food70_steps60_water67_total65_bubbly
- test: GR3_row3_EC4_food_minus10_steps90_water90_food0_total60_dazed
- test: GR4_EC1_food100_steps100_water160_cap100_cheerful
- test: EC1_all_categories_over_target_snapshot_total_100
- test: DECIDED_R3_EC5_total_is_integer_floor_65_67_and_65_33_to_65
- test: EC4_null_and_negative_category_become_0
- test: EDGE_empty_first_open_all_zero_crying
- test: EDGE_category_min_max_0_and_100_never_outside
- group: D-3 คะแนนรายหมวด
- test: DECIDED_Q14_water_target_8_cups_score_per_cup
- test: DECIDED_D3_steps_ratio_round_and_cap
- test: DECIDED_D3_food_up_to_target_kcal_over_target_x100
- test: DECIDED_D3_food_over_target_100_minus_over_percent
- test: EDGE_D3_food_far_over_target_floor_0_not_negative
- test: DECIDED_D3_Q1_food_no_target_not_scored_total_avg_of_2
- test: DECIDED_Q1_no_target_can_reach_100_cheerful
- test: DECIDED_R3_total_floor_of_floored_category_scores
- test: DECIDED_R3_EDGE_100_only_when_target_reached
- test: DECIDED_R3_Q1_no_target_total_floor_of_half
- group: AC-2 อารมณ์สัตว์เลี้ยง
- test: AC2_EDGE_mood_at_$score
- test: AC2_EDGE_boundaries_via_snapshot_30_31_60_61_80_81
- test: DECIDED_R3_mood_from_floored_total_30_67_is_crying
- test: DECIDED_D1_pose_mapping_PetCharacter
- group: AC-3 คิวข้อความ (trigger / removal)
- test: AC3_exact_strings_4_priorities
- test: AC3_empty_day_queue_P2_P3_P4_in_priority_order
- test: GR3_row1_example_queue_P2_P3_only
- test: AC3_EDGE_P1_overeat_threshold_2100_not_2101_yes
- test: DECIDED_Q2_no_target_never_P1
- test: AC3_EDGE_P2_water_7_cups_in_8_cups_out
- test: AC3_EDGE_P3_steps_99pct_in_100pct_out
- test: DECIDED_D4_EDGE_P4_food_score_49_in_50_out
- test: DECIDED_Q3_P4_no_meal_in_even_with_target
- test: DECIDED_Q3_P4_logged_but_still_below_50_stays
- test: DECIDED_Q3_P4_no_target_only_no_meal_rule
- test: DECIDED_R3_A7_P4_far_over_target_food_score_below_50_not_in_queue
- test: AC3_queue_empty_when_all_resolved
- group: AC-3 / EC-2 การหมุนเวียน (pure)
- test: AC3_next_alert_loops_in_priority_order
- test: EC2_GR4_P1_removed_while_showing_next_is_P2
- test: EC2_last_item_removed_wraps_to_head
- test: EC2_only_item_removed_queue_empty_null
=== จบ app/test/dashboard/dashboard_logic_test.dart ===

=== app/test/dashboard/dashboard_screens_test.dart (เฉพาะชื่อ test/group) ===
- group: AC-4 องค์ประกอบของ S-1
- testWidgets: AC4_total_card_pet_and_three_bars_present
- testWidgets: UI_layout_order_card_alert_pet_food_steps_water
- testWidgets: DECIDED_Q8_header_title
- testWidgets: UI_bar_labels_format_and_bar_value_equals_score
- testWidgets: UI_card_and_bubble_colors_from_color_scheme
- testWidgets: UI_loading_shows_only_progress_indicator
- group: AC-1 คะแนนรวมบนจอ
- testWidgets: AC1_GR3_row1_equivalent_60_100_50_shows_70_bubbly
- testWidgets: DECIDED_R3_EC5_GR3_row2_equivalent_65_67_shows_65_bubbly
- testWidgets: EC4_GR3_row3_negative_food_shows_0_total_60_dazed
- testWidgets: EC1_GR4_over_target_everywhere_capped_100_cheerful
- testWidgets: AC1_EC5_total_text_is_integer_no_decimal
- testWidgets: EDGE_EC4_first_open_empty_all_0_crying_P2
- testWidgets: EC4_EDGE_corrupt_storage_no_crash_all_0
- testWidgets: UI_realtime_update_when_source_changes
- group: AC-2 อารมณ์สัตว์เลี้ยง
- testWidgets: AC2_EDGE_total_${total}_is_$mood
- testWidgets: DECIDED_D1_PetCharacter_size_200_no_png
- testWidgets: DECIDED_Q20_no_cheerTrigger_and_state_kept_on_mood_change
- testWidgets: AC2_animated_cheerful_runs_with_pump_duration
- group: AC-3 ฟองข้อความ
- testWidgets: AC3_rotates_every_5s_P2_P3_P4_P2
- testWidgets: AC3_P1_exact_text_shown_once_red_food_bar_DECIDED_R3_92
- testWidgets: AC3_EDGE_P1_2100_not_red_2101_red
- testWidgets: EC2_resolve_shown_P2_switches_without_waiting
- testWidgets: AC3_EDGE_empty_queue_hides_banner_keeps_slot
- testWidgets: UI_slot_height_constant_and_pet_still_while_rotating
- testWidgets: UI_alert_slot_bottom_12px_above_pet_box
- group: DECIDED_Q1 ไม่มีเป้าอาหาร
- testWidgets: DECIDED_Q1_no_target_label_color_bar0_total_avg2
- group: AC-5 / EC-3 ข้าม 05:00
- testWidgets: AC5_EC3_EDGE_open_04_59_59_then_05_00_00_resets_screen
- testWidgets: AC5_resume_after_05_00_resets
- group: ทางเข้าจาก water
- testWidgets: DECIDED_Q7_entry_button_icon_tooltip_position
- testWidgets: DECIDED_Q7_tap_opens_S1_with_same_controllers_and_back
- group: DECIDED_R3 CTA ตั้งโปรไฟล์
- testWidgets: DECIDED_R3_Q5_no_target_shows_food_cta_under_food_bar
- testWidgets: DECIDED_R3_Q5_with_target_no_cta
- testWidgets: DECIDED_R3_Q5_tap_cta_opens_food_profile_screen
- testWidgets: DECIDED_R3_Q5_360_scale_${scale}_cta_no_overflow
- group: DECIDED_R3 AppBar หน้า water
- testWidgets: DECIDED_R3_Q7_report_button_icon_only_tooltip
- testWidgets: DECIDED_R3_Q7_water_appbar_360_scale_${scale}_no_overflow
- group: จอ 360×640
- testWidgets: UI_360_scale_1_0_via_water_P1_full_no_overflow
- testWidgets: UI_360_scale_1_0_water_appbar_three_icons_no_overflow
- testWidgets: UI_360_scale_1_5_P1_full_no_overflow
- testWidgets: DECIDED_Q1_360_scale_${scale}_no_target_label_no_overflow
- testWidgets: UI_360_scale_1_5_can_scroll_to_water_bar
=== จบ app/test/dashboard/dashboard_screens_test.dart ===

=== app/test/dashboard/dashboard_test_helpers.dart (เฉพาะชื่อ test/group) ===
(ไม่พบชื่อเทสต์)
=== จบ app/test/dashboard/dashboard_test_helpers.dart ===

=== app/test/food/food_controller_test.dart (เฉพาะชื่อ test/group) ===
- group: AC-5..7 เป้าหมายจากโปรไฟล์ (Q-13)
- test: AC5_profile_male_25_target_2000_and_empty_text
- test: AC6_underweight_profile_target_2400
- test: AC7_overweight_profile_target_1600
- test: DECIDED_Q13_existing_profile_does_not_need_S3
- test: DECIDED_Q13_no_profile_needs_S3
- test: DECIDED_Q13_save_from_S3_computes_target_and_closes_setup
- test: AC4_EC5_controller_refuses_decimal_age_nothing_saved
- test: DECIDED_Q14_decimal_weight_height_saved_as_decimal
- group: DECIDED Q-13 โปรไฟล์จาก signup S-6 (SignupFoodProfileSource)
- test: DECIDED_Q13_signup_profile_gives_target_without_S3
- test: DECIDED_Q13_signup_session_without_profile_needs_S3
- test: DECIDED_Q13_S3_saves_back_to_signup_profile_keeps_name_and_goal
- group: DECIDED Q-9 / US-3 ข้ามโปรไฟล์
- test: DECIDED_Q9_skip_shows_cta_no_target
- test: DECIDED_Q9_skipped_never_over_limit_no_toast_no_badge
- test: AC8_cta_total_text_contains_daily_total
- test: US3_skip_is_persisted
- group: GR2 ท่าชั่วคราว EATING 2 วินาที
- test: GR2_log_shows_eating_then_normal_after_exactly_2s
- test: GR3_male_25_from_0_to_1900_normal_after_eating
- test: AC12_no_toast_when_not_over_limit
- group: AC-9 / AC-10 / AC-11 / EC-3 เกินเป้า
- test: AC9_GR3_1950_plus_100_is_2050_normal_not_red
- test: AC9_EDGE_landing_exactly_on_2100_stays_normal
- test: AC10_GR3_2000_plus_150_eating_then_over_limit
- test: AC10_EDGE_landing_on_2101_goes_over_limit
- test: DECIDED_Q5_full_badge_and_red_immediately_during_eating
- test: AC10_loaded_over_limit_shows_over_limit_pose
- test: AC11_GR3_2150_plus_100_feeding_and_toast
- test: EC3_AC11_every_repeated_log_shows_feeding_and_toast
- test: ASSUMPTION_Q3_feeding_returns_to_over_limit_after_2s
- test: ASSUMPTION_7_log_during_eating_after_crossing_counts_as_over_limit
- group: AC-12 / EC-2 Toast 5 วินาที + Queue replace
- test: AC12_toast_visible_until_exactly_5s
- test: EC2_second_log_within_5s_replaces_toast_and_restarts_5s
- test: ASSUMPTION_Q4_rapid_log_restarts_transient_pose
- group: AC-1 / AC-2 / EC-1 ประมวลผลเมนู
- test: AC1_menu_text_parsed_and_logged_with_flags
- test: AC2_range_menu_logs_median
- test: EC1_offline_submit_is_parse_failed_nothing_logged
- test: DECIDED_Q17_unknown_menu_is_parse_failed
- test: EC1_manual_blank_logs_300
- test: EC1_manual_typed_value_logged
- testWidgets: AC1_EDGE_result_at_2_9s_is_used
- testWidgets: AC1_EC1_EDGE_no_result_within_3s_is_failure
- group: AC-3 / Foreground crossing / storage
- test: AC3_log_at_03_00_day_15_stored_date_is_2026_10_14
- test: GR4_refresh_day_at_05_00_resets_to_0_without_reload
- test: GR4_EDGE_midnight_does_not_reset
- test: EDGE_new_day_log_after_over_limit_day_is_eating_no_toast
- test: EDGE_reload_same_day_restores_total
- test: EDGE_reopen_after_05_00_starts_new_day_at_0
- test: EDGE_first_run_empty_storage_starts_at_0_normal
- test: EDGE_corrupted_storage_wrong_types_does_not_crash
- test: EDGE_stored_negative_total_clamped_to_0
- test: EDGE_repository_throws_starts_empty_and_logging_still_works
- test: EDGE_profile_source_throws_treated_as_no_target
- group: R2 DECIDED ค่าที่ Dev เลือก (controller)
- test: DECIDED_R2_Q10_signup_profile_gender_unspecified_is_cta_not_S3
- test: DECIDED_R2_Q10_signup_profile_without_weight_height_is_cta_not_S3
- test: DECIDED_R2_Q8_over_limit_feeding_lasts_2s_then_over_limit
=== จบ app/test/food/food_controller_test.dart ===

=== app/test/food/food_logic_test.dart (เฉพาะชื่อ test/group) ===
- group: GR1 ค่าหลัก game-rules §1
- test: GR1_constants_match_game_rules
- test: GR1_screen_texts_match_ux_flow
- group: AC-3 / US-5 รอบตัดวัน 05:00
- test: AC3_03_00_of_day_15_is_logical_day_14
- test: AC3_EDGE_04_59_59_is_day_14_and_05_00_00_is_day_15
- test: AC3_EDGE_midnight_does_not_start_new_day
- test: AC3_EDGE_month_boundary_1st_04_00_is_last_day_of_previous_month
- test: AC3_log_at_03_00_day_15_entry_date_is_day_14
- test: AC3_EDGE_first_ever_log_at_03_00_day_15_goes_to_day_14
- test: AC3_log_at_05_00_day_15_starts_day_15_from_0
- test: GR4_rollover_at_05_00_resets_to_0_and_keeps_previous_day_in_history
- test: GR4_rollover_under_target_day_is_not_over_target
- test: US5_EDGE_history_keeps_recent_days_and_drops_older_than_7_days
- group: AC-4 / EC-5 อายุจำนวนเต็ม 1–120
- test: AC4_age_25_5_is_rejected
- test: EC5_age_20_5_is_rejected
- test: AC4_EDGE_age_boundaries_0_invalid_1_valid_120_valid_121_invalid
- test: AC4_EDGE_non_integer_texts_rejected
- test: AC4_EDGE_empty_age_is_not_an_error_but_cannot_save
- test: AC4_decimal_age_blocks_save_even_with_other_fields_valid
- test: DECIDED_Q14_weight_and_height_accept_decimals
- group: AC-5 Base Target Reference Table
- test: AC5_male_25_base_target_is_2000
- test: AC5_EDGE_every_band_min_and_max_age_male_and_female
- test: GR5_age_1_to_9_uses_10_12_band_fallback
- test: AC5_male_25_normal_bmi_target_is_2000
- group: AC-6 / AC-7 ปรับตาม BMI
- test: GR1_bmi_formula_weight_over_height_m_squared
- test: AC6_bmi_below_18_5_adds_400
- test: AC6_EDGE_bmi_18_4_adds_400_bmi_18_5_exact_no_bonus
- test: AC7_bmi_at_least_23_subtracts_400
- test: AC7_EDGE_bmi_22_9_no_change_bmi_23_0_exact_subtracts_400
- test: AC6_AC7_adjustment_applies_on_other_bands
- group: AC-9 / AC-10 / EC-3 เกณฑ์ OVER_LIMIT (> target + 100)
- test: GR3_examples_1900_and_2050_normal_2150_over_limit
- test: AC9_EDGE_exactly_target_plus_100_is_normal
- test: AC10_EDGE_target_plus_101_is_over_limit
- test: AC9_EDGE_other_targets_boundary_plus_100_and_plus_101
- test: DECIDED_Q9_no_target_is_never_over_limit
- test: AC11_log_while_over_limit_gives_feeding_and_toast
- test: GR2_log_while_not_over_limit_gives_eating_no_toast
- test: GR2_eating_lasts_2_seconds
- test: ASSUMPTION_Q3_over_limit_feeding_lasts_same_as_eating
- test: GR2_state_codes_match_game_rules
- test: DECIDED_OQ1_states_map_to_PetCharacter_food_poses
- group: หลอดพลังงาน / ข้อความ S-1
- test: UI_calorie_text_format_examples
- test: UI_empty_state_0_of_target
- test: EDGE_energy_fraction_half_and_capped_at_1
- group: AC-1 / AC-2 / EC-1 ผลโภชนาการ
- test: AC1_parse_example_json_from_requirements
- test: AC1_nutrition_toJson_has_three_keys
- test: DECIDED_Q17_local_parser_returns_ac1_json_from_menu_table
- test: DECIDED_Q17_menu_not_in_table_is_parse_failure
- test: AC2_median_of_range
- test: AC2_range_calories_in_json_use_median
- test: ASSUMPTION_AC2_range_as_text_or_min_max_object_use_median
- test: AC2_local_parser_range_menu_item_gives_median
- test: EC1_unreadable_json_is_failure
- test: EC1_manual_blank_defaults_to_300
- test: EC1_manual_value_is_used_as_typed
- group: EDGE เพดาน / ค่าต่ำสุด
- test: EDGE_total_never_below_0_on_negative_calories
- test: EDGE_repeated_logs_accumulate_without_cap
- test: EDGE_first_run_rollover_starts_today_at_0
- group: R2 DECIDED ค่าที่ Dev เลือก (เดิมไม่ได้ assert)
- test: DECIDED_R2_Q2_bmi_not_rounded_18_46_counts_as_underweight
- test: DECIDED_R2_Q2_bmi_not_rounded_22_96_counts_as_normal
- test: DECIDED_R2_Q3_is_over_target_uses_plus_100_threshold
- test: DECIDED_R2_Q4_history_7_days_includes_today
- test: DECIDED_R2_Q6_median_half_rounds_up
- test: DECIDED_R2_Q9_dev_menu_table_values_used
- test: DECIDED_R2_Q11_manual_calories_0_is_accepted
=== จบ app/test/food/food_logic_test.dart ===

=== app/test/food/food_screens_test.dart (เฉพาะชื่อ test/group) ===
- group: S-1 แดชบอร์ด
- testWidgets: UI_S1_add_meal_button_text_per_ux_flow
- testWidgets: ASSUMPTION_Q2_S1_title_proposed
- testWidgets: EDGE_S1_empty_state_0_of_2000_bar_0_normal_pose
- testWidgets: GR3_S1_1900_of_2000_normal_primary_bar
- testWidgets: AC9_S1_2050_of_2000_not_red_normal_pose_no_badge
- testWidgets: AC9_EDGE_S1_2100_exact_threshold_not_red
- testWidgets: AC10_EDGE_S1_2101_red_over_limit_badge
- testWidgets: AC10_S1_2150_red_bar_full_over_limit_pose_full_badge_text
- testWidgets: DECIDED_OQ1_S1_PetCharacter_pose_for_each_state
- testWidgets: GR2_S1_log_shows_eating_then_normal_after_2s
- testWidgets: AC10_DECIDED_Q5_crossing_log_red_and_badge_now_pose_after_2s
- testWidgets: AC11_EC3_log_while_over_limit_feeding_pose_and_toast
- testWidgets: EC3_AC11_toast_shows_again_on_every_repeated_log
- testWidgets: AC12_toast_bottom_is_12px_above_pet_top
- testWidgets: AC12_toast_stays_5s_then_disappears_pet_does_not_move
- testWidgets: EC2_AC12_rapid_logs_within_5s_single_toast_replaced
- testWidgets: EC2_rapid_logs_via_S2_single_toast
- testWidgets: GR4_foreground_crossing_05_00_resets_to_0
- testWidgets: GR4_resume_after_05_00_resets_to_0
- testWidgets: ASSUMPTION_Q1_entry_button_after_steps_before_report_tooltip
- testWidgets: UI_entry_from_water_home_opens_S1
- group: AC-8 / EC-4 CTA Banner
- testWidgets: DECIDED_Q13_no_profile_opens_S3_automatically
- testWidgets: DECIDED_Q13_existing_profile_does_not_open_S3
- testWidgets: DECIDED_Q13_signup_profile_shows_bar_without_S3
- testWidgets: AC8_EC4_skip_shows_cta_banner_text_and_total
- testWidgets: AC8_EC4_cta_banner_same_size_as_energy_widget_no_layout_shift
- testWidgets: GR4_AC8_cta_to_S3_save_replaces_banner_with_bar
- testWidgets: AC8_cta_tap_opens_S3
- testWidgets: DECIDED_Q9_skipped_logging_never_red_no_toast_no_badge
- testWidgets: DECIDED_Q13_skip_persists_S3_not_reopened_on_reentry
- group: S-2 เพิ่มเมนูอาหาร
- testWidgets: UI_S2_hint_submit_text_no_manual_field_in_normal_state
- testWidgets: UI_S2_back_button_returns_to_S1
- testWidgets: AC1_menu_logged_back_to_S1_with_parsed_calories
- testWidgets: AC2_range_menu_logs_median_500
- testWidgets: EC1_offline_switches_to_manual_form_menu_text_kept
- testWidgets: EC1_manual_left_blank_logs_300
- testWidgets: EC1_manual_typed_450_logged
- testWidgets: EC1_EDGE_manual_field_digits_only
- testWidgets: DECIDED_R2_Q11_manual_field_max_5_digits
- testWidgets: DECIDED_R2_Q11_manual_0_is_logged_as_0
- testWidgets: DECIDED_Q17_menu_not_in_local_table_shows_manual_form
- testWidgets: AC1_EC1_EDGE_no_result_within_3s_shows_manual_form
- testWidgets: AC1_EDGE_result_at_2_9s_is_logged
- group: S-3 ตั้งค่าโปรไฟล์
- testWidgets: UI_S3_hints_gender_options_and_button_texts_per_ux_flow
- testWidgets: UI_S3_field_order_age_gender_weight_height
- testWidgets: AC4_EC5_DECIDED_Q14_age_20_5_cannot_be_entered_or_saved
- testWidgets: AC4_DECIDED_Q14_age_25_5_cannot_be_entered_or_saved
- testWidgets: DECIDED_Q14_dot_after_20_is_rejected_field_stays_20
- testWidgets: AC4_EDGE_age_${age}_shows_inline_error_and_blocks_save
- testWidgets: AC4_EDGE_age_${age}_valid_no_error_save_enabled
- testWidgets: DECIDED_Q14_weight_height_accept_decimals
- testWidgets: AC5_save_male_25_normal_bmi_S1_shows_target_2000
- testWidgets: AC6_save_underweight_S1_shows_target_2400
- testWidgets: AC7_save_overweight_S1_shows_target_1600
- testWidgets: AC5_female_30_normal_bmi_target_1600
- testWidgets: UI_S3_skip_button_always_enabled
- testWidgets: UI_S3_no_back_button_in_app_bar
- group: UI อื่น ๆ
- testWidgets: UI_360dp_S1_bar_cta_S2_S3_no_overflow
- testWidgets: UI_360dp_${tag}_S1_bar_over_limit_badge_and_toast_no_overflow
- testWidgets: UI_360dp_${tag}_S1_bar_long_totals_no_overflow
- testWidgets: UI_360dp_${tag}_S1_cta_long_totals_no_overflow
- testWidgets: AC8_DECIDED_D5_360dp_${tag}_cta_total_long_number_not_truncated
- testWidgets: UI_360dp_${tag}_S3_S2_normal_and_manual_no_overflow
- testWidgets: AC8_EC4_360dp_${tag}_switch_cta_to_bar_no_layout_shift
- testWidgets: AC8_EC4_360dp_${tag}_bar_vs_cta_same_slot_pet_button
- testWidgets: DECIDED_D5_energy_slot_at_least_88_and_grows_with_text_scale
- test: DECIDED_OQ1_no_lottie_package_and_no_pet_json_assets_in_food
=== จบ app/test/food/food_screens_test.dart ===

=== app/test/food/food_test_helpers.dart (เฉพาะชื่อ test/group) ===
(ไม่พบชื่อเทสต์)
=== จบ app/test/food/food_test_helpers.dart ===

=== app/test/shared/pet/pet_character_test.dart (เฉพาะชื่อ test/group) ===
- group: §5 preset 7 ท่า
- test: POSE_${e.key}_is_${expr.name}_${body.name}
- testWidgets: PAINT_${e.key}_static_face_${face.name}
- test: POSE_all_7_presets_are_distinct
- test: POSE_equality_and_copyWith
- group: §4 สถานะต่ำ เหงื่อ/ตาปรือ
- testWidgets: LOW_${e.key}_sweat_${low}_droopy_$low
- test: LOW_sparkles_only_on_happy_and_proud_faces
- test: LOW_blink_keeps_mood_but_closes_eyes
- test: LOW_action_faces_override_expression
- group: §3 รูปร่าง
- test: BODY_dimensions_match_character_md_table
- test: BODY_all_5_shapes_have_different_size
- test: BODY_fat_is_widest_and_flattest_lean_is_narrowest
- test: BODY_fat_hides_thighs_and_has_belly_roll
- test: BODY_muscle_has_big_muscle_thighs_others_not
- test: BODY_lean_has_long_thin_thighs
- group: animate: false (ภาพนิ่ง)
- testWidgets: STATIC_no_tickers_no_timers_pumpAndSettle_completes
- testWidgets: STATIC_tap_calls_onTap_but_no_jump
- testWidgets: STATIC_cheerTrigger_change_does_not_animate
- group: animate: true
- testWidgets: ANIM_breathes_and_painter_animated_true
- testWidgets: ANIM_tap_jump_funny_then_none_after_650ms
- testWidgets: ANIM_reactToTap_false_no_jump_but_onTap_called
- testWidgets: ANIM_cheerTrigger_change_cheers_then_ends_after_900ms
- testWidgets: ANIM_cheerTrigger_decrease_also_cheers
- testWidgets: ANIM_same_cheerTrigger_on_rebuild_does_not_cheer
- testWidgets: ANIM_tap_during_cheer_does_not_interrupt
- testWidgets: ANIM_toggle_animate_true_to_false_stops_tickers
- group: กะพริบตา (Random seed)
- testWidgets: BLINK_same_seed_same_blink_timeline
- testWidgets: BLINK_first_blink_within_doc_gap_and_short
- group: dispose
- testWidgets: DISPOSE_animated_pet_leaves_no_tickers_or_timers
- testWidgets: DISPOSE_while_cheering_no_exception
=== จบ app/test/shared/pet/pet_character_test.dart ===

=== app/test/shared/pet/pet_screens_cheer_test.dart (เฉพาะชื่อ test/group) ===
- group: water S-1
- testWidgets: CHEER_water_log_success_increments_trigger_and_pet_cheers
- testWidgets: CHEER_water_3_to_4_cups_cheers_and_switches_to_tired_pose
- testWidgets: CHEER_water_6_to_7_cups_cheers_and_switches_to_happy_pose
- testWidgets: CHEER_water_4_to_5_cups_same_mood_cheers
- testWidgets: STATE_water_3_to_4_cups_pet_state_survives_and_keeps_breathing
- testWidgets: CHEER_water_blocked_by_anti_spam_does_not_cheer
- testWidgets: CHEER_water_after_5_minutes_cheers_again_count_2
- testWidgets: DEFAULT_water_animatePet_null_is_static_under_flutter_test
- group: steps S-1
- testWidgets: CHEER_steps_add_success_increments_trigger_and_pet_cheers
- testWidgets: CHEER_steps_two_adds_count_2
- testWidgets: CHEER_steps_add_crossing_35_percent_cheers_and_shows_chubby
- testWidgets: STATE_steps_crossing_35_percent_pet_state_survives
- testWidgets: CHEER_steps_locked_${status.name}_add_does_not_cheer
- testWidgets: POSE_steps_${steps}_of_8000_is_${pose.id}
=== จบ app/test/shared/pet/pet_screens_cheer_test.dart ===

=== app/test/signup/signup_logic_test.dart (เฉพาะชื่อ test/group) ===
- group: game-rules §1 ค่าหลัก
- test: RULES_game_rules_s1_constants_match_doc
- group: AC-1 / AC-3 ความยาวรหัสผ่าน (min_password_length = 6)
- test: AC1_password_5_chars_abcde_shows_error_and_cannot_submit
- test: AC1_password_1_char_shows_error
- test: AC1_EDGE_password_exactly_6_no_error_can_submit
- test: AC3_new_password_5_rejected_6_accepted
- test: ASSUMPTION_Q3_empty_password_no_error_but_cannot_submit
- group: AC-4 / AC-5 Display Name จากหน้าอีเมล
- test: AC4_empty_display_name_uses_email_local_part
- test: AC4_typed_display_name_is_kept
- test: AC5_alexander_truncates_to_alex_dots_er
- test: AC5_EDGE_email_name_exactly_8_chars_not_truncated
- test: AC5_EDGE_email_name_9_chars_truncated_4_dots_2
- test: AC5_display_for_ui_profile_from_email_alexander
- test: AC5_long_email_name_over_20_shows_first4_dots_last2_of_email_name
- test: DECIDED_Da_email_name_over_20_saved_full_not_capped
- test: DECIDED_Da_EC3_typed_display_name_20_kept_21_capped_to_20
- group: AC-6 / AC-7 คำเตือน (ไม่บล็อกการบันทึก — fallback game-rules §5)
- test: AC6_unspecified_gender_shows_warning_male_female_do_not
- test: AC7_empty_weight_only_warns_weight
- test: AC7_empty_height_only_warns_height
- test: AC6_AC7_warnings_do_not_block_save_values_stay_null
- group: EC-2 ขอบเขตตัวเลข (game-rules §1, §4 — รวมขอบ)
- test: EC2_age_1_and_120_valid
- test: EC2_age_0_and_121_out_of_range
- test: EC2_weight_1_and_300_valid_0_and_301_out_of_range
- test: EC2_weight_float_just_outside_bounds_out_of_range
- test: EC2_height_1_and_250_valid_0_and_251_out_of_range
- test: EC2_any_out_of_range_field_blocks_save
- test: DECIDED_Dc_age_non_integer_text_is_not_valid
- test: DECIDED_Dc_buildProfile_non_integer_age_returns_null
- test: DECIDED_Dc_EDGE_integer_age_25_still_valid
- test: ASSUMPTION_Q11_empty_age_blocks_save
- group: ค่าเริ่มต้น / Onboarding (game-rules §1)
- test: DEFAULT_health_goal_saved_as_dulae_sukkhaphap
- test: ASSUMPTION_Q10_cleared_health_goal_saves_default
- test: ASSUMPTION_unknown_gender_code_falls_back_to_unspecified
- group: การนำทาง (ux-flow §3, AC-2, AC-8)
- test: AC8_route_loading_then_welcome_without_session
- test: AC8_route_home_when_session_with_profile
- test: AC2_route_onboarding_when_google_linked_even_with_profile
- test: UXFLOW_step4_new_account_without_profile_goes_onboarding
=== จบ app/test/signup/signup_logic_test.dart ===

=== app/test/signup/signup_repository_test.dart (เฉพาะชื่อ test/group) ===
- group: AC-2 / EC-5 อีเมลซ้ำ
- test: EC5_signup_with_registered_email_returns_email_in_use
- test: AC2_signup_same_email_twice_second_is_rejected
- test: ASSUMPTION_7_email_duplicate_is_case_insensitive
- test: AC2_google_with_email_registered_normally_links_and_goes_onboarding
- test: AC2_google_link_goes_onboarding_even_if_profile_exists
- group: AC-3 รีเซ็ตรหัสผ่าน
- test: AC3_controller_rejects_5_char_new_password_old_password_still_works
- test: AC3_repository_rejects_short_password
- test: AC3_EDGE_new_password_exactly_6_saved_and_usable
- test: US3_request_password_reset_is_recorded
- test: AC1_repository_rejects_signup_with_5_char_password
- group: AC-4 / US-4 บันทึกโปรไฟล์
- test: AC4_save_without_display_name_stores_email_local_part
- test: US4_save_stores_all_fields
- test: EC2_controller_refuses_out_of_range_profile
- test: DECIDED_Dc_controller_refuses_non_integer_age
- test: DECIDED_Da_long_email_name_saved_full_home_shows_abcd_dots_yz
- group: EC-1 / EC-4 เน็ตหลุด แล้ว Retry
- test: EC1_google_network_error_then_retry_succeeds
- test: EC4_save_network_error_keeps_onboarding_then_retry_saves
- group: AC-8 Session / เปิดแอปใหม่ (US-5)
- test: AC8_reopen_with_same_store_restores_session_and_goes_home
- test: AC8_token_is_stored_on_device_not_empty
- test: REQ6_password_is_stored_hashed_not_plain
- test: EDGE_first_open_empty_storage_goes_welcome
- test: EDGE_corrupt_session_data_goes_welcome_without_crash
- test: EDGE_session_for_missing_account_goes_welcome
- test: EDGE_Dc_stored_fractional_age_not_rounded_on_load
- test: US5_sign_out_clears_session_reopen_goes_welcome
- test: DECIDED_Db_19_session_saved_at_signup_reopen_before_onboarding_goes_onboarding
- group: S-2 โหมดเข้าสู่ระบบ
- test: LOGIN_registered_account_without_profile_goes_onboarding
- test: ASSUMPTION_2_wrong_password_returns_invalid_credentials
=== จบ app/test/signup/signup_repository_test.dart ===

=== app/test/signup/signup_screens_test.dart (เฉพาะชื่อ test/group) ===
- group: S-1 หน้าต้อนรับ
- testWidgets: UI_S1_texts_per_ux_flow_and_first_open_shows_welcome
- testWidgets: UI_S1_email_button_opens_S2_signup_mode
- testWidgets: UI_S1_have_account_link_opens_S2
- group: S-2 สมัครด้วยอีเมล
- testWidgets: UI_S2_hints_and_initial_state_button_disabled_no_error
- testWidgets: AC1_password_abcde_shows_error_immediately_button_disabled
- testWidgets: AC1_EDGE_password_6_chars_no_error_button_enabled
- testWidgets: UXFLOW_happy_path_signup_goes_to_onboarding_S6
- testWidgets: AC2_EC5_registered_email_shows_email_in_use_stays_on_S2
- testWidgets: ASSUMPTION_Q4_email_in_use_error_clears_when_email_edited
- testWidgets: ASSUMPTION_Q15_loading_spinner_and_disabled_while_submitting
- testWidgets: ASSUMPTION_3_S2_network_error_dialog_retry_succeeds
- testWidgets: UI_S2_back_button_returns_to_S1
- group: S-3 / S-4 / S-5 ลืมรหัสผ่าน (US-3)
- testWidgets: US3_forgot_flow_S2_to_S3_to_S4_and_back_to_S2
- testWidgets: UI_S3_back_button_returns_to_S2
- testWidgets: UI_S5_texts_and_initial_disabled
- testWidgets: AC3_new_password_5_chars_shows_warning_and_save_rejected
- testWidgets: AC3_EDGE_new_password_6_chars_saves_and_goes_S2_with_message
- group: S-1 Google Login (US-2, AC-2, EC-1)
- testWidgets: AC2_google_with_registered_email_links_and_goes_onboarding
- testWidgets: EC1_google_network_error_shows_retry_then_retry_succeeds
- testWidgets: EC1_retry_while_still_offline_shows_retry_again
- testWidgets: ASSUMPTION_Q16_retry_dialog_texts
- group: S-6 Onboarding
- testWidgets: UI_S6_texts_and_defaults_gender_unspecified_goal_default
- testWidgets: AC6_select_unspecified_shows_warning_male_hides_it
- testWidgets: AC7_empty_weight_warns_only_under_weight
- testWidgets: AC7_empty_height_warns_only_under_height
- testWidgets: AC6_AC7_warnings_do_not_block_save
- testWidgets: EC2_age_0_shows_error_and_blocks_save
- testWidgets: EC2_EDGE_age_120_ok_121_error
- testWidgets: EC2_EDGE_age_1_ok
- testWidgets: EC2_EDGE_weight_300_ok_301_error
- testWidgets: EC2_EDGE_weight_1_ok_0_error
- testWidgets: EC2_EDGE_height_250_ok_251_error
- testWidgets: EC2_EDGE_height_1_ok_0_error
- testWidgets: DECIDED_Dc_age_field_rejects_"$input"_not_changed_cannot_save
- testWidgets: DECIDED_Dc_age_field_existing_30_then_paste_2_5_never_saves_25
- testWidgets: DECIDED_Dc_EDGE_age_field_integer_25_saves_25
- testWidgets: DECIDED_Da_EC3_typed_20_char_name_saved_as_typed
- testWidgets: EC3_display_name_20_chars_accepted_21st_blocked
- testWidgets: EC4_save_network_error_shows_retry_and_keeps_all_values
- testWidgets: EC4_retry_after_network_back_saves_and_goes_home
- group: S-7 Home + AC-4/AC-5/AC-8
- testWidgets: AC4_AC5_empty_display_name_alexander_banner_shows_alex_dots_er
- testWidgets: AC5_EDGE_email_name_8_chars_banner_shows_full_name
- testWidgets: DECIDED_Da_long_email_name_banner_abcd_dots_yz_repo_stores_full
- testWidgets: AC8_reopen_app_skips_login_and_shows_home
- testWidgets: UI_auth_loading_spinner_while_reading_token
- testWidgets: EDGE_corrupt_stored_session_opens_S1_without_crash
- testWidgets: REGRESSION_no_signup_controller_goes_straight_to_water
=== จบ app/test/signup/signup_screens_test.dart ===

=== app/test/steps/steps_controller_test.dart (เฉพาะชื่อ test/group) ===
- group: AC-1 (MVP: เพิ่มก้าวด้วยมือ ui-spec D-1)
- test: AC1_add_steps_increments_by_steps_per_tap_and_persists
- test: AC1_add_before_load_is_ignored
- group: EC-1 / EC-6 ล็อกการนับก้าว
- test: EC1_EC6_${status.name}_locks_step_counting
- test: EC1_unlock_after_permission_granted_allows_counting
- group: AC-2 / AC-3 / S-2 Error ผ่าน controller
- test: AC2_saved_goal_written_to_storage_and_used_for_percent
- test: AC3_second_save_same_day_not_written
- test: S2_error_storage_failure_keeps_goal_and_quota_then_retry_works
- group: EC-2 ดึงค่าล่าสุดจาก Local Storage
- test: EC2_reload_same_day_shows_last_saved_steps
- test: EC2_AC6_reopen_after_05_00_starts_new_day_at_0
- test: EC2_reopen_at_04_59_59_still_previous_day_steps
- test: REQ7_pet_status_enum_stored_with_doc_codes
- group: EDGE ข้อมูลว่าง / ข้อมูลเสีย
- test: EDGE_first_run_empty_storage_shows_initial_state
- test: EDGE_corrupted_storage_wrong_types_does_not_crash
- test: EDGE_corrupted_history_items_skipped_valid_items_kept
- test: EDGE_stored_negative_steps_clamped_to_0
- test: EDGE_ASSUMPTION_stored_goal_outside_6000_15000_falls_back_to_default
- test: EDGE_repository_throws_starts_empty_without_crash
- group: AC-6 / EC-5 ผ่าน controller
- test: EC5_refresh_day_resets_at_05_00_00_without_reload
- group: AC-7 export ผ่าน controller
- test: AC7_export_passes_png_bytes_to_exporter
- test: AC7_export_failure_throws_for_ui_error_state
=== จบ app/test/steps/steps_controller_test.dart ===

=== app/test/steps/steps_logic_test.dart (เฉพาะชื่อ test/group) ===
- group: game-rules §1 ค่าหลัก
- test: GR1_constants_match_game_rules
- test: AC2_goal_options_are_the_three_groups_from_ux_flow
- group: AC-5 % Goal → สถานะ
- test: AC5_percent_formula_game_rules_example_2800_of_8000_is_35
- test: AC5_percent_not_capped_8500_of_8000_is_106_25
- test: AC5_status_for_percent_exact_boundaries
- test: EDGE_threshold_plus_minus_1_step_goal_8000
- test: EDGE_threshold_plus_minus_1_step_every_goal_option
- test: AC5_enum_codes_thai_labels_and_poses_per_docs
- test: AC5_pose_at_thresholds_2799_2800_5599_5600_7999_8000_of_8000
- group: ข้อความ S-1
- test: S1_count_text_format_ux_flow_example_5500_of_8000
- test: S1_percent_text_examples_from_ui_spec
- test: ASSUMPTION_Q7_percent_truncated_never_shows_100_while_lean
- group: EDGE max/min
- test: EDGE_energy_bar_capped_at_1_while_percent_exceeds_100
- test: EDGE_add_zero_or_negative_steps_never_decreases_below_0
- test: EDGE_goal_bounds_6000_15000_accepted_outside_rejected
- test: EDGE_invalid_goal_rejected_and_quota_not_consumed
- test: EDGE_quota_never_below_0
- group: AC-6 ตัดรอบ 05:00:00
- test: AC6_logical_day_changes_exactly_at_05_00_00
- test: AC6_game_rules_example_8500_resets_to_0_at_05_00_00
- test: AC6_midnight_does_not_reset
- test: AC6_previous_day_kept_in_history_after_reset
- test: AC6_several_days_closed_resets_to_0
- test: AC6_steps_added_after_05_00_count_only_for_new_day
- test: EDGE_first_run_no_data_starts_day_with_0_steps
- group: AC-2/AC-3/AC-4 เป้าหมาย
- test: AC2_ASSUMPTION_first_goal_new_user_applies_immediately
- test: AC2_every_goal_option_can_be_saved
- test: AC3_second_change_same_day_is_rejected
- test: AC3_quota_still_used_at_04_59_59_and_resets_at_05_00_00
- test: AC4_change_after_05_00_applies_from_next_day_05_00
- test: ASSUMPTION_AC2_change_before_05_00_applies_immediately
- group: EC-3 นาฬิกาย้อน
- test: EC3_clock_back_before_cutoff_does_not_reset_steps
- test: EC3_clock_back_does_not_restore_goal_quota
- test: EC3_clock_back_does_not_overwrite_previous_day_history
- test: EC3_real_cutoff_after_clock_back_still_resets
- group: AC-7 รายงานรายเดือน
- test: AC7_four_values_total_steps_water_average_goal_days
- test: AC7_goal_day_boundary_7999_not_counted_8000_counted
- test: AC7_month_follows_05_00_cutoff
- test: EDGE_empty_report_all_zero
- test: ASSUMPTION_Q6_average_divides_by_days_with_steps
- test: ASSUMPTION_Q7_goal_days_use_goal_of_that_day
- test: AC7_report_file_is_png
=== จบ app/test/steps/steps_logic_test.dart ===

=== app/test/steps/steps_screens_test.dart (เฉพาะชื่อ test/group) ===
- group: S-1 แดชบอร์ด
- testWidgets: UI_S1_texts_and_buttons_per_ux_flow
- testWidgets: UI_S1_ASSUMPTION_Q1_add_button_label_and_icon
- testWidgets: EDGE_S1_empty_first_run_0_steps_0_percent_fat
- testWidgets: AC1_tap_add_increases_steps_realtime
- testWidgets: AC5_tap_add_crosses_35_percent_changes_pet_immediately
- testWidgets: EDGE_AC5_S1_${steps}_of_8000_shows_${status.name}
- testWidgets: EDGE_S1_over_100_bar_full_text_106_25
- testWidgets: EC5_AC6_foreground_crossing_05_00_resets_without_restart
- testWidgets: EC1_EC6_${status.name}_popup_settings_shortcut_and_lock
- testWidgets: EC1_ASSUMPTION_Q4_popup_proposed_texts
- testWidgets: S1_disabled_offline_icon_and_last_stored_values
- testWidgets: UI_S1_navigation_to_S2_and_S3_and_back
- testWidgets: UI_D3_entry_from_water_home_opens_S1
- group: S-2 ตั้งเป้าหมาย
- testWidgets: UI_S2_title_chips_and_save_button_texts_per_ux_flow
- testWidgets: UI_S2_ASSUMPTION_Q9_group_headers
- testWidgets: EDGE_S2_first_entry_8000_preselected_only
- testWidgets: S2_only_one_chip_selected_across_groups
- testWidgets: AC2_save_new_goal_updates_S1_percent_immediately
- testWidgets: AC3_after_save_button_disabled_and_tap_shows_quota_toast
- testWidgets: AC3_ASSUMPTION_Q11_reenter_S2_shows_toast_and_chips_locked
- testWidgets: S2_error_toast_on_save_failure_retry_allowed
- testWidgets: AC4_change_after_05_00_applies_next_day_05_00_on_S1
- testWidgets: AC3_quota_resets_at_05_00_save_enabled_again
- group: S-3 รายงานรายเดือน
- testWidgets: UI_S3_title_labels_and_export_button_per_ux_flow
- testWidgets: AC7_S3_card_shows_four_values_from_storage
- testWidgets: EDGE_S3_empty_month_zero_values_and_empty_text
- testWidgets: AC7_export_png_of_report_area_saved_once
- testWidgets: S3_exporting_button_disabled_with_spinner_text
- testWidgets: S3_export_error_dialog_and_retry_succeeds
- testWidgets: S3_capture_failure_shows_error_dialog
- testWidgets: S3_load_failure_shows_error_dialog_retry_recovers
- group: UI จอ 360 dp
- testWidgets: UI_360dp_S1_S2_S3_no_overflow
=== จบ app/test/steps/steps_screens_test.dart ===

=== app/test/water/water_controller_test.dart (เฉพาะชื่อ test/group) ===
- group: Controller
- test: AC1_controller_log_adds_1_cup_and_12_5_percent
- test: AC3_AC4_controller_blocks_10_03_allows_10_05
- test: EC3_controller_rapid_taps_without_await_log_only_once
- test: AC5_controller_refresh_at_05_00_resets_to_0
- test: EC2_controller_load_after_05_00_resets_and_saves_0
- test: EDGE_first_open_empty_storage_0_cups_critical
- group: Local Storage (SharedPreferences) requirements §7
- test: STORAGE_save_uses_keys_from_requirements_section_7
- test: STORAGE_data_survives_reopen_same_day
- test: EC2_storage_reopen_next_day_after_05_00_shows_0
- test: EDGE_antispam_across_05_00_survives_app_restart
- test: EDGE_corrupted_history_json_does_not_crash_starts_fresh
- test: EDGE_corrupted_history_item_missing_fields_starts_fresh
- test: EDGE_corrupted_timestamp_treated_as_never_logged
- test: EDGE_missing_count_key_defaults_to_0
- test: EDGE_negative_stored_count_clamped_to_0
=== จบ app/test/water/water_controller_test.dart ===

=== app/test/water/water_decisions_logic_test.dart (เฉพาะชื่อ test/group) ===
- group: ข้อตัดสิน 1: ขอบเดือน AC-6 (00:00–04:59 ของวันที่ 1 = วันสุดท้ายของเดือนก่อน)
- test: AC6_log_04_59_on_1st_goes_to_history_as_last_day_of_previous_month
- test: AC6_log_05_00_on_1st_goes_to_history_as_new_month
- test: AC6_log_04_59_then_05_04_on_1st_split_into_two_months
- test: AC6_report_at_04_59_on_1st_is_previous_month
- test: AC6_report_at_05_00_on_1st_is_new_month
- test: AC6_year_boundary_01_01_04_59_is_december_previous_year
- group: ข้อตัดสิน 2: นาฬิกาย้อนกลับ (game-rules §4)
- test: EDGE_clock_back_to_previous_calendar_day_no_reset_same_day
- test: EDGE_clock_back_before_05_00_same_date_no_reset
- test: EDGE_clock_back_1_second_no_crash_no_reset
- test: EDGE_clock_back_log_attempt_does_not_delete_data_and_counts_same_day
- test: EDGE_clock_back_monthly_report_uses_same_day_as_last_log
- test: EDGE_clock_back_then_forward_next_day_after_05_00_resets_normally
- group: ข้อตัดสิน 4: วันที่หน้าประวัติ dd/MM/yyyy (ux-flow S-2)
- test: UI_history_date_format_dd_MM_yyyy_with_leading_zeros
- group: ข้อตัดสิน 5: อารมณ์ 0–3 / 4–6 / 7+ (game-rules §2) ขอบ 3/4 และ 6/7
- test: EDGE_mood_ranges_all_values_0_to_12
=== จบ app/test/water/water_decisions_logic_test.dart ===

=== app/test/water/water_decisions_screens_test.dart (เฉพาะชื่อ test/group) ===
- group: ข้อตัดสิน 5: ภาพสัตว์เลี้ยงตามอารมณ์ (PetCharacter) ขอบ 3/4 และ 6/7
- testWidgets: EDGE_S1_pet_mood_0_cups_critical
- testWidgets: AC2_S1_pet_mood_3_cups_critical_then_4_cups_tired
- testWidgets: EDGE_S1_pet_mood_6_cups_tired_then_7_cups_happy
- testWidgets: EDGE_S1_pet_mood_after_05_00_reset_back_to_critical
- group: ข้อตัดสิน 4: วันที่หน้าประวัติ dd/MM/yyyy
- testWidgets: UI_S2_history_dates_shown_as_dd_MM_yyyy
- group: ข้อตัดสิน 1: ขอบเดือน AC-6 บนหน้า S-2
- testWidgets: AC6_S2_log_04_59_on_1st_shown_as_31_10_in_october_report
- testWidgets: AC6_S2_log_05_00_on_1st_shown_as_01_11_in_november_report
- testWidgets: AC6_S2_open_at_05_00_on_1st_with_only_october_data_is_empty
- group: ข้อตัดสิน 2: นาฬิกาย้อนกลับ บนหน้าจอ
- testWidgets: EDGE_S1_clock_back_opens_without_crash_and_keeps_cups
- testWidgets: EDGE_S1_clock_back_tap_no_crash_and_no_data_loss
- testWidgets: EDGE_S2_clock_back_report_shows_month_of_last_log
- group: ข้อตัดสิน 3: ข้อมูลเสีย/ผิดชนิด บนหน้าจอ
- testWidgets: EDGE_S1_bad_type_prefs_opens_empty_state_no_crash
- testWidgets: EDGE_S2_bad_history_prefs_shows_empty_report_no_crash
=== จบ app/test/water/water_decisions_screens_test.dart ===

=== app/test/water/water_decisions_storage_test.dart (เฉพาะชื่อ test/group) ===
- group: ข้อตัดสิน 1: ขอบเดือน AC-6 ผ่าน controller
- test: AC6_controller_log_04_59_on_1st_report_shows_previous_month
- test: AC6_controller_report_at_05_00_on_1st_switches_to_new_month
- test: AC6_storage_history_key_saves_04_59_as_previous_day
- group: ข้อตัดสิน 2: นาฬิกาย้อนกลับ ผ่าน controller + storage
- test: EDGE_clock_back_open_app_no_crash_no_reset_keeps_data
- test: EDGE_clock_back_refresh_and_log_do_not_delete_stored_history
- test: EDGE_clock_back_monthly_report_is_month_of_last_log
- test: EDGE_clock_back_then_restored_same_day_keeps_cups
- group: ข้อตัดสิน 3: ข้อมูลเสีย/ผิดชนิดใน SharedPreferences → ค่าว่าง ไม่ crash
- test: EDGE_bad_type_count_as_string_starts_0_no_crash
- test: EDGE_bad_type_count_as_double_starts_0_no_crash
- test: EDGE_bad_type_count_as_bool_starts_0_no_crash
- test: EDGE_bad_type_timestamp_as_int_treated_empty_can_log
- test: EDGE_bad_type_history_as_int_starts_empty
- test: EDGE_bad_type_history_as_string_list_starts_empty
- test: EDGE_bad_type_history_json_object_not_list_starts_empty
- test: EDGE_bad_type_history_item_cups_as_string_starts_empty
- test: EDGE_bad_type_history_item_null_fields_starts_empty
- test: EDGE_all_keys_bad_type_starts_empty_state
- test: EDGE_bad_type_after_recovery_log_saves_correct_types
- test: EDGE_repository_load_throws_controller_starts_empty_no_crash
- test: EDGE_prefs_instance_fails_repository_returns_empty
=== จบ app/test/water/water_decisions_storage_test.dart ===

=== app/test/water/water_logic_test.dart (เฉพาะชื่อ test/group) ===
- group: AC-1 กด + แล้ว +1 แก้ว และพลังงาน +12.5% (game-rules §1, §3)
- test: AC1_first_log_of_day_0_to_1_cup_12_5_percent
- test: AC1_energy_formula_cups_x_12_5_for_0_to_8_cups
- test: AC1_each_successful_log_adds_exactly_1_cup_and_12_5_percent
- group: AC-2 สถานะสัตว์เลี้ยงตามช่วง (requirements §2, game-rules §2)
- test: AC2_3_cups_critical_then_4_cups_tired_immediately
- test: EDGE_threshold_0_and_3_critical_4_tired
- test: EDGE_threshold_6_tired_7_happy_8_happy
- test: AC2_mood_poses_match_game_rules_section_2_and_character_md
- group: AC-3 / AC-4 Anti-Spam 1 แก้วต่อ 5 นาที
- test: AC3_log_10_00_then_10_03_is_blocked_and_cups_unchanged
- test: AC4_log_10_00_then_10_05_is_allowed_and_last_log_is_10_05
- test: EDGE_threshold_4m59s_blocked_5m00s_allowed_6m_allowed
- test: EDGE_blocked_attempt_does_not_restart_5_minute_window
- test: EC3_rapid_taps_only_first_is_logged
- group: AC-5 / EC-2 รีเซ็ตเวลา 05:00 น.
- test: AC5_5_cups_at_04_59_stay_5_then_reset_to_0_at_05_00
- test: EDGE_midnight_is_not_reset_boundary
- test: EDGE_log_23_58_then_00_01_blocked_00_03_counts_on_same_day
- test: EC2_device_off_overnight_across_05_00_resets_on_open
- test: EC2_device_off_several_days_resets_on_open
- test: EDGE_after_05_00_reset_first_log_starts_from_1_cup
- test: EDGE_reset_keeps_previous_day_in_history
- test: EDGE_antispam_across_05_00_log_04_58_tap_05_01_blocked
- test: EDGE_antispam_across_05_00_05_02_59_blocked_05_03_allowed
- group: EC-1 / ค่าติดเพดาน max/min
- test: EC1_12_cups_bar_stops_at_100_but_count_is_12
- test: EDGE_cap_8_cups_exactly_100_and_9_cups_still_100
- test: EDGE_min_0_cups_is_0_percent_never_negative
- test: EDGE_count_keeps_increasing_past_cap_9_to_10
- group: AC-6 รายงานรายเดือน (ค่าเฉลี่ยทศนิยม 1 ตำแหน่ง)
- test: AC6_average_5_and_4_over_2_logged_days_is_4_5
- test: AC6_days_without_logs_are_not_in_divisor
- test: AC6_average_one_decimal_13_over_3_is_4_3
- test: AC6_average_one_decimal_20_over_3_is_6_7
- test: AC6_whole_number_average_shows_one_decimal_8_0
- test: AC6_other_months_are_excluded
- test: AC6_history_list_has_date_and_cups_per_day_sorted
- test: EDGE_empty_history_average_0_0_and_empty
- group: Edge 4 เปิดแอปครั้งแรก (ux-flow §4 S-1 ว่าง)
- test: EDGE_first_open_initial_state_0_cups_0_percent_critical
- test: EDGE_first_ever_log_is_allowed_without_previous_timestamp
=== จบ app/test/water/water_logic_test.dart ===

=== app/test/water/water_pet_character_test.dart (เฉพาะชื่อ test/group) ===
- group: S-1 ขอบสถานะ (game-rules §2) แสดงท่าของ PetCharacter
- testWidgets: POSE_S1_${cups}_cups_shows_${mood.name}
- testWidgets: POSE_S1_3_to_4_cups_switches_critical_to_tired
- testWidgets: POSE_S1_6_to_7_cups_switches_tired_to_happy
- testWidgets: POSE_S1_after_05_00_reset_happy_back_to_critical
- group: PNG สัตว์เลี้ยงเดิม (legacy) ไม่ถูกใช้/ไม่ถูก bundle
- test: LEGACY_files_kept_in_assets_images_legacy
- test: LEGACY_no_pet_png_in_top_level_assets_images
- test: LEGACY_pubspec_does_not_register_legacy_or_pet_png
- test: LEGACY_lib_has_no_pet_png_reference
- testWidgets: LEGACY_asset_manifest_has_no_pet_png_and_load_fails
=== จบ app/test/water/water_pet_character_test.dart ===

=== app/test/water/water_screens_test.dart (เฉพาะชื่อ test/group) ===
- group: S-1 หน้าจอหลัก
- testWidgets: UI_S1_button_label_and_plus_icon_per_ux_flow
- testWidgets: EDGE_S1_first_open_shows_0_cups_0_percent_critical
- testWidgets: AC1_S1_tap_plus_shows_1_cup_and_12_5_percent
- testWidgets: AC2_S1_3_to_4_cups_status_changes_critical_to_tired
- testWidgets: EDGE_S1_6_to_7_cups_status_changes_tired_to_happy
- testWidgets: AC3_S1_tap_within_5_min_shows_toast_and_count_unchanged
- testWidgets: AC3_S1_toast_disappears_2s_after_fully_shown_excluding_animation
- testWidgets: AC4_S1_tap_after_5_min_logs_successfully
- testWidgets: EC3_S1_rapid_double_tap_logs_once_and_shows_toast
- testWidgets: AC5_S1_open_app_after_05_00_shows_0_cups_0_percent
- testWidgets: AC5_S1_open_at_04_59_still_shows_5_cups
- testWidgets: AC5_S1_app_left_open_across_05_00_resets_on_screen
- testWidgets: EDGE_S1_log_04_58_tap_05_01_shows_toast_after_reset
- testWidgets: EC1_S1_12_cups_bar_full_100_but_count_12
- group: S-2 รายงานรายเดือน
- testWidgets: UI_S2_open_from_S1_shows_header_and_back_returns
- testWidgets: AC6_S2_average_4_5_and_daily_history_list
- testWidgets: EDGE_S2_empty_history_shows_empty_text_and_0_0
=== จบ app/test/water/water_screens_test.dart ===

=== ข้อมูลจาก log ของฟีเจอร์นี้ (ใช้ทำตารางผลวัด agent) ===
- 20261030-1313_product_dashboard.md: role=product, feature=dashboard, time=2026-10-30 13:13, status=ok, provider=gemini, model=gemini-3.5-flash-lite, attempts=1, seconds=9.8, llm_calls=1, total_tokens=3162, agent_version=75d978ad
- 20261030-1421_design_dashboard.md: role=design, feature=dashboard, time=2026-10-30 14:21, status=ok, provider=gemini, model=gemini-3.5-flash-lite, attempts=1, seconds=13.2, llm_calls=2, total_tokens=13713, agent_version=18116912
- 20261030-1626_design_dashboard.md: role=design, feature=dashboard, time=2026-10-30 16:26, status=ok, provider=gemini, model=gemini-3.5-flash-lite, attempts=1, seconds=13.5, llm_calls=2, total_tokens=14452, agent_version=0a643e01
- 20261030-1650_design_dashboard.md: role=design, feature=dashboard, time=2026-10-30 16:51, status=ok, provider=gemini, model=gemini-3.5-flash-lite, attempts=1, seconds=58.1, llm_calls=2, total_tokens=14156, agent_version=0a643e01
- 20261030-1757_design_review_dashboard.md: role=design_review, feature=dashboard, time=2026-10-30 17:57, status=ok, provider=gemini, model=gemini-3.5-flash-lite, attempts=1, seconds=7.0, llm_calls=1, total_tokens=13484, agent_version=ac395134

ให้เขียนตามโครงของ template นี้ (แทนที่ข้อความใน <...> ด้วยเนื้อหาจริง):
=== template: docs/_templates/review.md ===
# Review: <ชื่อฟีเจอร์> (<feature>)

> ผู้ตรวจ: Reviewer agent · ตรวจทานโดย: <ชื่อเพื่อน C> · ไฟล์ที่ตรวจ: <รายชื่อไฟล์ใน docs/ และ app/>

## 1. Checklist
<เกณฑ์ "พร้อมส่ง Dev" ของทีม (docs/SETUP_CREWAI.md ข้อ 11) — ตอบทีละข้อพร้อมเหตุผลสั้น ๆ
ถ้าไฟล์ที่ต้องใช้ตรวจยังไม่มี ให้ตอบ "ตรวจไม่ได้">

| # | หัวข้อ | ผล (ผ่าน/ไม่ผ่าน/ตรวจไม่ได้) | เหตุผล |
|---|---|---|---|
| 1 | user story รูปแบบ ในฐานะ/ฉันอยาก/เพื่อ | <ผล> | <เหตุผล> |
| 2 | acceptance criteria เป็นตัวเลข/เงื่อนไขที่ทดสอบได้ และอ้าง US | <ผล> | <เหตุผล> |
| 3 | มี edge cases พร้อมผลที่คาดหวัง | <ผล> | <เหตุผล> |
| 4 | มีสิ่งที่ไม่ทำในรอบนี้ | <ผล> | <เหตุผล> |
| 5 | กติกาเกมเป็นตารางตัวเลขครบ รวมพฤติกรรมที่ขอบเขต | <ผล> | <เหตุผล> |
| 6 | ตัวเลขตรงกันทุกไฟล์ | <ผล> | <เหตุผล> |
| 7 | ทุกหน้าจอโยงกับ US และมีสถานะผิดพลาด/ว่าง | <ผล> | <เหตุผล> |
| 8 | มีชื่อไฟล์ภาพ assets ครบทุกสถานะ | <ผล> | <เหตุผล> |
| 9 | ใช้ข้อมูลสมมติ ไม่มีคำแนะนำทางการแพทย์ | <ผล> | <เหตุผล> |
| 10 | ขอบเขตทำทันเวลา | <ผล> | <เหตุผล> |

## 2. รีวิวโค้ดใน app/ (ถ้ามี)
<โค้ดใน app/lib/ ทำตาม AC และตัวเลขใน game-rules.md หรือไม่ และเทสต์ใน app/test/ ครอบคลุม AC ใดบ้าง — ถ้ายังไม่มีโค้ด เขียนว่า "ยังไม่มีโค้ด">

## 3. ปัญหาที่พบ
<หนึ่งแถวต่อหนึ่งปัญหา ต้องระบุพอให้เจ้าของงานแก้ได้ทันที>

| # | ความรุนแรง (สูง/กลาง/ต่ำ) | ไฟล์ / หัวข้อ | ปัญหา | ข้อเสนอแก้ |
|---|---|---|---|---|
| 1 | <ระดับ> | <ไฟล์ § หัวข้อ> | <ผิดอย่างไร> | <ควรแก้อย่างไร> |

## 4. ตารางผลวัด agent
<ใช้ข้อมูลจากไฟล์ใน logs/ เท่านั้น ช่องที่ไม่มีข้อมูลให้ใส่ "-" ห้ามแต่งตัวเลข
คอลัมน์ "ต้องแก้มือ" ให้คนกรอกเอง>

| ไฟล์ log | บทบาท | agent เวอร์ชัน | ผู้ให้บริการ / รุ่น | สถานะ | เวลา (วินาที) | จำนวนเรียก LLM | tokens | ต้องแก้มือ (คนกรอก) |
|---|---|---|---|---|---|---|---|---|
| <ชื่อไฟล์> | <บทบาท> | <hash> | <ผู้ให้บริการ / รุ่น> | <ok/fail> | <ตัวเลข> | <ตัวเลข> | <ตัวเลข> | - |

## 5. สรุป
**ผล: <พร้อมส่ง Dev / ต้องแก้>**

สิ่งที่ต้องแก้ก่อนส่ง Dev:
- <รายการ หรือ "ไม่มี">

=== จบ template ===

กฎ: ตอบเป็น Markdown ภาษาไทยเท่านั้น ไม่ต้องห่อด้วย ``` ไม่ต้องมีคำเกริ่นหรือคำลงท้าย ข้อมูลสุขภาพ/ข้อมูลผู้ใช้ทั้งหมดต้องเป็นข้อมูลสมมติ
~~~~

expected_output: เนื้อหาไฟล์ docs/dashboard/review.md ฉบับสมบูรณ์ ตามโครง template

### LLM call 1 — ข้อความที่ส่งจริง

~~~~text
[system]
You are Software Quality Reviewer. You are a careful and evidence-driven Software Quality Reviewer on the PetPal Health engineering team.

Your responsibility is to independently review a feature against the approved requirements, UX flow, game rules, and available implementation evidence. You check both documents and the implementation when the relevant files are provided, and you pay particular attention to inconsistencies between them.

You are strict about correctness but do not reject work based on personal preference. A feature is considered ready only when it satisfies the approved requirements and game rules, the expected UX flow is consistent with the implementation, and available test or implementation evidence supports the result. If important evidence is missing, report the missing evidence instead of assuming the feature works.

You must not modify another agent's code or documents yourself. You must not invent requirements, expected values, test results, or measurements. You must not guess the contents of files that were not provided.

For every significant finding, report:
- what was found
- what was expected
- what actually happened
- the evidence or file/location supporting the finding
- why it matters
- what should be checked or fixed

When reporting measurements or test results, use only values supported by the available evidence. Do not fabricate numbers or claim that a test passed without evidence.

Your review should balance strictness and practicality. Judge the implementation against approved project evidence and requirements, not personal preference. Do not create new requirements during a review. Do not allow real defects to pass simply to keep work moving, but do not raise issues based only on subjective preferences or requirements that were never approved.

At the end of each review, clearly distinguish between:
- PASS: no blocking issue found based on available evidence
- NEEDS_FIX: one or more requirements, rules, UX expectations, or implementation behaviors are not satisfied
- INSUFFICIENT_EVIDENCE: the available files or evidence are not enough to determine whether the feature passes

The quality of this agent is measured by whether its findings are reproducible, evidence-based, relevant to the approved specification, and useful for the developer to act on.

## Evidence Coverage and Review Limitations

Before deciding the final status, verify how much of the required evidence was actually available and reviewed.

* Distinguish test names, test/group listings, test summaries, and actual test execution results. A list of test names alone does not prove that the tests passed.
* Do not claim a test passed, a test suite completed successfully, or a specific number of tests passed unless the available evidence explicitly supports that claim.
* If input files were truncated, omitted, summarized, or only partially provided, identify the limitation and explain which conclusions may be affected.
* When logs are available, identify the relevant log files and use their actual contents as evidence. Do not assume that every log was read merely because the logs directory was included as an input.
* Check whether test evidence corresponds to the implementation being reviewed. If this cannot be verified, state the limitation explicitly.
* Separate confirmed defects from unresolved questions, missing evidence, and assumptions. Do not report an unresolved question as a confirmed defect.
* Base the final status on the evidence actually reviewed, not on the expected outcome or a previous review's conclusion.
Your personal goal is: Review the dashboard requirements, UX flow, game rules, and implementation evidence against the approved specification. Identify reproducible defects, missing requirements, inconsistencies, and test failures, then report clear evidence and actionable findings without modifying the implementation.

[user]

Current Task: ฟีเจอร์: dashboard

งานของคุณ: รีวิวเอกสารทั้งหมด โค้ดใน app/lib/ และหลักฐานการทดสอบ (test-report.md + เทสต์ใน app/test/ + log ของ dev/qa) ด้วย checklist ใน template ทีละข้อ (ผ่าน/ไม่ผ่าน + เหตุผล), ระบุปัญหาพร้อมไฟล์/หัวข้อ/ข้อเสนอแก้, ตรวจว่าตัวเลขในทุกไฟล์ตรงกัน, สรุปผลว่า 'พร้อมส่ง Dev' หรือ 'ต้องแก้' และเติมตารางผลวัด agent จากข้อมูล log ที่ให้

ข้อมูลประกอบ:
=== docs/dashboard/requirements.md ===
# Requirements: dashboard (dashboard)

> สถานะ: draft · ผู้เขียน: Product agent · ผู้ตรวจ: เพื่อน A · อ้างอิง Issue: #101

## 1. สรุปฟีเจอร์
ฟีเจอร์ Dashboard ของแอป PetPal Health แสดงผลรวมสุขภาพประจำวันของผู้ใช้ผ่านคะแนนเฉลี่ยและสัตว์เลี้ยงเสมือนจริงที่ปรับเปลี่ยนอารมณ์ตามพฤติกรรมการบันทึกข้อมูลสุขภาพ (อาหาร, การก้าวเดิน, การดื่มน้ำ) เพื่อกระตุ้นให้ผู้ดูแลใส่ใจสุขภาพตนเองอย่างต่อเนื่อง

## 2. User stories

| ID | ในฐานะ | ฉันอยาก | เพื่อ |
|---|---|---|---|
| US-1 | ผู้ใช้แอป PetPal Health | ดูคะแนนสุขภาพรวมประจำวันบนหน้า Dashboard | ทราบสถานะสุขภาพภาพรวมของตนเองในแต่ละวัน |
| US-2 | ผู้ใช้แอป PetPal Health | เห็นสัตว์เลี้ยงเสมือนเปลี่ยนอารมณ์ตามคะแนนสุขภาพรวม | รับรู้ระดับความสุขหรือความผิดปกติของสุขภาพตนเองผ่านสัตว์เลี้ยง |
| US-3 | ผู้ใช้แอป PetPal Health | เห็นข้อความแนะนำหรือแจ้งเตือนที่หมุนเวียนแสดงผลบนหน้าจอ | ทราบสิ่งที่ต้องปรับปรุงเร่งด่วนเมื่อพฤติกรรมสุขภาพไม่เป็นไปตามเป้าหมาย |
| US-4 | ผู้ใช้แอป PetPal Health | ดูแถบความคืบหน้าและข้อมูลแยกตามหมวดหมู่ (อาหาร, การก้าวเดิน, การดื่มน้ำ) | ตรวจสอบรายละเอียดพฤติกรรมสุขภาพรายหมวดหมู่ได้ชัดเจน |
| US-5 | ผู้ใช้ระบบ | ให้ระบบตัดรอบวันใหม่และรีเซ็ตข้อมูลสุขภาพอ้างอิงตามเวลา 05:00 น. (ICT) | เริ่มต้นบันทึกและคำนวณคะแนนของวันใหม่ได้อย่างถูกต้องตาม Server Time |

## 3. Acceptance criteria

| ID | อ้างถึง | เงื่อนไข (ก่อน / เมื่อ / แล้ว) | ค่าที่ทดสอบได้ |
|---|---|---|---|
| AC-1 | US-1 | ก่อน: ผู้ใช้อยู่หน้า Dashboard และมีข้อมูลคะแนน Food, Steps, Water — เมื่อ: ระบบคำนวณคะแนนเฉลี่ย — แล้ว: แสดงคะแนนรวมคำนวณจาก (Food + Steps + Water) / 3 โดยค่าสูงสุดถูก Cap ไว้ไม่เกิน 100% และแสดงผลบน UI เป็นจำนวนเต็ม (Integer) เสมอ | คะแนนเฉลี่ยคำนวณถูกต้องตามสูตร, ค่าสูงสุดไม่เกิน 100, แสดงผลเป็น Integer |
| AC-2 | US-2 | ก่อน: คะแนนรวมถูกคำนวณแล้ว — เมื่อ: ตรวจสอบช่วงคะแนนกับอารมณ์สัตว์เลี้ยง — แล้ว: แสดงอารมณ์สัตว์เลี้ยงตรงตามตาราง (0-30% ร้องไห้, 31-60% เหม่อลอย, 61-80% ออรุ่มเจ๊าะ, 81-100% ยิ้มร่าเริง) | คะแนน 0-30 = ร้องไห้, 31-60 = เหม่อลอย, 61-80 = ออรุ่มเจ๊าะ, 81-100 = ยิ้มร่าเริง |
| AC-3 | US-3 | ก่อน: มีเงื่อนไขคำแนะนำที่ต้องแสดงตามลำดับความสำคัญ — เมื่อ: ข้อความแสดงผลบน UI — แล้ว: แสดงข้อความวนลูปทุก 5 วินาที ตาม Priority 1: `"แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว"` (พร้อมหลอดอาหารสีแดง), Priority 2: `"ดื่มน้ำๆ"`, Priority 3: `"ขยับร่างกายหน่อย อีกนิดๆ"`, Priority 4: `"ฉันหิว"` โดยมีกฎ Dynamic Queue คือคัดชื่อออกจากคิวทันทีเมื่อแก้ปัญหาสำเร็จ | ข้อความหมุนเวียนทุก 5 วินาที ตรงตาม String ที่กำหนดเป๊ะ และหลุดจากคิวทันทีที่แก้ปัญหาเสร็จ |
| AC-4 | US-4 | ก่อน: ผู้ใช้อยู่หน้า Dashboard — เมื่อ: ระบบแสดง UI Components ของฟีเจอร์ — แล้ว: แสดงผลครบถ้วนตาม 3 ฟีเจอร์หลัก (คะแนนรวม, อารมณ์สัตว์เลี้ยง, แถบความคืบหน้าแยกหมวดหมู่ Food/Steps/Water) | UI แสดงผลครบทั้ง 3 ฟีเจอร์หลัก |
| AC-5 | US-5 | ก่อน: เวลาปัจจุบันถึง 04:59 น. (ICT) — เมื่อ: นาฬิกา Server Time ถึงเวลา 05:00 น. (ICT) — แล้ว: ระบบทำการตัดรอบวันใหม่และรีเซ็ตข้อมูลสุขภาพประจำวันทันที | ตัดรอบวันและรีเซ็ตข้อมูลที่เวลา 05:00 น. (ICT) อิง Server Time |

## 4. Edge cases

| ID | สถานการณ์ | ผลที่คาดหวัง |
|---|---|---|
| EC-1 | คะแนนรวมจากการคำนวณ (Food + Steps + Water) / 3 มีค่าเกิน 100% (เช่น ได้ 120%) | ระบบทำการ Cap ค่าสูงสุดไว้ที่ 100% และแสดงผลบน UI เป็น 100% |
| EC-2 | ผู้ใช้แก้ปัญหาใน Priority 1 (Overeating หรือปัญหาอาหาร) สำเร็จในขณะที่ข้อความกำลังแสดงผลอยู่ | ระบบทำการคัดชื่อข้อความ Priority 1 ออกจาก Dynamic Queue ทันที และข้ามไปแสดงข้อความในลำดับถัดไปโดยไม่รอครบ 5 วินาที |
| EC-3 | เวลา Server Time เปลี่ยนผ่านเข้าสู่ช่วงเวลา 05:00 น. (ICT) พอดีขณะที่ผู้ใช้งานกำลังเปิดหน้า Dashboard ค้างไว้ | หน้าจอ Dashboard ทำการรีเฟรชข้อมูลและรีเซ็ตค่าสถานะสุขภาพประจำวันเป็นค่าเริ่มต้นของวันใหม่โดยอัตโนมัติทันที |
| EC-4 | ข้อมูลคะแนนในหมวดหมู่ใดหมวดหมู่หนึ่งเป็นค่าติดลบหรือข้อมูลว่าง (Null) | ระบบกำหนดให้คะแนนหมวดนั้นมีค่าเท่ากับ 0 ก่อนนำไปคำนวณสูตรเฉลี่ยหาร 3 เพื่อป้องกันข้อผิดพลาด |
| EC-5 | คะแนนรวมคำนวณออกมาเป็นทศนิยม (เช่น 65.66%) | ระบบทำการปัดเศษและแสดงผลบน UI เป็นจำนวนเต็ม (Integer) เสมอ (แสดงผลเป็น 66%) |

## 5. สิ่งที่ไม่ทำในรอบนี้ (Out of scope)
- ระบบแจ้งเตือนแบบ Push Notification ไปยังมือถือของผู้ใช้ นอกเหนือจากการแสดงข้อความวนลูปในหน้า Dashboard
- ระบบประวัติย้อนหลัง (Historical Data) เกินกว่า 1 วัน (รอบวันปัจจุบันตัดที่ 05:00 น.)
- การปรับแต่งหรือเปลี่ยนตัวละครสัตว์เลี้ยงนอกเหนือจาก 4 ระดับอารมณ์ที่กำหนด

## 6. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น)

| ข้อมูล | ชนิด/หน่วย | เก็บที่ไหน |
|---|---|---|
| คะแนนอาหาร (Food Score) | Integer (0-100) | Local Storage / Session Database |
| คะแนนการก้าวเดิน (Steps Score) | Integer (0-100) | Local Storage / Session Database |
| คะแนนการดื่มน้ำ (Water Score) | Integer (0-100) | Local Storage / Session Database |
| คะแนนสุขภาพรวม (Total Score) | Integer (0-100) | Local Storage / Session Database |
| สถานะอารมณ์สัตว์เลี้ยง (Pet Mood) | String (ร้องไห้ / เหม่อลอย / ออรุ่มเจ๊าะ / ยิ้มร่าเริง) | Local Storage / Session Database |
| คิวข้อความแจ้งเตือน (Alert Queue) | Array of Strings / Objects | Local Storage / Session Database |

## 7. คำถามที่ยังเปิดอยู่
- ทีม Design ต้องยืนยันภาพประกอบของสัตว์เลี้ยงทั้ง 4 ระดับอารมณ์ว่ารองรับขนาดหน้าจอ Responsive ทุกขนาดหรือไม่
- การซิง크 Server Time ระหว่าง Client กับ Server จะใช้ Timezone ตรงที่ 05:00 น. (ICT) เสมอสำหรับผู้ใช้ทุกคนใช่หรือไม่

=== จบ docs/dashboard/requirements.md ===

=== docs/dashboard/ux-flow.md ===
# UX flow: dashboard (dashboard)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: เพื่อน B · อ้างอิง: requirements.md

## 1. รายการหน้าจอ

| ID | ชื่อหน้าจอ | จุดประสงค์ | อ้างถึง |
|---|---|---|---|
| S-1 | หน้าจอแดชบอร์ดหลัก (Dashboard Main Screen) | แสดงคะแนนสุขภาพรวม, อารมณ์สัตว์เลี้ยงเสมือนจริง, ข้อความแนะนำวนลูป และแถบความคืบหน้าแยกตามหมวดหมู่ (อาหาร, การก้าวเดิน, การดื่มน้ำ) | US-1, US-2, US-3, US-4, US-5, AC-1, AC-2, AC-3, AC-4, AC-5 |

## 2. องค์ประกอบบนหน้าจอ

### S-1 หน้าจอแดชบอร์ดหลัก (Dashboard Main Screen)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| Total Score Card | แถบแสดงผลตัวเลข | `คะแนนสุขภาพรวม: [Integer]%` (ค่าคำจากสูตรเฉลี่ยและ Cap สูงสุด 100%) | อัปเดตแบบเรียลไทม์เมื่อคะแนน Food, Steps หรือ Water เปลี่ยนแปลง |
| Pet Character Display | รูปภาพตัวละคร (Image Asset) | ภาพตัวละครสัตว์เลี้ยงตามสถานะอารมณ์ปัจจุบัน | อัปเดตภาพทันทีเมื่อคะแนนรวมเปลี่ยนช่วงอารมณ์ (ร้องไห้, เหม่อลอย, ออรุ่มเจ๊าะ, ยิ้มร่าเริง) |
| Dynamic Alert Banner | แถบข้อความแจ้งเตือน (Banner) | ข้อความหมุนเวียน 4 ลำดับ:<br>1. `"แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว"`<br>2. `"ดื่มน้ำๆ"`<br>3. `"ขยับร่างกายหน่อย อีกนิดๆ"`<br>4. `"ฉันหิว"` | หมุนเวียนเปลี่ยนข้อความทุก 5 วินาที หรือตัดออกจากคิวทันทีเมื่อแก้ปัญหาสำเร็จ |
| Food Progress Bar | แถบความคืบหน้า (Progress Bar) | คะแนนอาหาร: `[Integer]%` (หลอดสีแดงหากเข้าเงื่อนไข Priority 1) | แสดงความคืบหน้าคะแนนหมวดอาหาร (Food Score) |
| Steps Progress Bar | แถบความคืบหน้า (Progress Bar) | คะแนนการก้าวเดิน: `[Integer]%` | แสดงความคืบหน้าคะแนนหมวดการก้าวเดิน (Steps Score) |
| Water Progress Bar | แถบความคืบหน้า (Progress Bar) | คะแนนการดื่มน้ำ: `[Integer]%` | แสดงความคืบหน้าคะแนนหมวดการดื่มน้ำ (Water Score) |

## 3. ขั้นตอนการใช้งาน (happy path)
1. ผู้ใช้เปิดแอปพลิเคชัน PetPal Health เข้าสู่หน้าแดชบอร์ดหลัก (S-1)
2. ระบบทำการตรวจสอบ Server Time และโหลดข้อมูลคะแนนสุขภาพประจำวัน (Food, Steps, Water) จาก Local Storage / Session Database
3. ระบบคำนวณคะแนนสุขภาพรวมด้วยสูตร `(Food + Steps + Water) / 3` โดยหากผลลัพธ์เกิน 100% จะถูก Cap ไว้ที่ 100% และปัดเศษเป็นจำนวนเต็ม (Integer)
4. ระบบประเมินช่วงคะแนนรวมเพื่อกำหนดสถานะอารมณ์สัตว์เลี้ยง (`CRYING`, `DAZED`, `BUBBLY`, `CHEERFUL`) และแสดงภาพ Asset ที่ตรงกัน
5. ระบบตรวจสอบเงื่อนไขคิวข้อความแจ้งเตือน (Alert Queue) และแสดงผลข้อความวนลูปทุก 5 วินาที หรืออัปเดตคิวทันทีเมื่อผู้ใช้แก้ปัญหาสำเร็จ
6. ระบบแสดงผลแถบความคืบหน้าแยกตามหมวดหมู่ (Food, Steps, Water) บนหน้าจอครบถ้วนตามข้อมูลปัจจุบัน

## 4. สถานะของหน้าจอ

| หน้าจอ | สถานะ | เงื่อนไขที่ทำให้เกิด | สิ่งที่แสดง |
|---|---|---|---|
| S-1 | ปกติ (Normal State) | ข้อมูลคะแนนสุขภาพครบถ้วน และเวลาปัจจุบันยังไม่ถึงรอบ 05:00 น. (ICT) | แสดงคะแนนรวม, สัตว์เลี้ยงตามอารมณ์จริง, ข้อความแจ้งเตือนในคิว และแถบความคืบหน้าทั้ง 3 หมวด |
| S-1 | ว่าง / ข้อมูลไม่สมบูรณ์ (Empty/Fallback State) | ข้อมูลคะแนนในหมวดหมู่ใดหมวดหมู่หนึ่งเป็นค่าติดลบหรือข้อมูลว่าง (Null) | ระบบกำหนดให้คะแนนหมวดนั้นมีค่าเท่ากับ 0 อัตโนมัติ แล้วคำนวณคะแนนรวมตามปกติ พร้อมแสดงแถบความคืบหน้าที่ 0% เพื่อป้องกันหน้าจอผิดพลาด |
| S-1 | ผิดพลาด / ข้ามช่วงเวลา (Error / Time Crossing State) | นาฬิกา Server Time ถึงเวลา 05:00 น. (ICT) พอดีขณะที่ผู้ใช้งานกำลังเปิดหน้า Dashboard ค้างไว้ | หน้าจอทำการรีเฟรชข้อมูลโดยอัตโนมัติทันที และรีเซ็ตค่าสถานะสุขภาพประจำวันเป็นค่าเริ่มต้นของวันใหม่ |

## 5. ไฟล์ภาพ assets

| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายภาพ |
|---|---|---|
| `assets/images/pet_crying.png` | S-1 / สถานะคะแนนรวม 0-30% | ภาพสัตว์เลี้ยงหน้าตาน่าสงสาร กำลังร้องไห้ แสดงถึงคะแนนสุขภาพอยู่ในระดับวิกฤต |
| `assets/images/pet_dazed.png` | S-1 / สถานะคะแนนรวม 31-60% | ภาพสัตว์เลี้ยงหน้าตาเหม่อลอย นั่งนิ่งๆ แสดงถึงคะแนนสุขภาพอยู่ในระดับปานกลางค่อนไปทางต่ำ |
| `assets/images/pet_bubbly.png` | S-1 / สถานะคะแนนรวม 61-80% | ภาพสัตว์เลี้ยงหน้าตายิ้มแย้ม สดใส ออรุ่มเจ๊าะ แสดงถึงคะแนนสุขภาพอยู่ในระดับดี |
| `assets/images/pet_cheerful.png` | S-1 / สถานะคะแนนรวม 81-100% | ภาพสัตว์เลี้ยงกระโดดโลดเต้น ยิ้มร่าเริง แสดงถึงคะแนนสุขภาพอยู่ในระดับยอดเยี่ยม |

## 6. คำถามถึง Product

1. ข้อเสนอแนะจาก Design: ทีม Design จะจัดเตรียมภาพประกอบสัตว์เลี้ยงทั้ง 4 ขนาดให้รองรับ Responsive Layout แบบ Flexbox/Grid ที่ปรับสัดส่วนอัตโนมัติเพื่อรองรับทุกขนาดหน้าจอ / กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule): ให้ Dev ใช้ภาพขนาดมาตรฐาน 300x300 pixels แบบ Scalable Image Container ไปก่อน / การประเมินสถานะการบล็อก: Blocking: ไม่ใช่ เพราะเป็นเรื่องการจัดวาง Asset บนหน้าจอซึ่งไม่กระทบตรรกะการคำนวณระบบ
2. ข้อเสนอแนะจาก Design: ยืนยันให้ใช้ Timezone มาตรฐาน `Asia/Bangkok (ICT)` เป็นเกณฑ์กลางเดียวสำหรับผู้ใช้ทุกคนในการตัดรอบเวลา 05:00 น. / กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule): ให้ Dev ตั้งค่าระบบเปรียบเทียบเวลาอิงตาม Timezone `GMT+7 (ICT)` เสมอในโค้ดฝั่ง Server/Client / การประเมินสถานะการบล็อก: Blocking: ไม่ใช่ เพราะมีความชัดเจนตามเงื่อนไข AC-5 และข้อกำหนดระบบอยู่แล้ว

=== จบ docs/dashboard/ux-flow.md ===

=== docs/dashboard/game-rules.md ===
# กติกาเกม: dashboard (dashboard)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: เพื่อน B · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ความหมาย | ค่า | หน่วย | อ้างถึง |
|---|---|---|---|---|
| `foodScore` | คะแนนอาหาร (Food Score) | 0 ถึง 100 (กรณีติดลบหรือ Null ระบบปรับเป็น 0) | เปอร์เซ็นต์ (%) | US-4, AC-1, AC-4, EC-4 |
| `stepsScore` | คะแนนการก้าวเดิน (Steps Score) | 0 ถึง 100 (กรณีติดลบหรือ Null ระบบปรับเป็น 0) | เปอร์เซ็นต์ (%) | US-4, AC-1, AC-4, EC-4 |
| `waterScore` | คะแนนการดื่มน้ำ (Water Score) | 0 ถึง 100 (กรณีติดลบหรือ Null ระบบปรับเป็น 0) | เปอร์เซ็นต์ (%) | US-4, AC-1, AC-4, EC-4 |
| `totalScore` | คะแนนสุขภาพรวมคำนวณจาก `(Food + Steps + Water) / 3` (Cap สูงสุดไม่เกิน 100% ปัดเศษเป็น Integer เสมอ) | 0 ถึง 100 | เปอร์เซ็นต์ (%) | US-1, AC-1, EC-1, EC-5 |
| `alertInterval` | ระยะเวลาในการหมุนเวียนข้อความแจ้งเตือนบนหน้า Dashboard | 5 | วินาที (Seconds) | US-3, AC-3 |
| `resetHour` | เวลาตัดรอบวันใหม่และรีเซ็ตข้อมูลสุขภาพประจำวันอิงตาม Server Time | 05:00 | น. (ICT / GMT+7) | US-5, AC-5, EC-3 |

### 1.1 ตารางลำดับความสำคัญของข้อความแจ้งเตือน (Dynamic Alert Queue Table)

| ลำดับ (Priority) | ข้อความแจ้งเตือน (Exact String) | เงื่อนไขการกระตุ้น (Trigger Condition) | เงื่อนไขการเคลียร์หลุดจากคิว (Queue Removal) |
|---|---|---|---|
| Priority 1 (สูงสุด) | `"แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว"` | ผู้ใช้บันทึกอาหารเกินเป้าหมาย (Overeating > 100 kcal / หลอดอาหารแสดงสีแดง) | ผู้ใช้จัดการปัญหาอาหาร หรือข้ามสู่รอบวันใหม่ |
| Priority 2 | `"ดื่มน้ำๆ"` | ปริมาณการดื่มน้ำยังไม่ถึงเป้าหมายประจำวัน (`waterScore < 100%`) | ผู้ใช้บันทึกการดื่มน้ำจนถึงเป้าหมาย (`waterScore >= 100%`) |
| Priority 3 | `"ขยับร่างกายหน่อย อีกนิดๆ"` | จำนวนก้าวเดินยังไม่ถึงเป้าหมายประจำวัน (`stepsScore < 100%`) | ผู้ใช้เดินครบตามเป้าหมายประจำวัน (`stepsScore >= 100%`) |
| Priority 4 | `"ฉันหิว"` | ผู้ใช้ยังไม่ได้บันทึกอาหารมื้อใดๆ หรือคะแนนอาหารต่ำกว่าเกณฑ์ | ผู้ใช้ทำการบันทึกอาหารเข้าระบบสำเร็จ |

*หมายเหตุ Dynamic Queue:* ข้อความในคิวจะหมุนเวียนแสดงผลทุก 5 วินาที หากผู้ใช้แก้ปัญหาของ Priority ใดสำเร็จ ระบบจะคัดชื่อข้อความนั้นออกจากคิวทันทีและสลับไปแสดงข้อความลำดับถัดไปโดยไม่ต้องรอครบ 5 วินาที (AC-3, EC-2)

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง

| สถานะ (Code Enum) | ช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพ (Asset / Preset) |
|---|---|---|
| `CRYING (ร้องไห้)` | มากกว่าหรือเท่ากับ 0% และน้อยกว่าหรือเท่ากับ 30% (`[0, 30]`) | `assets/images/pet_crying.png` |
| `DAZED (เหม่อลอย)` | มากกว่า 30% และน้อยกว่าหรือเท่ากับ 60% (`(30, 60]`) | `assets/images/pet_dazed.png` |
| `BUBBLY (ออรุ่มเจ๊าะ)` | มากกว่า 60% และน้อยกว่าหรือเท่ากับ 80% (`(60, 80]`) | `assets/images/pet_bubbly.png` |
| `CHEERFUL (ยิ้มร่าเริง)` | มากกว่า 80% และน้อยกว่าหรือเท่ากับ 100% (`(80, 100]`) | `assets/images/pet_cheerful.png` |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| คำนวณคะแนนรวมปกติ (Food: 60, Steps: 90, Water: 60) | Food: 60, Steps: 90, Water: 60 | Total Score: 70%, Pet Mood: `BUBBLY (ออรุ่มเจ๊าะ)` | คำนวณจาก (60 + 90 + 60) / 3 = 70 อ้างอิง AC-1, AC-2 |
| คำนวณคะแนนรวมได้ผลลัพธ์เป็นทศนิยม (Food: 70, Steps: 60, Water: 67) | Food: 70, Steps: 60, Water: 67 | Total Score: 66%, Pet Mood: `BUBBLY (ออรุ่มเจ๊าะ)` | คำนวณจาก (70 + 60 + 67) / 3 = 65.66% ปัดเศษเป็นจำนวนเต็มได้ 66% อ้างอิง EC-5 |
| ข้อมูลหมวดอาหารเป็นค่าว่างหรือติดลบ (Food: -10, Steps: 90, Water: 90) | Food: -10, Steps: 90, Water: 90 | Food: 0, Total Score: 60%, Pet Mood: `DAZED (เหม่อลอย)` | ระบบแปลงค่าติดลบเป็น 0 ก่อนคำนวณ (0 + 90 + 90) / 3 = 60 ตกในช่วง (30, 60] อ้างอิง EC-4 |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ที่ทดสอบได้ |
|---|---|
| คะแนนรวมจากการคำนวณเกิน 100% (เช่น Food: 100, Steps: 100, Water: 160 -> เฉลี่ยได้ 120%) | ระบบทำการ Cap ค่าสูงสุดของคะแนนรวมไว้ที่ 100% เสมอ และแสดงผลบน UI เป็น 100% พร้อมแสดงสถานะสัตว์เลี้ยงเป็น `CHEERFUL (ยิ้มร่าเริง)` อ้างอิง AC-1, EC-1 |
| ผู้ใช้แก้ปัญหาใน Priority 1 (Overeating หรือปัญหาอาหาร) สำเร็จในขณะที่ข้อความกำลังแสดงผลอยู่ | ระบบทำการคัดชื่อข้อความ Priority 1 ออกจาก Dynamic Queue ทันที และข้ามไปแสดงข้อความในลำดับถัดไป (Priority 2: `"ดื่มน้ำๆ"`) ทันทีโดยไม่ต้องรอให้ครบ 5 วินาที อ้างอิง AC-3, EC-2 |
| เวลา Server Time เปลี่ยนผ่านเข้าสู่ช่วงเวลา 05:00 น. (ICT) พอดีขณะที่ผู้ใช้งานกำลังเปิดหน้า Dashboard ค้างไว้ | หน้าจอ Dashboard ทำการรีเฟรชข้อมูลและรีเซ็ตค่าสถานะสุขภาพประจำวันทั้งหมด (`foodScore`, `stepsScore`, `waterScore`, `totalScore`) เป็นค่าเริ่มต้นของวันใหม่โดยอัตโนมัติทันที อ้างอิง AC-5, EC-3 |

## 5. คำถามถึง Product

1. **ข้อเสนอแนะจาก Design:** ทีม Design จะจัดเตรียมภาพประกอบสัตว์เลี้ยงทั้ง 4 ขนาดให้รองรับ Responsive Layout แบบ Flexbox/Grid ที่ปรับสัดส่วนอัตโนมัติเพื่อรองรับทุกขนาดหน้าจอ
   - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ให้ Dev ใช้ภาพขนาดมาตรฐาน 300x300 pixels แบบ Scalable Image Container ไปก่อน
   - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่ เพราะเป็นเรื่องการจัดวาง Asset บนหน้าจอซึ่งไม่กระทบตรรกะการคำนวณระบบ
2. **ข้อเสนอแนะจาก Design:** ยืนยันให้ใช้ Timezone มาตรฐาน `Asia/Bangkok (ICT)` เป็นเกณฑ์กลางเดียวสำหรับผู้ใช้ทุกคนในการตัดรอบเวลา 05:00 น.
   - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ให้ Dev ตั้งค่าระบบเปรียบเทียบเวลาอิงตาม Timezone `GMT+7 (ICT)` เสมอในโค้ดฝั่ง Server/Client
   - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่ เพราะมีความชัดเจนตามเงื่อนไข AC-5 และข้อกำหนดระบบอยู่แล้ว

=== จบ docs/dashboard/game-rules.md ===

=== docs/dashboard/test-report.md ===
# Test report: dashboard (QA รอบที่ 1 + รอบที่ 3)

> **รอบ 3 (2026-10-31 09:22–09:31) อยู่ท้ายไฟล์ §10–§15**: ผลล่าสุดหลังข้อตัดสิน owner รอบ 3 และ dev r3 (`logs/20261031-0921_dev_dashboard_r3.md`) คือ dashboard 116 เทสต์ **ผ่าน 116 / ไม่ผ่าน 0** · ทั้งแอป **719 ผ่าน / 0 ไม่ผ่าน** · `flutter analyze` No issues found! · BUG-DASH-1 ปิดแล้ว (owner ยึด A-7) · ปรับเทสต์ 12 ตัวเพราะข้อตัดสินใหม่ เพิ่มเทสต์ใหม่ 10 ตัว · ไม่พบบั๊กใหม่ · §0–§9 ด้านล่างเป็นผลรอบ 1 (คงไว้ตามเดิม)

> ผู้ทดสอบ: QA agent · วันที่ 2026-10-31 (08:26–08:47) · โค้ดที่ทดสอบ: `app/lib/features/dashboard/` + `dashboard_entry_button` ใน `app/lib/features/water/screens/water_home_screen.dart` (dev v1, `logs/20261031-0824_dev_dashboard.md`)
> อ้างอิง: requirements.md, game-rules.md, ux-flow.md, ui-spec.md + ข้อตัดสิน owner ด้านล่าง (ค่าคาดหวังทั้งหมดมาจากเอกสาร/ข้อตัดสิน ไม่ได้ลอกจากโค้ด)
> เทสต์: `app/test/dashboard/dashboard_logic_test.dart` (L), `dashboard_controller_test.dart` (C), `dashboard_screens_test.dart` (W) + ตัวช่วย `dashboard_test_helpers.dart` (ไม่มีเทสต์ในไฟล์นี้ ใช้ `FakeTimers` / `profileOf` จาก `app/test/food/food_test_helpers.dart`)
> ไม่ได้แก้โค้ดใน `app/lib/` · ไม่ได้แก้ไฟล์อื่นใน `docs/dashboard/` · ไม่ได้ commit / push

## 0. ข้อตัดสิน owner — DECIDED (owner ชั่วคราว, รอทีมยืนยัน)

ข้อไหนขัดกับเอกสาร ให้ข้อตัดสินชนะ เทสต์ที่อิงข้อตัดสินจะมีคำว่า `DECIDED_` ในชื่อ

| รหัส | เนื้อหา | มีผลต่อเทสต์ |
|---|---|---|
| D-1 | สัตว์เลี้ยงใช้ `PetCharacter`: CRYING [0,30] → `PetPose.dashboardCrying`, DAZED (30,60] → `dashboardDazed`, BUBBLY (60,80] → `dashboardBubbly` (= `waterHappy`), CHEERFUL (80,100] → `dashboardCheerful` ไม่ใช้ PNG | ตรวจ `painter.pose` ทุกช่วง, ไม่มี `Image`, ขนาด 200 (ui-spec Q-9) |
| D-2 | เวลาเครื่อง ตัดรอบ 05:00 แบบ water/steps/food ไม่มี Server Time | ใช้ `clock` ของ 3 controller (dashboard ไม่มี clock) |
| D-3 | Water, Steps = `round(min(actual/target,1)×100)`; Food ถึงเป้า = `kcal/target×100`, เกินเป้า = `max(0, 100 − ส่วนที่เกิน/target×100)`, ไม่มีเป้า = ไม่คิดคะแนน | ตัวเลขคะแนนรายหมวดทุกเทสต์ |
| D-4 | Priority 4 "คะแนนอาหารต่ำกว่าเกณฑ์" = `foodScore < 50` | ขอบ 49/50, กรณีกินเกินเป้ามาก (BUG-DASH-1) |
| Q-1 | ไม่มีเป้าอาหาร → total = `round((Steps + Water)/2)` แถบอาหาร「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 | `DECIDED_Q1_*` |
| Q-14 | เป้าน้ำ = 8 แก้ว (100% / 12.5% ต่อแก้ว ของ water_rules) | `DECIDED_Q14_*` (7 แก้ว = 88 ตาม ui-spec) |
| Q-3, Q-16, Q-19, Q-20, Q-21, Q-8 | ใช้ตามที่ ui-spec เลือก: P4 ประเมินสด, ปัด foodScore ก่อนเฉลี่ย, เริ่มที่ Priority สูงสุด + นับ 5 วิใหม่เมื่อข้อความเปลี่ยน, ไม่มี cheerTrigger, ไม่รวม `"`, หัวข้อ/tooltip「แดชบอร์ด」 | `DECIDED_Q3_* / Q16 / Q19 / Q20 / Q8` |
| Q-4 / Q-5 / Q-17 | ยึด game-rules + D-3: P2/P3 เมื่อ `< 100`, แถบอาหารเกินเป้าแสดงคะแนนจริง (93%), ตัดออกจากคิวทันที | AC-3/EC-2 |
| Q-7 | water ยังเป็นหน้าแรก เข้า dashboard ผ่าน `dashboard_entry_button` | `DECIDED_Q7_*` + เทสต์เดิมของ signup/water ต้องผ่าน |
| Q-2 / Q-11 / BUBBLY | ไม่มีการลบมื้อ; ไม่แสดงจำนวนจริง/ป้ายโซเดียม-น้ำตาล; BUBBLY ใช้หน้าเดิม | EC-2 ของ P1 ทดสอบผ่านการเปลี่ยนเป้า (ดู §7 ข้อ 5) |

## 1. สรุปตัวเลข

| รายการ | ค่า |
|---|---|
| เทสต์ dashboard ทั้งหมด | **106** (L 45 · C 18 · W 43) |
| ผ่าน / ไม่ผ่าน (dashboard) | **105 / 1** |
| `flutter test` ทั้งแอป (ใน app/) | **708 ผ่าน / 1 ไม่ผ่าน** — `02:37 +708 -1: Some tests failed.` (เทสต์เดิม 603 ผ่านครบ + dashboard 106) |
| `flutter analyze` (ทั้ง app/) | `No issues found! (ran in 5.9s)` |
| AC ทั้งหมด 5 ข้อ | 5 มีเทสต์ · ผ่าน 4 · **AC-3 ไม่ผ่าน 1 เทสต์** (BUG-DASH-1) |
| EC ทั้งหมด 5 ข้อ | 5 มีเทสต์ · ผ่าน 5 |
| AC/EC ที่ยังไม่มีเทสต์ | ไม่มี |
| Bug ที่พบ | **1** (BUG-DASH-1) |
| เทสต์ที่ QA แก้เองเพราะเทสต์ผิด | 1 (ดู §6) |
| คำถามค้าง | 11 (ดู §7) |

ชื่อเทสต์: `AC#_` / `EC#_` = ตามเอกสาร · `GR#_` = ตัวเลขจาก game-rules §# · `EDGE_` = edge case บังคับ 4 แบบ · `DECIDED_` = ตามข้อตัดสิน owner · `UI_` = โครงหน้าจอตาม ui-spec

## 2. AC → เทสต์

| AC | เทสต์ (ไฟล์) | ผล |
|---|---|---|
| AC-1 คะแนนรวม (F+S+W)/3, cap 100, จำนวนเต็ม | GR3_row1_food60_steps90_water60_total70_bubbly (L) · GR3_row2_EC5_food70_steps60_water67_total66_bubbly (L) · GR4_EC1_food100_steps100_water160_cap100_cheerful (L) · EC1_all_categories_over_target_snapshot_total_100 (L) · EC5_total_is_integer_rounded_65_67_to_66_and_65_33_to_65 (L) · DECIDED_Q16_total_from_rounded_category_scores (L) · AC1_GR3_row1_equivalent_60_100_50_shows_70_bubbly (W) · AC1_EC5_total_text_is_integer_no_decimal (W) · UI_realtime_update_when_source_changes (W) | ผ่าน |
| AC-2 อารมณ์ 4 ช่วง | AC2_EDGE_mood_at_0/30/31/60/61/80/81/100 (L, 8) · AC2_EDGE_boundaries_via_snapshot_30_31_60_61_80_81 (L) · DECIDED_Q13_mood_from_rounded_total_30_4_crying_30_5_dazed (L) · DECIDED_D1_pose_mapping_PetCharacter (L) · AC2_EDGE_total_0/30/31/60/61/80/81/100_is_<mood> (W, 8: key `dashboard_pet_image_<mood>` + `painter.pose`) · DECIDED_D1_PetCharacter_size_200_no_png (W) · DECIDED_Q20_no_cheerTrigger_and_state_kept_on_mood_change (W) · AC2_animated_cheerful_runs_with_pump_duration (W) | ผ่าน |
| AC-3 ข้อความวนทุก 5 วิ ตรงตัว + Dynamic Queue | AC3_exact_strings_4_priorities (L) · AC3_empty_day_queue_P2_P3_P4_in_priority_order (L) · GR3_row1_example_queue_P2_P3_only (L) · AC3_EDGE_P1_overeat_threshold_2100_not_2101_yes (L) · DECIDED_Q2_no_target_never_P1 (L) · AC3_EDGE_P2_water_7_cups_in_8_cups_out (L) · AC3_EDGE_P3_steps_99pct_in_100pct_out (L) · DECIDED_D4_EDGE_P4_food_score_49_in_50_out (L) · DECIDED_Q3_P4_no_meal_in_even_with_target (L) · DECIDED_Q3_P4_logged_but_still_below_50_stays (L) · DECIDED_Q3_P4_no_target_only_no_meal_rule (L) · **DECIDED_D4_P4_far_over_target_food_score_below_50_in_queue (L)** · AC3_queue_empty_when_all_resolved (L) · AC3_next_alert_loops_in_priority_order (L) · AC3_starts_at_highest_priority_P2_on_empty_day (C) · AC3_EDGE_rotation_exactly_at_5s_not_4_999s_and_loops (C) · AC3_P1_queue_rotates_P1_P2_P3_back_to_P1 (C) · AC3_single_item_queue_stays_on_same_text (C) · AC3_EDGE_empty_queue_no_alert (C) · DECIDED_Q3_P4_removed_when_meal_logged_reaches_50 (C) · DECIDED_Q19_new_P1_enters_queue_shows_highest_priority (C) · AC3_rotates_every_5s_P2_P3_P4_P2 (W: 4.9 s ยังเดิม / 5.0 s เปลี่ยน) · AC3_P1_exact_text_shown_once_red_food_bar_93 (W) · AC3_EDGE_P1_2100_not_red_2101_red (W) · AC3_EDGE_empty_queue_hides_banner_keeps_slot (W) | **ไม่ผ่าน 1** (BUG-DASH-1) · อื่นผ่าน |
| AC-4 UI ครบ 3 ส่วน | AC4_total_card_pet_and_three_bars_present (W) · UI_layout_order_card_alert_pet_food_steps_water (W) · UI_bar_labels_format_and_bar_value_equals_score (W) · UI_card_and_bubble_colors_from_color_scheme (W) · UI_loading_shows_only_progress_indicator (W) · DECIDED_Q8_header_title (W) | ผ่าน |
| AC-5 ตัดรอบ 05:00 (D-2 เวลาเครื่อง) | AC5_EC3_EDGE_04_59_59_keeps_day_05_00_00_resets_all (C) · AC5_open_after_05_00_with_yesterday_data_shows_new_day (C) · AC5_EC3_EDGE_open_04_59_59_then_05_00_00_resets_screen (W) · AC5_resume_after_05_00_resets (W) | ผ่าน |

## 3. Edge case (EC ในเอกสาร + 4 แบบบังคับ)

| กรณี | เทสต์ | ผล |
|---|---|---|
| EC-1 เฉลี่ยเกิน 100 → 100% | GR4_EC1_food100_steps100_water160_cap100_cheerful (L) · EC1_all_categories_over_target_snapshot_total_100 (L) · EC1_GR4_over_target_everywhere_capped_100_cheerful (W: 13 แก้ว / 20,000 ก้าว / 2,000 kcal → `คะแนนสุขภาพรวม: 100%`, แถบ ≤ 1.0, cheerful) | ผ่าน |
| EC-2 แก้ปัญหาขณะแสดง → ตัดออกทันที ไม่รอ 5 วิ | EC2_GR4_P1_removed_while_showing_next_is_P2 (L) · EC2_last_item_removed_wraps_to_head (L) · EC2_only_item_removed_queue_empty_null (L) · EC2_P2_resolved_by_logging_water_switches_to_P3_immediately (C) · DECIDED_Q19_after_removal_next_rotation_counts_5s_anew (C) · EC2_P3_resolved_by_steps_switches_to_P4_immediately (C) · EC2_GR4_P1_removed_while_showing_switches_to_P2_immediately (C) · EC2_last_problem_resolved_queue_empty_alert_hidden (C) · EC2_resolve_shown_P2_switches_without_waiting (W) | ผ่าน |
| EC-3 ข้าม 05:00 ขณะเปิดค้าง | AC5_EC3_EDGE_04_59_59_keeps_day_05_00_00_resets_all (C) · EC3_rollover_clears_P1_and_red_bar (C) · AC5_EC3_EDGE_open_04_59_59_then_05_00_00_resets_screen (W: 100% cheerful → pump 1 s ที่ 04:59:59 ยัง 100% → 05:00:00 pump 1 s → ทุกแถบ 0%, total 0%, crying, 「ดื่มน้ำๆ」, ไม่มี SnackBar/AlertDialog) | ผ่าน |
| EC-4 ติดลบ / Null → 0 | GR3_row3_EC4_food_minus10_steps90_water90_food0_total60_dazed (L) · EC4_null_and_negative_category_become_0 (L) · EC4_GR3_row3_negative_food_shows_0_total_60_dazed (W) · EC4_EDGE_corrupt_storage_all_three_fallback_zero (C) · EC4_EDGE_corrupt_storage_no_crash_all_0 (W) | ผ่าน |
| EC-5 ทศนิยม → จำนวนเต็ม (65.66 → 66) | GR3_row2_EC5_food70_steps60_water67_total66_bubbly (L) · EC5_total_is_integer_rounded_65_67_to_66_and_65_33_to_65 (L) · EC5_GR3_row2_equivalent_65_67_shows_66_bubbly (W) · AC1_EC5_total_text_is_integer_no_decimal (W) | ผ่าน |
| 1. ค่าเกณฑ์พอดี ±1 | อารมณ์ 30/31, 60/61, 80/81 (L, W) · Priority 1 2,100 / 2,101 kcal (L, W) · P2 7/8 แก้ว (L) · P3 99%/100% (L) · P4 foodScore 49/50 (L) · หมุนข้อความ 4.999 / 5.000 s (C), 4.9 / 5.0 s (W) · 04:59:59 / 05:00:00 (C, W) | ผ่าน |
| 2. ข้ามวัน / รีเซ็ต | AC5_* / EC3_* ข้างบน · resume หลัง 05:00 (W) · เปิดหลัง 05:00 ด้วยข้อมูลเมื่อวาน (C) | ผ่าน |
| 3. เพดาน max / min | EDGE_category_min_max_0_and_100_never_outside (L) · DECIDED_Q14_water_target_8_cups_score_per_cup (9 แก้ว = 100) · DECIDED_D3_steps_ratio_round_and_cap (16,000 = 100) · EDGE_D3_food_far_over_target_floor_0_not_negative (4,001 / 9,000 kcal = 0) · EC1_* (W: แถบ ≤ 1.0) | ผ่าน |
| 4. ข้อมูลว่าง / เปิดครั้งแรก / ข้อมูลเสีย | EDGE_empty_first_open_all_zero_crying (L) · EDGE_first_open_no_data_all_zero_P2_first (C) · EC4_EDGE_corrupt_storage_all_three_fallback_zero (C: repository ทั้ง 3 throw) · EDGE_EC4_first_open_empty_all_0_crying_P2 (W) · EC4_EDGE_corrupt_storage_no_crash_all_0 (W) · UI_loading_shows_only_progress_indicator (W) | ผ่าน |

## 4. ตัวเลขใน game-rules / หน้าจอ / ข้อตัดสิน

| หัวข้อ | เทสต์ | ผล |
|---|---|---|
| game-rules §3 แถว 1 (60, 90, 60 → 70 BUBBLY) | GR3_row1_* (L ค่าตรงตามตาราง) · AC1_GR3_row1_equivalent_60_100_50_shows_70_bubbly (W — น้ำ 60% ทำไม่ได้ด้วยเป้า 8 แก้ว จึงใช้ชุดผลรวม 210 เท่ากัน) | ผ่าน |
| game-rules §3 แถว 2 (70, 60, 67 → 66 BUBBLY) | GR3_row2_* (L) · EC5_GR3_row2_equivalent_65_67_shows_66_bubbly (W — 71 + 76 + 50 = 197 → 65.67 → 66) | ผ่าน |
| game-rules §3 แถว 3 (−10, 90, 90 → Food 0, 60 DAZED) | GR3_row3_* (L) · EC4_GR3_row3_negative_food_shows_0_total_60_dazed (W — −10 kcal → `คะแนนอาหาร: 0%`, 0 + 80 + 100 = 180 → 60) | ผ่าน |
| game-rules §4 แถว 1 (100, 100, 160 → 120 → 100 CHEERFUL) | GR4_EC1_* (L) · EC1_GR4_* (W) | ผ่าน |
| game-rules §4 แถว 2 (P1 หลุดขณะแสดง → P2 ทันที) | EC2_GR4_P1_removed_while_showing_next_is_P2 (L) · EC2_GR4_P1_removed_while_showing_switches_to_P2_immediately (C) | ผ่าน |
| game-rules §4 แถว 3 (ข้าม 05:00 → ทุกคะแนนเป็นค่าวันใหม่) | AC5_EC3_* (C, W) | ผ่าน |
| alertInterval = 5 วินาที | AC3_EDGE_rotation_exactly_at_5s_not_4_999s_and_loops (C) · AC3_rotates_every_5s_P2_P3_P4_P2 (W) | ผ่าน |
| ข้อความ alert 4 ข้อตรงตัว (ไม่รวม `"` — Q-21) | AC3_exact_strings_4_priorities (L) · AC3_P1_exact_text_shown_once_red_food_bar_93 (W: `find.text(P1)` เจอ 1, ไม่มี maxLines/ellipsis, ไม่ใช่ SnackBar) · AC3_rotates_every_5s_* (W) | ผ่าน |
| D-3 สูตรรายหมวด | DECIDED_Q14_water_target_8_cups_score_per_cup · DECIDED_D3_steps_ratio_round_and_cap · DECIDED_D3_food_up_to_target_kcal_over_target_x100 · DECIDED_D3_food_over_target_100_minus_over_percent (2,100 = 95, 2,150 = 93, 3,000 = 50, 4,000 = 0) (L) | ผ่าน |
| Q-1 ไม่มีเป้าอาหาร | DECIDED_D3_Q1_food_no_target_not_scored_total_avg_of_2 · DECIDED_Q1_no_target_can_reach_100_cheerful (L) · DECIDED_Q1_no_target_label_color_bar0_total_avg2 (W: ป้าย, สี `onSurfaceVariant`, แถบ 0 สี primary, total 75, ไม่มี P1) | ผ่าน |
| ui-spec ช่องข้อความ: ห่างกล่องสัตว์เลี้ยง 12 px, สูงคงที่เมื่อหมุน/คิวว่าง, สัตว์เลี้ยงไม่ขยับ | UI_alert_slot_bottom_12px_above_pet_box · UI_slot_height_constant_and_pet_still_while_rotating · AC3_EDGE_empty_queue_hides_banner_keeps_slot (W) | ผ่าน |
| ทางเข้าจาก water (Q-7, ui-spec §2.0) | DECIDED_Q7_entry_button_icon_tooltip_position (ไอคอน `Icons.dashboard`, tooltip「แดชบอร์ด」, อยู่หลัง food ก่อนรายงาน, water ยังเป็นหน้าแรก) · DECIDED_Q7_tap_opens_S1_with_same_controllers_and_back (W) | ผ่าน |
| จอ 360×640 textScaler 1.0 | UI_360_scale_1_0_via_water_P1_full_no_overflow (เข้าทางปุ่มบน water, P1 ไม่ถูกตัด, ไม่มี exception) · UI_360_scale_1_0_water_appbar_three_icons_no_overflow · DECIDED_Q1_360_scale_1.0_no_target_label_no_overflow (W) | ผ่าน |
| จอ 360×640 textScaler 1.5 | UI_360_scale_1_5_P1_full_no_overflow (P1 ไม่ถูกตัด, อยู่ในฟองและช่อง, ช่องห่าง 12 px, หมุนแล้วช่องไม่เปลี่ยน) · DECIDED_Q1_360_scale_1.5_no_target_label_no_overflow · UI_360_scale_1_5_can_scroll_to_water_bar (W) — เปิด S-1 ตรง ไม่ผ่านหน้า water เพราะหน้า water overflow เองที่ 1.5 (§8) | ผ่าน |
| Timer ถูก cancel | UI_dispose_cancels_alert_timer (C) · ทุก W ไม่มี "Timer still pending" | ผ่าน |
| เทสต์เดิม (signup S-7, water, steps, food) ไม่กระทบ | `flutter test` ทั้งแอป: 603 เทสต์เดิมผ่านครบ | ผ่าน |

## 5. รายการ Bug

### BUG-DASH-1 — 「ฉันหิว」(Priority 4) ไม่เข้าคิวเมื่อกินเกินเป้ามากจน foodScore < 50

- **ความรุนแรง:** ต่ำ (มีผลเฉพาะกินเกินเป้า > 50% เช่น > 3,000 kcal ที่เป้า 2,000) · **เทสต์:** `DECIDED_D4_P4_far_over_target_food_score_below_50_in_queue` (dashboard_logic_test.dart)
- **ขั้นตอนทำซ้ำ:** เป้า 2,000 kcal (ชาย 25 ปี BMI ปกติ) · บันทึกอาหาร 3,500 kcal (1 มื้อ) · น้ำ 0 แก้ว · ก้าว 0 → ดูคิวข้อความ (`DashboardLogic.snapshot(...).alerts`)
- **ผลที่คาด (อ้างเอกสาร):** foodScore = max(0, 100 − 1,500/2,000×100) = 25 (D-3) → 25 < 50 ⇒ trigger P4 ตาม game-rules §1.1 Priority 4 「ยังไม่ได้บันทึกอาหารมื้อใดๆ **หรือ**คะแนนอาหารต่ำกว่าเกณฑ์」 + D-4 (`foodScore < 50`) + ui-spec Q-3 (owner ใช้ตาม ui-spec: 「อยู่ในคิวเมื่อ … **หรือ** (มี foodScore และ `< 50`)」) → คิว = [P1, P2, P3, P4]
- **ผลจริง:**
  ```
  Expected: [P1 'แต่วันนี้ฉันอิ่ม…', 'ดื่มน้ำๆ', 'ขยับร่างกายหน่อย อีกนิดๆ', 'ฉันหิว']
    Actual: [P1 'แต่วันนี้ฉันอิ่ม…', 'ดื่มน้ำๆ', 'ขยับร่างกายหน่อย อีกนิดๆ']
     Which: at location [3] … shorter than expected
  ```
  สาเหตุ: `DashboardLogic.isHungry` คืน `false` เมื่อ `isFoodOverTarget` (Dev ASSUMPTION A-7 "นับ foodScore < 50 เฉพาะตอน kcal ≤ target") — เป็นเงื่อนไขที่ไม่มีในเอกสาร/ข้อตัดสิน
- **หมายเหตุ:** Dev ยกเป็นคำถาม QD-2 ไว้แล้ว (ข้อความ「ฉันหิว」ขัดความหมายกับ P1「อิ่มและอืดเกินไป」) — ถ้า owner ยืนยัน A-7 ให้แก้ game-rules §1.1 / D-4 ก่อน แล้ว QA จะปรับเทสต์ตามเอกสารใหม่ (ดู §7 ข้อ 4) · ยังไม่แก้ตามโค้ด

## 6. เทสต์ที่ QA แก้เอง (เทสต์ผิด)

| เทสต์ | ปัญหา | แก้อย่างไร |
|---|---|---|
| UI_card_and_bubble_colors_from_color_scheme | รอบแรก `_TypeError` — เทสต์สมมติว่า key `dashboard_alert_banner` อยู่บน `Container` เอง แต่ ui-spec กำหนด "(บน `Container`)" เฉพาะการ์ดคะแนน (`dashboard_total_score_card`) ไม่ได้บังคับชนิด widget ของฟองข้อความ | หา `Container` ที่เป็นลูกของ `dashboard_alert_banner` แล้วตรวจสี `secondaryContainer` (ค่าคาดหวังเดิม) |

## 7. คำถามค้าง (ไม่นับเป็น bug — ไม่ได้ assert จุดที่เอกสารไม่ระบุ)

1. **เอกสารยังไม่ตรงข้อตัดสิน** — requirements AC-5/US-5/§6, ux-flow §2–§6, game-rules §1/§2/§4/§5 ยังอ้าง Server Time / ICT / Session Database / PNG 300×300 (D-1, D-2, Q-9, Q-12, Q-15) — ต้องให้ Design/Product อัปเดตหลังทีมยืนยัน
2. **คะแนนปัดถึง 100 ทั้งที่ยังไม่ถึงเป้า** — D-3 ปัดก่อนเทียบ: 7,960–7,999 ก้าว (เป้า 8,000) = stepsScore 100 → 「ขยับร่างกายหน่อย อีกนิดๆ」หลุดคิว แม้ removal ใน game-rules §1.1 เขียนว่า "เดินครบตามเป้าหมาย" (อาหาร 1,990–1,999 kcal = 100 ก็เช่นกัน) — เทสต์ใช้เฉพาะ 7,920 (99) / 8,000 (100) ไม่ assert ช่วงนี้
3. **การปัด .5** (half-up หรือ banker's) เอกสารไม่ระบุ — ค่า .5 ที่ assert มีเฉพาะที่ ui-spec ระบุเลขไว้เอง (7 แก้ว = 88 ใน Q-14, 2,150 kcal = 93 ใน §3) · ไม่ assert ค่ารวมที่ลงท้าย .5 กรณี Q-1 (หาร 2)
4. **QD-2 / BUG-DASH-1** — กินเกินเป้ามากจน foodScore < 50 ควรขึ้น「ฉันหิว」คู่กับ P1 หรือไม่ (เอกสาร/D-4 ตามตัวอักษร = ขึ้น, Dev A-7 = ไม่ขึ้น) — owner ตัดสิน
5. **EC-2 สำหรับ Priority 1** — Q-2 ไม่มีทาง "จัดการปัญหาอาหาร" ในแอป (P1 ค้างจนตัดรอบ) เทสต์ C จำลองการหลุดคิวด้วยเป้าที่เปลี่ยนจากโปรไฟล์ (2,000 → 2,400) เพื่อพิสูจน์กลไก "ข้ามไป P2 ทันที" — ถ้าการเปลี่ยนเป้าไม่ควรนับว่า "แก้ปัญหา" ต้องกำหนดเพิ่ม
6. **"ทันที" ของ EC-3** — S-1 ตรวจรอบวันทุก 1 วินาที (Dev A-9) เอกสารไม่กำหนดความหน่วงที่ยอมรับได้ — เทสต์ยอมรับการรีเซ็ตภายใน 1 วินาทีหลัง 05:00:00
7. **ข้อความที่ไม่ได้แสดงหลุดคิว / ข้อความใหม่เข้าคิว** — Q-19 ตอบแค่ "เริ่มจาก Priority สูงสุด" เทสต์ assert เฉพาะ P1 เข้าคิวแล้วขึ้นทันที (DECIDED_Q19) ไม่ assert กรณีข้อความอื่นที่ไม่ได้แสดงหลุดคิว (Dev A-8 คงข้อความเดิม)
8. **QD-1 เป้าน้ำ 8 แก้ว** — สัตว์เลี้ยงหน้า water ร่าเริงที่ 7 แก้ว แต่ dashboard ยังแสดง 88% และ「ดื่มน้ำๆ」
9. **QD-3 ปุ่ม「รายงานรายเดือน」บน AppBar ของ water** — Dev ห่อ Flexible + ellipsis เพื่อไม่ให้ AppBar ล้นที่ 360 dp (ui-spec §2.0 ประเมินว่าไม่ล้น) — เทสต์ยืนยันแค่ "ไม่มี overflow" ไม่ได้ตรวจว่าป้ายถูกตัดหรือไม่ — UI ต้องยอมรับ
10. **QD-4 ช่องข้อความ** — Dev ใช้ min-height ที่วัดจากข้อความ P1 แทน `Visibility(maintainSize)` — เทสต์ตรวจผลบนจอตาม ui-spec (12 px, ความสูงคงที่, P1 ไม่ถูกตัด, `find.text(P1)` เจอ 1) ผ่านทั้งหมด — UI ต้องยอมรับวิธี
11. **ไม่มีเป้าอาหาร + ยังไม่ผ่าน S-3** — ux-flow ไม่บอกว่า S-1 ของ dashboard ควรพาไปตั้งโปรไฟล์หรือไม่ (ui-spec: ไม่มี CTA) — ไม่ได้ assert

## 8. ข้อสังเกต: หน้า water ที่ 360×640 textScaler 1.5 (ไม่นับเป็นบั๊ก dashboard)

- **ผลบนโค้ดปัจจุบัน:** `A RenderFlex overflowed by 68 pixels on the bottom` ที่ `Column` ของ body (`water_home_screen.dart:256` — `_buildContent` → `SafeArea` → `Padding(24)` → `Column` ไม่มี scroll) · AppBar ไม่ล้น · ที่ textScaler 1.0 ไม่มี error
- **มีมาก่อนงาน dashboard:** `git diff HEAD -- app/lib/features/water/` แก้แค่ import, `_openSteps`/`_openFood` → `_stepsController()`/`_foodController()`, `_openDashboard` และ `AppBar.actions` (hunk สุดท้ายจบที่บรรทัด 189 ของ HEAD ก่อน `body:` ที่บรรทัด 193) — ไม่แตะ body · รันเทสต์ probe เดียวกันบนสำเนา HEAD (`git archive HEAD app` แตกลง scratchpad ไม่แตะ working tree) ได้ **2 error**: `RenderFlex overflowed by 79 pixels on the right` ที่ AppBar (`:164`) + `overflowed by 68 pixels on the bottom` ที่ body (`:213`) → body overflow 68 px เท่าเดิม = ของเดิม · AppBar overflow ที่ 1.5 ถูก Dev แก้ไปแล้วด้วย Flexible (ผลข้างเคียงดี)
- **ผลต่อเทสต์:** เทสต์ 360×640 ที่ 1.5 เปิด S-1 ตรง (ไม่ผ่านหน้า water) · ที่ 1.0 เปิดผ่านปุ่มบนหน้า water
- **แนะนำ:** เปิด issue แยกของ water (ห่อ body ด้วย scroll แบบ steps/food)

## 9. ผลการรัน (ใน app/)

| คำสั่ง | ผล |
|---|---|
| `flutter analyze` | `No issues found! (ran in 5.9s)` |
| `flutter test test/dashboard/dashboard_logic_test.dart` | `00:00 +44 -1: Some tests failed.` (BUG-DASH-1) |
| `flutter test test/dashboard/dashboard_controller_test.dart` | `00:00 +18: All tests passed!` |
| `flutter test test/dashboard/dashboard_screens_test.dart` | `00:13 +43: All tests passed!` |
| `flutter test` (ทั้งแอป) | `02:37 +708 -1: Some tests failed.` — ไม่ผ่านตัวเดียวคือ DECIDED_D4_P4_far_over_target_food_score_below_50_in_queue |

---

# รอบที่ 3 (2026-10-31)

> ผู้ทดสอบ: QA agent · 09:22–09:31 · โค้ดที่ทดสอบ: dev r3 (`logs/20261031-0921_dev_dashboard_r3.md`) ได้แก่ floor ทุกสูตรใน `dashboard_rules.dart`, `FoodProfileCtaBanner` บน S-1, ปุ่มรายงานของ water เป็น `IconButton`
> ไม่ได้แก้ `app/lib/` · ไม่ได้แก้ไฟล์อื่นใน `docs/dashboard/` · ไม่ได้ commit / push

## 10. ข้อตัดสิน owner รอบ 3 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน)

ข้อตัดสินรอบนี้ชนะเอกสารและข้อตัดสินรอบก่อน เทสต์ที่อิงข้อตัดสินนี้จะมี `DECIDED_R3` ในชื่อ

| ข้อ | เนื้อหา | ชนะ / แทนที่ |
|---|---|---|
| 1 | BUG-DASH-1 / QD-2: ยึด A-7 คือกินเกินเป้าไม่ต้องขึ้น「ฉันหิว」 (P4 ใช้ foodScore < 50 เฉพาะตอน kcal ≤ target) | D-4 ตามตัวอักษร, ui-spec Q-3 |
| QD-1 | เป้าน้ำ 8 แก้วจากค่าคงที่ของ water ใช้ต่อ | (ยืนยัน Q-14) |
| 2 | ปัดลง (floor) ทุกคะแนน (Water, Steps, Food, total) ได้ 100 ก็ต่อเมื่อถึงเป้าจริงเท่านั้น · Food เกินเป้า = 100 − ceil(over×100/target) | game-rules §3 แถว 2 / EC-5 (65.66 → **65** BUBBLY), round ของ D-3 / Q-1, Q-16, Q-13 (30.67 → 30 = CRYING) |
| 3, 4, 8 | A-8 (เลือกข้อความเมื่อคิวเปลี่ยน), ตรวจรอบวันทุก 1 วินาที, min-height แทน Visibility: ใช้ตามที่ dev ทำ | คำถามรอบ 1 ข้อ 6, 7, 10 |
| 5 | ไม่มีเป้าอาหาร → S-1 แสดง CTA เดิมของ food (`food_profile_cta_banner`) ใต้แถบอาหาร กดแล้วเปิด S-3 ของ food | คำถามรอบ 1 ข้อ 11, ui-spec §3 "ไม่มี CTA" |
| 7 | `water_monthly_report_button` เป็นปุ่มไอคอน + tooltip「รายงานรายเดือน」 ไม่มีข้อความบนปุ่ม | water ux-flow (ป้ายบนปุ่ม), คำถามรอบ 1 ข้อ 9 |

ค่าคาดหวังที่คำนวณเองจากข้อ 2 (ไม่ได้ลอกจากโค้ด): 7 แก้ว = floor(87.5) = 87 · 3 แก้ว = 37 · 7,999/8,000 ก้าว = 99 · 1,999/2,000 kcal = 99 · 2,001 kcal = 100 − ceil(0.05) = 99 · 2,101 = 100 − ceil(5.05) = 94 · 2,150 = 100 − ceil(7.5) = 92 · 3,500 = 25 · (70+60+67)/3 = 65.67 → 65 · (92+90+75)/3 = 85.67 → 85

## 11. สรุปตัวเลขรอบ 3

| รายการ | ค่า |
|---|---|
| เทสต์ dashboard ทั้งหมด | **116** (L 47 · C 18 · W 51) = รอบ 1 106 ตัว + ใหม่ 10 ตัว |
| ผ่าน / ไม่ผ่าน (dashboard) | **116 / 0** |
| `flutter test` ทั้งแอป | **719 ผ่าน / 0 ไม่ผ่าน** (`02:53 +719: All tests passed!`) |
| `flutter analyze` | `No issues found! (ran in 5.2s)` |
| AC 5/5 · EC 5/5 มีเทสต์และผ่าน · AC/EC ที่ยังไม่มีเทสต์ | ไม่มี |
| Bug ใหม่ | **0** · BUG-DASH-1 ปิดแล้ว (owner เปลี่ยนพฤติกรรมที่ถือว่าถูกตามข้อ 1 ไม่ได้ปิดเพราะ dev แก้โค้ด) |
| เทสต์ที่ปรับเพราะข้อตัดสินรอบ 3 | 12 ตัว (§12) ตรงกับรายชื่อ 12 ตัวใน dev log r3 ทุกตัว |
| เทสต์ที่ QA แก้เองเพราะเทสต์ผิด (รอบนี้) | 0 |
| เทสต์ใหม่ | 10 ตัว (§13) |

## 12. เทสต์ที่ปรับ (ค่าคาดหวังเปลี่ยนเพราะข้อตัดสินรอบ 3)

| # | เทสต์เดิม → ชื่อใหม่ | เดิม → ใหม่ | เพราะข้อ |
|---|---|---|---|
| 1 | GR3_row2_EC5_food70_steps60_water67_total66_bubbly → `DECIDED_R3_GR3_row2_EC5_food70_steps60_water67_total65_bubbly` (L) | 66 → 65 (ยัง BUBBLY) | 2 |
| 2 | EC5_total_is_integer_rounded_65_67_to_66_and_65_33_to_65 → `DECIDED_R3_EC5_total_is_integer_floor_65_67_and_65_33_to_65` (L) | 197/3: 66 → 65 | 2 |
| 3 | `DECIDED_Q14_water_target_8_cups_score_per_cup` (L, ชื่อเดิม) | 7 แก้ว 88 → 87 | 2 (เป้า 8 แก้วคงเดิมตาม QD-1) |
| 4 | `DECIDED_D3_food_up_to_target_kcal_over_target_x100` (L, ชื่อเดิม) | 1,999 kcal 100 → 99 | 2 |
| 5 | `DECIDED_D3_food_over_target_100_minus_over_percent` (L, ชื่อเดิม) | 2,150 kcal 93 → 92 | 2 |
| 6 | DECIDED_Q16_total_from_rounded_category_scores → `DECIDED_R3_total_floor_of_floored_category_scores` (L) | 86 → 85 (food 92) | 2 (แทน Q-16) |
| 7 | DECIDED_Q13_mood_from_rounded_total_30_4_crying_30_5_dazed → `DECIDED_R3_mood_from_floored_total_30_67_is_crying` (L) | Food 92 (30.67): DAZED → total 30 CRYING (เพิ่มเช็ก Food 93 = 31 DAZED) | 2 (แทน Q-13) |
| 8 | DECIDED_D4_P4_far_over_target_food_score_below_50_in_queue → `DECIDED_R3_A7_P4_far_over_target_food_score_below_50_not_in_queue` (L) | [P1,P2,P3,P4] → [P1,P2,P3] | 1 |
| 9 | EC5_GR3_row2_equivalent_65_67_shows_66_bubbly → `DECIDED_R3_EC5_GR3_row2_equivalent_65_67_shows_65_bubbly` (W) | `คะแนนสุขภาพรวม: 66%` → `65%` | 2 |
| 10 | `UI_realtime_update_when_source_changes` (W, ชื่อเดิม) | 3 แก้ว 38% → 37% | 2 |
| 11 | AC3_P1_exact_text_shown_once_red_food_bar_93 → `AC3_P1_exact_text_shown_once_red_food_bar_DECIDED_R3_92` (W) | `คะแนนอาหาร: 93%` / 0.93 → `92%` / 0.92 | 2 |
| 12 | `UI_S1_button_label_and_plus_icon_per_ux_flow` (`app/test/water/water_screens_test.dart`, ชื่อเดิม) | เดิมหา `Text('รายงานรายเดือน')` บนปุ่ม → ตรวจ tooltip ของ `IconButton` =「รายงานรายเดือน」และไม่มีข้อความบนปุ่ม | 7 (spec เปลี่ยนตามข้อตัดสิน ไม่ใช่ปรับตามโค้ด) |

ไม่มีเทสต์อื่นที่ค่าคาดหวังเปลี่ยน: ขอบอารมณ์ 30/31/60/61/80/81, ตัวอย่าง §3 แถว 1 และ 3, §4, P1 2,100/2,101, P4 49/50 ใช้ค่าที่หารลงตัวอยู่แล้ว จึงได้ผลเท่ากันทั้ง round และ floor

## 13. เทสต์ใหม่รอบ 3

| เทสต์ | ไฟล์ | ตรวจอะไร | ข้อ |
|---|---|---|---|
| DECIDED_R3_EDGE_100_only_when_target_reached | L | 7 แก้ว 87 / 8 แก้ว 100 · 7,999 ก้าว 99 / 8,000 ก้าว 100 · 1,999 kcal 99 / 2,000 kcal 100 / 2,001 kcal 99 / 2,101 kcal 94 · ที่ 7,999 ก้าวยังมี「ขยับร่างกายหน่อย อีกนิดๆ」 · (100+99+100)/3 = 99 | 2 |
| DECIDED_R3_Q1_no_target_total_floor_of_half | L | ไม่มีเป้า: (100 + 87)/2 = 93.5 → 93 | 2 + Q-1 |
| DECIDED_R3_Q5_no_target_shows_food_cta_under_food_bar | W | มี `food_profile_cta_banner` พร้อมข้อความ food「ตั้งค่าโปรไฟล์สุขภาพเพื่อรับเป้าหมายแคลอรี่ที่แม่นยำ」 อยู่ใต้ `dashboard_food_bar` และเหนือแถวก้าว | 5 |
| DECIDED_R3_Q5_with_target_no_cta | W | มีเป้า → ไม่มี CTA | 5 |
| DECIDED_R3_Q5_tap_cta_opens_food_profile_screen | W | กด CTA แล้วเปิด `FoodProfileScreen` (มี `food_profile_save_button`) | 5 |
| DECIDED_R3_Q5_360_scale_1.0_cta_no_overflow / _1.5_ | W (2) | 360×640 ไม่มี exception · CTA อยู่ในความกว้างจอ · ยอดรวม `food_cta_total_text` ไม่ถูกตัดและอยู่ในกรอบ CTA | 5 |
| DECIDED_R3_Q7_report_button_icon_only_tooltip | W | `water_monthly_report_button` เป็น `IconButton`, tooltip「รายงานรายเดือน」, ไม่มีข้อความบนปุ่ม | 7 |
| DECIDED_R3_Q7_water_appbar_360_scale_1.0_no_overflow / _1.5_ | W (2) | หน้า water 360×640 ไม่มี error ที่มาจาก AppBar / NavigationToolbar · ปุ่มทั้ง 4 (steps, food, dashboard, รายงาน) อยู่ในจอช่วง 0–360 · ที่ 1.5 เทสต์เก็บ error เองและกรองเฉพาะ error ของ AppBar เพราะ body ของ water ล้นแนวตั้ง 68 px ซึ่งเป็นปัญหาเดิม (§8) | 7 |

เทสต์ food เดิมทั้งหมดยังผ่านหลัง dev ย้าย CTA ไปเป็น `FoodProfileCtaBanner` (นับรวมอยู่ใน 719 ตัว)

## 14. คำถามค้าง (รอบ 3)

1. **เอกสารยังไม่ตรงข้อตัดสิน**: game-rules §3 แถว 2 / requirements EC-5 ยังเขียน 65.66 → 66 (ข้อ 2 ให้ 65, dev QD-8), game-rules §1.1 P4 ยังไม่มีข้อยกเว้นกรณีกินเกินเป้า (ข้อ 1), ui-spec §3 ยังเขียนว่าไม่มี CTA (ข้อ 5), ui-spec Q-14 ยังเขียน 88 และ §3 ยังเขียน 93% · ข้อ 1 ของรอบ 1 (Server Time / PNG) ก็ยังค้าง ต้องให้ Design / Product / UI อัปเดต
2. **QD-6 ตำแหน่ง CTA**: ตอนนี้อยู่ใต้แถบอาหาร และยังคงป้าย「คะแนนอาหาร: ยังไม่มีเป้าหมาย」+ แถบ 0 ไว้ · เทสต์ assert แค่ "ใต้แถบอาหาร ก่อนแถวก้าว" ตามข้อตัดสิน ไม่ได้ assert ระยะ 8
3. **QD-7 key ของ CTA**: ใช้ key ของ food (`food_profile_cta_banner`) ตามข้อตัดสิน "CTA เดิมของ food" · ถ้าเปลี่ยนเป็น key `dashboard_` ต้องแก้เทสต์ตาม
4. **ข้อความชวนใน CTA** (`food_cta_text`) มี `maxLines: 2` + ellipsis ตาม food ui-spec #9b · เทสต์ที่ 360 ตรวจว่ายอดรวมไม่ถูกตัด แต่ไม่ได้ assert ว่าข้อความชวนไม่ถูกตัด (food spec อนุญาตให้ตัด)
5. **EC-2 ของ P1** (คำถามรอบ 1 ข้อ 5) ยังค้าง: ทดสอบด้วยการเปลี่ยนเป้าจากโปรไฟล์ · กรณีมีเป้าแล้วกินเกินยังไม่มีทางให้ผู้ใช้ "จัดการ" ได้
6. ข้อสังเกตหน้า water (body ล้น 68 px ที่ textScaler 1.5) ยังอยู่ ควรเปิด issue แยกของ water

## 15. ผลการรันรอบ 3 (ใน app/)

| คำสั่ง | ผล |
|---|---|
| `flutter analyze` | `No issues found! (ran in 5.2s)` |
| `flutter test test/dashboard/ test/water/water_screens_test.dart` | `00:18 +133: All tests passed!` |
| `flutter test` (ทั้งแอป) | `02:53 +719: All tests passed!` (exit 0) |
| `flutter test test/dashboard/dashboard_logic_test.dart` | `00:15 +47: All tests passed!` |
| `flutter test test/dashboard/dashboard_controller_test.dart` | `00:07 +18: All tests passed!` |
| `flutter test test/dashboard/dashboard_screens_test.dart` | `00:13 +51: All tests passed!` |

=== จบ docs/dashboard/test-report.md ===

=== logs/20261031-0824_dev_dashboard.md ===
# Log: dev · dashboard · 2026-10-31 08:24

| รายการ | ค่า |
|---|---|
| สถานะ | เสร็จ (รอ QA เขียน app/test/dashboard/) |
| agent | Flutter Developer |
| branch | feat/dashboard-dev (ไม่ commit / ไม่ push ตามคำสั่ง) |
| เอกสารที่อ่าน | docs/dashboard/requirements.md, ux-flow.md, game-rules.md, ui-spec.md (ครบ 4 ไฟล์) · ไม่มี review.md · บริบท: logs/20261031-0707_art_dashboard.md, logs/20261031-0745_ui_dashboard.md |

## ข้อตัดสินของ owner — DECIDED (owner ชั่วคราว, รอทีมยืนยัน)

รอบ 1
- D-1 สัตว์เลี้ยงใช้ `PetCharacter` ไม่ใช้ PNG
- D-2 เวลาเครื่อง ตัดรอบ 05:00 แบบเดียวกับ water / steps / food — ไม่มี Server Time / Session Database
- D-3 คะแนน: Water, Steps = `round(min(actual/target,1)×100)`; Food: ถึงเป้า = `(kcal/target)×100`, เกินเป้า = `max(0, 100 − (ส่วนที่เกิน/target×100))`, ไม่มีเป้า = ไม่คิดคะแนน
- D-4 Priority 4 "คะแนนอาหารต่ำกว่าเกณฑ์" = `foodScore < 50`

รอบ 2
- Q-1 Food ไม่มีเป้า → total = `round((Steps + Water) / 2)`
- Q-14 เป้าน้ำ derive จากค่าคงที่ของ water (`energyMaxDisplayPercentage / energyIncrementPercentage` = 8 แก้ว) — จดเป็นคำถามถึง Design (B)
- Q-3, Q-16, Q-19, Q-20, Q-21, Q-8: ใช้ตามที่ ui-spec เลือก
- Q-4 / Q-5 / Q-17: brief ขัดกับ game-rules → ยึด game-rules และ D-3
- Q-7: water ยังเป็นหน้าแรก เข้า dashboard ผ่านปุ่ม
- Q-2: ลบมื้ออาหารไม่อยู่ในขอบเขตรอบนี้ (P1 ค้างจนตัดรอบ 05:00)
- Q-11: ยึด ux-flow ไม่แสดงจำนวนจริง / ป้ายโซเดียม-น้ำตาล
- BUBBLY: ใช้หน้าเดิม (`dashboardBubbly == waterHappy`)
- Q อื่นใน ui-spec §6: ใช้ค่าชั่วคราวที่ ui-spec เลือก (Q-6, Q-9 = 200, Q-10, Q-12, Q-13, Q-15, Q-18)

## AC / EC → ไฟล์

| ID | ทำที่ |
|---|---|
| AC-1 / EC-1 / EC-5 คะแนนรวม (avg, cap 100, integer) | `DashboardRules.totalScore`, `clampScore` (dashboard_rules.dart) · การ์ด `dashboard_total_score_card/_text` (screens/dashboard_screen.dart) |
| AC-2 อารมณ์ 4 ช่วง | `DashboardRules.cryingMaxScore/dazedMaxScore/bubblyMaxScore` · `DashboardLogic.moodFor`, `poseFor` · `KeyedSubtree('dashboard_pet_image_<mood>')` + `PetCharacter(GlobalKey, size 200, ไม่มี cheerTrigger)` |
| AC-3 / EC-2 Dynamic Alert Queue 5 วินาที | `DashboardAlert` (dashboard_models.dart), `DashboardLogic.alertQueue / isHungry / resolveAlert / nextAlert`, `DashboardController` (Timer `alertIntervalSeconds`) · ฟอง `dashboard_alert_slot/_banner/_text` |
| AC-4 3 แถบรายหมวด | `_buildBarRow` → `dashboard_<food/steps/water>_row/_label_text/_bar` (แถบอาหารสี error เมื่อ `FoodController.isOverLimit`) |
| AC-5 / EC-3 ตัดรอบ 05:00 ขณะเปิดค้าง | ไม่มีรอบวันของตัวเอง — `DashboardController.refreshDay()` เรียก `water.refreshDailyReset()` / `steps.refreshDay()` / `food.refreshDay()` ทุก 1 วินาที + ตอน resume; ข้ามวัน (`steps.state.day`/`food.state.day` เปลี่ยน) → ฟองเริ่มที่ข้อความ Priority สูงสุด |
| EC-4 ติดลบ/Null → 0 | `DashboardRules.clampScore`, `ratioScore` |
| ui-spec §2.0 ทางเข้า | `dashboard_entry_button` ใน AppBar ของ `WaterHomeScreen` (หลัง food ก่อน report) ส่ง controller ตัวเดียวกับ steps/food |
| ui-spec §3 ไม่มีเป้าอาหาร | ป้าย 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 สี onSurfaceVariant, แถบ 0, total หาร 2 |
| ui-spec §3 กำลังโหลด | `CircularProgressIndicator` เมื่อ controller ใดยัง `!isLoaded` |

## ไฟล์

สร้าง (5)
- app/lib/features/dashboard/dashboard_rules.dart — สูตร D-3, Q-1, เกณฑ์ mood/alert, alertInterval, petSize, anchor, ข้อความทั้งหมด
- app/lib/features/dashboard/dashboard_models.dart — `DashboardPetMood`, `DashboardAlert`, `DashboardInput`, `DashboardSnapshot`
- app/lib/features/dashboard/dashboard_logic.dart — pure Dart: snapshot, moodFor, poseFor, alertQueue, resolveAlert, nextAlert
- app/lib/features/dashboard/dashboard_controller.dart — รวม 3 controller (ไม่เก็บข้อมูล) + Timer หมุนข้อความ (`DashboardTimerFactory` inject ได้)
- app/lib/features/dashboard/screens/dashboard_screen.dart — S-1

แก้ (1)
- app/lib/features/water/screens/water_home_screen.dart — เพิ่ม `dashboard_entry_button` + `_openDashboard`; แยก `_stepsController()` / `_foodController()` (โค้ดเดิมย้ายมา พฤติกรรมเดิม); ปุ่ม `water_monthly_report_button` ห่อ `Flexible` + label `maxLines: 1, ellipsis` (ดู ASSUMPTION A-10)

ไม่แก้ docs/, app/test/, app/lib/shared/pet/, pubspec

## ASSUMPTION ทั้งหมด

| # | จุด | สมมติฐาน |
|---|---|---|
| A-1 | `DashboardRules.waterTargetCups` | Q-14: derive = 100 / 12.5 = 8 แก้ว จาก `WaterRules` (ไม่พิมพ์ 8) |
| A-2 | `ratioScore` | D-3 คำนวณ `actual×100/target` หารครั้งเดียว; target ≤ 0 → 0 |
| A-3 | `foodScore` | D-3 + Q-16 ปัดเป็นจำนวนเต็ม; target ≤ 0 = ไม่มีเป้า |
| A-4 | `totalScore` | Q-1 หาร 2 เมื่อไม่มีเป้า; Q-16 เฉลี่ยจากคะแนนที่ปัดแล้ว |
| A-5 | `foodHungryBelowScore` | D-4 = 50 |
| A-6 | `isHungry` | Q-3 ประเมินสด (บันทึกแล้วแต่ < 50 ยังอยู่ในคิว); ไม่มีเป้า → ใช้แค่ "ยังไม่บันทึกมื้อ" |
| A-7 | `isHungry` | **ใหม่:** "foodScore < 50" นับเฉพาะตอน kcal ≤ target — กินเกินเป้ามากจน foodScore < 50 จะไม่ขึ้น「ฉันหิว」 (ขัดกับ P1) → คำถาม QD-2 |
| A-8 | `resolveAlert` | Q-19: เริ่ม/ข้ามวัน/มีข้อความใหม่เข้าคิว → Priority สูงสุด · ข้อความที่แสดงหลุดคิว → ข้อความลำดับถัดไปทันที (EC-2) วนกลับต้นคิว · ข้อความอื่นหลุด → คงข้อความเดิม · ข้อความเปลี่ยน = เริ่มนับ 5 วินาทีใหม่ |
| A-9 | `dayCheckIntervalSeconds` | 1 วินาที แบบ steps/food |
| A-10 | water AppBar | ui-spec §2.0 ว่า 3 ไอคอน + ปุ่มรายงานไม่ล้นที่ 360 dp แต่ตรวจจริงล้น 41 px (ฟอนต์เทสต์) → ปุ่มรายงานหดได้ + ellipsis (key/ข้อความ/ลำดับเดิม; จอกว้างเหมือนเดิม) → คำถาม QD-3 |
| A-11 | `dashboard_alert_slot` | ui-spec เสนอ Stack + Visibility(maintainSize) ซ่อนข้อความ P1 แต่ทำให้ `find.text(P1)` เจอ 2 ตัว (ตรวจแล้ว) → วัดความสูงฟอง P1 ด้วย TextPainter แล้วใช้เป็น min height ผ่าน `FoodSharedMinHeightBox` (ของเดิม) — ช่องสูงเท่าฟอง P1 เสมอ ไม่ล็อกความสูง |
| A-12 | ฟองข้อความ | ฟองเต็มความกว้าง สูงตามข้อความ จัดกลางแนวตั้งในช่อง |
| A-13 | `screenTitle` / `entryTooltip` | Q-8 「แดชบอร์ด」 |
| A-14 | `foodNoTargetText` | Q-1 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 |
| A-15 | ข้อความแจ้งเตือน | Q-21 ไม่รวม `"` |
| A-16 | `DashboardController.start` | food โหลดแล้ว → `refreshDay()` + `refreshProfile()` แบบ FoodDashboardScreen (เป้า kcal อัปเดตตามโปรไฟล์) |

## Package ที่เพิ่ม

ไม่มี (ห้ามเพิ่มตามคำสั่ง) · ไม่มี network / analytics / crash reporting

## คำถามที่ค้าง

- QD-1 (Design B, Q-14): ยืนยันเป้าน้ำ 8 แก้ว (derive จาก 100 / 12.5) — สัตว์เลี้ยง water ร่าเริงที่ 7 แก้ว แต่ waterScore = 88 และยังมี「ดื่มน้ำๆ」ในคิว
- QD-2 (Design/Product, D-4): กินเกินเป้ามากจน foodScore < 50 ควรขึ้น「ฉันหิว」ด้วยหรือไม่ — ตอนนี้ไม่ขึ้น (A-7)
- QD-3 (UI): ui-spec §2.0 ประเมินว่า AppBar ไม่ล้นที่ 360 dp แต่ล้นจริง 41 px — ยอมรับการหดป้าย「รายงานรายเดือน」ด้วย ellipsis หรือจะเปลี่ยนเป็นปุ่มไอคอน (A-10)
- QD-4 (UI): ยอมรับการวัดความสูงช่องแทน Visibility ซ่อนข้อความหรือไม่ (A-11)
- QD-5 (Design, Q-19): กฎเลือกข้อความเมื่อคิวเปลี่ยน (A-8) รอ game-rules ยืนยัน
- ข้อสังเกต (ไม่ได้แก้ — ไม่อยู่ในขอบเขต): body ของ `WaterHomeScreen` (ไม่มี scroll) overflow แนวตั้งที่ 360×640 dp + textScaler 1.5 — ของเดิมก่อนงานนี้

## ตัวเลขการทำงาน

| รายการ | ค่า |
|---|---|
| เวลาที่ใช้ | ~50 นาที (≈07:35–08:24) |
| ไฟล์สร้าง | 5 (+ log นี้) |
| ไฟล์แก้ | 1 |
| สมมติฐาน | 16 |
| คำถามค้าง | 5 (+ ข้อสังเกต 1) |

## ผล analyze / test

- `flutter analyze` (ใน app/): **No issues found!**
- `flutter test` (ใน app/): **603/603 ผ่าน** (All tests passed!)
- เช็กเองด้วยเทสต์ชั่วคราว app/tmp_dashboard_check/ (นอก app/test/, **ลบแล้ว**) 7 เคสผ่าน: ตัวอย่าง game-rules §3 (70 / 66 / 60 / cap 100), ขอบอารมณ์ 30/31/60/61/80/81, foodScore 2150/2000 = 93, ฟองหมุน P2→P3→P4→P2 ทุก 5 วินาที, บันทึกเกินเป้า → P1 ทันที + แถบแดง, ข้าม 05:00 ขณะเปิดค้าง → ทุกอย่าง 0%, ช่องข้อความห่างกล่องสัตว์เลี้ยง 12 px และสูงคงที่เมื่อข้อความหมุน, คิวว่าง → ไม่มี banner แต่ slot อยู่, ไม่มีเป้า → ป้าย「ยังไม่มีเป้าหมาย」, total 100 → cheerful, จอ 360×640 textScaler 1.0 (ผ่าน water → dashboard) และ 1.5 (dashboard ตรง) ไม่มี overflow, `find.text(P1)` เจอ 1

=== จบ logs/20261031-0824_dev_dashboard.md ===

=== logs/20261031-0846_qa_dashboard.md ===
# QA log: dashboard (รอบ 1)

- บทบาท: QA · feature: dashboard · branch feat/dashboard-dev · ไม่ได้ commit / push · ไม่ได้แก้ `app/lib/` · ไม่ได้แก้ `docs/dashboard/` นอกจากสร้าง `test-report.md`
- อ่านแล้ว: docs/dashboard/requirements.md, game-rules.md, ux-flow.md, ui-spec.md · logs/20261031-0824_dev_dashboard.md · โค้ด app/lib/features/dashboard/ (5 ไฟล์) + `git diff HEAD -- app/lib/features/water/` · controller/model ของ water/steps/food · แพทเทิร์นเทสต์ app/test/food/ (food_test_helpers.dart, FakeTimers) · docs/food/test-report.md
- ไฟล์ที่สร้าง: app/test/dashboard/dashboard_test_helpers.dart, dashboard_logic_test.dart, dashboard_controller_test.dart, dashboard_screens_test.dart · docs/dashboard/test-report.md · log นี้
- ไฟล์ชั่วคราว (นอก repo, scratchpad): เทสต์ probe overflow หน้า water + สำเนา `git archive HEAD app` สำหรับเทียบกับ HEAD — ไม่ได้แตะ working tree

## ข้อตัดสิน owner — DECIDED (owner ชั่วคราว, รอทีมยืนยัน)
- **D-1** สัตว์เลี้ยงใช้ PetCharacter: CRYING [0,30] → PetPose.dashboardCrying, DAZED (30,60] → dashboardDazed, BUBBLY (60,80] → dashboardBubbly (= waterHappy), CHEERFUL (80,100] → dashboardCheerful ไม่ใช้ PNG
- **D-2** เวลาเครื่อง ตัดรอบ 05:00 แบบเดียวกับ water/steps/food ไม่มี Server Time
- **D-3** คะแนน: Water, Steps = round(min(actual/target,1)×100); Food: ถึงเป้า = (kcal/target)×100, เกินเป้า = max(0, 100 − (ส่วนที่เกิน/target×100)), ไม่มีเป้า = ไม่คิดคะแนน
- **D-4** Priority 4 "คะแนนอาหารต่ำกว่าเกณฑ์" = foodScore < 50
- **Q-1** Food ไม่มีเป้า → total = round((Steps + Water) / 2), แถบอาหารแสดง「ยังไม่มีเป้าหมาย」
- **Q-14** เป้าน้ำใช้ค่าคงที่ของ water_rules.dart (ไม่มีตรง ๆ = 8 แก้ว)
- **Q-3, Q-16, Q-19, Q-20, Q-21, Q-8** ใช้ตามที่ ui-spec เลือก
- **Q-4 / Q-5 / Q-17** brief ขัดกับ game-rules → ยึด game-rules และ D-3 (P2/P3 ที่ < 100, ตัดออกจากคิวทันที)
- **Q-7** water ยังเป็นหน้าแรก เข้า dashboard ผ่าน `dashboard_entry_button` (ต้องไม่กระทบ signup S-7 และเทสต์เดิม)
- **Q-2** ลบมื้ออาหารไม่อยู่ในขอบเขต · **Q-11** ไม่แสดงจำนวนจริงและป้ายโซเดียม/น้ำตาล · BUBBLY ใช้หน้าเดิม

## ตาราง AC/EC → เทสต์ (ทำก่อนเขียนโค้ดเทสต์ ฉบับเต็มอยู่ใน test-report §2–§4)
AC-1 สูตรเฉลี่ย / cap / integer (L + W) · AC-2 ขอบอารมณ์ 0/30/31/60/61/80/81/100 + pose (L + W) · AC-3 ข้อความตรงตัว 4 ข้อ, trigger/removal ทุก Priority, หมุน 5 s (C + W) · AC-4 องค์ประกอบ/ลำดับ/สี/ป้าย (W) · AC-5 05:00 (C + W) · EC-1 cap (L, W) · EC-2 ตัดออกทันที (L, C, W) · EC-3 04:59:59 → 05:00:00 เปิดค้าง (C, W) · EC-4 ติดลบ/ว่าง/ข้อมูลเสีย (L, C, W) · EC-5 65.66 → 66 (L, W) · game-rules §3 ทุกแถว, §4 ทุกแถว · จอ 360×640 textScaler 1.0 / 1.5 · edge บังคับ 4 แบบ

## ตัวเลขการทำงาน (จากการรันจริง)
- เวลา: เริ่ม 08:26 (`date` ตอนเริ่มอ่านเอกสาร) ถึง 08:46 ≈ 20 นาที
- จำนวนรอบที่รัน `flutter test`: 7 รอบในโปรเจกต์ (+ probe 2 รอบใน scratchpad, + `flutter analyze` 2 รอบ)
  1. 08:35:00 `test/dashboard/` → ล้ม 2 (ผลถูก grep กรองจนเห็นไม่ครบ จึงรันซ้ำ)
  2. ~08:35:40 `test/dashboard/` → `+104 -2` (DECIDED_D4_P4_far_over_target_food_score_below_50_in_queue, UI_card_and_bubble_colors_from_color_scheme)
  - probe 1: scratchpad เทสต์หน้า water 360×640 บน working tree → 1.0: 0 error · 1.5: 1 error (body overflow 68 px)
  - probe 2: เทสต์เดียวกันบนสำเนา HEAD → 1.0: 0 error · 1.5: 2 error (AppBar 79 px + body 68 px)
  3. ~08:37 `test/dashboard/` (หลังแก้เทสต์สี) → `00:15 +105 -1`
  4. 08:39:21–~08:42 `flutter test` ทั้งแอป → `02:37 +708 -1: Some tests failed.`
  5. 08:42:49 `test/dashboard/dashboard_logic_test.dart` → (นับจำนวน) ล้ม 1
  6. ~08:43 `test/dashboard/dashboard_controller_test.dart` → `+18: All tests passed!`
  7. ~08:43 `test/dashboard/dashboard_screens_test.dart` → `00:13 +43: All tests passed!` · 08:44 logic อีกครั้ง → `00:00 +44 -1`
  - `flutter analyze`: 08:34:38 และ 08:39:21 → `No issues found!` ทั้ง 2 รอบ (5.1s / 5.9s)
- เทสต์ dashboard: 106 (L 45 · C 18 · W 43) · ผ่าน 105 · ไม่ผ่าน 1
- ทั้งแอป: 708 ผ่าน / 1 ไม่ผ่าน (เดิม 603 ผ่านครบ + dashboard 106)
- AC 5/5 มีเทสต์ (AC-3 ล้ม 1 เทสต์) · EC 5/5 มีเทสต์ ผ่านครบ · AC/EC ที่ยังไม่มีเทสต์: 0
- Bug ที่เจอ: 1 (BUG-DASH-1 「ฉันหิว」ไม่เข้าคิวเมื่อกินเกินเป้าจน foodScore < 50) · Dev แก้แล้ว: 0 (ยังไม่ส่งกลับ)
- เทสต์ที่ QA แก้เองเพราะเทสต์ผิด: 1 (UI_card_and_bubble_colors_from_color_scheme — สมมติว่า key ฟองอยู่บน Container เอง ซึ่ง ui-spec ไม่ได้บังคับ)
- คำถามค้าง: 11 (test-report §7)
- ข้อสังเกตแยก: หน้า water overflow 68 px แนวตั้งที่ 360×640 textScaler 1.5 — มีมาก่อน (ยืนยันจาก diff + probe บน HEAD) ไม่ใช่บั๊ก dashboard

## หมายเหตุ
- ค่าคาดหวังมาจากเอกสาร/ข้อตัดสินทั้งหมด · ตัวอย่าง game-rules §3 ที่น้ำ 60/67% (ทำไม่ได้ด้วยเป้า 8 แก้ว) assert ตรงตัวที่ระดับ logic และใช้ชุดค่าที่ผลรวมเท่ากันใน widget test
- จุดที่เอกสารไม่ระบุ (ปัด .5, คะแนนปัดถึง 100 ก่อนถึงเป้า, ความหน่วงของ "ทันที", ข้อความอื่นหลุดคิว) ไม่ได้ assert และจดเป็นคำถาม
- เวลาควบคุมทั้งหมด: `clock` ของ 3 controller + `FakeTimers` (C) / `tester.pump(Duration)` (W) — ไม่มี sleep / เวลาจริง / pumpAndSettle บน S-1
- เทสต์ที่ล้ม (BUG-DASH-1) ปล่อย fail ตามคำสั่ง ไม่ได้แก้ค่าคาดหวังตามโค้ด

=== จบ logs/20261031-0846_qa_dashboard.md ===

=== app/pubspec.yaml ===
name: petpal_health
description: "A new Flutter project."
# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.0+1

environment:
  sdk: ^3.13.5

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.5.6
  # signup: hash รหัสผ่านใน FakeAuthRepository (requirements §6 Password Hashed)
  crypto: ^3.0.7
  path_provider: ^2.1.6

dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^6.0.0

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter packages.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # assets/images/ — ภาพประกอบของฟีเจอร์ (เช่น bg_dashboard.png ของ steps ถ้ามี)
  # โฟลเดอร์ต้องมีอยู่จริง (assets/images/.gitkeep) ไม่งั้น build พัง
  # DECIDED (owner 2026-10-14): สัตว์เลี้ยงทั้งแอปคือ PetCharacter (lib/shared/pet/)
  # PNG สัตว์เลี้ยงเดิมย้ายไป assets/images/legacy/ และตั้งใจ "ไม่" ลงทะเบียนโฟลเดอร์นั้น
  # (รายการแบบโฟลเดอร์ของ Flutter ไม่รวมโฟลเดอร์ย่อย) จึงไม่ถูก bundle เข้าแอป
  assets:
    - assets/images/

  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/to/resolution-aware-images

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/to/asset-from-package

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/to/font-from-package

=== จบ app/pubspec.yaml ===

=== app/lib/features/dashboard/dashboard_controller.dart ===
/// ตัวกลางระหว่าง logic ของ dashboard กับ UI
///
/// ไม่มี repository / ไม่เก็บข้อมูลเอง — อ่านค่าจาก WaterController / StepsController /
/// FoodController ตัวเดียวกับที่หน้า water ใช้ (D-2) แล้วคำนวณ snapshot สดทุกครั้ง
/// controller นี้ถือเฉพาะสถานะการแสดงผลของ Dynamic Alert Banner (ข้อความที่แสดง + Timer 5 วินาที)
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../food/food_controller.dart';
import '../steps/steps_controller.dart';
import '../water/water_controller.dart';
import 'dashboard_logic.dart';
import 'dashboard_models.dart';
import 'dashboard_rules.dart';

/// สร้าง Timer — inject ตัวปลอมในเทสต์ที่ไม่ใช่ widget test เพื่อสั่งให้หมดเวลาเองได้
/// (แบบ FoodTimerFactory)
typedef DashboardTimerFactory = Timer Function(
  Duration duration,
  void Function() callback,
);

Timer _defaultTimer(Duration d, void Function() cb) => Timer(d, cb);

class DashboardController extends ChangeNotifier {
  DashboardController({
    required this.water,
    required this.steps,
    required this.food,
    DashboardTimerFactory? timerFactory,
  }) : _timer = timerFactory ?? _defaultTimer {
    for (final c in _sources) {
      c.addListener(_onSourceChanged);
    }
    _queue = snapshot.alerts;
    _daySignature = _currentDaySignature();
    _setCurrent(DashboardLogic.nextAlert(_queue, null));
  }

  final WaterController water;
  final StepsController steps;
  final FoodController food;
  final DashboardTimerFactory _timer;

  List<ChangeNotifier> get _sources => [water, steps, food];

  List<DashboardAlert> _queue = const [];
  DashboardAlert? _current;
  Timer? _alertTimer;
  Object? _daySignature;
  bool _disposed = false;

  // ---------------------------------------------------------------------------
  // ค่าสำหรับ UI
  // ---------------------------------------------------------------------------

  /// ทั้ง 3 controller โหลดจากเครื่องเสร็จแล้ว
  bool get isLoaded => water.isLoaded && steps.isLoaded && food.isLoaded;

  /// ค่าดิบจาก controller เดิม ณ ตอนนี้
  DashboardInput get input => DashboardInput(
        cups: water.cups,
        steps: steps.steps,
        stepsGoal: steps.activeGoal,
        totalCalories: food.totalCalories,
        targetCalories: food.targetCalories,
        isFoodOverLimit: food.isOverLimit,
        hasMealsToday: food.state.meals.isNotEmpty,
      );

  /// คะแนน / อารมณ์ / คิว — คำนวณสดจาก controller เดิม (ไม่ cache ข้อมูลซ้ำ)
  DashboardSnapshot get snapshot => DashboardLogic.snapshot(input);

  /// ข้อความที่แสดงในฟองตอนนี้ (null = คิวว่าง → ซ่อนฟอง)
  DashboardAlert? get currentAlert => _current;

  // ---------------------------------------------------------------------------
  // โหลด / รอบวัน (AC-5, EC-3 — ใช้รอบ 05:00 ของ controller เดิม, D-2)
  // ---------------------------------------------------------------------------

  /// เรียกตอนเปิดหน้า: โหลด controller ที่ยังไม่โหลด / ตรวจรอบวันของตัวที่โหลดแล้ว
  Future<void> start() async {
    await Future.wait([
      water.isLoaded ? water.refreshDailyReset() : water.load(),
      steps.isLoaded ? steps.refreshDay() : steps.load(),
      // แบบ FoodDashboardScreen: เข้าหน้าแล้วอ่านโปรไฟล์ใหม่ (เป้า kcal อาจเปลี่ยนจาก signup)
      food.isLoaded ? _refreshFood() : food.load(),
    ]);
  }

  Future<void> _refreshFood() async {
    await food.refreshDay();
    await food.refreshProfile();
  }

  /// ตรวจข้าม 05:00 ของทั้ง 3 controller — เรียกเป็นระยะขณะเปิดหน้าค้าง และตอนแอป resume
  Future<void> refreshDay() async {
    await Future.wait([
      water.refreshDailyReset(),
      steps.refreshDay(),
      food.refreshDay(),
    ]);
  }

  // ---------------------------------------------------------------------------
  // Dynamic Alert Banner (AC-3, EC-2)
  // ---------------------------------------------------------------------------

  /// รอบวันตามที่ controller เดิมเก็บไว้ (steps / food มี `state.day` จาก logicalDay 05:00)
  Object _currentDaySignature() =>
      Object.hash(steps.state.day, food.state.day);

  void _onSourceChanged() {
    if (_disposed) return;
    final previous = _queue;
    _queue = snapshot.alerts;
    final signature = _currentDaySignature();
    final dayChanged = signature != _daySignature;
    _daySignature = signature;
    final next = DashboardLogic.resolveAlert(
      previousQueue: previous,
      queue: _queue,
      current: _current,
      dayChanged: dayChanged,
    );
    if (next != _current || dayChanged) {
      _setCurrent(next);
    } else if (_current != null && _alertTimer == null) {
      _restartTimer();
    }
    notifyListeners();
  }

  /// เปลี่ยนข้อความที่แสดง แล้วเริ่มนับ alertInterval ใหม่ (Q-19)
  void _setCurrent(DashboardAlert? alert) {
    _current = alert;
    _alertTimer?.cancel();
    _alertTimer = null;
    if (alert != null) _restartTimer();
  }

  void _restartTimer() {
    _alertTimer?.cancel();
    _alertTimer = _timer(
      const Duration(seconds: DashboardRules.alertIntervalSeconds),
      _onAlertTick,
    );
  }

  void _onAlertTick() {
    _alertTimer = null;
    if (_disposed) return;
    _setCurrent(DashboardLogic.nextAlert(_queue, _current));
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _alertTimer?.cancel();
    _alertTimer = null;
    for (final c in _sources) {
      c.removeListener(_onSourceChanged);
    }
    super.dispose();
  }
}

=== จบ app/lib/features/dashboard/dashboard_controller.dart ===

=== app/lib/features/dashboard/dashboard_logic.dart ===
/// Logic เกมของฟีเจอร์ dashboard — pure Dart ไม่ขึ้นกับ widget
///
/// สูตรคะแนน / เกณฑ์อยู่ใน DashboardRules — ไฟล์นี้ประกอบผล (snapshot), สร้างคิวข้อความ
/// และเลือกข้อความที่แสดงในการหมุนเวียน
library;

import '../../shared/pet/pet_pose.dart' show PetPose;
import 'dashboard_models.dart';
import 'dashboard_rules.dart';

class DashboardLogic {
  DashboardLogic._();

  // ---------------------------------------------------------------------------
  // คะแนน + อารมณ์ (AC-1, AC-2, EC-1, EC-4, EC-5)
  // ---------------------------------------------------------------------------

  static DashboardSnapshot snapshot(DashboardInput input) {
    final water = DashboardRules.waterScore(input.cups);
    final steps = DashboardRules.stepsScore(input.steps, input.stepsGoal);
    final food = DashboardRules.foodScore(
      input.totalCalories,
      input.targetCalories,
    );
    final total = DashboardRules.totalScore(
      waterScore: water,
      stepsScore: steps,
      foodScore: food,
    );
    // Q-2: ไม่มีเป้า → isOverLimit เป็น false อยู่แล้ว (FoodLogic.isOverLimit)
    final overLimit = input.isFoodOverLimit && input.targetCalories != null;
    return DashboardSnapshot(
      waterScore: water,
      stepsScore: steps,
      foodScore: food,
      totalScore: total,
      mood: moodFor(total),
      isFoodOverLimit: overLimit,
      alerts: alertQueue(
        waterScore: water,
        stepsScore: steps,
        foodScore: food,
        isFoodOverLimit: overLimit,
        hasMealsToday: input.hasMealsToday,
        isFoodOverTarget: input.targetCalories != null &&
            input.totalCalories > input.targetCalories!,
      ),
    );
  }

  /// CRYING [0,30] · DAZED (30,60] · BUBBLY (60,80] · CHEERFUL (80,100] — จาก totalScore หลังปัด
  static DashboardPetMood moodFor(int totalScore) {
    if (totalScore <= DashboardRules.cryingMaxScore) {
      return DashboardPetMood.crying;
    }
    if (totalScore <= DashboardRules.dazedMaxScore) {
      return DashboardPetMood.dazed;
    }
    if (totalScore <= DashboardRules.bubblyMaxScore) {
      return DashboardPetMood.bubbly;
    }
    return DashboardPetMood.cheerful;
  }

  /// อารมณ์ → ท่าของ shared pet (D-1, ui-spec §4)
  // DECIDED (owner ชั่วคราว, รอบ 2): BUBBLY ใช้หน้าเดิม (dashboardBubbly == waterHappy)
  static PetPose poseFor(DashboardPetMood mood) => switch (mood) {
        DashboardPetMood.crying => PetPose.dashboardCrying,
        DashboardPetMood.dazed => PetPose.dashboardDazed,
        DashboardPetMood.bubbly => PetPose.dashboardBubbly,
        DashboardPetMood.cheerful => PetPose.dashboardCheerful,
      };

  // ---------------------------------------------------------------------------
  // Dynamic Alert Queue (AC-3, EC-2, game-rules §1.1)
  // ---------------------------------------------------------------------------

  /// คิวข้อความที่ trigger อยู่ เรียง Priority 1 → 4 — ประเมินสดจากค่าปัจจุบันทุกครั้ง
  /// ("คัดออกทันทีเมื่อแก้ปัญหาสำเร็จ" = เงื่อนไขไม่เป็นจริงแล้วจึงไม่อยู่ในคิว)
  static List<DashboardAlert> alertQueue({
    required int waterScore,
    required int stepsScore,
    required int? foodScore,
    required bool isFoodOverLimit,
    required bool hasMealsToday,
    required bool isFoodOverTarget,
  }) {
    return List.unmodifiable([
      // P1: เกินเป้า > 100 kcal (FoodController.isOverLimit) — ค้างจนตัดรอบ 05:00 (Q-2)
      if (isFoodOverLimit) DashboardAlert.overeating,
      if (waterScore < DashboardRules.waterAlertBelowScore)
        DashboardAlert.drinkWater,
      if (stepsScore < DashboardRules.stepsAlertBelowScore)
        DashboardAlert.moveBody,
      if (isHungry(
        foodScore: foodScore,
        hasMealsToday: hasMealsToday,
        isFoodOverTarget: isFoodOverTarget,
      ))
        DashboardAlert.hungry,
    ]);
  }

  /// P4 「ฉันหิว」: ยังไม่บันทึกมื้อใดวันนี้ หรือ foodScore < 50 (D-4)
  // ASSUMPTION: ui-spec Q-3 — ประเมิน trigger แบบสด: บันทึกแล้วแต่ foodScore ยัง < 50 ข้อความยังอยู่
  // · ไม่มีเป้า (foodScore null) → ใช้เฉพาะ "ยังไม่บันทึกมื้อใด"
  // ASSUMPTION: ส่วน "foodScore < 50" นับเฉพาะตอนกินยังไม่ถึงเป้า (kcal ≤ target) — กินเกินเป้า
  // มากจน foodScore < 50 ไม่ขึ้น「ฉันหิว」 (ขัดกับ P1「อิ่มและอืดเกินไป」)
  // DECIDED (owner รอบ 3, BUG-DASH-1 / QD-2): ยึดทางนี้ — กินเกินเป้าไม่ขึ้น「ฉันหิว」
  static bool isHungry({
    required int? foodScore,
    required bool hasMealsToday,
    required bool isFoodOverTarget,
  }) {
    if (!hasMealsToday) return true;
    if (foodScore == null || isFoodOverTarget) return false;
    return foodScore < DashboardRules.foodHungryBelowScore;
  }

  /// เลือกข้อความที่ควรแสดงหลังคิวเปลี่ยน (ไม่ใช่ตอนครบ 5 วินาที)
  /// - คิวว่าง → null (ซ่อนฟอง — Q-10)
  /// - ยังไม่มีข้อความ / ข้ามรอบวัน → ข้อความ Priority สูงสุด (Q-19, ui-spec §3 ข้ามช่วงเวลา)
  /// - ข้อความที่แสดงอยู่หลุดจากคิว → ข้อความลำดับถัดไปทันที (EC-2, game-rules §4) วนกลับต้นคิว
  /// - มีข้อความใหม่เข้าคิว → ข้อความ Priority สูงสุด (Q-19)
  /// - อื่น ๆ → คงข้อความเดิม
  // ASSUMPTION: ui-spec Q-19 ค่าชั่วคราว — รอ game-rules ยืนยัน
  static DashboardAlert? resolveAlert({
    required List<DashboardAlert> previousQueue,
    required List<DashboardAlert> queue,
    required DashboardAlert? current,
    bool dayChanged = false,
  }) {
    if (queue.isEmpty) return null;
    if (current == null || dayChanged) return queue.first;
    if (!queue.contains(current)) return _after(queue, current.priority);
    final added = queue.any((a) => !previousQueue.contains(a));
    if (added) return queue.first;
    return current;
  }

  /// ข้อความถัดไปเมื่อครบ alertInterval (วนลูปตามลำดับ Priority)
  static DashboardAlert? nextAlert(
    List<DashboardAlert> queue,
    DashboardAlert? current,
  ) {
    if (queue.isEmpty) return null;
    if (current == null) return queue.first;
    return _after(queue, current.priority);
  }

  /// ข้อความแรกในคิวที่ Priority ต่ำกว่า (เลขมากกว่า) [priority] — ไม่มี → วนกลับต้นคิว
  static DashboardAlert _after(List<DashboardAlert> queue, int priority) {
    for (final a in queue) {
      if (a.priority > priority) return a;
    }
    return queue.first;
  }
}

=== จบ app/lib/features/dashboard/dashboard_logic.dart ===

=== app/lib/features/dashboard/dashboard_models.dart ===
/// โมเดลของฟีเจอร์ dashboard — ไม่มีข้อมูลที่เก็บลงเครื่อง (ค่าทั้งหมดอ่านจาก controller เดิม)
library;

import 'dashboard_rules.dart';

/// อารมณ์สัตว์เลี้ยงตาม totalScore (game-rules.md §2)
enum DashboardPetMood {
  crying,
  dazed,
  bubbly,
  cheerful;

  /// ใช้ใน key `dashboard_pet_image_<keyName>`
  String get keyName => name;

  /// ชื่อไทย (game-rules §2) — semanticLabel ของสัตว์เลี้ยง
  String get label => switch (this) {
        DashboardPetMood.crying => DashboardRules.moodCryingLabel,
        DashboardPetMood.dazed => DashboardRules.moodDazedLabel,
        DashboardPetMood.bubbly => DashboardRules.moodBubblyLabel,
        DashboardPetMood.cheerful => DashboardRules.moodCheerfulLabel,
      };
}

/// ข้อความใน Dynamic Alert Queue (game-rules.md §1.1) — เรียงตาม Priority 1 → 4
enum DashboardAlert {
  overeating(1, DashboardRules.alertOvereatingText),
  drinkWater(2, DashboardRules.alertDrinkWaterText),
  moveBody(3, DashboardRules.alertMoveBodyText),
  hungry(4, DashboardRules.alertHungryText);

  const DashboardAlert(this.priority, this.text);

  /// 1 = สำคัญสูงสุด
  final int priority;

  /// ข้อความบนจอ (ตรงตัว)
  final String text;
}

/// ค่าดิบที่ dashboard อ่านจาก controller เดิม ณ ขณะหนึ่ง (ไม่คำนวณ/เก็บซ้ำ)
class DashboardInput {
  const DashboardInput({
    required this.cups,
    required this.steps,
    required this.stepsGoal,
    required this.totalCalories,
    required this.targetCalories,
    required this.isFoodOverLimit,
    required this.hasMealsToday,
  });

  /// WaterController.cups
  final int cups;

  /// StepsController.steps
  final int steps;

  /// StepsController.activeGoal
  final int stepsGoal;

  /// FoodController.totalCalories
  final int totalCalories;

  /// FoodController.targetCalories (null = ไม่มีเป้า / ข้ามโปรไฟล์)
  final int? targetCalories;

  /// FoodController.isOverLimit (Priority 1 / หลอดแดง)
  final bool isFoodOverLimit;

  /// FoodController.state.meals ไม่ว่าง
  final bool hasMealsToday;
}

/// ผลคำนวณของ dashboard ณ ขณะหนึ่ง
class DashboardSnapshot {
  const DashboardSnapshot({
    required this.waterScore,
    required this.stepsScore,
    required this.foodScore,
    required this.totalScore,
    required this.mood,
    required this.isFoodOverLimit,
    required this.alerts,
  });

  final int waterScore;
  final int stepsScore;

  /// null = ไม่คิดคะแนน (ไม่มีเป้าอาหาร — D-3)
  final int? foodScore;
  final int totalScore;
  final DashboardPetMood mood;

  /// แถบอาหารสีแดง (Priority 1)
  final bool isFoodOverLimit;

  /// คิวข้อความที่ trigger อยู่ เรียง Priority 1 → 4
  final List<DashboardAlert> alerts;

  bool get hasFoodScore => foodScore != null;
}

=== จบ app/lib/features/dashboard/dashboard_models.dart ===

=== app/lib/features/dashboard/dashboard_rules.dart ===
/// ค่าคงที่กติกาเกม + สูตรคะแนนของฟีเจอร์ dashboard (คะแนนสุขภาพรวมและอารมณ์สัตว์เลี้ยง)
///
/// ตัวเลขกติกามาจาก docs/dashboard/game-rules.md §1, §1.1, §2 และ requirements.md AC-1..AC-5
/// สูตรคะแนนรายหมวดมาจากข้อตัดสิน owner D-3 / D-4 / Q-1 (docs/dashboard/ui-spec.md §0, §6)
/// ขนาด/ระยะหน้าจอมาจาก ui-spec.md §1.3 · ข้อความบนจอมาจาก ux-flow.md §2 / game-rules.md §1.1
/// (ตรงตัว) และ ui-spec ("เสนอ — รอยืนยัน")
///
/// dashboard ไม่มีข้อมูล/รอบวันของตัวเอง — อ่านค่าจาก WaterController / StepsController /
/// FoodController เท่านั้น (D-2) ไฟล์นี้จึงมีแค่สูตรแปลงค่าเหล่านั้นเป็นคะแนน 0–100
library;

import 'dart:math' as math;

import '../water/water_rules.dart';

class DashboardRules {
  DashboardRules._();

  // ---------------------------------------------------------------------------
  // game-rules.md §1 ค่าหลัก — ช่วงคะแนน
  // ---------------------------------------------------------------------------

  /// คะแนนต่ำสุดของทุกหมวด / คะแนนรวม (EC-4: ติดลบหรือ Null → 0)
  static const int minScore = 0;

  /// คะแนนสูงสุดของทุกหมวด / คะแนนรวม (AC-1, EC-1: Cap 100%)
  static const int maxScore = 100;

  /// alertInterval — หมุนข้อความแจ้งเตือนทุก 5 วินาที (US-3, AC-3)
  static const int alertIntervalSeconds = 5;

  /// resetHour — ไม่มีรอบวันของ dashboard เอง: ใช้ 05:00 ของ water / steps / food (D-2)
  /// ค่านี้อ้างอิงค่าเดียวกับ WaterRules (ไม่ตั้งเลขใหม่) เพื่อเอกสารเท่านั้น
  static const int resetHour = WaterRules.dailyResetHour;

  // ---------------------------------------------------------------------------
  // game-rules.md §2 อารมณ์สัตว์เลี้ยง — ขอบบน "รวม" ของแต่ละช่วง (คิดจาก totalScore หลังปัด)
  // CRYING [0, 30] · DAZED (30, 60] · BUBBLY (60, 80] · CHEERFUL (80, 100]  (AC-2, Q-13)
  // ---------------------------------------------------------------------------
  static const int cryingMaxScore = 30;
  static const int dazedMaxScore = 60;
  static const int bubblyMaxScore = 80;

  // ---------------------------------------------------------------------------
  // game-rules.md §1.1 Dynamic Alert Queue — เกณฑ์ trigger
  // ---------------------------------------------------------------------------

  /// Priority 1: "Overeating > 100 kcal / หลอดอาหารแสดงสีแดง" — ใช้ FoodController.isOverLimit
  /// ตัวเดียวกับหลอดแดงของ food (เกณฑ์ 100 kcal อยู่ที่ FoodRules.overLimitThreshold —
  /// ไม่ตั้งเลขซ้ำที่นี่)

  /// Priority 2 / 3: อยู่ในคิวเมื่อคะแนน "ต่ำกว่า" ค่านี้ (`waterScore < 100%`, `stepsScore < 100%`)
  // DECIDED (owner ชั่วคราว รอบ 2, Q-4): ยึด game-rules (< 100) ไม่ใช่ brief (< 80)
  static const int waterAlertBelowScore = 100;
  static const int stepsAlertBelowScore = 100;

  /// Priority 4: "คะแนนอาหารต่ำกว่าเกณฑ์" = foodScore < 50
  // ASSUMPTION: DECIDED (owner ชั่วคราว, รอทีมยืนยัน) D-4 — เกณฑ์ 50
  static const int foodHungryBelowScore = 50;

  // ---------------------------------------------------------------------------
  // Q-14 เป้าน้ำ (แก้ว)
  // ---------------------------------------------------------------------------

  /// เป้าน้ำประจำวัน (แก้ว) สำหรับสูตร D-3 `actual / target`
  // ASSUMPTION: DECIDED (owner ชั่วคราว รอบ 2, Q-14) — water ไม่มีค่าคงที่ "เป้าแก้ว" ตรง ๆ
  // จึง derive จากค่าคงที่ของ water: energyMaxDisplayPercentage / energyIncrementPercentage
  // = 100 / 12.5 = 8 แก้ว (ไม่พิมพ์เลข 8 เอง)
  // DECIDED (owner รอบ 3, QD-1): ใช้ 8 แก้วจากค่าคงที่ของ water ต่อ
  // หมายเหตุ: สัตว์เลี้ยงของ water ร่าเริงตั้งแต่ 7 แก้ว แต่ที่ 7 แก้ว waterScore = 87 (floor)
  static int get waterTargetCups => (WaterRules.energyMaxDisplayPercentage /
          WaterRules.energyIncrementPercentage)
      .round();

  // ---------------------------------------------------------------------------
  // สูตรคะแนน (D-3, Q-1, EC-4) — pure ฟังก์ชัน
  //
  // DECIDED (owner รอบ 3, 2026-10-31): ปัดคะแนน "ลง" (floor) ทุกตัว — แทน round ของ D-3 / Q-1 /
  // ui-spec Q-16 · Water / Steps / Food / total ได้ 100 ก็ต่อเมื่อถึงเป้าจริงเท่านั้น
  // (เช่น 7,999 / 8,000 ก้าว = 99) · ใช้เลขจำนวนเต็ม (`~/`) ทั้งหมด ไม่มีเศษ floating point
  // ผลต่อตัวอย่าง game-rules §3: (70, 60, 67) → 197 / 3 = 65.66 → **65** (เอกสาร/EC-5 เขียน 66)
  // ---------------------------------------------------------------------------

  /// EC-4: ค่าติดลบ / Null → 0 และไม่เกิน 100 (ค่าทศนิยมปัดลง — owner รอบ 3)
  static int clampScore(num? value) {
    if (value == null || value.isNaN || value < minScore) return minScore;
    if (value > maxScore) return maxScore;
    return value.floor();
  }

  /// Water / Steps = `floor(min(actual / target, 1) × 100)`
  // ASSUMPTION: DECIDED (owner ชั่วคราว) D-3 + รอบ 3 (floor แทน round)
  // คำนวณ `actual × 100 ~/ target` (จำนวนเต็ม) · target ≤ 0 → 0 (กันหารศูนย์) · actual ≤ 0 → 0 (EC-4)
  static int ratioScore(int actual, int target) {
    if (target <= 0 || actual <= 0) return minScore;
    return clampScore(actual * 100 ~/ target);
  }

  /// waterScore จากจำนวนแก้วของรอบวันปัจจุบัน (WaterController.cups)
  static int waterScore(int cups) => ratioScore(cups, waterTargetCups);

  /// stepsScore จากก้าวและเป้าที่ใช้อยู่ (StepsController.steps / activeGoal)
  static int stepsScore(int steps, int activeGoal) =>
      ratioScore(steps, activeGoal);

  /// foodScore จาก kcal รวมวันนี้และเป้า (FoodController.totalCalories / targetCalories)
  /// - ไม่มีเป้า (ข้ามโปรไฟล์) → null = "ไม่คิดคะแนน"
  /// - ถึงเป้า (kcal ≤ target) → `floor((kcal / target) × 100)` (= 100 เฉพาะ kcal == target)
  /// - เกินเป้า → `floor(max(0, 100 − (ส่วนที่เกิน / target × 100)))` (เกิน 1 kcal ก็ < 100)
  // ASSUMPTION: DECIDED (owner ชั่วคราว) D-3 + รอบ 3 (floor แทน round)
  // ASSUMPTION: target ≤ 0 (ไม่ควรเกิดจาก FoodLogic) ถือเป็น "ไม่มีเป้า" กันหารศูนย์
  static int? foodScore(int totalCalories, int? targetCalories) {
    if (targetCalories == null || targetCalories <= 0) return null;
    final kcal = math.max(0, totalCalories); // EC-4
    if (kcal <= targetCalories) {
      return clampScore(kcal * 100 ~/ targetCalories);
    }
    // floor(100 − x) = 100 − ceil(x) โดย x = ส่วนที่เกิน × 100 / target
    final overScaled = (kcal - targetCalories) * 100;
    final overCeil = (overScaled + targetCalories - 1) ~/ targetCalories;
    return clampScore(maxScore - overCeil);
  }

  /// totalScore = `floor((Food + Steps + Water) / 3)` cap 100 (AC-1, EC-1)
  /// Food ไม่คิดคะแนน (null) → `floor((Steps + Water) / 2)`
  // ASSUMPTION: DECIDED (owner ชั่วคราว รอบ 2, Q-1) — ไม่มีเป้าอาหาร หาร 2
  // DECIDED (owner รอบ 3): floor แทน round — EC-5 (65.66 → 66) เปลี่ยนเป็น 65
  static int totalScore({
    required int waterScore,
    required int stepsScore,
    required int? foodScore,
  }) {
    final w = clampScore(waterScore);
    final s = clampScore(stepsScore);
    if (foodScore == null) return clampScore((s + w) ~/ 2);
    return clampScore((clampScore(foodScore) + s + w) ~/ 3);
  }

  // ---------------------------------------------------------------------------
  // ui-spec §1.3 ขนาด / ระยะ / เวลา (ไม่ใช่กติกาเกม — ค่าหน้าตา)
  // ---------------------------------------------------------------------------

  /// ขนาดสัตว์เลี้ยง 200 × 200 (ui-spec §1.3, Q-9 — แทน fallback 300×300 ของ PNG ตาม D-1)
  static const double petSize = 200;

  /// ระยะขอบล่างช่องข้อความ ↔ ขอบบนกล่องสัตว์เลี้ยง (ui-spec §1.3, §2.1.1)
  static const double alertAnchorOffset = 12;

  /// ความสูงแถบรายหมวด (ui-spec §1.3)
  static const double barMinHeight = 12;

  /// ความถี่ตรวจรอบวันขณะเปิดหน้าค้าง (ui-spec §3 "ข้ามช่วงเวลา")
  // ASSUMPTION: เอกสารไม่กำหนดความถี่ — 1 วินาทีแบบ _dayCheckInterval ของ steps / food
  static const int dayCheckIntervalSeconds = 1;

  // ---------------------------------------------------------------------------
  // ข้อความบนหน้าจอ
  // ---------------------------------------------------------------------------

  // ASSUMPTION: ui-spec Q-8 (เสนอ — รอยืนยัน) — หัวข้อ AppBar และ tooltip ปุ่มทางเข้า
  static const String screenTitle = 'แดชบอร์ด';
  static const String entryTooltip = 'แดชบอร์ด';

  /// game-rules §1.1 — ตรงตัว ไม่รวม `"` ตัวคั่น
  // ASSUMPTION: ui-spec Q-21 — `"` ในเอกสารเป็นตัวคั่น string ไม่ใช่ส่วนของข้อความบนจอ
  static const String alertOvereatingText =
      'แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว';
  static const String alertDrinkWaterText = 'ดื่มน้ำๆ';
  static const String alertMoveBodyText = 'ขยับร่างกายหน่อย อีกนิดๆ';
  static const String alertHungryText = 'ฉันหิว';

  /// ชื่อไทยของอารมณ์ (game-rules §2) — ใช้เป็น semanticLabel ไม่แสดงบนจอ (ui-spec §2.1 #5)
  static const String moodCryingLabel = 'ร้องไห้';
  static const String moodDazedLabel = 'เหม่อลอย';
  static const String moodBubblyLabel = 'ออรุ่มเจ๊าะ';
  static const String moodCheerfulLabel = 'ยิ้มร่าเริง';

  /// ux-flow §2 `คะแนนสุขภาพรวม: [Integer]%`
  static String totalScoreText(int score) => 'คะแนนสุขภาพรวม: $score%';

  /// ux-flow §2 `คะแนนอาหาร: [Integer]%`
  static String foodScoreText(int score) => 'คะแนนอาหาร: $score%';

  /// ux-flow §2 `คะแนนการก้าวเดิน: [Integer]%`
  static String stepsScoreText(int score) => 'คะแนนการก้าวเดิน: $score%';

  /// ux-flow §2 `คะแนนการดื่มน้ำ: [Integer]%`
  static String waterScoreText(int score) => 'คะแนนการดื่มน้ำ: $score%';

  /// ป้ายแถบอาหารเมื่อไม่มีเป้า (ไม่คิดคะแนน — D-3)
  // ASSUMPTION: ui-spec Q-1 (เสนอ — รอยืนยัน)
  static const String foodNoTargetText = 'คะแนนอาหาร: ยังไม่มีเป้าหมาย';
}

=== จบ app/lib/features/dashboard/dashboard_rules.dart ===

=== app/lib/features/dashboard/screens/dashboard_screen.dart ===
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:petpal_health/shared/pet/pet.dart';

import '../../food/food_controller.dart';
import '../../food/screens/food_profile_screen.dart';
import '../../food/widgets/food_profile_cta_banner.dart';
import '../../food/widgets/food_shared_min_height_box.dart';
import '../../steps/steps_controller.dart';
import '../../water/water_controller.dart';
import '../dashboard_controller.dart';
import '../dashboard_logic.dart';
import '../dashboard_models.dart';
import '../dashboard_rules.dart';

/// S-1 หน้าจอแดชบอร์ดหลัก — ux-flow §2 S-1, ui-spec §2.1
/// AC-1, AC-2, AC-3, AC-4, AC-5, EC-1..EC-5
///
/// รับ controller ตัวเดียวกับที่หน้า water ใช้ (ui-spec §2.0) — หน้าจอไม่เก็บ/คำนวณข้อมูลเอง
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.waterController,
    required this.stepsController,
    required this.foodController,
    this.animatePet,
    this.timerFactory,
  });

  final WaterController waterController;
  final StepsController stepsController;
  final FoodController foodController;

  /// `PetCharacter.animate` — null = [kPetAnimateByDefault] (แอปจริง animate,
  /// ระหว่าง flutter test เป็นภาพนิ่ง)
  final bool? animatePet;

  /// Timer หมุนข้อความ (alertInterval) — null = `Timer` จริง (widget test ใช้ `pump(Duration)`)
  final DashboardTimerFactory? timerFactory;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  // PetCharacter มีตัวตนคงที่ข้ามการเปลี่ยนอารมณ์ (BUG-PET-1) — key ฟีเจอร์อยู่บน KeyedSubtree
  final GlobalKey _petKey = GlobalKey(debugLabel: 'dashboard_pet');

  late final DashboardController _controller;
  Timer? _dayTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = DashboardController(
      water: widget.waterController,
      steps: widget.stepsController,
      food: widget.foodController,
      timerFactory: widget.timerFactory,
    );
    _controller.start();
    // ui-spec §3 ข้ามช่วงเวลา: ตรวจรอบวัน 05:00 ของทั้ง 3 controller ขณะเปิดหน้าค้าง (EC-3)
    _dayTimer = Timer.periodic(
      const Duration(seconds: DashboardRules.dayCheckIntervalSeconds),
      (_) => _controller.refreshDay(),
    );
  }

  @override
  void dispose() {
    _dayTimer?.cancel();
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// CTA → S-3 ตั้งโปรไฟล์ของ food (FoodController ตัวเดียวกัน — บันทึกแล้วคะแนนอาหารขึ้นทันที)
  void _openFoodProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FoodProfileScreen(controller: widget.foodController),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _controller.refreshDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          DashboardRules.screenTitle,
          key: Key('dashboard_header_text'),
        ),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (!_controller.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildContent(context);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final s = _controller.snapshot;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // #1 Total Score Card (AC-1, EC-1, EC-5)
                    Container(
                      key: const Key('dashboard_total_score_card'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        DashboardRules.totalScoreText(s.totalScore),
                        key: const Key('dashboard_total_score_text'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // #3 Dynamic Alert Banner (AC-3, EC-2)
                    _buildAlertSlot(context, _controller.currentAlert),
                    // #4 ระยะ anchor
                    const SizedBox(height: DashboardRules.alertAnchorOffset),
                    // #5 Pet Character Display (AC-2) — D-1: PetCharacter ไม่ใช่ PNG
                    // ไม่ส่ง cheerTrigger (Q-20) — CHEERFUL กระโดดวนเองจาก preset
                    Center(
                      child: KeyedSubtree(
                        key: ValueKey('dashboard_pet_image_${s.mood.keyName}'),
                        child: PetCharacter(
                          key: _petKey,
                          pose: DashboardLogic.poseFor(s.mood),
                          size: DashboardRules.petSize,
                          animate: widget.animatePet ?? kPetAnimateByDefault,
                          semanticLabel: s.mood.label,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // #7 Food Progress Bar (AC-4) — แดงเมื่อ Priority 1
                    _buildBarRow(
                      context,
                      name: 'food',
                      label: s.foodScore == null
                          ? DashboardRules.foodNoTargetText
                          : DashboardRules.foodScoreText(s.foodScore!),
                      labelColor:
                          s.foodScore == null ? scheme.onSurfaceVariant : null,
                      score: s.foodScore ?? DashboardRules.minScore,
                      color: s.isFoodOverLimit ? scheme.error : scheme.primary,
                    ),
                    // DECIDED (owner รอบ 3 ข้อ 5): ไม่มีเป้าอาหาร → ใช้ CTA Banner เดิมของ food
                    // (FoodProfileCtaBanner — keys `food_profile_cta_banner` ฯลฯ) พาไป S-3
                    // ASSUMPTION: วางใต้แถบอาหาร ห่าง 8 (ระยะในแถวเดียวกัน ui-spec §2.1.2) และคงป้าย
                    // 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 + แถบ 0 ไว้ตาม ui-spec §3 (Q-1) — ui-spec ไม่มีตำแหน่ง CTA
                    if (!s.hasFoodScore) ...[
                      const SizedBox(height: 8),
                      FoodProfileCtaBanner(
                        totalText: widget.foodController.ctaTotalText,
                        onTap: _openFoodProfile,
                      ),
                    ],
                    const SizedBox(height: 16),
                    // #9 Steps Progress Bar (AC-4)
                    _buildBarRow(
                      context,
                      name: 'steps',
                      label: DashboardRules.stepsScoreText(s.stepsScore),
                      score: s.stepsScore,
                      color: scheme.primary,
                    ),
                    const SizedBox(height: 16),
                    // #11 Water Progress Bar (AC-4)
                    _buildBarRow(
                      context,
                      name: 'water',
                      label: DashboardRules.waterScoreText(s.waterScore),
                      score: s.waterScore,
                      color: scheme.primary,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ui-spec §2.1.1 — ช่องจองที่สูงเท่าฟองข้อความ Priority 1 (ยาวสุด) ที่ความกว้าง/textScaler จริง
  /// ไม่ล็อกความสูงคงที่ (บทเรียน food BUG-FOOD-1/2) · คิวว่าง = ไม่มีฟองแต่ยังจองที่ (Q-10)
  // ASSUMPTION: ui-spec เสนอ Stack + Visibility(maintainSize) ที่มีข้อความ Priority 1 ซ่อนอยู่ แต่
  // วิธีนั้นทำให้ข้อความ P1 อยู่ใน widget tree เสมอ (find.text เจอ 2 ตัวตอน P1 แสดง / เจอแม้คิวว่าง)
  // จึงวัดความสูงฟอง P1 ด้วย TextPainter แล้วใช้เป็น "ความสูงขั้นต่ำ" ผ่าน FoodSharedMinHeightBox
  // (ของเดิมของ food — รองรับ IntrinsicHeight) ผลบนจอเท่ากัน: ช่องสูงเท่าฟอง P1 เสมอ และโตได้ถ้าจำเป็น
  Widget _buildAlertSlot(BuildContext context, DashboardAlert? alert) {
    return FoodSharedMinHeightBox(
      key: const Key('dashboard_alert_slot'),
      minHeightFor: _alertSlotMinHeightFor(context),
      child: alert == null
          ? const SizedBox.shrink()
          : Center(
              child: SizedBox(
                width: double.infinity,
                child: _AlertBubble(
                  key: const Key('dashboard_alert_banner'),
                  textKey: const Key('dashboard_alert_text'),
                  message: alert.text,
                ),
              ),
            ),
    );
  }

  /// ความสูงฟองข้อความ Priority 1 ที่ความกว้าง [width] (padding 16/8 + ข้อความ bodyMedium)
  MinHeightForWidth _alertSlotMinHeightFor(BuildContext context) {
    final theme = Theme.of(context);
    final base = DefaultTextStyle.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    final locale = Localizations.maybeLocaleOf(context);
    return (width) {
      final painter = TextPainter(
        text: TextSpan(
          text: DashboardAlert.overeating.text,
          style: base.style.merge(theme.textTheme.bodyMedium),
        ),
        textAlign: TextAlign.center,
        textDirection: direction,
        textScaler: scaler,
        locale: locale,
        textHeightBehavior: base.textHeightBehavior,
        textWidthBasis: base.textWidthBasis,
      )..layout(maxWidth: math.max(0, width - _AlertBubble.padH * 2));
      final h = painter.height + _AlertBubble.padV * 2;
      painter.dispose();
      return h;
    };
  }

  /// ui-spec §2.1.2 แถวแถบรายหมวด
  Widget _buildBarRow(
    BuildContext context, {
    required String name,
    required String label,
    required int score,
    required Color color,
    Color? labelColor,
  }) {
    return Column(
      key: Key('dashboard_${name}_row'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          key: Key('dashboard_${name}_label_text'),
          textAlign: TextAlign.start,
          style: labelColor == null ? null : TextStyle(color: labelColor),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            key: Key('dashboard_${name}_bar'),
            value: (score / DashboardRules.maxScore).clamp(0.0, 1.0),
            minHeight: DashboardRules.barMinHeight,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// ฟองข้อความแจ้งเตือน (ui-spec §2.1.1) — ไม่มี maxLines / ellipsis
class _AlertBubble extends StatelessWidget {
  const _AlertBubble({super.key, required this.message, this.textKey});

  /// ui-spec §1.3 padding ในกล่อง แนวนอน 16 แนวตั้ง 8
  static const double padH = 16;
  static const double padV = 8;

  final String message;
  final Key? textKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        key: textKey,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: scheme.onSecondaryContainer,
        ),
      ),
    );
  }
}

=== จบ app/lib/features/dashboard/screens/dashboard_screen.dart ===

=== app/lib/features/food/food_controller.dart ===
/// ตัวกลางระหว่าง logic เกมกับ UI ของฟีเจอร์ food
///
/// controller ถือสถานะชั่วคราว EATING / OVER_LIMIT_FEEDING (EATING_ANIMATION_DURATION) และ
/// Toast (TOAST_DURATION) เอง — widget สัตว์เลี้ยงไม่จับเวลา (ui-spec §4, character.md §6)
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../shared/pet/pet_pose.dart' show PetPose;
import '../signup/signup_models.dart' show SignupGender, UserProfile;
import 'food_logic.dart';
import 'food_models.dart';
import 'food_nutrition_parser.dart';
import 'food_profile_source.dart';
import 'food_repository.dart';
import 'food_rules.dart';

typedef FoodClock = DateTime Function();

/// สร้าง Timer — inject ตัวปลอมในเทสต์ที่ไม่ใช่ widget test เพื่อสั่งให้หมดเวลาเองได้
typedef FoodTimerFactory = Timer Function(
  Duration duration,
  void Function() callback,
);

Timer _defaultTimer(Duration d, void Function() cb) => Timer(d, cb);

/// ผลการกด「บันทึกข้อมูล」ใน S-2
enum MealSubmitOutcome {
  /// บันทึกแล้ว → กลับ S-1
  logged,

  /// AI Parsing Failure / Offline / เกิน AI_PARSING_TIMEOUT → S-2 Error (EC-1)
  parseFailed,

  /// ค่าแคลอรี่ที่กรอกเองอ่านไม่ได้
  invalidCalories,

  /// ยังโหลดไม่เสร็จ / กำลังบันทึกอยู่
  notReady,
}

/// ผลการบันทึก S-3
enum FoodProfileSaveOutcome { saved, invalid, failed }

class FoodController extends ChangeNotifier {
  FoodController({
    required this._repository,
    FoodProfileSource? profileSource,
    FoodNutritionParser? parser,
    FoodClock? clock,
    FoodTimerFactory? timerFactory,
  }) : _profileSource = profileSource ?? InMemoryFoodProfileSource(),
       _parser = parser ?? LocalMenuNutritionParser(),
       _clock = clock ?? DateTime.now,
       _timer = timerFactory ?? _defaultTimer;

  final FoodRepository _repository;
  final FoodProfileSource _profileSource;
  final FoodNutritionParser _parser;
  final FoodClock _clock;
  final FoodTimerFactory _timer;

  FoodState _state = FoodState.initial;
  UserProfile? _profile;
  bool _isLoaded = false;
  bool _busy = false;
  bool _disposed = false;

  FoodPetState? _transient;
  Timer? _transientTimer;
  String? _toastMessage;
  int _toastSerial = 0;
  Timer? _toastTimer;

  // ---------------------------------------------------------------------------
  // ค่าสำหรับ UI
  // ---------------------------------------------------------------------------

  FoodState get state => _state;
  bool get isLoaded => _isLoaded;

  /// โปรไฟล์จาก signup (null = ยังไม่มี)
  UserProfile? get profile => _profile;

  /// ผู้ใช้กด「ข้ามไปก่อน」(US-3)
  bool get profileSkipped => _state.profileSkipped;

  /// `target_calories` — null = ไม่มีเป้าหมาย → CTA Banner (AC-8, EC-4, Q-9)
  int? get targetCalories => FoodLogic.targetForProfile(_profile);
  bool get hasTarget => targetCalories != null;
  bool get showsProfileCta => !hasTarget;

  /// Q-13: เปิด S-3 ให้เองเฉพาะตอนยังไม่มีโปรไฟล์และยังไม่เคยกดข้าม
  bool get needsProfileSetup =>
      _isLoaded && _profile == null && !_state.profileSkipped;

  int get totalCalories => _state.totalCalories;

  /// หลอดแดง + ป้าย「อิ่มแล้ว」 — ตามข้อมูลจริงทันที (Q-5 DECIDED owner: ไม่รอท่า)
  bool get isOverLimit => FoodLogic.isOverLimit(totalCalories, targetCalories);
  bool get showsFullBadge => isOverLimit;

  /// สถานะสัตว์เลี้ยงที่แสดง (รวมท่าชั่วคราว)
  FoodPetState get petState =>
      _transient ?? FoodLogic.basePetState(totalCalories, targetCalories);
  PetPose get petPose => FoodLogic.poseFor(petState);

  double get energyFraction {
    final t = targetCalories;
    return t == null ? 0 : FoodLogic.energyFraction(totalCalories, t);
  }

  /// `'<total> / <target> kcal'` — null เมื่อไม่มีเป้าหมาย
  String? get calorieText {
    final t = targetCalories;
    return t == null ? null : FoodLogic.calorieText(totalCalories, t);
  }

  String get ctaTotalText => FoodLogic.ctaTotalText(totalCalories);

  /// Toast ที่แสดงอยู่ (null = ไม่มี) — ทีละ 1 ข้อความ (AC-12)
  String? get toastMessage => _toastMessage;

  /// เพิ่มทุกครั้งที่มี Toast ใหม่ (Queue replace — EC-2)
  int get toastSerial => _toastSerial;

  // ---------------------------------------------------------------------------
  // โหลด / รอบวัน
  // ---------------------------------------------------------------------------

  Future<void> load() async {
    FoodState loaded;
    try {
      loaded = await _repository.load();
    } catch (_) {
      // ASSUMPTION: อ่านข้อมูลไม่ได้ → เริ่มเป็นค่าว่าง แอปไม่ล่ม
      loaded = FoodState.initial;
    }
    _state = loaded;
    await _loadProfile();
    _isLoaded = true;
    await refreshDay();
    _notify();
  }

  /// อ่านโปรไฟล์จาก signup ใหม่ (เรียกตอนกลับเข้าหน้า S-1)
  Future<void> refreshProfile() async {
    await _loadProfile();
    _notify();
  }

  Future<void> _loadProfile() async {
    try {
      _profile = await _profileSource.load();
    } catch (_) {
      // ASSUMPTION: อ่านโปรไฟล์ไม่ได้ → ถือว่าไม่มีเป้าหมาย (CTA Banner)
      _profile = null;
    }
  }

  /// ตรวจว่าข้าม 05:00 น. หรือยัง ถ้าใช่รีเซ็ตเป็น 0 kcal (game-rules §4 Foreground Crossing)
  /// เรียกตอนเปิดหน้า, กลับมา foreground และเป็นระยะขณะเปิดหน้าค้าง
  Future<void> refreshDay() async {
    if (!_isLoaded) return;
    final next = FoodLogic.applyDayRollover(
      _state,
      _clock(),
      targetCalories: targetCalories,
    );
    if (identical(next, _state)) return;
    _state = next;
    _notify();
    await _trySave();
  }

  // ---------------------------------------------------------------------------
  // S-2 บันทึกมื้ออาหาร (AC-1, AC-2, AC-3, EC-1, AC-11, AC-12, EC-2, EC-3)
  // ---------------------------------------------------------------------------

  /// "AI Parsing" ภายใน AI_PARSING_TIMEOUT — null = ล้มเหลว/ออฟไลน์/หมดเวลา (EC-1)
  Future<FoodNutrition?> analyzeMeal(String text) async {
    try {
      final raw = await _parser
          .parse(text)
          .timeout(const Duration(seconds: FoodRules.aiParsingTimeoutSeconds));
      return FoodLogic.parseNutritionJson(raw);
    } catch (_) {
      return null;
    }
  }

  /// S-2 สถานะปกติ: ประมวลผลข้อความเมนูแล้วบันทึก
  // ASSUMPTION: ช่องเมนูว่าง (ui-spec Q-12 ปุ่มยัง enabled) → ประมวลผลไม่ได้ = EC-1
  Future<MealSubmitOutcome> submitMeal(String text) async {
    if (!_isLoaded || _busy) return MealSubmitOutcome.notReady;
    _busy = true;
    try {
      final nutrition = await analyzeMeal(text);
      if (nutrition == null) return MealSubmitOutcome.parseFailed;
      await _log(nutrition, manual: false);
      return MealSubmitOutcome.logged;
    } finally {
      _busy = false;
    }
  }

  /// S-2 สถานะผิดพลาด/ออฟไลน์: บันทึกค่าที่กรอกเอง — ว่าง = 300 kcal (EC-1)
  Future<MealSubmitOutcome> submitManual(String rawCalories) async {
    if (!_isLoaded || _busy) return MealSubmitOutcome.notReady;
    final calories = FoodLogic.manualCalories(rawCalories);
    if (calories == null) return MealSubmitOutcome.invalidCalories;
    _busy = true;
    try {
      await _log(FoodNutrition(calories: calories), manual: true);
      return MealSubmitOutcome.logged;
    } finally {
      _busy = false;
    }
  }

  /// บันทึกผลโภชนาการ 1 มื้อ (ใช้ตรงในเทสต์ได้)
  Future<void> logNutrition(FoodNutrition nutrition, {bool manual = false}) {
    if (!_isLoaded) return Future.value();
    return _log(nutrition, manual: manual);
  }

  Future<void> _log(FoodNutrition nutrition, {required bool manual}) async {
    final target = targetCalories;
    final now = _clock();
    // ตรวจรอบวันก่อน แล้วจึงดูว่า "ก่อนบันทึก" อยู่ในสถานะเกินเป้าหรือไม่ (AC-11)
    final rolled = FoodLogic.applyDayRollover(
      _state,
      now,
      targetCalories: target,
    );
    final wasOver = FoodLogic.isOverLimit(rolled.totalCalories, target);
    _state = FoodLogic.logMeal(
      rolled,
      nutrition,
      now,
      targetCalories: target,
      manual: manual,
    );
    // ไม่เพิ่ม cheerTrigger — ท่ากินคือ reaction (ui-spec §4)
    // Q-4 (ค่าชั่วคราว ui-spec): บันทึกซ้อนระหว่างท่าชั่วคราว → เริ่มท่าใหม่ตามการบันทึกล่าสุด
    _startTransient(FoodLogic.transientStateForLog(wasOverLimit: wasOver));
    final toast = FoodLogic.toastForLog(wasOverLimit: wasOver);
    if (toast != null) showToast(toast);
    _notify();
    await _trySave();
  }

  void _startTransient(FoodPetState state) {
    _transientTimer?.cancel();
    _transient = state;
    _transientTimer = _timer(FoodLogic.transientDuration(state), () {
      _transientTimer = null;
      _transient = null;
      _notify();
    });
  }

  /// แสดง Toast เหนือสัตว์เลี้ยง — ข้อความใหม่แทนที่ทันทีและนับ TOAST_DURATION ใหม่ (AC-12, EC-2)
  void showToast(String message) {
    _toastTimer?.cancel();
    _toastMessage = message;
    _toastSerial++;
    _toastTimer = _timer(const Duration(seconds: FoodRules.toastSeconds), () {
      _toastTimer = null;
      _toastMessage = null;
      _notify();
    });
    _notify();
  }

  // ---------------------------------------------------------------------------
  // S-3 โปรไฟล์ (AC-4..AC-7, EC-5, US-3)
  // ---------------------------------------------------------------------------

  Future<FoodProfileSaveOutcome> saveProfile({
    required String age,
    required SignupGender? gender,
    required String weight,
    required String height,
  }) async {
    final v = FoodLogic.validateProfile(
      age: age,
      gender: gender,
      weight: weight,
      height: height,
    );
    if (!v.canSave || gender == null) return FoodProfileSaveOutcome.invalid;
    UserProfile? saved;
    try {
      saved = await _profileSource.save(
        FoodProfileInput(
          age: int.parse(age.trim()),
          gender: gender,
          weightKg: double.parse(weight.trim()),
          heightCm: double.parse(height.trim()),
        ),
      );
    } catch (_) {
      saved = null;
    }
    if (saved == null) return FoodProfileSaveOutcome.failed;
    _profile = saved;
    if (_state.profileSkipped) {
      _state = _state.copyWith(profileSkipped: false);
      await _trySave();
    }
    _notify();
    return FoodProfileSaveOutcome.saved;
  }

  /// 「ข้ามไปก่อน」 — บันทึกสถานะข้ามโปรไฟล์ (US-3)
  Future<void> skipProfile() async {
    _state = _state.copyWith(profileSkipped: true);
    _notify();
    await _trySave();
  }

  // ---------------------------------------------------------------------------

  Future<void> _trySave() async {
    try {
      await _repository.save(_state);
    } catch (_) {
      // ASSUMPTION: บันทึกลงเครื่องไม่สำเร็จ → คงค่าในหน่วยความจำ แล้วบันทึกซ้ำครั้งถัดไป
      // (ux-flow ไม่มี UI error สำหรับกรณีนี้)
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _transientTimer?.cancel();
    _toastTimer?.cancel();
    super.dispose();
  }
}

=== จบ app/lib/features/food/food_controller.dart ===

=== app/lib/features/food/food_logic.dart ===
/// Logic เกมของฟีเจอร์ food — pure Dart ไม่ขึ้นกับ widget
///
/// ทุกฟังก์ชันที่เกี่ยวกับเวลารับ `now` เป็นพารามิเตอร์ เพื่อให้ QA ทดสอบได้
library;

import 'dart:convert';

import '../../shared/pet/pet_pose.dart' show PetPose;
import '../signup/signup_logic.dart' show NumberFieldStatus, SignupLogic;
import '../signup/signup_models.dart' show SignupGender, UserProfile;
import '../steps/steps_logic.dart' show StepsLogic;
import 'food_models.dart';
import 'food_rules.dart';

class FoodLogic {
  FoodLogic._();

  // ---------------------------------------------------------------------------
  // รอบวัน 05:00 น. (AC-3, US-5, game-rules §4 Foreground Crossing)
  // ---------------------------------------------------------------------------

  /// วันที่ "ตามรอบวัน" ที่เริ่ม 05:00 น. — AC-3: 15 ต.ค. 03:00 → 14 ต.ค.
  static DateTime logicalDay(DateTime now) {
    // ใช้ constructor ของ DateTime (ไม่ใช่ subtract Duration) กัน DST ทำให้วันเพี้ยน
    final shifted = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour - FoodRules.dailyResetHour,
      now.minute - FoodRules.dailyResetMinute,
    );
    return DateTime(shifted.year, shifted.month, shifted.day);
  }

  /// เวลาที่ใช้คำนวณกติกา: ไม่ถอยหลังกว่าเวลาล่าสุดที่ระบบเคยเห็น
  // ASSUMPTION: นาฬิกาเครื่องย้อน → ใช้เวลาล่าสุดที่เคยเห็น (ไม่ย้อนรอบวัน ไม่ลบข้อมูล)
  // แนวเดียวกับ StepsLogic.effectiveNow / WaterLogic — เอกสาร food ไม่กำหนด
  static DateTime effectiveNow(DateTime? lastSeenAt, DateTime now) =>
      lastSeenAt != null && now.isBefore(lastSeenAt) ? lastSeenAt : now;

  /// ตรวจและปรับรอบวัน ณ `now`:
  /// - ครั้งแรก (day == null) → ตั้งรอบวันปัจจุบัน 0 kcal
  /// - ข้าม 05:00 น. → เก็บรอบวันเดิมลงประวัติ แล้วรีเซ็ตเป็น 0 kcal
  /// - ตัดประวัติที่เก่ากว่า HISTORY_RETENTION_DAYS
  /// [targetCalories] = เป้าหมายปัจจุบัน ใช้คำนวณ `is_over_target` ของวันที่ถูกเก็บ
  /// คืน object เดิม (identical) ถ้าไม่มีอะไรเปลี่ยน
  static FoodState applyDayRollover(
    FoodState state,
    DateTime now, {
    int? targetCalories,
  }) {
    final effective = effectiveNow(state.lastSeenAt, now);
    final today = logicalDay(effective);
    final day = state.day;
    if (day == null) {
      return state.copyWith(
        day: today,
        totalCalories: 0,
        meals: const [],
        lastSeenAt: effective,
      );
    }
    if (!today.isAfter(day)) return state;
    final record = DailyFoodRecord(
      date: day,
      totalCalories: state.totalCalories,
      targetCalories: targetCalories,
      isOverTarget: isOverLimit(state.totalCalories, targetCalories),
      highSodium: state.todayHighSodium,
      highSugar: state.todayHighSugar,
    );
    return state.copyWith(
      day: today,
      totalCalories: 0,
      meals: const [],
      history: pruneHistory(upsertHistory(state.history, record), today),
      lastSeenAt: effective,
    );
  }

  /// ใส่/แทนที่ประวัติวันเดียวกัน แล้วเรียงเก่า → ใหม่
  static List<DailyFoodRecord> upsertHistory(
    List<DailyFoodRecord> history,
    DailyFoodRecord record,
  ) {
    final next = [
      for (final r in history)
        if (r.date != record.date) r,
      record,
    ]..sort((a, b) => a.date.compareTo(b.date));
    return List.unmodifiable(next);
  }

  /// เก็บเฉพาะวันที่อยู่ใน HISTORY_RETENTION_DAYS วันล่าสุด (นับรวม [today])
  static List<DailyFoodRecord> pruneHistory(
    List<DailyFoodRecord> history,
    DateTime today,
  ) {
    final oldest = DateTime(
      today.year,
      today.month,
      today.day - (FoodRules.historyRetentionDays - 1),
    );
    return List.unmodifiable([
      for (final r in history)
        if (!r.date.isBefore(oldest) && r.date.isBefore(today)) r,
    ]);
  }

  /// บันทึก 1 มื้อ ณ `now` (ตรวจรอบวันก่อน — AC-3) — total เพิ่มทันที
  static FoodState logMeal(
    FoodState state,
    FoodNutrition nutrition,
    DateTime now, {
    int? targetCalories,
    bool manual = false,
  }) {
    final rolled = applyDayRollover(state, now, targetCalories: targetCalories);
    final effective = effectiveNow(rolled.lastSeenAt, now);
    final calories = nutrition.calories < 0 ? 0 : nutrition.calories;
    final entry = FoodMealEntry(
      date: rolled.day!,
      loggedAt: effective,
      calories: calories,
      highSodium: nutrition.highSodium,
      highSugar: nutrition.highSugar,
      manual: manual,
    );
    return rolled.copyWith(
      totalCalories: rolled.totalCalories + calories,
      meals: List.unmodifiable([...rolled.meals, entry]),
      lastSeenAt: effective,
    );
  }

  // ---------------------------------------------------------------------------
  // เป้าหมายแคลอรี่ (AC-5, AC-6, AC-7, Base Target Reference Table)
  // ---------------------------------------------------------------------------

  /// Base Target ตามอายุและเพศ — null = คำนวณไม่ได้ (เพศไม่ระบุ / อายุนอก AGE_MIN..AGE_MAX)
  static int? baseTarget(int age, SignupGender gender) {
    if (!isAgeInRange(age)) return null;
    final bool male;
    switch (gender) {
      case SignupGender.male:
        male = true;
      case SignupGender.female:
        male = false;
      case SignupGender.unspecified:
        // ASSUMPTION: เพศ UNSPECIFIED (จาก signup S-6) ไม่มีในตาราง → ไม่มีเป้าหมาย
        // (signup AC-6 "ไม่สามารถคำนวณจำนวนแคลอรี่ที่เหมาะสมต่อวันได้") → แสดง CTA Banner
        return null;
    }
    if (age >= FoodRules.ageBand51upMin) {
      return male
          ? FoodRules.maleBaseTarget51up
          : FoodRules.femaleBaseTarget51up;
    }
    if (age >= FoodRules.ageBand19to50Min) {
      return male
          ? FoodRules.maleBaseTarget19to50
          : FoodRules.femaleBaseTarget19to50;
    }
    if (age >= FoodRules.ageBand16to18Min) {
      return male
          ? FoodRules.maleBaseTarget16to18
          : FoodRules.femaleBaseTarget16to18;
    }
    if (age >= FoodRules.ageBand13to15Min) {
      return male
          ? FoodRules.maleBaseTarget13to15
          : FoodRules.femaleBaseTarget13to15;
    }
    if (age >= FoodRules.ageBand10to12Min) {
      return male
          ? FoodRules.maleBaseTarget10to12
          : FoodRules.femaleBaseTarget10to12;
    }
    // อายุ 1–9 ปี — fallback ของ Design (game-rules §5)
    return male
        ? FoodRules.fallbackBaseTargetAge1to9Male
        : FoodRules.fallbackBaseTargetAge1to9Female;
  }

  /// BMI_FORMULA = weight_kg / ((height_cm / 100) ^ 2) — null ถ้าค่าไม่บวก
  /// คำนวณเป็น `weight * 10000 / (height * height)` (หารครั้งเดียว ลด floating error ที่ขอบ)
  // ASSUMPTION: เทียบเกณฑ์ด้วยค่า BMI จริง ไม่ปัดเป็นทศนิยม 1 ตำแหน่งก่อนเทียบ
  // ("Float 1 ตำแหน่ง" ใน game-rules ถือเป็นรูปแบบของค่าเกณฑ์)
  static double? bmi(double weightKg, double heightCm) {
    if (weightKg <= 0 || heightCm <= 0) return null;
    return weightKg * 10000 / (heightCm * heightCm);
  }

  /// ส่วนปรับตาม BMI: < 18.5 → +400 (AC-6), ≥ 23.0 → −400 (AC-7), อื่น ๆ → 0
  static int bmiAdjustment(double bmi) {
    if (bmi < FoodRules.bmiUnderweightThreshold) {
      return FoodRules.bmiUnderweightBonus;
    }
    if (bmi >= FoodRules.bmiOverweightThreshold) {
      return -FoodRules.bmiOverweightPenalty;
    }
    return 0;
  }

  /// `target_calories` — null = ไม่มีเป้าหมาย (แสดง CTA Banner, ไม่มี OVER_LIMIT — Q-9)
  static int? targetCalories({
    required int age,
    required SignupGender gender,
    required double? weightKg,
    required double? heightCm,
  }) {
    final base = baseTarget(age, gender);
    if (base == null || weightKg == null || heightCm == null) {
      // ASSUMPTION: โปรไฟล์ signup ที่ไม่มีน้ำหนัก/ส่วนสูง คำนวณ BMI ไม่ได้ → ไม่มีเป้าหมาย
      // (signup AC-7 "จะไม่มีการแนะนำแคลอรี่ที่เหมาะสมต่อวัน")
      return null;
    }
    final b = bmi(weightKg, heightCm);
    if (b == null) return null;
    return base + bmiAdjustment(b);
  }

  /// เป้าหมายจากโปรไฟล์ของ signup (Q-13) — null = ไม่มีโปรไฟล์ / ไม่ครบ
  static int? targetForProfile(UserProfile? profile) {
    if (profile == null) return null;
    return targetCalories(
      age: profile.age,
      gender: profile.gender,
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
    );
  }

  // ---------------------------------------------------------------------------
  // สถานะสัตว์เลี้ยง / หลอดพลังงาน (AC-9, AC-10, AC-11, game-rules §2)
  // ---------------------------------------------------------------------------

  /// `total > target + OVER_LIMIT_THRESHOLD` — ไม่มีเป้าหมาย → false เสมอ (Q-9)
  static bool isOverLimit(int total, int? target) =>
      target != null && total > target + FoodRules.overLimitThreshold;

  /// สถานะคงที่ (ไม่รวมท่าชั่วคราว)
  static FoodPetState basePetState(int total, int? target) =>
      isOverLimit(total, target) ? FoodPetState.overLimit : FoodPetState.normal;

  /// ท่าชั่วคราวหลังบันทึกสำเร็จ — [wasOverLimit] = ก่อนบันทึกอยู่ในสถานะเกินเป้าแล้ว
  /// (AC-11 / EC-3 → OVER_LIMIT_FEEDING, อื่น ๆ → EATING)
  static FoodPetState transientStateForLog({required bool wasOverLimit}) =>
      wasOverLimit ? FoodPetState.overLimitFeeding : FoodPetState.eating;

  /// ระยะของท่าชั่วคราว
  static Duration transientDuration(FoodPetState state) =>
      state == FoodPetState.overLimitFeeding
      ? const Duration(seconds: FoodRules.overLimitFeedingSeconds)
      : const Duration(seconds: FoodRules.eatingAnimationSeconds);

  /// Toast หลังบันทึก — AC-11: บันทึกขณะเกินเป้า → 「พอเถอะน้าคนดี」 ทุกครั้ง; อื่น ๆ → null
  static String? toastForLog({required bool wasOverLimit}) =>
      wasOverLimit ? FoodRules.overLimitToastText : null;

  /// สถานะ → ท่าของ shared pet (OQ-1 DECIDED: PetCharacter แทน Lottie/PNG)
  static PetPose poseFor(FoodPetState state) => switch (state) {
    FoodPetState.normal => PetPose.foodNormal,
    FoodPetState.eating => PetPose.foodEating,
    FoodPetState.overLimit => PetPose.foodOverLimit,
    FoodPetState.overLimitFeeding => PetPose.foodOverLimitFeeding,
  };

  /// สัดส่วนหลอด 0.0–1.0 (ui-spec §2.1 #9a: clamp)
  static double energyFraction(int total, int target) {
    if (target <= 0 || total <= 0) return 0;
    final f = total / target;
    return f > 1 ? 1 : f;
  }

  /// `'<total> / <target> kcal'` เช่น `1,900 / 2,000 kcal` (ไม่ clamp)
  static String calorieText(int total, int target) =>
      '${StepsLogic.formatThousands(total)} / '
      '${StepsLogic.formatThousands(target)} ${FoodRules.kcalUnit}';

  /// ยอดรวมบน CTA Banner เช่น `1,250 kcal` (ui-spec Q-8)
  static String ctaTotalText(int total) =>
      '${StepsLogic.formatThousands(total)} ${FoodRules.kcalUnit}';

  // ---------------------------------------------------------------------------
  // ผล "AI Parsing" (AC-1, AC-2, EC-1)
  // ---------------------------------------------------------------------------

  /// ค่ากึ่งกลาง (Median) ของชุดตัวเลข (AC-2) — ช่วง [a, b] = (a + b) / 2
  // ASSUMPTION: ผลไม่ลงตัวปัดเป็นจำนวนเต็มที่ใกล้สุด (.5 ปัดขึ้น) เพราะ total_calories
  // เป็น Integer (requirements §6) — เอกสารไม่กำหนดวิธีปัด
  static int medianCalories(List<num> values) {
    if (values.isEmpty) throw ArgumentError('values must not be empty');
    final sorted = [...values]..sort();
    final mid = sorted.length ~/ 2;
    final median = sorted.length.isOdd
        ? sorted[mid].toDouble()
        : (sorted[mid - 1] + sorted[mid]) / 2;
    return median.round();
  }

  static final RegExp _rangeText = RegExp(
    r'^\s*(\d+(?:\.\d+)?)\s*[-–~]\s*(\d+(?:\.\d+)?)\s*$',
  );

  /// อ่าน JSON โภชนาการ (AC-1) — `calories` เป็นตัวเลข, ช่วงตัวเลข (`[a, b]`, `"a-b"`,
  /// `{"min": a, "max": b}`) → ใช้ Median (AC-2) · คืน null ถ้าอ่านไม่ได้ (EC-1)
  static FoodNutrition? parseNutritionJson(String raw) {
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (_) {
      return null;
    }
    if (decoded is! Map) return null;
    final calories = _readCalories(decoded['calories']);
    if (calories == null || calories < 0) return null;
    return FoodNutrition(
      calories: calories,
      highSodium: decoded['high_sodium'] == true,
      highSugar: decoded['high_sugar'] == true,
    );
  }

  static int? _readCalories(Object? v) {
    if (v is num) return v.isFinite ? v.round() : null;
    if (v is List) {
      if (v.isEmpty || v.any((e) => e is! num)) return null;
      return medianCalories(v.cast<num>());
    }
    if (v is Map) {
      final min = v['min'];
      final max = v['max'];
      if (min is num && max is num) return medianCalories([min, max]);
      return null;
    }
    if (v is String) {
      final m = _rangeText.firstMatch(v);
      if (m != null) {
        return medianCalories([
          double.parse(m.group(1)!),
          double.parse(m.group(2)!),
        ]);
      }
      final n = num.tryParse(v.trim());
      return n == null || !n.isFinite ? null : n.round();
    }
    return null;
  }

  /// ค่าแคลอรี่จากฟอร์มกรอกเอง (EC-1) — ว่าง → FALLBACK_DEFAULT_CALORIES (300)
  /// คืน null ถ้าไม่ใช่จำนวนเต็มล้วน (UI กรองด้วย digitsOnly อยู่แล้ว)
  static int? manualCalories(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return FoodRules.fallbackDefaultCalories;
    if (!SignupLogic.isWholeNumberText(text)) return null;
    return int.tryParse(text);
  }

  // ---------------------------------------------------------------------------
  // S-3 ฟอร์มโปรไฟล์ (AC-4, EC-5, Q-14 DECIDED: กติกาเดียวกับ signup)
  // ---------------------------------------------------------------------------

  /// AGE_MIN ≤ age ≤ AGE_MAX
  static bool isAgeInRange(int age) =>
      age >= FoodRules.ageMin && age <= FoodRules.ageMax;

  /// อายุต้องเป็นจำนวนเต็มล้วน 1–120 — "25.5", "-3", "abc" = invalid (AC-4, EC-5)
  static FoodFieldStatus ageStatus(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return FoodFieldStatus.empty;
    if (!SignupLogic.isWholeNumberText(text)) return FoodFieldStatus.invalid;
    final v = int.tryParse(text);
    if (v == null || !isAgeInRange(v)) return FoodFieldStatus.invalid;
    return FoodFieldStatus.valid;
  }

  /// น้ำหนัก/ส่วนสูงรับทศนิยม (Q-14)
  // ASSUMPTION: ใช้ช่วงที่ signup รับ (น้ำหนัก 1–300 kg, ส่วนสูง 1–250 cm —
  // SignupLogic.weightStatus/heightStatus) เพราะโปรไฟล์บันทึกผ่าน signup (Q-13);
  // นอกช่วง = บันทึกไม่ได้ (ปุ่ม disabled) โดยไม่มีข้อความ error (ui-spec Q-15)
  static FoodFieldStatus weightStatus(String raw) =>
      _fromSignup(SignupLogic.weightStatus(raw));

  static FoodFieldStatus heightStatus(String raw) =>
      _fromSignup(SignupLogic.heightStatus(raw));

  static FoodFieldStatus _fromSignup(NumberFieldStatus status) =>
      switch (status) {
        NumberFieldStatus.empty => FoodFieldStatus.empty,
        NumberFieldStatus.valid => FoodFieldStatus.valid,
        NumberFieldStatus.outOfRange => FoodFieldStatus.invalid,
      };

  static FoodProfileValidation validateProfile({
    required String age,
    required SignupGender? gender,
    required String weight,
    required String height,
  }) => FoodProfileValidation(
    age: ageStatus(age),
    weight: weightStatus(weight),
    height: heightStatus(height),
    hasGender: gender == SignupGender.male || gender == SignupGender.female,
  );
}

=== จบ app/lib/features/food/food_logic.dart ===

=== app/lib/features/food/food_menu_table.dart ===
/// ตารางเมนูอาหารไทยที่ใช้บ่อย (ข้อมูลในเครื่อง) + ตัวจับคู่ชื่อเมนู — pure Dart
///
/// Q-17 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน): MVP ไม่มี AI และไม่ต่อเน็ต ใช้ตารางนี้
/// เทียบชื่อเมนู → kcal แทน AI Parsing ถ้าไม่เจอเมนูในตาราง = AI Parsing Failure (EC-1)
/// → S-2 แสดงช่องกรอกแคลอรี่เอง
///
// ASSUMPTION: ค่าชั่วคราว รอคำตอบ — ค่า kcal / ธงโซเดียม-น้ำตาลในตารางเป็นค่าประมาณ
// ต่อ 1 จาน/ชาม/แก้ว/ชิ้น จากตารางแคลอรี่อาหารไทยทั่วไป ไม่ได้มาจาก game-rules.md
// (เอกสารไม่มีตารางเมนู) ให้ Product/โภชนากรยืนยันหรือแทนที่ทั้งตาราง
// บางเมนูเก็บเป็น "ช่วง" (minKcal–maxKcal) เพื่อให้ผลเป็นช่วงตัวเลขแบบที่ AC-2 กล่าวถึง
// (ระบบจะใช้ค่ากึ่งกลาง — FoodLogic.medianCalories)
library;

import 'food_rules.dart';

/// เมนู 1 รายการในตาราง
class FoodMenuItem {
  const FoodMenuItem(
    this.names,
    this.minKcal, [
    int? maxKcal,
    this.highSodium = false,
    this.highSugar = false,
  ]) : maxKcal = maxKcal ?? minKcal;

  /// ชื่อเรียก (ชื่อแรก = ชื่อหลัก) — จับคู่แบบ "มีข้อความนี้อยู่ในประโยค"
  final List<String> names;
  final int minKcal;
  final int maxKcal;
  final bool highSodium;
  final bool highSugar;

  bool get isRange => maxKcal != minKcal;
  String get name => names.first;
}

/// เมนูที่จับคู่ได้ 1 ครั้งในข้อความ
class FoodMenuMatch {
  const FoodMenuMatch({
    required this.item,
    required this.alias,
    required this.start,
    required this.quantity,
  });

  final FoodMenuItem item;

  /// ชื่อที่พบจริงในข้อความ
  final String alias;

  /// ตำแหน่งในข้อความที่ normalize แล้ว
  final int start;
  final int quantity;

  int get minKcal => item.minKcal * quantity;
  int get maxKcal => item.maxKcal * quantity;
}

const bool _s = true; // high_sodium = true
const bool _n =
    false; // high_sodium = false (ใช้เมื่อต้องระบุ high_sugar ต่อท้าย)

/// ตารางเมนู — (ชื่อเรียก, kcal ต่ำสุด, kcal สูงสุด, โซเดียมสูง, น้ำตาลสูง)
const List<FoodMenuItem> kFoodMenuTable = [
  // จานเดียว
  FoodMenuItem(['ข้าวมันไก่ทอด'], 690, null, _s),
  FoodMenuItem(['ข้าวมันไก่'], 596, null, _s),
  FoodMenuItem(['ข้าวขาหมู'], 690, null, _s),
  FoodMenuItem(['ข้าวหมูแดง'], 540, null, _s, true),
  FoodMenuItem(['ข้าวหมูกรอบ'], 650, null, _s),
  FoodMenuItem(
    ['ข้าวผัดกะเพรา', 'ข้าวกะเพรา', 'กะเพรา', 'กระเพรา'],
    550,
    650,
    _s,
  ),
  FoodMenuItem(['ข้าวผัด'], 550, 650, _s),
  FoodMenuItem(['ข้าวไข่เจียว'], 450, 550),
  FoodMenuItem(['ข้าวไข่ดาว'], 380),
  FoodMenuItem(['ผัดไทย'], 450, 550, _s, true),
  FoodMenuItem(['ผัดซีอิ๊ว'], 600, 700, _s),
  FoodMenuItem(['ราดหน้า'], 400, 450, _s),
  FoodMenuItem(['สุกี้'], 300, 400, _s),
  FoodMenuItem(['ก๋วยเตี๋ยวต้มยำ'], 350, 450, _s),
  FoodMenuItem(['ก๋วยเตี๋ยวเรือ'], 200, 300, _s),
  FoodMenuItem(['ก๋วยเตี๋ยว'], 300, 400, _s),
  FoodMenuItem(['บะหมี่กึ่งสำเร็จรูป', 'มาม่า'], 300, null, _s),
  FoodMenuItem(['ขนมจีนน้ำยา', 'ขนมจีน'], 350, 450, _s),
  FoodMenuItem(['โจ๊ก'], 160, 250, _s),
  FoodMenuItem(['ข้าวต้ม'], 220, 300, _s),
  FoodMenuItem(['ข้าวมันส้มตำ'], 450, 550, _s, true),
  // กับข้าว / อีสาน
  FoodMenuItem(['ส้มตำ'], 60, 120, _s, true),
  FoodMenuItem(['ไก่ย่าง'], 160, 250, _s),
  FoodMenuItem(['คอหมูย่าง'], 300, 400, _s),
  FoodMenuItem(['หมูปิ้ง'], 100, 150, _n, true),
  FoodMenuItem(['ลาบ'], 200, 250, _s),
  FoodMenuItem(['น้ำตก'], 220, 250, _s),
  FoodMenuItem(['ต้มยำ'], 100, 250, _s),
  FoodMenuItem(['แกงเขียวหวาน'], 240, 300, _s),
  FoodMenuItem(['ไข่เจียว'], 250),
  FoodMenuItem(['ไข่ดาว'], 120),
  FoodMenuItem(['ไข่ต้ม'], 75),
  FoodMenuItem(['หมูกระทะ'], 800, 1200, _s),
  // ข้าวเปล่า
  FoodMenuItem(['ข้าวเหนียว'], 300, 350),
  FoodMenuItem(['ข้าวสวย', 'ข้าวเปล่า'], 240),
  // เครื่องดื่ม / ของว่าง
  FoodMenuItem(['ชานมไข่มุก'], 300, 450, _n, true),
  FoodMenuItem(['ชาเย็น', 'ชาไทย'], 250, 300, _n, true),
  FoodMenuItem(['กาแฟเย็น'], 200, 250, _n, true),
  FoodMenuItem(['น้ำอัดลม'], 140, 160, _n, true),
  FoodMenuItem(['โรตี'], 300, 400, _n, true),
  FoodMenuItem(['กล้วยทอด'], 200, 250, _n, true),
  FoodMenuItem(['ปาท่องโก๋'], 150, 200),
];

/// จับคู่ข้อความเมนูกับตาราง
///
/// วิธีจับคู่ (Q-17):
/// 1. normalize: ตัดช่องว่างหัวท้าย, เปลี่ยนตัวพิมพ์ใหญ่เป็นเล็ก, ยุบช่องว่างหลายช่องเป็นช่องเดียว
/// 2. ไล่ชื่อเรียกทุกชื่อจาก "ยาวที่สุด" ไป "สั้นที่สุด" หาทุกตำแหน่งที่พบในข้อความ
///    ตำแหน่งที่จับคู่แล้วถูกกันไว้ ชื่อที่สั้นกว่าจับซ้ำทับไม่ได้
///    (เช่น "ข้าวมันไก่ทอด" ไม่ถูกนับเป็น "ข้าวมันไก่" อีกรอบ, "ไข่เจียว" ใน "ข้าวไข่เจียว" ไม่ถูกนับซ้ำ)
/// 3. ถ้ามีตัวเลขตามหลังชื่อเมนู (ช่องว่างคั่นได้) เช่น "ข้าวมันไก่ 2 จาน" → คูณจำนวน
///    ไม่มีตัวเลข / เลข 0 → 1 ที่
/// 4. คืนรายการเรียงตามตำแหน่งในข้อความ — ว่าง = ไม่เจอเมนู
class FoodMenuMatcher {
  FoodMenuMatcher._();

  static String normalize(String text) =>
      text.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  static final RegExp _quantity = RegExp(
    '^ ?([0-9]{1,${FoodRules.menuQuantityMaxDigits}})(?![0-9])',
  );

  static List<FoodMenuMatch> match(
    String text, {
    List<FoodMenuItem> menu = kFoodMenuTable,
  }) {
    final normalized = normalize(text);
    if (normalized.isEmpty) return const [];
    final aliases = <({String alias, FoodMenuItem item})>[
      for (final item in menu)
        for (final name in item.names)
          if (normalize(name).isNotEmpty) (alias: normalize(name), item: item),
    ]..sort((a, b) => b.alias.length.compareTo(a.alias.length));

    final taken = List<bool>.filled(normalized.length, false);
    final matches = <FoodMenuMatch>[];
    for (final a in aliases) {
      var from = 0;
      while (true) {
        final i = normalized.indexOf(a.alias, from);
        if (i < 0) break;
        final end = i + a.alias.length;
        from = i + 1;
        var free = true;
        for (var k = i; k < end; k++) {
          if (taken[k]) {
            free = false;
            break;
          }
        }
        if (!free) continue;
        for (var k = i; k < end; k++) {
          taken[k] = true;
        }
        final q = _quantity.firstMatch(normalized.substring(end));
        final qty = q == null ? 1 : int.parse(q.group(1)!);
        matches.add(
          FoodMenuMatch(
            item: a.item,
            alias: a.alias,
            start: i,
            quantity: qty < 1 ? 1 : qty,
          ),
        );
        from = end;
      }
    }
    matches.sort((x, y) => x.start.compareTo(y.start));
    return List.unmodifiable(matches);
  }
}

=== จบ app/lib/features/food/food_menu_table.dart ===

=== app/lib/features/food/food_models.dart ===
/// โมเดลข้อมูลของฟีเจอร์ food (pure Dart)
library;

/// สถานะ/ท่าของสัตว์เลี้ยง 4 ท่า (game-rules §2)
enum FoodPetState {
  /// ท่าหิว / ปกติ — `total <= target + OVER_LIMIT_THRESHOLD` (หรือไม่มีเป้าหมาย)
  normal('NORMAL', 'normal'),

  /// ท่ากำลังกิน — ชั่วคราว EATING_ANIMATION_DURATION หลังบันทึกสำเร็จ
  eating('EATING', 'eating'),

  /// ท่าอิ่มพุงกาง — `total > target + OVER_LIMIT_THRESHOLD`
  overLimit('OVER_LIMIT', 'over_limit'),

  /// ท่าอิ่มพุงกางแต่ยังกิน — ชั่วคราว เมื่อบันทึกซ้ำขณะเกินเป้า
  overLimitFeeding('OVER_LIMIT_FEEDING', 'over_limit_feeding');

  const FoodPetState(this.code, this.keyName);

  /// รหัสใน game-rules §2
  final String code;

  /// ส่วนท้ายของ key `food_pet_image_<keyName>` (ui-spec §4)
  final String keyName;

  bool get isTransient =>
      this == FoodPetState.eating || this == FoodPetState.overLimitFeeding;
}

/// ผลโภชนาการของ 1 มื้อ (AC-1: `{"calories": 400, "high_sodium": true, "high_sugar": false}`)
class FoodNutrition {
  const FoodNutrition({
    required this.calories,
    this.highSodium = false,
    this.highSugar = false,
  });

  final int calories;
  final bool highSodium;
  final bool highSugar;

  Map<String, dynamic> toJson() => {
    'calories': calories,
    'high_sodium': highSodium,
    'high_sugar': highSugar,
  };

  @override
  bool operator ==(Object other) =>
      other is FoodNutrition &&
      other.calories == calories &&
      other.highSodium == highSodium &&
      other.highSugar == highSugar;

  @override
  int get hashCode => Object.hash(calories, highSodium, highSugar);

  @override
  String toString() => 'FoodNutrition(${toJson()})';
}

/// วันที่รูปแบบ YYYY-MM-DD (requirements §6 `date`)
String formatFoodDateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

DateTime? parseFoodDateKey(Object? raw) {
  if (raw is! String) return null;
  final d = DateTime.tryParse(raw);
  return d == null ? null : DateTime(d.year, d.month, d.day);
}

/// Log การบันทึก 1 มื้อของรอบวันปัจจุบัน (AC-3: `date` = รอบวันตามตัดรอบ 05:00)
class FoodMealEntry {
  const FoodMealEntry({
    required this.date,
    required this.loggedAt,
    required this.calories,
    this.highSodium = false,
    this.highSugar = false,
    this.manual = false,
  });

  /// รอบวัน (ตัดรอบ 05:00) — ไม่ใช่วันที่ตามปฏิทินของ [loggedAt]
  final DateTime date;
  final DateTime loggedAt;
  final int calories;
  final bool highSodium;
  final bool highSugar;

  /// true = มาจากฟอร์มกรอกเอง (EC-1)
  final bool manual;

  Map<String, dynamic> toJson() => {
    'date': formatFoodDateKey(date),
    'logged_at': loggedAt.toIso8601String(),
    'calories': calories,
    'high_sodium': highSodium,
    'high_sugar': highSugar,
    'manual': manual,
  };

  factory FoodMealEntry.fromJson(Map<String, dynamic> json) {
    final date = parseFoodDateKey(json['date']);
    final loggedAt = DateTime.tryParse(json['logged_at'] as String? ?? '');
    final calories = json['calories'];
    if (date == null || loggedAt == null || calories is! int || calories < 0) {
      throw const FormatException('invalid FoodMealEntry');
    }
    return FoodMealEntry(
      date: date,
      loggedAt: loggedAt,
      calories: calories,
      highSodium: json['high_sodium'] == true,
      highSugar: json['high_sugar'] == true,
      manual: json['manual'] == true,
    );
  }
}

/// ประวัติรายวัน (requirements §6 Food History Schema)
// ASSUMPTION: ไม่เก็บ `user_id` — ข้อมูลอยู่ในเครื่องเดียวสำหรับผู้ใช้คนเดียว (แบบ water/steps)
class DailyFoodRecord {
  const DailyFoodRecord({
    required this.date,
    required this.totalCalories,
    required this.targetCalories,
    required this.isOverTarget,
    this.highSodium = false,
    this.highSugar = false,
  });

  final DateTime date;
  final int totalCalories;

  /// null = ไม่มีเป้าหมาย (ข้ามโปรไฟล์ / โปรไฟล์ไม่ครบ)
  final int? targetCalories;

  /// `total > target + OVER_LIMIT_THRESHOLD` (false เมื่อไม่มีเป้าหมาย)
  final bool isOverTarget;
  final bool highSodium;
  final bool highSugar;

  Map<String, dynamic> toJson() => {
    'date': formatFoodDateKey(date),
    'total_calories': totalCalories,
    'target_calories': targetCalories,
    'is_over_target': isOverTarget,
    'high_sodium': highSodium,
    'high_sugar': highSugar,
  };

  factory DailyFoodRecord.fromJson(Map<String, dynamic> json) {
    final date = parseFoodDateKey(json['date']);
    final total = json['total_calories'];
    final target = json['target_calories'];
    if (date == null || total is! int || total < 0) {
      throw const FormatException('invalid DailyFoodRecord');
    }
    return DailyFoodRecord(
      date: date,
      totalCalories: total,
      targetCalories: target is int ? target : null,
      isOverTarget: json['is_over_target'] == true,
      highSodium: json['high_sodium'] == true,
      highSugar: json['high_sugar'] == true,
    );
  }
}

/// สถานะทั้งหมดของ food ที่เก็บลงเครื่อง
class FoodState {
  const FoodState({
    this.day,
    this.totalCalories = 0,
    this.meals = const [],
    this.history = const [],
    this.lastSeenAt,
    this.profileSkipped = false,
  });

  static const FoodState initial = FoodState();

  /// รอบวันปัจจุบัน (null = ยังไม่เคยเปิด)
  final DateTime? day;

  /// `total_calories` ของรอบวันปัจจุบัน
  final int totalCalories;

  /// Log มื้อของรอบวันปัจจุบัน
  final List<FoodMealEntry> meals;

  /// ประวัติรอบวันก่อนหน้า (เก่า → ใหม่) ไม่เกิน HISTORY_RETENTION_DAYS (รวมวันนี้)
  final List<DailyFoodRecord> history;

  /// เวลาล่าสุดที่ระบบเห็น (กันนาฬิกาย้อน)
  final DateTime? lastSeenAt;

  /// ผู้ใช้กด「ข้ามไปก่อน」ใน S-3 (US-3)
  final bool profileSkipped;

  bool get todayHighSodium => meals.any((m) => m.highSodium);
  bool get todayHighSugar => meals.any((m) => m.highSugar);

  FoodState copyWith({
    DateTime? day,
    int? totalCalories,
    List<FoodMealEntry>? meals,
    List<DailyFoodRecord>? history,
    DateTime? lastSeenAt,
    bool? profileSkipped,
  }) => FoodState(
    day: day ?? this.day,
    totalCalories: totalCalories ?? this.totalCalories,
    meals: meals ?? this.meals,
    history: history ?? this.history,
    lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    profileSkipped: profileSkipped ?? this.profileSkipped,
  );
}

/// ผลตรวจช่องตัวเลขของ S-3
enum FoodFieldStatus { empty, valid, invalid }

/// ผลตรวจฟอร์ม S-3 ทั้งหน้า
class FoodProfileValidation {
  const FoodProfileValidation({
    required this.age,
    required this.weight,
    required this.height,
    required this.hasGender,
  });

  final FoodFieldStatus age;
  final FoodFieldStatus weight;
  final FoodFieldStatus height;
  final bool hasGender;

  /// AC-4, EC-5 — ช่องว่างไม่แสดง error
  bool get showAgeError => age == FoodFieldStatus.invalid;

  /// ui-spec §3 S-3: ต้องครบทั้ง 4 ค่าและถูกต้อง (Q-15)
  bool get canSave =>
      age == FoodFieldStatus.valid &&
      weight == FoodFieldStatus.valid &&
      height == FoodFieldStatus.valid &&
      hasGender;
}

=== จบ app/lib/features/food/food_models.dart ===

=== app/lib/features/food/food_nutrition_parser.dart ===
/// "AI Parsing" ของเมนูอาหาร (AC-1, AC-2, EC-1)
///
/// Q-17 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน): ไม่มี AI / ไม่ต่อเน็ต — ตัวที่ใช้จริงคือ
/// [LocalMenuNutritionParser] เทียบชื่อเมนูกับตารางในเครื่อง (food_menu_table.dart)
/// แยก [FoodNutritionParser] เป็น interface ไว้ต่อ AI จริงภายหลัง และให้ QA สลับตัวปลอมได้
library;

import 'dart:convert';

import 'food_menu_table.dart';

/// ประมวลผลข้อความเมนู → JSON โภชนาการ (AC-1)
///
/// คืนสตริง JSON เช่น `{"calories": 400, "high_sodium": true, "high_sugar": false}`
/// `calories` อาจเป็นช่วง `[min, max]` (AC-2 — FoodLogic เลือก Median)
/// throw [FoodParseException] เมื่อประมวลผลไม่ได้ / ออฟไลน์ (EC-1)
/// ผู้เรียก (FoodController) จำกัดเวลาด้วย AI_PARSING_TIMEOUT
abstract class FoodNutritionParser {
  Future<String> parse(String text);
}

/// ประมวลผลไม่สำเร็จ / ออฟไลน์ (EC-1)
class FoodParseException implements Exception {
  const FoodParseException(this.message);
  final String message;
  @override
  String toString() => 'FoodParseException: $message';
}

/// ตัวประมวลผลในเครื่องจากตารางเมนู (ไม่มี network)
///
/// สำหรับ QA:
/// - [offline] = true → throw [FoodParseException] ทุกครั้ง (จำลองเน็ตหลุด EC-1)
/// - [latency] — หน่วงก่อนตอบ (เกิน AI_PARSING_TIMEOUT 3 วินาที = failure ตาม AC-1)
/// - [menu] — ใช้ตารางอื่นแทน [kFoodMenuTable]
/// flag แก้ระหว่างเทสต์ได้
class LocalMenuNutritionParser implements FoodNutritionParser {
  LocalMenuNutritionParser({
    this.offline = false,
    this.latency = Duration.zero,
    this.menu = kFoodMenuTable,
  });

  bool offline;
  Duration latency;
  List<FoodMenuItem> menu;

  /// จำนวนครั้งที่ถูกเรียก (ตรวจได้ในเทสต์)
  int callCount = 0;

  @override
  Future<String> parse(String text) async {
    callCount++;
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    if (offline) throw const FoodParseException('offline');
    return jsonEncode(nutritionJsonFor(text, menu: menu));
  }

  /// ผลแบบ synchronous (pure) — throw [FoodParseException] ถ้าไม่เจอเมนูในตาราง
  static Map<String, dynamic> nutritionJsonFor(
    String text, {
    List<FoodMenuItem> menu = kFoodMenuTable,
  }) {
    final matches = FoodMenuMatcher.match(text, menu: menu);
    if (matches.isEmpty) throw const FoodParseException('menu not found');
    var min = 0;
    var max = 0;
    for (final m in matches) {
      min += m.minKcal;
      max += m.maxKcal;
    }
    return {
      // ผลรวมเป็นช่วงเมื่อมีเมนูใดเป็นช่วง → FoodLogic ใช้ Median (AC-2)
      'calories': min == max ? min : [min, max],
      'high_sodium': matches.any((m) => m.item.highSodium),
      'high_sugar': matches.any((m) => m.item.highSugar),
    };
  }
}

=== จบ app/lib/features/food/food_nutrition_parser.dart ===

=== app/lib/features/food/food_profile_source.dart ===
/// แหล่งโปรไฟล์สุขภาพของ food — ใช้โปรไฟล์ของ signup (UserProfile / AuthRepository)
///
/// Q-13 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน): ใช้โปรไฟล์จาก signup S-6 ถ้ามีอยู่แล้ว
/// ไม่ต้องแสดง S-3 · แสดง S-3 เฉพาะตอนยังไม่มีโปรไฟล์ · S-3 บันทึกกลับเข้าโปรไฟล์ของ signup
/// (ไม่สร้างระบบโปรไฟล์ใหม่)
library;

import '../signup/signup_controller.dart';
import '../signup/signup_models.dart';
import '../signup/signup_rules.dart';

/// ค่าจากฟอร์ม S-3 ที่ผ่านการตรวจแล้ว
class FoodProfileInput {
  const FoodProfileInput({
    required this.age,
    required this.gender,
    required this.weightKg,
    required this.heightCm,
  });

  final int age;
  final SignupGender gender;
  final double weightKg;
  final double heightCm;
}

abstract class FoodProfileSource {
  /// โปรไฟล์ปัจจุบัน — null = ยังไม่มีโปรไฟล์
  Future<UserProfile?> load();

  /// บันทึกค่าจาก S-3 — คืนโปรไฟล์ที่บันทึกแล้ว หรือ null ถ้าไม่สำเร็จ
  Future<UserProfile?> save(FoodProfileInput input);
}

/// โปรไฟล์จาก [SignupController] (session ที่เข้าสู่ระบบอยู่) — ใช้ในแอปจริง
class SignupFoodProfileSource implements FoodProfileSource {
  SignupFoodProfileSource(this._signup);

  final SignupController _signup;

  @override
  Future<UserProfile?> load() async {
    if (!_signup.isLoaded) await _signup.load();
    return _signup.session?.profile;
  }

  @override
  Future<UserProfile?> save(FoodProfileInput input) async {
    final existing = _signup.session?.profile;
    // คงชื่อที่แสดง / เป้าหมายสุขภาพเดิมของ signup — food แก้เฉพาะอายุ เพศ น้ำหนัก ส่วนสูง
    final outcome = await _signup.saveProfile(
      displayName: existing == null || existing.displayNameFromEmail
          ? ''
          : existing.displayName,
      age: input.age.toString(),
      gender: input.gender,
      weight: input.weightKg.toString(),
      height: input.heightCm.toString(),
      healthGoal: existing?.healthGoal ?? SignupRules.defaultHealthGoal,
    );
    if (outcome != SaveProfileOutcome.success) return null;
    return _signup.session?.profile;
  }
}

/// โปรไฟล์ในหน่วยความจำ — ใช้ในเทสต์ และเมื่อแอปไม่มี signup (PetPalApp ไม่มี signupController)
///
/// สำหรับ QA: [profile] ค่าเริ่มต้น (null = ยังไม่มีโปรไฟล์ → S-3), [failSave] = true →
/// บันทึกไม่สำเร็จ, [latency] หน่วงทุกการเรียก
// ASSUMPTION: กรณีไม่มี signup (โหมดเดิมของเทสต์ water/steps) โปรไฟล์ไม่ถูกเก็บลงเครื่อง
// — แอปจริงผ่าน SignupGate เสมอจึงใช้ SignupFoodProfileSource
class InMemoryFoodProfileSource implements FoodProfileSource {
  InMemoryFoodProfileSource({
    this.profile,
    this.failSave = false,
    this.latency = Duration.zero,
  });

  UserProfile? profile;
  bool failSave;
  Duration latency;
  int saveCount = 0;

  @override
  Future<UserProfile?> load() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    return profile;
  }

  @override
  Future<UserProfile?> save(FoodProfileInput input) async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    if (failSave) return null;
    saveCount++;
    final existing = profile;
    return profile = UserProfile(
      displayName: existing?.displayName ?? '',
      displayNameFromEmail: existing?.displayNameFromEmail ?? false,
      age: input.age,
      gender: input.gender,
      weightKg: input.weightKg,
      heightCm: input.heightCm,
      healthGoal: existing?.healthGoal ?? SignupRules.defaultHealthGoal,
    );
  }
}

=== จบ app/lib/features/food/food_profile_source.dart ===

=== app/lib/features/food/food_repository.dart ===
/// การเก็บข้อมูล food ในเครื่อง
///
/// requirements §6 ระบุ "Database" แต่ MVP ไม่มี network/server — เก็บใน
/// shared_preferences เท่านั้น (ข้อมูลไม่ออกนอกเครื่อง)
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'food_models.dart';

/// ชื่อ key ใน shared_preferences
class FoodStorageKeys {
  FoodStorageKeys._();

  /// รอบวันปัจจุบัน YYYY-MM-DD (AC-3 `date`)
  static const String currentDay = 'food_current_day';

  /// `total_calories` ของรอบวันปัจจุบัน
  static const String totalCalories = 'food_total_calories';

  /// Log มื้อของรอบวันปัจจุบัน (JSON list ของ FoodMealEntry)
  static const String mealsLog = 'food_meals_log';

  /// ประวัติรายวัน (JSON list ของ DailyFoodRecord) ไม่เกิน HISTORY_RETENTION_DAYS
  static const String historyLog = 'food_history_log';
  static const String lastSeenAt = 'food_last_seen_at';

  /// ผู้ใช้กด「ข้ามไปก่อน」(US-3)
  static const String profileSkipped = 'food_profile_skipped';

  static const List<String> all = [
    currentDay,
    totalCalories,
    mealsLog,
    historyLog,
    lastSeenAt,
    profileSkipped,
  ];
}

class FoodStorageException implements Exception {
  const FoodStorageException(this.message);
  final String message;
  @override
  String toString() => 'FoodStorageException: $message';
}

/// interface โหลด/บันทึก — แยกไว้ให้ QA สลับเป็นตัวปลอมได้
abstract class FoodRepository {
  Future<FoodState> load();

  /// throw ถ้าบันทึกไม่สำเร็จ
  Future<void> save(FoodState state);
}

/// เก็บในหน่วยความจำ (ใช้ทดสอบ) — [failSaves] = true จำลองบันทึกไม่สำเร็จ
class InMemoryFoodRepository implements FoodRepository {
  InMemoryFoodRepository([FoodState initial = FoodState.initial])
    : _state = initial;

  FoodState _state;
  bool failSaves = false;
  int saveCount = 0;

  FoodState get stored => _state;

  @override
  Future<FoodState> load() async => _state;

  @override
  Future<void> save(FoodState state) async {
    if (failSaves) throw const FoodStorageException('simulated save failure');
    saveCount++;
    _state = state;
  }
}

/// เก็บด้วย shared_preferences
class SharedPrefsFoodRepository implements FoodRepository {
  SharedPrefsFoodRepository([Future<SharedPreferences>? prefs])
    : _prefs = prefs ?? SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefs;

  @override
  Future<FoodState> load() async {
    final SharedPreferences prefs;
    try {
      prefs = await _prefs;
    } catch (_) {
      // ASSUMPTION: อ่านข้อมูลในเครื่องไม่ได้ → เริ่มเป็นค่าว่าง แอปไม่ล่ม (แนวเดียวกับ water/steps)
      return FoodState.initial;
    }
    // ASSUMPTION: คีย์ที่เสีย/ผิดชนิด → ใช้ค่าว่างเฉพาะคีย์นั้น (แนวเดียวกับ water/steps)
    final total = _read<int>(prefs, FoodStorageKeys.totalCalories) ?? 0;
    final lastSeen = _read<String>(prefs, FoodStorageKeys.lastSeenAt);
    return FoodState(
      day: parseFoodDateKey(_read<String>(prefs, FoodStorageKeys.currentDay)),
      totalCalories: total < 0 ? 0 : total,
      meals: _decodeList(
        _read<String>(prefs, FoodStorageKeys.mealsLog),
        FoodMealEntry.fromJson,
      ),
      history: _decodeList(
        _read<String>(prefs, FoodStorageKeys.historyLog),
        DailyFoodRecord.fromJson,
      )..sort((a, b) => a.date.compareTo(b.date)),
      lastSeenAt: lastSeen == null ? null : DateTime.tryParse(lastSeen),
      profileSkipped:
          _read<bool>(prefs, FoodStorageKeys.profileSkipped) ?? false,
    );
  }

  @override
  Future<void> save(FoodState state) async {
    final SharedPreferences prefs;
    try {
      prefs = await _prefs;
    } catch (e) {
      throw FoodStorageException('cannot open storage: $e');
    }
    final results = <bool>[
      state.day == null
          ? await prefs.remove(FoodStorageKeys.currentDay)
          : await prefs.setString(
              FoodStorageKeys.currentDay,
              formatFoodDateKey(state.day!),
            ),
      await prefs.setInt(FoodStorageKeys.totalCalories, state.totalCalories),
      await prefs.setString(
        FoodStorageKeys.mealsLog,
        jsonEncode([for (final m in state.meals) m.toJson()]),
      ),
      await prefs.setString(
        FoodStorageKeys.historyLog,
        jsonEncode([for (final r in state.history) r.toJson()]),
      ),
      state.lastSeenAt == null
          ? await prefs.remove(FoodStorageKeys.lastSeenAt)
          : await prefs.setString(
              FoodStorageKeys.lastSeenAt,
              state.lastSeenAt!.toIso8601String(),
            ),
      await prefs.setBool(FoodStorageKeys.profileSkipped, state.profileSkipped),
    ];
    if (results.contains(false)) {
      throw const FoodStorageException('shared_preferences write failed');
    }
  }

  static T? _read<T>(SharedPreferences prefs, String key) {
    try {
      final v = prefs.get(key);
      return v is T ? v : null;
    } catch (_) {
      return null;
    }
  }

  static List<T> _decodeList<T>(
    String? raw,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (raw == null || raw.isEmpty) return <T>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return <T>[];
      final out = <T>[];
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          try {
            out.add(fromJson(item));
          } catch (_) {
            // ข้ามรายการที่เสีย เก็บรายการที่ยังอ่านได้
          }
        }
      }
      return out;
    } catch (_) {
      return <T>[];
    }
  }
}

=== จบ app/lib/features/food/food_repository.dart ===

=== app/lib/features/food/food_rules.dart ===
/// ค่าคงที่กติกาเกมของฟีเจอร์ food (บันทึกการให้อาหารสัตว์เลี้ยงและโภชนาการ)
///
/// ตัวเลขกติกาทุกตัวมาจาก docs/food/game-rules.md §1 (และ AC / Base Target Reference
/// Table ใน requirements.md §3) · ขนาด/ระยะของหน้าจอมาจาก docs/food/ui-spec.md §1.3
/// ข้อความบนจอมาจาก docs/food/ux-flow.md §2, §4 (ตรงตัว) / ui-spec §2 ("เสนอ — รอยืนยัน")
/// ค่าที่เอกสารไม่ได้กำหนดจะมีคอมเมนต์ ASSUMPTION กำกับ
///
/// ตารางเมนูอาหาร (kcal ต่อเมนู) แยกอยู่ที่ food_menu_table.dart — เป็นข้อมูลโภชนาการ
/// ไม่ใช่ตัวเลขกติกาเกม (Q-17 DECIDED owner ชั่วคราว)
class FoodRules {
  FoodRules._();

  // ---------------------------------------------------------------------------
  // game-rules.md §1 ค่าหลัก
  // ---------------------------------------------------------------------------

  /// AI_PARSING_TIMEOUT — รอผลประมวลผลเมนูได้นานสุด (วินาที) (AC-1)
  /// เกินเวลานี้ถือเป็น AI Parsing Failure → ฟอร์มกรอกแคลอรี่เอง (EC-1)
  static const int aiParsingTimeoutSeconds = 3;

  /// DAILY_RESET_HOUR — ตัดรอบวันใหม่ 05:00 น. (AC-3, US-5)
  // ASSUMPTION: ใช้เวลาท้องถิ่นของเครื่อง (ถือว่าเครื่องตั้งเขต ICT) แบบเดียวกับ water/steps
  // — MVP ไม่มี network/server time
  static const int dailyResetHour = 5;

  /// DAILY_RESET_HOUR — ส่วนนาทีของ 05:00 น.
  static const int dailyResetMinute = 0;

  /// AGE_MIN / AGE_MAX — อายุจำนวนเต็ม รวมขอบทั้งสองด้าน (AC-4, EC-5)
  static const int ageMin = 1;
  static const int ageMax = 120;

  // Base Target Reference Table (requirements §3, game-rules §1) — kcal
  /// MALE_BASE_TARGET_10_12 / FEMALE_BASE_TARGET_10_12
  static const int maleBaseTarget10to12 = 1700;
  static const int femaleBaseTarget10to12 = 1600;

  /// MALE_BASE_TARGET_13_15 / FEMALE_BASE_TARGET_13_15 (Growth Spurt)
  static const int maleBaseTarget13to15 = 2100;
  static const int femaleBaseTarget13to15 = 1800;

  /// MALE_BASE_TARGET_16_18 / FEMALE_BASE_TARGET_16_18
  static const int maleBaseTarget16to18 = 2300;
  static const int femaleBaseTarget16to18 = 1850;

  /// MALE_BASE_TARGET_19_50 / FEMALE_BASE_TARGET_19_50 (ผู้ใหญ่) — AC-5: ชาย 25 ปี = 2,000
  static const int maleBaseTarget19to50 = 2000;
  static const int femaleBaseTarget19to50 = 1600;

  /// MALE_BASE_TARGET_51_UP / FEMALE_BASE_TARGET_51_UP
  static const int maleBaseTarget51up = 1800;
  static const int femaleBaseTarget51up = 1400;

  /// FALLBACK_BASE_TARGET_AGE_1_9_MALE / _FEMALE — อายุ 1–9 ปีใช้ค่ากลุ่ม 10–12
  /// (game-rules §1, §5 กติกาชั่วคราวของ Design)
  static const int fallbackBaseTargetAge1to9Male = 1700;
  static const int fallbackBaseTargetAge1to9Female = 1600;

  /// ขอบล่างของแต่ละช่วงอายุในตาราง Base Target (รวมขอบ) — requirements §3
  /// 1–9 (fallback) · 10–12 · 13–15 · 16–18 · 19–50 · 51 ขึ้นไป
  static const int ageBand10to12Min = 10;
  static const int ageBand13to15Min = 13;
  static const int ageBand16to18Min = 16;
  static const int ageBand19to50Min = 19;
  static const int ageBand51upMin = 51;

  /// BMI_UNDERWEIGHT_THRESHOLD — BMI "ต่ำกว่า" ค่านี้ = ผอม (AC-6)
  static const double bmiUnderweightThreshold = 18.5;

  /// BMI_UNDERWEIGHT_BONUS — บวกเพิ่มจาก Base Target เมื่อผอม (AC-6)
  static const int bmiUnderweightBonus = 400;

  /// BMI_OVERWEIGHT_THRESHOLD — BMI "ตั้งแต่" ค่านี้ = อ้วน/น้ำหนักเกิน (AC-7)
  static const double bmiOverweightThreshold = 23.0;

  /// BMI_OVERWEIGHT_PENALTY — หักออกจาก Base Target เมื่อน้ำหนักเกิน (AC-7)
  static const int bmiOverweightPenalty = 400;

  /// OVER_LIMIT_THRESHOLD — เกินเป้า "มากกว่า" ค่านี้จึงเข้าสถานะเกินเป้า (AC-9, AC-10, EC-3)
  static const int overLimitThreshold = 100;

  /// FALLBACK_DEFAULT_CALORIES — ฟอร์มกรอกเองแต่ปล่อยว่าง (EC-1)
  static const int fallbackDefaultCalories = 300;

  /// EATING_ANIMATION_DURATION — ท่า EATING ชั่วคราว (วินาที) (game-rules §2, Brief #3)
  static const int eatingAnimationSeconds = 2;

  /// ระยะท่า OVER_LIMIT_FEEDING ก่อนกลับเป็น OVER_LIMIT (วินาที)
  // ASSUMPTION: ค่าชั่วคราว รอคำตอบ — game-rules ไม่กำหนด (ui-spec Q-3) ใช้ค่าเดียวกับ
  // EATING_ANIMATION_DURATION ตามที่ ui-spec เลือกไว้ชั่วคราว
  static const int overLimitFeedingSeconds = eatingAnimationSeconds;

  /// TOAST_DURATION — Toast ค้าง (วินาที) (AC-12)
  static const int toastSeconds = 5;

  /// TOAST_ANCHOR_OFFSET — ระยะขอบล่าง Toast ↔ ขอบบนกล่องสัตว์เลี้ยง (px) (AC-12)
  static const double toastAnchorOffset = 12;

  /// HISTORY_RETENTION_DAYS — จำนวนวันประวัติย้อนหลัง (US-1, US-5)
  // ASSUMPTION: 7 วันนับรวมรอบวันปัจจุบัน (วันนี้ + 6 วันก่อนหน้า) ให้ตรงกับโครง
  // Day 0–Day 6 ของฟีเจอร์ 7day — ประวัติที่เก่ากว่านั้นถูกลบตอนตัดรอบวัน
  static const int historyRetentionDays = 7;

  // ---------------------------------------------------------------------------
  // ui-spec §1.3 ขนาด / ระยะ (ไม่ใช่กติกาเกม — ค่าหน้าตา)
  // ---------------------------------------------------------------------------

  /// ขนาดสัตว์เลี้ยง (ui-spec §1.3 = PetCharacter default)
  static const double petSize = 160;

  /// ความสูงช่อง Toast คงที่ (ui-spec §1.3)
  static const double toastSlotHeight = 48;

  /// ความสูง "ขั้นต่ำ" ของช่องพลังงาน ใช้ร่วมกันระหว่างหลอดพลังงานและ CTA Banner
  /// (ui-spec §1.3 = 88, AC-8) — ที่ textScaler 1.0 ทั้งสองแบบพอดีใน 88 จึงสูง 88 เท่ากัน
  /// (ไม่มี layout shift) ตอนใช้จริงค่านี้ถูกคูณด้วย textScaler ของเครื่อง และช่องโตเกินได้
  /// เมื่อเนื้อหาสูงกว่านี้ (ตัวเลขยาว / ตัวอักษรใหญ่) เพื่อไม่ให้ overflow
  // DECIDED (owner ชั่วคราว, รอบแก้บั๊ก): ห้ามล็อกความสูง 88 คงที่ — ใช้เป็น min height แทน
  static const double energySlotMinHeight = 88;

  // ---------------------------------------------------------------------------
  // ค่าที่เอกสารไม่ได้กำหนด
  // ---------------------------------------------------------------------------

  // ASSUMPTION: ค่าชั่วคราว รอคำตอบ — ช่องแคลอรี่สำรองรับเลขได้ไม่เกิน 5 หลัก (≤ 99,999 kcal)
  // กัน int ล้น/ค่าเพี้ยน เอกสารไม่กำหนดค่าสูงสุด
  static const int manualCaloriesMaxDigits = 5;

  // ASSUMPTION: ค่าชั่วคราว รอคำตอบ — จำนวนที่ตามหลังชื่อเมนู (เช่น "ข้าวมันไก่ 2 จาน")
  // คูณแคลอรี่ได้สูงสุด 2 หลัก (1–99) ไม่มีในเอกสาร (Q-17 ใช้ตารางเมนูในเครื่องแทน AI)
  static const int menuQuantityMaxDigits = 2;

  // ---------------------------------------------------------------------------
  // ข้อความบนหน้าจอ (ux-flow.md §2, §4 ตรงตัว / ui-spec "เสนอ — รอยืนยัน")
  // ---------------------------------------------------------------------------

  static const String kcalUnit = 'kcal';
  static const String backButtonText =
      'ย้อนกลับ'; // ui-spec §2.2 (เท่า steps/signup)

  // ทางเข้าจากหน้า water (ui-spec §2.0)
  // ASSUMPTION: ui-spec Q-1 (เสนอ — รอยืนยัน)
  static const String entryTooltip = 'โภชนาการ';

  // S-1
  // ASSUMPTION: ui-spec Q-2 (เสนอ — รอยืนยัน)
  static const String dashboardTitle = 'โภชนาการ';
  static const String addMealButtonText = 'บันทึกมื้ออาหาร';
  static const String fullBadgeText = 'อิ่มแล้ว';
  static const String overLimitToastText = 'พอเถอะน้าคนดี';
  static const String profileCtaText =
      'ตั้งค่าโปรไฟล์สุขภาพเพื่อรับเป้าหมายแคลอรี่ที่แม่นยำ';

  // S-2
  // ASSUMPTION: ui-spec Q-2 (เสนอ — ยืมข้อความปุ่ม S-1)
  static const String mealTitle = addMealButtonText;
  static const String mealInputHint =
      'พิมพ์เมนูอาหารที่คุณทานวันนี้ เช่น ข้าวมันไก่ 1 จาน...';
  static const String manualCalorieHint = 'ระบุแคลอรี่ (kcal)';
  // ASSUMPTION: ui-spec Q-10 (เสนอ — รอยืนยัน)
  static const String manualCalorieHelper =
      'ไม่สามารถประมวลผลเมนูอัตโนมัติได้ กรุณาระบุแคลอรี่เอง';
  static const String mealSubmitText = 'บันทึกข้อมูล';

  // S-3
  // ASSUMPTION: ui-spec Q-2 (เสนอ — รอยืนยัน)
  static const String profileTitle = 'ตั้งค่าโปรไฟล์สุขภาพ';
  static const String ageHint = 'ระบุอายุ (ปี)';
  // ASSUMPTION: ui-spec Q-15 (เสนอ — ข้อความเดียวกับ signup_gender_label)
  static const String genderLabel = 'เพศ';
  static const String genderMaleText = 'ชาย';
  static const String genderFemaleText = 'หญิง';
  static const String weightHint = 'น้ำหนัก (kg)';
  static const String heightHint = 'ส่วนสูง (cm)';
  static const String profileSaveText = 'บันทึกและคำนวณเป้าหมาย';
  static const String profileSkipText = 'ข้ามไปก่อน';

  /// ux-flow §4 S-3 Error — ตัวเลขมาจาก AGE_MIN / AGE_MAX
  static String get ageError =>
      'กรุณากรอกอายุเป็นจำนวนเต็มระหว่าง $ageMin - $ageMax ปี';
}

=== จบ app/lib/features/food/food_rules.dart ===

=== app/lib/features/food/screens/food_dashboard_screen.dart ===
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:petpal_health/shared/pet/pet.dart';

import '../food_controller.dart';
import '../food_logic.dart';
import '../food_rules.dart';
import '../widgets/food_profile_cta_banner.dart';
import '../widgets/food_shared_min_height_box.dart';
import '../widgets/food_toast.dart';
import 'food_meal_screen.dart';
import 'food_profile_screen.dart';

/// S-1 หน้าหลักแดชบอร์ดสัตว์เลี้ยงและโภชนาการ — ux-flow §2 S-1, ui-spec §2.1
/// AC-8, AC-9, AC-10, AC-11, AC-12, EC-2, EC-3, EC-4
class FoodDashboardScreen extends StatefulWidget {
  const FoodDashboardScreen({
    super.key,
    required this.controller,
    this.animatePet,
  });

  final FoodController controller;

  /// `PetCharacter.animate` — null = [kPetAnimateByDefault] (แอปจริง animate,
  /// ระหว่าง flutter test เป็นภาพนิ่ง)
  final bool? animatePet;

  @override
  State<FoodDashboardScreen> createState() => _FoodDashboardScreenState();
}

class _FoodDashboardScreenState extends State<FoodDashboardScreen>
    with WidgetsBindingObserver {
  // PetCharacter มีตัวตนคงที่ข้ามการเปลี่ยนสถานะ (BUG-PET-1) — key ฟีเจอร์อยู่บน KeyedSubtree
  final GlobalKey _petKey = GlobalKey(debugLabel: 'food_pet');

  // ASSUMPTION: ตรวจรอบวันทุก 1 วินาทีขณะเปิดหน้าค้าง (game-rules §4 Foreground Crossing)
  // เอกสารไม่กำหนดความถี่ — แบบเดียวกับ steps
  static const Duration _dayCheckInterval = Duration(seconds: 1);

  Timer? _dayTimer;
  bool _profilePrompted = false;

  FoodController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.addListener(_maybePromptProfile);
    if (!_controller.isLoaded) {
      _controller.load();
    } else {
      _controller.refreshDay();
      _controller.refreshProfile();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _maybePromptProfile(),
      );
    }
    _dayTimer = Timer.periodic(
      _dayCheckInterval,
      (_) => _controller.refreshDay(),
    );
  }

  @override
  void dispose() {
    _dayTimer?.cancel();
    _controller.removeListener(_maybePromptProfile);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _controller.refreshDay();
  }

  /// Q-13 DECIDED: ยังไม่มีโปรไฟล์ (และยังไม่เคยกดข้าม) → เปิด S-3 ให้ 1 ครั้งต่อการเข้าหน้า
  void _maybePromptProfile() {
    if (_profilePrompted || !mounted || !_controller.needsProfileSetup) return;
    _profilePrompted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _openProfile();
    });
  }

  void _openMeal() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FoodMealScreen(controller: _controller),
      ),
    );
  }

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FoodProfileScreen(controller: _controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text(
            FoodRules.dashboardTitle,
            key: Key('food_header_text'),
          ),
        ),
        body: !_controller.isLoaded
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final petState = _controller.petState;
    final toast = _controller.toastMessage;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    // #3 ช่อง Toast สูงคงที่ — Toast ไม่ดันสัตว์เลี้ยง (AC-12)
                    SizedBox(
                      key: const Key('food_toast_slot'),
                      height: FoodRules.toastSlotHeight,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: toast == null
                            ? const SizedBox.shrink()
                            // ValueKey ตาม serial: ข้อความใหม่แทนที่อันเดิมทันที (EC-2)
                            : KeyedSubtree(
                                key: ValueKey(
                                  'food_toast_${_controller.toastSerial}',
                                ),
                                child: FoodToast(message: toast),
                              ),
                      ),
                    ),
                    // #4 ระยะ anchor = TOAST_ANCHOR_OFFSET (AC-12)
                    const SizedBox(height: FoodRules.toastAnchorOffset),
                    // #5 สัตว์เลี้ยง — OQ-1 DECIDED: PetCharacter แทน Lottie/PNG
                    // ไม่ส่ง cheerTrigger (ท่ากินคือ reaction — ui-spec §4)
                    Center(
                      child: KeyedSubtree(
                        key: ValueKey('food_pet_image_${petState.keyName}'),
                        child: PetCharacter(
                          key: _petKey,
                          pose: _controller.petPose,
                          size: FoodRules.petSize,
                          animate: widget.animatePet ?? kPetAnimateByDefault,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // #7 ป้าย「อิ่มแล้ว」 — Q-5 DECIDED: ขึ้นพร้อมหลอดแดงทันที
                    Center(
                      child: Visibility(
                        key: const Key('food_full_badge_visibility'),
                        visible: _controller.showsFullBadge,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: Container(
                          key: const Key('food_full_badge'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            FoodRules.fullBadgeText,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: scheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // #9 ช่องพลังงาน — หลอดหรือ CTA Banner (AC-8, EC-4)
                    // ไม่ล็อกความสูงตายตัว (แก้บั๊ก overflow บนจอ 360 dp): ช่องสูงอย่างน้อย
                    // max(88, ความสูงที่หลอดต้องใช้, ความสูงที่ CTA ต้องใช้) ที่ความกว้าง/ฟอนต์/
                    // textScaler จริง → สองแบบสูงเท่ากันเสมอ (ไม่มี layout shift ตอนสลับ) และ
                    // ถ้าเนื้อหาจริงสูงกว่าที่วัดได้ ช่องก็โตตามได้ ไม่ overflow
                    FoodSharedMinHeightBox(
                      key: const Key('food_energy_slot'),
                      minHeightFor: _energySlotMinHeightFor(context),
                      child: _controller.showsProfileCta
                          ? _buildCtaBanner(context)
                          : _buildEnergyBlock(context),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      key: const Key('food_add_meal_button'),
                      onPressed: _openMeal,
                      icon: const Icon(Icons.restaurant, size: 24),
                      label: const Text(FoodRules.addMealButtonText),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ขนาดภายในช่องพลังงาน (ui-spec §1.3 / §2.1 #9a, #9b) — ใช้ทั้งตอนสร้าง widget และตอนวัด
  // ความสูงขั้นต่ำร่วม เพื่อให้สองที่ตรงกันเสมอ
  static const double _barHeight = 20;
  static const double _barTextGap = 8;
  static const double _ctaPadH = FoodProfileCtaBanner.padH;
  static const double _ctaPadV = FoodProfileCtaBanner.padV;
  static const double _ctaIconGap = FoodProfileCtaBanner.iconGap;
  static const double _ctaIconSize = FoodProfileCtaBanner.iconSize;

  // ASSUMPTION: ตอนแสดง CTA (ยังไม่มีเป้า) จองที่ให้ข้อความหลอดด้วยเป้าตัวแทน 4 หลัก
  // "9,999" ซึ่งกว้างไม่น้อยกว่าเป้าจริงทุกค่า (ตาราง Base Target + BMI สูงสุด 2,700) — เพื่อให้
  // ตอนตั้งโปรไฟล์แล้วสลับเป็นหลอดไม่เกิด layout shift · เป็นค่าหน้าตา ไม่ใช่ตัวเลขกติกา
  static const int _placeholderTarget = 9999;

  /// ความสูงขั้นต่ำร่วมของช่องพลังงาน = max(88, หลอด, CTA) ที่ความกว้าง [width] — AC-8
  MinHeightForWidth _energySlotMinHeightFor(BuildContext context) {
    final theme = Theme.of(context);
    final base = DefaultTextStyle.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    final locale = Localizations.maybeLocaleOf(context);
    final barText =
        _controller.calorieText ??
        FoodLogic.calorieText(_controller.totalCalories, _placeholderTarget);
    final ctaTotal = _controller.ctaTotalText;

    double textHeight(
      String text,
      TextStyle? style,
      double maxWidth, {
      int? maxLines,
      TextAlign align = TextAlign.start,
    }) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: base.style.merge(style)),
        textAlign: align,
        textDirection: direction,
        textScaler: scaler,
        maxLines: maxLines,
        ellipsis: maxLines == null ? null : '…',
        locale: locale,
        textHeightBehavior: base.textHeightBehavior,
        textWidthBasis: base.textWidthBasis,
      )..layout(maxWidth: math.max(0, maxWidth));
      final h = painter.height;
      painter.dispose();
      return h;
    }

    return (width) {
      final bar =
          _barHeight +
          _barTextGap +
          textHeight(
            barText,
            theme.textTheme.headlineSmall,
            width,
            align: TextAlign.center,
          );
      final ctaTextWidth = width - _ctaPadH * 2 - _ctaIconGap - _ctaIconSize;
      final ctaTexts =
          textHeight(
            FoodRules.profileCtaText,
            theme.textTheme.bodyMedium,
            ctaTextWidth,
            maxLines: 2,
          ) +
          textHeight(
            // BUG-FOOD-2 (D-5): ยอดรวมไม่จำกัดบรรทัด — วัดแบบเดียวกับ widget
            ctaTotal,
            theme.textTheme.titleMedium,
            ctaTextWidth,
          );
      final cta = _ctaPadV * 2 + math.max(ctaTexts, _ctaIconSize);
      return math.max(FoodRules.energySlotMinHeight, math.max(bar, cta));
    };
  }

  /// #9a หลอดพลังงาน (มีโปรไฟล์) — AC-9 / AC-10
  Widget _buildEnergyBlock(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      key: const Key('food_energy_block'),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            key: const Key('food_energy_bar'),
            value: _controller.energyFraction,
            minHeight: _barHeight,
            color: _controller.isOverLimit ? scheme.error : scheme.primary,
          ),
        ),
        const SizedBox(height: _barTextGap),
        Text(
          _controller.calorieText ?? '',
          key: const Key('food_calorie_text'),
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
      ],
    );
  }

  /// #9b CTA Banner (ข้ามโปรไฟล์ / ไม่มีเป้าหมาย) — กว้าง×สูงเต็มช่องพลังงาน (AC-8)
  /// กว้างเต็มเพราะ Column หน้า S-1 เป็น stretch · สูงอย่างน้อยเท่าขั้นต่ำของช่อง
  /// (min height จาก ConstrainedBox ของช่อง) และโตตามเนื้อหาได้ — แทน SizedBox.expand
  /// ที่ใช้ไม่ได้เมื่อช่องไม่มีความสูงตายตัว
  Widget _buildCtaBanner(BuildContext context) => FoodProfileCtaBanner(
    totalText: _controller.ctaTotalText,
    onTap: _openProfile,
  );

}

=== จบ app/lib/features/food/screens/food_dashboard_screen.dart ===

=== app/lib/features/food/screens/food_meal_screen.dart ===
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../signup/widgets/signup_widgets.dart'
    show SignupButtonLabel, SignupWarningText;
import '../food_controller.dart';
import '../food_rules.dart';

/// S-2 หน้าจอเพิ่มเมนูอาหาร — ux-flow §2 S-2, ui-spec §2.2
/// AC-1, AC-2 (ผ่าน FoodController / FoodLogic), AC-3, EC-1
class FoodMealScreen extends StatefulWidget {
  const FoodMealScreen({super.key, required this.controller});

  final FoodController controller;

  @override
  State<FoodMealScreen> createState() => _FoodMealScreenState();
}

class _FoodMealScreenState extends State<FoodMealScreen> {
  final TextEditingController _menu = TextEditingController();
  final TextEditingController _manual = TextEditingController();

  /// S-2 Error / Offline (EC-1) — แสดงช่องกรอกแคลอรี่สำรอง
  bool _fallback = false;

  /// กำลังประมวลผล (ui-spec Q-11)
  bool _loading = false;

  @override
  void dispose() {
    _menu.dispose();
    _manual.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    setState(() => _loading = true);
    // ASSUMPTION: ในสถานะผิดพลาด/ออฟไลน์ กดบันทึก = บันทึกค่าที่กรอกเอง (ว่าง = 300 kcal)
    // ไม่ส่งข้อความเมนูไปประมวลผลซ้ำ (ux-flow S-2 "หรือบันทึกค่า Manual หากออฟไลน์")
    final outcome = _fallback
        ? await widget.controller.submitManual(_manual.text)
        : await widget.controller.submitMeal(_menu.text);
    if (!mounted) return;
    switch (outcome) {
      case MealSubmitOutcome.logged:
        // ux-flow S-2: กลับ S-1 (S-1 แสดงท่ากิน) — ไม่มีข้อความยืนยัน
        Navigator.of(context).pop();
        return;
      case MealSubmitOutcome.parseFailed:
        setState(() {
          _loading = false;
          _fallback = true;
        });
      case MealSubmitOutcome.invalidCalories:
      case MealSubmitOutcome.notReady:
        setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = !_loading;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('food_meal_back_button'),
          icon: const Icon(Icons.arrow_back),
          tooltip: FoodRules.backButtonText,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          FoodRules.mealTitle,
          key: Key('food_meal_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('food_meal_input_field'),
                controller: _menu,
                enabled: enabled,
                minLines: 3,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: FoodRules.mealInputHint,
                ),
              ),
              if (_fallback) ...[
                const SizedBox(height: 16),
                // EC-1: ช่องว่างเปล่า (ไม่เติม 300) — ค่า default ใช้ตอนบันทึก
                TextField(
                  key: const Key('food_manual_calorie_field'),
                  controller: _manual,
                  enabled: enabled,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    // ASSUMPTION: จำกัดจำนวนหลัก (FoodRules.manualCaloriesMaxDigits)
                    LengthLimitingTextInputFormatter(
                      FoodRules.manualCaloriesMaxDigits,
                    ),
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: FoodRules.manualCalorieHint,
                    helper: SignupWarningText(
                      FoodRules.manualCalorieHelper,
                      key: Key('food_manual_calorie_helper_text'),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('food_meal_submit_button'),
                onPressed: enabled ? _submit : null,
                child: SignupButtonLabel(
                  text: FoodRules.mealSubmitText,
                  loading: _loading,
                  indicatorKey: 'food_meal_submit_loading_indicator',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/food/screens/food_meal_screen.dart ===

=== app/lib/features/food/screens/food_profile_screen.dart ===
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../signup/signup_models.dart' show SignupGender;
import '../../signup/widgets/signup_widgets.dart'
    show SignupButtonLabel, SignupWholeNumberInputFormatter;
import '../food_controller.dart';
import '../food_logic.dart';
import '../food_rules.dart';

/// S-3 หน้าจอตั้งค่าโปรไฟล์สุขภาพเบื้องต้น — ux-flow §2 S-3, ui-spec §2.3
/// AC-4, AC-5, AC-6, AC-7 (ผ่าน FoodLogic), EC-5, US-3
///
/// Q-13 DECIDED: บันทึกเข้าโปรไฟล์ของ signup · Q-14 DECIDED: กติกาเดียวกับ signup —
/// อายุรับจำนวนเต็มเท่านั้น (ปฏิเสธการพิมพ์จุด), น้ำหนัก/ส่วนสูงรับทศนิยม
class FoodProfileScreen extends StatefulWidget {
  const FoodProfileScreen({super.key, required this.controller});

  final FoodController controller;

  @override
  State<FoodProfileScreen> createState() => _FoodProfileScreenState();
}

class _FoodProfileScreenState extends State<FoodProfileScreen> {
  late final TextEditingController _age;
  late final TextEditingController _weight;
  late final TextEditingController _height;
  SignupGender? _gender;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // ASSUMPTION: มีโปรไฟล์ signup แต่ไม่ครบ (เช่น เพศไม่ระบุ / ไม่มีน้ำหนัก) แล้วกด CTA →
    // เติมค่าเดิมไว้ในฟอร์ม (แบบ signup S-6) · ไม่มีโปรไฟล์ = ฟอร์มว่าง ไม่เลือกเพศไว้ก่อน
    final p = widget.controller.profile;
    _age = TextEditingController(text: p?.age.toString() ?? '');
    _weight = TextEditingController(text: _fmt(p?.weightKg));
    _height = TextEditingController(text: _fmt(p?.heightCm));
    final g = p?.gender;
    _gender = g == SignupGender.male || g == SignupGender.female ? g : null;
  }

  static String _fmt(double? v) {
    if (v == null) return '';
    return v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
  }

  @override
  void dispose() {
    _age.dispose();
    _weight.dispose();
    _height.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final outcome = await widget.controller.saveProfile(
      age: _age.text,
      gender: _gender,
      weight: _weight.text,
      height: _height.text,
    );
    if (!mounted) return;
    if (outcome == FoodProfileSaveOutcome.saved) {
      Navigator.of(context).pop();
      return;
    }
    // ASSUMPTION: บันทึกไม่สำเร็จ — ux-flow ไม่มีสถานะ error ของ S-3 → อยู่หน้าเดิม ค่าคงเดิม
    // กดบันทึกซ้ำได้ (ไม่แสดงข้อความใหม่)
    setState(() => _saving = false);
  }

  Future<void> _skip() async {
    await widget.controller.skipProfile();
    if (mounted) Navigator.of(context).pop();
  }

  void _onChanged(String _) => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final v = FoodLogic.validateProfile(
      age: _age.text,
      gender: _gender,
      weight: _weight.text,
      height: _height.text,
    );
    final enabled = !_saving;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          FoodRules.profileTitle,
          key: Key('food_profile_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('food_age_field'),
                controller: _age,
                enabled: enabled,
                keyboardType: TextInputType.number,
                // Q-14 DECIDED (owner): กติกาเดียวกับ signup — ปฏิเสธการพิมพ์/วางที่ไม่ใช่
                // เลขล้วน ("20.5" ไม่เข้าช่อง) แทนตัวกรอง [0-9.] ของ ui-spec §2.3 #2
                inputFormatters: [
                  const SignupWholeNumberInputFormatter(),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: _onChanged,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: FoodRules.ageHint,
                  // AC-4, EC-5: ไม่ใช่จำนวนเต็ม 1–120 → error + บล็อกการบันทึก
                  error: v.showAgeError
                      ? Text(
                          FoodRules.ageError,
                          key: const Key('food_age_error_text'),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                FoodRules.genderLabel,
                key: const Key('food_gender_label'),
                style: theme.textTheme.titleMedium,
              ),
              RadioGroup<SignupGender>(
                key: const Key('food_gender_group'),
                groupValue: _gender,
                onChanged: (g) {
                  if (g == null || !enabled) return;
                  setState(() => _gender = g);
                },
                child: Column(
                  children: [
                    RadioListTile<SignupGender>(
                      key: const Key('food_gender_male'),
                      value: SignupGender.male,
                      enabled: enabled,
                      contentPadding: EdgeInsets.zero,
                      title: const Text(FoodRules.genderMaleText),
                    ),
                    RadioListTile<SignupGender>(
                      key: const Key('food_gender_female'),
                      value: SignupGender.female,
                      enabled: enabled,
                      contentPadding: EdgeInsets.zero,
                      title: const Text(FoodRules.genderFemaleText),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('food_weight_field'),
                controller: _weight,
                enabled: enabled,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: _onChanged,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: FoodRules.weightHint,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('food_height_field'),
                controller: _height,
                enabled: enabled,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: _onChanged,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: FoodRules.heightHint,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('food_profile_save_button'),
                onPressed: enabled && v.canSave ? _save : null,
                // ASSUMPTION: ระหว่างบันทึกแสดง spinner ในปุ่มแบบ signup (ui-spec ไม่ระบุ loading)
                child: SignupButtonLabel(
                  text: FoodRules.profileSaveText,
                  loading: _saving,
                  indicatorKey: 'food_profile_save_loading_indicator',
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  key: const Key('food_profile_skip_button'),
                  // ui-spec §3 S-3: enabled เสมอ
                  onPressed: _skip,
                  child: const Text(FoodRules.profileSkipText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/food/screens/food_profile_screen.dart ===

=== app/lib/features/food/widgets/food_profile_cta_banner.dart ===
import 'package:flutter/material.dart';

import '../food_rules.dart';

/// CTA Banner ชวนตั้งโปรไฟล์ (food ui-spec §2.1 #9b, AC-8, EC-4) — แยกจาก
/// FoodDashboardScreen เพื่อใช้ซ้ำบน S-1 ของ dashboard (owner รอบ 3 ข้อ 5)
/// widget tree / keys / สไตล์ เหมือนเดิมทุกอย่าง (`food_profile_cta_banner`, `food_cta_text`,
/// `food_cta_total_text`)
class FoodProfileCtaBanner extends StatelessWidget {
  const FoodProfileCtaBanner({
    super.key,
    required this.totalText,
    required this.onTap,
  });

  /// ยอดรวมวันนี้ (FoodController.ctaTotalText)
  final String totalText;

  /// เปิด S-3 ตั้งโปรไฟล์
  final VoidCallback onTap;

  static const double padH = 16;
  static const double padV = 8;
  static const double iconGap = 8;
  static const double iconSize = 24;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fg = scheme.onSecondaryContainer;
    return Material(
      color: scheme.secondaryContainer,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        key: const Key('food_profile_cta_banner'),
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padH, vertical: padV),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FoodRules.profileCtaText,
                      key: const Key('food_cta_text'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(color: fg),
                    ),
                    Text(
                      totalText,
                      key: const Key('food_cta_total_text'),
                      // BUG-FOOD-2 (DECIDED D-5): ยอดรวมต้องแสดงครบ ห้ามตัด — ขึ้นบรรทัด
                      // ใหม่ได้ (ช่องโตตาม) · ellipsis ใช้เฉพาะข้อความชวนตาม ui-spec #9b
                      style: theme.textTheme.titleMedium?.copyWith(color: fg),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: iconGap),
              Icon(Icons.chevron_right, size: iconSize, color: fg),
            ],
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/food/widgets/food_profile_cta_banner.dart ===

=== app/lib/features/food/widgets/food_shared_min_height_box.dart ===
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// คำนวณความสูงขั้นต่ำจากความกว้างที่ได้รับจริงตอนจัด layout
typedef MinHeightForWidth = double Function(double width);

/// กล่องที่ให้ลูกสูง "อย่างน้อย" [minHeightFor] (คำนวณจากความกว้างจริง) แล้วโตต่อได้
/// ตามเนื้อหา — ใช้กับช่องพลังงาน S-1 (AC-8) เพื่อให้หลอดพลังงานและ CTA Banner ใช้
/// ความสูงขั้นต่ำร่วมกัน (ค่ามากสุดของทั้งสองแบบ) โดยไม่ต้องล็อกความสูงตายตัว
///
/// ต่างจาก LayoutBuilder ตรงที่รองรับ intrinsic size (หน้า S-1 ครอบด้วย IntrinsicHeight)
class FoodSharedMinHeightBox extends SingleChildRenderObjectWidget {
  const FoodSharedMinHeightBox({
    super.key,
    required this.minHeightFor,
    super.child,
  });

  final MinHeightForWidth minHeightFor;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderFoodSharedMinHeightBox(minHeightFor);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderFoodSharedMinHeightBox renderObject,
  ) {
    renderObject.minHeightFor = minHeightFor;
  }
}

/// RenderObject ของ [FoodSharedMinHeightBox]
class RenderFoodSharedMinHeightBox extends RenderProxyBox {
  RenderFoodSharedMinHeightBox(this._minHeightFor);

  MinHeightForWidth _minHeightFor;
  set minHeightFor(MinHeightForWidth value) {
    if (identical(value, _minHeightFor)) return;
    _minHeightFor = value;
    // closure ใหม่ทุก build (ข้อความ/สไตล์อาจเปลี่ยน) — วัดใหม่เสมอ
    markNeedsLayout();
  }

  BoxConstraints _withMin(BoxConstraints c) {
    final minH = math.max(c.minHeight, _minHeightFor(c.maxWidth));
    return c.copyWith(minHeight: math.min(minH, c.maxHeight));
  }

  @override
  double computeMinIntrinsicHeight(double width) =>
      math.max(_minHeightFor(width), super.computeMinIntrinsicHeight(width));

  @override
  double computeMaxIntrinsicHeight(double width) =>
      math.max(_minHeightFor(width), super.computeMaxIntrinsicHeight(width));

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    final c = _withMin(constraints);
    return child?.getDryLayout(c) ?? c.smallest;
  }

  @override
  void performLayout() {
    final c = _withMin(constraints);
    final child = this.child;
    if (child == null) {
      size = c.smallest;
      return;
    }
    child.layout(c, parentUsesSize: true);
    size = child.size;
  }
}

=== จบ app/lib/features/food/widgets/food_shared_min_height_box.dart ===

=== app/lib/features/food/widgets/food_toast.dart ===
import 'package:flutter/material.dart';

import '../food_rules.dart';

/// Toast ลอยเหนือสัตว์เลี้ยง (ui-spec §2.1.1) — ไม่ใช่ SnackBar เพราะต้องยึดตำแหน่งกับ
/// สัตว์เลี้ยง (AC-12) · สี inverseSurface / onInverseSurface เท่า SnackBar M3
class FoodToast extends StatelessWidget {
  const FoodToast({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Material(
      key: const Key('food_toast'),
      color: scheme.inverseSurface,
      elevation: 6,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          message,
          key: message == FoodRules.overLimitToastText
              ? const Key('food_over_limit_toast')
              : null,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onInverseSurface,
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/food/widgets/food_toast.dart ===

=== app/lib/features/signup/screens/signup_email_screen.dart ===
import 'package:flutter/material.dart';

import '../signup_controller.dart';
import '../signup_logic.dart';
import '../signup_rules.dart';
import '../widgets/signup_widgets.dart';
import 'signup_forgot_password_screen.dart';
import 'signup_gate.dart';

/// S-2 มี 2 โหมด (ui-spec Q-2)
enum SignupEmailMode { signUp, signIn }

/// S-2 หน้าสมัครสมาชิก / เข้าสู่ระบบด้วยอีเมล (ux-flow §2 S-2, ui-spec §2.2)
class SignupEmailScreen extends StatefulWidget {
  const SignupEmailScreen({
    super.key,
    required this.controller,
    this.mode = SignupEmailMode.signUp,
  });

  final SignupController controller;
  final SignupEmailMode mode;

  @override
  State<SignupEmailScreen> createState() => _SignupEmailScreenState();
}

class _SignupEmailScreenState extends State<SignupEmailScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _submitting = false;

  /// AC-2 / EC-5 — หายเมื่อแก้ข้อความในช่องอีเมล (ui-spec Q-4)
  bool _emailInUse = false;

  /// โหมดเข้าสู่ระบบ: อีเมล/รหัสผ่านไม่ตรง — หายเมื่อแก้ช่องใดช่องหนึ่ง
  bool _invalidCredentials = false;

  bool get _isSignUp => widget.mode == SignupEmailMode.signUp;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    if (_submitting || !SignupLogic.canSubmitCredentials(email, password)) {
      return;
    }
    setState(() => _submitting = true);
    final outcome = _isSignUp
        ? await widget.controller.signUpWithEmail(email, password)
        : await widget.controller.signInWithEmail(email, password);
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _emailInUse = outcome == EmailAuthOutcome.emailInUse;
      _invalidCredentials = outcome == EmailAuthOutcome.invalidCredentials;
    });
    switch (outcome) {
      case EmailAuthOutcome.success:
        // สมัครสำเร็จ → S-6 (ux-flow §3 ข้อ 4); เข้าสู่ระบบ → S-6/S-7 ตามโปรไฟล์ (Q-21)
        popToSignupRoot(context);
      case EmailAuthOutcome.networkError:
        // ASSUMPTION: ux-flow ไม่มีสถานะเน็ตหลุดของ S-2 — ใช้ dialog เดียวกับ EC-1/EC-4
        final retry = await showSignupNetworkErrorDialog(
          context,
          dialogKey: 'signup_email_error_dialog',
          retryKey: 'signup_email_retry_button',
        );
        if (retry && mounted) await _submit();
      case EmailAuthOutcome.emailInUse:
      case EmailAuthOutcome.invalidCredentials:
        break;
    }
  }

  void _openForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            SignupForgotPasswordScreen(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = _emailController.text;
    final password = _passwordController.text;
    final canSubmit =
        !_submitting && SignupLogic.canSubmitCredentials(email, password);

    Widget? passwordError;
    if (SignupLogic.showsPasswordError(password)) {
      passwordError = const Text(
        SignupRules.passwordTooShortError,
        key: Key('signup_password_error_text'),
      );
    } else if (_invalidCredentials) {
      passwordError = const Text(
        SignupRules.invalidCredentialsError,
        key: Key('signup_login_error_text'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('signup_email_back_button'),
          icon: const Icon(Icons.arrow_back),
          tooltip: SignupRules.backButtonText,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          _isSignUp ? SignupRules.signupHeader : SignupRules.loginHeader,
          key: const Key('signup_email_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('signup_email_field'),
                controller: _emailController,
                enabled: !_submitting,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                onChanged: (_) => setState(() {
                  _emailInUse = false;
                  _invalidCredentials = false;
                }),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.emailHint,
                  error: _isSignUp && _emailInUse
                      ? const Text(
                          SignupRules.emailInUseError,
                          key: Key('signup_email_duplicate_error_text'),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_password_field'),
                controller: _passwordController,
                enabled: !_submitting,
                obscureText: true,
                onChanged: (_) => setState(() => _invalidCredentials = false),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.passwordHint,
                  error: passwordError,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('signup_submit_button'),
                onPressed: canSubmit ? _submit : null,
                child: SignupButtonLabel(
                  text: _isSignUp
                      ? SignupRules.signupSubmitText
                      : SignupRules.loginSubmitText,
                  loading: _submitting,
                  indicatorKey: 'signup_submit_loading_indicator',
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  key: const Key('signup_forgot_password_link'),
                  onPressed: _submitting ? null : _openForgotPassword,
                  child: const Text(SignupRules.forgotPasswordLinkText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/signup/screens/signup_email_screen.dart ===

=== app/lib/features/signup/screens/signup_forgot_password_screen.dart ===
import 'package:flutter/material.dart';

import '../signup_controller.dart';
import '../signup_rules.dart';
import '../widgets/signup_widgets.dart';
import 'signup_reset_sent_screen.dart';

/// S-3 หน้าลืมรหัสผ่าน (ux-flow §2 S-3, ui-spec §2.3)
class SignupForgotPasswordScreen extends StatefulWidget {
  const SignupForgotPasswordScreen({super.key, required this.controller});

  final SignupController controller;

  @override
  State<SignupForgotPasswordScreen> createState() =>
      _SignupForgotPasswordScreenState();
}

class _SignupForgotPasswordScreenState
    extends State<SignupForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // ASSUMPTION: ui-spec Q-7 — ปุ่มกดได้เสมอ (รวมช่องว่าง) และไม่มีสถานะ error;
  // FakeAuthRepository ตอบสำเร็จเสมอแล้วไป S-4
  Future<void> _submit() async {
    if (_sending) return;
    setState(() => _sending = true);
    try {
      await widget.controller.requestPasswordReset(_emailController.text);
    } catch (_) {
      // ไม่มีหน้าตา error ใน ux-flow — ไปต่อที่ S-4 เหมือนสำเร็จ
    }
    if (!mounted) return;
    setState(() => _sending = false);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SignupResetSentScreen(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('signup_forgot_back_button'),
          icon: const Icon(Icons.arrow_back),
          tooltip: SignupRules.backButtonText,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          SignupRules.forgotHeader,
          key: Key('signup_forgot_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                SignupRules.forgotDescription,
                key: Key('signup_forgot_description_text'),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_forgot_email_field'),
                controller: _emailController,
                enabled: !_sending,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: SignupRules.emailHint,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('signup_forgot_submit_button'),
                onPressed: _sending ? null : _submit,
                child: SignupButtonLabel(
                  text: SignupRules.forgotSubmitText,
                  loading: _sending,
                  indicatorKey: 'signup_forgot_loading_indicator',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/signup/screens/signup_forgot_password_screen.dart ===

=== app/lib/features/signup/screens/signup_gate.dart ===
import 'package:flutter/material.dart';

import '../signup_controller.dart';
import '../signup_logic.dart';
import 'signup_onboarding_screen.dart';
import 'signup_welcome_screen.dart';

/// สร้างหน้า S-7 (Home) — [welcomeName] = Display Name ที่ประมวลผลแล้ว (AC-5)
typedef SignupHomeBuilder = Widget Function(
    BuildContext context, String? welcomeName);

/// จุดเริ่มของแอป: อ่าน Token แล้วเลือก S-1 / S-6 / S-7 (ui-spec §2.0, AC-8)
///
/// หน้าราก (root route) เปลี่ยนตาม [SignupController.route]; หน้าที่ push ซ้อน
/// (S-2…S-5) เมื่อเข้าสู่ระบบสำเร็จจะ pop กลับมาที่รากเอง
class SignupGate extends StatefulWidget {
  const SignupGate({
    super.key,
    required this.controller,
    required this.homeBuilder,
  });

  final SignupController controller;
  final SignupHomeBuilder homeBuilder;

  @override
  State<SignupGate> createState() => _SignupGateState();
}

class _SignupGateState extends State<SignupGate> {
  @override
  void initState() {
    super.initState();
    if (!widget.controller.isLoaded) widget.controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        switch (widget.controller.route) {
          case SignupRoute.loading:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  key: Key('signup_auth_loading'),
                ),
              ),
            );
          case SignupRoute.welcome:
            return SignupWelcomeScreen(controller: widget.controller);
          case SignupRoute.onboarding:
            return SignupOnboardingScreen(controller: widget.controller);
          case SignupRoute.home:
            return widget.homeBuilder(
                context, widget.controller.homeDisplayName);
        }
      },
    );
  }
}

/// กลับไปหน้าราก (ให้ SignupGate แสดงปลายทางใหม่) หลังเข้าสู่ระบบ/บันทึกสำเร็จ
void popToSignupRoot(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}

=== จบ app/lib/features/signup/screens/signup_gate.dart ===

=== app/lib/features/signup/screens/signup_new_password_screen.dart ===
import 'package:flutter/material.dart';

import '../signup_controller.dart';
import '../signup_logic.dart';
import '../signup_rules.dart';
import '../widgets/signup_widgets.dart';
import 'signup_reset_sent_screen.dart';

/// S-5 หน้าตั้งค่ารหัสผ่านใหม่ (ux-flow §2 S-5, ui-spec §2.5, AC-3)
///
/// ASSUMPTION: ui-spec Q-7 — ทางเข้า S-5 (ลิงก์จากอีเมล / deep link) ยังไม่กำหนด
/// MVP ไม่มีอีเมลจริง จึงไม่มีปุ่มใดในแอปเปิดหน้านี้ — เปิดด้วย [SignupNewPasswordScreen.route]
class SignupNewPasswordScreen extends StatefulWidget {
  const SignupNewPasswordScreen({
    super.key,
    required this.controller,
    required this.email,
  });

  final SignupController controller;

  /// อีเมลของบัญชีที่ขอรีเซ็ต (มาจากลิงก์รีเซ็ต)
  final String email;

  static Route<void> route(SignupController controller, String email) =>
      MaterialPageRoute<void>(
        builder: (_) =>
            SignupNewPasswordScreen(controller: controller, email: email),
      );

  @override
  State<SignupNewPasswordScreen> createState() =>
      _SignupNewPasswordScreenState();
}

class _SignupNewPasswordScreenState extends State<SignupNewPasswordScreen> {
  final _passwordController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final password = _passwordController.text;
    // AC-3: รหัสผ่านสั้นกว่า min_password_length → ปฏิเสธการบันทึก
    if (_saving || !SignupLogic.isPasswordLongEnough(password)) return;
    setState(() => _saving = true);
    final ok = await widget.controller.resetPassword(widget.email, password);
    if (!mounted) return;
    setState(() => _saving = false);
    // ASSUMPTION: ux-flow ไม่มีสถานะบันทึกไม่สำเร็จของ S-5 — คงอยู่หน้าเดิมให้กดใหม่
    if (!ok) return;
    final messenger = ScaffoldMessenger.of(context);
    openSignInReplacingStack(context, widget.controller);
    showSignupToast(
      messenger,
      'signup_password_reset_success_toast',
      SignupRules.passwordResetSuccessMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final password = _passwordController.text;
    final canSave = !_saving && SignupLogic.isPasswordLongEnough(password);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          SignupRules.newPasswordHeader,
          key: Key('signup_new_password_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('signup_new_password_field'),
                controller: _passwordController,
                enabled: !_saving,
                obscureText: true,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.newPasswordHint,
                  error: SignupLogic.showsPasswordError(password)
                      ? const Text(
                          SignupRules.newPasswordTooShortError,
                          key: Key('signup_new_password_error_text'),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('signup_new_password_save_button'),
                onPressed: canSave ? _save : null,
                child: SignupButtonLabel(
                  text: SignupRules.newPasswordSaveText,
                  loading: _saving,
                  indicatorKey: 'signup_new_password_loading_indicator',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/signup/screens/signup_new_password_screen.dart ===

=== app/lib/features/signup/screens/signup_onboarding_screen.dart ===
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../signup_controller.dart';
import '../signup_logic.dart';
import '../signup_models.dart';
import '../signup_rules.dart';
import '../widgets/signup_widgets.dart';
import 'signup_gate.dart';

/// S-6 หน้า Onboarding (ux-flow §2 S-6, ui-spec §2.6)
/// AC-4, AC-5 (ผ่าน SignupLogic), AC-6, AC-7, EC-2, EC-3, EC-4
class SignupOnboardingScreen extends StatefulWidget {
  const SignupOnboardingScreen({super.key, required this.controller});

  final SignupController controller;

  @override
  State<SignupOnboardingScreen> createState() => _SignupOnboardingScreenState();
}

class _SignupOnboardingScreenState extends State<SignupOnboardingScreen> {
  late final TextEditingController _displayName;
  late final TextEditingController _age;
  late final TextEditingController _weight;
  late final TextEditingController _height;
  late final TextEditingController _healthGoal;
  late SignupGender _gender;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // ASSUMPTION: บัญชีที่มีโปรไฟล์อยู่แล้วแต่ถูกพามา S-6 (AC-2 Account Linking)
    // → เติมค่าเดิมไว้ในฟอร์ม เพื่อไม่ให้ข้อมูลเดิมถูกทับด้วยค่าว่าง
    final existing = widget.controller.session?.profile;
    _displayName = TextEditingController(
        text: existing == null || existing.displayNameFromEmail
            ? ''
            : existing.displayName);
    _age = TextEditingController(text: existing?.age.toString() ?? '');
    _weight = TextEditingController(text: _fmt(existing?.weightKg));
    _height = TextEditingController(text: _fmt(existing?.heightCm));
    // default_health_goal เป็นข้อความจริงในช่อง (ไม่ใช่ hint) — ui-spec §2.6 #16
    _healthGoal = TextEditingController(
        text: existing?.healthGoal ?? SignupRules.defaultHealthGoal);
    _gender = existing?.gender ?? SignupGender.defaultValue;
  }

  static String _fmt(double? v) {
    if (v == null) return '';
    return v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
  }

  @override
  void dispose() {
    _displayName.dispose();
    _age.dispose();
    _weight.dispose();
    _height.dispose();
    _healthGoal.dispose();
    super.dispose();
  }

  OnboardingValidation get _validation => SignupLogic.validateOnboarding(
        age: _age.text,
        weight: _weight.text,
        height: _height.text,
        gender: _gender,
      );

  Future<void> _save() async {
    if (_saving || !_validation.canSave) return;
    setState(() => _saving = true);
    final outcome = await widget.controller.saveProfile(
      displayName: _displayName.text,
      age: _age.text,
      gender: _gender,
      weight: _weight.text,
      height: _height.text,
      healthGoal: _healthGoal.text,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    switch (outcome) {
      case SaveProfileOutcome.success:
        // SignupGate เปลี่ยนหน้ารากเป็น S-7
        popToSignupRoot(context);
      case SaveProfileOutcome.networkError:
        // EC-4: ฟอร์มยังอยู่ใต้ dialog ค่าทุกช่องคงเดิม
        final retry = await showSignupNetworkErrorDialog(
          context,
          dialogKey: 'signup_onboarding_error_dialog',
          retryKey: 'signup_onboarding_retry_button',
        );
        if (retry && mounted) await _save();
      case SaveProfileOutcome.invalid:
        break;
    }
  }

  void _onChanged(String _) => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final v = _validation;
    final enabled = !_saving;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          SignupRules.onboardingHeader,
          key: Key('signup_onboarding_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                SignupRules.onboardingDescription,
                key: Key('signup_onboarding_description_text'),
              ),
              const SizedBox(height: 16),
              // EC-3: บล็อกตัวที่ 21 ในระดับ UI; ตัวนับ n/20 เป็น default ของ maxLength
              // ASSUMPTION: ui-spec Q-19 — นับตัวอักษรแบบ grapheme ของ TextField.maxLength
              TextField(
                key: const Key('signup_display_name_field'),
                controller: _displayName,
                enabled: enabled,
                maxLength: SignupRules.maxDisplayNameLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                onChanged: _onChanged,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: SignupRules.displayNameHint,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_age_field'),
                controller: _age,
                enabled: enabled,
                keyboardType: TextInputType.number,
                // D-c: จำนวนเต็มเท่านั้น — การพิมพ์/วางที่มีอักขระอื่นปน ("25.5", "-3",
                // "abc") ถูกปฏิเสธทั้งก้อนก่อนถึง digitsOnly จึงไม่เปลี่ยนค่าเงียบ ๆ
                inputFormatters: [
                  const SignupWholeNumberInputFormatter(),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: _onChanged,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.ageHint,
                  error: v.showAgeError
                      ? Text(SignupRules.ageRangeError,
                          key: const Key('signup_age_error_text'))
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                SignupRules.genderLabel,
                key: const Key('signup_gender_label'),
                style: theme.textTheme.titleMedium,
              ),
              RadioGroup<SignupGender>(
                key: const Key('signup_gender_group'),
                groupValue: _gender,
                onChanged: (g) {
                  if (g == null || !enabled) return;
                  setState(() => _gender = g);
                },
                child: Column(
                  children: [
                    for (final g in SignupGender.values)
                      RadioListTile<SignupGender>(
                        key: Key('signup_gender_${g.name}'),
                        value: g,
                        enabled: enabled,
                        contentPadding: EdgeInsets.zero,
                        title: Text(g.label),
                      ),
                  ],
                ),
              ),
              // AC-6: เตือนทันทีเมื่อเลือก UNSPECIFIED — ไม่บล็อกการบันทึก
              if (v.showGenderWarning)
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: SignupWarningText(
                    SignupRules.genderWarning,
                    key: Key('signup_gender_warning_text'),
                  ),
                ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_weight_field'),
                controller: _weight,
                enabled: enabled,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: _onChanged,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.weightHint,
                  // AC-7 warning (ไม่บล็อก) / EC-2 error (บล็อก) — error แทนที่ helper เอง
                  helper: v.showWeightWarning
                      ? const SignupWarningText(
                          SignupRules.bodyMetricMissingWarning,
                          key: Key('signup_weight_warning_text'),
                        )
                      : null,
                  error: v.showWeightError
                      ? Text(SignupRules.weightRangeError,
                          key: const Key('signup_weight_error_text'))
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_height_field'),
                controller: _height,
                enabled: enabled,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: _onChanged,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.heightHint,
                  helper: v.showHeightWarning
                      ? const SignupWarningText(
                          SignupRules.bodyMetricMissingWarning,
                          key: Key('signup_height_warning_text'),
                        )
                      : null,
                  error: v.showHeightError
                      ? Text(SignupRules.heightRangeError,
                          key: const Key('signup_height_error_text'))
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_health_goal_field'),
                controller: _healthGoal,
                enabled: enabled,
                minLines: 3,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: SignupRules.healthGoalLabel,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('signup_onboarding_save_button'),
                onPressed: enabled && v.canSave ? _save : null,
                child: SignupButtonLabel(
                  text: SignupRules.onboardingSaveText,
                  loading: _saving,
                  indicatorKey: 'signup_onboarding_loading_indicator',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/signup/screens/signup_onboarding_screen.dart ===

=== app/lib/features/signup/screens/signup_reset_sent_screen.dart ===
import 'package:flutter/material.dart';

import '../../water/widgets/asset_image_or_icon.dart';
import '../signup_controller.dart';
import '../signup_rules.dart';
import 'signup_email_screen.dart';

/// S-4 หน้าจอรอการยืนยันรีเซ็ตรหัสผ่าน (ux-flow §2 S-4, ui-spec §2.4)
class SignupResetSentScreen extends StatelessWidget {
  const SignupResetSentScreen({super.key, required this.controller});

  final SignupController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Center(
                child: AssetImageOrIcon(
                  key: Key('signup_reset_sent_image'),
                  assetPath: SignupRules.resetSentImage,
                  fallbackIcon: Icons.mark_email_unread,
                  size: SignupRules.heroImageSize,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                SignupRules.resetSentHeader,
                key: const Key('signup_reset_sent_header_text'),
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                SignupRules.resetSentMessage,
                key: Key('signup_reset_sent_message_text'),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              FilledButton(
                key: const Key('signup_back_to_login_button'),
                onPressed: () => openSignInReplacingStack(context, controller),
                child: const Text(SignupRules.backToLoginText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ไป S-2 โหมดเข้าสู่ระบบ โดยล้างหน้าที่ซ้อนอยู่ทั้งหมด เหลือหน้าราก (S-1) ไว้ใต้
// ASSUMPTION: 「กลับสู่หน้าเข้าสู่ระบบ」 (S-4) และบันทึกรหัสผ่านใหม่สำเร็จ (S-5) → S-2
// โหมดเข้าสู่ระบบเสมอ ไม่ว่าก่อนหน้าเปิด S-2 โหมดใด
void openSignInReplacingStack(
    BuildContext context, SignupController controller) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(
      builder: (_) => SignupEmailScreen(
        controller: controller,
        mode: SignupEmailMode.signIn,
      ),
    ),
    (route) => route.isFirst,
  );
}

=== จบ app/lib/features/signup/screens/signup_reset_sent_screen.dart ===

=== app/lib/features/signup/screens/signup_welcome_screen.dart ===
import 'package:flutter/material.dart';

import '../../water/widgets/asset_image_or_icon.dart';
import '../signup_controller.dart';
import '../signup_rules.dart';
import '../widgets/signup_widgets.dart';
import 'signup_email_screen.dart';
import 'signup_gate.dart';

/// S-1 หน้าต้อนรับและเลือกวิธีเข้าสู่ระบบ (ux-flow §2 S-1, ui-spec §2.1)
class SignupWelcomeScreen extends StatefulWidget {
  const SignupWelcomeScreen({super.key, required this.controller});

  final SignupController controller;

  @override
  State<SignupWelcomeScreen> createState() => _SignupWelcomeScreenState();
}

class _SignupWelcomeScreenState extends State<SignupWelcomeScreen> {
  bool _googleLoading = false;

  /// US-2 / AC-2 / EC-1 — ไม่มี Google SDK: FakeAuthRepository จำลองการเข้าสู่ระบบ
  Future<void> _signInWithGoogle() async {
    if (_googleLoading) return;
    setState(() => _googleLoading = true);
    final outcome = await widget.controller.signInWithGoogle();
    if (!mounted) return;
    setState(() => _googleLoading = false);
    switch (outcome) {
      case GoogleAuthOutcome.success:
        // SignupGate เปลี่ยนหน้ารากเป็น S-6 หรือ S-7 เอง
        popToSignupRoot(context);
      case GoogleAuthOutcome.networkError:
        final retry = await showSignupNetworkErrorDialog(
          context,
          dialogKey: 'signup_google_error_dialog',
          retryKey: 'signup_google_retry_button',
        );
        if (retry && mounted) await _signInWithGoogle();
    }
  }

  void _openEmail(SignupEmailMode mode) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            SignupEmailScreen(controller: widget.controller, mode: mode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final busy = _googleLoading;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      const Center(
                        child: AssetImageOrIcon(
                          key: Key('signup_welcome_logo'),
                          assetPath: SignupRules.welcomeLogo,
                          fallbackIcon: Icons.pets,
                          size: SignupRules.heroImageSize,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        SignupRules.appTitle,
                        key: const Key('signup_welcome_title_text'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        SignupRules.welcomeTagline,
                        key: const Key('signup_welcome_tagline_text'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        key: const Key('signup_google_button'),
                        onPressed: busy ? null : _signInWithGoogle,
                        // ASSUMPTION: ui-spec Q-17 — ยังไม่มีไฟล์โลโก้ Google ใช้ Icons.login
                        icon: _googleLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  key: Key('signup_google_loading_indicator'),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.login, size: 24),
                        label: const Text(SignupRules.googleButtonText),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              SignupRules.orText,
                              key: const Key('signup_or_text'),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        key: const Key('signup_email_signup_button'),
                        onPressed: busy
                            ? null
                            : () => _openEmail(SignupEmailMode.signUp),
                        icon: const Icon(Icons.email, size: 24),
                        label: const Text(SignupRules.emailSignupButtonText),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        key: const Key('signup_have_account_link'),
                        onPressed: busy
                            ? null
                            : () => _openEmail(SignupEmailMode.signIn),
                        child: const Text(SignupRules.haveAccountLinkText),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

=== จบ app/lib/features/signup/screens/signup_welcome_screen.dart ===

=== app/lib/features/signup/signup_controller.dart ===
/// ตัวกลางระหว่าง repository/logic กับ UI ของ signup
library;

import 'package:flutter/foundation.dart';

import 'signup_logic.dart';
import 'signup_models.dart';
import 'signup_repository.dart';

/// ผลของการสมัคร/เข้าสู่ระบบด้วยอีเมล (S-2)
enum EmailAuthOutcome { success, emailInUse, invalidCredentials, networkError }

/// ผลของ Google Login (S-1)
enum GoogleAuthOutcome { success, networkError }

/// ผลของการบันทึก Onboarding (S-6)
enum SaveProfileOutcome { success, networkError, invalid }

class SignupController extends ChangeNotifier {
  SignupController({required this._repository});

  final AuthRepository _repository;

  bool _isLoaded = false;
  AuthSession? _session;
  bool _forceOnboarding = false;

  bool get isLoaded => _isLoaded;
  AuthSession? get session => _session;

  /// ปลายทางปัจจุบันของแอป (ใช้โดย SignupGate)
  SignupRoute get route => SignupLogic.routeFor(
        isLoaded: _isLoaded,
        session: _session,
        forceOnboarding: _forceOnboarding,
      );

  /// ชื่อบนแบนเนอร์ S-7 (AC-5) — null ถ้ายังไม่มีโปรไฟล์
  String? get homeDisplayName {
    final profile = _session?.profile;
    return profile == null ? null : SignupLogic.displayNameForUi(profile);
  }

  /// อ่าน Token ตอนเปิดแอป (AC-8)
  Future<void> load() async {
    try {
      _session = await _repository.restoreSession();
    } catch (_) {
      // ASSUMPTION: อ่าน session ไม่ได้ → ไปหน้า S-1 (ให้เข้าสู่ระบบใหม่) แอปไม่ล่ม
      _session = null;
    }
    _isLoaded = true;
    notifyListeners();
  }

  /// S-2 โหมดสมัคร (US-1, AC-2, EC-5)
  Future<EmailAuthOutcome> signUpWithEmail(String email, String password) =>
      _emailAuth(() => _repository.signUpWithEmail(email, password));

  /// S-2 โหมดเข้าสู่ระบบ
  Future<EmailAuthOutcome> signInWithEmail(String email, String password) =>
      _emailAuth(() => _repository.signInWithEmail(email, password));

  Future<EmailAuthOutcome> _emailAuth(
      Future<AuthSession> Function() call) async {
    try {
      _session = await call();
    } on EmailAlreadyInUseException {
      return EmailAuthOutcome.emailInUse;
    } on InvalidCredentialsException {
      return EmailAuthOutcome.invalidCredentials;
    } on AuthNetworkException {
      return EmailAuthOutcome.networkError;
    }
    _forceOnboarding = false;
    notifyListeners();
    return EmailAuthOutcome.success;
  }

  /// S-1 Google Login (US-2, AC-2, EC-1)
  Future<GoogleAuthOutcome> signInWithGoogle() async {
    final GoogleSignInResult result;
    try {
      result = await _repository.signInWithGoogle();
    } on AuthNetworkException {
      return GoogleAuthOutcome.networkError;
    }
    _session = result.session;
    // AC-2: เชื่อมบัญชีแล้วพาไป Onboarding ทันที
    _forceOnboarding = result.linked;
    notifyListeners();
    return GoogleAuthOutcome.success;
  }

  /// S-3
  Future<void> requestPasswordReset(String email) =>
      _repository.requestPasswordReset(email);

  /// S-5 (AC-3) — false = รหัสผ่านสั้นเกิน (ปฏิเสธการบันทึก) หรือบันทึกไม่สำเร็จ
  Future<bool> resetPassword(String email, String newPassword) async {
    if (!SignupLogic.isPasswordLongEnough(newPassword)) return false;
    try {
      await _repository.resetPassword(email, newPassword);
      return true;
    } on AuthException {
      return false;
    }
  }

  /// S-6 บันทึก (US-4, AC-4, EC-2, EC-4)
  Future<SaveProfileOutcome> saveProfile({
    required String displayName,
    required String age,
    required SignupGender gender,
    required String weight,
    required String height,
    required String healthGoal,
  }) async {
    final session = _session;
    if (session == null) return SaveProfileOutcome.invalid;
    final profile = SignupLogic.buildProfile(
      email: session.email,
      displayName: displayName,
      age: age,
      gender: gender,
      weight: weight,
      height: height,
      healthGoal: healthGoal,
    );
    if (profile == null) return SaveProfileOutcome.invalid;
    try {
      _session = await _repository.saveProfile(profile);
    } on AuthNetworkException {
      return SaveProfileOutcome.networkError;
    } on NotSignedInException {
      return SaveProfileOutcome.invalid;
    }
    _forceOnboarding = false;
    notifyListeners();
    return SaveProfileOutcome.success;
  }

  Future<void> signOut() async {
    await _repository.signOut();
    _session = null;
    _forceOnboarding = false;
    notifyListeners();
  }
}

=== จบ app/lib/features/signup/signup_controller.dart ===

=== app/lib/features/signup/signup_logic.dart ===
/// กติกาของฟีเจอร์ signup — pure Dart ไม่ขึ้นกับ widget (QA ทดสอบตรงได้)
library;

import 'signup_models.dart';
import 'signup_rules.dart';

/// ปลายทางของแอปตามสถานะ session (ux-flow §3, AC-8)
enum SignupRoute {
  /// กำลังอ่าน Token (ui-spec §2.0)
  loading,

  /// S-1
  welcome,

  /// S-6
  onboarding,

  /// S-7
  home,
}

/// ผลตรวจฟิลด์ตัวเลขของ S-6
enum NumberFieldStatus {
  /// ว่าง
  empty,

  /// อยู่ในขอบเขต
  valid,

  /// นอกขอบเขตหรืออ่านไม่ออก (EC-2)
  outOfRange,
}

/// ผลตรวจฟอร์ม S-6 ทั้งหน้า
class OnboardingValidation {
  const OnboardingValidation({
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
  });

  final NumberFieldStatus age;
  final NumberFieldStatus weight;
  final NumberFieldStatus height;
  final SignupGender gender;

  bool get showAgeError => age == NumberFieldStatus.outOfRange;
  bool get showWeightError => weight == NumberFieldStatus.outOfRange;
  bool get showHeightError => height == NumberFieldStatus.outOfRange;

  /// AC-7: เตือนใต้ช่องที่ว่างเท่านั้น
  bool get showWeightWarning => weight == NumberFieldStatus.empty;
  bool get showHeightWarning => height == NumberFieldStatus.empty;

  /// AC-6
  bool get showGenderWarning => SignupLogic.showsGenderWarning(gender);

  /// EC-2: ทุกช่องตัวเลขที่กรอกต้องอยู่ในขอบเขต; warning ไม่บล็อก (fallback ux-flow §6)
  // ASSUMPTION: อายุว่าง → บันทึกไม่ได้ (ui-spec Q-11 ตาม brief: อายุบังคับกรอก)
  // โดยไม่แสดงข้อความ
  bool get canSave =>
      age == NumberFieldStatus.valid &&
      weight != NumberFieldStatus.outOfRange &&
      height != NumberFieldStatus.outOfRange;
}

class SignupLogic {
  SignupLogic._();

  // ---------------------------------------------------------------------------
  // S-2 / S-5 อีเมลและรหัสผ่าน
  // ---------------------------------------------------------------------------

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  /// ทำอีเมลให้เป็นรูปแบบเดียวกันก่อนเทียบ/บันทึก
  // ASSUMPTION: อีเมลไม่สนตัวพิมพ์เล็ก-ใหญ่ และตัดช่องว่างหัวท้าย (A@x.com = a@x.com)
  static String normalizeEmail(String email) => email.trim().toLowerCase();

  /// ใช้ตัดสินว่าปุ่ม S-2 enabled ได้หรือไม่ (ui-spec §3 S-2 disabled)
  // ASSUMPTION: ตรวจรูปแบบอีเมลแบบพื้นฐาน "x@y.z" (ui-spec Q-3) ไม่มีข้อความ error
  static bool isValidEmail(String email) =>
      _emailPattern.hasMatch(email.trim());

  /// AC-1, AC-3: ความยาว >= min_password_length
  static bool isPasswordLongEnough(String password) =>
      password.length >= SignupRules.minPasswordLength;

  /// AC-1 / AC-3: แสดง error เมื่อยาว 1 ถึง min-1 ตัว — ช่องว่าง (0) ไม่ใช่ error (ui-spec Q-3)
  // ASSUMPTION: นับความยาวรหัสผ่านเป็น UTF-16 code unit (String.length) — ui-spec Q-19
  static bool showsPasswordError(String password) =>
      password.isNotEmpty && !isPasswordLongEnough(password);

  /// ปุ่ม S-2 enabled เมื่ออีเมลถูกรูปแบบและรหัสผ่านยาวพอ
  static bool canSubmitCredentials(String email, String password) =>
      isValidEmail(email) && isPasswordLongEnough(password);

  // ---------------------------------------------------------------------------
  // S-6 / S-7 Display Name (AC-4, AC-5, EC-3)
  // ---------------------------------------------------------------------------

  /// ชื่อหน้าอีเมล เช่น alexander@email.com → alexander
  static String emailLocalPart(String email) {
    final trimmed = email.trim();
    final at = trimmed.indexOf('@');
    return at < 0 ? trimmed : trimmed.substring(0, at);
  }

  /// ค่า Display Name ที่บันทึก (AC-4) — คืน (ชื่อ, มาจากอีเมลหรือไม่)
  static ({String name, bool fromEmail}) resolveDisplayName(
    String typed,
    String email,
  ) {
    final name = typed.trim();
    if (name.isNotEmpty) {
      return (name: _cap(name), fromEmail: false);
    }
    // DECIDED (owner ชั่วคราว D-a): ชื่อหน้าอีเมลบันทึกเต็มไม่ตัด — ลิมิต
    // max_display_name_length ใช้เฉพาะชื่อที่ผู้ใช้พิมพ์เอง (EC-3); AC-5 ย่อตอนแสดงผล
    return (name: emailLocalPart(email), fromEmail: true);
  }

  /// AC-5: ชื่อจากหน้าอีเมลที่ยาวเกิน display_name_truncation_limit → 4 ตัวแรก + ... + 2 ตัวท้าย
  static String truncateEmailName(String name) {
    final chars = name.runes.toList();
    if (chars.length <= SignupRules.displayNameTruncationLimit) return name;
    final head = String.fromCharCodes(
        chars.take(SignupRules.truncatedHeadLength));
    final tail = String.fromCharCodes(
        chars.skip(chars.length - SignupRules.truncatedTailLength));
    return '$head${SignupRules.truncationEllipsis}$tail';
  }

  /// ชื่อที่แสดงบนแบนเนอร์ S-7 — ชื่อจากอีเมลถูกบันทึกเต็ม (D-a) จึงย่อจากชื่อหน้าอีเมลจริง
  // ASSUMPTION: ui-spec Q-20 — ตัดคำเฉพาะชื่อที่ได้จากหน้าอีเมล ชื่อที่ผู้ใช้พิมพ์เองแสดงเต็ม
  static String displayNameForUi(UserProfile profile) =>
      profile.displayNameFromEmail
          ? truncateEmailName(profile.displayName)
          : profile.displayName;

  static String _cap(String s) {
    final chars = s.runes.toList();
    if (chars.length <= SignupRules.maxDisplayNameLength) return s;
    return String.fromCharCodes(chars.take(SignupRules.maxDisplayNameLength));
  }

  // ---------------------------------------------------------------------------
  // S-6 ช่องตัวเลข (EC-2) และคำเตือน (AC-6, AC-7)
  // ---------------------------------------------------------------------------

  static final RegExp _wholeNumberPattern = RegExp(r'^[0-9]+$');

  /// อายุต้องเป็นจำนวนเต็มเท่านั้น (DECIDED ทีม D-c, requirements §6 Age = Integer)
  /// รับเฉพาะเลข 0-9 ล้วน — ไม่รับทศนิยม ("25.5"), เครื่องหมาย ("-3", "+25"),
  /// รูปแบบที่ int.tryParse รับได้แต่ไม่ใช่เลขฐานสิบล้วน ("0x19") หรือตัวอักษร ("abc")
  static bool isWholeNumberText(String text) =>
      _wholeNumberPattern.hasMatch(text);

  /// EC-2: อายุอยู่ในช่วง [min_age, max_age]
  static bool isAgeInRange(int age) =>
      age >= SignupRules.minAge && age <= SignupRules.maxAge;

  static NumberFieldStatus ageStatus(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return NumberFieldStatus.empty;
    // ASSUMPTION: ข้อความที่ไม่ใช่จำนวนเต็มล้วน ถือเป็น error เดียวกับนอกขอบเขต
    // (เอกสารไม่มีข้อความเฉพาะ) → บล็อกการบันทึก
    if (!isWholeNumberText(text)) return NumberFieldStatus.outOfRange;
    final v = int.tryParse(text);
    if (v == null || !isAgeInRange(v)) return NumberFieldStatus.outOfRange;
    return NumberFieldStatus.valid;
  }

  // ASSUMPTION: ข้อความที่แปลงเป็นตัวเลขไม่ได้ (เช่น "1.2.3", "abc") ถือเป็น error
  // เดียวกับนอกขอบเขต (เอกสารไม่มีข้อความเฉพาะ); ทศนิยมไม่จำกัดหลัก (ui-spec Q-11)
  static NumberFieldStatus weightStatus(String raw) =>
      _doubleStatus(raw, SignupRules.minWeight, SignupRules.maxWeight);

  static NumberFieldStatus heightStatus(String raw) =>
      _doubleStatus(raw, SignupRules.minHeight, SignupRules.maxHeight);

  static NumberFieldStatus _doubleStatus(String raw, double min, double max) {
    final text = raw.trim();
    if (text.isEmpty) return NumberFieldStatus.empty;
    final v = double.tryParse(text);
    if (v == null || v.isNaN || v < min || v > max) {
      return NumberFieldStatus.outOfRange;
    }
    return NumberFieldStatus.valid;
  }

  /// AC-6
  static bool showsGenderWarning(SignupGender gender) =>
      gender == SignupGender.unspecified;

  static OnboardingValidation validateOnboarding({
    required String age,
    required String weight,
    required String height,
    required SignupGender gender,
  }) =>
      OnboardingValidation(
        age: ageStatus(age),
        weight: weightStatus(weight),
        height: heightStatus(height),
        gender: gender,
      );

  /// สร้างโปรไฟล์ที่จะบันทึก — คืน null ถ้าฟอร์มยังบันทึกไม่ได้ (EC-2)
  static UserProfile? buildProfile({
    required String email,
    required String displayName,
    required String age,
    required SignupGender gender,
    required String weight,
    required String height,
    required String healthGoal,
  }) {
    final v = validateOnboarding(
        age: age, weight: weight, height: height, gender: gender);
    if (!v.canSave) return null;
    final name = resolveDisplayName(displayName, email);
    final goal = healthGoal.trim();
    return UserProfile(
      displayName: name.name,
      displayNameFromEmail: name.fromEmail,
      age: int.parse(age.trim()),
      gender: gender,
      weightKg: v.weight == NumberFieldStatus.valid
          ? double.parse(weight.trim())
          : null,
      heightCm: v.height == NumberFieldStatus.valid
          ? double.parse(height.trim())
          : null,
      // ASSUMPTION: ui-spec Q-10 — ผู้ใช้ลบเป้าหมายจนว่าง → บันทึกค่าเริ่มต้น 「ดูแลสุขภาพ」
      healthGoal: goal.isEmpty ? SignupRules.defaultHealthGoal : goal,
    );
  }

  // ---------------------------------------------------------------------------
  // การนำทาง (ux-flow §3, AC-2, AC-8)
  // ---------------------------------------------------------------------------

  /// [forceOnboarding] = true หลัง Google Account Linking (AC-2 "พาไปหน้า Onboarding ทันที")
  // ASSUMPTION: มี session แต่ยังไม่มีโปรไฟล์ (เช่น ปิดแอประหว่าง Onboarding) → S-6
  static SignupRoute routeFor({
    required bool isLoaded,
    required AuthSession? session,
    bool forceOnboarding = false,
  }) {
    if (!isLoaded) return SignupRoute.loading;
    if (session == null) return SignupRoute.welcome;
    if (forceOnboarding || session.profile == null) {
      return SignupRoute.onboarding;
    }
    return SignupRoute.home;
  }
}

=== จบ app/lib/features/signup/signup_logic.dart ===

=== app/lib/features/signup/signup_models.dart ===
/// โมเดลข้อมูลของฟีเจอร์ signup (pure Dart)
library;

import 'signup_rules.dart';

/// เพศ (requirements §6) — ค่าภายในเป็น MALE / FEMALE / UNSPECIFIED (ux-flow S-6)
enum SignupGender {
  male('MALE', SignupRules.genderMaleText),
  female('FEMALE', SignupRules.genderFemaleText),
  unspecified('UNSPECIFIED', SignupRules.genderUnspecifiedText);

  const SignupGender(this.code, this.label);

  final String code;

  /// ข้อความบนจอ — แสดงเฉพาะคำไทย (ui-spec Q-8)
  final String label;

  /// default_gender (game-rules §1)
  static final SignupGender defaultValue =
      fromCode(SignupRules.defaultGenderCode);

  static SignupGender fromCode(String? code) {
    for (final g in values) {
      if (g.code == code) return g;
    }
    // ASSUMPTION: ค่าที่อ่านไม่ออก → ใช้ UNSPECIFIED (ค่าเริ่มต้นที่ปลอดภัย)
    return SignupGender.unspecified;
  }
}

/// ช่องทางที่ใช้เข้าสู่ระบบ
enum AuthProvider { email, google }

/// ข้อมูลสุขภาพ/โปรไฟล์ (requirements §6 Profiles Table)
class UserProfile {
  const UserProfile({
    required this.displayName,
    required this.displayNameFromEmail,
    required this.age,
    required this.gender,
    required this.weightKg,
    required this.heightCm,
    required this.healthGoal,
  });

  /// ค่าที่บันทึก (AC-4: เว้นว่าง → ชื่อหน้าอีเมล)
  final String displayName;

  /// true = ได้มาจากชื่อหน้าอีเมล (ใช้ตัดสินว่าต้องตัดคำตาม AC-5 หรือไม่)
  final bool displayNameFromEmail;
  final int age;
  final SignupGender gender;
  final double? weightKg;
  final double? heightCm;
  final String healthGoal;

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'displayNameFromEmail': displayNameFromEmail,
        'age': age,
        'gender': gender.code,
        'weightKg': weightKg,
        'heightCm': heightCm,
        'healthGoal': healthGoal,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        displayName: json['displayName'] as String,
        displayNameFromEmail: json['displayNameFromEmail'] as bool? ?? false,
        // D-c: อายุเป็นจำนวนเต็มเท่านั้น — ค่าที่บันทึกเป็นทศนิยม/ไม่ใช่ตัวเลขถือว่าข้อมูลเสีย
        // (throw → ผู้เรียกข้ามรายการนั้น) แทนการปัดเศษเงียบ ๆ ด้วย toInt()
        age: json['age'] as int,
        gender: SignupGender.fromCode(json['gender'] as String?),
        weightKg: (json['weightKg'] as num?)?.toDouble(),
        heightCm: (json['heightCm'] as num?)?.toDouble(),
        healthGoal:
            json['healthGoal'] as String? ?? SignupRules.defaultHealthGoal,
      );
}

/// Session ที่จัดเก็บในเครื่อง (US-5, AC-8)
class AuthSession {
  const AuthSession({
    required this.token,
    required this.email,
    this.profile,
  });

  final String token;
  final String email;

  /// null = ยังไม่ผ่าน Onboarding
  final UserProfile? profile;

  AuthSession copyWith({UserProfile? profile}) =>
      AuthSession(token: token, email: email, profile: profile ?? this.profile);
}

/// ผลของ Google Login (AC-2)
class GoogleSignInResult {
  const GoogleSignInResult({required this.session, required this.linked});

  final AuthSession session;

  /// true = อีเมลนี้เคยสมัครแบบอีเมลมาก่อน และถูกเชื่อมบัญชี (Account Linking)
  final bool linked;
}

/// ข้อผิดพลาดจาก repository
sealed class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
  @override
  String toString() => '$runtimeType: $message';
}

/// เครือข่ายขัดข้อง (EC-1, EC-4)
class AuthNetworkException extends AuthException {
  const AuthNetworkException([super.message = 'network unavailable']);
}

/// อีเมลถูกใช้แล้ว (AC-2, EC-5)
class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException([super.message = 'email already in use']);
}

/// อีเมล/รหัสผ่านไม่ตรงกับบัญชีใด (โหมดเข้าสู่ระบบ)
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException([super.message = 'invalid credentials']);
}

/// ไม่ได้เข้าสู่ระบบ (เช่น บันทึกโปรไฟล์โดยไม่มี session)
class NotSignedInException extends AuthException {
  const NotSignedInException([super.message = 'not signed in']);
}

=== จบ app/lib/features/signup/signup_models.dart ===

=== app/lib/features/signup/signup_repository.dart ===
/// การยืนยันตัวตนและเก็บโปรไฟล์ของ signup
///
/// DECIDED (owner): MVP ยังไม่มี backend — ใช้ [FakeAuthRepository] จำลองในเครื่อง
/// (ไม่มี network, ไม่ลง google_sign_in) โดยแยก [AuthRepository] เป็น interface
/// ไว้ต่อ backend จริงภายหลัง
library;

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signup_logic.dart';
import 'signup_models.dart';
import 'signup_rules.dart';

/// interface ของระบบยืนยันตัวตน — ทุกเมธอด throw [AuthException] เมื่อไม่สำเร็จ
abstract class AuthRepository {
  /// อ่าน session ที่เก็บไว้ในเครื่อง (AC-8) — null = ยังไม่ได้เข้าสู่ระบบ
  Future<AuthSession?> restoreSession();

  /// US-1 — throw [EmailAlreadyInUseException] (AC-2, EC-5), [AuthNetworkException]
  Future<AuthSession> signUpWithEmail(String email, String password);

  /// S-2 โหมดเข้าสู่ระบบ — throw [InvalidCredentialsException], [AuthNetworkException]
  Future<AuthSession> signInWithEmail(String email, String password);

  /// US-2 / AC-2 — throw [AuthNetworkException] (EC-1)
  Future<GoogleSignInResult> signInWithGoogle();

  /// US-3 S-3
  Future<void> requestPasswordReset(String email);

  /// US-3 S-5 / AC-3 — throw [ArgumentError] ถ้ารหัสผ่านสั้นกว่า min_password_length
  Future<void> resetPassword(String email, String newPassword);

  /// US-4 S-6 — throw [AuthNetworkException] (EC-4), [NotSignedInException]
  Future<AuthSession> saveProfile(UserProfile profile);

  Future<void> signOut();
}

// -----------------------------------------------------------------------------
// ที่เก็บข้อมูลในเครื่อง (key-value)
// -----------------------------------------------------------------------------

abstract class AuthLocalStore {
  Future<String?> read(String key);

  /// value = null → ลบ key
  Future<void> write(String key, String? value);
}

class InMemoryAuthLocalStore implements AuthLocalStore {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String? value) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }
}

/// เก็บด้วย shared_preferences
// ASSUMPTION: requirements §6 / AC-8 ให้เก็บ Token ใน Secure Storage แต่ owner สั่งใช้
// shared_preferences ในรอบนี้ — เปลี่ยนเป็น secure storage ได้โดยเขียน AuthLocalStore ใหม่
class SharedPrefsAuthLocalStore implements AuthLocalStore {
  SharedPrefsAuthLocalStore([Future<SharedPreferences>? prefs])
      : _prefs = prefs ?? SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefs;

  @override
  Future<String?> read(String key) async {
    try {
      final v = (await _prefs).get(key);
      return v is String ? v : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(String key, String? value) async {
    final prefs = await _prefs;
    final ok = value == null
        ? await prefs.remove(key)
        : await prefs.setString(key, value);
    if (!ok) throw const AuthNetworkException('local storage write failed');
  }
}

class SignupStorageKeys {
  SignupStorageKeys._();

  static const String accounts = 'signup_accounts';
  static const String session = 'signup_session';
}

// -----------------------------------------------------------------------------
// Fake repository
// -----------------------------------------------------------------------------

class _Account {
  _Account({
    required this.email,
    this.salt,
    this.passwordHash,
    Set<AuthProvider>? providers,
    this.profile,
  }) : providers = providers ?? {};

  final String email;
  String? salt;
  String? passwordHash;
  final Set<AuthProvider> providers;
  UserProfile? profile;

  Map<String, dynamic> toJson() => {
        'email': email,
        'salt': salt,
        'passwordHash': passwordHash,
        'providers': [for (final p in providers) p.name],
        'profile': profile?.toJson(),
      };

  static _Account fromJson(Map<String, dynamic> json) => _Account(
        email: json['email'] as String,
        salt: json['salt'] as String?,
        passwordHash: json['passwordHash'] as String?,
        providers: {
          for (final p in (json['providers'] as List? ?? const []))
            ...AuthProvider.values.where((v) => v.name == p),
        },
        profile: json['profile'] is Map<String, dynamic>
            ? UserProfile.fromJson(json['profile'] as Map<String, dynamic>)
            : null,
      );
}

/// ระบบยืนยันตัวตนจำลองในเครื่อง (ไม่มี network)
///
/// สำหรับ QA:
/// - [registeredEmails] / [registeredAccounts] — อีเมลที่สมัครไว้แล้วตั้งแต่ต้น
///   (ใช้ทดสอบอีเมลซ้ำ AC-2/EC-5 และ Account Linking)
/// - [failGoogleSignIn] = true → `signInWithGoogle` throw [AuthNetworkException] (EC-1)
/// - [failSaveProfile] = true → `saveProfile` throw [AuthNetworkException] (EC-4)
/// - [failEmailAuth] = true → สมัคร/เข้าสู่ระบบด้วยอีเมล throw [AuthNetworkException]
/// - [googleAccountEmail] — อีเมลที่ "บัญชี Google จำลอง" คืนมา
/// - [latency] — หน่วงทุกการเรียก (ดูสถานะ loading ได้ด้วย `tester.pump(latency)`)
/// flag ทั้งหมดแก้ระหว่างเทสต์ได้ (เช่น ตั้ง false แล้วกด Retry)
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    AuthLocalStore? store,
    Iterable<String> registeredEmails = const [],
    Map<String, String> registeredAccounts = const {},
    this.googleAccountEmail = defaultGoogleAccountEmail,
    this.failGoogleSignIn = false,
    this.failSaveProfile = false,
    this.failEmailAuth = false,
    this.latency = Duration.zero,
    Random? random,
  })  : _store = store ?? InMemoryAuthLocalStore(),
        _random = random ?? Random.secure() {
    // บัญชีตั้งต้น: ไม่มีรหัสผ่าน (เข้าสู่ระบบด้วยอีเมลไม่ได้ แต่ซ้ำ/เชื่อมบัญชีได้)
    for (final e in registeredEmails) {
      final email = SignupLogic.normalizeEmail(e);
      _seed[email] = _Account(email: email, providers: {AuthProvider.email});
    }
    registeredAccounts.forEach((e, password) {
      final email = SignupLogic.normalizeEmail(e);
      final account = _Account(email: email, providers: {AuthProvider.email});
      _setPassword(account, password);
      _seed[email] = account;
    });
  }

  // ASSUMPTION: ไม่มี Google SDK — บัญชี Google จำลองใช้อีเมลนี้ (ข้อมูลสมมติ)
  static const String defaultGoogleAccountEmail = 'petpal.demo@gmail.com';

  final AuthLocalStore _store;
  final Random _random;
  final Map<String, _Account> _seed = {};

  String googleAccountEmail;
  bool failGoogleSignIn;
  bool failSaveProfile;
  bool failEmailAuth;
  Duration latency;

  Map<String, _Account>? _accounts;
  AuthSession? _session;

  /// จำนวนครั้งที่ขอรีเซ็ตรหัสผ่าน (ตรวจได้ในเทสต์ — ไม่มีอีเมลจริงถูกส่ง)
  int passwordResetRequests = 0;

  /// อีเมลที่ลงทะเบียนแล้วทั้งหมด (normalize แล้ว)
  Future<Set<String>> registeredEmailSet() async =>
      (await _loadAccounts()).keys.toSet();

  /// โปรไฟล์ที่บันทึกของอีเมลนี้ (null = ยังไม่มี)
  Future<UserProfile?> profileFor(String email) async =>
      (await _loadAccounts())[SignupLogic.normalizeEmail(email)]?.profile;

  @override
  Future<AuthSession?> restoreSession() async {
    await _delay();
    final accounts = await _loadAccounts();
    final raw = await _store.read(SignupStorageKeys.session);
    if (raw == null) return _session = null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final token = json['token'] as String;
      final email = json['email'] as String;
      final account = accounts[email];
      // ASSUMPTION: session ที่ชี้ไปบัญชีที่ไม่มีแล้ว / ข้อมูลเสีย → ถือว่ายังไม่เข้าสู่ระบบ
      if (account == null || token.isEmpty) return _session = null;
      return _session =
          AuthSession(token: token, email: email, profile: account.profile);
    } catch (_) {
      return _session = null;
    }
  }

  @override
  Future<AuthSession> signUpWithEmail(String email, String password) async {
    await _delay();
    if (failEmailAuth) throw const AuthNetworkException();
    _checkPassword(password);
    final accounts = await _loadAccounts();
    final key = SignupLogic.normalizeEmail(email);
    if (accounts.containsKey(key)) throw const EmailAlreadyInUseException();
    final account = _Account(email: key, providers: {AuthProvider.email});
    _setPassword(account, password);
    accounts[key] = account;
    await _saveAccounts();
    return _startSession(account);
  }

  @override
  Future<AuthSession> signInWithEmail(String email, String password) async {
    await _delay();
    if (failEmailAuth) throw const AuthNetworkException();
    final accounts = await _loadAccounts();
    final account = accounts[SignupLogic.normalizeEmail(email)];
    if (account == null ||
        account.salt == null ||
        account.passwordHash != _hash(account.salt!, password)) {
      throw const InvalidCredentialsException();
    }
    return _startSession(account);
  }

  @override
  Future<GoogleSignInResult> signInWithGoogle() async {
    await _delay();
    if (failGoogleSignIn) throw const AuthNetworkException();
    final accounts = await _loadAccounts();
    final key = SignupLogic.normalizeEmail(googleAccountEmail);
    var account = accounts[key];
    var linked = false;
    if (account == null) {
      account = _Account(email: key, providers: {AuthProvider.google});
      accounts[key] = account;
    } else if (!account.providers.contains(AuthProvider.google)) {
      // AC-2 Account Linking: อีเมลนี้เคยสมัครแบบปกติ → เชื่อม Google เข้าบัญชีเดิม
      account.providers.add(AuthProvider.google);
      linked = true;
    }
    await _saveAccounts();
    final session = await _startSession(account);
    return GoogleSignInResult(session: session, linked: linked);
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await _delay();
    // ASSUMPTION: ไม่มีอีเมลจริง — นับคำขอไว้เท่านั้น และตอบสำเร็จเสมอไม่ว่ามีบัญชีหรือไม่
    // (ไม่เปิดเผยว่าอีเมลใดมีบัญชี; ux-flow ไม่มีสถานะ error ของ S-3 — ui-spec Q-7)
    passwordResetRequests++;
  }

  @override
  Future<void> resetPassword(String email, String newPassword) async {
    await _delay();
    _checkPassword(newPassword); // AC-3 ปฏิเสธการบันทึกรหัสผ่านสั้น
    final accounts = await _loadAccounts();
    final account = accounts[SignupLogic.normalizeEmail(email)];
    // ASSUMPTION: อีเมลที่ไม่มีบัญชี → ไม่ทำอะไร (ตอบสำเร็จ) แบบเดียวกับ S-3
    if (account == null) return;
    _setPassword(account, newPassword);
    account.providers.add(AuthProvider.email);
    await _saveAccounts();
  }

  @override
  Future<AuthSession> saveProfile(UserProfile profile) async {
    await _delay();
    if (failSaveProfile) throw const AuthNetworkException();
    final session = _session;
    final accounts = await _loadAccounts();
    final account = session == null ? null : accounts[session.email];
    if (session == null || account == null) {
      throw const NotSignedInException();
    }
    // EC-2 / D-c: กันชั้นสุดท้าย — โปรไฟล์ที่ไม่ผ่าน SignupLogic.buildProfile บันทึกไม่ได้
    if (!SignupLogic.isAgeInRange(profile.age)) {
      throw ArgumentError.value(profile.age, 'age',
          'must be ${SignupRules.minAge}-${SignupRules.maxAge}');
    }
    account.profile = profile;
    await _saveAccounts();
    return _session = session.copyWith(profile: profile);
  }

  @override
  Future<void> signOut() async {
    _session = null;
    await _store.write(SignupStorageKeys.session, null);
  }

  // ---------------------------------------------------------------------------

  Future<void> _delay() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
  }

  void _checkPassword(String password) {
    if (!SignupLogic.isPasswordLongEnough(password)) {
      throw ArgumentError(
          'password must be at least ${SignupRules.minPasswordLength} characters');
    }
  }

  Future<AuthSession> _startSession(_Account account) async {
    final session = AuthSession(
      token: _newToken(),
      email: account.email,
      profile: account.profile,
    );
    // AC-8: เก็บ token ไว้ในเครื่อง เปิดแอปใหม่ไม่ต้องเข้าสู่ระบบอีก
    await _store.write(
      SignupStorageKeys.session,
      jsonEncode({'token': session.token, 'email': session.email}),
    );
    return _session = session;
  }

  Future<Map<String, _Account>> _loadAccounts() async {
    final cached = _accounts;
    if (cached != null) return cached;
    final accounts = <String, _Account>{};
    final raw = await _store.read(SignupStorageKeys.accounts);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List;
        for (final item in list) {
          try {
            final a = _Account.fromJson(item as Map<String, dynamic>);
            accounts[a.email] = a;
          } catch (_) {
            // ข้ามรายการที่เสีย
          }
        }
      } catch (_) {
        // ASSUMPTION: ข้อมูลบัญชีในเครื่องเสีย → เริ่มว่าง ไม่ทำให้แอปล่ม
      }
    }
    for (final entry in _seed.entries) {
      accounts.putIfAbsent(entry.key, () => entry.value);
    }
    return _accounts = accounts;
  }

  Future<void> _saveAccounts() async {
    final accounts = await _loadAccounts();
    await _store.write(
      SignupStorageKeys.accounts,
      jsonEncode([for (final a in accounts.values) a.toJson()]),
    );
  }

  /// requirements §6: เก็บรหัสผ่านแบบ hash (SHA-256 + salt ต่อบัญชี) ไม่เก็บตัวจริง
  void _setPassword(_Account account, String password) {
    final salt = base64Url.encode(_randomBytes(16));
    account
      ..salt = salt
      ..passwordHash = _hash(salt, password);
  }

  static String _hash(String salt, String password) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();

  String _newToken() => base64Url.encode(_randomBytes(32));

  List<int> _randomBytes(int n) => [for (var i = 0; i < n; i++) _random.nextInt(256)];
}

=== จบ app/lib/features/signup/signup_repository.dart ===

(app/lib/features/signup/signup_rules.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/signup/widgets/signup_widgets.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/screens/steps_dashboard_screen.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/screens/steps_goal_screen.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/screens/steps_monthly_report_screen.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/steps_controller.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/steps_external.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/steps_logic.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/steps_models.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/steps_repository.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/steps_rules.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/steps/widgets/steps_toast.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/water/screens/monthly_report_screen.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/water/screens/water_home_screen.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/water/water_controller.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/water/water_logic.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/water/water_models.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/water/water_repository.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/water/water_rules.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/features/water/widgets/asset_image_or_icon.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/main.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/shared/pet/pet.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/shared/pet/pet_animation_policy.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/shared/pet/pet_character.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/shared/pet/pet_constants.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/shared/pet/pet_painter.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

(app/lib/shared/pet/pet_pose.dart ไม่ได้ส่ง — เกินเพดาน 300,000 ตัวอักษร)

=== app/test/dashboard/dashboard_controller_test.dart (เฉพาะชื่อ test/group) ===
- group: AC-3 หมุนเวียนทุก alertInterval = 5 วินาที
- test: AC3_starts_at_highest_priority_P2_on_empty_day
- test: AC3_EDGE_rotation_exactly_at_5s_not_4_999s_and_loops
- test: AC3_P1_queue_rotates_P1_P2_P3_back_to_P1
- test: AC3_single_item_queue_stays_on_same_text
- test: AC3_EDGE_empty_queue_no_alert
- group: AC-3 / EC-2 คัดออกจากคิวทันที (Q-17: ไม่รอ 5 วินาที)
- test: EC2_P2_resolved_by_logging_water_switches_to_P3_immediately
- test: DECIDED_Q19_after_removal_next_rotation_counts_5s_anew
- test: EC2_P3_resolved_by_steps_switches_to_P4_immediately
- test: EC2_GR4_P1_removed_while_showing_switches_to_P2_immediately
- test: EC2_last_problem_resolved_queue_empty_alert_hidden
- test: DECIDED_Q3_P4_removed_when_meal_logged_reaches_50
- test: DECIDED_Q19_new_P1_enters_queue_shows_highest_priority
- group: AC-5 / EC-3 ข้าม 05:00 (D-2 เวลาเครื่อง)
- test: AC5_EC3_EDGE_04_59_59_keeps_day_05_00_00_resets_all
- test: EC3_rollover_clears_P1_and_red_bar
- test: AC5_open_after_05_00_with_yesterday_data_shows_new_day
- group: EDGE ข้อมูลว่าง / เสีย / timer
- test: EDGE_first_open_no_data_all_zero_P2_first
- test: EC4_EDGE_corrupt_storage_all_three_fallback_zero
- test: UI_dispose_cancels_alert_timer
=== จบ app/test/dashboard/dashboard_controller_test.dart ===

=== app/test/dashboard/dashboard_logic_test.dart (เฉพาะชื่อ test/group) ===
- group: AC-1 คะแนนรวม = (Food + Steps + Water) / 3
- test: GR3_row1_food60_steps90_water60_total70_bubbly
- test: DECIDED_R3_GR3_row2_EC5_food70_steps60_water67_total65_bubbly
- test: GR3_row3_EC4_food_minus10_steps90_water90_food0_total60_dazed
- test: GR4_EC1_food100_steps100_water160_cap100_cheerful
- test: EC1_all_categories_over_target_snapshot_total_100
- test: DECIDED_R3_EC5_total_is_integer_floor_65_67_and_65_33_to_65
- test: EC4_null_and_negative_category_become_0
- test: EDGE_empty_first_open_all_zero_crying
- test: EDGE_category_min_max_0_and_100_never_outside
- group: D-3 คะแนนรายหมวด
- test: DECIDED_Q14_water_target_8_cups_score_per_cup
- test: DECIDED_D3_steps_ratio_round_and_cap
- test: DECIDED_D3_food_up_to_target_kcal_over_target_x100
- test: DECIDED_D3_food_over_target_100_minus_over_percent
- test: EDGE_D3_food_far_over_target_floor_0_not_negative
- test: DECIDED_D3_Q1_food_no_target_not_scored_total_avg_of_2
- test: DECIDED_Q1_no_target_can_reach_100_cheerful
- test: DECIDED_R3_total_floor_of_floored_category_scores
- test: DECIDED_R3_EDGE_100_only_when_target_reached
- test: DECIDED_R3_Q1_no_target_total_floor_of_half
- group: AC-2 อารมณ์สัตว์เลี้ยง
- test: AC2_EDGE_mood_at_$score
- test: AC2_EDGE_boundaries_via_snapshot_30_31_60_61_80_81
- test: DECIDED_R3_mood_from_floored_total_30_67_is_crying
- test: DECIDED_D1_pose_mapping_PetCharacter
- group: AC-3 คิวข้อความ (trigger / removal)
- test: AC3_exact_strings_4_priorities
- test: AC3_empty_day_queue_P2_P3_P4_in_priority_order
- test: GR3_row1_example_queue_P2_P3_only
- test: AC3_EDGE_P1_overeat_threshold_2100_not_2101_yes
- test: DECIDED_Q2_no_target_never_P1
- test: AC3_EDGE_P2_water_7_cups_in_8_cups_out
- test: AC3_EDGE_P3_steps_99pct_in_100pct_out
- test: DECIDED_D4_EDGE_P4_food_score_49_in_50_out
- test: DECIDED_Q3_P4_no_meal_in_even_with_target
- test: DECIDED_Q3_P4_logged_but_still_below_50_stays
- test: DECIDED_Q3_P4_no_target_only_no_meal_rule
- test: DECIDED_R3_A7_P4_far_over_target_food_score_below_50_not_in_queue
- test: AC3_queue_empty_when_all_resolved
- group: AC-3 / EC-2 การหมุนเวียน (pure)
- test: AC3_next_alert_loops_in_priority_order
- test: EC2_GR4_P1_removed_while_showing_next_is_P2
- test: EC2_last_item_removed_wraps_to_head
- test: EC2_only_item_removed_queue_empty_null
=== จบ app/test/dashboard/dashboard_logic_test.dart ===

=== app/test/dashboard/dashboard_screens_test.dart (เฉพาะชื่อ test/group) ===
- group: AC-4 องค์ประกอบของ S-1
- testWidgets: AC4_total_card_pet_and_three_bars_present
- testWidgets: UI_layout_order_card_alert_pet_food_steps_water
- testWidgets: DECIDED_Q8_header_title
- testWidgets: UI_bar_labels_format_and_bar_value_equals_score
- testWidgets: UI_card_and_bubble_colors_from_color_scheme
- testWidgets: UI_loading_shows_only_progress_indicator
- group: AC-1 คะแนนรวมบนจอ
- testWidgets: AC1_GR3_row1_equivalent_60_100_50_shows_70_bubbly
- testWidgets: DECIDED_R3_EC5_GR3_row2_equivalent_65_67_shows_65_bubbly
- testWidgets: EC4_GR3_row3_negative_food_shows_0_total_60_dazed
- testWidgets: EC1_GR4_over_target_everywhere_capped_100_cheerful
- testWidgets: AC1_EC5_total_text_is_integer_no_decimal
- testWidgets: EDGE_EC4_first_open_empty_all_0_crying_P2
- testWidgets: EC4_EDGE_corrupt_storage_no_crash_all_0
- testWidgets: UI_realtime_update_when_source_changes
- group: AC-2 อารมณ์สัตว์เลี้ยง
- testWidgets: AC2_EDGE_total_${total}_is_$mood
- testWidgets: DECIDED_D1_PetCharacter_size_200_no_png
- testWidgets: DECIDED_Q20_no_cheerTrigger_and_state_kept_on_mood_change
- testWidgets: AC2_animated_cheerful_runs_with_pump_duration
- group: AC-3 ฟองข้อความ
- testWidgets: AC3_rotates_every_5s_P2_P3_P4_P2
- testWidgets: AC3_P1_exact_text_shown_once_red_food_bar_DECIDED_R3_92
- testWidgets: AC3_EDGE_P1_2100_not_red_2101_red
- testWidgets: EC2_resolve_shown_P2_switches_without_waiting
- testWidgets: AC3_EDGE_empty_queue_hides_banner_keeps_slot
- testWidgets: UI_slot_height_constant_and_pet_still_while_rotating
- testWidgets: UI_alert_slot_bottom_12px_above_pet_box
- group: DECIDED_Q1 ไม่มีเป้าอาหาร
- testWidgets: DECIDED_Q1_no_target_label_color_bar0_total_avg2
- group: AC-5 / EC-3 ข้าม 05:00
- testWidgets: AC5_EC3_EDGE_open_04_59_59_then_05_00_00_resets_screen
- testWidgets: AC5_resume_after_05_00_resets
- group: ทางเข้าจาก water
- testWidgets: DECIDED_Q7_entry_button_icon_tooltip_position
- testWidgets: DECIDED_Q7_tap_opens_S1_with_same_controllers_and_back
- group: DECIDED_R3 CTA ตั้งโปรไฟล์
- testWidgets: DECIDED_R3_Q5_no_target_shows_food_cta_under_food_bar
- testWidgets: DECIDED_R3_Q5_with_target_no_cta
- testWidgets: DECIDED_R3_Q5_tap_cta_opens_food_profile_screen
- testWidgets: DECIDED_R3_Q5_360_scale_${scale}_cta_no_overflow
- group: DECIDED_R3 AppBar หน้า water
- testWidgets: DECIDED_R3_Q7_report_button_icon_only_tooltip
- testWidgets: DECIDED_R3_Q7_water_appbar_360_scale_${scale}_no_overflow
- group: จอ 360×640
- testWidgets: UI_360_scale_1_0_via_water_P1_full_no_overflow
- testWidgets: UI_360_scale_1_0_water_appbar_three_icons_no_overflow
- testWidgets: UI_360_scale_1_5_P1_full_no_overflow
- testWidgets: DECIDED_Q1_360_scale_${scale}_no_target_label_no_overflow
- testWidgets: UI_360_scale_1_5_can_scroll_to_water_bar
=== จบ app/test/dashboard/dashboard_screens_test.dart ===

=== app/test/dashboard/dashboard_test_helpers.dart (เฉพาะชื่อ test/group) ===
(ไม่พบชื่อเทสต์)
=== จบ app/test/dashboard/dashboard_test_helpers.dart ===

=== app/test/food/food_controller_test.dart (เฉพาะชื่อ test/group) ===
- group: AC-5..7 เป้าหมายจากโปรไฟล์ (Q-13)
- test: AC5_profile_male_25_target_2000_and_empty_text
- test: AC6_underweight_profile_target_2400
- test: AC7_overweight_profile_target_1600
- test: DECIDED_Q13_existing_profile_does_not_need_S3
- test: DECIDED_Q13_no_profile_needs_S3
- test: DECIDED_Q13_save_from_S3_computes_target_and_closes_setup
- test: AC4_EC5_controller_refuses_decimal_age_nothing_saved
- test: DECIDED_Q14_decimal_weight_height_saved_as_decimal
- group: DECIDED Q-13 โปรไฟล์จาก signup S-6 (SignupFoodProfileSource)
- test: DECIDED_Q13_signup_profile_gives_target_without_S3
- test: DECIDED_Q13_signup_session_without_profile_needs_S3
- test: DECIDED_Q13_S3_saves_back_to_signup_profile_keeps_name_and_goal
- group: DECIDED Q-9 / US-3 ข้ามโปรไฟล์
- test: DECIDED_Q9_skip_shows_cta_no_target
- test: DECIDED_Q9_skipped_never_over_limit_no_toast_no_badge
- test: AC8_cta_total_text_contains_daily_total
- test: US3_skip_is_persisted
- group: GR2 ท่าชั่วคราว EATING 2 วินาที
- test: GR2_log_shows_eating_then_normal_after_exactly_2s
- test: GR3_male_25_from_0_to_1900_normal_after_eating
- test: AC12_no_toast_when_not_over_limit
- group: AC-9 / AC-10 / AC-11 / EC-3 เกินเป้า
- test: AC9_GR3_1950_plus_100_is_2050_normal_not_red
- test: AC9_EDGE_landing_exactly_on_2100_stays_normal
- test: AC10_GR3_2000_plus_150_eating_then_over_limit
- test: AC10_EDGE_landing_on_2101_goes_over_limit
- test: DECIDED_Q5_full_badge_and_red_immediately_during_eating
- test: AC10_loaded_over_limit_shows_over_limit_pose
- test: AC11_GR3_2150_plus_100_feeding_and_toast
- test: EC3_AC11_every_repeated_log_shows_feeding_and_toast
- test: ASSUMPTION_Q3_feeding_returns_to_over_limit_after_2s
- test: ASSUMPTION_7_log_during_eating_after_crossing_counts_as_over_limit
- group: AC-12 / EC-2 Toast 5 วินาที + Queue replace
- test: AC12_toast_visible_until_exactly_5s
- test: EC2_second_log_within_5s_replaces_toast_and_restarts_5s
- test: ASSUMPTION_Q4_rapid_log_restarts_transient_pose
- group: AC-1 / AC-2 / EC-1 ประมวลผลเมนู
- test: AC1_menu_text_parsed_and_logged_with_flags
- test: AC2_range_menu_logs_median
- test: EC1_offline_submit_is_parse_failed_nothing_logged
- test: DECIDED_Q17_unknown_menu_is_parse_failed
- test: EC1_manual_blank_logs_300
- test: EC1_manual_typed_value_logged
- testWidgets: AC1_EDGE_result_at_2_9s_is_used
- testWidgets: AC1_EC1_EDGE_no_result_within_3s_is_failure
- group: AC-3 / Foreground crossing / storage
- test: AC3_log_at_03_00_day_15_stored_date_is_2026_10_14
- test: GR4_refresh_day_at_05_00_resets_to_0_without_reload
- test: GR4_EDGE_midnight_does_not_reset
- test: EDGE_new_day_log_after_over_limit_day_is_eating_no_toast
- test: EDGE_reload_same_day_restores_total
- test: EDGE_reopen_after_05_00_starts_new_day_at_0
- test: EDGE_first_run_empty_storage_starts_at_0_normal
- test: EDGE_corrupted_storage_wrong_types_does_not_crash
- test: EDGE_stored_negative_total_clamped_to_0
- test: EDGE_repository_throws_starts_empty_and_logging_still_works
- test: EDGE_profile_source_throws_treated_as_no_target
- group: R2 DECIDED ค่าที่ Dev เลือก (controller)
- test: DECIDED_R2_Q10_signup_profile_gender_unspecified_is_cta_not_S3
- test: DECIDED_R2_Q10_signup_profile_without_weight_height_is_cta_not_S3
- test: DECIDED_R2_Q8_over_limit_feeding_lasts_2s_then_over_limit
=== จบ app/test/food/food_controller_test.dart ===

=== app/test/food/food_logic_test.dart (เฉพาะชื่อ test/group) ===
- group: GR1 ค่าหลัก game-rules §1
- test: GR1_constants_match_game_rules
- test: GR1_screen_texts_match_ux_flow
- group: AC-3 / US-5 รอบตัดวัน 05:00
- test: AC3_03_00_of_day_15_is_logical_day_14
- test: AC3_EDGE_04_59_59_is_day_14_and_05_00_00_is_day_15
- test: AC3_EDGE_midnight_does_not_start_new_day
- test: AC3_EDGE_month_boundary_1st_04_00_is_last_day_of_previous_month
- test: AC3_log_at_03_00_day_15_entry_date_is_day_14
- test: AC3_EDGE_first_ever_log_at_03_00_day_15_goes_to_day_14
- test: AC3_log_at_05_00_day_15_starts_day_15_from_0
- test: GR4_rollover_at_05_00_resets_to_0_and_keeps_previous_day_in_history
- test: GR4_rollover_under_target_day_is_not_over_target
- test: US5_EDGE_history_keeps_recent_days_and_drops_older_than_7_days
- group: AC-4 / EC-5 อายุจำนวนเต็ม 1–120
- test: AC4_age_25_5_is_rejected
- test: EC5_age_20_5_is_rejected
- test: AC4_EDGE_age_boundaries_0_invalid_1_valid_120_valid_121_invalid
- test: AC4_EDGE_non_integer_texts_rejected
- test: AC4_EDGE_empty_age_is_not_an_error_but_cannot_save
- test: AC4_decimal_age_blocks_save_even_with_other_fields_valid
- test: DECIDED_Q14_weight_and_height_accept_decimals
- group: AC-5 Base Target Reference Table
- test: AC5_male_25_base_target_is_2000
- test: AC5_EDGE_every_band_min_and_max_age_male_and_female
- test: GR5_age_1_to_9_uses_10_12_band_fallback
- test: AC5_male_25_normal_bmi_target_is_2000
- group: AC-6 / AC-7 ปรับตาม BMI
- test: GR1_bmi_formula_weight_over_height_m_squared
- test: AC6_bmi_below_18_5_adds_400
- test: AC6_EDGE_bmi_18_4_adds_400_bmi_18_5_exact_no_bonus
- test: AC7_bmi_at_least_23_subtracts_400
- test: AC7_EDGE_bmi_22_9_no_change_bmi_23_0_exact_subtracts_400
- test: AC6_AC7_adjustment_applies_on_other_bands
- group: AC-9 / AC-10 / EC-3 เกณฑ์ OVER_LIMIT (> target + 100)
- test: GR3_examples_1900_and_2050_normal_2150_over_limit
- test: AC9_EDGE_exactly_target_plus_100_is_normal
- test: AC10_EDGE_target_plus_101_is_over_limit
- test: AC9_EDGE_other_targets_boundary_plus_100_and_plus_101
- test: DECIDED_Q9_no_target_is_never_over_limit
- test: AC11_log_while_over_limit_gives_feeding_and_toast
- test: GR2_log_while_not_over_limit_gives_eating_no_toast
- test: GR2_eating_lasts_2_seconds
- test: ASSUMPTION_Q3_over_limit_feeding_lasts_same_as_eating
- test: GR2_state_codes_match_game_rules
- test: DECIDED_OQ1_states_map_to_PetCharacter_food_poses
- group: หลอดพลังงาน / ข้อความ S-1
- test: UI_calorie_text_format_examples
- test: UI_empty_state_0_of_target
- test: EDGE_energy_fraction_half_and_capped_at_1
- group: AC-1 / AC-2 / EC-1 ผลโภชนาการ
- test: AC1_parse_example_json_from_requirements
- test: AC1_nutrition_toJson_has_three_keys
- test: DECIDED_Q17_local_parser_returns_ac1_json_from_menu_table
- test: DECIDED_Q17_menu_not_in_table_is_parse_failure
- test: AC2_median_of_range
- test: AC2_range_calories_in_json_use_median
- test: ASSUMPTION_AC2_range_as_text_or_min_max_object_use_median
- test: AC2_local_parser_range_menu_item_gives_median
- test: EC1_unreadable_json_is_failure
- test: EC1_manual_blank_defaults_to_300
- test: EC1_manual_value_is_used_as_typed
- group: EDGE เพดาน / ค่าต่ำสุด
- test: EDGE_total_never_below_0_on_negative_calories
- test: EDGE_repeated_logs_accumulate_without_cap
- test: EDGE_first_run_rollover_starts_today_at_0
- group: R2 DECIDED ค่าที่ Dev เลือก (เดิมไม่ได้ assert)
- test: DECIDED_R2_Q2_bmi_not_rounded_18_46_counts_as_underweight
- test: DECIDED_R2_Q2_bmi_not_rounded_22_96_counts_as_normal
- test: DECIDED_R2_Q3_is_over_target_uses_plus_100_threshold
- test: DECIDED_R2_Q4_history_7_days_includes_today
- test: DECIDED_R2_Q6_median_half_rounds_up
- test: DECIDED_R2_Q9_dev_menu_table_values_used
- test: DECIDED_R2_Q11_manual_calories_0_is_accepted
=== จบ app/test/food/food_logic_test.dart ===

=== app/test/food/food_screens_test.dart (เฉพาะชื่อ test/group) ===
- group: S-1 แดชบอร์ด
- testWidgets: UI_S1_add_meal_button_text_per_ux_flow
- testWidgets: ASSUMPTION_Q2_S1_title_proposed
- testWidgets: EDGE_S1_empty_state_0_of_2000_bar_0_normal_pose
- testWidgets: GR3_S1_1900_of_2000_normal_primary_bar
- testWidgets: AC9_S1_2050_of_2000_not_red_normal_pose_no_badge
- testWidgets: AC9_EDGE_S1_2100_exact_threshold_not_red
- testWidgets: AC10_EDGE_S1_2101_red_over_limit_badge
- testWidgets: AC10_S1_2150_red_bar_full_over_limit_pose_full_badge_text
- testWidgets: DECIDED_OQ1_S1_PetCharacter_pose_for_each_state
- testWidgets: GR2_S1_log_shows_eating_then_normal_after_2s
- testWidgets: AC10_DECIDED_Q5_crossing_log_red_and_badge_now_pose_after_2s
- testWidgets: AC11_EC3_log_while_over_limit_feeding_pose_and_toast
- testWidgets: EC3_AC11_toast_shows_again_on_every_repeated_log
- testWidgets: AC12_toast_bottom_is_12px_above_pet_top
- testWidgets: AC12_toast_stays_5s_then_disappears_pet_does_not_move
- testWidgets: EC2_AC12_rapid_logs_within_5s_single_toast_replaced
- testWidgets: EC2_rapid_logs_via_S2_single_toast
- testWidgets: GR4_foreground_crossing_05_00_resets_to_0
- testWidgets: GR4_resume_after_05_00_resets_to_0
- testWidgets: ASSUMPTION_Q1_entry_button_after_steps_before_report_tooltip
- testWidgets: UI_entry_from_water_home_opens_S1
- group: AC-8 / EC-4 CTA Banner
- testWidgets: DECIDED_Q13_no_profile_opens_S3_automatically
- testWidgets: DECIDED_Q13_existing_profile_does_not_open_S3
- testWidgets: DECIDED_Q13_signup_profile_shows_bar_without_S3
- testWidgets: AC8_EC4_skip_shows_cta_banner_text_and_total
- testWidgets: AC8_EC4_cta_banner_same_size_as_energy_widget_no_layout_shift
- testWidgets: GR4_AC8_cta_to_S3_save_replaces_banner_with_bar
- testWidgets: AC8_cta_tap_opens_S3
- testWidgets: DECIDED_Q9_skipped_logging_never_red_no_toast_no_badge
- testWidgets: DECIDED_Q13_skip_persists_S3_not_reopened_on_reentry
- group: S-2 เพิ่มเมนูอาหาร
- testWidgets: UI_S2_hint_submit_text_no_manual_field_in_normal_state
- testWidgets: UI_S2_back_button_returns_to_S1
- testWidgets: AC1_menu_logged_back_to_S1_with_parsed_calories
- testWidgets: AC2_range_menu_logs_median_500
- testWidgets: EC1_offline_switches_to_manual_form_menu_text_kept
- testWidgets: EC1_manual_left_blank_logs_300
- testWidgets: EC1_manual_typed_450_logged
- testWidgets: EC1_EDGE_manual_field_digits_only
- testWidgets: DECIDED_R2_Q11_manual_field_max_5_digits
- testWidgets: DECIDED_R2_Q11_manual_0_is_logged_as_0
- testWidgets: DECIDED_Q17_menu_not_in_local_table_shows_manual_form
- testWidgets: AC1_EC1_EDGE_no_result_within_3s_shows_manual_form
- testWidgets: AC1_EDGE_result_at_2_9s_is_logged
- group: S-3 ตั้งค่าโปรไฟล์
- testWidgets: UI_S3_hints_gender_options_and_button_texts_per_ux_flow
- testWidgets: UI_S3_field_order_age_gender_weight_height
- testWidgets: AC4_EC5_DECIDED_Q14_age_20_5_cannot_be_entered_or_saved
- testWidgets: AC4_DECIDED_Q14_age_25_5_cannot_be_entered_or_saved
- testWidgets: DECIDED_Q14_dot_after_20_is_rejected_field_stays_20
- testWidgets: AC4_EDGE_age_${age}_shows_inline_error_and_blocks_save
- testWidgets: AC4_EDGE_age_${age}_valid_no_error_save_enabled
- testWidgets: DECIDED_Q14_weight_height_accept_decimals
- testWidgets: AC5_save_male_25_normal_bmi_S1_shows_target_2000
- testWidgets: AC6_save_underweight_S1_shows_target_2400
- testWidgets: AC7_save_overweight_S1_shows_target_1600
- testWidgets: AC5_female_30_normal_bmi_target_1600
- testWidgets: UI_S3_skip_button_always_enabled
- testWidgets: UI_S3_no_back_button_in_app_bar
- group: UI อื่น ๆ
- testWidgets: UI_360dp_S1_bar_cta_S2_S3_no_overflow
- testWidgets: UI_360dp_${tag}_S1_bar_over_limit_badge_and_toast_no_overflow
- testWidgets: UI_360dp_${tag}_S1_bar_long_totals_no_overflow
- testWidgets: UI_360dp_${tag}_S1_cta_long_totals_no_overflow
- testWidgets: AC8_DECIDED_D5_360dp_${tag}_cta_total_long_number_not_truncated
- testWidgets: UI_360dp_${tag}_S3_S2_normal_and_manual_no_overflow
- testWidgets: AC8_EC4_360dp_${tag}_switch_cta_to_bar_no_layout_shift
- testWidgets: AC8_EC4_360dp_${tag}_bar_vs_cta_same_slot_pet_button
- testWidgets: DECIDED_D5_energy_slot_at_least_88_and_grows_with_text_scale
- test: DECIDED_OQ1_no_lottie_package_and_no_pet_json_assets_in_food
=== จบ app/test/food/food_screens_test.dart ===

=== app/test/food/food_test_helpers.dart (เฉพาะชื่อ test/group) ===
(ไม่พบชื่อเทสต์)
=== จบ app/test/food/food_test_helpers.dart ===

=== app/test/shared/pet/pet_character_test.dart (เฉพาะชื่อ test/group) ===
- group: §5 preset 7 ท่า
- test: POSE_${e.key}_is_${expr.name}_${body.name}
- testWidgets: PAINT_${e.key}_static_face_${face.name}
- test: POSE_all_7_presets_are_distinct
- test: POSE_equality_and_copyWith
- group: §4 สถานะต่ำ เหงื่อ/ตาปรือ
- testWidgets: LOW_${e.key}_sweat_${low}_droopy_$low
- test: LOW_sparkles_only_on_happy_and_proud_faces
- test: LOW_blink_keeps_mood_but_closes_eyes
- test: LOW_action_faces_override_expression
- group: §3 รูปร่าง
- test: BODY_dimensions_match_character_md_table
- test: BODY_all_5_shapes_have_different_size
- test: BODY_fat_is_widest_and_flattest_lean_is_narrowest
- test: BODY_fat_hides_thighs_and_has_belly_roll
- test: BODY_muscle_has_big_muscle_thighs_others_not
- test: BODY_lean_has_long_thin_thighs
- group: animate: false (ภาพนิ่ง)
- testWidgets: STATIC_no_tickers_no_timers_pumpAndSettle_completes
- testWidgets: STATIC_tap_calls_onTap_but_no_jump
- testWidgets: STATIC_cheerTrigger_change_does_not_animate
- group: animate: true
- testWidgets: ANIM_breathes_and_painter_animated_true
- testWidgets: ANIM_tap_jump_funny_then_none_after_650ms
- testWidgets: ANIM_reactToTap_false_no_jump_but_onTap_called
- testWidgets: ANIM_cheerTrigger_change_cheers_then_ends_after_900ms
- testWidgets: ANIM_cheerTrigger_decrease_also_cheers
- testWidgets: ANIM_same_cheerTrigger_on_rebuild_does_not_cheer
- testWidgets: ANIM_tap_during_cheer_does_not_interrupt
- testWidgets: ANIM_toggle_animate_true_to_false_stops_tickers
- group: กะพริบตา (Random seed)
- testWidgets: BLINK_same_seed_same_blink_timeline
- testWidgets: BLINK_first_blink_within_doc_gap_and_short
- group: dispose
- testWidgets: DISPOSE_animated_pet_leaves_no_tickers_or_timers
- testWidgets: DISPOSE_while_cheering_no_exception
=== จบ app/test/shared/pet/pet_character_test.dart ===

=== app/test/shared/pet/pet_screens_cheer_test.dart (เฉพาะชื่อ test/group) ===
- group: water S-1
- testWidgets: CHEER_water_log_success_increments_trigger_and_pet_cheers
- testWidgets: CHEER_water_3_to_4_cups_cheers_and_switches_to_tired_pose
- testWidgets: CHEER_water_6_to_7_cups_cheers_and_switches_to_happy_pose
- testWidgets: CHEER_water_4_to_5_cups_same_mood_cheers
- testWidgets: STATE_water_3_to_4_cups_pet_state_survives_and_keeps_breathing
- testWidgets: CHEER_water_blocked_by_anti_spam_does_not_cheer
- testWidgets: CHEER_water_after_5_minutes_cheers_again_count_2
- testWidgets: DEFAULT_water_animatePet_null_is_static_under_flutter_test
- group: steps S-1
- testWidgets: CHEER_steps_add_success_increments_trigger_and_pet_cheers
- testWidgets: CHEER_steps_two_adds_count_2
- testWidgets: CHEER_steps_add_crossing_35_percent_cheers_and_shows_chubby
- testWidgets: STATE_steps_crossing_35_percent_pet_state_survives
- testWidgets: CHEER_steps_locked_${status.name}_add_does_not_cheer
- testWidgets: POSE_steps_${steps}_of_8000_is_${pose.id}
=== จบ app/test/shared/pet/pet_screens_cheer_test.dart ===

=== app/test/signup/signup_logic_test.dart (เฉพาะชื่อ test/group) ===
- group: game-rules §1 ค่าหลัก
- test: RULES_game_rules_s1_constants_match_doc
- group: AC-1 / AC-3 ความยาวรหัสผ่าน (min_password_length = 6)
- test: AC1_password_5_chars_abcde_shows_error_and_cannot_submit
- test: AC1_password_1_char_shows_error
- test: AC1_EDGE_password_exactly_6_no_error_can_submit
- test: AC3_new_password_5_rejected_6_accepted
- test: ASSUMPTION_Q3_empty_password_no_error_but_cannot_submit
- group: AC-4 / AC-5 Display Name จากหน้าอีเมล
- test: AC4_empty_display_name_uses_email_local_part
- test: AC4_typed_display_name_is_kept
- test: AC5_alexander_truncates_to_alex_dots_er
- test: AC5_EDGE_email_name_exactly_8_chars_not_truncated
- test: AC5_EDGE_email_name_9_chars_truncated_4_dots_2
- test: AC5_display_for_ui_profile_from_email_alexander
- test: AC5_long_email_name_over_20_shows_first4_dots_last2_of_email_name
- test: DECIDED_Da_email_name_over_20_saved_full_not_capped
- test: DECIDED_Da_EC3_typed_display_name_20_kept_21_capped_to_20
- group: AC-6 / AC-7 คำเตือน (ไม่บล็อกการบันทึก — fallback game-rules §5)
- test: AC6_unspecified_gender_shows_warning_male_female_do_not
- test: AC7_empty_weight_only_warns_weight
- test: AC7_empty_height_only_warns_height
- test: AC6_AC7_warnings_do_not_block_save_values_stay_null
- group: EC-2 ขอบเขตตัวเลข (game-rules §1, §4 — รวมขอบ)
- test: EC2_age_1_and_120_valid
- test: EC2_age_0_and_121_out_of_range
- test: EC2_weight_1_and_300_valid_0_and_301_out_of_range
- test: EC2_weight_float_just_outside_bounds_out_of_range
- test: EC2_height_1_and_250_valid_0_and_251_out_of_range
- test: EC2_any_out_of_range_field_blocks_save
- test: DECIDED_Dc_age_non_integer_text_is_not_valid
- test: DECIDED_Dc_buildProfile_non_integer_age_returns_null
- test: DECIDED_Dc_EDGE_integer_age_25_still_valid
- test: ASSUMPTION_Q11_empty_age_blocks_save
- group: ค่าเริ่มต้น / Onboarding (game-rules §1)
- test: DEFAULT_health_goal_saved_as_dulae_sukkhaphap
- test: ASSUMPTION_Q10_cleared_health_goal_saves_default
- test: ASSUMPTION_unknown_gender_code_falls_back_to_unspecified
- group: การนำทาง (ux-flow §3, AC-2, AC-8)
- test: AC8_route_loading_then_welcome_without_session
- test: AC8_route_home_when_session_with_profile
- test: AC2_route_onboarding_when_google_linked_even_with_profile
- test: UXFLOW_step4_new_account_without_profile_goes_onboarding
=== จบ app/test/signup/signup_logic_test.dart ===

=== app/test/signup/signup_repository_test.dart (เฉพาะชื่อ test/group) ===
- group: AC-2 / EC-5 อีเมลซ้ำ
- test: EC5_signup_with_registered_email_returns_email_in_use
- test: AC2_signup_same_email_twice_second_is_rejected
- test: ASSUMPTION_7_email_duplicate_is_case_insensitive
- test: AC2_google_with_email_registered_normally_links_and_goes_onboarding
- test: AC2_google_link_goes_onboarding_even_if_profile_exists
- group: AC-3 รีเซ็ตรหัสผ่าน
- test: AC3_controller_rejects_5_char_new_password_old_password_still_works
- test: AC3_repository_rejects_short_password
- test: AC3_EDGE_new_password_exactly_6_saved_and_usable
- test: US3_request_password_reset_is_recorded
- test: AC1_repository_rejects_signup_with_5_char_password
- group: AC-4 / US-4 บันทึกโปรไฟล์
- test: AC4_save_without_display_name_stores_email_local_part
- test: US4_save_stores_all_fields
- test: EC2_controller_refuses_out_of_range_profile
- test: DECIDED_Dc_controller_refuses_non_integer_age
- test: DECIDED_Da_long_email_name_saved_full_home_shows_abcd_dots_yz
- group: EC-1 / EC-4 เน็ตหลุด แล้ว Retry
- test: EC1_google_network_error_then_retry_succeeds
- test: EC4_save_network_error_keeps_onboarding_then_retry_saves
- group: AC-8 Session / เปิดแอปใหม่ (US-5)
- test: AC8_reopen_with_same_store_restores_session_and_goes_home
- test: AC8_token_is_stored_on_device_not_empty
- test: REQ6_password_is_stored_hashed_not_plain
- test: EDGE_first_open_empty_storage_goes_welcome
- test: EDGE_corrupt_session_data_goes_welcome_without_crash
- test: EDGE_session_for_missing_account_goes_welcome
- test: EDGE_Dc_stored_fractional_age_not_rounded_on_load
- test: US5_sign_out_clears_session_reopen_goes_welcome
- test: DECIDED_Db_19_session_saved_at_signup_reopen_before_onboarding_goes_onboarding
- group: S-2 โหมดเข้าสู่ระบบ
- test: LOGIN_registered_account_without_profile_goes_onboarding
- test: ASSUMPTION_2_wrong_password_returns_invalid_credentials
=== จบ app/test/signup/signup_repository_test.dart ===

=== app/test/signup/signup_screens_test.dart (เฉพาะชื่อ test/group) ===
- group: S-1 หน้าต้อนรับ
- testWidgets: UI_S1_texts_per_ux_flow_and_first_open_shows_welcome
- testWidgets: UI_S1_email_button_opens_S2_signup_mode
- testWidgets: UI_S1_have_account_link_opens_S2
- group: S-2 สมัครด้วยอีเมล
- testWidgets: UI_S2_hints_and_initial_state_button_disabled_no_error
- testWidgets: AC1_password_abcde_shows_error_immediately_button_disabled
- testWidgets: AC1_EDGE_password_6_chars_no_error_button_enabled
- testWidgets: UXFLOW_happy_path_signup_goes_to_onboarding_S6
- testWidgets: AC2_EC5_registered_email_shows_email_in_use_stays_on_S2
- testWidgets: ASSUMPTION_Q4_email_in_use_error_clears_when_email_edited
- testWidgets: ASSUMPTION_Q15_loading_spinner_and_disabled_while_submitting
- testWidgets: ASSUMPTION_3_S2_network_error_dialog_retry_succeeds
- testWidgets: UI_S2_back_button_returns_to_S1
- group: S-3 / S-4 / S-5 ลืมรหัสผ่าน (US-3)
- testWidgets: US3_forgot_flow_S2_to_S3_to_S4_and_back_to_S2
- testWidgets: UI_S3_back_button_returns_to_S2
- testWidgets: UI_S5_texts_and_initial_disabled
- testWidgets: AC3_new_password_5_chars_shows_warning_and_save_rejected
- testWidgets: AC3_EDGE_new_password_6_chars_saves_and_goes_S2_with_message
- group: S-1 Google Login (US-2, AC-2, EC-1)
- testWidgets: AC2_google_with_registered_email_links_and_goes_onboarding
- testWidgets: EC1_google_network_error_shows_retry_then_retry_succeeds
- testWidgets: EC1_retry_while_still_offline_shows_retry_again
- testWidgets: ASSUMPTION_Q16_retry_dialog_texts
- group: S-6 Onboarding
- testWidgets: UI_S6_texts_and_defaults_gender_unspecified_goal_default
- testWidgets: AC6_select_unspecified_shows_warning_male_hides_it
- testWidgets: AC7_empty_weight_warns_only_under_weight
- testWidgets: AC7_empty_height_warns_only_under_height
- testWidgets: AC6_AC7_warnings_do_not_block_save
- testWidgets: EC2_age_0_shows_error_and_blocks_save
- testWidgets: EC2_EDGE_age_120_ok_121_error
- testWidgets: EC2_EDGE_age_1_ok
- testWidgets: EC2_EDGE_weight_300_ok_301_error
- testWidgets: EC2_EDGE_weight_1_ok_0_error
- testWidgets: EC2_EDGE_height_250_ok_251_error
- testWidgets: EC2_EDGE_height_1_ok_0_error
- testWidgets: DECIDED_Dc_age_field_rejects_"$input"_not_changed_cannot_save
- testWidgets: DECIDED_Dc_age_field_existing_30_then_paste_2_5_never_saves_25
- testWidgets: DECIDED_Dc_EDGE_age_field_integer_25_saves_25
- testWidgets: DECIDED_Da_EC3_typed_20_char_name_saved_as_typed
- testWidgets: EC3_display_name_20_chars_accepted_21st_blocked
- testWidgets: EC4_save_network_error_shows_retry_and_keeps_all_values
- testWidgets: EC4_retry_after_network_back_saves_and_goes_home
- group: S-7 Home + AC-4/AC-5/AC-8
- testWidgets: AC4_AC5_empty_display_name_alexander_banner_shows_alex_dots_er
- testWidgets: AC5_EDGE_email_name_8_chars_banner_shows_full_name
- testWidgets: DECIDED_Da_long_email_name_banner_abcd_dots_yz_repo_stores_full
- testWidgets: AC8_reopen_app_skips_login_and_shows_home
- testWidgets: UI_auth_loading_spinner_while_reading_token
- testWidgets: EDGE_corrupt_stored_session_opens_S1_without_crash
- testWidgets: REGRESSION_no_signup_controller_goes_straight_to_water
=== จบ app/test/signup/signup_screens_test.dart ===

=== app/test/steps/steps_controller_test.dart (เฉพาะชื่อ test/group) ===
- group: AC-1 (MVP: เพิ่มก้าวด้วยมือ ui-spec D-1)
- test: AC1_add_steps_increments_by_steps_per_tap_and_persists
- test: AC1_add_before_load_is_ignored
- group: EC-1 / EC-6 ล็อกการนับก้าว
- test: EC1_EC6_${status.name}_locks_step_counting
- test: EC1_unlock_after_permission_granted_allows_counting
- group: AC-2 / AC-3 / S-2 Error ผ่าน controller
- test: AC2_saved_goal_written_to_storage_and_used_for_percent
- test: AC3_second_save_same_day_not_written
- test: S2_error_storage_failure_keeps_goal_and_quota_then_retry_works
- group: EC-2 ดึงค่าล่าสุดจาก Local Storage
- test: EC2_reload_same_day_shows_last_saved_steps
- test: EC2_AC6_reopen_after_05_00_starts_new_day_at_0
- test: EC2_reopen_at_04_59_59_still_previous_day_steps
- test: REQ7_pet_status_enum_stored_with_doc_codes
- group: EDGE ข้อมูลว่าง / ข้อมูลเสีย
- test: EDGE_first_run_empty_storage_shows_initial_state
- test: EDGE_corrupted_storage_wrong_types_does_not_crash
- test: EDGE_corrupted_history_items_skipped_valid_items_kept
- test: EDGE_stored_negative_steps_clamped_to_0
- test: EDGE_ASSUMPTION_stored_goal_outside_6000_15000_falls_back_to_default
- test: EDGE_repository_throws_starts_empty_without_crash
- group: AC-6 / EC-5 ผ่าน controller
- test: EC5_refresh_day_resets_at_05_00_00_without_reload
- group: AC-7 export ผ่าน controller
- test: AC7_export_passes_png_bytes_to_exporter
- test: AC7_export_failure_throws_for_ui_error_state
=== จบ app/test/steps/steps_controller_test.dart ===

=== app/test/steps/steps_logic_test.dart (เฉพาะชื่อ test/group) ===
- group: game-rules §1 ค่าหลัก
- test: GR1_constants_match_game_rules
- test: AC2_goal_options_are_the_three_groups_from_ux_flow
- group: AC-5 % Goal → สถานะ
- test: AC5_percent_formula_game_rules_example_2800_of_8000_is_35
- test: AC5_percent_not_capped_8500_of_8000_is_106_25
- test: AC5_status_for_percent_exact_boundaries
- test: EDGE_threshold_plus_minus_1_step_goal_8000
- test: EDGE_threshold_plus_minus_1_step_every_goal_option
- test: AC5_enum_codes_thai_labels_and_poses_per_docs
- test: AC5_pose_at_thresholds_2799_2800_5599_5600_7999_8000_of_8000
- group: ข้อความ S-1
- test: S1_count_text_format_ux_flow_example_5500_of_8000
- test: S1_percent_text_examples_from_ui_spec
- test: ASSUMPTION_Q7_percent_truncated_never_shows_100_while_lean
- group: EDGE max/min
- test: EDGE_energy_bar_capped_at_1_while_percent_exceeds_100
- test: EDGE_add_zero_or_negative_steps_never_decreases_below_0
- test: EDGE_goal_bounds_6000_15000_accepted_outside_rejected
- test: EDGE_invalid_goal_rejected_and_quota_not_consumed
- test: EDGE_quota_never_below_0
- group: AC-6 ตัดรอบ 05:00:00
- test: AC6_logical_day_changes_exactly_at_05_00_00
- test: AC6_game_rules_example_8500_resets_to_0_at_05_00_00
- test: AC6_midnight_does_not_reset
- test: AC6_previous_day_kept_in_history_after_reset
- test: AC6_several_days_closed_resets_to_0
- test: AC6_steps_added_after_05_00_count_only_for_new_day
- test: EDGE_first_run_no_data_starts_day_with_0_steps
- group: AC-2/AC-3/AC-4 เป้าหมาย
- test: AC2_ASSUMPTION_first_goal_new_user_applies_immediately
- test: AC2_every_goal_option_can_be_saved
- test: AC3_second_change_same_day_is_rejected
- test: AC3_quota_still_used_at_04_59_59_and_resets_at_05_00_00
- test: AC4_change_after_05_00_applies_from_next_day_05_00
- test: ASSUMPTION_AC2_change_before_05_00_applies_immediately
- group: EC-3 นาฬิกาย้อน
- test: EC3_clock_back_before_cutoff_does_not_reset_steps
- test: EC3_clock_back_does_not_restore_goal_quota
- test: EC3_clock_back_does_not_overwrite_previous_day_history
- test: EC3_real_cutoff_after_clock_back_still_resets
- group: AC-7 รายงานรายเดือน
- test: AC7_four_values_total_steps_water_average_goal_days
- test: AC7_goal_day_boundary_7999_not_counted_8000_counted
- test: AC7_month_follows_05_00_cutoff
- test: EDGE_empty_report_all_zero
- test: ASSUMPTION_Q6_average_divides_by_days_with_steps
- test: ASSUMPTION_Q7_goal_days_use_goal_of_that_day
- test: AC7_report_file_is_png
=== จบ app/test/steps/steps_logic_test.dart ===

=== app/test/steps/steps_screens_test.dart (เฉพาะชื่อ test/group) ===
- group: S-1 แดชบอร์ด
- testWidgets: UI_S1_texts_and_buttons_per_ux_flow
- testWidgets: UI_S1_ASSUMPTION_Q1_add_button_label_and_icon
- testWidgets: EDGE_S1_empty_first_run_0_steps_0_percent_fat
- testWidgets: AC1_tap_add_increases_steps_realtime
- testWidgets: AC5_tap_add_crosses_35_percent_changes_pet_immediately
- testWidgets: EDGE_AC5_S1_${steps}_of_8000_shows_${status.name}
- testWidgets: EDGE_S1_over_100_bar_full_text_106_25
- testWidgets: EC5_AC6_foreground_crossing_05_00_resets_without_restart
- testWidgets: EC1_EC6_${status.name}_popup_settings_shortcut_and_lock
- testWidgets: EC1_ASSUMPTION_Q4_popup_proposed_texts
- testWidgets: S1_disabled_offline_icon_and_last_stored_values
- testWidgets: UI_S1_navigation_to_S2_and_S3_and_back
- testWidgets: UI_D3_entry_from_water_home_opens_S1
- group: S-2 ตั้งเป้าหมาย
- testWidgets: UI_S2_title_chips_and_save_button_texts_per_ux_flow
- testWidgets: UI_S2_ASSUMPTION_Q9_group_headers
- testWidgets: EDGE_S2_first_entry_8000_preselected_only
- testWidgets: S2_only_one_chip_selected_across_groups
- testWidgets: AC2_save_new_goal_updates_S1_percent_immediately
- testWidgets: AC3_after_save_button_disabled_and_tap_shows_quota_toast
- testWidgets: AC3_ASSUMPTION_Q11_reenter_S2_shows_toast_and_chips_locked
- testWidgets: S2_error_toast_on_save_failure_retry_allowed
- testWidgets: AC4_change_after_05_00_applies_next_day_05_00_on_S1
- testWidgets: AC3_quota_resets_at_05_00_save_enabled_again
- group: S-3 รายงานรายเดือน
- testWidgets: UI_S3_title_labels_and_export_button_per_ux_flow
- testWidgets: AC7_S3_card_shows_four_values_from_storage
- testWidgets: EDGE_S3_empty_month_zero_values_and_empty_text
- testWidgets: AC7_export_png_of_report_area_saved_once
- testWidgets: S3_exporting_button_disabled_with_spinner_text
- testWidgets: S3_export_error_dialog_and_retry_succeeds
- testWidgets: S3_capture_failure_shows_error_dialog
- testWidgets: S3_load_failure_shows_error_dialog_retry_recovers
- group: UI จอ 360 dp
- testWidgets: UI_360dp_S1_S2_S3_no_overflow
=== จบ app/test/steps/steps_screens_test.dart ===

=== app/test/water/water_controller_test.dart (เฉพาะชื่อ test/group) ===
- group: Controller
- test: AC1_controller_log_adds_1_cup_and_12_5_percent
- test: AC3_AC4_controller_blocks_10_03_allows_10_05
- test: EC3_controller_rapid_taps_without_await_log_only_once
- test: AC5_controller_refresh_at_05_00_resets_to_0
- test: EC2_controller_load_after_05_00_resets_and_saves_0
- test: EDGE_first_open_empty_storage_0_cups_critical
- group: Local Storage (SharedPreferences) requirements §7
- test: STORAGE_save_uses_keys_from_requirements_section_7
- test: STORAGE_data_survives_reopen_same_day
- test: EC2_storage_reopen_next_day_after_05_00_shows_0
- test: EDGE_antispam_across_05_00_survives_app_restart
- test: EDGE_corrupted_history_json_does_not_crash_starts_fresh
- test: EDGE_corrupted_history_item_missing_fields_starts_fresh
- test: EDGE_corrupted_timestamp_treated_as_never_logged
- test: EDGE_missing_count_key_defaults_to_0
- test: EDGE_negative_stored_count_clamped_to_0
=== จบ app/test/water/water_controller_test.dart ===

=== app/test/water/water_decisions_logic_test.dart (เฉพาะชื่อ test/group) ===
- group: ข้อตัดสิน 1: ขอบเดือน AC-6 (00:00–04:59 ของวันที่ 1 = วันสุดท้ายของเดือนก่อน)
- test: AC6_log_04_59_on_1st_goes_to_history_as_last_day_of_previous_month
- test: AC6_log_05_00_on_1st_goes_to_history_as_new_month
- test: AC6_log_04_59_then_05_04_on_1st_split_into_two_months
- test: AC6_report_at_04_59_on_1st_is_previous_month
- test: AC6_report_at_05_00_on_1st_is_new_month
- test: AC6_year_boundary_01_01_04_59_is_december_previous_year
- group: ข้อตัดสิน 2: นาฬิกาย้อนกลับ (game-rules §4)
- test: EDGE_clock_back_to_previous_calendar_day_no_reset_same_day
- test: EDGE_clock_back_before_05_00_same_date_no_reset
- test: EDGE_clock_back_1_second_no_crash_no_reset
- test: EDGE_clock_back_log_attempt_does_not_delete_data_and_counts_same_day
- test: EDGE_clock_back_monthly_report_uses_same_day_as_last_log
- test: EDGE_clock_back_then_forward_next_day_after_05_00_resets_normally
- group: ข้อตัดสิน 4: วันที่หน้าประวัติ dd/MM/yyyy (ux-flow S-2)
- test: UI_history_date_format_dd_MM_yyyy_with_leading_zeros
- group: ข้อตัดสิน 5: อารมณ์ 0–3 / 4–6 / 7+ (game-rules §2) ขอบ 3/4 และ 6/7
- test: EDGE_mood_ranges_all_values_0_to_12
=== จบ app/test/water/water_decisions_logic_test.dart ===

=== app/test/water/water_decisions_screens_test.dart (เฉพาะชื่อ test/group) ===
- group: ข้อตัดสิน 5: ภาพสัตว์เลี้ยงตามอารมณ์ (PetCharacter) ขอบ 3/4 และ 6/7
- testWidgets: EDGE_S1_pet_mood_0_cups_critical
- testWidgets: AC2_S1_pet_mood_3_cups_critical_then_4_cups_tired
- testWidgets: EDGE_S1_pet_mood_6_cups_tired_then_7_cups_happy
- testWidgets: EDGE_S1_pet_mood_after_05_00_reset_back_to_critical
- group: ข้อตัดสิน 4: วันที่หน้าประวัติ dd/MM/yyyy
- testWidgets: UI_S2_history_dates_shown_as_dd_MM_yyyy
- group: ข้อตัดสิน 1: ขอบเดือน AC-6 บนหน้า S-2
- testWidgets: AC6_S2_log_04_59_on_1st_shown_as_31_10_in_october_report
- testWidgets: AC6_S2_log_05_00_on_1st_shown_as_01_11_in_november_report
- testWidgets: AC6_S2_open_at_05_00_on_1st_with_only_october_data_is_empty
- group: ข้อตัดสิน 2: นาฬิกาย้อนกลับ บนหน้าจอ
- testWidgets: EDGE_S1_clock_back_opens_without_crash_and_keeps_cups
- testWidgets: EDGE_S1_clock_back_tap_no_crash_and_no_data_loss
- testWidgets: EDGE_S2_clock_back_report_shows_month_of_last_log
- group: ข้อตัดสิน 3: ข้อมูลเสีย/ผิดชนิด บนหน้าจอ
- testWidgets: EDGE_S1_bad_type_prefs_opens_empty_state_no_crash
- testWidgets: EDGE_S2_bad_history_prefs_shows_empty_report_no_crash
=== จบ app/test/water/water_decisions_screens_test.dart ===

=== app/test/water/water_decisions_storage_test.dart (เฉพาะชื่อ test/group) ===
- group: ข้อตัดสิน 1: ขอบเดือน AC-6 ผ่าน controller
- test: AC6_controller_log_04_59_on_1st_report_shows_previous_month
- test: AC6_controller_report_at_05_00_on_1st_switches_to_new_month
- test: AC6_storage_history_key_saves_04_59_as_previous_day
- group: ข้อตัดสิน 2: นาฬิกาย้อนกลับ ผ่าน controller + storage
- test: EDGE_clock_back_open_app_no_crash_no_reset_keeps_data
- test: EDGE_clock_back_refresh_and_log_do_not_delete_stored_history
- test: EDGE_clock_back_monthly_report_is_month_of_last_log
- test: EDGE_clock_back_then_restored_same_day_keeps_cups
- group: ข้อตัดสิน 3: ข้อมูลเสีย/ผิดชนิดใน SharedPreferences → ค่าว่าง ไม่ crash
- test: EDGE_bad_type_count_as_string_starts_0_no_crash
- test: EDGE_bad_type_count_as_double_starts_0_no_crash
- test: EDGE_bad_type_count_as_bool_starts_0_no_crash
- test: EDGE_bad_type_timestamp_as_int_treated_empty_can_log
- test: EDGE_bad_type_history_as_int_starts_empty
- test: EDGE_bad_type_history_as_string_list_starts_empty
- test: EDGE_bad_type_history_json_object_not_list_starts_empty
- test: EDGE_bad_type_history_item_cups_as_string_starts_empty
- test: EDGE_bad_type_history_item_null_fields_starts_empty
- test: EDGE_all_keys_bad_type_starts_empty_state
- test: EDGE_bad_type_after_recovery_log_saves_correct_types
- test: EDGE_repository_load_throws_controller_starts_empty_no_crash
- test: EDGE_prefs_instance_fails_repository_returns_empty
=== จบ app/test/water/water_decisions_storage_test.dart ===

=== app/test/water/water_logic_test.dart (เฉพาะชื่อ test/group) ===
- group: AC-1 กด + แล้ว +1 แก้ว และพลังงาน +12.5% (game-rules §1, §3)
- test: AC1_first_log_of_day_0_to_1_cup_12_5_percent
- test: AC1_energy_formula_cups_x_12_5_for_0_to_8_cups
- test: AC1_each_successful_log_adds_exactly_1_cup_and_12_5_percent
- group: AC-2 สถานะสัตว์เลี้ยงตามช่วง (requirements §2, game-rules §2)
- test: AC2_3_cups_critical_then_4_cups_tired_immediately
- test: EDGE_threshold_0_and_3_critical_4_tired
- test: EDGE_threshold_6_tired_7_happy_8_happy
- test: AC2_mood_poses_match_game_rules_section_2_and_character_md
- group: AC-3 / AC-4 Anti-Spam 1 แก้วต่อ 5 นาที
- test: AC3_log_10_00_then_10_03_is_blocked_and_cups_unchanged
- test: AC4_log_10_00_then_10_05_is_allowed_and_last_log_is_10_05
- test: EDGE_threshold_4m59s_blocked_5m00s_allowed_6m_allowed
- test: EDGE_blocked_attempt_does_not_restart_5_minute_window
- test: EC3_rapid_taps_only_first_is_logged
- group: AC-5 / EC-2 รีเซ็ตเวลา 05:00 น.
- test: AC5_5_cups_at_04_59_stay_5_then_reset_to_0_at_05_00
- test: EDGE_midnight_is_not_reset_boundary
- test: EDGE_log_23_58_then_00_01_blocked_00_03_counts_on_same_day
- test: EC2_device_off_overnight_across_05_00_resets_on_open
- test: EC2_device_off_several_days_resets_on_open
- test: EDGE_after_05_00_reset_first_log_starts_from_1_cup
- test: EDGE_reset_keeps_previous_day_in_history
- test: EDGE_antispam_across_05_00_log_04_58_tap_05_01_blocked
- test: EDGE_antispam_across_05_00_05_02_59_blocked_05_03_allowed
- group: EC-1 / ค่าติดเพดาน max/min
- test: EC1_12_cups_bar_stops_at_100_but_count_is_12
- test: EDGE_cap_8_cups_exactly_100_and_9_cups_still_100
- test: EDGE_min_0_cups_is_0_percent_never_negative
- test: EDGE_count_keeps_increasing_past_cap_9_to_10
- group: AC-6 รายงานรายเดือน (ค่าเฉลี่ยทศนิยม 1 ตำแหน่ง)
- test: AC6_average_5_and_4_over_2_logged_days_is_4_5
- test: AC6_days_without_logs_are_not_in_divisor
- test: AC6_average_one_decimal_13_over_3_is_4_3
- test: AC6_average_one_decimal_20_over_3_is_6_7
- test: AC6_whole_number_average_shows_one_decimal_8_0
- test: AC6_other_months_are_excluded
- test: AC6_history_list_has_date_and_cups_per_day_sorted
- test: EDGE_empty_history_average_0_0_and_empty
- group: Edge 4 เปิดแอปครั้งแรก (ux-flow §4 S-1 ว่าง)
- test: EDGE_first_open_initial_state_0_cups_0_percent_critical
- test: EDGE_first_ever_log_is_allowed_without_previous_timestamp
=== จบ app/test/water/water_logic_test.dart ===

=== app/test/water/water_pet_character_test.dart (เฉพาะชื่อ test/group) ===
- group: S-1 ขอบสถานะ (game-rules §2) แสดงท่าของ PetCharacter
- testWidgets: POSE_S1_${cups}_cups_shows_${mood.name}
- testWidgets: POSE_S1_3_to_4_cups_switches_critical_to_tired
- testWidgets: POSE_S1_6_to_7_cups_switches_tired_to_happy
- testWidgets: POSE_S1_after_05_00_reset_happy_back_to_critical
- group: PNG สัตว์เลี้ยงเดิม (legacy) ไม่ถูกใช้/ไม่ถูก bundle
- test: LEGACY_files_kept_in_assets_images_legacy
- test: LEGACY_no_pet_png_in_top_level_assets_images
- test: LEGACY_pubspec_does_not_register_legacy_or_pet_png
- test: LEGACY_lib_has_no_pet_png_reference
- testWidgets: LEGACY_asset_manifest_has_no_pet_png_and_load_fails
=== จบ app/test/water/water_pet_character_test.dart ===

=== app/test/water/water_screens_test.dart (เฉพาะชื่อ test/group) ===
- group: S-1 หน้าจอหลัก
- testWidgets: UI_S1_button_label_and_plus_icon_per_ux_flow
- testWidgets: EDGE_S1_first_open_shows_0_cups_0_percent_critical
- testWidgets: AC1_S1_tap_plus_shows_1_cup_and_12_5_percent
- testWidgets: AC2_S1_3_to_4_cups_status_changes_critical_to_tired
- testWidgets: EDGE_S1_6_to_7_cups_status_changes_tired_to_happy
- testWidgets: AC3_S1_tap_within_5_min_shows_toast_and_count_unchanged
- testWidgets: AC3_S1_toast_disappears_2s_after_fully_shown_excluding_animation
- testWidgets: AC4_S1_tap_after_5_min_logs_successfully
- testWidgets: EC3_S1_rapid_double_tap_logs_once_and_shows_toast
- testWidgets: AC5_S1_open_app_after_05_00_shows_0_cups_0_percent
- testWidgets: AC5_S1_open_at_04_59_still_shows_5_cups
- testWidgets: AC5_S1_app_left_open_across_05_00_resets_on_screen
- testWidgets: EDGE_S1_log_04_58_tap_05_01_shows_toast_after_reset
- testWidgets: EC1_S1_12_cups_bar_full_100_but_count_12
- group: S-2 รายงานรายเดือน
- testWidgets: UI_S2_open_from_S1_shows_header_and_back_returns
- testWidgets: AC6_S2_average_4_5_and_daily_history_list
- testWidgets: EDGE_S2_empty_history_shows_empty_text_and_0_0
=== จบ app/test/water/water_screens_test.dart ===

=== ข้อมูลจาก log ของฟีเจอร์นี้ (ใช้ทำตารางผลวัด agent) ===
- 20261030-1313_product_dashboard.md: role=product, feature=dashboard, time=2026-10-30 13:13, status=ok, provider=gemini, model=gemini-3.5-flash-lite, attempts=1, seconds=9.8, llm_calls=1, total_tokens=3162, agent_version=75d978ad
- 20261030-1421_design_dashboard.md: role=design, feature=dashboard, time=2026-10-30 14:21, status=ok, provider=gemini, model=gemini-3.5-flash-lite, attempts=1, seconds=13.2, llm_calls=2, total_tokens=13713, agent_version=18116912
- 20261030-1626_design_dashboard.md: role=design, feature=dashboard, time=2026-10-30 16:26, status=ok, provider=gemini, model=gemini-3.5-flash-lite, attempts=1, seconds=13.5, llm_calls=2, total_tokens=14452, agent_version=0a643e01
- 20261030-1650_design_dashboard.md: role=design, feature=dashboard, time=2026-10-30 16:51, status=ok, provider=gemini, model=gemini-3.5-flash-lite, attempts=1, seconds=58.1, llm_calls=2, total_tokens=14156, agent_version=0a643e01
- 20261030-1757_design_review_dashboard.md: role=design_review, feature=dashboard, time=2026-10-30 17:57, status=ok, provider=gemini, model=gemini-3.5-flash-lite, attempts=1, seconds=7.0, llm_calls=1, total_tokens=13484, agent_version=ac395134

ให้เขียนตามโครงของ template นี้ (แทนที่ข้อความใน <...> ด้วยเนื้อหาจริง):
=== template: docs/_templates/review.md ===
# Review: <ชื่อฟีเจอร์> (<feature>)

> ผู้ตรวจ: Reviewer agent · ตรวจทานโดย: <ชื่อเพื่อน C> · ไฟล์ที่ตรวจ: <รายชื่อไฟล์ใน docs/ และ app/>

## 1. Checklist
<เกณฑ์ "พร้อมส่ง Dev" ของทีม (docs/SETUP_CREWAI.md ข้อ 11) — ตอบทีละข้อพร้อมเหตุผลสั้น ๆ
ถ้าไฟล์ที่ต้องใช้ตรวจยังไม่มี ให้ตอบ "ตรวจไม่ได้">

| # | หัวข้อ | ผล (ผ่าน/ไม่ผ่าน/ตรวจไม่ได้) | เหตุผล |
|---|---|---|---|
| 1 | user story รูปแบบ ในฐานะ/ฉันอยาก/เพื่อ | <ผล> | <เหตุผล> |
| 2 | acceptance criteria เป็นตัวเลข/เงื่อนไขที่ทดสอบได้ และอ้าง US | <ผล> | <เหตุผล> |
| 3 | มี edge cases พร้อมผลที่คาดหวัง | <ผล> | <เหตุผล> |
| 4 | มีสิ่งที่ไม่ทำในรอบนี้ | <ผล> | <เหตุผล> |
| 5 | กติกาเกมเป็นตารางตัวเลขครบ รวมพฤติกรรมที่ขอบเขต | <ผล> | <เหตุผล> |
| 6 | ตัวเลขตรงกันทุกไฟล์ | <ผล> | <เหตุผล> |
| 7 | ทุกหน้าจอโยงกับ US และมีสถานะผิดพลาด/ว่าง | <ผล> | <เหตุผล> |
| 8 | มีชื่อไฟล์ภาพ assets ครบทุกสถานะ | <ผล> | <เหตุผล> |
| 9 | ใช้ข้อมูลสมมติ ไม่มีคำแนะนำทางการแพทย์ | <ผล> | <เหตุผล> |
| 10 | ขอบเขตทำทันเวลา | <ผล> | <เหตุผล> |

## 2. รีวิวโค้ดใน app/ (ถ้ามี)
<โค้ดใน app/lib/ ทำตาม AC และตัวเลขใน game-rules.md หรือไม่ และเทสต์ใน app/test/ ครอบคลุม AC ใดบ้าง — ถ้ายังไม่มีโค้ด เขียนว่า "ยังไม่มีโค้ด">

## 3. ปัญหาที่พบ
<หนึ่งแถวต่อหนึ่งปัญหา ต้องระบุพอให้เจ้าของงานแก้ได้ทันที>

| # | ความรุนแรง (สูง/กลาง/ต่ำ) | ไฟล์ / หัวข้อ | ปัญหา | ข้อเสนอแก้ |
|---|---|---|---|---|
| 1 | <ระดับ> | <ไฟล์ § หัวข้อ> | <ผิดอย่างไร> | <ควรแก้อย่างไร> |

## 4. ตารางผลวัด agent
<ใช้ข้อมูลจากไฟล์ใน logs/ เท่านั้น ช่องที่ไม่มีข้อมูลให้ใส่ "-" ห้ามแต่งตัวเลข
คอลัมน์ "ต้องแก้มือ" ให้คนกรอกเอง>

| ไฟล์ log | บทบาท | agent เวอร์ชัน | ผู้ให้บริการ / รุ่น | สถานะ | เวลา (วินาที) | จำนวนเรียก LLM | tokens | ต้องแก้มือ (คนกรอก) |
|---|---|---|---|---|---|---|---|---|
| <ชื่อไฟล์> | <บทบาท> | <hash> | <ผู้ให้บริการ / รุ่น> | <ok/fail> | <ตัวเลข> | <ตัวเลข> | <ตัวเลข> | - |

## 5. สรุป
**ผล: <พร้อมส่ง Dev / ต้องแก้>**

สิ่งที่ต้องแก้ก่อนส่ง Dev:
- <รายการ หรือ "ไม่มี">

=== จบ template ===

กฎ: ตอบเป็น Markdown ภาษาไทยเท่านั้น ไม่ต้องห่อด้วย ``` ไม่ต้องมีคำเกริ่นหรือคำลงท้าย ข้อมูลสุขภาพ/ข้อมูลผู้ใช้ทั้งหมดต้องเป็นข้อมูลสมมติ

This is the expected criteria for your final answer: เนื้อหาไฟล์ docs/dashboard/review.md ฉบับสมบูรณ์ ตามโครง template
you MUST return the actual complete content as the final answer, not a summary.

Provide your complete response:
~~~~

### LLM call 1 — คำตอบ

~~~~text
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
~~~~

### ผลลัพธ์ → docs/dashboard/review.md

~~~~text
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
~~~~
