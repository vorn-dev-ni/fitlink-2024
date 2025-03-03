import 'package:demo/data/service/firestore/base_service.dart';

class NotificationRepo {
  late NotificationBaseService notificationBaseService;
  NotificationRepo({
    required this.notificationBaseService,
  });
  Future sendCommentNotification(
      {required String senderID,
      required String receiverID,
      required String postId}) async {
    try {
      await notificationBaseService.sendCommentNotification(
          senderID, receiverID, postId);
    } catch (e) {
      rethrow;
    }
  }

  Future sendCommentLikedNotification(
      {required String senderID,
      required String receiverID,
      required String postId}) async {
    try {
      await notificationBaseService.sendCommentNotification(
          senderID, receiverID, postId);
    } catch (e) {
      rethrow;
    }
  }

  Future sentFollowingNotification(
      {required String senderID,
      required String receiverID,
      required String userId}) async {
    try {
      await notificationBaseService.sendFollowingNotification(
          senderID, receiverID, userId);
    } catch (e) {
      rethrow;
    }
  }

  Future sendLikeNotification(
      {required String senderID,
      required String receiverID,
      required String postId}) async {
    try {
      await notificationBaseService.sendLikeNotification(
          senderID, receiverID, postId);
    } catch (e) {
      rethrow;
    }
  }
}
