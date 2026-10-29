"""สร้างภาพสัตว์เลี้ยง 3 อารมณ์ของฟีเจอร์ water (game-rules.md §2)

    python tools/gen_pet_images.py        (ต้องมี Pillow: pip install pillow)

ได้ไฟล์ใน app/assets/images/:
    pet_critical.png  0–3 แก้ว   อ่อนแรง เหงื่อออก ตาปรือ ต้นอ่อนบนหัวเหี่ยว
    pet_tired.png     4–6 แก้ว   เฉย ๆ ง่วงนิด ๆ แลบลิ้นนิดหน่อย ต้นอ่อนเอียง
    pet_happy.png     7+ แก้ว    ยิ้ม แก้มแดง มีหยดน้ำเล็ก ๆ ต้นอ่อนตั้งตรง

ตัวละคร "ปุ๋ยน้ำ" ออกแบบใหม่สำหรับ PetPal Health: ตัวกลมสีฟ้าพาสเทล มีต้นอ่อนบนหัว
ทุกภาพเป็น PNG พื้นโปร่งใส 512×512 ตัวอยู่ตำแหน่งและขนาดเดียวกัน เปลี่ยนแค่สีหน้าและท่าทาง
วาดใหญ่ 4 เท่า (supersample) แล้วย่อด้วย LANCZOS ให้ขอบเนียน
"""

from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw

OUT_DIR = Path(__file__).resolve().parent.parent / "app" / "assets" / "images"
SIZE = 512
SCALE = 4
S = SIZE * SCALE  # ขนาดผืนที่วาดจริง

# โทนสีเดียวกับแอป (seed lightBlue + สีพาสเทลใน pet_painter.dart)
BODY = (205, 236, 255, 255)
BELLY = (236, 248, 255, 255)
OUTLINE = (91, 104, 122, 255)
EYE = (60, 66, 82, 255)
WHITE = (255, 255, 255, 255)
CHEEK = (255, 181, 194, 200)
TONGUE = (255, 143, 163, 255)
MOUTH = (110, 72, 88, 255)
SWEAT = (168, 216, 255, 255)
WATER = (127, 200, 248, 255)
LEAF = (150, 214, 160, 255)
LEAF_WILT = (196, 200, 150, 255)
SHADOW = (91, 104, 122, 40)
GLOOM = (150, 160, 200, 150)

LW = 0.022  # ความหนาเส้นขอบ (สัดส่วนของภาพ)


def p(x: float, y: float) -> tuple[float, float]:
    return (x * S, y * S)


def box(cx: float, cy: float, w: float, h: float) -> list[float]:
    return [(cx - w / 2) * S, (cy - h / 2) * S, (cx + w / 2) * S, (cy + h / 2) * S]


def line(d: ImageDraw.ImageDraw, pts, color=OUTLINE, w: float = LW) -> None:
    """เส้นหนาปลายมน"""
    px = [p(*q) for q in pts]
    d.line(px, fill=color, width=round(w * S), joint="curve")
    r = w * S / 2
    for x, y in (px[0], px[-1]):
        d.ellipse([x - r, y - r, x + r, y + r], fill=color)


def curve(pts, n: int = 40):
    """Bezier กำลังสอง/สาม → จุดสำหรับวาดเส้น"""
    out = []
    for i in range(n + 1):
        t = i / n
        if len(pts) == 3:
            (x0, y0), (x1, y1), (x2, y2) = pts
            x = (1 - t) ** 2 * x0 + 2 * (1 - t) * t * x1 + t ** 2 * x2
            y = (1 - t) ** 2 * y0 + 2 * (1 - t) * t * y1 + t ** 2 * y2
        else:
            (x0, y0), (x1, y1), (x2, y2), (x3, y3) = pts
            x = (1 - t) ** 3 * x0 + 3 * (1 - t) ** 2 * t * x1 + 3 * (1 - t) * t ** 2 * x2 + t ** 3 * x3
            y = (1 - t) ** 3 * y0 + 3 * (1 - t) ** 2 * t * y1 + 3 * (1 - t) * t ** 2 * y2 + t ** 3 * y3
        out.append((x, y))
    return out


def drop(d: ImageDraw.ImageDraw, cx: float, cy: float, r: float, color, outline=True) -> None:
    """หยดน้ำ (ปลายแหลมด้านบน) จุดศูนย์กลางของส่วนกลม = (cx, cy)"""
    pts = []
    for i in range(80):
        a = 2 * math.pi * i / 80
        x = math.sin(a) * math.sin(a / 2) * 1.15
        y = -math.cos(a) * 1.25
        pts.append(p(cx + x * r, cy + 0.35 * r + y * r))
    d.polygon(pts, fill=color)
    if outline:
        d.line(pts + [pts[0]], fill=OUTLINE, width=round(LW * 0.55 * S), joint="curve")
    d.ellipse(box(cx - r * 0.35, cy + r * 0.55, r * 0.42, r * 0.6), fill=(255, 255, 255, 210))


