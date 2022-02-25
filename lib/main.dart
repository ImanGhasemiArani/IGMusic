import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'controllers/file_manager.dart';
import 'models/notification_service.dart';
import 'screens/screen_holder.dart';
import 'screens/splash/splash_screen.dart';
import 'util/log.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  NotificationService().init();

  runApp(const MainMaterial());
}

class MainMaterial extends StatelessWidget {
  const MainMaterial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logging("Start App", isShowTime: true);

    return Builder(builder: (context) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "IGMusic",
          theme: ThemeData(
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Colors.transparent,
            ),
            primarySwatch: Colors.amber,
          ),
          home: FutureBuilder<bool>(
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data as bool) {
                FlutterNativeSplash.remove();
                return const ScreenHolder();
              }
              return const SplashScreen();
            },
            future: preLoadDat(),
          ));
    });
  }

  Future<bool> preLoadDat() async {
    await permissionsRequest().then((value) async {
      if (value) {
        await fastLoadUserData();
        //   await checkStorage();
        Future.delayed(const Duration(seconds: 5), checkStorage);
      }
    });
    return true;
  }
}
