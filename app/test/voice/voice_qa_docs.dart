// ค่าคาดหวังของ QA (ไม่ใช่ไฟล์เทสต์ — ไม่มี main) — พิมพ์ตรงตัวจากเอกสาร ไม่ import VoiceRules
// ที่มา: game-rules.md §1, §1.1, §1.2 · ux-flow.md §2 · ui-spec.md §2.4 / §2.5 / §7
// · ข้อตัดสิน owner V-1..V-10 (logs/20261112-1043_owner_voice.md)

/// game-rules §1.1 Exact String (ไม่รวม `"` ตัวคั่น — ui-spec §2)
const docStepsLazy =
    'แหม... นอนเก่งขนาดนี้ นึกว่าจำศีลอยู่ซะอีก ลุกขึ้นมาขยับขาหน่อยเร้ว เดี๋ยวร่างจะติดโซฟาเอานะยูว์';
const docStepsEncouraging =
    'ฮั่นแน่! อีกนิดเดียวก็จะครบเป้าหมายแล้วนะเนี่ย ขาเริ่มสั่นยังคะคนดี ฮึบอีกนิด เดี๋ยวมีรางวัลให้!';
const docStepsSuccess =
    'โอโห้! วันนี้เดินเยอะจนนับขาแทบไม่ทัน เก่งมากค่ะคนดี ขาไม่พังใช่ไหมเนี่ย วันนี้พักผ่อนตามสบายเลยนะ!';
const docFoodOvereating =
    'พุงจะแตกตายอยู่แล้วนะแม่คุณ! พอเถอะน้าคนดี เดี๋ยวพรุ่งนี้ค่อยลุยใหม่ (แต่ตอนนี้อิ่มแปล้เลยสิเนี่ย)';
const docWaterLow =
    'คอแห้งเป็นผงละเนี่ย ดื่มน้ำหน่อยเร้ว เดี๋ยวหน้าเหี่ยวไม่รู้ด้วยนะ พี่อ๊บเป็นห่วงนะเนี่ย';
const docWaterSuccess =
    'ดื่มน้ำเก่งมาก! ผิวพรรณเปล่งปลั่งออร่าจับเลยแบบนี้ เอาใจไปเลยสิคะคนดี!';

/// V-6: ชื่อไฟล์ใน game-rules §1.1 ไม่มี `.mp3` = id ของบทพูด
const idStepsLazy = 'voice_steps_lazy';
const idStepsEncouraging = 'voice_steps_encouraging';
const idStepsSuccess = 'voice_steps_success';
const idFoodOvereating = 'voice_food_overeating';
const idWaterLow = 'voice_water_low';
const idWaterSuccess = 'voice_water_success';

/// ui-spec §2.4.3 ช่วงไม่มีบทพูด
const docNoneBand = 'NONE';

/// game-rules §1 TOGGLE_DEBOUNCE_MS
const docDebounce = Duration(milliseconds: 300);

/// ui-spec VT-1: เป้าก้าว 10,000 เว้นแต่ระบุ → 1 ก้าว = 0.01%
const docGoal = 10000;

/// ui-spec §2.5 / game-rules §1.2 storage keys
const keyPermission = 'voice_permission_status';
const keyMaster = 'master_voice_toggle';
const keyDayBands = 'voice_day_bands';

/// V-6: ภาษา / pitch / volume (= game-rules DEFAULT_AUDIO_VOLUME_GAIN)
const docTtsLanguage = 'th-TH';
const docTtsPitch = 1.5;
const docTtsVolume = 0.80;

/// V-7: เวอร์ชันเริ่มต้นของ flutter_tts (Dev log: build ผ่านที่ 4.2.5 ไม่ต้องถอย)
const docFlutterTtsVersion = '4.2.5';

// ---- ux-flow §2 S-1 / S-3 (ตรงตัว) ----
const docDialogTitle =
    'ให้น้องอ๊บส่งเสียงทักทายและคอยเป็นกำลังใจให้คุณทุกวันไหมคะ?';
const docDialogBody =
    'น้องอ๊บพร้อมส่งเสียงเชยชม แซว หรือเตือนคุณตามบริบทสุขภาพ เพื่อเพิ่มความสนุกในการใช้งานแอป PetPal Health';
const docEnableLabel = 'เปิดเสียงโลด! (แนะนำ)'; // Q-04: ตัด `[ ]`
const docDisableLabel = 'ปิดเสียงไว้ก่อน';
const docMasterVoiceLabel = 'เปิด/ปิดเสียงพากย์น้องอ๊บ (Master Voice)';

/// V-3 / Q-03: สวิตช์แจ้งเตือนเดิม ป้ายเดิม
const docNotificationSwitchLabel = 'เปิด/ปิดแจ้งเตือนทั้งหมด';

/// V-2 / Q-02: AppBar title เดิมของหน้าตั้งค่าแจ้งเตือน
const docSettingsTitle = 'การแจ้งเตือนของน้องอ๊บ';

/// ui-spec Q-15 (เสนอ) — ข้อความ SnackBar
const docSaveErrorText = 'ไม่สามารถบันทึกการตั้งค่าเสียงได้ กรุณาลองใหม่อีกครั้ง';
