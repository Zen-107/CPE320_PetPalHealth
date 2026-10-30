# UI spec: Signup & Onboarding (signup)

> สถานะ: draft · ผู้เขียน: UI agent · อ้างอิง: ux-flow.md, game-rules.md (บริบท: requirements.md, brief.md)
> เอกสารนี้กำหนด "หน้าตา" เท่านั้น — ตัวเลข กติกา และ flow ให้ยึด ux-flow.md / game-rules.md
> design language ยึดตาม `docs/steps/ui-spec.md` (ฉบับเดียวที่มีก่อนหน้า) และโค้ดจริงใน `app/lib/` — ไม่สร้างระบบดีไซน์ใหม่

## 0. ข้อตัดสินใจที่มีผลต่อ UI

signup ยังไม่มีข้อตัดสินใจเฉพาะจากเจ้าของโปรเจกต์ — ตารางนี้คือข้อตัดสินใจระดับแอปที่มีอยู่แล้วซึ่ง spec นี้ต้องรองรับ (ไม่ใช่ของ UI agent)

| # | ข้อตัดสินใจ (ที่มา) | ผลต่อ UI |
|---|---|---|
| D-1 | ทั้งแอปใช้สัตว์เลี้ยงตัวเดียว = `PetCharacter` ไม่ใช้ PNG สัตว์เลี้ยง (owner 2026-10-14 — `docs/_design/character.md` §9 ข้อ 2, คอมเมนต์ใน `water_home_screen.dart`) | ภาพ `assets/images/signup/s7_home_placeholder.png` ของ DEFAULT_PET (game-rules §2) ใช้แทนสัตว์เลี้ยงไม่ได้ — ดู §4 และ Q-14 |
| D-2 | หน้า home ปัจจุบันของแอปคือ `WaterHomeScreen` (`app/lib/main.dart` → `MaterialApp.home`) | S-7 ไม่สร้างหน้าใหม่ ใช้ `WaterHomeScreen` เดิม + แบนเนอร์ต้อนรับ (แบบเดียวกับที่ steps ใส่ทางเข้าบนหน้า water แบบน้อยที่สุด — steps ui-spec D-3) ดู §2.7, Q-13 |

## 1. Design tokens

ทุกสีของ component ให้ดึงจาก `Theme.of(context).colorScheme` / `textTheme` เท่านั้น ห้าม hardcode hex ในหน้าจอ signup (signup ไม่วาดสัตว์เลี้ยงเอง จึงไม่มี hex ใด ๆ เลย)

### 1.1 สี

| Token | ค่า | ใช้ที่ไหน | ที่มา |
|---|---|---|---|
| Seed color | `Colors.lightBlue` | ทุก ColorScheme | `app/lib/main.dart` → `ColorScheme.fromSeed(seedColor: Colors.lightBlue)` |
| ปุ่มหลัก | `colorScheme.primary` (default ของ `FilledButton`) | S-1 ปุ่มสมัครด้วยอีเมล, S-2/S-3/S-4/S-5/S-6 ปุ่มดำเนินการ, ปุ่ม Retry ใน dialog | ของเดิม: `water_log_button`, `steps_add_button`, `steps_goal_save_button` |
| ปุ่มรอง (Google) | default ของ `OutlinedButton` (ขอบ `colorScheme.outline`, ตัวอักษร `primary`) | S-1 ปุ่ม Google | default M3 จาก ColorScheme เดิม — **component ใหม่ของแอป** (ยังไม่มีใครใช้ `OutlinedButton`) เหตุผล: ต้องแยกลำดับความสำคัญของ 2 ปุ่มบน S-1 โดยไม่ตั้งสีเอง |
| ลิงก์ | default ของ `TextButton` (ตัวอักษร `primary`) | S-1 「มีบัญชีอยู่แล้ว? เข้าสู่ระบบ」, S-2 「ลืมรหัสผ่าน?」 | ของเดิม: `water_monthly_report_button`, `steps_set_goal_button` |
| Disabled "สีเทาจาง" | สี disabled มาตรฐาน M3 ได้เองเมื่อ `onPressed: null` | ปุ่มที่ถูก disable ทุกปุ่ม | steps ui-spec §1.1 — ห้ามตั้งสีเทาเอง |
| ข้อความ Error ใต้ฟิลด์ | `colorScheme.error` (default ของ `InputDecoration.error`) | S-2, S-5, S-6 inline error | default M3 จาก ColorScheme เดิม |
| ข้อความเตือน (Inline Warning) | `colorScheme.tertiary` | S-6 คำเตือนเพศ/น้ำหนัก/ส่วนสูง | role ใน ColorScheme เดิม (ไม่มี hex ใหม่) — **การใช้ role ใหม่** เหตุผล: warning ไม่บล็อกการบันทึก (fallback rule ใน ux-flow §6) จึงต้องไม่ใช้สี `error` แต่ต้องเด่นกว่า helper text ปกติ |
| ข้อความรอง (คำโปรย, 「หรือ」) | `colorScheme.onSurfaceVariant` | S-1 | role เดิม (steps ใช้กับไอคอนออฟไลน์) |
| เส้นคั่น | default ของ `Divider` (`outlineVariant`) | S-1 | ของเดิม: `Divider(height: 1)` ใน steps S-3 |

### 1.2 ตัวอักษร

ไม่มี custom font ใน `app/pubspec.yaml` → ฟอนต์ default ของ Material ใช้ `Theme.of(context).textTheme` เท่านั้น

| ใช้กับ | style | ที่มา |
|---|---|---|
| หัวข้อหน้าจอใน AppBar (S-2, S-3, S-5, S-6) | default ของ `AppBar` | water / steps ทุกหน้า |
| หัวข้อแบบ hero ในเนื้อหา (S-1 「PetPal Health」, S-4 「ตรวจสอบอีเมลของคุณ」) | `textTheme.headlineSmall` | `water_count_text`, `steps_count_text` |
| คำโปรย / คำอธิบาย / ข้อความบรรยาย | default (`bodyMedium`) | `water_energy_text`, `steps_percent_text` |
| หัวกลุ่มในฟอร์ม (S-6 「เพศ」) | `textTheme.titleMedium` | steps S-2 หัวกลุ่มเป้าหมาย |
| ข้อความในฟิลด์ / hint | default ของ `TextField` (`bodyLarge`) | default M3 |
| Error / Warning ใต้ฟิลด์ | default ของ `InputDecoration` (`bodySmall`) — warning ที่ไม่ใช่ TextField (เพศ) ใช้ `bodySmall` เท่ากัน | default M3 |
| แบนเนอร์ต้อนรับ S-7 | `textTheme.titleMedium` | role เดิม (เท่าป้ายสถานะ steps) |

### 1.3 ระยะห่าง ขนาด มุมโค้ง

