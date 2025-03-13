import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

class VideoItem extends StatefulWidget {
  final Map<String, dynamic> video;

  const VideoItem({Key? key, required this.video}) : super(key: key);

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HelpersUtils.navigatorState(context)
            .pushNamed(AppPage.singleVideoTiktok);
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.video['thumbnail'],
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Icon(
                Icons.play_circle_fill,
                color: Colors.white.withOpacity(0.8),
                size: 50,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: Text(widget.video['caption'],
                      maxLines: 2,
                      style: AppTextTheme.lightTextTheme.bodySmall
                          ?.copyWith(color: AppColors.backgroundLight)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      widget.video['likes'],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.visibility, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      widget.video['views'],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
