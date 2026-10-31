# UI spec: ประวัติสุขภาพ 7 วันและสรุปภาพรวมสัปดาห์ (7day)

> สถานะ: draft (2026-10-31 รอบ 1) · ผู้เขียน: UI agent · อ้างอิง: ux-flow.md, game-rules.md (บริบท: requirements.md, brief.md, design-review.md)
> เอกสารนี้กำหนด "หน้าตา" เท่านั้น — ตัวเลข กติกา และ flow ให้ยึด ux-flow.md / game-rules.md และข้อตัดสิน owner ใน §0 (ข้อตัดสินชนะเอกสารเมื่อขัดกัน)
> design language ยึดตาม `docs/dashboard/ui-spec.md`, `docs/food/ui-spec.md` (และ steps / signup) และโค้ดจริงใน `app/lib/` — ไม่สร้างระบบดีไซน์ใหม่
> **ไม่มีสัตว์เลี้ยงในฟีเจอร์นี้** (requirements §5 Out of scope, game-rules §2) — ไม่ใช้ `PetCharacter`

## 0. ข้อตัดสินใจที่มีผลต่อ UI

ข้อ D-1 ถึง D-5 เป็นการตัดสินใจของเจ้าของโปรเจกต์ ไม่ใช่ของ UI agent — **DECIDED (owner ตัดสินไปก่อน, ทีมตรวจตอนรีวิว PR), 2026-10-31** — spec นี้แค่กำหนดหน้าตาให้รองรับ · D-6, D-7 เป็นข้อตกลงระดับแอป/เอกสารที่มีอยู่แล้ว

| # | ข้อตัดสินใจ (ที่มา) | ผลต่อ UI |
|---|---|---|
| D-1 | **OQ-01 (design-review §3, requirements §7 ข้อ 1):** การ์ดรายวันพับ/ขยายแบบ Accordion มี animation **250ms** ตาม ux-flow §6 ข้อ 1 / game-rules §5 ข้อ 1 — ไม่ใช้ fallback แบบ Instant Toggle | DAY_CARD ใช้ `ExpansionTile` (Accordion มาตรฐานของ Material) + `expansionAnimationStyle: AnimationStyle(duration: SevenDayRules.accordionDuration /* 250 ms */)` — §2.1.3 |
| D-2 | **OQ-02 / แหล่งข้อมูล:** ใช้ข้อมูลในเครื่องเท่านั้น — ไม่มี Server Cache, ไม่มี network, ไม่มีสถานะ OFFLINE · ux-flow §4 แถว OFFLINE และ EC-5 → การทำงานปกติจากข้อมูลในเครื่อง | ไม่มี UI ออฟไลน์ / ไอคอน / ข้อความ / dialog เรื่องเครือข่าย · ไม่มีแถว OFFLINE ใน §3 (หน้าตาเท่าสถานะ NORMAL/INCONSISTENT/EMPTY ตามข้อมูล) · ใช้แทนคำว่า "Server Cache" ใน requirements §6, ux-flow §3 ข้อ 3 |
| D-3 | **เก็บประวัติ 30 วัน** (`LOCAL_CACHE_RETENTION_DAYS` = 30, game-rules §1) · food ต้องเปลี่ยนการตัดประวัติจาก 7 วันเป็น 30 วัน (`FoodRules.historyRetentionDays` ที่ `food_logic.dart` `pruneHistory` ใช้) — **งาน Dev ไม่ใช่งาน UI** | S-1 แสดงเพียง 7 วัน (`MAX_HISTORY_DAYS`) — retention ไม่เปลี่ยนหน้าตา · spec แค่อ้าง |
| D-4 | **นับ 7 วันแบบรวมวันนี้** (Day 0 ถึง Day −6) **ตัดรอบ 05:00 เวลาเครื่อง** เหมือนทุกฟีเจอร์ (water / steps / food / dashboard D-2) — ใช้แทน "ICT / UTC+7 / Server Time" ใน brief §1, requirements §1/US-3, ux-flow §3 ข้อ 2, game-rules §1 `DATE_NORMALIZER_HOUR` | วันที่บนการ์ด = วันตามรอบ 05:00 (logical day) · ข้ามรอบ = §3 แถว "ข้ามรอบ 05:00" |
| D-5 | **ดึงข้อมูลจาก repository / controller เดิม** ของ water, steps, food — ห้ามเก็บข้อมูลซ้ำ | S-1 รับ `WaterController` / `StepsController` / `FoodController` ตัวเดียวกับที่หน้า water ใช้ (แบบ `DashboardScreen`) — ตารางช่องข้อมูล → ฟิลด์ใน §2.2 · ไม่มี repository / key ใน shared_preferences ใหม่ |
| D-6 | (เอกสาร — ไม่ใช่ข้อตัดสินใหม่) ไม่แสดงสัตว์เลี้ยง (requirements §5, game-rules §2 N/A) | ไม่มี `PetCharacter`, ไม่ import `shared/pet/` — §4 |
| D-7 | (ระดับแอป — ไม่ใช่ข้อตัดสินใหม่) หน้า home คือ `WaterHomeScreen` และฟีเจอร์อื่นเข้าทาง `IconButton` ใน `AppBar.actions` (dashboard ui-spec D-5, D-9, D-18) | ทางเข้า S-1 ใช้ pattern เดียวกัน — §2.0, Q-1 |

## 1. Design tokens

ทุกสีดึงจาก `Theme.of(context).colorScheme` / `textTheme` เท่านั้น — **ห้าม hardcode hex** ในโค้ด 7day (seed `Colors.lightBlue` ใน `app/lib/main.dart` → `ColorScheme.fromSeed`) · ไม่แก้ `ThemeData` · ไม่เพิ่ม font / package / asset

### 1.1 สี

| Token | ค่า | ใช้ที่ไหน | ที่มา |
|---|---|---|---|
| Seed color | `Colors.lightBlue` | ทุก ColorScheme | `app/lib/main.dart` |
| SUMMARY_CARD — พื้น / ตัวอักษร | `colorScheme.primaryContainer` / `colorScheme.onPrimaryContainer` | S-1 #1 ทั้งการ์ด (หัวข้อ ค่าเฉลี่ย coaching) | ของเดิม: `dashboard_total_score_card` (dashboard ui-spec §1.1) — ใช้แทน `summary_card_bg.png` (Q-6) |
| DAY_CARD — พื้น | default ของ `Card` M3 (ไม่ตั้ง `color`) | S-1 #3 การ์ดรายวัน 7 ใบ | ของเดิม: `steps_report_summary_card` (`steps_monthly_report_screen.dart`) |
| ข้อความรองบนการ์ดรายวัน (แถบสรุปตอนพับ, 「ไม่มีข้อมูล」) | `colorScheme.onSurfaceVariant` | S-1 #3 subtitle / body ว่าง | role เดิม: ป้าย 「คะแนนอาหาร: ยังไม่มีเป้าหมาย」 ของ dashboard |
| ไอคอนลูกศรพับ/ขยาย | default ของ `ExpansionTile` (`iconColor` / `collapsedIconColor` ไม่ตั้ง) | S-1 #3 trailing | default M3 — ใช้แทน `card_expanded_icon.png` / `card_collapsed_icon.png` (Q-6) |
| ป้ายเตือนพิเศษ (โซเดียมสูง / น้ำตาลสูง / Overeating) | พื้น `colorScheme.errorContainer`, ตัวอักษร `colorScheme.onErrorContainer` | S-1 #3 body ของการ์ดที่ขยาย | ของเดิม: ป้าย `food_full_badge` 「อิ่มแล้ว」 (food ui-spec §1.1) |
| EMPTY_STATE_CONTAINER — ไอคอน | `colorScheme.onSurfaceVariant` | S-1 #2 (เฉพาะ EMPTY) | role เดิม (เท่าข้อความรอง) — ใช้แทน `empty_history_illustration.png` (Q-6) |
| EMPTY_STATE_CONTAINER — ข้อความ | default (`onSurface`) | S-1 #2 | default Text |

ไม่มีสี green / orange / red ตามระดับเป้าหมาย (brief §3 "Color Highlighting") — ไม่มีใน ux-flow / game-rules และ ColorScheme ไม่มี role สีเขียว (ต้องตั้ง hex ใหม่) → Q-5
ไม่มีสถานะ disabled บน S-1 (ไม่มีปุ่ม/ช่องกรอก — ux-flow §2)

