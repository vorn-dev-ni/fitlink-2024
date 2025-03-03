import 'package:demo/common/widget/app_dialog.dart';
import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/home/controller/posts/post_media_controller.dart';
import 'package:demo/features/home/controller/posts/social_post_controller.dart';
import 'package:demo/features/home/controller/posts/social_postone_controller.dart';
import 'package:demo/features/home/controller/profile/profile_post_controller.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/features/home/widget/posts/post_panel.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostProfile extends ConsumerStatefulWidget {
  String userId;
  bool? currentUser;
  PostProfile({super.key, required this.userId, this.currentUser = true});

  @override
  ConsumerState<PostProfile> createState() => _PostProfileState();
}

class _PostProfileState extends ConsumerState<PostProfile> {
  bool blockScroll = false;
  late AudioPlayer playAudioUpload;

  @override
  void initState() {
    bindingAudio();
    super.initState();
  }

  Future<void> loadNextPage() async {
    // await ref
    //     .read(commentControllerProvider(post.postId!).notifier)
    //     .loadNextPage(post.postId!);
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(profilePostControllerProvider(
        widget.currentUser == true ? null : widget.userId));

    return async.when(
      data: (data) {
        return data != null && data.isNotEmpty
            ? ListView.builder(
                itemCount: data.length,
                physics: const NeverScrollableScrollPhysics(),
                // physics: blockScroll
                //     ? const NeverScrollableScrollPhysics()
                //     : const ScrollPhysics(),
                padding: const EdgeInsets.only(top: Sizes.xl, bottom: 140),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final result = data[index];
                  return PostPanel(
                    post: result,
                    pressThreedot: () {
                      _onTapUserProfile(context, result.postId, result);
                    },
                    showEditable: true,
                    isComment: true,
                    url: result.imageUrl,
                    showHeader: true,
                    twoFingersOn: () => setState(() => blockScroll = true),
                    twoFingersOff: () => Future.delayed(
                      PinchZoomReleaseUnzoomWidget.defaultResetDuration,
                      () => setState(() => blockScroll = false),
                    ),
                  );
                },
              )
            : SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: emptyContent(
                    title: 'Oop, this user has no related post yet !!!'),
              );
      },
      error: (error, stackTrace) {
        debugPrint('Error is ${error.toString()}');
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: emptyContent(title: error.toString()),
        );
      },
      loading: () {
        return renderLoading();
      },
    );
  }

  void closeBottomSheet() {
    HelpersUtils.navigatorState(context).pop();
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

  void _handleDeleting(String? postId, String? postImageUrl) async {
    try {
      ref.read(appLoadingStateProvider.notifier).setState(true);
      await ref
          .read(socialPostControllerProvider.notifier)
          .deletePost(postId ?? "", postImageUrl);
      ref.invalidate(socialPostControllerProvider);
      ref.invalidate(socialPostoneControllerProvider);
      Fluttertoast.showToast(
          msg: "Post has been deleted !!!",
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

  void _onTapUserProfile(BuildContext context, String? postId, Post post) {
    if (postId != null && FirebaseAuth.instance.currentUser != null) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: const Color.fromARGB(255, 236, 241, 247),
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.0)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.edit,
                        color: AppColors.backgroundDark,
                        size: Sizes.iconSm,
                      ),
                      title: Text(
                        'Edit Post',
                        style: AppTextTheme.lightTextTheme.bodyMedium,
                      ),
                      onTap: () {
                        closeBottomSheet();

                        ref
                            .read(postMediaControllerProvider.notifier)
                            .updateState(post);

                        HelpersUtils.navigatorState(context).pushNamed(
                            AppPage.createPost,
                            arguments: {'isEdit': true});
                        // Navigate to edit post logic here
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.delete,
                        color: AppColors.backgroundDark,
                        size: Sizes.iconSm,
                      ),
                      title: Text(
                        'Delete Post',
                        style: AppTextTheme.lightTextTheme.bodyMedium,
                      ),
                      onTap: () {
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
                                          _handleDeleting(
                                              postId, post.imageUrl);
                                        },
                                        child: Text('Delete',
                                            style: AppTextTheme
                                                .lightTextTheme.bodyLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .errorColor)))),
                                title: 'Delete Post',
                                textColor: AppColors.backgroundDark,
                                contentColor: AppColors.backgroundDark,
                                desc:
                                    "Are you sure you want to permanently remove this post from FitLink?"));
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  Widget renderLoading() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 4,
        padding: const EdgeInsets.only(top: Sizes.xl, bottom: 140),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Sizes.xs),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(Sizes.lg),
                child: Assets.app.defaultAvatar.image(
                  width: 100.w,
                  fit: BoxFit.cover,
                  height: 250,
                )),
          );
        },
      ),
    );
  }
}
