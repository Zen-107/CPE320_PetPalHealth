# UI spec: แดชบอร์ดสุขภาพรวมและอารมณ์สัตว์เลี้ยง (dashboard)

> สถานะ: draft (แก้ 2026-10-31 รอบ 3 ตามข้อตัดสิน owner รอบ 2–3 — D-6 ถึง D-18) · ผู้เขียน: UI agent · อ้างอิง: ux-flow.md, game-rules.md (บริบท: requirements.md, `ิbrief.md`, design-review.md, test-report.md)
> เอกสารนี้กำหนด "หน้าตา" เท่านั้น — ตัวเลข กติกา และ flow ให้ยึด ux-flow.md / game-rules.md และข้อตัดสิน owner ใน §0 (ข้อตัดสินชนะเอกสารเมื่อขัดกัน)
> design language ยึดตาม `docs/food/ui-spec.md`, `docs/steps/ui-spec.md`, `docs/signup/ui-spec.md` และโค้ดจริงใน `app/lib/` — ไม่สร้างระบบดีไซน์ใหม่

## 0. ข้อตัดสินใจที่มีผลต่อ UI

ข้อ D-1 ถึง D-4 และ D-6 ถึง D-18 เป็นการตัดสินใจของเจ้าของโปรเจกต์ ไม่ใช่ของ UI agent — **DECIDED (owner ชั่วคราว, รอทีมยืนยัน), 2026-10-31** — spec นี้แค่กำหนดหน้าตาให้รองรับ · D-5 เป็นข้อตัดสินระดับแอปที่มีอยู่แล้ว
ข้อที่ถูกแทนที่เขียนว่า ~~ขีดฆ่า~~ และชี้ไปข้อใหม่

| # | ข้อตัดสินใจ (ที่มา) | ผลต่อ UI |
|---|---|---|
| D-1 | **สัตว์เลี้ยง (รอบ 1):** ใช้ `PetCharacter` (CustomPainter) ใน `app/lib/shared/pet/` ไม่ใช้ PNG — ใช้แทนไฟล์ภาพ 4 ไฟล์และ fallback 300×300 ใน ux-flow §2 (Pet Character Display "Image Asset"), §5, §6 ข้อ 1 และ game-rules §2, §5 ข้อ 1 (ตรงกับ character.md §9 ข้อ 8) | Pet Character Display ของ S-1 = `PetCharacter` + preset `PetPose.dashboard*` (§4) — ห้ามโหลดไฟล์ภาพใด ๆ เป็นสัตว์เลี้ยง ไม่ลงทะเบียน asset ใหม่ใน pubspec |
| D-2 | **เวลา (รอบ 1):** ใช้เวลาเครื่อง ตัดรอบ 05:00 แบบเดียวกับ water / steps / food — ไม่มี Server Time / Session Database / network (ใช้แทน "Server Time", "ICT", "Local Storage / Session Database" ใน ux-flow §3–4, game-rules §1, §4, requirements AC-5) | dashboard ไม่มีรอบวันของตัวเอง: อ่านค่าจาก `WaterController` / `StepsController` / `FoodController` · ไม่มี UI ออฟไลน์ / sync · สถานะ "ข้ามช่วงเวลา" = ค่าจาก 3 controller กลับเป็นค่าวันใหม่ แล้วหน้าจอวาดใหม่ (§3) |
| D-3 | **คะแนน 0–100 (รอบ 1 — Dev ใส่ในไฟล์ rules พร้อม `// ASSUMPTION`):** สูตร `actual / target` ของ Water, Steps · Food: ถึงเป้า (kcal ≤ target) = `(kcal / target) × 100`; เกินเป้า = `max(0, 100 − (ส่วนที่เกิน / target × 100))`; ไม่มีเป้า (ข้ามโปรไฟล์) = **ไม่คิดคะแนน** · ~~การปัดแบบ `round`~~ → ถูกแทนด้วย **D-14 (floor)** | ตัวเลขทั้งหมดคำนวณใน `DashboardRules` / `DashboardLogic` — หน้าจอแสดงผลเท่านั้น · แถบอาหารมีสถานะ "ไม่คิดคะแนน" (D-6, D-17) |
| D-4 | **Priority 4 (รอบ 1):** "คะแนนอาหารต่ำกว่าเกณฑ์" = `foodScore < 50` — ขอบเขตเพิ่มเติมดู D-13 | กำหนดว่าข้อความ 「ฉันหิว」 อยู่ในคิวเมื่อไร (§3) |
| D-5 | (ระดับแอป — ไม่ใช่ข้อตัดสินใหม่) หน้า home คือ `WaterHomeScreen` (`app/lib/main.dart` → `_home`, signup ui-spec D-2) และฟีเจอร์อื่นเข้าทาง `IconButton` ใน `AppBar.actions` ของ water | ทางเข้า S-1 ใช้ pattern เดียวกัน (§2.0) — ยืนยันโดย D-9 |
| D-6 | **รอบ 2 (Q-1):** ไม่มีเป้าอาหาร → คะแนนรวมคิดจาก Steps + Water หาร 2 (ตัด Food ออกทั้งตัวตั้งและตัวหาร) — การปัดตาม D-14: `floor((S + W) / 2)` · ป้ายแถบอาหาร 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 แถบ 0 | §3 แถว "อาหารไม่คิดคะแนน" · ตัวอย่าง: S 100, W 87 → `floor(93.5)` = `คะแนนสุขภาพรวม: 93%` |
| D-7 | **รอบ 2 (Q-14) + ยืนยันรอบ 3 (QD-1):** เป้าน้ำ = 8 แก้ว derive จาก `WaterRules.energyMaxDisplayPercentage / WaterRules.energyIncrementPercentage` (ไม่พิมพ์เลข 8) → `DashboardRules.waterTargetCups` | waterScore ต่อแก้ว (floor ตาม D-14): 1 แก้ว 12 · 3 แก้ว 37 · 7 แก้ว 87 · 8 แก้ว 100 — สัตว์เลี้ยงหน้า water ร่าเริงที่ 7 แก้ว แต่ dashboard ยังแสดง 87% และมี 「ดื่มน้ำๆ」 ในคิว (ตั้งใจ) |
| D-8 | **รอบ 2 (Q-4 / Q-5 / Q-17):** brief ขัดกับ game-rules → ยึด game-rules + D-3: Priority 2 / 3 อยู่ในคิวเมื่อคะแนน `< 100` (ไม่ใช่ < 80 ของ brief) · แถบอาหารเกินเป้าแสดงคะแนนจริงตามสูตรเกินเป้า (ไม่บังคับเต็ม 100%) · แก้ปัญหาแล้วตัดออกจากคิว**ทันที** | §2.1.2, §3 |
| D-9 | **รอบ 2 (Q-7):** water ยังเป็นหน้าแรก — เข้า dashboard ผ่าน `dashboard_entry_button` ใน AppBar ของ water | §2.0 · ux-flow §3 ข้อ 1 ("เปิดแอป → S-1") ยังไม่ได้แก้ถ้อยคำ |
| D-10 | **รอบ 2 (Q-2):** การลบ/แก้มื้ออาหารไม่อยู่ในขอบเขตรอบนี้ — Priority 1 + แถบแดงค้างจนตัดรอบ 05:00 · ไม่มีเป้า → ไม่เข้า Priority 1 | §3 แถว Priority 1 |
| D-11 | **รอบ 2 (Q-11):** ยึด ux-flow — แถบรายหมวดแสดงเฉพาะ `คะแนน…: [Integer]%` ไม่แสดงจำนวนแก้ว / ก้าว / kcal ดิบ และไม่มีป้ายโซเดียม-น้ำตาล (ข้อยกเว้นเดียว: ยอดรวม kcal ใน CTA ของ food ตาม D-17 — Q-25) | §2.1.2 |
| D-12 | **รอบ 2 (BUBBLY):** ใช้หน้าเดิม `PetPose.dashboardBubbly` (`== PetPose.waterHappy`) ไม่ขอท่าใหม่จาก Art | §4 |
| D-13 | **รอบ 3 (A-7 / BUG-DASH-1 / QD-2):** กินเกินเป้าไม่ขึ้น 「ฉันหิว」 — เงื่อนไข "foodScore < 50" ของ Priority 4 นับเฉพาะตอน `kcal ≤ target` · ส่วน "ยังไม่บันทึกมื้อใด" ใช้เสมอ (รวมกรณีไม่มีเป้า) · ประเมินสด (บันทึกแล้วแต่ foodScore ยัง < 50 และยังไม่เกินเป้า → ข้อความยังอยู่) | ตัวอย่าง: เป้า 2,000 กิน 3,500 kcal → foodScore 25 แต่คิว = 「แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว」 → 「ดื่มน้ำๆ」 → 「ขยับร่างกายหน่อย อีกนิดๆ」 (ไม่มี 「ฉันหิว」) |
| D-14 | **รอบ 3 (การปัด):** ปัดลง (floor) ทุกคะแนน — Water, Steps = `floor(min(actual / target, 1) × 100)`; Food ถึงเป้า = `floor(kcal × 100 / target)`; Food เกินเป้า = `max(0, 100 − ceil(ส่วนที่เกิน × 100 / target))`; total = `floor((F + S + W) / 3)` (ไม่มีเป้า `floor((S + W) / 2)`) cap 100 · **ได้ 100 เฉพาะเมื่อถึงเป้าจริง** · อารมณ์ตัดสินจาก total หลัง floor — แทน `round` ของ D-3, Q-13, Q-16 เดิม | ตัวเลขบนจอทุกจุด: 7,999 / 8,000 ก้าว = `99%` · 1,999 / 2,000 kcal = `99%` · 2,000 = `100%` · 2,001 = `99%` · 2,101 = `94%` · 2,150 = `92%` · (70, 60, 67) → 65.67 → `65%` BUBBLY · total 30.67 → `30%` CRYING |
| D-15 | **รอบ 3 (A-8 + รอบวัน):** การเลือกข้อความเมื่อคิวเปลี่ยน — เปิดหน้า / ข้ามรอบวัน / มีข้อความใหม่เข้าคิว → ข้อความ Priority สูงสุด · ข้อความที่แสดงอยู่หลุดคิว → ข้อความลำดับถัดไปทันที (วนกลับต้นคิว) · ข้อความอื่นหลุด → คงข้อความเดิม · ข้อความเปลี่ยน = เริ่มนับ 5 วินาทีใหม่ · ตรวจรอบวันของทั้ง 3 controller **ทุก 1 วินาที** (`DashboardRules.dayCheckIntervalSeconds`) และเมื่อแอป resume | §2.1.1, §3 — หน้าตาไม่เปลี่ยน (ข้อความในฟองเดิมเปลี่ยนทันที) |
| D-16 | **รอบ 3 (QD-4 — ช่องฟองข้อความ):** จองความสูงช่องด้วย **min-height ที่วัดจากฟองข้อความ Priority 1** (TextPainter ที่ความกว้าง/textScaler จริง) ผ่าน `FoodSharedMinHeightBox` (`app/lib/features/food/widgets/food_shared_min_height_box.dart`) — ช่องโตตามเนื้อหาได้ ไม่ล็อกความสูง · ~~`Stack` + `Visibility(maintainSize)` ซ่อนข้อความ P1~~ (ทำให้ `find.text(P1)` เจอ 2 ตัว) | §2.1.1 |
| D-17 | **รอบ 3 (CTA — ข้อ 5):** ไม่มีเป้าอาหาร → แสดง `FoodProfileCtaBanner` (`app/lib/features/food/widgets/food_profile_cta_banner.dart` — CTA เดิมของ food, keys `food_profile_cta_banner` / `food_cta_text` / `food_cta_total_text`) **ใต้แถบอาหาร ห่าง 8** กดแล้วเปิด `FoodProfileScreen` (S-3 ของ food) ด้วย `FoodController` ตัวเดียวกัน · คงป้าย 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 และแถบ 0 ไว้ | §2.1 #7a, §3 — ตั้งโปรไฟล์แล้วกลับมา CTA หาย แถบอาหารเป็นคะแนนทันที · ไม่ได้เพิ่มหน้าจอ (S-3 ของ food มีอยู่แล้ว) |
| D-18 | **รอบ 3 (ข้อ 7 — AppBar ของ water):** `water_monthly_report_button` เป็น `IconButton` (ไอคอนปฏิทินเดิม `AssetImageOrIcon(WaterRules.calendarReportIcon, fallback Icons.calendar_month)`) + `tooltip:` 「รายงานรายเดือน」 (`WaterRules.monthlyReportButtonText`) **ไม่มีข้อความบนปุ่ม** key เดิม — AppBar มี 4 ปุ่มไอคอน 4 × 48 = 192 dp ไม่ล้นที่ 360 dp | §2.0 — แทนการประเมินเดิมของ spec ที่ว่า "3 ไอคอน + ปุ่มข้อความไม่ล้น" (ล้นจริง 41 px) |

