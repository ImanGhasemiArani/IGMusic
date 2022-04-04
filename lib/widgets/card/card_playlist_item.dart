import 'package:flutter/material.dart';

import '../../assets/fonts.dart';
import '../../models/playlist.dart';
import '../../util/util_artwork.dart';

class CardPlaylistItem extends StatelessWidget {
  const CardPlaylistItem(
      {Key? key, required this.index, required this.playlist})
      : super(key: key);

  final int index;
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Card(
      elevation: 5,
      shape: const CircleBorder(),
      child: Container(
        height: double.infinity,
        width: size.width / 4,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: getArtwork(artworkData: null).image, fit: BoxFit.cover),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF005f73),
                      Color(0xFF0a9396),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
              child: Text(
                playlist.name,
                style: Fonts.bold_14_ff000000,
                overflow: TextOverflow.ellipsis,
              )),
        ),
      ),
    );
  }
}
