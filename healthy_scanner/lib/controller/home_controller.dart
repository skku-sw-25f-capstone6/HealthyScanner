import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:healthy_scanner/data/home_api.dart';
import 'package:healthy_scanner/data/home_response.dart';
import 'package:healthy_scanner/controller/auth_controller.dart';

class HomeController extends GetxController {
  HomeController(this._api);

  final HomeApi _api;
  late final AuthController _auth = Get.find<AuthController>();

  Worker? _jwtWorker;

  final isLoading = false.obs;
  final errorMessage = RxnString();

  final todayScore = 0.obs;
  final scanItems = <ScanItem>[].obs;

  @override
  void onInit() {
    super.onInit();

    _jwtWorker = ever<String?>(_auth.appAccess, (jwt) {
      if (jwt != null && jwt.isNotEmpty) {
        fetchHome();
      }
    });

    final jwt = _auth.appAccess.value;
    if (jwt != null && jwt.isNotEmpty) {
      fetchHome();
    }
  }

  @override
  void onClose() {
    _jwtWorker?.dispose();
    super.onClose();
  }

  Future<void> fetchHome() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final auth = Get.find<AuthController>();
      final jwt = auth.appAccess.value;
      if (jwt == null || jwt.isEmpty) throw Exception('JWT is missing');

      final reqId = const Uuid().v4();
      final res = await _api.fetchHome(jwt: jwt, requestId: reqId);
      debugPrint(
          'home res score=${res.todayScore}, firstName=${res.scan.firstOrNull?.name}, firstUrl=${res.scan.firstOrNull?.url}');

      todayScore.value = res.todayScore;
      scanItems.assignAll(res.scan.take(2).toList());
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
