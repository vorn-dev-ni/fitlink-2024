import 'package:demo/common/model/notification_payload,dart';
import 'package:demo/data/service/utils/notification_service.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/global_key.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FcmService {
  late final FirebaseMessaging fcmInstance;

  FcmService() {
    fcmInstance = FirebaseMessaging.instance;
    debugPrint("Call init fcmservce");
    initToken();
  }

  Future<void> sendPushNotification(
      {required String title, required String body}) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('sendNotification');
      final token = await HelpersUtils.getDeviceToken();
      final response = await callable.call({
        "token": token,
        "title": title,
        "body": body,
        "soundName": "notification"
      });

      debugPrint("Notification sent: ${response.data}");
    } catch (e) {
      debugPrint("Error sending notification: $e");
      rethrow;
    }
  }

  Future initToken() async {
    await fcmInstance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    await HelpersUtils.getDeviceToken();
    await setUpPushnotification();
  }

  void requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      debugPrint('Notification permission granted');
    } else {
      debugPrint('Notification permission denied');
    }
  }

  Future getDetailNotification(RemoteMessage? value) async {
    debugPrint("getDetailNotification action is ${value?.data}");

    if (value?.data != null) {
      final data = NotificationData.fromMap(value!.data);
      if (FirebaseAuth.instance.currentUser != null && data.type == 'comment' ||
          data.type == 'like') {
        navigatorKey.currentState?.pushNamed(AppPage.commentListings,
            arguments: {'post': Post(postId: data.postID)});
      }
      // navigatorKey.currentState?.pushNamed(AppPage.NOTFOUND);
    }
  }

  void _processPushNotification({required RemoteMessage? value}) async {
    if (value?.data != null) {
      final data = NotificationData.fromMap(value!.data);
      if (FirebaseAuth.instance.currentUser != null && data.type == 'comment' ||
          data.type == 'like') {
        Future.delayed(const Duration(milliseconds: 3500), () {
          navigatorKey.currentState?.pushNamed(AppPage.commentListings,
              arguments: {'post': Post(postId: data.postID)});
        });
      }
    }
  }

  Future setUpPushnotification() async {
    fcmInstance.getInitialMessage().then(
      (value) {
        _processPushNotification(value: value);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(getDetailNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String? title = message.notification?.title;
      String? body = message.notification?.body;
      Map<String, dynamic>? data = message.data;
      NotificationService().setPayload(data);
      NotificationService().showNotification(id: 1, body: body, title: title);

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${data}');
      }
    });
  }
}
