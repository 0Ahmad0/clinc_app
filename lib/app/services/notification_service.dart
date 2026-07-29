import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/utils/app_url.dart';
import 'storage_service.dart';

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();



  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  bool _isInitialized = false;
  StreamSubscription<String>? _tokenRefreshSubscription;

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
    _bindTokenRefreshListener();

    // Handle app opened by notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleTap(initialMessage);
    }

    _isInitialized = true;
    debugPrint('✅ NotificationService initialized');

    await _logFcmToken(trigger: 'app_launch');
    await syncDeviceTokenWithBackend(reason: 'app_launch');
  }

  Future<void> onLoginSuccess() async {
    await _logFcmToken(trigger: 'login_success');
    await syncDeviceTokenWithBackend(reason: 'login_success');
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
    await _logNotificationPermissionState(source: 'before_request');

    if (Platform.isAndroid) {
      final granted = await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      log(
        '🔔 [FCM] Android POST_NOTIFICATIONS request result: '
        '${granted == true ? 'granted' : 'denied_or_unknown'}',
      );
    }
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    log(
      '🔔 [FCM] requestPermission result: ${settings.authorizationStatus.name}',
    );
    await _logNotificationPermissionState(source: 'after_request');

    if (Platform.isIOS) {
      final apnsToken = await _messaging.getAPNSToken();
      log(
        '🍎 [FCM] APNs token after permission request: '
        '${_maskToken(apnsToken)}',
      );
      if (apnsToken == null || apnsToken.isEmpty) {
        log(
          '⚠️ [FCM] APNs token is empty. '
          'Reason: APNs registration may be pending or Push capability is missing.',
        );
      }
    }
  }

  Future<void> _logNotificationPermissionState({required String source}) async {
    final settings = await _messaging.getNotificationSettings();
    log(
      '🔔 [FCM][$source] permission status: '
      'auth=${settings.authorizationStatus.name}, '
      'alert=${settings.alert.name}, badge=${settings.badge.name}, '
      'sound=${settings.sound.name}',
    );
  }

  void _bindTokenRefreshListener() {
    _tokenRefreshSubscription ??= _messaging.onTokenRefresh.listen((token) async {
      log('🔄 [FCM] onTokenRefresh token: ${_maskToken(token)}');
      if (token.isEmpty) {
        log(
          '⚠️ [FCM] onTokenRefresh emitted empty token. '
          'Reason: Firebase could not issue a valid token yet.',
        );
        return;
      }
      await syncDeviceTokenWithBackend(reason: 'token_refresh', overrideToken: token);
    });
  }

  Future<String?> _logFcmToken({required String trigger}) async {
    try {
      final token = await _messaging.getToken();
      log('📲 [FCM][$trigger] token: ${_maskToken(token)}');
      if (token == null || token.isEmpty) {
        final settings = await _messaging.getNotificationSettings();
        if (settings.authorizationStatus == AuthorizationStatus.denied) {
          log(
            '⚠️ [FCM][$trigger] token is null/empty. '
            'Reason: notification permission denied.',
          );
        } else {
          log(
            '⚠️ [FCM][$trigger] token is null/empty. '
            'Reason: token not issued yet or Firebase/APNs registration is incomplete.',
          );
        }
      }
      return token;
    } catch (e, s) {
      log('❌ [FCM][$trigger] failed to get token: $e', stackTrace: s);
      return null;
    }
  }

  Future<void> syncDeviceTokenWithBackend({
    required String reason,
    String? overrideToken,
  }) async {
    final accessToken = StorageService.instance.getAccessToken();
    if (accessToken.isEmpty || StorageService.instance.isGuest) {
      log(
        'ℹ️ [FCM][$reason] skip backend sync. '
        'Reason: user not authenticated or is guest.',
      );
      return;
    }

    final token = overrideToken ?? await _messaging.getToken();
    if (token == null || token.isEmpty) {
      log(
        '⚠️ [FCM][$reason] skip backend sync. '
        'Reason: FCM token is null/empty.',
      );
      return;
    }

    final payload = await _buildDeviceTokenPayload(token);
    await _postDeviceTokenWithRetry(
      reason: reason,
      accessToken: accessToken,
      payload: payload,
    );
  }

  Future<Map<String, dynamic>> _buildDeviceTokenPayload(String token) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final localeCode = StorageService.instance.languageCode;
    return {
      'token': token,
      'platform': _resolvePlatform(),
      'device_id': await _resolveStableDeviceId(),
      'app_version': '${packageInfo.version}+${packageInfo.buildNumber}',
      'locale': localeCode,
    };
  }

  Future<void> _postDeviceTokenWithRetry({
    required String reason,
    required String accessToken,
    required Map<String, dynamic> payload,
  }) async {
    const retryDelays = <Duration>[
      Duration(seconds: 2),
      Duration(seconds: 4),
      Duration(seconds: 8),
    ];
    var attempt = 0;

    while (true) {
      attempt++;
      try {
        final dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
            validateStatus: (_) => true,
          ),
        );

        final headers = <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };

        _logDeviceTokenRequest(
          reason: reason,
          attempt: attempt,
          url: AppUrl.userDeviceToken,
          headers: headers,
          payload: payload,
        );

        final response = await dio.post(
          AppUrl.userDeviceToken,
          data: payload,
          options: Options(headers: headers),
        );

        _logDeviceTokenResponse(
          reason: reason,
          statusCode: response.statusCode,
          responseBody: response.data,
        );

        final statusCode = response.statusCode ?? 0;
        if (statusCode >= 200 && statusCode < 300) {
          return;
        }

        final shouldRetry = statusCode >= 500 && attempt <= retryDelays.length;
        if (!shouldRetry) return;
      } on DioException catch (e, s) {
        final isNetworkFailure =
            e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout;
        log(
          '❌ [FCM][$reason] device-token request failed (attempt $attempt): '
          '${e.type} ${e.message}',
          stackTrace: s,
        );

        if (!isNetworkFailure || attempt > retryDelays.length) {
          return;
        }
      } catch (e, s) {
        log(
          '❌ [FCM][$reason] unexpected sync error on attempt $attempt: $e',
          stackTrace: s,
        );
        return;
      }

      final delay = retryDelays[attempt - 1];
      log(
        '🔁 [FCM][$reason] scheduling retry after ${delay.inSeconds}s '
        'because of network/server failure.',
      );
      await Future.delayed(delay);
    }
  }

  void _logDeviceTokenRequest({
    required String reason,
    required int attempt,
    required String url,
    required Map<String, String> headers,
    required Map<String, dynamic> payload,
  }) {
    final maskedHeaders = Map<String, String>.from(headers);
    final authHeader = maskedHeaders['Authorization'];
    if (authHeader != null) {
      maskedHeaders['Authorization'] = 'Bearer ${_maskToken(authHeader.replaceFirst('Bearer ', ''))}';
    }
    final maskedPayload = Map<String, dynamic>.from(payload);
    if (maskedPayload['token'] is String) {
      maskedPayload['token'] = _maskToken(maskedPayload['token'] as String?);
    }
    if (maskedPayload['fcm_token'] is String) {
      maskedPayload['fcm_token'] =
          _maskToken(maskedPayload['fcm_token'] as String?);
    }

    log('➡️ [FCM][$reason] /api/user/device-token request (attempt $attempt)');
    log('🌐 URL: $url');
    log('🧾 Headers: $maskedHeaders');
    log('📦 Payload: $maskedPayload');
  }

  void _logDeviceTokenResponse({
    required String reason,
    required int? statusCode,
    required dynamic responseBody,
  }) {
    log('⬅️ [FCM][$reason] /api/user/device-token status: $statusCode');
    log('📥 Response body: $responseBody');

    if (statusCode == 401 || statusCode == 403 || statusCode == 422) {
      log(
        '⚠️ [FCM][$reason] important backend response '
        '(full body for diagnostics): $responseBody',
      );
    }
  }

  String _resolvePlatform() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }

  Future<String> _resolveStableDeviceId() async {
    try {
      if (kIsWeb) return 'web';
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return androidInfo.id;
      }
      if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.identifierForVendor ?? 'ios_unknown';
      }
      return 'unsupported_platform';
    } catch (e) {
      log('⚠️ [FCM] failed to resolve device id: $e');
      return 'unknown_device';
    }
  }

  String _maskToken(String? token) {
    if (token == null || token.isEmpty) return '<empty>';
    if (token.length <= 12) return '***';
    return '${token.substring(0, 6)}...${token.substring(token.length - 4)}';
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

  void dispose() {
    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
  }
}
