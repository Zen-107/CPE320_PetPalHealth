import 'dart:async';

import 'package:flutter/foundation.dart';

import '../dashboard/dashboard_models.dart';
import 'voice_logic.dart';
import 'voice_models.dart';
import 'voice_repository.dart';
import 'voice_rules.dart';
import 'voice_tts_engine.dart';

/// สร้าง Timer ของ debounce — inject ตัวปลอมในเทสต์ที่ไม่ใช่ widget test ได้
/// (แบบ DashboardTimerFactory)
typedef VoiceTimerFactory = Timer Function(
  Duration duration,
  void Function() callback,
);

Timer _defaultTimer(Duration d, void Function() cb) => Timer(d, cb);

/// สถานะ + คิวเสียงพากย์ของน้องอ๊บ — ui-spec §2.4.4
///
/// - S-1: [permissionStatus] / [answerPermission] (AC-1)
/// - S-2: [evaluate] จาก dashboard → คิว FIFO เล่นทีละบท ([currentLine] = ฟองบทพูด) (AC-2..AC-7, EC-2)
/// - S-3: [masterVoice] / [setMasterVoice] พร้อม debounce 300 ms (AC-8, EC-5)
///
/// ไม่ต่อเน็ต — เสียงมาจาก [VoiceTtsEngine] ในเครื่อง (DECIDED owner 2026-11-12, V-6, V-6a)
class VoiceController extends ChangeNotifier {
  VoiceController({
    required this.repository,
    required this.engine,
    DateTime Function()? clock,
    VoiceTimerFactory? timerFactory,
  })  : _clock = clock ?? DateTime.now,
        _timer = timerFactory ?? _defaultTimer;

  final VoiceRepository repository;
  final VoiceTtsEngine engine;
  final DateTime Function() _clock;
  final VoiceTimerFactory _timer;

  bool _loaded = false;
  Future<void>? _loadFuture;
  bool _disposed = false;

  VoicePermissionStatus _permission = VoicePermissionStatus.unanswered;
  bool _master = false;

  /// ค่าที่บันทึกลงเครื่องแล้ว — ใช้ตัดสินว่าต้องบันทึกไหม และค่าที่ย้อนกลับเมื่อบันทึกไม่สำเร็จ
  bool _committedMaster = false;
  VoiceDayBands? _dayBands;

  Timer? _debounce;
  int _saveFailureCount = 0;

  // คิวเสียง (EC-2 No Audio Overlap, Cooldown 0 ms)
  final List<VoiceLine> _queue = [];
  VoiceLine? _currentLine;
  bool _playing = false;

  /// รุ่นของลูปเล่น — stopAndClear() เพิ่มค่า กันลูปเก่าเคลียร์ currentLine ของบทใหม่
  int _generation = 0;

  /// engine.prepare() ที่กำลังทำ / ทำเสร็จแล้ว — กันเรียกซ้อน (ทุกจุดรอ Future ตัวเดียวกัน)
  Future<bool>? _ready;

  /// ผลล่าสุดของ prepare(): null = ยังไม่รู้ / กำลังทำ, true = พร้อม (จำตลอด ไม่เรียกซ้ำ),
  /// false = ไม่พร้อม (จำไว้จนกว่า dashboard สั่ง [retryEngineIfUnavailable] — V-12)
  bool? _readyValue;

  /// input ล่าสุดจาก dashboard — ใช้ประเมินใหม่เมื่อ engine เพิ่งพร้อม (V-12)
  DashboardInput? _lastInput;

  bool get isLoaded => _loaded;
  VoicePermissionStatus get permissionStatus => _permission;

  /// ค่าที่สวิตช์แสดง (อัปเดตทันทีเมื่อกด)
  bool get masterVoice => _master;

  /// บทที่กำลังพูด → ฟองบน dashboard (null = ไม่มีฟอง)
  VoiceLine? get currentLine => _currentLine;

  /// บทที่รอ (ไม่รวม [currentLine])
  List<VoiceLine> get queue => List.unmodifiable(_queue);

  /// เพิ่มเมื่อบันทึกสวิตช์เสียงไม่สำเร็จ → SnackBar ของหน้าตั้งค่า
  int get saveFailureCount => _saveFailureCount;

  /// ช่วงล่าสุดของวัน (อ่านอย่างเดียว ให้เทสต์)
  VoiceDayBands? get dayBands => _dayBands;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // โหลด
  // ---------------------------------------------------------------------------

  /// เรียกซ้ำได้ โหลดครั้งเดียว · อ่านไม่ได้ → ค่าเริ่มต้น (ux-flow §4 S-1 ERROR → dialog แสดง)
  Future<void> load() => _loadFuture ??= _load();

  Future<void> _load() async {
    VoiceState s;
    try {
      s = await repository.load();
    } catch (_) {
      s = VoiceState.initial;
    }
    if (_disposed) return;
    _permission = s.permissionStatus;
    _master = s.masterVoice;
    _committedMaster = s.masterVoice;
    _dayBands = s.dayBands;
    _loaded = true;
    _notify();
  }

