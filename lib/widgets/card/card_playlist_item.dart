import 'package:flutter/material.dart';
import 'package:ig_music/util/util_artwork.dart';

import '../../assets/fnt_styles.dart';
import '../../models/playlist.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Container(
        height: double.infinity,
        width: size.width / 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          image: DecorationImage(
              image: getArtwork(artworkData: null).image, fit: BoxFit.cover),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: Text(
                playlist.name,
                style: FntStyles.songRecentlyItemWidgetTrackNameStyle,
                overflow: TextOverflow.ellipsis,
              )),
        ),
      ),
    );
  }
}
