// ignore_for_file: public_member_api_docs, sort_constructors_first
class MediaCount {
  int? followingCount;
  int? notificaitonCount;
  int? workoutCounts;
  int? followerCount;
  MediaCount({
    this.followingCount,
    this.notificaitonCount,
    this.followerCount,
    this.workoutCounts,
  });

  MediaCount copyWith({
    int? followingCount,
    int? notificaitonCount,
    int? followerCount,
    int? workoutCounts,
  }) {
    return MediaCount(
      workoutCounts: workoutCounts ?? this.workoutCounts,
      followingCount: followingCount ?? this.followingCount,
      notificaitonCount: notificaitonCount ?? this.notificaitonCount,
      followerCount: followerCount ?? this.followerCount,
    );
  }

  @override
  String toString() =>
      'MediaCount(followingCount: $followingCount, notificaitonCount: $notificaitonCount, followerCount: $followerCount)';
}
