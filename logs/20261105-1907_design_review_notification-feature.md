# Log: design_review · notification-feature · 2026-11-05 19:07

<!-- meta: {"role": "design_review", "feature": "notification-feature", "time": "2026-11-05 19:07", "status": "ok", "provider": "gemini", "model": "gemini-3.5-flash-lite", "attempts": 1, "seconds": 22.8, "llm_calls": 1, "total_tokens": 26227, "agent_version": "ac395134"} -->

| รายการ | ค่า |
|---|---|
| สถานะ | สำเร็จ |
| ผู้ให้บริการ / รุ่น | gemini / gemini-3.5-flash-lite |
| ลำดับความพยายาม | gemini: สำเร็จ |
| เวลารวม | 22.8 วินาที |
| จำนวนครั้งที่เรียก LLM | 1 |
| tokens (prompt / completion / total) | 24134 / 2093 / 26227 |
| ไฟล์ input | docs/notification-feature/requirements.md, docs/notification-feature/ux-flow.md, docs/notification-feature/game-rules.md |
| ไฟล์ output | docs/notification-feature/design-review.md |
| agent | agents/design_reviewer.md (เวอร์ชัน ac395134) |
| --note | - |

## ความพยายามที่ 1 — gemini (gemini-3.5-flash-lite) — สำเร็จ, 22.8 วินาที

### Agent

- ไฟล์: agents/design_reviewer.md
- role: Software Design Reviewer
- goal: Review the notification-feature design documents against supplied project specifications, verify prior findings when available, and report evidence-backed contradictions, ambiguities, missing decisions, and actionable documentation issues without modifying source documents.
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

# Design Review: notification-feature

## 1. ข้อมูลการตรวจ

- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: notification-feature
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

#### Task → docs/notification-feature/design-review.md

~~~~text
ฟีเจอร์: notification-feature

งานของคุณ: ตรวจเอกสาร Requirements, UX Flow และ Game Rules ก่อนส่งงานให้ Dev ตรวจความครบถ้วนและความสอดคล้องของเอกสาร ตรวจตัวเลข ชื่อสถานะ ขั้นตอนการใช้งาน และ edge cases โดยอ้างอิงหลักฐานจากไฟล์ที่ได้รับ ระบุข้อผิดพลาดพร้อมไฟล์/หัวข้อ เหตุผล และแนวทางแก้ไข ห้ามแต่งข้อกำหนดหรือผลทดสอบขึ้นเอง สรุปผลเป็น PASS, NEEDS_FIX หรือ INSUFFICIENT_EVIDENCE

ข้อมูลประกอบ:
=== docs/notification-feature/requirements.md ===
# Requirements: ฟีเจอร์แจ้งเตือน (notification-feature)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Product agent · ผู้ตรวจ: A (Product) · อ้างอิง Issue: เลข Issue: ยังไม่มี

## 1. สรุปฟีเจอร์
ฟีเจอร์แจ้งเตือนแจ้งเตือนผู้ใช้ให้กลับมาดูแล "น้องอ๊บ" ผ่านการแจ้งเตือนในเครื่อง 3 เรื่อง คือ การเดิน/ขยับ, การดื่มน้ำ และการกินอาหาร โดยใช้น้ำเสียงของน้องอ๊บเพื่อช่วยให้ผู้ใช้ไม่ลืมขยับร่างกาย บันทึกการดื่มน้ำ และบันทึกอาหารประจำวัน โดยแจ้งเตือนและการเมินแจ้งเตือนไม่เปลี่ยนอารมณ์หรือค่าใด ๆ ของน้องอ๊บ

## 2. User stories

| ID | ในฐานะ | ฉันอยาก | เพื่อ |
|---|---|---|---|
| US-1 | ผู้ใช้แอป | เลือกอนุญาตหรือไม่อนุญาตแจ้งเตือนบนการ์ดขอความยินยอม และเปิด/ปิดแจ้งเตือนทั้งหมดได้ในหน้าตั้งค่า | ควบคุมเองได้ว่าจะรับแจ้งเตือนหรือไม่ |
| US-2 | ผู้ใช้แอป | ได้รับแจ้งเตือนเมื่อไม่ได้ขยับนาน หรือเมื่อก้าวใกล้ถึงเป้า | ไม่ลืมขยับร่างกาย และไม่พลาดเป้าก้าวที่ตัวเองตั้งไว้ |
| US-3 | ผู้ใช้แอป | ได้รับแจ้งเตือนเมื่อไม่ได้บันทึกน้ำนาน | ไม่ลืมบันทึกการดื่มน้ำของวัน |
| US-4 | ผู้ใช้แอป | ได้รับแจ้งเตือนเมื่อยังไม่ได้บันทึกอาหารของวัน หรือยอดแคลอรี่ยังไม่ถึงเป้าตอน 21:00 | ไม่ลืมบันทึกอาหารของวัน |
| US-5 | ผู้ใช้แอป | ไม่ได้รับแจ้งเตือนตอนกลางคืน ได้รับไม่เกินวันละ 6 ข้อความ และแต่ละข้อความห่างกันอย่างน้อย 30 นาที | ไม่ถูกรบกวนตอนกลางคืน และไม่ได้รับแจ้งเตือนถี่เกินไป |
| US-6 | ผู้ใช้แอป | เห็นแจ้งเตือนตามรูปแบบของระบบปฏิบัติการที่ใช้ (Android หรือ iOS) | รู้ทันทีว่าเป็นข้อความจากน้องอ๊บ |
| US-7 | ผู้ใช้แอป | กดแจ้งเตือนแล้วเปิดแอปไปที่หน้าของเรื่องนั้นทันที | บันทึกเรื่องที่ถูกเตือนได้ทันที |

## 3. Acceptance criteria

### ตารางข้อความแจ้งเตือน

| ชื่อเรียก | เรื่อง | ข้อความ | เงื่อนไขส่ง | เงื่อนไขหยุด/ยกเลิก |
|---|---|---|---|---|
| เดิน: ไม่ขยับ | เดิน | อย่าลืมขยับบ้างนะ อย่ามัวแต่นั่งอืด ลุกขึ้นมาเดินเร็ว!! | ไม่มีก้าวใหม่ครบ 4 ชม. (นับจากก้าวล่าสุดของรอบวัน หรือจาก 06:00:00) ส่งครั้งเดียวต่อรอบนับ · ยอมให้ส่งช้าได้ไม่เกิน 60 นาที | มีก้าวใหม่ → ยกเลิกและเริ่มนับใหม่ |
| เดิน: ใกล้เป้า | เดิน | มาขยับร่างกายกันอีกนิด ใกล้ถึงเป้าหมายแล้วสู้ๆ | `current_steps` ÷ `daily_goal` ≥ 80% และ < 100% (80.00% พอดีส่ง) · ยอมให้ส่งช้าได้ไม่เกิน 60 นาที | วันละ 1 ครั้ง · ถ้าตอนตรวจพบค่าถึง ≥ 100% แล้ว (รวมกรณีข้ามจากต่ำกว่า 80% ไป ≥ 100% ในรอบอัปเดตเดียว) → ไม่ส่ง |
| เดิน: บันทึกเอง | เดิน (ตรวจก้าวไม่ได้) | อย่าลืมขยับร่างกายน้า ถ้าขยับแล้วมาอัปเดตให้น้องอ๊บด้วย | ผู้ใช้ตรวจก้าวไม่ได้ (ปฏิเสธสิทธิ์ Activity Recognition หรือเครื่องไม่มีเซนเซอร์นับก้าว) และไม่มีบันทึกขยับเองครบ 4 ชม. (นับจากบันทึกล่าสุดของรอบวัน หรือจาก 06:00:00) ส่งครั้งเดียวต่อรอบนับ | บันทึกขยับเอง → ยกเลิกและเริ่มนับใหม่ |
| น้ำ: 2 ชม. | น้ำ | อย่าลืมดื่มน้ำน้าา ผิวกบของน้องขาดความชุ่มชื้น น้องอ๊บไม่ชอบ | ไม่มีบันทึกน้ำครบ 2 ชม. (นับจาก `last_logged_timestamp` ของรอบวัน หรือจาก 06:00:00) และ `daily_water_count` < 8 · ส่งครั้งเดียวต่อรอบนับ | บันทึกน้ำ → ยกเลิกและเริ่มนับใหม่ · `daily_water_count` ≥ 8 → หยุดเรื่องน้ำทั้งรอบวัน |
| น้ำ: 4 ชม. | น้ำ | โปรดดื่มน้ำเถอะคนนี้ น้องอ๊บคอแห้งไม่ไหวแล้วววว ดื่มน้ำๆๆ | ไม่มีบันทึกน้ำครบ **4** ชม. (นับจาก `last_logged_timestamp` ของรอบวัน หรือจาก 06:00:00) และ `daily_water_count` < 8 · ส่งครั้งเดียวต่อรอบนับ | บันทึกน้ำ → ยกเลิกและเริ่มนับใหม่ · `daily_water_count` ≥ 8 → หยุดเรื่องน้ำทั้งรอบวัน |
| อาหาร: ยังไม่กิน | อาหาร | กินข้าวยัง อย่าลืมพักกินข้าวบ้างนะค้าบ แล้วอย่าลืมมาให้อาหารน้องอ๊บด้วย | เวลา 12:00:00, 15:00:00, 18:00:00 ถ้า `total_calories` ของรอบวัน = 0 | `total_calories` > 0 → ยกเลิกรอบที่เหลือของวัน |
| อาหาร: 21:00 | อาหาร | น้องอ๊บหิวแล้วน้า ถ้าทานแล้วมาบอกน้องอ๊บด้วยนะ | เวลา 21:00:00 ส่งครั้งเดียว · ผู้ใช้ที่มีเป้าแคลอรี่: `total_calories` < เป้า · ผู้ใช้ที่ไม่มีเป้าแคลอรี่: `total_calories` = 0 | `total_calories` ≥ เป้า → ไม่ส่ง · ไม่มีเป้าและ `total_calories` > 0 → ไม่ส่ง |

นิยามใต้ตาราง:
- "รอบนับ" = ช่วงตั้งแต่จุดเริ่มของตัวนับ จนถึงเหตุการณ์ที่ทำให้เริ่มนับใหม่ (ก้าวใหม่ / บันทึกขยับเอง / บันทึกน้ำ) หรือจนจบรอบวัน
- "ผู้ใช้ที่ไม่มีเป้าแคลอรี่" = ผู้ใช้ที่ข้ามโปรไฟล์สุขภาพ
- "ครบเป้าน้ำ" = `daily_water_count` ≥ 8 แก้ว (หลอดพลังงานน้ำ 100% ตามสูตร 12.5% ต่อแก้วของฟีเจอร์น้ำ)
- "ผู้ใช้ตรวจก้าวไม่ได้" = ปฏิเสธสิทธิ์ Activity Recognition หรือเครื่องไม่มีเซนเซอร์นับก้าว

หมายเหตุใต้ตาราง:
- ที่ 21:00:00 ส่งเฉพาะ "อาหาร: 21:00" ไม่ส่ง "อาหาร: ยังไม่กิน"
- "อาหาร: ยังไม่กิน" ดูยอดแคลอรี่ทั้งรอบวัน ผู้ใช้ที่บันทึกอาหารแล้ว (เช่น มื้อเช้า) จะไม่ได้ "อาหาร: ยังไม่กิน" ในวันนั้น
- ถึง 100% ของเป้าก้าวแล้ว "เดิน: ไม่ขยับ" ยังทำงานตามปกติ (ไม่หยุด)
- ข้อความทั้งหมดเป็นน้ำเสียงน้องอ๊บ ห้ามเพิ่มคำแนะนำเรื่องปริมาณน้ำ แคลอรี่ หรือสุขภาพ
- "อาหาร: 21:00" เป็นถ้อยคำที่ปรับให้นุ่มลงจากต้นฉบับ (ต้นฉบับกดดันผู้ใช้ว่า "แอบทานแล้วไม่บอก") A ยืนยันให้ปรับน้ำเสียงแล้ว

### ตาราง Acceptance Criteria

| ID | อ้างถึง | เงื่อนไข (ก่อน / เมื่อ / แล้ว) | ค่าที่ทดสอบได้ |
|---|---|---|---|
| AC-1 | US-1 | ก่อน: ผู้ใช้สมัครและกรอกข้อมูลส่วนตัวเสร็จสิ้น / เมื่อ: ผู้ใช้เข้าหน้า Home ครั้งแรก / แล้ว: การ์ดขอความยินยอมแสดงทับหน้า Home | แสดงครั้งเดียว |
| AC-2 | US-1 | ก่อน: การ์ดขอความยินยอมแสดง / เมื่อ: ผู้ใช้กดอนุญาต / แล้ว: ฟีเจอร์ทำงานและกล่องขอสิทธิ์แจ้งเตือนของระบบปรากฏ | กล่องขอสิทธิ์ของระบบปรากฏ |
| AC-3 | US-1 | ก่อน: การ์ดขอความยินยอมแสดง / เมื่อ: ผู้ใช้กดไม่อนุญาต / แล้ว: ฟีเจอร์ไม่ทำงาน ไม่ถามซ้ำเอง และไม่เรียกกล่องขอสิทธิ์ของระบบ | ไม่เรียกกล่องขอสิทธิ์ |
| AC-4 | US-1 | ก่อน: การ์ดขอความยินยอมแสดง / เมื่อ: ผู้ใช้เข้าหน้า Home ครั้งที่ 2 / แล้ว: การ์ดขอความยินยอมไม่แสดงอีก | แสดงครั้งเดียว |
| AC-5 | US-1 | ก่อน: ผู้ใช้เปิดหน้าตั้งค่า / เมื่อ: ดูสวิตช์เปิด/ปิดแจ้งเตือนทั้งหมด / แล้ว: แสดงสถานะสวิตช์ตรงกับคำตอบบนการ์ด | เปิดหรือปิด |
| AC-6 | US-1 | ก่อน: สวิตช์ปิดอยู่และยังไม่เคยได้สิทธิ์จากระบบ / เมื่อ: ผู้ใช้เปิดสวิตช์ / แล้ว: แอปเรียกกล่องขอสิทธิ์ของระบบ | กล่องขอสิทธิ์ของระบบปรากฏ |
| AC-7 | US-1 | ก่อน: สวิตช์เปิดอยู่ / เมื่อ: ผู้ใช้ปิดสวิตช์ / แล้ว: ยกเลิกข้อความที่ตั้งไว้ทั้งหมด และไม่ตั้งใหม่จนกว่าจะเปิด | ยกเลิกทั้งหมด |
| AC-8 | US-1 | ก่อน: ระบบปฏิเสธสิทธิ์แจ้งเตือน / เมื่อ: ตรวจสอบสถานะ / แล้ว: ถือเป็นปิด ไม่ส่งข้อความใด และหน้าตั้งค่าแสดงว่าสิทธิ์ถูกปิดจากระบบ | สิทธิ์ถูกปิดจากระบบ |
| AC-9 | US-2 | ก่อน: ไม่มีก้าวใหม่ครบ 4 ชม. นับจากก้าวล่าสุดหรือ 06:00:00 / เมื่อ: เวลาจำลองถึงกำหนด / แล้ว: ส่งข้อความ "เดิน: ไม่ขยับ" (ยอมให้ช้าได้ไม่เกิน 60 นาที) | 4 ชม. (ช้าสุดไม่เกิน 60 นาที) |
| AC-10 | US-2 | ก่อน: `current_steps` ÷ `daily_goal` อยู่ที่ 79.99% / เมื่อ: อัปเดตก้าว / แล้ว: ไม่ส่งข้อความ "เดิน: ใกล้เป้า" | 79.99% (ไม่ส่ง) |
| AC-11 | US-2 | ก่อน: `current_steps` ÷ `daily_goal` อยู่ที่ 80.00% / เมื่อ: อัปเดตก้าว / แล้ว: ส่งข้อความ "เดิน: ใกล้เป้า" | 80.00% (ส่ง) |
| AC-12 | US-2 | ก่อน: `current_steps` ÷ `daily_goal` อยู่ที่ 99.99% / เมื่อ: อัปเดตก้าว / แล้ว: ส่งข้อความ "เดิน: ใกล้เป้า" | 99.99% (ส่ง) |
| AC-13 | US-2 | ก่อน: `current_steps` ÷ `daily_goal` อยู่ที่ 100.00% / เมื่อ: อัปเดตก้าว / แล้ว: ไม่ส่งข้อความ "เดิน: ใกล้เป้า" | 100.00% (ไม่ส่ง) |
| AC-14 | US-2 | ก่อน: ก้าวข้ามจากต่ำกว่า 80% ไป ≥ 100% ในรอบอัปเดตเดียว / เมื่อ: อัปเดตก้าว / แล้ว: ไม่ส่ง "เดิน: ใกล้เป้า" | ไม่ส่ง |
| AC-15 | US-2 | ก่อน: ผู้ใช้ตรวจก้าวไม่ได้ / เมื่อ: ไม่มีบันทึกขยับเองครบ 4 ชม. นับจากบันทึกล่าสุดหรือ 06:00:00 / แล้ว: ส่งข้อความ "เดิน: บันทึกเอง" | 4 ชม. |
| AC-16 | US-3 | ก่อน: ไม่มีบันทึกน้ำครบ 2 ชม. นับจาก `last_logged_timestamp` หรือ 06:00:00 และ `daily_water_count` < 8 / เมื่อ: เวลาจำลองถึงกำหนด (เช่น ครบ 2:00:00 พอดี) / แล้ว: ส่งข้อความ "น้ำ: 2 ชม." | 2 ชม. |
| AC-17 | US-3 | ก่อน: ส่ง "น้ำ: 2 ชม." แล้ว / เมื่อ: ยังไม่บันทึกน้ำ / แล้ว: ไม่ส่ง "น้ำ: 2 ชม." ซ้ำในรอบนับเดียวกัน | ไม่ส่งซ้ำ |
| AC-18 | US-3 | ก่อน: ไม่มีบันทึกน้ำครบ 4 ชม. นับจาก `last_logged_timestamp` หรือ 06:00:00 และ `daily_water_count` < 8 / เมื่อ: เวลาจำลองถึงกำหนด / แล้ว: ส่งข้อความ "น้ำ: 4 ชม." | 4 ชม. |
| AC-19 | US-3 | ก่อน: `daily_water_count` ถึง 8 (≥ 8 แก้ว) / เมื่อ: ถึงกำหนดเรื่องน้ำ / แล้ว: หยุดเรื่องน้ำทั้งรอบวัน | หยุดเรื่องน้ำทั้งวัน |
| AC-20 | US-4 | ก่อน: `total_calories` ของรอบวัน = 0 / เมื่อ: เวลาจำลองถึง 12:00:00, 15:00:00 หรือ 18:00:00 / แล้ว: ส่งข้อความ "อาหาร: ยังไม่กิน" | 12:00/15:00/18:00 |
| AC-21 | US-4 | ก่อน: บันทึกอาหารแล้ว (`total_calories` > 0) / เมื่อ: ถึงเวลา 12:00:00, 15:00:00 หรือ 18:00:00 / แล้ว: ยกเลิกรอบที่เหลือของวัน | ยกเลิกรอบที่เหลือ |
| AC-22 | US-4 | ก่อน: ผู้ใช้มีเป้าแคลอรี่และ `total_calories` < เป้า / เมื่อ: เวลาจำลองถึง 21:00:00 / แล้ว: ส่งข้อความ "อาหาร: 21:00" | 21:00:00 |
| AC-23 | US-4 | ก่อน: ผู้ใช้ไม่มีเป้าแคลอรี่และ `total_calories` = 0 / เมื่อ: เวลาจำลองถึง 21:00:00 / แล้ว: ส่งข้อความ "อาหาร: 21:00" | 21:00:00 |
| AC-24 | US-4 | ก่อน: ผู้ใช้มีเป้าแคลอรี่และ `total_calories` ≥ เป้า / เมื่อ: เวลาจำลองถึง 21:00:00 / แล้ว: ไม่ส่ง "อาหาร: 21:00" | ไม่ส่ง |
| AC-25 | US-4 | ก่อน: ผู้ใช้ไม่มีเป้าแคลอรี่และ `total_calories` > 0 / เมื่อ: เวลาจำลองถึง 21:00:00 / แล้ว: ไม่ส่ง "อาหาร: 21:00" | ไม่ส่ง |
| AC-26 | US-5 | ก่อน: ช่วงเวลา 23:00:00 ถึง 05:59:59 / เมื่อ: เวลาจำลองอยู่ที่ 23:00:00 (ขอบ: 23:00:00 ไม่ส่ง, 06:00:00 ส่งได้) / แล้ว: ไม่ส่งข้อความใดเลย | 23:00:00 ถึง 05:59:59 |
| AC-27 | US-5 | ก่อน: บันทึกน้ำล่าสุด 22:30:00 / เมื่อ: ข้ามช่วงห้ามเตือน / แล้ว: ตัวนับ "น้ำ: 2 ชม." เริ่มที่ 06:00:00 ของวันถัดไป และส่งได้ที่ 08:00:00 | เริ่มที่ 06:00:00 ส่งที่ 08:00:00 |
| AC-28 | US-5 | ก่อน: ส่งข้อความไปแล้ว 6 ข้อความในรอบวัน / เมื่อ: มีข้อความใหม่เข้าเงื่อนไข / แล้ว: ไม่ส่งเพิ่มจนถึง 05:00:00 รอบวันถัดไป ข้อความที่เข้าเงื่อนไขระหว่างนั้นถูกยกเลิก | เพดาน 6 ข้อความ |
| AC-29 | US-5 | ก่อน: ส่งข้อความล่าสุดไปแล้ว / เมื่อ: ข้อความถัดไปจะส่งแต่ห่างจากข้อความล่าสุด 29:59 นาที / แล้ว: ข้อความถูกเลื่อน | ห่าง 29:59 นาที (เลื่อน) |
| AC-30 | US-5 | ก่อน: ส่งข้อความล่าสุดไปแล้ว / เมื่อ: ข้อความถัดไปจะส่งและห่างจากข้อความล่าสุด 30:00 นาทีพอดี / แล้ว: ส่งข้อความได้ | ห่าง 30:00 นาที (ส่งได้) |
| AC-31 | US-5 | ก่อน: หลายข้อความเข้าเงื่อนไขพร้อมกันหรือชนเพดาน/ระยะห่าง / เมื่อ: ระบบจัดลำดับ / แล้ว: เรียงลำดับความสำคัญ อาหาร > น้ำ > เดิน | อาหาร > น้ำ > เดิน |
| AC-32 | US-5 | ก่อน: ข้อความถูกเลื่อนเพราะระยะห่างหรือลำดับ / เมื่อ: ยังเข้าเงื่อนไข ไม่อยู่ในช่วงห้ามเตือน และยังไม่ชนเพดาน / แล้ว: ส่งทีหลังได้ | ส่งทีหลัง |
| AC-33 | US-5 | ก่อน: ข้อความถูกเลื่อน / เมื่อ: เวลาจำลองถึง 23:00:00 และยังไม่ได้ส่ง / แล้ว: ยกเลิกข้อความนั้น | ยกเลิกตอน 23:00:00 |
| AC-34 | US-5 | ก่อน: ข้อความเรื่องนั้นรอส่ง / เมื่อ: ผู้ใช้ทำสิ่งที่ถูกเตือนแล้ว (บันทึกน้ำ / บันทึกอาหาร / มีก้าวใหม่ / บันทึกขยับเอง) / แล้ว: ยกเลิกข้อความที่รอส่งของเรื่องนั้นทันที | ยกเลิกทันที |
| AC-35 | US-5 | ก่อน: ถึงเวลา 05:00:00 / เมื่อ: ถึงเวลารีเซ็ตรอบวัน / แล้ว: จำนวนข้อความที่ส่งแล้ว = 0 และสถานะ "เดิน: ใกล้เป้า" ส่งแล้ว = ไม่ | รีเซ็ตที่ 05:00:00 |
| AC-36 | US-6 | ก่อน: แจ้งเตือนถูกส่งบน Android / เมื่อ: ผู้ใช้มองเห็นแจ้งเตือน / แล้ว: แสดงแบบแชต 3 ส่วน คือ ชื่อผู้ส่ง "น้องอ๊บ" + รูปโปรไฟล์รูปกบขยิบตาทำปากจู๋ + ข้อความแจ้งเตือน | แสดงแบบแชต 3 ส่วน |
| AC-37 | US-6 | ก่อน: แจ้งเตือนถูกส่งบน iOS / เมื่อ: ผู้ใช้มองเห็นแจ้งเตือน / แล้ว: แจ้งเตือนปกติ 2 ส่วน คือ ไอคอนแอป + ข้อความแจ้งเตือน ไม่มีรูปโปรไฟล์ | แสดงปกติ 2 ส่วน |
| AC-38 | US-7 | ก่อน: มีแจ้งเตือนเรื่องเดิน / เมื่อ: ผู้ใช้กดแจ้งเตือน / แล้ว: เปิดแอปและไปที่หน้าฟีเจอร์เดินทันที (ใช้ได้ทั้งแอปเปิดอยู่, เบื้องหลัง, ปิดสนิท) | หน้าเดิน |
| AC-39 | US-7 | ก่อน: มีแจ้งเตือนเรื่องน้ำ / เมื่อ: ผู้ใช้กดแจ้งเตือน / แล้ว: เปิดแอปและไปที่หน้าน้ำทันที (ใช้ได้ทั้งแอปเปิดอยู่, เบื้องหลัง, ปิดสนิท) | หน้าน้ำ |
| AC-40 | US-7 | ก่อน: มีแจ้งเตือนเรื่องอาหาร / เมื่อ: ผู้ใช้กดแจ้งเตือน / แล้ว: เปิดแอปและไปที่หน้าอาหารทันที (ใช้ได้ทั้งแอปเปิดอยู่, เบื้องหลัง, ปิดสนิท) | หน้าอาหาร |

