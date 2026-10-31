# UI spec: บันทึกการให้อาหารสัตว์เลี้ยงและโภชนาการ (food)

> สถานะ: draft (แก้ 2026-10-31 ตามข้อตัดสิน owner D-3–D-5) · ผู้เขียน: UI agent · อ้างอิง: ux-flow.md, game-rules.md (บริบท: requirements.md, brief.md, design-review.md)
> เอกสารนี้กำหนด "หน้าตา" เท่านั้น — ตัวเลข กติกา และ flow ให้ยึด ux-flow.md / game-rules.md
> design language ยึดตาม `docs/steps/ui-spec.md`, `docs/signup/ui-spec.md` และโค้ดจริงใน `app/lib/` — ไม่สร้างระบบดีไซน์ใหม่

## 0. ข้อตัดสินใจที่มีผลต่อ UI

ข้อเหล่านี้เป็นการตัดสินใจของเจ้าของโปรเจกต์ ไม่ใช่ของ UI agent — spec นี้แค่กำหนดหน้าตาให้รองรับ

| # | ข้อตัดสินใจ (ที่มา) | ผลต่อ UI |
|---|---|---|
| D-1 | **OQ-1 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน), 2026-10-30:** ไม่ใช้ Lottie และไม่ใช้ Sprite Sheets — 4 ท่าของ food วาดใน `PetCharacter` (CustomPainter) ใน `app/lib/shared/pet/` ตามข้อตกลง owner 2026-10-14 ที่ให้ทั้งแอปใช้สัตว์เลี้ยงตัวเดียว (`docs/_design/character.md` §9 ข้อ 2 และ 5) ใช้แทน requirements.md ข้อ 7 และ asset/fallback ใน ux-flow.md §2, §5, §6 / game-rules.md §2, §5 | Pet Display Area ของ S-1 = `PetCharacter` + preset `PetPose.food*` (§4) — **ห้ามโหลด** `assets/images/pet/*.json` หรือ PNG/Sprite Sheet ใด ๆ เป็นภาพสัตว์เลี้ยง ไม่เพิ่ม package `lottie` |
| D-2 | หน้า home ปัจจุบันของแอปคือ `WaterHomeScreen` (`app/lib/main.dart` → `_home`) และ steps เข้าทางปุ่มใน AppBar ของ water (steps ui-spec D-3, `steps_entry_button`) | ux-flow ไม่มีทางเข้า S-1 — spec ใช้ pattern เดียวกับ steps (ปุ่มไอคอนใน AppBar ของ water) ไม่เพิ่มหน้าจอ ดู §2.0, Q-1 |
| D-3 | **Q-14 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน), 2026-10-31:** ช่องอายุของ S-3 ใช้กติกาเดียวกับ signup S-6 — รับเฉพาะจำนวนเต็ม ช่องอายุปฏิเสธการพิมพ์/วางจุด (และอักขระที่ไม่ใช่ตัวเลข) ตั้งแต่แรก แบบ `SignupWholeNumberInputFormatter` (`app/lib/features/signup/widgets/signup_widgets.dart`) · น้ำหนัก/ส่วนสูงรับทศนิยมได้ | "20.5" พิมพ์ในช่องอายุไม่ได้ (ค่าเดิมในช่องคงอยู่ ไม่ขึ้น error) · สถานะ error อายุ (`food_age_error_text`) ใช้กับค่าจำนวนเต็มนอกช่วง `[AGE_MIN, AGE_MAX]` เช่น `0`, `121` — ดู §2.3, §3 S-3 |
| D-4 | **Q-5 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน), 2026-10-31:** ป้าย 「อิ่มแล้ว」 ขึ้นพร้อมหลอดแดงทันทีเมื่อเกินเกณฑ์ ไม่ต้องรอท่าสัตว์เลี้ยง | ป้าย `food_full_badge` ผูกกับข้อมูลจริงเงื่อนไขเดียวกับสีหลอด `error` (ไม่ผูกกับท่า) — ขึ้น/หายในเฟรมเดียวกับที่หลอดเปลี่ยนสี รวมถึงระหว่างท่า `foodEating` ของการบันทึกที่ข้ามเกณฑ์ · เลิกข้อความ "ป้ายซ่อนระหว่างกิน" — ดู §2.1, §3 S-1 |
| D-5 | **Energy slot — DECIDED (owner ชั่วคราว, รอทีมยืนยัน), 2026-10-31:** การ overflow ของช่องพลังงานที่สูงคงที่ 88 px เป็นบั๊ก — ห้ามล็อกความสูง 88 px ต้องรองรับตัวเลขยาวและ textScaler 1.5 บนจอ 360 dp | Energy slot = ความสูงขั้นต่ำร่วมกันระหว่างหลอดกับ CTA และโตตามเนื้อหาได้ โดยยังไม่เกิด layout shift ตอนสลับ (AC-8) — ดู §1.3, §2.1 #9, §3 S-1 |

## 1. Design tokens

ทุกสีของ component ให้ดึงจาก `Theme.of(context).colorScheme` / `textTheme` เท่านั้น ห้าม hardcode hex ในหน้าจอ food (food ไม่วาดสัตว์เลี้ยงเอง สีตัวสัตว์เลี้ยงอยู่ใน `PetColors` ของ `app/lib/shared/pet/pet_constants.dart` — ห้ามแก้)

### 1.1 สี

| Token | ค่า | ใช้ที่ไหน | ที่มา |
|---|---|---|---|
| Seed color | `Colors.lightBlue` | ทุก ColorScheme | `app/lib/main.dart` → `ColorScheme.fromSeed(seedColor: Colors.lightBlue)` |
| ปุ่มหลัก | `colorScheme.primary` (default ของ `FilledButton`) | S-1 「บันทึกมื้ออาหาร」, S-2 「บันทึกข้อมูล」, S-3 「บันทึกและคำนวณเป้าหมาย」 | ของเดิม: `water_log_button`, `steps_add_button`, `signup_onboarding_save_button` |
| ปุ่มข้อความ | default ของ `TextButton` (ตัวอักษร `primary`) | S-3 「ข้ามไปก่อน」 | ของเดิม: `signup_have_account_link`, `steps_set_goal_button` |
| หลอดพลังงาน — ปกติ | `colorScheme.primary` (default ของ `LinearProgressIndicator`) track default | S-1 สถานะ ปกติ / ว่าง / กำลังกิน (และช่วงเกินเป้า ≤ 100 kcal ตาม AC-9) | ของเดิม: `water_energy_bar`, `steps_energy_bar` |
| หลอดพลังงาน — เกินเป้าหมาย ("สีแดง") | `colorScheme.error` ส่งเข้า `LinearProgressIndicator.color` (track คง default) | S-1 สถานะเกินเป้าหมาย (AC-10) | role เดิมใน ColorScheme — **การใช้ role ใหม่** เหตุผล: game-rules/ux-flow สั่ง "สีแดง" และ `error` ของ M3 เป็นโทนแดงที่ได้จาก seed เดิม ไม่ต้องตั้ง hex |
| ป้าย 「อิ่มแล้ว」 | พื้น `colorScheme.errorContainer`, ตัวอักษร `colorScheme.onErrorContainer` | S-1 สถานะเกินเป้าหมาย (ขึ้นพร้อมหลอดสี `error` — D-4) | role เดิม — **การใช้ role ใหม่** เหตุผล: ป้ายต้องเข้าชุดกับหลอดสีแดงในสถานะเดียวกัน; รูปทรงเดียวกับป้าย `steps_status_badge` |
| CTA Banner (ข้ามโปรไฟล์) | พื้น `colorScheme.secondaryContainer`, ตัวอักษร/ไอคอน `colorScheme.onSecondaryContainer` | S-1 สถานะข้ามโปรไฟล์ | ของเดิม: สีป้าย `steps_status_badge` |
| Toast ลอยเหนือสัตว์เลี้ยง | พื้น `colorScheme.inverseSurface`, ตัวอักษร `colorScheme.onInverseSurface` | S-1 Toast 「พอเถอะน้าคนดี」 | สีเดียวกับ default ของ `SnackBar` M3 (ที่ `water_anti_spam_toast` / `showStepsToast` ใช้) — ให้ Toast ทั้งแอปโทนเดียวกันแม้ตำแหน่งต่าง (ดู §1.3) |
| Disabled "สีเทาจาง" | สี disabled มาตรฐาน M3 ได้เองเมื่อ `onPressed: null` / `enabled: false` | S-2 ระหว่างโหลด, S-3 ปุ่มบันทึก | steps ui-spec §1.1 — ห้ามตั้งสีเทาเอง |
| ข้อความ Error ใต้ฟิลด์ | `colorScheme.error` (default ของ `InputDecoration.error`) | S-3 error อายุ | ของเดิม: `signup_age_error_text` |
| ข้อความแจ้ง (Inline Warning ไม่บล็อก) | `textTheme.bodySmall` + `colorScheme.tertiary` | S-2 ข้อความใต้ช่องกรอกแคลอรี่สำรอง (เสนอ — Q-10) | ของเดิม: `SignupWarningText` (`app/lib/features/signup/widgets/signup_widgets.dart`) |

