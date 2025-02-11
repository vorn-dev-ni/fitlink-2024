import 'package:demo/common/widget/horidivider.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class WorkoutTabBuild extends StatelessWidget {
  final String level;

  const WorkoutTabBuild({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Example count
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: Sizes.lg),
      shrinkWrap: true,
      // padding: const EdgeInsets.all(Sizes.md),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Sizes.md, top: 0),
          child: InkWell(
            onTap: () {
              HelpersUtils.navigatorState(context).pushNamed(AppPage.excercise);
            },
            child: Stack(
              children: [
                Positioned.fill(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(Sizes.lg),
                  child: FancyShimmerImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Z3ltfGVufDB8fDB8fHww',
                    boxFit: BoxFit.cover,
                  ),
                )),
                Positioned.fill(
                    child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.lg),
                      color: AppColors.backgroundDark.withOpacity(0.3),
                    ),
                  ),
                )),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.lg),
                    color: AppColors.backgroundDark.withOpacity(0.4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$level Workout',
                          style: AppTextTheme.lightTextTheme.titleLarge
                              ?.copyWith(color: AppColors.backgroundLight),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '20 Mins',
                              style: AppTextTheme.lightTextTheme.labelSmall
                                  ?.copyWith(color: AppColors.backgroundLight),
                            ),
                            const SizedBox(width: 8),
                            horiDivider(),
                            const SizedBox(width: 8),
                            Text(
                              '10 Exercises',
                              style: AppTextTheme.lightTextTheme.labelSmall
                                  ?.copyWith(color: AppColors.backgroundLight),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
