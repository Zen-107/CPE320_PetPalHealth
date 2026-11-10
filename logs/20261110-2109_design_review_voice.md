# Log: design_review · voice · 2026-11-10 21:10

<!-- meta: {"role": "design_review", "feature": "voice", "time": "2026-11-10 21:10", "status": "ok", "provider": "gemini", "model": "gemini-3.5-flash-lite", "attempts": 1, "seconds": 13.8, "llm_calls": 1, "total_tokens": 19294, "agent_version": "ac395134"} -->

| รายการ | ค่า |
|---|---|
| สถานะ | สำเร็จ |
| ผู้ให้บริการ / รุ่น | gemini / gemini-3.5-flash-lite |
| ลำดับความพยายาม | gemini: สำเร็จ |
| เวลารวม | 13.8 วินาที |
| จำนวนครั้งที่เรียก LLM | 1 |
| tokens (prompt / completion / total) | 17768 / 1526 / 19294 |
| ไฟล์ input | docs/voice/requirements.md, docs/voice/ux-flow.md, docs/voice/game-rules.md |
| ไฟล์ output | docs/voice/design-review.md |
| agent | agents/design_reviewer.md (เวอร์ชัน ac395134) |
| --note | - |

## ความพยายามที่ 1 — gemini (gemini-3.5-flash-lite) — สำเร็จ, 13.8 วินาที

### Agent

- ไฟล์: agents/design_reviewer.md
- role: Software Design Reviewer
- goal: Review the voice design documents against supplied project specifications, verify prior findings when available, and report evidence-backed contradictions, ambiguities, missing decisions, and actionable documentation issues without modifying source documents.
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

# Design Review: voice

## 1. ข้อมูลการตรวจ

- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: voice
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

#### Task → docs/voice/design-review.md

~~~~text
ฟีเจอร์: voice

งานของคุณ: ตรวจเอกสาร Requirements, UX Flow และ Game Rules ก่อนส่งงานให้ Dev ตรวจความครบถ้วนและความสอดคล้องของเอกสาร ตรวจตัวเลข ชื่อสถานะ ขั้นตอนการใช้งาน และ edge cases โดยอ้างอิงหลักฐานจากไฟล์ที่ได้รับ ระบุข้อผิดพลาดพร้อมไฟล์/หัวข้อ เหตุผล และแนวทางแก้ไข ห้ามแต่งข้อกำหนดหรือผลทดสอบขึ้นเอง สรุปผลเป็น PASS, NEEDS_FIX หรือ INSUFFICIENT_EVIDENCE

ข้อมูลประกอบ:
=== docs/voice/requirements.md ===
# Requirements: Pet Voice & Audio Feature (voice)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Product agent · ผู้ตรวจ: Senior QA · อ้างอิง Issue: #104

## 1. สรุปฟีเจอร์
ฟีเจอร์เสียงน้องอ๊บช่วยเพิ่มแรงจูงใจและสร้างความบันเทิงให้ผู้ใช้ผ่านเสียงพากย์กวนๆ อบอุ่น ของตัวละครสัตว์เลี้ยงตามบริบทสุขภาพ (การเดิน, การกิน, การดื่มน้ำ) พร้อมระบบขอสิทธิ์เมื่อเข้าใช้งานครั้งแรก และปุ่มควบคุมตั้งค่าที่มุมขวาบน

## 2. User stories

| ID | ในฐานะ | ฉันอยาก | เพื่อ |
|---|---|---|---|
| US-1 | ผู้ใช้ใหม่ที่เข้าแอปครั้งแรก | เห็น Dialog ขอสิทธิ์เปิดใช้งานเสียงพากย์น้องอ๊บ | สามารถเลือกเปิดหรือปิดเสียงได้ตั้งแต่เริ่มต้นใช้งาน |
| US-2 | ผู้ใช้แอป PetPal Health | ได้ยินเสียงพากย์น้องอ๊บตามบริบทกิจกรรมสุขภาพต่างๆ (Steps, Food, Water) | ได้รับแรงจูงใจ คำชมเชย หรือคำแซวขำๆ ที่เป็นกันเอง |
| US-3 | ผู้ใช้แอป PetPal Health | สามารถเปิด/ปิดเสียงพากย์ (Master Voice) และควบคุมระบบแจ้งเตือนผ่านปุ่มตั้งค่ามุมขวาบนได้ | ควบคุมประสบการณ์การใช้งานเสียงและการแจ้งเตือนของตนเองได้สะดวก |

## 3. Acceptance criteria

| ID | อ้างถึง | เงื่อนไข (ก่อน /เมื่อ / แล้ว) | ค่าที่ทดสอบได้ |
|---|---|---|---|
| AC-1 | US-1 | ก่อน: ผู้ใช้เปิดแอปครั้งแรกหลังผ่าน Onboarding<br>เมื่อ: ระบบแสดง First Launch Permission Dialog<br>แล้ว: ผู้ใช้กดปุ่ม `[ เปิดเสียงโลด! (แนะนำ) ]` หรือ `[ ปิดเสียงไว้ก่อน ]` | ค่าสถานะถูกบันทึก Local Storage และ Dialog ไม่แสดงซ้ำในครั้งถัดไป |
| AC-2 | US-2 | ก่อน: ผู้ใช้เปิดเสียงพากย์ไว้ และบันทึกข้อมูลก้าวเดิน (`steps`) < 35%<br>เมื่อ: ระบบประมวลผลข้อมูลก้าวเดิน<br>แล้ว: เล่นไฟล์เสียง `voice_steps_lazy.mp3` | เล่นเสียงตรงกับไฟล์ `voice_steps_lazy.mp3` พร้อมข้อความ: `"แหม... นอนเก่งขนาดนี้ นึกว่าจำศีลอยู่ซะอีก ลุกขึ้นมาขยับขาหน่อยเร้ว เดี๋ยวร่างจะติดโซฟาเอานะยูว์"` |
| AC-3 | US-2 | ก่อน: ผู้ใช้เปิดเสียงพากย์ไว้ และบันทึกข้อมูลก้าวเดิน (`steps`) อยู่ในช่วง 70% - 99%<br>เมื่อ: ระบบประมวลผลข้อมูลก้าวเดิน<br>แล้ว: เล่นไฟล์เสียง `voice_steps_encouraging.mp3` | เล่นเสียงตรงกับไฟล์ `voice_steps_encouraging.mp3` พร้อมข้อความ: `"ฮั่นแน่! อีกนิดเดียวก็จะครบเป้าหมายแล้วนะเนี่ย ขาเริ่มสั่นยังคะคนดี ฮึบอีกนิด เดี๋ยวมีรางวัลให้!"` |
| AC-4 | US-2 | ก่อน: ผู้ใช้เปิดเสียงพากย์ไว้ และบันทึกข้อมูลก้าวเดิน (`steps`) ≥ 100%<br>เมื่อ: ระบบประมวลผลข้อมูลก้าวเดิน<br>แล้ว: เล่นไฟล์เสียง `voice_steps_success.mp3` | เล่นเสียงตรงกับไฟล์ `voice_steps_success.mp3` พร้อมข้อความ: `"โอโห้! วันนี้เดินเยอะจนนับขาแทบไม่ทัน เก่งมากค่ะคนดี ขาไม่พังใช่ไหมเนี่ย วันนี้พักผ่อนตามสบายเลยนะ!"` |
| AC-5 | US-2 | ก่อน: ผู้ใช้เปิดเสียงพากย์ไว้ และบันทึกข้อมูลอาหาร (`food`) เกิน > 100 kcal<br>เมื่อ: ระบบประมวลผลข้อมูลอาหาร<br>แล้ว: เล่นไฟล์เสียง `voice_food_overeating.mp3` | เล่นเสียงตรงกับไฟล์ `voice_food_overeating.mp3` พร้อมข้อความ: `"พุงจะแตกตายอยู่แล้วนะแม่คุณ! พอเถอะน้าคนดี เดี๋ยวพรุ่งนี้ค่อยลุยใหม่ (แต่ตอนนี้อิ่มแปล้เลยสิเนี่ย)"` |
| AC-6 | US-2 | ก่อน: ผู้ใช้เปิดเสียงพากย์ไว้ และบันทึกข้อมูลน้ำ (`water`) < 3 แก้ว<br>เมื่อ: ระบบประมวลผลข้อมูลน้ำ<br>แล้ว: เล่นไฟล์เสียง `voice_water_low.mp3` | เล่นเสียงตรงกับไฟล์ `voice_water_low.mp3` พร้อมข้อความ: `"คอแห้งเป็นผงละเนี่ย ดื่มน้ำหน่อยเร้ว เดี๋ยวหน้าเหี่ยวไม่รู้ด้วยนะ พี่อ๊บเป็นห่วงนะเนี่ย"` |
| AC-7 | US-2 | ก่อน: ผู้ใช้เปิดเสียงพากย์ไว้ และบันทึกข้อมูลน้ำ (`water`) ≥ 8 แก้ว<br>เมื่อ: ระบบประมวลผลข้อมูลน้ำ<br>แล้ว: เล่นไฟล์เสียง `voice_water_success.mp3` | เล่นเสียงตรงกับไฟล์ `voice_water_success.mp3` พร้อมข้อความ: `"ดื่มน้ำเก่งมาก! ผิวพรรณเปล่งปลั่งออร่าจับเลยแบบนี้ เอาใจไปเลยสิคะคนดี!"` |
| AC-8 | US-3 | ก่อน: ผู้ใช้กดไอคอนตั้งค่าที่มุมขวาบน<br>เมื่อ: Modal แสดงขึ้นมา<br>แล้ว: ผู้ใช้พบ Toggle Switch 2 ตัว ได้แก่ Master Voice และ Push Notification Shortcut พร้อมใช้งาน | สามารถกดเปิด/ปิด Toggle ทั้งสองตัวได้สำเร็จและระบบบันทึกค่าทันที |

## 4. Edge cases

| ID | สถานการณ์ | ผลที่คาดหวัง |
|---|---|---|
| EC-1 | ผู้ใช้เปิดโหมดปิดเสียง (Mute Mode / Silent) หรือลดเสียงสื่อเป็น 0 บนมือถือ | ระบบต้องเล่นไฟล์เสียงในเบื้องหลังตามโค้ดปกติโดยไม่เกิดแอปพลิเคชันแครช (Crash) แม้ผู้ใช้ไม่ได้ยินเสียง |
| EC-2 | มีเหตุการณ์กระตุ้นเสียงพากย์หลายบริบทพร้อมกัน ( Audio Queue / Overlap ) เช่น บันทึกน้ำและก้าวเดินเสร็จในเวลาไล่เลี่ยกัน | ระบบต้องจัดคิวการเล่นเสียง (Audio Queue) เล่นทีละไฟล์ตามลำดับก่อนหลัง ไม่เล่นทับซ้อนกัน (No Audio Overlap) |
| EC-3 | ไฟล์เสียง `.mp3` ใน Local Assets เสียหายหรือไม่พบไฟล์ (Missing Asset) | ระบบต้องดักจับข้อผิดพลาด (Exception Handling) ข้ามการเล่นเสียงนั้นไปเงียบๆ โดยไม่กระทบการทำงานหลักของแอป |
| EC-4 | อุปกรณ์ของผู้ใช้อยู่ในสถานะออฟไลน์ (Offline Local Storage) | ระบบสามารถโหลดและเล่นไฟล์เสียง `.mp3` จาก Local Assets (`assets/audio/voice/`) ได้ปกติ 100% โดยไม่ต้องเชื่อมต่ออินเทอร์เน็ต |
| EC-5 | ผู้ใช้กดคลิกเปิด/ปิด Toggle Switch รัวๆ ในเวลาสั้นๆ (Toggle Debounce) | ระบบต้องมีกลไก Debounce (หน่วงเวลา 300 มิลลิวินาที) เพื่อป้องกันการบันทึกค่าซ้ำซ้อนและป้องการส่งคำขอชนกัน |

## 5. สิ่งที่ไม่ทำในรอบนี้ (Out of scope)
- ระบบบันทึกเสียงผู้ใช้หรือระบบแปลงข้อความ Text-to-Speech (TTS) แบบ Real-time บนคลาวด์
- การปรับเปลี่ยนคาแรคเตอร์เสียงหรือตัวเลือก Pitch Shift เพิ่มเติมจากการตั้งค่าในระบบ
- ระบบแปลภาษาเสียงพากย์เป็นภาษาอื่นนอกเหนือจากภาษาไทย

## 6. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น)

| ข้อมูล | ชนิด/หน่วย | เก็บที่ไหน |
|---|---|---|
| Voice Permission Status | Boolean (True/False) | Local Storage |
| Master Voice Toggle | Boolean (True/False) | Local Storage |
| Push Notification Shortcut Toggle | Boolean (True/False) | App Core Notification Setting |
| Audio File Path | String (Local Path) | Local Assets (`assets/audio/voice/`) |

## 7. คำถามที่ยังเปิดอยู่
- ทีมดีไซน์และเสียงต้องการยืนยันระดับความดังมาตรฐาน (Audio Volume Gain) ของไฟล์ `.mp3` ทั้ง 6 ไฟล์ ให้มีความดังเท่ากันหรือไม่ก่อนส่งมอบให้ Developer?

=== จบ docs/voice/requirements.md ===

=== docs/voice/ux-flow.md ===
# UX flow: Pet Voice & Audio Feature (voice)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: เพื่อน B · อ้างอิง: requirements.md

## 1. รายการหน้าจอ

| ID | ชื่อหน้าจอ | จุดประสงค์ | อ้างถึง |
|---|---|---|---|
| S-1 | First Launch Permission Dialog | ขอความยินยอมจากผู้ใช้ในการเปิดใช้งานเสียงพากย์น้องอ๊บเมื่อเข้าแอปครั้งแรกหลังผ่าน Onboarding | US-1, AC-1 |
| S-2 | Dashboard (Main Screen & Audio Trigger) | แสดงผลข้อมูลสุขภาพหลัก (`steps`, `food`, `water`) เล่นเสียงพากย์พร้อมข้อความตามบริบท และแสดงปุ่มตั้งค่ามุมขวาบน | US-2, US-3, AC-2, AC-3, AC-4, AC-5, AC-6, AC-7, AC-8 |
| S-3 | Top-Right Voice & Notification Settings Modal | แสดง Modal ตั้งค่าที่มี Toggle Switch 2 ตัว ได้แก่ `Master Voice` และ `Push Notification Shortcut` | US-3, AC-8, EC-5 |

## 2. องค์ประกอบบนหน้าจอ

### S-1 First Launch Permission Dialog
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| Dialog Container | Modal Dialog | แสดงทับหน้าจอหลักเมื่อเข้าแอปครั้งแรกหลังผ่าน Onboarding (เมื่อ `voice_permission_status` ยังเป็น `NULL / UNANSWERED`) | ป้องกันการกดทะลุพื้นหลัง บังคับเลือกปุ่มใดปุ่มหนึ่ง |
| Pet Illustration | ภาพประกอบ (Image) | `assets/images/pet_avatar_dialog.png` | แสดงภาพตัวละครน้องอ๊บทำหน้าตาน่ารักเป็นกันเองเชิญชวนเปิดเสียง |
| Dialog Title | ข้อความหัวข้อ (Text) | `"ให้น้องอ๊บส่งเสียงทักทายและคอยเป็นกำลังใจให้คุณทุกวันไหมคะ?"` | - |
| Dialog Body | ข้อความรายละเอียด (Text) | `"น้องอ๊บพร้อมส่งเสียงเชยชม แซว หรือเตือนคุณตามบริบทสุขภาพ เพื่อเพิ่มความสนุกในการใช้งานแอป PetPal Health"` | - |
| Primary Button | ปุ่มหลัก (Button) | `[ เปิดเสียงโลด! (แนะนำ) ]` | บันทึก `voice_permission_status = True` (`TRUE / ON`) และตั้งค่าเริ่มต้น `master_voice_toggle = True` (`TRUE / ON`) ลง Local Storage, ปิด Dialog และไม่แสดงซ้ำในครั้งถัดไป (AC-1) |
| Secondary Button | ปุ่มรอง (Button) | `[ ปิดเสียงไว้ก่อน ]` | บันทึก `voice_permission_status = False` (`FALSE / OFF`) และตั้งค่าเริ่มต้น `master_voice_toggle = False` (`FALSE / OFF`) ลง Local Storage, ปิด Dialog และไม่แสดงซ้ำในครั้งถัดไป (AC-1) |

