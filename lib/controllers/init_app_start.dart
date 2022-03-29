import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/notification_service.dart';
import '../services/audio_manager.dart';
import '../services/service_locator.dart';
import 'file_manager.dart';

Future<void> initAppStart() async {
  NotificationService().init();
  await GetStorage.init();
  await setupServiceLocator();
  await permissionsRequest().then((value) async {
    if (value) {
      sharedPreferences = await SharedPreferences.getInstance();
      await fastLoadUserData();
      Future.delayed(const Duration(seconds: 5), checkStorage);
      AudioManager();
    }
  });
  Get.put(ThemeController(
      ThemeMode.values.byName(GetStorage().read("themeMode") ?? "system")));
}
