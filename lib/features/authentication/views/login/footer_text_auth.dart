import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:demo/utils/theme/text/text_theme.dart';

Center footerTextAuth(
    {required String text1, required String text2, required Function onPress}) {
  return Center(
    child: TextButton(
        onPressed: () {
          onPress();
        },
        style: const ButtonStyle(
          splashFactory: NoSplash.splashFactory,
        ),
        child: RichText(
          softWrap: true,
          text: TextSpan(
              text: text1,
              style: AppTextTheme.lightTextTheme.labelSmall,
              children: [
                TextSpan(
                    text: text2,
                    style: const TextStyle(
                        color: AppColors.secondaryColor,
                        decoration: TextDecoration.underline))
              ]),
        )),
  );
}
