import 'package:flutter/material.dart';

import '../../assets/icos.dart';
import '../../controllers/btn_controllers.dart';
import '../../models/song_metadata.dart';
import 'tap_effect.dart';

// ignore: must_be_immutable
class BtnFavorite extends StatelessWidget {
  BtnFavorite({Key? key, this.size = 20, required this.songMetadata})
      : isLiked = songMetadata.isLiked,
        super(key: key);

  bool isLiked;
  final SongMetadata songMetadata;
  final double size;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return TapEffect(
        onTap: () {
          setState(() {
            isLiked = !isLiked;
          });
          btnLikeTaped(songMetadata: songMetadata, isLiked: isLiked);
        },
        child: Icon(
          isLiked ? Icos.heart : Icos.heart_outlined,
          color: isLiked ? Colors.red : Colors.white.withOpacity(0.7),
          size: size,
        ),
      );
    });
  }
}
