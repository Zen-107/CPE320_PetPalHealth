# UI spec: การนับก้าวและการตั้งเป้าหมายประจำวัน (steps)

> สถานะ: draft · ผู้เขียน: UI agent · อ้างอิง: ux-flow.md, game-rules.md (บริบท: requirements.md)
> เอกสารนี้กำหนด "หน้าตา" เท่านั้น — ตัวเลข กติกา และ flow ให้ยึด ux-flow.md / game-rules.md
> ไม่มี ui-spec.md ของฟีเจอร์อื่นมาก่อน จึงอ้างหน้าตาจากโค้ดฟีเจอร์ water ใน `app/lib/` เป็นมาตรฐาน

## 0. ข้อตัดสินใจจากเจ้าของโปรเจกต์ (MVP รอบนี้)

ข้อเหล่านี้เป็นการตัดสินใจของเจ้าของโปรเจกต์ ไม่ใช่ของ UI agent — spec นี้แค่กำหนดหน้าตาให้รองรับ

| # | ข้อตัดสินใจ | ผลต่อ UI |
|---|---|---|
| D-1 | ก้าวเดินกรอก**ด้วยมือผ่านปุ่ม** ไม่ใช้ Health API / เซนเซอร์ pedometer จริง | เพิ่ม "ปุ่มเพิ่มก้าวเดิน" บน S-1 (เป็น control บน S-1 ไม่ใช่หน้าจอใหม่) — ข้อความปุ่มเป็นข้อเสนอ ดู Q-1, Q-2 |
| D-2 | ไม่มี network/server — "Server Database" ในเอกสาร = local storage บนเครื่องใน MVP | สถานะที่พึ่ง server/เซนเซอร์ (S-1 Error/Denied, S-1 Disabled ออฟไลน์, S-2 server error) ยังต้องมีหน้าตาตาม ux-flow แต่จะถูก trigger อย่างไรใน MVP ดู Q-4, Q-5, Q-6 |
| D-3 | ต้องเข้า Steps ได้จากแอปเดิม (หน้า home ปัจจุบันคือ water) | ux-flow ไม่มีทางเข้า S-1 — spec กำหนดหน้าตาทางเข้าแบบน้อยที่สุด (ปุ่มใน AppBar ของ water) ไม่เพิ่มหน้าจอ ดู Q-3 |

## 1. Design tokens

ทุกสีของ component มาตรฐานให้ดึงจาก `Theme.of(context).colorScheme` / `textTheme` เท่านั้น ห้าม hardcode hex ในหน้าจอ (ยกเว้นสีวาดภาพสัตว์เลี้ยง ซึ่งเป็นแบบเดียวกับ water)

### 1.1 สี

| Token | ค่า | ใช้ที่ไหน | ที่มา |
|---|---|---|---|
| Seed color | `Colors.lightBlue` | ทุก ColorScheme | `app/lib/main.dart` → `ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue))` |
| ปุ่มหลัก / แถบ progress | `colorScheme.primary` (ค่า default ของ `FilledButton`, `LinearProgressIndicator`) | ปุ่มเพิ่มก้าวเดิน, ปุ่มบันทึกเป้าหมาย, ปุ่มดาวน์โหลดรายงาน, หลอดพลังงาน | ของเดิม: `water_home_screen.dart` (`water_log_button`, `water_energy_bar`) ใช้ default theme |
| ชิปที่ถูกเลือก | `colorScheme.secondaryContainer` (ค่า default ของ `ChoiceChip` selected ใน M3) | S-2 ชิปเป้าหมาย | default ของ Material 3 จาก ColorScheme เดิม — ไม่ตั้งค่าใหม่ |
| ป้ายสถานะ (Badge) | พื้น `colorScheme.secondaryContainer`, ตัวอักษร `colorScheme.onSecondaryContainer` | S-1 ป้ายสถานะสัตว์เลี้ยง | role ใน ColorScheme เดิม — ไม่ตั้งค่าใหม่ |
| Disabled "สีเทาจาง" | สี disabled มาตรฐานของ Material 3 (`onSurface` alpha 0.12 พื้น / 0.38 ตัวอักษร) ได้เองเมื่อ `onPressed: null` | S-2 ปุ่มบันทึก (quota หมด), S-3 ปุ่มดาวน์โหลด (กำลัง export) | default ของ `FilledButton` — ห้ามตั้งสีเทาเอง |
| ไอคอนออฟไลน์ | `colorScheme.onSurfaceVariant` | S-1 สถานะ Disabled | role ใน ColorScheme เดิม |
| สีตัวสัตว์เลี้ยง (วาด) | `0xFFD9D4E7` ม่วงเทาซีด | FAT | `app/lib/features/water/widgets/pet_painter.dart` → `PetPainter._criticalBody` |
| | `0xFFFFE0B2` พีชอ่อน | CHUBBY | `PetPainter._tiredBody` |
| | `0xFFB9F2D0` มิ้นต์อ่อน | LEAN, MUSCLE | `PetPainter._happyBody` |
| เส้นขอบ/ตา/ปาก | `0xFF6D6875` | ทุกสถานะ | `PetPainter._outline` |
| แก้ม | `0xFFFFB5C2` (alpha 0.8 ตามของเดิม) | CHUBBY, LEAN, MUSCLE | `PetPainter._cheek` |
| หยดเหงื่อ | `0xFFA8D8FF` | FAT | `PetPainter._sweat` |
| ประกาย | `0xFFFFE57F` | MUSCLE | `PetPainter._sparkle` |

> หมายเหตุ Dev: สีใน `PetPainter` เป็น `static const` แบบ private — ให้ใช้ค่า hex เดียวกันพร้อมคอมเมนต์อ้างชื่อเดิม หรือย้ายเป็น public const ที่ใช้ร่วมกันก็ได้ (ห้ามเปลี่ยนค่า)

