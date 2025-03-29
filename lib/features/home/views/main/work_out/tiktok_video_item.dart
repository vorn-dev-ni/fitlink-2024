import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/features/home/views/main/work_out/social_interacton_video.dart';
import 'package:demo/features/home/views/main/work_out/user_caption.dart';
import 'package:demo/features/home/views/main/work_out/user_tiktok_avatar.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VideoTiktokItem extends ConsumerStatefulWidget {
  final String img;
  String? caption;
  int? likeCount;
  bool? isProfile;
  int? commentCount;
  String? videoId;
  int? shareCount;
  final UserData? userdata;
  bool? isUserliked;
  Timestamp date;
  List<dynamic>? tags;
  final VoidCallback onCommentPressed;

  VideoTiktokItem(
      {Key? key,
      required this.img,
      this.videoId,
      required this.date,
      this.tags,
      this.isProfile,
      this.isUserliked,
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

class _VideoTiktokItemState extends ConsumerState<VideoTiktokItem>
    with AutomaticKeepAliveClientMixin<VideoTiktokItem> {
  bool showMore = false;
  @override
  Widget build(BuildContext context) {
    // Fluttertoast.showToast(msg: 'Re render video tiem ${widget.videoId}');
    return Stack(
      children: [
        SocialInteractonVideo(
            onCommentPressed: widget.onCommentPressed,
            videoId: widget.videoId ?? "",
            isUserliked: widget.isUserliked,
            receiverID: widget.userdata?.id,
            showEditIcon: widget.isProfile),
        MetaDataVideo(
          caption: widget.caption ?? "This is an",
          date: widget.date,
          tags: widget.tags!,
          userdata: widget.userdata!,
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MetaDataVideo extends StatefulWidget {
  final UserData userdata;
  final String caption;
  final List tags;
  final Timestamp date;

  const MetaDataVideo(
      {super.key,
      required this.userdata,
      required this.caption,
      required this.date,
      required this.tags});

  @override
  State<MetaDataVideo> createState() => _MetaDataVideoState();
}

class _MetaDataVideoState extends State<MetaDataVideo> {
  bool showMore = true;
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 20,
        right: 0,
        bottom: 20.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfile(),
            const SizedBox(
              height: Sizes.md,
            ),
            _buildCaption(widget.caption ??
                'My Journey so far, you can check out my work out plan'),
            const SizedBox(
              height: Sizes.md,
            ),
            showMore == true
                ? _buildMetaData(widget.date, widget.tags ?? [])
                : const SizedBox(),
            const SizedBox(
              height: Sizes.md,
            ),
            GestureDetector(
              onTap: () {
                WidgetsBinding.instance.addPostFrameCallback(
                  (timeStamp) {
                    setState(() {
                      showMore = !showMore;
                    });
                  },
                );
              },
              child: Text(
                showMore ? 'See less' : 'See more',
                style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                    color: const Color.fromARGB(255, 232, 225, 225),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ));
  }

  Widget _buildUserProfile() {
    return GestureDetector(
      onTap: () {
        final isAuth = HelpersUtils.isAuthenticated(context);
        if (isAuth &&
            FirebaseAuth.instance.currentUser?.uid != widget.userdata.id) {
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

  Widget _buildMetaData(Timestamp date, List<dynamic> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          FormatterUtils.formatTimestamp(
            date,
          ),
          style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
              color: const Color.fromARGB(255, 232, 225, 225),
              fontWeight: FontWeight.w400),
        ),
        Wrap(
            runSpacing: 4,
            spacing: 4,
            children: List.generate(
              tags.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  '#${tags[index]}',
                  style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                      color: const Color.fromARGB(255, 232, 225, 225),
                      fontWeight: FontWeight.w400),
                ),
              ),
            ))
      ],
    );
  }
}
