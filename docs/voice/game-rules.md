# กติกาเกม: Pet Voice & Audio Feature (voice)

> สถานะ: พร้อมรีวิว · ผู้เขียน: Design agent · ผู้ตรวจ: เพื่อน B · อ้างอิง: requirements.md, ux-flow.md

## 1. ค่าหลัก

| ชื่อค่า (ใช้ในโค้ด) | ชนิดข้อมูล | ความหมาย | ค่า | หน่วย | อ้างถึง |
|---|---|---|---|---|---|
| `VOICE_PERMISSION_STATUS` | Boolean | สถานะการตอบรับ Dialog ขอสิทธิ์เปิดเสียงครั้งแรก (`True` = เปิดเสียงโลด, `False` = ปิดเสียงไว้ก่อน, `NULL` = ยังไม่เคยตอบ) | `True / False` | - | US-1, AC-1 |
| `MASTER_VOICE_TOGGLE` | Boolean | สถานะสวิตช์เปิด/ปิดเสียงพากย์น้องอ๊บหลัก (`True` = เปิด, `False` = ปิด) | `True / False` | - | US-3, AC-8 |
| `PUSH_NOTIFICATION_SHORTCUT_TOGGLE` | Boolean | สถานะสวิตช์ลัดเปิด/ปิดระบบแจ้งเตือนหลักของแอป (`True` = เปิด, `False` = ปิด) | `True / False` | - | US-3, AC-8 |
| `AUDIO_FILE_PATH` | String | พาธโฟลเดอร์ Local Assets สำหรับเก็บไฟล์เสียง `.mp3` ทั้ง 6 บริบท | `assets/audio/voice/` | - | AC-2 ถึง AC-7, EC-4 |
| `STEPS_LAZY_THRESHOLD` | Float | เกณฑ์เปอร์เซ็นต์ก้าวเดินต่ำกว่ากำหนดที่เล่นเสียงโหมดขี้เกียจ (`< 35%`) | `< 35.00` | % | US-2, AC-2 |
| `STEPS_ENCOURAGING_MIN` | Float | ขอบล่างของช่วงก้าวเดินใกล้ถึงเป้าหมาย (`70% - 99%`) | `70.00` | % | US-2, AC-3 |
| `STEPS_ENCOURAGING_MAX` | Float | ขอบบนของช่วงก้าวเดินใกล้ถึงเป้าหมาย (`70% - 99%` หรือก่อนครบ `100.00%`) | `99.99` | % | US-2, AC-3 |
| `STEPS_SUCCESS_THRESHOLD` | Float | เกณฑ์เปอร์เซ็นต์ก้าวเดินเมื่อบรรลุหรือเกินเป้าหมาย (`≥ 100%`) | `>= 100.00` | % | US-2, AC-4 |
| `FOOD_OVEREATING_THRESHOLD` | Float | เกณฑ์แคลอรี่อาหารที่บันทึกเกินเป้าหมาย (`> 100 kcal`) | `> 100.00` | kcal | US-2, AC-5 |
| `WATER_LOW_THRESHOLD` | Integer | เกณฑ์จำนวนแก้วน้ำดื่มต่ำกว่ากำหนด (`< 3 แก้ว`) | `< 3` | แก้ว | US-2, AC-6 |
| `WATER_SUCCESS_THRESHOLD` | Integer | เกณฑ์จำนวนแก้วน้ำดื่มเมื่อบรรลุหรือเกินเป้าหมาย (`≥ 8 แก้ว`) | `>= 8` | แก้ว | US-2, AC-7 |
| `TOGGLE_DEBOUNCE_MS` | Integer | ระยะเวลาหน่วง Debounce เมื่อผู้ใช้กดสลับ Toggle Switch รัวๆ ในเวลาสั้นๆ | `300` | มิลลิวินาที | US-3, AC-8, EC-5 |
| `DEFAULT_AUDIO_VOLUME_GAIN` | Float | ค่าเริ่มต้นความดังมาตรฐานของ Audio Player สำหรับไฟล์ `.mp3` ทั้ง 6 ไฟล์ (Fallback Rule) | `0.80` | สัดส่วน (80%) | หัวข้อ 5 (Open Question) |

