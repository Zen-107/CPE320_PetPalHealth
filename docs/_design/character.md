# คัมภีร์ตัวละคร (Character Bible) — กบน้อย PetPal

> แหล่งความจริงเรื่องหน้าตา/ท่าทางของสัตว์เลี้ยงทั้งแอป โค้ดอยู่ที่ `app/lib/shared/pet/` ค่าทุกตัวในเอกสารนี้ตรงกับ `pet_constants.dart`
> ผู้ดูแล: Art agent (`.claude/agents/art.md`) · อัปเดตล่าสุด 2026-10-14 (รอบ 1 — สร้างตัวละคร)

## 1. ตัวละคร

- กบตัวกลมอ้วนนุ่ม (ทรงโมจิ: หัวกับตัวเป็นก้อนเดียว ก้นแบน) ตาโตอยู่บนปุ่มนูนสองข้างของหัว มีใบไม้ปักบนหัว แก้มชมพู แลบลิ้นเป็นเอกลักษณ์
- นิสัย: เอ๋อ ๆ แต่ใจดี (dopey-but-kind) — แม้ตอนปกติก็มักแลบลิ้นนิด ๆ ("blep") ไม่ดุ ไม่น่ากลัวแม้ในสถานะแย่ (ป่วยแบบน่าสงสาร ไม่ใช่น่ากลัว)
- สไตล์: เวกเตอร์เรียบ สีพาสเทล เส้นขอบเขียวเข้มหนา มุมมน ไม่มีเงาไล่สี (ยกเว้นเงาพื้นและเงาเสี้ยวที่ต้นขา MUSCLE)
- มีตัวเดียวทั้งแอป — ทุกฟีเจอร์ใช้ widget `PetCharacter` เท่านั้น ห้ามวาดสัตว์เลี้ยงตัวอื่น
- ภาพแรงบันดาลใจ `docs/_design/character-frog.png` **ยังไม่มีใน repo** — รอบนี้ออกแบบจากคำบรรยายของเจ้าของโปรเจกต์ (ดู §9 คำถามค้าง) และห้ามนำภาพนั้นไปใช้ในแอป

## 2. ชุดสี (`PetColors`)

| ชื่อ | Hex | ใช้ที่ |
|---|---|---|
| `body` | `#9ED98C` | ตัว (ปกติ) |
| `bodyCritical` | `#BCCDAA` | ตัวตอน critical (ซีด เขียวอมเทา) |
| `feet` | `#6FB86A` | เท้า มือ |
| `leaf` | `#6FB86A` | ใบไม้บนหัว |
| `leafWilted` | `#B3B26A` | ใบไม้เหี่ยว (critical) |
| `leafVein` | `#4E8F4B` | ก้านและเส้นใบ |
| `belly` | `#F4F1D8` | พุง |
| `cheek` | `#F7A8B0` | แก้ม (alpha 0.9 ปกติ / 0.55 tired / 0.30 critical / 0.95 ตอน cheer, funny) |
| `tongue` | `#F27E8D` | ลิ้น |
| `mouth` | `#7A3341` | ในปากที่อ้า |
| `outline` | `#3F5E3A` | เส้นขอบ ตาปิด คิ้ว ปาก |
| `pupil` | `#26331F` | ตาดำ |
| `eyeWhite` | `#FFFFFF` | ตาขาว + ประกายในตา |
| `muscleShade` | `#7CC46B` | เงาเสี้ยวที่ต้นขา MUSCLE |
| `sweat` | `#8FD3FF` | หยดเหงื่อ (ขอบ `#4A90C2`) |
| `sparkle` | `#FFD95A` | ประกายดาว |
| `shadow` | `#22000000` | เงาบนพื้น |

สีตามคำบรรยายเจ้าของใช้ตรงตามนั้น (body/feet/leaf/belly/cheek/tongue) สีอื่นเพิ่มเพื่อให้อ่านง่ายบนจอเล็ก

