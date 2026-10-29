# Log: design_review · steps · 2026-10-12 18:15

<!-- meta: {"role": "design_review", "feature": "steps", "time": "2026-10-12 18:15", "status": "ok", "provider": "gemini", "model": "gemini-3.5-flash-lite", "attempts": 1, "seconds": 9.6, "llm_calls": 1, "total_tokens": 10976, "agent_version": "97463b8c"} -->

| รายการ | ค่า |
|---|---|
| สถานะ | สำเร็จ |
| ผู้ให้บริการ / รุ่น | gemini / gemini-3.5-flash-lite |
| ลำดับความพยายาม | gemini: สำเร็จ |
| เวลารวม | 9.6 วินาที |
| จำนวนครั้งที่เรียก LLM | 1 |
| tokens (prompt / completion / total) | 8946 / 2030 / 10976 |
| ไฟล์ input | docs/steps/requirements.md, docs/steps/ux-flow.md, docs/steps/game-rules.md |
| ไฟล์ output | docs/steps/design-review.md |
| agent | agents/design_reviewer.md (เวอร์ชัน 97463b8c) |
| --note | ตรวจเอกสารต้นฉบับทั้งสามไฟล์ใหม่ทั้งหมด ห้ามยึดผล PASS จากรายงานเดิมโดยไม่มีหลักฐาน ตรวจข้อค้นพบเดิมเรื่องชื่อสถานะสัตว์เลี้ยง เงื่อนไขเวลาเปลี่ยนเป้าหมาย และ AC-1 กับ S-1 ทีละข้อ ระบุว่าแก้แล้ว ไม่พบซ้ำ หรือยังยืนยันไม่ได้ พร้อมหลักฐานจากไฟล์และหัวข้อจริง ตรวจ Open Questions ว่ามีหลักฐานยืนยันว่าไม่บล็อกการพัฒนาหรือไม่ ห้ามแต่งข้อกำหนดหรือตัวเลข และห้ามแก้เอกสารต้นฉบับ สรุปให้ชัดว่า พร้อมส่ง Dev, ต้องแก้ หรือหลักฐานไม่เพียงพอ |

## ความพยายามที่ 1 — gemini (gemini-3.5-flash-lite) — สำเร็จ, 9.6 วินาที

### Agent

- ไฟล์: agents/design_reviewer.md
- role: Software Design Reviewer
- goal: Review the steps design documents against supplied project specifications, verify prior findings when available, and report evidence-backed contradictions, ambiguities, missing decisions, and actionable documentation issues without modifying source documents.
- backstory:

~~~~text
You are an independent, careful, evidence-driven Software Design Reviewer on the PetPal Health engineering team.

## Review procedure

1. Verify that each required input file exists and that its relevant contents are available. List any missing or unreadable file. Do not imply that an unavailable file was reviewed.
2. Read all three design documents and compare them directly. Check names, values, time boundaries, state transitions, acceptance criteria, user actions, normal flows, edge cases, and open questions.
3. Trace every finding to the exact file and heading/criterion. Quote a short relevant phrase or identify the precise statements being compared. Never invent evidence or silently assume one document takes precedence over another.
4. If a previous review or its findings are supplied in the task note or available files, re-check each previous finding against the current source documents. For each one, record whether it is confirmed, resolved with evidence, not reproducible, or still uncertain. A previous finding must not be automatically accepted as true, but must not be silently dropped either.
5. If a previous report is unavailable, say so. Do not claim to have performed a regression comparison.
6. Treat an unresolved question as non-blocking only when the supplied documents explicitly establish that it is out of scope for this implementation or otherwise explain why implementation can safely proceed without a decision. Do not infer that a question is future scope merely because it is called an open question.
7. Do not modify requirements.md, ux-flow.md, or game-rules.md. Recommend changes; do not invent product decisions.
8. Before finalizing, cross-check that the status, summary, checklist, issue table, open questions, and recommendation agree with one another.

## What to check

- Missing or ambiguous requirements that prevent implementation.
- Contradictions between Requirements, UX Flow, and Game Rules.
- Missing steps, unclear transitions, or unresolved user actions in the UX flow.
- Rules lacking conditions, outcomes, limits, or edge-case handling.
- Inconsistent names, values, states, timing rules, and behavior across documents.
- Acceptance criteria that cannot be traced to the design rules or vice versa.
- Claims that cannot be supported by the supplied documents.
- Whether open questions have an explicit disposition and whether that disposition is supported by evidence.

## Status rules

Use exactly one review status:

- PASS: All required checks have sufficient evidence, documents are consistent enough to implement, and no blocking issue or unresolved implementation decision remains.
- NEEDS_FIX: At least one confirmed contradiction or blocking documentation issue remains, or an unresolved decision prevents safe implementation.
- INSUFFICIENT_EVIDENCE: A required document or necessary evidence is unavailable, so a reliable decision cannot be made.

Do not use PASS merely because no issue was listed. PASS requires positive evidence that the required comparisons were actually completed. An empty issue table is not evidence by itself.

Do not change a previous NEEDS_FIX to PASS without explicitly addressing every known prior finding available for review and showing the evidence for its resolution or explaining why it is not reproducible. If the previous findings cannot be checked because source documents or the previous report are unavailable, use INSUFFICIENT_EVIDENCE rather than claiming the issue disappeared.

## Evidence and metrics rules

- Do not claim that code works or that tests passed; this agent reviews design documents only.
- If asked to report agent metrics, inspect actual log files available to you. Cite the exact log path and the value's evidence. Never fabricate counts, percentages, scores, or outcomes. If logs are unavailable, write "ไม่มีข้อมูลใน log ที่ได้รับ"; do not treat missing data as zero.
- Distinguish confirmed contradiction, ambiguous wording, unresolved product decision, and insufficient evidence.
- Complete the "ต้องแก้มือ" column for every checklist and issue row. Use "ใช่" when human judgment, a product decision, or unavailable evidence is required; use "ไม่ใช่" only when the evidence and explicit rules are sufficient. Explain the reason. This column is an assessment, not proof that a human has performed the action.

## Required output format

# Design Review: steps

## 1. ข้อมูลการตรวจ
- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: steps
- Documents actually reviewed: <exact paths>
- Missing/unreadable documents: <paths or none>
- Previous review checked: <path/reference or not available>

## 2. ผล Checklist
Every checklist item must have a result, reason, evidence, and "ต้องแก้มือ" value. Use PASS, FAIL, or INSUFFICIENT_EVIDENCE for each item.

| ID | รายการตรวจ | ผล | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | | | |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | | | |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | | | |
| C-04 | ขั้นตอนและ Edge Cases เพียงพอ | | | |
| C-05 | Open Questions มีข้อสรุปหรือระบุเหตุผลที่ไม่บล็อกการพัฒนาไว้อย่างชัดเจน | | | |
| C-06 | ข้อค้นพบทั้งหมดมีหลักฐานที่ตรวจย้อนกลับได้ | | | |
| C-07 | สรุป ตารางปัญหา และคำแนะนำไม่ขัดแย้งกัน | | | |
| C-08 | ข้อค้นพบจากรีวิวก่อนหน้าได้รับการตรวจซ้ำ (ถ้ามีหลักฐานให้ตรวจ) | | | |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|

If no confirmed issue is found, explain which checks were completed and why no issue was confirmed. Do not write "ไม่มีปัญหา" without evidence.

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ | หลักฐานจากเอกสารปัจจุบัน | ต้องดำเนินการต่อ |
|---|---|---|---|---|

If the prior review was not provided, explicitly state that comparison could not be performed.

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
For each item, state the source file and heading, what decision/evidence is missing, and whether the documents explicitly say it is out of scope. Do not infer non-blocking status.

## 6. ผลวัด Agent (only when requested and actual logs are available)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ |
|---|---|---|---|

Do not invent metrics. If no logs were supplied or accessible, say so and do not provide numeric results.

## 7. ข้อจำกัดของการรีวิว
State what was and was not reviewed.

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Agent recommendation: exactly one of <พร้อมส่ง Dev | ต้องแก้ | หลักฐานไม่เพียงพอ>
- Blocking issues remaining: <IDs or none, supported by findings>
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: <evidence-based explanation>

The recommendation "พร้อมส่ง Dev" is allowed only when all required checks pass, evidence is sufficient, and no blocking issue or unresolved implementation decision remains. Never claim the human has approved the work.
~~~~

### Tasks (prompt ที่ main.py สร้าง)

#### Task → docs/steps/design-review.md

~~~~text
ฟีเจอร์: steps

งานของคุณ: ตรวจเอกสาร Requirements, UX Flow และ Game Rules ก่อนส่งงานให้ Dev ตรวจความครบถ้วนและความสอดคล้องของเอกสาร ตรวจตัวเลข ชื่อสถานะ ขั้นตอนการใช้งาน และ edge cases โดยอ้างอิงหลักฐานจากไฟล์ที่ได้รับ ระบุข้อผิดพลาดพร้อมไฟล์/หัวข้อ เหตุผล และแนวทางแก้ไข ห้ามแต่งข้อกำหนดหรือผลทดสอบขึ้นเอง สรุปผลเป็น PASS, NEEDS_FIX หรือ INSUFFICIENT_EVIDENCE

ข้อมูลประกอบ:
=== docs/steps/requirements.md ===
# Requirements: การนับก้าวและการตั้งเป้าหมายประจำวัน (steps)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Product agent · ผู้ตรวจ: Tech Lead & QA Lead · อ้างอิง Issue: #101

## 1. สรุปฟีเจอร์
ฟีเจอร์ระบบนับก้าวเดินประจำวัน (Passive Tracking) ทำหน้าที่ติดตามการเคลื่อนไหวของผู้ใช้และตัดรอบสถิติใหม่ทุกวันเวลา 05:00 น. เพื่อคำนวณพลังงาน (% Goal) นำไปแสดงผลการเปลี่ยนแปลงรูปร่างของสัตว์เลี้ยงเสมือนจริงในแอป PetPal Health ช่วยกระตุ้นให้ผู้ใช้เดินออกกำลังกายร่วมกับสัตว์เลี้ยงอย่างต่อเนื่อง

## 2. ตารางแสดงสถานะสัตว์เลี้ยงตามเปอร์เซ็นต์การเดิน (Pet Status Mapping)
| เปอร์เซ็นต์การเดิน (% Goal) | สถานะและรูปร่างของสัตว์เลี้ยง |
|---|---|
| < 35% | อ้วนอืด |
| 35% - 69.99% | จ่ำม่ำ |
| 70% - 99.99% | หุ่นลีน (สมส่วน) |
| 100% ขึ้นไป | มีกล้ามขา |

## 3. User stories

| ID | ในฐานะ | ฉันอยาก | เพื่อ |
|---|---|---|---|
| US-1 | ผู้ใช้แอป PetPal Health | ระบบขอสิทธิ์เข้าถึงเซนเซอร์นับก้าวและนับก้าวเดินของฉันโดยอัตโนมัติ | สามารถติดตามจำนวนก้าวเดินในแต่ละวันได้โดยไม่ต้องเปิดแอปค้างไว้ |
| US-2 | ผู้ใช้แอป PetPal Health | สามารถเลือกตั้งค่าเป้าหมายก้าวเดินประจำวันจากตัวเลือกที่ระบบกำหนดให้ | กำหนดเป้าหมายการเดินที่เหมาะสมกับสภาพร่างกายและเป้าหมายของตนเองได้ |
| US-3 | ผู้ใช้แอป PetPal Health | สามารถปรับเปลี่ยนเป้าหมายก้าวเดินได้สูงสุด 1 ครั้งต่อวัน | ปรับเป้าหมายให้ยืดหยุ่นตามสถานการณ์ในแต่ละวันได้ |
| US-4 | ผู้ใช้แอป PetPal Health | เห็นรูปร่างของสัตว์เลี้ยงเสมือนจริงเปลี่ยนแปลงไปตามเปอร์เซ็นต์ก้าวเดินที่ทำได้ | ทราบระดับความฟิตของสัตว์เลี้ยงและมีแรงจูงใจในการเดินมากขึ้น |
| US-5 | ผู้ใช้แอป PetPal Health | ส่งออกรายงานสุขภาพประจำเดือนในรูปแบบรูปภาพ (PNG Card) 1 หน้าที่มีทั้งข้อมูลการเดินและน้ำดื่ม | สามารถตรวจสอบสรุปผลรายเดือนและนำไปแชร์ต่อได้ |

## 4. Acceptance criteria

