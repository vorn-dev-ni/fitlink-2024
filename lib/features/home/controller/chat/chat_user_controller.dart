import 'package:demo/data/repository/firebase/user_chat_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/chat/chat_service.dart';
import 'package:demo/features/home/controller/chat/chat_loading_controller.dart';
import 'package:demo/features/home/model/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'chat_user_controller.g.dart';

@Riverpod(keepAlive: true)
class ChatUserController extends _$ChatUserController {
  late final UserChatRepository userChatRepository = UserChatRepository(
      baseService: ChatService(firebaseAuthService: FirebaseAuthService()));
  int _pageSize = 10;
  @override
  Stream<List<Chat>> build() {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      return Stream.value([]);
    }
    return userChatRepository.getUserChats(
        userId: FirebaseAuth.instance.currentUser?.uid ?? "",
        pageSize: _pageSize);
  }

  Future<void> loadNextMessages({required String userId}) async {
    try {
      final totalMessages =
          await userChatRepository.getUserChatsTotal(userId: userId);

      if (totalMessages <= _pageSize) {
        ref.read(chatLoadingControllerProvider.notifier).setState(false);
        return;
      }
      _pageSize = _pageSize + 10;
      ref.invalidateSelf();
      ref.read(chatLoadingControllerProvider.notifier).setState(false);
    } catch (e) {
      ref.read(chatLoadingControllerProvider.notifier).setState(false);

      rethrow;
    }
  }

  Future startMessaging(
      {required String senderId, required String receiverId}) async {
    try {
      await userChatRepository.startMessaging(
          senderId: senderId, receiverId: receiverId);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }
}
