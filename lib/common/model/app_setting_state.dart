// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:demo/utils/constant/enums.dart';

class AppSettingState {
  String localization;
  AppTheme? appTheme;
  bool? receviedNotification;
  bool? health_permission;
  bool? location_permission;
  bool? body_sensor_permission;
  bool? device_sensor_permission;
  bool? showOnboarding;

  AppSettingState({
    this.localization = 'en',
    this.showOnboarding = true,
    this.appTheme = AppTheme.light,
    this.receviedNotification = false,
    this.health_permission = false,
    this.body_sensor_permission = false,
    this.device_sensor_permission = false,
    this.location_permission = false,
  });

  AppSettingState copyWith(
      {String? localization,
      AppTheme? appTheme,
      bool? showOnboarding,
      bool? receviedNotification,
      bool? location_permission,
      bool? device_sensor_permission,
      bool? body_sensor_permission,
      bool? health_permission}) {
    return AppSettingState(
        showOnboarding: showOnboarding ?? this.showOnboarding,
        localization: localization ?? this.localization,
        appTheme: appTheme ?? this.appTheme,
        device_sensor_permission:
            device_sensor_permission ?? this.device_sensor_permission,
        health_permission: health_permission ?? this.health_permission,
        receviedNotification: receviedNotification ?? this.receviedNotification,
        location_permission: location_permission ?? this.location_permission,
        body_sensor_permission:
            body_sensor_permission ?? this.body_sensor_permission);
  }
}
