# Log: design_review · signup · 2026-10-30 09:53

<!-- meta: {"role": "design_review", "feature": "signup", "time": "2026-10-30 09:53", "status": "ok", "provider": "gemini", "model": "gemini-3.5-flash-lite", "attempts": 1, "seconds": 8.6, "llm_calls": 1, "total_tokens": 14458, "agent_version": "ac395134"} -->

| รายการ | ค่า |
|---|---|
| สถานะ | สำเร็จ |
| ผู้ให้บริการ / รุ่น | gemini / gemini-3.5-flash-lite |
| ลำดับความพยายาม | gemini: สำเร็จ |
| เวลารวม | 8.6 วินาที |
| จำนวนครั้งที่เรียก LLM | 1 |
| tokens (prompt / completion / total) | 13063 / 1395 / 14458 |
| ไฟล์ input | docs/signup/requirements.md, docs/signup/ux-flow.md, docs/signup/game-rules.md |
| ไฟล์ output | docs/signup/design-review.md |
| agent | agents/design_reviewer.md (เวอร์ชัน ac395134) |
| --note | - |

## ความพยายามที่ 1 — gemini (gemini-3.5-flash-lite) — สำเร็จ, 8.6 วินาที

### Agent

- ไฟล์: agents/design_reviewer.md
- role: Software Design Reviewer
- goal: Review the signup design documents against supplied project specifications, verify prior findings when available, and report evidence-backed contradictions, ambiguities, missing decisions, and actionable documentation issues without modifying source documents.
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

# Design Review: signup

## 1. ข้อมูลการตรวจ

- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: signup
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

#### Task → docs/signup/design-review.md

~~~~text
ฟีเจอร์: signup

งานของคุณ: ตรวจเอกสาร Requirements, UX Flow และ Game Rules ก่อนส่งงานให้ Dev ตรวจความครบถ้วนและความสอดคล้องของเอกสาร ตรวจตัวเลข ชื่อสถานะ ขั้นตอนการใช้งาน และ edge cases โดยอ้างอิงหลักฐานจากไฟล์ที่ได้รับ ระบุข้อผิดพลาดพร้อมไฟล์/หัวข้อ เหตุผล และแนวทางแก้ไข ห้ามแต่งข้อกำหนดหรือผลทดสอบขึ้นเอง สรุปผลเป็น PASS, NEEDS_FIX หรือ INSUFFICIENT_EVIDENCE

ข้อมูลประกอบ:
=== docs/signup/requirements.md ===
# Requirements: Signup & Onboarding Feature (signup)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Product agent · ผู้ตรวจ: Tech Lead & UX/UI Designer · อ้างอิง Issue: #101

## 1. สรุปฟีเจอร์
ระบบการสมัครสมาชิก เข้าสู่ระบบ (Authentication) และการกรอกข้อมูลส่วนตัวครั้งแรก (Onboarding) เพื่อจัดเก็บข้อมูลสุขภาพเบื้องต้นของผู้ใช้สำหรับแอปพลิเคชัน PetPal Health ช่วยให้ผู้ใช้สามารถเริ่มต้นใช้งานระบบได้อย่างรวดเร็วผ่าน Email/Password หรือ Google Login พร้อมทั้งเก็บข้อมูลสุขภาพเพื่อนำไปคำนวณและแนะนำการดูแลสุขภาพที่เหมาะสม

## 2. User stories

| ID | ในฐานะ | ฉันอยาก | เพื่อ |
|---|---|---|---|
| US-1 | ผู้ใช้งานใหม่ | สมัครสมาชิกด้วยอีเมลและรหัสผ่าน | เข้าใช้งานแอปพลิเคชัน PetPal Health ได้ |
| US-2 | ผู้ใช้งานใหม่ | เข้าสู่ระบบด้วยบัญชี Google | สมัครหรือเข้าใช้งานได้อย่างรวดเร็วโดยไม่ต้องจำรหัสผ่านใหม่ |
| US-3 | ผู้ใช้งานที่ลืมรหัสผ่าน | ขอรีเซ็ตรหัสผ่านผ่านอีเมล | ตั้งรหัสผ่านใหม่และกลับเข้าสู่ระบบได้ |
| US-4 | ผู้ใช้งานใหม่ที่สมัครสมาชิกสำเร็จ | กรอกข้อมูลส่วนตัวและข้อมูลสุขภาพในหน้าเดียว (Onboarding) | ระบบสามารถบันทึกข้อมูลและให้คำแนะนำด้านสุขภาพที่เหมาะสมได้ |
| US-5 | ผู้ใช้งานระบบ | จัดเก็บ Session การเข้าสู่ระบบไว้อย่างปลอดภัย | ไม่ต้องกรอกชื่อผู้ใช้และรหัสผ่านใหม่ทุกครั้งที่เปิดแอปพลิเคชัน |

## 3. Acceptance criteria

| ID | อ้างถึง | เงื่อนไข (ก่อน /เมื่อ /แล้ว) | ค่าที่ทดสอบได้ |
|---|---|---|---|
| AC-1 | US-1 | ก่อน: ผู้ใช้อยู่หน้าสมัครสมาชิก<br>เมื่อ: กรอกรหัสผ่านความยาว 5 ตัวอักษรหรือน้อยกว่า<br>แล้ว: ระบบต้องแสดงข้อความ Error ทันที | แสดงข้อความ Error: "รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร" และปุ่มสมัครสมาชิกถูก disable |
| AC-2 | US-1, US-2 | ก่อน: ผู้ใช้อยู่หน้าสมัครสมาชิก<br>เมื่อ: ใช้อีเมลที่เคยสมัครแล้วสมัครใหม่ หรือกด Google Login ด้วยอีเมลที่เคยสมัครแบบปกติแล้ว<br>แล้ว: ระบบจะแจ้งเตือนอีเมลซ้ำ หรือทำการเชื่อมต่อบัญชี (Account Linking) โดยอัตโนมัติ | กรณีสมัครปกติแสดง Error "อีเมลนี้ถูกใช้งานแล้ว", กรณี Google Login บัญชีถูกเชื่อมต่อและพาไปหน้า Onboarding ทันที |
| AC-3 | US-3 | ก่อน: ผู้ใช้อยู่หน้าลืมรหัสผ่าน<br>เมื่อ: ขอตั้งรหัสผ่านใหม่และกำหนดรหัสผ่านใหม่มีความยาวน้อยกว่า 6 ตัวอักษร<br>แล้ว: ระบบปฏิเสธการบันทึก | แสดงข้อความแจ้งเตือนว่ารหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร |
| AC-4 | US-4 | ก่อน: ผู้ใช้อยู่ในหน้า Onboarding<br>เมื่อ: ไม่กรอก Display Name และกดบันทึก<br>แล้ว: ระบบดึงชื่อหน้าอีเมลมาใช้เป็นค่าเริ่มต้น | ระบบบันทึกค่า Display Name เป็นชื่อหน้าอีเมล |
| AC-5 | US-4 | ก่อน: ผู้ใช้อยู่ในหน้า Onboarding และชื่อหน้าอีเมลมีความยาวเกิน 8 ตัวอักษร (เช่น `alexander@email.com`)<br>เมื่อ: ไม่กรอก Display Name และแสดงผลในพื้นที่จำกัด<br>แล้ว: ระบบตัดคำแสดงผลในรูปแบบ 4 ตัวแรก + `...` + 2 ตัวท้าย | แสดงผลเป็น `alex...er` บน UI |
| AC-6 | US-4 | ก่อน: ผู้ใช้อยู่ในหน้า Onboarding<br>เมื่อ: เลือกเพศเป็น "ไม่ระบุ"<br>แล้ว: ระบบแสดงข้อความแจ้งเตือนชัดเจน | แสดงข้อความ "ไม่สามารถคำนวณจำนวนแคลอรี่ที่เหมาะสมต่อวันได้" |
| AC-7 | US-4 | ก่อน: ผู้ใช้อยู่ในหน้า Onboarding<br>เมื่อ: ไม่กรอกน้ำหนัก หรือ ไม่กรอกส่วนสูง<br>แล้ว: ระบบแสดงข้อความแจ้งเตือนลักษณะเดียวกัน | แสดงข้อความ "จะไม่มีการแนะนำแคลอรี่ที่เหมาะสมต่อวัน" ใต้ฟิลด์ที่เว้นว่าง |
| AC-8 | US-5 | ก่อน: ผู้ใช้ล็อกอินสำเร็จ<br>เมื่อ: ปิดและเปิดแอปพลิเคชันขึ้นมาใหม่<br>แล้ว: ผู้ใช้ยังคงอยู่ในสถานะล็อกอิน | ระบบข้ามหน้า Login และแสดงหน้า Home ทันที พร้อม Token จัดเก็บใน Secure Storage |

## 4. Edge cases

| ID | สถานการณ์ | ผลที่คาดหวัง |
|---|---|---|
| EC-1 | อินเทอร์เน็ตหลุดระหว่างทำรายการ Google Login | แสดงปุ่ม Timeout / Retry เพื่อให้ผู้ใช้กดลองเชื่อมต่อใหม่อีกครั้งได้ |
| EC-2 | ผู้ใช้กรอกข้อมูลตัวเลขออกนอกขอบเขตที่กำหนด (อายุ 1-120, น้ำหนัก 1-300, ส่วนสูง 1-250) | ระบบบล็อกการกดบันทึกและแสดง Error ทันที |
| EC-3 | ผู้ใช้พิมพ์ Display Name เกิน 20 ตัวอักษร | ระบบบล็อกไม่ให้พิมพ์เพิ่มทันทีเมื่อครบ 20 ตัวอักษร |
| EC-4 | อินเทอร์เน็ตหลุดระหว่างกดบันทึกหน้า Onboarding | ระบบแสดงปุ่ม Retry โดยข้อมูลที่กรอกไว้ทั้งหมดจะไม่หายไป |
| EC-5 | ผู้ใช้กรอกอีเมลที่เคยสมัครสมาชิกไปแล้วในการสมัครปกติ | ระบบบล็อกและแสดงข้อความแจ้งเตือน "อีเมลนี้ถูกใช้งานแล้ว" |

## 5. สิ่งที่ไม่ทำในรอบนี้ (Out of scope)
- การยืนยันตัวตนสองขั้นตอน (2FA / OTP ทาง SMS)
- การสมัครสมาชิกหรือเข้าสู่ระบบด้วย Apple ID, Facebook หรือ Social Media อื่นๆ นอกจาก Google Login
- การแก้ไขเปลี่ยนอีเมลหลัก (Email Change) หลังสมัครสมาชิกสำเร็จในเวอร์ชันนี้
- ระบบคำนวณแคลอรี่เชิงลึกหรือเชื่อมต่อกับอุปกรณ์ Wearable (ทำเฉพาะการเก็บข้อมูลดิบและแสดงผลแจ้งเตือนตามเงื่อนไข)

## 6. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น)

