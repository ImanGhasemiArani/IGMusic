import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assets/fonts.dart';
import '../main.dart';
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: MyDrawer(
          isDark:
              Provider.of<ThemeNotifier>(context, listen: false).isDarkMode()),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                "Tap back again to leave",
                style: Fonts.fuzzyBubbles_11_ffffffff,
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
          BottomNavBar(
            size: size,
          )
        ]),
      ),
    );
  }
}