### 1.2 ตัวอักษร

ไม่มี custom font ใน `app/pubspec.yaml` → ใช้ฟอนต์ default ของ Material (รองรับไทยจากระบบ) ใช้ `Theme.of(context).textTheme` เท่านั้น

| ใช้กับ | style | ที่มา |
|---|---|---|
| หัวข้อหน้าจอ (AppBar title) | default ของ `AppBar` | `water_home_screen.dart`, `monthly_report_screen.dart` |
| ตัวเลขก้าวเดิน S-1 | `textTheme.headlineSmall` | `water_home_screen.dart` → `water_count_text` |
| ข้อความ % Goal S-1 | default (`bodyMedium`) | `water_home_screen.dart` → `water_energy_text` |
| ป้ายสถานะสัตว์เลี้ยง S-1 | `textTheme.titleMedium` | role ใน textTheme เดิม (water ใช้ `titleLarge` กับข้อความสถานะ — steps ย่อลง 1 ขั้นเพราะอยู่ในป้าย) |
| หัวกลุ่มเป้าหมาย S-2 | `textTheme.titleMedium` | role ใน textTheme เดิม |
| ตัวเลขในการ์ดสรุป S-3 | `textTheme.titleLarge` | `monthly_report_screen.dart` → `water_monthly_average_text` |
| ชื่อตัวแปรในการ์ด S-3 | default (`bodyMedium`) | ListTile default |

### 1.3 ระยะห่าง ขนาด มุมโค้ง

| Token | ค่า | ที่มา |
|---|---|---|
| Padding หน้าหลัก (S-1) | 24 รอบด้าน | `water_home_screen.dart` → `EdgeInsets.all(24)` |
| Padding หน้ารอง (S-2, S-3) | 16 รอบด้าน | `monthly_report_screen.dart` → `EdgeInsets.all(16)` |
| ช่องไฟ | 8 / 16 / 24 | `water_home_screen.dart` → `SizedBox(height: 8/16/24)` |
| ขนาดภาพสัตว์เลี้ยง | 160 × 160 | `pet_avatar.dart` → `PetAvatar.size` default 160 |
| ความสูงหลอดพลังงาน | `minHeight: 20` | `water_home_screen.dart` → `water_energy_bar` |
| มุมโค้งหลอดพลังงาน / ป้ายสถานะ | `BorderRadius.circular(8)` | `water_home_screen.dart` → `ClipRRect` ของ energy bar |
| ขนาดไอคอน | 24 | `asset_image_or_icon.dart` → `AssetImageOrIcon.size` default 24 |
| ระยะเวลา SnackBar (Toast) | 2 วินาที, `persist: false` | `water_rules.dart` → `WaterRules.antiSpamToastSeconds` (ใช้ชั่วคราว ดู Q-8) |
| สัดส่วนรูปร่างสัตว์เลี้ยงตามสถานะ | ดู §4.2 | **ใหม่** — เหตุผล: water วาดตัวเดียวขนาดเดียว (`body width s*0.78`) แต่ steps ต้องแสดง "รูปร่าง" 4 แบบ (อ้วน→มีกล้าม) จึงต้องมีความกว้างตัวและขาต่างกัน เป็นค่าการแสดงผล ไม่ใช่ตัวเลขกติกาเกม |

## 2. หน้าจอ

ข้อความในเครื่องหมาย「」ต่อไปนี้คัดลอกตรงตัวจาก ux-flow.md — ห้ามแก้ ข้อความที่ ux-flow ไม่มีและ spec เสนอไว้ชั่วคราว ระบุว่า **(เสนอ — รอยืนยัน)**

### 2.0 ทางเข้า S-1 จากหน้า water (D-3)

- ตำแหน่ง: `AppBar.actions` ของ `WaterHomeScreen` วางก่อนปุ่ม `water_monthly_report_button`
- Widget: `TextButton.icon` แบบเดียวกับ `water_monthly_report_button` (`water_home_screen.dart`)
- icon: `Icon(Icons.directions_walk)` ขนาด 24
- label: 「ก้าวเดินประจำวัน」 (ยืมข้อความหัวข้อ S-1 จาก ux-flow) **(รอยืนยัน — Q-3)**
- กดแล้ว `Navigator.push(MaterialPageRoute(...))` ไป S-1 (เหมือน `_openMonthlyReport`)
- ValueKey: `steps_entry_button`
- หมายเหตุ: AppBar มี 2 ปุ่มข้อความไทย อาจล้นบนจอแคบ — ถ้าล้น ให้ใช้ `IconButton` (icon เดิม + `tooltip:` 「ก้าวเดินประจำวัน」) แทน key เดิม

### 2.1 S-1 หน้าหลักแดชบอร์ดก้าวเดิน (Steps Dashboard)

โครง: `Scaffold` → `AppBar` → body `ListenableBuilder` (ตาม pattern water) → `SafeArea` → `Padding(24)` → `Column(crossAxisAlignment: stretch)`
ถ้าความสูงจอไม่พอ ให้ห่อด้วย `SingleChildScrollView` + `ConstrainedBox(minHeight)` + `IntrinsicHeight` เพื่อคง `Spacer` ได้ (ห้ามให้ overflow)

พื้นหลัง: `assets/images/bg_dashboard.png` วางเป็น `DecorationImage`/`Image.asset(fit: BoxFit.cover)` ใต้เนื้อหา — ถ้าไม่มีไฟล์ (`errorBuilder`) ให้แสดงพื้น `colorScheme.surface` ตามปกติ ไม่ทำให้แอปล่ม (ไฟล์ยังไม่มีใน repo)

