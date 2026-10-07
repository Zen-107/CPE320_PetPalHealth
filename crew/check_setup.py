"""ตรวจเครื่องก่อนใช้ CrewAI — รันจาก root ของ repo:

    python crew/check_setup.py

ตรวจทีละข้อตามลำดับ พิมพ์ [OK] หรือ [แก้] + วิธีแก้ และหยุดที่ข้อแรกที่พัง
([เตือน] = ไม่หยุด แต่ควรอ่าน) ไม่พิมพ์ key เต็ม แสดงแค่ 6 ตัวแรก + 4 ตัวท้าย
"""

from __future__ import annotations

import importlib.util
import os
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import llm as llm_mod  # noqa: E402  (ไฟล์นี้ใช้แค่ stdlib ตอน import)

ROOT = llm_mod.ROOT
ENV_PATH = llm_mod.ENV_PATH
TOTAL = 13
_secrets: list[str] = []


class Stop(Exception):
    pass


def safe(text: str) -> str:
    for s in _secrets:
        if s:
            text = text.replace(s, llm_mod.mask(s))
    return text


def ok(n: int, title: str, detail: str = "") -> None:
    print(f"[OK]   {n:>2}/{TOTAL} {title}" + (f" — {safe(detail)}" if detail else ""))


def warn(text: str) -> None:
    print(f"[เตือน]       {safe(text)}")


def bad(n: int, title: str, how: str) -> None:
    print(f"[แก้]  {n:>2}/{TOTAL} {title}")
    for line in safe(how).strip("\n").splitlines():
        print(f"             {line}")
    raise Stop


def api_bad(n: int, title: str, exc: BaseException) -> None:
    kind = llm_mod.error_kind(exc)
    detail = f"{type(exc).__name__}: {str(exc)[:300]}"
    bad(n, f"{title} — error {kind}", f"{detail}\n{llm_mod.EXPLAIN[kind]}")


INSTALL_HOW = """ติดตั้งแพ็กเกจ (ต้องเห็น (.venv) หน้าบรรทัดก่อน):
  python -m pip install -r requirements.txt
ถ้าสร้าง venv ด้วย uv (venv แบบนี้ไม่มี pip):
  uv pip install -r requirements.txt"""


# ---------------------------------------------------------------- 1–3 Python

def check_venv() -> None:
    if sys.prefix == sys.base_prefix:
        bad(1, "ยังไม่ได้เปิด venv (กำลังใช้ Python ของเครื่องโดยตรง)", f"""\
Windows (PowerShell ใน VS Code):
  Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
  .\\.venv\\Scripts\\Activate.ps1
macOS:
  source .venv/bin/activate
ถ้ายังไม่เคยสร้าง .venv: python -m venv .venv  (ดู docs/SETUP_CREWAI.md ข้อ 3)
เปิดแล้วต้องเห็น (.venv) หน้าบรรทัด แล้วรันไฟล์นี้ใหม่
Python ที่ใช้อยู่ตอนนี้: {sys.executable}""")
    here = Path(sys.prefix).resolve()
    ok(1, "อยู่ใน venv", str(here))
    if here != (ROOT / ".venv").resolve():
        warn(f"venv นี้ไม่ใช่ {ROOT / '.venv'} — ใช้ได้ แต่คู่มือของทีมใช้ .venv ที่ root repo")


def check_python() -> None:
    v = sys.version_info
    ver = f"{v.major}.{v.minor}.{v.micro}"
    if not ((3, 10) <= (v.major, v.minor) < (3, 14)):
        bad(2, f"Python {ver} ใช้ไม่ได้ (crewai รองรับ 3.10–3.13)", """\
1) ติดตั้ง Python 3.12 จาก https://www.python.org/downloads/ (ติ๊ก Add python.exe to PATH)
2) ปิด venv เดิมแล้วลบทิ้ง แล้วสร้างใหม่ด้วย 3.12:
     deactivate
     Remove-Item -Recurse -Force .venv
     py -3.12 -m venv .venv
     .\\.venv\\Scripts\\Activate.ps1
     python -m pip install -r requirements.txt""")
    ok(2, f"Python {ver}")
    if (v.major, v.minor) != (3, 12):
        warn("ทีมทดสอบกับ Python 3.12 — เวอร์ชันนี้น่าจะใช้ได้ แต่ถ้าติดตั้งพังให้เปลี่ยนเป็น 3.12")


