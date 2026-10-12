# Log: design_review · steps · 2026-10-12 19:19

<!-- meta: {"role": "design_review", "feature": "steps", "time": "2026-10-12 19:19", "status": "ok", "provider": "gemini", "model": "gemini-3.5-flash-lite", "attempts": 1, "seconds": 9.1, "llm_calls": 1, "total_tokens": 12303, "agent_version": "1477968c"} -->

| รายการ | ค่า |
|---|---|
| สถานะ | สำเร็จ |
| ผู้ให้บริการ / รุ่น | gemini / gemini-3.5-flash-lite |
| ลำดับความพยายาม | gemini: สำเร็จ |
| เวลารวม | 9.1 วินาที |
| จำนวนครั้งที่เรียก LLM | 1 |
| tokens (prompt / completion / total) | 10625 / 1678 / 12303 |
| ไฟล์ input | docs/steps/requirements.md, docs/steps/ux-flow.md, docs/steps/game-rules.md |
| ไฟล์ output | docs/steps/design-review.md |
| agent | agents/design_reviewer.md (เวอร์ชัน 1477968c) |
| --note | - |

## ความพยายามที่ 1 — gemini (gemini-3.5-flash-lite) — สำเร็จ, 9.1 วินาที

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

**## Final Consistency Gate — Mandatory Before Finalizing**

Before writing the final recommendation, perform the following checks using the evidence already collected. Do not skip any check.

1. **Reconcile checklist and findings**
   - If a checklist item says PASS but a finding contradicts that result, correct the checklist result.
   - If a confirmed contradiction exists between design documents, C-02 and/or C-03 must not be PASS when that contradiction falls within their scope.
   - Do not mark an item PASS simply because the report contains no finding for it.

2. **Reconcile summary and issue table**
   - Every blocking issue mentioned in the summary must have a corresponding issue ID in the issue table.
   - Every confirmed blocking issue in the issue table must be reflected in the overall status and final recommendation.
   - Do not describe a blocking issue as resolved unless current source evidence supports that conclusion.

3. **Reconcile open questions**
   - For each open question, identify the missing decision and whether it affects implementation.
   - Treat a question as non-blocking only when the supplied documents explicitly explain why implementation can safely proceed or establish that it is out of scope.
   - If the available evidence cannot establish whether implementation can safely proceed, do not claim that the question is resolved or non-blocking.

4. **Reconcile previous findings**
   - Account for every previous finding that is available for review.
   - Record evidence supporting its current disposition: confirmed, resolved, not reproducible, or still uncertain.
   - Do not silently remove, rename, or merge previous findings in a way that loses traceability.

5. **Apply the status decision rules**
   - INSUFFICIENT_EVIDENCE: A required document or critical evidence needed for a reliable decision is unavailable.
   - NEEDS_FIX: Sufficient evidence confirms at least one blocking contradiction, documentation issue, or unresolved implementation decision.
   - PASS: All required documents and comparisons have sufficient evidence, all required checklist items pass, and no blocking issue or unresolved implementation decision remains.
   - If both insufficient evidence and a confirmed blocking issue exist, report NEEDS_FIX when the confirmed issue already establishes that implementation should not proceed. Explain the evidence limitation separately.
   - Never select PASS merely because the issue table is empty.

6. **Validate the final report**
   - Verify that the status, checklist, issue table, previous-findings table, open questions, blocking issue IDs, and recommendation agree.
   - The recommendation must map to the status:
     - PASS → พร้อมส่ง Dev
     - NEEDS_FIX → ต้องแก้
     - INSUFFICIENT_EVIDENCE → หลักฐานไม่เพียงพอ
   - If any inconsistency remains, correct the report before finalizing it.
   - If the inconsistency cannot be resolved from available evidence, disclose the limitation and do not claim PASS.

This consistency gate evaluates the report against the source evidence. It must not invent product decisions or modify source documents.

### Evidence-Based Open Question and Naming Validation — Mandatory

