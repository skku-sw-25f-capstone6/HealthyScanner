import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/component/scan_mode_button.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';

class ScanController extends GetxController {
  final NavigationController _nav = Get.find<NavigationController>();

  final Rx<ScanMode> mode = ScanMode.ingredient.obs;

  CameraController? cameraController;
  Future<void>? initializeControllerFuture;
  final RxBool isTakingPicture = false.obs;

  final RxnString lastImagePath = RxnString();

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        return;
      }

      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      cameraController = controller;
      initializeControllerFuture = controller.initialize();
      update(); // GetBuilder용
    } catch (e) {
      debugPrint('카메라 초기화 실패: $e');
    }
  }

  /// 🔹 스캔 모드 변경
  void changeMode(ScanMode newMode) {
    mode.value = newMode;
  }

  /// 🔹 셔터 눌렀을 때
  Future<void> takePicture() async {
    final controller = cameraController;
    if (controller == null ||
        !controller.value.isInitialized ||
        isTakingPicture.value) {
      return;
    }

    isTakingPicture.value = true;
    try {
      final XFile file = await controller.takePicture();
      debugPrint('사진 저장 경로: ${file.path}');

      lastImagePath.value = file.path;

      _nav.goToScanCheck(
        imagePath: file.path,
        mode: mode.value,
      );
    } catch (e) {
      debugPrint('사진 촬영 실패: $e');
    } finally {
      isTakingPicture.value = false;
    }
  }

  /// 🔹 갤러리에서 사진 선택
  Future<void> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
      );

      if (image == null) {
        debugPrint('갤러리 선택 취소됨');
        return;
      }

      debugPrint('갤러리에서 선택한 이미지 경로: ${image.path}');
      lastImagePath.value = image.path;

      _nav.goToScanCheck(
        imagePath: image.path,
        mode: mode.value,
      );
    } catch (e) {
      debugPrint('갤러리 열기 실패: $e');
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
