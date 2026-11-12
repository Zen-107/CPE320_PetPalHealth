import 'package:flutter/material.dart';

import '../../voice/voice_controller.dart';
import '../../voice/voice_rules.dart';
import '../notification_controller.dart';
import '../notification_models.dart';
import '../notification_rules.dart';

/// S-2 หน้าตั้งค่าแจ้งเตือน — ui-spec §2.2 (AC-5..AC-8, EC-1, EC-9, EC-10)
///
/// เข้าจากปุ่มตั้งค่าบน AppBar ของ dashboard (DECIDED owner 2026-11-08, D-2)
/// · สิทธิ์ที่เปลี่ยนตอน resume มาจาก WaterHomeScreen (root) → วาดใหม่ผ่าน ListenableBuilder
///
/// voice S-3 (voice ui-spec §2.3) — DECIDED (owner 2026-11-12, V-2): ไม่สร้าง modal ใหม่ ·
/// เพิ่มสวิตช์ Master Voice ไว้บนสุดของหน้านี้ เมื่อได้รับ [voiceController] (null = หน้าเดิม)
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({
    super.key,
    required this.controller,
    this.voiceController,
  });

  final NotificationController controller;

  /// null = ไม่มีสวิตช์เสียง (หน้าเดิมทุกพิกเซล)
  final VoiceController? voiceController;

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  /// saveFailureCount ล่าสุดที่เห็น — เปลี่ยน = บันทึกสวิตช์เสียงไม่สำเร็จ → SnackBar
  int _seenSaveFailures = 0;

  NotificationController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    final voice = widget.voiceController;
    if (voice != null) {
      _seenSaveFailures = voice.saveFailureCount;
      voice.addListener(_onVoiceChanged);
      voice.load();
    }
  }

  @override
  void dispose() {
    final voice = widget.voiceController;
    if (voice != null) {
      voice.removeListener(_onVoiceChanged);
      // ui-spec §2.3: ออกจากหน้าระหว่างรอ debounce → บันทึกค่าค้างทันที (ไม่ทิ้ง)
      voice.flushPendingSave();
    }
    super.dispose();
  }

  /// ux-flow §4 S-3 ERROR — SnackBar pattern เดียวกับ showStepsToast
  void _onVoiceChanged() {
    final voice = widget.voiceController;
    if (voice == null || !mounted) return;
    if (voice.saveFailureCount == _seenSaveFailures) return;
    _seenSaveFailures = voice.saveFailureCount;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      const SnackBar(
        key: ValueKey('voice_save_error_toast'),
        content: Text(VoiceRules.saveErrorText),
        duration: Duration(seconds: VoiceRules.saveErrorToastSeconds),
        persist: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final voice = widget.voiceController;
    return Scaffold(
      appBar: AppBar(
        // ASSUMPTION: voice ui-spec Q-02 — คง AppBar title เดิม (ไม่มีหัวข้อ modal / ปุ่ม X)
        title: const Text(
          NotificationRules.settingsTitle,
          key: Key('notification_settings_header_text'),
        ),
      ),
      body: ListenableBuilder(
        listenable:
            voice == null ? controller : Listenable.merge([controller, voice]),
        builder: (context, _) {
          if (!controller.isLoaded || (voice != null && !voice.isLoaded)) {
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
    final voice = widget.voiceController;
    final denied =
        controller.systemPermission == NotificationSystemPermission.denied;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // voice S-3 #1 Master Voice Toggle — บนสุด (DECIDED owner 2026-11-12, V-2)
          if (voice != null)
            SwitchListTile(
              key: const Key('voice_master_switch'),
              value: voice.masterVoice,
              onChanged: voice.setMasterVoice,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                VoiceRules.masterVoiceSwitchLabel,
                key: Key('voice_master_switch_label'),
              ),
            ),
          // voice S-3 #2 Push Notification Shortcut = สวิตช์เดิม ไม่แตะ
          // (DECIDED owner 2026-11-12, V-3 · ASSUMPTION: voice ui-spec Q-03 ป้ายเดิม)
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
