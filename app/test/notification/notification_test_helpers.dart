// ตัวช่วยร่วมของเทสต์ notification (ไม่ใช่ไฟล์เทสต์ — ไม่มี main)
// ค่าคาดหวังทั้งหมดมาจาก docs/notification-feature/requirements.md, game-rules.md, ux-flow.md,
// ui-spec.md และข้อตัดสิน owner (DECIDED 2026-11-08: D-1..D-6, Q-03..Q-27 ตาม ui-spec §7,
// Q-28 logout, EC-9, inexact) — ไม่ได้ลอกจากโค้ด
// ห้ามเรียก plugin จริง (ui-spec §2.4.6) → FakeNotificationScheduler · เวลา = clock ที่ส่งเข้าไป
import 'dart:async';
import 'dart:typed_data';

import 'package:petpal_health/features/food/food_models.dart';
import 'package:petpal_health/features/notification/notification_avatar.dart';
import 'package:petpal_health/features/notification/notification_controller.dart';
import 'package:petpal_health/features/notification/notification_logic.dart';
import 'package:petpal_health/features/notification/notification_models.dart';
import 'package:petpal_health/features/notification/notification_repository.dart';
import 'package:petpal_health/features/notification/notification_scheduler.dart';
import 'package:petpal_health/features/steps/steps_models.dart';
import 'package:petpal_health/features/water/water_models.dart';

import '../dashboard/dashboard_test_helpers.dart' show Sources, makeSources;

export '../dashboard/dashboard_test_helpers.dart' show Sources, makeSources;

// ---------------------------------------------------------------------------
// เวลา (พฤศจิกายน 2026 — ควบคุมได้ ไม่ใช้เวลาจริง)
// ---------------------------------------------------------------------------

/// วันที่ "วันนี้" ของเทสต์ส่วนใหญ่
const int today = 10;

DateTime t(int day, int h, [int m = 0, int s = 0]) =>
    DateTime(2026, 11, day, h, m, s);
DateTime d(int day) => DateTime(2026, 11, day);

// ---------------------------------------------------------------------------
// ค่าจากเอกสาร (game-rules §1)
// ---------------------------------------------------------------------------

const int docResetHour = 5; // DAILY_RESET_TIME 05:00:00
const int docQuietStartHour = 23; // QUIET_HOURS_START_TIME 23:00:00
const List<int> docQuietEnd = [5, 59, 59]; // QUIET_HOURS_END_TIME 05:59:59
const int docActiveHour = 6; // ACTIVE_HOURS_START_TIME 06:00:00
const int docCap = 6; // DAILY_NOTIFICATION_CAP
const int docIntervalMinutes = 30; // MIN_NOTIFICATION_INTERVAL_MINUTES
const int docWalkHours = 4; // WALK_INACTIVITY_HOURS
const int docWalkMaxDelayMinutes = 60; // WALK_MAX_DELAY_MINUTES
const int docNearGoalMin = 80; // WALK_NEAR_GOAL_MIN_PERCENT
const int docNearGoalMaxExclusive = 100; // WALK_NEAR_GOAL_MAX_EXCLUSIVE_PERCENT
const int docWaterFirstHours = 2; // WATER_INACTIVITY_FIRST_HOURS
const int docWaterSecondHours = 4; // WATER_INACTIVITY_SECOND_HOURS
const int docWaterGoal = 8; // WATER_DAILY_GOAL_GLASSES
const List<int> docFoodHours = [12, 15, 18]; // FOOD_UNLOGGED_TIME_1/2/3
const int docFoodNightHour = 21; // FOOD_NIGHT_REMINDER_TIME
const int docAvatarPx = 192; // ui-spec D-1
const double docConsentPetSize = 120; // ui-spec §1.3
const double docEntryIconSize = 24; // ui-spec §2.0

// ---------------------------------------------------------------------------
// ข้อความตรงตัว (ux-flow §2 / game-rules §1.1 — ไม่รวม `"` ตัวคั่น)
// ---------------------------------------------------------------------------

