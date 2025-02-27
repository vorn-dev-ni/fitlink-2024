import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/features/home/controller/profile/profile_post_controller.dart';
import 'package:demo/features/home/widget/posts/post_panel.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostProfile extends ConsumerStatefulWidget {
  String userId;
  PostProfile({super.key, required this.userId});

  @override
  ConsumerState<PostProfile> createState() => _PostProfileState();
}

class _PostProfileState extends ConsumerState<PostProfile> {
  bool blockScroll = false;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(profilePostControllerProvider(widget.userId));

    return async.when(
      data: (data) {
        return data != null && data.isNotEmpty
            ? ListView.builder(
                itemCount: data.length,
                physics: blockScroll
                    ? const NeverScrollableScrollPhysics()
                    : const ScrollPhysics(),
                padding: const EdgeInsets.only(top: Sizes.xl, bottom: 140),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final result = data[index];
                  return PostPanel(
                    post: result,
                    isComment: false,
                    url: result.imageUrl,
                    showHeader: true,
                    twoFingersOn: () => setState(() => blockScroll = true),
                    twoFingersOff: () => Future.delayed(
                      PinchZoomReleaseUnzoomWidget.defaultResetDuration,
                      () => setState(() => blockScroll = false),
                    ),
                  );
                },
              )
            : SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: emptyContent(
                    title: 'Oop, this user has no related post yet !!!'),
              );
      },
      error: (error, stackTrace) {
        debugPrint('Error is ${error.toString()}');
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: emptyContent(title: error.toString()),
        );
      },
      loading: () {
        return renderLoading();
      },
    );
  }

  Skeletonizer renderLoading() {
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
        child: ListView.builder(
          itemCount: 4,
          padding: const EdgeInsets.only(top: Sizes.xl, bottom: 140),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: Sizes.xs),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Sizes.lg),
                child: FancyShimmerImage(
                    width: 100.w,
                    boxFit: BoxFit.cover,
                    height: 250,
                    imageUrl: index % 2 == 0
                        ? 'https://www.fastandup.in/nutrition-world/wp-content/uploads/2023/05/Workouts-for-Men.jpg'
                        : 'https://hips.hearstapps.com/hmg-prod/images/social-media-lifting-654a0331a2803.jpg?crop=1.00xw:0.751xh;0,0.204xh&resize=1200:*'),
              ),
            );
          },
        ),
      ),
    );
  }
}
