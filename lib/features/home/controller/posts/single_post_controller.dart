import 'package:demo/data/repository/firebase/post_social_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/posts/social_post_service.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'single_post_controller.g.dart';

@Riverpod(keepAlive: true)
class SinglePostController extends _$SinglePostController {
  late PostSocialRepo postSocialRepo;
  @override
  Stream<Post?> build(String postId) {
    postSocialRepo = PostSocialRepo(
        baseSocialMediaService:
            SocialPostService(firebaseAuthService: FirebaseAuthService()));
    return getSinglePost(postId);
  }

  Stream<Post?> getSinglePost(postId) async* {
    try {
      final stream = postSocialRepo.getSinglePost(postId);
      yield* stream;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }
}
