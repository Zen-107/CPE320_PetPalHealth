/// abstraction ของระบบแจ้งเตือนในเครื่อง (ui-spec §2.4) — เทสต์ใช้ตัวปลอม
/// (`FakeNotificationScheduler` ใน app/test/) ห้ามเรียก plugin จริงในเทสต์ (ui-spec §2.4.6)
library;

import 'notification_models.dart';

abstract interface class NotificationScheduler {
  /// เตรียม plugin + รับการกดแจ้งเตือนตอนแอปเปิดอยู่ / อยู่เบื้องหลัง (AC-38..AC-40)
  /// ห้ามขอสิทธิ์ตอนนี้ (AC-3)
  Future<void> initialize({required void Function(String? payload) onTap});

  /// payload ของแจ้งเตือนที่เปิดแอปจากสถานะปิดสนิท (EC-13) — ไม่ได้เปิดจากแจ้งเตือน = null
  Future<String?> launchPayload();

  /// อ่านสิทธิ์ปัจจุบันโดยไม่แสดงกล่อง
  Future<NotificationSystemPermission> checkPermission();

  /// แสดงกล่องขอสิทธิ์ของระบบ (AC-2, AC-6, EC-9)
  Future<NotificationSystemPermission> requestPermission();

  /// ตั้งเวลา [item] ที่ `item.scheduledAt` (id เดิม = แทนที่ของเดิม)
  Future<void> schedule(PlannedNotification item);

  /// ยกเลิก id เดียว
  Future<void> cancel(int id);

  /// ยกเลิกทุกรายการ — ใช้ตอนออกจากระบบเท่านั้น
  // DECIDED (owner 2026-11-08, Q-28): logout → cancelAll + ล้างแผนของวัน
  // (การวางแผนปกติห้ามใช้ — ui-spec §2.4.5)
  Future<void> cancelAll();
}

/// ไม่ทำอะไร — แพลตฟอร์มที่ไม่รองรับ (เช่น windows) / เทสต์ที่ไม่สนใจแจ้งเตือน
/// สิทธิ์ถือเป็น NOT_DETERMINED เสมอ → controller ไม่ตั้งเวลา
class NoopNotificationScheduler implements NotificationScheduler {
  const NoopNotificationScheduler();

  @override
  Future<void> initialize({required void Function(String? payload) onTap}) async {}

  @override
  Future<String?> launchPayload() async => null;

  @override
  Future<NotificationSystemPermission> checkPermission() async =>
      NotificationSystemPermission.notDetermined;

  @override
  Future<NotificationSystemPermission> requestPermission() async =>
      NotificationSystemPermission.notDetermined;

  @override
  Future<void> schedule(PlannedNotification item) async {}

  @override
  Future<void> cancel(int id) async {}

  @override
  Future<void> cancelAll() async {}
}
