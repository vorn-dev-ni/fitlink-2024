import 'dart:async';
import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:demo/features/home/controller/comment/comment_controller.dart';
import 'package:demo/features/home/model/comment.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileHeader extends ConsumerStatefulWidget {
  final String imageUrl;
  final String? postId;
  final ProfileType type;
  final bool showBackButton;
  final UserData? user;
  final Comment? comment;
  final Post? post;
  final BuildContext? context;
  final String? desc;

  const ProfileHeader({
    Key? key,
    required this.user,
    this.postId,
    this.post,
    this.comment,
    required this.imageUrl,
    this.context,
    this.desc,
    this.type = ProfileType.post,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  bool? hasLiked = false;
  bool hasClick = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    checkUserLike();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.sm),
      child: widget.type == ProfileType.post
          ? Row(
              children: [
                ClipOval(
                  child: Container(
                    child: Assets.app.defaultAvatar
                        .image(width: 40, height: 40, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: Sizes.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('User name example'),
                    Text(
                      'Workout Tag',
                      style: AppTextTheme.lightTextTheme.bodySmall
                          ?.copyWith(color: AppColors.secondaryColor),
                    )
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.ellipsis,
                    size: Sizes.iconMd,
                    color: AppColors.secondaryColor,
                  ),
                )
              ],
            )
          : renderCommentListing(),
    );
  }

  Widget renderCommentListing() {
    return Skeletonizer(
      enabled: false,
      child: Row(
        children: [
          if (widget.showBackButton)
            GestureDetector(
              onTap: () {
                HelpersUtils.navigatorState(widget.context!).pop(true);
              },
              child: const Padding(
                padding: EdgeInsets.only(left: Sizes.md),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
          widget.type == ProfileType.comment
              ? ClipOval(
                  child: Container(
                    child: widget.comment?.user?.avatar != "" &&
                            widget.comment?.user?.avatar != null
                        ? FancyShimmerImage(
                            shimmerHighlightColor: AppColors.neutralColor,
                            imageUrl: widget.comment?.user?.avatar ?? "",
                            width: 40,
                            cacheKey: widget.comment?.user?.avatar ?? "",
                            height: 40,
                            errorWidget: errorImgplaceholder(),
                            boxFit: BoxFit.cover)
                        : Assets.app.defaultAvatar
                            .image(width: 40, height: 40, fit: BoxFit.cover),
                  ),
                )
              : ClipOval(
                  child: Container(
                    child: widget.imageUrl != ""
                        ? FancyShimmerImage(
                            imageUrl: widget.imageUrl,
                            shimmerHighlightColor: AppColors.neutralColor,
                            width: 40,
                            cacheKey: widget.imageUrl,
                            height: 40,
                            errorWidget: errorImgplaceholder(),
                            boxFit: BoxFit.cover)
                        : Assets.app.defaultAvatar
                            .image(width: 40, height: 40, fit: BoxFit.cover),
                  ),
                ),
          const SizedBox(width: Sizes.md),
          renderUserStatus(),
          const Spacer(),
          if (widget.type == ProfileType.profile)
            IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.ellipsis,
                size: Sizes.iconMd,
                color: AppColors.secondaryColor,
              ),
            ),
          if (widget.type == ProfileType.comment &&
              widget.comment?.isLoading == false)
            LikeButton(
              isLiked: hasLiked ?? false,
              countPostion: CountPostion.bottom,
              countBuilder: (likeCount, isLiked, text) {
                return Text(
                  '$likeCount',
                  style: AppTextTheme.lightTextTheme.bodySmall,
                );
              },
              likeCountPadding: const EdgeInsets.only(right: 0),
              likeCount: widget.comment?.likesCount ?? 0,
              likeCountAnimationDuration: const Duration(milliseconds: 300),
              likeBuilder: (bool isLiked) => Icon(
                isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                color: isLiked ? Colors.red : null,
              ),
              onTap: (isLiked) => _onTapLiked(isLiked),
            )
        ],
      ),
    );
  }

  Widget renderUserStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.post?.type == 'text' || widget.type == ProfileType.comment
            ? RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: AppTextTheme.lightTextTheme.bodySmall,
                  children: [
                    TextSpan(
                      text: '${widget.user?.fullName} ',
                      style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(),
                    ),
                    TextSpan(
                      text: FormatterUtils.formatTimestamp(
                          widget.comment?.createdAt),
                      style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                        color: const Color.fromARGB(255, 170, 173, 178),
                      ),
                    ),
                  ],
                ),
              )
            : RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: AppTextTheme.lightTextTheme.bodySmall,
                  children: [
                    TextSpan(
                      text: '${widget.user?.fullName} ',
                      style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(),
                    ),
                    TextSpan(
                      text: FormatterUtils.formatTimestamp(
                          widget.comment?.createdAt),
                      style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                        color: const Color.fromARGB(255, 170, 173, 178),
                      ),
                    ),
                    const TextSpan(
                      text: 'is',
                    ),
                    TextSpan(
                      text: ' ${widget.post?.emoji} ',
                    ),
                    const TextSpan(
                      text: 'feeling ',
                    ),
                    TextSpan(
                      text: widget.post?.feeling,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
        SizedBox(
          width: 65.w,
          child: Text(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            widget.desc ?? "",
            style: AppTextTheme.lightTextTheme.bodyMedium
                ?.copyWith(color: AppColors.secondaryColor),
          ),
        ),
        if (widget.comment?.isLoading == true)
          Container(
            margin: const EdgeInsets.only(left: 0),
            child: Text(
              'loading...',
              style: AppTextTheme.lightTextTheme.bodySmall
                  ?.copyWith(color: const Color.fromARGB(255, 196, 199, 202)),
            ),
          ),
      ],
    );
  }

  Future checkUserLike() async {
    if (widget.postId == null || FirebaseAuth.instance.currentUser == null) {
      hasLiked = false;
      return;
    }

    hasLiked = widget.comment?.isLiked ?? false;
    setState(() {});
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

    if (widget.postId != null) {
      if (isCurrentlyLiked) {
        ref
            .read(commentControllerProvider(
              widget.postId,
            ).notifier)
            .toggleUserLikes(
                likes: widget.comment?.likesCount ?? 0,
                hasLiked: isCurrentlyLiked,
                id: widget.comment!.commentId,
                parentId: widget.postId!);
      } else {
        ref
            .read(commentControllerProvider(
              widget.postId,
            ).notifier)
            .toggleUserLikes(
                likes: widget.comment?.likesCount ?? 0,
                hasLiked: isCurrentlyLiked,
                id: widget.comment!.commentId,
                parentId: widget.postId!);
      }
    }

    return !isCurrentlyLiked;
  }
}
