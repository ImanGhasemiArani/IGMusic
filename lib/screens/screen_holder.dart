import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';

import '../assets/fnt_styles.dart';
import '../widgets/bottom_nav_bar.dart';
import 'offline/offline_screen.dart';
import 'online/online_screen.dart';

class ScreenHolder extends StatelessWidget {
  const ScreenHolder({Key? key}) : super(key: key);

  static final currentTabNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child:
                      Text("Tap back again to leave", style: FntStyles.tmp))),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        child: Stack(children: [
          ValueListenableBuilder<int>(
            valueListenable: currentTabNotifier,
            builder: (_, value1, __) {
              if (value1 == 0) {
                return const OfflineScreen();
              } else {
                return const OnlineScreen();
              }
            },
          ),
          BottomNavBar(
            size: MediaQuery.of(context).size,
          )
        ]),
      ),
    );
  }
}
