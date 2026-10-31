# UI spec: แดชบอร์ดสุขภาพรวมและอารมณ์สัตว์เลี้ยง (dashboard)

> สถานะ: draft (2026-10-31) · ผู้เขียน: UI agent · อ้างอิง: ux-flow.md, game-rules.md (บริบท: requirements.md, `ิbrief.md`, design-review.md)
> เอกสารนี้กำหนด "หน้าตา" เท่านั้น — ตัวเลข กติกา และ flow ให้ยึด ux-flow.md / game-rules.md และข้อตัดสิน owner ใน §0
> design language ยึดตาม `docs/food/ui-spec.md`, `docs/steps/ui-spec.md`, `docs/signup/ui-spec.md` และโค้ดจริงใน `app/lib/` — ไม่สร้างระบบดีไซน์ใหม่

## 0. ข้อตัดสินใจที่มีผลต่อ UI

ข้อ D-1 ถึง D-4 เป็นการตัดสินใจของเจ้าของโปรเจกต์ ไม่ใช่ของ UI agent — **DECIDED (owner ชั่วคราว, รอทีมยืนยัน), 2026-10-31** — spec นี้แค่กำหนดหน้าตาให้รองรับ · D-5 เป็นข้อตัดสินระดับแอปที่มีอยู่แล้ว

| # | ข้อตัดสินใจ (ที่มา) | ผลต่อ UI |
|---|---|---|
| D-1 | **สัตว์เลี้ยง — DECIDED (owner ชั่วคราว, รอทีมยืนยัน):** ใช้ `PetCharacter` (CustomPainter) ใน `app/lib/shared/pet/` ไม่ใช้ PNG — ใช้แทนไฟล์ภาพ 4 ไฟล์และ fallback 300×300 ใน ux-flow §2 (Pet Character Display "Image Asset"), §5, §6 ข้อ 1 และ game-rules §2, §5 ข้อ 1 (ตรงกับ character.md §9 ข้อ 8 และข้อตกลง owner 2026-10-14 ที่ทั้งแอปใช้สัตว์เลี้ยงตัวเดียว) | Pet Character Display ของ S-1 = `PetCharacter` + preset `PetPose.dashboard*` (§4) — ห้ามโหลดไฟล์ภาพใด ๆ เป็นสัตว์เลี้ยง ไม่ลงทะเบียน asset ใหม่ใน pubspec |
| D-2 | **เวลา — DECIDED (owner ชั่วคราว, รอทีมยืนยัน):** ใช้เวลาเครื่อง ตัดรอบ 05:00 แบบเดียวกับ water / steps / food — ไม่มี Server Time / Session Database / network (ใช้แทน "Server Time", "ICT", "Local Storage / Session Database" ใน ux-flow §3–4, game-rules §1, §4, requirements AC-5) | dashboard ไม่มีรอบวันของตัวเอง: อ่านค่าจาก `WaterController` / `StepsController` / `FoodController` ที่ตัดรอบ 05:00 อยู่แล้ว · ไม่มี UI ออฟไลน์ / sync / loading จาก server · สถานะ "ข้ามช่วงเวลา" = ค่าจาก 3 controller กลับเป็นค่าวันใหม่ แล้วหน้าจอวาดใหม่ (§3) |
| D-3 | **คะแนน 0–100 — DECIDED (owner ชั่วคราว, รอ Design ยืนยัน — Dev ใส่ในไฟล์ rules พร้อม `// ASSUMPTION`):** `waterScore`, `stepsScore` = `round(min(actual / target, 1) × 100)` · `foodScore`: ถึงเป้า (kcal ≤ target) = `(kcal / target) × 100`; เกินเป้า = `max(0, 100 − (ส่วนที่เกิน / target × 100))`; ไม่มีเป้า (ข้ามโปรไฟล์) = **ไม่คิดคะแนน** | แถบทั้ง 3 และคะแนนรวมแสดงจำนวนเต็ม 0–100 · แถบอาหารมีสถานะพิเศษ "ไม่คิดคะแนน" (§3 S-1, Q-1) · ตัวเลขทั้งหมดคำนวณใน logic ของ dashboard (เช่น `DashboardLogic`) — หน้าจอแสดงผลเท่านั้น |
| D-4 | **Priority 4 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน):** "คะแนนอาหารต่ำกว่าเกณฑ์" = `foodScore < 50` | ไม่มีผลต่อหน้าตาโดยตรง — กำหนดว่าข้อความ 「ฉันหิว」 อยู่ในคิวเมื่อไร (§3, Q-3) |
| D-5 | (ระดับแอป — ไม่ใช่ข้อตัดสินใหม่) หน้า home ปัจจุบันคือ `WaterHomeScreen` (`app/lib/main.dart` → `_home`, signup ui-spec D-2) และ steps / food เข้าทาง `IconButton` ใน `AppBar.actions` ของ water (`steps_entry_button`, `food_entry_button`) | ux-flow §3 ข้อ 1 บอกว่าเปิดแอปแล้วเข้า S-1 แต่ไม่มีหน้าจอ/ทางเข้าที่กำหนดในแอปปัจจุบัน — spec ใช้ pattern เดียวกับ steps/food (ปุ่มไอคอนใน AppBar ของ water) ไม่เปลี่ยนหน้า home ไม่เพิ่มหน้าจอ ดู §2.0, Q-7 |

## 1. Design tokens

ทุกสีของ component ให้ดึงจาก `Theme.of(context).colorScheme` / `textTheme` เท่านั้น ห้าม hardcode hex ในหน้าจอ dashboard (dashboard ไม่วาดสัตว์เลี้ยงเอง สีตัวสัตว์เลี้ยงอยู่ใน `PetColors` ของ `app/lib/shared/pet/pet_constants.dart` — ห้ามแก้)

### 1.1 สี

| Token | ค่า | ใช้ที่ไหน | ที่มา |
|---|---|---|---|
| Seed color | `Colors.lightBlue` | ทุก ColorScheme | `app/lib/main.dart` → `ColorScheme.fromSeed(seedColor: Colors.lightBlue)` |
| Total Score Card — พื้น / ตัวอักษร | `colorScheme.primaryContainer` / `colorScheme.onPrimaryContainer` | S-1 #1 | role เดิมใน ColorScheme — **การใช้ role ใหม่** เหตุผล: คะแนนรวมเป็นตัวเลขหลักของหน้า ต้องแยกจากฟองข้อความ (`secondaryContainer`) และแถบรายหมวด (`primary`) โดยไม่ตั้ง hex ใหม่; ยังเป็นโทนเดียวกับ seed |
| ฟองข้อความแจ้งเตือน (Dynamic Alert Banner) — พื้น / ตัวอักษร | `colorScheme.secondaryContainer` / `colorScheme.onSecondaryContainer` | S-1 #3 | ของเดิม: `steps_status_badge`, `food_profile_cta_banner` |
| แถบความคืบหน้า — ปกติ | `colorScheme.primary` (default ของ `LinearProgressIndicator`) track default | S-1 แถบ Food / Steps / Water | ของเดิม: `water_energy_bar`, `steps_energy_bar`, `food_energy_bar` |
| แถบอาหาร — Priority 1 ("หลอดสีแดง") | `colorScheme.error` ส่งเข้า `LinearProgressIndicator.color` (track คง default) | S-1 แถบ Food เมื่อเข้าเงื่อนไข Priority 1 | ของเดิม: `food_energy_bar` ตอนเกินเป้าหมาย (food ui-spec §1.1) — เงื่อนไขเดียวกับ `FoodController.isOverLimit` |
| ข้อความ "ไม่คิดคะแนน" ของแถบอาหาร | `colorScheme.onSurfaceVariant` | S-1 แถบ Food เมื่อไม่มีเป้า (Q-1) | role เดิม (signup ใช้กับข้อความรอง, steps ใช้กับไอคอนออฟไลน์) |