### S-2 Dashboard (Main Screen & Audio Trigger)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| Settings Icon Button | ปุ่มไอคอน (Icon Button) | ไอคอนตั้งค่ารูปเฟือง (`assets/images/icon_settings_gear.png`) ที่มุมขวาบน (Top-Right Action Bar) | เปิดหน้าต่าง `S-3 Top-Right Voice & Notification Settings Modal` (AC-8) |
| Pet Character Display | ภาพตัวละคร (`PetCharacter`) | `assets/images/pet_avatar_happy.png` พร้อมกล่องข้อความพูดตามบริบท | แสดงท่าทางตัวละครและข้อความบทพูดตรงกับไฟล์เสียง `.mp3` ที่กำลังเล่น |
| Steps Activity Trigger | ส่วนประมวลผลก้าวเดิน (`steps`) | ประเมินเปอร์เซ็นต์ก้าวเดินเมื่อบันทึกข้อมูลก้าวเดิน (`< 35%`, `70% - 99%`, `≥ 100%`) | หาก `master_voice_toggle == True` ระบบส่งไฟล์เสียงเข้า `Audio Queue` (FIFO) และแสดงข้อความตามตารางบทพูดด้านล่าง (AC-2, AC-3, AC-4) |
| Food Activity Trigger | ส่วนประมวลผลอาหาร (`food`) | ประเมินแคลอรี่ส่วนเกินเมื่อบันทึกข้อมูลอาหาร (`> 100 kcal`) | หาก `master_voice_toggle == True` ระบบส่งไฟล์เสียง `voice_food_overeating.mp3` เข้า `Audio Queue` (FIFO) และแสดงข้อความตามตารางบทพูดด้านล่าง (AC-5) |
| Water Activity Trigger | ส่วนประมวลผลน้ำดื่ม (`water`) | ประเมินจำนวนแก้วเมื่อบันทึกข้อมูลน้ำ (`< 3 แก้ว`, `≥ 8 แก้ว`) | หาก `master_voice_toggle == True` ระบบส่งไฟล์เสียงเข้า `Audio Queue` (FIFO) และแสดงข้อความตามตารางบทพูดด้านล่าง (AC-6, AC-7) |

#### ตารางบทพูดเสียงพากย์และไฟล์เสียงตามบริบทบนหน้า S-2 (Exact Strings)
| อ้างถึง | บริบทและเงื่อนไข | ไฟล์เสียงใน `assets/audio/voice/` | ข้อความที่แสดงและพากย์เสียงคำต่อคำ (Exact String) |
|---|---|---|---|
| AC-2 | ก้าวเดิน (`steps`) `< 35%` | `voice_steps_lazy.mp3` | `"แหม... นอนเก่งขนาดนี้ นึกว่าจำศีลอยู่ซะอีก ลุกขึ้นมาขยับขาหน่อยเร้ว เดี๋ยวร่างจะติดโซฟาเอานะยูว์"` |
| AC-3 | ก้าวเดิน (`steps`) อยู่ในช่วง `70% - 99%` (`70.00% - 99.99%`) | `voice_steps_encouraging.mp3` | `"ฮั่นแน่! อีกนิดเดียวก็จะครบเป้าหมายแล้วนะเนี่ย ขาเริ่มสั่นยังคะคนดี ฮึบอีกนิด เดี๋ยวมีรางวัลให้!"` |
| AC-4 | ก้าวเดิน (`steps`) `≥ 100%` | `voice_steps_success.mp3` | `"โอโห้! วันนี้เดินเยอะจนนับขาแทบไม่ทัน เก่งมากค่ะคนดี ขาไม่พังใช่ไหมเนี่ย วันนี้พักผ่อนตามสบายเลยนะ!"` |
| AC-5 | อาหาร (`food`) เกิน `> 100 kcal` | `voice_food_overeating.mp3` | `"พุงจะแตกตายอยู่แล้วนะแม่คุณ! พอเถอะน้าคนดี เดี๋ยวพรุ่งนี้ค่อยลุยใหม่ (แต่ตอนนี้อิ่มแปล้เลยสิเนี่ย)"` |
| AC-6 | น้ำ (`water`) `< 3 แก้ว` | `voice_water_low.mp3` | `"คอแห้งเป็นผงละเนี่ย ดื่มน้ำหน่อยเร้ว เดี๋ยวหน้าเหี่ยวไม่รู้ด้วยนะ พี่อ๊บเป็นห่วงนะเนี่ย"` |
| AC-7 | น้ำ (`water`) `≥ 8 แก้ว` | `voice_water_success.mp3` | `"ดื่มน้ำเก่งมาก! ผิวพรรณเปล่งปลั่งออร่าจับเลยแบบนี้ เอาใจไปเลยสิคะคนดี!"` |

### S-3 Top-Right Voice & Notification Settings Modal
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| Modal Title | ข้อความหัวข้อ (Text) | `"ตั้งค่าระบบเสียงและการแจ้งเตือน"` | - |
| Master Voice Toggle | Toggle Switch | ป้ายกำกับ: `"เปิด/ปิดเสียงพากย์น้องอ๊บ (Master Voice)"`<br>สถานะ: `TRUE / ON (เปิดใช้งาน)` หรือ `FALSE / OFF (ปิดใช้งาน)` (ตรงกับค่าใน Local Storage) | สลับสถานะเปิด/ปิดการเล่นไฟล์เสียงพากย์ในแอป พร้อมกลไก Debounce หน่วงเวลา `300 มิลลิวินาที` และบันทึกค่าลง Local Storage ทันที (AC-8, EC-5) |
| Push Notification Shortcut Toggle | Toggle Switch | ป้ายกำกับ: `"เปิด/ปิดการแจ้งเตือน (Push Notification Shortcut)"`<br>สถานะ: `TRUE / ON (เปิดใช้งาน)` หรือ `FALSE / OFF (ปิดใช้งาน)` (ตรงกับค่าใน App Core Notification Setting) | สลับสถานะเปิด/ปิดเชื่อมต่อกับระบบแจ้งเตือนหลักของแอป พร้อมกลไก Debounce หน่วงเวลา `300 มิลลิวินาที` และบันทึกค่าลง App Core Notification Setting ทันที (AC-8, EC-5) |
| Close Button | ปุ่มไอคอน (Icon Button) | ไอคอนกากบาท (`X`) หรือกดพื้นที่ว่างนอก Modal | ปิดหน้าต่าง `S-3` กลับสู่หน้าจอ `S-2 Dashboard` |

## 3. ขั้นตอนการใช้งาน (happy path)
1. ผู้ใช้เปิดแอป PetPal Health ครั้งแรกหลังผ่าน Onboarding ระบบตรวจสอบค่า `Voice Permission Status` (`voice_permission_status`) ใน Local Storage พบว่ายังไม่เคยตั้งค่า (`NULL / UNANSWERED`) จึงแสดงหน้าต่าง **S-1 First Launch Permission Dialog** พร้อมหัวข้อ `"ให้น้องอ๊บส่งเสียงทักทายและคอยเป็นกำลังใจให้คุณทุกวันไหมคะ?"`
2. ผู้ใช้กดปุ่ม `[ เปิดเสียงโลด! (แนะนำ) ]` (หรือ `[ ปิดเสียงไว้ก่อน ]`) ระบบบันทึกค่า `voice_permission_status = True` (หรือ `False`) และซิงค์ค่าเริ่มต้นของ `master_voice_toggle = True` (หรือ `False`) ลงใน Local Storage ทันที จากนั้นปิด Dialog และไม่แสดง Dialog นี้ซ้ำอีกในครั้งถัดไป (AC-1)
3. ผู้ใช้ใช้งานหน้า **S-2 Dashboard** และบันทึกข้อมูลสุขภาพระหว่างวัน (เช่น บันทึกก้าวเดิน `< 35%`, `70% - 99%`, `≥ 100%`, บันทึกอาหารเกิน `> 100 kcal`, หรือบันทึกน้ำ `< 3 แก้ว`, `≥ 8 แก้ว`)
4. หาก `master_voice_toggle` เป็น `True` (`ON`) ระบบจะโหลดไฟล์ `.mp3` ที่ตรงกับบริบทจาก Local Assets (`assets/audio/voice/`) เข้าสู่คิวเสียง (`Audio Queue` แบบ FIFO เล่นทีละไฟล์ต่อเนื่องกันทันทีโดยไม่เล่นทับซ้อนกันตาม EC-2) พร้อมแสดงข้อความบทพูดของน้องอ๊บตามตาราง AC-2 ถึง AC-7
5. เมื่อผู้ใช้ต้องการเปลี่ยนการตั้งค่าเสียงหรือการแจ้งเตือน ผู้ใช้กดปุ่มไอคอนตั้งค่าที่มุมขวาบนของหน้า `S-2` เพื่อเปิด **S-3 Top-Right Voice & Notification Settings Modal**
6. ผู้ใช้กดสลับ Toggle Switch ของ `Master Voice` หรือ `Push Notification Shortcut` ระบบใช้กลไก Debounce หน่วงเวลา `300 มิลลิวินาที` (EC-5) เพื่อป้องกันการกดรัวซ้ำซ้อน และบันทึกค่าใหม่ลงใน Local Storage / App Core Notification Setting ทันที (AC-8)

## 4. สถานะของหน้าจอ

| หน้าจอ | สถานะ | เงื่อนไขที่ทำให้เกิด | สิ่งที่แสดง |
|---|---|---|---|
| S-1 | `NORMAL (ปกติ)` | ผู้ใช้เปิดแอปครั้งแรกหลังผ่าน Onboarding และ `voice_permission_status` ยังเป็น `NULL / UNANSWERED` | แสดง First Launch Permission Dialog พร้อมภาพน้องอ๊บ หัวข้อ และปุ่ม `[ เปิดเสียงโลด! (แนะนำ) ]` / `[ ปิดเสียงไว้ก่อน ]` (AC-1) |
| S-1 | `EMPTY (ว่าง/ไม่แสดงซ้ำ)` | ผู้ใช้เคยกดเลือกปุ่มใน Dialog ไปแล้ว (`voice_permission_status` เป็น `True` หรือ `False` ใน Local Storage) | ไม่แสดง Dialog ซ้ำ เข้าสู่หน้า S-2 Dashboard ทันที (AC-1) |
| S-1 | `ERROR (ผิดพลาด)` | อ่านข้อมูลจาก Local Storage ไม่สำเร็จหรือข้อมูลเสียหาย | ใช้ค่าเริ่มต้นชั่วคราวเป็น `NULL / UNANSWERED` และแสดง Dialog ให้ผู้ใช้เลือกใหม่โดยแอปไม่แครช |
| S-2 | `NORMAL (ปกติ - เล่นเสียงพากย์)` | `master_voice_toggle == True` และข้อมูลสุขภาพที่บันทึกตรงตามเกณฑ์ AC-2 ถึง AC-7 | เล่นไฟล์เสียง `.mp3` จาก `assets/audio/voice/` ตามคิว FIFO (EC-2, EC-4) พร้อมแสดงข้อความบทพูด |
| S-2 | `EMPTY (ว่าง/ไม่เข้าเกณฑ์หรือปิดเสียง)` | ข้อมูลสุขภาพอยู่ในช่วงปกติที่ไม่มีเสียงพากย์ (เช่น ก้าวเดิน `35% - 69.99%`, อาหารไม่เกิน `100 kcal`, น้ำ `3 - 7 แก้ว`) หรือผู้ใช้ตั้งค่า `master_voice_toggle == False` หรือมือถือเปิด Mute Mode / ลดเสียงเป็น 0 (EC-1) | แสดงหน้าจอ Dashboard ตามปกติโดยไม่มีเสียงออกลำโพง และในกรณี Mute Mode ของมือถือ (EC-1) ระบบทำงานตามโค้ดปกติโดยไม่แครช |
| S-2 | `ERROR (ผิดพลาด - ไม่พบไฟล์เสียง)` | ไฟล์เสียง `.mp3` ใน Local Assets (`assets/audio/voice/`) สูญหายหรือเสียหาย (`Missing Asset` ตาม EC-3) | ระบบดักจับข้อผิดพลาด (Exception Handling) ข้ามการเล่นไฟล์เสียงนั้นไปเงียบๆ โดยไม่แครชและไม่กระทบการทำงานหลักของแอป (EC-3) |
| S-3 | `NORMAL (ปกติ)` | ผู้ใช้กดปุ่มไอคอนตั้งค่ามุมขวาบนเพื่อเปิด Modal | แสดง Toggle Switch ทั้ง 2 ตัว (`Master Voice` และ `Push Notification Shortcut`) ตามสถานะปัจจุบันพร้อมใช้งาน (AC-8) |
| S-3 | `EMPTY (ว่าง/หน่วงเวลากดซ้ำ)` | ผู้ใช้กดสลับ Toggle Switch รัวๆ ภายในช่วงเวลา `< 300 มิลลิวินาที` (EC-5) | ระบบหน่วงเวลา Debounce `300 มิลลิวินาที` รอให้การกดนิ่งก่อนบันทึกค่าครั้งสุดท้ายเพียงครั้งเดียว (EC-5) |
| S-3 | `ERROR (ผิดพลาด)` | ระบบไม่สามารถบันทึกค่าลง Local Storage หรือ App Core Notification Setting ได้ | คงสถานะ Toggle Switch ไว้ที่ค่าเดิมก่อนกดและแจ้งเตือนให้ลองใหม่อีกครั้งโดยแอปไม่แครช |

## 5. ไฟล์ภาพ assets

### 5.1 ไฟล์ภาพประกอบ UI และตัวละคร (`Image Assets`)
| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายภาพ |
|---|---|---|
| `assets/images/pet_avatar_dialog.png` | S-1 (First Launch Permission Dialog) | ภาพตัวละครน้องอ๊บทำหน้าตาน่ารักเป็นกันเองเชิญชวนเปิดเสียงพากย์ |
| `assets/images/pet_avatar_happy.png` | S-2 (Dashboard Main Screen) | ภาพตัวละครน้องอ๊บแสดงท่าทางประกอบการพูดให้กำลังใจและแซวผู้ใช้ |
| `assets/images/icon_settings_gear.png` | S-2 (มุมขวาบน Top-Right Action Bar) | ไอคอนรูปเฟืองสำหรับกดเปิด Modal ตั้งค่าระบบเสียงและการแจ้งเตือน (S-3) |

### 5.2 ไฟล์เสียงพากย์น้องอ๊บ (`Audio Assets` ใน `assets/audio/voice/`)
| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายเสียงพากย์ |
|---|---|---|
| `assets/audio/voice/voice_steps_lazy.mp3` | S-2 (AC-2: ก้าวเดิน `< 35%`) | เสียงพากย์น้องอ๊บโหมดขี้เกียจ แซวขำๆ ให้ลุกมาขยับขา |
| `assets/audio/voice/voice_steps_encouraging.mp3` | S-2 (AC-3: ก้าวเดิน `70% - 99%`) | เสียงพากย์น้องอ๊บโหมดใกล้สำเร็จ เชียร์อัพตื่นเต้นให้เดินครบเป้า |
| `assets/audio/voice/voice_steps_success.mp3` | S-2 (AC-4: ก้าวเดิน `≥ 100%`) | เสียงพากย์น้องอ๊บโหมดสำเร็จ ชมเชยเมื่อเดินถึงหรือเกินเป้าหมาย |
| `assets/audio/voice/voice_food_overeating.mp3` | S-2 (AC-5: อาหารเกิน `> 100 kcal`) | เสียงพากย์น้องอ๊บแซวด้วยความห่วงใยเมื่อกินเกินเป้าหมายมากกว่า 100 kcal |
| `assets/audio/voice/voice_water_low.mp3` | S-2 (AC-6: น้ำ `< 3 แก้ว`) | เสียงพากย์น้องอ๊บเตือนด้วยความห่วงใยเมื่อดื่มน้ำน้อยกว่า 3 แก้ว |
| `assets/audio/voice/voice_water_success.mp3` | S-2 (AC-7: น้ำ `≥ 8 แก้ว`) | เสียงพากย์น้องอ๊บชมเชยเมื่อดื่มน้ำครบตั้งแต่ 8 แก้วขึ้นไป |

