/// โมเดลข้อมูลของฟีเจอร์ steps (pure Dart ไม่ขึ้นกับ Flutter)
library;

import 'steps_rules.dart';

/// สถานะสัตว์เลี้ยงตาม % Goal (game-rules.md §2, AC-5)
/// `code` = ค่า Enum ใน requirements.md §7 (`FAT`, `CHUBBY`, `LEAN`, `MUSCLE`)
enum StepsPetStatus {
  fat('FAT'),
  chubby('CHUBBY'),
  lean('LEAN'),
  muscle('MUSCLE');

  const StepsPetStatus(this.code);

  final String code;

  static StepsPetStatus? fromCode(String? code) {
    for (final s in values) {
      if (s.code == code) return s;
    }
    return null;
  }
}

/// สถานะการนับก้าว (EC-1, EC-6) — MVP กรอกด้วยมือจึงเป็น [available] เสมอ
/// เว้นแต่ inject ค่าอื่น (เช่นในเทสต์) — ui-spec Q-4
enum StepsTrackingStatus { available, permissionDenied, noHardware }

/// ประวัติรายวัน 1 รายการ (วันตามรอบ 05:00 น., จำนวนก้าว, เป้าหมายที่ใช้วันนั้น)
class DailyStepsRecord {
  const DailyStepsRecord({
    required this.date,
    required this.steps,
    required this.goal,
  });

  /// วันตามรอบวัน 05:00 น. (เก็บเฉพาะ ปี/เดือน/วัน)
  final DateTime date;
  final int steps;

  /// เป้าหมายที่มีผลในรอบวันนั้น (ใช้นับ "วันที่ทำเป้าหมายสำเร็จ" AC-7)
  final int goal;

  Map<String, Object> toJson() => {
        'date': formatStepsDateKey(date),
        'steps': steps,
        'goal': goal,
      };

