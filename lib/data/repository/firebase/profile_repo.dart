import 'package:demo/data/service/firestore/base_service.dart';
import 'package:demo/features/home/views/single_profile/model/media_count.dart';

class ProfileRepository {
  late BaseUserService baseService;

  ProfileRepository({
    required this.baseService,
  });

  Future<bool?> checkIsFollowing(String followedUserId) async {
    try {
      return await baseService.isFollowingUser(followedUserId);
    } catch (e) {
      rethrow;
    }
  }

  Future updateCoverImage(Map<String, dynamic> data) async {
    try {
      await baseService.updateCoverImage(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<MediaCount> getMediaCount(String uid) {
    try {
      return baseService.getMediaCount(uid);
    } catch (e) {
      rethrow;
    }
  }

  Future updateProfile(Map<String, dynamic> data) async {
    try {
      await baseService.updateProfile(data);
    } catch (e) {
      rethrow;
    }
  }

  Future unfollowingUser(String followingId) async {
    try {
      await baseService.unfollowUser(followingId);
    } catch (e) {
      rethrow;
    }
  }

  Future followingUser(String followingId) async {
    try {
      await baseService.followUser(followingId);
    } catch (e) {
      rethrow;
    }
  }

  Stream<bool> getUserStatus(String? userId) {
    try {
      final docRef = baseService.getUserStatus(userId);
      return docRef.map(
        (event) {
          if (event.exists) {
            final result = event.data() as Map<String, dynamic>;
            return result['isOnline'];
          }

          return false;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future setUserOffline(String? userId) async {
    try {
      await baseService.setUserOffline(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future setUserOnline(String? userId) async {
    try {
      await baseService.setUserOnline(userId);
    } catch (e) {
      rethrow;
    }
  }
}
