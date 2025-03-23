import 'package:demo/common/widget/video/share_bottom_sheet.dart';
import 'package:demo/features/home/controller/video/tiktok_video_controller.dart';
import 'package:demo/features/home/views/main/work_out/social_like_comment_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SocialInteractonVideo extends ConsumerStatefulWidget {
  final VoidCallback onCommentPressed;
  String videoId;
  String? receiverID;
  bool? isUserliked;

  SocialInteractonVideo(
      {super.key,
      required this.onCommentPressed,
      required this.videoId,
      this.receiverID,
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
            key: UniqueKey(),
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
}
