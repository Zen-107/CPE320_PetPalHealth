# คัมภีร์ตัวละคร (Character Bible) — กบน้อย PetPal

> แหล่งความจริงเรื่องหน้าตา/ท่าทางของสัตว์เลี้ยงทั้งแอป โค้ดอยู่ที่ `app/lib/shared/pet/` ค่าทุกตัวในเอกสารนี้ตรงกับ `pet_constants.dart`
> ผู้ดูแล: Art agent (`.claude/agents/art.md`) · อัปเดตล่าสุด 2026-10-31 (รอบ 4 — ฟีเจอร์ dashboard: สีหน้า `crying` / `dazed` / `cheerful`, ลูปกระโดด `hop`, BUBBLY reuse `happy`) · รอบ 3 2026-10-30 (ฟีเจอร์ food: สีหน้า `eating` / `full` / `overfed`, รูปร่าง `stuffed`, ลูปเคี้ยว) · รอบ 2 2026-10-14 (ลุค "เอ๋อ": ตาเหล่ หนังตาตกข้างเดียว ฟองน้ำลาย · ตัวอย่างการใส่ Key §7)

## 1. ตัวละคร

- กบตัวกลมอ้วนนุ่ม (ทรงโมจิ: หัวกับตัวเป็นก้อนเดียว ก้นแบน) ตาโตอยู่บนปุ่มนูนสองข้างของหัว มีใบไม้ปักบนหัว แก้มชมพู แลบลิ้นเป็นเอกลักษณ์
- นิสัย: เอ๋อ ๆ แต่ใจดี (dopey-but-kind) — แม้ตอนปกติก็มักแลบลิ้นนิด ๆ ("blep") ตาเหล่มองคนละทิศ หนังตาตกข้างเดียว มีฟองน้ำลายเล็ก ๆ ที่มุมปาก (§4.1) ไม่ดุ ไม่น่ากลัวแม้ในสถานะแย่ (ป่วยแบบน่าสงสาร ไม่ใช่น่ากลัว)
- สไตล์: เวกเตอร์เรียบ สีพาสเทล เส้นขอบเขียวเข้มหนา มุมมน ไม่มีเงาไล่สี (ยกเว้นเงาพื้น เงาเสี้ยวที่ต้นขา MUSCLE และไฮไลต์บนพุง STUFFED)
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
| `rice` | `#FFFCF2` | ข้าวปั้น (onigiri) ที่ถือกิน + เม็ดข้าวกระเด็น — รอบ 3 food |
| `nori` | `#34473A` | แถบสาหร่ายบนข้าวปั้น — รอบ 3 food |
| `burp` | `#F2F6EE` | ควันเรอ (`full`) ขอบใช้ `outline` alpha 0.55 — รอบ 3 food |
| `tear` | `#B4E3FB` | สายน้ำตา + หยดน้ำตา (`crying`) อ่อนกว่า `sweat` และเป็น "สาย" จึงไม่สับสนกับหยดเหงื่อ — รอบ 4 dashboard |
| `tearOutline` | `#4A90C2` | ขอบน้ำตา และขอบหยดเหงื่อ (เดิมเป็นเลขในโค้ด ค่าเท่าเดิม) — รอบ 4 |
| `dazedDots` | `#7E9677` | จุด "..." ลอยข้างหัว (`dazed`) — รอบ 4 dashboard |

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
| `stuffed` (food รอบ 3) | 0.80 × 0.60 | **0.62 × 0.38 ต่ำลงจนเกือบแตะพื้น** มีเส้นขอบจาง + ไฮไลต์ขาว + สะดือจุด | 0.16 × 0.14 | 0.19 / 0.028 | "พุงกาง": ตัวช่วงล่างถูกขยายด้วยวงรีพุง (กว้าง × 1.06 สูง 0.36 ชิดพื้น) → ทรงลูกแพร์/ลูกบอล พุงตึงกลมเงา |

ข้อสังเกต `stuffed` ต่างจาก `fat` ชัด: FAT กว้างเต็มกรอบ เตี้ยแบน มีเส้นพุง**พับ** (อ้วน) ส่วน STUFFED กว้างพอดี ตัวสูงปกติ แต่พุงล่าง**ตึงกลมเงา** โป่งออกด้านข้าง (อิ่ม) — ยังคงกฎเดิม: FAT กว้างและเตี้ยสุด, LEAN ผอมสุด, CHUBBY สูงสุด, MUSCLE ต้นขาใหญ่สุด

ลำดับการวาด: เงาพื้น → ต้นขาหลัง → ตัว+ปุ่มตา (+วงรีพุง STUFFED) → พุง (+ขอบ/ไฮไลต์ STUFFED) → แขน → ข้าวปั้น → มือ (ตอนกิน มือวาดทับข้าวปั้น) → ต้นขา MUSCLE → เท้า → แก้มป่อง (ตอนกิน) → แก้ม → ตา/คิ้ว → ปาก/ลิ้น → ฟองน้ำลาย → เม็ดข้าว / ควันเรอ → ใบไม้ → เหงื่อ → ประกาย

