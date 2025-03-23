import 'dart:io';
import 'package:demo/features/home/views/single_profile/views/video_player_custom.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  @override
  _VideoPreviewScreenState createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreview> {
  late VideoPlayerController _controller;
  late String videoPath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    videoPath = ModalRoute.of(context)?.settings.arguments as String;
    _controller = VideoPlayerController.file(File(videoPath));
    initVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: VideoPlayerTikTok(
          videoPlayerController: _controller,
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void initVideo() async {
    await _controller.initialize();
  }
}
