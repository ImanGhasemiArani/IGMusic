import 'package:flutter/material.dart';
import 'package:ig_music/util/util_artwork.dart';

import '../../assets/fnt_styles.dart';
import '../../models/models.dart';

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: double.infinity,
          width: size.width / 3.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                image: getArtwork(artworkData: audioMetadata.artwork).image,
                fit: BoxFit.cover),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                child: Text(
                  trackName,
                  style: FntStyles.songRecentlyItemWidgetTrackNameStyle,
                  overflow: TextOverflow.ellipsis,
                )),
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