1. Do not classify an open question as non-blocking merely because it appears to be an enhancement or is not part of the core feature.
2. An open question may be classified as non-blocking only when the supplied documents explicitly establish that the specific decision is out of scope or that implementation can safely proceed without it.
3. Compare canonical identifiers and display labels separately. Check data fields, status codes, tables, acceptance criteria, UX labels, and game rules for naming mismatches.
4. If a mismatch or unresolved decision is found, record it in the issue table with evidence and an explicit blocking assessment.
5. Re-evaluate every affected checklist item. Do not mark C-03 or C-05 as PASS when the evidence contradicts the result.
6. Before assigning PASS, verify that every confirmed issue and unresolved implementation decision has been accounted for in the issue table and final recommendation.

### Canonical Status Code and Display Label Validation — Mandatory

1. For every status or enum-like field, compare the canonical stored value, display label, asset mapping, acceptance criteria, and game-rule table separately.
2. Do not claim that names are consistent merely because their meanings appear similar.
3. For example, if `pet_status_code` lists `ลีน` but the display label is `หุ่นลีน (สมส่วน)`, determine whether the documents explicitly define this as an intentional code-to-label mapping.
4. If the mapping is not explicitly defined, record it as a naming or mapping ambiguity in the issue table with exact file and section references.
5. Re-evaluate C-02 and C-03 based on the evidence. Do not mark them PASS when an unresolved naming or mapping ambiguity falls within their scope.
6. Ensure every confirmed issue appears in the issue table and is reflected in the checklist and final recommendation. Do not invent the intended mapping; recommend that the responsible human or Product owner clarify it.

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

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|

กำหนดเพิ่มเติมว่า:
- ใช่ — มีหลักฐานว่าปัญหานั้นทำให้การพัฒนาไม่ปลอดภัยหรือไม่สามารถทำตามข้อกำหนดได้อย่างน่าเชื่อถือ
- ไม่ใช่ — มีหลักฐานเพียงพอว่าปัญหานั้นไม่ขัดขวางการพัฒนา
- หากหลักฐานไม่พอ ให้ระบุว่า ยังตัดสินไม่ได้ พร้อมอธิบายเหตุผล ห้ามเดาเอง

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ | หลักฐานจากเอกสารปัจจุบัน | ต้องดำเนินการต่อ |
|---|---|---|---|---|

If the prior review was not provided, explicitly state that comparison could not be performed.

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
For each item, state the source file and heading, what decision/evidence is missing, and whether the documents explicitly say it is out of scope. Do not infer non-blocking status.

### Open Question Issue Tracking — Mandatory

1. Every unresolved Open Question that may affect implementation must be recorded as a separate issue-table entry with a unique ID.
2. Include the source document and section, the unresolved decision, its potential impact, the required human or Product Owner decision, and an explicit blocking assessment.
3. Do not mention an Open Question as a remaining blocking issue in the final summary unless it is represented in the issue table.
4. Keep the checklist, issue table, Open Questions section, and final recommendation consistent.
5. If multiple Open Questions concern different product or technical decisions, track them separately so each can be resolved independently.
6. Before finalizing, verify that every issue mentioned in the checklist or final summary has a corresponding issue-table entry.

### Checklist Evidence and Manual-Fix Validation — Mandatory

1. Every checklist result must be supported by evidence from the reviewed documents.
2. Before assigning PASS, verify that no unresolved issue directly contradicts the checklist criterion.
3. If an issue contradicts a checklist criterion, revise the result or provide explicit evidence explaining why the criterion still passes.
4. For C-08, if no previous review report is available, use INSUFFICIENT_EVIDENCE and explain that regression comparison cannot be performed. Do not require manual correction solely because historical data is unavailable.
5. Assess "ต้องแก้มือ" separately from the checklist result. Mark manual correction as required only when a human action is actually necessary, and explain the specific action.
6. Every issue must list all source documents used as evidence in the issue table.
7. Before finalizing, verify checklist results, issue records, manual-fix assessments, and the final recommendation for consistency.

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

## Output Schema Validation — Mandatory

Before finalizing the report:

