import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';
import 'package:healthy_scanner/controller/auth_controller.dart';

/// 로그인 메인 화면
/// ------------------------------------------------------------
/// 현재는 소셜 로그인 API(카카오, 네이버)가 아직 등록되지 않았기 때문에,
/// 로그인 버튼을 누르면 곧바로 “홈 화면(아카이브 캘린더)”으로 이동하도록 임시 설정함.
/// 추후 실제 로그인 API 연동 후, 성공 콜백에서 nav.goToArchiveCalendar()를 호출하면 됨.
/// ------------------------------------------------------------
class LoginMainView extends StatelessWidget {
  const LoginMainView({super.key});

  @override
  Widget build(BuildContext context) {
    // NavigationController 인스턴스 가져오기
    final nav = Get.find<NavigationController>();
     //✅ AuthController 인스턴스 가져오기
    final auth = Get.find<AuthController>(); 
   

    return Scaffold(
      backgroundColor: AppColors.mainRed,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 309),

            // 앱 로고 영역
            const Center(
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                width: 162,
                height: 66,
              ),
            ),

            const Spacer(),

            // ----------------------------
            // 🔹 소셜 로그인 버튼 영역
            // ----------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(38, 0, 38, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// ✅ 카카오 로그인 버튼
                  /// 현재는 로그인 성공 로직 없이 바로 홈으로 이동함.
                  SocialLoginButton(
                    label: '카카오로 로그인',
                    background: AppColors.kakaoYellow,
                    labelStyle: const TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      letterSpacing: 0,
                      wordSpacing: 1.3,
                    ),
                    leading: const Image(
                      image: AssetImage("assets/icons/ic_kakao.png"),
                      width: 14,
                      height: 13,
                    ),
                    onPressed: () async{
                      await auth.loginWithKakao();
                      // TODO: 카카오 로그인 API 연동 예정
                      // nav.goToHome(); // ✅ 임시로 홈으로 이동
                    },
                  ),
                  const SizedBox(height: 7),

                  /// ✅ 네이버 로그인 버튼
                  /// 현재는 카카오 버튼과 동일하게 홈으로 이동만 수행.
                  SocialLoginButton(
                    label: '네이버로 로그인',
                    background: AppColors.naverGreen,
                    labelStyle: const TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      letterSpacing: 0,
                      wordSpacing: 1.3,
                    ),
                    leading: const Image(
                      image: AssetImage("assets/icons/ic_naver.png"),
                      width: 29,
                      height: 29,
                    ),
                    onPressed: () {
                      // TODO: 네이버 로그인 API 연동 예정
                      nav.goToHome(); // ✅ 임시로 홈으로 이동
                    },
                  ),
                  const SizedBox(height: 20),

                  /// 문의 링크 텍스트
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // TODO: 문의 페이지 연결 (예: 이메일, 피드백 폼 등)
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        '문제가 있나요?',
                        style: context.caption2Regular
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 소셜 로그인 버튼 위젯
/// ------------------------------------------------------------
/// [label] 버튼에 표시할 텍스트
/// [background] 버튼 배경색
/// [labelStyle] 텍스트 스타일
/// [leading] 왼쪽 아이콘 (플랫폼 로고 등)
/// [onPressed] 버튼 클릭 시 실행할 콜백
/// ------------------------------------------------------------
class SocialLoginButton extends StatelessWidget {
  final String label;
  final Color background;
  final TextStyle labelStyle;
  final Widget leading;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.background,
    required this.labelStyle,
    required this.leading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(7),
        onTap: onPressed,
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(7),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000), // 25% black shadow
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 7),
              SizedBox(width: 28, height: 28, child: Center(child: leading)),
              const SizedBox(width: 67),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: labelStyle,
                ),
              ),
              const SizedBox(width: 103),
            ],
          ),
        ),
      ),
    );
  }
}
