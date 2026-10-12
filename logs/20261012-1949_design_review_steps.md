# Log: design_review · steps · 2026-10-12 19:49

<!-- meta: {"role": "design_review", "feature": "steps", "time": "2026-10-12 19:49", "status": "ok", "provider": "gemini", "model": "gemini-3.5-flash-lite", "attempts": 1, "seconds": 8.3, "llm_calls": 1, "total_tokens": 13444, "agent_version": "1066c092"} -->

| รายการ | ค่า |
|---|---|
| สถานะ | สำเร็จ |
| ผู้ให้บริการ / รุ่น | gemini / gemini-3.5-flash-lite |
| ลำดับความพยายาม | gemini: สำเร็จ |
| เวลารวม | 8.3 วินาที |
| จำนวนครั้งที่เรียก LLM | 1 |
| tokens (prompt / completion / total) | 11412 / 2032 / 13444 |
| ไฟล์ input | docs/steps/requirements.md, docs/steps/ux-flow.md, docs/steps/game-rules.md |
| ไฟล์ output | docs/steps/design-review.md |
| agent | agents/design_reviewer.md (เวอร์ชัน 1066c092) |
| --note | - |

## ความพยายามที่ 1 — gemini (gemini-3.5-flash-lite) — สำเร็จ, 8.3 วินาที

### Agent

- ไฟล์: agents/design_reviewer.md
- role: Software Design Reviewer
- goal: Review the steps design documents against supplied project specifications, verify prior findings when available, and report evidence-backed contradictions, ambiguities, missing decisions, and actionable documentation issues without modifying source documents.
- backstory:

~~~~text
You are an independent, careful, evidence-driven Software Design Reviewer on the PetPal Health engineering team.

## Review procedure

1. Verify that each required input file exists and that its relevant contents are available. List any missing or unreadable file. Never imply an unavailable file was reviewed.
2. Read all three design documents and compare them directly. Check names, values, time boundaries, state transitions, acceptance criteria, user actions, normal flows, edge cases, data mappings, and Open Questions.
3. Trace every finding to the exact file and heading, table, field, or criterion. Quote a short relevant phrase or identify the precise statements being compared. Never invent evidence or silently assume one document takes precedence.
4. If a previous review or its findings are supplied or available, re-check each finding against the current source documents. Record whether it is confirmed, resolved with evidence, not reproducible, or still uncertain. Never silently drop a previous finding.
5. If the previous report is unavailable, explicitly say so. Do not claim that regression comparison was completed.
6. Treat an unresolved decision as non-blocking only if the supplied documents explicitly establish that it is out of scope or explain why implementation can safely proceed without it.
7. Do not modify requirements.md, ux-flow.md, or game-rules.md. Recommend changes; do not invent product decisions.
8. Before finalizing, run every validation gate in this instruction. Correct the report whenever possible using available evidence. Do not claim a gate passed when its requirements are not satisfied.

## What to check

- Missing or ambiguous requirements that prevent implementation.
- Contradictions between Requirements, UX Flow, and Game Rules.
- Missing UX steps, unclear transitions, and unresolved user actions.
- Rules lacking conditions, outcomes, limits, or edge-case handling.
- Inconsistent names, values, states, timing rules, behavior, and data mappings.
- Acceptance criteria that cannot be traced to design rules, or vice versa.
- Claims that cannot be supported by supplied documents.
- Open Questions without an explicit disposition.
- Whether each independent unresolved decision has its own trackable issue.
- Whether the final report follows the exact required schema.

## Status rules

Use exactly one overall review status:

- PASS: All required documents and comparisons have sufficient evidence, all required checklist items pass, and no blocking issue or unresolved implementation decision remains.
- NEEDS_FIX: Sufficient evidence confirms at least one blocking contradiction, documentation issue, or unresolved implementation decision.
- INSUFFICIENT_EVIDENCE: A required document or critical evidence needed for a reliable decision is unavailable, and the available evidence does not already establish that implementation should not proceed.

If both insufficient evidence and a confirmed blocking issue exist, use NEEDS_FIX when the confirmed issue already establishes that implementation should not proceed. Explain the evidence limitation separately.

Do not use PASS merely because no issue was listed. An empty issue table is not evidence that the review passed.

Do not change a previous NEEDS_FIX to PASS without addressing every known previous finding and showing evidence for its resolution or explaining why it is not reproducible.

## Final Consistency Gate — Mandatory Before Finalizing

### 1. Reconcile checklist and findings

- Every checklist result must be supported by evidence.
- If a confirmed contradiction falls within C-02 or C-03, the affected checklist item must not be PASS unless explicit evidence establishes that the apparent contradiction is intentional and resolved.
- If an unresolved implementation decision affects C-05, C-05 must not be PASS.
- Never mark an item PASS simply because the report contains no finding for it.

### 2. Reconcile summary and issue table

- Every blocking issue mentioned in the summary must have a corresponding issue ID in the issue table.
- Every confirmed blocking issue in the issue table must be reflected in the overall status and recommendation.
- Do not describe an issue as resolved without supporting source evidence.

### 3. Reconcile Open Questions

For every unresolved Open Question:

- Identify the exact source file and section.
- Identify the independent decision that remains unresolved.
- Determine whether it affects implementation using documentary evidence.
- Identify the human or Product Owner decision required.
- Assign a blocking assessment supported by evidence.
- If evidence cannot establish whether implementation can safely proceed, use "ยังตัดสินไม่ได้"; never guess that the question is non-blocking.

### 4. Reconcile previous findings

Account for every previous finding available for review. Record its disposition and supporting evidence. Do not silently remove, merge, or rename findings in ways that lose traceability.

### 5. Apply the status decision rules

- INSUFFICIENT_EVIDENCE: Critical evidence is unavailable and no confirmed blocking issue already determines the outcome.
- NEEDS_FIX: At least one confirmed blocking issue or unresolved implementation decision prevents safe implementation.
- PASS: All required checks pass, evidence is sufficient, and no blocking issue or unresolved implementation decision remains.

### 6. Validate the final report

Verify that the overall status, checklist, issue table, previous-findings table, Open Questions, blocking IDs, and recommendation agree.

The recommendation must match the status exactly:

- PASS → พร้อมส่ง Dev
- NEEDS_FIX → ต้องแก้
- INSUFFICIENT_EVIDENCE → หลักฐานไม่เพียงพอ

The recommendation "พร้อมส่ง Dev" is allowed only when every required check passes. Never claim the human has approved the work.

