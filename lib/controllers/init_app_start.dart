import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/notification_service.dart';
import '../services/audio_manager.dart';
import '../services/localization_service.dart';
import '../services/service_locator.dart';
import 'file_manager.dart';

Future<void> initAppStart() async {
  sharedPreferences = await SharedPreferences.getInstance();
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.androidInfo;
  final infoMap = {
    'model': deviceInfo.model,
    'version': deviceInfo.version.release,
    'display': deviceInfo.display,
    'sdk': deviceInfo.version.sdkInt,
    'codename': deviceInfo.version.codename
  };

  NotificationService().init();
  await setupServiceLocator();
  await permissionsRequest().then((value) async {
    if (value) {
      Get.put(LocalizationService(
        sharedPreferences.getString('language') ?? 'English',
      ));
      Get.put(ThemeController(ThemeMode.values
          .byName(sharedPreferences.getString("themeMode") ?? "system")));
      await fastLoadUserData();
      Future.delayed(const Duration(seconds: 5), checkStorage);
      AudioManager();
    }
  });
}
