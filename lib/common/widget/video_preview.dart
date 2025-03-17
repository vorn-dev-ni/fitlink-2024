import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({Key? key}) : super(key: key);

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;
  String? videoPath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as String?;
      if (args != null) {
        setState(() {
          videoPath = args;
          _videoController = VideoPlayerController.file(File(videoPath!))
            ..initialize().then((_) {
              setState(() {
                _videoController.play();
              });
            });

          _chewieController = ChewieController(
            videoPlayerController: _videoController,
            autoPlay: true,
            bufferingBuilder: (context) => appLoadingSpinner(),
            aspectRatio: 0.55,
            looping: true,
            showControls: true,
            draggableProgressBar: true,
            allowFullScreen: false,
            allowedScreenSleep: false,
            zoomAndPan: true,
            allowMuting: false,
            controlsSafeAreaMinimum:
                const EdgeInsets.only(bottom: 30, left: 7, right: 7),
            maxScale: 2,
            allowPlaybackSpeedChanging: false,
            autoInitialize: true,
            showControlsOnInitialize: false,
            showOptions: false,
            // progressIndicatorDelay: null,
            errorBuilder: (context, errorMessage) {
              return emptyContent(title: errorMessage);
            },
            cupertinoProgressColors: ChewieProgressColors(
                bufferedColor: const Color.fromARGB(255, 154, 158, 163)),
            materialProgressColors: ChewieProgressColors(
                bufferedColor: const Color.fromARGB(255, 154, 158, 163)),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (videoPath == null) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: Text(
            "No video selected",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    if (!_videoController.value.isInitialized) {
      return Container(
        color: AppColors.backgroundDark,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
        extendBody: false,
        extendBodyBehindAppBar: false,
        backgroundColor: AppColors.backgroundDark,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: buildFullScreen(
                controller: _chewieController!,
                child: Chewie(controller: _chewieController!),
              ),
            ),
          ],
        ));
  }

  Widget buildVideoPlayer() {
    if (_chewieController == null || !_videoController.value.isInitialized) {
      return Container();
    }

    final chewieController = _chewieController;

    return buildFullScreen(
      controller: chewieController,
      child: Chewie(controller: chewieController),
    );
  }

  Widget buildFullScreen(
      {required ChewieController controller, required child}) {
    final size = controller.videoPlayerController.value.size;
    final videoWidth = size.width;
    final videoHeight = size.height;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final widthScale = screenWidth / videoWidth;
    final heightScale = screenHeight / videoHeight;

    final scaleFactor = widthScale > heightScale ? widthScale : heightScale;

    return Transform.scale(
      scale: scaleFactor,
      child: SizedBox(
        width: videoWidth,
        height: videoHeight,
        child: child,
      ),
    );
  }
}