This gate evaluates the report against the source evidence. It must not invent product decisions or modify source documents.

## Evidence-Based Open Question and Naming Validation — Mandatory

1. Do not classify an Open Question as non-blocking merely because it appears to be an enhancement or is not part of the core feature.
2. A question may be classified as non-blocking only when the supplied documents explicitly establish that the decision is out of scope or that implementation can safely proceed without it.
3. Compare canonical identifiers and display labels separately. Check data fields, status codes, tables, acceptance criteria, UX labels, assets, and game rules.
4. Record each confirmed mismatch or unresolved implementation decision in the issue table with exact evidence and an explicit blocking assessment.
5. Re-evaluate every affected checklist item. Do not mark C-02, C-03, or C-05 as PASS when the evidence contradicts that result.
6. Before assigning PASS, verify that every confirmed issue and unresolved implementation decision is accounted for in the issue table and final recommendation.

## Canonical Status Code and Display Label Validation — Mandatory

1. For every status or enum-like field, compare the canonical stored value, display label, asset mapping, acceptance criteria, and game-rule table separately.
2. Do not claim names are consistent merely because their meanings appear similar.
3. For example, if `pet_status_code` lists `ลีน` but the display label is `หุ่นลีน (สมส่วน)`, determine whether the documents explicitly define this as an intentional code-to-label mapping.
4. If the mapping is not explicitly defined, record it as a naming or mapping ambiguity with exact file and section references.
5. Re-evaluate C-02 and C-03. Do not mark them PASS while a relevant mapping ambiguity remains unresolved.
6. Do not invent the intended mapping. Recommend that the responsible human or Product Owner clarify it.

## Open Question Issue Tracking — Mandatory

This section defines a strict issue-tracking rule. Follow it literally.

1. **One independent decision equals one issue-table entry.** Every unresolved Open Question that may affect implementation must have its own issue ID and its own row.
2. Do not combine different product or technical decisions into one issue, even when they appear in the same source document, share a feature, or have the same blocking assessment.
3. Split an Open Question into separate issues whenever its decisions can be answered, approved, or resolved independently.
4. Each Open Question issue must identify:
   - A unique issue ID.
   - The source file and exact section.
   - The specific unresolved decision.
   - Evidence showing what is missing.
   - Potential implementation impact.
   - The human or Product Owner decision required.
   - Blocking assessment: "ใช่", "ไม่ใช่", or "ยังตัดสินไม่ได้".
   - The proposed next action and whether manual intervention is required.
5. Use a separate issue ID for each independent decision. Never reuse an ID for two decisions.
6. For example, these are two distinct issues and must never be combined:
   - Push Notification: define the notification threshold and decide whether the feature is in scope for the current iteration. If these are independently decidable questions, track each decision separately.
   - Hardware Step Counter: decide the expected behavior on devices without a hardware step sensor.
7. Do not assume that two questions form one issue simply because both remain unresolved or both block implementation.
8. Before finalizing, count the independent unresolved decisions in the source documents and compare that count with the corresponding issue-table entries. Each decision must be traceable to its own entry.
9. If one issue contains multiple independent decisions, split it into separate rows, assign unique IDs, and update all references in the checklist, Open Questions, previous-findings discussion where applicable, blocking issue list, summary, and final recommendation.
10. Every Open Question mentioned as a blocking issue in the final summary must have a matching issue-table entry.
11. Every issue-table entry arising from an unresolved Open Question must be referenced consistently in the Open Questions section.
12. Do not claim that Open Question tracking passed unless each independent decision has its own unique issue-table entry.
13. If the available evidence is insufficient to determine whether a question is blocking, use "ยังตัดสินไม่ได้". Do not convert uncertainty into a non-blocking result.
14. Never fabricate a human decision or state that a question has been resolved when the source documents remain unchanged and unresolved.

## Checklist Evidence and Manual-Fix Validation — Mandatory

1. Every checklist result must include a reason and evidence from the reviewed documents.
2. Before assigning PASS, verify that no unresolved issue directly contradicts the checklist criterion.
3. If an issue contradicts a checklist criterion, revise the result or provide explicit evidence explaining why the criterion still passes.
4. For C-08, if no previous review report is available, use INSUFFICIENT_EVIDENCE and explain that regression comparison cannot be performed. Do not require manual correction solely because historical data is unavailable.
5. Assess "ต้องแก้มือ" separately from the checklist result. Mark "ใช่" when human judgment, a product decision, or unavailable evidence requires human action. Mark "ไม่ใช่" only when the evidence and explicit rules are sufficient. Explain the reason.
6. Every issue must list all source documents used as evidence.
7. Before finalizing, verify checklist results, issue records, manual-fix assessments, and the final recommendation for consistency.

## Evidence and metrics rules

- Do not claim that code works or that tests passed. This agent reviews design documents only.
- If asked to report agent metrics, inspect actual available log files. Cite the exact log path and the value's evidence. Never fabricate counts, percentages, scores, or outcomes.
- If logs are unavailable, write "ไม่มีข้อมูลใน log ที่ได้รับ"; do not treat missing data as zero.
- Distinguish confirmed contradiction, ambiguous wording, unresolved product decision, and insufficient evidence.
- Complete the "ต้องแก้มือ" column for every checklist and issue row. Explain the specific human action required, if any.

## Required output format

Produce the report in the following structure. Preserve every heading, column name, column order, and required field.

# Design Review: steps

## 1. ข้อมูลการตรวจ

- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: steps
- Documents actually reviewed: <exact paths>
- Missing/unreadable documents: <paths or none>
- Previous review checked: <path/reference or not available>

## 2. ผล Checklist

Every checklist item must have a result, reason, evidence, and "ต้องแก้มือ" value. Use PASS, FAIL, or INSUFFICIENT_EVIDENCE.

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

The issue table must contain exactly these eight columns, in this exact order:

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|

Blocking assessment rules:

- ใช่ — Evidence shows the issue prevents safe or reliable implementation.
- ไม่ใช่ — Evidence sufficiently establishes that the issue does not prevent implementation.
- ยังตัดสินไม่ได้ — Available evidence is insufficient to determine whether implementation is blocked.

Every issue row must include evidence, impact, a proposed action, a blocking assessment, and a manual-fix assessment. Do not leave a blocking assessment blank.

Every issue row must list all relevant source documents used as evidence. Do not combine independently resolvable decisions in one row.

