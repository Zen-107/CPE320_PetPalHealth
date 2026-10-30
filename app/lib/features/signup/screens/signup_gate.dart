import 'package:flutter/material.dart';

import '../signup_controller.dart';
import '../signup_logic.dart';
import 'signup_onboarding_screen.dart';
import 'signup_welcome_screen.dart';

/// สร้างหน้า S-7 (Home) — [welcomeName] = Display Name ที่ประมวลผลแล้ว (AC-5)
typedef SignupHomeBuilder = Widget Function(
    BuildContext context, String? welcomeName);

/// จุดเริ่มของแอป: อ่าน Token แล้วเลือก S-1 / S-6 / S-7 (ui-spec §2.0, AC-8)
///
/// หน้าราก (root route) เปลี่ยนตาม [SignupController.route]; หน้าที่ push ซ้อน
/// (S-2…S-5) เมื่อเข้าสู่ระบบสำเร็จจะ pop กลับมาที่รากเอง
class SignupGate extends StatefulWidget {
  const SignupGate({
    super.key,
    required this.controller,
    required this.homeBuilder,
  });

  final SignupController controller;
  final SignupHomeBuilder homeBuilder;

  @override
  State<SignupGate> createState() => _SignupGateState();
}

class _SignupGateState extends State<SignupGate> {
  @override
  void initState() {
    super.initState();
    if (!widget.controller.isLoaded) widget.controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        switch (widget.controller.route) {
          case SignupRoute.loading:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  key: Key('signup_auth_loading'),
                ),
              ),
            );
          case SignupRoute.welcome:
            return SignupWelcomeScreen(controller: widget.controller);
          case SignupRoute.onboarding:
            return SignupOnboardingScreen(controller: widget.controller);
          case SignupRoute.home:
            return widget.homeBuilder(
                context, widget.controller.homeDisplayName);
        }
      },
    );
  }
}

/// กลับไปหน้าราก (ให้ SignupGate แสดงปลายทางใหม่) หลังเข้าสู่ระบบ/บันทึกสำเร็จ
void popToSignupRoot(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}
