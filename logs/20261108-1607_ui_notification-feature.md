# Log: ui · notification-feature รอบ 1 · 2026-11-08 16:07

| รายการ | ค่า |
|---|---|
| สถานะ | สำเร็จ — สร้าง docs/notification-feature/ui-spec.md (draft รอบ 1) |
| agent | UI Designer |
| branch / worktree | `.claude/worktrees/petpal-remote-control-c717e2` (ไม่ commit / ไม่ push) |
| ต่อจาก | logs/20261108-1548_art_notification-feature.md (Art รอบ 5 — `PetPose.notificationProfile`) |
| output | docs/notification-feature/ui-spec.md (ใหม่) · ไม่แก้ app/ ไม่แก้ไฟล์อื่นใน docs/ |
| เวลา | ~15:50–16:07 (เวลาจบจากนาฬิกาเครื่อง — owner แก้ชื่อไฟล์และเวลาให้ตรง เดิม agent ประมาณไว้ 16:35) |
| hook / สิทธิ์ | ไม่พบการบล็อก |

## ไฟล์ที่อ่าน

- docs/notification-feature/requirements.md, ux-flow.md, game-rules.md, design-review.md (ครบ — ux-flow + game-rules มีครบ จึงเขียน spec ได้)
- docs/dashboard/ui-spec.md (§0–§5), docs/7day/ui-spec.md (ทั้งไฟล์) — รูปแบบ §0 ตารางข้อตัดสิน, §2.0 ทางเข้า, checklist, ตาราง Q
- logs/20261031-1510_ui_7day.md, logs/20261031-0945_ui_dashboard_r3.md (รูปแบบ log ui)
- docs/_design/character.md (ทั้งไฟล์ — §5 แถว notification, §7 ตัวอย่าง S-1 / `renderNotificationAvatar` 192 px, §9 ข้อ 11–12), logs/20261108-1548_art_notification-feature.md
- app/lib/main.dart, features/water/screens/water_home_screen.dart (AppBar 5 ปุ่ม, `_openSteps/_openFood/_openDashboard`, lifecycle, 1-min reset timer), water_controller.dart / water_models.dart / water_rules.dart / water_repository.dart (`WaterStorageKeys`, `lastLoggedAt`, clamp ค่าติดลบ)
- features/dashboard/screens/dashboard_screen.dart (AppBar ไม่มีปุ่ม), dashboard_rules.dart (`waterTargetCups`, `screenTitle`)
- features/steps/steps_controller.dart (`addSteps` +1000, `isTrackingLocked`, clock), steps_models.dart (`StepsTrackingStatus`, `StepsState` ไม่มีเวลาก้าวล่าสุด), steps_rules.dart, steps_repository.dart (keys), screens/steps_dashboard_screen.dart (pattern `showDialog` + `_sensorDialogOpen`)
- features/food/food_controller.dart (`totalCalories`, `targetCalories`, `hasTarget`), food_models.dart, food_logic.dart (`isOverLimit`), food_repository.dart (keys)
- features/signup/screens/signup_gate.dart, signup_controller.dart, signup_logic.dart (`routeFor`), screens/signup_welcome_screen.dart (OutlinedButton/FilledButton)
- features/seven_day/seven_day_rules.dart (รูปแบบชื่อค่าคงที่ lowerCamel + DECIDED/ASSUMPTION)
- app/lib/shared/pet/pet_character.dart (พารามิเตอร์), pet_pose.dart (บรรทัด 174 `notificationProfile`) — grep
- app/pubspec.yaml, app/android/app/src/main/AndroidManifest.xml (`singleTop`), app/android/app/build.gradle.kts · glob พบว่าไม่มี `app/ios/`

## ข้อตัดสิน owner — DECIDED (owner) 2026-11-08 (ทีมให้ owner ตัดสินไปก่อน ทีมตรวจตอนรีวิว PR · ข้อตัดสินชนะเอกสาร)

