import 'package:flutter/material.dart';

import 'features/food/food_controller.dart';
import 'features/food/food_profile_source.dart';
import 'features/food/food_repository.dart';
import 'features/notification/notification_avatar.dart';
import 'features/notification/notification_controller.dart';
import 'features/notification/notification_local_scheduler.dart';
import 'features/notification/notification_repository.dart';
import 'features/notification/notification_scheduler.dart';
import 'features/signup/screens/signup_gate.dart';
import 'features/signup/signup_controller.dart';
import 'features/signup/signup_repository.dart';
import 'features/steps/steps_controller.dart';
import 'features/steps/steps_external.dart';
import 'features/steps/steps_repository.dart';
import 'features/water/screens/water_home_screen.dart';
import 'features/water/water_controller.dart';
import 'features/water/water_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final waterController = WaterController(
    repository: SharedPrefsWaterRepository(),
  );
  // signup: เปิดแอป → อ่าน Token → S-1 หรือ S-7 (docs/signup/ux-flow.md §3, AC-8)
  // DECIDED (owner): ยังไม่มี backend — auth จำลองในเครื่องด้วย FakeAuthRepository
  // + shared_preferences (ไม่มี network)
  final signupController = SignupController(
    repository: FakeAuthRepository(store: SharedPrefsAuthLocalStore()),
  );
  final stepsController = StepsController(
    repository: SharedPrefsStepsRepository(),
    // AC-7 น้ำดื่มรวม: อ่านจากข้อมูลของ water ตัวเดียวกับที่แอปใช้ (อ่านอย่างเดียว)
    waterHistory: ControllerWaterHistorySource(waterController),
    exporter: FileStepsReportExporter(),
  );
  // food: Q-13 DECIDED (owner ชั่วคราว) ใช้โปรไฟล์ของ signup · Q-17 ตารางเมนูในเครื่อง
  final foodController = FoodController(
    repository: SharedPrefsFoodRepository(),
    profileSource: SignupFoodProfileSource(signupController),
  );
  // notification: DECIDED (owner 2026-11-08, D-5) flutter_local_notifications + timezone +
  // flutter_timezone ในเครื่องเท่านั้น · แพลตฟอร์มอื่น (เช่น windows) = Noop ไม่ตั้งเวลา
  final avatar = PainterNotificationAvatarSource();
  final NotificationScheduler scheduler =
      LocalNotificationScheduler.isSupportedPlatform
          ? LocalNotificationScheduler(avatar: avatar)
          : const NoopNotificationScheduler();
  final notificationController = NotificationController(
    repository: SharedPrefsNotificationRepository(),
    scheduler: scheduler,
    avatar: avatar,
    water: waterController,
    steps: stepsController,
    food: foodController,
  );
  try {
    // ไม่ขอสิทธิ์ตอน initialize (AC-3) · รับการกดตอน FOREGROUND / BACKGROUND
    await scheduler.initialize(
        onTap: notificationController.handleNotificationTap);
    // TERMINATED (EC-13): เปิดแอปจากแจ้งเตือน → เก็บปลายทางไว้ก่อน runApp
    notificationController
        .handleNotificationTap(await scheduler.launchPayload());
  } catch (_) {
    // ASSUMPTION: plugin เริ่มไม่สำเร็จ → แอปยังเปิดได้ (แจ้งเตือนอาจไม่ทำงาน ไม่มี UI ผิดพลาด)
  }
  // DECIDED (owner 2026-11-08, notification Q-28): ออกจากระบบ → ยกเลิกแจ้งเตือนทั้งหมด
  signupController.onSignedOut = notificationController.onSignedOut;
  runApp(
    PetPalApp(
      waterController: waterController,
      stepsController: stepsController,
      signupController: signupController,
      foodController: foodController,
      notificationController: notificationController,
    ),
  );
}

class PetPalApp extends StatelessWidget {
  const PetPalApp({
    super.key,
    required this.waterController,
    this.stepsController,
    this.signupController,
    this.foodController,
    this.notificationController,
  });

  final WaterController waterController;

  /// null = หน้า water สร้าง StepsController เองเมื่อกดเข้า steps ครั้งแรก
  final StepsController? stepsController;

  /// null = เข้าหน้า home (water) ตรง ๆ ไม่ผ่าน signup (พฤติกรรมเดิม — เทสต์ water/steps)
  final SignupController? signupController;

  /// null = หน้า water สร้าง FoodController เองเมื่อกดเข้า food ครั้งแรก
  final FoodController? foodController;

  /// null = ไม่มีฟีเจอร์แจ้งเตือน (พฤติกรรมเดิม — เทสต์เดิม)
  final NotificationController? notificationController;

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
      foodController: foodController,
      welcomeName: welcomeName,
      notificationController: notificationController,
    );
  }
}
