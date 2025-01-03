import 'package:demo/common/widget/button.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget errorFallback(AppException appError, {required void cb()}) {
  return SizedBox(
    height: 80.h,
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            appError.title,
            style: AppTextTheme.lightTextTheme.titleLarge?.copyWith(
                color: AppColors.errorColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: Sizes.md,
          ),
          Text(
            appError.message,
            textAlign: TextAlign.center,
            style: AppTextTheme.lightTextTheme.labelLarge
                ?.copyWith(color: AppColors.errorColor),
          ),
          const SizedBox(
            height: Sizes.lg,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonApp(
                      splashColor: const Color.fromARGB(255, 255, 171, 164)
                          .withOpacity(0.1),
                      label: 'Retry',
                      onPressed: cb,
                      radius: Sizes.lg,
                      textStyle: AppTextTheme.lightTextTheme.bodyMedium
                          ?.copyWith(
                              color: AppColors.errorColor,
                              fontWeight: FontWeight.w600) as dynamic,
                      color: AppColors.errorLight,
                      textColor: Colors.white,
                      elevation: 0),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
