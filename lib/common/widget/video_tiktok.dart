// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:demo/features/home/model/post.dart';

List<VideoTikTok> dummyVideos = [
  VideoTikTok(
    documentID: "vid1",
    commentCount: 10,
    likeCount: 100,
    shareCount: 5,
    thumbnailUrl: "",
    userRef: UserData(
        id: "user3",
        fullName: "MikeRoss",
        avatar: "https://example.com/profile3.jpg"),
    videoUrl: "https://example.com/video3.mp4",
    viewCount: 350,
    createdAt: Timestamp.now(),
    caption: "Workout time!",
    tag: ["fitness"],
    isUserliked: true,
  ),
  VideoTikTok(
    documentID: "vid2",
    commentCount: 25,
    likeCount: 250,
    shareCount: 15,
    thumbnailUrl: "",
    userRef: UserData(
        id: "user3",
        fullName: "MikeRoss",
        avatar: "https://example.com/profile3.jpg"),
    videoUrl: "https://example.com/video3.mp4",
    viewCount: 350,
    createdAt: Timestamp.now(),
    caption: "Workout time!",
    tag: ["fitness"],
    isUserliked: true,
  ),
  VideoTikTok(
    documentID: "vid3",
    commentCount: 8,
    likeCount: 80,
    shareCount: 3,
    thumbnailUrl: "",
    userRef: UserData(
        id: "user3",
        fullName: "MikeRoss",
        avatar: "https://example.com/profile3.jpg"),
    videoUrl: "https://example.com/video3.mp4",
    viewCount: 350,
    createdAt: Timestamp.now(),
    caption: "Workout time!",
    tag: ["fitness"],
    isUserliked: true,
  ),
  VideoTikTok(
    documentID: "vid4",
    commentCount: 15,
    likeCount: 150,
    shareCount: 7,
    thumbnailUrl: "",
    userRef: UserData(
        id: "user3",
        fullName: "MikeRoss",
        avatar: "https://example.com/profile3.jpg"),
    videoUrl: "https://example.com/video3.mp4",
    viewCount: 350,
    createdAt: Timestamp.now(),
    caption: "Workout time!",
    tag: ["fitness"],
    isUserliked: true,
  ),
];

class VideoTikTok {
  String? documentID;
  int? commentCount;
  int? likeCount;
  int? shareCount;
  String? thumbnailUrl;
  UserData? userRef;
  String? videoUrl;
  int? viewCount;
  Timestamp? createdAt;
  DocumentSnapshot? lastDoc;
  String? caption;
  List<dynamic>? tag;
  bool? isUserliked;
  VideoPlayerController? videoplayer;

  VideoTikTok({
    this.videoplayer,
    this.documentID,
    this.commentCount,
    this.isUserliked,
    this.likeCount,
    this.shareCount,
    this.thumbnailUrl,
    this.userRef,
    this.videoUrl,
    this.viewCount,
    this.createdAt,
    this.lastDoc,
    this.caption,
    this.tag,
  });

  VideoTikTok.fromFirestore(DocumentSnapshot doc, UserData? userdata,
      {bool? paramsLiked, VideoPlayerController? newVideoplayer}) {
    documentID = doc.id;
    isUserliked = paramsLiked ?? false;
    commentCount = doc['commentCount'];
    createdAt = (doc['createdAt'] as Timestamp);
    likeCount = doc['likeCount'];
    shareCount = doc['shareCount'];
    thumbnailUrl = doc['thumbnailUrl'];
    userRef = userdata;
    videoUrl = doc['videoUrl'];
    viewCount = doc['viewCount'];
    caption = doc['caption'];
    tag = doc['tag'];
    lastDoc = doc;
    videoplayer = newVideoplayer;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['documentID'] = documentID;
    data['commentCount'] = commentCount;
    data['createdAt'] = createdAt;
    data['likeCount'] = likeCount;
    data['shareCount'] = shareCount;
    data['thumbnailUrl'] = thumbnailUrl;
    data['userRef'] = userRef?.toJson();
    data['videoUrl'] = videoUrl;
    data['viewCount'] = viewCount;
    data['caption'] = caption;
    data['tag'] = tag;
    return data;
  }

  VideoTikTok copyWith({
    String? documentID,
    int? commentCount,
    int? likeCount,
    int? shareCount,
    String? thumbnailUrl,
    UserData? userRef,
    String? videoUrl,
    int? viewCount,
    Timestamp? createdAt,
    DocumentSnapshot? lastDoc,
    String? caption,
    List<dynamic>? tag,
    bool? isUserliked,
    VideoPlayerController? videoplayer,
  }) {
    return VideoTikTok(
      documentID: documentID ?? this.documentID,
      commentCount: commentCount ?? this.commentCount,
      likeCount: likeCount ?? this.likeCount,
      shareCount: shareCount ?? this.shareCount,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      userRef: userRef ?? this.userRef,
      videoUrl: videoUrl ?? this.videoUrl,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      lastDoc: lastDoc ?? this.lastDoc,
      caption: caption ?? this.caption,
      tag: tag ?? this.tag,
      isUserliked: isUserliked ?? this.isUserliked,
      videoplayer: videoplayer ?? this.videoplayer,
    );
  }
}

