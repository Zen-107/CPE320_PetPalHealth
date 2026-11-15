/// abstraction ของ TTS (ui-spec §2.4.5) — controller รู้จักแค่ interface นี้ จึง fake ได้ในเทสต์
/// (`flutter_tts` ไม่ทำงานใน `flutter test`)
library;

abstract interface class VoiceTtsEngine {
  /// ตั้งภาษา / pitch / volume — คืน false ถ้าเครื่องไม่มีเสียง th-TH หรือ engine ใช้ไม่ได้ (V-6a)
  Future<bool> prepare();

  /// พูดข้อความ — Future จบเมื่อพูดเสร็จ (หรือถูก stop) · throw เมื่อ engine error
  Future<void> speak(String text);

  /// หยุดเสียงที่กำลังพูดทันที
  Future<void> stop();
}

/// engine ที่บอกได้ว่าเสียง "เริ่มออกลำโพงจริง" เมื่อไร — เครื่องสังเคราะห์เสียงใช้เวลาเตรียม
/// หลัง speak() (วัดบน emulator ได้ 5–6 วินาที) controller จึงรอสัญญาณนี้ก่อนแสดงฟองบทพูด
/// ให้ข้อความขึ้นพร้อมเสียง · engine ที่ไม่ implement = แสดงฟองทันทีที่สั่งพูด (พฤติกรรมเดิม)
abstract interface class VoiceSpeakStartAware {
  /// เรียกทุกครั้งที่เสียงของบทที่สั่ง speak() เริ่มเล่น · null = ไม่ต้องแจ้ง
  set onSpeakStart(void Function()? callback);
}

/// engine ที่ "อุ่นเครื่อง" ได้ — บทแรกหลังต่อ TTS ต้องโหลดโมเดลเสียงก่อน (วัดบน emulator:
/// บทแรกเริ่มช้า 3.5–6.6 วินาที บทถัดไป 0.06 วินาที) controller เรียก [prime] ต่อจาก prepare()
/// ที่ได้ true เพื่อจ่ายค่าโหลดนี้ล่วงหน้าแบบไม่มีเสียง
abstract interface class VoiceEnginePrimer {
  /// พูดคำสั้น ๆ แบบเงียบ (volume 0) จนจบ — ห้าม throw ออกมา
  Future<void> prime();
}

/// แพลตฟอร์มที่ไม่มี TTS (เช่น windows) — ไม่มีเสียง ไม่มีฟอง
// ASSUMPTION: voice ui-spec Q-31
class NoopVoiceTtsEngine implements VoiceTtsEngine {
  const NoopVoiceTtsEngine();

  @override
  Future<bool> prepare() async => false;

  @override
  Future<void> speak(String text) async {}

  @override
  Future<void> stop() async {}
}
