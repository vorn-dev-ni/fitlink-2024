import 'dart:ui';

import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class TiktokComment extends StatefulWidget {
  String? imageUrl;
  TiktokComment({
    super.key,
    required this.imageUrl,
  });

  @override
  State<TiktokComment> createState() => _TiktokCommentState();
}

class _TiktokCommentState extends State<TiktokComment> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Ensures a circular shape
            border: Border.all(
              color: const Color.fromARGB(
                  255, 194, 195, 197), // Customize border color
              width: 1, // Customize border width
            ),
          ),
          child: ClipOval(
            child: widget.imageUrl != ""
                ? FancyShimmerImage(
                    imageUrl: widget.imageUrl ?? "",
                    shimmerHighlightColor: AppColors.neutralColor,
                    width: 40,
                    height: 40,
                    cacheKey: widget.imageUrl,
                    errorWidget: errorImgplaceholder(),
                    boxFit: BoxFit.cover,
                  )
                : Assets.app.defaultAvatar
                    .image(width: 40, height: 40, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(
          width: Sizes.md,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'CruhsonCode',
                  style: AppTextTheme.lightTextTheme.bodyMedium,
                ),
                const SizedBox(
                  width: Sizes.xs,
                ),
                Text(
                  '10h',
                  style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: const Color.fromARGB(255, 197, 199, 202)),
                ),
              ],
            ),
            Text(
              'Cool as comment',
              style: AppTextTheme.lightTextTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w300),
            ),
          ],
        ),
        const Spacer(),
        LikeButton(
          isLiked: false,
          countPostion: CountPostion.bottom,
          countBuilder: (likeCount, isLiked, text) {
            return Text(
              '$likeCount',
              style: AppTextTheme.lightTextTheme.bodySmall,
            );
          },
          likeCountPadding: const EdgeInsets.only(right: 0),
          likeCount: 0,
          likeCountAnimationDuration: const Duration(milliseconds: 300),
          likeBuilder: (bool isLiked) => Icon(
            isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
            color: isLiked ? Colors.red : null,
          ),
          // onTap: (isLiked) ,
        )
      ],
    );
  }
}
