import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'audio_manager.dart';
import 'btn_audio_control.dart';
import 'music_item_page.dart';
import 'my_graphics/MyAssets.dart';

class MusicBottomSheet extends StatefulWidget {
  const MusicBottomSheet({Key? key}) : super(key: key);

  @override
  _MusicBottomSheetState createState() => _MusicBottomSheetState();
}

class _MusicBottomSheetState extends State<MusicBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
        reverseDuration: const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            transitionAnimationController: _controller,
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (builder) {
              return const MusicItemPage();
            });
      },
      child: Container(
        height: 60,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: GlassContainer(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          height: 60,
          width: MediaQuery.of(context).size.width,
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.40),
              Colors.white.withOpacity(0.10)
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
          blur: 15,
          borderWidth: 0,
          elevation: 3.0,
          shadowColor: Colors.black.withOpacity(0.20),
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: ValueListenableBuilder<Uint8List?>(
                          valueListenable:
                              AudioManager().currentSongArtworkNotifier,
                          builder: (_, value, __) {
                            return getArtwork(value);
                          },
                        )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                        fontWeight: FontWeight.bold),
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
                                      fontWeight: FontWeight.normal),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: PlayPauseButtonWithProgressBar(),
                    ),
                    NextButton(
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Image getArtwork(Uint8List? tmp) {
    return tmp == null || tmp.isEmpty
        ? Image.asset(
            MyAssets.defaultMusicCover,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          )
        : Image.memory(
            tmp,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          );
  }
}
