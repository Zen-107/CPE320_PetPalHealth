import 'package:flutter/material.dart';

import '../../water/widgets/asset_image_or_icon.dart';
import '../signup_controller.dart';
import '../signup_rules.dart';
import '../widgets/signup_widgets.dart';
import 'signup_email_screen.dart';
import 'signup_gate.dart';

/// S-1 หน้าต้อนรับและเลือกวิธีเข้าสู่ระบบ (ux-flow §2 S-1, ui-spec §2.1)
class SignupWelcomeScreen extends StatefulWidget {
  const SignupWelcomeScreen({super.key, required this.controller});

  final SignupController controller;

  @override
  State<SignupWelcomeScreen> createState() => _SignupWelcomeScreenState();
}

class _SignupWelcomeScreenState extends State<SignupWelcomeScreen> {
  bool _googleLoading = false;

  /// US-2 / AC-2 / EC-1 — ไม่มี Google SDK: FakeAuthRepository จำลองการเข้าสู่ระบบ
  Future<void> _signInWithGoogle() async {
    if (_googleLoading) return;
    setState(() => _googleLoading = true);
    final outcome = await widget.controller.signInWithGoogle();
    if (!mounted) return;
    setState(() => _googleLoading = false);
    switch (outcome) {
      case GoogleAuthOutcome.success:
        // SignupGate เปลี่ยนหน้ารากเป็น S-6 หรือ S-7 เอง
        popToSignupRoot(context);
      case GoogleAuthOutcome.networkError:
        final retry = await showSignupNetworkErrorDialog(
          context,
          dialogKey: 'signup_google_error_dialog',
          retryKey: 'signup_google_retry_button',
        );
        if (retry && mounted) await _signInWithGoogle();
    }
  }

  void _openEmail(SignupEmailMode mode) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            SignupEmailScreen(controller: widget.controller, mode: mode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final busy = _googleLoading;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      const Center(
                        child: AssetImageOrIcon(
                          key: Key('signup_welcome_logo'),
                          assetPath: SignupRules.welcomeLogo,
                          fallbackIcon: Icons.pets,
                          size: SignupRules.heroImageSize,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        SignupRules.appTitle,
                        key: const Key('signup_welcome_title_text'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        SignupRules.welcomeTagline,
                        key: const Key('signup_welcome_tagline_text'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        key: const Key('signup_google_button'),
                        onPressed: busy ? null : _signInWithGoogle,
                        // ASSUMPTION: ui-spec Q-17 — ยังไม่มีไฟล์โลโก้ Google ใช้ Icons.login
                        icon: _googleLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  key: Key('signup_google_loading_indicator'),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.login, size: 24),
                        label: const Text(SignupRules.googleButtonText),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              SignupRules.orText,
                              key: const Key('signup_or_text'),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        key: const Key('signup_email_signup_button'),
                        onPressed: busy
                            ? null
                            : () => _openEmail(SignupEmailMode.signUp),
                        icon: const Icon(Icons.email, size: 24),
                        label: const Text(SignupRules.emailSignupButtonText),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        key: const Key('signup_have_account_link'),
                        onPressed: busy
                            ? null
                            : () => _openEmail(SignupEmailMode.signIn),
                        child: const Text(SignupRules.haveAccountLinkText),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
