import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:demo/utils/constant/app_colors.dart';

class ElevationTheme {
  ElevationTheme._();

  // Light Theme ElevatedButton
  static final ElevatedButtonThemeData elevationButtonLight =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0, // Light theme elevation
      splashFactory: InkRipple.splashFactory,
      backgroundColor: AppColors.secondaryColor, // Button background
      foregroundColor: AppColors.backgroundLight, // Button text color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.xl), // Rounded corners
      ),

      overlayColor: Colors.transparent,
    ),
  );

  // Dark Theme ElevatedButton
  static final ElevatedButtonThemeData elevationButtonDark =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 4, // Dark theme elevation (slightly higher for contrast)
      backgroundColor: AppColors.primaryDark, // Button background
      foregroundColor: AppColors.backgroundDark, // Button text color
      shadowColor: AppColors.neutralBlack.withOpacity(0.5), // Dark shadow color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );

  static getElevationTheme(AppTheme appTheme) {
    return appTheme == AppTheme.light
        ? elevationButtonLight
        : elevationButtonDark;
  }
}
