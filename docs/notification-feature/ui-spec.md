# UI spec: ฟีเจอร์แจ้งเตือน (notification-feature)

> สถานะ: draft (2026-11-08 รอบ 1) · ผู้เขียน: UI agent · อ้างอิง: ux-flow.md, game-rules.md (บริบท: requirements.md, brief.md, design-review.md, docs/_design/character.md รอบ 5, logs/20261108-1548_art_notification-feature.md)
> เอกสารนี้กำหนด "หน้าตา" และโครงที่ Dev ต้องใช้ให้ตรวจได้ — ตัวเลข กติกา และ flow ให้ยึด ux-flow.md / game-rules.md และข้อตัดสิน owner ใน §0 (**ข้อตัดสินชนะเอกสารเมื่อขัดกัน**)
> design language ยึดตาม `docs/dashboard/ui-spec.md`, `docs/7day/ui-spec.md`, `docs/steps/ui-spec.md`, `docs/signup/ui-spec.md` และโค้ดจริงใน `app/lib/` — ไม่สร้างระบบดีไซน์ใหม่
> ux-flow มี 3 หน้าจอ: S-1 การ์ดขอความยินยอม, S-2 หน้าตั้งค่าแจ้งเตือน, S-3 การแจ้งเตือนบน OS — spec ไม่เพิ่มหน้าจออื่น (ทางเข้า S-2 เป็นปุ่มบน AppBar ของ dashboard ที่มีอยู่แล้ว — §2.0)

## 0. ข้อตัดสินใจที่มีผลต่อ UI

ข้อ D-1 ถึง D-6 เป็นการตัดสินใจของเจ้าของโปรเจกต์ ไม่ใช่ของ UI agent — **DECIDED (owner) 2026-11-08 — ทีมให้ owner ตัดสินไปก่อน ทีมตรวจตอนรีวิว PR** — spec นี้แค่กำหนดหน้าตา/โครงให้รองรับ · D-7 ถึง D-11 เป็นข้อตกลงระดับแอปที่มีอยู่แล้ว (ไม่ใช่ข้อตัดสินใหม่)

| # | ข้อตัดสินใจ (ที่มา) | ผลต่อ UI |
|---|---|---|
| D-1 | **รูปโปรไฟล์กบ (ux-flow §2 S-1/S-3, §4, §5, §6 ข้อ 1; game-rules §2, §5 ข้อ 1; design-review Q-01):** ไม่ใช้ PNG `assets/images/pet_profile_frog.png` — ใช้ `PetCharacter(pose: PetPose.notificationProfile)` (Art เพิ่มแล้ว — character.md §5, §7, §9 ข้อ 11) · S-1 วาดด้วย widget ตรง ๆ · Person icon Android เรนเดอร์จาก `PetCharacterPainter` ตอนรันแอป **192×192 px ครอปวงกลมเต็มกรอบ พื้นโปร่งใส** → `ByteArrayAndroidIcon` แคชไว้ · ไม่มี PNG ใน assets · **ปิด Q-01** | S-1 = `PetCharacter` (§2.1, §4) · S-3 = avatar จาก painter (§2.3.2) · ห้าม `Image.asset` / `AssetImage` ภาพกบ · ไม่แก้ `pubspec.yaml` ส่วน `assets:` |
| D-2 | **ทางเข้าหน้าตั้งค่า S-2 (ux-flow §1 S-2 "เข้าถึงจากเมนูตั้งค่า", §3 ข้อ 6):** ปุ่มไอคอนตั้งค่าใน AppBar หน้า dashboard (`IconButton` + tooltip) — ไม่แตะ AppBar หน้า water ที่เต็ม 5 ปุ่ม | §2.0 |
| D-3 | **"เดิน: บันทึกเอง" (ux-flow §2 S-3 แถว 3, §3.1; game-rules `WALK_MANUAL_INACTIVITY_HOURS`, `last_manual_move_timestamp`, §1.1 แถว 3, §4 EC-12; requirements AC-15, EC-12):** ตัดออกจากรอบนี้ → Out of scope (steps ไม่มีปุ่มบันทึกขยับเอง) · ผู้ใช้ที่ `StepsController.isTrackingLocked` **ไม่ได้รับข้อความเรื่องเดินเลย** · AC-15 / EC-12 ไม่ทำ | ไม่มีข้อความ 「อย่าลืมขยับร่างกายน้า ถ้าขยับแล้วมาอัปเดตให้น้องอ๊บด้วย」 ในโค้ด · ไม่มี key `last_manual_move_timestamp` · §2.4 |
| D-4 | **ค่าติดลบจากฟีเจอร์อื่น / `daily_goal` = 0 (EC-3):** ยึด EC-3 ของ notification (ไม่ส่งเรื่องนั้นในรอบวัน) เฉพาะ notification — ไม่เปลี่ยน A4 ของ 7day | §2.4.3 — ไม่มี UI ผิดพลาด (ux-flow §4 S-3 ERROR) |
| D-5 | **Package:** `flutter_local_notifications`, `timezone`, `flutter_timezone` — ในเครื่องเท่านั้น ไม่ต่อเน็ต ไม่ใช้ workmanager — คำนวณล่วงหน้าแล้วตั้งเวลาใหม่ทุกครั้งที่ข้อมูลเปลี่ยน / เปิดแอป | §2.4, §5 · เพิ่ม 3 package นี้ใน `pubspec.yaml` เท่านั้น |
| D-6 | **ตั้งเวลาแบบไม่เป๊ะ:** `AndroidScheduleMode.inexactAllowWhileIdle` ไม่ขอ exact alarm · ทุกข้อความอาจช้ากว่ากำหนด → Out of scope · เทสต์ตรวจเวลาที่ "ตั้ง" ไม่ใช่เวลาที่ OS ยิงจริง | manifest ไม่มี `SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM` (§5) · เทสต์ใช้ fake scheduler (§2.4.6) |
| — | **Q-02 (design-review):** ข้อความ PERMISSION_DENIED ใช้ Exact String จาก ux-flow ได้เลย — **ปิด Q-02** | 「สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน」 (§2.2) |
| D-7 | (ระดับแอป) สัตว์เลี้ยงใช้ `PetCharacter` ตัวเดียว (character.md §1, §9 ข้อ 2) | §4 |
| D-8 | (ระดับแอป) ห้ามต่อเน็ต ข้อมูลในเครื่อง ตัดรอบ **05:00 เวลาเครื่อง** ใช้ `clock` ร่วมของ controller (dashboard D-2, 7day D-4) | logic รับ `now` จาก clock ที่ inject ได้ (§2.4) — แทน "รอบวัน" ของ game-rules `DAILY_RESET_TIME` ด้วย `WaterLogic.logicalDay` |
| D-9 | (ระดับแอป — 7day D-5) อ่านค่าจาก controller เดิม ห้ามเก็บข้อมูลซ้ำ — key ใหม่ของ notification เองเก็บได้ | อ่าน `WaterController` / `StepsController` / `FoodController` ตัวเดียวกับหน้า water (§2.4.1) · เก็บเฉพาะ key ของ notification (§2.5) |
| D-10 | (ระดับแอป — dashboard D-5/D-9) water ยังเป็นหน้าแรก (`WaterHomeScreen` = Home) | S-1 แสดงทับหน้า water (§2.1) · deep link น้ำ = กลับหน้าแรก (§2.3.3) |
| D-11 | (ระดับแอป — dashboard D-7) เป้าน้ำ 8 แก้ว derive จากค่าคงที่ของ water | `NotificationRules.waterDailyGoalGlasses` = `DashboardRules.waterTargetCups` (ไม่พิมพ์เลข 8) |

## 1. Design tokens

ทุกสีดึงจาก `Theme.of(context).colorScheme` / `textTheme` เท่านั้น — **ห้าม hardcode hex** ในโค้ด notification (seed `Colors.lightBlue` ใน `app/lib/main.dart` → `ColorScheme.fromSeed`) · ไม่แก้ `ThemeData` · ไม่เพิ่ม font / asset · สีตัวสัตว์เลี้ยงอยู่ใน `PetColors` (`app/lib/shared/pet/pet_constants.dart` — `lips` `#EC6F86`, `heart` `#E8506E` ของ Art รอบ 5) ห้ามแก้

### 1.1 สี

| Token | ค่า | ใช้ที่ไหน | ที่มา |
|---|---|---|---|
| Seed color | `Colors.lightBlue` | ทุก ColorScheme · `AndroidNotificationDetails.color` (สีไอคอนเล็ก/ชื่อแอปบนแจ้งเตือน Android) | `app/lib/main.dart` — อ้างค่าเดียวกัน ไม่ตั้ง hex ใหม่ |
| พื้นการ์ด S-1 | default ของ `Dialog` M3 (`colorScheme.surfaceContainerHigh`) — ไม่ตั้ง `backgroundColor` | S-1 | ของเดิม: `steps_sensor_error_dialog` (`AlertDialog` default) ใน `steps_dashboard_screen.dart` |
| ฉากหลังทึบใต้การ์ด (barrier) | default ของ `showDialog` (`barrierColor` ไม่ตั้ง) | S-1 | ของเดิม: `steps_sensor_error_dialog`, `signup_widgets.dart` `showDialog` |
| หัวข้อการ์ด | default (`onSurface`) | S-1 | default Text ใน Dialog |
| รายละเอียดการ์ด | `colorScheme.onSurfaceVariant` | S-1 | role เดิม: `signup_welcome_tagline_text`, ข้อความรองของ dashboard / 7day (= สี content ของ `AlertDialog` M3) |
| ปุ่มอนุญาต (Primary) | default ของ `FilledButton` (`primary` / `onPrimary`) | S-1 | ของเดิม: `water_log_button`, `steps_open_settings_button` |
| ปุ่มไม่อนุญาต (Secondary) | default ของ `OutlinedButton` | S-1 | ของเดิม: `signup_google_button` (`signup_welcome_screen.dart`) |
| สวิตช์ | default ของ `SwitchListTile` M3 (เปิด = `primary`) | S-2 | **การใช้ widget ใหม่** — ยังไม่มีสวิตช์ในแอป ใช้ default ไม่ตั้งสี |
| กล่องข้อความสิทธิ์ถูกปิด | พื้น `colorScheme.errorContainer`, ตัวอักษร `colorScheme.onErrorContainer` | S-2 สถานะ PERMISSION_DENIED | ของเดิม: `food_full_badge`, ป้ายเตือน 7day (`seven_day_tag_*`) |
| ไอคอนทางเข้า S-2 | default ของ `IconButton` ใน AppBar | AppBar dashboard | ของเดิม: ปุ่มไอคอน 5 ปุ่มของ `WaterHomeScreen` |
| Person icon Android | พื้น**โปร่งใส** (ไม่เติมวงกลมสี) | S-3 | ux-flow §5 "พื้นหลังโปร่งใส" + D-1 — ตอบคำถาม Art ข้อ 2 (Q-11) |

ไม่มีสถานะ disabled ของปุ่ม/สวิตช์ (ux-flow ไม่มีพฤติกรรมรองรับ — §3)

### 1.2 ตัวอักษร

ไม่มี custom font ใน `app/pubspec.yaml` → `Theme.of(context).textTheme` เท่านั้น

| ใช้กับ | style | ที่มา |
|---|---|---|
| AppBar title S-2 | default ของ `AppBar` | ทุกหน้า |
| หัวข้อการ์ด S-1 | `textTheme.headlineSmall`, จัดกลาง | role เดิม: title ของ `AlertDialog` M3 (`steps_sensor_error_dialog`) |
| รายละเอียดการ์ด S-1 | `textTheme.bodyMedium` + `onSurfaceVariant`, จัดกลาง | role เดิม: content ของ `AlertDialog` M3 |
| ป้ายปุ่ม S-1 | default ของ `FilledButton` / `OutlinedButton` (`labelLarge`) | ปุ่มเดิมทุกหน้า |
| ป้ายสวิตช์ S-2 | default ของ `SwitchListTile.title` (`bodyLarge`) | default M3 |
| ข้อความสิทธิ์ถูกปิด S-2 | `textTheme.bodyMedium` + `onErrorContainer` | role เดิม: `dashboard_alert_text`, `food_cta_text` |
| ข้อความแจ้งเตือน S-3 | ฟอนต์ของระบบปฏิบัติการ (แอปกำหนดไม่ได้) | — |

