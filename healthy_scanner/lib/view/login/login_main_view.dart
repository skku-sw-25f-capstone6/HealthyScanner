import 'package:flutter/material.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';

class LoginMainView extends StatelessWidget {
  const LoginMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainRed,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 309),

            // 로고
            const Center(
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                width: 162,
                height: 66,
              ),
            ),

            const Spacer(),

            // 소셜 로그인 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(38, 0, 38, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SocialLoginButton(
                    label: '카카오로 로그인',
                    background: AppColors.kakaoYellow,
                    labelStyle: const TextStyle(
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        letterSpacing: 0,
                        wordSpacing: 1.3),
                    leading: const Image(
                      image: AssetImage("assets/icons/ic_kakao.png"),
                      width: 14,
                      height: 13,
                    ),
                    onPressed: () {
                      // TODO: 카카오 로그인 로직
                    },
                  ),
                  const SizedBox(height: 7),
                  SocialLoginButton(
                    label: '네이버로 로그인',
                    background: AppColors.naverGreen,
                    labelStyle: const TextStyle(
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        letterSpacing: 0,
                        wordSpacing: 1.3),
                    leading: const Image(
                      image: AssetImage("assets/icons/ic_naver.png"),
                      width: 29,
                      height: 29,
                    ),
                    onPressed: () {
                      // TODO: 네이버 로그인 로직
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // TODO: 문의 페이지로 이동
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

/// 소셜 로그인 버튼
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
                color: Color(0x40000000), // 25% black
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