จากบนลงล่าง:

| # | องค์ประกอบ | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 1 | ส่วนหัวข้อ | `AppBar(title: Text(...))` — มีปุ่มย้อนกลับอัตโนมัติเพราะถูก push จาก water | 「ก้าวเดินประจำวัน」 | AppBar default | `steps_header_text` (บน `Text`) |
| 1a | ไอคอนออฟไลน์ (เฉพาะสถานะ Disabled) | `AppBar.actions` → `Icon(Icons.cloud_off)` + `Tooltip` | tooltip: 「ออฟไลน์」 **(เสนอ — รอยืนยัน, Q-5)** | `colorScheme.onSurfaceVariant`, 24 | `steps_offline_icon` |
| 2 | `Spacer()` | | | | |
| 3 | รูปสัตว์เลี้ยง | `StepsPetAvatar` (ใหม่ ตาม pattern `PetAvatar`) ใน `Center` | ภาพตามสถานะ §4 | 160 × 160 | `steps_pet_image_<status>` (status = `fat` / `chubby` / `lean` / `muscle`) |
| 4 | `SizedBox(height: 16)` | | | | |
| 5 | ป้ายสถานะสัตว์เลี้ยง | `Center` → `Chip` (ไม่กดได้) หรือ `Container` + `BorderRadius.circular(8)` padding แนวนอน 16 แนวตั้ง 8 | 「อ้วนอืด」 / 「จ่ำม่ำ」 / 「หุ่นลีน (สมส่วน)」 / 「มีกล้ามขา」 | พื้น `secondaryContainer`, ตัวอักษร `onSecondaryContainer` + `titleMedium` | `steps_status_badge` |
| 6 | `SizedBox(height: 24)` | | | | |
| 7 | หลอดพลังงาน | `ClipRRect(BorderRadius.circular(8))` → `LinearProgressIndicator(value: fraction, minHeight: 20)` | `value` = %Goal/100 **clamp 0.0–1.0** (widget รับเกิน 1 ไม่ได้ — เกิน 100% หลอดเต็ม) | primary / default track | `steps_energy_bar` |
| 8 | `SizedBox(height: 8)` | | | | |
| 9 | ข้อความ % Goal | `Text(textAlign: center)` | `<ค่า>%` ค่าจริงไม่ clamp (เกิน 100% ได้ เช่น `106.25%`) — รูปแบบตัวเลข ดู Q-7 | default | `steps_percent_text` |
| 10 | `SizedBox(height: 16)` | | | | |
| 11 | ตัวเลขก้าวเดิน | `Text(textAlign: center)` | รูปแบบ 「5,500 / 8,000 ก้าว」 → `'<ก้าว> / <เป้าหมาย> ก้าว'` ใส่ comma คั่นหลักพัน | `headlineSmall` | `steps_count_text` |
| 12 | `Spacer()` | | | | |
| 13 | ปุ่มเพิ่มก้าวเดิน (D-1) | `FilledButton.icon` | label 「เพิ่มก้าวเดิน」 **(เสนอ — รอยืนยัน, Q-1)**, icon `Icons.directions_walk` | primary (เหมือน `water_log_button`) | `steps_add_button` |
| 14 | `SizedBox(height: 16)` | | | | |
| 15 | แถวปุ่มนำทาง | `Row` → 2 × `Expanded(TextButton.icon(...))` (pattern เดียวกับ `water_monthly_report_button`) | | | |
| 15a | ปุ่มตั้งเป้าหมาย | `TextButton.icon`, icon = `AssetImageOrIcon(assetPath: 'assets/icons/ic_target.png', fallbackIcon: Icons.flag)` | 「ตั้งเป้าหมาย」 | primary (default TextButton) | `steps_set_goal_button` |
| 15b | ปุ่มดูรายงานรายเดือน | `TextButton.icon`, icon = `AssetImageOrIcon(assetPath: 'assets/icons/ic_report.png', fallbackIcon: Icons.bar_chart)` | 「รายงานสรุปรายเดือน」 | primary (default TextButton) | `steps_monthly_report_button` |

เมื่อค่าเปลี่ยน: ภาพ/ป้าย/หลอด/ตัวเลขเปลี่ยนทันทีใน frame ถัดไป (ไม่ต้องมี animation; ถ้าจะใส่ `AnimatedSwitcher` ให้ key ของภาพยังเป็น `steps_pet_image_<status>`)

### 2.2 S-2 หน้าตั้งเป้าหมายประจำวัน (Daily Goal Settings)

โครง: `Scaffold` → `AppBar` → body `Padding(16)` → `Column(crossAxisAlignment: stretch)` (เนื้อหาเลื่อนได้ด้วย `SingleChildScrollView` ถ้าล้น) — ปุ่มบันทึกอยู่ล่างสุด

