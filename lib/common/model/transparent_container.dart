import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';

Widget transparentContainer(
    {required Widget child,
    double? opacity = 0.5,
    double? padding = Sizes.lg}) {
  return Container(
    padding: EdgeInsets.all(padding!),
    decoration: BoxDecoration(
        color: AppColors.backgroundDark.withOpacity(opacity!),
        borderRadius: BorderRadius.circular(Sizes.lg)),
    child: child,
  );
}