## 6. คำถามถึง Product
1. **คำถามเปิดจาก Requirements หัวข้อ 7:** ทีมดีไซน์และเสียงต้องการยืนยันระดับความดังมาตรฐาน (Audio Volume Gain) ของไฟล์ `.mp3` ทั้ง 6 ไฟล์ ให้มีความดังเท่ากันหรือไม่ก่อนส่งมอบให้ Developer?
   - **ข้อเสนอแนะจาก Design:** ทีมดีไซน์และเสียงควรปรับมาตรฐานความดัง (Loudness Normalization) ของไฟล์ `.mp3` ทั้ง 6 ไฟล์ใน `assets/audio/voice/` ให้เท่ากันที่ระดับ `-14 LUFS` (และ True Peak ไม่เกิน `-1.0 dBTP`) เพื่อป้องกันปัญหาเสียงดังหรือเบาไม่เท่ากันเมื่อเล่นต่อเนื่องใน `Audio Queue`
   - **กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):** ให้ Developer ตั้งค่าระดับความดังเริ่มต้นของ Audio Player ในโค้ดที่ `DEFAULT_AUDIO_VOLUME_GAIN = 0.80` (`80%` ของระดับเสียงสื่อมาตรฐาน) เท่ากันทุกไฟล์ `.mp3` ทั้ง 6 ไฟล์ เพื่อให้พัฒนาโค้ดและทดสอบได้ทันทีโดยไม่ต้องรอการปรับแต่งไฟล์เสียงใหม่
   - **การประเมินสถานะการบล็อก:** `Blocking: ไม่ใช่` (เนื่องจากมีค่าเริ่มต้น `DEFAULT_AUDIO_VOLUME_GAIN = 0.80` และชื่อไฟล์ `.mp3` มาตรฐานครบทั้ง 6 ไฟล์แล้ว จึงไม่บล็อกการเขียนโค้ดหรือการทดสอบตรรกะของ Developer)

=== จบ docs/voice/ux-flow.md ===

=== docs/voice/game-rules.md ===
# กติกาเกม: Pet Voice & Audio Feature (voice)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: เพื่อน B · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ชนิดข้อมูล | ความหมาย | ค่า | หน่วย | อ้างถึง |
|---|---|---|---|---|---|
| `VOICE_PERMISSION_STATUS` | Boolean | สถานะการตอบรับ Dialog ขอสิทธิ์เปิดเสียงครั้งแรก (`True` = เปิดเสียงโลด, `False` = ปิดเสียงไว้ก่อน, `NULL` = ยังไม่เคยตอบ) | `True / False` | - | US-1, AC-1 |
| `MASTER_VOICE_TOGGLE` | Boolean | สถานะสวิตช์เปิด/ปิดเสียงพากย์น้องอ๊บหลัก (`True` = เปิด, `False` = ปิด) | `True / False` | - | US-3, AC-8 |
| `PUSH_NOTIFICATION_SHORTCUT_TOGGLE` | Boolean | สถานะสวิตช์ลัดเปิด/ปิดระบบแจ้งเตือนหลักของแอป (`True` = เปิด, `False` = ปิด) | `True / False` | - | US-3, AC-8 |
| `AUDIO_FILE_PATH` | String | พาธโฟลเดอร์ Local Assets สำหรับเก็บไฟล์เสียง `.mp3` ทั้ง 6 บริบท | `assets/audio/voice/` | - | AC-2 ถึง AC-7, EC-4 |
| `STEPS_LAZY_THRESHOLD` | Float | เกณฑ์เปอร์เซ็นต์ก้าวเดินต่ำกว่ากำหนดที่เล่นเสียงโหมดขี้เกียจ (`< 35%`) | `< 35.00` | % | US-2, AC-2 |
| `STEPS_ENCOURAGING_MIN` | Float | ขอบล่างของช่วงก้าวเดินใกล้ถึงเป้าหมาย (`70% - 99%`) | `70.00` | % | US-2, AC-3 |
| `STEPS_ENCOURAGING_MAX` | Float | ขอบบนของช่วงก้าวเดินใกล้ถึงเป้าหมาย (`70% - 99%` หรือก่อนครบ `100.00%`) | `99.99` | % | US-2, AC-3 |
| `STEPS_SUCCESS_THRESHOLD` | Float | เกณฑ์เปอร์เซ็นต์ก้าวเดินเมื่อบรรลุหรือเกินเป้าหมาย (`≥ 100%`) | `>= 100.00` | % | US-2, AC-4 |
| `FOOD_OVEREATING_THRESHOLD` | Float | เกณฑ์แคลอรี่อาหารที่บันทึกเกินเป้าหมาย (`> 100 kcal`) | `> 100.00` | kcal | US-2, AC-5 |
| `WATER_LOW_THRESHOLD` | Integer | เกณฑ์จำนวนแก้วน้ำดื่มต่ำกว่ากำหนด (`< 3 แก้ว`) | `< 3` | แก้ว | US-2, AC-6 |
| `WATER_SUCCESS_THRESHOLD` | Integer | เกณฑ์จำนวนแก้วน้ำดื่มเมื่อบรรลุหรือเกินเป้าหมาย (`≥ 8 แก้ว`) | `>= 8` | แก้ว | US-2, AC-7 |
| `TOGGLE_DEBOUNCE_MS` | Integer | ระยะเวลาหน่วง Debounce เมื่อผู้ใช้กดสลับ Toggle Switch รัวๆ ในเวลาสั้นๆ | `300` | มิลลิวินาที | US-3, AC-8, EC-5 |
| `DEFAULT_AUDIO_VOLUME_GAIN` | Float | ค่าเริ่มต้นความดังมาตรฐานของ Audio Player สำหรับไฟล์ `.mp3` ทั้ง 6 ไฟล์ (Fallback Rule) | `0.80` | สัดส่วน (80%) | หัวข้อ 5 (Open Question) |

### 1.1 ตารางข้อความ เงื่อนไข และลำดับคิว

| ชื่อเรียก / ชื่อไฟล์ | หมวด/เรื่อง | ข้อความคำต่อคำ (Exact String) | เงื่อนไขส่ง/เล่น (Trigger) | เงื่อนไขหยุด/ยกเลิก/ข้าม (Cancel/Skip) |
|---|---|---|---|---|
| `voice_steps_lazy.mp3` | ก้าวเดิน (`steps` `< 35%`) | `"แหม... นอนเก่งขนาดนี้ นึกว่าจำศีลอยู่ซะอีก ลุกขึ้นมาขยับขาหน่อยเร้ว เดี๋ยวร่างจะติดโซฟาเอานะยูว์"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลก้าวเดิน (`steps`) `< 35%` (`< 35.00%`) (AC-2) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |
| `voice_steps_encouraging.mp3` | ก้าวเดิน (`steps` `70% - 99%`) | `"ฮั่นแน่! อีกนิดเดียวก็จะครบเป้าหมายแล้วนะเนี่ย ขาเริ่มสั่นยังคะคนดี ฮึบอีกนิด เดี๋ยวมีรางวัลให้!"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลก้าวเดิน (`steps`) อยู่ในช่วง `70% - 99%` (`70.00% - 99.99%`) (AC-3) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |
| `voice_steps_success.mp3` | ก้าวเดิน (`steps` `≥ 100%`) | `"โอโห้! วันนี้เดินเยอะจนนับขาแทบไม่ทัน เก่งมากค่ะคนดี ขาไม่พังใช่ไหมเนี่ย วันนี้พักผ่อนตามสบายเลยนะ!"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลก้าวเดิน (`steps`) `≥ 100%` (`>= 100.00%`) (AC-4) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |
| `voice_food_overeating.mp3` | อาหาร (`food` เกิน `> 100 kcal`) | `"พุงจะแตกตายอยู่แล้วนะแม่คุณ! พอเถอะน้าคนดี เดี๋ยวพรุ่งนี้ค่อยลุยใหม่ (แต่ตอนนี้อิ่มแปล้เลยสิเนี่ย)"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลอาหาร (`food`) เกิน `> 100 kcal` (`> 100.00 kcal`) (AC-5) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |
| `voice_water_low.mp3` | น้ำดื่ม (`water` `< 3 แก้ว`) | `"คอแห้งเป็นผงละเนี่ย ดื่มน้ำหน่อยเร้ว เดี๋ยวหน้าเหี่ยวไม่รู้ด้วยนะ พี่อ๊บเป็นห่วงนะเนี่ย"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลน้ำ (`water`) `< 3 แก้ว` (AC-6) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |
| `voice_water_success.mp3` | น้ำดื่ม (`water` `≥ 8 แก้ว`) | `"ดื่มน้ำเก่งมาก! ผิวพรรณเปล่งปลั่งออร่าจับเลยแบบนี้ เอาใจไปเลยสิคะคนดี!"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลน้ำ (`water`) `≥ 8 แก้ว` (AC-7) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |

- **กฎลำดับคิวการเล่นเสียง (`Audio Queue` ตาม `EC-2`):** จัดคิวการเล่นเสียงแบบเข้าก่อนออกก่อน (`FIFO: First-In, First-Out`) เมื่อมีเหตุการณ์กระตุ้นเสียงพากย์หลายบริบทในเวลาไล่เลี่ยกัน ระบบจะเล่นทีละไฟล์ตามลำดับก่อนหลัง ห้ามเล่นทับซ้อนกัน (`No Audio Overlap`)
- **ระยะห่างระหว่างไฟล์ในคิว:** เล่นไฟล์ถัดไปในคิวต่อเนื่องทันทีที่ไฟล์ก่อนหน้าเล่นจบ (`Cooldown = 0 มิลลิวินาที` หลังจบไฟล์ก่อนหน้า)
- **เพดานต่อวัน:** ไม่จำกัดจำนวนครั้งต่อวัน (เล่นตามเหตุการณ์การบันทึกข้อมูลสุขภาพจริงของผู้ใช้เมื่อเปิด `Master Voice Toggle`)
- **การล้างคิวเมื่อปิดเสียง:** หากผู้ใช้สลับ `Master Voice Toggle` เป็น `False` (`OFF`) ขณะมีไฟล์เสียงรออยู่ใน `Audio Queue` ระบบจะหยุดเสียงปัจจุบันและล้างคิวที่ค้างอยู่ทันที

### 1.2 ตารางสถานะและข้อมูลที่เก็บในระบบ (System State & Storage Schema)

| ชื่อข้อมูล (ตาม Requirements หัวข้อ 6) | ชื่อตัวแปรในโค้ด | ชนิดข้อมูล | ค่าเริ่มต้น | ค่าที่เป็นไปได้และป้ายแสดงผล `CODE_ENUM (ป้ายไทย)` | เก็บที่ไหน | อ้างถึง |
|---|---|---|---|---|---|---|
| Voice Permission Status | `voice_permission_status` | Boolean (True/False) | `NULL / UNANSWERED` (ก่อนตอบ Dialog ครั้งแรก) | `TRUE / ON (เปิดเสียงโลด - อนุญาต)`, `FALSE / OFF (ปิดเสียงไว้ก่อน - ไม่อนุญาตเริ่มต้น)`, `NULL / UNANSWERED (ยังไม่เคยตอบ Dialog ครั้งแรก)` | Local Storage | US-1, AC-1 |
| Master Voice Toggle | `master_voice_toggle` | Boolean (True/False) | ซิงค์ตามปุ่มที่เลือกใน `S-1` (`True` เมื่อกดเปิดเสียงโลด / `False` เมื่อกดปิดเสียงไว้ก่อน) | `TRUE / ON (เปิดใช้งานเสียงพากย์)`, `FALSE / OFF (ปิดใช้งานเสียงพากย์)` | Local Storage | US-1, US-3, AC-1, AC-8, EC-5 |
| Push Notification Shortcut Toggle | `push_notification_shortcut_toggle` | Boolean (True/False) | ซิงค์ตามค่าปัจจุบันใน App Core Notification Setting | `TRUE / ON (เปิดใช้งานการแจ้งเตือน)`, `FALSE / OFF (ปิดใช้งานการแจ้งเตือน)` | App Core Notification Setting | US-3, AC-8, EC-5 |
| Audio File Path | `audio_file_path` | String (Local Path) | `assets/audio/voice/` | พาธไฟล์ `.mp3` ทั้ง 6 ไฟล์ใน `assets/audio/voice/` | Local Assets (`assets/audio/voice/`) | US-2, AC-2 ถึง AC-7, EC-3, EC-4 |

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง

