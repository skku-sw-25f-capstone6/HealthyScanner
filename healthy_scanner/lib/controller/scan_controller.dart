import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/component/scan_mode_button.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';
import 'package:healthy_scanner/controller/auth_controller.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:healthy_scanner/data/scan_api.dart';
import 'package:dio/dio.dart';
import 'package:healthy_scanner/data/scan_fail_payload.dart';

class ScanController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  late final ScanApi _scanApi = ScanApi(baseUrl: 'https://healthy-scanner.com');

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
      update();
    } catch (e) {
      debugPrint('❌ [Camera] Failed to Initialize: $e');
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
      debugPrint('📷 [Camera] Saved Image Path: ${file.path}');

      lastImagePath.value = file.path;

      _nav.goToScanCrop(
        imagePath: file.path,
        mode: mode.value,
      );
    } catch (e) {
      debugPrint('❌ [Camera] Failed to Take a Picture: $e');
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
        debugPrint('🖼️ [Gallery] Cancel to Open Gallery');
        return;
      }

      debugPrint('🖼️ [Gallery] Selected Image Path: ${image.path}');
      lastImagePath.value = image.path;

      _nav.goToScanCrop(
        imagePath: image.path,
        mode: mode.value,
      );
    } catch (e) {
      debugPrint('❌ [Gallery] Failed to Open Gallery: $e');
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  /// 🔹 크롭된 이미지를 받아서 모드에 따라 분석 + 다음 화면 이동
  Future<void> handleCroppedImage(
    Uint8List imageBytes, {
    required ScanMode mode,
  }) async {
    String? barcodeValue;
    String? ocrText;

    try {
      if (mode == ScanMode.barcode) {
        debugPrint('🔍 [Barcode] Starting barcode scan...');
        barcodeValue = await _scanBarcode(imageBytes);
        debugPrint('🔍 [Barcode] Result: $barcodeValue');
      } else if (mode == ScanMode.ingredient) {
        debugPrint('📝 [OCR] Starting text recognition...');

        ocrText = await _recognizeText(imageBytes);

        // ---- Null 또는 빈 문자열 처리 ----
        if (ocrText == null || ocrText.trim().isEmpty) {
          debugPrint('📝 [OCR] No text recognized (null or empty).');
          _nav.goToScanFail(const ScanFailPayload(
            title: '사진을 인식할 수 없어요',
            message: '사진을 다시 촬영해 주세요',
          ));
        } else {
          // ---- 정상 OCR 결과 처리 ----
          final flattened =
              ocrText.replaceAll('\n', ' ').replaceAll('\r', ' ').trim();

          final previewLength = flattened.length > 200 ? 200 : flattened.length;

          debugPrint(
            '📝 [OCR] Sample text: ${flattened.substring(0, previewLength)}',
          );
        }
      }
    } catch (e, s) {
      debugPrint('❌ [Analyze] Error: $e');
      debugPrint('❌ [Analyze] Stacktrace: $s');
    }

    _nav.goToScanWaiting(
      imageBytes: imageBytes,
      mode: mode,
      barcode: barcodeValue,
      text: ocrText,
    );
  }

  /// 🔸 바코드 분석
  Future<String?> _scanBarcode(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File(
      '${tempDir.path}/cropped_barcode_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await tempFile.writeAsBytes(bytes);

    final inputImage = InputImage.fromFile(tempFile);

    final barcodeScanner = BarcodeScanner(
      formats: [
        BarcodeFormat.ean13,
        BarcodeFormat.ean8,
      ],
    );

    try {
      final barcodes = await barcodeScanner.processImage(inputImage);
      if (barcodes.isEmpty) return null;
      return barcodes.first.rawValue;
    } finally {
      await barcodeScanner.close();
      // 필요시 tempFile 삭제
      // await tempFile.delete();
    }
  }

  /// 🔸 텍스트 인식
  Future<String?> _recognizeText(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File(
      '${tempDir.path}/cropped_text_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await tempFile.writeAsBytes(bytes);

    final inputImage = InputImage.fromFile(tempFile);
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.korean,
    );

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } finally {
      await textRecognizer.close();
      // await tempFile.delete();
    }
  }

  /// 🔸 결과 분석
  Future<void> requestAnalyzeToServer({
    required Uint8List imageBytes,
    required ScanMode mode,
    String? barcode,
    String? nutritionLabel,
  }) async {
    try {
      final jwt = _auth.jwt.value;
      if (jwt == null || jwt.isEmpty) throw Exception('JWT is missing');

      late final ScanAnalyzeResponse result;

      switch (mode) {
        case ScanMode.barcode:
          result = await _scanApi.analyzeBarcodeImage(
            jwt: jwt,
            imageBytes: imageBytes,
            barcode: barcode,
          );
          break;

        case ScanMode.ingredient:
          final label = (nutritionLabel ?? '').trim();
          if (label.isEmpty) {
            // "텍스트 인식 불가"로 보고 싶다면 여기서 payload로 처리해도 됨
            throw Exception('nutrition_label is empty');
          }
          result = await _scanApi.analyzeNutritionLabel(
            jwt: jwt,
            imageBytes: imageBytes,
            nutritionLabel: label,
          );
          break;

        case ScanMode.image:
          result = await _scanApi.analyzeImageOnly(
            jwt: jwt,
            imageBytes: imageBytes,
          );
          break;
      }

      _nav.goToAnalysisResult(scanId: result.scanId);
    } catch (e, s) {
      debugPrint('❌ [API] analyze failed: $e');
      debugPrint('❌ [API] stack: $s');

      final payload = _mapErrorToPayload(e);

      if (payload.forceLogout) {
        await Get.find<AuthController>().logout();
        return;
      }

      _nav.goToScanFail(payload);
    }
  }

  ScanFailPayload _mapErrorToPayload(Object e) {
    // 1) DioException (서버코드/타임아웃/네트워크)
    if (e is DioException) {
      // 타임아웃
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const ScanFailPayload(
          title: '대기 시간이 초과되었어요',
          message: '잠시후 다시 시도해 주세요',
        );
      }

      // 네트워크 에러
      if (e.type == DioExceptionType.connectionError) {
        return const ScanFailPayload(
          title: '서버에 연결할 수 없어요',
          message: '인터넷 연결을 확인해 주세요',
        );
      }

      final status = e.response?.statusCode;

      // 401: 토큰 검증 에러 (+로그아웃)
      if (status == 401) {
        return const ScanFailPayload(
          title: '잘못된 접근이에요',
          message: '다시 로그인 해 주세요',
          forceLogout: true,
        );
      }

      // 404: 바코드 정보 없음
      if (status == 404) {
        final data = e.response?.data;
        final detail =
            (data is Map) ? data['detail']?.toString() : data?.toString();

        if (detail != null && detail.contains('Product not found')) {
          return const ScanFailPayload(
            title: '바코드를 불러올 수 없어요',
            message: '성분표를 직접 촬영해 주세요',
            suggestIngredientMode: true,
          );
        }

        return const ScanFailPayload(
          title: '오류가 발생했어요',
          message: '사진을 다시 촬영해 주세요',
        );
      }

      // 500: 서버 로직 에러
      if (status == 500) {
        return const ScanFailPayload(
          title: '서버 에러가 발생했어요',
          message: '잠시후 다시 시도해 주세요',
        );
      }

      // 422: 필드 누락/잘못된 요청
      if (status == 422 || status == 400) {
        return const ScanFailPayload(
          title: '잘못된 요청이에요',
          message: '사진을 다시 촬영해 주세요',
        );
      }

      // 디폴트
      return const ScanFailPayload(
        title: '오류가 발생했어요',
        message: '사진을 다시 촬영해 주세요',
      );
    }

    // 2) 필드 누락
    final msg = e.toString();
    if (msg.contains('nutrition_label is empty')) {
      return const ScanFailPayload(
        title: '잘못된 요청이에요',
        message: '사진을 다시 촬영해 주세요',
      );
    }

    // 3) 디폴트
    return const ScanFailPayload(
      title: '오류가 발생했어요',
      message: '사진을 다시 촬영해 주세요',
    );
  }
}
