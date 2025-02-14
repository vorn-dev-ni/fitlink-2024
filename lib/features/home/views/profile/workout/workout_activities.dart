import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/features/home/controller/activities/activity_form_controller.dart';
import 'package:demo/features/home/controller/workouts/activities_controller.dart';
import 'package:demo/model/workouts/workout_response.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorkoutActivities extends ConsumerStatefulWidget {
  const WorkoutActivities({super.key});

  @override
  ConsumerState<WorkoutActivities> createState() => _WorkoutActivitiesState();
}

class _WorkoutActivitiesState extends ConsumerState<WorkoutActivities> {
  DateTime _selectedDate = DateTime.now();
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(activitiesControllerProvider(_selectedDate));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: Sizes.xl,
        ),
        EasyTheme(
          data: EasyTheme.of(context).copyWithState(
            selectedDayTheme: const DayThemeData(
              backgroundColor: AppColors.secondaryColor,
              foregroundColor: AppColors.secondaryColor,
            ),
            selectedCurrentDayTheme: const DayThemeData(
                backgroundColor: Colors.transparent,
                foregroundColor: AppColors.secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(Sizes.lg))),
                border: BorderSide(style: BorderStyle.none)),
            unselectedDayTheme: const DayThemeData(
                backgroundColor: Colors.transparent,
                foregroundColor: Color.fromARGB(255, 0, 0, 0)),
            disabledDayTheme: DayThemeData(
              backgroundColor: Colors.grey.shade500,
            ),
          ),
          child: EasyDateTimeLinePicker.itemBuilder(
            focusedDate: _selectedDate,
            monthYearPickerOptions: const MonthYearPickerOptions(),
            itemBuilder:
                (context, date, isSelected, isDisabled, isToday, onTap) {
              return InkResponse(
                overlayColor: WidgetStatePropertyAll(
                    AppColors.primaryColor.withOpacity(0.1)),
                onTap: onTap,
                child: Column(
                  children: [
                    const SizedBox(
                      height: Sizes.md,
                    ),
                    Text(
                      DateFormat.E().format(date),
                      style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.w300),
                    ),
                    const SizedBox(
                      height: Sizes.xs,
                    ),
                    CircleAvatar(
                      backgroundColor: isSelected
                          ? AppColors.secondaryColor
                          : Colors.transparent,
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                            color: !isSelected
                                ? AppColors.backgroundDark
                                : AppColors.backgroundLight),
                      ),
                    ),
                  ],
                ),
              );
            },
            itemExtent: 64.0,
            selectionMode: const SelectionMode.autoCenter(),
            currentDate: currentDate,
            headerOptions: HeaderOptions(
              headerType: HeaderType.picker,
              headerBuilder: (context, date, onTap) {
                return InkWell(
                    onTap: onTap,
                    splashFactory: NoSplash.splashFactory,
                    overlayColor:
                        const WidgetStatePropertyAll(Colors.transparent),
                    child: Row(
                      children: [
                        Text(
                          DateFormat.yMMMM().format(date),
                          style: AppTextTheme.lightTextTheme.titleLarge
                              ?.copyWith(color: AppColors.secondaryColor),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.secondaryColor,
                        )
                      ],
                    ));
              },
            ),
            timelineOptions:
                const TimelineOptions(height: 100, padding: EdgeInsets.all(0)),
            firstDate: DateTime(2024, 3, 18),
            lastDate: DateTime(2050, 3, 18),
            onDateChange: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
        ),
        const Divider(
          color: AppColors.neutralColor,
        ),
        const SizedBox(
          height: Sizes.xxl,
        ),
        Text(
          FormatterUtils.formatDate(_selectedDate),
          style: AppTextTheme.lightTextTheme.bodyLarge,
        ),
        asyncValue.when(
          data: (data) {
            return data != null && data.isEmpty
                ? emptyContent(title: 'You have no workout activities yet !!!')
                : ListView.builder(
                    itemCount: data!.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final workout = data[index];
                      return workout.userActivity == true
                          ? renderActivity(workout)
                          : renderWorkout(workout);
                    },
                  );
          },
          error: (error, stackTrace) {
            return emptyContent(title: error.toString());
          },
          loading: () {
            return buildLoader();
          },
        )
      ],
    );
  }

  SizedBox renderWorkout(WorkoutExcerciseResponse workout) {
    return SizedBox(
      // width: 350,
      width: 100.w,
      child: GestureDetector(
        onTap: () {
          _navigating(workout, _selectedDate);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: Sizes.lg),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Sizes.lg),
                  child: FancyShimmerImage(
                    height: 220,
                    width: 100.w,
                    imageUrl: workout.imageUrl ??
                        'https://images.unsplash.com/photo-1599058917212-d750089bc07e?q=80&w=2669&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    boxFit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.lg),
                    color: AppColors.backgroundDark.withOpacity(0.4),
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
                                maxLines: 1,
                                style: AppTextTheme.lightTextTheme.titleMedium
                                    ?.copyWith(
                                        color: AppColors.backgroundLight),
                              ),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  "${workout.title}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextTheme
                                      .lightTextTheme.headlineMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.backgroundLight),
                                ),
                              ),
                              const SizedBox(height: Sizes.sm),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${workout.exercises?.length} ${workout.exercises!.length > 1 ? 'Exercises' : 'Exercises'}',
                                      style: AppTextTheme
                                          .lightTextTheme.bodySmall
                                          ?.copyWith(
                                              color: AppColors.backgroundLight),
                                    ),

                                    const VerticalDivider(
                                      color: AppColors.backgroundLight,
                                    ),
                                    Text(
                                      FormatterUtils.formatExerciseDuration(
                                          workout.totalDuration ?? 0),
                                      style: AppTextTheme
                                          .lightTextTheme.bodySmall
                                          ?.copyWith(
                                              color: AppColors.backgroundLight),
                                    ),
                                    // statusBag(Status.completed),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: Sizes.xxxl + 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  statusBag(workout.completed != null
                                      ? workout.completed!
                                          ? Status.completed
                                          : Status.progress
                                      : Status.progress),
                                  const SizedBox(
                                    width: Sizes.lg,
                                  ),
                                  FilledButton.icon(
                                      style: FilledButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 14),
                                          backgroundColor:
                                              AppColors.neutralBlack,
                                          foregroundColor:
                                              AppColors.primaryColor),
                                      onPressed: () =>
                                          _navigating(workout, _selectedDate),
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
      ),
    );
  }

  Widget renderActivity(WorkoutExcerciseResponse workout) {
    return SizedBox(
      width: 100.w,
      height: 200,
      child: GestureDetector(
        onTap: () {
          HelpersUtils.navigatorState(context)
              .pushNamed(AppPage.excerciseActivitiesForm, arguments: {
            'title': workout.title,
            'desc': workout.desc,
            'startTime': workout.startTime,
            'endTime': workout.endTime,
            'date': _selectedDate,
            'docId': workout.parentId
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(top: Sizes.lg),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Sizes.lg),
                  child: FancyShimmerImage(
                    height: 200,
                    width: 100.w,
                    imageUrl:
                        'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=2340&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    boxFit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.lg),
                    color: AppColors.backgroundDark.withOpacity(0.3),
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
                                workout.title ?? "",
                                maxLines: 2,
                                style: AppTextTheme.lightTextTheme.bodyLarge
                                    ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.backgroundLight),
                              ),
                              Row(
                                children: [
                                  Text(
                                    maxLines: 4,
                                    workout.desc ?? "",
                                    style: AppTextTheme.lightTextTheme.bodySmall
                                        ?.copyWith(
                                            color: AppColors.backgroundLight),
                                  ),
                                  const SizedBox(
                                    width: Sizes.sm,
                                  ),
                                ],
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
                                      onPressed: () {},
                                      label: Text(
                                        FormatterUtils.getFormattedTime(
                                            workout.startTime!),
                                        style: AppTextTheme
                                            .lightTextTheme.labelLarge
                                            ?.copyWith(
                                                color:
                                                    AppColors.secondaryColor),
                                      )),
                                  const SizedBox(
                                    width: Sizes.md,
                                  ),
                                  FilledButton.icon(
                                      iconAlignment: IconAlignment.start,
                                      style: FilledButton.styleFrom(
                                          backgroundColor:
                                              AppColors.secondaryColor,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 14),
                                          foregroundColor:
                                              AppColors.primaryColor),
                                      icon: const Icon(
                                        Icons.alarm,
                                        size: Sizes.iconSm,
                                      ),
                                      onPressed: () {},
                                      label: Text(
                                        FormatterUtils.getFormattedTime(
                                            workout.endTime!),
                                        style: AppTextTheme
                                            .lightTextTheme.labelLarge
                                            ?.copyWith(
                                                color: AppColors.primaryColor),
                                      )),
                                  const SizedBox(
                                    width: Sizes.md,
                                  ),
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
      ),
    );
  }

  Widget buildLoader() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return SizedBox(
            // width: 350,

            width: 100.w,
            height: 240,
            child: Padding(
              padding: const EdgeInsets.only(top: Sizes.lg),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Sizes.lg),
                      child: Image.network(
                        height: 240,
                        width: 100.w,
                        'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=2340&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.lg),
                        color: AppColors.backgroundDark.withOpacity(0.3),
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
                                    "First Day of Running Excercises",
                                    maxLines: 2,
                                    style: AppTextTheme.lightTextTheme.bodyLarge
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.backgroundLight),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        maxLines: 4,
                                        'Running from Takmao to Phnom Penh ',
                                        style: AppTextTheme
                                            .lightTextTheme.bodySmall
                                            ?.copyWith(
                                                color:
                                                    AppColors.backgroundLight),
                                      ),
                                      const SizedBox(
                                        width: Sizes.sm,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: Sizes.xxxl + 60,
                                  ),
                                  Row(
                                    children: [
                                      FilledButton.icon(
                                          iconAlignment: IconAlignment.start,
                                          style: FilledButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 14),
                                              foregroundColor:
                                                  AppColors.secondaryColor),
                                          icon: const Icon(
                                            Icons.alarm,
                                            size: Sizes.iconSm,
                                          ),
                                          onPressed: () {},
                                          label: Text(
                                            "4:00pm",
                                            style: AppTextTheme
                                                .lightTextTheme.labelLarge
                                                ?.copyWith(
                                                    color: AppColors
                                                        .secondaryColor),
                                          )),
                                      const SizedBox(
                                        width: Sizes.md,
                                      ),
                                      FilledButton.icon(
                                          iconAlignment: IconAlignment.start,
                                          style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.secondaryColor,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 14),
                                              foregroundColor:
                                                  AppColors.primaryColor),
                                          icon: const Icon(
                                            Icons.alarm,
                                            size: Sizes.iconSm,
                                          ),
                                          onPressed: () {},
                                          label: Text(
                                            "6:00pm",
                                            style: AppTextTheme
                                                .lightTextTheme.labelLarge
                                                ?.copyWith(
                                                    color:
                                                        AppColors.primaryColor),
                                          )),
                                      const SizedBox(
                                        width: Sizes.md,
                                      ),
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
    );
  }

  Widget statusBag(Status status) {
    return Material(
      color: status == Status.completed
          ? AppColors.secondaryColor
          : const Color.fromARGB(255, 206, 154, 0),
      type: MaterialType.button,
      elevation: 0,
      borderRadius: BorderRadius.circular(Sizes.xxl),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            status == Status.completed
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: AppColors.primaryColor,
                  )
                : const Icon(
                    Icons.incomplete_circle,
                    size: 16,
                    color: AppColors.warningLight,
                  ),
            const SizedBox(
              width: Sizes.xs,
            ),
            Text(
              status == Status.completed ? 'Completed' : 'Progressing',
              style: AppTextTheme.lightTextTheme.labelMedium?.copyWith(
                  color: status == Status.completed
                      ? AppColors.primaryColor
                      : AppColors.warningLight),
            ),
          ],
        ),
      ),
    );
  }

  void _navigating(workout, _selectedDate) {
    HelpersUtils.navigatorState(context)
        .pushNamed(AppPage.excercise, arguments: {
      'docId': workout.id,
      'title': workout.title,
      'duration': workout.totalDuration,
      'totalExcercises': workout.exercises?.length ?? 0,
      'feature': workout.imageUrl,
      'date': _selectedDate
    });
  }
}
