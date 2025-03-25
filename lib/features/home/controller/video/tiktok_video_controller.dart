import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/data/repository/firebase/video_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/video/video_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';
part 'tiktok_video_controller.g.dart';

@Riverpod(keepAlive: true)
class TiktokVideoController extends _$TiktokVideoController {
  late VideoRepository videoRepository;
  int _limit = 2;
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
    _limit = 2;
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

  Future preloadVideo(int index) async {
    try {
      // Check if index is valid
      if (state.value == null || index >= state.value!.length) {
        return;
      }

      final videoList = state.value ?? [];
      final video = videoList[index];

      // Skip if the video is already initialized
      if (video.isInitialized == true) {
        return;
      }

      // Check if the video player controller is assigned but not initialized
      if (!video.videoplayer!.value.isInitialized) {
        Fluttertoast.showToast(msg: 'Preloading video at index $index');

        // Initialize the video player
        await video.videoplayer!.initialize();

        // Mark the video as initialized

        // Update the state with the new list containing the initialized video
        final updatedList = List<VideoTikTok>.from(videoList);

        state = AsyncData(updatedList);

        Fluttertoast.showToast(msg: 'Done preloading video at index $index');
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
