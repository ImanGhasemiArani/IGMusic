import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../assets/fnt_styles.dart';
import '../../controllers/btn_controllers.dart';
import '../card/header_item_card.dart';

class HeaderHomeItems extends StatelessWidget {
  const HeaderHomeItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FittedBox(
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeaderItemCard(
                  onTap: favoritesBtnTaped,
                  height: size.height / 6,
                  width: (size.width - 40) / 3,
                  child: Column(
                    children: [
                      Expanded(
                        child: SvgPicture.asset(
                          "assets/popular.svg",
                        ),
                      ),
                      AutoSizeText(
                        "Favorites",
                        style: FntStyles.favoriteWidgetTextStyle,
                        minFontSize: 9,
                        maxFontSize: 11,
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
                HeaderItemCard(
                  onTap: recentlyBtnTaped,
                  height: size.height / 6,
                  width: (size.width - 40) / 3,
                  child: Column(
                    children: [
                      Expanded(
                        child: SvgPicture.asset(
                          "assets/recent.svg",
                        ),
                      ),
                      AutoSizeText(
                        "Recently",
                        style: FntStyles.favoriteWidgetTextStyle,
                        minFontSize: 9,
                        maxFontSize: 11,
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            HeaderItemCard(
              onTap: playlistBtnTaped,
              height: size.height / 9,
              width: (size.width - 40) / 3 * 2 + 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    AutoSizeText(
                      "Playlist",
                      style: FntStyles.playlistWidgetTextStyle,
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
      ),
    );
  }
}
