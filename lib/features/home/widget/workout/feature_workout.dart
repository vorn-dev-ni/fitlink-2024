import 'package:demo/features/home/controller/workouts/workout_controller.dart';
import 'package:demo/features/home/controller/workouts/workout_date_controller.dart';
import 'package:demo/features/home/widget/workout/feature_item.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FeatureWorkout extends ConsumerStatefulWidget {
  const FeatureWorkout({
    super.key,
  });

  @override
  ConsumerState<FeatureWorkout> createState() => _FeatureWorkoutState();
}

class _FeatureWorkoutState extends ConsumerState<FeatureWorkout> {
  @override
  Widget build(BuildContext context) {
    final asyncValue =
        ref.watch(workoutControllerProvider(WorkoutType.feature));

    return asyncValue.when(
      data: (data) {
        final result = data;
        return SizedBox(
          height: 250,
          // width: 100.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Feature Workout',
                style: AppTextTheme.lightTextTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: Sizes.md,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: result?.length ?? 0,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final workout = result![index];
                    return FeatureItem(workout, (item) => _navigating(item));
                  },
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return const Text('');
      },
      loading: () {
        return _buildLoading();
      },
    );
  }

  Skeletonizer _buildLoading() {
    return Skeletonizer(
      enabled: true,
      child: SizedBox(
        height: 250,
        // width: 100.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feature Workout',
              style: AppTextTheme.lightTextTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: Sizes.md,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: Sizes.md),
                    child: InkWell(
                      onTap: () {},
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Sizes.lg),
                              child: FancyShimmerImage(
                                // width: 300,
                                imageUrl:
                                    'https://images.unsplash.com/photo-1599058917212-d750089bc07e?q=80&w=2669&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',

                                boxFit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Sizes.lg),
                                color:
                                    AppColors.secondaryColor.withOpacity(0.4),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(Sizes.lg),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '7x4 Plan',
                                            style: AppTextTheme
                                                .lightTextTheme.titleMedium
                                                ?.copyWith(
                                                    color: AppColors
                                                        .backgroundLight),
                                          ),
                                          Text(
                                            'Squat Lose Weight',
                                            style: AppTextTheme
                                                .lightTextTheme.bodyLarge
                                                ?.copyWith(
                                                    color: AppColors
                                                        .backgroundLight),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '13 Excercises',
                                                style: AppTextTheme
                                                    .lightTextTheme.labelSmall
                                                    ?.copyWith(
                                                        color: AppColors
                                                            .backgroundLight),
                                              ),
                                              const SizedBox(
                                                width: Sizes.sm,
                                              ),
                                              Text(
                                                '440 cal',
                                                style: AppTextTheme
                                                    .lightTextTheme.labelSmall
                                                    ?.copyWith(
                                                        color: AppColors
                                                            .backgroundLight),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: Sizes.xxxl + 20,
                                          ),
                                          Row(
                                            children: [
                                              FilledButton.icon(
                                                  style: FilledButton.styleFrom(
                                                      foregroundColor: AppColors
                                                          .secondaryColor),
                                                  icon: const Icon(Icons.alarm),
                                                  onPressed: () {},
                                                  label: const Text('35min')),
                                              const SizedBox(
                                                width: Sizes.sm,
                                              ),
                                              FilledButton.icon(
                                                  style: FilledButton.styleFrom(
                                                      backgroundColor: AppColors
                                                          .neutralBlack,
                                                      foregroundColor: AppColors
                                                          .primaryColor),
                                                  onPressed: () {
                                                    HelpersUtils.navigatorState(
                                                            context)
                                                        .pushNamed(
                                                            AppPage.excercise);
                                                  },
                                                  label:
                                                      const Text('Start Now')),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigating(workout) {
    HelpersUtils.navigatorState(context)
        .pushNamed(AppPage.excercise, arguments: {
      'docId': workout.id,
      'title': workout.title,
      'duration': workout.totalDuration,
      'totalExcercises': workout.exercises?.length ?? 0,
      'feature': workout.imageUrl,
      'date': ref.read(workoutDateControllerProvider),
    });
  }
}