| # | องค์ประกอบ | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 1 | ปุ่มย้อนกลับ | `AppBar.leading: IconButton(icon: Icon(Icons.arrow_back))` แบบเดียวกับ `water_report_back_button` | ไอคอนลูกศรย้อนกลับ, tooltip ใช้ `WaterRules.backButtonText` (「ย้อนกลับ」) หรือค่าเดียวกันใน steps | AppBar default | `steps_goal_back_button` |
| 2 | หัวข้อหน้าจอ | `AppBar(title: Text(...))` | 「ตั้งเป้าหมายก้าวเดินประจำวัน」 | AppBar default | `steps_goal_header_text` |
| 3 | หัวกลุ่ม 1 | `Text` | 「กลุ่มเป้าหมายทั่วไป」 (ชื่อองค์ประกอบใน ux-flow — Q-9) | `titleMedium` | `steps_goal_group_general` |
| 4 | `SizedBox(height: 8)` | | | | |
| 5 | ชิปกลุ่ม 1 | `Wrap(spacing: 8, runSpacing: 8)` → `ChoiceChip` × 3 | 「6,000 ก้าว」 「7,000 ก้าว」 「8,000 ก้าว」 | M3 ChoiceChip default | `steps_goal_chip_6000`, `steps_goal_chip_7000`, `steps_goal_chip_8000` |
| 6 | `SizedBox(height: 24)` | | | | |
| 7 | หัวกลุ่ม 2 | `Text` | 「กลุ่มควบคุมน้ำหนัก」 | `titleMedium` | `steps_goal_group_weight` |
| 8 | `SizedBox(height: 8)` | | | | |
| 9 | ชิปกลุ่ม 2 | `Wrap` → `ChoiceChip` × 4 | 「9,000 ก้าว」 「10,000 ก้าว」 「11,000 ก้าว」 「12,000 ก้าว」 | | `steps_goal_chip_9000` … `steps_goal_chip_12000` |
| 10 | `SizedBox(height: 24)` | | | | |
| 11 | หัวกลุ่ม 3 | `Text` | 「กลุ่มนักกีฬา」 | `titleMedium` | `steps_goal_group_athlete` |
| 12 | `SizedBox(height: 8)` | | | | |
| 13 | ชิปกลุ่ม 3 | `Wrap` → `ChoiceChip` × 3 | 「13,000 ก้าว」 「14,000 ก้าว」 「15,000 ก้าว」 | | `steps_goal_chip_13000`, `steps_goal_chip_14000`, `steps_goal_chip_15000` |
| 14 | `Spacer()` / ช่องว่าง | | | | |
| 15 | ปุ่มบันทึกเป้าหมาย | `FilledButton` เต็มความกว้าง | 「บันทึกเป้าหมาย」 | primary; disabled = default M3 | `steps_goal_save_button` |

- เลือกได้ทีละ 1 ชิปจากทั้ง 3 กลุ่มรวมกัน (ทั้งหน้า 1 ค่า) — ชิปที่เลือก `selected: true` แสดง checkmark ตาม default M3
- ค่าชิปทั้งหมดต้องอ่านจากค่าคงที่ใน game-rules (ไม่ hardcode เลขซ้ำในหน้าจอ) — key ใช้ตัวเลขไม่มี comma
- Toast ทั้งหมดใช้ `ScaffoldMessenger` → `hideCurrentSnackBar()` แล้ว `showSnackBar(SnackBar(...))` ตาม pattern `water_anti_spam_toast`

### 2.3 S-3 หน้ารายงานสรุปผลรายเดือน (Monthly Report Export)

โครง: `Scaffold` → `AppBar` → body `Padding(16)` → `Column(crossAxisAlignment: stretch)`

| # | องค์ประกอบ | Widget | ข้อความ / ค่า | style / token | ValueKey |
|---|---|---|---|---|---|
| 1 | ปุ่มย้อนกลับ | `AppBar.leading: IconButton(Icons.arrow_back)` แบบ `water_report_back_button` | ไอคอนลูกศรย้อนกลับ | | `steps_report_back_button` |
| 2 | หัวข้อหน้าจอ | `AppBar(title: Text(...))` | 「รายงานสุขภาพประจำเดือน」 | AppBar default | `steps_report_header_text` |
| 3 | พื้นที่ที่จะถูก export เป็น PNG | `RepaintBoundary` ห่อข้อ 3a–3b (ใช้ `RenderRepaintBoundary.toImage()` สร้าง PNG 1 หน้า) พื้น `colorScheme.surface` padding 16 | | | `steps_report_capture` |
| 3a | หัวข้อในภาพ | `Text` | 「รายงานสุขภาพประจำเดือน」 (ให้ภาพ PNG มีหัวข้อในตัว) | `titleLarge` | - |
| 3b | การ์ดสรุปข้อมูล 4 ตัวแปร | `Card` → `Column` → 4 × `ListTile(title: ชื่อ, trailing: ค่า)` คั่นด้วย `Divider(height: 1)` (pattern รายการของ `monthly_report_screen.dart`) | title ตามลำดับ: 「ก้าวเดินรวมประจำเดือน」 「ปริมาณน้ำดื่มรวมประจำเดือน」 「ค่าเฉลี่ยก้าวเดินรายวัน」 「จำนวนวันที่ทำเป้าหมายสำเร็จ」 — trailing เป็นตัวเลข + หน่วย (หน่วย/ทศนิยม ดู Q-10) | title default, trailing `titleLarge` | การ์ด `steps_report_summary_card`; ค่า: `steps_report_total_steps`, `steps_report_total_water`, `steps_report_avg_steps`, `steps_report_goal_days` |
| 4 | ข้อความว่าง (เฉพาะสถานะ Empty) | `Text(textAlign: center)` ใต้การ์ด ระยะ 16 | 「ยังไม่มีข้อมูลสรุปผลในเดือนนี้」 | default (เหมือน `water_monthly_empty_text`) | `steps_report_empty_text` |
| 5 | `Spacer()` | | | | |
| 6 | ปุ่มส่งออกรายงาน | `FilledButton.icon` เต็มความกว้าง, icon `Icons.download` | 「ดาวน์โหลดรายงาน (PNG)」 | primary | `steps_report_export_button` |

## 3. สถานะของแต่ละหน้าจอ

### S-1