### 1.2 ตัวอักษร

ไม่มี custom font ใน `app/pubspec.yaml` → ฟอนต์ default ของ Material ใช้ `Theme.of(context).textTheme` เท่านั้น

| ใช้กับ | style | ที่มา |
|---|---|---|
| หัวข้อหน้าจอ (AppBar title) S-1, S-2, S-3 | default ของ `AppBar` | water / steps / signup ทุกหน้า |
| ตัวเลข `[total_calories] / [target_calories] kcal` S-1 | `textTheme.headlineSmall` | `water_count_text`, `steps_count_text` |
| ป้าย 「อิ่มแล้ว」 S-1 | `textTheme.titleMedium` | `steps_status_badge` |
| CTA Banner — ข้อความชวน | default (`bodyMedium`) | `steps_percent_text` |
| CTA Banner — ยอดรวมแคลอรี่ | `textTheme.titleMedium` | role เดิม (เท่าป้ายสถานะ) |
| Toast S-1 | `textTheme.bodyMedium` สี `onInverseSurface` | default ของ `SnackBar` M3 |
| ข้อความในฟิลด์ / hint | default ของ `TextField` (`bodyLarge`) | signup ฟอร์มทั้งหมด |
| หัวกลุ่มในฟอร์ม (S-3 「เพศ」) | `textTheme.titleMedium` | `signup_gender_label` |
| Error / Warning ใต้ฟิลด์ | default ของ `InputDecoration` (`bodySmall`) | signup S-6 |

### 1.3 ระยะห่าง ขนาด มุมโค้ง เวลา

| Token | ค่า | ที่มา |
|---|---|---|
| Padding หน้าหลัก (S-1) | 24 รอบด้าน | `water_home_screen.dart`, `steps_dashboard_screen.dart` → `EdgeInsets.all(24)` |
| Padding หน้าฟอร์ม (S-2, S-3) | 16 รอบด้าน | steps ui-spec §1.3, signup ui-spec §1.3 |
| ช่องไฟ | 8 / 16 / 24 (`SizedBox`) | `water_home_screen.dart` |
| ระยะระหว่างฟิลด์ / ก่อนปุ่มหลักท้ายฟอร์ม | 16 / 24 | signup ui-spec §1.3 |
| ขนาดสัตว์เลี้ยง | 160 × 160 | `PetCharacter.size` default 160 (`pet_character.dart`), character.md §3 |
| ระยะ Toast ↔ ขอบบนกล่องสัตว์เลี้ยง | 12 — อ่านจากค่าคงที่ `TOAST_ANCHOR_OFFSET` (game-rules §1) ห้าม hardcode | game-rules §1, AC-12 |
| ความสูงช่อง Toast (Toast slot) | 48 | **ใหม่** — เหตุผล: Toast ต้องอยู่เหนือสัตว์เลี้ยงพอดี 12 px และห้ามดันสัตว์เลี้ยงขยับเมื่อ Toast โผล่/หาย จึงจองช่องสูงคงที่ไว้เสมอ ใช้ 48 = ความสูงขั้นต่ำ SnackBar บรรทัดเดียวของ M3 (ข้อความ 1 บรรทัด) |
| Toast container | `Material(elevation: 6, borderRadius: BorderRadius.circular(8))` padding แนวนอน 16 แนวตั้ง 8 | **component ใหม่** — เหตุผล: `SnackBar` ผูกกับขอบล่างของ `Scaffold` ยึดตำแหน่งกับสัตว์เลี้ยงไม่ได้ (AC-12) · elevation 6 = default SnackBar M3, มุม 8 = มุมโค้งเดิมของแอป, padding เท่าป้าย `steps_status_badge` |
| ระยะเวลา Toast | 5 วินาที อ่านจาก `TOAST_DURATION` (game-rules §1) | game-rules §1, AC-12 — **ต่างจาก Toast อื่นของแอป (2 วินาที)** ตามกติกา food ดู Q-7 |
| ความสูงช่องพลังงาน (Energy slot) — ใช้ร่วมกันระหว่างหลอดพลังงานและ CTA Banner | ความสูงขั้นต่ำ 88 ร่วมกันระหว่างหลอดกับ CTA และโตตามเนื้อหาได้ โดยยังไม่เกิด layout shift ตอนสลับ (AC-8) — **ห้ามล็อกความสูงคงที่ 88** ต้องรองรับตัวเลขยาวและ textScaler 1.5 บนจอ 360 dp โดยไม่ overflow (D-5) | **ใหม่** — เหตุผล: AC-8/EC-4 บังคับ Banner กว้าง×สูงเท่า widget หลอดพลังงานเพื่อไม่ให้ layout shift จึงกำหนดช่องเดียวที่ใช้ร่วมกัน; ค่าขั้นต่ำ 88 = Banner padding 8×2 + ข้อความชวน 2 บรรทัด `bodyMedium` (20×2) + ยอดรวม `titleMedium` (24) = 80 ปัดขึ้นตาม grid 8 (ที่ textScaler 1.0) — เนื้อหาที่สูงกว่านี้ให้ช่องโตตาม (D-5) |
| ความสูงหลอดพลังงาน / มุมโค้ง | `minHeight: 20` / `BorderRadius.circular(8)` | `water_energy_bar`, `steps_energy_bar` |
| มุมโค้งป้าย / Banner | `BorderRadius.circular(8)` | `steps_status_badge` |
| ขนาดไอคอน | 24 | `AssetImageOrIcon.size` default 24 |
| Loading ในปุ่ม | `SizedBox(20×20)` + `CircularProgressIndicator(strokeWidth: 2)` | `SignupButtonLabel` (`signup_widgets.dart`) |
| Loading ทั้งหน้า | `Center(CircularProgressIndicator())` | water / steps ตอน `!isLoaded` |
| ขอบช่องกรอก | `OutlineInputBorder()` ค่า default | signup ui-spec §1.3 |
| ระยะเวลาท่ากิน | `EATING_ANIMATION_DURATION` (game-rules §1) — controller ของฟีเจอร์คุม ไม่ใช่ widget | character.md §6 |

## 2. หน้าจอ

ข้อความใน「」คัดลอกตรงตัวจาก ux-flow.md — ห้ามแก้ ข้อความที่ ux-flow ไม่มีและ spec เสนอไว้ชั่วคราว ระบุว่า **(เสนอ — รอยืนยัน)**
ค่าตัวเลขทุกตัว (`OVER_LIMIT_THRESHOLD`, `TOAST_DURATION`, `TOAST_ANCHOR_OFFSET`, `EATING_ANIMATION_DURATION`, `AGE_MIN`, `AGE_MAX`, `FALLBACK_DEFAULT_CALORIES` ฯลฯ) และข้อความบนจอทุกข้อความ ต้องอ่านจากค่าคงที่ชุดเดียว (เช่น `FoodRules`) แบบ `StepsRules` / `SignupRules` — ห้าม hardcode ในหน้าจอ
ValueKey ใช้ prefix `food_` ทั้งหมด
ตัวเลขแคลอรี่ทุกจุดเป็นจำนวนเต็มใส่ comma คั่นหลักพัน (เช่น `1,900`) — ตามรูปแบบตัวอย่างใน game-rules §3 และ `steps_count_text`

