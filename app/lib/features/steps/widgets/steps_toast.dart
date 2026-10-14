import 'package:flutter/material.dart';

import '../steps_rules.dart';

/// แสดง Toast (SnackBar) ตาม pattern `water_anti_spam_toast` (ui-spec §2.2)
/// ซ่อนอันเดิมก่อน แล้วแสดงใหม่ หายเองใน [StepsRules.toastSeconds] วินาที
void showStepsToast(BuildContext context, String key, String message) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      key: ValueKey(key),
      content: Text(message),
      duration: const Duration(seconds: StepsRules.toastSeconds),
      persist: false,
    ),
  );
}
