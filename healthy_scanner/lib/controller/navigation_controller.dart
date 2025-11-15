import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../component/scan_mode_button.dart';

/// 📍 모든 페이지 전환을 중앙에서 관리하는 컨트롤러
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

  /// ✅ 스캔 준비 → 대기 화면
  void goToScanWaiting() => Get.toNamed(AppRoutes.scanWaiting);

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

  /// ✅ 스캔 실패 → 실패 페이지
  void goToScanFail() => Get.toNamed(AppRoutes.scanFail);

  /// ✅ 홈(로그인 등)으로 돌아가기
  void backToHome() => Get.offAllNamed(AppRoutes.loginMain);

  /// ✅ 홈 → 마이페이지
  void goToMyPage() => Get.toNamed(AppRoutes.myPage);

  /// ✅ 뒤로가기
  void goBack() => Get.back();
  //void goToOnboarding() => Get.offAllNamed(AppRoutes.onboarding);
  void goToHome() => Get.offAllNamed(AppRoutes.home);
  void goToScanReady() => Get.toNamed(AppRoutes.scanReady);

  /// ✅ 로그아웃 (데이터 초기화 + 메인 이동)
  void logout() {
    // TODO: 여기에 SharedPref, Token 제거 등의 로직 추가 가능
    print('👋 로그아웃 완료');
    Get.offAllNamed(AppRoutes.loginMain);
  }
}
