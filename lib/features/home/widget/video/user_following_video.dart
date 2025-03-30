import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/features/home/controller/chat/following_friend_controller.dart';
import 'package:demo/features/home/controller/video/share/video_share_controller.dart';
import 'package:demo/features/home/model/chat.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserFollowingVideoShare extends ConsumerStatefulWidget {
  String videoUrl;
  String videoId;
  String thumbnailUrl;
  String receiverId;
  String avatar;
  String fullName;
  UserFollowingVideoShare(
      {super.key,
      required this.thumbnailUrl,
      required this.videoId,
      required this.fullName,
      required this.avatar,
      required this.receiverId,
      required this.videoUrl});

  @override
  ConsumerState<UserFollowingVideoShare> createState() =>
      _UserFollowingVideoShareState();
}

class _UserFollowingVideoShareState
    extends ConsumerState<UserFollowingVideoShare> {
  final TextEditingController _controller = TextEditingController();
  String? selectedIndex;
  String? userId;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(followingFriendControllerProvider(
        userId: FirebaseAuth.instance.currentUser?.uid));
    return async.when(
      data: (data) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: SingleChildScrollView(
            child: data!.isNotEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.only(top: selectedIndex != "" ? 0 : 50),
                        child: SizedBox(
                          height: 100,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            scrollDirection: Axis.horizontal,
                            itemCount: data.length,
                            cacheExtent: 50,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final result = data[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index.toString();
                                    userId = result.id;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: selectedIndex ==
                                                    index.toString()
                                                ? 1
                                                : 1,
                                            color: selectedIndex ==
                                                    index.toString()
                                                ? AppColors.errorColor
                                                : AppColors.neutralColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: result.avatar == "" ||
                                                  result.avatar == null
                                              ? Assets.app.defaultAvatar.image(
                                                  fit: BoxFit.cover,
                                                  width: 50,
                                                  height: 50,
                                                )
                                              : FancyShimmerImage(
                                                  imageUrl: result.avatar!,
                                                  cacheKey: result.avatar,
                                                  boxFit: BoxFit.cover,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(height: Sizes.sm),
                                      SizedBox(
                                        width: 70,
                                        child: Text(
                                          result.fullName ?? "",
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextTheme
                                              .lightTextTheme.bodySmall
                                              ?.copyWith(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (userId != null) renderHeader(),
                      const SizedBox(height: 12),
                      if (userId != null)
                        ElevatedButton(
                          onPressed: () {
                            _onShareVideo();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: const Text("Share"),
                        ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Assets.app.noComment
                            .image(fit: BoxFit.cover, width: 60, height: 60),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Please start follow someone first.',
                          style: AppTextTheme.lightTextTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
      error: (error, stackTrace) {
        return emptyContent(title: error.toString());
      },
      loading: () {
        return renderLoading();
      },
    );
  }

  Widget renderLoading() {
    return Skeletonizer(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: userId != "" ? 0 : 50),
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                cacheExtent: 50,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: selectedIndex == index.toString() ? 1 : 1,
                              color: selectedIndex == index.toString()
                                  ? AppColors.errorColor
                                  : AppColors.neutralColor,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Assets.app.defaultAvatar.image(
                                fit: BoxFit.contain,
                                width: 50,
                                height: 50,
                              )),
                        ),
                        const SizedBox(height: Sizes.sm),
                        SizedBox(
                          width: 70,
                          child: Text(
                            'example',
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextTheme.lightTextTheme.bodySmall
                                ?.copyWith(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (userId != null) renderHeader(),
          const SizedBox(height: 12),
          if (userId != null)
            ElevatedButton(
              onPressed: _onShareVideo,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Share"),
            ),
        ],
      ),
    ));
  }

  Widget renderHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 100.w,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: _controller,
                style: AppTextTheme.lightTextTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w400),
                // keyboardType: TextInputType.
                maxLines: 4,

                autofocus: true,
                onChanged: (value) {
                  setState(() {});
                },
                // maxLength: 100,
                decoration: const InputDecoration(
                    hintText: 'Write a message...',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(0),
                    helperStyle: TextStyle(color: AppColors.secondaryColor),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    hintStyle: TextStyle(color: AppColors.neutralDark)),
              ),
            ),
            const SizedBox(
              width: Sizes.md,
            ),
            Expanded(
              flex: 2,
              child: FancyShimmerImage(
                imageUrl: widget.thumbnailUrl,
                boxFit: BoxFit.contain,
                width: 300,
                height: 200,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onShareVideo() async {
    final payload = Message(
        type: MessageType.video,
        content: _controller.text.trim(),
        timestamp: Timestamp.now(),
        senderId: FirebaseAuth.instance.currentUser?.uid,
        thumbnailUrl: widget.thumbnailUrl,
        videoUrl: widget.videoUrl,
        videoAvatarUser: widget.avatar,
        videoUserName: widget.fullName,
        videoId: widget.videoId);
    DeviceUtils.hideKeyboard(context);

    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        HelpersUtils.navigatorState(context).pop();
      }
    });

    Fluttertoast.showToast(
        msg: 'Video share is in process...',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        fontSize: 16.0);

    await ref.read(videoShareControllerProvider.notifier).onShareVideo(
        payload, userId ?? "", widget.videoId,
        avatar: widget.avatar, fullName: widget.fullName);
  }
}
