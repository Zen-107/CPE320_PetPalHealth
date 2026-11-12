/// โมเดลของฟีเจอร์เสียงพากย์ (voice) — ui-spec §2.4 (immutable)
library;

import 'dart:convert';

import 'voice_rules.dart';

/// `voice_permission_status` (game-rules §1.2) — ไม่มีคีย์ = [unanswered]
enum VoicePermissionStatus { on, off, unanswered }

/// เรื่องที่ประเมินเสียง — **ลำดับ enum = ลำดับเข้าคิว** เมื่อหลายเรื่องเข้าช่วงใหม่พร้อมกัน
// ASSUMPTION: voice ui-spec Q-10 — water → steps → food (ตัวอย่าง game-rules §3 "น้ำก่อนก้าว")
enum VoiceTopic { water, steps, food }

/// บทพูด 6 บท (game-rules §1.1) — `id` = ชื่อไฟล์ในเอกสารโดยไม่มี `.mp3`
// DECIDED (owner 2026-11-12, V-6): ไม่มีไฟล์ mp3 — ชื่อไฟล์ใช้เป็น id ของบทพูดเท่านั้น
enum VoiceLine {
  /// AC-2
  stepsLazy('voice_steps_lazy', VoiceTopic.steps, VoiceRules.stepsLazyText),

  /// AC-3
  stepsEncouraging('voice_steps_encouraging', VoiceTopic.steps,
      VoiceRules.stepsEncouragingText),

  /// AC-4
  stepsSuccess(
      'voice_steps_success', VoiceTopic.steps, VoiceRules.stepsSuccessText),

  /// AC-5
  foodOvereating('voice_food_overeating', VoiceTopic.food,
      VoiceRules.foodOvereatingText),

  /// AC-6
  waterLow('voice_water_low', VoiceTopic.water, VoiceRules.waterLowText),

  /// AC-7
  waterSuccess(
      'voice_water_success', VoiceTopic.water, VoiceRules.waterSuccessText);

  const VoiceLine(this.id, this.topic, this.text);

  final String id;
  final VoiceTopic topic;

  /// ข้อความเดียวกันทั้งฟองบนจอและส่งให้ TTS (ui-spec §2.4.2)
  final String text;
}

/// ช่วงล่าสุดของแต่ละเรื่องในรอบวันหนึ่ง (V-4) — เก็บที่ `voice_day_bands`
///
/// ค่าของ map = `VoiceLine.id` หรือ [VoiceRules.noLineBandCode] (`'NONE'`)
/// เรื่องที่ยังไม่ประเมินในวันนี้ = ไม่มีใน map
class VoiceDayBands {
  VoiceDayBands({required DateTime day, Map<VoiceTopic, String> bands = const {}})
      : day = DateTime(day.year, day.month, day.day),
        bands = Map.unmodifiable(bands);

  /// รอบวัน (WaterLogic.logicalDay — ปี/เดือน/วัน)
  final DateTime day;
  final Map<VoiceTopic, String> bands;

  String toJsonString() => jsonEncode({
        'day': _formatDay(day),
        for (final e in bands.entries) e.key.name: e.value,
      });

  /// อ่านไม่ได้ → null (ASSUMPTION: voice ui-spec Q-09)
  static VoiceDayBands? fromJsonString(String? raw) {
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw);
      if (json is! Map) return null;
      final dayRaw = json['day'];
      if (dayRaw is! String) return null;
      final day = DateTime.tryParse(dayRaw);
      if (day == null) return null;
      final bands = <VoiceTopic, String>{};
      for (final topic in VoiceTopic.values) {
        final v = json[topic.name];
        if (v is String) bands[topic] = v;
      }
      return VoiceDayBands(day: day, bands: bands);
    } catch (_) {
      return null;
    }
  }

  static String _formatDay(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  @override
  bool operator ==(Object other) =>
      other is VoiceDayBands &&
      other.day == day &&
      other.bands.length == bands.length &&
      bands.entries.every((e) => other.bands[e.key] == e.value);

  @override
  int get hashCode => Object.hash(
        day,
        Object.hashAllUnordered(
            bands.entries.map((e) => Object.hash(e.key, e.value))),
      );

  @override
  String toString() => 'VoiceDayBands(${_formatDay(day)}, $bands)';
}

/// สถานะที่ฟีเจอร์เสียงเก็บเองในเครื่อง (game-rules §1.2 + `voice_day_bands`)
class VoiceState {
  const VoiceState({
    this.permissionStatus = VoicePermissionStatus.unanswered,
    this.masterVoice = false,
    this.dayBands,
  });

  /// ux-flow §4 S-1 ERROR / ไม่มีคีย์ = ค่านี้
  static const VoiceState initial = VoiceState();

  final VoicePermissionStatus permissionStatus;
  final bool masterVoice;
  final VoiceDayBands? dayBands;

  VoiceState copyWith({
    VoicePermissionStatus? permissionStatus,
    bool? masterVoice,
    VoiceDayBands? dayBands,
  }) =>
      VoiceState(
        permissionStatus: permissionStatus ?? this.permissionStatus,
        masterVoice: masterVoice ?? this.masterVoice,
        dayBands: dayBands ?? this.dayBands,
      );
}

/// ผลการประเมินหนึ่งครั้ง (ui-spec §2.4.3)
class VoiceEvaluation {
  const VoiceEvaluation({required this.bands, required this.lines});

  /// ช่วงล่าสุดของวันหลังประเมิน (บันทึกเสมอแม้ปิดเสียง — Q-08)
  final VoiceDayBands bands;

  /// บทที่ควรพูด เรียงตาม [VoiceTopic] (ว่าง = ไม่มีเรื่องใดเข้าช่วงใหม่ที่มีบท)
  final List<VoiceLine> lines;
}
