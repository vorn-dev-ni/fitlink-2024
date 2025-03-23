import 'dart:ui';
import 'package:demo/features/home/widget/video/user_following_video.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void showShareBottomSheet(
  BuildContext context,
  String videoId,
  String thumbnailUrl,
  String videoUrl,
  String receiverId,
  String avatar,
  String fullName,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    showDragHandle: true,
    enableDrag: true,
    backgroundColor: AppColors.backgroundLight,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
      double bottomSheetHeight = isKeyboardOpen ? 360 : 200;
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Container(
          width: 100.w,
          height: bottomSheetHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Send To',
                style: AppTextTheme.lightTextTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: Sizes.xxl,
              ),
              Expanded(
                  child: UserFollowingVideoShare(
                thumbnailUrl: thumbnailUrl,
                avatar: avatar,
                fullName: fullName,
                videoId: videoId,
                receiverId: receiverId,
                videoUrl: videoUrl,
              )),
            ],
          ),
        ),
      );
    },
  );
}