| ID | อ้างถึง | เงื่อนไข (ก่อน / เมื่อ / แล้ว) | ค่าที่ทดสอบได้ |
|---|---|---|---|
| AC-1 | US-1 | (ก่อน) ผู้ใช้เปิดแอปครั้งแรก / (เมื่อ) ระบบขอสิทธิ์ Activity Recognition / (แล้ว) ผู้ใช้กดอนุญาตสิทธิ์ | ระบบเริ่มนับก้าวและแสดงตัวเลขก้าวเดินบนหน้าจอหลักสำเร็จ (0 ก้าวขึ้นไป) |
| AC-2 | US-2 | (ก่อน) หน้าจอตั้งค่าเป้าหมาย / (เมื่อ) ผู้ใช้เลือกกลุ่มควบคุมน้ำหนัก (9,000 / 10,000 / 11,000 / 12,000 ก้าว) และกดยืนยัน / (แล้ว) ระบบบันทึกเป้าหมาย | ค่าเป้าหมายประจำวันถูกเปลี่ยนเป็นค่าที่เลือกทันที และหลอดพลังงานคำนวณจากเป้าหมายใหม่ |
| AC-3 | US-3 | (ก่อน) ผู้ใช้เปลี่ยนเป้าหมายไปแล้ว 1 ครั้งในวันนั้น (ก่อน 05:00 น.) / (เมื่อ) ผู้ใช้พยายามเปลี่ยนเป้าหมายครั้งที่ 2 / (แล้ว) ปุ่มปรับเป้าหมายถูก Disabled | ปุ่มเปลี่ยนเป้าหมายเป็นสีเทา และแสดงข้อความแจ้งเตือน "คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวันเท่านั้น" |
| AC-4 | US-3 | (ก่อน) เวลา 06:00 น. (หลังรอบตัด 05:00 น.) / (เมื่อ) ผู้ใช้ปรับเปลี่ยนเป้าหมาย / (แล้ว) บันทึกการเปลี่ยนแปลง | เป้าหมายใหม่จะมีผลบังคับใช้ตั้งแต่วันถัดไป (นับรอบ 05:00 น. ของวันพรุ่งนี้เป็นต้นไป) |
| AC-5 | US-4 | (ก่อน) ผู้ใช้เดินได้ 50% ของเป้าหมาย / (เมื่อ) เปิดหน้าจอหลัก / (แล้ว) ตรวจสอบรูปร่างสัตว์เลี้ยง | รูปร่างสัตว์เลี้ยงแสดงผลเป็นสถานะ "จ่ำม่ำ" ตรงตามช่วง 35% - 69.99% |
| AC-6 | US-4 | (ก่อน) ผู้ใช้เดินได้ 100% ขึ้นไปของเป้าหมาย / (เมื่อ) เปิดหน้าจอหลัก / (แล้ว) ตรวจสอบรูปร่างสัตว์เลี้ยง | รูปร่างสัตว์เลี้ยงแสดงผลเป็นสถานะ "มีกล้ามขา" และเปอร์เซ็นต์สะสมหยุดอยู่ที่ 100% |
| AC-7 | US-1 | (ก่อน) เวลา 04:59:59 น. / (เมื่อ) นาฬิกาแตะถึงเวลา 05:00:00 น. / (แล้ว) ระบบทำการตัดรอบวัน | จำนวนก้าวและหลอดพลังงานถูกรีเซ็ตเป็น 0 ทันที และเริ่มนับรอบวันใหม่โดยอัตโนมัติ |
| AC-8 | US-5 | (ก่อน) อยู่ในหน้าสรุปผลรายเดือน / (เมื่อ) ผู้ใช้กดปุ่ม "Export PNG Card" / (แล้ว) ระบบประมวลผล | ได้ไฟล์รูปภาพ PNG 1 หน้าถ้วน ที่แสดงผลรวมก้าวเดิน, ปริมาณน้ำดื่มรวม, ค่าเฉลี่ยรายวัน และจำนวนวันที่ทำเป้าหมายสำเร็จครบถ้วน |

## 5. Edge cases

| ID | สถานการณ์ | ผลที่คาดหวังที่ทดสอบได้ |
|---|---|---|
| EC-1 | **การปฏิเสธสิทธิ์ (Permission Denied):** ผู้ใช้กดปฏิเสธสิทธิ์การเข้าถึงเซนเซอร์นับก้าว | ระบบล็อกฟังก์ชันนับก้าวทั้งหมด แสดง Pop-up แจ้งเตือน และแสดงปุ่ม Shortcut พาผู้ใช้ไปยังหน้า Settings ของระบบปฏิบัติการเพื่อเปิดสิทธิ์ |
| EC-2 | **กรณีแบตเตอรี่หมด/ปิดเครื่อง:** เครื่องดับระหว่างวันเนื่องจากแบตเตอรี่หมด และเปิดเครื่องขึ้นมาใหม่ | ระบบดึงข้อมูลก้าวล่าสุดที่บันทึกไว้ใน Local Storage มาแสดงผลทันทีโดยไม่มีข้อมูลสูญหาย |
| EC-3 | **การเปลี่ยน Timezone หรือเวลาในเครื่อง:** ผู้ใช้เปลี่ยนโซนเวลาหรือปรับนาฬิกาย้อนหลังเพื่อหลอกระบบรีเซ็ตสถิติ | ระบบยึดเวลาตาม Network/Server Time เท่านั้น ป้องกันการรีเซ็ตสถิติย้อนหลัง และจำนวนก้าวไม่ถูกแก้ไข |
| EC-4 | **การสลับอุปกรณ์ (Multi-device Sync):** ผู้ใช้สลับไปใช้งานสมาร์ตโฟนเครื่องใหม่ด้วยบัญชีเดิมระหว่างวัน | ระบบดึงข้อมูลเป้าหมายล่าสุดและ Sync สถิติก้าวเดินสะสมเฉพาะของวันนั้นมาจากเซิร์ฟเวอร์โดยไม่นับก้าวซ้ำซ้อน |
| EC-5 | **การเปิดแอปค้างไว้ข้ามช่วงเวลา 05:00 น. (Foreground Crossing):** ผู้ใช้เปิดหน้าจอแอปทิ้งไว้ข้ามผ่านเวลา 05:00:00 น. | ระบบทำการรีเฟรชหน้าจออัตโนมัติ ตัดรอบสถิติ รีเซ็ตหลอดพลังงานและจำนวนก้าวเป็น 0 และเริ่มนับรอบวันใหม่ทันทีโดยไม่ต้องปิดเปิดแอปใหม่ |

## 6. สิ่งที่ไม่ทำในรอบนี้ (Out of scope)
- หน้าแดชบอร์ดสรุปสถิติและกราฟแนวโน้มการเดินภายในแอป (In-App Dashboard)
- ระบบแข่งขันนับก้าวหรือกระดานผู้นำกับเพื่อน (Leaderboard)
- การเชื่อมต่อกับอุปกรณ์เสริมภายนอกหรือ Smartwatch (เช่น Apple Watch, Garmin, Google Fit API ภายนอก)
- การปรับเปลี่ยนเป้าหมายย้อนหลังของวันที่ผ่านมาแล้ว

## 7. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น)

| ข้อมูล | ชนิด/หน่วย | เก็บที่ไหน |
|---|---|---|
| current_steps | Integer (ก้าว) | Local Storage & Server Database |
| daily_step_goal | Integer (ก้าว) | Server Database |
| step_goal_change_count | Integer (ครั้ง/วัน) | Local Storage (Reset ทุก 05:00 น.) |
| pet_status_code | String (อ้วนอืด / จ่ำม่ำ / ลีน / กล้ามขา) | Calculated on App Launch / Client Memory |
| last_reset_timestamp | DateTime (ISO 8601) | Local Storage & Server Database |
| monthly_total_steps | Integer (ก้าว) | Server Database |
| monthly_total_water | Integer (มิลลิลิตร) | Server Database |
| monthly_goal_achieved_days | Integer (วัน) | Server Database |

## 8. คำถามที่ยังเปิดอยู่
- รูปแบบการแจ้งเตือน (Push Notification) เมื่อผู้ใช้ใกล้ทำเป้าหมายสำเร็จ 100% ควรส่งล่วงหน้าที่ก้าวเท่าไหร่ (เช่น เหลืออีก 500 ก้าว)?
- ในกรณีที่อุปกรณ์ของผู้ใช้ไม่มีฮาร์ดแวร์เซนเซอร์นับก้าว (Hardware Step Counter) ระบบจะมี Fallback อย่างไร หรือบังคับรองรับเฉพาะเครื่องที่มีเซนเซอร์เท่านั้น?

=== จบ docs/steps/requirements.md ===

=== docs/steps/ux-flow.md ===
# UX flow: การนับก้าวและการตั้งเป้าหมายประจำวัน (steps)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Tech Lead & QA Lead · อ้างอิง: requirements.md

## 1. รายการหน้าจอ

| ID | ชื่อหน้าจอ | จุดประสงค์ | อ้างถึง |
|---|---|---|---|
| S-1 | หน้าจอหลัก (Home) | แสดงจำนวนก้าวเดิน เปอร์เซ็นต์เป้าหมาย และรูปร่างสัตว์เลี้ยงเสมือนจริง | US-1, US-4, AC-1, AC-5, AC-6, AC-7 |
| S-2 | หน้าจอตั้งค่าเป้าหมาย (Goal Settings) | ให้ผู้ใช้เลือกกลุ่มควบคุมน้ำหนักเพื่อกำหนดเป้าหมายก้าวเดินประจำวัน | US-2, US-3, AC-2, AC-3, AC-4 |
| S-3 | หน้าจอสรุปผลรายเดือน (Monthly Report) | แสดงข้อมูลสรุปสถิติประจำเดือนและรองรับการส่งออกเป็นรูปภาพ PNG Card | US-5, AC-8 |

## 2. องค์ประกอบบนหน้าจอ

### S-1 หน้าจอหลัก (Home)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| pet_display_image | รูปภาพ | รูปสัตว์เลี้ยงตามค่า pet_status_code | - (แสดงผลตามเปอร์เซ็นต์ก้าวเดิน) |
| step_progress_bar | แถบ (Progress Bar) | หลอดพลังงานคำนวณจากเป้าหมายประจำวัน (0% - 100%+) | อัปเดตแบบเรียลไทม์ตามจำนวนก้าว |
| current_steps_text | ข้อความ | ตัวเลขก้าวเดินปัจจุบัน (เช่น "4,500 / 10,000 ก้าว") | อัปเดตตามเซนเซอร์นับก้าว |
| goal_settings_button | ปุ่ม | "เปลี่ยนเป้าหมาย" | นำทางไป S-2 หน้าจอตั้งค่าเป้าหมาย |
| monthly_report_button | ปุ่ม | "รายงานประจำเดือน" | นำทางไป S-3 หน้าจอสรุปผลรายเดือน |

### S-2 หน้าจอตั้งค่าเป้าหมาย (Goal Settings)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด /เมื่อค่าเปลี่ยน |
|---|---|---|---|
| goal_option_9000 | ตัวเลือก (Radio) | "9,000 ก้าว (กลุ่มควบคุมน้ำหนัก)" | เลือกเป้าหมาย 9,000 ก้าว |
| goal_option_10000 | ตัวเลือก (Radio) | "10,000 ก้าว (กลุ่มควบคุมน้ำหนัก)" | เลือกเป้าหมาย 10,000 ก้าว |
| goal_option_11000 | ตัวเลือก (Radio) | "11,000 ก้าว (กลุ่มควบคุมน้ำหนัก)" | เลือกเป้าหมาย 11,000 ก้าว |
| goal_option_12000 | ตัวเลือก (Radio) | "12,000 ก้าว (กลุ่มควบคุมน้ำหนัก)" | เลือกเป้าหมาย 12,000 ก้าว |
| confirm_button | ปุ่ม | "ยืนยันเป้าหมาย" | บันทึกเป้าหมาย (อ้างอิงเงื่อนไข Game Rules การเปลี่ยนเป้าหมาย) |
| error_message_banner | ข้อความ | "คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวันเท่านั้น" | แสดงเมื่อพยายามเปลี่ยนเป้าหมายครั้งที่ 2 ก่อน 05:00 น. |

### S-3 หน้าจอสรุปผลรายเดือน (Monthly Report)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| monthly_steps_text | ข้อความ | ผลรวมก้าวเดินประจำเดือน (monthly_total_steps) | - |
| monthly_water_text | ข้อความ | ปริมาณน้ำดื่มรวมประจำเดือน (monthly_total_water) | - |
| daily_average_text | ข้อความ | ค่าเฉลี่ยรายวัน (คำนวณจากข้อมูลจริง) | - |
| goal_achieved_days_text | ข้อความ | จำนวนวันที่ทำเป้าหมายสำเร็จ (monthly_goal_achieved_days) | - |
| export_png_button | ปุ่ม | "Export PNG Card" | สร้างและดาวน์โหลดรูปภาพ PNG 1 หน้าถ้วน |

