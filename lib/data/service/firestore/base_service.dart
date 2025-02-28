import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/features/home/views/single_profile/model/media_count.dart';

abstract class BaseService {
  Future delete({required String uid});
  Future save(Map<String, dynamic> data);
  Future update();
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllRealTime();
  CollectionReference<Map<String, dynamic>> getAllOneTime();
  Future getById({required String uid});
  Future joinEvents(String docId);

  Future uploadCertificate(Map<String, dynamic> data);
}

abstract class BaseUserService {
  Future updateCoverImage(Map<String, dynamic> data);
  Future updateProfile(Map<String, dynamic> data);
  Future followUser(String followedUserId);
  Future isFollowingUser(String followedUserId);
  Future unfollowUser(String followedUserId);
  Future<MediaCount> getMediaCount(String userId);
}

abstract class BaseActivitiesService {
  Future updateUserWorkout(Map<String, dynamic> data);
  Future updateProcessUser(String id, DateTime date, Map<String, dynamic> data);
  Future updateUserActivity(String docId, Map<String, dynamic> data);

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllRealTime();
  CollectionReference<Map<String, dynamic>> getAllOneTime();
}

abstract class BaseSocialMediaService {
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPosts();
  Stream<QuerySnapshot<Map<String, dynamic>>> getPostByUser(String id);
  Future deletePost(
    String postId,
  );
  Future addCommentCount();
  Future editPost(String postId, Map<String, dynamic> payload);
  Future addPost(Map<String, dynamic> payload);
  Future updatePost(Map<String, dynamic> payload, String postId);

  Stream<DocumentSnapshot<Map<String, dynamic>>> getPostById(String postId);
  Future checkUserLike(String postId);
  Future updateLikeCount(String docId, int currentLikes);
  Future removeLikesCount(String docId, int currentLikes);
}

abstract class BaseCommentService {
  Future getTotalComment(String parentId);
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllComments(
      String parentId, int? pageSize, DocumentSnapshot? lastDocument);
  Future addComments(String parentId, String value, int commentCount);
  Future editComment(String parentId, String commentId, String value);
  Future deleteComment(
    String parentId,
    String commentId,
  );
  Future checkUserLike(
    String parentId,
    String commentId,
  );
  Future updateLikeCount(String parentId, String commentId, int currentLikes);
  Future removeLikesCount(String parentId, String commentId, int currentLikes);
}

abstract class NotificationBaseService {
  Future sendFollowingNotification(
      String senderID, String receiverID, String userId);
  Future getNotificationCurrentUser(String uid);
  Future sendCommentNotification(
      String senderID, String receiverID, String postID);
  Future sendLikeNotification(
      String senderID, String receiverID, String postID);
  Future deleteNotification(String uid, String docId);
}