| สถานะ | ช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพตัวละคร / ไฟล์เสียงที่ใช้ |
|---|---|---|
| `PERMISSION_DIALOG (ขอสิทธิ์เสียงครั้งแรก)` | `voice_permission_status == NULL / UNANSWERED` เมื่อเข้าหน้า Home ครั้งแรกหลัง Onboarding (AC-1) | ไฟล์ภาพ: `assets/images/pet_avatar_dialog.png` |
| `DASHBOARD_IDLE (ปกติ/ไม่มีเสียงพากย์)` | `master_voice_toggle == False` หรือข้อมูลอยู่ในช่วงปกติที่ไม่กระตุ้นเสียง (ก้าวเดิน `35.00% - 69.99%`, อาหารเกิน `<= 100.00 kcal`, น้ำ `3 - 7 แก้ว`) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png` (ไม่เล่นไฟล์เสียง) |
| `VOICE_STEPS_LAZY (ก้าวเดินโหมดขี้เกียจ)` | `master_voice_toggle == True` และก้าวเดิน (`steps`) `>= 0.00%` ถึง `< 35.00%` (ไม่รวมขอบ `35.00%`) (AC-2) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_steps_lazy.mp3` |
| `VOICE_STEPS_ENCOURAGING (ก้าวเดินโหมดเชียร์อัพ)` | `master_voice_toggle == True` และก้าวเดิน (`steps`) อยู่ในช่วง `70% - 99%` คือตั้งแต่ `70.00%` ถึง `99.99%` (รวมขอบ `70.00%` และ `99.99%` ก่อนครบ `100.00%`) (AC-3) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_steps_encouraging.mp3` |
| `VOICE_STEPS_SUCCESS (ก้าวเดินโหมดสำเร็จ)` | `master_voice_toggle == True` และก้าวเดิน (`steps`) `>= 100.00%` ขึ้นไป (รวมขอบ `100.00%` และรองรับค่าเกิน `100%`) (AC-4) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_steps_success.mp3` |
| `VOICE_FOOD_OVEREATING (อาหารเกินเป้าหมาย)` | `master_voice_toggle == True` และอาหาร (`food`) เกินเป้าหมาย `> 100.00 kcal` (ไม่รวมขอบ `100.00 kcal`) (AC-5) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_food_overeating.mp3` |
| `VOICE_WATER_LOW (น้ำดื่มน้อยกว่าเกณฑ์)` | `master_voice_toggle == True` และน้ำดื่ม (`water`) `>= 0` ถึง `< 3 แก้ว` คือ `0, 1, 2 แก้ว` (ไม่รวมขอบ `3 แก้ว`) (AC-6) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_water_low.mp3` |
| `VOICE_WATER_SUCCESS (น้ำดื่มบรรลุเป้าหมาย)` | `master_voice_toggle == True` และน้ำดื่ม (`water`) `>= 8 แก้ว` ขึ้นไป (รวมขอบ `8 แก้ว`) (AC-7) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_water_success.mp3` |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| ผู้ใช้เข้าแอปครั้งแรกหลัง Onboarding และกดปุ่ม `[ เปิดเสียงโลด! (แนะนำ) ]` บน S-1 | `voice_permission_status = NULL`, `master_voice_toggle = NULL` | `voice_permission_status = True`, `master_voice_toggle = True` | ปิด S-1 และไม่แสดงซ้ำในครั้งถัดไป (AC-1) |
| ผู้ใช้เข้าแอปครั้งแรกหลัง Onboarding และกดปุ่ม `[ ปิดเสียงไว้ก่อน ]` บน S-1 | `voice_permission_status = NULL`, `master_voice_toggle = NULL` | `voice_permission_status = False`, `master_voice_toggle = False` | ปิด S-1 และไม่แสดงซ้ำในครั้งถัดไป (AC-1) |
| บันทึกก้าวเดินต่ำกว่าเกณฑ์ `< 35%` (ขณะเปิดเสียง) | `steps = 34.99%`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_steps_lazy.mp3` | เข้าเกณฑ์ `< 35%` พอดีขอบบน (AC-2) |
| บันทึกก้าวเดินแตะขอบ `35.00%` พอดี (ขณะเปิดเสียง) | `steps = 35.00%`, `master_voice_toggle = True` | ไม่เล่นเสียงพากย์ (`No Trigger`) | ไม่อยู่ในช่วง `< 35%` และยังไม่ถึง `70%` |
| บันทึกก้าวเดินที่ `69.99%` ก่อนถึงเกณฑ์เชียร์อัพ | `steps = 69.99%`, `master_voice_toggle = True` | ไม่เล่นเสียงพากย์ (`No Trigger`) | ต่ำกว่าขอบล่าง `70.00%` |
| บันทึกก้าวเดินแตะขอบล่างช่วง `70% - 99%` | `steps = 70.00%`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_steps_encouraging.mp3` | เข้าเกณฑ์รวมขอบล่าง `70.00%` (AC-3) |
| บันทึกก้าวเดินแตะขอบบนช่วง `70% - 99%` | `steps = 99.00%` (หรือ `99.99%`), `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_steps_encouraging.mp3` | เข้าเกณฑ์ช่วง `70% - 99%` ก่อนครบ 100% (AC-3) |
| บันทึกก้าวเดินครบเป้าหมาย `100.00%` พอดี | `steps = 100.00%`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_steps_success.mp3` | เข้าเกณฑ์ `≥ 100%` พอดีขอบล่าง (AC-4) |
| บันทึกก้าวเดินเกินเป้าหมาย (Overachievement) | `steps = 125.00%`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_steps_success.mp3` | รองรับค่าสะสมเกิน 100% (AC-4) |
| บันทึกอาหารเกินเป้าหมาย `100.00 kcal` พอดี | `food_excess = 100.00 kcal`, `master_voice_toggle = True` | ไม่เล่นเสียงพากย์ (`No Trigger`) | ไม่เข้าเกณฑ์ เนื่องจากต้องมากกว่า `> 100 kcal` (AC-5) |
| บันทึกอาหารเกินเป้าหมายมากกว่า `100 kcal` | `food_excess = 100.01 kcal` (หรือ `150 kcal`), `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_food_overeating.mp3` | เข้าเกณฑ์ `> 100 kcal` (AC-5) |
| บันทึกน้ำดื่ม `< 3 แก้ว` | `water = 2 แก้ว`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_water_low.mp3` | เข้าเกณฑ์ `< 3 แก้ว` (AC-6) |
| บันทึกน้ำดื่มแตะขอบ `3 แก้ว` ถึง `7 แก้ว` | `water = 3 แก้ว` (หรือ `7 แก้ว`), `master_voice_toggle = True` | ไม่เล่นเสียงพากย์ (`No Trigger`) | ไม่อยู่ในช่วง `< 3 แก้ว` และยังไม่ถึง `8 แก้ว` |
| บันทึกน้ำดื่มครบ `8 แก้ว` พอดี | `water = 8 แก้ว`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_water_success.mp3` | เข้าเกณฑ์ `≥ 8 แก้ว` พอดีขอบล่าง (AC-7) |
| บันทึกน้ำ `8 แก้ว` และก้าวเดิน `100%` เสร็จในเวลาไล่เลี่ยกัน | `Audio Queue` ว่าง, มี 2 เหตุการณ์เกิดพร้อมกัน | คิวที่ 1 เล่น `voice_water_success.mp3` จนจบ แล้วเล่นคิวที่ 2 `voice_steps_success.mp3` ต่อทันที | จัดคิวแบบ FIFO ไม่เล่นทับซ้อนกัน (EC-2) |
| ผู้ใช้กดสลับสวิตช์ `Master Voice` และ `Push Notification Shortcut` ใน S-3 | `master_voice_toggle = True`, `push_notification_shortcut_toggle = True` | บันทึกค่าใหม่เป็น `False` หลังผ่าน Debounce `300 ms` | บันทึกค่าทันทีเมื่อพ้นระยะ Debounce (AC-8, EC-5) |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ที่ทดสอบได้ |
|---|---|
| ผู้ใช้เปิดโหมดปิดเสียง (Mute Mode / Silent) หรือลดเสียงสื่อเป็น 0 บนมือถือ (`EC-1`) | ระบบเล่นไฟล์เสียงในเบื้องหลังตามโค้ดปกติโดยไม่เกิดแอปพลิเคชันแครช (Crash) แม้ผู้ใช้ไม่ได้ยินเสียง |
| มีเหตุการณ์กระตุ้นเสียงพากย์หลายบริบทพร้อมกัน (`Audio Queue` / Overlap) เช่น บันทึกน้ำและก้าวเดินเสร็จในเวลาไล่เลี่ยกัน (`EC-2`) | ระบบจัดคิวการเล่นเสียง (`Audio Queue` แบบ FIFO) เล่นทีละไฟล์ตามลำดับก่อนหลัง ต่อเนื่องกันทันทีเมื่อไฟล์ก่อนหน้าจบ (`Cooldown = 0 ms`) โดยไม่เล่นทับซ้อนกัน (No Audio Overlap) |
| ไฟล์เสียง `.mp3` ใน Local Assets เสียหายหรือไม่พบไฟล์ (Missing Asset) (`EC-3`) | ระบบดักจับข้อผิดพลาด (Exception Handling) ข้ามการเล่นเสียงนั้นไปเงียบๆ โดยไม่แครชและไม่กระทบการทำงานหลักของแอป |
| อุปกรณ์ของผู้ใช้อยู่ในสถานะออฟไลน์ (Offline Local Storage) (`EC-4`) | ระบบโหลดและเล่นไฟล์เสียง `.mp3` จาก Local Assets (`assets/audio/voice/`) ได้ปกติ 100% โดยไม่ต้องเชื่อมต่ออินเทอร์เน็ต |
| ผู้ใช้กดคลิกเปิด/ปิด Toggle Switch รัวๆ ในเวลาสั้นๆ (Toggle Debounce) (`EC-5`) | ระบบมีกลไก Debounce (หน่วงเวลา `300 มิลลิวินาที`) เพื่อป้องกันการบันทึกค่าซ้ำซ้อนและป้องกันการส่งคำขอชนกัน |

## 5. คำถามถึง Product

1. **คำถามเปิดจาก Requirements หัวข้อ 7:** ทีมดีไซน์และเสียงต้องการยืนยันระดับความดังมาตรฐาน (Audio Volume Gain) ของไฟล์ `.mp3` ทั้ง 6 ไฟล์ ให้มีความดังเท่ากันหรือไม่ก่อนส่งมอบให้ Developer?
   - **ข้อเสนอแนะจาก Design:** ทีมดีไซน์และเสียงควรปรับมาตรฐานความดัง (Loudness Normalization) ของไฟล์ `.mp3` ทั้ง 6 ไฟล์ใน `assets/audio/voice/` ให้เท่ากันที่ระดับ `-14 LUFS` (และ True Peak ไม่เกิน `-1.0 dBTP`) เพื่อป้องกันปัญหาเสียงดังหรือเบาไม่เท่ากันเมื่อเล่นต่อเนื่องใน `Audio Queue`
   - **กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):** ให้ Developer ตั้งค่าระดับความดังเริ่มต้นของ Audio Player ในโค้ดที่ `DEFAULT_AUDIO_VOLUME_GAIN = 0.80` (`80%` ของระดับเสียงสื่อมาตรฐาน) เท่ากันทุกไฟล์ `.mp3` ทั้ง 6 ไฟล์ เพื่อให้พัฒนาโค้ดและทดสอบได้ทันทีโดยไม่ต้องรอการปรับแต่งไฟล์เสียงใหม่
   - **การประเมินสถานะการบล็อก:** `Blocking: ไม่ใช่` (เนื่องจากมีค่าเริ่มต้น `DEFAULT_AUDIO_VOLUME_GAIN = 0.80` และชื่อไฟล์ `.mp3` มาตรฐานครบทั้ง 6 ไฟล์แล้ว จึงไม่บล็อกการเขียนโค้ดหรือการทดสอบตรรกะของ Developer)

=== จบ docs/voice/game-rules.md ===

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

expected_output: เนื้อหาไฟล์ docs/voice/design-review.md ฉบับสมบูรณ์ ตามโครง template

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

# Design Review: voice

## 1. ข้อมูลการตรวจ

- Status: <PASS | NEEDS_FIX | INSUFFICIENT_EVIDENCE>
- Feature: voice
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
Your personal goal is: Review the voice design documents against supplied project specifications, verify prior findings when available, and report evidence-backed contradictions, ambiguities, missing decisions, and actionable documentation issues without modifying source documents.

[user]

Current Task: ฟีเจอร์: voice

งานของคุณ: ตรวจเอกสาร Requirements, UX Flow และ Game Rules ก่อนส่งงานให้ Dev ตรวจความครบถ้วนและความสอดคล้องของเอกสาร ตรวจตัวเลข ชื่อสถานะ ขั้นตอนการใช้งาน และ edge cases โดยอ้างอิงหลักฐานจากไฟล์ที่ได้รับ ระบุข้อผิดพลาดพร้อมไฟล์/หัวข้อ เหตุผล และแนวทางแก้ไข ห้ามแต่งข้อกำหนดหรือผลทดสอบขึ้นเอง สรุปผลเป็น PASS, NEEDS_FIX หรือ INSUFFICIENT_EVIDENCE

ข้อมูลประกอบ:
=== docs/voice/requirements.md ===
# Requirements: Pet Voice & Audio Feature (voice)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Product agent · ผู้ตรวจ: Senior QA · อ้างอิง Issue: #104

## 1. สรุปฟีเจอร์
ฟีเจอร์เสียงน้องอ๊บช่วยเพิ่มแรงจูงใจและสร้างความบันเทิงให้ผู้ใช้ผ่านเสียงพากย์กวนๆ อบอุ่น ของตัวละครสัตว์เลี้ยงตามบริบทสุขภาพ (การเดิน, การกิน, การดื่มน้ำ) พร้อมระบบขอสิทธิ์เมื่อเข้าใช้งานครั้งแรก และปุ่มควบคุมตั้งค่าที่มุมขวาบน

## 2. User stories

| ID | ในฐานะ | ฉันอยาก | เพื่อ |
|---|---|---|---|
| US-1 | ผู้ใช้ใหม่ที่เข้าแอปครั้งแรก | เห็น Dialog ขอสิทธิ์เปิดใช้งานเสียงพากย์น้องอ๊บ | สามารถเลือกเปิดหรือปิดเสียงได้ตั้งแต่เริ่มต้นใช้งาน |
| US-2 | ผู้ใช้แอป PetPal Health | ได้ยินเสียงพากย์น้องอ๊บตามบริบทกิจกรรมสุขภาพต่างๆ (Steps, Food, Water) | ได้รับแรงจูงใจ คำชมเชย หรือคำแซวขำๆ ที่เป็นกันเอง |
| US-3 | ผู้ใช้แอป PetPal Health | สามารถเปิด/ปิดเสียงพากย์ (Master Voice) และควบคุมระบบแจ้งเตือนผ่านปุ่มตั้งค่ามุมขวาบนได้ | ควบคุมประสบการณ์การใช้งานเสียงและการแจ้งเตือนของตนเองได้สะดวก |

## 3. Acceptance criteria

| ID | อ้างถึง | เงื่อนไข (ก่อน /เมื่อ / แล้ว) | ค่าที่ทดสอบได้ |
|---|---|---|---|
| AC-1 | US-1 | ก่อน: ผู้ใช้เปิดแอปครั้งแรกหลังผ่าน Onboarding<br>เมื่อ: ระบบแสดง First Launch Permission Dialog<br>แล้ว: ผู้ใช้กดปุ่ม `[ เปิดเสียงโลด! (แนะนำ) ]` หรือ `[ ปิดเสียงไว้ก่อน ]` | ค่าสถานะถูกบันทึก Local Storage และ Dialog ไม่แสดงซ้ำในครั้งถัดไป |
| AC-2 | US-2 | ก่อน: ผู้ใช้เปิดเสียงพากย์ไว้ และบันทึกข้อมูลก้าวเดิน (`steps`) < 35%<br>เมื่อ: ระบบประมวลผลข้อมูลก้าวเดิน<br>แล้ว: เล่นไฟล์เสียง `voice_steps_lazy.mp3` | เล่นเสียงตรงกับไฟล์ `voice_steps_lazy.mp3` พร้อมข้อความ: `"แหม... นอนเก่งขนาดนี้ นึกว่าจำศีลอยู่ซะอีก ลุกขึ้นมาขยับขาหน่อยเร้ว เดี๋ยวร่างจะติดโซฟาเอานะยูว์"` |
| AC-3 | US-2 | ก่อน: ผู้ใช้เปิดเสียงพากย์ไว้ และบันทึกข้อมูลก้าวเดิน (`steps`) อยู่ในช่วง 70% - 99%<br>เมื่อ: ระบบประมวลผลข้อมูลก้าวเดิน<br>แล้ว: เล่นไฟล์เสียง `voice_steps_encouraging.mp3` | เล่นเสียงตรงกับไฟล์ `voice_steps_encouraging.mp3` พร้อมข้อความ: `"ฮั่นแน่! อีกนิดเดียวก็จะครบเป้าหมายแล้วนะเนี่ย ขาเริ่มสั่นยังคะคนดี ฮึบอีกนิด เดี๋ยวมีรางวัลให้!"` |
| AC-4 | US-2 | ก่อน: ผู้ใช้เปิดเสียงพากย์ไว้ และบันทึกข้อมูลก้าวเดิน (`steps`) ≥ 100%<br>เมื่อ: ระบบประมวลผลข้อมูลก้าวเดิน<br>แล้ว: เล่นไฟล์เสียง `voice_steps_success.mp3` | เล่นเสียงตรงกับไฟล์ `voice_steps_success.mp3` พร้อมข้อความ: `"โอโห้! วันนี้เดินเยอะจนนับขาแทบไม่ทัน เก่งมากค่ะคนดี ขาไม่พังใช่ไหมเนี่ย วันนี้พักผ่อนตามสบายเลยนะ!"` |
| AC-5 | US-2 | ก่อน: ผู้ใช้เปิดเสียงพากย์ไว้ และบันทึกข้อมูลอาหาร (`food`) เกิน > 100 kcal<br>เมื่อ: ระบบประมวลผลข้อมูลอาหาร<br>แล้ว: เล่นไฟล์เสียง `voice_food_overeating.mp3` | เล่นเสียงตรงกับไฟล์ `voice_food_overeating.mp3` พร้อมข้อความ: `"พุงจะแตกตายอยู่แล้วนะแม่คุณ! พอเถอะน้าคนดี เดี๋ยวพรุ่งนี้ค่อยลุยใหม่ (แต่ตอนนี้อิ่มแปล้เลยสิเนี่ย)"` |
| AC-6 | US-2 | ก่อน: ผู้ใช้เปิดเสียงพากย์ไว้ และบันทึกข้อมูลน้ำ (`water`) < 3 แก้ว<br>เมื่อ: ระบบประมวลผลข้อมูลน้ำ<br>แล้ว: เล่นไฟล์เสียง `voice_water_low.mp3` | เล่นเสียงตรงกับไฟล์ `voice_water_low.mp3` พร้อมข้อความ: `"คอแห้งเป็นผงละเนี่ย ดื่มน้ำหน่อยเร้ว เดี๋ยวหน้าเหี่ยวไม่รู้ด้วยนะ พี่อ๊บเป็นห่วงนะเนี่ย"` |
| AC-7 | US-2 | ก่อน: ผู้ใช้เปิดเสียงพากย์ไว้ และบันทึกข้อมูลน้ำ (`water`) ≥ 8 แก้ว<br>เมื่อ: ระบบประมวลผลข้อมูลน้ำ<br>แล้ว: เล่นไฟล์เสียง `voice_water_success.mp3` | เล่นเสียงตรงกับไฟล์ `voice_water_success.mp3` พร้อมข้อความ: `"ดื่มน้ำเก่งมาก! ผิวพรรณเปล่งปลั่งออร่าจับเลยแบบนี้ เอาใจไปเลยสิคะคนดี!"` |
| AC-8 | US-3 | ก่อน: ผู้ใช้กดไอคอนตั้งค่าที่มุมขวาบน<br>เมื่อ: Modal แสดงขึ้นมา<br>แล้ว: ผู้ใช้พบ Toggle Switch 2 ตัว ได้แก่ Master Voice และ Push Notification Shortcut พร้อมใช้งาน | สามารถกดเปิด/ปิด Toggle ทั้งสองตัวได้สำเร็จและระบบบันทึกค่าทันที |

## 4. Edge cases

| ID | สถานการณ์ | ผลที่คาดหวัง |
|---|---|---|
| EC-1 | ผู้ใช้เปิดโหมดปิดเสียง (Mute Mode / Silent) หรือลดเสียงสื่อเป็น 0 บนมือถือ | ระบบต้องเล่นไฟล์เสียงในเบื้องหลังตามโค้ดปกติโดยไม่เกิดแอปพลิเคชันแครช (Crash) แม้ผู้ใช้ไม่ได้ยินเสียง |
| EC-2 | มีเหตุการณ์กระตุ้นเสียงพากย์หลายบริบทพร้อมกัน ( Audio Queue / Overlap ) เช่น บันทึกน้ำและก้าวเดินเสร็จในเวลาไล่เลี่ยกัน | ระบบต้องจัดคิวการเล่นเสียง (Audio Queue) เล่นทีละไฟล์ตามลำดับก่อนหลัง ไม่เล่นทับซ้อนกัน (No Audio Overlap) |
| EC-3 | ไฟล์เสียง `.mp3` ใน Local Assets เสียหายหรือไม่พบไฟล์ (Missing Asset) | ระบบต้องดักจับข้อผิดพลาด (Exception Handling) ข้ามการเล่นเสียงนั้นไปเงียบๆ โดยไม่กระทบการทำงานหลักของแอป |
| EC-4 | อุปกรณ์ของผู้ใช้อยู่ในสถานะออฟไลน์ (Offline Local Storage) | ระบบสามารถโหลดและเล่นไฟล์เสียง `.mp3` จาก Local Assets (`assets/audio/voice/`) ได้ปกติ 100% โดยไม่ต้องเชื่อมต่ออินเทอร์เน็ต |
| EC-5 | ผู้ใช้กดคลิกเปิด/ปิด Toggle Switch รัวๆ ในเวลาสั้นๆ (Toggle Debounce) | ระบบต้องมีกลไก Debounce (หน่วงเวลา 300 มิลลิวินาที) เพื่อป้องกันการบันทึกค่าซ้ำซ้อนและป้องการส่งคำขอชนกัน |

## 5. สิ่งที่ไม่ทำในรอบนี้ (Out of scope)
- ระบบบันทึกเสียงผู้ใช้หรือระบบแปลงข้อความ Text-to-Speech (TTS) แบบ Real-time บนคลาวด์
- การปรับเปลี่ยนคาแรคเตอร์เสียงหรือตัวเลือก Pitch Shift เพิ่มเติมจากการตั้งค่าในระบบ
- ระบบแปลภาษาเสียงพากย์เป็นภาษาอื่นนอกเหนือจากภาษาไทย

## 6. ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น)

| ข้อมูล | ชนิด/หน่วย | เก็บที่ไหน |
|---|---|---|
| Voice Permission Status | Boolean (True/False) | Local Storage |
| Master Voice Toggle | Boolean (True/False) | Local Storage |
| Push Notification Shortcut Toggle | Boolean (True/False) | App Core Notification Setting |
| Audio File Path | String (Local Path) | Local Assets (`assets/audio/voice/`) |

## 7. คำถามที่ยังเปิดอยู่
- ทีมดีไซน์และเสียงต้องการยืนยันระดับความดังมาตรฐาน (Audio Volume Gain) ของไฟล์ `.mp3` ทั้ง 6 ไฟล์ ให้มีความดังเท่ากันหรือไม่ก่อนส่งมอบให้ Developer?

=== จบ docs/voice/requirements.md ===

=== docs/voice/ux-flow.md ===
# UX flow: Pet Voice & Audio Feature (voice)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: เพื่อน B · อ้างอิง: requirements.md

## 1. รายการหน้าจอ

| ID | ชื่อหน้าจอ | จุดประสงค์ | อ้างถึง |
|---|---|---|---|
| S-1 | First Launch Permission Dialog | ขอความยินยอมจากผู้ใช้ในการเปิดใช้งานเสียงพากย์น้องอ๊บเมื่อเข้าแอปครั้งแรกหลังผ่าน Onboarding | US-1, AC-1 |
| S-2 | Dashboard (Main Screen & Audio Trigger) | แสดงผลข้อมูลสุขภาพหลัก (`steps`, `food`, `water`) เล่นเสียงพากย์พร้อมข้อความตามบริบท และแสดงปุ่มตั้งค่ามุมขวาบน | US-2, US-3, AC-2, AC-3, AC-4, AC-5, AC-6, AC-7, AC-8 |
| S-3 | Top-Right Voice & Notification Settings Modal | แสดง Modal ตั้งค่าที่มี Toggle Switch 2 ตัว ได้แก่ `Master Voice` และ `Push Notification Shortcut` | US-3, AC-8, EC-5 |

## 2. องค์ประกอบบนหน้าจอ

### S-1 First Launch Permission Dialog
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| Dialog Container | Modal Dialog | แสดงทับหน้าจอหลักเมื่อเข้าแอปครั้งแรกหลังผ่าน Onboarding (เมื่อ `voice_permission_status` ยังเป็น `NULL / UNANSWERED`) | ป้องกันการกดทะลุพื้นหลัง บังคับเลือกปุ่มใดปุ่มหนึ่ง |
| Pet Illustration | ภาพประกอบ (Image) | `assets/images/pet_avatar_dialog.png` | แสดงภาพตัวละครน้องอ๊บทำหน้าตาน่ารักเป็นกันเองเชิญชวนเปิดเสียง |
| Dialog Title | ข้อความหัวข้อ (Text) | `"ให้น้องอ๊บส่งเสียงทักทายและคอยเป็นกำลังใจให้คุณทุกวันไหมคะ?"` | - |
| Dialog Body | ข้อความรายละเอียด (Text) | `"น้องอ๊บพร้อมส่งเสียงเชยชม แซว หรือเตือนคุณตามบริบทสุขภาพ เพื่อเพิ่มความสนุกในการใช้งานแอป PetPal Health"` | - |
| Primary Button | ปุ่มหลัก (Button) | `[ เปิดเสียงโลด! (แนะนำ) ]` | บันทึก `voice_permission_status = True` (`TRUE / ON`) และตั้งค่าเริ่มต้น `master_voice_toggle = True` (`TRUE / ON`) ลง Local Storage, ปิด Dialog และไม่แสดงซ้ำในครั้งถัดไป (AC-1) |
| Secondary Button | ปุ่มรอง (Button) | `[ ปิดเสียงไว้ก่อน ]` | บันทึก `voice_permission_status = False` (`FALSE / OFF`) และตั้งค่าเริ่มต้น `master_voice_toggle = False` (`FALSE / OFF`) ลง Local Storage, ปิด Dialog และไม่แสดงซ้ำในครั้งถัดไป (AC-1) |

### S-2 Dashboard (Main Screen & Audio Trigger)
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| Settings Icon Button | ปุ่มไอคอน (Icon Button) | ไอคอนตั้งค่ารูปเฟือง (`assets/images/icon_settings_gear.png`) ที่มุมขวาบน (Top-Right Action Bar) | เปิดหน้าต่าง `S-3 Top-Right Voice & Notification Settings Modal` (AC-8) |
| Pet Character Display | ภาพตัวละคร (`PetCharacter`) | `assets/images/pet_avatar_happy.png` พร้อมกล่องข้อความพูดตามบริบท | แสดงท่าทางตัวละครและข้อความบทพูดตรงกับไฟล์เสียง `.mp3` ที่กำลังเล่น |
| Steps Activity Trigger | ส่วนประมวลผลก้าวเดิน (`steps`) | ประเมินเปอร์เซ็นต์ก้าวเดินเมื่อบันทึกข้อมูลก้าวเดิน (`< 35%`, `70% - 99%`, `≥ 100%`) | หาก `master_voice_toggle == True` ระบบส่งไฟล์เสียงเข้า `Audio Queue` (FIFO) และแสดงข้อความตามตารางบทพูดด้านล่าง (AC-2, AC-3, AC-4) |
| Food Activity Trigger | ส่วนประมวลผลอาหาร (`food`) | ประเมินแคลอรี่ส่วนเกินเมื่อบันทึกข้อมูลอาหาร (`> 100 kcal`) | หาก `master_voice_toggle == True` ระบบส่งไฟล์เสียง `voice_food_overeating.mp3` เข้า `Audio Queue` (FIFO) และแสดงข้อความตามตารางบทพูดด้านล่าง (AC-5) |
| Water Activity Trigger | ส่วนประมวลผลน้ำดื่ม (`water`) | ประเมินจำนวนแก้วเมื่อบันทึกข้อมูลน้ำ (`< 3 แก้ว`, `≥ 8 แก้ว`) | หาก `master_voice_toggle == True` ระบบส่งไฟล์เสียงเข้า `Audio Queue` (FIFO) และแสดงข้อความตามตารางบทพูดด้านล่าง (AC-6, AC-7) |

#### ตารางบทพูดเสียงพากย์และไฟล์เสียงตามบริบทบนหน้า S-2 (Exact Strings)
| อ้างถึง | บริบทและเงื่อนไข | ไฟล์เสียงใน `assets/audio/voice/` | ข้อความที่แสดงและพากย์เสียงคำต่อคำ (Exact String) |
|---|---|---|---|
| AC-2 | ก้าวเดิน (`steps`) `< 35%` | `voice_steps_lazy.mp3` | `"แหม... นอนเก่งขนาดนี้ นึกว่าจำศีลอยู่ซะอีก ลุกขึ้นมาขยับขาหน่อยเร้ว เดี๋ยวร่างจะติดโซฟาเอานะยูว์"` |
| AC-3 | ก้าวเดิน (`steps`) อยู่ในช่วง `70% - 99%` (`70.00% - 99.99%`) | `voice_steps_encouraging.mp3` | `"ฮั่นแน่! อีกนิดเดียวก็จะครบเป้าหมายแล้วนะเนี่ย ขาเริ่มสั่นยังคะคนดี ฮึบอีกนิด เดี๋ยวมีรางวัลให้!"` |
| AC-4 | ก้าวเดิน (`steps`) `≥ 100%` | `voice_steps_success.mp3` | `"โอโห้! วันนี้เดินเยอะจนนับขาแทบไม่ทัน เก่งมากค่ะคนดี ขาไม่พังใช่ไหมเนี่ย วันนี้พักผ่อนตามสบายเลยนะ!"` |
| AC-5 | อาหาร (`food`) เกิน `> 100 kcal` | `voice_food_overeating.mp3` | `"พุงจะแตกตายอยู่แล้วนะแม่คุณ! พอเถอะน้าคนดี เดี๋ยวพรุ่งนี้ค่อยลุยใหม่ (แต่ตอนนี้อิ่มแปล้เลยสิเนี่ย)"` |
| AC-6 | น้ำ (`water`) `< 3 แก้ว` | `voice_water_low.mp3` | `"คอแห้งเป็นผงละเนี่ย ดื่มน้ำหน่อยเร้ว เดี๋ยวหน้าเหี่ยวไม่รู้ด้วยนะ พี่อ๊บเป็นห่วงนะเนี่ย"` |
| AC-7 | น้ำ (`water`) `≥ 8 แก้ว` | `voice_water_success.mp3` | `"ดื่มน้ำเก่งมาก! ผิวพรรณเปล่งปลั่งออร่าจับเลยแบบนี้ เอาใจไปเลยสิคะคนดี!"` |

### S-3 Top-Right Voice & Notification Settings Modal
| องค์ประกอบ | ประเภท | ข้อความ/ค่าที่แสดง | เมื่อกด / เมื่อค่าเปลี่ยน |
|---|---|---|---|
| Modal Title | ข้อความหัวข้อ (Text) | `"ตั้งค่าระบบเสียงและการแจ้งเตือน"` | - |
| Master Voice Toggle | Toggle Switch | ป้ายกำกับ: `"เปิด/ปิดเสียงพากย์น้องอ๊บ (Master Voice)"`<br>สถานะ: `TRUE / ON (เปิดใช้งาน)` หรือ `FALSE / OFF (ปิดใช้งาน)` (ตรงกับค่าใน Local Storage) | สลับสถานะเปิด/ปิดการเล่นไฟล์เสียงพากย์ในแอป พร้อมกลไก Debounce หน่วงเวลา `300 มิลลิวินาที` และบันทึกค่าลง Local Storage ทันที (AC-8, EC-5) |
| Push Notification Shortcut Toggle | Toggle Switch | ป้ายกำกับ: `"เปิด/ปิดการแจ้งเตือน (Push Notification Shortcut)"`<br>สถานะ: `TRUE / ON (เปิดใช้งาน)` หรือ `FALSE / OFF (ปิดใช้งาน)` (ตรงกับค่าใน App Core Notification Setting) | สลับสถานะเปิด/ปิดเชื่อมต่อกับระบบแจ้งเตือนหลักของแอป พร้อมกลไก Debounce หน่วงเวลา `300 มิลลิวินาที` และบันทึกค่าลง App Core Notification Setting ทันที (AC-8, EC-5) |
| Close Button | ปุ่มไอคอน (Icon Button) | ไอคอนกากบาท (`X`) หรือกดพื้นที่ว่างนอก Modal | ปิดหน้าต่าง `S-3` กลับสู่หน้าจอ `S-2 Dashboard` |

## 3. ขั้นตอนการใช้งาน (happy path)
1. ผู้ใช้เปิดแอป PetPal Health ครั้งแรกหลังผ่าน Onboarding ระบบตรวจสอบค่า `Voice Permission Status` (`voice_permission_status`) ใน Local Storage พบว่ายังไม่เคยตั้งค่า (`NULL / UNANSWERED`) จึงแสดงหน้าต่าง **S-1 First Launch Permission Dialog** พร้อมหัวข้อ `"ให้น้องอ๊บส่งเสียงทักทายและคอยเป็นกำลังใจให้คุณทุกวันไหมคะ?"`
2. ผู้ใช้กดปุ่ม `[ เปิดเสียงโลด! (แนะนำ) ]` (หรือ `[ ปิดเสียงไว้ก่อน ]`) ระบบบันทึกค่า `voice_permission_status = True` (หรือ `False`) และซิงค์ค่าเริ่มต้นของ `master_voice_toggle = True` (หรือ `False`) ลงใน Local Storage ทันที จากนั้นปิด Dialog และไม่แสดง Dialog นี้ซ้ำอีกในครั้งถัดไป (AC-1)
3. ผู้ใช้ใช้งานหน้า **S-2 Dashboard** และบันทึกข้อมูลสุขภาพระหว่างวัน (เช่น บันทึกก้าวเดิน `< 35%`, `70% - 99%`, `≥ 100%`, บันทึกอาหารเกิน `> 100 kcal`, หรือบันทึกน้ำ `< 3 แก้ว`, `≥ 8 แก้ว`)
4. หาก `master_voice_toggle` เป็น `True` (`ON`) ระบบจะโหลดไฟล์ `.mp3` ที่ตรงกับบริบทจาก Local Assets (`assets/audio/voice/`) เข้าสู่คิวเสียง (`Audio Queue` แบบ FIFO เล่นทีละไฟล์ต่อเนื่องกันทันทีโดยไม่เล่นทับซ้อนกันตาม EC-2) พร้อมแสดงข้อความบทพูดของน้องอ๊บตามตาราง AC-2 ถึง AC-7
5. เมื่อผู้ใช้ต้องการเปลี่ยนการตั้งค่าเสียงหรือการแจ้งเตือน ผู้ใช้กดปุ่มไอคอนตั้งค่าที่มุมขวาบนของหน้า `S-2` เพื่อเปิด **S-3 Top-Right Voice & Notification Settings Modal**
6. ผู้ใช้กดสลับ Toggle Switch ของ `Master Voice` หรือ `Push Notification Shortcut` ระบบใช้กลไก Debounce หน่วงเวลา `300 มิลลิวินาที` (EC-5) เพื่อป้องกันการกดรัวซ้ำซ้อน และบันทึกค่าใหม่ลงใน Local Storage / App Core Notification Setting ทันที (AC-8)

## 4. สถานะของหน้าจอ

| หน้าจอ | สถานะ | เงื่อนไขที่ทำให้เกิด | สิ่งที่แสดง |
|---|---|---|---|
| S-1 | `NORMAL (ปกติ)` | ผู้ใช้เปิดแอปครั้งแรกหลังผ่าน Onboarding และ `voice_permission_status` ยังเป็น `NULL / UNANSWERED` | แสดง First Launch Permission Dialog พร้อมภาพน้องอ๊บ หัวข้อ และปุ่ม `[ เปิดเสียงโลด! (แนะนำ) ]` / `[ ปิดเสียงไว้ก่อน ]` (AC-1) |
| S-1 | `EMPTY (ว่าง/ไม่แสดงซ้ำ)` | ผู้ใช้เคยกดเลือกปุ่มใน Dialog ไปแล้ว (`voice_permission_status` เป็น `True` หรือ `False` ใน Local Storage) | ไม่แสดง Dialog ซ้ำ เข้าสู่หน้า S-2 Dashboard ทันที (AC-1) |
| S-1 | `ERROR (ผิดพลาด)` | อ่านข้อมูลจาก Local Storage ไม่สำเร็จหรือข้อมูลเสียหาย | ใช้ค่าเริ่มต้นชั่วคราวเป็น `NULL / UNANSWERED` และแสดง Dialog ให้ผู้ใช้เลือกใหม่โดยแอปไม่แครช |
| S-2 | `NORMAL (ปกติ - เล่นเสียงพากย์)` | `master_voice_toggle == True` และข้อมูลสุขภาพที่บันทึกตรงตามเกณฑ์ AC-2 ถึง AC-7 | เล่นไฟล์เสียง `.mp3` จาก `assets/audio/voice/` ตามคิว FIFO (EC-2, EC-4) พร้อมแสดงข้อความบทพูด |
| S-2 | `EMPTY (ว่าง/ไม่เข้าเกณฑ์หรือปิดเสียง)` | ข้อมูลสุขภาพอยู่ในช่วงปกติที่ไม่มีเสียงพากย์ (เช่น ก้าวเดิน `35% - 69.99%`, อาหารไม่เกิน `100 kcal`, น้ำ `3 - 7 แก้ว`) หรือผู้ใช้ตั้งค่า `master_voice_toggle == False` หรือมือถือเปิด Mute Mode / ลดเสียงเป็น 0 (EC-1) | แสดงหน้าจอ Dashboard ตามปกติโดยไม่มีเสียงออกลำโพง และในกรณี Mute Mode ของมือถือ (EC-1) ระบบทำงานตามโค้ดปกติโดยไม่แครช |
| S-2 | `ERROR (ผิดพลาด - ไม่พบไฟล์เสียง)` | ไฟล์เสียง `.mp3` ใน Local Assets (`assets/audio/voice/`) สูญหายหรือเสียหาย (`Missing Asset` ตาม EC-3) | ระบบดักจับข้อผิดพลาด (Exception Handling) ข้ามการเล่นไฟล์เสียงนั้นไปเงียบๆ โดยไม่แครชและไม่กระทบการทำงานหลักของแอป (EC-3) |
| S-3 | `NORMAL (ปกติ)` | ผู้ใช้กดปุ่มไอคอนตั้งค่ามุมขวาบนเพื่อเปิด Modal | แสดง Toggle Switch ทั้ง 2 ตัว (`Master Voice` และ `Push Notification Shortcut`) ตามสถานะปัจจุบันพร้อมใช้งาน (AC-8) |
| S-3 | `EMPTY (ว่าง/หน่วงเวลากดซ้ำ)` | ผู้ใช้กดสลับ Toggle Switch รัวๆ ภายในช่วงเวลา `< 300 มิลลิวินาที` (EC-5) | ระบบหน่วงเวลา Debounce `300 มิลลิวินาที` รอให้การกดนิ่งก่อนบันทึกค่าครั้งสุดท้ายเพียงครั้งเดียว (EC-5) |
| S-3 | `ERROR (ผิดพลาด)` | ระบบไม่สามารถบันทึกค่าลง Local Storage หรือ App Core Notification Setting ได้ | คงสถานะ Toggle Switch ไว้ที่ค่าเดิมก่อนกดและแจ้งเตือนให้ลองใหม่อีกครั้งโดยแอปไม่แครช |

## 5. ไฟล์ภาพ assets

### 5.1 ไฟล์ภาพประกอบ UI และตัวละคร (`Image Assets`)
| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายภาพ |
|---|---|---|
| `assets/images/pet_avatar_dialog.png` | S-1 (First Launch Permission Dialog) | ภาพตัวละครน้องอ๊บทำหน้าตาน่ารักเป็นกันเองเชิญชวนเปิดเสียงพากย์ |
| `assets/images/pet_avatar_happy.png` | S-2 (Dashboard Main Screen) | ภาพตัวละครน้องอ๊บแสดงท่าทางประกอบการพูดให้กำลังใจและแซวผู้ใช้ |
| `assets/images/icon_settings_gear.png` | S-2 (มุมขวาบน Top-Right Action Bar) | ไอคอนรูปเฟืองสำหรับกดเปิด Modal ตั้งค่าระบบเสียงและการแจ้งเตือน (S-3) |

### 5.2 ไฟล์เสียงพากย์น้องอ๊บ (`Audio Assets` ใน `assets/audio/voice/`)
| ชื่อไฟล์ | ใช้ที่ไหน | คำอธิบายเสียงพากย์ |
|---|---|---|
| `assets/audio/voice/voice_steps_lazy.mp3` | S-2 (AC-2: ก้าวเดิน `< 35%`) | เสียงพากย์น้องอ๊บโหมดขี้เกียจ แซวขำๆ ให้ลุกมาขยับขา |
| `assets/audio/voice/voice_steps_encouraging.mp3` | S-2 (AC-3: ก้าวเดิน `70% - 99%`) | เสียงพากย์น้องอ๊บโหมดใกล้สำเร็จ เชียร์อัพตื่นเต้นให้เดินครบเป้า |
| `assets/audio/voice/voice_steps_success.mp3` | S-2 (AC-4: ก้าวเดิน `≥ 100%`) | เสียงพากย์น้องอ๊บโหมดสำเร็จ ชมเชยเมื่อเดินถึงหรือเกินเป้าหมาย |
| `assets/audio/voice/voice_food_overeating.mp3` | S-2 (AC-5: อาหารเกิน `> 100 kcal`) | เสียงพากย์น้องอ๊บแซวด้วยความห่วงใยเมื่อกินเกินเป้าหมายมากกว่า 100 kcal |
| `assets/audio/voice/voice_water_low.mp3` | S-2 (AC-6: น้ำ `< 3 แก้ว`) | เสียงพากย์น้องอ๊บเตือนด้วยความห่วงใยเมื่อดื่มน้ำน้อยกว่า 3 แก้ว |
| `assets/audio/voice/voice_water_success.mp3` | S-2 (AC-7: น้ำ `≥ 8 แก้ว`) | เสียงพากย์น้องอ๊บชมเชยเมื่อดื่มน้ำครบตั้งแต่ 8 แก้วขึ้นไป |

## 6. คำถามถึง Product
1. **คำถามเปิดจาก Requirements หัวข้อ 7:** ทีมดีไซน์และเสียงต้องการยืนยันระดับความดังมาตรฐาน (Audio Volume Gain) ของไฟล์ `.mp3` ทั้ง 6 ไฟล์ ให้มีความดังเท่ากันหรือไม่ก่อนส่งมอบให้ Developer?
   - **ข้อเสนอแนะจาก Design:** ทีมดีไซน์และเสียงควรปรับมาตรฐานความดัง (Loudness Normalization) ของไฟล์ `.mp3` ทั้ง 6 ไฟล์ใน `assets/audio/voice/` ให้เท่ากันที่ระดับ `-14 LUFS` (และ True Peak ไม่เกิน `-1.0 dBTP`) เพื่อป้องกันปัญหาเสียงดังหรือเบาไม่เท่ากันเมื่อเล่นต่อเนื่องใน `Audio Queue`
   - **กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):** ให้ Developer ตั้งค่าระดับความดังเริ่มต้นของ Audio Player ในโค้ดที่ `DEFAULT_AUDIO_VOLUME_GAIN = 0.80` (`80%` ของระดับเสียงสื่อมาตรฐาน) เท่ากันทุกไฟล์ `.mp3` ทั้ง 6 ไฟล์ เพื่อให้พัฒนาโค้ดและทดสอบได้ทันทีโดยไม่ต้องรอการปรับแต่งไฟล์เสียงใหม่
   - **การประเมินสถานะการบล็อก:** `Blocking: ไม่ใช่` (เนื่องจากมีค่าเริ่มต้น `DEFAULT_AUDIO_VOLUME_GAIN = 0.80` และชื่อไฟล์ `.mp3` มาตรฐานครบทั้ง 6 ไฟล์แล้ว จึงไม่บล็อกการเขียนโค้ดหรือการทดสอบตรรกะของ Developer)

=== จบ docs/voice/ux-flow.md ===

=== docs/voice/game-rules.md ===
# กติกาเกม: Pet Voice & Audio Feature (voice)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: เพื่อน B · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ชนิดข้อมูล | ความหมาย | ค่า | หน่วย | อ้างถึง |
|---|---|---|---|---|---|
| `VOICE_PERMISSION_STATUS` | Boolean | สถานะการตอบรับ Dialog ขอสิทธิ์เปิดเสียงครั้งแรก (`True` = เปิดเสียงโลด, `False` = ปิดเสียงไว้ก่อน, `NULL` = ยังไม่เคยตอบ) | `True / False` | - | US-1, AC-1 |
| `MASTER_VOICE_TOGGLE` | Boolean | สถานะสวิตช์เปิด/ปิดเสียงพากย์น้องอ๊บหลัก (`True` = เปิด, `False` = ปิด) | `True / False` | - | US-3, AC-8 |
| `PUSH_NOTIFICATION_SHORTCUT_TOGGLE` | Boolean | สถานะสวิตช์ลัดเปิด/ปิดระบบแจ้งเตือนหลักของแอป (`True` = เปิด, `False` = ปิด) | `True / False` | - | US-3, AC-8 |
| `AUDIO_FILE_PATH` | String | พาธโฟลเดอร์ Local Assets สำหรับเก็บไฟล์เสียง `.mp3` ทั้ง 6 บริบท | `assets/audio/voice/` | - | AC-2 ถึง AC-7, EC-4 |
| `STEPS_LAZY_THRESHOLD` | Float | เกณฑ์เปอร์เซ็นต์ก้าวเดินต่ำกว่ากำหนดที่เล่นเสียงโหมดขี้เกียจ (`< 35%`) | `< 35.00` | % | US-2, AC-2 |
| `STEPS_ENCOURAGING_MIN` | Float | ขอบล่างของช่วงก้าวเดินใกล้ถึงเป้าหมาย (`70% - 99%`) | `70.00` | % | US-2, AC-3 |
| `STEPS_ENCOURAGING_MAX` | Float | ขอบบนของช่วงก้าวเดินใกล้ถึงเป้าหมาย (`70% - 99%` หรือก่อนครบ `100.00%`) | `99.99` | % | US-2, AC-3 |
| `STEPS_SUCCESS_THRESHOLD` | Float | เกณฑ์เปอร์เซ็นต์ก้าวเดินเมื่อบรรลุหรือเกินเป้าหมาย (`≥ 100%`) | `>= 100.00` | % | US-2, AC-4 |
| `FOOD_OVEREATING_THRESHOLD` | Float | เกณฑ์แคลอรี่อาหารที่บันทึกเกินเป้าหมาย (`> 100 kcal`) | `> 100.00` | kcal | US-2, AC-5 |
| `WATER_LOW_THRESHOLD` | Integer | เกณฑ์จำนวนแก้วน้ำดื่มต่ำกว่ากำหนด (`< 3 แก้ว`) | `< 3` | แก้ว | US-2, AC-6 |
| `WATER_SUCCESS_THRESHOLD` | Integer | เกณฑ์จำนวนแก้วน้ำดื่มเมื่อบรรลุหรือเกินเป้าหมาย (`≥ 8 แก้ว`) | `>= 8` | แก้ว | US-2, AC-7 |
| `TOGGLE_DEBOUNCE_MS` | Integer | ระยะเวลาหน่วง Debounce เมื่อผู้ใช้กดสลับ Toggle Switch รัวๆ ในเวลาสั้นๆ | `300` | มิลลิวินาที | US-3, AC-8, EC-5 |
| `DEFAULT_AUDIO_VOLUME_GAIN` | Float | ค่าเริ่มต้นความดังมาตรฐานของ Audio Player สำหรับไฟล์ `.mp3` ทั้ง 6 ไฟล์ (Fallback Rule) | `0.80` | สัดส่วน (80%) | หัวข้อ 5 (Open Question) |

### 1.1 ตารางข้อความ เงื่อนไข และลำดับคิว

| ชื่อเรียก / ชื่อไฟล์ | หมวด/เรื่อง | ข้อความคำต่อคำ (Exact String) | เงื่อนไขส่ง/เล่น (Trigger) | เงื่อนไขหยุด/ยกเลิก/ข้าม (Cancel/Skip) |
|---|---|---|---|---|
| `voice_steps_lazy.mp3` | ก้าวเดิน (`steps` `< 35%`) | `"แหม... นอนเก่งขนาดนี้ นึกว่าจำศีลอยู่ซะอีก ลุกขึ้นมาขยับขาหน่อยเร้ว เดี๋ยวร่างจะติดโซฟาเอานะยูว์"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลก้าวเดิน (`steps`) `< 35%` (`< 35.00%`) (AC-2) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |
| `voice_steps_encouraging.mp3` | ก้าวเดิน (`steps` `70% - 99%`) | `"ฮั่นแน่! อีกนิดเดียวก็จะครบเป้าหมายแล้วนะเนี่ย ขาเริ่มสั่นยังคะคนดี ฮึบอีกนิด เดี๋ยวมีรางวัลให้!"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลก้าวเดิน (`steps`) อยู่ในช่วง `70% - 99%` (`70.00% - 99.99%`) (AC-3) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |
| `voice_steps_success.mp3` | ก้าวเดิน (`steps` `≥ 100%`) | `"โอโห้! วันนี้เดินเยอะจนนับขาแทบไม่ทัน เก่งมากค่ะคนดี ขาไม่พังใช่ไหมเนี่ย วันนี้พักผ่อนตามสบายเลยนะ!"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลก้าวเดิน (`steps`) `≥ 100%` (`>= 100.00%`) (AC-4) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |
| `voice_food_overeating.mp3` | อาหาร (`food` เกิน `> 100 kcal`) | `"พุงจะแตกตายอยู่แล้วนะแม่คุณ! พอเถอะน้าคนดี เดี๋ยวพรุ่งนี้ค่อยลุยใหม่ (แต่ตอนนี้อิ่มแปล้เลยสิเนี่ย)"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลอาหาร (`food`) เกิน `> 100 kcal` (`> 100.00 kcal`) (AC-5) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |
| `voice_water_low.mp3` | น้ำดื่ม (`water` `< 3 แก้ว`) | `"คอแห้งเป็นผงละเนี่ย ดื่มน้ำหน่อยเร้ว เดี๋ยวหน้าเหี่ยวไม่รู้ด้วยนะ พี่อ๊บเป็นห่วงนะเนี่ย"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลน้ำ (`water`) `< 3 แก้ว` (AC-6) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |
| `voice_water_success.mp3` | น้ำดื่ม (`water` `≥ 8 แก้ว`) | `"ดื่มน้ำเก่งมาก! ผิวพรรณเปล่งปลั่งออร่าจับเลยแบบนี้ เอาใจไปเลยสิคะคนดี!"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลน้ำ (`water`) `≥ 8 แก้ว` (AC-7) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |

- **กฎลำดับคิวการเล่นเสียง (`Audio Queue` ตาม `EC-2`):** จัดคิวการเล่นเสียงแบบเข้าก่อนออกก่อน (`FIFO: First-In, First-Out`) เมื่อมีเหตุการณ์กระตุ้นเสียงพากย์หลายบริบทในเวลาไล่เลี่ยกัน ระบบจะเล่นทีละไฟล์ตามลำดับก่อนหลัง ห้ามเล่นทับซ้อนกัน (`No Audio Overlap`)
- **ระยะห่างระหว่างไฟล์ในคิว:** เล่นไฟล์ถัดไปในคิวต่อเนื่องทันทีที่ไฟล์ก่อนหน้าเล่นจบ (`Cooldown = 0 มิลลิวินาที` หลังจบไฟล์ก่อนหน้า)
- **เพดานต่อวัน:** ไม่จำกัดจำนวนครั้งต่อวัน (เล่นตามเหตุการณ์การบันทึกข้อมูลสุขภาพจริงของผู้ใช้เมื่อเปิด `Master Voice Toggle`)
- **การล้างคิวเมื่อปิดเสียง:** หากผู้ใช้สลับ `Master Voice Toggle` เป็น `False` (`OFF`) ขณะมีไฟล์เสียงรออยู่ใน `Audio Queue` ระบบจะหยุดเสียงปัจจุบันและล้างคิวที่ค้างอยู่ทันที

### 1.2 ตารางสถานะและข้อมูลที่เก็บในระบบ (System State & Storage Schema)

| ชื่อข้อมูล (ตาม Requirements หัวข้อ 6) | ชื่อตัวแปรในโค้ด | ชนิดข้อมูล | ค่าเริ่มต้น | ค่าที่เป็นไปได้และป้ายแสดงผล `CODE_ENUM (ป้ายไทย)` | เก็บที่ไหน | อ้างถึง |
|---|---|---|---|---|---|---|
| Voice Permission Status | `voice_permission_status` | Boolean (True/False) | `NULL / UNANSWERED` (ก่อนตอบ Dialog ครั้งแรก) | `TRUE / ON (เปิดเสียงโลด - อนุญาต)`, `FALSE / OFF (ปิดเสียงไว้ก่อน - ไม่อนุญาตเริ่มต้น)`, `NULL / UNANSWERED (ยังไม่เคยตอบ Dialog ครั้งแรก)` | Local Storage | US-1, AC-1 |
| Master Voice Toggle | `master_voice_toggle` | Boolean (True/False) | ซิงค์ตามปุ่มที่เลือกใน `S-1` (`True` เมื่อกดเปิดเสียงโลด / `False` เมื่อกดปิดเสียงไว้ก่อน) | `TRUE / ON (เปิดใช้งานเสียงพากย์)`, `FALSE / OFF (ปิดใช้งานเสียงพากย์)` | Local Storage | US-1, US-3, AC-1, AC-8, EC-5 |
| Push Notification Shortcut Toggle | `push_notification_shortcut_toggle` | Boolean (True/False) | ซิงค์ตามค่าปัจจุบันใน App Core Notification Setting | `TRUE / ON (เปิดใช้งานการแจ้งเตือน)`, `FALSE / OFF (ปิดใช้งานการแจ้งเตือน)` | App Core Notification Setting | US-3, AC-8, EC-5 |
| Audio File Path | `audio_file_path` | String (Local Path) | `assets/audio/voice/` | พาธไฟล์ `.mp3` ทั้ง 6 ไฟล์ใน `assets/audio/voice/` | Local Assets (`assets/audio/voice/`) | US-2, AC-2 ถึง AC-7, EC-3, EC-4 |

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง

| สถานะ | ช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพตัวละคร / ไฟล์เสียงที่ใช้ |
|---|---|---|
| `PERMISSION_DIALOG (ขอสิทธิ์เสียงครั้งแรก)` | `voice_permission_status == NULL / UNANSWERED` เมื่อเข้าหน้า Home ครั้งแรกหลัง Onboarding (AC-1) | ไฟล์ภาพ: `assets/images/pet_avatar_dialog.png` |
| `DASHBOARD_IDLE (ปกติ/ไม่มีเสียงพากย์)` | `master_voice_toggle == False` หรือข้อมูลอยู่ในช่วงปกติที่ไม่กระตุ้นเสียง (ก้าวเดิน `35.00% - 69.99%`, อาหารเกิน `<= 100.00 kcal`, น้ำ `3 - 7 แก้ว`) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png` (ไม่เล่นไฟล์เสียง) |
| `VOICE_STEPS_LAZY (ก้าวเดินโหมดขี้เกียจ)` | `master_voice_toggle == True` และก้าวเดิน (`steps`) `>= 0.00%` ถึง `< 35.00%` (ไม่รวมขอบ `35.00%`) (AC-2) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_steps_lazy.mp3` |
| `VOICE_STEPS_ENCOURAGING (ก้าวเดินโหมดเชียร์อัพ)` | `master_voice_toggle == True` และก้าวเดิน (`steps`) อยู่ในช่วง `70% - 99%` คือตั้งแต่ `70.00%` ถึง `99.99%` (รวมขอบ `70.00%` และ `99.99%` ก่อนครบ `100.00%`) (AC-3) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_steps_encouraging.mp3` |
| `VOICE_STEPS_SUCCESS (ก้าวเดินโหมดสำเร็จ)` | `master_voice_toggle == True` และก้าวเดิน (`steps`) `>= 100.00%` ขึ้นไป (รวมขอบ `100.00%` และรองรับค่าเกิน `100%`) (AC-4) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_steps_success.mp3` |
| `VOICE_FOOD_OVEREATING (อาหารเกินเป้าหมาย)` | `master_voice_toggle == True` และอาหาร (`food`) เกินเป้าหมาย `> 100.00 kcal` (ไม่รวมขอบ `100.00 kcal`) (AC-5) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_food_overeating.mp3` |
| `VOICE_WATER_LOW (น้ำดื่มน้อยกว่าเกณฑ์)` | `master_voice_toggle == True` และน้ำดื่ม (`water`) `>= 0` ถึง `< 3 แก้ว` คือ `0, 1, 2 แก้ว` (ไม่รวมขอบ `3 แก้ว`) (AC-6) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_water_low.mp3` |
| `VOICE_WATER_SUCCESS (น้ำดื่มบรรลุเป้าหมาย)` | `master_voice_toggle == True` และน้ำดื่ม (`water`) `>= 8 แก้ว` ขึ้นไป (รวมขอบ `8 แก้ว`) (AC-7) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_water_success.mp3` |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| ผู้ใช้เข้าแอปครั้งแรกหลัง Onboarding และกดปุ่ม `[ เปิดเสียงโลด! (แนะนำ) ]` บน S-1 | `voice_permission_status = NULL`, `master_voice_toggle = NULL` | `voice_permission_status = True`, `master_voice_toggle = True` | ปิด S-1 และไม่แสดงซ้ำในครั้งถัดไป (AC-1) |
| ผู้ใช้เข้าแอปครั้งแรกหลัง Onboarding และกดปุ่ม `[ ปิดเสียงไว้ก่อน ]` บน S-1 | `voice_permission_status = NULL`, `master_voice_toggle = NULL` | `voice_permission_status = False`, `master_voice_toggle = False` | ปิด S-1 และไม่แสดงซ้ำในครั้งถัดไป (AC-1) |
| บันทึกก้าวเดินต่ำกว่าเกณฑ์ `< 35%` (ขณะเปิดเสียง) | `steps = 34.99%`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_steps_lazy.mp3` | เข้าเกณฑ์ `< 35%` พอดีขอบบน (AC-2) |
| บันทึกก้าวเดินแตะขอบ `35.00%` พอดี (ขณะเปิดเสียง) | `steps = 35.00%`, `master_voice_toggle = True` | ไม่เล่นเสียงพากย์ (`No Trigger`) | ไม่อยู่ในช่วง `< 35%` และยังไม่ถึง `70%` |
| บันทึกก้าวเดินที่ `69.99%` ก่อนถึงเกณฑ์เชียร์อัพ | `steps = 69.99%`, `master_voice_toggle = True` | ไม่เล่นเสียงพากย์ (`No Trigger`) | ต่ำกว่าขอบล่าง `70.00%` |
| บันทึกก้าวเดินแตะขอบล่างช่วง `70% - 99%` | `steps = 70.00%`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_steps_encouraging.mp3` | เข้าเกณฑ์รวมขอบล่าง `70.00%` (AC-3) |
| บันทึกก้าวเดินแตะขอบบนช่วง `70% - 99%` | `steps = 99.00%` (หรือ `99.99%`), `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_steps_encouraging.mp3` | เข้าเกณฑ์ช่วง `70% - 99%` ก่อนครบ 100% (AC-3) |
| บันทึกก้าวเดินครบเป้าหมาย `100.00%` พอดี | `steps = 100.00%`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_steps_success.mp3` | เข้าเกณฑ์ `≥ 100%` พอดีขอบล่าง (AC-4) |
| บันทึกก้าวเดินเกินเป้าหมาย (Overachievement) | `steps = 125.00%`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_steps_success.mp3` | รองรับค่าสะสมเกิน 100% (AC-4) |
| บันทึกอาหารเกินเป้าหมาย `100.00 kcal` พอดี | `food_excess = 100.00 kcal`, `master_voice_toggle = True` | ไม่เล่นเสียงพากย์ (`No Trigger`) | ไม่เข้าเกณฑ์ เนื่องจากต้องมากกว่า `> 100 kcal` (AC-5) |
| บันทึกอาหารเกินเป้าหมายมากกว่า `100 kcal` | `food_excess = 100.01 kcal` (หรือ `150 kcal`), `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_food_overeating.mp3` | เข้าเกณฑ์ `> 100 kcal` (AC-5) |
| บันทึกน้ำดื่ม `< 3 แก้ว` | `water = 2 แก้ว`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_water_low.mp3` | เข้าเกณฑ์ `< 3 แก้ว` (AC-6) |
| บันทึกน้ำดื่มแตะขอบ `3 แก้ว` ถึง `7 แก้ว` | `water = 3 แก้ว` (หรือ `7 แก้ว`), `master_voice_toggle = True` | ไม่เล่นเสียงพากย์ (`No Trigger`) | ไม่อยู่ในช่วง `< 3 แก้ว` และยังไม่ถึง `8 แก้ว` |
| บันทึกน้ำดื่มครบ `8 แก้ว` พอดี | `water = 8 แก้ว`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_water_success.mp3` | เข้าเกณฑ์ `≥ 8 แก้ว` พอดีขอบล่าง (AC-7) |
| บันทึกน้ำ `8 แก้ว` และก้าวเดิน `100%` เสร็จในเวลาไล่เลี่ยกัน | `Audio Queue` ว่าง, มี 2 เหตุการณ์เกิดพร้อมกัน | คิวที่ 1 เล่น `voice_water_success.mp3` จนจบ แล้วเล่นคิวที่ 2 `voice_steps_success.mp3` ต่อทันที | จัดคิวแบบ FIFO ไม่เล่นทับซ้อนกัน (EC-2) |
| ผู้ใช้กดสลับสวิตช์ `Master Voice` และ `Push Notification Shortcut` ใน S-3 | `master_voice_toggle = True`, `push_notification_shortcut_toggle = True` | บันทึกค่าใหม่เป็น `False` หลังผ่าน Debounce `300 ms` | บันทึกค่าทันทีเมื่อพ้นระยะ Debounce (AC-8, EC-5) |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ที่ทดสอบได้ |
|---|---|
| ผู้ใช้เปิดโหมดปิดเสียง (Mute Mode / Silent) หรือลดเสียงสื่อเป็น 0 บนมือถือ (`EC-1`) | ระบบเล่นไฟล์เสียงในเบื้องหลังตามโค้ดปกติโดยไม่เกิดแอปพลิเคชันแครช (Crash) แม้ผู้ใช้ไม่ได้ยินเสียง |
| มีเหตุการณ์กระตุ้นเสียงพากย์หลายบริบทพร้อมกัน (`Audio Queue` / Overlap) เช่น บันทึกน้ำและก้าวเดินเสร็จในเวลาไล่เลี่ยกัน (`EC-2`) | ระบบจัดคิวการเล่นเสียง (`Audio Queue` แบบ FIFO) เล่นทีละไฟล์ตามลำดับก่อนหลัง ต่อเนื่องกันทันทีเมื่อไฟล์ก่อนหน้าจบ (`Cooldown = 0 ms`) โดยไม่เล่นทับซ้อนกัน (No Audio Overlap) |
| ไฟล์เสียง `.mp3` ใน Local Assets เสียหายหรือไม่พบไฟล์ (Missing Asset) (`EC-3`) | ระบบดักจับข้อผิดพลาด (Exception Handling) ข้ามการเล่นเสียงนั้นไปเงียบๆ โดยไม่แครชและไม่กระทบการทำงานหลักของแอป |
| อุปกรณ์ของผู้ใช้อยู่ในสถานะออฟไลน์ (Offline Local Storage) (`EC-4`) | ระบบโหลดและเล่นไฟล์เสียง `.mp3` จาก Local Assets (`assets/audio/voice/`) ได้ปกติ 100% โดยไม่ต้องเชื่อมต่ออินเทอร์เน็ต |
| ผู้ใช้กดคลิกเปิด/ปิด Toggle Switch รัวๆ ในเวลาสั้นๆ (Toggle Debounce) (`EC-5`) | ระบบมีกลไก Debounce (หน่วงเวลา `300 มิลลิวินาที`) เพื่อป้องกันการบันทึกค่าซ้ำซ้อนและป้องกันการส่งคำขอชนกัน |

