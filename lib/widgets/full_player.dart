import 'dart:typed_data';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import '../assets/icos.dart';
import '../controllers/audio_manager.dart';
import '../util/util_artwork.dart';
import 'button/btn_audio_control.dart';

class FullPlayer extends StatelessWidget {
  const FullPlayer({Key? key, required this.closeButtonOnTap})
      : super(key: key);

  final VoidCallback closeButtonOnTap;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
          Container(
            color: Colors.black.withOpacity(0.7),
            child: GlassContainer(
              width: size.width,
              height: size.height,
              blur: 30,
              border: const Border.fromBorderSide(BorderSide.none),
              opacity: 0.05,
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: SizedBox(
                height: size.height,
                width: size.width,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    leading: GestureDetector(
                        onTap: closeButtonOnTap,
                        child: const Icon(
                          Icos.down_arrow_2,
                          color: Colors.white,
                        )),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                    actions: const [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icos.dots,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ValueListenableBuilder<String>(
                            valueListenable:
                                AudioManager().currentSongTitleNotifier,
                            builder: (_, value, __) {
                              return Text(
                                value,
                                style: GoogleFonts.ubuntuMono(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ),
                        ValueListenableBuilder<String>(
                          valueListenable:
                              AudioManager().currentSongArtistNotifier,
                          builder: (_, value, __) {
                            return Text(
                              value,
                              style: GoogleFonts.ubuntuMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 3,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: ValueListenableBuilder<Uint8List?>(
                                valueListenable:
                                    AudioManager().currentSongArtworkNotifier,
                                builder: (_, value, __) {
                                  return getArtwork(
                                    artworkData: value,
                                    height: size.width - 80,
                                    width: size.width - 80,
                                  );
                                },
                              )),
                        ),
                        Flexible(
                          flex: 1,
                          child: Row(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icos.share_2,
                                size: 25,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              Icon(
                                Icos.timer,
                                size: 25,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              Icon(
                                Icos.cut_1,
                                size: 25,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              Icon(
                                Icos.heart_outlined,
                                size: 25,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: ValueListenableBuilder<ProgressBarStatus>(
                            valueListenable: AudioManager().progressNotifier,
                            builder: (_, value, __) {
                              return ProgressBar(
                                progress: value.current,
                                total: value.total,
                                buffered: value.buffered,
                                timeLabelLocation: TimeLabelLocation.below,
                                timeLabelTextStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.3)),
                                baseBarColor: Colors.white.withOpacity(0.3),
                                bufferedBarColor: Colors.white.withOpacity(0),
                                progressBarColor: Colors.white.withOpacity(1),
                                thumbColor: Colors.white,
                                barHeight: 3,
                                thumbRadius: 5,
                                thumbGlowRadius: 15,
                                thumbGlowColor: Colors.white.withOpacity(0.15),
                                timeLabelPadding: 5,
                                onSeek: AudioManager().seek,
                                onDragStart: (details) {
                                  AudioManager().isDraggingProgressBar = true;
                                  final oldState =
                                      AudioManager().progressNotifier.value;
                                  AudioManager().progressNotifier.value =
                                      ProgressBarStatus(
                                    current: details.timeStamp,
                                    buffered: oldState.buffered,
                                    total: oldState.total,
                                  );
                                },
                                onDragEnd: () => AudioManager()
                                    .isDraggingProgressBar = false,
                                onDragUpdate: (details) {
                                  final oldState =
                                      AudioManager().progressNotifier.value;
                                  AudioManager().progressNotifier.value =
                                      ProgressBarStatus(
                                    current: details.timeStamp,
                                    buffered: oldState.buffered,
                                    total: oldState.total,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Row(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icos.queue_list,
                                size: 25,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              const NextButton(),
                              const PlayPauseButton(),
                              const PreviousButton(),
                              const LoopButton(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]);
      },
    );
  }
}