ทุก `Text` ใน S-1 / S-2 **ไม่มี `maxLines` / ellipsis** (ข้อความต้องครบตรงตัว — บทเรียน food D-5 / dashboard D-16)

### 1.3 ระยะห่าง ขนาด มุมโค้ง เวลา

| Token | ค่า | ที่มา |
|---|---|---|
| Padding ในการ์ด S-1 | 24 รอบด้าน | default padding ของ `AlertDialog` M3 / padding หน้าหลัก 24 (`water_home_screen.dart`) |
| ระยะในการ์ด S-1 | สัตว์เลี้ยง → 16 → หัวข้อ → 8 → รายละเอียด → 24 → ปุ่มอนุญาต → 8 → ปุ่มไม่อนุญาต | ช่องไฟเดิม 8 / 16 / 24 |
| ขอบนอก/มุมการ์ด S-1 | default ของ `Dialog` M3 (`insetPadding` แนวนอน 40 แนวตั้ง 24, มุม 28) — ไม่ตั้งเอง | default ของ `AlertDialog` ในแอป |
| ขนาดสัตว์เลี้ยงบน S-1 | **120 × 120** — `NotificationRules.consentPetSize` | **ใหม่** — เหตุผล: การ์ดกว้าง 280 dp ที่จอ 360 (เนื้อหา 232) ถ้าใช้ 160 ของหน้าอื่น การ์ดที่ textScaler 1.5 สูงเกินจอ 640 (§2.1 งบความสูง) · 120 = ค่าตัวอย่างของ Art (character.md §7) และ Art ยืนยันว่าอ่านออกตั้งแต่ ~48 |
| ขนาด Person icon | **192 × 192 px** ครอปวงกลมเต็มกรอบ ไม่ซูม — `NotificationRules.avatarSizePx` | D-1 / character.md §7 (≈ 48 dp × xxxhdpi) |
| ปุ่มบน S-1 | เต็มความกว้างการ์ด (`Column(crossAxisAlignment: stretch)`) ซ้อนแนวตั้ง | **ใหม่ (การจัดวาง)** — เหตุผล: 2 ปุ่มข้อความไทยวางแถวเดียวในเนื้อหา 232 dp ที่ textScaler 1.5 ไม่พอ · ซ้อนแนวตั้งไม่ล้นทุก textScaler |
| Padding หน้า S-2 | 16 รอบด้าน (`ListView(padding: EdgeInsets.all(16))`) | หน้ารายการ/ฟอร์ม: 7day S-1, `monthly_report_screen.dart` |
| `SwitchListTile.contentPadding` | `EdgeInsets.zero` | **ใหม่** — เหตุผล: หน้ามี padding 16 แล้ว ไม่ให้ซ้อน 16 + 16 (ขอบสวิตช์ตรงกับขอบกล่องข้อความด้านล่าง) |
| ระยะสวิตช์ ↔ กล่องข้อความสิทธิ์ | 8 | ช่องไฟเดิม |
| กล่องข้อความสิทธิ์ | padding แนวนอน 16 แนวตั้ง 8 · `BorderRadius.circular(8)` | `food_full_badge`, `dashboard_total_score_card` |
| ไอคอนทางเข้า S-2 | `Icons.settings`, 24 — `NotificationRules.entryIconSize` | ขนาดเดียวกับปุ่ม AppBar เดิม (`SevenDayRules.entryIconSize` = 24) |
| Loading S-2 | `Center(CircularProgressIndicator())` | water / steps / food / dashboard / 7day ตอน `!isLoaded` |
| ความถี่ตรวจรอบวัน (ตั้งเวลารอบวันใหม่ขณะเปิดแอปค้าง) | 1 นาที — `NotificationRules.dayCheckInterval` | ค่าเดียวกับ `_resetCheckInterval` ของ `water_home_screen.dart` (ข้อความเร็วสุด 06:00 จึงไม่ต้องตรวจทุกวินาที) |

## 2. หน้าจอ

ข้อความใน「」คัดลอกตรงตัวจาก ux-flow.md / game-rules.md — ห้ามแก้ · `"` ที่ครอบข้อความในเอกสารเป็นตัวคั่น ไม่ใช่ส่วนของข้อความ (แบบ dashboard Q-21) · ข้อความที่เอกสารไม่มีและ spec เสนอไว้ชั่วคราว ระบุว่า **(เสนอ — รอยืนยัน)**
ข้อความทุกข้อความ และตัวเลข (เวลา เพดาน ระยะห่าง ขนาด) อยู่ใน `NotificationRules` (`app/lib/features/notification/notification_rules.dart`) — ห้าม hardcode ในหน้าจอ/logic
ValueKey ใช้ prefix `notification_` ทั้งหมด

### 2.0 ทางเข้า S-2 จาก AppBar ของ dashboard (D-2)

- ตำแหน่ง: `AppBar.actions` ของ `DashboardScreen` (`app/lib/features/dashboard/screens/dashboard_screen.dart`) — ปัจจุบันไม่มีปุ่ม → ปุ่มนี้เป็นปุ่มเดียว (ขวาสุด)
- Widget: `IconButton(key: Key('notification_settings_entry_button'), icon: Icon(Icons.settings, size: NotificationRules.entryIconSize /* 24 */), tooltip: NotificationRules.settingsTitle, onPressed: → push S-2)` · tooltip = 「การแจ้งเตือนของน้องอ๊บ」 (หัวข้อ S-2 จาก ux-flow — Q-04) · ไม่มีข้อความบนปุ่ม
- `DashboardScreen` รับพารามิเตอร์ใหม่ `NotificationController? notificationController` — **null = ไม่มีปุ่ม** (เทสต์ dashboard เดิมไม่เปลี่ยน) · `WaterHomeScreen._openDashboard` ส่ง `widget.notificationController` ต่อให้
- กดแล้ว `Navigator.push(MaterialPageRoute(builder: (_) => NotificationSettingsScreen(controller: notificationController)))` (แบบ `_openFoodProfile`)
- ความกว้าง AppBar ที่ 360 dp: ปุ่มย้อนกลับ 56 + title 「แดชบอร์ด」 + 48 → ไม่ล้นทั้ง textScaler 1.0 / 1.5
- ห้ามแตะ AppBar ของ `WaterHomeScreen` (คง 5 ปุ่มเดิม) และห้ามแก้ส่วนอื่นของ `DashboardScreen`

### 2.1 S-1 การ์ดขอความยินยอม (Consent Card)

จุดประสงค์ (ux-flow §1): แสดงทับหน้า Home เมื่อเข้าหน้า Home ครั้งแรกหลัง Onboarding เพื่อให้ผู้ใช้เลือกอนุญาตหรือไม่อนุญาตรับแจ้งเตือน (แสดงครั้งเดียว)

**เงื่อนไขแสดง / ครั้งเดียว:**
- แสดงจาก `WaterHomeScreen` (= Home, D-10) เมื่อ `widget.notificationController != null` และ `controller.isLoaded` และ `controller.consentStatus == NotificationConsentStatus.unanswered` (AC-1) — `consent_status` ถูกเขียนเป็น ALLOWED/DENIED ครั้งเดียวเมื่อกดปุ่ม → เข้า Home ครั้งที่ 2 ไม่แสดง (AC-4)
- ไม่แก้เส้นทางของ signup (`SignupGate` เลือก Home เองหลัง Onboarding — ux-flow §2 S-1) · `WaterHomeScreen` รับพารามิเตอร์ใหม่ `NotificationController? notificationController` (null = ไม่มีการ์ด/deep link — เทสต์ water เดิมไม่เปลี่ยน)
- เปิดด้วย `WidgetsBinding.instance.addPostFrameCallback` → `showDialog<void>(context, barrierDismissible: false, builder: …)` แบบ `_showSensorDialog` ของ steps · กันเปิดซ้ำด้วย flag `_consentDialogOpen` ใน State (rebuild ระหว่างการ์ดเปิดอยู่ต้องไม่เปิดใบที่ 2)
- **บล็อกการกดทะลุ:** dialog route คลุมทั้งจอรวม AppBar · `barrierDismissible: false` (แตะฉากหลังไม่ปิด) · ห่อเนื้อหาด้วย `PopScope(canPop: false)` (ปุ่ม back ของระบบไม่ปิด — Q-22) → ปิดได้ทางปุ่มอนุญาต/ไม่อนุญาตเท่านั้น

**โครง:** `PopScope(canPop: false)` → `Dialog(key: Key('notification_consent_card'))` (default สี/มุม/inset) → `SingleChildScrollView` → `Padding(24)` → `Column(mainAxisSize: min, crossAxisAlignment: stretch)`

จากบนลงล่าง:

| # | องค์ประกอบ (ux-flow §2 S-1) | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 1 | รูปโปรไฟล์น้องอ๊บ (D-1) | `Center` → `KeyedSubtree(key)` → `PetCharacter(pose: PetPose.notificationProfile, size: NotificationRules.consentPetSize, animate: widget.animatePet ?? kPetAnimateByDefault, reactToTap: false, semanticLabel: NotificationRules.petSemanticLabel)` — ไม่ส่ง `cheerTrigger` | ภาพขยิบตาทำปากจู๋ + หัวใจ คงที่ (§4) · `semanticLabel` 「น้องอ๊บขยิบตา」 **(เสนอ — จาก character.md §7)** ไม่แสดงบนจอ | 120 × 120 | `notification_consent_pet_image` (บน `KeyedSubtree`) |
| — | `SizedBox(height: 16)` | | | | |
| 2 | หัวข้อการ์ด | `Text(textAlign: center)` | 「น้องอ๊บอยากส่งเสียงหา!」 (`NotificationRules.consentTitle`) | `headlineSmall` | `notification_consent_title_text` |
| — | `SizedBox(height: 8)` | | | | |
| 3 | รายละเอียดการ์ด | `Text(textAlign: center)` | 「อนุญาตให้น้องอ๊บแจ้งเตือนเรื่องการเดิน การดื่มน้ำ และการกินอาหารนะค้าบ」 (`NotificationRules.consentBody`) | `bodyMedium` + `onSurfaceVariant` | `notification_consent_body_text` |
| — | `SizedBox(height: 24)` | | | | |
| 4 | ปุ่มอนุญาต (Primary) | `FilledButton(onPressed: _onAllow, child: Text(...))` | 「อนุญาต」 (`NotificationRules.allowButtonText`) | default `FilledButton` | `notification_consent_allow_button` |
| — | `SizedBox(height: 8)` | | | | |
| 5 | ปุ่มไม่อนุญาต (Secondary) | `OutlinedButton(onPressed: _onDeny, child: Text(...))` | 「ไม่อนุญาต」 (`NotificationRules.denyButtonText`) | default `OutlinedButton` | `notification_consent_deny_button` |

**เมื่อกด** (พฤติกรรมตาม ux-flow §2 S-1 / AC-2, AC-3, AC-5 — ไม่เขียนกติกาใหม่):
- 「อนุญาต」 → `Navigator.pop` การ์ด **ก่อน** แล้วเรียก `controller.answerConsent(allowed: true)` (บันทึก `consent_status = ALLOWED`, `notification_master_switch = ON` → เรียกกล่องขอสิทธิ์ของระบบต่อทันที → GRANTED = ตั้งเวลารอบวันปัจจุบัน) — กล่องของ OS ขึ้นหลังการ์ดปิดแล้ว
- 「ไม่อนุญาต」 → `Navigator.pop` แล้ว `controller.answerConsent(allowed: false)` (บันทึก `DENIED` / `OFF` · **ไม่เรียก** `scheduler.requestPermission()`)
- กดปุ่มใดปุ่มหนึ่งแล้วปุ่มทั้งสองไม่รับการกดซ้ำ (การ์ดปิดในเฟรมเดียวกัน)

