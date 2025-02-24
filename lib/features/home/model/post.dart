import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? postId;
  UserData? user;
  int? commentsCount;
  String? tag;
  bool? userLiked;
  int? likesCount;
  String? imageUrl;
  String? caption;
  Timestamp? createdAt;
  String? type;
  String? emoji;
  String? feeling;
  Post(
      {this.postId,
      this.user,
      this.userLiked = false,
      this.likesCount,
      this.commentsCount,
      this.caption,
      this.tag,
      this.createdAt,
      this.type = 'text',
      this.emoji,
      this.feeling,
      this.imageUrl});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['postId'],
      userLiked: json['userLiked'],
      type: json['type'],
      emoji: json['emoji'],
      feeling: json['feeling'],
      caption: json['caption'] ?? "",
      likesCount: json['likesCount'] ?? 0,
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
      commentsCount: json['commentsCount'] ?? 0,
      tag: json['tag'] ?? "",
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "postId": postId,
      "user": user?.toJson(),
      "caption": caption,
      "likesCount": likesCount,
      "imageUrl": imageUrl,
      "commentsCount": commentsCount,
      "tag": tag,
      "createdAt": createdAt?.toDate(),
    };
  }
}

class UserData {
  String? avatar;
  String? coverFeature;
  String? provider;
  String? bio;
  String? role;
  String? fullName;
  String? email;
  Timestamp? updatedAt;
  Timestamp? createdAt;

  UserData(
      {this.avatar,
      this.coverFeature,
      this.provider,
      this.bio,
      this.role,
      this.fullName,
      this.email,
      this.updatedAt,
      this.createdAt});

  UserData.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    coverFeature = json['coverFeature'];
    provider = json['provider'];
    bio = json['bio'];
    role = json['role'];
    fullName = json['fullName'];
    email = json['email'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['coverFeature'] = this.coverFeature;
    data['provider'] = this.provider;
    data['bio'] = this.bio;
    data['role'] = this.role;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
