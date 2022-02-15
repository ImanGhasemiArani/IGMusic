import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import '../assets/fnt_styles.dart';
import '../controllers/audio_manager.dart';
import '../util/util_artwork.dart';
import 'button/btn_audio_control.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key, required this.maxWidth}) : super(key: key);

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Uint8List?>(
      valueListenable: AudioManager().currentSongArtworkNotifier,
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
                  height: 2,
                  width: maxWidth * 0.1,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.7),
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
                child: GlassContainer(
                  width: maxWidth / 3 * 2,
                  height: 120,
                  blur: 25,
                  border: const Border.fromBorderSide(BorderSide.none),
                  opacity: 0.05,
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ValueListenableBuilder<String>(
                          valueListenable:
                              AudioManager().currentSongTitleNotifier,
                          builder: (_, value, __) {
                            return Text(
                              value,
                              textAlign: TextAlign.center,
                              style: FntStyles.songMiniItemWidgetTrackNameStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        ),
                        ValueListenableBuilder<String>(
                          valueListenable:
                              AudioManager().currentSongArtistNotifier,
                          builder: (_, value, __) {
                            return Text(
                              value,
                              textAlign: TextAlign.center,
                              style:
                                  FntStyles.songMiniItemWidgetArtistNameStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            PreviousButton(),
                            PlayPauseButton(),
                            NextButton(),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          )
        ]);
      },
    );
  }
}
