import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:healthy_scanner/controller/scan_controller.dart';

class ScanWaitingController extends GetxController {
  final RxBool requested = false.obs;

  late final Uint8List imageBytes;
  late final String? barcode;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;

    final Uint8List? bytes = args?['imageBytes'] as Uint8List?;
    imageBytes = bytes ?? Uint8List(0);

    barcode = args?['barcode'] as String?;
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
      barcode: barcode,
    );
  }
}
