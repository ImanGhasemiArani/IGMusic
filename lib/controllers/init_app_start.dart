import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/notification_service.dart';
import '../services/audio_manager.dart';
import '../services/localization_service.dart';
import '../services/service_locator.dart';
import 'file_manager.dart';

Future<void> initAppStart() async {
  sharedPreferences = await SharedPreferences.getInstance();
//   sharedPreferences.clear();
  NotificationService().init();
  !(sharedPreferences.get('isSendDeviceInfo') as bool? ?? false)
      ? await _initInternetWork()
      : null;
  await setupServiceLocator();
  await permissionsRequest().then((value) async {
    if (value) {
      Get.put(LocalizationService(
        sharedPreferences.getString('language') ??
            (WidgetsFlutterBinding.ensureInitialized()
                        .window
                        .locale
                        .languageCode ==
                    'fa'
                ? 'فارسی'
                : "English"),
      ));
      Get.put(ThemeController(ThemeMode.values
          .byName(sharedPreferences.getString("themeMode") ?? "system")));
      await fastLoadUserData();
      Future.delayed(const Duration(seconds: 5), checkStorage);
      AudioManager();
    }
  });
}

Future<void> _initInternetWork() async {
  var result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi) {
    await _initDatabase();
  }
}

Future<void> _initDatabase() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.androidInfo;
  final infoMap = {
    'model': deviceInfo.model ?? "null",
    'version':
        "${deviceInfo.version.release ?? "null"} ${deviceInfo.display ?? "null"}",
    'sdk': deviceInfo.version.sdkInt ?? 0,
  };
  await Parse().initialize(
    'LFfqRZZm7stkLIDHdnxded6EIlJsUQCeUjYyCSIi',
    'https://parseapi.back4app.com',
    clientKey: 'lV11wBilBDxOd4rF7NOpnmWXciL8W55VoxTNB2y0',
    autoSendSessionId: true,
  );
  var dataRef = ParseObject('Devices');
  infoMap.forEach((key, value) => dataRef.set(key, value));
  dataRef
      .save()
      .then((value) => sharedPreferences.setBool('isSendDeviceInfo', true));
}
