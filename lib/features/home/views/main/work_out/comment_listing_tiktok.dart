import 'dart:io';
import 'package:demo/common/widget/app_dialog.dart';
import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/common/widget/hori_button_icon.dart';
import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/features/home/controller/video/comment/comment_loading_tiktok.dart';
import 'package:demo/features/home/controller/video/comment/comment_video_controller.dart';
import 'package:demo/features/home/views/main/work_out/tiktok_comment.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommentsSection extends ConsumerStatefulWidget {
  final String videoId;
  final String receiverID;
  final List<CommentTikTok> data;

  const CommentsSection({
    Key? key,
    required this.videoId,
    required this.data,
    required this.receiverID,
  }) : super(key: key);

  @override
  ConsumerState<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends ConsumerState<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }

  void _scrollListener() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref
          .read(tiktokCommentControllerProvider(widget.videoId).notifier)
          .loadMoreComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      snap: true,
      snapAnimationDuration: const Duration(milliseconds: 500),
      snapSizes: const [0.5, 0.7, 0.9],
      expand: false,
      builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 0,
          ),
          child: renderContent(),
        );
      },
    );
  }

  Widget renderContent() {
    return Column(
      children: [
        Text(
          'Comments',
          style: AppTextTheme.lightTextTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        const Divider(color: AppColors.neutralColor),
        widget.data.isEmpty
            ? Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.app.noComment
                          .image(fit: BoxFit.cover, width: 100, height: 100),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("No comments yet"),
                    ],
                  ),
                ),
              )
            : Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: List.generate(
                      widget.data.length + 1,
                      (index) {
                        if (index == widget.data.length) {
                          final loading =
                              ref.watch(commentLoadingTiktokProvider);
                          return loading
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: appLoadingSpinner(),
                                )
                              : const SizedBox();
                        } else {
                          return GestureDetector(
                            onTap: () {
                              _onTapUserProfile(
                                  widget.data[index].userData?.id ?? "",
                                  widget.data[index].documentId ?? "",
                                  widget.data[index].text ?? "");
                            },
                            child: Padding(
                              key: UniqueKey(),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: _buildComment(
                                  widget.data[index], widget.videoId),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
        _buildCommentInput(setState),
      ],
    );
  }

  Widget _buildComment(CommentTikTok? comment, String? videoId) {
    return TiktokComment(
      data: comment,
      key: UniqueKey(),
      videoId: videoId,
    );
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      debugPrint('Text copied to clipboard!');
      if (DeviceUtils.isIOS()) {
        Fluttertoast.showToast(msg: 'Copied to clipboard');
      }
    });
  }

  void closeBottomSheet() {
    HelpersUtils.navigatorState(context).pop();
  }

  void _onTapUserProfile(String? uid, String commentId, String caption) {
    if (uid != null &&
        FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser!.uid == uid) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: 100.w,
            height: 17.h,
            padding: const EdgeInsets.all(Sizes.lg),
            color: const Color.fromARGB(255, 238, 241, 243),
            child: Padding(
              padding: const EdgeInsets.only(top: Sizes.lg),
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  HoriButtonIcon(
                      icon: const Icon(
                        Icons.copy,
                        color: AppColors.backgroundDark,
                      ),
                      label: 'Copy',
                      onPress: () {
                        closeBottomSheet();
                        copyToClipboard(caption);
                      },
                      themeColor: AppColors.backgroundDark),
                  // HoriButtonIcon(
                  //     icon: const Icon(
                  //       Icons.edit,
                  //       color: AppColors.backgroundDark,
                  //     ),
                  //     label: 'Edit',
                  //     onPress: () async {
                  //       closeBottomSheet();
                  //       final isEdit =
                  //           await HelpersUtils.navigatorState(context)
                  //               .pushNamed(AppPage.commentEditing, arguments: {
                  //         'postId': widget.post.postId,
                  //         'commentId': comment.commentId,
                  //         'text': comment.text
                  //       });
                  //       if (isEdit == true) {
                  //         playAudio();
                  //       }
                  //     },
                  //     themeColor: AppColors.backgroundDark),
                  HoriButtonIcon(
                      icon: const Icon(
                        Icons.delete,
                        color: AppColors.errorColor,
                      ),
                      label: 'Delete',
                      onPress: () {
                        closeBottomSheet();
                        showDialog(
                            context: context,
                            builder: (context) => AppALertDialog(
                                // bgColor: const Color.fromRGBO(0, 0, 0, 1)
                                //     .withOpacity(0.4),
                                bgColor: AppColors.backgroundLight,
                                onConfirm: () {},
                                showIcon: false,
                                negativeButton: SizedBox(
                                    width: 100.w,
                                    child: FilledButton(
                                        style: FilledButton.styleFrom(
                                            foregroundColor:
                                                AppColors.secondaryColor,
                                            backgroundColor:
                                                AppColors.backgroundLight),
                                        onPressed: () {
                                          HelpersUtils.navigatorState(context)
                                              .pop();
                                        },
                                        child: Text('Cancel',
                                            style: AppTextTheme
                                                .lightTextTheme.bodyLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .secondaryColor)))),
                                positivebutton: SizedBox(
                                    width: 100.w,
                                    child: FilledButton(
                                        style: FilledButton.styleFrom(
                                            foregroundColor:
                                                AppColors.errorColor,
                                            backgroundColor:
                                                AppColors.backgroundLight),
                                        onPressed: () {
                                          HelpersUtils.navigatorState(context)
                                              .pop();
                                          ref
                                              .read(
                                                  tiktokCommentControllerProvider(
                                                          widget.videoId)
                                                      .notifier)
                                              .deleteComment(commentId);
                                        },
                                        child: Text('Delete',
                                            style: AppTextTheme
                                                .lightTextTheme.bodyLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .errorColor)))),
                                title: 'Delete Comment',
                                textColor: AppColors.backgroundDark,
                                contentColor: AppColors.backgroundDark,
                                desc:
                                    "Are you sure you want to permanently remove this comment from FitLink?"));
                      },
                      themeColor: AppColors.backgroundDark),
                ],
              ),
            ),
          );
        },
      );

      return;
    }

    HelpersUtils.navigatorState(context)
        .pushNamed(AppPage.viewProfile, arguments: {'userId': uid});
  }

  Widget _buildCommentInput(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          renderProfile(),
          Expanded(
            child: TextField(
              controller: _commentController,
              focusNode: _commentFocusNode,
              style: AppTextTheme.lightTextTheme.bodyMedium
                  ?.copyWith(color: AppColors.backgroundDark),
              decoration: InputDecoration(
                  counterText: '',
                  hintStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                      color: const Color.fromARGB(255, 119, 114, 114)),
                  hintText: "Write a comment...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.backgroundLight),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.neutralColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 72, 70, 70)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  helperStyle:
                      const TextStyle(color: AppColors.backgroundDark)),
              onChanged: (value) {
                setState(() {});
              },
              maxLines: 4,
              maxLength: 25,
              minLines: 1,
            ),
          ),
          if (Platform.isIOS)
            const SizedBox(
              height: 100,
            ),
          if (_commentController.text.isNotEmpty)
            IconButton(
              onPressed: () async {
                String newComment = _commentController.text.trim();
                _commentController.clear();
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);

                await ref
                    .read(tiktokCommentControllerProvider(widget.videoId)
                        .notifier)
                    .writeComment(newComment, widget.receiverID ?? "");
              },
              icon: const Icon(
                Icons.send,
                color: AppColors.secondaryColor,
              ),
            ),
        ],
      ),
    );
  }

  renderProfile() {
    final profile = ref.watch(profileUserControllerProvider);
    return profile.when(
      data: (data) {
        return Row(
          children: [
            data?.avatar != null && data!.avatar != ""
                ? Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: AppColors.neutralColor),
                      borderRadius: BorderRadius.circular(Sizes.xxxl),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(Sizes.xxxl),
                        child: FancyShimmerImage(
                            imageUrl: data.avatar!,
                            boxFit: BoxFit.cover,
                            width: 50,
                            height: 50)),
                  )
                : Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: AppColors.neutralColor),
                      borderRadius: BorderRadius.circular(Sizes.xxxl),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(Sizes.xxxl),
                        child: Assets.app.defaultAvatar
                            .image(fit: BoxFit.cover, width: 50, height: 50)),
                  ),
            const SizedBox(
              width: Sizes.md,
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        return const CircleAvatar();
      },
      loading: () {
        return Skeletonizer(
          enabled: true,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: AppColors.neutralColor),
                  borderRadius: BorderRadius.circular(Sizes.xxxl),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(Sizes.xxxl),
                    child: Assets.app.defaultAvatar
                        .image(fit: BoxFit.cover, width: 50, height: 50)),
              ),
              const SizedBox(
                width: Sizes.md,
              ),
            ],
          ),
        );
      },
    );
  }
}
