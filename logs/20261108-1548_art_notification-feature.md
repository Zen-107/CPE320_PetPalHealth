# Log: art · notification-feature · 2026-11-08 15:48

| รายการ | ค่า |
|---|---|
| สถานะ | สำเร็จ (รอบ 5 ของตัวละคร — เพิ่มสีหน้า `wink` 1 แบบ + preset `PetPose.notificationProfile`) |
| agent | Art Director / Character Artist |
| branch | claude/petpal-remote-control-c717e2 (worktree `.claude/worktrees/petpal-remote-control-c717e2`; ไม่ได้ commit/push ตามคำสั่ง) |
| output | app/lib/shared/pet/pet_pose.dart, pet_constants.dart, pet_painter.dart · docs/_design/character.md · docs/_design/preview/notification_profile.png, notification_profile_96_circle.png, notification_profile_512.png, notification_profile_sizes.png, fx_wink.png, all_states_160.png (อัปเดต) |
| เวลาเริ่ม | 2026-11-08 ~15:15 |
| เวลาจบ | 2026-11-08 15:48 |

## ข้อตัดสินของ owner (บันทึกตามคำสั่ง)

ทั้งหมด **DECIDED (owner) 2026-11-08** — ทีมให้ owner ตัดสินไปก่อน ทีมตรวจตอนรีวิว PR:

| # | เรื่อง | ข้อตัดสิน |
|---|---|---|
| 1 | รูปโปรไฟล์กบ | ไม่ใช้ PNG `assets/images/pet_profile_frog.png` — ใช้ `PetCharacter` ท่าใหม่ `PetPose.notificationProfile` · S-1 วาดด้วย widget ตรง ๆ · Person icon แบบแชตบน Android เรนเดอร์จาก PetCharacter เป็นภาพตอนรันแอป ไม่มี PNG ใน assets (ปิด Q-01) |
| 2 | ทางเข้าหน้าตั้งค่า S-2 | ปุ่มตั้งค่าใน AppBar หน้า dashboard (ไม่แตะ AppBar หน้า water ที่เต็ม 5 ปุ่ม) — ไม่กระทบงาน Art |
| 3 | "เดิน: บันทึกเอง" | ตัดออกจากรอบนี้ → Out of scope — ไม่กระทบงาน Art |
| 4 | ค่าติดลบจากฟีเจอร์อื่น / daily_goal = 0 | ยึด EC-3 ของ notification (ไม่ส่งเรื่องนั้นในรอบวัน) เฉพาะ notification — ไม่เปลี่ยน A4 ของ 7day — ไม่กระทบงาน Art |
| 5 | Package | `flutter_local_notifications`, `timezone`, `flutter_timezone` (ในเครื่องเท่านั้น) — Art ไม่ได้เพิ่ม package |
| 6 | การตั้งเวลา | แบบไม่เป๊ะ (`inexactAllowWhileIdle`) ไม่ขอ exact alarm · ทุกข้อความอาจช้ากว่ากำหนดได้ → Out of scope — ไม่กระทบงาน Art |

จดข้อ 1 ใน character.md §9 ข้อ 11 ด้วย (ไม่ได้แก้ docs/notification-feature/)

## ไฟล์ที่อ่าน

- docs/_design/character.md (รอบ 4)
- docs/notification-feature/requirements.md (AC-36, AC-37, §5 ข้อจำกัด "ใช้ภาพโปรไฟล์กบ 1 ภาพ", คำถามข้อ 1), ux-flow.md (§1, §2 S-1 / S-3, §3, §5 รายการภาพ, คำถาม), game-rules.md (§2 `NOTIFICATION_PROFILE` — ไม่มีช่วงค่า, แจ้งเตือนไม่เปลี่ยนอารมณ์) — ไม่มี ui-spec.md ของฟีเจอร์นี้ ขนาดใช้ 160 (S-1) และ ~48–96 ครอปวงกลม (Person icon) ตามคำสั่ง
- app/lib/shared/pet/ ทุกไฟล์ (pet.dart, pet_pose.dart, pet_constants.dart, pet_painter.dart, pet_character.dart, pet_animation_policy.dart)
- app/test/shared/pet/pet_character_test.dart, pet_screens_cheer_test.dart (อ่านอย่างเดียว — ไม่วนลูป `PetExpression.values` / `PetFace.values`; กฎ sparkle ผูกกับ preset เดิม → เพิ่มค่า enum ไม่ทำเทสต์พัง) · grep โค้ดนอก pet/ ไม่มี `switch` บน `PetExpression` / `PetFace` → เพิ่มค่า enum ไม่ทำโค้ดฟีเจอร์ compile พัง
- logs/20261031-0707_art_dashboard.md (รูปแบบ log และวิธีเรนเดอร์ preview)

