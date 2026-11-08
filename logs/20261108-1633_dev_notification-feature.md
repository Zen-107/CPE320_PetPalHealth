# Log: Dev — ฟีเจอร์แจ้งเตือน (notification-feature) รอบ 1

- สถานะ: **สำเร็จ** — โค้ดครบตาม ui-spec §2.4 · `flutter analyze` No issues · `flutter test` 797 ผ่านทั้งหมด
- วันที่: 2026-11-08 ~16:15–16:33 · worktree `.claude/worktrees/petpal-remote-control-c717e2` (branch `claude/petpal-remote-control-c717e2`) · ไม่ commit / push / สลับ branch · ไม่พบ hook หรือสิทธิ์บล็อก
- ไม่แก้ docs/ · ไม่แก้/เพิ่มไฟล์ใน app/test/ · ไม่แตะ app/lib/shared/pet/, app/windows/, app/.metadata, analysis_options.yaml
- ไม่มี docs/notification-feature/review.md (รอบแรก)

## ไฟล์ที่อ่าน

- docs/notification-feature/ui-spec.md (ทั้งไฟล์ — §0, §2.4, §2.5, §5, §7), requirements.md, ux-flow.md, game-rules.md (ครบ 4 ไฟล์)
- docs/_design/character.md §7 · logs/20261108-1548_art_notification-feature.md · logs/20261108-1607_ui_notification-feature.md · logs/20261031-1521_dev_7day.md (รูปแบบ log)
- app/lib/main.dart, water (home screen, controller, models, logic, rules, repository), steps (controller, models, dashboard screen — pattern dialog), food (controller, models), dashboard (screen, controller, rules), signup (gate, controller), shared/pet (pet.dart, pet_pose.dart, pet_painter.dart, pet_character.dart — อ่านอย่างเดียว), seven_day_rules.dart
- app/pubspec.yaml, android/app/build.gradle.kts, AndroidManifest.xml · source ของ flutter_local_notifications 23.0.0 / flutter_timezone 5.1.1 ใน pub cache (ตรวจ API)
- app/test/dashboard/dashboard_test_helpers.dart, test/water/water_pet_character_test.dart (อ่านอย่างเดียว)

## ไฟล์ที่สร้าง (app/lib/features/notification/ — 10 ไฟล์)

| ไฟล์ | เนื้อหา |
|---|---|
| `notification_rules.dart` | `NotificationRules` — ค่าหลัก game-rules §1 (lowerCamel), ข้อความ S-1/S-2/S-3, token §1.3, channel, avatar 192 |
| `notification_models.dart` | `NotificationConsentStatus`, `NotificationSystemPermission` (`code`/`fromCode`), `NotificationTopic` (`priority`, `payloadCode`), `NotificationMessage` (`topic`, `text`), `NotificationInputs`, `PlannedNotification` (+json), `NotificationDayPlan` (+json), `NotificationState` |
| `notification_logic.dart` | `NotificationLogic` pure (import แค่ water_logic + models + rules) — `logicalDay`, `activeStart`, `quietStart`, `isQuietTime`, `anchorFor`, `inputsFor`, `invalidTopics`, `isNearGoal`, `committed`, `pending`, `sentCount`, `lastSentAt`, `walkNearGoalSentToday`, `planForToday`, `notificationId`, `encodePayload`, `decodePayload`, `candidates`, `buildPlan`, `committedOnly`, `schedule` |
| `notification_repository.dart` | `NotificationStorageKeys`, `NotificationRepository`, `InMemoryNotificationRepository` (`state` getter ให้เทสต์ตรวจ), `SharedPrefsNotificationRepository` |
| `notification_scheduler.dart` | `NotificationScheduler` (interface) + `NoopNotificationScheduler` |
| `notification_local_scheduler.dart` | `LocalNotificationScheduler` (plugin จริง, Android/iOS เท่านั้น — `isSupportedPlatform`) |
| `notification_avatar.dart` | `NotificationAvatarSource`, `PainterNotificationAvatarSource` (แคช Future) |
| `notification_controller.dart` | `NotificationController` |
| `screens/notification_settings_screen.dart` | S-2 `NotificationSettingsScreen` |
| `widgets/notification_consent_card.dart` | S-1 `NotificationConsentCard` + `showNotificationConsentCard()` |

## ไฟล์เดิมที่แก้ (8 ไฟล์ — พารามิเตอร์ใหม่ nullable ทั้งหมด null = พฤติกรรมเดิม)

| ไฟล์ | สิ่งที่แก้ |
|---|---|
| `app/lib/main.dart` | `main()` เป็น `async` · แยก steps/food controller เป็นตัวแปร · สร้าง `NotificationController` (+ `LocalNotificationScheduler` หรือ `NoopNotificationScheduler`) · `initialize(onTap:)` + `launchPayload()` ก่อน `runApp` (ห่อ try) · ผูก `signupController.onSignedOut` · `PetPalApp.notificationController` (nullable) ส่งให้ `WaterHomeScreen` |
| `app/lib/features/water/screens/water_home_screen.dart` | พารามิเตอร์ `notificationController` · หลัง water โหลดเสร็จ → `start()` · dispose → `stop()` · S-1 (post-frame + flag `_consentDialogOpen`) · deep link (`popUntil(isFirst)` + push ≤ 1 หน้า) · `onAppResumed()` ใน lifecycle เดิม · `_stepsController()`/`_foodController()` fallback ไปที่ controller ของ notification · ส่งต่อให้ `DashboardScreen` · AppBar 5 ปุ่มเดิมไม่เปลี่ยน |
| `app/lib/features/dashboard/screens/dashboard_screen.dart` | พารามิเตอร์ `notificationController` + `IconButton` `notification_settings_entry_button` ใน `AppBar.actions` (เฉพาะเมื่อไม่ null) → push S-2 |
| `app/lib/features/signup/signup_controller.dart` | field `Future<void> Function()? onSignedOut` เรียกใน `signOut()` (try/catch) ก่อน `notifyListeners()` — Q-28 |
| `app/pubspec.yaml`, `app/pubspec.lock` | 3 package (ด้านล่าง) |
| `app/android/app/src/main/AndroidManifest.xml` | `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, 2 receiver ของ plugin · ไม่มี exact alarm · `singleTop` คงเดิม |
| `app/android/app/build.gradle.kts` | `isCoreLibraryDesugaringEnabled = true`, `coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")`, `compileSdk = maxOf(flutter.compileSdkVersion, 37)` |