### 2.0 ทางเข้า S-1 จากหน้า water (D-2)

- ตำแหน่ง: `AppBar.actions` ของ `WaterHomeScreen` วาง**ต่อจาก** `steps_entry_button` และก่อน `water_monthly_report_button`
- Widget: `IconButton` แบบเดียวกับ `steps_entry_button` — `Icon(Icons.restaurant, size: 24)`, `tooltip:` 「โภชนาการ」 **(เสนอ — รอยืนยัน, Q-1)**
- กดแล้ว `Navigator.push(MaterialPageRoute(...))` ไป S-1 (แบบ `_openSteps`)
- ValueKey: `food_entry_button`
- ห้ามแก้ส่วนอื่นของ `WaterHomeScreen`

### 2.1 S-1 หน้าหลักแดชบอร์ดสัตว์เลี้ยงและโภชนาการ (Pet Dashboard & Food Tracker)

โครง: `Scaffold` → `AppBar` → body `ListenableBuilder` (pattern water/steps) → `!isLoaded` = `Center(CircularProgressIndicator())` → `SafeArea` → `LayoutBuilder` + `SingleChildScrollView` + `ConstrainedBox(minHeight)` + `IntrinsicHeight` (pattern `steps_dashboard_screen.dart` เพื่อคง `Spacer` และไม่ overflow) → `Padding(24)` → `Column(crossAxisAlignment: stretch)`
ไม่มีภาพพื้นหลัง (ux-flow §5 ไม่มี) — พื้น `colorScheme.surface` ตาม default

จากบนลงล่าง:

| # | องค์ประกอบ | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 1 | หัวข้อหน้าจอ | `AppBar(title: Text(...))` — มีปุ่มย้อนกลับอัตโนมัติเพราะถูก push จาก water | 「โภชนาการ」 **(เสนอ — รอยืนยัน, Q-2)** | AppBar default | `food_header_text` (บน `Text`) |
| 2 | `Spacer()` | | | | |
| 3 | ช่อง Toast (Toast Notification Area) | `SizedBox(height: 48)` → `Align(alignment: Alignment.bottomCenter)` → Toast (เมื่อมี) หรือว่าง | ดู §2.1.1 | §1.3 | ช่อง `food_toast_slot`; Toast `food_toast` |
| 4 | ระยะ anchor | `SizedBox(height: TOAST_ANCHOR_OFFSET)` (= 12) | | game-rules §1 | - |
| 5 | สัตว์เลี้ยง (Pet Display Area) | `Center` → `KeyedSubtree(key: food_pet_image_<state>)` → `PetCharacter(key: _petKey /* GlobalKey(debugLabel: 'food_pet') */, pose: ..., size: 160, animate: widget.animatePet ?? kPetAnimateByDefault)` — **ไม่ส่ง `cheerTrigger`** | ท่าตามสถานะ §4 | 160 × 160 | `food_pet_image_<state>` บน `KeyedSubtree` (state ดู §4) |
| 6 | `SizedBox(height: 16)` | | | | |
| 7 | ป้าย 「อิ่มแล้ว」 | `Center` → `Visibility(visible: <เกินเกณฑ์ตามข้อมูลจริง — เงื่อนไขเดียวกับหลอดสี error, D-4>, maintainSize: true, maintainAnimation: true, maintainState: true)` → `Container` padding แนวนอน 16 แนวตั้ง 8, `BorderRadius.circular(8)` (รูปทรงเดียวกับ `steps_status_badge`) | 「อิ่มแล้ว」 | พื้น `errorContainer`, ตัวอักษร `onErrorContainer` + `titleMedium` | `food_full_badge` |
| 8 | `SizedBox(height: 24)` | | | | |
| 9 | ช่องพลังงาน (Energy slot) | ช่องเต็มความกว้าง ความสูงขั้นต่ำ 88 ร่วมกันระหว่างหลอดกับ CTA และโตตามเนื้อหาได้ โดยยังไม่เกิด layout shift ตอนสลับ (AC-8, D-5, §1.3) → **9a** หรือ **9b** อย่างใดอย่างหนึ่ง (ห้ามมีทั้งสอง) — ห้ามล็อกความสูงคงที่ 88, ห้าม overflow เมื่อตัวเลขยาวหรือ textScaler 1.5 บนจอ 360 dp | | §1.3 | `food_energy_slot` |
| 9a | หลอดพลังงาน (มีโปรไฟล์) | `Column(mainAxisAlignment: center, crossAxisAlignment: stretch)` → `ClipRRect(BorderRadius.circular(8))` → `LinearProgressIndicator(value: fraction, minHeight: 20, color: <primary หรือ error>)` key `food_energy_bar` · `SizedBox(height: 8)` · `Text(textAlign: center)` key `food_calorie_text` | `value` = `total_calories / target_calories` **clamp 0.0–1.0** · ข้อความรูปแบบ `[total_calories] / [target_calories] kcal` → `'<total> / <target> kcal'` เช่น `1,900 / 2,000 kcal` (ค่าจริงไม่ clamp เช่น `2,250 / 2,000 kcal`) | หลอด §1.1, ข้อความ `headlineSmall` | `food_energy_block` (บน `Column`), `food_energy_bar`, `food_calorie_text` |
| 9b | CTA Banner (ข้ามโปรไฟล์) | `Material(color: secondaryContainer, borderRadius: BorderRadius.circular(8))` → `InkWell(borderRadius: 8, onTap: → S-3)` → `Padding(horizontal: 16, vertical: 8)` → `Row` [`Expanded(Column(mainAxisAlignment: center, crossAxisAlignment: start))` [ข้อความชวน, ยอดรวม], `SizedBox(width: 8)`, `Icon(Icons.chevron_right, size: 24)`] — กว้าง×สูงเต็ม Energy slot | ข้อความชวน: 「ตั้งค่าโปรไฟล์สุขภาพเพื่อรับเป้าหมายแคลอรี่ที่แม่นยำ」 (`maxLines: 2`, ellipsis) · ยอดรวม: `'<total> kcal'` เช่น `1,250 kcal` **(เสนอ — ตาม AC-8, Q-8)** | ข้อความชวน `bodyMedium`, ยอดรวม `titleMedium`, สี `onSecondaryContainer` | `food_profile_cta_banner` (บน `InkWell`), `food_cta_text`, `food_cta_total_text` |
| 10 | `Spacer()` | | | | |
| 11 | ปุ่มเพิ่มอาหาร (Add Food Button) | `FilledButton.icon`, icon `Icons.restaurant` 24 | 「บันทึกมื้ออาหาร」 | primary (เหมือน `water_log_button`) | `food_add_meal_button` |

- กด #11 → push S-2; กด #9b → push S-3
- เมื่อค่าเปลี่ยน: หลอด/ตัวเลข/สีหลอด และป้าย 「อิ่มแล้ว」 เปลี่ยนทันทีใน frame ถัดไปตามข้อมูลจริง (ไม่มี animation ของหลอด) — ป้ายขึ้น/หายพร้อมหลอดแดงในเฟรมเดียวกัน ไม่รอท่าสัตว์เลี้ยง (D-4) · ท่าสัตว์เลี้ยงเปลี่ยนตามสถานะสัตว์เลี้ยงที่ controller ถือ (§3)
- `Visibility(maintainSize)` ของป้าย #7 และช่อง Toast #3 ที่สูงคงที่ ทำให้สัตว์เลี้ยงและหลอดไม่ขยับเมื่อป้าย/Toast โผล่หรือหาย

#### 2.1.1 Toast ลอยเหนือสัตว์เลี้ยง (component ใหม่)

