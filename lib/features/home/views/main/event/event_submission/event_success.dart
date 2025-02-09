import 'package:demo/common/widget/button.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventSubmissSuccess extends ConsumerStatefulWidget {
  const EventSubmissSuccess({super.key});

  @override
  ConsumerState<EventSubmissSuccess> createState() =>
      _EmailVerifyConfimrationState();
}

class _EmailVerifyConfimrationState extends ConsumerState<EventSubmissSuccess> {
  late AuthController authController;

  @override
  void initState() {
    authController = AuthController(ref: ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: renderBody(),
        ),
      ],
    );
  }

  Widget renderBody() {
    return PopScope(
      canPop: false,
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(Sizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: Sizes.xxxl,
            ),
            Assets.app.catGym.image(width: 250, height: 250, fit: BoxFit.cover),
            const SizedBox(
              height: Sizes.lg,
            ),
            Text(
              'Thanks you',
              style: AppTextTheme.lightTextTheme.headlineLarge,
            ),
            const SizedBox(
              height: Sizes.sm,
            ),
            Text(
              'Your request has been submitted, we will contact you back in 1-2 business days!!!',
              textAlign: TextAlign.center,
              style: AppTextTheme.lightTextTheme.bodyMedium
                  ?.copyWith(color: AppColors.neutralDark),
            ),
            const Spacer(),
            ButtonApp(
                height: 18,
                splashColor: const Color.fromARGB(255, 207, 225, 255),
                label: "Back to home",
                onPressed: () {
                  HelpersUtils.navigatorState(context).pushNamedAndRemoveUntil(
                    AppPage.home,
                    (route) => false,
                  );
                },
                radius: 0,
                textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                    color: AppColors.backgroundLight,
                    fontWeight: FontWeight.w500) as dynamic,
                color: AppColors.secondaryColor,
                textColor: Colors.white,
                elevation: 0),
          ],
        ),
      )),
    );
  }
}
