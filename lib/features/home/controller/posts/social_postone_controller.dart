import 'package:demo/data/repository/firebase/notification_repo.dart';
import 'package:demo/data/repository/firebase/post_social_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/notification/notification_service.dart';
import 'package:demo/data/service/firestore/posts/social_post_service.dart';
import 'package:demo/features/home/controller/posts/post_loading_paging.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'social_postone_controller.g.dart';

@Riverpod(keepAlive: true)
class SocialPostoneController extends _$SocialPostoneController {
  int _pageSizes = 6;
  late PostSocialRepo postSocialRepo;
  late NotificationRepo notificationRepo;
  final firebaseService = FirebaseAuthService();
  @override
  Future<List<Post>?> build() {
    notificationRepo = NotificationRepo(
        notificationBaseService:
            NotificationRemoteService(firebaseAuthService: firebaseService));
    postSocialRepo = PostSocialRepo(
        baseSocialMediaService:
            SocialPostService(firebaseAuthService: firebaseService));

    return getAllPosts();
  }

  Future<List<Post>?> getAllPosts() async {
    try {
      return await postSocialRepo.getOneTimePosts(
          firebaseService.currentUser?.uid ?? "", _pageSizes);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadNextPage() async {
    try {
      // Check if there are more posts
      final total = await postSocialRepo.getTotalPosts();
      if (total < _pageSizes) {
        return;
      }
      ref.read(postLoadingPagingProvider.notifier).setState(true);
      _pageSizes = _pageSizes + 5;

      // Fetch new batch of posts using pagination
      final newDataStream = await postSocialRepo.getOneTimePosts(
        firebaseService.currentUser?.uid ?? "",
        _pageSizes,
      );

      final newData = newDataStream;

      if (newData != null && newData.isNotEmpty) {
        // Store the last document for pagination
        // _lastDocument = newData.last.reference;

        state = AsyncData([...newData]);
      }

      ref.read(postLoadingPagingProvider.notifier).setState(false);
    } catch (e) {
      ref.read(postLoadingPagingProvider.notifier).setState(false);
      rethrow;
    }
  }
}
