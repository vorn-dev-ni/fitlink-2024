import 'package:demo/common/model/grid_meal.dart';
import 'package:demo/features/home/widget/activity_list.dart';
import 'package:demo/features/home/widget/grid_meal_view.dart';
import 'package:flutter/material.dart';

class GymActivity extends StatelessWidget {
  const GymActivity({
    super.key,
    required this.myMeals,
  });

  final List<Gridmeal> myMeals;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [GridMealView(data: myMeals), const ActivityList()],
    );
  }
}
