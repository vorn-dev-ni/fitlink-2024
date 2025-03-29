import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VideoService extends VideoBaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late FirebaseAuthService firebaseAuthService;

  VideoService({
    required this.firebaseAuthService,
  });

  @override
  Future<void> commentOnVideo(
      Pattern videoId, String userId, String comment) async {
    try {
      // Add comment to the video document in Firestore
      DocumentReference videoRef =
          _firestore.collection('videos').doc(videoId.toString());
      await videoRef.collection('comments').add({
        'userId': userId,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to comment on video: $e");
    }
  }

  @override
  Future<void> createVideo(Map<String, dynamic> videoData) async {
    try {
      await _firestore.collection('videos').add(videoData);
    } catch (e) {
      throw Exception("Failed to create video: $e");
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos(
      {required int page, DocumentSnapshot? startAfter}) async {
    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection('videos')
          .orderBy('createdAt', descending: true)
          .orderBy('likeCount', descending: true)
          .orderBy('viewCount', descending: true)
          .orderBy('shareCount', descending: true)
          .limit(page);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();
      return snapshot;
    } catch (e) {
      throw Exception('Error fetching videos: ${e.toString()}');
    }
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getVideoById(
      String videoId) async {
    try {
      return await _firestore.collection('videos').doc(videoId).get();
    } catch (e) {
      throw Exception("Failed to fetch video by ID: $e");
    }
  }

  @override
  Future<void> likeVideo(String videoId, String userId) async {
    try {
      DocumentReference videoRef = _firestore.collection('videos').doc(videoId);
      await videoRef.update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw Exception("Failed to like video: $e");
    }
  }

  @override
  Future<void> shareVideo(String videoId, String? userId) async {
    try {
      if (userId == null) {
        return;
      }
      DocumentReference videoRef = _firestore.collection('videos').doc(videoId);
      final shareRef = videoRef.collection('shares').doc(userId);
      final previousView = await shareRef.get();
      if (previousView.exists) {
        return;
      }
      await shareRef.set({'shareAt': Timestamp.now()});
      await videoRef.update({
        'shareCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception("Failed to track view: $e");
    }
  }

  @override
  Future<void> trackView(String videoId, String? userId) async {
    try {
      if (userId == null) {
        // We dont add the view again
        return;
      }
      DocumentReference videoRef = _firestore.collection('videos').doc(videoId);
      final viewRef = videoRef.collection('views').doc(userId);
      final previousView = await viewRef.get();
      if (previousView.exists) {
        // We dont add the view again
        return;
      }
      await viewRef.set({'viewAt': Timestamp.now()});
      await videoRef.update({
        'viewCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception("Failed to track view: $e");
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchCommentVideo(
    String videoId, {
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) {
    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .limit(200);

      return query.snapshots();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> fetchCommentOneTime(
      String videoId,
      {int limit = 100,
      DocumentSnapshot<Object?>? startAfter}) async {
    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      return await query.get();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> searchVideo({
    required String search,
    List<String>? tag,
  }) async {
    try {
      String searchTerm = search.toLowerCase();

      Query<Map<String, dynamic>> query =
          _firestore.collection('videos').limit(300);
      if (tag != null && tag.isNotEmpty) {
        query = query.where('tag', arrayContainsAny: tag);
      }

      if (searchTerm.isNotEmpty) {
        query = query
            .orderBy('caption_lower_case')
            .startAt([searchTerm]).endAt(['$searchTerm\uf8ff']);
      }

      debugPrint("query is ${query}");
      final data = await query.get();

      return data;
    } catch (e) {
      rethrow;
    }
  }
}
