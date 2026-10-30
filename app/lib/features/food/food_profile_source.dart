/// แหล่งโปรไฟล์สุขภาพของ food — ใช้โปรไฟล์ของ signup (UserProfile / AuthRepository)
///
/// Q-13 — DECIDED (owner ชั่วคราว, รอทีมยืนยัน): ใช้โปรไฟล์จาก signup S-6 ถ้ามีอยู่แล้ว
/// ไม่ต้องแสดง S-3 · แสดง S-3 เฉพาะตอนยังไม่มีโปรไฟล์ · S-3 บันทึกกลับเข้าโปรไฟล์ของ signup
/// (ไม่สร้างระบบโปรไฟล์ใหม่)
library;

import '../signup/signup_controller.dart';
import '../signup/signup_models.dart';
import '../signup/signup_rules.dart';

/// ค่าจากฟอร์ม S-3 ที่ผ่านการตรวจแล้ว
class FoodProfileInput {
  const FoodProfileInput({
    required this.age,
    required this.gender,
    required this.weightKg,
    required this.heightCm,
  });

  final int age;
  final SignupGender gender;
  final double weightKg;
  final double heightCm;
}

abstract class FoodProfileSource {
  /// โปรไฟล์ปัจจุบัน — null = ยังไม่มีโปรไฟล์
  Future<UserProfile?> load();

  /// บันทึกค่าจาก S-3 — คืนโปรไฟล์ที่บันทึกแล้ว หรือ null ถ้าไม่สำเร็จ
  Future<UserProfile?> save(FoodProfileInput input);
}

/// โปรไฟล์จาก [SignupController] (session ที่เข้าสู่ระบบอยู่) — ใช้ในแอปจริง
class SignupFoodProfileSource implements FoodProfileSource {
  SignupFoodProfileSource(this._signup);

  final SignupController _signup;

  @override
  Future<UserProfile?> load() async {
    if (!_signup.isLoaded) await _signup.load();
    return _signup.session?.profile;
  }

  @override
  Future<UserProfile?> save(FoodProfileInput input) async {
    final existing = _signup.session?.profile;
    // คงชื่อที่แสดง / เป้าหมายสุขภาพเดิมของ signup — food แก้เฉพาะอายุ เพศ น้ำหนัก ส่วนสูง
    final outcome = await _signup.saveProfile(
      displayName: existing == null || existing.displayNameFromEmail
          ? ''
          : existing.displayName,
      age: input.age.toString(),
      gender: input.gender,
      weight: input.weightKg.toString(),
      height: input.heightCm.toString(),
      healthGoal: existing?.healthGoal ?? SignupRules.defaultHealthGoal,
    );
    if (outcome != SaveProfileOutcome.success) return null;
    return _signup.session?.profile;
  }
}

/// โปรไฟล์ในหน่วยความจำ — ใช้ในเทสต์ และเมื่อแอปไม่มี signup (PetPalApp ไม่มี signupController)
///
/// สำหรับ QA: [profile] ค่าเริ่มต้น (null = ยังไม่มีโปรไฟล์ → S-3), [failSave] = true →
/// บันทึกไม่สำเร็จ, [latency] หน่วงทุกการเรียก
// ASSUMPTION: กรณีไม่มี signup (โหมดเดิมของเทสต์ water/steps) โปรไฟล์ไม่ถูกเก็บลงเครื่อง
// — แอปจริงผ่าน SignupGate เสมอจึงใช้ SignupFoodProfileSource
class InMemoryFoodProfileSource implements FoodProfileSource {
  InMemoryFoodProfileSource({
    this.profile,
    this.failSave = false,
    this.latency = Duration.zero,
  });

  UserProfile? profile;
  bool failSave;
  Duration latency;
  int saveCount = 0;

  @override
  Future<UserProfile?> load() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    return profile;
  }

  @override
  Future<UserProfile?> save(FoodProfileInput input) async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    if (failSave) return null;
    saveCount++;
    final existing = profile;
    return profile = UserProfile(
      displayName: existing?.displayName ?? '',
      displayNameFromEmail: existing?.displayNameFromEmail ?? false,
      age: input.age,
      gender: input.gender,
      weightKg: input.weightKg,
      heightCm: input.heightCm,
      healthGoal: existing?.healthGoal ?? SignupRules.defaultHealthGoal,
    );
  }
}