ไม่มีสถานะ disabled บน S-1 (ไม่มีปุ่ม/ช่องกรอก — ux-flow §2)

### 1.2 ตัวอักษร

ไม่มี custom font ใน `app/pubspec.yaml` → ฟอนต์ default ของ Material ใช้ `Theme.of(context).textTheme` เท่านั้น

| ใช้กับ | style | ที่มา |
|---|---|---|
| หัวข้อหน้าจอ (AppBar title) | default ของ `AppBar` | water / steps / food ทุกหน้า |
| Total Score Card `คะแนนสุขภาพรวม: [Integer]%` | `textTheme.headlineSmall` + `onPrimaryContainer` | `water_count_text`, `steps_count_text`, `food_calorie_text` |
| ฟองข้อความแจ้งเตือน | `textTheme.bodyMedium` + `onSecondaryContainer` | `food_cta_text`, `steps_percent_text` |
| ป้ายแถบรายหมวด `คะแนน…: [Integer]%` | default (`bodyMedium`) | `water_energy_text`, `steps_percent_text` |

### 1.3 ระยะห่าง ขนาด มุมโค้ง เวลา

| Token | ค่า | ที่มา |
|---|---|---|
| Padding หน้าหลัก (S-1) | 24 รอบด้าน | `water_home_screen.dart`, `steps_dashboard_screen.dart`, `food_dashboard_screen.dart` → `EdgeInsets.all(24)` |
| ช่องไฟ | 8 / 16 / 24 (`SizedBox`) | `water_home_screen.dart` |
| ระยะฟองข้อความ ↔ ขอบบนกล่องสัตว์เลี้ยง | 12 | ค่าเดียวกับ `FoodRules.toastAnchorOffset` (ข้อความลอยเหนือสัตว์เลี้ยงของ food) — ให้ dashboard มีค่าคงที่ของตัวเอง (เช่น `DashboardRules.alertAnchorOffset = 12`) ห้าม import ค่าจาก food |
| Padding ในกล่อง (Total Score Card, ฟองข้อความ) | แนวนอน 16 แนวตั้ง 8 | ป้าย `steps_status_badge`, `food_full_badge`, `food_toast` |
| มุมโค้งกล่อง / แถบ | `BorderRadius.circular(8)` | `water_energy_bar` (`ClipRRect`), `steps_status_badge`, `food_profile_cta_banner` |
| ขนาดสัตว์เลี้ยง | **200 × 200** | **ใหม่** — เหตุผล: ux-flow/game-rules ให้ fallback 300×300 (สำหรับ PNG ซึ่งถูกแทนด้วย D-1) และ art แนะนำ 300 แต่จอ 360×640 dp มีพื้นที่ body ราว 560 dp: ที่ 300 หน้าต้องเลื่อนราว 80 dp ทำให้แถบ 3 หมวด (AC-4) ตกขอบจอ · ที่ 200 ทุกองค์ประกอบอยู่ในจอเดียวที่ textScaler 1.0 (รวม ≈ 540 dp — §2.1) และยังใหญ่กว่า 160 ของหน้าอื่น เพราะสัตว์เลี้ยงเป็นจุดเด่นของหน้ารวม · `PetCharacter` เป็นเวกเตอร์ คมทุกขนาด (character.md §7) — ค่าอยู่ใน `DashboardRules.petSize` (ดู Q-9) |
| ความสูงแถบรายหมวด | `minHeight: 12` | **ใหม่** — เหตุผล: หน้าอื่นมีหลอดพลังงานเดียว (`minHeight: 20`) ที่เป็นตัวหลักของหน้า แต่ S-1 มี 3 แถบซ้อนกันและตัวหลักคือคะแนนรวม + สัตว์เลี้ยง จึงลดความหนาให้ลำดับความสำคัญถูก และให้ทั้งหน้าพอดีจอ 360×640 (ประหยัด 24 dp) · มุมโค้ง 8 เท่าเดิม |
| ระยะเวลาหมุนข้อความ | อ่านจาก `alertInterval` (game-rules §1 = 5 วินาที) เป็นค่าคงที่ใน rules ของ dashboard — ห้าม hardcode ในหน้าจอ | game-rules §1 |
| Loading ทั้งหน้า | `Center(CircularProgressIndicator())` | water / steps / food ตอน `!isLoaded` |

## 2. หน้าจอ

ux-flow มีหน้าจอเดียว: **S-1 หน้าจอแดชบอร์ดหลัก (Dashboard Main Screen)** — spec ไม่เพิ่มหน้าจออื่น
ข้อความใน「」คัดลอกตรงตัวจาก ux-flow.md / game-rules.md — ห้ามแก้ · เครื่องหมาย `"` ที่ครอบข้อความแจ้งเตือนในเอกสารเป็นตัวคั่น string ไม่ใช่ส่วนของข้อความบนจอ (แบบเดียวกับ 「พอเถอะน้าคนดี」 ของ food — Q-21) · ข้อความที่ ux-flow ไม่มีและ spec เสนอไว้ชั่วคราว ระบุว่า **(เสนอ — รอยืนยัน)**
ข้อความบนจอทุกข้อความ และค่าตัวเลข (`alertInterval`, เกณฑ์อารมณ์ 30 / 60 / 80, เกณฑ์ Priority 4 = 50, ขนาดสัตว์เลี้ยง, ระยะ anchor) ต้องอ่านจากค่าคงที่ชุดเดียว (เช่น `DashboardRules`) แบบ `StepsRules` / `FoodRules` — ห้าม hardcode ในหน้าจอ
ValueKey ใช้ prefix `dashboard_` ทั้งหมด
ตัวเลข `[Integer]` ทุกจุดเป็นจำนวนเต็ม 0–100 ไม่มีทศนิยม ไม่มีช่องว่างก่อน `%` (เช่น `70%`)

### 2.0 ทางเข้า S-1 จากหน้า water (D-5)

