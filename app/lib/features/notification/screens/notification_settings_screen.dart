import 'package:flutter/material.dart';

import '../notification_controller.dart';
import '../notification_models.dart';
import '../notification_rules.dart';

/// S-2 หน้าตั้งค่าแจ้งเตือน — ui-spec §2.2 (AC-5..AC-8, EC-1, EC-9, EC-10)
///
/// เข้าจากปุ่มตั้งค่าบน AppBar ของ dashboard (DECIDED owner 2026-11-08, D-2)
/// · สิทธิ์ที่เปลี่ยนตอน resume มาจาก WaterHomeScreen (root) → วาดใหม่ผ่าน ListenableBuilder
class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key, required this.controller});

  final NotificationController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          NotificationRules.settingsTitle,
          key: Key('notification_settings_header_text'),
        ),
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          if (!controller.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildContent(context);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final denied =
        controller.systemPermission == NotificationSystemPermission.denied;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            key: const Key('notification_master_switch'),
            value: controller.isSwitchOn,
            onChanged: controller.setMasterSwitch,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              NotificationRules.masterSwitchLabel,
              key: Key('notification_master_switch_label'),
            ),
          ),
          // PERMISSION_DENIED (AC-8, EC-10) — แสดงเฉพาะเมื่อระบบปฏิเสธสิทธิ์
          if (denied) ...[
            const SizedBox(height: 8),
            Container(
              key: const Key('notification_permission_denied_banner'),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: scheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                NotificationRules.permissionDeniedText,
                key: const Key('notification_permission_denied_text'),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
