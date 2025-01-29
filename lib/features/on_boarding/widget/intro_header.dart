import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget introHeader(BuildContext context) {
  return Positioned(
    top: 0,
    child: SizedBox(
      width: 100.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Assets.splash.logo.image(width: 120, height: 150, fit: BoxFit.cover),
          TextButton(
              onPressed: () {
                // debugPrint("RUN");
                HelpersUtils.navigatorState(context).pushNamedAndRemoveUntil(
                  AppPage.home,
                  (route) => false,
                );
              },
              child: Text(
                'Skip',
                style: AppTextTheme.lightTextTheme.bodyMedium
                    ?.copyWith(color: AppColors.backgroundLight),
              ))
        ],
      ),
    ),
  );
}
