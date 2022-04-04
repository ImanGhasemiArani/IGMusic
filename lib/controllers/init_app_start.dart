import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ig_music/services/localization_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/notification_service.dart';
import '../services/audio_manager.dart';
import '../services/service_locator.dart';
import 'file_manager.dart';

Future<void> initAppStart() async {
  NotificationService().init();
  await setupServiceLocator();
  await permissionsRequest().then((value) async {
    if (value) {
      sharedPreferences = await SharedPreferences.getInstance();
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