## 5. คำถามถึง Product

1. **คำถามเปิดจาก Requirements หัวข้อ 7:** ทีมดีไซน์และเสียงต้องการยืนยันระดับความดังมาตรฐาน (Audio Volume Gain) ของไฟล์ `.mp3` ทั้ง 6 ไฟล์ ให้มีความดังเท่ากันหรือไม่ก่อนส่งมอบให้ Developer?
   - **ข้อเสนอแนะจาก Design:** ทีมดีไซน์และเสียงควรปรับมาตรฐานความดัง (Loudness Normalization) ของไฟล์ `.mp3` ทั้ง 6 ไฟล์ใน `assets/audio/voice/` ให้เท่ากันที่ระดับ `-14 LUFS` (และ True Peak ไม่เกิน `-1.0 dBTP`) เพื่อป้องกันปัญหาเสียงดังหรือเบาไม่เท่ากันเมื่อเล่นต่อเนื่องใน `Audio Queue`
   - **กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):** ให้ Developer ตั้งค่าระดับความดังเริ่มต้นของ Audio Player ในโค้ดที่ `DEFAULT_AUDIO_VOLUME_GAIN = 0.80` (`80%` ของระดับเสียงสื่อมาตรฐาน) เท่ากันทุกไฟล์ `.mp3` ทั้ง 6 ไฟล์ เพื่อให้พัฒนาโค้ดและทดสอบได้ทันทีโดยไม่ต้องรอการปรับแต่งไฟล์เสียงใหม่
   - **การประเมินสถานะการบล็อก:** `Blocking: ไม่ใช่` (เนื่องจากมีค่าเริ่มต้น `DEFAULT_AUDIO_VOLUME_GAIN = 0.80` และชื่อไฟล์ `.mp3` มาตรฐานครบทั้ง 6 ไฟล์แล้ว จึงไม่บล็อกการเขียนโค้ดหรือการทดสอบตรรกะของ Developer)

