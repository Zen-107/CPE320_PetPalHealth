// Unit tests: StepsController + การเก็บข้อมูลในเครื่อง (EC-2, ข้อมูลว่าง/เสีย, EC-1/EC-6, AC-1/2/3)
// เวลาควบคุมผ่าน clock ที่ส่งเข้า controller — ไม่ใช้เวลาจริง
// ค่าคาดหวังจากเอกสาร docs/steps/* ; จำนวนก้าวต่อการกดใช้ค่าคงที่ StepsRules.stepsPerTap
// เพราะเป็นค่าชั่วคราวของ Dev (ui-spec Q-2) ไม่ใช่ตัวเลขในสเปก
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:petpal_health/features/steps/steps_controller.dart';
import 'package:petpal_health/features/steps/steps_external.dart';
import 'package:petpal_health/features/steps/steps_models.dart';
import 'package:petpal_health/features/steps/steps_repository.dart';
import 'package:petpal_health/features/steps/steps_rules.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateTime t(int day, int h, [int m = 0, int s = 0]) =>
    DateTime(2026, 10, day, h, m, s);

class ThrowingRepository implements StepsRepository {
  @override
  Future<StepsState> load() async => throw StateError('disk broken');
  @override
  Future<void> save(StepsState state) async => throw StateError('disk broken');
}

