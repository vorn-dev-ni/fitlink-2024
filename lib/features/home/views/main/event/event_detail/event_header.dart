import 'package:flutter/material.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter_svg/svg.dart';

Widget eventHeaderSection(
    {required String title,
    required String address,
    required String establishment,
    required String startTime,
    required String endTime,
    required bool isFree,
    String? price}) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.all(Sizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: ),
          Text(
            title,
            style: AppTextTheme.lightTextTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: Sizes.xs,
          ),
          Text(
            'Shop: $establishment',
            style: AppTextTheme.lightTextTheme.labelMedium?.copyWith(),
          ),
          const SizedBox(
            height: Sizes.xs,
          ),
          Row(
            children: [
              SvgPicture.asset(Assets.icon.svg.mdiLocation),
              const SizedBox(
                width: Sizes.xs,
              ),
              Expanded(
                child: Text(
                  address,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.lightTextTheme.labelMedium?.copyWith(),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: Sizes.xs,
          ),
          Text(
            'Schedule: 1 : 00pm - 5 : 00pm',
            style: AppTextTheme.lightTextTheme.labelMedium?.copyWith(),
          ),
          const SizedBox(
            height: Sizes.xs,
          ),
          Text(
            isFree ? 'Free - entry' : '\$ $price',
            style: AppTextTheme.lightTextTheme.labelMedium
                ?.copyWith(color: AppColors.secondaryColor),
          ),
        ],
      ),
    ),
  );
}
