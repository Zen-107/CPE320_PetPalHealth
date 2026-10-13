# Log: design_review · steps · 2026-10-13 16:49

<!-- meta: {"role": "design_review", "feature": "steps", "time": "2026-10-13 16:49", "status": "ok", "provider": "gemini", "model": "gemini-3.5-flash-lite", "attempts": 1, "seconds": 7.0, "llm_calls": 1, "total_tokens": 14971, "agent_version": "ac395134"} -->

| รายการ | ค่า |
|---|---|
| สถานะ | สำเร็จ |
| ผู้ให้บริการ / รุ่น | gemini / gemini-3.5-flash-lite |
| ลำดับความพยายาม | gemini: สำเร็จ |
| เวลารวม | 7.0 วินาที |
| จำนวนครั้งที่เรียก LLM | 1 |
| tokens (prompt / completion / total) | 13308 / 1663 / 14971 |
| ไฟล์ input | docs/steps/requirements.md, docs/steps/ux-flow.md, docs/steps/game-rules.md |
| ไฟล์ output | docs/steps/design-review.md |
| agent | agents/design_reviewer.md (เวอร์ชัน ac395134) |
| --note | - |

## ความพยายามที่ 1 — gemini (gemini-3.5-flash-lite) — สำเร็จ, 7.0 วินาที

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

#### Task → docs/steps/design-review.md

~~~~text
ฟีเจอร์: steps

งานของคุณ: ตรวจเอกสาร Requirements, UX Flow และ Game Rules ก่อนส่งงานให้ Dev ตรวจความครบถ้วนและความสอดคล้องของเอกสาร ตรวจตัวเลข ชื่อสถานะ ขั้นตอนการใช้งาน และ edge cases โดยอ้างอิงหลักฐานจากไฟล์ที่ได้รับ ระบุข้อผิดพลาดพร้อมไฟล์/หัวข้อ เหตุผล และแนวทางแก้ไข ห้ามแต่งข้อกำหนดหรือผลทดสอบขึ้นเอง สรุปผลเป็น PASS, NEEDS_FIX หรือ INSUFFICIENT_EVIDENCE

ข้อมูลประกอบ:
=== docs/steps/requirements.md ===
# Requirements: การนับก้าวและการตั้งเป้าหมายประจำวัน (steps)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Product agent · ผู้ตรวจ: Senior PM · อ้างอิง Issue: #101

## 1. สรุปฟีเจอร์
ฟีเจอร์บันทึกก้าวเดินประจำวันอัตโนมัติ (Passive Tracking) เพื่อตัดรอบสถิติทุก 05:00 น. นำก้าวเดินเทียบกับเป้าหมายเพื่อคำนวณ % พลังงานขับเคลื่อนรูปร่างสัตว์เลี้ยงเสมือนจริง และรองรับการส่งออกรายงานสรุปผลรายเดือนเป็นไฟล์ภาพ PNG

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
| US-1 | ผู้ใช้แอป PetPal Health | ให้ระบบนับก้าวเดินของฉันโดยอัตโนมัติ | ฉันไม่ต้องคอยกดเปิดปิดการนับก้าวด้วยตนเอง |
| US-2 | ผู้ใช้ที่ต้องการดูแลสุขภาพ | สามารถตั้งค่าและปรับเปลี่ยนเป้าหมายก้าวเดินประจำวันได้ | สอดคล้องกับขีดความสามารถและเป้าหมายการออกกำลังกายของตนเอง |
| US-3 | เจ้าของสัตว์เลี้ยง | เห็นรูปร่างและสถานะของสัตว์เลี้ยงเสมือนจริงเปลี่ยนแปลงไปตาม % ก้าวเดิน | ทราบผลลัพธ์และมีแรงจูงใจในการเดินให้ครบเป้าหมาย |
| US-4 | ผู้ใช้ที่ต้องการสรุปผลสุขภาพ | สามารถส่งออกรายงานสรุปผลประจำเดือนในรูปแบบภาพ PNG ได้ | นำไปแชร์หรือเก็บไว้ดูความสำเร็จร่วมกับการดื่มน้ำ |

## 4. Acceptance criteria
| ID | อ้างถึง | เงื่อนไข (ก่อน / เมื่อ / แล้ว) | ค่าที่ทดสอบได้ |
|---|---|---|---|
| AC-1 | US-1 | ก่อน: ผู้ใช้เปิดแอปครั้งแรก / เมื่อ: ระบบขอสิทธิ์เซนเซอร์นับก้าวและผู้ใช้กดอนุญาต / แล้ว: ระบบเริ่มบันทึกก้าวเดินแบบ Passive | บันทึกก้าวเดินเพิ่มขึ้นตามการเคลื่อนไหวจริงโดยไม่มีค่าความคลาดเคลื่อนเกิน 5% จากฮาร์ดแวร์เครื่อง |
| AC-2 | US-2 | ก่อน: อยู่ในหน้าตั้งเป้าหมาย / เมื่อ: ผู้ใช้เลือกเป้าหมายกลุ่มทั่วไป (6,000 / 7,000 / 8,000) กลุ่มควบคุมน้ำหนัก (9,000 - 12,000) หรือกลุ่มนักกีฬา (13,000 - 15,000) แล้วกดบันทึก / แล้ว: ระบบบันทึกค่าเป้าหมายใหม่ทันที | ค่าเป้าหมายใหม่ถูกอัปเดตในฐานข้อมูลและนำไปคำนวณ % Goal ทันที |
| AC-3 | US-2 | ก่อน: ผู้ใช้ปรับเปลี่ยนเป้าหมายครั้งที่ 1 สำเร็จ / เมื่อ: ผู้ใช้พยายามกดเปลี่ยนเป้าหมายอีกครั้งภายในวันเดียวกัน (ก่อน 05:00 น.) / แล้ว: ปุ่มปรับเป้าหมายถูก Disabled (สีเทาจาง) และแสดง Toast Message | แสดงข้อความ *"คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวัน"* และไม่ให้บันทึกค่าซ้ำ |
| AC-4 | US-2 | ก่อน: ผู้ใช้ปรับเป้าหมายหลังเวลา 05:00 น. / เมื่อ: ระบบประมวลผลเวลาการเปลี่ยนเป้าหมาย / แล้ว: เป้าหมายใหม่จะมีผลในรอบวันถัดไป (เริ่มนับ 05:00 น. ของวันถัดไป) | เป้าหมายของรอบวันปัจจุบันยังคงใช้ค่าเดิม จนกว่าจะถึงเวลา 05:00 น. ของวันถัดไป |
| AC-5 | US-3 | ก่อน: ผู้ใช้เดินได้ค่า % Goal ต่างๆ / เมื่อ: ระบบคำนวณ `(ก้าวเดินจริง / เป้าหมาย) * 100` / แล้ว: แสดงสถานะสัตว์เลี้ยงตรงตามช่วง % | <35% แสดง "อ้วนอืด" (FAT), 35%-69.99% แสดง "จ่ำม่ำ" (CHUBBY), 70%-99.99% แสดง "หุ่นลีน (สมส่วน)" (LEAN), และ >=100% แสดง "มีกล้ามขา" (MUSCLE) |
| AC-6 | US-1, US-3 | ก่อน: เวลาถึง 05:00 น. / เมื่อ: ระบบถึงเวลาตัดรอบสถิติจับเวลาประจำวัน / แล้ว: จำนวนก้าวและหลอดพลังงานถูกรีเซ็ตเป็น 0 และเริ่มรอบวันใหม่ทันที | จำนวนก้าวประจำวันเป็น 0 และ % Goal เริ่มนับใหม่ ณ เวลา 05:00:00 น. |
| AC-7 | US-4 | ก่อน: อยู่ในหน้าสรุปผลรายเดือน / เมื่อ: ผู้ใช้กดปุ่มส่งออกรายงาน (Export PNG) / แล้ว: ระบบสร้างภาพ PNG 1 หน้าถ้วนที่รวมข้อมูลก้าวเดินรวม, น้ำดื่มรวม, ค่าเฉลี่ยรายวัน และจำนวนวันที่ทำเป้าหมายสำเร็จ | ไฟล์ภาพ PNG ถูกดาวน์โหลด/บันทึกเข้าเครื่องสำเร็จโดยแสดงข้อมูลครบทั้ง 4 ตัวแปรถูกต้องตรงกับฐานข้อมูล |

## 5. Edge cases
| ID | สถานการณ์ | ผลที่คาดหวัง |
|---|---|---|
| EC-1 | การปฏิเสธสิทธิ์ (Permission Denied): ผู้ใช้กดปฏิเสธสิทธิ์เข้าถึงเซนเซอร์นับก้าว | ระบบล็อกฟังก์ชันนับก้าวทั้งหมด แสดง Pop-up แจ้งเตือน และมีปุ่ม Shortcut พาผู้ใช้ไปหน้า Settings ของเครื่อง |
| EC-2 | กรณีแบตเตอรี่หมด/ปิดเครื่อง (Battery Drain / Device Shutdown): แบตเตอรี่หมดหรือเครื่องดับระหว่างวัน | ระบบดึงข้อมูลก้าวล่าสุดที่มีการบันทึกไว้ใน Local Storage มาแสดงผลโดยอัตโนมัติทันทีเมื่อเปิดแอปครั้งถัดไป |
| EC-3 | การเปลี่ยน Timezone หรือเวลาในเครื่อง (Timezone / Clock Modification): ผู้ใช้ปรับเวลาในเครื่องย้อนหลัง | ระบบยึดเวลาตาม Network/Server Time เท่านั้น ป้องกันการปรับเวลารีเซ็ตสถิติย้อนหลัง |
| EC-4 | การสลับอุปกรณ์ (Multi-device Sync): ผู้ใช้สลับไปใช้อุปกรณ์เครื่องใหม่ระหว่างวัน | ระบบ Sync เป้าหมายล่าสุดและดึงสถิติก้าวเดินสะสมเฉพาะของวันนั้นมาแสดงผลโดยไม่นับก้าวซ้ำซ้อน |
| EC-5 | การเปิดแอปค้างไว้ข้ามช่วงเวลา 05:00 น. (Foreground Crossing): เปิดหน้าจอแอปค้างไว้จนถึง 05:00 น. | ระบบทำการตัดรอบสถิติ รีเซ็ตหลอดพลังงานและจำนวนก้าวเป็น 0 และเริ่มรอบวันใหม่อัตโนมัติทันทีโดยไม่ต้อง Restart แอป |
| EC-6 | กรณีอุปกรณ์ไม่มีฮาร์ดแวร์เซนเซอร์นับก้าว (No Hardware Step Counter): อุปกรณ์ไม่มีเซนเซอร์ฮาร์ดแวร์นับก้าว | ระบบแสดง Pop-up แจ้งเตือนข้อจำกัดของอุปกรณ์ และทำการล็อกฟังก์ชันนับก้าวทั้งหมด (แนวทางเดียวกับ EC-1) |

