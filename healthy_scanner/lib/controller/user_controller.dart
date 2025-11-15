/*import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataController extends GetxController {
  var diet = ''.obs;
  var diseases = <String>[].obs;
  var allergies = <String>[].obs;

  /// ✅ SharedPreferences에 저장
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('diet', diet.value);
    await prefs.setStringList('diseases', diseases);
    await prefs.setStringList('allergies', allergies);
  }

  /// ✅ SharedPreferences에서 불러오기
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    diet.value = prefs.getString('diet') ?? '';
    diseases.value = prefs.getStringList('diseases') ?? [];
    allergies.value = prefs.getStringList('allergies') ?? [];
  }

  /// ✅ 전체 초기화 (로그아웃 시)
  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('diet');
    await prefs.remove('diseases');
    await prefs.remove('allergies');
    diet.value = '';
    diseases.clear();
    allergies.clear();
  }
}
*/