def pinned_versions() -> dict[str, str]:
    pins = {}
    req = ROOT / "requirements.txt"
    for line in req.read_text(encoding="utf-8-sig").splitlines():
        m = re.match(r"^\s*([A-Za-z0-9_.-]+)(\[[^\]]*\])?==([^\s#;]+)", line)
        if m:
            pins[m.group(1).lower()] = m.group(3)
    return pins


def check_packages() -> None:
    from importlib import metadata

    has_pip = importlib.util.find_spec("pip") is not None
    how = INSTALL_HOW if has_pip else (
        "venv นี้ไม่มี pip (น่าจะสร้างด้วย uv) ให้ติดตั้งด้วย:\n"
        "  uv pip install -r requirements.txt\n"
        "หรือติดตั้ง pip ก่อน: python -m ensurepip --upgrade")
    missing = [mod for mod in ("crewai", "google.genai", "dotenv")
               if importlib.util.find_spec(mod.split(".")[0]) is None
               or importlib.util.find_spec(mod) is None]
    if missing:
        bad(3, f"ยังไม่ได้ติดตั้งแพ็กเกจ: {', '.join(missing)}", how)
    wrong = []
    for name, want in pinned_versions().items():
        try:
            have = metadata.version(name)
        except metadata.PackageNotFoundError:
            have = "ไม่มี"
        if have != want:
            wrong.append(f"{name} มี {have} แต่ requirements.txt ต้องการ {want}")
    if wrong:
        bad(3, "เวอร์ชันแพ็กเกจไม่ตรงกับ requirements.txt", "\n".join(wrong) + "\n" + how)
    # crewai อ่าน .env ตอน import → ถ้า .env encoding ผิด ให้ข้อ 5 เป็นคนบอก ไม่ใช่โทษแพ็กเกจ
    if llm_mod.env_file_problem() is None:
        try:
            import crewai  # noqa: F401
            import dotenv  # noqa: F401
            from google import genai  # noqa: F401
        except Exception as exc:  # noqa: BLE001
            bad(3, f"import แพ็กเกจไม่ผ่าน ({type(exc).__name__}: {exc})",
                "ลองติดตั้งใหม่ทับ:\n"
                + how.replace("install -r", "install --force-reinstall -r"))
    ok(3, "แพ็กเกจครบ", ", ".join(f"{k}=={v}" for k, v in pinned_versions().items()))


# ---------------------------------------------------------------- 4–7 .env

def check_env_file() -> bool:
    if ENV_PATH.is_file():
        ok(4, "มีไฟล์ .env ที่ root repo")
        return True
    if llm_mod.env("GEMINI_API_KEY"):
        ok(4, "ไม่มี .env แต่มี GEMINI_API_KEY ใน environment (เช่น Codespaces secrets)")
        return False
    root_names = [p.name for p in ROOT.iterdir()]
    near = [n for n in root_names if "env" in n.lower() and n not in (".env.example", ".venv")]
    if ".env.txt" in near:
        bad(4, "เจอ .env.txt แทน .env (Windows แอบเติม .txt ให้)", """\
เปลี่ยนชื่อด้วยคำสั่ง:
  Rename-Item .env.txt .env
แล้วรันไฟล์นี้ใหม่""")
    if near:
        bad(4, f"ไม่มี .env แต่เจอไฟล์ชื่อคล้าย ๆ: {', '.join(near)}", """\
ไฟล์ต้องชื่อ .env เป๊ะ ๆ (มีจุดข้างหน้า ไม่มีนามสกุล ไม่มีเว้นวรรค) อยู่ที่ root repo
แก้ชื่อใน VS Code: คลิกขวาที่ไฟล์ → Rename → พิมพ์ .env""")
    misplaced = [p for p in (ROOT / "crew" / ".env", ROOT / "docs" / ".env") if p.exists()]
    if misplaced:
        bad(4, f"เจอ .env ผิดที่: {misplaced[0].relative_to(ROOT)}",
            f"ย้ายมาไว้ที่ root repo ({ROOT}) ข้าง ๆ requirements.txt")
    bad(4, "ยังไม่มีไฟล์ .env ที่ root repo", """\
สร้างจากตัวอย่าง:
  Copy-Item .env.example .env        (Windows PowerShell)
  cp .env.example .env               (macOS)
แล้วเปิด .env ใน VS Code ใส่ GEMINI_API_KEY (ดู docs/SETUP_CREWAI.md ข้อ 6)""")


