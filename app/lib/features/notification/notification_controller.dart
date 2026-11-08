/// ตัวกลางระหว่าง logic / storage / scheduler กับ UI ของฟีเจอร์แจ้งเตือน (ui-spec §2.4)
///
/// อ่านค่าจาก WaterController / StepsController / FoodController ตัวเดียวกับหน้า water
/// (ui-spec D-9 — ไม่เก็บข้อมูลของฟีเจอร์อื่นซ้ำ) แล้ววางแผนของรอบวันด้วย
/// `NotificationLogic.buildPlan` และตั้ง/ยกเลิกใน [NotificationScheduler]
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../food/food_controller.dart';
import '../steps/steps_controller.dart';
import '../water/water_controller.dart';
import 'notification_avatar.dart';
import 'notification_logic.dart';
import 'notification_models.dart';
import 'notification_repository.dart';
import 'notification_rules.dart';
import 'notification_scheduler.dart';

typedef NotificationClock = DateTime Function();

/// สร้าง Timer แบบเป็นระยะ (ตรวจรอบวันใหม่) — เทสต์ inject ตัวปลอมเพื่อเรียก [onTick] เอง
typedef NotificationTimerFactory = Timer Function(
  Duration interval,
  void Function() onTick,
);

Timer _defaultPeriodic(Duration d, void Function() onTick) =>
    Timer.periodic(d, (_) => onTick());

class NotificationController extends ChangeNotifier {
  NotificationController({
    required this._repository,
    required this._scheduler,
    required this.water,
    required this.steps,
    required this.food,
    this._avatar,
    NotificationClock? clock,
    NotificationTimerFactory? timerFactory,
  })  : _clock = clock ?? DateTime.now,
        _timerFactory = timerFactory ?? _defaultPeriodic;

  final NotificationRepository _repository;
  final NotificationScheduler _scheduler;
  final NotificationAvatarSource? _avatar;
  final NotificationClock _clock;
  final NotificationTimerFactory _timerFactory;

  /// controller ตัวเดียวกับที่หน้า water ใช้ (D-9) — WaterHomeScreen ใช้ steps/food ตัวนี้ด้วย
  final WaterController water;
  final StepsController steps;
  final FoodController food;

  // สถานะที่เก็บ (game-rules §1.2)
  NotificationConsentStatus _consent = NotificationConsentStatus.unanswered;
  bool _master = false;
  NotificationSystemPermission _permission =
      NotificationSystemPermission.notDetermined;
  DateTime? _lastStepsIncreasedAt;
  NotificationDayPlan? _plan;

  // สถานะในหน่วยความจำ
  bool _isLoaded = false;
  Future<void>? _loadFuture;
  bool _disposed = false;
  bool _listening = false;
  Timer? _dayTimer;
  DateTime? _lastSyncDay;
  NotificationTopic? _pendingDeepLink;
  String? _lastSavedSignature;

  /// false หลังออกจากระบบ จนกว่าจะเข้า Home ใหม่ ([start])
  // DECIDED (owner 2026-11-08, Q-28)
  bool _active = true;
  bool _clearRequested = false;

  // ขอสิทธิ์ (AC-2, AC-6, EC-9) — ทำใน _sync ทีละครั้ง
  bool _wantPermissionRequest = false;
  bool _forcePermissionRequest = false;
  bool _awaitingPermission = false;
  bool _requestingPermission = false;

  // ติดตามก้าวใหม่ → last_steps_increased_timestamp (ui-spec §2.4.1)
  DateTime? _seenStepsDay;
  int _seenSteps = 0;

  // sync แบบทีละครั้ง + รวบคำสั่งที่ค้าง (EC-1 — ui-spec §2.2)
  Future<void>? _syncFuture;
  bool _dirty = false;

  // ---------------------------------------------------------------------------
  // ค่าสำหรับ UI / เทสต์
  // ---------------------------------------------------------------------------

  bool get isLoaded => _isLoaded;
  NotificationConsentStatus get consentStatus => _consent;

  /// `notification_master_switch` ที่ผู้ใช้เลือก (true = ON)
  bool get masterSwitch => _master;
  NotificationSystemPermission get systemPermission => _permission;

