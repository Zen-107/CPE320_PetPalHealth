import 'package:flutter/material.dart';

import '../../water/widgets/asset_image_or_icon.dart';
import '../signup_controller.dart';
import '../signup_rules.dart';
import 'signup_email_screen.dart';

/// S-4 หน้าจอรอการยืนยันรีเซ็ตรหัสผ่าน (ux-flow §2 S-4, ui-spec §2.4)
class SignupResetSentScreen extends StatelessWidget {
  const SignupResetSentScreen({super.key, required this.controller});

  final SignupController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Center(
                child: AssetImageOrIcon(
                  key: Key('signup_reset_sent_image'),
                  assetPath: SignupRules.resetSentImage,
                  fallbackIcon: Icons.mark_email_unread,
                  size: SignupRules.heroImageSize,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                SignupRules.resetSentHeader,
                key: const Key('signup_reset_sent_header_text'),
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                SignupRules.resetSentMessage,
                key: Key('signup_reset_sent_message_text'),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              FilledButton(
                key: const Key('signup_back_to_login_button'),
                onPressed: () => openSignInReplacingStack(context, controller),
                child: const Text(SignupRules.backToLoginText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ไป S-2 โหมดเข้าสู่ระบบ โดยล้างหน้าที่ซ้อนอยู่ทั้งหมด เหลือหน้าราก (S-1) ไว้ใต้
// ASSUMPTION: 「กลับสู่หน้าเข้าสู่ระบบ」 (S-4) และบันทึกรหัสผ่านใหม่สำเร็จ (S-5) → S-2
// โหมดเข้าสู่ระบบเสมอ ไม่ว่าก่อนหน้าเปิด S-2 โหมดใด
void openSignInReplacingStack(
    BuildContext context, SignupController controller) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(
      builder: (_) => SignupEmailScreen(
        controller: controller,
        mode: SignupEmailMode.signIn,
      ),
    ),
    (route) => route.isFirst,
  );
}
