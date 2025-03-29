// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:demo/data/repository/firebase/video_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/video/video_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommentLikeController {
  late VideoRepository videoRepository;
  CommentLikeController() {
    videoRepository = VideoRepository(
      videoService: VideoService(firebaseAuthService: FirebaseAuthService()),
    );
  }

  Future likeVideoComment(String videoId, String commentId) async {
    try {
      await videoRepository.likeCommentVideo(videoId, commentId);
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  Future unLikedVideoComment(String videoId, String commentId) async {
    try {
      await videoRepository.unlikeCommentVideo(videoId, commentId);
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }
}
