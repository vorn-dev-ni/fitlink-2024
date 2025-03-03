import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

Widget postDescription({String desc = "This is an example"}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: Sizes.lg, vertical: 0),
    child: desc.length > 100
        ? Wrap(
            children: [
              Text(
                maxLines: 3,
                '${desc.substring(0, 100)}...',
                overflow: TextOverflow.ellipsis,
              ),
              GestureDetector(
                child: Text(
                  'Read more',
                  style: AppTextTheme.lightTextTheme.bodySmall
                      ?.copyWith(color: AppColors.neutralDark),
                ),
              )
            ],
          )
        : Text(desc),
  );
}
