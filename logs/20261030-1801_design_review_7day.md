# Log: design_review · 7day · 2026-10-30 18:01

<!-- meta: {"role": "design_review", "feature": "7day", "time": "2026-10-30 18:01", "status": "ok", "provider": "gemini", "model": "gemini-3.5-flash-lite", "attempts": 1, "seconds": 7.5, "llm_calls": 1, "total_tokens": 13400, "agent_version": "ac395134"} -->

| รายการ | ค่า |
|---|---|
| สถานะ | สำเร็จ |
| ผู้ให้บริการ / รุ่น | gemini / gemini-3.5-flash-lite |
| ลำดับความพยายาม | gemini: สำเร็จ |
| เวลารวม | 7.5 วินาที |
| จำนวนครั้งที่เรียก LLM | 1 |
| tokens (prompt / completion / total) | 11597 / 1803 / 13400 |
| ไฟล์ input | docs/7day/requirements.md, docs/7day/ux-flow.md, docs/7day/game-rules.md |
| ไฟล์ output | docs/7day/design-review.md |
| agent | agents/design_reviewer.md (เวอร์ชัน ac395134) |
| --note | - |

## ความพยายามที่ 1 — gemini (gemini-3.5-flash-lite) — สำเร็จ, 7.5 วินาที

### Agent

- ไฟล์: agents/design_reviewer.md
- role: Software Design Reviewer
- goal: Review the 7day design documents against supplied project specifications, verify prior findings when available, and report evidence-backed contradictions, ambiguities, missing decisions, and actionable documentation issues without modifying source documents.
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

# Design Review: 7day

## 1. ข้อมูลการตรวจ

- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: 7day
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

#### Task → docs/7day/design-review.md

~~~~text
ฟีเจอร์: 7day

งานของคุณ: ตรวจเอกสาร Requirements, UX Flow และ Game Rules ก่อนส่งงานให้ Dev ตรวจความครบถ้วนและความสอดคล้องของเอกสาร ตรวจตัวเลข ชื่อสถานะ ขั้นตอนการใช้งาน และ edge cases โดยอ้างอิงหลักฐานจากไฟล์ที่ได้รับ ระบุข้อผิดพลาดพร้อมไฟล์/หัวข้อ เหตุผล และแนวทางแก้ไข ห้ามแต่งข้อกำหนดหรือผลทดสอบขึ้นเอง สรุปผลเป็น PASS, NEEDS_FIX หรือ INSUFFICIENT_EVIDENCE

ข้อมูลประกอบ:
=== docs/7day/requirements.md ===
# Requirements: 7-Day Health History & Weekly Summary Feature (7day)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Product agent · ผู้ตรวจ: Senior BA · อ้างอิง Issue: #701

## 1. สรุปฟีเจอร์
ฟีเจอร์ประวัติ 7 วัน (7day) ของแอป PetPal Health ช่วยแสดงผลสถิติกิจกรรมสุขภาพย้อนหลัง (การกิน, การเดิน, การดื่มน้ำ) เพื่อให้ผู้ใช้เห็นแนวโน้มพฤติกรรมสุขภาพของตนเอง ผ่านการ์ดสรุปภาพรวมด้านบนและการ์ดรายวัน 7 วันแบบ Minimal พับเก็บได้ โดยยึดรอบเวลาตาม Date Normalizer เวลา 05:00 น. (ICT) เสมอ

## 2. User stories

| ID | ในฐานะ | ฉันอยาก | เพื่อ |
|---|---|---|---|
| US-1 | ผู้ใช้แอป PetPal Health | ดูสถิติกิจกรรมสุขภาพย้อนหลัง 7 วัน (การกิน, การเดิน, การดื่มน้ำ) ในรูปแบบการ์ดรายวันแบบพับเก็บได้ โดยให้วันปัจจุบันอยู่บนสุด | เห็นแนวโน้มพฤติกรรมสุขภาพของตนเองในรอบสัปดาห์ได้อย่างกระชับและเป็นระเบียบ |
| US-2 | ผู้ใช้แอป PetPal Health | ดูค่าเฉลี่ยกิจกรรมสุขภาพย้อนหลังและการแจ้งเตือนข้อความแนะนำ (Rule-based Coaching Text) ในการ์ดสรุปภาพรวมด้านบน | ทราบภาพรวมพฤติกรรมสุขภาพและคำแนะนำที่สอดคล้องกับพฤติกรรมการบันทึกของตนเอง |
| US-3 | ผู้ใช้ระบบ | ประมวลผลและดึงข้อมูลผ่านฟังก์ชัน Date Normalizer ที่อิงตามรอบ 05:00 น. (ICT) เสมอ | ป้องกันปัญหา Timezone หรือข้อมูลข้ามวันผิดพลาด และอัปเดตข้อมูลข้ามวันได้อย่างถูกต้องเมื่อเปิดหน้าจอค้างไว้ |

## 3. Acceptance criteria

| ID | อ้างถึง | เงื่อนไข (ก่อน /เมื่อ /แล้ว) | ค่าที่ทดสอบได้ |
|---|---|---|---|
| AC-1 | US-1 | **ก่อน:** อยู่ในหน้าประวัติ 7 วัน <br>**เมื่อ:** ระบบโหลดข้อมูล <br>**แล้ว:** แสดง Card เรียงลำดับจากวันปัจจุบันอยู่บนสุด ไล่ย้อนหลังไป 6 วันรวมเป็น 7 วัน โดย Card ของวันปัจจุบันถูกเปิดแสดงรายละเอียด (Expanded) และอีก 6 วันที่เหลือถูกพับเก็บไว้ (Collapsed) | ตรวจสอบว่า Day 0 (Current Day) สถานะ `expanded = true` และ Day -1 ถึง Day -6 สถานะ `expanded = false` |
| AC-2 | US-1 | **ก่อน:** อยู่ในการ์ดรายวัน <br>**เมื่อ:** วันนั้นไม่มีข้อมูลการบันทึกเลย <br>**แล้ว:** แสดงข้อความ `"ไม่มีข้อมูล"` และไม่นำไปนับเป็นตัวหารค่าเฉลี่ย | ข้อความแสดงผลตรงกับ `"ไม่มีข้อมูล"` และ Count ของวันนั้นถูกตัดออกจากการหาร |
| AC-3 | US-2 | **ก่อน:** มีข้อมูลการบันทึกไม่ครบ 7 วัน (Count < 7) <br>**เมื่อ:** ระบบคำนวณค่าเฉลี่ย <br>**แล้ว:** ใช้สูตร $\sum(\text{Values}) / \text{Count}(\text{Days with Records})$ แสดงผลเป็นทศนิยม 1 ตำแหน่ง และแสดงข้อความนำหน้า `"มีการบันทึกไม่สม่ำเสมอ จากข้อมูลการบันทึกเท่าที่มีพบว่า..."` | ค่าเฉลี่ยแสดงผลทศนิยม 1 ตำแหน่ง (เช่น 6.5 แก้ว, 7,240.5 ก้าว) และมีข้อความเตือนความไม่สม่ำเสมอแสดงครบถ้วน |
| AC-4 | US-2 | **ก่อน:** ผลการคำนวณน้ำดื่มเฉลี่ย < 8 แก้ว <br>**เมื่อ:** แสดงผลการ์ดสรุปภาพรวม <br>**แล้ว:** แสดงข้อความ `"ดื่มน้ำเฉลี่ยวันละ {val} แก้ว น้อยไปน้า พยายามกินน้ำมากกว่านี้ แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ"` | ข้อความตรงกับ Brief เป๊ะๆ โดย `{val}` แทนที่ด้วยค่าเฉลี่ยทศนิยม 1 ตำแหน่ง |
| AC-5 | US-2 | **ก่อน:** ผลการคำนวณการเดินเฉลี่ย < 8,000 ก้าว <br>**เมื่อ:** แสดงผลการ์ดสรุปภาพรวม <br>**แล้ว:** แสดงข้อความ `"เดินเฉลี่ยวันละ {val} ก้าว ขยับอีกนิดน้าเพื่อสุขภาพที่แข็งแรง แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ"` | ข้อความตรงกับ Brief เป๊ะๆ โดย `{val}` แทนที่ด้วยค่าเฉลี่ยทศนิยม 1 ตำแหน่ง |
| AC-6 | US-2 | **ก่อน:** ไม่มีข้อมูลการบันทึกเลยสักวันในรอบ 7 วัน <br>**เมื่อ:** เปิดหน้าจอประวัติ 7 วัน <br>**แล้ว:** แสดงข้อความสถานะว่า `"ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้"` | ข้อความแสดงผลตรงกับ `"ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้"` |

## 4. Edge cases

