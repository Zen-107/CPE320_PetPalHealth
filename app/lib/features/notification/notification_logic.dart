/// logic เกมของฟีเจอร์แจ้งเตือน (pure Dart — ไม่ import Flutter widget / plugin /
/// shared_preferences) · ทุกฟังก์ชันรับ `now` เป็นพารามิเตอร์ (ui-spec §2.4)
///
/// แนวคิด (DECIDED owner 2026-11-08, D-5): คำนวณ "แผนของรอบวัน" ล่วงหน้าแล้วตั้งเวลาใน OS
/// ใหม่ทุกครั้งที่ข้อมูลเปลี่ยน — ไม่มีงานเบื้องหลัง (workmanager)
/// - committed = รายการในแผนที่ `scheduledAt <= now` (ถือว่าส่งแล้ว ห้ามแก้/ยกเลิก)
/// - pending   = รายการที่ `scheduledAt > now` (ยกเลิก/ตั้งใหม่ได้)
library;

import '../water/water_logic.dart';
import 'notification_models.dart';
import 'notification_rules.dart';

class NotificationLogic {
  NotificationLogic._();

  static const Duration _interval = Duration(
    minutes: NotificationRules.minNotificationIntervalMinutes,
  );

  // ---------------------------------------------------------------------------
  // รอบวัน / ช่วงเวลา (AC-26, AC-35, EC-7, EC-8)
  // ---------------------------------------------------------------------------

  /// รอบวัน 05:00 เวลาเครื่อง (ui-spec D-8) = `WaterLogic.logicalDay`
  static DateTime logicalDay(DateTime now) => WaterLogic.logicalDay(now);

  /// ACTIVE_HOURS_START_TIME (06:00:00) ของรอบวัน [day]
  static DateTime activeStart(DateTime day) => DateTime(
    day.year,
    day.month,
    day.day,
    NotificationRules.activeHoursStartHour,
    NotificationRules.activeHoursStartMinute,
    NotificationRules.activeHoursStartSecond,
  );

  /// QUIET_HOURS_START_TIME (23:00:00) ของรอบวัน [day]
  static DateTime quietStart(DateTime day) => DateTime(
    day.year,
    day.month,
    day.day,
    NotificationRules.quietHoursStartHour,
    NotificationRules.quietHoursStartMinute,
    NotificationRules.quietHoursStartSecond,
  );

  /// อยู่ในช่วงห้ามเตือน 23:00:00–05:59:59 (รวมขอบทั้งสองฝั่ง) ของรอบวัน [day] หรือไม่
  /// (`day` = รอบวันที่ [t] สังกัด — ถ้าไม่ส่งใช้ logicalDay(t))
  static bool isQuietTime(DateTime t, [DateTime? day]) {
    final d = day ?? logicalDay(t);
    return !t.isBefore(quietStart(d)) || t.isBefore(activeStart(d));
  }

  /// เวลาชั่วโมงตรงของรอบวัน [day] (เช่น 12:00:00 ของ FOOD_UNLOGGED_TIME_1)
  static DateTime _at(DateTime day, int hour) =>
      DateTime(day.year, day.month, day.day, hour);

  /// ค่าที่มาทีหลังระหว่าง [event] (ถ้าอยู่ในรอบวัน [day]) กับ 06:00:00 (game-rules §1.1
  /// "ตัวนับเวลาหลังช่วงห้ามเตือน", AC-27)
  static DateTime anchorFor(DateTime? event, DateTime day) {
    final active = activeStart(day);
    if (event == null || logicalDay(event) != day) return active;
    return event.isAfter(active) ? event : active;
  }

  // ---------------------------------------------------------------------------
  // ค่าที่อ่านจากฟีเจอร์อื่น (ui-spec §2.4.1)
  // ---------------------------------------------------------------------------

  /// แปลงค่าดิบของ 3 controller ให้เป็นค่าของรอบวันนี้ (ค่าของรอบวันก่อน → 0 / null)
  static NotificationInputs inputsFor({
    required DateTime now,
    required int waterCups,
    required DateTime? waterLastLoggedAt,
    required int steps,
    required DateTime? stepsDay,
    required int stepsGoal,
    required bool isTrackingLocked,
    required DateTime? lastStepsIncreasedAt,
    required int totalCalories,
    required DateTime? foodDay,
    required int? targetCalories,
  }) {
    final today = logicalDay(now);
    final waterToday =
        waterLastLoggedAt != null && logicalDay(waterLastLoggedAt) == today;
    bool sameDay(DateTime? d) =>
        d != null && DateTime(d.year, d.month, d.day) == today;
    return NotificationInputs(
      waterCount: waterToday ? waterCups : 0,
      waterLastLoggedAt: waterToday ? waterLastLoggedAt : null,
      steps: sameDay(stepsDay) ? steps : 0,
      stepsGoal: stepsGoal,
      isTrackingLocked: isTrackingLocked,
      lastStepsIncreasedAt:
          lastStepsIncreasedAt != null &&
              logicalDay(lastStepsIncreasedAt) == today
          ? lastStepsIncreasedAt
          : null,
      totalCalories: sameDay(foodDay) ? totalCalories : 0,
      targetCalories: targetCalories,
    );
  }