### 1.2 ตัวอักษร

ไม่มี custom font ใน `app/pubspec.yaml` → `Theme.of(context).textTheme` เท่านั้น

| ใช้กับ | style | ที่มา |
|---|---|---|
| AppBar title | default ของ `AppBar` | ทุกหน้า |
| หัวข้อ SUMMARY_CARD 「สรุปภาพรวมรอบ 7 วัน」 | `textTheme.titleMedium` + `onPrimaryContainer` | role เดิม: `signup_gender_label`, `food_full_badge` |
| บรรทัดค่าเฉลี่ย 3 บรรทัด | `textTheme.bodyLarge` + `onPrimaryContainer` | role เดิม (default ของ `TextField` / `ListTile.title` M3) |
| Coaching text (prefix + คำแนะนำ) | `textTheme.bodyMedium` + `onPrimaryContainer` | role เดิม: `dashboard_alert_text`, `food_cta_text` |
| หัวการ์ดรายวัน `วันนี้, {date_str}` / `{day_label}, {date_str}` | `textTheme.titleMedium` | role เดิม |
| แถบสรุปตอนพับ / 「ไม่มีข้อมูล」 | `textTheme.bodyMedium` + `onSurfaceVariant` | role เดิม |
| บรรทัดรายละเอียดตอนขยาย (การเดิน / การดื่มน้ำ / แคลอรี) | `textTheme.bodyMedium` (default) | `dashboard_<…>_label_text` |
| ป้ายเตือนพิเศษ | `textTheme.labelLarge` + `onErrorContainer` | role เดิมใน textTheme — **การใช้ role ใหม่** เหตุผล: ป้ายเล็ก 3 ใบต้องวางแถวเดียวบนจอ 360 dp; `titleMedium` ของ `food_full_badge` ใหญ่เกินเมื่อมีหลายใบ |
| ข้อความ EMPTY | `textTheme.bodyLarge`, จัดกลาง | role เดิม |

### 1.3 ระยะห่าง ขนาด มุมโค้ง เวลา

| Token | ค่า | ที่มา |
|---|---|---|
| Padding หน้า (S-1) | 16 รอบด้าน | หน้ารายงาน/รายการ: `monthly_report_screen.dart`, `steps_monthly_report_screen.dart` → `EdgeInsets.all(16)` (S-1 เป็นหน้ารายการ ไม่ใช่หน้าหลักที่มีสัตว์เลี้ยง ซึ่งใช้ 24) |
| ช่องไฟ | 8 / 16 (`SizedBox`) | `water_home_screen.dart` |
| ระยะ SUMMARY_CARD ↔ การ์ดรายวันใบแรก | 16 | ช่องไฟเดิม |
| ระยะระหว่างการ์ดรายวัน | 8 | ช่องไฟเดิม |
| Padding ใน SUMMARY_CARD | 16 รอบด้าน | ค่า 16 เดิม (padding หน้าฟอร์ม/รายงาน) — การ์ดหลายบรรทัด ไม่ใช่กล่องบรรทัดเดียวแบบ 16/8 |
| มุมโค้ง SUMMARY_CARD | `BorderRadius.circular(8)` | `dashboard_total_score_card` |
| DAY_CARD | `Card(margin: EdgeInsets.zero, clipBehavior: Clip.antiAlias)` shape default M3 | `steps_report_summary_card` (เพิ่ม `margin: zero` ให้ระยะคุมด้วย `SizedBox` และ `antiAlias` ให้ ripple ไม่ล้นมุม) |
| ExpansionTile padding | `tilePadding` default (แนวนอน 16) · `childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 16)` | default ListTile / ค่า 16 เดิม |
| ระยะบรรทัดในการ์ดที่ขยาย | 8 | ช่องไฟเดิม |
| ป้ายเตือนพิเศษ | `Container` padding แนวนอน 8 แนวตั้ง 4, `BorderRadius.circular(8)` · วางใน `Wrap(spacing: 8, runSpacing: 8)` | **ใหม่ (padding 8/4)** — เหตุผล: ป้ายแบบ `food_full_badge` (16/8 + `titleMedium`) 3 ใบไม่พอดีแถวเดียวที่ 360 dp; มุม 8 เท่าเดิม · `Wrap` ขึ้นบรรทัดใหม่เองเมื่อ textScaler 1.5 |
| ขนาดไอคอนลูกศร | 24 (default ของ `ExpansionTile`) | `AssetImageOrIcon.size` default 24 |
| ขนาดไอคอน EMPTY | 48 — `SevenDayRules.emptyIconSize` | **ใหม่** — เหตุผล: ใช้แทนภาพประกอบ `empty_history_illustration.png` (Q-6) ต้องใหญ่กว่าไอคอนปุ่ม 24 เพื่อเป็นภาพประกอบ แต่เล็กพอไม่ดันการ์ดรายวันลงที่ 360×640 · 48 = 2 × 24 ตาม grid 8 |
| ระยะเวลา Accordion | 250 ms — `SevenDayRules.accordionDuration` | ux-flow §6 ข้อ 1, D-1 |
| ความถี่ตรวจรอบวัน | 1 วินาที + เมื่อแอป resume — `SevenDayRules.dayCheckIntervalSeconds` | แบบ `DashboardRules.dayCheckIntervalSeconds` (dashboard D-15) |
| Loading ทั้งหน้า | `Center(CircularProgressIndicator())` | water / steps / food / dashboard ตอน `!isLoaded` |
| ความสูงทุกกล่อง | **ไม่ล็อกความสูง** — ทุก Text ไม่มี `maxLines` / ellipsis (ข้อความต้องครบตรงตัว) กล่องโตตามเนื้อหา | บทเรียน food D-5 / dashboard D-16 |

## 2. หน้าจอ

ux-flow มีหน้าจอเดียว: **S-1 หน้าประวัติสุขภาพ 7 วัน (7-Day Health History Screen)** — spec ไม่เพิ่มหน้าจออื่น
ข้อความใน「」คัดลอกตรงตัวจาก ux-flow.md / game-rules.md — ห้ามแก้ · เครื่องหมาย `"` ที่ครอบข้อความในเอกสารเป็นตัวคั่น ไม่ใช่ส่วนของข้อความบนจอ (แบบ dashboard Q-21) · ข้อความที่เอกสารไม่มีและ spec เสนอไว้ชั่วคราว ระบุว่า **(เสนอ — รอยืนยัน)**
ข้อความบนจอทุกข้อความ และค่าตัวเลข (`MAX_HISTORY_DAYS`, `WATER_GOAL_THRESHOLD`, `STEPS_GOAL_THRESHOLD`, `LOCAL_CACHE_RETENTION_DAYS`, `accordionDuration`, `dayCheckIntervalSeconds`, `emptyIconSize`) อ่านจาก `SevenDayRules` (เสนอ `app/lib/features/seven_day/seven_day_rules.dart` — ชื่อโฟลเดอร์/คลาสขึ้นต้นด้วยตัวอักษรเพราะ Dart identifier ขึ้นต้นด้วยตัวเลขไม่ได้) — ห้าม hardcode ในหน้าจอ
ValueKey ใช้ prefix `seven_day_` ทั้งหมด

**รูปแบบตัวเลข** (ใช้ฟังก์ชันเดิม ไม่เขียนใหม่):
- ค่าเฉลี่ย `{val}` ทั้ง 3 หมวด: ทศนิยม 1 ตำแหน่ง + comma คั่นหลักพัน — `StepsLogic.formatAverage` (`steps_logic.dart`) เช่น `6.5`, `8.0`, `7,240.5`, `1,850.0` (Q-12)
- ค่ารายวัน: ก้าวและ kcal = จำนวนเต็ม + comma — `StepsLogic.formatThousands` เช่น `5,500`, `1,250` · แก้ว = จำนวนเต็มไม่มี comma เช่น `6` (water เก็บเป็น `int` — Q-13)
- `{date_str}` = `dd/MM/yyyy` — `WaterLogic.formatHistoryDate` (รูปแบบวันที่ที่ water ตัดสินไว้แล้ว) เช่น `31/10/2026` (Q-11)

### 2.0 ทางเข้า S-1 จากหน้า water (D-7)

