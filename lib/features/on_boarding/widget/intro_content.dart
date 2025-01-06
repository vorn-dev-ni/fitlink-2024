import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget introContent({required String title, required String body}) {
  return Padding(
    padding: const EdgeInsets.all(Sizes.xl),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.h,
        ),
        Text(
          title,
          style: AppTextTheme.lightTextTheme.bodyMedium
              ?.copyWith(color: AppColors.backgroundLight),
        ),
        Text(
          body,
          style: AppTextTheme.lightTextTheme.headlineLarge?.copyWith(
              color: AppColors.backgroundLight, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
