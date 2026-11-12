import 'package:flutter/material.dart';
import 'package:petpal_health/shared/pet/pet.dart';

import '../voice_controller.dart';
import '../voice_rules.dart';

/// S-1 First Launch Permission Dialog — ui-spec §2.1 (AC-1)
///
/// เปิดทับหน้า Home ด้วย `showDialog(barrierDismissible: false)` + `PopScope(canPop: false)`
/// → ปิดได้ทางปุ่ม 2 ปุ่มเท่านั้น (ux-flow "บังคับเลือกปุ่มใดปุ่มหนึ่ง")
/// pattern เดียวกับ showNotificationConsentCard
Future<void> showVoicePermissionDialog(
  BuildContext context,
  VoiceController controller, {
  bool? animatePet,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => VoicePermissionDialog(
      controller: controller,
      animatePet: animatePet,
    ),
  );
}

class VoicePermissionDialog extends StatefulWidget {
  const VoicePermissionDialog({
    super.key,
    required this.controller,
    this.animatePet,
  });

  final VoiceController controller;

  /// `PetCharacter.animate` — null = [kPetAnimateByDefault]
  final bool? animatePet;

  @override
  State<VoicePermissionDialog> createState() => _VoicePermissionDialogState();
}

class _VoicePermissionDialogState extends State<VoicePermissionDialog> {
  bool _answered = false;

  /// ปิด dialog ก่อน แล้วจึงบันทึกคำตอบ (ui-spec §2.1)
  void _answer(bool enabled) {
    if (_answered) return; // กันกดซ้ำ
    _answered = true;
    Navigator.of(context).pop();
    widget.controller.answerPermission(enabled: enabled);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: Dialog(
        key: const Key('voice_permission_dialog'),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // DECIDED (owner 2026-11-12, V-1, V-9): PetCharacter ท่าที่มีอยู่แทน PNG
                // ASSUMPTION: voice ui-spec Q-05 — dashboardCheerful (ต่างจากการ์ดแจ้งเตือน)
                Center(
                  child: KeyedSubtree(
                    key: const ValueKey('voice_permission_pet_image'),
                    child: PetCharacter(
                      pose: PetPose.dashboardCheerful,
                      size: VoiceRules.dialogPetSize,
                      animate: widget.animatePet ?? kPetAnimateByDefault,
                      reactToTap: false,
                      semanticLabel: VoiceRules.dialogPetSemanticLabel,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  VoiceRules.dialogTitle,
                  key: const Key('voice_permission_title_text'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  VoiceRules.dialogBody,
                  key: const Key('voice_permission_body_text'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  key: const Key('voice_permission_enable_button'),
                  onPressed: () => _answer(true),
                  child: const Text(VoiceRules.enableButtonText),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  key: const Key('voice_permission_disable_button'),
                  onPressed: () => _answer(false),
                  child: const Text(VoiceRules.disableButtonText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
