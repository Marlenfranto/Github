import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Save a string value to SharedPreferences
  static Future<void> saveString(String value, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Load a string value from SharedPreferences
  static Future<String> loadString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  static Future<void> clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
