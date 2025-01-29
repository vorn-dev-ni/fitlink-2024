import 'package:demo/common/widget/app_loading.dart';
import 'package:flutter/material.dart';

Widget backDropLoading({Color? backgroundColor}) {
  return Positioned.fill(
    top: 0,
    left: 0,
    right: 0,
    child: GestureDetector(
      onTap: () {},
      child: Container(
        color:
            backgroundColor?.withOpacity(0.6) ?? Colors.black.withOpacity(0.5),
        child: appLoadingSpinner(),
      ),
    ),
  );
}
