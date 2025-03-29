import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:demo/data/service/firestore/notification/notification_service.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:demo/features/home/model/chat.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatService extends ChatBaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late FirebaseAuthService firebaseAuthService;
  late NotificationRemoteService notificationRemoteService;

  ChatService({
    required this.firebaseAuthService,
  }) {
    NotificationRemoteService(firebaseAuthService: firebaseAuthService);
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUserChats(
      {required String userId, required int pageSize}) {
    try {
      final currentUserRef = _firestore.collection('users').doc(userId);
      return _firestore
          .collection('chats')
          .where('participants', arrayContains: currentUserRef)
          .where('lastMessage', isNotEqualTo: '')
          .orderBy('lastMessageTimestamp', descending: true)
          .limit(pageSize)
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> shareVideo({
    required String senderID,
    required String receiverID,
    required String videoId,
    required String videoUrl,
    required String thumbnailUrl,
    required String videoUserName,
    required String videoAvatarUser,
    String? text,
  }) async {
    try {
      String chatId;
      final chatResult = await checkIfChatExists(senderID, receiverID);
      if (chatResult['chatId'] != false) {
        chatId = chatResult['chatId'];
      } else {
        final newChatRef = _firestore.collection('chats').doc();
        chatId = newChatRef.id;
        final userDoc = _firestore.collection('users');
        final senderRef = userDoc.doc(senderID);
        final receiverRef = userDoc.doc(receiverID);
        await newChatRef.set({
          "lastMessage": text ?? "Shared a video.",
          "lastMessageTimestamp": FieldValue.serverTimestamp(),
          "participants": [senderRef, receiverRef],
          'createdAt': Timestamp.now(),
          "senderId": senderID,
          "last_read": {}
        });
      }

      final chatRef = _firestore.collection('chats').doc(chatId);
      final messageRef = chatRef.collection('messages').doc();
      final Timestamp timestamp = Timestamp.now();
      final bool hasText = text != null && text.trim().isNotEmpty;
      final String lastMessage = hasText ? text : "Shared a video.";

      final messageData = Message(
        content: text ?? "video",
        senderId: senderID,
        timestamp: timestamp,
        type: MessageType.video,
        videoUrl: videoUrl,
        videoAvatarUser: videoAvatarUser,
        videoUserName: videoUserName,
        videoId: videoId,
        thumbnailUrl: thumbnailUrl,
      ).toMap();

      WriteBatch batch = _firestore.batch();
      batch.set(
        chatRef,
        {
          "senderId": senderID,
          "lastMessage": lastMessage,
          "lastMessageTimestamp": timestamp,
        },
        SetOptions(merge: true),
      );

      batch.set(messageRef, messageData);
      Fluttertoast.showToast(msg: 'Video shared successfully.');
      //Unable later after testing
      // notificationRemoteService.sendChatBetweenUsers(senderID, receiverID,
      //     chatId, hasText ? text : 'Share a video to you');
      await batch.commit();
      debugPrint("Video shared successfully.");
    } catch (e, stackTrace) {
      debugPrint("Error sharing video: $e\n$stackTrace");
      rethrow;
    }
  }

  @override
  Future<void> submitChat({
    required String senderID,
    String? receiverID,
    required String chatId,
    required String messageText,
  }) async {
    try {
      final chatRef = _firestore.collection('chats').doc(chatId);
      final messageRef = chatRef.collection('messages').doc();
      final Timestamp timestamp = Timestamp.now();
      final messageData = Message(
        content: messageText,
        senderId: senderID,
        timestamp: timestamp,
        type: MessageType.text,
      ).toMap();

      WriteBatch batch = _firestore.batch();

      // Fluttertoast.showToast(msg: 'Sender is ${senderID}');
      batch.update(chatRef, {
        "senderId": senderID,
        "lastMessage": messageText,
        "lastMessageTimestamp": timestamp,
      });

      debugPrint("Run now");
      batch.set(messageRef, messageData);
      await batch.commit();
    } catch (e) {
      debugPrint("Error submitting chat: $e");
      rethrow;
    }
  }

  @override
  Future updateSeenChat(String chatId, String senderId) async {
    final chatRef = _firestore.collection('chats').doc(chatId);
    WriteBatch batch = _firestore.batch();
    batch.update(chatRef, {
      "last_read.$senderId": FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }

  @override
  Future<UserData> getUserFromReference(DocumentReference userRef) async {
    try {
      DocumentSnapshot userDoc = await userRef.get();

      if (userDoc.exists) {
        return UserData.fromJson(userDoc.data() as Map<String, dynamic>);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future firstTimeStartMessage(
      {required String senderId, required String receiverId}) async {
    try {
      final userDoc = _firestore.collection('users');
      final senderRef = userDoc.doc(senderId);
      final receiverRef = userDoc.doc(receiverId);

      await _firestore.collection('chats').add({
        "participants": [senderRef, receiverRef],
        'createdAt': Timestamp.now(),
        "senderId": senderId,
        'lastMessage': '',
        "last_read": {},
        'lastMessageTimestamp': Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> checkIfChatExists(
      String senderID, String receiverID) async {
    try {
      final senderRef = _firestore.collection('users').doc(senderID);
      final receiverRef = _firestore.collection('users').doc(receiverID);
      final snapshot = await FirebaseFirestore.instance
          .collection('chats')
          .where('participants',
              arrayContainsAny: [senderRef, receiverRef]).get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          List participants = doc['participants'];
          if (participants.contains(senderRef) &&
              participants.contains(receiverRef)) {
            return {'chatId': doc.id};
          }
        }
      }

      return {'chatId': false};
    } catch (e) {
      debugPrint("Error checking if chat exists: $e");
      return {'chatId': false};
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getTotalChat(String chatId) {
    try {
      return _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();
    } catch (e) {
      throw Exception("Error fetching total chat: $e");
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChatDetail(
      {required String senderID,
      required String receiverID,
      required pageSize,
      DocumentSnapshot? docs,
      required String chatId}) {
    try {
      final rawData = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(pageSize)
          .snapshots();

      return rawData;
    } catch (e) {
      debugPrint("Error fetching chat details: $e");
      rethrow;
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getTotalUserChats(
      {required String userId}) async {
    try {
      final currentUserRef = _firestore.collection('users').doc(userId);
      return _firestore
          .collection('chats')
          .where('participants', arrayContains: currentUserRef)
          .where('lastMessage', isNotEqualTo: '')
          .orderBy('createdAt', descending: true)
          .get();
    } catch (e) {
      throw Exception("Error fetching total chat: $e");
    }
  }

  @override
  Future<void> deleteMessage(
      {required String chatId, required String messageId}) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearLastMessage(String chatId) async {
    try {
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': FieldValue.delete(),
        'senderId': FieldValue.delete()
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future updateLastMessage(String chatId, Message lastMessage) async {
    try {
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': lastMessage.content,
        'senderId': FirebaseAuth.instance.currentUser?.uid ?? ""
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getUserLastMessage(
      {required String chatId}) async {
    try {
      return _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future updateUserMessage(
      {required String chatId,
      required String messageId,
      required String newText}) async {
    try {
      final messageRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId);
      await messageRef.update({
        'content': newText,
      });

      debugPrint("Message has been updated ${chatId} ${messageId} ${newText}");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> batchUpdateMessage(
      {required String chatId,
      required String messageId,
      required String newText,
      required Message lastMessage}) async {
    try {
      WriteBatch batch = _firestore.batch();

      DocumentReference messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId);

      batch.update(messageRef, {'content': newText.trim()});

      QuerySnapshot lastMessageSnapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (lastMessageSnapshot.docs.isNotEmpty) {
        final lastMessageDoc = lastMessageSnapshot.docs.first;
        final lastMessageId = lastMessageDoc.id;

        if (lastMessageId == lastMessage.id) {
          DocumentReference chatRef =
              _firestore.collection('chats').doc(chatId);
          batch.update(chatRef, {
            'lastMessage': newText.trim(),
            'senderId': FirebaseAuth.instance.currentUser?.uid ?? "",
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      }

      await batch.commit();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to edit message');
      debugPrint("Error updating message: $e");
      rethrow;
    }
  }
}