**งบความสูงที่จอ 360×640 dp:** การ์ดกว้าง 360 − 2 × 40 = 280 (เนื้อหา 232) · textScaler 1.0: 24 + 120 + 16 + หัวข้อ ~2 บรรทัด 64 + 8 + รายละเอียด ~3 บรรทัด 60 + 24 + 40 + 8 + 40 + 24 ≈ 430 · textScaler 1.5: ≈ 24 + 120 + 16 + ~3 บรรทัด 108 + 8 + ~5 บรรทัด 150 + 24 + 48 + 8 + 48 + 24 ≈ 580 < 640 − 2 × 24 = 592 → ไม่ต้องเลื่อน · จอเตี้ยกว่านี้ = `SingleChildScrollView` เลื่อนได้ ไม่ overflow

### 2.2 S-2 หน้าตั้งค่าแจ้งเตือน (Notification Settings Screen)

จุดประสงค์ (ux-flow §1): เปิด/ปิดแจ้งเตือนทั้งหมดผ่านสวิตช์หลัก 1 อัน และดูสถานะกรณีสิทธิ์ถูกปิดจากระบบ

ไฟล์: `app/lib/features/notification/screens/notification_settings_screen.dart` — `NotificationSettingsScreen({required NotificationController controller})`

โครง: `Scaffold` → `AppBar(title: Text(...))` (ปุ่มย้อนกลับอัตโนมัติ — ถูก push จาก dashboard) → body `ListenableBuilder(listenable: controller)` → `!controller.isLoaded` = `Center(CircularProgressIndicator())` → `SafeArea` → `ListView(padding: EdgeInsets.all(16))`

| # | องค์ประกอบ (ux-flow §2 S-2) | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 0 | หัวข้อหน้าตั้งค่า | `AppBar(title: Text(...))` | 「การแจ้งเตือนของน้องอ๊บ」 (`NotificationRules.settingsTitle`) | AppBar default | `notification_settings_header_text` (บน `Text`) |
| 1 | สวิตช์เปิด/ปิดแจ้งเตือนทั้งหมด | `SwitchListTile(key, value: controller.isSwitchOn, onChanged: controller.setMasterSwitch, contentPadding: EdgeInsets.zero, title: Text(...))` | ป้าย 「เปิด/ปิดแจ้งเตือนทั้งหมด」 (`NotificationRules.masterSwitchLabel`) **(เสนอ — รอยืนยัน, Q-03** — ux-flow ไม่มีป้ายสวิตช์ ใช้ชื่อองค์ประกอบใน ux-flow) · ค่า ON/OFF ตาม §3 | default `SwitchListTile` | `notification_master_switch` (บน `SwitchListTile`), `notification_master_switch_label` (บน `Text`) |
| 2 | ข้อความสถานะเมื่อสิทธิ์ถูกปิดจากระบบ — **เฉพาะ** `controller.systemPermission == NotificationSystemPermission.denied` | `SizedBox(height: 8)` → `Container(key, padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: errorContainer, borderRadius: BorderRadius.circular(8)))` → `Text(...)` | 「สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน」 (`NotificationRules.permissionDeniedText` — Q-02 ปิดแล้ว) | `bodyMedium` + `onErrorContainer` | `notification_permission_denied_banner` (บน `Container`), `notification_permission_denied_text` (บน `Text`) |

- ไม่มีปุ่ม "ไปที่การตั้งค่าเครื่อง" (ux-flow ไม่มี — Q-05) · ไม่มีรายการรายประเภท (requirements §5)
- `controller.isSwitchOn` = `masterSwitch == ON && systemPermission == GRANTED` (AC-5, AC-8) — ระหว่างรอกล่องขอสิทธิ์ของ OS สวิตช์แสดงค่าที่ผู้ใช้เพิ่งกด (`pendingSwitchValue`) จนกว่าผลจะกลับมา
- **กดสลับรัว ๆ (EC-1) — สถานะสุดท้ายชนะ (ไม่ใช้ timer debounce):** `setMasterSwitch(v)` เขียน `notification_master_switch` และ `notifyListeners()` ทันที (สวิตช์ขยับทุกครั้งที่กด) แล้วเรียก `_sync()` ที่ **ทำทีละครั้ง (serialized) และรวบคำสั่งที่ค้าง (coalesce)**: ถ้ามี sync กำลังทำ ให้ตั้ง `_dirty = true` แล้วออก · sync ที่กำลังทำจบแล้วเห็น `_dirty` → ทำใหม่ 1 รอบด้วยค่าล่าสุด · ผล: รายการที่ตั้งไว้ใน scheduler ตรงกับค่าสุดท้ายเท่านั้น (เทสต์: ON/OFF/ON/OFF ติดกันใน 1 เฟรม → fake scheduler ไม่มีรายการค้าง)
  - OFF → ยกเลิกรายการที่ยังไม่ถึงเวลาทั้งหมดของวันนี้ (AC-7 — §2.4.5)
  - ON + `NOT_DETERMINED` → `scheduler.requestPermission()` (AC-6, EC-9) — ระหว่างรอ ห้ามขอซ้ำ (flag `_requestingPermission`) · GRANTED → วางแผนรอบวันปัจจุบัน · DENIED → สถานะ PERMISSION_DENIED
  - ON + `DENIED` → เรียก `requestPermission()` อีก 1 ครั้ง (OS ตัดสินว่าจะแสดงกล่องหรือไม่) ยังปฏิเสธ = สวิตช์กลับเป็น OFF + กล่องข้อความยังอยู่ **(ชั่วคราว — Q-05)**
- **เช็กสิทธิ์ตอน resume:** `WaterHomeScreen.didChangeAppLifecycleState(resumed)` (มีอยู่แล้ว ใช้รีเซ็ตน้ำ) เรียก `widget.notificationController?.onAppResumed()` เพิ่ม 1 บรรทัด → controller เรียก `scheduler.checkPermission()` (ไม่แสดงกล่อง) → อัปเดต `system_permission_status` → GRANTED: วางแผนใหม่ · DENIED: ยกเลิกรายการค้าง → S-2 ที่เปิดค้างอยู่วาดใหม่ทันทีผ่าน `ListenableBuilder` (ผู้ใช้ไปปิด/เปิดสิทธิ์ในการตั้งค่าเครื่องแล้วกลับมา — EC-10) · `WaterHomeScreen` เป็น root เสมอขณะอยู่ใน S-2 จึงได้รับ lifecycle (ไม่ต้องเพิ่ม observer ใน S-2)
- งบที่ 360×640: AppBar + 16 + สวิตช์ ~56 (1.5: ~72 ป้ายขึ้น 2 บรรทัด) + 8 + กล่อง ~3 บรรทัด 76 (1.5: ~5 บรรทัด 166) ≈ 330 → ไม่ล้น · `ListView` เลื่อนได้เสมอ

### 2.3 S-3 การแจ้งเตือนบนระบบปฏิบัติการ (OS Notification Display)

ไม่มี widget ในแอป — กำหนด "หน้าตา" ผ่าน `NotificationDetails` ของ `flutter_local_notifications`

#### 2.3.1 ตารางข้อความ (ux-flow §2 S-3 / game-rules §1.1 — ตรงตัว)

`enum NotificationMessage` ใน `notification_models.dart` — `text` อ่านจาก `NotificationRules` · `topic` กำหนดปลายทาง (§2.3.3) · ลำดับ enum = ลำดับในเอกสาร

| enum | ชื่อเรียก | topic | ข้อความ (`NotificationRules.<…>Text`) |
|---|---|---|---|
| `walkInactive` | เดิน: ไม่ขยับ | `walk` | 「อย่าลืมขยับบ้างนะ อย่ามัวแต่นั่งอืด ลุกขึ้นมาเดินเร็ว!!」 |
| `walkNearGoal` | เดิน: ใกล้เป้า | `walk` | 「มาขยับร่างกายกันอีกนิด ใกล้ถึงเป้าหมายแล้วสู้ๆ」 |
| ~~`walkManual`~~ | ~~เดิน: บันทึกเอง~~ | — | **ไม่มีในโค้ด (D-3)** |
| `waterFirst` | น้ำ: 2 ชม. | `water` | 「อย่าลืมดื่มน้ำน้าา ผิวกบของน้องขาดความชุ่มชื้น น้องอ๊บไม่ชอบ」 |
| `waterSecond` | น้ำ: 4 ชม. | `water` | 「โปรดดื่มน้ำเถอะคนนี้ น้องอ๊บคอแห้งไม่ไหวแล้วววว ดื่มน้ำๆๆ」 |
| `foodUnlogged` | อาหาร: ยังไม่กิน | `food` | 「กินข้าวยัง อย่าลืมพักกินข้าวบ้างนะค้าบ แล้วอย่าลืมมาให้อาหารน้องอ๊บด้วย」 |
| `foodNight` | อาหาร: 21:00 | `food` | 「น้องอ๊บหิวแล้วน้า ถ้าทานแล้วมาบอกน้องอ๊บด้วยนะ」 |

#### 2.3.2 รูปแบบตาม OS

**Android — แชต 3 ส่วน (AC-36):** ชื่อผู้ส่ง + รูปโปรไฟล์ + ข้อความ

```dart
// ค่าทั้งหมดจาก NotificationRules — ตัวอย่างรูปแบบ ไม่ใช่โค้ดสำเร็จ
final person = Person(
  key: NotificationRules.senderKey,          // 'nong_ob'
  name: NotificationRules.senderName,        // 「น้องอ๊บ」
  icon: ByteArrayAndroidIcon(avatarPngBytes), // §2.3.2 avatar (D-1)
);
AndroidNotificationDetails(
  NotificationRules.androidChannelId,          // 'petpal_reminders'
  NotificationRules.androidChannelName,        // 「แจ้งเตือนจากน้องอ๊บ」 (เสนอ — Q-09)
  channelDescription: NotificationRules.androidChannelDescription, // 「เตือนเรื่องการเดิน การดื่มน้ำ และการกินอาหาร」 (เสนอ — Q-09)
  importance: Importance.defaultImportance,    // (ชั่วคราว — Q-09)
  priority: Priority.defaultPriority,
  category: AndroidNotificationCategory.message,
  icon: NotificationRules.androidSmallIcon,    // '@mipmap/ic_launcher' (ชั่วคราว — Q-10)
  color: Colors.lightBlue,                     // seed เดิมของ main.dart (§1.1)
  styleInformation: MessagingStyleInformation(
    person,
    groupConversation: false,
    messages: [Message(message.text, scheduledTime, person)],
  ),
);
// zonedSchedule(id, NotificationRules.senderName /* title */, message.text /* body */, ...)
```

- title = 「น้องอ๊บ」, body = ข้อความ (เครื่องที่ไม่วาด MessagingStyle ยังเห็นครบ 2 ส่วน)
- ข้อความ 1 รายการต่อ 1 แจ้งเตือน · id ไม่ซ้ำต่อรายการ (§2.4.5) — ไม่รวมเป็นกลุ่ม
- **Avatar:** `NotificationAvatarSource` (เสนอ `notification_avatar.dart`) วาด `const PetCharacterPainter(pose: PetPose.notificationProfile)` (breath 0 = ภาพนิ่ง) ลง `ui.PictureRecorder` ขนาด `NotificationRules.avatarSizePx` (192) → `canvas.clipPath(วงรีเต็มกรอบ)` → `toImage` → PNG bytes (โค้ดตัวอย่าง character.md §7 `renderNotificationAvatar`) · **ไม่เติมพื้น** (โปร่งใส) · **แคชในหน่วยความจำ** หลังเรนเดอร์ครั้งแรก (`Future<Uint8List>` ตัวเดียวต่อ process) · เรนเดอร์ตอนตั้งเวลา (แอปเปิดอยู่) — bytes ถูกฝากไว้กับรายการที่ตั้งเวลาแล้ว ไม่ต้องใช้ engine ตอน OS ยิง · ถ้าเรนเดอร์ไม่สำเร็จ → ส่ง `Person` ไม่มี `icon` (ยังเป็นแชต มีชื่อ + ข้อความ) ไม่ล้ม
- ห้ามโหลดภาพจาก assets / ห้าม `DrawableResourceAndroidBitmap` ภาพกบ

