import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

CustomTheme customTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;

  CustomTheme() {
    loadPrefs();
  }

  ThemeData get currentTheme => _isDarkTheme
      ? ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: Colors.black,
          brightness: Brightness.dark,
          backgroundColor: const Color(0xFF212121),
          accentColor: Colors.blue,
          accentIconTheme: const IconThemeData(color: Colors.blue),
          // dividerColor: Colors.black12,
        )
      : ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: Colors.white,
          brightness: Brightness.light,
          backgroundColor: const Color(0xFFE5E5E5),
          // scaffoldBackgroundColor: Colors.grey[200],
          accentColor: Colors.blue,
          accentIconTheme: const IconThemeData(color: Colors.blue),
          // dividerColor: Colors.white54,
        );

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    saveToPrefs();
    notifyListeners();
  }

  void saveToPrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('theme', _isDarkTheme);
  }

  void loadPrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _isDarkTheme = _prefs.getBool('theme') ?? false;
    notifyListeners();
  }
}
