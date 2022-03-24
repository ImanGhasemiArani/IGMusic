import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import '../assets/fonts.dart';
import '../assets/imgs.dart';
import '../controllers/value_notifier.dart';
import '../models/song_metadata.dart';
import '../util/audio_info.dart';
import '../util/util_artwork.dart';
import 'button/btn_favorite.dart';
import 'button/btn_play_pause.dart';
import 'button/btn_skip_next.dart';
import 'button/btn_skip_previous.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key, required this.maxWidth}) : super(key: key);

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder<Uint8List?>(
          valueListenable: currentSongArtworkNotifier,
          builder: (_, artwork, __) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Imgs.imgDefaultMusicCover),
                  fit: BoxFit.cover,
                ),
              ),
              child: getArtwork(artworkData: artwork),
            );
          },
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 4,
            width: maxWidth * 0.12,
            margin: const EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(1),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: GlassContainer(
              blur: 10,
              opacity: 0.2,
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              child: ValueListenableBuilder<SongMetadata>(
                valueListenable: currentSongMetaDataNotifier,
                builder: (_, metadata, __) {
                  return BtnFavorite(
                    songMetadata: metadata,
                    size: 25,
                  );
                },
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: GlassContainer(
                width: maxWidth / 3 * 2,
                blur: 10,
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
                                style: Fonts.rajdhani_16_w900_ffffffff,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                artist,
                                textAlign: TextAlign.center,
                                style: Fonts.overlock_15_ffffffff,
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
        ),
      ],
    );
  }
}
