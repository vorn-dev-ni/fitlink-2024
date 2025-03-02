import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';

class EventItemSkeleton extends StatelessWidget {
  const EventItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Skeleton for Image
        Container(
          width: double.infinity,
          height: 300, // Adjust height as needed
          color: Colors.grey[300],
        ),

        // Skeleton for Date Badge
        Positioned(
          top: Sizes.md,
          left: Sizes.md,
          child: Container(
            padding: const EdgeInsets.all(Sizes.sm),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(Sizes.md),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 12,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 4),
                Container(
                  width: 20,
                  height: 16,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ),

        // Skeleton for Bottom Text
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Sizes.lg, vertical: Sizes.md),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 80, height: 12, color: Colors.grey[300]),
                    Container(width: 40, height: 12, color: Colors.grey[300]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
