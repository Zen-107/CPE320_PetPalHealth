/// นโยบายเปิด/ปิด animation ของสัตว์เลี้ยง (PetCharacter) ระดับแอป
library;

import 'dart:io' show Platform;

/// ค่าเริ่มต้นของ `animate` ที่หน้าจอส่งให้ `PetCharacter`
///
/// PetCharacter ที่ animate จะ "หายใจ" ตลอดเวลา (AnimationController แบบ repeat)
/// ทำให้ `tester.pumpAndSettle()` ในเทสต์หน้าจอเดิมไม่มีวันจบ
// ASSUMPTION: ระหว่าง `flutter test` (flutter_tools ตั้ง env FLUTTER_TEST=true)
// ใช้ภาพนิ่ง (animate: false) เพื่อให้เทสต์หน้าจอเดิมที่ใช้ pumpAndSettle ทำงานได้
// ตอนรันแอปจริงจะ animate เสมอ — หน้าจอรับพารามิเตอร์ `animatePet` เพื่อบังคับค่าได้
// (เทสต์ที่ต้องการดู animation/cheer ส่ง animatePet: true แล้วใช้ pump(duration))
final bool kPetAnimateByDefault = !_isFlutterTest();

bool _isFlutterTest() {
  try {
    return Platform.environment.containsKey('FLUTTER_TEST');
  } catch (_) {
    // แพลตฟอร์มที่ไม่มี dart:io (เช่น web) → ไม่ใช่สภาพแวดล้อมเทสต์ของ flutter_tools
    return false;
  }
}