- Widget: `Material(color: inverseSurface, elevation: 6, borderRadius: BorderRadius.circular(8))` → `Padding(horizontal: 16, vertical: 8)` → `Text(message, textAlign: center, maxLines: 1, overflow: ellipsis, style: bodyMedium + onInverseSurface)`
- ความกว้าง: ตามเนื้อหา (ไม่ stretch) จัดกลางแนวนอนเหนือสัตว์เลี้ยง
- ตำแหน่ง: ขอบล่างของ Toast ชิดขอบล่างของช่อง #3 → ห่างขอบบนสุดของกล่อง `PetCharacter` (กล่อง 160×160 ที่รวมใบไม้แล้ว — character.md §7, `PetKeys.character`) เท่ากับ `TOAST_ANCHOR_OFFSET` = 12 เสมอ
- แสดงทีละ 1 ข้อความ (AC-12): Toast ใหม่**แทนที่**อันเดิมทันที (Queue replace) และเริ่มนับ `TOAST_DURATION` (5 วินาที) ใหม่ — ไม่มีการซ้อนหลายกล่อง
- ปรากฏ/หาย: ทันที ไม่มี animation (ถ้าจะใส่ fade ต้องไม่เปลี่ยนตำแหน่ง/ขนาดช่อง)
- ValueKey: `food_toast` บน `Material`; ข้อความ 「พอเถอะน้าคนดี」 ใช้ key `food_over_limit_toast` บน `Text`
- ห้ามใช้ `ScaffoldMessenger` / `SnackBar` สำหรับ Toast นี้

### 2.2 S-2 หน้าจอเพิ่มเมนูอาหาร (Add Meal Screen)

โครง: `Scaffold` → `AppBar` → body `SingleChildScrollView` → `Padding(16)` → `Column(crossAxisAlignment: stretch)` — ปุ่มส่งอยู่ท้ายฟอร์ม (เลื่อนตามเนื้อหา แบบ signup S-6)

| # | องค์ประกอบ | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 1 | ปุ่มย้อนกลับ (Back Button) | `AppBar.leading: IconButton(icon: Icon(Icons.arrow_back))` แบบ `steps_goal_back_button` | ไอคอนลูกศรย้อนกลับ, tooltip 「ย้อนกลับ」 (ค่าเดียวกับ `StepsRules.backButtonText` / `SignupRules.backButtonText`) | AppBar default | `food_meal_back_button` |
| 2 | หัวข้อหน้าจอ | `AppBar(title: Text(...))` | 「บันทึกมื้ออาหาร」 **(เสนอ — ยืมข้อความปุ่ม S-1, Q-2)** | AppBar default | `food_meal_header_text` |
| 3 | ช่องกรอกเมนูอาหาร (Food Input Field) | `TextField(minLines: 3, maxLines: null, keyboardType: TextInputType.multiline)` + `InputDecoration(border: OutlineInputBorder(), hintText: ...)` | hint 「พิมพ์เมนูอาหารที่คุณทานวันนี้ เช่น ข้าวมันไก่ 1 จาน...」 | §1.3 (เหมือน `signup_health_goal_field`) | `food_meal_input_field` |
| 4 | `SizedBox(height: 16)` — **เฉพาะสถานะผิดพลาด/ออฟไลน์** | | | | |
| 5 | ฟอร์มกรอกแคลอรี่สำรอง (Fallback Manual Calorie Input) — **เฉพาะสถานะผิดพลาด/ออฟไลน์** | `TextField(keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly])` + `InputDecoration(border: OutlineInputBorder(), hintText: ..., helper: <ข้อความแจ้ง>)` — ช่องว่างเปล่า (ไม่เติม 300 ลงในช่อง; ค่า default ใช้ตอนบันทึกตาม game-rules §4) | hint 「ระบุแคลอรี่ (kcal)」 · helper 「ไม่สามารถประมวลผลเมนูอัตโนมัติได้ กรุณาระบุแคลอรี่เอง」 **(เสนอ — รอยืนยัน, Q-10)** | hint default; helper `bodySmall` + `tertiary` (`SignupWarningText` pattern) | ช่อง `food_manual_calorie_field`; helper `food_manual_calorie_helper_text` |
| 6 | `SizedBox(height: 24)` | | | | |
| 7 | ปุ่มส่งข้อมูล (Submit Button) | `FilledButton` เต็มความกว้าง | 「บันทึกข้อมูล」 | primary; loading/disabled = default M3 | `food_meal_submit_button` |

- บันทึกสำเร็จ → `Navigator.pop` กลับ S-1 (S-1 แสดงท่ากินตาม §3) — S-2 ไม่แสดงข้อความยืนยันใด ๆ (ux-flow ไม่มี)

### 2.3 S-3 หน้าจอตั้งค่าโปรไฟล์สุขภาพเบื้องต้น (Profile Setup Screen)

โครง: `Scaffold` → `AppBar(automaticallyImplyLeading: false)` (ux-flow ไม่มีปุ่มย้อนกลับ — ทางออกคือ 「ข้ามไปก่อน」) → body `SingleChildScrollView` → `Padding(16)` → `Column(crossAxisAlignment: stretch)` — pattern เดียวกับ signup S-6

| # | องค์ประกอบ | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 1 | หัวข้อหน้าจอ | `AppBar(title: Text(...))` | 「ตั้งค่าโปรไฟล์สุขภาพ」 **(เสนอ — รอยืนยัน, Q-2)** | AppBar default | `food_profile_header_text` |
| 2 | ช่องกรอกอายุ (Age Input) | `TextField(keyboardType: TextInputType.number, inputFormatters: [SignupWholeNumberInputFormatter(), FilteringTextInputFormatter.digitsOnly])` + `OutlineInputBorder()` — กติกาเดียวกับ signup S-6 (D-3): รับเฉพาะจำนวนเต็ม การพิมพ์/วางที่มีจุดหรืออักขระที่ไม่ใช่ตัวเลข (เช่น `20.5`, `-3`) ถูกปฏิเสธตั้งแต่แรก ค่าเดิมในช่องคงอยู่ (ไม่เปลี่ยนเงียบ ๆ เป็น `205`) | hint 「ระบุอายุ (ปี)」 | §1.3 | `food_age_field` |
| 3 | `SizedBox(height: 16)` | | | | |
| 4 | หัวกลุ่มเพศ | `Text` | 「เพศ」 **(เสนอ — ข้อความเดียวกับ `signup_gender_label`, Q-15)** | `titleMedium` | `food_gender_label` |
| 5 | ตัวเลือกเพศ (Gender Selector) | `RadioGroup<...>` → `Column` → 2 × `RadioListTile(contentPadding: EdgeInsets.zero)` (pattern `signup_gender_group`; เลือก Radio จาก "Radio Button / Choice Chip") — ไม่มีค่าเลือกไว้ล่วงหน้า | ลำดับ: 「ชาย」 「หญิง」 — แสดงเฉพาะคำไทยจาก `MALE (ชาย)`, `FEMALE (หญิง)` ค่าภายในเป็น `MALE` / `FEMALE` (แนวเดียวกับ signup Q-8) | RadioListTile default | กลุ่ม `food_gender_group`; ตัวเลือก `food_gender_male`, `food_gender_female` |
| 6 | `SizedBox(height: 16)` | | | | |
| 7 | ช่องกรอกน้ำหนัก (Weight Input) | `TextField(keyboardType: TextInputType.numberWithOptions(decimal: true))` + `OutlineInputBorder()` — รับทศนิยมได้ (D-3) | hint 「น้ำหนัก (kg)」 | §1.3 | `food_weight_field` |
| 8 | `SizedBox(height: 16)` | | | | |
| 9 | ช่องกรอกส่วนสูง (Height Input) | `TextField(keyboardType: TextInputType.numberWithOptions(decimal: true))` + `OutlineInputBorder()` — รับทศนิยมได้ (D-3) | hint 「ส่วนสูง (cm)」 | §1.3 | `food_height_field` |
| 10 | `SizedBox(height: 24)` | | | | |
| 11 | ปุ่มบันทึกโปรไฟล์ (Save Profile Button) | `FilledButton` เต็มความกว้าง | 「บันทึกและคำนวณเป้าหมาย」 | primary; disabled = default M3 | `food_profile_save_button` |
| 12 | `SizedBox(height: 8)` | | | | |
| 13 | ปุ่มข้าม (Skip Button) | `Center` → `TextButton` | 「ข้ามไปก่อน」 | TextButton default | `food_profile_skip_button` |

