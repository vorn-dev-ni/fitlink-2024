import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/features/home/model/chat.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/features/home/views/single_profile/model/media_count.dart';
import 'package:demo/utils/constant/enums.dart';

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
  Stream<int> getNotificationCount(String? userId);
  Future isFollowingUser(String followedUserId);
  Future unfollowUser(String followedUserId);
  Future<MediaCount> getMediaCount(String userId);
  Future<void> setUserOnline(String? userId);
  Future<void> setUserOffline(String? userId);
  Future<DocumentSnapshot> getUserDetailById(String userId);
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserFriendsList();
  Future<QuerySnapshot<Map<String, dynamic>>> getUserFollowings();

  Stream<DocumentSnapshot> getUserStatus(String? userId);
  Future<DocumentSnapshot> getUserOnlineStatus(String? userId);

  Stream<QuerySnapshot<Map<String, dynamic>>> listenUserCollections();
}

abstract class BaseActivitiesService {
  Future updateUserWorkout(Map<String, dynamic> data);
  Future updateProcessUser(String id, DateTime date, Map<String, dynamic> data);
  Future updateUserActivity(String docId, Map<String, dynamic> data);

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllRealTime();
  CollectionReference<Map<String, dynamic>> getAllOneTime();
}

abstract class BaseSocialMediaService {
  Future<QuerySnapshot<Map<String, dynamic>>> getLatestPosts(pageSize);
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPosts();
  Future<int> getTotalPosts();
  Stream<DocumentSnapshot<Map<String, dynamic>>> getPostSocial(String postId);

  Future<QuerySnapshot<Map<String, dynamic>>> getAllPostOneTime(int pageSize);

  Stream<QuerySnapshot<Map<String, dynamic>>> getHybridFeedWithPagination(
    String? currentUserId,
    int pageSize,
  );
  Stream<QuerySnapshot<Map<String, dynamic>>> getPostByUser(String? id);
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
  Future<QuerySnapshot<Map<String, dynamic>>> getNotificationByUser(
    String userId, {
    DocumentSnapshot? lastDoc,
    int limit = 10,
  });
  Future sendFollowingNotification(
      String senderID, String receiverID, String userId);
  Future getNotificationCurrentUser(String uid);
  Future sendAlertEventInterestNotification(
      String senderID, String receiverID, String postID);
  Future sendCommentNotification(
      String senderID, String receiverID, String postID);
  Future sendLikeCommentNotification(
      String senderID, String receiverID, String postID);
  Future sendLikeNotification(
      String senderID, String receiverID, String postID);
  Future sendChatBetweenUsers(
      String senderID, String receiverID, String chatId, String text);
  Future deleteNotification(String uid, String docId);
  Future sendVideoLikeOrComment(
      String senderID, String receiverID, String postID, VideoTypeLike type);
}

abstract class VideoBaseService {
  Future<QuerySnapshot<Map<String, dynamic>>> searchVideo(
      {required String search, List<String>? tag});
  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos(
      {required int page, DocumentSnapshot? startAfter});
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchCommentVideo(
    String videoId, {
    int limit = 10,
    DocumentSnapshot? startAfter,
  });
  Future<QuerySnapshot<Map<String, dynamic>>> fetchCommentOneTime(
    String videoId, {
    int limit = 10,
    DocumentSnapshot? startAfter,
  });
  Future<void> createVideo(Map<String, dynamic> videoData);
  Future<void> likeVideo(String videoId, String userId);

  Future<void> shareVideo(String videoId, String userId);

  Future<void> commentOnVideo(String videoId, String userId, String comment);

  Future<void> trackView(String videoId, String? userId);

  Future getVideoById(String videoId);
}

abstract class ChatBaseService {
  Future updateSeenChat(String chatId, String senderId);
  Future<Map<String, dynamic>> checkIfChatExists(
      String senderID, String receiverID);
  Future<QuerySnapshot<Map<String, dynamic>>> getTotalChat(String chatId);
  Future<QuerySnapshot<Map<String, dynamic>>> getTotalUserChats(
      {required String userId});
  Future<QuerySnapshot<Map<String, dynamic>>> getUserLastMessage(
      {required String chatId});
  Future firstTimeStartMessage(
      {required String senderId, required String receiverId});
  Future<UserData> getUserFromReference(DocumentReference userRef);
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUserChats(
      {required String userId, required int pageSize});
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChatDetail(
      {required String senderID,
      required String receiverID,
      required pageSize,
      DocumentSnapshot? docs,
      required String chatId});
  Future<void> batchUpdateMessage({
    required String chatId,
    required String messageId,
    required String newText,
    required Message lastMessage,
  });
  Future<void> clearLastMessage(String chatId);
  Future<void> updateLastMessage(String chatId, Message lastMessage);
  Future<void> deleteMessage(
      {required String chatId, required String messageId});
  Future<void> submitChat({
    required String senderID,
    String? receiverID,
    required String chatId,
    required String messageText,
  });
  Future<void> shareVideo({
    required String senderID,
    required String receiverID,
    required String videoUrl,
    required String videoId,
    String? text,
    required String videoUserName,
    required String videoAvatarUser,
    required String thumbnailUrl,
  });

  Future updateUserMessage(
      {required String chatId,
      required String messageId,
      required String newText});
}
