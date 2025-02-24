// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:demo/features/home/model/comment.dart';
import 'package:flutter/material.dart';

class CommentRepo {
  late BaseCommentService baseCommentService;
  CommentRepo({
    required this.baseCommentService,
  });
  Future updateLikeCount(
      String parentId, String docId, int currentLikes) async {
    try {
      await baseCommentService.updateLikeCount(parentId, docId, currentLikes);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getTotalItems(String parentId) async {
    try {
      return await baseCommentService.getTotalComment(parentId);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<bool> checkUserCommentLiked(
      {String? parentId = "", String? commentId = ""}) async {
    try {
      return await baseCommentService.checkUserLike(
          parentId ?? "", commentId ?? "");
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> addComment(
      {String? parentId = "", String? text = "", int? count}) async {
    try {
      return await baseCommentService.addComments(
          parentId ?? "", text ?? "", count ?? 0);
    } catch (e) {
      rethrow;
    }
  }

  Future removeLikeCount(
      String parentId, String docId, int currentLikes) async {
    try {
      await baseCommentService.removeLikesCount(parentId, docId, currentLikes);
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Comment>?> getAllCommentByPostId(
      String parentId, int pageSizes, DocumentSnapshot? lastDocs) {
    try {
      return baseCommentService
          .getAllComments(parentId, pageSizes, lastDocs)
          .asyncMap((snapshot) async {
        List<Comment> comments =
            await Future.wait(snapshot.docs.map((doc) async {
          if (doc.exists) {
            Map<String, dynamic> postData = doc.data();

            DocumentReference? userRef =
                postData['userId'] as DocumentReference?;
            Map<String, dynamic>? userData =
                userRef != null ? await extractUserData(userRef) : null;

            bool isLiked = await checkUserCommentLiked(
                commentId: doc.id, parentId: parentId);
            final obj = {
              'user': userData,
              'commentId': doc.id,
              'isLiked': isLiked,
              ...postData,
            };
            return Comment.fromJson(obj);
          }
          return Comment(commentId: '', createdAt: Timestamp.now(), text: '');
        }));
        return comments;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> extractUserData(DocumentReference ref) async {
    DocumentReference userRef = ref;
    final result = await userRef.get();
    if (result.exists) {
      return result.data() as Map<String, dynamic>;
    }
    return null;
  }
}
