import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';


class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();



  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  // Android channel details
  static const _channelId = 'vaccination_requests';
  static const _channelName = 'requests';
  static const _channelDesc = 'new notification';

  final AndroidNotificationChannel _androidChannel =
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
        showBadge: true,
        // sound: RawResourceAndroidNotificationSound('notification'),
      );

  Future<void> init() async {
    if (_isInitialized) return;

    if (!kIsWeb) {
      await _requestPermissions();
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_androidChannel);

      // Initialize local notification tap handling
      await _localNotifications.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          // android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        ),
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          if (response.payload != null) {
            _onLocalNotificationTap(response.payload!);
          }
        },
      );
    }

    // Register FCM handlers
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);

    // Handle app opened by notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleTap(initialMessage);
    }

    _isInitialized = true;
    debugPrint('✅ NotificationService initialized');
  }

  Future<void> sendNotificationToMyself() async {
    final token = await FirebaseMessaging.instance.getToken();

    if (token == null) {
      print('FCM token not found');
      return;
    }

    final callable = FirebaseFunctions.instance.httpsCallable(
      'sendNotification',
    );

    final result = await callable.call({
      'token': token,
      'title': 'Test Notification',
      'body': 'Hello from Firebase Functions',
      'data': {'type': 'test'},
    });

    print(result.data);
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  // Foreground message
  Future<void> _handleForegroundMessage(RemoteMessage msg) async {
    final n = msg.notification;
    final data = msg.data;
    log("📩 Foreground Message Data: ${msg.data}");
    log("📩 Foreground Message Type: ${msg.messageType}");
    if (n == null) return;

    await _showSystemNotification(n.title, n.body, data);
    // dispatcher.emit(_buildKey(data), data);
  }

  // Background must be top-level or static
  static Future<void> _handleBackgroundMessage(RemoteMessage msg) async {
    if (msg.notification == null) return;
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          NotificationService.instance._androidChannel,
        );

    await plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: msg.notification!.title,
      body: msg.notification!.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          // sound: RawResourceAndroidNotificationSound('notification'),
        ),
        iOS: DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
          presentBadge: true,
          sound: "default",
        ),
      ),
      payload: jsonEncode(msg.data),
    );
  }

  void _handleTap(RemoteMessage msg) {
    final data = msg.data;
    log("🖱️ Tap Message Data: $data");
    log("🖱️ Tap Message Type: ${msg.messageType}");

    _navigateFromData(data);
  }

  void _onLocalNotificationTap(String payload) {
    try {
      final Map<String, dynamic> data = jsonDecode(payload);
      log("🖱️ Local Notification Tap Data: $data");
      _navigateFromData(data);
    } catch (e) {
      log("❌ Failed to parse payload: $e");
    }
  }

  void _navigateFromData(Map<String, dynamic> data) {
    final type = data['type'];
    final currentRoute = Get.currentRoute;
    log("📍 Current route: $currentRoute");

    if (type == 'appointment_canceled' || type == 'appointment_booked') {
      // Get.to(const DashboardScreen(
      //   initialIndex: 2,
      // ));
    } else {
      // Default action if unknown type
      // Get.toNamed(DashboardScreen.id);
    }
  }

  Future<void> _showSystemNotification(
    String? title,
    String? body,
    Map<String, dynamic> data,
  ) {
    return _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          showWhen: true,

          // sound: RawResourceAndroidNotificationSound('notification'),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          // sound: "notification.wav"
          sound: "default",
        ),
      ),
      payload: jsonEncode(data),
    );
  }

  Future<void> showSystemNotification(
    String? title,
    String? body,
    Map<String, dynamic> data,
  ) {
    return _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body:
      // MessagePreviewHelper.isMedia(body ?? '')
      //     ? MessagePreviewHelper.buildPreview(body ?? '')
      //     :
      body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          showWhen: true,

          // sound: RawResourceAndroidNotificationSound('notification'),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          // sound: "notification.wav"
          sound: "default",
        ),
      ),
      payload: jsonEncode(data),
    );
  }

  String buildMessagePreview(String message) {
    final ext = message.split('.').last.toLowerCase();

    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    const videoExtensions = ['mp4', 'mov', 'avi', 'mkv'];
    const voiceExtensions = ['mp3', 'wav', 'aac', 'm4a', 'ogg'];
    const fileExtensions = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt', 'zip'];

    if (imageExtensions.contains(ext)) {
      return 'chat.image_with_icon'.tr;
    }

    if (videoExtensions.contains(ext)) {
      return 'chat.video_with_icon'.tr;
    }

    if (voiceExtensions.contains(ext)) {
      return 'chat.voice_with_icon'.tr;
    }

    if (fileExtensions.contains(ext)) {
      return 'chat.file_with_icon'.tr;
    }

    return message;
  }


}
