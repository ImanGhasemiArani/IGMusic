import 'package:flutter/material.dart';

import '../../assets/fonts.dart';
import '../../controllers/btn_controllers.dart';
import '../../models/song_metadata.dart';
import '../../models/user_data.dart';
import '../../util/audio_info.dart';
import '../../util/util_artwork.dart';
import '../button/btn_song_item.dart';

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
    return BtnSongItem(
      onTap: () {
        songItemTaped(
            playlist: UserData().audiosMetadata,
            audioMetadata: audioMetadata,
            index: UserData().audiosMetadata.indexOf(audioMetadata));
      },
      child: Card(
        elevation: 5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
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
    );
  }
}