| ID | สถานการณ์ | ผลที่คาดหวัง |
|---|---|---|
| EC-1 | ผู้ใช้มีข้อมูลไม่ครบ 7 วัน (New / Inconsistent Users) | ระบบคำนวณค่าเฉลี่ยโดยหารเฉพาะจำนวนวันที่มีการบันทึกจริง พร้อมแสดงป้ายเตือนบันทึกไม่สม่ำเสมอตามเงื่อนไข |
| EC-2 | วันที่ไม่มีข้อมูลบันทึกเลย (Missing Data Days) | การ์ดรายวันของวันนั้นจะแสดงสถานะ `"ไม่มีข้อมูล"` และระบบจะไม่นำไปคำนวณรวมในยอด sum ค่าเฉลี่ย |
| EC-3 | ไม่มีข้อมูลเลยตลอด 7 วัน (Completely Empty History) | หน้าจอแสดงสถานะหน้าว่าง และแสดงข้อความ `"ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้"` |
| EC-4 | ผู้ใช้เปิดหน้าจอค้างไว้ข้ามเวลา 05:00 น. (ICT) (Date Transition at 05:00 ICT) | ระบบทำการ Normalize วันใหม่โดยอิงรอบ 05:00 น. ทันที,รีเฟรช Card รายวัน และสลับเปิด Card วันปัจจุบันอันใหม่ให้อยู่บนสุดและถูก Expanded อัตโนมัติ |
| EC-5 | ไม่มีสัญญาณอินเทอร์เน็ต (Offline Cache) | ระบบดึงข้อมูลประวัติ 7 วันจาก Local Cache มาแสดงผลในรูปแบบ Collapsible Card ได้ปกติโดยไม่เกิด Error |

## 5. สิ่งที่ไม่ทำในรอบนี้ (Out of scope)
- ไม่มีการแสดงผลตัวละครสัตว์เลี้ยงในหน้าประวัติ 7 วันนี้
- ไม่มีกราฟแสดงแนวโน้ม (Chart) ในหน้าสรุป 7 วัน เน้นการแสดงผลตัวเลขและข้อความแบบ Minimal เท่านั้น
- ไม่มีฟังก์ชันการแก้ไขข้อมูลย้อนหลัง (Historical Editing) จากหน้าจอนี้

## 6. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น)

| ข้อมูล | ชนิด/หน่วย | เก็บที่ไหน |
|---|---|---|
| ยอดการเดิน (Steps) | Integer (ก้าว) | Local Database / Server Cache |
| การดื่มน้ำ (Water) | Float (แก้ว) | Local Database / Server Cache |
| แคลอรีอาหาร (Food Calories) | Integer (kcal) | Local Database / Server Cache |
| ป้ายเตือนพิเศษ (Special Tags) | String (เช่น โซเดียมสูง / น้ำตาลสูง / Overeating) | Local Database / Server Cache |

## 7. คำถามที่ยังเปิดอยู่
- ทีม Design จะใช้ Component UI ตัวใดในการทำ Collapsible Card ให้รองรับหน้าจอขนาดเล็กได้ดีที่สุด
- การจัดการ Cache Size สูงสุดในกรณีที่ผู้ใช้ Offline เป็นเวลานานเกิน 7 วัน จะกำหนดนโยบายอย่างไร

=== จบ docs/7day/requirements.md ===

=== docs/7day/ux-flow.md ===
# UX flow: 7-Day Health History & Weekly Summary Feature (7day)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Senior BA · อ้างอิง: requirements.md

## 1. รายการหน้าจอ

| ID | ชื่อหน้าจอ | จุดประสงค์ | อ้างถึง |
|---|---|---|---|
| S-1 | หน้าประวัติสุขภาพ 7 วัน (7-Day Health History Screen) | แสดงการ์ดสรุปภาพรวมสัปดาห์ (Weekly Summary Card) และการ์ดรายวัน 7 วันแบบพับเก็บได้ (Collapsible Cards) เพื่อให้ผู้ใช้ตรวจสถิติการกิน การเดิน และการดื่มน้ำย้อนหลัง | US-1, US-2, US-3, AC-1, AC-2, AC-3, AC-4, AC-5, AC-6 |

## 2. องค์ประกอบบนหน้าจอ

### S-1 หน้าประวัติสุขภาพ 7 วัน (7-Day Health History Screen)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| APP_BAR_TITLE | หัวข้อหน้าจอ | ประวัติสุขภาพ 7 วัน | - |
| SUMMARY_CARD | การ์ดสรุปภาพรวม | หัวข้อ: "สรุปภาพรวมรอบ 7 วัน"<br>• ค่าเฉลี่ยการดื่มน้ำ: `{val} แก้ว` (ทศนิยม 1 ตำแหน่ง)<br>• ค่าเฉลี่ยการเดิน: `{val} ก้าว` (ทศนิยม 1 ตำแหน่ง)<br>• ค่าเฉลี่ยแคลอรี: `{val} kcal` (ทศนิยม 1 ตำแหน่ง)<br>• Coaching Text: ข้อความคำแนะนำตามเงื่อนไข AC-3, AC-4, AC-5, AC-6 หรือกรณีปกติ | แสดงผลสรุปตามข้อมูลจริงในระบบ |
| DAY_CARD_0 (Day 0 - วันปัจจุบัน) | การ์ดรายวัน (Expanded) | วันที่: วันนี้, `{date_str}`<br>• การเดิน: `{steps_val}` ก้าว<br>• การดื่มน้ำ: `{water_val}` แก้ว<br>• แคลอรี: `{food_val}` kcal<br>• ป้ายเตือนพิเศษ (ถ้ามี): `{special_tag}` | กดพับเก็บการ์ด (Collapse) เปลี่ยนสถานะ `expanded = false` |
| DAY_CARD_1 ถึง DAY_CARD_6 (Day -1 ถึง Day -6) | การ์ดรายวัน (Collapsed) | วันที่: `{day_label}`, `{date_str}`<br>(แสดงแถบสรุปสั้นๆ เช่น การเดิน / น้ำ / แคลอรี หรือข้อความ `"ไม่มีข้อมูล"` หากไม่มีการบันทึก) | กดขยายการ์ด (Expand) เปลี่ยนสถานะ `expanded = true` ของการ์ดนั้นๆ |
| EMPTY_STATE_CONTAINER | กล่องสถานะว่าง (แสดงเฉพาะเมื่อไม่มีข้อมูลตลอด 7 วัน) | ข้อความ: `"ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้"` | - |

## 3. ขั้นตอนการใช้งาน (happy path)
1. ผู้ใช้แตะเลือกเมนู "ประวัติ 7 วัน" จากหน้าหลักของแอป
2. ระบบเรียกใช้งานฟังก์ชัน Date Normalizer อิงรอบเวลา 05:00 น. (ICT) เพื่อคำนวณช่วงเวลา 7 วันย้อนหลัง
3. ระบบโหลดข้อมูลดิบจาก Local Database / Server Cache และตรวจสอบการบันทึกของแต่ละวัน
4. ระบบแสดงผลหน้าจอ S-1 โดยการ์ดสรุปภาพรวม (SUMMARY_CARD) ด้านบนจะแสดงค่าเฉลี่ยและข้อความแนะนำ Rule-based Coaching Text
5. ระบบแสดงรายการการ์ดรายวัน 7 วัน โดย Day 0 (วันปัจจุบัน) จะอยู่บนสุดและอยู่ในสถานะเปิดขยาย (Expanded = true) ส่วน Day -1 ถึง Day -6 จะอยู่ในสถานะพับเก็บ (Collapsed = false)
6. ผู้ใช้สามารถแตะที่การ์ดรายวันอื่นๆ เพื่อพับหรือขยายดูรายละเอียดกิจกรรม (การเดิน, การดื่มน้ำ, แคลอรี) ของวันนั้นๆ ได้ตามต้องการ

## 4. สถานะของหน้าจอ

| หน้าจอ | สถานะ | เงื่อนไขที่ทำให้เกิด | สิ่งที่แสดง |
|---|---|---|---|
| S-1 | NORMAL (ปกติ) | ผู้ใช้มีข้อมูลการบันทึกครบถ้วนหรือบางส่วนในรอบ 7 วัน | แสดง SUMMARY_CARD คำนวณค่าเฉลี่ยปกติ และแสดง DAY_CARD เรียง 7 วันโดย Day 0 อยู่บนสุดและ Expanded ส่วนวันอื่น Collapsed |
| S-1 | INCONSISTENT (บันทึกไม่สม่ำเสมอ) | ผู้ใช้มีข้อมูลการบันทึกไม่ครบ 7 วัน (Count < 7 แต่ > 0) | แสดงข้อความเตือน `"มีการบันทึกไม่สม่ำเสมอ จากข้อมูลการบันทึกเท่าที่มีพบว่า..."` ใน SUMMARY_CARD พร้อมคำนวณค่าเฉลี่ยเฉพาะวันที่มียอดบันทึก |
| S-1 | EMPTY (ว่าง) | ไม่มีข้อมูลการบันทึกเลยสักวันในรอบ 7 วัน (Completely Empty History) | SUMMARY_CARD ซ่อนหรือแสดงค่า 0 และแสดง EMPTY_STATE_CONTAINER พร้อมข้อความ `"ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้"` |
| S-1 | OFFLINE (ออฟไลน์) | ไม่มีสัญญาณอินเทอร์เน็ตระหว่างเปิดหน้าจอ | ระบบดึงข้อมูลจาก Local Cache มาแสดงผลตามปกติโดยไม่แสดง Error Dialog |

## 5. ไฟล์ภาพ assets

| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายภาพ |
|---|---|---|
| `assets/images/7day/summary_card_bg.png` | S-1 (SUMMARY_CARD) | พื้นหลังการ์ดสรุปภาพรวมสไตล์ Minimal โทนสีพาสเทลอุ่น |
| `assets/images/7day/card_expanded_icon.png` | S-1 (DAY_CARD - Expanded) | ไอคอนลูกศรชี้ขึ้นแสดงสถานะกำลังขยายการ์ดรายวัน |
| `assets/images/7day/card_collapsed_icon.png` | S-1 (DAY_CARD - Collapsed) | ไอคอนลูกศรชี้ลงแสดงสถานะการ์ดรายวันที่ถูกพับเก็บไว้ |
| `assets/images/7day/empty_history_illustration.png` | S-1 (EMPTY_STATE_CONTAINER) | ภาพกราฟิกไอคอนกล่องเปล่า Minimal สื่อถึงยังไม่มีประวัติการบันทึกในรอบ 7 วัน (ไม่มีตัวละครสัตว์เลี้ยงตาม Out of scope) |

