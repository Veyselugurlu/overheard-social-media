import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const String _onboardingKey = 'onboardingState';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool getOnboardingState() {
    return _prefs?.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingState(bool value) async {
    await _prefs?.setBool(_onboardingKey, value);
  }

  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
