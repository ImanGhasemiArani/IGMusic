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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
              width: size.width / 4,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFfbf8cc),
                    Color(0xFFffcfd2),
                    Color(0xFFf1c0e8),
                    Color(0xFFcfbaf0),
                    Color(0xFFa3c4f3),
                    Color(0xFF8eecf5),
                    Color(0xFFb9fbc0),
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              alignment: Alignment.center,
              child: Text(
                "Favorites",
                style: GoogleFonts.rajdhani(
                    // color: const Color(0xFFBDBDBD),
                    color: const Color(0xff121212),
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
                overflow: TextOverflow.ellipsis,
              )),
        ),
      ),
    );
  }
}
