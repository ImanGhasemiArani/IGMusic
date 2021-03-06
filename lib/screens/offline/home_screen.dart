import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/fonts.dart';
import '../../lang/strs.dart';
import '../../models/user_data.dart';
import '../../util/log.dart';
import '../../widgets/card/card_item_song.dart';
import '../../widgets/menu/menu_container_main_boy.dart';
import '../../widgets/playlists_widget.dart';
import '../../widgets/recently_songs.dart';

var isCollapseTopItem = false.obs;
List<Widget> musicItemWidgetsList = <Widget>[];

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Column(
        children: const [
          HomeScreenTopItems(),
          MenuContainerMainBody(),
          Expanded(
            child: HomeScreenSongView(),
          ),
        ],
      ),
    );
  }
}

class HomeScreenSongView extends StatelessWidget {
  const HomeScreenSongView({
    Key? key,
  }) : super(key: key);

  static final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final RxDouble topItem = 0.0.obs;
    controller.addListener(() {
      var size = MediaQuery.of(context).size;
      double value = controller.offset / ((size.height / 5 + 20) * 0.7);
      topItem.value = value;
      isCollapseTopItem.value = controller.offset > 50;
    });

    return Obx(
      () {
        createWidgets(UserData().audiosMetadata);
        return ListView.builder(
          controller: controller,
          addAutomaticKeepAlives: true,
          physics: const BouncingScrollPhysics(),
          itemCount: musicItemWidgetsList.length,
          itemBuilder: (buildContext, index) {
            return Obx(() {
              double scale = 1.0;
              if (topItem > 0.5) {
                scale = index + 0.5 - topItem.value;
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
          },
        );
      },
    );
  }
}

class HomeScreenTopItems extends StatelessWidget {
  const HomeScreenTopItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(
      () => AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: isCollapseTopItem.value ? 0 : 1,
        child: AnimatedContainer(
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 500),
          width: size.width,
          alignment: Alignment.topCenter,
          height: isCollapseTopItem.value
              ? 0
              : size.height * 0.2 + size.width / 4 + 8 + 25 + 15 + 25 + 10,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            addAutomaticKeepAlives: true,
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                child: SizedBox(
                  height: 25,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      Strs.recentlySongsStr.tr,
                      style: Fonts.bold_30,
                    ),
                  ),
                ),
              ),
              const RecentlySong(),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: SizedBox(
                  height: 25,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      Strs.playlistsStr.tr,
                      style: Fonts.bold_30,
                    ),
                  ),
                ),
              ),
              const PlaylistsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

void createWidgets(List songs) {
  List<Widget> items = <Widget>[];
  int i = 0;
  // ignore: avoid_function_literals_in_foreach_calls
  songs.forEach((audioMetadata) {
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
