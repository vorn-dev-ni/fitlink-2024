import 'dart:io';
import 'package:chewie/chewie.dart';
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
            looping: false,
            autoInitialize: true,
            allowFullScreen: false,
            showControlsOnInitialize: false,
            showControls: true,
            allowMuting: true,
            draggableProgressBar: true,

            aspectRatio: _videoController.value.aspectRatio,
            allowPlaybackSpeedChanging: false,
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
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.backgroundLight,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            buildFullScreen(
              controller: _chewieController,
              child: Chewie(
                controller: _chewieController,
              ),
            ),
          ],
        ));
  }

  Widget buildFullScreen(
      {required ChewieController controller, required child}) {
    final size = controller.videoPlayerController.value.size;
    final width = size.width;
    final height = size.height;
    // controller.videoPlayerController.play();

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        child: child,
        width: width,
        height: height,
      ),
    );
  }
}
