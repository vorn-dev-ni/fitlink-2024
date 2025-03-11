import 'package:demo/data/repository/firebase/profile_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/profiles/profile_service.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'following_friend_controller.g.dart';

@Riverpod(keepAlive: true)
class FollowingFriendController extends _$FollowingFriendController {
  late ProfileRepository profileRepository;
  @override
  Stream<List<UserData>?> build({
    String? userId,
  }) {
    profileRepository = ProfileRepository(
        baseService:
            ProfileService(firebaseAuthService: FirebaseAuthService()));
    try {
      if (userId == null) {
        return Stream.value([]);
      }
      return getData(userId);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  Stream<List<UserData>?> getData(userId) {
    return profileRepository.getUserFriendsList(userId);
  }
}
