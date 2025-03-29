import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/utils/constant/enums.dart';

class NotificationModel {
  final String postID;
  final bool read;
  final String senderID;
  final Timestamp timestamp;
  final NotificationType type;
  final String fullName;
  final String avatar;
  final DocumentSnapshot? lastDoc;
  bool? hasFollow;

  NotificationModel(
      {required this.postID,
      required this.read,
      required this.senderID,
      required this.timestamp,
      required this.type,
      this.lastDoc,
      this.hasFollow,
      required this.fullName,
      required this.avatar});

  factory NotificationModel.fromJson(
      Map<String, dynamic> json, DocumentSnapshot lastDoc) {
    return NotificationModel(
      postID: json['postID'] as String,
      read: json['read'] as bool,
      senderID: json['senderID'] as String,
      lastDoc: lastDoc,
      hasFollow: json['hasFollow'],
      timestamp: json['timestamp'] as Timestamp,
      type: NotificationType.values.byName(json['type']),
      fullName: json['fullName'] as String? ?? "Unknown User",
      avatar: json['avatar'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postID': postID,
      'read': read,
      'senderID': senderID,
      'timestamp': timestamp,
      'type': type.name,
      'fullName': fullName,
      'avatar': avatar,
    };
  }
}