| สถานะ | หน้าตา |
|---|---|
| ปกติ (Normal) | ตาม §2.1 ครบทุกองค์ประกอบ ไม่มี `steps_offline_icon` ปุ่มทุกปุ่ม enabled |
| ว่าง/เริ่มต้นวันใหม่ (Empty/Initial) | `steps_count_text` = 「0 / <เป้าหมาย> ก้าว」 (เช่น `0 / 8,000 ก้าว`), `steps_percent_text` = 「0%」, `steps_energy_bar` value 0.0, ภาพ `steps_pet_image_fat`, ป้าย 「อ้วนอืด」 — layout เดิม ไม่มีข้อความพิเศษ |
| ผิดพลาด/ปฏิเสธสิทธิ์ (Error/Denied) | แสดง `AlertDialog` (Pop-up) `barrierDismissible: false` — key `steps_sensor_error_dialog`; title/เนื้อหา **(เสนอ — รอยืนยัน, Q-4)**: title 「ไม่สามารถนับก้าวเดินได้」, content 「กรุณาอนุญาตสิทธิ์เซนเซอร์นับก้าวในหน้า Settings ของเครื่อง」; actions: `FilledButton` 「ไปที่ Settings」 key `steps_open_settings_button` (Shortcut ไปหน้า Settings ของเครื่อง) — ใต้ dialog ปุ่ม `steps_add_button` เป็น disabled (ล็อกฟังก์ชันนับก้าวตาม game-rules §4) |
| ปิดการใช้งาน/จำกัดสิทธิ์ (Disabled — ออฟไลน์) | layout ปกติ แสดงค่าล่าสุดจาก Local Storage + `Icon(Icons.cloud_off)` key `steps_offline_icon` ใน `AppBar.actions` สี `onSurfaceVariant` — ไม่มี dialog ไม่เปลี่ยนสีอื่น |

### S-2

| สถานะ | หน้าตา |
|---|---|
| ปกติ (Normal) | ชิปครบ 10 ตัว enabled, ชิปของเป้าหมายปัจจุบัน `selected`, `steps_goal_save_button` enabled (primary) |
| ว่าง/เริ่มต้นวันใหม่ (Empty/Initial) | เหมือนปกติ โดย `steps_goal_chip_8000` ถูก `selected` ไว้ล่วงหน้า (DEFAULT_DAILY_GOAL) |
| ผิดพลาด (Error — บันทึกไม่สำเร็จ) | layout ไม่เปลี่ยน, ชิปที่ผู้ใช้เลือกยังคงเลือกอยู่, ปุ่มบันทึกยัง enabled ให้กดซ้ำได้ + `SnackBar` key `steps_goal_error_toast` ข้อความ 「ไม่สามารถบันทึกเป้าหมายได้ กรุณาลองใหม่อีกครั้ง」 |
| ปิดการใช้งาน (Disabled — ใช้โควต้าแล้ว) | `steps_goal_save_button` `onPressed: null` → สีเทาจางตาม M3 default; ชิปทุกตัว `onSelected: null` (เทาจาง) แต่ชิปเป้าหมายปัจจุบันยังแสดง selected; `SnackBar` key `steps_goal_quota_toast` ข้อความ 「คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวัน」 — จังหวะแสดง Toast ดู Q-11 (ชั่วคราว: แสดงทันทีเมื่อเข้า S-2 ขณะโควต้าหมด และแสดงซ้ำเมื่อแตะบริเวณปุ่มที่ disabled โดยห่อปุ่มด้วย `GestureDetector`) |

### S-3

| สถานะ | หน้าตา |
|---|---|
| ปกติ (Normal) | การ์ด 4 ตัวแปรมีค่า, ไม่มี `steps_report_empty_text`, ปุ่ม 「ดาวน์โหลดรายงาน (PNG)」 enabled |
| ว่าง (Empty/Initial) | การ์ดแสดงค่า 0 ทั้ง 4 แถว + `steps_report_empty_text` 「ยังไม่มีข้อมูลสรุปผลในเดือนนี้」 ใต้การ์ด; ปุ่ม export คง enabled (ux-flow ไม่ได้สั่งปิด) |
| ผิดพลาด (Error) | `AlertDialog` key `steps_report_error_dialog`, content 「ไม่สามารถสร้างไฟล์ภาพรายงานได้ในขณะนี้」, action `FilledButton` 「ลองใหม่อีกครั้ง」 key `steps_report_retry_button` (ไม่มี title — ux-flow ไม่ได้กำหนด) |
| ปิดการใช้งาน (Disabled — กำลัง export) | `steps_report_export_button` `onPressed: null` (เทาจาง), icon แทนที่ด้วย `SizedBox(20×20, CircularProgressIndicator(strokeWidth: 2))` key `steps_report_exporting_indicator`, label เปลี่ยนเป็น 「กำลังสร้างรายงาน...」 |

## 4. ภาพสัตว์เลี้ยงแต่ละสถานะ

### 4.1 ไฟล์ assets (ตาม game-rules.md §2 ตรงตัว)

| สถานะ (enum ใน Dart) | ป้าย | ไฟล์ภาพ | key ภาพ PNG | key ภาพวาด fallback |
|---|---|---|---|---|
| `FAT (อ้วนอืด)` → `fat` | 「อ้วนอืด」 | `assets/images/pet_fat.png` | `steps_pet_png_fat` | `steps_pet_painter_fat` |
| `CHUBBY (จ่ำม่ำ)` → `chubby` | 「จ่ำม่ำ」 | `assets/images/pet_chubby.png` | `steps_pet_png_chubby` | `steps_pet_painter_chubby` |
| `LEAN (หุ่นลีน (สมส่วน))` → `lean` | 「หุ่นลีน (สมส่วน)」 | `assets/images/pet_lean.png` | `steps_pet_png_lean` | `steps_pet_painter_lean` |
| `MUSCLE (มีกล้ามขา)` → `muscle` | 「มีกล้ามขา」 | `assets/images/pet_muscle.png` | `steps_pet_png_muscle` | `steps_pet_painter_muscle` |

