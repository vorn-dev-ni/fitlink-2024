import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget emptyContent({required String title}) {
  return SizedBox(
    width: 90.w,
    height: 50.h,
    child: Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.app.catGym.image(height: 250, fit: BoxFit.cover),
          // SvgPicture.asset(
          //   Assets.icon.svg.notFound,
          //   height: 300,
          // ),
          Text(
            title,
            style: AppTextTheme.lightTextTheme.labelLarge
                ?.copyWith(color: AppColors.secondaryColor),
          )
        ],
      ),
    )),
  );
}