| # | เรื่อง | ข้อตัดสิน | ใน ui-spec |
|---|---|---|---|
| 1 | รูปโปรไฟล์กบ | ไม่ใช้ PNG `assets/images/pet_profile_frog.png` — ใช้ `PetCharacter(pose: PetPose.notificationProfile)` · S-1 วาดด้วย widget ตรง ๆ · Person icon Android เรนเดอร์จาก `PetCharacterPainter` ตอนรันแอป 192×192 px ครอปวงกลมเต็มกรอบ พื้นโปร่งใส → `ByteArrayAndroidIcon` แคชไว้ · ไม่มี PNG ใน assets (ปิด Q-01) | D-1 |
| 2 | ทางเข้า S-2 | ปุ่มไอคอนตั้งค่าใน AppBar หน้า dashboard (IconButton + tooltip) ไม่แตะ AppBar หน้า water ที่เต็ม 5 ปุ่ม | D-2, §2.0 |
| 3 | "เดิน: บันทึกเอง" | ตัดออก → Out of scope · ผู้ใช้ `isTrackingLocked` ไม่ได้ข้อความเรื่องเดินเลย · AC-15 / EC-12 ไม่ทำ | D-3 |
| 4 | ค่าติดลบ / `daily_goal` = 0 | ยึด EC-3 ของ notification (ไม่ส่งเรื่องนั้นในรอบวัน) เฉพาะ notification — ไม่เปลี่ยน A4 ของ 7day | D-4 |
| 5 | Package | `flutter_local_notifications`, `timezone`, `flutter_timezone` — ในเครื่อง ไม่ต่อเน็ต ไม่ใช้ workmanager — คำนวณล่วงหน้า ตั้งใหม่ทุกครั้งที่ข้อมูลเปลี่ยน/เปิดแอป | D-5 |
| 6 | การตั้งเวลา | `AndroidScheduleMode.inexactAllowWhileIdle` ไม่ขอ exact alarm · ทุกข้อความอาจช้า → Out of scope · เทสต์ตรวจเวลาที่ "ตั้ง" | D-6 |
| Q-02 | ข้อความ PERMISSION_DENIED | ใช้ Exact String จาก ux-flow | ปิด Q-02 |

ข้อตกลงเดิมที่ยึด: PetCharacter ตัวเดียว (D-7) · ไม่ต่อเน็ต ตัดรอบ 05:00 เวลาเครื่อง clock ร่วม (D-8) · อ่านจาก controller เดิม key ใหม่ของ notification เก็บได้ (D-9) · water เป็นหน้าแรก S-1 ทับหน้า water (D-10) · เป้าน้ำ 8 แก้วจากค่าคงที่ water (D-11)

## การตัดสินใจหลักพร้อมเหตุผล (ของ UI — ชั่วคราว)