## ข้อตัดสิน owner — DECIDED (owner) 2026-11-08 (ทีมให้ owner ตัดสินไปก่อน ทีมตรวจตอนรีวิว PR · ข้อตัดสินชนะเอกสาร)

| # | เรื่อง | ข้อตัดสิน | ในโค้ด |
|---|---|---|---|
| D-1 | รูปโปรไฟล์กบ | `PetCharacter(pose: PetPose.notificationProfile)` ไม่มี PNG · Person icon เรนเดอร์จาก painter 192 px ครอปวงกลม พื้นโปร่งใส แคช | `notification_consent_card.dart`, `notification_avatar.dart`, `NotificationRules.avatarSizePx` |
| D-2 | ทางเข้า S-2 | ปุ่มตั้งค่าบน AppBar dashboard | `dashboard_screen.dart` |
| D-3 | "เดิน: บันทึกเอง" | ตัดออก — `isTrackingLocked` = ไม่มีข้อความเดิน · AC-15 / EC-12 ไม่ทำ | `NotificationLogic.candidates`, ไม่มีข้อความ/คีย์ใน `NotificationRules`/`NotificationStorageKeys` |
| D-4 | EC-3 | ค่าติดลบ / `daily_goal` = 0 → ระงับเรื่องนั้นทั้งรอบวัน (เฉพาะ notification) | `NotificationLogic.invalidTopics`, `NotificationDayPlan.suppressedTopics` |
| D-5 | Package | `flutter_local_notifications`, `timezone`, `flutter_timezone` ในเครื่องเท่านั้น · คำนวณล่วงหน้า ตั้งใหม่ทุกครั้งที่ข้อมูลเปลี่ยน/เปิดแอป | `notification_local_scheduler.dart`, `NotificationController._sync` |
| D-6 | ตั้งเวลา | `AndroidScheduleMode.inexactAllowWhileIdle` ไม่ขอ exact alarm | `LocalNotificationScheduler.schedule`, manifest |
| Q-03..Q-27 | ค่าชั่วคราวใน ui-spec §7 | ใช้ทุกข้อ (`// ASSUMPTION: ui-spec Q-xx`) | ตามตารางด้านล่าง |
| Q-28 | ออกจากระบบ (เปลี่ยนจาก ui-spec) | logout → ยกเลิกแจ้งเตือนทั้งหมด (`cancelAll` + ล้างแผนของวัน) ไม่เปลี่ยน consent/สวิตช์ · เข้าระบบใหม่ + เข้า Home แล้วจึงวางแผนใหม่ | `SignupController.onSignedOut` → `NotificationController.onSignedOut()` (`_active = false`, `cancelAll`, `_plan = null`) · `WaterHomeScreen.initState` → `start()` (`_active = true`) |

## API สาธารณะสำหรับ QA

- **logic (pure):** `NotificationLogic.buildPlan(NotificationInputs inputs, NotificationDayPlan? previous, DateTime now) → NotificationDayPlan` (items = committed + pending เรียงเวลา) · `NotificationLogic.schedule(candidates, day:, now:, committed:)` (คิว §2.4.4 ล้วน) · `candidates(inputs, plan, now, suppressed:)` · `committed/pending(plan, now)` · `sentCount/lastSentAt/walkNearGoalSentToday(plan, now)` · `notificationId(day, message, anchor)` · `encodePayload(message)` / `decodePayload(payload) → NotificationTopic?` · `isQuietTime(t, [day])` · `inputsFor(...)` แปลงค่าดิบของ 3 controller
- **controller:** `NotificationController({required repository, required scheduler, required water, required steps, required food, avatar?, clock?, timerFactory?})` · `load()`, `start()`, `stop()`, `answerConsent(allowed:)`, `setMasterSwitch(bool)`, `onAppResumed()`, `handleNotificationTap(String?)`, `takePendingDeepLink()`, `onSignedOut()` · getters `isLoaded`, `consentStatus`, `masterSwitch`, `systemPermission`, `isSwitchOn`, `isRequestingPermission`, `canSchedule`, `pendingDeepLink`, `plan`, `lastStepsIncreasedAt` · เมธอดที่ trigger sync คืน Future ที่เสร็จเมื่อ sync (รวมรอบที่รวบไว้) เสร็จ
- **clock:** ส่งฟังก์ชันเดียวกันให้ `WaterController/StepsController/FoodController/NotificationController(clock:)`
- **timer:** `typedef NotificationTimerFactory = Timer Function(Duration interval, void Function() onTick)` (default `Timer.periodic`) — Timer ถูกสร้างใน `start()` และยกเลิกใน `stop()` / `dispose()` (WaterHomeScreen เรียก `stop()` ตอน dispose → widget test ไม่มี Timer ค้าง)
- **fake scheduler:** `implements NotificationScheduler` ต้องมี 7 เมธอด: `initialize({onTap})`, `launchPayload()`, `checkPermission()`, `requestPermission()`, `schedule(PlannedNotification)`, `cancel(int id)`, **`cancelAll()`** (เพิ่มจาก ui-spec สำหรับ Q-28 — การวางแผนปกติไม่เรียก)
- **fake avatar:** `implements NotificationAvatarSource { Future<Uint8List?> avatarPng(); }` (controller เรียกแค่ prewarm — ไม่ส่งก็ได้)
- **repository:** `InMemoryNotificationRepository([NotificationState])` + getter `state`
- **Keys:** `notification_consent_card`, `notification_consent_pet_image`, `notification_consent_title_text`, `notification_consent_body_text`, `notification_consent_allow_button`, `notification_consent_deny_button`, `notification_settings_header_text`, `notification_master_switch`, `notification_master_switch_label`, `notification_permission_denied_banner`, `notification_permission_denied_text`, `notification_settings_entry_button`
- **wiring ในเทสต์:** `PetPalApp(waterController:, stepsController:, foodController:, notificationController:)` — WaterHomeScreen ใช้ `notificationController.steps/food` เป็น fallback ถ้าไม่ส่ง steps/food