## 4. Edge cases

| ID | สถานการณ์ | ผลที่คาดหวัง |
|---|---|---|
| EC-1 | กดสวิตช์เปิด/ปิดแจ้งเตือนรัว ๆ | ใช้สถานะสุดท้ายที่กดเป็นตัวตัดสิน ข้อความที่ตั้งไว้ตรงกับสถานะสุดท้ายเท่านั้น |
| EC-2 | กดแจ้งเตือนอันเดียวกันซ้ำหลายครั้งติดกัน | เปิดหน้าของเรื่องนั้นหน้าเดียว ไม่เปิดซ้อน |
| EC-3 | ค่าที่อ่านจากฟีเจอร์อื่นติดลบ (`current_steps`, `daily_water_count`, `total_calories`) หรือ `daily_goal` = 0 | ไม่ส่งข้อความของเรื่องนั้นในรอบวันนั้น |
| EC-4 | `daily_water_count` เกิน 8 (เช่น 12 แก้ว) | ถือว่าครบเป้าน้ำ ไม่ส่งข้อความเรื่องน้ำ |
| EC-5 | หลายข้อความครบกำหนดพร้อมกัน | ระบบจัดส่งตามลำดับความสำคัญ (อาหาร > น้ำ > เดิน) โดยเว้นระยะห่างตามกำหนด |
| EC-6 | บันทึกน้ำ/อาหาร/มีก้าวใหม่/บันทึกขยับเองระหว่างข้อความเรื่องนั้นรอส่ง | ยกเลิกข้อความนั้นทันที |
| EC-7 | ครบกำหนดข้อความในช่วงห้ามเตือน (23:00:00 ถึง 05:59:59) | ไม่ส่งข้อความในคืนนั้น และตัวนับเริ่มใหม่ตามกติกาหลังช่วงห้ามเตือน |
| EC-8 | ข้ามรอบ 05:00:00 | รีเซ็ตจำนวนข้อความที่ส่งแล้วเป็น 0 และรีเซ็ตสถานะ "เดิน: ใกล้เป้า" เป็นยังไม่ส่ง |
| EC-9 | กดไม่อนุญาตบนการ์ดแล้วเปิดสวิตช์ทีหลัง | แอปเรียกกล่องขอสิทธิ์ของระบบ (ครั้งแรกสำหรับผู้ที่เคยกดไม่อนุญาตบนการ์ด) |
| EC-10 | ระบบปฏิเสธสิทธิ์แจ้งเตือน | ถือเป็นปิด ไม่ส่งข้อความใด และหน้าตั้งค่าแสดงว่าสิทธิ์ถูกปิดจากระบบ |
| EC-11 | ก้าวข้าม 80% และ 100% ในรอบอัปเดตเดียว (เช่น จาก 70.00% ไป 100.00%) | ไม่ส่ง "เดิน: ใกล้เป้า" (ตรงกับ AC-14) |
| EC-12 | ผู้ใช้ตรวจก้าวไม่ได้ | ไม่ได้รับ "เดิน: ไม่ขยับ" และ "เดิน: ใกล้เป้า" แต่ได้รับ "เดิน: บันทึกเอง" แทน |
| EC-13 | เปิดแอปจากแจ้งเตือนตอนปิดสนิท | เปิดแอปและไปที่หน้าของเรื่องนั้นทันที |
| EC-14 | ไม่เปิดแอปข้ามรอบวัน | จะไม่มีข้อความของรอบวันใหม่จนกว่าผู้ใช้จะเปิดแอป เมื่อเปิดแอป ระบบตั้งข้อความของรอบวันปัจจุบันใหม่ตามกติกาทั้งหมด |
| EC-15 | ส่งครบ 6 ข้อความก่อน 21:00 | ส่งครบ 6 แล้วไม่ส่งเพิ่มจนถึง 05:00:00 รอบวันถัดไป ข้อความที่เข้าเงื่อนไขระหว่างนั้นถูกยกเลิก |

## 5. สิ่งที่ไม่ทำในรอบนี้ (Out of scope)
- ไม่มี push จากเซิร์ฟเวอร์
- ไม่มีหน้าตั้งค่ารายประเภท (เปิด/ปิดเฉพาะเดิน/น้ำ/อาหาร) และไม่ให้ผู้ใช้ปรับเวลา ความถี่ หรือช่วงห้ามเตือนเอง
- ไม่ตรวจการขยับแบบไม่นับก้าว
- ไม่รับประกันเวลาเป๊ะของ "เดิน: ไม่ขยับ" และ "เดิน: ใกล้เป้า" (ช้าได้ไม่เกิน 60 นาที)
- iOS ไม่มีรูปโปรไฟล์แบบแชต
- ไม่รองรับการเดินทางข้ามเขตเวลา (ใช้เวลาท้องถิ่นของเครื่อง)
- ไม่ส่งข้อความของรอบวันใหม่ถ้าผู้ใช้ไม่เปิดแอปเลย
- ไม่ให้คำแนะนำสุขภาพหรือตัวเลขที่ควรกิน/ดื่ม
- แจ้งเตือนไม่มีผลต่ออารมณ์หรือค่าใด ๆ ของน้องอ๊บ
- Design ไม่ต้องทำกติกาเกมหรือภาพอารมณ์สัตว์เลี้ยงสำหรับฟีเจอร์นี้ ใช้ภาพโปรไฟล์กบ 1 ภาพเท่านั้น

## 6. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น)

| ข้อมูล | ชนิด/หน่วย | เก็บที่ไหน |
|---|---|---|
| `current_steps` | จำนวนเต็ม (ก้าว) | อ่านจากฟีเจอร์เดิน (`docs/steps/`) |
| `daily_goal` | จำนวนเต็ม (ก้าว) | อ่านจากฟีเจอร์เดิน (`docs/steps/`) |
| สถานะสิทธิ์ Activity Recognition และการมีเซนเซอร์นับก้าว | สถานะ (มี/ไม่มี, อนุญาต/ปฏิเสธ) | อ่านจากฟีเจอร์เดิน (`docs/steps/`) |
| ปุ่มบันทึกการขยับเอง | การกระทำ | อ่านจากฟีเจอร์เดิน (`docs/steps/`) |
| `daily_water_count` | จำนวนเต็ม (แก้ว) | อ่านจากฟีเจอร์น้ำ (`docs/water/`) |
| `last_logged_timestamp` | วันที่และเวลา | อ่านจากฟีเจอร์น้ำ (`docs/water/`) |
| `total_calories` | จำนวนเต็ม (kcal) | อ่านจากฟีเจอร์อาหาร (`docs/food/`) |
| เป้าแคลอรี่รายวันจากโปรไฟล์ | จำนวนเต็ม (kcal) | อ่านจากฟีเจอร์อาหาร (`docs/food/`) |
| สถานะความยินยอมบนการ์ด | อนุญาต / ไม่อนุญาต / ยังไม่ตอบ | Local Storage |
| สถานะสวิตช์แจ้งเตือนทั้งหมด | เปิด / ปิด | Local Storage |
| สถานะสิทธิ์แจ้งเตือนของระบบ | อนุญาต / ปฏิเสธ / ยังไม่เคยขอ | Local Storage |
| จำนวนข้อความที่ส่งแล้วในรอบวัน | จำนวนเต็ม 0–6 | Local Storage |
| เวลาส่งข้อความล่าสุด | วันที่และเวลา | Local Storage |
| "เดิน: ใกล้เป้า" ส่งแล้วในรอบวันหรือยัง | ใช่ / ไม่ | Local Storage |
| เวลาบันทึกขยับเองล่าสุด | วันที่และเวลา | Local Storage |
| เวลาที่ `current_steps` เพิ่มล่าสุด | วันที่และเวลา | Local Storage |

## 7. คำถามที่ยังเปิดอยู่
1. (ถาม Design) ชื่อไฟล์ภาพโปรไฟล์กบสำหรับแจ้งเตือน Android
2. (ถาม Design) ข้อความในหน้าตั้งค่าเมื่อระบบปฏิเสธสิทธิ์แจ้งเตือน

=== จบ docs/notification-feature/requirements.md ===

=== docs/notification-feature/ux-flow.md ===
# UX flow: ฟีเจอร์แจ้งเตือน (notification-feature)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: เพื่อน B · อ้างอิง: requirements.md

## 1. รายการหน้าจอ

| ID | ชื่อหน้าจอ | จุดประสงค์ | อ้างถึง |
|---|---|---|---|
| S-1 | การ์ดขอความยินยอม (Consent Card) | แสดงทับหน้า Home เมื่อเข้าหน้า Home ครั้งแรกหลัง Onboarding เพื่อให้ผู้ใช้เลือกอนุญาตหรือไม่อนุญาตรับแจ้งเตือน (แสดงครั้งเดียว) | US-1, AC-1, AC-2, AC-3, AC-4, EC-9 |
| S-2 | หน้าตั้งค่าแจ้งเตือน (Notification Settings Screen) | เข้าถึงจากเมนูตั้งค่าเพื่อให้ผู้ใช้เปิด/ปิดแจ้งเตือนทั้งหมดผ่านสวิตช์หลัก 1 อัน และดูสถานะกรณีสิทธิ์ถูกปิดจากระบบ | US-1, AC-5, AC-6, AC-7, AC-8, EC-1, EC-9, EC-10 |
| S-3 | การแจ้งเตือนบนระบบปฏิบัติการ (OS Notification Display) | แสดงข้อความแจ้งเตือนจากน้องอ๊บตามรูปแบบของ Android (แชต 3 ส่วน) หรือ iOS (ปกติ 2 ส่วน) และรับการกดเพื่อนำทางไปหน้าฟีเจอร์ทันที | US-2, US-3, US-4, US-5, US-6, US-7, AC-9 ถึง AC-40, EC-2, EC-13 |

## 2. องค์ประกอบบนหน้าจอ

### S-1 การ์ดขอความยินยอม (Consent Card)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| พื้นหลังการ์ดทับหน้า Home | Modal Overlay Card | แสดงทับหน้า Home เฉพาะการเข้าหน้า Home ครั้งแรกหลังสมัครและกรอกข้อมูลส่วนตัวเสร็จ (ไม่แก้เส้นทางของฟีเจอร์ `signup`) | บล็อกการกดทะลุหลังการ์ดจนกว่าผู้ใช้จะเลือกปุ่มใดปุ่มหนึ่ง การ์ดแสดงครั้งเดียว ไม่แสดงซ้ำในการเข้าหน้า Home ครั้งที่ 2 เป็นต้นไป (AC-1, AC-4) |
| รูปโปรไฟล์น้องอ๊บ | รูปภาพ (Image) | `assets/images/pet_profile_frog.png` | แสดงรูปกบขยิบตาทำปากจู๋คงที่ 1 ภาพ (ไม่มีผลเมื่อกด) |
| หัวข้อการ์ด | ข้อความหัวข้อ (Title Text) | น้องอ๊บอยากส่งเสียงหา! | - |
| รายละเอียดการ์ด | ข้อความเนื้อหา (Body Text) | อนุญาตให้น้องอ๊บแจ้งเตือนเรื่องการเดิน การดื่มน้ำ และการกินอาหารนะค้าบ | - (ไม่มีคำแนะนำสุขภาพ และไม่ระบุว่าแจ้งเตือนเปลี่ยนอารมณ์น้องอ๊บ) |
| ปุ่มอนุญาต | ปุ่มหลัก (Primary Button) | อนุญาต | บันทึก `consent_status = ALLOWED (อนุญาต)` และ `notification_master_switch = ON (เปิด)` ลง Local Storage, ปิดการ์ดทันที, เปิดใช้งานฟีเจอร์ และเรียกกล่องขอสิทธิ์แจ้งเตือนของระบบ (`OS Permission Dialog`) ต่อทันที (AC-2, AC-5) |
| ปุ่มไม่อนุญาต | ปุ่มรอง (Secondary Button) | ไม่อนุญาต | บันทึก `consent_status = DENIED (ไม่อนุญาต)` และ `notification_master_switch = OFF (ปิด)` ลง Local Storage, ปิดการ์ดทันที, ฟีเจอร์ไม่ทำงาน ไม่ถามซ้ำเอง และไม่เรียกกล่องขอสิทธิ์ของระบบ (AC-3, AC-4, AC-5) |

### S-2 หน้าตั้งค่าแจ้งเตือน (Notification Settings Screen)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| หัวข้อหน้าตั้งค่า | ข้อความหัวข้อ (Title Text) | การแจ้งเตือนของน้องอ๊บ | - |
| สวิตช์เปิด/ปิดแจ้งเตือนทั้งหมด | สวิตช์ (Switch 1 อัน) | `ON (เปิด)` / `OFF (ปิด)` (ค่าเริ่มต้นตรงกับคำตอบบนการ์ด S-1 ตาม AC-5; ถ้าระบบปฏิเสธสิทธิ์จะแสดงเป็น `OFF (ปิด)` ตาม AC-8) | - เปลี่ยนเป็น `ON (เปิด)` และยังไม่เคยได้สิทธิ์จากระบบ (`NOT_DETERMINED`) → เรียกกล่องขอสิทธิ์ของระบบทันที (AC-6, EC-9) หากได้รับสิทธิ์จะตั้งเวลาแจ้งเตือนของรอบวันปัจจุบันตาม `game-rules.md`<br>- เปลี่ยนเป็น `OFF (ปิด)` → ยกเลิกข้อความที่ตั้งไว้ทั้งหมดทันที และไม่ตั้งใหม่จนกว่าจะเปิดอีกครั้ง (AC-7)<br>- กดสลับรัว ๆ → ใช้สถานะสุดท้ายที่กดเป็นตัวตัดสิน (EC-1) |
| ข้อความสถานะเมื่อสิทธิ์ถูกปิดจากระบบ | ข้อความแจ้งสถานะ (Warning Text) | สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน | แสดงบริเวณใต้สวิตช์เฉพาะเมื่อ `system_permission_status == DENIED (ปฏิเสธ)` (ปฏิเสธในกล่องขอสิทธิ์หรือปิดในการตั้งค่าเครื่อง) โดยระบบถือเป็นปิดและไม่ส่งข้อความใด (AC-8, EC-10) |

### S-3 การแจ้งเตือนบนระบบปฏิบัติการ (OS Notification Display)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| รูปแบบแจ้งเตือน Android (แบบแชต 3 ส่วน) | OS Notification (Android Chat Style) | 1. ชื่อผู้ส่ง: `น้องอ๊บ`<br>2. รูปโปรไฟล์: `assets/images/pet_profile_frog.png` (รูปกบขยิบตาทำปากจู๋ รูปเดียวคงที่ ไม่เปลี่ยนตามอารมณ์)<br>3. ข้อความแจ้งเตือน: ข้อความคำต่อคำตามตารางด้านล่าง (AC-36) | เปิดแอปและนำทางไปยังหน้าจอของเรื่องนั้นทันทีตามตาราง 3.1 (AC-38, AC-39, AC-40) |
| รูปแบบแจ้งเตือน iOS (ปกติ 2 ส่วน) | OS Notification (iOS Standard Style) | 1. ไอคอนแอป PetPal Health (ไม่มีรูปโปรไฟล์แบบแชต)<br>2. ข้อความแจ้งเตือน: ข้อความคำต่อคำตามตารางด้านล่าง (AC-37) | เปิดแอปและนำทางไปยังหน้าจอของเรื่องนั้นทันทีตามตาราง 3.1 (AC-38, AC-39, AC-40) |

#### ตารางข้อความแจ้งเตือนคำต่อคำที่แสดงบน S-3 (อ้างอิงเงื่อนไขละเอียดใน `game-rules.md` หัวข้อ 1.1)
| ชื่อเรียก | เรื่อง | ข้อความที่แสดงจริง (Exact String) | หน้าจอปลายทางเมื่อกด |
|---|---|---|---|
| เดิน: ไม่ขยับ | เดิน | อย่าลืมขยับบ้างนะ อย่ามัวแต่นั่งอืด ลุกขึ้นมาเดินเร็ว!! | หน้าฟีเจอร์เดิน (`docs/steps/`) |
| เดิน: ใกล้เป้า | เดิน | มาขยับร่างกายกันอีกนิด ใกล้ถึงเป้าหมายแล้วสู้ๆ | หน้าฟีเจอร์เดิน (`docs/steps/`) |
| เดิน: บันทึกเอง | เดิน (ตรวจก้าวไม่ได้) | อย่าลืมขยับร่างกายน้า ถ้าขยับแล้วมาอัปเดตให้น้องอ๊บด้วย | หน้าฟีเจอร์เดิน (`docs/steps/`) |
| น้ำ: 2 ชม. | น้ำ | อย่าลืมดื่มน้ำน้าา ผิวกบของน้องขาดความชุ่มชื้น น้องอ๊บไม่ชอบ | หน้าฟีเจอร์น้ำ (`docs/water/`) |
| น้ำ: 4 ชม. | น้ำ | โปรดดื่มน้ำเถอะคนนี้ น้องอ๊บคอแห้งไม่ไหวแล้วววว ดื่มน้ำๆๆ | หน้าฟีเจอร์น้ำ (`docs/water/`) |
| อาหาร: ยังไม่กิน | อาหาร | กินข้าวยัง อย่าลืมพักกินข้าวบ้างนะค้าบ แล้วอย่าลืมมาให้อาหารน้องอ๊บด้วย | หน้าฟีเจอร์อาหาร (`docs/food/`) |
| อาหาร: 21:00 | อาหาร | น้องอ๊บหิวแล้วน้า ถ้าทานแล้วมาบอกน้องอ๊บด้วยนะ | หน้าฟีเจอร์อาหาร (`docs/food/`) |

## 3. ขั้นตอนการใช้งาน (happy path)

1. **เข้าหน้า Home ครั้งแรกหลัง Onboarding:** ผู้ใช้สมัครและกรอกข้อมูลส่วนตัวเสร็จสิ้น ระบบพาเข้าหน้า Home ครั้งแรก และแสดงการ์ดขอความยินยอม (S-1) ทับหน้า Home เพียงครั้งเดียว (US-1, AC-1, AC-4)
2. **อนุญาตความยินยอมและสิทธิ์ของระบบ:** ผู้ใช้กดปุ่ม `อนุญาต` บน S-1 ระบบบันทึก `consent_status = ALLOWED (อนุญาต)` และ `notification_master_switch = ON (เปิด)` ปิดการ์ดทันที และเรียกกล่องขอสิทธิ์แจ้งเตือนของระบบ (`OS Permission Dialog`) ต่อทันที (AC-2, AC-5)
3. **เริ่มระบบตั้งเวลาในเครื่อง:** เมื่อผู้ใช้กดอนุญาตในกล่องขอสิทธิ์ของระบบ (`system_permission_status = GRANTED (อนุญาต)`) ระบบแจ้งเตือนในเครื่อง (Local Notification) จะตรวจสอบข้อมูลจากฟีเจอร์เดิน น้ำ และอาหาร และตั้งเวลาแจ้งเตือนของรอบวันปัจจุบันภายใต้กติกากลาง (ไม่ส่งช่วง `23:00:00`–`05:59:59`, เพดานไม่เกิน 6 ข้อความต่อรอบวัน, ห่างกันอย่างน้อย 30 นาที, ลำดับความสำคัญ `อาหาร > น้ำ > เดิน`) (US-2 ถึง US-5)
4. **แสดงแจ้งเตือนตามระบบปฏิบัติการ:** เมื่อถึงกำหนดเวลาหรือเข้าเงื่อนไข ระบบแสดงการแจ้งเตือน (S-3) โดยบน Android แสดงแบบแชต 3 ส่วน (ชื่อผู้ส่ง `"น้องอ๊บ"` + รูปกบขยิบตาทำปากจู๋ + ข้อความ) และบน iOS แสดงแบบปกติ 2 ส่วน (ไอคอนแอป + ข้อความ) (US-6, AC-36, AC-37)
5. **กดแจ้งเตือนเพื่อเข้าสู่ฟีเจอร์ทันที:** ผู้ใช้กดที่แจ้งเตือน ระบบเปิดแอปและพาไปยังหน้าฟีเจอร์ของเรื่องนั้นทันทีตามตาราง 3.1 เพื่อให้ผู้ใช้บันทึกข้อมูลได้ทันที และเมื่อผู้ใช้ทำกิจกรรมนั้นแล้ว ระบบยกเลิกข้อความที่รอส่งของเรื่องนั้นทันที (US-7, AC-34, AC-38, AC-39, AC-40)
6. **ควบคุมเปิด/ปิดผ่านหน้าตั้งค่า:** ผู้ใช้สามารถเปิดหน้าตั้งค่าแจ้งเตือน (S-2) จากเมนูตั้งค่าเพื่อดูหรือสลับสวิตช์เปิด/ปิดแจ้งเตือนทั้งหมดได้ตลอดเวลา (US-1, AC-5, AC-6, AC-7)

### 3.1 ตารางเส้นทาง Deep Linking และการนำทางข้ามสถานะแอป

| เรื่องของแจ้งเตือน | ชื่อเรียกข้อความที่ครอบคลุม | หน้าจอปลายทาง | สถานะแอปที่รองรับ | พฤติกรรมการนำทางและกันหน้าซ้อน | อ้างถึง |
|---|---|---|---|---|---|
| เดิน | เดิน: ไม่ขยับ, เดิน: ใกล้เป้า, เดิน: บันทึกเอง | หน้าฟีเจอร์เดิน (`docs/steps/`) | `FOREGROUND (แอปเปิดอยู่)`, `BACKGROUND (แอปอยู่เบื้องหลัง)`, `TERMINATED (แอปปิดสนิท)` | เปิดแอปและไปที่หน้าฟีเจอร์เดินทันที หากกดแจ้งเตือนเดิมซ้ำติดกันหลายครั้งจะเปิดเพียงหน้าเดียว ไม่เปิดซ้อนทับบน Stack | US-7, AC-38, EC-2, EC-13 |
| น้ำ | น้ำ: 2 ชม., น้ำ: 4 ชม. | หน้าฟีเจอร์น้ำ (`docs/water/`) | `FOREGROUND (แอปเปิดอยู่)`, `BACKGROUND (แอปอยู่เบื้องหลัง)`, `TERMINATED (แอปปิดสนิท)` | เปิดแอปและไปที่หน้าฟีเจอร์น้ำทันที หากกดแจ้งเตือนเดิมซ้ำติดกันหลายครั้งจะเปิดเพียงหน้าเดียว ไม่เปิดซ้อนทับบน Stack | US-7, AC-39, EC-2, EC-13 |
| อาหาร | อาหาร: ยังไม่กิน, อาหาร: 21:00 | หน้าฟีเจอร์อาหาร (`docs/food/`) | `FOREGROUND (แอปเปิดอยู่)`, `BACKGROUND (แอปอยู่เบื้องหลัง)`, `TERMINATED (แอปปิดสนิท)` | เปิดแอปและไปที่หน้าฟีเจอร์อาหารทันที หากกดแจ้งเตือนเดิมซ้ำติดกันหลายครั้งจะเปิดเพียงหน้าเดียว ไม่เปิดซ้อนทับบน Stack | US-7, AC-40, EC-2, EC-13 |

## 4. สถานะของหน้าจอ

