import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/data/repository/firebase/video_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/video/video_service.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/features/home/controller/video/comment/comment_loading_tiktok.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_video_controller.g.dart';

@Riverpod(keepAlive: false)
class TiktokCommentController extends _$TiktokCommentController {
  late VideoRepository videoRepository;
  int _limit = 7;
  DocumentSnapshot? _lastDoc;
  String? _videoId;
  bool _hasMore = true;
  bool _isFetching = false;

  @override
  Future<List<CommentTikTok>> build(String videoId) async {
    _videoId = videoId;
    videoRepository = VideoRepository(
      videoService: VideoService(firebaseAuthService: FirebaseAuthService()),
    );
    clearState();
    return await getComments();
  }

  void clearState() {
    _limit = 10;
    _lastDoc = null;
    _hasMore = true;
    _isFetching = false;
  }

  Future toggleLike({bool? alreadyLiked, String? receiverID}) async {
    try {
      await videoRepository.likeOrUnlike(videoId, alreadyLiked, receiverID);
      // ref.invalidate(socialInteractonVideoControllerProvider(videoId));
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  Future writeComment(String newComment, String? receiverID) async {
    try {
      final currentState = state.value ?? [];
      final user = await ref.read(profileUserControllerProvider.future);

      state = AsyncData([
        CommentTikTok(
          createdAt: Timestamp.now(),
          documentId: '',
          isLiked: false,
          lastDoc: null,
          likes: 0,
          isLoading: true,
          text: newComment,
          userData: UserData(avatar: user?.avatar, fullName: user?.fullname),
        ),
        ...currentState,
      ]);

      final resultId =
          await videoRepository.addComment(videoId, newComment, receiverID);

      state = AsyncData([
        CommentTikTok(
          createdAt: Timestamp.now(),
          documentId: resultId.id,
          isLiked: false,
          // lastDoc: await resultId.get(),
          lastDoc: null,
          likes: 0,
          isLoading: false,
          text: newComment,
          userData: UserData(
              avatar: user?.avatar, fullName: user?.fullname, id: user?.id),
        ),
        ...currentState,
      ]);
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  Future deleteComment(String commentId) async {
    try {
      ref.read(commentLoadingTiktokProvider.notifier).setState(true);
      state = AsyncValue.data([
        ...?state.value?.where((element) => element.documentId != commentId)
      ]);
      await videoRepository.deleteComment(videoId, commentId);

      ref.read(commentLoadingTiktokProvider.notifier).setState(false);
      Fluttertoast.showToast(msg: 'Comment has been deleted.');
    } catch (error) {
      ref.read(commentLoadingTiktokProvider.notifier).setState(false);

      Fluttertoast.showToast(msg: error.toString());
    }
  }

  Future editComment(String id, String newComment) async {
    try {
      await videoRepository.editComment(videoId, id, newComment);
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  Future loadMoreComments() async {
    if (!_hasMore || _isFetching) return;

    _isFetching = true;

    try {
      ref.read(commentLoadingTiktokProvider.notifier).setState(true);

      final comments = await videoRepository.fetchCommentsOneTime(
        _videoId!,
        _limit,
        _lastDoc,
      );

      if (comments.isNotEmpty) {
        _lastDoc = comments.last.lastDoc;
        _hasMore = true;
      } else {
        _hasMore = false;
        // clearState();
      }

      final currentState = state.value ?? [];
      state = AsyncData([...currentState, ...comments]);
      ref.read(commentLoadingTiktokProvider.notifier).setState(false);
      _isFetching = false;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      ref.read(commentLoadingTiktokProvider.notifier).setState(false);

      rethrow;
    } finally {
      _isFetching = false;
    }
  }

  Future likeVideoComment(String videoId, String commentId) async {
    try {
      // Before updating the state, get the current state
      final currentState = state.value ?? [];

      // Find the comment that is being liked
      final updatedComments = currentState.map((comment) {
        if (comment.documentId == commentId) {
          // Update the comment's isLiked status and increment the like count
          return CommentTikTok(
            documentId: comment.documentId,
            createdAt: comment.createdAt,
            text: comment.text,
            likes: (comment.likes ?? 0) + 1,
            isLiked: true, // Comment is now liked
            // lastDoc: comment.lastDoc,
            userData: comment.userData,
            isLoading: false,
          );
        }
        return comment;
      }).toList();

      // Update the state
      state = AsyncData(updatedComments);

      // Perform the like operation
      await videoRepository.likeCommentVideo(videoId, commentId);
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  Future unLikedVideoComment(String videoId, String commentId) async {
    try {
      final currentState = state.value ?? [];

      final updatedComments = currentState.map((comment) {
        if (comment.documentId == commentId) {
          return CommentTikTok(
            documentId: comment.documentId,
            createdAt: comment.createdAt,
            text: comment.text,
            likes: (comment.likes ?? 0) - 1,
            isLiked: false, // Comment is now unliked
            // lastDoc: comment.lastDoc,
            userData: comment.userData,
            isLoading: false,
          );
        }
        return comment;
      }).toList();

      // Update the state
      state = AsyncData(updatedComments);

      // Perform the unlike operation
      await videoRepository.unlikeCommentVideo(videoId, commentId);
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  FutureOr<List<CommentTikTok>> getComments() async {
    try {
      final data = await videoRepository.fetchCommentsOneTime(
        _videoId!,
        _limit,
        _lastDoc,
      );

      if (data == null || data.isEmpty) {
        return [];
      }

      _lastDoc = data.last.lastDoc;

      return data;
    } catch (e) {
      rethrow;
    }
  }
}