## AC / EC → โค้ด

| AC / EC | โค้ด |
|---|---|
| AC-1, AC-4 | `WaterHomeScreen._onNotificationChanged` (เปิดเมื่อ `isLoaded && consentStatus == unanswered`, flag กันซ้อน) + `showNotificationConsentCard` |
| AC-2 | `answerConsent(allowed: true)` → `requestPermission()` 1 ครั้ง (หลังการ์ด pop) → GRANTED = `buildPlan` + `schedule` |
| AC-3 | `answerConsent(allowed: false)` → DENIED/OFF ไม่เรียก `requestPermission` |
| AC-5 | `isSwitchOn` = master ON && (GRANTED หรือกำลังรอกล่อง) · `SwitchListTile.value` |
| AC-6, EC-9 | `setMasterSwitch(true)` ขณะไม่ใช่ GRANTED → `_wantPermissionRequest` → `requestPermission()` ใน `_syncOnce` |
| AC-7 | `_syncOnce` `!canSchedule` → `cancel(id)` ทุกรายการ pending → `committedOnly` |
| AC-8, EC-10 | banner เมื่อ `systemPermission == denied` · `isSwitchOn` false · `onAppResumed` → `checkPermission` |
| AC-9 | `candidates` `walkInactive` (anchor = `anchorFor(last_steps_increased)` + 4 ชม.) · `_trackSteps` เขียนเวลาก้าวใหม่ |
| AC-10..AC-14, EC-11 | `isNearGoal` (จำนวนเต็ม `steps*100 >= goal*80 && < goal*100`) · วันละครั้ง (anchor 06:00) |
| AC-15, EC-12 | **ไม่ทำ (D-3)** |
| AC-16..AC-19, EC-4 | `waterFirst`/`waterSecond` (anchor + 2/4 ชม.), `waterCount < waterDailyGoalGlasses` |
| AC-20, AC-21 | `foodUnlogged` 12/15/18 เมื่อ `totalCalories == 0` |
| AC-22..AC-25 | `foodNight` 21:00 (มีเป้า: < เป้า · ไม่มีเป้า: == 0) |
| AC-26, AC-27, AC-33, EC-7 | `schedule()` `t >= activeStart`, break เมื่อ `t >= quietStart` · `anchorFor` ใช้ค่าที่มาทีหลังกับ 06:00 |
| AC-28, EC-15 | `schedule()` `count < dailyNotificationCap` (นับ committed) |
| AC-29, AC-30 | `t = last + 30 นาที` (29:59 → เลื่อนเป็น 30:00) |
| AC-31, EC-5 | `_byPriority` (priority → dueAt → enum) |
| AC-32 | รายการที่ dueAt ≤ t แต่ถูกเลื่อน ยังอยู่ใน remaining จนได้คิว |
| AC-34, EC-6 | anchor เปลี่ยน (บันทึกน้ำ/ก้าวใหม่) → id ใหม่ → `cancel(old)` + `schedule(new)` · อาหาร > 0 → ไม่มีผู้สมัคร → cancel |
| AC-35, EC-8 | `planForToday` (แผนวันอื่น = ว่าง) → count/nearGoal derive ใหม่ · Timer `dayCheckInterval` ตรวจรอบวัน |
| AC-36 | `LocalNotificationScheduler._details` Android: `MessagingStyleInformation(Person(name 「น้องอ๊บ」, icon ByteArrayAndroidIcon(avatar)))`, title 「น้องอ๊บ」 |
| AC-37 | iOS: `DarwinNotificationDetails(presentBanner: true, …)`, title null — **ตรวจจากโค้ดเท่านั้น** (ไม่มี app/ios — Q-12) |
| AC-38..AC-40, EC-2 | `handleNotificationTap` → `pendingDeepLink` → `WaterHomeScreen._openDeepLink` (`popUntil(isFirst)` + push Steps/Food หรือไม่ push สำหรับน้ำ) |
| EC-13 | `main()` `launchPayload()` ก่อน `runApp` → นำทางเมื่อ Home + water โหลดเสร็จ |
| EC-1 | `_sync` serialized + coalesce (`_syncFuture`, `_dirty`) สถานะสุดท้ายชนะ |
| EC-3 | `invalidTopics` → `suppressedTopics` ของแผนวันนั้น (Q-20) |
| EC-14 | `start()` เมื่อเข้า Home → `buildPlan` ของวันปัจจุบัน |

## การตัดสินใจ / สมมติฐาน (ASSUMPTION)

ใช้ค่าชั่วคราวของ ui-spec ทุกข้อ: Q-03 (ป้ายสวิตช์), Q-04 (tooltip), Q-05 (DENIED กด ON ขออีกครั้ง), Q-06 (ตัดขั้นที่เลยเวลา), Q-07 (ไม่ตัดเพราะช้า), Q-08 (dueAt ใกล้เป้า = ตอนตรวจพบ), Q-09 (channel), Q-10 (`@mipmap/ic_launcher`), Q-11 (พื้นโปร่งใส), Q-12 (iOS ในโค้ดเท่านั้น), Q-15 (Android < 13), Q-16 (deep link ค้างในหน่วยความจำ), Q-17 (popUntil), Q-18, Q-19 (fallback เขตเวลา), Q-20, Q-21 (`notification_day_plan`), Q-22 (PopScope), Q-23, Q-24 (บันทึกไม่ได้คงในหน่วยความจำ), Q-25 (FNV-1a hash), Q-26 (foreground แสดงแจ้งเตือน OS), Q-27 (ไม่แก้ label)

