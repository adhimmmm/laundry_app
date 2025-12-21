import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loundry_app/app/core/models/notification_model.dart';
import 'package:loundry_app/app/core/services/notification_hive_service.dart';

import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/routes/app_pages.dart';
import 'app/core/services/theme_service.dart';
import 'app/core/models/notification_handler.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(); // Inisialisasi Firebase

  // Minta izin notifikasi (Penting untuk Android 13+)
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  await Hive.initFlutter();
  Hive.registerAdapter(NotificationModelAdapter());

  final notifHive = NotificationHiveService();
  await notifHive.init();

  Get.put(notifHive);

  // 🔥 Init GetStorageP
  await GetStorage.init();

  // 🔥 Load theme
  final ThemeMode themeMode = await ThemeService.loadTheme();

  // 🔥 Init Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔥 INIT NOTIFICATION SERVICE (BENAR)
  await Get.putAsync(() => NotificationService().init());

  // 🔥 Init Supabase
  await Supabase.initialize(
    url: 'https://smsnzqjsuwofcbjnptbc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNtc256cWpzdXdvZmNiam5wdGJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMwMDk4MDksImV4cCI6MjA3ODU4NTgwOX0.DKw4f7GvdffOBhLTei7wAZNs6sdCBMG88Kpp9Is0jdw',
  );

  /// 🔥 AUTO LOGIN CHECK
  final session = Supabase.instance.client.auth.currentSession;

  runApp(
    MyApp(
      themeMode: themeMode,
      initialRoute: session == null ? Routes.AUTH : Routes.MAIN_VIEW,
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
