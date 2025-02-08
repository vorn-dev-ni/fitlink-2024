import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: blogImageUrls.length,
            itemBuilder: (context, index) {
              final img = blogImageUrls[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: FancyShimmerImage(
                  errorWidget: errorImgplaceholder(),
                  imageUrl: img,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