### 1.1 ตารางข้อความ เงื่อนไข และลำดับคิว

| ชื่อเรียก / ชื่อไฟล์ | หมวด/เรื่อง | ข้อความคำต่อคำ (Exact String) | เงื่อนไขส่ง/เล่น (Trigger) | เงื่อนไขหยุด/ยกเลิก/ข้าม (Cancel/Skip) |
|---|---|---|---|---|
| `voice_steps_lazy.mp3` | ก้าวเดิน (`steps` `< 35%`) | `"แหม... นอนเก่งขนาดนี้ นึกว่าจำศีลอยู่ซะอีก ลุกขึ้นมาขยับขาหน่อยเร้ว เดี๋ยวร่างจะติดโซฟาเอานะยูว์"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลก้าวเดิน (`steps`) `< 35%` (`< 35.00%`) (AC-2) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |
| `voice_steps_encouraging.mp3` | ก้าวเดิน (`steps` `70% - 99%`) | `"ฮั่นแน่! อีกนิดเดียวก็จะครบเป้าหมายแล้วนะเนี่ย ขาเริ่มสั่นยังคะคนดี ฮึบอีกนิด เดี๋ยวมีรางวัลให้!"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลก้าวเดิน (`steps`) อยู่ในช่วง `70% - 99%` (`70.00% - 99.99%`) (AC-3) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |
| `voice_steps_success.mp3` | ก้าวเดิน (`steps` `≥ 100%`) | `"โอโห้! วันนี้เดินเยอะจนนับขาแทบไม่ทัน เก่งมากค่ะคนดี ขาไม่พังใช่ไหมเนี่ย วันนี้พักผ่อนตามสบายเลยนะ!"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลก้าวเดิน (`steps`) `≥ 100%` (`>= 100.00%`) (AC-4) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |
| `voice_food_overeating.mp3` | อาหาร (`food` เกิน `> 100 kcal`) | `"พุงจะแตกตายอยู่แล้วนะแม่คุณ! พอเถอะน้าคนดี เดี๋ยวพรุ่งนี้ค่อยลุยใหม่ (แต่ตอนนี้อิ่มแปล้เลยสิเนี่ย)"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลอาหาร (`food`) เกิน `> 100 kcal` (`> 100.00 kcal`) (AC-5) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |
| `voice_water_low.mp3` | น้ำดื่ม (`water` `< 3 แก้ว`) | `"คอแห้งเป็นผงละเนี่ย ดื่มน้ำหน่อยเร้ว เดี๋ยวหน้าเหี่ยวไม่รู้ด้วยนะ พี่อ๊บเป็นห่วงนะเนี่ย"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลน้ำ (`water`) `< 3 แก้ว` (AC-6) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |
| `voice_water_success.mp3` | น้ำดื่ม (`water` `≥ 8 แก้ว`) | `"ดื่มน้ำเก่งมาก! ผิวพรรณเปล่งปลั่งออร่าจับเลยแบบนี้ เอาใจไปเลยสิคะคนดี!"` | `MASTER_VOICE_TOGGLE == True` และบันทึกข้อมูลน้ำ (`water`) `≥ 8 แก้ว` (AC-7) | ข้ามการเล่นเมื่อ `MASTER_VOICE_TOGGLE == False` หรือเมื่อไฟล์ `.mp3` สูญหาย/เสียหาย (EC-3) |

- **กฎลำดับคิวการเล่นเสียง (`Audio Queue` ตาม `EC-2`):** จัดคิวการเล่นเสียงแบบเข้าก่อนออกก่อน (`FIFO: First-In, First-Out`) เมื่อมีเหตุการณ์กระตุ้นเสียงพากย์หลายบริบทในเวลาไล่เลี่ยกัน ระบบจะเล่นทีละไฟล์ตามลำดับก่อนหลัง ห้ามเล่นทับซ้อนกัน (`No Audio Overlap`)
- **ระยะห่างระหว่างไฟล์ในคิว:** เล่นไฟล์ถัดไปในคิวต่อเนื่องทันทีที่ไฟล์ก่อนหน้าเล่นจบ (`Cooldown = 0 มิลลิวินาที` หลังจบไฟล์ก่อนหน้า)
- **เพดานต่อวัน:** ไม่จำกัดจำนวนครั้งต่อวัน (เล่นตามเหตุการณ์การบันทึกข้อมูลสุขภาพจริงของผู้ใช้เมื่อเปิด `Master Voice Toggle`)
- **การล้างคิวเมื่อปิดเสียง:** หากผู้ใช้สลับ `Master Voice Toggle` เป็น `False` (`OFF`) ขณะมีไฟล์เสียงรออยู่ใน `Audio Queue` ระบบจะหยุดเสียงปัจจุบันและล้างคิวที่ค้างอยู่ทันที

### 1.2 ตารางสถานะและข้อมูลที่เก็บในระบบ (System State & Storage Schema)

| ชื่อข้อมูล (ตาม Requirements หัวข้อ 6) | ชื่อตัวแปรในโค้ด | ชนิดข้อมูล | ค่าเริ่มต้น | ค่าที่เป็นไปได้และป้ายแสดงผล `CODE_ENUM (ป้ายไทย)` | เก็บที่ไหน | อ้างถึง |
|---|---|---|---|---|---|---|
| Voice Permission Status | `voice_permission_status` | Boolean (True/False) | `NULL / UNANSWERED` (ก่อนตอบ Dialog ครั้งแรก) | `TRUE / ON (เปิดเสียงโลด - อนุญาต)`, `FALSE / OFF (ปิดเสียงไว้ก่อน - ไม่อนุญาตเริ่มต้น)`, `NULL / UNANSWERED (ยังไม่เคยตอบ Dialog ครั้งแรก)` | Local Storage | US-1, AC-1 |
| Master Voice Toggle | `master_voice_toggle` | Boolean (True/False) | ซิงค์ตามปุ่มที่เลือกใน `S-1` (`True` เมื่อกดเปิดเสียงโลด / `False` เมื่อกดปิดเสียงไว้ก่อน) | `TRUE / ON (เปิดใช้งานเสียงพากย์)`, `FALSE / OFF (ปิดใช้งานเสียงพากย์)` | Local Storage | US-1, US-3, AC-1, AC-8, EC-5 |
| Push Notification Shortcut Toggle | `push_notification_shortcut_toggle` | Boolean (True/False) | ซิงค์ตามค่าปัจจุบันใน App Core Notification Setting | `TRUE / ON (เปิดใช้งานการแจ้งเตือน)`, `FALSE / OFF (ปิดใช้งานการแจ้งเตือน)` | App Core Notification Setting | US-3, AC-8, EC-5 |
| Audio File Path | `audio_file_path` | String (Local Path) | `assets/audio/voice/` | พาธไฟล์ `.mp3` ทั้ง 6 ไฟล์ใน `assets/audio/voice/` | Local Assets (`assets/audio/voice/`) | US-2, AC-2 ถึง AC-7, EC-3, EC-4 |

## 2. สถานะ/อารมณ์ของสัตว์เลี้ยง

| สถานะ | ช่วงค่า (ระบุรวม/ไม่รวมขอบ) | ไฟล์ภาพตัวละคร / ไฟล์เสียงที่ใช้ |
|---|---|---|
| `PERMISSION_DIALOG (ขอสิทธิ์เสียงครั้งแรก)` | `voice_permission_status == NULL / UNANSWERED` เมื่อเข้าหน้า Home ครั้งแรกหลัง Onboarding (AC-1) | ไฟล์ภาพ: `assets/images/pet_avatar_dialog.png` |
| `DASHBOARD_IDLE (ปกติ/ไม่มีเสียงพากย์)` | `master_voice_toggle == False` หรือข้อมูลอยู่ในช่วงปกติที่ไม่กระตุ้นเสียง (ก้าวเดิน `35.00% - 69.99%`, อาหารเกิน `<= 100.00 kcal`, น้ำ `3 - 7 แก้ว`) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png` (ไม่เล่นไฟล์เสียง) |
| `VOICE_STEPS_LAZY (ก้าวเดินโหมดขี้เกียจ)` | `master_voice_toggle == True` และก้าวเดิน (`steps`) `>= 0.00%` ถึง `< 35.00%` (ไม่รวมขอบ `35.00%`) (AC-2) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_steps_lazy.mp3` |
| `VOICE_STEPS_ENCOURAGING (ก้าวเดินโหมดเชียร์อัพ)` | `master_voice_toggle == True` และก้าวเดิน (`steps`) อยู่ในช่วง `70% - 99%` คือตั้งแต่ `70.00%` ถึง `99.99%` (รวมขอบ `70.00%` และ `99.99%` ก่อนครบ `100.00%`) (AC-3) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_steps_encouraging.mp3` |
| `VOICE_STEPS_SUCCESS (ก้าวเดินโหมดสำเร็จ)` | `master_voice_toggle == True` และก้าวเดิน (`steps`) `>= 100.00%` ขึ้นไป (รวมขอบ `100.00%` และรองรับค่าเกิน `100%`) (AC-4) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_steps_success.mp3` |
| `VOICE_FOOD_OVEREATING (อาหารเกินเป้าหมาย)` | `master_voice_toggle == True` และอาหาร (`food`) เกินเป้าหมาย `> 100.00 kcal` (ไม่รวมขอบ `100.00 kcal`) (AC-5) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_food_overeating.mp3` |
| `VOICE_WATER_LOW (น้ำดื่มน้อยกว่าเกณฑ์)` | `master_voice_toggle == True` และน้ำดื่ม (`water`) `>= 0` ถึง `< 3 แก้ว` คือ `0, 1, 2 แก้ว` (ไม่รวมขอบ `3 แก้ว`) (AC-6) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_water_low.mp3` |
| `VOICE_WATER_SUCCESS (น้ำดื่มบรรลุเป้าหมาย)` | `master_voice_toggle == True` และน้ำดื่ม (`water`) `>= 8 แก้ว` ขึ้นไป (รวมขอบ `8 แก้ว`) (AC-7) | ไฟล์ภาพ: `assets/images/pet_avatar_happy.png`<br>ไฟล์เสียง: `assets/audio/voice/voice_water_success.mp3` |

## 3. เหตุการณ์และผลลัพธ์

| เหตุการณ์ | ค่าก่อน | ค่าหลัง | หมายเหตุ |
|---|---|---|---|
| ผู้ใช้เข้าแอปครั้งแรกหลัง Onboarding และกดปุ่ม `[ เปิดเสียงโลด! (แนะนำ) ]` บน S-1 | `voice_permission_status = NULL`, `master_voice_toggle = NULL` | `voice_permission_status = True`, `master_voice_toggle = True` | ปิด S-1 และไม่แสดงซ้ำในครั้งถัดไป (AC-1) |
| ผู้ใช้เข้าแอปครั้งแรกหลัง Onboarding และกดปุ่ม `[ ปิดเสียงไว้ก่อน ]` บน S-1 | `voice_permission_status = NULL`, `master_voice_toggle = NULL` | `voice_permission_status = False`, `master_voice_toggle = False` | ปิด S-1 และไม่แสดงซ้ำในครั้งถัดไป (AC-1) |
| บันทึกก้าวเดินต่ำกว่าเกณฑ์ `< 35%` (ขณะเปิดเสียง) | `steps = 34.99%`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_steps_lazy.mp3` | เข้าเกณฑ์ `< 35%` พอดีขอบบน (AC-2) |
| บันทึกก้าวเดินแตะขอบ `35.00%` พอดี (ขณะเปิดเสียง) | `steps = 35.00%`, `master_voice_toggle = True` | ไม่เล่นเสียงพากย์ (`No Trigger`) | ไม่อยู่ในช่วง `< 35%` และยังไม่ถึง `70%` |
| บันทึกก้าวเดินที่ `69.99%` ก่อนถึงเกณฑ์เชียร์อัพ | `steps = 69.99%`, `master_voice_toggle = True` | ไม่เล่นเสียงพากย์ (`No Trigger`) | ต่ำกว่าขอบล่าง `70.00%` |
| บันทึกก้าวเดินแตะขอบล่างช่วง `70% - 99%` | `steps = 70.00%`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_steps_encouraging.mp3` | เข้าเกณฑ์รวมขอบล่าง `70.00%` (AC-3) |
| บันทึกก้าวเดินแตะขอบบนช่วง `70% - 99%` | `steps = 99.00%` (หรือ `99.99%`), `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_steps_encouraging.mp3` | เข้าเกณฑ์ช่วง `70% - 99%` ก่อนครบ 100% (AC-3) |
| บันทึกก้าวเดินครบเป้าหมาย `100.00%` พอดี | `steps = 100.00%`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_steps_success.mp3` | เข้าเกณฑ์ `≥ 100%` พอดีขอบล่าง (AC-4) |
| บันทึกก้าวเดินเกินเป้าหมาย (Overachievement) | `steps = 125.00%`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_steps_success.mp3` | รองรับค่าสะสมเกิน 100% (AC-4) |
| บันทึกอาหารเกินเป้าหมาย `100.00 kcal` พอดี | `food_excess = 100.00 kcal`, `master_voice_toggle = True` | ไม่เล่นเสียงพากย์ (`No Trigger`) | ไม่เข้าเกณฑ์ เนื่องจากต้องมากกว่า `> 100 kcal` (AC-5) |
| บันทึกอาหารเกินเป้าหมายมากกว่า `100 kcal` | `food_excess = 100.01 kcal` (หรือ `150 kcal`), `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_food_overeating.mp3` | เข้าเกณฑ์ `> 100 kcal` (AC-5) |
| บันทึกน้ำดื่ม `< 3 แก้ว` | `water = 2 แก้ว`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_water_low.mp3` | เข้าเกณฑ์ `< 3 แก้ว` (AC-6) |
| บันทึกน้ำดื่มแตะขอบ `3 แก้ว` ถึง `7 แก้ว` | `water = 3 แก้ว` (หรือ `7 แก้ว`), `master_voice_toggle = True` | ไม่เล่นเสียงพากย์ (`No Trigger`) | ไม่อยู่ในช่วง `< 3 แก้ว` และยังไม่ถึง `8 แก้ว` |
| บันทึกน้ำดื่มครบ `8 แก้ว` พอดี | `water = 8 แก้ว`, `master_voice_toggle = True` | เล่นไฟล์เสียง `voice_water_success.mp3` | เข้าเกณฑ์ `≥ 8 แก้ว` พอดีขอบล่าง (AC-7) |
| บันทึกน้ำ `8 แก้ว` และก้าวเดิน `100%` เสร็จในเวลาไล่เลี่ยกัน | `Audio Queue` ว่าง, มี 2 เหตุการณ์เกิดพร้อมกัน | คิวที่ 1 เล่น `voice_water_success.mp3` จนจบ แล้วเล่นคิวที่ 2 `voice_steps_success.mp3` ต่อทันที | จัดคิวแบบ FIFO ไม่เล่นทับซ้อนกัน (EC-2) |
| ผู้ใช้กดสลับสวิตช์ `Master Voice` และ `Push Notification Shortcut` ใน S-3 | `master_voice_toggle = True`, `push_notification_shortcut_toggle = True` | บันทึกค่าใหม่เป็น `False` หลังผ่าน Debounce `300 ms` | บันทึกค่าทันทีเมื่อพ้นระยะ Debounce (AC-8, EC-5) |