ค่ารอบ 4 (dashboard): ความสูงกระโดดต่อเนื่องของ `cheerful` `hopHeight` 0.05 (cheer เดิม 0.06, แตะ 0.10) · สายน้ำตากว้าง 0.036 → 0.054 จากใต้ตา (+0.32 r) ยาวลงถึงใต้ปาก 0.13 · จุด "..." รัศมี 0.016 / 0.019 / 0.022 · รอบ 4 วาดน้ำตาหลังปาก (ทับแก้ม) และจุด "..." หลังเม็ดข้าว/ควันเรอ ก่อนใบไม้

ขนาดอุปกรณ์ food (`PetProportions`): ข้าวปั้นกว้าง `foodSize` 0.20 (สูง ×0.92) จุดกลางอยู่ใต้ปาก 0.135 ยกขึ้น 0.025 ตอนอ้าปากกัด · แก้มป่อง รัศมี `cheekPuffRadius` 0.058 ยื่นออกนอกขอบหน้า (ยุบ 30% ตอนอ้าปาก) · วงรีพุง `paunchWidthFactor` 1.06 / `paunchHeight` 0.36

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
| `eating` (food รอบ 3) | 0 / **+0.24,+0.30** / 0.60 | **0.30** / **−0.22,+0.34** / 0.48 | ปาก "ω" เคี้ยว ↔ อ้าปากกัดเห็นลิ้น (ลูปเคี้ยว) | ไม่มี | **ตาเหล่เข้าหากันมองข้าวปั้น** (ตาดำสองข้างหันเข้าใน-ลง) · สองมือประคองข้าวปั้น (มีรอยกัด) ใต้ปาก แขนงอเป็นวงโอบ · **แก้มป่อง** ยื่นออกนอกหน้า · เม็ดข้าวกระเด็น 2 เม็ด · ใบไม้ผงกตามจังหวะเคี้ยว |
| `full` (food รอบ 3) | **ปิด** (‿) lid 1.0 | **ปิด** (‿) lid 1.0 | ยิ้มกว้างปิด + ลิ้นเลียมุมปากซ้าย | ไม่มี | "อิ่มฟิน" หลับตาพริ้ม · มือแปะข้างพุง (ขยับตามหายใจ) · **ควันเรอ** 3 ก้อนที่มุมปากขวา · ใบไม้เอียงสบาย ๆ |
| `overfed` (food รอบ 3) | **0.48** / +0.22,+0.36 / 0.56 | **0.58** / −0.20,+0.40 / 0.46 | ปาก "ω" ปลายตก (เคี้ยวฝืน ๆ) ↔ อ้าปากกัด | ไม่มี | ตาเหล่มองข้าวปั้นแต่**หนังตาหนักสองข้าง** · **คิ้วกังวล** (ปลายในยกขึ้น — กลับด้านกับ proud) · หยดเหงื่อ 1 หยด · ถือข้าวปั้น + แก้มป่อง + เม็ดข้าว · ใบไม้เอียงแบบ tired |

| `crying` (dashboard รอบ 4) | **ปิดแน่น** lid 1.0 วาดเป็นเส้นโค้งหนาเอียงเศร้า (ปลายนอกต่ำ) | ปิดแน่น (สมมาตร) | **อ้าปากร้องไห้กว้าง** มุมปากตกลง เห็นลิ้นข้างใน | ไม่มี | **สายน้ำตา** สองข้างไหลจากใต้ตาลงถึงแก้ม + หยดน้ำตา 1 หยดหล่นจากข้างตาซ้ายตามจังหวะหายใจ · **คิ้วกังวล** (แบบ overfed แต่ต่ำลง 0.052 ให้อยู่ในปุ่มตา) · ใบไม้ห้อยพับข้าง (1.05 rad สีปกติ ไม่เหี่ยว) · แขนห้อยแบบ tired · ตัวสีปกติ (ไม่ซีด ไม่มีเหงื่อ — ต่างจาก critical) |
| `dazed` (dashboard รอบ 4) | **0.36** / −0.02,+0.10 / **0.24** | **0.36** / +0.06,+0.12 / **0.20** | ปาก "o" เล็กเยื้องซ้าย (อ้าค้าง) | **มี** ห้อยที่ขอบขวาของปาก o | **ตาดำจุดเล็ก** มองตรงไปข้างหน้าแบบว่างเปล่า · หนังตาตก**เท่ากันสองข้าง** 0.36 · จุด **"..."** 3 จุดลอยขึ้นขวาบนของหัว ขยับตามหายใจ · ใบไม้เอียงขี้เกียจ (0.20 + 0.10·breath) · แขนวางพุงปกติ |
| `cheerful` (dashboard รอบ 4) | `^` | `^` | ยิ้มอ้ากว้าง เห็นลิ้น (แบบ cheer) | ไม่มี | ภาพเดียวกับ cheer แต่เป็น**สีหน้าค้าง**: ชูแขนสองข้างตลอด ประกาย 5 ดวงกระพริบตามจังหวะกระโดด แก้ม 0.95 ใบไม้โบก + **กระโดดต่อเนื่อง** (ลูป `hop`) |

