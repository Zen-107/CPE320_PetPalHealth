// ตัวช่วยร่วมของเทสต์ food (ไม่ใช่ไฟล์เทสต์ — ไม่มี main)
// ค่าคาดหวังทั้งหมดในเทสต์มาจาก docs/food/requirements.md, game-rules.md, ux-flow.md,
// ui-spec.md และข้อตัดสิน owner (DECIDED ชั่วคราว) — ไม่ได้ลอกจากโค้ด
import 'dart:async';

import 'package:petpal_health/features/signup/signup_models.dart';

/// วันที่/เวลาที่ควบคุมได้ (ไม่มีเวลาจริง)
DateTime t(int day, int h, [int m = 0, int s = 0, int ms = 0]) =>
    DateTime(2026, 10, day, h, m, s, ms);
DateTime d(int day) => DateTime(2026, 10, day);

/// คั่นหลักพันแบบตัวอย่างใน game-rules §3 ("1,900") — เขียนเองในเทสต์ ไม่เรียกโค้ด Dev
String fmt(int n) {
  final s = n.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return b.toString();
}

/// `[total_calories] / [target_calories] kcal` (ux-flow §2 S-1)
String calText(int total, int target) => '${fmt(total)} / ${fmt(target)} kcal';

// ---- ค่าจากเอกสาร (game-rules §1 / requirements §3) ----
const int docAiTimeoutSeconds = 3;
const int docResetHour = 5;
const int docAgeMin = 1;
const int docAgeMax = 120;
const int docOverLimitThreshold = 100;
const int docFallbackCalories = 300;
const int docEatingSeconds = 2;
const int docToastSeconds = 5;
const double docToastAnchor = 12;
/// ประวัติ food เก็บ 30 วัน "นับรวมวันนี้" (วันนี้ + 29 วันก่อนหน้า)
/// DECIDED (owner 7day รอบ 1 "food เก็บประวัติ 30 วัน" + รอบ 2 Q-19 เฉพาะ food + รอบ 3 สมมติฐาน dev
/// ข้อ 2 "30 วันนับรวมวันนี้") — เดิม 7 (food R2-Q4)
const int docHistoryDays = 30;
const double docBmiUnder = 18.5;
const double docBmiOver = 23.0;
const int docBmiBonus = 400;
const int docBmiPenalty = 400;

/// Base Target Reference Table (requirements §3) — (ageMin, ageMax, male, female)
const List<(int, int, int, int)> docBaseTable = [
  (10, 12, 1700, 1600),
  (13, 15, 2100, 1800),
  (16, 18, 2300, 1850),
  (19, 50, 2000, 1600),
  (51, 120, 1800, 1400),
];

// ---- ข้อความจาก ux-flow.md (ตรงตัว) ----
const addMealText = 'บันทึกมื้ออาหาร';
const ctaText = 'ตั้งค่าโปรไฟล์สุขภาพเพื่อรับเป้าหมายแคลอรี่ที่แม่นยำ';
const overLimitToast = 'พอเถอะน้าคนดี';
const fullBadgeText = 'อิ่มแล้ว';
const mealHint = 'พิมพ์เมนูอาหารที่คุณทานวันนี้ เช่น ข้าวมันไก่ 1 จาน...';
const manualHint = 'ระบุแคลอรี่ (kcal)';
const submitText = 'บันทึกข้อมูล';
const ageHint = 'ระบุอายุ (ปี)';
const weightHint = 'น้ำหนัก (kg)';
const heightHint = 'ส่วนสูง (cm)';
const skipText = 'ข้ามไปก่อน';
const saveProfileText = 'บันทึกและคำนวณเป้าหมาย';
const ageErrorText = 'กรุณากรอกอายุเป็นจำนวนเต็มระหว่าง 1 - 120 ปี';
const maleText = 'ชาย'; // ui-spec §2.3 (คำไทยจาก MALE (ชาย))
const femaleText = 'หญิง';

/// โปรไฟล์ (signup UserProfile) — ค่า default: ชาย 25 ปี 65 kg 175 cm
/// BMI = 65 / 1.75² = 21.2 (ปกติ) → เป้าหมาย 2,000 kcal (AC-5)
UserProfile profileOf({
  int age = 25,
  SignupGender gender = SignupGender.male,
  double? weightKg = 65,
  double? heightCm = 175,
}) =>
    UserProfile(
      displayName: 'ทดสอบ',
      displayNameFromEmail: false,
      age: age,
      gender: gender,
      weightKg: weightKg,
      heightCm: heightCm,
      healthGoal: 'ดูแลสุขภาพ',
    );

/// Timer ปลอมสำหรับ unit test — เวลาเดินเฉพาะเมื่อเรียก [advance]
class FakeTimers {
  Duration elapsed = Duration.zero;
  final List<FakeTimer> _timers = [];

  Timer create(Duration duration, void Function() callback) {
    final timer = FakeTimer._(elapsed + duration, callback);
    _timers.add(timer);
    return timer;
  }

  void advance(Duration duration) {
    final target = elapsed + duration;
    while (true) {
      final due = _timers
          .where((x) => x.isActive && x.due <= target)
          .toList()
        ..sort((a, b) => a.due.compareTo(b.due));
      if (due.isEmpty) break;
      elapsed = due.first.due;
      due.first._fire();
    }
    elapsed = target;
  }

  int get activeCount => _timers.where((x) => x.isActive).length;
}

class FakeTimer implements Timer {
  FakeTimer._(this.due, this._callback);

  final Duration due;
  final void Function() _callback;
  bool _active = true;

  void _fire() {
    _active = false;
    _callback();
  }

  @override
  void cancel() => _active = false;

  @override
  bool get isActive => _active;

  @override
  int get tick => 0;
}
