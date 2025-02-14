import 'package:demo/common/widget/horidivider.dart';
import 'package:demo/features/home/controller/workouts/workout_controller.dart';
import 'package:demo/features/home/controller/workouts/workout_date_controller.dart';
import 'package:demo/model/workouts/workout_response.dart';
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

class WorkoutTabBuild extends ConsumerStatefulWidget {
  final String level;

  const WorkoutTabBuild({super.key, required this.level});

  @override
  ConsumerState<WorkoutTabBuild> createState() => _WorkoutTabBuildState();
}

class _WorkoutTabBuildState extends ConsumerState<WorkoutTabBuild>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> myTabs = ["Beginner", "Intermediate", "Advanced"];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(workoutControllerProvider(_selectedIndex == 0
        ? WorkoutType.beginner
        : _selectedIndex == 1
            ? WorkoutType.intermediate
            : WorkoutType.advance));
    return asyncValue.when(
      data: (data) {
        return WorkoutItem(data);
      },
      error: (error, stackTrace) => const Text(''),
      loading: () {
        return _build_loading();
      },
    );
  }

  Column WorkoutItem(List<WorkoutExcerciseResponse>? data) {
    return Column(
      children: [
        Skeletonizer(
          enabled: false,
          ignoreContainers: true,
          child: Container(
            color: Colors.transparent,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(myTabs.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          left: BorderSide.none,
                          bottom: BorderSide(
                              width: 2,
                              color: _selectedIndex == index
                                  ? AppColors.secondaryColor
                                  : Colors.transparent),
                        )),
                    child: Text(myTabs[index],
                        style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                          color: _selectedIndex == index
                              ? AppColors.secondaryColor
                              : Colors.grey,
                        )),
                  ),
                );
              }),
            ),
          ),
        ),
        ListView.builder(
          itemCount: data?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: Sizes.lg),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final workout = data![index];
            return Padding(
              padding: const EdgeInsets.only(bottom: Sizes.md, top: 0),
              child: InkWell(
                onTap: () {
                  HelpersUtils.navigatorState(context)
                      .pushNamed(AppPage.excercise, arguments: {
                    'docId': workout.id,
                    'title': workout.title,
                    'duration': workout.totalDuration,
                    'totalExcercises': workout.exercises?.length ?? 0,
                    'feature': workout.imageUrl,
                    'date': ref.read(workoutDateControllerProvider),
                  });
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(Sizes.lg),
                      child: FancyShimmerImage(
                        imageUrl: workout.imageUrl ??
                            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Z3ltfGVufDB8fDB8fHww',
                        boxFit: BoxFit.cover,
                      ),
                    )),
                    Positioned.fill(
                        child: ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Sizes.lg),
                          color: AppColors.backgroundDark.withOpacity(0.3),
                        ),
                      ),
                    )),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.lg),
                        color: AppColors.backgroundDark.withOpacity(0.4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Sizes.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${workout.title}',
                              style: AppTextTheme.lightTextTheme.titleLarge
                                  ?.copyWith(color: AppColors.backgroundLight),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  '${workout.totalDuration} Mins',
                                  style: AppTextTheme.lightTextTheme.labelSmall
                                      ?.copyWith(
                                          color: AppColors.backgroundLight),
                                ),
                                const SizedBox(width: 8),
                                horiDivider(),
                                const SizedBox(width: 8),
                                Text(
                                  '${workout.exercises?.length} Exercises',
                                  style: AppTextTheme.lightTextTheme.labelSmall
                                      ?.copyWith(
                                          color: AppColors.backgroundLight),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Skeletonizer _build_loading() {
    return Skeletonizer(
      enabled: true,
      ignoreContainers: true,
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(myTabs.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          left: BorderSide.none,
                          bottom: BorderSide(
                              width: 2,
                              color: _selectedIndex == index
                                  ? AppColors.secondaryColor
                                  : Colors.transparent),
                        )),
                    child: Text(myTabs[index],
                        style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                          color: _selectedIndex == index
                              ? AppColors.secondaryColor
                              : Colors.grey,
                        )),
                  ),
                );
              }),
            ),
          ),
          ListView.builder(
            itemCount: 3, // Example count
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: Sizes.lg),
            shrinkWrap: true,
            // padding: const EdgeInsets.all(Sizes.md),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: Sizes.md, top: 0),
                child: InkWell(
                  onTap: () {
                    HelpersUtils.navigatorState(context)
                        .pushNamed(AppPage.excercise);
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(Sizes.lg),
                        child: FancyShimmerImage(
                          imageUrl:
                              'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Z3ltfGVufDB8fDB8fHww',
                          boxFit: BoxFit.cover,
                        ),
                      )),
                      Positioned.fill(
                          child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Sizes.lg),
                            color: AppColors.backgroundDark.withOpacity(0.3),
                          ),
                        ),
                      )),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Sizes.lg),
                          color: AppColors.backgroundDark.withOpacity(0.4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(Sizes.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.level} Workout',
                                style: AppTextTheme.lightTextTheme.titleLarge
                                    ?.copyWith(
                                        color: AppColors.backgroundLight),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    '20 Mins',
                                    style: AppTextTheme
                                        .lightTextTheme.labelSmall
                                        ?.copyWith(
                                            color: AppColors.backgroundLight),
                                  ),
                                  const SizedBox(width: 8),
                                  horiDivider(),
                                  const SizedBox(width: 8),
                                  Text(
                                    '10 Exercises',
                                    style: AppTextTheme
                                        .lightTextTheme.labelSmall
                                        ?.copyWith(
                                            color: AppColors.backgroundLight),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