ENCODING_HOW = """เปิด .env ใน VS Code → คลิกชื่อ encoding มุมขวาล่าง (เช่น "UTF-8 with BOM" หรือ "UTF-16 LE")
→ Save with Encoding → เลือก UTF-8 (ไม่มี BOM) → บันทึก แล้วรันไฟล์นี้ใหม่
(มักเกิดจากสร้างไฟล์ด้วย echo ... > .env หรือ Notepad รุ่นเก่า)"""


def check_env_encoding() -> dict[str, str]:
    problem = llm_mod.env_file_problem()
    if problem:
        bad(5, problem, ENCODING_HOW)
    values: dict[str, str] = {}
    for no, line in enumerate(ENV_PATH.read_text(encoding="utf-8").splitlines(), 1):
        s = line.strip()
        if not s or s.startswith("#"):
            continue
        if "=" not in s:
            warn(f".env บรรทัด {no}: ไม่มีเครื่องหมาย = (บรรทัดนี้จะถูกข้าม)")
            continue
        key, _, value = s.partition("=")
        if key != key.strip() or value != value.strip():
            warn(f".env บรรทัด {no} ({key.strip()}): มีเว้นวรรครอบ = — ควรเขียนติดกัน เช่น KEY=ค่า")
        if value.strip()[:1] in ("'", '"'):
            warn(f".env บรรทัด {no} ({key.strip()}): ไม่ต้องใส่ quote ครอบค่า")
        values[key.strip().removeprefix("export ").strip()] = llm_mod.clean(value)
    ok(5, ".env เป็น UTF-8 ไม่มี BOM")
    return values


def check_key_present(values: dict[str, str]) -> str:
    llm_mod.load_env()
    key = llm_mod.env("GEMINI_API_KEY")
    _secrets.append(key)
    if not key:
        hint = ""
        near = [k for k in values if "GEMINI" in k.upper() and k != "GEMINI_API_KEY"
                and k != "GEMINI_MODEL"]
        if near:
            hint = f"\nเจอชื่อที่คล้าย: {', '.join(near)} — ชื่อต้องเป็น GEMINI_API_KEY เป๊ะ ๆ"
        if any(k.startswith(("AIza", "gsk_")) or (v.startswith("AIza") and k != "GEMINI_API_KEY")
               for k, v in values.items()):
            hint += "\nเหมือนจะเอา key ไปใส่เป็นชื่อตัวแปร — บรรทัดต้องเป็น GEMINI_API_KEY=AIza..."
        bad(6, "ไม่มีค่า GEMINI_API_KEY ใน .env", f"""\
1) สร้าง key ที่ https://aistudio.google.com → Get API key → Create API key
2) เปิด .env แล้วใส่บรรทัดนี้ (ไม่มีเว้นวรรค ไม่มี quote):
     GEMINI_API_KEY=AIza...ของคุณ
3) กด Ctrl+S บันทึก แล้วรันไฟล์นี้ใหม่{hint}""")
    ok(6, "มี GEMINI_API_KEY", llm_mod.mask(key))
    return key


def check_key_format(key: str) -> None:
    if key.startswith("AIza") and len(key) == 39:
        ok(7, "รูปแบบ key เหมือน key จาก AI Studio (AIza..., 39 ตัว)")
    elif key.startswith("AIza"):
        ok(7, "key ขึ้นต้น AIza")
        warn(f"key ยาว {len(key)} ตัว (ปกติ 39) — อาจก๊อปมาไม่ครบหรือเกิน")
    else:
        ok(7, "มี key แต่ไม่ได้ขึ้นต้นด้วย AIza")
        warn("key ที่ไม่ขึ้นต้น AIza อาจไม่ได้มาจาก aistudio.google.com — ถ้าข้อต่อไปพัง "
             "ให้สร้าง key ใหม่ที่ AI Studio")
    google_key = llm_mod.env("GOOGLE_API_KEY")
    if google_key and google_key != key:
        _secrets.append(google_key)
        warn("เครื่องนี้มี GOOGLE_API_KEY ตั้งไว้ด้วย — โค้ดของเราใช้ GEMINI_API_KEY ใน .env เสมอ "
             "แต่โปรแกรมอื่นอาจสับสน")
    for py in (ROOT / "crew").glob("*.py"):
        if re.search(r"AIza[0-9A-Za-z_\-]{20,}|gsk_[0-9A-Za-z]{20,}", py.read_text(encoding="utf-8")):
            warn(f"เจอสิ่งที่หน้าตาเหมือน key ใน {py.relative_to(ROOT)} — ห้ามใส่ key ในโค้ด! "
                 "ใส่ใน .env เท่านั้น และโค้ดต้องเขียน os.getenv(\"GEMINI_API_KEY\") (ชื่อตัวแปร ไม่ใช่ key)")


