import 'package:demo/data/repository/firebase/notification_repo.dart';
import 'package:demo/data/repository/firebase/post_social_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/notification/notification_service.dart';
import 'package:demo/data/service/firestore/posts/social_post_service.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'social_post_controller.g.dart';

@Riverpod(keepAlive: true)
class SocialPostController extends _$SocialPostController {
  late PostSocialRepo postSocialRepo;
  late NotificationRepo notificationRepo;
  final firebaseService = FirebaseAuthService();
  @override
  Stream<List<Post>?> build() {
    notificationRepo = NotificationRepo(
        notificationBaseService:
            NotificationRemoteService(firebaseAuthService: firebaseService));
    postSocialRepo = PostSocialRepo(
        baseSocialMediaService:
            SocialPostService(firebaseAuthService: firebaseService));
    return getAllPosts();
  }

  Stream<List<Post>?> getAllPosts() async* {
    try {
      final stream = postSocialRepo.getAllPosts();
      await for (var posts in stream) {
        yield posts;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future addUserLike(String docId, int likes, bool hasLiked,
      {String? receiverId, String? parentId}) async {
    try {
      if (hasLiked) {
        await postSocialRepo.removeLikeCount(docId, likes);
      } else {
        await postSocialRepo.updateLikeCount(docId, likes);

        if (receiverId != null && parentId != null) {
          await notificationRepo.sendLikeNotification(
              senderID: FirebaseAuth.instance.currentUser!.uid,
              receiverID: receiverId,
              postId: parentId);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future doubleTapLikes(String docId, int likes) async {
    try {
      await postSocialRepo.updateLikeCount(docId, likes);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isUserLiked(String? postId) async {
    try {
      if (postId == "" || postId == null) {
        return false;
      }
      return await postSocialRepo.checkUserLikePost(postId);
    } catch (e) {
      rethrow;
    }
  }
}