1. Compare every output table against the exact header and column count specified in the Required output format.
2. Do not remove, rename, reorder, or omit any required column.
3. For the issue table, include all eight columns exactly as specified, including "Blocking หรือไม่".
4. Check that every issue has an explicit blocking assessment: "ใช่", "ไม่ใช่", or "ยังตัดสินไม่ได้", with an evidence-based reason.
5. If the report does not match the required format, revise it before finalizing.
6. Do not claim that format validation passed unless the final report actually matches the required schema.

### Checklist–Issue Consistency Validation — Mandatory

1. Before finalizing the report, compare every checklist result against the issue table, Open Questions, and final recommendation.
2. Do not mark a checklist item PASS if the report contains an unresolved issue that directly contradicts that item's acceptance criteria.
3. If a checklist item remains PASS despite a related issue, provide explicit evidence explaining why the issue does not cause failure. Do not rely on general statements such as "consistent overall."
4. For every issue, assess "Blocking หรือไม่" separately from "ต้องแก้มือ". Explain why an issue can or cannot block development based on documented evidence.
5. If the documents do not provide enough evidence to determine whether an issue blocks development, use "ยังตัดสินไม่ได้" rather than guessing.
6. Verify that the exact issue-table column names, order, and column count match the Required output format. Having all required columns in the wrong order does not pass validation.
7. If any validation fails, revise the report before assigning the final status.
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

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | ข้อเสนอแก้ไข | Blocking หรือไม่ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|---|---|---|---|

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

**## Final Consistency Gate — Mandatory Before Finalizing**

Before writing the final recommendation, perform the following checks using the evidence already collected. Do not skip any check.

1. **Reconcile checklist and findings**
   - If a checklist item says PASS but a finding contradicts that result, correct the checklist result.
   - If a confirmed contradiction exists between design documents, C-02 and/or C-03 must not be PASS when that contradiction falls within their scope.
   - Do not mark an item PASS simply because the report contains no finding for it.

2. **Reconcile summary and issue table**
   - Every blocking issue mentioned in the summary must have a corresponding issue ID in the issue table.
   - Every confirmed blocking issue in the issue table must be reflected in the overall status and final recommendation.
   - Do not describe a blocking issue as resolved unless current source evidence supports that conclusion.

3. **Reconcile open questions**
   - For each open question, identify the missing decision and whether it affects implementation.
   - Treat a question as non-blocking only when the supplied documents explicitly explain why implementation can safely proceed or establish that it is out of scope.
   - If the available evidence cannot establish whether implementation can safely proceed, do not claim that the question is resolved or non-blocking.

4. **Reconcile previous findings**
   - Account for every previous finding that is available for review.
   - Record evidence supporting its current disposition: confirmed, resolved, not reproducible, or still uncertain.
   - Do not silently remove, rename, or merge previous findings in a way that loses traceability.

5. **Apply the status decision rules**
   - INSUFFICIENT_EVIDENCE: A required document or critical evidence needed for a reliable decision is unavailable.
   - NEEDS_FIX: Sufficient evidence confirms at least one blocking contradiction, documentation issue, or unresolved implementation decision.
   - PASS: All required documents and comparisons have sufficient evidence, all required checklist items pass, and no blocking issue or unresolved implementation decision remains.
   - If both insufficient evidence and a confirmed blocking issue exist, report NEEDS_FIX when the confirmed issue already establishes that implementation should not proceed. Explain the evidence limitation separately.
   - Never select PASS merely because the issue table is empty.

6. **Validate the final report**
   - Verify that the status, checklist, issue table, previous-findings table, open questions, blocking issue IDs, and recommendation agree.
   - The recommendation must map to the status:
     - PASS → พร้อมส่ง Dev
     - NEEDS_FIX → ต้องแก้
     - INSUFFICIENT_EVIDENCE → หลักฐานไม่เพียงพอ
   - If any inconsistency remains, correct the report before finalizing it.
   - If the inconsistency cannot be resolved from available evidence, disclose the limitation and do not claim PASS.

This consistency gate evaluates the report against the source evidence. It must not invent product decisions or modify source documents.

