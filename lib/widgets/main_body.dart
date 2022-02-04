import 'package:flutter/material.dart';
import 'package:ig_music/widgets/song_item_widget.dart';
import 'package:ig_music/widgets/top_container_main_body.dart';

import '../models/models.dart';
import 'menu_container_main_boy.dart';

class MainBody extends StatefulWidget {
  const MainBody({Key? key}) : super(key: key);

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  final ScrollController _controller = ScrollController();
  List<Widget> musicItemWidgetsList = <Widget>[];
  bool closeTopLayer = false;
  double topItem = 0;
  double bottomItem = 0;

  void createWidgets() {
    List<Widget> items = <Widget>[];
    int i = 0;
    UserData().audiosMetadata.forEach((audioMetadata) {
      items.add(SongItemWidget(
        audioMetadata: audioMetadata,
        index: i++,
      ));
    });
    items.add(Container(
      height: 150,
      color: Colors.transparent,
    ));

    setState(() {
      musicItemWidgetsList = items;
    });
  }

  @override
  void initState() {
    super.initState();
    createWidgets();
    _controller.addListener(() {
      double value = _controller.offset / ((MediaQuery.of(context).size.height / 5 + 20) * 0.7);
      double value2 = (_controller.offset + (MediaQuery.of(context).size.height)) /
          ((MediaQuery.of(context).size.height / 5 + 20) * 0.7);
      setState(() {
        topItem = value;
        bottomItem = value2;
        closeTopLayer = _controller.offset > 10;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Container(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: closeTopLayer ? 0 : 1,
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: size.width,
                  alignment: Alignment.topCenter,
                  height: closeTopLayer ? 0 : size.height / 9 + size.height / 6 + 25,
                  child: const TopContainerMainBody()),
            ),
            const MenuContainerMainBody(),
            Expanded(
              child: ListView.builder(
                  controller: _controller,
                  addAutomaticKeepAlives: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: musicItemWidgetsList.length,
                  itemBuilder: (buildContext, index) {
                    bool top = false;
                    bool bottom = false;
                    double scale = 1.0;
                    if (topItem > 0.5) {
                      top = true;
                      scale = index + 0.5 - topItem;
                      if (scale < 0) {
                        scale = 0;
                      } else if (scale > 1) {
                        scale = 1;
                        top = false;
                      }
                    }
                    if (bottomItem > 0.5 && !top) {
                      scale = 1 - index + 3.5 + topItem;
                      bottom = true;
                      if (scale < 0) {
                        scale = 0;
                      } else if (scale > 1) {
                        scale = 1;
                        bottom = false;
                      }
                    }
                    return Opacity(
                      opacity: scale,
                      child: Transform(
                        transform: Matrix4.identity()..scale(scale, scale),
                        alignment: bottom ? Alignment.bottomCenter : Alignment.topCenter,
                        child: Align(
                            heightFactor: 0.7,
                            alignment: Alignment.topCenter,
                            child: musicItemWidgetsList[index]),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
