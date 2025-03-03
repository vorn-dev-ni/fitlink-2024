import 'package:demo/data/repository/firebase/notification_repo.dart';
import 'package:demo/data/repository/firebase/post_social_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/notification/notification_service.dart';
import 'package:demo/data/service/firestore/posts/social_post_service.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'profile_post_controller.g.dart';

@Riverpod(keepAlive: true)
class ProfilePostController extends _$ProfilePostController {
  late PostSocialRepo postSocialRepo;
  late NotificationRepo notificationRepo;
  final firebaseService = FirebaseAuthService();
  @override
  Stream<List<Post>?> build(String? uid) {
    notificationRepo = NotificationRepo(
        notificationBaseService:
            NotificationRemoteService(firebaseAuthService: firebaseService));
    postSocialRepo = PostSocialRepo(
        baseSocialMediaService:
            SocialPostService(firebaseAuthService: firebaseService));

    debugPrint("user received is ${uid}");

    if (FirebaseAuth.instance.currentUser == null) {
      debugPrint("User is null");
      return const Stream.empty();
    }
    return getAllPosts(uid ?? FirebaseAuth.instance.currentUser!.uid);
  }

  Stream<List<Post>?> getAllPosts(String uid) async* {
    try {
      final stream = postSocialRepo.getAllUserPost(uid);
      await for (var posts in stream) {
        yield posts;
      }
    } catch (e) {
      rethrow;
    }
  }
}
