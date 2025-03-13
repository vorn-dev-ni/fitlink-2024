import 'package:demo/features/video_search/widget/video_grid_item.dart';
import 'package:flutter/material.dart';

class VideoProfile extends StatefulWidget {
  const VideoProfile({super.key});

  @override
  State<VideoProfile> createState() => _VideoProfileState();
}

class _VideoProfileState extends State<VideoProfile> {
  final List<Map<String, dynamic>> videos = List.generate(20, (index) {
    return {
      "thumbnail":
          "https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?q=80&w=3360&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "caption": "Awesome video #$index",
      "likes": (1000 + index * 23).toString(),
      "views": (5000 + index * 57).toString(),
    };
  });
  @override
  Widget build(BuildContext context) {
    return _buildVideoListing();
  }

  Widget _buildVideoListing() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 9 / 16,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return VideoItem(video: videos[index]);
      },
    );
  }
}
