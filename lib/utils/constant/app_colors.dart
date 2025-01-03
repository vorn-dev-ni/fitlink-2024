import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryColor = Color(0xFF0070F0); // Main brand color
  static const Color primaryLight =
      Color(0xFF82B1FF); // Light version of primary
  static const Color primaryDark = Color(0xFF0043A4); // Dark version of primary

  // Secondary Colors
  static const Color secondaryColor =
      Color(0xFFEBF4FF); // Soft background accent
  static const Color secondaryDark =
      Color(0xFFB2D4FF); // Slightly darker accent

  // Tertiary Colors
  static const Color tertiaryColor = Color(0xFFC9F0FF); // Subtle tertiary
  static const Color tertiaryDark = Color(0xFF8EC4E5); // Darker tertiary

  // Neutral Colors (Grays)
  static const Color neutralColor = Color(0xFFF7F9FA); // Light neutral
  static const Color neutralDark = Color(0xFF979797); // Medium neutral
  static const Color neutralBlack = Color(0xFF1A1A1A); // Dark neutral

  // Error Colors
  static const Color errorColor = Color(0xFFFF5449); // Main error color
  static const Color errorLight = Color(0xFFFFDAD6); // Light version of error

  // Success Colors
  static const Color successColor = Color(0xFF28A745); // Success green
  static const Color successLight = Color(0xFFD4EDDA); // Light success

  // Warning Colors
  static const Color warningColor = Color(0xFFFFC107); // Warning yellow
  static const Color warningLight = Color(0xFFFFE8A1); // Light warning

  // Background Colors
  static const Color backgroundLight = Color(0xFFFFFFFF); // White background
  static const Color backgroundDark = Color(0xFF121212); // Dark background

  static const Color textColor = Colors.black; // Darker tertiary
}