**iOS — ปกติ 2 ส่วน (AC-37):** ไอคอนแอป + ข้อความ — ไม่มีรูปโปรไฟล์

```dart
const DarwinNotificationDetails(
  presentAlert: true, presentBanner: true, presentList: true, presentSound: true,
  presentBadge: false,
);
// zonedSchedule(id, null /* ไม่มี title */, message.text, ...) — iOS แสดงไอคอน + ชื่อแอปเองที่หัวแจ้งเตือน
```

- title = `null` บน iOS (แยก title ตาม `defaultTargetPlatform` ใน `LocalNotificationScheduler`) · ไม่มี attachment

**แอปเปิดอยู่ (foreground):** แสดงแจ้งเตือนของ OS ตามปกติทั้งสอง OS (Android default, iOS `presentBanner: true`) — ไม่แสดง SnackBar / dialog ในแอปแทน (Q-26)

#### 2.3.3 Payload และ Deep link (ux-flow §3.1 — AC-38 ถึง AC-40, EC-2, EC-13)

- payload = `'<topic>|<message>'` เช่น `'water|waterFirst'` — `NotificationLogic.encodePayload` / `decodePayload` (pure) · topic ไม่รู้จัก/อ่านไม่ได้ → เปิดแอปเฉย ๆ ไม่นำทาง
- ปลายทาง:

| topic | ปลายทาง | วิธีนำทางใน `WaterHomeScreen` |
|---|---|---|
| `walk` | หน้าฟีเจอร์เดิน `StepsDashboardScreen` | `popUntil(isFirst)` → push `StepsDashboardScreen(controller: _stepsController())` (ตัวเดียวกับ `_openSteps`) |
| `water` | หน้าฟีเจอร์น้ำ = `WaterHomeScreen` (หน้าแรก — D-10) | `popUntil(isFirst)` เท่านั้น |
| `food` | หน้าฟีเจอร์อาหาร `FoodDashboardScreen` | `popUntil(isFirst)` → push `FoodDashboardScreen(controller: _foodController())` (ตัวเดียวกับ `_openFood`) |

- รับการกดทั้ง 3 สถานะแอป:
  - `FOREGROUND` / `BACKGROUND`: `initialize(onDidReceiveNotificationResponse: (r) => controller.handleNotificationTap(r.payload))` — Activity เป็น `singleTop` อยู่แล้ว (manifest) จึงไม่สร้างหน้าใหม่
  - `TERMINATED` (EC-13): ใน `main()` หลัง `initialize` เรียก `scheduler.launchPayload()` (= `getNotificationAppLaunchDetails()` ที่ `didNotificationLaunchApp == true`) → `controller.handleNotificationTap(payload)` ก่อน `runApp`
- `handleNotificationTap` เก็บ `pendingDeepLink` (ในหน่วยความจำเท่านั้น) + `notifyListeners()` · `WaterHomeScreen` ฟัง controller แล้ว **post-frame** เรียก `controller.takePendingDeepLink()` (คืนค่าแล้วล้างเป็น null — ใช้ได้ครั้งเดียว) แล้วนำทางตามตาราง · ทำเฉพาะเมื่อ `WaterHomeScreen` mounted และ `WaterController.isLoaded` (ยังไม่เข้า Home เช่นอยู่หน้า signup → ค้างไว้จนเข้า Home — Q-16)
- **กันหน้าซ้อน (EC-2):** ทุกครั้ง `popUntil((r) => r.isFirst)` ก่อน แล้ว push ปลายทาง **ไม่เกิน 1 หน้า** → stack หลังกด = `[Home]` (น้ำ) หรือ `[Home, ปลายทาง]` (เดิน/อาหาร) เสมอ ไม่ว่าจะกดกี่ครั้ง หรือก่อนหน้าอยู่หน้าไหน (รวม S-2 / dashboard) — หน้าที่ถูก pop เสียสถานะ (Q-17)
- ไม่มี named route / `navigatorKey` ใหม่ใน `MaterialApp` (ใช้ `Navigator.of(context)` ของ `WaterHomeScreen` — controller ของ steps/food ตัวเดียวกัน D-9)

### 2.4 โครงชั้นโค้ดที่แนะนำ + การวางคิว (สำหรับ Dev / QA)

โฟลเดอร์ `app/lib/features/notification/` (pattern เดียวกับ water / steps / food / dashboard / seven_day):

| ไฟล์ | ชั้น | เนื้อหา |
|---|---|---|
| `notification_rules.dart` | ค่าคงที่ | `NotificationRules` — ค่าหลัก §2.4.2 + ข้อความ §2.1–2.3 + token §1.3 · คอมเมนต์ `// DECIDED (owner 2026-11-08, D-x)` / `// ASSUMPTION: ui-spec Q-xx` |
| `notification_models.dart` | model (immutable) | `NotificationConsentStatus {allowed, denied, unanswered}` · `NotificationSystemPermission {granted, denied, notDetermined}` (ทั้งสองมี `code` = ค่า CODE_ENUM ของ game-rules เช่น `'ALLOWED'`, `'NOT_DETERMINED'` และ `fromCode`) · `NotificationTopic {food, water, walk}` + `priority` (food 3 > water 2 > walk 1) + `payloadCode` · `NotificationMessage` (§2.3.1) · `NotificationInputs` (snapshot §2.4.1) · `PlannedNotification {id, message, anchor, dueAt, scheduledAt}` · `NotificationDayPlan {day, items, suppressedTopics}` (+ toJson/fromJson) |
| `notification_logic.dart` | **logic pure** (ไม่ import Flutter widget / plugin / shared_preferences) | `logicalDay(now)` (= `WaterLogic.logicalDay`) · `isQuietTime(t, day)` · `candidates(inputs, plan, now)` · `buildPlan(inputs, previous, now) → NotificationDayPlan` · `committed(plan, now)` · `sentCount` / `lastSentAt` / `walkNearGoalSentToday` (derive จาก plan) · `notificationId(item)` · `encodePayload` / `decodePayload` — ทุกฟังก์ชันรับ `now` เป็นพารามิเตอร์ |
| `notification_repository.dart` | storage | `NotificationStorageKeys` (§2.5) · `abstract NotificationRepository { load(); save(state); }` · `InMemoryNotificationRepository` · `SharedPrefsNotificationRepository` (อ่านทีละคีย์ ค่าผิดชนิด = ค่าเริ่มต้น แบบ `SharedPrefsWaterRepository`) |
| `notification_scheduler.dart` | abstraction (fake ได้) | `abstract interface class NotificationScheduler { Future<void> initialize({required void Function(String? payload) onTap}); Future<String?> launchPayload(); Future<NotificationSystemPermission> checkPermission(); Future<NotificationSystemPermission> requestPermission(); Future<void> schedule(PlannedNotification item); Future<void> cancel(int id); }` · `NoopNotificationScheduler` (แพลตฟอร์มอื่น เช่น windows / เทสต์ที่ไม่สนใจ) |
| `notification_local_scheduler.dart` | ตัวจริง (plugin) | `LocalNotificationScheduler implements NotificationScheduler` — `flutter_local_notifications` + `timezone` + `flutter_timezone` (§5) · แปลง `DateTime` → `tz.TZDateTime.from(t, tz.local)` · `zonedSchedule(..., androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, payload: ...)` (D-6) · `scheduledAt` ≤ now + 5 วินาที → `show()` ทันที · ใช้เฉพาะ Android / iOS (`defaultTargetPlatform`) |
| `notification_avatar.dart` | render | `NotificationAvatarSource` (abstract `Future<Uint8List?> avatarPng()`) + `PainterNotificationAvatarSource` (แคช) — §2.3.2 |
| `notification_controller.dart` | controller | `NotificationController extends ChangeNotifier` — รับ `repository`, `scheduler`, `avatar`, `water: WaterController`, `steps: StepsController`, `food: FoodController`, `clock` (default `DateTime.now` — **เทสต์ส่ง clock ตัวเดียวกับ 3 controller**), `timerFactory` (optional) · `load()`, `start()` (load 3 controller ถ้ายังไม่โหลดแบบ `DashboardController.start()` + addListener ทั้ง 3 + Timer `dayCheckInterval`), `answerConsent({required bool allowed})`, `setMasterSwitch(bool)`, `onAppResumed()`, `handleNotificationTap(String?)`, `takePendingDeepLink()`, getters `isLoaded`, `consentStatus`, `masterSwitch`, `systemPermission`, `isSwitchOn`, `pendingDeepLink` · `dispose()` ถอด listener + cancel Timer |
| `screens/notification_settings_screen.dart` | UI | S-2 (§2.2) |
| `widgets/notification_consent_card.dart` | UI | S-1 (§2.1) + `Future<void> showNotificationConsentCard(BuildContext, NotificationController, {bool? animatePet})` |

ไฟล์เดิมที่ต้องแก้ (เท่านี้): `app/lib/main.dart` (สร้าง/initialize/launchPayload/ส่ง controller — `main()` เป็น `async`), `water_home_screen.dart` (พารามิเตอร์ `notificationController`, เปิด S-1, deep link, `onAppResumed`, ส่งต่อให้ dashboard), `dashboard_screen.dart` (พารามิเตอร์ + ปุ่ม §2.0), `app/pubspec.yaml` (3 package), `app/android/app/src/main/AndroidManifest.xml`, `app/android/app/build.gradle.kts` (§5) · `PetPalApp` รับ `NotificationController? notificationController` (null = พฤติกรรมเดิม)

#### 2.4.1 ข้อมูลที่อ่าน (D-9 — อ่านอย่างเดียว ไม่เก็บซ้ำ)

`today` = `NotificationLogic.logicalDay(now)` · ค่าที่ไม่ใช่ของรอบวันนี้ถือเป็นค่าวันใหม่ (controller อื่นรีเซ็ตแบบ lazy)

| ค่าใน game-rules | แหล่งในโค้ด | หมายเหตุ |
|---|---|---|
| `daily_water_count` | `WaterController.cups` เมื่อ `logicalDay(state.lastLoggedAt) == today` ไม่เช่นนั้น 0 | `SharedPrefsWaterRepository` clamp ค่าติดลบเป็น 0 อยู่แล้ว — logic ยังตรวจ EC-3 |
| `last_logged_timestamp` (น้ำ) | `WaterController.state.lastLoggedAt` (ใช้เมื่ออยู่ในรอบวันนี้) | |
| `current_steps` | `StepsController.steps` เมื่อ `state.day == today` ไม่เช่นนั้น 0 | ก้าวจำลองด้วยปุ่ม +1000 (`StepsRules.stepsPerTap`) |
| `daily_goal` | `StepsController.activeGoal` | |
| ตรวจก้าวไม่ได้ | `StepsController.isTrackingLocked` | true → ไม่มีข้อความเรื่องเดิน (D-3) |
| "มีก้าวใหม่" | controller ฟัง `StepsController` — `steps` มากกว่าค่าที่เห็นล่าสุดในรอบวันเดียวกัน → เขียน `last_steps_increased_timestamp = clock()` | key ของ notification เอง (game-rules §1.2) — StepsState ไม่มีเวลาก้าวล่าสุด |
| `total_calories` | `FoodController.totalCalories` เมื่อ `state.day == today` ไม่เช่นนั้น 0 | |
| เป้าแคลอรี่ | `FoodController.targetCalories` (null = ไม่มีเป้า / ข้ามโปรไฟล์) | |

