import 'package:get/get.dart';

// [view import]
import '../view/splash/splash_view.dart';
import '../view/archive/archive_calendar.dart';
import '../view/archive/archive_list.dart';
import '../view/login/login_main_view.dart';
import '../view/login/login_fail_view.dart';
import '../view/scan/scan_check_view.dart';
import '../view/scan/scan_fail_view.dart';
import '../view/scan/scan_ready_view.dart';
import '../view/scan/scan_waiting_view.dart';
import '../view/home/home.dart';
import '../view/mypage/mypage_view.dart';
import '../view/mypage/mypage_diet_edit_view.dart';
import '../view/mypage/mypage_disease_edit_view.dart';
import '../view/mypage/mypage_allergy_edit_view.dart';
import '../view/analysis/analysis_result_view.dart';

// [onboarding import]
import '../view/onboarding/onboarding_agree_view.dart';
import '../view/onboarding/onboarding_diet_view.dart';
import '../view/onboarding/onboarding_disease_view.dart';
import '../view/onboarding/onboarding_allergy_view.dart';
import '../view/onboarding/onboarding_complete_view.dart';

class AppRoutes {
  // ----------------------
  // 📍 경로 상수 정의
  // ----------------------
  static const splash = '/splash/splash';
  static const archiveCalendar = '/archive/calendar';
  static const archiveList = '/archive/list';
  static const loginMain = '/login/main';
  static const loginFail = '/login/fail';
  static const scanCheck = '/scan/check';
  static const scanFail = '/scan/fail';
  static const scanReady = '/scan/ready';
  static const scanWaiting = '/scan/waiting';
  static const analysisResult = '/analysis/result';
  static const home = '/home';

  static const myPage = '/mypage';
  static const myPageDietEdit = '/mypage/diet_edit';
  static const myPageDiseaseEdit = '/mypage/disease_edit';
  static const myPageAllergyEdit = '/mypage/allergy_edit';

  // ✅ 온보딩
  static const onboardingAgree = '/onboarding/agree';
  static const onboardingDiet = '/onboarding/diet';
  static const onboardingDisease = '/onboarding/disease';
  static const onboardingAllergy = '/onboarding/allergy';
  static const onboardingComplete = '/onboarding/complete';

  // ----------------------
  // 📍 페이지 목록 등록
  // ----------------------
  static final pages = [
    GetPage(name: splash, page: () => const SplashView()),
    GetPage(name: loginMain, page: () => const LoginMainView()),
    GetPage(name: loginFail, page: () => const LoginFailView()),
    GetPage(name: archiveCalendar, page: () => const ArchiveCalendarView()),
    GetPage(name: archiveList, page: () => const ArchiveListView()),
    GetPage(name: scanCheck, page: () => const ScanCheckView()),
    GetPage(name: scanFail, page: () => const ScanFailView()),
    GetPage(name: scanReady, page: () => const ScanReadyView()),
    GetPage(name: scanWaiting, page: () => const ScanWaitingView()),
    GetPage(name: home, page: () => const HomeView()),
    GetPage(name: analysisResult, page: () => const AnalysisResultView()),


    // ✅ 온보딩 단계
    GetPage(name: onboardingAgree, page: () => const OnboardingAgreeView()),
    GetPage(name: onboardingDiet, page: () => const OnboardingDietView()),
    GetPage(name: onboardingDisease, page: () => const OnboardingDiseaseView()),
    GetPage(name: onboardingAllergy, page: () => const OnboardingAllergyView()),
    GetPage(name: onboardingComplete, page: () => const OnboardingCompleteView()),

    // ✅ 마이페이지 편집 화면
    GetPage(name: myPage, page: () => const MyPageView()),
    GetPage(name: myPageDietEdit, page: () => const MyPageDietEditView()),
    GetPage(name: myPageDiseaseEdit, page: () => const MyPageDiseaseEditView()),
    GetPage(name: myPageAllergyEdit, page: () => const MyPageAllergyEditView()),
  ];

  // ----------------------
  // 🧩 라우트 중복 검증 함수
  // ----------------------
  static void validateRoutes() {
    assert(() {
      final names = pages.map((p) => p.name).toList();
      final dupes =
          names.where((n) => names.where((x) => x == n).length > 1).toSet();
      if (dupes.isNotEmpty) {
        throw Exception('Duplicate routes found: ${dupes.join(', ')}');
      }
      return true;
    }());
  }
}
