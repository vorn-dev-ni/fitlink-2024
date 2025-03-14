import 'package:chewie/chewie.dart';
import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/core/riverpod/navigation_state.dart';
import 'package:demo/features/home/views/main/work_out/tiktok_comment.dart';
import 'package:demo/features/home/views/main/work_out/tiktok_video_item.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';

class WorkoutTab extends ConsumerStatefulWidget {
  const WorkoutTab({super.key});

  @override
  ConsumerState<WorkoutTab> createState() => _WorkoutTabState();
}

class _WorkoutTabState extends ConsumerState<WorkoutTab>
    with AutomaticKeepAliveClientMixin<WorkoutTab>, WidgetsBindingObserver {
  List<String> videoUrls = [
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
  ];

  List<ChewieController> _chewieControllers = [];
  bool _isLoading = true;
  int _stateVideoIndex = 0;
  bool isSliding = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeVideoControllers();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (var controller in _chewieControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _initializeVideoControllers() async {
    List<VideoPlayerController> videoControllers = videoUrls.map((url) {
      return VideoPlayerController.networkUrl(Uri.parse(url));
    }).toList();

    await Future.wait(
        videoControllers.map((controller) => controller.initialize()));

    List<ChewieController> chewieControllers =
        videoControllers.map((controller) {
      return ChewieController(
        videoPlayerController: controller,
        autoPlay: false,
        looping: true,
        aspectRatio: controller.value.aspectRatio,
        autoInitialize: true,
        showControlsOnInitialize: false,
        zoomAndPan: true,
        controlsSafeAreaMinimum: EdgeInsets.zero,
        allowMuting: true,
        bufferingBuilder: (context) => appLoadingSpinner(),
        allowFullScreen: false,

        startAt: const Duration(seconds: 0),
        // hideControlsTimer: const Duration(seconds: 0),
        showControls: false,
        draggableProgressBar: true,
        customControls: CustomVideoControls(videoPlayerController: controller),
        // progressIndicatorDelay: null,
        errorBuilder: (context, errorMessage) {
          return emptyContent(title: errorMessage);
        },
        cupertinoProgressColors: ChewieProgressColors(
            bufferedColor: const Color.fromARGB(255, 154, 158, 163)),
        materialProgressColors: ChewieProgressColors(
            bufferedColor: const Color.fromARGB(255, 154, 158, 163)),
        showOptions: false,
      );
    }).toList();

    setState(() {
      _chewieControllers = chewieControllers;
      _isLoading = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pauseCurrentVideo(_stateVideoIndex);
    } else if (state == AppLifecycleState.resumed) {
      _playVideo(_stateVideoIndex);
    }
  }

  void _updateStateVideoIndex(int index) {
    setState(() {
      _stateVideoIndex = index;
    });
  }

  void _pauseCurrentVideo(index) {
    if (_chewieControllers.isNotEmpty) {
      final controller = _chewieControllers[index].videoPlayerController;
      controller.pause();
    }
  }

  void _resumeAllVideos() {
    for (var controller in _chewieControllers) {
      controller.videoPlayerController.play();
    }
  }

  void _playVideo(int stateIndex) {
    if (_chewieControllers.isNotEmpty) {
      final controller = _chewieControllers[stateIndex].videoPlayerController;
      controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationStateProvider) ?? 0;
    if (currentIndex != 3) {
      _pauseCurrentVideo(_stateVideoIndex);
    }

    if (currentIndex == 3) {
      _playVideo(_stateVideoIndex);
    }
    return Scaffold(
      extendBody: false,
      body: _isLoading
          ? Skeletonizer(
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
                              onCommentPressed: _showCommentBottomSheet,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ) // Show loading indicator
          : Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: videoUrls.length,
                onPageChanged: (index) {
                  _chewieControllers[index].videoPlayerController.play();

                  _updateStateVideoIndex(index);
                  // Fetch more videos when the user is 2 videos away from the end
                  if (index >= videoUrls.length - 2) {
                    // _fetchMoreVideos();
                  }
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        buildVideoPlayer(index),
                        VideoTiktokItem(
                          img: '',
                          onCommentPressed: _showCommentBottomSheet,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget buildVideoPlayer(int index) {
    return buildFullScreen(
        controller: _chewieControllers[index],
        child: Chewie(
          key: ValueKey(index),
          controller: _chewieControllers[index],
        ));
  }

  Widget buildFullScreen(
      {required ChewieController controller, required child}) {
    final size = controller.videoPlayerController.value.size;
    final width = size.width;
    final height = size.height;

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        child: child,
        width: width,
        height: height,
      ),
    );
  }

  void _showCommentBottomSheet() {
    TextEditingController _commentController = TextEditingController();
    FocusNode _commentFocusNode = FocusNode();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.backgroundLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      enableDrag: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              snap: true,
              snapSizes: const [0.5, 0.7, 0.9],
              expand: false,
              builder: (context, controller) {
                return GestureDetector(
                  onTap: () {
                    HelpersUtils.navigatorState(context)
                        .pushNamed(AppPage.NOTFOUND);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 16,
                      right: 16,
                      top: 0,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Comments',
                          style: AppTextTheme.lightTextTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: AppColors.neutralColor),
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: _buildComment('User Comment $index'),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  focusNode: _commentFocusNode,
                                  style: AppTextTheme.lightTextTheme.bodyMedium
                                      ?.copyWith(
                                          color: AppColors.backgroundDark),
                                  decoration: InputDecoration(
                                    hintStyle: AppTextTheme
                                        .lightTextTheme.bodyMedium
                                        ?.copyWith(
                                            color: const Color.fromARGB(
                                                255, 119, 114, 114)),
                                    hintText: "Write a comment...",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppColors.backgroundLight),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppColors.neutralColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 72, 70, 70)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  maxLines: 4,
                                  minLines: 1,
                                  onSubmitted: (text) {
                                    HelpersUtils.navigatorState(context).pop();
                                  },
                                ),
                              ),
                              if (_commentController.text.isNotEmpty)
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.send,
                                      color: AppColors.secondaryColor,
                                    ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildComment(String comment) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TiktokComment(imageUrl: ''));
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomVideoControls extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const CustomVideoControls({Key? key, required this.videoPlayerController})
      : super(key: key);

  @override
  _CustomVideoControlsState createState() => _CustomVideoControlsState();
}

class _CustomVideoControlsState extends State<CustomVideoControls> {
  double _sliderValue = 0.0;
  bool isSliding = false;

  @override
  void initState() {
    super.initState();
    widget.videoPlayerController.addListener(_updateSliderValue);
  }

  @override
  void dispose() {
    widget.videoPlayerController.removeListener(_updateSliderValue);
    super.dispose();
  }

  // Update slider value based on video position
  void _updateSliderValue() {
    if (!mounted || isSliding) return;

    setState(() {
      _sliderValue =
          widget.videoPlayerController.value.position.inSeconds.toDouble();
    });
  }

  // Toggle Play/Pause
  void _togglePlayPause() {
    if (widget.videoPlayerController.value.isPlaying) {
      widget.videoPlayerController.pause();
    } else {
      widget.videoPlayerController.play();
    }
    setState(() {}); // Update the control UI
  }

  @override
  Widget build(BuildContext context) {
    final videoController = widget.videoPlayerController;
    final duration = videoController.value.duration.inSeconds.toDouble();

    return Positioned(
      bottom: 20,
      left: 10,
      right: 10,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Play/Pause Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    videoController.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 36,
                    color: Colors.white,
                  ),
                  onPressed: _togglePlayPause,
                ),
              ],
            ),

            // Video Progress Slider
            Slider(
              value: _sliderValue.clamp(0.0, duration),
              min: 0,
              max: duration,
              activeColor: Colors.red,
              inactiveColor: Colors.white.withOpacity(0.5),
              onChanged: (value) {
                setState(() {
                  isSliding = true;
                  _sliderValue = value;
                });
              },
              onChangeEnd: (value) {
                isSliding = false;
                videoController.seekTo(Duration(seconds: value.toInt()));
              },
            ),

            // Optionally, show the video current time and duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDuration(Duration(seconds: _sliderValue.toInt())),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  formatDuration(Duration(seconds: duration.toInt())),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Format the duration to a MM:SS format
  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
