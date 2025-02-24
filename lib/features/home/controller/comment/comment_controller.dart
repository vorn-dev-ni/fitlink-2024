import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/repository/firebase/comment_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/comments/comment_service.dart';
import 'package:demo/features/home/controller/comment/comment_loading.dart';
import 'package:demo/features/home/controller/comment/comment_loading_dummy.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/features/home/model/comment.dart';
import 'package:demo/features/home/model/comment_loading.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'comment_controller.g.dart';

@Riverpod(keepAlive: false)
class CommentController extends _$CommentController {
  int _pageSizes = 10;
  late CommentRepo commentRepo;

  @override
  Stream<List<Comment>?> build(String? parentId) {
    commentRepo = CommentRepo(
      baseCommentService: CommentService(
        firebaseAuthService: FirebaseAuthService(),
      ),
    );
    if (parentId == null) return const Stream.empty();
    return getAllComments(parentId);
  }

  Stream<List<Comment>?> getAllComments(String parentId) async* {
    yield* commentRepo.getAllCommentByPostId(parentId, _pageSizes, null);
  }

  Future<bool> isUserLiked({String? postId, String? commentId}) async {
    try {
      if (postId == null || commentId == null) {
        return false;
      }
      return await commentRepo.checkUserCommentLiked(
          parentId: postId, commentId: commentId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> submitComment({
    String? parentId,
    required String text,
    required int count,
  }) async {
    try {
      if (parentId == null) {
        return;
      }

      final user = await ref.read(profileUserControllerProvider.future);
      final tempComment = Comment(
        commentId: DateTime.now().toIso8601String(),
        createdAt: Timestamp.now(),
        isLiked: false,
        likesCount: 0,
        isLoading: true,
        user: UserData(avatar: user?.avatar, fullName: user?.fullname),
        text: text,
      );

      state = AsyncData([tempComment, ...state.value ?? []]);
      await commentRepo.addComment(
        parentId: parentId,
        text: text,
        count: count,
      );
      state = AsyncData([...state.value ?? []]);
      ref.invalidateSelf();
    } catch (e) {
      ref.invalidateSelf();
    }
  }

  Future toggleUserLikes(
      {required String parentId,
      required String id,
      required int likes,
      required bool hasLiked}) async {
    try {
      if (hasLiked) {
        await commentRepo.removeLikeCount(parentId, id, likes);
      } else {
        await commentRepo.updateLikeCount(parentId, id, likes);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadNextPage(String parentId) async {
    try {
      final total = await commentRepo.getTotalItems(parentId);
      if (total <= _pageSizes) {
        return;
      }
      ref.read(commentPagingLoadingProvider.notifier).setState(true);
      _pageSizes = _pageSizes + 10;
      final newDataStream = commentRepo.getAllCommentByPostId(
        parentId,
        _pageSizes,
        null,
      );

      final newData = await newDataStream.first;
      if (newData != null && newData.isNotEmpty) {
        state = AsyncData([...newData]);
      }
      ref.read(commentPagingLoadingProvider.notifier).setState(false);

      // Optionally, update pagination state
      // if (newData.isNotEmpty) {
      //   ref.read(lastDocumentNotifierProvider.notifier).setLastDocument(newData);
      // }
    } catch (e) {
      rethrow;
    }
  }
}
