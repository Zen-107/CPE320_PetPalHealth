import 'package:flutter/material.dart';

import '../signup_controller.dart';
import '../signup_rules.dart';
import '../widgets/signup_widgets.dart';
import 'signup_reset_sent_screen.dart';

/// S-3 หน้าลืมรหัสผ่าน (ux-flow §2 S-3, ui-spec §2.3)
class SignupForgotPasswordScreen extends StatefulWidget {
  const SignupForgotPasswordScreen({super.key, required this.controller});

  final SignupController controller;

  @override
  State<SignupForgotPasswordScreen> createState() =>
      _SignupForgotPasswordScreenState();
}

class _SignupForgotPasswordScreenState
    extends State<SignupForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // ASSUMPTION: ui-spec Q-7 — ปุ่มกดได้เสมอ (รวมช่องว่าง) และไม่มีสถานะ error;
  // FakeAuthRepository ตอบสำเร็จเสมอแล้วไป S-4
  Future<void> _submit() async {
    if (_sending) return;
    setState(() => _sending = true);
    try {
      await widget.controller.requestPasswordReset(_emailController.text);
    } catch (_) {
      // ไม่มีหน้าตา error ใน ux-flow — ไปต่อที่ S-4 เหมือนสำเร็จ
    }
    if (!mounted) return;
    setState(() => _sending = false);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SignupResetSentScreen(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('signup_forgot_back_button'),
          icon: const Icon(Icons.arrow_back),
          tooltip: SignupRules.backButtonText,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          SignupRules.forgotHeader,
          key: Key('signup_forgot_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                SignupRules.forgotDescription,
                key: Key('signup_forgot_description_text'),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_forgot_email_field'),
                controller: _emailController,
                enabled: !_sending,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: SignupRules.emailHint,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('signup_forgot_submit_button'),
                onPressed: _sending ? null : _submit,
                child: SignupButtonLabel(
                  text: SignupRules.forgotSubmitText,
                  loading: _sending,
                  indicatorKey: 'signup_forgot_loading_indicator',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
