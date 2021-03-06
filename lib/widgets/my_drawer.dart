import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../assets/fonts.dart';
import '../assets/imgs.dart';
import '../controllers/btn_controllers.dart';
import '../lang/strs.dart';
import '../main.dart';
import '../services/localization_service.dart';
import '../util/feedback.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final width = size.width;
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
                      Strs.appName.tr,
                      style: Fonts.w900_18_FFC29409,
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StatefulBuilder(
                          builder: (context, setState) {
                            final ThemeController themeController = Get.find();
                            return AnimatedToggleSwitch<ThemeMode>.rolling(
                              current: themeController.mode,
                              values: const [
                                ThemeMode.light,
                                ThemeMode.dark,
                                ThemeMode.system
                              ],
                              onChanged: (value) {
                                setState(() {
                                  themeController.mode = value;
                                });
                                Future.delayed(
                                    const Duration(milliseconds: 500),
                                    (() => Get.changeThemeMode(
                                        themeController.mode)));
                              },
                              borderColor: Get.isDarkMode
                                  ? Theme.of(context).colorScheme.surface
                                  : Theme.of(context).colorScheme.primary,
                              colorBuilder: (value) => Get.isDarkMode
                                  ? Theme.of(context).colorScheme.surface
                                  : Theme.of(context).colorScheme.primary,
                              iconBuilder: (mode, size, active) => Icon(
                                mode == ThemeMode.system
                                    ? Icons.brightness_6_rounded
                                    : mode == ThemeMode.dark
                                        ? Icons.brightness_2_rounded
                                        : Icons.brightness_5_rounded,
                                size: size.shortestSide,
                                color: active
                                    ? Get.isDarkMode
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary
                                    : null,
                              ),
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
                            Strs.settingsStr.tr,
                            style: Fonts.w700_20,
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
                          onPressed: () {
                            languageBottomSheet(context);
                          },
                          icon: const Icon(Icons.language_rounded),
                          label: Text(
                            Strs.languagesStr.tr,
                            style: Fonts.w700_20,
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
                          onPressed: () {
                            Navigator.pop(context);
                            BetterFeedback.of(context).show((feedback) async {
                              final screenshotFilePath =
                                  await writeImageToStorage(
                                      feedback.screenshot);
                              sendFeedback(
                                  feedback.extra!['feedback_type'],
                                  feedback.extra!['feedback_text'],
                                  feedback.extra!['rating'],
                                  screenshotFilePath);
                            });
                          },
                          icon: const Icon(Icons.feedback_rounded),
                          label: Text(
                            Strs.feedbackStr.tr,
                            style: Fonts.w700_20,
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
                            Strs.aboutStr.tr,
                            style: Fonts.w700_20,
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
                          onPressed: btnRefreshTaped,
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(
                            Strs.refreshStr.tr,
                            style: Fonts.w700_20.copyWith(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  "${Strs.poweredByStr.tr}\n${Strs.imanGhasemiAraniStr.tr}",
                  style: Fonts.w700_20.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Object languageBottomSheet(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Get.bottomSheet(
      Padding(
        padding: EdgeInsets.symmetric(vertical: size.height / 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height / 50),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                  LocalizationService.changeLocale(Strs.englishLangStr);
                },
                child: SizedBox(
                  width: size.width / 1.3,
                  child: Text(
                    Strs.englishLangStr,
                    style: Fonts.w700_20.copyWith(color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height / 50),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                  LocalizationService.changeLocale(Strs.persianLangStr);
                },
                child: SizedBox(
                  width: size.width / 1.3,
                  child: Text(
                    Strs.persianLangStr,
                    style: Fonts.w700_20.copyWith(color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      enableDrag: false,
      backgroundColor: Colors.blueGrey,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
    );
  }
}