  /// EC-3 (DECIDED owner 2026-11-08, D-4): ค่าติดลบ หรือ `daily_goal == 0` → ระงับเรื่องนั้น
  /// ทั้งรอบวัน (เฉพาะ notification — ไม่เปลี่ยน A4 ของ 7day)
  static Set<NotificationTopic> invalidTopics(NotificationInputs i) => {
    // ASSUMPTION: daily_goal ติดลบถือเป็นค่าผิดเหมือน 0 (ทางที่ปลอดภัย — ไม่ส่ง)
    if (i.steps < 0 || i.stepsGoal <= 0) NotificationTopic.walk,
    if (i.waterCount < 0) NotificationTopic.water,
    if (i.totalCalories < 0) NotificationTopic.food,
  };

  /// 80% ≤ steps/goal < 100% เทียบแบบจำนวนเต็ม (ui-spec §2.4.2: 8,000/10,000 ส่ง ·
  /// 7,999 ไม่ส่ง · 9,999 ส่ง · 10,000 ไม่ส่ง) (AC-10..AC-14)
  static bool isNearGoal(int steps, int goal) {
    if (goal <= 0 || steps < 0) return false;
    return steps * 100 >= goal * NotificationRules.walkNearGoalMinPercent &&
        steps * 100 < goal * NotificationRules.walkNearGoalMaxExclusivePercent;
  }

  // ---------------------------------------------------------------------------
  // ค่าที่ derive จากแผน (game-rules §1.2)
  // ---------------------------------------------------------------------------

  /// รายการที่ถึงเวลาแล้ว (ส่งแล้ว) — `scheduledAt <= now`
  static List<PlannedNotification> committed(
    NotificationDayPlan? plan,
    DateTime now,
  ) => [
    for (final i in plan?.items ?? const <PlannedNotification>[])
      if (!i.scheduledAt.isAfter(now)) i,
  ];

  /// รายการที่ยังไม่ถึงเวลา — `scheduledAt > now`
  static List<PlannedNotification> pending(
    NotificationDayPlan? plan,
    DateTime now,
  ) => [
    for (final i in plan?.items ?? const <PlannedNotification>[])
      if (i.scheduledAt.isAfter(now)) i,
  ];

  /// `sent_notification_count`
  static int sentCount(NotificationDayPlan? plan, DateTime now) =>
      committed(plan, now).length;

  /// `last_notification_timestamp`
  static DateTime? lastSentAt(NotificationDayPlan? plan, DateTime now) {
    DateTime? last;
    for (final i in committed(plan, now)) {
      if (last == null || i.scheduledAt.isAfter(last)) last = i.scheduledAt;
    }
    return last;
  }

  /// `walk_near_goal_sent_today`
  static bool walkNearGoalSentToday(NotificationDayPlan? plan, DateTime now) =>
      committed(
        plan,
        now,
      ).any((i) => i.message == NotificationMessage.walkNearGoal);

  /// แผนของรอบวันนี้ — แผนของวันอื่นถือว่าว่าง (รีเซ็ต 05:00 — AC-35, EC-8)
  static NotificationDayPlan planForToday(
    NotificationDayPlan? previous,
    DateTime now,
  ) {
    final today = logicalDay(now);
    if (previous == null || previous.day != today) {
      return NotificationDayPlan(day: today);
    }
    return previous;
  }

  // ---------------------------------------------------------------------------
  // id / payload (ui-spec §2.3.3, §2.4.5, Q-25)
  // ---------------------------------------------------------------------------

