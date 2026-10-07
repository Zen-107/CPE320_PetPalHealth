"""อ่านไฟล์บทบาทใน agents/*.md แล้วแปลงเป็น crewai.Agent

รูปแบบไฟล์ (ใช้ร่วมกับ Claude Code sub-agent ได้):

    ---
    name: product                 # ชื่อไฟล์/ชื่อ agent (Claude Code ใช้ด้วย)
    owner: A                      # เพื่อนที่เป็นเจ้าของ/ผู้ออกแบบ agent นี้
    description: ...              # Claude Code ใช้ตัดสินใจว่าจะเรียก agent นี้เมื่อไร
    role: ...                     # CrewAI: role
    goal: ...                     # CrewAI: goal (ใส่ {feature} ได้)
    input_files: [...]            # ข้อตกลงทีม: ไฟล์ที่ agent อ่าน
    output_file: ...              # ข้อตกลงทีม: ไฟล์ที่ agent เขียน (1 ไฟล์ หรือ list)
    ---
    เนื้อหาด้านล่าง = backstory ของ CrewAI = system prompt ของ Claude Code
    (คอมเมนต์ <!-- ... --> จะถูกตัดทิ้ง ไม่ส่งให้ LLM)

ถ้าช่อง description/role/goal หรือ backstory ยังเป็น TODO (หรือว่าง) ถือว่า "ยังไม่ได้ออกแบบ"
และจะไม่ยอมรันด้วยค่าว่าง

ทดสอบ: python crew/load_agents.py   (บอกสถานะ agent ทุกตัว ไม่เรียก API)
"""

from __future__ import annotations

import re
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
AGENTS_DIR = ROOT / "agents"
DESIGNED_FIELDS = ("description", "role", "goal")


class AgentNotDesigned(RuntimeError):
    """ไฟล์ agent ยังเป็นแม่แบบ — ข้อความเป็นภาษาไทยพร้อมบอกเจ้าของ"""


@dataclass
class AgentSpec:
    name: str
    role: str
    goal: str
    backstory: str
    description: str
    path: Path
    owner: str = ""
    input_files: list[str] = field(default_factory=list)
    output_files: list[str] = field(default_factory=list)
    todo: list[str] = field(default_factory=list)

    def render(self, feature: str) -> "AgentSpec":
        sub = lambda s: s.replace("{feature}", feature).replace("<feature>", feature)  # noqa: E731
        return AgentSpec(self.name, sub(self.role), sub(self.goal), sub(self.backstory),
                         self.description, self.path, self.owner,
                         [sub(p) for p in self.input_files], [sub(p) for p in self.output_files],
                         list(self.todo))

    def not_designed_message(self) -> str:
        owner = f"เพื่อน {self.owner}" if self.owner else "เจ้าของไฟล์"
        return (f"agents/{self.path.name} ยังไม่ได้ออกแบบ — เจ้าของคือ{owner}\n"
                f"  ช่องที่ยังเป็น TODO/ว่าง: {', '.join(self.todo)}\n"
                "  วิธีออกแบบ: docs/SETUP_CREWAI.md ข้อ 8")


def _as_list(value) -> list[str]:
    if value is None:
        return []
    if isinstance(value, (list, tuple)):
        return [str(v).strip() for v in value if str(v).strip()]
    return [str(value).strip()] if str(value).strip() else []


def _is_todo(value: str) -> bool:
    return not value.strip() or "TODO" in value


def parse_file(path: Path) -> AgentSpec:
    import yaml  # pyyaml ติดมากับ crewai

    text = path.read_text(encoding="utf-8-sig")
    if not text.startswith("---"):
        raise ValueError(f"{path.name}: ต้องขึ้นต้นด้วยบรรทัด --- (frontmatter)")
    try:
        _, front, body = text.split("---", 2)
    except ValueError:
        raise ValueError(f"{path.name}: frontmatter ต้องปิดด้วยบรรทัด --- อีกครั้ง") from None
    try:
        meta = yaml.safe_load(front) or {}
    except yaml.YAMLError as exc:
        mark = getattr(exc, "problem_mark", None)
        where = f" บรรทัด {mark.line + 1}" if mark else ""
        raise ValueError(f"agents/{path.name}{where}: frontmatter อ่านไม่ได้ — ถ้าข้อความมีเครื่องหมาย : "
                         "ให้ครอบทั้งข้อความด้วย \"...\" เช่น role: \"PO: ผู้วางแผน\"") from None
    name = str(meta.get("name") or "").strip()
    if not name:
        raise ValueError(f"{path.name}: frontmatter ขาด name")
    backstory = re.sub(r"<!--.*?-->", "", body, flags=re.S).strip()
    values = {k: str(meta.get(k) or "").strip() for k in DESIGNED_FIELDS}
    todo = [k for k, v in values.items() if _is_todo(v)]
    if _is_todo(backstory):
        todo.append("backstory (เนื้อหาใต้เส้น ---)")
    return AgentSpec(
        name=name,
        role=values["role"],
        goal=values["goal"],
        backstory=backstory,
        description=values["description"],
        path=path,
        owner=str(meta.get("owner") or "").strip(),
        input_files=_as_list(meta.get("input_files")),
        output_files=_as_list(meta.get("output_file")),
        todo=todo,
    )


def load_specs() -> dict[str, AgentSpec]:
    specs = {}
    for path in sorted(AGENTS_DIR.glob("*.md")):
        spec = parse_file(path)
        specs[spec.name] = spec
    return specs


def require_designed(name: str) -> AgentSpec:
    """คืน spec ของ agent — ถ้ายังเป็นแม่แบบ (มี TODO) ให้หยุดด้วย AgentNotDesigned"""
    # อ่านเฉพาะไฟล์ของบทบาทนี้ — ไฟล์ของเพื่อนคนอื่นพังไม่ควรทำให้เรารันไม่ได้
    path = AGENTS_DIR / f"{name}.md"
    if not path.is_file():
        raise KeyError(f"ไม่พบ agents/{name}.md — git pull หรือกู้คืนด้วย git checkout -- agents/{name}.md")
    spec = parse_file(path)
    if spec.name != name:
        raise ValueError(f"agents/{name}.md: ช่อง name ต้องเป็น {name} (ตอนนี้เป็น {spec.name})")
    if spec.todo:
        raise AgentNotDesigned(spec.not_designed_message())
    return spec


def build_agent(name: str, feature: str, llm, max_rpm: int):
    from crewai import Agent

    spec = require_designed(name).render(feature)
    agent = Agent(
        role=spec.role,
        goal=spec.goal,
        backstory=spec.backstory,
        llm=llm,
        allow_delegation=False,
        max_rpm=max_rpm,
        max_iter=3,
        max_retry_limit=1,  # 429 แล้วอย่าวนซ้ำนาน ให้ main.py สลับไป Groq เร็ว ๆ
        verbose=True,
    )
    return agent, spec


if __name__ == "__main__":
    import sys

    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    for path in sorted(AGENTS_DIR.glob("*.md")):
        try:
            spec = parse_file(path)
        except ValueError as exc:
            print(f"[แก้] {exc}")
            continue
        if spec.todo:
            print(f"[ยังไม่ออกแบบ] {spec.not_designed_message()}")
        else:
            print(f"[OK] {spec.path.name}: name={spec.name} | role={spec.role} | "
                  f"backstory {len(spec.backstory)} ตัวอักษร")
