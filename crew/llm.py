"""สร้าง LLM ให้ CrewAI จากค่าใน .env

- Gemini เป็นตัวหลัก (GEMINI_API_KEY + GEMINI_MODEL)
- Groq เป็นตัวสำรอง (GROQ_API_KEY + GROQ_MODEL) — main.py สลับมาใช้อัตโนมัติเมื่อ Gemini ตอบ 429/โควตาหมด
- ไม่ hardcode ชื่อรุ่นในโค้ด: ให้รัน crew/check_setup.py แล้วใส่รุ่นที่แนะนำลง .env

ไฟล์นี้ import ได้โดยไม่ต้องมี crewai/dotenv (import แบบ lazy) เพื่อให้ check_setup.py ใช้ซ้ำได้
"""

from __future__ import annotations

import os
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ENV_PATH = ROOT / ".env"
GROQ_BASE_URL = "https://api.groq.com/openai/v1"


class SetupError(RuntimeError):
    """ตั้งค่าไม่ครบ — ข้อความเป็นวิธีแก้ภาษาไทย พิมพ์ให้ผู้ใช้ได้เลย"""


def clean(value: str | None) -> str:
    """ตัดเว้นวรรคและ quote ที่เผลอใส่มารอบค่า เช่น ' "AIza..." ' → AIza..."""
    value = (value or "").strip()
    while len(value) >= 2 and value[0] == value[-1] and value[0] in "\"'":
        value = value[1:-1].strip()
    return value


def mask(secret: str) -> str:
    """แสดง key แค่ 6 ตัวแรก + 4 ตัวท้าย"""
    if len(secret) <= 12:
        return "*" * len(secret)
    return f"{secret[:6]}...{secret[-4:]}"


def env_file_problem() -> str | None:
    """ตรวจ encoding ของ .env (crewai อ่าน .env ตอน import — ถ้า encoding ผิด import crewai จะพัง)"""
    if not ENV_PATH.is_file():
        return None
    raw = ENV_PATH.read_bytes()
    if raw.startswith((b"\xff\xfe", b"\xfe\xff")) or b"\x00" in raw:
        return ".env เป็น UTF-16 (อ่านไม่ได้)"
    if raw.startswith(b"\xef\xbb\xbf"):
        return ".env มี BOM นำหน้า (UTF-8 with BOM)"
    try:
        raw.decode("utf-8")
    except UnicodeDecodeError as exc:
        return f".env ไม่ใช่ UTF-8 ({exc.reason} ที่ byte {exc.start})"
    return None


def load_env() -> None:
    """อ่าน .env ที่ root repo

    ค่าที่ไม่ว่างใน .env ชนะ environment variable เดิมของเครื่อง ส่วนบรรทัดว่าง (เช่น GROQ_API_KEY=)
    จะไม่ลบค่าที่มีอยู่แล้ว — Codespaces secrets จึงยังใช้ได้แม้มี .env ที่ก๊อปจาก .env.example
    """
    # ปิด tracing/telemetry ของ crewai: ไม่ส่งข้อมูลออก และไม่ถาม input() ตอนรันครั้งแรก
    os.environ.setdefault("CREWAI_TRACING_ENABLED", "false")
    os.environ.setdefault("CREWAI_DISABLE_TELEMETRY", "true")
    os.environ.setdefault("OTEL_SDK_DISABLED", "true")
    from dotenv import dotenv_values

    if ENV_PATH.is_file():
        for name, value in dotenv_values(ENV_PATH, encoding="utf-8-sig").items():
            if clean(value):
                os.environ[name] = clean(value)


def env(name: str) -> str:
    return clean(os.getenv(name))


def max_rpm() -> int:
    try:
        return max(1, int(env("MAX_RPM") or 8))
    except ValueError:
        return 8


def gemini_llm():
    key, model = env("GEMINI_API_KEY"), env("GEMINI_MODEL")
    if not key:
        raise SetupError(
            "ไม่พบ GEMINI_API_KEY ใน .env → ดู docs/SETUP_CREWAI.md ข้อ 5–6 "
            "แล้วรัน python crew/check_setup.py"
        )
    if not model:
        raise SetupError(
            "ยังไม่ได้ตั้ง GEMINI_MODEL ใน .env → รัน python crew/check_setup.py "
            "แล้วก๊อปบรรทัด GEMINI_MODEL=... ที่มันแนะนำไปใส่ .env"
        )
    model = model.removeprefix("models/").removeprefix("gemini/")
    from crewai import LLM

    # ส่ง api_key ตรง ๆ: crewai จะใช้ GOOGLE_API_KEY ของเครื่องก่อน ถ้าไม่ส่ง
    return LLM(model=f"gemini/{model}", api_key=key, temperature=0.4)


def groq_configured() -> bool:
    return bool(env("GROQ_API_KEY") and env("GROQ_MODEL"))