## 4. พฤติกรรมที่ขอบเขต

| กรณี | ผลลัพธ์ที่ทดสอบได้ |
|---|---|
| ผู้ใช้เปิดโหมดปิดเสียง (Mute Mode / Silent) หรือลดเสียงสื่อเป็น 0 บนมือถือ (`EC-1`) | ระบบเล่นไฟล์เสียงในเบื้องหลังตามโค้ดปกติโดยไม่เกิดแอปพลิเคชันแครช (Crash) แม้ผู้ใช้ไม่ได้ยินเสียง |
| มีเหตุการณ์กระตุ้นเสียงพากย์หลายบริบทพร้อมกัน (`Audio Queue` / Overlap) เช่น บันทึกน้ำและก้าวเดินเสร็จในเวลาไล่เลี่ยกัน (`EC-2`) | ระบบจัดคิวการเล่นเสียง (`Audio Queue` แบบ FIFO) เล่นทีละไฟล์ตามลำดับก่อนหลัง ต่อเนื่องกันทันทีเมื่อไฟล์ก่อนหน้าจบ (`Cooldown = 0 ms`) โดยไม่เล่นทับซ้อนกัน (No Audio Overlap) |
| ไฟล์เสียง `.mp3` ใน Local Assets เสียหายหรือไม่พบไฟล์ (Missing Asset) (`EC-3`) | ระบบดักจับข้อผิดพลาด (Exception Handling) ข้ามการเล่นเสียงนั้นไปเงียบๆ โดยไม่แครชและไม่กระทบการทำงานหลักของแอป |
| อุปกรณ์ของผู้ใช้อยู่ในสถานะออฟไลน์ (Offline Local Storage) (`EC-4`) | ระบบโหลดและเล่นไฟล์เสียง `.mp3` จาก Local Assets (`assets/audio/voice/`) ได้ปกติ 100% โดยไม่ต้องเชื่อมต่ออินเทอร์เน็ต |
| ผู้ใช้กดคลิกเปิด/ปิด Toggle Switch รัวๆ ในเวลาสั้นๆ (Toggle Debounce) (`EC-5`) | ระบบมีกลไก Debounce (หน่วงเวลา `300 มิลลิวินาที`) เพื่อป้องกันการบันทึกค่าซ้ำซ้อนและป้องกันการส่งคำขอชนกัน |

