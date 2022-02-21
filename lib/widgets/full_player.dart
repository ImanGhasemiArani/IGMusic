import 'dart:typed_data';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import '../assets/fnt_styles.dart';
import '../assets/icos.dart';
import '../controllers/value_notifier.dart';
import '../models/audio_manager.dart';
import '../models/progress_bar_status.dart';
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
    var size = MediaQuery.of(context).size;
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
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
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
                            valueListenable: currentSongTitleNotifier,
                            builder: (_, value, __) {
                              return Text(
                                value,
                                style:
                                    FntStyles.songFullItemWidgetTrackNameStyle,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ),
                        ValueListenableBuilder<String>(
                          valueListenable: currentSongArtistNotifier,
                          builder: (_, value, __) {
                            return Text(
                              value,
                              style:
                                  FntStyles.songFullItemWidgetArtistNameStyle,
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
                                valueListenable: currentSongArtworkNotifier,
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
                        ),
                        Flexible(
                          flex: 1,
                          child: ValueListenableBuilder<ProgressBarStatus>(
                            valueListenable: progressNotifier,
                            builder: (_, value, __) {
                              return ProgressBar(
                                progress: value.current,
                                total: value.total,
                                buffered: value.buffered,
                                timeLabelLocation: TimeLabelLocation.below,
                                timeLabelTextStyle:
                                    FntStyles.progressTimeLabelStyle,
                                baseBarColor: Colors.white.withOpacity(0.3),
                                bufferedBarColor: Colors.white.withOpacity(0),
                                progressBarColor: Colors.white.withOpacity(1),
                                thumbColor: Colors.white,
                                barHeight: 2,
                                thumbRadius: 4,
                                thumbGlowRadius: 15,
                                thumbGlowColor: Colors.white.withOpacity(0.15),
                                timeLabelPadding: 5,
                                onSeek: AudioManager().seek,
                                onDragStart: (details) {
                                  isDraggingProgressBar = true;
                                  final oldState = progressNotifier.value;
                                  progressNotifier.value = ProgressBarStatus(
                                    current: details.timeStamp,
                                    buffered: oldState.buffered,
                                    total: oldState.total,
                                  );
                                },
                                onDragEnd: () => isDraggingProgressBar = false,
                                onDragUpdate: (details) {
                                  final oldState = progressNotifier.value;
                                  progressNotifier.value = ProgressBarStatus(
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
                              const BtnSkipNext(),
                              const BtnPlayPause(),
                              const BtnSkipPrevious(),
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
