/// ค่าคงที่กติกา + ข้อความ + token หน้าจอทั้งหมดของฟีเจอร์เสียงพากย์น้องอ๊บ (voice)
///
/// ตัวเลขกติกามาจาก docs/voice/game-rules.md §1 (ชื่อแบบ lowerCamel ตาม ui-spec §2.4.2)
/// · ข้อความมาจาก ux-flow.md §2 / game-rules.md §1.1 (ตรงตัว ไม่รวม `"` ตัวคั่น และ `[ ]`
/// ของปุ่ม — ui-spec §2, Q-04) · token หน้าจอมาจาก ui-spec §1.3 · ข้อความ "(เสนอ)" มาจาก ui-spec §7
///
/// ข้อตัดสิน owner ที่มีผลที่ไฟล์นี้: DECIDED (owner 2026-11-12, V-1..V-10) — ui-spec §0,
/// logs/20261112-1043_owner_voice.md
library;

import '../dashboard/dashboard_rules.dart';
import '../food/food_rules.dart';
import '../notification/notification_rules.dart';
import '../steps/steps_rules.dart';

class VoiceRules {
  VoiceRules._();

  // ---------------------------------------------------------------------------
  // game-rules.md §1 ค่าหลัก (เกณฑ์)
  // ---------------------------------------------------------------------------

  /// STEPS_LAZY_THRESHOLD `< 35.00` % (ไม่รวมขอบ) — AC-2
  static const int stepsLazyBelowPercent = 35;

  /// STEPS_ENCOURAGING_MIN `70.00` % (รวมขอบ) — AC-3
  static const int stepsEncouragingMinPercent = 70;

  /// STEPS_ENCOURAGING_MAX `99.99` % — เอกสารเท่านั้น logic ใช้ `< stepsSuccessMinPercent`
  /// (ครอบคลุม 99.99x %) — AC-3, ui-spec §2.4.2
  // ASSUMPTION: voice ui-spec Q-30 — 99.00% และ 99.99% = stepsEncouraging (เทียบ < 100%)
  static const double stepsEncouragingMaxPercent = 99.99;

  /// STEPS_SUCCESS_THRESHOLD `>= 100.00` % (รวมขอบ) — AC-4
  static const int stepsSuccessMinPercent = 100;

  /// FOOD_OVEREATING_THRESHOLD `> 100.00` kcal (ไม่รวมขอบ) — AC-5
  /// อ้างค่าเดียวกับหลอดแดง / alert P1 (ไม่พิมพ์ซ้ำ) · logic ใช้ `DashboardInput.isFoodOverLimit`
  // ASSUMPTION: voice ui-spec Q-19 — เทียบ `total > target + 100` (= FoodController.isOverLimit)
  // · ไม่มีเป้า = ไม่มีบทอาหาร
  static const int foodOvereatingThresholdKcal = FoodRules.overLimitThreshold;

  /// WATER_LOW_THRESHOLD `< 3` แก้ว (ไม่รวมขอบ) — AC-6
  static const int waterLowBelowCups = 3;

  /// WATER_SUCCESS_THRESHOLD `>= 8` แก้ว (รวมขอบ) — AC-7 · อ้างเป้าน้ำของ dashboard (8)
  /// แบบ notification D-11 (ไม่พิมพ์ซ้ำ)
  static int get waterSuccessMinCups => DashboardRules.waterTargetCups;

  /// TOGGLE_DEBOUNCE_MS 300 — EC-5
  static const Duration toggleDebounce = Duration(milliseconds: 300);

  /// DEFAULT_AUDIO_VOLUME_GAIN 0.80 — game-rules §5 Fallback Rule
  // DECIDED (owner 2026-11-12, V-6): ใช้เป็น volume ของ TTS
  static const double defaultAudioVolumeGain = 0.80;

  // ---------------------------------------------------------------------------
  // TTS (V-6, V-6a) — ไม่มีไฟล์ mp3 / AUDIO_FILE_PATH (V-6b)
  // ---------------------------------------------------------------------------

  // DECIDED (owner 2026-11-12, V-6): TTS ในเครื่องผ่าน flutter_tts ภาษาไทย
  static const String ttsLanguage = 'th-TH';

  // DECIDED (owner 2026-11-12, V-6): pitch สูงแบบตัวการ์ตูน
  static const double ttsPitch = 1.5;

  /// เวลาสูงสุดต่อ 1 บทพูด — บาง engine ไม่ส่ง completion (ui-spec §1.3)
  // ASSUMPTION: voice ui-spec Q-12 — 20 วินาที แล้ว stop() + บทถัดไป
  static const Duration speakTimeout = Duration(seconds: 20);

