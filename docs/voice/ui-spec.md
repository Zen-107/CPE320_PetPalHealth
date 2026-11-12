# UI spec: เสียงพากย์น้องอ๊บ (voice)

> สถานะ: draft (2026-11-12 รอบ 1) · ผู้เขียน: UI agent · อ้างอิง: ux-flow.md, game-rules.md (บริบท: requirements.md, design-review.md (PASS), docs/_design/character.md, logs/20261112-1043_owner_voice.md)
> เอกสารนี้กำหนด "หน้าตา" และโครงที่ Dev ต้องใช้ให้ตรวจได้ — ตัวเลข กติกา และ flow ให้ยึด ux-flow.md / game-rules.md และข้อตัดสิน owner ใน §0 (**ข้อตัดสินชนะเอกสารเมื่อขัดกัน**)
> design language ยึดตาม `docs/notification-feature/ui-spec.md`, `docs/dashboard/ui-spec.md` และโค้ดจริงใน `app/lib/` — ไม่สร้างระบบดีไซน์ใหม่ · **ไม่มีสี/ฟอนต์/ระยะใหม่** (§1)
> ux-flow มี 3 หน้าจอ: S-1 Dialog ขอเปิดเสียงครั้งแรก, S-2 Dashboard (เล่นเสียง + ข้อความ), S-3 ตั้งค่าเสียง/แจ้งเตือน — ตาม V-2 **S-3 ไม่ใช่ modal ใหม่** แต่เป็นหน้าตั้งค่าแจ้งเตือนเดิม (notification S-2) ที่เพิ่มสวิตช์ 1 ตัว · spec ไม่เพิ่มหน้าจออื่น

## 0. ข้อตัดสินใจที่มีผลต่อ UI

V-1 ถึง V-10 เป็นการตัดสินใจของเจ้าของโปรเจกต์ ไม่ใช่ของ UI agent — **DECIDED (owner) 2026-11-12 — ทีมให้ owner ตัดสินไปก่อน ทีมตรวจตอนรีวิว PR** (logs/20261112-1043_owner_voice.md) — spec นี้แค่กำหนดหน้าตา/โครงให้รองรับ · เทสต์ที่อิงข้อตัดสินให้มี `DECIDED_` ในชื่อ (เช่น `DECIDED_V2_voice_switch_on_top`) · A-1 ถึง A-5 เป็นข้อตกลงระดับแอปที่มีอยู่แล้ว (ไม่ใช่ข้อตัดสินใหม่)

| # | ข้อตัดสินใจ (ที่มา) | ผลต่อ UI |
|---|---|---|
| V-1 | **ไม่ใช้ PNG ทั้ง 3 ไฟล์** (ux-flow §2, §5.1 `pet_avatar_dialog.png`, `pet_avatar_happy.png`, `icon_settings_gear.png`) · สัตว์เลี้ยงใน S-1 และบน dashboard ใช้ `PetCharacter` ด้วยท่าที่มีอยู่แล้ว · ปุ่มเฟืองใช้ `Icons.settings` ตัวเดิม (`notification_settings_entry_button`) | S-1 = `PetCharacter(pose: PetPose.dashboardCheerful)` (§2.1, §4) · dashboard = ท่าเดิมของ dashboard (§2.2) · ห้าม `Image.asset` / `AssetImage` · ไม่แก้ `pubspec.yaml` ส่วน `assets:` |
| V-2 | **ไม่สร้าง modal S-3** (ux-flow S-3: Modal, หัวข้อ 「ตั้งค่าระบบเสียงและการแจ้งเตือน」, ปุ่ม X) · ปุ่มเฟืองบน AppBar dashboard เปิดหน้าตั้งค่าแจ้งเตือนเดิม `NotificationSettingsScreen` เหมือนเดิม · เพิ่มสวิตช์ 「เปิด/ปิดเสียงพากย์น้องอ๊บ (Master Voice)」 **บนสุด** ของหน้านั้น → หน้าเดียวมีสวิตช์ 2 ตัวตามเจตนา AC-8 · เทสต์ `DECIDED_D2_*` ของ notification ต้องไม่พัง | §2.3 · AppBar title / tooltip / ปุ่มย้อนกลับเดิม (ไม่มีปุ่ม X, ไม่มีหัวข้อ modal — Q-02) |
| V-3 | **Push Notification Shortcut = สวิตช์ `notification_master_switch` เดิม** (`NotificationController.setMasterSwitch` ขอสิทธิ์ตาม AC-6/EC-9 ของ notification) · ไม่มี key `push_notification_shortcut_toggle` · **debounce 300 ms ใช้กับสวิตช์เสียงเท่านั้น** พฤติกรรม notification ไม่เปลี่ยน (game-rules §1.2, ux-flow S-3, EC-5) | §2.3 แถว 2 = widget เดิมไม่แตะ ป้ายเดิม 「เปิด/ปิดแจ้งเตือนทั้งหมด」 (Q-03) |
| V-4 | **จังหวะพูด:** ประเมินเฉพาะบน dashboard (S-2) ตอนเปิดหน้า และตอนค่าเปลี่ยนขณะหน้าเปิดอยู่ · แต่ละเรื่อง (steps / food / water) พูดเฉพาะเมื่อค่า "เข้าช่วงใหม่" ที่ต่างจากช่วงล่าสุดของเรื่องนั้นในรอบวันเดียวกัน (ช่วงที่ไม่มีบทพูดก็นับเป็นช่วง) · เพดานต่อวันเป็นผลจากกติกานี้ (แทน "ไม่จำกัด") · รอบวันของแอปเดิม (05:00) | §2.4.3 (`VoiceLogic.evaluate`) · ไม่มีการพูดบนหน้าอื่น |
| V-5 | **S-1 แสดงทับหน้า home (water)** หลัง onboarding เมื่อ `voice_permission_status` ยังไม่ตอบ · voice controller เป็น **nullable** — `null` = ไม่มี dialog / ไม่มีสวิตช์เสียง / ไม่พูด (พฤติกรรมเดิม เทสต์เดิมไม่พัง) | `PetPalApp` / `WaterHomeScreen` / `DashboardScreen` / `NotificationSettingsScreen` รับ `VoiceController? voiceController` (§2.4) |
| V-6 | **แหล่งเสียง = TTS ในเครื่องผ่าน `flutter_tts`** อ่าน Exact String ของ game-rules §1.1 คำต่อคำ · `th-TH` · pitch `1.5` · volume `0.80` (= `DEFAULT_AUDIO_VOLUME_GAIN`) · **ไม่มีไฟล์ mp3** — ชื่อ `voice_*.mp3` ใช้เป็น id ของบทพูดเท่านั้น (requirements AC-2..AC-7, EC-3, EC-4, §6, ux-flow §5.2, game-rules `AUDIO_FILE_PATH`) | `VoiceLine.id` = `'voice_steps_lazy'` ฯลฯ (§2.4.2) · `VoiceTtsEngine` (§2.4.5) |
| V-6a | **ห้ามต่อเน็ต** — engine ในเครื่องเท่านั้น ห้าม cloud TTS · เครื่องไม่มีเสียงไทย / TTS error → **ข้ามเงียบ ไม่แครช** (ใช้ EC-3 แทนกรณีไฟล์หาย) | §3 S-2 ERROR — ไม่มีฟองข้อความ ไม่มี UI ผิดพลาด (Q-11) |
| V-6b | ไม่มีโฟลเดอร์ `assets/audio/` · ไม่แก้ส่วน assets ของ pubspec | §5 |
| V-7 | `flutter_tts` pin เวอร์ชันเดียว (เริ่ม `4.2.5`; build ไม่ผ่านกับ compileSdk 36 / Flutter 3.47.6 / Dart 3.13.5 → ถอยเวอร์ชันและจด log) · **ไม่เพิ่ม `uses-permission`** · อนุญาต `<queries>` intent `android.intent.action.TTS_SERVICE` · ไม่ใช้ไมโครโฟน | §5 |
| V-8 | เสียงในแจ้งเตือน: ไม่ทำรอบนี้ (แจ้งเตือนใช้เสียงระบบตาม notification Q-09) | ไม่แตะ `NotificationDetails` |
| V-9 | **ไม่ต้องมีท่าใหม่** (ข้ามขั้น art) · dialog ใช้ท่าที่มีใน `PetPose` · บน dashboard ท่าเป็นไปตามกติกา dashboard เดิม **เสียงไม่เปลี่ยนท่า** (game-rules §2 `pet_avatar_happy.png` ทุกสถานะ) | §4 · ไม่ส่ง `cheerTrigger` เมื่อพูด |
| V-10 | คำถามที่เหลือใช้คำตอบชั่วคราวใน §7 ทุกข้อ | §7 |
| A-1 | (ระดับแอป) สัตว์เลี้ยงใช้ `PetCharacter` ตัวเดียว ไม่มี PNG / Lottie (DECIDED owner 2026-10-14) | §4 |
| A-2 | (ระดับแอป) AppBar หน้า water เต็ม 5 ปุ่ม — ไม่เพิ่มปุ่ม (7day Q-1, notification D-2) | ไม่แตะ AppBar ของ `WaterHomeScreen` |
| A-3 | (ระดับแอป) ไม่ต่อเน็ต · ข้อมูลเก็บใน `shared_preferences` · ตัดรอบ 05:00 ด้วย `WaterLogic.logicalDay` | §2.5 · logic รับ `now` จาก clock ที่ inject ได้ |
| A-4 | (ระดับแอป — notification D-9 / 7day D-5) อ่านค่าจาก controller เดิม ห้ามเก็บข้อมูลสุขภาพซ้ำ — key ของ voice เองเก็บได้ | ใช้ `DashboardController.input` (`DashboardInput`) ตัวเดียวกับคะแนน dashboard (§2.4.1) |
| A-5 | (ระดับแอป) notification D-1..D-6, Q-09, Q-28 ไม่เปลี่ยน | การ์ด S-1 ของ notification / S-2 / deep link ทำงานเหมือนเดิม |

## 1. Design tokens

ทุกสีดึงจาก `Theme.of(context).colorScheme` / `textTheme` เท่านั้น — **ห้าม hardcode hex** ในโค้ด voice (seed `Colors.lightBlue` ใน `app/lib/main.dart` → `ColorScheme.fromSeed`) · ไม่แก้ `ThemeData` · ไม่เพิ่ม font / asset · สีตัวสัตว์เลี้ยงอยู่ใน `PetColors` (`app/lib/shared/pet/pet_constants.dart`) ห้ามแก้ · **ฟีเจอร์นี้ไม่มี token สี/ตัวอักษร/ระยะ/มุมโค้งใหม่** — ค่าใหม่มีเฉพาะเวลา (§1.3 `speakTimeout`) และ storage key (§2.5)

### 1.1 สี

| Token | ค่า | ใช้ที่ไหน | ที่มา (ของเดิม) |
|---|---|---|---|
| Seed color | `Colors.lightBlue` | ทุก ColorScheme | `app/lib/main.dart` `PetPalApp.build` |
| พื้น dialog S-1 | default ของ `Dialog` M3 (`surfaceContainerHigh`) — ไม่ตั้ง `backgroundColor` | S-1 | `notification_consent_card` (`app/lib/features/notification/widgets/notification_consent_card.dart`) |
| ฉากหลังทึบ (barrier) | default ของ `showDialog` | S-1 | `showNotificationConsentCard` |
| หัวข้อ dialog | default (`onSurface`) | S-1 | `notification_consent_title_text` |
| รายละเอียด dialog | `colorScheme.onSurfaceVariant` | S-1 | `notification_consent_body_text` |
| ปุ่มเปิดเสียง (Primary) | default `FilledButton` (`primary` / `onPrimary`) | S-1 | `notification_consent_allow_button` |
| ปุ่มปิดเสียง (Secondary) | default `OutlinedButton` | S-1 | `notification_consent_deny_button` |
| ฟองบทพูด | พื้น `colorScheme.secondaryContainer` ตัวอักษร `colorScheme.onSecondaryContainer` มุม 8 — **ใช้ class `_AlertBubble` เดิม** | S-2 | `_AlertBubble` ใน `app/lib/features/dashboard/screens/dashboard_screen.dart` (`dashboard_alert_banner`) — เหตุผล: ช่องนี้คือ "ฟองพูดเหนือหัวน้องอ๊บ" อยู่แล้ว บทพูดเสียงเป็นคำพูดของตัวเดียวกัน จึงใช้สีเดียวกัน แยกด้วย key (§2.2) |
| สวิตช์เสียง | default `SwitchListTile` M3 (เปิด = `primary`) | S-3 | `notification_master_switch` (`notification_settings_screen.dart`) |
| SnackBar บันทึกไม่สำเร็จ | default `SnackBar` | S-3 ERROR | `showStepsToast` (`app/lib/features/steps/widgets/steps_toast.dart`), `water_anti_spam_toast` |

