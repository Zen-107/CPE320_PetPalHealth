/// Logic เกมของฟีเจอร์ steps — pure Dart ไม่ขึ้นกับ widget
///
/// ทุกฟังก์ชันที่เกี่ยวกับเวลารับ `now` เป็นพารามิเตอร์ เพื่อให้ QA ทดสอบได้
library;

import '../water/water_models.dart' show DailyWaterRecord;
import 'steps_models.dart';
import 'steps_rules.dart';

class StepsLogic {
  StepsLogic._();

  // ---------------------------------------------------------------------------
  // % Goal และสถานะสัตว์เลี้ยง (AC-5, game-rules §2)
  // ---------------------------------------------------------------------------

  /// % Goal = (ก้าวเดินจริง / เป้าหมาย) * 100 — ไม่ตัดเพดาน (ux-flow S-1 รองรับเกิน 100%)
  /// คำนวณ `steps * 100 / goal` ด้วยการหารครั้งเดียว เพื่อให้ค่าตรงขอบ (เช่น 2,800/8,000
  /// = 35.0) ไม่เพี้ยนจาก floating point
  static double percentGoal(int steps, int goal) {
    if (goal <= 0 || steps <= 0) return 0;
    return steps * 100 / goal;
  }

  /// สัดส่วน 0.0–1.0 สำหรับหลอดพลังงาน (ui-spec §2.1 #7: clamp — เกิน 100% หลอดเต็ม)
  static double energyBarFraction(int steps, int goal) {
    final p = percentGoal(steps, goal) / StepsRules.muscleMinPercent;
    if (p < 0) return 0;
    if (p > 1) return 1;
    return p;
  }

  /// สถานะตาม % Goal: FAT [0,35) CHUBBY [35,70) LEAN [70,100) MUSCLE [100,∞)
  static StepsPetStatus statusForPercent(double percent) {
    if (percent >= StepsRules.muscleMinPercent) return StepsPetStatus.muscle;
    if (percent >= StepsRules.leanMinPercent) return StepsPetStatus.lean;
    if (percent >= StepsRules.chubbyMinPercent) return StepsPetStatus.chubby;
    return StepsPetStatus.fat;
  }

  static StepsPetStatus statusFor(int steps, int goal) =>
      statusForPercent(percentGoal(steps, goal));

  static String statusText(StepsPetStatus status) => switch (status) {
        StepsPetStatus.fat => StepsRules.statusFatText,
        StepsPetStatus.chubby => StepsRules.statusChubbyText,
        StepsPetStatus.lean => StepsRules.statusLeanText,
        StepsPetStatus.muscle => StepsRules.statusMuscleText,
      };

  static String statusImage(StepsPetStatus status) => switch (status) {
        StepsPetStatus.fat => StepsRules.petFatImage,
        StepsPetStatus.chubby => StepsRules.petChubbyImage,
        StepsPetStatus.lean => StepsRules.petLeanImage,
        StepsPetStatus.muscle => StepsRules.petMuscleImage,
      };

  // ---------------------------------------------------------------------------
  // รูปแบบข้อความ (ui-spec §2.1, Q-7, Q-10)
  // ---------------------------------------------------------------------------

  /// ข้อความ % Goal: ทศนิยมสูงสุด 2 ตำแหน่งแบบตัดทิ้ง (ไม่ปัด) และตัดศูนย์ท้าย
  /// เช่น 2,800/8,000 → "35", 8,500/8,000 → "106.25", 7,999/8,000 → "99.98"
  // ASSUMPTION: ui-spec Q-7 — ตัดทิ้งไม่ปัด เพื่อไม่ให้แสดง 100% ขณะภาพยังเป็น LEAN
  // ใช้เลขจำนวนเต็ม (หน่วย 0.01%) เพื่อไม่ให้ floating point ทำให้ค่าตรงขอบเพี้ยน
  static String formatPercent(int steps, int goal) {
    if (goal <= 0 || steps <= 0) return '0';
    final hundredths = (steps * 10000) ~/ goal;
    final whole = hundredths ~/ 100;
    final frac = hundredths % 100;
    if (frac == 0) return '$whole';
    if (frac % 10 == 0) return '$whole.${frac ~/ 10}';
    return '$whole.${frac.toString().padLeft(2, '0')}';
  }

