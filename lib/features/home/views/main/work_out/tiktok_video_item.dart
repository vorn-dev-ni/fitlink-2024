import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:demo/features/home/views/main/work_out/tiktok_comment.dart';
import 'package:demo/features/home/views/main/work_out/user_caption.dart';
import 'package:demo/features/home/views/main/work_out/user_tiktok_avatar.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:like_button/like_button.dart';
import 'package:sizer/sizer.dart';

class VideoTiktokItem extends StatefulWidget {
  final String img;
  final VoidCallback onCommentPressed;

  const VideoTiktokItem(
      {Key? key, required this.img, required this.onCommentPressed})
      : super(key: key);

  @override
  _VideoTiktokItemState createState() => _VideoTiktokItemState();
}

class _VideoTiktokItemState extends State<VideoTiktokItem> {
  void _showCommentBottomSheet() {}

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FancyShimmerImage(
          errorWidget: errorImgplaceholder(),
          imageUrl: widget.img,
          boxFit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(
                  LikeButton(
                    isLiked: false,
                    countPostion: CountPostion.bottom,
                    countBuilder: (likeCount, isLiked, text) {
                      return Text(
                        '$likeCount',
                        style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                          color: AppColors.backgroundLight,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            const Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4.0,
                              color: Colors.black, // Black shadow
                            ),
                          ],
                        ),
                      );
                    },
                    likeCountPadding: const EdgeInsets.only(right: 0),
                    likeCount: 0,
                    // bubblesSize: 40,

                    likeCountAnimationDuration:
                        const Duration(milliseconds: 300),
                    likeBuilder: (bool isLiked) => Icon(
                      isLiked
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart_fill,
                      size: Sizes.iconLg,
                      color: isLiked ? Colors.red : AppColors.backgroundLight,
                    ),
                    // onTap: (isLiked) ,
                  ),
                  "", () {
                // _showCommentBottomSheet();
              }),
              // const SizedBox(height: 20),
              _buildIcon(
                  const Icon(
                    CupertinoIcons.chat_bubble_fill,
                    color: AppColors.backgroundLight,
                    size: Sizes.iconLg,
                  ),
                  "20", () {
                widget.onCommentPressed();
              }),
              const SizedBox(height: 20),
              _buildIcon(
                  Assets.app.shareOption.image(
                    fit: BoxFit.cover,
                    width: 33,
                    height: 33,
                    color: AppColors.backgroundLight,
                  ),
                  "Share",
                  () {}),
              SizedBox(height: 20.h),
            ],
          ),
        ),
        Positioned(
            left: 20,
            right: 0,
            bottom: 15.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserProfile(),
                const SizedBox(
                  height: Sizes.md,
                ),
                _buildCaption(
                    'My Journey so far, you can check out my work out plan, My Journey so far, you can check out my work out plan, My Journey so far, you can check out my work out plan.'),
              ],
            )),
        const Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 100,
          ),
        ),
      ],
    );
  }

  Widget _buildUserProfile() {
    return UserProfile(
      name: "Panhavorn",
      avatar: Assets.app.defaultAvatar.image(
        fit: BoxFit.cover,
        width: 50,
        height: 50,
      ),
    );
  }

  Widget _buildCaption(String caption) {
    return captionText(caption);
  }

  Widget _buildIcon(Widget icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            children: [
              Positioned(
                top: 2,
                left: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDark
                        .withOpacity(0.5), // Shadow effect
                    borderRadius:
                        BorderRadius.circular(10), // Optional rounded corners
                  ),
                ),
              ),
              // Main icon
              icon,
              Positioned(
                  top: 2,
                  left: 2,
                  child: Container(
                    color: AppColors.backgroundDark.withOpacity(0.5),
                  )),
            ],
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4.0,
                  color: Colors.black, // Black shadow
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComment(String comment) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TiktokComment(imageUrl: ''));
  }
}