const walkInactiveDoc = 'อย่าลืมขยับบ้างนะ อย่ามัวแต่นั่งอืด ลุกขึ้นมาเดินเร็ว!!';
const walkNearGoalDoc = 'มาขยับร่างกายกันอีกนิด ใกล้ถึงเป้าหมายแล้วสู้ๆ';
const walkManualDoc = 'อย่าลืมขยับร่างกายน้า ถ้าขยับแล้วมาอัปเดตให้น้องอ๊บด้วย';
const waterFirstDoc = 'อย่าลืมดื่มน้ำน้าา ผิวกบของน้องขาดความชุ่มชื้น น้องอ๊บไม่ชอบ';
const waterSecondDoc = 'โปรดดื่มน้ำเถอะคนนี้ น้องอ๊บคอแห้งไม่ไหวแล้วววว ดื่มน้ำๆๆ';
const foodUnloggedDoc =
    'กินข้าวยัง อย่าลืมพักกินข้าวบ้างนะค้าบ แล้วอย่าลืมมาให้อาหารน้องอ๊บด้วย';
const foodNightDoc = 'น้องอ๊บหิวแล้วน้า ถ้าทานแล้วมาบอกน้องอ๊บด้วยนะ';

const consentTitleDoc = 'น้องอ๊บอยากส่งเสียงหา!';
const consentBodyDoc =
    'อนุญาตให้น้องอ๊บแจ้งเตือนเรื่องการเดิน การดื่มน้ำ และการกินอาหารนะค้าบ';
const allowDoc = 'อนุญาต';
const denyDoc = 'ไม่อนุญาต';
const settingsTitleDoc = 'การแจ้งเตือนของน้องอ๊บ';
const permissionDeniedDoc =
    'สิทธิ์แจ้งเตือนถูกปิดจากระบบ กรุณาไปที่การตั้งค่าเครื่องเพื่อเปิดใช้งาน';
const senderNameDoc = 'น้องอ๊บ';

/// ui-spec Q-03 (เสนอ) — DECIDED owner: ใช้ค่าที่ ui-spec เลือก
const masterSwitchLabelQ03 = 'เปิด/ปิดแจ้งเตือนทั้งหมด';

// ---------------------------------------------------------------------------
// ตัวช่วย logic
// ---------------------------------------------------------------------------

/// snapshot ของ 3 ฟีเจอร์ — ค่าเริ่มต้น = "เรื่องอื่นไม่มีผู้สมัคร" (ui-spec §2.4.4):
/// ตรวจก้าวไม่ได้, น้ำ 8 แก้ว, อาหาร 2,000 / เป้า 2,000
NotificationInputs inp({
  int water = 8,
  DateTime? waterAt,
  int steps = 0,
  int goal = 10000,
  bool locked = true,
  DateTime? stepsAt,
  int kcal = 2000,
  int? target = 2000,
  bool noTarget = false,
}) =>
    NotificationInputs(
      waterCount: water,
      waterLastLoggedAt: waterAt,
      steps: steps,
      stepsGoal: goal,
      isTrackingLocked: locked,
      lastStepsIncreasedAt: stepsAt,
      totalCalories: kcal,
      targetCalories: noTarget ? null : target,
    );

typedef Slot = (NotificationMessage, DateTime);

List<Slot> slotsOf(Iterable<PlannedNotification> items) =>
    [for (final i in items) (i.message, i.scheduledAt)];

List<Slot> allSlots(NotificationDayPlan p) => slotsOf(p.items);

List<Slot> pendingSlots(NotificationDayPlan p, DateTime now) =>
    slotsOf(NotificationLogic.pending(p, now));

List<Slot> slotsOfMessage(NotificationDayPlan p, NotificationMessage m) =>
    allSlots(p).where((s) => s.$1 == m).toList();