# ---------------------------------------------------------------- 8–11 Gemini

def version_of(name: str) -> float:
    m = re.search(r"gemini-(\d+(?:\.\d+)?)", name)
    return float(m.group(1)) if m else 0.0


def recommend(models: list[str]) -> str:
    stable = [m for m in models
              if not re.search(r"preview|exp|latest|tts|image|audio|live|thinking|embedding", m)]
    for kind in ("flash-lite", "flash"):
        pool = [m for m in stable if kind in m and (kind != "flash" or "lite" not in m)]
        if pool:
            return sorted(pool, key=lambda m: (-version_of(m), len(m), m))[0]
    return models[0]


def check_models(key: str):
    from google import genai
    from google.genai import types

    client = genai.Client(api_key=key, http_options=types.HttpOptions(timeout=30_000))
    try:
        models = sorted(
            m.name.removeprefix("models/") for m in client.models.list()
            if "generateContent" in (m.supported_actions or []))
    except Exception as exc:  # noqa: BLE001
        api_bad(8, "ดึงรายชื่อโมเดลจาก Gemini ไม่ได้", exc)
    if not models:
        bad(8, "key นี้ไม่เห็นโมเดลที่ใช้ generateContent ได้เลย",
            "สร้าง key ใหม่ที่ https://aistudio.google.com แล้วลองใหม่")
    ok(8, f"ดึงรายชื่อโมเดลได้ ({len(models)} รุ่นที่ใช้ generateContent)")
    return client, models


def check_recommend(models: list[str]) -> tuple[str, str]:
    rec = recommend(models)
    current = llm_mod.env("GEMINI_MODEL").removeprefix("models/").removeprefix("gemini/")
    if current and current not in models:
        bad(9, f"GEMINI_MODEL={current} ไม่มีในรายชื่อ (จะเจอ 404 NOT_FOUND)", f"""\
รุ่นนี้ถูกปิดหรือพิมพ์ผิด (เช่น gemini-1.5-flash เลิกให้บริการแล้ว)
แก้ใน .env เป็น:
  GEMINI_MODEL={rec}""")
    ok(9, f"รุ่นที่แนะนำ: {rec}",
       f"ใน .env ตั้งไว้ {current}" if current else "ยังไม่ได้ตั้ง GEMINI_MODEL ใน .env")
    if current and current != rec:
        warn(f"ใช้ {current} ต่อได้ แต่ทีมแนะนำ {rec} (ไม่ใช่ preview โควตาฟรีเยอะกว่า)")
    if current and "preview" in current:
        warn("รุ่น preview อาจถูกปิดเมื่อไรก็ได้ และโควตาฟรีน้อย")
    return rec, current or rec


def check_genai_call(client, model: str) -> None:
    try:
        resp = client.models.generate_content(model=model, contents="ตอบสั้น ๆ คำเดียวว่า OK")
    except Exception as exc:  # noqa: BLE001
        api_bad(10, f"เรียก {model} ผ่าน google-genai ไม่ผ่าน", exc)
    ok(10, f"เรียก {model} ผ่าน google-genai ได้", f"ตอบว่า: {(resp.text or '').strip()[:40]!r}")


def check_crewai_call(model: str) -> None:
    os.environ["GEMINI_MODEL"] = model
    try:
        reply = llm_mod.gemini_llm().call("ตอบสั้น ๆ คำเดียวว่า OK")
    except Exception as exc:  # noqa: BLE001
        api_bad(11, f"เรียก {model} ผ่าน crewai.LLM ไม่ผ่าน", exc)
    ok(11, f"เรียก {model} ผ่าน crewai.LLM ได้", f"ตอบว่า: {str(reply).strip()[:40]!r}")


# ---------------------------------------------------------------- 12 Groq

GROQ_PREFERRED = ("llama-3.3-70b-versatile", "openai/gpt-oss-120b", "llama-3.1-8b-instant")