สมมติฐานเพิ่มของ Dev:
1. **`canSchedule` = ตอบการ์ดแล้ว (ไม่ใช่ UNANSWERED) + master ON + GRANTED + ไม่ได้ออกจากระบบ** — ui-spec §2.4.5 ข้อ 2 เขียนว่า "consent ไม่ใช่ ALLOWED = ไม่ตั้งเวลา" แต่ EC-9 (กดไม่อนุญาตแล้วเปิดสวิตช์ทีหลัง) ต้องได้แจ้งเตือน ทั้งที่ consent ยังเป็น DENIED (consent เปลี่ยนครั้งเดียวบนการ์ด) → เลือกทางที่ EC-9 ทำงาน
2. `checkPermission()` ตอบ "ปิด" ขณะที่เก็บไว้เป็น NOT_DETERMINED (Android 13+/iOS ก่อนเคยขอ) → คง NOT_DETERMINED (ไม่แสดง banner ก่อนผู้ใช้เคยถูกถาม และ AC-6 ยังขอได้)
3. ผล `requestPermission()` เป็น NOT_DETERMINED (Noop / แพลตฟอร์มไม่รองรับ) → คงค่าเดิม
4. `daily_goal` ติดลบถือเป็นค่าผิดเหมือน 0 (EC-3)
5. `walkNearGoal` anchor = 06:00 ของรอบวัน (ครั้งเดียวต่อวัน) · ขณะยังรอส่งคง dueAt เดิม (id/เวลาไม่ขยับทุกครั้งที่วางแผนใหม่)
6. Q-06 ตัดเฉพาะผู้สมัครที่เลยเวลา "และไม่ได้อยู่ในแผนที่รอส่ง" — รายการที่ถูกเลื่อนอยู่แล้วไม่ถูกตัด (AC-32)
7. รายการที่ `scheduledAt == now` ถูกแสดงทันที (`show()` เมื่อ ≤ now + 5 วินาที) และนับเป็น committed ทันที → ปิดสวิตช์ทีหลังไม่ยกเลิก (เทสต์ EC-1/AC-7 ที่ต้องการ "ไม่มีรายการค้าง" ควรตั้ง now ก่อนเวลาครบกำหนด เช่น 07:00 ไม่ใช่ 08:00 พอดี)
8. `decodePayload`: message ไม่รู้จักยังนำทางตาม topic · message ที่รู้จักแต่ไม่ตรง topic → null
9. avatar ส่งให้ทั้ง controller (prewarm ใน `start()`) และ `LocalNotificationScheduler` (ใช้จริง) — interface `schedule(item)` ไม่มีพารามิเตอร์รูป
10. เพิ่ม `cancelAll()` ใน `NotificationScheduler` สำหรับ Q-28 เท่านั้น
11. Q-28: ผูกผ่าน field `SignupController.onSignedOut` (ตั้งใน main — สร้าง controller ก่อน notification จึงส่งผ่าน constructor ไม่ได้) · ล้างเฉพาะแผน (`notification_day_plan` + ค่าที่ derive) ไม่ล้าง `last_steps_increased_timestamp` · ผลข้างเคียง: เข้าระบบใหม่วันเดียวกัน เพดาน 6 / ระยะห่างนับใหม่
12. `start()` / `stop()` ผูกกับอายุของ WaterHomeScreen (listener 3 controller + Timer) · `start()` เรียกหลัง water โหลดเสร็จ (ไม่โหลด water ซ้อน) และโหลด steps/food เองถ้ายังไม่โหลด
13. deep link รอให้การ์ด S-1 ปิดก่อน (`popUntil` จะปิดการ์ดโดยไม่มีคำตอบ)
14. อ่าน storage ไม่ได้ → DENIED/OFF ในหน่วยความจำ (ux-flow §4 S-1 ERROR) — ถ้าผู้ใช้เปลี่ยนสวิตช์ภายหลัง ค่าจะถูกบันทึก
15. `answerConsent` ทำงานครั้งเดียว (consent ไม่ใช่ UNANSWERED แล้ว → ไม่ทำอะไร)
16. plugin เริ่ม/ตั้งเวลา/ยกเลิกไม่สำเร็จ → ข้าม ไม่มี UI ผิดพลาด แอปยังเปิดได้
17. บันทึกลงเครื่องเฉพาะเมื่อสถานะเปลี่ยน (เทียบ signature) ลดการเขียนซ้ำ
18. `compileSdk = maxOf(flutter.compileSdkVersion, 37)` — README ของ flutter_local_notifications 23 กำหนด compileSdk ≥ 37 (Flutter 3.47 ค่าเริ่ม 36) · ui-spec §5 ไม่ได้ระบุ
19. เวลาใน `inputsFor`: ค่าของรอบวันอื่น (water `lastLoggedAt`, steps/food `state.day`) ถือเป็น 0 / null

รวม 19 ข้อ (+ Q-03..Q-27 ของ ui-spec)

## Package ที่เพิ่ม (`flutter pub add flutter_local_notifications timezone flutter_timezone`)

| package | constraint | resolved | เหตุผล |
|---|---|---|---|
| flutter_local_notifications | ^23.0.0 | 23.0.0 | แจ้งเตือนในเครื่อง / ตั้งเวลา / MessagingStyle (D-5) |
| timezone | ^0.11.2 | 0.11.2 | `TZDateTime` สำหรับ `zonedSchedule` (D-5) |
| flutter_timezone | ^5.1.1 | 5.1.1 | ชื่อเขตเวลาเครื่อง (D-5) |

