import 'dart:async';

import 'package:demo/common/widget/app_dialog.dart';
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
import 'package:sizer/sizer.dart';

class UploadTab extends ConsumerStatefulWidget {
  const UploadTab({super.key});

  @override
  ConsumerState<UploadTab> createState() => _UploadTabState();
}

class _UploadTabState extends ConsumerState<UploadTab> {
  UserRoles? userRoles;
  late StreamSubscription<dynamic> streamSubscription;

  @override
  void initState() {
    super.initState();
    fetchUserRole();
    final streamData =
        FirestoreService(firebaseAuthService: FirebaseAuthService())
            .getUserRoleRealTime();

    streamSubscription = streamData.listen((event) {
      if (event != null && event.containsKey('role')) {
        final roleString = event['role'];
        final newRole = UserRolesExtension.fromValue(roleString);
        setState(() {
          userRoles = newRole;
        });
      }
    });
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Container(
            width: 100.w,
            child: Text('User role ${userRoles?.name}'),
            // height: 200,
            decoration: BoxDecoration(color: AppColors.backgroundLight),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(40),
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
                onTap: _handleNavigateEvent,
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
    final asyncValues = await ref.read(profileUserControllerProvider.future);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        setState(() {
          userRoles = asyncValues?.userRoles;
        });
      },
    );
  }

  void _handleNavigateEvent() {
    if (userRoles == UserRoles.NORMAL) {
      showDialog(
          context: context,
          builder: (context) => AppALertDialog(
              onConfirm: () {},
              positivebutton: SizedBox(
                  width: 100.w,
                  child: FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.errorColor),
                      onPressed: () {
                        HelpersUtils.navigatorState(context).pop();
                        HelpersUtils.navigatorState(context)
                            .pushNamed(AppPage.eventRequestGymTrainer);
                      },
                      child: const Text('Confirm'))),
              title: 'Notice',
              desc:
                  "To proceed, please submit proof that you are a gym owner or trainer. This information is required to unlock full access to the app’s features"));
    } else {
      HelpersUtils.navigatorState(context).pushNamed(AppPage.eventCreate);
    }
  }
}