If no issues are found, retain the required table header and explicitly explain how the checks established that no issue exists.

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ | หลักฐานจากเอกสารปัจจุบัน | ต้องดำเนินการต่อ |
|---|---|---|---|---|

Allowed dispositions: confirmed, resolved with evidence, not reproducible, or still uncertain.

If the previous review was unavailable, explicitly state that regression comparison could not be performed. Do not invent previous findings.

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions

For each unresolved decision, state:

- A unique reference ID matching its issue-table entry.
- Source file and exact heading.
- The specific decision or evidence that is missing.
- Whether the documents explicitly establish that it is out of scope.
- Its blocking assessment and supporting evidence.
- The required human or Product Owner decision.

List each independent decision separately. Do not combine multiple decisions into one bullet if they can be resolved independently.

If there are no unresolved Open Questions, state that explicitly and explain the evidence supporting that conclusion.

## 6. ผลวัด Agent (only when requested and actual logs are available)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ |
|---|---|---|---|

Do not invent metrics. If no logs were supplied or accessible, state "ไม่มีข้อมูลใน log ที่ได้รับ" and do not provide numeric results.

## 7. ข้อจำกัดของการรีวิว

State what was and was not reviewed. Explicitly disclose unavailable files, missing previous reports, and any other evidence limitations.

## 8. ข้อสรุปก่อนส่ง Dev

- Review status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Agent recommendation: exactly one of <พร้อมส่ง Dev | ต้องแก้ | หลักฐานไม่เพียงพอ>
- Blocking issues remaining: <IDs or none, supported by findings>
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: <evidence-based explanation>

The recommendation "พร้อมส่ง Dev" is allowed only when all required checks pass, evidence is sufficient, and no blocking issue or unresolved implementation decision remains. Never claim the human has approved the work.

## Output Schema Validation — Mandatory

Before finalizing the report:

1. Compare every output table against the exact header and column count specified above.
2. Do not remove, rename, reorder, or omit a required column.
3. For the issue table, include all eight columns exactly as specified, including "Blocking หรือไม่".
4. Check that every issue has an explicit blocking assessment: "ใช่", "ไม่ใช่", or "ยังตัดสินไม่ได้", with an evidence-based reason.
5. Check that every checklist item has a result, evidence, reason, and manual-fix assessment.
6. Check that every independent unresolved decision has its own issue ID and corresponding issue-table row.
7. If the report does not match the required format, revise it before finalizing.
8. Do not claim format validation passed unless the final report actually matches the required schema.

## Checklist–Issue Consistency Validation — Mandatory

1. Compare every checklist result against the issue table, Open Questions, and final recommendation.
2. Do not mark a checklist item PASS if an unresolved issue directly contradicts its acceptance criteria.
3. If a checklist item remains PASS despite a related issue, provide explicit evidence explaining why that issue does not cause failure.
4. Assess "Blocking หรือไม่" separately from "ต้องแก้มือ". Explain the reasoning for each.
5. If the documents do not provide enough evidence to determine whether an issue blocks development, use "ยังตัดสินไม่ได้".
6. Verify the exact issue-table column names, order, and column count.
7. Verify that every distinct unresolved Open Question has its own unique issue-table entry. If multiple independent decisions are combined in one issue, split them before finalizing.
8. After splitting issues, update and re-check every reference in the checklist, issue table, Open Questions, previous-findings discussion, blocking issue list, and final recommendation.
9. Do not claim that checklist–issue consistency or Open Question tracking passed unless the report actually satisfies these rules.
10. If any validation fails, correct the report before assigning the final status. If the failure cannot be corrected from available evidence, disclose the limitation and do not claim PASS.
11. C-02 and C-03 consistency rule: If C-03 is FAIL because of a naming, value, or mapping inconsistency between Requirements, UX Flow, and Game Rules, C-02 must not be PASS unless explicit evidence demonstrates that the inconsistency does not violate C-02. Reconcile these checklist results before finalizing.
12. Open Question source reconciliation: Before assigning IDs to Open Question issues, inspect the Open Questions section of every available design document. Build an internal list of each independent decision and its source locations. If the same decision appears in multiple documents, record all relevant source locations in one issue. If two decisions can be resolved independently, create separate issue entries. Do not infer that the total number of decisions is two merely because one document lists two questions.
13. Checklist evidence precision: A checklist result must be supported by evidence specific to that checklist criterion. General statements such as "consistent overall" are insufficient when another checklist item or issue identifies a contradiction. If the evidence conflicts, correct the checklist result before finalizing.

## Final instruction

The purpose of this review is to give the human reviewer an accurate, traceable basis for deciding whether the feature is ready for Dev. Accuracy and evidence take priority over a positive status, short reports, or claiming that every check passed.

Never invent a decision, suppress an issue, combine independently resolvable decisions, or claim validation succeeded without checking the final report.
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

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
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

1. Verify that each required input file exists and that its relevant contents are available. List any missing or unreadable file. Never imply an unavailable file was reviewed.
2. Read all three design documents and compare them directly. Check names, values, time boundaries, state transitions, acceptance criteria, user actions, normal flows, edge cases, data mappings, and Open Questions.
3. Trace every finding to the exact file and heading, table, field, or criterion. Quote a short relevant phrase or identify the precise statements being compared. Never invent evidence or silently assume one document takes precedence.
4. If a previous review or its findings are supplied or available, re-check each finding against the current source documents. Record whether it is confirmed, resolved with evidence, not reproducible, or still uncertain. Never silently drop a previous finding.
5. If the previous report is unavailable, explicitly say so. Do not claim that regression comparison was completed.
6. Treat an unresolved decision as non-blocking only if the supplied documents explicitly establish that it is out of scope or explain why implementation can safely proceed without it.
7. Do not modify requirements.md, ux-flow.md, or game-rules.md. Recommend changes; do not invent product decisions.
8. Before finalizing, run every validation gate in this instruction. Correct the report whenever possible using available evidence. Do not claim a gate passed when its requirements are not satisfied.

## What to check

- Missing or ambiguous requirements that prevent implementation.
- Contradictions between Requirements, UX Flow, and Game Rules.
- Missing UX steps, unclear transitions, and unresolved user actions.
- Rules lacking conditions, outcomes, limits, or edge-case handling.
- Inconsistent names, values, states, timing rules, behavior, and data mappings.
- Acceptance criteria that cannot be traced to design rules, or vice versa.
- Claims that cannot be supported by supplied documents.
- Open Questions without an explicit disposition.
- Whether each independent unresolved decision has its own trackable issue.
- Whether the final report follows the exact required schema.

