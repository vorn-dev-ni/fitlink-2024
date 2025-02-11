import 'package:demo/features/home/widget/workout/feature_workout.dart';
import 'package:demo/features/home/widget/workout/workout_tab_bar.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class MainWorkoutScreen extends StatefulWidget {
  const MainWorkoutScreen({super.key});

  @override
  State<MainWorkoutScreen> createState() => _MainWorkoutScreenState();
}

class _MainWorkoutScreenState extends State<MainWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 7.5.h,
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
                  HelpersUtils.navigatorState(context)
                      .pushNamed(AppPage.excerciseActivitiesForm);
                },
                icon: const Icon(
                  Icons.add,
                  size: Sizes.xxl,
                  color: AppColors.backgroundLight,
                )),
          ),
        ],
        flexibleSpace: Stack(
          fit: StackFit.expand,
          children: [
            Assets.app.workoutAppbarBg.image(fit: BoxFit.cover),
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
        title: Text(
          "Start Your Workout",
          style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
              color: AppColors.backgroundLight,
              fontWeight: FontWeight.w500), // Ensure text is visible
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.lg),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(Sizes.lg))),
                        border: BorderSide(style: BorderStyle.none)),
                    unselectedDayTheme: const DayThemeData(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Color.fromARGB(255, 0, 0, 0)),
                    disabledDayTheme: DayThemeData(
                      backgroundColor: Colors.grey.shade500,
                    ),
                  ),
                  child: EasyDateTimeLinePicker.itemBuilder(
                    focusedDate: DateTime.now(),

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
                                  style: AppTextTheme.lightTextTheme.titleLarge
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
                    firstDate: DateTime(2024, 3, 18),
                    lastDate: DateTime(2050, 3, 18),
                    onDateChange: (date) {
                      // Handle the selected date.
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
                WorkoutTabView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
