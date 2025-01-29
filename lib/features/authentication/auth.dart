import 'dart:async';

import 'package:demo/common/widget/backdrop_loading.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/features/authentication/views/login/login_email.dart';
import 'package:demo/features/authentication/views/login/login_phone.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  StreamSubscription<User?>? streamAuthState;
  final List<Widget> _screens = const [EmailLoginTab(), PhoneNumberTab()];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _screens.length, vsync: this);

    _tabController.addListener(() {
      DeviceUtils.hideKeyboard(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    // streamAuthState?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLoading = ref.watch(appLoadingStateProvider);
    return GestureDetector(
      onTap: () => DeviceUtils.hideKeyboard(context),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(Sizes.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerTitle(),
                    tabBarHeader(),
                    tabBarContent(),
                  ],
                ),
              ),
              if (appLoading == true)
                backDropLoading(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0)),
            ],
          ),
        ),
      ),
    );
  }

  Column headerTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Login',
          style: AppTextTheme.lightTextTheme.headlineLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          '“STAY FIT - STAY CONNECTED”',
          style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
              color: AppColors.neutralDark, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  TabBar tabBarHeader() {
    return TabBar(
      controller: _tabController,
      padding: const EdgeInsets.only(top: Sizes.xl),
      indicatorColor: AppColors.secondaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      isScrollable: true,

      tabAlignment: TabAlignment.start,
      labelStyle: AppTextTheme.lightTextTheme.titleMedium,
      overlayColor: const WidgetStatePropertyAll(AppColors.backgroundLight),
      dividerColor: Colors.transparent,
      // indicatorPadding: const EdgeInsets.all(2),
      indicatorWeight: 1,

      labelColor: AppColors.secondaryColor,
      unselectedLabelColor: AppColors.neutralDark,
      tabs: const [
        Tab(text: 'Email'),
        Tab(text: 'Phone Number'),
      ],
    );
  }

  Expanded tabBarContent() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: const [EmailLoginTab(), PhoneNumberTab()],
      ),
    );
  }
}
