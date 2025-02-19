import 'package:demo/features/home/widget/posts/post_desc.dart';
import 'package:demo/features/home/widget/posts/profile_user.dart';
import 'package:demo/features/home/widget/posts/social_media_bottom.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PostPanel extends StatefulWidget {
  final bool showHeader;
  final String? url;
  final VoidCallback? twoFingersOn;
  final VoidCallback? twoFingersOff;
  const PostPanel({
    this.showHeader = true,
    this.twoFingersOff,
    this.url,
    this.twoFingersOn,
    Key? key,
  }) : super(key: key);

  @override
  _PostPanelState createState() => _PostPanelState();
}

class _PostPanelState extends State<PostPanel> {
  bool blockScroll = false;
  bool hasClickTap = false;
  bool isAnimating = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showHeader)
          const ProfileHeader(
              desc: 'Vacation',
              imageUrl: 'profileheader',
              type: ProfileType.profile,
              context: null),
        Stack(
          children: [
            Positioned(
              child: GestureDetector(
                onDoubleTapDown: (_) {
                  if (!isAnimating) {
                    setState(() {
                      hasClickTap = !hasClickTap;
                      isAnimating = true;
                    });
                  }
                },
                child: PinchZoomReleaseUnzoomWidget(
                  minScale: 0.8,
                  maxScale: 3,
                  fingersRequiredToPinch: 0,
                  useOverlay: true,
                  overlayColor: AppColors.backgroundDark,
                  clipBehavior: Clip.none,
                  twoFingersOn: widget.twoFingersOn,
                  twoFingersOff: widget.twoFingersOff,
                  boundaryMargin: const EdgeInsets.only(bottom: 0),
                  resetDuration: const Duration(milliseconds: 0),
                  child: FancyShimmerImage(
                    errorWidget: errorImgplaceholder(),
                    imageUrl: widget.url ??
                        "https://plus.unsplash.com/premium_photo-1661964304872-7b715cf38cd1?q=80&w=3570&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    width: 100.w,
                  ),
                ),
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: const Icon(
                  CupertinoIcons.heart_fill,
                  color: AppColors.errorColor,
                )
                    .animate(
                      onComplete: (controller) {
                        setState(() {
                          isAnimating = false;
                        });
                      },
                      target: hasClickTap ? 1 : 0,
                    )
                    .scale(
                      begin:
                          hasClickTap ? const Offset(5, 5) : const Offset(0, 0),
                      end:
                          hasClickTap ? const Offset(0, 0) : const Offset(5, 5),
                      duration: const Duration(milliseconds: 300),
                    )
                    .animate(
                      onComplete: (controller) {
                        setState(() {
                          isAnimating = false;
                        });
                      },
                      target: hasClickTap ? 1 : 0,
                    ))
          ],
        ),
        SocialMediaBottom(
          comments: 25,
          likes: 4,
        ),
        postDescription(
          desc:
              'ius earum ut molestias architecto voluptate aliquamnihil, eveniet aliquid culpa officia aut!',
        ),
        const SizedBox(
          height: Sizes.lg,
        ),
        const Divider(
          color: AppColors.neutralColor,
        )
      ],
    );
  }
}
