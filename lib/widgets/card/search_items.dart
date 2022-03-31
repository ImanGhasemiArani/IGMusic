import 'package:flutter/material.dart';

import '../../assets/fonts.dart';
import '../../assets/imgs.dart';
import '../../controllers/btn_controllers.dart';
import '../../models/song_metadata.dart';
import '../../models/user_data.dart';
import '../../util/audio_info.dart';
import '../../util/util_artwork.dart';

// ignore: must_be_immutable
class SearchSongItem extends StatelessWidget {
  SearchSongItem({Key? key, required this.audioMetadata}) : super(key: key) {
    var list = exportData(
        audioMetadata.title, audioMetadata.artist, audioMetadata.album);
    trackName = list[0];
    artistAlbumName = "${list[1]} | ${list[2]}";
  }

  final SongMetadata audioMetadata;
  late String trackName;
  late String artistAlbumName;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 4,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: () {
          songItemTaped(
              playlist: UserData().audiosMetadata,
              audioMetadata: audioMetadata,
              index: UserData().audiosMetadata.indexOf(audioMetadata));
        },
        enableFeedback: false,
        leading: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(
                  Imgs.imgDefaultMusicCover,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: getArtwork(artworkData: audioMetadata.artwork),
          ),
        ),
        title: Column(
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
              artistAlbumName,
              style: Fonts.overlock_14_w700,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
