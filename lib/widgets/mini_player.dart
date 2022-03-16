import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/value_notifier.dart';
import '../models/song_metadata.dart';
import '../util/audio_info.dart';
import '../util/util_artwork.dart';
import 'button/btn_play_pause.dart';
import 'button/btn_skip_next.dart';
import 'button/btn_skip_previous.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key, required this.maxWidth}) : super(key: key);

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Uint8List?>(
      valueListenable: currentSongArtworkNotifier,
      builder: (_, value, __) {
        return Stack(children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: getArtwork(artworkData: value).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                  height: 4,
                  width: maxWidth * 0.12,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(1),
                          blurRadius: 8,
                        ),
                      ])),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: GlassContainer(
                  width: maxWidth / 3 * 2,
                  //   height: 120,
                  blur: 50,
                  border: const Border.fromBorderSide(BorderSide.none),
                  opacity: 0.05,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ValueListenableBuilder<SongMetadata>(
                        valueListenable: currentSongMetaDataNotifier,
                        builder: (_, metadata, __) {
                          var infoList = exportData(
                              metadata.title, metadata.artist, metadata.album);
                          var title = infoList[0];
                          var artist = infoList[1];
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.rajdhani(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  artist,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.overlock(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    BtnSkipPrevious(),
                                    BtnPlayPause(),
                                    BtnSkipNext(),
                                  ],
                                ),
                              ]);
                        }),
                  ),
                ),
              ),
            ),
          )
        ]);
      },
    );
  }
}