  /// ค่าที่สวิตช์บน S-2 แสดง: master ON และระบบอนุญาต (AC-5, AC-8, Q-23) — ระหว่างรอ
  /// กล่องขอสิทธิ์แสดงค่าที่ผู้ใช้เพิ่งกด (ui-spec §2.2)
  bool get isSwitchOn =>
      _master &&
      (_permission == NotificationSystemPermission.granted ||
          _awaitingPermission);

  /// กำลังรอผลกล่องขอสิทธิ์ของระบบ
  bool get isRequestingPermission => _requestingPermission;

  /// ปลายทางจากการกดแจ้งเตือนที่ยังไม่ได้นำทาง (ในหน่วยความจำเท่านั้น — Q-16)
  NotificationTopic? get pendingDeepLink => _pendingDeepLink;

  /// แผนของรอบวันล่าสุด (committed + pending)
  NotificationDayPlan? get plan => _plan;

  /// `last_steps_increased_timestamp`
  DateTime? get lastStepsIncreasedAt => _lastStepsIncreasedAt;

  /// ตั้งเวลาแจ้งเตือนได้หรือไม่ ณ ตอนนี้
  // ASSUMPTION: ui-spec §2.4.5 ข้อ 2 เขียนว่า consent ต้องเป็น ALLOWED แต่ EC-9 (กดไม่อนุญาต
  // แล้วเปิดสวิตช์ทีหลัง) ต้องทำงานได้ทั้งที่ consent ยังเป็น DENIED (เปลี่ยนครั้งเดียวบนการ์ด)
  // → ใช้ "ตอบการ์ดแล้ว" (ไม่ใช่ UNANSWERED) + master ON + GRANTED
  bool get canSchedule =>
      _active &&
      _consent != NotificationConsentStatus.unanswered &&
      _master &&
      _permission == NotificationSystemPermission.granted;

  bool get _sourcesLoaded => water.isLoaded && steps.isLoaded && food.isLoaded;

  // ---------------------------------------------------------------------------
  // โหลด / เริ่ม / หยุด
  // ---------------------------------------------------------------------------

  /// โหลดสถานะจากเครื่อง (เรียกซ้ำได้ — โหลดครั้งเดียว)
  Future<void> load() => _loadFuture ??= _load();

  Future<void> _load() async {
    try {
      final s = await _repository.load();
      _consent = s.consentStatus;
      _master = s.masterSwitch;
      _permission = s.systemPermission;
      _lastStepsIncreasedAt = s.lastStepsIncreasedTimestamp;
      _plan = s.dayPlan;
    } catch (_) {
      // ux-flow §4 S-1 ERROR / ui-spec §3: อ่านไม่ได้ → ไม่แสดงการ์ด ถือเป็นไม่อนุญาต
      // ชั่วคราว (ไม่ขอสิทธิ์ ไม่ตั้งเวลา) ผู้ใช้เปิดเองได้ใน S-2
      _consent = NotificationConsentStatus.denied;
      _master = false;
    }
    _isLoaded = true;
    _notify();
  }

  /// เรียกเมื่อเข้า Home (WaterHomeScreen): โหลดทุกอย่าง ฟัง 3 controller ตั้ง Timer
  /// ตรวจรอบวัน และวางแผนรอบวันปัจจุบัน (EC-14) — เรียกซ้ำได้
  Future<void> start() async {
    if (_disposed) return;
    // DECIDED (owner 2026-11-08, Q-28): เข้าระบบใหม่และเข้า Home แล้วจึงวางแผนใหม่
    _active = true;
    if (!_listening) {
      _listening = true;
      for (final c in _sources) {
        c.addListener(_onSourceChanged);
      }
    }
    _dayTimer ??=
        _timerFactory(NotificationRules.dayCheckInterval, _onDayTick);
    await load();
    // เรนเดอร์ avatar ล่วงหน้าขณะแอปเปิดอยู่ (ui-spec §2.3.2) — ไม่สำเร็จก็ไม่เป็นไร
    final avatar = _avatar;
    if (avatar != null) unawaited(avatar.avatarPng().catchError((_) => null));
    // แบบ DashboardController.start: โหลด controller ที่ยังไม่โหลด
    await Future.wait([
      if (!water.isLoaded) water.load(),
      if (!steps.isLoaded) steps.load(),
      if (!food.isLoaded) food.load(),
    ]);
    if (_disposed) return;
    _trackSteps();
    await _refreshPermission();
    await _sync();
  }

