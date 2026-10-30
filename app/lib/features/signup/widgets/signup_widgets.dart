import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../signup_logic.dart';
import '../signup_rules.dart';

/// ช่องอายุ S-6 (D-c: จำนวนเต็มเท่านั้น) — ปฏิเสธการแก้ไขทั้งก้อนเมื่อข้อความใหม่มีอักขระ
/// ที่ไม่ใช่เลข 0-9 แล้วคงค่าเดิมไว้
///
/// ใช้วางก่อน `FilteringTextInputFormatter.digitsOnly` (ui-spec §2.6 #6): digitsOnly อย่างเดียว
/// จะกรองทิ้งเฉพาะตัวที่ไม่ใช่ตัวเลข ทำให้การวาง "25.5" กลายเป็น "255", "2.5" → "25",
/// "-3" → "3" (ค่าเปลี่ยนเงียบ ๆ) — formatter นี้ทำให้ทั้งการวางนั้นไม่มีผลแทน
// ASSUMPTION: ui-spec ไม่ได้กำหนดพฤติกรรมการวางข้อความที่มีอักขระอื่นปน — เลือกปฏิเสธทั้งก้อน
// (ไม่เปลี่ยนค่าเงียบ ๆ และไม่เพิ่ม UI/ข้อความใหม่)
class SignupWholeNumberInputFormatter extends TextInputFormatter {
  const SignupWholeNumberInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty || SignupLogic.isWholeNumberText(text)) return newValue;
    return oldValue;
  }
}

/// เนื้อในปุ่มขณะ loading (ui-spec §3): spinner 20×20 strokeWidth 2 + ข้อความปุ่มเดิม
/// ใช้คู่กับ `onPressed: null` (สี disabled ตาม M3 default)
class SignupButtonLabel extends StatelessWidget {
  const SignupButtonLabel({
    super.key,
    required this.text,
    required this.loading,
    required this.indicatorKey,
  });

  final String text;
  final bool loading;
  final String indicatorKey;

  @override
  Widget build(BuildContext context) {
    if (!loading) return Text(text);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            key: ValueKey(indicatorKey),
            strokeWidth: 2,
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}

/// dialog เครือข่ายขัดข้อง (ui-spec §3, EC-1 / EC-4) — pattern `steps_report_error_dialog`
/// คืน true เมื่อผู้ใช้กด「ลองใหม่อีกครั้ง」; ปิด dialog ด้วยการแตะนอกกรอบ → false
Future<bool> showSignupNetworkErrorDialog(
  BuildContext context, {
  required String dialogKey,
  required String retryKey,
}) async {
  final retry = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => AlertDialog(
      key: ValueKey(dialogKey),
      content: const Text(SignupRules.networkErrorMessage),
      actions: [
        FilledButton(
          key: ValueKey(retryKey),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text(SignupRules.retryButtonText),
        ),
      ],
    ),
  );
  return retry == true;
}

/// Toast (SnackBar) ตาม pattern `showStepsToast` (ui-spec §1.3)
void showSignupToast(ScaffoldMessengerState messenger, String key, String message) {
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      key: ValueKey(key),
      content: Text(message),
      duration: const Duration(seconds: SignupRules.toastSeconds),
      persist: false,
    ),
  );
}

/// ข้อความเตือน (Inline Warning) สี tertiary bodySmall (ui-spec §1.1, §2.6)
class SignupWarningText extends StatelessWidget {
  const SignupWarningText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.bodySmall
          ?.copyWith(color: theme.colorScheme.tertiary),
    );
  }
}