- ux-flow §3 ข้อ 1: 「ผู้ใช้แตะเลือกเมนู "ประวัติ 7 วัน" จากหน้าหลักของแอป」 → ปุ่มในหน้า home (`WaterHomeScreen`)
- ตำแหน่ง: `AppBar.actions` ของ `WaterHomeScreen` ลำดับ `steps_entry_button` → `food_entry_button` → `dashboard_entry_button` → **`seven_day_entry_button`** → `water_monthly_report_button`
- Widget: `IconButton` แบบเดียวกับปุ่มเดิม — `Icon(Icons.history, size: 24)`, `tooltip:` 「ประวัติ 7 วัน」 (`SevenDayRules.entryTooltip` — ข้อความจาก ux-flow §3 ข้อ 1) · ไม่มีข้อความบนปุ่ม
- ความกว้าง: 5 × 48 = 240 dp — ที่จอ 360 dp เหลือ ~104 dp ให้ title 「PetPal Health」 ซึ่งตัด ellipsis ตาม default ของ `AppBar` (ไม่ล้น) · `IconButton` ไม่ขยายตาม textScaler → ไม่ล้นทั้ง textScaler 1.0 และ 1.5 (เหมือน dashboard D-18) · ปุ่มที่ 6 ในอนาคตจะไม่พอ → Q-1
- กดแล้ว `Navigator.push(MaterialPageRoute(...))` ไป `SevenDayHistoryScreen` (แบบ `_openDashboard`) ส่ง `waterController: _controller`, `stepsController: _stepsController()`, `foodController: _foodController()` — controller ตัวเดียวกับที่ steps / food / dashboard ใช้ (D-5)
- ValueKey: `seven_day_entry_button`
- ห้ามแก้ส่วนอื่นของ `WaterHomeScreen`

### 2.1 S-1 หน้าประวัติสุขภาพ 7 วัน (7-Day Health History Screen)

จุดประสงค์ (ux-flow §1): แสดงการ์ดสรุปภาพรวมสัปดาห์ (Weekly Summary Card) และการ์ดรายวัน 7 วันแบบพับเก็บได้ (Collapsible Cards) เพื่อให้ผู้ใช้ตรวจสถิติการกิน การเดิน และการดื่มน้ำย้อนหลัง

โครง: `Scaffold` → `AppBar` → body `ListenableBuilder` ที่ฟังทั้ง 3 controller (`Listenable.merge` หรือ controller รวมแบบ `DashboardController` — อัปเดตทันทีเมื่อค่าใดเปลี่ยน) → controller ใดยัง `!isLoaded` = `Center(CircularProgressIndicator())` → `SafeArea` → `SingleChildScrollView` → `Padding(16)` → `Column(crossAxisAlignment: stretch)`
- ใช้ `SingleChildScrollView` + `Column` (ไม่ใช้ `ListView.builder`) — มีแค่ 8 ชิ้น และทุกการ์ดต้องอยู่ใน widget tree ให้เทสต์หา Day −6 ได้โดยไม่ต้องเลื่อน
- ไม่มีภาพพื้นหลัง — พื้น `colorScheme.surface` default
- เข้าหน้า: เรียกตรวจรอบวันของทั้ง 3 controller แบบ `DashboardController.start()` (load ถ้ายังไม่โหลด / refresh ถ้าโหลดแล้ว) แล้วตรวจซ้ำทุก 1 วินาทีและเมื่อ resume (§1.3) — Timer ต้อง cancel ใน `dispose`

จากบนลงล่าง:

| # | องค์ประกอบ (ux-flow §2) | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 0 | APP_BAR_TITLE | `AppBar(title: Text(...))` — ปุ่มย้อนกลับอัตโนมัติ (ถูก push) | 「ประวัติสุขภาพ 7 วัน」 | AppBar default | `seven_day_header_text` (บน `Text`) |
| 1 | SUMMARY_CARD — **ไม่แสดงในสถานะ EMPTY** (§3) | §2.1.1 | หัวข้อ + ค่าเฉลี่ย 3 บรรทัด + coaching | §1.1–1.3 | `seven_day_summary_card` |
| 2 | EMPTY_STATE_CONTAINER — **แสดงเฉพาะ EMPTY แทน #1** | §2.1.2 | 「ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้」 | §1.1–1.3 | `seven_day_empty_state`, `seven_day_empty_text` |
| — | `SizedBox(height: 16)` | | | | |
| 3 | DAY_CARD_0 … DAY_CARD_6 | 7 × §2.1.3 เรียง Day 0 (บนสุด) → Day −6 คั่นด้วย `SizedBox(height: 8)` ห่อทั้งชุดด้วย `KeyedSubtree(key: ValueKey('seven_day_window_<yyyy-MM-dd ของ Day 0>'))` | ตาม §2.1.3 | §1.3 | `seven_day_day_card_<i>` (i = 0…6) |

- สิ่งที่กดได้: ปุ่มย้อนกลับของ AppBar และหัวการ์ดรายวันแต่ละใบ — SUMMARY_CARD / EMPTY / ป้ายไม่กดได้ · ไม่มีการแก้ข้อมูลย้อนหลัง (requirements §5)
- ไม่มีกราฟ / แถบความคืบหน้า (requirements §5)
- งบความสูงที่ 360×640 dp textScaler 1.0 (body ≈ 560): 16 + SUMMARY (≈ 16 + 24 + 8 + 3×24 + 8 + coaching 2–6 บรรทัด×20 + 16 ≈ 180–260) + 16 + Day 0 ขยาย (≈ 56 + 3×28 + ป้าย 32 ≈ 170) + 6 × (56 + 8) ≈ 750–830 → **หน้าเลื่อนได้** (ตั้งใจ) · ทุกขนาดจอ/textScaler ต้องไม่มี RenderFlex overflow

#### 2.1.1 SUMMARY_CARD

`Container(key: seven_day_summary_card, padding: EdgeInsets.all(16), decoration: BoxDecoration(color: primaryContainer, borderRadius: BorderRadius.circular(8)))` เต็มความกว้าง → `Column(crossAxisAlignment: start)`:

| # | ส่วน | ข้อความ (ux-flow §2 SUMMARY_CARD) | style | ValueKey |
|---|---|---|---|---|
| a | หัวข้อ | 「สรุปภาพรวมรอบ 7 วัน」 | `titleMedium` + `onPrimaryContainer` | `seven_day_summary_title_text` |
| — | `SizedBox(height: 8)` | | | |
| b | ค่าเฉลี่ยน้ำ | `ค่าเฉลี่ยการดื่มน้ำ: {val} แก้ว` เช่น `ค่าเฉลี่ยการดื่มน้ำ: 6.5 แก้ว` · หมวดนี้ไม่มีวันที่มีบันทึกเลย → `ค่าเฉลี่ยการดื่มน้ำ: ไม่มีข้อมูล` **(เสนอ — Q-8)** | `bodyLarge` + `onPrimaryContainer` | `seven_day_avg_water_text` |
| c | ค่าเฉลี่ยก้าว | `ค่าเฉลี่ยการเดิน: {val} ก้าว` เช่น `ค่าเฉลี่ยการเดิน: 7,240.5 ก้าว` (ไม่มีข้อมูล → `ค่าเฉลี่ยการเดิน: ไม่มีข้อมูล`) | เดียวกับ b | `seven_day_avg_steps_text` |
| d | ค่าเฉลี่ยแคลอรี | `ค่าเฉลี่ยแคลอรี: {val} kcal` เช่น `ค่าเฉลี่ยแคลอรี: 1,850.0 kcal` (ไม่มีข้อมูล → `ค่าเฉลี่ยแคลอรี: ไม่มีข้อมูล`) | เดียวกับ b | `seven_day_avg_food_text` |
| — | `SizedBox(height: 8)` — **เฉพาะเมื่อมี coaching อย่างน้อย 1 บรรทัด** | | | |
| e | Coaching — prefix (เฉพาะ INCONSISTENT `0 < count < 7`) | 「มีการบันทึกไม่สม่ำเสมอ จากข้อมูลการบันทึกเท่าที่มีพบว่า...」 | `bodyMedium` + `onPrimaryContainer` | `seven_day_coaching_prefix_text` |
| f | Coaching — น้ำต่ำ (`WARNING_LOW_WATER`) | 「ดื่มน้ำเฉลี่ยวันละ {val} แก้ว น้อยไปน้า พยายามกินน้ำมากกว่านี้ แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ」 (`{val}` = ค่าเดียวกับบรรทัด b) | เดียวกับ e | `seven_day_coaching_water_text` |
| g | Coaching — ก้าวต่ำ (`WARNING_LOW_STEPS`) | 「เดินเฉลี่ยวันละ {val} ก้าว ขยับอีกนิดน้าเพื่อสุขภาพที่แข็งแรง แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ」 (`{val}` = ค่าเดียวกับบรรทัด c) | เดียวกับ e | `seven_day_coaching_steps_text` |