## 6. สิ่งที่ไม่ทำในรอบนี้ (Out of scope)
- ระบบแจ้งเตือน Push Notification เมื่อเดินใกล้ถึงเป้าหมาย (เช่น แจ้งเตือนเมื่อเดินถึง 80% หรือเหลืออีก 1,000 ก้าว)
- หน้าแดชบอร์ดสรุปสถิติและกราฟแนวโน้มแสดงผลรายสัปดาห์/รายเดือนภายในแอป (In-App Dashboard)
- ระบบแข่งขันนับก้าวกับเพื่อนหรือระบบจัดอันดับ (Leaderboard)
- การเชื่อมต่อกับ Smartwatch หรืออุปกรณ์ภายนอก (Apple Health / Google Fit / Garmin / Fitbit)

## 7. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น)
| ข้อมูล | ชนิด/หน่วย | เก็บที่ไหน |
|---|---|---|
| จำนวนก้าวปัจจุบัน (Current Steps) | Integer (ก้าว) | Local Storage & Server Database |
| เป้าหมายประจำวัน (Daily Goal) | Integer (ก้าว) | Server Database |
| เปอร์เซ็นต์พลังงาน (% Goal) | Float (%) | Client App Memory (คำนวณแบบ Real-time) |
| สถานะสัตว์เลี้ยง (Pet Status Enum) | String (`FAT`, `CHUBBY`, `LEAN`, `MUSCLE`) | Server Database |
| โควต้าการเปลี่ยนเป้าหมายรายวัน | Integer (ครั้ง/วัน) | Local Storage (รีเซ็ตทุก 05:00 น.) |
| ข้อมูลรายงานสรุปรายเดือน (Monthly Health Data) | Object (รวม ก้าวรวม, น้ำรวม, ค่าเฉลี่ย, วันที่สำเร็จเป้าหมาย) | Server Database & Temporary PNG File |

=== จบ docs/steps/requirements.md ===

=== docs/steps/ux-flow.md ===
# UX flow: การนับก้าวและการตั้งเป้าหมายประจำวัน (steps)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Senior PM · อ้างอิง: requirements.md

## 1. รายการหน้าจอ

| ID | ชื่อหน้าจอ | จุดประสงค์ | อ้างถึง |
|---|---|---|---|
| S-1 | หน้าหลักการนับก้าวและสัตว์เลี้ยงเสมือนจริง | แสดงจำนวนก้าวปัจจุบัน % พลังงาน สถานะสัตว์เลี้ยง และทางเข้าสู่หน้าตั้งเป้าหมายและรายงาน | US-1, US-3, AC-1, AC-5, AC-6, EC-1, EC-2, EC-3, EC-4, EC-5, EC-6 |
| S-2 | หน้าตั้งเป้าหมายประจำวัน | ให้ผู้ใช้เลือกหรือตั้งค่าเป้าหมายก้าวเดินประจำวันตามกลุ่มเป้าหมาย | US-2, AC-2, AC-3, AC-4 |
| S-3 | หน้าสรุปผลรายเดือนและส่งออกรายงาน | แสดงข้อมูลสุขภาพรายเดือนรวมถึงก้าวเดินและน้ำดื่ม พร้อมปุ่มส่งออกรายงานเป็นภาพ PNG | US-4, AC-7 |

## 2. องค์ประกอบบนหน้าจอ

### S-1 หน้าหลักการนับก้าวและสัตว์เลี้ยงเสมือนจริง
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| รูปภาพสัตว์เลี้ยงเสมือนจริง | รูปภาพ | แสดงภาพตามสถานะ Code Enum: `FAT` (< 35%), `CHUBBY` (35% - 69.99%), `LEAN` (70% - 99.99%), `MUSCLE` (>= 100%) | ไม่มี |
| ป้ายสถานะสัตว์เลี้ยง | ข้อความ | ป้ายแสดงชื่อสถานะภาษาไทยกำกับ Code Enum: "อ้วนอืด (FAT)" / "จ่ำม่ำ (CHUBBY)" / "หุ่นลีน (สมส่วน) (LEAN)" / "มีกล้ามขา (MUSCLE)" | อัปเดตตาม game-rules.md ข้อ 2 |
| แถบพลังงาน (% Goal) | แถบแสดงผล | ตัวเลข % Goal และหลอดพลังงานคำนวณตามจริง (เช่น 45%, 100%, 120%) สามารถสะสมเกิน 100% ได้ตามจำนวนก้าวเดินจริง | อัปเดตแบบ Real-time ตามจำนวนก้าวเดินจริง |
| ตัวเลขก้าวเดินปัจจุบัน | ข้อความ | จำนวนก้าวปัจจุบันเทียบเป้าหมาย (เช่น "0 / 10,000 ก้าว" โดย 10,000 ก้าว เป็นค่าเริ่มต้น DEFAULT_DAILY_GOAL) | อัปเดตอัตโนมัติจากเซนเซอร์ (Passive Tracking) |
| ปุ่มตั้งเป้าหมาย | ปุ่ม | "ตั้งเป้าหมาย" | เปิดหน้า S-2 หน้าตั้งเป้าหมายประจำวัน |
| ปุ่มดูรายงานรายเดือน | ปุ่ม | "รายงานประจำเดือน" | เปิดหน้า S-3 หน้าสรุปผลรายเดือนและส่งออกรายงาน |
| ป๊อปอัปแจ้งเตือนสิทธิ์ (Permission/Hardware Error) | ป๊อปอัป | "ไม่สามารถเข้าถึงเซนเซอร์นับก้าวได้ กรุณาเปิดสิทธิ์ในการตั้งค่าเครื่อง" | ปุ่ม "ไปที่การตั้งค่า" (พาไปหน้า Settings ของเครื่อง) |

### S-2 หน้าตั้งเป้าหมายประจำวัน
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| ตัวเลือกกลุ่มทั่วไป | ตัวเลือก (Radio) | "6,000 ก้าว", "7,000 ก้าว", "8,000 ก้าว" | เลือกเป้าหมายกลุ่มทั่วไป |
| ตัวเลือกกลุ่มควบคุมน้ำหนัก | ตัวเลือก (Radio) | "9,000 ก้าว", "10,000 ก้าว (ค่าเริ่มต้น / DEFAULT_DAILY_GOAL)", "11,000 ก้าว", "12,000 ก้าว" | เลือกเป้าหมายกลุ่มควบคุมน้ำหนัก (โดย 10,000 ก้าว เป็นค่าเริ่มต้นระบบที่ถูกเลือกไว้ล่วงหน้าสำหรับผู้ใช้ใหม่) |
| ตัวเลือกกลุ่มนักกีฬา | ตัวเลือก (Radio) | "13,000 ก้าว", "14,000 ก้าว", "15,000 ก้าว" | เลือกเป้าหมายกลุ่มนักกีฬา |
| ปุ่มบันทึก | ปุ่ม | "บันทึก" | บันทึกค่าเป้าหมายใหม่ (อ้างอิง AC-2, AC-3, AC-4) |
| ปุ่มย้อนกลับ | ปุ่ม | "ย้อนกลับ" | กลับไปหน้า S-1 |
| Toast ข้อความแจ้งเตือน | ข้อความลอย | "คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวัน" | แสดงเมื่อพยายามบันทึกขณะปุ่ม Disabled (เกินโควต้า 1 ครั้ง/วัน) |

### S-3 หน้าสรุปผลรายเดือนและส่งออกรายงาน
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| ข้อมูลสรุปรายเดือน | ข้อความ | ก้าวเดินรวม, น้ำดื่มรวม, ค่าเฉลี่ยรายวัน, จำนวนวันที่ทำเป้าหมายสำเร็จ | แสดงข้อมูลจากฐานข้อมูล |
| ปุ่มส่งออกรายงาน (Export PNG) | ปุ่ม | "ส่งออกรายงาน (PNG)" | สร้างและดาวน์โหลด/บันทึกภาพ PNG 1 หน้าถ้วนเข้าเครื่อง |
| ปุ่มย้อนกลับ | ปุ่ม | "ย้อนกลับ" | กลับไปหน้า S-1 |

## 3. ขั้นตอนการใช้งาน (happy path)

1. **เปิดแอปครั้งแรก:** ผู้ใช้เปิดแอป PetPal Health ระบบแสดงหน้าขอสิทธิ์เซนเซอร์นับก้าว ผู้ใช้กด "อนุญาต" ระบบเริ่มบันทึกก้าวเดินแบบ Passive และแสดงหน้าหลัก (S-1) โดยแสดงจำนวนก้าวเป็น 0 เทียบเป้าหมายเริ่มต้น 10,000 ก้าว ("0 / 10,000 ก้าว"), % Goal เป็น 0%, และแสดงรูปร่างสัตว์เลี้ยงเริ่มต้น "อ้วนอืด (FAT)"
2. **การนับก้าวอัตโนมัติ:** เมื่อผู้ใช้เคลื่อนไหวร่างกาย ระบบนับก้าวเดินอัตโนมัติและอัปเดตตัวเลขก้าวเดิน หลอดพลังงาน และรูปร่างสัตว์เลี้ยงบนหน้า S-1 แบบ Real-time ตามเงื่อนไข % Goal (เมื่อเดินเกิน 100% ตัวเลขและหลอดพลังงานคำนวณตามจริง เช่น 120% และสัตว์เลี้ยงคงสถานะสูงสุด "มีกล้ามขา (MUSCLE)")
3. **การตั้งเป้าหมาย:** ผู้ใช้กดปุ่ม "ตั้งเป้าหมาย" ในหน้า S-1 เพื่อเข้าสู่หน้า S-2 โดยระบบแสดงตัวเลือก 3 กลุ่ม (10 ค่า) พร้อมเลือกค่าเริ่มต้น 10,000 ก้าว (DEFAULT_DAILY_GOAL) ไว้ล่วงหน้า ผู้ใช้สามารถเลือกเป้าหมายที่ต้องการ (เช่น 8,000 ก้าว) แล้วกด "บันทึก" ระบบบันทึกค่าเป้าหมายใหม่ทันทีและพาผู้ใช้กลับสู่หน้า S-1
4. **การส่งออกรายงาน:** ผู้ใช้กดปุ่ม "รายงานประจำเดือน" ในหน้า S-1 เพื่อเข้าสู่หน้า S-3 จากนั้นกดปุ่ม "ส่งออกรายงาน (PNG)" ระบบสร้างภาพ PNG รวมข้อมูล 4 ตัวแปร (ก้าวเดินรวม, น้ำดื่มรวม, ค่าเฉลี่ยรายวัน, วันที่สำเร็จเป้าหมาย) และบันทึกเข้าเครื่องสำเร็จ

## 4. สถานะของหน้าจอ