## 3. สัดส่วน (`PetProportions`)

วาดในกรอบจัตุรัสด้าน `s` (บนหน้าจอ `s = 160` logical px) ค่าทั้งหมดเป็นสัดส่วนของ `s`

ค่าร่วม: เส้นพื้น (ใต้เท้า) y = 0.88 · ปุ่มตารัศมี 0.12 · ตาขาว = 0.80 × ปุ่มตา · ระยะตาจากแกนกลาง = clamp(กว้างตัว × 0.30, 0.17, 0.22) · ตาอยู่ที่ขอบบนตัว + 0.045 · ปากอยู่ใต้ตา 0.165 · เส้นขอบหนา 0.022 · ใบไม้ยาว 0.17

| รูปร่าง (`PetBodyShape`) | กว้าง × สูงตัว | พุง | ต้นขาหลัง | ระยะเท้า / ขนาดนิ้ว | จุดเด่น |
|---|---|---|---|---|---|
| `normal` (water) | 0.74 × 0.58 | 0.42 × 0.30 | 0.17 × 0.15 (อยู่หลังตัว) | 0.15 / 0.030 | ทรงมาตรฐาน |
| `fat` | **0.94** × 0.52 | 0.68 × 0.36 + เส้นพุงพับ + สะดือ | ซ่อน | 0.24 / 0.024 | กว้างเต็มกรอบ เตี้ยแบน เท้าเล็กจิ๋ว |
| `chubby` | 0.78 × **0.64** | 0.50 × 0.36 | 0.16 × 0.14 | 0.16 / 0.028 | กลมเกือบเป็นวงกลม |
| `lean` | **0.56** × 0.62 | 0.26 × 0.30 | 0.12 × 0.22 (เรียวยาว) | 0.12 / 0.030 | ผอมสูง พุงเล็ก |
| `muscle` | 0.60 × 0.60 | 0.30 × 0.28 | **0.25 × 0.27 อยู่หน้าตัว** มีเงาเสี้ยว + เส้นกล้าม + ไฮไลต์ | 0.20 / 0.036 | ต้นขาใหญ่เป็นกล้าม แขนเบ่งกล้าม (ท่า proud) |

ลำดับการวาด: เงาพื้น → ต้นขาหลัง → ตัว+ปุ่มตา → พุง → แขน → ต้นขา MUSCLE → เท้า → แก้ม → ตา/คิ้ว → ปาก/ลิ้น → ใบไม้ → เหงื่อ → ประกาย

## 4. สีหน้า (`PetExpression` = สีหน้าหลัก, `PetFace` = หน้าที่วาดจริงในเฟรมนั้น)

| หน้า (`PetFace`) | ตา | ปาก/ลิ้น | อื่น ๆ |
|---|---|---|---|
| `happy` | เปิดโต ตาดำใหญ่ 0.64 มีประกาย 2 จุด | ยิ้มอ้ารูป D เห็นลิ้นข้างใน | แก้มชมพูเข้ม ประกาย 2 ดวง ใบไม้ตั้ง |
| `content` | เปิด หนังตาลงนิด (0.15) | ยิ้มปิด + แลบลิ้น "blep" ตรงกลาง | ใจดี สบาย ๆ |
| `proud` | เปิดโต + **คิ้วเฉียงมุ่งมั่น** | ยิ้มกว้างปิด มุมปากยก + แลบลิ้นด้านข้าง | ประกาย 2 ดวง |
| `tired` | **หนังตาตกครึ่ง (0.45)** มองต่ำ | อ้าปากเล็กหอบ ลิ้นห้อยยาว (แกว่งตามการหายใจ) | หยดเหงื่อ 1 หยด แก้มซีด ใบไม้เอียง แขนห้อย |
| `critical` | **หนังตาตก 0.62** ตาดำเล็กมองลงล่าง + ถุงใต้ตา | ปากหยักเบี้ยว ลิ้นห้อยเอียงข้าง | ตัวซีด `bodyCritical` ตัวยุบลง (สูง ×0.96 กว้าง ×1.03) ใบไม้เหี่ยวพับข้าง สีเหลืองหม่น หยดเหงื่อ 2 หยด แก้มจางมาก แขนห้อย หายใจช้าและเบา |
| `blink` | ปิด (เส้นโค้ง ‿) | คงปาก ใบไม้ แก้ม ตามสีหน้าเดิม (เปลี่ยนแค่ตา) | เกิดสุ่มทุก 1.8–5.0 วินาที นาน 180 ms |
| `funny` (แตะตัว) | `>` `<` หยีตา | อ้าปากกลม ลิ้นยื่นยาวเฉียง | แขนกางออก ตัวกระโดด |
| `cheer` (เพิ่มน้ำ/ก้าว) | `^ ^` | ยิ้มอ้ากว้าง เห็นลิ้น | ชูแขนสองข้าง กระโดด 2 ครั้ง ประกาย 5 ดวง ใบไม้โบก |

