import 'package:flutter/material.dart';

import 'widgets/main_body.dart';
import 'models/models.dart';

class ThirdLayer extends StatefulWidget {
  const ThirdLayer({Key? key}) : super(key: key);

  @override
  State<ThirdLayer> createState() => _ThirdLayerState();
}

class _ThirdLayerState extends State<ThirdLayer> {
  List<Widget> musicItemWidgetsList = <Widget>[];
  final ScrollController _controller = ScrollController();

  void createWidgets() {
    List<Widget> items = <Widget>[];
    UserData().audiosMetadata.forEach((audioMetadata) {
      items.add(Card(
        child: Container(height: 100, child: Center(child: Text(audioMetadata.title))),
      ));
    });

    setState(() {
      musicItemWidgetsList = items;
    });
  }

  @override
  void initState() {
    super.initState();
    createWidgets();
    _controller.addListener(() {
      // MainBody.closeTopLayer.value = _controller.offset > 50;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          itemCount: musicItemWidgetsList.length,
          itemBuilder: (buildContext, index) {
            return musicItemWidgetsList[index];
          }),
    );
  }
}