| ข้อมูล | ชนิด/หน่วย | เก็บที่ไหน |
|---|---|---|
| Email | String (Email format) | Database (Users Table) |
| Password (Hashed) | String (Hashed) | Database (Users Table) |
| Auth Token / Session | String | Secure Storage (Device) |
| Display Name | String (Max 20 chars) | Database (Profiles Table) |
| อายุ (Age) | Integer (1 - 120 ปี) | Database (Profiles Table) |
| เพศ (Gender) | String (ชาย / หญิง / ไม่ระบุ) | Database (Profiles Table) |
| น้ำหนัก (Weight) | Float (1 - 300 กิโลกรัม) | Database (Profiles Table) |
| ส่วนสูง (Height) | Float (1 - 250 เซนติเมตร) | Database (Profiles Table) |
| เป้าหมายสุขภาพ (Health Goal) | Text (Default: "ดูแลสุขภาพ") | Database (Profiles Table) |

## 7. คำถามที่ยังเปิดอยู่
- ในกรณีที่ผู้ใช้ใช้ Google Login ครั้งแรก ระบบต้องการบังคับให้กดยอมรับ Terms & Conditions เพิ่มเติมในหน้า Onboarding หรือถือว่ายอมรับจาก Google มาแล้ว?
- ข้อความแจ้งเตือนกรณีไม่กรอกน้ำหนัก/ส่วนสูง/เพศ ควรเป็น Banner แจ้งเตือนแบบถาวรในหน้าโปรไฟล์ หรือเป็น Pop-up เตือนครั้งเดียวตอนกดบันทึก?

=== จบ docs/signup/requirements.md ===

=== docs/signup/ux-flow.md ===
# UX flow: Signup & Onboarding (signup)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Tech Lead & UX/UI Designer · อ้างอิง: requirements.md

## 1. รายการหน้าจอ

| ID | ชื่อหน้าจอ | จุดประสงค์ | อ้างถึง |
|---|---|---|---|
| S-1 | หน้าต้อนรับและเลือกวิธีเข้าสู่ระบบ | ให้ผู้ใช้เลือกเข้าสู่ระบบหรือสมัครสมาชิกผ่าน Email/Password หรือ Google Login | US-1, US-2 |
| S-2 | หน้าสมัครสมาชิกด้วยอีเมล | กรอกอีเมลและรหัสผ่านเพื่อสร้างบัญชีใหม่ | US-1, AC-1, AC-2, EC-5 |
| S-3 | หน้าลืมรหัสผ่าน (ขอรีเซ็ต) | กรอกอีเมลเพื่อรับลิงก์ตั้งรหัสผ่านใหม่ | US-3 |
| S-4 | หน้าจอรอการยืนยันรีเซ็ตรหัสผ่าน | แจ้งเตือนผู้ใช้ให้ตรวจสอบอีเมลสำหรับลิงก์ตั้งรหัสผ่านใหม่ | US-3 |
| S-5 | หน้าตั้งค่ารหัสผ่านใหม่ | กำหนดรหัสผ่านใหม่หลังจากคลิกลิงก์รีเซ็ต | US-3, AC-3 |
| S-6 | หน้า Onboarding (ข้อมูลส่วนตัวและสุขภาพ) | กรอก Display Name, อายุ, เพศ, น้ำหนัก, ส่วนสูง และเป้าหมายสุขภาพ | US-4, AC-4, AC-5, AC-6, AC-7, EC-2, EC-3, EC-4 |
| S-7 | หน้าจอหลัก (Home) | หน้าจอหลังจากล็อกอินหรือสมัครสมาชิกสำเร็จ | US-5, AC-8 |

## 2. องค์ประกอบบนหน้าจอ

### S-1 หน้าต้อนรับและเลือกวิธีเข้าสู่ระบบ
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| โลโก้แอปพลิเคชัน | รูปภาพ | `assets/images/signup/s1_logo.png` | - |
| หัวข้อหลัก | ข้อความหัวข้อ | "PetPal Health" | - |
| คำโปรย | ข้อความบรรยาย | "เพื่อนซี้สุขภาพดี พาคุณและสัตว์เลี้ยงมีความสุขไปด้วยกัน" | - |
| ปุ่ม Google Login | ปุ่มกด (Button) | "เข้าสู่ระบบด้วย Google" | เรียกใช้งาน Google Auth / ทำ Account Linking ถ้าอีเมลซ้ำ แล้วพาไป S-6 หรือ S-7 |
| เส้นคั่นหรือตัวอักษร | ข้อความ | "หรือ" | - |
| ปุ่มสมัครด้วยอีเมล | ปุ่มกด (Button) | "สมัครสมาชิกด้วยอีเมล" | พาไปหน้า S-2 |
| ข้อความมีบัญชีอยู่แล้ว | ปุ่มลิงก์ (Link) | "มีบัญชีอยู่แล้ว? เข้าสู่ระบบ" | พาไปหน้า S-2 (เปลี่ยนโหมดเป็นเข้าสู่ระบบ) |

### S-2 หน้าสมัครสมาชิกด้วยอีเมล
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| ปุ่มย้อนกลับ | ปุ่มไอคอน (Icon Button) | ไอคอนลูกศรซ้าย | กลับไปหน้า S-1 |
| หัวข้อหน้าจอ | ข้อความหัวข้อ | "สร้างบัญชีผู้ใช้" | - |
| ฟิลด์อีเมล | ช่องกรอกข้อความ (Text Field) | Placeholder: "กรอกอีเมลของคุณ" | รับค่า Email (Email format) |
| ฟิลด์รหัสผ่าน | ช่องกรอกข้อความ (Password Field) | Placeholder: "รหัสผ่าน (อย่างน้อย 6 ตัวอักษร)" | รับค่า Password |
| ข้อความ Error รหัสผ่าน | ข้อความแจ้งเตือน (Inline Error) | "รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร" | แสดงเมื่อรหัสผ่านสั้นกว่า 6 ตัวอักษร (AC-1) |
| ข้อความ Error อีเมลซ้ำ | ข้อความแจ้งเตือน (Inline Error) | "อีเมลนี้ถูกใช้งานแล้ว" | แสดงเมื่อใช้อีเมลที่เคยสมัครแล้ว (AC-2, EC-5) |
| ปุ่มดำเนินการ | ปุ่มกด (Button) | "ดำเนินการต่อ" / "สมัครสมาชิก" | ตรวจสอบข้อมูล ถ้าย่อ/สั้นเกินไปจะ disable ถ้ายืนยันสำเร็จไป S-6 |
| ลิงก์ลืมรหัสผ่าน | ปุ่มลิงก์ (Link) | "ลืมรหัสผ่าน?" | พาไปหน้า S-3 |

### S-3 หน้าลืมรหัสผ่าน (ขอรีเซ็ต)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| ปุ่มย้อนกลับ | ปุ่มไอคอน (Icon Button) | ไอคอนลูกศรซ้าย | กลับไปหน้า S-2 |
| หัวข้อหน้าจอ | ข้อความหัวข้อ | "ลืมรหัสผ่าน" | - |
| คำอธิบาย | ข้อความบรรยาย | "กรอกอีเมลที่คุณใช้สมัคร เพื่อรับลิงก์ตั้งค่ารหัสผ่านใหม่" | - |
| ฟิลด์อีเมลรีเซ็ต | ช่องกรอกข้อความ (Text Field) | Placeholder: "กรอกอีเมลของคุณ" | รับค่า Email |
| ปุ่มส่งคำขอ | ปุ่มกด (Button) | "ส่งลิงก์รีเซ็ตรหัสผ่าน" | ส่งคำขอรีเซ็ตแล้วพาไปหน้า S-4 |

### S-4 หน้าจอรอการยืนยันรีเซ็ตรหัสผ่าน
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| ไอคอนสถานะ | รูปภาพ | `assets/images/signup/s4_email_sent.png` | - |
| หัวข้อหน้าจอ | ข้อความหัวข้อ | "ตรวจสอบอีเมลของคุณ" | - |
| ข้อความแจ้งเตือน | ข้อความบรรยาย | "เราได้ส่งลิงก์สำหรับตั้งรหัสผ่านใหม่ไปที่อีเมลของคุณแล้ว กรุณาตรวจสอบกล่องข้อความ" | - |
| ปุ่มเปิดอีเมล/กลับหน้าหลัก | ปุ่มกด (Button) | "กลับสู่หน้าเข้าสู่ระบบ" | พาไปหน้า S-2 |

### S-5 หน้าตั้งค่ารหัสผ่านใหม่
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| หัวข้อหน้าจอ | ข้อความหัวข้อ | "ตั้งรหัสผ่านใหม่" | - |
| ฟิลด์รหัสผ่านใหม่ | ช่องกรอกข้อความ (Password Field) | Placeholder: "รหัสผ่านใหม่ (อย่างน้อย 6 ตัวอักษร)" | รับค่า Password ใหม่ |
| ข้อความ Error รหัสผ่านใหม่ | ข้อความแจ้งเตือน (Inline Error) | "รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร" | แสดงเมื่อความยาวน้อยกว่า 6 ตัวอักษร (AC-3) |
| ปุ่มบันทึกรหัสผ่าน | ปุ่มกด (Button) | "บันทึกรหัสผ่านใหม่" | บันทึกและพาไปหน้า S-2 พร้อมข้อความสำเร็จ |

