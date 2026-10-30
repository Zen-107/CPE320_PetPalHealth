import 'package:flutter/material.dart';

import '../signup_controller.dart';
import '../signup_logic.dart';
import '../signup_rules.dart';
import '../widgets/signup_widgets.dart';
import 'signup_forgot_password_screen.dart';
import 'signup_gate.dart';

/// S-2 มี 2 โหมด (ui-spec Q-2)
enum SignupEmailMode { signUp, signIn }

/// S-2 หน้าสมัครสมาชิก / เข้าสู่ระบบด้วยอีเมล (ux-flow §2 S-2, ui-spec §2.2)
class SignupEmailScreen extends StatefulWidget {
  const SignupEmailScreen({
    super.key,
    required this.controller,
    this.mode = SignupEmailMode.signUp,
  });

  final SignupController controller;
  final SignupEmailMode mode;

  @override
  State<SignupEmailScreen> createState() => _SignupEmailScreenState();
}

class _SignupEmailScreenState extends State<SignupEmailScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _submitting = false;

  /// AC-2 / EC-5 — หายเมื่อแก้ข้อความในช่องอีเมล (ui-spec Q-4)
  bool _emailInUse = false;

  /// โหมดเข้าสู่ระบบ: อีเมล/รหัสผ่านไม่ตรง — หายเมื่อแก้ช่องใดช่องหนึ่ง
  bool _invalidCredentials = false;

  bool get _isSignUp => widget.mode == SignupEmailMode.signUp;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    if (_submitting || !SignupLogic.canSubmitCredentials(email, password)) {
      return;
    }
    setState(() => _submitting = true);
    final outcome = _isSignUp
        ? await widget.controller.signUpWithEmail(email, password)
        : await widget.controller.signInWithEmail(email, password);
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _emailInUse = outcome == EmailAuthOutcome.emailInUse;
      _invalidCredentials = outcome == EmailAuthOutcome.invalidCredentials;
    });
    switch (outcome) {
      case EmailAuthOutcome.success:
        // สมัครสำเร็จ → S-6 (ux-flow §3 ข้อ 4); เข้าสู่ระบบ → S-6/S-7 ตามโปรไฟล์ (Q-21)
        popToSignupRoot(context);
      case EmailAuthOutcome.networkError:
        // ASSUMPTION: ux-flow ไม่มีสถานะเน็ตหลุดของ S-2 — ใช้ dialog เดียวกับ EC-1/EC-4
        final retry = await showSignupNetworkErrorDialog(
          context,
          dialogKey: 'signup_email_error_dialog',
          retryKey: 'signup_email_retry_button',
        );
        if (retry && mounted) await _submit();
      case EmailAuthOutcome.emailInUse:
      case EmailAuthOutcome.invalidCredentials:
        break;
    }
  }

  void _openForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            SignupForgotPasswordScreen(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = _emailController.text;
    final password = _passwordController.text;
    final canSubmit =
        !_submitting && SignupLogic.canSubmitCredentials(email, password);

    Widget? passwordError;
    if (SignupLogic.showsPasswordError(password)) {
      passwordError = const Text(
        SignupRules.passwordTooShortError,
        key: Key('signup_password_error_text'),
      );
    } else if (_invalidCredentials) {
      passwordError = const Text(
        SignupRules.invalidCredentialsError,
        key: Key('signup_login_error_text'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('signup_email_back_button'),
          icon: const Icon(Icons.arrow_back),
          tooltip: SignupRules.backButtonText,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          _isSignUp ? SignupRules.signupHeader : SignupRules.loginHeader,
          key: const Key('signup_email_header_text'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('signup_email_field'),
                controller: _emailController,
                enabled: !_submitting,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                onChanged: (_) => setState(() {
                  _emailInUse = false;
                  _invalidCredentials = false;
                }),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.emailHint,
                  error: _isSignUp && _emailInUse
                      ? const Text(
                          SignupRules.emailInUseError,
                          key: Key('signup_email_duplicate_error_text'),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('signup_password_field'),
                controller: _passwordController,
                enabled: !_submitting,
                obscureText: true,
                onChanged: (_) => setState(() => _invalidCredentials = false),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: SignupRules.passwordHint,
                  error: passwordError,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('signup_submit_button'),
                onPressed: canSubmit ? _submit : null,
                child: SignupButtonLabel(
                  text: _isSignUp
                      ? SignupRules.signupSubmitText
                      : SignupRules.loginSubmitText,
                  loading: _submitting,
                  indicatorKey: 'signup_submit_loading_indicator',
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  key: const Key('signup_forgot_password_link'),
                  onPressed: _submitting ? null : _openForgotPassword,
                  child: const Text(SignupRules.forgotPasswordLinkText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