/// รายการที่ "ส่งแล้ว" (committed) ของเทสต์ — anchor = เวลานั้นถ้าไม่ระบุ
PlannedNotification sentItem(
  NotificationMessage m,
  DateTime at, {
  DateTime? anchor,
  DateTime? due,
}) {
  final a = anchor ?? at;
  return PlannedNotification(
    id: NotificationLogic.notificationId(NotificationLogic.logicalDay(at), m, a),
    message: m,
    anchor: a,
    dueAt: due ?? at,
    scheduledAt: at,
  );
}

NotificationDayPlan planOf(
  DateTime day,
  List<PlannedNotification> items, {
  Set<NotificationTopic> suppressed = const {},
}) =>
    NotificationDayPlan(day: day, items: items, suppressedTopics: suppressed);

// ---------------------------------------------------------------------------
// Fake scheduler (ui-spec §2.4.6) — บันทึก scheduled / cancelled / requestPermission
// ---------------------------------------------------------------------------

class FakeNotificationScheduler implements NotificationScheduler {
  FakeNotificationScheduler({
    this.checkResult = NotificationSystemPermission.notDetermined,
    this.requestResult = NotificationSystemPermission.granted,
    this.launch,
  });

  NotificationSystemPermission checkResult;
  NotificationSystemPermission requestResult;

  /// ถ้าไม่ null: requestPermission ค้างจนกว่าจะ complete (จำลองกล่องของ OS เปิดค้าง)
  Completer<NotificationSystemPermission>? requestGate;

  String? launch;
  void Function(String? payload)? onTap;

  /// เรียกตอน requestPermission ถูกเรียก (ให้ widget test ตรวจว่าการ์ดปิดก่อน)
  void Function()? onRequest;

  int initializeCount = 0;
  int requestCount = 0;
  int checkCount = 0;
  int cancelAllCount = 0;

  /// รายการที่ตั้งอยู่ใน "OS" ตอนนี้ (id → item)
  final Map<int, PlannedNotification> active = {};
  final List<PlannedNotification> scheduledLog = [];
  final List<int> cancelledLog = [];

  /// รายการที่ตั้งไว้และยังไม่ถึงเวลา ณ [now]
  List<PlannedNotification> pendingAt(DateTime now) =>
      active.values.where((i) => i.scheduledAt.isAfter(now)).toList()
        ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

  @override
  Future<void> initialize({required void Function(String? payload) onTap}) async {
    initializeCount++;
    this.onTap = onTap;
  }

  @override
  Future<String?> launchPayload() async => launch;

  @override
  Future<NotificationSystemPermission> checkPermission() async {
    checkCount++;
    return checkResult;
  }

  @override
  Future<NotificationSystemPermission> requestPermission() async {
    requestCount++;
    onRequest?.call();
    final gate = requestGate;
    if (gate != null) return gate.future;
    return requestResult;
  }

  @override
  Future<void> schedule(PlannedNotification item) async {
    scheduledLog.add(item);
    active[item.id] = item;
  }

  @override
  Future<void> cancel(int id) async {
    cancelledLog.add(id);
    active.remove(id);
  }

  @override
  Future<void> cancelAll() async {
    cancelAllCount++;
    active.clear();
  }
}

class FakeNotificationAvatarSource implements NotificationAvatarSource {
  int calls = 0;
  @override
  Future<Uint8List?> avatarPng() async {
    calls++;
    return Uint8List(0);
  }
}

/// Timer ตรวจรอบวัน (NotificationTimerFactory) — เรียก [tick] เองแทนเวลาจริง
class FakeDayTimers {
  final List<_FakePeriodic> _timers = [];
  Duration? lastInterval;

  Timer create(Duration interval, void Function() onTick) {
    lastInterval = interval;
    final timer = _FakePeriodic(onTick);
    _timers.add(timer);
    return timer;
  }

  int get activeCount => _timers.where((x) => x.isActive).length;

  void tick() {
    for (final x in [..._timers]) {
      if (x.isActive) x.fire();
    }
  }
}

class _FakePeriodic implements Timer {
  _FakePeriodic(this._onTick);
  final void Function() _onTick;
  bool _active = true;
  int _ticks = 0;

  void fire() {
    _ticks++;
    _onTick();
  }

