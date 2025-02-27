import 'package:demo/common/widget/app_dialog.dart';
import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/common/widget/hori_button_icon.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/home/controller/comment/comment_controller.dart';
import 'package:demo/features/home/model/comment.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/features/home/widget/posts/profile_user.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/services.dart';

class CommentOverview extends ConsumerStatefulWidget {
  late Post post;
  CommentOverview({super.key, required this.post});

  @override
  ConsumerState<CommentOverview> createState() => _CommentOverviewState();
}

class _CommentOverviewState extends ConsumerState<CommentOverview> {
  late AudioPlayer playAudioUpload;

  @override
  void initState() {
    bindingAudio();
    super.initState();
  }

  @override
  void dispose() {
    playAudioUpload.dispose();
    super.dispose();
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      debugPrint('Text copied to clipboard!');
      if (DeviceUtils.isIOS()) {
        Fluttertoast.showToast(msg: 'Copied to clipboard');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final commentsStream = ref.watch(commentControllerProvider(
      widget.post.postId,
    ));

    return commentsStream.when(
      data: (data) {
        if (data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: emptyContent(title: 'Start the comment now !!!'),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
            child: ListView.builder(
              itemCount: data.length,
              padding: const EdgeInsets.only(bottom: 0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final comment = data[index];
                return GestureDetector(
                  onLongPress: () {
                    if (comment.isLoading == false) {
                      _onTapUserProfile(comment.user?.id, comment);
                    }
                  },
                  child: ProfileHeader(
                      post: widget.post,
                      key: ValueKey(comment.commentId),
                      user: comment.user ?? UserData(),
                      context: context,
                      desc: comment.text,
                      comment: comment,
                      postId: widget.post.postId,
                      imageUrl: '',
                      type: ProfileType.comment,
                      showBackButton: false),
                );
              },
            ),
          );
        }
      },
      error: (error, stackTrace) {
        return emptyContent(title: error.toString());
      },
      loading: () {
        return buildLoading();
      },
    );
  }

  Widget buildLoading() {
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
        child: ListView.builder(
          itemCount: 3,
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ProfileHeader(
                    user: UserData(),
                    context: context,
                    desc:
                        'what do you do to get in that form, can you provide some tips and trick what do you do to get in that form, can you provide some tips and trick',
                    imageUrl: 'profileheader',
                    type: ProfileType.comment,
                    showBackButton: false),
              ],
            );
          },
        ),
      ),
    );
  }

  void closeBottomSheet() {
    HelpersUtils.navigatorState(context).pop();
  }

  void _onTapUserProfile(String? uid, Comment comment) {
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
                        copyToClipboard(comment.text);
                      },
                      themeColor: AppColors.backgroundDark),
                  HoriButtonIcon(
                      icon: const Icon(
                        Icons.edit,
                        color: AppColors.backgroundDark,
                      ),
                      label: 'Edit',
                      onPress: () async {
                        closeBottomSheet();
                        final isEdit =
                            await HelpersUtils.navigatorState(context)
                                .pushNamed(AppPage.commentEditing, arguments: {
                          'postId': widget.post.postId,
                          'commentId': comment.commentId,
                          'text': comment.text
                        });
                        if (isEdit == true) {
                          playAudio();
                        }
                      },
                      themeColor: AppColors.backgroundDark),
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
                                          _handleDeleting(widget.post.postId,
                                              comment.commentId);
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
    }
  }

  void bindingAudio() async {
    playAudioUpload = AudioPlayer();
    await playAudioUpload.setAsset(Assets.audio.uploadSound);
    playAudioUpload.setVolume(0.8);
  }

  Future playAudio() async {
    await playAudioUpload.seek(Duration.zero);
    await playAudioUpload.play();
  }

  void _handleDeleting(String? postId, String commentId) async {
    try {
      ref.read(appLoadingStateProvider.notifier).setState(true);
      await ref
          .read(commentControllerProvider(
            postId,
          ).notifier)
          .deleteComments(commentId: commentId, postId: postId);
      Fluttertoast.showToast(
          msg: "Comment has been deleted !!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
      await Future.delayed(const Duration(milliseconds: 300), () {
        ref.read(appLoadingStateProvider.notifier).setState(false);
      });
    } catch (e) {
      if (mounted) {
        ref.read(appLoadingStateProvider.notifier).setState(false);
      }

      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
