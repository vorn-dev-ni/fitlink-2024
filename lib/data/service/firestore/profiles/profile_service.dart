// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:demo/features/home/views/single_profile/model/media_count.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileService implements BaseUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late FirebaseAuthService firebaseAuthService;
  ProfileService({
    required this.firebaseAuthService,
  });

  @override
  Future updateCoverImage(Map<String, dynamic> data) async {
    try {
      final docId = _firestore
          .collection('users')
          .doc(firebaseAuthService.currentUser!.uid);
      await docId.set(data, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future updateProfile(Map<String, dynamic> data) async {
    try {
      final docId = _firestore
          .collection('users')
          .doc(firebaseAuthService.currentUser!.uid);
      await docId.update(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> followUser(String followedUserId) async {
    try {
      final currentUserId = firebaseAuthService.currentUser?.uid;

      final docSnapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(followedUserId)
          .get();

      if (docSnapshot.exists) {
        debugPrint("User is already following $followedUserId");
        return;
      }

      WriteBatch batch = _firestore.batch();

      batch.set(
        _firestore
            .collection('users')
            .doc(currentUserId)
            .collection('following')
            .doc(followedUserId),
        {'followedAt': FieldValue.serverTimestamp()},
      );

      batch.set(
        _firestore
            .collection('users')
            .doc(followedUserId)
            .collection('followers')
            .doc(currentUserId),
        {'followedAt': FieldValue.serverTimestamp()},
      );

      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future unfollowUser(String followedUserId) async {
    try {
      final currentUserId = firebaseAuthService.currentUser?.uid;
      if (currentUserId == null) {
        throw Exception("User is not authenticated.");
      }

      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(followedUserId)
          .delete();

      await _firestore
          .collection('users')
          .doc(followedUserId)
          .collection('followers')
          .doc(currentUserId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MediaCount> getMediaCount(String userId) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        return MediaCount();
      }
      final notificationsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .get();

      final followersSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('followers')
          .get();

      final followingSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('following')
          .get();

      final workoutSnapshot = await _firestore
          .collection('activities')
          .where('userId', isEqualTo: userId)
          .get();

      final notificationsCount = notificationsSnapshot.docs.length;
      final followersCount = followersSnapshot.docs.length;
      final followingCount = followingSnapshot.docs.length;
      final workoutCount = workoutSnapshot.docs.length;

      return MediaCount(
        notificaitonCount: notificationsCount,
        followerCount: followersCount,
        workoutCounts: workoutCount,
        followingCount: followingCount,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<int> getNotificationCount(String? userId) {
    if (userId == null) {
      return Stream.value(0);
    }
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  @override
  Future<bool> isFollowingUser(String followedUserId) async {
    try {
      final currentUserId = firebaseAuthService.currentUser!.uid;
      final followingDoc = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(followedUserId)
          .get();

      return followingDoc.exists;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<DocumentSnapshot<Object?>> getUserStatus(String? userId) {
    if (userId == null) {
      return const Stream.empty();
    }
    return _firestore.collection('users').doc(userId).snapshots();
  }

  @override
  Future<void> setUserOffline(String? userId) async {
    if (userId == null) {
      return;
    }
    await _firestore.collection('users').doc(userId).update({
      'isOnline': false,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> setUserOnline(String? userId) async {
    if (userId == null) {
      return;
    }
    await _firestore.collection('users').doc(userId).update({
      'isOnline': true,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> listenUserCollections() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  @override
  Future<DocumentSnapshot<Object?>> getUserDetailById(String userId) async {
    try {
      final followingDoc =
          await _firestore.collection('users').doc(userId).get();

      return followingDoc;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserFriendsList() {
    return _firestore.collection('users').snapshots();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getUserFollowings() {
    return _firestore.collection('users').get();
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserOnlineStatus(
      String? userId) async {
    return _firestore.collection('users').doc(userId).get();
  }
}
