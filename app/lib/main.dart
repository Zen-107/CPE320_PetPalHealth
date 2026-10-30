import 'package:flutter/material.dart';

import 'features/signup/screens/signup_gate.dart';
import 'features/signup/signup_controller.dart';
import 'features/signup/signup_repository.dart';
import 'features/steps/steps_controller.dart';
import 'features/steps/steps_external.dart';
import 'features/steps/steps_repository.dart';
import 'features/water/screens/water_home_screen.dart';
import 'features/water/water_controller.dart';
import 'features/water/water_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final waterController = WaterController(
    repository: SharedPrefsWaterRepository(),
  );
  runApp(
    PetPalApp(
      waterController: waterController,
      stepsController: StepsController(
        repository: SharedPrefsStepsRepository(),
        // AC-7 น้ำดื่มรวม: อ่านจากข้อมูลของ water ตัวเดียวกับที่แอปใช้ (อ่านอย่างเดียว)
        waterHistory: ControllerWaterHistorySource(waterController),
        exporter: FileStepsReportExporter(),
      ),
      // signup: เปิดแอป → อ่าน Token → S-1 หรือ S-7 (docs/signup/ux-flow.md §3, AC-8)
      // DECIDED (owner): ยังไม่มี backend — auth จำลองในเครื่องด้วย FakeAuthRepository
      // + shared_preferences (ไม่มี network)
      signupController: SignupController(
        repository: FakeAuthRepository(store: SharedPrefsAuthLocalStore()),
      ),
    ),
  );
}

class PetPalApp extends StatelessWidget {
  const PetPalApp({
    super.key,
    required this.waterController,
    this.stepsController,
    this.signupController,
  });

  final WaterController waterController;

  /// null = หน้า water สร้าง StepsController เองเมื่อกดเข้า steps ครั้งแรก
  final StepsController? stepsController;

  /// null = เข้าหน้า home (water) ตรง ๆ ไม่ผ่าน signup (พฤติกรรมเดิม — เทสต์ water/steps)
  final SignupController? signupController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetPal Health',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: signupController == null
          ? _home(null)
          : SignupGate(
              controller: signupController!,
              homeBuilder: (context, welcomeName) => _home(welcomeName),
            ),
    );
  }

  /// S-7 ของ signup = WaterHomeScreen เดิม + แบนเนอร์ต้อนรับ (signup ui-spec D-2)
  Widget _home(String? welcomeName) {
    return WaterHomeScreen(
      controller: waterController,
      stepsController: stepsController,
      welcomeName: welcomeName,
    );
  }
}
