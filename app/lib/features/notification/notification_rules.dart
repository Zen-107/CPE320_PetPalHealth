/// ค่าคงที่กติกา + ข้อความ + token หน้าจอทั้งหมดของฟีเจอร์แจ้งเตือน (notification-feature)
///
/// ตัวเลขกติกามาจาก docs/notification-feature/game-rules.md §1 (ชื่อแบบ lowerCamel ตาม
/// ui-spec §2.4.2) · ข้อความมาจาก ux-flow.md §2 / game-rules.md §1.1 (ตรงตัว ไม่รวม `"`
/// ตัวคั่น — ui-spec §2) · token หน้าจอมาจาก ui-spec §1.3 · ข้อความ "(เสนอ)" มาจาก ui-spec §7
///
/// ข้อตัดสิน owner ที่มีผลที่ไฟล์นี้: DECIDED (owner 2026-11-08, D-1..D-6) — ui-spec §0
library;

import '../dashboard/dashboard_rules.dart';
import '../water/water_rules.dart';

class NotificationRules {
  NotificationRules._();

  // ---------------------------------------------------------------------------
  // game-rules.md §1 ค่าหลัก
  // ---------------------------------------------------------------------------

  /// DAILY_RESET_TIME 05:00:00 (AC-35, EC-8, EC-14)
  // DECIDED (owner 2026-11-08 / ui-spec D-8): ตัดรอบ 05:00 เวลาเครื่อง อ้างค่าเดียวกับ water
  // (ไม่ตั้งเลขซ้ำ) — logic ใช้ WaterLogic.logicalDay
  static const int dailyResetHour = WaterRules.dailyResetHour;
  static const int dailyResetMinute = WaterRules.dailyResetMinute;

  /// QUIET_HOURS_START_TIME 23:00:00 (รวมขอบ — 23:00:00 ไม่ส่ง) (AC-26, AC-33, EC-7)
  static const int quietHoursStartHour = 23;
  static const int quietHoursStartMinute = 0;
  static const int quietHoursStartSecond = 0;

  /// QUIET_HOURS_END_TIME 05:59:59 (รวมขอบ — 05:59:59 ไม่ส่ง) (AC-26, EC-7)
  static const int quietHoursEndHour = 5;
  static const int quietHoursEndMinute = 59;
  static const int quietHoursEndSecond = 59;

  /// ACTIVE_HOURS_START_TIME 06:00:00 (รวมขอบ — 06:00:00 ส่งได้) และจุดเริ่มตัวนับ (AC-26, AC-27)
  static const int activeHoursStartHour = 6;
  static const int activeHoursStartMinute = 0;
  static const int activeHoursStartSecond = 0;

  /// DAILY_NOTIFICATION_CAP — เพดานต่อรอบวัน (AC-28, EC-15)
  static const int dailyNotificationCap = 6;

  /// MIN_NOTIFICATION_INTERVAL_MINUTES — ระยะห่างขั้นต่ำ (รวมขอบ 30:00 ส่งได้) (AC-29, AC-30)
  static const int minNotificationIntervalMinutes = 30;

  /// WALK_INACTIVITY_HOURS — "เดิน: ไม่ขยับ" (AC-9)
  static const int walkInactivityHours = 4;

  /// WALK_MAX_DELAY_MINUTES (AC-9)
  // DECIDED (owner 2026-11-08, D-6) + ASSUMPTION: ui-spec Q-07 — เก็บไว้เป็นเอกสารเท่านั้น
  // logic ไม่ตัดทิ้งเพราะช้า (ตั้งเวลาแบบ inexact ทุกข้อความอาจช้ากว่ากำหนด → Out of scope)
  static const int walkMaxDelayMinutes = 60;

  /// WALK_NEAR_GOAL_MIN_PERCENT 80.00 (รวมขอบ) (AC-10, AC-11)
  static const int walkNearGoalMinPercent = 80;

  /// WALK_NEAR_GOAL_MAX_EXCLUSIVE_PERCENT 100.00 (ไม่รวมขอบ) (AC-12, AC-13, AC-14, EC-11)
  static const int walkNearGoalMaxExclusivePercent = 100;

  /// WATER_INACTIVITY_FIRST_HOURS — "น้ำ: 2 ชม." (AC-16, AC-17, AC-27)
  static const int waterInactivityFirstHours = 2;

  /// WATER_INACTIVITY_SECOND_HOURS — "น้ำ: 4 ชม." (AC-18)
  static const int waterInactivitySecondHours = 4;

  /// WATER_DAILY_GOAL_GLASSES — ครบเป้าน้ำ (รวมขอบ >= 8) (AC-19, EC-4)
  // ui-spec D-11: derive จากค่าคงที่ของ water ผ่าน dashboard (ไม่พิมพ์เลข 8)
  static int get waterDailyGoalGlasses => DashboardRules.waterTargetCups;

  /// FOOD_UNLOGGED_TIME_1/2/3 — 12:00:00, 15:00:00, 18:00:00 (AC-20, AC-21)
  static const List<int> foodUnloggedHours = [12, 15, 18];

  /// FOOD_NIGHT_REMINDER_TIME — 21:00:00 (AC-22..AC-25)
  static const int foodNightReminderHour = 21;

