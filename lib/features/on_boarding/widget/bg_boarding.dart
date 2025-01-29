import 'package:demo/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget background_boarding({AssetGenImage? image}) {
  return SizedBox.expand(
    child: image?.image(
      width: 1.sw,
      height: 1.sh,
      fit: BoxFit.cover,
    ),
  );
}
