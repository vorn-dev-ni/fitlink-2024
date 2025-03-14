import 'package:demo/features/home/views/main/work_out/tiktok_comment.dart';
import 'package:demo/features/home/views/main/work_out/user_caption.dart';
import 'package:demo/features/home/views/main/work_out/user_tiktok_avatar.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
        Positioned(
          bottom: -85,
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
                              offset: Offset(0, 2),
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
                      shadows: [
                        Shadow(
                            color: AppColors.neutralBlack.withOpacity(0.5),
                            blurRadius: 19,
                            offset: const Offset(0, 0))
                      ],
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
                  Icon(
                    shadows: [
                      Shadow(
                          color: AppColors.neutralBlack.withOpacity(0.5),
                          blurRadius: 19,
                          offset: const Offset(0, 0))
                    ],
                    CupertinoIcons.chat_bubble_fill,
                    color: AppColors.backgroundLight,
                    size: Sizes.iconLg,
                  ),
                  "20", () {
                widget.onCommentPressed();
              }),
              const SizedBox(height: 20),
              _buildIcon(
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.neutralBlack.withOpacity(0.3),
                            blurRadius: 19,
                            offset: const Offset(0, 0))
                      ],
                    ),
                    child: Assets.app.shareOption.image(
                      fit: BoxFit.cover,
                      width: 33,
                      height: 33,
                      color: AppColors.backgroundLight,
                    ),
                  ),
                  "0",
                  () {}),
              SizedBox(height: 20.h),
            ],
          ),
        ),
        Positioned(
            left: 20,
            right: 0,
            bottom: 10.h,
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

  Widget _buildComment(String comment) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TiktokComment(imageUrl: ''));
  }
}
