import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/features/home/views/single_profile/model/media_count.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  Future<List<UserData>> searchUserFollowingLists(
    String userId, {
    String? searchTerm,
    int limit = 10,
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      final followingRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('following')
          .limit(limit);

      QuerySnapshot followingSnapshot;
      if (lastDoc != null) {
        followingSnapshot =
            await followingRef.startAfterDocument(lastDoc).get();
      } else {
        followingSnapshot = await followingRef.get();
      }

      final userIds = followingSnapshot.docs.map((doc) => doc.id).toList();
      if (userIds.isEmpty) return [];

      final usersQuery = FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds);

      final userDocs = await usersQuery.get();

      final filteredUsers = userDocs.docs.where((doc) {
        final userData = doc.data() as Map<String, dynamic>;
        final fullName = userData['fullName']?.toLowerCase() ?? '';
        return searchTerm != null && searchTerm.isNotEmpty
            ? fullName.contains(searchTerm.toLowerCase())
            : true;
      }).map((doc) {
        final result = doc.data() as Map<String, dynamic>;
        return UserData.fromJson({...result, 'id': doc.id}, doc: doc);
      }).toList();

      return filteredUsers;
    } catch (e) {
      debugPrint("Error fetching followings: $e");
      rethrow;
    }
  }

  Stream<List<UserData>> getUserFriendsList(String userId) {
    return baseService.getUserFriendsList().asyncMap(
      (userSnapshot) async {
        final followingRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('following');

        final followingSnapshot = await followingRef.get();

        final userIds = followingSnapshot.docs.map((doc) => doc.id).toList();

        if (userIds.isEmpty) return [];

        final userDocs = await Future.wait(
          userIds.map((id) => baseService.getUserDetailById(id)),
        );

        return userDocs.where((doc) => doc.exists).map((doc) {
          final result = doc.data() as Map<String, dynamic>;
          return UserData.fromJson({...result, 'id': doc.id});
        }).toList();
      },
    );
  }

  Future getTotalFollowings(String userId) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('following')
          .get();

      return result.docs.length;
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

  Stream<int> getNotificationCount(String? uid) async* {
    try {
      yield* baseService.getNotificationCount(uid);
    } catch (e) {
      rethrow;
    }
  }

  Future clearBadge() async {
    try {
      await baseService.clearNotificationCount();
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

  Stream<QuerySnapshot<Map<String, dynamic>>> listenUserCollections() {
    return baseService.listenUserCollections();
  }

  Stream<UserData?> getUserById(String userId) {
    try {
      return baseService.getUserStatus(userId).map(
        (doc) {
          final result = doc.data() as Map<String, dynamic>;
          return UserData.fromJson({...result, 'id': doc.id});
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> getUserOnlineStatus(String userId) async {
    try {
      final data = await baseService.getUserOnlineStatus(userId);
      if (data.exists) {
        final mapresult = data.data() as Map;
        return mapresult['isOnline'];
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
