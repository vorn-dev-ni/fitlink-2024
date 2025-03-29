import 'package:demo/data/repository/firebase/notification_repo.dart';
import 'package:demo/data/repository/firebase/user_chat_repo.dart';
import 'package:demo/data/repository/firebase/video_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/chat/chat_service.dart';
import 'package:demo/data/service/firestore/notification/notification_service.dart';
import 'package:demo/data/service/firestore/video/video_service.dart';
import 'package:demo/features/home/model/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';
part 'video_share_controller.g.dart';

@Riverpod(keepAlive: true)
class VideoShareController extends _$VideoShareController {
  late UserChatRepository userChatRepository;
  VideoPlayerController? videoplayer;
  late VideoRepository videoRepository;
  late NotificationRepo notificationRepo;

  @override
  void build() {
    notificationRepo = NotificationRepo(
        notificationBaseService: NotificationRemoteService(
            firebaseAuthService: FirebaseAuthService()));
    userChatRepository = UserChatRepository(
      baseService: ChatService(firebaseAuthService: FirebaseAuthService()),
    );

    videoRepository = VideoRepository(
        videoService: VideoService(firebaseAuthService: FirebaseAuthService()));
    return;
  }

  Future onShareVideo(Message message, String receiverId, String videoId,
      {required String avatar, required String fullName}) async {
    final success = await userChatRepository.shareVideo(
      videoId: videoId,
      senderID: FirebaseAuth.instance.currentUser?.uid ?? "",
      receiverID: receiverId,
      text: message.content,
      videoUserName: fullName,
      videoAvatarUser: avatar,
      videoUrl: message.videoUrl ?? "",
      thumbnailUrl: message.thumbnailUrl ?? "",
    );
    if (success) {
      await videoRepository.setShareCount(videoId);
    }
  }
}
