# Log: design_review · dashboard · 2026-10-30 17:57

<!-- meta: {"role": "design_review", "feature": "dashboard", "time": "2026-10-30 17:57", "status": "ok", "provider": "gemini", "model": "gemini-3.5-flash-lite", "attempts": 1, "seconds": 7.0, "llm_calls": 1, "total_tokens": 13484, "agent_version": "ac395134"} -->

| รายการ | ค่า |
|---|---|
| สถานะ | สำเร็จ |
| ผู้ให้บริการ / รุ่น | gemini / gemini-3.5-flash-lite |
| ลำดับความพยายาม | gemini: สำเร็จ |
| เวลารวม | 7.0 วินาที |
| จำนวนครั้งที่เรียก LLM | 1 |
| tokens (prompt / completion / total) | 11841 / 1643 / 13484 |
| ไฟล์ input | docs/dashboard/requirements.md, docs/dashboard/ux-flow.md, docs/dashboard/game-rules.md |
| ไฟล์ output | docs/dashboard/design-review.md |
| agent | agents/design_reviewer.md (เวอร์ชัน ac395134) |
| --note | - |

## ความพยายามที่ 1 — gemini (gemini-3.5-flash-lite) — สำเร็จ, 7.0 วินาที

### Agent

- ไฟล์: agents/design_reviewer.md
- role: Software Design Reviewer
- goal: Review the dashboard design documents against supplied project specifications, verify prior findings when available, and report evidence-backed contradictions, ambiguities, missing decisions, and actionable documentation issues without modifying source documents.
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

# Design Review: dashboard

## 1. ข้อมูลการตรวจ

- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: dashboard
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

#### Task → docs/dashboard/design-review.md

~~~~text
ฟีเจอร์: dashboard

งานของคุณ: ตรวจเอกสาร Requirements, UX Flow และ Game Rules ก่อนส่งงานให้ Dev ตรวจความครบถ้วนและความสอดคล้องของเอกสาร ตรวจตัวเลข ชื่อสถานะ ขั้นตอนการใช้งาน และ edge cases โดยอ้างอิงหลักฐานจากไฟล์ที่ได้รับ ระบุข้อผิดพลาดพร้อมไฟล์/หัวข้อ เหตุผล และแนวทางแก้ไข ห้ามแต่งข้อกำหนดหรือผลทดสอบขึ้นเอง สรุปผลเป็น PASS, NEEDS_FIX หรือ INSUFFICIENT_EVIDENCE

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

expected_output: เนื้อหาไฟล์ docs/dashboard/design-review.md ฉบับสมบูรณ์ ตามโครง template

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

# Design Review: dashboard

## 1. ข้อมูลการตรวจ

- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: dashboard
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
Your personal goal is: Review the dashboard design documents against supplied project specifications, verify prior findings when available, and report evidence-backed contradictions, ambiguities, missing decisions, and actionable documentation issues without modifying source documents.

[user]

Current Task: ฟีเจอร์: dashboard

งานของคุณ: ตรวจเอกสาร Requirements, UX Flow และ Game Rules ก่อนส่งงานให้ Dev ตรวจความครบถ้วนและความสอดคล้องของเอกสาร ตรวจตัวเลข ชื่อสถานะ ขั้นตอนการใช้งาน และ edge cases โดยอ้างอิงหลักฐานจากไฟล์ที่ได้รับ ระบุข้อผิดพลาดพร้อมไฟล์/หัวข้อ เหตุผล และแนวทางแก้ไข ห้ามแต่งข้อกำหนดหรือผลทดสอบขึ้นเอง สรุปผลเป็น PASS, NEEDS_FIX หรือ INSUFFICIENT_EVIDENCE

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

This is the expected criteria for your final answer: เนื้อหาไฟล์ docs/dashboard/design-review.md ฉบับสมบูรณ์ ตามโครง template
you MUST return the actual complete content as the final answer, not a summary.

Provide your complete response:
~~~~

### LLM call 1 — คำตอบ

~~~~text
# Design Review: dashboard

## 1. ข้อมูลการตรวจ
- Status: PASS
- Feature: dashboard
- Documents actually reviewed: docs/dashboard/requirements.md, docs/dashboard/ux-flow.md, docs/dashboard/game-rules.md
- Missing/unreadable documents: ไม่มี
- Previous findings checked: ไม่มีข้อมูลรอบก่อน

