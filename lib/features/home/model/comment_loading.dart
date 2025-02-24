// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:demo/features/home/model/comment.dart';

class CommentLoading {
  bool? isLoading;
  Comment? comment;
  CommentLoading({
    this.isLoading,
    this.comment,
  });

  CommentLoading copyWith({
    bool? isLoading,
    Comment? comment,
  }) {
    return CommentLoading(
      isLoading: isLoading ?? this.isLoading,
      comment: comment ?? this.comment,
    );
  }

  @override
  String toString() =>
      'CommentLoading(isLoading: $isLoading, comment: $comment)';
}
