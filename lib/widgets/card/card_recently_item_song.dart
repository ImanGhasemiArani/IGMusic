import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../assets/fonts.dart';
import '../../controllers/btn_controllers.dart';
import '../../models/song_metadata.dart';
import '../../models/user_data.dart';
import '../../screens/offline/song_screen.dart';
import '../../util/audio_info.dart';
import '../../util/util_artwork.dart';

// ignore: must_be_immutable
class CardRecentlyItemSong extends StatelessWidget {
  CardRecentlyItemSong(
      {Key? key, required this.index, required this.audioMetadata})
      : super(key: key) {
    var list = exportData(
        audioMetadata.title, audioMetadata.artist, audioMetadata.album);
    trackName = list[0];
  }

  final int index;
  final SongMetadata audioMetadata;
  late String trackName;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
      child: OpenContainer(
        tappable: false,
        transitionDuration: const Duration(milliseconds: 500),
        closedElevation: 5,
        openElevation: 0,
        closedColor: Theme.of(context).cardColor,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide.none,
        ),
        openShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          side: BorderSide.none,
        ),
        openBuilder: (_, __) => const SongScreen(),
        closedBuilder: (context, openContainer) => GestureDetector(
          onTap: () {
            songItemTaped(
              openContainer: openContainer,
              playlist: UserData().audiosMetadata,
              audioMetadata: audioMetadata,
              index: UserData().audiosMetadata.indexOf(audioMetadata),
            );
          },
          child: Container(
            height: double.infinity,
            width: size.width / 3.5,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                  image: getArtwork(artworkData: audioMetadata.artwork).image,
                  fit: BoxFit.cover),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFff9500),
                          Color(0xFFffc300),
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Text(
                    trackName,
                    style: Fonts.bold_14_ff000000,
                    overflow: TextOverflow.ellipsis,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
