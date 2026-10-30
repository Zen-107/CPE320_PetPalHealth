/// ตัวกลางระหว่าง logic เกมกับ UI ของฟีเจอร์ food
///
/// controller ถือสถานะชั่วคราว EATING / OVER_LIMIT_FEEDING (EATING_ANIMATION_DURATION) และ
/// Toast (TOAST_DURATION) เอง — widget สัตว์เลี้ยงไม่จับเวลา (ui-spec §4, character.md §6)
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../shared/pet/pet_pose.dart' show PetPose;
import '../signup/signup_models.dart' show SignupGender, UserProfile;
import 'food_logic.dart';
import 'food_models.dart';
import 'food_nutrition_parser.dart';
import 'food_profile_source.dart';
import 'food_repository.dart';
import 'food_rules.dart';

typedef FoodClock = DateTime Function();

/// สร้าง Timer — inject ตัวปลอมในเทสต์ที่ไม่ใช่ widget test เพื่อสั่งให้หมดเวลาเองได้
typedef FoodTimerFactory = Timer Function(
  Duration duration,
  void Function() callback,
);

Timer _defaultTimer(Duration d, void Function() cb) => Timer(d, cb);

/// ผลการกด「บันทึกข้อมูล」ใน S-2
enum MealSubmitOutcome {
  /// บันทึกแล้ว → กลับ S-1
  logged,

  /// AI Parsing Failure / Offline / เกิน AI_PARSING_TIMEOUT → S-2 Error (EC-1)
  parseFailed,

  /// ค่าแคลอรี่ที่กรอกเองอ่านไม่ได้
  invalidCalories,

  /// ยังโหลดไม่เสร็จ / กำลังบันทึกอยู่
  notReady,
}

/// ผลการบันทึก S-3
enum FoodProfileSaveOutcome { saved, invalid, failed }

class FoodController extends ChangeNotifier {
  FoodController({
    required this._repository,
    FoodProfileSource? profileSource,
    FoodNutritionParser? parser,
    FoodClock? clock,
    FoodTimerFactory? timerFactory,
  }) : _profileSource = profileSource ?? InMemoryFoodProfileSource(),
       _parser = parser ?? LocalMenuNutritionParser(),
       _clock = clock ?? DateTime.now,
       _timer = timerFactory ?? _defaultTimer;

  final FoodRepository _repository;
  final FoodProfileSource _profileSource;
  final FoodNutritionParser _parser;
  final FoodClock _clock;
  final FoodTimerFactory _timer;

  FoodState _state = FoodState.initial;
  UserProfile? _profile;
  bool _isLoaded = false;
  bool _busy = false;
  bool _disposed = false;

  FoodPetState? _transient;
  Timer? _transientTimer;
  String? _toastMessage;
  int _toastSerial = 0;
  Timer? _toastTimer;

  // ---------------------------------------------------------------------------
  // ค่าสำหรับ UI
  // ---------------------------------------------------------------------------

  FoodState get state => _state;
  bool get isLoaded => _isLoaded;

  /// โปรไฟล์จาก signup (null = ยังไม่มี)
  UserProfile? get profile => _profile;

  /// ผู้ใช้กด「ข้ามไปก่อน」(US-3)
  bool get profileSkipped => _state.profileSkipped;

  /// `target_calories` — null = ไม่มีเป้าหมาย → CTA Banner (AC-8, EC-4, Q-9)
  int? get targetCalories => FoodLogic.targetForProfile(_profile);
  bool get hasTarget => targetCalories != null;
  bool get showsProfileCta => !hasTarget;

  /// Q-13: เปิด S-3 ให้เองเฉพาะตอนยังไม่มีโปรไฟล์และยังไม่เคยกดข้าม
  bool get needsProfileSetup =>
      _isLoaded && _profile == null && !_state.profileSkipped;

  int get totalCalories => _state.totalCalories;

  /// หลอดแดง + ป้าย「อิ่มแล้ว」 — ตามข้อมูลจริงทันที (Q-5 DECIDED owner: ไม่รอท่า)
  bool get isOverLimit => FoodLogic.isOverLimit(totalCalories, targetCalories);
  bool get showsFullBadge => isOverLimit;

  /// สถานะสัตว์เลี้ยงที่แสดง (รวมท่าชั่วคราว)
  FoodPetState get petState =>
      _transient ?? FoodLogic.basePetState(totalCalories, targetCalories);
  PetPose get petPose => FoodLogic.poseFor(petState);

