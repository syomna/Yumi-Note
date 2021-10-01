import 'package:shared_preferences/shared_preferences.dart';

class CacheData {
  static SharedPreferences? prefs;

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool>? setBool(String key, bool value) =>
      prefs?.setBool(key, value);

  static bool? getBool(String key) => prefs?.getBool(key);
}
