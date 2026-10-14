# Test report: pet (shared PetCharacter — ข้ามฟีเจอร์ water + steps)

- QA · 2026-10-14 · log: logs/20261014-1149_qa_pet.md (รอบ 1), logs/20261014-1218_qa_pet.md (รอบ 2 — หลัง Dev แก้ BUG-PET-1, logs/20261014-1207_dev_pet.md)
- สเปกที่ใช้เป็นค่าคาดหวัง: docs/_design/character.md (§3–§7), docs/water/game-rules.md §2–§3 (ช่วงค่า), docs/steps/game-rules.md §2–§4 (ช่วงค่า), ข้อตัดสิน owner 2026-10-14 (ทั้งแอปใช้ PetCharacter ตัวเดียว, PNG เดิมย้ายไป legacy/ และไม่ bundle)
- โค้ดที่ทดสอบ: app/lib/shared/pet/, หน้าจอ water/steps (Dev log 20261014-1141) — ไม่ได้แก้ app/lib/

## 1. ข้อกำหนด → เทสต์

| ข้อกำหนด (เอกสาร) | เทสต์ | ผล |
|---|---|---|
| §5 preset 7 ท่า → สีหน้า/รูปร่าง/หน้าที่วาด | pet_character_test: `POSE_<preset>_is_<expr>_<body>` ×7, `PAINT_<preset>_static_face_<face>` ×7, `POSE_all_7_presets_are_distinct`, `POSE_equality_and_copyWith` | ผ่าน 16/16 |
| §4 สถานะต่ำ เหงื่อ+ตาปรือ, อื่นไม่มี; blink/funny/cheer แทนหน้า; ประกาย | `LOW_<preset>_sweat_*_droopy_*` ×7, `LOW_sparkles_only_on_happy_and_proud_faces`, `LOW_blink_keeps_mood_but_closes_eyes`, `LOW_action_faces_override_expression` | ผ่าน 10/10 |
| §3 รูปร่าง (FAT กว้างสุด/เตี้ยสุด, LEAN ผอมสุด, CHUBBY สูงสุด, MUSCLE ต้นขากล้าม, FAT พุงพับ/ซ่อนต้นขา) | `BODY_dimensions_match_character_md_table`, `BODY_all_5_shapes_have_different_size`, `BODY_fat_is_widest_and_flattest_lean_is_narrowest`, `BODY_fat_hides_thighs_and_has_belly_roll`, `BODY_muscle_has_big_muscle_thighs_others_not`, `BODY_lean_has_long_thin_thighs` | ผ่าน 6/6 |
| §6/§7 animate:false ไม่มี ticker/Timer, pumpAndSettle จบ, แตะเรียก onTap แต่ไม่กระโดด, cheer ไม่เล่น | `STATIC_no_tickers_no_timers_pumpAndSettle_completes`, `STATIC_tap_calls_onTap_but_no_jump`, `STATIC_cheerTrigger_change_does_not_animate` | ผ่าน 3/3 |
| §6/§7 animate:true: หายใจ, แตะ→jump/funny ที่ 200 ms ยังกระโดดที่ 600 ms หยุดที่ 660 ms (jump 650 ms), reactToTap:false, cheer ที่ 100 ms/850 ms หยุดที่ 910 ms (cheer 900 ms), ค่าลดก็ cheer, rebuild ค่าเดิมไม่ cheer, แตะระหว่าง cheer ไม่ขัด, สลับ true→false หยุด ticker | `ANIM_*` 8 เทสต์ | ผ่าน 8/8 |
| §6 กะพริบสุ่มด้วย Random(seed): ซ้ำได้, ครั้งแรกใน [1800, 1800+3200+180] ms, ตาปิดสั้นกว่า 180 ms | `BLINK_same_seed_same_blink_timeline`, `BLINK_first_blink_within_doc_gap_and_short` | ผ่าน 2/2 |
| §7 dispose ไม่มี Timer/ticker ค้าง | `DISPOSE_animated_pet_leaves_no_tickers_or_timers`, `DISPOSE_while_cheering_no_exception` | ผ่าน 2/2 |
| §6 + water §3: บันทึกน้ำสำเร็จ → cheerTrigger +1 → ดีใจ | pet_screens_cheer_test: `CHEER_water_log_success_increments_trigger_and_pet_cheers`, `CHEER_water_4_to_5_cups_same_mood_cheers`, `CHEER_water_after_5_minutes_cheers_again_count_2` | ผ่าน 3/3 |
| เหมือนข้างบน แต่บันทึกครั้งที่ทำให้อารมณ์เปลี่ยน (3→4, 6→7) | `CHEER_water_3_to_4_cups_cheers_and_switches_to_tired_pose`, `CHEER_water_6_to_7_cups_cheers_and_switches_to_happy_pose` | ผ่าน 2/2 (รอบ 1 ไม่ผ่าน → BUG-PET-1 แก้แล้ว) |
| water AC-3: บันทึกถูกบล็อก (anti-spam) → ไม่ดีใจ | `CHEER_water_blocked_by_anti_spam_does_not_cheer` | ผ่าน |
| animatePet null → ภาพนิ่งระหว่าง flutter test (Dev ASSUMPTION 1) | `DEFAULT_water_animatePet_null_is_static_under_flutter_test` | ผ่าน |
| เพิ่มก้าวสำเร็จ → ดีใจ | `CHEER_steps_add_success_increments_trigger_and_pet_cheers`, `CHEER_steps_two_adds_count_2` | ผ่าน 2/2 |
| เพิ่มก้าวครั้งที่ข้าม 35% (FAT→CHUBBY) → ดีใจ | `CHEER_steps_add_crossing_35_percent_cheers_and_shows_chubby` | ผ่าน (รอบ 1 ไม่ผ่าน → BUG-PET-1 แก้แล้ว) |
| §6 สัตว์เลี้ยงตัวเดิมเมื่อสถานะเปลี่ยน (State เดิม, หายใจไม่เริ่มใหม่) — รอบ 2 | `STATE_water_3_to_4_cups_pet_state_survives_and_keeps_breathing`, `STATE_steps_crossing_35_percent_pet_state_survives` | ผ่าน 2/2 |
| steps §4 ล็อก (permissionDenied/noHardware) → เพิ่มไม่ได้ → ไม่ดีใจ | `CHEER_steps_locked_<status>_add_does_not_cheer` ×2 | ผ่าน 2/2 |
| steps §2 ขอบ 2799/2800/5599/5600/7999/8000 → ท่า (character.md §5) บนหน้าจอ | `POSE_steps_<n>_of_8000_is_<id>` ×6 | ผ่าน 6/6 |
| water §2 ขอบ 0/3/4/6/7/12 แก้ว → ท่า, 3→4, 6→7, รีเซ็ต 05:00 | water_pet_character_test: `POSE_S1_<n>_cups_shows_<mood>` ×6, `POSE_S1_3_to_4…`, `POSE_S1_6_to_7…`, `POSE_S1_after_05_00_reset…` | ผ่าน 9/9 |
| owner 2026-10-14: PNG เดิมอยู่ใน legacy/ ไม่ bundle ไม่มีโค้ดอ้าง | `LEGACY_files_kept_in_assets_images_legacy`, `LEGACY_no_pet_png_in_top_level_assets_images`, `LEGACY_pubspec_does_not_register_legacy_or_pet_png`, `LEGACY_lib_has_no_pet_png_reference`, `LEGACY_asset_manifest_has_no_pet_png_and_load_fails` | ผ่าน 5/5 |
| water AC-2 / steps AC-5 ระดับ logic (`poseFor`) | water_logic_test `AC2_mood_poses_match_game_rules_section_2_and_character_md`; steps_logic_test `AC5_enum_codes_thai_labels_and_poses_per_docs`, `AC5_pose_at_thresholds_2799_2800_5599_5600_7999_8000_of_8000` | ผ่าน 3/3 |
| เทสต์หน้าจอ water เดิมที่ตรวจภาพสัตว์เลี้ยง (ปรับ helper `expectPetMood` เป็น PetCharacter) | water_decisions_screens_test: `EDGE_S1_pet_mood_0_cups_critical`, `AC2_S1_pet_mood_3_cups_critical_then_4_cups_tired`, `EDGE_S1_pet_mood_6_cups_tired_then_7_cups_happy`, `EDGE_S1_pet_mood_after_05_00_reset_back_to_critical` (+ ใช้ใน `EDGE_S1_clock_back_opens…`, `EDGE_S1_bad_type_prefs…`) | ผ่าน |