| Token | ค่า | ที่มา |
|---|---|---|
| Padding หน้า hero (S-1, S-4) | 24 รอบด้าน | `water_home_screen.dart`, `steps_dashboard_screen.dart` → `EdgeInsets.all(24)` |
| Padding หน้าฟอร์ม (S-2, S-3, S-5, S-6) | 16 รอบด้าน | steps ui-spec §1.3 หน้ารอง → `EdgeInsets.all(16)` |
| ช่องไฟ | 8 / 16 / 24 (`SizedBox`) | `water_home_screen.dart` |
| ระยะระหว่างฟิลด์ในฟอร์ม | 16 | ค่าช่องไฟเดิม |
| ระยะก่อนปุ่มหลักท้ายฟอร์ม | 24 | ค่าช่องไฟเดิม |
| ขนาดภาพโลโก้ S-1 / ภาพ S-4 | 160 × 160 | ใช้ค่าเดียวกับขนาดสัตว์เลี้ยง (`PetCharacter.size` default 160) — ux-flow §5 บอก "ขนาดกลาง" ไม่ตั้งค่าใหม่ |
| ขนาดไอคอน | 24 | `asset_image_or_icon.dart` → `AssetImageOrIcon.size` default 24 |
| Loading ในปุ่ม | `SizedBox(20×20)` + `CircularProgressIndicator(strokeWidth: 2)` | steps ui-spec §3 S-3 (`steps_report_exporting_indicator`) |
| Loading ทั้งหน้า | `Center(CircularProgressIndicator())` | `water_home_screen.dart` / `steps_dashboard_screen.dart` ตอน `!isLoaded` |
| ขอบช่องกรอก | `OutlineInputBorder()` ค่า default M3 (ไม่ตั้งรัศมีเอง) | **ใหม่** — เหตุผล: แอปยังไม่มี `TextField` เลย signup เป็นฟอร์มแรก; S-6 มี 6 ช่องในหน้าเดียว ขอบแบบ outline แยกช่องชัดกว่า underline — ใช้ default ทั้งหมด ไม่เพิ่มค่าตัวเลข |
| ระยะเวลา SnackBar (Toast) | 2 วินาที, `persist: false`, `hideCurrentSnackBar()` ก่อน | `StepsRules.toastSeconds` / `showStepsToast` (`steps_toast.dart`), `water_anti_spam_toast` |

## 2. หน้าจอ

ข้อความใน「」คัดลอกตรงตัวจาก ux-flow.md — ห้ามแก้ ข้อความที่ ux-flow ไม่มีและ spec เสนอไว้ชั่วคราว ระบุว่า **(เสนอ — รอยืนยัน)**
ค่าตัวเลขทุกตัว (6, 20, 8, 1–120, 1.0–300.0, 1.0–250.0, 「ดูแลสุขภาพ」, `UNSPECIFIED`) ต้องอ่านจากค่าคงที่ตาม game-rules §1 (เช่น `SignupRules.minPasswordLength`) ห้าม hardcode ซ้ำในหน้าจอ — pattern เดียวกับ `StepsRules`
ValueKey ใช้ prefix `signup_` ทั้งหมด

### 2.0 การเปิดแอป (ตรวจ Token — AC-8, game-rules §4)

ไม่ใช่หน้าจอใหม่ เป็นสถานะ loading ระหว่างอ่าน Token จาก Secure Storage ก่อนตัดสินใจไป S-1 หรือ S-7

- `Scaffold(body: Center(child: CircularProgressIndicator()))` แบบเดียวกับ water ตอน `!isLoaded` — key `signup_auth_loading`
- ไม่มีข้อความ ไม่มีโลโก้ (ux-flow ไม่กำหนด)

### 2.1 S-1 หน้าต้อนรับและเลือกวิธีเข้าสู่ระบบ

โครง: `Scaffold` (ไม่มี AppBar — ux-flow ไม่มีปุ่มย้อนกลับ/หัวข้อ AppBar) → `SafeArea` → `Padding(24)` → `Column(crossAxisAlignment: stretch)`
ถ้าความสูงจอไม่พอ ใช้ pattern `SingleChildScrollView` + `ConstrainedBox(minHeight)` + `IntrinsicHeight` แบบ `steps_dashboard_screen.dart` เพื่อคง `Spacer`

| # | องค์ประกอบ | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 1 | `Spacer()` | | | | |
| 2 | โลโก้ | `Center` → `AssetImageOrIcon(assetPath: 'assets/images/signup/s1_logo.png', fallbackIcon: Icons.pets, size: 160)` | ภาพตาม ux-flow §5 | 160 × 160 | `signup_welcome_logo` |
| 3 | `SizedBox(height: 16)` | | | | |
| 4 | หัวข้อหลัก | `Text(textAlign: center)` | 「PetPal Health」 | `headlineSmall` | `signup_welcome_title_text` |
| 5 | `SizedBox(height: 8)` | | | | |
| 6 | คำโปรย | `Text(textAlign: center)` | 「เพื่อนซี้สุขภาพดี พาคุณและสัตว์เลี้ยงมีความสุขไปด้วยกัน」 | `bodyMedium`, `onSurfaceVariant` | `signup_welcome_tagline_text` |
| 7 | `Spacer()` | | | | |
| 8 | ปุ่ม Google Login | `OutlinedButton.icon`, icon `Icons.login` 24 (ux-flow ไม่มีไฟล์โลโก้ Google — Q-17) | 「เข้าสู่ระบบด้วย Google」 | OutlinedButton default | `signup_google_button` |
| 9 | `SizedBox(height: 16)` | | | | |
| 10 | เส้นคั่น | `Row` → `Expanded(Divider())`, `Padding(horizontal: 16, Text)`, `Expanded(Divider())` | 「หรือ」 | `bodyMedium`, `onSurfaceVariant` | `signup_or_text` (บน `Text`) |
| 11 | `SizedBox(height: 16)` | | | | |
| 12 | ปุ่มสมัครด้วยอีเมล | `FilledButton.icon`, icon `Icons.email` 24 | 「สมัครสมาชิกด้วยอีเมล」 | primary | `signup_email_signup_button` |
| 13 | `SizedBox(height: 8)` | | | | |
| 14 | ลิงก์มีบัญชีแล้ว | `TextButton` | 「มีบัญชีอยู่แล้ว? เข้าสู่ระบบ」 | TextButton default | `signup_have_account_link` |

- กด #12 → S-2 โหมดสมัคร, กด #14 → S-2 โหมดเข้าสู่ระบบ (ดู §2.2)

### 2.2 S-2 หน้าสมัครสมาชิกด้วยอีเมล

โครง: `Scaffold` → `AppBar` → body `SingleChildScrollView` → `Padding(16)` → `Column(crossAxisAlignment: stretch)`