- ตำแหน่ง: `AppBar.actions` ของ `WaterHomeScreen` วาง**ต่อจาก** `food_entry_button` และก่อน `water_monthly_report_button` (ไม่ย้ายปุ่มเดิม)
- Widget: `IconButton` แบบเดียวกับ `steps_entry_button` / `food_entry_button` — `Icon(Icons.dashboard, size: 24)`, `tooltip:` 「แดชบอร์ด」 **(เสนอ — รอยืนยัน, Q-8)**
- กดแล้ว `Navigator.push(MaterialPageRoute(...))` ไป S-1 (แบบ `_openSteps` / `_openFood`)
- ข้อมูล: S-1 ต้องรับ **controller ตัวเดียวกัน** กับที่หน้า water ใช้อยู่ — `widget.controller` (water), `widget.stepsController ?? _ownedStepsController`, `widget.foodController ?? _ownedFoodController` (สร้างแบบเดียวกับ `_openSteps` / `_openFood` ถ้ายังไม่มี) เพื่อให้แถบอัปเดตตามการบันทึกจริง และเปิดหน้า steps/food ภายหลังแล้วเห็นข้อมูลชุดเดียวกัน
- ValueKey: `dashboard_entry_button`
- ความกว้าง AppBar บนจอ 360 dp: ปุ่มไอคอน 3 ปุ่ม (48 × 3) + `water_monthly_report_button` ยังไม่ล้น — ชื่อ 「PetPal Health」 ตัด ellipsis ตาม default ของ AppBar ได้ · ห้ามมี RenderFlex overflow
- ห้ามแก้ส่วนอื่นของ `WaterHomeScreen`

### 2.1 S-1 หน้าจอแดชบอร์ดหลัก (Dashboard Main Screen)

จุดประสงค์ (ux-flow §1): แสดงคะแนนสุขภาพรวม, อารมณ์สัตว์เลี้ยงเสมือนจริง, ข้อความแนะนำวนลูป และแถบความคืบหน้าแยกตามหมวดหมู่ (อาหาร, การก้าวเดิน, การดื่มน้ำ)

โครง: `Scaffold` → `AppBar` → body `ListenableBuilder(listenable: Listenable.merge([water, steps, food]))` (pattern water/steps/food — อัปเดตทันทีเมื่อค่าใดเปลี่ยน, ux-flow §2 "อัปเดตแบบเรียลไทม์") → ถ้า controller ใดยัง `!isLoaded` = `Center(CircularProgressIndicator())` → `SafeArea` → `LayoutBuilder` + `SingleChildScrollView` + `ConstrainedBox(minHeight: constraints.maxHeight)` + `IntrinsicHeight` (pattern `steps_dashboard_screen.dart` / `food_dashboard_screen.dart` เพื่อคง `Spacer` และไม่ overflow เมื่อจอเตี้ยหรือ textScaler สูง) → `Padding(24)` → `Column(crossAxisAlignment: stretch)`
ไม่มีภาพพื้นหลัง — พื้น `colorScheme.surface` ตาม default

จากบนลงล่าง:

| # | องค์ประกอบ (ux-flow §2) | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 0 | หัวข้อหน้าจอ | `AppBar(title: Text(...))` — มีปุ่มย้อนกลับอัตโนมัติเพราะถูก push จาก water | 「แดชบอร์ด」 **(เสนอ — รอยืนยัน, Q-8)** | AppBar default | `dashboard_header_text` (บน `Text`) |
| 1 | Total Score Card | `Container(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: primaryContainer, borderRadius: BorderRadius.circular(8)))` เต็มความกว้าง → `Text(textAlign: center)` | `'คะแนนสุขภาพรวม: <totalScore>%'` ตามรูปแบบ `คะแนนสุขภาพรวม: [Integer]%` เช่น `คะแนนสุขภาพรวม: 70%` | `headlineSmall` + `onPrimaryContainer` | `dashboard_total_score_card` (บน `Container`), `dashboard_total_score_text` (บน `Text`) |
| 2 | `Spacer()` | | | | |
| 3 | Dynamic Alert Banner (ช่อง + ฟองข้อความ) | ช่องจองที่ `dashboard_alert_slot` → ฟองข้อความ ดู §2.1.1 | ข้อความ 1 จาก 4 ตาม game-rules §1.1 | §1.1, §1.2 | `dashboard_alert_slot`, `dashboard_alert_banner`, `dashboard_alert_text` |
| 4 | ระยะ anchor | `SizedBox(height: DashboardRules.alertAnchorOffset)` (= 12) | | §1.3 | - |
| 5 | Pet Character Display | `Center` → `KeyedSubtree(key: ValueKey('dashboard_pet_image_<mood>'))` → `PetCharacter(key: _petKey /* GlobalKey(debugLabel: 'dashboard_pet') */, pose: ..., size: DashboardRules.petSize /* 200 */, animate: widget.animatePet ?? kPetAnimateByDefault, semanticLabel: <ชื่อไทยของอารมณ์>)` — **ไม่ส่ง `cheerTrigger`** | ท่าตามอารมณ์ §4 · `semanticLabel` = 「ร้องไห้」 / 「เหม่อลอย」 / 「ออรุ่มเจ๊าะ」 / 「ยิ้มร่าเริง」 (ชื่อในวงเล็บของ game-rules §2 — ไม่แสดงบนจอ) | 200 × 200 | `dashboard_pet_image_<crying\|dazed\|bubbly\|cheerful>` บน `KeyedSubtree` |
| 6 | `SizedBox(height: 24)` | | | | |
| 7 | Food Progress Bar | แถวแถบ §2.1.2 | ป้าย `'คะแนนอาหาร: <foodScore>%'` ตามรูปแบบ `คะแนนอาหาร: [Integer]%` · สีแดงเมื่อเข้าเงื่อนไข Priority 1 · ไม่มีเป้า ดู §3 (Q-1) | §2.1.2 | `dashboard_food_row`, `dashboard_food_label_text`, `dashboard_food_bar` |
| 8 | `SizedBox(height: 16)` | | | | |
| 9 | Steps Progress Bar | แถวแถบ §2.1.2 | `'คะแนนการก้าวเดิน: <stepsScore>%'` ตามรูปแบบ `คะแนนการก้าวเดิน: [Integer]%` | §2.1.2 | `dashboard_steps_row`, `dashboard_steps_label_text`, `dashboard_steps_bar` |
| 10 | `SizedBox(height: 16)` | | | | |
| 11 | Water Progress Bar | แถวแถบ §2.1.2 | `'คะแนนการดื่มน้ำ: <waterScore>%'` ตามรูปแบบ `คะแนนการดื่มน้ำ: [Integer]%` | §2.1.2 | `dashboard_water_row`, `dashboard_water_label_text`, `dashboard_water_bar` |
| 12 | `Spacer()` | | | | |