## 5. ตารางสถานะ → ท่าทาง/สีหน้า (`PetPose` presets)

ช่วงค่าเป็นของ game-rules.md (Art ไม่ได้กำหนด) — ที่นี่แค่จับคู่ภาพ

| ฟีเจอร์ | สถานะ (game-rules §2) | Preset | สีหน้า | รูปร่าง | ไฟล์ preview |
|---|---|---|---|---|---|
| water | happy (7+ แก้ว) | `PetPose.waterHappy` | `happy` | `normal` | `preview/water_happy.png` |
| water | tired (4–6 แก้ว) | `PetPose.waterTired` | `tired` | `normal` | `preview/water_tired.png` |
| water | critical (0–3 แก้ว) | `PetPose.waterCritical` | `critical` | `normal` | `preview/water_critical.png` |
| steps | FAT `[0, 35)` % | `PetPose.stepsFat` | `tired` (อืด เหนื่อย มีเหงื่อ) | `fat` | `preview/steps_fat.png` |
| steps | CHUBBY `[35, 70)` % | `PetPose.stepsChubby` | `content` | `chubby` | `preview/steps_chubby.png` |
| steps | LEAN `[70, 100)` % | `PetPose.stepsLean` | `happy` | `lean` | `preview/steps_lean.png` |
| steps | MUSCLE `[100, ∞)` % | `PetPose.stepsMuscle` | `proud` + แขนเบ่งกล้าม | `muscle` | `preview/steps_muscle.png` |

ภาพรวมทุกสถานะที่ขนาดจริง 160 px: `preview/all_states_160.png` · เฟรมพิเศษ: `fx_blink.png`, `fx_jump_funny.png`, `fx_cheer.png`, `fx_breath_in.png`, `fx_critical_sweat.png`

ความต่างที่ต้องรักษา: water 3 สถานะต่างกันที่ตา (เปิด / ตกครึ่ง / ตกมาก+มองล่าง) ปาก ใบไม้ (ตั้ง / เอียง / เหี่ยว) แขน (วางพุง / ห้อย) และเหงื่อ — ไม่ใช่แค่สี; steps 4 สถานะต่างกันที่ **รูปร่าง** ก่อน (กว้างแบน / กลม / ผอมสูง / ต้นขากล้าม+เบ่งแขน) แล้วจึงสีหน้า

## 6. อนิเมชัน (Flutter ล้วน: `CustomPainter` + `AnimationController`)

