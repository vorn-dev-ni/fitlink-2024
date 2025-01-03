import 'package:demo/common/model/grid_meal.dart';
import 'package:demo/features/home/widget/grid_meal_item.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';

class GridMealView extends StatelessWidget {
  const GridMealView({
    super.key,
    required this.data,
  });

  final List<Gridmeal> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Sizes.md),
      child: SizedBox(
        // height: 200,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            final Gridmeal item = data[index];
            return GridMealItem(
              item,
              onTap: () {},
            );
          },
          shrinkWrap: true,
        ),
      ),
    );
  }
}
