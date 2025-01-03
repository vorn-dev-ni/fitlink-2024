import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageUtils {
  late SharedPreferences _sharedPreferences;

  // Private static variable to hold the instance
  static final LocalStorageUtils _instance = LocalStorageUtils._internal();

  // Private constructor
  LocalStorageUtils._internal();

  // Factory constructor to return the singleton instance
  factory LocalStorageUtils() {
    return _instance;
  }

  Future clear() async {
    await _sharedPreferences.clear();
  }

  Future<LocalStorageUtils> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> setKeyString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  String? getKey(String key) {
    return _sharedPreferences.getString(key);
  }
}