ช่วง % ของแต่ละสถานะ: ยึด game-rules.md §2 (ไม่เขียนซ้ำที่นี่)

### 4.2 Fallback (pattern เดียวกับ `PetAvatar` / `PetPainter` ของ water)

ไฟล์ทั้ง 4 ยังไม่มีใน `app/assets/images/` (มีแค่ `pet_critical/tired/happy.png` ของ water) → ต้องมี fallback:

- `StepsPetAvatar` (ใหม่ ใน `app/lib/features/steps/widgets/`) ทำงานเหมือน `PetAvatar` (`pet_avatar.dart`): ตรวจ `AssetManifest` ว่ามีไฟล์ใน bundle → ถ้ามีใช้ `Image.asset(..., fit: BoxFit.contain, errorBuilder: → ภาพวาด)` key `steps_pet_png_<status>`; ถ้าไม่มี → `CustomPaint(painter: StepsPetPainter(status: ...))` key `steps_pet_painter_<status>`, `Size.square(160)`
- widget ภายนอกรับ key `steps_pet_image_<status>` จากหน้าจอ (เหมือน `water_pet_image_<mood>`)
- `StepsPetPainter` (ใหม่) วาดสไตล์เดียวกับ `PetPainter`: ตัววงรี + หูสามเหลี่ยม 2 ข้าง, เส้นขอบ `_outline` หนา `s*0.025` ปลายมน, มีฟิลด์ public `status` ให้ QA ตรวจได้ `(painter as StepsPetPainter).status`; `shouldRepaint` เมื่อ status เปลี่ยน
- ห้ามแก้ `PetPainter` / `PetAvatar` ของ water

หน้าตาแต่ละสถานะ (s = ด้านของกรอบ 160; สัดส่วนเป็น **ใหม่** ค่าการแสดงผล ไม่ใช่กติกาเกม):

| สถานะ | สีตัว | รูปร่างตัว (oval กลาง `(0.5s, 0.56s)`) | หน้า | ของประกอบ |
|---|---|---|---|---|
| FAT | `_criticalBody` `0xFFD9D4E7` | กว้าง `0.92s` สูง `0.68s` (อ้วนกว้างกว่า water) | ตาปรือ + ปากเปิด (เหมือน `tired` ของ water แต่ไม่แลบลิ้น) หูตก droop `0.07` | หยดเหงื่อ `_sweat` ที่ `(0.84s, 0.38s)` |
| CHUBBY | `_tiredBody` `0xFFFFE0B2` | กว้าง `0.84s` สูง `0.68s` | ตาจุดกลม (วงกลมทึบ `_outline` รัศมี `0.035s`) + ยิ้มเล็ก (arc กว้าง `0.12s`) หูตั้ง | แก้ม `_cheek` alpha 0.8 |
| LEAN | `_happyBody` `0xFFB9F2D0` | กว้าง `0.72s` สูง `0.68s` | ตายิ้ม (^ ^) + ยิ้มกว้าง (เหมือน `happy` ของ water) หูตั้ง | แก้ม `_cheek` alpha 0.8 |
| MUSCLE | `_happyBody` `0xFFB9F2D0` | กว้าง `0.72s` สูง `0.62s` (ยกตัวขึ้นเล็กน้อยเพื่อเว้นที่ขา) | ตายิ้ม (^ ^) + ยิ้มกว้าง หูตั้ง | ขา 2 ข้าง: oval กว้าง `0.18s` สูง `0.16s` ที่ `(0.36s, 0.88s)` และ `(0.64s, 0.88s)` สีตัว + ขอบ `_outline`, เส้นโค้งกล้าม (arc สั้น) บนแต่ละขา; ประกาย `_sparkle` 2 จุดตำแหน่งเดียวกับ `happy` ของ water |

## 5. Checklist สำหรับ reviewer

