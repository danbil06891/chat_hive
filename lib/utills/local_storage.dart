import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _sharedPreferences;
  static init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future saveString({required String key, required String value}) async {
    await _sharedPreferences.setString(key, value);
  }

  static Future saveInt({required String key, required int value}) async {
    await _sharedPreferences.setInt(key, value);
  }

  static Future saveBool({required String key, required bool value}) async {
    await _sharedPreferences.setBool(key, value);
  }

  static Future saveDouble({required String key, required double value}) async {
    await _sharedPreferences.setDouble(key, value);
  }

  static Future saveStringList(
      {required String key, required List<String> value}) async {
    await _sharedPreferences.setStringList(key, value);
  }

  static String getString({required String key}) {
    return _sharedPreferences.getString(key) ?? '';
  }

  static int getInt({required String key}) {
    return _sharedPreferences.getInt(key) ?? -1;
  }

  static double getDouble({required String key}) {
    return _sharedPreferences.getDouble(key) ?? 0;
  }

  static bool getBool({required String key}) {
    return _sharedPreferences.getBool(key) ?? false;
  }

  static List<String> getStringList({required String key}) {
    return _sharedPreferences.getStringList(key) ?? [];
  }

  static void removeValue({required String key}) async {
    await _sharedPreferences.remove(key);
  }

  static void clear() async {
    await _sharedPreferences.clear();
  }
}
