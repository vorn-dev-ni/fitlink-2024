import 'package:demo/common/widget/button.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

class ReportAction {
  final String label;
  final String reason;

  ReportAction({
    required this.label,
    required this.reason,
  });
}

final class ReportAlertDialog extends StatelessWidget {
  void Function(String reason) onSelectReason;
  ReportAlertDialog({super.key, required this.onSelectReason});
  final List<ReportAction> actions = [
    ReportAction(
      label: 'Spam',
      reason: 'This content is spam or misleading',
    ),
    ReportAction(
      label: 'Harassment',
      reason: 'This content is harassing or bullying',
    ),
    ReportAction(
      label: 'Scamming or fraud',
      reason: 'This content is scam or fraud',
    ),
    ReportAction(
      label: 'Other',
      reason: 'This content is not my type',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please provide action to report this content.'),
            const SizedBox(
              height: Sizes.md,
            ),
            ...List.generate(
              actions.length,
              (index) {
                return ButtonApp(
                  label: actions[index].label,
                  textStyle: AppTextTheme.lightTextTheme.bodyMedium!
                      .copyWith(color: AppColors.errorColor),
                  color: AppColors.errorLight,
                  elevation: 0,
                  splashColor: AppColors.errorColor,
                  onPressed: () {
                    onSelectReason(actions[index].reason);
                    Navigator.of(context).pop();
                  },
                );
              },
            )
          ],
        ));
  }
}
