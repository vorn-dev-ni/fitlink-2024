import 'package:demo/common/model/grid_meal.dart';
import 'package:demo/common/widget/Icon_tab.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:demo/utils/constant/sizes.dart';

// ignore: non_constant_identifier_names
Widget GridMealItem(Gridmeal item, {void Function()? onTap}) {
  return Material(
    elevation: 0,
    type: MaterialType.card,
    borderRadius: BorderRadius.circular(Sizes.lg),
    clipBehavior: Clip.hardEdge,
    color: item.backgroundColor,
    child: InkWell(
      onTap: onTap,
      splashFactory: InkRipple.splashFactory,
      splashColor: item.textColors.withOpacity(0.25),
      highlightColor: item.backgroundColor.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Sizes.md, vertical: Sizes.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "${item.value}",
                    style: AppTextTheme.lightTextTheme.bodyLarge
                        ?.copyWith(color: item.textColors),
                  ),
                  Text(
                    "${item.perUnit}",
                    style: AppTextTheme.lightTextTheme.bodyMedium
                        ?.copyWith(color: item.textColors),
                  ),
                ],
              ),
              IconTab(
                  svgAsset: SvgAsset.gymSvg,
                  forebackground: item.backgroundColor)
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                "${item.label}",
                style: AppTextTheme.lightTextTheme.bodyLarge
                    ?.copyWith(color: item.textColors),
              ),
            ],
          ),
        ]),
      ),
    ),
  );
}