### 1.2 ตัวอักษร

ไม่มี custom font ใน `app/pubspec.yaml` → `Theme.of(context).textTheme` เท่านั้น

| ใช้กับ | style | ที่มา |
|---|---|---|
| หัวข้อ dialog S-1 | `textTheme.headlineSmall` จัดกลาง | `notification_consent_title_text` |
| รายละเอียด dialog S-1 | `textTheme.bodyMedium` + `onSurfaceVariant` จัดกลาง | `notification_consent_body_text` |
| ป้ายปุ่ม S-1 | default `FilledButton` / `OutlinedButton` (`labelLarge`) | ปุ่มเดิมทุกหน้า |
| ข้อความบทพูด S-2 | `textTheme.bodyMedium` + `onSecondaryContainer` จัดกลาง (ภายใน `_AlertBubble`) | `dashboard_alert_text` |
| ป้ายสวิตช์เสียง S-3 | default `SwitchListTile.title` (`bodyLarge`) | `notification_master_switch_label` |
| SnackBar | default | `showStepsToast` |

ทุก `Text` ของ voice **ไม่มี `maxLines` / ellipsis** (ข้อความต้องครบตรงตัว — บทเรียน food D-5 / dashboard D-16)

### 1.3 ระยะห่าง ขนาด มุมโค้ง เวลา

| Token | ค่า | ที่มา |
|---|---|---|
| Padding ใน dialog S-1 | 24 รอบด้าน | `notification_consent_card` |
| ระยะใน dialog S-1 | สัตว์เลี้ยง → 16 → หัวข้อ → 8 → รายละเอียด → 24 → ปุ่มเปิดเสียง → 8 → ปุ่มปิดเสียง | `notification_consent_card` |
| ขอบนอก/มุม dialog S-1 | default `Dialog` M3 (inset แนวนอน 40 แนวตั้ง 24, มุม 28) | `notification_consent_card` |
| ขนาดสัตว์เลี้ยง S-1 | **120 × 120** — `VoiceRules.dialogPetSize` = `NotificationRules.consentPetSize` (อ้างค่าเดิม ไม่พิมพ์ 120) | `NotificationRules.consentPetSize` |
| ปุ่ม S-1 | เต็มความกว้าง ซ้อนแนวตั้ง (`Column(crossAxisAlignment: stretch)`) | `notification_consent_card` (เหตุผลเดิม: ปุ่มไทย 2 ปุ่มแถวเดียวไม่พอที่ 232 dp) |
| ฟองบทพูด S-2 | padding แนวนอน 16 แนวตั้ง 8 มุม 8 — `_AlertBubble.padH` / `padV` | `_AlertBubble` |
| ช่องฟอง S-2 | `dashboard_alert_slot` เดิม (`FoodSharedMinHeightBox`) · ขอบล่างห่างกล่องสัตว์เลี้ยง `DashboardRules.alertAnchorOffset` (12) | dashboard ui-spec §2.1.1 / D-16 |
| ขนาดสัตว์เลี้ยง S-2 | 200 × 200 — `DashboardRules.petSize` (ไม่เปลี่ยน) | dashboard |
| Padding หน้า S-3 | 16 รอบด้าน (`ListView(padding: EdgeInsets.all(16))` เดิม) | `notification_settings_screen.dart` |
| `SwitchListTile.contentPadding` สวิตช์เสียง | `EdgeInsets.zero` | `notification_master_switch` |
| ระยะสวิตช์เสียง ↔ สวิตช์แจ้งเตือน | 0 (ListTile ติดกัน สูงขั้นต่ำ 56 ตาม M3) | default M3 — **ไม่มี Divider** |
| ไอคอนทางเข้า S-3 | `Icons.settings` 24 — `NotificationRules.entryIconSize` (เดิม) | notification §2.0 |
| SnackBar บันทึกไม่สำเร็จ | หายเองใน 2 วินาที — `VoiceRules.saveErrorToastSeconds` = `StepsRules.toastSeconds` · `persist: false` | `showStepsToast` |
| Debounce สวิตช์เสียง | 300 ms — `VoiceRules.toggleDebounce` | game-rules `TOGGLE_DEBOUNCE_MS` |
| เวลาสูงสุดต่อ 1 บทพูด | **20 วินาที — `VoiceRules.speakTimeout`** | **ใหม่** — เหตุผล: บาง TTS engine ไม่ส่ง completion → ฟองค้าง/คิวค้างตลอด · บทยาวสุด ~100 ตัวอักษรใช้ ~8–12 วินาทีที่ความเร็วปกติ เผื่อ ~2 เท่า (Q-12) |

ไม่มีสถานะ disabled ของปุ่ม/สวิตช์ (ux-flow ไม่มีพฤติกรรมรองรับ — §3)

## 2. หน้าจอ

ข้อความใน「」คัดลอกตรงตัวจาก ux-flow.md / game-rules.md — ห้ามแก้ · `"` ที่ครอบข้อความในเอกสารเป็นตัวคั่น ไม่ใช่ส่วนของข้อความ · `[ … ]` ของปุ่มใน ux-flow เป็นสัญลักษณ์ปุ่ม ไม่ใช่ส่วนของป้าย (Q-04) · ข้อความที่เอกสารไม่มีและ spec เสนอไว้ชั่วคราว ระบุว่า **(เสนอ — รอยืนยัน)**
ข้อความทุกข้อความ และตัวเลขทุกตัว (เกณฑ์ เวลา ค่า TTS) อยู่ใน `VoiceRules` (`app/lib/features/voice/voice_rules.dart`) — ห้าม hardcode ในหน้าจอ/logic/engine
ValueKey ของ widget ใหม่ใช้ prefix `voice_` ทั้งหมด

### 2.1 S-1 First Launch Permission Dialog

จุดประสงค์ (ux-flow §1): ขอความยินยอมเปิดเสียงพากย์น้องอ๊บเมื่อเข้าแอปครั้งแรกหลังผ่าน Onboarding

ไฟล์: `app/lib/features/voice/widgets/voice_permission_dialog.dart` — `Future<void> showVoicePermissionDialog(BuildContext context, VoiceController controller, {bool? animatePet})` + `class VoicePermissionDialog extends StatefulWidget` (pattern เดียวกับ `showNotificationConsentCard` / `NotificationConsentCard`)

**เงื่อนไขแสดง / ลำดับกับการ์ดแจ้งเตือน (V-5, Q-17):**
- แสดงจาก `WaterHomeScreen` (= Home) เมื่อครบทุกข้อ:
  1. `widget.voiceController != null` และ `voice.isLoaded` และ `voice.permissionStatus == VoicePermissionStatus.unanswered`
  2. ไม่มี dialog ของ voice เปิดอยู่ (flag `_voiceDialogOpen`) และ**การ์ดแจ้งเตือนไม่ได้เปิดอยู่** (`!_consentDialogOpen`)
  3. ถ้ามี `notificationController`: `notification.isLoaded` และ `notification.consentStatus != NotificationConsentStatus.unanswered` และ `!notification.isRequestingPermission`
- ผล: **การ์ดแจ้งเตือน (notification S-1) ขึ้นก่อนเสมอ** → ผู้ใช้ตอบ → (ถ้ากดอนุญาต รอกล่องขอสิทธิ์ของ OS ปิด) → dialog เสียงขึ้นต่อ · ไม่มี `notificationController` → dialog เสียงขึ้นทันทีหลังโหลด
- `WaterHomeScreen` ฟัง `voiceController` เพิ่ม (addListener ใน initState / removeListener ใน dispose แบบ `_onNotificationChanged`) และเรียก `voice.load()` ใน initState · ตรวจเงื่อนไขใน method เดียว `_onVoiceChanged()` ที่ถูกเรียกจากทั้ง listener ของ voice และ notification และหลังการ์ดแจ้งเตือนปิด (`_showConsentCard` จบ)
- เปิดด้วย `addPostFrameCallback` → `showVoicePermissionDialog(...)` · ตั้ง `_voiceDialogOpen = true` ก่อน schedule · จบแล้วตั้ง false และเรียก `_onNotificationChanged()` (ให้ deep link ที่ค้างทำงานต่อ)
- **deep link ของ notification ต้องรอ dialog เสียงปิดด้วย:** เงื่อนไข deep link ใน `_onNotificationChanged` / `_openDeepLink` เพิ่ม `&& !_voiceDialogOpen` (ไม่เช่นนั้น `popUntil(isFirst)` ปิด dialog โดยไม่มีคำตอบ)
- **บล็อกการกดทะลุ** (ux-flow "บังคับเลือกปุ่มใดปุ่มหนึ่ง"): `barrierDismissible: false` + `PopScope(canPop: false)` → ปิดได้ทางปุ่ม 2 ปุ่มเท่านั้น
- ไม่แก้ `SignupGate` / signup

**โครง:** `PopScope(canPop: false)` → `Dialog(key: Key('voice_permission_dialog'))` (default สี/มุม/inset) → `SingleChildScrollView` → `Padding(24)` → `Column(mainAxisSize: min, crossAxisAlignment: stretch)`

จากบนลงล่าง:

| # | องค์ประกอบ (ux-flow §2 S-1) | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 1 | Pet Illustration (V-1) | `Center` → `KeyedSubtree(key)` → `PetCharacter(pose: PetPose.dashboardCheerful, size: VoiceRules.dialogPetSize, animate: widget.animatePet ?? kPetAnimateByDefault, reactToTap: false, semanticLabel: VoiceRules.dialogPetSemanticLabel)` — ไม่ส่ง `cheerTrigger` | กบยิ้มร่าเริงชูแขน กระโดดเบา ๆ (§4) · `semanticLabel` = `DashboardRules.moodCheerfulLabel` 「ยิ้มร่าเริง」 (อ้างของเดิม ไม่แสดงบนจอ) | 120 × 120 | `voice_permission_pet_image` (บน `KeyedSubtree`) |
| — | `SizedBox(height: 16)` | | | | |
| 2 | Dialog Title | `Text(textAlign: center)` | 「ให้น้องอ๊บส่งเสียงทักทายและคอยเป็นกำลังใจให้คุณทุกวันไหมคะ?」 (`VoiceRules.dialogTitle`) | `headlineSmall` | `voice_permission_title_text` |
| — | `SizedBox(height: 8)` | | | | |
| 3 | Dialog Body | `Text(textAlign: center)` | 「น้องอ๊บพร้อมส่งเสียงเชยชม แซว หรือเตือนคุณตามบริบทสุขภาพ เพื่อเพิ่มความสนุกในการใช้งานแอป PetPal Health」 (`VoiceRules.dialogBody`) | `bodyMedium` + `onSurfaceVariant` | `voice_permission_body_text` |
| — | `SizedBox(height: 24)` | | | | |
| 4 | Primary Button | `FilledButton(onPressed: () => _answer(true), child: Text(...))` | 「เปิดเสียงโลด! (แนะนำ)」 (`VoiceRules.enableButtonText`) | default `FilledButton` | `voice_permission_enable_button` |
| — | `SizedBox(height: 8)` | | | | |
| 5 | Secondary Button | `OutlinedButton(onPressed: () => _answer(false), child: Text(...))` | 「ปิดเสียงไว้ก่อน」 (`VoiceRules.disableButtonText`) | default `OutlinedButton` | `voice_permission_disable_button` |

