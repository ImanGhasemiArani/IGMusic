import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../assets/icos.dart';
import '../assets/imgs.dart';
import '../controllers/btn_controllers.dart';
import '../controllers/value_notifier.dart';
import '../models/progress_bar_status.dart';
import '../models/song_metadata.dart';
import '../services/audio_manager.dart';
import '../util/audio_info.dart';
import '../util/util_artwork.dart';
import 'button/btn_loop_mode.dart';
import 'button/btn_favorite.dart';
import 'button/btn_play_pause.dart';
import 'button/btn_set_speed.dart';
import 'button/btn_set_timer.dart';
import 'button/btn_skip_next.dart';
import 'button/btn_skip_previous.dart';
import 'button/tap_effect.dart';
import 'card/card_effective_playlist_item.dart';
import 'list/current_playlist_horizontal_list.dart';

class FullPlayer extends StatelessWidget {
  const FullPlayer({Key? key, required this.closeButtonOnTap})
      : super(key: key);

  final VoidCallback closeButtonOnTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final artHeight = height * 0.5;
    final artWeight = width * 0.6;

    final threeDotSize = (width - artWeight) * 0.5 * 0.5;
    final threeDotRP = (width - artWeight) * 0.25 * 0.5;
    final threeDotTP = (width - artWeight) * 0.25;

    final progressWidth = width * 0.68;
    final progressTP = artHeight - progressWidth * 0.95;
    final durationSize = (width - artWeight) * 0.5 * 0.5;
    final durationTP = progressWidth * 0.5 * 1.5 - durationSize * 0.5;
    final durationLRP = (width - artWeight) * 0.5 * 0.25;

    final curvedTextRadius = width * 0.68 * 0.5;
    final textTitleTP = artHeight - curvedTextRadius * 2 * 0.88;
    final textArtistTP = artHeight - curvedTextRadius * 2 * 0.78;

    final controllerBtnsTP = artHeight + curvedTextRadius * 2 * 0.3;

    final queueItemSize = width * 0.2;
    final queueWidgetBP = queueItemSize * 0.15;

    final btnsSpaceSize =
        height - controllerBtnsTP - queueItemSize - queueWidgetBP;

    final btnsWidgetSize = Size(width * 0.4, width * 0.12);
    final extraBtnsWidgetSize = Size(width * 0.6, width * 0.6 * 0.25);
    final btnsSpaceHeight =
        (btnsSpaceSize - btnsWidgetSize.height - extraBtnsWidgetSize.height) /
            3;

