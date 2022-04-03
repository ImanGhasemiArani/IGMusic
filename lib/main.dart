import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import 'controllers/file_manager.dart';
import 'controllers/init_app_start.dart';
import 'screens/screen_holder.dart';
import 'services/localization_service.dart';
import 'util/log.dart';
import 'widgets/custom_feedback.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  await initAppStart();
  runApp(
    BetterFeedback(
      feedbackBuilder: (context, onSubmit, scrollController) {
        return CustomFeedbackForm(
          onSubmit: onSubmit,
          scrollController: scrollController,
        );
      },
      child: const MainMaterial(),
    ),
  );
}

class MainMaterial extends StatelessWidget {
  const MainMaterial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logging("Start App", isShowTime: true);

    return Builder(builder: (context) {
      final ThemeController themeController = Get.find();
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        locale: LocalizationService.locale,
        fallbackLocale: LocalizationService.fallBackLocale,
        translations: LocalizationService(),
        themeMode: themeController.mode,
        theme: ThemeData(
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(40),
              ),
            ),
          ),
          brightness: Brightness.light,
          iconTheme: const IconThemeData(color: Colors.black),
          textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
          colorScheme: const ColorScheme.light().copyWith(
            secondary: Colors.amber,
            onSecondary: Colors.black,
            tertiary: Colors.teal,
            onTertiary: Colors.black,
          ),
        ),
        darkTheme: ThemeData(
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(50),
              ),
            ),
          ),
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
        title: "IGMusic",
        home: ScreenApp(),
      );
    });
  }
}

class ScreenApp extends StatelessWidget {
  ScreenApp({Key? key}) : super(key: key) {
    _widget = const ScreenHolder();
    FlutterNativeSplash.remove();
  }
  late final Widget _widget;

  @override
  Widget build(BuildContext context) {
    return _widget;
  }
}

class ThemeController {
  late ThemeMode _mode;

  ThemeController(this._mode);

  ThemeMode get mode => _mode;

  set mode(ThemeMode themeMode) {
    _mode = themeMode;
    sharedPreferences.setString("themeMode", _mode.name);
  }
}