| หน้าจอ | สถานะ | เงื่อนไขที่ทำให้เกิด | สิ่งที่แสดง |
|---|---|---|---|
| S-1 | ปกติ | แอปทำงานปกติและได้รับสิทธิ์เซนเซอร์นับก้าว | แสดงจำนวนก้าว % พลังงาน (เกิน 100% ได้) และรูปร่างสัตว์เลี้ยงตามเกณฑ์ |
| S-1 | ว่าง / เริ่มต้นวันใหม่ | เวลาถึง 05:00:00 น. หรือเปิดแอปวันแรก | จำนวนก้าวแสดงเป็น "0 / 10,000 ก้าว" (หรือเป้าหมายที่ตั้งไว้), % Goal เป็น 0%, สัตว์เลี้ยงแสดงสถานะเริ่มต้น "อ้วนอืด (FAT)" |
| S-1 | ผิดพลาด (Permission/Hardware Denied) | ผู้ใช้ปฏิเสธสิทธิ์เซนเซอร์ (EC-1) หรืออุปกรณ์ไม่มีฮาร์ดแวร์เซนเซอร์ (EC-6) | แสดง Pop-up แจ้งเตือนข้อจำกัดและปุ่ม "ไปที่การตั้งค่า" พร้อมล็อกฟังก์ชันนับก้าว |
| S-2 | ปกติ | ผู้ใช้ยังไม่ได้เปลี่ยนเป้าหมายในวันนั้น (โควต้าเหลือ 1 ครั้ง) | แสดงตัวเลือกเป้าหมาย 3 กลุ่ม (10 ตัวเลือก) โดยมี 10,000 ก้าว (DEFAULT_DAILY_GOAL) ถูกเลือกไว้ล่วงหน้า (Pre-selected) และปุ่ม "บันทึก" ใช้งานได้ปกติ |
| S-2 | ผิดพลาด (Disabled State) | ผู้ใช้พยายามเปลี่ยนเป้าหมายซ้ำภายในวันเดียวกัน (ก่อน 05:00 น.) | ปุ่มบันทึกถูก Disabled (สีเทาจาง) และแสดง Toast Message: *"คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวัน"* |
| S-3 | ปกติ | มีข้อมูลสรุปรายเดือนในระบบ | แสดงข้อมูลสรุป 4 ตัวแปรและปุ่ม "ส่งออกรายงาน (PNG)" |
| S-3 | ว่าง | ไม่มีข้อมูลสถิติในเดือนนั้น | แสดงข้อความ "ยังไม่มีข้อมูลสรุปสำหรับเดือนนี้" และปุ่มส่งออกรายงานถูกปิดการใช้งาน |

## 5. ไฟล์ภาพ assets

| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายภาพ |
|---|---|---|
| assets/images/pet_fat.png | S-1 (สถานะ: < 35%) | ภาพสัตว์เลี้ยงเสมือนจริงรูปร่างอ้วนอืด (FAT) |
| assets/images/pet_chubby.png | S-1 (สถานะ: 35% - 69.99%) | ภาพสัตว์เลี้ยงเสมือนจริงรูปร่างจ่ำม่ำ (CHUBBY) |
| assets/images/pet_lean.png | S-1 (สถานะ: 70% - 99.99%) | ภาพสัตว์เลี้ยงเสมือนจริงหุ่นลีน สมส่วน (LEAN) |
| assets/images/pet_muscle.png | S-1 (สถานะ: >= 100%) | ภาพสัตว์เลี้ยงเสมือนจริงมีกล้ามขา (MUSCLE) |
| assets/images/icon_steps.png | S-1 (องค์ประกอบก้าวเดิน) | ไอคอนสัญลักษณ์รูปฝ่าเท้า/ก้าวเดิน |
| assets/images/bg_report_export.png | S-3 (เทมเพลตภาพ PNG) | เทมเพลตพื้นหลังสำหรับสร้างภาพรายงานสรุปผลรายเดือน PNG 1 หน้าถ้วน |

*หมายเหตุ: ชื่อไฟล์ภาพข้างต้นเป็นข้อเสนอเพื่อใช้ในการพัฒนา UI เมื่อยังไม่มีไฟล์จริงจากทีม Asset*

## 6. ข้อเสนอแนะเพิ่มเติมจาก Design สำหรับการพัฒนา
1. **การแสดงผลตัวเลือกเป้าหมายในหน้า S-2 และค่าเริ่มต้นระบบ (DEFAULT_DAILY_GOAL)**: ออกแบบเป็นกลุ่ม Radio Buttons แยก 3 กลุ่มชัดเจน (กลุ่มทั่วไป 6,000-8,000, กลุ่มควบคุมน้ำหนัก 9,000-12,000, กลุ่มนักกีฬา 13,000-15,000) โดยกำหนดค่าเริ่มต้นที่ 10,000 ก้าว (`DEFAULT_DAILY_GOAL` ในกลุ่มควบคุมน้ำหนัก) ถูกเลือกไว้ล่วงหน้า (Pre-selected) สำหรับผู้ใช้ใหม่ เพื่อให้การตั้งค่าเริ่มต้นสอดคล้องกันทุกส่วนของระบบ
2. **การจัดการข้อผิดพลาดขณะ Export PNG**: หากเกิดกรณีพื้นที่จัดเก็บในเครื่องเต็ม ให้แสดง Alert Pop-up แจ้งว่า *"ไม่สามารถบันทึกภาพได้เนื่องจากพื้นที่จัดเก็บข้อมูลไม่เพียงพอ"* เพื่อให้ผู้ใช้ทราบสถานะที่ชัดเจน

=== จบ docs/steps/ux-flow.md ===

=== docs/steps/game-rules.md ===
# กติกาเกม: การนับก้าวและการตั้งเป้าหมายประจำวัน (steps)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Senior PM · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ความหมาย | ค่า | หน่วย | อ้างถึง |
|---|---|---|---|---|
| DEFAULT_DAILY_GOAL | ค่าเป้าหมายก้าวเดินเริ่มต้นประจำวัน (กรณีผู้ใช้ยังไม่ได้กำหนดเอง) | 10,000 (ค่าเริ่มต้นแนะนำ กลุ่มควบคุมน้ำหนัก) | ก้าว | AC-2 |
| STEP_GOAL_OPTIONS_GENERAL | ตัวเลือกเป้าหมายกลุ่มทั่วไป | 6,000 / 7,000 / 8,000 | ก้าว | AC-2 |
| STEP_GOAL_OPTIONS_WEIGHT_CONTROL | ตัวเลือกเป้าหมายกลุ่มควบคุมน้ำหนัก | 9,000 / 10,000 / 11,000 / 12,000 | ก้าว | AC-2 |
| STEP_GOAL_OPTIONS_ATHLETE | ตัวเลือกเป้าหมายกลุ่มนักกีฬา | 13,000 / 14,000 / 15,000 | ก้าว | AC-2 |
| DAILY_GOAL_CHANGE_LIMIT | โควต้าสูงสุดในการเปลี่ยนเป้าหมายต่อวัน | 1 | ครั้ง/วัน | AC-3 |
| RESET_TIME_HOUR | เวลาตัดรอบสถิติจับเวลาประจำวัน (ชั่วโมง) | 05 | นาฬิกา | AC-4, AC-6 |
| RESET_TIME_MINUTE | เวลาตัดรอบสถิติจับเวลาประจำวัน (นาที) | 00 | นาที | AC-4, AC-6 |
| RESET_TIME_SECOND | เวลาตัดรอบสถิติจับเวลาประจำวัน (วินาที) | 00 | วินาที | AC-4, AC-6 |
| STEP_ACCURACY_THRESHOLD | เกณฑ์ความคลาดเคลื่อนสูงสุดที่ยอมรับได้จากฮาร์ดแวร์ | 5 | % | AC-1 |
| GOAL_PERCENTAGE_FAT_LIMIT | เกณฑ์สูงสุดของช่วงสถานะอ้วนอืด (ไม่รวมค่าน้อยกว่า) | 35 | % | AC-5 |
| GOAL_PERCENTAGE_CHUBBY_MIN | เกณฑ์ต่ำสุดของช่วงสถานะจ่ำม่ำ (รวมค่า) | 35 | % | AC-5 |
| GOAL_PERCENTAGE_CHUBBY_MAX | เกณฑ์สูงสุดของช่วงสถานะจ่ำม่ำ (ไม่รวมค่าน้อยกว่า) | 69.99 | % | AC-5 |
| GOAL_PERCENTAGE_LEAN_MIN | เกณฑ์ต่ำสุดของช่วงสถานะหุ่นลีน (สมส่วน) (รวมค่า) | 70 | % | AC-5 |
| GOAL_PERCENTAGE_LEAN_MAX | เกณฑ์สูงสุดของช่วงสถานะหุ่นลีน (สมส่วน) (ไม่รวมค่าน้อยกว่า) | 99.99 | % | AC-5 |
| GOAL_PERCENTAGE_MUSCLE_MIN | เกณฑ์ต่ำสุดของช่วงสถานะมีกล้ามขา (รวมค่า) | 100 | % | AC-5 |

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง

