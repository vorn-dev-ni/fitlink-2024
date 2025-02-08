import 'package:demo/common/model/user_model.dart';
import 'package:demo/core/riverpod/navigation_state.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/features/authentication/controller/login_controller.dart';
import 'package:demo/features/authentication/controller/register_controller.dart';
import 'package:demo/features/home/controller/navbar_controller.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/features/home/views/profile/events/event_profile.dart';
import 'package:demo/features/home/views/profile/favorites/favorite_profile.dart';
import 'package:demo/features/home/views/profile/post/post_profile.dart';
import 'package:demo/features/home/views/profile/profile_header.dart';
import 'package:demo/features/home/views/profile/video/video_profile.dart';
import 'package:demo/features/home/views/workout/workout_profile.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  late final AuthController authController;
  AuthModel? currentUser;
  late List<Tab> _tabBarheaders;
  late List<Widget> _screens;

  @override
  void initState() {
    _screens = [
      const PostProfile(),
      const VideoProfile(),
      const EventProfile(),
      const FavoriteProfile(),
      const WorkoutProfile(),
    ];
    _tabBarheaders = [
      Tab(
          icon: Text(
        'Posts',
        style: AppTextTheme.lightTextTheme.labelLarge,
      )),
      Tab(
          icon: Text(
        'Videos',
        style: AppTextTheme.lightTextTheme.labelLarge,
      )),
      Tab(
          icon: Text(
        'Events',
        style: AppTextTheme.lightTextTheme.labelLarge,
      )),
      Tab(
          icon: Text(
        'Favorites',
        style: AppTextTheme.lightTextTheme.labelLarge,
      )),
      Tab(
          icon: Text(
        'Workout',
        style: AppTextTheme.lightTextTheme.labelLarge,
      )),
    ];
    if (mounted) {
      authController = AuthController(ref: ref);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final asyncUser = ref.watch(profileUserControllerProvider);

    return DefaultTabController(
      length: _screens.length,
      child: Scaffold(
          extendBodyBehindAppBar: false,
          body: asyncUser.when(
            data: (data) {
              final emailExisted = data?.email;
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  ProfileHeader(
                    onLogout: () {
                      handleLogout();
                    },
                  ),
                ],
                body: Skeletonizer(
                  enabled: emailExisted == null ? true : false,
                  child: SafeArea(
                    child: Column(
                      children: [
                        TabBar(
                          tabAlignment: TabAlignment.center,
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.label,
                          dividerColor: Colors.transparent,
                          tabs: _tabBarheaders,
                          indicatorColor: AppColors.secondaryColor,
                        ),
                        renderView()
                      ],
                    ),
                  ),
                ),
              );
            },
            error: (error, stackTrace) => const Text(''),
            loading: () {
              return build_loading();
            },
          )),
    );
  }

  Skeletonizer build_loading() {
    return Skeletonizer(
      enabled: true,
      ignorePointers: true,
      justifyMultiLineText: false,
      effect: const ShimmerEffect(
          highlightColor: Colors.white,
          baseColor: Color.fromARGB(212, 213, 213, 213)),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          ProfileHeader(
            onLogout: () {
              // handleLogout();
            },
          ),
        ],
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                tabAlignment: TabAlignment.center,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Colors.transparent,
                tabs: _tabBarheaders,
                indicatorColor: AppColors.secondaryColor,
              ),
              renderView()
            ],
          ),
        ),
      ),
    );
  }

  Widget renderView() {
    return Expanded(
      child: TabBarView(
        children: _screens,
      ),
    );
  }

  void handleLogout() async {
    if (mounted) {
      Fluttertoast.showToast(
          msg: 'See you soon love 😔 !!!',
          timeInSecForIosWeb: 5,
          toastLength: Toast.LENGTH_LONG);
    }
    ref.invalidate(navbarControllerProvider);
    ref.invalidate(navigationStateProvider);
    ref.invalidate(registerControllerProvider);
    ref.invalidate(loginControllerProvider);
    ref.invalidate(profileUserControllerProvider);
    LocalStorageUtils().setKeyString('email', '');
    await authController.logout();
  }
}
