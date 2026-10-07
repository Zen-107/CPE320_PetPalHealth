# PetPal Health 🐾💧

แอปมือถือ (Flutter) ที่ชวนผู้ใช้ดูแลสุขภาพผ่านสัตว์เลี้ยงเสมือน — ดื่มน้ำ ทำกิจกรรมดี ๆ แล้วสัตว์เลี้ยงจะมีพลังและอารมณ์ดีขึ้น ถ้าละเลยมันจะเหี่ยว

โปรเจกต์วิชา CPE320 โจทย์ **"Building a SE Team of AI Agents to design & develop software"** — ทีมใช้ AI agent แบบผสม 2 ฝั่ง:
ฝั่งออกแบบใช้ **CrewAI + Gemini** (Groq สำรอง) สร้างเอกสาร และฝั่งพัฒนาใช้ **Claude Code sub-agents** อ่านเอกสารแล้วเขียนแอปและเทสต์

> 👉 **เพื่อนที่เพิ่งเริ่ม: อ่าน [docs/SETUP_CREWAI.md](docs/SETUP_CREWAI.md) แล้วทำตามทีละข้อ**

## ใครทำส่วนไหน

| คน | ออกแบบ agent | เครื่องมือ | ผลงาน |
|---|---|---|---|
| A | `agents/product.md` | CrewAI (`--role product`) | `docs/<feature>/requirements.md` |
| B | `agents/design.md` (UX + กติกาเกม) | CrewAI (`--role design`) | `docs/<feature>/ux-flow.md`, `docs/<feature>/game-rules.md` |
| C | `agents/reviewer.md` (+ Dev สำรอง) | CrewAI (`--role review`) | `docs/<feature>/review.md` + ตารางผลวัด agent |
| Dev/QA | `agents/dev.md`, `agents/qa.md` | Claude Code (`.claude/agents/dev.md`, `qa.md`) | `app/lib/` (Flutter), `app/test/` |

A, B, C ออกแบบ agent ของตัวเอง (ไฟล์ใน repo เป็นแม่แบบว่าง) — วิธีทำอยู่ใน [SETUP_CREWAI.md ข้อ 8](docs/SETUP_CREWAI.md#8-ออกแบบ-agent-ของคุณ)

## โครงโฟลเดอร์

```text
agents/            ไฟล์บทบาท agent (frontmatter: name, owner, description, role, goal, input_files, output_file / เนื้อหา = backstory)
  product.md  design.md  reviewer.md   แม่แบบว่าง — A / B / C ออกแบบเอง
  dev.md  qa.md                        ฝั่ง Dev/QA (Claude Code)
.claude/agents/    Claude Code sub-agent (dev, qa) — ชี้ไปอ่าน agents/dev.md, agents/qa.md
crew/              โค้ด CrewAI
  main.py          python crew/main.py --feature water --role product|design|review
  llm.py           สร้าง LLM จาก .env (Gemini หลัก, 429 → สลับ Groq อัตโนมัติ)
  load_agents.py   อ่าน agents/*.md → crewai.Agent (หยุดถ้ายังเป็น TODO)
  check_setup.py   ตรวจเครื่องทีละข้อ + แนะนำ GEMINI_MODEL
docs/
  SETUP_CREWAI.md  คู่มือติดตั้งและส่งงาน (ภาษาไทย)
  _templates/      โครงเอกสาร requirements / ux-flow / game-rules / review
  water/           ฟีเจอร์แรก: ดื่มน้ำ (brief.md = โจทย์ตั้งต้น — A เขียน)
logs/              log ทุกรอบที่รัน agent (prompt ที่ส่งจริง + ผลลัพธ์ + เวอร์ชัน agent) และบันทึกการออกแบบ agent — commit ขึ้นด้วย
app/               แอป Flutter (Android) — โค้ดใน app/lib/, เทสต์ใน app/test/ (ฝั่ง Dev/QA)
.devcontainer/     GitHub Codespaces (ทางหนีไฟเมื่อเครื่องติดตั้งไม่ผ่าน)
requirements.txt   แพ็กเกจฝั่ง CrewAI (Python 3.10–3.13, ทีมใช้ 3.12)
.env.example       ตัวอย่างไฟล์ .env (ห้าม commit .env จริง)
```

## รันแอป

แอปอยู่ใน `app/` (Flutter, Android) — สร้างด้วย Flutter 3.47.6 stable

**1) เช็กเครื่อง** (ครั้งแรก)
```powershell
flutter doctor
```
ต้องเห็น `[√] Flutter` และ `[√] Android toolchain` (ถ้า Android toolchain เป็น `[!]` ให้ทำตามที่มันบอก เช่น `flutter doctor --android-licenses`)

**2) เปิด Emulator** — Android Studio → **Device Manager** → กด ▶ ที่เครื่องจำลอง (ถ้ายังไม่มี กด **Create Virtual Device**) หรือใช้คำสั่ง:
```powershell
flutter emulators                     # ดูรายชื่อ emulator
flutter emulators --launch <emulator id>
flutter devices                       # ต้องเห็น emulator หรือมือถือที่เสียบสาย (เปิด USB debugging)
```

**3) รันแอปและเทสต์** (ต้องอยู่ในโฟลเดอร์ `app/`)
```powershell
cd app
flutter pub get
flutter run
flutter test
```
ระหว่าง `flutter run` กด `r` = hot reload, `R` = hot restart, `q` = ออก

## Workflow

1 ฟีเจอร์ = 1 GitHub Issue เดินตาม label:

```text
needs-design ──► ready-for-dev ──► needs-review ──► done
  A เขียน requirements           Dev เขียน app/   QA เทสต์ผ่าน
  B เขียน ux-flow + game-rules   QA เขียน app/test/ + C รีวิวโค้ด
  C รีวิวเอกสาร → "พร้อมส่ง Dev"
```

| label | ความหมาย | ใครทำงานอยู่ |
|---|---|---|
| `needs-design` | ยังออกแบบไม่เสร็จ / รีวิวแล้วต้องแก้ | A → B → C |
| `ready-for-dev` | เอกสารผ่านรีวิว ห้ามเปลี่ยน requirements โดยไม่เปิด Issue | Dev (Claude Code) |
| `needs-review` | โค้ด + เทสต์เสร็จ รอตรวจ | QA + C |
| `done` | ผ่านเทสต์และรีวิวแล้ว | — |

ส่งงานผ่าน branch `feat/<feature>-<role>` → Pull Request → เปลี่ยน label ใน Issue (รายละเอียดใน [SETUP_CREWAI.md ข้อ 10](docs/SETUP_CREWAI.md#10-ส่งงานผ่าน-github))

## กติกาสำคัญ
- ห้าม commit API key / ไฟล์ `.env`
- log ใน `logs/` ต้อง commit ทุกรอบ
- ข้อมูลสุขภาพใช้ข้อมูลสมมติเท่านั้น
