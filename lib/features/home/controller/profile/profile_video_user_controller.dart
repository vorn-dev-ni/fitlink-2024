import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/data/repository/firebase/video_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firebase/storage_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/data/service/firestore/video/video_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'profile_video_user_controller.g.dart';

@Riverpod(keepAlive: true)
class ProfileVideoUserController extends _$ProfileVideoUserController {
  late FirestoreService firestoreService;
  late StorageService storageService;
  late VideoRepository videoRepository;
  @override
  Stream<List<VideoTikTok>> build(String userId) {
    storageService = StorageService();
    videoRepository = VideoRepository(
        videoService: VideoService(firebaseAuthService: FirebaseAuthService()));
    firestoreService =
        FirestoreService(firebaseAuthService: FirebaseAuthService());
    return getData(userId);
  }

  Stream<List<VideoTikTok>> getData(String? userId) {
    try {
      if (userId == null) {
        return Stream.value([]);
      } else {
        return videoRepository.getVideosByUserId(userId);
      }
    } catch (e) {
      rethrow;
    }
  }
}