  // DECIDED (owner 2026-11-08, D-3): ไม่มี WALK_MANUAL_INACTIVITY_HOURS / ข้อความ
  // "เดิน: บันทึกเอง" / key last_manual_move_timestamp ในรอบนี้ (AC-15, EC-12 → Out of scope)

  // ---------------------------------------------------------------------------
  // ข้อความแจ้งเตือน S-3 (ux-flow §2 S-3 / game-rules §1.1 — ตรงตัว)
  // ---------------------------------------------------------------------------

  static const String walkInactiveText =
      'อย่าลืมขยับบ้างนะ อย่ามัวแต่นั่งอืด ลุกขึ้นมาเดินเร็ว!!';
  static const String walkNearGoalText =
      'มาขยับร่างกายกันอีกนิด ใกล้ถึงเป้าหมายแล้วสู้ๆ';
  static const String waterFirstText =
      'อย่าลืมดื่มน้ำน้าา ผิวกบของน้องขาดความชุ่มชื้น น้องอ๊บไม่ชอบ';
  static const String waterSecondText =
      'โปรดดื่มน้ำเถอะคนนี้ น้องอ๊บคอแห้งไม่ไหวแล้วววว ดื่มน้ำๆๆ';
  static const String foodUnloggedText =
      'กินข้าวยัง อย่าลืมพักกินข้าวบ้างนะค้าบ แล้วอย่าลืมมาให้อาหารน้องอ๊บด้วย';
  static const String foodNightText =
      'น้องอ๊บหิวแล้วน้า ถ้าทานแล้วมาบอกน้องอ๊บด้วยนะ';

  // ---------------------------------------------------------------------------
  // S-1 การ์ดขอความยินยอม (ux-flow §2 S-1 — ตรงตัว)
  // ---------------------------------------------------------------------------

  static const String consentTitle = 'น้องอ๊บอยากส่งเสียงหา!';
  static const String consentBody =
      'อนุญาตให้น้องอ๊บแจ้งเตือนเรื่องการเดิน การดื่มน้ำ และการกินอาหารนะค้าบ';
  static const String allowButtonText = 'อนุญาต';
  static const String denyButtonText = 'ไม่อนุญาต';

  /// semanticLabel ของรูปบนการ์ด (ไม่แสดงบนจอ)
  // ASSUMPTION: ui-spec §2.1 (เสนอ — จาก character.md §7)
  static const String petSemanticLabel = 'น้องอ๊บขยิบตา';

  /// ui-spec §1.3 — ขนาดสัตว์เลี้ยงบนการ์ด 120 × 120
  static const double consentPetSize = 120;

  // ---------------------------------------------------------------------------
  // S-2 หน้าตั้งค่า (ux-flow §2 S-2)
  // ---------------------------------------------------------------------------

  static const String settingsTitle = 'การแจ้งเตือนของน้องอ๊บ';

  // ASSUMPTION: ui-spec Q-03 (เสนอ — รอยืนยัน) ux-flow ไม่มีป้ายสวิตช์ ใช้ชื่อองค์ประกอบ
  static const String masterSwitchLabel = 'เปิด/ปิดแจ้งเตือนทั้งหมด';

  // ui-spec Q-02 ปิดแล้ว — Exact String ของ ux-flow §2 S-2 / §4
  static const String permissionDeniedText =
      'สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน';

  /// ui-spec §2.0 ไอคอนทางเข้า S-2 บน AppBar dashboard
  // DECIDED (owner 2026-11-08, D-2) · tooltip = settingsTitle (ASSUMPTION: ui-spec Q-04)
  static const double entryIconSize = 24;

  /// ui-spec §1.3 — ตรวจรอบวันใหม่ขณะเปิดแอปค้าง (เท่า _resetCheckInterval ของ water)
  static const Duration dayCheckInterval = Duration(minutes: 1);

  // ---------------------------------------------------------------------------
  // S-3 รูปแบบแจ้งเตือนบน OS (ui-spec §2.3)
  // ---------------------------------------------------------------------------

  /// ชื่อผู้ส่ง (AC-36) — title บน Android
  static const String senderName = 'น้องอ๊บ';
  static const String senderKey = 'nong_ob';

  // ASSUMPTION: ui-spec Q-09 (เสนอ) — channel ไม่มีในเอกสาร
  static const String androidChannelId = 'petpal_reminders';
  static const String androidChannelName = 'แจ้งเตือนจากน้องอ๊บ';
  static const String androidChannelDescription =
      'เตือนเรื่องการเดิน การดื่มน้ำ และการกินอาหาร';

  // ASSUMPTION: ui-spec Q-10 — ไอคอนเล็กชั่วคราว (ไอคอน monochrome เป็นงานของ Art ภายหลัง)
  static const String androidSmallIcon = '@mipmap/ic_launcher';

  /// Person icon Android 192 × 192 px ครอปวงกลม พื้นโปร่งใส
  // DECIDED (owner 2026-11-08, D-1) + ASSUMPTION: ui-spec Q-11 (คงพื้นโปร่งใส)
  static const int avatarSizePx = 192;

  /// เวลาที่ตั้งห่างจากตอนนี้ไม่เกินค่านี้ → แสดงทันทีด้วย show() แทน zonedSchedule (ui-spec §2.4)
  static const Duration showImmediatelyWithin = Duration(seconds: 5);

  /// ตัวคั่น payload `'<topic>|<message>'` (ui-spec §2.3.3)
  static const String payloadSeparator = '|';
}