- ลำดับฟิลด์ตาม ux-flow §2 S-3 (อายุ → เพศ → น้ำหนัก → ส่วนสูง)
- Error ใต้ช่องอายุผ่าน `InputDecoration.error: Text(key: ...)` (สี `colorScheme.error` default): 「กรุณากรอกอายุเป็นจำนวนเต็มระหว่าง 1 - 120 ปี」 key `food_age_error_text` — ตัวเลข 1 / 120 ในข้อความต้องมาจาก `AGE_MIN` / `AGE_MAX` · ขึ้นเมื่อค่าจำนวนเต็มอยู่นอก `[AGE_MIN, AGE_MAX]` (เช่น `0`, `121`) — ทศนิยมพิมพ์ไม่ได้ตั้งแต่แรกจึงไม่ใช่ทางที่ทำให้ error ขึ้น (D-3)
- กด #11 หรือ #13 → กลับ S-1 (บันทึกแล้ว → หลอดพลังงาน 9a; ข้าม → CTA Banner 9b)

## 3. สถานะของแต่ละหน้าจอ

### S-1

สถานะสัตว์เลี้ยง (game-rules §2) กำหนดท่า §4; สถานะหลอด/ป้ายกำหนดจาก `total_calories` เทียบ `target_calories + OVER_LIMIT_THRESHOLD` ตามข้อมูลจริงทันที (ไม่เขียนเงื่อนไขซ้ำที่นี่) — ป้าย 「อิ่มแล้ว」 ใช้เงื่อนไขเดียวกับหลอดสี `error` (D-4)

| สถานะ | หน้าตา |
|---|---|
| กำลังโหลด | `Center(CircularProgressIndicator())` แทน body ทั้งหมด (pattern water/steps) |
| ปกติ (Normal) — AC-9 | ตาม §2.1 · ท่า `PetPose.foodNormal` key `food_pet_image_normal` · หลอดสี `primary` (รวมช่วงเกินเป้า ≤ 100 kcal: หลอดเต็ม `value` 1.0 แต่ยังสี `primary`, ข้อความแสดงค่าจริงเช่น `2,050 / 2,000 kcal`) · ป้าย 「อิ่มแล้ว」 ซ่อน (จองที่ไว้) · ไม่มี Toast |
| ว่าง (Empty) | `food_calorie_text` = `0 / <target> kcal` (เช่น `0 / 2,000 kcal`), `food_energy_bar` value 0.0 สี `primary`, ท่า `PetPose.foodNormal` — layout เดิม ไม่มีข้อความพิเศษ |
| กำลังกิน (Eating State) | กลับจาก S-2 ด้วยการบันทึกสำเร็จ (จากสถานะที่ไม่ใช่เกินเป้า) → ท่า `PetPose.foodEating` key `food_pet_image_eating` (เคี้ยววน 420 ms/คำ ใน widget) ตลอด `EATING_ANIMATION_DURATION` แล้ว controller เปลี่ยนท่าตามระดับแคลอรี่จริง (`foodNormal` หรือ `foodOverLimit`) · หลอดและตัวเลขแสดงยอดใหม่ทันทีตั้งแต่กลับถึง S-1 (สีหลอดตามยอดใหม่) · ป้าย 「อิ่มแล้ว」 ตามข้อมูลจริงทันทีพร้อมสีหลอด — ถ้าการบันทึกนี้ข้ามเกณฑ์ ป้ายขึ้นพร้อมหลอดแดงทันทีขณะสัตว์เลี้ยงยังอยู่ท่า `foodEating` (D-4) · ไม่มี Toast · ไม่มี cheer |
| เกินเป้าหมาย (Overeating Limit) — AC-10 | ท่า `PetPose.foodOverLimit` key `food_pet_image_over_limit` · หลอดเต็ม (`value` 1.0) สี `colorScheme.error` · ป้าย 「อิ่มแล้ว」 key `food_full_badge` แสดง (ขึ้นในเฟรมเดียวกับที่หลอดเป็นสี `error` — D-4) · ข้อความ เช่น `2,150 / 2,000 kcal` |
| อิ่มพุงกางแต่ยังกิน (`OVER_LIMIT_FEEDING`) — AC-11, EC-3 | บันทึกสำเร็จขณะอยู่ในสถานะเกินเป้าหมาย → ท่า `PetPose.foodOverLimitFeeding` key `food_pet_image_over_limit_feeding` (เคี้ยววน) แทนท่า `EATING` · Toast 「พอเถอะน้าคนดี」 (`food_toast` + `food_over_limit_toast`) ปรากฏในช่อง #3 เหนือสัตว์เลี้ยง 12 px ค้าง 5 วินาที — **ทุกครั้ง**ที่บันทึกซ้ำ · หลอดยังสี `error` ป้าย 「อิ่มแล้ว」 ยังแสดง · ระยะของท่านี้ก่อนกลับเป็น `foodOverLimit` ดู Q-3 |
| บันทึกซ้อนเร็ว (EC-2) | Toast เดิมถูกแทนที่ทันทีด้วย Toast ของการบันทึกใหม่ (นับ 5 วินาทีใหม่) — มีกล่อง Toast ไม่เกิน 1 กล่องเสมอ · ท่าสัตว์เลี้ยงเริ่มท่าชั่วคราวของการบันทึกล่าสุด (Q-4) |
| ข้ามโปรไฟล์ (Skipped Profile) — AC-8, EC-4 | ช่อง #9 แสดง CTA Banner 9b แทน 9a (ไม่มี `food_energy_bar` / `food_calorie_text` ใน tree) · ขนาด `food_profile_cta_banner` = ขนาด `food_energy_slot` = ขนาดเดียวกับตอนแสดงหลอดบนจอและ textScaler เดียวกัน (กว้างเต็ม × ความสูงช่องร่วม ≥ 88 ที่โตตามเนื้อหาได้ — D-5) → ไม่มี layout shift ตอนสลับ · ท่า `foodNormal` / `foodEating` ตามการบันทึก (ไม่มีเป้าหมายจึงไม่เข้าสถานะเกินเป้า — Q-9) · ป้าย 「อิ่มแล้ว」 ซ่อน |

### S-2

ทุก loading ในปุ่ม: `onPressed: null` + child `Row(mainAxisSize: min)` [`SizedBox(20×20, CircularProgressIndicator(strokeWidth: 2))`, `SizedBox(width: 8)`, `Text(「บันทึกข้อมูล」)`] แบบ `SignupButtonLabel`

| สถานะ | หน้าตา |
|---|---|
| ปกติ (Normal) | ตาม §2.2 #1–#3, #6–#7 (ไม่มี #4–#5) · ช่องเมนูว่างแสดง hint · ปุ่ม 「บันทึกข้อมูล」 enabled (ux-flow ไม่มีพฤติกรรม disabled — Q-12) |
| กำลังประมวลผล AI (loading) **(เสนอ — Q-11)** | ปุ่ม loading spinner key `food_meal_submit_loading_indicator` · ช่องเมนู (และช่องแคลอรี่ถ้ามี) `enabled: false` ค่ายังแสดงอยู่ · ปุ่มย้อนกลับยังกดได้ |
| ผิดพลาด / ออฟไลน์ (Error / Offline) — EC-1 | เพิ่ม #4–#5 ใต้ช่องเมนูทันที: ช่อง 「ระบุแคลอรี่ (kcal)」 ว่าง + helper สี tertiary · ช่องเมนูคงข้อความที่ผู้ใช้พิมพ์ไว้ (ไม่ล้าง, ยังแก้ได้ — Q-10) · ปุ่ม 「บันทึกข้อมูล」 enabled แม้ช่องแคลอรี่ว่าง (ระบบใช้ `FALLBACK_DEFAULT_CALORIES`) · ไม่มี dialog / SnackBar |

### S-3

