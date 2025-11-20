import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/controller/scan_controller.dart';
import 'package:healthy_scanner/component/scan_mode_button.dart';
import 'package:healthy_scanner/component/round_icon_button.dart';
import 'package:healthy_scanner/component/guide_pill.dart';
import 'package:healthy_scanner/component/shutter_button.dart';

class ScanReadyView extends StatelessWidget {
  const ScanReadyView({super.key});

  String _guideText(ScanMode mode) {
    switch (mode) {
      case ScanMode.barcode:
        return '식품 바코드를 프레임 안에 맞춰주세요';
      case ScanMode.ingredient:
        return '식품 성분표를 프레임 안에 맞춰주세요';
      case ScanMode.image:
        return '식품 이미지를 프레임 안에 맞춰주세요';
    }
  }

  @override
  Widget build(BuildContext context) {
    final scan = Get.find<ScanController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: GetBuilder<ScanController>(
              builder: (_) => _buildCameraPreview(scan),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 57),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoundIconButton(
                      assetPath: 'assets/icons/ic_x.png',
                      onTap: () => Get.back(),
                    ),
                    RoundIconButton(
                      assetPath: 'assets/icons/ic_image.png',
                      onTap: scan.pickFromGallery,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Obx(
                  () => GuidePill.red(
                    _guideText(scan.mode.value),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Obx(
                  () => ScanModeButton(
                    selected: scan.mode.value,
                    onChanged: scan.changeMode,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ShutterButton(
                onTap: scan.takePicture,
              ),
              const SizedBox(height: 35),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview(ScanController scan) {
    final controller = scan.cameraController;

    if (scan.initializeControllerFuture == null || controller == null) {
      return const _CameraPlaceholder();
    }

    return FutureBuilder<void>(
      future: scan.initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                '카메라를 불러오지 못했어요',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final previewSize = controller.value.previewSize;

            if (previewSize == null) {
              return const _CameraPlaceholder();
            }

            final cameraRatio = previewSize.height / previewSize.width;

            final height = constraints.maxHeight;
            final width = height * cameraRatio;

            return FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: width,
                height: height,
                child: CameraPreview(controller),
              ),
            );
          },
        );
      },
    );
  }
}

/// 카메라 연결 전 임시 화면
class _CameraPlaceholder extends StatelessWidget {
  const _CameraPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/sample_eggs.png',
      fit: BoxFit.cover,
    );
  }
}
