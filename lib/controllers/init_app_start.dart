import 'package:shared_preferences/shared_preferences.dart';

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
      await fastLoadUserData();
      Future.delayed(const Duration(seconds: 5), checkStorage);
      AudioManager();
    }
  });
}