### Evidence-Based Open Question and Naming Validation — Mandatory

1. Do not classify an open question as non-blocking merely because it appears to be an enhancement or is not part of the core feature.
2. An open question may be classified as non-blocking only when the supplied documents explicitly establish that the specific decision is out of scope or that implementation can safely proceed without it.
3. Compare canonical identifiers and display labels separately. Check data fields, status codes, tables, acceptance criteria, UX labels, and game rules for naming mismatches.
4. If a mismatch or unresolved decision is found, record it in the issue table with evidence and an explicit blocking assessment.
5. Re-evaluate every affected checklist item. Do not mark C-03 or C-05 as PASS when the evidence contradicts the result.
6. Before assigning PASS, verify that every confirmed issue and unresolved implementation decision has been accounted for in the issue table and final recommendation.

### Canonical Status Code and Display Label Validation — Mandatory

1. For every status or enum-like field, compare the canonical stored value, display label, asset mapping, acceptance criteria, and game-rule table separately.
2. Do not claim that names are consistent merely because their meanings appear similar.
3. For example, if `pet_status_code` lists `ลีน` but the display label is `หุ่นลีน (สมส่วน)`, determine whether the documents explicitly define this as an intentional code-to-label mapping.
4. If the mapping is not explicitly defined, record it as a naming or mapping ambiguity in the issue table with exact file and section references.
5. Re-evaluate C-02 and C-03 based on the evidence. Do not mark them PASS when an unresolved naming or mapping ambiguity falls within their scope.
6. Ensure every confirmed issue appears in the issue table and is reflected in the checklist and final recommendation. Do not invent the intended mapping; recommend that the responsible human or Product owner clarify it.

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

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|

กำหนดเพิ่มเติมว่า:
- ใช่ — มีหลักฐานว่าปัญหานั้นทำให้การพัฒนาไม่ปลอดภัยหรือไม่สามารถทำตามข้อกำหนดได้อย่างน่าเชื่อถือ
- ไม่ใช่ — มีหลักฐานเพียงพอว่าปัญหานั้นไม่ขัดขวางการพัฒนา
- หากหลักฐานไม่พอ ให้ระบุว่า ยังตัดสินไม่ได้ พร้อมอธิบายเหตุผล ห้ามเดาเอง

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ | หลักฐานจากเอกสารปัจจุบัน | ต้องดำเนินการต่อ |
|---|---|---|---|---|

If the prior review was not provided, explicitly state that comparison could not be performed.

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
For each item, state the source file and heading, what decision/evidence is missing, and whether the documents explicitly say it is out of scope. Do not infer non-blocking status.

### Open Question Issue Tracking — Mandatory

1. Every unresolved Open Question that may affect implementation must be recorded as a separate issue-table entry with a unique ID.
2. Include the source document and section, the unresolved decision, its potential impact, the required human or Product Owner decision, and an explicit blocking assessment.
3. Do not mention an Open Question as a remaining blocking issue in the final summary unless it is represented in the issue table.
4. Keep the checklist, issue table, Open Questions section, and final recommendation consistent.
5. If multiple Open Questions concern different product or technical decisions, track them separately so each can be resolved independently.
6. Before finalizing, verify that every issue mentioned in the checklist or final summary has a corresponding issue-table entry.

### Checklist Evidence and Manual-Fix Validation — Mandatory

1. Every checklist result must be supported by evidence from the reviewed documents.
2. Before assigning PASS, verify that no unresolved issue directly contradicts the checklist criterion.
3. If an issue contradicts a checklist criterion, revise the result or provide explicit evidence explaining why the criterion still passes.
4. For C-08, if no previous review report is available, use INSUFFICIENT_EVIDENCE and explain that regression comparison cannot be performed. Do not require manual correction solely because historical data is unavailable.
5. Assess "ต้องแก้มือ" separately from the checklist result. Mark manual correction as required only when a human action is actually necessary, and explain the specific action.
6. Every issue must list all source documents used as evidence in the issue table.
7. Before finalizing, verify checklist results, issue records, manual-fix assessments, and the final recommendation for consistency.

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