ข้อกำหนดที่ยังไม่มีเทสต์อัตโนมัติ: §8/QA ข้อ 4 "ทุกสถานะแยกออกด้วยตาที่ 160 px" (ตรวจด้วยตา — ไม่มี golden test), สีใน §2 และลำดับการวาด §3 (ไม่ได้ทดสอบระดับพิกเซล)

## 2. สรุปตัวเลข

รอบสุดท้าย (รอบ 2, `flutter test` ใน app/):
- `01:02 +296: All tests passed!` → ทั้งหมด 296 / ผ่าน 296 / ไม่ผ่าน 0
- `flutter analyze` → `No issues found! (ran in 12.0s)`
- เทสต์ pet: pet_character_test 47 · pet_screens_cheer_test 20 · water_pet_character_test 14 · steps_logic_test +1 (ทั้งหมดผ่าน)
- ข้อกำหนดที่ยังไม่มีเทสต์อัตโนมัติ: ตรวจด้วยตาที่ 160 px / สีและลำดับการวาดระดับพิกเซล (ดู §1)

รอบ 1 (ก่อนแก้): `00:58 +291 -3: Some tests failed.` (294 เทสต์, 3 = BUG-PET-1)

| รายการ | ค่า |
|---|---|
| bug ที่เจอ / ที่ Dev แก้แล้ว | 1 / 1 |
| จำนวนรอบที่ส่งกลับให้ Dev | 1 |
| เทสต์ที่ QA แก้เพราะเทสต์ผิด | 0 |
| locator ที่ปรับตามการแก้โค้ด (รอบ 2) | 3 จุด (กระทบ 21 เทสต์) — ไม่นับเป็นเทสต์ผิด |

