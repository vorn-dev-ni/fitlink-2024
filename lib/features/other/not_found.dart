import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.backgroundDark,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.app.noInternetCat.image(width: 300, height: 300),
          const Center(
            child: Text(
              'Coming soon, please wait...',
              style: TextStyle(color: AppColors.textColor, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
