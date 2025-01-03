import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:flutter/material.dart';

class AppTextTheme {
  AppTextTheme._();
  static final TextTheme lightTextTheme =
      Typography.material2021().black.copyWith(
            displayLarge: const TextStyle(
                fontSize: 57,
                color: AppColors.textColor,
                fontWeight: FontWeight.w400,
                fontFamily: 'DMSans'),
            displayMedium: const TextStyle(
                fontSize: 45,
                color: AppColors.textColor,
                fontWeight: FontWeight.w400,
                fontFamily: 'DMSans'),
            displaySmall: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
                fontFamily: 'DMSans'),
            headlineLarge: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
                fontFamily: 'DMSans'),
            headlineMedium: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
                fontFamily: 'DMSans'),
            headlineSmall: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
                fontFamily: 'DMSans'),
            titleLarge: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
                fontFamily: 'DMSans'),
            titleMedium: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
                fontFamily: 'DMSans'),
            titleSmall: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
                fontFamily: 'DMSans'),
            bodyLarge: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
                fontFamily: 'DMSans'),
            bodyMedium: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
                fontFamily: 'DMSans'),
            bodySmall: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
                fontFamily: 'DMSans'),
            labelLarge: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
                fontFamily: 'DMSans'),
            labelMedium: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
                fontFamily: 'DMSans'),
            labelSmall: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
                fontFamily: 'DMSans'),
          );

  // Dark Theme Text Styles
  static final TextTheme darkTextTheme =
      Typography.material2021().white.copyWith(
            displayLarge: const TextStyle(
                fontSize: 57,
                fontWeight: FontWeight.w400,
                fontFamily: 'DMSans'),
            displayMedium: const TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w400,
                fontFamily: 'DMSans'),
            displaySmall: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w400,
                fontFamily: 'DMSans'),
            headlineLarge: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                fontFamily: 'DMSans'),
            headlineMedium: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                fontFamily: 'DMSans'),
            headlineSmall: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                fontFamily: 'DMSans'),
            titleLarge: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                fontFamily: 'DMSans'),
            titleMedium: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'DMSans'),
            titleSmall: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'DMSans'),
            bodyLarge: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'DMSans'),
            bodyMedium: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'DMSans'),
            bodySmall: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'DMSans'),
            labelLarge: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'DMSans'),
            labelMedium: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'DMSans'),
            labelSmall: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                fontFamily: 'DMSans'),
          );

  static TextTheme getTextTheme(AppTheme appTheme) {
    return appTheme == AppTheme.light ? lightTextTheme : darkTextTheme;
  }
}
