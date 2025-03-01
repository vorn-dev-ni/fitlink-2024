import 'dart:async';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/features/home/controller/posts/social_post_controller.dart';
import 'package:demo/features/home/controller/posts/user_like_controller.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/features/home/widget/posts/post_desc.dart';
import 'package:demo/features/home/widget/posts/profile_user.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:sizer/sizer.dart';
import 'package:lottie/lottie.dart';

class PostPanel extends ConsumerStatefulWidget {
  final bool showHeader;
  final String? url;
  final bool? showEditable;
  final VoidCallback? twoFingersOn;
  final VoidCallback? twoFingersOff;
  final VoidCallback? pressThreedot;
  final Post post;
  final bool? isComment;
  const PostPanel({
    this.isComment = false,
    this.pressThreedot,
    this.showHeader = true,
    this.twoFingersOff,
    required this.post,
    this.url,
    this.showEditable = false,
    this.twoFingersOn,
    Key? key,
  }) : super(key: key);

  @override
  _PostPanelState createState() => _PostPanelState();
}

class _PostPanelState extends ConsumerState<PostPanel>
    with TickerProviderStateMixin {
  late FirebaseAuthService _firebaseAuthService;

  Timer? _debounceTimer;
  bool isLiking = false;
  late FirestoreService firestoreService;
  int likeCounterTemp = 0;
  bool blockScroll = false;
  bool hasClickTap = false;
  bool isAnimating = false;
  bool hasLiked = false;
  bool hasClick = false;
  StreamSubscription? _likeStreamSubscription;
  late final AnimationController _lottieController;
  late AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  StreamSubscription<User?>? streamAuthState;

  final likeAnimationKey = GlobalKey<LikeButtonState>();
  @override
  void didChangeDependencies() {
    checkUserLike();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    streamAuthState?.cancel();
    _lottieController.dispose();
    _likeStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _firebaseAuthService = FirebaseAuthService();
    firestoreService =
        FirestoreService(firebaseAuthService: FirebaseAuthService());
    _lottieController = AnimationController(vsync: this);
    checkUserLiked();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_scaleController);

    super.initState();
  }

  Future<bool?> _handleLike(bool isCurrentlyLiked, animationDuration) async {
    try {
      if (_debounceTimer?.isActive ?? false) {
        ref
            .read(userLikeControllerProvider(widget.post.postId).notifier)
            .setLikeStatus(isCurrentlyLiked);
        return isCurrentlyLiked;
      }
      _scaleController.forward().then((_) {
        _scaleController.reverse();
      });

      _debounceTimer = Timer(const Duration(milliseconds: 500), () {});
      ref
          .read(userLikeControllerProvider(widget.post.postId).notifier)
          .setLikeStatus(!isCurrentlyLiked);
      ref.read(socialPostControllerProvider.notifier).addUserLike(
          widget.post.postId ?? "",
          widget.post.likesCount ?? 0,
          isCurrentlyLiked,
          parentId: widget.post.postId,
          receiverId: widget.post.user?.id);

      return !isCurrentlyLiked;
    } catch (e) {
      debugPrint("Error: $e");
      return isCurrentlyLiked;
    }
  }

  Future _handleDoubleTapLike(bool isLiked) async {
    if (isAnimating == false) {
      _lottieController.reset();
    }
    isAnimating = true;
    if (!isLiked) {
      likeAnimationKey.currentState?.onTap();
    }
  }

  Widget build(BuildContext context) {
    const animationDuration = Duration(milliseconds: 300);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showHeader)
          ProfileHeader(
              desc: widget.post.tag ?? "",
              user: widget.post.user,
              imageUrl: widget.post.user?.avatar ?? "",
              type: widget.showEditable == false
                  ? ProfileType.header
                  : ProfileType.profile,
              onPressThreeDot: () {
                widget.pressThreedot!();
              },
              post: widget.post,
              context: null),
        if (widget.post.imageUrl != null && widget.post.imageUrl != "")
          renderImageSection(),
        if (widget.url == "loading")
          Assets.app.artOne.image(width: 100.w, fit: BoxFit.cover, height: 300),
        renderSocialMedia(context, animationDuration),
        Column(
          children: [
            postDescription(desc: widget.post.caption ?? ""),
            const SizedBox(
              height: Sizes.lg,
            ),
          ],
        ),
        const Divider(
          color: AppColors.neutralColor,
        )
      ],
    );
  }

  Widget renderImageSection() {
    final isUserLiked =
        ref.watch(userLikeControllerProvider(widget.post.postId ?? ''));
    return Stack(
      children: [
        Positioned(
          child: GestureDetector(
            onDoubleTapDown: (_) {
              bool isAuth = HelpersUtils.isAuthenticated(context);
              if (!isAuth) {
                return;
              }
              _handleDoubleTapLike(isUserLiked);
            },
            child: PinchZoomReleaseUnzoomWidget(
              minScale: 0.6,
              maxScale: 3,
              fingersRequiredToPinch: 2,
              useOverlay: true,
              overlayColor: AppColors.backgroundDark,
              clipBehavior: Clip.none,
              twoFingersOn: widget.twoFingersOn,
              twoFingersOff: widget.twoFingersOff,
              boundaryMargin: const EdgeInsets.only(bottom: 0),
              resetDuration: const Duration(milliseconds: 0),
              child: FancyShimmerImage(
                errorWidget: errorImgplaceholder(),
                cacheKey: widget.url,
                boxFit: BoxFit.cover,
                imageUrl: widget.url ??
                    "https://plus.unsplash.com/premium_photo-1661964304872-7b715cf38cd1?q=80&w=3570&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                width: 100.w,
              ),
            ),
          ),
        ),
        if (isAnimating)
          Positioned.fill(
            child: Lottie.asset(
              controller: _lottieController,
              Assets.lotties.heart,
              repeat: false,
              onLoaded: (composition) {
                _lottieController.duration = composition.duration;
                _lottieController.forward().then((value) {
                  setState(() {
                    isAnimating = false;
                  });
                });
              },
            ),
          ),
      ],
    );
  }

  Widget renderSocialMedia(BuildContext context, animationDuration) {
    final isUserLiked =
        ref.watch(userLikeControllerProvider(widget.post.postId ?? ''));
    return Padding(
      padding: const EdgeInsets.only(
          left: Sizes.lg, right: Sizes.lg, bottom: Sizes.xs, top: Sizes.lg),
      child: Row(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: LikeButton(
              isLiked: isUserLiked,
              key: likeAnimationKey,
              countBuilder: (likeCount, isLiked, text) {
                return Text(
                  '$likeCount',
                  style: AppTextTheme.lightTextTheme.bodyMedium,
                );
              },
              // likeCount: widget.post.likesCount ?? 0,
              likeCount: widget.post.likesCount,
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
          if (widget.isComment == false)
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
                  Text('${widget.post.commentsCount}'),
                ],
              ),
            ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                '${widget.post.formattedCreatedAt}',
                style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                  color: const Color.fromARGB(255, 170, 173, 178),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future checkUserLike() async {
    if (widget.post.postId == null ||
        widget.post.userLiked == null ||
        widget.post.likesCount == null ||
        FirebaseAuth.instance.currentUser == null) {
      return;
    }
    isLiking = widget.post.userLiked!;
    likeCounterTemp = widget.post.likesCount!;
    setState(() {});
  }

  void checkUserLiked() {
    if (mounted) {
      streamAuthState = _firebaseAuthService.authStateChanges.listen(
        (user) async {
          final email = LocalStorageUtils().getKey('email');
          if (email != null && email != "") {
            final result = await ref
                .read(socialPostControllerProvider.notifier)
                .isUserLiked(widget.post.postId ?? "");

            if (mounted) {
              ref
                  .read(userLikeControllerProvider(widget.post.postId).notifier)
                  .setLikeStatus(result);
            }
          }
        },
      );
    }
  }
}