- ลำดับแถบ Food → Steps → Water ตามตาราง ux-flow §2
- ไม่มีปุ่ม ไม่มีช่องกรอก ไม่มีทางไปหน้าอื่นจาก S-1 นอกจากปุ่มย้อนกลับของ AppBar (ux-flow ไม่มี) — แถบไม่กดได้
- งบความสูงที่จอ 360×640 dp, textScaler 1.0 (body ≈ 560): 24 + การ์ด 48 + ช่องข้อความ 56 + 12 + สัตว์เลี้ยง 200 + 24 + แถบ 3 × 40 + 16 × 2 + 24 ≈ 540 → ไม่ต้องเลื่อน · จอเตี้ยกว่า/ตัวอักษรใหญ่กว่า = เลื่อนได้ ไม่ overflow
- เมื่อค่าเปลี่ยน: ตัวเลข สีแถบ ความยาวแถบ และท่าสัตว์เลี้ยงเปลี่ยนในเฟรมถัดไปพร้อมกัน (ไม่มี animation ของแถบหรือตัวเลข)

#### 2.1.1 Dynamic Alert Banner (ฟองข้อความเหนือหัวสัตว์เลี้ยง — component ใหม่)

- ข้อความ 4 ลำดับ (คัดลอกตรงตัวจาก ux-flow §2 / game-rules §1.1 ไม่รวม `"` ที่เป็นตัวคั่น — Q-21):
  1. 「แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว」
  2. 「ดื่มน้ำๆ」
  3. 「ขยับร่างกายหน่อย อีกนิดๆ」
  4. 「ฉันหิว」
- ฟองข้อความ: `Container(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: secondaryContainer, borderRadius: BorderRadius.circular(8)))` เต็มความกว้าง → `Text(message, textAlign: center, style: bodyMedium + onSecondaryContainer)` — **ไม่มี `maxLines` / ellipsis** (ข้อความต้องแสดงครบตรงตัว) ไม่มีหางชี้ ไม่มีไอคอน · สีเดียวกันทุก Priority
- ช่องจองที่ `dashboard_alert_slot` (กันสัตว์เลี้ยงขยับเมื่อข้อความยาว/สั้นสลับกันหรือฟองหาย): `Stack` ที่มี
  - ลูกตัวแรก (กำหนดขนาด): ฟองข้อความของข้อความที่ยาวที่สุด (Priority 1) ห่อด้วย `Visibility(visible: false, maintainSize: true, maintainAnimation: true, maintainState: true)` — ช่องจึงสูงเท่าข้อความ Priority 1 ที่ความกว้าง/textScaler จริงเสมอ (≈ 56 dp = 2 บรรทัดที่จอ 360 dp)
  - ลูกตัวที่สอง (เมื่อคิวไม่ว่าง): `Positioned.fill` → ฟองข้อความจริง key `dashboard_alert_banner` ข้อความ key `dashboard_alert_text` จัดกลางแนวตั้ง
  - ห้ามล็อกความสูงคงที่ (บทเรียน food D-5)
- ตำแหน่ง: ขอบล่างของช่องห่างขอบบนสุดของกล่อง `PetCharacter` (กล่อง 200×200 — `PetKeys.character`) เท่ากับ `alertAnchorOffset` = 12 เสมอ (เหนือหัวสัตว์เลี้ยง — brief §3, ดู Q-18)
- การหมุนเวียน / ตัดออกจากคิว: พฤติกรรมตาม game-rules §1.1 + หมายเหตุ Dynamic Queue + §4 (ไม่เขียนซ้ำ) — หน้าตา: เปลี่ยนข้อความในฟองเดิม **ทันที** ไม่มี animation (ถ้าจะใส่ fade ต้องไม่เปลี่ยนขนาด/ตำแหน่งช่อง) · ฟองแสดงทีละ 1 ข้อความเสมอ ไม่มีตัวบอกลำดับ/จำนวน
- คิวว่าง: ไม่มี `dashboard_alert_banner` ใน tree แต่ `dashboard_alert_slot` ยังจองที่เท่าเดิม (§3, Q-10)
- ห้ามใช้ `SnackBar` / `ScaffoldMessenger` / `Tooltip` / dialog สำหรับข้อความนี้

#### 2.1.2 แถวแถบรายหมวด (Food / Steps / Water — ใช้ร่วมกัน 3 แถว)

- `Column(crossAxisAlignment: stretch)` key `dashboard_<food|steps|water>_row` →
  - `Text(textAlign: TextAlign.start)` key `dashboard_<…>_label_text` — style default (`bodyMedium`)
  - `SizedBox(height: 8)`
  - `ClipRRect(borderRadius: BorderRadius.circular(8))` → `LinearProgressIndicator(key: dashboard_<…>_bar, value: score / 100, minHeight: 12, color: <primary หรือ error>)`
- `value` = คะแนนจำนวนเต็มของหมวด ÷ 100 (คะแนนอยู่ใน 0–100 อยู่แล้วตาม D-3 — ยัง clamp 0.0–1.0 กันพลาด) → ความยาวแถบตรงกับตัวเลขในป้ายเสมอ
- สี: `primary` ทุกแถบ ยกเว้นแถบอาหารเมื่อเข้าเงื่อนไข Priority 1 (game-rules §1.1 — ใช้ `FoodController.isOverLimit` ตัวเดียวกับหลอดแดงของ food) = `colorScheme.error`
- ไม่มีไอคอน ไม่มีตัวเลขดิบ (แก้ว / ก้าว / kcal) — ux-flow แสดงเฉพาะ % (Q-11)

## 3. สถานะของแต่ละหน้าจอ

### S-1

อารมณ์สัตว์เลี้ยงมาจาก `totalScore` (จำนวนเต็มหลังปัดและ cap) ตามช่วง game-rules §2 — ไม่เขียนเงื่อนไขซ้ำ · ข้อความในคิวตาม game-rules §1.1 + D-4

