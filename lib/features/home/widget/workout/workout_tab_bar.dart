import 'package:demo/features/home/widget/workout/workout_body.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorkoutTabView extends ConsumerStatefulWidget {
  const WorkoutTabView({super.key});

  @override
  ConsumerState<WorkoutTabView> createState() => _WorkoutTabViewState();
}

class _WorkoutTabViewState extends ConsumerState<WorkoutTabView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: Sizes.md,
        ),

        Text(
          'Workout Levels',
          style: AppTextTheme.lightTextTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: Sizes.md,
        ),

        // TabBar without AppBar
        const WorkoutTabBuild(
          level: 'Intermediate',
        ),
      ],
    );
  }
}
