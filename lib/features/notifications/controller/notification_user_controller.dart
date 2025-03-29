import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/repository/firebase/notification_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/data/service/firestore/notification/notification_service.dart';
import 'package:demo/features/notifications/controller/notification_loading.dart';
import 'package:demo/features/notifications/model/notification_model.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'notification_user_controller.g.dart';

@Riverpod(keepAlive: false)
class NotificationUserController extends _$NotificationUserController {
  late FirestoreService firestoreService;
  late NotificationRepo notificationRepo;
  late FirebaseAuthService firebaseAuthService;

  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  int limit = 9;

  @override
  Future<List<NotificationModel>> build(String? uid) {
    if (uid == null) {
      throw AppException(title: 'Unauthorized', message: 'Session is expired');
    }

    firebaseAuthService = FirebaseAuthService();
    firestoreService =
        FirestoreService(firebaseAuthService: firebaseAuthService);
    notificationRepo = NotificationRepo(
        notificationBaseService: NotificationRemoteService(
            firebaseAuthService: firebaseAuthService));
    _hasMore = true;
    limit = 10;
    _lastDocument = null;
    // Fluttertoast.showToast(msg: 'run again');
    return getData(uid);
  }

  Future refreshState() async {
    _hasMore = true;
    limit = 9;
    _lastDocument = null;
    ref.invalidateSelf();
  }

  Future<List<NotificationModel>> getData(String uid) async {
    try {
      List<NotificationModel> notifications = await notificationRepo
          .getNotificationByUser(uid, limit, _lastDocument);

      if (notifications.isNotEmpty) {
        _lastDocument = notifications.last.lastDoc;
      } else {
        _hasMore = false;
      }

      return notifications;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadMoreNotifications() async {
    if (!_hasMore) {
      return;
    }

    try {
      int mutatePage = limit;

      ref.read(notificationLoadingProvider.notifier).setState(true);
      final notifications = await notificationRepo.getNotificationByUser(
        uid ?? "",
        mutatePage,
        _lastDocument,
      );
      ref.read(notificationLoadingProvider.notifier).setState(false);

      if (notifications.isNotEmpty) {
        _lastDocument = notifications.last.lastDoc as DocumentSnapshot;
      } else {
        _hasMore = false;
      }

      if (state.value != null) {
        debugPrint(" pagesie ${mutatePage}");

        state = AsyncData([
          ...state.value!,
          ...notifications,
        ]);
      }
    } catch (e) {
      ref.read(notificationLoadingProvider.notifier).setState(false);
      rethrow;
    }
  }

  Future resetState() async {}
}
