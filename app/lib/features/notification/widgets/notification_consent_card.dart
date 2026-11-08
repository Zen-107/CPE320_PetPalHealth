import 'package:flutter/material.dart';
import 'package:petpal_health/shared/pet/pet.dart';

import '../notification_controller.dart';
import '../notification_rules.dart';

/// S-1 การ์ดขอความยินยอม — ui-spec §2.1 (AC-1..AC-5)
///
/// เปิดทับหน้า Home ด้วย `showDialog(barrierDismissible: false)` + `PopScope(canPop: false)`
/// → ปิดได้ทางปุ่มอนุญาต / ไม่อนุญาตเท่านั้น (ux-flow "บล็อกการกดทะลุ", ASSUMPTION: ui-spec Q-22)
Future<void> showNotificationConsentCard(
  BuildContext context,
  NotificationController controller, {
  bool? animatePet,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => NotificationConsentCard(
      controller: controller,
      animatePet: animatePet,
    ),
  );
}

class NotificationConsentCard extends StatefulWidget {
  const NotificationConsentCard({
    super.key,
    required this.controller,
    this.animatePet,
  });

  final NotificationController controller;

  /// `PetCharacter.animate` — null = [kPetAnimateByDefault]
  final bool? animatePet;

  @override
  State<NotificationConsentCard> createState() =>
      _NotificationConsentCardState();
}

class _NotificationConsentCardState extends State<NotificationConsentCard> {
  bool _answered = false;

  /// ปิดการ์ด "ก่อน" แล้วจึงบันทึกคำตอบ → กล่องขอสิทธิ์ของ OS ขึ้นหลังการ์ดปิด (ui-spec §2.1)
  void _answer(bool allowed) {
    if (_answered) return; // กดแล้วไม่รับการกดซ้ำ
    _answered = true;
    Navigator.of(context).pop();
    widget.controller.answerConsent(allowed: allowed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: Dialog(
        key: const Key('notification_consent_card'),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // DECIDED (owner 2026-11-08, D-1): PetCharacter แทนไฟล์ภาพ PNG ของ ux-flow §5
                Center(
                  child: KeyedSubtree(
                    key: const ValueKey('notification_consent_pet_image'),
                    child: PetCharacter(
                      pose: PetPose.notificationProfile,
                      size: NotificationRules.consentPetSize,
                      animate: widget.animatePet ?? kPetAnimateByDefault,
                      // ux-flow §2 S-1 "ไม่มีผลเมื่อกด"
                      reactToTap: false,
                      semanticLabel: NotificationRules.petSemanticLabel,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  NotificationRules.consentTitle,
                  key: const Key('notification_consent_title_text'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  NotificationRules.consentBody,
                  key: const Key('notification_consent_body_text'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  key: const Key('notification_consent_allow_button'),
                  onPressed: () => _answer(true),
                  child: const Text(NotificationRules.allowButtonText),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  key: const Key('notification_consent_deny_button'),
                  onPressed: () => _answer(false),
                  child: const Text(NotificationRules.denyButtonText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