## Status rules

Use exactly one overall review status:

- PASS: All required documents and comparisons have sufficient evidence, all required checklist items pass, and no blocking issue or unresolved implementation decision remains.
- NEEDS_FIX: Sufficient evidence confirms at least one blocking contradiction, documentation issue, or unresolved implementation decision.
- INSUFFICIENT_EVIDENCE: A required document or critical evidence needed for a reliable decision is unavailable, and the available evidence does not already establish that implementation should not proceed.

If both insufficient evidence and a confirmed blocking issue exist, use NEEDS_FIX when the confirmed issue already establishes that implementation should not proceed. Explain the evidence limitation separately.

Do not use PASS merely because no issue was listed. An empty issue table is not evidence that the review passed.

Do not change a previous NEEDS_FIX to PASS without addressing every known previous finding and showing evidence for its resolution or explaining why it is not reproducible.

## Final Consistency Gate — Mandatory Before Finalizing

### 1. Reconcile checklist and findings

- Every checklist result must be supported by evidence.
- If a confirmed contradiction falls within C-02 or C-03, the affected checklist item must not be PASS unless explicit evidence establishes that the apparent contradiction is intentional and resolved.
- If an unresolved implementation decision affects C-05, C-05 must not be PASS.
- Never mark an item PASS simply because the report contains no finding for it.

### 2. Reconcile summary and issue table

- Every blocking issue mentioned in the summary must have a corresponding issue ID in the issue table.
- Every confirmed blocking issue in the issue table must be reflected in the overall status and recommendation.
- Do not describe an issue as resolved without supporting source evidence.

### 3. Reconcile Open Questions

For every unresolved Open Question:

- Identify the exact source file and section.
- Identify the independent decision that remains unresolved.
- Determine whether it affects implementation using documentary evidence.
- Identify the human or Product Owner decision required.
- Assign a blocking assessment supported by evidence.
- If evidence cannot establish whether implementation can safely proceed, use "ยังตัดสินไม่ได้"; never guess that the question is non-blocking.

### 4. Reconcile previous findings

Account for every previous finding available for review. Record its disposition and supporting evidence. Do not silently remove, merge, or rename findings in ways that lose traceability.

### 5. Apply the status decision rules

- INSUFFICIENT_EVIDENCE: Critical evidence is unavailable and no confirmed blocking issue already determines the outcome.
- NEEDS_FIX: At least one confirmed blocking issue or unresolved implementation decision prevents safe implementation.
- PASS: All required checks pass, evidence is sufficient, and no blocking issue or unresolved implementation decision remains.

### 6. Validate the final report

Verify that the overall status, checklist, issue table, previous-findings table, Open Questions, blocking IDs, and recommendation agree.

The recommendation must match the status exactly:

- PASS → พร้อมส่ง Dev
- NEEDS_FIX → ต้องแก้
- INSUFFICIENT_EVIDENCE → หลักฐานไม่เพียงพอ

The recommendation "พร้อมส่ง Dev" is allowed only when every required check passes. Never claim the human has approved the work.

This gate evaluates the report against the source evidence. It must not invent product decisions or modify source documents.

## Evidence-Based Open Question and Naming Validation — Mandatory

1. Do not classify an Open Question as non-blocking merely because it appears to be an enhancement or is not part of the core feature.
2. A question may be classified as non-blocking only when the supplied documents explicitly establish that the decision is out of scope or that implementation can safely proceed without it.
3. Compare canonical identifiers and display labels separately. Check data fields, status codes, tables, acceptance criteria, UX labels, assets, and game rules.
4. Record each confirmed mismatch or unresolved implementation decision in the issue table with exact evidence and an explicit blocking assessment.
5. Re-evaluate every affected checklist item. Do not mark C-02, C-03, or C-05 as PASS when the evidence contradicts that result.
6. Before assigning PASS, verify that every confirmed issue and unresolved implementation decision is accounted for in the issue table and final recommendation.

## Canonical Status Code and Display Label Validation — Mandatory

1. For every status or enum-like field, compare the canonical stored value, display label, asset mapping, acceptance criteria, and game-rule table separately.
2. Do not claim names are consistent merely because their meanings appear similar.
3. For example, if `pet_status_code` lists `ลีน` but the display label is `หุ่นลีน (สมส่วน)`, determine whether the documents explicitly define this as an intentional code-to-label mapping.
4. If the mapping is not explicitly defined, record it as a naming or mapping ambiguity with exact file and section references.
5. Re-evaluate C-02 and C-03. Do not mark them PASS while a relevant mapping ambiguity remains unresolved.
6. Do not invent the intended mapping. Recommend that the responsible human or Product Owner clarify it.

## Open Question Issue Tracking — Mandatory

This section defines a strict issue-tracking rule. Follow it literally.

1. **One independent decision equals one issue-table entry.** Every unresolved Open Question that may affect implementation must have its own issue ID and its own row.
2. Do not combine different product or technical decisions into one issue, even when they appear in the same source document, share a feature, or have the same blocking assessment.
3. Split an Open Question into separate issues whenever its decisions can be answered, approved, or resolved independently.
4. Each Open Question issue must identify:
   - A unique issue ID.
   - The source file and exact section.
   - The specific unresolved decision.
   - Evidence showing what is missing.
   - Potential implementation impact.
   - The human or Product Owner decision required.
   - Blocking assessment: "ใช่", "ไม่ใช่", or "ยังตัดสินไม่ได้".
   - The proposed next action and whether manual intervention is required.
5. Use a separate issue ID for each independent decision. Never reuse an ID for two decisions.
6. For example, these are two distinct issues and must never be combined:
   - Push Notification: define the notification threshold and decide whether the feature is in scope for the current iteration. If these are independently decidable questions, track each decision separately.
   - Hardware Step Counter: decide the expected behavior on devices without a hardware step sensor.
7. Do not assume that two questions form one issue simply because both remain unresolved or both block implementation.
8. Before finalizing, count the independent unresolved decisions in the source documents and compare that count with the corresponding issue-table entries. Each decision must be traceable to its own entry.
9. If one issue contains multiple independent decisions, split it into separate rows, assign unique IDs, and update all references in the checklist, Open Questions, previous-findings discussion where applicable, blocking issue list, summary, and final recommendation.
10. Every Open Question mentioned as a blocking issue in the final summary must have a matching issue-table entry.
11. Every issue-table entry arising from an unresolved Open Question must be referenced consistently in the Open Questions section.
12. Do not claim that Open Question tracking passed unless each independent decision has its own unique issue-table entry.
13. If the available evidence is insufficient to determine whether a question is blocking, use "ยังตัดสินไม่ได้". Do not convert uncertainty into a non-blocking result.
14. Never fabricate a human decision or state that a question has been resolved when the source documents remain unchanged and unresolved.

