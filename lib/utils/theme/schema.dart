import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/theme/button/elevation_theme.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SchemaData {
  SchemaData._();
  static ThemeData lightThemeData({String? locale}) {
    return ThemeData(
            useMaterial3: true,
            fontFamily: locale == 'en' ? 'Lexend' : 'KohSantepheap')
        .copyWith(
      textTheme: AppTextTheme.lightTextTheme,
      extensions: const [
        SkeletonizerConfigData(),
      ],
      bottomSheetTheme:
          const BottomSheetThemeData(dragHandleColor: AppColors.neutralBlack),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      primaryColor: AppColors.primaryColor,
      brightness: Brightness.light,
      elevatedButtonTheme: ElevationTheme.elevationButtonLight,
      textSelectionTheme: AppTextThemeSelection.lightTheme,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        tertiary: AppColors.tertiaryColor,
        error: AppColors.errorColor,
        surface: AppColors.secondaryColor,
        onSurface: AppColors.primaryColor,
      ),
    );
  }

  static ThemeData darkThemeData({String? locale}) {
    return ThemeData(
            useMaterial3: true,
            fontFamily: locale == 'en' ? 'Lexend' : 'KohSantepheap')
        .copyWith(
      scaffoldBackgroundColor: Colors.black12,
      textTheme: AppTextTheme.darkTextTheme,
      brightness: Brightness.dark,
      extensions: const [
        SkeletonizerConfigData(),
      ],
      bottomSheetTheme:
          const BottomSheetThemeData(dragHandleColor: AppColors.neutralBlack),
      elevatedButtonTheme: ElevationTheme.elevationButtonDark,
      primaryColorDark: AppColors.primaryDark,
      textSelectionTheme: AppTextThemeSelection.darkTheme,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.secondaryDark,
        tertiary: AppColors.tertiaryDark,
        error: AppColors.errorColor,
        onSurface: AppColors.primaryColor,

        surface: AppColors.neutralBlack,
        // onSurface: Colors.white
      ),
    );
  }

  static ThemeData getAppTheme(AppTheme appTheme, {String? locale}) {
    return appTheme == AppTheme.light
        ? lightThemeData(locale: locale)
        : darkThemeData(locale: locale);
  }
}