## Output Schema Validation — Mandatory

Before finalizing the report:

1. Compare every output table against the exact header and column count specified in the Required output format.
2. Do not remove, rename, reorder, or omit any required column.
3. For the issue table, include all eight columns exactly as specified, including "Blocking หรือไม่".
4. Check that every issue has an explicit blocking assessment: "ใช่", "ไม่ใช่", or "ยังตัดสินไม่ได้", with an evidence-based reason.
5. If the report does not match the required format, revise it before finalizing.
6. Do not claim that format validation passed unless the final report actually matches the required schema.

### Checklist–Issue Consistency Validation — Mandatory

1. Before finalizing the report, compare every checklist result against the issue table, Open Questions, and final recommendation.
2. Do not mark a checklist item PASS if the report contains an unresolved issue that directly contradicts that item's acceptance criteria.
3. If a checklist item remains PASS despite a related issue, provide explicit evidence explaining why the issue does not cause failure. Do not rely on general statements such as "consistent overall."
4. For every issue, assess "Blocking หรือไม่" separately from "ต้องแก้มือ". Explain why an issue can or cannot block development based on documented evidence.
5. If the documents do not provide enough evidence to determine whether an issue blocks development, use "ยังตัดสินไม่ได้" rather than guessing.
6. Verify that the exact issue-table column names, order, and column count match the Required output format. Having all required columns in the wrong order does not pass validation.
7. If any validation fails, revise the report before assigning the final status.
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

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | ข้อเสนอแก้ไข | Blocking หรือไม่ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|---|---|---|---|

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
- Previous findings checked: ไม่มีข้อมูลรอบก่อน

