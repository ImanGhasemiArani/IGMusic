import 'package:flutter/material.dart';
import 'package:ig_music/assets/fonts.dart';

import '../../controllers/value_notifier.dart';
import '../../models/user_data.dart';
import '../../util/log.dart';
import '../../widgets/card/card_item_song.dart';
import '../../widgets/menu/menu_container_main_boy.dart';
import '../../widgets/playlists_widget.dart';
import '../../widgets/recently_songs.dart';

List<Widget> musicItemWidgetsList = <Widget>[];
final ScrollController controller = ScrollController();
var isCollapseTopItem = ValueNotifier<bool>(false);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double topItem = 0;

  @override
  void initState() {
    super.initState();
    createWidgets();
    controller.addListener(() {
      var size = MediaQuery.of(context).size;
      double value = controller.offset / ((size.height / 5 + 20) * 0.7);
      setState(() {
        topItem = value;
        isCollapseTopItem.value = controller.offset > 50;
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
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: isCollapseTopItem.value ? 0 : 1,
            child: AnimatedContainer(
              curve: Curves.decelerate,
              duration: const Duration(milliseconds: 500),
              width: size.width,
              alignment: Alignment.topCenter,
              height: isCollapseTopItem.value
                  ? 0
                  : size.height * 0.2 + size.width / 4 + 15 + 50 + 50,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                addAutomaticKeepAlives: true,
                shrinkWrap: true,
                children: [
                  Container(
                    height: 20,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Recently Songs",
                      style: Fonts.righteous_20,
                    ),
                  ),
                  const RecentlySong(),
                  Container(
                    height: 20,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Playlists",
                      style: Fonts.righteous_20,
                    ),
                  ),
                  const PlaylistsWidget(),
                ],
              ),
            ),
          ),
          const MenuContainerMainBody(),
          Expanded(
            child: ValueListenableBuilder<bool>(
                valueListenable: songsMetadataNotifier,
                builder: (_, value, __) {
                  return ListView.builder(
                      controller: controller,
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