## Map สถานะ game-rules §2 → pose ใน code

| Code Enum (game-rules) | ช่วงค่า | Preset ที่ UI ต้องอ้าง | PetExpression / PetBodyShape | PetFace (นิ่ง) | reuse / ใหม่ | อนิเมชันเฉพาะ |
|---|---|---|---|---|---|---|
| `NOTIFICATION_PROFILE` (ภาพโปรไฟล์แจ้งเตือนคงที่) | ไม่มี (ภาพคงที่) | `PetPose.notificationProfile` (id `normal_wink`) | `wink` (ใหม่) / `normal` | `wink` (ใหม่) | ใหม่ (reuse `_openEye`, แขน/ใบไม้/แก้มปกติ, โครงตัว normal) | ไม่มี (ใช้ breath/blink เดิมเมื่อ animate) |

## การตัดสินใจหลักพร้อมเหตุผล

1. **ทำเป็น `PetExpression` ใหม่ ไม่ reuse** — ไม่มีสีหน้าเดิมที่ขยิบตาข้างเดียวหรือทำปากจู๋ (cheerful/cheer = `^ ^` สองข้าง + ยิ้มอ้า) · ต่อท้าย enum ทั้ง `PetExpression.wink` และ `PetFace.wink` ไม่เปลี่ยนลำดับค่าเดิม
2. **ตาขวา `^` เส้นหนา 0.034 ไม่ใช่ ‿** — ‿ คือภาษาของตาปิด/ง่วง/กะพริบ/full ของตัวละครนี้ ถ้าใช้จะอ่านเป็น "ง่วง" · `^` ยอดแหลม หนากว่า cheer (0.03) เพื่อให้รอดที่ 48 px · กะพริบตา: เฉพาะตาซ้ายปิด (ผ่าน `_openEye` เดิมที่ใช้ค่า blink) ตาขวายังเป็น `^` — ไม่ให้ภาพกระตุกเป็น ‿ ‿
3. **ตาซ้ายเปิดมองตรง ไม่เหล่** — โปรไฟล์ต้อง "สบตา" ผู้ใช้ จึงตั้ง `pupilDx 0` และ `isDerpyEye = false` สำหรับ wink (ลุคเอ๋อยังอยู่ในใบไม้/แก้ม/ทรงตัว) · ผลข้างเคียง: `hasHalfLidEye` / `hasDroopyEyes` = false ตามธรรมชาติ (ไม่ชนกฎเดิม)
4. **ปากจู๋ = สองก้อนซ้อนแนวตั้งแบบเลข "3" สี `lips`** — รอบแรกเรนเดอร์ก้อนเล็ก (0.026) ดูเป็นตัว "B" → ขยายเป็น 0.032 ลดส่วนแบนด้านซ้าย ที่ 48 px อ่านเป็นปากชมพูจู๋ได้ · สี `#EC6F86` เข้มกว่า `tongue` ไม่ให้อ่านเป็นแลบลิ้น
5. **หัวใจข้างตาขยิบ (ขวาบน นอกตัว)** — สื่อ "จุ๊บ" แบบอีโมจิ 😘 และวางให้อยู่ในวงกลมครอปที่แนบกรอบ (ระยะไกลสุด ≈ 0.47·s < 0.5) · ขยาย 0.085 → 0.10 หลังดูภาพ 48 px · getter `showsKissHeart` ให้เทสต์ตรวจ
6. **ไม่มี ticker/controller ใหม่** — ภาพคงที่ตาม game-rules §2; เมื่อ animate ใช้ breath (หัวใจพอง +8%) และ blink เดิม · `animate: false` เห็นท่าขยิบครบ
7. **ไม่เพิ่ม helper เรนเดอร์บิตแมปใน pet/** — `PetCharacterPainter` เป็น public อยู่แล้ว Dev วาดลง `PictureRecorder` ได้ ~10 บรรทัด (ตัวอย่างใน character.md §7) ลดโค้ดที่ไม่มีเทสต์ใน shared/pet
8. **ภาพท่าเดิมไม่เปลี่ยน** — เปรียบเทียบพิกเซล all_states_160.png ก่อน/หลัง 15 ช่องแรกเหมือนกันทุกพิกเซล

## ท่า/สีหน้าที่เพิ่ม

| ของใหม่ | รายละเอียด |
|---|---|
| `PetExpression.wink` / `PetFace.wink` | ตาซ้ายเปิด lid 0 ตาดำ 0.66 มองตรง (+0.04 ลง) · ตาขวา `^` หนา · ปากจู๋ "3" สองก้อน ไฮไลต์ + รอยบุ๋ม · หัวใจจุ๊บขวาบน · แก้ม 0.95 · แขน/ใบไม้ปกติ ไม่มีประกาย/เหงื่อ/ฟองน้ำลาย |
| preset | `PetPose.notificationProfile = PetPose(expression: PetExpression.wink)` id `normal_wink` |
| สี | `PetColors.lips` `#EC6F86`, `PetColors.heart` `#E8506E` |
| สัดส่วน | `PetProportions.winkStroke` 0.034, `kissLobeRadius` 0.032, `kissHeartSize` 0.10 |
| ตา | `PetDerpy.eyes[wink]` = (lid 0, 0.00, +0.04, 0.66) / (lid 1.0) |
| getter painter | `isWinking`, `showsKissHeart` · `isDerpyEye` = false เมื่อ `wink` |

Preview (docs/_design/preview/): `notification_profile.png` (160 พื้นโปร่งใส), `notification_profile_96_circle.png` (96 ครอปวงกลม พื้นโปร่งใส), `notification_profile_512.png` (รายละเอียด), `notification_profile_sizes.png` (พื้นสว่าง/มืด: 160 · วงกลม 96/64/48 · วงกลมซูม 1.3× 96/48 · วงกลมพื้นสีอ่อน 96/48 · เฟรมกะพริบ), `fx_wink.png` (นิ่ง · blink 0.5 · blink 1 · breath 1 · แตะ funny), `all_states_160.png` (เติมช่องที่ 16) — วิธี: เทสต์ชั่วคราว app/test/_art_preview_tmp_test.dart (วาด painter ลง `PictureRecorder` ใน `tester.runAsync`) + เช็กพฤติกรรม app/test/_art_tmp_wink_test.dart (**ลบทั้งสองไฟล์แล้ว**) · ปรับ 1 รอบหลังดูภาพ (ปากเล็กเป็นตัว B → ขยาย; หัวใจเล็กที่ 48 px → ขยาย)

## งานที่ส่งต่อ

Dev (notification-feature)
1. S-1 การ์ดขอความยินยอม: ใช้ `PetCharacter(pose: PetPose.notificationProfile, reactToTap: false, ...)` แทน `Image.asset('assets/images/pet_profile_frog.png')` — ไม่ต้องเพิ่ม asset · ห่อด้วย `KeyedSubtree` key ฟีเจอร์ (เสนอ `notification_consent_pet_image`) · `animate: kPetAnimateByDefault` หรือ `false` (ภาพนิ่งก็ขยิบครบ)
2. S-3 Android Person icon: เรนเดอร์ `PetCharacterPainter(pose: PetPose.notificationProfile)` (breath 0) ลง `PictureRecorder` **192 × 192 px** ครอปวงกลมแนบกรอบทั้งภาพ (ไม่ซูม) พื้นโปร่งใส → PNG bytes → `ByteArrayAndroidIcon` ใน `Person(icon: ...)` ของ `MessagingStyleInformation` · เรนเดอร์ครั้งเดียวแล้ว cache (ภาพไม่เปลี่ยน) · ตัวอย่างโค้ดใน character.md §7 · ถ้าทำในโค้ดที่รันตอน background (callback ของ notification) ต้องมี Flutter engine/`WidgetsFlutterBinding` ก่อนใช้ `dart:ui` — ทางที่ง่ายคือเรนเดอร์ตอนตั้งเวลาแจ้งเตือนขณะแอปเปิดอยู่
3. iOS ไม่ใช้ภาพนี้ (AC-37)

QA (notification-feature)
1. S-1: `painter.pose == PetPose.notificationProfile`, `painter.face == PetFace.wink`, `showsKissHeart == true`, `isDerpyEye == false` ด้วย `animate: false` (รายการ getter เต็มใน character.md §7)
2. แตะรูปบน S-1 ไม่มีผล (ถ้า Dev ตั้ง `reactToTap: false` → `face` ยังเป็น `wink` หลังแตะแม้ `animate: true`)
3. เทสต์เดิม `test/shared/pet/` ไม่ต้องแก้ (ผ่านทั้งหมด) · ถ้าจะเพิ่ม `notificationProfile` ในตาราง preset ของเทสต์ — ไม่ซ้ำกับ preset ใด
4. ตรวจด้วยตา `preview/notification_profile_sizes.png` และ `all_states_160.png`

## คำถามที่ค้าง

1. (ถึง Design) docs/notification-feature/ux-flow.md §2 S-1, §3, §5 และ game-rules.md §2, คำถามข้อ 1 ยังอ้าง PNG `assets/images/pet_profile_frog.png` — ควรอัปเดตตามข้อตัดสิน owner ข้อ 1 (Art ไม่ได้แก้ docs ฟีเจอร์)
2. (ถึง UI/Dev) Person icon บนธีมมืด: กบพื้นโปร่งใสยังอ่านออก แต่จะเด่นขึ้นถ้าเติมวงกลมพื้นสีอ่อน (เช่น `PetColors.belly`) — ux-flow §5 ระบุ "พื้นหลังโปร่งใส" จึงคงโปร่งใสเป็นค่าเริ่ม ให้ UI ตัดสิน
3. (ถึง UI) ขนาดรูปบนการ์ด S-1 ไม่ระบุ (ไม่มี ui-spec.md) — Art ตรวจที่ 160 และวงกลม 48–96; ตัวอย่างใน character.md ใช้ 120
4. (ถึง Product) ปากจู๋ที่ 48 px รอยบุ๋มกลางหายไป อ่านเป็น "ปากชมพูจู๋" + หัวใจ — ถ้าต้องการ "จุ๊บ" ชัดกว่านี้ แจ้ง Art (character.md §9 ข้อ 12)

## ผลตรวจ

- `flutter analyze` (app/) — No issues found!
- `flutter test test/shared/pet/` (app/) — `+67: All tests passed!`
- `flutter test` (app/ ทั้งหมด หลังลบไฟล์ชั่วคราว) — `+797: All tests passed!`
- เช็กพฤติกรรมชั่วคราว (ลบแล้ว): static wink → face wink, isWinking/showsKissHeart true, isDerpyEye/halfLid/droopy/drool/sparkles/sweat/tears/food false, chew/hop 0, transientCallbackCount 0, id `normal_wink`; blink 1 → face blink + heart ยังแสดง; jump → funny + heart ซ่อน; animate: true แตะ → funny แล้วกลับ wink/blink — ผ่าน
- `flutter` แก้ line ending ของ app/windows/flutter/generated_plugin_* เป็นผลข้างเคียง (เนื้อหาไม่เปลี่ยน) → `git checkout` คืนแล้ว ไม่มีไฟล์นอกขอบเขตเปลี่ยน

## เวลาที่ใช้

ประมาณ 33 นาที (อ่าน 7 · โค้ด 8 · เรนเดอร์/ตรวจภาพ 2 รอบ 7 · เอกสาร + log 11)
