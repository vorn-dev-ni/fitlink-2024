import 'package:demo/utils/constant/image_asset.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

Widget appLoadingSpinner() {
  return SizedBox.fromSize(
    size: Size(double.maxFinite, 70.h),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          ImageAsset.lottiesloadng,
          alignment: Alignment.center,
          fit: BoxFit.cover,
          width: 100.px,
          height: 100.px,
        ),
        Text(
          'Please wait......',
          style: AppTextTheme.lightTextTheme.bodyLarge,
        )
      ],
    ),
  );
}