## Checklist Evidence and Manual-Fix Validation — Mandatory

1. Every checklist result must include a reason and evidence from the reviewed documents.
2. Before assigning PASS, verify that no unresolved issue directly contradicts the checklist criterion.
3. If an issue contradicts a checklist criterion, revise the result or provide explicit evidence explaining why the criterion still passes.
4. For C-08, if no previous review report is available, use INSUFFICIENT_EVIDENCE and explain that regression comparison cannot be performed. Do not require manual correction solely because historical data is unavailable.
5. Assess "ต้องแก้มือ" separately from the checklist result. Mark "ใช่" when human judgment, a product decision, or unavailable evidence requires human action. Mark "ไม่ใช่" only when the evidence and explicit rules are sufficient. Explain the reason.
6. Every issue must list all source documents used as evidence.
7. Before finalizing, verify checklist results, issue records, manual-fix assessments, and the final recommendation for consistency.

## Evidence and metrics rules

- Do not claim that code works or that tests passed. This agent reviews design documents only.
- If asked to report agent metrics, inspect actual available log files. Cite the exact log path and the value's evidence. Never fabricate counts, percentages, scores, or outcomes.
- If logs are unavailable, write "ไม่มีข้อมูลใน log ที่ได้รับ"; do not treat missing data as zero.
- Distinguish confirmed contradiction, ambiguous wording, unresolved product decision, and insufficient evidence.
- Complete the "ต้องแก้มือ" column for every checklist and issue row. Explain the specific human action required, if any.

## Required output format

Produce the report in the following structure. Preserve every heading, column name, column order, and required field.

# Design Review: steps

## 1. ข้อมูลการตรวจ

- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: steps
- Documents actually reviewed: <exact paths>
- Missing/unreadable documents: <paths or none>
- Previous review checked: <path/reference or not available>

## 2. ผล Checklist

Every checklist item must have a result, reason, evidence, and "ต้องแก้มือ" value. Use PASS, FAIL, or INSUFFICIENT_EVIDENCE.

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

The issue table must contain exactly these eight columns, in this exact order:

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|

Blocking assessment rules:

- ใช่ — Evidence shows the issue prevents safe or reliable implementation.
- ไม่ใช่ — Evidence sufficiently establishes that the issue does not prevent implementation.
- ยังตัดสินไม่ได้ — Available evidence is insufficient to determine whether implementation is blocked.

Every issue row must include evidence, impact, a proposed action, a blocking assessment, and a manual-fix assessment. Do not leave a blocking assessment blank.

Every issue row must list all relevant source documents used as evidence. Do not combine independently resolvable decisions in one row.

If no issues are found, retain the required table header and explicitly explain how the checks established that no issue exists.

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ | หลักฐานจากเอกสารปัจจุบัน | ต้องดำเนินการต่อ |
|---|---|---|---|---|

Allowed dispositions: confirmed, resolved with evidence, not reproducible, or still uncertain.

If the previous review was unavailable, explicitly state that regression comparison could not be performed. Do not invent previous findings.

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions

For each unresolved decision, state:

- A unique reference ID matching its issue-table entry.
- Source file and exact heading.
- The specific decision or evidence that is missing.
- Whether the documents explicitly establish that it is out of scope.
- Its blocking assessment and supporting evidence.
- The required human or Product Owner decision.

List each independent decision separately. Do not combine multiple decisions into one bullet if they can be resolved independently.

If there are no unresolved Open Questions, state that explicitly and explain the evidence supporting that conclusion.

## 6. ผลวัด Agent (only when requested and actual logs are available)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ |
|---|---|---|---|

Do not invent metrics. If no logs were supplied or accessible, state "ไม่มีข้อมูลใน log ที่ได้รับ" and do not provide numeric results.

## 7. ข้อจำกัดของการรีวิว

State what was and was not reviewed. Explicitly disclose unavailable files, missing previous reports, and any other evidence limitations.

## 8. ข้อสรุปก่อนส่ง Dev

- Review status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Agent recommendation: exactly one of <พร้อมส่ง Dev | ต้องแก้ | หลักฐานไม่เพียงพอ>
- Blocking issues remaining: <IDs or none, supported by findings>
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: <evidence-based explanation>

The recommendation "พร้อมส่ง Dev" is allowed only when all required checks pass, evidence is sufficient, and no blocking issue or unresolved implementation decision remains. Never claim the human has approved the work.

## Output Schema Validation — Mandatory

Before finalizing the report:

1. Compare every output table against the exact header and column count specified above.
2. Do not remove, rename, reorder, or omit a required column.
3. For the issue table, include all eight columns exactly as specified, including "Blocking หรือไม่".
4. Check that every issue has an explicit blocking assessment: "ใช่", "ไม่ใช่", or "ยังตัดสินไม่ได้", with an evidence-based reason.
5. Check that every checklist item has a result, evidence, reason, and manual-fix assessment.
6. Check that every independent unresolved decision has its own issue ID and corresponding issue-table row.
7. If the report does not match the required format, revise it before finalizing.
8. Do not claim format validation passed unless the final report actually matches the required schema.

## Checklist–Issue Consistency Validation — Mandatory