## 3. Bug

### BUG-PET-1 (แก้แล้ว — ยืนยันรอบ 2): บันทึกน้ำ/เพิ่มก้าวสำเร็จในครั้งที่ทำให้สถานะสัตว์เลี้ยงเปลี่ยน → สัตว์เลี้ยงไม่ดีใจ (cheer หาย)

ขั้นตอนทำซ้ำ (water)
1. `WaterController(repository: InMemoryWaterRepository(WaterState(cups: 3, lastLoggedAt: 14 ต.ค. 09:00)), clock: () => 14 ต.ค. 10:00)`
2. `pumpWidget(MaterialApp(home: WaterHomeScreen(controller: c, animatePet: true)))` แล้ว pump 16 ms ×5
3. แตะ `water_log_button` → `pump()` → `pump(100ms)`
4. อ่าน painter (`PetKeys.painter`) → `isCheering`

ผลที่คาด: `isCheering == true` — character.md §6 "ดีใจ (cheer) ทำงานเมื่อ cheerTrigger เปลี่ยนค่า", §7 "cheerTrigger: เพิ่มค่าทุกครั้งที่บันทึกน้ำ/ก้าวสำเร็จ → เล่น cheer" (และ water game-rules §3: 3→4 แก้วเป็นการบันทึกสำเร็จ)
ผลจริง: `isCheering == false` (ท่าเปลี่ยนเป็น waterTired ถูกต้อง, `petCheerCount` = 1, `cheerTrigger` = 1) — เทสต์ `CHEER_water_3_to_4_cups_…` (เส้น 103), `CHEER_water_6_to_7_cups_…`, `CHEER_steps_add_crossing_35_percent_…` (steps 1,800 → 2,800 / 8,000) ไม่ผ่าน; กรณีควบคุม 4→5 แก้ว (อารมณ์ไม่เปลี่ยน) ดีใจปกติ

