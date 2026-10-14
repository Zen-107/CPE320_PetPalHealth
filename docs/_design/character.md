# คัมภีร์ตัวละคร (Character Bible) — กบน้อย PetPal

> แหล่งความจริงเรื่องหน้าตา/ท่าทางของสัตว์เลี้ยงทั้งแอป โค้ดอยู่ที่ `app/lib/shared/pet/` ค่าทุกตัวในเอกสารนี้ตรงกับ `pet_constants.dart`
> ผู้ดูแล: Art agent (`.claude/agents/art.md`) · อัปเดตล่าสุด 2026-10-14 (รอบ 2 — ลุค "เอ๋อ" (derpy): ตาเหล่ หนังตาตกข้างเดียว ฟองน้ำลาย · แก้ตัวอย่างการใส่ Key §7)

## 1. ตัวละคร

- กบตัวกลมอ้วนนุ่ม (ทรงโมจิ: หัวกับตัวเป็นก้อนเดียว ก้นแบน) ตาโตอยู่บนปุ่มนูนสองข้างของหัว มีใบไม้ปักบนหัว แก้มชมพู แลบลิ้นเป็นเอกลักษณ์
- นิสัย: เอ๋อ ๆ แต่ใจดี (dopey-but-kind) — แม้ตอนปกติก็มักแลบลิ้นนิด ๆ ("blep") ตาเหล่มองคนละทิศ หนังตาตกข้างเดียว มีฟองน้ำลายเล็ก ๆ ที่มุมปาก (§4.1) ไม่ดุ ไม่น่ากลัวแม้ในสถานะแย่ (ป่วยแบบน่าสงสาร ไม่ใช่น่ากลัว)
- สไตล์: เวกเตอร์เรียบ สีพาสเทล เส้นขอบเขียวเข้มหนา มุมมน ไม่มีเงาไล่สี (ยกเว้นเงาพื้นและเงาเสี้ยวที่ต้นขา MUSCLE)
- มีตัวเดียวทั้งแอป — ทุกฟีเจอร์ใช้ widget `PetCharacter` เท่านั้น ห้ามวาดสัตว์เลี้ยงตัวอื่น
- ภาพแรงบันดาลใจ `docs/_design/character-frog.png` (ยืมมาจากงานอื่น) ใช้เป็น **แรงบันดาลใจเท่านั้น**: รอบ 2 หยิบเสน่ห์ "เอ๋อ" (ตาเหล่ หนังตาตกข้างเดียว ฟองน้ำลาย) มาวางทับตัวละครเดิม ไม่ลอกภาพ ไม่ใช้ชื่อตัวละครในภาพ และห้ามนำภาพนั้นไปใช้ในแอป

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
| `drool` | `#D4EEFB` | ฟองน้ำลาย (ไฮไลต์ใช้ `eyeWhite`) — รอบ 2 |
| `droolOutline` | `#86C3E3` | ขอบฟองน้ำลาย — รอบ 2 |

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

ลำดับการวาด: เงาพื้น → ต้นขาหลัง → ตัว+ปุ่มตา → พุง → แขน → ต้นขา MUSCLE → เท้า → แก้ม → ตา/คิ้ว → ปาก/ลิ้น → ฟองน้ำลาย → ใบไม้ → เหงื่อ → ประกาย

## 4. สีหน้า (`PetExpression` = สีหน้าหลัก, `PetFace` = หน้าที่วาดจริงในเฟรมนั้น)

ค่าตาแต่ละข้างอยู่ใน `PetDerpy.eyes` (ซ้าย, ขวา) หน่วยเป็นสัดส่วนของรัศมีตาขาว `r` · ตาซ้าย = ข้าง "ตื่น" ตาดำโตมองขึ้น-ออกนอก · ตาขวา = ข้าง "ง่วง" ตาดำเล็กกว่ามองลง-ออกนอก

