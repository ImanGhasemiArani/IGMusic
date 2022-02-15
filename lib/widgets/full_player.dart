import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import '../controllers/audio_manager.dart';
import '../util/util_artwork.dart';

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
          GlassContainer(
            width: size.width,
            height: size.height,
            blur: 20,
            border: const Border.fromBorderSide(BorderSide.none),
            opacity: 0.05,
            borderRadius: BorderRadius.circular(0),
          ),
          Center(
            child: FittedBox(
              fit: BoxFit.cover,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                //   WaveformBuilder(width: size.width - 40, height: 80),
                  GestureDetector(
                      onTap: closeButtonOnTap,
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 50,
                      ))
                ],
              ),
            ),
          ),
        ]);
      },
    );
  }
}
