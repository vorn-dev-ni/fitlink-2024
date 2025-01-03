import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class FirebaseRemoteConfigService {
  late FirebaseRemoteConfig _firebaseRemoteConfig;

  static final FirebaseRemoteConfigService _instance =
      FirebaseRemoteConfigService._internal();
  Stream<dynamic> get onConfigUpdated => _firebaseRemoteConfig.onConfigUpdated;
  FirebaseRemoteConfigService._internal();

  FirebaseRemoteConfig get remoteConfigInstance => _firebaseRemoteConfig;
  factory FirebaseRemoteConfigService() {
    return _instance;
  }

  Future init() async {
    _firebaseRemoteConfig = FirebaseRemoteConfig.instance;
    await _firebaseRemoteConfig.setDefaults(const {
      "banner_tag": "Welcome Gym Bro",
      "social_login": false,
      "showPopup": false,
    });
    await _firebaseRemoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 2),
      minimumFetchInterval: const Duration(minutes: 15),
    ));

    // await _remoteConfigActivate();
    await activateRemoteConfig();
  }

  Future activateRemoteConfig() async {
    bool? isfetch = await _firebaseRemoteConfig.fetchAndActivate();
    if (kDebugMode) {
      print("remote config is inital ${isfetch}");
    }
  }

  double? getDouble(String key) {
    return _firebaseRemoteConfig.getDouble(key);
  }

  RemoteConfigValue? getValue(String key) {
    return _firebaseRemoteConfig.getValue(key);
  }

  bool? getBoolean(String key) {
    return _firebaseRemoteConfig.getBool(key);
  }

  String? getString(String key) {
    return _firebaseRemoteConfig.getString(key);
  }
}
