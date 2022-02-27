import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/btn_controllers.dart';
import '../../models/song_metadata.dart';
import '../../models/user_data.dart';
import '../../util/util_artwork.dart';
import '../button/btn_song_item.dart';

// ignore: must_be_immutable
class CardRecentlyItemSong extends StatelessWidget {
  CardRecentlyItemSong(
      {Key? key, required this.index, required this.audioMetadata})
      : super(key: key) {
    setupInfo();
  }

  final int index;
  final SongMetadata audioMetadata;
  late String trackName;
  late String artistName;
  late String albumName;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        elevation: 5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: BtnSongItem(
          onTap: () {
            songItemTaped(audioMetadata,
                UserData().audiosMetadata.indexOf(audioMetadata));
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
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Text(
                    trackName,
                    style: GoogleFonts.rajdhani(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w900),
                    overflow: TextOverflow.ellipsis,
                  )),
            ),
          ),
        ),
      ),
    );
  }

  void setupInfo() {
    trackName = audioMetadata.title;
    var re = RegExp(r'[^a-zA-Z0-9]');
    artistName = audioMetadata.artist;
    var trackNames =
        trackName.split(re).where((element) => element.isNotEmpty).toList();
    var artistNames =
        artistName.split(re).where((element) => element.isNotEmpty).toList();
    var artists = [...artistNames];
    for (var i = 0; i < artistNames.length; i++) {
      artistNames[i] = artistNames[i].toLowerCase();
    }
    trackNames
        .retainWhere((element) => !artistNames.contains(element.toLowerCase()));
    trackName = trackNames.length >= 2
        ? trackNames.sublist(0, 2).join(" ")
        : (trackNames.isEmpty || trackNames[0].isEmpty)
            ? "Unknown"
            : trackNames[0];
    artistName = artists.length >= 2
        ? artists.sublist(0, 2).join(" ")
        : artists.length == 1
            ? artists[0]
            : "Unknown";
    albumName = audioMetadata.album;
  }
}
