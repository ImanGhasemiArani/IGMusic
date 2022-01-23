import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'my_graphics/MyColors.dart';
import 'my_graphics/MyIcons.dart';

class FirstLayer extends StatelessWidget {
  const FirstLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          textDirection: TextDirection.ltr,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection: TextDirection.rtl,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(MyIcons.time,
                      size: 30, color: MyColors.tripleOptionsIcons),
                ),
                Text(
                  "Recently",
                  style: GoogleFonts.ubuntuMono(
                      color: MyColors.tripleOptionsTexts, fontSize: 16),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection: TextDirection.rtl,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(MyIcons.heart_1,
                      size: 30, color: MyColors.tripleOptionsIcons),
                ),
                Text(
                  "Favorites",
                  style: GoogleFonts.ubuntuMono(
                      color: MyColors.tripleOptionsTexts, fontSize: 16),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection: TextDirection.rtl,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(MyIcons.playlist,
                      size: 30, color: MyColors.tripleOptionsIcons),
                ),
                Text(
                  "Playlist",
                  style: GoogleFonts.ubuntuMono(
                      color: MyColors.tripleOptionsTexts, fontSize: 16),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        height: double.infinity,
        width: double.infinity,
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.40),
            Colors.white.withOpacity(0.10)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.60),
            Colors.white.withOpacity(0.10),
            Colors.lightBlueAccent.withOpacity(0.05),
            Colors.lightBlueAccent.withOpacity(0.6)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.39, 0.40, 1.0],
        ),
        blur: 15,
        borderWidth: 0,
        elevation: 3.0,
        shadowColor: Colors.black.withOpacity(0.20),
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}
