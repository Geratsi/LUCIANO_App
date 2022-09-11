import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('ru'),
    const Locale('es'),
  ];

  static String getLabel(String? countryCode) {
    switch (countryCode) {
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      case 'es':
        return 'Татарча';
      default:
        return 'Русский';
    }
  }
}
