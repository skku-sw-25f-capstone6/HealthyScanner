import 'package:flutter/material.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';

class ScanWaitingView extends StatelessWidget {
  const ScanWaitingView({
    super.key,
    this.onClose,
  });

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: 사용자가 촬영한 이미지를 배경으로 띄우기
      backgroundColor: AppColors.peachRed,
      body: Stack(
        children: [
          // 상단 좌측 아이콘
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 20),
              child: GestureDetector(
                onTap: onClose ?? () => Navigator.of(context).maybePop(),
                child: Image.asset(
                  'assets/icons/ic_x.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),

          // 중앙 로딩 영역
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: 2.5,
                  child: Image.asset(
                    'assets/images/loading.gif',
                  ),
                ),
                Text(
                  '잠시만 기다려 주세요',
                  style: context.title2Medium.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  'AI가 사진을 분석중입니다.',
                  style: context.caption2Regular.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
