import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';

Widget CustomBottomNavigationBar(
    {required int selectedIndex,
    required void Function(int) onTap,
    required List<BottomNavigationBarItem> items}) {
  return BottomNavigationBar(
    currentIndex: selectedIndex,
    onTap: onTap, // Use onTap callback to update the index
    items: items,

    enableFeedback: false, // Disable splash/ripple effect
    selectedItemColor: AppColors.primaryColor,
    backgroundColor: Colors.white,
    showUnselectedLabels: false,
    showSelectedLabels: false,
    elevation: 0,
    unselectedItemColor: AppColors.primaryColor.withOpacity(0.3),
    unselectedLabelStyle: const TextStyle(color: Colors.grey),
    type: BottomNavigationBarType.fixed, // Type similar to MUI 3 style
  );
}
