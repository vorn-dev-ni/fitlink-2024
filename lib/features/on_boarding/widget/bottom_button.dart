import 'package:demo/common/widget/button.dart';
import 'package:demo/features/on_boarding/controller/start_page_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomButtonStarter extends ConsumerWidget {
  const BottomButtonStarter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = ref.watch(startPageControllerProvider);
    if (activeIndex < 2) {
      return const SizedBox();
    }
    return Positioned(
      bottom: 20,
      right: Sizes.xl,
      child: ButtonApp(
        label: 'Enter',
        radius: 25,
        color: AppColors.secondaryColor,
        textStyle: AppTextTheme.lightTextTheme.titleMedium!.copyWith(
          color: AppColors.backgroundLight,
        ),
        splashColor: AppColors.backgroundLight,
        onPressed: () {
          HelpersUtils.navigatorState(context).pushNamedAndRemoveUntil(
            AppPage.auth,
            (route) => false,
          );
        },
      ),
    );
  }
}
