import 'package:demo/data/repository/firebase/post_social_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/posts/social_post_service.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'social_like_controller.g.dart';

@Riverpod(keepAlive: true)
class SocialLikeController extends _$SocialLikeController {
  late PostSocialRepo postSocialRepo;

  @override
  Stream<Post> build(String postId) {
    postSocialRepo = PostSocialRepo(
        baseSocialMediaService:
            SocialPostService(firebaseAuthService: FirebaseAuthService()));
    return postSocialRepo.listenToPost(postId);
  }
}