1. **S-1 = `showDialog(barrierDismissible: false)` + `PopScope(canPop: false)` + `Dialog`** เปิดจาก `WaterHomeScreen` post-frame เมื่อ `consent_status == UNANSWERED` — pattern เดียวกับ `steps_sensor_error_dialog` (มี flag กันเปิดซ้อน) · dialog route คลุม AppBar จึงกดทะลุไม่ได้ · ไม่แตะ signup
2. **สัตว์เลี้ยงบนการ์ด 120 px** (token ใหม่) — การ์ด 280 dp ที่ 360 dp; 160 ทำให้ textScaler 1.5 สูงเกินจอ · 120 คือค่าตัวอย่างของ Art · `reactToTap: false` ตาม ux "ไม่มีผลเมื่อกด"
3. **ปุ่ม S-1 ซ้อนแนวตั้งเต็มกว้าง** (Filled 「อนุญาต」 บน, Outlined 「ไม่อนุญาต」 ล่าง) — สองปุ่มไทยแถวเดียวไม่พอที่ 1.5
4. **Token ทั้งหมดเป็นของเดิม/ default** — Dialog/barrier default (แบบ steps), ข้อความรอง `onSurfaceVariant`, banner `errorContainer` (แบบ `food_full_badge`), Android `color` = seed `Colors.lightBlue` · ใหม่เฉพาะ: pet 120, ปุ่มซ้อน, `SwitchListTile.contentPadding: zero` · ไม่มี hex ใหม่
5. **S-2 = `ListView(padding 16)` + `SwitchListTile` + banner** — ป้ายสวิตช์ไม่มีในเอกสาร ใช้ชื่อองค์ประกอบ 「เปิด/ปิดแจ้งเตือนทั้งหมด」 (เสนอ) · สวิตช์แสดง `master ON && GRANTED`
6. **EC-1 ไม่ใช้ timer debounce** — เขียนค่าทันที + sync แบบ serialized/coalesce → scheduler ตรงกับสถานะสุดท้าย ทดสอบได้ใน 1 เฟรม
7. **เช็กสิทธิ์ตอน resume ผ่าน `WaterHomeScreen.didChangeAppLifecycleState` ที่มีอยู่** — Home เป็น root เสมอ ไม่ต้องเพิ่ม observer
8. **Deep link: `popUntil(isFirst)` แล้ว push ไม่เกิน 1 หน้า** ใน `WaterHomeScreen` ด้วย controller steps/food ตัวเดียวกับ `_openSteps/_openFood` — กันหน้าซ้อน (EC-2) แบบคาดเดาได้ ไม่ต้องมี navigatorKey · TERMINATED ใช้ `getNotificationAppLaunchDetails` ใน `main()` · payload `'<topic>|<message>'`
9. **Android MessagingStyle**: title 「น้องอ๊บ」 + body ข้อความ (fallback ครบ) + `Person(name, ByteArrayAndroidIcon)` · avatar เรนเดอร์ตอนตั้งเวลา (แอปเปิด) แคช · พื้นโปร่งใสตาม ux §5 (ตอบ Art ข้อ 2) · **iOS title null** (2 ส่วน)
10. **โครงชั้น**: rules / models / logic pure (รับ `now`) / repository / scheduler abstraction (+ Noop, Fake ในเทสต์) / local scheduler (plugin) / avatar / controller / screen / widget — ตาม pattern ฟีเจอร์เดิม
11. **การวางคิวเป็นอัลกอริทึม pure เดียว (`buildPlan`)** + ตารางเทสต์ T-1–T-18 ที่คำนวณค่าคาดหวังแล้ว (เช่น วันว่างทั้งวัน → ครบ 6 ก่อน 21:00 ไม่มี `foodNight`)
12. **ห้าม `cancelAll` / ห้าม cancel รายการที่ถึงเวลาแล้ว** — Android cancel id ที่แสดงแล้วจะลบจากถาด และ inexact อาจยิงช้า · id = hash(วัน|message|anchor)
13. **key ใหม่ `notification_day_plan`** — จำเป็นเมื่อคำนวณล่วงหน้า (รู้ว่าตั้ง/ส่งอะไรแล้ว นับเพดาน "ครั้งเดียวต่อรอบนับ" topic ที่ถูกระงับ) · คีย์ game-rules ยังเขียนครบ (derive) · ไม่มี `last_manual_move_timestamp` (D-3)
14. **ทางเข้า S-2**: `notification_settings_entry_button` `Icons.settings` 24 tooltip = หัวข้อ S-2 · `DashboardScreen` / `WaterHomeScreen` / `PetPalApp` รับ `notificationController` แบบ nullable → เทสต์เดิมไม่เปลี่ยน
15. **manifest**: `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, 2 receiver ของ plugin · ไม่มี exact alarm · build.gradle.kts เปิด desugaring · iOS ไม่มีโฟลเดอร์ใน repo → จด setup ไว้เท่านั้น

## คำถามที่ค้าง (รายละเอียดและค่าชั่วคราวใน ui-spec §7)

- ปิดแล้ว: Q-01 (owner 1), Q-02 (owner)
- B (ux-flow / game-rules): Q-03 ป้ายสวิตช์, Q-05 DENIED + กด ON / ไม่มีปุ่มไปการตั้งค่า, Q-06 ข้อความที่เลยเวลาเมื่อเปิดแอปช้า (เก็บขั้นล่าสุดของแต่ละสาย), Q-08 dueAt ของใกล้เป้า, Q-13 เอกสารยังอ้าง PNG และ "บันทึกเอง", Q-16 deep link ตอนไม่อยู่ Home, Q-17 popUntil ปิดหน้าที่ค้าง, Q-22 ปุ่ม back บนการ์ด, Q-24 เขียน storage ไม่สำเร็จ, Q-26 แจ้งเตือนตอน foreground
- A (requirements): Q-15 Android < 13 ไม่มีกล่องสิทธิ์, Q-18 ผู้ใช้เดิมเห็นการ์ดหลังอัปเดต, Q-23 master ON + DENIED แล้วเปิดสิทธิ์ภายหลัง, Q-28 ออกจากระบบแล้วยกเลิกแจ้งเตือนไหม
- O (ข้อตัดสิน owner ที่ต้องตีความ): Q-04 tooltip, Q-07 ช้าเกิน 60 นาที, Q-14 AC-15/EC-12 ยังอยู่ในเอกสาร, Q-20 EC-3 ระงับทั้งวัน
- UI / Art: Q-09 channel, Q-10 small icon monochrome (งาน Art), Q-11 พื้น avatar, Q-12 ไม่มี ios/, Q-19 fallback timezone, Q-21 key ใหม่, Q-25 id scheme, Q-27 `android:label`

## เวลาที่ใช้

ประมาณ 45 นาที (อ่านเอกสาร + โค้ด ~20 · เขียน spec ~20 รวมเขียนซ้ำ 1 รอบเพื่อแก้ค่าคาดหวัง T-18 ที่ขัดกันเอง · log ~5)