| # | องค์ประกอบ | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 1 | ปุ่มย้อนกลับ | `AppBar.leading: IconButton(icon: Icon(Icons.arrow_back))` แบบ `steps_goal_back_button` | ไอคอนลูกศรซ้าย, tooltip 「ย้อนกลับ」 (`StepsRules.backButtonText` / `WaterRules.backButtonText` หรือค่าเดียวกันใน signup) | AppBar default | `signup_email_back_button` |
| 2 | หัวข้อหน้าจอ | `AppBar(title: Text(...))` | โหมดสมัคร: 「สร้างบัญชีผู้ใช้」 · โหมดเข้าสู่ระบบ: 「เข้าสู่ระบบ」 **(เสนอ — รอยืนยัน, Q-2)** | AppBar default | `signup_email_header_text` |
| 3 | ฟิลด์อีเมล | `TextField(keyboardType: emailAddress, autocorrect: false)` + `InputDecoration(border: OutlineInputBorder(), hintText: ...)` | hint 「กรอกอีเมลของคุณ」 | §1.3 | `signup_email_field` |
| 4 | `SizedBox(height: 16)` | | | | |
| 5 | ฟิลด์รหัสผ่าน | `TextField(obscureText: true)` + `InputDecoration(border: OutlineInputBorder(), hintText: ...)` | hint 「รหัสผ่าน (อย่างน้อย 6 ตัวอักษร)」 | §1.3 | `signup_password_field` |
| 6 | `SizedBox(height: 24)` | | | | |
| 7 | ปุ่มดำเนินการ | `FilledButton` เต็มความกว้าง | โหมดสมัคร: 「สมัครสมาชิก」 · โหมดเข้าสู่ระบบ: 「ดำเนินการต่อ」 (ux-flow ให้ 2 ข้อความ — การจับคู่กับโหมดเป็นการตีความ Q-2) | primary; disabled = default M3 | `signup_submit_button` |
| 8 | `SizedBox(height: 8)` | | | | |
| 9 | ลิงก์ลืมรหัสผ่าน | `Center` → `TextButton` | 「ลืมรหัสผ่าน?」 | TextButton default | `signup_forgot_password_link` |

ข้อความ error (แสดงผ่าน `InputDecoration.error: Text(key: ...)` เพื่อให้ตรวจ key ได้ — สี `colorScheme.error` default):

