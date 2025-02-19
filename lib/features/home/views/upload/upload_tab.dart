import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class UploadTab extends ConsumerStatefulWidget {
  const UploadTab({super.key});

  @override
  ConsumerState<UploadTab> createState() => _UploadTabState();
}

class _UploadTabState extends ConsumerState<UploadTab>
    with AutomaticKeepAliveClientMixin<UploadTab> {
  UserRoles? userRoles;
  late FirestoreService firestoreService;

  @override
  void initState() {
    firestoreService =
        FirestoreService(firebaseAuthService: FirebaseAuthService());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.backgroundDark,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Assets.app.catGym.image(width: 250, height: 250, fit: BoxFit.cover),
          Text(
            'Coming Soon my love !!!',
            style: AppTextTheme.lightTextTheme.bodyLarge
                ?.copyWith(color: AppColors.secondaryColor),
          ),
          const Spacer(),
          Container(
            alignment: Alignment.topCenter,
            height: 15.h,
            padding: const EdgeInsets.symmetric(
                horizontal: Sizes.xxxl + 50, vertical: Sizes.xxxl),
            decoration: const BoxDecoration(color: Colors.black),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    HelpersUtils.navigatorState(context)
                        .pushNamed(AppPage.createPost);
                  },
                  child: Text(
                    'Posts',
                    style: AppTextTheme.lightTextTheme.bodyMedium
                        ?.copyWith(color: AppColors.backgroundLight),
                  ),
                ),
                Text(
                  'Videos',
                  style: AppTextTheme.lightTextTheme.bodyMedium
                      ?.copyWith(color: AppColors.backgroundLight),
                ),
                GestureDetector(
                  onTap: () {
                    HelpersUtils.navigatorState(context)
                        .pushNamed(AppPage.eventCreate);
                  },
                  child: Text(
                    'Events',
                    style: AppTextTheme.lightTextTheme.bodyMedium
                        ?.copyWith(color: AppColors.backgroundLight),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void fetchUserRole() async {
    final asyncValues = await ref.watch(profileUserControllerProvider.future);
    debugPrint("USer role is ${asyncValues}");
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          setState(() {
            userRoles = asyncValues?.userRoles;
          });
        },
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
