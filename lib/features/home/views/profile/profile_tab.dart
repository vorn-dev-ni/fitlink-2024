import 'package:demo/common/model/user_model.dart';
import 'package:demo/common/widget/backdrop_loading.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/core/riverpod/navigation_state.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/features/authentication/controller/login_controller.dart';
import 'package:demo/features/authentication/controller/register_controller.dart';
import 'package:demo/features/home/controller/chat/user_status_controller.dart';
import 'package:demo/features/home/controller/logout_controller.dart';
import 'package:demo/features/home/controller/navbar_controller.dart';
import 'package:demo/features/home/controller/posts/social_post_controller.dart';
import 'package:demo/features/home/controller/posts/user_like_controller.dart';
import 'package:demo/features/home/controller/profile/profile_post_controller.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/features/home/controller/video/tiktok_video_controller.dart';
import 'package:demo/features/home/views/single_profile/controller/media_tag_conroller.dart';
import 'package:demo/features/home/views/single_profile/controller/notification_badge.dart';
import 'package:demo/features/home/views/single_profile/controller/single_user_controller.dart';
import 'package:demo/features/home/views/profile/post/post_profile.dart';
import 'package:demo/features/home/views/profile/profile_header.dart';
import 'package:demo/features/home/views/profile/video/video_profile.dart';
import 'package:demo/features/home/views/profile/workout/workout_profile.dart';
import 'package:demo/features/notifications/controller/notification_user_controller.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bindingUser();
  }

  @override
  void initState() {
    _playsoundLogout = AudioPlayer();
    binding();
    _screens = [
      PostProfile(
        currentUser: true,
        userId: uid ?? "",
      ),
      VideoProfile(
        userId: FirebaseAuth.instance.currentUser?.uid,
      ),
      WorkoutProfile(
        key: UniqueKey(),
        userId: uid ?? "",
      ),
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
    final isLoading = ref.watch(appLoadingStateProvider);

    return DefaultTabController(
      length: _screens.length,
      child: Stack(
        children: [
          Scaffold(
              body: asyncUser.when(
            data: (data) {
              final emailExisted = data?.email;
              return SafeArea(
                bottom: false,
                top: DeviceUtils.isIOS(),
                child: NestedScrollView(
                  floatHeaderSlivers: false,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    ProfileHeader(
                      uid: data?.id ?? "",
                      onLogout: () async {
                        ref
                            .read(appLoadingStateProvider.notifier)
                            .setState(true);
                        await handleLogout();
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
            error: (error, stackTrace) => Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                error.toString().length > 100
                    ? error.toString().substring(0, 50)
                    : error.toString(),
                style: AppTextTheme.lightTextTheme.bodyMedium
                    ?.copyWith(color: AppColors.errorColor),
              ),
            )),
            loading: () {
              return buildLoader();
            },
          )),
          if (isLoading) backDropLoading()
        ],
      ),
    );
  }

  Widget buildLoader() {
    return Skeletonizer(
      enabled: true,
      ignorePointers: true,
      justifyMultiLineText: false,
      effect: const ShimmerEffect(
          highlightColor: Colors.white,
          baseColor: Color.fromARGB(212, 213, 213, 213)),
      child: SafeArea(
        top: DeviceUtils.isIOS(),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            ProfileHeader(
              uid: "example",
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

  Future handleLogout() async {
    try {
      if (mounted) {
        ref.invalidate(singleUserControllerProvider);
        ref.invalidate(registerControllerProvider);
        ref.invalidate(loginControllerProvider);
        ref.invalidate(socialPostControllerProvider);
        ref.invalidate(userLikeControllerProvider);
        ref.invalidate(mediaTagConrollerProvider);

        LocalStorageUtils().setKeyString('email', '');
        LocalStorageUtils().setKeyString('notificationCount', '');
        await authController.logout();
        _playsoundLogout.play();
        Fluttertoast.showToast(
            msg: 'See you soon love 😔 !!!',
            timeInSecForIosWeb: 3,
            toastLength: Toast.LENGTH_SHORT);
        String uid = LocalStorageUtils().getKey('uid') ?? '';
        ref.read(userStatusControllerProvider.notifier).setUserOffline(uid);
        ref.read(logoutControllerProvider.notifier).logout();
        ref.invalidate(notificationBadgeProvider);
        ref.invalidate(notificationUserControllerProvider);
        LocalStorageUtils().setKeyString('uid', '');
        ref.invalidate(profileUserControllerProvider);
        ref.invalidate(profilePostControllerProvider);
        // ref.invalidate(tiktokVideoControllerProvider);
        ref.invalidate(socialInteractonVideoControllerProvider);
        ref.invalidate(navbarControllerProvider);
        ref.invalidate(navigationStateProvider);
        ref.read(appLoadingStateProvider.notifier).setState(false);
        Future.delayed(const Duration(milliseconds: 1000), () {
          ref.read(appLoadingStateProvider.notifier).setState(false);
        });
      }
    } catch (e) {
      LocalStorageUtils().setKeyString('uid', '');
      LocalStorageUtils().setKeyString('email', '');
      ref.invalidate(profilePostControllerProvider);
      ref.invalidate(profileUserControllerProvider);
      ref.read(appLoadingStateProvider.notifier).setState(false);
    }
  }

  void binding() async {
    await _playsoundLogout.setAsset(Assets.audio.bye);
    _playsoundLogout.setVolume(0.8);
  }

  void bindingUser() {
    final routeParams = ModalRoute.of(context)?.settings;
    if (routeParams?.arguments?.toString() != null) {
      final data = routeParams?.arguments as Map;
      if (data.containsKey('userId')) {
        uid = data['userId'];
      } else {
        uid = FirebaseAuth.instance.currentUser?.uid;
      }
    }
    return;
  }
}
