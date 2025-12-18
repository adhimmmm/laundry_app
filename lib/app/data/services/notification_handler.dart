import 'package:firebase_messaging/firebase_messaging.dart';

/// 🔥 WAJIB: handler background HARUS top-level
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📦 Background message received');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
}

class FirebaseMessagingHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initPushNotification() async {
    // ================= PERMISSION =================
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('🔐 Authorization status: ${settings.authorizationStatus}');

    // ================= TOKEN =================
    String? token = await _firebaseMessaging.getToken();
    print('🔥 FCM Token: $token');

    // ================= TERMINATED =================
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      print(
        '🚀 App opened from terminated by notification: ${initialMessage.notification?.title}',
      );
    }

    // ================= FOREGROUND =================
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📲 Foreground message received');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
    });

    // ================= BACKGROUND =================
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}
