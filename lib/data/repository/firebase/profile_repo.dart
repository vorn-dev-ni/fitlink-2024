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
}