| สถานะ | หน้าตา |
|---|---|
| ปกติ (Normal) | ตาม §2.3 ฟิลด์ว่างทั้ง 3 แสดง hint (หรือเติมค่าเดิมจากโปรไฟล์ signup ถ้ามี — ตามที่ Dev เลือกไว้, Q-13) · ยังไม่มีเพศถูกเลือก (เว้นแต่ค่าเดิมเป็น 「ชาย」/「หญิง」) · ไม่มี error · `food_profile_save_button` disabled จนกว่าอายุถูกต้อง + เลือกเพศ + กรอกน้ำหนักและส่วนสูง (ต้องใช้ทั้ง 4 ค่าคำนวณเป้าหมาย — Q-15) · 「ข้ามไปก่อน」 enabled เสมอ |
| ผิดพลาด (Error) — AC-4, EC-5 | อายุเป็นจำนวนเต็มนอก `[AGE_MIN, AGE_MAX]` (เช่น `0`, `121`) → `food_age_error_text` 「กรุณากรอกอายุเป็นจำนวนเต็มระหว่าง 1 - 120 ปี」 ใต้ช่องอายุทันทีขณะพิมพ์ ขอบช่องสี error (default M3) · ปุ่มบันทึก disabled (บล็อกการบันทึก) · ช่องว่างไม่แสดง error (สถานะปกติ) · การพิมพ์/วางจุดทศนิยม (เช่น `20.5`) ถูกปฏิเสธที่ช่องตั้งแต่แรก ค่าในช่องคงเดิม ไม่มี error เพิ่ม (D-3 — กติกาเดียวกับ signup S-6) |

## 4. ภาพสัตว์เลี้ยงแต่ละสถานะ

ใช้ `PetCharacter` ตัวเดียวจาก `app/lib/shared/pet/` (`import 'package:petpal_health/shared/pet/pet.dart'`) — **ไม่ใช้ไฟล์ Lottie/PNG ใน ux-flow §5 และ game-rules §2** (D-1) ชื่อ preset ตรวจแล้วกับ `app/lib/shared/pet/pet_pose.dart` และ `docs/_design/character.md` §5, §7

| สถานะ (game-rules §2) | Preset | สีหน้า / รูปร่าง | ท่าทางที่เห็น (character.md §4–5) | ขยับ | ขนาด | key บน `KeyedSubtree` (เสนอ — Dev/QA ตัดสินชื่อสุดท้าย) | preview |
|---|---|---|---|---|---|---|---|
| `NORMAL` ท่าหิว/ปกติ | `PetPose.foodNormal` (reuse) | `content` / `normal` | แลบลิ้น blep + ฟองน้ำลาย ตาขวาตกข้างเดียว ร่าเริงอยากกิน | หายใจ + กะพริบ | 160 × 160 | `food_pet_image_normal` | `docs/_design/preview/food_normal.png` |
| `EATING` ชั่วคราว | `PetPose.foodEating` | `eating` / `normal` | สองมือถือข้าวปั้น ตาเหล่เข้ามองของกิน แก้มป่อง ปาก ω | ลูปเคี้ยว `PetTiming.chew` 420 ms ตราบที่ `pose.isEating` | 160 × 160 | `food_pet_image_eating` | `food_eating.png` |
| `OVER_LIMIT` อิ่มพุงกาง | `PetPose.foodOverLimit` | `full` / `stuffed` | พุงตึงกลม หลับตาฟิน มือแปะพุง ควันเรอ | หายใจ (มือตบพุง ควันลอย) | 160 × 160 | `food_pet_image_over_limit` | `food_over_limit.png` |
| `OVER_LIMIT_FEEDING` ชั่วคราว | `PetPose.foodOverLimitFeeding` | `overfed` / `stuffed` | พุงตึงกลม ถือข้าวปั้นเคี้ยวต่อ หนังตาหนักสองข้าง คิ้วกังวล เหงื่อ | ลูปเคี้ยว 420 ms | 160 × 160 | `food_pet_image_over_limit_feeding` | `food_over_limit_feeding.png` |

ภาพรวม 4 ท่าที่ขนาดจริง: `docs/_design/preview/food_states_160.png` · วงจรเคี้ยว: `fx_food_chew_cycle.png`

กติกาการใช้ widget (character.md §6–7):
- `PetCharacter(key: _petKey)` — `_petKey = GlobalKey(debugLabel: 'food_pet')` สร้างครั้งเดียวใน State ของ S-1; key ฟีเจอร์ `food_pet_image_<state>` อยู่บน `KeyedSubtree` ที่ห่อไว้เท่านั้น (กัน BUG-PET-1)
- **ไม่ส่ง / ไม่เพิ่ม `cheerTrigger`** ตอนบันทึกอาหาร — ท่ากินคือ reaction อยู่แล้ว และ cheer (900 ms) จะบังหน้ากิน
- widget ไม่จับเวลาเอง: controller ของฟีเจอร์ถือสถานะ `EATING` / `OVER_LIMIT_FEEDING` ตาม `EATING_ANIMATION_DURATION` แล้วเปลี่ยน `pose` เมื่อหมดเวลา
- `animate: widget.animatePet ?? kPetAnimateByDefault` (`pet_animation_policy.dart`) — S-1 รับพารามิเตอร์ `animatePet` แบบ water/steps
- `reactToTap` คง default (แตะแล้วกระโดดหน้าตลกเหมือนทั้งแอป)
- Toast anchor อ้างขอบบนของกล่อง `PetCharacter` (`SizedBox` size × size ที่รวมใบไม้แล้ว — หาได้ด้วย `PetKeys.character`)
- ท่าสัตว์เลี้ยงไม่เป็นตัวกำหนดการแสดงป้าย 「อิ่มแล้ว」 (D-4) — ป้ายอาจแสดงคู่กับท่า `foodEating` ได้ในช่วงท่ากินของการบันทึกที่ข้ามเกณฑ์
- ไม่ต้องการท่าใหม่จาก Art — 4 สถานะมี preset ครบ

## 5. Checklist สำหรับ reviewer