controller วางแผนใหม่ (`_sync`) เมื่อ: `start()` (เปิดแอป — EC-14), ค่าจาก 3 controller เปลี่ยน, เปลี่ยนสวิตช์/สิทธิ์, resume, Timer พบว่ารอบวันเปลี่ยน (05:00)

#### 2.4.2 ค่าคงที่ (`NotificationRules` — ชื่อจาก game-rules §1 แบบ lowerCamel ตาม `SevenDayRules`)

| game-rules | `NotificationRules.` | ค่า |
|---|---|---|
| `DAILY_RESET_TIME` | `dailyResetHour` / `dailyResetMinute` | `= WaterRules.dailyResetHour` / `WaterRules.dailyResetMinute` (5:00 — D-8, ไม่ตั้งเลขซ้ำ) |
| `QUIET_HOURS_START_TIME` | `quietHoursStartHour/Minute/Second` | 23:00:00 (รวมขอบ) |
| `QUIET_HOURS_END_TIME` | `quietHoursEndHour/Minute/Second` | 05:59:59 (รวมขอบ) |
| `ACTIVE_HOURS_START_TIME` | `activeHoursStartHour/Minute/Second` | 06:00:00 (รวมขอบ) |
| `DAILY_NOTIFICATION_CAP` | `dailyNotificationCap` | 6 |
| `MIN_NOTIFICATION_INTERVAL_MINUTES` | `minNotificationIntervalMinutes` | 30 |
| `WALK_INACTIVITY_HOURS` | `walkInactivityHours` | 4 |
| `WALK_MAX_DELAY_MINUTES` | `walkMaxDelayMinutes` | 60 — เอกสารเท่านั้น logic ไม่ใช้ตัดทิ้ง (D-6, Q-07) |
| `WALK_NEAR_GOAL_MIN_PERCENT` | `walkNearGoalMinPercent` | 80.00 (รวมขอบ) |
| `WALK_NEAR_GOAL_MAX_EXCLUSIVE_PERCENT` | `walkNearGoalMaxExclusivePercent` | 100.00 (ไม่รวมขอบ) |
| `WATER_INACTIVITY_FIRST_HOURS` | `waterInactivityFirstHours` | 2 |
| `WATER_INACTIVITY_SECOND_HOURS` | `waterInactivitySecondHours` | 4 |
| `WATER_DAILY_GOAL_GLASSES` | `waterDailyGoalGlasses` | `=> DashboardRules.waterTargetCups` (8 — D-11) |
| `FOOD_UNLOGGED_TIME_1/2/3` | `foodUnloggedHours` | `[12, 15, 18]` (นาที/วินาที 0) |
| `FOOD_NIGHT_REMINDER_TIME` | `foodNightReminderHour` | 21 |
| ~~`WALK_MANUAL_INACTIVITY_HOURS`~~ | — | ไม่มี (D-3) |

เปอร์เซ็นต์ก้าวเทียบแบบจำนวนเต็มเพื่อเลี่ยงทศนิยม: `steps * 100 >= goal * 80 && steps * 100 < goal * 100` (8,000 / 10,000 → ส่ง · 7,999 → ไม่ส่ง · 9,999 → ส่ง · 10,000 → ไม่ส่ง)

#### 2.4.3 ผู้สมัคร (candidates) — แปลง game-rules §1.1 เป็นเวลา `dueAt`

ทุกเวลาเป็นเวลาเครื่องของวันตาม `today` (วันที่ปฏิทิน = `today`) · `active` = `today` 06:00:00 · `anchor(x)` = ค่าที่มาทีหลังระหว่าง (x ถ้าอยู่ในรอบวันนี้) กับ `active` (game-rules §1.1 "ตัวนับเวลาหลังช่วงห้ามเตือน")

| message | เกิดเมื่อ (ณ เวลาวางแผน) | `anchor` | `dueAt` |
|---|---|---|---|
| `walkInactive` | `!isTrackingLocked` | `anchor(last_steps_increased_timestamp)` | anchor + 4 ชม. |
| `walkNearGoal` | `!isTrackingLocked` และ 80% ≤ p < 100% และยังไม่ส่งวันนี้ | — | `now` (เวลาที่ตรวจพบ — Q-08) |
| `waterFirst` | count < 8 | `anchor(lastLoggedAt)` | anchor + 2 ชม. |
| `waterSecond` | count < 8 | `anchor(lastLoggedAt)` | anchor + 4 ชม. |
| `foodUnlogged` × 3 | `total_calories == 0` | dueAt | 12:00:00 / 15:00:00 / 18:00:00 |
| `foodNight` | มีเป้า: total < เป้า · ไม่มีเป้า: total == 0 | dueAt | 21:00:00 |

- "ส่งครั้งเดียวต่อรอบนับ": ถ้า plan ของวันนี้มีรายการ **committed** (§2.4.5) ที่ `message` + `anchor` เดียวกัน → ไม่เป็นผู้สมัครอีก (บันทึกน้ำ/ก้าวใหม่ → anchor เปลี่ยน → รอบนับใหม่)
- EC-3 (D-4): เรื่องใดมีค่าติดลบ (`current_steps`, `daily_water_count`, `total_calories`) หรือ `daily_goal == 0` → ใส่ topic ใน `suppressedTopics` ของ plan วันนี้ → ไม่มีผู้สมัครของ topic นั้นจนจบรอบวัน (แม้ค่าจะกลับมาถูก — Q-20)
- **ผู้สมัครที่เลยเวลาแล้ว** (`dueAt < now` และไม่ได้ committed — เกิดเมื่อไม่ได้เปิดแอปตอนถึงเวลา EC-14): ถือเป็น "ถูกเลื่อน" ส่งได้ตั้งแต่ `now` แต่ในแต่ละสาย (`waterFirst`→`waterSecond`, `foodUnlogged` 12→15→18) **เก็บเฉพาะขั้นล่าสุดที่เลยเวลา** (ขั้นที่ยังไม่ถึงเวลาคงไว้ตามปกติ) **(ชั่วคราว — Q-06)** · ยกเว้น `walkNearGoal` (dueAt = now อยู่แล้ว)

#### 2.4.4 การจัดคิว (pure, เทสต์ได้) — `NotificationLogic.buildPlan`

```
committed = รายการใน plan วันนี้ที่ scheduledAt <= now      // ส่งแล้ว — ห้ามแก้/ยกเลิก
count     = committed.length                              // = sent_notification_count
last      = max(committed.scheduledAt) หรือ null           // = last_notification_timestamp
t         = max(now, active, last == null ? -∞ : last + 30 นาที)
quiet     = today 23:00:00
remaining = candidates (§2.4.3)
while remaining ไม่ว่าง && count < 6:
  ready = remaining ที่ dueAt <= t
  if ready ว่าง: t = max(t, min(remaining.dueAt)); continue
  pick = ready เรียงตาม (topic.priority มาก→น้อย, dueAt เร็ว→ช้า, ลำดับ enum).first
  if t >= quiet: break                                    // ถึง 23:00:00 แล้ว → ที่เหลือถูกยกเลิก (AC-33)
  pending += pick ที่ scheduledAt = t; count++; t = t + 30 นาที; remaining -= pick
// ที่เหลือใน remaining = ไม่ส่งรอบวันนี้ (ชนเพดาน AC-28 / ช่วงห้ามเตือน AC-26)
plan = committed + pending
```

- ขอบ: `scheduledAt` 22:59:59 ส่งได้ · 23:00:00 ไม่ส่ง · ห่าง 29:59 นาที → ถูกเลื่อนเป็น 30:00 พอดี (AC-29, AC-30) · ไม่มีรายการก่อน 06:00:00 (`t >= active`)
- ไม่วางแผนข้ามรอบวัน — วันใหม่ตั้งตอนเปิดแอป/Timer พบรอบวันใหม่ (EC-14) · `sent_notification_count` / `walk_near_goal_sent_today` รีเซ็ตเพราะ plan เป็นของวันใหม่ (AC-35)
- ไม่มีการตัดทิ้งเพราะช้าเกิน 60 นาทีของเรื่องเดิน (D-6 / Q-07)

**กรณีทดสอบขั้นต่ำ (input → `pending.scheduledAt` ที่คาดหวัง)** — clock เดียวกันทุก controller, `isTrackingLocked = false` เว้นแต่ระบุ · T-1 และ T-18 เป็นแผนทั้งวัน · T-2 ถึง T-17 ดูเฉพาะรายการของเรื่องที่ระบุ (ตั้งเรื่องอื่นให้ไม่มีผู้สมัคร เช่น `isTrackingLocked = true`, น้ำ 8 แก้ว, มีอาหารแล้วและถึงเป้า)

| # | สถานการณ์ | ผลที่คาดหวัง | อ้างถึง |
|---|---|---|---|
| T-1 | now 05:30 วันใหม่ ไม่มีบันทึกใด ๆ, เป้าก้าว 8,000, มีเป้าอาหาร | `waterFirst` 08:00 · `waterSecond` 10:00 · `walkInactive` 10:30 (ชน 10:00 กับน้ำ → น้ำก่อน) · `foodUnlogged` 12:00, 15:00, 18:00 · ครบ 6 → **ไม่มี `foodNight`** | AC-16, AC-18, AC-9, AC-20, AC-28, AC-31, EC-15 |
| T-2 | น้ำล่าสุด 08:00 (3 แก้ว) now 08:00 | `waterFirst` 10:00 และ `waterSecond` 12:00 | AC-16–18, game-rules §3 |
| T-3 | น้ำล่าสุด 22:30 เมื่อวาน, now 05:10 | `waterFirst` 08:00 | AC-27 |
| T-4 | ก้าวเพิ่มล่าสุด 08:00, now 08:00 | `walkInactive` 12:00 | AC-9 |
| T-5 | committed 12:00, ผู้สมัคร dueAt 12:29:59 | scheduledAt 12:30:00 | AC-29, AC-30 |
| T-6 | `foodUnlogged` และ `waterFirst` dueAt 12:00 พร้อมกัน | food 12:00, water 12:30 | AC-31, EC-5 |
| T-7 | ผู้สมัครเดียว dueAt 22:59:59 / 23:00:00 | ส่ง 22:59:59 / ไม่มีรายการ | AC-26, EC-7 |
| T-8 | ผู้สมัครถูกเลื่อนจน t = 23:00:00 | ไม่มีรายการ | AC-33 |
| T-9 | committed 6 รายการแล้ว + ผู้สมัครใหม่ | `pending` ว่าง | AC-28 |
| T-10 | steps 7,999 / 8,000 / 9,999 / 10,000 จาก goal 10,000 (now 13:00, ไม่มี committed) | ไม่มี / `walkNearGoal` 13:00 / 13:00 / ไม่มี · committed `walkNearGoal` แล้ว → ไม่มีอีก | AC-10–13 |
| T-11 | steps 7,000 → 10,000 ในการอัปเดตเดียว | ไม่มี `walkNearGoal` | AC-14, EC-11 |
| T-12 | `isTrackingLocked = true` | ไม่มี `walkInactive` / `walkNearGoal` | D-3 |
| T-13 | water 8 / 12 แก้ว | ไม่มี `waterFirst`/`waterSecond` | AC-19, EC-4 |
| T-14 | `foodUnlogged` 12:00 committed แล้วบันทึก 500 kcal ตอน 12:30 | plan ใหม่ไม่มี 15:00 / 18:00 (12:00 ยังอยู่เป็น committed) | AC-20, AC-21 |
| T-15 | 21:00 เป้า 2,000: total 1,500 / 2,000 · ไม่มีเป้า: 0 / 350 | `foodNight` 21:00 / ไม่มี · 21:00 / ไม่มี | AC-22–25 |
| T-16 | `daily_goal == 0` หรือ `current_steps < 0` | ไม่มีข้อความเดินทั้งวัน (ค่ากลับมาถูกแล้วก็ไม่มี) · น้ำ/อาหารยังมี | EC-3, D-4 |
| T-17 | บันทึกน้ำขณะ `waterFirst` รอส่ง (pending) | รายการเดิมถูก `cancel(id)` และมีรายการใหม่ที่ anchor ใหม่ | AC-34, EC-6 |
| T-18 | now 14:00 เปิดแอปครั้งแรกของวัน ไม่มีบันทึก (มีเป้าอาหาร, ไม่มี committed) | (Q-06) ผู้สมัครที่เลยเวลา: `waterFirst` (08) ถูกตัด เหลือ `waterSecond` (10) · `walkInactive` (10) · `foodUnlogged` (12) → แผน: `foodUnlogged` 14:00 · `waterSecond` 14:30 · `foodUnlogged` 15:00 (ขั้น 15 ตรงเวลา — อาหารก่อนเดิน) · `walkInactive` 15:30 · `foodUnlogged` 18:00 · `foodNight` 21:00 = 6 | EC-14, Q-06 |