| สถานะ | เงื่อนไข (อ้างถึง) | หน้าตา |
|---|---|---|
| กำลังโหลด | `WaterController` / `StepsController` / `FoodController` ตัวใดยัง `!isLoaded` (โหลดจากเครื่อง — D-2) | `Center(CircularProgressIndicator())` แทน body ทั้งหมด (pattern water/steps/food) — ไม่มีข้อความ |
| ปกติ (Normal State) | ux-flow §4 | ตาม §2.1 ครบ: การ์ด `คะแนนสุขภาพรวม: <n>%`, สัตว์เลี้ยงท่าตามอารมณ์ (§4), ฟองข้อความแสดงข้อความในคิว, 3 แถบสี `primary` พร้อมป้าย % · ตัวอย่าง game-rules §3: Food 60 / Steps 90 / Water 60 → `คะแนนสุขภาพรวม: 70%`, `dashboard_pet_image_bubbly`, แถบ `คะแนนอาหาร: 60%` / `คะแนนการก้าวเดิน: 90%` / `คะแนนการดื่มน้ำ: 60%`, ฟองหมุน 「ดื่มน้ำๆ」 → 「ขยับร่างกายหน่อย อีกนิดๆ」 (P4 ไม่อยู่ในคิวเพราะ 60 ≥ 50 และมีมื้ออาหาร) |
| ว่าง / ข้อมูลไม่สมบูรณ์ (Empty/Fallback State) | ux-flow §4, EC-4 — คะแนนหมวดใดติดลบ/ว่าง → 0 | layout เดิม ไม่มีข้อความพิเศษ ไม่มี error · แถบหมวดนั้น `value` 0.0 ป้าย `คะแนน…: 0%` · วันใหม่ทั้งหมดเป็น 0: `คะแนนสุขภาพรวม: 0%`, ท่า `dashboardCrying` key `dashboard_pet_image_crying`, ฟองหมุน P2 → P3 → P4 (「ดื่มน้ำๆ」, 「ขยับร่างกายหน่อย อีกนิดๆ」, 「ฉันหิว」) |
| อาหารไม่คิดคะแนน (ไม่มีเป้า — ข้ามโปรไฟล์) — D-3 | `FoodController.hasTarget == false` | แถบอาหาร: ป้าย 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 **(เสนอ — รอยืนยัน, Q-1)** สี `onSurfaceVariant` key เดิม `dashboard_food_label_text` · แถบ `value` 0.0 สี `primary` (เห็นแค่ track) · **ไม่มี** ตัวเลข % ของอาหาร · คะแนนรวมคิดจาก Steps + Water (Q-1) · ไม่เข้า Priority 1 (Q-2) · Priority 4 ขึ้นเฉพาะเมื่อยังไม่บันทึกมื้อใด (Q-3) · ไม่มี CTA ไปตั้งโปรไฟล์บนหน้านี้ (ux-flow ไม่มี) |
| อาหารเกินเป้าหมาย (Priority 1) | game-rules §1.1 Priority 1 (Overeating > 100 kcal = `FoodController.isOverLimit`) | แถบอาหาร `color: colorScheme.error` · `value` = `foodScore` ÷ 100 (ลดลงตามสูตรเกินเป้า D-3 — ไม่ใช่แถบเต็ม, Q-5) ป้ายแสดงคะแนนจริง เช่น `คะแนนอาหาร: 93%` · ฟองข้อความแสดง 「แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว」 เป็นลำดับแรกของคิว · สีแดงขึ้น/หายในเฟรมเดียวกับที่ `isOverLimit` เปลี่ยน · เกินเป้าไม่ถึง 100 kcal = แถบสี `primary` (แบบ food AC-9) |
| คิวข้อความว่าง | ไม่มีเงื่อนไข Priority ใดเป็นจริง (เช่น น้ำ 100, ก้าว 100, มีมื้ออาหาร, foodScore ≥ 50, ไม่เกินเป้า) | ไม่มี `dashboard_alert_banner` / `dashboard_alert_text` ใน tree · `dashboard_alert_slot` ยังจองที่ (สัตว์เลี้ยงไม่ขยับ) — brief §6 ข้อ 3 (Q-10) |
| แก้ปัญหาสำเร็จขณะข้อความกำลังแสดง | game-rules §4 แถว 2, AC-3, EC-2 | ข้อความในฟองเปลี่ยนเป็นข้อความถัดไปในคิว**ในเฟรมเดียวกับ**ที่คะแนน/สีแถบเปลี่ยน (ไม่รอ 5 วินาที) · ถ้าไม่มีข้อความเหลือ → สถานะคิวว่าง |
| ผิดพลาด / ข้ามช่วงเวลา (Error / Time Crossing State) | ux-flow §4, game-rules §4 แถว 3 — ใช้เวลาเครื่อง 05:00 (D-2) | ไม่มี dialog / SnackBar / ข้อความผิดพลาด · เมื่อ controller ทั้ง 3 ตัดรอบ หน้าจอวาดใหม่ทันทีเป็นค่าวันใหม่ = หน้าตาเดียวกับแถว "ว่าง" (0%, ท่า crying, ฟองเริ่มจากข้อความลำดับแรกของคิวใหม่) · S-1 ต้องเรียก `refreshDailyReset()` (water) / `refreshDay()` (steps, food) เป็นระยะขณะเปิดค้าง และเมื่อแอป resume — แบบ `_dayCheckInterval` 1 วินาทีของ steps/food |

ไม่มีสถานะ disabled (ไม่มี control ที่กดได้นอกจากตัวสัตว์เลี้ยง)

## 4. ภาพสัตว์เลี้ยงแต่ละสถานะ

ใช้ `PetCharacter` ตัวเดียวจาก `app/lib/shared/pet/` (`import 'package:petpal_health/shared/pet/pet.dart'`) — **ไม่ใช้ไฟล์ภาพตาม ux-flow §5 / game-rules §2** (D-1) · ชื่อ preset ตรวจแล้วกับ `app/lib/shared/pet/pet_pose.dart` (บรรทัด 143–159) และ `docs/_design/character.md` §4–7

| อารมณ์ (game-rules §2) | ช่วง totalScore | Preset | สีหน้า / รูปร่าง | ท่าทางที่เห็น (character.md §4–5) | ขยับ (`animate: true`) | ขนาด | key บน `KeyedSubtree` | preview |
|---|---|---|---|---|---|---|---|---|
| `CRYING` (ร้องไห้) | `[0, 30]` | `PetPose.dashboardCrying` (ใหม่) | `crying` / `normal` | ตาปิดแน่นเอียงเศร้า คิ้วกังวล สายน้ำตาฟ้าสองข้าง + หยดน้ำตา ปากร้องไห้อ้ากว้าง ใบไม้ห้อย แขนห้อย ตัวสีปกติ (ไม่ซีด ไม่มีเหงื่อ) | หายใจ (`breath` 2400 ms) หยดน้ำตาหล่นตามลมหายใจ | 200 × 200 | `dashboard_pet_image_crying` | `docs/_design/preview/dashboard_crying.png` |
| `DAZED` (เหม่อลอย) | `(30, 60]` | `PetPose.dashboardDazed` (ใหม่) | `dazed` / `normal` | ตาดำจุดเล็กมองตรงว่างเปล่า หนังตาตกเท่ากันสองข้าง ปาก "o" ฟองน้ำลาย จุด "..." ลอยขวาบน | หายใจ — "..." ลอยขึ้นลง ใบไม้แกว่งช้า | 200 × 200 | `dashboard_pet_image_dazed` | `dashboard_dazed.png` |
| `BUBBLY` (ออรุ่มเจ๊าะ) | `(60, 80]` | `PetPose.dashboardBubbly` (reuse `happy` — `== PetPose.waterHappy`) | `happy` / `normal` | ตาโตเป็นประกาย (ตาขวาตกข้างเดียว) ยิ้มอ้ารูป D แก้มชมพู ประกาย 2 ดวง ฟองน้ำลาย แขนวางพุง | หายใจ + กะพริบ | 200 × 200 | `dashboard_pet_image_bubbly` | `dashboard_bubbly.png` |
| `CHEERFUL` (ยิ้มร่าเริง) | `(80, 100]` | `PetPose.dashboardCheerful` (ใหม่) | `cheerful` / `normal` | ตา ^ ^ ยิ้มอ้ากว้าง ชูแขนสองข้าง ประกาย 5 ดวง ใบไม้โบก | **กระโดดต่อเนื่อง** `PetTiming.hop` 760 ms/ครั้ง (`hopHeight` 0.05) | 200 × 200 | `dashboard_pet_image_cheerful` | `dashboard_cheerful.png` |