1. Compare every checklist result against the issue table, Open Questions, and final recommendation.
2. Do not mark a checklist item PASS if an unresolved issue directly contradicts its acceptance criteria.
3. If a checklist item remains PASS despite a related issue, provide explicit evidence explaining why that issue does not cause failure.
4. Assess "Blocking หรือไม่" separately from "ต้องแก้มือ". Explain the reasoning for each.
5. If the documents do not provide enough evidence to determine whether an issue blocks development, use "ยังตัดสินไม่ได้".
6. Verify the exact issue-table column names, order, and column count.
7. Verify that every distinct unresolved Open Question has its own unique issue-table entry. If multiple independent decisions are combined in one issue, split them before finalizing.
8. After splitting issues, update and re-check every reference in the checklist, issue table, Open Questions, previous-findings discussion, blocking issue list, and final recommendation.
9. Do not claim that checklist–issue consistency or Open Question tracking passed unless the report actually satisfies these rules.
10. If any validation fails, correct the report before assigning the final status. If the failure cannot be corrected from available evidence, disclose the limitation and do not claim PASS.
11. C-02 and C-03 consistency rule: If C-03 is FAIL because of a naming, value, or mapping inconsistency between Requirements, UX Flow, and Game Rules, C-02 must not be PASS unless explicit evidence demonstrates that the inconsistency does not violate C-02. Reconcile these checklist results before finalizing.
12. Open Question source reconciliation: Before assigning IDs to Open Question issues, inspect the Open Questions section of every available design document. Build an internal list of each independent decision and its source locations. If the same decision appears in multiple documents, record all relevant source locations in one issue. If two decisions can be resolved independently, create separate issue entries. Do not infer that the total number of decisions is two merely because one document lists two questions.
13. Checklist evidence precision: A checklist result must be supported by evidence specific to that checklist criterion. General statements such as "consistent overall" are insufficient when another checklist item or issue identifies a contradiction. If the evidence conflicts, correct the checklist result before finalizing.

## Final instruction

The purpose of this review is to give the human reviewer an accurate, traceable basis for deciding whether the feature is ready for Dev. Accuracy and evidence take priority over a positive status, short reports, or claiming that every check passed.

Never invent a decision, suppress an issue, combine independently resolvable decisions, or claim validation succeeded without checking the final report.
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

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
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
ทุกข้อมีผล เหตุผล และหลักฐานจากไฟล์/หัวข้อที่ตรวจจริง หากข้อมูลไม่พอให้ใช้ INSUFFICIENT_EVIDENCE ห้ามเดา

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | PASS | requirements.md หัวข้อ 1-7 มี User Stories, Acceptance Criteria และ Edge Cases ชัดเจน | ไม่ใช่ (โครงสร้าง requirements ครบถ้วนสมบูรณ์) |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | FAIL | requirements.md หัวข้อ 7 ระบุค่า pet_status_code เป็น `ลีน` แต่ ux-flow.md และ game-rules.md ใช้คำว่า `หุ่นลีน (สมส่วน)` ซึ่งไม่ตรงกัน | ใช่ (ต้องปรับปรุงชื่อสถานะให้เป็นมาตรฐานเดียวกันทุกเอกสาร) |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | FAIL | requirements.md หัวข้อ 7 ใช้คำว่า `ลีน` ขณะที่ game-rules.md หัวข้อ 2 ใช้ `หุ่นลีน (สมส่วน)` และ ux-flow.md หัวข้อ 5 ใช้ `pet_status_lean.png` | ใช่ (ต้องแก้ชื่อสถานะ pet_status_code ใน requirements.md ให้ตรงกับ game-rules.md) |
| C-04 | ขั้นตอนใช้งานและ Edge Cases เพียงพอ | PASS | ux-flow.md หัวข้อ 3 และ requirements.md หัวข้อ 5 ครอบคลุมทั้ง Happy Path และ Edge Cases เช่น Permission Denied และ Foreground Crossing | ไม่ใช่ (ขั้นตอนและ edge cases ครบถ้วนตามขอบเขต) |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | FAIL | requirements.md หัวข้อ 8, ux-flow.md หัวข้อ 6 และ game-rules.md หัวข้อ 5 มีคำถาม Open Questions ค้างอยู่ 2 ประเด็นโดยไม่มีการระบุข้อยกเว้นหรือความชัดเจนว่าบล็อกหรือไม่ | ใช่ (Product Owner ต้องตัดสินใจเรื่อง Push Notification และ Hardware Step Counter) |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ข้อค้นพบทั้งหมดอ้างอิงตรงจากไฟล์ requirements.md, ux-flow.md และ game-rules.md | ไม่ใช่ (หลักฐานอ้างอิงตรงตามเอกสารต้นทาง) |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | สรุปผล ตารางปัญหา และคำแนะนำมีความสอดคล้องกับผลการตรวจเอกสาร | ไม่ใช่ (ผลลัพธ์การสรุปสอดคล้องกับตารางปัญหา) |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีรายงานผลการตรวจรอบก่อนหน้าให้เปรียบเทียบ | ไม่ใช่ (เนื่องจากไม่มีข้อมูลรอบก่อน จึงบันทึกเป็น insufficient evidence) |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|
| ISS-01 | docs/steps/requirements.md | หัวข้อ 7. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น) | ชื่อสถานะสัตว์เลี้ยงในตาราง field `pet_status_code` ระบุเป็น `ลีน` แต่ใน `game-rules.md` หัวข้อ 2 และ `ux-flow.md` หัวข้อ 5 ระบุเป็น `หุ่นลีน (สมส่วน)` และ `pet_status_lean.png` | อาจทำให้ Developer อ้างอิงชื่อ Status Code ในฐานข้อมูลหรือโค้ดผิดพลาด ไม่ตรงกับเงื่อนไขใน Game Rules | ใช่ | แก้ไขค่าใน `requirements.md` หัวข้อ 7 จาก `ลีน` ให้เป็น `หุ่นลีน (สมส่วน)` เพื่อให้ตรงกับ Game Rules และ UX Flow | ใช่ (ต้องแก้ไขชื่อสถานะให้ตรงกันทุกไฟล์) |
| ISS-02 | docs/steps/requirements.md | หัวข้อ 8. คำถามที่ยังเปิดอยู่ | มี Open Question เกี่ยวกับ Push Notification เมื่อผู้ใช้ใกล้ทำเป้าหมายสำเร็จ | นักพัฒนาไม่ทราบว่าจะต้องออกแบบหรือ implement ฟีเจอร์แจ้งเตือนล่วงหน้าหรือไม่ | ยังตัดสินไม่ได้ | Product Owner ต้องตัดสินใจว่าจะนำ Push Notification เข้ามาทำในรอบนี้หรือตัดออกไปไว้ใน Out of Scope | ใช่ (Product Owner ต้องให้ความชัดเจน) |
| ISS-03 | docs/steps/requirements.md | หัวข้อ 8. คำถามที่ยังเปิดอยู่ | มี Open Question เกี่ยวกับอุปกรณ์ที่ไม่มีฮาร์ดแวร์เซนเซอร์นับก้าว (Hardware Step Counter) ว่าจะมี Fallback อย่างไร | นักพัฒนาไม่ทราบว่าต้องรองรับอุปกรณ์ที่ไม่มีเซนเซอร์นับก้าวหรือไม่ และจะจัดการอย่างไรหากเปิดแอปบนอุปกรณ์ดังกล่าว | ยังตัดสินไม่ได้ | Product Owner ต้องตัดสินใจกำหนดข้อกำหนด (Fallback หรือบังคับเฉพาะเครื่องที่มีเซนเซอร์) | ใช่ (Product Owner ต้องให้ความชัดเจน) |

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|
| - | ไม่มีข้อมูลสำหรับเปรียบเทียบ (รอบรีวิวก่อนหน้าไม่ถูกจัดเตรียมไว้) | ยังยืนยันไม่ได้ | ไม่มีรายงานหรือบันทึกการรีวิวก่อนหน้าในระบบ | ข้ามการตรวจสอบรอบก่อนเนื่องจากไม่มีข้อมูล |

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- ISS-02: docs/steps/requirements.md หัวข้อ 8 (รวมถึง ux-flow.md หัวข้อ 6 และ game-rules.md หัวข้อ 5) - รูปแบบการแจ้งเตือน (Push Notification) เมื่อผู้ใช้ใกล้ทำเป้าหมายสำเร็จ 100% ควรส่งล่วงหน้าที่ก้าวเท่าไหร่ ขาดการระบุขอบเขตที่ชัดเจน เอกสารยังไม่ระบุว่าอยู่นอกขอบเขต (Out of Scope) หรือไม่ การตัดสินใจขึ้นอยู่กับ Product Owner โดยประเมินว่ายังตัดสินไม่ได้เนื่องจากอาจส่งผลต่อการออกแบบ API และ Notification Service
- ISS-03: docs/steps/requirements.md หัวข้อ 8 (รวมถึง ux-flow.md หัวข้อ 6 และ game-rules.md หัวข้อ 5) - ในกรณีที่อุปกรณ์ของผู้ใช้ไม่มีฮาร์ดแวร์เซนเซอร์นับก้าว ระบบจะมี Fallback อย่างไร ขาดข้อกำหนดทางเทคนิคและการตัดสินใจเชิงผลิตภัณฑ์ การตัดสินใจขึ้นอยู่กับ Product Owner ร่วมกับ Tech Lead โดยประเมินว่ายังตัดสินไม่ได้เพราะอาจกระทบต่อการทำงานบนอุปกรณ์จริงของผู้ใช้บางกลุ่ม

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|
| ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มีข้อมูลใน log ที่ได้รับ |

