import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/features/home/controller/posts/post_loading_paging.dart';
import 'package:demo/features/home/controller/posts/social_postone_controller.dart';
import 'package:demo/features/home/controller/tab/home_scroll_controller.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/features/home/widget/posts/post_panel.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/permission_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:flutter/cupertino.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SocialMediaTab extends ConsumerStatefulWidget {
  const SocialMediaTab({super.key});

  @override
  ConsumerState<SocialMediaTab> createState() => _SocialMediaTabState();
}

class _SocialMediaTabState extends ConsumerState<SocialMediaTab>
    with AutomaticKeepAliveClientMixin<SocialMediaTab> {
  List<String> dummyData = [
    "https://plus.unsplash.com/premium_photo-1661964304872-7b715cf38cd1?q=80&w=3570&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1550399504-8953e1a6ac87?q=80&w=3729&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://plus.unsplash.com/premium_photo-1680981143104-f165d1d6d39c?q=80&w=3732&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1566371486490-560ded23b5e4?q=80&w=3570&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1546749876-2088f8b19e09?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8c2V4eSUyMGd5bXxlbnwwfHwwfHx8MA%3D%3D",
    "https://images.unsplash.com/photo-1596079306903-9164c205f400?q=80&w=3571&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://plus.unsplash.com/premium_photo-1665673313231-b3cef27c80dd?q=80&w=3570&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  ];
  late ScrollController scrollController;
  bool blockScroll = false;
  bool hasClickTap = false;
  bool isAnimating = false;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        PermissionUtils.checkNotificationPermission(context);
      }
    });

    final scrollController = ref.read(homeScrollControllerProvider);
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  // This function will be triggered when scrolling

  @override
  Widget build(BuildContext context) {
    final asyncValues = ref.watch(socialPostoneControllerProvider);
    final scrollController = ref.watch(homeScrollControllerProvider);
    return SingleChildScrollView(
      controller: scrollController,
      physics: blockScroll
          ? const NeverScrollableScrollPhysics()
          : const ScrollPhysics(),
      child: Column(
        children: [
          asyncValues.when(
            data: (data) {
              return data!.isEmpty
                  ? emptyContent(title: 'Oop, No post for today yet!!!')
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final post = data[index];
                        return renderItem(post);
                      },
                    );
            },
            error: (error, stackTrace) {
              debugPrint('Error Post New Feeds: ${error.toString()}');
              String errorMessage = error.toString();
              if (errorMessage.length > 100) {
                errorMessage = errorMessage.substring(0, 100);
              }
              return emptyContent(title: errorMessage);
            },
            loading: () {
              return _build_loading();
            },
          ),
          renderLoading(),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget _build_loading() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dummyData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Sizes.xs),
            child: PostPanel(
              post: Post(),
              url: "loading",
              twoFingersOn: () => setState(() => blockScroll = true),
              twoFingersOff: () => Future.delayed(
                PinchZoomReleaseUnzoomWidget.defaultResetDuration,
                () => setState(() => blockScroll = false),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget renderItem(Post post) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.xs),
      child: PostPanel(
        post: post,
        isComment: true,
        key: ValueKey(post.postId),
        // url: "loading",

        twoFingersOn: () => setState(() => blockScroll = true),
        twoFingersOff: () => Future.delayed(
          PinchZoomReleaseUnzoomWidget.defaultResetDuration,
          () => setState(() => blockScroll = false),
        ),
      ),
    );
  }

  // void _scrollListener() {
  //   final scrollController = ref.read(homeScrollControllerProvider);
  //   final maxScroll = scrollController.position.maxScrollExtent;
  //   final currentScroll = scrollController.position.pixels;

  //   if (currentScroll >= maxScroll * 0.95) {
  //     // Load when scrolled 50% down
  //     // debugPrint("Scrolled halfway, loading more...");
  //     ref.read(socialPostoneControllerProvider.notifier).loadNextPage();
  //   }
  // }
  void _scrollListener() {
    final scrollController = ref.read(homeScrollControllerProvider);
    if (scrollController.position.atEdge) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        debugPrint("Reach bottom");
        ref.read(socialPostoneControllerProvider.notifier).loadNextPage();
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  Widget renderLoading() {
    final loadingPaging = ref.watch(postLoadingPagingProvider);
    return loadingPaging
        ? Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: appLoadingSpinner(),
          )
        : const SizedBox();
  }
}
