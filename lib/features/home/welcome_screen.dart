import 'package:demo/common/model/screen_app.dart';
import 'package:demo/core/riverpod/app_setting.dart';
import 'package:demo/core/riverpod/navigation_state.dart';
import 'package:demo/common/routes/routes.dart';
import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/bottom_nav.dart';
import 'package:demo/features/app_screen.dart';
import 'package:demo/features/home/model/app_bar.dart';
import 'package:demo/generated/l10n.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/flavor/config.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo/utils/localization/translation_helper.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  DateTime today = HelpersUtils.getToday();
  late List<BottomNavigationBarItem> navItems = [];
  late List<ScreenApp> renderScreen = [];
  late String titleBar = "";
  String? username = "";

  @override
  void initState() {
    super.initState();

    AppRoutes.navigationStacks.forEach(
      (element) {
        navItems.add(
          BottomNavigationBarItem(
            // icon: Icon(Icons.home),
            activeIcon: element.routeName == AppPage.NAV_SCAN
                ? Material(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(Sizes.xxxl),
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.lg),
                      child: SvgPicture.string(
                        element.iconSvg ?? "",
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                            AppColors.backgroundLight, BlendMode.srcIn),
                      ),
                    ),
                  )
                : SvgPicture.string(
                    element.iconSvg ?? "",
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                        AppColors.primaryColor, BlendMode.srcIn),
                  ),
            icon: element.routeName == AppPage.NAV_SCAN
                ? Material(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(Sizes.xxxl),
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.lg),
                      child: SvgPicture.string(
                        element.iconSvg ?? "",
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                            AppColors.backgroundLight, BlendMode.srcIn),
                      ),
                    ),
                  )
                : SvgPicture.string(
                    element.iconSvg ?? "",
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                        AppColors.primaryColor.withOpacity(0.3),
                        BlendMode.srcIn),
                  ),
            backgroundColor: AppColors.backgroundLight,
            label: element.routeName,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = ref.watch(navigationStateProvider);
    final appSettings = ref.watch(appSettingsControllerProvider);

    debugPrint("Re rendering state welcome again");

    return Scaffold(
      appBar: _appBar(selectedIndex, appSettings.appTheme!),
      backgroundColor:
          SchemaData.getAppTheme(appSettings.appTheme!).scaffoldBackgroundColor,
      body: _widgetBody(selectedIndex, renderScreen),
      bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: selectedIndex, onTap: _onTap, items: navItems),
    );
  }

  AppBarConfig getAppBarConfig(
      int selectedIndex, AppLocalizations appLocalizations) {
    switch (selectedIndex) {
      case 0:
        return AppBarConfig(
            text:
                "${appLocalizations.product_flavor} ${AppConfig.appConfig.flavor.value}",
            isCenter: false,
            showHeader: true);
      case 1:
        return AppBarConfig(
            text: appLocalizations.settings,
            isCenter: false,
            showHeader: false);

      default:
        return const AppBarConfig(
            text: "", isCenter: false, showHeader: false); // Default values
    }
  }

  AppBar _appBar(int selectedIndex, AppTheme appTheme) {
    return AppBarCustom(
        bgColor: SchemaData.getAppTheme(appTheme).scaffoldBackgroundColor,
        text: getAppBarConfig(selectedIndex, tr(context)).text,
        textColor: SchemaData.getAppTheme(appTheme).colorScheme.primary,
        showheader: getAppBarConfig(selectedIndex, tr(context)).showHeader,
        isCenter: getAppBarConfig(selectedIndex, tr(context)).isCenter);
  }

  SafeArea _widgetBody(int selectedIndex, renderScreen) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.xl - 2),
      child: SingleChildScrollView(
          child: navigationScreen(selectedIndex, context)),
    ));
  }

  void _onTap(int p1) {
    ref.read(navigationStateProvider.notifier).changeIndex(p1);
  }
}
