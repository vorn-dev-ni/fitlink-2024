// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';

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
  String? formattedCreatedAt;
  String? feeling;
  Post(
      {this.postId,
      this.user,
      this.userLiked = false,
      this.likesCount = 0,
      this.commentsCount = 0,
      this.caption,
      this.formattedCreatedAt,
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
      emoji: json['emoji'] ?? "",
      feeling: json['feeling'] ?? "",
      formattedCreatedAt: FormatterUtils.formatTimestamp(
        json['createdAt'],
      ),
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
      "caption": caption,
      "likesCount": likesCount,
      "commentsCount": commentsCount,
      if (imageUrl != null) "imageUrl": imageUrl,
      if (tag != null) "tag": tag,
      if (feeling != null) "feeling": feeling,
      if (emoji != null) "emoji": emoji,
      "type": type,
      "createdAt": FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toJsonUpdated() {
    return {
      "caption": caption,
      "likesCount": likesCount,
      "commentsCount": commentsCount,
      if (imageUrl != null) "imageUrl": imageUrl,
      if (tag != null) "tag": tag,
      if (feeling != null) "feeling": feeling,
      if (emoji != null) "emoji": emoji,
      "type": type,
      "updatedAt": FieldValue.serverTimestamp(),
    };
  }

  Post copyWith({
    String? postId,
    UserData? user,
    int? commentsCount,
    String? tag,
    bool? userLiked,
    int? likesCount,
    String? imageUrl,
    String? caption,
    Timestamp? createdAt,
    String? type,
    String? emoji,
    String? feeling,
  }) {
    return Post(
      postId: postId ?? this.postId,
      caption: caption ?? this.caption,
      commentsCount: commentsCount ?? this.commentsCount,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      emoji: emoji ?? this.emoji,
      feeling: feeling ?? this.feeling,
      imageUrl: imageUrl ?? this.imageUrl,
      likesCount: likesCount ?? this.likesCount,
      tag: tag ?? this.tag,
    );
  }
}

class UserData {
  String? id;
  String? avatar;
  int? followingCount;
  int? followerCount;
  int? notificationCount;
  String? coverFeature;
  String? provider;
  String? bio;
  String? role;
  String? fullName;
  String? email;
  Timestamp? updatedAt;
  Timestamp? createdAt;
  bool? isOnline;
  Timestamp? lastSeen;
  DocumentSnapshot? documentSnapshot;

  UserData(
      {this.avatar,
      this.coverFeature,
      this.id,
      this.provider,
      this.documentSnapshot,
      this.bio,
      this.role,
      this.isOnline = false,
      this.lastSeen,
      this.fullName,
      this.email,
      this.followerCount = 0,
      this.followingCount = 0,
      this.notificationCount = 0,
      this.updatedAt,
      this.createdAt});

  UserData.fromJson(Map<String, dynamic> json, {DocumentSnapshot? doc}) {
    id = json['id'];
    avatar = json['avatar'];
    coverFeature = json['coverFeature'];
    provider = json['provider'];
    bio = json['bio'];
    id = json['id'];
    doc = json['doc'];
    followerCount = json['followerCount'];
    followingCount = json['followingCount'];
    notificationCount = json['notificationCount'];
    role = json['role'];
    fullName = json['fullName'];
    email = json['email'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    lastSeen = json['lastSeen'];
    isOnline = json['isOnline'] ?? false;
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

  @override
  String toString() {
    return 'UserData(id: $id, avatar: $avatar, coverFeature: $coverFeature, provider: $provider, bio: $bio, role: $role, fullName: $fullName, email: $email, updatedAt: $updatedAt, createdAt: $createdAt)';
  }
}