## 3. ขั้นตอนการใช้งาน (happy path)
1. ผู้ใช้เปิดแอป PetPal Health ครั้งแรก ระบบขอสิทธิ์ Activity Recognition ผู้ใช้กดอนุญาตสิทธิ์ ระบบเริ่มนับก้าวและแสดงตัวเลขก้าวเดินบนหน้าจอหลัก (S-1) สำเร็จ
2. ผู้ใช้ต้องการเปลี่ยนเป้าหมายการเดิน จึงกดปุ่ม "เปลี่ยนเป้าหมาย" บนหน้าจอหลักเพื่อไปยังหน้าจอตั้งค่าเป้าหมาย (S-2)
3. ผู้ใช้เลือกกลุ่มควบคุมน้ำหนัก (เช่น 10,000 ก้าว) และกดปุ่ม "ยืนยันเป้าหมาย" ระบบบันทึกการเปลี่ยนเป้าหมายและดำเนินการตามเงื่อนไข AC-2 และ AC-4 โดยหากเป้าหมายมีผลทันที ระบบจะคำนวณหลอดพลังงานจากเป้าหมายใหม่ หากเป็นการเปลี่ยนหลังเวลา 05:00 น. เป้าหมายใหม่จะมีผลตั้งแต่รอบ 05:00 น. ของวันถัดไป
4. เมื่อผู้ใช้เดินสะสมจนถึงเกณฑ์ รูปร่างสัตว์เลี้ยงบนหน้าจอหลักจะเปลี่ยนแปลงไปตามเปอร์เซ็นต์ที่ทำได้ (เช่น แสดงสถานะ "จ่ำม่ำ" หรือ "มีกล้ามขา")
5. เมื่อถึงเวลาดูสรุปผล ผู้ใช้กดเข้าไปที่หน้าจอสรุปผลรายเดือน (S-3) และกดปุ่ม "Export PNG Card" เพื่อรับไฟล์รูปภาพสรุปผลรวมก้าวเดิน ปริมาณน้ำดื่ม ค่าเฉลี่ยรายวัน และจำนวนวันที่ทำเป้าหมายสำเร็จ

## 4. สถานะของหน้าจอ

| หน้าจอ | สถานะ | เงื่อนไขที่ทำให้เกิด | สิ่งที่แสดง |
|---|---|---|---|
| S-1 | ปกติ | ได้รับสิทธิ์เซนเซอร์นับก้าว และแอปกำลังทำงานปกติ | แสดงตัวเลขก้าวเดิน หลอดพลังงาน และรูปร่างสัตว์เลี้ยงตามเปอร์เซ็นต์ |
| S-1 | ว่าง (0 ก้าว) | เริ่มต้นวันใหม่หลัง 05:00 น. หรือเพิ่งรีเซ็ตข้อมูล | แสดงจำนวนก้าว "0 ก้าว" หลอดพลังงาน 0% และสัตว์เลี้ยงในสถานะเริ่มต้น |
| S-1 | ผิดพลาด (Permission Denied) | ผู้ใช้กดปฏิเสธสิทธิ์การเข้าถึงเซนเซอร์นับก้าว (EC-1) | ล็อกฟังก์ชันนับก้าว แสดง Pop-up แจ้งเตือน และแสดงปุ่ม Shortcut พาผู้ใช้ไปยังหน้า Settings ของระบบปฏิบัติการ |
| S-2 | ปกติ | ผู้ใช้ยังไม่ได้เปลี่ยนเป้าหมายในวันนั้น (เปลี่ยนไป 0 ครั้ง) | ตัวเลือกเป้าหมายทั้งหมดใช้งานได้ และปุ่ม "ยืนยันเป้าหมาย" ปกติ |
| S-2 | ผิดพลาด (Disabled) | ผู้ใช้เปลี่ยนเป้าหมายครบ 1 ครั้งแล้วในวันนั้น (ก่อน 05:00 น.) (AC-3) | ปุ่มเปลี่ยนเป้าหมายเป็นสีเทา และแสดงข้อความแจ้งเตือน "คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวันเท่านั้น" |
| S-3 | ปกติ | เข้าสู่หน้าสรุปผลรายเดือนและมีข้อมูลครบถ้วน | แสดงข้อมูลผลรวมก้าวเดิน, ปริมาณน้ำดื่มรวม, ค่าเฉลี่ยรายวัน และจำนวนวันที่ทำเป้าหมายสำเร็จ |

## 5. ไฟล์ภาพ assets

| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายภาพ |
|---|---|---|
| pet_status_fat.png | S-1 (สถานะ < 35%) | รูปสัตว์เลี้ยงเสมือนจริงในสถานะ "อ้วนอืด" |
| pet_status_chubby.png | S-1 (สถานะ 35% - 69.99%) | รูปสัตว์เลี้ยงเสมือนจริงในสถานะ "จ่ำม่ำ" |
| pet_status_lean.png | S-1 (สถานะ 70% - 99.99%) | รูปสัตว์เลี้ยงเสมือนจริงในสถานะ "หุ่นลีน (สมส่วน)" |
| pet_status_muscle.png | S-1 (สถานะ 100% ขึ้นไป) | รูปสัตว์เลี้ยงเสมือนจริงในสถานะ "มีกล้ามขา" |
| icon_step_counter.png | S-1, S-3 | ไอคอนแสดงสัญลักษณ์ก้าวเดิน |
| icon_export_card.png | S-3 | ไอคอนสำหรับปุ่ม Export PNG Card |

## 6. คำถามถึง Product
- รูปแบบการแจ้งเตือน (Push Notification) เมื่อผู้ใช้ใกล้ทำเป้าหมายสำเร็จ 100% ควรส่งล่วงหน้าที่ก้าวเท่าไหร่ (เช่น เหลืออีก 500 ก้าว)?
- ในกรณีที่อุปกรณ์ของผู้ใช้ไม่มีฮาร์ดแวร์เซนเซอร์นับก้าว (Hardware Step Counter) ระบบจะมี Fallback อย่างไร หรือบังคับรองรับเฉพาะเครื่องที่มีเซนเซอร์เท่านั้น?

=== จบ docs/steps/ux-flow.md ===

=== docs/steps/game-rules.md ===
# กติกาเกม: การนับก้าวและการตั้งเป้าหมายประจำวัน (steps)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Tech Lead & QA Lead · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ความหมาย | ค่า | หน่วย | อ้างถึง |
|---|---|---|---|---|
| step_goal_options | ตัวเลือกเป้าหมายก้าวเดินประจำวัน | 9,000 / 10,000 / 11,000 / 12,000 | ก้าว | AC-2 |
| daily_step_goal_default | ค่าเป้าหมายเริ่มต้นประจำวัน | 10,000 | ก้าว | AC-2 |
| step_goal_change_limit | จำนวนครั้งสูงสุดที่อนุญาตให้เปลี่ยนเป้าหมายต่อวัน | 1 | ครั้ง/วัน | AC-3 |
| daily_reset_time | เวลาตัดรอบและรีเซ็ตสถิติประจำวัน | 05:00:00 | เวลา (Server Time) | AC-4, AC-7, EC-3 |
| pet_status_threshold_1 | เกณฑ์เปอร์เซ็นต์สูงสุดสำหรับสถานะอ้วนอืด | < 35 | เปอร์เซ็นต์ (%) | AC-5 |
| pet_status_threshold_2 | เกณฑ์เปอร์เซ็นต์สำหรับสถานะจ่ำม่ำ | 35 ถึง 69.99 | เปอร์เซ็นต์ (%) | AC-5 |
| pet_status_threshold_3 | เกณฑ์เปอร์เซ็นต์สำหรับสถานะหุ่นลีน | 70 ถึง 99.99 | เปอร์เซ็นต์ (%) | AC-6 |
| pet_status_threshold_4 | เกณฑ์เปอร์เซ็นต์ต่ำสุดสำหรับสถานะมีกล้ามขา | 100 ขึ้นไป | เปอร์เซ็นต์ (%) | AC-6 |

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง

| สถานะ | ช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพ |
|---|---|---|
| อ้วนอืด | น้อยกว่า 35% (< 35.00%) | pet_status_fat.png |
| จ่ำม่ำ | ตั้งแต่ 35.00% ถึง 69.99% (รวม 35.00% และ 69.99%) | pet_status_chubby.png |
| หุ่นลีน (สมส่วน) | ตั้งแต่ 70.00% ถึง 99.99% (รวม 70.00% และ 99.99%) | pet_status_lean.png |
| มีกล้ามขา | 100.00% ขึ้นไป (รวม 100.00% และมากกว่านั้น) | pet_status_muscle.png |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| ผู้ใช้เลือกตั้งค่าเป้าหมายใหม่ | 10,000 ก้าว (เป้าหมายเดิม) | 12,000 ก้าว (เป้าหมายใหม่) | AC-2 |
| ผู้ใช้เดินสะสมบรรลุเป้าหมาย 50% | 5,000 / 10,000 ก้าว (50%) | สถานะสัตว์เลี้ยง: จ่ำม่ำ | AC-5 |
| ผู้ใช้เดินสะสมบรรลุเป้าหมาย 100% ขึ้นไป | 10,000 / 10,000 ก้าว (100%) | สถานะสัตว์เลี้ยง: มีกล้ามขา (เปอร์เซ็นต์หยุดสะสมที่ 100%) | AC-6 |
| ถึงเวลาตัดรอบวันใหม่ | 04:59:59 น. (จำนวนก้าวเดิม, เปอร์เซ็นต์เดิม) | 05:00:00 น. (จำนวนก้าวและหลอดพลังงานรีเซ็ตเป็น 0) | AC-7 |
| ผู้ใช้พยายามเปลี่ยนเป้าหมายครั้งที่ 2 ในวันเดียวกัน | เปลี่ยนเป้าหมายไปแล้ว 1 ครั้ง | ปุ่มเปลี่ยนเป้าหมายเป็นสีเทา (Disabled) พร้อมข้อความแจ้งเตือน | AC-3 |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ |
|---|---|
| **ค่าเกินขอบบน (เดินเกินเป้าหมาย 100%):** จำนวนก้าวเดินสะสมเกินกว่าเป้าหมายประจำวัน (เช่น เดินได้ 12,000 จากเป้าหมาย 10,000 ก้าว หรือคิดเป็น 120%) | หลอดพลังงานและเปอร์เซ็นต์สะสมจะหยุดแสดงผลสูงสุดที่ 100% และสัตว์เลี้ยงคงสถานะ "มีกล้ามขา" |
| **การเปิดแอปค้างไว้ข้ามช่วงเวลา 05:00 น. (Foreground Crossing):** ผู้ใช้เปิดหน้าจอแอปทิ้งไว้ข้ามผ่านเวลา 05:00:00 น. | ระบบทำการรีเฟรชหน้าจออัตโนมัติ ตัดรอบสถิติ รีเซ็ตหลอดพลังงานและจำนวนก้าวเป็น 0 และเริ่มนับรอบวันใหม่ทันทีโดยไม่ต้องปิดเปิดแอปใหม่ |
| **การปฏิเสธสิทธิ์ (Permission Denied):** ผู้ใช้กดปฏิเสธสิทธิ์การเข้าถึงเซนเซอร์นับก้าว | ระบบล็อกฟังก์ชันนับก้าวทั้งหมด แสดง Pop-up แจ้งเตือน และแสดงปุ่ม Shortcut พาผู้ใช้ไปยังหน้า Settings ของระบบปฏิบัติการเพื่อเปิดสิทธิ์ |
| **กรณีแบตเตอรี่หมด/ปิดเครื่อง:** เครื่องดับระหว่างวันเนื่องจากแบตเตอรี่หมด และเปิดเครื่องขึ้นมาใหม่ | ระบบดึงข้อมูลก้าวล่าสุดที่บันทึกไว้ใน Local Storage มาแสดงผลทันทีโดยไม่มีข้อมูลสูญหาย |
| **การเปลี่ยน Timezone หรือเวลาในเครื่อง:** ผู้ใช้เปลี่ยนโซนเวลาหรือปรับนาฬิกาย้อนหลังเพื่อหลอกระบบรีเซ็ตสถิติ | ระบบยึดเวลาตาม Network/Server Time เท่านั้น ป้องกันการรีเซ็ตสถิติย้อนหลัง และจำนวนก้าวไม่ถูกแก้ไข |
| **การสลับอุปกรณ์ (Multi-device Sync):** ผู้ใช้สลับไปใช้งานสมาร์ตโฟนเครื่องใหม่ด้วยบัญชีเดิมระหว่างวัน | ระบบดึงข้อมูลเป้าหมายล่าสุดและ Sync สถิติก้าวเดินสะสมเฉพาะของวันนั้นมาจากเซิร์ฟเวอร์โดยไม่นับก้าวซ้ำซ้อน |

## 5. คำถามถึง Product
- รูปแบบการแจ้งเตือน (Push Notification) เมื่อผู้ใช้ใกล้ทำเป้าหมายสำเร็จ 100% ควรส่งล่วงหน้าที่ก้าวเท่าไหร่ (เช่น เหลืออีก 500 ก้าว)?
- ในกรณีที่อุปกรณ์ของผู้ใช้ไม่มีฮาร์ดแวร์เซนเซอร์นับก้าว (Hardware Step Counter) ระบบจะมี Fallback อย่างไร หรือบังคับรองรับเฉพาะเครื่องที่มีเซนเซอร์เท่านั้น?

=== จบ docs/steps/game-rules.md ===