| หน้าจอ | สถานะ | เงื่อนไขที่ทำให้เกิด | สิ่งที่แสดง |
|---|---|---|---|
| S-1 | `NORMAL (ปกติ)` | ผู้ใช้เข้าหน้า Home ครั้งแรกหลัง Onboarding และ `consent_status == UNANSWERED (ยังไม่ตอบ)` (AC-1) | แสดงการ์ดขอความยินยอมทับหน้า Home พร้อมรูปกบ ปุ่ม `อนุญาต` และปุ่ม `ไม่อนุญาต` |
| S-1 | `EMPTY (ว่าง/ไม่แสดง)` | ผู้ใช้เคยตอบบนการ์ดไปแล้ว (`ALLOWED` หรือ `DENIED`) เมื่อเข้าหน้า Home ครั้งที่ 2 เป็นต้นไป (AC-4) | ซ่อนการ์ดสนิท แสดงหน้า Home ตามปกติโดยไม่ถามซ้ำ |
| S-1 | `ERROR (ผิดพลาด)` | อ่านหรือบันทึกค่าความยินยอมใน Local Storage ไม่สำเร็จ | ปิดการ์ดโดยถือเป็นสถานะไม่อนุญาตชั่วคราว (ไม่ส่งแจ้งเตือนเองโดยไม่ได้รับความยินยอม) และให้ผู้ใช้ใช้งานหน้า Home หรือตั้งค่าภายหลังใน S-2 ได้ |
| S-2 | `NORMAL (ปกติ - เปิดใช้งาน)` | `notification_master_switch == ON (เปิด)` และ `system_permission_status == GRANTED (อนุญาต)` (AC-5) | แสดงสวิตช์แจ้งเตือนทั้งหมดในตำแหน่ง `ON (เปิด)` ไม่มีข้อความเตือนสิทธิ์ถูกปิด |
| S-2 | `EMPTY (ว่าง - ปิดใช้งานโดยผู้ใช้)` | ผู้ใช้เลือกไม่อนุญาตบน S-1 หรือปิดสวิตช์เอง (`notification_master_switch == OFF (ปิด)`) โดยที่ระบบไม่ได้ปฏิเสธสิทธิ์ (AC-3, AC-5, AC-7) | แสดงสวิตช์แจ้งเตือนทั้งหมดในตำแหน่ง `OFF (ปิด)` ไม่มีรายการแจ้งเตือนตั้งเวลารอส่งในระบบ |
| S-2 | `PERMISSION_DENIED (ผิดพลาด - สิทธิ์ถูกปิดจากระบบ)` | ระบบปฏิบัติการปฏิเสธสิทธิ์แจ้งเตือน (`system_permission_status == DENIED (ปฏิเสธ)`) ทั้งจากกล่องขอสิทธิ์หรือจากการตั้งค่าเครื่อง (AC-8, EC-10) | ถือเป็นสถานะปิด สวิตช์แสดง `OFF (ปิด)` ไม่ส่งข้อความใด และแสดงข้อความเตือน `"สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน"` |
| S-3 | `NORMAL (ปกติ)` | ข้อความเข้าเงื่อนไข ไม่อยู่ในช่วงห้ามเตือน (`23:00:00`–`05:59:59`) ยังไม่ชนเพดาน 6 ข้อความ และห่างจากข้อความล่าสุด ≥ 30:00 นาที (AC-30, AC-36, AC-37) | Android แสดงแบบแชต 3 ส่วน (`น้องอ๊บ` + รูป `assets/images/pet_profile_frog.png` + ข้อความ); iOS แสดงปกติ 2 ส่วน (ไอคอนแอป + ข้อความ) |
| S-3 | `EMPTY (ว่าง/ไม่มีการส่งแจ้งเตือน)` | อยู่ในช่วงห้ามเตือน (`23:00:00`–`05:59:59`), ส่งครบ 6 ข้อความในรอบวันแล้ว, สวิตช์ปิดอยู่, หรือไม่เปิดแอปข้ามรอบวัน (AC-7, AC-26, AC-28, EC-14, EC-15) | ไม่มีการแสดงแจ้งเตือนใด ๆ บนหน้าจอระบบปฏิบัติการ |
| S-3 | `ERROR (ผิดพลาด - ข้อมูลต้นทางไม่ถูกต้อง)` | ค่าที่อ่านจากฟีเจอร์อื่นติดลบ (`current_steps < 0`, `daily_water_count < 0`, `total_calories < 0`) หรือ `daily_goal == 0` (EC-3) | ระงับการส่งข้อความแจ้งเตือนของเรื่องนั้นในรอบวันนั้นทันที โดยไม่แสดงข้อความผิดพลาดรบกวนผู้ใช้ |

## 5. ไฟล์ภาพ assets

| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายภาพ |
|---|---|---|
| `assets/images/pet_profile_frog.png` | S-1 (การ์ดขอความยินยอม) และ S-3 (รูปโปรไฟล์แจ้งเตือนแบบแชตบน Android ตาม AC-36) | รูปโปรไฟล์น้องอ๊บ กบขยิบตาทำปากจู๋ พื้นหลังโปร่งใส ใช้ภาพเดียวคงที่ ไม่เปลี่ยนตามอารมณ์สัตว์เลี้ยง (ส่วน iOS ใช้ไอคอนแอปมาตรฐาน ไม่มีรูปโปรไฟล์ในรอบนี้ตาม AC-37) |

## 6. คำถามถึง Product

1. (ถาม Design) ชื่อไฟล์ภาพโปรไฟล์กบสำหรับแจ้งเตือน Android
   - *ข้อเสนอแนะจาก Design:* กำหนดชื่อไฟล์ภาพมาตรฐานเป็น `assets/images/pet_profile_frog.png` สำหรับรูปกบขยิบตาทำปากจู๋ เพื่อให้ใช้ร่วมกันได้ทั้งในการ์ดขอความยินยอม (S-1) และการแจ้งเตือนแบบแชตบน Android (S-3)
   - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ให้ Dev อ้างอิง Path `assets/images/pet_profile_frog.png` ในโค้ดแสดงผล S-1 และ Android Notification Builder ได้ทันที
   - *การประเมินสถานะการบล็อก:* `Blocking: ไม่ใช่` (เพราะกำหนดชื่อไฟล์และตำแหน่ง Asset ชัดเจนตรงกันทุกตารางแล้ว)

2. (ถาม Design) ข้อความในหน้าตั้งค่าเมื่อระบบปฏิเสธสิทธิ์แจ้งเตือน
   - *ข้อเสนอแนะจาก Design:* แสดงข้อความแจ้งสาเหตุและวิธีแก้ไขอย่างกระชับเป็นมิตรบริเวณใต้สวิตช์ในหน้าตั้งค่า (S-2) เมื่อตรวจพบว่าสิทธิ์แจ้งเตือนของระบบถูกปฏิเสธหรือถูกปิดจากเครื่อง
   - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ให้ Dev แสดงข้อความ Exact String ว่า `"สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน"` ในสถานะ `PERMISSION_DENIED` ของหน้า S-2 ได้ทันที
   - *การประเมินสถานะการบล็อก:* `Blocking: ไม่ใช่` (เพราะกำหนดข้อความ Exact String และเงื่อนไขการแสดงผลใน S-2 ครบถ้วนแล้ว)

=== จบ docs/notification-feature/ux-flow.md ===

=== docs/notification-feature/game-rules.md ===
# กติกาเกม: ฟีเจอร์แจ้งเตือน (notification-feature)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: เพื่อน B · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ชนิดข้อมูล | ความหมาย | ค่า | หน่วย | อ้างถึง |
|---|---|---|---|---|---|
| `DAILY_RESET_TIME` | String | เวลาเริ่มต้นรอบวันใหม่และรีเซ็ตตัวนับรายวันทั้งหมด (รอบวัน `05:00:00` ถึง `04:59:59` ของวันถัดไป อิงนาฬิกาในเครื่อง) | `"05:00:00"` | เวลา (`HH:MM:SS`) | AC-35, EC-8, EC-14 |
| `QUIET_HOURS_START_TIME` | String | เวลาเริ่มต้นช่วงห้ามเตือนตอนกลางคืน (**รวมขอบ** `23:00:00` ไม่ส่ง และยกเลิกข้อความที่ถูกเลื่อนค้างอยู่; `22:59:59` ส่งได้) | `"23:00:00"` | เวลา (`HH:MM:SS`) | AC-26, AC-33, EC-7 |
| `QUIET_HOURS_END_TIME` | String | เวลาสิ้นสุดช่วงห้ามเตือนตอนกลางคืน (**รวมขอบ** `05:59:59` ไม่ส่ง) | `"05:59:59"` | เวลา (`HH:MM:SS`) | AC-26, EC-7 |
| `ACTIVE_HOURS_START_TIME` | String | เวลาแรกหลังพ้นช่วงห้ามเตือนที่ส่งข้อความได้ และใช้เป็นจุดเริ่มตัวนับหากเหตุการณ์ล่าสุดเกิดก่อนหน้านี้ (**รวมขอบ** `06:00:00` ส่งได้) | `"06:00:00"` | เวลา (`HH:MM:SS`) | AC-26, AC-27, EC-7 |
| `DAILY_NOTIFICATION_CAP` | Integer | เพดานจำนวนข้อความแจ้งเตือนสูงสุดต่อรอบวัน (ส่งครบแล้วไม่ส่งเพิ่มจนถึง `05:00:00` รอบวันถัดไป) | `6` | ข้อความ | AC-28, EC-15 |
| `MIN_NOTIFICATION_INTERVAL_MINUTES` | Integer | ระยะห่างขั้นต่ำระหว่างข้อความที่ส่งล่าสุดกับข้อความถัดไป (**รวมขอบ** `30:00` นาทีส่งได้; `29:59` นาทีถูกเลื่อน) | `30` | นาที | AC-29, AC-30, EC-5 |
| `WALK_INACTIVITY_HOURS` | Integer | ระยะเวลาที่ไม่มีก้าวใหม่ก่อนส่งข้อความ `"เดิน: ไม่ขยับ"` (ครบ `4:00:00` ชม. พอดีส่งได้) | `4` | ชั่วโมง | AC-9 |
| `WALK_MANUAL_INACTIVITY_HOURS` | Integer | ระยะเวลาที่ไม่มีบันทึกขยับเองก่อนส่งข้อความ `"เดิน: บันทึกเอง"` สำหรับผู้ใช้ตรวจก้าวไม่ได้ | `4` | ชั่วโมง | AC-15, EC-12 |
| `WALK_MAX_DELAY_MINUTES` | Integer | ระยะเวลาผ่อนผันสูงสุดที่ยอมให้ `"เดิน: ไม่ขยับ"` และ `"เดิน: ใกล้เป้า"` ส่งช้ากว่าเวลาตามเงื่อนไข | `60` | นาที | AC-9 |
| `WALK_NEAR_GOAL_MIN_PERCENT` | Float | สัดส่วนความคืบหน้าก้าวต่ำสุดที่ส่ง `"เดิน: ใกล้เป้า"` (**รวมขอบ** `80.00%` ส่ง; `79.99%` ไม่ส่ง) | `80.00` | เปอร์เซ็นต์ (%) | AC-10, AC-11 |
| `WALK_NEAR_GOAL_MAX_EXCLUSIVE_PERCENT` | Float | ขอบบนของสัดส่วนความคืบหน้าก้าวสำหรับ `"เดิน: ใกล้เป้า"` (**ไม่รวมขอบ** `100.00%`: `< 100.00%` เช่น `99.99%` ส่ง; `>= 100.00%` ไม่ส่ง) | `100.00` | เปอร์เซ็นต์ (%) | AC-12, AC-13, AC-14, EC-11 |
| `WATER_INACTIVITY_FIRST_HOURS` | Integer | ระยะเวลาที่ไม่มีบันทึกน้ำก่อนส่ง `"น้ำ: 2 ชม."` (ครบ `2:00:00` ชม. พอดีส่งได้) | `2` | ชั่วโมง | AC-16, AC-17, AC-27 |
| `WATER_INACTIVITY_SECOND_HOURS` | Integer | ระยะเวลาที่ไม่มีบันทึกน้ำก่อนส่ง `"น้ำ: 4 ชม."` (ครบ `4:00:00` ชม. พอดีส่งได้) | `4` | ชั่วโมง | AC-18 |
| `WATER_DAILY_GOAL_GLASSES` | Integer | จำนวนแก้วน้ำที่ถือว่าครบเป้าน้ำของวัน (**รวมขอบ** `>= 8` แก้ว หรือหลอดพลังงานน้ำ `100%` หยุดเรื่องน้ำทั้งรอบวัน) | `8` | แก้ว | AC-16, AC-18, AC-19, EC-4 |
| `FOOD_UNLOGGED_TIME_1` | String | เวลาตรวจส่ง `"อาหาร: ยังไม่กิน"` รอบที่ 1 เมื่อ `total_calories == 0` | `"12:00:00"` | เวลา (`HH:MM:SS`) | AC-20, AC-21 |
| `FOOD_UNLOGGED_TIME_2` | String | เวลาตรวจส่ง `"อาหาร: ยังไม่กิน"` รอบที่ 2 เมื่อ `total_calories == 0` | `"15:00:00"` | เวลา (`HH:MM:SS`) | AC-20, AC-21 |
| `FOOD_UNLOGGED_TIME_3` | String | เวลาตรวจส่ง `"อาหาร: ยังไม่กิน"` รอบที่ 3 เมื่อ `total_calories == 0` | `"18:00:00"` | เวลา (`HH:MM:SS`) | AC-20, AC-21 |
| `FOOD_NIGHT_REMINDER_TIME` | String | เวลาตรวจส่ง `"อาหาร: 21:00"` รอบค่ำเพียงครั้งเดียว (ที่เวลานี้ไม่ส่ง `"อาหาร: ยังไม่กิน"`) | `"21:00:00"` | เวลา (`HH:MM:SS`) | AC-22, AC-23, AC-24, AC-25 |

### 1.1 ตารางข้อความ เงื่อนไข และลำดับคิว

| ชื่อเรียก | เรื่อง | ข้อความคำต่อคำ (Exact String) | เงื่อนไขส่ง (Trigger) | เงื่อนไขหยุด/ยกเลิก (Cancel/Stop) |
|---|---|---|---|---|
| เดิน: ไม่ขยับ | เดิน | อย่าลืมขยับบ้างนะ อย่ามัวแต่นั่งอืด ลุกขึ้นมาเดินเร็ว!! | ไม่มีก้าวใหม่ครบ 4 ชม. (นับจากก้าวล่าสุดของรอบวัน หรือจาก 06:00:00) ส่งครั้งเดียวต่อรอบนับ · ยอมให้ส่งช้าได้ไม่เกิน 60 นาที | มีก้าวใหม่ → ยกเลิกและเริ่มนับใหม่ |
| เดิน: ใกล้เป้า | เดิน | มาขยับร่างกายกันอีกนิด ใกล้ถึงเป้าหมายแล้วสู้ๆ | `current_steps` ÷ `daily_goal` ≥ 80% และ < 100% (80.00% พอดีส่ง) · ยอมให้ส่งช้าได้ไม่เกิน 60 นาที | วันละ 1 ครั้ง · ถ้าตอนตรวจพบค่าถึง ≥ 100% แล้ว (รวมกรณีข้ามจากต่ำกว่า 80% ไป ≥ 100% ในรอบอัปเดตเดียว) → ไม่ส่ง |
| เดิน: บันทึกเอง | เดิน (ตรวจก้าวไม่ได้) | อย่าลืมขยับร่างกายน้า ถ้าขยับแล้วมาอัปเดตให้น้องอ๊บด้วย | ผู้ใช้ตรวจก้าวไม่ได้ (ปฏิเสธสิทธิ์ Activity Recognition หรือเครื่องไม่มีเซนเซอร์นับก้าว) และไม่มีบันทึกขยับเองครบ 4 ชม. (นับจากบันทึกล่าสุดของรอบวัน หรือจาก 06:00:00) ส่งครั้งเดียวต่อรอบนับ | บันทึกขยับเอง → ยกเลิกและเริ่มนับใหม่ |
| น้ำ: 2 ชม. | น้ำ | อย่าลืมดื่มน้ำน้าา ผิวกบของน้องขาดความชุ่มชื้น น้องอ๊บไม่ชอบ | ไม่มีบันทึกน้ำครบ 2 ชม. (นับจาก `last_logged_timestamp` ของรอบวัน หรือจาก 06:00:00) และ `daily_water_count` < 8 · ส่งครั้งเดียวต่อรอบนับ | บันทึกน้ำ → ยกเลิกและเริ่มนับใหม่ · `daily_water_count` ≥ 8 → หยุดเรื่องน้ำทั้งรอบวัน |
| น้ำ: 4 ชม. | น้ำ | โปรดดื่มน้ำเถอะคนนี้ น้องอ๊บคอแห้งไม่ไหวแล้วววว ดื่มน้ำๆๆ | ไม่มีบันทึกน้ำครบ **4** ชม. (นับจาก `last_logged_timestamp` ของรอบวัน หรือจาก 06:00:00) และ `daily_water_count` < 8 · ส่งครั้งเดียวต่อรอบนับ | บันทึกน้ำ → ยกเลิกและเริ่มนับใหม่ · `daily_water_count` ≥ 8 → หยุดเรื่องน้ำทั้งรอบวัน |
| อาหาร: ยังไม่กิน | อาหาร | กินข้าวยัง อย่าลืมพักกินข้าวบ้างนะค้าบ แล้วอย่าลืมมาให้อาหารน้องอ๊บด้วย | เวลา 12:00:00, 15:00:00, 18:00:00 ถ้า `total_calories` ของรอบวัน = 0 | `total_calories` > 0 → ยกเลิกรอบที่เหลือของวัน |
| อาหาร: 21:00 | อาหาร | น้องอ๊บหิวแล้วน้า ถ้าทานแล้วมาบอกน้องอ๊บด้วยนะ | เวลา 21:00:00 ส่งครั้งเดียว · ผู้ใช้ที่มีเป้าแคลอรี่: `total_calories` < เป้า · ผู้ใช้ที่ไม่มีเป้าแคลอรี่: `total_calories` = 0 | `total_calories` ≥ เป้า → ไม่ส่ง · ไม่มีเป้าและ `total_calories` > 0 → ไม่ส่ง |

**นิยามและกติกากลางของการจัดคิว:**
- **ลำดับความสำคัญ (Priority Order):** `อาหาร > น้ำ > เดิน` เมื่อหลายข้อความเข้าเงื่อนไขพร้อมกัน หรือชนเพดาน/ระยะห่าง (AC-31, EC-5)
- **ระยะห่างขั้นต่ำ (Cooldown):** ข้อความถัดไปส่งได้เมื่อห่างจาก `last_notification_timestamp` ≥ `30:00` นาที (`29:59` นาทีถูกเลื่อน) (AC-29, AC-30)
- **การส่งข้อความที่ถูกเลื่อนและการตัดทิ้งตอน 23:00:00:** ข้อความที่ถูกเลื่อนเพราะระยะห่างหรือลำดับ จะส่งทีหลังได้ถ้ายังเข้าเงื่อนไขอยู่ ไม่อยู่ในช่วงห้ามเตือน และยังไม่ชนเพดาน 6 ข้อความ แต่หากถึงเวลา `23:00:00` แล้วยังไม่ได้ส่ง ให้ยกเลิกทิ้งทันที (AC-32, AC-33)
- **ตัวนับเวลาหลังช่วงห้ามเตือน:** ตัวนับของ `"เดิน: ไม่ขยับ"`, `"เดิน: บันทึกเอง"`, `"น้ำ: 2 ชม."` และ `"น้ำ: 4 ชม."` เริ่มจาก**ค่าที่มาทีหลังระหว่าง** (เวลาที่เกิดเหตุการณ์ล่าสุดของรอบวันนั้น) กับ `06:00:00` โดยข้อความที่ครบกำหนดในช่วงห้ามเตือน (`23:00:00`–`05:59:59`) ไม่ส่งของคืนนั้น (AC-26, AC-27, EC-7)
- **การยกเลิกอัตโนมัติเมื่อผู้ใช้ทำกิจกรรมแล้ว:** หากผู้ใช้บันทึกน้ำ บันทึกอาหาร มีก้าวใหม่ หรือบันทึกขยับเอง ระหว่างที่ข้อความของเรื่องนั้นรอส่ง ให้ยกเลิกข้อความที่รอส่งของเรื่องนั้นทันที (AC-34, EC-6)
- **เงื่อนไขเพิ่มเติมตามหมวด:** ถึง `100%` ของเป้าก้าวแล้ว `"เดิน: ไม่ขยับ"` ยังทำงานตามปกติ (ไม่หยุด); ผู้ใช้ตรวจก้าวไม่ได้จะไม่ได้รับ `"เดิน: ไม่ขยับ"` และ `"เดิน: ใกล้เป้า"` แต่ได้รับ `"เดิน: บันทึกเอง"` แทน (และผู้ที่ตรวจก้าวได้จะไม่ได้รับ `"เดิน: บันทึกเอง"`); ที่ `21:00:00` ส่งเฉพาะ `"อาหาร: 21:00"` ไม่ส่ง `"อาหาร: ยังไม่กิน"`

### 1.2 ตารางสถานะและข้อมูลที่เก็บในระบบ (System State & Storage Schema)

#### ข้อมูลที่ฟีเจอร์แจ้งเตือนเก็บเองใน Local Storage
| ชื่อฟิลด์ (Storage Key) | ชนิดข้อมูล | ค่า CODE_ENUM (ป้ายไทย) / ขอบเขตค่า | ค่าเริ่มต้น | ความหมายและกติกาอัปเดต |
|---|---|---|---|---|
| `consent_status` | String | `ALLOWED (อนุญาต)`, `DENIED (ไม่อนุญาต)`, `UNANSWERED (ยังไม่ตอบ)` | `UNANSWERED (ยังไม่ตอบ)` | สถานะความยินยอมบนการ์ด S-1 (เปลี่ยนครั้งเดียวเมื่อผู้ใช้กดปุ่มบน S-1 ตาม AC-1 ถึง AC-4) |
| `notification_master_switch` | String | `ON (เปิด)`, `OFF (ปิด)` | `OFF (ปิด)` ก่อนตอบการ์ด; หลังตอบการ์ดตั้งค่าเริ่มต้นตรงกับคำตอบบน S-1 (`ALLOWED` → `ON (เปิด)`, `DENIED` → `OFF (ปิด)`) | สถานะสวิตช์เปิด/ปิดแจ้งเตือนทั้งหมดในหน้าตั้งค่า S-2 (AC-5, AC-6, AC-7; หาก `system_permission_status == DENIED (ปฏิเสธ)` ให้ถือเป็นปิดตาม AC-8) |
| `system_permission_status` | String | `GRANTED (อนุญาต)`, `DENIED (ปฏิเสธ)`, `NOT_DETERMINED (ยังไม่เคยขอ)` | `NOT_DETERMINED (ยังไม่เคยขอ)` | สถานะสิทธิ์แจ้งเตือนของระบบปฏิบัติการ (AC-2, AC-6, AC-8, EC-9, EC-10) |
| `sent_notification_count` | Integer | `0` ถึง `6` | `0` | จำนวนข้อความที่ส่งแล้วในรอบวัน รีเซ็ตกลับเป็น `0` เมื่อถึงเวลา `05:00:00` (AC-28, AC-35) |
| `last_notification_timestamp` | String (ISO DateTime / Nullable) | วันและเวลาที่ส่งข้อความล่าสุด หรือ `NULL` | `NULL` | ใช้คำนวณระยะห่างขั้นต่ำ 30 นาทีระหว่างข้อความ (AC-29, AC-30) |
| `walk_near_goal_sent_today` | Boolean / String | `YES (ใช่)` (`true`), `NO (ไม่)` (`false`) | `NO (ไม่)` (`false`) | สถานะว่าส่ง `"เดิน: ใกล้เป้า"` ในรอบวันปัจจุบันไปแล้วหรือยัง รีเซ็ตเป็น `NO (ไม่)` เมื่อถึง `05:00:00` (AC-11, AC-35) |
| `last_manual_move_timestamp` | String (ISO DateTime / Nullable) | วันและเวลาที่กดบันทึกขยับเองล่าสุด หรือ `NULL` | `NULL` | ใช้เริ่มตัวนับ 4 ชม. ของ `"เดิน: บันทึกเอง"` โดยเริ่มจากค่าที่มาทีหลังระหว่างเวลานี้ของรอบวันกับ `06:00:00` (AC-15, EC-12) |
| `last_steps_increased_timestamp` | String (ISO DateTime / Nullable) | วันและเวลาที่ `current_steps` เพิ่มขึ้นล่าสุด หรือ `NULL` | `NULL` | ใช้เริ่มตัวนับ 4 ชม. ของ `"เดิน: ไม่ขยับ"` โดยเริ่มจากค่าที่มาทีหลังระหว่างเวลานี้ของรอบวันกับ `06:00:00` (AC-9) |