| ฟิลด์ | ข้อความ | ValueKey |
|---|---|---|
| รหัสผ่าน (#5) | 「รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร」 | `signup_password_error_text` |
| อีเมล (#3) — เฉพาะโหมดสมัคร | 「อีเมลนี้ถูกใช้งานแล้ว」 | `signup_email_duplicate_error_text` |

### 2.3 S-3 หน้าลืมรหัสผ่าน (ขอรีเซ็ต)

โครง: เหมือน S-2 (`AppBar` + `Padding(16)` + `Column(stretch)`)

| # | องค์ประกอบ | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 1 | ปุ่มย้อนกลับ | `AppBar.leading: IconButton(Icons.arrow_back)` | ไอคอนลูกศรซ้าย, tooltip 「ย้อนกลับ」 | AppBar default | `signup_forgot_back_button` |
| 2 | หัวข้อหน้าจอ | `AppBar(title: Text(...))` | 「ลืมรหัสผ่าน」 | AppBar default | `signup_forgot_header_text` |
| 3 | คำอธิบาย | `Text` | 「กรอกอีเมลที่คุณใช้สมัคร เพื่อรับลิงก์ตั้งค่ารหัสผ่านใหม่」 | `bodyMedium` | `signup_forgot_description_text` |
| 4 | `SizedBox(height: 16)` | | | | |
| 5 | ฟิลด์อีเมลรีเซ็ต | `TextField(keyboardType: emailAddress)` + `OutlineInputBorder()` | hint 「กรอกอีเมลของคุณ」 | §1.3 | `signup_forgot_email_field` |
| 6 | `SizedBox(height: 24)` | | | | |
| 7 | ปุ่มส่งคำขอ | `FilledButton` เต็มความกว้าง | 「ส่งลิงก์รีเซ็ตรหัสผ่าน」 | primary | `signup_forgot_submit_button` |

### 2.4 S-4 หน้าจอรอการยืนยันรีเซ็ตรหัสผ่าน

โครง: `Scaffold` (ไม่มี AppBar — ux-flow ไม่มีปุ่มย้อนกลับ) → `SafeArea` → `Padding(24)` → `Column(crossAxisAlignment: stretch)` แบบหน้า hero เดียวกับ S-1

| # | องค์ประกอบ | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 1 | `Spacer()` | | | | |
| 2 | ไอคอนสถานะ | `Center` → `AssetImageOrIcon(assetPath: 'assets/images/signup/s4_email_sent.png', fallbackIcon: Icons.mark_email_unread, size: 160)` | ภาพตาม ux-flow §5 | 160 × 160 | `signup_reset_sent_image` |
| 3 | `SizedBox(height: 16)` | | | | |
| 4 | หัวข้อหน้าจอ | `Text(textAlign: center)` | 「ตรวจสอบอีเมลของคุณ」 | `headlineSmall` | `signup_reset_sent_header_text` |
| 5 | `SizedBox(height: 8)` | | | | |
| 6 | ข้อความแจ้งเตือน | `Text(textAlign: center)` | 「เราได้ส่งลิงก์สำหรับตั้งรหัสผ่านใหม่ไปที่อีเมลของคุณแล้ว กรุณาตรวจสอบกล่องข้อความ」 | `bodyMedium` | `signup_reset_sent_message_text` |
| 7 | `Spacer()` | | | | |
| 8 | ปุ่มกลับหน้าเข้าสู่ระบบ | `FilledButton` เต็มความกว้าง | 「กลับสู่หน้าเข้าสู่ระบบ」 | primary | `signup_back_to_login_button` |

### 2.5 S-5 หน้าตั้งค่ารหัสผ่านใหม่

โครง: `Scaffold` → `AppBar(automaticallyImplyLeading: false)` (ux-flow ไม่มีปุ่มย้อนกลับ) → `Padding(16)` → `Column(stretch)`

| # | องค์ประกอบ | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 1 | หัวข้อหน้าจอ | `AppBar(title: Text(...))` | 「ตั้งรหัสผ่านใหม่」 | AppBar default | `signup_new_password_header_text` |
| 2 | ฟิลด์รหัสผ่านใหม่ | `TextField(obscureText: true)` + `OutlineInputBorder()` | hint 「รหัสผ่านใหม่ (อย่างน้อย 6 ตัวอักษร)」 | §1.3 | `signup_new_password_field` |
| 3 | `SizedBox(height: 24)` | | | | |
| 4 | ปุ่มบันทึกรหัสผ่าน | `FilledButton` เต็มความกว้าง | 「บันทึกรหัสผ่านใหม่」 | primary; disabled = default M3 | `signup_new_password_save_button` |

- Error ใต้ฟิลด์ #2 (`InputDecoration.error`): 「รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร」 key `signup_new_password_error_text` (ข้อความ**ต่างจาก S-2** ตาม ux-flow ตรงตัว — Q-5)
- บันทึกสำเร็จ → กลับ S-2 แล้วแสดง `SnackBar` key `signup_password_reset_success_toast` ข้อความ 「บันทึกรหัสผ่านใหม่เรียบร้อยแล้ว」 **(เสนอ — รอยืนยัน, Q-6)** ตาม pattern `showStepsToast` (§1.3)

### 2.6 S-6 หน้า Onboarding (ข้อมูลส่วนตัวและสุขภาพ)

โครง: `Scaffold` → `AppBar(automaticallyImplyLeading: false)` → body `SingleChildScrollView` (ฟอร์มหน้าเดียวแบบ long scroll ตาม brief) → `Padding(16)` → `Column(crossAxisAlignment: stretch)` — ปุ่มบันทึกอยู่ท้ายฟอร์ม (เลื่อนตามเนื้อหา)

| # | องค์ประกอบ | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 1 | หัวข้อหน้าจอ | `AppBar(title: Text(...))` | 「ข้อมูลสุขภาพเบื้องต้นของคุณ」 | AppBar default | `signup_onboarding_header_text` |
| 2 | คำอธิบาย | `Text` | 「โปรดกรอกข้อมูลเพื่อให้ PetPal Health ช่วยแนะนำการดูแลสุขภาพที่เหมาะสม」 | `bodyMedium` | `signup_onboarding_description_text` |
| 3 | `SizedBox(height: 16)` | | | | |
| 4 | ฟิลด์ Display Name | `TextField(maxLength: max_display_name_length, maxLengthEnforcement: MaxLengthEnforcement.enforced)` + `OutlineInputBorder()` — ตัวนับ `n/20` ใต้ช่องเป็น default ของ `maxLength` (คงไว้) | hint 「ชื่อที่ใช้แสดง (สูงสุด 20 ตัวอักษร)」 | §1.3 | `signup_display_name_field` |
| 5 | `SizedBox(height: 16)` | | | | |
| 6 | ฟิลด์อายุ | `TextField(keyboardType: number, inputFormatters: [FilteringTextInputFormatter.digitsOnly])` + `OutlineInputBorder()` (เลือก Text Field จาก "Stepper / Text Field") | hint 「อายุ (ปี)」 | §1.3 | `signup_age_field` |
| 7 | `SizedBox(height: 16)` | | | | |
| 8 | หัวกลุ่มเพศ | `Text` | 「เพศ」 **(เสนอ — รอยืนยัน, Q-9)** | `titleMedium` | `signup_gender_label` |
| 9 | ตัวเลือกเพศ | `RadioGroup<Gender>` → `Column` → 3 × `RadioListTile(contentPadding: EdgeInsets.zero)` (เลือก Radio จาก "Radio Button / Dropdown" ตาม brief) | ลำดับ: 「ชาย」 「หญิง」 「ไม่ระบุ」 — แสดงเฉพาะคำไทย ค่าภายในเป็น `MALE` / `FEMALE` / `UNSPECIFIED` (Q-8) | RadioListTile default | กลุ่ม `signup_gender_group`; ตัวเลือก `signup_gender_male`, `signup_gender_female`, `signup_gender_unspecified` |
| 10 | คำเตือนเพศไม่ระบุ | `Padding(left: 16)` → `Text` (แสดงเฉพาะเมื่อเลือก `UNSPECIFIED`) | 「ไม่สามารถคำนวณจำนวนแคลอรี่ที่เหมาะสมต่อวันได้」 | `bodySmall`, `colorScheme.tertiary` | `signup_gender_warning_text` |
| 11 | `SizedBox(height: 16)` | | | | |
| 12 | ฟิลด์น้ำหนัก | `TextField(keyboardType: TextInputType.numberWithOptions(decimal: true))` + `OutlineInputBorder()` | hint 「น้ำหนัก (กิโลกรัม)」 | §1.3 | `signup_weight_field` |
| 13 | `SizedBox(height: 16)` | | | | |
| 14 | ฟิลด์ส่วนสูง | `TextField(keyboardType: TextInputType.numberWithOptions(decimal: true))` + `OutlineInputBorder()` | hint 「ส่วนสูง (เซนติเมตร)」 | §1.3 | `signup_height_field` |
| 15 | `SizedBox(height: 16)` | | | | |
| 16 | ฟิลด์เป้าหมายสุขภาพ | `TextField(minLines: 3, maxLines: 3 → ขยายได้, keyboardType: multiline)` + `OutlineInputBorder()` + `labelText` 「เป้าหมายสุขภาพ」 **(เสนอ — Q-10)**; controller เริ่มต้นด้วยค่า `default_health_goal` | ค่าเริ่มต้นในช่อง: 「ดูแลสุขภาพ」 (เป็นข้อความจริงในช่อง ไม่ใช่ hint) | §1.3 | `signup_health_goal_field` |
| 17 | `SizedBox(height: 24)` | | | | |
| 18 | ปุ่มบันทึกข้อมูล | `FilledButton` เต็มความกว้าง | 「บันทึกและเริ่มต้นใช้งาน」 | primary; disabled = default M3 | `signup_onboarding_save_button` |

ข้อความใต้ฟิลด์ (ใช้ `InputDecoration.helper: Text(key: ...)` สำหรับ warning โดยกำหนด style `bodySmall` + `colorScheme.tertiary`; ใช้ `InputDecoration.error: Text(key: ...)` สำหรับ error — error แทนที่ helper เองตาม default):

| ฟิลด์ | ชนิด | ข้อความ | เมื่อไร | ValueKey |
|---|---|---|---|---|
| อายุ (#6) | Error | 「อายุต้องอยู่ระหว่าง 1–120 ปี」 **(เสนอ — Q-11)** ตัวเลขดึงจาก `min_age` / `max_age` | ค่านอก `[min_age, max_age]` (game-rules §4) | `signup_age_error_text` |
| น้ำหนัก (#12) | Warning | 「จะไม่มีการแนะนำแคลอรี่ที่เหมาะสมต่อวัน」 | ช่องว่าง (AC-7) | `signup_weight_warning_text` |
| น้ำหนัก (#12) | Error | 「น้ำหนักต้องอยู่ระหว่าง 1–300 กิโลกรัม」 **(เสนอ — Q-11)** จาก `min_weight` / `max_weight` | ค่านอก `[min_weight, max_weight]` | `signup_weight_error_text` |
| ส่วนสูง (#14) | Warning | 「จะไม่มีการแนะนำแคลอรี่ที่เหมาะสมต่อวัน」 | ช่องว่าง (AC-7) | `signup_height_warning_text` |
| ส่วนสูง (#14) | Error | 「ส่วนสูงต้องอยู่ระหว่าง 1–250 เซนติเมตร」 **(เสนอ — Q-11)** จาก `min_height` / `max_height` | ค่านอก `[min_height, max_height]` | `signup_height_error_text` |

- Display Name: ไม่มี error/warning — ระบบบล็อกตัวที่ 21 เองด้วย `maxLengthEnforcement` (EC-3, game-rules §4)
- เลข 1 ในข้อความ error แสดงเป็นจำนวนเต็ม (ไม่ใช่ `1.0`) เพื่ออ่านง่าย — ค่าที่ใช้ตรวจยังเป็น float ตาม game-rules

### 2.7 S-7 หน้าจอหลัก (Home)

ไม่สร้างหน้าใหม่ (D-2): S-7 = `WaterHomeScreen` เดิม เพิ่มเพียงแบนเนอร์ต้อนรับ — "Widget สุขภาพ" ใน ux-flow = เนื้อหาเดิมของ water ทั้งหมด (สัตว์เลี้ยง หลอดพลังงาน ปุ่ม) ห้ามแก้ส่วนอื่นของ water

| # | องค์ประกอบ | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 0 | แบนเนอร์ต้อนรับ | `Text(textAlign: center, maxLines: 1, overflow: ellipsis)` วางเป็นลูกตัวแรกของ `Column` ใน `_buildContent` (ก่อน `Spacer()` ตัวแรก) แสดงเฉพาะเมื่อ `WaterHomeScreen` ได้รับชื่อ (พารามิเตอร์ใหม่แบบ optional, `null` = ไม่แสดง → เทสต์ water เดิมไม่เปลี่ยน) | 「สวัสดี <Display Name>」 **(เสนอ — รอยืนยัน, Q-12)** — `<Display Name>` คือค่าที่ประมวลผลแล้ว: ถ้ามาจากชื่อหน้าอีเมลและยาวเกิน `display_name_truncation_limit` (8) → 4 ตัวแรก + `...` + 2 ตัวท้าย (เช่น `alex...er`) ไม่เกิน 8 → แสดงตามจริง (AC-5) | `titleMedium` | `signup_home_welcome_text` |
| 1… | เนื้อหาเดิมของ water | ตาม `water_home_screen.dart` | ตามเดิม | ตามเดิม | key เดิมของ water |

## 3. สถานะของแต่ละหน้าจอ

ทุก loading ในปุ่ม: `onPressed: null` + child เป็น `Row(mainAxisSize: min)` [`SizedBox(20×20, CircularProgressIndicator(strokeWidth: 2))`, `SizedBox(width: 8)`, `Text(<ข้อความปุ่มเดิม>)`] — ไม่เปลี่ยนข้อความปุ่ม (ux-flow ไม่มีข้อความ loading) — สถานะ loading ทั้งหมด **(เสนอ — Q-15)** เพราะ ux-flow ไม่ได้กำหนด แต่เป็นการเรียกเครือข่ายที่ต้องกันกดซ้ำ

dialog เครือข่ายขัดข้อง (ใช้ร่วม S-1 EC-1 และ S-6 EC-4) — pattern เดียวกับ `steps_report_error_dialog`: `AlertDialog` ไม่มี title, `barrierDismissible: true` (ปิดแล้วกลับไปแก้ฟอร์มได้), content 「การเชื่อมต่อขัดข้อง กรุณาลองใหม่อีกครั้ง」 **(เสนอ — Q-16)**, action `FilledButton` 「ลองใหม่อีกครั้ง」 (ข้อความเดียวกับ `StepsRules.retryButtonText` — ux-flow เรียกแค่ "Retry", Q-16)

### S-1

| สถานะ | หน้าตา |
|---|---|
| ปกติ | ตาม §2.1 ปุ่มทุกปุ่ม enabled |
| กำลังเข้าสู่ระบบด้วย Google (loading) | `signup_google_button` disabled + spinner key `signup_google_loading_indicator`; ปุ่ม #12 และลิงก์ #14 disabled (`onPressed: null`) ระหว่างรอ |
| ผิดพลาด — เน็ตหลุดระหว่าง Google Login (EC-1, game-rules §4) | dialog เครือข่ายขัดข้อง key `signup_google_error_dialog`, ปุ่ม key `signup_google_retry_button` (กดแล้วเรียก Google Login ใหม่); ใต้ dialog หน้า S-1 กลับเป็นสถานะปกติ |

### S-2

| สถานะ | หน้าตา |
|---|---|
| ปกติ (เพิ่งเปิด) | ฟิลด์ว่างทั้ง 2 แสดง hint, ไม่มี error, `signup_submit_button` disabled (เทาจาง) |
| ว่าง (ลบข้อความจนหมด) | แสดง hint ในช่องนั้น; ถ้าช่องรหัสผ่านว่าง **ไม่**แสดง `signup_password_error_text` (ความยาว 0 = สถานะว่าง ไม่ใช่ error — Q-3); ปุ่ม disabled |
| ผิดพลาด — รหัสผ่านสั้น (AC-1) | ความยาว 1 ถึง `min_password_length − 1` (1–5): `signup_password_error_text` 「รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร」 สี error + ขอบช่องเป็นสี error (default M3) ทันทีขณะพิมพ์; ปุ่ม disabled |
| ผิดพลาด — อีเมลซ้ำ (AC-2, EC-5) — โหมดสมัคร | หลังกดปุ่มและระบบตอบกลับ: `signup_email_duplicate_error_text` 「อีเมลนี้ถูกใช้งานแล้ว」 ใต้ช่องอีเมล ขอบช่องสี error; ค่าที่กรอกคงอยู่; error หายเมื่อแก้ข้อความในช่องอีเมล **(เสนอ — Q-4)** |
| กำลังส่ง (loading) | `signup_submit_button` loading (spinner key `signup_submit_loading_indicator`), ฟิลด์ทั้งสอง `enabled: false` |
| disabled | ปุ่มดำเนินการ disabled เมื่อรหัสผ่าน < 6 ตัว หรืออีเมลว่าง/รูปแบบไม่ถูกต้อง (ux-flow "ถ้าย่อ/สั้นเกินไปจะ disable") — ไม่มีข้อความสำหรับอีเมลผิดรูปแบบ (Q-3) |

### S-3

| สถานะ | หน้าตา |
|---|---|
| ปกติ | ตาม §2.3 ปุ่ม enabled (ux-flow/game-rules ไม่มีพฤติกรรม disabled ของหน้านี้ — Q-7) |
| กำลังส่ง (loading) | ปุ่ม loading spinner key `signup_forgot_loading_indicator` |
| ผิดพลาด | ไม่กำหนด — ux-flow ไม่มีกรณีอีเมลไม่พบ/เน็ตหลุด (Q-7) |

### S-4

| สถานะ | หน้าตา |
|---|---|
| ปกติ | ตาม §2.4 (หน้าคงที่ ไม่มีสถานะอื่นใน ux-flow) — ถ้าไม่มีไฟล์ภาพ แสดง `Icons.mark_email_unread` ขนาด 160 สี default ของ Icon |

### S-5

| สถานะ | หน้าตา |
|---|---|
| ปกติ (เพิ่งเปิด) | ช่องว่างแสดง hint, ไม่มี error, ปุ่ม disabled |
| ผิดพลาด — รหัสผ่านใหม่สั้น (AC-3) | ความยาว 1–5: `signup_new_password_error_text` 「รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร」 สี error; ปุ่ม disabled (AC-3 "ระบบปฏิเสธการบันทึก") |
| กำลังบันทึก (loading) | ปุ่ม loading spinner key `signup_new_password_loading_indicator`, ช่อง `enabled: false` |

### S-6

| สถานะ | หน้าตา |
|---|---|
| ปกติ (เข้าครั้งแรก) | ค่าเริ่มต้น: เพศ `signup_gender_unspecified` ถูกเลือก, ช่องเป้าหมาย = 「ดูแลสุขภาพ」, ช่องอื่นว่าง (hint) — ผลตามกติกา: เห็น `signup_gender_warning_text`, `signup_weight_warning_text`, `signup_height_warning_text` ตั้งแต่เปิดหน้า (Q-8); ปุ่มบันทึก disabled เพราะอายุว่าง (Q-11) |
| เตือน — ไม่ระบุเพศ (AC-6) | `signup_gender_warning_text` สี tertiary ใต้ตัวเลือก — หายทันทีเมื่อเลือก 「ชาย」/「หญิง」; ไม่ทำให้ปุ่ม disabled (fallback rule ux-flow §6) |
| เตือน — ไม่กรอกน้ำหนัก/ส่วนสูง (AC-7) | warning ใต้ช่องที่ว่างเท่านั้น สี tertiary, ขอบช่องปกติ (ไม่ใช่สี error); ไม่ทำให้ปุ่ม disabled |
| ผิดพลาด — นอกขอบเขต (EC-2, game-rules §4) | error ใต้ช่องที่ผิดทันทีขณะพิมพ์ สี error + ขอบสี error; ปุ่มบันทึก disabled จนกว่าทุกช่องตัวเลขที่กรอกจะอยู่ในขอบเขต (ตัวอย่างที่ต้องขึ้น error: อายุ 0, 121 · น้ำหนัก 301 · ส่วนสูง 251) |
| Display Name ครบ 20 ตัว (EC-3) | ตัวนับแสดง `20/20`; พิมพ์ตัวที่ 21 แล้วข้อความไม่เปลี่ยน — ไม่มี error |
| กำลังบันทึก (loading) | ปุ่ม loading spinner key `signup_onboarding_loading_indicator`; ทุกช่อง `enabled: false` (ค่ายังแสดงอยู่) |
| ข้อผิดพลาดเครือข่าย (EC-4) | dialog เครือข่ายขัดข้อง key `signup_onboarding_error_dialog`, ปุ่ม key `signup_onboarding_retry_button`; ค่าทุกช่องคงเดิม (ฟอร์มยังอยู่ใต้ dialog ไม่ถูก rebuild ใหม่), ปุ่มบันทึกกลับเป็น enabled |

### S-7

| สถานะ | หน้าตา |
|---|---|
| ปกติ | `signup_home_welcome_text` + เนื้อหา water เดิม |
| เปิดแอปใหม่ (AC-8) | ผ่าน §2.0 (loading) แล้วไป S-7 ทันที ไม่เห็น S-1 |

## 4. ภาพสัตว์เลี้ยงแต่ละสถานะ

| สถานะ (game-rules §2) | ไฟล์ใน game-rules | สิ่งที่แสดงจริง | ขนาด | key |
|---|---|---|---|---|
| DEFAULT_PET | `assets/images/signup/s7_home_placeholder.png` | **ไม่ใช้ PNG** (D-1) — บน S-7 สัตว์เลี้ยงคือ `PetCharacter` ของ `WaterHomeScreen` เดิม ท่าทางตาม `WaterLogic.poseFor(mood)` (ผู้ใช้ใหม่ 0 แก้ว → `PetPose.waterCritical`) | 160 × 160 (ค่าเดิมของ water) | `water_pet_image_<mood>` บน `KeyedSubtree` (key เดิม ไม่เพิ่มใหม่) |

- หน้าจอ S-1 ถึง S-6 ไม่มีสัตว์เลี้ยง (ux-flow ไม่ได้วางไว้) — signup ไม่สร้าง/ไม่แก้ `PetCharacter`, `PetPose`, `pet_constants.dart`
- ความขัดแย้ง: DEFAULT_PET หมายถึง "สถานะเริ่มต้นหลัง Onboarding" แต่ water แสดง critical สำหรับผู้ใช้ใหม่ — ดู Q-14
- **งานของ Art (ถ้าเจ้าของต้องการ DEFAULT_PET แยก):** เพิ่ม preset `PetPose.signupDefault` ใน `pet_pose.dart` + แถวใน `character.md` §5 + preview — ข้อเสนอ: `PetPose(expression: PetExpression.content, body: PetBodyShape.normal)` (ใจดี สบาย ๆ แลบลิ้น เหมาะกับการทักทายครั้งแรก) ไม่ต้องเพิ่ม enum ใหม่

## 5. Checklist สำหรับ reviewer

- [ ] ไม่มี hex สีในโค้ด signup — สีทั้งหมดมาจาก `Theme.of(context).colorScheme` (seed `Colors.lightBlue` ใน `main.dart`)
- [ ] ไม่แก้ `ThemeData` ใน `app/lib/main.dart` และไม่เพิ่ม font ใน pubspec
- [ ] ตัวเลขทุกค่า (6, 20, 8, 1/120, 1.0/300.0, 1.0/250.0) และ 「ดูแลสุขภาพ」, `UNSPECIFIED` อ่านจากค่าคงที่ชุดเดียวตาม game-rules §1 ไม่ hardcode ในหน้าจอ
- [ ] ข้อความบนจอทุกข้อความตรงกับ ux-flow ตัวต่อตัว (ยกเว้นที่ spec ระบุ "เสนอ — รอยืนยัน")
- [ ] §2.0 ระหว่างอ่าน Token แสดง `CircularProgressIndicator` กลางจอ key `signup_auth_loading`
- [ ] S-1 ไม่มี AppBar, padding 24, โลโก้ 160×160 ผ่าน `AssetImageOrIcon` key `signup_welcome_logo` (fallback `Icons.pets`)
- [ ] S-1 หัวข้อ 「PetPal Health」 `headlineSmall`; คำโปรย `onSurfaceVariant`
- [ ] S-1 ปุ่ม Google เป็น `OutlinedButton.icon` key `signup_google_button` อยู่เหนือเส้นคั่น 「หรือ」
- [ ] S-1 ปุ่ม 「สมัครสมาชิกด้วยอีเมล」 เป็น `FilledButton.icon` key `signup_email_signup_button`; ลิงก์ 「มีบัญชีอยู่แล้ว? เข้าสู่ระบบ」 เป็น `TextButton` key `signup_have_account_link`
- [ ] S-1 EC-1: `AlertDialog` key `signup_google_error_dialog` มีปุ่ม key `signup_google_retry_button`
- [ ] S-2 AppBar มีปุ่มย้อนกลับ key `signup_email_back_button` และ title key `signup_email_header_text` (โหมดสมัคร 「สร้างบัญชีผู้ใช้」)
- [ ] S-2 ช่องอีเมล/รหัสผ่านใช้ `OutlineInputBorder()` default, hint ตรงตัว, ช่องรหัสผ่าน `obscureText: true`
- [ ] S-2 เปิดหน้ามา ปุ่ม `signup_submit_button` disabled (`onPressed: null`) และไม่มี error
- [ ] S-2 พิมพ์รหัสผ่าน 5 ตัว (`abcde`) → `signup_password_error_text` 「รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร」 + ปุ่ม disabled; ช่องว่างไม่แสดง error
- [ ] S-2 อีเมลซ้ำ → `signup_email_duplicate_error_text` 「อีเมลนี้ถูกใช้งานแล้ว」 ผ่าน `InputDecoration.error` (สี error default)
- [ ] S-2 ลิงก์ 「ลืมรหัสผ่าน?」 key `signup_forgot_password_link` ไป S-3
- [ ] S-3 title 「ลืมรหัสผ่าน」, คำอธิบาย, hint 「กรอกอีเมลของคุณ」, ปุ่ม 「ส่งลิงก์รีเซ็ตรหัสผ่าน」 key `signup_forgot_submit_button`
- [ ] S-4 ไม่มี AppBar, ภาพ 160×160 key `signup_reset_sent_image` (fallback `Icons.mark_email_unread`), หัวข้อ `headlineSmall`, ปุ่ม 「กลับสู่หน้าเข้าสู่ระบบ」 key `signup_back_to_login_button` ไป S-2
- [ ] S-5 AppBar ไม่มีปุ่มย้อนกลับ title 「ตั้งรหัสผ่านใหม่」; รหัสผ่าน 1–5 ตัว → `signup_new_password_error_text` 「รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร」 + ปุ่ม disabled
- [ ] S-5 บันทึกสำเร็จ → S-2 + `SnackBar` key `signup_password_reset_success_toast` (2 วินาที, `persist: false`, `hideCurrentSnackBar()` ก่อน)
- [ ] S-6 ใช้ `SingleChildScrollView` + padding 16 + ระยะระหว่างช่อง 16 + ก่อนปุ่ม 24; ไม่ overflow บนจอ 360 dp ขณะคีย์บอร์ดเปิด
- [ ] S-6 Display Name `maxLength` = ค่า `max_display_name_length` + `MaxLengthEnforcement.enforced` (พิมพ์ตัวที่ 21 ไม่ได้)
- [ ] S-6 อายุรับเฉพาะตัวเลข (`digitsOnly`); น้ำหนัก/ส่วนสูงใช้ `numberWithOptions(decimal: true)`
- [ ] S-6 เพศเป็น `RadioListTile` 3 ตัว 「ชาย」「หญิง」「ไม่ระบุ」 keys `signup_gender_male/female/unspecified`; เปิดหน้ามา `unspecified` ถูกเลือก
- [ ] S-6 เลือก 「ไม่ระบุ」 → `signup_gender_warning_text` 「ไม่สามารถคำนวณจำนวนแคลอรี่ที่เหมาะสมต่อวันได้」 สี `colorScheme.tertiary` `bodySmall`; เลือกชาย/หญิงแล้วหาย
- [ ] S-6 น้ำหนักว่าง → `signup_weight_warning_text`, ส่วนสูงว่าง → `signup_height_warning_text` ข้อความ 「จะไม่มีการแนะนำแคลอรี่ที่เหมาะสมต่อวัน」 สี tertiary (ไม่ใช่สี error)
- [ ] S-6 warning ไม่ทำให้ `signup_onboarding_save_button` disabled
- [ ] S-6 อายุ 0 / 121, น้ำหนัก 301, ส่วนสูง 251 → error key `signup_age/weight/height_error_text` สี error + ปุ่มบันทึก disabled
- [ ] S-6 ช่องเป้าหมายสุขภาพเริ่มต้นมีข้อความ 「ดูแลสุขภาพ」 อยู่ในช่องจริง (ไม่ใช่ hint) key `signup_health_goal_field`
- [ ] S-6 ปุ่ม 「บันทึกและเริ่มต้นใช้งาน」 `FilledButton` เต็มความกว้าง key `signup_onboarding_save_button`
- [ ] S-6 EC-4: `AlertDialog` key `signup_onboarding_error_dialog` ปุ่ม key `signup_onboarding_retry_button`; ปิด dialog แล้วค่าทุกช่องยังอยู่
- [ ] ปุ่มที่กำลังโหลดใช้ spinner 20×20 `strokeWidth: 2` + `onPressed: null` (ไม่ตั้งสีเทาเอง)
- [ ] S-7 = `WaterHomeScreen` เดิม; `signup_home_welcome_text` `titleMedium` อยู่บนสุดของ Column และไม่แสดงเมื่อไม่ส่งชื่อ (เทสต์ water เดิมผ่าน)
- [ ] S-7 อีเมล `alexander@email.com` + Display Name ว่าง → แบนเนอร์มี `alex...er`; ชื่อหน้าอีเมล ≤ 8 ตัวแสดงเต็ม
- [ ] ไม่มีการวาด/สร้างสัตว์เลี้ยงใน signup และไม่แก้ไฟล์ใน `app/lib/shared/pet/`; ไม่มีการโหลด `s7_home_placeholder.png` เป็นภาพสัตว์เลี้ยง
- [ ] ไม่มีหน้าจออื่นนอกจาก S-1 ถึง S-7 (§2.0 เป็นแค่สถานะ loading)

## 6. คำถามที่ค้าง

| # | ประเด็น | ทางที่ spec เลือกไว้ชั่วคราว |
|---|---|---|
| Q-1 | ux-flow ไม่บอกว่า MVP มี backend/เครือข่ายจริงหรือไม่ (steps ตัดสินว่าไม่มี network — steps D-2) และ `pubspec.yaml` ยังไม่มี package Google Sign-In / Secure Storage — สถานะอีเมลซ้ำ, EC-1, EC-4 จะ trigger อย่างไร | spec กำหนดหน้าตาครบทุกสถานะ Dev สร้าง widget ไว้; วิธี trigger ให้เจ้าของตัดสิน (ถ้าไม่มี backend ให้ซ่อนไว้หลัง flag สำหรับเทสต์แบบ steps Q-4/Q-5) |
| Q-2 | S-2 ปุ่มมี 2 ข้อความ 「ดำเนินการต่อ」/「สมัครสมาชิก」 แต่ไม่บอกว่าใช้เมื่อไร และโหมดเข้าสู่ระบบ (จากลิงก์ S-1) ไม่มี title/ข้อความใด ๆ | โหมดสมัคร = title 「สร้างบัญชีผู้ใช้」 + ปุ่ม 「สมัครสมาชิก」 (ตาม happy path ข้อ 3); โหมดเข้าสู่ระบบ = title 「เข้าสู่ระบบ」 (เสนอ, ยืมจากลิงก์ S-1) + ปุ่ม 「ดำเนินการต่อ」 |
| Q-3 | S-2 ไม่มีข้อความ error สำหรับอีเมลผิดรูปแบบ; AC-1 ว่า "≤ 5 ตัว" แสดง error ทันที แต่สถานะปกติ (ช่องว่าง = 0 ตัว) ไม่มี error | อีเมลผิดรูปแบบ: ปุ่ม disabled โดยไม่มีข้อความ; รหัสผ่าน 0 ตัว = สถานะว่าง ไม่แสดง error, 1–5 ตัวแสดง error |
| Q-4 | S-2 error อีเมลซ้ำ หายเมื่อไร ux-flow ไม่กำหนด | หายเมื่อผู้ใช้แก้ข้อความในช่องอีเมล |
| Q-5 | ข้อความ error รหัสผ่าน S-2 「รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร」 กับ S-5 「รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร」 ต่างกัน (กติกาเดียวกัน `min_password_length`) | ใช้ตาม ux-flow ตรงตัวแต่ละหน้า — แนะนำให้ Design รวมเป็นข้อความเดียว |
| Q-6 | S-5 "พาไปหน้า S-2 พร้อมข้อความสำเร็จ" แต่ไม่มีข้อความ | SnackBar 「บันทึกรหัสผ่านใหม่เรียบร้อยแล้ว」 (เสนอ) |
| Q-7 | S-3/S-5: ไม่มีสถานะ error (อีเมลไม่พบในระบบ, เน็ตหลุด, ลิงก์หมดอายุ), ไม่บอกว่ากดส่งตอนช่องว่างได้หรือไม่ และ S-5 ถูกเปิดอย่างไร (deep link จากอีเมล) | S-3 ปุ่ม enabled เสมอ ไม่มีหน้าตา error; S-5 ออกแบบเป็นหน้าเดี่ยวไม่มีปุ่มย้อนกลับ — ทางเข้า S-5 รอ Tech Lead |
| Q-8 | S-6 ตัวเลือกเพศใน ux-flow เขียน `MALE (ชาย)` ฯลฯ ไม่ชัดว่าแสดงทั้งอังกฤษ+ไทยหรือไม่; และค่าเริ่มต้น `UNSPECIFIED` + ช่องน้ำหนัก/ส่วนสูงว่าง ทำให้ warning ทั้ง 3 ขึ้นตั้งแต่เปิดหน้า ซึ่งสถานะ "ปกติ" ใน ux-flow §4 ไม่ได้พูดถึง | แสดงเฉพาะคำไทย 「ชาย」「หญิง」「ไม่ระบุ」 (ตรงกับ requirements §6, AC-6); warning แสดงตามค่าปัจจุบันตั้งแต่เปิดหน้า (ไม่รอผู้ใช้แตะช่อง) |
| Q-9 | S-6 ไม่มีหัวข้อ/label ของกลุ่มเพศ | 「เพศ」 (เสนอ) `titleMedium` |
| Q-10 | S-6 ช่องเป้าหมายสุขภาพไม่มี placeholder/label (มีแค่ค่าเริ่มต้น); ถ้าผู้ใช้ลบจนว่างจะบันทึกอะไร | labelText 「เป้าหมายสุขภาพ」 (เสนอ); พฤติกรรมเมื่อว่างเป็นของ game-rules — ไม่กำหนดใน spec |
| Q-11 | S-6 ข้อความ error นอกขอบเขต (EC-2) ไม่มีใน ux-flow; brief บอกอายุ "บังคับกรอก" แต่ ux-flow/game-rules ไม่พูดถึงอายุว่าง; ทศนิยมของน้ำหนัก/ส่วนสูงไม่กำหนด | error เสนอ 「อายุต้องอยู่ระหว่าง 1–120 ปี」 「น้ำหนักต้องอยู่ระหว่าง 1–300 กิโลกรัม」 「ส่วนสูงต้องอยู่ระหว่าง 1–250 เซนติเมตร」; อายุว่าง → ปุ่มบันทึก disabled โดยไม่มีข้อความ (ตาม brief); น้ำหนัก/ส่วนสูงรับทศนิยมได้ไม่จำกัดหลักในระดับ UI |
| Q-12 | S-7 แบนเนอร์ต้อนรับมีแค่ "แสดง Display Name" ไม่มีคำทักทาย และไม่บอกว่าแสดงทุกครั้งหรือครั้งแรกเท่านั้น | 「สวัสดี <Display Name>」 (เสนอ) แสดงทุกครั้งที่อยู่ S-7 |
| Q-13 | ux-flow มี S-7 แยก แต่แอปมี home อยู่แล้ว (`WaterHomeScreen`) | S-7 = `WaterHomeScreen` + แบนเนอร์ (D-2) ไม่สร้างหน้า home ที่สอง |
| Q-14 | game-rules §2 ให้ DEFAULT_PET ใช้ `s7_home_placeholder.png` แต่ owner ตัดสินแล้วว่าทั้งแอปใช้ `PetCharacter` (D-1); และผู้ใช้ใหม่บน water จะเห็นสัตว์เลี้ยง critical (0 แก้ว) ไม่ใช่ "สถานะเริ่มต้น" | ไม่ใช้ PNG; S-7 แสดงตามกติกา water เดิม (ไม่เปลี่ยนกติกา water) — ถ้าต้องการ DEFAULT_PET แยก ต้องให้ game-rules กำหนดเงื่อนไข และ Art เพิ่ม preset `PetPose.signupDefault` (§4) |
| Q-15 | ux-flow ไม่มีสถานะ loading ใด ๆ (สมัคร, Google, ส่งลิงก์, บันทึก, เปิดแอป) | ปุ่ม disabled + spinner 20×20 ข้อความปุ่มเดิม; เปิดแอป = spinner กลางจอ (pattern water/steps) |
| Q-16 | EC-1/EC-4 บอกแค่ "แสดงปุ่ม Retry / Timeout" ไม่มีข้อความหรือรูปแบบ | `AlertDialog` แบบ `steps_report_error_dialog`: content 「การเชื่อมต่อขัดข้อง กรุณาลองใหม่อีกครั้ง」 (เสนอ) + ปุ่ม 「ลองใหม่อีกครั้ง」 (ข้อความเดียวกับ steps) |
| Q-17 | S-1 ปุ่ม Google ไม่มีไฟล์โลโก้ Google ใน ux-flow §5 (แนวทางแบรนด์ Google ปกติต้องมีโลโก้) | ใช้ `Icons.login` ชั่วคราว — ถ้าต้องการโลโก้ Google ให้เพิ่มไฟล์ใน ux-flow §5 แล้วเปลี่ยนเป็น `AssetImageOrIcon` |
| Q-18 | `pubspec.yaml` ลงทะเบียนแค่ `assets/images/` (ไม่รวมโฟลเดอร์ย่อย) → ไฟล์ใน `assets/images/signup/` จะไม่ถูก bundle และไฟล์ยังไม่มีใน repo | ใช้ `AssetImageOrIcon` ซึ่งแสดง fallback icon เมื่อไม่มีไฟล์ — Dev ต้องเพิ่ม `assets/images/signup/` ใน pubspec เมื่อมีไฟล์ |
| Q-19 | การนับ "ตัวอักษร" ของ Display Name / รหัสผ่านกับอักษรไทยที่มีสระบน-ล่าง/วรรณยุกต์ (`maxLength` ของ Flutter นับเป็น grapheme cluster ซึ่งอาจไม่ตรงกับการนับฝั่งฐานข้อมูล) | ใช้การนับของ `TextField.maxLength` (grapheme) — รอ Tech Lead ยืนยันให้ตรงกับฝั่งบันทึก |
| Q-20 | กติกาตัดคำ AC-5 (4 ตัวแรก + `...` + 2 ตัวท้าย) กับชื่อยาว 9 ตัว ได้ผลยาว 9 ตัวเท่าเดิม (`alexander` → `alex...er`) จึงไม่ได้ประหยัดพื้นที่; และ ux-flow ไม่บอกว่าชื่อที่ผู้ใช้พิมพ์เอง (≤ 20) ต้องตัดด้วยหรือไม่ | ทำตาม AC-5 ตรงตัว ตัดเฉพาะชื่อที่ได้จากหน้าอีเมล; ชื่อที่พิมพ์เองแสดงเต็มพร้อม `maxLines: 1` + ellipsis กันล้น |
| Q-21 | AC-2 ว่า Google Login ที่อีเมลซ้ำ "พาไปหน้า Onboarding ทันที" แต่ ux-flow S-1 ว่า "พาไป S-6 หรือ S-7"; S-2 โหมดเข้าสู่ระบบสำเร็จแล้วไป S-6 หรือ S-7 ก็ไม่ระบุ | ไม่กำหนดใน spec (เป็น flow) — UI ของทั้ง S-6 และ S-7 พร้อมรองรับทั้งสองทาง |
| Q-22 | ระบบ back ของเครื่องบน S-4/S-5/S-6 (ไม่มีปุ่มย้อนกลับใน ux-flow) | S-4/S-5/S-6 ไม่มีปุ่มย้อนกลับใน AppBar; การดัก back ของระบบเป็นเรื่อง flow — รอ Tech Lead |
