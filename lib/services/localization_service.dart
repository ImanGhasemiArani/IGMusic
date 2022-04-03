import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../lang/en_us.dart';
import '../lang/fa_ir.dart';

class LocalizationService extends Translations {
  static const locale = Locale('en', 'US');

  static const fallBackLocale = Locale('en', 'US');

  static final langs = [
    'English',
    'فارسی',
  ];

  static const locales = [
    Locale('en', 'US'),
    Locale('fa', 'IR'),
  ];

  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUS, 'fa_IR': faIR};

  void changeLocale(String localeName) {
    final locale = _getLocale(localeName);
    Get.updateLocale(locale);
  }

  Locale _getLocale(String lang) {
    try {
      return locales[langs.indexOf(lang)];
    } catch (e) {
      return Get.locale!;
    }
  }
}