## 6. คำถามถึง Product

1. ข้อเสนอแนะจาก Design: ทีม Design แนะนำให้ใช้ขอบเขต Accordion Component แบบมาตรฐานที่มี Animation ความเร็ว 250ms ในการพับ/ขยายการ์ดรายวัน เพื่อให้รองรับหน้าจอขนาดเล็ก (Compact Screen) ได้ไหลลื่นและไม่กินพื้นที่
   - กติกาชั่วคราว (Fallback Rule): หากระบบ Accordion มีข้อจำกัดทางเทคนิค ให้ใช้การเปิด/ปิดแบบท็อกเกิลทันที (Instant Toggle) โดยไม่มี Animation ซับซ้อน เพื่อให้ Dev พัฒนาต่อได้ทันที
   - การประเมินสถานะการบล็อก: Blocking: ไม่ใช่ (เนื่องจากมี Fallback ชัดเจน)

2. ข้อเสนอแนะจาก Design: สำหรับนโยบาย Cache Size สูงสุดในกรณี Offline นานเกิน 7 วัน แนะนำให้จำกัดการจัดเก็บ Local Cache ไว้ที่ 30 วันล่าสุด (Rolling 30-Day Window) เพื่อประหยัดพื้นที่จัดเก็บในเครื่องผู้ใช้
   - กติกาชั่วคราว (Fallback Rule): ให้ระบบเก็บบันทึกย้อนหลังใน Local Cache สูงสุด 30 วันแรกพ้นจากนั้นให้ลบข้อมูลเก่าทิ้งอัตโนมัติ (FIFO - First In, First Out)
   - การประเมินสถานะการบล็อก: Blocking: ไม่ใช่ (อยู่นอกเหนือ Scope หลักของ 7 วัน แต่กำหนด Fallback รองรับไว้แล้ว)

=== จบ docs/7day/ux-flow.md ===

=== docs/7day/game-rules.md ===
# กติกาเกม: ประวัติสุขภาพ 7 วัน (7day)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Senior BA · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ความหมาย | ค่า | หน่วย / ชนิด | อ้างถึง |
|---|---|---|---|---|
| `MAX_HISTORY_DAYS` | จำนวนวันสูงสุดในประวัติที่แสดงผล | 7 | วัน (Integer) | AC-1 |
| `DATE_NORMALIZER_HOUR` | เวลาตัดรอบประจำวันตาม Date Normalizer (ICT) | 5 | นาฬิกา (Integer) | US-3, EC-4 |
| `WATER_GOAL_THRESHOLD` | เกณฑ์มาตรฐานค่าเฉลี่ยน้ำดื่มสำหรับการแสดงข้อความแนะนำ | 8.0 | แก้ว (Float 1 ตำแหน่ง) | AC-4 |
| `STEPS_GOAL_THRESHOLD` | เกณฑ์มาตรฐานค่าเฉลี่ยการเดินสำหรับการแสดงข้อความแนะนำ | 8000.0 | ก้าว (Float 1 ตำแหน่ง) | AC-5 |
| `LOCAL_CACHE_RETENTION_DAYS` | จำนวนวันสูงสุดในการจัดเก็บข้อมูลใน Local Cache (Rolling Window) | 30 | วัน (Integer) | EC-5 |

### 1.1 ตารางข้อความแนะนำตามเกณฑ์ (Rule-based Coaching Text Table)

| รหัสเงื่อนไข (Condition Code) | เกณฑ์การตรวจสอบ | ข้อความแนะนำที่แสดงผล (Exact String) | อ้างถึง |
|---|---|---|---|
| `PREFIX_INCONSISTENT` | บันทึกไม่ครบ 7 วัน (`0 < count < 7`) | `"มีการบันทึกไม่สม่ำเสมอ จากข้อมูลการบันทึกเท่าที่มีพบว่า..."` (แสดงเป็นคำนำหน้าข้อความแนะนำ) | AC-3 |
| `WARNING_LOW_WATER` | ค่าเฉลี่ยน้ำดื่ม < 8.0 แก้ว (`avg_water < 8.0`) | `"ดื่มน้ำเฉลี่ยวันละ {val} แก้ว น้อยไปน้า พยายามกินน้ำมากกว่านี้ แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ"` | AC-4 |
| `WARNING_LOW_STEPS` | ค่าเฉลี่ยการเดิน < 8,000 ก้าว (`avg_steps < 8000.0`) | `"เดินเฉลี่ยวันละ {val} ก้าว ขยับอีกนิดน้าเพื่อสุขภาพที่แข็งแรง แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ"` | AC-5 |
| `STATUS_EMPTY_7DAYS` | ไม่มีข้อมูลการบันทึกตลอด 7 วัน (`count == 0`) | `"ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้"` | AC-6 |
| `STATUS_NO_DAILY_DATA` | วันใดวันหนึ่งในการ์ดรายวันไม่มีข้อมูล | `"ไม่มีข้อมูล"` (แสดงบนการ์ดรายวันของวันนั้น และไม่นับเป็นตัวหารเฉลี่ย) | AC-2 |

*หมายเหตุ Coaching Text:*
- กรณีมีคำนำหน้า `PREFIX_INCONSISTENT` ให้วางไว้หน้าข้อความแนะนำเสมอ เช่น `"มีการบันทึกไม่สม่ำเสมอ จากข้อมูลการบันทึกเท่าที่มีพบว่า... ดื่มน้ำเฉลี่ยวันละ 6.5 แก้ว..."`
- หากเข้าเกณฑ์เตือนทั้งค่าน้ำดื่มต่ำ (`WARNING_LOW_WATER`) และการเดินต่ำ (`WARNING_LOW_STEPS`) ให้แสดงข้อความเตือนเรียงต่อกันเป็นคนละบรรทัด โดยค่าน้ำขึ้นก่อนแล้วตามด้วยก้าวเดิน เพื่อให้อ่านง่ายและชัดเจนบน UI

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง
*(หมายเหตุ: อ้างอิงจาก Out of scope ของฟีเจอร์ 7day ว่าไม่มีการแสดงผลตัวละครสัตว์เลี้ยงในหน้าประวัติ 7 วันนี้ จึงไม่มีสถานะหรืออารมณ์สัตว์เลี้ยงเฉพาะในหน้านี้)*

| สถานะ | ช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพ |
|---|---|---|
| N/A | N/A | N/A |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| คำนวณค่าเฉลี่ยน้ำดื่มจาก 3 วัน (7.0, 8.0, 9.0 แก้ว) | Count = 3, Sum = 24.0 | Average = 8.0 แก้ว | แสดงผลทศนิยม 1 ตำแหน่ง อ้างอิง AC-3 |
| คำนวณค่าเฉลี่ยการเดินจาก 2 วัน (5000, 6000 ก้าว) | Count = 2, Sum = 11000 | Average = 5500.0 ก้าว | แสดงผลทศนิยม 1 ตำแหน่ง อ้างอิง AC-3 |
| วันที่ไม่มีข้อมูลการบันทึกในรอบ 7 วัน | ยอดบันทึกดิบ = null | แสดงข้อความ `"ไม่มีข้อมูล"` และไม่นำ Count ไปหาร | อ้างอิง AC-2 |
| เปิดหน้าจอโดยไม่มีข้อมูลเลยตลอด 7 วัน | Sum = 0, Count = 0 | แสดงข้อความ `"ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้"` | อ้างอิง AC-6 |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ที่ทดสอบได้ |
|---|---|
| ผู้ใช้มีข้อมูลไม่ครบ 7 วัน (New / Inconsistent Users) | ระบบคำนวณค่าเฉลี่ยโดยหารเฉพาะจำนวนวันที่มีการบันทึกจริง ($\sum(\text{Values}) / \text{Count}$) แสดงผลทศนิยม 1 ตำแหน่ง พร้อมแสดงป้ายเตือน `"มีการบันทึกไม่สม่ำเสมอ จากข้อมูลการบันทึกเท่าที่มีพบว่า..."` |
| วันที่ไม่มีข้อมูลบันทึกเลย (Missing Data Days) | การ์ดรายวัน (DAY_CARD) ของวันนั้นจะแสดงข้อความ `"ไม่มีข้อมูล"` และระบบจะไม่นำไปคำนวณรวมในยอด sum และ count ของค่าเฉลี่ย |
| ไม่มีข้อมูลเลยตลอด 7 วัน (Completely Empty History) | หน้าจอซ่อนค่าสรุปหรือแสดงค่า 0 และแสดง EMPTY_STATE_CONTAINER พร้อมข้อความ `"ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้"` |
| ผู้ใช้เปิดหน้าจอค้างไว้ข้ามเวลา 05:00 น. (ICT) (Date Transition at 05:00 ICT) | ระบบทำการ Normalize วันใหม่โดยอิงรอบ 05:00 น. ทันที, รีเฟรช Card รายวัน และสลับเปิด Card วันปัจจุบันอันใหม่ให้อยู่บนสุดและถูก Expanded อัตโนมัติ (`expanded = true`) |
| ไม่มีสัญญาณอินเทอร์เน็ต (Offline Cache) | ระบบดึงข้อมูลประวัติ 7 วันจาก Local Cache มาแสดงผลในรูปแบบ Collapsible Card ได้ปกติโดยไม่เกิด Error Dialog |

