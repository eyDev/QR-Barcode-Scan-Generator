import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._();
  factory PreferenciasUsuario() {
    return _instancia;
  }
  PreferenciasUsuario._();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get primaryColor {
    return Color.fromRGBO(_prefs.getInt('red') ?? 28,
        _prefs.getInt('green') ?? 86, _prefs.getInt('blue') ?? 140, 1.0);
  }

  set primaryColor(Color value) {
    _prefs.setInt('red', value.red);
    _prefs.setInt('green', value.green);
    _prefs.setInt('blue', value.blue);
  }

  get darkMode {
    return _prefs.getBool('darkMode') ?? false;
  }

  set darkMode(bool value) {
    _prefs.setBool('darkMode', value);
  }

  get language {
    String sl = ui.window.locale.languageCode;
    if (sl != 'de' && sl != 'en' && sl != 'es' && sl != 'fr' && sl != 'it') {
      sl = 'en';
    }
    return _prefs.getString('language') ?? sl;
  }

  set language(String value) {
    _prefs.setString('language', value);
  }
}