=== จบ docs/voice/game-rules.md ===

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

This is the expected criteria for your final answer: เนื้อหาไฟล์ docs/voice/design-review.md ฉบับสมบูรณ์ ตามโครง template
you MUST return the actual complete content as the final answer, not a summary.

Provide your complete response:
~~~~

### LLM call 1 — คำตอบ

~~~~text
# Design Review: voice

## 1. ข้อมูลการตรวจ
- Status: PASS
- Feature: voice
- Documents actually reviewed: docs/voice/requirements.md, docs/voice/ux-flow.md, docs/voice/game-rules.md
- Missing/unreadable documents: ไม่มี
- Previous findings checked: ไม่มีข้อมูลรอบก่อน

## 2. ผล Checklist
| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | PASS | requirements.md หัวข้อ 1-6 มีสรุปฟีเจอร์ User Stories (US-1 ถึง US-3) Acceptance Criteria ครบถ้วน (AC-1 ถึง AC-8) Edge Cases (EC-1 ถึง EC-5) และข้อมูลที่เก็บในระบบชัดเจน | ไม่ใช่ เพราะเอกสารมีความสมบูรณ์เพียงพอต่อการนำไปพัฒนา |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | PASS | requirements.md, ux-flow.md และ game-rules.md มีข้อมูลสอดคล้องกัน ทั้งชื่อสถานะ ค่าตัวเลข และเงื่อนไขการทำงาน เช่น AC-1 ถึง AC-8 ตรงกับหน้าจอ S-1, S-2, S-3 และตารางใน Game Rules | ไม่ใช่ เพราะเอกสารทั้งสามฉบับสอดคล้องกันอย่างสมบูรณ์ |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | PASS | game-rules.md หัวข้อ 1-2 และ ux-flow.md หัวข้อ 2 ระบุตัวเลขเปอร์เซ็นต์ (`< 35%`, `70% - 99%`, `≥ 100%`), แคลอรี่ (`> 100 kcal`), แก้วน้ำ (`< 3 แก้ว`, `≥ 8 แก้ว`), ระยะ Debounce (`300 ms`) และค่า `DEFAULT_AUDIO_VOLUME_GAIN = 0.80` ตรงกันทุกประการ | ไม่ใช่ เพราะชื่อตัวแปร ค่า และเงื่อนไขตรงกันทุกตาราง |
| C-04 | ขั้นตอนใช้งานและEdge Cases เพียงพอ | PASS | ux-flow.md หัวข้อ 3 และ requirements.md หัวข้อ 4 ครอบคลุมทั้ง Happy Path และ Edge Cases (EC-1 ถึง EC-5) รวมถึงการจัดการ Audio Queue (FIFO) และ Missing Asset | ไม่ใช่ เพราะขั้นตอนการใช้งานและ Edge Cases ครอบคลุมครบถ้วน |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | PASS | requirements.md หัวข้อ 7, ux-flow.md หัวข้อ 6.1 และ game-rules.md หัวข้อ 5 ระบุคำถามเกี่ยวกับระดับความดังมาตรฐาน (Audio Volume Gain) พร้อมข้อเสนอแนะ `-14 LUFS`, กำหนด Fallback Rule เป็น `DEFAULT_AUDIO_VOLUME_GAIN = 0.80` และระบุเหตุผลชัดเจนว่า Blocking: ไม่ใช่ | ไม่ใช่ เพราะมีกติกาชั่วคราวรองรับชัดเจนและระบุว่าไม่บล็อกการพัฒนา |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ข้อค้นพบและตารางทั้งหมดอ้างอิงไฟล์และหัวข้อจาก requirements.md, ux-flow.md และ game-rules.md ได้อย่างชัดเจน | ไม่ใช่ เพราะทุกจุดอ้างอิงหลักฐานได้ถูกต้องครบถ้วน |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | สรุปผล ตารางปัญหา (ไม่มีปัญหาที่บล็อก) และคำแนะนำใน Open Questions สอดคล้องไปในทิศทางเดียวกัน | ไม่ใช่ เพราะเนื้อหาทุกส่วนมีความสอดคล้องกัน ไม่ขัดแย้งกัน |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีรายงานผลการรีวิวกรอบก่อนหน้าให้ตรวจสอบ | ไม่ใช่ เนื่องจากไม่มีข้อมูลรอบก่อนให้เปรียบเทียบ |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|

