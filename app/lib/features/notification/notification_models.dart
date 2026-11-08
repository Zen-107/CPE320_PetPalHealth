/// โมเดลข้อมูลของฟีเจอร์แจ้งเตือน (pure Dart ไม่ขึ้นกับ Flutter) — ui-spec §2.4
library;

import 'dart:convert';

import 'notification_rules.dart';

/// `consent_status` (game-rules §1.2) — เปลี่ยนครั้งเดียวเมื่อกดปุ่มบน S-1 (AC-1..AC-4)
enum NotificationConsentStatus {
  allowed('ALLOWED'),
  denied('DENIED'),
  unanswered('UNANSWERED');

  const NotificationConsentStatus(this.code);

  /// ค่า CODE_ENUM ที่เก็บในเครื่อง
  final String code;

  /// ค่าที่ไม่รู้จัก / null → ค่าเริ่มต้น UNANSWERED
  static NotificationConsentStatus fromCode(String? code) {
    for (final v in values) {
      if (v.code == code) return v;
    }
    return unanswered;
  }
}

/// `system_permission_status` (game-rules §1.2)
enum NotificationSystemPermission {
  granted('GRANTED'),
  denied('DENIED'),
  notDetermined('NOT_DETERMINED');

  const NotificationSystemPermission(this.code);

  final String code;

  /// ค่าที่ไม่รู้จัก / null → ค่าเริ่มต้น NOT_DETERMINED
  static NotificationSystemPermission fromCode(String? code) {
    for (final v in values) {
      if (v.code == code) return v;
    }
    return notDetermined;
  }
}

/// เรื่องของแจ้งเตือน + ลำดับความสำคัญ อาหาร > น้ำ > เดิน (AC-31, EC-5) + ปลายทาง deep link
enum NotificationTopic {
  food(3, 'food'),
  water(2, 'water'),
  walk(1, 'walk');

  const NotificationTopic(this.priority, this.payloadCode);

  /// มาก = สำคัญกว่า
  final int priority;

  /// ส่วน topic ของ payload `'<topic>|<message>'`
  final String payloadCode;

  static NotificationTopic? fromPayloadCode(String? code) {
    for (final v in values) {
      if (v.payloadCode == code) return v;
    }
    return null;
  }
}

/// ตารางข้อความ S-3 (ui-spec §2.3.1) — ลำดับ enum = ลำดับในเอกสาร
// DECIDED (owner 2026-11-08, D-3): ไม่มี "เดิน: บันทึกเอง" (walkManual)
enum NotificationMessage {
  walkInactive(NotificationTopic.walk),
  walkNearGoal(NotificationTopic.walk),
  waterFirst(NotificationTopic.water),
  waterSecond(NotificationTopic.water),
  foodUnlogged(NotificationTopic.food),
  foodNight(NotificationTopic.food);

  const NotificationMessage(this.topic);

  final NotificationTopic topic;

  /// ข้อความตรงตัวจาก NotificationRules
  String get text => switch (this) {
        NotificationMessage.walkInactive => NotificationRules.walkInactiveText,
        NotificationMessage.walkNearGoal => NotificationRules.walkNearGoalText,
        NotificationMessage.waterFirst => NotificationRules.waterFirstText,
        NotificationMessage.waterSecond => NotificationRules.waterSecondText,
        NotificationMessage.foodUnlogged => NotificationRules.foodUnloggedText,
        NotificationMessage.foodNight => NotificationRules.foodNightText,
      };

  static NotificationMessage? fromName(String? name) {
    for (final v in values) {
      if (v.name == name) return v;
    }
    return null;
  }
}

/// snapshot ค่าที่อ่านจาก 3 ฟีเจอร์ ณ เวลาวางแผน (ui-spec §2.4.1)
///
/// ค่าทุกตัวต้องเป็นของ "รอบวันนี้" แล้ว — ค่าของรอบวันก่อนให้ส่ง 0 / null
/// (ดู `NotificationLogic.inputsFor` ที่แปลงจากค่าดิบให้)
class NotificationInputs {
  const NotificationInputs({
    required this.waterCount,
    required this.waterLastLoggedAt,
    required this.steps,
    required this.stepsGoal,
    required this.isTrackingLocked,
    required this.lastStepsIncreasedAt,
    required this.totalCalories,
    required this.targetCalories,
  });

  /// `daily_water_count`
  final int waterCount;

  /// `last_logged_timestamp` ของน้ำ (null = ไม่มีในรอบวันนี้)
  final DateTime? waterLastLoggedAt;

  /// `current_steps`
  final int steps;

  /// `daily_goal`
  final int stepsGoal;

  /// ตรวจก้าวไม่ได้ (StepsController.isTrackingLocked) — true = ไม่มีข้อความเรื่องเดิน (D-3)
  final bool isTrackingLocked;

  /// `last_steps_increased_timestamp` (null = ไม่มีในรอบวันนี้)
  final DateTime? lastStepsIncreasedAt;

  /// `total_calories`
  final int totalCalories;

  /// เป้าแคลอรี่ (null = ไม่มีเป้า / ข้ามโปรไฟล์)
  final int? targetCalories;

  @override
  String toString() => 'NotificationInputs(water: $waterCount @ '
      '$waterLastLoggedAt, steps: $steps/$stepsGoal locked: $isTrackingLocked '
      '@ $lastStepsIncreasedAt, kcal: $totalCalories/$targetCalories)';
}

/// 1 รายการในแผนของวัน (ui-spec §2.4)
class PlannedNotification {
  const PlannedNotification({
    required this.id,
    required this.message,
    required this.anchor,
    required this.dueAt,
    required this.scheduledAt,
  });

