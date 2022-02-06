import 'package:flutter/material.dart';

import '../../widgets/appbar/app_bar.dart';
import 'home_screen.dart';
import 'playlist_screen.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  static final currentBodyNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: searchAppBar(),
      body: ValueListenableBuilder<int>(
        valueListenable: currentBodyNotifier,
        builder: (_, value2, __) {
          switch (value2) {
            case 0:
              return const HomeScreen();
            case 1:
              return const PlaylistScreen();
          }
          return const HomeScreen();
        },
      ),
    );
  }
}
