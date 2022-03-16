import 'package:flutter/material.dart';
import 'package:ig_music/util/util_artwork.dart';

import '../../assets/imgs.dart';
import '../../models/song_metadata.dart';
import '../list/current_playlist_horizontal_list.dart';

class CardEffectivePlaylistItem extends CardItem {
  CardEffectivePlaylistItem({
    Key? key,
    required this.songMetadata,
  });

  final SongMetadata songMetadata;
  @override
  Widget? buildWidget(double diffPosition) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(
            image: AssetImage(Imgs.imgDefaultMusicCover),
          )),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: getArtwork(artworkData: songMetadata.artwork),
      ),
    );
  }
}
