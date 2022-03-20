import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/btn_controllers.dart';
import '../button/btn_song_item.dart';

class CardFavoritesPlaylist extends StatelessWidget {
  const CardFavoritesPlaylist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BtnSongItem(
      onTap: () {
        btnFavoritesPlaylistTaped();
      },
      child: Card(
        elevation: 5,
        shape: const CircleBorder(),
        child: Align(
          alignment: Alignment.center,
          child: Container(
              width: size.width / 4,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
              alignment: Alignment.center,
              child: Text(
                "Favorites",
                style: GoogleFonts.rajdhani(
                    color: Theme.of(context).colorScheme.onTertiary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
                overflow: TextOverflow.ellipsis,
              )),
        ),
      ),
    );
  }
}
