import 'package:flutter/material.dart';
import 'package:get/get.dart';
<<<<<<< HEAD
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
=======
import 'package:supabase_flutter/supabase_flutter.dart';

>>>>>>> origin/main
import 'app/routes/app_pages.dart';
import 'app/core/services/theme_service.dart';
import 'app/data/services/notification_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

<<<<<<< HEAD
  // 🔥 Init GetStorage (kalau dipakai di tempat lain)
  await GetStorage.init();

  // 🔥 Load theme dari SharedPreferences
  final ThemeMode themeMode = await ThemeService.loadTheme();

  // 🔥 Init Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔥 Init Firebase Cloud Messaging
  await FirebaseMessagingHandler().initPushNotification();
=======
  await Supabase.initialize(
    url: 'https://smsnzqjsuwofcbjnptbc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNtc256cWpzdXdvZmNiam5wdGJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMwMDk4MDksImV4cCI6MjA3ODU4NTgwOX0.DKw4f7GvdffOBhLTei7wAZNs6sdCBMG88Kpp9Is0jdw',
  );
>>>>>>> origin/main

  final themeMode = await ThemeService.loadTheme();

  /// 🔥 AUTO LOGIN CHECK
  final session = Supabase.instance.client.auth.currentSession;

  runApp(
    MyApp(
      themeMode: themeMode,
      initialRoute:
          session == null ? Routes.AUTH : Routes.MAIN_VIEW,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeMode themeMode;
  final String initialRoute;

  const MyApp({
    super.key,
    required this.themeMode,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Laundry App',

<<<<<<< HEAD
      // 🔥 PAKAI THEME DARI SHARED PREF
=======
>>>>>>> origin/main
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

<<<<<<< HEAD
      // ================= ROUTING =================
      initialRoute: Routes.MAIN_VIEW,
=======
      initialRoute: initialRoute,
>>>>>>> origin/main
      getPages: AppPages.pages,
    );
  }
}
