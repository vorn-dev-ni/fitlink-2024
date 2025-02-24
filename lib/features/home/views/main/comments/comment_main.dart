import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:demo/features/home/controller/comment/comment_controller.dart';
import 'package:demo/features/home/controller/comment/comment_loading.dart';
import 'package:demo/features/home/controller/comment/comment_loading_dummy.dart';
import 'package:demo/features/home/controller/posts/single_post_controller.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/features/home/views/main/comments/comment_overview.dart';
import 'package:demo/features/home/widget/posts/post_panel.dart';
import 'package:demo/features/home/widget/posts/profile_user.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommentMain extends ConsumerStatefulWidget {
  const CommentMain({super.key});

  @override
  ConsumerState<CommentMain> createState() => _CommentMainState();
}

class _CommentMainState extends ConsumerState<CommentMain> {
  late TextEditingController _commentTextController;
  late FocusNode _textFocuscope;
  bool blockScroll = false;
  bool hasClickTap = false;
  bool isResize = false;
  bool isAnimating = false;
  bool isLoading = false; // Track if we are loading more comments
  int currPageSizes = 10;
  late AudioPlayer playAudioUpload;
  late Post post;
  late ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    bindingAudio();
    _textFocuscope = FocusNode();
    _commentTextController = TextEditingController();
    requestFocus();
    _scrollController.addListener(
      () async {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (post.postId != null) {
            await loadNextPage();
          }
        }
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    bindingPost();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _textFocuscope.dispose();
    playAudioUpload.dispose();
    super.dispose();
  }

  Future<void> loadNextPage() async {
    await ref
        .read(commentControllerProvider(post.postId!).notifier)
        .loadNextPage(post.postId!);
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DeviceUtils.hideKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: renderAppBar(context),
        resizeToAvoidBottomInset: DeviceUtils.isAndroid() ? isResize : false,
        bottomSheet: renderBottomSheet(context),
        body: renderBody(),
      ),
    );
  }

  AppBar renderAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      leadingWidth: 100.w,
      leading: ProfileHeader(
          context: context,
          user: post.user ?? UserData(),
          desc: post.caption,
          post: post,
          postId: post.postId,
          imageUrl: post.user?.avatar ?? "",
          type: ProfileType.header,
          showBackButton: true),
    );
  }

  Widget renderBody() {
    final async = ref.watch(singlePostControllerProvider(post.postId!));
    return SafeArea(
        child: PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        bool keyboardVisible = isKeyboardVisible(context);
        if (didPop) {
          return;
        }
        DeviceUtils.hideKeyboard(context);
        if (!keyboardVisible) {
          HelpersUtils.navigatorState(context).pop(true);
          return;
        }
      },
      child: SingleChildScrollView(
          controller: _scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: blockScroll
              ? const NeverScrollableScrollPhysics()
              : const ScrollPhysics(),
          child: Column(
            children: [
              async.when(
                data: (data) {
                  return Column(
                    children: [
                      PostPanel(
                        post: data!,
                        isComment: true,
                        url: data.imageUrl,
                        showHeader: false,
                        twoFingersOn: () => setState(() => blockScroll = true),
                        twoFingersOff: () => Future.delayed(
                          PinchZoomReleaseUnzoomWidget.defaultResetDuration,
                          () => setState(() => blockScroll = false),
                        ),
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) {
                  return emptyContent(title: error.toString());
                },
                loading: () {
                  return buildLoading();
                },
              ),
              renderComments(post),
              renderPaging(),
            ],
          )),
    ));
  }

  Widget renderPaging() {
    final pagingLoading = ref.watch(commentPagingLoadingProvider);
    return Container(
        alignment: Alignment.topCenter,
        height: pagingLoading ? 360 : 120,
        child: pagingLoading
            ? const CircularProgressIndicator(
                color: AppColors.secondaryColor,
              )
            : const Text(''));
  }

  Widget buildLoading() {
    return Skeletonizer(
        enabled: true,
        child: Column(
          children: [
            PostPanel(
              post: Post(),
              isComment: true,
              url: "",
              showHeader: false,
              twoFingersOn: () => setState(() => blockScroll = true),
              twoFingersOff: () => Future.delayed(
                PinchZoomReleaseUnzoomWidget.defaultResetDuration,
                () => setState(() => blockScroll = false),
              ),
            ),
            const SizedBox(
              height: Sizes.md,
            ),
          ],
        ));
  }

  Widget renderBottomSheet(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.lg),
        child: SizedBox(
          height: 7.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              currentUserAvatar(),
              const SizedBox(
                width: Sizes.sm,
              ),
              Expanded(
                  child: TextField(
                focusNode: _textFocuscope,
                controller: _commentTextController,
                autofocus: false,
                onChanged: (value) {
                  setState(() {});
                },
                style: AppTextTheme.lightTextTheme.bodyMedium,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.neutralColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.secondaryColor)),
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(color: AppColors.neutralDark)),
              )),
              const SizedBox(
                width: Sizes.sm,
              ),
              if (_commentTextController.text.isNotEmpty)
                IconButton(
                    onPressed: () async {
                      if (!HelpersUtils.isAuthenticated(context)) {
                        return;
                      }
                      DeviceUtils.hideKeyboard(context);
                      await handleSubmitComment();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: AppColors.secondaryColor,
                    ))
            ],
          ),
        ),
      ),
    );
  }

  Widget currentUserAvatar() {
    final asyncUser = ref.watch(profileUserControllerProvider);
    return asyncUser.when(
      data: (data) {
        return ClipOval(
          child: data?.avatar == "" || data?.avatar == null
              ? Container(
                  child: Assets.app.defaultAvatar
                      .image(width: 40, height: 40, fit: BoxFit.cover),
                )
              : FancyShimmerImage(
                  boxFit: BoxFit.cover,
                  width: 40,
                  height: 40,
                  imageUrl: data!.avatar!,
                  errorWidget: errorImgplaceholder()),
        );
      },
      error: (error, stackTrace) {
        return emptyContent(title: error.toString());
      },
      loading: () {
        return Skeletonizer(
            enabled: true,
            child: ClipOval(
                child: Container(
              child: Assets.app.defaultAvatar
                  .image(width: 40, height: 40, fit: BoxFit.cover),
            )));
      },
    );
  }

  Widget renderComments(Post? postId) {
    return CommentOverview(
      post: post,
    );
  }

  bool isKeyboardVisible(BuildContext context) {
    final padding = MediaQuery.of(context).viewInsets.bottom;
    return padding > 0;
  }

  void bindingPost() {
    final routes =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    if (routes.containsKey('post')) {
      post = routes['post'];
      debugPrint('run ${post.postId}');
    } else {
      post = Post();
    }

    setState(() {
      isResize = true;
    });
  }

  Future handleSubmitComment() async {
    try {
      final value = _commentTextController.text;
      _commentTextController.clear();
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      await ref
          .read(commentControllerProvider(
            post.postId,
          ).notifier)
          .submitComment(
              parentId: post.postId,
              text: value,
              count: post.commentsCount ?? 0);

      if (mounted) {
        playAudio();
      }
      Fluttertoast.showToast(
          msg: 'Successfully Posted !!!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: AppColors.secondaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void requestFocus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _textFocuscope.requestFocus();
  }
}
