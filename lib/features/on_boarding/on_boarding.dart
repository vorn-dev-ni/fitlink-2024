import 'package:demo/features/on_boarding/controller/pageview_controller.dart';
import 'package:demo/features/on_boarding/controller/start_page_controller.dart';
import 'package:demo/features/on_boarding/widget/bottom_button.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  ConsumerState<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  late OnBoardingController onBoardingController;
  @override
  void initState() {
    super.initState();
    onBoardingController = OnBoardingController();
    bindingState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          PageView.builder(
            onPageChanged: (value) {
              ref.read(startPageControllerProvider.notifier).updatePage(value);
            },
            itemCount: onBoardingController.pages.length,
            itemBuilder: (context, index) {
              return onBoardingController.pages[index];
            },
            controller: onBoardingController.controller,
          ),
          linearDotIndicator(),
          const BottomButtonStarter()
        ],
      ),
    );
  }

  Positioned linearDotIndicator() {
    return Positioned(
      bottom: 50,
      left: Sizes.xl,
      child: SmoothPageIndicator(
        controller: onBoardingController.controller,
        count: onBoardingController.pages.length,
        axisDirection: Axis.horizontal,
        effect: const SlideEffect(
            spacing: 0.0,
            radius: 0.0,
            dotWidth: 30.0,
            dotHeight: 4.0,
            strokeWidth: 1.5,
            dotColor: Colors.grey,
            activeDotColor: AppColors.secondaryColor),
      ),
    );
  }

  Future bindingState() async {
    await LocalStorageUtils().setBoolKey('firstTime', false);
  }
}
