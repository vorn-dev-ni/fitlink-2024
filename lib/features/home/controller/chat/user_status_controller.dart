import 'package:demo/data/repository/firebase/profile_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/profiles/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_status_controller.g.dart';

@Riverpod(keepAlive: true)
class UserStatusController extends _$UserStatusController {
  late final ProfileRepository profileRepository;
  @override
  Stream<bool> build() {
    profileRepository = ProfileRepository(
        baseService:
            ProfileService(firebaseAuthService: FirebaseAuthService()));
    return profileRepository
        .getUserStatus(FirebaseAuth.instance.currentUser?.uid);
  }

  void setUserOnline() async {
    await profileRepository
        .setUserOnline(FirebaseAuth.instance.currentUser?.uid);
    // state = UserStatus.online;
  }

  void setUserOffline(String uid) async {
    await profileRepository.setUserOffline(uid);
    // state = UserStatus.offline;
  }
}
