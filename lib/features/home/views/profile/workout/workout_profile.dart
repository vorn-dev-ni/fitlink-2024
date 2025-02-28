import 'package:demo/features/home/views/profile/workout/workout_activities.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutProfile extends ConsumerStatefulWidget {
  String userId;
  WorkoutProfile({super.key, required this.userId});

  @override
  ConsumerState<WorkoutProfile> createState() => _WorkoutProfileState();
}

class _WorkoutProfileState extends ConsumerState<WorkoutProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.lg),
        child: Column(
          children: [
            WorkoutActivities(
              userId: widget.userId,
            ),
          ],
        ),
      ),
    );
  }
}
