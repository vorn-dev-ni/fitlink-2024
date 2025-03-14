import 'dart:ui';
import 'package:demo/features/home/controller/logout_controller.dart';
import 'package:demo/features/home/controller/navbar_controller.dart';
import 'package:demo/core/riverpod/navigation_state.dart';
import 'package:demo/features/home/views/chat/chat_tab.dart';
import 'package:demo/features/home/views/main/home_tab.dart';
import 'package:demo/features/home/views/main/work_out/workout_tab.dart';
import 'package:demo/features/home/views/profile/profile_tab.dart';
import 'package:demo/features/other/no_internet.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<Widget> tabScreens = [
  const HomeTab(),
  const ChatTab(),
  const NoInternet(),
  const WorkoutTab(),
  ProfileTab(key: UniqueKey()),
];

class MyHomeScreen extends ConsumerStatefulWidget {
  const MyHomeScreen({super.key});

  @override
  ConsumerState<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends ConsumerState<MyHomeScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark, // For iOS
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext contex) {
    final tabIndex = ref.watch(navigationStateProvider);
    final navBars = ref.watch(navbarControllerProvider);
    final isLoggedOut = ref.watch(logoutControllerProvider);

    if (isLoggedOut) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(logoutControllerProvider.notifier).reset();
        setState(() {
          tabScreens[4] = ProfileTab(key: UniqueKey());
        });
      });
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.backgroundLight,
        // body: tabScreens[tabIndex],
        body: IndexedStack(
          index: tabIndex,
          children: tabScreens,
        ),
        bottomNavigationBar: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              padding: const EdgeInsets.only(top: 16),
              color: Colors.black.withOpacity(0.3),
              child: BottomNavigationBar(
                currentIndex: tabIndex,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 10,
                selectedItemColor: AppColors.secondaryColor,
                unselectedItemColor: AppColors.neutralColor,
                showSelectedLabels: false,
                onTap: _onTap,
                items: navBars,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int index) {
    if ([1, 2, 4].contains(index)) {
      bool isAuth = HelpersUtils.isAuthenticated(context);
      if (!isAuth) {
        return;
      }
    }
    if (index == 2) {
      HelpersUtils.navigatorState(context).pushNamed(AppPage.uploadingTab);
      return;
    }
    ref.read(navigationStateProvider.notifier).changeIndex(index);
  }
}
