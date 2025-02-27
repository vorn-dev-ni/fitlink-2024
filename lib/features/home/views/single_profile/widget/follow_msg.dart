import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

Widget renderFollowMsg() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          ClipRRect(
            clipBehavior: Clip.antiAlias,
            child: TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.xl),
                    foregroundColor: AppColors.backgroundLight,
                    backgroundColor: AppColors.backgroundDark.withOpacity(0.67),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes.lg))),
                onPressed: () {},
                child: Text(
                  'Follow',
                  style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: AppColors.backgroundLight),
                )),
          ),
          const SizedBox(
            width: Sizes.lg,
          ),
          ClipRRect(
            clipBehavior: Clip.antiAlias,
            child: TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.xl),
                    foregroundColor: AppColors.backgroundLight,
                    backgroundColor: AppColors.backgroundDark.withOpacity(0.67),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes.lg))),
                onPressed: () {},
                child: Text(
                  'Message',
                  style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: AppColors.backgroundLight),
                )),
          ),
        ],
      ),
      const SizedBox(
        height: Sizes.md,
      ),
    ],
  );
}
