import 'package:flutter/material.dart';

import 'offline/offline_screen.dart';
import 'online/online_screen.dart';

class ScreenHolder extends StatelessWidget {
  const ScreenHolder({Key? key}) : super(key: key);

  static final currentTabNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ValueListenableBuilder<int>(
        valueListenable: currentTabNotifier,
        builder: (_, value1, __) {
          if (value1 == 0) {
            return const OfflineScreen();
          } else {
            return const OnlineScreen();
          }
        },
      ),
    );
  }
}
