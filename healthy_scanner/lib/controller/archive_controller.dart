import 'package:get/get.dart';
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
      final String jwt = auth.jwt.value ?? '';
      if (jwt.isEmpty) throw Exception('JWT is missing');

      final result = await fetchScanHistory(
        baseHost: 'healthy-scanner.com',
        date: date,
        jwt: jwt,
      );

      items.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
      items.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
