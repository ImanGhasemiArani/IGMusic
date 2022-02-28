import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assets/fnt_styles.dart';
import '../main.dart';
import '../widgets/bottom_nav_bar.dart';
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
      drawer: Container(
        width: size.width / 2,
        margin: const EdgeInsets.fromLTRB(20, 100, 0, 100),
        child: Drawer(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: ListView(
            children: [
              FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
                child: AnimatedToggleSwitch<bool?>.rolling(
                  current: Provider.of<ThemeNotifier>(context).isDarkMode(),
                  values: const [false, true, null],
                  onChanged: (value) {
                    Provider.of<ThemeNotifier>(context, listen: false)
                        .setTheme(value);
                  },
                  borderColor: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.primary,
                  colorBuilder: (value) {
                    var isDark =
                        Theme.of(context).brightness == Brightness.dark;
                    return isDark
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.primary;
                  },
                  iconBuilder: (bool? i, Size size, bool active) {
                    IconData data;
                    if (i == null) {
                      data = Icons.brightness_6_rounded;
                    } else if (i) {
                      data = Icons.brightness_2_rounded;
                    } else {
                      data = Icons.brightness_5_rounded;
                    }
                    var isDark =
                        Theme.of(context).brightness == Brightness.dark;
                    return Icon(
                      data,
                      size: size.shortestSide,
                      color: active
                          ? isDark
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary
                          : null,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
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
            size: size,
          )
        ]),
      ),
    );
  }
}
