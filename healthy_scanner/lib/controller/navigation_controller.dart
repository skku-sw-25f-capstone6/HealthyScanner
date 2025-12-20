import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import '../routes/app_routes.dart';
import '../component/scan_mode_button.dart';
import 'package:healthy_scanner/constants/onboarding_constants.dart';
import 'package:healthy_scanner/controller/auth_controller.dart';
import 'package:healthy_scanner/data/api_service.dart';
import 'package:healthy_scanner/data/scan_fail_payload.dart';
import 'package:healthy_scanner/controller/scan_controller.dart';
import 'package:healthy_scanner/controller/home_controller.dart';
import 'package:healthy_scanner/controller/mypage_controller.dart';
import 'package:healthy_scanner/view/login/kakao_login_webview.dart';
import 'package:healthy_scanner/core/onboarding_store.dart';

/// 📍 모든 페이지 전환을 중앙에서 관리하는 컨트롤러
class NavigationController extends SuperController {
  // ------------------------
  // 🔹 LifeCycle Hooks
  // ------------------------
  @override
  void onInit() {
    super.onInit();
    debugPrint('✅ NavigationController initialized');
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {}

  @override
  void onHidden() {}

  void resetState() {
    agreedPolicy.value = false;
    agreedService.value = false;

    selectedDiet.value = '';
    selectedDiseases.clear();
    selectedAllergies.clear();

    isSubmittingProfile.value = false;
  }

  // ------------------------
  // 🔹 Route Observer Hook
  // ------------------------
  void onPageChanged(String route) {
    debugPrint('🔄 Page changed → $route');
  }

  // ------------------------
  // 🔹 공용 이동 함수
  // ------------------------

  /// ✅ 스플래시 → 로그인
  void goToLogin() => Get.offAllNamed(AppRoutes.loginMain);

  /// ✅ 로그인 실패 → 실패 페이지
  void goToLoginFail() => Get.toNamed(AppRoutes.loginFail);

  /// ✅ 로그인 성공 → 아카이브 캘린더
  void goToArchiveCalendar() => Get.offAllNamed(AppRoutes.archiveCalendar);

  /// ✅ 아카이브 캘린더 → 아카이브 리스트
  void goToArchiveList() => Get.toNamed(AppRoutes.archiveList);
  // ============================================================
  // 🧭 온보딩 상태 및 유효성
  // ============================================================
  final agreedPolicy = false.obs;
  final agreedService = false.obs;
  final selectedDiet = ''.obs;
  final selectedDiseases = <String>[].obs;
  final selectedAllergies = <String>[].obs;
  final isSubmittingProfile = false.obs;

  bool get isAgreeValid => agreedPolicy.value && agreedService.value;
  bool get isDietValid => selectedDiet.isNotEmpty;
  bool get isDiseaseValid => selectedDiseases.isNotEmpty;
  bool get isAllergyValid => selectedAllergies.isNotEmpty;

  // ============================================================
  // 🔹 온보딩 이동 함수
  // ============================================================
  void goToOnboardingAgree() => Get.offAllNamed(AppRoutes.onboardingAgree);
  void goToOnboardingDiet() => Get.toNamed(AppRoutes.onboardingDiet);
  void goToOnboardingDisease() => Get.toNamed(AppRoutes.onboardingDisease);
  void goToOnboardingAllergy() => Get.toNamed(AppRoutes.onboardingAllergy);
  void goToOnboardingComplete() => Get.toNamed(AppRoutes.onboardingComplete);

  /// ✅ 온보딩 완료 후 홈 이동
  void finishOnboarding() => Get.offAllNamed(AppRoutes.home);

  Future<void> submitOnboardingProfile() async {
    if (isSubmittingProfile.value) return;

    final auth = Get.find<AuthController>();
    final token = auth.appAccess.value;
    if (token == null || token.isEmpty) {
      Get.snackbar(
        '로그인이 필요합니다',
        '다시 로그인해 주세요.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final habitPayload = OnboardingConstants.mapHabit(selectedDiet.value);
    final conditionPayload =
        OnboardingConstants.mapConditions(selectedDiseases.toList());
    final allergyPayload =
        OnboardingConstants.mapAllergies(selectedAllergies.toList());

    isSubmittingProfile.value = true;
    try {
      await Get.find<ApiService>().postOnboardingProfile(
        jwt: token,
        habits: habitPayload,
        conditions: conditionPayload,
        allergies: allergyPayload,
      );

      final auth = Get.find<AuthController>();
      final userKey = auth.userId.value;
      await OnboardingStore.setCompleted(true, userKey: userKey);

      if (Get.isRegistered<MyPageController>()) {
        final myPage = Get.find<MyPageController>();
        myPage.currentHabitKorean.value = selectedDiet.value;
        myPage.fetchMyPageInfo();
      }

      finishOnboarding();
    } catch (e) {
      debugPrint('❌ [ONBOARDING] submit failed: $e');
      Get.snackbar(
        '등록에 실패했어요',
        '네트워크 상태를 확인한 뒤 다시 시도해 주세요.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmittingProfile.value = false;
    }
  }

  /// ✅ 온보딩 중 뒤로가기
  void backOnboardingStep() => Get.back();

  // ============================================================
  // 🔹 기존 공용 이동 함수 (기존 기능 유지)
  // ============================================================
  /// ✅ 스캔 준비 → 대기 화면
  void goToScanWaiting({
    required Uint8List imageBytes,
    required ScanMode mode,
    String? barcode,
    String? text,
  }) {
    Get.toNamed(
      AppRoutes.scanWaiting,
      arguments: {
        'imageBytes': imageBytes,
        'mode': mode,
        'barcode': barcode,
        'text': text,
      },
    );
  }

  /// ✅ 스캔 대기 → 결과 확인
  void goToScanCheck({
    required String imagePath,
    required ScanMode mode,
  }) {
    Get.toNamed(
      AppRoutes.scanCheck,
      arguments: {
        'imagePath': imagePath,
        'mode': mode,
      },
    );
  }

  void goToKakaoWebView(String loginUrl) {
    Get.to(() => KakaoLoginWebView(loginUrl: loginUrl));
  }

  /// ✅ 스캔 대기 → 사진 자르기
  void goToScanCrop({
    required String imagePath,
    required ScanMode mode,
  }) {
    Get.toNamed(
      AppRoutes.scanCrop,
      arguments: {
        'imagePath': imagePath,
        'mode': mode,
      },
    );
  }

  /// ✅ 스캔 실패 → 실패 페이지
  void goToScanFail(ScanFailPayload payload) => Get.offNamed(
        AppRoutes.scanFail,
        arguments: payload.toArgs(),
      );

  /// ✅ 로그인 화면으로 돌아가기
  void backToLoginMain() => Get.offAllNamed(AppRoutes.loginMain);

  /// ✅ 홈 → 마이페이지
  void goToMyPage() => Get.toNamed(AppRoutes.myPage);
  void goToMyPageDietEdit() => Get.toNamed(AppRoutes.myPageDietEdit);
  void goToMyPageDiseaseEdit() => Get.toNamed(AppRoutes.myPageDiseaseEdit);
  void goToMyPageAllergyEdit() => Get.toNamed(AppRoutes.myPageAllergyEdit);

  /// ✅ 뒤로가기
  void goBack({bool refreshHomeIfNeeded = true}) {
    final prev = Get.previousRoute;
    final curr = Get.currentRoute;

    debugPrint('⬅️ goBack curr=$curr prev=$prev');

    Get.back();

    if (!refreshHomeIfNeeded) return;

    if (prev == AppRoutes.home) {
      Future.microtask(() {
        if (Get.isRegistered<HomeController>()) {
          debugPrint('🏠 back -> home detected. fetchHome()');
          Get.find<HomeController>().fetchHome();
        }
      });
    }
  }

  void goToHome() {
    Get.offAllNamed(AppRoutes.home);

    Future.microtask(() {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchHome();
      }
    });
  }

  void goToScanReady() => Get.toNamed(AppRoutes.scanReady);
  void replaceToScanReady({ScanMode? initialMode}) {
    if (initialMode != null) {
      Get.find<ScanController>().changeMode(initialMode);
    }
    Get.offAllNamed(AppRoutes.scanReady);
  }

  void goToAnalysisResult({required String scanId}) {
    Get.offAllNamed(AppRoutes.home);

    Future.microtask(() {
      Get.toNamed(
        AppRoutes.analysisResult,
        arguments: {'scanId': scanId},
      );
    });

    Future.microtask(() {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchHome();
      }
    });
  }

  void routeAfterLogin() {
    final auth = Get.find<AuthController>();
    final userKey = auth.userId.value;
    final completed = OnboardingStore.isCompleted(userKey: userKey);

    if (completed) {
      goToHome();
    } else {
      goToOnboardingAgree();
    }
  }
}