## 1. Design tokens

ทุกสีของ component ให้ดึงจาก `Theme.of(context).colorScheme` / `textTheme` เท่านั้น ห้าม hardcode hex ในหน้าจอ dashboard (dashboard ไม่วาดสัตว์เลี้ยงเอง สีตัวสัตว์เลี้ยงอยู่ใน `PetColors` ของ `app/lib/shared/pet/pet_constants.dart` — ห้ามแก้)

### 1.1 สี

| Token | ค่า | ใช้ที่ไหน | ที่มา |
|---|---|---|---|
| Seed color | `Colors.lightBlue` | ทุก ColorScheme | `app/lib/main.dart` → `ColorScheme.fromSeed(seedColor: Colors.lightBlue)` |
| Total Score Card — พื้น / ตัวอักษร | `colorScheme.primaryContainer` / `colorScheme.onPrimaryContainer` | S-1 #1 | role เดิมใน ColorScheme — **การใช้ role ใหม่** เหตุผล: คะแนนรวมเป็นตัวเลขหลักของหน้า ต้องแยกจากฟองข้อความ (`secondaryContainer`) และแถบรายหมวด (`primary`) โดยไม่ตั้ง hex ใหม่ |
| ฟองข้อความแจ้งเตือน (Dynamic Alert Banner) — พื้น / ตัวอักษร | `colorScheme.secondaryContainer` / `colorScheme.onSecondaryContainer` | S-1 #3 | ของเดิม: `steps_status_badge`, `food_profile_cta_banner` |
| CTA ตั้งโปรไฟล์ (D-17) | พื้น `secondaryContainer`, ตัวอักษร/ไอคอน `onSecondaryContainer` — ค่าภายใน `FoodProfileCtaBanner` ห้ามตั้งสีทับ | S-1 #7a (ไม่มีเป้าอาหาร) | ของเดิม: food ui-spec §1.1 "CTA Banner (ข้ามโปรไฟล์)" |
| แถบความคืบหน้า — ปกติ | `colorScheme.primary` (default ของ `LinearProgressIndicator`) track default | S-1 แถบ Food / Steps / Water | ของเดิม: `water_energy_bar`, `steps_energy_bar`, `food_energy_bar` |
| แถบอาหาร — Priority 1 ("หลอดสีแดง") | `colorScheme.error` ส่งเข้า `LinearProgressIndicator.color` (track คง default) | S-1 แถบ Food เมื่อเข้าเงื่อนไข Priority 1 | ของเดิม: `food_energy_bar` ตอนเกินเป้าหมาย (food ui-spec §1.1) — เงื่อนไขเดียวกับ `FoodController.isOverLimit` |
| ข้อความ "ไม่คิดคะแนน" ของแถบอาหาร | `colorScheme.onSurfaceVariant` | S-1 ป้ายแถบ Food เมื่อไม่มีเป้า (D-6) | role เดิม (signup ใช้กับข้อความรอง, steps ใช้กับไอคอนออฟไลน์) |

ไม่มีสถานะ disabled บน S-1 (ไม่มีปุ่ม/ช่องกรอกที่ถูกปิด — ux-flow §2)

### 1.2 ตัวอักษร

ไม่มี custom font ใน `app/pubspec.yaml` → ฟอนต์ default ของ Material ใช้ `Theme.of(context).textTheme` เท่านั้น

