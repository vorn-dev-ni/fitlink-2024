import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

Widget HoriButtonIcon({
  required String label,
  required Function onPress,
  required Widget icon,
  Color? themeColor,
}) {
  return Column(
    children: [
      IconButton(
          style: IconButton.styleFrom(
              backgroundColor: AppColors.backgroundLight,
              overlayColor: themeColor?.withOpacity(0.2)),
          onPressed: () {
            onPress();
          },
          icon: icon),
      Text(
        label,
        style:
            AppTextTheme.lightTextTheme.bodyMedium?.copyWith(color: themeColor),
      )
    ],
  );
}