## 7. ข้อจำกัดของการรีวิว
- ตรวจสอบเอกสารการออกแบบเฉพาะ 3 ไฟล์ ได้แก่ docs/steps/requirements.md, docs/steps/ux-flow.md และ docs/steps/game-rules.md เท่านั้น
- ไม่มีรายงานการรีวิวก่อนหน้า (Previous review report) ทำให้ไม่สามารถตรวจสอบการแก้ไขจากรอบก่อนได้
- ไม่มี Log หรือข้อมูลโค้ดจริง เนื่องจากเป็นการรีวิวในระดับเอกสารการออกแบบ (Design Documents)

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: NEEDS_FIX
- Agent recommendation: ต้องแก้
- Blocking issues remaining: ISS-01, ISS-02, ISS-03 (พบความไม่สอดคล้องของชื่อสถานะ pet_status_code และมี Open Questions ที่ยังไม่ได้รับข้อสรุปจาก Product Owner)
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: ผลการตรวจสอบพบปัญหาความไม่สอดคล้องของชื่อสถานะระหว่างเอกสาร Requirements และ Game Rules (ISS-01) รวมถึงมีคำถาม Open Questions ค้างอยู่ 2 ประเด็น (ISS-02, ISS-03) ที่ยังไม่ได้รับการตัดสินใจอย่างเป็นทางการจาก Product Owner ซึ่งอาจส่งผลกระทบต่อการพัฒนาและความถูกต้องของข้อมูล จึงไม่สามารถแนะนำให้ส่ง Dev ได้ในรอบนี้
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
ทุกข้อมีผล เหตุผล และหลักฐานจากไฟล์/หัวข้อที่ตรวจจริง หากข้อมูลไม่พอให้ใช้ INSUFFICIENT_EVIDENCE ห้ามเดา

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | PASS | requirements.md หัวข้อ 1-7 มี User Stories, Acceptance Criteria และ Edge Cases ชัดเจน | ไม่ใช่ (โครงสร้าง requirements ครบถ้วนสมบูรณ์) |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | FAIL | requirements.md หัวข้อ 7 ระบุค่า pet_status_code เป็น `ลีน` แต่ ux-flow.md และ game-rules.md ใช้คำว่า `หุ่นลีน (สมส่วน)` ซึ่งไม่ตรงกัน | ใช่ (ต้องปรับปรุงชื่อสถานะให้เป็นมาตรฐานเดียวกันทุกเอกสาร) |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | FAIL | requirements.md หัวข้อ 7 ใช้คำว่า `ลีน` ขณะที่ game-rules.md หัวข้อ 2 ใช้ `หุ่นลีน (สมส่วน)` และ ux-flow.md หัวข้อ 5 ใช้ `pet_status_lean.png` | ใช่ (ต้องแก้ชื่อสถานะ pet_status_code ใน requirements.md ให้ตรงกับ game-rules.md) |
| C-04 | ขั้นตอนใช้งานและ Edge Cases เพียงพอ | PASS | ux-flow.md หัวข้อ 3 และ requirements.md หัวข้อ 5 ครอบคลุมทั้ง Happy Path และ Edge Cases เช่น Permission Denied และ Foreground Crossing | ไม่ใช่ (ขั้นตอนและ edge cases ครบถ้วนตามขอบเขต) |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | FAIL | requirements.md หัวข้อ 8, ux-flow.md หัวข้อ 6 และ game-rules.md หัวข้อ 5 มีคำถาม Open Questions ค้างอยู่ 2 ประเด็นโดยไม่มีการระบุข้อยกเว้นหรือความชัดเจนว่าบล็อกหรือไม่ | ใช่ (Product Owner ต้องตัดสินใจเรื่อง Push Notification และ Hardware Step Counter) |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ข้อค้นพบทั้งหมดอ้างอิงตรงจากไฟล์ requirements.md, ux-flow.md และ game-rules.md | ไม่ใช่ (หลักฐานอ้างอิงตรงตามเอกสารต้นทาง) |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | สรุปผล ตารางปัญหา และคำแนะนำมีความสอดคล้องกับผลการตรวจเอกสาร | ไม่ใช่ (ผลลัพธ์การสรุปสอดคล้องกับตารางปัญหา) |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีรายงานผลการตรวจรอบก่อนหน้าให้เปรียบเทียบ | ไม่ใช่ (เนื่องจากไม่มีข้อมูลรอบก่อน จึงบันทึกเป็น insufficient evidence) |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|
| ISS-01 | docs/steps/requirements.md | หัวข้อ 7. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น) | ชื่อสถานะสัตว์เลี้ยงในตาราง field `pet_status_code` ระบุเป็น `ลีน` แต่ใน `game-rules.md` หัวข้อ 2 และ `ux-flow.md` หัวข้อ 5 ระบุเป็น `หุ่นลีน (สมส่วน)` และ `pet_status_lean.png` | อาจทำให้ Developer อ้างอิงชื่อ Status Code ในฐานข้อมูลหรือโค้ดผิดพลาด ไม่ตรงกับเงื่อนไขใน Game Rules | ใช่ | แก้ไขค่าใน `requirements.md` หัวข้อ 7 จาก `ลีน` ให้เป็น `หุ่นลีน (สมส่วน)` เพื่อให้ตรงกับ Game Rules และ UX Flow | ใช่ (ต้องแก้ไขชื่อสถานะให้ตรงกันทุกไฟล์) |
| ISS-02 | docs/steps/requirements.md | หัวข้อ 8. คำถามที่ยังเปิดอยู่ | มี Open Question เกี่ยวกับ Push Notification เมื่อผู้ใช้ใกล้ทำเป้าหมายสำเร็จ | นักพัฒนาไม่ทราบว่าจะต้องออกแบบหรือ implement ฟีเจอร์แจ้งเตือนล่วงหน้าหรือไม่ | ยังตัดสินไม่ได้ | Product Owner ต้องตัดสินใจว่าจะนำ Push Notification เข้ามาทำในรอบนี้หรือตัดออกไปไว้ใน Out of Scope | ใช่ (Product Owner ต้องให้ความชัดเจน) |
| ISS-03 | docs/steps/requirements.md | หัวข้อ 8. คำถามที่ยังเปิดอยู่ | มี Open Question เกี่ยวกับอุปกรณ์ที่ไม่มีฮาร์ดแวร์เซนเซอร์นับก้าว (Hardware Step Counter) ว่าจะมี Fallback อย่างไร | นักพัฒนาไม่ทราบว่าต้องรองรับอุปกรณ์ที่ไม่มีเซนเซอร์นับก้าวหรือไม่ และจะจัดการอย่างไรหากเปิดแอปบนอุปกรณ์ดังกล่าว | ยังตัดสินไม่ได้ | Product Owner ต้องตัดสินใจกำหนดข้อกำหนด (Fallback หรือบังคับเฉพาะเครื่องที่มีเซนเซอร์) | ใช่ (Product Owner ต้องให้ความชัดเจน) |

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|
| - | ไม่มีข้อมูลสำหรับเปรียบเทียบ (รอบรีวิวก่อนหน้าไม่ถูกจัดเตรียมไว้) | ยังยืนยันไม่ได้ | ไม่มีรายงานหรือบันทึกการรีวิวก่อนหน้าในระบบ | ข้ามการตรวจสอบรอบก่อนเนื่องจากไม่มีข้อมูล |

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- ISS-02: docs/steps/requirements.md หัวข้อ 8 (รวมถึง ux-flow.md หัวข้อ 6 และ game-rules.md หัวข้อ 5) - รูปแบบการแจ้งเตือน (Push Notification) เมื่อผู้ใช้ใกล้ทำเป้าหมายสำเร็จ 100% ควรส่งล่วงหน้าที่ก้าวเท่าไหร่ ขาดการระบุขอบเขตที่ชัดเจน เอกสารยังไม่ระบุว่าอยู่นอกขอบเขต (Out of Scope) หรือไม่ การตัดสินใจขึ้นอยู่กับ Product Owner โดยประเมินว่ายังตัดสินไม่ได้เนื่องจากอาจส่งผลต่อการออกแบบ API และ Notification Service
- ISS-03: docs/steps/requirements.md หัวข้อ 8 (รวมถึง ux-flow.md หัวข้อ 6 และ game-rules.md หัวข้อ 5) - ในกรณีที่อุปกรณ์ของผู้ใช้ไม่มีฮาร์ดแวร์เซนเซอร์นับก้าว ระบบจะมี Fallback อย่างไร ขาดข้อกำหนดทางเทคนิคและการตัดสินใจเชิงผลิตภัณฑ์ การตัดสินใจขึ้นอยู่กับ Product Owner ร่วมกับ Tech Lead โดยประเมินว่ายังตัดสินไม่ได้เพราะอาจกระทบต่อการทำงานบนอุปกรณ์จริงของผู้ใช้บางกลุ่ม

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|
| ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มีข้อมูลใน log ที่ได้รับ |

