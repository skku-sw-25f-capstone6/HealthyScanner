// import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import '../controller/navigation_controller.dart';

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
import '../view/myPage/myPage.dart';
import '../view/main/main_shell_view.dart';

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
  static const home = '/home';
  //static const onboarding = '/onboarding';
  static const myPage = '/myPage';

  // ----------------------
  // 📍 페이지 목록 등록
  // ----------------------
  static final pages = [
    GetPage(name: splash, page: () => const SplashView()),
    GetPage(
        name: loginMain,
        page: () => const LoginMainView(),
        transition: Transition.noTransition,
        transitionDuration: Duration.zero),
    GetPage(name: loginFail, page: () => const LoginFailView()),
    GetPage(name: archiveCalendar, page: () => const ArchiveCalendarView()),
    GetPage(name: archiveList, page: () => const ArchiveListView()),
    GetPage(name: scanCheck, page: () => const ScanCheckView()),
    GetPage(name: scanFail, page: () => const ScanFailView()),
    GetPage(
        name: scanReady,
        page: () => const ScanReadyView(),
        transition: Transition.noTransition,
        transitionDuration: Duration.zero),
    GetPage(name: scanWaiting, page: () => const ScanWaitingView()),
    GetPage(name: home, page: () => const MainShellView()),
    //GetPage(name: onboarding, page: () => const OnboardingView()),
    GetPage(name: myPage, page: () => const MyPageView()),
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