| ใช้กับ | style | ที่มา |
|---|---|---|
| หัวข้อหน้าจอ (AppBar title) | default ของ `AppBar` | water / steps / food ทุกหน้า |
| Total Score Card `คะแนนสุขภาพรวม: [Integer]%` | `textTheme.headlineSmall` + `onPrimaryContainer` | `water_count_text`, `steps_count_text`, `food_calorie_text` |
| ฟองข้อความแจ้งเตือน | `textTheme.bodyMedium` + `onSecondaryContainer` | `food_cta_text`, `steps_percent_text` |
| ป้ายแถบรายหมวด `คะแนน…: [Integer]%` | default (`bodyMedium` จาก `DefaultTextStyle`) — เปลี่ยนแค่สีเมื่อไม่คิดคะแนน | `water_energy_text`, `steps_percent_text` |
| CTA (D-17) | ข้อความชวน `bodyMedium` (`maxLines: 2`), ยอดรวม `titleMedium` — ค่าภายใน `FoodProfileCtaBanner` | food ui-spec §2.1 #9b |

### 1.3 ระยะห่าง ขนาด มุมโค้ง เวลา

| Token | ค่า | ที่มา |
|---|---|---|
| Padding หน้าหลัก (S-1) | 24 รอบด้าน | `water_home_screen.dart`, `steps_dashboard_screen.dart`, `food_dashboard_screen.dart` → `EdgeInsets.all(24)` |
| ช่องไฟ | 8 / 16 / 24 (`SizedBox`) | `water_home_screen.dart` |
| ระยะฟองข้อความ ↔ ขอบบนกล่องสัตว์เลี้ยง | 12 — `DashboardRules.alertAnchorOffset` | ค่าเดียวกับ `FoodRules.toastAnchorOffset` แต่เป็นค่าคงที่ของ dashboard เอง (ไม่ import จาก food) |
| ความสูงช่องฟองข้อความ | ขั้นต่ำ = ความสูงฟองข้อความ Priority 1 (padding 8 × 2 + ข้อความ `bodyMedium` ที่ความกว้างช่อง − 32 และ textScaler จริง; ≈ 56 dp ที่จอ 360 dp) โตตามเนื้อหาได้ — ห้ามล็อกค่าคงที่ (D-16) | `FoodSharedMinHeightBox` (ของเดิม — food ใช้กับ Energy slot, food D-5) |
| Padding ในกล่อง (Total Score Card, ฟองข้อความ) | แนวนอน 16 แนวตั้ง 8 | ป้าย `steps_status_badge`, `food_full_badge`, `food_toast` |
| มุมโค้งกล่อง / แถบ | `BorderRadius.circular(8)` | `water_energy_bar` (`ClipRRect`), `steps_status_badge`, `food_profile_cta_banner` |
| ระยะแถบอาหาร ↔ CTA (D-17) | 8 | ช่องไฟเดิม (เท่าระยะป้าย ↔ แถบในแถวเดียวกัน §2.1.2) |
| ขนาดสัตว์เลี้ยง | **200 × 200** — `DashboardRules.petSize` | **ใหม่** — เหตุผล: fallback 300×300 ของ ux-flow/game-rules เป็นของ PNG (แทนด้วย D-1) และที่ 300 แถบ 3 หมวด (AC-4) ตกขอบจอ 360×640 · ที่ 200 หน้าปกติอยู่ในจอเดียวที่ textScaler 1.0 (≈ 540 dp — §2.1) และใหญ่กว่า 160 ของหน้าอื่นเพราะเป็นจุดเด่นของหน้ารวม (Q-9) |
| ความสูงแถบรายหมวด | `minHeight: 12` — `DashboardRules.barMinHeight` | **ใหม่** — เหตุผล: หน้าอื่นมีหลอดเดียว (`minHeight: 20`) ที่เป็นตัวหลักของหน้า แต่ S-1 มี 3 แถบซ้อนกันและตัวหลักคือคะแนนรวม + สัตว์เลี้ยง · มุมโค้ง 8 เท่าเดิม |
| ระยะเวลาหมุนข้อความ | `DashboardRules.alertIntervalSeconds` (= `alertInterval` 5 วินาที, game-rules §1) | game-rules §1 |
| ความถี่ตรวจรอบวัน | `DashboardRules.dayCheckIntervalSeconds` = 1 วินาที (D-15) | แบบ `_dayCheckInterval` ของ steps / food |
| Loading ทั้งหน้า | `Center(CircularProgressIndicator())` | water / steps / food ตอน `!isLoaded` |

## 2. หน้าจอ

ux-flow มีหน้าจอเดียว: **S-1 หน้าจอแดชบอร์ดหลัก (Dashboard Main Screen)** — spec ไม่เพิ่มหน้าจออื่น (CTA ของ D-17 พาไป S-3 ของ food ที่มีอยู่แล้ว)
ข้อความใน「」คัดลอกตรงตัวจาก ux-flow.md / game-rules.md — ห้ามแก้ · เครื่องหมาย `"` ที่ครอบข้อความแจ้งเตือนในเอกสารเป็นตัวคั่น string ไม่ใช่ส่วนของข้อความบนจอ (แบบเดียวกับ 「พอเถอะน้าคนดี」 ของ food — Q-21) · ข้อความที่ ux-flow ไม่มีและ spec เสนอไว้ชั่วคราว ระบุว่า **(เสนอ — รอยืนยัน)**
ข้อความบนจอทุกข้อความ และค่าตัวเลข (`alertIntervalSeconds`, เกณฑ์อารมณ์ 30 / 60 / 80, เกณฑ์ Priority 2/3 = 100, Priority 4 = 50, ขนาดสัตว์เลี้ยง, ระยะ anchor, ความสูงแถบ) อ่านจาก `DashboardRules` (`app/lib/features/dashboard/dashboard_rules.dart`) — ห้าม hardcode ในหน้าจอ
ValueKey ใช้ prefix `dashboard_` ทั้งหมด ยกเว้น CTA ที่ใช้ keys ของ food ตาม D-17
ตัวเลข `[Integer]` ทุกจุดเป็นจำนวนเต็ม 0–100 ปัดลง (D-14) ไม่มีทศนิยม ไม่มีช่องว่างก่อน `%` (เช่น `70%`)

### 2.0 ทางเข้า S-1 จากหน้า water (D-5, D-9, D-18)

- ตำแหน่ง: `AppBar.actions` ของ `WaterHomeScreen` ลำดับ `steps_entry_button` → `food_entry_button` → **`dashboard_entry_button`** → `water_monthly_report_button`
- Widget: `IconButton` แบบเดียวกับ `steps_entry_button` / `food_entry_button` — `Icon(Icons.dashboard, size: 24)`, `tooltip:` 「แดชบอร์ด」 (`DashboardRules.entryTooltip`) **(เสนอ — รอยืนยัน, Q-8)**
- `water_monthly_report_button` เป็น `IconButton` ไอคอนปฏิทินเดิม + tooltip 「รายงานรายเดือน」 ไม่มีข้อความบนปุ่ม (D-18) → AppBar มีปุ่มไอคอน 4 ปุ่ม (4 × 48) ไม่ล้นที่ 360 dp ทั้ง textScaler 1.0 และ 1.5; ชื่อ 「PetPal Health」 ตัด ellipsis ตาม default ของ AppBar ได้
- กดแล้ว `Navigator.push(MaterialPageRoute(...))` ไป `DashboardScreen` (แบบ `_openSteps` / `_openFood`)
- ข้อมูล: S-1 รับ **controller ตัวเดียวกัน** กับที่หน้า water ใช้อยู่ — `widget.controller` (water), steps / food ตัวที่ inject หรือที่หน้า water สร้างเก็บไว้ (ตัวเดียวกับที่ `_openSteps` / `_openFood` ใช้)
- ValueKey: `dashboard_entry_button`
- ห้ามแก้ส่วนอื่นของ `WaterHomeScreen`

### 2.1 S-1 หน้าจอแดชบอร์ดหลัก (Dashboard Main Screen)

