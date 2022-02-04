import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ig_music/my_graphics/my_fonts.dart';

class TopContainerMainBody extends StatelessWidget {
  const TopContainerMainBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FittedBox(
      fit: BoxFit.fill,
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Row(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Container(
                  height: size.height / 6,
                  width: (size.width - 40) / 3,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 0)]),
                  child: Column(
                    children: [
                      Expanded(
                        child: SvgPicture.asset(
                          "assets/popular.svg",
                        ),
                      ),
                      AutoSizeText(
                        "Favorites",
                        style: MyFonts.favoriteWidgetTextStyle,
                        minFontSize: 9,
                        maxFontSize: 11,
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Container(
                  height: size.height / 6,
                  width: (size.width - 40) / 3,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 0)]),
                  child: Column(
                    children: [
                      Expanded(
                        child: SvgPicture.asset(
                          "assets/recent.svg",
                        ),
                      ),
                      AutoSizeText(
                        "Recently",
                        style: MyFonts.recentlyWidgetTextStyle,
                        minFontSize: 9,
                        maxFontSize: 11,
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Container(
              height: size.height / 9,
              width: (size.width - 40) / 3 * 2 + 10,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 0)]),
              child: Row(
                children: [
                  AutoSizeText(
                    "Playlist",
                    style: MyFonts.playlistWidgetTextStyle,
                    minFontSize: 9,
                    maxFontSize: 11,
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                  ),
                  Expanded(
                    child: SvgPicture.asset(
                      "assets/playlist.svg",
                      alignment: Alignment.centerRight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
