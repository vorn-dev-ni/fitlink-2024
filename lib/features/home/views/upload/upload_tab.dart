import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(80),
          decoration: const BoxDecoration(color: Colors.black),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Posts',
                style: AppTextTheme.lightTextTheme.bodyMedium
                    ?.copyWith(color: AppColors.backgroundLight),
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
        Expanded(
            child: Container(
          decoration: const BoxDecoration(color: Colors.black),
        ))
      ],
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

  // void _handleNavigateEvent() async {
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     final roleString = await firestoreService.checkUserRole();
  //     final newRole = UserRolesExtension.fromValue(roleString);
  //     if (newRole == UserRoles.NORMAL) {
  //       if (mounted) {
  //         showDialog(
  //             context: context,
  //             builder: (context) => AppALertDialog(
  //                 onConfirm: () {},
  //                 positivebutton: SizedBox(
  //                     width: 100.w,
  //                     child: FilledButton(
  //                         style: FilledButton.styleFrom(
  //                             backgroundColor: AppColors.errorColor),
  //                         onPressed: () {
  //                           HelpersUtils.navigatorState(context).pop();
  //                           HelpersUtils.navigatorState(context)
  //                               .pushNamed(AppPage.eventRequestGymTrainer);
  //                         },
  //                         child: const Text('Confirm'))),
  //                 title: 'Notice',
  //                 desc:
  //                     "To proceed, please submit proof that you are a gym owner or trainer. This information is required to unlock full access to the app’s features"));
  //       }
  //     } else {
  //       if (mounted) {
  //         HelpersUtils.navigatorState(context).pushNamed(AppPage.eventCreate);
  //       }
  //     }
  //   }
  // }

  @override
  bool get wantKeepAlive => true;
}