- [ ] ไม่มี hex สีใน steps screens — สี component มาจาก `Theme.of(context).colorScheme` (seed `Colors.lightBlue` ใน `main.dart`)
- [ ] ไม่แก้ `ThemeData` ใน `app/lib/main.dart` และไม่เพิ่ม font ใน pubspec
- [ ] สีวาดสัตว์เลี้ยงใช้ hex เดียวกับ `PetPainter` (`_criticalBody/_tiredBody/_happyBody/_outline/_cheek/_sweat/_sparkle`) ตาม §4.2
- [ ] `PetPainter` / `PetAvatar` ของ water ไม่ถูกแก้
- [ ] มีปุ่ม `steps_entry_button` (TextButton.icon หรือ IconButton) ใน AppBar ของ `WaterHomeScreen` และกดแล้วไป S-1
- [ ] S-1 AppBar title = 「ก้าวเดินประจำวัน」 key `steps_header_text`
- [ ] S-1 padding 24, ช่องไฟ 8/16/24 ตาม §2.1
- [ ] ภาพสัตว์เลี้ยง 160×160 key `steps_pet_image_<fat|chubby|lean|muscle>`
- [ ] ภาพใช้ PNG ตาม game-rules §2 ถ้ามีใน bundle มิฉะนั้น `CustomPaint` key `steps_pet_painter_<status>` (แอปไม่ล่มเมื่อไม่มีไฟล์)
- [ ] ป้ายสถานะ key `steps_status_badge` แสดง 「อ้วนอืด」/「จ่ำม่ำ」/「หุ่นลีน (สมส่วน)」/「มีกล้ามขา」 ตรงตัว พื้น `secondaryContainer`
- [ ] หลอดพลังงาน `LinearProgressIndicator` `minHeight: 20` มุมโค้ง 8 key `steps_energy_bar` และ value ถูก clamp ไม่เกิน 1.0
- [ ] `steps_percent_text` แสดง % จริงเกิน 100% ได้ ลงท้าย `%`
- [ ] `steps_count_text` รูปแบบ `<ก้าว> / <เป้าหมาย> ก้าว` มี comma คั่นหลักพัน style `headlineSmall`
- [ ] ปุ่ม `steps_add_button` เป็น `FilledButton.icon` และเป็นทางเดียวที่เพิ่มก้าว (ไม่มีการเรียก sensor/Health API)
- [ ] ปุ่ม 「ตั้งเป้าหมาย」 key `steps_set_goal_button` ไป S-2; 「รายงานสรุปรายเดือน」 key `steps_monthly_report_button` ไป S-3
- [ ] ไอคอนปุ่มใช้ `AssetImageOrIcon` กับ `assets/icons/ic_target.png` (fallback `Icons.flag`) และ `assets/icons/ic_report.png` (fallback `Icons.bar_chart`)
- [ ] S-1 Empty: `0 / <เป้าหมาย> ก้าว`, `0%`, ภาพ fat
- [ ] S-1 Error: `AlertDialog` key `steps_sensor_error_dialog` มีปุ่ม key `steps_open_settings_button`
- [ ] S-1 Disabled: `Icon(Icons.cloud_off)` key `steps_offline_icon` ใน AppBar
- [ ] S-2 title 「ตั้งเป้าหมายก้าวเดินประจำวัน」 key `steps_goal_header_text`, ปุ่มย้อนกลับ key `steps_goal_back_button`
- [ ] S-2 มี `ChoiceChip` 10 ตัว key `steps_goal_chip_<ค่า>` ใน 3 กลุ่มตามลำดับ 6,000–8,000 / 9,000–12,000 / 13,000–15,000 label มี 「ก้าว」
- [ ] S-2 เลือกได้ทีละ 1 ค่าทั้งหน้า; เข้าหน้าครั้งแรก `steps_goal_chip_8000` selected
- [ ] S-2 ปุ่ม 「บันทึกเป้าหมาย」 เป็น `FilledButton` key `steps_goal_save_button`; disabled ใช้ `onPressed: null` (ไม่ตั้งสีเทาเอง)
- [ ] S-2 Toast โควต้าเป็น `SnackBar` key `steps_goal_quota_toast` ข้อความ 「คุณสามารถปรับเปลี่ยนเป้าหมายได้เพียง 1 ครั้งต่อวัน」
- [ ] S-2 Toast error เป็น `SnackBar` key `steps_goal_error_toast` ข้อความ 「ไม่สามารถบันทึกเป้าหมายได้ กรุณาลองใหม่อีกครั้ง」
- [ ] SnackBar เรียก `hideCurrentSnackBar()` ก่อน และ `persist: false` (pattern `water_anti_spam_toast`)
- [ ] S-3 title 「รายงานสุขภาพประจำเดือน」 key `steps_report_header_text`, ปุ่มย้อนกลับ key `steps_report_back_button`
- [ ] S-3 การ์ด key `steps_report_summary_card` มี 4 แถวชื่อตรงตัวตาม ux-flow และค่า key `steps_report_total_steps/total_water/avg_steps/goal_days`
- [ ] S-3 การ์ดอยู่ใน `RepaintBoundary` key `steps_report_capture` (สิ่งที่ export = สิ่งที่เห็น)
- [ ] S-3 ปุ่ม 「ดาวน์โหลดรายงาน (PNG)」 `FilledButton.icon` key `steps_report_export_button`
- [ ] S-3 Empty แสดง 「ยังไม่มีข้อมูลสรุปผลในเดือนนี้」 key `steps_report_empty_text`
- [ ] S-3 Exporting: ปุ่ม disabled + `CircularProgressIndicator` key `steps_report_exporting_indicator` + 「กำลังสร้างรายงาน...」
- [ ] S-3 Error: `AlertDialog` key `steps_report_error_dialog` ข้อความ 「ไม่สามารถสร้างไฟล์ภาพรายงานได้ในขณะนี้」 ปุ่ม 「ลองใหม่อีกครั้ง」 key `steps_report_retry_button`
- [ ] ไม่มีหน้าจออื่นนอกจาก S-1, S-2, S-3 (ทางเข้าเป็นแค่ปุ่มบนหน้า water)
- [ ] ข้อความบนจอทุกข้อความตรงกับ ux-flow ตัวต่อตัว (ยกเว้นที่ spec ระบุ "เสนอ — รอยืนยัน")
- [ ] ไม่มี overflow (แถบเหลือง-ดำ) บนจอกว้าง 360 dp

## 6. คำถามที่ค้าง

