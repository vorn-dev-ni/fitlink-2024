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
            offset: const Offset(2, 2),
            blurRadius: 5.0,
            color: Colors.black.withOpacity(0.2),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
