import 'dart:typed_data';
import 'package:get/get.dart';
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
    final args = Get.arguments as Map<String, dynamic>?;
    final Uint8List? imageBytes = args?['imageBytes'] as Uint8List?;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: imageBytes != null
                  ? Center(
                      child: Image.memory(
                        imageBytes,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Image.asset(
                      'assets/images/sample_eggs.png',
                      fit: BoxFit.contain,
                    ),
            ),
          ),

          Positioned.fill(
            child: Container(
              color: AppColors.staticBlack.withValues(alpha: 0.6),
            ),
          ),

          // 상단 좌측 닫기 아이콘
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 20),
              child: GestureDetector(
                onTap: onClose ?? () => Navigator.of(context).maybePop(),
                child: Image.asset(
                  'assets/icons/ic_x_white.png',
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
                  scale: 2,
                  child: Image.asset(
                    // TODO: gif 화질 개선 시 Lottie 등 활용
                    'assets/images/loading.gif',
                  ),
                ),
                Text(
                  '잠시만 기다려 주세요',
                  style: context.body2Bold.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  'AI가 사진을 분석중입니다',
                  style: context.caption1Medium.copyWith(
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