| # | ประเด็น | ทางที่ spec เลือกไว้ชั่วคราว |
|---|---|---|
| Q-1 | ปุ่มเพิ่มก้าวเดินด้วยมือ (D-1) ไม่มีข้อความใน ux-flow | label 「เพิ่มก้าวเดิน」 + `Icons.directions_walk` key `steps_add_button` — รอเจ้าของยืนยันข้อความ |
| Q-2 | กด 1 ครั้งเพิ่มกี่ก้าว / ให้พิมพ์จำนวนเองหรือไม่ — เป็นตัวเลขกติกา UI ตั้งเองไม่ได้ | spec กำหนดเป็นปุ่มกดเดียว (ไม่มีช่องกรอก) จำนวนก้าวต่อครั้งให้เจ้าของ/game-rules กำหนด แล้ว Dev ใส่เป็นค่าคงที่พร้อมคอมเมนต์ ASSUMPTION จนกว่าจะยืนยัน |
| Q-3 | ux-flow ไม่มีทางเข้า S-1 จากหน้า water (home) | ปุ่ม `steps_entry_button` ใน AppBar ของ water label 「ก้าวเดินประจำวัน」 (หรือ IconButton ถ้าล้น) — ไม่เพิ่มหน้าจอ |
| Q-4 | S-1 Error/Denied: ux-flow ไม่มีข้อความของ Pop-up/ปุ่ม Settings และ MVP ไม่มีเซนเซอร์ (D-1) จึงไม่มีเหตุการณ์ปฏิเสธสิทธิ์จริง | หน้าตาตาม §3 ข้อความเสนอ 「ไม่สามารถนับก้าวเดินได้」 / 「กรุณาอนุญาตสิทธิ์เซนเซอร์นับก้าวในหน้า Settings ของเครื่อง」 / 「ไปที่ Settings」 — Dev สร้าง widget ไว้แต่ไม่ trigger ใน MVP (หรือ trigger ผ่าน flag สำหรับเทสต์) รอเจ้าของยืนยัน |
| Q-5 | S-1 Disabled (ออฟไลน์): MVP ไม่มี network (D-2) จึงไม่มีสถานะออฟไลน์จริง และ ux-flow ไม่มีข้อความ tooltip | `Icons.cloud_off` key `steps_offline_icon` tooltip 「ออฟไลน์」 — ชั่วคราว: Dev สร้าง widget ไว้แต่ไม่แสดงใน MVP (ซ่อนไว้หลัง flag สำหรับเทสต์) รอเจ้าของกำหนดเงื่อนไข trigger |
| Q-6 | S-2 Error "เชื่อมต่อ Server ขัดข้อง" — MVP บันทึกลง local storage (D-2) | ใช้ SnackBar `steps_goal_error_toast` เมื่อการเขียน local storage ล้มเหลว (throw) — รอยืนยัน |
| Q-7 | รูปแบบตัวเลข % Goal (ทศนิยมกี่ตำแหน่ง) ไม่ได้กำหนด; ถ้าปัดขึ้นอาจเห็น 「100%」 ขณะภาพยังเป็น LEAN (เช่น 99.996%) | แสดงสูงสุด 2 ตำแหน่งแบบ**ตัดทิ้ง (floor) ไม่ปัด** และตัดศูนย์ท้าย (35 → `35%`, 106.25 → `106.25%`) เพื่อไม่ให้ตัวเลขข้ามเกณฑ์ที่ภาพยังไม่เปลี่ยน |
| Q-8 | ระยะเวลาแสดง Toast ของ steps ไม่ได้กำหนด | ใช้ 2 วินาทีเท่า water (`WaterRules.antiSpamToastSeconds`) เพื่อหน้าตาเหมือนกัน |
| Q-9 | หัวกลุ่ม S-2 ux-flow ให้เป็น "ชื่อองค์ประกอบ" ไม่ได้ระบุว่าเป็นข้อความบนจอ | แสดง 「กลุ่มเป้าหมายทั่วไป」 「กลุ่มควบคุมน้ำหนัก」 「กลุ่มนักกีฬา」 เป็นหัวกลุ่ม |
| Q-10 | S-3 หน่วยและทศนิยมของค่าในการ์ดไม่ได้กำหนด | ก้าว → 「ก้าว」, น้ำ → 「แก้ว」 (หน่วยเดียวกับ water), ค่าเฉลี่ย → 「ก้าว/วัน」 ทศนิยม 1 ตำแหน่ง (เท่า `WaterRules.monthlyAverageDecimals`), จำนวนวัน → 「วัน」 |
| Q-11 | S-2 Disabled: ux-flow ว่า "พยายามกด" แล้วปุ่ม Disabled + Toast แต่ปุ่มที่ disabled กดไม่ได้ | แสดง Toast ทันทีเมื่อเข้า S-2 ขณะโควต้าหมด และแสดงซ้ำเมื่อแตะบริเวณปุ่ม (GestureDetector ห่อปุ่ม disabled) |
| Q-12 | หลังบันทึกเป้าหมายสำเร็จ ux-flow ไม่ได้บอกว่าจะกลับ S-1 อัตโนมัติหรืออยู่ S-2 และไม่มีข้อความยืนยัน | ไม่มีข้อความยืนยัน; อยู่ที่ S-2 ต่อ (ปุ่มเปลี่ยนเป็น disabled เพราะโควต้าหมด) ผู้ใช้กดย้อนกลับเอง — รอยืนยัน |
| Q-13 | ux-flow §5 ระบุ `ic_target.png` ใช้ที่ "S-2 (ปุ่มตั้งเป้าหมาย)" และ `ic_report.png` ที่ "S-3 (ปุ่มรายงาน)" แต่ปุ่มทั้งสองอยู่บน S-1 | ใช้ไอคอนบนปุ่มของ S-1 (`steps_set_goal_button`, `steps_monthly_report_button`); ไฟล์ยังไม่มีและ `assets/icons/` ไม่ได้ลงทะเบียนใน pubspec → แสดง fallback Material icon |
| Q-14 | export PNG สำเร็จแล้ว ux-flow ไม่มีข้อความแจ้งผู้ใช้ | ไม่แสดงข้อความ (ตาม ux-flow ตรงตัว) — แนะนำให้เจ้าของพิจารณาเพิ่มข้อความ SnackBar |
| Q-15 | ไฟล์ `bg_dashboard.png` และภาพสัตว์เลี้ยงทั้ง 4 ยังไม่มีใน repo | ใช้ fallback ตาม §2.1 / §4.2 |
