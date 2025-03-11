import 'package:demo/data/repository/firebase/profile_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firebase/storage_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/data/service/firestore/profiles/profile_service.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_header_controller.g.dart';

@Riverpod(keepAlive: true)
class UserHeaderController extends _$UserHeaderController {
  late FirestoreService firestoreService;
  late StorageService storageService;
  late ProfileRepository profileRepository;
  @override
  Stream<UserData?> build(String userId) {
    storageService = StorageService();
    profileRepository = ProfileRepository(
        baseService:
            ProfileService(firebaseAuthService: FirebaseAuthService()));
    firestoreService =
        FirestoreService(firebaseAuthService: FirebaseAuthService());

    return getData(userId);
  }

  Stream<UserData?> getData(String userId) {
    return profileRepository.getUserById(userId);
  }

  Future<bool> isUserOnline() async {
    return await profileRepository.getUserOnlineStatus(userId);
  }
}
