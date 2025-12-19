import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/core/api_client.dart';
import 'package:healthy_scanner/data/scan_api.dart';
import 'package:healthy_scanner/data/scan_history_detail_response.dart';

class AnalysisResultController extends GetxController {
  late final String scanId;

  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();
  final Rxn<ScanHistoryDetailResponse> detail =
      Rxn<ScanHistoryDetailResponse>();

  late final ScanApi _api = ScanApi(dioClient: ApiClient.dioClient);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;

    scanId = (args?['scanId'] ?? '').toString();
    if (scanId.isEmpty) {
      isLoading.value = false;
      error.value = 'scanId is missing';
      return;
    }

    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    error.value = null;

    try {
      final res = await _api.getScanHistoryDetails(scanId: scanId);
      detail.value = res;
    } catch (e) {
      debugPrint('❌ [AnalysisResultController] fetch failed: $e');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
