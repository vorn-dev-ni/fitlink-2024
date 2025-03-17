import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerTikTok extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerTikTok({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerTikTokState createState() => _VideoPlayerTikTokState();
}

class _VideoPlayerTikTokState extends State<VideoPlayerTikTok> {
  late VideoPlayerController _videoPlayerController;
  bool _isPlaying = true;
  bool _isSeeking = false;
  bool _isBuffering = false;
  bool _isInitialized = false;
  double _currentPosition = 0.0;
  double _videoDuration = 0.0;
  double _bufferedPosition = 0.0;

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _videoPlayerController.pause();
      } else {
        _videoPlayerController.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> _initializeVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then(
            (value) {
              if (mounted) {
                setState(() {
                  _isInitialized = true;
                });
              }
            },
          )
          ..addListener(() {
            setState(() {});
            if (!mounted) return;
            final isCurrentlyBuffering =
                _videoPlayerController.value.isBuffering;
            final currentPos = _videoPlayerController.value.position.inSeconds;
            setState(() {
              _isBuffering = isCurrentlyBuffering;
              if (_videoPlayerController.value.isInitialized) {
                _currentPosition = currentPos.toDouble();
                _videoDuration =
                    _videoPlayerController.value.duration.inSeconds.toDouble();

                if (_videoPlayerController.value.buffered.isNotEmpty) {
                  _bufferedPosition = _videoPlayerController
                      .value.buffered.last.end.inSeconds
                      .toDouble();
                }
              }
            });
          });
    _videoPlayerController.setLooping(true);

    _videoPlayerController.play();
  }

  void _seekTo(Duration value) async {
    _videoPlayerController.setVolume(0);
    setState(() {
      _isSeeking = true;
      _isPlaying = false;
    });

    await _videoPlayerController.play();
    await _videoPlayerController.seekTo(value);
    await Future.delayed(const Duration(milliseconds: 100));
    await _videoPlayerController.play();
    await _videoPlayerController.setVolume(1);
    setState(() {
      _isSeeking = false;
      _isPlaying = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: _isInitialized
          ? GestureDetector(
              onTap: _togglePlayPause,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AspectRatio(
                    aspectRatio: 9 / 16,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                  if (_isBuffering == false &&
                      _isSeeking == false &&
                      !_isPlaying)
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        // padding: const EdgeInsets.all(20),
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
                  renderButtonClose(context),

                  // Buffering indicator
                  if (_isBuffering || _isSeeking)
                    Center(child: appLoadingSpinner()),
                  // Custom Progress Bar
                  renderProgressVideo(),
                ],
              ),
            )
          : Center(child: appLoadingSpinner()),
    );
  }

  Widget renderProgressVideo() {
    return Positioned(
      bottom: 60,
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
}
