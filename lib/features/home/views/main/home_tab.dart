import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/features/home/controller/event/events_listing_controller.dart';
import 'package:demo/features/home/controller/posts/social_post_controller.dart';
import 'package:demo/features/home/controller/tab/event_scroll_controller.dart';
import 'package:demo/features/home/controller/tab/home_scroll_controller.dart';
import 'package:demo/features/home/views/main/event/event.dart';
import 'package:demo/features/home/views/main/my_home/social_media.dart';
import 'package:demo/features/home/views/main/work_out/workout_tab.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
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

    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          tabBarHeader(),
          tabBarContent(),
        ],
      ),
    );
  }

  Widget tabBarHeader() {
    return Row(
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
            onTap: (value) {
              switch (value) {
                case 0:
                  ref.read(homeScrollControllerProvider.notifier).scrollToTop(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.bounceIn);
                  ref.invalidate(socialPostControllerProvider);
                  break;
                case 2:
                  ref.read(eventScrollControllerProvider.notifier).scrollToTop(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.bounceIn);
                  ref.invalidate(eventsListingControllerProvider);
                  break;
                default:
                  break;
              }
            },
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
            tabs: const [
              Tab(
                text: 'Home',
              ),
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
}
