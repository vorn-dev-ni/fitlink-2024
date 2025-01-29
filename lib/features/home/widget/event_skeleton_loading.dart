import 'package:demo/utils/constant/app_colors.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart'; // Import Skeletonizer package

class EventSkeletonLoading extends StatelessWidget {
  const EventSkeletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.7,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          return InkWell(
              highlightColor: AppColors.primaryColor,
              splashColor: AppColors.primaryColor,
              hoverColor: AppColors.primaryColor,
              child: InkWell(
                  highlightColor: AppColors.primaryColor,
                  splashColor: AppColors.primaryColor,
                  hoverColor: AppColors.primaryColor,
                  child: Stack(
                    children: [
                      FancyShimmerImage(
                        boxFit: BoxFit.cover,
                        shimmerBaseColor: index % 3 == 0
                            ? const Color.fromARGB(255, 252, 245, 245)
                            : const Color.fromARGB(255, 198, 195, 195),
                        imageUrl: index % 3 == 0
                            ? 'https://i.pinimg.com/736x/40/a2/cc/40a2cc94f0149b7c8e73fa8017c87d54.jpg'
                            : 'https://i.pinimg.com/736x/40/a2/cc/40a2cc94f0149b7c8e73fa8017c87d54.jpg',
                      ),
                    ],
                  )));
        },
      ),
    );
  }
}
