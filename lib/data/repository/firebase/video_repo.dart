import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:demo/data/service/firestore/notification/notification_service.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VideoRepository {
  final VideoBaseService videoService;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _authUser = FirebaseAuth.instance;
  late NotificationRemoteService notificationRemoteService;

  VideoRepository({required this.videoService}) {
    notificationRemoteService =
        NotificationRemoteService(firebaseAuthService: FirebaseAuthService());
  }

  Future<List<VideoTikTok>> searchVideo({
    required String searchQuery,
    List<String>? tag,
  }) async {
    try {
      final snapshot =
          await videoService.searchVideo(search: searchQuery.trim(), tag: tag);
      final videos = await Future.wait(snapshot.docs.map((doc) async {
        final userRef = doc.data()['userRef'] as DocumentReference?;
        UserData? userData;
        if (userRef != null) {
          final result = await userRef.get();
          userData = UserData.fromJson(result.data() as Map<String, dynamic>);
        }
        return VideoTikTok.fromFirestore(doc, userData, paramsLiked: false);
      }));

      return videos;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteVideo(String videoId) async {
    try {
      final videoDocRef = _firebaseFirestore.collection('videos').doc(videoId);
      final videoDoc = await videoDocRef.get();

      if (!videoDoc.exists) {
        throw Exception("Video not found");
      }

      final videoData = videoDoc.data()!;
      final videoUrl = videoData['videoUrl'] as String?;
      final thumbnailUrl = videoData['thumbnailUrl'] as String?;

      if (videoUrl != null && videoUrl.isNotEmpty) {
        final videoPath = FirebaseStorage.instance.refFromURL(videoUrl);
        await videoPath.delete();
      }

      if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
        final thumbPath = FirebaseStorage.instance.refFromURL(thumbnailUrl);
        await thumbPath.delete();
      }

      await videoDocRef.delete();
    } catch (e) {
      throw Exception("Failed to delete video: $e");
    }
  }

  Stream<VideoTikTok> getVideoCounts(String videoId) {
    // Fluttertoast.showToast(msg: 'videoId ${videoId}');

    if (videoId == "") {
      return const Stream.empty();
    }

    return _firebaseFirestore
        .collection('videos')
        .doc(videoId)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.exists == true) {
        await Future.delayed(const Duration(milliseconds: 400));
        var hasLiked = await checkIfUserLiked(videoId);
        final userRef = snapshot.data()!['userRef'] as DocumentReference?;
        final userDoc = await userRef!.get();
        final result = userDoc.data() as Map<String, dynamic>;

        final resultUser = UserData.fromJson({'id': userDoc.id, ...result});
        if (LocalStorageUtils().getKey('uid') == '' ||
            LocalStorageUtils().getKey('uid') == null) {
          hasLiked = false;
        }
        return VideoTikTok.fromFirestore(snapshot, resultUser,
            paramsLiked: hasLiked);
      } else {
        return VideoTikTok(
          documentID: videoId,
          commentCount: 0,
          likeCount: 0,
          isUserliked: false,
          shareCount: 0,
        );
      }
    });
  }

  Future<VideoTikTok?> getVideoByIdOnce(String videoId) async {
    try {
      final doc =
          await _firebaseFirestore.collection('videos').doc(videoId).get();
      if (doc.exists) {
        await Future.delayed(const Duration(milliseconds: 400));

        final hasLiked = await checkIfUserLiked(videoId);
        final userRef = doc.data()!['userRef'] as DocumentReference?;

        final userDoc = await userRef!.get();
        final result = userDoc.data() as Map<String, dynamic>;
        final resultUser = UserData.fromJson({'id': userDoc.id, ...result});

        return VideoTikTok.fromFirestore(doc, resultUser,
            paramsLiked: hasLiked);
      }
      return null;
    } catch (e) {
      throw Exception("Failed to fetch video by ID: $e");
    }
  }

  Stream<List<VideoTikTok>> getVideosByUserId(String userId) {
    final userRef = _firebaseFirestore.collection('users').doc(userId);
    return _firebaseFirestore
        .collection('videos')
        .orderBy('createdAt', descending: true)
        .where('userRef', isEqualTo: userRef)
        .snapshots()
        .asyncMap((snapshot) async {
      List<VideoTikTok> videos = [];
      for (var doc in snapshot.docs) {
        final hasLiked = await checkIfUserLiked(doc.id);
        final userData = await userRef.get();
        final result = UserData.fromJson(userData.data()!);

        videos
            .add(VideoTikTok.fromFirestore(doc, result, paramsLiked: hasLiked));
      }
      return videos;
    });
  }

  Future<int> getVideoCommentCount(String videoId) async {
    final data = await _firebaseFirestore
        .collection('videos')
        .doc(videoId)
        .collection('comments')
        .get();

    return data.size;
  }

  Future<void> likeOrUnlike(
      String videoId, bool? isLiked, String? receiverID) async {
    try {
      if (_authUser.currentUser == null) {
        throw Exception("User is not authenticated");
      }
      bool alreadyLiked = await checkIfUserLiked(videoId);
      if (alreadyLiked) {
        await _unlikeVideo(videoId);
      } else {
        await _likeVideo(videoId, receiverID);
      }
    } catch (e) {
      throw Exception("Failed to like or unlike the video: $e");
    }
  }

  Future<void> _likeVideo(String videoId, String? receiverID) async {
    final userId = _authUser.currentUser?.uid;

    if (userId == null) throw Exception("User is not authenticated");
    final videoRef = _firebaseFirestore.collection('videos').doc(videoId);
    await videoRef.update({
      'likeCount': FieldValue.increment(1),
    });

    await videoRef.collection('likes').doc(userId).set({
      'likeAt': FieldValue.serverTimestamp(),
    });

    if (userId == receiverID) {
      //Dont send notificaiton to own video
      return;
    }
    await notificationRemoteService.sendVideoLikeOrComment(
        userId, receiverID ?? "", videoId, VideoTypeLike.like);
  }

  Future<void> _unlikeVideo(String videoId) async {
    final userId = _authUser.currentUser?.uid;
    if (userId == null) throw Exception("User is not authenticated");

    final videoRef = _firebaseFirestore.collection('videos').doc(videoId);
    await videoRef.update({
      'likeCount': FieldValue.increment(-1),
    });

    await videoRef.collection('likes').doc(userId).delete();
  }

  Future<bool> checkIfUserLiked(String videoId) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        return false;
      }
      if (videoId == "") {
        return false;
      }

      final videoDoc = await _firebaseFirestore
          .collection('videos')
          .doc(videoId)
          .collection('likes')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      return videoDoc.exists;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return false;
  }

  Future<void> likeCommentVideo(String videoId, String commentId) async {
    try {
      final userId = _authUser.currentUser?.uid;
      if (userId == null) return;

      final commentRef = _firebaseFirestore
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .doc(commentId);
      await commentRef.update({'likes': FieldValue.increment(1)});
      final likeRef = commentRef.collection('likes').doc(userId);
      await likeRef.set({
        'likeAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> unlikeCommentVideo(String videoId, String commentId) async {
    try {
      final userId = _authUser.currentUser?.uid;
      if (userId == null) return;

      final commentRef = _firebaseFirestore
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .doc(commentId);
      await commentRef.update({'likes': FieldValue.increment(-1)});
      final likeRef = commentRef.collection('likes').doc(userId);
      await likeRef.delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unlikeComment(String videoId, String commentId) async {
    final userId = _authUser.currentUser?.uid;
    if (userId == null) return;

    final likeRef = _firebaseFirestore
        .collection('videos')
        .doc(videoId)
        .collection('comments')
        .doc(commentId)
        .collection('likes')
        .doc(userId);

    await likeRef.delete();
  }

  Future<bool> checkCommentUserLiked(String videoId, String commentId) async {
    final userId = _authUser.currentUser?.uid;
    if (userId == null) return false;

    final videoDoc = await _firebaseFirestore
        .collection('videos')
        .doc(videoId)
        .collection('comments')
        .doc(commentId)
        .collection('likes')
        .doc(userId)
        .get();

    return videoDoc.exists;
  }

  // Add New Comment
  Future<DocumentReference<Map<String, dynamic>>> addComment(
      String videoId, String commentText, String? receiverID) async {
    try {
      // Ensure the user is logged in (check only if not already authenticated)
      if (_authUser.currentUser == null) {
        throw Exception("User is not authenticated");
      }

      String userId = _authUser.currentUser!.uid;
      String userName = _authUser.currentUser!.displayName ?? "Anonymous";

      var videoRef = _firebaseFirestore.collection('videos').doc(videoId);

      // Use a batch to combine the two writes into one
      WriteBatch batch = _firebaseFirestore.batch();

      // Add the new comment to the comments subcollection
      var commentRef = videoRef
          .collection('comments')
          .doc(); // Create a new document reference
      batch.set(commentRef, {
        'userId': userId,
        'userName': userName,
        'text': commentText,
        'createdAt': FieldValue.serverTimestamp(),
        'likes': 0,
      });

      // Increment the comment count in the video document
      batch.update(videoRef, {
        'commentCount': FieldValue.increment(1),
      });

      // Commit the batch operation
      await batch.commit();
      notificationRemoteService.sendVideoLikeOrComment(
          userId, receiverID ?? "", videoId, VideoTypeLike.comment);

      return commentRef; // Return the reference of the new comment
    } catch (e) {
      throw Exception("Failed to add comment: $e");
    }
  }

  // Edit Existing Comment
  Future<void> editComment(
      String videoId, String commentId, String newText) async {
    try {
      // Ensure the user is logged in
      if (_authUser.currentUser == null) {
        throw Exception("User is not authenticated");
      }

      // Reference the comment document in the comments subcollection
      var commentDoc = await _firebaseFirestore
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .doc(commentId)
          .get();

      if (commentDoc.exists) {
        // Check if the current user is the owner of the comment
        if (commentDoc['userId'] == _authUser.currentUser?.uid) {
          // Update the comment text
          await commentDoc.reference.update({'text': newText});
        } else {
          throw Exception("You can only edit your own comments");
        }
      } else {
        throw Exception("Comment not found");
      }
    } catch (e) {
      throw Exception("Failed to edit comment: $e");
    }
  }

  // Delete Comment
  Future<void> deleteComment(String videoId, String commentId) async {
    try {
      if (_authUser.currentUser == null) {
        throw Exception("User is not authenticated");
      }

      var commentDoc = await _firebaseFirestore
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .doc(commentId)
          .get();

      if (commentDoc.exists) {
        if (commentDoc['userId'] == _authUser.currentUser?.uid) {
          await commentDoc.reference.delete();
          _firebaseFirestore
              .collection('videos')
              .doc(videoId)
              .update({'commentCount': FieldValue.increment(-1)});
        } else {
          throw Exception("You can only delete your own comments");
        }
      } else {
        throw Exception("Comment not found");
      }
    } catch (e) {
      throw Exception("Failed to delete comment: $e");
    }
  }

  Future<void> likeComment(String videoId, String commentId) async {
    try {
      if (_authUser.currentUser == null) {
        throw Exception("User is not authenticated");
      }
      var videoRef = _firebaseFirestore.collection('videos').doc(videoId);
      await videoRef.update({'likeCount': FieldValue.increment(1)});
      var commentDoc =
          await videoRef.collection('comments').doc(commentId).get();

      if (commentDoc.exists) {
        debugPrint("Prevent liking spam");
      } else {
        await videoRef
            .collection('likes')
            .doc(_authUser.currentUser?.uid)
            .set({'likeAt': Timestamp.now()});
      }
    } catch (e) {
      throw Exception("Failed to like comment: $e");
    }
  }

  Future<void> disLikeComment(String videoId, String commentId) async {
    try {
      if (_authUser.currentUser == null) {
        throw Exception("User is not authenticated");
      }
      final videoRef = _firebaseFirestore.collection('videos').doc(videoId);
      await videoRef.update({'likeCount': FieldValue.increment(-1)});
      final commentDoc = await videoRef
          .collection('likes')
          .doc(_authUser.currentUser?.uid)
          .get();
      if (commentDoc.exists) {
        await videoRef
            .collection('likes')
            .doc(_authUser.currentUser?.uid)
            .delete();
      }
    } catch (e) {
      throw Exception("Failed to like comment: $e");
    }
  }

  Future<List<VideoTikTok>> fetchVideos({
    required int page,
    DocumentSnapshot? startAfter,
  }) async {
    final snapshot =
        await videoService.fetchVideos(page: page, startAfter: startAfter);

    List<VideoTikTok> videos = [];

    for (var doc in snapshot.docs) {
      final userRef = doc.data()['userRef'] as DocumentReference?;

      UserData? user;

      // If userRef exists, fetch user data
      if (userRef != null) {
        final userDoc = await userRef.get();
        if (userDoc.exists) {
          final result = userDoc.data() as Map<String, dynamic>;
          user = UserData.fromJson({'id': userDoc.id, ...result});
        }
      }

      videos.add(VideoTikTok.fromFirestore(doc, user, newVideoplayer: null));
    }

    return videos;
  }

  // Future<List<VideoTikTok>> fetchVideos({
  //   required int page,
  //   DocumentSnapshot? startAfter,
  // }) async {
  //   final snapshot =
  //       await videoService.fetchVideos(page: page, startAfter: startAfter);

  //   List<VideoTikTok> videos = [];

  //   for (var doc in snapshot.docs) {
  //     final userRef = doc.data()['userRef'] as DocumentReference?;

  //     UserData? user;

  //     // If userRef exists, fetch user data
  //     if (userRef != null) {
  //       final userDoc = await userRef.get();
  //       if (userDoc.exists) {
  //         final result = userDoc.data() as Map<String, dynamic>;
  //         user = UserData.fromJson({'id': userDoc.id, ...result});
  //       }
  //     }

  //     videos.add(VideoTikTok.fromFirestore(doc, user));
  //   }

  //   return videos;
  // }

  Future setViewCount(String videoId) async {
    try {
      await videoService.trackView(videoId, _authUser.currentUser?.uid);
    } catch (e) {
      rethrow;
    }
  }

  Future setShareCount(String videoId) async {
    try {
      await videoService.shareVideo(videoId, _authUser.currentUser?.uid ?? "");
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<CommentTikTok>> fetchComments(
    String videoId,
    int limit,
    DocumentSnapshot? startAfter,
  ) {
    return videoService
        .fetchCommentVideo(videoId, limit: limit, startAfter: startAfter)
        .asyncMap((snapshot) async {
      List<CommentTikTok> comments = [];

      for (var doc in snapshot.docs) {
        var commentData = doc.data();
        var userId = doc.data()['userId'];
        bool isUserliked = await checkCommentUserLiked(videoId, doc.id);

        var comment = CommentTikTok.fromJson({
          ...commentData,
          'id': doc.id,
        }, lastDoc: doc, paramLiked: isUserliked);

        var userDoc =
            await _firebaseFirestore.collection('users').doc(userId).get();

        if (userDoc.exists) {
          var user = UserData.fromJson(userDoc.data()!);
          comment.userData = user;
        }

        comments.add(comment);
      }

      return comments;
    });
  }

  Future<List<CommentTikTok>> fetchCommentsOneTime(
    String videoId,
    int limit,
    DocumentSnapshot? startAfter,
  ) async {
    try {
      final snapshot = await videoService.fetchCommentOneTime(videoId,
          limit: limit, startAfter: startAfter);

      List<CommentTikTok> comments = [];

      for (var doc in snapshot.docs) {
        var commentData = doc.data();
        var userId = doc.data()['userId'];

        bool isUserliked = await checkCommentUserLiked(videoId, doc.id);

        var comment = CommentTikTok.fromJson({
          ...commentData,
          'id': doc.id,
        }, lastDoc: doc, paramLiked: isUserliked);

        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          var user = UserData.fromJson({'id': userDoc.id, ...userDoc.data()!});
          comment.userData = user;
        }

        comments.add(comment);
      }

      return comments;
    } catch (e) {
      rethrow;
    }
  }

  void navigatingBackHome(WidgetRef ref) {
    HelpersUtils.navigatorState(ref.context).pop();
    HelpersUtils.navigatorState(ref.context).pop();
  }
}