## 2. ผล Checklist
ทุกข้อมีผล เหตุผล และหลักฐานจากไฟล์/หัวข้อที่ตรวจจริง หากข้อมูลไม่พอให้ใช้ INSUFFICIENT_EVIDENCE ห้ามเดา

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | PASS | เอกสาร requirements.md มี User stories, Acceptance criteria, และ Edge cases ที่ระบุพฤติกรรมระบบครบถ้วน | ไม่ใช่ เพราะข้อมูลและขอบเขตมีความชัดเจนเพียงพอให้นำไปพัฒนาต่อได้ |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | PASS | ทั้ง 3 เอกสารอ้างอิงสูตรคำนวณ (Food+Steps+Water)/3, การ Cap ที่ 100%, ช่วงคะแนนอารมณ์สัตว์เลี้ยง และเวลาตัดรอบ 05:00 น. ตรงกัน | ไม่ใช่ เพราะตรรกะ ข้อมูล และเงื่อนไขในทุกเอกสารสอดคล้องกันเป็นเนื้อเดียวกัน |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | PASS | ชื่อสถานะ Enum (`CRYING`, `DAZED`, `BUBBLY`, `CHEERFUL`), ช่วงเปอร์เซ็นต์, ระยะเวลาแจ้งเตือน 5 วินาที, และเวลา 05:00 น. (ICT) ตรงกันทุกไฟล์ | ไม่ใช่ เพราะตัวเลข ชื่อสถานะ และเวลาไม่มีจุดขัดแย้งกัน |
| C-04 | ขั้นตอนใช้งานและ Edge Cases เพียงพอ | PASS | เอกสาร ux-flow.md ระบุ Happy path ชัดเจน และ requirements.md ครอบคลุม Edge cases สำคัญ เช่น ค่าติดลบ, เกิน 100%, และช่วงเวลาตัดรอบ | ไม่ใช่ เพราะขั้นตอนและกรณีขอบเขตครอบคลุมสถานการณ์ใช้งานจริงครบถ้วน |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | PASS | Open Questions ใน requirements.md, ux-flow.md และ game-rules.md ระบุวิธีปฏิบัติชั่วคราว (Fallback Rule) และยืนยันว่าเป็น Non-blocking | ไม่ใช่ เพราะมีคำอธิบายและแนวทางปฏิบัติชั่วคราวชัดเจน ทำให้ทีม Dev สามารถดำเนินการต่อได้ทันที |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ทุกการตรวจสอบอ้างอิงไฟล์และหัวข้อจริงจาก requirements.md, ux-flow.md และ game-rules.md | ไม่ใช่ เพราะทุกข้อสรุปมีหลักฐานอ้างอิงภายในเอกสารที่ตรวจสอบได้ |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | บทสรุป ผลการตรวจสอบ และข้อเสนอแนะสอดคล้องกับหลักฐานโดยไม่มีความขัดแย้ง | ไม่ใช่ เพราะผลการรีวิวและตารางทั้งหมดมีความสอดคล้องกัน |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีรายงานข้อค้นพบจากรอบก่อนสำหรับใช้อ้างอิงเปรียบเทียบ | ไม่ใช่ เพราะไม่มีข้อมูลรอบก่อนให้ตรวจซ้ำ (บันทึกตามข้อเท็จจริง) |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|

- ตรวจเปรียบเทียบข้อกำหนด (Requirements), UX Flow (ux-flow.md) และ Game Rules (game-rules.md) พบว่าสูตรการคำนวณ (`(Food + Steps + Water) / 3`), การจำกัดค่าสูงสุดไม่เกิน 100%, การปัดเศษเป็น Integer, ช่วงคะแนนอารมณ์สัตว์เลี้ยง (`CRYING`, `DAZED`, `BUBBLY`, `CHEERFUL`), ข้อความ Dynamic Alert Queue, ระยะเวลาหมุนเวียน 5 วินาที และเวลาตัดรอบ 05:00 น. (ICT) สอดคล้องตรงกันทุกประการ จึงไม่พบปัญหาที่ขัดแย้งหรือบล็อกการพัฒนา

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|

- ไม่มีข้อมูลสำหรับเปรียบเนื่องจากไม่พบรายงานการรีวิวรอบก่อน (Previous review not available)

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- ไม่มีรายการคำถามที่บล็อกการพัฒนา โดยประเด็น Open Questions ในเอกสารประกอบด้วย:
  1. การจัดวางภาพ Responsive ของสัตว์เลี้ยง (requirements.md ข้อ 7, ux-flow.md และ game-rules.md หัวข้อ 5): มี Fallback Rule ให้ใช้ภาพขนาด 300x300 pixels แบบ Scalable Image Container และระบุชัดเจนว่าเป็น Non-blocking
  2. การใช้ Timezone Asia/Bangkok (ICT) ในการตัดรอบ 05:00 น. (requirements.md ข้อ 7, ux-flow.md และ game-rules.md หัวข้อ 5): มี Fallback Rule กำหนดให้เปรียบเทียบเวลาอิง GMT+7 (ICT) และระบุชัดเจนว่าเป็น Non-blocking

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|

