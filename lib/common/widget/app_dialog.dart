import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

class AppALertDialog extends StatefulWidget {
  final String title;
  final String desc;
  final Function onConfirm;
  final Widget? negativeButton;
  final Widget? positivebutton;
  final bool? showIcon;
  final Color? textColor;
  final Color? contentColor;
  final Color? bgColor;
  const AppALertDialog(
      {super.key,
      this.showIcon = true,
      required this.onConfirm,
      this.contentColor = AppColors.errorColor,
      this.textColor = AppColors.errorColor,
      this.negativeButton,
      this.bgColor,
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
        backgroundColor: widget.bgColor ?? AppColors.errorLight,
        title: widget.showIcon == true
            ? const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Icon(
                  Icons.info_sharp,
                  size: 70.0,
                  color: AppColors.errorColor,
                ),
              )
            : null,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: AppTextTheme.lightTextTheme.titleLarge?.copyWith(
                  color: widget.textColor, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: Sizes.md,
            ),
            Text(
              widget.desc,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: AppTextTheme.lightTextTheme.bodyMedium
                  ?.copyWith(color: widget.contentColor),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                if (widget.negativeButton != null)
                  Expanded(
                    child: widget.negativeButton!,
                  ),
                const SizedBox(
                  width: Sizes.sm,
                ),
                if (widget.positivebutton != null)
                  Expanded(
                    child: widget.positivebutton!,
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
