import 'package:demo/common/widget/button.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

Widget renderButton(isSubmitting, Function onPress, String text) {
  return Container(
    color: AppColors.backgroundLight,
    child: ButtonApp(
        height: 14,
        splashColor: const Color.fromARGB(255, 207, 225, 255),
        label: text,
        onPressed: () {
          onPress();
        },
        radius: 0,
        textStyle: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
            color: AppColors.backgroundLight,
            fontWeight: FontWeight.w500) as dynamic,
        color: AppColors.secondaryColor,
        textColor: Colors.white,
        elevation: 0),
  );
}