สาเหตุ (จากการอ่านโค้ด): water_home_screen.dart:181 และ steps_dashboard_screen.dart:214 ใส่ key `water_pet_image_${mood.name}` / `steps_pet_image_${status.name}` ไว้ที่ `PetCharacter` เอง เมื่อสถานะเปลี่ยน key เปลี่ยน → Flutter ทิ้ง State เดิมและสร้าง State ใหม่ ซึ่ง `initState` เห็น `cheerTrigger` เป็นค่าใหม่แล้ว (cheer ถูกเล่นเฉพาะใน `didUpdateWidget`) จึงไม่เห็น "การเปลี่ยนค่า" — ผลข้างเคียง: จังหวะหายใจ/กะพริบเริ่มใหม่ด้วย จุดที่หายคือจังหวะสำคัญที่สุด (ข้ามเกณฑ์)
การแก้ (Dev 20261014-1207): หน้าจอเก็บ `GlobalKey` ไว้ที่ PetCharacter และย้าย key ฟีเจอร์ `water_pet_image_<mood>` / `steps_pet_image_<status>` ไปไว้ที่ `KeyedSubtree` ที่ห่อ → State ถูกย้ายตาม ไม่สร้างใหม่
ยืนยัน (รอบ 2): 3 เทสต์ CHEER ข้างบนผ่าน + เพิ่ม `STATE_*` 2 เทสต์ (State เดิม, breath > 0 ต่อเนื่อง) ผ่าน · ตำแหน่ง key ใหม่ยอมรับได้ตาม character.md: §7 ระบุ key ฟีเจอร์ว่า "ไม่บังคับ" และการหา painter ด้วย `find.descendant(of: find.byKey(<key ฟีเจอร์>), …)` ตาม §7 ยังใช้ได้ แต่ตาราง Key ใน §7 ("key ที่ฟีเจอร์ส่งเข้า PetCharacter(key: ...) = ตัว widget เอง") ไม่ตรงกับโค้ดแล้ว → คำถาม 1
locator เทสต์ที่ปรับ: `tester.widget<PetCharacter>(find.byKey(featureKey))` → `find.descendant(of: find.byKey(featureKey), matching: find.byType(PetCharacter))` ใน water_decisions_screens_test (`expectPetMood`), water_pet_character_test (`expectMood`), pet_screens_cheer_test (`POSE_steps_*`)
หมายเหตุ: ตัวอย่างใน character.md §7 เองแนะนำ key แบบนี้ (ดูคำถาม 1) — ทางแก้ให้ Dev/Art ตัดสิน เช่น ให้ PetCharacter มี key คงที่ (เช่น GlobalKey เก็บใน State ของหน้าจอ) และย้าย key ฟีเจอร์ไปไว้ที่ widget ห่อ

## 4. คำถามถึงเอกสาร

1. character.md §7 (ตัวอย่างโค้ด + ตาราง Key) และ doc comment ใน pet_character.dart ยังให้ใส่ key ฟีเจอร์ที่ PetCharacter ซึ่งขัดกับ §6 เมื่อสถานะเปลี่ยนพร้อมกัน (ต้นเหตุ BUG-PET-1) — โค้ดหน้าจอแก้แล้ว (GlobalKey + KeyedSubtree) แต่ Art ยังต้องปรับเอกสารให้ตรง
2. docs/water/game-rules.md §2 และ docs/steps/game-rules.md §2 ยังระบุไฟล์ pet_*.png — ควรอัปเดตตามข้อตัดสิน owner 2026-10-14 (ตอนนี้เทสต์ยึดข้อตัดสินแทนคอลัมน์ "ไฟล์ภาพ")
3. character.md §6 "1800 + random(0..3200) ms" ไม่ระบุว่ารวม 3200 หรือไม่ — เทสต์ตรวจแค่อยู่ในช่วง [1800, 5000+180]
4. (decided by owner 2026-10-14: ยังไม่ต้องทำปฏิกิริยาอื่น — แค่ไม่ดีใจ) เมื่อบันทึกถูกบล็อก (anti-spam / ล็อกเซนเซอร์) สัตว์เลี้ยงควรมีปฏิกิริยาอื่นไหม (เช่นส่ายหัว) — เอกสารไม่กำหนด เทสต์ตรวจแค่ "ไม่ดีใจ"
5. (decided by owner 2026-10-14: ยอมรับแนวทางนี้) Dev ASSUMPTION 1 (ปิด animation อัตโนมัติด้วย env FLUTTER_TEST) — ทดสอบแล้วว่าทำงาน แต่ยังรอยืนยันว่ายอมรับแนวทางนี้
