import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:healthy_scanner/controller/scan_controller.dart';
import 'package:healthy_scanner/component/scan_mode_button.dart';

class ScanWaitingController extends GetxController {
  final RxBool requested = false.obs;

  late final Uint8List imageBytes;
  late final ScanMode mode;
  late final String? barcode;
  late final String? ocrText;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;

    final Uint8List? bytes = args?['imageBytes'] as Uint8List?;
    imageBytes = bytes ?? Uint8List(0);
    mode = (args?['mode'] as ScanMode?) ?? ScanMode.ingredient;
    barcode = args?['barcode'] as String?;
    ocrText = args?['text'] as String?;
  }

  @override
  void onReady() {
    super.onReady();
    _requestOnce();
  }

  Future<void> _requestOnce() async {
    if (requested.value) return;
    requested.value = true;

    if (imageBytes.isEmpty) return;

    final scanController = Get.find<ScanController>();
    await scanController.requestAnalyzeToServer(
      imageBytes: imageBytes,
      mode: mode,
      barcode: barcode,
      nutritionLabel: ocrText,
    );
  }
}
