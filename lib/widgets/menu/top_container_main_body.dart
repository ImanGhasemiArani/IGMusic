import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../assets/fnt_styles.dart';
import '../button/favorites_button.dart';
import '../button/playlist_button.dart';
import '../button/recently_button.dart';

class TopContainerMainBody extends StatelessWidget {
  const TopContainerMainBody({Key? key}) : super(key: key);

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
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: FavoritesButton(
                    child: Container(
                      height: size.height / 6,
                      width: (size.width - 40) / 3,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
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
                  ),
                ),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: RecentlyButton(
                    child: Container(
                      height: size.height / 6,
                      width: (size.width - 40) / 3,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Expanded(
                            child: SvgPicture.asset(
                              "assets/recent.svg",
                            ),
                          ),
                          AutoSizeText(
                            "Recently",
                            style: FntStyles.recentlyWidgetTextStyle,
                            minFontSize: 9,
                            maxFontSize: 11,
                            maxLines: 1,
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: PlaylistButton(
                child: Container(
                  height: size.height / 9,
                  width: (size.width - 40) / 3 * 2 + 10,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
            ),
          ],
        ),
      ),
    );
  }
}

//import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:glass_kit/glass_kit.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'screens/main_screen.dart';
// import 'my_graphics/MyIcons.dart';
// import 'my_graphics/my_colors.dart';
//
// class FirstLayer extends StatelessWidget {
//   const FirstLayer({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: FittedBox(
//         fit: BoxFit.fill,
//         alignment: Alignment.topCenter,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           textDirection: TextDirection.ltr,
//           children: [
//             GestureDetector(
//               onTap: () {},
//               child: GlassFirstLayer(
//                 index: 0,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   textDirection: TextDirection.rtl,
//                   children: [
//                     const Icon(MyIcons.time, size: 25, color: MyColors.tripleOptionsIcons),
//                     AutoSizeText(
//                       "Recently",
//                       style:
//                           GoogleFonts.ubuntuMono(color: MyColors.tripleOptionsTexts, fontSize: 14),
//                       minFontSize: 12,
//                       maxFontSize: 16,
//                       maxLines: 1,
//                       textDirection: TextDirection.ltr,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {},
//               child: GlassFirstLayer(
//                 index: 1,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   textDirection: TextDirection.rtl,
//                   children: [
//                     const Icon(MyIcons.heart_1, size: 25, color: MyColors.tripleOptionsIcons),
//                     AutoSizeText(
//                       "Favorites",
//                       style:
//                           GoogleFonts.ubuntuMono(color: MyColors.tripleOptionsTexts, fontSize: 14),
//                       minFontSize: 12,
//                       maxFontSize: 16,
//                       maxLines: 1,
//                       textDirection: TextDirection.ltr,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 MainScreen.currentBodyNotifier.value = 1;
//               },
//               child: GlassFirstLayer(
//                 index: 2,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   textDirection: TextDirection.rtl,
//                   children: [
//                     const Icon(MyIcons.playlist, size: 25, color: MyColors.tripleOptionsIcons),
//                     AutoSizeText(
//                       "Playlist",
//                       style:
//                           GoogleFonts.ubuntuMono(color: MyColors.tripleOptionsTexts, fontSize: 14),
//                       minFontSize: 12,
//                       maxFontSize: 16,
//                       maxLines: 1,
//                       textDirection: TextDirection.ltr,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class GlassFirstLayer extends StatelessWidget {
//   const GlassFirstLayer({
//     Key? key,
//     required this.child,
//     required this.index,
//   }) : super(key: key);
//   final Widget child;
//   final int index;
//
//   @override
//   Widget build(BuildContext context) {
//     return GlassContainer.frostedGlass(
//       child: child,
//       borderRadius: BorderRadius.circular(50),
//       height: MediaQuery.of(context).size.height / 11,
//       width: MediaQuery.of(context).size.height / 11,
//       gradient: LinearGradient(
//         colors: [Colors.white.withOpacity(0.40), Colors.white.withOpacity(0.10)],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//       borderGradient: LinearGradient(
//         colors: [
//           Colors.white.withOpacity(0.60),
//           Colors.white.withOpacity(0.10),
//           Colors.lightBlueAccent.withOpacity(0.05),
//           Colors.lightBlueAccent.withOpacity(0.6)
//         ],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         stops: const [0.0, 0.39, 0.40, 1.0],
//       ),
//       blur: 10,
//       borderWidth: 0,
//       elevation: 5,
//       shadowColor: Colors.black,
//       alignment: Alignment.center,
//       margin: EdgeInsets.fromLTRB(index % 3 == 0 ? 20 : 5, 15, index % 3 == 2 ? 20 : 5, 10),
//       padding: const EdgeInsets.all(10),
//     );
//   }
// }
