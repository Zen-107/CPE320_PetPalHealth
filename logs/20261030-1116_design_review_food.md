# Log: design_review · food · 2026-10-30 11:16

<!-- meta: {"role": "design_review", "feature": "food", "time": "2026-10-30 11:16", "status": "ok", "provider": "gemini", "model": "gemini-3.5-flash-lite", "attempts": 1, "seconds": 6.1, "llm_calls": 1, "total_tokens": 15983, "agent_version": "ac395134"} -->

| รายการ | ค่า |
|---|---|
| สถานะ | สำเร็จ |
| ผู้ให้บริการ / รุ่น | gemini / gemini-3.5-flash-lite |
| ลำดับความพยายาม | gemini: สำเร็จ |
| เวลารวม | 6.1 วินาที |
| จำนวนครั้งที่เรียก LLM | 1 |
| tokens (prompt / completion / total) | 14504 / 1479 / 15983 |
| ไฟล์ input | docs/food/requirements.md, docs/food/ux-flow.md, docs/food/game-rules.md |
| ไฟล์ output | docs/food/design-review.md |
| agent | agents/design_reviewer.md (เวอร์ชัน ac395134) |
| --note | - |

## ความพยายามที่ 1 — gemini (gemini-3.5-flash-lite) — สำเร็จ, 6.1 วินาที

### Agent

- ไฟล์: agents/design_reviewer.md
- role: Software Design Reviewer
- goal: Review the food design documents against supplied project specifications, verify prior findings when available, and report evidence-backed contradictions, ambiguities, missing decisions, and actionable documentation issues without modifying source documents.
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

# Design Review: food

## 1. ข้อมูลการตรวจ

- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: food
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
14. **Blocking Status Consistency:** When an issue is marked "ยังตัดสินไม่ได้" under the Blocking column, do not automatically classify it as a confirmed blocking issue in the summary. Evaluate it using the documented blocking criteria. If the available evidence cannot establish whether it blocks development, state that the blocking status is unresolved and explain what decision or evidence is needed. Keep the issue table, Open Questions section, and final summary consistent.
15. **Requirements Readiness Consistency:** Do not mark C-01 PASS solely because the Requirements document has a complete structure, User Stories, Acceptance Criteria, and Edge Cases. Also evaluate whether unresolved requirements or Open Questions prevent implementation. If they may affect implementation and remain undecided, explain the limitation and ensure the checklist result matches the documented review criteria.
16. **C-07 Final Cross-Check:** Before marking C-07 PASS, compare the final Review Status, checklist results, issue table, Open Questions section, blocking issue list, and recommendations. If any result contradicts another section, resolve the contradiction before finalizing. C-07 must not be PASS while material inconsistencies remain.
17. **Evidence-Based Issue Severity:** Distinguish between (a) a confirmed blocking issue, (b) an issue whose blocking status is unresolved, and (c) a non-blocking issue. Do not treat these categories as interchangeable. Explain the evidence and required decision for each unresolved issue.
18. **One Independent Decision per Issue:** Each independent Open Question or decision must have its own unique issue ID. Do not combine independent decisions into one issue merely because they appear in the same document or affect the same feature.
19. **Unique Issue ID Validation:** Before finalizing, verify that every issue ID is unique and consistently refers to the same problem in the issue table, Open Questions section, checklist evidence, and final summary. If two independent questions are listed, they must not share one ID.
20. **Blocking Status Must Match Everywhere:** For each issue, use the same blocking classification in the issue table, Open Questions section, and final summary. If the evidence does not establish whether an issue blocks development, explicitly label it as unresolved rather than claiming that it definitely blocks development. If it is confirmed to block a specific part of development, state that scope clearly and use the same classification throughout the report.
21. **C-07 Requires Unique IDs and Status Agreement:** C-07 must be FAIL whenever issue IDs are duplicated for independent problems, issue references point to different problems, or blocking classifications conflict between report sections. Change C-07 to PASS only after all such inconsistencies have been corrected.
22. **Final Issue Audit:** Before finalizing, count the independent problems in the issue table and compare them with the Open Questions section. Confirm that each independent problem has one unique ID, every reference points to the correct problem, and the summary includes all relevant issues without merging or omitting any.

## Final instruction

The purpose of this review is to give the human reviewer an accurate, traceable basis for deciding whether the feature is ready for Dev. Accuracy and evidence take priority over a positive status, short reports, or claiming that every check passed.

Never invent a decision, suppress an issue, combine independently resolvable decisions, or claim validation succeeded without checking the final report.
~~~~

### Tasks (prompt ที่ main.py สร้าง)

#### Task → docs/food/design-review.md

~~~~text
ฟีเจอร์: food

งานของคุณ: ตรวจเอกสาร Requirements, UX Flow และ Game Rules ก่อนส่งงานให้ Dev ตรวจความครบถ้วนและความสอดคล้องของเอกสาร ตรวจตัวเลข ชื่อสถานะ ขั้นตอนการใช้งาน และ edge cases โดยอ้างอิงหลักฐานจากไฟล์ที่ได้รับ ระบุข้อผิดพลาดพร้อมไฟล์/หัวข้อ เหตุผล และแนวทางแก้ไข ห้ามแต่งข้อกำหนดหรือผลทดสอบขึ้นเอง สรุปผลเป็น PASS, NEEDS_FIX หรือ INSUFFICIENT_EVIDENCE

ข้อมูลประกอบ:
=== docs/food/requirements.md ===
# Requirements: บันทึกการให้อาหารสัตว์เลี้ยงและโภชนาการ (food)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Product agent · ผู้ตรวจ: Senior Team · อ้างอิง Issue: #101

## 1. สรุปฟีเจอร์
ฟีเจอร์บันทึกการให้อาหารสัตว์เลี้ยงช่วยให้ผู้ใช้สามารถบันทึกเมนูอาหารประจำวันได้อย่างรวดเร็วผ่านระบบ AI Parsing ที่ดึงข้อมูลโภชนาการอัตโนมัติ พร้อมระบบคำนวณเป้าหมายแคลอรี่รายบุคคลที่อ้างอิงตามช่วงอายุ เพศ และค่า BMI เพื่อขับเคลื่อนหลอดพลังงานและ Animation ของสัตว์เลี้ยง รวมถึงรองรับการจัดเก็บประวัติย้อนหลัง 7 วัน

## 2. User stories

| ID | ในฐานะ | ฉันอยาก | เพื่อ |
|---|---|---|---|
| US-1 | ผู้ใช้งานแอปพลิเคชัน | บันทึกเมนูอาหารที่ทานในแต่ละวันและให้ระบบประมวลผลแคลอรี่โดยอัตโนมัติ | สามารถติดตามพลังงานที่ได้รับในแต่ละวันได้อย่างสะดวกรวดเร็ว |
| US-2 | ผู้ใช้ที่มีการตั้งค่าข้อมูลส่วนตัว (อายุ เพศ และน้ำหนัก/ส่วนสูง) | ได้รับเป้าหมายแคลอรี่ประจำวันและสภาวะสัตว์เลี้ยงที่คำนวณจากข้อมูลสุขภาพจริง | สามารถดูแลโภชนาการให้สอดคล้องกับความต้องการของร่างกายตนเอง |
| US-3 | ผู้ใช้งานที่ข้ามการกรอกข้อมูลส่วนตัว | เห็น CTA Banner แทนที่หลอดพลังงาน % โดยไม่มีปัญหา Layout Shift | สามารถใช้งานแอปต่อได้และเข้าถึงปุ่มเชิญชวนกรอกโปรไฟล์ได้อย่างเหมาะสม |
| US-4 | ผู้ใช้งานที่บันทึกอาหารจนเกินเป้าหมาย | เห็นการเปลี่ยนแปลงสถานะของสัตว์เลี้ยงและหลอดพลังงานตามเงื่อนไขส่วนเกิน 100 kcal | ทราบระดับพลังงานส่วนเกินและรับคำเตือนที่เหมาะสม |
| US-5 | นักพัฒนาและระบบหลังบ้าน | จัดเก็บข้อมูลการบริโภคอาหารตามรอบตัดวัน 05:00 น. และรองรับโครงสร้างประวัติ 7 วัน | ข้อมูลสถิติย้อนหลังมีความถูกต้องและตรงรอบวันใช้งานจริง |

## 3. Acceptance criteria

| ID | อ้างถึง | เงื่อนไข (ก่อน /เมื่อ / แล้ว) | ค่าที่ทดสอบได้ |
|---|---|---|---|
| AC-1 | US-1 | ก่อน: อยู่หน้าบันทึกอาหาร / เมื่อ: ส่งข้อความเมนูอาหารผ่าน AI / แล้ว: ระบบคืนค่า JSON ของโภชนาการ | ผลลัพธ์เป็น JSON Format เช่น `{"calories": 400, "high_sodium": true, "high_sugar": false}` ภายใน 3 วินาที |
| AC-2 | US-1 | ก่อน: AI คืนค่าแคลอรี่เป็นช่วงตัวเลข / เมื่อ: ระบบทำการประมวลผล / แล้ว: เลือกค่าแคลอรี่มาใช้งาน | ระบบนำค่ากึ่งกลาง (Median) ของช่วงตัวเลขมาคำนวณโดยอัตโนมัติ |
| AC-3 | US-1, US-5 | ก่อน: เวลาปัจจุบันคือ 03:00 น. ของวันที่ 15 / เมื่อ: ผู้ใช้บันทึกอาหาร / แล้ว: ระบบบันทึก Log ลงฐานข้อมูล | ค่า `date` ในฐานข้อมูลถูกบันทึกเป็นรอบวันที่ 14 ตามรอบตัดวัน 05:00 น. (ICT) |
| AC-4 | US-2 | ก่อน: ผู้ใช้กรอกอายุ / เมื่อ: พยายามใส่ทศนิยม (เช่น 25.5) / แล้ว: ระบบปฏิเสธการบันทึก | ระบบบล็อกและบังคับให้รับค่าอายุเป็นจำนวนเต็ม (Integer) ช่วง 1 - 120 เท่านั้น |
| AC-5 | US-2 | ก่อน: ผู้ใช้เลือกเพศชาย อายุ 25 ปี / เมื่อ: ดึงค่า Base Target / แล้ว: แสดงผลเป้าหมายแคลอรี่พื้นฐาน | ระบบอ้างอิงจากตาราง Base Target Reference Table ได้ค่า 2,000 kcal |
| AC-6 | US-2 | ก่อน: ผู้ใช้มีค่า BMI < 18.5 (ผอม) / เมื่อ: คำนวณเป้าหมายแคลอรี่ / แล้ว: ปรับเพิ่มเป้าหมาย | ระบบบวกเพิ่ม +400 kcal จาก Base Target |
| AC-7 | US-2 | ก่อน: ผู้ใช้มีค่า BMI ≥ 23.0 (อ้วน/น้ำหนักเกิน) / เมื่อ: คำนวณเป้าหมายแคลอรี่ / แล้ว: ปรับลดเป้าหมาย | ระบบลบออก -400 kcal จาก Base Target |
| AC-8 | US-3 | ก่อน: ผู้ใช้กดข้ามการกรอกโปรไฟล์ / เมื่อ: เปิดหน้าจอหลัก / แล้ว: แสดง UI ทดแทน | แสดง Call-to-Action Banner ที่มีขนาดความกว้างและสูง (Dimension) เท่ากับ Widget หลอดพลังงานเดิม พร้อมยอดรวมแคลอรี่รายวัน โดยไม่มี Layout Shift |
| AC-9 | US-4 | ก่อน: แคลอรี่รวมเกินเป้าหมายแต่เกิน ≤ 100 kcal / เมื่อ: ตรวจสอบสถานะหลอดและสัตว์เลี้ยง / แล้ว: แสดงผลปกติ | หลอดพลังงานไม่เปลี่ยนเป็นสีแดง และสัตว์เลี้ยงอยู่ในท่าปกติ (ไม่แสดงท่าอิ่มเกิน) |
| AC-10 | US-4 | ก่อน: แคลอรี่รวมเกินเป้าหมาย > 100 kcal / เมื่อ: ตรวจสอบสถานะหลอดและสัตว์เลี้ยง / แล้ว: เปลี่ยนแปลงสถานะ | หลอดพลังงานเปลี่ยนเป็นสีแดง สัตว์เลี้ยงแสดง "ท่าอิ่มพุงกาง" และแสดงข้อความ "อิ่มแล้ว" |
| AC-11 | US-4 | ก่อน: อยู่ในสถานะเกินเป้าหมาย > 100 kcal / เมื่อ: กดปุ่มบันทึกอาหารเพิ่ม / แล้ว: แสดงอนิเมชั่นและข้อความเตือน | แสดง "ท่าอิ่มพุงกางแต่ยังกิน" พร้อม Toast ข้อความ "พอเถอะน้าคนดี" ทุกครั้งที่มีการกดบันทึกซ้ำ |
| AC-12 | US-4 | ก่อน: มีการแสดง Toast Message / เมื่อ: มีข้อความใหม่เข้ามาซ้อน / แล้ว: จัดการแสดงผล | แสดง Toast ลอยเหนือตัวสัตว์เลี้ยง โดยมีจุดอ้างอิง (Anchor) ห่างจากขอบบนสุดของ Asset สัตว์เลี้ยง 12px เสมอ และจำกัด 1 ข้อความต่อ 1 การบันทึก (ค้าง 5 วินาที หรือ Queue replace ทันทีเมื่อส่งซ้อน) |

