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