ไม่มี network / analytics / crash reporting / workmanager

## ผลรันคำสั่ง

- `flutter pub add ...` — สำเร็จ (มีคำเตือน "Building with plugins requires symlink support / Developer Mode" ของ Windows — ไม่กระทบ analyze/test)
- `flutter analyze` (app/): **No issues found!**
- `flutter test` (app/ ทั้งหมด): **+797: All tests passed!** (ระหว่างทางเคยพัง 1 ข้อ `LEGACY_lib_has_no_pet_png_reference` เพราะคอมเมนต์ของ Dev มีชื่อ `pet_profile_frog.png` → แก้คอมเมนต์ ไม่แตะเทสต์)
- ตรวจเองชั่วคราว (`app/tmp_notification_check/` นอก app/test — **ลบแล้ว**) 18 + 4 เทสต์ ผ่าน: T-1, T-2, T-3, T-4, T-5, T-6, T-7, T-9, T-10, T-12, T-13, T-14, T-15, T-16, T-18, payload/id/json round-trip · controller: allow→request→schedule และบันทึกน้ำ cancel+ตั้งใหม่ (T-17), deny ไม่ขอสิทธิ์ + EC-9, EC-1 สลับรัวจบ OFF ไม่มีรายการค้าง, DENIED → resume GRANTED, Q-28 cancelAll + ไม่ตั้งเวลาจนกว่า start() · widget: การ์ด S-1 (แตะฉากหลังไม่ปิด, back ไม่ปิด, allow ปิด + request 1 ครั้ง), ไม่มีการ์ดเมื่อตอบแล้ว, dashboard → ปุ่มตั้งค่า → S-2 banner + สวิตช์ OFF, deep link walk/food/food ซ้ำ/water จาก S-2 (stack ถูกต้อง), ไม่มี overflow ของการ์ด/S-2/AppBar dashboard ที่ 360×640 และ 360×480 textScaler 1.0/1.5
- `flutter` แก้ `app/windows/flutter/generated_plugin_registrant.cc/.h`, `generated_plugins.cmake` (**เนื้อหาเปลี่ยน** — ลงทะเบียน plugin windows ของ `flutter_timezone`, `flutter_local_notifications_windows` ไม่ใช่แค่ line ending) → `git checkout` คืนตามคำสั่ง (ห้ามแตะ app/windows/) · flutter จะสร้างใหม่ทุกครั้งที่ pub get/test/build
- ไม่ได้ build APK (เครื่องนี้มี Android SDK 35/36/36.1 ไม่มี 37)

## คำถามค้าง (ส่งทีเดียว)

1. (Dev → owner) Android build: flutter_local_notifications 23 ต้องการ compileSdk 37 — ตั้ง `maxOf(flutter.compileSdkVersion, 37)` แล้ว แต่เครื่องนี้ไม่มี SDK 37 จึงยังไม่ได้ build/ทดสอบบนเครื่องจริง · ยืนยันว่าจะติดตั้ง SDK 37 หรือต้องการ pin plugin รุ่นเก่ากว่า
2. (Dev → owner) ไฟล์ generated ใน `app/windows/flutter/` จะเปลี่ยนเนื้อหาเองหลัง pub get (เพิ่ม plugin ใหม่) — คืนไว้ตามคำสั่งแล้ว ควร commit ไฟล์ที่ flutter สร้างใหม่หรือไม่ (ถ้าไม่ commit build windows จะสร้างใหม่เอง)
3. (Dev → UI/Design) ui-spec §2.4.5 ข้อ 2 "consent ไม่ใช่ ALLOWED = ไม่ตั้งเวลา" ขัดกับ EC-9 — Dev ใช้ "ตอบการ์ดแล้ว" (สมมติฐาน 1) ขอยืนยัน
4. (Dev → owner) Q-28: ล้างแผนตอน logout ทำให้เข้าระบบใหม่วันเดียวกันได้แจ้งเตือนเพิ่มอีกสูงสุด 6 (เพดาน/ระยะห่างนับใหม่) — รับได้หรือไม่
5. (Dev → QA/UI) หน้า Home (WaterHomeScreen เดิม) ที่ 360×640 textScaler 1.5 overflow 68 px อยู่แล้วก่อนงานนี้ (ตรวจโดยไม่มี notification) — เทสต์ "Home + S-1 ไม่ overflow ที่ 1.5" (ui-spec §6) จะเจอ overflow ของ Home ไม่ใช่ของการ์ด · การ์ดที่ 1.5 ด้วยฟอนต์เทสต์สูงเกินจอ → เลื่อนได้ (SingleChildScrollView) ไม่ overflow — ต้อง `ensureVisible` ก่อนกดปุ่ม
6. (ซ้ำ ui-spec Q-13/Q-14) docs ยังอ้าง `pet_profile_frog.png` และ "เดิน: บันทึกเอง" — ขอ Design/Product อัปเดต (Dev ไม่แก้ docs)
7. (ซ้ำ ui-spec Q-10) ไอคอนเล็ก monochrome ของ Android เป็นงานของ Art

## ตัวเลขการทำงาน

- เวลาที่ใช้: ประมาณ 18 นาทีตามนาฬิกาเครื่อง (16:15 → 16:33 — อ่านเอกสาร/โค้ด ~5, เขียนโค้ด ~7, ตรวจ/เทสต์/log ~6)
- ไฟล์ที่สร้าง: 10 (app/lib/features/notification/) + log 1 · ไฟล์ชั่วคราว 2 (ลบแล้ว)
- ไฟล์ที่แก้: 8 (main.dart, water_home_screen.dart, dashboard_screen.dart, signup_controller.dart, pubspec.yaml, pubspec.lock, AndroidManifest.xml, build.gradle.kts)
- จำนวนสมมติฐาน: 19 ของ Dev (+ Q-03..Q-27 ของ ui-spec)
- จำนวนคำถาม: 7 (ไม่มีข้อที่บล็อกงาน)
- เทสต์เดิมที่พัง: 0

