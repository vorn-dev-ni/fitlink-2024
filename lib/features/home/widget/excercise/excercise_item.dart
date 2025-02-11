import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

Widget excercise_item(BuildContext context, int index) {
  return ListTile(
    onTap: () {
      HelpersUtils.navigatorState(context).pushNamed(AppPage.excerciseDetail);
    },
    contentPadding: const EdgeInsets.all(Sizes.md),
    leading: FancyShimmerImage(
      width: 120,
      height: 120,
      imageUrl:
          'https://cdn.shopify.com/s/files/1/0269/5551/3900/files/Dumbbell-Bent-Over-Row-_Single-Arm_49867db3-f465-4fbc-b359-29cbdda502e2_600x600.png?v=1612138069',
      boxFit: BoxFit.cover,
    ),
    title: Text(
      "Dumbbell Goblet Squat $index",
      style: const TextStyle(color: AppColors.backgroundDark, fontSize: 16),
    ),
    subtitle: const Padding(
      padding: EdgeInsets.only(top: Sizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.alarm,
            color: AppColors.secondaryColor,
            size: Sizes.iconXs,
          ),
          SizedBox(
            width: Sizes.xs,
          ),
          Padding(
            padding: EdgeInsets.only(top: 1),
            child: Text(
              "00:20",
              style: TextStyle(color: AppColors.secondaryColor),
            ),
          ),
        ],
      ),
    ),
    minTileHeight: 100,
  );
}
