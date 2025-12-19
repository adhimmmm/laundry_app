import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/routes/app_pages.dart';
import 'app/core/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://smsnzqjsuwofcbjnptbc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNtc256cWpzdXdvZmNiam5wdGJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMwMDk4MDksImV4cCI6MjA3ODU4NTgwOX0.DKw4f7GvdffOBhLTei7wAZNs6sdCBMG88Kpp9Is0jdw',
  );

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

      initialRoute: initialRoute,
      getPages: AppPages.pages,
    );
  }
}