| หน้า (`PetFace`) | ตาซ้าย: หนังตา / ตาดำ dx,dy / ขนาด | ตาขวา: หนังตา / ตาดำ dx,dy / ขนาด | ปาก/ลิ้น | ฟองน้ำลาย | อื่น ๆ |
|---|---|---|---|---|---|
| `happy` | 0 / −0.18,−0.10 / 0.62 | **0.30** / +0.20,+0.24 / 0.50 | ยิ้มอ้ารูป D เห็นลิ้นข้างใน | **มี** ห้อยใต้มุมปากขวา | แก้มชมพูเข้ม ประกาย 2 ดวง ใบไม้ตั้ง |
| `content` | 0 / −0.16,−0.04 / 0.58 | **0.38** / +0.22,+0.28 / 0.46 | ยิ้มปิด + แลบลิ้น "blep" ตรงกลาง | **มี** ข้างปลายลิ้น | ใจดี สบาย ๆ ลุคเอ๋อเต็มที่ |
| `proud` | 0 / −0.14,−0.12 / 0.60 | **0.24** / +0.18,+0.14 / 0.50 | ยิ้มกว้างปิด มุมปากยก + แลบลิ้นด้านข้าง | ไม่มี | **คิ้วเฉียงมุ่งมั่น** สองข้าง (ตาขวาหรี่ใต้คิ้ว = ยิ้มเท่ ๆ) ประกาย 2 ดวง |
| `tired` | **0.45** / −0.12,+0.30 / 0.56 | **0.55** / +0.16,+0.36 / 0.48 | อ้าปากเล็กหอบ ลิ้นห้อยยาว (แกว่งตามการหายใจ) | ไม่มี | หยดเหงื่อ 1 หยด แก้มซีด ใบไม้เอียง แขนห้อย |
| `critical` | **0.62** / −0.10,+0.45 / 0.48 | **0.70** / +0.14,+0.50 / 0.42 | ปากหยักเบี้ยว ลิ้นห้อยเอียงข้าง | ไม่มี | ถุงใต้ตา ตัวซีด `bodyCritical` ตัวยุบลง (สูง ×0.96 กว้าง ×1.03) ใบไม้เหี่ยวพับข้าง สีเหลืองหม่น หยดเหงื่อ 2 หยด แก้มจางมาก แขนห้อย หายใจช้าและเบา |
| `blink` | ปิด (เส้นโค้ง ‿) | ปิด | คงปาก ใบไม้ แก้ม ตามสีหน้าเดิม (เปลี่ยนแค่ตา) | ตามสีหน้าเดิม (happy/content มี) | เกิดสุ่มทุก 1.8–5.0 วินาที นาน 180 ms |
| `funny` (แตะตัว) | `>` | `<` | อ้าปากกลม ลิ้นยื่นยาวเฉียง | ไม่มี | แขนกางออก ตัวกระโดด (เหมือนรอบ 1) |
| `cheer` (เพิ่มน้ำ/ก้าว) | `^` | `^` | ยิ้มอ้ากว้าง เห็นลิ้น | ไม่มี | ชูแขนสองข้าง กระโดด 2 ครั้ง ประกาย 5 ดวง ใบไม้โบก (เหมือนรอบ 1) |

### 4.1 ลุค "เอ๋อ" (derpy) — รอบ 2

วางทับทุกสีหน้าที่ลืมตา (`happy/content/proud/tired/critical`) โดย **ไม่แตะรูปร่าง ท่าแขน ปาก ใบไม้ เหงื่อ ประกาย** ของแต่ละสถานะ (ค่าทั้งหมดอยู่ใน `PetDerpy` ใน `pet_constants.dart`)

