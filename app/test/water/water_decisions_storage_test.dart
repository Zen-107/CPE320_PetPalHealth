// Unit tests (QA v2): WaterController + SharedPreferences ตามข้อตัดสิน Zen-107 2026-10-08
// - ข้อ 1 ขอบเดือน AC-6 · ข้อ 2 นาฬิกาย้อนกลับ (game-rules §4)
// - ข้อ 3 ข้อมูลเสีย/เก็บผิดชนิด → เริ่มใหม่เป็นค่าว่าง แอปห้าม crash (game-rules §4)
// เวลาควบคุมผ่าน clock ที่ส่งเข้า controller — ไม่ใช้เวลาจริง
//
// ไม่ assert สิ่งที่เอกสารไม่กำหนด (จดเป็นคำถามใน test-report.md):
// - นาฬิกาย้อนแล้วกดบันทึกได้ทันทีหรือไม่
// - ข้อมูลเสียบางคีย์ ให้ล้างเฉพาะคีย์นั้นหรือล้างทั้งหมด
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/water/water_controller.dart';
import 'package:petpal_health/features/water/water_models.dart';
import 'package:petpal_health/features/water/water_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateTime dt(int month, int day, int hour, int minute, [int second = 0]) =>
    DateTime(2026, month, day, hour, minute, second);