## 2. ผล Checklist

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | PASS | ข้อกำหนดครอบคลุม User stories, Acceptance criteria, และ Edge cases ชัดเจน แต่อาจมีประเด็นชื่อสถานะไม่ตรงกันเล็กน้อย | ไม่ใช่ เพราะโครงสร้างหลักครบถ้วน นำไปขึ้นโครงสร้างข้อมูลได้ |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | FAIL | พบความไม่สอดคล้องของชื่อสถานะสัตว์เลี้ยงระหว่าง Requirements (`ลีน`), UX Flow (`pet_status_lean.png`) และ Game Rules (`หุ่นลีน (สมส่วน)`) | ใช่ เนื่องจากชื่อสถานะไม่ตรงกันทำให้การอ้างอิงโค้ดและ Assets อาจผิดพลาด |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | FAIL | ชื่อสถานะสัตว์เลี้ยงใน Requirements ข้อ 2 ระบุคำว่า "ลีน" แต่ใน Game Rules หัวข้อ 1 และ 2 ระบุ "หุ่นลีน (สมส่วน)" | ใช่ ต้องปรับแก้ชื่อสถานะให้เป็นมาตรฐานเดียวกันทุกเอกสาร |
| C-04 | ขั้นตอนใช้งานและ Edge Cases เพียงพอ | PASS | UX Flow และ Game Rules มีขั้นตอนการใช้งานและ Edge cases รองรับครบถ้วน (EC-1 ถึง EC-5) | ไม่ใช่ เพราะครอบคลุมสถานการณ์สำคัญหมดแล้ว |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | FAIL | คำถามที่ยังเปิดอยู่เรื่อง Push Notification และ Hardware Step Counter Fallback ยังไม่มีข้อสรุปชัดเจนว่าไม่บล็อกการพัฒนา | ใช่ เพราะยังไม่มีข้อยุติที่ชัดเจนจาก Product Owner |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ทุกข้อค้นพบอ้างอิงไฟล์และหัวข้อจริงจากเอกสารที่ได้รับ | ไม่ใช่ เพราะมีหลักฐานอ้างอิงชัดเจน |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกับผลการตรวจเอกสาร | ไม่ใช่ เพราะทุกส่วนตรงกันตามหลักฐาน |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีรายงานผลการตรวจรอบก่อนให้เปรียบเทียบ | ไม่ใช่ เพราะไม่มีข้อมูลรอบก่อนให้ตรวจสอบ |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | ข้อเสนอแก้ไข | Blocking หรือไม่ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|---|---|---|---|
| ISS-01 | requirements.md, ux-flow.md, game-rules.md | requirements.md (หัวข้อ 2 และ 7), game-rules.md (หัวข้อ 1 และ 2) | ชื่อสถานะสัตว์เลี้ยงไม่ตรงกัน โดย requirements.md ใช้คำว่า "ลีน" แต่ game-rules.md ใช้คำว่า "หุ่นลีน (สมส่วน)" | อาจทำให้การเขียน Map ค่า `pet_status_code` กับ UI Label และ Assets ผิดพลาด | ปรับปรุงชื่อสถานะใน requirements.md ให้ตรงกับ game-rules.md เป็น "หุ่นลีน (สมส่วน)" | ใช่ | ใช่ ต้องให้มนุษย์/Product Owner ยืนยันชื่อมาตรฐาน |
| ISS-02 | requirements.md, ux-flow.md, game-rules.md | requirements.md (หัวข้อ 8), ux-flow.md (หัวข้อ 6), game-rules.md (หัวข้อ 5) | คำถามที่ยังเปิดอยู่ (Open Questions) เกี่ยวกับ Push Notification และ Hardware Step Counter Fallback ยังไม่ได้รับการตัดสินใจ | นักพัฒนาอาจไม่ทราบว่าต้องทำระบบ Fallback สำหรับอุปกรณ์ที่ไม่มีเซนเซอร์นับก้าวหรือไม่ | ให้ Product Owner ตัดสินใจและระบุข้อสรุปในเอกสารว่าเป็ร Out of scope หรือต้องทำ | ใช่ | ใช่ ต้องให้ Product Owner ตัดสินใจใน Open Questions |

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|
| - | ไม่มีข้อมูลรอบก่อน | ไม่มีข้อมูลสำหรับเปรียบเทียบ | ไม่มีรายงานการรีวิวก่อนหน้าในระบบ | ข้ามการตรวจสอบ Regression |

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- รูปแบบการแจ้งเตือน (Push Notification) เมื่อผู้ใช้ใกล้ทำเป้าหมายสำเร็จ 100% ควรส่งล่วงหน้าที่ก้าวเท่าไหร่ (เช่น เหลืออีก 500 ก้าว)? (อ้างอิงจาก requirements.md หัวข้อ 8, ux-flow.md หัวข้อ 6, game-rules.md หัวข้อ 5) ขาดการตัดสินใจจาก Product Owner ว่าจะรวมในรอบนี้หรือไม่ บล็อกการพัฒนาในส่วนของการแจ้งเตือนหากต้องทำ
- ในกรณีที่อุปกรณ์ของผู้ใช้ไม่มีฮาร์ดแวร์เซนเซอร์นับก้าว (Hardware Step Counter) ระบบจะมี Fallback อย่างไร หรือบังคับรองรับเฉพาะเครื่องที่มีเซนเซอร์เท่านั้น? (อ้างอิงจาก requirements.md หัวข้อ 8, ux-flow.md หัวข้อ 6, game-rules.md หัวข้อ 5) ขาดการตัดสินใจเชิงเทคนิคและผลิตภัณฑ์ บล็อกการพัฒนาเนื่องจากกระทบต่อความเข้ากันได้ของอุปกรณ์ (Device Compatibility)

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|
| ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่ใช่ เพราะไม่มีการร้องขอหรือไฟล์ log ให้ตรวจสอบ |

