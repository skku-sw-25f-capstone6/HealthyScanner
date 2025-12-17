import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:healthy_scanner/data/archive_response.dart';
import 'package:healthy_scanner/data/archive_api.dart';
import 'package:healthy_scanner/controller/auth_controller.dart';

class ArchiveListController extends GetxController {
  final selectedDate = DateTime.now().obs;
  final items = <ScanHistoryItem>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> load(DateTime date) async {
    selectedDate.value = date;
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final auth = Get.find<AuthController>();
      final jwt = auth.appAccess.value ?? '';
      if (jwt.isEmpty) throw Exception('JWT is missing');

      final result = await fetchScanHistory(
        baseHost: 'healthy-scanner.com',
        date: date,
        jwt: jwt,
      );

      final resolved = result.map((it) {
        return ScanHistoryItem(
          name: it.name,
          category: it.category,
          summary: it.summary,
          url: _resolveUrl('healthy-scanner.com', it.url),
          riskLevel: it.riskLevel,
        );
      }).toList();

      for (final item in resolved) {
        debugPrint('🧾 ${item.name}');
        debugPrint('  url: ${item.url}');
      }

      items.assignAll(resolved);
    } catch (e) {
      errorMessage.value = e.toString();
      items.clear();
    } finally {
      isLoading.value = false;
    }
  }

  String _resolveUrl(String baseHost, String raw) {
    final p = raw.trim();
    if (p.isEmpty) return p;

    if (p.startsWith('http://') || p.startsWith('https://')) return p;

    final path = p.startsWith('/') ? p : '/$p';

    return Uri.https(baseHost, path).toString();
  }
}