    var _appearance = CircularSliderAppearance(
      size: progressWidth,
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
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Imgs.imgDefaultMusicCover),
              fit: BoxFit.cover,
            ),
          ),
          child: ValueListenableBuilder<Uint8List?>(
            valueListenable: currentSongArtworkNotifier,
            builder: (_, artworkData, __) => ClipRRect(
              child: getArtwork(artworkData: artworkData),
            ),
          ),
        ),
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
                var infoList =
                    exportData(metadata.title, metadata.artist, metadata.album);
                var title = infoList[0];
                var artist = infoList[1];
                var album = infoList[2];
                var artistAlbum = "$artist | $album";
                title =
                    title.length > 25 ? title.substring(0, 25) + "..." : title;
                artistAlbum = artistAlbum.length > 25
                    ? artistAlbum.substring(0, 25) + "..."
                    : artistAlbum;
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: textTitleTP,
                        ),
                        child: CircularText(
                          children: [
                            TextItem(
                              text: Text(
                                title,
                                style: GoogleFonts.supermercadoOne(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              startAngle: 90,
                              startAngleAlignment: StartAngleAlignment.center,
                              direction: CircularTextDirection.anticlockwise,
                              space: 4,
                            ),
                          ],
                          radius: curvedTextRadius,
                          position: CircularTextPosition.outside,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: textArtistTP,
                        ),
                        child: CircularText(
                          children: [
                            TextItem(
                              text: Text(
                                artistAlbum,
                                style: GoogleFonts.pompiere(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              startAngle: 90,
                              startAngleAlignment: StartAngleAlignment.center,
                              direction: CircularTextDirection.anticlockwise,
                              space: 3,
                            ),
                          ],
                          radius: curvedTextRadius,
                          position: CircularTextPosition.outside,
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(
              right: threeDotRP,
              top: threeDotTP,
            ),
            child: TapEffect(
              padding: const EdgeInsets.all(0),
              onTap: closeButtonOnTap,
              child: SizedBox(
                height: threeDotSize,
                width: threeDotSize,
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Icon(
                    Icos.dots,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ValueListenableBuilder<Uint8List?>(
              valueListenable: currentSongArtworkNotifier,
              builder: (_, artwork, __) {
                return Container(
                  height: artHeight,
                  width: artWeight,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(1000)),
                    image: DecorationImage(
                      image: getArtwork(artworkData: artwork).image,
                      fit: BoxFit.cover,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                );
              }),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: progressTP),
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
                      child: Container(
                        width: durationSize,
                        height: durationSize,
                        margin: EdgeInsets.only(
                          top: durationTP,
                          left: durationLRP,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            progressData.current.toString().substring(2, 7),
                            style: GoogleFonts.fuzzyBubbles(
                              color: const Color.fromRGBO(255, 255, 255, 0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: durationSize,
                        height: durationSize,
                        margin: EdgeInsets.only(
                          top: durationTP,
                          right: durationLRP,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            progressData.total.toString().substring(2, 7),
                            style: GoogleFonts.fuzzyBubbles(
                              color: const Color.fromRGBO(255, 255, 255, 0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: btnsSpaceSize,
            width: width,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: controllerBtnsTP),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _btnsWidget(btnsWidgetSize),
                  SizedBox(height: btnsSpaceHeight),
                  _extraBtnsWidget(extraBtnsWidgetSize),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: queueWidgetBP),
            child: const CurrentPlaylistFullPlayer(),
          ),
        )
      ],
    );
  }

  Widget _extraBtnsWidget(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(96, 125, 139, 0.3),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const LoopButton(),
          ValueListenableBuilder<SongMetadata>(
              valueListenable: currentSongMetaDataNotifier,
              builder: (_, metadata, __) {
                return BtnFavorite(
                  songMetadata: metadata,
                );
              }),
          const BtnSetTimer(),
          const BtnSetSpeed(),
        ],
      ),
    );
  }

  Widget _btnsWidget(Size size) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                BtnSkipPrevious(),
                BtnSkipNext(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: BtnPlayPause(size: size.height),
          ),
        ],
      ),
    );
  }
}

class CurrentPlaylistFullPlayer extends StatefulWidget {
  const CurrentPlaylistFullPlayer({Key? key}) : super(key: key);

  @override
  State<CurrentPlaylistFullPlayer> createState() =>
      _CurrentPlaylistFullPlayerState();
}

class _CurrentPlaylistFullPlayerState extends State<CurrentPlaylistFullPlayer> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SongMetadata>>(
      valueListenable: playlistNotifier,
      builder: (_, effectivePlaylist, __) {
        return HorizontalCardPager(
          initialPage:
              effectivePlaylist.indexOf(currentSongMetaDataNotifier.value),
          items: getPlaylistItems(effectivePlaylist),
          onPageChanged: (page) {
            if (page.toString().split(".")[1] == "0" && isOnChangeWork) {
              songItemTaped(
                  index: page.toInt(), playlist: playlistNotifier.value);
            }
          },
        );
      },
    );
  }

  List<CardItem> getPlaylistItems(List<SongMetadata> playlist) {
    return playlist
        .map((e) => CardEffectivePlaylistItem(
              songMetadata: e,
            ))
        .toList();
  }
}
