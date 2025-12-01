import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import '../routes/app_routes.dart';
import '../component/scan_mode_button.dart';
import 'package:healthy_scanner/view/login/kakao_login_webview.dart';

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
  void goToScanFail() => Get.toNamed(AppRoutes.scanFail);

  /// ✅ 홈(로그인 등)으로 돌아가기
  void backToHome() => Get.offAllNamed(AppRoutes.loginMain);

  /// ✅ 홈 → 마이페이지
  void goToMyPage() => Get.toNamed(AppRoutes.myPage);
  void goToMyPageDietEdit() => Get.toNamed(AppRoutes.myPageDietEdit);
  void goToMyPageDiseaseEdit() => Get.toNamed(AppRoutes.myPageDiseaseEdit);
  void goToMyPageAllergyEdit() => Get.toNamed(AppRoutes.myPageAllergyEdit);
  void goToAnalysisResult() => Get.toNamed(AppRoutes.analysisResult);

  /// ✅ 뒤로가기
  void goBack() => Get.back();
  //void goToOnboarding() => Get.offAllNamed(AppRoutes.onboarding);
  void goToHome() => Get.offAllNamed(AppRoutes.home);
  void goToScanReady() => Get.toNamed(AppRoutes.scanReady);

  /// ✅ 로그아웃 (데이터 초기화 + 메인 이동)
  void logout() {
    // TODO: 여기에 SharedPref, Token 제거 등의 로직 추가 가능
    debugPrint('👋 로그아웃 완료');
    Get.offAllNamed(AppRoutes.loginMain);
  }
}

void goToAnalysisResult() {
  debugPrint('🚀 goToAnalysisResult() 호출됨');
  Get.toNamed(AppRoutes.analysisResult);
}
