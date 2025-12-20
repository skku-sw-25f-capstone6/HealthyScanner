import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:healthy_scanner/controller/auth_controller.dart';
import 'package:healthy_scanner/controller/analysis_result_controller.dart';
import 'package:healthy_scanner/data/scan_history_patch_request.dart';
import 'package:healthy_scanner/data/scan_history_api.dart';

class AnalysisEditController extends GetxController {
  final String scanId;
  final String initialName;

  AnalysisEditController({
    required this.scanId,
    required this.initialName,
  });

  final nameTEC = TextEditingController();

  final isSaving = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    nameTEC.text = initialName;
  }

  @override
  void onClose() {
    nameTEC.dispose();
    super.onClose();
  }

  bool get canSave => nameTEC.text.trim().isNotEmpty;

  Future<void> save() async {
    final newName = nameTEC.text.trim();
    if (newName.isEmpty) {
      error.value = "상품명을 입력해주세요.";
      return;
    }

    isSaving.value = true;
    error.value = null;

    try {
      final auth = Get.find<AuthController>();
      final token = auth.appAccess.value;
      if (token == null || token.isEmpty) {
        throw Exception("토큰이 없어요. 다시 로그인 해주세요.");
      }

      final requestId = const Uuid().v4();

      final res = await ScanHistoryApi.patchScanHistoryName(
        scanId: scanId,
        accessToken: token,
        requestId: requestId,
        body: ScanHistoryPatchRequest(
          name: newName,
          category: "Uncategorized",
        ),
      );

      final result = Get.find<AnalysisResultController>();
      final cur = result.detail.value;
      if (cur != null) {
        await result.fetch();
      }

      Get.back(result: res.name);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isSaving.value = false;
    }
  }
}
