import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // Default to English

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['en', 'ta'].contains(locale.languageCode)) return; // Only allow supported locales
    _locale = locale;
    notifyListeners();
  }
}