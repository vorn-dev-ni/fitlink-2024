import 'package:demo/common/widget/button.dart';
import 'package:demo/common/widget/duration_card.dart';
import 'package:demo/common/widget/tag_cad.dart';
import 'package:demo/features/home/model/activity.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/image_asset.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:demo/utils/constant/sizes.dart';

class ActivityList extends StatefulWidget {
  const ActivityList({super.key});

  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  List<Activity> _activities = [];
  @override
  void initState() {
    super.initState();
    _activities = [
      Activity(
        title: 'Morning Gym Session',
        imageUrl:
            'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=3570&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        tag: ActivityTag.gym,
        createdDate:
            DateTime.now().subtract(const Duration(days: 1)), // Yesterday
      ),
      Activity(
        title: 'Lunch at Italian Restaurant',
        tag: ActivityTag.food,
        imageUrl:
            'https://plus.unsplash.com/premium_photo-1661265933107-85a5dbd815af?q=80&w=3518&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',

        createdDate:
            DateTime.now().subtract(const Duration(days: 2)), // 2 days ago
      ),
      Activity(
        title: 'Evening Cardio',
        tag: ActivityTag.gym,
        imageUrl:
            'https://plus.unsplash.com/premium_photo-1661920538067-c48451160c72?q=80&w=3570&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',

        createdDate:
            DateTime.now().subtract(const Duration(hours: 5)), // 5 hours ago
      ),
      Activity(
        title: 'Dinner at Sushi Place',
        tag: ActivityTag.food,
        imageUrl:
            'https://images.unsplash.com/photo-1521805103424-d8f8430e8933?q=80&w=3570&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',

        createdDate:
            DateTime.now().subtract(const Duration(days: 3)), // 3 days ago
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.lg),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _activities.length, // Add 1 to include the header
        itemBuilder: (context, index) {
          late final activities = _activities[index];
          if (index == 0) {
            return TouchableHeader();
          }
          return AcitivtyTabItem(activities);
        },
      ),
    );
  }

  Widget AcitivtyTabItem(Activity activities) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
      child: Material(
        color: AppColors.secondaryColor,
        elevation: 0,
        type: MaterialType.button,
        // clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(Sizes.xl),
        child: InkWell(
          onTap: () {
            // Handle tap action here
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.blue.withOpacity(0.3),
          highlightColor: Colors.blue.withOpacity(0.1),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    fadeInCurve: Curves.linear,
                    fadeOutCurve: Curves.bounceOut,
                    width: 80,
                    height: 80,
                    // imageCacheHeight: 80,
                    // imageCacheWidth: 80,
                    fadeInDuration: const Duration(milliseconds: 500),
                    placeholder: ImageAsset.placeHolderImage,
                    image: activities.imageUrl,
                  ),
                ),
              ),
              const SizedBox(
                width: Sizes.sm,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      activities.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.lightTextTheme.titleMedium
                          ?.copyWith(color: AppColors.primaryColor),
                    ),
                    const SizedBox(
                      height: Sizes.sm - 2,
                    ),
                    Row(
                      // mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TagCard(label: 'Gym'),
                        const Spacer(),
                        Padding(
                            padding: const EdgeInsets.only(right: Sizes.lg),
                            child: DurationCard(label: '3d'))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget TouchableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Sizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Activity',
            style: AppTextTheme.lightTextTheme.bodyLarge
                ?.copyWith(color: AppColors.textColor),
          ),
          ButtonApp(
              splashColor: AppColors.primaryColor,
              label: 'View All',
              onPressed: () {},
              radius: Sizes.lg,
              textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600) as dynamic,
              color: AppColors.secondaryColor,
              textColor: Colors.white,
              elevation: 0),
        ],
      ),
    );
  }
}
