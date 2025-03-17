import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/core/riverpod/navigation_state.dart';
import 'package:demo/features/home/controller/video/comment/comment_video_controller.dart';
import 'package:demo/features/home/controller/video/tiktok_video_controller.dart';
import 'package:demo/features/home/views/main/work_out/comment_listing_tiktok.dart';
import 'package:demo/features/home/views/main/work_out/tiktok_video_item.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';

class WorkoutTab extends ConsumerStatefulWidget {
  @override
  _WorkoutTabState createState() => _WorkoutTabState();
}

class _WorkoutTabState extends ConsumerState<WorkoutTab>
    with WidgetsBindingObserver {
  List<String> videoUrls = [
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
  ];
  bool _isPaused = false;
  List<VideoPlayerController> _videoControllers = [];
  int _stateVideoIndex = 0;
  bool isSliding = false;
  bool isPause = false;

  Future<void> _initializeVideos() async {
    final videos = await ref.read(tiktokVideoControllerProvider.future);

    if (videos.isNotEmpty) {
      _initializeVideoControllers(videos);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _initializeVideos();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeVideoControllers(List<VideoTikTok> videos) async {
    List<VideoPlayerController> videoControllers = videos.map((video) {
      return VideoPlayerController.networkUrl(Uri.parse(video.videoUrl ?? ""));
    }).toList();

    for (var controller in videoControllers) {
      controller.initialize().then(
        (value) {
          setState(() {});
        },
      );
      controller.setLooping(true);
      controller.addListener(() {});
    }

    // await Future.wait(
    //   videoControllers.map((controller) async {
    //     await controller.initialize();

    //     setState(() {});
    //   }),
    // );

    setState(() {
      _videoControllers = videoControllers;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // _pauseCurrentVideo(_stateVideoIndex);
    } else if (state == AppLifecycleState.resumed) {
      // _playVideo(_stateVideoIndex, "");
    }
  }

  void _updateStateVideoIndex(int index) {
    setState(() {
      _stateVideoIndex = index;
    });
  }

  void _pauseCurrentVideo(int index) {
    if (_videoControllers.isNotEmpty) {
      final controller = _videoControllers[index];
      if (isPause) {
        controller.pause();
      } else {
        controller.play();
      }
      setState(() {
        isPause = !isPause;
      });
    }
  }

  void _playVideo(int stateIndex, String docId) {
    if (_videoControllers.isNotEmpty) {
      final controller = _videoControllers[stateIndex];
      // controller.play();
      addViewCountWithDebounce(docId);
    }
  }

  Timer? _debounce;
  void addViewCountWithDebounce(String videoId) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(tiktokVideoControllerProvider.notifier).trackViewCount(videoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationStateProvider) ?? 0;
    if (currentIndex != 3) {
      _pauseCurrentVideo(_stateVideoIndex);
    }
    final videos = ref.watch(tiktokVideoControllerProvider);
    final currenIndex = ref.watch(navigationStateProvider);
    if (currenIndex != 3 && _videoControllers.isNotEmpty) {
      _videoControllers[_stateVideoIndex].pause();
    }

    if (currenIndex == 3 && _videoControllers.isNotEmpty) {
      _videoControllers[_stateVideoIndex].play();
    }
    return videos.when(
      data: (data) {
        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: data.length,
          pageSnapping: true,
          onPageChanged: (index) {
            debugPrint("Change to index $index");

            if (_stateVideoIndex != index && index < data.length) {
              _videoControllers[_stateVideoIndex].pause();
              _videoControllers[index].play();
            }

            if (index < data.length) _updateStateVideoIndex(index);
          },
          itemBuilder: (context, index) {
            final video = data[index];
            return Stack(
              fit: StackFit.expand,
              children: [
                if (_videoControllers.isNotEmpty)
                  CustomVideo(
                      videoIndex: index, controller: _videoControllers[index]),
                VideoTiktokItem(
                  caption: video.caption,
                  videoId: video.documentID,
                  commentCount: video.commentCount,
                  likeCount: video.likeCount,
                  shareCount: video.likeCount,
                  userdata: video.userRef,
                  img: video.thumbnailUrl ?? "",
                  onCommentPressed: () {
                    _showCommentBottomSheet(video.documentID ?? "");
                  },
                ),
              ],
            );
          },
        );
      },
      error: (error, stackTrace) => emptyContent(title: error.toString()),
      loading: () => Skeletonizer(
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
                        onCommentPressed: () {
                          _showCommentBottomSheet('');
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildVideoPlayer(int index) {
    if (_videoControllers.isEmpty || index >= _videoControllers.length) {
      return Container();
    }
    return buildFullScreen(
      controller: _videoControllers[index],
      child: VideoPlayer(_videoControllers[index]),
    );
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

  void _showCommentBottomSheet(String videoId) async {
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
}

class CustomVideo extends StatefulWidget {
  final int videoIndex;
  final VideoPlayerController controller;

  const CustomVideo({
    Key? key,
    required this.videoIndex,
    required this.controller,
  }) : super(key: key);

  @override
  _CustomVideoState createState() => _CustomVideoState();
}

class _CustomVideoState extends State<CustomVideo> {
  bool _isPlaying = true;
  bool _isSeeking = false;
  bool _isBuffering = false;
  double _currentPosition = 0.0;
  double _videoDuration = 0.0;
  double _bufferedPosition = 0.0;

  @override
  void initState() {
    super.initState();
    widget.controller.play();

    widget.controller.addListener(() {
      if (mounted) {
        setState(() {
          _isBuffering = widget.controller.value.isBuffering;
          _currentPosition =
              widget.controller.value.position.inSeconds.toDouble();
          _videoDuration =
              widget.controller.value.duration.inSeconds.toDouble();

          if (widget.controller.value.buffered.isNotEmpty) {
            _bufferedPosition =
                widget.controller.value.buffered.last.end.inSeconds.toDouble();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    widget.controller.pause();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        widget.controller.pause();
      } else {
        widget.controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> _seekTo(Duration value) async {
    widget.controller.setVolume(0);
    setState(() {
      _isSeeking = true;
      _isPlaying = false;
    });

    await widget.controller.seekTo(value);
    await widget.controller.play();
    widget.controller.setVolume(1);

    setState(() {
      _isSeeking = false;
      _isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: 9 / 16,
            child: VideoPlayer(widget.controller),
          ),
          if (!_isBuffering && !_isSeeking && !_isPlaying)
            Center(
              child: Container(
                alignment: Alignment.center,
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          // Progress Bar
          Positioned(
            bottom: 20,
            left: 14,
            right: 14,
            child: ProgressBar(
              progress: Duration(seconds: _currentPosition.toInt()),
              buffered: Duration(seconds: _bufferedPosition.toInt()),
              total: Duration(seconds: _videoDuration.toInt()),
              progressBarColor: Colors.red,
              timeLabelTextStyle: AppTextTheme.lightTextTheme.bodyMedium
                  ?.copyWith(color: AppColors.backgroundLight),
              baseBarColor: Colors.white.withOpacity(0.24),
              bufferedBarColor: Colors.white.withOpacity(0.24),
              thumbColor: Colors.white,
              barHeight: 3.0,
              thumbRadius: 5.0,
              onSeek: (value) {
                _seekTo(value);
              },
            ),
          ),
          if (_isBuffering || _isSeeking)
            Center(child: appLoadingSpinner()), // Buffering Spinner
        ],
      ),
    );
  }
}