def check_groq() -> str | None:
    key = llm_mod.env("GROQ_API_KEY")
    if not key:
        ok(12, "ข้าม Groq (ไม่ได้ใส่ GROQ_API_KEY — ไม่บังคับ แต่แนะนำไว้สำรองตอน Gemini โควตาหมด)")
        return None
    _secrets.append(key)
    if not key.startswith("gsk_"):
        warn(f"GROQ_API_KEY ({llm_mod.mask(key)}) ไม่ขึ้นต้น gsk_ — อาจก๊อปผิด")
    import httpx

    try:
        r = httpx.get(f"{llm_mod.GROQ_BASE_URL}/models",
                      headers={"Authorization": f"Bearer {key}"}, timeout=30)
        r.raise_for_status()
        ids = sorted(m["id"] for m in r.json().get("data", []) if m.get("active", True))
    except httpx.HTTPStatusError as exc:
        exc.code = exc.response.status_code  # ให้ error_kind อ่านรหัสได้
        api_bad(12, "ดึงรายชื่อโมเดล Groq ไม่ได้", exc)
    except Exception as exc:  # noqa: BLE001
        api_bad(12, "ดึงรายชื่อโมเดล Groq ไม่ได้", exc)
    chat = [i for i in ids if not re.search(r"whisper|tts|guard|playai|orpheus|compound", i)]
    rec = next((m for m in GROQ_PREFERRED if m in chat), chat[0] if chat else None)
    if rec is None:
        bad(12, "Groq ไม่มีโมเดลแชตให้ใช้", "ลองใหม่ภายหลัง หรือข้าม Groq ไปก่อน (ลบ GROQ_API_KEY ใน .env)")
    current = llm_mod.env("GROQ_MODEL")
    if current and current not in ids:
        bad(12, f"GROQ_MODEL={current} ไม่มีในรายชื่อของ Groq", f"แก้ใน .env เป็น:\n  GROQ_MODEL={rec}")
    model = current or rec
    os.environ["GROQ_MODEL"] = model
    try:
        reply = llm_mod.groq_llm().call("ตอบสั้น ๆ คำเดียวว่า OK")
    except Exception as exc:  # noqa: BLE001
        api_bad(12, f"เรียก Groq {model} ผ่าน crewai.LLM ไม่ผ่าน", exc)
    ok(12, f"เรียก Groq {model} ผ่าน crewai.LLM ได้", f"ตอบว่า: {str(reply).strip()[:40]!r}")
    return rec if not current else current


# ---------------------------------------------------------------- main

def main() -> int:
    for stream in (sys.stdout, sys.stderr):
        try:
            stream.reconfigure(encoding="utf-8", errors="replace")
        except (AttributeError, ValueError):
            pass
    print("ตรวจเครื่องสำหรับ PetPal Health (CrewAI)\n" + "-" * 60)
    try:
        check_venv()
        check_python()
        check_packages()
        if check_env_file():
            values = check_env_encoding()
        else:
            values = {}
            ok(5, "ข้ามการตรวจ encoding (ไม่ได้ใช้ไฟล์ .env)")
        key = check_key_present(values)
        check_key_format(key)
        client, models = check_models(key)
        rec, use = check_recommend(models)
        check_genai_call(client, use)
        check_crewai_call(use)
        groq_model = check_groq()
    except Stop:
        print("-" * 60 + "\nแก้ข้อ [แก้] ด้านบน แล้วรัน python crew/check_setup.py อีกครั้ง")
        return 1
    except KeyboardInterrupt:
        print("\nยกเลิก")
        return 1
    except Exception as exc:  # noqa: BLE001 — กันไม่ให้มือใหม่เห็น traceback ยาว ๆ
        print(f"\n[แก้] เจอ error ที่ไม่คาดไว้: {type(exc).__name__}: {safe(str(exc))[:300]}")
        print("     ก๊อปข้อความนี้ (ไม่มี key) ส่งในกลุ่ม หรือดู docs/SETUP_CREWAI.md ข้อ 12")
        return 1

    print("-" * 60)
    ok(13, "ผ่านทุกข้อ! ใส่/ตรวจบรรทัดนี้ใน .env:")
    print(f"\nGEMINI_MODEL={rec}")
    if groq_model:
        print(f"GROQ_MODEL={groq_model}")
    print("\nบันทึก .env แล้วไปต่อที่ docs/SETUP_CREWAI.md ข้อ 8")
    return 0


if __name__ == "__main__":
    sys.exit(main())