### Base Target Reference Table
| ช่วงอายุ (ปี) | เพศชาย (Male Base Target) | เพศหญิง (Female Base Target) |
| :--- | :--- | :--- |
| **10 – 12 ปี** | 1,700 kcal | 1,600 kcal |
| **13 – 15 ปี (Growth Spurt)** | 2,100 kcal | 1,800 kcal |
| **16 – 18 ปี** | 2,300 kcal | 1,850 kcal |
| **19 – 50 ปี (ผู้ใหญ่)** | 2,000 kcal | 1,600 kcal |
| **51 ปีขึ้นไป** | 1,800 kcal | 1,400 kcal |

## 4. Edge cases

| ID | สถานการณ์ | ผลที่คาดหวัง |
|---|---|---|
| EC-1 | AI Parsing Failure / Offline: แปลงค่าแคลอรี่ไม่สำเร็จหรืออินเทอร์เน็ตหลุด | ระบบเปลี่ยนเป็นฟอร์มให้กรอกแคลอรี่เองทันที และหากผู้ใช้ปล่อยว่างไว้ ระบบจะกำหนดค่า Default ที่ 300 kcal อัตโนมัติ |
| EC-2 | Rapid Sequential Logging: ผู้ใช้บันทึกเมนูใหม่ซ้อนกันภายใน 5 วินาที | Toast ข้อความเตือนเด้งสลับแสดงของเมนูใหม่ทันทีแบบ Queue Replace โดยไม่ค้างซ้อนกัน |
| EC-3 | Overeating Threshold Trigger: แคลอรี่รวมเกินเป้าหมาย > 100 kcal | หลอดพลังงานเปลี่ยนเป็นสีแดง สัตว์เลี้ยงเปลี่ยนเป็น "ท่าอิ่มพุงกาง" และทุกครั้งที่กดบันทึกเพิ่มจะแสดง "ท่าอิ่มพุงกางแต่ยังกิน" พร้อม Toast "พอเถอะน้าคนดี" ทุกครั้ง |
| EC-4 | Skipped Profile Layout: ผู้ใช้กดข้ามการกรอกโปรไฟล์สุขภาพ | แสดง CTA Banner ขนาดเท่า Widget เดิม ชวนกรอกโปรไฟล์แทนช่องหลอด % พลังงาน ป้องกัน Layout Shift สมบูรณ์ |
| EC-5 | Invalid Age Input: ผู้ใช้พยายามกรอกอายุเป็นทศนิยม (เช่น 20.5 ปี) | ระบบบล็อกการบันทึกและบังคับให้กรอกเป็นจำนวนเต็ม (Integer 1-120) เท่านั้น |

## 5. สิ่งที่ไม่ทำในรอบนี้ (Out of scope)
- การสแกนรูปภาพอาหารด้วย AI (Food Image Recognition / Camera Scan)
- การแยกสัดส่วนสารอาหารเชิงลึก (Carb / Protein / Fat breakdown)
- การตั้งค่าแจ้งเตือนเวลาทานอาหารอัตโนมัติ (Meal Reminder Push Notification)

## 6. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น)

| ข้อมูล | ชนิด/หน่วย | เก็บที่ไหน |
|---|---|---|
| `user_id` | String / UUID | Database (Users Table & History Schema) |
| `date` | Date (YYYY-MM-DD อ้างอิงรอบ 05:00 น.) | Database (Food History Schema) |
| `total_calories` | Integer (kcal) | Database (Food History Schema) |
| `is_over_target` | Boolean | Database (Food History Schema) |
| `age` | Integer (1 - 120 ปี) | Database (Users Profile) |
| `gender` | String (Male / Female) | Database (Users Profile) |
| `bmi` | Float | Calculated in App / Database |

## 7. คำถามที่ยังเปิดอยู่
- ทีม Design ต้องการใช้ Asset แอนิเมชันสัตว์เลี้ยงในรูปแบบ Lottie Files (.json) หรือ Sprite Sheets สำหรับการแสดงผล 4 ท่าทาง เพื่อให้ประสิทธิภาพการ Render บนมือถือดีที่สุด?

=== จบ docs/food/requirements.md ===

=== docs/food/ux-flow.md ===
# UX flow: บันทึกการให้อาหารสัตว์เลี้ยงและโภชนาการ (food)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Senior Team · อ้างอิง: requirements.md

## 1. รายการหน้าจอ

| ID | ชื่อหน้าจอ | จุดประสงค์ | อ้างถึง |
|---|---|---|---|
| S-1 | หน้าหลักแดชบอร์ดสัตว์เลี้ยงและโภชนาการ (Pet Dashboard & Food Tracker) | แสดงภาพสัตว์เลี้ยง หลอดพลังงานแคลอรี่ประจำวัน และทางเข้าสู่ฟังก์ชันบันทึกอาหาร | US-1, US-2, US-3, US-4, US-5, AC-8, AC-9, AC-10, AC-11 |
| S-2 | หน้าจอเพิ่มเมนูอาหาร (Add Meal Screen) | ให้ผู้ใช้พิมพ์ข้อความเมนูอาหารเพื่อส่งให้ AI ประมวลผล หรือกรอกแคลอรี่เองกรณีออฟไลน์/AI ล้มเหลว | US-1, AC-1, AC-2, EC-1 |
| S-3 | หน้าจอตั้งค่าโปรไฟล์สุขภาพเบื้องต้น (Profile Setup Screen) | ให้ผู้ใช้กรอกอายุ เพศ ส่วนสูง และน้ำหนัก เพื่อนำมาคำนวณเป้าหมายแคลอรี่รายบุคคล | US-2, AC-4, AC-5, AC-6, AC-7, EC-5 |

## 2. องค์ประกอบบนหน้าจอ

### S-1 หน้าหลักแดชบอร์ดสัตว์เลี้ยงและโภชนาการ (Pet Dashboard & Food Tracker)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| Pet Display Area | ส่วนแสดงผล Lottie Animation | แสดงท่าทางสัตว์เลี้ยงตามเงื่อนไขพลังงาน 4 ท่าทาง: `NORMAL` (ท่าหิว/ปกติ), `EATING` (ท่ากำลังกิน แสดงชั่วคราว 2 วินาทีขณะบันทึกสำเร็จ), `OVER_LIMIT` (ท่าอิ่มพุงกาง), `OVER_LIMIT_FEEDING` (ท่าอิ่มพุงกางแต่ยังกิน) | - |
| Energy Progress Bar / CTA Banner | แถบความคืบหน้า / แบนเนอร์ | กรณีมีโปรไฟล์: แสดงตัวเลข `[total_calories] / [target_calories] kcal`<br>กรณีข้ามโปรไฟล์: แสดง CTA Banner ข้อความ "ตั้งค่าโปรไฟล์สุขภาพเพื่อรับเป้าหมายแคลอรี่ที่แม่นยำ" | กรณีข้ามโปรไฟล์ กดที่ Banner จะพาไปหน้า S-3 |
| Toast Notification Area | กล่องข้อความลอย (Toast) | แสดงข้อความเตือน (เช่น "พอเถอะน้าคนดี") | ลอยเหนือตัวสัตว์เลี้ยง ห่างจากขอบบนสุดของ Asset สัตว์เลี้ยง 12px (ค้าง 5 วินาที หรือ Queue replace ทันทีเมื่อส่งซ้อน) |
| ปุ่มเพิ่มอาหาร (Add Food Button) | ปุ่มกด (Button) | "บันทึกมื้ออาหาร" | พาผู้ใช้ไปยังหน้า S-2 |

### S-2 หน้าจอเพิ่มเมนูอาหาร (Add Meal Screen)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| ปุ่มย้อนกลับ (Back Button) | ปุ่มไอคอน (Icon Button) | ไอคอนลูกศรย้อนกลับ | พาผู้ใช้กลับสู่หน้า S-1 |
| ช่องกรอกเมนูอาหาร (Food Input Field) | กล่องข้อความ (Text Area / Multiline) | Placeholder: "พิมพ์เมนูอาหารที่คุณทานวันนี้ เช่น ข้าวมันไก่ 1 จาน..." | รับข้อความเมนูอาหารจากผู้ใช้ |
| ฟอร์มกรอกแคลอรี่สำรอง (Fallback Manual Calorie Input) | ช่องกรอกตัวเลข (Number Input) | Placeholder: "ระบุแคลอรี่ (kcal)" (แสดงอัตโนมัติเฉพาะเมื่อเกิด AI Parsing Failure / Offline ตามเงื่อนไข EC-1) | รับค่าตัวเลขแคลอรี่ (Default: 300 kcal หากปล่อยว่าง) |
| ปุ่มส่งข้อมูล (Submit Button) | ปุ่มกด (หลัก) | "บันทึกข้อมูล" | ส่งข้อความไปยัง AI Parsing (หรือบันทึกค่า Manual หากออฟไลน์) แล้วกลับหน้า S-1 พร้อมสั่งเล่นแอนิเมชัน `EATING` ชั่วคราว |

### S-3 หน้าจอตั้งค่าโปรไฟล์สุขภาพเบื้องต้น (Profile Setup Screen)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| ช่องกรอกอายุ (Age Input) | ช่องกรอกตัวเลข (Number Input) | Placeholder: "ระบุอายุ (ปี)" | บล็อกและบังคับรับค่าเป็นจำนวนเต็ม (Integer) ช่วง 1 - 120 เท่านั้น (AC-4, EC-5) |
| ตัวเลือกเพศ (Gender Selector) | Radio Button / Choice Chip | ตัวเลือก: `MALE (ชาย)`, `FEMALE (หญิง)` | เลือกเพศเพื่อใช้คำนวณ Base Target ตามตาราง (AC-5) |
| ช่องกรอกน้ำหนัก (Weight Input) | ช่องกรอกตัวเลข (Number Input) | Placeholder: "น้ำหนัก (kg)" | รับค่าทศนิยมสำหรับคำนวณ BMI |
| ช่องกรอกส่วนสูง (Height Input) | ช่องกรอกตัวเลข (Number Input) | Placeholder: "ส่วนสูง (cm)" | รับค่าทศนิยมสำหรับคำนวณ BMI |
| ปุ่มข้าม (Skip Button) | ปุ่มข้อความ (Text Button) | "ข้ามไปก่อน" | บันทึกสถานะข้ามโปรไฟล์ และพาไปหน้า S-1 โดยแสดง CTA Banner แทนหลอดพลังงาน (US-3, AC-8, EC-4) |
| ปุ่มบันทึกโปรไฟล์ (Save Profile Button) | ปุ่มกด (หลัก) | "บันทึกและคำนวณเป้าหมาย" | บันทึกข้อมูล คำนวณ BMI และ Base Target พร้อมพาไปหน้า S-1 |

## 3. ขั้นตอนการใช้งาน (happy path)
1. **เปิดแอปพลิเคชัน:** ผู้ใช้เปิดแอป PetPal Health ระบบตรวจสอบช่วงเวลาปัจจุบัน (อ้างอิงรอบตัดวัน 05:00 น. ICT ตาม US-5 และ AC-3) และโหลดข้อมูลโภชนาการของรอบวันนั้น
2. **เข้าสู่หน้าบันทึกอาหาร:** ผู้ใช้กดปุ่ม "บันทึกมื้ออาหาร" ที่หน้า S-1 ระบบพาไปยังหน้า S-2 (หน้าจอเพิ่มเมนูอาหาร)
3. **ป้อนข้อมูลเมนูอาหาร:** ผู้ใช้พิมพ์ข้อความเมนูอาหาร (เช่น "ส้มตำปูปลาร้าและไก่ย่าง") ในช่องกรอก และกดปุ่ม "บันทึกข้อมูล"
4. **AI ประมวลผล:** ระบบส่งข้อความผ่าน AI Parsing คืนค่า JSON โภชนาการ (เช่น `{"calories": 400, "high_sodium": true, "high_sugar": false}`) ภายใน 3 วินาที (AC-1) หาก AI คืนค่าเป็นช่วงตัวเลข ระบบจะเลือกค่ากึ่งกลาง (Median) มาคำนวณอัตโนมัติ (AC-2)
5. **อัปเดตข้อมูลและแสดงผล:** ระบบบันทึก Log ลงฐานข้อมูลตามรอบวันที่ถูกต้อง (AC-3) กลับมาที่หน้า S-1 สัตว์เลี้ยงแสดง "ท่ากำลังกิน" (`EATING`) ชั่วคราว 2 วินาที ก่อนจะเปลี่ยนเป็นท่าตามระดับแคลอรี่สะสมจริง พร้อมอัปเดตหลอดพลังงาน %

