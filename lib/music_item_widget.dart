import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'audio_manager.dart';
import 'file_manager.dart';
import 'glass_container.dart';
import 'music_item_page.dart';
import 'my_graphics/MyAssets.dart';
import 'my_graphics/MyColors.dart';
import 'my_graphics/MyIcons.dart';
import 'visualizer_music.dart';

class MusicItemWidget extends StatefulWidget {
  const MusicItemWidget(
      {Key? key, required this.index, required this.audioMetadata})
      : super(key: key);
  final int index;
  final AudioMetadata audioMetadata;

  @override
  _MusicItemWidgetState createState() => _MusicItemWidgetState();
}

class _MusicItemWidgetState extends State<MusicItemWidget>
    with AutomaticKeepAliveClientMixin {
  String trackName = "";
  String artistName = "";
  String albumName = "";

  @override
  initState() {
    super.initState();
    setupInfo();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: EdgeInsets.fromLTRB(
          (widget.index.isEven ? 20 : 5), 5, (widget.index.isOdd ? 20 : 5), 5),
      color: Colors.transparent,
      child: Center(
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: (getArtWork() as Image).image, fit: BoxFit.cover)),
          ),
          InkWell(
              onTap: () {
                var temp = AudioManager().audioStatusNotifier.value ==
                        AudioStatus.playing &&
                    AudioManager().currentSongIDNotifier.value ==
                        widget.audioMetadata.id;
                if (temp) {
                  AudioManager().pauseAudio();
                } else {
                  if (AudioManager().audioStatusNotifier.value ==
                      AudioStatus.playing) {
                    AudioManager().pauseAudio();
                  }
                  AudioManager().setPlayList(index: widget.index);
                  // AudioManager().seekToAudio(UserData().audiosMetadata.indexOf(widget.audioMetadata));
                  AudioManager().playAudio();
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (builder) {
                        return const MusicItemPage();
                      });
                }
              },
              child: ValueListenableBuilder<int>(
                valueListenable: AudioManager().currentSongIDNotifier,
                builder: (_, value, __) {
                  var isThisSong = value == widget.audioMetadata.id;
                  if (isThisSong) {
                    return MyGlassContainer(
                      blur: 0,
                      child: Stack(
                        children: [
                          ValueListenableBuilder<AudioStatus>(
                            valueListenable: AudioManager().audioStatusNotifier,
                            builder: (_, value, __) {
                              if (value == AudioStatus.playing) {
                                return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: VisualizerMusic(
                                      maxHeight: 100,
                                      maxWidth:
                                          (MediaQuery.of(context).size.width -
                                                  50) /
                                              2,
                                      widthItem: 10,
                                    ));
                              } else {
                                return const SizedBox(
                                  height: double.infinity,
                                  width: double.infinity,
                                );
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, right: 10),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {},
                                autofocus: false,
                                child: const Icon(
                                  MyIcons.dots,
                                  size: 18,
                                  color: MyColors.musicListTopIconText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return MyGlassContainer(
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(15, 50, 15, 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              textDirection: TextDirection.ltr,
                              children: [
                                Text(
                                  widget.audioMetadata.title,
                                  style: GoogleFonts.ubuntuMono(
                                      fontSize: 20,
                                      color: MyColors.tripleOptionsIcons,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                                Text(
                                  artistName,
                                  style: GoogleFonts.ubuntuMono(
                                      fontSize: 19,
                                      color: MyColors.tripleOptionsIcons,
                                      fontWeight: FontWeight.normal),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                                Text(
                                  albumName,
                                  style: GoogleFonts.ubuntuMono(
                                      fontSize: 16,
                                      color: MyColors.tripleOptionsIcons,
                                      fontWeight: FontWeight.normal),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, right: 10),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {},
                                autofocus: false,
                                child: const Icon(
                                  MyIcons.dots,
                                  size: 18,
                                  color: MyColors.musicListTopIconText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              )),
        ]),
      ),
    );
  }

  Widget getArtWork() {
    Uint8List? tmp = widget.audioMetadata.artwork;
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

  void setupInfo() {
    trackName = widget.audioMetadata.title;
    var re = RegExp(r'[^a-zA-Z0-9]');
    artistName = widget.audioMetadata.artist;
    var trackNames =
        trackName.split(re).where((element) => element.isNotEmpty).toList();
    var artistNames =
        artistName.split(re).where((element) => element.isNotEmpty).toList();
    var artists = [...artistNames];
    for (var i = 0; i < artistNames.length; i++) {
      artistNames[i] = artistNames[i].toLowerCase();
    }
    trackNames
        .retainWhere((element) => !artistNames.contains(element.toLowerCase()));
    trackName = trackNames.length >= 2
        ? trackNames.sublist(0, 2).join(" ")
        : trackNames[0];
    artistName = artists.length >= 2
        ? artists.sublist(0, 2).join(" ")
        : artists.length == 1
            ? artists[0]
            : "Unknown";
    albumName = widget.audioMetadata.album;
  }
}
