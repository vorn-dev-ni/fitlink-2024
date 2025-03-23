import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/data/repository/firebase/video_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/video/video_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';
part 'single_video_controller.g.dart';

@Riverpod(keepAlive: true)
class SingleVideoController extends _$SingleVideoController {
  late VideoRepository videoRepository;
  VideoPlayerController? videoplayer;

  @override
  Future<VideoTikTok?> build(String videoId) async {
    videoRepository = VideoRepository(
      videoService: VideoService(firebaseAuthService: FirebaseAuthService()),
    );
    ref.onDispose(
      () {
        videoplayer?.dispose();
      },
    );

    return fetchSingleVideo(videoId);
  }

  Future<VideoTikTok?> fetchSingleVideo(String videoId) async {
    try {
      final video = await videoRepository.getVideoByIdOnce(videoId);

      return video?.copyWith(videoplayer: null);
    } catch (e) {
      Fluttertoast.showToast(msg: 'fetchSingleVideo ${e.toString()}');
      rethrow;
    }
  }

  // Future<void> likeVideo(String videoId) async {
  //   try {
  //     await videoRepository.likeOrUnlike(videoId);
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'likeVideo failed: ${e.toString()}');
  //   }
  // }

  Future<void> shareVideo(String videoId) async {
    try {
      // await videoRepository.shareVideo(videoId);
      // Handle any additional actions needed
    } catch (e) {
      Fluttertoast.showToast(msg: 'shareVideo failed: ${e.toString()}');
    }
  }
}
