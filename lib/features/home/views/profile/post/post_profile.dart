import 'package:demo/utils/constant/sizes.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PostProfile extends StatefulWidget {
  const PostProfile({super.key});

  @override
  State<PostProfile> createState() => _PostProfileState();
}

class _PostProfileState extends State<PostProfile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
      child: ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.only(top: Sizes.xl, bottom: 140),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Sizes.xs),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.lg),
              child: FancyShimmerImage(
                  width: 100.w,
                  boxFit: BoxFit.cover,
                  height: 250,
                  imageUrl: index % 2 == 0
                      ? 'https://www.fastandup.in/nutrition-world/wp-content/uploads/2023/05/Workouts-for-Men.jpg'
                      : 'https://hips.hearstapps.com/hmg-prod/images/social-media-lifting-654a0331a2803.jpg?crop=1.00xw:0.751xh;0,0.204xh&resize=1200:*'),
            ),
          );
        },
      ),
    );
  }
}