## 5. คำถามถึง Product

1. **ข้อเสนอแนะจาก Design:** ทีม Design แนะนำให้ใช้ขอบเขต Accordion Component แบบมาตรฐานที่มี Animation ความเร็ว 250ms ในการพับ/ขยายการ์ดรายวัน เพื่อให้รองรับหน้าจอขนาดเล็ก (Compact Screen) ได้ไหลลื่น
   - *กติกาชั่วคราว (Fallback Rule):* หากระบบ Accordion มีข้อจำกัดทางเทคนิค ให้ใช้การเปิด/ปิดแบบท็อกเกิลทันที (Instant Toggle) โดยไม่มี Animation ซับซ้อน เพื่อให้ Dev พัฒนาต่อได้ทันที
   - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่
2. **ข้อเสนอแนะจาก Design:** สำหรับนโยบาย Cache Size สูงสุดในกรณี Offline นานเกิน 7 วัน แนะนำให้จำกัดการจัดเก็บ Local Cache ไว้ที่ 30 วันล่าสุด (Rolling 30-Day Window) เพื่อประหยัดพื้นที่จัดเก็บในเครื่องผู้ใช้
   - *กติกาชั่วคราว (Fallback Rule):* ให้ระบบเก็บบันทึกย้อนหลังใน Local Cache สูงสุด 30 วันแรกพ้นจากนั้นให้ลบข้อมูลเก่าทิ้งอัตโนมัติ (FIFO - First In, First Out)
   - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่

=== จบ docs/7day/game-rules.md ===

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

expected_output: เนื้อหาไฟล์ docs/7day/design-review.md ฉบับสมบูรณ์ ตามโครง template

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

# Design Review: 7day

## 1. ข้อมูลการตรวจ

- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: 7day
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
Your personal goal is: Review the 7day design documents against supplied project specifications, verify prior findings when available, and report evidence-backed contradictions, ambiguities, missing decisions, and actionable documentation issues without modifying source documents.

[user]

Current Task: ฟีเจอร์: 7day

งานของคุณ: ตรวจเอกสาร Requirements, UX Flow และ Game Rules ก่อนส่งงานให้ Dev ตรวจความครบถ้วนและความสอดคล้องของเอกสาร ตรวจตัวเลข ชื่อสถานะ ขั้นตอนการใช้งาน และ edge cases โดยอ้างอิงหลักฐานจากไฟล์ที่ได้รับ ระบุข้อผิดพลาดพร้อมไฟล์/หัวข้อ เหตุผล และแนวทางแก้ไข ห้ามแต่งข้อกำหนดหรือผลทดสอบขึ้นเอง สรุปผลเป็น PASS, NEEDS_FIX หรือ INSUFFICIENT_EVIDENCE

ข้อมูลประกอบ:
=== docs/7day/requirements.md ===
# Requirements: 7-Day Health History & Weekly Summary Feature (7day)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Product agent · ผู้ตรวจ: Senior BA · อ้างอิง Issue: #701

## 1. สรุปฟีเจอร์
ฟีเจอร์ประวัติ 7 วัน (7day) ของแอป PetPal Health ช่วยแสดงผลสถิติกิจกรรมสุขภาพย้อนหลัง (การกิน, การเดิน, การดื่มน้ำ) เพื่อให้ผู้ใช้เห็นแนวโน้มพฤติกรรมสุขภาพของตนเอง ผ่านการ์ดสรุปภาพรวมด้านบนและการ์ดรายวัน 7 วันแบบ Minimal พับเก็บได้ โดยยึดรอบเวลาตาม Date Normalizer เวลา 05:00 น. (ICT) เสมอ

## 2. User stories

| ID | ในฐานะ | ฉันอยาก | เพื่อ |
|---|---|---|---|
| US-1 | ผู้ใช้แอป PetPal Health | ดูสถิติกิจกรรมสุขภาพย้อนหลัง 7 วัน (การกิน, การเดิน, การดื่มน้ำ) ในรูปแบบการ์ดรายวันแบบพับเก็บได้ โดยให้วันปัจจุบันอยู่บนสุด | เห็นแนวโน้มพฤติกรรมสุขภาพของตนเองในรอบสัปดาห์ได้อย่างกระชับและเป็นระเบียบ |
| US-2 | ผู้ใช้แอป PetPal Health | ดูค่าเฉลี่ยกิจกรรมสุขภาพย้อนหลังและการแจ้งเตือนข้อความแนะนำ (Rule-based Coaching Text) ในการ์ดสรุปภาพรวมด้านบน | ทราบภาพรวมพฤติกรรมสุขภาพและคำแนะนำที่สอดคล้องกับพฤติกรรมการบันทึกของตนเอง |
| US-3 | ผู้ใช้ระบบ | ประมวลผลและดึงข้อมูลผ่านฟังก์ชัน Date Normalizer ที่อิงตามรอบ 05:00 น. (ICT) เสมอ | ป้องกันปัญหา Timezone หรือข้อมูลข้ามวันผิดพลาด และอัปเดตข้อมูลข้ามวันได้อย่างถูกต้องเมื่อเปิดหน้าจอค้างไว้ |

## 3. Acceptance criteria

| ID | อ้างถึง | เงื่อนไข (ก่อน /เมื่อ /แล้ว) | ค่าที่ทดสอบได้ |
|---|---|---|---|
| AC-1 | US-1 | **ก่อน:** อยู่ในหน้าประวัติ 7 วัน <br>**เมื่อ:** ระบบโหลดข้อมูล <br>**แล้ว:** แสดง Card เรียงลำดับจากวันปัจจุบันอยู่บนสุด ไล่ย้อนหลังไป 6 วันรวมเป็น 7 วัน โดย Card ของวันปัจจุบันถูกเปิดแสดงรายละเอียด (Expanded) และอีก 6 วันที่เหลือถูกพับเก็บไว้ (Collapsed) | ตรวจสอบว่า Day 0 (Current Day) สถานะ `expanded = true` และ Day -1 ถึง Day -6 สถานะ `expanded = false` |
| AC-2 | US-1 | **ก่อน:** อยู่ในการ์ดรายวัน <br>**เมื่อ:** วันนั้นไม่มีข้อมูลการบันทึกเลย <br>**แล้ว:** แสดงข้อความ `"ไม่มีข้อมูล"` และไม่นำไปนับเป็นตัวหารค่าเฉลี่ย | ข้อความแสดงผลตรงกับ `"ไม่มีข้อมูล"` และ Count ของวันนั้นถูกตัดออกจากการหาร |
| AC-3 | US-2 | **ก่อน:** มีข้อมูลการบันทึกไม่ครบ 7 วัน (Count < 7) <br>**เมื่อ:** ระบบคำนวณค่าเฉลี่ย <br>**แล้ว:** ใช้สูตร $\sum(\text{Values}) / \text{Count}(\text{Days with Records})$ แสดงผลเป็นทศนิยม 1 ตำแหน่ง และแสดงข้อความนำหน้า `"มีการบันทึกไม่สม่ำเสมอ จากข้อมูลการบันทึกเท่าที่มีพบว่า..."` | ค่าเฉลี่ยแสดงผลทศนิยม 1 ตำแหน่ง (เช่น 6.5 แก้ว, 7,240.5 ก้าว) และมีข้อความเตือนความไม่สม่ำเสมอแสดงครบถ้วน |
| AC-4 | US-2 | **ก่อน:** ผลการคำนวณน้ำดื่มเฉลี่ย < 8 แก้ว <br>**เมื่อ:** แสดงผลการ์ดสรุปภาพรวม <br>**แล้ว:** แสดงข้อความ `"ดื่มน้ำเฉลี่ยวันละ {val} แก้ว น้อยไปน้า พยายามกินน้ำมากกว่านี้ แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ"` | ข้อความตรงกับ Brief เป๊ะๆ โดย `{val}` แทนที่ด้วยค่าเฉลี่ยทศนิยม 1 ตำแหน่ง |
| AC-5 | US-2 | **ก่อน:** ผลการคำนวณการเดินเฉลี่ย < 8,000 ก้าว <br>**เมื่อ:** แสดงผลการ์ดสรุปภาพรวม <br>**แล้ว:** แสดงข้อความ `"เดินเฉลี่ยวันละ {val} ก้าว ขยับอีกนิดน้าเพื่อสุขภาพที่แข็งแรง แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ"` | ข้อความตรงกับ Brief เป๊ะๆ โดย `{val}` แทนที่ด้วยค่าเฉลี่ยทศนิยม 1 ตำแหน่ง |
| AC-6 | US-2 | **ก่อน:** ไม่มีข้อมูลการบันทึกเลยสักวันในรอบ 7 วัน <br>**เมื่อ:** เปิดหน้าจอประวัติ 7 วัน <br>**แล้ว:** แสดงข้อความสถานะว่า `"ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้"` | ข้อความแสดงผลตรงกับ `"ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้"` |

## 4. Edge cases

