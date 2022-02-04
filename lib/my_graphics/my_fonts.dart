import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'my_colors.dart';

class MyFonts {
  MyFonts._();

  static TextStyle songItemWidgetTrackNameStyle = GoogleFonts.rajdhani(
      fontSize: 16, color: MyColors.songItemWidgetTrackNameColor, fontWeight: FontWeight.w900);

  static TextStyle songItemWidgetArtistNameStyle =
      GoogleFonts.itim(fontSize: 15, color: MyColors.songItemWidgetArtistNameColor);

  static TextStyle songItemWidgetAlbumNameStyle =
      GoogleFonts.itim(fontSize: 12, color: MyColors.songItemWidgetAlbumNameColor);

  //
  static TextStyle favoriteWidgetTextStyle =
      GoogleFonts.fuzzyBubbles(color: MyColors.favoriteWidgetTextColor, fontSize: 11);

  static TextStyle recentlyWidgetTextStyle =
      GoogleFonts.fuzzyBubbles(color: MyColors.recentlyWidgetTextColor, fontSize: 11);

  static TextStyle playlistWidgetTextStyle =
      GoogleFonts.fuzzyBubbles(color: MyColors.playlistWidgetTextColor, fontSize: 11);

//
}
