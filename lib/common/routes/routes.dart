import 'package:demo/common/model/route_app.dart';
import 'package:demo/common/model/screen_app.dart';
import 'package:demo/features/home/about.dart';
import 'package:demo/features/home/demo.dart';
import 'package:demo/features/home/welcome_screen.dart';
import 'package:demo/features/other/no_internet.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  static final List<RoutesApp> mainStacks = [
    RoutesApp(
        routeName: AppPage.FIRST, builder: (context) => const WelcomeScreen()),
    RoutesApp(
        routeName: AppPage.NO_INTERNET,
        builder: (context) => const NoInternet()),
  ];
  static final List<ScreenApp> navigationStacks = [
    ScreenApp(
        routeName: AppPage.NAV_WELCOME_HOME,
        arguments: null,
        builder: (context) => const DemoScreen(),
        iconSvg: SvgAsset.homeSvg),
    ScreenApp(
        routeName: AppPage.NAV_ACCOUNT,
        arguments: null,
        builder: (context) => AboutScreen(),
        iconSvg: SvgAsset.accountSvg),
  ];

  static Map<String, WidgetBuilder> getAppRoutes() {
    Map<String, WidgetBuilder> routeMap = Map.fromEntries(
      AppRoutes.mainStacks.map((e) => MapEntry(e.routeName, e.builder)),
    );

    return routeMap;
  }
}