| สถานะ | ช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพ |
|---|---|---|
| อ้วนอืด (FAT) | น้อยกว่า 35% (< 35.00%) | assets/images/pet_fat.png |
| จ่ำม่ำ (CHUBBY) | ตั้งแต่ 35% ถึงน้อยกว่า 70% (รวม 35.00% ถึง 69.99%) | assets/images/pet_chubby.png |
| หุ่นลีน (สมส่วน) (LEAN) | ตั้งแต่ 70% ถึงน้อยกว่า 100% (รวม 70.00% ถึง 99.99%) | assets/images/pet_lean.png |
| มีกล้ามขา (MUSCLE) | 100% ขึ้นไป (รวม 100.00% ขึ้นไป) | assets/images/pet_muscle.png |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| คำนวณ % Goal เมื่อเป้าหมายคือ 8,000 ก้าว และเดินได้ 2,400 ก้าว | 2,400 ก้าว / เป้าหมาย 8,000 ก้าว | 30.00% (สถานะ: อ้วนอืด / FAT) | อ้าง AC-5 |
| คำนวณ % Goal เมื่อเป้าหมายคือ 8,000 ก้าว และเดินได้ 4,000 ก้าว | 4,000 ก้าว / เป้าหมาย 8,000 ก้าว | 50.00% (สถานะ: จ่ำม่ำ / CHUBBY) | อ้าง AC-5 |
| คำนวณ % Goal เมื่อเป้าหมายคือ 8,000 ก้าว และเดินได้ 6,000 ก้าว | 6,000 ก้าว / เป้าหมาย 8,000 ก้าว | 75.00% (สถานะ: หุ่นลีน / LEAN) | อ้าง AC-5 |
| คำนวณ % Goal เมื่อเป้าหมายคือ 8,000 ก้าว และเดินได้ 8,000 ก้าว | 8,000 ก้าว / เป้าหมาย 8,000 ก้าว | 100.00% (สถานะ: มีกล้ามขา / MUSCLE) | อ้าง AC-5 |
| ผู้ใช้เปลี่ยนเป้าหมายสำเร็จครั้งที่ 1 ในวันเดียวกัน | โควต้าเปลี่ยนเป้าหมายเหลือ 1 ครั้ง | โควต้าเปลี่ยนเป้าหมายเหลือ 0 ครั้ง (ปุ่มถูก Disabled) | อ้าง AC-3 |
| ถึงเวลาตัดรอบประจำวันเวลา 05:00:00 น. | จำนวนก้าวสะสมเดิม, % Goal เดิม | จำนวนก้าว = 0, % Goal = 0% | อ้าง AC-6 |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ที่ทดสอบได้ |
|---|---|
| ค่าเกินขอบบน (% Goal สูงกว่า 100% / เดินเกินเป้าหมาย) | หลอดพลังงานและค่า % Goal หยุดสะสมสูงสุดที่ 100% (ตามข้อกำหนดสะสมสูงสุดไม่เกิน 100%) โดยสัตว์เลี้ยงคงสถานะ "มีกล้ามขา" (MUSCLE) ขณะที่ตัวเลขจำนวนก้าวเดินจริงยังคงแสดงค่าตามการนับจริง (เช่น "12,000 / 10,000 ก้าว") |
| ค่าต่ำกว่าขอบล่าง (จำนวนก้าวติดลบหรือ 0) | ระบบแสดงจำนวนก้าวเป็น 0 และ % Goal เป็น 0% พร้อมแสดงสถานะ "อ้วนอืด" (FAT) |
| การเปลี่ยนเป้าหมายซ้ำในวันเดียวกัน (ก่อน 05:00 น.) | ปุ่มบันทึกเป้าหมายถูกเปลี่ยนเป็นสถานะ Disabled (สีเทาจาง) และแสดง Toast Message: *"คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวัน"* ทันทีเมื่อผู้ใช้พยายามกด |
| การเปลี่ยนเป้าหมายหลังเวลา 05:00 น. | ค่าเป้าหมายใหม่จะถูกบันทึกไว้ในฐานข้อมูล แต่จะยังไม่มีผลกับรอบวันปัจจุบัน โดยรอบวันปัจจุบันยังคงใช้เป้าหมายเดิมจนกระทั่งถึงเวลา 05:00:00 น. ของวันถัดไปจึงจะเริ่มใช้เป้าหมายใหม่ |
| การปฏิเสธสิทธิ์เซนเซอร์นับก้าว (EC-1) และไม่มีฮาร์ดแวร์ (EC-6) | ระบบล็อกฟังก์ชันนับก้าวทั้งหมด แสดง Pop-up แจ้งเตือนข้อจำกัดของอุปกรณ์ และแสดงปุ่ม Shortcut พาผู้ใช้ไปหน้า Settings ของเครื่อง |
| แบตเตอรี่หมดหรือเครื่องดับระหว่างวัน (EC-2) | ระบบดึงข้อมูลก้าวล่าสุดที่มีการบันทึกสำรองไว้ใน Local Storage มาแสดงผลโดยอัตโนมัติทันทีเมื่อเปิดแอปพลิเคชันครั้งถัดไป |
| การปรับเวลาในเครื่องย้อนหลัง (EC-3) | ระบบบังคับใช้เวลาอ้างอิงตาม Network/Server Time เท่านั้น เพื่อป้องกันการปรับเวลารีเซ็ตสถิติย้อนหลัง |
| การสลับอุปกรณ์ระหว่างวัน (EC-4) | ระบบทำการ Sync เป้าหมายล่าสุดและดึงสถิติก้าวเดินสะสมเฉพาะของวันนั้นมาจาก Server โดยไม่นับก้าวซ้ำซ้อน |
| การเปิดแอปค้างไว้ข้ามช่วงเวลา 05:00 น. (Foreground Crossing / EC-5) | ระบบดำเนินการตัดรอบสถิติ ทำการรีเซ็ตหลอดพลังงานและจำนวนก้าวเป็น 0 และเริ่มรอบวันใหม่อัตโนมัติทันทีบนหน้าจอโดยผู้ใช้ไม่ต้องทำการ Restart แอปพลิเคชัน |

## 5. ข้อเสนอแนะเพิ่มเติมจาก Design สำหรับการพัฒนา
1. **ค่าเริ่มต้นเป้าหมาย (`DEFAULT_DAILY_GOAL`)**: แนะนำใช้ 10,000 ก้าว (ค่ากึ่งกลางของกลุ่มควบคุมน้ำหนัก) เป็นค่า Default เมื่อผู้ใช้เปิดแอปครั้งแรก
2. **ตัวเลือกเป้าหมายในหน้า S-2**: ออกแบบเป็น Radio Buttons ครบทั้ง 10 ค่าตามกลุ่ม (6,000 - 8,000 / 9,000 - 12,000 / 13,000 - 15,000) เพื่อความสะดวกในการใช้งานของผู้ใช้และลดความผิดพลาดในการกรอกข้อมูล
3. **การจัดการ Storage เต็มขณะ Export PNG**: หากเกิดกรณีพื้นที่จัดเก็บเต็ม แนะนำให้แสดง Alert Pop-up แจ้งว่า *"ไม่สามารถบันทึกภาพได้เนื่องจากพื้นที่จัดเก็บข้อมูลไม่เพียงพอ"* เพื่อแจ้งผู้ใช้ทราบอย่างชัดเจน

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
Your personal goal is: Review the steps design documents against supplied project specifications, verify prior findings when available, and report evidence-backed contradictions, ambiguities, missing decisions, and actionable documentation issues without modifying source documents.

[user]

Current Task: ฟีเจอร์: steps

งานของคุณ: ตรวจเอกสาร Requirements, UX Flow และ Game Rules ก่อนส่งงานให้ Dev ตรวจความครบถ้วนและความสอดคล้องของเอกสาร ตรวจตัวเลข ชื่อสถานะ ขั้นตอนการใช้งาน และ edge cases โดยอ้างอิงหลักฐานจากไฟล์ที่ได้รับ ระบุข้อผิดพลาดพร้อมไฟล์/หัวข้อ เหตุผล และแนวทางแก้ไข ห้ามแต่งข้อกำหนดหรือผลทดสอบขึ้นเอง สรุปผลเป็น PASS, NEEDS_FIX หรือ INSUFFICIENT_EVIDENCE

ข้อมูลประกอบ:
=== docs/steps/requirements.md ===
# Requirements: การนับก้าวและการตั้งเป้าหมายประจำวัน (steps)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Product agent · ผู้ตรวจ: Senior PM · อ้างอิง Issue: #101

## 1. สรุปฟีเจอร์
ฟีเจอร์บันทึกก้าวเดินประจำวันอัตโนมัติ (Passive Tracking) เพื่อตัดรอบสถิติทุก 05:00 น. นำก้าวเดินเทียบกับเป้าหมายเพื่อคำนวณ % พลังงานขับเคลื่อนรูปร่างสัตว์เลี้ยงเสมือนจริง และรองรับการส่งออกรายงานสรุปผลรายเดือนเป็นไฟล์ภาพ PNG

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
| US-1 | ผู้ใช้แอป PetPal Health | ให้ระบบนับก้าวเดินของฉันโดยอัตโนมัติ | ฉันไม่ต้องคอยกดเปิดปิดการนับก้าวด้วยตนเอง |
| US-2 | ผู้ใช้ที่ต้องการดูแลสุขภาพ | สามารถตั้งค่าและปรับเปลี่ยนเป้าหมายก้าวเดินประจำวันได้ | สอดคล้องกับขีดความสามารถและเป้าหมายการออกกำลังกายของตนเอง |
| US-3 | เจ้าของสัตว์เลี้ยง | เห็นรูปร่างและสถานะของสัตว์เลี้ยงเสมือนจริงเปลี่ยนแปลงไปตาม % ก้าวเดิน | ทราบผลลัพธ์และมีแรงจูงใจในการเดินให้ครบเป้าหมาย |
| US-4 | ผู้ใช้ที่ต้องการสรุปผลสุขภาพ | สามารถส่งออกรายงานสรุปผลประจำเดือนในรูปแบบภาพ PNG ได้ | นำไปแชร์หรือเก็บไว้ดูความสำเร็จร่วมกับการดื่มน้ำ |

## 4. Acceptance criteria
| ID | อ้างถึง | เงื่อนไข (ก่อน / เมื่อ / แล้ว) | ค่าที่ทดสอบได้ |
|---|---|---|---|
| AC-1 | US-1 | ก่อน: ผู้ใช้เปิดแอปครั้งแรก / เมื่อ: ระบบขอสิทธิ์เซนเซอร์นับก้าวและผู้ใช้กดอนุญาต / แล้ว: ระบบเริ่มบันทึกก้าวเดินแบบ Passive | บันทึกก้าวเดินเพิ่มขึ้นตามการเคลื่อนไหวจริงโดยไม่มีค่าความคลาดเคลื่อนเกิน 5% จากฮาร์ดแวร์เครื่อง |
| AC-2 | US-2 | ก่อน: อยู่ในหน้าตั้งเป้าหมาย / เมื่อ: ผู้ใช้เลือกเป้าหมายกลุ่มทั่วไป (6,000 / 7,000 / 8,000) กลุ่มควบคุมน้ำหนัก (9,000 - 12,000) หรือกลุ่มนักกีฬา (13,000 - 15,000) แล้วกดบันทึก / แล้ว: ระบบบันทึกค่าเป้าหมายใหม่ทันที | ค่าเป้าหมายใหม่ถูกอัปเดตในฐานข้อมูลและนำไปคำนวณ % Goal ทันที |
| AC-3 | US-2 | ก่อน: ผู้ใช้ปรับเปลี่ยนเป้าหมายครั้งที่ 1 สำเร็จ / เมื่อ: ผู้ใช้พยายามกดเปลี่ยนเป้าหมายอีกครั้งภายในวันเดียวกัน (ก่อน 05:00 น.) / แล้ว: ปุ่มปรับเป้าหมายถูก Disabled (สีเทาจาง) และแสดง Toast Message | แสดงข้อความ *"คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวัน"* และไม่ให้บันทึกค่าซ้ำ |
| AC-4 | US-2 | ก่อน: ผู้ใช้ปรับเป้าหมายหลังเวลา 05:00 น. / เมื่อ: ระบบประมวลผลเวลาการเปลี่ยนเป้าหมาย / แล้ว: เป้าหมายใหม่จะมีผลในรอบวันถัดไป (เริ่มนับ 05:00 น. ของวันถัดไป) | เป้าหมายของรอบวันปัจจุบันยังคงใช้ค่าเดิม จนกว่าจะถึงเวลา 05:00 น. ของวันถัดไป |
| AC-5 | US-3 | ก่อน: ผู้ใช้เดินได้ค่า % Goal ต่างๆ / เมื่อ: ระบบคำนวณ `(ก้าวเดินจริง / เป้าหมาย) * 100` / แล้ว: แสดงสถานะสัตว์เลี้ยงตรงตามช่วง % | <35% แสดง "อ้วนอืด" (FAT), 35%-69.99% แสดง "จ่ำม่ำ" (CHUBBY), 70%-99.99% แสดง "หุ่นลีน (สมส่วน)" (LEAN), และ >=100% แสดง "มีกล้ามขา" (MUSCLE) |
| AC-6 | US-1, US-3 | ก่อน: เวลาถึง 05:00 น. / เมื่อ: ระบบถึงเวลาตัดรอบสถิติจับเวลาประจำวัน / แล้ว: จำนวนก้าวและหลอดพลังงานถูกรีเซ็ตเป็น 0 และเริ่มรอบวันใหม่ทันที | จำนวนก้าวประจำวันเป็น 0 และ % Goal เริ่มนับใหม่ ณ เวลา 05:00:00 น. |
| AC-7 | US-4 | ก่อน: อยู่ในหน้าสรุปผลรายเดือน / เมื่อ: ผู้ใช้กดปุ่มส่งออกรายงาน (Export PNG) / แล้ว: ระบบสร้างภาพ PNG 1 หน้าถ้วนที่รวมข้อมูลก้าวเดินรวม, น้ำดื่มรวม, ค่าเฉลี่ยรายวัน และจำนวนวันที่ทำเป้าหมายสำเร็จ | ไฟล์ภาพ PNG ถูกดาวน์โหลด/บันทึกเข้าเครื่องสำเร็จโดยแสดงข้อมูลครบทั้ง 4 ตัวแปรถูกต้องตรงกับฐานข้อมูล |

