// ignore_for_file: public_member_api_docs, sort_constructors_first
class NotificationData {
  final String senderID;
  final String receiverID;
  final String postID;
  final String type;

  NotificationData({
    required this.senderID,
    required this.receiverID,
    required this.postID,
    required this.type,
  });

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    return NotificationData(
      senderID: map['senderID'],
      receiverID: map['receiverID'],
      postID: map['postID'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'receiverID': receiverID,
      'postID': postID,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'NotificationData(senderID: $senderID, receiverID: $receiverID, postID: $postID, type: $type)';
  }
}
