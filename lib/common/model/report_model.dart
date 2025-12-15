class ReportData {
  final String reason;
  final String postId;
  final String type;

  ReportData({
    required this.reason,
    required this.postId,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'postId': postId,
      'type': type,
    };
  }

  @override
  String toString() =>
      'ReportData(reason: $reason, postId: $postId, type: $type)';
}
