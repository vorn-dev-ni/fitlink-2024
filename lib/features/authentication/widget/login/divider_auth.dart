import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget dividerAuth() {
  return SizedBox(
    width: 100.w,
    child: Row(
      children: [
        SizedBox(
          height: Sizes.buttonHeightLg,
        ),
        const Expanded(
          child: Divider(
            color: AppColors.neutralColor,
            height: 1,
          ),
        ),
        Text(
          'or sign in with',
          style: AppTextTheme.lightTextTheme.labelMedium
              ?.copyWith(color: const Color(0xffBDBDBD)),
        ),
        Expanded(
          child: Divider(
            color: AppColors.neutralColor,
            height: 1,
          ),
        ),
      ],
    ),
  );
}
