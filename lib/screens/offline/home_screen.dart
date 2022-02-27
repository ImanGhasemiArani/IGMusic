import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/value_notifier.dart';
import '../../models/user_data.dart';
import '../../util/log.dart';
import '../../widgets/card/card_item_song.dart';
import '../../widgets/menu/menu_container_main_boy.dart';
import '../../widgets/playlists_widget.dart';
import '../../widgets/recently_songs.dart';

List<Widget> musicItemWidgetsList = <Widget>[];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _controller = ScrollController();
  bool closeTopLayer = false;
  double topItem = 0;

  @override
  void initState() {
    super.initState();
    createWidgets();
    _controller.addListener(() {
      double value = _controller.offset /
          ((MediaQuery.of(context).size.height / 5 + 20) * 0.7);
      setState(() {
        topItem = value;
        closeTopLayer = _controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Column(
        children: [
          GestureDetector(
              onTap: () {
                _controller.jumpTo(0);
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                alignment: Alignment.centerLeft,
                child: Text(
                    "Recently Songs" + (closeTopLayer ? " (Tap to open)" : ""),
                    style: GoogleFonts.fuzzyBubbles(fontSize: 14)),
              )),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: closeTopLayer ? 0 : 1,
            child: AnimatedContainer(
                curve: Curves.decelerate,
                duration: const Duration(milliseconds: 300),
                width: size.width,
                alignment: Alignment.topCenter,
                height: closeTopLayer ? 0 : size.height * 0.2,
                child: const RecentlySong()),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            alignment: Alignment.centerLeft,
            child: Text("Playlists",
                style: GoogleFonts.fuzzyBubbles(fontSize: 14)),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: closeTopLayer ? 0 : 1,
            child: AnimatedContainer(
                curve: Curves.decelerate,
                duration: const Duration(milliseconds: 300),
                width: size.width,
                alignment: Alignment.topCenter,
                height: closeTopLayer ? 0 : size.width / 4 + 15,
                child: const PlaylistsWidget()),
          ),
          const MenuContainerMainBody(),
          Expanded(
            child: ValueListenableBuilder<bool>(
                valueListenable: songsMetadataNotifier,
                builder: (_, value, __) {
                  return ListView.builder(
                      controller: _controller,
                      addAutomaticKeepAlives: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: musicItemWidgetsList.length,
                      itemBuilder: (buildContext, index) {
                        double scale = 1.0;
                        if (topItem > 0.5) {
                          scale = index + 0.5 - topItem;
                          if (scale < 0) {
                            scale = 0;
                          } else if (scale > 1) {
                            scale = 1;
                          }
                        }
                        return Opacity(
                          opacity: scale,
                          child: Transform(
                            transform: Matrix4.identity()..scale(scale, scale),
                            alignment: Alignment.topCenter,
                            child: Align(
                                heightFactor: 0.7,
                                alignment: Alignment.topCenter,
                                child: musicItemWidgetsList[index]),
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}

void createWidgets() {
  List<Widget> items = <Widget>[];
  int i = 0;
  // ignore: avoid_function_literals_in_foreach_calls
  UserData().audiosMetadata.forEach((audioMetadata) {
    items.add(
      CardItemSong(
        audioMetadata: audioMetadata,
        index: i++,
      ),
    );
  });
  items.add(Container(
    height: 150,
  ));

  logging("Songs number -> $i");

  musicItemWidgetsList = items;
}
