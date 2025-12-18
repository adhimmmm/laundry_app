import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/core/services/theme_service.dart';
import 'app/data/services/notification_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Init GetStorage (kalau dipakai di tempat lain)
  await GetStorage.init();

  // 🔥 Load theme dari SharedPreferences
  final ThemeMode themeMode = await ThemeService.loadTheme();

  // 🔥 Init Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔥 Init Firebase Cloud Messaging
  await FirebaseMessagingHandler().initPushNotification();

  runApp(MyApp(themeMode: themeMode));
}

class MyApp extends StatelessWidget {
  final ThemeMode themeMode;

  const MyApp({super.key, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Laundry App',

      // 🔥 PAKAI THEME DARI SHARED PREF
      themeMode: themeMode,

      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F9FC),
        primaryColor: const Color(0xFF5B8DEF),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF5B8DEF),
      ),

      // ================= ROUTING =================
      initialRoute: Routes.MAIN_VIEW,
      getPages: AppPages.pages,
    );
  }
}
