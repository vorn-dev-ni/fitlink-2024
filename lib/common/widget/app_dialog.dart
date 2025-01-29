import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

class AppALertDialog extends StatefulWidget {
  final String title;
  final String desc;
  final Function onConfirm;
  final Widget? positivebutton;
  const AppALertDialog(
      {super.key,
      required this.onConfirm,
      required this.title,
      this.positivebutton,
      required this.desc});

  @override
  State<AppALertDialog> createState() => _AppALertDialogState();
}

class _AppALertDialogState extends State<AppALertDialog> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        widget.onConfirm();
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(16.0),
        backgroundColor: AppColors.errorLight,
        title: const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Icon(
            Icons.info_sharp,
            size: 70.0,
            color: AppColors.errorColor,
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: AppTextTheme.lightTextTheme.titleLarge?.copyWith(
                  color: AppColors.errorColor, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: Sizes.md,
            ),
            Text(
              widget.desc,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: AppTextTheme.lightTextTheme.bodyMedium
                  ?.copyWith(color: AppColors.errorColor),
            ),
            const SizedBox(height: 16.0),
            if (widget.positivebutton != null) widget.positivebutton!
          ],
        ),
      ),
    );
  }
}
