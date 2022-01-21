import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'file_manager.dart';
import 'main_page.dart';

void main() => runApp(const MainMaterial());

class MainMaterial extends StatelessWidget {
  const MainMaterial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      var time = DateTime.now();
      print(
          "Start App => time: ${time.minute}: ${time.second}: ${time.millisecond}");
    }
    // loadUserData();
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
        home: MainPage(),
      );
    });
  }
}