- บรรทัด e, f, g เป็น `Text` แยกกันคนละบรรทัด เรียง prefix → น้ำ → ก้าว (game-rules §1.1 หมายเหตุ: "คนละบรรทัด โดยค่าน้ำขึ้นก่อนแล้วตามด้วยก้าวเดิน") คั่นด้วย `SizedBox(height: 4)` — **ใหม่ (4)** เหตุผล: บรรทัดในย่อหน้าเดียวกัน ระยะ 8 ทำให้ดูเป็นคนละกลุ่ม · ไม่มี `maxLines` · prefix เป็นบรรทัดของตัวเอง (ไม่ต่อท้ายบรรทัดเดียวกับคำแนะนำ — Q-9)
- เงื่อนไขขึ้น/ไม่ขึ้นของ e/f/g: game-rules §1.1 (ไม่เขียนซ้ำ) · การตัดสิน `< 8.0` / `< 8000.0` เทียบค่าที่ปัด 1 ตำแหน่งแล้ว (ค่าเดียวกับที่แสดง) **(ชั่วคราว — Q-10)** · หมวดที่ไม่มีข้อมูล → ไม่มีบรรทัดเตือนของหมวดนั้น (Q-8)
- กรณีปกติ (count = 7 และไม่เข้าเกณฑ์เตือน) → ไม่มี coaching (ไม่มี e/f/g และไม่มี SizedBox ก่อนหน้า) — เอกสารไม่มีข้อความกรณีปกติ (Q-7)
- ห้ามใช้ `Image.asset('assets/images/7day/summary_card_bg.png')` (Q-6)

#### 2.1.2 EMPTY_STATE_CONTAINER (เฉพาะสถานะ EMPTY)

`Padding(padding: EdgeInsets.symmetric(vertical: 16))` key `seven_day_empty_state` → `Column(mainAxisSize: min)`:
- `Icon(Icons.inbox_outlined, size: SevenDayRules.emptyIconSize /* 48 */, color: onSurfaceVariant)` key `seven_day_empty_icon` — กล่องเปล่าแทน `empty_history_illustration.png` (ux-flow §5 "ภาพกราฟิกไอคอนกล่องเปล่า Minimal") · ไม่มีสัตว์เลี้ยง
- `SizedBox(height: 8)`
- `Text(「ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้」, textAlign: center, style: bodyLarge)` key `seven_day_empty_text`
- ข้อความนี้มีในจอ **1 จุดเท่านั้น** (`find.text` เจอ 1) — SUMMARY_CARD ซ่อน จึงไม่มี coaching `STATUS_EMPTY_7DAYS` ซ้ำ (Q-3)

#### 2.1.3 DAY_CARD (ใช้ร่วมกัน 7 ใบ)

`Card(key: seven_day_day_card_<i>, margin: EdgeInsets.zero, clipBehavior: Clip.antiAlias)` → `ExpansionTile`:

| property | ค่า |
|---|---|
| `key` | `ValueKey('seven_day_day_tile_<i>')` |
| `initiallyExpanded` | `i == 0` (AC-1: Day 0 `expanded = true`, Day −1…−6 `expanded = false`) |
| `expansionAnimationStyle` | `AnimationStyle(duration: SevenDayRules.accordionDuration)` = 250 ms (D-1) |
| `shape` / `collapsedShape` | `const Border()` (ไม่มีเส้นขอบบน/ล่างของ tile — ขอบเป็นของ `Card`) |
| `title` | `Text(<หัวการ์ด>, style: titleMedium)` key `seven_day_day_title_<i>` — Day 0: `วันนี้, {date_str}` เช่น `วันนี้, 31/10/2026` · Day −1…−6: `{day_label}, {date_str}` เช่น `เมื่อวาน, 30/10/2026`, `วันอังคาร, 27/10/2026` — `{day_label}` ดูด้านล่าง |
| `subtitle` | **เฉพาะตอนพับ** — `Text(<แถบสรุป>, style: bodyMedium + onSurfaceVariant)` key `seven_day_day_summary_<i>`: วันมีบันทึก = `{steps_val} ก้าว · {water_val} แก้ว · {food_val} kcal` เช่น `5,500 ก้าว · 6 แก้ว · 1,250 kcal` **(เสนอ — รอยืนยัน, Q-14)** · วันไม่มีบันทึก = 「ไม่มีข้อมูล」 · ตอนขยาย `subtitle: null` |
| `trailing` | ไม่ตั้ง → ไอคอนลูกศร default (`Icons.expand_more` หมุนเป็นชี้ขึ้นตอนขยาย พร้อม animation 250 ms) แทน PNG 2 ไฟล์ (Q-6) |
| `expandedCrossAxisAlignment` / `expandedAlignment` | `CrossAxisAlignment.start` / `Alignment.centerLeft` |
| `childrenPadding` | `EdgeInsets.fromLTRB(16, 0, 16, 16)` |
| `children` (ตอนขยาย) | ดูด้านล่าง — ห่อด้วย `Column(key: seven_day_day_body_<i>, crossAxisAlignment: start)` |
| `maintainState` | `false` (default) — ตอนพับเสร็จ body ไม่อยู่ใน tree |

body ตอนขยาย (ux-flow §2 DAY_CARD_0 — ลำดับ การเดิน → การดื่มน้ำ → แคลอรี):
- วันมีบันทึก:
  1. `การเดิน: {steps_val} ก้าว` key `seven_day_day_steps_<i>`
  2. `SizedBox(height: 8)` · `การดื่มน้ำ: {water_val} แก้ว` key `seven_day_day_water_<i>`
  3. `SizedBox(height: 8)` · `แคลอรี: {food_val} kcal` key `seven_day_day_food_<i>`
  4. ถ้ามีป้ายอย่างน้อย 1: `SizedBox(height: 8)` · `Wrap(spacing: 8, runSpacing: 8)` key `seven_day_day_tags_<i>` → ป้ายเรียง 「โซเดียมสูง」 → 「น้ำตาลสูง」 → 「Overeating」 (ข้อความจาก requirements §6 / brief §3) แต่ละใบ `Container(padding: h8 v4, color errorContainer, radius 8)` → `Text(labelLarge + onErrorContainer)` keys `seven_day_tag_high_sodium_<i>` / `seven_day_tag_high_sugar_<i>` / `seven_day_tag_overeating_<i>` · ไม่มีป้าย = ไม่มี `Wrap` · ไม่มีหัวข้อ "ป้ายเตือนพิเศษ" บนจอ
  - หมวดที่ไม่มีบันทึกในวันที่หมวดอื่นมีบันทึก แสดง `0` (เช่น `การดื่มน้ำ: 0 แก้ว`) — Q-8
- วันไม่มีบันทึก: `Text(「ไม่มีข้อมูล」, style: bodyMedium + onSurfaceVariant)` key `seven_day_day_no_data_<i>` แทนบรรทัด 1–4 (AC-2)

`{day_label}` **(เสนอ — รอยืนยัน, Q-11)**: Day −1 = 「เมื่อวาน」 · Day −2…−6 = ชื่อวันในสัปดาห์ของวันที่นั้น 「วันจันทร์」「วันอังคาร」「วันพุธ」「วันพฤหัสบดี」「วันศุกร์」「วันเสาร์」「วันอาทิตย์」 (map จาก `DateTime.weekday` 1–7 ใน `SevenDayRules` — แอปไม่มี package `intl`)

