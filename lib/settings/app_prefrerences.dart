import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefrerences extends ChangeNotifier {
  late SharedPreferences _prefs;

  Map<String, String> locale = {
    'locale': 'pt_BR',
    'name': 'R\$',
  };

  AppPrefrerences() {
    _startSettings();
  }

  _startSettings() async {
    await _startPrefs();
    await _readLocale();
  }

  Future<void> _startPrefs() async {
    // sistema do shared prefs inicializado
    _prefs = await SharedPreferences.getInstance();
  }

  _readLocale() {
    final local = _prefs.getString('locale') ?? 'pt_BR';
    final name = _prefs.getString('name') ?? 'R\$';
    locale = {
      'locale': local,
      'name': name,
    };
    notifyListeners();
  }

  setLocate(String local, String name) async {
    await _prefs.setString('locale', local);

    await _prefs.setString('name', name);

    await _readLocale();
  }
}
