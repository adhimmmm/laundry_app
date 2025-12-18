import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const _key = 'isDarkMode';

  /// load theme saat app start
  static Future<ThemeMode> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_key) ?? false;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  /// toggle theme
  static Future<void> switchTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = Get.isDarkMode;
    await prefs.setBool(_key, !isDark);

    Get.changeThemeMode(!isDark ? ThemeMode.dark : ThemeMode.light);
  }
}