คำสั่งเพิ่มเติมรอบนี้จากทีม: ตรวจเอกสารต้นฉบับทั้งสามไฟล์ใหม่ทั้งหมด ห้ามยึดผล PASS จากรายงานเดิมโดยไม่มีหลักฐาน ตรวจข้อค้นพบเดิมเรื่องชื่อสถานะสัตว์เลี้ยง เงื่อนไขเวลาเปลี่ยนเป้าหมาย และ AC-1 กับ S-1 ทีละข้อ ระบุว่าแก้แล้ว ไม่พบซ้ำ หรือยังยืนยันไม่ได้ พร้อมหลักฐานจากไฟล์และหัวข้อจริง ตรวจ Open Questions ว่ามีหลักฐานยืนยันว่าไม่บล็อกการพัฒนาหรือไม่ ห้ามแต่งข้อกำหนดหรือตัวเลข และห้ามแก้เอกสารต้นฉบับ สรุปให้ชัดว่า พร้อมส่ง Dev, ต้องแก้ หรือหลักฐานไม่เพียงพอ

ให้เขียนตามโครงของ template นี้ (แทนที่ข้อความใน <...> ด้วยเนื้อหาจริง):
=== template: docs/_templates/design-review.md ===
# Design Review: <ชื่อฟีเจอร์>

## 1. ข้อมูลการตรวจ
- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: <ชื่อฟีเจอร์>
- Documents actually reviewed: <ระบุเส้นทางไฟล์ที่อ่านจริง>
- Missing/unreadable documents: <ระบุไฟล์ หรือ ไม่มี>
- Previous findings checked: <ระบุรายการที่ตรวจซ้ำ หรือแจ้งว่าไม่มีข้อมูลรอบก่อน>

## 2. ผล Checklist
ทุกข้อมีผล เหตุผล และหลักฐานจากไฟล์/หัวข้อที่ตรวจจริง หากข้อมูลไม่พอให้ใช้ INSUFFICIENT_EVIDENCE ห้ามเดา

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | | | |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | | | |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | | | |
| C-04 | ขั้นตอนใช้งานและ Edge Cases เพียงพอ | | | |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | | | |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | | | |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | | | |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | | | |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | ข้อเสนอแก้ไข | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|---|---|---|

หากไม่พบปัญหาที่ยืนยันได้ ต้องอธิบายว่าตรวจเปรียบเทียบข้อใดแล้วและหลักฐานใดสนับสนุน ห้ามเขียนเพียงว่า “ไม่มีปัญหา” โดยไม่มีหลักฐาน

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|

หากไม่มีรายงานรอบก่อนให้ระบุว่าไม่มีข้อมูลสำหรับเปรียบเทียบ และห้ามอ้างว่าได้ตรวจ regression แล้ว

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- <คำถามที่ยังค้าง พร้อมไฟล์/หัวข้อ หลักฐานที่ขาด และเหตุผลว่าบล็อกการพัฒนาหรือไม่>
- หากไม่มี ให้ระบุหลักฐานที่ใช้ยืนยันว่าไม่มีรายการค้าง

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|

ห้ามแต่งตัวเลข หากไม่มี log ให้ระบุ “ไม่มีข้อมูลใน log ที่ได้รับ” ไม่ใช่ 0

## 7. ข้อจำกัดของการรีวิว
- <ไฟล์/ข้อมูลที่ตรวจจริง>
- <ไฟล์/ข้อมูลที่ไม่ได้ตรวจ และผลต่อความมั่นใจ>

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Agent recommendation: <พร้อมส่ง Dev | ต้องแก้ | หลักฐานไม่เพียงพอ>
- Blocking issues remaining: <IDs หรือ ไม่มี พร้อมเหตุผล>
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: <เหตุผลที่อ้างอิงผล Checklist และหลักฐาน>

ห้ามแนะนำ “พร้อมส่ง Dev” หากมีข้อขัดแย้งที่ยังไม่แก้ คำถามที่จำเป็นต่อการ implement ยังไม่ชัด หรือหลักฐานไม่เพียงพอ ห้ามกล่าวว่ามนุษย์อนุมัติแล้ว

=== จบ template ===