  double get energyFraction {
    final t = targetCalories;
    return t == null ? 0 : FoodLogic.energyFraction(totalCalories, t);
  }

  /// `'<total> / <target> kcal'` — null เมื่อไม่มีเป้าหมาย
  String? get calorieText {
    final t = targetCalories;
    return t == null ? null : FoodLogic.calorieText(totalCalories, t);
  }

  String get ctaTotalText => FoodLogic.ctaTotalText(totalCalories);

  /// Toast ที่แสดงอยู่ (null = ไม่มี) — ทีละ 1 ข้อความ (AC-12)
  String? get toastMessage => _toastMessage;

  /// เพิ่มทุกครั้งที่มี Toast ใหม่ (Queue replace — EC-2)
  int get toastSerial => _toastSerial;

  // ---------------------------------------------------------------------------
  // โหลด / รอบวัน
  // ---------------------------------------------------------------------------

  Future<void> load() async {
    FoodState loaded;
    try {
      loaded = await _repository.load();
    } catch (_) {
      // ASSUMPTION: อ่านข้อมูลไม่ได้ → เริ่มเป็นค่าว่าง แอปไม่ล่ม
      loaded = FoodState.initial;
    }
    _state = loaded;
    await _loadProfile();
    _isLoaded = true;
    await refreshDay();
    _notify();
  }

  /// อ่านโปรไฟล์จาก signup ใหม่ (เรียกตอนกลับเข้าหน้า S-1)
  Future<void> refreshProfile() async {
    await _loadProfile();
    _notify();
  }

  Future<void> _loadProfile() async {
    try {
      _profile = await _profileSource.load();
    } catch (_) {
      // ASSUMPTION: อ่านโปรไฟล์ไม่ได้ → ถือว่าไม่มีเป้าหมาย (CTA Banner)
      _profile = null;
    }
  }

  /// ตรวจว่าข้าม 05:00 น. หรือยัง ถ้าใช่รีเซ็ตเป็น 0 kcal (game-rules §4 Foreground Crossing)
  /// เรียกตอนเปิดหน้า, กลับมา foreground และเป็นระยะขณะเปิดหน้าค้าง
  Future<void> refreshDay() async {
    if (!_isLoaded) return;
    final next = FoodLogic.applyDayRollover(
      _state,
      _clock(),
      targetCalories: targetCalories,
    );
    if (identical(next, _state)) return;
    _state = next;
    _notify();
    await _trySave();
  }

  // ---------------------------------------------------------------------------
  // S-2 บันทึกมื้ออาหาร (AC-1, AC-2, AC-3, EC-1, AC-11, AC-12, EC-2, EC-3)
  // ---------------------------------------------------------------------------

  /// "AI Parsing" ภายใน AI_PARSING_TIMEOUT — null = ล้มเหลว/ออฟไลน์/หมดเวลา (EC-1)
  Future<FoodNutrition?> analyzeMeal(String text) async {
    try {
      final raw = await _parser
          .parse(text)
          .timeout(const Duration(seconds: FoodRules.aiParsingTimeoutSeconds));
      return FoodLogic.parseNutritionJson(raw);
    } catch (_) {
      return null;
    }
  }

  /// S-2 สถานะปกติ: ประมวลผลข้อความเมนูแล้วบันทึก
  // ASSUMPTION: ช่องเมนูว่าง (ui-spec Q-12 ปุ่มยัง enabled) → ประมวลผลไม่ได้ = EC-1
  Future<MealSubmitOutcome> submitMeal(String text) async {
    if (!_isLoaded || _busy) return MealSubmitOutcome.notReady;
    _busy = true;
    try {
      final nutrition = await analyzeMeal(text);
      if (nutrition == null) return MealSubmitOutcome.parseFailed;
      await _log(nutrition, manual: false);
      return MealSubmitOutcome.logged;
    } finally {
      _busy = false;
    }
  }

  /// S-2 สถานะผิดพลาด/ออฟไลน์: บันทึกค่าที่กรอกเอง — ว่าง = 300 kcal (EC-1)
  Future<MealSubmitOutcome> submitManual(String rawCalories) async {
    if (!_isLoaded || _busy) return MealSubmitOutcome.notReady;
    final calories = FoodLogic.manualCalories(rawCalories);
    if (calories == null) return MealSubmitOutcome.invalidCalories;
    _busy = true;
    try {
      await _log(FoodNutrition(calories: calories), manual: true);
      return MealSubmitOutcome.logged;
    } finally {
      _busy = false;
    }
  }

