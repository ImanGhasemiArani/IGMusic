import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'util/extensions.dart';
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
  SharedPreferences.getInstance().then((instance) {
    sharedPreferences = instance;
    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(instance.getString("theme") ?? 'null'),
        child: const MainMaterial(),
      ),
    );
  });
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
          //
          //
          //
          themeMode: Provider.of<ThemeNotifier>(context).getTheme(),
          //
          theme: ThemeData(
            bottomSheetTheme:
                const BottomSheetThemeData(backgroundColor: Colors.transparent),
            brightness: Brightness.light,
            iconTheme: const IconThemeData(color: Colors.black),
            textTheme:
                const TextTheme(bodyText2: TextStyle(color: Colors.black)),
            colorScheme: const ColorScheme.light().copyWith(
              secondary: Colors.amber,
              onSecondary: Colors.black,
              tertiary: Colors.teal,
              onTertiary: Colors.black,
            ),
          ),
          //
          darkTheme: ThemeData(
            bottomSheetTheme:
                const BottomSheetThemeData(backgroundColor: Colors.transparent),
            brightness: Brightness.dark,
            iconTheme: const IconThemeData(color: Color(0xFFBDBDBD)),
            textTheme:
                const TextTheme(bodyText2: TextStyle(color: Color(0xFFBDBDBD))),
            colorScheme: const ColorScheme.dark().copyWith(
              secondary: Colors.amber,
              onSecondary: Colors.black,
              tertiary: Colors.teal,
              onTertiary: Colors.black,
            ),
          ),
          //
          //
          //
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

class ThemeNotifier with ChangeNotifier {
  bool? _isDarkMode;
  ThemeNotifier(String isDarkMode) {
    _isDarkMode = isDarkMode.parseBool();
  }

  getTheme() => _isDarkMode == null
      ? SchedulerBinding.instance!.window.platformBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light
      : _isDarkMode!
          ? ThemeMode.dark
          : ThemeMode.light;

  isDarkMode() => _isDarkMode;

  setTheme(bool? isDarkMode) async {
    _isDarkMode = isDarkMode;
    sharedPreferences.setString("theme", isDarkMode.toString());
    notifyListeners();
  }
}
