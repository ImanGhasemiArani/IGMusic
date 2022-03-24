import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'controllers/init_app_start.dart';
import 'util/extensions.dart';
import 'controllers/file_manager.dart';
import 'screens/screen_holder.dart';
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
      child: ChangeNotifierProvider<ThemeNotifier>(
        create: (_) =>
            ThemeNotifier(sharedPreferences.getString("theme") ?? 'null'),
        child: const MainMaterial(),
      ),
    ),
  );
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
        //
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
        //
        //
        //
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

  Future<void> setTheme(bool? isDarkMode) async {
    _isDarkMode = isDarkMode;
    sharedPreferences.setString("theme", isDarkMode.toString());
    notifyListeners();
  }
}