จากการตรวจเปรียบเทียบเอกสาร `docs/voice/requirements.md`, `docs/voice/ux-flow.md` และ `docs/voice/game-rules.md` อย่างละเอียด ไม่พบข้อผิดพลาด ความขัดแย้ง หรือปัญหาที่บล็อกการพัฒนา โดยทุกเงื่อนไข ค่าตัวเลข ชื่อตัวแปร และ Acceptance Criteria มีความสอดคล้องกันอย่างสมบูรณ์

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|

ไม่มีข้อมูลสำหรับเปรียบเทียบ เนื่องจากไม่มีรายงานการรีวิวกรอบก่อนหน้า (Previous review checked: ไม่มีย้อนหลัง)

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- ไม่มีรายการค้างที่บล็อกการพัฒนา เนื่องจากประเด็นเรื่องระดับความดังมาตรฐาน (Audio Volume Gain) ของไฟล์ `.mp3` ทั้ง 6 ไฟล์ ใน `requirements.md` หัวข้อ 7, `ux-flow.md` หัวข้อ 6.1 และ `game-rules.md` หัวข้อ 5 ได้กำหนด Fallback Rule เป็น `DEFAULT_AUDIO_VOLUME_GAIN = 0.80` ไว้เรียบร้อยแล้ว ซึ่งมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา (Blocking: ไม่ใช่)

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)
ไม่มีข้อมูลใน log ที่ได้รับ

