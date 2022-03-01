import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key, required this.isDark}) : super(key: key);

  bool? isDark;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
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
              child: StatefulBuilder(builder: (context, setState) {
                return AnimatedToggleSwitch<bool?>.rolling(
                  current: isDark,
                  values: const [false, true, null],
                  onChanged: (value) {
                    setState(() {
                      isDark = value;
                    });
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Provider.of<ThemeNotifier>(context, listen: false)
                          .setTheme(value);
                    });
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
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
