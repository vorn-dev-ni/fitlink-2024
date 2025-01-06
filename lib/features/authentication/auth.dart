import 'package:demo/features/authentication/phone_num.dart';
import 'package:demo/features/authentication/widget/login/email_login.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<Widget> _screens = const [EmailLoginTab(), PhoneNumberTab()];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _screens.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
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

      labelColor: AppColors.secondaryColor, // Active tab text color
      unselectedLabelColor: AppColors.neutralDark, // Inactive tab text color
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
