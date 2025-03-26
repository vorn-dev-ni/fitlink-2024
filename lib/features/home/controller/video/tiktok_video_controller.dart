import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/data/repository/firebase/video_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/video/video_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';
part 'tiktok_video_controller.g.dart';

@Riverpod(keepAlive: true)
class TiktokVideoController extends _$TiktokVideoController {
  late VideoRepository videoRepository;
  int _limit = 4;
  DocumentSnapshot? _lastDoc;

  @override
  Future<List<VideoTikTok>> build() async {
    videoRepository = VideoRepository(
      videoService: VideoService(firebaseAuthService: FirebaseAuthService()),
    );
    clearState();
    return fetchVideo();
  }

  void disposeVideoControllers() {
    if (state is AsyncData<List<VideoTikTok>>) {
      for (var controller in state.value!) {
        controller.videoplayer == null;
        controller.videoplayer?.dispose();
      }
      // Fluttertoast.showToast(msg: 'video has been disposed');

      // ref.invalidateSelf();
      // state = const AsyncLoading();
    }
  }

  void refresh() {
    state = const AsyncLoading();
    // disposeVideoControllers();
    ref.invalidateSelf();
    // state = const AsyncLoading();
  }

  void clearState() {
    _limit = 4;
    _lastDoc = null;
    disposeVideoControllers();
  }

  Future trackViewCount(String videoId) async {
    try {
      await videoRepository.setViewCount(videoId);
    } catch (e) {
      rethrow;
    }
  }

  void disposeVideo(int index) {
    final videoList = state.value ?? [];

    if (index >= 0 && index < videoList.length) {
      final video = videoList[index];
      if (video.isInitialized == false || video.isInitialized == null) {
        return;
      }
      video.videoplayer == null;
      final updatedVideo = video.copyWith(isInitialized: false);
      final updatedList = List<VideoTikTok>.from(videoList);
      updatedList[index] = updatedVideo;
      state = AsyncData(updatedList);
      // Fluttertoast.showToast(msg: 'Disposed video at index $index');
    }
  }

  Future preloadVideo(int index, {String? message = 'Preload video'}) async {
    try {
      if (state.value == null || index >= state.value!.length) return;
      final videoList = state.value!;
      final video = videoList[index];

      if (video.isInitialized == true) return;

      // Fluttertoast.showToast(
      //     msg: '${message} at index ${index}',
      //     toastLength: Toast.LENGTH_LONG,
      //     fontSize: 16.0);
      if (video.videoplayer != null && video.isInitialized == null ||
          video.isInitialized == false) {
        await video.videoplayer?.initialize();
        final updatedVideo = video.copyWith(isInitialized: true);
        final updatedList = List<VideoTikTok>.from(videoList);
        updatedList[index] = updatedVideo;
        state = AsyncData(updatedList);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Error while preloading video: ${e.toString()}');
    }
  }

  FutureOr<List<VideoTikTok>> fetchVideo({bool loadMore = false}) async {
    try {
      List<VideoTikTok> videos;

      if (loadMore && _lastDoc != null) {
        videos = await videoRepository.fetchVideos(
          page: _limit,
          startAfter: _lastDoc,
        );
      } else {
        videos = await videoRepository.fetchVideos(page: _limit);
      }

      if (videos.isNotEmpty) {
        _lastDoc = videos.last.lastDoc;
      }
      final List<VideoTikTok> updatedVideos = [];

      for (int i = 0; i < videos.length; i++) {
        final video = videos[i];
        final videoController = VideoPlayerController.networkUrl(
          Uri.parse(video.videoUrl ?? ""),
          videoPlayerOptions: VideoPlayerOptions(),
        );

        if (i <= 1) {
          await videoController.initialize();
        }

        ref.read(
          socialInteractonVideoControllerProvider(video.documentID ?? "")
              .future,
        );
        if (i <= 1) {
          updatedVideos.add(video.copyWith(
              videoplayer: videoController, isInitialized: true));
        } else {
          updatedVideos.add(video.copyWith(videoplayer: videoController));
        }
      }

      // final updatedVideos = await Future.wait(
      //   videos.map((video) async {
      //     final videoController = VideoPlayerController.networkUrl(
      //         Uri.parse(video.videoUrl ?? ""),
      //         videoPlayerOptions: VideoPlayerOptions());
      //     if (videoController.value.isInitialized == false) {
      //       await videoController.initialize();
      //     }

      //     ref.read(
      //         socialInteractonVideoControllerProvider(video.documentID ?? "")
      //             .future);

      //     return video.copyWith(videoplayer: videoController);
      //   }),
      //   eagerError: true,
      // );

      if (loadMore && state.value != null) {
        state = AsyncData([...state.value!, ...updatedVideos]);
      }

      return updatedVideos;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Video is in proessing...');
      rethrow;
    }
  }

  FutureOr<List<VideoTikTok>> loadMore() async {
    return await fetchVideo(loadMore: true);
  }

  void setLastDoc(DocumentSnapshot doc) {
    _lastDoc = doc;
  }
}

@Riverpod(keepAlive: true)
class SocialInteractonVideoController
    extends _$SocialInteractonVideoController {
  late VideoRepository videoRepository;

  @override
  Stream<VideoTikTok> build(String videoId) {
    videoRepository = VideoRepository(
      videoService: VideoService(firebaseAuthService: FirebaseAuthService()),
    );

    return fetchInteractionData();
  }

  Stream<VideoTikTok> fetchInteractionData() async* {
    try {
      if (videoId == "") {
        yield* const Stream.empty();
      }

      yield* videoRepository.getVideoCounts(videoId);
    } catch (e) {
      throw Exception("Failed to fetch interaction data: $e");
    }
  }

  Future deleteVideo(videoId) async {
    try {
      return await videoRepository.deleteVideo(videoId);
    } catch (e) {
      throw Exception("Failed to fetch interaction data: $e");
    }
  }

  Future checkUserLiked(videoId) async {
    try {
      return await videoRepository.checkIfUserLiked(videoId);
    } catch (e) {
      throw Exception("Failed to fetch interaction data: $e");
    }
  }
}

@Riverpod(keepAlive: false)
class CheckUserLikedController extends _$CheckUserLikedController {
  late VideoRepository videoRepository;

  @override
  Future<bool> build(String videoId) async {
    videoRepository = VideoRepository(
      videoService: VideoService(firebaseAuthService: FirebaseAuthService()),
    );
    return checkUserLiked(videoId);
  }

  FutureOr<bool> checkUserLiked(String videoId) async {
    try {
      return await videoRepository.checkIfUserLiked(videoId);
    } catch (e) {
      throw Exception("Failed to fetch interaction data: $e");
    }
  }
}