### S-6 หน้า Onboarding (ข้อมูลส่วนตัวและสุขภาพ)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| หัวข้อหน้าจอ | ข้อความหัวข้อ | "ข้อมูลสุขภาพเบื้องต้นของคุณ" | - |
| คำอธิบาย | ข้อความบรรยาย | "โปรดกรอกข้อมูลเพื่อให้ PetPal Health ช่วยแนะนำการดูแลสุขภาพที่เหมาะสม" | - |
| ฟิลด์ Display Name | ช่องกรอกข้อความ (Text Field) | Placeholder: "ชื่อที่ใช้แสดง (สูงสุด 20 ตัวอักษร)" | จำกัดความยาวสูงสุด 20 ตัวอักษร (EC-3), หากเว้นว่างระบบจะดึงชื่อหน้าอีเมลมาใช้เป็นค่าเริ่มต้น (AC-4, AC-5) |
| ฟิลด์อายุ (Age) | ช่องกรอกตัวเลข (Stepper / Text Field) | Placeholder: "อายุ (ปี)" | รับค่า Integer ระหว่าง 1-120 ปี (EC-2) |
| ตัวเลือกเพศ (Gender) | Radio Button / Dropdown | ตัวเลือก: `MALE (ชาย)`, `FEMALE (หญิง)`, `UNSPECIFIED (ไม่ระบุ)` | ค่าเริ่มต้น: `UNSPECIFIED (ไม่ระบุ)` ตามกติกา Default Value Sync |
| คำเตือนเพศไม่ระบุ | ข้อความแจ้งเตือน (Inline Warning) | "ไม่สามารถคำนวณจำนวนแคลอรี่ที่เหมาะสมต่อวันได้" | ปรากฏขึ้นทันทีเมื่อเลือก `UNSPECIFIED (ไม่ระบุ)` (AC-6) |
| ฟิลด์น้ำหนัก (Weight) | ช่องกรอกตัวเลข (Text Field) | Placeholder: "น้ำหนัก (กิโลกรัม)" | รับค่า Float ระหว่าง 1-300 กิโลกรัม (EC-2) |
| ข้อความเตือนน้ำหนักว่าง | ข้อความแจ้งเตือน (Inline Warning) | "จะไม่มีการแนะนำแคลอรี่ที่เหมาะสมต่อวัน" | ปรากฏใต้ฟิลด์น้ำหนักหากเว้นว่าง (AC-7) |
| ฟิลด์ส่วนสูง (Height) | ช่องกรอกตัวเลข (Text Field) | Placeholder: "ส่วนสูง (เซนติเมตร)" | รับค่า Float ระหว่าง 1-250 เซนติเมตร (EC-2) |
| ข้อความเตือนส่วนสูงว่าง | ข้อความแจ้งเตือน (Inline Warning) | "จะไม่มีการแนะนำแคลอรี่ที่เหมาะสมต่อวัน" | ปรากฏใต้ฟิลด์ส่วนสูงหากเว้นว่าง (AC-7) |
| ฟิลด์เป้าหมายสุขภาพ | ช่องกรอกข้อความ (Text Area) | ค่าเริ่มต้น: "ดูแลสุขภาพ" | รับค่า Text |
| ปุ่มบันทึกข้อมูล | ปุ่มกด (Button) | "บันทึกและเริ่มต้นใช้งาน" | บันทึกข้อมูลลง Profiles Table และพาไปหน้า S-7 (หากเน็ตหลุดแสดงปุ่ม Retry ตาม EC-4) |

### S-7 หน้าจอหลัก (Home)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| แบนเนอร์ต้อนรับ | ข้อความ | แสดง Display Name ที่ประมวลผลแล้ว (เช่น `alex...er` หรือชื่อเต็ม) | - |
| Widget สุขภาพ | Widget แสดงผล | ข้อมูลสุขภาพและสัตว์เลี้ยงเสมือนจริง | - |

## 3. ขั้นตอนการใช้งาน (happy path)
1. ผู้ใช้เปิดแอปพลิเคชัน PetPal Health ขึ้นมาครั้งแรก จะพบกับหน้าต้อนรับ (S-1)
2. ผู้ใช้กดปุ่ม "สมัครสมาชิกด้วยอีเมล" ระบบนำทางไปยังหน้า S-2
3. ผู้ใช้กรอกอีเมลและรหัสผ่านที่มีความยาว 6 ตัวอักษรขึ้นไป แล้วกด "สมัครสมาชิก"
4. ระบบตรวจสอบความถูกต้องและสร้างบัญชีสำเร็จ จากนั้นนำทางผู้ใช้เข้าสู่หน้า Onboarding (S-6)
5. ผู้ใช้กรอก Display Name, อายุ, เพศ, น้ำหนัก, ส่วนสูง และเป้าหมายสุขภาพ (หรือปล่อยว่าง Display Name เพื่อให้ระบบดึงชื่อหน้าอีเมลมาใช้) แล้วกด "บันทึกและเริ่มต้นใช้งาน"
6. ระบบบันทึกข้อมูลลงในฐานข้อมูล และบันทึก Auth Token ลง Secure Storage บนเครื่อง
7. ระบบนำทางผู้ใช้เข้าสู่หน้าจอหลัก (S-7) โดยในครั้งถัดไปที่เปิดแอป ระบบจะข้ามหน้า Login และพามาที่หน้า S-7 ทันที (AC-8)

## 4. สถานะของหน้าจอ

| หน้าจอ | สถานะ | เงื่อนไขที่ทำให้เกิด | สิ่งที่แสดง |
|---|---|---|---|
| S-2 | ปกติ | ผู้ใช้เพิ่งเปิดหน้าสมัครสมาชิก | ฟิลด์อีเมลและรหัสผ่านว่างเปล่า ปุ่มดำเนินการถูก Disable |
| S-2 | ว่าง | ผู้ใช้ลบข้อความในฟิลด์จนหมด | แสดง Placeholder ในช่องกรอกข้อมูล |
| S-2 | ผิดพลาด (รหัสผ่านสั้น) | ผู้ใช้กรอกรหัสผ่านความยาว <= 5 ตัวอักษร (AC-1) | แสดงข้อความ Error: "รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร" และปุ่มถูก Disable |
| S-2 | ผิดพลาด (อีเมลซ้ำ) | ผู้ใช้อีเมลที่เคยสมัครแล้วมาสมัครใหม่ (AC-2, EC-5) | แสดงข้อความ Error: "อีเมลนี้ถูกใช้งานแล้ว" |
| S-5 | ผิดพลาด (รหัสผ่านใหม่สั้น) | ผู้ใช้กรอกรหัสผ่านใหม่น้อยกว่า 6 ตัวอักษร (AC-3) | แสดงข้อความแจ้งเตือนว่ารหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร |
| S-6 | ปกติ | เข้าสู่หน้า Onboarding ครั้งแรก | ฟิลด์แสดงค่าเริ่มต้น (`UNSPECIFIED (ไม่ระบุ)` สำหรับเพศ, "ดูแลสุขภาพ" สำหรับเป้าหมายสุขภาพ) |
| S-6 | ผิดพลาด (ไม่ระบุเพศ) | ผู้ใช้เลือกเพศเป็น `UNSPECIFIED (ไม่ระบุ)` (AC-6) | แสดงข้อความ "ไม่สามารถคำนวณจำนวนแคลอรี่ที่เหมาะสมต่อวันได้" |
| S-6 | ผิดพลาด (ไม่กรอกน้ำหนัก/ส่วนสูง) | ผู้ใช้เว้นว่างช่องน้ำหนักหรือส่วนสูง (AC-7) | แสดงข้อความ "จะไม่มีการแนะนำแคลอรี่ที่เหมาะสมต่อวัน" ใต้ฟิลด์ที่เว้นว่าง |
| S-6 | ผิดพลาด (ข้อมูลนอกขอบเขต) | ผู้ใช้กรอกอายุ/น้ำหนัก/ส่วนสูงเกินขอบเขต (EC-2) | ระบบบล็อกการกดบันทึกและแสดง Error ใต้ฟิลด์ |
| S-6 | ข้อผิดพลาดเครือข่าย | อินเทอร์เน็ตหลุดระหว่างกดบันทึก (EC-4) | ระบบแสดงปุ่ม Retry โดยข้อมูลที่กรอกไว้ไม่หายไป |

## 5. ไฟล์ภาพ assets

| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายภาพ |
|---|---|---|
| assets/images/signup/s1_logo.png | S-1 (หน้าต้อนรับ) | โลโก้หลักของแอปพลิเคชัน PetPal Health ขนาดกลาง |
| assets/images/signup/s4_email_sent.png | S-4 (หน้ารอการยืนยันอีเมล) | ไอคอนรูปซองจดหมายและนาฬิกาสื่อถึงการรอตรวจสอบอีเมล |
| assets/images/signup/s7_home_placeholder.png | S-7 (หน้าจอหลัก) | ภาพประกอบ Widget สุขภาพและสัตว์เลี้ยงเริ่มต้น |

## 6. คำถามถึง Product

- ในกรณีที่ผู้ใช้ใช้ Google Login ครั้งแรก ระบบต้องการบังคับให้กดยอมรับ Terms & Conditions เพิ่มเติมในหน้า Onboarding หรือถือว่ายอมรับจาก Google มาแล้ว?
  - *ข้อเสนอแนะจาก Design:* ถือว่ายอมรับข้อกำหนดพื้นฐานจากการเข้าสู่ระบบด้วย Google มาแล้ว แต่ควรเพิ่มข้อความแจ้งเตือนตัวเล็กๆ (Disclaimers) ด้านล่างปุ่ม Onboarding ว่าการดำเนินการต่อถือเป็นการยอมรับเงื่อนไขการใช้งานแอปพลิเคชัน
  - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ข้ามขั้นตอนการติ๊ก Terms & Conditions เพิ่มเติมในหน้า Onboarding โดยให้ถือว่าการกดปุ่ม Google Login หรือสมัครสมาชิกเป็นการยอมรับโดยปริยาย
  - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่ (มีแนวทางปฏิบัติที่ชัดเจนและสอดคล้องกับพฤติกรรมแอปทั่วไป)

- ข้อความแจ้งเตือนกรณีไม่กรอกน้ำหนัก/ส่วนสูง/เพศ ควรเป็น Banner แจ้งเตือนแบบถาวรในหน้าโปรไฟล์ หรือเป็น Pop-up เตือนครั้งเดียวตอนกดบันทึก?
  - *ข้อเสนอแนะจาก Design:* แสดงเป็นข้อความแจ้งเตือนแบบ Inline (Inline Warning) ใต้ฟิลด์ที่เกี่ยวข้องทันทีที่มีการเว้นว่างหรือเลือกค่าที่ไม่สมบูรณ์ เพื่อให้ผู้ใช้เห็นผลกระทบทันทีก่อนกดบันทึก
  - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ใช้ข้อความเตือนแบบ Inline ใต้ฟิลด์ตามที่ระบุใน AC-6 และ AC-7 โดยไม่บล็อกการกดบันทึก (ผู้ใช้ยังคงกดบันทึกข้ามไปได้แต่ฟีเจอร์คำนวณแคลอรี่จะไม่แสดงผล)
  - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่ (ข้อกำหนดระบุพฤติกรรมชัดเจนแล้วว่าจะแสดงข้อความเตือนลักษณะใด)

=== จบ docs/signup/ux-flow.md ===

=== docs/signup/game-rules.md ===
# กติกาเกม: Signup & Onboarding (signup)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Tech Lead & UX/UI Designer · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ความหมาย | ค่า | หน่วย | อ้างถึง |
|---|---|---|---|---|
| min_password_length | ความยาวขั้นต่ำของรหัสผ่าน | 6 | ตัวอักษร | AC-1, AC-3 |
| max_display_name_length | ความยาวสูงสุดของ Display Name | 20 | ตัวอักษร | EC-3 |
| display_name_truncation_limit | ความยาวชื่ออีเมลสูงสุดก่อนตัดคำ | 8 | ตัวอักษร | AC-5 |
| min_age | อายุขั้นต่ำที่รองรับ | 1 | ปี | EC-2 |
| max_age | อายุสูงสุดที่รองรับ | 120 | ปี | EC-2 |
| min_weight | น้ำหนักขั้นต่ำที่รองรับ | 1.0 | กิโลกรัม | EC-2 |
| max_weight | น้ำหนักสูงสุดที่รองรับ | 300.0 | กิโลกรัม | EC-2 |
| min_height | ส่วนสูงขั้นต่ำที่รองรับ | 1.0 | เซนติเมตร | EC-2 |
| max_height | ส่วนสูงสูงสุดที่รองรับ | 250.0 | เซนติเมตร | EC-2 |
| default_health_goal | เป้าหมายสุขภาพเริ่มต้น | ดูแลสุขภาพ | Text | requirements.md |
| default_gender | เพศเริ่มต้นในระบบ | UNSPECIFIED (ไม่ระบุ) | String Enum | UX Flow (S-6) |

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง

