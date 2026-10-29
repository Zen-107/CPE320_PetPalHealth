import 'package:flutter/material.dart';

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
    ),
  );
}

class PetPalApp extends StatelessWidget {
  const PetPalApp({
    super.key,
    required this.waterController,
    this.stepsController,
  });

  final WaterController waterController;

  /// null = หน้า water สร้าง StepsController เองเมื่อกดเข้า steps ครั้งแรก
  final StepsController? stepsController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetPal Health',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: WaterHomeScreen(
        controller: waterController,
        stepsController: stepsController,
      ),
    );
  }
}
