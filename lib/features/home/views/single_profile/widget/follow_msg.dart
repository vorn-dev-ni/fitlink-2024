import 'package:demo/features/home/views/single_profile/controller/single_user_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FollowMessageWidget extends ConsumerStatefulWidget {
  final Function? following;
  final Function? unfollow;
  final String? userId;

  FollowMessageWidget({this.following, this.unfollow, this.userId});

  @override
  _FollowMessageWidgetState createState() => _FollowMessageWidgetState();
}

class _FollowMessageWidgetState extends ConsumerState<FollowMessageWidget> {
  bool? isFollowing = null;
  bool isDisabled = false;

  void toggleFollow() {
    isDisabled = true;
    if (isFollowing != null) {
      setState(() {
        isFollowing = !isFollowing!;
      });
      if (isFollowing! && widget.following != null) {
        widget.following!();
      } else {
        widget.unfollow!();
      }
    }

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isDisabled = false;
      });
    });
  }

  @override
  void initState() {
    checkIsfollowing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              clipBehavior: Clip.antiAlias,
              child: TextButton(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: Sizes.xl),
                      foregroundColor: AppColors.backgroundLight,
                      disabledBackgroundColor:
                          const Color.fromARGB(255, 43, 41, 41),
                      disabledForegroundColor: AppColors.neutralBlack,
                      backgroundColor:
                          AppColors.backgroundDark.withOpacity(0.67),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Sizes.lg))),
                  onPressed: isDisabled ? null : toggleFollow,
                  child: isFollowing == null || isDisabled == true
                      ? Text('loading...',
                          style: AppTextTheme.lightTextTheme.titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.backgroundLight))
                      : Text(
                          isFollowing!
                              ? 'Unfollow'
                              : 'Follow', // Toggle text between Follow/Unfollow
                          style: AppTextTheme.lightTextTheme.titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.backgroundLight),
                        )),
            ),
            const SizedBox(
              width: Sizes.lg,
            ),
            ClipRRect(
              clipBehavior: Clip.antiAlias,
              child: TextButton(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: Sizes.xl),
                      foregroundColor: AppColors.backgroundLight,
                      backgroundColor:
                          AppColors.backgroundDark.withOpacity(0.67),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Sizes.lg))),
                  onPressed: () {
                    HelpersUtils.navigatorState(context)
                        .pushNamed(AppPage.NOTFOUND);
                  },
                  child: Text(
                    'Message',
                    style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w300,
                        color: AppColors.backgroundLight),
                  )),
            ),
          ],
        ),
        const SizedBox(
          height: Sizes.md,
        ),
      ],
    );
  }

  void checkIsfollowing() async {
    try {
      if (mounted) {
        bool result = await ref
            .read(singleUserControllerProvider(widget.userId ?? "").notifier)
            .checkIfuserFollowing(widget.userId ?? "");
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            setState(() {
              isFollowing = result;
            });
          },
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
