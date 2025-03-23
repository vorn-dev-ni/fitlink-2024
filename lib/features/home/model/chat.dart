// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/utils/constant/enums.dart';

class WrapperMessage {
  final List<Message> messages;
  final UserData userReceiver;

  WrapperMessage({
    required this.messages,
    required this.userReceiver,
  });

  WrapperMessage copyWith({
    List<Message>? messages,
    UserData? userReceiver,
  }) {
    return WrapperMessage(
      messages: messages ?? this.messages,
      userReceiver: userReceiver ?? this.userReceiver,
    );
  }

  @override
  String toString() =>
      'WrapperMessage(messages: $messages, userReceiver: $userReceiver)';
}

class Message {
  final String? id;
  final String? senderId;
  final MessageType type;
  final String content;
  final String? videoAvatarUser;
  final String? videoUserName;
  final Timestamp timestamp;
  final bool? readStatus;
  final String? videoUrl;
  final String? videoId;
  final String? thumbnailUrl;
  final Map<String, dynamic>? otherUserInfo;
  UserData? receiver;
  final DocumentSnapshot<Map<String, dynamic>>? snapshot;

  Message(
      {this.senderId,
      this.id,
      required this.type,
      required this.content,
      this.videoUrl,
      this.videoId,
      this.thumbnailUrl,
      this.videoAvatarUser,
      this.videoUserName,
      required this.timestamp,
      this.receiver,
      this.snapshot,
      this.readStatus,
      this.otherUserInfo});

  factory Message.fromMap(
    Map<String, dynamic> data, {
    Map<String, dynamic>? otherUserInfo,
    DocumentSnapshot<Map<String, dynamic>>? snapshot,
  }) {
    return Message(
        senderId: data['senderId'],
        type: MessageType.values
            .firstWhere((e) => e.toString() == 'MessageType.${data['type']}'),
        content: data['content'],
        timestamp: data['timestamp'],
        readStatus: data['readStatus'],
        receiver: data['receiver'],
        otherUserInfo: otherUserInfo,
        snapshot: snapshot,
        videoAvatarUser: data['videoAvatarUser'],
        videoUrl: data['videoUrl'],
        videoUserName: data['videoUserName'],
        videoId: data['videoId'],
        thumbnailUrl: data['thumbnailUrl'],
        id: data['id']);
  }

  // Convert Message to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'type': type.toString().split('.').last,
      'content': content,
      'timestamp': timestamp,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'videoId': videoId,
      'videoAvatarUser': videoAvatarUser,
      'videoUserName': videoUserName,
    };
  }

  @override
  String toString() {
    return 'Message(id: $id, senderId: $senderId, type: $type, content: $content, timestamp: $timestamp, readStatus: $readStatus, otherUserInfo: $otherUserInfo, receiver: $receiver, snapshot: $snapshot)';
  }
}

class Chat {
  final String chatId;
  final String senderId;
  final String? videoId;
  final List<DocumentReference> participants;
  final String? lastMessage;
  final DateTime? lastMessageTimestamp;
  final List<Message> messages;
  final Map<String, dynamic>? otherParticipantInfo;
  final String? videoAvatarUser;
  final String? videoUserName;
  Map<String, dynamic>? last_read;
  Chat({
    required this.chatId,
    this.last_read,
    this.videoId,
    this.videoAvatarUser,
    this.videoUserName,
    required this.senderId,
    required this.participants,
    this.lastMessage,
    this.lastMessageTimestamp,
    required this.messages,
    this.otherParticipantInfo,
  });

  factory Chat.fromDocument(DocumentSnapshot doc,
      {List<Message> messages = const [],
      Map<String, dynamic>? otherParticipantInfo}) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Chat(
      senderId: doc['senderId'],
      chatId: doc.id,
      last_read: doc['last_read'],
      participants: (doc['participants'] as List<dynamic>)
          .map((ref) => ref as DocumentReference)
          .toList(),
      lastMessage: doc['lastMessage'] as String?,
      lastMessageTimestamp:
          (doc['lastMessageTimestamp'] as Timestamp?)?.toDate(),
      messages: messages,
      videoUserName: data['videoUserName'] ?? "",
      videoAvatarUser: data['videoAvatarUser'] ?? "",
      videoId: data['videoId'] ?? "",
      otherParticipantInfo: otherParticipantInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'videoUserName': videoUserName,
      'videoAvatarUser': videoAvatarUser,
      'videoId': videoId,
      'participants': participants,
      'lastMessage': lastMessage ?? '',
      'lastMessageTimestamp': lastMessageTimestamp != null
          ? Timestamp.fromDate(lastMessageTimestamp!)
          : null,
      'messages': messages.map((message) => message.toMap()).toList(),
      'otherParticipantInfo': otherParticipantInfo,
    };
  }
}
