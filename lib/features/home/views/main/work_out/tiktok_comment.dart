import 'dart:async';
import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/features/home/controller/video/comment/comment_like_controller.dart';
import 'package:demo/features/home/controller/video/comment/comment_video_controller.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';

class TiktokComment extends ConsumerStatefulWidget {
  String? videoId;
  CommentTikTok? data;
  TiktokComment({super.key, this.data, this.videoId});

  @override
  ConsumerState<TiktokComment> createState() => _TiktokCommentState();
}

class _TiktokCommentState extends ConsumerState<TiktokComment> {
  Timer? _debounceTimer;
  bool? hasLiked;
  int totalLiked = 0;
  CommentLikeController commentLikeController = CommentLikeController();
  @override
  void initState() {
    hasLiked = widget.data?.isLiked ?? false;
    totalLiked = widget.data?.likes ?? 0;
    super.initState();
  }

  Future<bool?> _onTapLiked(bool isCurrentlyLiked) async {
    if (!HelpersUtils.isAuthenticated(context)) {
      return false;
    }
    if (_debounceTimer?.isActive ?? false) {
      return isCurrentlyLiked;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {});
    hasLiked = !isCurrentlyLiked;

    if (isCurrentlyLiked) {
      ref
          .read(tiktokCommentControllerProvider(widget.videoId ?? "").notifier)
          .unLikedVideoComment(
              widget.videoId ?? "", widget.data?.documentId ?? "");
    } else {
      ref
          .read(tiktokCommentControllerProvider(widget.videoId ?? "").notifier)
          .likeVideoComment(
              widget.videoId ?? "", widget.data?.documentId ?? "");
    }

    return !isCurrentlyLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color.fromARGB(255, 194, 195, 197),
              width: 1,
            ),
          ),
          child: ClipOval(
            child: widget.data?.userData?.avatar != ""
                ? FancyShimmerImage(
                    imageUrl: widget.data?.userData?.avatar ?? "",
                    shimmerHighlightColor: AppColors.neutralColor,
                    width: 40,
                    height: 40,
                    cacheKey: widget.data?.userData?.avatar,
                    errorWidget: errorImgplaceholder(),
                    boxFit: BoxFit.cover,
                  )
                : Assets.app.defaultAvatar
                    .image(width: 40, height: 40, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(
          width: Sizes.md,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // width: 75.w,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.data?.userData?.fullName}',
                    style: AppTextTheme.lightTextTheme.bodyMedium,
                  ),
                  const SizedBox(
                    width: Sizes.md,
                  ),
                  if (widget.data?.isLoading == false)
                    Text(
                      FormatterUtils.formatTimestamp(widget.data?.createdAt),
                      style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w300,
                          color: const Color.fromARGB(255, 197, 199, 202)),
                    ),
                ],
              ),
            ),
            Text(
              '${widget.data?.text}',
              style: AppTextTheme.lightTextTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w300),
            ),
            if (widget.data?.isLoading == true)
              Text(
                'Sending...',
                style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w300,
                    color: const Color.fromARGB(255, 197, 199, 202)),
              ),
          ],
        ),
        const Spacer(),
        if (widget.data?.isLoading == false)
          LikeButton(
            isLiked: widget.data?.isLiked ?? false,
            countPostion: CountPostion.bottom,
            countBuilder: (likeCount, isLiked, text) {
              return Text(
                '$likeCount',
                style: AppTextTheme.lightTextTheme.bodySmall,
              );
            },
            likeCountPadding: const EdgeInsets.only(right: 0),
            likeCount: widget.data?.likes,
            likeCountAnimationDuration: const Duration(milliseconds: 300),
            likeBuilder: (bool isLiked) => Icon(
              isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
              color: isLiked ? Colors.red : null,
            ),
            onTap: _onTapLiked,
          )
      ],
    );
  }
}