#### ข้อมูลที่อ่านอย่างเดียว (Read-only) จากฟีเจอร์อื่น (ไม่สร้างค่าเป้าซ้ำ)
- **ฟีเจอร์เดิน (`docs/steps/`):** `current_steps` (`Integer`, ก้าว), `daily_goal` (`Integer`, ก้าว), สถานะสิทธิ์ Activity Recognition และการมีเซนเซอร์นับก้าว, การกดปุ่มบันทึกการขยับเอง
- **ฟีเจอร์น้ำ (`docs/water/`):** `daily_water_count` (`Integer`, แก้ว), `last_logged_timestamp` (`String` DateTime เวลาบันทึกน้ำล่าสุด)
- **ฟีเจอร์อาหาร (`docs/food/`):** `total_calories` (`Integer`, kcal ยอดรวมของรอบวัน), เป้าแคลอรี่รายวันจากโปรไฟล์ (`Integer`, kcal หรือไม่มีเป้ากรณีผู้ใช้ข้ามโปรไฟล์สุขภาพ)

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง

การส่งแจ้งเตือนและการเมินแจ้งเตือน**ไม่เปลี่ยนอารมณ์หรือค่าใด ๆ ของน้องอ๊บ** ฟีเจอร์นี้จึงไม่มีกติกาเพิ่ม/ลดค่าความสุขของสัตว์เลี้ยง และใช้เฉพาะภาพโปรไฟล์กบคงที่ 1 ภาพสำหรับการ์ดขอความยินยอมและการแจ้งเตือนบน Android เท่านั้น

| สถานะ (Code Enum) | ช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพ |
|---|---|---|
| `NOTIFICATION_PROFILE (ภาพโปรไฟล์แจ้งเตือนคงที่)` | ไม่มีช่วงค่าตัวเลข (แจ้งเตือนไม่เปลี่ยนอารมณ์หรือค่าใด ๆ ของน้องอ๊บ) | `assets/images/pet_profile_frog.png` |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| ไม่มีก้าวใหม่ครบ 4 ชม. (ผู้ใช้ตรวจก้าวได้) | ก้าวล่าสุดเพิ่มเวลา `08:00:00`, เวลาจำลองถึง `12:00:00` | ส่งข้อความ `"เดิน: ไม่ขยับ"` (ยอมให้ช้าสุดไม่เกิน `13:00:00`) | อ้าง AC-9 |
| อัปเดตก้าวที่สัดส่วน `79.99%` (ต่ำกว่าขอบล่าง) | `current_steps = 7999`, `daily_goal = 10000` (`7999 ÷ 10000 = 79.99%`) | ไม่ส่งข้อความ `"เดิน: ใกล้เป้า"` | อ้าง AC-10 |
| อัปเดตก้าวที่สัดส่วน `80.00%` พอดี (ขอบล่างรวมขอบ) | `current_steps = 8000`, `daily_goal = 10000` (`80.00%`), `walk_near_goal_sent_today = NO (ไม่)` | ส่งข้อความ `"เดิน: ใกล้เป้า"`, ตั้ง `walk_near_goal_sent_today = YES (ใช่)` | อ้าง AC-11 |
| อัปเดตก้าวที่สัดส่วน `99.99%` (ก่อนถึงขอบบน) | `current_steps = 9999`, `daily_goal = 10000` (`99.99%`), `walk_near_goal_sent_today = NO (ไม่)` | ส่งข้อความ `"เดิน: ใกล้เป้า"`, ตั้ง `walk_near_goal_sent_today = YES (ใช่)` | อ้าง AC-12 |
| อัปเดตก้าวที่สัดส่วน `100.00%` พอดี (ขอบบนไม่รวมขอบ) | `current_steps = 10000`, `daily_goal = 10000` (`100.00%`) | ไม่ส่งข้อความ `"เดิน: ใกล้เป้า"` | อ้าง AC-13 |
| ก้าวกระโดดข้ามจากต่ำกว่า `80%` ไป `>= 100%` ในรอบเดียว | `current_steps` เปลี่ยนจาก `7000` (`70.00%`) → `10000` (`100.00%`), `daily_goal = 10000` | ไม่ส่งข้อความ `"เดิน: ใกล้เป้า"` | อ้าง AC-14, EC-11 |
| ผู้ใช้ตรวจก้าวไม่ได้และไม่บันทึกขยับเองครบ 4 ชม. | `last_manual_move_timestamp = 09:00:00`, เวลาจำลองถึง `13:00:00` | ส่งข้อความ `"เดิน: บันทึกเอง"` | อ้าง AC-15, EC-12 |
| ไม่บันทึกน้ำครบ 2 ชม. และยังไม่บันทึกต่อจนครบ 4 ชม. | `last_logged_timestamp = 08:00:00`, `daily_water_count = 3` (`< 8`) | เวลา `10:00:00` ส่ง `"น้ำ: 2 ชม."` 1 ครั้ง (ไม่ส่งซ้ำในรอบนับเดิม) และเวลา `12:00:00` ส่ง `"น้ำ: 4 ชม."` | อ้าง AC-16, AC-17, AC-18 |
| บันทึกน้ำจนถึงเป้าน้ำ 8 แก้ว | `daily_water_count` เพิ่มจาก `7` → `8` แก้ว (หลอดน้ำ `100%`) | ยกเลิกและหยุดข้อความเรื่องน้ำทั้งรอบวันทันที | อ้าง AC-19 |
| ยังไม่บันทึกอาหารที่เวลา `12:00:00` แล้วมาบันทึกตอน `12:30:00` | เวลา `12:00:00` มี `total_calories = 0` → ต่อมา `12:30:00` บันทึก `500 kcal` (`> 0`) | เวลา `12:00:00` ส่ง `"อาหาร: ยังไม่กิน"` ส่วนรอบ `15:00:00` และ `18:00:00` ถูกยกเลิกทั้งหมด | อ้าง AC-20, AC-21 |
| ถึงเวลา `21:00:00` สำหรับผู้ใช้ที่มีเป้าแคลอรี่ `2000 kcal` | กรณี ก: `total_calories = 1500` (`< 2000`) / กรณี ข: `total_calories = 2000` (`>= 2000`) | กรณี ก: ส่ง `"อาหาร: 21:00"` / กรณี ข: ไม่ส่ง `"อาหาร: 21:00"` | อ้าง AC-22, AC-24 |
| ถึงเวลา `21:00:00` สำหรับผู้ใช้ที่ไม่มีเป้าแคลอรี่ (ข้ามโปรไฟล์) | กรณี ก: `total_calories = 0` / กรณี ข: `total_calories = 350` (`> 0`) | กรณี ก: ส่ง `"อาหาร: 21:00"` / กรณี ข: ไม่ส่ง `"อาหาร: 21:00"` | อ้าง AC-23, AC-25 |
| ตัวนับหลังข้ามช่วงห้ามเตือน (ดื่มน้ำก่อนเข้านอน) | บันทึกน้ำล่าสุดเวลา `22:30:00`, ข้ามช่วงห้ามเตือน `23:00:00`–`05:59:59` | ตัวนับ `"น้ำ: 2 ชม."` เริ่มนับที่ `06:00:00` ของวันถัดไป และส่งได้ที่เวลา `08:00:00` | อ้าง AC-27, EC-7 |
| ตรวจสอบระยะห่าง `29:59` นาที เทียบกับ `30:00` นาทีพอดี | ส่งข้อความล่าสุดเมื่อ `12:00:00`, ข้อความถัดไปเข้าเงื่อนไข | ที่ `12:29:59` (ห่าง `29:59`) ข้อความถูกเลื่อน; ที่ `12:30:00` (ห่าง `30:00` พอดี) ส่งข้อความได้ | อ้าง AC-29, AC-30 |
| รีเซ็ตรอบวันเมื่อถึงเวลา `05:00:00` | เวลา `04:59:59` มี `sent_notification_count = 6`, `walk_near_goal_sent_today = YES (ใช่)` | เวลา `05:00:00` รีเซ็ต `sent_notification_count = 0` และ `walk_near_goal_sent_today = NO (ไม่)` | อ้าง AC-35, EC-8 |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ที่ทดสอบได้ |
|---|---|
| กดสวิตช์เปิด/ปิดแจ้งเตือนรัว ๆ (EC-1) | ใช้สถานะสุดท้ายที่กดเป็นตัวตัดสิน ข้อความที่ตั้งไว้ในระบบตรงกับสถานะสุดท้ายเท่านั้น |
| กดแจ้งเตือนอันเดียวกันซ้ำหลายครั้งติดกัน (EC-2) | เปิดแอปไปยังหน้าของเรื่องนั้นเพียงหน้าเดียว ไม่เปิดหน้าซ้อนทับกัน |
| ค่าที่อ่านจากฟีเจอร์อื่นติดลบ (`current_steps < 0`, `daily_water_count < 0`, `total_calories < 0`) หรือ `daily_goal == 0` (EC-3) | ไม่ส่งข้อความของเรื่องนั้นในรอบวันนั้น |
| `daily_water_count` เกิน 8 แก้ว เช่น 12 แก้ว (EC-4) | ถือว่าครบเป้าน้ำ (`>= 8`) ไม่ส่งข้อความเรื่องน้ำในรอบวันนั้น |
| หลายข้อความครบกำหนดพร้อมกัน (EC-5) | จัดลำดับส่งตามความสำคัญ `อาหาร > น้ำ > เดิน` โดยเว้นระยะห่างระหว่างข้อความอย่างน้อย `30:00` นาที (AC-30, AC-31) |
| บันทึกน้ำ / บันทึกอาหาร / มีก้าวใหม่ / บันทึกขยับเอง ขณะข้อความเรื่องนั้นรอส่ง (EC-6) | ยกเลิกข้อความที่รอส่งของเรื่องนั้นทันที (AC-34) |
| ครบกำหนดในช่วงห้ามเตือน `23:00:00` ถึง `05:59:59` หรือข้อความที่ถูกเลื่อนค้างถึง `23:00:00` (EC-7) | ขอบ `22:59:59` ส่งได้, ขอบ `23:00:00` ถึง `05:59:59` ไม่ส่งข้อความใดเลย ข้อความที่ถูกเลื่อนค้างถึง `23:00:00` ถูกยกเลิกทิ้ง และตัวนับเริ่มใหม่จาก `06:00:00` (ขอบ `06:00:00` ส่งได้) (AC-26, AC-27, AC-33) |
| ข้ามเวลารีเซ็ตรอบวัน `05:00:00` (EC-8) | รีเซ็ต `sent_notification_count = 0` และรีเซ็ต `walk_near_goal_sent_today = NO (ไม่)` ทันที (AC-35) |
| กด `ไม่อนุญาต` บนการ์ด S-1 แล้วมาเปิดสวิตช์ในหน้าตั้งค่า S-2 ทีหลัง (EC-9) | แอปเรียกกล่องขอสิทธิ์แจ้งเตือนของระบบขึ้นมา (เป็นการขอสิทธิ์ระบบครั้งแรกของผู้ที่เคยกดไม่อนุญาตบนการ์ด) (AC-6) |
| ระบบปฏิเสธสิทธิ์แจ้งเตือน (`system_permission_status == DENIED (ปฏิเสธ)`) (EC-10) | ถือเป็นปิด ไม่ส่งข้อความใด และหน้าตั้งค่า S-2 แสดงข้อความ `"สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน"` (AC-8) |
| ก้าวข้ามทั้ง `80%` และ `100%` ในรอบอัปเดตเดียว เช่น `70.00%` ไป `100.00%` (EC-11) | ไม่ส่งข้อความ `"เดิน: ใกล้เป้า"` (AC-14) |
| ผู้ใช้ตรวจก้าวไม่ได้ (ปฏิเสธสิทธิ์ Activity Recognition หรือเครื่องไม่มีเซนเซอร์นับก้าว) (EC-12) | ไม่ส่ง `"เดิน: ไม่ขยับ"` และ `"เดิน: ใกล้เป้า"` แต่ใช้ตัวนับ 4 ชม. ส่ง `"เดิน: บันทึกเอง"` แทน (AC-15) |
| กดเปิดแอปจากแจ้งเตือนตอนแอปปิดสนิท (`TERMINATED`) (EC-13) | เปิดแอปและนำทางไปยังหน้าฟีเจอร์ของเรื่องนั้นทันที (เดิน → หน้าเดิน, น้ำ → หน้าน้ำ, อาหาร → หน้าอาหาร) (AC-38, AC-39, AC-40) |
| ไม่เปิดแอปเลยข้ามรอบวัน `05:00:00` (EC-14) | ไม่มีข้อความของรอบวันใหม่ถูกส่งจนกว่าผู้ใช้จะเปิดแอป เมื่อเปิดแอปแล้ว ระบบจึงตั้งเวลาข้อความของรอบวันปัจจุบันใหม่ตามกติกาทั้งหมด |
| ส่งครบเพดาน 6 ข้อความก่อนเวลา `21:00:00` (EC-15) | เมื่อ `sent_notification_count == 6` ระบบหยุดส่งข้อความเพิ่มจนถึง `05:00:00` ของรอบวันถัดไป และยกเลิกข้อความที่เข้าเงื่อนไขระหว่างนั้นทั้งหมด (AC-28) |

## 5. คำถามถึง Product

1. (ถาม Design) ชื่อไฟล์ภาพโปรไฟล์กบสำหรับแจ้งเตือน Android
   - *ข้อเสนอแนะจาก Design:* กำหนดชื่อไฟล์ภาพมาตรฐานเป็น `assets/images/pet_profile_frog.png` สำหรับรูปกบขยิบตาทำปากจู๋ เพื่อให้ใช้ร่วมกันได้ทั้งในการ์ดขอความยินยอม (S-1) และการแจ้งเตือนแบบแชตบน Android (S-3)
   - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ให้ Dev อ้างอิง Path `assets/images/pet_profile_frog.png` ในโค้ดแสดงผล S-1 และ Android Notification Builder ได้ทันที
   - *การประเมินสถานะการบล็อก:* `Blocking: ไม่ใช่` (เพราะกำหนดชื่อไฟล์และตำแหน่ง Asset ชัดเจนตรงกันทุกตารางใน `ux-flow.md` และ `game-rules.md` แล้ว)

2. (ถาม Design) ข้อความในหน้าตั้งค่าเมื่อระบบปฏิเสธสิทธิ์แจ้งเตือน
   - *ข้อเสนอแนะจาก Design:* แสดงข้อความแจ้งสาเหตุและวิธีแก้ไขอย่างกระชับเป็นมิตรบริเวณใต้สวิตช์ในหน้าตั้งค่า (S-2) เมื่อตรวจพบว่าสิทธิ์แจ้งเตือนของระบบถูกปฏิเสธหรือถูกปิดจากเครื่อง
   - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ให้ Dev แสดงข้อความ Exact String ว่า `"สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน"` ในสถานะ `PERMISSION_DENIED` ของหน้า S-2 ได้ทันที
   - *การประเมินสถานะการบล็อก:* `Blocking: ไม่ใช่` (เพราะกำหนดข้อความ Exact String และเงื่อนไขการแสดงผลตรงกับ `ux-flow.md` 100% แล้ว)

=== จบ docs/notification-feature/game-rules.md ===

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

expected_output: เนื้อหาไฟล์ docs/notification-feature/design-review.md ฉบับสมบูรณ์ ตามโครง template

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

# Design Review: notification-feature

## 1. ข้อมูลการตรวจ

- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: notification-feature
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
Your personal goal is: Review the notification-feature design documents against supplied project specifications, verify prior findings when available, and report evidence-backed contradictions, ambiguities, missing decisions, and actionable documentation issues without modifying source documents.

[user]

Current Task: ฟีเจอร์: notification-feature

งานของคุณ: ตรวจเอกสาร Requirements, UX Flow และ Game Rules ก่อนส่งงานให้ Dev ตรวจความครบถ้วนและความสอดคล้องของเอกสาร ตรวจตัวเลข ชื่อสถานะ ขั้นตอนการใช้งาน และ edge cases โดยอ้างอิงหลักฐานจากไฟล์ที่ได้รับ ระบุข้อผิดพลาดพร้อมไฟล์/หัวข้อ เหตุผล และแนวทางแก้ไข ห้ามแต่งข้อกำหนดหรือผลทดสอบขึ้นเอง สรุปผลเป็น PASS, NEEDS_FIX หรือ INSUFFICIENT_EVIDENCE

ข้อมูลประกอบ:
=== docs/notification-feature/requirements.md ===
# Requirements: ฟีเจอร์แจ้งเตือน (notification-feature)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Product agent · ผู้ตรวจ: A (Product) · อ้างอิง Issue: เลข Issue: ยังไม่มี

## 1. สรุปฟีเจอร์
ฟีเจอร์แจ้งเตือนแจ้งเตือนผู้ใช้ให้กลับมาดูแล "น้องอ๊บ" ผ่านการแจ้งเตือนในเครื่อง 3 เรื่อง คือ การเดิน/ขยับ, การดื่มน้ำ และการกินอาหาร โดยใช้น้ำเสียงของน้องอ๊บเพื่อช่วยให้ผู้ใช้ไม่ลืมขยับร่างกาย บันทึกการดื่มน้ำ และบันทึกอาหารประจำวัน โดยแจ้งเตือนและการเมินแจ้งเตือนไม่เปลี่ยนอารมณ์หรือค่าใด ๆ ของน้องอ๊บ

## 2. User stories

| ID | ในฐานะ | ฉันอยาก | เพื่อ |
|---|---|---|---|
| US-1 | ผู้ใช้แอป | เลือกอนุญาตหรือไม่อนุญาตแจ้งเตือนบนการ์ดขอความยินยอม และเปิด/ปิดแจ้งเตือนทั้งหมดได้ในหน้าตั้งค่า | ควบคุมเองได้ว่าจะรับแจ้งเตือนหรือไม่ |
| US-2 | ผู้ใช้แอป | ได้รับแจ้งเตือนเมื่อไม่ได้ขยับนาน หรือเมื่อก้าวใกล้ถึงเป้า | ไม่ลืมขยับร่างกาย และไม่พลาดเป้าก้าวที่ตัวเองตั้งไว้ |
| US-3 | ผู้ใช้แอป | ได้รับแจ้งเตือนเมื่อไม่ได้บันทึกน้ำนาน | ไม่ลืมบันทึกการดื่มน้ำของวัน |
| US-4 | ผู้ใช้แอป | ได้รับแจ้งเตือนเมื่อยังไม่ได้บันทึกอาหารของวัน หรือยอดแคลอรี่ยังไม่ถึงเป้าตอน 21:00 | ไม่ลืมบันทึกอาหารของวัน |
| US-5 | ผู้ใช้แอป | ไม่ได้รับแจ้งเตือนตอนกลางคืน ได้รับไม่เกินวันละ 6 ข้อความ และแต่ละข้อความห่างกันอย่างน้อย 30 นาที | ไม่ถูกรบกวนตอนกลางคืน และไม่ได้รับแจ้งเตือนถี่เกินไป |
| US-6 | ผู้ใช้แอป | เห็นแจ้งเตือนตามรูปแบบของระบบปฏิบัติการที่ใช้ (Android หรือ iOS) | รู้ทันทีว่าเป็นข้อความจากน้องอ๊บ |
| US-7 | ผู้ใช้แอป | กดแจ้งเตือนแล้วเปิดแอปไปที่หน้าของเรื่องนั้นทันที | บันทึกเรื่องที่ถูกเตือนได้ทันที |

## 3. Acceptance criteria

### ตารางข้อความแจ้งเตือน

| ชื่อเรียก | เรื่อง | ข้อความ | เงื่อนไขส่ง | เงื่อนไขหยุด/ยกเลิก |
|---|---|---|---|---|
| เดิน: ไม่ขยับ | เดิน | อย่าลืมขยับบ้างนะ อย่ามัวแต่นั่งอืด ลุกขึ้นมาเดินเร็ว!! | ไม่มีก้าวใหม่ครบ 4 ชม. (นับจากก้าวล่าสุดของรอบวัน หรือจาก 06:00:00) ส่งครั้งเดียวต่อรอบนับ · ยอมให้ส่งช้าได้ไม่เกิน 60 นาที | มีก้าวใหม่ → ยกเลิกและเริ่มนับใหม่ |
| เดิน: ใกล้เป้า | เดิน | มาขยับร่างกายกันอีกนิด ใกล้ถึงเป้าหมายแล้วสู้ๆ | `current_steps` ÷ `daily_goal` ≥ 80% และ < 100% (80.00% พอดีส่ง) · ยอมให้ส่งช้าได้ไม่เกิน 60 นาที | วันละ 1 ครั้ง · ถ้าตอนตรวจพบค่าถึง ≥ 100% แล้ว (รวมกรณีข้ามจากต่ำกว่า 80% ไป ≥ 100% ในรอบอัปเดตเดียว) → ไม่ส่ง |
| เดิน: บันทึกเอง | เดิน (ตรวจก้าวไม่ได้) | อย่าลืมขยับร่างกายน้า ถ้าขยับแล้วมาอัปเดตให้น้องอ๊บด้วย | ผู้ใช้ตรวจก้าวไม่ได้ (ปฏิเสธสิทธิ์ Activity Recognition หรือเครื่องไม่มีเซนเซอร์นับก้าว) และไม่มีบันทึกขยับเองครบ 4 ชม. (นับจากบันทึกล่าสุดของรอบวัน หรือจาก 06:00:00) ส่งครั้งเดียวต่อรอบนับ | บันทึกขยับเอง → ยกเลิกและเริ่มนับใหม่ |
| น้ำ: 2 ชม. | น้ำ | อย่าลืมดื่มน้ำน้าา ผิวกบของน้องขาดความชุ่มชื้น น้องอ๊บไม่ชอบ | ไม่มีบันทึกน้ำครบ 2 ชม. (นับจาก `last_logged_timestamp` ของรอบวัน หรือจาก 06:00:00) และ `daily_water_count` < 8 · ส่งครั้งเดียวต่อรอบนับ | บันทึกน้ำ → ยกเลิกและเริ่มนับใหม่ · `daily_water_count` ≥ 8 → หยุดเรื่องน้ำทั้งรอบวัน |
| น้ำ: 4 ชม. | น้ำ | โปรดดื่มน้ำเถอะคนนี้ น้องอ๊บคอแห้งไม่ไหวแล้วววว ดื่มน้ำๆๆ | ไม่มีบันทึกน้ำครบ **4** ชม. (นับจาก `last_logged_timestamp` ของรอบวัน หรือจาก 06:00:00) และ `daily_water_count` < 8 · ส่งครั้งเดียวต่อรอบนับ | บันทึกน้ำ → ยกเลิกและเริ่มนับใหม่ · `daily_water_count` ≥ 8 → หยุดเรื่องน้ำทั้งรอบวัน |
| อาหาร: ยังไม่กิน | อาหาร | กินข้าวยัง อย่าลืมพักกินข้าวบ้างนะค้าบ แล้วอย่าลืมมาให้อาหารน้องอ๊บด้วย | เวลา 12:00:00, 15:00:00, 18:00:00 ถ้า `total_calories` ของรอบวัน = 0 | `total_calories` > 0 → ยกเลิกรอบที่เหลือของวัน |
| อาหาร: 21:00 | อาหาร | น้องอ๊บหิวแล้วน้า ถ้าทานแล้วมาบอกน้องอ๊บด้วยนะ | เวลา 21:00:00 ส่งครั้งเดียว · ผู้ใช้ที่มีเป้าแคลอรี่: `total_calories` < เป้า · ผู้ใช้ที่ไม่มีเป้าแคลอรี่: `total_calories` = 0 | `total_calories` ≥ เป้า → ไม่ส่ง · ไม่มีเป้าและ `total_calories` > 0 → ไม่ส่ง |

นิยามใต้ตาราง:
- "รอบนับ" = ช่วงตั้งแต่จุดเริ่มของตัวนับ จนถึงเหตุการณ์ที่ทำให้เริ่มนับใหม่ (ก้าวใหม่ / บันทึกขยับเอง / บันทึกน้ำ) หรือจนจบรอบวัน
- "ผู้ใช้ที่ไม่มีเป้าแคลอรี่" = ผู้ใช้ที่ข้ามโปรไฟล์สุขภาพ
- "ครบเป้าน้ำ" = `daily_water_count` ≥ 8 แก้ว (หลอดพลังงานน้ำ 100% ตามสูตร 12.5% ต่อแก้วของฟีเจอร์น้ำ)
- "ผู้ใช้ตรวจก้าวไม่ได้" = ปฏิเสธสิทธิ์ Activity Recognition หรือเครื่องไม่มีเซนเซอร์นับก้าว