  /// รหัสช่วงที่ไม่มีบทพูด (ui-spec §2.4.3)
  static const String noLineBandCode = 'NONE';

  // ---------------------------------------------------------------------------
  // บทพูด (game-rules §1.1 Exact String — ไม่รวม `"`)
  // ---------------------------------------------------------------------------

  /// AC-2 voice_steps_lazy
  static const String stepsLazyText =
      'แหม... นอนเก่งขนาดนี้ นึกว่าจำศีลอยู่ซะอีก ลุกขึ้นมาขยับขาหน่อยเร้ว เดี๋ยวร่างจะติดโซฟาเอานะยูว์';

  /// AC-3 voice_steps_encouraging
  static const String stepsEncouragingText =
      'ฮั่นแน่! อีกนิดเดียวก็จะครบเป้าหมายแล้วนะเนี่ย ขาเริ่มสั่นยังคะคนดี ฮึบอีกนิด เดี๋ยวมีรางวัลให้!';

  /// AC-4 voice_steps_success
  static const String stepsSuccessText =
      'โอโห้! วันนี้เดินเยอะจนนับขาแทบไม่ทัน เก่งมากค่ะคนดี ขาไม่พังใช่ไหมเนี่ย วันนี้พักผ่อนตามสบายเลยนะ!';

  /// AC-5 voice_food_overeating
  static const String foodOvereatingText =
      'พุงจะแตกตายอยู่แล้วนะแม่คุณ! พอเถอะน้าคนดี เดี๋ยวพรุ่งนี้ค่อยลุยใหม่ (แต่ตอนนี้อิ่มแปล้เลยสิเนี่ย)';

  /// AC-6 voice_water_low
  static const String waterLowText =
      'คอแห้งเป็นผงละเนี่ย ดื่มน้ำหน่อยเร้ว เดี๋ยวหน้าเหี่ยวไม่รู้ด้วยนะ พี่อ๊บเป็นห่วงนะเนี่ย';

  /// AC-7 voice_water_success
  static const String waterSuccessText =
      'ดื่มน้ำเก่งมาก! ผิวพรรณเปล่งปลั่งออร่าจับเลยแบบนี้ เอาใจไปเลยสิคะคนดี!';

  // ---------------------------------------------------------------------------
  // S-1 First Launch Permission Dialog (ux-flow §2 S-1, ui-spec §2.1)
  // ---------------------------------------------------------------------------

  static const String dialogTitle =
      'ให้น้องอ๊บส่งเสียงทักทายและคอยเป็นกำลังใจให้คุณทุกวันไหมคะ?';

  static const String dialogBody =
      'น้องอ๊บพร้อมส่งเสียงเชยชม แซว หรือเตือนคุณตามบริบทสุขภาพ เพื่อเพิ่มความสนุกในการใช้งานแอป PetPal Health';

  // ASSUMPTION: voice ui-spec Q-04 — `[ ]` เป็นสัญลักษณ์ปุ่ม ไม่ใช่ส่วนของป้าย
  static const String enableButtonText = 'เปิดเสียงโลด! (แนะนำ)';
  static const String disableButtonText = 'ปิดเสียงไว้ก่อน';

  /// ui-spec §1.3 — 120 × 120 (อ้างค่าเดียวกับการ์ดแจ้งเตือน)
  static const double dialogPetSize = NotificationRules.consentPetSize;

  /// ui-spec §2.1 — 「ยิ้มร่าเริง」 (อ้างของเดิม ไม่แสดงบนจอ)
  // ASSUMPTION: voice ui-spec Q-05 — ท่า dashboardCheerful
  static const String dialogPetSemanticLabel = DashboardRules.moodCheerfulLabel;

  // ---------------------------------------------------------------------------
  // S-3 สวิตช์เสียง (ux-flow §2 S-3, ui-spec §2.3)
  // ---------------------------------------------------------------------------

  // DECIDED (owner 2026-11-12, V-2): สวิตช์บนสุดของหน้าตั้งค่าแจ้งเตือนเดิม
  static const String masterVoiceSwitchLabel =
      'เปิด/ปิดเสียงพากย์น้องอ๊บ (Master Voice)';

  /// ux-flow §4 S-3 ERROR "แจ้งเตือนให้ลองใหม่อีกครั้ง"
  // ASSUMPTION: voice ui-spec Q-15 — ข้อความเสนอ รอยืนยัน
  static const String saveErrorText =
      'ไม่สามารถบันทึกการตั้งค่าเสียงได้ กรุณาลองใหม่อีกครั้ง';

  /// SnackBar หายเองใน 2 วินาที (อ้าง StepsRules.toastSeconds)
  static const int saveErrorToastSeconds = StepsRules.toastSeconds;
}
