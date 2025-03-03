import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

Widget renderLeading({String? title}) {
  return Text(
    title ?? "",
    style: AppTextTheme.lightTextTheme.bodySmall,
  );
}