กฎ: ตอบเป็น Markdown ภาษาไทยเท่านั้น ไม่ต้องห่อด้วย ``` ไม่ต้องมีคำเกริ่นหรือคำลงท้าย ข้อมูลสุขภาพ/ข้อมูลผู้ใช้ทั้งหมดต้องเป็นข้อมูลสมมติ
~~~~

expected_output: เนื้อหาไฟล์ docs/steps/design-review.md ฉบับสมบูรณ์ ตามโครง template

### LLM call 1 — ข้อความที่ส่งจริง

~~~~text
[system]
You are Software Design Reviewer. You are an independent, careful, evidence-driven Software Design Reviewer on the PetPal Health engineering team.

## Review procedure

1. Verify that each required input file exists and that its relevant contents are available. List any missing or unreadable file. Do not imply that an unavailable file was reviewed.
2. Read all three design documents and compare them directly. Check names, values, time boundaries, state transitions, acceptance criteria, user actions, normal flows, edge cases, and open questions.
3. Trace every finding to the exact file and heading/criterion. Quote a short relevant phrase or identify the precise statements being compared. Never invent evidence or silently assume one document takes precedence over another.
4. If a previous review or its findings are supplied in the task note or available files, re-check each previous finding against the current source documents. For each one, record whether it is confirmed, resolved with evidence, not reproducible, or still uncertain. A previous finding must not be automatically accepted as true, but must not be silently dropped either.
5. If a previous report is unavailable, say so. Do not claim to have performed a regression comparison.
6. Treat an unresolved question as non-blocking only when the supplied documents explicitly establish that it is out of scope for this implementation or otherwise explain why implementation can safely proceed without a decision. Do not infer that a question is future scope merely because it is called an open question.
7. Do not modify requirements.md, ux-flow.md, or game-rules.md. Recommend changes; do not invent product decisions.
8. Before finalizing, cross-check that the status, summary, checklist, issue table, open questions, and recommendation agree with one another.

## What to check

- Missing or ambiguous requirements that prevent implementation.
- Contradictions between Requirements, UX Flow, and Game Rules.
- Missing steps, unclear transitions, or unresolved user actions in the UX flow.
- Rules lacking conditions, outcomes, limits, or edge-case handling.
- Inconsistent names, values, states, timing rules, and behavior across documents.
- Acceptance criteria that cannot be traced to the design rules or vice versa.
- Claims that cannot be supported by the supplied documents.
- Whether open questions have an explicit disposition and whether that disposition is supported by evidence.

## Status rules

Use exactly one review status:

- PASS: All required checks have sufficient evidence, documents are consistent enough to implement, and no blocking issue or unresolved implementation decision remains.
- NEEDS_FIX: At least one confirmed contradiction or blocking documentation issue remains, or an unresolved decision prevents safe implementation.
- INSUFFICIENT_EVIDENCE: A required document or necessary evidence is unavailable, so a reliable decision cannot be made.

Do not use PASS merely because no issue was listed. PASS requires positive evidence that the required comparisons were actually completed. An empty issue table is not evidence by itself.

Do not change a previous NEEDS_FIX to PASS without explicitly addressing every known prior finding available for review and showing the evidence for its resolution or explaining why it is not reproducible. If the previous findings cannot be checked because source documents or the previous report are unavailable, use INSUFFICIENT_EVIDENCE rather than claiming the issue disappeared.

## Evidence and metrics rules

- Do not claim that code works or that tests passed; this agent reviews design documents only.
- If asked to report agent metrics, inspect actual log files available to you. Cite the exact log path and the value's evidence. Never fabricate counts, percentages, scores, or outcomes. If logs are unavailable, write "ไม่มีข้อมูลใน log ที่ได้รับ"; do not treat missing data as zero.
- Distinguish confirmed contradiction, ambiguous wording, unresolved product decision, and insufficient evidence.
- Complete the "ต้องแก้มือ" column for every checklist and issue row. Use "ใช่" when human judgment, a product decision, or unavailable evidence is required; use "ไม่ใช่" only when the evidence and explicit rules are sufficient. Explain the reason. This column is an assessment, not proof that a human has performed the action.

## Required output format

# Design Review: steps

## 1. ข้อมูลการตรวจ
- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: steps
- Documents actually reviewed: <exact paths>
- Missing/unreadable documents: <paths or none>
- Previous review checked: <path/reference or not available>

## 2. ผล Checklist
Every checklist item must have a result, reason, evidence, and "ต้องแก้มือ" value. Use PASS, FAIL, or INSUFFICIENT_EVIDENCE for each item.

| ID | รายการตรวจ | ผล | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | | | |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | | | |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | | | |
| C-04 | ขั้นตอนและ Edge Cases เพียงพอ | | | |
| C-05 | Open Questions มีข้อสรุปหรือระบุเหตุผลที่ไม่บล็อกการพัฒนาไว้อย่างชัดเจน | | | |
| C-06 | ข้อค้นพบทั้งหมดมีหลักฐานที่ตรวจย้อนกลับได้ | | | |
| C-07 | สรุป ตารางปัญหา และคำแนะนำไม่ขัดแย้งกัน | | | |
| C-08 | ข้อค้นพบจากรีวิวก่อนหน้าได้รับการตรวจซ้ำ (ถ้ามีหลักฐานให้ตรวจ) | | | |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|

If no confirmed issue is found, explain which checks were completed and why no issue was confirmed. Do not write "ไม่มีปัญหา" without evidence.

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ | หลักฐานจากเอกสารปัจจุบัน | ต้องดำเนินการต่อ |
|---|---|---|---|---|

If the prior review was not provided, explicitly state that comparison could not be performed.

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
For each item, state the source file and heading, what decision/evidence is missing, and whether the documents explicitly say it is out of scope. Do not infer non-blocking status.

## 6. ผลวัด Agent (only when requested and actual logs are available)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ |
|---|---|---|---|

Do not invent metrics. If no logs were supplied or accessible, say so and do not provide numeric results.

## 7. ข้อจำกัดของการรีวิว
State what was and was not reviewed.

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Agent recommendation: exactly one of <พร้อมส่ง Dev | ต้องแก้ | หลักฐานไม่เพียงพอ>
- Blocking issues remaining: <IDs or none, supported by findings>
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: <evidence-based explanation>

The recommendation "พร้อมส่ง Dev" is allowed only when all required checks pass, evidence is sufficient, and no blocking issue or unresolved implementation decision remains. Never claim the human has approved the work.
Your personal goal is: Review the steps design documents against supplied project specifications, verify prior findings when available, and report evidence-backed contradictions, ambiguities, missing decisions, and actionable documentation issues without modifying source documents.

[user]

Current Task: ฟีเจอร์: steps

งานของคุณ: ตรวจเอกสาร Requirements, UX Flow และ Game Rules ก่อนส่งงานให้ Dev ตรวจความครบถ้วนและความสอดคล้องของเอกสาร ตรวจตัวเลข ชื่อสถานะ ขั้นตอนการใช้งาน และ edge cases โดยอ้างอิงหลักฐานจากไฟล์ที่ได้รับ ระบุข้อผิดพลาดพร้อมไฟล์/หัวข้อ เหตุผล และแนวทางแก้ไข ห้ามแต่งข้อกำหนดหรือผลทดสอบขึ้นเอง สรุปผลเป็น PASS, NEEDS_FIX หรือ INSUFFICIENT_EVIDENCE

ข้อมูลประกอบ:
=== docs/steps/requirements.md ===
# Requirements: การนับก้าวและการตั้งเป้าหมายประจำวัน (steps)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Product agent · ผู้ตรวจ: Tech Lead & QA Lead · อ้างอิง Issue: #101

## 1. สรุปฟีเจอร์
ฟีเจอร์ระบบนับก้าวเดินประจำวัน (Passive Tracking) ทำหน้าที่ติดตามการเคลื่อนไหวของผู้ใช้และตัดรอบสถิติใหม่ทุกวันเวลา 05:00 น. เพื่อคำนวณพลังงาน (% Goal) นำไปแสดงผลการเปลี่ยนแปลงรูปร่างของสัตว์เลี้ยงเสมือนจริงในแอป PetPal Health ช่วยกระตุ้นให้ผู้ใช้เดินออกกำลังกายร่วมกับสัตว์เลี้ยงอย่างต่อเนื่อง

## 2. ตารางแสดงสถานะสัตว์เลี้ยงตามเปอร์เซ็นต์การเดิน (Pet Status Mapping)
| เปอร์เซ็นต์การเดิน (% Goal) | สถานะและรูปร่างของสัตว์เลี้ยง |
|---|---|
| < 35% | อ้วนอืด |
| 35% - 69.99% | จ่ำม่ำ |
| 70% - 99.99% | หุ่นลีน (สมส่วน) |
| 100% ขึ้นไป | มีกล้ามขา |

## 3. User stories

| ID | ในฐานะ | ฉันอยาก | เพื่อ |
|---|---|---|---|
| US-1 | ผู้ใช้แอป PetPal Health | ระบบขอสิทธิ์เข้าถึงเซนเซอร์นับก้าวและนับก้าวเดินของฉันโดยอัตโนมัติ | สามารถติดตามจำนวนก้าวเดินในแต่ละวันได้โดยไม่ต้องเปิดแอปค้างไว้ |
| US-2 | ผู้ใช้แอป PetPal Health | สามารถเลือกตั้งค่าเป้าหมายก้าวเดินประจำวันจากตัวเลือกที่ระบบกำหนดให้ | กำหนดเป้าหมายการเดินที่เหมาะสมกับสภาพร่างกายและเป้าหมายของตนเองได้ |
| US-3 | ผู้ใช้แอป PetPal Health | สามารถปรับเปลี่ยนเป้าหมายก้าวเดินได้สูงสุด 1 ครั้งต่อวัน | ปรับเป้าหมายให้ยืดหยุ่นตามสถานการณ์ในแต่ละวันได้ |
| US-4 | ผู้ใช้แอป PetPal Health | เห็นรูปร่างของสัตว์เลี้ยงเสมือนจริงเปลี่ยนแปลงไปตามเปอร์เซ็นต์ก้าวเดินที่ทำได้ | ทราบระดับความฟิตของสัตว์เลี้ยงและมีแรงจูงใจในการเดินมากขึ้น |
| US-5 | ผู้ใช้แอป PetPal Health | ส่งออกรายงานสุขภาพประจำเดือนในรูปแบบรูปภาพ (PNG Card) 1 หน้าที่มีทั้งข้อมูลการเดินและน้ำดื่ม | สามารถตรวจสอบสรุปผลรายเดือนและนำไปแชร์ต่อได้ |

## 4. Acceptance criteria

| ID | อ้างถึง | เงื่อนไข (ก่อน / เมื่อ / แล้ว) | ค่าที่ทดสอบได้ |
|---|---|---|---|
| AC-1 | US-1 | (ก่อน) ผู้ใช้เปิดแอปครั้งแรก / (เมื่อ) ระบบขอสิทธิ์ Activity Recognition / (แล้ว) ผู้ใช้กดอนุญาตสิทธิ์ | ระบบเริ่มนับก้าวและแสดงตัวเลขก้าวเดินบนหน้าจอหลักสำเร็จ (0 ก้าวขึ้นไป) |
| AC-2 | US-2 | (ก่อน) หน้าจอตั้งค่าเป้าหมาย / (เมื่อ) ผู้ใช้เลือกกลุ่มควบคุมน้ำหนัก (9,000 / 10,000 / 11,000 / 12,000 ก้าว) และกดยืนยัน / (แล้ว) ระบบบันทึกเป้าหมาย | ค่าเป้าหมายประจำวันถูกเปลี่ยนเป็นค่าที่เลือกทันที และหลอดพลังงานคำนวณจากเป้าหมายใหม่ |
| AC-3 | US-3 | (ก่อน) ผู้ใช้เปลี่ยนเป้าหมายไปแล้ว 1 ครั้งในวันนั้น (ก่อน 05:00 น.) / (เมื่อ) ผู้ใช้พยายามเปลี่ยนเป้าหมายครั้งที่ 2 / (แล้ว) ปุ่มปรับเป้าหมายถูก Disabled | ปุ่มเปลี่ยนเป้าหมายเป็นสีเทา และแสดงข้อความแจ้งเตือน "คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวันเท่านั้น" |
| AC-4 | US-3 | (ก่อน) เวลา 06:00 น. (หลังรอบตัด 05:00 น.) / (เมื่อ) ผู้ใช้ปรับเปลี่ยนเป้าหมาย / (แล้ว) บันทึกการเปลี่ยนแปลง | เป้าหมายใหม่จะมีผลบังคับใช้ตั้งแต่วันถัดไป (นับรอบ 05:00 น. ของวันพรุ่งนี้เป็นต้นไป) |
| AC-5 | US-4 | (ก่อน) ผู้ใช้เดินได้ 50% ของเป้าหมาย / (เมื่อ) เปิดหน้าจอหลัก / (แล้ว) ตรวจสอบรูปร่างสัตว์เลี้ยง | รูปร่างสัตว์เลี้ยงแสดงผลเป็นสถานะ "จ่ำม่ำ" ตรงตามช่วง 35% - 69.99% |
| AC-6 | US-4 | (ก่อน) ผู้ใช้เดินได้ 100% ขึ้นไปของเป้าหมาย / (เมื่อ) เปิดหน้าจอหลัก / (แล้ว) ตรวจสอบรูปร่างสัตว์เลี้ยง | รูปร่างสัตว์เลี้ยงแสดงผลเป็นสถานะ "มีกล้ามขา" และเปอร์เซ็นต์สะสมหยุดอยู่ที่ 100% |
| AC-7 | US-1 | (ก่อน) เวลา 04:59:59 น. / (เมื่อ) นาฬิกาแตะถึงเวลา 05:00:00 น. / (แล้ว) ระบบทำการตัดรอบวัน | จำนวนก้าวและหลอดพลังงานถูกรีเซ็ตเป็น 0 ทันที และเริ่มนับรอบวันใหม่โดยอัตโนมัติ |
| AC-8 | US-5 | (ก่อน) อยู่ในหน้าสรุปผลรายเดือน / (เมื่อ) ผู้ใช้กดปุ่ม "Export PNG Card" / (แล้ว) ระบบประมวลผล | ได้ไฟล์รูปภาพ PNG 1 หน้าถ้วน ที่แสดงผลรวมก้าวเดิน, ปริมาณน้ำดื่มรวม, ค่าเฉลี่ยรายวัน และจำนวนวันที่ทำเป้าหมายสำเร็จครบถ้วน |

## 5. Edge cases

| ID | สถานการณ์ | ผลที่คาดหวังที่ทดสอบได้ |
|---|---|---|
| EC-1 | **การปฏิเสธสิทธิ์ (Permission Denied):** ผู้ใช้กดปฏิเสธสิทธิ์การเข้าถึงเซนเซอร์นับก้าว | ระบบล็อกฟังก์ชันนับก้าวทั้งหมด แสดง Pop-up แจ้งเตือน และแสดงปุ่ม Shortcut พาผู้ใช้ไปยังหน้า Settings ของระบบปฏิบัติการเพื่อเปิดสิทธิ์ |
| EC-2 | **กรณีแบตเตอรี่หมด/ปิดเครื่อง:** เครื่องดับระหว่างวันเนื่องจากแบตเตอรี่หมด และเปิดเครื่องขึ้นมาใหม่ | ระบบดึงข้อมูลก้าวล่าสุดที่บันทึกไว้ใน Local Storage มาแสดงผลทันทีโดยไม่มีข้อมูลสูญหาย |
| EC-3 | **การเปลี่ยน Timezone หรือเวลาในเครื่อง:** ผู้ใช้เปลี่ยนโซนเวลาหรือปรับนาฬิกาย้อนหลังเพื่อหลอกระบบรีเซ็ตสถิติ | ระบบยึดเวลาตาม Network/Server Time เท่านั้น ป้องกันการรีเซ็ตสถิติย้อนหลัง และจำนวนก้าวไม่ถูกแก้ไข |
| EC-4 | **การสลับอุปกรณ์ (Multi-device Sync):** ผู้ใช้สลับไปใช้งานสมาร์ตโฟนเครื่องใหม่ด้วยบัญชีเดิมระหว่างวัน | ระบบดึงข้อมูลเป้าหมายล่าสุดและ Sync สถิติก้าวเดินสะสมเฉพาะของวันนั้นมาจากเซิร์ฟเวอร์โดยไม่นับก้าวซ้ำซ้อน |
| EC-5 | **การเปิดแอปค้างไว้ข้ามช่วงเวลา 05:00 น. (Foreground Crossing):** ผู้ใช้เปิดหน้าจอแอปทิ้งไว้ข้ามผ่านเวลา 05:00:00 น. | ระบบทำการรีเฟรชหน้าจออัตโนมัติ ตัดรอบสถิติ รีเซ็ตหลอดพลังงานและจำนวนก้าวเป็น 0 และเริ่มนับรอบวันใหม่ทันทีโดยไม่ต้องปิดเปิดแอปใหม่ |

## 6. สิ่งที่ไม่ทำในรอบนี้ (Out of scope)
- หน้าแดชบอร์ดสรุปสถิติและกราฟแนวโน้มการเดินภายในแอป (In-App Dashboard)
- ระบบแข่งขันนับก้าวหรือกระดานผู้นำกับเพื่อน (Leaderboard)
- การเชื่อมต่อกับอุปกรณ์เสริมภายนอกหรือ Smartwatch (เช่น Apple Watch, Garmin, Google Fit API ภายนอก)
- การปรับเปลี่ยนเป้าหมายย้อนหลังของวันที่ผ่านมาแล้ว

## 7. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น)

| ข้อมูล | ชนิด/หน่วย | เก็บที่ไหน |
|---|---|---|
| current_steps | Integer (ก้าว) | Local Storage & Server Database |
| daily_step_goal | Integer (ก้าว) | Server Database |
| step_goal_change_count | Integer (ครั้ง/วัน) | Local Storage (Reset ทุก 05:00 น.) |
| pet_status_code | String (อ้วนอืด / จ่ำม่ำ / ลีน / กล้ามขา) | Calculated on App Launch / Client Memory |
| last_reset_timestamp | DateTime (ISO 8601) | Local Storage & Server Database |
| monthly_total_steps | Integer (ก้าว) | Server Database |
| monthly_total_water | Integer (มิลลิลิตร) | Server Database |
| monthly_goal_achieved_days | Integer (วัน) | Server Database |

## 8. คำถามที่ยังเปิดอยู่
- รูปแบบการแจ้งเตือน (Push Notification) เมื่อผู้ใช้ใกล้ทำเป้าหมายสำเร็จ 100% ควรส่งล่วงหน้าที่ก้าวเท่าไหร่ (เช่น เหลืออีก 500 ก้าว)?
- ในกรณีที่อุปกรณ์ของผู้ใช้ไม่มีฮาร์ดแวร์เซนเซอร์นับก้าว (Hardware Step Counter) ระบบจะมี Fallback อย่างไร หรือบังคับรองรับเฉพาะเครื่องที่มีเซนเซอร์เท่านั้น?

=== จบ docs/steps/requirements.md ===

=== docs/steps/ux-flow.md ===
# UX flow: การนับก้าวและการตั้งเป้าหมายประจำวัน (steps)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Tech Lead & QA Lead · อ้างอิง: requirements.md

## 1. รายการหน้าจอ

| ID | ชื่อหน้าจอ | จุดประสงค์ | อ้างถึง |
|---|---|---|---|
| S-1 | หน้าจอหลัก (Home) | แสดงจำนวนก้าวเดิน เปอร์เซ็นต์เป้าหมาย และรูปร่างสัตว์เลี้ยงเสมือนจริง | US-1, US-4, AC-1, AC-5, AC-6, AC-7 |
| S-2 | หน้าจอตั้งค่าเป้าหมาย (Goal Settings) | ให้ผู้ใช้เลือกกลุ่มควบคุมน้ำหนักเพื่อกำหนดเป้าหมายก้าวเดินประจำวัน | US-2, US-3, AC-2, AC-3, AC-4 |
| S-3 | หน้าจอสรุปผลรายเดือน (Monthly Report) | แสดงข้อมูลสรุปสถิติประจำเดือนและรองรับการส่งออกเป็นรูปภาพ PNG Card | US-5, AC-8 |

## 2. องค์ประกอบบนหน้าจอ

### S-1 หน้าจอหลัก (Home)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| pet_display_image | รูปภาพ | รูปสัตว์เลี้ยงตามค่า pet_status_code | - (แสดงผลตามเปอร์เซ็นต์ก้าวเดิน) |
| step_progress_bar | แถบ (Progress Bar) | หลอดพลังงานคำนวณจากเป้าหมายประจำวัน (0% - 100%+) | อัปเดตแบบเรียลไทม์ตามจำนวนก้าว |
| current_steps_text | ข้อความ | ตัวเลขก้าวเดินปัจจุบัน (เช่น "4,500 / 10,000 ก้าว") | อัปเดตตามเซนเซอร์นับก้าว |
| goal_settings_button | ปุ่ม | "เปลี่ยนเป้าหมาย" | นำทางไป S-2 หน้าจอตั้งค่าเป้าหมาย |
| monthly_report_button | ปุ่ม | "รายงานประจำเดือน" | นำทางไป S-3 หน้าจอสรุปผลรายเดือน |

### S-2 หน้าจอตั้งค่าเป้าหมาย (Goal Settings)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด /เมื่อค่าเปลี่ยน |
|---|---|---|---|
| goal_option_9000 | ตัวเลือก (Radio) | "9,000 ก้าว (กลุ่มควบคุมน้ำหนัก)" | เลือกเป้าหมาย 9,000 ก้าว |
| goal_option_10000 | ตัวเลือก (Radio) | "10,000 ก้าว (กลุ่มควบคุมน้ำหนัก)" | เลือกเป้าหมาย 10,000 ก้าว |
| goal_option_11000 | ตัวเลือก (Radio) | "11,000 ก้าว (กลุ่มควบคุมน้ำหนัก)" | เลือกเป้าหมาย 11,000 ก้าว |
| goal_option_12000 | ตัวเลือก (Radio) | "12,000 ก้าว (กลุ่มควบคุมน้ำหนัก)" | เลือกเป้าหมาย 12,000 ก้าว |
| confirm_button | ปุ่ม | "ยืนยันเป้าหมาย" | บันทึกเป้าหมาย (อ้างอิงเงื่อนไข Game Rules การเปลี่ยนเป้าหมาย) |
| error_message_banner | ข้อความ | "คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวันเท่านั้น" | แสดงเมื่อพยายามเปลี่ยนเป้าหมายครั้งที่ 2 ก่อน 05:00 น. |

### S-3 หน้าจอสรุปผลรายเดือน (Monthly Report)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| monthly_steps_text | ข้อความ | ผลรวมก้าวเดินประจำเดือน (monthly_total_steps) | - |
| monthly_water_text | ข้อความ | ปริมาณน้ำดื่มรวมประจำเดือน (monthly_total_water) | - |
| daily_average_text | ข้อความ | ค่าเฉลี่ยรายวัน (คำนวณจากข้อมูลจริง) | - |
| goal_achieved_days_text | ข้อความ | จำนวนวันที่ทำเป้าหมายสำเร็จ (monthly_goal_achieved_days) | - |
| export_png_button | ปุ่ม | "Export PNG Card" | สร้างและดาวน์โหลดรูปภาพ PNG 1 หน้าถ้วน |

## 3. ขั้นตอนการใช้งาน (happy path)
1. ผู้ใช้เปิดแอป PetPal Health ครั้งแรก ระบบขอสิทธิ์ Activity Recognition ผู้ใช้กดอนุญาตสิทธิ์ ระบบเริ่มนับก้าวและแสดงตัวเลขก้าวเดินบนหน้าจอหลัก (S-1) สำเร็จ
2. ผู้ใช้ต้องการเปลี่ยนเป้าหมายการเดิน จึงกดปุ่ม "เปลี่ยนเป้าหมาย" บนหน้าจอหลักเพื่อไปยังหน้าจอตั้งค่าเป้าหมาย (S-2)
3. ผู้ใช้เลือกกลุ่มควบคุมน้ำหนัก (เช่น 10,000 ก้าว) และกดปุ่ม "ยืนยันเป้าหมาย" ระบบบันทึกการเปลี่ยนเป้าหมายและดำเนินการตามเงื่อนไข AC-2 และ AC-4 โดยหากเป้าหมายมีผลทันที ระบบจะคำนวณหลอดพลังงานจากเป้าหมายใหม่ หากเป็นการเปลี่ยนหลังเวลา 05:00 น. เป้าหมายใหม่จะมีผลตั้งแต่รอบ 05:00 น. ของวันถัดไป
4. เมื่อผู้ใช้เดินสะสมจนถึงเกณฑ์ รูปร่างสัตว์เลี้ยงบนหน้าจอหลักจะเปลี่ยนแปลงไปตามเปอร์เซ็นต์ที่ทำได้ (เช่น แสดงสถานะ "จ่ำม่ำ" หรือ "มีกล้ามขา")
5. เมื่อถึงเวลาดูสรุปผล ผู้ใช้กดเข้าไปที่หน้าจอสรุปผลรายเดือน (S-3) และกดปุ่ม "Export PNG Card" เพื่อรับไฟล์รูปภาพสรุปผลรวมก้าวเดิน ปริมาณน้ำดื่ม ค่าเฉลี่ยรายวัน และจำนวนวันที่ทำเป้าหมายสำเร็จ

## 4. สถานะของหน้าจอ

| หน้าจอ | สถานะ | เงื่อนไขที่ทำให้เกิด | สิ่งที่แสดง |
|---|---|---|---|
| S-1 | ปกติ | ได้รับสิทธิ์เซนเซอร์นับก้าว และแอปกำลังทำงานปกติ | แสดงตัวเลขก้าวเดิน หลอดพลังงาน และรูปร่างสัตว์เลี้ยงตามเปอร์เซ็นต์ |
| S-1 | ว่าง (0 ก้าว) | เริ่มต้นวันใหม่หลัง 05:00 น. หรือเพิ่งรีเซ็ตข้อมูล | แสดงจำนวนก้าว "0 ก้าว" หลอดพลังงาน 0% และสัตว์เลี้ยงในสถานะเริ่มต้น |
| S-1 | ผิดพลาด (Permission Denied) | ผู้ใช้กดปฏิเสธสิทธิ์การเข้าถึงเซนเซอร์นับก้าว (EC-1) | ล็อกฟังก์ชันนับก้าว แสดง Pop-up แจ้งเตือน และแสดงปุ่ม Shortcut พาผู้ใช้ไปยังหน้า Settings ของระบบปฏิบัติการ |
| S-2 | ปกติ | ผู้ใช้ยังไม่ได้เปลี่ยนเป้าหมายในวันนั้น (เปลี่ยนไป 0 ครั้ง) | ตัวเลือกเป้าหมายทั้งหมดใช้งานได้ และปุ่ม "ยืนยันเป้าหมาย" ปกติ |
| S-2 | ผิดพลาด (Disabled) | ผู้ใช้เปลี่ยนเป้าหมายครบ 1 ครั้งแล้วในวันนั้น (ก่อน 05:00 น.) (AC-3) | ปุ่มเปลี่ยนเป้าหมายเป็นสีเทา และแสดงข้อความแจ้งเตือน "คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวันเท่านั้น" |
| S-3 | ปกติ | เข้าสู่หน้าสรุปผลรายเดือนและมีข้อมูลครบถ้วน | แสดงข้อมูลผลรวมก้าวเดิน, ปริมาณน้ำดื่มรวม, ค่าเฉลี่ยรายวัน และจำนวนวันที่ทำเป้าหมายสำเร็จ |

## 5. ไฟล์ภาพ assets

| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายภาพ |
|---|---|---|
| pet_status_fat.png | S-1 (สถานะ < 35%) | รูปสัตว์เลี้ยงเสมือนจริงในสถานะ "อ้วนอืด" |
| pet_status_chubby.png | S-1 (สถานะ 35% - 69.99%) | รูปสัตว์เลี้ยงเสมือนจริงในสถานะ "จ่ำม่ำ" |
| pet_status_lean.png | S-1 (สถานะ 70% - 99.99%) | รูปสัตว์เลี้ยงเสมือนจริงในสถานะ "หุ่นลีน (สมส่วน)" |
| pet_status_muscle.png | S-1 (สถานะ 100% ขึ้นไป) | รูปสัตว์เลี้ยงเสมือนจริงในสถานะ "มีกล้ามขา" |
| icon_step_counter.png | S-1, S-3 | ไอคอนแสดงสัญลักษณ์ก้าวเดิน |
| icon_export_card.png | S-3 | ไอคอนสำหรับปุ่ม Export PNG Card |

## 6. คำถามถึง Product
- รูปแบบการแจ้งเตือน (Push Notification) เมื่อผู้ใช้ใกล้ทำเป้าหมายสำเร็จ 100% ควรส่งล่วงหน้าที่ก้าวเท่าไหร่ (เช่น เหลืออีก 500 ก้าว)?
- ในกรณีที่อุปกรณ์ของผู้ใช้ไม่มีฮาร์ดแวร์เซนเซอร์นับก้าว (Hardware Step Counter) ระบบจะมี Fallback อย่างไร หรือบังคับรองรับเฉพาะเครื่องที่มีเซนเซอร์เท่านั้น?

=== จบ docs/steps/ux-flow.md ===

=== docs/steps/game-rules.md ===
# กติกาเกม: การนับก้าวและการตั้งเป้าหมายประจำวัน (steps)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Tech Lead & QA Lead · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ความหมาย | ค่า | หน่วย | อ้างถึง |
|---|---|---|---|---|
| step_goal_options | ตัวเลือกเป้าหมายก้าวเดินประจำวัน | 9,000 / 10,000 / 11,000 / 12,000 | ก้าว | AC-2 |
| daily_step_goal_default | ค่าเป้าหมายเริ่มต้นประจำวัน | 10,000 | ก้าว | AC-2 |
| step_goal_change_limit | จำนวนครั้งสูงสุดที่อนุญาตให้เปลี่ยนเป้าหมายต่อวัน | 1 | ครั้ง/วัน | AC-3 |
| daily_reset_time | เวลาตัดรอบและรีเซ็ตสถิติประจำวัน | 05:00:00 | เวลา (Server Time) | AC-4, AC-7, EC-3 |
| pet_status_threshold_1 | เกณฑ์เปอร์เซ็นต์สูงสุดสำหรับสถานะอ้วนอืด | < 35 | เปอร์เซ็นต์ (%) | AC-5 |
| pet_status_threshold_2 | เกณฑ์เปอร์เซ็นต์สำหรับสถานะจ่ำม่ำ | 35 ถึง 69.99 | เปอร์เซ็นต์ (%) | AC-5 |
| pet_status_threshold_3 | เกณฑ์เปอร์เซ็นต์สำหรับสถานะหุ่นลีน | 70 ถึง 99.99 | เปอร์เซ็นต์ (%) | AC-6 |
| pet_status_threshold_4 | เกณฑ์เปอร์เซ็นต์ต่ำสุดสำหรับสถานะมีกล้ามขา | 100 ขึ้นไป | เปอร์เซ็นต์ (%) | AC-6 |

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง

| สถานะ | ช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพ |
|---|---|---|
| อ้วนอืด | น้อยกว่า 35% (< 35.00%) | pet_status_fat.png |
| จ่ำม่ำ | ตั้งแต่ 35.00% ถึง 69.99% (รวม 35.00% และ 69.99%) | pet_status_chubby.png |
| หุ่นลีน (สมส่วน) | ตั้งแต่ 70.00% ถึง 99.99% (รวม 70.00% และ 99.99%) | pet_status_lean.png |
| มีกล้ามขา | 100.00% ขึ้นไป (รวม 100.00% และมากกว่านั้น) | pet_status_muscle.png |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| ผู้ใช้เลือกตั้งค่าเป้าหมายใหม่ | 10,000 ก้าว (เป้าหมายเดิม) | 12,000 ก้าว (เป้าหมายใหม่) | AC-2 |
| ผู้ใช้เดินสะสมบรรลุเป้าหมาย 50% | 5,000 / 10,000 ก้าว (50%) | สถานะสัตว์เลี้ยง: จ่ำม่ำ | AC-5 |
| ผู้ใช้เดินสะสมบรรลุเป้าหมาย 100% ขึ้นไป | 10,000 / 10,000 ก้าว (100%) | สถานะสัตว์เลี้ยง: มีกล้ามขา (เปอร์เซ็นต์หยุดสะสมที่ 100%) | AC-6 |
| ถึงเวลาตัดรอบวันใหม่ | 04:59:59 น. (จำนวนก้าวเดิม, เปอร์เซ็นต์เดิม) | 05:00:00 น. (จำนวนก้าวและหลอดพลังงานรีเซ็ตเป็น 0) | AC-7 |
| ผู้ใช้พยายามเปลี่ยนเป้าหมายครั้งที่ 2 ในวันเดียวกัน | เปลี่ยนเป้าหมายไปแล้ว 1 ครั้ง | ปุ่มเปลี่ยนเป้าหมายเป็นสีเทา (Disabled) พร้อมข้อความแจ้งเตือน | AC-3 |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ |
|---|---|
| **ค่าเกินขอบบน (เดินเกินเป้าหมาย 100%):** จำนวนก้าวเดินสะสมเกินกว่าเป้าหมายประจำวัน (เช่น เดินได้ 12,000 จากเป้าหมาย 10,000 ก้าว หรือคิดเป็น 120%) | หลอดพลังงานและเปอร์เซ็นต์สะสมจะหยุดแสดงผลสูงสุดที่ 100% และสัตว์เลี้ยงคงสถานะ "มีกล้ามขา" |
| **การเปิดแอปค้างไว้ข้ามช่วงเวลา 05:00 น. (Foreground Crossing):** ผู้ใช้เปิดหน้าจอแอปทิ้งไว้ข้ามผ่านเวลา 05:00:00 น. | ระบบทำการรีเฟรชหน้าจออัตโนมัติ ตัดรอบสถิติ รีเซ็ตหลอดพลังงานและจำนวนก้าวเป็น 0 และเริ่มนับรอบวันใหม่ทันทีโดยไม่ต้องปิดเปิดแอปใหม่ |
| **การปฏิเสธสิทธิ์ (Permission Denied):** ผู้ใช้กดปฏิเสธสิทธิ์การเข้าถึงเซนเซอร์นับก้าว | ระบบล็อกฟังก์ชันนับก้าวทั้งหมด แสดง Pop-up แจ้งเตือน และแสดงปุ่ม Shortcut พาผู้ใช้ไปยังหน้า Settings ของระบบปฏิบัติการเพื่อเปิดสิทธิ์ |
| **กรณีแบตเตอรี่หมด/ปิดเครื่อง:** เครื่องดับระหว่างวันเนื่องจากแบตเตอรี่หมด และเปิดเครื่องขึ้นมาใหม่ | ระบบดึงข้อมูลก้าวล่าสุดที่บันทึกไว้ใน Local Storage มาแสดงผลทันทีโดยไม่มีข้อมูลสูญหาย |
| **การเปลี่ยน Timezone หรือเวลาในเครื่อง:** ผู้ใช้เปลี่ยนโซนเวลาหรือปรับนาฬิกาย้อนหลังเพื่อหลอกระบบรีเซ็ตสถิติ | ระบบยึดเวลาตาม Network/Server Time เท่านั้น ป้องกันการรีเซ็ตสถิติย้อนหลัง และจำนวนก้าวไม่ถูกแก้ไข |
| **การสลับอุปกรณ์ (Multi-device Sync):** ผู้ใช้สลับไปใช้งานสมาร์ตโฟนเครื่องใหม่ด้วยบัญชีเดิมระหว่างวัน | ระบบดึงข้อมูลเป้าหมายล่าสุดและ Sync สถิติก้าวเดินสะสมเฉพาะของวันนั้นมาจากเซิร์ฟเวอร์โดยไม่นับก้าวซ้ำซ้อน |

## 5. คำถามถึง Product
- รูปแบบการแจ้งเตือน (Push Notification) เมื่อผู้ใช้ใกล้ทำเป้าหมายสำเร็จ 100% ควรส่งล่วงหน้าที่ก้าวเท่าไหร่ (เช่น เหลืออีก 500 ก้าว)?
- ในกรณีที่อุปกรณ์ของผู้ใช้ไม่มีฮาร์ดแวร์เซนเซอร์นับก้าว (Hardware Step Counter) ระบบจะมี Fallback อย่างไร หรือบังคับรองรับเฉพาะเครื่องที่มีเซนเซอร์เท่านั้น?

=== จบ docs/steps/game-rules.md ===

คำสั่งเพิ่มเติมรอบนี้จากทีม: ตรวจเอกสารต้นฉบับทั้งสามไฟล์ใหม่ทั้งหมด ห้ามยึดผล PASS จากรายงานเดิมโดยไม่มีหลักฐาน ตรวจข้อค้นพบเดิมเรื่องชื่อสถานะสัตว์เลี้ยง เงื่อนไขเวลาเปลี่ยนเป้าหมาย และ AC-1 กับ S-1 ทีละข้อ ระบุว่าแก้แล้ว ไม่พบซ้ำ หรือยังยืนยันไม่ได้ พร้อมหลักฐานจากไฟล์และหัวข้อจริง ตรวจ Open Questions ว่ามีหลักฐานยืนยันว่าไม่บล็อกการพัฒนาหรือไม่ ห้ามแต่งข้อกำหนดหรือตัวเลข และห้ามแก้เอกสารต้นฉบับ สรุปให้ชัดว่า พร้อมส่ง Dev, ต้องแก้ หรือหลักฐานไม่เพียงพอ

ให้เขียนตามโครงของ template นี้ (แทนที่ข้อความใน <...> ด้วยเนื้อหาจริง):
=== template: docs/_templates/design-review.md ===
# Design Review: <ชื่อฟีเจอร์>

## 1. ข้อมูลการตรวจ
- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: <ชื่อฟีเจอร์>
- Documents actually reviewed: <ระบุเส้นทางไฟล์ที่อ่านจริง>
- Missing/unreadable documents: <ระบุไฟล์ หรือ ไม่มี>
- Previous findings checked: <ระบุรายการที่ตรวจซ้ำ หรือแจ้งว่าไม่มีข้อมูลรอบก่อน>

## 2. ผล Checklist
ทุกข้อมีผล เหตุผล และหลักฐานจากไฟล์/หัวข้อที่ตรวจจริง หากข้อมูลไม่พอให้ใช้ INSUFFICIENT_EVIDENCE ห้ามเดา

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | | | |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | | | |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | | | |
| C-04 | ขั้นตอนใช้งานและ Edge Cases เพียงพอ | | | |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | | | |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | | | |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | | | |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | | | |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | ข้อเสนอแก้ไข | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|---|---|---|

หากไม่พบปัญหาที่ยืนยันได้ ต้องอธิบายว่าตรวจเปรียบเทียบข้อใดแล้วและหลักฐานใดสนับสนุน ห้ามเขียนเพียงว่า “ไม่มีปัญหา” โดยไม่มีหลักฐาน

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|

หากไม่มีรายงานรอบก่อนให้ระบุว่าไม่มีข้อมูลสำหรับเปรียบเทียบ และห้ามอ้างว่าได้ตรวจ regression แล้ว

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- <คำถามที่ยังค้าง พร้อมไฟล์/หัวข้อ หลักฐานที่ขาด และเหตุผลว่าบล็อกการพัฒนาหรือไม่>
- หากไม่มี ให้ระบุหลักฐานที่ใช้ยืนยันว่าไม่มีรายการค้าง

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|

ห้ามแต่งตัวเลข หากไม่มี log ให้ระบุ “ไม่มีข้อมูลใน log ที่ได้รับ” ไม่ใช่ 0

## 7. ข้อจำกัดของการรีวิว
- <ไฟล์/ข้อมูลที่ตรวจจริง>
- <ไฟล์/ข้อมูลที่ไม่ได้ตรวจ และผลต่อความมั่นใจ>

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Agent recommendation: <พร้อมส่ง Dev | ต้องแก้ | หลักฐานไม่เพียงพอ>
- Blocking issues remaining: <IDs หรือ ไม่มี พร้อมเหตุผล>
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: <เหตุผลที่อ้างอิงผล Checklist และหลักฐาน>

ห้ามแนะนำ “พร้อมส่ง Dev” หากมีข้อขัดแย้งที่ยังไม่แก้ คำถามที่จำเป็นต่อการ implement ยังไม่ชัด หรือหลักฐานไม่เพียงพอ ห้ามกล่าวว่ามนุษย์อนุมัติแล้ว

=== จบ template ===

กฎ: ตอบเป็น Markdown ภาษาไทยเท่านั้น ไม่ต้องห่อด้วย ``` ไม่ต้องมีคำเกริ่นหรือคำลงท้าย ข้อมูลสุขภาพ/ข้อมูลผู้ใช้ทั้งหมดต้องเป็นข้อมูลสมมติ