จุดประสงค์ (ux-flow §1): แสดงคะแนนสุขภาพรวม, อารมณ์สัตว์เลี้ยงเสมือนจริง, ข้อความแนะนำวนลูป และแถบความคืบหน้าแยกตามหมวดหมู่ (อาหาร, การก้าวเดิน, การดื่มน้ำ)

โครง: `Scaffold` → `AppBar` → body `ListenableBuilder` ที่ฟังค่าจากทั้ง 3 controller (อัปเดตทันทีเมื่อค่าใดเปลี่ยน — ux-flow §2 "อัปเดตแบบเรียลไทม์"; โค้ดปัจจุบันฟังผ่าน `DashboardController` ที่รวม 3 controller + สถานะฟองข้อความ — Q-23) → ถ้า controller ใดยัง `!isLoaded` = `Center(CircularProgressIndicator())` → `SafeArea` → `LayoutBuilder` + `SingleChildScrollView` + `ConstrainedBox(minHeight: constraints.maxHeight)` + `IntrinsicHeight` (pattern `steps_dashboard_screen.dart` / `food_dashboard_screen.dart`) → `Padding(24)` → `Column(crossAxisAlignment: stretch)`
ไม่มีภาพพื้นหลัง — พื้น `colorScheme.surface` ตาม default

จากบนลงล่าง:

| # | องค์ประกอบ (ux-flow §2) | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 0 | หัวข้อหน้าจอ | `AppBar(title: Text(...))` — มีปุ่มย้อนกลับอัตโนมัติเพราะถูก push จาก water | 「แดชบอร์ด」 (`DashboardRules.screenTitle`) **(เสนอ — รอยืนยัน, Q-8)** | AppBar default | `dashboard_header_text` (บน `Text`) |
| 1 | Total Score Card | `Container(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: primaryContainer, borderRadius: BorderRadius.circular(8)))` เต็มความกว้าง → `Text(textAlign: center)` | `คะแนนสุขภาพรวม: [Integer]%` เช่น `คะแนนสุขภาพรวม: 70%` | `headlineSmall` + `onPrimaryContainer` | `dashboard_total_score_card` (บน `Container`), `dashboard_total_score_text` (บน `Text`) |
| 2 | `Spacer()` | | | | |
| 3 | Dynamic Alert Banner (ช่อง + ฟองข้อความ) | ช่อง `FoodSharedMinHeightBox` → ฟองข้อความ ดู §2.1.1 | ข้อความ 1 จาก 4 ตาม game-rules §1.1 | §1.1, §1.2, §1.3 | `dashboard_alert_slot`, `dashboard_alert_banner`, `dashboard_alert_text` |
| 4 | ระยะ anchor | `SizedBox(height: DashboardRules.alertAnchorOffset)` (= 12) | | §1.3 | - |
| 5 | Pet Character Display | `Center` → `KeyedSubtree(key: ValueKey('dashboard_pet_image_<mood>'))` → `PetCharacter(key: _petKey /* GlobalKey(debugLabel: 'dashboard_pet') */, pose: DashboardLogic.poseFor(mood), size: DashboardRules.petSize, animate: widget.animatePet ?? kPetAnimateByDefault, semanticLabel: <ชื่อไทยของอารมณ์>)` — **ไม่ส่ง `cheerTrigger`** | ท่าตามอารมณ์ §4 · `semanticLabel` = 「ร้องไห้」 / 「เหม่อลอย」 / 「ออรุ่มเจ๊าะ」 / 「ยิ้มร่าเริง」 (ชื่อในวงเล็บของ game-rules §2 — ไม่แสดงบนจอ) | 200 × 200 | `dashboard_pet_image_<crying\|dazed\|bubbly\|cheerful>` บน `KeyedSubtree` |
| 6 | `SizedBox(height: 24)` | | | | |
| 7 | Food Progress Bar | แถวแถบ §2.1.2 | `คะแนนอาหาร: [Integer]%` · สีแดงเมื่อเข้าเงื่อนไข Priority 1 · ไม่มีเป้า = 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 แถบ 0 (D-6) | §2.1.2 | `dashboard_food_row`, `dashboard_food_label_text`, `dashboard_food_bar` |
| 7a | CTA ตั้งโปรไฟล์ — **เฉพาะเมื่อไม่มีเป้าอาหาร** (D-17) | `SizedBox(height: 8)` → `FoodProfileCtaBanner(totalText: foodController.ctaTotalText, onTap: → push FoodProfileScreen(controller: foodController))` เต็มความกว้าง | ข้อความชวน 「ตั้งค่าโปรไฟล์สุขภาพเพื่อรับเป้าหมายแคลอรี่ที่แม่นยำ」 (food ux-flow) + ยอดรวม `<total> kcal` (food ui-spec Q-8) + `Icons.chevron_right` — ค่าภายใน widget ของ food | §1.1, §1.2 | `food_profile_cta_banner` (บน `InkWell`), `food_cta_text`, `food_cta_total_text` |
| 8 | `SizedBox(height: 16)` | | | | |
| 9 | Steps Progress Bar | แถวแถบ §2.1.2 | `คะแนนการก้าวเดิน: [Integer]%` | §2.1.2 | `dashboard_steps_row`, `dashboard_steps_label_text`, `dashboard_steps_bar` |
| 10 | `SizedBox(height: 16)` | | | | |
| 11 | Water Progress Bar | แถวแถบ §2.1.2 | `คะแนนการดื่มน้ำ: [Integer]%` | §2.1.2 | `dashboard_water_row`, `dashboard_water_label_text`, `dashboard_water_bar` |
| 12 | `Spacer()` | | | | |

- ลำดับแถบ Food → Steps → Water ตามตาราง ux-flow §2
- สิ่งที่กดได้บน S-1: ปุ่มย้อนกลับของ AppBar, ตัวสัตว์เลี้ยง (`reactToTap`), และ CTA #7a (เฉพาะไม่มีเป้า) — แถบไม่กดได้ ไม่มีทางไปหน้าอื่น
- งบความสูงที่จอ 360×640 dp, textScaler 1.0 (body ≈ 560): 24 + การ์ด 48 + ช่องข้อความ 56 + 12 + สัตว์เลี้ยง 200 + 24 + แถบ 3 × 40 + 16 × 2 + 24 ≈ 540 → ไม่ต้องเลื่อน · สถานะไม่มีเป้า (+ 8 + CTA ≈ 80) ≈ 628 → หน้าเลื่อนได้ ~70 dp (ยอมรับ — Q-25) · จอเตี้ยกว่า/ตัวอักษรใหญ่กว่า = เลื่อนได้ ไม่ overflow
- เมื่อค่าเปลี่ยน: ตัวเลข สีแถบ ความยาวแถบ CTA และท่าสัตว์เลี้ยงเปลี่ยนในเฟรมถัดไปพร้อมกัน (ไม่มี animation ของแถบหรือตัวเลข)

#### 2.1.1 Dynamic Alert Banner (ฟองข้อความเหนือหัวสัตว์เลี้ยง — component ใหม่)

- ข้อความ 4 ลำดับ (คัดลอกตรงตัวจาก ux-flow §2 / game-rules §1.1 ไม่รวม `"` ที่เป็นตัวคั่น — Q-21):
  1. 「แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว」
  2. 「ดื่มน้ำๆ」
  3. 「ขยับร่างกายหน่อย อีกนิดๆ」
  4. 「ฉันหิว」
