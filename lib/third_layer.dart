import 'dart:collection';

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';

import 'file_manager.dart';
import 'music_item_widget.dart';

typedef UpdateWidget = Function();

class ThirdLayer extends StatefulWidget {
  const ThirdLayer({Key? key}) : super(key: key);

  @override
  ThirdLayerState createState() => ThirdLayerState();
}

class ThirdLayerState extends State<ThirdLayer> {
  final HashMap<int, Widget> widgets = HashMap<int, Widget>();
  final scrollController = ScrollController();
  final LiveOptions options = const LiveOptions(
    delay: Duration(seconds: 1),
    showItemInterval: Duration(milliseconds: 50),
    showItemDuration: Duration(milliseconds: 400),
    reAnimateOnVisibility: false,
  );

  static late UpdateWidget updateWidget;

  @override
  void initState() {
    super.initState();
    updateWidget = () {
      setState(() {});
    };
    Future.delayed(const Duration(seconds: 0), load);
  }

  @override
  Widget build(BuildContext context) {
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    return LiveSliverGrid.options(
      // key: ValueKey<int>(UserData().audiosMetadata.length),
      options: options,
      controller: scrollController,
      itemCount: UserData().audiosMetadata.length,
      itemBuilder: buildAnimatedItem,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }

  Widget buildAnimatedItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) =>
      FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 5),
            end: Offset.zero,
          ).animate(animation),
          child: getChild(index),
        ),
      );

  Widget getChild(int index) {
    if (widgets[index] == null) {
      Widget tmp = MusicItemWidget(
        // key: UniqueKey(),
          index: index, audioMetadata: UserData().audiosMetadata[index]);
      widgets[index] = tmp;
      return tmp;
    }
    return widgets[index]!;
  }

  void load() async {
    await updateAudios();
    setState(() {});
  }
}
