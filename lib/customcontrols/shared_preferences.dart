import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static late SharedPreferences _prefs;
  static String KEY_USERNAME = "username";
  static String KEY_USERID = "userid";
  static String KEY_ORGNAME = "orgname";
  static String KEY_ORGCODE = "orgcode";
  static String KEY_USERALLOWRECIEPTID = "userallowedrecieptid";
  static String KEY_TOKEN = "token";
  static String KEY_TOKENEXP = "tokenexp";
  static String KEY_ORGID = "orgid";

  static Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveString(String key, String value) async {
    await _initPrefs();
    await _prefs.setString(key, value);
  }

  static String loadString(String key) {
    return _prefs.getString(key) ?? "";
  }

  static void removeString() {
    _prefs.getKeys().forEach((key) {
      _prefs.remove(key);
    });
  }

  static Set<String> getallstring() {
    return _prefs.getKeys();
  }
}
