import 'package:demo/common/widget/video_tiktok.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:demo/features/home/controller/video/comment/comment_video_controller.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SocialLikeCommentItem extends ConsumerStatefulWidget {
  String videoId;
  bool isLiked;
  VideoTikTok data;
  VoidCallback onCommentPressed;
  VoidCallback onShare;
  String? receiverID;

  SocialLikeCommentItem(
      {super.key,
      required this.videoId,
      required this.onShare,
      this.receiverID,
      required this.isLiked,
      required this.onCommentPressed,
      required this.data});

  @override
  ConsumerState<SocialLikeCommentItem> createState() =>
      _SocialLikeCommentItemState();
}

class _SocialLikeCommentItemState extends ConsumerState<SocialLikeCommentItem> {
  Timer? _debounceTimer;
  bool? hasLiked;

  @override
  void initState() {
    super.initState();

    hasLiked = widget.data.isUserliked;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(
              LikeButton(
                isLiked: hasLiked,
                countPostion: CountPostion.bottom,
                countBuilder: (likeCount, isLiked, text) {
                  return Text(
                    '$likeCount',
                    style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                      color: AppColors.backgroundLight,
                      fontWeight: FontWeight.w400,
                      shadows: [
                        const Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  );
                },
                likeCountPadding: const EdgeInsets.only(right: 0),
                likeCount: widget.data.likeCount ?? 0,
                likeCountAnimationDuration: const Duration(milliseconds: 300),
                likeBuilder: (bool isLiked) => Icon(
                  shadows: [
                    Shadow(
                        color: AppColors.neutralBlack.withOpacity(0.5),
                        blurRadius: 19,
                        offset: const Offset(0, 0))
                  ],
                  isLiked
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart_fill,
                  size: Sizes.iconLg,
                  color: isLiked ? Colors.red : AppColors.backgroundLight,
                ),
                onTap: (isLiked) => _onTapLiked(isLiked, widget.receiverID),
              ),
              "",
              () {}),
          // const SizedBox(height: 20),
          _buildIcon(
              Icon(
                shadows: [
                  Shadow(
                      color: AppColors.neutralBlack.withOpacity(0.5),
                      blurRadius: 19,
                      offset: const Offset(0, 0))
                ],
                CupertinoIcons.chat_bubble_fill,
                color: AppColors.backgroundLight,
                size: Sizes.iconLg,
              ),
              widget.data.commentCount?.toString() ?? '0', () {
            if (!HelpersUtils.isAuthenticated(context)) {
              return;
            }
            widget.onCommentPressed();
          }),
          const SizedBox(height: 20),

          widget.receiverID == ""
              ? _buildIcon(
                  LikeButton(
                    isLiked: hasLiked,
                    countPostion: CountPostion.bottom,
                    countBuilder: (likeCount, isLiked, text) {
                      return Text(
                        '$likeCount',
                        style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                          color: AppColors.backgroundLight,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            const Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 4.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      );
                    },
                    likeCountPadding: const EdgeInsets.only(right: 0),
                    likeCount: widget.data.likeCount ?? 0,
                    likeCountAnimationDuration:
                        const Duration(milliseconds: 300),
                    likeBuilder: (bool isLiked) => Icon(
                      shadows: [
                        Shadow(
                            color: AppColors.neutralBlack.withOpacity(0.5),
                            blurRadius: 19,
                            offset: const Offset(0, 0))
                      ],
                      isLiked
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart_fill,
                      size: Sizes.iconLg,
                      color: isLiked ? Colors.red : AppColors.backgroundLight,
                    ),
                    onTap: (isLiked) => _onTapLiked(isLiked, widget.receiverID),
                  ),
                  "",
                  () {})
              : _buildIcon(
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.neutralBlack.withOpacity(0.3),
                            blurRadius: 50,
                            offset: const Offset(0, 0))
                      ],
                    ),
                    child: Assets.app.shareOption.image(
                      fit: BoxFit.cover,
                      width: 33,
                      height: 33,
                      color: AppColors.backgroundLight,
                    ),
                  ),
                  widget.data.shareCount?.toString() ?? '0', () {
                  if (!HelpersUtils.isAuthenticated(context)) {
                    return;
                  }
                  widget.onShare();
                }),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Future<bool?> _onTapLiked(bool isCurrentlyLiked, String? receiverID) async {
    if (!HelpersUtils.isAuthenticated(context)) {
      return false;
    }
    if (_debounceTimer?.isActive ?? false) {
      return isCurrentlyLiked;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {});
    ref
        .read(tiktokCommentControllerProvider(
          widget.videoId,
        ).notifier)
        .toggleLike(alreadyLiked: isCurrentlyLiked, receiverID: receiverID);
    // hasLiked = !isCurrentlyLiked;

    return !isCurrentlyLiked;
  }

  Widget _buildIcon(Widget icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            children: [
              // Main icon
              icon
            ],
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: const Offset(0, 2),
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
