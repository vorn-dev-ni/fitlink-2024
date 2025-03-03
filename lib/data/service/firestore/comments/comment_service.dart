// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CommentService extends BaseCommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late FirebaseAuthService firebaseAuthService;
  CommentService({
    required this.firebaseAuthService,
  });
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllComments(
      String parentId, int? pageSize, DocumentSnapshot? lastDocument) {
    try {
      final ref = _firestore
          .collection('posts')
          .doc(parentId)
          .collection('comments')
          .orderBy('createdAt', descending: true);
      Query<Map<String, dynamic>> query =
          pageSize != null ? ref.limit(pageSize) : ref;

      // Use lastDocument for pagination

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      return query.snapshots();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future removeLikesCount(
      String parentId, String commentId, int currentLikes) async {
    try {
      final docRef = _firestore
          .collection('posts')
          .doc(parentId)
          .collection('comments')
          .doc(commentId);
      await docRef.update({'likesCount': FieldValue.increment(-1)});

      final twoRef = docRef
          .collection('likes')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      await twoRef.delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future updateLikeCount(
      String parentId, String commentId, int currentLikes) async {
    try {
      try {
        final docRef = _firestore
            .collection('posts')
            .doc(parentId)
            .collection('comments')
            .doc(commentId);
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
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future checkUserLike(String parentId, String commentId) async {
    try {
      final snapShot = await _firestore
          .collection('posts')
          .doc(parentId)
          .collection('comments')
          .doc(commentId)
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
  Future addComments(String parentId, String value, int commentCount) async {
    try {
      final userRef = _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      final postRef = _firestore.collection('posts').doc(parentId);
      await postRef.update({'commentsCount': FieldValue.increment(1)});
      await postRef.collection('comments').add(
        {
          'createdAt': Timestamp.now(),
          'likesCount': 0,
          'text': value.trim(),
          'userId': userRef
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future editComment(String parentId, String commentId, String value) async {
    try {
      final ref = _firestore.collection('posts').doc(parentId);
      await ref
          .collection('comments')
          .doc(commentId)
          .update({'text': value.trim()});
      debugPrint("Success updated comment $commentId");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getTotalComment(String parentId) async {
    try {
      final ref = _firestore
          .collection('posts')
          .doc(parentId)
          .collection('comments')
          .orderBy('createdAt', descending: true);

      final snapshot = await ref.get();
      return snapshot.docs.length;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future deleteComment(String parentId, String commentId) async {
    try {
      final ref = _firestore.collection('posts').doc(parentId);
      await ref.update({'commentsCount': FieldValue.increment(-1)});
      await ref.collection('comments').doc(commentId).delete();
      debugPrint("Success deleted comment $commentId");
    } catch (e) {
      rethrow;
    }
  }
}
