// ignore: unrelated_type_equality_checks
import 'package:demo/common/model/app_setting_state.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_setting.g.dart';

@Riverpod(keepAlive: true)
class AppSettingsController extends _$AppSettingsController {
  @override
  AppSettingState build() {
    return getData();
  }

  void updateNotificationPermission(bool notification) {
    state = state.copyWith(receviedNotification: notification);
  }

  Future updateLocalization(String localization) async {
    state = state.copyWith(localization: localization);
    await LocalStorageUtils().setKeyString('locale', localization);
  }

  Future<void> updateAppTheme() async {
    state = state.copyWith(
        appTheme:
            state.appTheme == AppTheme.dark ? AppTheme.light : AppTheme.dark);
    await LocalStorageUtils().setKeyString('theme', state.appTheme?.name ?? "");
  }

  void updateAppPermission(
      {bool? location,
      bool? notification,
      bool? activity,
      bool? deviceSensors}) {
    state = state.copyWith(
        location_permission: location,
        device_sensor_permission: deviceSensors,
        receviedNotification: notification,
        body_sensor_permission: activity);
  }

  AppSettingState getData() {
    String? themeMode =
        LocalStorageUtils().getKey('theme') ?? AppTheme.light.name;
    String localization = LocalStorageUtils().getKey('locale') ?? 'en';
    AppTheme appTheme = themeMode == 'dark' ? AppTheme.dark : AppTheme.light;
    return AppSettingState(
      localization: localization,
      appTheme: appTheme,
    );
  }
}
