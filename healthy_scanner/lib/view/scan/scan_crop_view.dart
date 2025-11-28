import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:healthy_scanner/component/scan_mode_button.dart';
import 'package:healthy_scanner/component/round_icon_button.dart';
import 'package:healthy_scanner/component/bottom_button.dart';
import 'package:healthy_scanner/component/guide_pill.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/controller/scan_controller.dart';

class ScanCropView extends StatefulWidget {
  const ScanCropView({super.key});

  @override
  State<ScanCropView> createState() => _ScanCropViewState();
}

class _ScanCropViewState extends State<ScanCropView> {
  late ScanMode _mode;
  late String _imagePath;

  final CropController _cropController = CropController();
  bool _isCropping = false;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>?;

    _imagePath = args?['imagePath'] as String? ?? '';
    _mode = args?['mode'] as ScanMode? ?? ScanMode.ingredient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 전체 화면을 채우는 크롭 영역
          Positioned.fill(
            child: _buildCropArea(),
          ),

          // 그 위에 올리는 UI 오버레이
          Column(
            children: [
              const SizedBox(height: 57),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RoundIconButton(
                      assetPath: 'assets/icons/ic_x.png',
                      onTap: () => Get.back(),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: GuidePill.gray('분석에 필요한 부분만 선택해 주세요'),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: ScanModeButton(
                  selected: _mode,
                  onChanged: (m) => setState(() => _mode = m),
                ),
              ),
              SafeArea(
                minimum: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                child: BottomButton(
                  text: _isCropping ? '대기 중' : '분석하기',
                  onPressed: () {
                    if (_isCropping) return;
                    _onConfirmCrop();
                  },
                ),
              ),
            ],
          ),

          // 크롭 진행 중 로딩 오버레이
          if (_isCropping)
            Container(
              color: AppColors.staticBlack,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCropArea() {
    final bytes = File(_imagePath).readAsBytesSync();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Crop(
                controller: _cropController,
                image: bytes,
                baseColor: Colors.black,
                maskColor: Colors.black.withValues(alpha: 0.6),
                withCircleUi: false,
                interactive: true,
                onCropped: _onCropped,
                initialRectBuilder: InitialRectBuilder.withBuilder(
                  (viewportRect, imageRect) {
                    const widthScale = 0.8;
                    const heightScale = 0.4;

                    final vw = viewportRect.width;
                    final vh = viewportRect.height;

                    final rectWidth = vw * widthScale;
                    final rectHeight = vh * heightScale;

                    final left = viewportRect.left + (vw - rectWidth) / 2;
                    final top = viewportRect.top + (vh - rectHeight) / 2;

                    return Rect.fromLTWH(left, top, rectWidth, rectHeight);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onConfirmCrop() {
    setState(() => _isCropping = true);
    _cropController.crop();
  }

  void _onCropped(CropResult result) async {
    setState(() => _isCropping = false);

    if (result is CropSuccess) {
      final croppedImage = result.croppedImage;
      debugPrint('cropped image size: ${croppedImage.lengthInBytes} bytes');

      final scanController = Get.find<ScanController>();

      // 🔹 분석 + 네비게이션은 컨트롤러에 위임
      await scanController.handleCroppedImage(
        croppedImage,
        mode: _mode,
      );
    } else if (result is CropFailure) {
      debugPrint('이미지 크롭 실패: ${result.cause}');
    }
  }
}