1. **ตาเหล่** — ตาดำสองข้างมองคนละทิศ (ซ้ายขึ้น-ออก, ขวาลง-ออก) และขนาดไม่เท่ากัน (ขวาเล็กกว่า ~0.8×) ตาดำและประกายถูกตัด (clip) ให้อยู่ในตาขาวเสมอ
2. **หนังตาตกข้างเดียว** — สีหน้าปกติ (`happy/content/proud`) มีหนังตาตกที่ **ตาขวาข้างเดียว** 0.24–0.38 (≤ `PetDerpy.halfLidMax` 0.40) ตาซ้ายเปิดเต็ม
   - เส้นหนังตาโค้งนูนขึ้นเล็กน้อย ปลายด้านนอกห้อยลง (`lidDroop` 0.012) และยื่นเลยขอบตาขาว (`lidOvershoot` 0.014) — ใช้กับทุกตาที่มีหนังตา (รวม tired/critical)
   - **กฎแยกสถานะ**: สถานะต่ำมีหนังตาตก **ทั้งสองข้าง** และทุกข้าง ≥ 0.45 (tired 0.45/0.55, critical 0.62/0.70) ส่วนสถานะดีตกข้างเดียว ≤ 0.38 → ที่ 160 px อ่านได้ทันที: "ปรือข้างเดียว = เอ๋อ", "ปรือสองข้าง + เหงื่อ = เหนื่อย", "ปรือมาก + ถุงใต้ตา + ตัวซีด = แย่"
3. **ฟองน้ำลาย** — วงกลมฟ้าอ่อน `drool` ขอบ `droolOutline` + จุดไฮไลต์ขาว รัศมี `droolRadius` 0.028·s (ที่ 160 px ≈ 9 px) พองขึ้น +15% ตามการหายใจ
   - แสดงเฉพาะ `happy` (ใต้มุมปากขวาของรอยยิ้มรูป D) และ `content` (ข้างปลายลิ้น blep) — รวมตอนกะพริบตา
   - ไม่แสดงใน `proud` (MUSCLE ต้องดูมั่นใจ และมุมปากมีลิ้น+ลักยิ้มแน่นแล้ว), `tired`/`critical` (สีฟ้าในสถานะต่ำสงวนไว้ให้หยดเหงื่อ ไม่ให้สับสน และน้ำลายไหลตอนป่วยดูไม่น่ารัก), `funny`/`cheer` (เคลื่อนไหวเร็ว)
4. ใบไม้บนหัว แก้มชมพู ลิ้นแลบ และนิสัยใจดีคงเดิม · `blink`/`funny`/`cheer` ไม่มีตาเหล่ (ตาปิด/สัญลักษณ์)

ตัวตรวจในเทสต์ (getter ใหม่ของ `PetCharacterPainter`): `isDerpyEye` (วาดตาเหล่เฟรมนี้ = ไม่มี action และไม่กะพริบ), `hasHalfLidEye` (ตาตกข้างเดียว — happy/content/proud ขณะลืมตา), `showsDroolBubble` (happy/content เมื่อไม่มี action), `eyeSpecs` (ค่า `(PetEyeSpec ซ้าย, PetEyeSpec ขวา)` ของสีหน้า) · `hasDroopyEyes` ความหมายเดิม = ตาปรือสองข้างของสถานะต่ำ

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

ความต่างที่ต้องรักษา: water 3 สถานะต่างกันที่ตา (ตกข้างเดียว+ฟองน้ำลาย / ตกสองข้าง / ตกมากสองข้าง+มองล่าง+ถุงใต้ตา) ปาก ใบไม้ (ตั้ง / เอียง / เหี่ยว) แขน (วางพุง / ห้อย) และเหงื่อ — ไม่ใช่แค่สี; steps 4 สถานะต่างกันที่ **รูปร่าง** ก่อน (กว้างแบน / กลม / ผอมสูง / ต้นขากล้าม+เบ่งแขน) แล้วจึงสีหน้า

## 6. อนิเมชัน (Flutter ล้วน: `CustomPainter` + `AnimationController`)