  @override
  void cancel() => _active = false;
  @override
  bool get isActive => _active;
  @override
  int get tick => _ticks;
}

// ---------------------------------------------------------------------------
// repository ที่อ่าน/บันทึกไม่ได้ (ux-flow §4 S-1 ERROR) / โหลดค้าง (สถานะกำลังโหลด)
// ---------------------------------------------------------------------------

class BrokenLoadNotificationRepository implements NotificationRepository {
  int saves = 0;
  @override
  Future<NotificationState> load() async => throw const FormatException('corrupt');
  @override
  Future<void> save(NotificationState state) async => saves++;
}

class BrokenSaveNotificationRepository extends InMemoryNotificationRepository {
  BrokenSaveNotificationRepository([super.state]);
  @override
  Future<void> save(NotificationState state) async =>
      throw const FormatException('disk full');
}

class PendingNotificationRepository implements NotificationRepository {
  final Completer<NotificationState> c = Completer();
  @override
  Future<NotificationState> load() => c.future;
  @override
  Future<void> save(NotificationState state) async {}
}

// ---------------------------------------------------------------------------
// สถานะเริ่มต้นของ 3 ฟีเจอร์ในรอบวัน [day]
// ---------------------------------------------------------------------------

WaterState waterOn(int cups, DateTime? lastLoggedAt) =>
    WaterState(cups: cups, lastLoggedAt: lastLoggedAt, history: const []);

StepsState stepsOn(int day, int steps, {int goal = 8000}) =>
    StepsState.initial.copyWith(
        steps: steps, day: d(day), activeGoal: goal, lastSeenAt: t(day, 5, 1));

FoodState foodOn(int day, int kcal, {bool skipped = false}) => FoodState(
      day: d(day),
      totalCalories: kcal,
      meals: kcal == 0
          ? const []
          : [FoodMealEntry(date: d(day), loggedAt: t(day, 5, 2), calories: kcal)],
      lastSeenAt: t(day, 5, 1),
      profileSkipped: skipped,
    );

/// state ของ notification ที่ "ตอบการ์ดแล้ว อนุญาต + สิทธิ์ GRANTED + สวิตช์ ON"
const NotificationState grantedOn = NotificationState(
  consentStatus: NotificationConsentStatus.allowed,
  masterSwitch: true,
  systemPermission: NotificationSystemPermission.granted,
);

/// ชุดทดสอบ controller: 3 controller + notification ที่ใช้นาฬิกาเดียวกัน
class Harness {
  Harness({
    required this.sources,
    required this.scheduler,
    required this.repo,
    required this.timers,
    required this.controller,
  });

  final Sources sources;
  final FakeNotificationScheduler scheduler;
  final NotificationRepository repo;
  final FakeDayTimers timers;
  final NotificationController controller;

  InMemoryNotificationRepository get mem => repo as InMemoryNotificationRepository;
}

Harness makeHarness({
  required DateTime Function() clock,
  NotificationState state = NotificationState.initial,
  NotificationRepository? repo,
  WaterState? water,
  StepsState? steps,
  FoodState? food,
  bool noProfile = false,
  StepsTrackingStatus tracking = StepsTrackingStatus.available,
  FakeNotificationScheduler? scheduler,
}) {
  final sources = makeSources(
    clock: clock,
    water: water ?? waterOn(0, null),
    steps: steps,
    food: food,
    noProfile: noProfile,
  );
  sources.steps.trackingStatus = tracking;
  final s = scheduler ??
      FakeNotificationScheduler(checkResult: state.systemPermission);
  final r = repo ?? InMemoryNotificationRepository(state);
  final timers = FakeDayTimers();
  final c = NotificationController(
    repository: r,
    scheduler: s,
    avatar: FakeNotificationAvatarSource(),
    water: sources.water,
    steps: sources.steps,
    food: sources.food,
    clock: clock,
    timerFactory: timers.create,
  );
  return Harness(
      sources: sources, scheduler: s, repo: r, timers: timers, controller: c);
}