  // ---------------------------------------------------------------------------
  // S-1 (AC-1)
  // ---------------------------------------------------------------------------

  /// กดปุ่มใน dialog — บันทึกทันที (ไม่ debounce) · ไม่พูดอะไร (V-4)
  // ASSUMPTION: voice ui-spec Q-16 — บันทึกไม่สำเร็จ → ใช้ค่าในหน่วยความจำ ไม่มี UI ผิดพลาด
  Future<void> answerPermission({required bool enabled}) async {
    _debounce?.cancel();
    _debounce = null;
    _permission = enabled ? VoicePermissionStatus.on : VoicePermissionStatus.off;
    _master = enabled;
    _committedMaster = enabled;
    _notify();
    if (!enabled) unawaited(stopAndClear());
    try {
      await repository.savePermission(enabled: enabled);
    } catch (_) {
      // คงค่าในหน่วยความจำ
    }
  }

  // ---------------------------------------------------------------------------
  // S-3 สวิตช์เสียง (AC-8, EC-5)
  // ---------------------------------------------------------------------------

  /// สวิตช์ขยับทันทีทุกครั้ง · ปิด = หยุดเสียง + ล้างคิวทันที (game-rules §1.1)
  /// · เขียนลงเครื่องครั้งเดียวหลังนิ่ง 300 ms ด้วยค่าล่าสุด
  // ASSUMPTION: voice ui-spec Q-14 — "Debounce 300 ms และบันทึกทันที" = ค่าในหน่วยความจำเปลี่ยน
  // ทันที เขียน storage หลังนิ่ง 300 ms
  // DECIDED (owner 2026-11-12, V-3): debounce ใช้กับสวิตช์เสียงเท่านั้น
  void setMasterVoice(bool on) {
    if (_disposed || on == _master) return;
    _master = on;
    _notify();
    if (!on) unawaited(stopAndClear());
    _debounce?.cancel();
    _debounce = _timer(VoiceRules.toggleDebounce, () {
      _debounce = null;
      unawaited(_commitMaster());
    });
  }

  /// บันทึกค่าที่ค้าง debounce ทันที (ออกจากหน้าตั้งค่า / dispose)
  Future<void> flushPendingSave() async {
    if (_debounce == null) return;
    _debounce!.cancel();
    _debounce = null;
    await _commitMaster();
  }

  Future<void> _commitMaster() async {
    final value = _master;
    if (value == _committedMaster) return;
    final previous = _committedMaster;
    try {
      await repository.saveMasterVoice(value);
      _committedMaster = value;
    } catch (_) {
      if (_disposed) return;
      // ux-flow §4 S-3 ERROR: คงสถานะสวิตช์ไว้ที่ค่าเดิมก่อนกด + แจ้งให้ลองใหม่
      // (ถ้าผู้ใช้กดใหม่ระหว่างรอบันทึก ปล่อยให้ชุดการกดใหม่จัดการเอง)
      if (_debounce == null && _master == value) {
        _master = previous;
        if (!previous) unawaited(stopAndClear());
      }
      _saveFailureCount++;
      _notify();
    }
  }

  // ---------------------------------------------------------------------------
  // S-2 การประเมิน + คิวเสียง (AC-2..AC-7, EC-2, EC-3)
  // ---------------------------------------------------------------------------

  /// DECIDED (owner 2026-11-12, V-4): เรียกจาก dashboard ตอนเปิดหน้าและตอนค่าเปลี่ยน
  /// (เรียกซ้ำได้ — ช่วงเดิมไม่พูดซ้ำ)
  // ASSUMPTION: voice ui-spec Q-08 — บันทึกช่วงเสมอแม้ปิดเสียง (เปิดเสียงทีหลังไม่มีบทย้อน)
  ///
  /// DECIDED (owner 2026-11-12, V-11): engine ยังไม่พร้อม (ยังไม่รู้ผล / prepare() false) → ไม่บันทึก
  /// ช่วงที่มีบทพูดว่า "พูดแล้ว" — เก็บไว้พูดเมื่อ engine พร้อม · ปิดเสียงอยู่ → บันทึกช่วงทั้งหมด
  /// ตาม Q-08 (ไม่เรียก prepare())
  void evaluate(DashboardInput input) {
    if (!_loaded || _disposed) return;
    _lastInput = input;
    if (!_master) {
      _applyEvaluation(input, commitLineBands: true);
      return;
    }
    if (_readyValue == true) {
      _evaluateAndSpeak(input);
      return;
    }
    // ยังไม่พร้อม: บันทึกเฉพาะช่วงที่ไม่มีบทพูด แล้วรอผล prepare()
    _applyEvaluation(input, commitLineBands: false);
    final gen = _generation;
    unawaited(_ensureReady().then((ready) {
      // ออกจาก dashboard / แอปไป background / ปิดเสียง ระหว่างรอ prepare() → stopAndClear()
      // เพิ่ม generation แล้ว → ไม่พูด (บทยังไม่ถูกบันทึก จึงพูดได้เมื่อเข้า dashboard ครั้งหน้า)
      if (!ready || _disposed || gen != _generation || !_master) return;
      final latest = _lastInput;
      if (latest != null) _evaluateAndSpeak(latest);
    }));
  }

