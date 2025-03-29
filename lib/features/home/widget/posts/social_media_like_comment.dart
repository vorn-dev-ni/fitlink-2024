import 'dart:async';

import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/features/home/controller/posts/social_like_controller.dart';
import 'package:demo/features/home/controller/posts/social_post_controller.dart';
import 'package:demo/features/home/controller/posts/user_like_controller.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SocialMediaLikeComment extends ConsumerStatefulWidget {
  String postId;
  Post? post;
  bool? isComment;
  GlobalKey<LikeButtonState> animationKey;

  SocialMediaLikeComment(
      {super.key,
      required this.postId,
      required this.isComment,
      this.post,
      required this.animationKey});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SocialMediaLikeCommentState();
}

class _SocialMediaLikeCommentState extends ConsumerState<SocialMediaLikeComment>
    with TickerProviderStateMixin {
  late final Animation<double> _scaleAnimation;
  final animationDuration = const Duration(milliseconds: 300);
  Timer? _debounceTimer;
  late AnimationController _scaleController;

  Future<bool?> _handleLike(bool isCurrentlyLiked, animationDuration) async {
    try {
      if (_debounceTimer?.isActive ?? false) {
        ref
            .read(userLikeControllerProvider(widget.postId).notifier)
            .setLikeStatus(isCurrentlyLiked);
        return isCurrentlyLiked;
      }
      _scaleController.forward().then((_) {
        _scaleController.reverse();
      });

      _debounceTimer = Timer(const Duration(milliseconds: 500), () {});
      ref
          .read(userLikeControllerProvider(widget.postId).notifier)
          .setLikeStatus(!isCurrentlyLiked);
      ref.read(socialPostControllerProvider.notifier).addUserLike(
          widget.post?.postId ?? "", 0, isCurrentlyLiked,
          parentId: widget.post?.postId, receiverId: widget.post?.user?.id);

      return !isCurrentlyLiked;
    } catch (e) {
      debugPrint("Error: $e");
      return isCurrentlyLiked;
    }
  }

  @override
  void initState() {
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_scaleController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isUserLiked = ref.watch(userLikeControllerProvider(widget.postId));
    final async = ref.watch(socialLikeControllerProvider(widget.postId));
    return async.when(
      data: (data) {
        return Padding(
          padding: const EdgeInsets.only(
              left: Sizes.lg, right: Sizes.lg, bottom: Sizes.xs, top: Sizes.lg),
          child: Row(
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: LikeButton(
                  isLiked: isUserLiked,
                  key: widget.animationKey,
                  countBuilder: (likeCount, isLiked, text) {
                    return Text(
                      '$likeCount',
                      style: AppTextTheme.lightTextTheme.bodyMedium,
                    );
                  },
                  likeCount: data.likesCount,
                  likeCountPadding: const EdgeInsets.all(0),
                  likeCountAnimationType: LikeCountAnimationType.all,
                  likeCountAnimationDuration: animationDuration,
                  likeBuilder: (bool isLiked) => Icon(
                    isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                    color: isLiked ? Colors.red : null,
                  ),
                  onTap: (bool isCurrentlyLiked) async {
                    if (!HelpersUtils.isAuthenticated(context)) {
                      return false;
                    }

                    return _handleLike(isCurrentlyLiked, animationDuration);
                  },
                ),
              ),
              const SizedBox(width: Sizes.md),
              GestureDetector(
                onTap: () async {
                  bool isAuth = HelpersUtils.isAuthenticated(context);
                  if (!isAuth || widget.isComment == false) {
                    return;
                  }

                  await HelpersUtils.navigatorState(context).pushNamed(
                    AppPage.commentListings,
                    arguments: {'post': widget.post},
                  );
                },
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.chat_bubble),
                    const SizedBox(width: Sizes.xs),
                    Text('${data.commentsCount}'),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${widget.post?.formattedCreatedAt}',
                    style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                      color: const Color.fromARGB(255, 170, 173, 178),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return emptyContent(title: error.toString().substring(0, 100));
      },
      loading: () {
        return Skeletonizer(
          enabled: true,
          child: Padding(
            padding: const EdgeInsets.only(
                left: Sizes.lg,
                right: Sizes.lg,
                bottom: Sizes.xs,
                top: Sizes.lg),
            child: Row(
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: LikeButton(
                    isLiked: false,
                    // key: widget.animationKey,
                    countBuilder: (likeCount, isLiked, text) {
                      return Text(
                        '$likeCount',
                        style: AppTextTheme.lightTextTheme.bodyMedium,
                      );
                    },
                    // likeCount: widget.post.likesCount ?? 0,
                    likeCount: 1,
                    likeCountPadding: const EdgeInsets.all(0),
                    likeCountAnimationType: LikeCountAnimationType.all,
                    likeCountAnimationDuration: animationDuration,
                    likeBuilder: (bool isLiked) => Icon(
                      isLiked
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      color: isLiked ? Colors.red : null,
                    ),
                    onTap: (bool isCurrentlyLiked) async {
                      if (!HelpersUtils.isAuthenticated(context)) {
                        return false;
                      }

                      return _handleLike(isCurrentlyLiked, animationDuration);
                    },
                  ),
                ),
                const SizedBox(width: Sizes.md),
                GestureDetector(
                  onTap: () async {
                    bool isAuth = HelpersUtils.isAuthenticated(context);
                    if (!isAuth) {
                      return;
                    }
                    await HelpersUtils.navigatorState(context).pushNamed(
                      AppPage.commentListings,
                      arguments: {'post': widget.post},
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.chat_bubble),
                      const SizedBox(width: Sizes.xs),
                      Text('${widget.post?.commentsCount}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