| สถานะ | ช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพ |
|---|---|---|
| DEFAULT_PET (สัตว์เลี้ยงเริ่มต้น) | ค่าสถานะเริ่มต้นหลังทำ Onboarding สำเร็จ (เมื่อยังไม่มีการบันทึกกิจกรรมสุขภาพเชิงลึกอื่นๆ) | `assets/images/signup/s7_home_placeholder.png` |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| กรอกรหัสผ่าน 5 ตัวอักษร | password = "abcde" (ความยาว 5) | Error แสดงผล, button = disabled | อ้าง AC-1 |
| ไม่กรอก Display Name โดยอีเมลคือ alexander@email.com (ความยาว > 8) | display_name = "" | display_name = "alex...er" | อ้าง AC-4, AC-5 |
| เลือกเพศเป็น "ไม่ระบุ" (`UNSPECIFIED`) | gender = `MALE` หรือ `FEMALE` | gender = `UNSPECIFIED` | แสดง Inline Warning (AC-6) |
| เว้นว่างช่องน้ำหนักหรือส่วนสูง | weight = null, height = null | weight = null, height = null | แสดง Inline Warning (AC-7) |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ |
|---|---|
| ผู้ใช้กรอกอายุ, น้ำหนัก, หรือส่วนสูง เกินขอบบนหรือต่ำกว่าขอบล่าง (เช่น อายุ 0 หรือ 121, น้ำหนัก 301, ส่วนสูง 251) | ระบบบล็อกการกดปุ่มบันทึกทันที และแสดง Error ใต้ฟิลด์ที่กรอกเกินขอบเขต (EC-2) |
| ผู้ใช้พิมพ์ Display Name ครบ 20 ตัวอักษร | ระบบบล็อกไม่ให้พิมพ์อักขระตัวที่ 21 เพิ่มเติมทันทีในระดับ UI (EC-3) |
| อินเทอร์เน็ตหลุดระหว่างกดบันทึกหน้า Onboarding (S-6) หรือระหว่าง Google Login | แสดงปุ่ม Retry โดยข้อมูลที่ผู้ใช้กรอกไว้ทั้งหมดจะไม่สูญหายและยังคงค้างอยู่ในฟิลด์ (EC-1, EC-4) |
| ผู้ใช้เปิดแอปพลิเคชันขึ้นมาใหม่หลังล็อกอินสำเร็จ | ระบบอ่าน Token จาก Secure Storage และข้ามหน้า Login ไปยังหน้า Home (S-7) ทันที (AC-8) |

## 5. คำถามถึง Product

- ในกรณีที่ผู้ใช้ใช้ Google Login ครั้งแรก ระบบต้องการบังคับให้กดยอมรับ Terms & Conditions เพิ่มเติมในหน้า Onboarding หรือถือว่ายอมรับจาก Google มาแล้ว?
  - *ข้อเสนอแนะจาก Design:* ถือว่ายอมรับข้อกำหนดพื้นฐานจากการเข้าสู่ระบบด้วย Google มาแล้ว แต่ควรเพิ่มข้อความแจ้งเตือนตัวเล็กๆ (Disclaimers) ด้านล่างปุ่ม Onboarding ว่าการดำเนินการต่อถือเป็นการยอมรับเงื่อนไขการใช้งานแอปพลิเคชัน
  - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ข้ามขั้นตอนการติ๊ก Terms & Conditions เพิ่มเติมในหน้า Onboarding โดยให้ถือว่าการกดปุ่ม Google Login หรือสมัครสมาชิกเป็นการยอมรับโดยปริยาย
  - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่ (มีแนวทางปฏิบัติที่ชัดเจนและสอดคล้องกับพฤติกรรมแอปทั่วไป)

- ข้อความแจ้งเตือนกรณีไม่กรอกน้ำหนัก/ส่วนสูง/เพศ ควรเป็น Banner แจ้งเตือนแบบถาวรในหน้าโปรไฟล์ หรือเป็น Pop-up เตือนครั้งเดียวตอนกดบันทึก?
  - *ข้อเสนอแนะจาก Design:* แสดงเป็นข้อความแจ้งเตือนแบบ Inline (Inline Warning) ใต้ฟิลด์ที่เกี่ยวข้องทันทีที่มีการเว้นว่างหรือเลือกค่าที่ไม่สมบูรณ์ เพื่อให้ผู้ใช้เห็นผลกระทบทันทีก่อนกดบันทึก
  - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ใช้ข้อความเตือนแบบ Inline ใต้ฟิลด์ตามที่ระบุใน AC-6 และ AC-7 โดยไม่บล็อกการกดบันทึก (ผู้ใช้ยังคงกดบันทึกข้ามไปได้แต่ฟีเจอร์คำนวณแคลอรี่จะไม่แสดงผล)
  - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่ (ข้อกำหนดระบุพฤติกรรมชัดเจนแล้วว่าจะแสดงข้อความเตือนลักษณะใด)

=== จบ docs/signup/game-rules.md ===

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

expected_output: เนื้อหาไฟล์ docs/signup/design-review.md ฉบับสมบูรณ์ ตามโครง template

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

# Design Review: signup

## 1. ข้อมูลการตรวจ

- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: signup
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
Your personal goal is: Review the signup design documents against supplied project specifications, verify prior findings when available, and report evidence-backed contradictions, ambiguities, missing decisions, and actionable documentation issues without modifying source documents.

[user]

Current Task: ฟีเจอร์: signup

งานของคุณ: ตรวจเอกสาร Requirements, UX Flow และ Game Rules ก่อนส่งงานให้ Dev ตรวจความครบถ้วนและความสอดคล้องของเอกสาร ตรวจตัวเลข ชื่อสถานะ ขั้นตอนการใช้งาน และ edge cases โดยอ้างอิงหลักฐานจากไฟล์ที่ได้รับ ระบุข้อผิดพลาดพร้อมไฟล์/หัวข้อ เหตุผล และแนวทางแก้ไข ห้ามแต่งข้อกำหนดหรือผลทดสอบขึ้นเอง สรุปผลเป็น PASS, NEEDS_FIX หรือ INSUFFICIENT_EVIDENCE

ข้อมูลประกอบ:
=== docs/signup/requirements.md ===
# Requirements: Signup & Onboarding Feature (signup)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Product agent · ผู้ตรวจ: Tech Lead & UX/UI Designer · อ้างอิง Issue: #101

## 1. สรุปฟีเจอร์
ระบบการสมัครสมาชิก เข้าสู่ระบบ (Authentication) และการกรอกข้อมูลส่วนตัวครั้งแรก (Onboarding) เพื่อจัดเก็บข้อมูลสุขภาพเบื้องต้นของผู้ใช้สำหรับแอปพลิเคชัน PetPal Health ช่วยให้ผู้ใช้สามารถเริ่มต้นใช้งานระบบได้อย่างรวดเร็วผ่าน Email/Password หรือ Google Login พร้อมทั้งเก็บข้อมูลสุขภาพเพื่อนำไปคำนวณและแนะนำการดูแลสุขภาพที่เหมาะสม

## 2. User stories

| ID | ในฐานะ | ฉันอยาก | เพื่อ |
|---|---|---|---|
| US-1 | ผู้ใช้งานใหม่ | สมัครสมาชิกด้วยอีเมลและรหัสผ่าน | เข้าใช้งานแอปพลิเคชัน PetPal Health ได้ |
| US-2 | ผู้ใช้งานใหม่ | เข้าสู่ระบบด้วยบัญชี Google | สมัครหรือเข้าใช้งานได้อย่างรวดเร็วโดยไม่ต้องจำรหัสผ่านใหม่ |
| US-3 | ผู้ใช้งานที่ลืมรหัสผ่าน | ขอรีเซ็ตรหัสผ่านผ่านอีเมล | ตั้งรหัสผ่านใหม่และกลับเข้าสู่ระบบได้ |
| US-4 | ผู้ใช้งานใหม่ที่สมัครสมาชิกสำเร็จ | กรอกข้อมูลส่วนตัวและข้อมูลสุขภาพในหน้าเดียว (Onboarding) | ระบบสามารถบันทึกข้อมูลและให้คำแนะนำด้านสุขภาพที่เหมาะสมได้ |
| US-5 | ผู้ใช้งานระบบ | จัดเก็บ Session การเข้าสู่ระบบไว้อย่างปลอดภัย | ไม่ต้องกรอกชื่อผู้ใช้และรหัสผ่านใหม่ทุกครั้งที่เปิดแอปพลิเคชัน |

## 3. Acceptance criteria

