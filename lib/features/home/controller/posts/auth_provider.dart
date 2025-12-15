import 'package:demo/common/model/user_model.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/data/service/firestore/notification/notification_service.dart';
import 'package:demo/features/home/controller/chat/following_friend_controller.dart';
import 'package:demo/features/home/controller/comment/comment_controller.dart';
import 'package:demo/features/home/controller/navbar_controller.dart';
import 'package:demo/features/home/controller/posts/social_post_controller.dart';
import 'package:demo/features/home/controller/profile/profile_post_controller.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/features/home/controller/video/tiktok_video_controller.dart';
import 'package:demo/features/home/controller/video/video_page_controller.dart';
import 'package:demo/features/home/controller/workouts/activities_controller.dart';
import 'package:demo/features/home/views/single_profile/controller/notification_badge.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationRemoteServiceProvider = Provider((ref) =>
    NotificationRemoteService(firebaseAuthService: FirebaseAuthService()));
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService(firebaseAuthService: FirebaseAuthService());
});

final userSyncProvider = FutureProvider.family<void, String>((ref, uid) async {
  // Safety: ensure user still exists
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null || currentUser.uid != uid) return;

  final firestoreService = ref.read(firestoreServiceProvider);
  final notificationRemoteService = ref.read(notificationRemoteServiceProvider);

  try {
    // 1️⃣ Invalidate following friends
    ref.invalidate(followingFriendControllerProvider(userId: uid));

    // 2️⃣ Fetch user data
    final AuthModel? authModel = await firestoreService.getEmail(uid);

    // 3️⃣ Store FCM token
    final fcmToken = await HelpersUtils.getDeviceToken();
    if (fcmToken != null) {
      await notificationRemoteService.storeFcmToken(uid, fcmToken);
    }

    // 4️⃣ Invalidate app state providers (SAFE — no widget lifecycle)
    ref.invalidate(socialInteractonVideoControllerProvider);
    ref.invalidate(userNotificationControllerProvider);
    ref.invalidate(socialPostControllerProvider);
    ref.invalidate(commentControllerProvider);
    ref.invalidate(profilePostControllerProvider);
    ref.invalidate(activitiesControllerProvider);
    ref.invalidate(profileUserControllerProvider);
    ref.read(tiktokVideoControllerProvider.notifier).refresh();
    ref.read(videoPageControllerProvider.notifier).resetPage();

    // 5️⃣ Update navbar avatar
    ref
        .read(navbarControllerProvider.notifier)
        .updateProfileTab(authModel?.avatar ?? "");

    // 6️⃣ Stop loading state
    ref.read(appLoadingStateProvider.notifier).setState(false);
  } catch (e, st) {
    // Optional: report error (NO UI here)
    debugPrint('userSyncProvider error: $e');
    FirebaseCrashlytics.instance.recordError(e, st);
  }
});