  /// เรียกเมื่อ Home ถูกปิด — ถอด listener และหยุด Timer (แผนที่ตั้งไว้ใน OS ยังอยู่)
  void stop() {
    _dayTimer?.cancel();
    _dayTimer = null;
    if (_listening) {
      _listening = false;
      for (final c in _sources) {
        c.removeListener(_onSourceChanged);
      }
    }
  }

  List<ChangeNotifier> get _sources => [water, steps, food];

  void _onSourceChanged() {
    if (_disposed) return;
    _trackSteps();
    _sync();
  }

  /// Timer: พบรอบวันใหม่ (05:00) ขณะเปิดแอปค้าง → วางแผนของวันใหม่ (EC-8, EC-14)
  void _onDayTick() {
    if (_disposed) return;
    final today = NotificationLogic.logicalDay(_clock());
    if (_lastSyncDay != today) {
      _trackSteps();
      _sync();
    }
  }

  /// steps เพิ่มจากค่าที่เห็นล่าสุดในรอบวันเดียวกัน → บันทึกเวลาก้าวใหม่
  void _trackSteps() {
    if (!steps.isLoaded) return;
    final now = _clock();
    final today = NotificationLogic.logicalDay(now);
    final d = steps.state.day;
    final current =
        d != null && DateTime(d.year, d.month, d.day) == today ? steps.steps : 0;
    if (_seenStepsDay == today && current > _seenSteps) {
      _lastStepsIncreasedAt = now;
    }
    _seenStepsDay = today;
    _seenSteps = current;
  }

  // ---------------------------------------------------------------------------
  // S-1 / S-2
  // ---------------------------------------------------------------------------

  /// S-1: กดอนุญาต / ไม่อนุญาต (AC-2, AC-3, AC-5) — เปลี่ยน consent ได้ครั้งเดียว
  Future<void> answerConsent({required bool allowed}) async {
    await load();
    if (_consent != NotificationConsentStatus.unanswered) return;
    _consent = allowed
        ? NotificationConsentStatus.allowed
        : NotificationConsentStatus.denied;
    _master = allowed;
    _awaitingPermission = allowed;
    _notify();
    try {
      await _save(force: true);
    } catch (_) {
      // ux-flow §4 S-1 ERROR: บันทึกไม่ได้ → ไม่อนุญาตชั่วคราว (ไม่ขอสิทธิ์ ไม่ตั้งเวลา)
      _consent = NotificationConsentStatus.denied;
      _master = false;
      _awaitingPermission = false;
      _notify();
      return;
    }
    if (allowed) {
      // AC-2: เรียกกล่องขอสิทธิ์ของระบบต่อทันที (แม้สิทธิ์จะเป็น GRANTED อยู่แล้ว)
      _wantPermissionRequest = true;
      _forcePermissionRequest = true;
    }
    // AC-3: ไม่อนุญาต → ไม่เรียก requestPermission
    await _sync();
  }

  /// S-2 สวิตช์เปิด/ปิดทั้งหมด (AC-6, AC-7, EC-1, EC-9) — สถานะสุดท้ายชนะ
  Future<void> setMasterSwitch(bool value) async {
    await load();
    _master = value;
    if (value && _permission != NotificationSystemPermission.granted) {
      // ON + NOT_DETERMINED (AC-6) / ON + DENIED (ASSUMPTION: ui-spec Q-05 ขออีกครั้ง)
      _wantPermissionRequest = true;
      _awaitingPermission = true;
    } else if (!value) {
      _wantPermissionRequest = false;
      _awaitingPermission = false;
    }
    _notify();
    await _trySave();
    await _sync();
  }

  /// กลับจาก background — อ่านสิทธิ์ใหม่ (ไม่แสดงกล่อง) แล้ววางแผนใหม่ (EC-10, Q-23)
  Future<void> onAppResumed() async {
    if (_disposed) return;
    await load();
    _trackSteps();
    await _refreshPermission();
    await _sync();
  }

