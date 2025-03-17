import 'package:demo/features/home/model/post.dart';
import 'package:demo/features/home/views/main/work_out/social_interacton_video.dart';
import 'package:demo/features/home/views/main/work_out/user_caption.dart';
import 'package:demo/features/home/views/main/work_out/user_tiktok_avatar.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

class VideoTiktokItem extends StatefulWidget {
  final String img;
  String? caption;
  int? likeCount;
  int? commentCount;
  String? videoId;
  int? shareCount;
  final UserData? userdata;
  final VoidCallback onCommentPressed;

  VideoTiktokItem(
      {Key? key,
      required this.img,
      this.videoId,
      required this.onCommentPressed,
      this.likeCount,
      this.commentCount,
      this.caption,
      this.shareCount,
      this.userdata})
      : super(key: key);

  @override
  _VideoTiktokItemState createState() => _VideoTiktokItemState();
}

class _VideoTiktokItemState extends State<VideoTiktokItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SocialInteractonVideo(
          onCommentPressed: widget.onCommentPressed,
          videoId: widget.videoId ?? "",
        ),
        Positioned(
            left: 20,
            right: 0,
            bottom: 16.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserProfile(),
                const SizedBox(
                  height: Sizes.md,
                ),
                _buildCaption(widget.caption ??
                    'My Journey so far, you can check out my work out plan, My Journey so far, you can check out my work out plan, My Journey so far, you can check out my work out plan.'),
              ],
            )),
      ],
    );
  }

  Widget _buildUserProfile() {
    return GestureDetector(
      onTap: () {
        if (FirebaseAuth.instance.currentUser?.uid != widget.userdata?.id) {
          HelpersUtils.navigatorState(context).pushNamed(AppPage.viewProfile,
              arguments: {'userId': widget.userdata?.id});
        }
      },
      child: UserProfile(
        name: widget.userdata?.fullName ?? "",
        avatar: widget.userdata?.avatar == "" || widget.userdata?.avatar == null
            ? Assets.app.defaultAvatar.image(
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              )
            : FancyShimmerImage(
                imageUrl: widget.userdata?.avatar ?? "",
                boxFit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
      ),
    );
  }

  Widget _buildCaption(String caption) {
    return captionText(caption);
  }
}
