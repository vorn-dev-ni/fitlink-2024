import 'package:demo/features/home/controller/workouts/excercises_controller.dart';
import 'package:demo/features/home/controller/workouts/workout_controller.dart';
import 'package:demo/features/home/controller/workouts/workout_date_controller.dart';
import 'package:demo/features/home/widget/workout/feature_workout.dart';
import 'package:demo/features/home/widget/workout/workout_tab_bar.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class MainWorkoutScreen extends ConsumerStatefulWidget {
  const MainWorkoutScreen({super.key});

  @override
  ConsumerState<MainWorkoutScreen> createState() => _MainWorkoutScreenState();
}

class _MainWorkoutScreenState extends ConsumerState<MainWorkoutScreen>
    with AutomaticKeepAliveClientMixin<MainWorkoutScreen> {
  // late DateTime selectedDate;

  @override
  void initState() {
    // selectedDate =
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(workoutDateControllerProvider);
    return Scaffold(
      body: RefreshIndicator(
        backgroundColor: AppColors.backgroundLight,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));

          ref.invalidate(workoutControllerProvider);
          ref.invalidate(excercisesControllerProvider);
          // ref.refresh(workoutControllerProvider(WorkoutType.feature).future);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 7.5.h,
              pinned: true,
              centerTitle: false,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Assets.app.workoutAppbarBg.image(
                        width: 100,
                        height: 10,
                        fit: BoxFit.cover,
                        alignment: Alignment.center),
                    Container(color: Colors.black.withOpacity(0.5)),
                  ],
                ),
              ),
              backgroundColor: Colors.black,
              elevation: 0,
              leadingWidth: 200,
              leading: Padding(
                padding: const EdgeInsets.all(Sizes.lg),
                child: Text(
                  "Start Your Workout",
                  style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                    color: AppColors.backgroundLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              actions: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.backgroundDark.withOpacity(0.4),
                  ),
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.only(right: Sizes.lg),
                  child: IconButton(
                    padding: const EdgeInsets.all(12),
                    onPressed: () {
                      if (!HelpersUtils.isAuthenticated(context)) {
                        return;
                      }
                      HelpersUtils.navigatorState(context).pushNamed(
                          AppPage.excerciseActivitiesForm,
                          arguments: {'title': '', 'date': selectedDate});
                    },
                    icon: const Icon(
                      Icons.add,
                      size: Sizes.xxl,
                      color: AppColors.backgroundLight,
                    ),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.lg, vertical: Sizes.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Sizes.lg))),
                            border: BorderSide(style: BorderStyle.none)),
                        unselectedDayTheme: const DayThemeData(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Color.fromARGB(255, 0, 0, 0)),
                        disabledDayTheme: DayThemeData(
                          backgroundColor: Colors.grey.shade500,
                        ),
                      ),
                      child: EasyDateTimeLinePicker.itemBuilder(
                        focusedDate: selectedDate,

                        monthYearPickerOptions: const MonthYearPickerOptions(),

                        itemBuilder: (context, date, isSelected, isDisabled,
                            isToday, onTap) {
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
                                  style: AppTextTheme.lightTextTheme.bodyLarge
                                      ?.copyWith(
                                          fontWeight: isSelected
                                              ? FontWeight.w500
                                              : FontWeight.w300),
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
                        // timelineOptions: TimelineOptions(height: 50),
                        currentDate: DateTime.now(),
                        headerOptions: HeaderOptions(
                          headerType: HeaderType.picker,
                          headerBuilder: (context, date, onTap) {
                            return InkWell(
                                onTap: onTap,
                                splashFactory: NoSplash.splashFactory,
                                overlayColor: const WidgetStatePropertyAll(
                                    Colors.transparent),
                                child: Row(
                                  children: [
                                    Text(
                                      DateFormat.yMMMM().format(date),
                                      style: AppTextTheme
                                          .lightTextTheme.titleLarge
                                          ?.copyWith(
                                              color: AppColors.secondaryColor),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: AppColors.secondaryColor,
                                    )
                                  ],
                                ));
                          },
                        ),
                        timelineOptions: const TimelineOptions(
                            height: 100, padding: EdgeInsets.all(0)),
                        firstDate: DateTime(2020, 3, 18),
                        lastDate: DateTime.now(),
                        onDateChange: (date) {
                          ref
                              .read(workoutDateControllerProvider.notifier)
                              .updateDate(date);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: Sizes.xs,
                    ),
                    const FeatureWorkout(),
                    const SizedBox(
                      height: Sizes.md,
                    ),
                    const WorkoutTabView(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
