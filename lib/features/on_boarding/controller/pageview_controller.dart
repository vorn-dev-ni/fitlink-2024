import 'package:flutter/material.dart';
import 'package:demo/features/on_boarding/widget/intro_main.dart';
import 'package:demo/gen/assets.gen.dart';

class OnBoardingController {
  late PageController controller;

  OnBoardingController() {
    controller = PageController(initialPage: 0);
  }
  List<Widget> get pages => [
        IntroMain(
          body: 'Find Your Fitness Community',
          title: 'Connect with others',
          backgroundAssets: Assets.app.artOne,
        ),
        IntroMain(
          body: 'Customized Work Out Plan',
          title: 'Building your workout',
          backgroundAssets: Assets.app.artTwo,
        ),
        IntroMain(
          body: 'Welcome to FitLink',
          title: 'Your fitness Companion',
          backgroundAssets: Assets.app.gymBackground,
        ),
      ];
}