---

## รอบ 2 — 2026-11-08 16:34–16:40 (ตามข้อตัดสิน owner ต่อคำถาม 7 ข้อ)

### ข้อตัดสิน owner รอบ 2 — DECIDED (owner) 2026-11-08

| # | คำถาม | ข้อตัดสิน | ผล |
|---|---|---|---|
| 1 | compileSdk 37 | ห้ามบังคับ SDK ที่ไม่มีในเครื่อง → pin `flutter_local_notifications` รุ่นใหม่สุดที่ build ได้กับ compileSdk ที่มี (35/36/36.1) + Flutter ในเครื่อง · เอา `maxOf(..., 37)` ออก · พิสูจน์ด้วย `flutter build apk --debug` | pin **22.3.3** (CHANGELOG: 23.0.0 ขยับเป็น compileSdk 37 + AGP 9.1.1; 22.x ใช้ compileSdk 36) · `compileSdk = flutter.compileSdkVersion` (36) · desugaring 2.1.4 คงไว้ (README 22.3.3 ยังกำหนด) · build ผ่าน |
| 2 | ไฟล์ generated ใน app/windows/ | คืนด้วย `git checkout` ไม่ commit | คืนแล้วหลัง pub add / build / test ทุกครั้ง — `git status` ไม่มี app/windows/ |
| 3 | EC-9 กับ ui-spec §2.4.5 | รับ — ตั้งเวลาเมื่อตอบการ์ดแล้ว (อนุญาตหรือไม่ก็ได้) + สวิตช์ ON + GRANTED | สมมติฐาน 1 เป็นข้อตัดสินแล้ว (โค้ดไม่เปลี่ยน — `NotificationController.canSchedule`) |
| 4 | Q-28 ล้างแผนตอน logout | รับ — เข้าระบบใหม่วันเดียวกันได้เพิ่มอีกสูงสุด 6 | สมมติฐาน 11 เป็นข้อตัดสินแล้ว (โค้ดไม่เปลี่ยน) |
| 5–7 | Home overflow ที่ 1.5 / docs อ้าง PNG และ "บันทึกเอง" / ไอคอน monochrome | รับทราบ ไม่แก้โค้ด (QA จด 5 เป็นข้อสังเกต · 6/7 ค้างกับ Design/Art) | — |

### การเปลี่ยนแปลง

- `app/pubspec.yaml`: `flutter_local_notifications: 22.3.3` (pin ตรงรุ่น ผ่าน `flutter pub add "flutter_local_notifications:^22.3.3"` → pub เขียนเป็น `22.3.3`) · `timezone: ^0.11.2`, `flutter_timezone: ^5.1.1` ไม่ต้องเปลี่ยน
- `app/pubspec.lock`: flutter_local_notifications 22.3.3, _platform_interface 12.2.0, _linux 8.0.2, _web 1.0.0, _windows 3.1.1 · timezone 0.11.2 · flutter_timezone 5.1.1
- `app/android/app/build.gradle.kts`: `compileSdk = flutter.compileSdkVersion` (เอา `maxOf(..., 37)` ออก + คอมเมนต์ DECIDED รอบ 2) · desugaring เดิมคงไว้
- โค้ด Dart: ไม่เปลี่ยน — API ของ 22.3.3 ที่ใช้ (named params ของ `initialize(settings:)`, `show(id:)`, `zonedSchedule(id:, scheduledDate:, notificationDetails:, androidScheduleMode:)`, `cancel(id:)`) เหมือน 23.0.0 · **API สาธารณะสำหรับ QA ไม่เปลี่ยน**
- สมมติฐานข้อ 18 (compileSdk 37) ถูกยกเลิก · คำถามค้างข้อ 1–4 ปิดแล้ว

### ผลรันคำสั่ง (รอบ 2)

- `flutter build apk --debug` (app/): **สำเร็จ** — `√ Built build\app\outputs\flutter-apk\app-debug.apk` (Gradle assembleDebug 223.8s, exit 0) · มีคำเตือน "SDK XML version 4" ของ command-line tools (ไม่กระทบ) · build/ ไม่ถูก track ใน git
- `flutter analyze` (app/): **No issues found!**
- `flutter test` (app/ ทั้งหมด): **+797: All tests passed!**
- `git checkout -- app/windows/` หลังทุกคำสั่ง flutter — ไม่มีไฟล์นอกขอบเขตเปลี่ยน

### คำถามค้างหลังรอบ 2

- 5 (ข้อสังเกตของ QA), 6 (Design/Product อัปเดต docs), 7 (Art ไอคอน monochrome) — ไม่บล็อก

### ตัวเลขรอบ 2

- เวลา ~6 นาที (+ build 3.7 นาที) · ไฟล์ที่แก้ 3 (pubspec.yaml, pubspec.lock, build.gradle.kts) + log · สมมติฐาน −1 (ข้อ 18 ยกเลิก; ข้อ 1, 11 เป็น DECIDED) · คำถามค้าง 3

---

## รอบ 3 — 2026-11-08 ~16:58–17:05 (แก้บั๊ก loop 1/3 จาก QA รอบ 1)

อ่าน: docs/notification-feature/test-report.md, logs/20261108-1702_qa_notification-feature.md · แก้เฉพาะ app/lib/ · ไม่แตะ app/test/notification/ · คืน app/windows/ หลังทุกคำสั่ง flutter

### ข้อตัดสิน owner รอบ 3 — DECIDED (owner) 2026-11-08

