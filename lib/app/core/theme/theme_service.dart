import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  final _box = GetStorage();
  final _key = 'isDarkMode';

  bool get isDarkMode => _box.read(_key) ?? false;

  ThemeMode get themeMode =>
      isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    final newMode = !isDarkMode;
    _box.write(_key, newMode);
    Get.changeThemeMode(
      newMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
