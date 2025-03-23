import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:demo/features/home/model/chat.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserChatRepository {
  late ChatBaseService baseService;

  UserChatRepository({
    required this.baseService,
  });
  Future<void> deleteMessage(
      {required String chatId, required String messageId}) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  Future<bool> shareVideo({
    required String senderID,
    required String receiverID,
    required String videoUrl,
    required String thumbnailUrl,
    required String videoId,
    String? text,
    required String videoUserName,
    required String videoAvatarUser,
  }) async {
    try {
      await baseService.shareVideo(
          senderID: senderID,
          receiverID: receiverID,
          videoUrl: videoUrl,
          text: text,
          videoAvatarUser: videoAvatarUser,
          videoUserName: videoUserName,
          videoId: videoId,
          thumbnailUrl: thumbnailUrl);

      return true;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
  }

  Future updateSeenChat(
      {required String chatId, required String senderId}) async {
    try {
      await baseService.updateSeenChat(chatId, senderId);
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> updateMessage(
  //     String chatId, String messageId, String newText) async {
  //   try {
  //     await baseService.updateUserMessage(
  //         chatId: chatId, messageId: messageId, newText: newText);
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'Failed to update message');
  //     rethrow; //Working earlier
  //   }
  // }
  Future<void> updateMessage(String chatId, String messageId, String newText,
      Message lastmessage) async {
    try {
      await baseService.batchUpdateMessage(
          chatId: chatId,
          messageId: messageId,
          newText: newText,
          lastMessage: lastmessage);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to update message');
      rethrow;
    }
  }

  Future<void> updateLastMessage(
      String chatId, Message lastMessage, String? newText) async {
    await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
      'lastMessage': newText ?? lastMessage.content,
      'lastMessageTimestamp': lastMessage.timestamp,
    });
  }

  Future<void> clearLastMessage(String chatId) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .update({'lastMessage': ""});
  }

  Stream<List<Chat>> getUserChats({
    required String userId,
    required int pageSize,
  }) {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('participants',
            arrayContains:
                FirebaseFirestore.instance.collection('users').doc(userId))
        .where('lastMessage', isNotEqualTo: "")
        .orderBy('lastMessageTimestamp', descending: true)
        .limit(pageSize)
        .snapshots()
        .asyncMap((snapshot) async {
      final chatsWithDetails = await Future.wait(snapshot.docs.map((doc) async {
        List<DocumentReference> participants =
            List<DocumentReference>.from(doc['participants']);
        DocumentReference? otherUserRef =
            participants.firstWhere((ref) => ref.id != userId);

        Map<String, dynamic>? otherUserInfo;
        final userDoc = await otherUserRef.get();

        if (userDoc.exists) {
          final otherUser = userDoc.data() as Map;
          otherUserInfo = {
            'id': userDoc.id,
            'fullName': otherUser['fullName'],
            'email': otherUser['email'],
            'isOnline': otherUser['isOnline'] ?? false,
            'lastSeen': (otherUser['lastSeen'] as Timestamp?)?.toDate() ??
                Timestamp.now(),
            'avatar': otherUser['avatar'] ?? ""
          };
        }

        final messagesSnapshot = await doc.reference
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        final messages = messagesSnapshot.docs.map((messageDoc) {
          return Message.fromMap(messageDoc.data());
        }).toList();

        return Chat.fromDocument(doc,
            messages: messages, otherParticipantInfo: otherUserInfo);
      }));

      return chatsWithDetails;
    });
  }

  Future<Message?> getUserLastMessage({required String chatId}) async {
    final data = await baseService.getUserLastMessage(chatId: chatId);

    if (data.docs.isNotEmpty) {
      final state = data.docs.first.data();
      return Message.fromMap({...state, 'id': data.docs.first.id});
    }

    return null; // Return null if no messages are found
  }

  Stream<List<Message>> getUserMessage({
    required String senderID,
    required String receiverID,
    required String chatId,
    bool isNewChat = false,
    required int pageSize,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  }) {
    return baseService
        .getUserChatDetail(
            chatId: chatId,
            receiverID: receiverID,
            senderID: senderID,
            pageSize: pageSize)
        .asyncMap((snapshot) async {
      final messagesWithDetails =
          await Future.wait(snapshot.docs.map((doc) async {
        final result = doc.data();
        final otherUserRef =
            FirebaseFirestore.instance.collection('users').doc(receiverID);
        Map<String, dynamic>? otherUserInfo;
        try {
          final userDoc = await otherUserRef.get();
          if (userDoc.exists) {
            final otherUser = userDoc.data() as Map;
            otherUserInfo = {
              'id': userDoc.id,
              'fullName': otherUser['fullName'],
              'email': otherUser['email'],
              'isOnline': otherUser['isOnline'] ?? false,
              'lastSeen': (otherUser['lastSeen'] as Timestamp?)?.toDate() ??
                  Timestamp.now(),
              'avatar': otherUser['avatar'] ?? ""
            };
          }
        } catch (e) {
          debugPrint("Error fetching receiver user info: $e");
        }

        // debugPrint("data ${doc} ");
        return Message.fromMap({
          ...result,
          'id': doc.id,
        }, otherUserInfo: otherUserInfo, snapshot: doc);
      }));
      return messagesWithDetails;
    });
  }

  Future<Map<String, dynamic>> checkChatExist(
      String senderID, String receiverID) async {
    try {
      final result = await baseService.checkIfChatExists(senderID, receiverID);
      return result;
    } catch (e) {
      debugPrint('Error checking if chat exists: $e');
      rethrow;
    }
  }

  Future<int> getTotalChat(String chatId) async {
    try {
      final data = await baseService.getTotalChat(chatId);
      return data.docs.length;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getUserChatsTotal({required String userId}) async {
    try {
      final data = await baseService.getTotalUserChats(userId: userId);
      return data.docs.length;
    } catch (e) {
      rethrow;
    }
  }

  Future startNewChat({
    required String senderID,
    required String receiverID,
    required String chatId,
  }) async {
    await startMessaging(senderId: senderID, receiverId: receiverID);
  }

  Future sendMessaging(
      {required String senderId,
      required String chatId,
      required String text}) async {
    try {
      await baseService.submitChat(
          chatId: chatId, messageText: text, senderID: senderId);
    } catch (e) {
      rethrow;
    }
  }

  Future startMessaging(
      {required String senderId, required String receiverId}) async {
    try {
      await baseService.firstTimeStartMessage(
          senderId: senderId, receiverId: receiverId);
    } catch (e) {
      rethrow;
    }
  }
}