class ViewModel {
  String? documentId;
  String? viewAt;

  ViewModel({this.documentId, this.viewAt});

  ViewModel.fromJson(Map<String, dynamic> json) {
    documentId = json['documentId'];
    viewAt = json['viewAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['documentId'] = this.documentId;
    data['viewAt'] = this.viewAt;
    return data;
  }
}

class LikeTikTokModel {
  String? documentId;
  String? likeAt;

  LikeTikTokModel({this.documentId, this.likeAt});

  LikeTikTokModel.fromJson(Map<String, dynamic> json) {
    documentId = json['documentId'];
    likeAt = json['likeAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['documentId'] = this.documentId;
    data['likeAt'] = this.likeAt;
    return data;
  }
}

final List<CommentTikTok> generateDummyComments = [
  CommentTikTok(
    documentId: '1',
    createdAt: Timestamp.fromMillisecondsSinceEpoch(
        1627833600000), // Example timestamp
    text: 'Great video! I love it!',
    likes: 10,
    lastDoc: null, // Not needed for dummy data
    userData: UserData(avatar: '', fullName: 'User 1'),
    isLiked: false,
    isLoading: false,
  ),
  CommentTikTok(
    documentId: '2',
    createdAt: Timestamp.fromMillisecondsSinceEpoch(
        1627833700000), // Example timestamp
    text: 'Awesome content, keep it up!',
    likes: 5,
    lastDoc: null,
    userData: UserData(avatar: '', fullName: 'User 2'),
    isLiked: true,
    isLoading: false,
  ),
  CommentTikTok(
    documentId: '3',
    createdAt: Timestamp.fromMillisecondsSinceEpoch(
        1627833800000), // Example timestamp
    text: 'I want to see more videos like this!',
    likes: 20,
    lastDoc: null,
    userData: UserData(avatar: '', fullName: 'User 3'),
    isLiked: true,
    isLoading: false,
  ),
  CommentTikTok(
    documentId: '4',
    createdAt: Timestamp.fromMillisecondsSinceEpoch(
        1627833900000), // Example timestamp
    text: 'This is so inspiring!',
    likes: 15,
    lastDoc: null,
    userData: UserData(avatar: '', fullName: 'User 4'),
    isLiked: false,
    isLoading: false,
  ),
  CommentTikTok(
    documentId: '5',
    createdAt: Timestamp.fromMillisecondsSinceEpoch(
        1627833700000), // Example timestamp
    text: 'Awesome content, keep it up!',
    likes: 5,
    lastDoc: null,
    userData: UserData(avatar: '', fullName: 'User 2'),
    isLiked: true,
    isLoading: false,
  ),
  CommentTikTok(
    documentId: '6',
    createdAt: Timestamp.fromMillisecondsSinceEpoch(
        1627833700000), // Example timestamp
    text: 'Awesome content, keep it up!',
    likes: 5,
    lastDoc: null,
    userData: UserData(avatar: '', fullName: 'User 2'),
    isLiked: true,
    isLoading: false,
  ),
  CommentTikTok(
    documentId: '7',
    createdAt: Timestamp.fromMillisecondsSinceEpoch(
        1627833700000), // Example timestamp
    text: 'Awesome content, keep it up!',
    likes: 5,
    lastDoc: null,
    userData: UserData(avatar: '', fullName: 'User 2'),
    isLiked: true,
    isLoading: false,
  ),
];

class CommentTikTok {
  String? documentId;
  Timestamp? createdAt;
  String? text;
  int? likes;
  DocumentSnapshot? lastDoc;
  UserData? userData;
  bool? isLiked;
  bool? isLoading;

  CommentTikTok(
      {this.documentId,
      this.createdAt,
      this.lastDoc,
      this.userData,
      this.likes,
      this.isLoading,
      this.isLiked,
      this.text});

  CommentTikTok.fromJson(Map<String, dynamic> json,
      {this.lastDoc, this.userData, bool? paramLiked}) {
    createdAt = json['createdAt'];
    text = json['text'];
    likes = json['likes'];
    documentId = json['id'];
    isLiked = paramLiked ?? false;
    isLoading = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['documentId'] = documentId;
    data['commentAt'] = createdAt;
    data['text'] = text;
    data['likes'] = likes;
    data['isLiked'] = isLiked;
    if (userData != null) {
      data['userData'] = userData!.toJson();
    }

    return data;
  }
}

class ShareTikTok {
  String? documentId;
  String? shareAt;

  ShareTikTok({this.documentId, this.shareAt});

  ShareTikTok.fromJson(Map<String, dynamic> json) {
    documentId = json['documentId'];
    shareAt = json['shareAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['documentId'] = this.documentId;
    data['shareAt'] = this.shareAt;
    return data;
  }
}
