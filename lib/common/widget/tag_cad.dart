import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: non_constant_identifier_names
Widget TagCard({required String label}) {
  return Material(
    color: AppColors.backgroundLight,
    borderRadius: BorderRadius.circular(Sizes.xl),
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Sizes.sm - 2, horizontal: Sizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '${label}',
            style: AppTextTheme.lightTextTheme.labelMedium
                ?.copyWith(color: AppColors.textColor),
          ),
          const SizedBox(
            width: Sizes.sm,
          ),
          SvgPicture.string(
            SvgAsset.dumbellSvg,
            width: 16,
            height: 16,
          )
        ],
      ),
    ),
  );
}
