import 'dart:io';

import 'package:demo/data/service/utils/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FcmService {
  late final FirebaseMessaging fcmInstance;

  FcmService() {
    fcmInstance = FirebaseMessaging.instance;
    debugPrint("Call init fcmservce");
    initToken();
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
    if (Platform.isIOS) {
      String? apnsToken = await fcmInstance.getAPNSToken();
      await Future.delayed(const Duration(seconds: 2));

      debugPrint('APNS Token: $apnsToken');
    }

    final token = await fcmInstance.getToken();
    // final iosToken = await fcmInstance.getAPNSToken();

    debugPrint("token fmc is ${token} getAPNSToken");
    await setUpPushnotification();
  }

  Future getDetailNotification(RemoteMessage? value) async {
    debugPrint("Click action is");
  }

  Future setUpPushnotification() async {
    fcmInstance.getInitialMessage().then(
      (value) {
        getDetailNotification(value);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(getDetailNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      String? title = message.notification?.title;
      String? body = message.notification?.body;
      NotificationService().showNotification(id: 1, body: body, title: title);

      if (message.notification != null) {
        debugPrint(
            'Message also contained a notification: ${message.notification}');
      }
    });
  }
}