#### 2.4.5 ตั้งเวลาจริง / ยกเลิก (`NotificationController._sync`)

1. โหลด plan เดิมของวันนี้ (`notification_day_plan`) — วันไม่ตรง = plan ว่าง (รีเซ็ต 05:00)
2. ถ้า `!isSwitchOn` (OFF / ไม่ใช่ GRANTED / consent ไม่ใช่ ALLOWED): `cancel(id)` ทุกรายการ pending (`scheduledAt > now`) → เก็บ plan = committed เท่านั้น (AC-7, AC-8)
3. ไม่เช่นนั้น `buildPlan` → `cancel(id)` รายการ pending เดิมที่ไม่อยู่ในแผนใหม่ · `schedule()` รายการใหม่ที่ยังไม่ได้ตั้ง (id เดิม + เวลาเดิม = ไม่ตั้งซ้ำ)
4. บันทึก `notification_day_plan` และเขียนค่าที่ derive: `sent_notification_count`, `last_notification_timestamp`, `walk_near_goal_sent_today`
- **ห้าม `cancelAll()` / ห้าม `cancel` รายการ committed** — บน Android การ cancel id ที่แสดงแล้วจะลบออกจากถาดแจ้งเตือน (และรายการที่ยิงช้าเพราะ inexact ยังต้องยิงได้ — D-6)
- `id` = `NotificationLogic.notificationId(item)` — hash แบบกำหนดได้ของ `'<yyyy-MM-dd ของ today>|<message>|<anchor ISO>'` & `0x7fffffff` (ไม่ชนกันข้ามวัน/ข้ามรอบนับ — Q-25)
- consent `ALLOWED` แต่ `system_permission_status == NOT_DETERMINED` (เช่นปิดแอประหว่างกล่องขอสิทธิ์) → ไม่ตั้งเวลา สวิตช์แสดง OFF จนผู้ใช้เปิดเอง

#### 2.4.6 การเทสต์

- logic: เทสต์ `NotificationLogic.buildPlan` ด้วยตาราง §2.4.4 โดยตรง (ไม่ต้องมี widget)
- controller / widget: `FakeNotificationScheduler` (ใน `app/test/`) บันทึก `scheduled` (id → item), `cancelled`, จำนวนครั้ง `requestPermission`, ตั้งผลของ `checkPermission`/`requestPermission` ได้ · `FakeNotificationAvatarSource` คืน `Uint8List(0)` (ไม่ต้อง `toImage` ใน widget test)
- ตรวจ "เวลาที่ตั้ง" (`scheduledAt`) ไม่ใช่เวลาที่ OS ยิง (D-6) · ห้ามเรียก plugin จริงในเทสต์ (`LocalNotificationScheduler` ไม่ถูกสร้างใน test)
- clock: ฟังก์ชันเดียวกันส่งให้ `WaterController(clock:)`, `StepsController(clock:)`, `FoodController(clock:)`, `NotificationController(clock:)`

### 2.5 Storage keys (`NotificationStorageKeys` — shared_preferences, ชื่อตรง game-rules §1.2 แบบ `WaterStorageKeys`)

| ค่าคงที่ | key | ชนิดที่เก็บ | ค่าเริ่มต้น |
|---|---|---|---|
| `consentStatus` | `consent_status` | String `'ALLOWED'` / `'DENIED'` / `'UNANSWERED'` | `'UNANSWERED'` |
| `masterSwitch` | `notification_master_switch` | String `'ON'` / `'OFF'` | `'OFF'` |
| `systemPermissionStatus` | `system_permission_status` | String `'GRANTED'` / `'DENIED'` / `'NOT_DETERMINED'` | `'NOT_DETERMINED'` |
| `sentNotificationCount` | `sent_notification_count` | int 0–6 (derive จาก plan) | 0 |
| `lastNotificationTimestamp` | `last_notification_timestamp` | String ISO-8601 / ไม่มีคีย์ = null | null |
| `walkNearGoalSentToday` | `walk_near_goal_sent_today` | bool | false |
| `lastStepsIncreasedTimestamp` | `last_steps_increased_timestamp` | String ISO-8601 / null | null |
| `dayPlan` | `notification_day_plan` | String JSON `{day, items[{id, message, anchor, dueAt, scheduledAt}], suppressedTopics[]}` | ไม่มี |

- `notification_day_plan` = **key ใหม่** (ไม่มีใน game-rules) เหตุผล: ตั้งเวลาล่วงหน้า (D-5) ต้องรู้ว่าตั้งอะไรไว้แล้ว/อะไรส่งแล้ว เพื่อ cancel เฉพาะที่ค้าง นับเพดาน 6 และ "ครั้งเดียวต่อรอบนับ" ได้หลังปิดเปิดแอป และเก็บ topic ที่ถูกระงับตาม D-4 — เก็บเฉพาะข้อมูลของ notification (D-9) — Q-21
- ไม่มี key `last_manual_move_timestamp` (D-3)
- อ่าน/เขียนไม่สำเร็จ: ดู §3 S-1 ERROR · S-2 เขียนไม่สำเร็จ = คงค่าในหน่วยความจำ ไม่มี UI ผิดพลาด (แบบ `StepsController._trySave` — Q-24)

## 3. สถานะของแต่ละหน้าจอ

### S-1

| สถานะ (ux-flow §4) | เงื่อนไข | หน้าตา |
|---|---|---|
| NORMAL | Home + `consent_status == UNANSWERED` (AC-1) | Home ปกติด้านหลัง + ฉากหลังทึบ (default barrier) + การ์ด §2.1 ตรงกลาง: กบขยิบตา 120, 「น้องอ๊บอยากส่งเสียงหา!」, รายละเอียด, ปุ่ม 「อนุญาต」 (Filled) เหนือ 「ไม่อนุญาต」 (Outlined) · แตะฉากหลัง / AppBar / ปุ่ม back → การ์ดยังอยู่ ไม่มีการนำทาง |
| EMPTY | `ALLOWED` / `DENIED` แล้ว (AC-4) | ไม่มี `notification_consent_card` ใน tree · Home ปกติ |
| ERROR | อ่าน `consent_status` ไม่ได้ → ไม่แสดงการ์ด · บันทึกไม่ได้หลังกดปุ่ม → การ์ดปิดตามปกติ | ไม่มี dialog / SnackBar ผิดพลาด · ค่าในหน่วยความจำ = `DENIED` / `OFF` ชั่วคราว (ไม่ขอสิทธิ์ ไม่ตั้งเวลา) · ผู้ใช้เปิดเองได้ใน S-2 |
| กำลังโหลด | `NotificationController` ยัง `!isLoaded` | ไม่มีการ์ด (Home แสดงตามสถานะของ water เอง) — การ์ดขึ้นในเฟรมหลังโหลดเสร็จ |

ไม่มีสถานะ disabled

### S-2

| สถานะ (ux-flow §4) | เงื่อนไข | หน้าตา |
|---|---|---|
| กำลังโหลด | `!controller.isLoaded` | `Center(CircularProgressIndicator())` แทน body |
| NORMAL (เปิดใช้งาน) | master ON + GRANTED (AC-5) | สวิตช์ ON (`value: true`) · ไม่มี `notification_permission_denied_banner` |
| EMPTY (ปิดโดยผู้ใช้) | master OFF + permission ไม่ใช่ DENIED (AC-3, AC-5, AC-7) | สวิตช์ OFF · ไม่มีกล่องข้อความ · scheduler ไม่มีรายการ pending |
| PERMISSION_DENIED | `system_permission_status == DENIED` (AC-8, EC-10) | สวิตช์ OFF (แม้ master ที่เก็บไว้เป็น ON — Q-23) · ใต้สวิตช์ 8 dp มีกล่อง `errorContainer` 「สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน」 · ไม่มีรายการ pending |
| รอผลกล่องขอสิทธิ์ | กด ON ขณะ `NOT_DETERMINED` / `DENIED` (AC-6, EC-9) | สวิตช์แสดง ON ทันที · กล่องของ OS ทับหน้าจอ · ผล GRANTED → คง ON (NORMAL) · DENIED → OFF + กล่องข้อความ (PERMISSION_DENIED) |
| กลับจาก background | `onAppResumed` อ่านสิทธิ์ใหม่ | วาดใหม่ทันทีเป็นสถานะตามแถวด้านบน (เช่นไปเปิดสิทธิ์ในเครื่องแล้วกลับมา → กล่องข้อความหาย, สวิตช์กลับเป็นค่า master ที่เก็บไว้) |

ไม่มีสถานะ disabled (สวิตช์กดได้ทุกสถานะ — Q-05)

### S-3

| สถานะ (ux-flow §4) | เงื่อนไข | หน้าตา |
|---|---|---|
| NORMAL | รายการใน plan ถึงเวลา (§2.4.4) | Android: แชต 「น้องอ๊บ」 + avatar กบขยิบตาวงกลม + ข้อความ · iOS: ไอคอนแอป + ข้อความ (ไม่มี title, ไม่มีรูป) |
| EMPTY | ช่วงห้ามเตือน / ครบ 6 / สวิตช์ปิด / ไม่ได้รับสิทธิ์ / ไม่เปิดแอปข้ามรอบวัน (AC-7, AC-26, AC-28, EC-14, EC-15) | ไม่มีแจ้งเตือน — ไม่มีรายการใน scheduler |
| ERROR | EC-3 (D-4) | ไม่มีข้อความของ topic นั้นทั้งวัน · ไม่มีข้อความผิดพลาดในแอป |

## 4. ภาพสัตว์เลี้ยงแต่ละสถานะ

ใช้ `PetCharacter` / `PetCharacterPainter` จาก `app/lib/shared/pet/` (`import 'package:petpal_health/shared/pet/pet.dart'`) เท่านั้น — ชื่อ preset ตรวจแล้วกับ `pet_pose.dart` บรรทัด 174 (`PetPose.notificationProfile`) และ character.md §4–§7 · game-rules §2: แจ้งเตือนไม่เปลี่ยนอารมณ์ → ภาพเดียวคงที่

| สถานะ (game-rules §2) | Preset | สีหน้า / รูปร่าง | ท่าทางที่เห็น (character.md §4) | ใช้ที่ | ขนาด | ขยับ | key | preview |
|---|---|---|---|---|---|---|---|---|
| `NOTIFICATION_PROFILE` (ภาพโปรไฟล์แจ้งเตือนคงที่) | `PetPose.notificationProfile` (id `normal_wink`) | `wink` / `normal` | ตาซ้ายเปิดโตมองตรง · ตาขวาขยิบเป็น `^` เส้นหนา · ปากจู๋ชมพู (`PetColors.lips`) สองก้อนแบบเลข "3" · หัวใจจุ๊บ (`PetColors.heart`) ขวาบน · แก้มชมพู · แขนวางพุง ใบไม้ตั้ง | S-1 | 120 × 120 | `animate: widget.animatePet ?? kPetAnimateByDefault` — หายใจ (หัวใจพอง +8%) + กะพริบเฉพาะตาซ้าย · **`reactToTap: false`** (ux-flow "ไม่มีผลเมื่อกด") · ไม่ส่ง `cheerTrigger` | `notification_consent_pet_image` บน `KeyedSubtree` | `docs/_design/preview/notification_profile.png` |
| เดียวกัน | `PetCharacterPainter(pose: PetPose.notificationProfile)` (breath 0, ภาพนิ่ง) | `wink` / `normal` | เท่ากับด้านบน ครอปวงกลมแนบกรอบ ไม่ซูม (หัวใจอยู่ในวงกลม) พื้นโปร่งใส | S-3 Android Person icon | 192 × 192 px | ไม่ขยับ (บิตแมป) | — | `notification_profile_96_circle.png`, `notification_profile_sizes.png` |

