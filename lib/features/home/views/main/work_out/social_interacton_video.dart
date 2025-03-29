import 'package:demo/common/widget/app_dialog.dart';
import 'package:demo/common/widget/video/share_bottom_sheet.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/home/controller/video/tiktok_video_controller.dart';
import 'package:demo/features/home/views/main/work_out/social_like_comment_item.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SocialInteractonVideo extends ConsumerStatefulWidget {
  final VoidCallback onCommentPressed;
  String videoId;
  String? receiverID;
  bool? showEditIcon;
  bool? isUserliked;

  SocialInteractonVideo(
      {super.key,
      required this.onCommentPressed,
      required this.videoId,
      this.receiverID,
      this.showEditIcon,
      this.isUserliked});

  @override
  ConsumerState<SocialInteractonVideo> createState() =>
      _SocialInteractonVideoState();
}

class _SocialInteractonVideoState extends ConsumerState<SocialInteractonVideo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final async =
        ref.watch(socialInteractonVideoControllerProvider(widget.videoId));

    return async.when(
      data: (data) {
        return SocialLikeCommentItem(
            videoId: widget.videoId,
            receiverID: widget.receiverID,
            showEditIcon: widget.showEditIcon,
            key: UniqueKey(),
            onEdit: openBottomSheet,
            onShare: () => showShareBottomSheet(
                context,
                widget.videoId,
                data.thumbnailUrl ?? "",
                data.videoUrl ?? "",
                data.userRef?.id ?? "",
                data.userRef?.avatar ?? "",
                data.userRef?.fullName ?? ""),
            isLiked: widget.isUserliked ?? false,
            onCommentPressed: widget.onCommentPressed,
            data: data);
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () => _buildLoading(),
    );
  }

  Future _handleDeleting(String videoId) async {
    try {
      ref.read(appLoadingStateProvider.notifier).setState(true);
      await ref
          .read(
              socialInteractonVideoControllerProvider(widget.videoId).notifier)
          .deleteVideo(videoId);
      ref.read(appLoadingStateProvider.notifier).setState(false);

      Fluttertoast.showToast(msg: 'Your video has been deleted...');
      ref.read(tiktokVideoControllerProvider.notifier).refresh();
      if (mounted) {
        HelpersUtils.navigatorState(context).pop();
        // HelpersUtils.navigatorState(context).pop();
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
      ref.read(appLoadingStateProvider.notifier).setState(false);
    }
  }

  Widget _buildLoading() {
    return const Skeletonizer(enabled: true, child: SizedBox());
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

  void closeBottomSheet() {
    HelpersUtils.navigatorState(context).pop();
  }

  void openBottomSheet() {
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
          initialChildSize: 0.25,
          minChildSize: 0.2,
          maxChildSize: 0.3,
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
                      Icons.delete,
                      color: AppColors.backgroundDark,
                      size: Sizes.iconSm,
                    ),
                    title: Text(
                      'Delete Video',
                      style: AppTextTheme.lightTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      closeBottomSheet();
                      showDialog(
                          context: context,
                          builder: (context) => AppALertDialog(
                              // bgColor: const Color.fromRGBO(0, 0, 0, 1)
                              //     .withOpacity(0.4),
                              bgColor: AppColors.backgroundLight,
                              onConfirm: () {},
                              showIcon: false,
                              negativeButton: SizedBox(
                                  width: 100.w,
                                  child: FilledButton(
                                      style: FilledButton.styleFrom(
                                          foregroundColor:
                                              AppColors.secondaryColor,
                                          backgroundColor:
                                              AppColors.backgroundLight),
                                      onPressed: () {
                                        HelpersUtils.navigatorState(context)
                                            .pop();
                                      },
                                      child: Text('Cancel',
                                          style: AppTextTheme
                                              .lightTextTheme.bodyLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors
                                                      .secondaryColor)))),
                              positivebutton: SizedBox(
                                  width: 100.w,
                                  child: FilledButton(
                                      style: FilledButton.styleFrom(
                                          foregroundColor: AppColors.errorColor,
                                          backgroundColor:
                                              AppColors.backgroundLight),
                                      onPressed: () {
                                        HelpersUtils.navigatorState(context)
                                            .pop();
                                        _handleDeleting(widget.videoId);
                                      },
                                      child: Text('Delete',
                                          style: AppTextTheme
                                              .lightTextTheme.bodyLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      AppColors.errorColor)))),
                              title: 'Delete Video',
                              textColor: AppColors.backgroundDark,
                              contentColor: AppColors.backgroundDark,
                              desc:
                                  "Are you sure you want to permanently remove this video from FitLink?"));
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
}
