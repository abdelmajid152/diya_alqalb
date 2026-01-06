import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Theme controller to manage light/dark theme switching
class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _storage = GetStorage();
  final _key = 'isDarkMode';

  /// Observable for dark mode state
  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  /// Load saved theme preference from storage
  void _loadThemeFromStorage() {
    _isDarkMode.value = _storage.read(_key) ?? false;
    _updateTheme();
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _saveThemeToStorage();
    _updateTheme();
  }

  /// Set specific theme mode
  void setTheme({required bool isDark}) {
    _isDarkMode.value = isDark;
    _saveThemeToStorage();
    _updateTheme();
  }

  /// Save theme preference to storage
  void _saveThemeToStorage() {
    _storage.write(_key, _isDarkMode.value);
  }

  /// Apply theme change to the app
  void _updateTheme() {
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  /// Get current theme mode
  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
}
