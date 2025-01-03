import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget IconTab({required String svgAsset, required Color forebackground}) {
  return Container(
    clipBehavior: Clip.hardEdge,
    padding: const EdgeInsets.all(Sizes.sm),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(Sizes.xl),
      color: Colors.white,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.string(
          svgAsset,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(forebackground, BlendMode.srcIn),
        ),
      ],
    ),
  );
}
