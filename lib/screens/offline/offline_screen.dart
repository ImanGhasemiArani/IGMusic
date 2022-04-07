import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/app_bar.dart';
import 'home_screen.dart';
import 'playlist_screen.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  static final currentBodyNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchAppBar(context, AppBar().preferredSize),
      floatingActionButton: Obx(
        () => Visibility(
          visible: isCollapseTopItem.value,
          child: FloatingActionButton(
            onPressed: () {
              var milSec = HomeScreenSongView.controller.offset / 3;
              HomeScreenSongView.controller.animateTo(0,
                  curve: Curves.decelerate,
                  duration: Duration(milliseconds: milSec.toInt()));
            },
            enableFeedback: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            mini: true,
            elevation: 10,
            backgroundColor:
                Theme.of(context).colorScheme.surface.withOpacity(0.7),
            child: Icon(
              Icons.arrow_upward_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