  static DailyStepsRecord fromJson(Map<String, dynamic> json) {
    final d = DateTime.parse(json['date'] as String);
    return DailyStepsRecord(
      date: DateTime(d.year, d.month, d.day),
      steps: (json['steps'] as num).toInt(),
      goal: (json['goal'] as num).toInt(),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is DailyStepsRecord &&
      other.date == date &&
      other.steps == steps &&
      other.goal == goal;

  @override
  int get hashCode => Object.hash(date, steps, goal);

  @override
  String toString() =>
      'DailyStepsRecord(${formatStepsDateKey(date)}, $steps/$goal)';
}

/// สถานะทั้งหมดของฟีเจอร์ steps ที่เก็บในเครื่อง (requirements.md §7)
class StepsState {
  const StepsState({
    required this.steps,
    required this.day,
    required this.activeGoal,
    required this.pendingGoal,
    required this.pendingGoalDay,
    required this.hasUserGoal,
    required this.goalChangeDay,
    required this.goalChangeCount,
    required this.lastSeenAt,
    required this.history,
  });

  /// สถานะเริ่มต้น (ผู้ใช้ใหม่) — ux-flow.md §4 S-1 ว่าง, S-2 ว่าง (8,000 pre-selected)
  static const StepsState initial = StepsState(
    steps: 0,
    day: null,
    activeGoal: StepsRules.defaultDailyGoal,
    pendingGoal: null,
    pendingGoalDay: null,
    hasUserGoal: false,
    goalChangeDay: null,
    goalChangeCount: 0,
    lastSeenAt: null,
    history: [],
  );

  /// Current Steps ของรอบวัน [day]
  final int steps;

  /// รอบวัน (05:00–04:59) ที่ [steps] เป็นของ — null = ยังไม่เคยเปิด
  final DateTime? day;

  /// เป้าหมายที่ใช้คำนวณ % Goal ของรอบวันปัจจุบัน
  final int activeGoal;

  /// เป้าหมายที่บันทึกแล้วแต่ยังไม่มีผล (AC-4) — มีผลเมื่อถึงรอบวัน [pendingGoalDay]
  final int? pendingGoal;
  final DateTime? pendingGoalDay;

  /// ผู้ใช้เคยบันทึกเป้าหมายเองแล้วหรือยัง (false = ยังใช้ค่าเริ่มต้น)
  final bool hasUserGoal;

  /// รอบวันที่เปลี่ยนเป้าหมายล่าสุด และจำนวนครั้งในรอบวันนั้น (โควต้า AC-3)
  final DateTime? goalChangeDay;
  final int goalChangeCount;

  /// เวลาล่าสุดที่ระบบเคยเห็น (ใช้กันนาฬิกาย้อน EC-3)
  final DateTime? lastSeenAt;

  /// ประวัติรอบวันที่ผ่านไปแล้ว เรียงจากเก่าไปใหม่ (ไม่รวมรอบวันปัจจุบัน)
  final List<DailyStepsRecord> history;

  /// เป้าหมายล่าสุดที่ผู้ใช้บันทึก (รวมที่ยังรอมีผล) — ใช้เลือกชิปบน S-2
  int get latestGoal => pendingGoal ?? activeGoal;

  StepsState copyWith({
    int? steps,
    DateTime? day,
    int? activeGoal,
    int? Function()? pendingGoal,
    DateTime? Function()? pendingGoalDay,
    bool? hasUserGoal,
    DateTime? goalChangeDay,
    int? goalChangeCount,
    DateTime? lastSeenAt,
    List<DailyStepsRecord>? history,
  }) {
    return StepsState(
      steps: steps ?? this.steps,
      day: day ?? this.day,
      activeGoal: activeGoal ?? this.activeGoal,
      pendingGoal: pendingGoal != null ? pendingGoal() : this.pendingGoal,
      pendingGoalDay:
          pendingGoalDay != null ? pendingGoalDay() : this.pendingGoalDay,
      hasUserGoal: hasUserGoal ?? this.hasUserGoal,
      goalChangeDay: goalChangeDay ?? this.goalChangeDay,
      goalChangeCount: goalChangeCount ?? this.goalChangeCount,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      history: history ?? this.history,
    );
  }

  @override
  String toString() => 'StepsState(steps: $steps, day: $day, '
      'activeGoal: $activeGoal, pendingGoal: $pendingGoal@$pendingGoalDay, '
      'hasUserGoal: $hasUserGoal, goalChange: $goalChangeCount@$goalChangeDay, '
      'lastSeenAt: $lastSeenAt, history: $history)';
}

/// ผลของการบันทึกเป้าหมาย (AC-2, AC-3, AC-4)
enum SaveGoalOutcome {
  /// บันทึกสำเร็จ มีผลกับรอบวันปัจจุบันทันที (AC-2)
  appliedNow,

  /// บันทึกสำเร็จ มีผลรอบวันถัดไป 05:00 น. (AC-4)
  appliedNextDay,

  /// โควต้าหมด ไม่บันทึก (AC-3)
  quotaExceeded,

  /// ค่าไม่อยู่ในตัวเลือก AC-2
  invalidGoal,

  /// เขียนลงเครื่องไม่สำเร็จ (ux-flow S-2 Error, ui-spec Q-6) — สถานะไม่เปลี่ยน
  storageError,

  /// ยังโหลดไม่เสร็จ หรือกำลังบันทึกอยู่
  notReady,
}

class SaveGoalResult {
  const SaveGoalResult(this.outcome, this.state);

  final SaveGoalOutcome outcome;
  final StepsState state;

  bool get isSaved =>
      outcome == SaveGoalOutcome.appliedNow ||
      outcome == SaveGoalOutcome.appliedNextDay;
}

/// ผลของการกดเพิ่มก้าวเดิน
enum AddStepsOutcome { added, locked, notReady }

/// ข้อมูลรายงานสรุปรายเดือน 4 ตัวแปร (AC-7)
class MonthlyStepsReport {
  const MonthlyStepsReport({
    required this.year,
    required this.month,
    required this.totalSteps,
    required this.totalWaterCups,
    required this.averageDailySteps,
    required this.goalAchievedDays,
    required this.recordedDays,
  });

  final int year;
  final int month;

  /// ก้าวเดินรวมประจำเดือน
  final int totalSteps;

  /// ปริมาณน้ำดื่มรวมประจำเดือน (แก้ว — จากประวัติของฟีเจอร์ water)
  final int totalWaterCups;

  /// ค่าเฉลี่ยก้าวเดินรายวัน (ยังไม่ปัดเศษ)
  final double averageDailySteps;

  /// จำนวนวันที่ทำเป้าหมายสำเร็จ (% Goal >= 100)
  final int goalAchievedDays;

  /// จำนวนวันที่มีก้าว > 0 (ตัวหารของค่าเฉลี่ย)
  final int recordedDays;

  /// ux-flow S-3 ว่าง: ยังไม่มีข้อมูลการใช้งานในเดือนนี้ (ทั้งก้าวและน้ำเป็น 0)
  bool get isEmpty => totalSteps == 0 && totalWaterCups == 0;

  @override
  String toString() => 'MonthlyStepsReport($year-$month, steps: $totalSteps, '
      'water: $totalWaterCups, avg: $averageDailySteps, '
      'goalDays: $goalAchievedDays, recordedDays: $recordedDays)';
}

/// แปลงวันที่เป็น 'yyyy-MM-dd'
String formatStepsDateKey(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