| ID | สถานการณ์ | ผลที่คาดหวัง |
|---|---|---|
| EC-1 | ผู้ใช้มีข้อมูลไม่ครบ 7 วัน (New / Inconsistent Users) | ระบบคำนวณค่าเฉลี่ยโดยหารเฉพาะจำนวนวันที่มีการบันทึกจริง พร้อมแสดงป้ายเตือนบันทึกไม่สม่ำเสมอตามเงื่อนไข |
| EC-2 | วันที่ไม่มีข้อมูลบันทึกเลย (Missing Data Days) | การ์ดรายวันของวันนั้นจะแสดงสถานะ `"ไม่มีข้อมูล"` และระบบจะไม่นำไปคำนวณรวมในยอด sum ค่าเฉลี่ย |
| EC-3 | ไม่มีข้อมูลเลยตลอด 7 วัน (Completely Empty History) | หน้าจอแสดงสถานะหน้าว่าง และแสดงข้อความ `"ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้"` |
| EC-4 | ผู้ใช้เปิดหน้าจอค้างไว้ข้ามเวลา 05:00 น. (ICT) (Date Transition at 05:00 ICT) | ระบบทำการ Normalize วันใหม่โดยอิงรอบ 05:00 น. ทันที,รีเฟรช Card รายวัน และสลับเปิด Card วันปัจจุบันอันใหม่ให้อยู่บนสุดและถูก Expanded อัตโนมัติ |
| EC-5 | ไม่มีสัญญาณอินเทอร์เน็ต (Offline Cache) | ระบบดึงข้อมูลประวัติ 7 วันจาก Local Cache มาแสดงผลในรูปแบบ Collapsible Card ได้ปกติโดยไม่เกิด Error |

## 5. สิ่งที่ไม่ทำในรอบนี้ (Out of scope)
- ไม่มีการแสดงผลตัวละครสัตว์เลี้ยงในหน้าประวัติ 7 วันนี้
- ไม่มีกราฟแสดงแนวโน้ม (Chart) ในหน้าสรุป 7 วัน เน้นการแสดงผลตัวเลขและข้อความแบบ Minimal เท่านั้น
- ไม่มีฟังก์ชันการแก้ไขข้อมูลย้อนหลัง (Historical Editing) จากหน้าจอนี้

## 6. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น)

| ข้อมูล | ชนิด/หน่วย | เก็บที่ไหน |
|---|---|---|
| ยอดการเดิน (Steps) | Integer (ก้าว) | Local Database / Server Cache |
| การดื่มน้ำ (Water) | Float (แก้ว) | Local Database / Server Cache |
| แคลอรีอาหาร (Food Calories) | Integer (kcal) | Local Database / Server Cache |
| ป้ายเตือนพิเศษ (Special Tags) | String (เช่น โซเดียมสูง / น้ำตาลสูง / Overeating) | Local Database / Server Cache |

## 7. คำถามที่ยังเปิดอยู่
- ทีม Design จะใช้ Component UI ตัวใดในการทำ Collapsible Card ให้รองรับหน้าจอขนาดเล็กได้ดีที่สุด
- การจัดการ Cache Size สูงสุดในกรณีที่ผู้ใช้ Offline เป็นเวลานานเกิน 7 วัน จะกำหนดนโยบายอย่างไร

=== จบ docs/7day/requirements.md ===

=== docs/7day/ux-flow.md ===
# UX flow: 7-Day Health History & Weekly Summary Feature (7day)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Senior BA · อ้างอิง: requirements.md

## 1. รายการหน้าจอ

| ID | ชื่อหน้าจอ | จุดประสงค์ | อ้างถึง |
|---|---|---|---|
| S-1 | หน้าประวัติสุขภาพ 7 วัน (7-Day Health History Screen) | แสดงการ์ดสรุปภาพรวมสัปดาห์ (Weekly Summary Card) และการ์ดรายวัน 7 วันแบบพับเก็บได้ (Collapsible Cards) เพื่อให้ผู้ใช้ตรวจสถิติการกิน การเดิน และการดื่มน้ำย้อนหลัง | US-1, US-2, US-3, AC-1, AC-2, AC-3, AC-4, AC-5, AC-6 |

## 2. องค์ประกอบบนหน้าจอ

### S-1 หน้าประวัติสุขภาพ 7 วัน (7-Day Health History Screen)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| APP_BAR_TITLE | หัวข้อหน้าจอ | ประวัติสุขภาพ 7 วัน | - |
| SUMMARY_CARD | การ์ดสรุปภาพรวม | หัวข้อ: "สรุปภาพรวมรอบ 7 วัน"<br>• ค่าเฉลี่ยการดื่มน้ำ: `{val} แก้ว` (ทศนิยม 1 ตำแหน่ง)<br>• ค่าเฉลี่ยการเดิน: `{val} ก้าว` (ทศนิยม 1 ตำแหน่ง)<br>• ค่าเฉลี่ยแคลอรี: `{val} kcal` (ทศนิยม 1 ตำแหน่ง)<br>• Coaching Text: ข้อความคำแนะนำตามเงื่อนไข AC-3, AC-4, AC-5, AC-6 หรือกรณีปกติ | แสดงผลสรุปตามข้อมูลจริงในระบบ |
| DAY_CARD_0 (Day 0 - วันปัจจุบัน) | การ์ดรายวัน (Expanded) | วันที่: วันนี้, `{date_str}`<br>• การเดิน: `{steps_val}` ก้าว<br>• การดื่มน้ำ: `{water_val}` แก้ว<br>• แคลอรี: `{food_val}` kcal<br>• ป้ายเตือนพิเศษ (ถ้ามี): `{special_tag}` | กดพับเก็บการ์ด (Collapse) เปลี่ยนสถานะ `expanded = false` |
| DAY_CARD_1 ถึง DAY_CARD_6 (Day -1 ถึง Day -6) | การ์ดรายวัน (Collapsed) | วันที่: `{day_label}`, `{date_str}`<br>(แสดงแถบสรุปสั้นๆ เช่น การเดิน / น้ำ / แคลอรี หรือข้อความ `"ไม่มีข้อมูล"` หากไม่มีการบันทึก) | กดขยายการ์ด (Expand) เปลี่ยนสถานะ `expanded = true` ของการ์ดนั้นๆ |
| EMPTY_STATE_CONTAINER | กล่องสถานะว่าง (แสดงเฉพาะเมื่อไม่มีข้อมูลตลอด 7 วัน) | ข้อความ: `"ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้"` | - |

## 3. ขั้นตอนการใช้งาน (happy path)
1. ผู้ใช้แตะเลือกเมนู "ประวัติ 7 วัน" จากหน้าหลักของแอป
2. ระบบเรียกใช้งานฟังก์ชัน Date Normalizer อิงรอบเวลา 05:00 น. (ICT) เพื่อคำนวณช่วงเวลา 7 วันย้อนหลัง
3. ระบบโหลดข้อมูลดิบจาก Local Database / Server Cache และตรวจสอบการบันทึกของแต่ละวัน
4. ระบบแสดงผลหน้าจอ S-1 โดยการ์ดสรุปภาพรวม (SUMMARY_CARD) ด้านบนจะแสดงค่าเฉลี่ยและข้อความแนะนำ Rule-based Coaching Text
5. ระบบแสดงรายการการ์ดรายวัน 7 วัน โดย Day 0 (วันปัจจุบัน) จะอยู่บนสุดและอยู่ในสถานะเปิดขยาย (Expanded = true) ส่วน Day -1 ถึง Day -6 จะอยู่ในสถานะพับเก็บ (Collapsed = false)
6. ผู้ใช้สามารถแตะที่การ์ดรายวันอื่นๆ เพื่อพับหรือขยายดูรายละเอียดกิจกรรม (การเดิน, การดื่มน้ำ, แคลอรี) ของวันนั้นๆ ได้ตามต้องการ

## 4. สถานะของหน้าจอ

| หน้าจอ | สถานะ | เงื่อนไขที่ทำให้เกิด | สิ่งที่แสดง |
|---|---|---|---|
| S-1 | NORMAL (ปกติ) | ผู้ใช้มีข้อมูลการบันทึกครบถ้วนหรือบางส่วนในรอบ 7 วัน | แสดง SUMMARY_CARD คำนวณค่าเฉลี่ยปกติ และแสดง DAY_CARD เรียง 7 วันโดย Day 0 อยู่บนสุดและ Expanded ส่วนวันอื่น Collapsed |
| S-1 | INCONSISTENT (บันทึกไม่สม่ำเสมอ) | ผู้ใช้มีข้อมูลการบันทึกไม่ครบ 7 วัน (Count < 7 แต่ > 0) | แสดงข้อความเตือน `"มีการบันทึกไม่สม่ำเสมอ จากข้อมูลการบันทึกเท่าที่มีพบว่า..."` ใน SUMMARY_CARD พร้อมคำนวณค่าเฉลี่ยเฉพาะวันที่มียอดบันทึก |
| S-1 | EMPTY (ว่าง) | ไม่มีข้อมูลการบันทึกเลยสักวันในรอบ 7 วัน (Completely Empty History) | SUMMARY_CARD ซ่อนหรือแสดงค่า 0 และแสดง EMPTY_STATE_CONTAINER พร้อมข้อความ `"ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้"` |
| S-1 | OFFLINE (ออฟไลน์) | ไม่มีสัญญาณอินเทอร์เน็ตระหว่างเปิดหน้าจอ | ระบบดึงข้อมูลจาก Local Cache มาแสดงผลตามปกติโดยไม่แสดง Error Dialog |

