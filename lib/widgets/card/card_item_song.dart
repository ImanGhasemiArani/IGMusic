import 'package:flutter/material.dart';

import '../../assets/fonts.dart';
import '../../assets/imgs.dart';
import '../../controllers/btn_controllers.dart';
import '../../models/song_metadata.dart';
import '../../models/user_data.dart';
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
    var size = MediaQuery.of(context).size;
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        height: size.height / 5,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).shadowColor.withAlpha(100),
                  blurRadius: 10)
            ]),
        child: BtnSongItem(
          onTap: () {
            songItemTaped(
                playlist: UserData().audiosMetadata,
                audioMetadata: audioMetadata,
                index: index);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 0, bottom: size.height / 15, right: 5),
                  child: SizedBox(
                    width: (size.width - 40 - 30) * 0.35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          trackName,
                          style: Fonts.rajdhani_16_w900,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          artistName,
                          style: Fonts.overlock_14_w700,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          albumName,
                          style: Fonts.itim_12,
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
    );
  }
}
