import 'dart:async';
import 'dart:io';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:demo/features/home/controller/video/tiktok_video_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoListingPlayer extends ConsumerStatefulWidget {
  final String? videoUrl;
  final bool? paging;
  final File? videoFile;
  final String? videoId;
  final VideoPlayerController? videoPlayerController;

  const VideoListingPlayer({
    Key? key,
    this.videoUrl,
    this.videoFile,
    this.videoId,
    this.videoPlayerController,
    this.paging = false,
  }) : super(key: key);

  @override
  _VideoPlayerTikTokState createState() => _VideoPlayerTikTokState();
}

class _VideoPlayerTikTokState extends ConsumerState<VideoListingPlayer>
    with WidgetsBindingObserver {
  VideoPlayerController? _videoPlayerController;
  bool _isPlaying = false;
  bool _isSeeking = false;
  bool _isBuffering = false;
  bool _manualPause = false;
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

  Future<void> initializeplayer() async {
    if (_videoPlayerController != null) return;

    if (widget.videoPlayerController != null) {
      _videoPlayerController = widget.videoPlayerController;
    }

    await _videoPlayerController?.initialize();
    _videoPlayerController?.setLooping(true);
    _videoPlayerController?.addListener(_videoListener);

    if (mounted) {
      setState(() {
        _videoDuration =
            _videoPlayerController!.value.duration.inSeconds.toDouble();

        if (widget.paging == false && !_manualPause) {
          _videoPlayerController?.play();
          _isPlaying = true;
        }
      });
    }
  }

  // Future<File> _cacheVideo(String url) async {
  //   final cacheManager = DefaultCacheManager();
  //   final file = await cacheManager.getSingleFile(url);
  //   return file;
  // }

  void _togglePlayPause() {
    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) return;
    if (_isPlaying) {
      _videoPlayerController?.pause();
      _manualPause = true;
    } else {
      _videoPlayerController?.play();
      _manualPause = false;
    }
    setState(() {
      _isPlaying = _videoPlayerController!.value.isPlaying;
    });
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
    addViewCountWithDebounce(widget.videoId);
    initializeplayer();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (widget.videoPlayerController == null) {
      _videoPlayerController?.removeListener(_videoListener);
      _videoPlayerController?.dispose();
    }
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _videoPlayerController?.value.isInitialized == true
        ? GestureDetector(
            onTap: _togglePlayPause,
            child: VisibilityDetector(
              key: ValueKey(widget.videoId ?? widget.videoUrl ?? 'video'),
              onVisibilityChanged: (VisibilityInfo info) {
                if (info.visibleFraction >= 0.8) {
                  _videoPlayerController?.play();
                  _isPlaying = true;
                } else {
                  _videoPlayerController?.pause();
                }
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  fullScreen(_videoPlayerController!),
                  if (!_isBuffering && !_isSeeking && !_isPlaying)
                    renderPausePlay(),
                  if (_isBuffering || _isSeeking)
                    const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primaryColor)),
                  renderProgressVideo(),
                ],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(color: AppColors.secondaryColor));
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
      scaleY: DeviceUtils.isAndroid() ? 1 : 1,
      scaleX: DeviceUtils.isAndroid() ? 1 : 1,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
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

  void _videoListener() {
    if (!mounted) return;
    final isBuffering = _videoPlayerController!.value.isBuffering;
    final currentPos = _videoPlayerController!.value.position.inSeconds;

    setState(() {
      _isBuffering = isBuffering;
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
