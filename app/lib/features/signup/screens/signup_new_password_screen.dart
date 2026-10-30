import 'package:flutter/material.dart';

import '../signup_controller.dart';
import '../signup_logic.dart';
import '../signup_rules.dart';
import '../widgets/signup_widgets.dart';
import 'signup_reset_sent_screen.dart';

/// S-5 หน้าตั้งค่ารหัสผ่านใหม่ (ux-flow §2 S-5, ui-spec §2.5, AC-3)
///
/// ASSUMPTION: ui-spec Q-7 — ทางเข้า S-5 (ลิงก์จากอีเมล / deep link) ยังไม่กำหนด
/// MVP ไม่มีอีเมลจริง จึงไม่มีปุ่มใดในแอปเปิดหน้านี้ — เปิดด้วย [SignupNewPasswordScreen.route]
class SignupNewPasswordScreen extends StatefulWidget {
  const SignupNewPasswordScreen({
    super.key,
    required this.controller,
    required this.email,
  });

  final SignupController controller;

  /// อีเมลของบัญชีที่ขอรีเซ็ต (มาจากลิงก์รีเซ็ต)
  final String email;

  static Route<void> route(SignupController controller, String email) =>
      MaterialPageRoute<void>(
        builder: (_) =>
            SignupNewPasswordScreen(controller: controller, email: email),
      );

  @override
  State<SignupNewPasswordScreen> createState() =>
      _SignupNewPasswordScreenState();
}

class _SignupNewPasswordScreenState extends State<SignupNewPasswordScreen> {
  final _passwordController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final password = _passwordController.text;
    // AC-3: รหัสผ่านสั้นกว่า min_password_length → ปฏิเสธการบันทึก
    if (_saving || !SignupLogic.isPasswordLongEnough(password)) return;
    setState(() => _saving = true);
    final ok = await widget.controller.resetPassword(widget.email, password);
    if (!mounted) return;
    setState(() => _saving = false);
    // ASSUMPTION: ux-flow ไม่มีสถานะบันทึกไม่สำเร็จของ S-5 — คงอยู่หน้าเดิมให้กดใหม่
    if (!ok) return;
    final messenger = ScaffoldMessenger.of(context);
    openSignInReplacingStack(context, widget.controller);
    showSignupToast(
      messenger,
      'signup_password_reset_success_toast',
      SignupRules.passwordResetSuccessMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final password = _passwordController.text;
    final canSave = !_saving && SignupLogic.isPasswordLongEnough(password);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          SignupRules.newPasswordHeader,
          key: Key('signup_new_password_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('signup_new_password_field'),
                controller: _passwordController,
                enabled: !_saving,
                obscureText: true,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.newPasswordHint,
                  error: SignupLogic.showsPasswordError(password)
                      ? const Text(
                          SignupRules.newPasswordTooShortError,
                          key: Key('signup_new_password_error_text'),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('signup_new_password_save_button'),
                onPressed: canSave ? _save : null,
                child: SignupButtonLabel(
                  text: SignupRules.newPasswordSaveText,
                  loading: _saving,
                  indicatorKey: 'signup_new_password_loading_indicator',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