| ID | อ้างถึง | เงื่อนไข (ก่อน /เมื่อ /แล้ว) | ค่าที่ทดสอบได้ |
|---|---|---|---|
| AC-1 | US-1 | ก่อน: ผู้ใช้อยู่หน้าสมัครสมาชิก<br>เมื่อ: กรอกรหัสผ่านความยาว 5 ตัวอักษรหรือน้อยกว่า<br>แล้ว: ระบบต้องแสดงข้อความ Error ทันที | แสดงข้อความ Error: "รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร" และปุ่มสมัครสมาชิกถูก disable |
| AC-2 | US-1, US-2 | ก่อน: ผู้ใช้อยู่หน้าสมัครสมาชิก<br>เมื่อ: ใช้อีเมลที่เคยสมัครแล้วสมัครใหม่ หรือกด Google Login ด้วยอีเมลที่เคยสมัครแบบปกติแล้ว<br>แล้ว: ระบบจะแจ้งเตือนอีเมลซ้ำ หรือทำการเชื่อมต่อบัญชี (Account Linking) โดยอัตโนมัติ | กรณีสมัครปกติแสดง Error "อีเมลนี้ถูกใช้งานแล้ว", กรณี Google Login บัญชีถูกเชื่อมต่อและพาไปหน้า Onboarding ทันที |
| AC-3 | US-3 | ก่อน: ผู้ใช้อยู่หน้าลืมรหัสผ่าน<br>เมื่อ: ขอตั้งรหัสผ่านใหม่และกำหนดรหัสผ่านใหม่มีความยาวน้อยกว่า 6 ตัวอักษร<br>แล้ว: ระบบปฏิเสธการบันทึก | แสดงข้อความแจ้งเตือนว่ารหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร |
| AC-4 | US-4 | ก่อน: ผู้ใช้อยู่ในหน้า Onboarding<br>เมื่อ: ไม่กรอก Display Name และกดบันทึก<br>แล้ว: ระบบดึงชื่อหน้าอีเมลมาใช้เป็นค่าเริ่มต้น | ระบบบันทึกค่า Display Name เป็นชื่อหน้าอีเมล |
| AC-5 | US-4 | ก่อน: ผู้ใช้อยู่ในหน้า Onboarding และชื่อหน้าอีเมลมีความยาวเกิน 8 ตัวอักษร (เช่น `alexander@email.com`)<br>เมื่อ: ไม่กรอก Display Name และแสดงผลในพื้นที่จำกัด<br>แล้ว: ระบบตัดคำแสดงผลในรูปแบบ 4 ตัวแรก + `...` + 2 ตัวท้าย | แสดงผลเป็น `alex...er` บน UI |
| AC-6 | US-4 | ก่อน: ผู้ใช้อยู่ในหน้า Onboarding<br>เมื่อ: เลือกเพศเป็น "ไม่ระบุ"<br>แล้ว: ระบบแสดงข้อความแจ้งเตือนชัดเจน | แสดงข้อความ "ไม่สามารถคำนวณจำนวนแคลอรี่ที่เหมาะสมต่อวันได้" |
| AC-7 | US-4 | ก่อน: ผู้ใช้อยู่ในหน้า Onboarding<br>เมื่อ: ไม่กรอกน้ำหนัก หรือ ไม่กรอกส่วนสูง<br>แล้ว: ระบบแสดงข้อความแจ้งเตือนลักษณะเดียวกัน | แสดงข้อความ "จะไม่มีการแนะนำแคลอรี่ที่เหมาะสมต่อวัน" ใต้ฟิลด์ที่เว้นว่าง |
| AC-8 | US-5 | ก่อน: ผู้ใช้ล็อกอินสำเร็จ<br>เมื่อ: ปิดและเปิดแอปพลิเคชันขึ้นมาใหม่<br>แล้ว: ผู้ใช้ยังคงอยู่ในสถานะล็อกอิน | ระบบข้ามหน้า Login และแสดงหน้า Home ทันที พร้อม Token จัดเก็บใน Secure Storage |

## 4. Edge cases

| ID | สถานการณ์ | ผลที่คาดหวัง |
|---|---|---|
| EC-1 | อินเทอร์เน็ตหลุดระหว่างทำรายการ Google Login | แสดงปุ่ม Timeout / Retry เพื่อให้ผู้ใช้กดลองเชื่อมต่อใหม่อีกครั้งได้ |
| EC-2 | ผู้ใช้กรอกข้อมูลตัวเลขออกนอกขอบเขตที่กำหนด (อายุ 1-120, น้ำหนัก 1-300, ส่วนสูง 1-250) | ระบบบล็อกการกดบันทึกและแสดง Error ทันที |
| EC-3 | ผู้ใช้พิมพ์ Display Name เกิน 20 ตัวอักษร | ระบบบล็อกไม่ให้พิมพ์เพิ่มทันทีเมื่อครบ 20 ตัวอักษร |
| EC-4 | อินเทอร์เน็ตหลุดระหว่างกดบันทึกหน้า Onboarding | ระบบแสดงปุ่ม Retry โดยข้อมูลที่กรอกไว้ทั้งหมดจะไม่หายไป |
| EC-5 | ผู้ใช้กรอกอีเมลที่เคยสมัครสมาชิกไปแล้วในการสมัครปกติ | ระบบบล็อกและแสดงข้อความแจ้งเตือน "อีเมลนี้ถูกใช้งานแล้ว" |

## 5. สิ่งที่ไม่ทำในรอบนี้ (Out of scope)
- การยืนยันตัวตนสองขั้นตอน (2FA / OTP ทาง SMS)
- การสมัครสมาชิกหรือเข้าสู่ระบบด้วย Apple ID, Facebook หรือ Social Media อื่นๆ นอกจาก Google Login
- การแก้ไขเปลี่ยนอีเมลหลัก (Email Change) หลังสมัครสมาชิกสำเร็จในเวอร์ชันนี้
- ระบบคำนวณแคลอรี่เชิงลึกหรือเชื่อมต่อกับอุปกรณ์ Wearable (ทำเฉพาะการเก็บข้อมูลดิบและแสดงผลแจ้งเตือนตามเงื่อนไข)

## 6. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น)

| ข้อมูล | ชนิด/หน่วย | เก็บที่ไหน |
|---|---|---|
| Email | String (Email format) | Database (Users Table) |
| Password (Hashed) | String (Hashed) | Database (Users Table) |
| Auth Token / Session | String | Secure Storage (Device) |
| Display Name | String (Max 20 chars) | Database (Profiles Table) |
| อายุ (Age) | Integer (1 - 120 ปี) | Database (Profiles Table) |
| เพศ (Gender) | String (ชาย / หญิง / ไม่ระบุ) | Database (Profiles Table) |
| น้ำหนัก (Weight) | Float (1 - 300 กิโลกรัม) | Database (Profiles Table) |
| ส่วนสูง (Height) | Float (1 - 250 เซนติเมตร) | Database (Profiles Table) |
| เป้าหมายสุขภาพ (Health Goal) | Text (Default: "ดูแลสุขภาพ") | Database (Profiles Table) |

## 7. คำถามที่ยังเปิดอยู่
- ในกรณีที่ผู้ใช้ใช้ Google Login ครั้งแรก ระบบต้องการบังคับให้กดยอมรับ Terms & Conditions เพิ่มเติมในหน้า Onboarding หรือถือว่ายอมรับจาก Google มาแล้ว?
- ข้อความแจ้งเตือนกรณีไม่กรอกน้ำหนัก/ส่วนสูง/เพศ ควรเป็น Banner แจ้งเตือนแบบถาวรในหน้าโปรไฟล์ หรือเป็น Pop-up เตือนครั้งเดียวตอนกดบันทึก?

=== จบ docs/signup/requirements.md ===

=== docs/signup/ux-flow.md ===
# UX flow: Signup & Onboarding (signup)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Tech Lead & UX/UI Designer · อ้างอิง: requirements.md

## 1. รายการหน้าจอ

| ID | ชื่อหน้าจอ | จุดประสงค์ | อ้างถึง |
|---|---|---|---|
| S-1 | หน้าต้อนรับและเลือกวิธีเข้าสู่ระบบ | ให้ผู้ใช้เลือกเข้าสู่ระบบหรือสมัครสมาชิกผ่าน Email/Password หรือ Google Login | US-1, US-2 |
| S-2 | หน้าสมัครสมาชิกด้วยอีเมล | กรอกอีเมลและรหัสผ่านเพื่อสร้างบัญชีใหม่ | US-1, AC-1, AC-2, EC-5 |
| S-3 | หน้าลืมรหัสผ่าน (ขอรีเซ็ต) | กรอกอีเมลเพื่อรับลิงก์ตั้งรหัสผ่านใหม่ | US-3 |
| S-4 | หน้าจอรอการยืนยันรีเซ็ตรหัสผ่าน | แจ้งเตือนผู้ใช้ให้ตรวจสอบอีเมลสำหรับลิงก์ตั้งรหัสผ่านใหม่ | US-3 |
| S-5 | หน้าตั้งค่ารหัสผ่านใหม่ | กำหนดรหัสผ่านใหม่หลังจากคลิกลิงก์รีเซ็ต | US-3, AC-3 |
| S-6 | หน้า Onboarding (ข้อมูลส่วนตัวและสุขภาพ) | กรอก Display Name, อายุ, เพศ, น้ำหนัก, ส่วนสูง และเป้าหมายสุขภาพ | US-4, AC-4, AC-5, AC-6, AC-7, EC-2, EC-3, EC-4 |
| S-7 | หน้าจอหลัก (Home) | หน้าจอหลังจากล็อกอินหรือสมัครสมาชิกสำเร็จ | US-5, AC-8 |

## 2. องค์ประกอบบนหน้าจอ

### S-1 หน้าต้อนรับและเลือกวิธีเข้าสู่ระบบ
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| โลโก้แอปพลิเคชัน | รูปภาพ | `assets/images/signup/s1_logo.png` | - |
| หัวข้อหลัก | ข้อความหัวข้อ | "PetPal Health" | - |
| คำโปรย | ข้อความบรรยาย | "เพื่อนซี้สุขภาพดี พาคุณและสัตว์เลี้ยงมีความสุขไปด้วยกัน" | - |
| ปุ่ม Google Login | ปุ่มกด (Button) | "เข้าสู่ระบบด้วย Google" | เรียกใช้งาน Google Auth / ทำ Account Linking ถ้าอีเมลซ้ำ แล้วพาไป S-6 หรือ S-7 |
| เส้นคั่นหรือตัวอักษร | ข้อความ | "หรือ" | - |
| ปุ่มสมัครด้วยอีเมล | ปุ่มกด (Button) | "สมัครสมาชิกด้วยอีเมล" | พาไปหน้า S-2 |
| ข้อความมีบัญชีอยู่แล้ว | ปุ่มลิงก์ (Link) | "มีบัญชีอยู่แล้ว? เข้าสู่ระบบ" | พาไปหน้า S-2 (เปลี่ยนโหมดเป็นเข้าสู่ระบบ) |

### S-2 หน้าสมัครสมาชิกด้วยอีเมล
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| ปุ่มย้อนกลับ | ปุ่มไอคอน (Icon Button) | ไอคอนลูกศรซ้าย | กลับไปหน้า S-1 |
| หัวข้อหน้าจอ | ข้อความหัวข้อ | "สร้างบัญชีผู้ใช้" | - |
| ฟิลด์อีเมล | ช่องกรอกข้อความ (Text Field) | Placeholder: "กรอกอีเมลของคุณ" | รับค่า Email (Email format) |
| ฟิลด์รหัสผ่าน | ช่องกรอกข้อความ (Password Field) | Placeholder: "รหัสผ่าน (อย่างน้อย 6 ตัวอักษร)" | รับค่า Password |
| ข้อความ Error รหัสผ่าน | ข้อความแจ้งเตือน (Inline Error) | "รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร" | แสดงเมื่อรหัสผ่านสั้นกว่า 6 ตัวอักษร (AC-1) |
| ข้อความ Error อีเมลซ้ำ | ข้อความแจ้งเตือน (Inline Error) | "อีเมลนี้ถูกใช้งานแล้ว" | แสดงเมื่อใช้อีเมลที่เคยสมัครแล้ว (AC-2, EC-5) |
| ปุ่มดำเนินการ | ปุ่มกด (Button) | "ดำเนินการต่อ" / "สมัครสมาชิก" | ตรวจสอบข้อมูล ถ้าย่อ/สั้นเกินไปจะ disable ถ้ายืนยันสำเร็จไป S-6 |
| ลิงก์ลืมรหัสผ่าน | ปุ่มลิงก์ (Link) | "ลืมรหัสผ่าน?" | พาไปหน้า S-3 |

