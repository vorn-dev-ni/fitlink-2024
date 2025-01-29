import 'package:flutter/material.dart';

class VideoProfile extends StatefulWidget {
  const VideoProfile({super.key});

  @override
  State<VideoProfile> createState() => _VideoProfileState();
}

class _VideoProfileState extends State<VideoProfile> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Video Profile Tab"));
  }
}