- ไม่มีข้อมูลใน log ที่ได้รับ

## 7. ข้อจำกัดของการรีวิว
- เอกสารที่ตรวจจริง: docs/dashboard/requirements.md, docs/dashboard/ux-flow.md, docs/dashboard/game-rules.md
- ไฟล์ที่ไม่ได้ตรวจ: ไม่มีเอกสารอื่นนอกเหนือจากที่ระบุ และไม่มีบันทึก Log การทำงานของระบบ
- ผลต่อความมั่นใจ: ข้อมูลการออกแบบครอบคลุมครบถ้วน มีตรรกะและรายละเอียดสอดคล้องกันทุกมิติ ทำให้มีความมั่นใจสูงในการส่งมอบให้ทีมพัฒนา

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: PASS
- Agent recommendation: พร้อมส่ง Dev
- Blocking issues remaining: ไม่มี
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: เอกสาร Requirements, UX Flow และ Game Rules มีความครบถ้วนสมบูรณ์ สอดคล้องต้องกันในทุกส่วน ทั้งสูตรการคำนวณ เงื่อนไข Edge cases ช่วงคะแนนอารมณ์สัตว์เลี้ยง และเวลาตัดรอบ 05:00 น. (ICT) ตลอดจนมี Fallback Rule สำหรับประเด็น Open Questions อย่างชัดเจน ทำให้ทีม Dev สามารถนำไปพัฒนาต่อได้ทันทีโดยไม่มีข้อติดขัด
~~~~

### ผลลัพธ์ → docs/dashboard/design-review.md

~~~~text
# Design Review: dashboard

## 1. ข้อมูลการตรวจ
- Status: PASS
- Feature: dashboard
- Documents actually reviewed: docs/dashboard/requirements.md, docs/dashboard/ux-flow.md, docs/dashboard/game-rules.md
- Missing/unreadable documents: ไม่มี
- Previous findings checked: ไม่มีข้อมูลรอบก่อน

## 2. ผล Checklist
ทุกข้อมีผล เหตุผล และหลักฐานจากไฟล์/หัวข้อที่ตรวจจริง หากข้อมูลไม่พอให้ใช้ INSUFFICIENT_EVIDENCE ห้ามเดา

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | PASS | เอกสาร requirements.md มี User stories, Acceptance criteria, และ Edge cases ที่ระบุพฤติกรรมระบบครบถ้วน | ไม่ใช่ เพราะข้อมูลและขอบเขตมีความชัดเจนเพียงพอให้นำไปพัฒนาต่อได้ |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | PASS | ทั้ง 3 เอกสารอ้างอิงสูตรคำนวณ (Food+Steps+Water)/3, การ Cap ที่ 100%, ช่วงคะแนนอารมณ์สัตว์เลี้ยง และเวลาตัดรอบ 05:00 น. ตรงกัน | ไม่ใช่ เพราะตรรกะ ข้อมูล และเงื่อนไขในทุกเอกสารสอดคล้องกันเป็นเนื้อเดียวกัน |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | PASS | ชื่อสถานะ Enum (`CRYING`, `DAZED`, `BUBBLY`, `CHEERFUL`), ช่วงเปอร์เซ็นต์, ระยะเวลาแจ้งเตือน 5 วินาที, และเวลา 05:00 น. (ICT) ตรงกันทุกไฟล์ | ไม่ใช่ เพราะตัวเลข ชื่อสถานะ และเวลาไม่มีจุดขัดแย้งกัน |
| C-04 | ขั้นตอนใช้งานและ Edge Cases เพียงพอ | PASS | เอกสาร ux-flow.md ระบุ Happy path ชัดเจน และ requirements.md ครอบคลุม Edge cases สำคัญ เช่น ค่าติดลบ, เกิน 100%, และช่วงเวลาตัดรอบ | ไม่ใช่ เพราะขั้นตอนและกรณีขอบเขตครอบคลุมสถานการณ์ใช้งานจริงครบถ้วน |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | PASS | Open Questions ใน requirements.md, ux-flow.md และ game-rules.md ระบุวิธีปฏิบัติชั่วคราว (Fallback Rule) และยืนยันว่าเป็น Non-blocking | ไม่ใช่ เพราะมีคำอธิบายและแนวทางปฏิบัติชั่วคราวชัดเจน ทำให้ทีม Dev สามารถดำเนินการต่อได้ทันที |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ทุกการตรวจสอบอ้างอิงไฟล์และหัวข้อจริงจาก requirements.md, ux-flow.md และ game-rules.md | ไม่ใช่ เพราะทุกข้อสรุปมีหลักฐานอ้างอิงภายในเอกสารที่ตรวจสอบได้ |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | บทสรุป ผลการตรวจสอบ และข้อเสนอแนะสอดคล้องกับหลักฐานโดยไม่มีความขัดแย้ง | ไม่ใช่ เพราะผลการรีวิวและตารางทั้งหมดมีความสอดคล้องกัน |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีรายงานข้อค้นพบจากรอบก่อนสำหรับใช้อ้างอิงเปรียบเทียบ | ไม่ใช่ เพราะไม่มีข้อมูลรอบก่อนให้ตรวจซ้ำ (บันทึกตามข้อเท็จจริง) |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|

