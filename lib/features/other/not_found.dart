import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Seem like the screen is not exist',
          style: TextStyle(color: AppColors.textColor),
        ),
      ),
    );
  }
}