  /// ใส่ comma คั่นหลักพัน เช่น 5500 → "5,500"
  static String formatThousands(int value) {
    final negative = value < 0;
    final digits = value.abs().toString();
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
      buf.write(digits[i]);
    }
    return negative ? '-$buf' : buf.toString();
  }

  /// "5,500 / 8,000 ก้าว" (ux-flow S-1)
  static String countText(int steps, int goal) =>
      '${formatThousands(steps)} / ${formatThousands(goal)} ${StepsRules.stepsUnit}';

  /// ป้ายชิปเป้าหมาย เช่น "8,000 ก้าว" (ux-flow S-2)
  static String goalChipText(int goal) =>
      '${formatThousands(goal)} ${StepsRules.stepsUnit}';

  /// ค่าเฉลี่ยทศนิยม 1 ตำแหน่งพร้อม comma เช่น 5250.5 → "5,250.5"
  static String formatAverage(double average) {
    final fixed = average.toStringAsFixed(StepsRules.monthlyAverageDecimals);
    final dot = fixed.indexOf('.');
    final intPart = int.parse(dot < 0 ? fixed : fixed.substring(0, dot));
    final fracPart = dot < 0 ? '' : fixed.substring(dot);
    return '${formatThousands(intPart)}$fracPart';
  }

  // ---------------------------------------------------------------------------
  // รอบวัน 05:00 น. (AC-6, EC-5) และนาฬิกาย้อน (EC-3)
  // ---------------------------------------------------------------------------

  /// วันที่ "ตามรอบวัน" ที่เริ่ม 05:00:00 น.
  /// เช่น 2026-10-14 04:59:59 → 2026-10-13, 2026-10-14 05:00:00 → 2026-10-14
  static DateTime logicalDay(DateTime now) {
    // ใช้ constructor ของ DateTime (ไม่ใช่ subtract Duration) กัน DST ทำให้วันเพี้ยน
    final shifted = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour - StepsRules.resetCutoffHour,
      now.minute - StepsRules.resetCutoffMinute,
    );
    return DateTime(shifted.year, shifted.month, shifted.day);
  }

  /// เวลา 05:00:00 น. ถัดไปหลัง `now` (เวลาตัดรอบครั้งถัดไป)
  static DateTime nextCutoff(DateTime now) {
    final day = logicalDay(now);
    return DateTime(day.year, day.month, day.day + 1,
        StepsRules.resetCutoffHour, StepsRules.resetCutoffMinute);
  }

  /// เวลาที่ใช้คำนวณกติกา: ไม่ถอยหลังกว่าเวลาล่าสุดที่ระบบเคยเห็น
  // ASSUMPTION: EC-3 ให้ยึด Network/Server Time แต่ MVP ไม่มี network (ui-spec D-2)
  // ทางที่ปลอดภัยที่สุดแบบออฟไลน์: ถ้านาฬิกาเครื่องย้อนกลับไปก่อนเวลาล่าสุดที่เคยเห็น
  // ให้ใช้เวลาล่าสุดแทน → ไม่รีเซ็ต/ไม่ย้อนรอบวัน ไม่ได้โควต้าเปลี่ยนเป้าหมายคืน
  // และไม่ลบข้อมูล (แนวเดียวกับ WaterLogic.effectiveNow)
  static DateTime effectiveNow(DateTime? lastSeenAt, DateTime now) =>
      lastSeenAt != null && now.isBefore(lastSeenAt) ? lastSeenAt : now;

  /// ตรวจและปรับรอบวัน ณ เวลา `now`:
  /// - ครั้งแรก (day == null) → ตั้งรอบวันปัจจุบัน ก้าว 0
  /// - ข้าม 05:00 น. แล้ว → เก็บรอบวันเดิมลงประวัติ แล้วรีเซ็ตก้าวเป็น 0 (AC-6, EC-5)
  /// - ถึงรอบวันของเป้าหมายที่รอมีผล → ใช้เป้าหมายนั้น (AC-4)
  /// - นาฬิกาย้อน → ไม่ย้อนรอบวัน (EC-3)
  /// คืน object เดิม (identical) ถ้าไม่มีอะไรเปลี่ยน
  static StepsState applyDayRollover(StepsState state, DateTime now) {
    final today = logicalDay(effectiveNow(state.lastSeenAt, now));
    var next = state;
    final day = state.day;
    if (day == null) {
      next = next.copyWith(day: today, steps: 0);
    } else if (today.isAfter(day)) {
      next = next.copyWith(
        day: today,
        steps: 0,
        history: upsertHistory(
          state.history,
          DailyStepsRecord(
              date: day, steps: state.steps, goal: state.activeGoal),
        ),
      );
    }
    final pending = next.pendingGoal;
    final pendingDay = next.pendingGoalDay;
    if (pending != null &&
        (pendingDay == null || !today.isBefore(pendingDay))) {
      next = next.copyWith(
        activeGoal: pending,
        pendingGoal: () => null,
        pendingGoalDay: () => null,
      );
    }
    return next;
  }

  /// ใส่/แทนที่ประวัติของวันเดียวกัน (คืน list ใหม่ เรียงตามวันที่)
  static List<DailyStepsRecord> upsertHistory(
    List<DailyStepsRecord> history,
    DailyStepsRecord record,
  ) {
    final result = [
      for (final r in history)
        if (r.date != record.date) r,
      record,
    ]..sort((a, b) => a.date.compareTo(b.date));
    return List.unmodifiable(result);
  }

  // ---------------------------------------------------------------------------
  // เพิ่มก้าวเดินด้วยมือ (ui-spec D-1)
  // ---------------------------------------------------------------------------

  /// เพิ่มก้าว `amount` ณ เวลา `now` (ตรวจรอบวันก่อนเสมอ)
  static StepsState addSteps(StepsState state, int amount, DateTime now) {
    final current = applyDayRollover(state, now);
    if (amount <= 0) return current;
    return current.copyWith(
      steps: current.steps + amount,
      lastSeenAt: effectiveNow(current.lastSeenAt, now),
    );
  }

  // ---------------------------------------------------------------------------
  // เป้าหมายและโควต้า (AC-2, AC-3, AC-4)
  // ---------------------------------------------------------------------------

  static bool isValidGoal(int goal) =>
      goal >= StepsRules.minDailyGoal &&
      goal <= StepsRules.maxDailyGoal &&
      StepsRules.allGoals.contains(goal);

  /// จำนวนครั้งที่เปลี่ยนเป้าหมายไปแล้วในรอบวันของ `now` (รีเซ็ตทุก 05:00 น.)
  static int goalChangesUsed(StepsState state, DateTime now) {
    final changeDay = state.goalChangeDay;
    if (changeDay == null) return 0;
    final today = logicalDay(effectiveNow(state.lastSeenAt, now));
    // นาฬิกาย้อนจนรอบวันอยู่ก่อนวันที่เปลี่ยน → ถือว่ายังเป็นวันเดียวกัน (EC-3)
    return today.isAfter(changeDay) ? 0 : state.goalChangeCount;
  }

  static int remainingGoalQuota(StepsState state, DateTime now) {
    final left = StepsRules.dailyGoalQuota - goalChangesUsed(state, now);
    return left < 0 ? 0 : left;
  }

  static bool canChangeGoal(StepsState state, DateTime now) =>
      remainingGoalQuota(state, now) > 0;

  /// เป้าหมายใหม่มีผลทันทีหรือไม่
  // ASSUMPTION: AC-2 ("นำไปคำนวณ % Goal ทันที") ขัดกับ AC-4 ("ปรับหลัง 05:00 มีผลรอบวัน
  // ถัดไป") — ทุกเวลาในรอบวันอยู่ "หลัง 05:00" ของรอบวันนั้น ถ้าตีความตรงตัว AC-2 จะไม่มีวัน
  // เกิด เลือกตีความตาม docs/steps/brief.md §2 ซึ่งเป็นต้นทางของ AC ทั้งสอง:
  //   1) ตั้งเป้าหมายครั้งแรก (ยังไม่เคยบันทึกเอง) → มีผลทันที (AC-2)
  //   2) เปลี่ยนช่วง 00:00–04:59 (ก่อน 05:00) → มีผลกับรอบวันปัจจุบันทันที (AC-2)
  //   3) เปลี่ยนช่วง 05:00–23:59 → มีผล 05:00 น. ของรอบวันถัดไป (AC-4)
  static bool goalAppliesImmediately(StepsState state, DateTime now) {
    if (!state.hasUserGoal) return true;
    final t = effectiveNow(state.lastSeenAt, now);
    final minutes = t.hour * 60 + t.minute;
    final cutoff =
        StepsRules.resetCutoffHour * 60 + StepsRules.resetCutoffMinute;
    return minutes < cutoff;
  }

  /// บันทึกเป้าหมาย `goal` ณ เวลา `now` (ไม่รวมการเขียนลงเครื่อง)
  /// - ทุกการบันทึกที่สำเร็จหักโควต้า 1 ครั้ง รวมการตั้งครั้งแรก (game-rules §3)
  static SaveGoalResult saveGoal(StepsState state, int goal, DateTime now) {
    final current = applyDayRollover(state, now);
    if (!isValidGoal(goal)) {
      return SaveGoalResult(SaveGoalOutcome.invalidGoal, current);
    }
    if (!canChangeGoal(current, now)) {
      return SaveGoalResult(SaveGoalOutcome.quotaExceeded, current);
    }
    final eff = effectiveNow(current.lastSeenAt, now);
    final today = logicalDay(eff);
    final used = goalChangesUsed(current, now);
    final immediate = goalAppliesImmediately(current, now);
    final base = current.copyWith(
      hasUserGoal: true,
      goalChangeDay: today,
      goalChangeCount: used + 1,
      lastSeenAt: eff,
    );
    if (immediate) {
      return SaveGoalResult(
        SaveGoalOutcome.appliedNow,
        base.copyWith(
          activeGoal: goal,
          pendingGoal: () => null,
          pendingGoalDay: () => null,
        ),
      );
    }
    return SaveGoalResult(
      SaveGoalOutcome.appliedNextDay,
      base.copyWith(
        pendingGoal: () => goal,
        pendingGoalDay: () => DateTime(today.year, today.month, today.day + 1),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // รายงานรายเดือน (AC-7)
  // ---------------------------------------------------------------------------

  /// รายงานของเดือนตามรอบวันของ `now` (00:00–04:59 ของวันที่ 1 นับเป็นเดือนก่อน)
  /// - ก้าวเดินรวม = ผลรวมก้าวทุกรอบวันในเดือน (รวมรอบวันปัจจุบัน)
  /// - น้ำดื่มรวม = ผลรวมแก้วจากประวัติของฟีเจอร์ water ในเดือนเดียวกัน
  /// - ค่าเฉลี่ยรายวัน = ก้าวรวม / จำนวนวันที่มีก้าว > 0
  /// - วันที่ทำเป้าหมายสำเร็จ = จำนวนรอบวันที่ % Goal >= 100 (เทียบเป้าหมายของวันนั้น)
  // ASSUMPTION: ตัวหารค่าเฉลี่ย = จำนวนวันที่มีก้าว > 0 (แนวเดียวกับ DECIDED ของ water
  // "นับเฉพาะวันที่มีการบันทึก") — เอกสาร steps ไม่ได้กำหนด
  // ASSUMPTION: "วันที่ทำเป้าหมายสำเร็จ" ใช้เป้าหมายที่มีผลในรอบวันนั้น (ไม่ใช่เป้าหมายปัจจุบัน)
  static MonthlyStepsReport monthlyReport(
    StepsState state,
    List<DailyWaterRecord> waterHistory,
    DateTime now,
  ) {
    final today = logicalDay(effectiveNow(state.lastSeenAt, now));
    bool inMonth(DateTime d) =>
        d.year == today.year && d.month == today.month;

    final days = <DailyStepsRecord>[
      for (final r in state.history)
        if (r.date != state.day) r,
      if (state.day != null)
        DailyStepsRecord(
            date: state.day!, steps: state.steps, goal: state.activeGoal),
    ].where((r) => inMonth(r.date) && r.steps > 0).toList();

    final totalSteps = days.fold<int>(0, (sum, r) => sum + r.steps);
    final goalDays = days
        .where((r) => statusFor(r.steps, r.goal) == StepsPetStatus.muscle)
        .length;
    final totalWater = waterHistory
        .where((r) => inMonth(r.date) && r.cups > 0)
        .fold<int>(0, (sum, r) => sum + r.cups);

    return MonthlyStepsReport(
      year: today.year,
      month: today.month,
      totalSteps: totalSteps,
      totalWaterCups: totalWater,
      averageDailySteps: days.isEmpty ? 0.0 : totalSteps / days.length,
      goalAchievedDays: goalDays,
      recordedDays: days.length,
    );
  }

  /// ชื่อไฟล์ PNG ของรายงาน เช่น steps_report_2026-10.png
  static String reportFileName(int year, int month) =>
      'steps_report_${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}.png';
}