  /// hash แบบกำหนดได้ (FNV-1a 32 บิต) ของ `'<yyyy-MM-dd ของรอบวัน>|<message>|<anchor ISO>'`
  /// & 0x7fffffff — ไม่ใช้ String.hashCode เพราะไม่คงที่ข้ามการเปิดแอป
  static int notificationId(
    DateTime day,
    NotificationMessage message,
    DateTime anchor,
  ) {
    final key = '${_dayKey(day)}|${message.name}|${anchor.toIso8601String()}';
    var hash = 0x811c9dc5;
    for (final unit in key.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash & 0x7fffffff;
  }

  /// `'<topic>|<message>'` เช่น `'water|waterFirst'`
  static String encodePayload(NotificationMessage message) =>
      '${message.topic.payloadCode}${NotificationRules.payloadSeparator}'
      '${message.name}';

  /// อ่าน topic จาก payload — รูปแบบผิด / topic ไม่รู้จัก → null (เปิดแอปเฉย ๆ ไม่นำทาง)
  static NotificationTopic? decodePayload(String? payload) {
    if (payload == null) return null;
    final parts = payload.split(NotificationRules.payloadSeparator);
    if (parts.length != 2) return null;
    final topic = NotificationTopic.fromPayloadCode(parts[0]);
    if (topic == null) return null;
    final message = NotificationMessage.fromName(parts[1]);
    // ASSUMPTION: message ที่ไม่รู้จักยังนำทางตาม topic ได้ แต่ message ที่รู้จักต้องตรง topic
    if (message != null && message.topic != topic) return null;
    return topic;
  }

  // ---------------------------------------------------------------------------
  // ผู้สมัคร (ui-spec §2.4.3)
  // ---------------------------------------------------------------------------

  /// ผู้สมัครของรอบวันนี้ (ยังไม่จัดคิว) — `scheduledAt` = `dueAt`
  ///
  /// [plan] = แผนของวันนี้ (หลัง [planForToday]) ใช้ตัด "ส่งครั้งเดียวต่อรอบนับ" และ
  /// [suppressed] = topic ที่ถูกระงับทั้งรอบวัน (EC-3)
  static List<PlannedNotification> candidates(
    NotificationInputs inputs,
    NotificationDayPlan plan,
    DateTime now, {
    Set<NotificationTopic>? suppressed,
  }) {
    final day = plan.day;
    final active = activeStart(day);
    final blocked = suppressed ?? plan.suppressedTopics;
    final done = committed(plan, now);
    final previousPending = pending(plan, now);

    bool isCommitted(NotificationMessage m, DateTime anchor) =>
        done.any((i) => i.message == m && i.anchor == anchor);

    final out = <PlannedNotification>[];
    void add(NotificationMessage m, DateTime anchor, DateTime dueAt) {
      if (isCommitted(m, anchor)) return; // ส่งครั้งเดียวต่อรอบนับ (AC-17)
      out.add(
        PlannedNotification(
          id: notificationId(day, m, anchor),
          message: m,
          anchor: anchor,
          dueAt: dueAt,
          scheduledAt: dueAt,
        ),
      );
    }

    // เดิน — DECIDED (owner 2026-11-08, D-3): ตรวจก้าวไม่ได้ → ไม่มีข้อความเรื่องเดินเลย
    if (!inputs.isTrackingLocked && !blocked.contains(NotificationTopic.walk)) {
      // เดิน: ไม่ขยับ — ไม่มีก้าวใหม่ครบ 4 ชม. (AC-9) · ถึง 100% แล้วยังทำงาน
      final walkAnchor = anchorFor(inputs.lastStepsIncreasedAt, day);
      add(
        NotificationMessage.walkInactive,
        walkAnchor,
        walkAnchor.add(
          const Duration(hours: NotificationRules.walkInactivityHours),
        ),
      );
      // เดิน: ใกล้เป้า — วันละ 1 ครั้ง (anchor = 06:00 ของวัน) (AC-10..AC-14)
      final alreadySent = done.any(
        (i) => i.message == NotificationMessage.walkNearGoal,
      );
      if (!alreadySent && isNearGoal(inputs.steps, inputs.stepsGoal)) {
        // ASSUMPTION: ui-spec Q-08 — dueAt = เวลาที่ตรวจพบ · คงค่าเดิมถ้ายังรอส่งอยู่
        // (id/เวลาที่ตั้งไม่ขยับทุกครั้งที่วางแผนใหม่)
        DateTime due = now;
        for (final p in previousPending) {
          if (p.message == NotificationMessage.walkNearGoal) due = p.dueAt;
        }
        add(NotificationMessage.walkNearGoal, active, due);
      }
    }

    // น้ำ — ครบเป้า (>= 8 แก้ว) หยุดทั้งรอบวัน (AC-19, EC-4)
    if (!blocked.contains(NotificationTopic.water) &&
        inputs.waterCount < NotificationRules.waterDailyGoalGlasses) {
      final waterAnchor = anchorFor(inputs.waterLastLoggedAt, day);
      add(
        NotificationMessage.waterFirst,
        waterAnchor,
        waterAnchor.add(
          const Duration(hours: NotificationRules.waterInactivityFirstHours),
        ),
      );
      add(
        NotificationMessage.waterSecond,
        waterAnchor,
        waterAnchor.add(
          const Duration(hours: NotificationRules.waterInactivitySecondHours),
        ),
      );
    }

    // อาหาร (AC-20..AC-25)
    if (!blocked.contains(NotificationTopic.food)) {
      if (inputs.totalCalories == 0) {
        for (final h in NotificationRules.foodUnloggedHours) {
          final t = _at(day, h);
          add(NotificationMessage.foodUnlogged, t, t);
        }
      }
      final target = inputs.targetCalories;
      final night = target != null
          ? inputs.totalCalories < target
          : inputs.totalCalories == 0;
      if (night) {
        final t = _at(day, NotificationRules.foodNightReminderHour);
        add(NotificationMessage.foodNight, t, t);
      }
    }

    return _dropSupersededByCommitted(out, done, day, now);
  }

  /// สายขั้นบันได (ui-spec Q-06): น้ำ 2→4 ชม. ของรอบนับเดียวกัน (anchor เดียวกัน) ·
  /// อาหาร 12→15→18 ของรอบวัน (แต่ละขั้นมี anchor ของตัวเอง จึงเทียบตามสาย ไม่ใช่ anchor)
  /// · ข้อความอื่นไม่อยู่ในสาย (null)
  static String? _chainKey(PlannedNotification c) => switch (c.message) {
    NotificationMessage.waterFirst ||
    NotificationMessage.waterSecond => 'water|${c.anchor.toIso8601String()}',
    NotificationMessage.foodUnlogged => 'foodUnlogged',
    _ => null,
  };

  /// BUG-NOTI-1 (Dev รอบ 4): ขั้นของสายที่อยู่ก่อนขั้นที่ส่งไปแล้ว (committed) ห้ามวางแผนอีก
  /// (ขั้นถัดไปถูกส่งแล้ว = ขั้นก่อนหน้าถูกแทนที่ตาม Q-06 ไปแล้ว) — ทำให้วางแผนซ้ำได้แผนเดิม
  // DECIDED (owner 2026-11-08, QA คำถาม 1): ตั้งแต่ 21:00:00 ไม่ส่ง "อาหาร: ยังไม่กิน" เลย
  // (game-rules §1.1 "ที่ 21:00:00 ส่งเฉพาะ อาหาร: 21:00") — schedule() ตัดซ้ำตามเวลาคิวด้วย
  static List<PlannedNotification> _dropSupersededByCommitted(
    List<PlannedNotification> items,
    List<PlannedNotification> done,
    DateTime day,
    DateTime now,
  ) {
    final night = _at(day, NotificationRules.foodNightReminderHour);
    bool superseded(PlannedNotification c) {
      final key = _chainKey(c);
      if (key == null) return false;
      return done.any((d) => _chainKey(d) == key && d.dueAt.isAfter(c.dueAt));
    }

    return [
      for (final c in items)
        if (!superseded(c) &&
            !(c.message == NotificationMessage.foodUnlogged &&
                !now.isBefore(night)))
          c,
    ];
  }

  /// ASSUMPTION: ui-spec Q-06 — ในชุดที่ "ถึงเวลาแล้ว" ณ เวลาคิว [t] (dueAt <= t) ถ้าสายเดียวกัน
  /// มีหลายขั้น เก็บเฉพาะขั้นล่าสุด ขั้นก่อนหน้าถูกตัดถาวร (ไม่ส่งรอบวันนี้)
  // BUG-NOTI-1 (Dev รอบ 4): ตัดสินที่เวลาคิว (ไม่ใช่ตอนวางแผน) → ผลขึ้นกับ t และรายการที่เหลือ
  // เท่านั้น การวางแผนซ้ำที่เวลาใดก็ตามจึงเดินคิวเหมือนเดิม (idempotent)
  static Set<PlannedNotification> _supersededInChain(
    List<PlannedNotification> ready,
  ) {
    final latest = <String, PlannedNotification>{};
    for (final c in ready) {
      final key = _chainKey(c);
      if (key == null) continue;
      final cur = latest[key];
      if (cur == null || c.dueAt.isAfter(cur.dueAt)) latest[key] = c;
    }
    return {
      for (final c in ready)
        if (_chainKey(c) != null && !identical(latest[_chainKey(c)], c)) c,
    };
  }

  // ---------------------------------------------------------------------------
  // จัดคิว (ui-spec §2.4.4)
  // ---------------------------------------------------------------------------

  /// วางแผนรอบวันนี้ใหม่: คง committed เดิม + จัดคิวผู้สมัครตามกติกากลาง
  /// (ลำดับ อาหาร > น้ำ > เดิน, ห่าง ≥ 30:00 นาที, เพดาน 6, ไม่ส่ง 23:00:00–05:59:59)
  static NotificationDayPlan buildPlan(
    NotificationInputs inputs,
    NotificationDayPlan? previous,
    DateTime now,
  ) {
    final today = planForToday(previous, now);
    final suppressed = {...today.suppressedTopics, ...invalidTopics(inputs)};
    final done = committed(today, now);
    final remaining = candidates(inputs, today, now, suppressed: suppressed);
    final pendingItems = schedule(
      remaining,
      day: today.day,
      now: now,
      committed: done,
    );
    return NotificationDayPlan(
      day: today.day,
      items: List.unmodifiable([...done, ...pendingItems]),
      suppressedTopics: Set.unmodifiable(suppressed),
    );
  }

  /// แผนตอนสวิตช์ปิด / ไม่ได้รับสิทธิ์: เก็บเฉพาะ committed (AC-7, AC-8)
  static NotificationDayPlan committedOnly(
    NotificationDayPlan? previous,
    DateTime now, {
    NotificationInputs? inputs,
  }) {
    final today = planForToday(previous, now);
    return NotificationDayPlan(
      day: today.day,
      items: List.unmodifiable(committed(today, now)),
      suppressedTopics: Set.unmodifiable({
        ...today.suppressedTopics,
        if (inputs != null) ...invalidTopics(inputs),
      }),
    );
  }

  /// อัลกอริทึมคิว ui-spec §2.4.4 — คืนรายการ pending ที่มี `scheduledAt` แล้ว
  static List<PlannedNotification> schedule(
    List<PlannedNotification> candidates, {
    required DateTime day,
    required DateTime now,
    List<PlannedNotification> committed = const [],
  }) {
    var count = committed.length;
    DateTime? last;
    for (final c in committed) {
      if (last == null || c.scheduledAt.isAfter(last)) last = c.scheduledAt;
    }
    var t = _max(now, activeStart(day));
    if (last != null) t = _max(t, last.add(_interval));
    final quiet = quietStart(day);
    final night = _at(day, NotificationRules.foodNightReminderHour);
    final remaining = [...candidates];
    final out = <PlannedNotification>[];

    while (remaining.isNotEmpty &&
        count < NotificationRules.dailyNotificationCap) {
      // DECIDED (owner 2026-11-08, QA คำถาม 1): "อาหาร: ยังไม่กิน" ที่ถูกเลื่อนจนถึง 21:00:00
      // ไม่ส่ง (ที่ 21:00 ส่งเฉพาะ "อาหาร: 21:00")
      if (!t.isBefore(night)) {
        remaining.removeWhere(
          (c) => c.message == NotificationMessage.foodUnlogged,
        );
        if (remaining.isEmpty) break;
      }
      final ready = remaining.where((c) => !c.dueAt.isAfter(t)).toList();
      final superseded = _supersededInChain(ready);
      if (superseded.isNotEmpty) {
        remaining.removeWhere(superseded.contains);
        ready.removeWhere(superseded.contains);
      }
      if (ready.isEmpty) {
        var next = remaining.first.dueAt;
        for (final c in remaining) {
          if (c.dueAt.isBefore(next)) next = c.dueAt;
        }
        t = _max(t, next);
        continue;
      }
      ready.sort(_byPriority);
      final pick = ready.first;
      // ถึง 23:00:00 แล้ว → ที่เหลือถูกยกเลิก (AC-26, AC-33, EC-7)
      if (!t.isBefore(quiet)) break;
      out.add(
        PlannedNotification(
          id: pick.id,
          message: pick.message,
          anchor: pick.anchor,
          dueAt: pick.dueAt,
          scheduledAt: t,
        ),
      );
      count++;
      t = t.add(_interval);
      remaining.remove(pick);
    }
    // ที่เหลือใน remaining = ไม่ส่งรอบวันนี้ (ชนเพดาน AC-28 / ช่วงห้ามเตือน AC-26)
    return out;
  }

  /// topic.priority มาก→น้อย, dueAt เร็ว→ช้า, ลำดับ enum (AC-31)
  static int _byPriority(PlannedNotification a, PlannedNotification b) {
    final p = b.topic.priority.compareTo(a.topic.priority);
    if (p != 0) return p;
    final d = a.dueAt.compareTo(b.dueAt);
    if (d != 0) return d;
    return a.message.index.compareTo(b.message.index);
  }

  static DateTime _max(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

  static String _dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
