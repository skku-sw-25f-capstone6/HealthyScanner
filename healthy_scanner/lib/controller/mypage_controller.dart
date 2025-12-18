import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/constants/onboarding_constants.dart';
import 'package:healthy_scanner/controller/auth_controller.dart';
import 'package:healthy_scanner/data/api_service.dart';
import 'package:healthy_scanner/data/my_page_info_response.dart';

class MyPageController extends GetxController {
  MyPageController(this._api);

  final ApiService _api;
  late final AuthController _auth = Get.find<AuthController>();

  final profileInfo = Rxn<MyPageInfoResponse>();
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final isUpdatingHabit = false.obs;
  final currentHabitKorean = OnboardingConstants.defaultDietLabel.obs;
  final currentConditionsKorean = <String>[].obs;
  final currentAllergiesKorean = <String>[].obs;
  final isUpdatingConditions = false.obs;
  final isUpdatingAllergies = false.obs;

  Worker? _jwtWorker;

  @override
  void onInit() {
    super.onInit();

    _jwtWorker = ever<String?>(_auth.appAccess, (jwt) {
      if (jwt == null || jwt.isEmpty) {
        profileInfo.value = null;
        errorMessage.value = '로그인이 필요합니다.';
      } else {
        fetchMyPageInfo();
      }
    });

    final jwt = _auth.appAccess.value;
    if (jwt != null && jwt.isNotEmpty) {
      fetchMyPageInfo();
    }
  }

  @override
  void onClose() {
    _jwtWorker?.dispose();
    super.onClose();
  }

  Future<void> fetchMyPageInfo() async {
    final token = _auth.appAccess.value;
    if (token == null || token.isEmpty) {
      errorMessage.value = '로그인이 필요합니다.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final info = await _api.fetchMyPageInfo(jwt: token);
      profileInfo.value = info;
      final habitLabel = OnboardingConstants.habitCodeToLabel(info.habit);
      if (habitLabel != null && habitLabel.isNotEmpty) {
        currentHabitKorean.value = habitLabel;
      }
      currentConditionsKorean.assignAll(
        OnboardingConstants.conditionCodesToLabels(info.conditions),
      );
      currentAllergiesKorean.assignAll(
        OnboardingConstants.allergyCodesToLabels(info.allergies),
      );
    } catch (e) {
      debugPrint('❌ [MyPage] fetch failed: $e');
      errorMessage.value = '마이페이지 정보를 불러오지 못했어요.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateHabit(String koreanHabit) async {
    if (isUpdatingHabit.value) return false;

    final token = _auth.appAccess.value;
    if (token == null || token.isEmpty) {
      Get.snackbar(
        '로그인이 필요합니다',
        '다시 로그인해 주세요.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isUpdatingHabit.value = true;
    try {
      await _api.updateHabit(jwt: token, koreanHabit: koreanHabit);
      currentHabitKorean.value = koreanHabit;
      Get.snackbar(
        '저장 완료',
        '식습관 정보가 업데이트되었어요.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      debugPrint('❌ [MyPage] update habit failed: $e');
      Get.snackbar(
        '저장에 실패했어요',
        '네트워크 상태를 확인한 뒤 다시 시도해 주세요.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isUpdatingHabit.value = false;
    }
  }

  Future<bool> updateConditions(List<String> koreanConditions) async {
    if (isUpdatingConditions.value) return false;
    final token = _auth.appAccess.value;
    if (token == null || token.isEmpty) {
      return false;
    }

    isUpdatingConditions.value = true;
    try {
      await _api.updateConditions(
        jwt: token,
        koreanConditions: koreanConditions,
      );
      currentConditionsKorean.assignAll(koreanConditions);
      return true;
    } catch (e) {
      debugPrint('❌ [MyPage] update conditions failed: $e');
      return false;
    } finally {
      isUpdatingConditions.value = false;
    }
  }

  Future<bool> updateAllergies(List<String> koreanAllergies) async {
    if (isUpdatingAllergies.value) return false;
    final token = _auth.appAccess.value;
    if (token == null || token.isEmpty) {
      return false;
    }

    isUpdatingAllergies.value = true;
    try {
      await _api.updateAllergies(
        jwt: token,
        koreanAllergies: koreanAllergies,
      );
      currentAllergiesKorean.assignAll(koreanAllergies);
      return true;
    } catch (e) {
      debugPrint('❌ [MyPage] update allergies failed: $e');
      return false;
    } finally {
      isUpdatingAllergies.value = false;
    }
  }
}
