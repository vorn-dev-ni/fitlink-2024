import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ZoomableImage extends StatefulWidget {
  final String imageUrl;

  const ZoomableImage({required this.imageUrl, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ZoomableImageState createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: PhotoView(
        imageProvider: NetworkImage(widget.imageUrl),
        maxScale: PhotoViewComputedScale.covered,
        enablePanAlways: false,
        basePosition: Alignment.center,
        disableGestures: false,
        onTapUp: (context, details, controllerValue) {
          HelpersUtils.navigatorState(context).pop();
        },
        loadingBuilder: (context, event) {
          return appLoadingSpinner();
        },
        errorBuilder: (context, error, stackTrace) {
          return errorImgplaceholder();
        },
        backgroundDecoration: const BoxDecoration(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