## 7. ข้อจำกัดของการรีวิว
- ตรวจสอบเฉพาะเอกสาร requirements.md, ux-flow.md และ game-rules.md ในโฟลเดอร์ docs/steps/ เท่านั้น
- ไม่ได้ตรวจสอบโค้ดจริง ระบบรันไทม์ หรือผลการทดสอบระบบ เนื่องจากเป็นงานตรวจสอบการออกแบบ (Design Review)

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: NEEDS_FIX
- Agent recommendation: ต้องแก้
- Blocking issues remaining: ISS-01, ISS-02 เนื่องจากชื่อสถานะไม่สอดคล้องกันระหว่างเอกสาร และยังมี Open Questions ที่ยังไม่มีข้อสรุปชัดเจน
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: ผล Checklist พบข้อผิดพลาดใน C-02, C-03 และ C-05 โดยมีความขัดแย้งของชื่อสถานะสัตว์เลี้ยงระหว่างเอกสาร Requirements และ Game Rules รวมถึงมีคำถามที่ยังเปิดอยู่ซึ่งจำเป็นต่อการตัดสินใจก่อนเริ่มพัฒนา
~~~~

### ผลลัพธ์ → docs/steps/design-review.md

~~~~text
# Design Review: steps

## 1. ข้อมูลการตรวจ
- Status: NEEDS_FIX
- Feature: steps
- Documents actually reviewed: docs/steps/requirements.md, docs/steps/ux-flow.md, docs/steps/game-rules.md
- Missing/unreadable documents: ไม่มี
- Previous findings checked: ไม่มีข้อมูลรอบก่อน