DailyWaterRecord rec(int month, int day, int cups) =>
    DailyWaterRecord(date: DateTime(2026, month, day), cups: cups);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DateTime now;
  DateTime clock() => now;

  Future<WaterController> openWithPrefs(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    final c = WaterController(
        repository: SharedPrefsWaterRepository(), clock: clock);
    await c.load();
    return c;
  }

  group('ข้อตัดสิน 1: ขอบเดือน AC-6 ผ่าน controller', () {
    test('AC6_controller_log_04_59_on_1st_report_shows_previous_month', () async {
      now = dt(11, 1, 4, 59);
      final c = WaterController(
          repository: InMemoryWaterRepository(), clock: clock);
      await c.load();
      await c.logWater();
      final rep = c.monthlyReport();
      expect(rep.month, 10);
      expect(rep.records, [rec(10, 31, 1)]);
    });

    test('AC6_controller_report_at_05_00_on_1st_switches_to_new_month', () async {
      now = dt(11, 1, 4, 59);
      final c = WaterController(
          repository: InMemoryWaterRepository(), clock: clock);
      await c.load();
      await c.logWater(); // → 31 ต.ค.
      now = dt(11, 1, 5, 0);
      await c.refreshDailyReset();
      final rep = c.monthlyReport();
      expect(rep.month, 11);
      expect(rep.isEmpty, isTrue, reason: '31 ต.ค. ไม่อยู่ในเดือน พ.ย.');
      expect(c.state.history, [rec(10, 31, 1)], reason: 'ประวัติเดิมยังอยู่');
    });

    test('AC6_storage_history_key_saves_04_59_as_previous_day', () async {
      now = dt(11, 1, 4, 59);
      SharedPreferences.setMockInitialValues({});
      final c = WaterController(
          repository: SharedPrefsWaterRepository(), clock: clock);
      await c.load();
      await c.logWater();
      final prefs = await SharedPreferences.getInstance();
      final hist = jsonDecode(prefs.getString('daily_history_log')!) as List;
      expect(hist.length, 1);
      expect(DateTime.parse((hist.single as Map)['date'] as String),
          DateTime(2026, 10, 31));
      expect((hist.single as Map)['cups'], 1);
    });
  });

  group('ข้อตัดสิน 2: นาฬิกาย้อนกลับ ผ่าน controller + storage', () {
    Map<String, Object> stored() => {
          'daily_water_count': 3,
          'water_energy_percentage': 37.5,
          'last_logged_timestamp': dt(10, 8, 10, 0).toIso8601String(),
          'daily_history_log': jsonEncode([
            {'date': '2026-10-07', 'cups': 6},
            {'date': '2026-10-08', 'cups': 3},
          ]),
        };

    test('EDGE_clock_back_open_app_no_crash_no_reset_keeps_data', () async {
      now = dt(10, 7, 9, 0);
      final c = await openWithPrefs(stored());
      expect(c.isLoaded, isTrue);
      expect(c.cups, 3);
      expect(c.displayEnergyPercentage, 37.5);
      expect(c.state.history, [rec(10, 7, 6), rec(10, 8, 3)]);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('daily_water_count'), 3,
          reason: 'ห้ามลบข้อมูลในเครื่อง');
    });

    test('EDGE_clock_back_refresh_and_log_do_not_delete_stored_history',
        () async {
      now = dt(10, 7, 9, 0);
      final c = await openWithPrefs(stored());
      await c.refreshDailyReset();
      final outcome = await c.logWater(); // ไม่ assert ว่า logged/blocked
      expect(c.cups, outcome == LogWaterOutcome.logged ? 4 : 3);
      final prefs = await SharedPreferences.getInstance();
      final hist = (jsonDecode(prefs.getString('daily_history_log')!) as List)
          .cast<Map<String, dynamic>>()
          .map(DailyWaterRecord.fromJson)
          .toList();
      expect(hist.firstWhere((r) => r.date == DateTime(2026, 10, 7)).cups, 6,
          reason: 'ประวัติวันก่อนห้ามถูกเขียนทับ');
      expect(
          hist.firstWhere((r) => r.date == DateTime(2026, 10, 8)).cups,
          outcome == LogWaterOutcome.logged ? 4 : 3,
          reason: 'นับเป็นวันเดียวกับบันทึกล่าสุด (8 ต.ค.)');
      expect(hist.length, 2);
    });

    test('EDGE_clock_back_monthly_report_is_month_of_last_log', () async {
      now = dt(10, 30, 12, 0);
      final c = await openWithPrefs({
        'daily_water_count': 2,
        'last_logged_timestamp': dt(11, 1, 6, 0).toIso8601String(),
        'daily_history_log': jsonEncode([
          {'date': '2026-10-31', 'cups': 5},
          {'date': '2026-11-01', 'cups': 2},
        ]),
      });
      final rep = c.monthlyReport();
      expect(rep.month, 11);
      expect(rep.records, [rec(11, 1, 2)]);
      expect(c.cups, 2);
    });

    test('EDGE_clock_back_then_restored_same_day_keeps_cups', () async {
      now = dt(10, 7, 9, 0);
      final c = await openWithPrefs(stored());
      now = dt(10, 8, 12, 0); // นาฬิกากลับมาปกติ วันเดียวกับบันทึกล่าสุด
      await c.refreshDailyReset();
      expect(c.cups, 3);
      expect(await c.logWater(), LogWaterOutcome.logged);
      expect(c.cups, 4);
      expect(c.state.history, [rec(10, 7, 6), rec(10, 8, 4)]);
    });
  });

  group('ข้อตัดสิน 3: ข้อมูลเสีย/ผิดชนิดใน SharedPreferences → ค่าว่าง ไม่ crash', () {
    test('EDGE_bad_type_count_as_string_starts_0_no_crash', () async {
      now = dt(10, 8, 9, 0);
      final c = await openWithPrefs({'daily_water_count': '5'});
      expect(c.isLoaded, isTrue);
      expect(c.cups, 0);
      expect(c.displayEnergyPercentage, 0.0);
      expect(c.mood, PetMood.critical);
    });

    test('EDGE_bad_type_count_as_double_starts_0_no_crash', () async {
      now = dt(10, 8, 9, 0);
      final c = await openWithPrefs({'daily_water_count': 2.5});
      expect(c.isLoaded, isTrue);
      expect(c.cups, 0);
    });

    test('EDGE_bad_type_count_as_bool_starts_0_no_crash', () async {
      now = dt(10, 8, 9, 0);
      final c = await openWithPrefs({'daily_water_count': true});
      expect(c.isLoaded, isTrue);
      expect(c.cups, 0);
    });

    test('EDGE_bad_type_timestamp_as_int_treated_empty_can_log', () async {
      now = dt(10, 8, 9, 0);
      final c = await openWithPrefs({'last_logged_timestamp': 42});
      expect(c.isLoaded, isTrue);
      expect(c.state.lastLoggedAt, isNull);
      expect(await c.logWater(), LogWaterOutcome.logged);
      expect(c.cups, 1);
    });

    test('EDGE_bad_type_history_as_int_starts_empty', () async {
      now = dt(10, 8, 9, 0);
      final c = await openWithPrefs({'daily_history_log': 7});
      expect(c.isLoaded, isTrue);
      expect(c.state.history, isEmpty);
      expect(c.monthlyReport().isEmpty, isTrue);
    });

    test('EDGE_bad_type_history_as_string_list_starts_empty', () async {
      now = dt(10, 8, 9, 0);
      final c = await openWithPrefs({
        'daily_history_log': <String>['2026-10-07', '6'],
      });
      expect(c.isLoaded, isTrue);
      expect(c.state.history, isEmpty);
    });

    test('EDGE_bad_type_history_json_object_not_list_starts_empty', () async {
      now = dt(10, 8, 9, 0);
      final c = await openWithPrefs({
        'daily_history_log': jsonEncode({'date': '2026-10-07', 'cups': 6}),
      });
      expect(c.isLoaded, isTrue);
      expect(c.state.history, isEmpty);
    });

    test('EDGE_bad_type_history_item_cups_as_string_starts_empty', () async {
      now = dt(10, 8, 9, 0);
      final c = await openWithPrefs({
        'daily_history_log': jsonEncode([
          {'date': '2026-10-07', 'cups': 'six'},
        ]),
      });
      expect(c.isLoaded, isTrue);
      expect(c.state.history, isEmpty);
    });

    test('EDGE_bad_type_history_item_null_fields_starts_empty', () async {
      now = dt(10, 8, 9, 0);
      final c = await openWithPrefs({
        'daily_history_log': jsonEncode([
          {'date': null, 'cups': null},
        ]),
      });
      expect(c.isLoaded, isTrue);
      expect(c.state.history, isEmpty);
    });

    test('EDGE_all_keys_bad_type_starts_empty_state', () async {
      now = dt(10, 8, 9, 0);
      final c = await openWithPrefs({
        'daily_water_count': 'abc',
        'water_energy_percentage': 'abc',
        'last_logged_timestamp': 123,
        'daily_history_log': 3.14,
      });
      expect(c.isLoaded, isTrue);
      expect(c.cups, 0);
      expect(c.displayEnergyPercentage, 0.0);
      expect(c.state.lastLoggedAt, isNull);
      expect(c.state.history, isEmpty);
      expect(c.monthlyReport().isEmpty, isTrue);
    });

    test('EDGE_bad_type_after_recovery_log_saves_correct_types', () async {
      now = dt(10, 8, 9, 0);
      final c = await openWithPrefs({
        'daily_water_count': 'abc',
        'last_logged_timestamp': 123,
        'daily_history_log': 3.14,
      });
      expect(await c.logWater(), LogWaterOutcome.logged);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('daily_water_count'), 1);
      expect(prefs.getDouble('water_energy_percentage'), 12.5);
      expect(DateTime.parse(prefs.getString('last_logged_timestamp')!),
          dt(10, 8, 9, 0));
      final hist = jsonDecode(prefs.getString('daily_history_log')!) as List;
      expect(hist.length, 1);
      // เปิดแอปใหม่อ่านค่าได้ตามปกติ
      final c2 = WaterController(
          repository: SharedPrefsWaterRepository(), clock: clock);
      await c2.load();
      expect(c2.cups, 1);
    });

    test('EDGE_repository_load_throws_controller_starts_empty_no_crash',
        () async {
      now = dt(10, 8, 9, 0);
      final c = WaterController(repository: _ThrowingRepository(), clock: clock);
      await c.load();
      expect(c.isLoaded, isTrue);
      expect(c.cups, 0);
      expect(c.state.history, isEmpty);
    });

    test('EDGE_prefs_instance_fails_repository_returns_empty', () async {
      final repo = SharedPrefsWaterRepository(
          Future<SharedPreferences>.error(StateError('storage broken')));
      final s = await repo.load();
      expect(s.cups, 0);
      expect(s.lastLoggedAt, isNull);
      expect(s.history, isEmpty);
    });
  });
}

class _ThrowingRepository implements WaterRepository {
  @override
  Future<WaterState> load() async => throw const FormatException('corrupt');

  @override
  Future<void> save(WaterState state) async {}
}
