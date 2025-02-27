import 'package:demo/common/model/user_model.dart';
import 'package:demo/core/riverpod/navigation_state.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/features/authentication/controller/login_controller.dart';
import 'package:demo/features/authentication/controller/register_controller.dart';
import 'package:demo/features/home/controller/navbar_controller.dart';
import 'package:demo/features/home/controller/posts/social_post_controller.dart';
import 'package:demo/features/home/controller/posts/user_like_controller.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/features/home/controller/profile/user_form_controller.dart';
import 'package:demo/features/home/views/profile/events/event_profile.dart';
import 'package:demo/features/home/views/profile/favorites/favorite_profile.dart';
import 'package:demo/features/home/views/profile/post/post_profile.dart';
import 'package:demo/features/home/views/profile/profile_header.dart';
import 'package:demo/features/home/views/profile/video/video_profile.dart';
import 'package:demo/features/home/views/profile/workout/workout_profile.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
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
  late AudioPlayer _playsoundLogout;

  @override
  void initState() {
    _playsoundLogout = AudioPlayer();
    binding();
    _screens = [
      const PostProfile(),
      const VideoProfile(),
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
          // extendBodyBehindAppBar: false,
          // backgroundColor: AppColors.backgroundDark,
          body: asyncUser.when(
        data: (data) {
          final emailExisted = data?.email;
          return SafeArea(
            top: DeviceUtils.isIOS(),
            child: NestedScrollView(
              floatHeaderSlivers: false,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                ProfileHeader(
                  onLogout: () {
                    handleLogout();
                  },
                ),
              ],
              body: Skeletonizer(
                enabled: emailExisted == null ? true : false,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: Sizes.sm),
                      color: Colors.white,
                      child: TabBar(
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        dividerColor: Colors.transparent,
                        tabs: _tabBarheaders,
                        indicatorColor: AppColors.secondaryColor,
                      ),
                    ),
                    renderView(),
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
      _playsoundLogout.play();
      ref.invalidate(navbarControllerProvider);
      ref.invalidate(navigationStateProvider);
      ref.invalidate(registerControllerProvider);
      ref.invalidate(loginControllerProvider);
      ref.invalidate(profileUserControllerProvider);
      ref.invalidate(socialPostControllerProvider);
      ref.invalidate(userLikeControllerProvider);
      LocalStorageUtils().setKeyString('email', '');
      Fluttertoast.showToast(
          msg: 'See you soon love 😔 !!!',
          timeInSecForIosWeb: 5,
          toastLength: Toast.LENGTH_LONG);
      await authController.logout();
    }
  }

  void binding() async {
    await _playsoundLogout.setAsset(Assets.audio.bye);
    _playsoundLogout.setVolume(0.8);
  }
}
