import 'package:demo/features/home/widget/workout/workout_body.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

class WorkoutTabView extends StatefulWidget {
  const WorkoutTabView({super.key});

  @override
  State<WorkoutTabView> createState() => _WorkoutTabViewState();
}

class _WorkoutTabViewState extends State<WorkoutTabView>
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workout Levels',
          style: AppTextTheme.lightTextTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: Sizes.md,
        ),
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
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
        const SizedBox(
          height: Sizes.lg,
        ),

        // TabBar without AppBar
        const WorkoutTabBuild(
          level: 'Intermediate',
        ),
      ],
    );
  }
}
