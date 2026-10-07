# คู่มือติดตั้งและใช้งาน CrewAI ของ PetPal Health

> สำหรับเพื่อน A, B, C ที่ไม่เคยตั้งค่า Python มาก่อน — อ่านจากบนลงล่าง ทำทีละข้อ ไม่ต้องข้าม
> ทุกคำสั่งอยู่ในกล่อง ก๊อปไปวางได้เลย หลังแต่ละคำสั่งมีบอกว่า "ควรเห็น" อะไร ถ้าไม่เห็นแบบนั้น ไปดู [ข้อ 12 ตารางแก้ปัญหา](#12-ตารางแก้ปัญหา)

## สารบัญ
0. [ภาพรวม](#0-ภาพรวม)
1. [สิ่งที่ต้องมี](#1-สิ่งที่ต้องมี)
2. [clone repo และเปิดใน VS Code](#2-clone-repo-และเปิดใน-vs-code)
3. [สร้างและเปิด venv](#3-สร้างและเปิด-venv)
4. [ติดตั้งแพ็กเกจ](#4-ติดตั้งแพ็กเกจ)
5. [สมัคร API key](#5-สมัคร-api-key)
6. [ตั้งค่าไฟล์ .env](#6-ตั้งค่าไฟล์-env)
7. [ตรวจเครื่องด้วย check_setup.py](#7-ตรวจเครื่องด้วย-check_setuppy)
8. [ออกแบบ agent ของคุณ](#8-ออกแบบ-agent-ของคุณ)
9. [รันงานตามบทบาทของตัวเอง](#9-รันงานตามบทบาทของตัวเอง)
10. [ส่งงานผ่าน GitHub](#10-ส่งงานผ่าน-github)
11. [เกณฑ์ "พร้อมส่งให้ Dev"](#11-เกณฑ์-พร้อมส่งให้-dev)
12. [ตารางแก้ปัญหา](#12-ตารางแก้ปัญหา)
13. [กติกาทีม](#13-กติกาทีม)
14. [ทางหนีไฟ: GitHub Codespaces](#14-ทางหนีไฟ-github-codespaces)

---

## 0. ภาพรวม

- เรากำลังทำแอปมือถือ **PetPal Health** (สัตว์เลี้ยงเสมือนที่อารมณ์ดีขึ้นเมื่อเราดูแลสุขภาพ) โดยใช้ "ทีม AI agent" ช่วยออกแบบและเขียนโค้ด
- ฝั่งเพื่อน (A, B, C) ใช้ **CrewAI + Gemini** (ฟรี) สร้างเอกสาร → ฝั่ง Dev ใช้ Claude Code อ่านเอกสารแล้วเขียนแอป Flutter
- **A = Product** เขียน `docs/<feature>/requirements.md` · **B = Design** เขียน `docs/<feature>/ux-flow.md` + `game-rules.md` · **C = Reviewer** เขียน `docs/<feature>/review.md` (+ ตารางผลวัด agent)
- **แต่ละคนต้องออกแบบ agent ของตัวเอง** (`agents/product.md` / `design.md` / `reviewer.md` ตอนนี้เป็นแม่แบบว่าง) — ดู [ข้อ 8](#8-ออกแบบ-agent-ของคุณ)
- ทุกครั้งที่รัน agent จะมีไฟล์ log ใน `logs/` อัตโนมัติ — ต้อง commit ขึ้นไปด้วย (อาจารย์ใช้ดูว่า agent ทำงานยังไง)
- 1 ฟีเจอร์ = 1 Issue บน GitHub เดินตาม label: `needs-design` → `ready-for-dev` → `needs-review` → `done` · ฟีเจอร์แรกคือ **water (ดื่มน้ำ)**

---

## 1. สิ่งที่ต้องมี

### Windows 10/11

| ของ | ดาวน์โหลด | หมายเหตุ |
|---|---|---|
| Python **3.12** | https://www.python.org/downloads/release/python-31210/ → เลื่อนลงไปกด **Windows installer (64-bit)** | ห้ามใช้ 3.14 (crewai ยังไม่รองรับ) · 3.12.10 คือตัวติดตั้งสำเร็จรูปตัวล่าสุดของ 3.12 |
| Git | https://git-scm.com/download/win | กด Next ไปเรื่อย ๆ ได้เลย |
| VS Code | https://code.visualstudio.com | ตอนติดตั้งติ๊ก "Add to PATH" และ "Open with Code" |
| Python extension ของ VS Code | เปิด VS Code → กด `Ctrl+Shift+X` → ค้นหา **Python** (ของ Microsoft) → Install | |
| บัญชี GitHub | https://github.com/signup | แจ้งชื่อบัญชีให้เจ้าของ repo เพิ่มเป็น collaborator |

**ตอนติดตั้ง Python (สำคัญมาก):** หน้าแรกของตัวติดตั้ง **ติ๊ก ☑ "Add python.exe to PATH"** ที่ด้านล่างก่อน แล้วค่อยกด **Install Now**

**ปิด "App execution aliases" (กันไม่ให้พิมพ์ python แล้วเด้ง Microsoft Store):**
1. กดปุ่ม Windows → พิมพ์ `App execution aliases` (หรือ "นามแฝงการดำเนินการแอป") → Enter
   (Windows 11: Settings → Apps → Advanced app settings → App execution aliases)
2. หา **App Installer python.exe** และ **App Installer python3.exe** → สลับเป็น **Off** ทั้งสองตัว
3. ปิด VS Code / PowerShell ทุกหน้าต่างแล้วเปิดใหม่

**เช็กว่าติดตั้งครบ** — เปิด PowerShell (กดปุ่ม Windows → พิมพ์ `PowerShell` → Enter) แล้วรันทีละบรรทัด:

```powershell
py -3.12 --version
```
ควรเห็น: `Python 3.12.10` (หรือ 3.12.อะไรก็ได้)

```powershell
git --version
```
ควรเห็น: `git version 2.xx.x.windows.x`

```powershell
code --version
```
ควรเห็น: เลขเวอร์ชัน 3 บรรทัด (ถ้าขึ้นว่าไม่รู้จัก `code` ให้รีสตาร์ตเครื่องหนึ่งรอบ)

### macOS (สั้น ๆ)

```bash
xcode-select --install          # ได้ git มาด้วย (ถ้าขึ้นว่าติดตั้งแล้วก็ข้ามได้)
```
ติดตั้ง Python 3.12 จาก https://www.python.org/downloads/release/python-31210/ → **macOS 64-bit universal2 installer** แล้วเช็ก:
```bash
python3.12 --version
```
ควรเห็น: `Python 3.12.10` — ส่วนที่เหลือของคู่มือใช้ Terminal ของ VS Code ได้เหมือนกัน ต่างแค่คำสั่งที่มีบอกไว้ว่า (macOS)

---

## 2. clone repo และเปิดใน VS Code

เปิด PowerShell แล้วไปที่โฟลเดอร์ที่จะเก็บงาน (ตัวอย่างคือ Documents):

```powershell
cd $HOME\Documents
git clone https://github.com/Zen-107/CPE320_PetPalHealth.git
```
ควรเห็น: `Cloning into 'CPE320_PetPalHealth'...` และจบด้วย `done.`
(ถ้ามีหน้าต่างให้ล็อกอิน GitHub ให้กด Sign in with your browser แล้วอนุญาต)

```powershell
cd CPE320_PetPalHealth
code .
```
ควรเห็น: VS Code เปิดขึ้นมา ด้านซ้ายมีโฟลเดอร์ `agents`, `crew`, `docs`, ... (ถ้าถาม "Do you trust the authors?" กด **Yes, I trust**)

**เปิด Terminal ใน VS Code:** เมนู **Terminal → New Terminal** (หรือ ``Ctrl+` ``)
ดูมุมขวาบนของ terminal ต้องเป็น **powershell** (ถ้าเป็นอย่างอื่น กดลูกศร ˅ ข้างปุ่ม + → เลือก PowerShell)
**ตั้งแต่ข้อนี้ไป ทุกคำสั่งพิมพ์ใน terminal ของ VS Code** และต้องอยู่ที่โฟลเดอร์ `CPE320_PetPalHealth`

---

## 3. สร้างและเปิด venv

venv = กล่องแยกแพ็กเกจ Python ของโปรเจกต์นี้ ไม่ปนกับเครื่อง (ทำครั้งเดียว แต่ต้อง "เปิด" ทุกครั้งที่เปิด terminal ใหม่)

เช็กก่อนว่า `python` ในเครื่องเป็นเวอร์ชันไหน:
```powershell
python --version
```
- ถ้าเห็น `Python 3.12.x` → ใช้คำสั่งนี้สร้าง venv:
  ```powershell
  python -m venv .venv
  ```
- ถ้าเห็นเวอร์ชันอื่น (เช่น 3.13, 3.14) → ใช้คำสั่งนี้แทน เพื่อบังคับใช้ 3.12:
  ```powershell
  py -3.12 -m venv .venv
  ```

ควรเห็น: ไม่มีข้อความอะไร (ใช้เวลา 5–20 วินาที) และมีโฟลเดอร์ `.venv` โผล่ทางซ้าย

**เปิด venv** (ทำทุกครั้งที่เปิด terminal ใหม่):
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
.\.venv\Scripts\Activate.ps1
```
ควรเห็น: บรรทัดคำสั่งมี **`(.venv)`** นำหน้า เช่น
```text
(.venv) PS C:\Users\you\Documents\CPE320_PetPalHealth>
```
> 💡 **กฎเหล็ก: ก่อนรันคำสั่ง python ทุกครั้ง ดูว่ามี `(.venv)` นำหน้าไหม** ถ้าไม่มี = ยังไม่ได้เปิด venv → รัน 2 บรรทัดด้านบนอีกรอบ
> (บรรทัด `Set-ExecutionPolicy` มีผลแค่หน้าต่างนี้ ปลอดภัย ไม่ได้เปลี่ยนการตั้งค่าเครื่อง)

(macOS: `python3.12 -m venv .venv` แล้ว `source .venv/bin/activate`)

**ให้ VS Code ใช้ Python ใน venv:** กด `Ctrl+Shift+P` → พิมพ์ `Python: Select Interpreter` → เลือกตัวที่มี **`('.venv': venv)`** หรือ path `.\.venv\Scripts\python.exe`
ควรเห็น: มุมขวาล่างของ VS Code ขึ้น `3.12.x ('.venv': venv)` — หลังจากนี้เปิด terminal ใหม่ VS Code จะเปิด venv ให้เอง

> **ทางเลือก: ใช้ uv (ถ้าเคยใช้ uv อยู่แล้ว ไม่งั้นข้ามกล่องนี้ไป)**
> ```powershell
> uv venv --python 3.12
> .\.venv\Scripts\Activate.ps1
> ```
> ⚠️ venv ที่สร้างด้วย uv **ไม่มี pip** — คำสั่ง `python -m pip ...` จะขึ้น `No module named pip`
> ให้ใช้ **`uv pip ...`** แทนทุกที่ เช่น `uv pip install -r requirements.txt`

---

## 4. ติดตั้งแพ็กเกจ

(ต้องเห็น `(.venv)` นำหน้าก่อน)

```powershell
python -m pip install -r requirements.txt
```
ใช้เวลา 2–6 นาที (โหลดประมาณ 300 MB) ควรเห็นบรรทัดสุดท้ายขึ้นต้นด้วย:
```text
Successfully installed ... crewai-1.15.23 ... google-genai-1.65.0 ... python-dotenv-1.2.4 ...
```
(ถ้ามีข้อความสีเหลือง `[notice] A new release of pip is available` ไม่ต้องสนใจ)

ถ้าใช้ uv:
```powershell
uv pip install -r requirements.txt
```
ควรเห็น: `Installed ... packages in ...` และมี `+ crewai==1.15.23` ในรายการ

เช็กว่า import ได้:
```powershell
python -c "import crewai, google.genai, dotenv; print('OK', crewai.__version__)"
```
ควรเห็น: `OK 1.15.23`

> ❗ ห้ามรัน `pip install crewai` เองหรืออัปเกรดแพ็กเกจเอง ใช้ `requirements.txt` เท่านั้น ทุกคนจะได้เวอร์ชันเดียวกัน

---

## 5. สมัคร API key

### Gemini (ตัวหลัก — ต้องมี)
1. เข้า https://aistudio.google.com/apikey แล้วล็อกอินด้วยบัญชี Google ส่วนตัว (บัญชีมหาลัยบางที่ถูกปิดไว้ ถ้าใช้ไม่ได้ให้ใช้ Gmail ส่วนตัว)
2. กด **Create API key** (ถ้าถามโปรเจกต์ ให้เลือกที่มันสร้างให้ หรือ Create API key in new project)
3. กด copy key — **key ที่ถูกต้องขึ้นต้นด้วย `AIza` และยาว 39 ตัว**

> ⚠️ ต้องสร้างที่ **aistudio.google.com** เท่านั้น ไม่ใช่ console.cloud.google.com (key จากที่อื่นมักโดน 403)

### Groq (ตัวสำรอง — แนะนำให้มี)
ใช้ตอน Gemini โควตาฟรีหมด ระบบจะสลับไปใช้ให้อัตโนมัติ
1. เข้า https://console.groq.com/keys → ล็อกอิน (ใช้ Google ได้)
2. กด **Create API Key** → ตั้งชื่ออะไรก็ได้ → copy (**ขึ้นต้นด้วย `gsk_`** และจะแสดงแค่ครั้งเดียว)

### 🔒 กฎความปลอดภัยของ key
- **ห้ามส่ง key ในแชต / LINE / Discord / รูปแคปหน้าจอ** แม้แต่ในกลุ่มเพื่อน
- **ห้ามใส่ key ในโค้ด `.py`** ใส่ในไฟล์ `.env` เท่านั้น (ข้อ 6)
- ถ้าเผลอหลุด (ส่งในแชต, push ขึ้น GitHub) → **ลบ key นั้นทันที** ที่หน้าเว็บเดิม (ไอคอนถังขยะ) แล้วสร้างใหม่

---

## 6. ตั้งค่าไฟล์ .env

ไฟล์ `.env` คือที่เก็บ key ในเครื่องเรา (ถูกตั้งไว้ใน `.gitignore` แล้ว จะไม่ขึ้น GitHub)

ก๊อปจากไฟล์ตัวอย่าง:
```powershell
Copy-Item .env.example .env
```
ควรเห็น: ไม่มีข้อความ และมีไฟล์ `.env` ทางซ้ายของ VS Code (ตัวหนังสือสีเทา = ถูก git ignore ถูกต้องแล้ว)
(macOS: `cp .env.example .env`)

เปิด `.env` ใน VS Code (คลิกที่ไฟล์) แล้วเติม key หลัง `=` ให้เป็นแบบนี้:
```dotenv
GEMINI_API_KEY=AIza...วางkeyของคุณตรงนี้
GEMINI_MODEL=
GROQ_API_KEY=gsk_...วางkeyของคุณตรงนี้
GROQ_MODEL=
MAX_RPM=8
```
กด `Ctrl+S` บันทึก (ปล่อย `GEMINI_MODEL` กับ `GROQ_MODEL` ว่างไว้ก่อน ข้อ 7 จะบอกว่าต้องใส่อะไร)

**กฎการเขียน .env:**
| ✅ ถูก | ❌ ผิด | ทำไม |
|---|---|---|
| `GEMINI_API_KEY=AIzaSy...` | `GEMINI_API_KEY = AIzaSy...` | ห้ามเว้นวรรครอบ `=` |
| `GEMINI_API_KEY=AIzaSy...` | `GEMINI_API_KEY="AIzaSy..."` | ไม่ต้องใส่ quote |
| `GEMINI_API_KEY=AIzaSy...` | `AIzaSy...=` หรือ `AIzaSy...` เฉย ๆ | ซ้ายของ `=` คือ **ชื่อ** ขวาคือ **key** |
| ไฟล์ชื่อ `.env` | `.env.txt`, `env`, `.env (1)` | ชื่อต้องเป๊ะ |

**ถ้าต้องสร้างไฟล์ .env เอง (ไม่ใช้ Copy-Item):** ใน VS Code คลิกขวาที่พื้นที่ว่างใต้รายการไฟล์ทางซ้าย → **New File...** → พิมพ์ `.env` → Enter
❌ อย่าสร้างด้วย Notepad (จะได้ `.env.txt` โดยไม่รู้ตัว) และอย่าใช้ `echo ... > .env` ใน PowerShell (จะได้ไฟล์ UTF-16 ที่อ่านไม่ได้)
มุมขวาล่างของ VS Code ตอนเปิด `.env` ต้องเขียนว่า **UTF-8** (ไม่ใช่ UTF-8 with BOM / UTF-16)

---

## 7. ตรวจเครื่องด้วย check_setup.py

```powershell
python crew/check_setup.py
```
สคริปต์จะตรวจ 13 ข้อตามลำดับ และ **หยุดที่ข้อแรกที่พัง** พร้อมบอกวิธีแก้เป็นภาษาไทย
- `[OK]` = ผ่าน · `[เตือน]` = ไม่หยุด แต่ควรอ่าน · `[แก้]` = ต้องแก้ตามที่บอก แล้วรันคำสั่งเดิมอีกรอบ
- key จะแสดงแค่ 6 ตัวแรกกับ 4 ตัวท้าย ส่งข้อความนี้ให้เพื่อนดูได้ปลอดภัย

ควรเห็น (เมื่อผ่านหมด — ชื่อรุ่นอาจต่างจากนี้ ใช้ตามที่เครื่องเราขึ้น):
```text
ตรวจเครื่องสำหรับ PetPal Health (CrewAI)
------------------------------------------------------------
[OK]    1/13 อยู่ใน venv — C:\Users\you\Documents\CPE320_PetPalHealth\.venv
[OK]    2/13 Python 3.12.10
[OK]    3/13 แพ็กเกจครบ — crewai==1.15.23, google-genai==1.65.0, python-dotenv==1.2.4
[OK]    4/13 มีไฟล์ .env ที่ root repo
[OK]    5/13 .env เป็น UTF-8 ไม่มี BOM
[OK]    6/13 มี GEMINI_API_KEY — AIzaSy...Ab12
[OK]    7/13 รูปแบบ key เหมือน key จาก AI Studio (AIza..., 39 ตัว)
[OK]    8/13 ดึงรายชื่อโมเดลได้ (xx รุ่นที่ใช้ generateContent)
[OK]    9/13 รุ่นที่แนะนำ: gemini-2.5-flash-lite — ยังไม่ได้ตั้ง GEMINI_MODEL ใน .env
[OK]   10/13 เรียก gemini-2.5-flash-lite ผ่าน google-genai ได้ — ตอบว่า: 'OK'
[OK]   11/13 เรียก gemini-2.5-flash-lite ผ่าน crewai.LLM ได้ — ตอบว่า: 'OK'
[OK]   12/13 เรียก Groq llama-3.3-70b-versatile ผ่าน crewai.LLM ได้ — ตอบว่า: 'OK'
------------------------------------------------------------
[OK]   13/13 ผ่านทุกข้อ! ใส่/ตรวจบรรทัดนี้ใน .env:

GEMINI_MODEL=gemini-2.5-flash-lite
GROQ_MODEL=llama-3.3-70b-versatile
```

**ขั้นสุดท้าย:** ก๊อปบรรทัด `GEMINI_MODEL=...` (และ `GROQ_MODEL=...` ถ้ามี) ที่เครื่องเราแนะนำ ไปแทนบรรทัดเดิมใน `.env` → `Ctrl+S` → รัน `python crew/check_setup.py` อีกรอบให้ผ่านหมด

> ❗ ห้ามเดาชื่อรุ่นเอง (เช่น `gemini-1.5-flash` ที่เจอในเน็ต — ถูกปิดไปแล้ว จะได้ 404) ใช้ตามที่ check_setup บอกเท่านั้น

---

## 8. ออกแบบ agent ของคุณ

> ⭐ **ข้อนี้คืองานหลักของ A, B, C และเป็นส่วนที่อาจารย์ให้คะแนน**
> ไฟล์ agent ของแต่ละคนใน repo เป็น **แม่แบบว่าง** (ทุกช่องเขียนว่า `TODO`) — ไม่มีใครเขียนบทบาทไว้ให้ คุณต้องออกแบบเอง
> ถ้ายังไม่ออกแบบ `main.py` จะไม่ยอมรัน และบอกว่าไฟล์ไหนเป็นของใคร

### 8.1 ไฟล์ของใคร

| เจ้าของ | ไฟล์ของคุณ | agent อ่าน (ข้อตกลงทีม) | agent เขียน (ข้อตกลงทีม) |
|---|---|---|---|
| A | `agents/product.md` | `docs/<feature>/brief.md` | `docs/<feature>/requirements.md` |
| B | `agents/design.md` | `docs/<feature>/requirements.md` | `docs/<feature>/ux-flow.md`, `docs/<feature>/game-rules.md` |
| C | `agents/reviewer.md` | `docs/<feature>/requirements.md`, `ux-flow.md`, `game-rules.md` และโค้ดใน `app/` (`app/lib/`, `app/test/`) | `docs/<feature>/review.md` |

แก้เฉพาะไฟล์ของตัวเอง ห้ามแก้ไฟล์ agent ของเพื่อน (`agents/dev.md`, `agents/qa.md` เป็นของฝั่ง Dev)
A ต้องเขียน `docs/water/brief.md` (โจทย์ตั้งต้น) เองด้วย — ถ้ายังมีคำว่า TODO อยู่ main.py จะไม่ส่งไฟล์นี้ให้ agent

### 8.2 ช่องไหนต้องกรอก ช่องไหนห้ามแตะ

เปิดไฟล์ของคุณใน VS Code จะเห็น 2 ส่วน: **frontmatter** (ระหว่างเส้น `---` สองเส้นด้านบน) และ **เนื้อหาด้านล่าง**

| ช่อง | ต้องทำอะไร | CrewAI ใช้ทำอะไร |
|---|---|---|
| `description` | **กรอกเอง** — agent นี้ทำอะไร ใช้เมื่อไร (1–2 ประโยค) | คำอธิบาย (Claude Code ใช้ตัดสินใจว่าจะเรียก agent ตัวนี้) |
| `role` | **กรอกเอง** — ตำแหน่งงาน 1 บรรทัด | `Agent(role=...)` |
| `goal` | **กรอกเอง** — เป้าหมายของงานแต่ละรอบ (เขียน `{feature}` ได้ จะถูกแทนด้วยชื่อฟีเจอร์) | `Agent(goal=...)` |
| เนื้อหาใต้เส้น `---` | **เขียนเอง** — ลบคอมเมนต์ `<!-- ... -->` ทั้งก้อนทิ้ง แล้วเขียน backstory ของคุณ ใช้คำถามนำทางในคอมเมนต์ช่วยคิด (agent เป็นใคร เชี่ยวชาญอะไร ห้ามทำอะไร ต้องส่งผลแบบไหน) | `Agent(backstory=...)` |
| `name`, `owner`, `input_files`, `output_file` | **ห้ามแก้** — เป็นข้อตกลงของทีม ถ้าจำเป็นต้องเปลี่ยนให้เปิด Issue ก่อน | main.py ตรวจว่าตรงกับโค้ดจริง ถ้าไม่ตรงจะหยุด |

**กฎการเขียน frontmatter:**
- แทนคำว่า `TODO` ด้วยข้อความของคุณ — ถ้าช่อง `description`/`role`/`goal` ยังมีคำว่า TODO หรือ backstory ยังว่าง main.py จะถือว่ายังออกแบบไม่เสร็จ
- คอมเมนต์ `# ...` ท้ายบรรทัด และ `<!-- ... -->` ในเนื้อหา จะไม่ถูกส่งให้ LLM (ลบทิ้งได้เมื่อไม่ต้องใช้แล้ว)
- ถ้าข้อความมีเครื่องหมาย `:` ให้ครอบทั้งข้อความด้วย `"..."` ไม่งั้นจะอ่านไม่ได้
- ข้อความยาวหลายบรรทัด ให้เอาไปเขียนในเนื้อหาด้านล่าง (backstory) แทน

### 8.3 ตรวจว่าไฟล์อ่านได้ (ยังไม่เรียก API ไม่เสียโควตา)

```powershell
python crew/load_agents.py
```
ก่อนออกแบบ ควรเห็นแบบนี้ (ตัวอย่างของ A):
```text
[ยังไม่ออกแบบ] agents/product.md ยังไม่ได้ออกแบบ — เจ้าของคือเพื่อน A
  ช่องที่ยังเป็น TODO/ว่าง: description, role, goal, backstory (เนื้อหาใต้เส้น ---)
  วิธีออกแบบ: docs/SETUP_CREWAI.md ข้อ 8
```
หลังกรอกครบ บรรทัดของไฟล์คุณต้องเปลี่ยนเป็น `[OK] product.md: name=product | role=... | backstory N ตัวอักษร`
(บรรทัดของเพื่อนคนอื่นจะยังเป็น `[ยังไม่ออกแบบ]` ก็ได้ ไม่กระทบการรันของเรา)

ถ้าเห็น `[แก้] agents/... บรรทัด N: frontmatter อ่านไม่ได้` → ไปดูบรรทัดนั้น ส่วนใหญ่เป็นเพราะมี `:` โดยไม่มี `"..."` ครอบ

### 8.4 ลองรัน → อ่านผล → ปรับ (ทำซ้ำหลายรอบ)

1. **รัน** ตาม [ข้อ 9](#9-รันงานตามบทบาทของตัวเอง)
2. **อ่านผลทั้งไฟล์** เทียบกับเกณฑ์ [ข้อ 11](#11-เกณฑ์-พร้อมส่งให้-dev) จดว่าอะไรขาด อะไรผิด อะไรเกินมา
3. **เดาสาเหตุ** — ผลไม่ดีเพราะ agent ไม่รู้อะไร หรือไม่ได้ถูกห้ามอะไร แล้ว **แก้ที่ไฟล์ agent** (`goal` หรือ backstory)
   - `--note` ใช้สั่งเฉพาะรอบเดียว (เช่น "ขอ edge case เพิ่ม") — แต่สิ่งที่อยากให้ agent ทำได้ทุกครั้งต้องอยู่ในไฟล์ agent เพราะไฟล์นี้คืองานที่ถูกให้คะแนน
4. **แก้ทีละอย่าง** แล้วรันใหม่ด้วย `--overwrite` จะได้รู้ว่าการแก้ไหนทำให้ผลดีขึ้นจริง
5. ทำจนผลผ่านเกณฑ์ ข้อ 11 โดยต้องแก้มือน้อยที่สุด (แต่ละรอบใช้โควตาฟรี — อ่านผลให้ละเอียดก่อนรันรอบใหม่)

### 8.5 จดเวอร์ชันที่ลองไว้ใน logs/ (ใช้เขียนรายงาน)

**บันทึกให้อัตโนมัติ:** log ทุกรอบใน `logs/` มีหัวข้อ `### Agent` ที่เก็บ role, goal และ backstory ที่ใช้รอบนั้นไว้ทั้งหมด และในตารางบนสุดจะมีบรรทัด
```text
| agent | agents/product.md (เวอร์ชัน 3f9a1c2e) |
```
รหัส 8 ตัวนี้ (hash) จะเปลี่ยนทุกครั้งที่ไฟล์ agent เปลี่ยน ทำให้รู้ว่า log ไหนรันด้วย agent เวอร์ชันไหน

**ต้องจดเอง:** สร้างไฟล์บันทึกการออกแบบของตัวเอง **1 ไฟล์ต่อคน** (ใน VS Code: New File)
- A: `logs/agent-design_product.md` · B: `logs/agent-design_design.md` · C: `logs/agent-design_reviewer.md`

ก๊อปโครงนี้ไปใส่ แล้วเพิ่มแถวทุกครั้งที่แก้ไฟล์ agent:
```markdown
# บันทึกการออกแบบ agent: <product/design/reviewer> — เจ้าของ: เพื่อน <A/B/C>

| เวอร์ชัน | hash (จาก log) | วันที่ | แก้อะไร | ทำไม (เห็นปัญหาอะไรในผลรอบก่อน) | log ที่ใช้ทดสอบ | ผลหลังแก้ |
|---|---|---|---|---|---|---|
| v1 | | | เวอร์ชันแรก | | | |
```

**commit ทุกเวอร์ชัน** (ไฟล์ agent + log + บันทึก) เพื่อให้ย้อนดูได้ว่าแต่ละเวอร์ชันหน้าตาเป็นยังไง:
```powershell
git add agents/product.md logs/
git commit -m "agent(product): v2 — <สรุปสิ่งที่แก้>"
```
ควรเห็น: `[feat/water-product xxxxxxx] agent(product): v2 — ...` (ทำบน branch ของตัวเองตาม [ข้อ 10](#10-ส่งงานผ่าน-github))

---

## 9. รันงานตามบทบาทของตัวเอง

ก่อนรันทุกครั้ง: เห็น `(.venv)` นำหน้า + `git pull` เอางานล่าสุดของเพื่อนมาก่อน
```powershell
git pull
```
ควรเห็น: `Already up to date.` หรือรายชื่อไฟล์ที่อัปเดต

### 👤 A — Product
```powershell
python crew/main.py --feature water --role product
```
| | |
|---|---|
| ต้องเสร็จก่อน | `agents/product.md` ออกแบบแล้ว ([ข้อ 8](#8-ออกแบบ-agent-ของคุณ)) |
| input | `docs/water/brief.md` (A เขียนเอง — ถ้ายังมี TODO จะไม่ถูกส่งให้ agent และผลจะกว้าง ๆ) |
| output | `docs/water/requirements.md` |
| log | `logs/<วันที่-เวลา>_product_water.md` เช่น `logs/20261008-1430_product_water.md` |

### 🎨 B — Design (รอให้ A ส่ง requirements.md ขึ้น GitHub ก่อน)
```powershell
python crew/main.py --feature water --role design
```
| | |
|---|---|
| ต้องเสร็จก่อน | `agents/design.md` ออกแบบแล้ว ([ข้อ 8](#8-ออกแบบ-agent-ของคุณ)) |
| input | `docs/water/requirements.md` (**บังคับ** — ถ้าไม่มีจะหยุดและบอก) |
| output | `docs/water/ux-flow.md` และ `docs/water/game-rules.md` |
| log | `logs/<วันที่-เวลา>_design_water.md` |

### 🔍 C — Reviewer (รอให้ A และ B ส่งงานก่อน)
```powershell
python crew/main.py --feature water --role review
```
| | |
|---|---|
| ต้องเสร็จก่อน | `agents/reviewer.md` ออกแบบแล้ว ([ข้อ 8](#8-ออกแบบ-agent-ของคุณ)) |
| input | `docs/water/requirements.md` (บังคับ), `ux-flow.md`, `game-rules.md`, โค้ดใน `app/lib/` และเทสต์ใน `app/test/` (ถ้ามี) + log ทั้งหมดของ water ใน `logs/` |
| output | `docs/water/review.md` (มี checklist + ตารางผลวัด agent ที่ดึงจาก logs) |
| log | `logs/<วันที่-เวลา>_review_water.md` |

**ระหว่างรัน** จะเห็นกล่องข้อความของ CrewAI เลื่อนขึ้นมา (ปกติ 20 วินาที – 2 นาที) **ควรเห็นตอนจบ:**
```text
[OK] เสร็จแล้ว
     ไฟล์ผลลัพธ์: docs/water/requirements.md
     log: logs/20261008-1430_product_water.md
     ขั้นต่อไป: เปิดไฟล์ผลลัพธ์ ตรวจ/แก้เองตาม checklist (SETUP_CREWAI.md ข้อ 11) แล้วค่อย commit
```
ถ้า Gemini โควตาหมด และใส่ Groq ไว้ จะเห็น `[สลับ] gemini ตอบ 429 ... → ลองใหม่ด้วย groq` แล้วทำงานต่อเอง (log จะบันทึกว่าใช้ตัวไหน)

**อยากให้ agent แก้งานรอบใหม่:** ไฟล์ output เดิมจะไม่ถูกเขียนทับโดยไม่ตั้งใจ ต้องสั่งเอง และบอกสิ่งที่อยากให้แก้ด้วย `--note`:
```powershell
python crew/main.py --feature water --role product --overwrite --note "เพิ่ม edge case ตอนเปลี่ยนวันตอนเที่ยงคืน"
```
(แนะนำให้ commit ของเดิมก่อนใช้ `--overwrite` จะได้ย้อนกลับได้ — ทุกรอบมี log แยกไฟล์อยู่แล้ว)

---

## 10. ส่งงานผ่าน GitHub

**ทำครั้งแรกครั้งเดียว** — บอก git ว่าเราเป็นใคร:
```powershell
git config --global user.name "ชื่อเล่นของเรา"
git config --global user.email "อีเมลที่ใช้สมัคร GitHub"
```

### ทีละขั้น (ตัวอย่างของ A ฟีเจอร์ water — B ใช้ `design`, C ใช้ `review`)

**1) เอางานล่าสุดลงมา และสร้าง branch ของเรา**
```powershell
git checkout main
git pull
git checkout -b feat/water-product
```
ควรเห็น: `Switched to a new branch 'feat/water-product'`

**2) รัน agent** (ข้อ 9) แล้ว **เปิดไฟล์ผลลัพธ์อ่านเองทั้งไฟล์** แก้ตรงที่ผิด/ไม่ครบตาม [ข้อ 11](#11-เกณฑ์-พร้อมส่งให้-dev) — agent ช่วยร่าง เราเป็นคนรับผิดชอบ

**3) ดูว่าจะส่งไฟล์อะไรบ้าง**
```powershell
git status
```
ควรเห็น: ไฟล์ใน `docs/water/`, `logs/` และไฟล์ agent ของเรา (เช่น `agents/product.md`) เป็นสีแดง — **ต้องไม่มี `.env` ในรายการ** (ถ้ามี หยุด! ดูข้อ 12 แถวสุดท้าย)

**4) เลือกเฉพาะ docs, logs และไฟล์ agent ของตัวเอง** (ห้าม `git add .` หรือ `git add -A`)
```powershell
git add docs/ logs/ agents/product.md
git status
```
(B ใช้ `agents/design.md`, C ใช้ `agents/reviewer.md`)
ควรเห็น: ไฟล์เดิมกลายเป็นสีเขียวใต้หัวข้อ `Changes to be committed` และไม่มี `.env`

**5) commit**
```powershell
git commit -m "docs(water): requirements จาก product agent + log"
```
ควรเห็น: `[feat/water-product xxxxxxx] docs(water): ...` และ `N files changed`

**6) push**
```powershell
git push -u origin feat/water-product
```
ควรเห็น: บรรทัดท้าย ๆ มีลิงก์ `https://github.com/Zen-107/CPE320_PetPalHealth/pull/new/feat/water-product`

**7) เปิด Pull Request** — กดลิงก์ด้านบน (หรือเข้าหน้า repo จะมีแถบเหลือง **Compare & pull request**)
- Title: `docs(water): requirements` · ในช่องรายละเอียดพิมพ์ `Refs #<เลข Issue ของ water>` และสรุปสั้น ๆ ว่าแก้อะไรเองบ้าง
- กด **Create pull request** → ให้เพื่อนอีกคนกด **Merge** หลังดูแล้ว

**8) เปลี่ยน label ใน Issue** — เปิด Issue ของฟีเจอร์ → แถบขวา **Labels** ⚙️ → ติ๊ก/เอาออก
| ใครส่งเสร็จ | label ที่ต้องเป็นหลังส่ง |
|---|---|
| A ส่ง requirements | คงไว้ `needs-design` (รอ B) |
| B ส่ง ux-flow + game-rules | คงไว้ `needs-design` (รอ C รีวิวเอกสาร) |
| C รีวิวเอกสารแล้ว "พร้อมส่ง Dev" | `needs-design` → `ready-for-dev` |
| C รีวิวเอกสารแล้ว "ต้องแก้" | คงไว้ `needs-design` + คอมเมนต์ใน Issue ว่าใครต้องแก้อะไร |
| Dev เขียนโค้ด + QA เขียนเทสต์เสร็จ | `ready-for-dev` → `needs-review` |
| QA เทสต์ผ่าน + C รีวิวโค้ดแล้ว | `needs-review` → `done` |

**9) แจ้งในกลุ่ม** — เช่น "A ส่ง requirements water แล้ว PR #3 ฝาก B ทำ design ต่อ" (ส่งลิงก์ PR ได้ ห้ามส่ง key)

### ถ้าใช้ GitHub Desktop (ไม่ถนัด command line)
1. ติดตั้ง https://desktop.github.com → Sign in ด้วยบัญชี GitHub
2. **File → Clone repository** → แท็บ GitHub.com → เลือก `Zen-107/CPE320_PetPalHealth` → Clone
3. ก่อนเริ่มงาน: ด้านบนเลือก **Current branch: main** → กด **Fetch origin** / **Pull origin**
4. **Current branch → New branch** → ชื่อ `feat/water-product` → Create branch
5. รัน agent ใน VS Code ตามข้อ 9 (เปิดโฟลเดอร์ด้วย **Repository → Open in Visual Studio Code**)
6. กลับมาที่ GitHub Desktop แท็บ **Changes** ทางซ้าย: ติ๊กเฉพาะไฟล์ใน `docs/`, `logs/` และไฟล์ agent ของตัวเอง — **ถ้าเห็น `.env` ห้ามติ๊ก**
7. ช่อง Summary ซ้ายล่าง: `docs(water): requirements จาก product agent + log` → กด **Commit to feat/water-product**
8. กด **Publish branch** (ครั้งต่อไปจะเป็น **Push origin**) → กด **Create Pull Request** → เบราว์เซอร์เปิดหน้า PR → ทำต่อตามขั้น 7–9 ด้านบน

---

## 11. เกณฑ์ "พร้อมส่งให้ Dev"

ก่อน commit ให้ติ๊กเองทุกข้อ (C ใช้ checklist นี้ตอนรีวิวด้วย)

### requirements.md (A)
- [ ] user story ทุกข้อเป็นรูปแบบ **ในฐานะ … ฉันอยาก … เพื่อ …** และมีรหัส US-1, US-2, …
- [ ] acceptance criteria ทุกข้อ **เป็นตัวเลขหรือเงื่อนไขที่ทดสอบได้** (บอกค่าก่อน การกระทำ และค่าหลังที่วัดได้) และอ้าง US
- [ ] มี **edge cases** อย่างน้อย 5 ข้อ พร้อมผลที่คาดหวัง (ค่าเกิน max, ต่ำกว่า 0, ข้ามวัน, กดรัว, ไม่เปิดแอปนาน ๆ)
- [ ] มีหัวข้อ **สิ่งที่ไม่ทำ** ในรอบนี้
- [ ] ข้อมูลทั้งหมดเป็น **ข้อมูลสมมติ** และไม่มีคำแนะนำทางการแพทย์

### ux-flow.md + game-rules.md (B)
- [ ] ทุกหน้าจอโยงกลับไปหา US/AC ได้ และมีสถานะ ปกติ / ว่าง / ผิดพลาด
- [ ] **ตารางตัวเลขกติกาเกม** ครบ และทุกค่า **เป็นตัวเลขที่ทดสอบได้**: ค่าเริ่มต้น, ค่าที่เพิ่ม/ลดและเมื่อไร, ค่าสูงสุด/ต่ำสุด, ช่วงของแต่ละอารมณ์ (ระบุว่าค่าที่ขอบพอดีนับเป็นช่วงไหน), พฤติกรรมเมื่อค่าจะเกินขอบ
- [ ] ตัวเลขกติกาเกมเป็นการตัดสินใจของ B — ตรวจเองว่าสมเหตุสมผลกับผู้ใช้ ไม่ใช่แค่รับค่าที่ agent เสนอ
- [ ] ตัวเลขตรงกับ requirements.md ทุกตัว
- [ ] มี **ตารางชื่อไฟล์ภาพ assets** ครบทุกสถานะของสัตว์เลี้ยง และตั้งชื่อตามรูปแบบเดียวกันทั้งไฟล์


### review.md (C)
- [ ] ทุกข้อใน checklist มีผล ผ่าน/ไม่ผ่าน + เหตุผล
- [ ] ปัญหาที่เจอระบุไฟล์ + หัวข้อ + ข้อเสนอแก้
- [ ] ตารางผลวัด agent ตัวเลขตรงกับไฟล์ใน `logs/` (ไม่มีตัวเลขแต่งขึ้น) และเติมคอลัมน์ "ต้องแก้มือ" เอง
- [ ] สรุปชัดว่า **พร้อมส่ง Dev** หรือ **ต้องแก้**

---

## 12. ตารางแก้ปัญหา

ลองรัน `python crew/check_setup.py` ก่อนเสมอ ส่วนใหญ่มันจะบอกวิธีแก้ให้เอง

| อาการ (ข้อความที่เห็น) | สาเหตุ | วิธีแก้ |
|---|---|---|
| `ModuleNotFoundError: No module named 'crewai'` | ยังไม่ได้เปิด venv หรือยังไม่ได้ติดตั้ง | ดูว่ามี `(.venv)` ไหม → ถ้าไม่มีรัน `.\.venv\Scripts\Activate.ps1` → ถ้ามีแล้วยังพัง รัน `python -m pip install -r requirements.txt` |
| `No module named pip` | venv สร้างด้วย uv (ไม่มี pip) | ใช้ `uv pip install -r requirements.txt` แทน |
| พิมพ์ `python` แล้วเด้ง Microsoft Store / ขึ้น `Python was not found` | Windows App execution alias | ปิด alias ตามข้อ 1 แล้วเปิด terminal ใหม่ ถ้ายังไม่หาย ติดตั้ง Python ใหม่โดยติ๊ก Add to PATH |
| `Activate.ps1 cannot be loaded because running scripts is disabled on this system` | PowerShell ปิดการรันสคริปต์ | รัน `Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned` ก่อน แล้วค่อย `.\.venv\Scripts\Activate.ps1` |
| `ไม่พบ GEMINI_API_KEY` / `No API key was provided` | ไม่มี .env, ชื่อตัวแปรผิด, หรือลืมกด Save | เช็กว่าไฟล์ชื่อ `.env` อยู่ข้าง `requirements.txt`, บรรทัดเป็น `GEMINI_API_KEY=AIza...`, กด `Ctrl+S` |
| `400 ... API_KEY_INVALID` / `API key not valid` | key ผิด/ก๊อปไม่ครบ/มีเว้นวรรค | ก๊อป key ใหม่จาก aistudio.google.com/apikey ให้ครบ 39 ตัว ไม่มี quote |
| `403 PERMISSION_DENIED` | key ไม่ได้มาจาก AI Studio หรือถูกจำกัดสิทธิ์ | สร้าง key ใหม่ที่ **aistudio.google.com** (ไม่ใช่ Cloud Console) ถ้าบัญชีมหาลัยใช้ไม่ได้ ใช้ Gmail ส่วนตัว |
| `404 NOT_FOUND ... models/gemini-1.5-flash is not found` | ชื่อรุ่นเก่า/พิมพ์ผิด | รัน `python crew/check_setup.py` แล้วใช้ `GEMINI_MODEL` ที่มันแนะนำ |
| `429 RESOURCE_EXHAUSTED` | โควตาฟรีหมด หรือเรียกถี่เกิน | รอ 1 นาทีแล้วรันใหม่ / ลด `MAX_RPM` ใน .env (เช่น 5) / ถ้าโควตารายวันหมด รอพรุ่งนี้หรือใส่ Groq ไว้ให้สลับเอง |
| `SSL: CERTIFICATE_VERIFY_FAILED` / `ConnectError` / timeout | Wi-Fi มหาลัยหรือ proxy บล็อก | สลับไปฮอตสปอตมือถือ / ปิด VPN / ใช้ Codespaces (ข้อ 14) |
| `UnicodeDecodeError` หรือ check_setup บอก `.env เป็น UTF-16` / `มี BOM` | สร้าง .env ด้วย `echo >` หรือ Notepad | เปิด .env ใน VS Code → คลิก encoding มุมขวาล่าง → **Save with Encoding** → **UTF-8** |
| `Python 3.14 ใช้ไม่ได้` / pip ขึ้น `No matching distribution found for crewai` | Python ไม่ใช่ 3.10–3.13 | ติดตั้ง Python 3.12 → `deactivate` → `Remove-Item -Recurse -Force .venv` → `py -3.12 -m venv .venv` → เปิด venv → ติดตั้งใหม่ |
| `agents/... ยังไม่ได้ออกแบบ — เจ้าของคือเพื่อน X` | ไฟล์ agent ยังเป็นแม่แบบ (มี TODO หรือ backstory ว่าง) | เจ้าของไฟล์ออกแบบตาม [ข้อ 8](#8-ออกแบบ-agent-ของคุณ) แล้ว push ขึ้นมา (คนอื่นต้อง `git pull`) |
| `agents/... บรรทัด N: frontmatter อ่านไม่ได้` | ในช่อง frontmatter มีเครื่องหมาย `:` ที่ไม่ได้ครอบ `"..."` | ครอบข้อความในบรรทัดนั้นด้วย `"..."` แล้วรัน `python crew/load_agents.py` ตรวจ |
| `ช่องข้อตกลงทีมไม่ตรงกับที่โค้ดใช้` | แก้ `name`/`input_files`/`output_file` ในไฟล์ agent | คืนค่าเดิม (`git checkout -- agents/<ไฟล์>` จะคืนทั้งไฟล์ — ก๊อปส่วนที่เขียนเองเก็บไว้ก่อน) |
| `git push` → `rejected ... fetch first` / `non-fast-forward` | มีคนอื่น push ก่อน | `git pull --rebase` แล้ว `git push` อีกรอบ |
| `git push` → `Permission ... denied` / `403` | ยังไม่ได้เป็น collaborator หรือล็อกอินผิดบัญชี | ให้เจ้าของ repo เพิ่มเรา (Settings → Collaborators) แล้วกดรับคำเชิญในอีเมล / ใช้ GitHub Desktop ล็อกอินใหม่ |
| เผลอ commit `.env` | ไม่ได้ดู `git status` ก่อน add | ดูด้านล่าง ⬇️ |

### 🚨 เผลอ commit .env
1. **เปลี่ยน key ทันที** (สำคัญที่สุด ทำก่อนอย่างอื่น): ลบ key เดิมที่ aistudio.google.com/apikey (และ console.groq.com/keys) → สร้างใหม่ → ใส่ใน .env
2. เอา .env ออกจาก git (ไฟล์ในเครื่องยังอยู่):
   ```powershell
   git rm --cached .env
   git commit -m "remove .env from repo"
   git push
   ```
   ควรเห็น: `rm '.env'` และ commit ใหม่
3. แจ้งในกลุ่มทันที — ถ้า push ไปแล้ว key เก่ายังอยู่ใน history ของ GitHub ตลอดไป **จึงต้องเปลี่ยน key เสมอ** การลบไฟล์อย่างเดียวไม่พอ

---

## 13. กติกาทีม

1. **ห้าม commit key** — `.env` อยู่ในเครื่องเท่านั้น ใช้ `git add docs/ logs/ agents/<ไฟล์ตัวเอง>` ห้าม `git add .`
2. **ออกแบบ agent ของตัวเอง** — แก้เฉพาะไฟล์ agent ของตัวเอง ห้ามแก้ของเพื่อน และห้ามแก้ช่องข้อตกลงทีม (`name`, `owner`, `input_files`, `output_file`) โดยไม่เปิด Issue · จดทุกเวอร์ชันใน `logs/agent-design_<role>.md`
3. **บันทึก log ทุกรอบ** — main.py สร้าง log ให้เอง ห้ามลบ ห้ามแก้ และ commit ขึ้นไปพร้อมงาน (รวมรอบที่ล้มเหลวด้วย)
4. **ห้ามเปลี่ยน requirements หลังติด label `ready-for-dev`** โดยไม่เปิด Issue ใหม่และแจ้ง Dev ก่อน
5. **ข้อมูลสุขภาพใช้ข้อมูลสมมติเท่านั้น** ห้ามใส่ข้อมูลจริงของตัวเองหรือคนอื่นใน prompt, `--note`, หรือเอกสาร
6. agent ร่าง — **คนตรวจและรับผิดชอบ** อ่านผลทุกครั้งก่อนส่ง
7. ห้ามแก้ `requirements.txt` หรืออัปเกรดแพ็กเกจเอง ถ้าจำเป็นให้เปิด Issue

---

## 14. ทางหนีไฟ: GitHub Codespaces

ใช้เมื่อเครื่องตัวเองติดตั้งไม่ผ่าน หรือเน็ตมหาลัยบล็อก — ได้ VS Code ในเบราว์เซอร์ที่ติดตั้งทุกอย่างให้แล้ว (ฟรีสำหรับบัญชีส่วนตัวประมาณ 60 ชั่วโมง/เดือน บนเครื่อง 2-core)

**1) ใส่ key เป็น Codespaces secret (ทำครั้งเดียว ไม่ต้องมีไฟล์ .env)**
1. เข้า https://github.com/settings/codespaces → หัวข้อ **Codespaces secrets** → **New secret**
2. Name: `GEMINI_API_KEY` · Value: key ของเรา · Repository access: เลือก `Zen-107/CPE320_PetPalHealth` → **Add secret**
3. (ไม่บังคับ) ทำซ้ำกับ `GROQ_API_KEY`

**2) เปิด Codespace**
1. เข้าหน้า repo บน GitHub → ปุ่มเขียว **Code** → แท็บ **Codespaces** → **Create codespace on main**
2. รอ 3–5 นาทีครั้งแรก (มันจะสร้าง `.venv` และติดตั้ง `requirements.txt` ให้เองตาม `.devcontainer/devcontainer.json`)
   ควรเห็น: VS Code ในเบราว์เซอร์ และ terminal ด้านล่างจบด้วย `Successfully installed ... crewai-1.15.23 ...`
3. ถ้าสร้าง secret หลังเปิด Codespace แล้ว: กด `Ctrl+Shift+P` → `Codespaces: Rebuild Container`

**3) ใช้งาน** (Codespaces เป็น Linux — เปิด venv ด้วยคำสั่งแบบ macOS)
```bash
source .venv/bin/activate
python crew/check_setup.py
```
ควรเห็น: ข้อ 4 ขึ้นว่า `ไม่มี .env แต่มี GEMINI_API_KEY ใน environment (เช่น Codespaces secrets)` และผ่านไปจนจบ

แล้วสร้าง `.env` ที่มีแค่ชื่อรุ่น (ไม่ต้องใส่ key — key มาจาก secret):
```bash
echo "GEMINI_MODEL=<รุ่นที่ check_setup แนะนำ>" > .env
```
จากนั้นทำข้อ 9–10 ได้เหมือนเดิมทุกอย่าง (ใช้ `git` ใน terminal ของ Codespace ได้เลย ไม่ต้องล็อกอินเพิ่ม)

> ปิด Codespace เมื่อเลิกใช้: https://github.com/codespaces → ⋯ → **Stop codespace** (ไม่งั้นกินชั่วโมงฟรี)
