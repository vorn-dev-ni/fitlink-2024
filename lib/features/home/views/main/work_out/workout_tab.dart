import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/features/home/controller/video/comment/comment_video_controller.dart';
import 'package:demo/features/home/controller/video/tiktok_video_controller.dart';
import 'package:demo/features/home/views/main/work_out/comment_listing_tiktok.dart';
import 'package:demo/features/home/views/main/work_out/social_like_comment_item.dart';
import 'package:demo/features/home/views/main/work_out/tiktok_video_item.dart';
import 'package:demo/features/home/views/main/work_out/video_list_player.dart';
import 'package:demo/features/home/views/single_profile/views/video_player_custom.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:sizer/sizer.dart';

class WorkoutTab extends ConsumerStatefulWidget {
  @override
  _WorkoutTabState createState() => _WorkoutTabState();
}

class _WorkoutTabState extends ConsumerState<WorkoutTab>
    with WidgetsBindingObserver {
  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  bool isSliding = false;
  bool isPause = false;
  PageController? pageController;
  bool isFetchingMore = false;
  int _currentIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;

      if (newPage != _currentIndex) {
        _currentIndex = newPage;
        _handleVideoPlayback(
          newPage,
        );
      }
    });

    super.initState();
  }

  void _handleVideoPlayback(int index) async {
    final controller = ref.read(tiktokVideoControllerProvider.notifier);
    final videoList = ref.read(tiktokVideoControllerProvider).value ?? [];

    if (index < 0 || index >= videoList.length) return;

    final aheadIndex = index + 2;
    if (aheadIndex < videoList.length) {
      await ref
          .read(tiktokVideoControllerProvider.notifier)
          .preloadVideo(aheadIndex);
    }

    final nextIndex = index + 1;
    if (nextIndex >= videoList.length - 1 && !isFetchingMore) {
      setState(() => isFetchingMore = true);
      final newVideos = await controller.loadMore();
      if (newVideos != null) {
        setState(() => isFetchingMore = false);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videos = ref.watch(tiktokVideoControllerProvider);

    return videos.when(data: (data) {
      return data.isEmpty
          ? Center(child: emptyContent(title: 'No Video in FYP.'))
          : SafeArea(
              top: false,
              bottom: false,
              child: Container(
                color: AppColors.backgroundDark,
                child: PreloadPageView.builder(
                  pageSnapping: true,
                  scrollDirection: Axis.vertical,
                  controller: PreloadPageController(),
                  itemCount: data.length,
                  preloadPagesCount: 2,
                  itemBuilder: (context, index) {
                    final video = data[index];
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        // VideoPlayer( video.),
                        VideoListingPlayer(
                          videoUrl: video.videoUrl,
                          paging: true,
                          videoId: video.documentID ?? "",
                          videoPlayerController: video.videoplayer,
                        ),
                        VideoTiktokItem(
                          caption: video.caption,
                          videoId: video.documentID,
                          commentCount: video.commentCount,
                          likeCount: video.likeCount,
                          isUserliked: video.isUserliked,
                          shareCount: video.likeCount,
                          date: video.createdAt ?? Timestamp.now(),
                          tags: video.tag ?? [],
                          userdata: video.userRef,
                          img: video.thumbnailUrl ?? "",
                          onCommentPressed: () {
                            _showCommentBottomSheet(
                              video.userRef?.id ?? "",
                              video.documentID ?? "",
                            );
                          },
                        ),
                        if (index >= data.length - 1) renderLoadingBottom()
                      ],
                    );
                  },
                ),
              ),
            );
    }, error: (error, stackTrace) {
      debugPrint(error.toString());
      if (error.toString().length >= 100) {
        return Center(
            child: emptyContent(title: error.toString().substring(0, 150)));
      }
      return Center(child: emptyContent(title: error.toString()));
    }, loading: () {
      return renderLoading();
    });
  }

  Widget renderLoading() {
    return Skeletonizer(
        enabled: true,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Container(
                color: const Color.fromARGB(255, 188, 195, 204),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                        bottom: 22.h,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipOval(
                              child: Assets.app.defaultAvatar.image(
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text('This is an example...'),
                            const Text('This...'),
                          ],
                        )),
                    Positioned(
                      right: 16,
                      bottom: 0,
                      child: SocialLikeCommentItem(
                          videoId: '',
                          onShare: () {},
                          isLiked: false,
                          onCommentPressed: () {},
                          data: VideoTikTok()),
                    )
                  ],
                ))));
  }

  Widget buildFullScreen({
    required VideoPlayerController controller,
    required child,
  }) {
    final size = controller.value.size;
    final videoWidth = size.width;
    final videoHeight = size.height;

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: videoWidth,
        height: videoHeight,
        child: child,
      ),
    );
  }

  void _showCommentBottomSheet(String userId, String videoId) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      isDismissible: true,
      backgroundColor: AppColors.backgroundLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      enableDrag: true,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final commentAsync =
                ref.watch(tiktokCommentControllerProvider(videoId));
            return commentAsync.when(
              data: (data) {
                return CommentsSection(
                  videoId: videoId,
                  receiverID: userId,
                  data: data,
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text('Error: $error'),
                );
              },
              loading: () {
                return Skeletonizer(
                  child: CommentsSection(
                    videoId: videoId,
                    receiverID: '',
                    data: generateDummyComments,
                  ),
                );
              },
            );
          },
        );
      },
    ).whenComplete(() {});
  }

  Widget renderLoadingBottom() {
    return isFetchingMore
        ? Positioned(bottom: 100, left: 0, right: 0, child: appLoadingSpinner())
        : const SizedBox();
  }
}
