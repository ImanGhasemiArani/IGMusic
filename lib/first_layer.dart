import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main_page.dart';
import 'my_graphics/my_colors.dart';
import 'my_graphics/MyIcons.dart';

class FirstLayer extends StatelessWidget {
  const FirstLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.fill,
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          textDirection: TextDirection.ltr,
          children: [
            GestureDetector(
              onTap: () {},
              child: GlassFirstLayer(
                index: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    const Icon(MyIcons.time,
                        size: 25, color: MyColors.tripleOptionsIcons),
                    AutoSizeText(
                      "Recently",
                      style: GoogleFonts.ubuntuMono(
                          color: MyColors.tripleOptionsTexts, fontSize: 14),
                      minFontSize: 12,
                      maxFontSize: 16,
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: GlassFirstLayer(
                index: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    const Icon(MyIcons.heart_1,
                        size: 25, color: MyColors.tripleOptionsIcons),
                    AutoSizeText(
                      "Favorites",
                      style: GoogleFonts.ubuntuMono(
                          color: MyColors.tripleOptionsTexts, fontSize: 14),
                      minFontSize: 12,
                      maxFontSize: 16,
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                MainPage.currentBodyNotifier.value = 1;
              },
              child: GlassFirstLayer(
                index: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    const Icon(MyIcons.playlist,
                        size: 25, color: MyColors.tripleOptionsIcons),
                    AutoSizeText(
                      "Playlist",
                      style: GoogleFonts.ubuntuMono(
                          color: MyColors.tripleOptionsTexts, fontSize: 14),
                      minFontSize: 12,
                      maxFontSize: 16,
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GlassFirstLayer extends StatelessWidget {
  const GlassFirstLayer({
    Key? key,
    required this.child,
    required this.index,
  }) : super(key: key);
  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GlassContainer.frostedGlass(
      child: child,
      borderRadius: BorderRadius.circular(50),
      height: MediaQuery.of(context).size.height / 11,
      width: MediaQuery.of(context).size.height / 11,
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
      blur: 10,
      borderWidth: 0,
      elevation: 5,
      shadowColor: Colors.black,
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          index % 3 == 0 ? 20 : 5, 15, index % 3 == 2 ? 20 : 5, 10),
      padding: const EdgeInsets.all(10),
    );
  }
}
