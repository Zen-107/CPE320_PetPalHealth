// Unit tests: WaterController + Local Storage (requirements §7)
// เวลาควบคุมผ่าน clock ที่ส่งเข้า controller — ไม่ใช้เวลาจริง
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/water/water_controller.dart';
import 'package:petpal_health/features/water/water_models.dart';
import 'package:petpal_health/features/water/water_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateTime t(int day, int hour, int minute, [int second = 0]) =>
    DateTime(2026, 10, day, hour, minute, second);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DateTime now;
  DateTime clock() => now;

  group('Controller', () {
    test('AC1_controller_log_adds_1_cup_and_12_5_percent', () async {
      now = t(8, 10, 0);
      final c = WaterController(
          repository: InMemoryWaterRepository(), clock: clock);
      await c.load();
      expect(await c.logWater(), LogWaterOutcome.logged);
      expect(c.cups, 1);
      expect(c.displayEnergyPercentage, 12.5);
    });

    test('AC3_AC4_controller_blocks_10_03_allows_10_05', () async {
      now = t(8, 10, 0);
      final c = WaterController(
          repository: InMemoryWaterRepository(), clock: clock);
      await c.load();
      await c.logWater();
      now = t(8, 10, 3);
      expect(await c.logWater(), LogWaterOutcome.blockedBySpam);
      expect(c.cups, 1);
      now = t(8, 10, 5);
      expect(await c.logWater(), LogWaterOutcome.logged);
      expect(c.cups, 2);
      expect(c.state.lastLoggedAt, t(8, 10, 5));
    });

    test('EC3_controller_rapid_taps_without_await_log_only_once', () async {
      now = t(8, 10, 0);
      final c = WaterController(
          repository: InMemoryWaterRepository(), clock: clock);
      await c.load();
      final futures = [for (var i = 0; i < 5; i++) c.logWater()];
      final outcomes = await Future.wait(futures);
      expect(outcomes.where((o) => o == LogWaterOutcome.logged).length, 1);
      expect(c.cups, 1);
    });

    test('AC5_controller_refresh_at_05_00_resets_to_0', () async {
      now = t(8, 4, 59);
      final c = WaterController(
        repository: InMemoryWaterRepository(
          WaterState(cups: 5, lastLoggedAt: t(8, 4, 30), history: const []),
        ),
        clock: clock,
      );
      await c.load();
      expect(c.cups, 5);
      now = t(8, 5, 0);
      await c.refreshDailyReset();
      expect(c.cups, 0);
      expect(c.displayEnergyPercentage, 0.0);
    });

    test('EC2_controller_load_after_05_00_resets_and_saves_0', () async {
      now = t(8, 9, 0);
      final repo = InMemoryWaterRepository(
        WaterState(cups: 6, lastLoggedAt: t(7, 21, 0), history: const []),
      );
      final c = WaterController(repository: repo, clock: clock);
      await c.load();
      expect(c.cups, 0);
      expect((await repo.load()).cups, 0, reason: 'ค่าที่เก็บในเครื่องต้องเป็น 0 ด้วย');
    });

    test('EDGE_first_open_empty_storage_0_cups_critical', () async {
      now = t(8, 9, 0);
      final c = WaterController(
          repository: InMemoryWaterRepository(), clock: clock);
      await c.load();
      expect(c.cups, 0);
      expect(c.displayEnergyPercentage, 0.0);
      expect(c.mood, PetMood.critical);
      expect(c.monthlyReport().isEmpty, isTrue);
    });
  });

  group('Local Storage (SharedPreferences) requirements §7', () {
    test('STORAGE_save_uses_keys_from_requirements_section_7', () async {
      SharedPreferences.setMockInitialValues({});
      now = t(8, 10, 0);
      final c = WaterController(
          repository: SharedPrefsWaterRepository(), clock: clock);
      await c.load();
      await c.logWater();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('daily_water_count'), 1);
      expect(prefs.getDouble('water_energy_percentage'), 12.5);
      final ts = prefs.getString('last_logged_timestamp');
      expect(ts, isNotNull);
      expect(DateTime.parse(ts!), t(8, 10, 0));
      final hist = jsonDecode(prefs.getString('daily_history_log')!) as List;
      expect(hist.length, 1);
    });

    test('STORAGE_data_survives_reopen_same_day', () async {
      SharedPreferences.setMockInitialValues({});
      now = t(8, 10, 0);
      final c1 = WaterController(
          repository: SharedPrefsWaterRepository(), clock: clock);
      await c1.load();
      await c1.logWater();
      now = t(8, 10, 5);
      await c1.logWater();
      now = t(8, 20, 0);
      final c2 = WaterController(
          repository: SharedPrefsWaterRepository(), clock: clock);
      await c2.load();
      expect(c2.cups, 2);
      expect(c2.displayEnergyPercentage, 25.0);
    });

    test('EC2_storage_reopen_next_day_after_05_00_shows_0', () async {
      SharedPreferences.setMockInitialValues({
        'daily_water_count': 5,
        'water_energy_percentage': 62.5,
        'last_logged_timestamp': t(7, 22, 0).toIso8601String(),
        'daily_history_log': jsonEncode([
          {'date': '2026-10-07', 'cups': 5}
        ]),
      });
      now = t(8, 5, 0);
      final c = WaterController(
          repository: SharedPrefsWaterRepository(), clock: clock);
      await c.load();
      expect(c.cups, 0);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('daily_water_count'), 0);
      expect(prefs.getDouble('water_energy_percentage'), 0.0);
    });

    test('EDGE_antispam_across_05_00_survives_app_restart', () async {
      // game-rules §4: บันทึก 04:58 ปิดแอป เปิด 05:01 กด → บล็อก, 05:03 บันทึกได้
      SharedPreferences.setMockInitialValues({
        'daily_water_count': 3,
        'last_logged_timestamp': t(8, 4, 58).toIso8601String(),
        'daily_history_log': jsonEncode([
          {'date': '2026-10-07', 'cups': 3}
        ]),
      });
      now = t(8, 5, 1);
      final c = WaterController(
          repository: SharedPrefsWaterRepository(), clock: clock);
      await c.load();
      expect(c.cups, 0);
      expect(await c.logWater(), LogWaterOutcome.blockedBySpam);
      expect(c.cups, 0);
      now = t(8, 5, 3);
      expect(await c.logWater(), LogWaterOutcome.logged);
      expect(c.cups, 1);
    });

    // Edge 4: ข้อมูลที่เก็บไว้เสีย/หาย
    test('EDGE_corrupted_history_json_does_not_crash_starts_fresh', () async {
      SharedPreferences.setMockInitialValues({
        'daily_history_log': '{not valid json',
      });
      now = t(8, 9, 0);
      final c = WaterController(
          repository: SharedPrefsWaterRepository(), clock: clock);
      await c.load();
      expect(c.isLoaded, isTrue);
      expect(c.cups, 0);
      expect(c.monthlyReport().isEmpty, isTrue);
      expect(await c.logWater(), LogWaterOutcome.logged);
      expect(c.cups, 1);
    });

    test('EDGE_corrupted_history_item_missing_fields_starts_fresh', () async {
      SharedPreferences.setMockInitialValues({
        'daily_history_log': jsonEncode([
          {'date': 'not-a-date', 'cups': 3},
        ]),
      });
      now = t(8, 9, 0);
      final c = WaterController(
          repository: SharedPrefsWaterRepository(), clock: clock);
      await c.load();
      expect(c.isLoaded, isTrue);
      expect(c.monthlyReport().isEmpty, isTrue);
    });

    test('EDGE_corrupted_timestamp_treated_as_never_logged', () async {
      SharedPreferences.setMockInitialValues({
        'daily_water_count': 0,
        'last_logged_timestamp': 'garbage',
      });
      now = t(8, 9, 0);
      final c = WaterController(
          repository: SharedPrefsWaterRepository(), clock: clock);
      await c.load();
      expect(await c.logWater(), LogWaterOutcome.logged);
      expect(c.cups, 1);
    });

    test('EDGE_missing_count_key_defaults_to_0', () async {
      SharedPreferences.setMockInitialValues({
        'last_logged_timestamp': t(8, 8, 0).toIso8601String(),
      });
      now = t(8, 9, 0);
      final c = WaterController(
          repository: SharedPrefsWaterRepository(), clock: clock);
      await c.load();
      expect(c.cups, 0);
      expect(c.displayEnergyPercentage, 0.0);
    });

    test('EDGE_negative_stored_count_clamped_to_0', () async {
      SharedPreferences.setMockInitialValues({
        'daily_water_count': -3,
        'last_logged_timestamp': t(8, 8, 0).toIso8601String(),
      });
      now = t(8, 9, 0);
      final c = WaterController(
          repository: SharedPrefsWaterRepository(), clock: clock);
      await c.load();
      expect(c.cups, 0);
      expect(c.displayEnergyPercentage, 0.0);
    });
  });
}
