import 'package:demo/common/model/notification_payload.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/global_key.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        AndroidInitializationSettings('@mipmap/ic_launcher_foreground');

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

      // debugPrint('isPermission ${isPermission == true ? 'true' : 'false'}');
      // Fluttertoast.showToast(
      //     msg: 'isPermission ${isPermission == true ? 'true' : 'false'}');
    }
  }

  static void _onDidReceiveNotificationResponse(NotificationResponse response) {
    // debugPrint('Notification clicked with payload: ${response.}');
    NotificationData? result;
    debugPrint('_onDidReceiveNotificationResponse cl icked with payload');
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
      if (FirebaseAuth.instance.currentUser != null &&
          result?.type == 'following') {
        navigatorKey.currentState?.pushNamed(AppPage.viewProfile,
            arguments: {'userId': result?.postID});
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
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: '@drawable/branding',
      channelShowBadge: true,
      // color: AppColors.secondaryColor,
      sound: const RawResourceAndroidNotificationSound('notification'),
      enableVibration: true,
      enableLights: true,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentSound: true,
      sound: 'notification',
    );
    debugPrint("Show notificaiton now !!!");

    return NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  Future<void> showNotification({
    required int id,
    String? title,
    String? body,
    String channelId = 'default_channel',
    String channelName = 'broad-cast-user',
    String channelDesc = 'This is the channel',
  }) async {
    try {
      debugPrint("Run notificaiton ${id} ${title} ${body}");
      await _notificationsPlugin?.show(
        id,
        title,
        body,
        _notificationDetails(
            channelId: channelId,
            channelName: channelName,
            channelDesc: channelDesc),
      );
    } catch (e) {
      rethrow;
    }
  }
}
