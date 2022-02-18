import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../assets/clrs.dart';
import '../../assets/fnt_styles.dart';
import '../../assets/imgs.dart';
import '../../controllers/btn_controllers.dart';
import '../../models/models.dart';
import '../button/btn_song_item.dart';

// ignore: must_be_immutable
class CardItemSong extends StatelessWidget {
  CardItemSong({Key? key, required this.index, required this.audioMetadata})
      : super(key: key) {
    setupInfo();
  }

  final int index;
  final SongMetadata audioMetadata;
  late String trackName;
  late String artistName;
  late String albumName;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Card(
      elevation: 5,
      shadowColor: Clrs.songItemWidgetShadowColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: BtnSongItem(
        onTap: () {
          songItemTaped(audioMetadata, index);
        },
        child: Container(
          height: size.height / 5,
          decoration: BoxDecoration(
              color: Clrs.songItemWidgetMainColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Clrs.songItemWidgetShadowColor.withAlpha(100),
                    blurRadius: 10)
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 0, bottom: size.height / 15, right: 5),
                  child: Container(
                    width: (size.width - 40 - 30) * 0.35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          trackName,
                          style: FntStyles.songItemWidgetTrackNameStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          artistName,
                          style: FntStyles.songItemWidgetArtistNameStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          albumName,
                          style: FntStyles.songItemWidgetAlbumNameStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: AssetImage(Imgs.img_default_music_cover),
                            )),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: getArtwork(size))),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getArtwork(Size size) {
    double width = double.infinity;
    double height = double.infinity;
    Uint8List? tmp = audioMetadata.artwork;
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

  void setupInfo() {
    trackName = audioMetadata.title;
    var re = RegExp(r'[^a-zA-Z0-9]');
    artistName = audioMetadata.artist;
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
        : (trackNames.isEmpty || trackNames[0].isEmpty)
            ? "Unknown"
            : trackNames[0];
    artistName = artists.length >= 2
        ? artists.sublist(0, 2).join(" ")
        : artists.length == 1
            ? artists[0]
            : "Unknown";
    albumName = audioMetadata.album;
  }
}

