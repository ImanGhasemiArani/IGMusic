import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../assets/imgs.dart';
import '../main.dart';

// ignore: must_be_immutable
class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key, required this.isDark}) : super(key: key);

  bool? isDark;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final drawerHeight = size.height * 0.8;
    return Container(
      width: width / 2,
      height: drawerHeight,
      margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Drawer(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Image.asset(
                      Imgs.imgIconApp,
                      height: size.width / 4,
                      width: size.width / 4,
                    ),
                    Text(
                      "IG Music",
                      style: GoogleFonts.overlock(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StatefulBuilder(
                        builder: (context, setState) {
                          return AnimatedToggleSwitch<bool?>.rolling(
                            current: isDark,
                            values: const [false, true, null],
                            onChanged: (value) {
                              setState(() {
                                isDark = value;
                              });
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                Provider.of<ThemeNotifier>(context,
                                        listen: false)
                                    .setTheme(value);
                              });
                            },
                            borderColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Theme.of(context).colorScheme.surface
                                    : Theme.of(context).colorScheme.primary,
                            colorBuilder: (value) {
                              var isDark = Theme.of(context).brightness ==
                                  Brightness.dark;
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
                              var isDark = Theme.of(context).brightness ==
                                  Brightness.dark;
                              return Icon(
                                data,
                                size: size.shortestSide,
                                color: active
                                    ? isDark
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary
                                    : null,
                              );
                            },
                          );
                        },
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          enableFeedback: false,
                          elevation: 0,
                          primary: Colors.transparent,
                          onPrimary:
                              Theme.of(context).textTheme.bodyText2!.color,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.settings),
                        label: Text(
                          "Settings",
                          style: GoogleFonts.overlock(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          enableFeedback: false,
                          elevation: 0,
                          primary: Colors.transparent,
                          onPrimary:
                              Theme.of(context).textTheme.bodyText2!.color,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.language_rounded),
                        label: Text(
                          "Languages",
                          style: GoogleFonts.overlock(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          enableFeedback: false,
                          elevation: 0,
                          primary: Colors.transparent,
                          onPrimary:
                              Theme.of(context).textTheme.bodyText2!.color,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.feedback_rounded),
                        label: Text(
                          "Feedback",
                          style: GoogleFonts.overlock(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          enableFeedback: false,
                          elevation: 0,
                          primary: Colors.transparent,
                          onPrimary:
                              Theme.of(context).textTheme.bodyText2!.color,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.info_rounded),
                        label: Text(
                          "About",
                          style: GoogleFonts.overlock(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  "Powered by:\nIman Ghasemi Arani",
                  style: GoogleFonts.overlock(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
