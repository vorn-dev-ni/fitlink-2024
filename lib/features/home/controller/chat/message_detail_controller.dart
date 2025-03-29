import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/repository/firebase/user_chat_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/chat/chat_service.dart';
import 'package:demo/data/service/firestore/notification/notification_service.dart';
import 'package:demo/features/home/controller/chat/chat_load_more.dart';
import 'package:demo/features/home/controller/chat/chat_loading_controller.dart';
import 'package:demo/features/home/controller/chat/user_header_controller.dart';
import 'package:demo/features/home/model/chat.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'message_detail_controller.g.dart';

@Riverpod(keepAlive: true)
class MessageDetailController extends _$MessageDetailController {
  late UserChatRepository userChatRepository;
  NotificationRemoteService notificationService =
      NotificationRemoteService(firebaseAuthService: FirebaseAuthService());
  int _pageSize = 20;
  @override
  Stream<List<Message>?> build(
      {required String senderId, required String receiverId, String? chatId}) {
    userChatRepository = UserChatRepository(
        baseService: ChatService(firebaseAuthService: FirebaseAuthService()));

    try {
      return getData();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  Future<String?> getChatId(
      {required String senderID, required String receiverID}) async {
    final chatResult =
        await userChatRepository.checkChatExist(senderID, receiverID);
    if (chatResult['chatId'] != false) {
      return chatResult['chatId'];
    }
    return null;
  }

  Future<void> loadNextMessages({
    required String senderId,
    required String receiverId,
    String? chatId,
  }) async {
    try {
      ref.read(chatLoadingControllerProvider.notifier).setState(true);

      final chatExists =
          await userChatRepository.checkChatExist(senderId, receiverId);

      final totalMessages =
          await userChatRepository.getTotalChat(chatId ?? chatExists['chatId']);

      if (totalMessages <= _pageSize) {
        ref.read(chatLoadMoreProvider.notifier).setState(true);
        ref.read(chatLoadingControllerProvider.notifier).setState(false);
        return;
      }

      ref.read(chatLoadingControllerProvider.notifier).setState(true);
      _pageSize = _pageSize + 30;
      ref.invalidateSelf();
      // if (state is AsyncData<List<Message>>) {
      //   final currentMessages = state.value ?? [];
      //   final updatedMessages = [...currentMessages];
      //   state = AsyncValue.data(
      //       updatedMessages); // Update the state with the new list
      // }
      ref.read(chatLoadMoreProvider.notifier).setState(true);
      ref.read(chatLoadingControllerProvider.notifier).setState(false);
    } catch (e) {
      ref.read(chatLoadMoreProvider.notifier).setState(true);
      ref.read(chatLoadingControllerProvider.notifier).setState(false);

      rethrow;
    }
  }

// d is Fii8JoCBZdN10hSLA05pYw6U9ug1 z2gKJwr8htdSenJzg1SmEHmDBwZ2
  Stream<List<Message>?> getData() async* {
    try {
      final chatExists =
          await userChatRepository.checkChatExist(senderId, receiverId);

      if (chatExists['chatId'] == false) {
        await userChatRepository.startNewChat(
            receiverID: receiverId, senderID: senderId, chatId: chatId ?? "");
        ref.invalidateSelf();
      } else {
        yield* userChatRepository.getUserMessage(
            senderID: FirebaseAuth.instance.currentUser?.uid ?? "",
            chatId: chatId ?? chatExists['chatId'],
            receiverID: receiverId,
            pageSize: _pageSize);
      }
    } catch (e) {
      ref.read(chatLoadingControllerProvider.notifier).setState(false);
      rethrow;
    }
  }

  Future sendChatNotification(
      {required String senderID,
      required String receiverID,
      required String chatId,
      required String text}) async {
    try {
      await notificationService.sendChatBetweenUsers(
          senderID, receiverID, chatId, text);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMessage({
    required String messageId,
    String? chatId,
    Message? lastMessage,
  }) async {
    try {
      await userChatRepository.deleteMessage(
          chatId: chatId!, messageId: messageId);
      final updatedChatId = chatId;
      final lastMessage =
          await userChatRepository.getUserLastMessage(chatId: updatedChatId);

      if (lastMessage != null) {
        await userChatRepository.updateLastMessage(
            updatedChatId, lastMessage, null);
      } else {
        await userChatRepository.clearLastMessage(updatedChatId);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to delete message');
      debugPrint('Error deleting message: $e');
      rethrow;
    }
  }

  Future<void> editMessage({
    required String senderId,
    required String receiverId,
    required String messageId,
    required String newText,
    required Message lastMessage,
    String? chatId,
  }) async {
    try {
      await userChatRepository.updateMessage(
          chatId!, messageId, newText, lastMessage);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to edit message');
      rethrow;
    }
  }

  Future sendMessage({
    required String senderId,
    String? receiverId,
    String? chatId,
    bool? isInChat,
    required String text,
  }) async {
    try {
      String tempChatId = chatId ?? "";
      final tempMsg = Message(
          content: text,
          timestamp: Timestamp.now(),
          otherUserInfo: {
            'fullName': "",
            'email': "",
            'isOnline': true,
            'lastSeen': Timestamp.now(),
            'avatar': "",
            "id": receiverId
          },
          type: MessageType.sending,
          readStatus: false,
          senderId: senderId,
          receiver: UserData(
            id: senderId,
          ));

      state = AsyncData([tempMsg, ...state.value ?? []]);

      await userChatRepository.sendMessaging(
          senderId: senderId, chatId: chatId ?? tempChatId, text: text);
      bool isUseronline = await ref
          .read(userHeaderControllerProvider(receiverId ?? "").notifier)
          .isUserOnline();

      if (!isUseronline) {
        await sendChatNotification(
            senderID: senderId,
            receiverID: receiverId ?? "",
            chatId: tempChatId,
            text: text);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }
}