## 5. Edge cases
| ID | สถานการณ์ | ผลที่คาดหวัง |
|---|---|---|
| EC-1 | การปฏิเสธสิทธิ์ (Permission Denied): ผู้ใช้กดปฏิเสธสิทธิ์เข้าถึงเซนเซอร์นับก้าว | ระบบล็อกฟังก์ชันนับก้าวทั้งหมด แสดง Pop-up แจ้งเตือน และมีปุ่ม Shortcut พาผู้ใช้ไปหน้า Settings ของเครื่อง |
| EC-2 | กรณีแบตเตอรี่หมด/ปิดเครื่อง (Battery Drain / Device Shutdown): แบตเตอรี่หมดหรือเครื่องดับระหว่างวัน | ระบบดึงข้อมูลก้าวล่าสุดที่มีการบันทึกไว้ใน Local Storage มาแสดงผลโดยอัตโนมัติทันทีเมื่อเปิดแอปครั้งถัดไป |
| EC-3 | การเปลี่ยน Timezone หรือเวลาในเครื่อง (Timezone / Clock Modification): ผู้ใช้ปรับเวลาในเครื่องย้อนหลัง | ระบบยึดเวลาตาม Network/Server Time เท่านั้น ป้องกันการปรับเวลารีเซ็ตสถิติย้อนหลัง |
| EC-4 | การสลับอุปกรณ์ (Multi-device Sync): ผู้ใช้สลับไปใช้อุปกรณ์เครื่องใหม่ระหว่างวัน | ระบบ Sync เป้าหมายล่าสุดและดึงสถิติก้าวเดินสะสมเฉพาะของวันนั้นมาแสดงผลโดยไม่นับก้าวซ้ำซ้อน |
| EC-5 | การเปิดแอปค้างไว้ข้ามช่วงเวลา 05:00 น. (Foreground Crossing): เปิดหน้าจอแอปค้างไว้จนถึง 05:00 น. | ระบบทำการตัดรอบสถิติ รีเซ็ตหลอดพลังงานและจำนวนก้าวเป็น 0 และเริ่มรอบวันใหม่อัตโนมัติทันทีโดยไม่ต้อง Restart แอป |
| EC-6 | กรณีอุปกรณ์ไม่มีฮาร์ดแวร์เซนเซอร์นับก้าว (No Hardware Step Counter): อุปกรณ์ไม่มีเซนเซอร์ฮาร์ดแวร์นับก้าว | ระบบแสดง Pop-up แจ้งเตือนข้อจำกัดของอุปกรณ์ และทำการล็อกฟังก์ชันนับก้าวทั้งหมด (แนวทางเดียวกับ EC-1) |

## 6. สิ่งที่ไม่ทำในรอบนี้ (Out of scope)
- ระบบแจ้งเตือน Push Notification เมื่อเดินใกล้ถึงเป้าหมาย (เช่น แจ้งเตือนเมื่อเดินถึง 80% หรือเหลืออีก 1,000 ก้าว)
- หน้าแดชบอร์ดสรุปสถิติและกราฟแนวโน้มแสดงผลรายสัปดาห์/รายเดือนภายในแอป (In-App Dashboard)
- ระบบแข่งขันนับก้าวกับเพื่อนหรือระบบจัดอันดับ (Leaderboard)
- การเชื่อมต่อกับ Smartwatch หรืออุปกรณ์ภายนอก (Apple Health / Google Fit / Garmin / Fitbit)

## 7. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น)
| ข้อมูล | ชนิด/หน่วย | เก็บที่ไหน |
|---|---|---|
| จำนวนก้าวปัจจุบัน (Current Steps) | Integer (ก้าว) | Local Storage & Server Database |
| เป้าหมายประจำวัน (Daily Goal) | Integer (ก้าว) | Server Database |
| เปอร์เซ็นต์พลังงาน (% Goal) | Float (%) | Client App Memory (คำนวณแบบ Real-time) |
| สถานะสัตว์เลี้ยง (Pet Status Enum) | String (`FAT`, `CHUBBY`, `LEAN`, `MUSCLE`) | Server Database |
| โควต้าการเปลี่ยนเป้าหมายรายวัน | Integer (ครั้ง/วัน) | Local Storage (รีเซ็ตทุก 05:00 น.) |
| ข้อมูลรายงานสรุปรายเดือน (Monthly Health Data) | Object (รวม ก้าวรวม, น้ำรวม, ค่าเฉลี่ย, วันที่สำเร็จเป้าหมาย) | Server Database & Temporary PNG File |

=== จบ docs/steps/requirements.md ===

=== docs/steps/ux-flow.md ===
# UX flow: การนับก้าวและการตั้งเป้าหมายประจำวัน (steps)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Senior PM · อ้างอิง: requirements.md

## 1. รายการหน้าจอ

| ID | ชื่อหน้าจอ | จุดประสงค์ | อ้างถึง |
|---|---|---|---|
| S-1 | หน้าหลักการนับก้าวและสัตว์เลี้ยงเสมือนจริง | แสดงจำนวนก้าวปัจจุบัน % พลังงาน สถานะสัตว์เลี้ยง และทางเข้าสู่หน้าตั้งเป้าหมายและรายงาน | US-1, US-3, AC-1, AC-5, AC-6, EC-1, EC-2, EC-3, EC-4, EC-5, EC-6 |
| S-2 | หน้าตั้งเป้าหมายประจำวัน | ให้ผู้ใช้เลือกหรือตั้งค่าเป้าหมายก้าวเดินประจำวันตามกลุ่มเป้าหมาย | US-2, AC-2, AC-3, AC-4 |
| S-3 | หน้าสรุปผลรายเดือนและส่งออกรายงาน | แสดงข้อมูลสุขภาพรายเดือนรวมถึงก้าวเดินและน้ำดื่ม พร้อมปุ่มส่งออกรายงานเป็นภาพ PNG | US-4, AC-7 |

## 2. องค์ประกอบบนหน้าจอ

### S-1 หน้าหลักการนับก้าวและสัตว์เลี้ยงเสมือนจริง
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| รูปภาพสัตว์เลี้ยงเสมือนจริง | รูปภาพ | แสดงภาพตามสถานะ Code Enum: `FAT` (< 35%), `CHUBBY` (35% - 69.99%), `LEAN` (70% - 99.99%), `MUSCLE` (>= 100%) | ไม่มี |
| ป้ายสถานะสัตว์เลี้ยง | ข้อความ | ป้ายแสดงชื่อสถานะภาษาไทยกำกับ Code Enum: "อ้วนอืด (FAT)" / "จ่ำม่ำ (CHUBBY)" / "หุ่นลีน (สมส่วน) (LEAN)" / "มีกล้ามขา (MUSCLE)" | อัปเดตตาม game-rules.md ข้อ 2 |
| แถบพลังงาน (% Goal) | แถบแสดงผล | ตัวเลข % Goal และหลอดพลังงานคำนวณตามจริง (เช่น 45%, 100%, 120%) สามารถสะสมเกิน 100% ได้ตามจำนวนก้าวเดินจริง | อัปเดตแบบ Real-time ตามจำนวนก้าวเดินจริง |
| ตัวเลขก้าวเดินปัจจุบัน | ข้อความ | จำนวนก้าวปัจจุบันเทียบเป้าหมาย (เช่น "0 / 10,000 ก้าว" โดย 10,000 ก้าว เป็นค่าเริ่มต้น DEFAULT_DAILY_GOAL) | อัปเดตอัตโนมัติจากเซนเซอร์ (Passive Tracking) |
| ปุ่มตั้งเป้าหมาย | ปุ่ม | "ตั้งเป้าหมาย" | เปิดหน้า S-2 หน้าตั้งเป้าหมายประจำวัน |
| ปุ่มดูรายงานรายเดือน | ปุ่ม | "รายงานประจำเดือน" | เปิดหน้า S-3 หน้าสรุปผลรายเดือนและส่งออกรายงาน |
| ป๊อปอัปแจ้งเตือนสิทธิ์ (Permission/Hardware Error) | ป๊อปอัป | "ไม่สามารถเข้าถึงเซนเซอร์นับก้าวได้ กรุณาเปิดสิทธิ์ในการตั้งค่าเครื่อง" | ปุ่ม "ไปที่การตั้งค่า" (พาไปหน้า Settings ของเครื่อง) |

### S-2 หน้าตั้งเป้าหมายประจำวัน
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| ตัวเลือกกลุ่มทั่วไป | ตัวเลือก (Radio) | "6,000 ก้าว", "7,000 ก้าว", "8,000 ก้าว" | เลือกเป้าหมายกลุ่มทั่วไป |
| ตัวเลือกกลุ่มควบคุมน้ำหนัก | ตัวเลือก (Radio) | "9,000 ก้าว", "10,000 ก้าว (ค่าเริ่มต้น / DEFAULT_DAILY_GOAL)", "11,000 ก้าว", "12,000 ก้าว" | เลือกเป้าหมายกลุ่มควบคุมน้ำหนัก (โดย 10,000 ก้าว เป็นค่าเริ่มต้นระบบที่ถูกเลือกไว้ล่วงหน้าสำหรับผู้ใช้ใหม่) |
| ตัวเลือกกลุ่มนักกีฬา | ตัวเลือก (Radio) | "13,000 ก้าว", "14,000 ก้าว", "15,000 ก้าว" | เลือกเป้าหมายกลุ่มนักกีฬา |
| ปุ่มบันทึก | ปุ่ม | "บันทึก" | บันทึกค่าเป้าหมายใหม่ (อ้างอิง AC-2, AC-3, AC-4) |
| ปุ่มย้อนกลับ | ปุ่ม | "ย้อนกลับ" | กลับไปหน้า S-1 |
| Toast ข้อความแจ้งเตือน | ข้อความลอย | "คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวัน" | แสดงเมื่อพยายามบันทึกขณะปุ่ม Disabled (เกินโควต้า 1 ครั้ง/วัน) |

