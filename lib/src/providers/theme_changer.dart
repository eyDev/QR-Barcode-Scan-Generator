import 'package:flutter/material.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;
  FFNavigationBarTheme _navTheme;
  ThemeChanger(this._themeData, this._navTheme);

  getTheme() => _themeData;

  setTheme(ThemeData theme) {
    this._themeData = theme;
    notifyListeners();
  }

  getNavigationBarTheme() => _navTheme;

  setNavigationBarTheme(FFNavigationBarTheme theme) {
    this._navTheme = theme;
    notifyListeners();
  }
  //primaryColor: Color.fromRGBO(28, 86, 140, 1.0),
}
