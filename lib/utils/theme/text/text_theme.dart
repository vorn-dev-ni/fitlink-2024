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
                fontFamily: 'Lexend'),
            displayMedium: const TextStyle(
                fontSize: 45,
                color: AppColors.textColor,
                fontWeight: FontWeight.w400,
                fontFamily: 'Lexend'),
            displaySmall: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
                fontFamily: 'Lexend'),
            headlineLarge: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
                fontFamily: 'Lexend'),
            headlineMedium: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
                fontFamily: 'Lexend'),
            headlineSmall: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
                fontFamily: 'Lexend'),
            titleLarge: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
                fontFamily: 'Lexend'),
            titleMedium: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
                fontFamily: 'Lexend'),
            titleSmall: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
                fontFamily: 'Lexend'),
            bodyLarge: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
                fontFamily: 'Lexend'),
            bodyMedium: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
                fontFamily: 'Lexend'),
            bodySmall: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
                fontFamily: 'Lexend'),
            labelLarge: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
                fontFamily: 'Lexend'),
            labelMedium: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
                fontFamily: 'Lexend'),
            labelSmall: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
                fontFamily: 'Lexend'),
          );

  // Dark Theme Text Styles
  static final TextTheme darkTextTheme =
      Typography.material2021().white.copyWith(
            displayLarge: const TextStyle(
                fontSize: 57,
                fontWeight: FontWeight.w400,
                fontFamily: 'Lexend'),
            displayMedium: const TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w400,
                fontFamily: 'Lexend'),
            displaySmall: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w400,
                fontFamily: 'Lexend'),
            headlineLarge: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                fontFamily: 'Lexend'),
            headlineMedium: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                fontFamily: 'Lexend'),
            headlineSmall: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                fontFamily: 'Lexend'),
            titleLarge: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                fontFamily: 'Lexend'),
            titleMedium: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Lexend'),
            titleSmall: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Lexend'),
            bodyLarge: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Lexend'),
            bodyMedium: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Lexend'),
            bodySmall: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'Lexend'),
            labelLarge: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Lexend'),
            labelMedium: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Lexend'),
            labelSmall: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                fontFamily: 'Lexend'),
          );

  static TextTheme getTextTheme(AppTheme appTheme) {
    return appTheme == AppTheme.light ? lightTextTheme : darkTextTheme;
  }
}
