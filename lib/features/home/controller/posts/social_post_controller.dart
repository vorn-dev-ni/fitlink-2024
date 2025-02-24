import 'package:demo/data/repository/firebase/post_social_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/posts/social_post_service.dart';
import 'package:demo/features/home/controller/posts/user_like_controller.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'social_post_controller.g.dart';

@Riverpod(keepAlive: true)
class SocialPostController extends _$SocialPostController {
  late PostSocialRepo postSocialRepo;
  @override
  Stream<List<Post>?> build() {
    debugPrint("call api again");
    postSocialRepo = PostSocialRepo(
        baseSocialMediaService:
            SocialPostService(firebaseAuthService: FirebaseAuthService()));
    return getAllPosts();
  }

  Stream<List<Post>?> getAllPosts() async* {
    try {
      final stream = postSocialRepo.getAllPosts();
      await for (var posts in stream) {
        yield posts;
      }
      // yield stream;
    } catch (e) {
      rethrow;
    }
  }

  Future addUserLike(String docId, int likes, bool hasLiked) async {
    try {
      if (hasLiked) {
        await postSocialRepo.removeLikeCount(docId, likes);
      } else {
        await postSocialRepo.updateLikeCount(docId, likes);
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

  Future<bool> isUserLiked(String postId) async {
    try {
      return await postSocialRepo.checkUserLikePost(postId);
    } catch (e) {
      rethrow;
    }
  }
}
