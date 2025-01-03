import 'package:demo/common/widget/button.dart';
import 'package:demo/core/riverpod/app_setting.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/theme/schema.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:demo/utils/localization/translation_helper.dart';

class AboutScreen extends ConsumerStatefulWidget {
  AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    final appSettings = ref.watch(appSettingsControllerProvider);
    return SizedBox(
      height: 100.h,
      child: Column(
        children: [
          SizedBox(
            height: 25.h,
          ),
          Center(
            child: SizedBox(
              width: 50.w,
              child: ButtonApp(
                label: tr(context).toggle_theme,
                textStyle: AppTextTheme.getTextTheme(appSettings.appTheme!)
                    .bodyMedium!
                    .copyWith(
                      color: appSettings.appTheme! == AppTheme.light
                          ? AppColors.backgroundLight
                          : AppColors.backgroundDark,
                    ),
                splashColor: AppColors.primaryLight,
                color: appSettings.appTheme! == AppTheme.dark
                    ? AppColors.backgroundLight
                    : const Color.fromARGB(255, 36, 69, 123),
                onPressed: () {
                  ref
                      .read(appSettingsControllerProvider.notifier)
                      .updateAppTheme();
                },
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 50.w,
              child: ButtonApp(
                label: tr(context).khmer,
                textStyle: AppTextTheme.getTextTheme(appSettings.appTheme!)
                    .bodyMedium!
                    .copyWith(
                      color: appSettings.appTheme! == AppTheme.dark
                          ? AppColors.backgroundLight
                          : AppColors.backgroundLight,
                    ),
                splashColor: AppColors.primaryLight,
                color: appSettings.appTheme! == AppTheme.dark
                    ? AppColors.primaryColor
                    : AppColors.primaryLight,
                onPressed: () {
                  ref
                      .read(appSettingsControllerProvider.notifier)
                      .updateLocalization('km');
                },
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 50.w,
              child: ButtonApp(
                label: tr(context).english,
                textStyle: AppTextTheme.getTextTheme(appSettings.appTheme!)
                    .bodyMedium!
                    .copyWith(
                      color: appSettings!.appTheme! == AppTheme.dark
                          ? AppColors.backgroundLight
                          : AppColors.backgroundLight,
                    ),
                splashColor: AppColors.primaryLight,
                color: SchemaData.getAppTheme(appSettings.appTheme!)
                    .primaryColorDark,
                onPressed: () {
                  ref
                      .read(appSettingsControllerProvider.notifier)
                      .updateLocalization('en');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