  /// id ของแจ้งเตือนบน OS — `NotificationLogic.notificationId`
  final int id;
  final NotificationMessage message;

  /// จุดเริ่มของ "รอบนับ" — message + anchor เดียวกัน = รอบนับเดียวกัน (ส่งครั้งเดียว)
  final DateTime anchor;

  /// เวลาที่เข้าเงื่อนไขตามกติกา
  final DateTime dueAt;

  /// เวลาที่ตั้งจริงหลังจัดคิว (≥ dueAt)
  final DateTime scheduledAt;

  NotificationTopic get topic => message.topic;

  Map<String, Object> toJson() => {
        'id': id,
        'message': message.name,
        'anchor': anchor.toIso8601String(),
        'dueAt': dueAt.toIso8601String(),
        'scheduledAt': scheduledAt.toIso8601String(),
      };

  /// อ่านไม่ได้ → null (ข้ามรายการนั้น)
  static PlannedNotification? fromJson(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    final message = NotificationMessage.fromName(json['message'] as String?);
    final anchor = _parseDate(json['anchor']);
    final dueAt = _parseDate(json['dueAt']);
    final scheduledAt = _parseDate(json['scheduledAt']);
    if (id is! int ||
        message == null ||
        anchor == null ||
        dueAt == null ||
        scheduledAt == null) {
      return null;
    }
    return PlannedNotification(
      id: id,
      message: message,
      anchor: anchor,
      dueAt: dueAt,
      scheduledAt: scheduledAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PlannedNotification &&
      other.id == id &&
      other.message == message &&
      other.anchor == anchor &&
      other.dueAt == dueAt &&
      other.scheduledAt == scheduledAt;

  @override
  int get hashCode => Object.hash(id, message, anchor, dueAt, scheduledAt);

  @override
  String toString() =>
      'PlannedNotification(${message.name} @ $scheduledAt, due $dueAt, '
      'anchor $anchor, id $id)';
}

/// แผนแจ้งเตือนของรอบวัน (key `notification_day_plan` — ui-spec §2.5, Q-21)
class NotificationDayPlan {
  const NotificationDayPlan({
    required this.day,
    this.items = const [],
    this.suppressedTopics = const {},
  });

  /// รอบวัน (logicalDay — ปี/เดือน/วัน)
  final DateTime day;

  /// รายการทั้งหมดของวัน เรียงตาม scheduledAt (committed + pending)
  final List<PlannedNotification> items;

  /// เรื่องที่ถูกระงับทั้งรอบวันเพราะค่าผิดปกติ (EC-3, D-4, Q-20)
  final Set<NotificationTopic> suppressedTopics;

  String toJsonString() => jsonEncode({
        'day': _formatDay(day),
        'items': [for (final i in items) i.toJson()],
        'suppressedTopics': [for (final t in suppressedTopics) t.payloadCode],
      });

  /// อ่านไม่ได้ → null (ถือว่าไม่มีแผน)
  static NotificationDayPlan? fromJsonString(String? raw) {
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw);
      if (json is! Map) return null;
      final day = _parseDate(json['day']);
      if (day == null) return null;
      final rawItems = json['items'];
      final rawTopics = json['suppressedTopics'];
      final items = <PlannedNotification>[
        if (rawItems is List)
          for (final r in rawItems) ?PlannedNotification.fromJson(r),
      ]..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      final topics = <NotificationTopic>{
        if (rawTopics is List)
          for (final r in rawTopics)
            ?NotificationTopic.fromPayloadCode(r is String ? r : null),
      };
      return NotificationDayPlan(
        day: DateTime(day.year, day.month, day.day),
        items: List.unmodifiable(items),
        suppressedTopics: Set.unmodifiable(topics),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  String toString() =>
      'NotificationDayPlan(${_formatDay(day)}, $items, suppressed: $suppressedTopics)';
}

/// สถานะที่ฟีเจอร์แจ้งเตือนเก็บเองในเครื่อง (game-rules §1.2 + `notification_day_plan`)
class NotificationState {
  const NotificationState({
    this.consentStatus = NotificationConsentStatus.unanswered,
    this.masterSwitch = false,
    this.systemPermission = NotificationSystemPermission.notDetermined,
    this.sentNotificationCount = 0,
    this.lastNotificationTimestamp,
    this.walkNearGoalSentToday = false,
    this.lastStepsIncreasedTimestamp,
    this.dayPlan,
  });

  static const NotificationState initial = NotificationState();

  final NotificationConsentStatus consentStatus;

  /// `notification_master_switch` true = ON
  final bool masterSwitch;
  final NotificationSystemPermission systemPermission;

  /// derive จาก plan (ui-spec §2.4.5 ข้อ 4)
  final int sentNotificationCount;
  final DateTime? lastNotificationTimestamp;
  final bool walkNearGoalSentToday;

  final DateTime? lastStepsIncreasedTimestamp;
  final NotificationDayPlan? dayPlan;

  @override
  String toString() => 'NotificationState(consent: ${consentStatus.code}, '
      'master: $masterSwitch, permission: ${systemPermission.code}, '
      'sent: $sentNotificationCount, last: $lastNotificationTimestamp, '
      'nearGoalSent: $walkNearGoalSentToday, '
      'stepsIncreased: $lastStepsIncreasedTimestamp, plan: $dayPlan)';
}

DateTime? _parseDate(Object? raw) =>
    raw is String ? DateTime.tryParse(raw) : null;

String _formatDay(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