- ฟองข้อความ: `Container(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: secondaryContainer, borderRadius: BorderRadius.circular(8)))` เต็มความกว้าง → `Text(message, textAlign: center, style: bodyMedium + onSecondaryContainer)` — **ไม่มี `maxLines` / ellipsis** (ข้อความต้องแสดงครบตรงตัว) ไม่มีหางชี้ ไม่มีไอคอน · สีเดียวกันทุก Priority
- ช่อง `dashboard_alert_slot` (D-16): `FoodSharedMinHeightBox(minHeightFor: <ความสูงฟองข้อความ Priority 1 ที่ความกว้างนั้น>)` — วัดด้วย `TextPainter` ด้วย style / textScaler / locale เดียวกับฟองจริง (ความกว้างข้อความ = ความกว้างช่อง − 16 × 2, บวก padding 8 × 2) → ช่องสูงเท่าฟอง P1 เสมอ และโตตามเนื้อหาได้ถ้าจำเป็น · ห้ามล็อกความสูงคงที่ · ห้ามมีข้อความ P1 ซ่อนอยู่ใน tree (`find.text(P1)` ต้องเจอไม่เกิน 1)
- ฟองในช่อง: เต็มความกว้าง จัดกลางแนวตั้ง — ความสูงของฟองเอง = ความสูงข้อความที่แสดง (ข้อความสั้นได้ฟองเตี้ยกว่าช่อง; โค้ดปัจจุบันทำแบบนี้ — Q-24)
- ตำแหน่ง: ขอบล่างของช่องห่างขอบบนสุดของกล่อง `PetCharacter` (กล่อง 200×200 — `PetKeys.character`) เท่ากับ `alertAnchorOffset` = 12 เสมอ (เหนือหัวสัตว์เลี้ยง — Q-18)
- การหมุนเวียน / ตัดออกจากคิว: พฤติกรรมตาม game-rules §1.1 + หมายเหตุ Dynamic Queue + §4 และ D-8, D-13, D-15 (ไม่เขียนซ้ำ) — หน้าตา: เปลี่ยนข้อความในฟองเดิม **ทันที** ไม่มี animation · ฟองแสดงทีละ 1 ข้อความเสมอ ไม่มีตัวบอกลำดับ/จำนวน
- คิวว่าง: ไม่มี `dashboard_alert_banner` ใน tree แต่ `dashboard_alert_slot` ยังจองที่เท่าเดิม (Q-10)
- ห้ามใช้ `SnackBar` / `ScaffoldMessenger` / `Tooltip` / dialog สำหรับข้อความนี้

#### 2.1.2 แถวแถบรายหมวด (Food / Steps / Water — ใช้ร่วมกัน 3 แถว)

- `Column(crossAxisAlignment: stretch)` key `dashboard_<food|steps|water>_row` →
  - `Text(textAlign: TextAlign.start)` key `dashboard_<…>_label_text` — style default (`bodyMedium`); ไม่มีเป้าอาหาร = สี `onSurfaceVariant`
  - `SizedBox(height: 8)`
  - `ClipRRect(borderRadius: BorderRadius.circular(8))` → `LinearProgressIndicator(key: dashboard_<…>_bar, value: score / 100 (clamp 0.0–1.0), minHeight: 12, color: <primary หรือ error>)`
- `value` = คะแนนจำนวนเต็มของหมวด (D-14) ÷ 100 → ความยาวแถบตรงกับตัวเลขในป้ายเสมอ (เช่น 2,150 / 2,000 kcal → `คะแนนอาหาร: 92%`, value 0.92)
- สี: `primary` ทุกแถบ ยกเว้นแถบอาหารเมื่อเข้าเงื่อนไข Priority 1 (`FoodController.isOverLimit` ตัวเดียวกับหลอดแดงของ food — > 100 kcal เหนือเป้า) = `colorScheme.error`
- ไม่มีไอคอน ไม่มีตัวเลขดิบ (แก้ว / ก้าว / kcal) — D-11

## 3. สถานะของแต่ละหน้าจอ

### S-1

อารมณ์สัตว์เลี้ยงมาจาก `totalScore` (จำนวนเต็มหลัง floor และ cap — D-14) ตามช่วง game-rules §2 · ข้อความในคิวตาม game-rules §1.1 + D-4, D-8, D-13 · การเลือกข้อความตาม D-15

