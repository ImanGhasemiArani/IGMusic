import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../assets/fnt_styles.dart';
import '../assets/icos.dart';
import '../controllers/value_notifier.dart';
import '../models/audio_manager.dart';
import '../models/progress_bar_status.dart';
import '../models/song_metadata.dart';
import '../util/util_artwork.dart';
import 'button/btn_audio_control.dart';
import 'button/btn_favourite.dart';
import 'button/btn_play_pause.dart';
import 'button/btn_skip_next.dart';
import 'button/btn_skip_previous.dart';

class FullPlayer extends StatelessWidget {
  const FullPlayer({Key? key, required this.closeButtonOnTap})
      : super(key: key);

  final VoidCallback closeButtonOnTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var _appearance = CircularSliderAppearance(
      size: size.width * 0.6 + 40,
      startAngle: 150,
      counterClockwise: true,
      angleRange: 120,
      animationEnabled: true,
      customWidths: CustomSliderWidths(
        handlerSize: 4,
        shadowWidth: 3 * 1.4,
        progressBarWidth: 3,
        trackWidth: 2,
      ),
      spinnerMode: false,
    );
    return Scaffold(
      body: Stack(
        children: [
          ValueListenableBuilder<Uint8List?>(
              valueListenable: currentSongArtworkNotifier,
              builder: (_, artworkData, __) => Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: getArtwork(artworkData: artworkData).image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
          Container(
            color: const Color.fromRGBO(0, 0, 0, 0.7),
            child: const GlassContainer(
              blur: 30,
              border: Border.fromBorderSide(BorderSide.none),
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ValueListenableBuilder<SongMetadata>(
                valueListenable: currentSongMetaDataNotifier,
                builder: (_, metadata, __) {
                  return Container(
                    height: size.height * 0.5,
                    width: size.width * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(1000)),
                      image: DecorationImage(
                        image: getArtwork(artworkData: metadata.artwork).image,
                        fit: BoxFit.cover,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding:
                              EdgeInsets.fromLTRB(0, 0, 0, size.height * 0.1),
                          child: GlassContainer(
                            width: size.width * 0.5,
                            blur: 8,
                            opacity: 0.08,
                            border:
                                const Border.fromBorderSide(BorderSide.none),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    metadata.title,
                                    style: FntStyles
                                        .songFullItemWidgetTrackNameStyle,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    metadata.artist,
                                    style: FntStyles
                                        .songFullItemWidgetArtistNameStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: size.height * 0.5 - size.width * 0.6 - 20),
            child: ValueListenableBuilder<ProgressBarStatus>(
              valueListenable: progressNotifier,
              builder: (_, progressData, __) {
                var totalSec = progressData.total.inSeconds.toDouble();
                var currentSec = progressData.current.inSeconds
                    .clamp(0, totalSec)
                    .toDouble();
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: SleekCircularSlider(
                        appearance: _appearance,
                        innerWidget: (a) => const SizedBox(),
                        min: 0,
                        max: totalSec,
                        initialValue: currentSec,
                        onChangeEnd: (details) {
                          AudioManager()
                              .seek(Duration(seconds: details.toInt()));
                          isUpdateProgressNotifier = true;
                        },
                        onChangeStart: (details) {
                          isUpdateProgressNotifier = false;
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: size.width * 0.6 - 20,
                          left: size.width * 0.1,
                        ),
                        child: Text(
                          progressData.current.toString().substring(2, 7),
                          style: FntStyles.progressTimeLabelStyle,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: size.width * 0.6 - 20,
                          right: size.width * 0.1,
                        ),
                        child: Text(
                          progressData.total.toString().substring(2, 7),
                          style: FntStyles.progressTimeLabelStyle,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.6),
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const LoopButton(),
                        GlassContainer(
                          border: const Border.fromBorderSide(BorderSide.none),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: const [
                                BtnSkipPrevious(),
                                BtnPlayPause(),
                                BtnSkipNext(),
                              ],
                            ),
                          ),
                        ),
                        Icon(
                          Icos.queue_list,
                          size: 25,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BtnFavourite(),
                        Icon(
                          Icos.cut_1,
                          size: 25,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        Icon(
                          Icos.timer,
                          size: 25,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        Icon(
                          Icos.share_2,
                          size: 25,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