กติกาการใช้ widget:
- ห่อ key ฟีเจอร์ไว้ที่ `KeyedSubtree` ไม่ใส่บน `PetCharacter` (character.md §7, BUG-PET-1) · pose ไม่เปลี่ยนจึงไม่ต้องใช้ GlobalKey
- หน้า Home มีสัตว์เลี้ยงของ water อยู่ด้วย → เทสต์หา painter ของการ์ดด้วย `find.descendant(of: find.byKey(ValueKey('notification_consent_pet_image')), matching: find.byKey(PetKeys.painter))`
- ตรวจด้วย `animate: false`: `painter.pose == PetPose.notificationProfile`, `face == PetFace.wink`, `isWinking`, `showsKissHeart` true, `isDerpyEye` false (character.md §7) · แตะรูปแล้ว `face` ยังเป็น `wink`
- เทสต์ที่ `animate: true` ใช้ `pump(Duration)` ห้าม `pumpAndSettle()`
- ไม่ต้องการท่าใหม่จาก Art (Art ส่งแล้วรอบ 5)

## 5. Android / iOS setup ที่ต้องเพิ่ม

**`app/pubspec.yaml` — dependencies:** `flutter_local_notifications`, `timezone`, `flutter_timezone` (เวอร์ชันล่าสุดที่รองรับ SDK `^3.13.5` — Dev เลือก · D-5) · ไม่เพิ่ม `workmanager` / asset

**`main()`** (เฉพาะ Android/iOS ผ่าน `LocalNotificationScheduler`): `tz.initializeTimeZones()` → `FlutterTimezone.getLocalTimezone()` → `tz.setLocalLocation(tz.getLocation(name))` (หาไม่ได้ → fallback Q-19) → `plugin.initialize(InitializationSettings(android: AndroidInitializationSettings(NotificationRules.androidSmallIcon), iOS: DarwinInitializationSettings(requestAlertPermission: false, requestBadgePermission: false, requestSoundPermission: false)), onDidReceiveNotificationResponse: …)` — **ไม่ขอสิทธิ์ตอน initialize** (AC-3: ไม่อนุญาต = ไม่มีกล่อง) · Android สร้าง channel `petpal_reminders` ผ่าน `resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(...)`

สิทธิ์: Android `requestNotificationsPermission()` / `areNotificationsEnabled()` · iOS `requestPermissions(alert: true, sound: true, badge: false)` / `checkPermissions()` · Android < 13 ไม่มีกล่อง → `areNotificationsEnabled() == true` ถือเป็น GRANTED (Q-15)

**`app/android/app/src/main/AndroidManifest.xml`** (ตามเอกสาร plugin สำหรับ scheduled notification):
```xml
<!-- ใต้ <manifest> -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<!-- ใน <application> -->
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
    </intent-filter>
</receiver>
```
- **ห้าม** `SCHEDULE_EXACT_ALARM`, `USE_EXACT_ALARM`, `USE_FULL_SCREEN_INTENT` (D-6) · คง `android:launchMode="singleTop"` เดิม (deep link ตอน BACKGROUND ไม่สร้าง Activity ใหม่)

**`app/android/app/build.gradle.kts`** (plugin ต้องใช้ desugaring):
```kotlin
android { compileOptions { isCoreLibraryDesugaringEnabled = true /* + ค่าเดิม */ } }
dependencies { coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4") }
```

**iOS:** repo ยังไม่มีโฟลเดอร์ `app/ios/` (Q-12) — เมื่อสร้าง: `AppDelegate.swift` เพิ่ม `FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in GeneratedPluginRegistrant.register(with: registry) }` และ `UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate` · ไม่ต้องเพิ่ม key ใน `Info.plist` สำหรับ local notification · ไม่มี Notification Service Extension / attachment (AC-37)

## 6. Checklist สำหรับ reviewer

- [ ] ไม่มี hex สีในโค้ด notification — สีมาจาก `colorScheme` / default widget; Android `color` = `Colors.lightBlue` (seed ของ `main.dart`)
- [ ] ไม่แก้ `ThemeData`, ไม่เพิ่ม font/asset; `pubspec.yaml` เพิ่มเฉพาะ `flutter_local_notifications`, `timezone`, `flutter_timezone`; ไม่มี `workmanager`
- [ ] ไม่มี `pet_profile_frog.png` / `Image.asset` / `AssetImage` / `DrawableResourceAndroidBitmap` ภาพกบในโค้ด; ไม่แก้ไฟล์ใน `app/lib/shared/pet/`
- [ ] ข้อความทุกข้อความ (S-1, S-2, 6 ข้อความ S-3, ชื่อผู้ส่ง, channel) และตัวเลขทั้งหมดใน §2.4.2 อยู่ใน `NotificationRules`; `waterDailyGoalGlasses` อ้าง `DashboardRules.waterTargetCups`; `dailyResetHour` อ้าง `WaterRules.dailyResetHour`; มีคอมเมนต์ `DECIDED (owner 2026-11-08, D-x)` / `ASSUMPTION: ui-spec Q-xx`
- [ ] ข้อความตรงตัวทุกอักษร: 「น้องอ๊บอยากส่งเสียงหา!」, 「อนุญาตให้น้องอ๊บแจ้งเตือนเรื่องการเดิน การดื่มน้ำ และการกินอาหารนะค้าบ」, 「อนุญาต」, 「ไม่อนุญาต」, 「การแจ้งเตือนของน้องอ๊บ」, 「สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน」, 「น้องอ๊บ」 และ 6 ข้อความใน §2.3.1
- [ ] ไม่มีข้อความ 「อย่าลืมขยับร่างกายน้า ถ้าขยับแล้วมาอัปเดตให้น้องอ๊บด้วย」 และไม่มี key `last_manual_move_timestamp` (D-3); `isTrackingLocked == true` → ไม่มีข้อความเรื่องเดินใน plan
- [ ] AppBar ของ `WaterHomeScreen` ยังเป็น 5 ปุ่มเดิม (ไม่มีปุ่มใหม่)
- [ ] `DashboardScreen` มี `notification_settings_entry_button` (`IconButton`, `Icons.settings` 24, tooltip 「การแจ้งเตือนของน้องอ๊บ」) เฉพาะเมื่อได้รับ `notificationController`; กดแล้วเปิด `NotificationSettingsScreen`; null → ไม่มีปุ่ม
- [ ] S-1 เปิดด้วย `showDialog(barrierDismissible: false)` + `PopScope(canPop: false)` จาก `WaterHomeScreen` เฉพาะ `consent_status == UNANSWERED`; มี flag กันเปิดซ้อน; ไม่มีการแก้ `SignupGate` / signup
- [ ] S-1 keys: `notification_consent_card` (`Dialog`), `notification_consent_pet_image`, `notification_consent_title_text`, `notification_consent_body_text`, `notification_consent_allow_button` (`FilledButton`), `notification_consent_deny_button` (`OutlinedButton`); ลำดับบนลงล่างและระยะ 16/8/24/8 ตาม §2.1; padding 24; ปุ่มเต็มความกว้างซ้อนแนวตั้ง
- [ ] S-1 สัตว์เลี้ยง = `PetCharacter(pose: PetPose.notificationProfile, size: 120, reactToTap: false)` ใน `KeyedSubtree`; `animate: widget.animatePet ?? kPetAnimateByDefault`; ไม่มี `cheerTrigger`
- [ ] แตะฉากหลัง/ตำแหน่งปุ่ม AppBar ขณะ S-1 แสดง → การ์ดยังอยู่และไม่มีการนำทาง; ปุ่ม back ไม่ปิดการ์ด
- [ ] กด 「อนุญาต」 → การ์ดหาย, `consent_status = 'ALLOWED'`, `notification_master_switch = 'ON'`, `requestPermission()` ถูกเรียก 1 ครั้งหลังการ์ดปิด; GRANTED → มีรายการใน fake scheduler
- [ ] กด 「ไม่อนุญาต」 → การ์ดหาย, `'DENIED'` / `'OFF'`, `requestPermission()` ไม่ถูกเรียก, ไม่มีรายการใน scheduler
- [ ] เปิด Home ครั้งที่ 2 (สร้าง widget ใหม่ด้วย repository เดิม) → ไม่มี `notification_consent_card`
- [ ] repository อ่าน `consent_status` ไม่ได้ → ไม่มีการ์ด ไม่มี dialog ผิดพลาด ไม่ขอสิทธิ์ ไม่ตั้งเวลา
- [ ] S-2: AppBar title key `notification_settings_header_text`; `ListView(padding: 16)`; `SwitchListTile` key `notification_master_switch` (`contentPadding: zero`) ป้าย key `notification_master_switch_label`
- [ ] S-2 PERMISSION_DENIED: สวิตช์ `value == false` และมี `notification_permission_denied_banner` (`errorContainer`, padding 16/8, มุม 8) ห่างสวิตช์ 8 + `notification_permission_denied_text` (`bodyMedium` `onErrorContainer`); สถานะอื่นไม่มี banner ใน tree
- [ ] S-2 ปิดสวิตช์ → ทุกรายการ pending ถูก `cancel(id)`; รายการ committed ไม่ถูก cancel; ไม่มีการเรียก `cancelAll`
- [ ] S-2 เปิดสวิตช์ขณะ `NOT_DETERMINED` (เช่นหลังกดไม่อนุญาตบน S-1) → `requestPermission()` ถูกเรียก (AC-6, EC-9)
- [ ] กดสวิตช์ ON/OFF/ON/OFF ติดกัน → สวิตช์แสดง OFF; fake scheduler ไม่มีรายการ pending; storage `'OFF'` (EC-1)
- [ ] จำลอง `checkPermission()` เปลี่ยนเป็น DENIED แล้วส่ง `AppLifecycleState.resumed` → S-2 ที่เปิดอยู่แสดง banner ทันทีและรายการ pending ถูกยกเลิก; เปลี่ยนกลับ GRANTED + resumed → banner หาย สวิตช์ ON มีรายการใหม่
- [ ] `NotificationLogic` ไม่ import Flutter widgets / plugin / shared_preferences และรับ `now` เป็นพารามิเตอร์; เทสต์ T-1 ถึง T-18 (§2.4.4) ผ่านด้วยค่าที่คาดหวังตรงทุกเวลา
- [ ] ไม่มีรายการที่ `scheduledAt` ≥ 23:00:00 หรือ < 06:00:00; รายการติดกันห่าง ≥ 30:00 นาที; committed + pending ≤ 6 ต่อรอบวัน
- [ ] `zonedSchedule` ใช้ `AndroidScheduleMode.inexactAllowWhileIdle`; ไม่มี exact alarm ใน manifest
- [ ] Android details: channel `petpal_reminders`, `MessagingStyleInformation` ที่ `Person(name: 'น้องอ๊บ', icon: ByteArrayAndroidIcon(...))`, title 「น้องอ๊บ」 body = ข้อความ; avatar เรนเดอร์จาก `PetCharacterPainter(pose: PetPose.notificationProfile)` 192 px ครอปวงกลม พื้นโปร่งใส และเรนเดอร์ครั้งเดียว (แคช)
- [ ] iOS details: title `null`, ไม่มี attachment, `presentBanner: true`
- [ ] payload = `'<topic>|<message>'`; payload อ่านไม่ได้ → ไม่นำทาง ไม่ล้ม
- [ ] กดแจ้งเตือน walk / water / food (จำลองผ่าน `handleNotificationTap`) จากหน้าใดก็ได้ (S-2, dashboard, steps) → stack = `[Home, StepsDashboardScreen]` / `[Home]` / `[Home, FoodDashboardScreen]`; กดซ้ำ 3 ครั้ง → stack เท่าเดิม (EC-2); steps/food ได้ controller ตัวเดียวกับ `_openSteps` / `_openFood`
- [ ] TERMINATED: `main()` เรียก `launchPayload()` ก่อน `runApp` และ Home นำทางหลังโหลดเสร็จ (EC-13)
- [ ] manifest มี `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, 2 receiver ของ plugin; `build.gradle.kts` เปิด desugaring; `launchMode="singleTop"` คงเดิม
- [ ] `PetPalApp` / `WaterHomeScreen` / `DashboardScreen` ที่ไม่ได้รับ `notificationController` ทำงานเหมือนเดิม (เทสต์เดิมทั้งหมดผ่านโดยไม่แก้)
- [ ] ไม่มี RenderFlex overflow ที่ 360×640 dp textScaler 1.0 และ 1.5: Home + S-1, S-2 ทุกสถานะ (รวม banner), AppBar dashboard ที่มีปุ่มตั้งค่า
- [ ] Timer ตรวจรอบวันและ listener ของ 3 controller ถูกยกเลิกใน `NotificationController.dispose()`; ไม่มีการเรียก network

## 7. คำถามที่ค้าง

ที่มา: **A** = requirements (Product) · **B** = ux-flow / game-rules (Design) · **O** = ข้อตัดสิน owner · **UI** = ช่องว่างที่ spec ต้องเลือก · ค่าชั่วคราวทุกข้อให้ Dev ใส่ `// ASSUMPTION: ui-spec Q-xx`

