// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SocialPostService extends BaseSocialMediaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late FirebaseAuthService firebaseAuthService;
  SocialPostService({
    required this.firebaseAuthService,
  }) {
    firebaseAuthService = FirebaseAuthService();
  }
  Future<List<DocumentReference>> getFollowedUsers(
      String currentUserId, int pageSize) async {
    final followingSnapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('following')
        .limit(pageSize)
        .get();

    final followedUserIds =
        followingSnapshot.docs.map((doc) => doc.id).toList();

    List<DocumentReference> userRefs = [];
    for (var userId in followedUserIds) {
      final userDocSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (userDocSnapshot.exists) {
        userRefs.add(userDocSnapshot.reference);
      }
    }

    return userRefs;
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPosts() {
    final querySnapshot = _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .orderBy('likesCount', descending: true)
        .orderBy('commentsCount', descending: true)
        .snapshots();
    return querySnapshot;
  }

  Future<int> getTotalPostsCount() async {
    var snapshot = await _firestore.collection('posts').get();
    return snapshot.size;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getPostsFromFollowedUsers(
    List<String> followedUserIds,
    int pageSize,
  ) {
    return _firestore
        .collection('posts')
        .where('userId',
            whereIn:
                followedUserIds.take(10).toList()) // Limit to 10 followed users
        .orderBy('createdAt', descending: true)
        .limit(pageSize) // Limit results with dynamic pageSize
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getTrendingPosts(int pageSize) {
    final now = DateTime.now();
    final twoWeekAgo = now.subtract(const Duration(days: 14));
    return Stream.empty();
  }

  Stream<List<DocumentSnapshot>> getPosts(int pageSize) {
    final now = DateTime.now();
    final tenDayAgo = now.subtract(const Duration(days: 14));
    return FirebaseFirestore.instance
        .collection('posts')
        .where('createdAt', isGreaterThanOrEqualTo: tenDayAgo)
        .orderBy('createdAt', descending: true) // Keep other orders if needed
        .limit(pageSize)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs); // Fetch posts without ordering by likeCount
  }

  Stream<List<DocumentSnapshot>> getSortedPosts(int pageSize) {
    return getPosts(pageSize).map((posts) {
      // Sort posts based on likeCount
      posts.sort((a, b) {
        final likeA = a['likeCount'] ?? 0;
        final likeB = b['likeCount'] ?? 0;
        return b['createdAt'].compareTo(a['createdAt']) == 0
            ? likeB
                .compareTo(likeA) // If createdAt is the same, sort by likeCount
            : b['createdAt']
                .compareTo(a['createdAt']); // Else, sort by createdAt
      });
      return posts;
    });
  }

  @override
  Future addCommentCount() {
    throw UnimplementedError();
  }

  @override
  Future updateLikeCount(String docId, int currentLikes) async {
    try {
      final docRef = _firestore.collection('posts').doc(docId);
      await docRef.update({'likesCount': FieldValue.increment(1)});
      await docRef
          .collection('likes')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'likedAt': Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future removeLikesCount(String docId, int currentLikes) async {
    try {
      final docRef = _firestore.collection('posts').doc(docId);
      await docRef.update({'likesCount': FieldValue.increment(-1)});
      await docRef
          .collection('likes')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future checkUserLike(String? postId) async {
    try {
      if (FirebaseAuth.instance.currentUser == null || postId == null) {
        return false;
      }
      final snapShot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapShot.exists) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> getPostById(String postId) {
    try {
      return _firestore.collection('posts').doc(postId).snapshots();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future addPost(Map<String, dynamic> payload) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        return false;
      }

      final userRef = _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      payload['userId'] = userRef;
      await _firestore.collection('posts').add(payload);
      return false;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getPostByUser(String? id) {
    if (id == null) {
      throw ArgumentError("User ID cannot be empty");
    }

    final userDocPath = _firestore.collection('users').doc(id);

    final snapshot = _firestore
        .collection('posts')
        .where('userId', isEqualTo: userDocPath)
        .orderBy('createdAt', descending: true)
        .snapshots();

    return snapshot;
  }

  @override
  Future deletePost(String? postId) async {
    try {
      if (postId == null) {
        return;
      }
      final postRef = _firestore.collection('posts').doc(postId);
      await postRef.delete();
      debugPrint("post has been deleted ");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future editPost(String postId, Map<String, dynamic> payload) {
    throw UnimplementedError();
  }

  @override
  Future updatePost(Map<String, dynamic> payload, String postId) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        return;
      }

      await _firestore.collection('posts').doc(postId).update(payload);
      return false;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getHybridFeedWithPagination(
    String? currentUserId,
    int pageSize,
  ) {
    if (currentUserId == null) {
      return _getTrendingPosts(pageSize);
    }

    return getFollowedUsers(currentUserId, 10)
        .asStream()
        .asyncMap((followedUserIds) async {
      if (followedUserIds.isNotEmpty) {
        final trendingPostsStream = _getTrendingPosts(pageSize);
        return trendingPostsStream;
      } else {
        return _getTrendingPosts(pageSize);
      }
    }).asyncExpand((postsStream) => postsStream);
  }

  @override
  Future<int> getTotalPosts() async {
    try {
      final ref =
          _firestore.collection('posts').orderBy('createdAt', descending: true);

      final snapshot = await ref.get();
      return snapshot.docs.length;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getAllPostOneTime(
      int pageSize) async {
    debugPrint("Page size is ${pageSize}");
    final now = DateTime.now();
    final ageAgo = now.subtract(const Duration(days: 30));
    return await _firestore
        .collection('posts')
        .where('createdAt', isGreaterThanOrEqualTo: ageAgo)
        .orderBy('likesCount', descending: true)
        .orderBy('commentsCount', descending: true)
        .orderBy('createdAt', descending: true)
        .limit(pageSize)
        .get();
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> getPostSocial(String postId) {
    return _firestore.collection('posts').doc(postId).snapshots();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getLatestPosts(pageSize) async {
    final now = DateTime.now();
    final ageAgo = now.subtract(const Duration(days: 30));

    return await _firestore
        .collection('posts')
        .where('createdAt', isGreaterThanOrEqualTo: ageAgo)
        .orderBy('createdAt', descending: true)
        .limit(4)
        .get();
  }
}
