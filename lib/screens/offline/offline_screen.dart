import 'package:flutter/material.dart';

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
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: isCollapseTopItem,
        builder: (_, value, __) {
          return value
              ? FloatingActionButton(
                  onPressed: () {
                    controller.jumpTo(0);
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
                )
              : const SizedBox(width: 0, height: 0);
        },
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
