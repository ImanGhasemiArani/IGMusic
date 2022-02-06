import 'dart:typed_data';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../assets/icos.dart';
import '../assets/imgs.dart';
import '../controllers/audio_manager.dart';
import '../models/models.dart';
import '../widgets/button/btn_audio_control.dart';

class MusicItemPage extends StatefulWidget {
  const MusicItemPage({Key? key}) : super(key: key);

  @override
  _MusicItemPageState createState() => _MusicItemPageState();
}

class _MusicItemPageState extends State<MusicItemPage> {
  late SongMetadata audioMetadata;

  @override
  void initState() {
    super.initState();
    ValueListenableBuilder<SongMetadata>(
      valueListenable: AudioManager().currentSongMetaDataNotifier,
      builder: (_, value, __) {
        updateMetaData(value);
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Center(
        child: Stack(
          children: [
            ValueListenableBuilder<Uint8List?>(
              valueListenable: AudioManager().currentSongArtworkNotifier,
              builder: (_, value, __) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      image: DecorationImage(image: getArtwork(value).image, fit: BoxFit.cover)),
                );
              },
            ),
            GlassContainer(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30), bottom: Radius.circular(0)),
                height: double.infinity,
                width: double.infinity,
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent.withOpacity(0.5),
                    Colors.transparent.withOpacity(0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderGradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.60),
                    Colors.white.withOpacity(0.10),
                    Colors.lightBlueAccent.withOpacity(0.05),
                    Colors.lightBlueAccent.withOpacity(0.6)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.39, 0.40, 1.0],
                ),
                blur: 10,
                borderWidth: 0,
                elevation: 3.0,
                shadowColor: Colors.black.withOpacity(0.20),
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      leading: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icos.down_arrow_2)),
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
                              valueListenable: AudioManager().currentSongTitleNotifier,
                              builder: (_, value, __) {
                                return Text(
                                  value,
                                  style: GoogleFonts.ubuntuMono(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                          ),
                          ValueListenableBuilder<String>(
                            valueListenable: AudioManager().currentSongArtistNotifier,
                            builder: (_, value, __) {
                              return Text(
                                value,
                                style: GoogleFonts.ubuntuMono(fontSize: 11, fontWeight: FontWeight.normal, color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 50),
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ValueListenableBuilder<Uint8List?>(
                                    valueListenable: AudioManager().currentSongArtworkNotifier,
                                    builder: (_, value, __) {
                                      return getArtwork(value);
                                    },
                                  )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 325,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
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
                                ValueListenableBuilder<ProgressBarStatus>(
                                  valueListenable: AudioManager().progressNotifier,
                                  builder: (_, value, __) {
                                    return ProgressBar(
                                      progress: value.current,
                                      total: value.total,
                                      buffered: value.buffered,
                                      timeLabelTextStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                                      baseBarColor: Colors.white.withOpacity(0.3),
                                      bufferedBarColor: Colors.white.withOpacity(0),
                                      progressBarColor: Colors.white.withOpacity(1),
                                      thumbColor: Colors.white,
                                      barHeight: 2,
                                      onSeek: AudioManager().seek,
                                      thumbRadius: 4,
                                      thumbGlowRadius: 15,
                                      thumbGlowColor: Colors.white.withOpacity(0.15),
                                      timeLabelPadding: 5,
                                    );
                                  },
                                ),
                                Center(
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
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void updateMetaData(SongMetadata data) {
    setState(() {
      audioMetadata = data;
    });
  }

  Image getArtwork(Uint8List? tmp) {
    return tmp == null || tmp.isEmpty
        ? Image.asset(
            Imgs.img_default_music_cover,
            width: 325,
            height: 325,
            fit: BoxFit.cover,
          )
        : Image.memory(
            tmp,
            width: 325,
            height: 325,
            fit: BoxFit.cover,
          );
  }
}