### S-3 หน้าลืมรหัสผ่าน (ขอรีเซ็ต)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| ปุ่มย้อนกลับ | ปุ่มไอคอน (Icon Button) | ไอคอนลูกศรซ้าย | กลับไปหน้า S-2 |
| หัวข้อหน้าจอ | ข้อความหัวข้อ | "ลืมรหัสผ่าน" | - |
| คำอธิบาย | ข้อความบรรยาย | "กรอกอีเมลที่คุณใช้สมัคร เพื่อรับลิงก์ตั้งค่ารหัสผ่านใหม่" | - |
| ฟิลด์อีเมลรีเซ็ต | ช่องกรอกข้อความ (Text Field) | Placeholder: "กรอกอีเมลของคุณ" | รับค่า Email |
| ปุ่มส่งคำขอ | ปุ่มกด (Button) | "ส่งลิงก์รีเซ็ตรหัสผ่าน" | ส่งคำขอรีเซ็ตแล้วพาไปหน้า S-4 |

### S-4 หน้าจอรอการยืนยันรีเซ็ตรหัสผ่าน
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| ไอคอนสถานะ | รูปภาพ | `assets/images/signup/s4_email_sent.png` | - |
| หัวข้อหน้าจอ | ข้อความหัวข้อ | "ตรวจสอบอีเมลของคุณ" | - |
| ข้อความแจ้งเตือน | ข้อความบรรยาย | "เราได้ส่งลิงก์สำหรับตั้งรหัสผ่านใหม่ไปที่อีเมลของคุณแล้ว กรุณาตรวจสอบกล่องข้อความ" | - |
| ปุ่มเปิดอีเมล/กลับหน้าหลัก | ปุ่มกด (Button) | "กลับสู่หน้าเข้าสู่ระบบ" | พาไปหน้า S-2 |

### S-5 หน้าตั้งค่ารหัสผ่านใหม่
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| หัวข้อหน้าจอ | ข้อความหัวข้อ | "ตั้งรหัสผ่านใหม่" | - |
| ฟิลด์รหัสผ่านใหม่ | ช่องกรอกข้อความ (Password Field) | Placeholder: "รหัสผ่านใหม่ (อย่างน้อย 6 ตัวอักษร)" | รับค่า Password ใหม่ |
| ข้อความ Error รหัสผ่านใหม่ | ข้อความแจ้งเตือน (Inline Error) | "รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร" | แสดงเมื่อความยาวน้อยกว่า 6 ตัวอักษร (AC-3) |
| ปุ่มบันทึกรหัสผ่าน | ปุ่มกด (Button) | "บันทึกรหัสผ่านใหม่" | บันทึกและพาไปหน้า S-2 พร้อมข้อความสำเร็จ |

### S-6 หน้า Onboarding (ข้อมูลส่วนตัวและสุขภาพ)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| หัวข้อหน้าจอ | ข้อความหัวข้อ | "ข้อมูลสุขภาพเบื้องต้นของคุณ" | - |
| คำอธิบาย | ข้อความบรรยาย | "โปรดกรอกข้อมูลเพื่อให้ PetPal Health ช่วยแนะนำการดูแลสุขภาพที่เหมาะสม" | - |
| ฟิลด์ Display Name | ช่องกรอกข้อความ (Text Field) | Placeholder: "ชื่อที่ใช้แสดง (สูงสุด 20 ตัวอักษร)" | จำกัดความยาวสูงสุด 20 ตัวอักษร (EC-3), หากเว้นว่างระบบจะดึงชื่อหน้าอีเมลมาใช้เป็นค่าเริ่มต้น (AC-4, AC-5) |
| ฟิลด์อายุ (Age) | ช่องกรอกตัวเลข (Stepper / Text Field) | Placeholder: "อายุ (ปี)" | รับค่า Integer ระหว่าง 1-120 ปี (EC-2) |
| ตัวเลือกเพศ (Gender) | Radio Button / Dropdown | ตัวเลือก: `MALE (ชาย)`, `FEMALE (หญิง)`, `UNSPECIFIED (ไม่ระบุ)` | ค่าเริ่มต้น: `UNSPECIFIED (ไม่ระบุ)` ตามกติกา Default Value Sync |
| คำเตือนเพศไม่ระบุ | ข้อความแจ้งเตือน (Inline Warning) | "ไม่สามารถคำนวณจำนวนแคลอรี่ที่เหมาะสมต่อวันได้" | ปรากฏขึ้นทันทีเมื่อเลือก `UNSPECIFIED (ไม่ระบุ)` (AC-6) |
| ฟิลด์น้ำหนัก (Weight) | ช่องกรอกตัวเลข (Text Field) | Placeholder: "น้ำหนัก (กิโลกรัม)" | รับค่า Float ระหว่าง 1-300 กิโลกรัม (EC-2) |
| ข้อความเตือนน้ำหนักว่าง | ข้อความแจ้งเตือน (Inline Warning) | "จะไม่มีการแนะนำแคลอรี่ที่เหมาะสมต่อวัน" | ปรากฏใต้ฟิลด์น้ำหนักหากเว้นว่าง (AC-7) |
| ฟิลด์ส่วนสูง (Height) | ช่องกรอกตัวเลข (Text Field) | Placeholder: "ส่วนสูง (เซนติเมตร)" | รับค่า Float ระหว่าง 1-250 เซนติเมตร (EC-2) |
| ข้อความเตือนส่วนสูงว่าง | ข้อความแจ้งเตือน (Inline Warning) | "จะไม่มีการแนะนำแคลอรี่ที่เหมาะสมต่อวัน" | ปรากฏใต้ฟิลด์ส่วนสูงหากเว้นว่าง (AC-7) |
| ฟิลด์เป้าหมายสุขภาพ | ช่องกรอกข้อความ (Text Area) | ค่าเริ่มต้น: "ดูแลสุขภาพ" | รับค่า Text |
| ปุ่มบันทึกข้อมูล | ปุ่มกด (Button) | "บันทึกและเริ่มต้นใช้งาน" | บันทึกข้อมูลลง Profiles Table และพาไปหน้า S-7 (หากเน็ตหลุดแสดงปุ่ม Retry ตาม EC-4) |

### S-7 หน้าจอหลัก (Home)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| แบนเนอร์ต้อนรับ | ข้อความ | แสดง Display Name ที่ประมวลผลแล้ว (เช่น `alex...er` หรือชื่อเต็ม) | - |
| Widget สุขภาพ | Widget แสดงผล | ข้อมูลสุขภาพและสัตว์เลี้ยงเสมือนจริง | - |

## 3. ขั้นตอนการใช้งาน (happy path)
1. ผู้ใช้เปิดแอปพลิเคชัน PetPal Health ขึ้นมาครั้งแรก จะพบกับหน้าต้อนรับ (S-1)
2. ผู้ใช้กดปุ่ม "สมัครสมาชิกด้วยอีเมล" ระบบนำทางไปยังหน้า S-2
3. ผู้ใช้กรอกอีเมลและรหัสผ่านที่มีความยาว 6 ตัวอักษรขึ้นไป แล้วกด "สมัครสมาชิก"
4. ระบบตรวจสอบความถูกต้องและสร้างบัญชีสำเร็จ จากนั้นนำทางผู้ใช้เข้าสู่หน้า Onboarding (S-6)
5. ผู้ใช้กรอก Display Name, อายุ, เพศ, น้ำหนัก, ส่วนสูง และเป้าหมายสุขภาพ (หรือปล่อยว่าง Display Name เพื่อให้ระบบดึงชื่อหน้าอีเมลมาใช้) แล้วกด "บันทึกและเริ่มต้นใช้งาน"
6. ระบบบันทึกข้อมูลลงในฐานข้อมูล และบันทึก Auth Token ลง Secure Storage บนเครื่อง
7. ระบบนำทางผู้ใช้เข้าสู่หน้าจอหลัก (S-7) โดยในครั้งถัดไปที่เปิดแอป ระบบจะข้ามหน้า Login และพามาที่หน้า S-7 ทันที (AC-8)

## 4. สถานะของหน้าจอ

| หน้าจอ | สถานะ | เงื่อนไขที่ทำให้เกิด | สิ่งที่แสดง |
|---|---|---|---|
| S-2 | ปกติ | ผู้ใช้เพิ่งเปิดหน้าสมัครสมาชิก | ฟิลด์อีเมลและรหัสผ่านว่างเปล่า ปุ่มดำเนินการถูก Disable |
| S-2 | ว่าง | ผู้ใช้ลบข้อความในฟิลด์จนหมด | แสดง Placeholder ในช่องกรอกข้อมูล |
| S-2 | ผิดพลาด (รหัสผ่านสั้น) | ผู้ใช้กรอกรหัสผ่านความยาว <= 5 ตัวอักษร (AC-1) | แสดงข้อความ Error: "รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร" และปุ่มถูก Disable |
| S-2 | ผิดพลาด (อีเมลซ้ำ) | ผู้ใช้อีเมลที่เคยสมัครแล้วมาสมัครใหม่ (AC-2, EC-5) | แสดงข้อความ Error: "อีเมลนี้ถูกใช้งานแล้ว" |
| S-5 | ผิดพลาด (รหัสผ่านใหม่สั้น) | ผู้ใช้กรอกรหัสผ่านใหม่น้อยกว่า 6 ตัวอักษร (AC-3) | แสดงข้อความแจ้งเตือนว่ารหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร |
| S-6 | ปกติ | เข้าสู่หน้า Onboarding ครั้งแรก | ฟิลด์แสดงค่าเริ่มต้น (`UNSPECIFIED (ไม่ระบุ)` สำหรับเพศ, "ดูแลสุขภาพ" สำหรับเป้าหมายสุขภาพ) |
| S-6 | ผิดพลาด (ไม่ระบุเพศ) | ผู้ใช้เลือกเพศเป็น `UNSPECIFIED (ไม่ระบุ)` (AC-6) | แสดงข้อความ "ไม่สามารถคำนวณจำนวนแคลอรี่ที่เหมาะสมต่อวันได้" |
| S-6 | ผิดพลาด (ไม่กรอกน้ำหนัก/ส่วนสูง) | ผู้ใช้เว้นว่างช่องน้ำหนักหรือส่วนสูง (AC-7) | แสดงข้อความ "จะไม่มีการแนะนำแคลอรี่ที่เหมาะสมต่อวัน" ใต้ฟิลด์ที่เว้นว่าง |
| S-6 | ผิดพลาด (ข้อมูลนอกขอบเขต) | ผู้ใช้กรอกอายุ/น้ำหนัก/ส่วนสูงเกินขอบเขต (EC-2) | ระบบบล็อกการกดบันทึกและแสดง Error ใต้ฟิลด์ |
| S-6 | ข้อผิดพลาดเครือข่าย | อินเทอร์เน็ตหลุดระหว่างกดบันทึก (EC-4) | ระบบแสดงปุ่ม Retry โดยข้อมูลที่กรอกไว้ไม่หายไป |

## 5. ไฟล์ภาพ assets

| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายภาพ |
|---|---|---|
| assets/images/signup/s1_logo.png | S-1 (หน้าต้อนรับ) | โลโก้หลักของแอปพลิเคชัน PetPal Health ขนาดกลาง |
| assets/images/signup/s4_email_sent.png | S-4 (หน้ารอการยืนยันอีเมล) | ไอคอนรูปซองจดหมายและนาฬิกาสื่อถึงการรอตรวจสอบอีเมล |
| assets/images/signup/s7_home_placeholder.png | S-7 (หน้าจอหลัก) | ภาพประกอบ Widget สุขภาพและสัตว์เลี้ยงเริ่มต้น |

## 6. คำถามถึง Product

- ในกรณีที่ผู้ใช้ใช้ Google Login ครั้งแรก ระบบต้องการบังคับให้กดยอมรับ Terms & Conditions เพิ่มเติมในหน้า Onboarding หรือถือว่ายอมรับจาก Google มาแล้ว?
  - *ข้อเสนอแนะจาก Design:* ถือว่ายอมรับข้อกำหนดพื้นฐานจากการเข้าสู่ระบบด้วย Google มาแล้ว แต่ควรเพิ่มข้อความแจ้งเตือนตัวเล็กๆ (Disclaimers) ด้านล่างปุ่ม Onboarding ว่าการดำเนินการต่อถือเป็นการยอมรับเงื่อนไขการใช้งานแอปพลิเคชัน
  - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ข้ามขั้นตอนการติ๊ก Terms & Conditions เพิ่มเติมในหน้า Onboarding โดยให้ถือว่าการกดปุ่ม Google Login หรือสมัครสมาชิกเป็นการยอมรับโดยปริยาย
  - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่ (มีแนวทางปฏิบัติที่ชัดเจนและสอดคล้องกับพฤติกรรมแอปทั่วไป)

- ข้อความแจ้งเตือนกรณีไม่กรอกน้ำหนัก/ส่วนสูง/เพศ ควรเป็น Banner แจ้งเตือนแบบถาวรในหน้าโปรไฟล์ หรือเป็น Pop-up เตือนครั้งเดียวตอนกดบันทึก?
  - *ข้อเสนอแนะจาก Design:* แสดงเป็นข้อความแจ้งเตือนแบบ Inline (Inline Warning) ใต้ฟิลด์ที่เกี่ยวข้องทันทีที่มีการเว้นว่างหรือเลือกค่าที่ไม่สมบูรณ์ เพื่อให้ผู้ใช้เห็นผลกระทบทันทีก่อนกดบันทึก
  - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ใช้ข้อความเตือนแบบ Inline ใต้ฟิลด์ตามที่ระบุใน AC-6 และ AC-7 โดยไม่บล็อกการกดบันทึก (ผู้ใช้ยังคงกดบันทึกข้ามไปได้แต่ฟีเจอร์คำนวณแคลอรี่จะไม่แสดงผล)
  - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่ (ข้อกำหนดระบุพฤติกรรมชัดเจนแล้วว่าจะแสดงข้อความเตือนลักษณะใด)

=== จบ docs/signup/ux-flow.md ===

=== docs/signup/game-rules.md ===
# กติกาเกม: Signup & Onboarding (signup)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Tech Lead & UX/UI Designer · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ความหมาย | ค่า | หน่วย | อ้างถึง |
|---|---|---|---|---|
| min_password_length | ความยาวขั้นต่ำของรหัสผ่าน | 6 | ตัวอักษร | AC-1, AC-3 |
| max_display_name_length | ความยาวสูงสุดของ Display Name | 20 | ตัวอักษร | EC-3 |
| display_name_truncation_limit | ความยาวชื่ออีเมลสูงสุดก่อนตัดคำ | 8 | ตัวอักษร | AC-5 |
| min_age | อายุขั้นต่ำที่รองรับ | 1 | ปี | EC-2 |
| max_age | อายุสูงสุดที่รองรับ | 120 | ปี | EC-2 |
| min_weight | น้ำหนักขั้นต่ำที่รองรับ | 1.0 | กิโลกรัม | EC-2 |
| max_weight | น้ำหนักสูงสุดที่รองรับ | 300.0 | กิโลกรัม | EC-2 |
| min_height | ส่วนสูงขั้นต่ำที่รองรับ | 1.0 | เซนติเมตร | EC-2 |
| max_height | ส่วนสูงสูงสุดที่รองรับ | 250.0 | เซนติเมตร | EC-2 |
| default_health_goal | เป้าหมายสุขภาพเริ่มต้น | ดูแลสุขภาพ | Text | requirements.md |
| default_gender | เพศเริ่มต้นในระบบ | UNSPECIFIED (ไม่ระบุ) | String Enum | UX Flow (S-6) |

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง

| สถานะ | ช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพ |
|---|---|---|
| DEFAULT_PET (สัตว์เลี้ยงเริ่มต้น) | ค่าสถานะเริ่มต้นหลังทำ Onboarding สำเร็จ (เมื่อยังไม่มีการบันทึกกิจกรรมสุขภาพเชิงลึกอื่นๆ) | `assets/images/signup/s7_home_placeholder.png` |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| กรอกรหัสผ่าน 5 ตัวอักษร | password = "abcde" (ความยาว 5) | Error แสดงผล, button = disabled | อ้าง AC-1 |
| ไม่กรอก Display Name โดยอีเมลคือ alexander@email.com (ความยาว > 8) | display_name = "" | display_name = "alex...er" | อ้าง AC-4, AC-5 |
| เลือกเพศเป็น "ไม่ระบุ" (`UNSPECIFIED`) | gender = `MALE` หรือ `FEMALE` | gender = `UNSPECIFIED` | แสดง Inline Warning (AC-6) |
| เว้นว่างช่องน้ำหนักหรือส่วนสูง | weight = null, height = null | weight = null, height = null | แสดง Inline Warning (AC-7) |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ |
|---|---|
| ผู้ใช้กรอกอายุ, น้ำหนัก, หรือส่วนสูง เกินขอบบนหรือต่ำกว่าขอบล่าง (เช่น อายุ 0 หรือ 121, น้ำหนัก 301, ส่วนสูง 251) | ระบบบล็อกการกดปุ่มบันทึกทันที และแสดง Error ใต้ฟิลด์ที่กรอกเกินขอบเขต (EC-2) |
| ผู้ใช้พิมพ์ Display Name ครบ 20 ตัวอักษร | ระบบบล็อกไม่ให้พิมพ์อักขระตัวที่ 21 เพิ่มเติมทันทีในระดับ UI (EC-3) |
| อินเทอร์เน็ตหลุดระหว่างกดบันทึกหน้า Onboarding (S-6) หรือระหว่าง Google Login | แสดงปุ่ม Retry โดยข้อมูลที่ผู้ใช้กรอกไว้ทั้งหมดจะไม่สูญหายและยังคงค้างอยู่ในฟิลด์ (EC-1, EC-4) |
| ผู้ใช้เปิดแอปพลิเคชันขึ้นมาใหม่หลังล็อกอินสำเร็จ | ระบบอ่าน Token จาก Secure Storage และข้ามหน้า Login ไปยังหน้า Home (S-7) ทันที (AC-8) |

## 5. คำถามถึง Product

- ในกรณีที่ผู้ใช้ใช้ Google Login ครั้งแรก ระบบต้องการบังคับให้กดยอมรับ Terms & Conditions เพิ่มเติมในหน้า Onboarding หรือถือว่ายอมรับจาก Google มาแล้ว?
  - *ข้อเสนอแนะจาก Design:* ถือว่ายอมรับข้อกำหนดพื้นฐานจากการเข้าสู่ระบบด้วย Google มาแล้ว แต่ควรเพิ่มข้อความแจ้งเตือนตัวเล็กๆ (Disclaimers) ด้านล่างปุ่ม Onboarding ว่าการดำเนินการต่อถือเป็นการยอมรับเงื่อนไขการใช้งานแอปพลิเคชัน
  - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ข้ามขั้นตอนการติ๊ก Terms & Conditions เพิ่มเติมในหน้า Onboarding โดยให้ถือว่าการกดปุ่ม Google Login หรือสมัครสมาชิกเป็นการยอมรับโดยปริยาย
  - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่ (มีแนวทางปฏิบัติที่ชัดเจนและสอดคล้องกับพฤติกรรมแอปทั่วไป)

- ข้อความแจ้งเตือนกรณีไม่กรอกน้ำหนัก/ส่วนสูง/เพศ ควรเป็น Banner แจ้งเตือนแบบถาวรในหน้าโปรไฟล์ หรือเป็น Pop-up เตือนครั้งเดียวตอนกดบันทึก?
  - *ข้อเสนอแนะจาก Design:* แสดงเป็นข้อความแจ้งเตือนแบบ Inline (Inline Warning) ใต้ฟิลด์ที่เกี่ยวข้องทันทีที่มีการเว้นว่างหรือเลือกค่าที่ไม่สมบูรณ์ เพื่อให้ผู้ใช้เห็นผลกระทบทันทีก่อนกดบันทึก
  - *กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):* ใช้ข้อความเตือนแบบ Inline ใต้ฟิลด์ตามที่ระบุใน AC-6 และ AC-7 โดยไม่บล็อกการกดบันทึก (ผู้ใช้ยังคงกดบันทึกข้ามไปได้แต่ฟีเจอร์คำนวณแคลอรี่จะไม่แสดงผล)
  - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่ (ข้อกำหนดระบุพฤติกรรมชัดเจนแล้วว่าจะแสดงข้อความเตือนลักษณะใด)

=== จบ docs/signup/game-rules.md ===

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

This is the expected criteria for your final answer: เนื้อหาไฟล์ docs/signup/design-review.md ฉบับสมบูรณ์ ตามโครง template
you MUST return the actual complete content as the final answer, not a summary.

Provide your complete response:
~~~~

### LLM call 1 — คำตอบ

~~~~text
# Design Review: signup

## 1. ข้อมูลการตรวจ
- Status: PASS
- Feature: signup
- Documents actually reviewed: docs/signup/requirements.md, docs/signup/ux-flow.md, docs/signup/game-rules.md
- Missing/unreadable documents: ไม่มี
- Previous findings checked: ไม่มีข้อมูลรอบก่อน (ไม่มีการบันทึกรีวิวก่อนหน้า)