หมายเหตุใต้ตาราง:
- ที่ 21:00:00 ส่งเฉพาะ "อาหาร: 21:00" ไม่ส่ง "อาหาร: ยังไม่กิน"
- "อาหาร: ยังไม่กิน" ดูยอดแคลอรี่ทั้งรอบวัน ผู้ใช้ที่บันทึกอาหารแล้ว (เช่น มื้อเช้า) จะไม่ได้ "อาหาร: ยังไม่กิน" ในวันนั้น
- ถึง 100% ของเป้าก้าวแล้ว "เดิน: ไม่ขยับ" ยังทำงานตามปกติ (ไม่หยุด)
- ข้อความทั้งหมดเป็นน้ำเสียงน้องอ๊บ ห้ามเพิ่มคำแนะนำเรื่องปริมาณน้ำ แคลอรี่ หรือสุขภาพ
- "อาหาร: 21:00" เป็นถ้อยคำที่ปรับให้นุ่มลงจากต้นฉบับ (ต้นฉบับกดดันผู้ใช้ว่า "แอบทานแล้วไม่บอก") A ยืนยันให้ปรับน้ำเสียงแล้ว

### ตาราง Acceptance Criteria

| ID | อ้างถึง | เงื่อนไข (ก่อน / เมื่อ / แล้ว) | ค่าที่ทดสอบได้ |
|---|---|---|---|
| AC-1 | US-1 | ก่อน: ผู้ใช้สมัครและกรอกข้อมูลส่วนตัวเสร็จสิ้น / เมื่อ: ผู้ใช้เข้าหน้า Home ครั้งแรก / แล้ว: การ์ดขอความยินยอมแสดงทับหน้า Home | แสดงครั้งเดียว |
| AC-2 | US-1 | ก่อน: การ์ดขอความยินยอมแสดง / เมื่อ: ผู้ใช้กดอนุญาต / แล้ว: ฟีเจอร์ทำงานและกล่องขอสิทธิ์แจ้งเตือนของระบบปรากฏ | กล่องขอสิทธิ์ของระบบปรากฏ |
| AC-3 | US-1 | ก่อน: การ์ดขอความยินยอมแสดง / เมื่อ: ผู้ใช้กดไม่อนุญาต / แล้ว: ฟีเจอร์ไม่ทำงาน ไม่ถามซ้ำเอง และไม่เรียกกล่องขอสิทธิ์ของระบบ | ไม่เรียกกล่องขอสิทธิ์ |
| AC-4 | US-1 | ก่อน: การ์ดขอความยินยอมแสดง / เมื่อ: ผู้ใช้เข้าหน้า Home ครั้งที่ 2 / แล้ว: การ์ดขอความยินยอมไม่แสดงอีก | แสดงครั้งเดียว |
| AC-5 | US-1 | ก่อน: ผู้ใช้เปิดหน้าตั้งค่า / เมื่อ: ดูสวิตช์เปิด/ปิดแจ้งเตือนทั้งหมด / แล้ว: แสดงสถานะสวิตช์ตรงกับคำตอบบนการ์ด | เปิดหรือปิด |
| AC-6 | US-1 | ก่อน: สวิตช์ปิดอยู่และยังไม่เคยได้สิทธิ์จากระบบ / เมื่อ: ผู้ใช้เปิดสวิตช์ / แล้ว: แอปเรียกกล่องขอสิทธิ์ของระบบ | กล่องขอสิทธิ์ของระบบปรากฏ |
| AC-7 | US-1 | ก่อน: สวิตช์เปิดอยู่ / เมื่อ: ผู้ใช้ปิดสวิตช์ / แล้ว: ยกเลิกข้อความที่ตั้งไว้ทั้งหมด และไม่ตั้งใหม่จนกว่าจะเปิด | ยกเลิกทั้งหมด |
| AC-8 | US-1 | ก่อน: ระบบปฏิเสธสิทธิ์แจ้งเตือน / เมื่อ: ตรวจสอบสถานะ / แล้ว: ถือเป็นปิด ไม่ส่งข้อความใด และหน้าตั้งค่าแสดงว่าสิทธิ์ถูกปิดจากระบบ | สิทธิ์ถูกปิดจากระบบ |
| AC-9 | US-2 | ก่อน: ไม่มีก้าวใหม่ครบ 4 ชม. นับจากก้าวล่าสุดหรือ 06:00:00 / เมื่อ: เวลาจำลองถึงกำหนด / แล้ว: ส่งข้อความ "เดิน: ไม่ขยับ" (ยอมให้ช้าได้ไม่เกิน 60 นาที) | 4 ชม. (ช้าสุดไม่เกิน 60 นาที) |
| AC-10 | US-2 | ก่อน: `current_steps` ÷ `daily_goal` อยู่ที่ 79.99% / เมื่อ: อัปเดตก้าว / แล้ว: ไม่ส่งข้อความ "เดิน: ใกล้เป้า" | 79.99% (ไม่ส่ง) |
| AC-11 | US-2 | ก่อน: `current_steps` ÷ `daily_goal` อยู่ที่ 80.00% / เมื่อ: อัปเดตก้าว / แล้ว: ส่งข้อความ "เดิน: ใกล้เป้า" | 80.00% (ส่ง) |
| AC-12 | US-2 | ก่อน: `current_steps` ÷ `daily_goal` อยู่ที่ 99.99% / เมื่อ: อัปเดตก้าว / แล้ว: ส่งข้อความ "เดิน: ใกล้เป้า" | 99.99% (ส่ง) |
| AC-13 | US-2 | ก่อน: `current_steps` ÷ `daily_goal` อยู่ที่ 100.00% / เมื่อ: อัปเดตก้าว / แล้ว: ไม่ส่งข้อความ "เดิน: ใกล้เป้า" | 100.00% (ไม่ส่ง) |
| AC-14 | US-2 | ก่อน: ก้าวข้ามจากต่ำกว่า 80% ไป ≥ 100% ในรอบอัปเดตเดียว / เมื่อ: อัปเดตก้าว / แล้ว: ไม่ส่ง "เดิน: ใกล้เป้า" | ไม่ส่ง |
| AC-15 | US-2 | ก่อน: ผู้ใช้ตรวจก้าวไม่ได้ / เมื่อ: ไม่มีบันทึกขยับเองครบ 4 ชม. นับจากบันทึกล่าสุดหรือ 06:00:00 / แล้ว: ส่งข้อความ "เดิน: บันทึกเอง" | 4 ชม. |
| AC-16 | US-3 | ก่อน: ไม่มีบันทึกน้ำครบ 2 ชม. นับจาก `last_logged_timestamp` หรือ 06:00:00 และ `daily_water_count` < 8 / เมื่อ: เวลาจำลองถึงกำหนด (เช่น ครบ 2:00:00 พอดี) / แล้ว: ส่งข้อความ "น้ำ: 2 ชม." | 2 ชม. |
| AC-17 | US-3 | ก่อน: ส่ง "น้ำ: 2 ชม." แล้ว / เมื่อ: ยังไม่บันทึกน้ำ / แล้ว: ไม่ส่ง "น้ำ: 2 ชม." ซ้ำในรอบนับเดียวกัน | ไม่ส่งซ้ำ |
| AC-18 | US-3 | ก่อน: ไม่มีบันทึกน้ำครบ 4 ชม. นับจาก `last_logged_timestamp` หรือ 06:00:00 และ `daily_water_count` < 8 / เมื่อ: เวลาจำลองถึงกำหนด / แล้ว: ส่งข้อความ "น้ำ: 4 ชม." | 4 ชม. |
| AC-19 | US-3 | ก่อน: `daily_water_count` ถึง 8 (≥ 8 แก้ว) / เมื่อ: ถึงกำหนดเรื่องน้ำ / แล้ว: หยุดเรื่องน้ำทั้งรอบวัน | หยุดเรื่องน้ำทั้งวัน |
| AC-20 | US-4 | ก่อน: `total_calories` ของรอบวัน = 0 / เมื่อ: เวลาจำลองถึง 12:00:00, 15:00:00 หรือ 18:00:00 / แล้ว: ส่งข้อความ "อาหาร: ยังไม่กิน" | 12:00/15:00/18:00 |
| AC-21 | US-4 | ก่อน: บันทึกอาหารแล้ว (`total_calories` > 0) / เมื่อ: ถึงเวลา 12:00:00, 15:00:00 หรือ 18:00:00 / แล้ว: ยกเลิกรอบที่เหลือของวัน | ยกเลิกรอบที่เหลือ |
| AC-22 | US-4 | ก่อน: ผู้ใช้มีเป้าแคลอรี่และ `total_calories` < เป้า / เมื่อ: เวลาจำลองถึง 21:00:00 / แล้ว: ส่งข้อความ "อาหาร: 21:00" | 21:00:00 |
| AC-23 | US-4 | ก่อน: ผู้ใช้ไม่มีเป้าแคลอรี่และ `total_calories` = 0 / เมื่อ: เวลาจำลองถึง 21:00:00 / แล้ว: ส่งข้อความ "อาหาร: 21:00" | 21:00:00 |
| AC-24 | US-4 | ก่อน: ผู้ใช้มีเป้าแคลอรี่และ `total_calories` ≥ เป้า / เมื่อ: เวลาจำลองถึง 21:00:00 / แล้ว: ไม่ส่ง "อาหาร: 21:00" | ไม่ส่ง |
| AC-25 | US-4 | ก่อน: ผู้ใช้ไม่มีเป้าแคลอรี่และ `total_calories` > 0 / เมื่อ: เวลาจำลองถึง 21:00:00 / แล้ว: ไม่ส่ง "อาหาร: 21:00" | ไม่ส่ง |
| AC-26 | US-5 | ก่อน: ช่วงเวลา 23:00:00 ถึง 05:59:59 / เมื่อ: เวลาจำลองอยู่ที่ 23:00:00 (ขอบ: 23:00:00 ไม่ส่ง, 06:00:00 ส่งได้) / แล้ว: ไม่ส่งข้อความใดเลย | 23:00:00 ถึง 05:59:59 |
| AC-27 | US-5 | ก่อน: บันทึกน้ำล่าสุด 22:30:00 / เมื่อ: ข้ามช่วงห้ามเตือน / แล้ว: ตัวนับ "น้ำ: 2 ชม." เริ่มที่ 06:00:00 ของวันถัดไป และส่งได้ที่ 08:00:00 | เริ่มที่ 06:00:00 ส่งที่ 08:00:00 |
| AC-28 | US-5 | ก่อน: ส่งข้อความไปแล้ว 6 ข้อความในรอบวัน / เมื่อ: มีข้อความใหม่เข้าเงื่อนไข / แล้ว: ไม่ส่งเพิ่มจนถึง 05:00:00 รอบวันถัดไป ข้อความที่เข้าเงื่อนไขระหว่างนั้นถูกยกเลิก | เพดาน 6 ข้อความ |
| AC-29 | US-5 | ก่อน: ส่งข้อความล่าสุดไปแล้ว / เมื่อ: ข้อความถัดไปจะส่งแต่ห่างจากข้อความล่าสุด 29:59 นาที / แล้ว: ข้อความถูกเลื่อน | ห่าง 29:59 นาที (เลื่อน) |
| AC-30 | US-5 | ก่อน: ส่งข้อความล่าสุดไปแล้ว / เมื่อ: ข้อความถัดไปจะส่งและห่างจากข้อความล่าสุด 30:00 นาทีพอดี / แล้ว: ส่งข้อความได้ | ห่าง 30:00 นาที (ส่งได้) |
| AC-31 | US-5 | ก่อน: หลายข้อความเข้าเงื่อนไขพร้อมกันหรือชนเพดาน/ระยะห่าง / เมื่อ: ระบบจัดลำดับ / แล้ว: เรียงลำดับความสำคัญ อาหาร > น้ำ > เดิน | อาหาร > น้ำ > เดิน |
| AC-32 | US-5 | ก่อน: ข้อความถูกเลื่อนเพราะระยะห่างหรือลำดับ / เมื่อ: ยังเข้าเงื่อนไข ไม่อยู่ในช่วงห้ามเตือน และยังไม่ชนเพดาน / แล้ว: ส่งทีหลังได้ | ส่งทีหลัง |
| AC-33 | US-5 | ก่อน: ข้อความถูกเลื่อน / เมื่อ: เวลาจำลองถึง 23:00:00 และยังไม่ได้ส่ง / แล้ว: ยกเลิกข้อความนั้น | ยกเลิกตอน 23:00:00 |
| AC-34 | US-5 | ก่อน: ข้อความเรื่องนั้นรอส่ง / เมื่อ: ผู้ใช้ทำสิ่งที่ถูกเตือนแล้ว (บันทึกน้ำ / บันทึกอาหาร / มีก้าวใหม่ / บันทึกขยับเอง) / แล้ว: ยกเลิกข้อความที่รอส่งของเรื่องนั้นทันที | ยกเลิกทันที |
| AC-35 | US-5 | ก่อน: ถึงเวลา 05:00:00 / เมื่อ: ถึงเวลารีเซ็ตรอบวัน / แล้ว: จำนวนข้อความที่ส่งแล้ว = 0 และสถานะ "เดิน: ใกล้เป้า" ส่งแล้ว = ไม่ | รีเซ็ตที่ 05:00:00 |
| AC-36 | US-6 | ก่อน: แจ้งเตือนถูกส่งบน Android / เมื่อ: ผู้ใช้มองเห็นแจ้งเตือน / แล้ว: แสดงแบบแชต 3 ส่วน คือ ชื่อผู้ส่ง "น้องอ๊บ" + รูปโปรไฟล์รูปกบขยิบตาทำปากจู๋ + ข้อความแจ้งเตือน | แสดงแบบแชต 3 ส่วน |
| AC-37 | US-6 | ก่อน: แจ้งเตือนถูกส่งบน iOS / เมื่อ: ผู้ใช้มองเห็นแจ้งเตือน / แล้ว: แจ้งเตือนปกติ 2 ส่วน คือ ไอคอนแอป + ข้อความแจ้งเตือน ไม่มีรูปโปรไฟล์ | แสดงปกติ 2 ส่วน |
| AC-38 | US-7 | ก่อน: มีแจ้งเตือนเรื่องเดิน / เมื่อ: ผู้ใช้กดแจ้งเตือน / แล้ว: เปิดแอปและไปที่หน้าฟีเจอร์เดินทันที (ใช้ได้ทั้งแอปเปิดอยู่, เบื้องหลัง, ปิดสนิท) | หน้าเดิน |
| AC-39 | US-7 | ก่อน: มีแจ้งเตือนเรื่องน้ำ / เมื่อ: ผู้ใช้กดแจ้งเตือน / แล้ว: เปิดแอปและไปที่หน้าน้ำทันที (ใช้ได้ทั้งแอปเปิดอยู่, เบื้องหลัง, ปิดสนิท) | หน้าน้ำ |
| AC-40 | US-7 | ก่อน: มีแจ้งเตือนเรื่องอาหาร / เมื่อ: ผู้ใช้กดแจ้งเตือน / แล้ว: เปิดแอปและไปที่หน้าอาหารทันที (ใช้ได้ทั้งแอปเปิดอยู่, เบื้องหลัง, ปิดสนิท) | หน้าอาหาร |

## 4. Edge cases

| ID | สถานการณ์ | ผลที่คาดหวัง |
|---|---|---|
| EC-1 | กดสวิตช์เปิด/ปิดแจ้งเตือนรัว ๆ | ใช้สถานะสุดท้ายที่กดเป็นตัวตัดสิน ข้อความที่ตั้งไว้ตรงกับสถานะสุดท้ายเท่านั้น |
| EC-2 | กดแจ้งเตือนอันเดียวกันซ้ำหลายครั้งติดกัน | เปิดหน้าของเรื่องนั้นหน้าเดียว ไม่เปิดซ้อน |
| EC-3 | ค่าที่อ่านจากฟีเจอร์อื่นติดลบ (`current_steps`, `daily_water_count`, `total_calories`) หรือ `daily_goal` = 0 | ไม่ส่งข้อความของเรื่องนั้นในรอบวันนั้น |
| EC-4 | `daily_water_count` เกิน 8 (เช่น 12 แก้ว) | ถือว่าครบเป้าน้ำ ไม่ส่งข้อความเรื่องน้ำ |
| EC-5 | หลายข้อความครบกำหนดพร้อมกัน | ระบบจัดส่งตามลำดับความสำคัญ (อาหาร > น้ำ > เดิน) โดยเว้นระยะห่างตามกำหนด |
| EC-6 | บันทึกน้ำ/อาหาร/มีก้าวใหม่/บันทึกขยับเองระหว่างข้อความเรื่องนั้นรอส่ง | ยกเลิกข้อความนั้นทันที |
| EC-7 | ครบกำหนดข้อความในช่วงห้ามเตือน (23:00:00 ถึง 05:59:59) | ไม่ส่งข้อความในคืนนั้น และตัวนับเริ่มใหม่ตามกติกาหลังช่วงห้ามเตือน |
| EC-8 | ข้ามรอบ 05:00:00 | รีเซ็ตจำนวนข้อความที่ส่งแล้วเป็น 0 และรีเซ็ตสถานะ "เดิน: ใกล้เป้า" เป็นยังไม่ส่ง |
| EC-9 | กดไม่อนุญาตบนการ์ดแล้วเปิดสวิตช์ทีหลัง | แอปเรียกกล่องขอสิทธิ์ของระบบ (ครั้งแรกสำหรับผู้ที่เคยกดไม่อนุญาตบนการ์ด) |
| EC-10 | ระบบปฏิเสธสิทธิ์แจ้งเตือน | ถือเป็นปิด ไม่ส่งข้อความใด และหน้าตั้งค่าแสดงว่าสิทธิ์ถูกปิดจากระบบ |
| EC-11 | ก้าวข้าม 80% และ 100% ในรอบอัปเดตเดียว (เช่น จาก 70.00% ไป 100.00%) | ไม่ส่ง "เดิน: ใกล้เป้า" (ตรงกับ AC-14) |
| EC-12 | ผู้ใช้ตรวจก้าวไม่ได้ | ไม่ได้รับ "เดิน: ไม่ขยับ" และ "เดิน: ใกล้เป้า" แต่ได้รับ "เดิน: บันทึกเอง" แทน |
| EC-13 | เปิดแอปจากแจ้งเตือนตอนปิดสนิท | เปิดแอปและไปที่หน้าของเรื่องนั้นทันที |
| EC-14 | ไม่เปิดแอปข้ามรอบวัน | จะไม่มีข้อความของรอบวันใหม่จนกว่าผู้ใช้จะเปิดแอป เมื่อเปิดแอป ระบบตั้งข้อความของรอบวันปัจจุบันใหม่ตามกติกาทั้งหมด |
| EC-15 | ส่งครบ 6 ข้อความก่อน 21:00 | ส่งครบ 6 แล้วไม่ส่งเพิ่มจนถึง 05:00:00 รอบวันถัดไป ข้อความที่เข้าเงื่อนไขระหว่างนั้นถูกยกเลิก |

## 5. สิ่งที่ไม่ทำในรอบนี้ (Out of scope)
- ไม่มี push จากเซิร์ฟเวอร์
- ไม่มีหน้าตั้งค่ารายประเภท (เปิด/ปิดเฉพาะเดิน/น้ำ/อาหาร) และไม่ให้ผู้ใช้ปรับเวลา ความถี่ หรือช่วงห้ามเตือนเอง
- ไม่ตรวจการขยับแบบไม่นับก้าว
- ไม่รับประกันเวลาเป๊ะของ "เดิน: ไม่ขยับ" และ "เดิน: ใกล้เป้า" (ช้าได้ไม่เกิน 60 นาที)
- iOS ไม่มีรูปโปรไฟล์แบบแชต
- ไม่รองรับการเดินทางข้ามเขตเวลา (ใช้เวลาท้องถิ่นของเครื่อง)
- ไม่ส่งข้อความของรอบวันใหม่ถ้าผู้ใช้ไม่เปิดแอปเลย
- ไม่ให้คำแนะนำสุขภาพหรือตัวเลขที่ควรกิน/ดื่ม
- แจ้งเตือนไม่มีผลต่ออารมณ์หรือค่าใด ๆ ของน้องอ๊บ
- Design ไม่ต้องทำกติกาเกมหรือภาพอารมณ์สัตว์เลี้ยงสำหรับฟีเจอร์นี้ ใช้ภาพโปรไฟล์กบ 1 ภาพเท่านั้น

## 6. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น)

| ข้อมูล | ชนิด/หน่วย | เก็บที่ไหน |
|---|---|---|
| `current_steps` | จำนวนเต็ม (ก้าว) | อ่านจากฟีเจอร์เดิน (`docs/steps/`) |
| `daily_goal` | จำนวนเต็ม (ก้าว) | อ่านจากฟีเจอร์เดิน (`docs/steps/`) |
| สถานะสิทธิ์ Activity Recognition และการมีเซนเซอร์นับก้าว | สถานะ (มี/ไม่มี, อนุญาต/ปฏิเสธ) | อ่านจากฟีเจอร์เดิน (`docs/steps/`) |
| ปุ่มบันทึกการขยับเอง | การกระทำ | อ่านจากฟีเจอร์เดิน (`docs/steps/`) |
| `daily_water_count` | จำนวนเต็ม (แก้ว) | อ่านจากฟีเจอร์น้ำ (`docs/water/`) |
| `last_logged_timestamp` | วันที่และเวลา | อ่านจากฟีเจอร์น้ำ (`docs/water/`) |
| `total_calories` | จำนวนเต็ม (kcal) | อ่านจากฟีเจอร์อาหาร (`docs/food/`) |
| เป้าแคลอรี่รายวันจากโปรไฟล์ | จำนวนเต็ม (kcal) | อ่านจากฟีเจอร์อาหาร (`docs/food/`) |
| สถานะความยินยอมบนการ์ด | อนุญาต / ไม่อนุญาต / ยังไม่ตอบ | Local Storage |
| สถานะสวิตช์แจ้งเตือนทั้งหมด | เปิด / ปิด | Local Storage |
| สถานะสิทธิ์แจ้งเตือนของระบบ | อนุญาต / ปฏิเสธ / ยังไม่เคยขอ | Local Storage |
| จำนวนข้อความที่ส่งแล้วในรอบวัน | จำนวนเต็ม 0–6 | Local Storage |
| เวลาส่งข้อความล่าสุด | วันที่และเวลา | Local Storage |
| "เดิน: ใกล้เป้า" ส่งแล้วในรอบวันหรือยัง | ใช่ / ไม่ | Local Storage |
| เวลาบันทึกขยับเองล่าสุด | วันที่และเวลา | Local Storage |
| เวลาที่ `current_steps` เพิ่มล่าสุด | วันที่และเวลา | Local Storage |

## 7. คำถามที่ยังเปิดอยู่
1. (ถาม Design) ชื่อไฟล์ภาพโปรไฟล์กบสำหรับแจ้งเตือน Android
2. (ถาม Design) ข้อความในหน้าตั้งค่าเมื่อระบบปฏิเสธสิทธิ์แจ้งเตือน

=== จบ docs/notification-feature/requirements.md ===

=== docs/notification-feature/ux-flow.md ===
# UX flow: ฟีเจอร์แจ้งเตือน (notification-feature)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: เพื่อน B · อ้างอิง: requirements.md

## 1. รายการหน้าจอ

| ID | ชื่อหน้าจอ | จุดประสงค์ | อ้างถึง |
|---|---|---|---|
| S-1 | การ์ดขอความยินยอม (Consent Card) | แสดงทับหน้า Home เมื่อเข้าหน้า Home ครั้งแรกหลัง Onboarding เพื่อให้ผู้ใช้เลือกอนุญาตหรือไม่อนุญาตรับแจ้งเตือน (แสดงครั้งเดียว) | US-1, AC-1, AC-2, AC-3, AC-4, EC-9 |
| S-2 | หน้าตั้งค่าแจ้งเตือน (Notification Settings Screen) | เข้าถึงจากเมนูตั้งค่าเพื่อให้ผู้ใช้เปิด/ปิดแจ้งเตือนทั้งหมดผ่านสวิตช์หลัก 1 อัน และดูสถานะกรณีสิทธิ์ถูกปิดจากระบบ | US-1, AC-5, AC-6, AC-7, AC-8, EC-1, EC-9, EC-10 |
| S-3 | การแจ้งเตือนบนระบบปฏิบัติการ (OS Notification Display) | แสดงข้อความแจ้งเตือนจากน้องอ๊บตามรูปแบบของ Android (แชต 3 ส่วน) หรือ iOS (ปกติ 2 ส่วน) และรับการกดเพื่อนำทางไปหน้าฟีเจอร์ทันที | US-2, US-3, US-4, US-5, US-6, US-7, AC-9 ถึง AC-40, EC-2, EC-13 |