//import 'dart:typed_data';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'controllers/audio_manager.dart';
// import 'glass_container.dart';
// import 'models/models.dart';
// import 'draggable_song_screen.dart';
// import 'my_graphics/MyAssets.dart';
// import 'my_graphics/my_colors.dart';
// import 'my_graphics/MyIcons.dart';
// import 'visualizer_music.dart';
//
// class MusicItemWidget extends StatefulWidget {
//   const MusicItemWidget({Key? key, required this.index, required this.audioMetadata})
//       : super(key: key);
//   final int index;
//   final SongMetadata audioMetadata;
//
//   @override
//   _MusicItemWidgetState createState() => _MusicItemWidgetState();
// }
//
// class _MusicItemWidgetState extends State<MusicItemWidget>
//     with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   String trackName = "";
//   String artistName = "";
//   String albumName = "";
//
//   @override
//   initState() {
//     super.initState();
//     _controller = AnimationController(
//         vsync: this,
//         duration: const Duration(milliseconds: 800),
//         reverseDuration: const Duration(milliseconds: 500));
//     setupInfo();
//   }
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Container(
//       margin: EdgeInsets.fromLTRB((widget.index % 3 == 0 ? 20 : (widget.index % 3 == 1 ? 10 : 0)),
//           5, (widget.index % 3 == 2 ? 20 : (widget.index % 3 == 1 ? 10 : 0)), 5),
//       color: Colors.transparent,
//       child: Center(
//         child: Stack(children: [
//           Container(
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 image: DecorationImage(image: (getArtWork() as Image).image, fit: BoxFit.cover)),
//           ),
//           InkWell(
//               onLongPress: () {
//                 if (kDebugMode) {
//                   print("dots button pressed");
//                 }
//               },
//               autofocus: false,
//               enableFeedback: false,
//               borderRadius: BorderRadius.circular(15),
//               onTap: () {
//                 var temp = AudioManager().audioStatusNotifier.value == AudioStatus.playing &&
//                     AudioManager().currentSongIDNotifier.value == widget.audioMetadata.id;
//                 if (temp) {
//                   AudioManager().pauseAudio();
//                 } else {
//                   if (AudioManager().audioStatusNotifier.value == AudioStatus.playing) {
//                     AudioManager().pauseAudio();
//                     AudioManager().setPlayList(index: widget.index);
//                     AudioManager().playAudio();
//                   } else if (AudioManager().currentSongIDNotifier.value ==
//                       widget.audioMetadata.id) {
//                     AudioManager().playAudio();
//                   } else {
//                     AudioManager().setPlayList(index: widget.index);
//                     AudioManager().playAudio();
//                   }
//                   showModalBottomSheet(
//                       transitionAnimationController: _controller,
//                       context: context,
//                       backgroundColor: Colors.transparent,
//                       isScrollControlled: true,
//                       builder: (builder) {
//                         return const MusicItemPage();
//                       });
//                 }
//               },
//               child: ValueListenableBuilder<int>(
//                 valueListenable: AudioManager().currentSongIDNotifier,
//                 builder: (_, value, __) {
//                   var isThisSong = value == widget.audioMetadata.id;
//                   if (isThisSong) {
//                     return MyGlassContainer(
//                       blur: 0,
//                       child: Stack(
//                         children: [
//                           ValueListenableBuilder<AudioStatus>(
//                             valueListenable: AudioManager().audioStatusNotifier,
//                             builder: (_, value, __) {
//                               if (value == AudioStatus.playing) {
//                                 return Align(
//                                     alignment: Alignment.bottomCenter,
//                                     child: VisualizerMusic(
//                                       maxHeight: 60,
//                                       maxWidth: (MediaQuery.of(context).size.width - 60) / 3,
//                                       widthItem: 5,
//                                     ));
//                               } else {
//                                 return const SizedBox(
//                                   height: double.infinity,
//                                   width: double.infinity,
//                                 );
//                               }
//                             },
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 10, right: 5),
//                             child: Align(
//                               alignment: Alignment.topRight,
//                               child: InkWell(
//                                 onTap: () {
//                                   if (kDebugMode) {
//                                     print("dots button pressed");
//                                   }
//                                 },
//                                 enableFeedback: false,
//                                 autofocus: false,
//                                 child: const Icon(
//                                   MyIcons.dots,
//                                   size: 18,
//                                   color: MyColors.musicListTopIconText,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   } else {
//                     return MyGlassContainer(
//                       child: Stack(
//                         children: [
//                           Align(
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                 textDirection: TextDirection.ltr,
//                                 children: [
//                                   Text(
//                                     widget.audioMetadata.title,
//                                     style: GoogleFonts.ubuntuMono(
//                                         fontSize: 16,
//                                         color: MyColors.tripleOptionsIcons,
//                                         fontWeight: FontWeight.bold),
//                                     maxLines: 1,
//                                     overflow: TextOverflow.clip,
//                                   ),
//                                   Text(
//                                     artistName,
//                                     style: GoogleFonts.ubuntuMono(
//                                         fontSize: 15,
//                                         color: MyColors.tripleOptionsIcons,
//                                         fontWeight: FontWeight.normal),
//                                     maxLines: 1,
//                                     overflow: TextOverflow.clip,
//                                   ),
//                                   Text(
//                                     albumName,
//                                     style: GoogleFonts.ubuntuMono(
//                                         fontSize: 12,
//                                         color: MyColors.tripleOptionsIcons,
//                                         fontWeight: FontWeight.normal),
//                                     maxLines: 1,
//                                     overflow: TextOverflow.clip,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             alignment: Alignment.centerLeft,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 10, right: 5),
//                             child: Align(
//                               alignment: Alignment.topRight,
//                               child: InkWell(
//                                 onTap: () {
//                                   if (kDebugMode) {
//                                     print("dots button pressed");
//                                   }
//                                 },
//                                 enableFeedback: false,
//                                 autofocus: false,
//                                 child: const Icon(
//                                   MyIcons.dots,
//                                   size: 18,
//                                   color: MyColors.musicListTopIconText,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//                 },
//               )),
//         ]),
//       ),
//     );
//   }
//
//   Widget getArtWork() {
//     Uint8List? tmp = widget.audioMetadata.artwork;
//     return tmp == null || tmp.isEmpty
//         ? Image.asset(
//             MyAssets.defaultMusicCover,
//             width: 50,
//             height: 50,
//             fit: BoxFit.cover,
//           )
//         : Image.memory(
//             tmp,
//             width: 50,
//             height: 50,
//             fit: BoxFit.cover,
//           );
//   }
//
//   void setupInfo() {
//     trackName = widget.audioMetadata.title;
//     var re = RegExp(r'[^a-zA-Z0-9]');
//     artistName = widget.audioMetadata.artist;
//     var trackNames = trackName.split(re).where((element) => element.isNotEmpty).toList();
//     var artistNames = artistName.split(re).where((element) => element.isNotEmpty).toList();
//     var artists = [...artistNames];
//     for (var i = 0; i < artistNames.length; i++) {
//       artistNames[i] = artistNames[i].toLowerCase();
//     }
//     trackNames.retainWhere((element) => !artistNames.contains(element.toLowerCase()));
//     trackName = trackNames.length >= 2 ? trackNames.sublist(0, 2).join(" ") : trackNames[0];
//     artistName = artists.length >= 2
//         ? artists.sublist(0, 2).join(" ")
//         : artists.length == 1
//             ? artists[0]
//             : "Unknown";
//     albumName = widget.audioMetadata.album;
//   }
// }