| อนิเมชัน | ทำงานเมื่อ | รายละเอียด | ค่าใน `PetTiming` |
|---|---|---|---|
| หายใจ (idle) | ตลอดเวลาเมื่อ `animate: true` | ยืด-หดตัวรอบเส้นพื้น สูง +3% กว้าง −1.5% (critical ×0.6) ประกาย/ใบไม้ขยับตาม ฟองน้ำลายพองขึ้น +15% | `breath` 2400 ms (ไป-กลับ), สถานะต่ำ `breathLow` 3400 ms |
| กะพริบตา | สุ่ม | หนังตาปิด 0→1→0 | `blink` 180 ms ห่างกัน 1800 + random(0..3200) ms |
| แตะตัว → กระโดด + หน้าตลก | แตะที่กล่องของสัตว์เลี้ยง (`reactToTap`) | ย่อตัว → ลอย 0.10·s (ยืด) → ลงพื้นแล้วยุบ หน้า `funny` | `jump` 650 ms |
| ดีใจ (cheer) | `cheerTrigger` เปลี่ยนค่า | กระโดดสั้น 2 ครั้ง 0.06·s ชูแขน หน้า `cheer` ประกาย | `cheer` 900 ms |
| สถานะต่ำ | `tired` / `critical` | ตาปรือ (ค่าคงที่ของท่า) + หยดเหงื่อไหลลงตามจังหวะหายใจ + หายใจช้า | — |

ระหว่าง cheer แตะตัวจะไม่ขัดจังหวะ · เงาพื้นหดเมื่อลอย · `animate: false` = เฟรมนิ่ง (breath 0, ไม่มี blink/action) ไม่สร้าง controller หรือ Timer

## 7. วิธีใช้ widget

```dart
import 'package:petpal_health/shared/pet/pet.dart';

// ใน State ของหน้าจอ — สร้างครั้งเดียว คงที่ตลอดอายุหน้าจอ
final GlobalKey _petKey = GlobalKey(debugLabel: 'water_pet');

// ใน build()
KeyedSubtree(
  key: ValueKey('water_pet_image_${mood.name}'), // key ฟีเจอร์ (เปลี่ยนตามสถานะ) อยู่ที่ wrapper
  child: PetCharacter(
    key: _petKey,                 // GlobalKey คงที่ — ห้ามใส่ key ฟีเจอร์ตรงนี้
    pose: PetPose.waterHappy,     // หรือ PetPose(expression: ..., body: ...)
    size: 160,                    // default 160
    animate: true,                // false = ภาพนิ่ง ไม่มี ticker (ใช้ในเทสต์)
    random: Random(42),           // ไม่บังคับ — กำหนด seed ให้การกะพริบตาซ้ำได้
    cheerTrigger: addCount,       // เพิ่มค่าทุกครั้งที่บันทึกน้ำ/ก้าวสำเร็จ → เล่น cheer
    reactToTap: true,             // แตะ → กระโดด + หน้าตลก
    onTap: () {},                 // ไม่บังคับ (เรียกเสมอ แม้ animate: false)
    semanticLabel: 'สดชื่น',       // ไม่บังคับ
  ),
)
```

**ทำไมไม่ใส่ key ฟีเจอร์บน `PetCharacter` ตรง ๆ (BUG-PET-1):** key ฟีเจอร์ (`water_pet_image_<mood>`, `steps_pet_image_<status>`) เปลี่ยนเมื่อสถานะเปลี่ยน ถ้าอยู่บน `PetCharacter` Flutter จะทิ้ง State เดิมแล้วสร้างใหม่ — การบันทึกครั้งที่ทำให้สถานะเปลี่ยน (เช่น 3→4 แก้ว, ข้าม 35%) จึงเพิ่ม `cheerTrigger` ให้ State ที่ถูกทิ้ง ส่วน State ใหม่เริ่มด้วยค่าใหม่จึงไม่เห็นการเปลี่ยน → cheer หาย วิธีที่ถูก: ใส่ key ฟีเจอร์บน `KeyedSubtree` ที่ห่อไว้ (เทสต์ยังหาได้ด้วย key เดิม) และให้ `PetCharacter` ถือ `GlobalKey` ที่เก็บใน State ของหน้าจอ — GlobalKey ทำให้ State เดิม (พร้อม AnimationController ที่กำลังเล่น cheer) ถูกย้ายไปอยู่ใต้ wrapper ใหม่แทนการสร้างใหม่

API สาธารณะ (`app/lib/shared/pet/`):