| อนิเมชัน | ทำงานเมื่อ | รายละเอียด | ค่าใน `PetTiming` |
|---|---|---|---|
| หายใจ (idle) | ตลอดเวลาเมื่อ `animate: true` | ยืด-หดตัวรอบเส้นพื้น สูง +3% กว้าง −1.5% (critical ×0.6) ประกาย/ใบไม้ขยับตาม | `breath` 2400 ms (ไป-กลับ), สถานะต่ำ `breathLow` 3400 ms |
| กะพริบตา | สุ่ม | หนังตาปิด 0→1→0 | `blink` 180 ms ห่างกัน 1800 + random(0..3200) ms |
| แตะตัว → กระโดด + หน้าตลก | แตะที่กล่องของสัตว์เลี้ยง (`reactToTap`) | ย่อตัว → ลอย 0.10·s (ยืด) → ลงพื้นแล้วยุบ หน้า `funny` | `jump` 650 ms |
| ดีใจ (cheer) | `cheerTrigger` เปลี่ยนค่า | กระโดดสั้น 2 ครั้ง 0.06·s ชูแขน หน้า `cheer` ประกาย | `cheer` 900 ms |
| สถานะต่ำ | `tired` / `critical` | ตาปรือ (ค่าคงที่ของท่า) + หยดเหงื่อไหลลงตามจังหวะหายใจ + หายใจช้า | — |

ระหว่าง cheer แตะตัวจะไม่ขัดจังหวะ · เงาพื้นหดเมื่อลอย · `animate: false` = เฟรมนิ่ง (breath 0, ไม่มี blink/action) ไม่สร้าง controller หรือ Timer

## 7. วิธีใช้ widget

```dart
import 'package:petpal_health/shared/pet/pet.dart';

PetCharacter(
  key: ValueKey('water_pet_image_${mood.name}'), // key ของฟีเจอร์เอง (ไม่บังคับ)
  pose: PetPose.waterHappy,     // หรือ PetPose(expression: ..., body: ...)
  size: 160,                    // default 160
  animate: true,                // false = ภาพนิ่ง ไม่มี ticker (ใช้ในเทสต์)
  random: Random(42),           // ไม่บังคับ — กำหนด seed ให้การกะพริบตาซ้ำได้
  cheerTrigger: addCount,       // เพิ่มค่าทุกครั้งที่บันทึกน้ำ/ก้าวสำเร็จ → เล่น cheer
  reactToTap: true,             // แตะ → กระโดด + หน้าตลก
  onTap: () {},                 // ไม่บังคับ (เรียกเสมอ แม้ animate: false)
  semanticLabel: 'สดชื่น',       // ไม่บังคับ
)
```

API สาธารณะ (`app/lib/shared/pet/`):

- `PetCharacter` (StatefulWidget) — พารามิเตอร์ตามด้านบน; `pose` จำเป็น
- `PetPose(expression, body = normal)` — immutable มี `==`, `id` (เช่น `fat_tired`), `isLowState`, `copyWith`; presets `waterHappy/waterTired/waterCritical/stepsFat/stepsChubby/stepsLean/stepsMuscle`
- `enum PetExpression { happy, content, proud, tired, critical }` (ตั้งชื่อเลี่ยง `PetMood` ของ water)
- `enum PetBodyShape { normal, fat, chubby, lean, muscle }`
- `enum PetAction { none, jump, cheer }`
- `enum PetFace { happy, content, proud, tired, critical, blink, funny, cheer }`
- `PetCharacterPainter` (CustomPainter) — ฟิลด์ `pose, breath, blink, action, actionProgress, animated`; getter `expression, bodyShape, bodySpec, face, isBlinking, isJumping, isCheering, showsSweat, hasDroopyEyes, showsSparkles`
- `PetColors`, `PetProportions`, `PetBodySpec`, `PetTiming`, `PetKeys`

`cheerTrigger`: เล่น cheer ทุกครั้งที่ค่า **เปลี่ยน** (ไม่ใช่แค่เพิ่ม) — ฟีเจอร์ควรเก็บตัวนับใน state/controller ให้คงที่ข้าม rebuild

### Key และการตรวจในเทสต์