ภาพรวม 4 ท่าที่ 160 px: `docs/_design/preview/dashboard_states_160.png` · ลูป: `docs/_design/preview/fx_dashboard_loops.png`

กติกาการใช้ widget (character.md §6–7):
- `PetCharacter(key: _petKey)` — `_petKey = GlobalKey(debugLabel: 'dashboard_pet')` สร้างครั้งเดียวใน State ของ S-1; key ฟีเจอร์ `dashboard_pet_image_<mood>` อยู่บน `KeyedSubtree` ที่ห่อไว้เท่านั้น (กัน BUG-PET-1)
- map ใน logic ของ dashboard (เช่น `DashboardLogic.poseFor(mood)`) ตามตัวอย่าง character.md §7 — หน้าจอไม่ switch เอง
- **ไม่ส่ง `cheerTrigger`** — S-1 ไม่มีการบันทึก (art แนะนำ) และ CHEERFUL กระโดดวนอยู่แล้ว
- `animate: widget.animatePet ?? kPetAnimateByDefault` (`pet_animation_policy.dart`) — S-1 รับพารามิเตอร์ `animatePet` แบบ water/steps/food
- `reactToTap` คง default (แตะแล้วกระโดดหน้าตลกเหมือนทั้งแอป; ระหว่างแตะ ลูปกระโดดหยุดชั่วคราว)
- เทสต์ที่ `animate: true` (โดยเฉพาะ CHEERFUL) ใช้ `pump(Duration)` เท่านั้น **ห้าม `pumpAndSettle()`** (timeout) · Timer หมุนข้อความ 5 วินาทีและ Timer ตรวจรอบวันต้องถูก cancel ใน `dispose`
- anchor ของฟองข้อความอ้างขอบบนของกล่อง `PetCharacter` (`PetKeys.character`, `SizedBox` size × size)
- ไม่ต้องการท่าใหม่จาก Art — 4 อารมณ์มี preset ครบ (ถ้า Product ต้องการให้ BUBBLY ต่างจาก water happy เป็นงาน Art — character.md §9 ข้อ 9)

## 5. Checklist สำหรับ reviewer

- [ ] ไม่มี hex สีในโค้ด dashboard — สีทั้งหมดมาจาก `Theme.of(context).colorScheme` (seed `Colors.lightBlue` ใน `main.dart`)
- [ ] ไม่แก้ `ThemeData` ใน `app/lib/main.dart`, ไม่เพิ่ม font / package / asset ใน pubspec
- [ ] ไม่มีการโหลด PNG หรือไฟล์ภาพใด ๆ เป็นสัตว์เลี้ยง และไม่แก้ไฟล์ใน `app/lib/shared/pet/`
- [ ] ข้อความบนจอทุกข้อความ ตัวเลขเกณฑ์ (30/60/80, 50), `alertInterval` 5 วินาที, ขนาดสัตว์เลี้ยง 200 และระยะ anchor 12 อ่านจากค่าคงที่ของ dashboard (เช่น `DashboardRules`) ไม่ hardcode ในหน้าจอ; สูตรคะแนน D-3 / เกณฑ์ D-4 มีคอมเมนต์ `// ASSUMPTION`
- [ ] มีปุ่ม `dashboard_entry_button` (`IconButton`, `Icons.dashboard` 24, tooltip 「แดชบอร์ด」) ใน AppBar ของ `WaterHomeScreen` ถัดจาก `food_entry_button` ก่อน `water_monthly_report_button` และกดแล้วไป S-1
- [ ] S-1 ใช้ `WaterController` / `StepsController` / `FoodController` ตัวเดียวกับที่หน้า water ส่งให้ steps/food (บันทึกน้ำแล้วกลับมา S-1 เห็นแถบน้ำเปลี่ยน)
- [ ] AppBar title 「แดชบอร์ด」 key `dashboard_header_text` และมีปุ่มย้อนกลับอัตโนมัติ
- [ ] S-1 padding 24, ช่องไฟ 8/16/24 ตาม §2.1, ใช้ pattern `SingleChildScrollView` + `IntrinsicHeight` + `Spacer`
- [ ] ไม่มี RenderFlex overflow บนจอ 360×640 dp ทั้ง textScaler 1.0 และ 1.5 (รวม AppBar ของ water ที่มี 3 ปุ่มไอคอน)
- [ ] ลำดับจากบนลงล่าง: Total Score Card → ฟองข้อความ → สัตว์เลี้ยง → แถบ Food → Steps → Water
- [ ] Total Score Card key `dashboard_total_score_card` พื้น `primaryContainer` มุม 8 padding 16/8; ข้อความ key `dashboard_total_score_text` = `คะแนนสุขภาพรวม: <n>%` `headlineSmall` สี `onPrimaryContainer`; n เป็นจำนวนเต็ม 0–100
- [ ] ตัวอย่าง game-rules §3: (60, 90, 60) → `คะแนนสุขภาพรวม: 70%` + `dashboard_pet_image_bubbly`; (70, 60, 67) → `66%`; Food −10 → `คะแนนอาหาร: 0%` และ `60%` + `dashboard_pet_image_dazed`; คะแนนดิบเกิน → แสดงไม่เกิน `100%` + `dashboard_pet_image_cheerful`
- [ ] สัตว์เลี้ยงเป็น `PetCharacter` `size: 200` ถือ `GlobalKey` คงที่ และห่อด้วย `KeyedSubtree` key `dashboard_pet_image_<crying|dazed|bubbly|cheerful>`
- [ ] map อารมณ์ → `painter.pose`: CRYING=`PetPose.dashboardCrying`, DAZED=`PetPose.dashboardDazed`, BUBBLY=`PetPose.dashboardBubbly`, CHEERFUL=`PetPose.dashboardCheerful` (ตรวจขอบ 30→crying, 31→dazed, 60→dazed, 61→bubbly, 80→bubbly, 81→cheerful)
- [ ] `PetCharacter` ของ dashboard ไม่มี `cheerTrigger`; `animate` = `widget.animatePet ?? kPetAnimateByDefault`
- [ ] เปลี่ยนอารมณ์แล้ว State ของ `PetCharacter` เดิมถูกใช้ต่อ (GlobalKey) ไม่ถูกสร้างใหม่
- [ ] ฟองข้อความ key `dashboard_alert_banner` พื้น `secondaryContainer` มุม 8 padding 16/8; ข้อความ key `dashboard_alert_text` `bodyMedium` สี `onSecondaryContainer` จัดกลาง ไม่มี `maxLines`/ellipsis
- [ ] ข้อความในฟองตรงตัวทุกอักษรกับ game-rules §1.1 (ไม่รวม `"` ตัวคั่น): 「แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว」 「ดื่มน้ำๆ」 「ขยับร่างกายหน่อย อีกนิดๆ」 「ฉันหิว」
- [ ] ฟองข้อความไม่ใช่ `SnackBar` / dialog และแสดงทีละ 1 ข้อความ (`find.byKey(dashboard_alert_banner)` เจอไม่เกิน 1)
- [ ] ความสูง `dashboard_alert_slot` เท่ากันทุกข้อความและตอนคิวว่าง (`tester.getSize` ไม่เปลี่ยน; `getTopLeft(PetKeys.character)` ไม่ขยับเมื่อข้อความหมุน)
- [ ] ขอบล่างของ `dashboard_alert_slot` อยู่สูงกว่าขอบบนของ `PetKeys.character` 12 px พอดี
- [ ] หลัง `pump(5 วินาที)` ข้อความในฟองเปลี่ยนเป็นข้อความถัดไปในคิว; แก้ปัญหาของข้อความที่แสดงอยู่ (เช่น บันทึกน้ำจนครบ) → ข้อความเปลี่ยนในเฟรมถัดไปโดยไม่รอ 5 วินาที
- [ ] คิวว่าง → ไม่มี `dashboard_alert_banner` ใน tree แต่ `dashboard_alert_slot` ยังอยู่และสูงเท่าเดิม
- [ ] 3 แถบ key `dashboard_food_bar` / `dashboard_steps_bar` / `dashboard_water_bar` เป็น `LinearProgressIndicator` `minHeight: 12` ใน `ClipRRect` มุม 8; `value` = คะแนน ÷ 100 (ไม่เกิน 1.0)
- [ ] ป้ายแถบ key `dashboard_<food|steps|water>_label_text` = `คะแนนอาหาร: <n>%` / `คะแนนการก้าวเดิน: <n>%` / `คะแนนการดื่มน้ำ: <n>%` style `bodyMedium` ชิดซ้าย
- [ ] แถบอาหารสี `colorScheme.error` เมื่อ `FoodController.isOverLimit` เป็นจริง และสี `primary` เมื่อไม่ใช่ (รวมเกินเป้า ≤ 100 kcal)
- [ ] ไม่มีเป้าอาหาร (ข้ามโปรไฟล์) → `dashboard_food_label_text` = 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 สี `onSurfaceVariant`, `dashboard_food_bar` value 0.0, คะแนนรวม = ค่าเฉลี่ยของ Steps + Water (Q-1), ไม่มีข้อความ Priority 1
- [ ] ระหว่างโหลด (controller ใดยัง `!isLoaded`) แสดง `CircularProgressIndicator` อย่างเดียว
- [ ] จำลองเวลาเครื่องข้าม 05:00 ขณะเปิด S-1 → ทุกแถบ `0%`, `คะแนนสุขภาพรวม: 0%`, `dashboard_pet_image_crying` โดยไม่มี dialog/SnackBar; ไม่มีการเรียก network / server time
- [ ] Timer ทั้งหมดของ S-1 ถูก cancel ใน `dispose` (เทสต์ไม่มี pending timer)
- [ ] เทสต์ที่ `animate: true` ใช้ `pump(Duration)` ไม่ใช้ `pumpAndSettle()`
- [ ] ไม่มีหน้าจออื่นนอกจาก S-1 (ทางเข้าเป็นแค่ปุ่มบนหน้า water) และ S-1 ไม่มีปุ่ม/ช่องกรอก/ลิงก์ไปหน้าอื่น

