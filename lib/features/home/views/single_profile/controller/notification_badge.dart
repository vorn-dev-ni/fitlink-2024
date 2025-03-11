import 'package:demo/data/repository/firebase/profile_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/profiles/profile_service.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'notification_badge.g.dart';

@Riverpod(keepAlive: true)
class NotificationBadge extends _$NotificationBadge {
  @override
  int build() {
    ref.watch(userNotificationControllerProvider);

    String? storedCount = LocalStorageUtils().getKey('notificationCount');
    int count = (storedCount == null || storedCount.isEmpty)
        ? 0
        : int.parse(storedCount);

    return count;
  }

  void clearNotificationBadge() async {
    state = 0;
    await LocalStorageUtils().setKeyString('notificationCount', '0');
  }

  Future setBadge(int badge) async {
    state = badge;
    await LocalStorageUtils()
        .setKeyString('notificationCount', badge.toString());
  }
}

@Riverpod(keepAlive: true)
class UserNotificationController extends _$UserNotificationController {
  late ProfileRepository profileRepository;
  @override
  Stream<int> build() async* {
    profileRepository = ProfileRepository(
        baseService:
            ProfileService(firebaseAuthService: FirebaseAuthService()));
    final data = profileRepository
        .getNotificationCount(FirebaseAuth.instance.currentUser?.uid);

    final cachedNotificationCount =
        LocalStorageUtils().getKey('notificationCount');

    if (cachedNotificationCount == null || cachedNotificationCount == '') {
      int count = await data.first;
      await LocalStorageUtils()
          .setKeyString('notificationCount', count.toString());
    }

    yield* data;
  }
}
