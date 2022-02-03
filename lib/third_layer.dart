import 'dart:collection';

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';

import 'models/models.dart';
import 'music_item_widget.dart';

typedef UpdateWidget = Function();

class ThirdLayer extends StatefulWidget {
  const ThirdLayer({Key? key}) : super(key: key);

  @override
  _ThirdLayerState createState() => _ThirdLayerState();
}

class _ThirdLayerState extends State<ThirdLayer> {
  final HashMap<int, Widget> widgets = HashMap<int, Widget>();
  final scrollController = ScrollController();
  final LiveOptions options = const LiveOptions(
    delay: Duration.zero,
    visibleFraction: 0.000000000001,
    showItemInterval: Duration(milliseconds: 30),
    showItemDuration: Duration(milliseconds: 300),
    reAnimateOnVisibility: false,
  );

  static late UpdateWidget updateWidget;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    return LiveSliverGrid.options(
      options: options,
      controller: scrollController,
      itemCount: UserData().audiosMetadata.length,
      itemBuilder: buildAnimatedItem,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
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
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(animation),
          child: getChild(index),
        ),
      );

  Widget getChild(int index) {
    if (widgets[index] == null) {
      Widget tmp = MusicItemWidget(
          // key: UniqueKey(),
          index: index,
          audioMetadata: UserData().audiosMetadata[index]);
      widgets[index] = tmp;
      return tmp;
    }
    return widgets[index]!;
  }

  List<Widget> getChildren() {
    List<Widget> tmp = <Widget>[];
    for (var element in UserData().audiosMetadata) {
      tmp.add(getChild(UserData().audiosMetadata.indexOf(element)));
    }
    return tmp;
  }
}