  /// บันทึกผลโภชนาการ 1 มื้อ (ใช้ตรงในเทสต์ได้)
  Future<void> logNutrition(FoodNutrition nutrition, {bool manual = false}) {
    if (!_isLoaded) return Future.value();
    return _log(nutrition, manual: manual);
  }

  Future<void> _log(FoodNutrition nutrition, {required bool manual}) async {
    final target = targetCalories;
    final now = _clock();
    // ตรวจรอบวันก่อน แล้วจึงดูว่า "ก่อนบันทึก" อยู่ในสถานะเกินเป้าหรือไม่ (AC-11)
    final rolled = FoodLogic.applyDayRollover(
      _state,
      now,
      targetCalories: target,
    );
    final wasOver = FoodLogic.isOverLimit(rolled.totalCalories, target);
    _state = FoodLogic.logMeal(
      rolled,
      nutrition,
      now,
      targetCalories: target,
      manual: manual,
    );
    // ไม่เพิ่ม cheerTrigger — ท่ากินคือ reaction (ui-spec §4)
    // Q-4 (ค่าชั่วคราว ui-spec): บันทึกซ้อนระหว่างท่าชั่วคราว → เริ่มท่าใหม่ตามการบันทึกล่าสุด
    _startTransient(FoodLogic.transientStateForLog(wasOverLimit: wasOver));
    final toast = FoodLogic.toastForLog(wasOverLimit: wasOver);
    if (toast != null) showToast(toast);
    _notify();
    await _trySave();
  }

  void _startTransient(FoodPetState state) {
    _transientTimer?.cancel();
    _transient = state;
    _transientTimer = _timer(FoodLogic.transientDuration(state), () {
      _transientTimer = null;
      _transient = null;
      _notify();
    });
  }

  /// แสดง Toast เหนือสัตว์เลี้ยง — ข้อความใหม่แทนที่ทันทีและนับ TOAST_DURATION ใหม่ (AC-12, EC-2)
  void showToast(String message) {
    _toastTimer?.cancel();
    _toastMessage = message;
    _toastSerial++;
    _toastTimer = _timer(const Duration(seconds: FoodRules.toastSeconds), () {
      _toastTimer = null;
      _toastMessage = null;
      _notify();
    });
    _notify();
  }

  // ---------------------------------------------------------------------------
  // S-3 โปรไฟล์ (AC-4..AC-7, EC-5, US-3)
  // ---------------------------------------------------------------------------

  Future<FoodProfileSaveOutcome> saveProfile({
    required String age,
    required SignupGender? gender,
    required String weight,
    required String height,
  }) async {
    final v = FoodLogic.validateProfile(
      age: age,
      gender: gender,
      weight: weight,
      height: height,
    );
    if (!v.canSave || gender == null) return FoodProfileSaveOutcome.invalid;
    UserProfile? saved;
    try {
      saved = await _profileSource.save(
        FoodProfileInput(
          age: int.parse(age.trim()),
          gender: gender,
          weightKg: double.parse(weight.trim()),
          heightCm: double.parse(height.trim()),
        ),
      );
    } catch (_) {
      saved = null;
    }
    if (saved == null) return FoodProfileSaveOutcome.failed;
    _profile = saved;
    if (_state.profileSkipped) {
      _state = _state.copyWith(profileSkipped: false);
      await _trySave();
    }
    _notify();
    return FoodProfileSaveOutcome.saved;
  }

  /// 「ข้ามไปก่อน」 — บันทึกสถานะข้ามโปรไฟล์ (US-3)
  Future<void> skipProfile() async {
    _state = _state.copyWith(profileSkipped: true);
    _notify();
    await _trySave();
  }

  // ---------------------------------------------------------------------------

  Future<void> _trySave() async {
    try {
      await _repository.save(_state);
    } catch (_) {
      // ASSUMPTION: บันทึกลงเครื่องไม่สำเร็จ → คงค่าในหน่วยความจำ แล้วบันทึกซ้ำครั้งถัดไป
      // (ux-flow ไม่มี UI error สำหรับกรณีนี้)
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _transientTimer?.cancel();
    _toastTimer?.cancel();
    super.dispose();
  }
}
