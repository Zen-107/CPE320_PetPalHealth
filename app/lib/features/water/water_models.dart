/// โมเดลข้อมูลของฟีเจอร์ water (pure Dart ไม่ขึ้นกับ Flutter)
library;

/// สถานะ/อารมณ์ของสัตว์เลี้ยง (game-rules.md §2)
enum PetMood { critical, tired, happy }

/// ประวัติรายวัน 1 รายการ (requirements.md §7 daily_history_log: Date, Total Cups)
class DailyWaterRecord {
  const DailyWaterRecord({required this.date, required this.cups});

  /// วันที่ตามรอบวัน 05:00 น. (เก็บเฉพาะ ปี/เดือน/วัน)
  final DateTime date;
  final int cups;

  DailyWaterRecord copyWith({int? cups}) =>
      DailyWaterRecord(date: date, cups: cups ?? this.cups);

  Map<String, Object> toJson() => {
        'date': formatDateKey(date),
        'cups': cups,
      };

  static DailyWaterRecord fromJson(Map<String, dynamic> json) {
    return DailyWaterRecord(
      date: DateTime.parse(json['date'] as String),
      cups: (json['cups'] as num).toInt(),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is DailyWaterRecord && other.date == date && other.cups == cups;

  @override
  int get hashCode => Object.hash(date, cups);

  @override
  String toString() => 'DailyWaterRecord(${formatDateKey(date)}, $cups)';
}

/// สถานะการดื่มน้ำของวันปัจจุบัน + ประวัติ
class WaterState {
  const WaterState({
    required this.cups,
    required this.lastLoggedAt,
    required this.history,
  });

  /// สถานะเริ่มต้น (เปิดแอปวันแรก) — ux-flow.md §4 S-1 ว่าง
  static const WaterState initial =
      WaterState(cups: 0, lastLoggedAt: null, history: []);

  /// daily_water_count
  final int cups;

  /// last_logged_timestamp (null = ยังไม่เคยบันทึก)
  final DateTime? lastLoggedAt;

  /// daily_history_log เรียงตามวันที่จากเก่าไปใหม่
  final List<DailyWaterRecord> history;

  WaterState copyWith({
    int? cups,
    DateTime? lastLoggedAt,
    List<DailyWaterRecord>? history,
  }) {
    return WaterState(
      cups: cups ?? this.cups,
      lastLoggedAt: lastLoggedAt ?? this.lastLoggedAt,
      history: history ?? this.history,
    );
  }

  @override
  String toString() =>
      'WaterState(cups: $cups, lastLoggedAt: $lastLoggedAt, history: $history)';
}

/// ผลของการกดบันทึกน้ำ
enum LogWaterOutcome {
  /// บันทึกสำเร็จ (AC-1, AC-4)
  logged,

  /// ถูกบล็อกโดย Anti-Spam (AC-3, EC-3)
  blockedBySpam,

  /// ยังโหลดข้อมูลจากเครื่องไม่เสร็จ — ไม่บันทึกและไม่แสดง Toast
  notReady,
}

class LogWaterResult {
  const LogWaterResult(this.outcome, this.state);

  final LogWaterOutcome outcome;

  /// สถานะหลังประมวลผล (ถ้าถูกบล็อก จำนวนแก้วไม่เปลี่ยน)
  final WaterState state;

  bool get isLogged => outcome == LogWaterOutcome.logged;
}

/// ข้อมูลหน้ารายงานรายเดือน (AC-6)
class MonthlyWaterReport {
  const MonthlyWaterReport({
    required this.year,
    required this.month,
    required this.records,
    required this.totalCups,
    required this.average,
  });

  final int year;
  final int month;

  /// รายการประวัติรายวันของเดือนนี้ เรียงจากเก่าไปใหม่
  final List<DailyWaterRecord> records;
  final int totalCups;

  /// ค่าเฉลี่ยแบบยังไม่ปัดเศษ (ใช้ formatAverage เพื่อแสดงผล)
  final double average;

  bool get isEmpty => records.isEmpty;
}

/// แปลงวันที่เป็น 'yyyy-MM-dd'
String formatDateKey(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