def leaf(d: ImageDraw.ImageDraw, base, tip, width: float, color) -> None:
    (bx, by), (tx, ty) = base, tip
    nx, ny = -(ty - by), (tx - bx)
    ln = math.hypot(nx, ny) or 1
    nx, ny = nx / ln * width, ny / ln * width
    mx, my = (bx + tx) / 2, (by + ty) / 2
    side1 = curve([(bx, by), (mx + nx, my + ny), (tx, ty)])
    side2 = curve([(tx, ty), (mx - nx, my - ny), (bx, by)])
    pts = [p(*q) for q in side1 + side2]
    d.polygon(pts, fill=color)
    d.line(pts + [pts[0]], fill=OUTLINE, width=round(LW * 0.55 * S), joint="curve")
    vein = tuple(max(c - 40, 0) for c in color[:3]) + (255,)
    line(d, curve([(bx, by), (mx + nx * 0.1, my + ny * 0.1), (tx, ty)], 20), vein, LW * 0.3)


def sprout(d: ImageDraw.ImageDraw, mood: str) -> None:
    """ต้นอ่อนบนหัว = ท่าทางหลักที่บอกว่าดื่มน้ำพอไหม"""
    base = (0.5, 0.30)
    if mood == "happy":
        stem = [base, (0.5, 0.22), (0.5, 0.15)]
        top = stem[-1]
        line(d, curve(stem, 20), OUTLINE, LW * 0.9)
        leaf(d, top, (0.37, 0.07), 0.05, LEAF)
        leaf(d, top, (0.63, 0.08), 0.05, LEAF)
    elif mood == "tired":
        stem = [base, (0.51, 0.22), (0.56, 0.17)]
        top = stem[-1]
        line(d, curve(stem, 20), OUTLINE, LW * 0.9)
        leaf(d, top, (0.45, 0.11), 0.047, LEAF)
        leaf(d, top, (0.69, 0.16), 0.047, LEAF)
    else:  # critical: เหี่ยวตกลงด้านข้าง
        stem = [base, (0.52, 0.20), (0.62, 0.21)]
        top = stem[-1]
        line(d, curve(stem, 20), OUTLINE, LW * 0.9)
        leaf(d, top, (0.71, 0.32), 0.042, LEAF_WILT)
        leaf(d, top, (0.57, 0.31), 0.04, LEAF_WILT)


def arms(img: Image.Image, mood: str) -> None:
    """แขนสั้น ๆ: ตก (critical) / ข้างตัว (tired) / ชูขึ้น (happy) — วาดก่อนตัวให้ตัวทับโคนแขน"""
    for side in (-1, 1):
        if mood == "happy":
            cx, cy, ang = 0.5 + side * 0.34, 0.50, 35 * side
        elif mood == "tired":
            cx, cy, ang = 0.5 + side * 0.335, 0.66, -15 * side
        else:
            cx, cy, ang = 0.5 + side * 0.305, 0.73, -5 * side
        arm = Image.new("RGBA", (S, S), (0, 0, 0, 0))
        ImageDraw.Draw(arm).ellipse(box(0.5, 0.5, 0.10, 0.16), fill=BODY, outline=OUTLINE,
                                    width=round(LW * S))
        arm = arm.rotate(ang, resample=Image.BICUBIC, center=p(0.5, 0.5))
        layer = Image.new("RGBA", (S, S), (0, 0, 0, 0))
        layer.paste(arm, (round((cx - 0.5) * S), round((cy - 0.5) * S)), arm)
        img.alpha_composite(layer)


def body(img: Image.Image) -> None:
    d = ImageDraw.Draw(img)
    # เงาบนพื้น (เหมือนกันทุกภาพ)
    shadow = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).ellipse(box(0.5, 0.905, 0.56, 0.06), fill=SHADOW)
    img.alpha_composite(shadow)
    # เท้า
    for fx in (0.38, 0.62):
        d.ellipse(box(fx, 0.865, 0.15, 0.08), fill=BODY, outline=OUTLINE, width=round(LW * S))
    # ตัว
    d.ellipse(box(0.5, 0.58, 0.70, 0.60), fill=BODY, outline=OUTLINE, width=round(LW * S))
    # ท้องสีอ่อน
    d.ellipse(box(0.5, 0.71, 0.36, 0.26), fill=BELLY)
    # เงาสะท้อนบนหัว
    d.ellipse(box(0.35, 0.40, 0.10, 0.06), fill=(255, 255, 255, 170))


LEFT_EYE, RIGHT_EYE, MOUTH_Y = (0.39, 0.555), (0.61, 0.555), 0.645