## 2. องค์ประกอบบนหน้าจอ

### S-1 การ์ดขอความยินยอม (Consent Card)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| พื้นหลังการ์ดทับหน้า Home | Modal Overlay Card | แสดงทับหน้า Home เฉพาะการเข้าหน้า Home ครั้งแรกหลังสมัครและกรอกข้อมูลส่วนตัวเสร็จ (ไม่แก้เส้นทางของฟีเจอร์ `signup`) | บล็อกการกดทะลุหลังการ์ดจนกว่าผู้ใช้จะเลือกปุ่มใดปุ่มหนึ่ง การ์ดแสดงครั้งเดียว ไม่แสดงซ้ำในการเข้าหน้า Home ครั้งที่ 2 เป็นต้นไป (AC-1, AC-4) |
| รูปโปรไฟล์น้องอ๊บ | รูปภาพ (Image) | `assets/images/pet_profile_frog.png` | แสดงรูปกบขยิบตาทำปากจู๋คงที่ 1 ภาพ (ไม่มีผลเมื่อกด) |
| หัวข้อการ์ด | ข้อความหัวข้อ (Title Text) | น้องอ๊บอยากส่งเสียงหา! | - |
| รายละเอียดการ์ด | ข้อความเนื้อหา (Body Text) | อนุญาตให้น้องอ๊บแจ้งเตือนเรื่องการเดิน การดื่มน้ำ และการกินอาหารนะค้าบ | - (ไม่มีคำแนะนำสุขภาพ และไม่ระบุว่าแจ้งเตือนเปลี่ยนอารมณ์น้องอ๊บ) |
| ปุ่มอนุญาต | ปุ่มหลัก (Primary Button) | อนุญาต | บันทึก `consent_status = ALLOWED (อนุญาต)` และ `notification_master_switch = ON (เปิด)` ลง Local Storage, ปิดการ์ดทันที, เปิดใช้งานฟีเจอร์ และเรียกกล่องขอสิทธิ์แจ้งเตือนของระบบ (`OS Permission Dialog`) ต่อทันที (AC-2, AC-5) |
| ปุ่มไม่อนุญาต | ปุ่มรอง (Secondary Button) | ไม่อนุญาต | บันทึก `consent_status = DENIED (ไม่อนุญาต)` และ `notification_master_switch = OFF (ปิด)` ลง Local Storage, ปิดการ์ดทันที, ฟีเจอร์ไม่ทำงาน ไม่ถามซ้ำเอง และไม่เรียกกล่องขอสิทธิ์ของระบบ (AC-3, AC-4, AC-5) |

### S-2 หน้าตั้งค่าแจ้งเตือน (Notification Settings Screen)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| หัวข้อหน้าตั้งค่า | ข้อความหัวข้อ (Title Text) | การแจ้งเตือนของน้องอ๊บ | - |
| สวิตช์เปิด/ปิดแจ้งเตือนทั้งหมด | สวิตช์ (Switch 1 อัน) | `ON (เปิด)` / `OFF (ปิด)` (ค่าเริ่มต้นตรงกับคำตอบบนการ์ด S-1 ตาม AC-5; ถ้าระบบปฏิเสธสิทธิ์จะแสดงเป็น `OFF (ปิด)` ตาม AC-8) | - เปลี่ยนเป็น `ON (เปิด)` และยังไม่เคยได้สิทธิ์จากระบบ (`NOT_DETERMINED`) → เรียกกล่องขอสิทธิ์ของระบบทันที (AC-6, EC-9) หากได้รับสิทธิ์จะตั้งเวลาแจ้งเตือนของรอบวันปัจจุบันตาม `game-rules.md`<br>- เปลี่ยนเป็น `OFF (ปิด)` → ยกเลิกข้อความที่ตั้งไว้ทั้งหมดทันที และไม่ตั้งใหม่จนกว่าจะเปิดอีกครั้ง (AC-7)<br>- กดสลับรัว ๆ → ใช้สถานะสุดท้ายที่กดเป็นตัวตัดสิน (EC-1) |
| ข้อความสถานะเมื่อสิทธิ์ถูกปิดจากระบบ | ข้อความแจ้งสถานะ (Warning Text) | สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน | แสดงบริเวณใต้สวิตช์เฉพาะเมื่อ `system_permission_status == DENIED (ปฏิเสธ)` (ปฏิเสธในกล่องขอสิทธิ์หรือปิดในการตั้งค่าเครื่อง) โดยระบบถือเป็นปิดและไม่ส่งข้อความใด (AC-8, EC-10) |

### S-3 การแจ้งเตือนบนระบบปฏิบัติการ (OS Notification Display)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| รูปแบบแจ้งเตือน Android (แบบแชต 3 ส่วน) | OS Notification (Android Chat Style) | 1. ชื่อผู้ส่ง: `น้องอ๊บ`<br>2. รูปโปรไฟล์: `assets/images/pet_profile_frog.png` (รูปกบขยิบตาทำปากจู๋ รูปเดียวคงที่ ไม่เปลี่ยนตามอารมณ์)<br>3. ข้อความแจ้งเตือน: ข้อความคำต่อคำตามตารางด้านล่าง (AC-36) | เปิดแอปและนำทางไปยังหน้าจอของเรื่องนั้นทันทีตามตาราง 3.1 (AC-38, AC-39, AC-40) |
| รูปแบบแจ้งเตือน iOS (ปกติ 2 ส่วน) | OS Notification (iOS Standard Style) | 1. ไอคอนแอป PetPal Health (ไม่มีรูปโปรไฟล์แบบแชต)<br>2. ข้อความแจ้งเตือน: ข้อความคำต่อคำตามตารางด้านล่าง (AC-37) | เปิดแอปและนำทางไปยังหน้าจอของเรื่องนั้นทันทีตามตาราง 3.1 (AC-38, AC-39, AC-40) |

#### ตารางข้อความแจ้งเตือนคำต่อคำที่แสดงบน S-3 (อ้างอิงเงื่อนไขละเอียดใน `game-rules.md` หัวข้อ 1.1)
| ชื่อเรียก | เรื่อง | ข้อความที่แสดงจริง (Exact String) | หน้าจอปลายทางเมื่อกด |
|---|---|---|---|
| เดิน: ไม่ขยับ | เดิน | อย่าลืมขยับบ้างนะ อย่ามัวแต่นั่งอืด ลุกขึ้นมาเดินเร็ว!! | หน้าฟีเจอร์เดิน (`docs/steps/`) |
| เดิน: ใกล้เป้า | เดิน | มาขยับร่างกายกันอีกนิด ใกล้ถึงเป้าหมายแล้วสู้ๆ | หน้าฟีเจอร์เดิน (`docs/steps/`) |
| เดิน: บันทึกเอง | เดิน (ตรวจก้าวไม่ได้) | อย่าลืมขยับร่างกายน้า ถ้าขยับแล้วมาอัปเดตให้น้องอ๊บด้วย | หน้าฟีเจอร์เดิน (`docs/steps/`) |
| น้ำ: 2 ชม. | น้ำ | อย่าลืมดื่มน้ำน้าา ผิวกบของน้องขาดความชุ่มชื้น น้องอ๊บไม่ชอบ | หน้าฟีเจอร์น้ำ (`docs/water/`) |
| น้ำ: 4 ชม. | น้ำ | โปรดดื่มน้ำเถอะคนนี้ น้องอ๊บคอแห้งไม่ไหวแล้วววว ดื่มน้ำๆๆ | หน้าฟีเจอร์น้ำ (`docs/water/`) |
| อาหาร: ยังไม่กิน | อาหาร | กินข้าวยัง อย่าลืมพักกินข้าวบ้างนะค้าบ แล้วอย่าลืมมาให้อาหารน้องอ๊บด้วย | หน้าฟีเจอร์อาหาร (`docs/food/`) |
| อาหาร: 21:00 | อาหาร | น้องอ๊บหิวแล้วน้า ถ้าทานแล้วมาบอกน้องอ๊บด้วยนะ | หน้าฟีเจอร์อาหาร (`docs/food/`) |

## 3. ขั้นตอนการใช้งาน (happy path)

1. **เข้าหน้า Home ครั้งแรกหลัง Onboarding:** ผู้ใช้สมัครและกรอกข้อมูลส่วนตัวเสร็จสิ้น ระบบพาเข้าหน้า Home ครั้งแรก และแสดงการ์ดขอความยินยอม (S-1) ทับหน้า Home เพียงครั้งเดียว (US-1, AC-1, AC-4)
2. **อนุญาตความยินยอมและสิทธิ์ของระบบ:** ผู้ใช้กดปุ่ม `อนุญาต` บน S-1 ระบบบันทึก `consent_status = ALLOWED (อนุญาต)` และ `notification_master_switch = ON (เปิด)` ปิดการ์ดทันที และเรียกกล่องขอสิทธิ์แจ้งเตือนของระบบ (`OS Permission Dialog`) ต่อทันที (AC-2, AC-5)
3. **เริ่มระบบตั้งเวลาในเครื่อง:** เมื่อผู้ใช้กดอนุญาตในกล่องขอสิทธิ์ของระบบ (`system_permission_status = GRANTED (อนุญาต)`) ระบบแจ้งเตือนในเครื่อง (Local Notification) จะตรวจสอบข้อมูลจากฟีเจอร์เดิน น้ำ และอาหาร และตั้งเวลาแจ้งเตือนของรอบวันปัจจุบันภายใต้กติกากลาง (ไม่ส่งช่วง `23:00:00`–`05:59:59`, เพดานไม่เกิน 6 ข้อความต่อรอบวัน, ห่างกันอย่างน้อย 30 นาที, ลำดับความสำคัญ `อาหาร > น้ำ > เดิน`) (US-2 ถึง US-5)
4. **แสดงแจ้งเตือนตามระบบปฏิบัติการ:** เมื่อถึงกำหนดเวลาหรือเข้าเงื่อนไข ระบบแสดงการแจ้งเตือน (S-3) โดยบน Android แสดงแบบแชต 3 ส่วน (ชื่อผู้ส่ง `"น้องอ๊บ"` + รูปกบขยิบตาทำปากจู๋ + ข้อความ) และบน iOS แสดงแบบปกติ 2 ส่วน (ไอคอนแอป + ข้อความ) (US-6, AC-36, AC-37)
5. **กดแจ้งเตือนเพื่อเข้าสู่ฟีเจอร์ทันที:** ผู้ใช้กดที่แจ้งเตือน ระบบเปิดแอปและพาไปยังหน้าฟีเจอร์ของเรื่องนั้นทันทีตามตาราง 3.1 เพื่อให้ผู้ใช้บันทึกข้อมูลได้ทันที และเมื่อผู้ใช้ทำกิจกรรมนั้นแล้ว ระบบยกเลิกข้อความที่รอส่งของเรื่องนั้นทันที (US-7, AC-34, AC-38, AC-39, AC-40)
6. **ควบคุมเปิด/ปิดผ่านหน้าตั้งค่า:** ผู้ใช้สามารถเปิดหน้าตั้งค่าแจ้งเตือน (S-2) จากเมนูตั้งค่าเพื่อดูหรือสลับสวิตช์เปิด/ปิดแจ้งเตือนทั้งหมดได้ตลอดเวลา (US-1, AC-5, AC-6, AC-7)

### 3.1 ตารางเส้นทาง Deep Linking และการนำทางข้ามสถานะแอป

| เรื่องของแจ้งเตือน | ชื่อเรียกข้อความที่ครอบคลุม | หน้าจอปลายทาง | สถานะแอปที่รองรับ | พฤติกรรมการนำทางและกันหน้าซ้อน | อ้างถึง |
|---|---|---|---|---|---|
| เดิน | เดิน: ไม่ขยับ, เดิน: ใกล้เป้า, เดิน: บันทึกเอง | หน้าฟีเจอร์เดิน (`docs/steps/`) | `FOREGROUND (แอปเปิดอยู่)`, `BACKGROUND (แอปอยู่เบื้องหลัง)`, `TERMINATED (แอปปิดสนิท)` | เปิดแอปและไปที่หน้าฟีเจอร์เดินทันที หากกดแจ้งเตือนเดิมซ้ำติดกันหลายครั้งจะเปิดเพียงหน้าเดียว ไม่เปิดซ้อนทับบน Stack | US-7, AC-38, EC-2, EC-13 |
| น้ำ | น้ำ: 2 ชม., น้ำ: 4 ชม. | หน้าฟีเจอร์น้ำ (`docs/water/`) | `FOREGROUND (แอปเปิดอยู่)`, `BACKGROUND (แอปอยู่เบื้องหลัง)`, `TERMINATED (แอปปิดสนิท)` | เปิดแอปและไปที่หน้าฟีเจอร์น้ำทันที หากกดแจ้งเตือนเดิมซ้ำติดกันหลายครั้งจะเปิดเพียงหน้าเดียว ไม่เปิดซ้อนทับบน Stack | US-7, AC-39, EC-2, EC-13 |
| อาหาร | อาหาร: ยังไม่กิน, อาหาร: 21:00 | หน้าฟีเจอร์อาหาร (`docs/food/`) | `FOREGROUND (แอปเปิดอยู่)`, `BACKGROUND (แอปอยู่เบื้องหลัง)`, `TERMINATED (แอปปิดสนิท)` | เปิดแอปและไปที่หน้าฟีเจอร์อาหารทันที หากกดแจ้งเตือนเดิมซ้ำติดกันหลายครั้งจะเปิดเพียงหน้าเดียว ไม่เปิดซ้อนทับบน Stack | US-7, AC-40, EC-2, EC-13 |

## 4. สถานะของหน้าจอ

| หน้าจอ | สถานะ | เงื่อนไขที่ทำให้เกิด | สิ่งที่แสดง |
|---|---|---|---|
| S-1 | `NORMAL (ปกติ)` | ผู้ใช้เข้าหน้า Home ครั้งแรกหลัง Onboarding และ `consent_status == UNANSWERED (ยังไม่ตอบ)` (AC-1) | แสดงการ์ดขอความยินยอมทับหน้า Home พร้อมรูปกบ ปุ่ม `อนุญาต` และปุ่ม `ไม่อนุญาต` |
| S-1 | `EMPTY (ว่าง/ไม่แสดง)` | ผู้ใช้เคยตอบบนการ์ดไปแล้ว (`ALLOWED` หรือ `DENIED`) เมื่อเข้าหน้า Home ครั้งที่ 2 เป็นต้นไป (AC-4) | ซ่อนการ์ดสนิท แสดงหน้า Home ตามปกติโดยไม่ถามซ้ำ |
| S-1 | `ERROR (ผิดพลาด)` | อ่านหรือบันทึกค่าความยินยอมใน Local Storage ไม่สำเร็จ | ปิดการ์ดโดยถือเป็นสถานะไม่อนุญาตชั่วคราว (ไม่ส่งแจ้งเตือนเองโดยไม่ได้รับความยินยอม) และให้ผู้ใช้ใช้งานหน้า Home หรือตั้งค่าภายหลังใน S-2 ได้ |
| S-2 | `NORMAL (ปกติ - เปิดใช้งาน)` | `notification_master_switch == ON (เปิด)` และ `system_permission_status == GRANTED (อนุญาต)` (AC-5) | แสดงสวิตช์แจ้งเตือนทั้งหมดในตำแหน่ง `ON (เปิด)` ไม่มีข้อความเตือนสิทธิ์ถูกปิด |
| S-2 | `EMPTY (ว่าง - ปิดใช้งานโดยผู้ใช้)` | ผู้ใช้เลือกไม่อนุญาตบน S-1 หรือปิดสวิตช์เอง (`notification_master_switch == OFF (ปิด)`) โดยที่ระบบไม่ได้ปฏิเสธสิทธิ์ (AC-3, AC-5, AC-7) | แสดงสวิตช์แจ้งเตือนทั้งหมดในตำแหน่ง `OFF (ปิด)` ไม่มีรายการแจ้งเตือนตั้งเวลารอส่งในระบบ |
| S-2 | `PERMISSION_DENIED (ผิดพลาด - สิทธิ์ถูกปิดจากระบบ)` | ระบบปฏิบัติการปฏิเสธสิทธิ์แจ้งเตือน (`system_permission_status == DENIED (ปฏิเสธ)`) ทั้งจากกล่องขอสิทธิ์หรือจากการตั้งค่าเครื่อง (AC-8, EC-10) | ถือเป็นสถานะปิด สวิตช์แสดง `OFF (ปิด)` ไม่ส่งข้อความใด และแสดงข้อความเตือน `"สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน"` |
| S-3 | `NORMAL (ปกติ)` | ข้อความเข้าเงื่อนไข ไม่อยู่ในช่วงห้ามเตือน (`23:00:00`–`05:59:59`) ยังไม่ชนเพดาน 6 ข้อความ และห่างจากข้อความล่าสุด ≥ 30:00 นาที (AC-30, AC-36, AC-37) | Android แสดงแบบแชต 3 ส่วน (`น้องอ๊บ` + รูป `assets/images/pet_profile_frog.png` + ข้อความ); iOS แสดงปกติ 2 ส่วน (ไอคอนแอป + ข้อความ) |
| S-3 | `EMPTY (ว่าง/ไม่มีการส่งแจ้งเตือน)` | อยู่ในช่วงห้ามเตือน (`23:00:00`–`05:59:59`), ส่งครบ 6 ข้อความในรอบวันแล้ว, สวิตช์ปิดอยู่, หรือไม่เปิดแอปข้ามรอบวัน (AC-7, AC-26, AC-28, EC-14, EC-15) | ไม่มีการแสดงแจ้งเตือนใด ๆ บนหน้าจอระบบปฏิบัติการ |
| S-3 | `ERROR (ผิดพลาด - ข้อมูลต้นทางไม่ถูกต้อง)` | ค่าที่อ่านจากฟีเจอร์อื่นติดลบ (`current_steps < 0`, `daily_water_count < 0`, `total_calories < 0`) หรือ `daily_goal == 0` (EC-3) | ระงับการส่งข้อความแจ้งเตือนของเรื่องนั้นในรอบวันนั้นทันที โดยไม่แสดงข้อความผิดพลาดรบกวนผู้ใช้ |

## 5. ไฟล์ภาพ assets

| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายภาพ |
|---|---|---|
| `assets/images/pet_profile_frog.png` | S-1 (การ์ดขอความยินยอม) และ S-3 (รูปโปรไฟล์แจ้งเตือนแบบแชตบน Android ตาม AC-36) | รูปโปรไฟล์น้องอ๊บ กบขยิบตาทำปากจู๋ พื้นหลังโปร่งใส ใช้ภาพเดียวคงที่ ไม่เปลี่ยนตามอารมณ์สัตว์เลี้ยง (ส่วน iOS ใช้ไอคอนแอปมาตรฐาน ไม่มีรูปโปรไฟล์ในรอบนี้ตาม AC-37) |

## 6. คำถามถึง Product

1. (ถาม Design) ชื่อไฟล์ภาพโปรไฟล์กบสำหรับแจ้งเตือน Android
   - *ข้อเสนอแนะจาก Design:* กำหนดชื่อไฟล์ภาพมาตรฐานเป็น `assets/images/pet_profile_frog.png` สำหรับรูปกบขยิบตาทำปากจู๋ เพื่อให้ใช้ร่วมกันได้ทั้งในการ์ดขอความยินยอม (S-1) และการแจ้งเตือนแบบแชตบน Android (S-3)
   - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ให้ Dev อ้างอิง Path `assets/images/pet_profile_frog.png` ในโค้ดแสดงผล S-1 และ Android Notification Builder ได้ทันที
   - *การประเมินสถานะการบล็อก:* `Blocking: ไม่ใช่` (เพราะกำหนดชื่อไฟล์และตำแหน่ง Asset ชัดเจนตรงกันทุกตารางแล้ว)

2. (ถาม Design) ข้อความในหน้าตั้งค่าเมื่อระบบปฏิเสธสิทธิ์แจ้งเตือน
   - *ข้อเสนอแนะจาก Design:* แสดงข้อความแจ้งสาเหตุและวิธีแก้ไขอย่างกระชับเป็นมิตรบริเวณใต้สวิตช์ในหน้าตั้งค่า (S-2) เมื่อตรวจพบว่าสิทธิ์แจ้งเตือนของระบบถูกปฏิเสธหรือถูกปิดจากเครื่อง
   - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ให้ Dev แสดงข้อความ Exact String ว่า `"สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน"` ในสถานะ `PERMISSION_DENIED` ของหน้า S-2 ได้ทันที
   - *การประเมินสถานะการบล็อก:* `Blocking: ไม่ใช่` (เพราะกำหนดข้อความ Exact String และเงื่อนไขการแสดงผลใน S-2 ครบถ้วนแล้ว)

=== จบ docs/notification-feature/ux-flow.md ===

