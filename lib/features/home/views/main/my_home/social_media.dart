import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:demo/features/home/widget/posts/post_panel.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SocialMediaTab extends StatefulWidget {
  const SocialMediaTab({super.key});

  @override
  State<SocialMediaTab> createState() => _SocialMediaTabState();
}

class _SocialMediaTabState extends State<SocialMediaTab>
    with AutomaticKeepAliveClientMixin<SocialMediaTab> {
  List<String> blogImageUrls = [
    "https://plus.unsplash.com/premium_photo-1661964304872-7b715cf38cd1?q=80&w=3570&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1550399504-8953e1a6ac87?q=80&w=3729&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://plus.unsplash.com/premium_photo-1680981143104-f165d1d6d39c?q=80&w=3732&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1566371486490-560ded23b5e4?q=80&w=3570&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1546749876-2088f8b19e09?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8c2V4eSUyMGd5bXxlbnwwfHwwfHx8MA%3D%3D",
    "https://images.unsplash.com/photo-1596079306903-9164c205f400?q=80&w=3571&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://plus.unsplash.com/premium_photo-1665673313231-b3cef27c80dd?q=80&w=3570&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  ];
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  bool blockScroll = false;
  bool hasClickTap = false;
  bool isAnimating = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      physics: blockScroll
          ? const NeverScrollableScrollPhysics()
          : const ScrollPhysics(),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: blogImageUrls.length,
            itemBuilder: (context, index) {
              final img = blogImageUrls[index];
              return renderItem(img);
            },
          ),
        ],
      ),
    );
  }

  Widget renderItem(String img) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.xs),
      child: PostPanel(
        url: img,
        twoFingersOn: () => setState(() => blockScroll = true),
        twoFingersOff: () => Future.delayed(
          PinchZoomReleaseUnzoomWidget.defaultResetDuration,
          () => setState(() => blockScroll = false),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
