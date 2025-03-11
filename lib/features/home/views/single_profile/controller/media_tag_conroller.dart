import 'package:demo/data/repository/firebase/profile_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/data/service/firestore/profiles/profile_service.dart';
import 'package:demo/features/home/views/single_profile/controller/notification_badge.dart';
import 'package:demo/features/home/views/single_profile/model/media_count.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'media_tag_conroller.g.dart';

@Riverpod(keepAlive: true)
class MediaTagConroller extends _$MediaTagConroller {
  late FirestoreService firestoreService;
  late ProfileRepository profileRepository;
  late FirebaseAuthService firebaseAuthService;
  @override
  Future<MediaCount?> build(String uid) async {
    firebaseAuthService = FirebaseAuthService();
    firestoreService =
        FirestoreService(firebaseAuthService: firebaseAuthService);
    profileRepository = ProfileRepository(
        baseService: ProfileService(firebaseAuthService: firebaseAuthService));

    return getData(uid);
  }

  FutureOr<MediaCount> getData(String uid) async {
    try {
      final result = await profileRepository.getMediaCount(uid);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