=== docs/notification-feature/game-rules.md ===
# กติกาเกม: ฟีเจอร์แจ้งเตือน (notification-feature)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: เพื่อน B · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ชนิดข้อมูล | ความหมาย | ค่า | หน่วย | อ้างถึง |
|---|---|---|---|---|---|
| `DAILY_RESET_TIME` | String | เวลาเริ่มต้นรอบวันใหม่และรีเซ็ตตัวนับรายวันทั้งหมด (รอบวัน `05:00:00` ถึง `04:59:59` ของวันถัดไป อิงนาฬิกาในเครื่อง) | `"05:00:00"` | เวลา (`HH:MM:SS`) | AC-35, EC-8, EC-14 |
| `QUIET_HOURS_START_TIME` | String | เวลาเริ่มต้นช่วงห้ามเตือนตอนกลางคืน (**รวมขอบ** `23:00:00` ไม่ส่ง และยกเลิกข้อความที่ถูกเลื่อนค้างอยู่; `22:59:59` ส่งได้) | `"23:00:00"` | เวลา (`HH:MM:SS`) | AC-26, AC-33, EC-7 |
| `QUIET_HOURS_END_TIME` | String | เวลาสิ้นสุดช่วงห้ามเตือนตอนกลางคืน (**รวมขอบ** `05:59:59` ไม่ส่ง) | `"05:59:59"` | เวลา (`HH:MM:SS`) | AC-26, EC-7 |
| `ACTIVE_HOURS_START_TIME` | String | เวลาแรกหลังพ้นช่วงห้ามเตือนที่ส่งข้อความได้ และใช้เป็นจุดเริ่มตัวนับหากเหตุการณ์ล่าสุดเกิดก่อนหน้านี้ (**รวมขอบ** `06:00:00` ส่งได้) | `"06:00:00"` | เวลา (`HH:MM:SS`) | AC-26, AC-27, EC-7 |
| `DAILY_NOTIFICATION_CAP` | Integer | เพดานจำนวนข้อความแจ้งเตือนสูงสุดต่อรอบวัน (ส่งครบแล้วไม่ส่งเพิ่มจนถึง `05:00:00` รอบวันถัดไป) | `6` | ข้อความ | AC-28, EC-15 |
| `MIN_NOTIFICATION_INTERVAL_MINUTES` | Integer | ระยะห่างขั้นต่ำระหว่างข้อความที่ส่งล่าสุดกับข้อความถัดไป (**รวมขอบ** `30:00` นาทีส่งได้; `29:59` นาทีถูกเลื่อน) | `30` | นาที | AC-29, AC-30, EC-5 |
| `WALK_INACTIVITY_HOURS` | Integer | ระยะเวลาที่ไม่มีก้าวใหม่ก่อนส่งข้อความ `"เดิน: ไม่ขยับ"` (ครบ `4:00:00` ชม. พอดีส่งได้) | `4` | ชั่วโมง | AC-9 |
| `WALK_MANUAL_INACTIVITY_HOURS` | Integer | ระยะเวลาที่ไม่มีบันทึกขยับเองก่อนส่งข้อความ `"เดิน: บันทึกเอง"` สำหรับผู้ใช้ตรวจก้าวไม่ได้ | `4` | ชั่วโมง | AC-15, EC-12 |
| `WALK_MAX_DELAY_MINUTES` | Integer | ระยะเวลาผ่อนผันสูงสุดที่ยอมให้ `"เดิน: ไม่ขยับ"` และ `"เดิน: ใกล้เป้า"` ส่งช้ากว่าเวลาตามเงื่อนไข | `60` | นาที | AC-9 |
| `WALK_NEAR_GOAL_MIN_PERCENT` | Float | สัดส่วนความคืบหน้าก้าวต่ำสุดที่ส่ง `"เดิน: ใกล้เป้า"` (**รวมขอบ** `80.00%` ส่ง; `79.99%` ไม่ส่ง) | `80.00` | เปอร์เซ็นต์ (%) | AC-10, AC-11 |
| `WALK_NEAR_GOAL_MAX_EXCLUSIVE_PERCENT` | Float | ขอบบนของสัดส่วนความคืบหน้าก้าวสำหรับ `"เดิน: ใกล้เป้า"` (**ไม่รวมขอบ** `100.00%`: `< 100.00%` เช่น `99.99%` ส่ง; `>= 100.00%` ไม่ส่ง) | `100.00` | เปอร์เซ็นต์ (%) | AC-12, AC-13, AC-14, EC-11 |
| `WATER_INACTIVITY_FIRST_HOURS` | Integer | ระยะเวลาที่ไม่มีบันทึกน้ำก่อนส่ง `"น้ำ: 2 ชม."` (ครบ `2:00:00` ชม. พอดีส่งได้) | `2` | ชั่วโมง | AC-16, AC-17, AC-27 |
| `WATER_INACTIVITY_SECOND_HOURS` | Integer | ระยะเวลาที่ไม่มีบันทึกน้ำก่อนส่ง `"น้ำ: 4 ชม."` (ครบ `4:00:00` ชม. พอดีส่งได้) | `4` | ชั่วโมง | AC-18 |
| `WATER_DAILY_GOAL_GLASSES` | Integer | จำนวนแก้วน้ำที่ถือว่าครบเป้าน้ำของวัน (**รวมขอบ** `>= 8` แก้ว หรือหลอดพลังงานน้ำ `100%` หยุดเรื่องน้ำทั้งรอบวัน) | `8` | แก้ว | AC-16, AC-18, AC-19, EC-4 |
| `FOOD_UNLOGGED_TIME_1` | String | เวลาตรวจส่ง `"อาหาร: ยังไม่กิน"` รอบที่ 1 เมื่อ `total_calories == 0` | `"12:00:00"` | เวลา (`HH:MM:SS`) | AC-20, AC-21 |
| `FOOD_UNLOGGED_TIME_2` | String | เวลาตรวจส่ง `"อาหาร: ยังไม่กิน"` รอบที่ 2 เมื่อ `total_calories == 0` | `"15:00:00"` | เวลา (`HH:MM:SS`) | AC-20, AC-21 |
| `FOOD_UNLOGGED_TIME_3` | String | เวลาตรวจส่ง `"อาหาร: ยังไม่กิน"` รอบที่ 3 เมื่อ `total_calories == 0` | `"18:00:00"` | เวลา (`HH:MM:SS`) | AC-20, AC-21 |
| `FOOD_NIGHT_REMINDER_TIME` | String | เวลาตรวจส่ง `"อาหาร: 21:00"` รอบค่ำเพียงครั้งเดียว (ที่เวลานี้ไม่ส่ง `"อาหาร: ยังไม่กิน"`) | `"21:00:00"` | เวลา (`HH:MM:SS`) | AC-22, AC-23, AC-24, AC-25 |

### 1.1 ตารางข้อความ เงื่อนไข และลำดับคิว

| ชื่อเรียก | เรื่อง | ข้อความคำต่อคำ (Exact String) | เงื่อนไขส่ง (Trigger) | เงื่อนไขหยุด/ยกเลิก (Cancel/Stop) |
|---|---|---|---|---|
| เดิน: ไม่ขยับ | เดิน | อย่าลืมขยับบ้างนะ อย่ามัวแต่นั่งอืด ลุกขึ้นมาเดินเร็ว!! | ไม่มีก้าวใหม่ครบ 4 ชม. (นับจากก้าวล่าสุดของรอบวัน หรือจาก 06:00:00) ส่งครั้งเดียวต่อรอบนับ · ยอมให้ส่งช้าได้ไม่เกิน 60 นาที | มีก้าวใหม่ → ยกเลิกและเริ่มนับใหม่ |
| เดิน: ใกล้เป้า | เดิน | มาขยับร่างกายกันอีกนิด ใกล้ถึงเป้าหมายแล้วสู้ๆ | `current_steps` ÷ `daily_goal` ≥ 80% และ < 100% (80.00% พอดีส่ง) · ยอมให้ส่งช้าได้ไม่เกิน 60 นาที | วันละ 1 ครั้ง · ถ้าตอนตรวจพบค่าถึง ≥ 100% แล้ว (รวมกรณีข้ามจากต่ำกว่า 80% ไป ≥ 100% ในรอบอัปเดตเดียว) → ไม่ส่ง |
| เดิน: บันทึกเอง | เดิน (ตรวจก้าวไม่ได้) | อย่าลืมขยับร่างกายน้า ถ้าขยับแล้วมาอัปเดตให้น้องอ๊บด้วย | ผู้ใช้ตรวจก้าวไม่ได้ (ปฏิเสธสิทธิ์ Activity Recognition หรือเครื่องไม่มีเซนเซอร์นับก้าว) และไม่มีบันทึกขยับเองครบ 4 ชม. (นับจากบันทึกล่าสุดของรอบวัน หรือจาก 06:00:00) ส่งครั้งเดียวต่อรอบนับ | บันทึกขยับเอง → ยกเลิกและเริ่มนับใหม่ |
| น้ำ: 2 ชม. | น้ำ | อย่าลืมดื่มน้ำน้าา ผิวกบของน้องขาดความชุ่มชื้น น้องอ๊บไม่ชอบ | ไม่มีบันทึกน้ำครบ 2 ชม. (นับจาก `last_logged_timestamp` ของรอบวัน หรือจาก 06:00:00) และ `daily_water_count` < 8 · ส่งครั้งเดียวต่อรอบนับ | บันทึกน้ำ → ยกเลิกและเริ่มนับใหม่ · `daily_water_count` ≥ 8 → หยุดเรื่องน้ำทั้งรอบวัน |
| น้ำ: 4 ชม. | น้ำ | โปรดดื่มน้ำเถอะคนนี้ น้องอ๊บคอแห้งไม่ไหวแล้วววว ดื่มน้ำๆๆ | ไม่มีบันทึกน้ำครบ **4** ชม. (นับจาก `last_logged_timestamp` ของรอบวัน หรือจาก 06:00:00) และ `daily_water_count` < 8 · ส่งครั้งเดียวต่อรอบนับ | บันทึกน้ำ → ยกเลิกและเริ่มนับใหม่ · `daily_water_count` ≥ 8 → หยุดเรื่องน้ำทั้งรอบวัน |
| อาหาร: ยังไม่กิน | อาหาร | กินข้าวยัง อย่าลืมพักกินข้าวบ้างนะค้าบ แล้วอย่าลืมมาให้อาหารน้องอ๊บด้วย | เวลา 12:00:00, 15:00:00, 18:00:00 ถ้า `total_calories` ของรอบวัน = 0 | `total_calories` > 0 → ยกเลิกรอบที่เหลือของวัน |
| อาหาร: 21:00 | อาหาร | น้องอ๊บหิวแล้วน้า ถ้าทานแล้วมาบอกน้องอ๊บด้วยนะ | เวลา 21:00:00 ส่งครั้งเดียว · ผู้ใช้ที่มีเป้าแคลอรี่: `total_calories` < เป้า · ผู้ใช้ที่ไม่มีเป้าแคลอรี่: `total_calories` = 0 | `total_calories` ≥ เป้า → ไม่ส่ง · ไม่มีเป้าและ `total_calories` > 0 → ไม่ส่ง |

**นิยามและกติกากลางของการจัดคิว:**
- **ลำดับความสำคัญ (Priority Order):** `อาหาร > น้ำ > เดิน` เมื่อหลายข้อความเข้าเงื่อนไขพร้อมกัน หรือชนเพดาน/ระยะห่าง (AC-31, EC-5)
- **ระยะห่างขั้นต่ำ (Cooldown):** ข้อความถัดไปส่งได้เมื่อห่างจาก `last_notification_timestamp` ≥ `30:00` นาที (`29:59` นาทีถูกเลื่อน) (AC-29, AC-30)
- **การส่งข้อความที่ถูกเลื่อนและการตัดทิ้งตอน 23:00:00:** ข้อความที่ถูกเลื่อนเพราะระยะห่างหรือลำดับ จะส่งทีหลังได้ถ้ายังเข้าเงื่อนไขอยู่ ไม่อยู่ในช่วงห้ามเตือน และยังไม่ชนเพดาน 6 ข้อความ แต่หากถึงเวลา `23:00:00` แล้วยังไม่ได้ส่ง ให้ยกเลิกทิ้งทันที (AC-32, AC-33)
- **ตัวนับเวลาหลังช่วงห้ามเตือน:** ตัวนับของ `"เดิน: ไม่ขยับ"`, `"เดิน: บันทึกเอง"`, `"น้ำ: 2 ชม."` และ `"น้ำ: 4 ชม."` เริ่มจาก**ค่าที่มาทีหลังระหว่าง** (เวลาที่เกิดเหตุการณ์ล่าสุดของรอบวันนั้น) กับ `06:00:00` โดยข้อความที่ครบกำหนดในช่วงห้ามเตือน (`23:00:00`–`05:59:59`) ไม่ส่งของคืนนั้น (AC-26, AC-27, EC-7)
- **การยกเลิกอัตโนมัติเมื่อผู้ใช้ทำกิจกรรมแล้ว:** หากผู้ใช้บันทึกน้ำ บันทึกอาหาร มีก้าวใหม่ หรือบันทึกขยับเอง ระหว่างที่ข้อความของเรื่องนั้นรอส่ง ให้ยกเลิกข้อความที่รอส่งของเรื่องนั้นทันที (AC-34, EC-6)
- **เงื่อนไขเพิ่มเติมตามหมวด:** ถึง `100%` ของเป้าก้าวแล้ว `"เดิน: ไม่ขยับ"` ยังทำงานตามปกติ (ไม่หยุด); ผู้ใช้ตรวจก้าวไม่ได้จะไม่ได้รับ `"เดิน: ไม่ขยับ"` และ `"เดิน: ใกล้เป้า"` แต่ได้รับ `"เดิน: บันทึกเอง"` แทน (และผู้ที่ตรวจก้าวได้จะไม่ได้รับ `"เดิน: บันทึกเอง"`); ที่ `21:00:00` ส่งเฉพาะ `"อาหาร: 21:00"` ไม่ส่ง `"อาหาร: ยังไม่กิน"`

### 1.2 ตารางสถานะและข้อมูลที่เก็บในระบบ (System State & Storage Schema)

#### ข้อมูลที่ฟีเจอร์แจ้งเตือนเก็บเองใน Local Storage
| ชื่อฟิลด์ (Storage Key) | ชนิดข้อมูล | ค่า CODE_ENUM (ป้ายไทย) / ขอบเขตค่า | ค่าเริ่มต้น | ความหมายและกติกาอัปเดต |
|---|---|---|---|---|
| `consent_status` | String | `ALLOWED (อนุญาต)`, `DENIED (ไม่อนุญาต)`, `UNANSWERED (ยังไม่ตอบ)` | `UNANSWERED (ยังไม่ตอบ)` | สถานะความยินยอมบนการ์ด S-1 (เปลี่ยนครั้งเดียวเมื่อผู้ใช้กดปุ่มบน S-1 ตาม AC-1 ถึง AC-4) |
| `notification_master_switch` | String | `ON (เปิด)`, `OFF (ปิด)` | `OFF (ปิด)` ก่อนตอบการ์ด; หลังตอบการ์ดตั้งค่าเริ่มต้นตรงกับคำตอบบน S-1 (`ALLOWED` → `ON (เปิด)`, `DENIED` → `OFF (ปิด)`) | สถานะสวิตช์เปิด/ปิดแจ้งเตือนทั้งหมดในหน้าตั้งค่า S-2 (AC-5, AC-6, AC-7; หาก `system_permission_status == DENIED (ปฏิเสธ)` ให้ถือเป็นปิดตาม AC-8) |
| `system_permission_status` | String | `GRANTED (อนุญาต)`, `DENIED (ปฏิเสธ)`, `NOT_DETERMINED (ยังไม่เคยขอ)` | `NOT_DETERMINED (ยังไม่เคยขอ)` | สถานะสิทธิ์แจ้งเตือนของระบบปฏิบัติการ (AC-2, AC-6, AC-8, EC-9, EC-10) |
| `sent_notification_count` | Integer | `0` ถึง `6` | `0` | จำนวนข้อความที่ส่งแล้วในรอบวัน รีเซ็ตกลับเป็น `0` เมื่อถึงเวลา `05:00:00` (AC-28, AC-35) |
| `last_notification_timestamp` | String (ISO DateTime / Nullable) | วันและเวลาที่ส่งข้อความล่าสุด หรือ `NULL` | `NULL` | ใช้คำนวณระยะห่างขั้นต่ำ 30 นาทีระหว่างข้อความ (AC-29, AC-30) |
| `walk_near_goal_sent_today` | Boolean / String | `YES (ใช่)` (`true`), `NO (ไม่)` (`false`) | `NO (ไม่)` (`false`) | สถานะว่าส่ง `"เดิน: ใกล้เป้า"` ในรอบวันปัจจุบันไปแล้วหรือยัง รีเซ็ตเป็น `NO (ไม่)` เมื่อถึง `05:00:00` (AC-11, AC-35) |
| `last_manual_move_timestamp` | String (ISO DateTime / Nullable) | วันและเวลาที่กดบันทึกขยับเองล่าสุด หรือ `NULL` | `NULL` | ใช้เริ่มตัวนับ 4 ชม. ของ `"เดิน: บันทึกเอง"` โดยเริ่มจากค่าที่มาทีหลังระหว่างเวลานี้ของรอบวันกับ `06:00:00` (AC-15, EC-12) |
| `last_steps_increased_timestamp` | String (ISO DateTime / Nullable) | วันและเวลาที่ `current_steps` เพิ่มขึ้นล่าสุด หรือ `NULL` | `NULL` | ใช้เริ่มตัวนับ 4 ชม. ของ `"เดิน: ไม่ขยับ"` โดยเริ่มจากค่าที่มาทีหลังระหว่างเวลานี้ของรอบวันกับ `06:00:00` (AC-9) |

#### ข้อมูลที่อ่านอย่างเดียว (Read-only) จากฟีเจอร์อื่น (ไม่สร้างค่าเป้าซ้ำ)
- **ฟีเจอร์เดิน (`docs/steps/`):** `current_steps` (`Integer`, ก้าว), `daily_goal` (`Integer`, ก้าว), สถานะสิทธิ์ Activity Recognition และการมีเซนเซอร์นับก้าว, การกดปุ่มบันทึกการขยับเอง
- **ฟีเจอร์น้ำ (`docs/water/`):** `daily_water_count` (`Integer`, แก้ว), `last_logged_timestamp` (`String` DateTime เวลาบันทึกน้ำล่าสุด)
- **ฟีเจอร์อาหาร (`docs/food/`):** `total_calories` (`Integer`, kcal ยอดรวมของรอบวัน), เป้าแคลอรี่รายวันจากโปรไฟล์ (`Integer`, kcal หรือไม่มีเป้ากรณีผู้ใช้ข้ามโปรไฟล์สุขภาพ)

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง

การส่งแจ้งเตือนและการเมินแจ้งเตือน**ไม่เปลี่ยนอารมณ์หรือค่าใด ๆ ของน้องอ๊บ** ฟีเจอร์นี้จึงไม่มีกติกาเพิ่ม/ลดค่าความสุขของสัตว์เลี้ยง และใช้เฉพาะภาพโปรไฟล์กบคงที่ 1 ภาพสำหรับการ์ดขอความยินยอมและการแจ้งเตือนบน Android เท่านั้น

| สถานะ (Code Enum) | ช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพ |
|---|---|---|
| `NOTIFICATION_PROFILE (ภาพโปรไฟล์แจ้งเตือนคงที่)` | ไม่มีช่วงค่าตัวเลข (แจ้งเตือนไม่เปลี่ยนอารมณ์หรือค่าใด ๆ ของน้องอ๊บ) | `assets/images/pet_profile_frog.png` |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| ไม่มีก้าวใหม่ครบ 4 ชม. (ผู้ใช้ตรวจก้าวได้) | ก้าวล่าสุดเพิ่มเวลา `08:00:00`, เวลาจำลองถึง `12:00:00` | ส่งข้อความ `"เดิน: ไม่ขยับ"` (ยอมให้ช้าสุดไม่เกิน `13:00:00`) | อ้าง AC-9 |
| อัปเดตก้าวที่สัดส่วน `79.99%` (ต่ำกว่าขอบล่าง) | `current_steps = 7999`, `daily_goal = 10000` (`7999 ÷ 10000 = 79.99%`) | ไม่ส่งข้อความ `"เดิน: ใกล้เป้า"` | อ้าง AC-10 |
| อัปเดตก้าวที่สัดส่วน `80.00%` พอดี (ขอบล่างรวมขอบ) | `current_steps = 8000`, `daily_goal = 10000` (`80.00%`), `walk_near_goal_sent_today = NO (ไม่)` | ส่งข้อความ `"เดิน: ใกล้เป้า"`, ตั้ง `walk_near_goal_sent_today = YES (ใช่)` | อ้าง AC-11 |
| อัปเดตก้าวที่สัดส่วน `99.99%` (ก่อนถึงขอบบน) | `current_steps = 9999`, `daily_goal = 10000` (`99.99%`), `walk_near_goal_sent_today = NO (ไม่)` | ส่งข้อความ `"เดิน: ใกล้เป้า"`, ตั้ง `walk_near_goal_sent_today = YES (ใช่)` | อ้าง AC-12 |
| อัปเดตก้าวที่สัดส่วน `100.00%` พอดี (ขอบบนไม่รวมขอบ) | `current_steps = 10000`, `daily_goal = 10000` (`100.00%`) | ไม่ส่งข้อความ `"เดิน: ใกล้เป้า"` | อ้าง AC-13 |
| ก้าวกระโดดข้ามจากต่ำกว่า `80%` ไป `>= 100%` ในรอบเดียว | `current_steps` เปลี่ยนจาก `7000` (`70.00%`) → `10000` (`100.00%`), `daily_goal = 10000` | ไม่ส่งข้อความ `"เดิน: ใกล้เป้า"` | อ้าง AC-14, EC-11 |
| ผู้ใช้ตรวจก้าวไม่ได้และไม่บันทึกขยับเองครบ 4 ชม. | `last_manual_move_timestamp = 09:00:00`, เวลาจำลองถึง `13:00:00` | ส่งข้อความ `"เดิน: บันทึกเอง"` | อ้าง AC-15, EC-12 |
| ไม่บันทึกน้ำครบ 2 ชม. และยังไม่บันทึกต่อจนครบ 4 ชม. | `last_logged_timestamp = 08:00:00`, `daily_water_count = 3` (`< 8`) | เวลา `10:00:00` ส่ง `"น้ำ: 2 ชม."` 1 ครั้ง (ไม่ส่งซ้ำในรอบนับเดิม) และเวลา `12:00:00` ส่ง `"น้ำ: 4 ชม."` | อ้าง AC-16, AC-17, AC-18 |
| บันทึกน้ำจนถึงเป้าน้ำ 8 แก้ว | `daily_water_count` เพิ่มจาก `7` → `8` แก้ว (หลอดน้ำ `100%`) | ยกเลิกและหยุดข้อความเรื่องน้ำทั้งรอบวันทันที | อ้าง AC-19 |
| ยังไม่บันทึกอาหารที่เวลา `12:00:00` แล้วมาบันทึกตอน `12:30:00` | เวลา `12:00:00` มี `total_calories = 0` → ต่อมา `12:30:00` บันทึก `500 kcal` (`> 0`) | เวลา `12:00:00` ส่ง `"อาหาร: ยังไม่กิน"` ส่วนรอบ `15:00:00` และ `18:00:00` ถูกยกเลิกทั้งหมด | อ้าง AC-20, AC-21 |
| ถึงเวลา `21:00:00` สำหรับผู้ใช้ที่มีเป้าแคลอรี่ `2000 kcal` | กรณี ก: `total_calories = 1500` (`< 2000`) / กรณี ข: `total_calories = 2000` (`>= 2000`) | กรณี ก: ส่ง `"อาหาร: 21:00"` / กรณี ข: ไม่ส่ง `"อาหาร: 21:00"` | อ้าง AC-22, AC-24 |
| ถึงเวลา `21:00:00` สำหรับผู้ใช้ที่ไม่มีเป้าแคลอรี่ (ข้ามโปรไฟล์) | กรณี ก: `total_calories = 0` / กรณี ข: `total_calories = 350` (`> 0`) | กรณี ก: ส่ง `"อาหาร: 21:00"` / กรณี ข: ไม่ส่ง `"อาหาร: 21:00"` | อ้าง AC-23, AC-25 |
| ตัวนับหลังข้ามช่วงห้ามเตือน (ดื่มน้ำก่อนเข้านอน) | บันทึกน้ำล่าสุดเวลา `22:30:00`, ข้ามช่วงห้ามเตือน `23:00:00`–`05:59:59` | ตัวนับ `"น้ำ: 2 ชม."` เริ่มนับที่ `06:00:00` ของวันถัดไป และส่งได้ที่เวลา `08:00:00` | อ้าง AC-27, EC-7 |
| ตรวจสอบระยะห่าง `29:59` นาที เทียบกับ `30:00` นาทีพอดี | ส่งข้อความล่าสุดเมื่อ `12:00:00`, ข้อความถัดไปเข้าเงื่อนไข | ที่ `12:29:59` (ห่าง `29:59`) ข้อความถูกเลื่อน; ที่ `12:30:00` (ห่าง `30:00` พอดี) ส่งข้อความได้ | อ้าง AC-29, AC-30 |
| รีเซ็ตรอบวันเมื่อถึงเวลา `05:00:00` | เวลา `04:59:59` มี `sent_notification_count = 6`, `walk_near_goal_sent_today = YES (ใช่)` | เวลา `05:00:00` รีเซ็ต `sent_notification_count = 0` และ `walk_near_goal_sent_today = NO (ไม่)` | อ้าง AC-35, EC-8 |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ที่ทดสอบได้ |
|---|---|
| กดสวิตช์เปิด/ปิดแจ้งเตือนรัว ๆ (EC-1) | ใช้สถานะสุดท้ายที่กดเป็นตัวตัดสิน ข้อความที่ตั้งไว้ในระบบตรงกับสถานะสุดท้ายเท่านั้น |
| กดแจ้งเตือนอันเดียวกันซ้ำหลายครั้งติดกัน (EC-2) | เปิดแอปไปยังหน้าของเรื่องนั้นเพียงหน้าเดียว ไม่เปิดหน้าซ้อนทับกัน |
| ค่าที่อ่านจากฟีเจอร์อื่นติดลบ (`current_steps < 0`, `daily_water_count < 0`, `total_calories < 0`) หรือ `daily_goal == 0` (EC-3) | ไม่ส่งข้อความของเรื่องนั้นในรอบวันนั้น |
| `daily_water_count` เกิน 8 แก้ว เช่น 12 แก้ว (EC-4) | ถือว่าครบเป้าน้ำ (`>= 8`) ไม่ส่งข้อความเรื่องน้ำในรอบวันนั้น |
| หลายข้อความครบกำหนดพร้อมกัน (EC-5) | จัดลำดับส่งตามความสำคัญ `อาหาร > น้ำ > เดิน` โดยเว้นระยะห่างระหว่างข้อความอย่างน้อย `30:00` นาที (AC-30, AC-31) |
| บันทึกน้ำ / บันทึกอาหาร / มีก้าวใหม่ / บันทึกขยับเอง ขณะข้อความเรื่องนั้นรอส่ง (EC-6) | ยกเลิกข้อความที่รอส่งของเรื่องนั้นทันที (AC-34) |
| ครบกำหนดในช่วงห้ามเตือน `23:00:00` ถึง `05:59:59` หรือข้อความที่ถูกเลื่อนค้างถึง `23:00:00` (EC-7) | ขอบ `22:59:59` ส่งได้, ขอบ `23:00:00` ถึง `05:59:59` ไม่ส่งข้อความใดเลย ข้อความที่ถูกเลื่อนค้างถึง `23:00:00` ถูกยกเลิกทิ้ง และตัวนับเริ่มใหม่จาก `06:00:00` (ขอบ `06:00:00` ส่งได้) (AC-26, AC-27, AC-33) |
| ข้ามเวลารีเซ็ตรอบวัน `05:00:00` (EC-8) | รีเซ็ต `sent_notification_count = 0` และรีเซ็ต `walk_near_goal_sent_today = NO (ไม่)` ทันที (AC-35) |
| กด `ไม่อนุญาต` บนการ์ด S-1 แล้วมาเปิดสวิตช์ในหน้าตั้งค่า S-2 ทีหลัง (EC-9) | แอปเรียกกล่องขอสิทธิ์แจ้งเตือนของระบบขึ้นมา (เป็นการขอสิทธิ์ระบบครั้งแรกของผู้ที่เคยกดไม่อนุญาตบนการ์ด) (AC-6) |
| ระบบปฏิเสธสิทธิ์แจ้งเตือน (`system_permission_status == DENIED (ปฏิเสธ)`) (EC-10) | ถือเป็นปิด ไม่ส่งข้อความใด และหน้าตั้งค่า S-2 แสดงข้อความ `"สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน"` (AC-8) |
| ก้าวข้ามทั้ง `80%` และ `100%` ในรอบอัปเดตเดียว เช่น `70.00%` ไป `100.00%` (EC-11) | ไม่ส่งข้อความ `"เดิน: ใกล้เป้า"` (AC-14) |
| ผู้ใช้ตรวจก้าวไม่ได้ (ปฏิเสธสิทธิ์ Activity Recognition หรือเครื่องไม่มีเซนเซอร์นับก้าว) (EC-12) | ไม่ส่ง `"เดิน: ไม่ขยับ"` และ `"เดิน: ใกล้เป้า"` แต่ใช้ตัวนับ 4 ชม. ส่ง `"เดิน: บันทึกเอง"` แทน (AC-15) |
| กดเปิดแอปจากแจ้งเตือนตอนแอปปิดสนิท (`TERMINATED`) (EC-13) | เปิดแอปและนำทางไปยังหน้าฟีเจอร์ของเรื่องนั้นทันที (เดิน → หน้าเดิน, น้ำ → หน้าน้ำ, อาหาร → หน้าอาหาร) (AC-38, AC-39, AC-40) |
| ไม่เปิดแอปเลยข้ามรอบวัน `05:00:00` (EC-14) | ไม่มีข้อความของรอบวันใหม่ถูกส่งจนกว่าผู้ใช้จะเปิดแอป เมื่อเปิดแอปแล้ว ระบบจึงตั้งเวลาข้อความของรอบวันปัจจุบันใหม่ตามกติกาทั้งหมด |
| ส่งครบเพดาน 6 ข้อความก่อนเวลา `21:00:00` (EC-15) | เมื่อ `sent_notification_count == 6` ระบบหยุดส่งข้อความเพิ่มจนถึง `05:00:00` ของรอบวันถัดไป และยกเลิกข้อความที่เข้าเงื่อนไขระหว่างนั้นทั้งหมด (AC-28) |