void main() {
  late DateTime now;

  StepsController make(StepsRepository repo,
          {StepsTrackingStatus tracking = StepsTrackingStatus.available}) =>
      StepsController(
        repository: repo,
        waterHistory: FixedWaterHistorySource(),
        exporter: InMemoryStepsReportExporter(),
        clock: () => now,
        trackingStatus: tracking,
      );

  setUp(() => now = t(14, 10));

  group('AC-1 (MVP: เพิ่มก้าวด้วยมือ ui-spec D-1)', () {
    test('AC1_add_steps_increments_by_steps_per_tap_and_persists', () async {
      final repo = InMemoryStepsRepository();
      final c = make(repo);
      await c.load();
      expect(c.steps, 0);
      expect(await c.addSteps(), AddStepsOutcome.added);
      expect(c.steps, StepsRules.stepsPerTap);
      await c.addSteps();
      expect(c.steps, 2 * StepsRules.stepsPerTap);
      expect(repo.stored.steps, 2 * StepsRules.stepsPerTap,
          reason: 'บันทึกลง Local Storage');
      expect(c.percentGoal, 2 * StepsRules.stepsPerTap * 100 / 8000);
    });

    test('AC1_add_before_load_is_ignored', () async {
      final c = make(InMemoryStepsRepository());
      expect(await c.addSteps(), AddStepsOutcome.notReady);
      expect(c.steps, 0);
    });
  });

  group('EC-1 / EC-6 ล็อกการนับก้าว', () {
    for (final status in [
      StepsTrackingStatus.permissionDenied,
      StepsTrackingStatus.noHardware,
    ]) {
      test('EC1_EC6_${status.name}_locks_step_counting', () async {
        final repo = InMemoryStepsRepository();
        final c = make(repo, tracking: status);
        await c.load();
        expect(c.isTrackingLocked, isTrue);
        expect(await c.addSteps(), AddStepsOutcome.locked);
        expect(c.steps, 0);
      });
    }

    test('EC1_unlock_after_permission_granted_allows_counting', () async {
      final c = make(InMemoryStepsRepository(),
          tracking: StepsTrackingStatus.permissionDenied);
      await c.load();
      c.trackingStatus = StepsTrackingStatus.available;
      expect(await c.addSteps(), AddStepsOutcome.added);
      expect(c.steps, StepsRules.stepsPerTap);
    });
  });

  group('AC-2 / AC-3 / S-2 Error ผ่าน controller', () {
    test('AC2_saved_goal_written_to_storage_and_used_for_percent', () async {
      SharedPreferences.setMockInitialValues({});
      final c = make(SharedPrefsStepsRepository());
      await c.load();
      await c.addSteps(3000);
      expect(await c.saveGoal(10000), SaveGoalOutcome.appliedNow);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt(StepsStorageKeys.dailyGoal), 10000);
      expect(c.activeGoal, 10000);
      expect(c.percentGoal, 30);
      expect(c.countText, '3,000 / 10,000 ก้าว');
    });

    test('AC3_second_save_same_day_not_written', () async {
      final repo = InMemoryStepsRepository();
      final c = make(repo);
      await c.load();
      expect(await c.saveGoal(10000), SaveGoalOutcome.appliedNow);
      final saves = repo.saveCount;
      now = t(14, 23, 59, 59);
      expect(c.canChangeGoal, isFalse);
      expect(c.remainingGoalQuota, 0);
      expect(await c.saveGoal(12000), SaveGoalOutcome.quotaExceeded);
      expect(repo.saveCount, saves);
      expect(repo.stored.latestGoal, 10000);
      expect(c.latestGoal, 10000);
    });

    test('S2_error_storage_failure_keeps_goal_and_quota_then_retry_works',
        () async {
      final repo = InMemoryStepsRepository();
      final c = make(repo);
      await c.load();
      repo.failSaves = true;
      expect(await c.saveGoal(10000), SaveGoalOutcome.storageError);
      expect(c.activeGoal, 8000);
      expect(c.canChangeGoal, isTrue, reason: 'ให้ลองกดบันทึกซ้ำได้');
      repo.failSaves = false;
      expect(await c.saveGoal(10000), SaveGoalOutcome.appliedNow);
      expect(c.activeGoal, 10000);
    });
  });

  group('EC-2 ดึงค่าล่าสุดจาก Local Storage', () {
    test('EC2_reload_same_day_shows_last_saved_steps', () async {
      SharedPreferences.setMockInitialValues({});
      final a = make(SharedPrefsStepsRepository());
      await a.load();
      await a.addSteps(4200);
      expect(await a.saveGoal(10000), SaveGoalOutcome.appliedNow);

      // ปิดเครื่อง/แบตหมด แล้วเปิดใหม่ในรอบวันเดียวกัน
      now = t(14, 18);
      final b = make(SharedPrefsStepsRepository());
      await b.load();
      expect(b.steps, 4200);
      expect(b.activeGoal, 10000);
      expect(b.canChangeGoal, isFalse, reason: 'โควต้าเก็บใน Local Storage');
      expect(b.countText, '4,200 / 10,000 ก้าว');
    });

    test('EC2_AC6_reopen_after_05_00_starts_new_day_at_0', () async {
      SharedPreferences.setMockInitialValues({
        StepsStorageKeys.currentSteps: 7000,
        StepsStorageKeys.currentDay: '2026-10-13',
        StepsStorageKeys.dailyGoal: 8000,
        StepsStorageKeys.lastSeenAt: t(13, 21).toIso8601String(),
      });
      now = t(14, 6);
      final c = make(SharedPrefsStepsRepository());
      await c.load();
      expect(c.steps, 0);
      expect(c.petStatus, StepsPetStatus.fat);
    });

    test('EC2_reopen_at_04_59_59_still_previous_day_steps', () async {
      SharedPreferences.setMockInitialValues({
        StepsStorageKeys.currentSteps: 7000,
        StepsStorageKeys.currentDay: '2026-10-13',
        StepsStorageKeys.dailyGoal: 8000,
        StepsStorageKeys.lastSeenAt: t(13, 21).toIso8601String(),
      });
      now = t(14, 4, 59, 59);
      final c = make(SharedPrefsStepsRepository());
      await c.load();
      expect(c.steps, 7000);
    });

    test('REQ7_pet_status_enum_stored_with_doc_codes', () async {
      SharedPreferences.setMockInitialValues({});
      final c = make(SharedPrefsStepsRepository());
      await c.load();
      await c.addSteps(8000);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(StepsStorageKeys.petStatus), 'MUSCLE');
    });
  });

  group('EDGE ข้อมูลว่าง / ข้อมูลเสีย', () {
    test('EDGE_first_run_empty_storage_shows_initial_state', () async {
      SharedPreferences.setMockInitialValues({});
      final c = make(SharedPrefsStepsRepository());
      await c.load();
      expect(c.isLoaded, isTrue);
      expect(c.steps, 0);
      expect(c.activeGoal, 8000);
      expect(c.latestGoal, 8000);
      expect(c.percentText, '0%');
      expect(c.countText, '0 / 8,000 ก้าว');
      expect(c.petStatus, StepsPetStatus.fat);
      expect(c.energyBarFraction, 0);
      expect(c.canChangeGoal, isTrue);
    });

    test('EDGE_corrupted_storage_wrong_types_does_not_crash', () async {
      SharedPreferences.setMockInitialValues({
        StepsStorageKeys.currentSteps: 'abc',
        StepsStorageKeys.currentDay: 123,
        StepsStorageKeys.dailyGoal: 'eight thousand',
        StepsStorageKeys.pendingGoal: true,
        StepsStorageKeys.hasUserGoal: 'yes',
        StepsStorageKeys.goalChangeDay: 'not-a-date',
        StepsStorageKeys.goalChangeCount: 'x',
        StepsStorageKeys.lastSeenAt: 'garbage',
        StepsStorageKeys.historyLog: '{not json',
      });
      final c = make(SharedPrefsStepsRepository());
      await c.load();
      expect(c.isLoaded, isTrue);
      expect(c.steps, 0);
      expect(c.activeGoal, 8000);
      expect(c.canChangeGoal, isTrue);
      expect(c.monthlyReport().totalSteps, 0);
      // ยังใช้งานต่อได้
      expect(await c.addSteps(1000), AddStepsOutcome.added);
      expect(c.steps, 1000);
    });

    test('EDGE_corrupted_history_items_skipped_valid_items_kept', () async {
      SharedPreferences.setMockInitialValues({
        StepsStorageKeys.currentSteps: 0,
        StepsStorageKeys.currentDay: '2026-10-14',
        StepsStorageKeys.historyLog:
            '[{"date":"2026-10-12","steps":5000,"goal":8000},'
                '{"date":"bad"},7,{"date":"2026-10-13","steps":"x","goal":8000}]',
      });
      final c = make(SharedPrefsStepsRepository());
      await c.load();
      expect(c.monthlyReport().totalSteps, 5000);
    });

    test('EDGE_stored_negative_steps_clamped_to_0', () async {
      SharedPreferences.setMockInitialValues({
        StepsStorageKeys.currentSteps: -500,
        StepsStorageKeys.currentDay: '2026-10-14',
        StepsStorageKeys.goalChangeCount: -3,
      });
      final c = make(SharedPrefsStepsRepository());
      await c.load();
      expect(c.steps, 0);
      expect(c.remainingGoalQuota, 1);
    });

    test('EDGE_ASSUMPTION_stored_goal_outside_6000_15000_falls_back_to_default',
        () async {
      for (final bad in [5999, 15001, 0, -8000]) {
        SharedPreferences.setMockInitialValues({
          StepsStorageKeys.dailyGoal: bad,
          StepsStorageKeys.currentDay: '2026-10-14',
        });
        final c = make(SharedPrefsStepsRepository());
        await c.load();
        expect(c.activeGoal, 8000, reason: 'stored $bad');
      }
    });

    test('EDGE_repository_throws_starts_empty_without_crash', () async {
      final c = make(ThrowingRepository());
      await c.load();
      expect(c.isLoaded, isTrue);
      expect(c.steps, 0);
      expect(c.activeGoal, 8000);
      // บันทึกลงเครื่องล้มเหลว → ไม่ crash
      expect(await c.addSteps(500), AddStepsOutcome.added);
      expect(await c.saveGoal(10000), SaveGoalOutcome.storageError);
    });
  });

  group('AC-6 / EC-5 ผ่าน controller', () {
    test('EC5_refresh_day_resets_at_05_00_00_without_reload', () async {
      final repo = InMemoryStepsRepository();
      now = t(14, 4, 59, 0);
      final c = make(repo);
      await c.load();
      await c.addSteps(8500);
      now = t(14, 4, 59, 59);
      await c.refreshDay();
      expect(c.steps, 8500);
      now = t(14, 5, 0, 0);
      await c.refreshDay();
      expect(c.steps, 0);
      expect(c.percentText, '0%');
      expect(repo.stored.steps, 0, reason: 'บันทึกการรีเซ็ตลงเครื่อง');
    });
  });

  group('AC-7 export ผ่าน controller', () {
    test('AC7_export_passes_png_bytes_to_exporter', () async {
      final exporter = InMemoryStepsReportExporter();
      final c = StepsController(
        repository: InMemoryStepsRepository(),
        exporter: exporter,
        clock: () => now,
      );
      await c.load();
      final png = [137, 80, 78, 71, 13, 10, 26, 10];
      final path =
          await c.exportMonthlyReportPng(Uint8List.fromList(png));
      expect(exporter.saved.single, png);
      expect(path, endsWith('.png'));
    });

    test('AC7_export_failure_throws_for_ui_error_state', () async {
      final exporter = InMemoryStepsReportExporter()..fail = true;
      final c = StepsController(
        repository: InMemoryStepsRepository(),
        exporter: exporter,
        clock: () => now,
      );
      await c.load();
      expect(c.exportMonthlyReportPng(Uint8List.fromList([1, 2, 3])),
          throwsA(anything));
    });
  });
}
