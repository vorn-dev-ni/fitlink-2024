import 'package:demo/common/model/user_model.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/features/home/views/profile/profile_header.dart';
import 'package:demo/features/home/views/single_profile/controller/single_user_controller.dart';
import 'package:demo/features/home/views/profile/post/post_profile.dart';
import 'package:demo/features/home/views/profile/video/video_profile.dart';
import 'package:demo/features/home/views/profile/workout/workout_profile.dart';
import 'package:demo/features/home/views/single_profile/widget/single_profile_header.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SingleProfile extends ConsumerStatefulWidget {
  SingleProfile({super.key});

  @override
  ConsumerState<SingleProfile> createState() => _SingleProfileState();
}

class _SingleProfileState extends ConsumerState<SingleProfile> {
  late final AuthController authController;
  AuthModel? currentUser;
  late List<Tab> _tabBarheaders;
  late List<Widget> _screens;
  String? uid;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bindingUser();
  }

  @override
  void initState() {
    _screens = [
      PostProfile(
        userId: uid ?? "",
        currentUser: false,
      ),
      const VideoProfile(),
      WorkoutProfile(
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
    final asyncUser = ref.watch(singleUserControllerProvider(uid ?? ""));
    return DefaultTabController(
      length: _screens.length,
      child: Scaffold(
          body: asyncUser.when(
        data: (data) {
          final emailExisted = data?.email;
          return SafeArea(
            top: DeviceUtils.isIOS(),
            child: NestedScrollView(
              floatHeaderSlivers: false,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SingleProfileHeader(
                  uid: data?.id ?? "",
                  onLogout: () async {},
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
            error.toString(),
            style: AppTextTheme.lightTextTheme.bodyMedium
                ?.copyWith(color: AppColors.errorColor),
          ),
        )),
        loading: () {
          return build_loading();
        },
      )),
    );
  }

  Widget build_loading() {
    return Skeletonizer(
      enabled: true,
      ignorePointers: true,
      justifyMultiLineText: false,
      // ignoreContainers: true,
      effect: const ShimmerEffect(
          highlightColor: Colors.white,
          baseColor: Color.fromARGB(212, 213, 213, 213)),
      child: SafeArea(
        top: DeviceUtils.isIOS(),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) =>
              [ProfileHeader(singleMode: true, onLogout: () {}, uid: uid)],
          body: SafeArea(
            child: Column(
              children: [
                TabBar(
                  tabAlignment: TabAlignment.start,
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

  void bindingUser() {
    final routeParams = ModalRoute.of(context)?.settings;
    if (routeParams?.arguments?.toString() != null) {
      final data = routeParams?.arguments as Map;
      if (data.containsKey('userId')) {
        uid = data['userId'];
        setState(() {
          _screens = [
            PostProfile(
              userId: data['userId'],
              currentUser: false,
            ),
            const VideoProfile(),
            WorkoutProfile(
              userId: data['userId'],
            ),
          ];
        });
      } else {
        uid = FirebaseAuth.instance.currentUser?.uid;
      }
    }
    return;
  }
}
