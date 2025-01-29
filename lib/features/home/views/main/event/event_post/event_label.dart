import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

Widget eventLabel({String label = 'Event Information'}) {
  return Text(
    label,
    style: AppTextTheme.lightTextTheme.bodyLarge
        ?.copyWith(fontWeight: FontWeight.w500),
  );
}
