import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../assets/imgs.dart';
import '../../controllers/btn_controllers.dart';
import '../../models/song_metadata.dart';
import '../button/btn_song_item.dart';

// ignore: must_be_immutable
class CardItemSong extends StatelessWidget {
  CardItemSong({Key? key, required this.index, required this.audioMetadata})
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
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: BtnSongItem(
        onTap: () {
          songItemTaped(audioMetadata, index);
        },
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
                          style: GoogleFonts.rajdhani(
                              fontSize: 16, fontWeight: FontWeight.w900),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          artistName,
                          style: GoogleFonts.itim(fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          albumName,
                          style: GoogleFonts.itim(fontSize: 12),
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
                              image: AssetImage(Imgs.img_default_music_cover),
                            )),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: getArtwork(size))),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getArtwork(Size size) {
    double width = double.infinity;
    double height = double.infinity;
    Uint8List? tmp = audioMetadata.artwork;
    return tmp == null || tmp.isEmpty
        ? Image.asset(
            Imgs.img_default_music_cover,
            width: width,
            height: height,
            fit: BoxFit.cover,
          )
        : Image.memory(
            tmp,
            width: width,
            height: height,
            fit: BoxFit.cover,
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
