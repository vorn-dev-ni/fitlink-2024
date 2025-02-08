import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:sizer/sizer.dart';

class CahceImageNetwork extends StatefulWidget {
  final int? index;
  final String feature;

  CahceImageNetwork({
    super.key,
    this.index = 0,
    required this.feature,
  });

  @override
  State<CahceImageNetwork> createState() => _CahceImageNetworkState();
}

class _CahceImageNetworkState extends State<CahceImageNetwork>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    debugPrint("Re build event item");

    return FancyShimmerImage(
      cacheKey: widget.feature,
      boxFit: BoxFit.cover,
      errorWidget: errorImgplaceholder(),
      width: 100.w,
      imageUrl: widget.feature,
    );
  }
}