| สถานะ | เงื่อนไข (อ้างถึง) | หน้าตา |
|---|---|---|
| กำลังโหลด | `WaterController` / `StepsController` / `FoodController` ตัวใดยัง `!isLoaded` (โหลดจากเครื่อง — D-2) | `Center(CircularProgressIndicator())` แทน body ทั้งหมด — ไม่มีข้อความ |
| ปกติ (Normal State) | ux-flow §4 | ตาม §2.1 (ไม่มี #7a): การ์ด `คะแนนสุขภาพรวม: <n>%`, สัตว์เลี้ยงท่าตามอารมณ์ (§4), ฟองข้อความในคิว, 3 แถบสี `primary` · ตัวอย่าง game-rules §3 แถว 1: Food 60 / Steps 90 / Water 60 → `คะแนนสุขภาพรวม: 70%`, `dashboard_pet_image_bubbly`, ฟองหมุน 「ดื่มน้ำๆ」 → 「ขยับร่างกายหน่อย อีกนิดๆ」 (P4 ไม่อยู่ในคิวเพราะ 60 ≥ 50 และมีมื้ออาหาร) · แถว 2: (70, 60, 67) → 65.67 → `คะแนนสุขภาพรวม: 65%` BUBBLY (D-14 — เอกสารเขียน 66, Q-22) · ขอบ: 7,999 / 8,000 ก้าว = `คะแนนการก้าวเดิน: 99%` และยังมี 「ขยับร่างกายหน่อย อีกนิดๆ」 |
| ว่าง / ข้อมูลไม่สมบูรณ์ (Empty/Fallback State) | ux-flow §4, EC-4 — คะแนนหมวดใดติดลบ/ว่าง → 0 | layout เดิม ไม่มีข้อความพิเศษ ไม่มี error · แถบหมวดนั้น `value` 0.0 ป้าย `คะแนน…: 0%` · game-rules §3 แถว 3: Food −10 → `คะแนนอาหาร: 0%`, total `60%` `dashboard_pet_image_dazed` · วันใหม่ทั้งหมดเป็น 0 (มีเป้าอาหาร): `คะแนนสุขภาพรวม: 0%`, `dashboard_pet_image_crying`, ฟองหมุน 「ดื่มน้ำๆ」 → 「ขยับร่างกายหน่อย อีกนิดๆ」 → 「ฉันหิว」 |
| อาหารไม่คิดคะแนน (ไม่มีเป้า — ข้ามโปรไฟล์) — D-6, D-17 | `FoodController.hasTarget == false` | ป้าย `dashboard_food_label_text` = 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 **(เสนอ — รอยืนยัน)** สี `onSurfaceVariant` · `dashboard_food_bar` value 0.0 สี `primary` · **มี CTA #7a** `food_profile_cta_banner` ใต้แถบอาหาร ห่าง 8 (ยอดรวมเช่น `1,250 kcal`) กดแล้วเปิด S-3 ของ food · total = `floor((S + W) / 2)` เช่น S 100 / W 87 → `93%` · ไม่เข้า Priority 1 (D-10) · Priority 4 ขึ้นเฉพาะเมื่อยังไม่บันทึกมื้อใด (D-13) · ตั้งโปรไฟล์สำเร็จแล้วกลับมา → CTA หาย ป้ายเป็น `คะแนนอาหาร: <n>%` ในเฟรมถัดไป |
| อาหารเกินเป้าหมาย (Priority 1) | game-rules §1.1 Priority 1 (> 100 kcal เหนือเป้า = `FoodController.isOverLimit`) | แถบอาหาร `color: colorScheme.error` · `value` = foodScore ÷ 100 (D-8, D-14 — ไม่ใช่แถบเต็ม) เช่น 2,150 / 2,000 kcal → `คะแนนอาหาร: 92%` · ฟองข้อความแสดง 「แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว」 เป็นลำดับแรกของคิว (ขึ้นทันทีเมื่อเข้าคิว — D-15) · ไม่มี 「ฉันหิว」 แม้ foodScore < 50 (D-13) · ค้างจนตัดรอบ 05:00 (D-10) · เกินเป้าไม่ถึง 100 kcal (เช่น 2,001 → `99%`, 2,100 → `95%`) = แถบสี `primary` |
| คิวข้อความว่าง | ไม่มีเงื่อนไข Priority ใดเป็นจริง (น้ำ 100, ก้าว 100, มีมื้ออาหาร, ไม่เกินเป้า และ foodScore ≥ 50 หรือ kcal > target ≤ 100 kcal) | ไม่มี `dashboard_alert_banner` / `dashboard_alert_text` ใน tree · `dashboard_alert_slot` ยังจองที่ (สัตว์เลี้ยงไม่ขยับ — Q-10) |
| แก้ปัญหาสำเร็จขณะข้อความกำลังแสดง | game-rules §4 แถว 2, AC-3, EC-2, D-8, D-15 | ข้อความในฟองเปลี่ยนเป็นข้อความลำดับถัดไปในคิว**ในเฟรมเดียวกับ**ที่คะแนน/สีแถบเปลี่ยน (ไม่รอ 5 วินาที) แล้วเริ่มนับ 5 วินาทีใหม่ · ถ้าไม่มีข้อความเหลือ → สถานะคิวว่าง |
| ผิดพลาด / ข้ามช่วงเวลา (Error / Time Crossing State) | ux-flow §4, game-rules §4 แถว 3 — เวลาเครื่อง 05:00 (D-2), ตรวจทุก 1 วินาที + resume (D-15) | ไม่มี dialog / SnackBar / ข้อความผิดพลาด · หน้าจอวาดใหม่ทันทีเป็นค่าวันใหม่ = หน้าตาเดียวกับแถว "ว่าง" (0%, ท่า crying) · ฟองเริ่มจากข้อความ Priority สูงสุดของคิวใหม่ |

ไม่มีสถานะ disabled (ไม่มี control ที่ถูกปิด)

## 4. ภาพสัตว์เลี้ยงแต่ละสถานะ

ใช้ `PetCharacter` ตัวเดียวจาก `app/lib/shared/pet/` (`import 'package:petpal_health/shared/pet/pet.dart'`) — **ไม่ใช้ไฟล์ภาพตาม ux-flow §5 / game-rules §2** (D-1) · ชื่อ preset ตรวจแล้วกับ `app/lib/shared/pet/pet_pose.dart` (บรรทัด 143–159), `DashboardLogic.poseFor` และ `docs/_design/character.md` §4–7

| อารมณ์ (game-rules §2) | ช่วง totalScore (หลัง floor) | Preset | สีหน้า / รูปร่าง | ท่าทางที่เห็น (character.md §4–5) | ขยับ (`animate: true`) | ขนาด | key บน `KeyedSubtree` | preview |
|---|---|---|---|---|---|---|---|---|
| `CRYING` (ร้องไห้) | `[0, 30]` | `PetPose.dashboardCrying` | `crying` / `normal` | ตาปิดแน่นเอียงเศร้า คิ้วกังวล สายน้ำตาฟ้าสองข้าง + หยดน้ำตา ปากร้องไห้อ้ากว้าง ใบไม้ห้อย แขนห้อย ตัวสีปกติ (ไม่ซีด ไม่มีเหงื่อ) | หายใจ (`breath` 2400 ms) หยดน้ำตาหล่นตามลมหายใจ | 200 × 200 | `dashboard_pet_image_crying` | `docs/_design/preview/dashboard_crying.png` |
| `DAZED` (เหม่อลอย) | `(30, 60]` | `PetPose.dashboardDazed` | `dazed` / `normal` | ตาดำจุดเล็กมองตรงว่างเปล่า หนังตาตกเท่ากันสองข้าง ปาก "o" ฟองน้ำลาย จุด "..." ลอยขวาบน | หายใจ — "..." ลอยขึ้นลง ใบไม้แกว่งช้า | 200 × 200 | `dashboard_pet_image_dazed` | `dashboard_dazed.png` |
| `BUBBLY` (ออรุ่มเจ๊าะ) | `(60, 80]` | `PetPose.dashboardBubbly` (หน้าเดิม `== PetPose.waterHappy` — D-12) | `happy` / `normal` | ตาโตเป็นประกาย (ตาขวาตกข้างเดียว) ยิ้มอ้ารูป D แก้มชมพู ประกาย 2 ดวง ฟองน้ำลาย แขนวางพุง | หายใจ + กะพริบ | 200 × 200 | `dashboard_pet_image_bubbly` | `dashboard_bubbly.png` |
| `CHEERFUL` (ยิ้มร่าเริง) | `(80, 100]` | `PetPose.dashboardCheerful` | `cheerful` / `normal` | ตา ^ ^ ยิ้มอ้ากว้าง ชูแขนสองข้าง ประกาย 5 ดวง ใบไม้โบก | **กระโดดต่อเนื่อง** `PetTiming.hop` 760 ms/ครั้ง (`hopHeight` 0.05) | 200 × 200 | `dashboard_pet_image_cheerful` | `dashboard_cheerful.png` |

ภาพรวม 4 ท่าที่ 160 px: `docs/_design/preview/dashboard_states_160.png` · ลูป: `docs/_design/preview/fx_dashboard_loops.png`
ขอบที่ต้องตรวจ (D-14): total 30 → crying, 31 → dazed, 60 → dazed, 61 → bubbly, 80 → bubbly, 81 → cheerful · ค่าเฉลี่ย 30.67 → 30 → crying

กติกาการใช้ widget (character.md §6–7):
- `PetCharacter(key: _petKey)` — `_petKey = GlobalKey(debugLabel: 'dashboard_pet')` สร้างครั้งเดียวใน State ของ S-1; key ฟีเจอร์ `dashboard_pet_image_<mood>` อยู่บน `KeyedSubtree` ที่ห่อไว้เท่านั้น (กัน BUG-PET-1)
- map ใน `DashboardLogic.poseFor(mood)` — หน้าจอไม่ switch เอง
- **ไม่ส่ง `cheerTrigger`** (Q-20)
- `animate: widget.animatePet ?? kPetAnimateByDefault` (`pet_animation_policy.dart`)
- `reactToTap` คง default (แตะแล้วกระโดดหน้าตลก; ระหว่างแตะ ลูปกระโดดหยุดชั่วคราว)
- เทสต์ที่ `animate: true` (โดยเฉพาะ CHEERFUL) ใช้ `pump(Duration)` เท่านั้น **ห้าม `pumpAndSettle()`** · Timer หมุนข้อความและ Timer ตรวจรอบวันต้องถูก cancel ใน `dispose`
- anchor ของฟองข้อความอ้างขอบบนของกล่อง `PetCharacter` (`PetKeys.character`)
- ไม่ต้องการท่าใหม่จาก Art (D-12)

## 5. Checklist สำหรับ reviewer

- [ ] ไม่มี hex สีในโค้ด dashboard — สีทั้งหมดมาจาก `Theme.of(context).colorScheme` (seed `Colors.lightBlue` ใน `main.dart`)
- [ ] ไม่แก้ `ThemeData` ใน `app/lib/main.dart`, ไม่เพิ่ม font / package / asset ใน pubspec
- [ ] ไม่มีการโหลด PNG หรือไฟล์ภาพใด ๆ เป็นสัตว์เลี้ยง และไม่แก้ไฟล์ใน `app/lib/shared/pet/`
- [ ] ข้อความบนจอ ตัวเลขเกณฑ์ (30/60/80, 100, 50), `alertIntervalSeconds` 5, `dayCheckIntervalSeconds` 1, `petSize` 200, `alertAnchorOffset` 12, `barMinHeight` 12 อยู่ใน `DashboardRules` ไม่ hardcode ในหน้าจอ; สูตร D-3/D-6/D-7/D-14 และเกณฑ์ D-4/D-13 มีคอมเมนต์ `// ASSUMPTION` / `DECIDED`
- [ ] คะแนนทุกตัวใช้ floor (จำนวนเต็ม `~/`) — 7 แก้ว `87`, 3 แก้ว `37`, 8 แก้ว `100`, 7,999 / 8,000 ก้าว `99`, 1,999 / 2,000 kcal `99`, 2,000 `100`, 2,001 `99`, 2,101 `94`, 2,150 `92`, 3,500 `25`
- [ ] game-rules §3: (60, 90, 60) → `คะแนนสุขภาพรวม: 70%` + `dashboard_pet_image_bubbly`; (70, 60, 67) → `65%` + `dashboard_pet_image_bubbly`; Food −10 → `คะแนนอาหาร: 0%` และ `60%` + `dashboard_pet_image_dazed`; คะแนนดิบเกิน (100, 100, 160) → `100%` + `dashboard_pet_image_cheerful`
- [ ] AppBar ของ `WaterHomeScreen` ลำดับ `steps_entry_button` → `food_entry_button` → `dashboard_entry_button` → `water_monthly_report_button` ทั้งหมดเป็น `IconButton`; `dashboard_entry_button` ใช้ `Icons.dashboard` 24 tooltip 「แดชบอร์ด」 กดแล้วไป S-1
- [ ] `water_monthly_report_button` เป็น `IconButton` ไอคอนปฏิทินเดิม tooltip 「รายงานรายเดือน」 ไม่มี `Text` บนปุ่ม; AppBar ไม่ล้นที่ 360 dp textScaler 1.0 / 1.5
- [ ] S-1 ใช้ `WaterController` / `StepsController` / `FoodController` ตัวเดียวกับที่หน้า water ส่งให้ steps/food (บันทึกน้ำแล้วกลับมา S-1 เห็นแถบน้ำเปลี่ยน)
- [ ] AppBar title 「แดชบอร์ด」 key `dashboard_header_text` และมีปุ่มย้อนกลับอัตโนมัติ
- [ ] S-1 padding 24, ช่องไฟ 8/16/24 ตาม §2.1, pattern `SingleChildScrollView` + `IntrinsicHeight` + `Spacer`
- [ ] ไม่มี RenderFlex overflow บน S-1 ที่จอ 360×640 dp ทั้ง textScaler 1.0 และ 1.5 ทั้งสถานะมีเป้าและไม่มีเป้า (มี CTA)
- [ ] ลำดับจากบนลงล่าง: Total Score Card → ฟองข้อความ → สัตว์เลี้ยง → แถบ Food (→ CTA ถ้าไม่มีเป้า) → Steps → Water
- [ ] Total Score Card key `dashboard_total_score_card` พื้น `primaryContainer` มุม 8 padding 16/8; ข้อความ key `dashboard_total_score_text` = `คะแนนสุขภาพรวม: <n>%` `headlineSmall` สี `onPrimaryContainer`
- [ ] สัตว์เลี้ยงเป็น `PetCharacter` `size: 200` ถือ `GlobalKey` คงที่ ห่อด้วย `KeyedSubtree` key `dashboard_pet_image_<crying|dazed|bubbly|cheerful>`; map ตาม §4 และขอบ 30/31/60/61/80/81 (30.67 → crying)
- [ ] `PetCharacter` ของ dashboard ไม่มี `cheerTrigger`; `animate` = `widget.animatePet ?? kPetAnimateByDefault`
- [ ] ฟองข้อความ key `dashboard_alert_banner` พื้น `secondaryContainer` มุม 8 padding 16/8 เต็มความกว้าง; ข้อความ key `dashboard_alert_text` `bodyMedium` สี `onSecondaryContainer` จัดกลาง ไม่มี `maxLines`/ellipsis
- [ ] ข้อความในฟองตรงตัวทุกอักษร (ไม่รวม `"` ตัวคั่น): 「แต่วันนี้ฉันอิ่มและอืดเกินไปน้าาาา วันต่อไปต้องลดการกินแล้ว」 「ดื่มน้ำๆ」 「ขยับร่างกายหน่อย อีกนิดๆ」 「ฉันหิว」
- [ ] ฟองข้อความไม่ใช่ `SnackBar` / dialog แสดงทีละ 1 ข้อความ; `find.text(P1)` เจอไม่เกิน 1 (ไม่มีข้อความ P1 ซ่อนใน tree)
- [ ] `dashboard_alert_slot` เป็น `FoodSharedMinHeightBox` ที่ min height = ความสูงฟอง P1 ที่วัดจริง (ไม่ใช่ค่าคงที่); ความสูงช่องเท่ากันทุกข้อความและตอนคิวว่าง; `getTopLeft(PetKeys.character)` ไม่ขยับเมื่อข้อความหมุน
- [ ] ขอบล่างของ `dashboard_alert_slot` อยู่สูงกว่าขอบบนของ `PetKeys.character` 12 px พอดี
- [ ] หลัง `pump(5 วินาที)` ข้อความเปลี่ยนเป็นข้อความถัดไปในคิว (ที่ 4.999 วินาทียังไม่เปลี่ยน) และวนกลับต้นคิว; แก้ปัญหาของข้อความที่แสดงอยู่ → ข้อความถัดไปทันที; P1 เข้าคิว → แสดง P1 ทันที (D-15)
- [ ] คิวว่าง → ไม่มี `dashboard_alert_banner` ใน tree แต่ `dashboard_alert_slot` ยังอยู่และสูงเท่าเดิม
- [ ] P2 / P3 อยู่ในคิวเมื่อคะแนน `< 100` (99 ยังอยู่ 100 หลุด — D-8)
- [ ] กินเกินเป้าจน foodScore < 50 (เช่น 3,500 / 2,000) → คิวไม่มี 「ฉันหิว」 (D-13); ยังไม่บันทึกมื้อ → มี 「ฉันหิว」 ทั้งมีและไม่มีเป้า; บันทึกแล้ว foodScore 49 (ไม่เกินเป้า) → มี, 50 → ไม่มี
- [ ] 3 แถบ key `dashboard_food_bar` / `dashboard_steps_bar` / `dashboard_water_bar` เป็น `LinearProgressIndicator` `minHeight: 12` ใน `ClipRRect` มุม 8; `value` = คะแนน ÷ 100
- [ ] ป้ายแถบ key `dashboard_<food|steps|water>_label_text` = `คะแนนอาหาร: <n>%` / `คะแนนการก้าวเดิน: <n>%` / `คะแนนการดื่มน้ำ: <n>%` ชิดซ้าย
- [ ] แถบอาหารสี `colorScheme.error` เมื่อ `FoodController.isOverLimit` (2,101 แดง) และ `primary` เมื่อไม่ใช่ (2,100 ไม่แดง)
- [ ] ไม่มีเป้าอาหาร → ป้าย 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 สี `onSurfaceVariant`, แถบ 0, total = `floor((S + W) / 2)` (100 + 87 → `93%`), ไม่มี P1, มี `food_profile_cta_banner` ใต้แถบอาหารก่อนแถวก้าว (ห่าง 8) พร้อม `food_cta_text` / `food_cta_total_text`
- [ ] กด `food_profile_cta_banner` บน S-1 → เปิด `FoodProfileScreen` ด้วย `FoodController` ตัวเดียวกัน; มีเป้าแล้ว → ไม่มี `food_profile_cta_banner` บน S-1
- [ ] ระหว่างโหลด (controller ใดยัง `!isLoaded`) แสดง `CircularProgressIndicator` อย่างเดียว
- [ ] จำลองเวลาเครื่องข้าม 05:00 ขณะเปิด S-1 (ตรวจทุก 1 วินาที) → ทุกแถบ `0%`, `คะแนนสุขภาพรวม: 0%`, `dashboard_pet_image_crying` ไม่มี dialog/SnackBar; ไม่มีการเรียก network / server time
- [ ] Timer ทั้งหมดของ S-1 ถูก cancel ใน `dispose`; เทสต์ที่ `animate: true` ใช้ `pump(Duration)` ไม่ใช้ `pumpAndSettle()`
- [ ] ไม่มีหน้าจอใหม่นอกจาก S-1 (CTA พาไป S-3 ของ food ที่มีอยู่แล้ว)

## 6. คำถามที่ค้าง

| # | ประเด็น | ทางที่ spec เลือกไว้ชั่วคราว / สถานะ |
|---|---|---|
| Q-1 | ~~Food ไม่มีเป้า: total หาร 2 หรือ 3 และแถบ Food แสดงอะไร~~ | **ปิดแล้ว → D-6** (หาร 2, floor ตาม D-14) และ **D-17** (CTA) · ข้อความ 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 ยังเป็นข้อเสนอ — รอ Design ยืนยันถ้อยคำ |
| Q-2 | ~~Priority 1 เมื่อไม่มีเป้า / ไม่มีทาง "จัดการปัญหาอาหาร"~~ | **ปิดแล้ว → D-10** |
| Q-3 | ~~Priority 4 trigger กับ removal ขัดกัน~~ | **ปิดแล้ว → D-13** (ประเมินสด, ไม่นับ foodScore < 50 เมื่อเกินเป้า) · game-rules §1.1 Priority 4 ยังไม่ได้เขียนข้อยกเว้นกรณีกินเกินเป้า — ให้ Design อัปเดต |
| Q-4 | ~~เกณฑ์ P2/P3: game-rules < 100 vs brief < 80~~ | **ปิดแล้ว → D-8** |
| Q-5 | ~~brief "หลอดแดงแม้คิด 100%" vs D-3~~ | **ปิดแล้ว → D-8** |
| Q-6 | EC-4 / game-rules §1 "Null → 0" ขัดกับ D-3 "ไม่มีเป้า = ไม่คิดคะแนน" | D-6 ใช้กับไม่มีเป้าอาหาร · Null/ติดลบ → 0 ใช้กับค่าที่ผิดรูปแบบทั้ง 3 หมวด (owner รอบ 2 ให้ใช้ค่าของ spec — รอทีมยืนยัน) |
| Q-7 | ~~ux-flow §3 ข้อ 1 สื่อว่า S-1 เป็นหน้าแรก~~ | **ปิดแล้ว → D-9** · ux-flow §3 ข้อ 1 ยังไม่ได้แก้ถ้อยคำ |
| Q-8 | ux-flow ไม่กำหนดหัวข้อ AppBar ของ S-1 และ tooltip ปุ่มทางเข้า | 「แดชบอร์ด」 ทั้งสองจุด (เสนอ — owner รอบ 2 ให้ใช้ตาม spec, รอยืนยัน) |
| Q-9 | fallback 300×300 (ของ PNG) และ art แนะนำ 300 | ใช้ 200 (`DashboardRules.petSize`) — owner รอบ 2 ให้ใช้ตาม spec, รอยืนยัน |
| Q-10 | คิวว่าง: ux-flow/game-rules ไม่บอกหน้าตา (brief §6 ข้อ 3 ให้ซ่อน) | ซ่อนฟอง จองที่ไว้ |
| Q-11 | ~~brief §4 ตัวเลขดิบ/ป้ายโซเดียม-น้ำตาล~~ | **ปิดแล้ว → D-11** |
| Q-12 | ux-flow §2, §5, §6 และ game-rules §2, §5 ยังอ้างไฟล์ภาพ + 300×300 | ยึด D-1 — ให้ Design อัปเดตเอกสาร |
| Q-13 | ~~ช่วง "31-60" vs `(30,60]` และการปัดก่อนตัดสินอารมณ์~~ | **ปิดแล้ว → D-14** (อารมณ์จาก total หลัง floor: 30.67 → 30 = CRYING) · ux-flow §5 / AC-2 ยังเขียนช่วงแบบ "31-60" (เท่ากันบนจำนวนเต็ม) |
| Q-14 | ~~water ไม่มีค่าคงที่เป้าแก้ว~~ | **ปิดแล้ว → D-7** (8 แก้ว; 7 แก้ว = 87 ตาม D-14) |
| Q-15 | ux-flow §3–4, game-rules §1/§4, requirements AC-5 อ้าง "Server Time" / "ICT" / "Session Database" | ยึด D-2 — ให้ Design/Product อัปเดตเอกสาร |
| Q-16 | ~~การปัดเศษ foodScore / total แบบ round~~ | **ปิดแล้ว → D-14** (floor ทุกคะแนน) |
| Q-17 | ~~brief "คัดออกในรอบ 5 วินาทีถัดไป" vs game-rules "ทันที"~~ | **ปิดแล้ว → D-8** |
| Q-18 | ตำแหน่งฟองข้อความ: ux-flow §2 ไม่บอกลำดับบนจอ, brief §3 "เหนือหัวสัตว์เลี้ยง" | เหนือหัวสัตว์เลี้ยง 12 px (owner รอบ 2 ให้ใช้ตาม spec, รอยืนยัน) |
| Q-19 | ~~การหมุนเริ่มจากข้อความไหนเมื่อคิวเปลี่ยน~~ | **ปิดแล้ว → D-15** · game-rules ยังไม่ได้เขียนกฎนี้ |
| Q-20 | ux-flow ไม่มีการฉลองเมื่ออารมณ์ขยับขึ้น | ไม่ใช้ `cheerTrigger` (owner รอบ 2 ให้ใช้ตาม spec) |
| Q-21 | `"` ในข้อความแจ้งเตือนของเอกสารเป็นส่วนของข้อความหรือตัวคั่น | ตัวคั่น — แสดงไม่รวม `"` (owner รอบ 2 ให้ใช้ตาม spec) |
| Q-22 | **ถึง Design (B):** game-rules §3 แถว 2 และ requirements EC-5 เขียน (70, 60, 67) → 65.66 → **66** แต่ D-14 (floor) ให้ **65** (ยัง BUBBLY) | ต้องแก้ game-rules §3 แถว 2 และ EC-5 จาก 66 เป็น 65 (และคำว่า "ปัดเศษ" เป็น "ปัดลง") · brief §1 / §6 ข้อ 2 ที่อ้าง `Math.round` ก็ขัดกับ D-14 เช่นกัน · UI ไม่ได้แก้ไฟล์เหล่านั้น |
| Q-23 | **โค้ดต่างจาก spec:** spec เดิมกำหนด body เป็น `ListenableBuilder(listenable: Listenable.merge([water, steps, food]))` แต่โค้ดฟัง `DashboardController` (ChangeNotifier ที่ฟัง 3 controller แล้ว notify ต่อ + ถือสถานะฟองข้อความ/Timer) | หน้าตาและการอัปเดตเท่ากัน — spec ผ่อนเป็น "ฟังค่าจากทั้ง 3 controller" (§2.1) · รอ UI/QA ยืนยันว่ายอมรับ (ไม่ได้มีข้อตัดสิน owner) |
| Q-24 | **โค้ดต่างจาก spec:** spec เดิมให้ฟองข้อความเต็มช่อง (`Positioned.fill` สูงเท่าช่อง) แต่โค้ด (dev A-12) วางฟอง `Center` เต็มความกว้าง สูงตามข้อความที่แสดง — ข้อความสั้น (เช่น 「ดื่มน้ำๆ」) ได้ฟองเตี้ยกว่าช่อง จัดกลางแนวตั้ง ช่องยังสูงเท่าเดิม | spec บันทึกตามโค้ดใน §2.1.1 ชั่วคราว (ไม่กระทบตำแหน่งสัตว์เลี้ยง/anchor 12 px) · ข้อดีของแบบเต็มช่อง: ขอบฟองไม่ขยับขึ้นลงเมื่อข้อความหมุน — รอ owner/UI เลือก |
| Q-25 | D-17 ใช้ CTA เดิมของ food ซึ่งแสดงยอดรวม `<total> kcal` (ตัวเลขดิบ) — ขัดกับ D-11 "ไม่แสดงตัวเลขดิบ" เล็กน้อย · สถานะไม่มีเป้าทำให้หน้ายาว ≈ 628 dp → ที่ 360×640 ต้องเลื่อน ~70 dp (แถบน้ำอาจอยู่ใต้ขอบจอ) | ยอมรับตาม D-17 (ใช้ CTA เดิมทั้งชิ้น) · ถ้าต้องการให้พอดีจอ ทางเลือก: ลดสัตว์เลี้ยงเป็น 160 เฉพาะสถานะนี้ หรือให้ CTA แทนแถวอาหาร — รอ owner (dev QD-6) |
| Q-26 | CTA บน dashboard ใช้ keys ของ food (`food_profile_cta_banner` ฯลฯ) ไม่ใช่ prefix `dashboard_` (dev QD-7) | ใช้ keys ของ food ตาม D-17 — ถ้าภายหลังมี S-1 ของ food กับ dashboard อยู่ใน stack พร้อมกัน เทสต์ต้องค้นใต้ `DashboardScreen` (`find.descendant`) |
| Q-27 | (ข้อสังเกต ไม่ใช่ของ dashboard) body ของ `WaterHomeScreen` ไม่มี scroll และล้นแนวตั้ง ~68 px ที่ 360×640 textScaler 1.5 (มีมาก่อน — dev/QA log) | ไม่อยู่ในขอบเขต spec นี้ — แนะนำให้ water ใช้ pattern scroll + `IntrinsicHeight` แบบ steps/food |
