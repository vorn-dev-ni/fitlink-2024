// import 'package:demo/data/repository/firebase/video_repo.dart';
// import 'package:demo/data/service/firebase/firebase_service.dart';
// import 'package:demo/data/service/firestore/video/video_service.dart';
// import 'package:flutter/material.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// part 'user_like_tiktok.g.dart';

// @Riverpod(keepAlive: true)
// class UserTikTokLikeRealTimeController
//     extends _$UserTikTokLikeRealTimeController {
//   late VideoRepository videoRepository;

//   @override
//   Stream<bool> build(String videoId) {
//     videoRepository = VideoRepository(
//       videoService: VideoService(firebaseAuthService: FirebaseAuthService()),
//     );
//     return fetch();
//   }

//   Stream<VideoTikTok> fetch() {
//     try {
//       if (videoId == "") {
//         return const Stream.empty();
//       }

//       return videoRepository.getVideoCounts(videoId);
//     } catch (e) {
//       throw Exception("Failed to fetch interaction data: $e");
//     }
//   }
// }
