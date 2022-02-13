import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import '../assets/fnt_styles.dart';
import '../assets/imgs.dart';
import '../controllers/audio_manager.dart';
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
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: getArtwork(value).image,
                fit: BoxFit.cover,
              ),
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

  Image getArtwork(Uint8List? tmp) {
    var width = 50.0;
    var height = 50.0;
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
}