## 5. คำถามถึง Product

1. (ถาม Design) ชื่อไฟล์ภาพโปรไฟล์กบสำหรับแจ้งเตือน Android
   - *ข้อเสนอแนะจาก Design:* กำหนดชื่อไฟล์ภาพมาตรฐานเป็น `assets/images/pet_profile_frog.png` สำหรับรูปกบขยิบตาทำปากจู๋ เพื่อให้ใช้ร่วมกันได้ทั้งในการ์ดขอความยินยอม (S-1) และการแจ้งเตือนแบบแชตบน Android (S-3)
   - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ให้ Dev อ้างอิง Path `assets/images/pet_profile_frog.png` ในโค้ดแสดงผล S-1 และ Android Notification Builder ได้ทันที
   - *การประเมินสถานะการบล็อก:* `Blocking: ไม่ใช่` (เพราะกำหนดชื่อไฟล์และตำแหน่ง Asset ชัดเจนตรงกันทุกตารางใน `ux-flow.md` และ `game-rules.md` แล้ว)

2. (ถาม Design) ข้อความในหน้าตั้งค่าเมื่อระบบปฏิเสธสิทธิ์แจ้งเตือน
   - *ข้อเสนอแนะจาก Design:* แสดงข้อความแจ้งสาเหตุและวิธีแก้ไขอย่างกระชับเป็นมิตรบริเวณใต้สวิตช์ในหน้าตั้งค่า (S-2) เมื่อตรวจพบว่าสิทธิ์แจ้งเตือนของระบบถูกปฏิเสธหรือถูกปิดจากเครื่อง
   - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ให้ Dev แสดงข้อความ Exact String ว่า `"สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน"` ในสถานะ `PERMISSION_DENIED` ของหน้า S-2 ได้ทันที
   - *การประเมินสถานะการบล็อก:* `Blocking: ไม่ใช่` (เพราะกำหนดข้อความ Exact String และเงื่อนไขการแสดงผลตรงกับ `ux-flow.md` 100% แล้ว)

=== จบ docs/notification-feature/game-rules.md ===

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

This is the expected criteria for your final answer: เนื้อหาไฟล์ docs/notification-feature/design-review.md ฉบับสมบูรณ์ ตามโครง template
you MUST return the actual complete content as the final answer, not a summary.

Provide your complete response:
~~~~

### LLM call 1 — คำตอบ

~~~~text
# Design Review: notification-feature

## 1. ข้อมูลการตรวจ
- Status: NEEDS_FIX
- Feature: notification-feature
- Documents actually reviewed: docs/notification-feature/requirements.md, docs/notification-feature/ux-flow.md, docs/notification-feature/game-rules.md
- Missing/unreadable documents: ไม่มี
- Previous findings checked: ไม่มีข้อมูลรอบก่อน (ไม่มีรายงานรีวิวก่อนหน้า)

## 2. ผล Checklist
ทุกข้อมีผล เหตุผล และหลักฐานจากไฟล์/หัวข้อที่ตรวจจริง หากข้อมูลไม่พอให้ใช้ INSUFFICIENT_EVIDENCE ห้ามเดา

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | FAIL | requirements.md หัวข้อ 7 ระบุ Open Questions ที่ยังไม่มีข้อสรุปชัดเจนจาก Product 2 ข้อ ซึ่งส่งผลต่อการนำไปพัฒนาในส่วนการเรียกใช้ asset และการแสดงผลข้อความสถานะระบบ | ใช่ — ต้องให้ Product เจ้าของฟีเจอร์สรุปคำตอบของ Open Questions ทั้ง 2 ข้อให้ชัดเจนก่อนส่ง Dev |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | PASS | requirements.md, ux-flow.md และ game-rules.md มีตารางเงื่อนไข Acceptance Criteria, ตารางข้อความแจ้งเตือนคำต่อคำ และโครงสร้าง Local Storage สอดคล้องตรงกันทุกประการ | ไม่ใช่ — เอกสารทั้ง 3 ฉบับอ้างอิงและสอดคล้องกันเป็นเนื้อเดียวกัน |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | PASS | requirements.md หัวข้อ 3, ux-flow.md หัวข้อ 2 และ game-rules.md หัวข้อ 1/3 กำหนดค่าตัวเลข (เช่น เปอร์เซ็นต์ 80.00%, เพดาน 6 ข้อความ, เวลา 23:00, 05:00, 06:00, 21:00) และเงื่อนไขตรงกันทุกตาราง | ไม่ใช่ — ชื่อสถานะ ตัวเลข และเวลาตรงกันทุกประการ |
| C-04 | ขั้นตอนใช้งานและEdge Cases เพียงพอ | PASS | ux-flow.md หัวข้อ 3 (Happy path / Deep linking) และ game-rules.md หัวข้อ 4 (Edge cases) ครอบคลุมสถานการณ์ขอบเขต เช่น การกดรัว, ค่าติดลบ, ข้ามขอบเวลาห้ามเตือน, ข้ามรอบวัน และการปฏิเสธสิทธิ์ | ไม่ใช่ — ขั้นตอนการใช้งานและ Edge cases ครอบคลุมครบถ้วน |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | FAIL | requirements.md หัวข้อ 7 ยังมี Open Questions ค้างอยู่ 2 ข้อ (ชื่อไฟล์ภาพโปรไฟล์กบ และข้อความตั้งค่าเมื่อสิทธิ์ถูกปิด) ซึ่งแม้ใน ux-flow.md จะมี Fallback Rule แต่ใน requirements.md ยังระบุสถานะเป็นคำถามที่เปิดอยู่โดยไม่มีการปิดประเด็นอย่างเป็นทางการ | ใช่ — ต้องให้ Product ยืนยันปิด Open Questions ในเอกสาร Requirements ให้สมบูรณ์ |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ทุกข้อสังเกตและปัญหาอ้างอิงเส้นทางไฟล์ หัวข้อ และตารางในเอกสารทั้ง 3 ฉบับได้อย่างแม่นยำ | ไม่ใช่ — ทุกประเด็นมีหลักฐานอ้างอิงชัดเจน |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | บทสรุปสถานะ NEEDS_FIX สอดคล้องกับตารางปัญหา Open Questions และคำแนะนำในการแก้ไข | ไม่ใช่ — ข้อมูลสอดคล้องกันทุกส่วน |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีรายงานการรีวิวก่อนหน้าสำหรับการเปรียบเทียบ (ไม่สามารถทำ Regression comparison ได้) | ไม่ใช่ — ไม่มีข้อมูลรอบก่อนให้ตรวจสอบ |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|
| Q-01 | requirements.md | หัวข้อ 7. คำถามที่ยังเปิดอยู่ (ข้อ 1) | ข้อ 1: "(ถาม Design) ชื่อไฟล์ภาพโปรไฟล์กบสำหรับแจ้งเตือน Android" ปรากฏเป็นคำถามค้างอยู่ใน Requirements แม้ใน UX Flow และ Game Rules จะกำหนด Fallback เป็น `assets/images/pet_profile_frog.png` แล้วก็ตาม | ทำให้เอกสาร Requirements ยังไม่ถือเป็น Baseline ที่สมบูรณ์และยังรอการยืนยันอย่างเป็นทางการจาก Product/Design | ยังตัดสินไม่ได้ | ให้ Product/Design อัปเดต Requirements หัวข้อ 7 ให้ระบุชื่อไฟล์ `assets/images/pet_profile_frog.png` เป็นข้อสรุปถาวร | ใช่ — ต้องอัปเดต requirements.md ให้ปิดคำถามข้อ 1 |
| Q-02 | requirements.md | หัวข้อ 7. คำถามที่ยังเปิดอยู่ (ข้อ 2) | ข้อ 2: "(ถาม Design) ข้อความในหน้าตั้งค่าเมื่อระบบปฏิเสธสิทธิ์แจ้งเตือน" ค้างอยู่ใน Requirements โดยยังไม่มีการทำเครื่องหมายว่าปิดประเด็น แม้ UX Flow และ Game Rules จะกำหนด Exact String ไว้แล้ว | ทำให้ข้อกำหนดใน requirements.md ไม่สอดคล้องกับสถานะการตัดสินใจในภาพรวมของเอกสารชุดเดียวกัน | ยังตัดสินไม่ได้ | ให้ Product/Design อัปเดต requirements.md ให้ระบุ Exact String `"สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน"` เป็นข้อยืนยันถาวร | ใช่ — ต้องอัปเดต requirements.md ให้ปิดคำถามข้อ 2 |

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|
| - | ไม่มีข้อมูลรอบก่อน | ไม่มีข้อมูลสำหรับเปรียบเทียบ | ไม่มีเอกสารรายงานรีวิวก่อนหน้า | ไม่ต้องดำเนินการ (ไม่มีประวัติ) |

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- Q-01: `requirements.md` หัวข้อ 7 (ข้อ 1) — ยังไม่มีการทำเครื่องหมายสรุปผลอย่างเป็นทางการในไฟล์ Requirements สำหรับชื่อไฟล์ภาพโปรไฟล์กบ Android (`assets/images/pet_profile_frog.png`), มีผลกระทบทำให้ Requirements ไม่สมบูรณ์, การประเมินการบล็อก: ยังตัดสินไม่ได้ (เนื่องจากมี Fallback ใน UX Flow แล้วแต่ตัวเอกสาร Requirements ยังเปิดคำถามทิ้งไว้), ต้องให้ Product/Design อัปเดต requirements.md ให้เรียบร้อย
- Q-02: `requirements.md` หัวข้อ 7 (ข้อ 2) — ยังไม่มีการทำเครื่องหมายสรุปผลอย่างเป็นทางการในไฟล์ Requirements สำหรับข้อความหน้าตั้งค่าเมื่อระบบปฏิเสธสิทธิ์แจ้งเตือน, มีผลกระทบทำให้ Requirements ไม่สมบูรณ์, การประเมินการบล็อก: ยังตัดสินไม่ได้ (เนื่องจากมี Exact String ใน UX Flow/Game Rules แล้วแต่ Requirements ยังแขวนคำถามไว้), ต้องให้ Product/Design อัปเดต requirements.md ให้เรียบร้อย

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|
| - | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มี | ไม่ต้องดำเนินการ |

## 7. ข้อจำกัดของการรีวิว
- เอกสารที่ตรวจจริง: `docs/notification-feature/requirements.md`, `docs/notification-feature/ux-flow.md`, `docs/notification-feature/game-rules.md`
- เอกสารที่ไม่ได้ตรวจ: ไม่มี
- ข้อจำกัด: ไม่พบรายงานการตรวจรอบก่อนหน้า ทำให้ไม่สามารถตรวจสอบการแก้ไขย้อนหลัง (Regression) ได้ และพบว่าไฟล์ Requirements ยังมี Open Questions ค้างอยู่แม้เอกสารอื่นจะมี Fallback Rule รองรับแล้ว

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: NEEDS_FIX
- Agent recommendation: ต้องแก้
- Blocking issues remaining: Q-01, Q-02 (Open Questions ใน requirements.md ยังไม่ถูกปิดอย่างเป็นทางการ)
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: แม้ว่าเอกสาร UX Flow และ Game Rules จะมีความสอดคล้อง กำหนดค่า ตัวเลข และ Edge Cases ได้อย่างสมบูรณ์แบบและมี Fallback Rule รองรับแล้ว แต่เอกสาร `requirements.md` ในหัวข้อ 7 ยังคงมี Open Questions 2 ข้อค้างอยู่โดยไม่มีการทำเครื่องหมายสรุปผลอย่างเป็นทางการ ส่งผลให้สถานะความพร้อมของ requirements.md ยังไม่สมบูรณ์และต้องให้ Product ทำการเคลียร์ประเด็นดังกล่าวให้เรียบร้อยก่อนส่งมอบให้ทีม Dev พัฒนาต่อไป
~~~~

### ผลลัพธ์ → docs/notification-feature/design-review.md

~~~~text
# Design Review: notification-feature

## 1. ข้อมูลการตรวจ
- Status: NEEDS_FIX
- Feature: notification-feature
- Documents actually reviewed: docs/notification-feature/requirements.md, docs/notification-feature/ux-flow.md, docs/notification-feature/game-rules.md
- Missing/unreadable documents: ไม่มี
- Previous findings checked: ไม่มีข้อมูลรอบก่อน (ไม่มีรายงานรีวิวก่อนหน้า)

## 2. ผล Checklist
ทุกข้อมีผล เหตุผล และหลักฐานจากไฟล์/หัวข้อที่ตรวจจริง หากข้อมูลไม่พอให้ใช้ INSUFFICIENT_EVIDENCE ห้ามเดา

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | FAIL | requirements.md หัวข้อ 7 ระบุ Open Questions ที่ยังไม่มีข้อสรุปชัดเจนจาก Product 2 ข้อ ซึ่งส่งผลต่อการนำไปพัฒนาในส่วนการเรียกใช้ asset และการแสดงผลข้อความสถานะระบบ | ใช่ — ต้องให้ Product เจ้าของฟีเจอร์สรุปคำตอบของ Open Questions ทั้ง 2 ข้อให้ชัดเจนก่อนส่ง Dev |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | PASS | requirements.md, ux-flow.md และ game-rules.md มีตารางเงื่อนไข Acceptance Criteria, ตารางข้อความแจ้งเตือนคำต่อคำ และโครงสร้าง Local Storage สอดคล้องตรงกันทุกประการ | ไม่ใช่ — เอกสารทั้ง 3 ฉบับอ้างอิงและสอดคล้องกันเป็นเนื้อเดียวกัน |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | PASS | requirements.md หัวข้อ 3, ux-flow.md หัวข้อ 2 และ game-rules.md หัวข้อ 1/3 กำหนดค่าตัวเลข (เช่น เปอร์เซ็นต์ 80.00%, เพดาน 6 ข้อความ, เวลา 23:00, 05:00, 06:00, 21:00) และเงื่อนไขตรงกันทุกตาราง | ไม่ใช่ — ชื่อสถานะ ตัวเลข และเวลาตรงกันทุกประการ |
| C-04 | ขั้นตอนใช้งานและEdge Cases เพียงพอ | PASS | ux-flow.md หัวข้อ 3 (Happy path / Deep linking) และ game-rules.md หัวข้อ 4 (Edge cases) ครอบคลุมสถานการณ์ขอบเขต เช่น การกดรัว, ค่าติดลบ, ข้ามขอบเวลาห้ามเตือน, ข้ามรอบวัน และการปฏิเสธสิทธิ์ | ไม่ใช่ — ขั้นตอนการใช้งานและ Edge cases ครอบคลุมครบถ้วน |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | FAIL | requirements.md หัวข้อ 7 ยังมี Open Questions ค้างอยู่ 2 ข้อ (ชื่อไฟล์ภาพโปรไฟล์กบ และข้อความตั้งค่าเมื่อสิทธิ์ถูกปิด) ซึ่งแม้ใน ux-flow.md จะมี Fallback Rule แต่ใน requirements.md ยังระบุสถานะเป็นคำถามที่เปิดอยู่โดยไม่มีการปิดประเด็นอย่างเป็นทางการ | ใช่ — ต้องให้ Product ยืนยันปิด Open Questions ในเอกสาร Requirements ให้สมบูรณ์ |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ทุกข้อสังเกตและปัญหาอ้างอิงเส้นทางไฟล์ หัวข้อ และตารางในเอกสารทั้ง 3 ฉบับได้อย่างแม่นยำ | ไม่ใช่ — ทุกประเด็นมีหลักฐานอ้างอิงชัดเจน |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | บทสรุปสถานะ NEEDS_FIX สอดคล้องกับตารางปัญหา Open Questions และคำแนะนำในการแก้ไข | ไม่ใช่ — ข้อมูลสอดคล้องกันทุกส่วน |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีรายงานการรีวิวก่อนหน้าสำหรับการเปรียบเทียบ (ไม่สามารถทำ Regression comparison ได้) | ไม่ใช่ — ไม่มีข้อมูลรอบก่อนให้ตรวจสอบ |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|
| Q-01 | requirements.md | หัวข้อ 7. คำถามที่ยังเปิดอยู่ (ข้อ 1) | ข้อ 1: "(ถาม Design) ชื่อไฟล์ภาพโปรไฟล์กบสำหรับแจ้งเตือน Android" ปรากฏเป็นคำถามค้างอยู่ใน Requirements แม้ใน UX Flow และ Game Rules จะกำหนด Fallback เป็น `assets/images/pet_profile_frog.png` แล้วก็ตาม | ทำให้เอกสาร Requirements ยังไม่ถือเป็น Baseline ที่สมบูรณ์และยังรอการยืนยันอย่างเป็นทางการจาก Product/Design | ยังตัดสินไม่ได้ | ให้ Product/Design อัปเดต Requirements หัวข้อ 7 ให้ระบุชื่อไฟล์ `assets/images/pet_profile_frog.png` เป็นข้อสรุปถาวร | ใช่ — ต้องอัปเดต requirements.md ให้ปิดคำถามข้อ 1 |
| Q-02 | requirements.md | หัวข้อ 7. คำถามที่ยังเปิดอยู่ (ข้อ 2) | ข้อ 2: "(ถาม Design) ข้อความในหน้าตั้งค่าเมื่อระบบปฏิเสธสิทธิ์แจ้งเตือน" ค้างอยู่ใน Requirements โดยยังไม่มีการทำเครื่องหมายว่าปิดประเด็น แม้ UX Flow และ Game Rules จะกำหนด Exact String ไว้แล้ว | ทำให้ข้อกำหนดใน requirements.md ไม่สอดคล้องกับสถานะการตัดสินใจในภาพรวมของเอกสารชุดเดียวกัน | ยังตัดสินไม่ได้ | ให้ Product/Design อัปเดต requirements.md ให้ระบุ Exact String `"สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน"` เป็นข้อยืนยันถาวร | ใช่ — ต้องอัปเดต requirements.md ให้ปิดคำถามข้อ 2 |

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|
| - | ไม่มีข้อมูลรอบก่อน | ไม่มีข้อมูลสำหรับเปรียบเทียบ | ไม่มีเอกสารรายงานรีวิวก่อนหน้า | ไม่ต้องดำเนินการ (ไม่มีประวัติ) |

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- Q-01: `requirements.md` หัวข้อ 7 (ข้อ 1) — ยังไม่มีการทำเครื่องหมายสรุปผลอย่างเป็นทางการในไฟล์ Requirements สำหรับชื่อไฟล์ภาพโปรไฟล์กบ Android (`assets/images/pet_profile_frog.png`), มีผลกระทบทำให้ Requirements ไม่สมบูรณ์, การประเมินการบล็อก: ยังตัดสินไม่ได้ (เนื่องจากมี Fallback ใน UX Flow แล้วแต่ตัวเอกสาร Requirements ยังเปิดคำถามทิ้งไว้), ต้องให้ Product/Design อัปเดต requirements.md ให้เรียบร้อย
- Q-02: `requirements.md` หัวข้อ 7 (ข้อ 2) — ยังไม่มีการทำเครื่องหมายสรุปผลอย่างเป็นทางการในไฟล์ Requirements สำหรับข้อความหน้าตั้งค่าเมื่อระบบปฏิเสธสิทธิ์แจ้งเตือน, มีผลกระทบทำให้ Requirements ไม่สมบูรณ์, การประเมินการบล็อก: ยังตัดสินไม่ได้ (เนื่องจากมี Exact String ใน UX Flow/Game Rules แล้วแต่ Requirements ยังแขวนคำถามไว้), ต้องให้ Product/Design อัปเดต requirements.md ให้เรียบร้อย

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)

| รายการวัด | ผลจาก log จริง | แหล่งหลักฐานใน logs/ | ต้องแก้มือ (พร้อมเหตุผล) |
|---|---|---|---|
| - | ไม่มีข้อมูลใน log ที่ได้รับ | ไม่มี | ไม่ต้องดำเนินการ |

## 7. ข้อจำกัดของการรีวิว
- เอกสารที่ตรวจจริง: `docs/notification-feature/requirements.md`, `docs/notification-feature/ux-flow.md`, `docs/notification-feature/game-rules.md`
- เอกสารที่ไม่ได้ตรวจ: ไม่มี
- ข้อจำกัด: ไม่พบรายงานการตรวจรอบก่อนหน้า ทำให้ไม่สามารถตรวจสอบการแก้ไขย้อนหลัง (Regression) ได้ และพบว่าไฟล์ Requirements ยังมี Open Questions ค้างอยู่แม้เอกสารอื่นจะมี Fallback Rule รองรับแล้ว

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: NEEDS_FIX
- Agent recommendation: ต้องแก้
- Blocking issues remaining: Q-01, Q-02 (Open Questions ใน requirements.md ยังไม่ถูกปิดอย่างเป็นทางการ)
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: แม้ว่าเอกสาร UX Flow และ Game Rules จะมีความสอดคล้อง กำหนดค่า ตัวเลข และ Edge Cases ได้อย่างสมบูรณ์แบบและมี Fallback Rule รองรับแล้ว แต่เอกสาร `requirements.md` ในหัวข้อ 7 ยังคงมี Open Questions 2 ข้อค้างอยู่โดยไม่มีการทำเครื่องหมายสรุปผลอย่างเป็นทางการ ส่งผลให้สถานะความพร้อมของ requirements.md ยังไม่สมบูรณ์และต้องให้ Product ทำการเคลียร์ประเด็นดังกล่าวให้เรียบร้อยก่อนส่งมอบให้ทีม Dev พัฒนาต่อไป
~~~~