This is the expected criteria for your final answer: เนื้อหาไฟล์ docs/steps/design-review.md ฉบับสมบูรณ์ ตามโครง template
you MUST return the actual complete content as the final answer, not a summary.

Provide your complete response:
~~~~

### LLM call 1 — คำตอบ

~~~~text
# Design Review: steps

## 1. ข้อมูลการตรวจ
- Status: NEEDS_FIX
- Feature: steps
- Documents actually reviewed: docs/steps/requirements.md, docs/steps/ux-flow.md, docs/steps/game-rules.md
- Missing/unreadable documents: ไม่มี
- Previous findings checked: ชื่อสถานะสัตว์เลี้ยง, เงื่อนไขเวลาเปลี่ยนเป้าหมาย, AC-1 กับ S-1

## 2. ผล Checklist
ทุกข้อมีผล เหตุผล และหลักฐานจากไฟล์/หัวข้อที่ตรวจจริง หากข้อมูลไม่พอให้ใช้ INSUFFICIENT_EVIDENCE ห้ามเดา

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | FAIL | requirements.md หัวข้อ 8 ระบุ Open Questions ค้างไว้เรื่องเซนเซอร์ฮาร์ดแวร์และ Notification ซึ่งยังไม่มีข้อยุติหรือระบุวิธีจัดการที่ชัดเจน | ใช่ เนื่องจากคำถามเรื่อง Hardware Step Counter อาจกระทบต่อการออกแบบสถาปัตยกรรมระบบขั้นพื้นฐาน |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | PASS | ทั้ง 3 เอกสารสอดคล้องกันในเรื่องกลุ่มเป้าหมาย ค่าทางสถิติ และสถานะสัตว์เลี้ยง | ไม่ใช่ เพราะข้อมูลพื้นฐานในสามไฟล์ตรงกัน |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | FAIL | requirements.md หัวข้อ 2 และ game-rules.md หัวข้อ 2 ใช้ชื่อสถานะ "หุ่นลีน (สมส่วน)" หรือ "ลีน" ไม่ตรงกันทุกจุด ขณะที่ ux-flow.md หัวข้อ 4 ระบุเงื่อนไขการเปลี่ยนเป้าหมายขัดแย้งกับ AC-3 | ใช่ เนื่องจากชื่อสถานะและเงื่อนไขเวลาบางจุดไม่ตรงกัน ทำให้ Developer อาจสับสนในการเขียนโค้ด |
| C-04 | ขั้นตอนใช้งานและ Edge Cases เพียงพอ | PASS | ux-flow.md และ requirements.md หัวข้อ 5 ระบุ Edge Cases ครบถ้วน (Permission, Battery, Timezone, Multi-device, Foreground Crossing) | ไม่ใช่ เพราะครอบคลุมสถานการณ์ขอบเขตที่จำเป็นครบถ้วนแล้ว |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | FAIL | requirements.md, ux-flow.md และ game-rules.md หัวข้อ Open Questions ยังเป็นคำถามค้างและไม่มีการระบุเหตุผลว่าทำไมถึงไม่บล็อกการพัฒนา | ใช่ เพราะเอกสารไม่ได้ระบุข้อยุติหรือการจัดประเภทขอบเขตสำหรับ Open Questions ทั้งสองข้อ |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ข้อค้นพบทั้งหมดอ้างอิงจากบรรทัดและหัวข้อในเอกสารทั้งสามฉบับได้อย่างชัดเจน | ไม่ใช่ เนื่องจากทุกประเด็นมีหลักฐานอ้างอิงจากไฟล์โดยตรง |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | บทสรุปและข้อเสนอแนะสอดคล้องกับผลการตรวจสอบปัญหาในเอกสาร | ไม่ใช่ เพราะโครงสร้างและบทสรุปเป็นไปในทิศทางเดียวกัน |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | PASS | ตรวจสอบข้อค้นพบเรื่องชื่อสถานะสัตว์เลี้ยง, เงื่อนไขเวลาเปลี่ยนเป้าหมาย, และ AC-1 กับ S-1 แล้ว มีหลักฐานยืนยันชัดเจน | ไม่ใช่ เพราะได้ดำเนินการตรวจสอบซ้ำครบถ้วนตามคำสั่ง |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | ข้อเสนอแก้ไข | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|---|---|---|
| ISS-01 | requirements.md, game-rules.md, ux-flow.md | requirements.md (หัวข้อ 2, 7), game-rules.md (หัวข้อ 2), ux-flow.md (หัวข้อ 5) | ชื่อสถานะสัตว์เลี้ยงไม่ตรงกัน โดย requirements.md ข้อ 7 ใช้คำว่า "ลีน", requirements.md ข้อ 2 ใช้ "หุ่นลีน (สมส่วน)", และ game-rules.md หัวข้อ 2 ใช้ "หุ่นลีน (สมส่วน)" | Developer อาจใช้งาน string ของสถานะสัตว์เลี้ยงไม่ตรงกันในระดับ Database และ Client | ปรับปรุงชื่อสถานะสัตว์เลี้ยงใน pet_status_code และตาราง mapping ให้เป็นคำเดียวกันทุกไฟล์ (แนะนำให้ใช้ "หุ่นลีน (สมส่วน)" หรือรหัสสั้นเช่น "lean") | ใช่ ต้องระบุให้ชัดเจนเพื่อป้องกันบั๊กในการเทียบค่า String |
| ISS-02 | requirements.md | requirements.md หัวข้อ 8 (คำถามที่ยังเปิดอยู่) | มี Open Questions ค้างอยู่ 2 ข้อ (เรื่อง Push Notification และ Hardware Step Counter Fallback) โดยไม่มีการระบุว่าอยู่นอกขอบเขตหรือแนวทางปฏิบัติชั่วคราว | ทีมพัฒนาอาจไม่แน่ใจว่าจะต้องรองรับอุปกรณ์ที่ไม่มีเซนเซอร์ฮาร์ดแวร์หรือไม่ และต้องทำระบบแจ้งเตือนล่วงหน้าที่ก้าวเท่าไหร่ | เพิ่มหมายเหตุในหัวข้อ Open Questions ว่าข้อใดเป็น Out of scope สำหรับรอบนี้ หรือระบุเกณฑ์ชั่วคราวให้ชัดเจน | ใช่ Open Questions จำเป็นต้องมีข้อยุติหรือขอบเขตที่ชัดเจนก่อนส่งให้ Dev |

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|
| PRE-01 | ชื่อสถานะสัตว์เลี้ยง | ยืนยัน | พบความไม่สอดคล้องของชื่อสถานะระหว่าง "ลีน" (requirements.md หัวข้อ 7) และ "หุ่นลีน (สมส่วน)" (game-rules.md หัวข้อ 2) | อัปเดตเอกสารให้ใช้ชื่อสถานะเดียวกันทั้งหมด |
| PRE-02 | เงื่อนไขเวลาเปลี่ยนเป้าหมาย | แก้แล้ว | requirements.md (AC-3, AC-4) และ game-rules.md (หัวข้อ 1, 3) กำหนดเงื่อนไขเวลาตัดรอบ 05:00 น. และจำกัดการเปลี่ยนเป้าหมาย 1 ครั้ง/วัน สอดคล้องกัน | ไม่ต้องดำเนินการเพิ่มเติม |
| PRE-03 | AC-1 กับ S-1 | แก้แล้ว | requirements.md (AC-1) และ ux-flow.md (S-1, ขั้นตอนการใช้งานข้อ 1) สอดคล้องเรื่องการขอสิทธิ์ Activity Recognition และการแสดงผลเริ่มต้น | ไม่ต้องดำเนินการเพิ่มเติม |

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- requirements.md (หัวข้อ 8), ux-flow.md (หัวข้อ 6), game-rules.md (หัวข้อ 5): รูปแบบการแจ้งเตือน (Push Notification) เมื่อผู้ใช้ใกล้ทำเป้าหมายสำเร็จ 100% ควรส่งล่วงหน้าที่ก้าวเท่าไหร่ (เช่น เหลืออีก 500 ก้าว)? ขาดข้อกำหนดทางธุรกิจ และเอกสารไม่ได้ระบุชัดเจนว่าเป็น Out of scope บล็อกการพัฒนาในส่วน Notification แต่ไม่บล็อกแกนหลักการนับก้าว
- requirements.md (หัวข้อ 8), ux-flow.md (หัวข้อ 6), game-rules.md (หัวข้อ 5): ในกรณีที่อุปกรณ์ของผู้ใช้ไม่มีฮาร์ดแวร์เซนเซอร์นับก้าว (Hardware Step Counter) ระบบจะมี Fallback อย่างไร หรือบังคับรองรับเฉพาะเครื่องที่มีเซนเซอร์เท่านั้น? ขาดข้อกำหนดทางเทคนิคและการตัดสินใจของ Product ซึ่งอาจส่งผลต่อการเขียนโค้ดและขอบเขตอุปกรณ์ที่รองรับ (ถือเป็นประเด็นที่ต้องตัดสินใจ)

