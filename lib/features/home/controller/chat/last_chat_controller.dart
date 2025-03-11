import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/repository/firebase/user_chat_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/chat/chat_service.dart';
import 'package:demo/features/home/model/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'last_chat_controller.g.dart';

@Riverpod(keepAlive: true)
class LastChatController extends _$LastChatController {
  late UserChatRepository userChatRepository;
  final firestore = FirebaseFirestore.instance;

  @override
  Stream<Chat?> build({required String userId, required String currentId}) {
    try {
      userChatRepository = UserChatRepository(
          baseService: ChatService(firebaseAuthService: FirebaseAuthService()));
      debugPrint("User id is ${userId} ${currentId}");
      return getData(userId, currentId);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  // Future updateSeenchat(
  //     {required String chatId, required String currentId}) async {
  //   try {
  //     await userChatRepository.updateSeenChat(
  //         chatId: chatId, senderId: currentId);
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //     rethrow;
  //   }
  // }

  Stream<Chat?> getData(String userId, String currentId) async* {
    try {
      final currentRef = firestore.collection('users').doc(currentId);
      final receiverRef = firestore.collection('users').doc(userId);

      final snapshot = firestore
          .collection('chats')
          .where('participants', arrayContainsAny: [
            currentRef,
            receiverRef,
          ])
          .orderBy('lastMessageTimestamp', descending: true)
          .limit(1)
          .snapshots();

      await for (final querySnapshot in snapshot) {
        if (querySnapshot.docs.isEmpty) {
          // debugPrint("Null chat app");
          yield null;
        } else {
          final doc = querySnapshot.docs.first;
          // debugPrint("docis ${doc}");

          yield Chat.fromDocument(doc);
        }
      }
    } catch (e) {
      // debugPrint("Error fetching last chat: $e");
      rethrow;
    }
  }
}
