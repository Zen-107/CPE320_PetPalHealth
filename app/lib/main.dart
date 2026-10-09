import 'package:flutter/material.dart';

import 'features/water/screens/water_home_screen.dart';
import 'features/water/water_controller.dart';
import 'features/water/water_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    PetPalApp(
      waterController: WaterController(
        repository: SharedPrefsWaterRepository(),
      ),
    ),
  );
}

class PetPalApp extends StatelessWidget {
  const PetPalApp({super.key, required this.waterController});

  final WaterController waterController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetPal Health',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: WaterHomeScreen(controller: waterController),
    );
  }
}