- [ ] ไม่มี hex สีในโค้ด food — สีทั้งหมดมาจาก `Theme.of(context).colorScheme` (seed `Colors.lightBlue` ใน `main.dart`)
- [ ] ไม่แก้ `ThemeData` ใน `app/lib/main.dart`, ไม่เพิ่ม font และไม่เพิ่ม package `lottie` ใน pubspec
- [ ] ไม่มีการโหลด `assets/images/pet/*.json`, PNG หรือ Sprite Sheet ใด ๆ เป็นภาพสัตว์เลี้ยง และไม่แก้ไฟล์ใน `app/lib/shared/pet/`
- [ ] ข้อความบนจอทุกข้อความตรงกับ ux-flow ตัวต่อตัว (ยกเว้นที่ spec ระบุ "เสนอ — รอยืนยัน") และอ่านจากค่าคงที่ชุดเดียว (เช่น `FoodRules`)
- [ ] ตัวเลขกติกา (`OVER_LIMIT_THRESHOLD`, `TOAST_DURATION`, `TOAST_ANCHOR_OFFSET`, `EATING_ANIMATION_DURATION`, `AGE_MIN`, `AGE_MAX`, `FALLBACK_DEFAULT_CALORIES`) ไม่ถูก hardcode ในหน้าจอ
- [ ] มีปุ่ม `food_entry_button` (`IconButton`, `Icons.restaurant`) ใน AppBar ของ `WaterHomeScreen` ถัดจาก `steps_entry_button` และกดแล้วไป S-1
- [ ] S-1 padding 24, ช่องไฟ 8/16/24, ใช้ pattern scroll + `IntrinsicHeight` (ไม่ overflow บนจอ 360 dp)
- [ ] S-1 สัตว์เลี้ยงเป็น `PetCharacter` ขนาด 160 ที่ถือ `GlobalKey` และห่อด้วย `KeyedSubtree` key `food_pet_image_<normal|eating|over_limit|over_limit_feeding>`
- [ ] S-1 map สถานะ → `painter.pose`: NORMAL=`PetPose.foodNormal`, EATING=`PetPose.foodEating`, OVER_LIMIT=`PetPose.foodOverLimit`, OVER_LIMIT_FEEDING=`PetPose.foodOverLimitFeeding`
- [ ] `PetCharacter` ของ food ไม่มี `cheerTrigger` (หรือเป็นค่าคงที่ไม่เปลี่ยนตอนบันทึก)
- [ ] หลอดพลังงาน `LinearProgressIndicator` key `food_energy_bar` `minHeight: 20` มุมโค้ง 8, value clamp ไม่เกิน 1.0
- [ ] หลอดใช้สี `colorScheme.primary` เมื่อไม่เกินเป้า (รวมเกิน ≤ 100 kcal) และ `colorScheme.error` เมื่อเกินเป้า > 100 kcal
- [ ] `food_calorie_text` รูปแบบ `<total> / <target> kcal` มี comma คั่นหลักพัน style `headlineSmall`; ว่าง = `0 / <target> kcal`
- [ ] ป้าย `food_full_badge` 「อิ่มแล้ว」 พื้น `errorContainer` ตัวอักษร `onErrorContainer` `titleMedium` ใช้ `Visibility(maintainSize: true)` (ตำแหน่งสัตว์เลี้ยงไม่ขยับ) และ visible ด้วยเงื่อนไขเดียวกับหลอดสี `error` (ข้อมูลจริง) — ไม่ผูกกับท่าสัตว์เลี้ยง (D-4)
- [ ] บันทึกที่ทำให้ข้ามเกณฑ์ → ทันทีที่กลับถึง S-1 `food_full_badge` visible และหลอดสี `error` พร้อมกัน ขณะ `food_pet_image_eating` ยังอยู่ใน tree (ไม่รอหมด `EATING_ANIMATION_DURATION`)
- [ ] `food_energy_slot` กว้างเต็ม สูง ≥ 88 และไม่ล็อกความสูงคงที่ 88 (D-5); ข้ามโปรไฟล์แล้ว `tester.getSize(food_profile_cta_banner)` == ขนาด `food_energy_slot` == ขนาดตอนแสดง `food_energy_block` ภายใต้จอและ textScaler เดียวกัน (ไม่มี layout shift ตอนสลับ — AC-8)
- [ ] จอ 360 dp + textScaler 1.5 + ตัวเลขยาว (เช่น `123,456 / 2,000 kcal` และ `123,456 kcal`) ทั้ง 9a และ 9b ไม่มี RenderFlex overflow (D-5)
- [ ] CTA Banner key `food_profile_cta_banner` พื้น `secondaryContainer`, ข้อความ 「ตั้งค่าโปรไฟล์สุขภาพเพื่อรับเป้าหมายแคลอรี่ที่แม่นยำ」 + ยอดรวม `<total> kcal` + `Icons.chevron_right`; แตะแล้วไป S-3
- [ ] สถานะข้ามโปรไฟล์ไม่มี `food_energy_bar` ใน widget tree
- [ ] ปุ่ม 「บันทึกมื้ออาหาร」 เป็น `FilledButton.icon` key `food_add_meal_button` ไป S-2
- [ ] Toast ไม่ใช่ `SnackBar` — เป็น `Material` key `food_toast` สี `inverseSurface`/`onInverseSurface` มุม 8 อยู่ในช่อง `food_toast_slot` สูง 48
- [ ] ขอบล่างของ `food_toast` อยู่สูงกว่าขอบบนของกล่อง `PetKeys.character` เท่ากับ 12 px พอดี (`getBottomLeft(food_toast).dy + 12 == getTopLeft(PetKeys.character).dy`)
- [ ] บันทึกขณะเกินเป้า → `food_over_limit_toast` 「พอเถอะน้าคนดี」 แสดงทุกครั้ง; บันทึกซ้อนภายใน 5 วินาทีมี `food_toast` เพียง 1 ตัวใน tree; หายเองหลัง 5 วินาที
- [ ] บันทึกสำเร็จตอนไม่เกินเป้า → ท่า EATING ไม่มี Toast
- [ ] S-2 ปุ่มย้อนกลับ key `food_meal_back_button` (tooltip 「ย้อนกลับ」) กลับ S-1
- [ ] S-2 ช่องเมนู key `food_meal_input_field` multiline `minLines: 3` `OutlineInputBorder()` hint ตรงตัว
- [ ] S-2 ปุ่ม 「บันทึกข้อมูล」 `FilledButton` เต็มความกว้าง key `food_meal_submit_button`; ระหว่างประมวลผลมี spinner 20×20 key `food_meal_submit_loading_indicator` + `onPressed: null`
- [ ] S-2 สถานะปกติไม่มี `food_manual_calorie_field`; สถานะผิดพลาด/ออฟไลน์มี `food_manual_calorie_field` (digitsOnly, hint 「ระบุแคลอรี่ (kcal)」, ช่องว่างไม่เติม 300) + helper สี `tertiary` และช่องเมนูยังเก็บข้อความเดิม
- [ ] S-3 AppBar ไม่มีปุ่มย้อนกลับ; ลำดับ อายุ → เพศ → น้ำหนัก → ส่วนสูง; hint ตรงตัว 「ระบุอายุ (ปี)」「น้ำหนัก (kg)」「ส่วนสูง (cm)」
- [ ] S-3 เพศเป็น `RadioListTile` 2 ตัว 「ชาย」「หญิง」 keys `food_gender_male/female` ไม่มีค่าเลือกไว้ก่อน (เมื่อไม่มีค่าเดิมจากโปรไฟล์)
- [ ] S-3 ช่องอายุ `food_age_field` ใช้ `SignupWholeNumberInputFormatter` + `FilteringTextInputFormatter.digitsOnly` (กติกาเดียวกับ `signup_age_field` — D-3); พิมพ์/วาง `20.5` แล้วค่าในช่องไม่เปลี่ยน (ไม่กลายเป็น `205`) และไม่มี `food_age_error_text`
- [ ] S-3 ช่องน้ำหนัก/ส่วนสูงใช้ `numberWithOptions(decimal: true)` และรับค่าทศนิยม (เช่น `55.5`) ได้
- [ ] S-3 พิมพ์อายุ `0`, `121` → `food_age_error_text` 「กรุณากรอกอายุเป็นจำนวนเต็มระหว่าง 1 - 120 ปี」 สี error + `food_profile_save_button` disabled; ช่องว่างไม่มี error
- [ ] S-3 ปุ่ม 「บันทึกและคำนวณเป้าหมาย」 `FilledButton` key `food_profile_save_button`; 「ข้ามไปก่อน」 `TextButton` key `food_profile_skip_button` enabled เสมอ
- [ ] ไม่มีหน้าจออื่นนอกจาก S-1, S-2, S-3 (ทางเข้าเป็นแค่ปุ่มบนหน้า water)

## 6. คำถามที่ค้าง