| # | เรื่อง | ข้อตัดสิน | ในโค้ด |
|---|---|---|---|
| QA คำถาม 1 | 21:00 กับขั้นอาหารที่เลยเวลา (Q-06) | game-rules ชนะ: ตั้งแต่ 21:00:00 ไม่ส่ง "อาหาร: ยังไม่กิน" เลย (ขั้น 12/15/18 ที่เลยเวลาถูกตัด) ส่งได้เฉพาะ "อาหาร: 21:00" → เปิดแอปครั้งแรก 21:00 = `foodNight` 21:00 ไม่มี `foodUnlogged` | `notification_logic.dart` `_dropStaleSteps` (now ≥ 21:00 → ตัด `foodUnlogged` ทั้งหมด) + `schedule()` (t ≥ 21:00 → เอา `foodUnlogged` ที่ถูกเลื่อนออกจากคิว) |
| QA คำถาม 2 | ค่า derive ในเครื่องอัปเดตตอน sync เท่านั้น | รับตามเดิม | ไม่เปลี่ยน |

### การแก้

| บั๊ก | สาเหตุ | แก้ (ไฟล์ / บรรทัด) |
|---|---|---|
| BUG-NOTI-1 (ปานกลาง) วางแผนซ้ำแล้ว `waterFirst` ที่ Q-06 ตัดไว้กลับมา แผน T-18 เลื่อน `foodNight` หลุดเพดาน | `_dropStaleSteps` นับเป็น "เลยเวลา" เฉพาะรายการที่ไม่เคยรอส่ง (`!wasPending`) — พอ `waterSecond` อยู่ในแผนแล้ว สายน้ำเหลือ stale 1 รายการ (`waterFirst`) จึงไม่ถูกตัด | `app/lib/features/notification/notification_logic.dart` `_dropStaleSteps` (~บรรทัด 318–352): ตัดสินจาก `dueAt < now` ของสายเท่านั้น (ไม่ดู pending) → ทุกสายเก็บเฉพาะขั้นล่าสุดที่เลยเวลา วางแผนซ้ำด้วยข้อมูลเดิม = แผนเดิม (controller จึงไม่ schedule/cancel เพิ่ม) · พารามิเตอร์เปลี่ยนจาก `previousPending` เป็น `day` (private) · สมมติฐาน 6 เดิม ("ไม่ตัดรายการที่รอส่งอยู่") ถูกยกเลิก — ผลข้างเคียง: รายการที่ถูกเลื่อนอยู่ ถ้าขั้นถัดไปของสายเดียวกันเลยเวลาแล้ว จะเหลือเฉพาะขั้นถัดไป (ตรง Q-06) |
| BUG-NOTI-2 (ต่ำ) deep link ค้างไม่ถูกนำทางหลังตอบการ์ด S-1 เมื่อผลขอสิทธิ์กลับทันที / กดไม่อนุญาต | การ์ดปิดแล้ว `_onNotificationChanged()` ทำงานก่อน `answerConsent` เปลี่ยน consent → ตั้งการ์ดใหม่ (flag เปิด) ทำให้ข้าม deep link · เฟรมถัดไป `_showConsentCard` ออกทาง early return โดยไม่ตรวจซ้ำ | `app/lib/features/water/screens/water_home_screen.dart` `_showConsentCard` (บรรทัด ~175–179): early return (consent ตอบแล้ว) เรียก `_onNotificationChanged()` อีกครั้ง → deep link ถูกนำทางหลังการ์ดปิด |
| 21:00 (DECIDED) | — | `notification_logic.dart` `_dropStaleSteps` + `schedule()` (~บรรทัด 418–425) |

API สาธารณะสำหรับ QA: **ไม่เปลี่ยน** (`buildPlan`, `candidates`, `schedule` signature เดิม)

### ผลรันคำสั่ง (รอบ 3)

- `flutter analyze` (app/): **No issues found!**
- `flutter test` (app/ ทั้งหมด): **+935 −1** — 4 เทสต์ของบั๊ก (`T18_Q06_replan_same_minute_keeps_T18_plan`, `T18_Q06_replan_at_1405_keeps_T18_plan`, `EC14_open_app_new_day_plans_today_T18`, `EC13_Q16_TERMINATED_with_unanswered_card_navigates_after_answer`) **ผ่านแล้ว**
- ข้อที่ไม่ผ่าน 1 ข้อ: `QUESTION_QA1_first_open_at_2100_no_food_logged_both_food_messages_planned` — `expect(slotsOfMessage(p, M.foodUnlogged), hasLength(1))` ได้ `[]` · เป็นผลตรงตามข้อตัดสิน owner 21:00 (ไม่มี `foodUnlogged` ตั้งแต่ 21:00) — **ให้ QA ปรับเทสต์เป็น foodUnlogged 0 รายการ + foodNight 21:00:00** (Dev ไม่แก้ app/test/)
- `git checkout -- app/windows/` หลังทุกคำสั่ง flutter

### ตัวเลขรอบ 3

- เวลา ~7 นาที · ไฟล์ที่แก้ 2 (notification_logic.dart, water_home_screen.dart) + log · สมมติฐาน −1 (ข้อ 6 ยกเลิก) · DECIDED +2 · คำถามค้างใหม่ 0

---

## รอบ 4 — 2026-11-08 (จบ 20:24 ตาม `date`) — แก้บั๊ก loop 2/3: BUG-NOTI-1 (ยังเปิดจาก QA รอบ 2)

อ่าน: docs/notification-feature/test-report.md §9, logs/20261108-1709_qa_notification-feature_r2.md · แก้เฉพาะ app/lib/ · ไม่แตะ app/test/notification/ · คืน app/windows/ หลังทุกคำสั่ง flutter

### สาเหตุ (ราก)

