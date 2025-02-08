import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

Widget BottomUploadImage(
    BuildContext context, Function(UploadType type) onPress) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(
            Icons.photo,
            color: AppColors.secondaryColor,
          ),
          title: Text(
            "Choose from gallery",
            style: AppTextTheme.lightTextTheme.bodyMedium,
          ),
          onTap: () {
            onPress(UploadType.photo);
            HelpersUtils.navigatorState(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.camera_alt,
            color: AppColors.secondaryColor,
          ),
          title: Text(
            "Take a picture",
            style: AppTextTheme.lightTextTheme.bodyMedium,
          ),
          onTap: () async {
            onPress(UploadType.camera);
            HelpersUtils.navigatorState(context).pop();
          },
        ),
      ],
    ),
  );
}
