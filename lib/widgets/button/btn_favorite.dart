import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/icos.dart';
import '../../controllers/btn_controllers.dart';
import '../../models/song_metadata.dart';
import 'tap_effect.dart';

class BtnFavorite extends StatelessWidget {
  const BtnFavorite({Key? key, this.size = 20, required this.songMetadata})
      : super(key: key);

  final SongMetadata songMetadata;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isLiked = songMetadata.isLiked.obs;
    return TapEffect(
      onTap: () {
        isLiked.value = !isLiked.value;
        btnLikeTaped(songMetadata: songMetadata, isLiked: isLiked.value);
      },
      child: Obx(
        () => Icon(
          isLiked.value ? Icos.heart : Icos.heart_outlined,
          color: isLiked.value ? Colors.red : Colors.white.withOpacity(0.7),
          size: size,
        ),
      ),
    );
  }
}