def groq_llm():
    key, model = env("GROQ_API_KEY"), env("GROQ_MODEL")
    if not key or not model:
        raise SetupError(
            "ต้องมีทั้ง GROQ_API_KEY และ GROQ_MODEL ใน .env ถึงจะใช้ Groq ได้ "
            "→ รัน python crew/check_setup.py เพื่อดูรุ่นที่แนะนำ"
        )
    from crewai import LLM

    # Groq มี endpoint แบบ OpenAI → ใช้ตัวเชื่อม openai ที่ติดมากับ crewai ได้เลย
    return LLM(
        model=f"openai/{model.removeprefix('groq/')}",
        base_url=GROQ_BASE_URL,
        api_key=key,
        temperature=0.4,
    )


def providers() -> list[tuple[str, object]]:
    """ลำดับผู้ให้บริการที่จะลอง: Gemini ก่อน แล้วค่อย Groq (ถ้าตั้งค่าไว้)"""
    order: list[tuple[str, object]] = [("gemini", gemini_llm)]
    if groq_configured():
        order.append(("groq", groq_llm))
    return order


# ---------------------------------------------------------------- จำแนก error

def _chain(exc: BaseException):
    seen = set()
    while exc is not None and id(exc) not in seen:
        seen.add(id(exc))
        yield exc
        exc = exc.__cause__ or exc.__context__


def error_kind(exc: BaseException) -> str:
    """คืนค่า '400' / '401' / '403' / '404' / '429' / 'network' / 'other'"""
    for e in _chain(exc):
        code = getattr(e, "code", None) or getattr(e, "status_code", None)
        if isinstance(code, int) and code in (400, 401, 403, 404, 429):
            return str(code)
        name = type(e).__name__
        if name in ("ConnectError", "ConnectTimeout", "ReadTimeout", "APIConnectionError",
                    "APITimeoutError", "SSLError", "SSLCertVerificationError", "gaierror",
                    "TimeoutException", "ProxyError"):
            return "network"
    text = " ".join(str(e) for e in _chain(exc))
    upper = text.upper()
    if "RESOURCE_EXHAUSTED" in upper or "429" in text or "QUOTA" in upper or "RATE LIMIT" in upper:
        return "429"
    if "API_KEY_INVALID" in upper or "API KEY NOT VALID" in upper or "INVALID_ARGUMENT" in upper:
        return "400"
    if "PERMISSION_DENIED" in upper:
        return "403"
    if "NOT_FOUND" in upper or "IS NOT FOUND" in upper:
        return "404"
    if "CERTIFICATE" in upper or "SSL" in upper or "GETADDRINFO" in upper or "CONNECTION" in upper:
        return "network"
    return "other"


def is_quota_error(exc: BaseException) -> bool:
    return error_kind(exc) == "429"


EXPLAIN = {
    "400": "400 — key ไม่ถูกต้อง (API_KEY_INVALID) หรือคำขอผิดรูปแบบ\n"
           "  วิธีแก้: ก๊อป key ใหม่จาก aistudio.google.com → Get API key ให้ครบทุกตัว ไม่มีเว้นวรรค/quote",
    "401": "401 — key ไม่ถูกต้องหรือถูกลบไปแล้ว\n"
           "  วิธีแก้: สร้าง key ใหม่ที่หน้าเว็บของผู้ให้บริการ แล้วแก้ใน .env",
    "403": "403 — key นี้ไม่มีสิทธิ์ใช้ Gemini API (PERMISSION_DENIED)\n"
           "  สาเหตุบ่อย: ใช้ key จาก Google Cloud Console ที่ไม่ได้เปิด Generative Language API, "
           "ตั้ง API restriction ไว้, หรือประเทศ/บัญชีถูกจำกัด\n"
           "  วิธีแก้: สร้าง key ใหม่ที่ aistudio.google.com (ไม่ใช่ console.cloud.google.com)",
    "404": "404 — ไม่พบรุ่นนี้ (NOT_FOUND) เช่น ใช้ชื่อรุ่นเก่าอย่าง gemini-1.5-flash ที่ถูกปิดแล้ว\n"
           "  วิธีแก้: รัน python crew/check_setup.py แล้วใช้ GEMINI_MODEL ที่มันแนะนำ",
    "429": "429 — โควตาฟรีหมดหรือเรียกถี่เกิน (RESOURCE_EXHAUSTED)\n"
           "  วิธีแก้: รอ 1 นาทีแล้วลองใหม่ / ลด MAX_RPM ใน .env / ถ้าโควตารายวันหมด รอพรุ่งนี้ "
           "หรือใส่ GROQ_API_KEY + GROQ_MODEL ให้ระบบสลับไป Groq อัตโนมัติ",
    "network": "เชื่อมต่อเน็ตไม่ได้ (timeout / SSL / DNS)\n"
               "  วิธีแก้: เช็กเน็ต, ถ้าใช้ Wi-Fi มหาลัยลองสลับไปฮอตสปอตมือถือ, ปิด VPN/proxy "
               "หรือใช้ GitHub Codespaces (docs/SETUP_CREWAI.md ข้อ 14)",
    "other": "error ที่ไม่รู้จัก — อ่านข้อความด้านบน แล้วดูตารางแก้ปัญหาใน docs/SETUP_CREWAI.md ข้อ 12",
}


def explain(exc: BaseException) -> str:
    return EXPLAIN[error_kind(exc)]
