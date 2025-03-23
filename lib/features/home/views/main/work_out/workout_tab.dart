import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/features/home/controller/video/comment/comment_video_controller.dart';
import 'package:demo/features/home/controller/video/tiktok_video_controller.dart';
import 'package:demo/features/home/views/main/work_out/comment_listing_tiktok.dart';
import 'package:demo/features/home/views/main/work_out/tiktok_video_item.dart';
import 'package:demo/features/home/views/single_profile/views/video_player_custom.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class WorkoutTab extends ConsumerStatefulWidget {
  @override
  _WorkoutTabState createState() => _WorkoutTabState();
}

class _WorkoutTabState extends ConsumerState<WorkoutTab>
    with WidgetsBindingObserver {
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  bool isSliding = false;
  bool isPause = false;
  PageController? pageController;
  bool isFetchingMore = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    _pageController.addListener(_onPageScroll);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageScroll() {
    if (_pageController.position.haveDimensions) {
      int currentPage = _pageController.page!.toInt();
      _onPageChanged(currentPage);
    }
  }

  void _onPageChanged(int index) async {
    if (index >= 1 && isFetchingMore == false) {
      setState(() {
        isFetchingMore = true;
      });

      final data =
          await ref.read(tiktokVideoControllerProvider.notifier).loadMore();

      if (data != null) {
        setState(() {
          isFetchingMore = false;
        });
      }
    }
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
              child: Stack(
                children: [
                  Container(
                    color: AppColors.backgroundDark,
                    child: PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: data.length,
                      pageSnapping: true,
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        final video = data[index];
                        return VisibilityDetector(
                          key: ValueKey(video.documentID),
                          onVisibilityChanged: (visibilityInfo) async {
                            if (visibilityInfo.visibleFraction >= 0.7) {
                              if (!video.videoplayer!.value.isPlaying) {
                                video.videoplayer!.play();
                              }
                            } else {
                              if (video.videoplayer!.value.isPlaying) {
                                video.videoplayer!.pause();
                              }
                            }
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              VideoPlayerTikTok(
                                  paging: true,
                                  videoId: video.documentID,
                                  videoPlayerController: video.videoplayer),
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
                              if (index >= data.length - 1)
                                renderLoadingBottom()
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
      return Skeletonizer(
        enabled: true,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 64),
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 1,
            onPageChanged: (index) {},
            itemBuilder: (context, index) {
              return Container(
                color: const Color.fromARGB(255, 188, 195, 204),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Skeletonizer(
                      ignoreContainers: true,
                      child: VideoTiktokItem(
                        img: '',
                        date: Timestamp.now(),
                        // tags: null,
                        onCommentPressed: () {},
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
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
