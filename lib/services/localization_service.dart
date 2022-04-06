import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/file_manager.dart';
import '../lang/en_us.dart';
import '../lang/fa_ir.dart';

class LocalizationService extends Translations {
  LocalizationService(String initLang) {
    locale = _getLocale(initLang);
    _changeFontFamily(initLang);
  }

  late final Locale locale;

  static const fallBackLocale = Locale('en', 'US');

  static String? fontFamily;

  static final langs = [
    'English',
    'فارسی',
  ];

  static const locales = [
    Locale('en', 'US'),
    Locale('fa', 'IR'),
  ];

  static const fontFamilies = [
    'Roboto',
    'Peyda',
  ];

  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUS, 'fa_IR': faIR};

  static void changeLocale(String localeName) {
    sharedPreferences.setString('language', localeName);
    final locale = _getLocale(localeName);
    _changeFontFamily(localeName);
    Get.updateLocale(locale);
  }

  static void _changeFontFamily(String localeName) {
    try {
      fontFamily = fontFamilies[langs.indexOf(localeName)];
    } catch (e) {
      fontFamily = fontFamilies[0];
    }
  }

  static Locale _getLocale(String lang) {
    try {
      return locales[langs.indexOf(lang)];
    } catch (e) {
      return locales[0];
    }
  }
}