## 4. สถานะของหน้าจอ

| หน้าจอ | สถานะ | เงื่อนไขที่ทำให้เกิด | สิ่งที่แสดง |
|---|---|---|---|
| S-1 | ปกติ (Normal) | ผู้ใช้มีโปรไฟล์สุขภาพ และแคลอรี่รวมยังไม่เกินเป้าหมาย หรือเกินเป้าหมายแต่น้อยกว่า/เท่ากับ 100 kcal (`total_calories <= target_calories + 100`) | แสดงหลอดพลังงานสีปกติ และสัตว์เลี้ยงอยู่ในท่าปกติ/ท่าหิว (`NORMAL`) (AC-9) |
| S-1 | กำลังกิน (Eating State) | ผู้ใช้กดบันทึกเมนูอาหารสำเร็จ | สัตว์เลี้ยงแสดง "ท่ากำลังกิน" (`EATING`) ชั่วคราว 2 วินาที ก่อนกลับสู่สถานะปกติหรืออิ่มพุงกาง |
| S-1 | ว่าง (Empty) | วันนี้ยังไม่มีการบันทึกประวัติอาหารใดๆ (ยอดสะสม 0 kcal) | หลอดพลังงานแสดง `0 / [target_calories] kcal` (0%) และสัตว์เลี้ยงอยู่ในท่าเริ่มต้น |
| S-1 | เกินเป้าหมาย (Overeating Limit) | แคลอรี่รวมเกินเป้าหมายมากกว่า 100 kcal (`total_calories > target_calories + 100`) | หลอดพลังงานเปลี่ยนเป็นสีแดง สัตว์เลี้ยงแสดง "ท่าอิ่มพุงกาง" (`OVER_LIMIT`) พร้อมข้อความ "อิ่มแล้ว" (AC-10) และแสดง Toast "พอเถอะน้าคนดี" ทุกครั้งที่กดบันทึกซ้ำ (AC-11, EC-3) |
| S-1 | ข้ามโปรไฟล์ (Skipped Profile) | ผู้ใช้กดข้ามการกรอกโปรไฟล์สุขภาพ (US-3) | แสดง CTA Banner ขนาดเท่า Widget หลอดพลังงานเดิม ชวนกรอกโปรไฟล์ โดยไม่มี Layout Shift (AC-8, EC-4) |
| S-2 | ปกติ (Normal) | หน้าจอพร้อมรับข้อความเมนูอาหาร | แสดงช่องกรอกข้อความเมนูอาหารและปุ่มส่งข้อมูล |
| S-2 | ผิดพลาด / ออฟไลน์ (Error / Offline) | เกิด AI Parsing Failure หรืออินเทอร์เน็ตหลุด (EC-1) | ระบบเปลี่ยนเป็นฟอร์มให้กรอกแคลอรี่เองทันที (`Fallback Manual Calorie Input`) |
| S-3 | ปกติ (Normal) | หน้าจอตั้งค่าโปรไฟล์สุขภาพ | แสดงฟอร์มกรอก อายุ (`AGE`), เพศ (`GENDER`), น้ำหนัก และส่วนสูงครบถ้วน |
| S-3 | ผิดพลาด (Error) | ผู้ใช้กรอกอายุเป็นทศนิยม (เช่น 20.5) (AC-4, EC-5) | ระบบบล็อกการบันทึกและแสดง Inline Error ใต้ช่องอายุ: "กรุณากรอกอายุเป็นจำนวนเต็มระหว่าง 1 - 120 ปี" |

## 5. ไฟล์ภาพ assets

| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายภาพ |
|---|---|---|
| `assets/images/pet/normal.json` | S-1 (สถานะปกติ/ท่าหิว) | Lottie Animation สัตว์เลี้ยงในท่าทางปกติ ร่าเริง |
| `assets/images/pet/eating.json` | S-1 (สถานะกำลังกิน) | Lottie Animation สัตว์เลี้ยงใน "ท่ากำลังกิน" แสดงชั่วคราว 2 วินาทีหลังบันทึกสำเร็จ |
| `assets/images/pet/over_limit.json` | S-1 (สถานะเกินเป้าหมาย > 100 kcal) | Lottie Animation สัตว์เลี้ยงใน "ท่าอิ่มพุงกาง" |
| `assets/images/pet/over_limit_feeding.json` | S-1 (สถานะกดบันทึกซ้ำขณะเกินเป้าหมาย) | Lottie Animation สัตว์เลี้ยงใน "ท่าอิ่มพุงกางแต่ยังกิน" |
| `assets/images/banner/profile_cta.png` | S-1 (สถานะข้ามโปรไฟล์) | CTA Banner ขนาดกว้าง x สูง เท่ากับ Widget หลอดพลังงานเดิม เพื่อป้องกัน Layout Shift |

## 6. คำถามถึง Product
- **ประเด็นรูปแบบ Asset แอนิเมชันสัตว์เลี้ยง (4 ท่าทาง):**
  - *ข้อเสนอแนะจาก Design:* เพื่อให้ประสิทธิภาพการ Render บนมือถือดีที่สุดและรองรับการเล่นแอนิเมชันต่อเนื่อง 4 ท่าทางได้อย่างลื่นไหล แนะนำให้ใช้รูปแบบ Lottie Files (`.json`) เป็นมาตรฐานหลักสำหรับ Asset แอนิเมชันสัตว์เลี้ยงทั้งหมด
  - *กติกาชั่วคราว (Fallback Rule):* หากระบบ Lottie มีปัญหาขัดข้องทางเทคนิค ให้ใช้ Sprite Sheets (.png) เป็นสำรองชั่วคราวโดยอ้างอิงขนาดมิติติดตั้งเดียวกัน
  - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่ (เนื่องจากมีกติกาสำรอง Lottie Files ชัดเจนและทีมสามารถดำเนินการต่อได้ทันที)
- **ประเด็นช่วงอายุ 1–9 ปีในตาราง Base Target:**
  - *ข้อเสนอแนะจาก Design:* ใน Requirements ตาราง Base Target เริ่มต้นที่ 10 ปี แต่เปิดรับอายุ 1–120 ปี ในมุมโภชนาการเบื้องต้น เสนอให้ใช้ค่าของกลุ่ม 10–12 ปี (ชาย 1,700 / หญิง 1,600 kcal) สำหรับช่วงอายุ 1–9 ปี
  - *กติกาชั่วคราว (Fallback Rule):* ให้ Dev กำหนด Base Target ของเด็กอายุ 1–9 ปี เท่ากับกลุ่ม 10–12 ปี ไปพลางก่อนเพื่อไม่ให้ระบบสะดุด
  - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่

=== จบ docs/food/ux-flow.md ===

=== docs/food/game-rules.md ===
# กติกาเกม: บันทึกการให้อาหารสัตว์เลี้ยงและโภชนาการ (food)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Senior Team · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ความหมาย | ค่า | หน่วย / ชนิด | อ้างถึง |
|---|---|---|---|---|
| `AI_PARSING_TIMEOUT` | ระยะเวลารอการประมวลผลของ AI | 3 | วินาที (Integer) | AC-1 |
| `DAILY_RESET_HOUR` | เวลาตัดรอบวันใหม่ในระบบ | 05:00 | น. ICT (String) | AC-3, US-5 |
| `AGE_MIN` | ค่าอายุต่ำสุดที่อนุญาต | 1 | ปี (Integer) | AC-4, EC-5 |
| `AGE_MAX` | ค่าอายุสูงสุดที่อนุญาต | 120 | ปี (Integer) | AC-4, EC-5 |
| `MALE_BASE_TARGET_10_12` | เป้าหมายแคลอรี่พื้นฐานชาย (10-12 ปี) | 1700 | kcal (Integer) | Base Target Table |
| `FEMALE_BASE_TARGET_10_12` | เป้าหมายแคลอรี่พื้นฐานหญิง (10-12 ปี) | 1600 | kcal (Integer) | Base Target Table |
| `MALE_BASE_TARGET_13_15` | เป้าหมายแคลอรี่พื้นฐานชาย (13-15 ปี) | 2100 | kcal (Integer) | Base Target Table |
| `FEMALE_BASE_TARGET_13_15` | เป้าหมายแคลอรี่พื้นฐานหญิง (13-15 ปี) | 1800 | kcal (Integer) | Base Target Table |
| `MALE_BASE_TARGET_16_18` | เป้าหมายแคลอรี่พื้นฐานชาย (16-18 ปี) | 2300 | kcal (Integer) | Base Target Table |
| `FEMALE_BASE_TARGET_16_18` | เป้าหมายแคลอรี่พื้นฐานหญิง (16-18 ปี) | 1850 | kcal (Integer) | Base Target Table |
| `MALE_BASE_TARGET_19_50` | เป้าหมายแคลอรี่พื้นฐานชาย (19-50 ปี) | 2000 | kcal (Integer) | Base Target Table |
| `FEMALE_BASE_TARGET_19_50` | เป้าหมายแคลอรี่พื้นฐานหญิง (19-50 ปี) | 1600 | kcal (Integer) | Base Target Table |
| `MALE_BASE_TARGET_51_UP` | เป้าหมายแคลอรี่พื้นฐานชาย (51 ปีขึ้นไป) | 1800 | kcal (Integer) | Base Target Table |
| `FEMALE_BASE_TARGET_51_UP` | เป้าหมายแคลอรี่พื้นฐานหญิง (51 ปีขึ้นไป) | 1400 | kcal (Integer) | Base Target Table |
| `FALLBACK_BASE_TARGET_AGE_1_9_MALE` | เป้าหมายแคลอรี่สำรองสำหรับเด็กชาย 1-9 ปี (อิงกลุ่ม 10-12) | 1700 | kcal (Integer) | ข้อเสนอแนะ Design |
| `FALLBACK_BASE_TARGET_AGE_1_9_FEMALE` | เป้าหมายแคลอรี่สำรองสำหรับเด็กหญิง 1-9 ปี (อิงกลุ่ม 10-12) | 1600 | kcal (Integer) | ข้อเสนอแนะ Design |
| `BMI_FORMULA` | สูตรคำนวณดัชนีมวลกาย | `weight_kg / ((height_cm / 100) ^ 2)` | สูตร (Float) | AC-6, AC-7 |
| `BMI_UNDERWEIGHT_THRESHOLD` | เกณฑ์ BMI ผอม (ต่ำกว่า) | 18.5 | BMI (Float 1 ตำแหน่ง) | AC-6 |
| `BMI_UNDERWEIGHT_BONUS` | ค่าแคลอรี่บวกเพิ่มกรณีผอม | 400 | kcal (Integer) | AC-6 |
| `BMI_OVERWEIGHT_THRESHOLD` | เกณฑ์ BMI อ้วน/น้ำหนักเกิน (ตั้งแต่) | 23.0 | BMI (Float 1 ตำแหน่ง) | AC-7 |
| `BMI_OVERWEIGHT_PENALTY` | ค่าแคลอรี่ที่ต้องหักออกกรณีน้ำหนักเกิน | 400 | kcal (Integer) | AC-7 |
| `OVER_LIMIT_THRESHOLD` | ส่วนเกินแคลอรี่ที่เริ่มเปลี่ยนสถานะสัตว์เลี้ยง | 100 | kcal (Integer) | AC-10, EC-3 |
| `FALLBACK_DEFAULT_CALORIES` | แคลอรี่เริ่มต้นกรณีออฟไลน์และไม่กรอกข้อมูล | 300 | kcal (Integer) | EC-1 |
| `EATING_ANIMATION_DURATION` | ระยะเวลาแสดงท่าทางกำลังกินชั่วคราว | 2 | วินาที (Integer) | Brief #3 |
| `TOAST_DURATION` | ระยะเวลาแสดง Toast Message | 5 | วินาที (Integer) | AC-12 |
| `TOAST_ANCHOR_OFFSET` | ระยะห่าง Toast จากขอบบนสุดของ Asset สัตว์เลี้ยง | 12 | px (Integer) | AC-12 |
| `HISTORY_RETENTION_DAYS` | จำนวนวันที่ระบบเก็บประวัติย้อนหลัง | 7 | วัน (Integer) | US-1, US-5 |

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง (Pet Animation 4 ท่าทาง)