หมายเหตุ dashboard: `crying` / `cheerful` ตาปิดอยู่แล้ว (lid 1.0) ตอนกะพริบ `face` = `blink` แต่ภาพตาไม่เปลี่ยน (วาดตาของสีหน้าเดิม — ใช้กับ `full` ด้วย ภาพเท่าเดิม) · ระหว่าง `funny` (แตะ) น้ำตา คิ้ว จุด "..." ฟองน้ำลาย และลูปกระโดดซ่อน/หยุดชั่วคราว · `cheer` ระหว่าง `cheerful` แทบเหมือนเดิม (ตั้งใจ — ดีใจอยู่แล้ว)

หมายเหตุ food: `blink` ระหว่าง `eating`/`overfed` ยังถือข้าวปั้นและเคี้ยวต่อ (เปลี่ยนแค่ตา) · `full` ตาปิดอยู่แล้ว กะพริบไม่เปลี่ยนภาพ · ระหว่าง `funny`/`cheer` ข้าวปั้น แก้มป่อง เม็ดข้าว ควันเรอ ซ่อนทั้งหมด

### 4.1 ลุค "เอ๋อ" (derpy) — รอบ 2

วางทับทุกสีหน้าที่ลืมตา (`happy/content/proud/tired/critical`) โดย **ไม่แตะรูปร่าง ท่าแขน ปาก ใบไม้ เหงื่อ ประกาย** ของแต่ละสถานะ (ค่าทั้งหมดอยู่ใน `PetDerpy` ใน `pet_constants.dart`)

1. **ตาเหล่** — ตาดำสองข้างมองคนละทิศ (ซ้ายขึ้น-ออก, ขวาลง-ออก) และขนาดไม่เท่ากัน (ขวาเล็กกว่า ~0.8×) ตาดำและประกายถูกตัด (clip) ให้อยู่ในตาขาวเสมอ · ข้อยกเว้น (รอบ 3): `eating`/`overfed` ตาดำสองข้าง**หันเข้าหากัน-ลง**มองข้าวปั้นในมือ (ตาเหล่เข้า = ยังเอ๋อ แต่มีเป้าหมาย) ขนาดยังไม่เท่ากันตามเดิม
2. **หนังตาตกข้างเดียว** — สีหน้าปกติ (`happy/content/proud`) มีหนังตาตกที่ **ตาขวาข้างเดียว** 0.24–0.38 (≤ `PetDerpy.halfLidMax` 0.40) ตาซ้ายเปิดเต็ม
   - เส้นหนังตาโค้งนูนขึ้นเล็กน้อย ปลายด้านนอกห้อยลง (`lidDroop` 0.012) และยื่นเลยขอบตาขาว (`lidOvershoot` 0.014) — ใช้กับทุกตาที่มีหนังตา (รวม tired/critical)
   - `eating` ตกข้างเดียว 0.30 ตามกฎสถานะดี · `overfed` ตกสองข้าง ≥ 0.45 (0.48/0.58) ตามกฎ "ปรือสองข้าง" แต่**ต่างจาก tired** ที่ตาดำมองเข้าหาข้าวปั้น + คิ้วกังวล + ถือของกิน · `full` ปิดสองข้าง (lid 1.0 ≥ `closedLid` 0.92) → ไม่วาดตาเหล่
   - (รอบ 4) `dazed` หนังตาตก**สองข้างเท่ากัน 0.36** — อยู่ระหว่างสองกฎ: ไม่ใช่ "ข้างเดียว" (`hasHalfLidEye` = false) และไม่ถึง 0.45 (`hasDroopyEyes` = false) จุดที่อ่านว่า "เหม่อ" คือตาดำจุดเล็ก (0.24/0.20) มองตรง + "..." ไม่ใช่ความปรือ · `crying`/`cheerful` ปิดตา (lid 1.0) → ไม่วาดตาเหล่
   - **กฎแยกสถานะ**: สถานะต่ำมีหนังตาตก **ทั้งสองข้าง** และทุกข้าง ≥ 0.45 (tired 0.45/0.55, critical 0.62/0.70) ส่วนสถานะดีตกข้างเดียว ≤ 0.38 → ที่ 160 px อ่านได้ทันที: "ปรือข้างเดียว = เอ๋อ", "ปรือสองข้าง + เหงื่อ = เหนื่อย", "ปรือมาก + ถุงใต้ตา + ตัวซีด = แย่"
