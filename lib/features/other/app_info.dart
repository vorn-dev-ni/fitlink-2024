import 'package:demo/common/widget/error_fallback.dart';
import 'package:demo/core/riverpod/app_setting.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:demo/utils/localization/translation_helper.dart';

class AppInfo extends ConsumerStatefulWidget {
  const AppInfo({
    super.key,
  });

  @override
  ConsumerState<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends ConsumerState<AppInfo> {
  late Future<PackageInfo> _result;
  String deviceName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDevicename();
    _result = _checkAppinfo();
  }

  Future<void> getDevicename() async {
    final resultName = await DeviceUtils.getDeviceName();
    setState(() {
      deviceName = resultName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = ref.watch(appSettingsControllerProvider);

    return FutureBuilder(
      future: _result,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final appInfo = snapshot.data;

            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: Sizes.lg,
                  ),
                  Text(deviceName),
                  Text(
                    'App ${appInfo?.packageName}',
                    style: AppTextTheme.getTextTheme(appSettings.appTheme!)
                        .bodySmall,
                  ),
                  Text(
                    'App Version Code ${appInfo?.version}',
                    style: AppTextTheme.getTextTheme(appSettings.appTheme!)
                        .bodySmall,
                  ),
                  Text(
                    'App build Number ${appInfo?.buildNumber}',
                    style: AppTextTheme.getTextTheme(appSettings.appTheme!)
                        .bodySmall,
                  ),
                  Text(
                    'App build Number ${appInfo?.installerStore}',
                    style: AppTextTheme.getTextTheme(appSettings.appTheme!)
                        .bodySmall,
                  ),
                ],
              ),
            );
          }
        }

        if (snapshot.hasError) {
          return errorFallback(
              cb: () {},
              AppException(
                title: "Oops",
                message: snapshot.error.toString(),
              ));
        }

        return const Text('');
      },
    );
  }

  Future<PackageInfo> _checkAppinfo() async {
    return await DeviceUtils.getAppInfoPackage();
  }
}