### S-3 หน้าสรุปผลรายเดือนและส่งออกรายงาน
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| ข้อมูลสรุปรายเดือน | ข้อความ | ก้าวเดินรวม, น้ำดื่มรวม, ค่าเฉลี่ยรายวัน, จำนวนวันที่ทำเป้าหมายสำเร็จ | แสดงข้อมูลจากฐานข้อมูล |
| ปุ่มส่งออกรายงาน (Export PNG) | ปุ่ม | "ส่งออกรายงาน (PNG)" | สร้างและดาวน์โหลด/บันทึกภาพ PNG 1 หน้าถ้วนเข้าเครื่อง |
| ปุ่มย้อนกลับ | ปุ่ม | "ย้อนกลับ" | กลับไปหน้า S-1 |

## 3. ขั้นตอนการใช้งาน (happy path)

1. **เปิดแอปครั้งแรก:** ผู้ใช้เปิดแอป PetPal Health ระบบแสดงหน้าขอสิทธิ์เซนเซอร์นับก้าว ผู้ใช้กด "อนุญาต" ระบบเริ่มบันทึกก้าวเดินแบบ Passive และแสดงหน้าหลัก (S-1) โดยแสดงจำนวนก้าวเป็น 0 เทียบเป้าหมายเริ่มต้น 10,000 ก้าว ("0 / 10,000 ก้าว"), % Goal เป็น 0%, และแสดงรูปร่างสัตว์เลี้ยงเริ่มต้น "อ้วนอืด (FAT)"
2. **การนับก้าวอัตโนมัติ:** เมื่อผู้ใช้เคลื่อนไหวร่างกาย ระบบนับก้าวเดินอัตโนมัติและอัปเดตตัวเลขก้าวเดิน หลอดพลังงาน และรูปร่างสัตว์เลี้ยงบนหน้า S-1 แบบ Real-time ตามเงื่อนไข % Goal (เมื่อเดินเกิน 100% ตัวเลขและหลอดพลังงานคำนวณตามจริง เช่น 120% และสัตว์เลี้ยงคงสถานะสูงสุด "มีกล้ามขา (MUSCLE)")
3. **การตั้งเป้าหมาย:** ผู้ใช้กดปุ่ม "ตั้งเป้าหมาย" ในหน้า S-1 เพื่อเข้าสู่หน้า S-2 โดยระบบแสดงตัวเลือก 3 กลุ่ม (10 ค่า) พร้อมเลือกค่าเริ่มต้น 10,000 ก้าว (DEFAULT_DAILY_GOAL) ไว้ล่วงหน้า ผู้ใช้สามารถเลือกเป้าหมายที่ต้องการ (เช่น 8,000 ก้าว) แล้วกด "บันทึก" ระบบบันทึกค่าเป้าหมายใหม่ทันทีและพาผู้ใช้กลับสู่หน้า S-1
4. **การส่งออกรายงาน:** ผู้ใช้กดปุ่ม "รายงานประจำเดือน" ในหน้า S-1 เพื่อเข้าสู่หน้า S-3 จากนั้นกดปุ่ม "ส่งออกรายงาน (PNG)" ระบบสร้างภาพ PNG รวมข้อมูล 4 ตัวแปร (ก้าวเดินรวม, น้ำดื่มรวม, ค่าเฉลี่ยรายวัน, วันที่สำเร็จเป้าหมาย) และบันทึกเข้าเครื่องสำเร็จ

## 4. สถานะของหน้าจอ

| หน้าจอ | สถานะ | เงื่อนไขที่ทำให้เกิด | สิ่งที่แสดง |
|---|---|---|---|
| S-1 | ปกติ | แอปทำงานปกติและได้รับสิทธิ์เซนเซอร์นับก้าว | แสดงจำนวนก้าว % พลังงาน (เกิน 100% ได้) และรูปร่างสัตว์เลี้ยงตามเกณฑ์ |
| S-1 | ว่าง / เริ่มต้นวันใหม่ | เวลาถึง 05:00:00 น. หรือเปิดแอปวันแรก | จำนวนก้าวแสดงเป็น "0 / 10,000 ก้าว" (หรือเป้าหมายที่ตั้งไว้), % Goal เป็น 0%, สัตว์เลี้ยงแสดงสถานะเริ่มต้น "อ้วนอืด (FAT)" |
| S-1 | ผิดพลาด (Permission/Hardware Denied) | ผู้ใช้ปฏิเสธสิทธิ์เซนเซอร์ (EC-1) หรืออุปกรณ์ไม่มีฮาร์ดแวร์เซนเซอร์ (EC-6) | แสดง Pop-up แจ้งเตือนข้อจำกัดและปุ่ม "ไปที่การตั้งค่า" พร้อมล็อกฟังก์ชันนับก้าว |
| S-2 | ปกติ | ผู้ใช้ยังไม่ได้เปลี่ยนเป้าหมายในวันนั้น (โควต้าเหลือ 1 ครั้ง) | แสดงตัวเลือกเป้าหมาย 3 กลุ่ม (10 ตัวเลือก) โดยมี 10,000 ก้าว (DEFAULT_DAILY_GOAL) ถูกเลือกไว้ล่วงหน้า (Pre-selected) และปุ่ม "บันทึก" ใช้งานได้ปกติ |
| S-2 | ผิดพลาด (Disabled State) | ผู้ใช้พยายามเปลี่ยนเป้าหมายซ้ำภายในวันเดียวกัน (ก่อน 05:00 น.) | ปุ่มบันทึกถูก Disabled (สีเทาจาง) และแสดง Toast Message: *"คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวัน"* |
| S-3 | ปกติ | มีข้อมูลสรุปรายเดือนในระบบ | แสดงข้อมูลสรุป 4 ตัวแปรและปุ่ม "ส่งออกรายงาน (PNG)" |
| S-3 | ว่าง | ไม่มีข้อมูลสถิติในเดือนนั้น | แสดงข้อความ "ยังไม่มีข้อมูลสรุปสำหรับเดือนนี้" และปุ่มส่งออกรายงานถูกปิดการใช้งาน |

## 5. ไฟล์ภาพ assets

| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายภาพ |
|---|---|---|
| assets/images/pet_fat.png | S-1 (สถานะ: < 35%) | ภาพสัตว์เลี้ยงเสมือนจริงรูปร่างอ้วนอืด (FAT) |
| assets/images/pet_chubby.png | S-1 (สถานะ: 35% - 69.99%) | ภาพสัตว์เลี้ยงเสมือนจริงรูปร่างจ่ำม่ำ (CHUBBY) |
| assets/images/pet_lean.png | S-1 (สถานะ: 70% - 99.99%) | ภาพสัตว์เลี้ยงเสมือนจริงหุ่นลีน สมส่วน (LEAN) |
| assets/images/pet_muscle.png | S-1 (สถานะ: >= 100%) | ภาพสัตว์เลี้ยงเสมือนจริงมีกล้ามขา (MUSCLE) |
| assets/images/icon_steps.png | S-1 (องค์ประกอบก้าวเดิน) | ไอคอนสัญลักษณ์รูปฝ่าเท้า/ก้าวเดิน |
| assets/images/bg_report_export.png | S-3 (เทมเพลตภาพ PNG) | เทมเพลตพื้นหลังสำหรับสร้างภาพรายงานสรุปผลรายเดือน PNG 1 หน้าถ้วน |

*หมายเหตุ: ชื่อไฟล์ภาพข้างต้นเป็นข้อเสนอเพื่อใช้ในการพัฒนา UI เมื่อยังไม่มีไฟล์จริงจากทีม Asset*

## 6. ข้อเสนอแนะเพิ่มเติมจาก Design สำหรับการพัฒนา
1. **การแสดงผลตัวเลือกเป้าหมายในหน้า S-2 และค่าเริ่มต้นระบบ (DEFAULT_DAILY_GOAL)**: ออกแบบเป็นกลุ่ม Radio Buttons แยก 3 กลุ่มชัดเจน (กลุ่มทั่วไป 6,000-8,000, กลุ่มควบคุมน้ำหนัก 9,000-12,000, กลุ่มนักกีฬา 13,000-15,000) โดยกำหนดค่าเริ่มต้นที่ 10,000 ก้าว (`DEFAULT_DAILY_GOAL` ในกลุ่มควบคุมน้ำหนัก) ถูกเลือกไว้ล่วงหน้า (Pre-selected) สำหรับผู้ใช้ใหม่ เพื่อให้การตั้งค่าเริ่มต้นสอดคล้องกันทุกส่วนของระบบ
2. **การจัดการข้อผิดพลาดขณะ Export PNG**: หากเกิดกรณีพื้นที่จัดเก็บในเครื่องเต็ม ให้แสดง Alert Pop-up แจ้งว่า *"ไม่สามารถบันทึกภาพได้เนื่องจากพื้นที่จัดเก็บข้อมูลไม่เพียงพอ"* เพื่อให้ผู้ใช้ทราบสถานะที่ชัดเจน

=== จบ docs/steps/ux-flow.md ===

