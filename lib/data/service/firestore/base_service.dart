import 'package:cloud_firestore/cloud_firestore.dart';

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
  Future addCommentCount();
  Future editPost();
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
  );
  Future checkUserLike(
    String parentId,
    String commentId,
  );
  Future updateLikeCount(String parentId, String commentId, int currentLikes);
  Future removeLikesCount(String parentId, String commentId, int currentLikes);
}