| Key | widget |
|---|---|
| `PetKeys.character` = `ValueKey('pet_character')` | `GestureDetector` รากของสัตว์เลี้ยง (ใช้ `tester.tap`) |
| `PetKeys.painter` = `ValueKey('pet_painter')` | `CustomPaint` ที่ `painter` เป็น `PetCharacterPainter` |
| key ที่ฟีเจอร์ส่งเข้า `PetCharacter(key: ...)` | ตัว widget เอง (เช่น `water_pet_image_<mood>`, `steps_pet_image_<status>`) |

```dart
final painter = tester.widget<CustomPaint>(find.byKey(PetKeys.painter)).painter
    as PetCharacterPainter;
expect(painter.pose, PetPose.stepsMuscle);
expect(painter.bodyShape, PetBodyShape.muscle);
expect(painter.face, PetFace.proud);
expect(painter.animated, isFalse);
```

- ถ้าในหน้าจอมีสัตว์เลี้ยงตัวเดียว `find.byKey(PetKeys.painter)` เจอตัวเดียว ถ้ามีหลายตัวให้ใช้ `find.descendant(of: find.byKey(<key ฟีเจอร์>), matching: find.byKey(PetKeys.painter))`
- `animate: false` → ไม่มี ticker, `pumpAndSettle()` ใช้ได้; แตะ/cheer ไม่เล่นอนิเมชัน (แต่ `onTap` ยังถูกเรียก)
- `animate: true` → หายใจตลอด **ห้ามใช้ `pumpAndSettle()`** (จะ timeout) ให้ใช้ `pump(Duration)`; แตะแล้ว `pump(200ms)` → `isJumping == true`, `face == PetFace.funny`; รอเกิน 650 ms หลังเฟรมแรก → `action == PetAction.none`; เปลี่ยน `cheerTrigger` แล้ว `pump(100ms)` → `isCheering == true`
- กะพริบตาสุ่มด้วย `random` — ส่ง `Random(seed)` เพื่อให้ผลซ้ำได้; Timer ถูกยกเลิกตอน dispose ไม่ค้างหลังเทสต์

## 8. กฎการแก้ไขตัวละคร

- เพิ่มท่า/สีหน้าใหม่ = เพิ่มค่าใน enum + กิ่งใน painter + แถวในเอกสารนี้ + ภาพ preview — ห้ามสร้าง widget สัตว์เลี้ยงตัวที่สอง
- สี/สัดส่วนเปลี่ยนได้ที่ `pet_constants.dart` เท่านั้นและต้องแก้เอกสารนี้ให้ตรง
- รูปร่างและสีหน้าต้องต่างกันชัดที่ 160 px (ตรวจด้วย `preview/all_states_160.png`)

## 9. คำถามค้าง

1. ภาพแรงบันดาลใจ `docs/_design/character-frog.png` ยังไม่มีใน repo — ออกแบบจากคำบรรยาย ถ้าเจ้าของเพิ่มภาพแล้ว ต้องการให้ปรับอะไรไหม
2. water game-rules §2 บอกว่า "ถ้ามี PNG ใน app/assets/images/ ให้ใช้ PNG แทนภาพวาด" และปัจจุบันมี `pet_critical/tired/happy.png` อยู่จริง (เป็นตัวละครคนละแบบกับกบ) — เมื่อเปลี่ยนมาใช้ `PetCharacter` ต้องให้ Product ตัดสินว่าเลิกใช้ PNG (แก้ game-rules + ลบ/เก็บไฟล์) หรือคง PNG ไว้ ซึ่งจะขัดกับหลัก "ตัวละครเดียวทั้งแอป"
3. steps FAT ใช้สีหน้า `tired` (มีเหงื่อ ตาปรือ) เพื่อสื่อ "อ้วนอืด" — ถ้า Product อยากให้ FAT ดูร่าเริงกว่านี้ (ไม่ให้ผู้ใช้รู้สึกโดนตำหนิ) สามารถเปลี่ยนเป็น `content` ได้โดยแก้ preset เดียว
