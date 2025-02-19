import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static FlutterLocalNotificationsPlugin? notificationsPlugin;
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() {
    notificationsPlugin ??= FlutterLocalNotificationsPlugin();
    initizalization();
    return _instance;
  }

  static Future initizalization() async {
    //Android init

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher_notification_foreground',
    );

    const DarwinInitializationSettings initializationSettingsIOSDarwin =
        DarwinInitializationSettings(
            requestBadgePermission: true,
            requestSoundPermission: true,
            defaultPresentSound: true,
            requestAlertPermission: true);
    const settings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOSDarwin);
    await notificationsPlugin?.initialize(
      settings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
    await notificationsPlugin
        ?.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  NotificationDetails notificationDetailDemo(
      {String channelId = 'default_channel',
      String channelDetail = 'Testing',
      String? channelDesc = 'Description channel'}) {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('01203123', channelDetail,
            channelDescription: channelDesc,
            importance: Importance.max,
            // icon: '@drawable/splash',
            playSound: true,
            channelShowBadge: false,
            color: AppColors.secondaryColor,
            priority: Priority.high,
            sound: const RawResourceAndroidNotificationSound('notification'),
            enableVibration: true,
            ticker: 'ticker');

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(presentSound: true, sound: 'notification');
    final NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    return notificationDetails;
  }

  Future showNotification(
      {int id = 0,
      String? title,
      String? body,
      String channelId = 'default_channel',
      String channelDetail = 'Testing',
      String? channelDesc = 'Description channel'}) async {
    return await notificationsPlugin?.show(
        id, title, body, notificationDetailDemo());
  }
}
