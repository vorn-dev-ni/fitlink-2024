import 'package:demo/data/repository/firebase/profile_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/profiles/profile_service.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'notification_badge.g.dart';

@Riverpod(keepAlive: true)
class UserNotificationController extends _$UserNotificationController {
  late ProfileRepository profileRepository;

  @override
  Stream<int> build() async* {
    try {
      profileRepository = ProfileRepository(
          baseService:
              ProfileService(firebaseAuthService: FirebaseAuthService()));

      final data = profileRepository
          .getNotificationCount(FirebaseAuth.instance.currentUser?.uid);
      yield* data;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  Future clearNotificationBadge() async {
    try {
      await profileRepository.clearBadge();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
