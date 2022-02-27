import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ig_music/assets/clrs.dart';

class FntStyles {
  FntStyles._();

  //

  static TextStyle songMiniItemWidgetTrackNameStyle = GoogleFonts.rajdhani(
      fontSize: 16,
      color: Clrs.songMiniItemWidgetTrackNameColor,
      fontWeight: FontWeight.w900);

  static TextStyle songMiniItemWidgetArtistNameStyle = GoogleFonts.itim(
      fontSize: 15, color: Clrs.songMiniItemWidgetArtistNameColor);

  //

  static TextStyle songFullItemWidgetTrackNameStyle = GoogleFonts.rajdhani(
      fontSize: 15,
      color: Clrs.songFullItemWidgetTrackNameColor,
      fontWeight: FontWeight.w900);

  static TextStyle songFullItemWidgetArtistNameStyle = GoogleFonts.itim(
      fontSize: 11, color: Clrs.songFullItemWidgetArtistNameColor);

  //

  static TextStyle songRecentlyItemWidgetTrackNameStyle =
      GoogleFonts.rajdhani(fontSize: 14, fontWeight: FontWeight.w900);

  static TextStyle songRecentlyItemWidgetArtistNameStyle =
      GoogleFonts.itim(fontSize: 15);

  //

  static TextStyle playlistWidgetTextStyle =
      GoogleFonts.fuzzyBubbles(fontSize: 11);

  static TextStyle shuffleButtonWidgetTextStyle =
      GoogleFonts.fuzzyBubbles(fontSize: 11);

  static TextStyle progressTimeLabelStyle = GoogleFonts.fuzzyBubbles(
      color: Clrs.progressTimeLabelColor, fontSize: 12);

  static TextStyle favoriteWidgetTextStyle = GoogleFonts.fuzzyBubbles(
      color: Clrs.favoriteWidgetTextColor, fontSize: 11);

  static TextStyle tmp =
      GoogleFonts.fuzzyBubbles(color: Colors.white, fontSize: 11);

//
}
