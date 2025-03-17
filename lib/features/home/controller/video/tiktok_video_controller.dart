import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/data/repository/firebase/video_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/video/video_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'tiktok_video_controller.g.dart';

@Riverpod(keepAlive: true)
class TiktokVideoController extends _$TiktokVideoController {
  late VideoRepository videoRepository;
  int _limit = 3;
  DocumentSnapshot? _lastDoc;

  @override
  Future<List<VideoTikTok>> build() async {
    videoRepository = VideoRepository(
      videoService: VideoService(firebaseAuthService: FirebaseAuthService()),
    );
    return fetchVideo(); // Fetch initial set of videos
  }

  void clearState() {
    _limit = 3;
    _lastDoc = null;
  }

  Future trackViewCount(String videoId) async {
    try {
      await videoRepository.setViewCount(videoId);
    } catch (e) {
      rethrow;
    }
  }

  FutureOr<List<VideoTikTok>> fetchVideo({bool loadMore = false}) async {
    try {
      if (loadMore && _lastDoc != null) {
        final videos = await videoRepository.fetchVideos(
            page: _limit, startAfter: _lastDoc);
        if (videos.isNotEmpty) {
          _lastDoc = videos.last.lastDoc;
        }
        return videos;
      } else {
        final videos = await videoRepository.fetchVideos(page: _limit);
        if (videos.isNotEmpty) {
          _lastDoc = videos.last.lastDoc;
        }
        return videos;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'fetchVideo ${e.toString()}');
      rethrow;
    }
  }

  FutureOr<List<VideoTikTok>> loadMore() async {
    return fetchVideo(loadMore: true);
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

  Stream<VideoTikTok> fetchInteractionData() {
    try {
      if (videoId == "") {
        return const Stream.empty();
      }
      return videoRepository.getVideoCounts(videoId);
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
