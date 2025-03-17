import 'package:demo/gen/assets.gen.dart';
import 'package:demo/model/workouts/workout_response.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

Widget excercise_item(BuildContext context, int index, Exercises? excercise) {
  return ListTile(
    contentPadding: const EdgeInsets.all(Sizes.md),
    leading: excercise == null
        ? Assets.app.catGym.image(
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          )
        : FancyShimmerImage(
            width: 120,
            height: 120,
            imageUrl: excercise.imageUrl ?? "",
            boxFit: BoxFit.cover,
          ),
    title: SizedBox(
      width: 300,
      child: Text(
        overflow: TextOverflow.ellipsis,
        excercise?.title ?? "N/A",
        maxLines: 3,
        style: const TextStyle(color: AppColors.backgroundDark, fontSize: 16),
      ),
    ),
    subtitle: Padding(
      padding: const EdgeInsets.only(top: Sizes.sm),
      child: IntrinsicHeight(
        child: Wrap(
          // crossAxisAlignment: CrossAxisAlignment.center,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Icon(
              Icons.alarm,
              color: AppColors.secondaryColor,
              size: Sizes.iconXs,
            ),
            const SizedBox(
              width: Sizes.xs,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                FormatterUtils.formatExerciseDuration(
                    int.parse(excercise?.duration ?? "0")),
                style: const TextStyle(color: AppColors.secondaryColor),
              ),
            ),
            const SizedBox(
              width: Sizes.sm,
            ),
            const Text(
              '|',
              style: TextStyle(color: AppColors.secondaryColor),
            ),
            const SizedBox(
              width: Sizes.sm,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                '${excercise?.sets} sets',
                style: const TextStyle(color: AppColors.secondaryColor),
              ),
            ),
            const SizedBox(
              width: Sizes.sm,
            ),
            const Text(
              '|',
              style: TextStyle(color: AppColors.secondaryColor),
            ),
            const SizedBox(
              width: Sizes.sm,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                '${excercise?.reps} reps',
                style: const TextStyle(color: AppColors.secondaryColor),
              ),
            ),
          ],
        ),
      ),
    ),
    minTileHeight: 100,
  );
}