| รหัสสถานะ (Code Enum) | ความหมาย | เงื่อนไขและช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพ (Asset) |
|---|---|---|---|
| `NORMAL` | ท่าหิว / ท่าปกติ | `total_calories <= target_calories + 100` (แคลอรี่ยังไม่เกินเป้าหมาย หรือเกินมาไม่เกิน 100 kcal) | `assets/images/pet/normal.json` |
| `EATING` | ท่ากำลังกิน | แสดงผลชั่วคราว 2 วินาที (`EATING_ANIMATION_DURATION`) หลังผู้ใช้กดปุ่มส่งเมนูอาหารสำเร็จ (Transient State) ก่อนกลับสู่สถานะสะสมจริง | `assets/images/pet/eating.json` |
| `OVER_LIMIT` | ท่าอิ่มพุงกาง | `total_calories > target_calories + 100` (แคลอรี่สะสมเกินเป้าหมายมากกว่า 100 kcal ขึ้นไป) หลอดเปลี่ยนเป็นสีแดง พร้อมแสดงข้อความ "อิ่มแล้ว" | `assets/images/pet/over_limit.json` |
| `OVER_LIMIT_FEEDING` | ท่าอิ่มพุงกางแต่ยังกิน | แสดงผลชั่วคราวเมื่อกดปุ่มบันทึกอาหารซ้ำขณะที่อยู่ในสถานะ `OVER_LIMIT` พร้อมแสดง Toast "พอเถอะน้าคนดี" | `assets/images/pet/over_limit_feeding.json` |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| ผู้ใช้กดส่งเมนูอาหารสำเร็จ | กำลังบันทึก | บันทึกสำเร็จ | สัตว์เลี้ยงแสดงท่า `EATING` ชั่วคราว 2 วินาที ก่อนคำนวณสถานะใหม่ตามระดับแคลอรี่จริง (Brief #3) |
| ผู้ชายอายุ 25 ปี (Base Target 2,000 kcal) ทานอาหารสะสม | 0 kcal | 1,900 kcal | หลอดพลังงานปกติ, สัตว์เลี้ยงท่า `NORMAL` (AC-5, AC-9) |
| ทานอาหารเพิ่มจนเกินเป้าหมายเล็กน้อย ($\le 100$ kcal) | 1,950 kcal (Target 2,000) | 2,050 kcal (เกิน 50 kcal) | หลอดพลังงานยังเป็นสีปกติ, สัตว์เลี้ยงท่า `NORMAL` (AC-9) |
| ทานอาหารเพิ่มจนเกินเป้าหมายมากกว่า 100 kcal | 2,000 kcal (Target 2,000) | 2,150 kcal (เกิน 150 kcal) | หลอดพลังงานเปลี่ยนเป็นสีแดง, สัตว์เลี้ยงท่า `OVER_LIMIT`, แสดงข้อความ "อิ่มแล้ว" (AC-10) |
| กดบันทึกซ้ำขณะที่อยู่ในสถานะเกินเป้าหมาย > 100 kcal | 2,150 kcal (Target 2,000) | 2,250 kcal | สัตว์เลี้ยงแสดงท่า `OVER_LIMIT_FEEDING` และแสดง Toast "พอเถอะน้าคนดี" (AC-11) |
| บันทึกอาหารตอน 03:00 น. ของวันที่ 15 | วันที่ 15 เวลา 03:00 น. | บันทึก Log ลงฐานข้อมูลเป็นวันที่ 14 | อ้างอิงรอบตัดวัน 05:00 น. (AC-3, US-5) |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ที่ทดสอบได้ |
|---|---|
| ค่าแคลอรี่เกินขอบบน (Overeating > 100 kcal) | หลอดพลังงานเปลี่ยนเป็นสีแดงทันที สัตว์เลี้ยงเปลี่ยนเป็นท่า `OVER_LIMIT` ("อิ่มพุงกาง") พร้อมแสดงข้อความ "อิ่มแล้ว" และทุกครั้งที่กดบันทึกเพิ่มจะแสดงท่า `OVER_LIMIT_FEEDING` พร้อมแสดง Toast ข้อความ "พอเถอะน้าคนดี" ซ้ำทุกครั้ง (AC-10, AC-11, EC-3) |
| AI Parsing คืนค่าเป็นช่วงตัวเลข (Range Values) | ระบบจะดึงค่ากึ่งกลาง (Median) ของช่วงตัวเลขนั้นมาคำนวณเป็น `total_calories` โดยอัตโนมัติทันที (AC-2) |
| AI Parsing Failure / Offline (เน็ตหลุดหรือประมวลผลไม่สำเร็จ) | ระบบสลับหน้าจอไปเป็นฟอร์มกรอกแคลอรี่เองทันที หากผู้ใช้ปล่อยช่องว่างไว้ ระบบจะกำหนดค่า `FALLBACK_DEFAULT_CALORIES` ที่ 300 kcal ให้อัตโนมัติ (EC-1) |
| Rapid Sequential Logging (ผู้ใช้กดบันทึกเมนูใหม่ซ้อนกันภายใน 5 วินาที) | Toast ข้อความเตือนจะเด้งสลับแสดงของเมนูใหม่ทันทีแบบ Queue Replace โดยไม่ค้างซ้อนกันหลายกล่อง (AC-12, EC-2) |
| ผู้ใช้กรอกอายุผิดพลาด (เช่น ใส่ทศนิยม 20.5 ปี หรือต่ำกว่า 1 หรือเกิน 120) | ระบบบล็อกการบันทึกทันที และบังคับให้กรอกเป็นจำนวนเต็ม (Integer) ระหว่าง 1 - 120 ปีเท่านั้น พร้อมแสดง Inline Error (AC-4, EC-5) |
| ผู้ใช้ข้ามการกรอกโปรไฟล์สุขภาพ (Skipped Profile) | หน้า S-1 จะแสดง CTA Banner (ขนาดกว้าง x สูง เท่ากับ Widget หลอดพลังงานเดิม) แทนหลอดพลังงาน % เพื่อป้องกันปัญหา Layout Shift และสามารถกดเพื่อกลับมาตั้งค่าโปรไฟล์ได้ (AC-8, EC-4) |
| Foreground Crossing ข้ามช่วงเวลาตัดรอบ (05:00 น.) | หากผู้ใช้เปิดแอปค้างไว้ผ่านเวลา 05:00 น. (ICT) ระบบจะทำการรีเซ็ตตัวนับประจำวันเป็น 0 kcal สำหรับรอบวันใหม่ทันที โดยข้อมูลประวัติสะสมวันก่อนหน้าจะถูกจัดเก็บลงในฐานข้อมูล 7 วันย้อนหลังอย่างถูกต้อง (US-5, AC-3) |

## 5. คำถามถึง Product
- **ประเด็นรูปแบบ Asset แอนิเมชันสัตว์เลี้ยง (4 ท่าทาง):**
  - *ข้อเสนอแนะจาก Design:* ทีมแนะนำให้ใช้ Lottie Files (`.json`) เป็นมาตรฐานสำหรับ Asset แอนิเมชันสัตว์เลี้ยงทั้ง 4 ท่าทาง เพื่อประสิทธิภาพการ Render สูงสุดบนมือถือ
  - *กติกาชั่วคราว (Fallback Rule):* หากไฟล์ Lottie มีปัญหาทางเทคนิค ให้ใช้ Sprite Sheets (.png) เป็นรูปแบบสำรองชั่วคราวโดยอ้างอิงมิติขนาดเท่ากัน
  - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่ (เนื่องจากมีกติกาสำรองที่ชัดเจนและทีมสามารถพัฒนาต่อได้ทันที)
- **ประเด็นช่วงอายุ 1–9 ปีในตาราง Base Target:**
  - *ข้อเสนอแนะจาก Design:* ใน Requirements ตาราง Base Target เริ่มต้นที่ 10 ปี แต่เปิดรับอายุ 1–120 ปี ในมุมโภชนาการเบื้องต้น เสนอให้ใช้ค่าของกลุ่ม 10–12 ปี (ชาย 1,700 / หญิง 1,600 kcal) สำหรับช่วงอายุ 1–9 ปี
  - *กติกาชั่วคราว (Fallback Rule):* ให้ Dev กำหนด Base Target ของเด็กอายุ 1–9 ปี เท่ากับกลุ่ม 10–12 ปี ไปพลางก่อนเพื่อไม่ให้ระบบสะดุด
  - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่

=== จบ docs/food/game-rules.md ===

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

expected_output: เนื้อหาไฟล์ docs/food/design-review.md ฉบับสมบูรณ์ ตามโครง template

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

# Design Review: food

## 1. ข้อมูลการตรวจ

- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: food
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
14. **Blocking Status Consistency:** When an issue is marked "ยังตัดสินไม่ได้" under the Blocking column, do not automatically classify it as a confirmed blocking issue in the summary. Evaluate it using the documented blocking criteria. If the available evidence cannot establish whether it blocks development, state that the blocking status is unresolved and explain what decision or evidence is needed. Keep the issue table, Open Questions section, and final summary consistent.
15. **Requirements Readiness Consistency:** Do not mark C-01 PASS solely because the Requirements document has a complete structure, User Stories, Acceptance Criteria, and Edge Cases. Also evaluate whether unresolved requirements or Open Questions prevent implementation. If they may affect implementation and remain undecided, explain the limitation and ensure the checklist result matches the documented review criteria.
16. **C-07 Final Cross-Check:** Before marking C-07 PASS, compare the final Review Status, checklist results, issue table, Open Questions section, blocking issue list, and recommendations. If any result contradicts another section, resolve the contradiction before finalizing. C-07 must not be PASS while material inconsistencies remain.
17. **Evidence-Based Issue Severity:** Distinguish between (a) a confirmed blocking issue, (b) an issue whose blocking status is unresolved, and (c) a non-blocking issue. Do not treat these categories as interchangeable. Explain the evidence and required decision for each unresolved issue.
18. **One Independent Decision per Issue:** Each independent Open Question or decision must have its own unique issue ID. Do not combine independent decisions into one issue merely because they appear in the same document or affect the same feature.
19. **Unique Issue ID Validation:** Before finalizing, verify that every issue ID is unique and consistently refers to the same problem in the issue table, Open Questions section, checklist evidence, and final summary. If two independent questions are listed, they must not share one ID.
20. **Blocking Status Must Match Everywhere:** For each issue, use the same blocking classification in the issue table, Open Questions section, and final summary. If the evidence does not establish whether an issue blocks development, explicitly label it as unresolved rather than claiming that it definitely blocks development. If it is confirmed to block a specific part of development, state that scope clearly and use the same classification throughout the report.
21. **C-07 Requires Unique IDs and Status Agreement:** C-07 must be FAIL whenever issue IDs are duplicated for independent problems, issue references point to different problems, or blocking classifications conflict between report sections. Change C-07 to PASS only after all such inconsistencies have been corrected.
22. **Final Issue Audit:** Before finalizing, count the independent problems in the issue table and compare them with the Open Questions section. Confirm that each independent problem has one unique ID, every reference points to the correct problem, and the summary includes all relevant issues without merging or omitting any.

## Final instruction

The purpose of this review is to give the human reviewer an accurate, traceable basis for deciding whether the feature is ready for Dev. Accuracy and evidence take priority over a positive status, short reports, or claiming that every check passed.

Never invent a decision, suppress an issue, combine independently resolvable decisions, or claim validation succeeded without checking the final report.
Your personal goal is: Review the food design documents against supplied project specifications, verify prior findings when available, and report evidence-backed contradictions, ambiguities, missing decisions, and actionable documentation issues without modifying source documents.

[user]

Current Task: ฟีเจอร์: food

งานของคุณ: ตรวจเอกสาร Requirements, UX Flow และ Game Rules ก่อนส่งงานให้ Dev ตรวจความครบถ้วนและความสอดคล้องของเอกสาร ตรวจตัวเลข ชื่อสถานะ ขั้นตอนการใช้งาน และ edge cases โดยอ้างอิงหลักฐานจากไฟล์ที่ได้รับ ระบุข้อผิดพลาดพร้อมไฟล์/หัวข้อ เหตุผล และแนวทางแก้ไข ห้ามแต่งข้อกำหนดหรือผลทดสอบขึ้นเอง สรุปผลเป็น PASS, NEEDS_FIX หรือ INSUFFICIENT_EVIDENCE

ข้อมูลประกอบ:
=== docs/food/requirements.md ===
# Requirements: บันทึกการให้อาหารสัตว์เลี้ยงและโภชนาการ (food)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Product agent · ผู้ตรวจ: Senior Team · อ้างอิง Issue: #101

## 1. สรุปฟีเจอร์
ฟีเจอร์บันทึกการให้อาหารสัตว์เลี้ยงช่วยให้ผู้ใช้สามารถบันทึกเมนูอาหารประจำวันได้อย่างรวดเร็วผ่านระบบ AI Parsing ที่ดึงข้อมูลโภชนาการอัตโนมัติ พร้อมระบบคำนวณเป้าหมายแคลอรี่รายบุคคลที่อ้างอิงตามช่วงอายุ เพศ และค่า BMI เพื่อขับเคลื่อนหลอดพลังงานและ Animation ของสัตว์เลี้ยง รวมถึงรองรับการจัดเก็บประวัติย้อนหลัง 7 วัน

## 2. User stories

| ID | ในฐานะ | ฉันอยาก | เพื่อ |
|---|---|---|---|
| US-1 | ผู้ใช้งานแอปพลิเคชัน | บันทึกเมนูอาหารที่ทานในแต่ละวันและให้ระบบประมวลผลแคลอรี่โดยอัตโนมัติ | สามารถติดตามพลังงานที่ได้รับในแต่ละวันได้อย่างสะดวกรวดเร็ว |
| US-2 | ผู้ใช้ที่มีการตั้งค่าข้อมูลส่วนตัว (อายุ เพศ และน้ำหนัก/ส่วนสูง) | ได้รับเป้าหมายแคลอรี่ประจำวันและสภาวะสัตว์เลี้ยงที่คำนวณจากข้อมูลสุขภาพจริง | สามารถดูแลโภชนาการให้สอดคล้องกับความต้องการของร่างกายตนเอง |
| US-3 | ผู้ใช้งานที่ข้ามการกรอกข้อมูลส่วนตัว | เห็น CTA Banner แทนที่หลอดพลังงาน % โดยไม่มีปัญหา Layout Shift | สามารถใช้งานแอปต่อได้และเข้าถึงปุ่มเชิญชวนกรอกโปรไฟล์ได้อย่างเหมาะสม |
| US-4 | ผู้ใช้งานที่บันทึกอาหารจนเกินเป้าหมาย | เห็นการเปลี่ยนแปลงสถานะของสัตว์เลี้ยงและหลอดพลังงานตามเงื่อนไขส่วนเกิน 100 kcal | ทราบระดับพลังงานส่วนเกินและรับคำเตือนที่เหมาะสม |
| US-5 | นักพัฒนาและระบบหลังบ้าน | จัดเก็บข้อมูลการบริโภคอาหารตามรอบตัดวัน 05:00 น. และรองรับโครงสร้างประวัติ 7 วัน | ข้อมูลสถิติย้อนหลังมีความถูกต้องและตรงรอบวันใช้งานจริง |

## 3. Acceptance criteria

| ID | อ้างถึง | เงื่อนไข (ก่อน /เมื่อ / แล้ว) | ค่าที่ทดสอบได้ |
|---|---|---|---|
| AC-1 | US-1 | ก่อน: อยู่หน้าบันทึกอาหาร / เมื่อ: ส่งข้อความเมนูอาหารผ่าน AI / แล้ว: ระบบคืนค่า JSON ของโภชนาการ | ผลลัพธ์เป็น JSON Format เช่น `{"calories": 400, "high_sodium": true, "high_sugar": false}` ภายใน 3 วินาที |
| AC-2 | US-1 | ก่อน: AI คืนค่าแคลอรี่เป็นช่วงตัวเลข / เมื่อ: ระบบทำการประมวลผล / แล้ว: เลือกค่าแคลอรี่มาใช้งาน | ระบบนำค่ากึ่งกลาง (Median) ของช่วงตัวเลขมาคำนวณโดยอัตโนมัติ |
| AC-3 | US-1, US-5 | ก่อน: เวลาปัจจุบันคือ 03:00 น. ของวันที่ 15 / เมื่อ: ผู้ใช้บันทึกอาหาร / แล้ว: ระบบบันทึก Log ลงฐานข้อมูล | ค่า `date` ในฐานข้อมูลถูกบันทึกเป็นรอบวันที่ 14 ตามรอบตัดวัน 05:00 น. (ICT) |
| AC-4 | US-2 | ก่อน: ผู้ใช้กรอกอายุ / เมื่อ: พยายามใส่ทศนิยม (เช่น 25.5) / แล้ว: ระบบปฏิเสธการบันทึก | ระบบบล็อกและบังคับให้รับค่าอายุเป็นจำนวนเต็ม (Integer) ช่วง 1 - 120 เท่านั้น |
| AC-5 | US-2 | ก่อน: ผู้ใช้เลือกเพศชาย อายุ 25 ปี / เมื่อ: ดึงค่า Base Target / แล้ว: แสดงผลเป้าหมายแคลอรี่พื้นฐาน | ระบบอ้างอิงจากตาราง Base Target Reference Table ได้ค่า 2,000 kcal |
| AC-6 | US-2 | ก่อน: ผู้ใช้มีค่า BMI < 18.5 (ผอม) / เมื่อ: คำนวณเป้าหมายแคลอรี่ / แล้ว: ปรับเพิ่มเป้าหมาย | ระบบบวกเพิ่ม +400 kcal จาก Base Target |
| AC-7 | US-2 | ก่อน: ผู้ใช้มีค่า BMI ≥ 23.0 (อ้วน/น้ำหนักเกิน) / เมื่อ: คำนวณเป้าหมายแคลอรี่ / แล้ว: ปรับลดเป้าหมาย | ระบบลบออก -400 kcal จาก Base Target |
| AC-8 | US-3 | ก่อน: ผู้ใช้กดข้ามการกรอกโปรไฟล์ / เมื่อ: เปิดหน้าจอหลัก / แล้ว: แสดง UI ทดแทน | แสดง Call-to-Action Banner ที่มีขนาดความกว้างและสูง (Dimension) เท่ากับ Widget หลอดพลังงานเดิม พร้อมยอดรวมแคลอรี่รายวัน โดยไม่มี Layout Shift |
| AC-9 | US-4 | ก่อน: แคลอรี่รวมเกินเป้าหมายแต่เกิน ≤ 100 kcal / เมื่อ: ตรวจสอบสถานะหลอดและสัตว์เลี้ยง / แล้ว: แสดงผลปกติ | หลอดพลังงานไม่เปลี่ยนเป็นสีแดง และสัตว์เลี้ยงอยู่ในท่าปกติ (ไม่แสดงท่าอิ่มเกิน) |
| AC-10 | US-4 | ก่อน: แคลอรี่รวมเกินเป้าหมาย > 100 kcal / เมื่อ: ตรวจสอบสถานะหลอดและสัตว์เลี้ยง / แล้ว: เปลี่ยนแปลงสถานะ | หลอดพลังงานเปลี่ยนเป็นสีแดง สัตว์เลี้ยงแสดง "ท่าอิ่มพุงกาง" และแสดงข้อความ "อิ่มแล้ว" |
| AC-11 | US-4 | ก่อน: อยู่ในสถานะเกินเป้าหมาย > 100 kcal / เมื่อ: กดปุ่มบันทึกอาหารเพิ่ม / แล้ว: แสดงอนิเมชั่นและข้อความเตือน | แสดง "ท่าอิ่มพุงกางแต่ยังกิน" พร้อม Toast ข้อความ "พอเถอะน้าคนดี" ทุกครั้งที่มีการกดบันทึกซ้ำ |
| AC-12 | US-4 | ก่อน: มีการแสดง Toast Message / เมื่อ: มีข้อความใหม่เข้ามาซ้อน / แล้ว: จัดการแสดงผล | แสดง Toast ลอยเหนือตัวสัตว์เลี้ยง โดยมีจุดอ้างอิง (Anchor) ห่างจากขอบบนสุดของ Asset สัตว์เลี้ยง 12px เสมอ และจำกัด 1 ข้อความต่อ 1 การบันทึก (ค้าง 5 วินาที หรือ Queue replace ทันทีเมื่อส่งซ้อน) |

### Base Target Reference Table
| ช่วงอายุ (ปี) | เพศชาย (Male Base Target) | เพศหญิง (Female Base Target) |
| :--- | :--- | :--- |
| **10 – 12 ปี** | 1,700 kcal | 1,600 kcal |
| **13 – 15 ปี (Growth Spurt)** | 2,100 kcal | 1,800 kcal |
| **16 – 18 ปี** | 2,300 kcal | 1,850 kcal |
| **19 – 50 ปี (ผู้ใหญ่)** | 2,000 kcal | 1,600 kcal |
| **51 ปีขึ้นไป** | 1,800 kcal | 1,400 kcal |

## 4. Edge cases

| ID | สถานการณ์ | ผลที่คาดหวัง |
|---|---|---|
| EC-1 | AI Parsing Failure / Offline: แปลงค่าแคลอรี่ไม่สำเร็จหรืออินเทอร์เน็ตหลุด | ระบบเปลี่ยนเป็นฟอร์มให้กรอกแคลอรี่เองทันที และหากผู้ใช้ปล่อยว่างไว้ ระบบจะกำหนดค่า Default ที่ 300 kcal อัตโนมัติ |
| EC-2 | Rapid Sequential Logging: ผู้ใช้บันทึกเมนูใหม่ซ้อนกันภายใน 5 วินาที | Toast ข้อความเตือนเด้งสลับแสดงของเมนูใหม่ทันทีแบบ Queue Replace โดยไม่ค้างซ้อนกัน |
| EC-3 | Overeating Threshold Trigger: แคลอรี่รวมเกินเป้าหมาย > 100 kcal | หลอดพลังงานเปลี่ยนเป็นสีแดง สัตว์เลี้ยงเปลี่ยนเป็น "ท่าอิ่มพุงกาง" และทุกครั้งที่กดบันทึกเพิ่มจะแสดง "ท่าอิ่มพุงกางแต่ยังกิน" พร้อม Toast "พอเถอะน้าคนดี" ทุกครั้ง |
| EC-4 | Skipped Profile Layout: ผู้ใช้กดข้ามการกรอกโปรไฟล์สุขภาพ | แสดง CTA Banner ขนาดเท่า Widget เดิม ชวนกรอกโปรไฟล์แทนช่องหลอด % พลังงาน ป้องกัน Layout Shift สมบูรณ์ |
| EC-5 | Invalid Age Input: ผู้ใช้พยายามกรอกอายุเป็นทศนิยม (เช่น 20.5 ปี) | ระบบบล็อกการบันทึกและบังคับให้กรอกเป็นจำนวนเต็ม (Integer 1-120) เท่านั้น |

## 5. สิ่งที่ไม่ทำในรอบนี้ (Out of scope)
- การสแกนรูปภาพอาหารด้วย AI (Food Image Recognition / Camera Scan)
- การแยกสัดส่วนสารอาหารเชิงลึก (Carb / Protein / Fat breakdown)
- การตั้งค่าแจ้งเตือนเวลาทานอาหารอัตโนมัติ (Meal Reminder Push Notification)

## 6. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น)

| ข้อมูล | ชนิด/หน่วย | เก็บที่ไหน |
|---|---|---|
| `user_id` | String / UUID | Database (Users Table & History Schema) |
| `date` | Date (YYYY-MM-DD อ้างอิงรอบ 05:00 น.) | Database (Food History Schema) |
| `total_calories` | Integer (kcal) | Database (Food History Schema) |
| `is_over_target` | Boolean | Database (Food History Schema) |
| `age` | Integer (1 - 120 ปี) | Database (Users Profile) |
| `gender` | String (Male / Female) | Database (Users Profile) |
| `bmi` | Float | Calculated in App / Database |

## 7. คำถามที่ยังเปิดอยู่
- ทีม Design ต้องการใช้ Asset แอนิเมชันสัตว์เลี้ยงในรูปแบบ Lottie Files (.json) หรือ Sprite Sheets สำหรับการแสดงผล 4 ท่าทาง เพื่อให้ประสิทธิภาพการ Render บนมือถือดีที่สุด?

=== จบ docs/food/requirements.md ===

=== docs/food/ux-flow.md ===
# UX flow: บันทึกการให้อาหารสัตว์เลี้ยงและโภชนาการ (food)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Senior Team · อ้างอิง: requirements.md

## 1. รายการหน้าจอ

| ID | ชื่อหน้าจอ | จุดประสงค์ | อ้างถึง |
|---|---|---|---|
| S-1 | หน้าหลักแดชบอร์ดสัตว์เลี้ยงและโภชนาการ (Pet Dashboard & Food Tracker) | แสดงภาพสัตว์เลี้ยง หลอดพลังงานแคลอรี่ประจำวัน และทางเข้าสู่ฟังก์ชันบันทึกอาหาร | US-1, US-2, US-3, US-4, US-5, AC-8, AC-9, AC-10, AC-11 |
| S-2 | หน้าจอเพิ่มเมนูอาหาร (Add Meal Screen) | ให้ผู้ใช้พิมพ์ข้อความเมนูอาหารเพื่อส่งให้ AI ประมวลผล หรือกรอกแคลอรี่เองกรณีออฟไลน์/AI ล้มเหลว | US-1, AC-1, AC-2, EC-1 |
| S-3 | หน้าจอตั้งค่าโปรไฟล์สุขภาพเบื้องต้น (Profile Setup Screen) | ให้ผู้ใช้กรอกอายุ เพศ ส่วนสูง และน้ำหนัก เพื่อนำมาคำนวณเป้าหมายแคลอรี่รายบุคคล | US-2, AC-4, AC-5, AC-6, AC-7, EC-5 |

## 2. องค์ประกอบบนหน้าจอ

### S-1 หน้าหลักแดชบอร์ดสัตว์เลี้ยงและโภชนาการ (Pet Dashboard & Food Tracker)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| Pet Display Area | ส่วนแสดงผล Lottie Animation | แสดงท่าทางสัตว์เลี้ยงตามเงื่อนไขพลังงาน 4 ท่าทาง: `NORMAL` (ท่าหิว/ปกติ), `EATING` (ท่ากำลังกิน แสดงชั่วคราว 2 วินาทีขณะบันทึกสำเร็จ), `OVER_LIMIT` (ท่าอิ่มพุงกาง), `OVER_LIMIT_FEEDING` (ท่าอิ่มพุงกางแต่ยังกิน) | - |
| Energy Progress Bar / CTA Banner | แถบความคืบหน้า / แบนเนอร์ | กรณีมีโปรไฟล์: แสดงตัวเลข `[total_calories] / [target_calories] kcal`<br>กรณีข้ามโปรไฟล์: แสดง CTA Banner ข้อความ "ตั้งค่าโปรไฟล์สุขภาพเพื่อรับเป้าหมายแคลอรี่ที่แม่นยำ" | กรณีข้ามโปรไฟล์ กดที่ Banner จะพาไปหน้า S-3 |
| Toast Notification Area | กล่องข้อความลอย (Toast) | แสดงข้อความเตือน (เช่น "พอเถอะน้าคนดี") | ลอยเหนือตัวสัตว์เลี้ยง ห่างจากขอบบนสุดของ Asset สัตว์เลี้ยง 12px (ค้าง 5 วินาที หรือ Queue replace ทันทีเมื่อส่งซ้อน) |
| ปุ่มเพิ่มอาหาร (Add Food Button) | ปุ่มกด (Button) | "บันทึกมื้ออาหาร" | พาผู้ใช้ไปยังหน้า S-2 |

### S-2 หน้าจอเพิ่มเมนูอาหาร (Add Meal Screen)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| ปุ่มย้อนกลับ (Back Button) | ปุ่มไอคอน (Icon Button) | ไอคอนลูกศรย้อนกลับ | พาผู้ใช้กลับสู่หน้า S-1 |
| ช่องกรอกเมนูอาหาร (Food Input Field) | กล่องข้อความ (Text Area / Multiline) | Placeholder: "พิมพ์เมนูอาหารที่คุณทานวันนี้ เช่น ข้าวมันไก่ 1 จาน..." | รับข้อความเมนูอาหารจากผู้ใช้ |
| ฟอร์มกรอกแคลอรี่สำรอง (Fallback Manual Calorie Input) | ช่องกรอกตัวเลข (Number Input) | Placeholder: "ระบุแคลอรี่ (kcal)" (แสดงอัตโนมัติเฉพาะเมื่อเกิด AI Parsing Failure / Offline ตามเงื่อนไข EC-1) | รับค่าตัวเลขแคลอรี่ (Default: 300 kcal หากปล่อยว่าง) |
| ปุ่มส่งข้อมูล (Submit Button) | ปุ่มกด (หลัก) | "บันทึกข้อมูล" | ส่งข้อความไปยัง AI Parsing (หรือบันทึกค่า Manual หากออฟไลน์) แล้วกลับหน้า S-1 พร้อมสั่งเล่นแอนิเมชัน `EATING` ชั่วคราว |

### S-3 หน้าจอตั้งค่าโปรไฟล์สุขภาพเบื้องต้น (Profile Setup Screen)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| ช่องกรอกอายุ (Age Input) | ช่องกรอกตัวเลข (Number Input) | Placeholder: "ระบุอายุ (ปี)" | บล็อกและบังคับรับค่าเป็นจำนวนเต็ม (Integer) ช่วง 1 - 120 เท่านั้น (AC-4, EC-5) |
| ตัวเลือกเพศ (Gender Selector) | Radio Button / Choice Chip | ตัวเลือก: `MALE (ชาย)`, `FEMALE (หญิง)` | เลือกเพศเพื่อใช้คำนวณ Base Target ตามตาราง (AC-5) |
| ช่องกรอกน้ำหนัก (Weight Input) | ช่องกรอกตัวเลข (Number Input) | Placeholder: "น้ำหนัก (kg)" | รับค่าทศนิยมสำหรับคำนวณ BMI |
| ช่องกรอกส่วนสูง (Height Input) | ช่องกรอกตัวเลข (Number Input) | Placeholder: "ส่วนสูง (cm)" | รับค่าทศนิยมสำหรับคำนวณ BMI |
| ปุ่มข้าม (Skip Button) | ปุ่มข้อความ (Text Button) | "ข้ามไปก่อน" | บันทึกสถานะข้ามโปรไฟล์ และพาไปหน้า S-1 โดยแสดง CTA Banner แทนหลอดพลังงาน (US-3, AC-8, EC-4) |
| ปุ่มบันทึกโปรไฟล์ (Save Profile Button) | ปุ่มกด (หลัก) | "บันทึกและคำนวณเป้าหมาย" | บันทึกข้อมูล คำนวณ BMI และ Base Target พร้อมพาไปหน้า S-1 |

## 3. ขั้นตอนการใช้งาน (happy path)
1. **เปิดแอปพลิเคชัน:** ผู้ใช้เปิดแอป PetPal Health ระบบตรวจสอบช่วงเวลาปัจจุบัน (อ้างอิงรอบตัดวัน 05:00 น. ICT ตาม US-5 และ AC-3) และโหลดข้อมูลโภชนาการของรอบวันนั้น
2. **เข้าสู่หน้าบันทึกอาหาร:** ผู้ใช้กดปุ่ม "บันทึกมื้ออาหาร" ที่หน้า S-1 ระบบพาไปยังหน้า S-2 (หน้าจอเพิ่มเมนูอาหาร)
3. **ป้อนข้อมูลเมนูอาหาร:** ผู้ใช้พิมพ์ข้อความเมนูอาหาร (เช่น "ส้มตำปูปลาร้าและไก่ย่าง") ในช่องกรอก และกดปุ่ม "บันทึกข้อมูล"
4. **AI ประมวลผล:** ระบบส่งข้อความผ่าน AI Parsing คืนค่า JSON โภชนาการ (เช่น `{"calories": 400, "high_sodium": true, "high_sugar": false}`) ภายใน 3 วินาที (AC-1) หาก AI คืนค่าเป็นช่วงตัวเลข ระบบจะเลือกค่ากึ่งกลาง (Median) มาคำนวณอัตโนมัติ (AC-2)
5. **อัปเดตข้อมูลและแสดงผล:** ระบบบันทึก Log ลงฐานข้อมูลตามรอบวันที่ถูกต้อง (AC-3) กลับมาที่หน้า S-1 สัตว์เลี้ยงแสดง "ท่ากำลังกิน" (`EATING`) ชั่วคราว 2 วินาที ก่อนจะเปลี่ยนเป็นท่าตามระดับแคลอรี่สะสมจริง พร้อมอัปเดตหลอดพลังงาน %

## 4. สถานะของหน้าจอ

| หน้าจอ | สถานะ | เงื่อนไขที่ทำให้เกิด | สิ่งที่แสดง |
|---|---|---|---|
| S-1 | ปกติ (Normal) | ผู้ใช้มีโปรไฟล์สุขภาพ และแคลอรี่รวมยังไม่เกินเป้าหมาย หรือเกินเป้าหมายแต่น้อยกว่า/เท่ากับ 100 kcal (`total_calories <= target_calories + 100`) | แสดงหลอดพลังงานสีปกติ และสัตว์เลี้ยงอยู่ในท่าปกติ/ท่าหิว (`NORMAL`) (AC-9) |
| S-1 | กำลังกิน (Eating State) | ผู้ใช้กดบันทึกเมนูอาหารสำเร็จ | สัตว์เลี้ยงแสดง "ท่ากำลังกิน" (`EATING`) ชั่วคราว 2 วินาที ก่อนกลับสู่สถานะปกติหรืออิ่มพุงกาง |
| S-1 | ว่าง (Empty) | วันนี้ยังไม่มีการบันทึกประวัติอาหารใดๆ (ยอดสะสม 0 kcal) | หลอดพลังงานแสดง `0 / [target_calories] kcal` (0%) และสัตว์เลี้ยงอยู่ในท่าเริ่มต้น |
| S-1 | เกินเป้าหมาย (Overeating Limit) | แคลอรี่รวมเกินเป้าหมายมากกว่า 100 kcal (`total_calories > target_calories + 100`) | หลอดพลังงานเปลี่ยนเป็นสีแดง สัตว์เลี้ยงแสดง "ท่าอิ่มพุงกาง" (`OVER_LIMIT`) พร้อมข้อความ "อิ่มแล้ว" (AC-10) และแสดง Toast "พอเถอะน้าคนดี" ทุกครั้งที่กดบันทึกซ้ำ (AC-11, EC-3) |
| S-1 | ข้ามโปรไฟล์ (Skipped Profile) | ผู้ใช้กดข้ามการกรอกโปรไฟล์สุขภาพ (US-3) | แสดง CTA Banner ขนาดเท่า Widget หลอดพลังงานเดิม ชวนกรอกโปรไฟล์ โดยไม่มี Layout Shift (AC-8, EC-4) |
| S-2 | ปกติ (Normal) | หน้าจอพร้อมรับข้อความเมนูอาหาร | แสดงช่องกรอกข้อความเมนูอาหารและปุ่มส่งข้อมูล |
| S-2 | ผิดพลาด / ออฟไลน์ (Error / Offline) | เกิด AI Parsing Failure หรืออินเทอร์เน็ตหลุด (EC-1) | ระบบเปลี่ยนเป็นฟอร์มให้กรอกแคลอรี่เองทันที (`Fallback Manual Calorie Input`) |
| S-3 | ปกติ (Normal) | หน้าจอตั้งค่าโปรไฟล์สุขภาพ | แสดงฟอร์มกรอก อายุ (`AGE`), เพศ (`GENDER`), น้ำหนัก และส่วนสูงครบถ้วน |
| S-3 | ผิดพลาด (Error) | ผู้ใช้กรอกอายุเป็นทศนิยม (เช่น 20.5) (AC-4, EC-5) | ระบบบล็อกการบันทึกและแสดง Inline Error ใต้ช่องอายุ: "กรุณากรอกอายุเป็นจำนวนเต็มระหว่าง 1 - 120 ปี" |

## 5. ไฟล์ภาพ assets

| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายภาพ |
|---|---|---|
| `assets/images/pet/normal.json` | S-1 (สถานะปกติ/ท่าหิว) | Lottie Animation สัตว์เลี้ยงในท่าทางปกติ ร่าเริง |
| `assets/images/pet/eating.json` | S-1 (สถานะกำลังกิน) | Lottie Animation สัตว์เลี้ยงใน "ท่ากำลังกิน" แสดงชั่วคราว 2 วินาทีหลังบันทึกสำเร็จ |
| `assets/images/pet/over_limit.json` | S-1 (สถานะเกินเป้าหมาย > 100 kcal) | Lottie Animation สัตว์เลี้ยงใน "ท่าอิ่มพุงกาง" |
| `assets/images/pet/over_limit_feeding.json` | S-1 (สถานะกดบันทึกซ้ำขณะเกินเป้าหมาย) | Lottie Animation สัตว์เลี้ยงใน "ท่าอิ่มพุงกางแต่ยังกิน" |
| `assets/images/banner/profile_cta.png` | S-1 (สถานะข้ามโปรไฟล์) | CTA Banner ขนาดกว้าง x สูง เท่ากับ Widget หลอดพลังงานเดิม เพื่อป้องกัน Layout Shift |

## 6. คำถามถึง Product
- **ประเด็นรูปแบบ Asset แอนิเมชันสัตว์เลี้ยง (4 ท่าทาง):**
  - *ข้อเสนอแนะจาก Design:* เพื่อให้ประสิทธิภาพการ Render บนมือถือดีที่สุดและรองรับการเล่นแอนิเมชันต่อเนื่อง 4 ท่าทางได้อย่างลื่นไหล แนะนำให้ใช้รูปแบบ Lottie Files (`.json`) เป็นมาตรฐานหลักสำหรับ Asset แอนิเมชันสัตว์เลี้ยงทั้งหมด
  - *กติกาชั่วคราว (Fallback Rule):* หากระบบ Lottie มีปัญหาขัดข้องทางเทคนิค ให้ใช้ Sprite Sheets (.png) เป็นสำรองชั่วคราวโดยอ้างอิงขนาดมิติติดตั้งเดียวกัน
  - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่ (เนื่องจากมีกติกาสำรอง Lottie Files ชัดเจนและทีมสามารถดำเนินการต่อได้ทันที)
- **ประเด็นช่วงอายุ 1–9 ปีในตาราง Base Target:**
  - *ข้อเสนอแนะจาก Design:* ใน Requirements ตาราง Base Target เริ่มต้นที่ 10 ปี แต่เปิดรับอายุ 1–120 ปี ในมุมโภชนาการเบื้องต้น เสนอให้ใช้ค่าของกลุ่ม 10–12 ปี (ชาย 1,700 / หญิง 1,600 kcal) สำหรับช่วงอายุ 1–9 ปี
  - *กติกาชั่วคราว (Fallback Rule):* ให้ Dev กำหนด Base Target ของเด็กอายุ 1–9 ปี เท่ากับกลุ่ม 10–12 ปี ไปพลางก่อนเพื่อไม่ให้ระบบสะดุด
  - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่

=== จบ docs/food/ux-flow.md ===

=== docs/food/game-rules.md ===
# กติกาเกม: บันทึกการให้อาหารสัตว์เลี้ยงและโภชนาการ (food)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Senior Team · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ความหมาย | ค่า | หน่วย / ชนิด | อ้างถึง |
|---|---|---|---|---|
| `AI_PARSING_TIMEOUT` | ระยะเวลารอการประมวลผลของ AI | 3 | วินาที (Integer) | AC-1 |
| `DAILY_RESET_HOUR` | เวลาตัดรอบวันใหม่ในระบบ | 05:00 | น. ICT (String) | AC-3, US-5 |
| `AGE_MIN` | ค่าอายุต่ำสุดที่อนุญาต | 1 | ปี (Integer) | AC-4, EC-5 |
| `AGE_MAX` | ค่าอายุสูงสุดที่อนุญาต | 120 | ปี (Integer) | AC-4, EC-5 |
| `MALE_BASE_TARGET_10_12` | เป้าหมายแคลอรี่พื้นฐานชาย (10-12 ปี) | 1700 | kcal (Integer) | Base Target Table |
| `FEMALE_BASE_TARGET_10_12` | เป้าหมายแคลอรี่พื้นฐานหญิง (10-12 ปี) | 1600 | kcal (Integer) | Base Target Table |
| `MALE_BASE_TARGET_13_15` | เป้าหมายแคลอรี่พื้นฐานชาย (13-15 ปี) | 2100 | kcal (Integer) | Base Target Table |
| `FEMALE_BASE_TARGET_13_15` | เป้าหมายแคลอรี่พื้นฐานหญิง (13-15 ปี) | 1800 | kcal (Integer) | Base Target Table |
| `MALE_BASE_TARGET_16_18` | เป้าหมายแคลอรี่พื้นฐานชาย (16-18 ปี) | 2300 | kcal (Integer) | Base Target Table |
| `FEMALE_BASE_TARGET_16_18` | เป้าหมายแคลอรี่พื้นฐานหญิง (16-18 ปี) | 1850 | kcal (Integer) | Base Target Table |
| `MALE_BASE_TARGET_19_50` | เป้าหมายแคลอรี่พื้นฐานชาย (19-50 ปี) | 2000 | kcal (Integer) | Base Target Table |
| `FEMALE_BASE_TARGET_19_50` | เป้าหมายแคลอรี่พื้นฐานหญิง (19-50 ปี) | 1600 | kcal (Integer) | Base Target Table |
| `MALE_BASE_TARGET_51_UP` | เป้าหมายแคลอรี่พื้นฐานชาย (51 ปีขึ้นไป) | 1800 | kcal (Integer) | Base Target Table |
| `FEMALE_BASE_TARGET_51_UP` | เป้าหมายแคลอรี่พื้นฐานหญิง (51 ปีขึ้นไป) | 1400 | kcal (Integer) | Base Target Table |
| `FALLBACK_BASE_TARGET_AGE_1_9_MALE` | เป้าหมายแคลอรี่สำรองสำหรับเด็กชาย 1-9 ปี (อิงกลุ่ม 10-12) | 1700 | kcal (Integer) | ข้อเสนอแนะ Design |
| `FALLBACK_BASE_TARGET_AGE_1_9_FEMALE` | เป้าหมายแคลอรี่สำรองสำหรับเด็กหญิง 1-9 ปี (อิงกลุ่ม 10-12) | 1600 | kcal (Integer) | ข้อเสนอแนะ Design |
| `BMI_FORMULA` | สูตรคำนวณดัชนีมวลกาย | `weight_kg / ((height_cm / 100) ^ 2)` | สูตร (Float) | AC-6, AC-7 |
| `BMI_UNDERWEIGHT_THRESHOLD` | เกณฑ์ BMI ผอม (ต่ำกว่า) | 18.5 | BMI (Float 1 ตำแหน่ง) | AC-6 |
| `BMI_UNDERWEIGHT_BONUS` | ค่าแคลอรี่บวกเพิ่มกรณีผอม | 400 | kcal (Integer) | AC-6 |
| `BMI_OVERWEIGHT_THRESHOLD` | เกณฑ์ BMI อ้วน/น้ำหนักเกิน (ตั้งแต่) | 23.0 | BMI (Float 1 ตำแหน่ง) | AC-7 |
| `BMI_OVERWEIGHT_PENALTY` | ค่าแคลอรี่ที่ต้องหักออกกรณีน้ำหนักเกิน | 400 | kcal (Integer) | AC-7 |
| `OVER_LIMIT_THRESHOLD` | ส่วนเกินแคลอรี่ที่เริ่มเปลี่ยนสถานะสัตว์เลี้ยง | 100 | kcal (Integer) | AC-10, EC-3 |
| `FALLBACK_DEFAULT_CALORIES` | แคลอรี่เริ่มต้นกรณีออฟไลน์และไม่กรอกข้อมูล | 300 | kcal (Integer) | EC-1 |
| `EATING_ANIMATION_DURATION` | ระยะเวลาแสดงท่าทางกำลังกินชั่วคราว | 2 | วินาที (Integer) | Brief #3 |
| `TOAST_DURATION` | ระยะเวลาแสดง Toast Message | 5 | วินาที (Integer) | AC-12 |
| `TOAST_ANCHOR_OFFSET` | ระยะห่าง Toast จากขอบบนสุดของ Asset สัตว์เลี้ยง | 12 | px (Integer) | AC-12 |
| `HISTORY_RETENTION_DAYS` | จำนวนวันที่ระบบเก็บประวัติย้อนหลัง | 7 | วัน (Integer) | US-1, US-5 |

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง (Pet Animation 4 ท่าทาง)

| รหัสสถานะ (Code Enum) | ความหมาย | เงื่อนไขและช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพ (Asset) |
|---|---|---|---|
| `NORMAL` | ท่าหิว / ท่าปกติ | `total_calories <= target_calories + 100` (แคลอรี่ยังไม่เกินเป้าหมาย หรือเกินมาไม่เกิน 100 kcal) | `assets/images/pet/normal.json` |
| `EATING` | ท่ากำลังกิน | แสดงผลชั่วคราว 2 วินาที (`EATING_ANIMATION_DURATION`) หลังผู้ใช้กดปุ่มส่งเมนูอาหารสำเร็จ (Transient State) ก่อนกลับสู่สถานะสะสมจริง | `assets/images/pet/eating.json` |
| `OVER_LIMIT` | ท่าอิ่มพุงกาง | `total_calories > target_calories + 100` (แคลอรี่สะสมเกินเป้าหมายมากกว่า 100 kcal ขึ้นไป) หลอดเปลี่ยนเป็นสีแดง พร้อมแสดงข้อความ "อิ่มแล้ว" | `assets/images/pet/over_limit.json` |
| `OVER_LIMIT_FEEDING` | ท่าอิ่มพุงกางแต่ยังกิน | แสดงผลชั่วคราวเมื่อกดปุ่มบันทึกอาหารซ้ำขณะที่อยู่ในสถานะ `OVER_LIMIT` พร้อมแสดง Toast "พอเถอะน้าคนดี" | `assets/images/pet/over_limit_feeding.json` |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| ผู้ใช้กดส่งเมนูอาหารสำเร็จ | กำลังบันทึก | บันทึกสำเร็จ | สัตว์เลี้ยงแสดงท่า `EATING` ชั่วคราว 2 วินาที ก่อนคำนวณสถานะใหม่ตามระดับแคลอรี่จริง (Brief #3) |
| ผู้ชายอายุ 25 ปี (Base Target 2,000 kcal) ทานอาหารสะสม | 0 kcal | 1,900 kcal | หลอดพลังงานปกติ, สัตว์เลี้ยงท่า `NORMAL` (AC-5, AC-9) |
| ทานอาหารเพิ่มจนเกินเป้าหมายเล็กน้อย ($\le 100$ kcal) | 1,950 kcal (Target 2,000) | 2,050 kcal (เกิน 50 kcal) | หลอดพลังงานยังเป็นสีปกติ, สัตว์เลี้ยงท่า `NORMAL` (AC-9) |
| ทานอาหารเพิ่มจนเกินเป้าหมายมากกว่า 100 kcal | 2,000 kcal (Target 2,000) | 2,150 kcal (เกิน 150 kcal) | หลอดพลังงานเปลี่ยนเป็นสีแดง, สัตว์เลี้ยงท่า `OVER_LIMIT`, แสดงข้อความ "อิ่มแล้ว" (AC-10) |
| กดบันทึกซ้ำขณะที่อยู่ในสถานะเกินเป้าหมาย > 100 kcal | 2,150 kcal (Target 2,000) | 2,250 kcal | สัตว์เลี้ยงแสดงท่า `OVER_LIMIT_FEEDING` และแสดง Toast "พอเถอะน้าคนดี" (AC-11) |
| บันทึกอาหารตอน 03:00 น. ของวันที่ 15 | วันที่ 15 เวลา 03:00 น. | บันทึก Log ลงฐานข้อมูลเป็นวันที่ 14 | อ้างอิงรอบตัดวัน 05:00 น. (AC-3, US-5) |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ที่ทดสอบได้ |
|---|---|
| ค่าแคลอรี่เกินขอบบน (Overeating > 100 kcal) | หลอดพลังงานเปลี่ยนเป็นสีแดงทันที สัตว์เลี้ยงเปลี่ยนเป็นท่า `OVER_LIMIT` ("อิ่มพุงกาง") พร้อมแสดงข้อความ "อิ่มแล้ว" และทุกครั้งที่กดบันทึกเพิ่มจะแสดงท่า `OVER_LIMIT_FEEDING` พร้อมแสดง Toast ข้อความ "พอเถอะน้าคนดี" ซ้ำทุกครั้ง (AC-10, AC-11, EC-3) |
| AI Parsing คืนค่าเป็นช่วงตัวเลข (Range Values) | ระบบจะดึงค่ากึ่งกลาง (Median) ของช่วงตัวเลขนั้นมาคำนวณเป็น `total_calories` โดยอัตโนมัติทันที (AC-2) |
| AI Parsing Failure / Offline (เน็ตหลุดหรือประมวลผลไม่สำเร็จ) | ระบบสลับหน้าจอไปเป็นฟอร์มกรอกแคลอรี่เองทันที หากผู้ใช้ปล่อยช่องว่างไว้ ระบบจะกำหนดค่า `FALLBACK_DEFAULT_CALORIES` ที่ 300 kcal ให้อัตโนมัติ (EC-1) |
| Rapid Sequential Logging (ผู้ใช้กดบันทึกเมนูใหม่ซ้อนกันภายใน 5 วินาที) | Toast ข้อความเตือนจะเด้งสลับแสดงของเมนูใหม่ทันทีแบบ Queue Replace โดยไม่ค้างซ้อนกันหลายกล่อง (AC-12, EC-2) |
| ผู้ใช้กรอกอายุผิดพลาด (เช่น ใส่ทศนิยม 20.5 ปี หรือต่ำกว่า 1 หรือเกิน 120) | ระบบบล็อกการบันทึกทันที และบังคับให้กรอกเป็นจำนวนเต็ม (Integer) ระหว่าง 1 - 120 ปีเท่านั้น พร้อมแสดง Inline Error (AC-4, EC-5) |
| ผู้ใช้ข้ามการกรอกโปรไฟล์สุขภาพ (Skipped Profile) | หน้า S-1 จะแสดง CTA Banner (ขนาดกว้าง x สูง เท่ากับ Widget หลอดพลังงานเดิม) แทนหลอดพลังงาน % เพื่อป้องกันปัญหา Layout Shift และสามารถกดเพื่อกลับมาตั้งค่าโปรไฟล์ได้ (AC-8, EC-4) |
| Foreground Crossing ข้ามช่วงเวลาตัดรอบ (05:00 น.) | หากผู้ใช้เปิดแอปค้างไว้ผ่านเวลา 05:00 น. (ICT) ระบบจะทำการรีเซ็ตตัวนับประจำวันเป็น 0 kcal สำหรับรอบวันใหม่ทันที โดยข้อมูลประวัติสะสมวันก่อนหน้าจะถูกจัดเก็บลงในฐานข้อมูล 7 วันย้อนหลังอย่างถูกต้อง (US-5, AC-3) |

## 5. คำถามถึง Product
- **ประเด็นรูปแบบ Asset แอนิเมชันสัตว์เลี้ยง (4 ท่าทาง):**
  - *ข้อเสนอแนะจาก Design:* ทีมแนะนำให้ใช้ Lottie Files (`.json`) เป็นมาตรฐานสำหรับ Asset แอนิเมชันสัตว์เลี้ยงทั้ง 4 ท่าทาง เพื่อประสิทธิภาพการ Render สูงสุดบนมือถือ
  - *กติกาชั่วคราว (Fallback Rule):* หากไฟล์ Lottie มีปัญหาทางเทคนิค ให้ใช้ Sprite Sheets (.png) เป็นรูปแบบสำรองชั่วคราวโดยอ้างอิงมิติขนาดเท่ากัน
  - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่ (เนื่องจากมีกติกาสำรองที่ชัดเจนและทีมสามารถพัฒนาต่อได้ทันที)
- **ประเด็นช่วงอายุ 1–9 ปีในตาราง Base Target:**
  - *ข้อเสนอแนะจาก Design:* ใน Requirements ตาราง Base Target เริ่มต้นที่ 10 ปี แต่เปิดรับอายุ 1–120 ปี ในมุมโภชนาการเบื้องต้น เสนอให้ใช้ค่าของกลุ่ม 10–12 ปี (ชาย 1,700 / หญิง 1,600 kcal) สำหรับช่วงอายุ 1–9 ปี
  - *กติกาชั่วคราว (Fallback Rule):* ให้ Dev กำหนด Base Target ของเด็กอายุ 1–9 ปี เท่ากับกลุ่ม 10–12 ปี ไปพลางก่อนเพื่อไม่ให้ระบบสะดุด
  - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่

=== จบ docs/food/game-rules.md ===

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

This is the expected criteria for your final answer: เนื้อหาไฟล์ docs/food/design-review.md ฉบับสมบูรณ์ ตามโครง template
you MUST return the actual complete content as the final answer, not a summary.

Provide your complete response:
~~~~

### LLM call 1 — คำตอบ

~~~~text
# Design Review: food

## 1. ข้อมูลการตรวจ
- Status: NEEDS_FIX
- Feature: food
- Documents actually reviewed: docs/food/requirements.md, docs/food/ux-flow.md, docs/food/game-rules.md
- Missing/unreadable documents: ไม่มี
- Previous findings checked: ไม่มีข้อมูลรอบก่อน

## 2. ผล Checklist
ทุกข้อมีผล เหตุผล และหลักฐานจากไฟล์/หัวข้อที่ตรวจจริง หากข้อมูลไม่พอให้ใช้ INSUFFICIENT_EVIDENCE ห้ามเดา

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | PASS | เอกสาร requirements.md มี User stories, Acceptance criteria, Edge cases และ Base Target Table ครบถ้วน | ไม่ใช่ |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | PASS | ข้อมูลหลักฐานระหว่าง requirements.md, ux-flow.md และ game-rules.md สอดคล้องกัน | ไม่ใช่ |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | PASS | ชื่อสถานะ (Code Enum) เช่น NORMAL, EATING, OVER_LIMIT, OVER_LIMIT_FEEDING ตัวเลขแคลอรี่ และรอบตัดวัน 05:00 น. ตรงกันทุกไฟล์ | ไม่ใช่ |
| C-04 | ขั้นตอนใช้งานและEdge Cases เพียงพอ | PASS | ux-flow.md ระบุขั้นตอน Happy path และ requirements.md/game-rules.md ระบุ Edge cases เช่น AI Parsing Failure, Rapid Sequential Logging ครบถ้วน | ไม่ใช่ |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | PASS | ทุก Open Question ในเอกสาร UX Flow และ Game Rules ระบุสถานะ "Blocking: ไม่ใช่" และมีกติกาสำรอง (Fallback Rule) ชัดเจน | ไม่ใช่ |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ข้อค้นพบและตารางข้อมูลอ้างอิงโยงกลับไปยัง AC, US และ EC ในเอกสาร requirements.md ได้ทั้งหมด | ไม่ใช่ |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกับผลการตรวจเอกสารและไม่มีความขัดแย้ง | ไม่ใช่ |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีข้อมูลรายงานการรีวิวกรอบก่อนสำหรับการเปรียบเทียบ regression | ไม่ใช่ (ไม่มีข้อมูลรอบก่อน) |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|
| OQ-1 | docs/food/requirements.md | 7. คำถามที่ยังเปิดอยู่ | Open Question เรื่องรูปแบบ Asset แอนิเมชันสัตว์เลี้ยง (Lottie Files vs Sprite Sheets) ยังคงค้างอยู่ใน Requirements โดยไม่มีข้อสรุปในตัว Requirements เอง แม้ ux-flow.md และ game-rules.md จะระบุวิธีสำรองแล้วก็ตาม | ความไม่สอดคล้องของการจัดการคำถามที่เปิดอยู่ระหว่างเอกสาร requirements.md และเอกสารอื่นๆ | ไม่ใช่ | อัปเดตข้อสรุปใน docs/food/requirements.md ให้ตรงกับ ux-flow.md และ game-rules.md โดยระบุแนวทางสำรอง (Sprite Sheets) ให้ชัดเจน | ใช่ (เพื่อความสมบูรณ์ของเอกสาร Requirements) |

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|
| - | - | ยังยืนยันไม่ได้ | ไม่มีข้อมูลสำหรับเปรียบเทียบ เนื่องจากเป็นรอบการตรวจแรก (No previous review data available) | ระบุว่าไม่มีข้อมูลรอบก่อนในรายงาน |

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- **OQ-1**: docs/food/requirements.md (หัวข้อ 7. คำถามที่ยังเปิดอยู่) - เรื่องรูปแบบ Asset แอนิเมชันสัตว์เลี้ยง (Lottie Files .json หรือ Sprite Sheets) - เอกสาร requirements.md ยังเปิดคำถามไว้โดยไม่มีบทสรุป แม้เอกสาร ux-flow.md และ game-rules.md จะกำหนด Fallback Rule ไว้แล้วก็ตาม - ไม่บล็อกการพัฒนาเนื่องจากมีกติกาสำรอง (Fallback Rule: ใช้ Sprite Sheets .png หาก Lottie มีปัญหา) ชัดเจนในเอกสารอื่น - ต้องให้ Product Owner หรือ Design Team ยืนยันการปิดประเด็นใน requirements.md ให้ตรงกัน

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|
| ไม่มีข้อมูล | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่ต้องแก้มือ เนื่องจากไม่มีการเรียกตรวจ log |

## 7. ข้อจำกัดของการรีวิว
- เอกสารที่ตรวจจริง: docs/food/requirements.md, docs/food/ux-flow.md, docs/food/game-rules.md
- ไฟล์ที่ไม่ได้ตรวจ: ไม่มี (ตรวจครบทุกไฟล์ที่ได้รับ) และไม่มีรายงานการรีวิวกรอบก่อน (Previous review report) ทำให้ไม่สามารถทำ Regression comparison ได้

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: NEEDS_FIX
- Agent recommendation: ต้องแก้
- Blocking issues remaining: ไม่มีปัญหาที่เป็น Blocking (OQ-1 มีสถานะ Blocking: ไม่ใช่ ตามเอกสาร Design และมีกติกาสำรองรองรับ) แต่ยังมีประเด็นเอกสาร requirements.md ที่ต้องปรับแก้ให้สอดคล้องกับ ux-flow.md และ game-rules.md
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: เอกสารมีความครบถ้วนและสอดคล้องกันในระดับสูง แต่พบ Open Question ที่ยังเปิดค้างอยู่ใน requirements.md ซึ่งจำเป็นต้องได้รับการอัปเดตให้ตรงกับกติกาสำรองที่ระบุไว้ใน ux-flow.md และ game-rules.md ก่อนส่งมอบให้ทีม Dev ป้องกันความสับสนในการทำงาน
~~~~

### ผลลัพธ์ → docs/food/design-review.md

~~~~text
# Design Review: food

## 1. ข้อมูลการตรวจ
- Status: NEEDS_FIX
- Feature: food
- Documents actually reviewed: docs/food/requirements.md, docs/food/ux-flow.md, docs/food/game-rules.md
- Missing/unreadable documents: ไม่มี
- Previous findings checked: ไม่มีข้อมูลรอบก่อน

## 2. ผล Checklist
ทุกข้อมีผล เหตุผล และหลักฐานจากไฟล์/หัวข้อที่ตรวจจริง หากข้อมูลไม่พอให้ใช้ INSUFFICIENT_EVIDENCE ห้ามเดา

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | PASS | เอกสาร requirements.md มี User stories, Acceptance criteria, Edge cases และ Base Target Table ครบถ้วน | ไม่ใช่ |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | PASS | ข้อมูลหลักฐานระหว่าง requirements.md, ux-flow.md และ game-rules.md สอดคล้องกัน | ไม่ใช่ |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | PASS | ชื่อสถานะ (Code Enum) เช่น NORMAL, EATING, OVER_LIMIT, OVER_LIMIT_FEEDING ตัวเลขแคลอรี่ และรอบตัดวัน 05:00 น. ตรงกันทุกไฟล์ | ไม่ใช่ |
| C-04 | ขั้นตอนใช้งานและEdge Cases เพียงพอ | PASS | ux-flow.md ระบุขั้นตอน Happy path และ requirements.md/game-rules.md ระบุ Edge cases เช่น AI Parsing Failure, Rapid Sequential Logging ครบถ้วน | ไม่ใช่ |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | PASS | ทุก Open Question ในเอกสาร UX Flow และ Game Rules ระบุสถานะ "Blocking: ไม่ใช่" และมีกติกาสำรอง (Fallback Rule) ชัดเจน | ไม่ใช่ |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ข้อค้นพบและตารางข้อมูลอ้างอิงโยงกลับไปยัง AC, US และ EC ในเอกสาร requirements.md ได้ทั้งหมด | ไม่ใช่ |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกับผลการตรวจเอกสารและไม่มีความขัดแย้ง | ไม่ใช่ |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีข้อมูลรายงานการรีวิวกรอบก่อนสำหรับการเปรียบเทียบ regression | ไม่ใช่ (ไม่มีข้อมูลรอบก่อน) |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|
| OQ-1 | docs/food/requirements.md | 7. คำถามที่ยังเปิดอยู่ | Open Question เรื่องรูปแบบ Asset แอนิเมชันสัตว์เลี้ยง (Lottie Files vs Sprite Sheets) ยังคงค้างอยู่ใน Requirements โดยไม่มีข้อสรุปในตัว Requirements เอง แม้ ux-flow.md และ game-rules.md จะระบุวิธีสำรองแล้วก็ตาม | ความไม่สอดคล้องของการจัดการคำถามที่เปิดอยู่ระหว่างเอกสาร requirements.md และเอกสารอื่นๆ | ไม่ใช่ | อัปเดตข้อสรุปใน docs/food/requirements.md ให้ตรงกับ ux-flow.md และ game-rules.md โดยระบุแนวทางสำรอง (Sprite Sheets) ให้ชัดเจน | ใช่ (เพื่อความสมบูรณ์ของเอกสาร Requirements) |

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|
| - | - | ยังยืนยันไม่ได้ | ไม่มีข้อมูลสำหรับเปรียบเทียบ เนื่องจากเป็นรอบการตรวจแรก (No previous review data available) | ระบุว่าไม่มีข้อมูลรอบก่อนในรายงาน |

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- **OQ-1**: docs/food/requirements.md (หัวข้อ 7. คำถามที่ยังเปิดอยู่) - เรื่องรูปแบบ Asset แอนิเมชันสัตว์เลี้ยง (Lottie Files .json หรือ Sprite Sheets) - เอกสาร requirements.md ยังเปิดคำถามไว้โดยไม่มีบทสรุป แม้เอกสาร ux-flow.md และ game-rules.md จะกำหนด Fallback Rule ไว้แล้วก็ตาม - ไม่บล็อกการพัฒนาเนื่องจากมีกติกาสำรอง (Fallback Rule: ใช้ Sprite Sheets .png หาก Lottie มีปัญหา) ชัดเจนในเอกสารอื่น - ต้องให้ Product Owner หรือ Design Team ยืนยันการปิดประเด็นใน requirements.md ให้ตรงกัน

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|
| ไม่มีข้อมูล | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่ต้องแก้มือ เนื่องจากไม่มีการเรียกตรวจ log |

## 7. ข้อจำกัดของการรีวิว
- เอกสารที่ตรวจจริง: docs/food/requirements.md, docs/food/ux-flow.md, docs/food/game-rules.md
- ไฟล์ที่ไม่ได้ตรวจ: ไม่มี (ตรวจครบทุกไฟล์ที่ได้รับ) และไม่มีรายงานการรีวิวกรอบก่อน (Previous review report) ทำให้ไม่สามารถทำ Regression comparison ได้

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: NEEDS_FIX
- Agent recommendation: ต้องแก้
- Blocking issues remaining: ไม่มีปัญหาที่เป็น Blocking (OQ-1 มีสถานะ Blocking: ไม่ใช่ ตามเอกสาร Design และมีกติกาสำรองรองรับ) แต่ยังมีประเด็นเอกสาร requirements.md ที่ต้องปรับแก้ให้สอดคล้องกับ ux-flow.md และ game-rules.md
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: เอกสารมีความครบถ้วนและสอดคล้องกันในระดับสูง แต่พบ Open Question ที่ยังเปิดค้างอยู่ใน requirements.md ซึ่งจำเป็นต้องได้รับการอัปเดตให้ตรงกับกติกาสำรองที่ระบุไว้ใน ux-flow.md และ game-rules.md ก่อนส่งมอบให้ทีม Dev ป้องกันความสับสนในการทำงาน
~~~~
