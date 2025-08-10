import 'package:flutter/material.dart';

class LanguageService with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void changeLanguage(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }
}

class AppTranslations {
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'Settings',
      'general': 'General',
      'terms': 'Terms & Conditions',
      'privacy': 'Privacy Policy',
      'help': 'Help & Support',
      'appInfo': 'App Information',
      'logout': 'Logout',
      'language': 'Language',
      'english': 'English',
      'tamil': 'Tamil',
      'logout_confirmation': 'Are you sure you want to logout?',
      'cancel': 'Cancel',
      // Home page translations
      'pregnancy_companion': 'Pregnancy Companion',
      'hello_mom': 'Hello, Mom-to-be!',
      'track_journey': 'Track your pregnancy journey with us',
      'track_pregnancy': 'Track your Pregnancy',
      'pregnancy_date': 'Pregnancy Date',
      'awareness_post': 'Awareness Post',
      'appointment': 'Appointment',
      'screening': 'Screening',
      'reports': 'Reports',
      'baby_growth': 'Baby Growth',
      'daily_tip': 'Daily Tip',
      'tip_content': 'Stay hydrated! Drink at least 8-10 glasses of water daily to support your increased blood volume and amniotic fluid.',
    },
    'ta': {
      'settings': 'அமைப்புகள்',
      'general': 'பொது',
      'terms': 'விதிமுறைகள் மற்றும் நிபந்தனைகள்',
      'privacy': 'தனியுரிமைக் கொள்கை',
      'help': 'உதவி & ஆதரவு',
      'appInfo': 'பயன்பாட்டு தகவல்',
      'logout': 'வெளியேறு',
      'language': 'மொழி',
      'english': 'ஆங்கிலம்',
      'tamil': 'தமிழ்',
      'logout_confirmation': 'நீங்கள் வெளியேற விரும்புகிறீர்களா?',
      'cancel': 'ரத்து செய்',
      // Home page translations
      'pregnancy_companion': 'கர்ப்ப துணை',
      'hello_mom': 'வணக்கம், அம்மா!',
      'track_journey': 'உங்கள் கர்ப்ப பயணத்தை எங்களுடன் கண்காணிக்கவும்',
      'track_pregnancy': 'உங்கள் கர்ப்பத்தை கண்காணிக்கவும்',
      'pregnancy_date': 'கர்ப்ப தேதி',
      'awareness_post': 'விழிப்புணர்வு இடுகை',
      'appointment': 'நியமனம்',
      'screening': 'திரையிடல்',
      'reports': 'அறிக்கைகள்',
      'baby_growth': 'குழந்தை வளர்ச்சி',
      'daily_tip': 'தினசரி உதவிக்குறிப்பு',
      'tip_content': 'நீரேற்றமாக இருங்கள்! உங்கள் அதிகரித்த இரத்த அளவு மற்றும் கருநீர் ஆதரவுக்கு தினசரி குறைந்தது 8-10 கிளாஸ் தண்ணீர் குடிக்கவும்.',
    },
  };

  static String translate(BuildContext context, String key) {
    final locale = Localizations.localeOf(context).languageCode;
    return _localizedValues[locale]?[key] ?? _localizedValues['en']![key]!;
  }
}