## 5. ไฟล์ภาพ assets

| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายภาพ |
|---|---|---|
| `assets/images/7day/summary_card_bg.png` | S-1 (SUMMARY_CARD) | พื้นหลังการ์ดสรุปภาพรวมสไตล์ Minimal โทนสีพาสเทลอุ่น |
| `assets/images/7day/card_expanded_icon.png` | S-1 (DAY_CARD - Expanded) | ไอคอนลูกศรชี้ขึ้นแสดงสถานะกำลังขยายการ์ดรายวัน |
| `assets/images/7day/card_collapsed_icon.png` | S-1 (DAY_CARD - Collapsed) | ไอคอนลูกศรชี้ลงแสดงสถานะการ์ดรายวันที่ถูกพับเก็บไว้ |
| `assets/images/7day/empty_history_illustration.png` | S-1 (EMPTY_STATE_CONTAINER) | ภาพกราฟิกไอคอนกล่องเปล่า Minimal สื่อถึงยังไม่มีประวัติการบันทึกในรอบ 7 วัน (ไม่มีตัวละครสัตว์เลี้ยงตาม Out of scope) |

## 6. คำถามถึง Product

1. ข้อเสนอแนะจาก Design: ทีม Design แนะนำให้ใช้ขอบเขต Accordion Component แบบมาตรฐานที่มี Animation ความเร็ว 250ms ในการพับ/ขยายการ์ดรายวัน เพื่อให้รองรับหน้าจอขนาดเล็ก (Compact Screen) ได้ไหลลื่นและไม่กินพื้นที่
   - กติกาชั่วคราว (Fallback Rule): หากระบบ Accordion มีข้อจำกัดทางเทคนิค ให้ใช้การเปิด/ปิดแบบท็อกเกิลทันที (Instant Toggle) โดยไม่มี Animation ซับซ้อน เพื่อให้ Dev พัฒนาต่อได้ทันที
   - การประเมินสถานะการบล็อก: Blocking: ไม่ใช่ (เนื่องจากมี Fallback ชัดเจน)

2. ข้อเสนอแนะจาก Design: สำหรับนโยบาย Cache Size สูงสุดในกรณี Offline นานเกิน 7 วัน แนะนำให้จำกัดการจัดเก็บ Local Cache ไว้ที่ 30 วันล่าสุด (Rolling 30-Day Window) เพื่อประหยัดพื้นที่จัดเก็บในเครื่องผู้ใช้
   - กติกาชั่วคราว (Fallback Rule): ให้ระบบเก็บบันทึกย้อนหลังใน Local Cache สูงสุด 30 วันแรกพ้นจากนั้นให้ลบข้อมูลเก่าทิ้งอัตโนมัติ (FIFO - First In, First Out)
   - การประเมินสถานะการบล็อก: Blocking: ไม่ใช่ (อยู่นอกเหนือ Scope หลักของ 7 วัน แต่กำหนด Fallback รองรับไว้แล้ว)

=== จบ docs/7day/ux-flow.md ===

=== docs/7day/game-rules.md ===
# กติกาเกม: ประวัติสุขภาพ 7 วัน (7day)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: Senior BA · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ความหมาย | ค่า | หน่วย / ชนิด | อ้างถึง |
|---|---|---|---|---|
| `MAX_HISTORY_DAYS` | จำนวนวันสูงสุดในประวัติที่แสดงผล | 7 | วัน (Integer) | AC-1 |
| `DATE_NORMALIZER_HOUR` | เวลาตัดรอบประจำวันตาม Date Normalizer (ICT) | 5 | นาฬิกา (Integer) | US-3, EC-4 |
| `WATER_GOAL_THRESHOLD` | เกณฑ์มาตรฐานค่าเฉลี่ยน้ำดื่มสำหรับการแสดงข้อความแนะนำ | 8.0 | แก้ว (Float 1 ตำแหน่ง) | AC-4 |
| `STEPS_GOAL_THRESHOLD` | เกณฑ์มาตรฐานค่าเฉลี่ยการเดินสำหรับการแสดงข้อความแนะนำ | 8000.0 | ก้าว (Float 1 ตำแหน่ง) | AC-5 |
| `LOCAL_CACHE_RETENTION_DAYS` | จำนวนวันสูงสุดในการจัดเก็บข้อมูลใน Local Cache (Rolling Window) | 30 | วัน (Integer) | EC-5 |

### 1.1 ตารางข้อความแนะนำตามเกณฑ์ (Rule-based Coaching Text Table)

| รหัสเงื่อนไข (Condition Code) | เกณฑ์การตรวจสอบ | ข้อความแนะนำที่แสดงผล (Exact String) | อ้างถึง |
|---|---|---|---|
| `PREFIX_INCONSISTENT` | บันทึกไม่ครบ 7 วัน (`0 < count < 7`) | `"มีการบันทึกไม่สม่ำเสมอ จากข้อมูลการบันทึกเท่าที่มีพบว่า..."` (แสดงเป็นคำนำหน้าข้อความแนะนำ) | AC-3 |
| `WARNING_LOW_WATER` | ค่าเฉลี่ยน้ำดื่ม < 8.0 แก้ว (`avg_water < 8.0`) | `"ดื่มน้ำเฉลี่ยวันละ {val} แก้ว น้อยไปน้า พยายามกินน้ำมากกว่านี้ แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ"` | AC-4 |
| `WARNING_LOW_STEPS` | ค่าเฉลี่ยการเดิน < 8,000 ก้าว (`avg_steps < 8000.0`) | `"เดินเฉลี่ยวันละ {val} ก้าว ขยับอีกนิดน้าเพื่อสุขภาพที่แข็งแรง แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ"` | AC-5 |
| `STATUS_EMPTY_7DAYS` | ไม่มีข้อมูลการบันทึกตลอด 7 วัน (`count == 0`) | `"ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้"` | AC-6 |
| `STATUS_NO_DAILY_DATA` | วันใดวันหนึ่งในการ์ดรายวันไม่มีข้อมูล | `"ไม่มีข้อมูล"` (แสดงบนการ์ดรายวันของวันนั้น และไม่นับเป็นตัวหารเฉลี่ย) | AC-2 |

*หมายเหตุ Coaching Text:*
- กรณีมีคำนำหน้า `PREFIX_INCONSISTENT` ให้วางไว้หน้าข้อความแนะนำเสมอ เช่น `"มีการบันทึกไม่สม่ำเสมอ จากข้อมูลการบันทึกเท่าที่มีพบว่า... ดื่มน้ำเฉลี่ยวันละ 6.5 แก้ว..."`
- หากเข้าเกณฑ์เตือนทั้งค่าน้ำดื่มต่ำ (`WARNING_LOW_WATER`) และการเดินต่ำ (`WARNING_LOW_STEPS`) ให้แสดงข้อความเตือนเรียงต่อกันเป็นคนละบรรทัด โดยค่าน้ำขึ้นก่อนแล้วตามด้วยก้าวเดิน เพื่อให้อ่านง่ายและชัดเจนบน UI

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง
*(หมายเหตุ: อ้างอิงจาก Out of scope ของฟีเจอร์ 7day ว่าไม่มีการแสดงผลตัวละครสัตว์เลี้ยงในหน้าประวัติ 7 วันนี้ จึงไม่มีสถานะหรืออารมณ์สัตว์เลี้ยงเฉพาะในหน้านี้)*

| สถานะ | ช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพ |
|---|---|---|
| N/A | N/A | N/A |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| คำนวณค่าเฉลี่ยน้ำดื่มจาก 3 วัน (7.0, 8.0, 9.0 แก้ว) | Count = 3, Sum = 24.0 | Average = 8.0 แก้ว | แสดงผลทศนิยม 1 ตำแหน่ง อ้างอิง AC-3 |
| คำนวณค่าเฉลี่ยการเดินจาก 2 วัน (5000, 6000 ก้าว) | Count = 2, Sum = 11000 | Average = 5500.0 ก้าว | แสดงผลทศนิยม 1 ตำแหน่ง อ้างอิง AC-3 |
| วันที่ไม่มีข้อมูลการบันทึกในรอบ 7 วัน | ยอดบันทึกดิบ = null | แสดงข้อความ `"ไม่มีข้อมูล"` และไม่นำ Count ไปหาร | อ้างอิง AC-2 |
| เปิดหน้าจอโดยไม่มีข้อมูลเลยตลอด 7 วัน | Sum = 0, Count = 0 | แสดงข้อความ `"ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้"` | อ้างอิง AC-6 |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ที่ทดสอบได้ |
|---|---|
| ผู้ใช้มีข้อมูลไม่ครบ 7 วัน (New / Inconsistent Users) | ระบบคำนวณค่าเฉลี่ยโดยหารเฉพาะจำนวนวันที่มีการบันทึกจริง ($\sum(\text{Values}) / \text{Count}$) แสดงผลทศนิยม 1 ตำแหน่ง พร้อมแสดงป้ายเตือน `"มีการบันทึกไม่สม่ำเสมอ จากข้อมูลการบันทึกเท่าที่มีพบว่า..."` |
| วันที่ไม่มีข้อมูลบันทึกเลย (Missing Data Days) | การ์ดรายวัน (DAY_CARD) ของวันนั้นจะแสดงข้อความ `"ไม่มีข้อมูล"` และระบบจะไม่นำไปคำนวณรวมในยอด sum และ count ของค่าเฉลี่ย |
| ไม่มีข้อมูลเลยตลอด 7 วัน (Completely Empty History) | หน้าจอซ่อนค่าสรุปหรือแสดงค่า 0 และแสดง EMPTY_STATE_CONTAINER พร้อมข้อความ `"ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้"` |
| ผู้ใช้เปิดหน้าจอค้างไว้ข้ามเวลา 05:00 น. (ICT) (Date Transition at 05:00 ICT) | ระบบทำการ Normalize วันใหม่โดยอิงรอบ 05:00 น. ทันที, รีเฟรช Card รายวัน และสลับเปิด Card วันปัจจุบันอันใหม่ให้อยู่บนสุดและถูก Expanded อัตโนมัติ (`expanded = true`) |
| ไม่มีสัญญาณอินเทอร์เน็ต (Offline Cache) | ระบบดึงข้อมูลประวัติ 7 วันจาก Local Cache มาแสดงผลในรูปแบบ Collapsible Card ได้ปกติโดยไม่เกิด Error Dialog |