## 6. คำถามที่ค้าง

| # | ประเด็น | ทางที่ spec เลือกไว้ชั่วคราว |
|---|---|---|
| Q-1 | D-3 บอก Food "ไม่มีเป้า = ไม่คิดคะแนน" แต่ไม่บอกว่าคะแนนรวมหาร 2 หรือ 3 และแถบ Food แสดงอะไร · ux-flow มีแค่รูปแบบ `คะแนนอาหาร: [Integer]%` | **คะแนนรวม = `round((Steps + Water) / 2)`** (ตัด Food ออกจากทั้งตัวตั้งและตัวหาร) — เหตุผล: "ไม่คิดคะแนน" ≠ "ได้ 0"; ถ้าหาร 3 ผู้ใช้ที่ข้ามโปรไฟล์ทำได้สูงสุด 67 และไม่มีวันถึง CHEERFUL ทั้งที่ไม่ได้ทำผิด · แถบ Food: ป้าย 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 (เสนอ) สี `onSurfaceVariant`, แถบ value 0 สี `primary` — ไม่แสดง `0%` เพราะจะสื่อผิดว่าได้ 0 · รอ Design ยืนยันทั้งสูตรและข้อความ |
| Q-2 | Priority 1 เมื่อไม่มีเป้า และเงื่อนไขเคลียร์ "ผู้ใช้จัดการปัญหาอาหาร" — ฟีเจอร์ food ไม่มีการลบ/แก้มื้ออาหาร | ไม่มีเป้า → ไม่เข้า Priority 1 (`isOverLimit` เป็น false อยู่แล้ว) · มีเป้าแล้วเกิน → ข้อความ P1 + แถบแดงค้างจนตัดรอบ 05:00 (ไม่มีทาง "จัดการ" ในแอปปัจจุบัน) |
| Q-3 | Priority 4 trigger "ยังไม่บันทึกอาหาร **หรือ** foodScore < 50" แต่ removal "บันทึกอาหารสำเร็จ" — ขัดกันเมื่อบันทึกแล้วแต่คะแนนยัง < 50 · ไม่มีเป้า = ไม่มี foodScore | ประเมินเงื่อนไข trigger แบบสด: อยู่ในคิวเมื่อมื้ออาหารวันนี้ว่าง (`FoodState.meals` ว่าง) **หรือ** (มี foodScore และ `< 50`) — บันทึกแล้วแต่ยัง < 50 ข้อความยังอยู่ · ไม่มีเป้า → ใช้เฉพาะส่วน "ยังไม่บันทึกมื้อใด" · รอ Design ยืนยัน |
| Q-4 | เกณฑ์ Priority 2 / 3: game-rules §1.1 = `< 100%` แต่ brief §3 = "ไม่ถึง 80%" (และ Priority 4 ใน brief = อาหารไม่ถึง 80%) | ยึด game-rules (`< 100`) และ D-4 (`< 50`) — brief เป็นบริบท ไม่ใช่เอกสารหลัก |
| Q-5 | brief §3 บอกหลอดอาหารแดง "แม้คะแนนรวมจะถูกคิดที่ 100%" (สื่อว่าเกินเป้ายังได้ 100) แต่ D-3 ลดคะแนนเมื่อเกินเป้า | ยึด D-3 · แถบอาหารยาวตาม foodScore จริง (เช่น 93%) สี `error` — ไม่บังคับเต็ม 100% ให้ความยาวตรงกับตัวเลขในป้ายเสมอ |
| Q-6 | EC-4 / game-rules §1 "Null → 0" ขัดกับ D-3 "ไม่มีเป้า = ไม่คิดคะแนน" | ยึด D-3 สำหรับกรณีไม่มีเป้าอาหาร (Q-1) · กฎ Null/ติดลบ → 0 ใช้กับค่าที่อ่านได้แต่ผิดรูปแบบ (เช่น คะแนนติดลบ) ทั้ง 3 หมวด |
| Q-7 | ux-flow §3 ข้อ 1 "เปิดแอป → เข้าสู่หน้าแดชบอร์ดหลัก (S-1)" สื่อว่า S-1 เป็นหน้าแรก แต่แอปปัจจุบันมี home = `WaterHomeScreen` (signup S-7 ผูกแบนเนอร์ต้อนรับไว้) | ไม่เปลี่ยนหน้า home — เข้า S-1 ผ่าน `dashboard_entry_button` ใน AppBar ของ water (D-5) · ถ้า owner ต้องการให้ S-1 เป็นหน้าแรก ต้องตัดสินพร้อมผลกระทบต่อ signup S-7 และเทสต์ water |
| Q-8 | ux-flow ไม่กำหนดหัวข้อ AppBar ของ S-1 และ tooltip ปุ่มทางเข้า | 「แดชบอร์ด」 ทั้งสองจุด (เสนอ) |
| Q-9 | ux-flow/game-rules fallback 300×300 (ของ PNG) และ art แนะนำ `size: 300` | ใช้ **200** (เหตุผล §1.3: 300 ทำให้แถบ 3 หมวดตกจอ 360×640) — ค่าอยู่ใน `DashboardRules.petSize` เปลี่ยนได้จุดเดียว |
| Q-10 | ux-flow/game-rules ไม่บอกหน้าตาเมื่อไม่มีข้อความในคิว (brief §6 ข้อ 3: "Bubble ข้อความจะซ่อนอัตโนมัติ") | ซ่อนฟอง แต่จองที่ไว้ (`dashboard_alert_slot`) ไม่ให้สัตว์เลี้ยงขยับ |
| Q-11 | brief §4 ให้แต่ละโซนแสดงจำนวนแก้ว / ก้าว / kcal เทียบเป้า + ป้ายโซเดียม/น้ำตาลสูง แต่ ux-flow §2 แสดงเฉพาะ % | ยึด ux-flow — แสดงเฉพาะ `คะแนน…: [Integer]%` ไม่แสดงตัวเลขดิบ / ป้ายโซเดียม-น้ำตาล |
| Q-12 | ux-flow §2 (Pet Character Display "Image Asset"), §5, §6 ข้อ 1 และ game-rules §2, §5 ข้อ 1 ยังอ้างไฟล์ภาพ + 300×300 | ยึด D-1 (`PetCharacter`) — ให้ Design อัปเดตเอกสารเมื่อทีมยืนยัน (UI ไม่ได้แก้ docs/dashboard/ อื่น) |
| Q-13 | ux-flow §5 / AC-2 เขียนช่วง "0-30 / 31-60 / 61-80 / 81-100" ส่วน game-rules §2 ใช้ `[0,30] / (30,60] / (60,80] / (80,100]` | เท่ากันเพราะอารมณ์ตัดสินจาก totalScore ที่ปัดเป็นจำนวนเต็มแล้ว — spec ใช้ totalScore หลังปัด (ค่าเดียวกับที่แสดงในการ์ด) เพื่อให้ตัวเลขกับท่าไม่ขัดกัน |
| Q-14 | water ไม่มีค่าคงที่ "เป้าหมายแก้ว" (`WaterRules` มีแค่ 12.5%/แก้ว และเพดาน 100%) — D-3 ต้องใช้ `actual / target` | target น้ำ = `energyMaxDisplayPercentage / energyIncrementPercentage` = 8 แก้ว → `waterScore = round(WaterLogic.displayEnergyPercentage(cups))` (ผลเท่าสูตร D-3) · หมายเหตุ: สัตว์เลี้ยงของ water ร่าเริงที่ 7 แก้ว แต่ waterScore = 88 (ยังมี 「ดื่มน้ำๆ」 ในคิว) — Dev ใส่ `// ASSUMPTION` |
| Q-15 | ux-flow §3–4, game-rules §1/§4, requirements AC-5 อ้าง "Server Time" / "ICT" / "Session Database" | ยึด D-2 (เวลาเครื่อง ตัดรอบ 05:00 ผ่าน controller เดิม) · ไม่มี UI ออฟไลน์/sync (brief §6 ข้อ 5 Offline Cache ไม่เกี่ยว) |
| Q-16 | การปัดเศษ: D-3 สั่ง `round` เฉพาะ Water/Steps; สูตร Food ไม่ได้ปัด · brief §1 ให้ทุก % บนจอเป็นจำนวนเต็ม | ปัด foodScore เป็นจำนวนเต็มด้วย (`round`) ก่อนแสดงและก่อนเฉลี่ย · totalScore = `round(ค่าเฉลี่ยของคะแนนหมวดที่ปัดแล้ว)` แล้ว cap 100 — ตรงกับตัวอย่าง game-rules §3 (70, 60, 67 → 66) |
| Q-17 | brief §3 "คัดชื่อออกจากคิวในรอบ 5 วินาทีถัดไป" vs game-rules §1.1/§4 "ทันทีโดยไม่ต้องรอ" | ยึด game-rules — เปลี่ยนข้อความทันที |
| Q-18 | ตำแหน่งฟองข้อความ: ตาราง ux-flow §2 เรียง Total → Pet → Alert → แถบ (ไม่ได้บอกว่าเป็นลำดับบนจอ) ส่วน brief §3 บอก "เหนือหัวสัตว์เลี้ยง" | วางเหนือหัวสัตว์เลี้ยง 12 px (brief + เป็นคำพูดของสัตว์เลี้ยง "ฉัน…" + pattern Toast เหนือสัตว์เลี้ยงของ food) |
| Q-19 | ux-flow ไม่บอกว่าเมื่อคิวเปลี่ยน (ข้อความใหม่เข้าคิว / วันใหม่) การหมุนเริ่มจากข้อความไหน | หน้าตาไม่ขึ้นกับคำตอบ — ชั่วคราว: เริ่มจากข้อความ Priority สูงสุดในคิว และเริ่มนับ 5 วินาทีใหม่เมื่อข้อความที่แสดงเปลี่ยน · รอ game-rules ยืนยัน |
| Q-20 | ux-flow ไม่มีพฤติกรรมฉลองเมื่ออารมณ์ขยับขึ้น (art เสนอว่าเพิ่ม `cheerTrigger` ได้) | ไม่ใช้ `cheerTrigger` บน S-1 — เปลี่ยนท่าตรง ๆ |
| Q-21 | ux-flow/game-rules เขียนข้อความแจ้งเตือนเป็น `` `"…"` `` (เครื่องหมายคำพูดอยู่ใน code span) ไม่ชัดว่า `"` เป็นส่วนของข้อความบนจอหรือเป็นตัวคั่น string | ถือเป็นตัวคั่น — แสดง**ไม่รวม** `"` ให้เหมือน Toast 「พอเถอะน้าคนดี」 ของ food ที่ ux-flow เขียน `"พอเถอะน้าคนดี"` แต่แอปแสดงไม่มีเครื่องหมาย · ถ้า Design บอกว่าต้องรวม แก้ที่ค่าคงที่จุดเดียว |
