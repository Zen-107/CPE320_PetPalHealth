/// logic ของฟีเจอร์เสียงพากย์ (pure Dart) — ui-spec §2.4.3
///
/// ไม่ขึ้นกับ widget / plugin / shared_preferences · รับเวลาปัจจุบันเป็นพารามิเตอร์
library;

import '../dashboard/dashboard_models.dart';
import '../water/water_logic.dart';
import 'voice_models.dart';
import 'voice_rules.dart';

class VoiceLogic {
  VoiceLogic._();

  /// AC-6, AC-7 — `< 3` → waterLow · `3..7` → null · `>= 8` → waterSuccess
  // ASSUMPTION: voice ui-spec Q-20 — น้ำติดลบ → waterLow
  static VoiceLine? lineForWater(int cups) {
    if (cups < VoiceRules.waterLowBelowCups) return VoiceLine.waterLow;
    if (cups >= VoiceRules.waterSuccessMinCups) return VoiceLine.waterSuccess;
    return null;
  }

  /// AC-2..AC-4 — เทียบแบบจำนวนเต็ม (เลี่ยงทศนิยม: `steps*100` กับ `goal*X`)
  // ASSUMPTION: voice ui-spec Q-20 — เป้า ≤ 0 / ก้าว ≤ 0 = 0% (= StepsLogic.percentGoal)
  // ASSUMPTION: voice ui-spec Q-30 — 99.99x % = stepsEncouraging (เทียบ < 100%)
  static VoiceLine? lineForSteps(int steps, int goal) {
    if (goal <= 0 || steps <= 0) return VoiceLine.stepsLazy;
    final scaled = steps * 100;
    if (scaled < goal * VoiceRules.stepsLazyBelowPercent) {
      return VoiceLine.stepsLazy;
    }
    if (scaled >= goal * VoiceRules.stepsSuccessMinPercent) {
      return VoiceLine.stepsSuccess;
    }
    if (scaled >= goal * VoiceRules.stepsEncouragingMinPercent) {
      return VoiceLine.stepsEncouraging;
    }
    return null;
  }

  /// AC-5 — `isFoodOverLimit` (= total > target + FoodRules.overLimitThreshold)
  static VoiceLine? lineForFood(bool isFoodOverLimit) =>
      isFoodOverLimit ? VoiceLine.foodOvereating : null;

  static VoiceLine? lineFor(VoiceTopic topic, DashboardInput input) =>
      switch (topic) {
        VoiceTopic.water => lineForWater(input.cups),
        VoiceTopic.steps => lineForSteps(input.steps, input.stepsGoal),
        VoiceTopic.food => lineForFood(input.isFoodOverLimit),
      };

  /// รหัสช่วง — ช่วงไม่มีบทพูด = `'NONE'` (แต่ละเรื่องมีช่วงไม่มีบทพูดช่วงเดียว)
  static String bandCode(VoiceLine? line) =>
      line?.id ?? VoiceRules.noLineBandCode;

  /// DECIDED (owner 2026-11-12, V-6a / BUG-VOICE-1): เลือก voice ไทยที่ "ไม่ต้องใช้เน็ต" จากผล
  /// `FlutterTts.getVoices` (Android) — คืน `{'name', 'locale'}` สำหรับ `setVoice` หรือ null ถ้าไม่มี
  ///
  /// - locale ต้องเป็นภาษาไทย (`th` หรือ `th-…` / `th_…`) — ไม่สนตัวพิมพ์
  /// - `network_required` ต้องเป็น `"0"` เท่านั้น (ไม่มีคีย์ / ค่าอื่น = ไม่เลือก — ปลอดภัยไว้ก่อน)
  /// - ข้าม voice ที่ features มี `notInstalled` (ยังไม่ดาวน์โหลด)
  /// - ถ้ามีหลายตัว เลือกตัวที่ locale ตรง [VoiceRules.ttsLanguage] (`th-TH`) ก่อน ไม่เช่นนั้นตัวแรก
  // ASSUMPTION: BUG-VOICE-1 — รายการที่ไม่ใช่ List / สมาชิกที่ไม่ใช่ Map ถูกข้าม (ไม่ throw)
  static Map<String, String>? pickOfflineThaiVoice(Object? voices) {
    if (voices is! List) return null;
    Map<String, String>? fallback;
    for (final v in voices) {
      if (v is! Map) continue;
      final name = v[VoiceRules.ttsVoiceNameKey];
      final locale = v[VoiceRules.ttsVoiceLocaleKey];
      if (name is! String || name.isEmpty || locale is! String) continue;
      if (!_isThaiLocale(locale)) continue;
      if (v[VoiceRules.ttsVoiceNetworkRequiredKey] !=
          VoiceRules.ttsVoiceNetworkNotRequired) {
        continue;
      }
      final features = v[VoiceRules.ttsVoiceFeaturesKey];
      if (features is String &&
          features.split('\t').contains(VoiceRules.ttsVoiceFeatureNotInstalled)) {
        continue;
      }
      final picked = {
        VoiceRules.ttsVoiceNameKey: name,
        VoiceRules.ttsVoiceLocaleKey: locale,
      };
      if (_sameLocale(locale, VoiceRules.ttsLanguage)) return picked;
      fallback ??= picked;
    }
    return fallback;
  }

  static bool _isThaiLocale(String locale) {
    final l = locale.toLowerCase();
    final code = VoiceRules.ttsLanguageCode;
    return l == code || l.startsWith('$code-') || l.startsWith('${code}_');
  }

  static bool _sameLocale(String a, String b) =>
      a.toLowerCase().replaceAll('_', '-') ==
      b.toLowerCase().replaceAll('_', '-');

  /// DECIDED (owner 2026-11-12, V-4): แต่ละเรื่องพูดเฉพาะเมื่อค่า "เข้าช่วงใหม่" ที่ต่างจาก
  /// ช่วงล่าสุดของเรื่องนั้นในรอบวันเดียวกัน (ช่วงที่ไม่มีบทพูดก็นับเป็นช่วง)
  /// · รอบวัน 05:00 ของแอปเดิม (WaterLogic.logicalDay)
  static VoiceEvaluation evaluate({
    required DashboardInput input,
    required VoiceDayBands? previous,
    required DateTime now,
  }) {
    final today = WaterLogic.logicalDay(now);
    // วันใหม่ (05:00) = เริ่มนับใหม่
    final prev = (previous != null && previous.day == today)
        ? previous.bands
        : const <VoiceTopic, String>{};
    final bands = Map<VoiceTopic, String>.of(prev);
    final lines = <VoiceLine>[];
    for (final topic in VoiceTopic.values) {
      final line = lineFor(topic, input);
      final code = bandCode(line);
      if (prev[topic] != code) {
        bands[topic] = code;
        if (line != null) lines.add(line);
      }
    }
    return VoiceEvaluation(
      bands: VoiceDayBands(day: today, bands: bands),
      lines: List.unmodifiable(lines),
    );
  }
}
