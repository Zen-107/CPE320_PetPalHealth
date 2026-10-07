"""PetPal Health — รัน agent ของ CrewAI ตามบทบาท

    python crew/main.py --feature water --role product   # A: เขียน requirements.md
    python crew/main.py --feature water --role design    # B: เขียน ux-flow.md + game-rules.md
    python crew/main.py --feature water --role review    # C: เขียน review.md

ตัวเลือกเพิ่ม:
    --note "ข้อความ"   สั่งเพิ่มเติมรอบนี้ เช่น "เพิ่ม edge case ตอนเปลี่ยนวัน"
    --overwrite        ยอมเขียนทับไฟล์ output เดิม (ปกติจะหยุดเพื่อกันงานที่แก้มือหาย)

ทุกรอบจะบันทึก prompt ที่ส่งจริง + ผลลัพธ์ลง logs/<YYYYMMDD-HHMM>_<role>_<feature>.md อัตโนมัติ
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import time
import traceback
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import llm as llm_mod  # noqa: E402
from load_agents import AgentNotDesigned, build_agent, require_designed  # noqa: E402

ROOT = llm_mod.ROOT
DOCS = ROOT / "docs"
TEMPLATES = DOCS / "_templates"
LOGS = ROOT / "logs"


@dataclass
class Output:
    filename: str
    instruction: str


@dataclass
class Role:
    agent: str
    inputs: list[tuple[str, bool]]  # (ชื่อไฟล์ใน docs/<feature>/, บังคับต้องมีไหม)
    outputs: list[Output]
    include_app: bool = False       # ส่งโค้ดใน app/ ให้ agent อ่านด้วย


ROLES = {
    "product": Role(
        agent="product",
        inputs=[("brief.md", False)],
        outputs=[Output(
            "requirements.md",
            "เขียน requirements ของฟีเจอร์นี้ตามโครงของ template ทุกหัวข้อ: "
            "user story รูปแบบ 'ในฐานะ…ฉันอยาก…เพื่อ…', acceptance criteria ที่มีตัวเลขทดสอบได้ทุกข้อ, "
            "edge cases, สิ่งที่ไม่ทำในรอบนี้, ข้อมูลที่ใช้ (ข้อมูลสมมติเท่านั้น) และคำถามที่ยังเปิดอยู่",
        )],
    ),
    "design": Role(
        agent="design",
        inputs=[("requirements.md", True)],
        outputs=[
            Output(
                "ux-flow.md",
                "ออกแบบ UX flow ตาม requirements: รายการหน้าจอ, ขั้นตอนการใช้งานทีละขั้น, "
                "สถานะของแต่ละหน้าจอ (ปกติ/ว่าง/ผิดพลาด), ข้อความบนปุ่ม และตารางชื่อไฟล์ภาพ assets",
            ),
            Output(
                "game-rules.md",
                "เขียนกติกาเกมเป็นตารางตัวเลขที่ Dev นำไปเขียนโค้ดได้ทันที: ค่าเริ่มต้น, ค่าที่เพิ่ม/ลด, "
                "ค่าสูงสุด/ต่ำสุด, ช่วงเวลา, เกณฑ์อารมณ์ของสัตว์เลี้ยง, พฤติกรรมที่ขอบเขต (เช่น ค่าเกิน max) "
                "และชื่อไฟล์ภาพของแต่ละสถานะ — ทุกตัวเลขต้องตรงกับ acceptance criteria และ ux-flow",
            ),
        ],
    ),
    "review": Role(
        agent="reviewer",
        inputs=[("requirements.md", True), ("ux-flow.md", False), ("game-rules.md", False)],
        outputs=[Output(
            "review.md",
            "รีวิวเอกสารทั้งหมด (และโค้ดใน app/ ถ้ามี) ด้วย checklist ใน template ทีละข้อ "
            "(ผ่าน/ไม่ผ่าน + เหตุผล), ระบุปัญหาพร้อมไฟล์/หัวข้อ/ข้อเสนอแก้, ตรวจว่าตัวเลขในทุกไฟล์ตรงกัน, "
            "สรุปผลว่า 'พร้อมส่ง Dev' หรือ 'ต้องแก้' และเติมตารางผลวัด agent จากข้อมูล log ที่ให้",
        )],
        include_app=True,
    ),
}
APP = ROOT / "app"
APP_CODE_LIMIT = 40_000  # ตัวอักษร — กันไม่ให้ prompt ใหญ่จนโควตาฟรีหมด


# ---------------------------------------------------------------- utilities

def fail(message: str, code: int = 1) -> int:
    print(f"\n[แก้] {message}")
    return code


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8-sig")


def strip_fences(text: str) -> str:
    """ตัด ```markdown ... ``` ที่ LLM ชอบห่อมาทั้งก้อน"""
    text = text.strip()
    m = re.match(r"^```[a-zA-Z]*\s*\n(.*)\n```$", text, re.S)
    return (m.group(1) if m else text).strip() + "\n"


def log_path(role: str, feature: str) -> Path:
    stamp = datetime.now().strftime("%Y%m%d-%H%M")
    path = LOGS / f"{stamp}_{role}_{feature}.md"
    n = 2
    while path.exists():
        path = LOGS / f"{stamp}_{role}_{feature}-{n}.md"
        n += 1
    return path


def previous_runs(feature: str) -> str:
    """สรุป metadata ของ log เดิมของฟีเจอร์นี้ ให้ reviewer ใช้ทำตารางผลวัด agent"""
    rows = []
    for p in sorted(LOGS.glob(f"*_{feature}*.md")):
        m = re.search(r"<!-- meta: (\{.*?\}) -->", read(p))
        if m:
            meta = json.loads(m.group(1))
            rows.append(f"- {p.name}: " + ", ".join(f"{k}={v}" for k, v in meta.items()))
    return "\n".join(rows) or "(ยังไม่มี log ของฟีเจอร์นี้)"


def app_code() -> tuple[str, list[str]]:
    """รวมโค้ดใน app/ ให้ reviewer อ่าน: pubspec.yaml, app/lib/ (โค้ดแอป), app/test/ (เทสต์)"""
    files = (sorted(APP.glob("pubspec.yaml")) + sorted((APP / "lib").rglob("*.dart"))
             + sorted((APP / "test").rglob("*.dart")))
    if not files:
        return "(ยังไม่มีโค้ดใน app/)", []
    parts, used, total = [], [], 0
    for p in files:
        rel = str(p.relative_to(ROOT)).replace("\\", "/")
        text = read(p)
        if total + len(text) > APP_CODE_LIMIT:
            parts.append(f"(ตัดที่ {APP_CODE_LIMIT} ตัวอักษร — ไฟล์ที่เหลือไม่ได้ส่ง)")
            break
        parts.append(f"=== {rel} ===\n{text}\n=== จบ {rel} ===")
        used.append(rel)
        total += len(text)
    return "\n\n".join(parts), used


def agent_version(path: Path) -> str:
    """hash 8 ตัวของไฟล์ agent — ใช้บอกว่ารอบนี้รันด้วย agent เวอร์ชันไหน"""
    import hashlib

    return hashlib.sha1(path.read_bytes()).hexdigest()[:8]


def contract_problem(spec, role: Role, feature: str) -> str | None:
    """เทียบ input_files/output_file ใน frontmatter กับข้อตกลงที่ main.py ใช้จริง"""
    norm = lambda paths: sorted(p.replace("\\", "/").rstrip("/") for p in paths)  # noqa: E731
    want_out = norm(f"docs/{feature}/{o.filename}" for o in role.outputs)
    want_in = norm([f"docs/{feature}/{f}" for f, _ in role.inputs] + (["app"] if role.include_app else []))
    got = spec.render(feature)
    rows = []
    if norm(got.output_files) != want_out:
        rows.append(f"output_file ควรเป็น {want_out} แต่ในไฟล์คือ {norm(got.output_files)}")
    if norm(got.input_files) != want_in:
        rows.append(f"input_files ควรเป็น {want_in} แต่ในไฟล์คือ {norm(got.input_files)}")
    if not rows:
        return None
    return (f"agents/{spec.path.name}: ช่องข้อตกลงทีมไม่ตรงกับที่โค้ดใช้\n  " + "\n  ".join(rows)
            + "\n  ช่อง name/owner/input_files/output_file เป็นข้อตกลงร่วม — คืนค่าเดิม "
              "หรือเปิด Issue ถ้าทีมตกลงเปลี่ยน (ต้องแก้ crew/main.py ด้วย)")


def fence(text: str) -> str:
    return f"~~~~text\n{text.strip()}\n~~~~"


# ---------------------------------------------------------------- run

@dataclass
class Attempt:
    provider: str
    model: str = ""
    status: str = "ล้มเหลว"
    error: str = ""
    trace: str = ""
    exc: Exception | None = None
    seconds: float = 0.0
    calls: list[dict] = field(default_factory=list)
    usage: dict = field(default_factory=dict)
    results: dict[str, str] = field(default_factory=dict)
    agent_text: str = ""
    task_texts: list[str] = field(default_factory=list)


def build_tasks(role: Role, feature: str, agent, context_text: str, note: str):
    from crewai import Task

    tasks, texts = [], []
    for out in role.outputs:
        template = read(TEMPLATES / out.filename)
        description = (
            f"ฟีเจอร์: {feature}\n\n"
            f"งานของคุณ: {out.instruction}\n\n"
            f"ข้อมูลประกอบ:\n{context_text}\n\n"
            + (f"คำสั่งเพิ่มเติมรอบนี้จากทีม: {note}\n\n" if note else "")
            + f"ให้เขียนตามโครงของ template นี้ (แทนที่ข้อความใน <...> ด้วยเนื้อหาจริง):\n"
            f"=== template: docs/_templates/{out.filename} ===\n{template}\n=== จบ template ===\n\n"
            "กฎ: ตอบเป็น Markdown ภาษาไทยเท่านั้น ไม่ต้องห่อด้วย ``` ไม่ต้องมีคำเกริ่นหรือคำลงท้าย "
            "ข้อมูลสุขภาพ/ข้อมูลผู้ใช้ทั้งหมดต้องเป็นข้อมูลสมมติ"
        )
        expected = f"เนื้อหาไฟล์ docs/{feature}/{out.filename} ฉบับสมบูรณ์ ตามโครง template"
        task = Task(description=description, expected_output=expected, agent=agent,
                    context=list(tasks) or None)
        tasks.append(task)
        texts.append(f"#### Task → docs/{feature}/{out.filename}\n\n{fence(description)}\n\n"
                     f"expected_output: {expected}")
    return tasks, texts


def run_attempt(name: str, factory, args, role: Role, context_text: str) -> Attempt:
    from crewai import Crew, Process
    from crewai.events import (LLMCallCompletedEvent, LLMCallFailedEvent,
                               LLMCallStartedEvent, crewai_event_bus)

    attempt = Attempt(provider=name)
    started = time.perf_counter()
    try:
        model = factory()
        attempt.model = getattr(model, "model", "")
        agent, spec = build_agent(role.agent, args.feature, model, llm_mod.max_rpm())
        attempt.agent_text = (f"- ไฟล์: agents/{spec.path.name}\n- role: {spec.role}\n"
                              f"- goal: {spec.goal}\n- backstory:\n\n{fence(spec.backstory)}")
        tasks, attempt.task_texts = build_tasks(role, args.feature, agent, context_text, args.note)

        with crewai_event_bus.scoped_handlers():
            @crewai_event_bus.on(LLMCallStartedEvent)
            def _start(source, event):
                attempt.calls.append({"messages": event.messages, "response": None, "error": None})

            @crewai_event_bus.on(LLMCallCompletedEvent)
            def _done(source, event):
                if attempt.calls:
                    attempt.calls[-1]["response"] = event.response

            @crewai_event_bus.on(LLMCallFailedEvent)
            def _failed(source, event):
                if attempt.calls:
                    attempt.calls[-1]["error"] = event.error

            crew = Crew(agents=[agent], tasks=tasks, process=Process.sequential,
                        verbose=True, max_rpm=llm_mod.max_rpm())
            output = crew.kickoff()
            crewai_event_bus.flush()

        for out, task_out in zip(role.outputs, output.tasks_output):
            attempt.results[out.filename] = strip_fences(task_out.raw or "")
        usage = getattr(output, "token_usage", None)
        if usage is not None:
            attempt.usage = {k: getattr(usage, k, None) for k in
                             ("prompt_tokens", "completion_tokens", "total_tokens",
                              "successful_requests")}
        empty = [f for f, text in attempt.results.items() if not text.strip()]
        if empty:
            raise RuntimeError(f"agent ตอบกลับว่างเปล่าสำหรับ {', '.join(empty)}")
        attempt.status = "สำเร็จ"
    except Exception as exc:  # noqa: BLE001 — ทุก error ต้องถูกบันทึกลง log
        attempt.error = f"{type(exc).__name__}: {exc}"
        attempt.trace = traceback.format_exc()
        attempt.exc = exc
    attempt.seconds = round(time.perf_counter() - started, 1)
    return attempt


def format_messages(messages) -> str:
    if isinstance(messages, str):
        return messages
    parts = []
    for m in messages or []:
        if isinstance(m, dict):
            parts.append(f"[{m.get('role', '?')}]\n{m.get('content', '')}")
        else:
            parts.append(str(m))
    return "\n\n".join(parts)


def write_log(path: Path, args, inputs_used: list[str], attempts: list[Attempt],
              written: list[str], agent_file: str, agent_ver: str) -> None:
    final = attempts[-1] if attempts else None
    ok = bool(final and final.status == "สำเร็จ")
    usage = final.usage if final else {}
    meta = {
        "role": args.role, "feature": args.feature,
        "time": datetime.now().strftime("%Y-%m-%d %H:%M"),
        "status": "ok" if ok else "fail",
        "provider": final.provider if final else "",
        "model": final.model if final else "",
        "attempts": len(attempts),
        "seconds": round(sum(a.seconds for a in attempts), 1),
        "llm_calls": sum(len(a.calls) for a in attempts),
        "total_tokens": usage.get("total_tokens"),
        "agent_version": agent_ver,
    }
    lines = [
        f"# Log: {args.role} · {args.feature} · {meta['time']}",
        "",
        f"<!-- meta: {json.dumps(meta, ensure_ascii=False)} -->",
        "",
        "| รายการ | ค่า |",
        "|---|---|",
        f"| สถานะ | {'สำเร็จ' if ok else 'ล้มเหลว'} |",
        f"| ผู้ให้บริการ / รุ่น | {meta['provider']} / {meta['model']} |",
        "| ลำดับความพยายาม | " + " → ".join(
            f"{a.provider}: {a.status}" + (f" ({llm_mod.error_kind(a.exc)})"
                                           if a.exc else "")
            for a in attempts) + " |",
        f"| เวลารวม | {meta['seconds']} วินาที |",
        f"| จำนวนครั้งที่เรียก LLM | {meta['llm_calls']} |",
        f"| tokens (prompt / completion / total) | {usage.get('prompt_tokens')} / "
        f"{usage.get('completion_tokens')} / {usage.get('total_tokens')} |",
        f"| ไฟล์ input | {', '.join(inputs_used) or '-'} |",
        f"| ไฟล์ output | {', '.join(written) or '-'} |",
        f"| agent | {agent_file} (เวอร์ชัน {agent_ver}) |",
        f"| --note | {args.note or '-'} |",
        "",
    ]
    for i, a in enumerate(attempts, 1):
        lines += [f"## ความพยายามที่ {i} — {a.provider} ({a.model or '-'}) — {a.status}, "
                  f"{a.seconds} วินาที", ""]
        if a.agent_text:
            lines += ["### Agent", "", a.agent_text, ""]
        if a.task_texts:
            lines += ["### Tasks (prompt ที่ main.py สร้าง)", "", *a.task_texts, ""]
        previous = None
        for n, call in enumerate(a.calls, 1):
            sent = format_messages(call["messages"])
            lines += [f"### LLM call {n} — ข้อความที่ส่งจริง", "",
                      "(เหมือน call ก่อนหน้า — ส่งซ้ำ)" if sent == previous else fence(sent), ""]
            previous = sent
            if call["response"] is not None:
                lines += [f"### LLM call {n} — คำตอบ", "", fence(str(call["response"])), ""]
            if call["error"]:
                lines += [f"### LLM call {n} — error", "", fence(str(call["error"])), ""]
        for filename, text in a.results.items():
            lines += [f"### ผลลัพธ์ → docs/{args.feature}/{filename}", "", fence(text), ""]
        if a.error:
            lines += ["### Error", "", fence(a.error), "", "<details><summary>traceback</summary>",
                      "", fence(a.trace), "", "</details>", ""]
    LOGS.mkdir(exist_ok=True)
    path.write_text("\n".join(lines), encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    for stream in (sys.stdout, sys.stderr):
        try:
            stream.reconfigure(encoding="utf-8", errors="replace")
        except (AttributeError, ValueError):
            pass

    parser = argparse.ArgumentParser(description="รัน agent ของ PetPal Health ตามบทบาท")
    parser.add_argument("--feature", required=True, help="ชื่อฟีเจอร์ เช่น water")
    parser.add_argument("--role", required=True, choices=sorted(ROLES))
    parser.add_argument("--note", default="", help="คำสั่งเพิ่มเติมรอบนี้")
    parser.add_argument("--overwrite", action="store_true", help="เขียนทับ output เดิม")
    args = parser.parse_args(argv)

    if not re.fullmatch(r"[a-z0-9][a-z0-9-]*", args.feature):
        return fail("--feature ใช้ได้แค่ a-z 0-9 และ - เช่น water หรือ sleep-time", 2)

    problem = llm_mod.env_file_problem()
    if problem:
        return fail(f"{problem} → รัน python crew/check_setup.py เพื่อดูวิธีแก้")
    try:
        llm_mod.load_env()
        import crewai  # noqa: F401
    except ImportError:
        return fail("ยังไม่ได้ติดตั้งแพ็กเกจหรือยังไม่ได้ activate .venv "
                    "→ รัน python crew/check_setup.py เพื่อดูวิธีแก้")

    role = ROLES[args.role]
    feature_dir = DOCS / args.feature
    feature_dir.mkdir(parents=True, exist_ok=True)

    # 0) agent ต้องถูกออกแบบแล้ว และช่องข้อตกลงทีมต้องตรงกับโค้ด
    try:
        spec = require_designed(role.agent)
    except AgentNotDesigned as exc:
        return fail(str(exc))
    except KeyError as exc:
        return fail(str(exc.args[0]))
    except ValueError as exc:
        return fail(str(exc))
    problem = contract_problem(spec, role, args.feature)
    if problem:
        return fail(problem)
    agent_file = f"agents/{spec.path.name}"
    agent_ver = agent_version(spec.path)

    # 1) ไฟล์ input
    context_parts, inputs_used = [], []
    for filename, required in role.inputs:
        path = feature_dir / filename
        if path.is_file() and "TODO" in read(path) and not required:
            print(f"[เตือน] docs/{args.feature}/{filename} ยังมี TODO (ยังเป็นแม่แบบ) "
                  "— จะไม่ส่งไฟล์นี้ให้ agent")
            context_parts.append(f"(docs/{args.feature}/{filename} ยังไม่ได้เขียน)")
        elif path.is_file():
            context_parts.append(f"=== docs/{args.feature}/{filename} ===\n{read(path)}\n"
                                 f"=== จบ {filename} ===")
            inputs_used.append(f"docs/{args.feature}/{filename}")
        elif required:
            return fail(f"ยังไม่มี docs/{args.feature}/{filename} — บทบาท {args.role} "
                        f"ต้องรอไฟล์นี้ก่อน (git pull แล้วดูว่าเพื่อนส่งงานแล้วหรือยัง)")
        else:
            print(f"[เตือน] ไม่มี docs/{args.feature}/{filename} — จะทำงานต่อโดยไม่ใช้ไฟล์นี้")
            context_parts.append(f"(ยังไม่มี docs/{args.feature}/{filename})")
    if role.include_app:
        code, used = app_code()
        context_parts.append(f"=== โค้ดใน app/ ===\n{code}\n=== จบโค้ด ===")
        inputs_used += used
    if args.role == "review":
        context_parts.append(f"=== ข้อมูลจาก log ของฟีเจอร์นี้ (ใช้ทำตารางผลวัด agent) ===\n"
                             f"{previous_runs(args.feature)}")
    if args.role == "product" and "docs/" + args.feature + "/brief.md" not in inputs_used:
        context_parts.append(f"ฟีเจอร์ชื่อ '{args.feature}' ของแอป PetPal Health "
                             "(แอปดูแลสุขภาพที่มีสัตว์เลี้ยงเสมือนเปลี่ยนอารมณ์ตามพฤติกรรมผู้ใช้)")

    # 2) ไฟล์ output — กันเขียนทับงานที่แก้มือแล้ว
    targets = [feature_dir / o.filename for o in role.outputs]
    existing = [p for p in targets if p.exists()]
    if existing and not args.overwrite:
        names = ", ".join(str(p.relative_to(ROOT)).replace("\\", "/") for p in existing)
        return fail(f"มีไฟล์ {names} อยู่แล้ว — ถ้าต้องการให้ agent เขียนใหม่ทับ ให้เพิ่ม --overwrite "
                    "(แนะนำให้ commit ของเดิมก่อน จะได้ย้อนกลับได้)")

    # 3) รัน: Gemini ก่อน ถ้าโควตาหมดสลับไป Groq
    try:
        llm_mod.gemini_llm()  # ตรวจ key/รุ่นก่อน (ยังไม่เรียก API) จะได้ไม่สร้าง log เปล่า
        order = llm_mod.providers()
    except llm_mod.SetupError as exc:
        return fail(str(exc))
    context_text = "\n\n".join(context_parts)
    log_file = log_path(args.role, args.feature)
    attempts: list[Attempt] = []
    for i, (name, factory) in enumerate(order):
        print(f"\n>>> รัน {args.role} ด้วย {name} ...")
        attempt = run_attempt(name, factory, args, role, context_text)
        attempts.append(attempt)
        if attempt.status == "สำเร็จ":
            break
        exc = attempt.exc
        has_next = i + 1 < len(order)
        if isinstance(exc, llm_mod.SetupError):
            break
        if exc is not None and llm_mod.is_quota_error(exc) and has_next:
            print(f"\n[สลับ] {name} ตอบ 429 (โควตาหมด/เรียกถี่เกิน) → ลองใหม่ด้วย {order[i + 1][0]}")
            continue
        break

    final = attempts[-1]
    written = []
    if final.status == "สำเร็จ":
        for out in role.outputs:
            path = feature_dir / out.filename
            path.write_text(final.results[out.filename], encoding="utf-8")
            written.append(f"docs/{args.feature}/{out.filename}")
    write_log(log_file, args, inputs_used, attempts, written, agent_file, agent_ver)
    rel_log = str(log_file.relative_to(ROOT)).replace("\\", "/")

    if final.status == "สำเร็จ":
        print("\n[OK] เสร็จแล้ว")
        for w in written:
            print(f"     ไฟล์ผลลัพธ์: {w}")
        print(f"     log: {rel_log}")
        print("     ขั้นต่อไป: เปิดไฟล์ผลลัพธ์ ตรวจ/แก้เองตาม checklist (SETUP_CREWAI.md ข้อ 11) แล้วค่อย commit")
        return 0

    exc = final.exc
    if isinstance(exc, llm_mod.SetupError):
        return fail(str(exc))
    print(f"\n[แก้] รันไม่สำเร็จ ({final.provider}): {final.error[:300]}")
    if exc is not None:
        print("  " + llm_mod.explain(exc))
    if exc is not None and llm_mod.is_quota_error(exc) and not llm_mod.groq_configured():
        print("  (ยังไม่ได้ตั้ง Groq สำรอง: ใส่ GROQ_API_KEY และ GROQ_MODEL ใน .env)")
    print(f"  รายละเอียดเต็ม (รวม traceback) อยู่ใน {rel_log}")
    return 1


if __name__ == "__main__":
    sys.exit(main())
