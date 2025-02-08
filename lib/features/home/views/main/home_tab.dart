import 'package:demo/common/model/user_model.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/features/home/controller/navbar_controller.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/features/home/views/main/event/event.dart';
import 'package:demo/features/home/views/main/my_home/social_media.dart';
import 'package:demo/features/home/views/main/work_out/workout_tab.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab>
    with TickerProviderStateMixin {
  late FirestoreService firestoreService;
  late TabController _tabController;
  final List<Widget> _screens = const [
    SocialMediaTab(),
    WorkoutTab(),
    EventTabs(),
  ];

  @override
  void didChangeDependencies() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark, // For iOS
    ));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark, // For iOS
    ));
    firestoreService =
        FirestoreService(firebaseAuthService: FirebaseAuthService());
    _tabController = TabController(length: _screens.length, vsync: this);

    // if (FirebaseAuth.instance.currentUser != null) {
    //   syncUser();
    // }

    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        tabBarHeader(),
        tabBarContent(),
      ],
    );
  }

  Widget tabBarHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: Sizes.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
            child: Assets.utils.fitlinkLogo
                .image(fit: BoxFit.contain, width: 85, height: 85),
          ),
          Expanded(
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelStyle: AppTextTheme.lightTextTheme.labelLarge,
              overlayColor:
                  const WidgetStatePropertyAll(AppColors.backgroundLight),
              dividerColor: Colors.transparent,
              indicatorWeight: 1,
              labelPadding: const EdgeInsets.all(Sizes.sm),
              labelColor: AppColors.secondaryColor,
              unselectedLabelColor: AppColors.neutralDark,
              tabs: const [
                Tab(text: 'Home'),
                Tab(text: 'Workout'),
                Tab(text: 'Event'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: Sizes.sm),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                size: Sizes.iconMd,
                color: Color.fromARGB(255, 180, 184, 190),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded tabBarContent() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: _screens,
      ),
    );
  }

  Future syncUser() async {
    try {
      AuthModel? authModel = await firestoreService
          .getEmail(FirebaseAuth.instance.currentUser!.uid);

      debugPrint("Tab ?>>> ${authModel}");

      ref.invalidate(navbarControllerProvider);

      ref
          .read(navbarControllerProvider.notifier)
          .updateProfileTab(authModel.avatar ?? "");
      ref.invalidate(profileUserControllerProvider);
    } catch (e) {
      if (mounted) {
        HelpersUtils.showErrorSnackbar(
            duration: 2000,
            context,
            'Oop!',
            e.toString(),
            StatusSnackbar.failed);
      }
    }
  }
}
