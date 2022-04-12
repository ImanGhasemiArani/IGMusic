import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../lang/strs.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/my_drawer.dart';
import 'offline/offline_screen.dart';
import 'online/online_screen.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class ScreenHolder extends StatelessWidget {
  const ScreenHolder({Key? key}) : super(key: key);

  static final currentTabNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: const MyDrawer(),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: FittedBox(
            alignment: Alignment.center,
            fit: BoxFit.scaleDown,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: const Color(0xFF303030),
              ),
              alignment: Alignment.center,
              child: Text(
                Strs.doubleTapToClose.tr,
                style: const TextStyle(
                  fontFamily: "Peyda",
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
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
          BottomNavBar(),
        ]),
      ),
    );
  }
}
