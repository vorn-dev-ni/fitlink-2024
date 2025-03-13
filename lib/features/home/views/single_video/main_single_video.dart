import 'package:demo/features/home/views/main/work_out/tiktok_video_item.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';

class MainSingleVideo extends StatefulWidget {
  const MainSingleVideo({super.key});

  @override
  State<MainSingleVideo> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainSingleVideo> {
  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          VideoTiktokItem(
            img: '',
            onCommentPressed: _pressComment,
          ),
          Positioned(
            left: 16,
            top: topPadding + 10,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
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
          ),
        ],
      ),
    );
  }

  void _pressComment() {}
}
