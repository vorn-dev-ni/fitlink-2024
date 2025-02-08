import 'dart:ui';
import 'package:demo/features/home/controller/navbar_controller.dart';
import 'package:demo/core/riverpod/navigation_state.dart';
import 'package:demo/features/home/views/chat/chat_tab.dart';
import 'package:demo/features/home/views/main/home_tab.dart';
import 'package:demo/features/home/views/profile/profile_tab.dart';
import 'package:demo/features/home/views/upload/upload_tab.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<Widget> tabScreens = const [
  HomeTab(),
  ChatTab(),
  UploadTab(),
  Center(
    child: Text('Coming soon'),
  ),
  ProfileTab()
];

class MyHomeScreen extends ConsumerStatefulWidget {
  const MyHomeScreen({super.key});

  @override
  ConsumerState<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends ConsumerState<MyHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext contex) {
    final tabIndex = ref.watch(navigationStateProvider);
    final navBars = ref.watch(navbarControllerProvider);
    return Scaffold(
      extendBody: true,
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
              onTap: (index) {
                if ([1, 2, 4].contains(index)) {
                  final email = LocalStorageUtils().getKey('email');
                  if (email == "" || email == null) {
                    HelpersUtils.navigatorState(context)
                        .pushNamed(AppPage.auth);
                    return;
                  }
                }
                ref.read(navigationStateProvider.notifier).changeIndex(index);
              },
              items: navBars,
            ),
          ),
        ),
      ),
    );
  }
}
