import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../assets/fonts.dart';
import '../../assets/imgs.dart';
import '../../controllers/btn_controllers.dart';
import '../../models/song_metadata.dart';
import '../../models/user_data.dart';
import '../../screens/offline/song_screen.dart';
import '../../util/audio_info.dart';
import '../../util/util_artwork.dart';
import '../button/btn_song_item.dart';

// ignore: must_be_immutable
class CardItemSong extends StatelessWidget {
  CardItemSong({Key? key, required this.index, required this.audioMetadata})
      : super(key: key) {
    var list = exportData(
        audioMetadata.title, audioMetadata.artist, audioMetadata.album);
    trackName = list[0];
    artistName = list[1];
    albumName = list[2];
  }

  final int index;
  final SongMetadata audioMetadata;
  late String trackName;
  late String artistName;
  late String albumName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double cardHeight = size.height / 5;
    double songInfoHeight = cardHeight / 2;
    double songInfoWidth = (size.width - 40 - 30) * 0.4;
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        height: cardHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withAlpha(100),
              blurRadius: 10,
            )
          ],
        ),
        child: OpenContainer(
          tappable: false,
          transitionDuration: const Duration(milliseconds: 500),
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
          closedBuilder: (context, openContainer) => BtnSongItem(
            onTap: () {
              songItemTaped(
                openContainer: openContainer,
                playlist: UserData().audiosMetadata,
                audioMetadata: audioMetadata,
                index: index,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: songInfoWidth,
                      height: songInfoHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            trackName,
                            style: Fonts.w900_16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            artistName,
                            style: Fonts.w400_11,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            albumName,
                            style: Fonts.w400_9,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: const DecorationImage(
                                image: AssetImage(Imgs.imgDefaultMusicCover),
                              )),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: getArtwork(
                                artworkData: audioMetadata.artwork,
                                height: double.infinity,
                                width: double.infinity,
                              ))),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
