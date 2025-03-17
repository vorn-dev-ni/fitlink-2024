import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/features/home/controller/video/tiktok_video_controller.dart';
import 'package:demo/features/home/views/main/work_out/social_like_comment_item.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SocialInteractonVideo extends ConsumerStatefulWidget {
  final VoidCallback onCommentPressed;
  String videoId;

  SocialInteractonVideo(
      {super.key, required this.onCommentPressed, required this.videoId});

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
            isLiked: data.isUserliked ?? true,
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
    return Skeletonizer(enabled: true, child: SizedBox());
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
