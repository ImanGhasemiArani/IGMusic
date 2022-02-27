import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../assets/icos.dart';
import '../controllers/value_notifier.dart';
import '../util/util_artwork.dart';
import 'visualizer/circular_visualizer.dart';

class ButtonNavBarContentMenu extends StatelessWidget {
  const ButtonNavBarContentMenu({Key? key, required this.avatarOnTap})
      : super(key: key);

  final VoidCallback avatarOnTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Icon(
          Icos.offlineTab,
          size: 30,
        ),
        GestureDetector(
          onTap: avatarOnTap,
          child: CircularVisualizer(
            onPressed: () {},
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: ValueListenableBuilder<Uint8List?>(
                  valueListenable: currentSongArtworkNotifier,
                  builder: (_, value, __) {
                    return getArtwork(artworkData: value);
                  },
                )),
          ),
        ),
        const Icon(
          Icos.onlineTab,
          size: 30,
        ),
      ],
    );
  }
}
