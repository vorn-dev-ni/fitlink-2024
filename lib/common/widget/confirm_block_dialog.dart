import 'package:demo/common/widget/button.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

class ConfirmBlockDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmBlockDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.sm),
      ),
      title: Text(
        'Are you sure you?',
        style: AppTextTheme.lightTextTheme.titleLarge!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Once blocked, you will no longer see this user’s posts in your feed.',
              style: AppTextTheme.lightTextTheme.bodySmall!
                  .copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ButtonApp(
                label: 'Cancel',
                color: AppColors.secondaryColor,
                splashColor: AppColors.primaryColor,
                textStyle: AppTextTheme.lightTextTheme.bodyMedium!
                    .copyWith(color: AppColors.backgroundLight),
                elevation: 0,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ButtonApp(
                label: 'Block',
                color: AppColors.errorLight,
                splashColor: AppColors.errorColor.withOpacity(0.2),
                textStyle: AppTextTheme.lightTextTheme.bodyMedium!
                    .copyWith(color: AppColors.errorColor),
                elevation: 0,
                onPressed: () {
                  onConfirm();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