## 7. ข้อจำกัดของการรีวิว
- ตรวจสอบเอกสารการออกแบบเฉพาะ 3 ไฟล์ ได้แก่ docs/steps/requirements.md, docs/steps/ux-flow.md และ docs/steps/game-rules.md เท่านั้น
- ไม่มีรายงานการรีวิวก่อนหน้า (Previous review report) ทำให้ไม่สามารถตรวจสอบการแก้ไขจากรอบก่อนได้
- ไม่มี Log หรือข้อมูลโค้ดจริง เนื่องจากเป็นการรีวิวในระดับเอกสารการออกแบบ (Design Documents)

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: NEEDS_FIX
- Agent recommendation: ต้องแก้
- Blocking issues remaining: ISS-01, ISS-02, ISS-03 (พบความไม่สอดคล้องของชื่อสถานะ pet_status_code และมี Open Questions ที่ยังไม่ได้รับข้อสรุปจาก Product Owner)
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: ผลการตรวจสอบพบปัญหาความไม่สอดคล้องของชื่อสถานะระหว่างเอกสาร Requirements และ Game Rules (ISS-01) รวมถึงมีคำถาม Open Questions ค้างอยู่ 2 ประเด็น (ISS-02, ISS-03) ที่ยังไม่ได้รับการตัดสินใจอย่างเป็นทางการจาก Product Owner ซึ่งอาจส่งผลกระทบต่อการพัฒนาและความถูกต้องของข้อมูล จึงไม่สามารถแนะนำให้ส่ง Dev ได้ในรอบนี้
~~~~
