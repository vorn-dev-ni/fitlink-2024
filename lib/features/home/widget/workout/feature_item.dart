import 'package:demo/model/workouts/workout_response.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

Widget FeatureItem(WorkoutExcerciseResponse workout, Function navigate) {
  return SizedBox(
    child: Padding(
      padding: const EdgeInsets.only(right: Sizes.md),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.lg),
              child: FancyShimmerImage(
                imageUrl: workout.imageUrl ??
                    'https://images.unsplash.com/photo-1599058917212-d750089bc07e?q=80&w=2669&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                boxFit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.lg),
                color: AppColors.secondaryColor.withOpacity(0.2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Sizes.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${workout.planName} Plan',
                            style: AppTextTheme.lightTextTheme.titleMedium
                                ?.copyWith(color: AppColors.backgroundLight),
                          ),
                          Text(
                            workout.title ?? "",
                            style: AppTextTheme.lightTextTheme.bodyLarge
                                ?.copyWith(color: AppColors.backgroundLight),
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Text(
                                  '${workout.exercises?.length} Excercises',
                                  style: AppTextTheme.lightTextTheme.bodySmall
                                      ?.copyWith(
                                          color: AppColors.backgroundLight),
                                ),
                                const VerticalDivider(
                                  color: AppColors.backgroundLight,
                                ),
                                Text(
                                  '${workout.totalBurn} cal',
                                  style: AppTextTheme.lightTextTheme.labelSmall
                                      ?.copyWith(
                                          color: AppColors.backgroundLight),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: Sizes.xxxl + 20,
                          ),
                          Row(
                            children: [
                              FilledButton.icon(
                                  iconAlignment: IconAlignment.start,
                                  style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 14),
                                      foregroundColor:
                                          AppColors.secondaryColor),
                                  icon: const Icon(
                                    Icons.alarm,
                                    size: Sizes.iconSm,
                                  ),
                                  onPressed: () => navigate(workout),
                                  label: Text(
                                    FormatterUtils.formatExerciseDuration(
                                        workout.totalDuration ?? 0),
                                    style: AppTextTheme
                                        .lightTextTheme.labelMedium
                                        ?.copyWith(
                                            color: AppColors.secondaryColor),
                                  )),
                              const SizedBox(
                                width: Sizes.md,
                              ),
                              FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 14),
                                      backgroundColor: AppColors.neutralBlack,
                                      foregroundColor: AppColors.primaryColor),
                                  onPressed: () => navigate(workout),
                                  label: Text(
                                    'Start Now',
                                    style: AppTextTheme
                                        .lightTextTheme.labelMedium
                                        ?.copyWith(
                                            color: AppColors.primaryColor),
                                  )),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
