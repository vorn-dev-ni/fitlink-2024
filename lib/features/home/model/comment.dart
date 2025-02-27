import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';

class Comment {
  final String commentId; // Added commentId field
  final Timestamp createdAt;
  final String text;
  final UserData? user;
  final int? likesCount;
  final bool? isLiked;
  final bool isLoading;
  final String? formattedCreatedAt;

  Comment(
      {required this.commentId,
      required this.createdAt,
      this.isLiked = false,
      required this.text,
      this.formattedCreatedAt,
      this.isLoading = false,
      this.likesCount = 0,
      this.user});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      likesCount: json['likesCount'],
      isLiked: json['isLiked'],
      commentId: json['commentId'] as String, // Parsing commentId
      createdAt: json['createdAt'] as Timestamp,
      formattedCreatedAt: FormatterUtils.formatTimestamp(
        json['createdAt'],
      ),

      text: json['text'] as String,
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentId'] = commentId; // Adding commentId to map
    data['createdAt'] = createdAt;
    data['text'] = text;
    if (user != null) {
      data['user'] = user?.toJson();
    }
    return data;
  }
}