- พับ/ขยายแต่ละใบอิสระต่อกัน (ขยายหลายใบพร้อมกันได้ — ไม่ใช่แบบเปิดได้ใบเดียว) — Q-15
- สถานะพับ/ขยายเก็บใน State ของหน้า — ออกจากหน้าแล้วกลับเข้ามา = ค่าเริ่มต้น (AC-1) · ข้ามรอบ 05:00 = `KeyedSubtree` ของหน้าต่างเปลี่ยน key → การ์ดทั้งชุดสร้างใหม่เป็นค่าเริ่มต้น (Day 0 ใหม่ขยาย อีก 6 พับ — EC-4, Q-4)
- ห้ามล็อกความสูงของ title / subtitle / body · ห้าม `maxLines`

### 2.2 ช่องข้อมูล → แหล่งข้อมูลในโค้ด (D-5 — อ่านอย่างเดียว ไม่เก็บซ้ำ)

วันอ้างอิง `today` = วันตามรอบ 05:00 เวลาเครื่อง (ฟังก์ชัน logical day แบบเดียวกับ `WaterLogic.logicalDay` / `StepsLogic.logicalDay` / `FoodLogic.logicalDay`) · Day −n = `DateTime(today.year, today.month, today.day - n)` · เทียบวันด้วย ปี/เดือน/วัน

| ช่องบนจอ | หมวด | Day 0 (วันนี้) | Day −1…−6 | หน่วย / หมายเหตุ |
|---|---|---|---|---|
| `{water_val}` | water | `WaterController.state.history` record ที่ `date == today` → `cups` (history ถูก upsert ทุกครั้งที่บันทึก — `WaterLogic.logWater`/`upsertHistory`) · ไม่มี record = 0 | `state.history` record ที่ `date == Day −n` → `cups` · ไม่มี = 0 | แก้ว (`int`) — ตรงกับเอกสาร (แก้ว) · requirements §6 เขียน Float แต่โค้ดเก็บ int (Q-13) · history ของ water เก็บเฉพาะวันที่บันทึก (cups > 0) |
| `{steps_val}` | steps | `StepsController.state.steps` เมื่อ `state.day == today` (หลัง `refreshDay`) | `state.history` (`DailyStepsRecord.date` / `.steps`) — history **ไม่รวมวันปัจจุบัน** · ไม่มี record (วันที่ไม่ได้เปิดแอป) = 0 | ก้าว (`int`) — ตรง · มี record ที่ `steps == 0` ได้ (rollover บันทึกวันที่เปิดแอปแต่ไม่เดิน) → นับเป็นไม่มีบันทึก |
| `{food_val}` | food | `FoodController.state.totalCalories` (= `FoodController.totalCalories`) เมื่อ `state.day == today` | `state.history` (`DailyFoodRecord.date` / `.totalCalories`) — ไม่รวมวันปัจจุบัน · ไม่มี = 0 | kcal (`int`) — ตรง · ปัจจุบันตัดประวัติที่ 7 วันรวมวันนี้ (= Day −1…−6 พอดี) → ต้องเปลี่ยนเป็น 30 ตาม D-3 |
| ป้าย 「โซเดียมสูง」 | food | `FoodState.todayHighSodium` (มื้อใดใน `meals` มี `highSodium`) | `DailyFoodRecord.highSodium` | ธง `high_sodium` (food AC-1) |
| ป้าย 「น้ำตาลสูง」 | food | `FoodState.todayHighSugar` | `DailyFoodRecord.highSugar` | ธง `high_sugar` |
| ป้าย 「Overeating」 | food | `FoodController.isOverLimit` (`total > target + FoodRules.overLimitThreshold` — เงื่อนไขเดียวกับหลอดแดงของ food) | `DailyFoodRecord.isOverTarget` (คำนวณตอน rollover ด้วยเป้า ณ ตอนนั้น) | ไม่มีเป้า (ข้ามโปรไฟล์) = false เสมอ |
| "วันที่มีบันทึก" ของวัน (ใช้ตัดสิน 「ไม่มีข้อมูล」 และ `count`) | ทั้ง 3 | `water_val > 0 \|\| steps_val > 0 \|\| food_val > 0` | เดียวกัน | **(ชั่วคราว — Q-2)** แนวเดียวกับรายงานรายเดือนของ water (`cups > 0`) และ steps (`recordedDays` = ก้าว > 0) |
| ค่าเฉลี่ยรายหมวด `{val}` | แต่ละหมวด | รวม Day 0 ถ้าหมวดนั้น > 0 | | `sum(ค่าหมวด) / จำนวนวันที่หมวดนั้น > 0` ในหน้าต่าง 7 วัน **(ชั่วคราว — Q-2, Q-16)** |

ค่าทั้งหมดคำนวณใน logic ของฟีเจอร์ (เสนอ `SevenDayLogic` pure Dart รับ state ของ 3 controller + `now`) — หน้าจอแสดงผลเท่านั้น · ห้ามอ่าน shared_preferences เอง ห้ามสร้าง repository ใหม่

## 3. สถานะของแต่ละหน้าจอ

### S-1

`count` = จำนวนวันที่มีบันทึกใน 7 วัน (นิยาม §2.2) · เงื่อนไขข้อความ coaching ตาม game-rules §1.1 (ไม่เขียนซ้ำ)