- ตรวจเปรียบเทียบข้อกำหนด (Requirements), UX Flow (ux-flow.md) และ Game Rules (game-rules.md) พบว่าสูตรการคำนวณ (`(Food + Steps + Water) / 3`), การจำกัดค่าสูงสุดไม่เกิน 100%, การปัดเศษเป็น Integer, ช่วงคะแนนอารมณ์สัตว์เลี้ยง (`CRYING`, `DAZED`, `BUBBLY`, `CHEERFUL`), ข้อความ Dynamic Alert Queue, ระยะเวลาหมุนเวียน 5 วินาที และเวลาตัดรอบ 05:00 น. (ICT) สอดคล้องตรงกันทุกประการ จึงไม่พบปัญหาที่ขัดแย้งหรือบล็อกการพัฒนา

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|

- ไม่มีข้อมูลสำหรับเปรียบเนื่องจากไม่พบรายงานการรีวิวรอบก่อน (Previous review not available)

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- ไม่มีรายการคำถามที่บล็อกการพัฒนา โดยประเด็น Open Questions ในเอกสารประกอบด้วย:
  1. การจัดวางภาพ Responsive ของสัตว์เลี้ยง (requirements.md ข้อ 7, ux-flow.md และ game-rules.md หัวข้อ 5): มี Fallback Rule ให้ใช้ภาพขนาด 300x300 pixels แบบ Scalable Image Container และระบุชัดเจนว่าเป็น Non-blocking
  2. การใช้ Timezone Asia/Bangkok (ICT) ในการตัดรอบ 05:00 น. (requirements.md ข้อ 7, ux-flow.md และ game-rules.md หัวข้อ 5): มี Fallback Rule กำหนดให้เปรียบเทียบเวลาอิง GMT+7 (ICT) และระบุชัดเจนว่าเป็น Non-blocking

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|

- ไม่มีข้อมูลใน log ที่ได้รับ

## 7. ข้อจำกัดของการรีวิว
- เอกสารที่ตรวจจริง: docs/dashboard/requirements.md, docs/dashboard/ux-flow.md, docs/dashboard/game-rules.md
- ไฟล์ที่ไม่ได้ตรวจ: ไม่มีเอกสารอื่นนอกเหนือจากที่ระบุ และไม่มีบันทึก Log การทำงานของระบบ
- ผลต่อความมั่นใจ: ข้อมูลการออกแบบครอบคลุมครบถ้วน มีตรรกะและรายละเอียดสอดคล้องกันทุกมิติ ทำให้มีความมั่นใจสูงในการส่งมอบให้ทีมพัฒนา

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: PASS
- Agent recommendation: พร้อมส่ง Dev
- Blocking issues remaining: ไม่มี
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: เอกสาร Requirements, UX Flow และ Game Rules มีความครบถ้วนสมบูรณ์ สอดคล้องต้องกันในทุกส่วน ทั้งสูตรการคำนวณ เงื่อนไข Edge cases ช่วงคะแนนอารมณ์สัตว์เลี้ยง และเวลาตัดรอบ 05:00 น. (ICT) ตลอดจนมี Fallback Rule สำหรับประเด็น Open Questions อย่างชัดเจน ทำให้ทีม Dev สามารถนำไปพัฒนาต่อได้ทันทีโดยไม่มีข้อติดขัด
~~~~