| # | ที่มา | ประเด็น | ทางที่ spec เลือกไว้ชั่วคราว |
|---|---|---|---|
| Q-01 | B / design-review | ชื่อไฟล์ภาพโปรไฟล์กบ | **ปิด (D-1)** — `PetPose.notificationProfile` ไม่มี PNG |
| Q-02 | B / design-review | ข้อความ PERMISSION_DENIED | **ปิด** — Exact String ของ ux-flow |
| Q-03 | B (ux-flow §2 S-2) | สวิตช์ไม่มีป้ายข้อความ | ป้าย 「เปิด/ปิดแจ้งเตือนทั้งหมด」 (ชื่อองค์ประกอบใน ux-flow) **(เสนอ)** |
| Q-04 | O (D-2) | tooltip ของปุ่มตั้งค่าบน dashboard | ใช้หัวข้อ S-2 「การแจ้งเตือนของน้องอ๊บ」 |
| Q-05 | B (ux-flow §2 S-2) | DENIED แล้วผู้ใช้กดสวิตช์เป็น ON — ux-flow กำหนดเฉพาะ NOT_DETERMINED · ไม่มีปุ่มไปการตั้งค่าเครื่อง | สวิตช์กดได้ → `requestPermission()` อีกครั้ง (OS ตัดสินว่าจะมีกล่องไหม) ยังปฏิเสธ = กลับ OFF + banner · ไม่เพิ่มปุ่ม "ไปที่การตั้งค่า" (ถ้าต้องการ ให้เพิ่มใน ux-flow ก่อน — steps มี 「ไปที่ Settings」 ให้ reuse ได้) |
| Q-06 | B (game-rules §1.1, EC-14) | เปิดแอปครั้งแรกของวันหลังเวลาครบกำหนดแล้ว (เช่น 14:00) — ข้อความที่ "เลยเวลา" ไม่ได้ถูกเลื่อนเพราะระยะห่าง/ลำดับ ส่งหรือไม่ | ถือว่าเข้าเงื่อนไขอยู่ → ส่งได้ตั้งแต่ตอนเปิด แต่เก็บเฉพาะ**ขั้นล่าสุดที่เลยเวลาของแต่ละสาย** (น้ำ 2→4 ชม., อาหาร 12→15→18) กันข้อความกองท่วม (T-18) |
| Q-07 | O (D-6) + B (`WALK_MAX_DELAY_MINUTES`) | "ช้าได้ไม่เกิน 60 นาที" ของเรื่องเดิน กับการถูกเลื่อนตามคิว/inexact | ไม่ตัดทิ้งเพราะช้า — ค่า 60 อยู่ใน rules เป็นเอกสาร · เทสต์ตรวจเวลาที่ตั้ง |
| Q-08 | B (game-rules §1.1 เดิน: ใกล้เป้า) | "ส่งเมื่อ" ใกล้เป้าคือเวลาใด เมื่อตั้งเวลาล่วงหน้า | `dueAt` = เวลาที่วางแผน (ตอนตรวจพบ 80–<100%) แล้วเข้าคิวตามกติกา · ถึง ≥ 100% ก่อนส่ง → วางแผนใหม่แล้วหายไป |
| Q-09 | UI | channel id / ชื่อ / คำอธิบาย / importance ไม่มีในเอกสาร | `petpal_reminders` · 「แจ้งเตือนจากน้องอ๊บ」 · 「เตือนเรื่องการเดิน การดื่มน้ำ และการกินอาหาร」 **(เสนอ)** · `Importance.defaultImportance` (มีเสียง ไม่เด้ง heads-up — รบกวนน้อยตาม US-5) |
| Q-10 | UI → Art | ไอคอนเล็กบนแถบสถานะ Android ควรเป็นภาพขาวดำ (monochrome) — แอปมีแค่ `@mipmap/ic_launcher` | ใช้ `@mipmap/ic_launcher` ชั่วคราว (บางเครื่องเห็นเป็นสี่เหลี่ยมขาว) · **งานของ Art:** ไอคอน monochrome `res/drawable` ภายหลัง |
| Q-11 | Art (log ข้อ 2) | Person icon บนธีมมืด — เติมวงกลมพื้นสีอ่อนไหม | คงพื้นโปร่งใสตาม ux-flow §5 |
| Q-12 | UI | repo ไม่มีโฟลเดอร์ `app/ios/` — ตั้งค่า/ทดสอบ iOS ไม่ได้รอบนี้ | เขียนกิ่ง iOS ใน Dart (`DarwinNotificationDetails`, title null) + จด setup ใน §5 · AC-37 ตรวจจากโค้ดเท่านั้น |
| Q-13 | B | ux-flow §2/§4/§5 และ game-rules §2/§5 ยังอ้าง `pet_profile_frog.png` และมีแถว "เดิน: บันทึกเอง" | ข้อตัดสิน D-1 / D-3 ชนะ — ขอ Design อัปเดตเอกสารให้ตรง (UI ไม่แก้) |
| Q-14 | O (D-3) | AC-15 / EC-12 และ `WALK_MANUAL_INACTIVITY_HOURS` ยังอยู่ใน requirements/game-rules | ไม่ทำ ไม่มีค่าคงที่/ข้อความ/คีย์ในโค้ด · ขอ Product ย้ายเข้า Out of scope |
| Q-15 | A (AC-2) | Android < 13 ไม่มีกล่องขอสิทธิ์ — AC-2 "กล่องขอสิทธิ์ปรากฏ" ทดสอบไม่ได้บนเครื่องรุ่นเก่า | `areNotificationsEnabled() == true` → GRANTED ทันที ไม่มีกล่อง |
| Q-16 | B (ux-flow §3.1) | กดแจ้งเตือนตอนยังไม่อยู่ Home (เช่นออกจากระบบอยู่) | deep link ค้างในหน่วยความจำ ใช้เมื่อ `WaterHomeScreen` โหลดเสร็จครั้งถัดไป (ไม่บันทึกลงเครื่อง) |
| Q-17 | B (EC-2) | กันหน้าซ้อนด้วย `popUntil(isFirst)` ทำให้หน้าที่เปิดค้างอยู่ (เช่น S-2, dashboard, หน้าแก้เป้าก้าว) ถูกปิด | ยอมรับ — stack หลังกดคาดเดาได้เสมอ ทดสอบง่าย |
| Q-18 | A (AC-1) | ผู้ใช้เดิมที่ผ่าน Onboarding ก่อนอัปเดตแอป จะเห็นการ์ดเมื่อเข้า Home ครั้งแรกหลังอัปเดต (consent ยัง UNANSWERED) | ยอมรับ — แสดงครั้งเดียวเหมือนผู้ใช้ใหม่ |
| Q-19 | UI | `FlutterTimezone.getLocalTimezone()` ไม่สำเร็จ / ชื่อเขตเวลาไม่อยู่ในฐานข้อมูล `timezone` | fallback = location แบบ offset คงที่จาก `DateTime.now().timeZoneOffset` (เช่น `Etc/GMT-7`) ถ้าไม่ได้อีกใช้ `tz.UTC` · ไม่รองรับข้ามเขตเวลา (requirements §5) |
| Q-20 | O (D-4) | EC-3 "ไม่ส่งเรื่องนั้นในรอบวันนั้น" ถ้าค่ากลับมาถูกภายหลังในวันเดียวกัน | ระงับทั้งรอบวัน (เก็บใน `suppressedTopics` ของ plan) |
| Q-21 | UI | ต้องเก็บแผนที่ตั้งไว้ (ไม่มีใน game-rules §1.2) | key ใหม่ `notification_day_plan` (เหตุผล §2.5) · คีย์ของ game-rules ยังเขียนครบ (derive จาก plan) |
| Q-22 | B (ux-flow §2 S-1 "บล็อกการกดทะลุ") | ปุ่ม back ของระบบขณะการ์ดแสดง (Home เป็น root — back = ออกแอป) | `PopScope(canPop: false)` — ต้องเลือกปุ่มใดปุ่มหนึ่ง |
| Q-23 | A (AC-8) | master เก็บ ON แต่ระบบ DENIED → แสดง OFF · ผู้ใช้ไปเปิดสิทธิ์ในเครื่องแล้วกลับมา | สวิตช์กลับเป็น ON เองตาม master ที่เก็บไว้ (`isSwitchOn = master ON && GRANTED`) และตั้งเวลาใหม่ |
| Q-24 | B (ux-flow §4 S-2) | บันทึกค่าสวิตช์ลงเครื่องไม่สำเร็จ | คงค่าในหน่วยความจำ ไม่มี UI ผิดพลาด (แบบ `StepsController._trySave`) |
| Q-25 | UI | id แจ้งเตือนต้องไม่ชน (cancel id ที่แสดงแล้วจะลบออกจากถาด) | hash ของ `วัน|message|anchor` & `0x7fffffff` · ไม่ cancel รายการ committed |
| Q-26 | B (ux-flow §3 ข้อ 4) | แอปเปิดอยู่ขณะถึงเวลา — แสดงแจ้งเตือน OS หรือแจ้งในแอป | แสดงแจ้งเตือน OS ตามปกติ (iOS `presentBanner: true`) ไม่มี UI ในแอป |
| Q-27 | UI | `android:label="petpal_health"` ใน manifest จะแสดงเป็นชื่อแอปบนหัวแจ้งเตือน Android และหน้าตั้งค่า channel | ไม่แก้ในฟีเจอร์นี้ (นอกขอบเขต) — เสนอ owner เปลี่ยนเป็น 「PetPal Health」 แยกงาน |
| Q-28 | A | ออกจากระบบ (signup) แล้วควรยกเลิกแจ้งเตือนที่ตั้งไว้หรือไม่ — เอกสารไม่กล่าวถึง | ไม่เปลี่ยน signup (ux-flow "ไม่แก้เส้นทาง signup") — แจ้งเตือนยังคงตามแผน · รอ Product |
