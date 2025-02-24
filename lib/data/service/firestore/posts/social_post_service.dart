// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

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
    final querySnapshot = _firestore.collection('posts').snapshots();
    return querySnapshot;
  }

  @override
  Future addCommentCount() {
    throw UnimplementedError();
  }

  @override
  Future editPost() {
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
  Future checkUserLike(String postId) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
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
}