3. **ฟองน้ำลาย** — วงกลมฟ้าอ่อน `drool` ขอบ `droolOutline` + จุดไฮไลต์ขาว รัศมี `droolRadius` 0.028·s (ที่ 160 px ≈ 9 px) พองขึ้น +15% ตามการหายใจ
   - แสดงเฉพาะ `happy` (ใต้มุมปากขวาของรอยยิ้มรูป D), `content` (ข้างปลายลิ้น blep) และ (รอบ 4) `dazed` (ขอบขวาของปาก o — เหม่อจนน้ำลายไหล) — รวมตอนกะพริบตา
   - ไม่แสดงใน `proud` (MUSCLE ต้องดูมั่นใจ และมุมปากมีลิ้น+ลักยิ้มแน่นแล้ว), `tired`/`critical` (สีฟ้าในสถานะต่ำสงวนไว้ให้หยดเหงื่อ ไม่ให้สับสน และน้ำลายไหลตอนป่วยดูไม่น่ารัก), `funny`/`cheer` (เคลื่อนไหวเร็ว)
4. ใบไม้บนหัว แก้มชมพู ลิ้นแลบ และนิสัยใจดีคงเดิม · `blink`/`funny`/`cheer` ไม่มีตาเหล่ (ตาปิด/สัญลักษณ์)

ตัวตรวจในเทสต์ (getter ของ `PetCharacterPainter`): `isDerpyEye` (วาดตาเหล่เฟรมนี้ = ไม่มี action, ไม่กะพริบ และสีหน้าไม่ได้ปิดตา — `full` / `crying` / `cheerful` = false), `hasHalfLidEye` (ตาตกข้างเดียว — happy/content/proud/eating ขณะลืมตา), `showsDroolBubble` (happy/content เมื่อไม่มี action), `eyeSpecs` (ค่า `(PetEyeSpec ซ้าย, PetEyeSpec ขวา)` ของสีหน้า) · `hasDroopyEyes` = ลืมตาแบบเอ๋อ และหนังตา**ทุกข้าง** ≥ `PetDerpy.droopyLidMin` 0.45 → true เฉพาะ tired / critical / overfed (รอบ 3 เขียนเป็นกฎจากค่าตา ผลกับ 7 preset เดิมเท่าเดิม)

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
| food | `NORMAL` ท่าหิว/ปกติ | `PetPose.foodNormal` (**reuse** สีหน้า `content` + รูปร่าง `normal` — ไม่มีการวาดใหม่) | `content` (แลบลิ้น + ฟองน้ำลาย = "หิว อยากกิน" แต่ร่าเริง) | `normal` | `preview/food_normal.png` |
| food | `EATING` ชั่วคราวหลังส่งเมนูสำเร็จ | `PetPose.foodEating` (ใหม่) | `eating` + ลูปเคี้ยว | `normal` | `preview/food_eating.png` |
| food | `OVER_LIMIT` อิ่มพุงกาง | `PetPose.foodOverLimit` (ใหม่) | `full` | `stuffed` (ใหม่) | `preview/food_over_limit.png` |
| food | `OVER_LIMIT_FEEDING` อิ่มพุงกางแต่ยังกิน (ชั่วคราว) | `PetPose.foodOverLimitFeeding` (ใหม่) | `overfed` + ลูปเคี้ยว | `stuffed` | `preview/food_over_limit_feeding.png` |
| dashboard | `CRYING` (ร้องไห้) คะแนนรวม `[0, 30]` | `PetPose.dashboardCrying` (ใหม่) | `crying` | `normal` | `preview/dashboard_crying.png` |
| dashboard | `DAZED` (เหม่อลอย) `(30, 60]` | `PetPose.dashboardDazed` (ใหม่) | `dazed` | `normal` | `preview/dashboard_dazed.png` |
| dashboard | `BUBBLY` (ออรุ่มเจ๊าะ) `(60, 80]` | `PetPose.dashboardBubbly` (**reuse** สีหน้า `happy` + `normal` — ภาพเดียวกับ `waterHappy`, `==` กัน) | `happy` (ตาโตเป็นประกาย ยิ้มอ้า แก้มชมพู ประกาย ฟองน้ำลาย = สดใสออดอ้อน) | `normal` | `preview/dashboard_bubbly.png` |
| dashboard | `CHEERFUL` (ยิ้มร่าเริง) `(80, 100]` | `PetPose.dashboardCheerful` (ใหม่) | `cheerful` + ลูปกระโดด | `normal` | `preview/dashboard_cheerful.png` |

ภาพรวมทุกสถานะที่ขนาดจริง 160 px: `preview/all_states_160.png` (แถว 1 water happy/tired/critical + steps FAT · แถว 2 steps CHUBBY/LEAN/MUSCLE + food NORMAL · แถว 3 food EATING/OVER_LIMIT/OVER_LIMIT_FEEDING + dashboard CRYING · แถว 4 dashboard DAZED/BUBBLY/CHEERFUL) · food 4 ท่าเรียงกัน: `preview/food_states_160.png` · dashboard 4 ท่าเรียงกัน: `preview/dashboard_states_160.png` · เฟรมพิเศษ: `fx_blink.png`, `fx_jump_funny.png`, `fx_cheer.png`, `fx_breath_in.png`, `fx_critical_sweat.png`, `fx_food_chew_cycle.png` (แถวบน eating / แถวล่าง overfed ที่ chew 0, 0.25, 0.5), `fx_dashboard_loops.png` (แถวบน cheerful ที่ hop 0, 0.25, 0.5, 0.9 · แถวล่าง crying breath 0/1 แล้ว dazed breath 0/1)

