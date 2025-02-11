import 'package:flutter/material.dart';

class WorkoutProfile extends StatefulWidget {
  const WorkoutProfile({super.key});

  @override
  State<WorkoutProfile> createState() => _WorkoutProfileState();
}

class _WorkoutProfileState extends State<WorkoutProfile> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Workout Tab"));
  }
}
