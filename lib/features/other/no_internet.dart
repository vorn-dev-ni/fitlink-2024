import 'package:app_settings/app_settings.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/screen_text.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.backgroundLight,
          ),
          backgroundColor: AppColors.backgroundLight,
          body: Padding(
            padding: const EdgeInsets.all(Sizes.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.app.noInternetCat.image(
                  width: 100.w,
                  fit: BoxFit.cover,
                  height: 40.h,
                ),
                const SizedBox(
                  height: Sizes.xl,
                ),
                Text(
                  ScreenText.nointernetScreen['title'],
                  style: AppTextTheme.lightTextTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor),
                ),
                const SizedBox(
                  height: Sizes.md,
                ),
                Text(
                  textAlign: TextAlign.center,
                  ScreenText.nointernetScreen['desc'],
                  style: AppTextTheme.lightTextTheme.labelLarge
                      ?.copyWith(color: AppColors.secondaryColor),
                ),
                const SizedBox(
                  height: Sizes.xl,
                ),
                ButtonApp(
                    height: 2.h,
                    splashColor: const Color.fromARGB(255, 207, 225, 255),
                    label: ScreenText.nointernetScreen['button'],
                    onPressed: _handleOpenSetting,
                    // radius: Sizes.lg,
                    textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                        color: AppColors.backgroundLight,
                        fontWeight: FontWeight.normal) as dynamic,
                    color: AppColors.secondaryColor,
                    textColor: Colors.white,
                    elevation: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _handleOpenSetting() async {
    DeviceUtils.isAndroid()
        ? await AppSettings.openAppSettingsPanel(AppSettingsPanelType.wifi)
        : await AppSettings.openAppSettings(type: AppSettingsType.wifi);
  }
}