ความต่างที่ต้องรักษา (dashboard): 4 ระดับต่างกันที่ **ตาและสิ่งประกอบ** ก่อน (รูปร่าง `normal` เท่ากันเพราะคะแนนรวมไม่ได้บอกรูปร่าง): CRYING = ตาปิดแน่นเอียงเศร้า + **สายน้ำตาฟ้า** + ปากร้องไห้ + ใบไม้ห้อย + แขนห้อย · DAZED = **ตาดำจุดเล็ก** ปรือเท่ากันสองข้าง + ปาก o + **"..."** · BUBBLY = ตาโตเอ๋อเป็นประกาย + ยิ้ม D + ประกาย 2 ดวง (แขนวางพุง) · CHEERFUL = ตา **^ ^** + **ชูแขน** + ประกาย 5 ดวง + **กระโดดต่อเนื่อง** — ระหว่าง BUBBLY กับ CHEERFUL ต่างที่ตา (เปิด vs ^ ^) และแขน (วางพุง vs ชูขึ้น) อ่านได้ที่ 160 px แม้ภาพนิ่ง · CRYING ต่างจาก water critical: ตัวสีปกติ ไม่มีเหงื่อ ใบไม้ไม่เหี่ยว ตาปิด (critical ตาปรือมองล่าง)

ความต่างที่ต้องรักษา (food): NORMAL vs EATING ต่างที่ **มือถือข้าวปั้น + แก้มป่อง + ตาเหล่เข้ามองของกิน + ปาก ω** (รูปร่างเท่ากันเพราะยังไม่เกินเป้า) · OVER_LIMIT และ OVER_LIMIT_FEEDING ต่างจากสองท่าแรกที่ **รูปร่าง stuffed พุงตึงกลม** ก่อน แล้ว OVER_LIMIT = หลับตาฟิน + มือแปะพุง + ควันเรอ (ไม่ถือของ) ส่วน OVER_LIMIT_FEEDING = ถือข้าวปั้นเคี้ยวต่อ + หนังตาหนักสองข้าง + คิ้วกังวล + เหงื่อ

ความต่างที่ต้องรักษา: water 3 สถานะต่างกันที่ตา (ตกข้างเดียว+ฟองน้ำลาย / ตกสองข้าง / ตกมากสองข้าง+มองล่าง+ถุงใต้ตา) ปาก ใบไม้ (ตั้ง / เอียง / เหี่ยว) แขน (วางพุง / ห้อย) และเหงื่อ — ไม่ใช่แค่สี; steps 4 สถานะต่างกันที่ **รูปร่าง** ก่อน (กว้างแบน / กลม / ผอมสูง / ต้นขากล้าม+เบ่งแขน) แล้วจึงสีหน้า

## 6. อนิเมชัน (Flutter ล้วน: `CustomPainter` + `AnimationController`)

| อนิเมชัน | ทำงานเมื่อ | รายละเอียด | ค่าใน `PetTiming` |
|---|---|---|---|
| หายใจ (idle) | ตลอดเวลาเมื่อ `animate: true` | ยืด-หดตัวรอบเส้นพื้น สูง +3% กว้าง −1.5% (critical ×0.6) ประกาย/ใบไม้ขยับตาม ฟองน้ำลายพองขึ้น +15% | `breath` 2400 ms (ไป-กลับ), สถานะต่ำ `breathLow` 3400 ms |
| กะพริบตา | สุ่ม | หนังตาปิด 0→1→0 | `blink` 180 ms ห่างกัน 1800 + random(0..3200) ms |
| แตะตัว → กระโดด + หน้าตลก | แตะที่กล่องของสัตว์เลี้ยง (`reactToTap`) | ย่อตัว → ลอย 0.10·s (ยืด) → ลงพื้นแล้วยุบ หน้า `funny` | `jump` 650 ms |
| ดีใจ (cheer) | `cheerTrigger` เปลี่ยนค่า | กระโดดสั้น 2 ครั้ง 0.06·s ชูแขน หน้า `cheer` ประกาย | `cheer` 900 ms |
| สถานะต่ำ | `tired` / `critical` | ตาปรือ (ค่าคงที่ของท่า) + หยดเหงื่อไหลลงตามจังหวะหายใจ + หายใจช้า | — |
| เคี้ยว (food รอบ 3) | ตลอดเวลาที่ `pose.isEating` (`eating` / `overfed`) และ `animate: true` | `AnimationController` แยก (`repeat`) สร้างเมื่อ pose เป็นท่ากิน และ dispose ทันทีเมื่อเปลี่ยนเป็นท่าอื่น · `chewOpen = sin(π·chew)`: < 0.3 ปาก "ω" แก้มป่องเต็ม, ≥ 0.3 อ้าปากกัด แก้มยุบ 30% ข้าวปั้นยกขึ้นหาปาก เม็ดข้าวขยับ ใบไม้ผงก | `chew` 420 ms ต่อ 1 คำ |
| อิ่ม (food รอบ 3) | `full` | ใช้ลมหายใจเดิม: มือตบพุงขึ้นลง ควันเรอลอยขึ้น ใบไม้แกว่ง | `breath` 2400 ms |
| กระโดดต่อเนื่อง (dashboard รอบ 4) | ตลอดเวลาที่ `pose.isBouncing` (`cheerful`) และ `animate: true` และไม่มี action | `AnimationController` แยก (`repeat`) สร้างเมื่อ pose เป็น `cheerful` dispose ทันทีเมื่อเปลี่ยนท่า · `hopLift = sin(π·hop) × hopHeight` ลอยแล้วยืด ใกล้พื้นยุบ ใบไม้โบก ประกายกระพริบ · แตะ (jump) / cheer เล่นทับได้ตามปกติ | `hop` 760 ms ต่อ 1 กระโดด, `hopHeight` 0.05 |
| ร้องไห้ (dashboard รอบ 4) | `crying` | ใช้ลมหายใจเดิม: หยดน้ำตาหล่นลง (+0.06) และจางลง | `breath` 2400 ms |
| เหม่อ (dashboard รอบ 4) | `dazed` | ใช้ลมหายใจเดิม: จุด "..." ลอยขึ้นลงทีละจุด ใบไม้แกว่งช้า ฟองน้ำลายพอง | `breath` 2400 ms |

