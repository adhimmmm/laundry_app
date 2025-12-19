import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';

/// 🔥 WAJIB: handler background HARUS top-level
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('📦 BACKGROUND MESSAGE: ${message.notification?.title}');
}

class NotificationService extends GetxService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  /// ================= ANDROID CHANNEL =================
  /// ⚠️ SOUND HARUS ADA DI: android/app/src/main/res/raw/
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'channel_chat_like',
        'Chat Like Notification',
        description: 'Notification like WhatsApp / Shopee',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notif'),
      );

  /// ================= INIT =================
  Future<NotificationService> init() async {
    await _requestPermission();
    await _initLocalNotification();
    await _getToken();

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    _listenForeground();
    _listenNotificationClick();

    return this;
  }

  /// ================= PERMISSION =================
  Future<void> _requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log('🔐 PERMISSION: ${settings.authorizationStatus}');
  }

  /// ================= TOKEN =================
  Future<void> _getToken() async {
    try {
      final token = await _fcm.getToken();
      log('🔥 FCM TOKEN: $token');
    } catch (e) {
      log('❌ TOKEN ERROR: $e');
    }
  }

  /// ================= LOCAL NOTIFICATION INIT =================
  Future<void> _initLocalNotification() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotif.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          _handlePayload(response.payload!);
        }
      },
    );

    // 🔥 CREATE CHANNEL (WAJIB ANDROID 8+)
    await _localNotif
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  /// ================= FOREGROUND =================
  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification == null) return;

      log('📲 FOREGROUND: ${notification.title}');

      _localNotif.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            importance: Importance.max,
            priority: Priority.high,
            sound: _androidChannel.sound,
            playSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    });
  }

  /// ================= CLICK HANDLER =================
  void _listenNotificationClick() {
    // BACKGROUND
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handlePayload(jsonEncode(message.data));
    });

    // TERMINATED
    _fcm.getInitialMessage().then((message) {
      if (message != null) {
        _handlePayload(jsonEncode(message.data));
      }
    });
  }

  /// ================= PAYLOAD HANDLER =================
  void _handlePayload(String payload) {
    final data = jsonDecode(payload);

    log('📦 PAYLOAD: $data');

    /// 🎯 SEMUA NOTIF → MAIN VIEW
    if (Get.currentRoute != Routes.MAIN_VIEW) {
      Get.offAllNamed(Routes.MAIN_VIEW);
    }
  }
}
