import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/features/home/widget/map_display.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ExcerciseDetail extends StatefulWidget {
  const ExcerciseDetail({super.key});

  @override
  State<ExcerciseDetail> createState() => _ExcerciseDetailState();
}

class _ExcerciseDetailState extends State<ExcerciseDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        isCenter: true,
        showheader: false,
        text: 'PPL Workout',
        trailing: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () {
              HelpersUtils.navigatorState(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        bgColor: Colors.transparent,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FancyShimmerImage(
              boxFit: BoxFit.cover,
              width: 100.w,
              height: 200,
              imageUrl:
                  'https://cdn.shopify.com/s/files/1/0269/5551/3900/files/Dumbbell-Bent-Over-Row-_Single-Arm_49867db3-f465-4fbc-b359-29cbdda502e2_600x600.png?v=1612138069',
            ),
            const SizedBox(
              height: Sizes.xl,
            ),
            Text(
              'Barbel Row',
              style: AppTextTheme.lightTextTheme.bodyLarge,
            ),
            const SizedBox(
              height: Sizes.lg,
            ),
            Container(
              padding: const EdgeInsets.all(Sizes.xxxl),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: AppColors.secondaryColor, width: 4)),
              child: Column(
                children: [
                  Text(
                    'Remaining ',
                    style: AppTextTheme.lightTextTheme.bodyMedium,
                  ),
                  Text(
                    '60',
                    style: AppTextTheme.lightTextTheme.headlineLarge
                        ?.copyWith(color: AppColors.secondaryColor),
                  ),
                  Text(
                    'seconds',
                    style: AppTextTheme.lightTextTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: Sizes.lg,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sets count: ',
                  style: AppTextTheme.lightTextTheme.bodyMedium,
                ),
                const SizedBox(
                  width: Sizes.xs,
                ),
                Text(
                  '2',
                  style: AppTextTheme.lightTextTheme.bodyMedium
                      ?.copyWith(color: AppColors.secondaryColor),
                ),
              ],
            ),
            const SizedBox(
              height: Sizes.lg,
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.xxxl + 20, vertical: Sizes.lg),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 1, color: AppColors.secondaryColor),
                      borderRadius: BorderRadius.circular(Sizes.xxxl)),
                  foregroundColor: AppColors.secondaryColor),
              onPressed: () {},
              label: const Text('DONE'),
              icon: const Icon(Icons.check),
            ),
            const SizedBox(
              height: Sizes.lg,
            ),
            Padding(
              padding: const EdgeInsets.all(Sizes.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(Sizes.md),
                          backgroundColor: AppColors.secondaryColor,
                          foregroundColor: AppColors.backgroundLight),
                      onPressed: () {},
                      label: const Text('PAUSE'),
                      icon: const Icon(Icons.pause),
                    ),
                  ),
                  const SizedBox(
                    width: Sizes.lg,
                  ),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(Sizes.md),
                          backgroundColor: AppColors.secondaryColor,
                          foregroundColor: AppColors.backgroundLight),
                      onPressed: () {},
                      label: const Text('NEXT SET'),
                      icon: const Icon(Icons.arrow_forward_sharp),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
