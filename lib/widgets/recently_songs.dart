import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../assets/fnt_styles.dart';
import '../controllers/audio_manager.dart';
import '../models/models.dart';
import 'card/card_recently_item_song.dart';

class RecentlySong extends StatelessWidget {
  const RecentlySong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ValueListenableBuilder<int>(
        valueListenable: AudioManager().recentlySongsNotifier,
        builder: (_, value, __) {
          return ExpandablePanel(
            header: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text("Recently Songs",
                  style: FntStyles.recentlyWidgetTextStyle),
            ),
            collapsed: Container(),
            controller: ExpandableController(
                initialExpanded: UserData().recentlyPlayedSongs.isNotEmpty),
            expanded: SizedBox(
              height: size.height * 0.2,
              width: size.width,
              child: UserData().recentlyPlayedSongs.isEmpty
                  ? Center(
                      child: Text("Empty! Play any Song!",
                          style: FntStyles.recentlyWidgetTextStyle),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      addAutomaticKeepAlives: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: UserData().recentlyPlayedSongs.length,
                      itemBuilder: (context, index) {
                        return CardRecentlyItemSong(
                            index: index,
                            audioMetadata: UserData().getSongBy(
                                id: UserData().recentlyPlayedSongs[index])!);
                      }),
            ),
          );
        });
  }
}