## 5. คำถามถึง Product

1. **ข้อเสนอแนะจาก Design:** ทีม Design แนะนำให้ใช้ขอบเขต Accordion Component แบบมาตรฐานที่มี Animation ความเร็ว 250ms ในการพับ/ขยายการ์ดรายวัน เพื่อให้รองรับหน้าจอขนาดเล็ก (Compact Screen) ได้ไหลลื่น
   - *กติกาชั่วคราว (Fallback Rule):* หากระบบ Accordion มีข้อจำกัดทางเทคนิค ให้ใช้การเปิด/ปิดแบบท็อกเกิลทันที (Instant Toggle) โดยไม่มี Animation ซับซ้อน เพื่อให้ Dev พัฒนาต่อได้ทันที
   - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่
2. **ข้อเสนอแนะจาก Design:** สำหรับนโยบาย Cache Size สูงสุดในกรณี Offline นานเกิน 7 วัน แนะนำให้จำกัดการจัดเก็บ Local Cache ไว้ที่ 30 วันล่าสุด (Rolling 30-Day Window) เพื่อประหยัดพื้นที่จัดเก็บในเครื่องผู้ใช้
   - *กติกาชั่วคราว (Fallback Rule):* ให้ระบบเก็บบันทึกย้อนหลังใน Local Cache สูงสุด 30 วันแรกพ้นจากนั้นให้ลบข้อมูลเก่าทิ้งอัตโนมัติ (FIFO - First In, First Out)
   - *การประเมินสถานะการบล็อก:* Blocking: ไม่ใช่

=== จบ docs/7day/game-rules.md ===

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

This is the expected criteria for your final answer: เนื้อหาไฟล์ docs/7day/design-review.md ฉบับสมบูรณ์ ตามโครง template
you MUST return the actual complete content as the final answer, not a summary.

Provide your complete response:
~~~~

### LLM call 1 — คำตอบ

~~~~text
# Design Review: 7day

## 1. ข้อมูลการตรวจ
- Status: NEEDS_FIX
- Feature: 7day
- Documents actually reviewed: docs/7day/requirements.md, docs/7day/ux-flow.md, docs/7day/game-rules.md
- Missing/unreadable documents: ไม่มี
- Previous findings checked: ไม่มีข้อมูลรอบก่อน

## 2. ผล Checklist

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | PASS | เอกสาร Requirements มี User stories, Acceptance criteria ครอบคลุมการคำนวณและ Edge cases ชัดเจน อ้างอิงจาก `docs/7day/requirements.md` (หัวข้อ 2, 3, 4) | ไม่ใช่ - โครงสร้างข้อกำหนดครบถ้วน |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | PASS | ข้อมูลการแสดงผล การคำนวณ และเงื่อนไขใน Requirements, UX Flow และ Game Rules สอดคล้องกัน อ้างอิงจาก `docs/7day/requirements.md`, `docs/7day/ux-flow.md`, `docs/7day/game-rules.md` | ไม่ใช่ - เอกสารหลักมีความสอดคล้องกันดี |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | PASS | ค่าคงที่และเกณฑ์ต่างๆ เช่น `MAX_HISTORY_DAYS` (7), `DATE_NORMALIZER_HOUR` (5), `WATER_GOAL_THRESHOLD` (8.0), `STEPS_GOAL_THRESHOLD` (8000.0) ตรงกันทุกไฟล์ อ้างอิงจาก `docs/7day/game-rules.md` และ `docs/7day/requirements.md` | ไม่ใช่ - ชื่อและตัวเลขตรงกัน |
| C-04 | ขั้นตอนใช้งานและEdge Cases เพียงพอ | PASS | UX Flow ระบุขั้นตอนการใช้งาน Happy Path ชัดเจน และมี Edge Cases ครอบคลุมกรณีข้อมูลไม่ครบ ข้ามวัน และ Offline อ้างอิงจาก `docs/7day/ux-flow.md` (หัวข้อ 3, 4) และ `docs/7day/requirements.md` (หัวข้อ 4) | ไม่ใช่ - ขั้นตอนและ Edge Cases เพียงพอ |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | FAIL | Open Questions ใน Requirements ยังไม่มีข้อสรุปชัดเจนเรื่อง UI Component สำหรับ Collapsible Card และนโยบาย Cache Size (ถึงแม้ UX Flow/Game Rules จะระบุ Fallback แต่ใน Requirements ยังค้างอยู่) อ้างอิงจาก `docs/7day/requirements.md` (หัวข้อ 7) | ใช่ - ต้องให้ Product Owner ตัดสินใจเรื่อง Open Questions ให้เรียบร้อยใน Requirements |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ข้อค้นพบและตารางทั้งหมดอ้างอิงตำแหน่งและหัวข้อจากเอกสารต้นทางได้อย่างแม่นยำ | ไม่ใช่ - มีหลักฐานอ้างอิงชัดเจนทุกจุด |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | บทสรุป ตารางปัญหา และคำแนะนำมีความสอดคล้องกับสถานะ NEEDS_FIX และ Open Questions ที่ค้างอยู่ | ไม่ใช่ - สอดคล้องกันทุกส่วน |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีรายงานผลการรีวิวกรอบก่อนหน้าให้เปรียบเทียบ อ้างอิงจากประวัติการตรวจ | ไม่ใช่ - ไม่มีข้อมูลรอบก่อนให้ตรวจสอบ |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|
| OQ-01 | docs/7day/requirements.md | 7. คำถามที่ยังเปิดอยู่ | Open Question เรื่อง UI Component ที่ใช้ทำ Collapsible Card ยังไม่มีข้อสรุปใน Requirements (แม้ UX Flow จะมี Fallback แล้วก็ตาม) อ้างอิง: `docs/7day/requirements.md` หัวข้อ 7 | อาจทำให้ทีมพัฒนาเลือกใช้งาน Component ไม่ตรงกับมาตรฐานผลิตภัณฑ์ที่ Product Owner ต้องการ | ยังตัดสินไม่ได้ | Product Owner ควรระบุข้อสรุปในเอกสาร Requirements ว่าจะใช้ Component ตัวใด | ใช่ - Product Owner ต้องสรุปผล |
| OQ-02 | docs/7day/requirements.md | 7. คำถามที่ยังเปิดอยู่ | Open Question เรื่องนโยบายจัดการ Cache Size สูงสุดกรณี Offline เกิน 7 วัน ยังไม่มีข้อสรุปใน Requirements (แม้ UX Flow/Game Rules จะระบุ FIFO 30 วันแล้วก็ตาม) อ้างอิง: `docs/7day/requirements.md` หัวข้อ 7 | ขาดความชัดเจนทางนโยบายข้อมูลระดับ Requirements | ยังตัดสินไม่ได้ | Product Owner ควรยืนยันนโยบาย Rolling 30-Day Window และ FIFO ลงใน Requirements | ใช่ - Product Owner ต้องสรุปผล |

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|
| N/A | ไม่มีข้อมูลรอบก่อน | ไม่มีข้อมูลสำหรับเปรียบเทียบ | ไม่มีรายงานการรีวิวก่อนหน้าในระบบ | ข้ามการตรวจรอบก่อนเนื่องจากไม่มีเอกสารอ้างอิง |

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- OQ-01: ทีม Design จะใช้ Component UI ตัวใดในการทำ Collapsible Card ให้รองรับหน้าจอขนาดเล็กได้ดีที่สุด (`docs/7day/requirements.md` หัวข้อ 7) - ยังไม่มีการสรุปใน Requirements แต่อ้างอิง Fallback ใน UX Flow/Game Rules ว่าใช้ Instant Toggle ได้หากมีข้อจำกัด - Blocking: ยังตัดสินไม่ได้ - ต้องการการตัดสินใจจาก Product Owner
- OQ-02: การจัดการ Cache Size สูงสุดในกรณีที่ผู้ใช้ Offline เป็นเวลานานเกิน 7 วัน จะกำหนดนโยบายอย่างไร (`docs/7day/requirements.md` หัวข้อ 7) - ยังไม่มีการสรุปใน Requirements แต่อ้างอิง Fallback ใน UX Flow/Game Rules ว่าให้ใช้ Rolling 30-Day Window และ FIFO - Blocking: ยังตัดสินไม่ได้ - ต้องการการตัดสินใจจาก Product Owner

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)

ไม่มีข้อมูลใน log ที่ได้รับ

