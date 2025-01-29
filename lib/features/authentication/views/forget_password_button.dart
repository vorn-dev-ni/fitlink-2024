import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

Container forgetPasswordButton(BuildContext context) {
  return Container(
    alignment: Alignment.centerRight,
    child: TextButton(
        onPressed: () {
          HelpersUtils.navigatorState(context)
              .pushNamed(AppPage.forgetpassword);
        },
        child: Text('Forgot password?',
            textAlign: TextAlign.end,
            style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                color: AppColors.secondaryColor, fontWeight: FontWeight.w500))),
  );
}