=== docs/steps/game-rules.md ===
# กติกาเกม: การนับก้าวและการตั้งเป้าหมายประจำวัน (steps)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Senior PM · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ความหมาย | ค่า | หน่วย | อ้างถึง |
|---|---|---|---|---|
| DEFAULT_DAILY_GOAL | ค่าเป้าหมายก้าวเดินเริ่มต้นประจำวัน (กรณีผู้ใช้ยังไม่ได้กำหนดเอง) | 10,000 (ค่าเริ่มต้นแนะนำ กลุ่มควบคุมน้ำหนัก) | ก้าว | AC-2 |
| STEP_GOAL_OPTIONS_GENERAL | ตัวเลือกเป้าหมายกลุ่มทั่วไป | 6,000 / 7,000 / 8,000 | ก้าว | AC-2 |
| STEP_GOAL_OPTIONS_WEIGHT_CONTROL | ตัวเลือกเป้าหมายกลุ่มควบคุมน้ำหนัก | 9,000 / 10,000 / 11,000 / 12,000 | ก้าว | AC-2 |
| STEP_GOAL_OPTIONS_ATHLETE | ตัวเลือกเป้าหมายกลุ่มนักกีฬา | 13,000 / 14,000 / 15,000 | ก้าว | AC-2 |
| DAILY_GOAL_CHANGE_LIMIT | โควต้าสูงสุดในการเปลี่ยนเป้าหมายต่อวัน | 1 | ครั้ง/วัน | AC-3 |
| RESET_TIME_HOUR | เวลาตัดรอบสถิติจับเวลาประจำวัน (ชั่วโมง) | 05 | นาฬิกา | AC-4, AC-6 |
| RESET_TIME_MINUTE | เวลาตัดรอบสถิติจับเวลาประจำวัน (นาที) | 00 | นาที | AC-4, AC-6 |
| RESET_TIME_SECOND | เวลาตัดรอบสถิติจับเวลาประจำวัน (วินาที) | 00 | วินาที | AC-4, AC-6 |
| STEP_ACCURACY_THRESHOLD | เกณฑ์ความคลาดเคลื่อนสูงสุดที่ยอมรับได้จากฮาร์ดแวร์ | 5 | % | AC-1 |
| GOAL_PERCENTAGE_FAT_LIMIT | เกณฑ์สูงสุดของช่วงสถานะอ้วนอืด (ไม่รวมค่าน้อยกว่า) | 35 | % | AC-5 |
| GOAL_PERCENTAGE_CHUBBY_MIN | เกณฑ์ต่ำสุดของช่วงสถานะจ่ำม่ำ (รวมค่า) | 35 | % | AC-5 |
| GOAL_PERCENTAGE_CHUBBY_MAX | เกณฑ์สูงสุดของช่วงสถานะจ่ำม่ำ (ไม่รวมค่าน้อยกว่า) | 69.99 | % | AC-5 |
| GOAL_PERCENTAGE_LEAN_MIN | เกณฑ์ต่ำสุดของช่วงสถานะหุ่นลีน (สมส่วน) (รวมค่า) | 70 | % | AC-5 |
| GOAL_PERCENTAGE_LEAN_MAX | เกณฑ์สูงสุดของช่วงสถานะหุ่นลีน (สมส่วน) (ไม่รวมค่าน้อยกว่า) | 99.99 | % | AC-5 |
| GOAL_PERCENTAGE_MUSCLE_MIN | เกณฑ์ต่ำสุดของช่วงสถานะมีกล้ามขา (รวมค่า) | 100 | % | AC-5 |

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง

| สถานะ | ช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพ |
|---|---|---|
| อ้วนอืด (FAT) | น้อยกว่า 35% (< 35.00%) | assets/images/pet_fat.png |
| จ่ำม่ำ (CHUBBY) | ตั้งแต่ 35% ถึงน้อยกว่า 70% (รวม 35.00% ถึง 69.99%) | assets/images/pet_chubby.png |
| หุ่นลีน (สมส่วน) (LEAN) | ตั้งแต่ 70% ถึงน้อยกว่า 100% (รวม 70.00% ถึง 99.99%) | assets/images/pet_lean.png |
| มีกล้ามขา (MUSCLE) | 100% ขึ้นไป (รวม 100.00% ขึ้นไป) | assets/images/pet_muscle.png |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| คำนวณ % Goal เมื่อเป้าหมายคือ 8,000 ก้าว และเดินได้ 2,400 ก้าว | 2,400 ก้าว / เป้าหมาย 8,000 ก้าว | 30.00% (สถานะ: อ้วนอืด / FAT) | อ้าง AC-5 |
| คำนวณ % Goal เมื่อเป้าหมายคือ 8,000 ก้าว และเดินได้ 4,000 ก้าว | 4,000 ก้าว / เป้าหมาย 8,000 ก้าว | 50.00% (สถานะ: จ่ำม่ำ / CHUBBY) | อ้าง AC-5 |
| คำนวณ % Goal เมื่อเป้าหมายคือ 8,000 ก้าว และเดินได้ 6,000 ก้าว | 6,000 ก้าว / เป้าหมาย 8,000 ก้าว | 75.00% (สถานะ: หุ่นลีน / LEAN) | อ้าง AC-5 |
| คำนวณ % Goal เมื่อเป้าหมายคือ 8,000 ก้าว และเดินได้ 8,000 ก้าว | 8,000 ก้าว / เป้าหมาย 8,000 ก้าว | 100.00% (สถานะ: มีกล้ามขา / MUSCLE) | อ้าง AC-5 |
| ผู้ใช้เปลี่ยนเป้าหมายสำเร็จครั้งที่ 1 ในวันเดียวกัน | โควต้าเปลี่ยนเป้าหมายเหลือ 1 ครั้ง | โควต้าเปลี่ยนเป้าหมายเหลือ 0 ครั้ง (ปุ่มถูก Disabled) | อ้าง AC-3 |
| ถึงเวลาตัดรอบประจำวันเวลา 05:00:00 น. | จำนวนก้าวสะสมเดิม, % Goal เดิม | จำนวนก้าว = 0, % Goal = 0% | อ้าง AC-6 |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ที่ทดสอบได้ |
|---|---|
| ค่าเกินขอบบน (% Goal สูงกว่า 100% / เดินเกินเป้าหมาย) | หลอดพลังงานและค่า % Goal หยุดสะสมสูงสุดที่ 100% (ตามข้อกำหนดสะสมสูงสุดไม่เกิน 100%) โดยสัตว์เลี้ยงคงสถานะ "มีกล้ามขา" (MUSCLE) ขณะที่ตัวเลขจำนวนก้าวเดินจริงยังคงแสดงค่าตามการนับจริง (เช่น "12,000 / 10,000 ก้าว") |
| ค่าต่ำกว่าขอบล่าง (จำนวนก้าวติดลบหรือ 0) | ระบบแสดงจำนวนก้าวเป็น 0 และ % Goal เป็น 0% พร้อมแสดงสถานะ "อ้วนอืด" (FAT) |
| การเปลี่ยนเป้าหมายซ้ำในวันเดียวกัน (ก่อน 05:00 น.) | ปุ่มบันทึกเป้าหมายถูกเปลี่ยนเป็นสถานะ Disabled (สีเทาจาง) และแสดง Toast Message: *"คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวัน"* ทันทีเมื่อผู้ใช้พยายามกด |
| การเปลี่ยนเป้าหมายหลังเวลา 05:00 น. | ค่าเป้าหมายใหม่จะถูกบันทึกไว้ในฐานข้อมูล แต่จะยังไม่มีผลกับรอบวันปัจจุบัน โดยรอบวันปัจจุบันยังคงใช้เป้าหมายเดิมจนกระทั่งถึงเวลา 05:00:00 น. ของวันถัดไปจึงจะเริ่มใช้เป้าหมายใหม่ |
| การปฏิเสธสิทธิ์เซนเซอร์นับก้าว (EC-1) และไม่มีฮาร์ดแวร์ (EC-6) | ระบบล็อกฟังก์ชันนับก้าวทั้งหมด แสดง Pop-up แจ้งเตือนข้อจำกัดของอุปกรณ์ และแสดงปุ่ม Shortcut พาผู้ใช้ไปหน้า Settings ของเครื่อง |
| แบตเตอรี่หมดหรือเครื่องดับระหว่างวัน (EC-2) | ระบบดึงข้อมูลก้าวล่าสุดที่มีการบันทึกสำรองไว้ใน Local Storage มาแสดงผลโดยอัตโนมัติทันทีเมื่อเปิดแอปพลิเคชันครั้งถัดไป |
| การปรับเวลาในเครื่องย้อนหลัง (EC-3) | ระบบบังคับใช้เวลาอ้างอิงตาม Network/Server Time เท่านั้น เพื่อป้องกันการปรับเวลารีเซ็ตสถิติย้อนหลัง |
| การสลับอุปกรณ์ระหว่างวัน (EC-4) | ระบบทำการ Sync เป้าหมายล่าสุดและดึงสถิติก้าวเดินสะสมเฉพาะของวันนั้นมาจาก Server โดยไม่นับก้าวซ้ำซ้อน |
| การเปิดแอปค้างไว้ข้ามช่วงเวลา 05:00 น. (Foreground Crossing / EC-5) | ระบบดำเนินการตัดรอบสถิติ ทำการรีเซ็ตหลอดพลังงานและจำนวนก้าวเป็น 0 และเริ่มรอบวันใหม่อัตโนมัติทันทีบนหน้าจอโดยผู้ใช้ไม่ต้องทำการ Restart แอปพลิเคชัน |