def face_happy(d: ImageDraw.ImageDraw) -> None:
    for ex, ey in (LEFT_EYE, RIGHT_EYE):
        d.ellipse(box(ex, ey, 0.072, 0.088), fill=EYE)
        d.ellipse(box(ex + 0.014, ey - 0.018, 0.026, 0.028), fill=WHITE)
        d.ellipse(box(ex - 0.014, ey + 0.02, 0.012, 0.012), fill=WHITE)
    # แก้มแดง
    for cx in (0.29, 0.71):
        d.ellipse(box(cx, 0.64, 0.085, 0.05), fill=CHEEK)
    # ปากยิ้มเปิด (ครึ่งวงล่าง) + ลิ้น
    mouth_box = box(0.5, MOUTH_Y - 0.005, 0.12, 0.10)
    d.pieslice(mouth_box, 0, 180, fill=MOUTH)
    d.chord(box(0.5, MOUTH_Y + 0.035, 0.07, 0.04), 180, 360, fill=TONGUE)
    d.arc(mouth_box, 0, 180, fill=OUTLINE, width=round(LW * 0.8 * S))
    line(d, [(0.44, MOUTH_Y - 0.005), (0.56, MOUTH_Y - 0.005)], OUTLINE, LW * 0.8)
    # หยดน้ำเล็ก ๆ รอบตัว
    drop(d, 0.13, 0.36, 0.032, WATER)
    drop(d, 0.88, 0.42, 0.026, WATER)
    drop(d, 0.84, 0.20, 0.020, WATER)


def face_tired(d: ImageDraw.ImageDraw) -> None:
    # ตาง่วง: เห็นครึ่งล่างของตา มีเปลือกตาเป็นเส้นตรง
    for ex, ey in (LEFT_EYE, RIGHT_EYE):
        d.chord(box(ex, ey, 0.066, 0.07), 0, 180, fill=EYE)
        d.ellipse(box(ex + 0.012, ey + 0.012, 0.014, 0.012), fill=WHITE)
        line(d, [(ex - 0.042, ey), (ex + 0.042, ey)], OUTLINE, LW * 0.85)
    for cx in (0.29, 0.71):
        d.ellipse(box(cx, 0.645, 0.07, 0.04), fill=(255, 181, 194, 110))
    # ปากเฉย ๆ + แลบลิ้นนิดหน่อย (game-rules: แลบลิ้น)
    d.chord(box(0.515, MOUTH_Y + 0.005, 0.04, 0.05), 0, 180, fill=TONGUE, outline=OUTLINE,
            width=round(LW * 0.5 * S))
    line(d, [(0.465, MOUTH_Y + 0.005), (0.545, MOUTH_Y + 0.005)], OUTLINE, LW * 0.8)
    # z เล็ก ๆ
    for zx, zy, zs in ((0.80, 0.30, 0.045), (0.87, 0.22, 0.032)):
        line(d, [(zx, zy), (zx + zs, zy), (zx, zy + zs), (zx + zs, zy + zs)], OUTLINE, LW * 0.6)


def face_critical(d: ImageDraw.ImageDraw, img: Image.Image) -> None:
    # เส้นหม่นบนหน้าผาก (อ่อนแรง)
    gloom = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    gd = ImageDraw.Draw(gloom)
    for gx in (0.42, 0.47, 0.52, 0.57):
        line(gd, [(gx, 0.36), (gx, 0.45)], GLOOM, LW * 0.5)
    img.alpha_composite(gloom)
    # ตาปรือหนัก เปลือกตาเอียงตกด้านนอก
    for (ex, ey), side in ((LEFT_EYE, -1), (RIGHT_EYE, 1)):
        d.chord(box(ex, ey + 0.012, 0.056, 0.05), 0, 180, fill=EYE)
        line(d, [(ex + 0.04 * side, ey + 0.014), (ex - 0.04 * side, ey - 0.008)], OUTLINE, LW * 0.85)
        line(d, [(ex - 0.03, ey + 0.058), (ex + 0.03, ey + 0.058)], (150, 160, 200, 180), LW * 0.5)
    # ปากหยัก ๆ
    wave = [(0.45 + i * 0.02, MOUTH_Y + 0.012 + (0.01 if i % 2 else -0.004)) for i in range(6)]
    line(d, wave, OUTLINE, LW * 0.75)
    # เหงื่อ
    drop(d, 0.77, 0.40, 0.034, SWEAT)
    drop(d, 0.23, 0.47, 0.026, SWEAT)


def render(mood: str) -> Image.Image:
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    sprout(d, mood)
    arms(img, mood)
    body(img)
    d = ImageDraw.Draw(img)
    if mood == "happy":
        face_happy(d)
    elif mood == "tired":
        face_tired(d)
    else:
        face_critical(d, img)
    return img.resize((SIZE, SIZE), Image.LANCZOS)


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    for mood in ("critical", "tired", "happy"):
        path = OUT_DIR / f"pet_{mood}.png"
        render(mood).save(path, optimize=True)
        print(f"wrote {path.relative_to(OUT_DIR.parent.parent.parent)} ({SIZE}x{SIZE})")


if __name__ == "__main__":
    main()