## 2. ผล Checklist
ทุกข้อมีผล เหตุผล และหลักฐานจากไฟล์/หัวข้อที่ตรวจจริง หากข้อมูลไม่พอให้ใช้ INSUFFICIENT_EVIDENCE ห้ามเดา

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | PASS | เอกสาร requirements.md ระบุวัตถุประสงค์ User stories Acceptance criteria และ Edge cases ชัดเจนครบถ้วน | ไม่ใช่ เพราะโครงสร้างและรายละเอียดข้อมูลสมบูรณ์เพียงพอต่อการนำไปพัฒนา |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | PASS | เอกสารทั้ง 3 ฉบับสอดคล้องกัน โดย UX Flow อ้างอิง US และ Game Rules ระบุค่าตัวเลข ขอบเขต และพฤติกรรมสอดคล้องกับ AC และ EC | ไม่ใช่ เพราะข้อมูล ขอบเขต และสถานะเชื่อมโยงตรงกันทุกฉบับ |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | PASS | ค่าคงที่ เช่น min_password_length = 6, max_display_name_length = 20, ขอบเขตอายุ น้ำหนัก ส่วนสูง และสถานะ UNSPECIFIED ตรงกันทั้งใน Requirements, UX Flow และ Game Rules | ไม่ใช่ เพราะค่าตัวเลข ชื่อฟิลด์ และสถานะตรงกันทั้งหมด |
| C-04 | ขั้นตอนใช้งานและ Edge Cases เพียงพอ | PASS | UX Flow ระบุขั้นตอนการใช้งาน (happy path) หน้าจอ องค์ประกอบ และ Edge cases ใน requirements.md ครอบคลุมทั้งกรณีเน็ตหลุด อีเมลซ้ำ และข้อมูลนอกขอบเขต | ไม่ใช่ เพราะครอบคลุมสถานการณ์ปกติและกรณีขอบเขตครบถ้วน |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | PASS | Open Questions ใน Requirements, UX Flow และ Game Rules ระบุข้อเสนอแนะและกติกาชั่วคราว (Fallback Rule) พร้อมประเมินสถานะ Blocking: ไม่ใช่ ชัดเจน | ไม่ใช่ เพราะมีกติกาชั่วคราวรองรับการพัฒนาต่อได้ทันทีโดยไม่ติดขัด |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ข้อกำหนด Acceptance criteria, Edge cases และ Game rules ทุกข้ออ้างอิงถึงกันและมีที่มาจากไฟล์ที่ตรวจสอบได้ | ไม่ใช่ เพราะทุกรายการมีอ้างอิงและหลักฐานตรวจสอบย้อนกลับได้ |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | ผลการตรวจไม่พบปัญหาขัดแย้ง และข้อเสนอแนะใน Open Questions สอดคล้องกับสถานะ PASS | ไม่ใช่ เพราะข้อมูลและการประเมินสถานะมีความสอดคล้องเป็นไปในทิศทางเดียวกัน |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีรายงานการรีวิวก่อนหน้าสำหรับฟีเจอร์นี้ | ไม่ใช่ เนื่องจากไม่มีข้อมูลรอบก่อนให้ตรวจสอบเปรียบเทียบ (บันทึกไว้ตามข้อเท็จจริง) |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|

จากการตรวจสอบเปรียบเทียบเอกสาร `docs/signup/requirements.md`, `docs/signup/ux-flow.md` และ `docs/signup/game-rules.md` อย่างละเอียด ไม่พบปัญหาข้อขัดแย้ง ตัวเลขไม่ตรงกัน หรือข้อกำหนดที่ไม่สมบูรณ์ซึ่งจะขัดขวางการพัฒนา ทั้งนี้ Open Questions ในเอกสารได้ระบุ Fallback Rule รองรับไว้เรียบร้อยแล้ว

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|

ไม่มีข้อมูลสำหรับเปรียบเทียบ (ไม่พบรายงานการรีวิวก่อนหน้าในระบบ)

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- ไม่มีรายการปัญหาหรือคำถามที่บล็อกการพัฒนา ทุกคำถามใน Open Questions ของเอกสาร requirements.md, ux-flow.md และ game-rules.md มีกติกาชั่วคราว (Fallback Rule) และระบุชัดเจนว่า "Blocking: ไม่ใช่" ซึ่งได้รับการยืนยันด้วยหลักฐานในเอกสารว่าทีมพัฒนาสามารถดำเนินงานต่อได้ทันที

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)
- ไม่มีข้อมูลใน log ที่ได้รับ

## 7. ข้อจำกัดของการรีวิว
- ตรวจสอบเฉพาะเอกสารที่ได้รับ ได้แก่ docs/signup/requirements.md, docs/signup/ux-flow.md และ docs/signup/game-rules.md เท่านั้น
- ไม่มีข้อมูลรายงานการรีวิวก่อนหน้าสำหรับการตรวจสอบย้อนหลัง (Regression check)

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: PASS
- Agent recommendation: พร้อมส่ง Dev
- Blocking issues remaining: ไม่มี
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: เอกสาร requirements.md, ux-flow.md และ game-rules.md มีความครบถ้วน สมบูรณ์ และสอดคล้องกันในทุกมิติ ทั้งชื่อสถานะ ค่าตัวเลข ขอบเขต Edge cases และขั้นตอนการใช้งาน ตลอดจนมีกติกาชั่วคราว (Fallback Rule) รองรับในส่วนของ Open Questions ทำให้ไม่มีประเด็นติดขัดหรือบล็อกการพัฒนา ทีมพัฒนาสามารถนำไปปฏิบัติงานต่อได้ทันที
~~~~

### ผลลัพธ์ → docs/signup/design-review.md

~~~~text
# Design Review: signup

## 1. ข้อมูลการตรวจ
- Status: PASS
- Feature: signup
- Documents actually reviewed: docs/signup/requirements.md, docs/signup/ux-flow.md, docs/signup/game-rules.md
- Missing/unreadable documents: ไม่มี
- Previous findings checked: ไม่มีข้อมูลรอบก่อน (ไม่มีการบันทึกรีวิวก่อนหน้า)

## 2. ผล Checklist
ทุกข้อมีผล เหตุผล และหลักฐานจากไฟล์/หัวข้อที่ตรวจจริง หากข้อมูลไม่พอให้ใช้ INSUFFICIENT_EVIDENCE ห้ามเดา

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | PASS | เอกสาร requirements.md ระบุวัตถุประสงค์ User stories Acceptance criteria และ Edge cases ชัดเจนครบถ้วน | ไม่ใช่ เพราะโครงสร้างและรายละเอียดข้อมูลสมบูรณ์เพียงพอต่อการนำไปพัฒนา |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | PASS | เอกสารทั้ง 3 ฉบับสอดคล้องกัน โดย UX Flow อ้างอิง US และ Game Rules ระบุค่าตัวเลข ขอบเขต และพฤติกรรมสอดคล้องกับ AC และ EC | ไม่ใช่ เพราะข้อมูล ขอบเขต และสถานะเชื่อมโยงตรงกันทุกฉบับ |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | PASS | ค่าคงที่ เช่น min_password_length = 6, max_display_name_length = 20, ขอบเขตอายุ น้ำหนัก ส่วนสูง และสถานะ UNSPECIFIED ตรงกันทั้งใน Requirements, UX Flow และ Game Rules | ไม่ใช่ เพราะค่าตัวเลข ชื่อฟิลด์ และสถานะตรงกันทั้งหมด |
| C-04 | ขั้นตอนใช้งานและ Edge Cases เพียงพอ | PASS | UX Flow ระบุขั้นตอนการใช้งาน (happy path) หน้าจอ องค์ประกอบ และ Edge cases ใน requirements.md ครอบคลุมทั้งกรณีเน็ตหลุด อีเมลซ้ำ และข้อมูลนอกขอบเขต | ไม่ใช่ เพราะครอบคลุมสถานการณ์ปกติและกรณีขอบเขตครบถ้วน |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | PASS | Open Questions ใน Requirements, UX Flow และ Game Rules ระบุข้อเสนอแนะและกติกาชั่วคราว (Fallback Rule) พร้อมประเมินสถานะ Blocking: ไม่ใช่ ชัดเจน | ไม่ใช่ เพราะมีกติกาชั่วคราวรองรับการพัฒนาต่อได้ทันทีโดยไม่ติดขัด |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ข้อกำหนด Acceptance criteria, Edge cases และ Game rules ทุกข้ออ้างอิงถึงกันและมีที่มาจากไฟล์ที่ตรวจสอบได้ | ไม่ใช่ เพราะทุกรายการมีอ้างอิงและหลักฐานตรวจสอบย้อนกลับได้ |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | ผลการตรวจไม่พบปัญหาขัดแย้ง และข้อเสนอแนะใน Open Questions สอดคล้องกับสถานะ PASS | ไม่ใช่ เพราะข้อมูลและการประเมินสถานะมีความสอดคล้องเป็นไปในทิศทางเดียวกัน |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีรายงานการรีวิวก่อนหน้าสำหรับฟีเจอร์นี้ | ไม่ใช่ เนื่องจากไม่มีข้อมูลรอบก่อนให้ตรวจสอบเปรียบเทียบ (บันทึกไว้ตามข้อเท็จจริง) |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|

จากการตรวจสอบเปรียบเทียบเอกสาร `docs/signup/requirements.md`, `docs/signup/ux-flow.md` และ `docs/signup/game-rules.md` อย่างละเอียด ไม่พบปัญหาข้อขัดแย้ง ตัวเลขไม่ตรงกัน หรือข้อกำหนดที่ไม่สมบูรณ์ซึ่งจะขัดขวางการพัฒนา ทั้งนี้ Open Questions ในเอกสารได้ระบุ Fallback Rule รองรับไว้เรียบร้อยแล้ว

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|

ไม่มีข้อมูลสำหรับเปรียบเทียบ (ไม่พบรายงานการรีวิวก่อนหน้าในระบบ)

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- ไม่มีรายการปัญหาหรือคำถามที่บล็อกการพัฒนา ทุกคำถามใน Open Questions ของเอกสาร requirements.md, ux-flow.md และ game-rules.md มีกติกาชั่วคราว (Fallback Rule) และระบุชัดเจนว่า "Blocking: ไม่ใช่" ซึ่งได้รับการยืนยันด้วยหลักฐานในเอกสารว่าทีมพัฒนาสามารถดำเนินงานต่อได้ทันที

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)
- ไม่มีข้อมูลใน log ที่ได้รับ

## 7. ข้อจำกัดของการรีวิว
- ตรวจสอบเฉพาะเอกสารที่ได้รับ ได้แก่ docs/signup/requirements.md, docs/signup/ux-flow.md และ docs/signup/game-rules.md เท่านั้น
- ไม่มีข้อมูลรายงานการรีวิวก่อนหน้าสำหรับการตรวจสอบย้อนหลัง (Regression check)

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: PASS
- Agent recommendation: พร้อมส่ง Dev
- Blocking issues remaining: ไม่มี
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: เอกสาร requirements.md, ux-flow.md และ game-rules.md มีความครบถ้วน สมบูรณ์ และสอดคล้องกันในทุกมิติ ทั้งชื่อสถานะ ค่าตัวเลข ขอบเขต Edge cases และขั้นตอนการใช้งาน ตลอดจนมีกติกาชั่วคราว (Fallback Rule) รองรับในส่วนของ Open Questions ทำให้ไม่มีประเด็นติดขัดหรือบล็อกการพัฒนา ทีมพัฒนาสามารถนำไปปฏิบัติงานต่อได้ทันที
~~~~