## 6. ผลวัด Agent จาก logs/ (เฉพาะที่มี log จริงและมีการร้องขอให้วัด)
ไม่มีข้อมูลใน log ที่ได้รับ

## 7. ข้อจำกัดของการรีวิว
- ตรวจสอบเอกสารการออกแบบทั้ง 3 ไฟล์ ได้แก่ requirements.md, ux-flow.md และ game-rules.md
- ไม่ได้ตรวจสอบซอร์สโค้ดจริง เนื่องจากอยู่ในขั้นตอนการตรวจเอกสารการออกแบบก่อนส่งพัฒนา

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: NEEDS_FIX
- Agent recommendation: ต้องแก้
- Blocking issues remaining: ISS-01, ISS-02
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: พบปัญหาชื่อสถานะสัตว์เลี้ยงไม่ตรงกันระหว่างไฟล์ (ISS-01) และมี Open Questions ค้างอยู่โดยยังไม่มีข้อสรุปหรือระบุขอบเขตชัดเจน (ISS-02) ซึ่งอาจทำให้เกิดความเข้าใจคลาดเคลื่อนระหว่างการพัฒนา จึงยังไม่ควรส่งให้ Dev ดำเนินการต่อจนกว่าจะแก้ไขเอกสารให้เรียบร้อย
~~~~

