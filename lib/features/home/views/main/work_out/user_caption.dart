import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget captionText(String caption) {
  return SizedBox(
    width: 60.w,
    child: Text(
      caption,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        shadows: [
          Shadow(
            offset: const Offset(0, 0),
            blurRadius: 8.0,
            color: Colors.black.withOpacity(1),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
