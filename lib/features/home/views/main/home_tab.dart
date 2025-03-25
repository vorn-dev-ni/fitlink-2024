import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/features/home/controller/posts/social_postone_controller.dart';
import 'package:demo/features/home/controller/tab/event_scroll_controller.dart';
import 'package:demo/features/home/controller/tab/home_scroll_controller.dart';
import 'package:demo/features/home/controller/tab/tab_loading.dart';
import 'package:demo/features/home/views/daily_workout/main_workout.dart';
import 'package:demo/features/home/views/main/event/event.dart';
import 'package:demo/features/home/views/main/my_home/social_media.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
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
    // WorkoutTab(),
    MainWorkoutScreen(),

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

    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          tabBarHeader(),
          tabBarContent(),
        ],
      ),
    );
  }

  Widget tabBarHeader() {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: Sizes.xl),
              child: Assets.utils.fitlinkLogo
                  .image(fit: BoxFit.contain, width: 70, height: 70),
            ),
            Expanded(
              child: TabBar(
                controller: _tabController,
                onTap: (value) {},
                indicatorColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                labelStyle: AppTextTheme.lightTextTheme.labelLarge,
                overlayColor:
                    const WidgetStatePropertyAll(AppColors.backgroundLight),
                dividerColor: Colors.transparent,
                indicatorWeight: 1,
                labelPadding: const EdgeInsets.all(Sizes.sm),
                labelColor: AppColors.secondaryColor,
                unselectedLabelColor: AppColors.neutralDark,
                tabs: [
                  GestureDetector(
                    onTap: () => _handleRefreshTab(0),
                    child: const Tab(
                      text: 'Home',
                    ),
                  ),
                  const Tab(text: 'Workout'),
                  GestureDetector(
                      onTap: () => _handleRefreshTab(2),
                      child: const Tab(text: 'Event')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: Sizes.sm),
              child: IconButton(
                onPressed: () {
                  HelpersUtils.navigatorState(context)
                      .pushNamed(AppPage.searchTikTok);
                },
                icon: const Icon(
                  Icons.search,
                  size: Sizes.iconMd,
                  color: Color.fromARGB(255, 180, 184, 190),
                ),
              ),
            ),
          ],
        ),
        renderLoading(),
      ],
    );
  }

  Widget renderLoading() {
    final isLoading = ref.watch(tabLoadingControllerProvider);
    return isLoading
        ? Positioned.fill(
            left: 0, right: 0, top: 45, child: appLoadingSpinner())
        : const SizedBox();
  }

  Expanded tabBarContent() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: _screens,
      ),
    );
  }

  void _handleRefreshTab(int index) {
    _tabController.animateTo(index);
    if (_tabController.index == index &&
        _tabController.indexIsChanging == false) {
      ref.read(tabLoadingControllerProvider.notifier).setState(true);

      switch (index) {
        case 0:
          ref.read(homeScrollControllerProvider.notifier).scrollToTop(
              duration: const Duration(milliseconds: 300),
              curve: Curves.bounceIn);
          // ref.invalidate(socialPostControllerProvider);
          ref.invalidate(socialPostoneControllerProvider);
          break;
        case 2:
          ref.read(eventScrollControllerProvider.notifier).scrollToTop(
              duration: const Duration(milliseconds: 300),
              curve: Curves.bounceIn);
          ref.invalidate(eventScrollControllerProvider);
          break;
      }

      Future.delayed(const Duration(seconds: 1), () {
        ref.read(tabLoadingControllerProvider.notifier).setState(false);
      });
    }
  }
}