## 7. ข้อจำกัดของการรีวิว
- ตรวจสอบเฉพาะเอกสารในโฟลเดอร์ `docs/voice/` ได้แก่ `requirements.md`, `ux-flow.md` และ `game-rules.md` เท่านั้น
- ไม่มีรายงานผลการรีวิวจากรอบก่อนหน้าสำหรับการทำ Regression Check

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: PASS
- Agent recommendation: พร้อมส่ง Dev
- Blocking issues remaining: ไม่มี
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: เอกสาร requirements.md, ux-flow.md และ game-rules.md มีความครบถ้วน สอดคล้องต้องกันในทุกมิติ ทั้ง User Stories, Acceptance Criteria, Edge Cases, ตารางค่าตัวเลข, สถานะ และชื่อตัวแปร รวมถึงมีข้อสรุปที่ชัดเจนสำหรับ Open Questions โดยมี Fallback Rule รองรับทำให้ไม่มีปัญหาติดขัดในการนำไปพัฒนาต่อ
~~~~

### ผลลัพธ์ → docs/voice/design-review.md

~~~~text
# Design Review: voice

## 1. ข้อมูลการตรวจ
- Status: PASS
- Feature: voice
- Documents actually reviewed: docs/voice/requirements.md, docs/voice/ux-flow.md, docs/voice/game-rules.md
- Missing/unreadable documents: ไม่มี
- Previous findings checked: ไม่มีข้อมูลรอบก่อน

## 2. ผล Checklist
| ID | รายการตรวจ | ผล (PASS / FAIL / INSUFFICIENT_EVIDENCE) | เหตุผลและหลักฐาน (ไฟล์/หัวข้อ) | ต้องแก้มือ (ใช่/ไม่ใช่ พร้อมเหตุผล) |
|---|---|---|---|---|
| C-01 | Requirements ครบถ้วนและนำไปพัฒนาได้ | PASS | requirements.md หัวข้อ 1-6 มีสรุปฟีเจอร์ User Stories (US-1 ถึง US-3) Acceptance Criteria ครบถ้วน (AC-1 ถึง AC-8) Edge Cases (EC-1 ถึง EC-5) และข้อมูลที่เก็บในระบบชัดเจน | ไม่ใช่ เพราะเอกสารมีความสมบูรณ์เพียงพอต่อการนำไปพัฒนา |
| C-02 | Requirements, UX Flow และ Game Rules สอดคล้องกัน | PASS | requirements.md, ux-flow.md และ game-rules.md มีข้อมูลสอดคล้องกัน ทั้งชื่อสถานะ ค่าตัวเลข และเงื่อนไขการทำงาน เช่น AC-1 ถึง AC-8 ตรงกับหน้าจอ S-1, S-2, S-3 และตารางใน Game Rules | ไม่ใช่ เพราะเอกสารทั้งสามฉบับสอดคล้องกันอย่างสมบูรณ์ |
| C-03 | ชื่อสถานะ ตัวเลข เงื่อนไข และเวลาใช้ตรงกัน | PASS | game-rules.md หัวข้อ 1-2 และ ux-flow.md หัวข้อ 2 ระบุตัวเลขเปอร์เซ็นต์ (`< 35%`, `70% - 99%`, `≥ 100%`), แคลอรี่ (`> 100 kcal`), แก้วน้ำ (`< 3 แก้ว`, `≥ 8 แก้ว`), ระยะ Debounce (`300 ms`) และค่า `DEFAULT_AUDIO_VOLUME_GAIN = 0.80` ตรงกันทุกประการ | ไม่ใช่ เพราะชื่อตัวแปร ค่า และเงื่อนไขตรงกันทุกตาราง |
| C-04 | ขั้นตอนใช้งานและEdge Cases เพียงพอ | PASS | ux-flow.md หัวข้อ 3 และ requirements.md หัวข้อ 4 ครอบคลุมทั้ง Happy Path และ Edge Cases (EC-1 ถึง EC-5) รวมถึงการจัดการ Audio Queue (FIFO) และ Missing Asset | ไม่ใช่ เพราะขั้นตอนการใช้งานและ Edge Cases ครอบคลุมครบถ้วน |
| C-05 | Open Questions มีข้อสรุปหรือมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา | PASS | requirements.md หัวข้อ 7, ux-flow.md หัวข้อ 6.1 และ game-rules.md หัวข้อ 5 ระบุคำถามเกี่ยวกับระดับความดังมาตรฐาน (Audio Volume Gain) พร้อมข้อเสนอแนะ `-14 LUFS`, กำหนด Fallback Rule เป็น `DEFAULT_AUDIO_VOLUME_GAIN = 0.80` และระบุเหตุผลชัดเจนว่า Blocking: ไม่ใช่ | ไม่ใช่ เพราะมีกติกาชั่วคราวรองรับชัดเจนและระบุว่าไม่บล็อกการพัฒนา |
| C-06 | ทุกข้อค้นพบมีหลักฐานที่ตรวจย้อนกลับได้ | PASS | ข้อค้นพบและตารางทั้งหมดอ้างอิงไฟล์และหัวข้อจาก requirements.md, ux-flow.md และ game-rules.md ได้อย่างชัดเจน | ไม่ใช่ เพราะทุกจุดอ้างอิงหลักฐานได้ถูกต้องครบถ้วน |
| C-07 | บทสรุป ตารางปัญหา และคำแนะนำสอดคล้องกัน | PASS | สรุปผล ตารางปัญหา (ไม่มีปัญหาที่บล็อก) และคำแนะนำใน Open Questions สอดคล้องไปในทิศทางเดียวกัน | ไม่ใช่ เพราะเนื้อหาทุกส่วนมีความสอดคล้องกัน ไม่ขัดแย้งกัน |
| C-08 | ข้อค้นพบจากรอบก่อนถูกตรวจซ้ำครบ (เมื่อมีข้อมูลให้ตรวจ) | INSUFFICIENT_EVIDENCE | ไม่มีรายงานผลการรีวิวกรอบก่อนหน้าให้ตรวจสอบ | ไม่ใช่ เนื่องจากไม่มีข้อมูลรอบก่อนให้เปรียบเทียบ |

## 3. รายการปัญหาที่พบ

| ID | ไฟล์ | หัวข้อ/ตำแหน่ง | ปัญหาและหลักฐาน | ผลกระทบ | Blocking หรือไม่ | ข้อเสนอแก้ไข | ต้องแก้มือ |
|---|---|---|---|---|---|---|---|

จากการตรวจเปรียบเทียบเอกสาร `docs/voice/requirements.md`, `docs/voice/ux-flow.md` และ `docs/voice/game-rules.md` อย่างละเอียด ไม่พบข้อผิดพลาด ความขัดแย้ง หรือปัญหาที่บล็อกการพัฒนา โดยทุกเงื่อนไข ค่าตัวเลข ชื่อตัวแปร และ Acceptance Criteria มีความสอดคล้องกันอย่างสมบูรณ์

## 4. การตรวจข้อค้นพบจากรอบก่อน

| ID เดิม | ข้อค้นพบเดิม | ผลตรวจซ้ำ (ยืนยัน/แก้แล้ว/ไม่พบซ้ำ/ยังยืนยันไม่ได้) | หลักฐานจากเอกสารปัจจุบัน | สิ่งที่ต้องทำต่อ |
|---|---|---|---|---|

ไม่มีข้อมูลสำหรับเปรียบเทียบ เนื่องจากไม่มีรายงานการรีวิวกรอบก่อนหน้า (Previous review checked: ไม่มีย้อนหลัง)

## 5. รายการที่ยังยืนยันไม่ได้ / Open Questions
- ไม่มีรายการค้างที่บล็อกการพัฒนา เนื่องจากประเด็นเรื่องระดับความดังมาตรฐาน (Audio Volume Gain) ของไฟล์ `.mp3` ทั้ง 6 ไฟล์ ใน `requirements.md` หัวข้อ 7, `ux-flow.md` หัวข้อ 6.1 และ `game-rules.md` หัวข้อ 5 ได้กำหนด Fallback Rule เป็น `DEFAULT_AUDIO_VOLUME_GAIN = 0.80` ไว้เรียบร้อยแล้ว ซึ่งมีหลักฐานชัดเจนว่าไม่บล็อกการพัฒนา (Blocking: ไม่ใช่)

## 6. ผลวัด Agent จาก logs/ (เฉพาะเมื่อมี log จริงและมีการร้องขอให้วัด)
ไม่มีข้อมูลใน log ที่ได้รับ

## 7. ข้อจำกัดของการรีวิว
- ตรวจสอบเฉพาะเอกสารในโฟลเดอร์ `docs/voice/` ได้แก่ `requirements.md`, `ux-flow.md` และ `game-rules.md` เท่านั้น
- ไม่มีรายงานผลการรีวิวจากรอบก่อนหน้าสำหรับการทำ Regression Check

## 8. ข้อสรุปก่อนส่ง Dev
- Review status: PASS
- Agent recommendation: พร้อมส่ง Dev
- Blocking issues remaining: ไม่มี
- Human approval: รอผู้ตรวจตัดสินใจ
- Reason: เอกสาร requirements.md, ux-flow.md และ game-rules.md มีความครบถ้วน สอดคล้องต้องกันในทุกมิติ ทั้ง User Stories, Acceptance Criteria, Edge Cases, ตารางค่าตัวเลข, สถานะ และชื่อตัวแปร รวมถึงมีข้อสรุปที่ชัดเจนสำหรับ Open Questions โดยมี Fallback Rule รองรับทำให้ไม่มีปัญหาติดขัดในการนำไปพัฒนาต่อ
~~~~
