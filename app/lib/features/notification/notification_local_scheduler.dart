/// ตัวตั้งเวลาจริงด้วย flutter_local_notifications + timezone + flutter_timezone
/// (DECIDED owner 2026-11-08, D-5) — ในเครื่องเท่านั้น ไม่ต่อเน็ต · ใช้เฉพาะ Android / iOS
///
/// ห้ามสร้างในเทสต์ (ui-spec §2.4.6) — เทสต์ใช้ FakeNotificationScheduler
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'notification_avatar.dart';
import 'notification_logic.dart';
import 'notification_models.dart';
import 'notification_rules.dart';
import 'notification_scheduler.dart';

class LocalNotificationScheduler implements NotificationScheduler {
  LocalNotificationScheduler({
    FlutterLocalNotificationsPlugin? plugin,
    NotificationAvatarSource? avatar,
  })  : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
        _avatar = avatar ?? PainterNotificationAvatarSource();

  final FlutterLocalNotificationsPlugin _plugin;
  final NotificationAvatarSource _avatar;

  /// แพลตฟอร์มที่ตัวนี้รองรับ — อื่น ๆ ใช้ NoopNotificationScheduler
  static bool get isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  IOSFlutterLocalNotificationsPlugin? get _ios =>
      _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

  @override
  Future<void> initialize({
    required void Function(String? payload) onTap,
  }) async {
    await _initTimeZone();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(NotificationRules.androidSmallIcon),
        // AC-3: ไม่ขอสิทธิ์ตอน initialize — ขอเมื่อผู้ใช้กดอนุญาต / เปิดสวิตช์เท่านั้น
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      // FOREGROUND / BACKGROUND (AC-38..AC-40)
      onDidReceiveNotificationResponse: (r) => onTap(r.payload),
    );
    await _android?.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationRules.androidChannelId,
        NotificationRules.androidChannelName,
        description: NotificationRules.androidChannelDescription,
        // DECIDED (owner 2026-11-09): Q-09 เปลี่ยน — เด้งบนจอ (heads-up) importance high
        // NOTE: Android ไม่เปลี่ยน importance ของ channel ที่สร้างไว้แล้ว (id เดิม petpal_reminders)
        // เครื่องที่ติดตั้งรุ่นก่อนต้องล้างข้อมูลแอปหรือติดตั้งใหม่ จึงจะเด้ง — ไม่ทำโค้ดย้าย channel
        importance: Importance.high,
      ),
    );
  }

  /// ASSUMPTION: ui-spec Q-19 — หาเขตเวลาไม่ได้ → offset คงที่ (Etc/GMT±N) → UTC
  /// (เวลาที่ตั้งเป็นจุดเวลาเดียวกันเสมอเพราะแปลงด้วย TZDateTime.from — เขตเวลามีผลแค่การแสดง)
  static Future<void> _initTimeZone() async {
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
      return;
    } catch (_) {
      // ไปใช้ fallback
    }
    try {
      final offset = DateTime.now().timeZoneOffset;
      if (offset.inMinutes % 60 == 0) {
        final h = offset.inHours;
        // Etc/GMT กลับเครื่องหมาย: UTC+7 = Etc/GMT-7
        final name = h == 0 ? 'Etc/GMT' : 'Etc/GMT${h > 0 ? '-' : '+'}${h.abs()}';
        tz.setLocalLocation(tz.getLocation(name));
        return;
      }
    } catch (_) {
      // ไปใช้ UTC
    }
    tz.setLocalLocation(tz.UTC);
  }

  @override
  Future<String?> launchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details == null || !details.didNotificationLaunchApp) return null;
    return details.notificationResponse?.payload;
  }

  @override
  Future<NotificationSystemPermission> checkPermission() async {
    if (_isAndroid) {
      final enabled = await _android?.areNotificationsEnabled();
      if (enabled == null) return NotificationSystemPermission.notDetermined;
      // ASSUMPTION: ui-spec Q-15 — Android < 13 ไม่มีกล่อง: เปิดอยู่ = GRANTED
      return enabled
          ? NotificationSystemPermission.granted
          : NotificationSystemPermission.denied;
    }
    final options = await _ios?.checkPermissions();
    if (options == null) return NotificationSystemPermission.notDetermined;
    return options.isEnabled
        ? NotificationSystemPermission.granted
        : NotificationSystemPermission.denied;
  }

  @override
  Future<NotificationSystemPermission> requestPermission() async {
    final bool? granted;
    if (_isAndroid) {
      granted = await _android?.requestNotificationsPermission();
    } else {
      granted =
          await _ios?.requestPermissions(alert: true, sound: true, badge: false);
    }
    return granted == true
        ? NotificationSystemPermission.granted
        : NotificationSystemPermission.denied;
  }

  @override
  Future<void> schedule(PlannedNotification item) async {
    final details = await _details(item);
    // iOS ไม่มี title (2 ส่วน: ไอคอนแอป + ข้อความ — AC-37) · Android title = 「น้องอ๊บ」
    final title = _isAndroid ? NotificationRules.senderName : null;
    final body = item.message.text;
    final payload = NotificationLogic.encodePayload(item.message);
    final now = DateTime.now();
    if (!item.scheduledAt
        .isAfter(now.add(NotificationRules.showImmediatelyWithin))) {
      await _plugin.show(
        id: item.id,
        title: title,
        body: body,
        notificationDetails: details,
        payload: payload,
      );
      return;
    }
    await _plugin.zonedSchedule(
      id: item.id,
      scheduledDate: tz.TZDateTime.from(item.scheduledAt, tz.local),
      notificationDetails: details,
      // DECIDED (owner 2026-11-08, D-6): ไม่เป๊ะ ไม่ขอ exact alarm
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      title: title,
      body: body,
      payload: payload,
    );
  }

  Future<NotificationDetails> _details(PlannedNotification item) async {
    Uint8List? avatar;
    if (_isAndroid) {
      try {
        avatar = await _avatar.avatarPng();
      } catch (_) {
        avatar = null;
      }
    }
    final person = Person(
      key: NotificationRules.senderKey,
      name: NotificationRules.senderName,
      // เรนเดอร์ไม่สำเร็จ → ไม่มีรูป (ยังเป็นแชต มีชื่อ + ข้อความ) — ui-spec §2.3.2
      icon: avatar == null || avatar.isEmpty ? null : ByteArrayAndroidIcon(avatar),
    );
    return NotificationDetails(
      // AC-36 แชต 3 ส่วน: ชื่อผู้ส่ง + รูปโปรไฟล์ + ข้อความ
      android: AndroidNotificationDetails(
        NotificationRules.androidChannelId,
        NotificationRules.androidChannelName,
        channelDescription: NotificationRules.androidChannelDescription,
        // DECIDED (owner 2026-11-09): Q-09 heads-up — high (Android < 8 ใช้ priority)
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.message,
        icon: NotificationRules.androidSmallIcon,
        // seed เดิมของ main.dart (ui-spec §1.1)
        color: Colors.lightBlue,
        styleInformation: MessagingStyleInformation(
          person,
          groupConversation: false,
          messages: [Message(item.message.text, item.scheduledAt, person)],
        ),
      ),
      // AC-37 ปกติ 2 ส่วน · แอปเปิดอยู่ยังแสดง banner (ASSUMPTION: ui-spec Q-26)
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBanner: true,
        presentList: true,
        presentSound: true,
        presentBadge: false,
      ),
    );
  }

  @override
  Future<void> cancel(int id) => _plugin.cancel(id: id);

  @override
  Future<void> cancelAll() => _plugin.cancelAll();
}
