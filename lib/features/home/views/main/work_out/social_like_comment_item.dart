import 'dart:async';

import 'package:demo/common/controller/report_controller.dart';
import 'package:demo/common/widget/confirm_block_dialog.dart';
import 'package:demo/common/widget/report_alert_dialog.dart';
import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/home/controller/posts/social_post_controller.dart';
import 'package:demo/features/home/controller/video/comment/comment_video_controller.dart';
import 'package:demo/features/home/controller/video/tiktok_video_controller.dart';
import 'package:demo/features/home/controller/video/video_page_controller.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:sizer/sizer.dart';

class SocialLikeCommentItem extends ConsumerStatefulWidget {
  String videoId;
  bool isLiked;
  VideoTikTok data;
  VoidCallback onCommentPressed;
  VoidCallback? onEdit;

  VoidCallback onShare;
  String? receiverID;
  bool? showEditIcon;

  SocialLikeCommentItem(
      {super.key,
      required this.videoId,
      required this.onShare,
      this.showEditIcon,
      this.onEdit,
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
          const SizedBox(height: 20),
          if (widget.showEditIcon == true &&
              widget.receiverID == FirebaseAuth.instance.currentUser?.uid)
            _buildIcon(
                Icon(
                  shadows: [
                    Shadow(
                        color: AppColors.neutralBlack.withOpacity(0.5),
                        blurRadius: 19,
                        offset: const Offset(0, 0))
                  ],
                  Icons.more_horiz,
                  color: AppColors.backgroundLight,
                  size: Sizes.iconXl,
                ),
                '', () {
              if (!HelpersUtils.isAuthenticated(context)) {
                return;
              }
              widget.onEdit != null ? widget.onEdit!() : null;
            }),

          _buildIcon(
              Icon(
                shadows: [
                  Shadow(
                      color: AppColors.neutralBlack.withOpacity(0.5),
                      blurRadius: 19,
                      offset: const Offset(0, 0))
                ],
                CupertinoIcons.ellipsis_vertical,
                color: AppColors.backgroundLight,
                size: Sizes.iconLg,
              ),
              '', () {
            _onTapReportVideo(context, widget.videoId, widget.receiverID);
          }),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Future _onReportPost(String reason, String videoId) async {
    await ref
        .read(reportControllerProvider.notifier)
        .sendReport(postId: videoId, reason: reason, type: "video");
  }

  void _onTapReportVideo(BuildContext context, String videoId, String? userId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: const Color.fromARGB(255, 236, 241, 247),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.2,
          minChildSize: 0.1,
          maxChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.report,
                      color: AppColors.backgroundDark,
                      size: Sizes.iconSm,
                    ),
                    title: Text(
                      'Report Video',
                      style: AppTextTheme.lightTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (context) => ReportAlertDialog(
                                onSelectReason: (reason) {
                                  _onReportPost(reason, videoId);
                                },
                              ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.warning,
                      color: AppColors.backgroundDark,
                      size: Sizes.iconSm,
                    ),
                    title: Text(
                      'Block User',
                      style: AppTextTheme.lightTextTheme.bodyMedium,
                    ),
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) {
                          return ConfirmBlockDialog(onConfirm: () {
                            Navigator.of(dialogContext).pop(true);
                          });
                        },
                      );
                      if (mounted && confirmed == true) {
                        // Safe navigation using State's context
                        final isAuth = HelpersUtils.isAuthenticated(context);
                        if (isAuth) {
                          ref
                              .read(appLoadingStateProvider.notifier)
                              .setState(true);
                          await ref
                              .read(socialPostControllerProvider.notifier)
                              .blockUser(
                                  blockedId: userId ?? "",
                                  contentId: videoId,
                                  postID: videoId);
                          ref
                              .read(tiktokVideoControllerProvider.notifier)
                              .refresh();
                          ref
                              .read(videoPageControllerProvider.notifier)
                              .resetPage();
                          ref
                              .read(appLoadingStateProvider.notifier)
                              .setState(false);
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<bool?> _onTapLiked(bool isCurrentlyLiked, String? receiverID) async {
    if (!HelpersUtils.isAuthenticated(context)) {
      return false;
    }
    if (_debounceTimer?.isActive ?? false) {
      return isCurrentlyLiked;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 1000), () {});
    ref
        .read(tiktokCommentControllerProvider(
          widget.videoId,
        ).notifier)
        .toggleLike(alreadyLiked: isCurrentlyLiked, receiverID: receiverID);

    return !isCurrentlyLiked;
  }

  Widget _buildIcon(Widget icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          icon,
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