## 5. คำถามถึง Product

1. **คำถามเปิดจาก Requirements หัวข้อ 7:** ทีมดีไซน์และเสียงต้องการยืนยันระดับความดังมาตรฐาน (Audio Volume Gain) ของไฟล์ `.mp3` ทั้ง 6 ไฟล์ ให้มีความดังเท่ากันหรือไม่ก่อนส่งมอบให้ Developer?
   - **ข้อเสนอแนะจาก Design:** ทีมดีไซน์และเสียงควรปรับมาตรฐานความดัง (Loudness Normalization) ของไฟล์ `.mp3` ทั้ง 6 ไฟล์ใน `assets/audio/voice/` ให้เท่ากันที่ระดับ `-14 LUFS` (และ True Peak ไม่เกิน `-1.0 dBTP`) เพื่อป้องกันปัญหาเสียงดังหรือเบาไม่เท่ากันเมื่อเล่นต่อเนื่องใน `Audio Queue`
   - **กติกาชั่วคราวเพื่อให้ Dev พัฒนาต่อได้ทันที (Fallback Rule):** ให้ Developer ตั้งค่าระดับความดังเริ่มต้นของ Audio Player ในโค้ดที่ `DEFAULT_AUDIO_VOLUME_GAIN = 0.80` (`80%` ของระดับเสียงสื่อมาตรฐาน) เท่ากันทุกไฟล์ `.mp3` ทั้ง 6 ไฟล์ เพื่อให้พัฒนาโค้ดและทดสอบได้ทันทีโดยไม่ต้องรอการปรับแต่งไฟล์เสียงใหม่
   - **การประเมินสถานะการบล็อก:** `Blocking: ไม่ใช่` (เนื่องจากมีค่าเริ่มต้น `DEFAULT_AUDIO_VOLUME_GAIN = 0.80` และชื่อไฟล์ `.mp3` มาตรฐานครบทั้ง 6 ไฟล์แล้ว จึงไม่บล็อกการเขียนโค้ดหรือการทดสอบตรรกะของ Developer)
