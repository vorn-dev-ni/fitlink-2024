import 'dart:async';
import 'dart:io';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:demo/features/home/controller/video/tiktok_video_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerTikTok extends ConsumerStatefulWidget {
  final String? videoUrl;
  final bool? paging;
  final File? videoFile;
  final String? videoId;
  final VideoPlayerController? videoPlayerController;

  const VideoPlayerTikTok(
      {Key? key,
      this.videoUrl,
      this.videoFile,
      this.videoId,
      this.videoPlayerController,
      this.paging = false})
      : super(key: key);

  @override
  _VideoPlayerTikTokState createState() => _VideoPlayerTikTokState();
}

class _VideoPlayerTikTokState extends ConsumerState<VideoPlayerTikTok>
    with WidgetsBindingObserver {
  VideoPlayerController? _videoPlayerController;
  bool _isPlaying = true;
  bool _isSeeking = false;
  bool _isBuffering = false;
  double _currentPosition = 0.0;
  double _videoDuration = 0.0;
  double _bufferedPosition = 0.0;

  Timer? _debounce;
  void addViewCountWithDebounce(String? videoId) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      if (videoId != null) {
        ref
            .read(tiktokVideoControllerProvider.notifier)
            .trackViewCount(videoId);
      }
    });
  }

  Future<void> _initializeVideoPlayer() async {
    if (_videoPlayerController != null) {
      return;
    }

    if (widget.videoPlayerController != null) {
      _videoPlayerController = widget.videoPlayerController;
    } else if (widget.videoFile != null) {
      _videoPlayerController = VideoPlayerController.file(widget.videoFile!)
        ..initialize();
    } else if (widget.videoUrl != null) {
      final file = await _cacheVideo(widget.videoUrl!);
      _videoPlayerController = VideoPlayerController.file(file)..initialize();
    }
    _videoPlayerController?.setLooping(true);

    if (widget.paging == false) {
      _videoPlayerController?.play();
    }

    _videoPlayerController?.addListener(_videoListener);
  }

  Future<File> _cacheVideo(String url) async {
    final cacheManager = DefaultCacheManager();

    final file = await cacheManager.getSingleFile(url);
    return file;
  }

  void _togglePlayPause() {
    if (_videoPlayerController?.value?.isInitialized == false) {
      return;
    }
    if (_isPlaying) {
      _videoPlayerController?.pause();
    } else {
      _videoPlayerController?.play();
    }
  }

  void _seekTo(Duration value) async {
    _videoPlayerController?.setVolume(0);
    setState(() {
      _isSeeking = true;
      _isPlaying = false;
    });

    await _videoPlayerController?.seekTo(value);
    _videoPlayerController?.play();
    _videoPlayerController?.setVolume(1);

    setState(() {
      _isSeeking = false;
      _isPlaying = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    addViewCountWithDebounce(widget.videoId);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _videoPlayerController?.dispose();
    _videoPlayerController?.removeListener(_videoListener);
    _debounce?.cancel();
    // DefaultCacheManager().emptyCache();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_videoPlayerController == null) return;
    if (state == AppLifecycleState.resumed) {
      if (_videoPlayerController!.value.isInitialized &&
          widget.paging == false) {
        // Fluttertoast.showToast(msg: 'play app');
        _videoPlayerController!.play();
      }
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive && widget.paging == false) {
      // Fluttertoast.showToast(msg: 'paused app');
      _videoPlayerController!.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _videoPlayerController?.value.isInitialized != null &&
            _videoPlayerController?.value.isInitialized == true
        ? GestureDetector(
            onTap: _togglePlayPause,
            child: Stack(
              fit: StackFit.expand,
              children: [
                fullScreen(_videoPlayerController!),

                if (_isBuffering == false && _isSeeking == false && !_isPlaying)
                  renderPausePlay(),

                if (widget.paging == false) renderButtonClose(context),

                if (_isBuffering || _isSeeking)
                  const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.backgroundLight)),
                // Custom Progress Bar
                renderProgressVideo(),
              ],
            ),
          )
        : Stack(
            children: [
              if (widget.paging == false) renderButtonClose(context),
              const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.backgroundLight)),
            ],
          );
  }

  Center renderPausePlay() {
    return Center(
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
    );
  }

  Widget fullScreen(VideoPlayerController controller) {
    return Transform.scale(
      scaleX: 1,
      scaleY: 1,
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.size.width,
            height: controller.value.size.height,
            child: AspectRatio(
                aspectRatio: 9 / 16, child: VideoPlayer(controller)),
          ),
        ),
      ),
    );
  }

  Widget renderProgressVideo() {
    final paddingBottom = MediaQuery.of(context).padding.bottom;
    return Positioned(
      bottom: widget.paging == true ? paddingBottom : 60,
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
    );
  }

  Widget renderButtonClose(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;
    return Positioned(
      top: topInset,
      left: 20,
      child: GestureDetector(
        onTap: () {
          HelpersUtils.navigatorState(context).pop();
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _videoListener() {
    final isCurrentlyBuffering = _videoPlayerController!.value.isBuffering;
    final currentPos = _videoPlayerController!.value.position.inSeconds;
    if (!mounted) return;
    setState(() {
      _isBuffering = isCurrentlyBuffering;
      if (_videoPlayerController?.value.isPlaying == true) {
        _isPlaying = true;
      }

      if (_videoPlayerController?.value?.isPlaying == false) {
        _isPlaying = false;
      }

      _currentPosition = currentPos.toDouble();
      _videoDuration =
          _videoPlayerController!.value.duration.inSeconds.toDouble();

      if (_videoPlayerController!.value.buffered.isNotEmpty) {
        _bufferedPosition = _videoPlayerController!
            .value.buffered.last.end.inSeconds
            .toDouble();
      }
    });
  }
}