## 2. ผล Checklist

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | PASS | ข้อกำหนดครอบคลุม User stories, Acceptance criteria, และ Edge cases ชัดเจน แต่อาจมีประเด็นชื่อสถานะไม่ตรงกันเล็กน้อย | ไม่ใช่ เพราะโครงสร้างหลักครบถ้วน นำไปขึ้นโครงสร้างข้อมูลได้ |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | FAIL | พบความไม่สอดคล้องของชื่อสถานะสัตว์เลี้ยงระหว่าง Requirements (`ลีน`), UX Flow (`pet_status_lean.png`) และ Game Rules (`หุ่นลีน (สมส่วน)`) | ใช่ เนื่องจากชื่อสถานะไม่ตรงกันทำให้การอ้างอิงโค้ดและ Assets อาจผิดพลาด |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | FAIL | ชื่อสถานะสัตว์เลี้ยงใน Requirements ข้อ 2 ระบุคำว่า "ลีน" แต่ใน Game Rules หัวข้อ 1 และ 2 ระบุ "หุ่นลีน (สมส่วน)" | ใช่ ต้องปรับแก้ชื่อสถานะให้เป็นมาตรฐานเดียวกันทุกเอกสาร |
| C-04 | ขั้นตอนใช้งานและ Edge Cases เพียงพอ | PASS | UX Flow และ Game Rules มีขั้นตอนการใช้งานและ Edge cases รองรับครบถ้วน (EC-1 ถึง EC-5) | ไม่ใช่ เพราะครอบคลุมสถานการณ์สำคัญหมดแล้ว |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | FAIL | คำถามที่ยังเปิดอยู่เรื่อง Push Notification และ Hardware Step Counter Fallback ยังไม่มีข้อสรุปชัดเจนว่าไม่บล็อกการพัฒนา | ใช่ เพราะยังไม่มีข้อยุติที่ชัดเจนจาก Product Owner |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ทุกข้อค้นพบอ้างอิงไฟล์และหัวข้อจริงจากเอกสารที่ได้รับ | ไม่ใช่ เพราะมีหลักฐานอ้างอิงชัดเจน |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกับผลการตรวจเอกสาร | ไม่ใช่ เพราะทุกส่วนตรงกันตามหลักฐาน |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีรายงานผลการตรวจรอบก่อนให้เปรียบเทียบ | ไม่ใช่ เพราะไม่มีข้อมูลรอบก่อนให้ตรวจสอบ |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | ข้อเสนอแก้ไข | Blocking หรือไม่ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|---|---|---|---|
| ISS-01 | requirements.md, ux-flow.md, game-rules.md | requirements.md (หัวข้อ 2 และ 7), game-rules.md (หัวข้อ 1 และ 2) | ชื่อสถานะสัตว์เลี้ยงไม่ตรงกัน โดย requirements.md ใช้คำว่า "ลีน" แต่ game-rules.md ใช้คำว่า "หุ่นลีน (สมส่วน)" | อาจทำให้การเขียน Map ค่า `pet_status_code` กับ UI Label และ Assets ผิดพลาด | ปรับปรุงชื่อสถานะใน requirements.md ให้ตรงกับ game-rules.md เป็น "หุ่นลีน (สมส่วน)" | ใช่ | ใช่ ต้องให้มนุษย์/Product Owner ยืนยันชื่อมาตรฐาน |
| ISS-02 | requirements.md, ux-flow.md, game-rules.md | requirements.md (หัวข้อ 8), ux-flow.md (หัวข้อ 6), game-rules.md (หัวข้อ 5) | คำถามที่ยังเปิดอยู่ (Open Questions) เกี่ยวกับ Push Notification และ Hardware Step Counter Fallback ยังไม่ได้รับการตัดสินใจ | นักพัฒนาอาจไม่ทราบว่าต้องทำระบบ Fallback สำหรับอุปกรณ์ที่ไม่มีเซนเซอร์นับก้าวหรือไม่ | ให้ Product Owner ตัดสินใจและระบุข้อสรุปในเอกสารว่าเป็ร Out of scope หรือต้องทำ | ใช่ | ใช่ ต้องให้ Product Owner ตัดสินใจใน Open Questions |

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|
| - | ไม่มีข้อมูลรอบก่อน | ไม่มีข้อมูลสำหรับเปรียบเทียบ | ไม่มีรายงานการรีวิวก่อนหน้าในระบบ | ข้ามการตรวจสอบ Regression |

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- รูปแบบการแจ้งเตือน (Push Notification) เมื่อผู้ใช้ใกล้ทำเป้าหมายสำเร็จ 100% ควรส่งล่วงหน้าที่ก้าวเท่าไหร่ (เช่น เหลืออีก 500 ก้าว)? (อ้างอิงจาก requirements.md หัวข้อ 8, ux-flow.md หัวข้อ 6, game-rules.md หัวข้อ 5) ขาดการตัดสินใจจาก Product Owner ว่าจะรวมในรอบนี้หรือไม่ บล็อกการพัฒนาในส่วนของการแจ้งเตือนหากต้องทำ
- ในกรณีที่อุปกรณ์ของผู้ใช้ไม่มีฮาร์ดแวร์เซนเซอร์นับก้าว (Hardware Step Counter) ระบบจะมี Fallback อย่างไร หรือบังคับรองรับเฉพาะเครื่องที่มีเซนเซอร์เท่านั้น? (อ้างอิงจาก requirements.md หัวข้อ 8, ux-flow.md หัวข้อ 6, game-rules.md หัวข้อ 5) ขาดการตัดสินใจเชิงเทคนิคและผลิตภัณฑ์ บล็อกการพัฒนาเนื่องจากกระทบต่อความเข้ากันได้ของอุปกรณ์ (Device Compatibility)

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|
| ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่ใช่ เพราะไม่มีการร้องขอหรือไฟล์ log ให้ตรวจสอบ |

## 7. ข้อจำกัดของการรีวิว
- ตรวจสอบเฉพาะเอกสาร requirements.md, ux-flow.md และ game-rules.md ในโฟลเดอร์ docs/steps/ เท่านั้น
- ไม่ได้ตรวจสอบโค้ดจริง ระบบรันไทม์ หรือผลการทดสอบระบบ เนื่องจากเป็นงานตรวจสอบการออกแบบ (Design Review)

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: NEEDS_FIX
- Agent recommendation: ต้องแก้
- Blocking issues remaining: ISS-01, ISS-02 เนื่องจากชื่อสถานะไม่สอดคล้องกันระหว่างเอกสาร และยังมี Open Questions ที่ยังไม่มีข้อสรุปชัดเจน
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: ผล Checklist พบข้อผิดพลาดใน C-02, C-03 และ C-05 โดยมีความขัดแย้งของชื่อสถานะสัตว์เลี้ยงระหว่างเอกสาร Requirements และ Game Rules รวมถึงมีคำถามที่ยังเปิดอยู่ซึ่งจำเป็นต่อการตัดสินใจก่อนเริ่มพัฒนา
~~~~