- `PetCharacter` (StatefulWidget) — พารามิเตอร์ตามด้านบน; `pose` จำเป็น
- `PetPose(expression, body = normal)` — immutable มี `==`, `id` (เช่น `fat_tired`), `isLowState`, `copyWith`; presets `waterHappy/waterTired/waterCritical/stepsFat/stepsChubby/stepsLean/stepsMuscle`
- `enum PetExpression { happy, content, proud, tired, critical }` (ตั้งชื่อเลี่ยง `PetMood` ของ water)
- `enum PetBodyShape { normal, fat, chubby, lean, muscle }`
- `enum PetAction { none, jump, cheer }`
- `enum PetFace { happy, content, proud, tired, critical, blink, funny, cheer }`
- `PetCharacterPainter` (CustomPainter) — ฟิลด์ `pose, breath, blink, action, actionProgress, animated`; getter `expression, bodyShape, bodySpec, face, isBlinking, isJumping, isCheering, showsSweat, hasDroopyEyes, showsSparkles` + (รอบ 2) `isDerpyEye, hasHalfLidEye, showsDroolBubble, eyeSpecs`
- `PetColors`, `PetProportions`, `PetBodySpec`, `PetTiming`, `PetKeys` + (รอบ 2) `PetDerpy`, `PetEyeSpec`

`cheerTrigger`: เล่น cheer ทุกครั้งที่ค่า **เปลี่ยน** (ไม่ใช่แค่เพิ่ม) — ฟีเจอร์ควรเก็บตัวนับใน state/controller ให้คงที่ข้าม rebuild

### Key และการตรวจในเทสต์

| Key | widget |
|---|---|
| `PetKeys.character` = `ValueKey('pet_character')` | `GestureDetector` รากของสัตว์เลี้ยง (ใช้ `tester.tap`) |
| `PetKeys.painter` = `ValueKey('pet_painter')` | `CustomPaint` ที่ `painter` เป็น `PetCharacterPainter` |
| key ฟีเจอร์ `water_pet_image_<mood>` / `steps_pet_image_<status>` | `KeyedSubtree` ที่หน้าจอห่อ `PetCharacter` ไว้ (ไม่ใช่ตัว `PetCharacter`) |
| `GlobalKey` ใน State ของหน้าจอ (เช่น `debugLabel: 'water_pet'`) | ตัว `PetCharacter` — คงที่ข้ามการเปลี่ยนสถานะ (ไม่ใช่ key สำหรับค้นในเทสต์) |

```dart
final painter = tester.widget<CustomPaint>(find.byKey(PetKeys.painter)).painter
    as PetCharacterPainter;
expect(painter.pose, PetPose.stepsMuscle);
expect(painter.bodyShape, PetBodyShape.muscle);
expect(painter.face, PetFace.proud);
expect(painter.animated, isFalse);
expect(painter.hasHalfLidEye, isTrue);      // proud: ตาขวาหรี่ 0.24 ข้างเดียว
expect(painter.showsDroolBubble, isFalse);  // proud ไม่มีฟองน้ำลาย
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

1. (ปิดแล้ว รอบ 2) ภาพแรงบันดาลใจ `character-frog.png` มาแล้ว — หยิบเฉพาะลุคเอ๋อ (§4.1) ไม่ลอกภาพ/ชื่อ
2. (ปิดแล้ว — owner ตัดสิน 2026-10-14 ตามคอมเมนต์ใน water_home_screen.dart) water เลิกใช้ PNG ใช้ `PetCharacter` ตัวเดียว
3. steps FAT ใช้สีหน้า `tired` (เหงื่อ ตาปรือสองข้าง) เพื่อสื่อ "อ้วนอืด" — ถ้า Product อยากให้ FAT ดูร่าเริงกว่านี้ เปลี่ยนเป็น `content` ได้โดยแก้ preset เดียว (จะได้ตาตกข้างเดียว + ฟองน้ำลายแทน)
4. (รอบ 2) ภาพแรงบันดาลใจมีหน้า "พูด" (อ้าปากกลม) — ยังไม่มีสถานะไหนในเกมต้องใช้ จึงไม่ได้เพิ่ม ถ้าฟีเจอร์ใหม่ต้องการ แจ้ง Art เพื่อเพิ่ม `PetFace`
