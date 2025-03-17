import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/features/home/controller/profile/profile_video_user_controller.dart';
import 'package:demo/features/video_search/widget/video_grid_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VideoProfile extends ConsumerStatefulWidget {
  String? userId;
  VideoProfile({super.key, this.userId});

  @override
  ConsumerState<VideoProfile> createState() => _VideoProfileState();
}

class _VideoProfileState extends ConsumerState<VideoProfile> {
  @override
  Widget build(BuildContext context) {
    return _buildVideoListing();
  }

  Widget _buildVideoListing() {
    final async = ref.watch(profileVideoUserControllerProvider(
        widget.userId ?? FirebaseAuth.instance.currentUser?.uid ?? ""));
    return async.when(
      data: (data) {
        return data.isEmpty
            ? SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Center(
                  child:
                      emptyContent(title: 'User has no video or upload yet.'),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 9 / 16,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return VideoItem(
                    video: data[index],
                    key: UniqueKey(),
                  );
                },
              );
      },
      error: (error, stackTrace) {
        return Center(
          child: emptyContent(title: error.toString()),
        );
      },
      loading: () => Skeletonizer(
          child: GridView.builder(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 9 / 16,
        ),
        itemCount: dummyVideos.length,
        itemBuilder: (context, index) {
          return VideoItem(video: dummyVideos[index]);
        },
      )),
    );
  }
}
