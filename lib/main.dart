import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controllers/file_manager.dart';
import 'models/notification_service.dart';
import 'screens/screen_holder.dart';
import 'screens/splash/splash_screen.dart';
import 'util/log.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
            primarySwatch: Colors.grey,
          ),
          home: AnimatedSplashScreen.withScreenFunction(
            centered: true,
            curve: Curves.decelerate,
            splashIconSize: 150,
            disableNavigation: true,
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.white,
            splash: const SplashScreen(),
            screenFunction: () async {
              await permissionsRequest().then((value) async {
                if (value) {
                  await fastLoadUserData();
                  //   await checkStorage();
                  Future.delayed(const Duration(seconds: 5), checkStorage);
                }
              });

              externalMethods();

              return const ScreenHolder();
            },
          ));
    });
  }

  Future<void> externalMethods() async {}
}