**ระยะเวลาของ `EATING` / `OVER_LIMIT_FEEDING` เป็นของฟีเจอร์** (`EATING_ANIMATION_DURATION` ใน docs/food/game-rules.md) — widget ไม่จับเวลาเอง: หน้าจอส่ง `PetPose.foodEating` / `foodOverLimitFeeding` ตลอดช่วงที่สถานะเป็นท่าชั่วคราว แล้วเปลี่ยน pose กลับเมื่อหมดเวลา (widget เคี้ยววนจนกว่า pose จะเปลี่ยน)

ระหว่าง cheer แตะตัวจะไม่ขัดจังหวะ · เงาพื้นหดเมื่อลอย · `animate: false` = เฟรมนิ่ง (breath 0, chew 0, ไม่มี blink/action) ไม่สร้าง controller หรือ Timer — ท่ากินแบบนิ่งแสดงปาก "ω" + แก้มป่อง + ข้าวปั้นมีรอยกัด จึงอ่านออกว่ากำลังกินแม้ไม่ขยับ

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
- `PetPose(expression, body = normal)` — immutable มี `==`, `id` (เช่น `fat_tired`, `stuffed_full`, `normal_crying`), `isLowState`, `isEating` (รอบ 3), `isBouncing` (รอบ 4), `copyWith`; presets `waterHappy/waterTired/waterCritical/stepsFat/stepsChubby/stepsLean/stepsMuscle` + (รอบ 3) `foodNormal/foodEating/foodOverLimit/foodOverLimitFeeding` + (รอบ 4) `dashboardCrying/dashboardDazed/dashboardBubbly/dashboardCheerful`
- `enum PetExpression { happy, content, proud, tired, critical, eating, full, overfed, crying, dazed, cheerful }` (ตั้งชื่อเลี่ยง `PetMood` ของ water)
- `enum PetBodyShape { normal, fat, chubby, lean, muscle, stuffed }`
- `enum PetAction { none, jump, cheer }` (ไม่เปลี่ยน — EATING เป็น pose ไม่ใช่ action)
- `enum PetFace { happy, content, proud, tired, critical, blink, funny, cheer, eating, full, overfed, crying, dazed, cheerful }`
- `PetCharacterPainter` (CustomPainter) — ฟิลด์ `pose, breath, blink, action, actionProgress, animated` + (รอบ 3) `chew` + (รอบ 4) `hop`; getter `expression, bodyShape, bodySpec, face, isBlinking, isJumping, isCheering, showsSweat, hasDroopyEyes, showsSparkles` + (รอบ 2) `isDerpyEye, hasHalfLidEye, showsDroolBubble, eyeSpecs` + (รอบ 3) `showsFood, showsPuffedCheeks, showsBurpPuff, showsWorriedBrows, chewOpen` + (รอบ 4) `showsTears, showsThoughtDots, hopLift` (`showsWorriedBrows` รวม `crying` ด้วย, `showsSparkles` รวม `cheerful`)
- `PetColors` (+ รอบ 4 `tear`, `tearOutline`, `dazedDots`), `PetProportions` (+ รอบ 4 `hopHeight`), `PetBodySpec` (+ `bellyBulge`), `PetTiming` (+ `chew`, รอบ 4 `hop`), `PetKeys` + (รอบ 2) `PetDerpy` (+ รอบ 3 `closedLid`, `droopyLidMin`; รอบ 4 `dazed` อยู่ใน `droolExpressions`), `PetEyeSpec`

