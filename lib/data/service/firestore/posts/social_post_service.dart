// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPosts() {
    final querySnapshot = _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
    return querySnapshot;
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
  Stream<QuerySnapshot<Map<String, dynamic>>> getPostByUser(String id) {
    if (id.isEmpty) {
      throw ArgumentError("User ID cannot be empty");
    }

    final userDocPath = _firestore.collection('users').doc(id);

    final snapshot = _firestore
        .collection('posts')
        .where('userId', isEqualTo: userDocPath) // Compare with stored path
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
    // TODO: implement editPost
    throw UnimplementedError();
  }

  @override
  Future updatePost(Map<String, dynamic> payload, String postId) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        return;
      }

      debugPrint("UPdate post with ${payload} ${postId}");
      await _firestore.collection('posts').doc(postId).update(payload);
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