## 5. ข้อเสนอแนะเพิ่มเติมจาก Design สำหรับการพัฒนา
1. **ค่าเริ่มต้นเป้าหมาย (`DEFAULT_DAILY_GOAL`)**: แนะนำใช้ 10,000 ก้าว (ค่ากึ่งกลางของกลุ่มควบคุมน้ำหนัก) เป็นค่า Default เมื่อผู้ใช้เปิดแอปครั้งแรก
2. **ตัวเลือกเป้าหมายในหน้า S-2**: ออกแบบเป็น Radio Buttons ครบทั้ง 10 ค่าตามกลุ่ม (6,000 - 8,000 / 9,000 - 12,000 / 13,000 - 15,000) เพื่อความสะดวกในการใช้งานของผู้ใช้และลดความผิดพลาดในการกรอกข้อมูล
3. **การจัดการ Storage เต็มขณะ Export PNG**: หากเกิดกรณีพื้นที่จัดเก็บเต็ม แนะนำให้แสดง Alert Pop-up แจ้งว่า *"ไม่สามารถบันทึกภาพได้เนื่องจากพื้นที่จัดเก็บข้อมูลไม่เพียงพอ"* เพื่อแจ้งผู้ใช้ทราบอย่างชัดเจน

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
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | PASS | เอกสาร requirements.md มีครบถ้วนทั้งสรุปฟีเจอร์ Pet Status Mapping, User stories, Acceptance criteria (AC-1 ถึง AC-7), Edge cases (EC-1 ถึง EC-6), สิ่งที่ไม่ทำ และข้อมูลที่ใช้ | ไม่ใช่ |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | FAIL | พบความขัดแย้งทางตรรกะและข้อกำหนดระหว่าง requirements.md, ux-flow.md และ game-rules.md เกี่ยวกับการสะสมค่าพลังงาน (% Goal) ที่เกิน 100% | ใช่ เนื่องจากข้อกำหนดเรื่อง % Goal เกิน 100% ขัดแย้งระหว่าง Requirement/UX Flow กับ Game Rules |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | FAIL | พบความขัดแย้งของข้อกำหนดเงื่อนไข (% Goal สูงกว่า 100%) ระหว่าง requirements.md/ux-flow.md กับ game-rules.md รวมถึงชื่อสถานะและตัวเลขค่าเริ่มต้นที่ระบุสอดคล้องกันแต่ติดปัญหาเงื่อนไขการสะสมพลังงาน | ใช่ ต้องแก้ไขข้อกำหนดเรื่องการหยุดสะสมหลอดพลังงานที่ 100% ใน game-rules.md ให้ตรงกับ UX/Requirements ที่ระบุว่าสะสมเกิน 100% ได้ตามจริง |
| C-04 | ขั้นตอนใช้งานและ Edge Cases เพียงพอ | PASS | ขั้นตอนการใช้งาน (Happy path) ใน ux-flow.md และ Edge cases (EC-1 ถึง EC-6) ครอบคลุมการทำงานทั่วไปและกรณีข้อผิดพลาดที่สำคัญ | ไม่ใช่ |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | PASS | เอกสารทั้ง 3 ฉบับระบุสถานะ "พร้อมรีวิว" และไม่มี Open Questions ค้างในตัวเอกสาร | ไม่ใช่ |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ทุกข้อค้นพบอ้างอิงตรงจากเอกสาร requirements.md, ux-flow.md และ game-rules.md | ไม่ใช่ |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | บทสรุป ตารางปัญหา และคำแนะนำในรีวิวนี้สอดคล้องกับหลักฐานที่ตรวจพบทั้งหมด | ไม่ใช่ |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีรายงานผลการตรวจรอบก่อนหน้าสำหรับการเปรียบเทียบ | ไม่ใช่ เนื่องจากไม่มีข้อมูลรอบก่อนให้ตรวจซ้ำ |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|
| ISS-01 | docs/steps/game-rules.md | หัวข้อ 4. พฤติกรรมที่ขอบเขต / แถวที่ 1 | ระบุว่า *"ค่าเกินขอบบน (% Goal สูงกว่า 100% / เดินเกินเป้าหมาย): หลอดพลังงานและค่า % Goal หยุดสะสมสูงสุดที่ 100%..."* ซึ่งขัดแย้งกับ docs/steps/requirements.md (AC-5, AC-6) และ docs/steps/ux-flow.md (S-1 องค์ประกอบแถบพลังงาน และหัวข้อ 3 ขั้นตอนการใช้งาน ข้อ 2) ที่ระบุว่าสามารถสะสมเกิน 100% ได้ตามจำนวนก้าวเดินจริง (เช่น 120%) และสัตว์เลี้ยงคงสถานะ "มีกล้ามขา" | ทำให้ทีมพัฒนาเกิดความสับสนว่าจะต้องหยุดหลอดพลังงานที่ 100% ตาม Game Rules หรือปล่อยให้เกิน 100% ตาม Requirements และ UX Flow | ใช่ | แก้ไข docs/steps/game-rules.md หัวข้อ 4 แถวที่ 1 ให้สอดคล้องกับ Requirements และ UX Flow โดยระบุว่าหลอดพลังงานและค่า % Goal สามารถสะสมเกิน 100% ตามจริงได้ แต่สถานะสัตว์เลี้ยงจะถูกรักษาสถานะสูงสุดไว้ที่ "มีกล้ามขา" (MUSCLE) | ใช่ ทีม Product/Design ต้องปรับแก้เอกสาร game-rules.md ให้ตรงกับ requirements.md และ ux-flow.md |

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|
| - | - | ไม่มีข้อมูลสำหรับเปรียบเทียบ | ไม่มีรายงานการตรวจรอบก่อนหน้า | ไม่ต้องดำเนินการ |

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- ไม่มีรายการ Open Questions ค้างในเอกสารต้นทางทั้ง 3 ฉบับ (ทุกฉบับระบุสถานะ "พร้อมรีวิว" และไม่มีการตั้งหัวข้อ Open Questions ไว้) หลักฐานยืนยันจากส่วนหัวของเอกสาร requirements.md, ux-flow.md และ game-rules.md

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|
| ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่ต้องดำเนินการ |

## 7. ข้อจำกัดของการรีวิว
- เอกสารที่ตรวจจริง: docs/steps/requirements.md, docs/steps/ux-flow.md, docs/steps/game-rules.md
- ไฟล์ที่ไม่ได้ตรวจ: ไม่มีเอกสารการตรวจรอบก่อนหน้า (Previous review report) และไม่มีไฟล์ Source Code หรือ Asset จริง ทำให้ไม่สามารถยืนยันการทำงานในระดับโค้ดได้

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: NEEDS_FIX
- Agent recommendation: ต้องแก้
- Blocking issues remaining: ISS-01 (ความขัดแย้งของข้อกำหนด % Goal เกิน 100% ระหว่าง Game Rules กับ Requirements และ UX Flow)
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: ผลการตรวจพบความขัดแย้งอย่างชัดเจนในข้อกำหนดการแสดงผล % Goal เกิน 100% ระหว่าง docs/steps/game-rules.md และเอกสาร Requirements/UX Flow ซึ่งจะทำให้ทีมพัฒนาไม่สามารถตัดสินใจเขียนโค้ดได้อย่างถูกต้อง จึงจำเป็นต้องให้ทีมแก้ไขเอกสารให้สอดคล้องกันก่อนส่งมอบงานให้ Dev
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
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | PASS | เอกสาร requirements.md มีครบถ้วนทั้งสรุปฟีเจอร์ Pet Status Mapping, User stories, Acceptance criteria (AC-1 ถึง AC-7), Edge cases (EC-1 ถึง EC-6), สิ่งที่ไม่ทำ และข้อมูลที่ใช้ | ไม่ใช่ |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | FAIL | พบความขัดแย้งทางตรรกะและข้อกำหนดระหว่าง requirements.md, ux-flow.md และ game-rules.md เกี่ยวกับการสะสมค่าพลังงาน (% Goal) ที่เกิน 100% | ใช่ เนื่องจากข้อกำหนดเรื่อง % Goal เกิน 100% ขัดแย้งระหว่าง Requirement/UX Flow กับ Game Rules |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | FAIL | พบความขัดแย้งของข้อกำหนดเงื่อนไข (% Goal สูงกว่า 100%) ระหว่าง requirements.md/ux-flow.md กับ game-rules.md รวมถึงชื่อสถานะและตัวเลขค่าเริ่มต้นที่ระบุสอดคล้องกันแต่ติดปัญหาเงื่อนไขการสะสมพลังงาน | ใช่ ต้องแก้ไขข้อกำหนดเรื่องการหยุดสะสมหลอดพลังงานที่ 100% ใน game-rules.md ให้ตรงกับ UX/Requirements ที่ระบุว่าสะสมเกิน 100% ได้ตามจริง |
| C-04 | ขั้นตอนใช้งานและ Edge Cases เพียงพอ | PASS | ขั้นตอนการใช้งาน (Happy path) ใน ux-flow.md และ Edge cases (EC-1 ถึง EC-6) ครอบคลุมการทำงานทั่วไปและกรณีข้อผิดพลาดที่สำคัญ | ไม่ใช่ |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | PASS | เอกสารทั้ง 3 ฉบับระบุสถานะ "พร้อมรีวิว" และไม่มี Open Questions ค้างในตัวเอกสาร | ไม่ใช่ |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ทุกข้อค้นพบอ้างอิงตรงจากเอกสาร requirements.md, ux-flow.md และ game-rules.md | ไม่ใช่ |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | บทสรุป ตารางปัญหา และคำแนะนำในรีวิวนี้สอดคล้องกับหลักฐานที่ตรวจพบทั้งหมด | ไม่ใช่ |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีรายงานผลการตรวจรอบก่อนหน้าสำหรับการเปรียบเทียบ | ไม่ใช่ เนื่องจากไม่มีข้อมูลรอบก่อนให้ตรวจซ้ำ |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|
| ISS-01 | docs/steps/game-rules.md | หัวข้อ 4. พฤติกรรมที่ขอบเขต / แถวที่ 1 | ระบุว่า *"ค่าเกินขอบบน (% Goal สูงกว่า 100% / เดินเกินเป้าหมาย): หลอดพลังงานและค่า % Goal หยุดสะสมสูงสุดที่ 100%..."* ซึ่งขัดแย้งกับ docs/steps/requirements.md (AC-5, AC-6) และ docs/steps/ux-flow.md (S-1 องค์ประกอบแถบพลังงาน และหัวข้อ 3 ขั้นตอนการใช้งาน ข้อ 2) ที่ระบุว่าสามารถสะสมเกิน 100% ได้ตามจำนวนก้าวเดินจริง (เช่น 120%) และสัตว์เลี้ยงคงสถานะ "มีกล้ามขา" | ทำให้ทีมพัฒนาเกิดความสับสนว่าจะต้องหยุดหลอดพลังงานที่ 100% ตาม Game Rules หรือปล่อยให้เกิน 100% ตาม Requirements และ UX Flow | ใช่ | แก้ไข docs/steps/game-rules.md หัวข้อ 4 แถวที่ 1 ให้สอดคล้องกับ Requirements และ UX Flow โดยระบุว่าหลอดพลังงานและค่า % Goal สามารถสะสมเกิน 100% ตามจริงได้ แต่สถานะสัตว์เลี้ยงจะถูกรักษาสถานะสูงสุดไว้ที่ "มีกล้ามขา" (MUSCLE) | ใช่ ทีม Product/Design ต้องปรับแก้เอกสาร game-rules.md ให้ตรงกับ requirements.md และ ux-flow.md |

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|
| - | - | ไม่มีข้อมูลสำหรับเปรียบเทียบ | ไม่มีรายงานการตรวจรอบก่อนหน้า | ไม่ต้องดำเนินการ |

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- ไม่มีรายการ Open Questions ค้างในเอกสารต้นทางทั้ง 3 ฉบับ (ทุกฉบับระบุสถานะ "พร้อมรีวิว" และไม่มีการตั้งหัวข้อ Open Questions ไว้) หลักฐานยืนยันจากส่วนหัวของเอกสาร requirements.md, ux-flow.md และ game-rules.md

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|
| ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่ต้องดำเนินการ |

## 7. ข้อจำกัดของการรีวิว
- เอกสารที่ตรวจจริง: docs/steps/requirements.md, docs/steps/ux-flow.md, docs/steps/game-rules.md
- ไฟล์ที่ไม่ได้ตรวจ: ไม่มีเอกสารการตรวจรอบก่อนหน้า (Previous review report) และไม่มีไฟล์ Source Code หรือ Asset จริง ทำให้ไม่สามารถยืนยันการทำงานในระดับโค้ดได้

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: NEEDS_FIX
- Agent recommendation: ต้องแก้
- Blocking issues remaining: ISS-01 (ความขัดแย้งของข้อกำหนด % Goal เกิน 100% ระหว่าง Game Rules กับ Requirements และ UX Flow)
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: ผลการตรวจพบความขัดแย้งอย่างชัดเจนในข้อกำหนดการแสดงผล % Goal เกิน 100% ระหว่าง docs/steps/game-rules.md และเอกสาร Requirements/UX Flow ซึ่งจะทำให้ทีมพัฒนาไม่สามารถตัดสินใจเขียนโค้ดได้อย่างถูกต้อง จึงจำเป็นต้องให้ทีมแก้ไขเอกสารให้สอดคล้องกันก่อนส่งมอบงานให้ Dev
~~~~
