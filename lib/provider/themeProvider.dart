import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;
  ThemeChanger();
  Future<void> addThemeToSF(bool theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme', theme);
    print(_themeData);
    print("theme saved to shared preference");
  }

  ThemeData get currentTHeme {
    return _themeData;
  }

  Future<ThemeData> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("theme") == true) {
      _themeData = ThemeData.light();
      return ThemeData.light();
    } else {
      _themeData = ThemeData.dark();

      return ThemeData.dark();
    }
  }

  setTheme(ThemeData theme) {
    print("theme changed");
    _themeData = theme;
    if (theme == ThemeData.light()) {
      addThemeToSF(true);
    } else {
      addThemeToSF(false);
    }
    notifyListeners();
  }
}