  Future<void> _refreshPermission() async {
    final NotificationSystemPermission checked;
    try {
      checked = await _scheduler.checkPermission();
    } catch (_) {
      return;
    }
    // ASSUMPTION: ระบบตอบ "ปิด" ทั้งที่แอปยังไม่เคยขอ (Android 13+ / iOS ก่อนขอสิทธิ์)
    // → ยังเป็น NOT_DETERMINED (ไม่แสดง banner ก่อนผู้ใช้เคยถูกถาม — AC-6 ยังขอได้)
    if (checked == NotificationSystemPermission.notDetermined) return;
    if (checked == NotificationSystemPermission.denied &&
        _permission == NotificationSystemPermission.notDetermined) {
      return;
    }
    if (checked == _permission) return;
    _permission = checked;
    _notify();
    await _trySave();
  }

  // ---------------------------------------------------------------------------
  // Deep link (ui-spec §2.3.3 — AC-38..AC-40, EC-2, EC-13)
  // ---------------------------------------------------------------------------

  /// รับการกดแจ้งเตือน (ทุกสถานะแอป) — payload อ่านไม่ได้ → ไม่ทำอะไร
  void handleNotificationTap(String? payload) {
    final topic = NotificationLogic.decodePayload(payload);
    if (topic == null) return;
    _pendingDeepLink = topic;
    _notify();
  }

  /// คืนปลายทางที่ค้างแล้วล้างเป็น null (ใช้ได้ครั้งเดียว)
  NotificationTopic? takePendingDeepLink() {
    final t = _pendingDeepLink;
    _pendingDeepLink = null;
    return t;
  }

  // ---------------------------------------------------------------------------
  // ออกจากระบบ (DECIDED owner 2026-11-08, Q-28)
  // ---------------------------------------------------------------------------

  /// ยกเลิกแจ้งเตือนที่ตั้งไว้ทั้งหมด (cancelAll) + ล้างแผนของวัน โดยไม่เปลี่ยน consent /
  /// สวิตช์ / สิทธิ์ · ไม่วางแผนใหม่จนกว่าจะเข้า Home อีกครั้ง ([start])
  Future<void> onSignedOut() async {
    if (_disposed) return;
    _active = false;
    _clearRequested = true;
    await load();
    await _sync();
  }

  // ---------------------------------------------------------------------------
  // วางแผน / ตั้งเวลา (ui-spec §2.4.5)
  // ---------------------------------------------------------------------------

  Future<void> _sync() {
    final running = _syncFuture;
    if (running != null) {
      _dirty = true;
      return running;
    }
    final done = Completer<void>();
    _syncFuture = done.future;
    _runSync(done);
    return done.future;
  }

  Future<void> _runSync(Completer<void> done) async {
    do {
      _dirty = false;
      try {
        await _syncOnce();
      } catch (_) {
        // ASSUMPTION: ตั้งเวลา/บันทึกผิดพลาด → คงสถานะในหน่วยความจำ ลองใหม่รอบถัดไป
      }
    } while (_dirty && !_disposed);
    // ไม่มี await คั่นระหว่างตรวจ _dirty ครั้งสุดท้ายกับการปลด → ไม่มีคำสั่งหาย
    _syncFuture = null;
    done.complete();
  }

