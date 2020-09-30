import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  bool isLightTheme;

  ThemeProvider({this.isLightTheme});

  toggleTheme() async {
    final settings = await Hive.openBox('settings');

    settings.put('isLightTheme', !isLightTheme);
    isLightTheme = !isLightTheme;
    if (isLightTheme) {
      return ThemeData(accentColor: Colors.blueAccent);
    } else {
      return ThemeData(accentColor: Colors.black87);
    }

    // notifyListeners();
  }
}