**เมื่อกด** (พฤติกรรมตาม ux-flow §2 S-1 / AC-1 / game-rules §3 — ไม่เขียนกติกาใหม่):
- `_answer(enabled)`: ถ้า `_answered` แล้ว → ออก (กันกดซ้ำ) · `_answered = true` → `Navigator.pop` dialog **ก่อน** → `controller.answerPermission(enabled: enabled)`
- `answerPermission(enabled: true)` → ในหน่วยความจำ `permissionStatus = on`, `masterVoice = true` → `notifyListeners()` → บันทึก `voice_permission_status = true`, `master_voice_toggle = true`
- `answerPermission(enabled: false)` → `off` / `false` · บันทึก `false` / `false`
- การบันทึกของ S-1 **ไม่ debounce** (กดได้ครั้งเดียว)
- ไม่พูดอะไรหลังกด (การพูดเกิดบน dashboard เท่านั้น — V-4)

**งบความสูงที่จอ 360×640 dp** (การ์ดกว้าง 280 เนื้อหา 232 — เท่าการ์ดแจ้งเตือน): textScaler 1.0 ≈ 24 + 120 + 16 + หัวข้อ ~4 บรรทัด 128 + 8 + รายละเอียด ~4 บรรทัด 80 + 24 + 40 + 8 + 40 + 24 ≈ 512 < 592 → ไม่ต้องเลื่อน · textScaler 1.5 ≈ 790 > 592 → **เลื่อนใน `SingleChildScrollView`** ไม่ overflow (ปุ่มอาจต้องเลื่อนลงจึงเห็น — Q-28)

### 2.2 S-2 Dashboard (Main Screen & Audio Trigger)

จุดประสงค์ (ux-flow §1): แสดงข้อมูลสุขภาพหลัก + เล่นเสียงพากย์พร้อมข้อความตามบริบท + ปุ่มตั้งค่ามุมขวาบน

ไฟล์เดิม: `app/lib/features/dashboard/screens/dashboard_screen.dart` — `DashboardScreen` รับพารามิเตอร์ใหม่ `VoiceController? voiceController` (null = ไม่มีการประเมิน/ไม่พูด/ไม่มีฟองบทพูด — เทสต์ dashboard เดิมไม่เปลี่ยน) · `WaterHomeScreen._openDashboard` ส่ง `widget.voiceController` ต่อ

**หน้าตาที่เปลี่ยน — เท่านี้:** layout, AppBar, คะแนน, แถบ, สัตว์เลี้ยง, ระยะ ของ dashboard **คงเดิมทุกอย่าง** (dashboard ui-spec §2.1) — เปลี่ยนเฉพาะเนื้อหาในช่อง `dashboard_alert_slot` ขณะพูด และความสูงขั้นต่ำของช่อง

| # | องค์ประกอบ (ux-flow §2 S-2) | การแสดงผล | ValueKey |
|---|---|---|---|
| 0 | Settings Icon Button (V-1, V-2) | ปุ่มเดิม `IconButton(Icons.settings 24, tooltip 「การแจ้งเตือนของน้องอ๊บ」)` **ไม่เปลี่ยน** · กดแล้ว push `NotificationSettingsScreen(controller: notification, voiceController: widget.voiceController)` | `notification_settings_entry_button` (เดิม) |
| 1 | Pet Character Display — ภาพ (V-9) | `PetCharacter` เดิม `DashboardLogic.poseFor(mood)` 200 × 200 — **ไม่เปลี่ยนท่าเมื่อพูด** ไม่ส่ง `cheerTrigger` | `dashboard_pet_image_<mood>` (เดิม) |
| 2 | Pet Character Display — กล่องข้อความพูด (Q-06) | **ในช่อง `dashboard_alert_slot` เดิม (เหนือหัวน้องอ๊บ 12 dp):** ขณะ `voice.currentLine != null` แสดง `_AlertBubble(key: Key('voice_speech_bubble'), textKey: Key('voice_speech_text'), message: voice.currentLine!.text)` **แทน** `dashboard_alert_banner` · พูดจบ → กลับไปแสดง `dashboard_alert_banner` ของ `_controller.currentAlert` ปัจจุบัน (หรือว่างถ้าคิว alert ว่าง) | `voice_speech_bubble` (บน `Container` ของ `_AlertBubble`), `voice_speech_text` (บน `Text`) |
| 3 | Steps / Food / Water Activity Trigger | ไม่มี widget — `VoiceController.evaluate(DashboardInput)` (§2.4.3) | — |