## 7. ข้อจำกัดของการรีวิว
- ตรวจสอบเฉพาะเอกสาร Requirements (`docs/7day/requirements.md`), UX Flow (`docs/7day/ux-flow.md`) และ Game Rules (`docs/7day/game-rules.md`) ที่ได้รับเท่านั้น
- ไม่มีข้อมูลรายงานการรีวิวกรอบก่อนหน้า (Previous Review Report) จึงไม่สามารถทำ Regression Comparison ได้

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: NEEDS_FIX
- Agent recommendation: ต้องแก้
- Blocking issues remaining: OQ-01, OQ-02 (Open Questions ในเอกสาร Requirements ยังไม่ถูกปิดให้สมบูรณ์ แม้ UX Flow และ Game Rules จะมีข้อยกเว้น/Fallback รองรับแล้วก็ตาม)
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: ผลการตรวจสอบพบว่าเอกสารมีความครบถ้วน สอดคล้อง และมีตารางเงื่อนไขที่ชัดเจนดีมาก แต่ยังมีข้อคำถามที่ยังเปิดอยู่ (Open Questions) ในเอกสาร `requirements.md` ที่ยังไม่ได้รับการบันทึกข้อสรุปอย่างเป็นทางการ จึงต้องให้ Product Owner ทำการอัปเดตและปิดประเด็นดังกล่าวก่อนส่งมอบให้ทีมพัฒนา (Dev) ต่อไป
~~~~

### ผลลัพธ์ → docs/7day/design-review.md

~~~~text
# Design Review: 7day

## 1. ข้อมูลการตรวจ
- Status: NEEDS_FIX
- Feature: 7day
- Documents actually reviewed: docs/7day/requirements.md, docs/7day/ux-flow.md, docs/7day/game-rules.md
- Missing/unreadable documents: ไม่มี
- Previous findings checked: ไม่มีข้อมูลรอบก่อน

## 2. ผล Checklist

| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | PASS | เอกสาร Requirements มี User stories, Acceptance criteria ครอบคลุมการคำนวณและ Edge cases ชัดเจน อ้างอิงจาก `docs/7day/requirements.md` (หัวข้อ 2, 3, 4) | ไม่ใช่ - โครงสร้างข้อกำหนดครบถ้วน |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | PASS | ข้อมูลการแสดงผล การคำนวณ และเงื่อนไขใน Requirements, UX Flow และ Game Rules สอดคล้องกัน อ้างอิงจาก `docs/7day/requirements.md`, `docs/7day/ux-flow.md`, `docs/7day/game-rules.md` | ไม่ใช่ - เอกสารหลักมีความสอดคล้องกันดี |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | PASS | ค่าคงที่และเกณฑ์ต่างๆ เช่น `MAX_HISTORY_DAYS` (7), `DATE_NORMALIZER_HOUR` (5), `WATER_GOAL_THRESHOLD` (8.0), `STEPS_GOAL_THRESHOLD` (8000.0) ตรงกันทุกไฟล์ อ้างอิงจาก `docs/7day/game-rules.md` และ `docs/7day/requirements.md` | ไม่ใช่ - ชื่อและตัวเลขตรงกัน |
| C-04 | ขั้นตอนใช้งานและEdge Cases เพียงพอ | PASS | UX Flow ระบุขั้นตอนการใช้งาน Happy Path ชัดเจน และมี Edge Cases ครอบคลุมกรณีข้อมูลไม่ครบ ข้ามวัน และ Offline อ้างอิงจาก `docs/7day/ux-flow.md` (หัวข้อ 3, 4) และ `docs/7day/requirements.md` (หัวข้อ 4) | ไม่ใช่ - ขั้นตอนและ Edge Cases เพียงพอ |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | FAIL | Open Questions ใน Requirements ยังไม่มีข้อสรุปชัดเจนเรื่อง UI Component สำหรับ Collapsible Card และนโยบาย Cache Size (ถึงแม้ UX Flow/Game Rules จะระบุ Fallback แต่ใน Requirements ยังค้างอยู่) อ้างอิงจาก `docs/7day/requirements.md` (หัวข้อ 7) | ใช่ - ต้องให้ Product Owner ตัดสินใจเรื่อง Open Questions ให้เรียบร้อยใน Requirements |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ข้อค้นพบและตารางทั้งหมดอ้างอิงตำแหน่งและหัวข้อจากเอกสารต้นทางได้อย่างแม่นยำ | ไม่ใช่ - มีหลักฐานอ้างอิงชัดเจนทุกจุด |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | บทสรุป ตารางปัญหา และคำแนะนำมีความสอดคล้องกับสถานะ NEEDS_FIX และ Open Questions ที่ค้างอยู่ | ไม่ใช่ - สอดคล้องกันทุกส่วน |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีรายงานผลการรีวิวกรอบก่อนหน้าให้เปรียบเทียบ อ้างอิงจากประวัติการตรวจ | ไม่ใช่ - ไม่มีข้อมูลรอบก่อนให้ตรวจสอบ |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|
| OQ-01 | docs/7day/requirements.md | 7. คำถามที่ยังเปิดอยู่ | Open Question เรื่อง UI Component ที่ใช้ทำ Collapsible Card ยังไม่มีข้อสรุปใน Requirements (แม้ UX Flow จะมี Fallback แล้วก็ตาม) อ้างอิง: `docs/7day/requirements.md` หัวข้อ 7 | อาจทำให้ทีมพัฒนาเลือกใช้งาน Component ไม่ตรงกับมาตรฐานผลิตภัณฑ์ที่ Product Owner ต้องการ | ยังตัดสินไม่ได้ | Product Owner ควรระบุข้อสรุปในเอกสาร Requirements ว่าจะใช้ Component ตัวใด | ใช่ - Product Owner ต้องสรุปผล |
| OQ-02 | docs/7day/requirements.md | 7. คำถามที่ยังเปิดอยู่ | Open Question เรื่องนโยบายจัดการ Cache Size สูงสุดกรณี Offline เกิน 7 วัน ยังไม่มีข้อสรุปใน Requirements (แม้ UX Flow/Game Rules จะระบุ FIFO 30 วันแล้วก็ตาม) อ้างอิง: `docs/7day/requirements.md` หัวข้อ 7 | ขาดความชัดเจนทางนโยบายข้อมูลระดับ Requirements | ยังตัดสินไม่ได้ | Product Owner ควรยืนยันนโยบาย Rolling 30-Day Window และ FIFO ลงใน Requirements | ใช่ - Product Owner ต้องสรุปผล |

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|
| N/A | ไม่มีข้อมูลรอบก่อน | ไม่มีข้อมูลสำหรับเปรียบเทียบ | ไม่มีรายงานการรีวิวก่อนหน้าในระบบ | ข้ามการตรวจรอบก่อนเนื่องจากไม่มีเอกสารอ้างอิง |

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- OQ-01: ทีม Design จะใช้ Component UI ตัวใดในการทำ Collapsible Card ให้รองรับหน้าจอขนาดเล็กได้ดีที่สุด (`docs/7day/requirements.md` หัวข้อ 7) - ยังไม่มีการสรุปใน Requirements แต่อ้างอิง Fallback ใน UX Flow/Game Rules ว่าใช้ Instant Toggle ได้หากมีข้อจำกัด - Blocking: ยังตัดสินไม่ได้ - ต้องการการตัดสินใจจาก Product Owner
- OQ-02: การจัดการ Cache Size สูงสุดในกรณีที่ผู้ใช้ Offline เป็นเวลานานเกิน 7 วัน จะกำหนดนโยบายอย่างไร (`docs/7day/requirements.md` หัวข้อ 7) - ยังไม่มีการสรุปใน Requirements แต่อ้างอิง Fallback ใน UX Flow/Game Rules ว่าให้ใช้ Rolling 30-Day Window และ FIFO - Blocking: ยังตัดสินไม่ได้ - ต้องการการตัดสินใจจาก Product Owner

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)

ไม่มีข้อมูลใน log ที่ได้รับ

## 7. ข้อจำกัดของการรีวิว
- ตรวจสอบเฉพาะเอกสาร Requirements (`docs/7day/requirements.md`), UX Flow (`docs/7day/ux-flow.md`) และ Game Rules (`docs/7day/game-rules.md`) ที่ได้รับเท่านั้น
- ไม่มีข้อมูลรายงานการรีวิวกรอบก่อนหน้า (Previous Review Report) จึงไม่สามารถทำ Regression Comparison ได้

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: NEEDS_FIX
- Agent recommendation: ต้องแก้
- Blocking issues remaining: OQ-01, OQ-02 (Open Questions ในเอกสาร Requirements ยังไม่ถูกปิดให้สมบูรณ์ แม้ UX Flow และ Game Rules จะมีข้อยกเว้น/Fallback รองรับแล้วก็ตาม)
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: ผลการตรวจสอบพบว่าเอกสารมีความครบถ้วน สอดคล้อง และมีตารางเงื่อนไขที่ชัดเจนดีมาก แต่ยังมีข้อคำถามที่ยังเปิดอยู่ (Open Questions) ในเอกสาร `requirements.md` ที่ยังไม่ได้รับการบันทึกข้อสรุปอย่างเป็นทางการ จึงต้องให้ Product Owner ทำการอัปเดตและปิดประเด็นดังกล่าวก่อนส่งมอบให้ทีมพัฒนา (Dev) ต่อไป
~~~~
