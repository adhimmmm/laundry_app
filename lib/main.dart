import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/core/theme/theme_service.dart';
import 'app/data/services/notification_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Wajib untuk GetX Theme (dark / light)
  await GetStorage.init();

  // 🔥 Firebase init
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔥 Firebase Cloud Messaging init
  await FirebaseMessagingHandler().initPushNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Laundry App',

      // ================= LIGHT THEME =================
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF5B8DEF),
        scaffoldBackgroundColor: const Color(0xFFF8F9FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5B8DEF),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      // ================= DARK THEME =================
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF5B8DEF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF020617),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      // 🔥 Kunci dark mode GetX
      themeMode: ThemeService().themeMode,

      // ================= ROUTING =================
      initialRoute: Routes.MAIN_VIEW,
      getPages: AppPages.pages,
    );
  }
}
