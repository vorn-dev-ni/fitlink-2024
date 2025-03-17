import 'dart:async';
import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/features/home/controller/video/comment/comment_video_controller.dart';
import 'package:demo/features/home/controller/video/single_video_controller.dart';
import 'package:demo/features/home/controller/video/tiktok_video_controller.dart';
import 'package:demo/features/home/views/main/work_out/comment_listing_tiktok.dart';
import 'package:demo/features/home/views/main/work_out/tiktok_video_item.dart';
import 'package:demo/features/home/views/single_profile/views/video_player_custom.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainSingleVideo extends ConsumerStatefulWidget {
  final String videoId;

  const MainSingleVideo({
    Key? key,
    required this.videoId, // Accept the videoId
  }) : super(key: key);

  @override
  ConsumerState<MainSingleVideo> createState() => _MainSingleVideoState();
}

class _MainSingleVideoState extends ConsumerState<MainSingleVideo> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // _initializeVideoPlayer();
  }

  void addViewCountWithDebounce(String videoId) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(tiktokVideoControllerProvider.notifier).trackViewCount(videoId);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoAsync = ref.watch(singleVideoControllerProvider(widget.videoId));
    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.backgroundDark,
      body: videoAsync.when(
        data: (data) {
          return Stack(
            children: [
              VideoPlayerTikTok(videoUrl: data?.videoUrl ?? ""),
              VideoTiktokItem(
                caption: data?.caption ?? "",
                videoId: widget.videoId,
                userdata: data!.userRef,
                commentCount: data.commentCount,
                img: data.thumbnailUrl ?? "",
                onCommentPressed: () {
                  _showCommentBottomSheet(widget.videoId);
                },
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          return const Text('Error loading video');
        },
        loading: () => Skeletonizer(
          child: Stack(
            fit: StackFit.expand,
            children: [
              buildVideoPlayer(),
              VideoTiktokItem(
                caption: 'Loading...',
                videoId: widget.videoId,
                commentCount: 0,
                img: '',
                onCommentPressed: () {
                  _showCommentBottomSheet(widget.videoId);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVideoPlayer() {
    return SizedBox(
      width: 100.w,
      height: 100.h,
    );
  }

  Widget buildFullScreen(
      {required ChewieController controller, required child}) {
    final size = controller.videoPlayerController.value.size;
    final videoWidth = size.width;
    final videoHeight = size.height;

    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    // final widthScale = screenWidth / videoWidth;
    // final heightScale = screenHeight / videoHeight;

    // final scaleFactor = widthScale > heightScale ? widthScale : heightScale;

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: videoWidth,
        height: videoHeight,
        child: child,
      ),
    );
  }

  void _showCommentBottomSheet(String videoId) {
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
                return CommentsSection(videoId: videoId, data: data);
              },
              error: (error, stackTrace) {
                return Center(child: Text('Error: $error'));
              },
              loading: () {
                return Skeletonizer(
                    child: CommentsSection(
                        videoId: videoId, data: generateDummyComments));
              },
            );
          },
        );
      },
    );
  }
}