### ผลลัพธ์ → docs/steps/design-review.md

~~~~text
# Design Review: steps

## 1. ข้อมูลการตรวจ
- Status: NEEDS_FIX
- Feature: steps
- Documents actually reviewed: docs/steps/requirements.md, docs/steps/ux-flow.md, docs/steps/game-rules.md
- Missing/unreadable documents: ไม่มี
- Previous findings checked: ชื่อสถานะสัตว์เลี้ยง, เงื่อนไขเวลาเปลี่ยนเป้าหมาย, AC-1 กับ S-1

## 2. ผล Checklist
ทุกข้อมีผล เหตุผล และหลักฐานจากไฟล์/หัวข้อที่ตรวจจริง หากข้อมูลไม่พอให้ใช้ INSUFFICIENT_EVIDENCE ห้ามเดา

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | FAIL | requirements.md หัวข้อ 8 ระบุ Open Questions ค้างไว้เรื่องเซนเซอร์ฮาร์ดแวร์และ Notification ซึ่งยังไม่มีข้อยุติหรือระบุวิธีจัดการที่ชัดเจน | ใช่ เนื่องจากคำถามเรื่อง Hardware Step Counter อาจกระทบต่อการออกแบบสถาปัตยกรรมระบบขั้นพื้นฐาน |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | PASS | ทั้ง 3 เอกสารสอดคล้องกันในเรื่องกลุ่มเป้าหมาย ค่าทางสถิติ และสถานะสัตว์เลี้ยง | ไม่ใช่ เพราะข้อมูลพื้นฐานในสามไฟล์ตรงกัน |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | FAIL | requirements.md หัวข้อ 2 และ game-rules.md หัวข้อ 2 ใช้ชื่อสถานะ "หุ่นลีน (สมส่วน)" หรือ "ลีน" ไม่ตรงกันทุกจุด ขณะที่ ux-flow.md หัวข้อ 4 ระบุเงื่อนไขการเปลี่ยนเป้าหมายขัดแย้งกับ AC-3 | ใช่ เนื่องจากชื่อสถานะและเงื่อนไขเวลาบางจุดไม่ตรงกัน ทำให้ Developer อาจสับสนในการเขียนโค้ด |
| C-04 | ขั้นตอนใช้งานและ Edge Cases เพียงพอ | PASS | ux-flow.md และ requirements.md หัวข้อ 5 ระบุ Edge Cases ครบถ้วน (Permission, Battery, Timezone, Multi-device, Foreground Crossing) | ไม่ใช่ เพราะครอบคลุมสถานการณ์ขอบเขตที่จำเป็นครบถ้วนแล้ว |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | FAIL | requirements.md, ux-flow.md และ game-rules.md หัวข้อ Open Questions ยังเป็นคำถามค้างและไม่มีการระบุเหตุผลว่าทำไมถึงไม่บล็อกการพัฒนา | ใช่ เพราะเอกสารไม่ได้ระบุข้อยุติหรือการจัดประเภทขอบเขตสำหรับ Open Questions ทั้งสองข้อ |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ข้อค้นพบทั้งหมดอ้างอิงจากบรรทัดและหัวข้อในเอกสารทั้งสามฉบับได้อย่างชัดเจน | ไม่ใช่ เนื่องจากทุกประเด็นมีหลักฐานอ้างอิงจากไฟล์โดยตรง |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | บทสรุปและข้อเสนอแนะสอดคล้องกับผลการตรวจสอบปัญหาในเอกสาร | ไม่ใช่ เพราะโครงสร้างและบทสรุปเป็นไปในทิศทางเดียวกัน |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | PASS | ตรวจสอบข้อค้นพบเรื่องชื่อสถานะสัตว์เลี้ยง, เงื่อนไขเวลาเปลี่ยนเป้าหมาย, และ AC-1 กับ S-1 แล้ว มีหลักฐานยืนยันชัดเจน | ไม่ใช่ เพราะได้ดำเนินการตรวจสอบซ้ำครบถ้วนตามคำสั่ง |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | ข้อเสนอแก้ไข | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|---|---|---|
| ISS-01 | requirements.md, game-rules.md, ux-flow.md | requirements.md (หัวข้อ 2, 7), game-rules.md (หัวข้อ 2), ux-flow.md (หัวข้อ 5) | ชื่อสถานะสัตว์เลี้ยงไม่ตรงกัน โดย requirements.md ข้อ 7 ใช้คำว่า "ลีน", requirements.md ข้อ 2 ใช้ "หุ่นลีน (สมส่วน)", และ game-rules.md หัวข้อ 2 ใช้ "หุ่นลีน (สมส่วน)" | Developer อาจใช้งาน string ของสถานะสัตว์เลี้ยงไม่ตรงกันในระดับ Database และ Client | ปรับปรุงชื่อสถานะสัตว์เลี้ยงใน pet_status_code และตาราง mapping ให้เป็นคำเดียวกันทุกไฟล์ (แนะนำให้ใช้ "หุ่นลีน (สมส่วน)" หรือรหัสสั้นเช่น "lean") | ใช่ ต้องระบุให้ชัดเจนเพื่อป้องกันบั๊กในการเทียบค่า String |
| ISS-02 | requirements.md | requirements.md หัวข้อ 8 (คำถามที่ยังเปิดอยู่) | มี Open Questions ค้างอยู่ 2 ข้อ (เรื่อง Push Notification และ Hardware Step Counter Fallback) โดยไม่มีการระบุว่าอยู่นอกขอบเขตหรือแนวทางปฏิบัติชั่วคราว | ทีมพัฒนาอาจไม่แน่ใจว่าจะต้องรองรับอุปกรณ์ที่ไม่มีเซนเซอร์ฮาร์ดแวร์หรือไม่ และต้องทำระบบแจ้งเตือนล่วงหน้าที่ก้าวเท่าไหร่ | เพิ่มหมายเหตุในหัวข้อ Open Questions ว่าข้อใดเป็น Out of scope สำหรับรอบนี้ หรือระบุเกณฑ์ชั่วคราวให้ชัดเจน | ใช่ Open Questions จำเป็นต้องมีข้อยุติหรือขอบเขตที่ชัดเจนก่อนส่งให้ Dev |

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|
| PRE-01 | ชื่อสถานะสัตว์เลี้ยง | ยืนยัน | พบความไม่สอดคล้องของชื่อสถานะระหว่าง "ลีน" (requirements.md หัวข้อ 7) และ "หุ่นลีน (สมส่วน)" (game-rules.md หัวข้อ 2) | อัปเดตเอกสารให้ใช้ชื่อสถานะเดียวกันทั้งหมด |
| PRE-02 | เงื่อนไขเวลาเปลี่ยนเป้าหมาย | แก้แล้ว | requirements.md (AC-3, AC-4) และ game-rules.md (หัวข้อ 1, 3) กำหนดเงื่อนไขเวลาตัดรอบ 05:00 น. และจำกัดการเปลี่ยนเป้าหมาย 1 ครั้ง/วัน สอดคล้องกัน | ไม่ต้องดำเนินการเพิ่มเติม |
| PRE-03 | AC-1 กับ S-1 | แก้แล้ว | requirements.md (AC-1) และ ux-flow.md (S-1, ขั้นตอนการใช้งานข้อ 1) สอดคล้องเรื่องการขอสิทธิ์ Activity Recognition และการแสดงผลเริ่มต้น | ไม่ต้องดำเนินการเพิ่มเติม |

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- requirements.md (หัวข้อ 8), ux-flow.md (หัวข้อ 6), game-rules.md (หัวข้อ 5): รูปแบบการแจ้งเตือน (Push Notification) เมื่อผู้ใช้ใกล้ทำเป้าหมายสำเร็จ 100% ควรส่งล่วงหน้าที่ก้าวเท่าไหร่ (เช่น เหลืออีก 500 ก้าว)? ขาดข้อกำหนดทางธุรกิจ และเอกสารไม่ได้ระบุชัดเจนว่าเป็น Out of scope บล็อกการพัฒนาในส่วน Notification แต่ไม่บล็อกแกนหลักการนับก้าว
- requirements.md (หัวข้อ 8), ux-flow.md (หัวข้อ 6), game-rules.md (หัวข้อ 5): ในกรณีที่อุปกรณ์ของผู้ใช้ไม่มีฮาร์ดแวร์เซนเซอร์นับก้าว (Hardware Step Counter) ระบบจะมี Fallback อย่างไร หรือบังคับรองรับเฉพาะเครื่องที่มีเซนเซอร์เท่านั้น? ขาดข้อกำหนดทางเทคนิคและการตัดสินใจของ Product ซึ่งอาจส่งผลต่อการเขียนโค้ดและขอบเขตอุปกรณ์ที่รองรับ (ถือเป็นประเด็นที่ต้องตัดสินใจ)

## 6. ผลวัด Agent จาก logs/ (เฉพาะที่มี log จริงและมีการร้องขอให้วัด)
ไม่มีข้อมูลใน log ที่ได้รับ

## 7. ข้อจำกัดของการรีวิว
- ตรวจสอบเอกสารการออกแบบทั้ง 3 ไฟล์ ได้แก่ requirements.md, ux-flow.md และ game-rules.md
- ไม่ได้ตรวจสอบซอร์สโค้ดจริง เนื่องจากอยู่ในขั้นตอนการตรวจเอกสารการออกแบบก่อนส่งพัฒนา

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: NEEDS_FIX
- Agent recommendation: ต้องแก้
- Blocking issues remaining: ISS-01, ISS-02
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: พบปัญหาชื่อสถานะสัตว์เลี้ยงไม่ตรงกันระหว่างไฟล์ (ISS-01) และมี Open Questions ค้างอยู่โดยยังไม่มีข้อสรุปหรือระบุขอบเขตชัดเจน (ISS-02) ซึ่งอาจทำให้เกิดความเข้าใจคลาดเคลื่อนระหว่างการพัฒนา จึงยังไม่ควรส่งให้ Dev ดำเนินการต่อจนกว่าจะแก้ไขเอกสารให้เรียบร้อย
~~~~