`cheerTrigger`: เล่น cheer ทุกครั้งที่ค่า **เปลี่ยน** (ไม่ใช่แค่เพิ่ม) — ฟีเจอร์ควรเก็บตัวนับใน state/controller ให้คงที่ข้าม rebuild

### Key และการตรวจในเทสต์

| Key | widget |
|---|---|
| `PetKeys.character` = `ValueKey('pet_character')` | `GestureDetector` รากของสัตว์เลี้ยง (ใช้ `tester.tap`) |
| `PetKeys.painter` = `ValueKey('pet_painter')` | `CustomPaint` ที่ `painter` เป็น `PetCharacterPainter` |
| key ฟีเจอร์ `water_pet_image_<mood>` / `steps_pet_image_<status>` / (เสนอ) `food_pet_image_<state>` / (เสนอ รอบ 4) `dashboard_pet_image_<mood>` เช่น `dashboard_pet_image_crying` | `KeyedSubtree` ที่หน้าจอห่อ `PetCharacter` ไว้ (ไม่ใช่ตัว `PetCharacter`) — ชื่อ key ของ food ให้ Dev/QA ตัดสิน |
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
- food (รอบ 3): `animate: false` + `PetPose.foodEating` → `face == PetFace.eating`, `showsFood`, `showsPuffedCheeks`, `hasHalfLidEye` เป็น true, `chew == 0`, ไม่มี ticker · `foodOverLimitFeeding` → `face == PetFace.overfed`; `showsFood`, `showsSweat`, `hasDroopyEyes`, `showsWorriedBrows` เป็น true · `foodOverLimit` → `face == PetFace.full`, `bodyShape == PetBodyShape.stuffed`, `showsBurpPuff == true`, `isDerpyEye == false`, `showsFood == false` · `foodNormal` → `face == PetFace.content`, `showsDroolBubble == true` · `animate: true` + ท่ากิน แล้ว `pump(100ms)` → `chew > 0`; เปลี่ยนเป็นท่าไม่กิน → `chew == 0`

- dashboard (รอบ 4): `animate: false` + `dashboardCrying` → `face == PetFace.crying`, `showsTears`, `showsWorriedBrows` เป็น true; `isDerpyEye`, `showsSweat`, `showsSparkles`, `showsDroolBubble` เป็น false · `dashboardDazed` → `face == PetFace.dazed`, `showsThoughtDots`, `showsDroolBubble`, `isDerpyEye` เป็น true; `hasHalfLidEye`, `hasDroopyEyes`, `showsSweat` เป็น false · `dashboardBubbly` → `== PetPose.waterHappy`, `face == PetFace.happy`, `showsSparkles`, `hasHalfLidEye` เป็น true · `dashboardCheerful` → `face == PetFace.cheerful`, `showsSparkles == true`, `isDerpyEye == false`, `hop == 0`, `hopLift == 0`, ไม่มี ticker · ทั้ง 4 ท่า `bodyShape == PetBodyShape.normal`, `isLowState == false`, `isEating == false` · `animate: true` + `dashboardCheerful` แล้ว `pump(200ms)` → `hop > 0`, `hopLift > 0`; ท่าอื่น `hop == 0` · แตะระหว่าง cheerful → `face == PetFace.funny`, `hopLift == 0`

```dart
// dashboard — สถานะ game-rules §2 → pose (ตัวอย่างฝั่ง Dev; ชื่อ enum ฝั่งฟีเจอร์เป็นของ Dev)
PetPose dashboardPose(DashboardPetMood m) => switch (m) {
      DashboardPetMood.crying => PetPose.dashboardCrying,     // [0, 30]
      DashboardPetMood.dazed => PetPose.dashboardDazed,       // (30, 60]
      DashboardPetMood.bubbly => PetPose.dashboardBubbly,     // (60, 80]
      DashboardPetMood.cheerful => PetPose.dashboardCheerful, // (80, 100]
    };
// ขนาด: ux-flow / game-rules ให้ fallback 300×300 → PetCharacter(size: 300) ได้ (วาดเวกเตอร์ คมทุกขนาด)
```

```dart
// food — สถานะ game-rules §2 → pose (ตัวอย่างฝั่ง Dev; ชื่อ enum ฝั่งฟีเจอร์เป็นของ Dev)
PetPose foodPose(FoodPetState s) => switch (s) {
      FoodPetState.normal => PetPose.foodNormal,
      FoodPetState.eating => PetPose.foodEating,
      FoodPetState.overLimit => PetPose.foodOverLimit,
      FoodPetState.overLimitFeeding => PetPose.foodOverLimitFeeding,
    };
// ไม่ต้องเพิ่ม cheerTrigger ตอนบันทึกอาหาร — ท่ากินคือ reaction อยู่แล้ว (cheer จะทับหน้า eating)
```