รายละเอียดช่อง (#2):
- ในหนึ่งเฟรมมีฟองได้ **ฟองเดียว**: `voice_speech_bubble` **หรือ** `dashboard_alert_banner` ไม่มีทั้งสอง · `find.text(<บทพูด>)` เจอ 1 ตัวขณะพูด 0 ตัวเมื่อพูดจบ
- Timer หมุนข้อความ alert 5 วินาทีของ `DashboardController` ทำงานต่อเบื้องหลังตามปกติ (ไม่หยุด ไม่รีเซ็ต) — ฟองบทพูดแค่บังไว้
- body ของ `Scaffold` ใช้ `ListenableBuilder(listenable: voice == null ? _controller : Listenable.merge([_controller, voice]), ...)`
- **ความสูงขั้นต่ำของช่อง (Q-07):** `_alertSlotMinHeightFor` เดิมวัดจากข้อความ alert P1 · เมื่อ `voice != null && voice.masterVoice` ให้วัด **ค่ามากสุดของ P1 กับบทพูดทั้ง 6 (`VoiceLine.values`)** ด้วย TextPainter style/textScaler/locale เดียวกัน → ช่องสูงเท่าบทพูดยาวสุดเสมอขณะเปิดเสียง ฟองบทพูดขึ้น/หายไม่ทำให้สัตว์เลี้ยงและแถบกระโดด · ปิดเสียง = วัด P1 อย่างเดิม · ห้ามมีข้อความบทพูดซ่อนอยู่ใน tree (วัดด้วย TextPainter เท่านั้น — บทเรียน dashboard D-16)
- งบความสูงที่ 360×640: ช่องโตจาก ~1 บรรทัด P1 เป็น ~3 บรรทัด (1.0, ≈ 76 dp) / ~5 บรรทัด (1.5, ≈ 166 dp) → หน้า dashboard เป็น `SingleChildScrollView` อยู่แล้ว **ไม่ overflow** (เลื่อนได้)
- ไม่มี `Semantics(liveRegion: true)` บนฟองบทพูด (กันโปรแกรมอ่านจออ่านทับเสียง TTS — Q-32)

**การประเมิน/พูด (เรียกจาก dashboard):**
- `initState`: ถ้ามี voice → `_controller.addListener(_evaluateVoice)` และเรียก `_evaluateVoice()` หลังเฟรมแรก
- `_evaluateVoice()`: ถ้า `_controller.isLoaded` → `voice.evaluate(_controller.input)` (เรียกซ้ำได้ — ช่วงเดิมไม่พูดซ้ำ จึงไม่เป็นไรที่ `DashboardController` notify ทุก 5 วินาทีจาก Timer alert)
- `dispose` → `voice.stopAndClear()` แล้ว removeListener (Q-13)
- `didChangeAppLifecycleState`: `paused` / `inactive` / `hidden` → `voice.stopAndClear()` · `resumed` → เดิม (`refreshDay`) แล้ว `_evaluateVoice()` (Q-13)
- เปิด S-3 (push หน้าตั้งค่า) **ไม่หยุด** บทที่กำลังพูด (dashboard ยัง mounted อยู่ใต้หน้าตั้งค่า)

### 2.3 S-3 Voice & Notification Settings (= หน้าตั้งค่าแจ้งเตือนเดิม + สวิตช์เสียง — V-2)

จุดประสงค์ (ux-flow §1): ตั้งค่า Master Voice และ Push Notification Shortcut ในที่เดียว (AC-8)

ไฟล์เดิม: `app/lib/features/notification/screens/notification_settings_screen.dart` — `NotificationSettingsScreen({required NotificationController controller, VoiceController? voiceController})` · `voiceController == null` = หน้าเดิมทุกพิกเซล (สวิตช์ 1 อัน — เทสต์ `UX_S2_header_and_DECIDED_Q03_switch_label` ที่ `find.byType(Switch), findsOneWidget` ยังผ่าน)

โครง: เดิม `Scaffold` → `AppBar(title: Text(NotificationRules.settingsTitle, key: notification_settings_header_text))` (ปุ่มย้อนกลับอัตโนมัติ แทนปุ่ม X ของ ux-flow — Q-02) → body `ListenableBuilder(listenable: voice == null ? controller : Listenable.merge([controller, voice]))` → ถ้า `!controller.isLoaded || (voice != null && !voice.isLoaded)` = `Center(CircularProgressIndicator())` → `SafeArea` → `ListView(padding: EdgeInsets.all(16))` → `Builder` ครอบ (ใช้ context ของ Scaffold สำหรับ SnackBar)

| # | องค์ประกอบ (ux-flow §2 S-3) | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 0 | Modal Title | **ไม่มี** — ใช้ AppBar title เดิม 「การแจ้งเตือนของน้องอ๊บ」 (V-2, Q-02) | — | AppBar default | `notification_settings_header_text` (เดิม) |
| 1 | Master Voice Toggle — **เฉพาะเมื่อ `voiceController != null`, บนสุด** | `SwitchListTile(key, value: voice.masterVoice, onChanged: voice.setMasterVoice, contentPadding: EdgeInsets.zero, title: Text(...))` | ป้าย 「เปิด/ปิดเสียงพากย์น้องอ๊บ (Master Voice)」 (`VoiceRules.masterVoiceSwitchLabel`) · ON/OFF ตาม `master_voice_toggle` | default `SwitchListTile` | `voice_master_switch` (บน `SwitchListTile`), `voice_master_switch_label` (บน `Text`) |
| 2 | Push Notification Shortcut Toggle (V-3) | `SwitchListTile` เดิม **ไม่แตะ** (ไม่มี debounce, ขอสิทธิ์ตาม notification) | ป้ายเดิม 「เปิด/ปิดแจ้งเตือนทั้งหมด」 (`NotificationRules.masterSwitchLabel` — Q-03) | เดิม | `notification_master_switch`, `notification_master_switch_label` (เดิม) |
| 3 | banner สิทธิ์ถูกปิด (ของ notification) | เดิม — `SizedBox(8)` + `notification_permission_denied_banner` เฉพาะ DENIED | เดิม | เดิม | เดิม |
| 4 | Close Button | **ไม่มี** — ปุ่มย้อนกลับของ AppBar / ปุ่ม back ของระบบ กลับ dashboard (Q-02) | — | — | — |

**สวิตช์เสียง — debounce 300 ms (EC-5, Q-14):**
- `setMasterVoice(v)`: ถ้า `v == masterVoice` → ออก · ในหน่วยความจำ `masterVoice = v` → `notifyListeners()` **ทันที** (สวิตช์ขยับทุกครั้งที่กด) · ถ้า `v == false` → `stopAndClear()` ทันที (game-rules §1.1 "การล้างคิวเมื่อปิดเสียง")
- จากนั้นยกเลิก Timer debounce เดิม แล้วตั้งใหม่ `VoiceRules.toggleDebounce` (300 ms) · ครบเวลาโดยไม่มีการกดเพิ่ม → `repository.saveMasterVoice(masterVoice)` **ครั้งเดียว** ด้วยค่าล่าสุด · ถ้าค่าล่าสุดเท่ากับค่าที่บันทึกไว้แล้ว (`_committedMaster`) → ไม่บันทึก
- ผล: กด ON→OFF→ON→OFF ภายใน 300 ms → สวิตช์แสดง OFF, บันทึก 1 ครั้งเป็น `false` (หรือ 0 ครั้งถ้าค่าเริ่มต้นเป็น `false` อยู่แล้ว)
- ออกจากหน้า/ dispose ระหว่างรอ debounce → **บันทึกค่าค้างทันที** (flush) ไม่ทิ้ง (`VoiceController.dispose` / `flushPendingSave()`) — ไม่เช่นนั้นกดแล้วกลับทันทีค่าหาย
- ไม่มีสถานะ disabled ระหว่างรอ debounce

**สวิตช์เสียง — บันทึกไม่สำเร็จ (ux-flow §4 S-3 ERROR):** `saveMasterVoice` throw → `masterVoice = _committedMaster` (ค่าก่อนชุดการกดนั้น) → `saveFailureCount++` → `notifyListeners()` · หน้าตั้งค่าฟัง `saveFailureCount` ที่เปลี่ยน (เก็บค่าเห็นล่าสุดใน State — แปลงหน้าเป็น `StatefulWidget`) แล้วเรียก SnackBar:

```dart
// pattern เดียวกับ showStepsToast
messenger.hideCurrentSnackBar();
messenger.showSnackBar(SnackBar(
  key: const ValueKey('voice_save_error_toast'),
  content: const Text(VoiceRules.saveErrorText),
  duration: const Duration(seconds: VoiceRules.saveErrorToastSeconds), // 2
  persist: false,
));
```

- `VoiceRules.saveErrorText` = 「ไม่สามารถบันทึกการตั้งค่าเสียงได้ กรุณาลองใหม่อีกครั้ง」 **(เสนอ — รอยืนยัน, Q-15** — ux-flow บอกแค่ "แจ้งเตือนให้ลองใหม่อีกครั้ง" · รูปประโยคตาม `StepsRules.goalErrorMessage`)
- สวิตช์ notification บันทึกไม่สำเร็จ → พฤติกรรมเดิมของ notification (คงค่าในหน่วยความจำ ไม่มี UI — notification Q-24) ไม่เปลี่ยน (V-3)

**งบที่ 360×640:** AppBar + 16 + สวิตช์เสียง ~56 (1.5: ~96 ป้าย 2–3 บรรทัด) + สวิตช์แจ้งเตือน ~56 (1.5: ~72) + banner (ถ้ามี) 8 + ~76 (1.5: ~166) ≈ 290 (1.5: ≈ 430) → ไม่ล้น · `ListView` เลื่อนได้เสมอ

### 2.4 โครงชั้นโค้ดที่แนะนำ (สำหรับ Dev / QA)

โฟลเดอร์ใหม่ `app/lib/features/voice/` (pattern เดียวกับ notification):

| ไฟล์ | ชั้น | เนื้อหา |
|---|---|---|
| `voice_rules.dart` | ค่าคงที่ | `VoiceRules` — ค่า §2.4.2 + ข้อความ §2.1–2.3 + token §1.3 · คอมเมนต์ `// DECIDED (owner 2026-11-12, V-x)` / `// ASSUMPTION: voice ui-spec Q-xx` |
| `voice_models.dart` | model (immutable) | `enum VoicePermissionStatus {on, off, unanswered}` · `enum VoiceTopic {water, steps, food}` (**ลำดับ enum = ลำดับเข้าคิว** — Q-10) · `enum VoiceLine` (§2.4.2) · `VoiceDayBands {DateTime day; Map<VoiceTopic, String> bands}` (+ `toJsonString` / `fromJsonString` — อ่านไม่ได้ = null) · `VoiceState {permissionStatus, masterVoice, dayBands}` + `VoiceState.initial` (`unanswered`, `false`, `null`) |
| `voice_logic.dart` | **logic pure** (ไม่ import Flutter widget / plugin / shared_preferences) | `lineForWater(int cups)`, `lineForSteps(int steps, int goal)`, `lineForFood(bool isFoodOverLimit)` → `VoiceLine?` (null = ช่วงไม่มีบทพูด) · `bandCode(VoiceLine?)` · `evaluate({required DashboardInput input, required VoiceDayBands? previous, required DateTime now}) → VoiceEvaluation {VoiceDayBands bands; List<VoiceLine> lines}` (§2.4.3) — รับ `now` เป็นพารามิเตอร์ |
| `voice_repository.dart` | storage | `VoiceStorageKeys` (§2.5) · `abstract VoiceRepository { Future<VoiceState> load(); Future<void> savePermission({required bool enabled}); Future<void> saveMasterVoice(bool on); Future<void> saveDayBands(VoiceDayBands bands); }` (throw ได้) · `InMemoryVoiceRepository` (เปิด `state` + ตัวนับการ save ให้เทสต์) · `SharedPrefsVoiceRepository` (อ่านทีละคีย์ ค่าผิดชนิด = ไม่มีคีย์ แบบ `SharedPrefsNotificationRepository`) |
| `voice_tts_engine.dart` | **abstraction (fake ได้)** | `VoiceTtsEngine` + `NoopVoiceTtsEngine` (§2.4.5) |
| `voice_flutter_tts_engine.dart` | ตัวจริง (plugin) | `FlutterTtsVoiceEngine implements VoiceTtsEngine` — `flutter_tts` (§2.4.5) · `static bool get isSupportedPlatform` (Android / iOS ตาม `defaultTargetPlatform` แบบ `LocalNotificationScheduler.isSupportedPlatform`) |
| `voice_controller.dart` | controller | `VoiceController extends ChangeNotifier` (§2.4.4) |
| `widgets/voice_permission_dialog.dart` | UI | S-1 (§2.1) |

ไฟล์เดิมที่ต้องแก้ (เท่านี้): `app/lib/main.dart` (สร้าง `VoiceController` + engine, ส่งเข้า `PetPalApp`), `water_home_screen.dart` (พารามิเตอร์ `voiceController`, `voice.load()`, เปิด S-1, guard deep link, ส่งต่อให้ dashboard), `dashboard_screen.dart` (พารามิเตอร์, ประเมิน/หยุด, ฟองบทพูด, min-height, ส่งต่อให้หน้าตั้งค่า), `notification_settings_screen.dart` (พารามิเตอร์ + สวิตช์เสียง + SnackBar — เป็น `StatefulWidget`), `app/pubspec.yaml` (`flutter_tts` เท่านั้น), `app/android/app/src/main/AndroidManifest.xml` (`<queries>` เท่านั้น — §5) · `PetPalApp` รับ `VoiceController? voiceController` (null = พฤติกรรมเดิม)

#### 2.4.1 ข้อมูลที่อ่าน (A-4 — อ่านอย่างเดียว ไม่เก็บซ้ำ)

`VoiceController.evaluate` รับ `DashboardInput` จาก `DashboardController.input` (ค่าชุดเดียวกับที่ dashboard ใช้คิดคะแนน)

| ค่าใน game-rules | แหล่งในโค้ด | หมายเหตุ |
|---|---|---|
| `steps` (%) | `DashboardInput.steps` / `DashboardInput.stepsGoal` (= `StepsController.steps` / `activeGoal`) | เทียบแบบจำนวนเต็ม §2.4.3 |
| `food` เกิน `> 100 kcal` | `DashboardInput.isFoodOverLimit` (= `FoodController.isOverLimit` = `total > target + FoodRules.overLimitThreshold`) | ตัวเดียวกับหลอดแดง / alert P1 · ไม่มีเป้า → `false` (Q-19) |
| `water` (แก้ว) | `DashboardInput.cups` (= `WaterController.cups`) | |
| รอบวัน | `WaterLogic.logicalDay(clock())` | 05:00 (A-3) |

#### 2.4.2 ค่าคงที่ (`VoiceRules` — ชื่อจาก game-rules §1 แบบ lowerCamel)

| game-rules | `VoiceRules.` | ค่า |
|---|---|---|
| `VOICE_PERMISSION_STATUS` / `MASTER_VOICE_TOGGLE` | — (เป็น storage §2.5) | — |
| `PUSH_NOTIFICATION_SHORTCUT_TOGGLE` | **ไม่มี** (V-3) | ใช้ `notification_master_switch` |
| `AUDIO_FILE_PATH` | **ไม่มี** (V-6, V-6b) | — |
| `STEPS_LAZY_THRESHOLD` | `stepsLazyBelowPercent` | `35` (ไม่รวมขอบ: `< 35`) |
| `STEPS_ENCOURAGING_MIN` | `stepsEncouragingMinPercent` | `70` (รวมขอบ) |
| `STEPS_ENCOURAGING_MAX` | `stepsEncouragingMaxPercent` | `99.99` — เอกสารเท่านั้น logic ใช้ `< stepsSuccessMinPercent` (ครอบคลุม 99.99x) |
| `STEPS_SUCCESS_THRESHOLD` | `stepsSuccessMinPercent` | `100` (รวมขอบ) |
| `FOOD_OVEREATING_THRESHOLD` | `foodOvereatingThresholdKcal` | `= FoodRules.overLimitThreshold` (100 — ไม่พิมพ์ซ้ำ) · logic ใช้ `isFoodOverLimit` |
| `WATER_LOW_THRESHOLD` | `waterLowBelowCups` | `3` (ไม่รวมขอบ: `< 3`) |
| `WATER_SUCCESS_THRESHOLD` | `waterSuccessMinCups` | `=> DashboardRules.waterTargetCups` (8 — แบบ notification D-11) |
| `TOGGLE_DEBOUNCE_MS` | `toggleDebounce` | `Duration(milliseconds: 300)` |
| `DEFAULT_AUDIO_VOLUME_GAIN` | `defaultAudioVolumeGain` | `0.80` (V-6) |
| — (V-6) | `ttsLanguage` | `'th-TH'` |
| — (V-6) | `ttsPitch` | `1.5` |
| — (ใหม่ §1.3) | `speakTimeout` | `Duration(seconds: 20)` |
| — (§1.3) | `dialogPetSize` | `= NotificationRules.consentPetSize` (120) |
| — (§2.1) | `dialogPetSemanticLabel` | `= DashboardRules.moodCheerfulLabel` |
| — (§1.3) | `saveErrorToastSeconds` | `= StepsRules.toastSeconds` (2) |

ข้อความ S-1 / S-3: `dialogTitle`, `dialogBody`, `enableButtonText`, `disableButtonText`, `masterVoiceSwitchLabel`, `saveErrorText` (§2.1, §2.3)

**`enum VoiceLine`** (`voice_models.dart`) — `id` = ชื่อไฟล์ใน game-rules ไม่มี `.mp3` (V-6) · `text` อ่านจาก `VoiceRules.<…>Text` · ข้อความตรงตัว game-rules §1.1 (ไม่รวม `"`):

| enum | `id` | `topic` | ข้อความ (`VoiceRules.<…>Text`) | AC |
|---|---|---|---|---|
| `stepsLazy` | `voice_steps_lazy` | `steps` | 「แหม... นอนเก่งขนาดนี้ นึกว่าจำศีลอยู่ซะอีก ลุกขึ้นมาขยับขาหน่อยเร้ว เดี๋ยวร่างจะติดโซฟาเอานะยูว์」 (`stepsLazyText`) | AC-2 |
| `stepsEncouraging` | `voice_steps_encouraging` | `steps` | 「ฮั่นแน่! อีกนิดเดียวก็จะครบเป้าหมายแล้วนะเนี่ย ขาเริ่มสั่นยังคะคนดี ฮึบอีกนิด เดี๋ยวมีรางวัลให้!」 (`stepsEncouragingText`) | AC-3 |
| `stepsSuccess` | `voice_steps_success` | `steps` | 「โอโห้! วันนี้เดินเยอะจนนับขาแทบไม่ทัน เก่งมากค่ะคนดี ขาไม่พังใช่ไหมเนี่ย วันนี้พักผ่อนตามสบายเลยนะ!」 (`stepsSuccessText`) | AC-4 |
| `foodOvereating` | `voice_food_overeating` | `food` | 「พุงจะแตกตายอยู่แล้วนะแม่คุณ! พอเถอะน้าคนดี เดี๋ยวพรุ่งนี้ค่อยลุยใหม่ (แต่ตอนนี้อิ่มแปล้เลยสิเนี่ย)」 (`foodOvereatingText`) | AC-5 |
| `waterLow` | `voice_water_low` | `water` | 「คอแห้งเป็นผงละเนี่ย ดื่มน้ำหน่อยเร้ว เดี๋ยวหน้าเหี่ยวไม่รู้ด้วยนะ พี่อ๊บเป็นห่วงนะเนี่ย」 (`waterLowText`) | AC-6 |
| `waterSuccess` | `voice_water_success` | `water` | 「ดื่มน้ำเก่งมาก! ผิวพรรณเปล่งปลั่งออร่าจับเลยแบบนี้ เอาใจไปเลยสิคะคนดี!」 (`waterSuccessText`) | AC-7 |

ข้อความเดียวกันใช้ทั้งฟองบนจอและส่งให้ TTS (`engine.speak(line.text)`) — ห้ามมีข้อความอีกชุดสำหรับเสียง

#### 2.4.3 การประเมิน (pure) — `VoiceLogic.evaluate` (V-4)

ช่วงของแต่ละเรื่อง (ช่วงที่ไม่มีบทพูด = `null`, code `'NONE'` — แต่ละเรื่องมีช่วงไม่มีบทพูดช่วงเดียว จึงไม่กำกวม):

| เรื่อง | ช่วง → `VoiceLine?` | การเทียบ (จำนวนเต็ม เลี่ยงทศนิยม) |
|---|---|---|
| water | `cups < 3` → `waterLow` · `3..7` → null · `cups >= 8` → `waterSuccess` | `cups < waterLowBelowCups` / `cups >= waterSuccessMinCups` |
| steps | `< 35%` → `stepsLazy` · `35%..<70%` → null · `70%..<100%` → `stepsEncouraging` · `>= 100%` → `stepsSuccess` | `goal <= 0 \|\| steps <= 0` → ถือเป็น 0% (= `StepsLogic.percentGoal` — Q-20) · ไม่เช่นนั้น `steps*100 < goal*35` / `steps*100 >= goal*100` / `steps*100 >= goal*70` |
| food | `isFoodOverLimit` → `foodOvereating` · ไม่ใช่ → null | — |

```
today    = WaterLogic.logicalDay(now)
prev     = previous ถ้า previous.day == today ไม่เช่นนั้น ว่าง          // วันใหม่ (05:00) = เริ่มนับใหม่
lines    = []
bands    = สำเนาของ prev
for topic in VoiceTopic.values (water → steps → food):               // Q-10
  line = lineFor(topic, input)
  code = line?.id ?? 'NONE'
  if prev ไม่มี topic นี้ || prev[topic] != code:
    bands[topic] = code
    if line != null: lines.add(line)                                // ช่วงไม่มีบทพูด: บันทึกช่วง ไม่พูด
return VoiceEvaluation(bands: VoiceDayBands(today, bands), lines: lines)
```

- controller เป็นคนตัดสินว่าจะ "พูด" `lines` หรือไม่ (`masterVoice`) — **ช่วงถูกบันทึกเสมอแม้ปิดเสียง** (Q-08) → เปิดเสียงทีหลังไม่มีบทค้างพูดย้อน
- `bands` เปลี่ยน → `repository.saveDayBands` (บันทึกไม่สำเร็จ = คงในหน่วยความจำ ไม่มี UI — Q-09)

**กรณีทดสอบขั้นต่ำ (logic + controller)** — clock เดียวกันทุก controller · เป้าก้าว 10,000 เว้นแต่ระบุ

| # | สถานการณ์ | ผลที่คาดหวัง | อ้างถึง |
|---|---|---|---|
| VT-1 | steps 3,499 / 3,500 / 6,999 / 7,000 / 9,999 / 10,000 / 12,500 (ประเมินครั้งแรกของวันทุกครั้ง) | `stepsLazy` / ไม่มี / ไม่มี / `stepsEncouraging` / `stepsEncouraging` / `stepsSuccess` / `stepsSuccess` | AC-2..AC-4, game-rules §3 |
| VT-2 | food: total = target + 100 / target + 101 / ไม่มีเป้า total 5,000 | ไม่มี / `foodOvereating` / ไม่มี | AC-5, Q-19 |
| VT-3 | water 0, 2 / 3, 7 / 8, 12 | `waterLow` / ไม่มี / `waterSuccess` | AC-6, AC-7 |
| VT-4 | ประเมินซ้ำด้วยค่าเดิมในวันเดียวกัน (เช่นเปิด dashboard 2 ครั้ง / Timer alert notify) | ครั้งที่ 2 `lines` ว่าง | V-4 |
| VT-5 | water 2 (พูด `waterLow`) → 5 → 2 ในวันเดียวกัน | ครั้งที่ 2 ไม่มีบท (บันทึก `NONE`) · ครั้งที่ 3 `waterLow` อีกครั้ง | V-4 "ช่วงที่ไม่มีบทพูดก็นับเป็นช่วง" |
| VT-6 | พูด `waterLow` วันนี้ แล้ว clock ข้าม 05:00 ค่าเดิม | วันใหม่ `waterLow` อีกครั้ง | V-4, A-3 |
| VT-7 | ปิดแอป/สร้าง controller ใหม่ด้วย repository เดิม วันเดียวกัน ค่าเดิม | ไม่พูดซ้ำ (อ่าน `voice_day_bands`) | V-4, Q-09 |
| VT-8 | เปิด dashboard ครั้งแรกของวัน: water 8, steps 10,000, food ไม่เกิน | คิว `[waterSuccess, stepsSuccess]` · `speak` ครั้งที่ 2 เริ่มหลังครั้งที่ 1 จบเท่านั้น · ฟองแสดงบท water แล้วเปลี่ยนเป็นบท steps ทันทีที่บทแรกจบ | EC-2, game-rules §3 แถวสุดท้าย, Q-10 |
| VT-9 | `masterVoice == false` + ค่าเข้าเกณฑ์ | `engine.speak` ไม่ถูกเรียก ไม่มี `voice_speech_bubble` · ช่วงถูกบันทึก · เปิดเสียงแล้วกลับ dashboard ค่าเดิม → ยังไม่พูด | AC-2..7, Q-08 |
| VT-10 | กำลังพูดบทที่ 1 มีบทที่ 2 ในคิว แล้วปิดสวิตช์เสียง | `engine.stop()` ถูกเรียก · คิวว่าง · `currentLine == null` · ฟองหาย · ไม่พูดบทที่ 2 | game-rules §1.1 การล้างคิว |
| VT-11 | `engine.prepare()` คืน `false` (ไม่มี th-TH) | ไม่เรียก `speak` · ไม่มีฟอง · ไม่ throw · ช่วงยังถูกบันทึก | V-6a, Q-11 |
| VT-12 | `engine.speak` throw ในบทที่ 1 | ข้ามไปบทที่ 2 ทันที ไม่ throw ออกนอก controller | EC-3 (V-6a) |
| VT-13 | `engine.speak` ไม่ complete | ครบ 20 วินาที (`pump(VoiceRules.speakTimeout)`) → ฟองหาย → บทถัดไปเริ่ม | Q-12 |
| VT-14 | กำลังพูดแล้ว pop dashboard / ส่ง `AppLifecycleState.paused` | `engine.stop()` ถูกเรียก คิวว่าง | Q-13 |
| VT-15 | กดสวิตช์เสียง 4 ครั้งภายใน 100 ms (เริ่ม ON) | สวิตช์ `value` เปลี่ยนทุกครั้ง จบที่ ON · ก่อน 300 ms `saveMasterVoice` 0 ครั้ง · หลัง `pump(300ms)` 0 ครั้ง (ค่าเท่าเดิม) · กด 3 ครั้ง (จบ OFF) → 1 ครั้งค่า `false` | EC-5, game-rules §3 |
| VT-16 | `saveMasterVoice` throw | สวิตช์กลับค่าเดิม · มี `voice_save_error_toast` ข้อความ `VoiceRules.saveErrorText` · หายเองใน 2 วินาที | ux-flow §4 S-3 ERROR |

#### 2.4.4 `VoiceController` (ChangeNotifier)

constructor: `VoiceController({required VoiceRepository repository, required VoiceTtsEngine engine, DateTime Function()? clock /* default DateTime.now — เทสต์ส่ง clock ตัวเดียวกับ water/steps/food */, VoiceTimerFactory? timerFactory /* debounce — default Timer */})`

| สมาชิก | ความหมาย |
|---|---|
| `bool isLoaded` | โหลดจาก repository แล้ว |
| `VoicePermissionStatus permissionStatus` | `voice_permission_status` |
| `bool masterVoice` | ค่าที่สวิตช์แสดง (ในหน่วยความจำ — อัปเดตทันทีเมื่อกด) |
| `VoiceLine? currentLine` | บทที่กำลังพูด → ฟอง S-2 (null = ไม่มีฟอง) |
| `List<VoiceLine> queue` | บทที่รอ (ไม่รวม `currentLine`) — อ่านอย่างเดียว ให้เทสต์ |
| `int saveFailureCount` | เพิ่มเมื่อบันทึกสวิตช์เสียงไม่สำเร็จ → SnackBar (§2.3) |
| `Future<void> load()` | เรียกซ้ำได้ โหลดครั้งเดียว · อ่านไม่ได้ (throw) → `unanswered` / `false` / bands ว่าง (ux-flow §4 S-1 ERROR → dialog แสดง) |
| `Future<void> answerPermission({required bool enabled})` | §2.1 · บันทึกไม่สำเร็จ → คงค่าในหน่วยความจำ ไม่มี UI (Q-16) |
| `void setMasterVoice(bool on)` | §2.3 debounce |
| `void evaluate(DashboardInput input)` | `VoiceLogic.evaluate` → บันทึก bands → ถ้า `masterVoice` เพิ่ม `lines` ต่อท้ายคิว (FIFO) → เริ่มเล่นถ้าว่าง · ไม่ทำอะไรถ้า `!isLoaded` |
| `Future<void> stopAndClear()` | ล้างคิว, `currentLine = null`, `engine.stop()` (error กลืนเงียบ), notify |
| `Future<void> flushPendingSave()` | บันทึกค่าที่ค้าง debounce ทันที |
| `dispose()` | cancel Timer debounce (flush ก่อน), `engine.stop()` |

ลูปเล่น (ทีละบท — EC-2 No Audio Overlap, Cooldown 0 ms):
```
_playing = true
if (_ready == null) _ready = await engine.prepare().catchError(false)     // ครั้งเดียวต่อ process
while queue ไม่ว่าง && masterVoice:
  if !_ready: queue.clear(); break                                       // ไม่มีเสียงไทย → ข้ามเงียบ ไม่มีฟอง (Q-11)
  currentLine = queue.removeFirst(); notify()
  try: await engine.speak(currentLine.text).timeout(VoiceRules.speakTimeout)
  catch: (กลืน — EC-3 / V-6a; timeout → engine.stop())
  if currentLine ยังเป็นบทนี้: currentLine = null; notify()
_playing = false
```
- `stopAndClear()` ระหว่าง `await speak` → `engine.stop()` ทำให้ speak คืนค่า → ลูปเห็นคิวว่างแล้วจบ · ต้องใช้ "รุ่น" (generation counter) กันลูปเก่าเคลียร์ `currentLine` ของบทใหม่

#### 2.4.5 TTS engine — interface ที่ fake ได้ในเทสต์

`flutter_tts` ไม่ทำงานใน `flutter test` (ไม่มี platform channel) → controller รู้จักแค่ interface นี้ · **`FlutterTtsVoiceEngine` ห้ามถูกสร้างในเทสต์**

```dart
// voice_tts_engine.dart — ตัวอย่างรูปแบบ ไม่ใช่โค้ดสำเร็จ
abstract interface class VoiceTtsEngine {
  /// ตั้งภาษา/pitch/volume — คืน false ถ้าเครื่องไม่มีเสียง th-TH หรือ engine ใช้ไม่ได้ (V-6a)
  Future<bool> prepare();

  /// พูดข้อความ — Future จบเมื่อพูดเสร็จ (หรือถูก stop) · throw เมื่อ engine error
  Future<void> speak(String text);

  /// หยุดเสียงที่กำลังพูดทันที
  Future<void> stop();
}

class NoopVoiceTtsEngine implements VoiceTtsEngine {
  const NoopVoiceTtsEngine();
  @override Future<bool> prepare() async => false;   // ไม่มีเสียง → ไม่มีฟอง
  @override Future<void> speak(String text) async {}
  @override Future<void> stop() async {}
}
```

```dart
// voice_flutter_tts_engine.dart — Android / iOS เท่านั้น
class FlutterTtsVoiceEngine implements VoiceTtsEngine {
  final FlutterTts _tts = FlutterTts();
  static bool get isSupportedPlatform => !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
       defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Future<bool> prepare() async {
    try {
      final available = await _tts.isLanguageAvailable(VoiceRules.ttsLanguage);
      if (available != true) return false;
      await _tts.setLanguage(VoiceRules.ttsLanguage);           // 'th-TH'
      await _tts.setPitch(VoiceRules.ttsPitch);                 // 1.5
      await _tts.setVolume(VoiceRules.defaultAudioVolumeGain);  // 0.80
      await _tts.awaitSpeakCompletion(true);                    // speak() รอจนพูดจบ
      return true;
    } catch (_) {
      return false;
    }
  }

  @override Future<void> speak(String text) async => _tts.speak(text);
  @override Future<void> stop() async => _tts.stop();
}
// ไม่เรียก setSpeechRate (ใช้ค่าเครื่อง — Q-21) · ไม่ใช้ engine/voice ที่ต้องดาวน์โหลดหรือ network (V-6a)
```

**Fake ในเทสต์** (`app/test/voice/fake_voice_tts_engine.dart` — เสนอ):
- `bool available` (ผลของ `prepare`, default true) · `List<String> spoken` · `int stopCount` · `bool throwOnSpeak`
- `bool autoComplete` (default true = `speak` จบทันทีแบบ microtask) · false = `speak` คืน Future จาก `Completer` ที่เทสต์สั่ง `completeCurrent()` เอง (ใช้ตรวจฟองขณะพูด / FIFO / stop) · `stop()` ต้อง complete Completer ที่ค้าง
- clock: ฟังก์ชันเดียวกันส่งให้ `WaterController(clock:)`, `StepsController(clock:)`, `FoodController(clock:)`, `VoiceController(clock:)`
- ฟองบทพูดตรวจด้วย `find.byKey(Key('voice_speech_text'))` + ข้อความเท่ากับ `VoiceRules.<…>Text`

### 2.5 Storage keys (`VoiceStorageKeys` — shared_preferences)

| ค่าคงที่ | key | ชนิดที่เก็บ | ค่าเริ่มต้น (ไม่มีคีย์) | หมายเหตุ |
|---|---|---|---|---|
| `permissionStatus` | `voice_permission_status` | `bool` (`setBool`) — `true` = ON, `false` = OFF | ไม่มีคีย์ = `UNANSWERED` | game-rules §1.2 · ค่าผิดชนิด = ไม่มีคีย์ → dialog แสดง (ux-flow §4 S-1 ERROR) |
| `masterVoice` | `master_voice_toggle` | `bool` | `false` | game-rules §1.2 · ค่าผิดชนิด = `false` |
| `dayBands` | `voice_day_bands` | String JSON `{"day":"yyyy-MM-dd","water":"voice_water_low","steps":"NONE","food":"NONE"}` (เรื่องที่ยังไม่ประเมินวันนี้ = ไม่มี field) | ไม่มี | **ใหม่** — เหตุผล: V-4 "ช่วงล่าสุดของรอบวันเดียวกัน" ต้องอยู่รอดหลังปิด/เปิดแอปในวันเดียวกัน ไม่เช่นนั้นเปิดแอปใหม่พูดซ้ำทุกครั้ง · JSON อ่านไม่ได้ = null (Q-09) |

- ไม่มี key `push_notification_shortcut_toggle` (V-3) / `audio_file_path` (V-6b)
- ออกจากระบบ (signup) ไม่ล้าง key ของ voice (Q-24)

## 3. สถานะของแต่ละหน้าจอ

### S-1

| สถานะ (ux-flow §4) | เงื่อนไข | หน้าตา |
|---|---|---|
| NORMAL | Home + `voice_permission_status` ไม่มีคีย์ + การ์ดแจ้งเตือนตอบแล้ว (§2.1) | Home ด้านหลัง + barrier default + dialog §2.1 ตรงกลาง: กบร่าเริง 120, หัวข้อ, รายละเอียด, 「เปิดเสียงโลด! (แนะนำ)」 (Filled) เหนือ 「ปิดเสียงไว้ก่อน」 (Outlined) · แตะฉากหลัง / AppBar / back → dialog ยังอยู่ |
| EMPTY (ไม่แสดงซ้ำ) | `voice_permission_status` เป็น `true` / `false` (AC-1) | ไม่มี `voice_permission_dialog` ใน tree · Home ปกติ |
| ERROR | อ่าน storage ไม่ได้ / ค่าเสียหาย | ถือเป็น UNANSWERED → **แสดง dialog ตามปกติ** (ux-flow §4) ไม่แครช · บันทึกไม่ได้หลังกด → dialog ปิดตามปกติ ค่าในหน่วยความจำใช้ต่อ ไม่มี UI ผิดพลาด (Q-16) |
| รอการ์ดแจ้งเตือน | `notification.consentStatus == UNANSWERED` หรือการ์ดแจ้งเตือนเปิดอยู่ หรือกำลังรอกล่องขอสิทธิ์ OS | ไม่มี `voice_permission_dialog` — ขึ้นหลังการ์ดแจ้งเตือนปิด (Q-17) |
| กำลังโหลด | `!voice.isLoaded` | ไม่มี dialog |

ไม่มีสถานะ disabled

### S-2

| สถานะ (ux-flow §4) | เงื่อนไข | หน้าตา |
|---|---|---|
| NORMAL (กำลังพูด) | `currentLine != null` | ช่อง `dashboard_alert_slot` แสดง `voice_speech_bubble` (`secondaryContainer`) ข้อความบทพูดตรงตัว แทน `dashboard_alert_banner` · สัตว์เลี้ยง/คะแนน/แถบ ไม่เปลี่ยน |
| NORMAL (ไม่ได้พูด) | `currentLine == null` | dashboard เดิมทุกอย่าง (`dashboard_alert_banner` ตามคิว alert) · ช่องสูงเท่าบทยาวสุดถ้า `masterVoice` (§2.2) |
| EMPTY | ค่าอยู่ช่วงไม่มีบทพูด / ช่วงเดิมพูดแล้ว / `masterVoice == false` / มือถือ Mute (EC-1) | ไม่มี `voice_speech_bubble` (ยกเว้น Mute: TTS ทำงานตามปกติ ฟองแสดงตามปกติ เพราะแอปตรวจ Mute ไม่ได้ — Q-22) · ไม่แครช |
| ERROR | ไม่มีเสียง th-TH / TTS error / speak เกินเวลา (V-6a) | ข้ามบทนั้นเงียบ ๆ — ไม่มีฟองของบทที่ข้าม (timeout: ฟองหายเมื่อครบ 20 วินาที) · ไม่มี SnackBar / dialog ผิดพลาด |
| voice = null | ไม่ได้ส่ง `voiceController` | dashboard เดิมทุกพิกเซล |

### S-3

| สถานะ (ux-flow §4) | เงื่อนไข | หน้าตา |
|---|---|---|
| กำลังโหลด | notification หรือ voice ยังไม่โหลด | `Center(CircularProgressIndicator())` |
| NORMAL | โหลดแล้ว | `voice_master_switch` บนสุด ตามด้วย `notification_master_switch` (+ banner ของ notification ถ้า DENIED) |
| EMPTY (หน่วงเวลากดซ้ำ) | กดสวิตช์เสียงรัว ๆ < 300 ms (EC-5) | สวิตช์ขยับตามทุกการกด · บันทึกครั้งเดียวด้วยค่าสุดท้ายหลังนิ่ง 300 ms · ไม่มี indicator รอ |
| ERROR | บันทึกสวิตช์เสียงไม่สำเร็จ | สวิตช์เสียงกลับค่าเดิม + SnackBar `voice_save_error_toast` 「ไม่สามารถบันทึกการตั้งค่าเสียงได้ กรุณาลองใหม่อีกครั้ง」 (เสนอ) 2 วินาที · สวิตช์แจ้งเตือน: พฤติกรรมเดิมของ notification |
| voice = null | ไม่ได้ส่ง `voiceController` | หน้าเดิม (สวิตช์ 1 อัน) |

ไม่มีสถานะ disabled

## 4. ภาพสัตว์เลี้ยงแต่ละสถานะ

ใช้ `PetCharacter` จาก `app/lib/shared/pet/` (`import 'package:petpal_health/shared/pet/pet.dart'`) เท่านั้น — preset ตรวจแล้วกับ `app/lib/shared/pet/pet_pose.dart` (`dashboardCheerful` บรรทัด 166) และ character.md §4–§7 · **ไม่ต้องการท่าใหม่จาก Art (V-9)**

| สถานะ (game-rules §2) | Preset | สีหน้า / รูปร่าง | ท่าทางที่เห็น (character.md §4) | ใช้ที่ | ขนาด | ขยับ | key | preview |
|---|---|---|---|---|---|---|---|---|
| `PERMISSION_DIALOG` (ขอสิทธิ์เสียงครั้งแรก) | `PetPose.dashboardCheerful` (id `normal_cheerful`) | `cheerful` / `normal` | ตา `^ ^` ยิ้มอ้ากว้างเห็นลิ้น **ชูแขนสองข้าง** ประกาย 5 ดวง แก้มชมพูเข้ม ใบไม้โบก — "ตื่นเต้นชวนเปิดเสียง" ตาม ux-flow §2 S-1 (Q-05) | S-1 | 120 × 120 | `animate: widget.animatePet ?? kPetAnimateByDefault` — หายใจ + **กระโดดต่อเนื่อง** (ลูป `hop` 760 ms สูง 0.05·s ≈ 6 dp) · `reactToTap: false` (ux-flow ไม่มีพฤติกรรมเมื่อกด) · ไม่ส่ง `cheerTrigger` | `voice_permission_pet_image` บน `KeyedSubtree` | `docs/_design/preview/dashboard_cheerful.png` |
| `DASHBOARD_IDLE` และ `VOICE_*` ทั้ง 6 | ท่าเดิมของ dashboard `DashboardLogic.poseFor(mood)` (`dashboardCrying` / `dashboardDazed` / `dashboardBubbly` / `dashboardCheerful`) ตามคะแนนรวม | ตามอารมณ์ dashboard | **ไม่เปลี่ยนเพราะเสียง** (V-9) — game-rules §2 ใช้ภาพเดียวกันทุกสถานะเสียงอยู่แล้ว ภาพนั้นคือภาพของ dashboard | S-2 | 200 × 200 (`DashboardRules.petSize`) | เดิม | `dashboard_pet_image_<mood>` (เดิม) | `preview/dashboard_states_160.png` |

กติกาการใช้ widget:
- ห่อ key ฟีเจอร์ไว้ที่ `KeyedSubtree` ไม่ใส่บน `PetCharacter` (character.md §7, BUG-PET-1) · pose บน dialog ไม่เปลี่ยน จึงไม่ต้องใช้ GlobalKey
- Home มีสัตว์เลี้ยงของ water อยู่ด้วย → เทสต์หา painter ของ dialog ด้วย `find.descendant(of: find.byKey(ValueKey('voice_permission_pet_image')), matching: find.byKey(PetKeys.painter))`
- ตรวจด้วย `animate: false`: `painter.pose == PetPose.dashboardCheerful`, `face == PetFace.cheerful`, `showsSparkles == true`, `isDerpyEye == false`, `hop == 0` (character.md §7 dashboard รอบ 4)
- เทสต์ที่ `animate: true` **ห้าม `pumpAndSettle()`** (ลูป hop ไม่จบ) ใช้ `pump(Duration)`
- ทำไมไม่ใช้ `notificationProfile` (ขยิบตา): dialog เสียงขึ้นต่อจากการ์ดแจ้งเตือนทันที (§2.1) — ถ้าท่าเดียวกันผู้ใช้จะเห็นเหมือนการ์ดซ้ำ · cheerful อ่านว่า "ชวนสนุก" ตรงกับเนื้อหา (Q-05)

## 5. Android / iOS setup ที่ต้องเพิ่ม

**`app/pubspec.yaml` — dependencies:** `flutter_tts: 4.2.5` (pin เวอร์ชันเดียว ไม่มี `^` — V-7 · build ไม่ผ่าน → ถอยเวอร์ชันและจด log) · ไม่เพิ่ม asset / ไม่แก้ส่วน `assets:` (V-6b)

**`main()`:**
```dart
final VoiceTtsEngine voiceEngine = FlutterTtsVoiceEngine.isSupportedPlatform
    ? FlutterTtsVoiceEngine()
    : const NoopVoiceTtsEngine();                    // windows ฯลฯ — ไม่มีเสียง ไม่มีฟอง (Q-31)
final voiceController = VoiceController(
  repository: SharedPrefsVoiceRepository(),
  engine: voiceEngine,
);
// ส่ง voiceController: voiceController เข้า PetPalApp → WaterHomeScreen
```
- ไม่เรียก `prepare()` ใน `main()` (เรียกครั้งแรกเมื่อจะพูด — ไม่ถ่วงเวลาเปิดแอป)

**`app/android/app/src/main/AndroidManifest.xml`** — เพิ่ม `<intent>` ใน `<queries>` **ที่มีอยู่แล้ว** (บรรทัด ~55 ข้าง `PROCESS_TEXT`) เท่านั้น:
```xml
<queries>
    <!-- เดิม: PROCESS_TEXT -->
    <!-- voice (V-7): ให้ Android 11+ มองเห็น TTS engine ในเครื่อง — ไม่ใช่สิทธิ์ -->
    <intent>
        <action android:name="android.intent.action.TTS_SERVICE" />
    </intent>
</queries>
```
- **ห้ามเพิ่ม `uses-permission` ใด ๆ** (ไม่มี `INTERNET`, `RECORD_AUDIO`) — V-7

**iOS:** repo ยังไม่มี `app/ios/` (notification Q-12) — กิ่ง iOS ใช้โค้ดเดียวกัน ไม่ตั้ง audio category / `setSharedInstance` รอบนี้ (Q-25)

## 6. Checklist สำหรับ reviewer

- [ ] ไม่มี hex สี / ฟอนต์ / asset ใหม่ในโค้ด voice; ไม่แก้ `ThemeData`; ไม่แก้ส่วน `assets:` ของ `pubspec.yaml`; ไม่มีโฟลเดอร์ `assets/audio/`; ไม่มีไฟล์ `.mp3`
- [ ] `pubspec.yaml` เพิ่มเฉพาะ `flutter_tts` แบบ pin (`4.2.5` หรือเวอร์ชันที่ถอยแล้วพร้อมจด log)
- [ ] ไม่มี `pet_avatar_dialog.png` / `pet_avatar_happy.png` / `icon_settings_gear.png` / `Image.asset` / `AssetImage` ในโค้ด voice; ไม่แก้ไฟล์ใน `app/lib/shared/pet/`
- [ ] ข้อความทุกข้อความ (S-1 4 ข้อความ, ป้ายสวิตช์, SnackBar, 6 บทพูด) และตัวเลขทั้งหมดใน §2.4.2 อยู่ใน `VoiceRules`; `foodOvereatingThresholdKcal` อ้าง `FoodRules.overLimitThreshold`; `waterSuccessMinCups` อ้าง `DashboardRules.waterTargetCups`; `dialogPetSize` อ้าง `NotificationRules.consentPetSize`; มีคอมเมนต์ `DECIDED (owner 2026-11-12, V-x)` / `ASSUMPTION: voice ui-spec Q-xx`
- [ ] ข้อความตรงตัวทุกอักษร (ไม่มี `"` / `[ ]`): 「ให้น้องอ๊บส่งเสียงทักทายและคอยเป็นกำลังใจให้คุณทุกวันไหมคะ?」, 「น้องอ๊บพร้อมส่งเสียงเชยชม แซว หรือเตือนคุณตามบริบทสุขภาพ เพื่อเพิ่มความสนุกในการใช้งานแอป PetPal Health」, 「เปิดเสียงโลด! (แนะนำ)」, 「ปิดเสียงไว้ก่อน」, 「เปิด/ปิดเสียงพากย์น้องอ๊บ (Master Voice)」 และ 6 บทพูดใน §2.4.2
- [ ] `VoiceLine` มี 6 ค่า `id` ตรง §2.4.2 (`voice_steps_lazy` …) ไม่มี `.mp3`; ฟองและ `engine.speak` ใช้ `line.text` ตัวเดียวกัน
- [ ] `VoiceRules.ttsLanguage == 'th-TH'`, `ttsPitch == 1.5`, `defaultAudioVolumeGain == 0.80`, `toggleDebounce == 300 ms`, `speakTimeout == 20 s`; `FlutterTtsVoiceEngine.prepare` เรียก `isLanguageAvailable` → `setLanguage` → `setPitch` → `setVolume` → `awaitSpeakCompletion(true)` และคืน false เมื่อไม่มี th-TH / error; ไม่เรียก `setSpeechRate`; ไม่มี network
- [ ] `VoiceLogic` ไม่ import Flutter widgets / plugin / shared_preferences; รับ `now` เป็นพารามิเตอร์; ใช้ `WaterLogic.logicalDay`; ลำดับประเมิน water → steps → food; เทียบก้าวแบบจำนวนเต็ม; เทสต์ VT-1 ถึง VT-16 ผ่าน
- [ ] `VoiceController` ไม่ถูกสร้างด้วย `FlutterTtsVoiceEngine` ในเทสต์ใด ๆ (ใช้ fake ที่ implement `VoiceTtsEngine`)
- [ ] `PetPalApp` / `WaterHomeScreen` / `DashboardScreen` / `NotificationSettingsScreen` ที่ไม่ได้รับ `voiceController` ทำงานเหมือนเดิม — เทสต์เดิมทั้งหมดผ่านโดยไม่แก้ (รวม `DECIDED_D2_*` และ `find.byType(Switch), findsOneWidget` ของ notification S-2)
- [ ] AppBar ของ `WaterHomeScreen` ยัง 5 ปุ่ม; AppBar dashboard ยังมีปุ่มเดียว `notification_settings_entry_button` (`Icons.settings` 24, tooltip 「การแจ้งเตือนของน้องอ๊บ」)
- [ ] S-1: `showDialog(barrierDismissible: false)` + `PopScope(canPop: false)` จาก `WaterHomeScreen`; flag `_voiceDialogOpen`; keys `voice_permission_dialog` (`Dialog`), `voice_permission_pet_image`, `voice_permission_title_text` (`headlineSmall`), `voice_permission_body_text` (`bodyMedium` + `onSurfaceVariant`), `voice_permission_enable_button` (`FilledButton`), `voice_permission_disable_button` (`OutlinedButton`); ลำดับและระยะ 16/8/24/8; padding 24; ปุ่มเต็มความกว้างซ้อนแนวตั้ง
- [ ] S-1 สัตว์เลี้ยง = `PetCharacter(pose: PetPose.dashboardCheerful, size: 120, reactToTap: false)` ใน `KeyedSubtree`; `animate: widget.animatePet ?? kPetAnimateByDefault`; ไม่มี `cheerTrigger`
- [ ] S-1 ขึ้น**หลัง**การ์ดแจ้งเตือน: Home ที่ consent = UNANSWERED → เห็น `notification_consent_card` และไม่มี `voice_permission_dialog`; ตอบการ์ดแล้ว → `voice_permission_dialog` ขึ้น; ไม่มี notificationController → dialog เสียงขึ้นทันที; ไม่มี 2 dialog ซ้อนกัน
- [ ] กด 「เปิดเสียงโลด! (แนะนำ)」 → dialog หาย, `voice_permission_status == true`, `master_voice_toggle == true`; กด 「ปิดเสียงไว้ก่อน」 → `false` / `false`; กดซ้ำไม่บันทึกซ้ำ; ไม่มีการเรียก `speak` จากการกด
- [ ] สร้าง Home ใหม่ด้วย repository เดิม → ไม่มี `voice_permission_dialog`; repository อ่านไม่ได้ / ค่าผิดชนิด → dialog แสดง ไม่แครช
- [ ] deep link ของ notification ไม่ปิด dialog เสียง (รอ `_voiceDialogOpen == false`)
- [ ] S-2: ขณะพูดมี `voice_speech_bubble` + `voice_speech_text` อยู่**ภายใน** `dashboard_alert_slot` และไม่มี `dashboard_alert_banner`; พูดจบ → `voice_speech_bubble` หาย `dashboard_alert_banner` กลับมา (ถ้าคิว alert ไม่ว่าง); ฟองใช้ `_AlertBubble` (`secondaryContainer`, padding 16/8, มุม 8, `bodyMedium` + `onSecondaryContainer`, ไม่มี maxLines)
- [ ] S-2: สัตว์เลี้ยง dashboard pose/ขนาด/key ไม่เปลี่ยนระหว่างพูด; ไม่มีการเพิ่ม `cheerTrigger`
- [ ] S-2: `masterVoice == true` → ความสูงขั้นต่ำของ `dashboard_alert_slot` ≥ ความสูงฟองของบทพูดยาวสุดที่ความกว้างจริง; ฟองขึ้น/หายแล้ว `getRect(PetKeys.character)` ไม่ขยับ; ไม่มีข้อความบทพูดซ่อนใน tree
- [ ] S-2: `engine.speak` ไม่ถูกเรียกพร้อมกัน 2 ครั้ง (บทถัดไปเริ่มหลังบทก่อนจบ); pop dashboard / `paused` → `stop()` + คิวว่าง; ไม่มีการพูดบนหน้าอื่นนอก dashboard
- [ ] S-3: `voice_master_switch` (`SwitchListTile`, `contentPadding: zero`) อยู่**เหนือ** `notification_master_switch` (`getRect` top น้อยกว่า); ป้าย key `voice_master_switch_label`; AppBar title / `notification_master_switch` / banner เดิมไม่เปลี่ยน; ไม่มี key `push_notification_shortcut_toggle`
- [ ] S-3: กดสวิตช์เสียงรัว ๆ → บันทึก ≤ 1 ครั้งหลัง 300 ms ด้วยค่าสุดท้าย; สวิตช์แจ้งเตือนไม่มี debounce (ขอสิทธิ์ทันทีเหมือนเดิม); ปิดสวิตช์เสียงขณะพูด → `stop()` + คิวว่างทันที; ออกจากหน้าระหว่างรอ debounce → ค่าถูกบันทึก
- [ ] S-3 ERROR: บันทึกสวิตช์เสียงไม่สำเร็จ → สวิตช์กลับค่าเดิม + `voice_save_error_toast` (`persist: false`, 2 วินาที)
- [ ] storage: `voice_permission_status` / `master_voice_toggle` เป็น `bool`; `voice_day_bands` เป็น JSON ตาม §2.5; ไม่มี key อื่นของ voice
- [ ] manifest: เพิ่มเฉพาะ `<intent><action android:name="android.intent.action.TTS_SERVICE"/></intent>` ใน `<queries>` เดิม; ไม่มี `uses-permission` ใหม่
- [ ] ไม่มี RenderFlex overflow ที่ 360×640 dp textScaler 1.0 และ 1.5: Home + S-1 (เลื่อนได้), dashboard ขณะพูดบทยาวสุด + ช่องจองความสูง, S-3 พร้อม banner
- [ ] `VoiceController.dispose()` ยกเลิก Timer debounce (flush ก่อน) และเรียก `engine.stop()`; ไม่มี Timer ค้างหลังเทสต์

## 7. คำถามที่ค้าง

ที่มา: **A** = requirements (Product) · **B** = ux-flow / game-rules (Design) · **O** = ข้อตัดสิน owner · **UI** = ช่องว่างที่ spec ต้องเลือก · ค่าชั่วคราวทุกข้อให้ Dev ใส่ `// ASSUMPTION: voice ui-spec Q-xx`

| # | ที่มา | ประเด็น | ทางที่ spec เลือกไว้ชั่วคราว |
|---|---|---|---|
| Q-01 | O (V-1) | PNG 3 ไฟล์ใน ux-flow §5.1 | **ปิด** — PetCharacter + `Icons.settings` |
| Q-02 | O (V-2) + B (ux-flow S-3) | หัวข้อ modal 「ตั้งค่าระบบเสียงและการแจ้งเตือน」 และปุ่ม X ไม่มีที่ใช้เมื่อไม่มี modal | คง AppBar title เดิม 「การแจ้งเตือนของน้องอ๊บ」 (เทสต์ `DECIDED_D2_*` ตรวจข้อความนี้) และ tooltip เดิม · ปุ่มย้อนกลับ AppBar / back ของระบบแทนปุ่ม X · ถ้าต้องการเปลี่ยนหัวข้อเป็นของ ux-flow ให้ owner ตัดสินพร้อมแก้เทสต์ notification |
| Q-03 | O (V-3) + B | ป้าย 「เปิด/ปิดการแจ้งเตือน (Push Notification Shortcut)」 ของ ux-flow ไม่ได้ใช้ | ใช้ป้ายเดิม 「เปิด/ปิดแจ้งเตือนทั้งหมด」 (notification Q-03) — widget เดิมไม่แตะ |
| Q-04 | B (ux-flow §2 S-1) | ป้ายปุ่มเขียนเป็น `[ เปิดเสียงโลด! (แนะนำ) ]` | `[ ]` และช่องว่างด้านในเป็นสัญลักษณ์ปุ่ม → ป้าย 「เปิดเสียงโลด! (แนะนำ)」 / 「ปิดเสียงไว้ก่อน」 (คง `!` และ `(แนะนำ)`) |
| Q-05 | O (V-1, V-9) → UI | ท่าสัตว์เลี้ยงใน S-1 | `PetPose.dashboardCheerful` (ชูแขน ร่าเริง) — ต่างจากการ์ดแจ้งเตือนที่ขึ้นก่อนหน้า (`notificationProfile`) · ไม่ต้องมีท่าใหม่ |
| Q-06 | O → UI | ข้อความบทพูดแสดงที่ไหนบน dashboard | ในช่อง `dashboard_alert_slot` เดิม (ฟองเหนือหัวน้องอ๊บ) แทนฟอง alert ชั่วคราวขณะพูด · สไตล์ `_AlertBubble` เดิม · แยกด้วย key `voice_speech_*` · ไม่มีไอคอนลำโพง |
| Q-07 | UI | บทพูดยาวกว่า alert P1 มาก — ฟองขึ้น/หายทำให้ layout กระโดด | จองความสูงช่อง = บทยาวสุด **เฉพาะเมื่อ `masterVoice == true`** (dashboard D-16 วัดด้วย TextPainter) · ปิดเสียง = ความสูงเดิม |
| Q-08 | O (V-4) | ปิดเสียงอยู่ — บันทึกช่วงไหม / เปิดเสียงทีหลังควรพูดทันทีไหม | บันทึกช่วงเสมอ (พูดเฉพาะเมื่อเปิดเสียง) → เปิดเสียงแล้วไม่มีบทย้อน พูดเมื่อเข้าช่วงใหม่ครั้งถัดไป · การสลับสวิตช์ไม่ใช่ "ค่าเปลี่ยน" ที่กระตุ้นการพูด |
| Q-09 | O (V-4) → UI | ต้องจำ "ช่วงล่าสุดของวัน" ข้ามการปิด/เปิดแอป — game-rules §1.2 ไม่มี key | key ใหม่ `voice_day_bands` (JSON ต่อรอบวัน) · บันทึกไม่สำเร็จ = คงในหน่วยความจำ ไม่มี UI |
| Q-10 | B (game-rules §3 แถวสุดท้าย, EC-2) | หลายเรื่องเข้าช่วงใหม่ในการประเมินครั้งเดียว (เช่นเปิด dashboard) — ลำดับคิว | water → steps → food (ตรงตัวอย่าง game-rules "น้ำก่อนก้าว" และลำดับ `_sources` ของ `DashboardController`) · เหตุการณ์ต่างครั้งกัน = FIFO ตามเวลาที่ตรวจพบ |
| Q-11 | O (V-6a) | ไม่มีเสียงไทย — แสดงข้อความในฟองโดยไม่มีเสียงไหม | ไม่แสดง (ux-flow ผูกข้อความกับ "ไฟล์ที่กำลังเล่น" และ EC-3 "ข้ามเงียบ ๆ") · ช่วงยังถูกบันทึก |
| Q-12 | UI | TTS บางเครื่องไม่ส่ง completion → ฟอง/คิวค้าง | `VoiceRules.speakTimeout` 20 วินาที (ใหม่) แล้ว `stop()` + บทถัดไป |
| Q-13 | O (V-4) → UI | ออกจาก dashboard / แอปไป background ระหว่างพูด | `stopAndClear()` (หยุด + ล้างคิว) · กลับมา resume → ประเมินใหม่ (ช่วงเดิมไม่พูดซ้ำ) · เปิดหน้าตั้งค่าทับ dashboard ไม่หยุด |
| Q-14 | B (ux-flow S-3 "Debounce 300 ms และบันทึกทันที") | สองคำขัดกัน | สวิตช์ + ค่าในหน่วยความจำเปลี่ยนทันที (ปิด = หยุดเสียงทันที) · เขียน storage ครั้งเดียวหลังนิ่ง 300 ms ด้วยค่าสุดท้าย · ออกจากหน้า = flush |
| Q-15 | B (ux-flow §4 S-3 ERROR) | ข้อความ "แจ้งเตือนให้ลองใหม่" ไม่มี Exact String | SnackBar 「ไม่สามารถบันทึกการตั้งค่าเสียงได้ กรุณาลองใหม่อีกครั้ง」 **(เสนอ)** 2 วินาที (pattern `showStepsToast`) · ไม่มีปุ่มลองใหม่ |
| Q-16 | B (ux-flow §4 S-1) | บันทึกคำตอบ S-1 ไม่สำเร็จ | dialog ปิดตามปกติ ใช้ค่าในหน่วยความจำ ไม่มี UI ผิดพลาด → เปิดแอปครั้งหน้า dialog ขึ้นอีก (storage ยังไม่มีคีย์) |
| Q-17 | UI | ลำดับกับการ์ดแจ้งเตือนบน Home | การ์ดแจ้งเตือนก่อน (ฟีเจอร์เดิม เวลาไม่เปลี่ยน) → รอกล่องขอสิทธิ์ OS จบ → dialog เสียง · ไม่มี dialog ซ้อน |
| Q-18 | A (AC-1) | ผู้ใช้เดิมที่ผ่าน Onboarding ก่อนอัปเดต | เห็น dialog เสียงครั้งเดียวเมื่อเข้า Home หลังอัปเดต (ไม่มีคีย์ = UNANSWERED) เหมือน notification Q-18 |
| Q-19 | A (AC-5) | "อาหารเกิน > 100 kcal" เทียบกับอะไร / ไม่มีเป้า | `total > target + 100` = `FoodController.isOverLimit` (ตัวเดียวกับหลอดแดง/alert P1) · ไม่มีเป้า (ข้ามโปรไฟล์) = ไม่มีบทอาหาร |
| Q-20 | B | เป้าก้าว ≤ 0 / ก้าวติดลบ | ถือเป็น 0% → `stepsLazy` (เหมือน `StepsLogic.percentGoal`) · น้ำติดลบ → `waterLow` |
| Q-21 | O (V-6) | ความเร็วพูดไม่ได้กำหนด | ไม่เรียก `setSpeechRate` (ค่าเครื่อง) |
| Q-22 | A (EC-1) | แอปตรวจ Mute / เสียงสื่อ 0 ไม่ได้ | TTS ทำงานตามปกติ ฟองแสดงตามปกติ ไม่แครช |
| Q-23 | UI | หน้าตั้งค่าเข้าได้ทางปุ่มเฟืองซึ่งมีเฉพาะเมื่อมี `notificationController` | ในแอปจริงมีทั้งคู่เสมอ · กรณี voice มีแต่ notification null (เทสต์เท่านั้น) = ไม่มีทางเข้าสวิตช์เสียง — ยอมรับ |
| Q-24 | A | ออกจากระบบ (signup) ล้างค่าเสียงไหม | ไม่ล้าง — เป็นค่าระดับเครื่อง (`voice_permission_status`, `master_voice_toggle`, `voice_day_bands` คงอยู่) · รอ Product |
| Q-25 | UI | ไม่มี `app/ios/` — ตั้ง audio session iOS ไม่ได้ | ใช้ default ของ `flutter_tts` · ตรวจ iOS จากโค้ดเท่านั้น |
| Q-26 | B | game-rules มี `PUSH_NOTIFICATION_SHORTCUT_TOGGLE`, `AUDIO_FILE_PATH`, `audio_file_path` | ไม่มีในโค้ด (V-3, V-6b) |
| Q-27 | B | ux-flow / game-rules / requirements ยังเขียน mp3, PNG, modal S-3, "เพดานไม่จำกัด" | ข้อตัดสิน V-1..V-6 ชนะ — ขอ Design/Product อัปเดตเอกสาร (UI ไม่แก้) |
| Q-28 | UI | dialog S-1 ที่ textScaler 1.5 สูง ~790 dp เกินจอ 640 | เลื่อนใน `SingleChildScrollView` (ไม่ overflow) — ปุ่มอาจต้องเลื่อนจึงเห็น · ไม่ลดขนาดสัตว์เลี้ยง/หัวข้อ เพื่อคงหน้าตาเดียวกับการ์ดแจ้งเตือน |
| Q-29 | UI | ข้อความหัวข้อยาว (~57 ตัวอักษร) กับ `headlineSmall` | คง `headlineSmall` ตามการ์ดแจ้งเตือน (ความสม่ำเสมอ) |
| Q-30 | B (game-rules §3) | ตัวอย่าง `steps = 99.00% (หรือ 99.99%)` | ทั้งคู่ = `stepsEncouraging` (เทียบ `< 100%`) |
| Q-31 | UI | Windows / แพลตฟอร์มที่ไม่ใช่มือถือ | `NoopVoiceTtsEngine` → `prepare()` false → ไม่มีเสียง ไม่มีฟอง |
| Q-32 | UI | โปรแกรมอ่านจอ (TalkBack) อ่านฟองทับเสียง TTS | ไม่ใส่ `liveRegion` บนฟอง |