  Future<void> _syncOnce() async {
    if (!_isLoaded || _disposed) return;

    if (_clearRequested) {
      _clearRequested = false;
      try {
        await _scheduler.cancelAll();
      } catch (_) {
        // ไม่มี UI ผิดพลาด
      }
      // ล้างแผนของวัน (นับเพดาน/ระยะห่างใหม่เมื่อวางแผนครั้งถัดไป) — ไม่แตะ consent/สวิตช์/สิทธิ์
      _plan = null;
      await _trySave();
      _notify();
    }
    if (!_active) return;

    if (_wantPermissionRequest) {
      _wantPermissionRequest = false;
      final force = _forcePermissionRequest;
      _forcePermissionRequest = false;
      if (_master &&
          (force || _permission != NotificationSystemPermission.granted)) {
        _requestingPermission = true;
        _notify();
        NotificationSystemPermission result;
        try {
          result = await _scheduler.requestPermission();
        } catch (_) {
          result = NotificationSystemPermission.denied;
        }
        _requestingPermission = false;
        // NOT_DETERMINED = แพลตฟอร์มไม่รองรับ (Noop) → คงค่าเดิม
        if (result != NotificationSystemPermission.notDetermined) {
          _permission = result;
        }
      }
      // ผู้ใช้กด ON ซ้ำระหว่างรอ → ยังรอผลรอบถัดไป
      _awaitingPermission = _wantPermissionRequest;
      _notify();
      await _trySave();
    }

    final now = _clock();
    final today = NotificationLogic.planForToday(_plan, now);
    final NotificationDayPlan next;
    if (!canSchedule) {
      // AC-7 / AC-8: ปิดหรือไม่ได้รับสิทธิ์ → ยกเลิกรายการที่ยังไม่ถึงเวลาทั้งหมด
      next = NotificationLogic.committedOnly(
        _plan,
        now,
        inputs: _sourcesLoaded ? _inputs(now) : null,
      );
    } else if (!_sourcesLoaded) {
      return; // รอข้อมูลจาก 3 ฟีเจอร์ก่อน (listener เรียก sync อีกครั้งเมื่อโหลดเสร็จ)
    } else {
      next = NotificationLogic.buildPlan(_inputs(now), _plan, now);
    }

    final oldPending = NotificationLogic.pending(today, now);
    final committedIds = {
      for (final i in NotificationLogic.committed(today, now)) i.id,
    };
    final newPending = [
      for (final i in next.items)
        if (!committedIds.contains(i.id)) i,
    ];
    // ห้าม cancelAll / ห้าม cancel รายการ committed (ui-spec §2.4.5)
    for (final old in oldPending) {
      if (!newPending.any((n) => n.id == old.id)) {
        await _safe(() => _scheduler.cancel(old.id));
      }
    }
    for (final n in newPending) {
      // id เดิม + เวลาเดิม = ไม่ตั้งซ้ำ
      if (!oldPending.contains(n)) {
        await _safe(() => _scheduler.schedule(n));
      }
    }
    _plan = next;
    _lastSyncDay = today.day;
    await _trySave();
    _notify();
  }

  NotificationInputs _inputs(DateTime now) => NotificationLogic.inputsFor(
        now: now,
        waterCups: water.cups,
        waterLastLoggedAt: water.state.lastLoggedAt,
        steps: steps.steps,
        stepsDay: steps.state.day,
        stepsGoal: steps.activeGoal,
        isTrackingLocked: steps.isTrackingLocked,
        lastStepsIncreasedAt: _lastStepsIncreasedAt,
        totalCalories: food.totalCalories,
        foodDay: food.state.day,
        targetCalories: food.targetCalories,
      );

  static Future<void> _safe(Future<void> Function() call) async {
    try {
      await call();
    } catch (_) {
      // plugin ผิดพลาด → ข้ามรายการนั้น (ไม่มี UI ผิดพลาด)
    }
  }

  // ---------------------------------------------------------------------------
  // บันทึก (ui-spec §2.4.5 ข้อ 4, §2.5)
  // ---------------------------------------------------------------------------

  NotificationState _snapshot() {
    final now = _clock();
    final p = _plan == null ? null : NotificationLogic.planForToday(_plan, now);
    return NotificationState(
      consentStatus: _consent,
      masterSwitch: _master,
      systemPermission: _permission,
      sentNotificationCount: NotificationLogic.sentCount(p, now),
      lastNotificationTimestamp: NotificationLogic.lastSentAt(p, now),
      walkNearGoalSentToday: NotificationLogic.walkNearGoalSentToday(p, now),
      lastStepsIncreasedTimestamp: _lastStepsIncreasedAt,
      dayPlan: _plan,
    );
  }

  Future<void> _save({bool force = false}) async {
    final state = _snapshot();
    final signature = '$state|${_plan?.toJsonString()}';
    if (!force && signature == _lastSavedSignature) return;
    await _repository.save(state);
    _lastSavedSignature = signature;
  }

  /// ASSUMPTION: ui-spec Q-24 — บันทึกไม่สำเร็จ → คงค่าในหน่วยความจำ ไม่มี UI ผิดพลาด
  Future<void> _trySave() async {
    try {
      await _save();
    } catch (_) {
      _lastSavedSignature = null;
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    stop();
    super.dispose();
  }
}
