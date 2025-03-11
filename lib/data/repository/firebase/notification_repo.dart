import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:demo/features/notifications/model/notification_model.dart';
import 'package:demo/utils/constant/enums.dart';

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

  Future<List<NotificationModel>> getNotificationByUser(
      String userId, int limit, DocumentSnapshot? lastDocument) async {
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

      List<NotificationModel> notifications = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();

        DocumentSnapshot senderSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(data['senderID'])
            .get();

        String fullName = senderSnapshot.exists
            ? senderSnapshot.get('fullName') ?? "Unknown User"
            : "Unknown User";

        String avatar =
            senderSnapshot.exists ? senderSnapshot.get('avatar') ?? "" : "";

        bool hasFollow = false;
        if (data['type'] == NotificationType.following.name) {
          DocumentSnapshot followingDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('following')
              .doc(data['senderID'])
              .get();
          hasFollow = followingDoc.exists;
        }

        notifications.add(NotificationModel(
          postID: data['postID'],
          read: data['read'],
          lastDoc: doc,
          senderID: data['senderID'],
          timestamp: data['timestamp'],
          type: NotificationTypeMapper.fromString(data['type']) ??
              NotificationType.chat,
          fullName: fullName,
          avatar: avatar,
          hasFollow: hasFollow,
        ));
      }

      return notifications;
    } catch (e) {
      rethrow;
    }
  }

  Future sendCommentLikedNotification(
      {required String senderID,
      required String receiverID,
      required String postId}) async {
    try {
      await notificationBaseService.sendLikeCommentNotification(
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

  Future sendChatNotificationBetweenUser(
      {required String senderID,
      required String receiverID,
      required String chatId,
      required String text}) async {
    try {
      await notificationBaseService.sendChatBetweenUsers(
          senderID, receiverID, chatId, text);
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
