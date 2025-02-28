import 'package:demo/common/model/notification_payload.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/global_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static FlutterLocalNotificationsPlugin? _notificationsPlugin;
  static Map<String, dynamic>? _payload;

  void setPayload(payload) {
    _payload = payload;
  }

  NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  static Future<void> initialize() async {
    _notificationsPlugin ??= FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher_notification_foreground');

    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings(
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentSound: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _notificationsPlugin!.initialize(
      initSettings,
      // onDidReceiveBackgroundNotificationResponse:
      //     _onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    debugPrint("Notification local initialized");

    // Request permissions (for Android 13+ and iOS)
    final androidPlugin =
        _notificationsPlugin?.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }

  static void _onDidReceiveNotificationResponse(NotificationResponse response) {
    // debugPrint('Notification clicked with payload: ${response.}');
    NotificationData? result;
    if (response.payload != null) {
      // When user click notificaiton in forceground

      if (_payload != null) {
        result = NotificationData.fromMap(_payload!);
      }
      debugPrint(
          '_onDidReceiveNotificationResponse cl icked with payload: ${result.toString()}');

      if (result?.type == 'like' || result?.type == 'comment') {
        navigatorKey.currentState?.pushNamed(
          AppPage.commentListings,
          arguments: {'post': Post(postId: result?.postID)},
        );
      }

      // debugPrint('Notification clicked with payload: ${navigatorKey}');
    }
  }

  static Map<String, dynamic>? getPayload() => _payload;

  NotificationDetails _notificationDetails({
    String channelId = 'default_channel',
    String channelName = 'Testing',
    String channelDesc = 'Description channel',
  }) {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      channelShowBadge: false,
      color: AppColors.secondaryColor,
      sound: const RawResourceAndroidNotificationSound('notification'),
      enableVibration: true,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentSound: true,
      sound: 'notification',
    );

    return NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String channelId = 'default_channel',
    String channelName = 'Testing',
    String channelDesc = 'Description channel',
  }) async {
    await _notificationsPlugin?.show(
      id,
      title,
      body,
      _notificationDetails(
          channelId: channelId,
          channelName: channelName,
          channelDesc: channelDesc),
    );
  }

  // static void _onDidReceiveBackgroundNotificationResponse(
  //     NotificationResponse response) {
  //   if (response.payload != null) {
  //     _payload = response.payload;
  //     debugPrint(
  //         '_onDidReceiveBackgroundNotificationResponse clicked with payload: $_payload');
  //     // debugPrint('Notification clicked with payload: ${navigatorKey}');
  //   }
  //   navigatorKey.currentState?.pushNamed(AppPage.NotificationPath);
  // }
}