| # | ประเด็น | ทางที่ spec เลือกไว้ชั่วคราว |
|---|---|---|
| Q-1 | ux-flow ไม่มีทางเข้า S-1 จากหน้า home (water) และ dashboard ยังไม่ถูกสร้าง | `IconButton` `food_entry_button` `Icons.restaurant` tooltip 「โภชนาการ」 (เสนอ) ใน AppBar ของ water แบบ steps D-3 — ไม่เพิ่มหน้าจอ |
| Q-2 | ux-flow ไม่กำหนดหัวข้อ AppBar ของ S-1/S-2/S-3 | S-1 「โภชนาการ」, S-2 「บันทึกมื้ออาหาร」 (ยืมข้อความปุ่ม), S-3 「ตั้งค่าโปรไฟล์สุขภาพ」 — ทั้งหมดเสนอ |
| Q-3 | game-rules ไม่ระบุว่า `OVER_LIMIT_FEEDING` ค้างนานเท่าไรก่อนกลับเป็น `OVER_LIMIT` (character.md §9 ข้อ 7) | ชั่วคราว: Dev ใช้ค่าเดียวกับ `EATING_ANIMATION_DURATION` พร้อมคอมเมนต์ ASSUMPTION จนกว่า game-rules จะกำหนด (UI ไม่ตั้งตัวเลขใหม่) |
| Q-4 | บันทึกซ้อนระหว่างท่ากิน (EC-2) ต้องเริ่มนับท่ากินใหม่หรือไม่ | ท่าชั่วคราวเริ่มใหม่ตามการบันทึกล่าสุด (สอดคล้องกับ Toast แบบ queue replace) — รอ game-rules ยืนยัน |
| Q-5 | ~~ux-flow §3 ข้อ 5 ไม่ชัดว่าหลอดพลังงานอัปเดตทันทีหรือหลังท่ากิน 2 วินาที และป้าย 「อิ่มแล้ว」 ผูกกับหลอดหรือกับท่าสัตว์เลี้ยง~~ **ปิดแล้ว — DECIDED (owner ชั่วคราว, รอทีมยืนยัน) 2026-10-31 → D-4** | หลอด/ตัวเลข/สีหลอดตามข้อมูลจริงทันที; ป้าย 「อิ่มแล้ว」 ขึ้นพร้อมหลอดแดงทันทีเมื่อเกินเกณฑ์ ไม่รอท่าสัตว์เลี้ยง (เลิกแบบเดิมที่ป้ายซ่อนระหว่างกิน) — ux-flow/game-rules ยังไม่ได้อัปเดตถ้อยคำ |
| Q-6 | ux-flow บอก Toast "เช่น" 「พอเถอะน้าคนดี」 แต่ไม่มีข้อความอื่น; ค่า `high_sodium` / `high_sugar` จาก AI (AC-1) ไม่มีที่แสดงบนจอ | มี Toast เดียวคือ 「พอเถอะน้าคนดี」; component รองรับข้อความอื่นถ้ามีภายหลัง; ไม่แสดงโซเดียม/น้ำตาล |
| Q-7 | Toast ของ food ต้องยึดตำแหน่งเหนือสัตว์เลี้ยงและค้าง 5 วินาที ต่างจาก Toast อื่นของแอป (`SnackBar` ล่างจอ 2 วินาที) | ทำตาม game-rules (component ใหม่ §2.1.1) แต่ใช้สีเดียวกับ SnackBar M3 ให้โทนเดียวกัน; ข้อความยาวเกิน 1 บรรทัดจะถูกตัด ellipsis (ช่องสูง 48) |
| Q-8 | ux-flow S-1 ให้ CTA Banner มีแค่ข้อความชวน แต่ AC-8 / brief §1 บอก "พร้อมยอดรวมแคลอรี่รายวัน"; ux-flow §5 ยังระบุไฟล์ `assets/images/banner/profile_cta.png` | Banner วาดด้วย widget (ข้อความ + ยอดรวม `<total> kcal` (เสนอ) + chevron) ไม่โหลด PNG — ไฟล์ไม่มีใน repo และ `assets/images/banner/` ไม่ได้ลงทะเบียนใน pubspec; PNG ไม่รับประกันข้อความ/ยอดรวมที่เปลี่ยนได้ |
| Q-9 | ข้ามโปรไฟล์แล้วไม่มี `target_calories` → สถานะ NORMAL/OVER_LIMIT ตัดสินไม่ได้ | ใช้ท่า `foodNormal` / `foodEating` เท่านั้น ไม่เข้า OVER_LIMIT / ไม่มี Toast / ไม่มีป้าย — รอ game-rules ยืนยัน |
| Q-10 | EC-1 "เปลี่ยนเป็นฟอร์มให้กรอกแคลอรี่เอง" ไม่บอกว่าช่องเมนูยังอยู่ไหม และไม่มีข้อความอธิบายผู้ใช้ | คงช่องเมนู (ข้อความเดิม) + เพิ่มช่องแคลอรี่ใต้ช่องเมนู พร้อม helper 「ไม่สามารถประมวลผลเมนูอัตโนมัติได้ กรุณาระบุแคลอรี่เอง」 (เสนอ) สี tertiary แบบ warning ไม่บล็อก |
| Q-11 | ux-flow ไม่มีสถานะ loading ระหว่างรอ AI (สูงสุด `AI_PARSING_TIMEOUT`) | ปุ่ม loading spinner 20×20 + ช่องกรอก disabled (pattern signup Q-15) |
| Q-12 | S-2 กด 「บันทึกข้อมูล」 ขณะช่องเมนูว่าง (สถานะปกติ) ไม่มีพฤติกรรมกำหนด | ปุ่ม enabled ตาม ux-flow (ไม่มีสถานะ disabled); แนะนำให้ Design เพิ่มกติกา (เช่น disabled เมื่อว่าง) |
| Q-13 | signup S-6 เก็บอายุ/เพศ/น้ำหนัก/ส่วนสูงแล้ว (มี `UNSPECIFIED` ด้วย) แต่ food S-3 ถามซ้ำและไม่มีตัวเลือก "ไม่ระบุ"; ux-flow ไม่บอกว่า S-3 แสดงเมื่อไร (ครั้งแรกที่เข้า food?) | หน้าตา S-3 ใช้ pattern ฟอร์มเดียวกับ signup S-6 · ค่าที่ Dev เลือกไว้ในโค้ด: ใช้โปรไฟล์ signup ถ้ามี, เติมค่าเดิมลงฟอร์ม S-3, โปรไฟล์ไม่ครบ = แสดง CTA Banner — spec ไม่กำหนด flow นี้เพิ่ม (รอ Design/Product ยืนยันในเอกสาร flow) |
| Q-14 | ~~ux-flow ว่า "บล็อกและบังคับรับค่าเป็นจำนวนเต็ม" แต่ก็มีสถานะ error เมื่อกรอก 20.5 — ถ้าบล็อกที่ตัวกรองแบบ signup (`SignupWholeNumberInputFormatter`) error จะไม่มีวันขึ้น~~ **ปิดแล้ว — DECIDED (owner ชั่วคราว, รอทีมยืนยัน) 2026-10-31 → D-3** | ใช้กติกาเดียวกับ signup S-6: ช่องอายุปฏิเสธการพิมพ์จุดตั้งแต่แรก (`SignupWholeNumberInputFormatter` + `digitsOnly`), น้ำหนัก/ส่วนสูงรับทศนิยม · error อายุใช้กับค่านอกช่วง (`0`, `121`) — ตัวอย่าง "20.5" ใน ux-flow S-3 / game-rules §6 จึงไม่ปรากฏเป็น error บนจอ (เอกสารนั้นยังไม่ได้อัปเดต) |
| Q-15 | S-3 ไม่มี label กลุ่มเพศ, ไม่มีค่าเริ่มต้นเพศ, ไม่มีช่วง/ข้อความ error ของน้ำหนัก-ส่วนสูง และไม่บอกว่าปุ่มบันทึก disabled เมื่อไร | label 「เพศ」 (เสนอ), ไม่เลือกเพศไว้ก่อน, ไม่มี error น้ำหนัก/ส่วนสูง; ปุ่มบันทึก disabled จนกว่าทั้ง 4 ค่าครบและอายุถูกต้อง |
| Q-16 | ไม่มีทางกลับไปแก้โปรไฟล์ food เมื่อเคยบันทึกแล้ว (Banner แสดงเฉพาะตอนข้าม) | ไม่เพิ่มทางเข้า (ไม่อยู่ใน ux-flow) |
| Q-17 | แอปไม่มี package เครือข่าย/AI ใน `pubspec.yaml` (signup ตัดสินแล้วว่าไม่มี network) — AI Parsing ใน MVP จะทำอย่างไร | spec กำหนดหน้าตาทั้งสถานะปกติ / loading / ผิดพลาด-ออฟไลน์; วิธี trigger ให้เจ้าของ/Tech Lead ตัดสิน (ถ้าไม่มี AI จริง สถานะผิดพลาดต้อง trigger ได้สำหรับเทสต์) |
| Q-18 | ux-flow §2 (Pet Display Area "Lottie Animation"), §5, §6 · game-rules §2, §5 · requirements §7 ยังอ้าง Lottie / Sprite Sheets / `assets/images/pet/*.json` | ยึด D-1 (OQ-1 DECIDED owner ชั่วคราว) ใช้ `PetCharacter` — ให้ Design อัปเดตเอกสารเมื่อทีมยืนยัน (UI ไม่ได้แก้ docs/food/ อื่น) |
| Q-19 | `NORMAL` ชื่อ "ท่าหิว / ท่าปกติ" ครอบคลุม 0 kcal ถึงเกินเป้า 100 kcal (character.md §9 ข้อ 6) | ใช้ `foodNormal` ตลอดช่วง ถ้าต้องการ "หิว" ชัดขึ้นต้องเพิ่มสถานะใน game-rules ก่อน แล้วจึงขอท่าใหม่จาก Art |
| Q-20 | ux-flow §3 ข้อ 5 พูดถึง "หลอดพลังงาน %" แต่องค์ประกอบ S-1 แสดงเฉพาะ `[total] / [target] kcal` | ไม่แสดงข้อความ % (ตามตารางองค์ประกอบ) — หลอดสื่อสัดส่วนอยู่แล้ว |