การตัดตาม Q-06 ("เก็บเฉพาะขั้นล่าสุดที่เลยเวลาของสาย") ตัดสินที่ `now` ของการวางแผน และดูเฉพาะผู้สมัคร — `candidates()` ข้ามรายการที่ committed ก่อนถึง `_dropStaleSteps` จึงไม่รู้ว่าขั้นหลังของสายถูกส่งไปแล้ว (เช่น `waterSecond` ส่ง 14:30 → วางแผนที่ 16:10 เหลือ `waterFirst` ที่เลยเวลาตัวเดียว → กลับมา) และผลยังขึ้นกับ `now` ของการวางแผน ไม่ใช่เวลาที่คิวจะส่งจริง → วางแผนซ้ำแล้วแผนเปลี่ยน

### การแก้ (app/lib/features/notification/notification_logic.dart)

1. `_chainKey(item)` (~บรรทัด 322): สาย = น้ำ `waterFirst`/`waterSecond` ของ anchor เดียวกัน (รอบนับเดียวกัน — บันทึกน้ำ = รอบใหม่) · อาหาร `foodUnlogged` ทั้งรอบวัน (เทียบตามสาย ไม่ใช่ anchor) · ข้อความอื่น = ไม่อยู่ในสาย
2. `_dropSupersededByCommitted` (~บรรทัด 333, แทน `_dropStaleSteps`): ผู้สมัครที่มีขั้นหลังของสายเดียวกัน (dueAt มากกว่า) committed แล้ว → ไม่วางแผนอีก · คงกฎ 21:00 (now ≥ 21:00 → ไม่มี `foodUnlogged`)
3. `_supersededInChain` (~บรรทัด 359) ใช้ใน `schedule()` (~บรรทัด 450): ณ เวลาคิว `t` ในชุดที่ถึงเวลาแล้ว (dueAt ≤ t) ถ้าสายเดียวกันมีหลายขั้น เก็บขั้นล่าสุด ขั้นก่อนหน้าถูกตัดถาวร — Q-06 ตัดสินที่ "เวลาที่จะส่งจริง" ผลจึงขึ้นกับ t และรายการที่เหลือเท่านั้น
4. ผล: invariant `buildPlan(i, buildPlan(i, prev, t1), t2)` (t2 ≥ t1, inputs เดิม) = แผนแรก (committed เดิม + pending เดิม) → controller ไม่ schedule/cancel เพิ่ม · T-18 เดิม · รายการที่ถูกเลื่อนจนขั้นถัดไปของสายถึงเวลา → ถูกตัดตั้งแต่แผนแรก (ตรง `Q06_R2_deferred_waterFirst_dropped_when_waterSecond_overdue`)
- รอบ 3 คงเดิม: กฎ 21:00 (candidates + `schedule()` ตัด `foodUnlogged` เมื่อ t ≥ 21:00) และ BUG-NOTI-2 (`water_home_screen.dart`) ไม่แตะ
- API สาธารณะ: **ไม่เปลี่ยน** (`buildPlan`, `candidates`, `schedule` signature เดิม — `schedule()` ตอนนี้ใช้กฎสาย Q-06 ภายในด้วย)
- ASSUMPTION ที่ปรับ: Q-06 ตัดสินที่เวลาคิว (dueAt ≤ t) — ขั้นก่อนหน้าที่คิวเลื่อนไปถึงเวลาครบกำหนดของขั้นถัดไปพอดีจะถูกตัด (ขั้นถัดไปส่งแทน)

### ตรวจเองชั่วคราว (tmp_noti_r4/ นอก app/test — **ลบแล้ว**)

วางแผนแรกที่เวลาเริ่ม แล้ววางแผนซ้ำ "ทุก 1 นาที" จนถึง 04:58 วันถัดไป ทั้งแบบต่อกัน (`buildPlan(i, แผนก่อนหน้า, t)`) และแบบตรงจากแผนแรก (`buildPlan(i, p0, t)`) — ตรวจว่า `items` เท่าแผนแรกทุกครั้ง:
- T-18 (ไม่มีข้อมูล เปิด 14:00): 899 ครั้งผ่าน — `foodUnlogged` 14:00 · `waterSecond` 14:30 · `foodUnlogged` 15:00 · `walkInactive` 15:30 · `foodUnlogged` 18:00 · `foodNight` 21:00
- T-1 (05:30): 1,409 ครั้ง · ผสมที่มีการเลื่อน (น้ำ 10:00 + อาหาร, 11:00): 1,079 · ใกล้เป้าก้าว (13:00): 959 · เปิด 20:00: 539 · เปิด 21:00 (`foodNight` 21:00 ไม่มี `foodUnlogged`): 479 · สายน้ำเลยเวลา 10:15 (`waterSecond` 10:15 เท่านั้น): 1,124
- เปิดครั้งแรกทุก 30 นาที 06:00–22:00 (33 จุด) วางแผนซ้ำทุก 7 นาที: ผ่านทั้งหมด
- ทุกกรณีผ่าน ไม่มีแผนเปลี่ยน

### ผลรันคำสั่ง (รอบ 4)

- `flutter analyze` (app/): **No issues found!**
- `flutter test` (app/ ทั้งหมด): **+948: All tests passed!** — รวม 4 ข้อที่ล้มรอบ QA 2 (`T18_R2_BUG1_replan_later_1610_after_some_sent_keeps_T18_plan`, `T18_R2_BUG1_replan_after_every_slot_keeps_T18_plan`, `Q06_R2_deferred_waterFirst_dropped_when_waterSecond_overdue`, `R2_BUG1_replan_1400_1405_1610_no_extra_schedule_or_cancel`)
- `git checkout -- app/windows/` หลังทุกคำสั่ง flutter

### ตัวเลขรอบ 4

- ไฟล์ที่แก้ 1 (notification_logic.dart) + log · ไฟล์ชั่วคราว 1 (ลบแล้ว) · คำถามค้างใหม่ 0