| สถานะ | เงื่อนไข (อ้างถึง) | หน้าตา |
|---|---|---|
| กำลังโหลด | controller ใดยัง `!isLoaded` (โหลดจากเครื่อง — D-2) | `Center(CircularProgressIndicator())` แทน body ทั้งหมด ไม่มีข้อความ |
| NORMAL (ปกติ) | ux-flow §4 · `count == 7` | ตาม §2.1: SUMMARY_CARD (#1) ค่าเฉลี่ย 3 บรรทัด · ไม่มี prefix · มีบรรทัดเตือน f/g เฉพาะที่เข้าเกณฑ์ (เรียงน้ำ → ก้าว) · ไม่เข้าเกณฑ์เลย = ไม่มี coaching · 7 การ์ด Day 0 ขยาย (`seven_day_day_body_0` อยู่ใน tree) อีก 6 พับ (มี `seven_day_day_summary_<1–6>` ไม่มี `seven_day_day_body_<1–6>`) · ไม่มี `seven_day_empty_state` |
| INCONSISTENT (บันทึกไม่สม่ำเสมอ) | ux-flow §4, AC-3, EC-1 · `0 < count < 7` | เหมือน NORMAL + บรรทัด e 「มีการบันทึกไม่สม่ำเสมอ จากข้อมูลการบันทึกเท่าที่มีพบว่า...」 เป็นบรรทัดแรกของ coaching ตามด้วย f/g ที่เข้าเกณฑ์ · วันไม่มีบันทึก: การ์ดพับแสดง subtitle 「ไม่มีข้อมูล」, ขยายแสดง body 「ไม่มีข้อมูล」 (AC-2) · ตัวอย่าง game-rules §3: น้ำ 7, 8, 9 แก้ว 3 วัน → `ค่าเฉลี่ยการดื่มน้ำ: 8.0 แก้ว` ไม่มีบรรทัด f · ก้าว 5000, 6000 → `ค่าเฉลี่ยการเดิน: 5,500.0 ก้าว` + บรรทัด g 「เดินเฉลี่ยวันละ 5,500.0 ก้าว ขยับอีกนิดน้าเพื่อสุขภาพที่แข็งแรง แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ」 |
| INCONSISTENT — ไม่เข้าเกณฑ์เตือน | `0 < count < 7`, น้ำเฉลี่ย ≥ 8.0 และก้าวเฉลี่ย ≥ 8,000.0 (หรือหมวดไม่มีข้อมูล) | coaching มีแค่บรรทัด e (prefix ลงท้าย "...") — ตามกติกา prefix ของ game-rules §1.1 · ไม่มีข้อความต่อท้าย (Q-7) |
| EMPTY (ว่าง) | ux-flow §4, AC-6, EC-3 · `count == 0` | **ไม่มี** `seven_day_summary_card` (เลือก "ซ่อน" จาก "ซ่อนหรือแสดงค่า 0" — Q-3) · แสดง EMPTY_STATE_CONTAINER (#2) ไอคอน `Icons.inbox_outlined` 48 + 「ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้」 ข้อความเดียวบนจอ · ใต้ลงมายังมี 7 การ์ด (Day 0 ขยายแสดง 「ไม่มีข้อมูล」, อีก 6 พับ subtitle 「ไม่มีข้อมูล」) — คง AC-1 (Q-3) |
| ข้ามรอบ 05:00 ขณะเปิดหน้าค้าง | EC-4, game-rules §4 แถว 4, D-4 — ตรวจทุก 1 วินาที + resume | หน้าต่าง 7 วันเลื่อนในเฟรมถัดไป: การ์ดบนสุดเป็นวันใหม่ `วันนี้, <วันที่ใหม่>` ขยาย · การ์ดที่เคยเป็น "วันนี้" ลงมาเป็น 「เมื่อวาน」 และพับ · การ์ดทั้งชุดกลับค่าเริ่มต้น (Q-4) · SUMMARY คำนวณใหม่ (Day 0 ใหม่ยังไม่มีบันทึก → อาจเปลี่ยนเป็น INCONSISTENT) · ไม่มี dialog / SnackBar / ข้อความแจ้ง |
| ~~OFFLINE~~ | ux-flow §4 แถว OFFLINE, EC-5 | **ไม่มีสถานะนี้ (D-2)** — ข้อมูลมาจากเครื่องเสมอ หน้าตาตามแถวด้านบน |
| ระหว่าง animation พับ/ขยาย | D-1 | ความสูงการ์ดเปลี่ยนต่อเนื่อง 250 ms ไอคอนหมุนพร้อมกัน การ์ดด้านล่างเลื่อนตาม · กดซ้ำระหว่าง animation = กลับทิศทันที (พฤติกรรม default ของ `ExpansionTile`) |

ไม่มีสถานะ disabled / ผิดพลาด (ไม่มี control ที่ถูกปิด และข้อมูลเครื่องอ่านไม่ได้ = controller เดิมคืนค่าว่างอยู่แล้ว → แสดงเป็น EMPTY)

## 4. ภาพสัตว์เลี้ยงแต่ละสถานะ

**ไม่มี** — requirements §5 Out of scope และ game-rules §2 (N/A) · S-1 ไม่ import `package:petpal_health/shared/pet/pet.dart` ไม่ใช้ `PetCharacter` / `PetPose` และไม่วาดสัตว์เลี้ยงเอง · EMPTY ใช้ไอคอน Material กล่องเปล่า (§2.1.2) · ไม่ต้องการท่าใหม่จาก Art

## 5. Checklist สำหรับ reviewer

- [ ] ไม่มี hex สีในโค้ด 7day — สีทั้งหมดมาจาก `Theme.of(context).colorScheme` (seed `Colors.lightBlue` ใน `main.dart`)
- [ ] ไม่แก้ `ThemeData`, ไม่เพิ่ม font / package / asset ใน `pubspec.yaml`; ไม่มี `Image.asset` ของ `assets/images/7day/*` (ไม่มีไฟล์ใน repo)
- [ ] ไม่มี `PetCharacter` / import `shared/pet/` ในโค้ด 7day
- [ ] ข้อความบนจอและตัวเลข (`7`, `8.0`, `8000.0`, `30`, `250 ms`, `1 วินาที`, `48`) อยู่ใน `SevenDayRules` ไม่ hardcode ในหน้าจอ; ค่าชั่วคราวจาก §6 มีคอมเมนต์ `// ASSUMPTION` และข้อ D-1–D-5 มีคอมเมนต์ `DECIDED`
- [ ] AppBar ของ `WaterHomeScreen` ลำดับ `steps_entry_button` → `food_entry_button` → `dashboard_entry_button` → `seven_day_entry_button` → `water_monthly_report_button` ทั้งหมดเป็น `IconButton`; `seven_day_entry_button` ใช้ `Icons.history` 24 tooltip 「ประวัติ 7 วัน」 กดแล้วไป S-1
- [ ] AppBar ของ `WaterHomeScreen` ไม่ล้น (ไม่มี RenderFlex overflow) ที่ 360 dp textScaler 1.0 และ 1.5
- [ ] S-1 ได้ `WaterController` / `StepsController` / `FoodController` ตัวเดียวกับที่หน้า water ส่งให้ dashboard (บันทึกน้ำ/ก้าว/อาหารแล้วเข้า S-1 เห็นค่าวันนี้ตรง); ไม่มี repository / key shared_preferences ใหม่
- [ ] AppBar title 「ประวัติสุขภาพ 7 วัน」 key `seven_day_header_text` มีปุ่มย้อนกลับอัตโนมัติ
- [ ] body = `SingleChildScrollView` + `Padding(16)` + `Column` (ไม่ใช่ `ListView.builder`); การ์ด 7 ใบ `seven_day_day_card_0`…`_6` อยู่ใน tree ทั้งหมดโดยไม่ต้องเลื่อน; ระยะ summary ↔ การ์ด 16, ระหว่างการ์ด 8
- [ ] SUMMARY_CARD key `seven_day_summary_card` พื้น `primaryContainer` มุม 8 padding 16; หัวข้อ 「สรุปภาพรวมรอบ 7 วัน」 `titleMedium`; บรรทัดค่าเฉลี่ยเรียง น้ำ → ก้าว → แคลอรี รูปแบบ `ค่าเฉลี่ยการดื่มน้ำ: <v> แก้ว` / `ค่าเฉลี่ยการเดิน: <v> ก้าว` / `ค่าเฉลี่ยแคลอรี: <v> kcal`
- [ ] ค่าเฉลี่ยทศนิยม 1 ตำแหน่งเสมอและมี comma: น้ำ 7, 8, 9 → `8.0`; ก้าว 5000, 6000 → `5,500.0`; ก้าวรวม 14,481 / 2 วัน → `7,240.5`
- [ ] ค่าเฉลี่ยหารด้วยจำนวนวันที่หมวดนั้น > 0 (วัน 0 ไม่นับตัวหาร); หมวดที่ไม่มีวันมีบันทึกแสดง `…: ไม่มีข้อมูล` และไม่มีบรรทัดเตือนของหมวดนั้น
- [ ] `0 < count < 7` → `seven_day_coaching_prefix_text` 「มีการบันทึกไม่สม่ำเสมอ จากข้อมูลการบันทึกเท่าที่มีพบว่า...」 ตรงตัว อยู่บรรทัดแรก; `count == 7` → ไม่มี prefix
- [ ] น้ำเฉลี่ย 7.9 → มี `seven_day_coaching_water_text` 「ดื่มน้ำเฉลี่ยวันละ 7.9 แก้ว น้อยไปน้า พยายามกินน้ำมากกว่านี้ แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ」; 8.0 → ไม่มี; 7.96 (แสดง `8.0`) → ไม่มี
- [ ] ก้าวเฉลี่ย 7,999.9 → มี `seven_day_coaching_steps_text` 「เดินเฉลี่ยวันละ 7,999.9 ก้าว ขยับอีกนิดน้าเพื่อสุขภาพที่แข็งแรง แต่เก่งมากแล้วดูแลสุขภาพต่อไปนะ」; 8,000.0 → ไม่มี
- [ ] เข้าเกณฑ์ทั้งสอง → บรรทัดน้ำอยู่เหนือบรรทัดก้าว เป็น `Text` แยกกัน; coaching ทุกบรรทัดไม่มี `maxLines`/ellipsis สี `onPrimaryContainer` `bodyMedium`
- [ ] NORMAL ไม่เข้าเกณฑ์ → ไม่มี widget coaching ใด ๆ ใน tree
- [ ] EMPTY (`count == 0`) → ไม่มี `seven_day_summary_card`; มี `seven_day_empty_state` + `Icons.inbox_outlined` 48 สี `onSurfaceVariant` + `seven_day_empty_text` 「ยังไม่มีข้อมูลการบันทึกในรอบ 7 วันนี้」; `find.text` ของข้อความนี้เจอ 1; ยังมีการ์ด 7 ใบ
- [ ] การ์ดรายวันเป็น `Card(margin: zero, clipBehavior: antiAlias)` → `ExpansionTile` ที่ `expansionAnimationStyle.duration == 250 ms`, `shape`/`collapsedShape` = `Border()`; ไม่มี PNG ลูกศร (ใช้ไอคอน default)
- [ ] เปิดหน้า: Day 0 ขยาย (`seven_day_day_body_0` อยู่ใน tree), Day −1…−6 พับ (ไม่มี `seven_day_day_body_<1–6>`) — AC-1
- [ ] แตะหัวการ์ด → ขยาย/พับ; หลัง `pump(250 ms)` เสร็จ; ขยายหลายใบพร้อมกันได้; ออกแล้วเข้าหน้าใหม่ = ค่าเริ่มต้น
- [ ] หัวการ์ด `seven_day_day_title_0` = `วันนี้, dd/MM/yyyy`; `_1` = `เมื่อวาน, dd/MM/yyyy`; `_2…_6` = `<ชื่อวันไทย>, dd/MM/yyyy`; style `titleMedium`
- [ ] การ์ดพับมี subtitle `seven_day_day_summary_<i>` = `<ก้าว> ก้าว · <แก้ว> แก้ว · <kcal> kcal` หรือ 「ไม่มีข้อมูล」 สี `onSurfaceVariant`; การ์ดขยายไม่มี subtitle
- [ ] การ์ดขยายที่มีบันทึก: บรรทัด `การเดิน: <n> ก้าว` → `การดื่มน้ำ: <n> แก้ว` → `แคลอรี: <n> kcal` (ก้าว/kcal มี comma); หมวดที่ไม่มีบันทึก = `0`; วันไม่มีบันทึก = `seven_day_day_no_data_<i>` 「ไม่มีข้อมูล」 เท่านั้น
- [ ] ป้าย: Day 0 จาก `todayHighSodium` / `todayHighSugar` / `FoodController.isOverLimit`; วันก่อนจาก `DailyFoodRecord.highSodium` / `highSugar` / `isOverTarget`; ข้อความ 「โซเดียมสูง」「น้ำตาลสูง」「Overeating」 เรียงตามนี้ใน `Wrap(spacing 8, runSpacing 8)` พื้น `errorContainer` ตัวอักษร `onErrorContainer` `labelLarge` padding 8/4 มุม 8; ไม่มีป้าย = ไม่มี `seven_day_day_tags_<i>`
- [ ] ค่ารายวัน: water จาก `WaterController.state.history` (รวมวันนี้); steps วันนี้จาก `state.steps` (`state.day == today`) วันก่อนจาก `state.history`; food วันนี้จาก `state.totalCalories` วันก่อนจาก `state.history`
- [ ] steps record ที่ `steps == 0` และวันที่ไม่มี record ใดเลยทั้ง 3 หมวด → การ์ด 「ไม่มีข้อมูล」 และไม่นับใน `count`
- [ ] จำลองเวลาเครื่องข้าม 05:00 ขณะเปิด S-1 → ภายใน 1 วินาทีการ์ดบนสุดเป็น `วันนี้, <วันใหม่>` ขยาย, การ์ดเดิมเป็น `เมื่อวาน, …` พับ; ไม่มี dialog / SnackBar; ไม่มีการเรียก network
- [ ] ไม่มี UI ออฟไลน์ใด ๆ (ไอคอน/ข้อความ/แบนเนอร์)
- [ ] ไม่มี RenderFlex overflow บน S-1 ที่ 360×640 dp ทั้ง textScaler 1.0 และ 1.5 ทุกสถานะ (NORMAL ขยายทุกใบ + ป้ายครบ 3 + ตัวเลขยาว เช่น `123,456 ก้าว · 99 แก้ว · 12,345 kcal`, INCONSISTENT มี coaching 3 บรรทัด, EMPTY); ไม่มี `SizedBox`/`Container` ความสูงคงที่ครอบข้อความ
- [ ] Timer ตรวจรอบวันถูก cancel ใน `dispose`; ไม่มีหน้าจอใหม่นอกจาก S-1

## 6. คำถามที่ค้าง

ที่มา: **A** = requirements (Product) · **B** = ux-flow / game-rules (Design) · ค่าชั่วคราวทุกข้อให้ Dev ใส่ `// ASSUMPTION` อ้างเลขข้อ

| # | ที่มา | ประเด็น | ทางที่ spec เลือกไว้ชั่วคราว |
|---|---|---|---|
| Q-1 | B (ux-flow §3 ข้อ 1) | ทางเข้า "เมนู ประวัติ 7 วัน จากหน้าหลัก" — AppBar ของ water มีปุ่มไอคอน 4 ปุ่มแล้ว | `IconButton` ที่ 5 `seven_day_entry_button` (`Icons.history`, tooltip 「ประวัติ 7 วัน」) — 5 × 48 = 240 dp ไม่ล้นที่ 360 dp ทั้ง textScaler 1.0/1.5 แต่ title 「PetPal Health」 ถูกตัด ellipsis มากขึ้น (~104 dp) · ทางเลือกถ้า owner ไม่ต้องการ: (ก) ทางเข้าจาก AppBar ของ dashboard (เป็นหน้ารวมสุขภาพอยู่แล้ว) หรือ (ข) รวม 「รายงานรายเดือน」 + 「ประวัติ 7 วัน」 ไว้ใน `PopupMenuButton` (`Icons.more_vert`) — ฟีเจอร์ที่ 6 ต้องเลือกทาง (ก)/(ข) แน่นอน |
| Q-2 | A (brief §2 / AC-3 "Count(Days with Records)") + B (game-rules §1.1 `count`) | "วันที่มีบันทึก" นับอย่างไรเมื่อบางหมวดมีบางหมวดไม่มี และตัวหารค่าเฉลี่ยเป็นของรวมหรือรายหมวด | `count` (ใช้ตัดสิน INCONSISTENT / EMPTY / การ์ด 「ไม่มีข้อมูล」) = วันที่หมวดใดหมวดหนึ่ง > 0 · ตัวหารค่าเฉลี่ยรายหมวด = วันที่หมวดนั้น > 0 (แนวเดียวกับรายงานรายเดือนของ water / steps) · ค่า 0 (เช่น steps record 0 ก้าว) = ไม่มีบันทึก |
| Q-3 | B (ux-flow §4 EMPTY "ซ่อนหรือแสดงค่า 0", game-rules §4) + A (brief §4 ข้อ 3 "สถานะหน้าว่าง") | EMPTY: ซ่อนหรือแสดง 0 · ยังแสดงการ์ดรายวันไหม · ข้อความ `STATUS_EMPTY_7DAYS` ใน coaching ซ้ำกับ EMPTY_STATE_CONTAINER | ซ่อน SUMMARY_CARD (ข้อความว่างขึ้นที่เดียว) · ยังแสดง 7 การ์ดแบบ 「ไม่มีข้อมูล」 เพื่อคง AC-1 (Day 0 expanded เสมอ) |
| Q-4 | B (EC-4, game-rules §4 แถว 4) | ข้ามรอบ 05:00: การ์ดที่เคยเป็น Day 0 (และการ์ดที่ผู้ใช้กางไว้) ต้องคงสถานะหรือกลับค่าเริ่มต้น | กลับค่าเริ่มต้นทั้งชุด (Day 0 ใหม่ขยาย อีก 6 พับ) ผ่าน `KeyedSubtree` ที่ key ตามวันที่ Day 0 |
| Q-5 | A (brief §3 Color Highlighting) | brief กำหนดสีเขียว ≥ 80% / ส้ม 50–79% / แดง < 50% หรือ Overeating แต่ requirements, ux-flow, game-rules ไม่มี และไม่บอกเป้าที่ใช้คิด % (water 8 แก้ว? steps เป้าของวันนั้น `DailyStepsRecord.goal` หรือ 8,000? food ≥ 80% ของเป้า = ผ่าน?) · ColorScheme ไม่มี role สีเขียว/ส้ม → ต้องตั้ง hex ใหม่ | **ไม่ทำสีระดับเป้าในรอบนี้** — ตัวเลขสีปกติ · Overeating แสดงเป็นป้าย `errorContainer` (สีแดงโทนเดียวกับ food) · ถ้า owner ต้องการ ต้องเพิ่มเกณฑ์ใน game-rules ก่อน แล้ว UI จะเสนอ token (เช่น `primary` / `tertiary` / `error` หรือ hex ใหม่พร้อมเหตุผล) |
| Q-6 | B (ux-flow §5) | `assets/images/7day/summary_card_bg.png`, `card_expanded_icon.png`, `card_collapsed_icon.png`, `empty_history_illustration.png` **ไม่มีใน repo** (`app/assets/images/` มีแค่ `.gitkeep` + `legacy/`) และ `assets/images/7day/` ไม่ได้ลงทะเบียนใน pubspec (Flutter ไม่รวมโฟลเดอร์ย่อยจาก `assets/images/`) | ใช้ widget แทนทั้งหมดแบบ food Q-8 / dashboard D-1: พื้น SUMMARY = `primaryContainer` · ลูกศร = ไอคอน default ของ `ExpansionTile` (`Icons.expand_more` หมุน) · EMPTY = `Icons.inbox_outlined` 48 `onSurfaceVariant` · ไม่เพิ่ม asset — ถ้าต้องการ PNG จริงเป็นงานของ Art + ลงทะเบียน pubspec |
| Q-7 | B (ux-flow §2 SUMMARY_CARD "หรือกรณีปกติ") + A (brief §2) | ไม่มีข้อความ coaching กรณีปกติ และ INCONSISTENT ที่ไม่เข้าเกณฑ์เตือนเหลือ prefix ที่ลงท้าย "..." ลอย ๆ | NORMAL ไม่เข้าเกณฑ์ = ไม่มี coaching · INCONSISTENT ไม่เข้าเกณฑ์ = แสดง prefix อย่างเดียว (ตามกติกา prefix) — ขอ Design เพิ่มข้อความชม/ปกติใน game-rules §1.1 |
| Q-8 | B (game-rules §1.1, §3) | หมวดที่ไม่มีบันทึกเลยใน 7 วัน (แต่หมวดอื่นมี) ค่าเฉลี่ยแสดงอะไร และต้องขึ้นคำเตือน "< 8" ไหม (0.0 < 8.0) · ในวันที่มีบันทึก หมวดที่ไม่มีแสดงอะไร | บรรทัดค่าเฉลี่ย `…: ไม่มีข้อมูล` **(เสนอ)** และไม่ขึ้นคำเตือนหมวดนั้น · ในการ์ดรายวัน หมวดที่ไม่มีแสดง `0` |
| Q-9 | B (game-rules §1.1 หมายเหตุ) | ตัวอย่างต่อ prefix กับคำแนะนำในบรรทัดเดียว ("...พบว่า... ดื่มน้ำเฉลี่ย...") แต่หมายเหตุถัดไปให้น้ำ/ก้าว "คนละบรรทัด" | prefix เป็นบรรทัดของตัวเอง ตามด้วยน้ำ แล้วก้าว — `Text` แยก 3 ตัว (ทดสอบตรงตัวได้ทีละข้อความ, ขึ้นบรรทัดสวยที่ textScaler 1.5) |
| Q-10 | B (game-rules §1 `WATER_GOAL_THRESHOLD` / `STEPS_GOAL_THRESHOLD`, §1.1) | เทียบ `< 8.0` / `< 8000.0` กับค่าดิบหรือค่าที่ปัด 1 ตำแหน่ง — ค่าดิบ 7.96 จะขึ้น 「ดื่มน้ำเฉลี่ยวันละ 8.0 แก้ว น้อยไปน้า…」 ซึ่งขัดกันเอง | เทียบค่าที่ปัด 1 ตำแหน่งแล้ว (ค่าเดียวกับที่แสดง) — 7.96 → `8.0` ไม่เตือน · 7.94 → `7.9` เตือน |
| Q-11 | B (ux-flow §2 DAY_CARD) | ไม่กำหนดรูปแบบ `{date_str}` และ `{day_label}` | `{date_str}` = `dd/MM/yyyy` (`WaterLogic.formatHistoryDate` ที่ water ตัดสินไว้) · `{day_label}` = 「เมื่อวาน」 สำหรับ Day −1, ชื่อวันไทย 「วันจันทร์」…「วันอาทิตย์」 สำหรับ Day −2…−6 (เสนอ) |
| Q-12 | A (brief §2, AC-3 ตัวอย่าง `7,240.5 ก้าว`) | ทศนิยม 1 ตำแหน่งต้องคั่นหลักพันไหม และใช้กับน้ำ/kcal ด้วยหรือไม่ | คั่นหลักพันทุกหมวดด้วย `StepsLogic.formatAverage` (ตัวอย่าง AC-3 มี comma; steps รายงานรายเดือนใช้แบบนี้อยู่แล้ว) — น้ำ < 1,000 จึงไม่เห็น comma |
| Q-13 | A (requirements §6 Water "Float (แก้ว)") | โค้ด water เก็บ `cups` เป็น `int` (`DailyWaterRecord.cups`) | แสดงแก้วรายวันเป็นจำนวนเต็ม (`6 แก้ว`) · ค่าเฉลี่ยเป็นทศนิยม 1 ตำแหน่ง — ขอ Product แก้ชนิดใน §6 เป็น Integer |
| Q-14 | B (ux-flow §2 DAY_CARD_1–6 "แถบสรุปสั้นๆ เช่น…") | ไม่กำหนดรูปแบบแถบสรุปตอนพับ และไม่บอกว่าแสดงป้ายตอนพับไหม | `<ก้าว> ก้าว · <แก้ว> แก้ว · <kcal> kcal` (เสนอ) ไม่แสดงป้ายตอนพับ (Minimal — ป้ายดูได้เมื่อขยาย) |
| Q-15 | B (ux-flow §3 ข้อ 6) / A (requirements §7 ข้อ 1) | Accordion เปิดได้ทีละใบ (เปิดใบใหม่ปิดใบเดิม) หรืออิสระ | อิสระ — "แตะเพื่อพับหรือขยาย…ได้ตามต้องการ" ไม่ได้บอกว่าต้องปิดใบอื่น |
| Q-16 | A (brief §1 / AC-1) + B (game-rules §1.1) | Day 0 นับในค่าเฉลี่ยไหม ทั้งที่วันยังไม่จบ (เปิดตอนเช้า Day 0 มีน้ำ 1 แก้ว → ดึงค่าเฉลี่ยลงและอาจขึ้นคำเตือน) | นับ Day 0 ตาม D-4 (หน้าต่างรวมวันนี้) เมื่อหมวดนั้น > 0 — วันนี้ยังไม่บันทึก (= 0) ไม่นับตัวหาร จึงไม่ดึงค่าลงจนกว่าจะเริ่มบันทึก · ถ้า owner ต้องการตัด Day 0 ออกจากค่าเฉลี่ย ต้องแก้ game-rules |
| Q-17 | B (ux-flow §3 ข้อ 5) | 「Day -1 ถึง Day -6 จะอยู่ในสถานะพับเก็บ (Collapsed = false)」 — น่าจะพิมพ์ผิด (AC-1 เขียน `expanded = false`) | ตีความเป็น `expanded = false` (= Collapsed) ตาม AC-1 · ให้ Design แก้ถ้อยคำ |
| Q-18 | B (ux-flow §2 DAY_CARD_0) / A (brief) | สะกด 「แคลอรี」 (7day) ต่างจาก 「แคลอรี่」 (food) และป้าย 「Overeating」 เป็นภาษาอังกฤษ ขณะป้ายอื่นเป็นไทย | คัดลอกตรงตัวตามเอกสาร 7day (「แคลอรี」, 「Overeating」) — ถ้าจะเปลี่ยนเป็น 「แคลอรี่」 / 「กินเกินเป้า」 ต้องแก้ ux-flow / requirements ก่อน |
| Q-19 | A (D-3, requirements §7 ข้อ 2) | retention 30 วันแบบ rolling ขัดกับรายงานรายเดือนของ water / steps ที่ต้องใช้ทั้งเดือน (เดือน 31 วัน: วันที่ 31 จะเห็นแค่ 30 วันล่าสุด) · water / steps ปัจจุบันไม่ตัดประวัติเลย | UI ไม่กระทบ (แสดง 7 วัน) — ให้ owner/Dev ตัดสินว่าจะใช้ 30 กับ food อย่างเดียว หรือปรับเป็น ≥ 31 สำหรับทุกฟีเจอร์ |
| Q-20 | A (brief §3 / requirements §6) | `DailyFoodRecord.isOverTarget` ของวันก่อนคำนวณด้วยเป้า ณ ตอนตัดรอบ (เปลี่ยนโปรไฟล์ภายหลังไม่คิดใหม่) | ใช้ค่าที่เก็บไว้ (ไม่คำนวณย้อนหลัง) — ตรงกับ "ไม่มีการแก้ไขข้อมูลย้อนหลัง" |