  /// DECIDED (owner 2026-11-12, V-12): prepare() ที่ได้ false ให้ลองใหม่ — dashboard เรียกตอนเข้าหน้า
  /// และตอนแอป resumed (ก่อน [evaluate]) · ได้ true แล้วไม่เรียกซ้ำ · กำลัง prepare อยู่ = ไม่ทำอะไร
  /// (รอผลรอบเดิม ไม่เรียกซ้อน)
  void retryEngineIfUnavailable() {
    if (_readyValue != false) return;
    _readyValue = null;
    _ready = null;
  }

  /// engine พร้อมแล้ว: ประเมิน + บันทึกช่วง + เข้าคิว (เรียกซ้ำได้ — ช่วงที่บันทึกแล้วไม่พูดซ้ำ)
  void _evaluateAndSpeak(DashboardInput input) {
    final lines = _applyEvaluation(input, commitLineBands: true);
    if (!_master || lines.isEmpty) return;
    _queue.addAll(lines); // FIFO ต่อท้ายคิว — ลำดับ water → steps → food (Q-10)
    unawaited(_runQueue());
  }

  List<VoiceLine> _applyEvaluation(
    DashboardInput input, {
    required bool commitLineBands,
  }) {
    final result = VoiceLogic.evaluate(
      input: input,
      previous: _dayBands,
      now: _clock(),
      commitLineBands: commitLineBands,
    );
    if (result.bands != _dayBands) {
      _dayBands = result.bands;
      unawaited(_saveBands(result.bands));
    }
    return result.lines;
  }

  /// prepare() ครั้งเดียวต่อรอบ — เรียกซ้อนได้ ทุกคนรอ Future เดียวกัน
  Future<bool> _ensureReady() {
    final ready = _ready ??= _prepare();
    return ready.then((value) {
      // ผลของรอบที่ถูกยกเลิกด้วย retryEngineIfUnavailable() ไม่ทับรอบใหม่
      if (identical(_ready, ready)) _readyValue = value;
      return value;
    });
  }

  // ASSUMPTION: voice ui-spec Q-09 — บันทึกไม่สำเร็จ = คงในหน่วยความจำ ไม่มี UI
  Future<void> _saveBands(VoiceDayBands bands) async {
    try {
      await repository.saveDayBands(bands);
    } catch (_) {}
  }

  Future<bool> _prepare() async {
    try {
      return await engine.prepare();
    } catch (_) {
      return false;
    }
  }

  Future<void> _runQueue() async {
    if (_playing) return;
    _playing = true;
    final gen = _generation;
    try {
      // ปกติถึงตรงนี้เมื่อ engine พร้อมแล้ว (_evaluateAndSpeak) — เช็กซ้ำเพื่อความปลอดภัย
      final ready = await _ensureReady();
      while (!_disposed &&
          gen == _generation &&
          _master &&
          _queue.isNotEmpty) {
        if (!ready) {
          // DECIDED (owner 2026-11-12, V-6a): ไม่มีเสียงไทย → ข้ามเงียบ
          // ASSUMPTION: voice ui-spec Q-11 — ไม่แสดงฟองเมื่อไม่มีเสียง
          _queue.clear();
          break;
        }
        final line = _queue.removeAt(0);
        _currentLine = line;
        _notify();
        try {
          await engine.speak(line.text).timeout(VoiceRules.speakTimeout);
        } on TimeoutException {
          // ASSUMPTION: voice ui-spec Q-12 — engine ไม่ส่ง completion → หยุดแล้วไปบทถัดไป
          await _safeStop();
        } catch (_) {
          // EC-3 (V-6a): TTS error → ข้ามบทนี้เงียบ ๆ
        }
        if (gen == _generation && _currentLine == line) {
          _currentLine = null;
          _notify();
        }
      }
    } finally {
      if (gen == _generation) _playing = false;
    }
  }

  Future<void> _safeStop() async {
    try {
      await engine.stop();
    } catch (_) {}
  }

  /// หยุดเสียงปัจจุบัน + ล้างคิว (ปิดเสียง / ออกจาก dashboard / แอปไป background — Q-13)
  Future<void> stopAndClear() async {
    _generation++;
    _playing = false;
    final changed = _currentLine != null || _queue.isNotEmpty;
    _queue.clear();
    _currentLine = null;
    if (changed) _notify();
    await _safeStop();
  }

  @override
  void dispose() {
    if (_debounce != null) {
      _debounce!.cancel();
      _debounce = null;
      unawaited(_commitMaster());
    }
    _disposed = true;
    _generation++;
    _queue.clear();
    _currentLine = null;
    unawaited(_safeStop());
    super.dispose();
  }
}
