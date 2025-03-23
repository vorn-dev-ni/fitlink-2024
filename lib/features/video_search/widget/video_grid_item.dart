import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/features/home/controller/video/single_video_controller.dart';
import 'package:demo/features/home/views/single_video/main_single_video.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoItem extends ConsumerStatefulWidget {
  final VideoTikTok video;

  const VideoItem({Key? key, required this.video}) : super(key: key);

  @override
  ConsumerState<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends ConsumerState<VideoItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HelpersUtils.navigatorState(context).push(MaterialPageRoute(
          builder: (context) {
            return MainSingleVideo(videoId: widget.video.documentID ?? "");
          },
        ));
      },
      child: Stack(
        children: [
          widget.video.thumbnailUrl == ""
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Assets.app.defaultAvatar.image(
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FancyShimmerImage(
                    imageUrl: widget.video.thumbnailUrl ?? "",
                    width: double.infinity,
                    height: double.infinity,
                    boxFit: BoxFit.cover,
                  ),
                ),
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.backgroundDark.withOpacity(0.5),
            ),
          )),
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
            bottom: 15,
            left: 10,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 180,
                  child: Text('${widget.video.caption}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.lightTextTheme.bodySmall
                          ?.copyWith(color: AppColors.backgroundLight)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.video.likeCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.visibility, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.video.viewCount}',
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
