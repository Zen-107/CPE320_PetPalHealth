/// ส่วนที่ steps ต้องพึ่งภายนอก (ประวัติน้ำของ water, การบันทึกไฟล์ PNG)
/// แยกเป็น interface เพื่อให้ QA inject ตัวปลอมได้โดยไม่ต้องมี platform channel
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import '../water/water_controller.dart';
import '../water/water_models.dart';
import '../water/water_repository.dart';
import 'steps_logic.dart';

// -----------------------------------------------------------------------------
// ประวัติน้ำดื่ม (AC-7 "น้ำดื่มรวม") — อ่านอย่างเดียว ไม่แก้พฤติกรรมของ water
// -----------------------------------------------------------------------------

abstract class WaterHistorySource {
  Future<List<DailyWaterRecord>> loadHistory();
}

/// อ่านจาก WaterController ที่ใช้อยู่ในแอป (ข้อมูลเดียวกับที่ water บันทึกลงเครื่อง)
class ControllerWaterHistorySource implements WaterHistorySource {
  ControllerWaterHistorySource(this.controller);

  final WaterController controller;

  @override
  Future<List<DailyWaterRecord>> loadHistory() async {
    if (!controller.isLoaded) await controller.load();
    return controller.state.history;
  }
}

/// อ่านตรงจาก WaterRepository (เช่น SharedPrefsWaterRepository)
class RepositoryWaterHistorySource implements WaterHistorySource {
  RepositoryWaterHistorySource(this.repository);

  final WaterRepository repository;

  @override
  Future<List<DailyWaterRecord>> loadHistory() async =>
      (await repository.load()).history;
}

/// ค่าคงที่ (ใช้ทดสอบ)
class FixedWaterHistorySource implements WaterHistorySource {
  FixedWaterHistorySource([this.history = const []]);

  List<DailyWaterRecord> history;
  bool fail = false;

  @override
  Future<List<DailyWaterRecord>> loadHistory() async {
    if (fail) throw StateError('simulated water history failure');
    return history;
  }
}

// -----------------------------------------------------------------------------
// บันทึกไฟล์ PNG (AC-7)
// -----------------------------------------------------------------------------

abstract class StepsReportExporter {
  /// บันทึก PNG ลงเครื่อง คืน path ของไฟล์ — throw ถ้าไม่สำเร็จ
  Future<String> savePng(
    Uint8List pngBytes, {
    required int year,
    required int month,
  });
}

/// บันทึกเป็นไฟล์ในโฟลเดอร์เอกสารของแอป
// ASSUMPTION: "ดาวน์โหลด/บันทึกเข้าเครื่อง" (AC-7) = เขียนไฟล์ลงโฟลเดอร์ Documents ของแอป
// (path_provider) ไม่บันทึกลง Gallery เพราะต้องขอสิทธิ์/เพิ่ม package — รอยืนยัน
class FileStepsReportExporter implements StepsReportExporter {
  FileStepsReportExporter({Future<Directory> Function()? directory})
      : _directory = directory ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _directory;

  @override
  Future<String> savePng(
    Uint8List pngBytes, {
    required int year,
    required int month,
  }) async {
    if (pngBytes.isEmpty) throw StateError('empty PNG');
    final dir = await _directory();
    final file = File(
        '${dir.path}${Platform.pathSeparator}${StepsLogic.reportFileName(year, month)}');
    await file.writeAsBytes(pngBytes, flush: true);
    return file.path;
  }
}

/// เก็บ bytes ในหน่วยความจำ (ใช้ทดสอบ) — ตั้ง [fail] เพื่อจำลองสร้างไฟล์ไม่สำเร็จ
class InMemoryStepsReportExporter implements StepsReportExporter {
  final List<Uint8List> saved = [];
  bool fail = false;

  @override
  Future<String> savePng(
    Uint8List pngBytes, {
    required int year,
    required int month,
  }) async {
    if (fail) throw StateError('simulated export failure');
    saved.add(pngBytes);
    return 'memory://${StepsLogic.reportFileName(year, month)}';
  }
}
