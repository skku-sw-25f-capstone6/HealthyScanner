import 'package:get/get.dart';
import '../routes/app_routes.dart';

/// 📍 모든 페이지 전환 및 온보딩 상태를 중앙에서 관리하는 컨트롤러
class NavigationController extends SuperController {
  // ------------------------
  // 🔹 LifeCycle Hooks
  // ------------------------
  @override
  void onInit() {
    super.onInit();
    print('✅ NavigationController initialized');
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
    print('🔄 Page changed → $route');
  }

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

  /// ✅ 스플래시 → 로그인
  void goToLogin() => Get.offAllNamed(AppRoutes.loginMain);

  /// ✅ 로그인 실패 → 실패 페이지
  void goToLoginFail() => Get.toNamed(AppRoutes.loginFail);

  /// ✅ 로그인 성공 → 온보딩 (기존 홈 → 온보딩으로 수정됨)
  void goToArchiveCalendar() => Get.offAllNamed(AppRoutes.onboardingAgree);

  /// ✅ 아카이브 캘린더 → 아카이브 리스트
  void goToArchiveList() => Get.toNamed(AppRoutes.archiveList);

  /// ✅ 스캔 준비 → 대기 화면
  void goToScanWaiting() => Get.toNamed(AppRoutes.scanWaiting);

  /// ✅ 스캔 대기 → 결과 확인
  void goToScanCheck() => Get.offAllNamed(AppRoutes.scanCheck);

  /// ✅ 스캔 실패 → 실패 페이지
  void goToScanFail() => Get.toNamed(AppRoutes.scanFail);

  /// ✅ 홈(로그인 등)으로 돌아가기
  void backToHome() => Get.offAllNamed(AppRoutes.loginMain);

  /// ✅ 뒤로가기
  void goBack() => Get.back();

  /// ✅ 홈으로 이동
  void goToHome() => Get.offAllNamed(AppRoutes.home);

  /// ✅ 스캔 준비로 이동
  void goToScanReady() => Get.toNamed(AppRoutes.scanReady);
  /// ✅ 마이페이지 관련 네비게이션
  void goToMyPage() => Get.toNamed(AppRoutes.myPage);
  void goToMyPageDietEdit() => Get.toNamed(AppRoutes.myPageDietEdit);
  void goToMyPageDiseaseEdit() => Get.toNamed(AppRoutes.myPageDiseaseEdit);
  void goToMyPageAllergyEdit() => Get.toNamed(AppRoutes.myPageAllergyEdit);
  void goToAnalysisResult() => Get.toNamed(AppRoutes.analysisResult);
  
  
  /// ✅ 로그아웃
  void logout() {
    print('👋 로그아웃 완료');
    Get.offAllNamed(AppRoutes.loginMain);
  }
}

void goToAnalysisResult() {
  print('🚀 goToAnalysisResult() 호출됨');
  Get.toNamed(AppRoutes.analysisResult);
}