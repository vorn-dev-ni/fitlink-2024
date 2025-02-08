import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

Widget userSocialMediaTab(
    {required String floatingText, required String type}) {
  return Column(
    children: [
      Text(
        floatingText,
        style: AppTextTheme.lightTextTheme.labelLarge
            ?.copyWith(color: AppColors.backgroundLight),
      ),
      Text(
        type,
        style: AppTextTheme.lightTextTheme.labelMedium
            ?.copyWith(color: AppColors.backgroundLight),
      ),
    ],
  );
}
