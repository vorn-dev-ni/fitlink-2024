import 'dart:async';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/features/home/controller/posts/social_post_controller.dart';
import 'package:demo/features/home/controller/posts/user_like_controller.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/features/home/widget/posts/post_desc.dart';
import 'package:demo/features/home/widget/posts/profile_user.dart';
import 'package:demo/features/home/widget/posts/social_media_like_comment.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  StreamSubscription<User?>? streamAuthState;

  final likeAnimationKey = GlobalKey<LikeButtonState>();
  @override
  void didChangeDependencies() {
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

    super.initState();
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
        if (widget.post.imageUrl == null)
          Column(
            children: [
              const SizedBox(
                height: Sizes.lg,
              ),
              postDescription(desc: widget.post.caption ?? ""),
            ],
          ),
        if (widget.url != "loading")
          SocialMediaLikeComment(
            postId: widget.post.postId ?? "",
            isComment: widget.isComment,
            animationKey: likeAnimationKey,
            post: widget.post,
          ),
        if (widget.post.imageUrl != null)
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
                cacheKey: widget.post.imageUrl,
                boxFit: BoxFit.cover,
                imageUrl: widget.post.imageUrl ??
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