## 8. กฎการแก้ไขตัวละคร

- เพิ่มท่า/สีหน้าใหม่ = เพิ่มค่าใน enum + กิ่งใน painter + แถวในเอกสารนี้ + ภาพ preview — ห้ามสร้าง widget สัตว์เลี้ยงตัวที่สอง
- สี/สัดส่วนเปลี่ยนได้ที่ `pet_constants.dart` เท่านั้นและต้องแก้เอกสารนี้ให้ตรง
- รูปร่างและสีหน้าต้องต่างกันชัดที่ 160 px (ตรวจด้วย `preview/all_states_160.png`)

## 9. คำถามค้าง

1. (ปิดแล้ว รอบ 2) ภาพแรงบันดาลใจ `character-frog.png` มาแล้ว — หยิบเฉพาะลุคเอ๋อ (§4.1) ไม่ลอกภาพ/ชื่อ
2. (ปิดแล้ว — owner ตัดสิน 2026-10-14 ตามคอมเมนต์ใน water_home_screen.dart) water เลิกใช้ PNG ใช้ `PetCharacter` ตัวเดียว
3. (decided by owner 2026-10-14: คง FAT เป็นหน้าเหนื่อย `tired`) steps FAT ใช้สีหน้า `tired` (เหงื่อ ตาปรือสองข้าง) เพื่อสื่อ "อ้วนอืด" — ถ้า Product อยากให้ FAT ดูร่าเริงกว่านี้ เปลี่ยนเป็น `content` ได้โดยแก้ preset เดียว (จะได้ตาตกข้างเดียว + ฟองน้ำลายแทน)
4. (รอบ 2) ภาพแรงบันดาลใจมีหน้า "พูด" (อ้าปากกลม) — ยังไม่มีสถานะไหนในเกมต้องใช้ จึงไม่ได้เพิ่ม ถ้าฟีเจอร์ใหม่ต้องการ แจ้ง Art เพื่อเพิ่ม `PetFace`
5. (DECIDED — owner ชั่วคราว 2026-10-30, รอทีมยืนยัน) food OQ-1: ไม่ใช้ Lottie และไม่ใช้ Sprite Sheets — 4 ท่าของ food วาดใน `PetCharacter` (CustomPainter) ตามข้อตกลง owner 2026-10-14 ที่ให้ทั้งแอปใช้สัตว์เลี้ยงตัวเดียว ใช้แทน requirements.md ข้อ 7 และ asset `assets/images/pet/*.json` / fallback PNG ใน ux-flow.md / game-rules.md
6. (รอบ 3 เปิด) food `NORMAL` ชื่อ "ท่าหิว / ท่าปกติ" แต่ครอบคลุมตั้งแต่ 0 kcal จนเกินเป้า 100 kcal — Art ใช้ `content` (หิวแต่ร่าเริง) ตลอดช่วง ถ้า Product อยากให้ "หิว" ชัดขึ้นตอนกินน้อย ต้องเพิ่มสถานะใน game-rules ก่อน (Art ไม่แบ่งช่วงเอง)
7. (รอบ 3 เปิด) food: บันทึกซ้อนระหว่าง `EATING` 2 วินาที (EC-2) ควรเริ่มนับใหม่หรือไม่ และหลัง `OVER_LIMIT_FEEDING` ควรค้างนานเท่าไร (game-rules ไม่ระบุเวลา) — เป็นกติกาของ game-rules; widget แค่เคี้ยววนตราบที่ pose ยังเป็นท่ากิน
8. (DECIDED — owner ชั่วคราว 2026-10-31, รอทีมยืนยัน) dashboard: สัตว์เลี้ยงใช้ `PetCharacter` (CustomPainter) ไม่ใช้ PNG — แทน `assets/images/pet_crying/dazed/bubbly/cheerful.png` และ fallback 300×300 ใน docs/dashboard/ux-flow.md §5 / game-rules.md §2; 4 อารมณ์ทำเป็น PetPose (reuse `happy` สำหรับ BUBBLY)
9. (รอบ 4 เปิด) dashboard BUBBLY "ออรุ่มเจ๊าะ" reuse สีหน้า `happy` ตามคำสั่ง owner — ภาพเหมือน water happy ทุกประการ ถ้า Product อยากให้ "ออดอ้อน" ชัดกว่านี้ (เช่น หัวใจลอย ตาหวาน) ต้องเพิ่ม `PetExpression` ใหม่ (ไม่กระทบ API — เปลี่ยนแค่ preset)
10. (รอบ 4 เปิด) dashboard ux-flow §5 เขียนช่วงเป็น "31-60 / 61-80 / 81-100" ส่วน game-rules §2 ใช้ `(30, 60]` ฯลฯ — เท่ากันเมื่อคะแนนเป็นจำนวนเต็ม (totalScore ปัดเป็น integer) Art ไม่ได้ใช้ตัวเลขนี้ แค่จับคู่ภาพ
