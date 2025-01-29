import 'package:demo/common/model/transparent_container.dart';
import 'package:demo/common/model/user_model.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/features/home/controller/navbar_controller.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/features/home/views/profile/events/event_profile.dart';
import 'package:demo/features/home/views/profile/favorites/favorite_profile.dart';
import 'package:demo/features/home/views/profile/post/post_profile.dart';
import 'package:demo/features/home/views/profile/video/video_profile.dart';
import 'package:demo/features/home/views/workout/workout_profile.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
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
  late bool isLoading = true;

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
      Future.delayed(const Duration(milliseconds: 500), () async {
        fetchUserProfile();
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _screens.length,
      child: Scaffold(
        extendBodyBehindAppBar: isLoading,
        body: SafeArea(
          child: Skeletonizer(
            enabled: isLoading,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                profileHeader(),
              ],
              body: Column(
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

  SliverAppBar profileHeader() {
    return SliverAppBar(
      expandedHeight: 60.h,
      // floating: false,
      // pinned: true,
      actions: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.backgroundDark.withOpacity(0.4),
          ),
          margin: const EdgeInsets.only(right: Sizes.lg, top: Sizes.md),
          child: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {},
              icon: const Icon(
                Icons.notifications,
                size: Sizes.xxl,
                color: AppColors.backgroundLight,
              )),
        )
      ],
      backgroundColor: AppColors.backgroundDark,
      flexibleSpace: FlexibleSpaceBar(
          background: Stack(
        children: [
          Positioned.fill(
              child: Stack(
            children: [
              Positioned.fill(
                child: FancyShimmerImage(
                  imageUrl:
                      'https://cdn.statically.io/gh/Anime-Sama/IMG/img/contenu/dumbbell-nan-kilo-moteru.jpg',
                  boxFit: BoxFit.cover,
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          )),
          Positioned(
            bottom: 10,
            child: Padding(
              padding: const EdgeInsets.all(Sizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      transparentContainer(
                        child: Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          '${currentUser?.fullname}',
                          style: AppTextTheme.lightTextTheme.headlineMedium
                              ?.copyWith(color: AppColors.backgroundLight),
                        ),
                      ),
                      const SizedBox(
                        height: Sizes.md,
                      ),
                      transparentContainer(
                        child: SizedBox(
                          width: 85.w,
                          child: Text(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            "This user has no bio yet !!!",
                            style: AppTextTheme.lightTextTheme.bodyMedium
                                ?.copyWith(
                                    color: AppColors.backgroundLight,
                                    fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: Sizes.md,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor
                                        .withOpacity(0.15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(Sizes.lg))),
                                onPressed: () {},
                                child: const Text('Edit Profile')),
                          ),
                          const SizedBox(
                            width: Sizes.lg,
                          ),
                          ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor
                                        .withOpacity(0.15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(Sizes.lg))),
                                onPressed: () {},
                                child: const Text('Share Profile')),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: Sizes.md,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 95.w,
                        child: transparentContainer(
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: userSocialMediaTab(
                                      floatingText: '0', type: 'Workouts')),
                              Expanded(
                                  child: userSocialMediaTab(
                                      floatingText: '0', type: 'Followings')),
                              Expanded(
                                  child: userSocialMediaTab(
                                      floatingText: '0', type: 'Followers'))
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget userSocialMediaTab(
      {required String floatingText, required String type}) {
    return Column(
      children: [
        Text(
          floatingText,
          style: AppTextTheme.lightTextTheme.labelLarge
              ?.copyWith(color: AppColors.backgroundLight),
        ),
        Text(
          type,
          style: AppTextTheme.lightTextTheme.labelMedium
              ?.copyWith(color: AppColors.backgroundLight),
        ),
      ],
    );
  }

  void handleLogout() async {
    ref.invalidate(navbarControllerProvider);
    await authController.logout();
  }

  void fetchUserProfile() async {
    try {
      final asyncValues = await ref.read(profileUserControllerProvider.future);
      if (asyncValues != null) {
        currentUser = asyncValues;
        isLoading = false;
      } else {
        currentUser = null;
        isLoading = false;
      }

      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          if (mounted) {
            setState(() {});
          }
        },
      );
    } catch (e) {}
  }
}
