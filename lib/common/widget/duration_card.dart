import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget DurationCard({required String label}) {
  return Container(
    color: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Sizes.sm - 4, horizontal: Sizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.string(
            SvgAsset.durationSvg,
            width: 20,
            height: 20,
          ),
          const SizedBox(
            width: Sizes.xs - 2,
          ),
          Text(
            '${label}',
            style: AppTextTheme.lightTextTheme.labelMedium
                ?.copyWith(color: AppColors.textColor),
          ),
        ],
      ),
    ),
  );
}
