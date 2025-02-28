import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationRemoteService extends NotificationBaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late FirebaseAuthService firebaseAuthService;
  NotificationRemoteService({
    required this.firebaseAuthService,
  });

  @override
  Future deleteNotification(String uid, String docId) {
    throw UnimplementedError();
  }

  @override
  Future getNotificationCurrentUser(String uid) {
    throw UnimplementedError();
  }

  @override
  Future postNotification(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .add(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendLikeNotification(
      String senderID, String receiverID, String postID) async {
    try {
      if (receiverID == FirebaseAuth.instance.currentUser?.uid) {
        //This case we prevent user from sending notification to their own
        return;
      }
      //Check only send notification to other not to your self
      final HttpsCallable callable = FirebaseFunctions.instance
          .httpsCallable('sendNotificationToSpecificUser');
      final response = await callable.call({
        'eventType': 'like',
        'senderID': senderID,
        'receiverID': receiverID,
        'postID': postID,
      });
      debugPrint('Notification sent: ${response.data}');
    } catch (e) {
      debugPrint('Error sending notification: $e');
    }
  }

  Future<void> removeFcmToken(String userId) async {
    try {
      await FirebaseMessaging.instance.deleteToken();
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': FieldValue.delete(),
      });
      debugPrint('FCM token removed successfully');
    } catch (e) {
      debugPrint('Error removing FCM token: $e');
    }
  }

  Future<void> storeFcmToken(String userId, String fcmToken) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final result = userDoc.data() as Map;
      String? existingFcmToken = result['fcmToken'];
      if (userDoc.exists && existingFcmToken != null) {
        if (existingFcmToken == fcmToken) {
          debugPrint('FCM token is the same. No update needed.');
          return; // No update needed
        }
      }
      await FirebaseFirestore.instance.collection('users').doc(userId).set(
        {'fcmToken': fcmToken},
        SetOptions(merge: true),
      );
      debugPrint('FCM token stored successfully');
    } catch (e) {
      debugPrint('Error storing FCM token: $e');
    }
  }

  @override
  Future<void> sendCommentNotification(
      String senderID, String receiverID, String postID) async {
    try {
      if (receiverID == FirebaseAuth.instance.currentUser?.uid) {
        //This case we prevent user from sending notification to their own
        return;
      }

      final HttpsCallable callable = FirebaseFunctions.instance
          .httpsCallable('sendNotificationToSpecificUser');
      debugPrint('Payload is ${senderID} ${receiverID} ${postID}');
      final response = await callable.call({
        'eventType': 'comment',
        'senderID': senderID,
        'receiverID': receiverID,
        'postID': postID,
      });
      debugPrint('Notification sent: ${response.data}');
    } catch (e) {
      debugPrint('Error sending notification: $e');
      rethrow;
    }
  }

  @override
  Future sendFollowingNotification(
      String senderID, String receiverID, String userId) async {
    try {
      if (receiverID == FirebaseAuth.instance.currentUser?.uid) {
        //This case we prevent user from sending notification to their own
        return;
      }

      final HttpsCallable callable = FirebaseFunctions.instance
          .httpsCallable('sendNotificationToSpecificUser');
      debugPrint('Payload is ${senderID} ${receiverID} ${userId}');
      final response = await callable.call({
        'eventType': 'following',
        'senderID': senderID,
        'receiverID': receiverID,
        'postID': userId,
      });
      debugPrint('Notification sent: ${response.data}');
    } catch (e) {
      debugPrint('Error sending notification: $e');
      rethrow;
    }
  }
}
