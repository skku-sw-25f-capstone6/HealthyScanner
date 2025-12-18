import 'package:get_storage/get_storage.dart';

class OnboardingStore {
  OnboardingStore._();
  static final _box = GetStorage();

  static String _key(String? userKey) => userKey == null
      ? 'onboarding_completed'
      : 'onboarding_completed_$userKey';

  static bool isCompleted({String? userKey}) {
    return _box.read(_key(userKey)) == true;
  }

  static Future<void> setCompleted(bool value, {String? userKey}) async {
    await _box.write(_key(userKey), value);
  }

  static Future<void> clear({String? userKey}) async {
    await _box.remove(_key(userKey));
  }
}
