import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ig_music/assets/clrs.dart';

class FntStyles {
  FntStyles._();

  static TextStyle songItemWidgetTrackNameStyle = GoogleFonts.rajdhani(
      fontSize: 16,
      color: Clrs.songItemWidgetTrackNameColor,
      fontWeight: FontWeight.w900);

  static TextStyle songMiniItemWidgetTrackNameStyle = GoogleFonts.rajdhani(
      fontSize: 16,
      color: Clrs.songMiniItemWidgetTrackNameColor,
      fontWeight: FontWeight.w900);

  static TextStyle songItemWidgetArtistNameStyle =
      GoogleFonts.itim(fontSize: 15, color: Clrs.songItemWidgetArtistNameColor);

  static TextStyle songMiniItemWidgetArtistNameStyle = GoogleFonts.itim(
      fontSize: 15, color: Clrs.songMiniItemWidgetArtistNameColor);

  static TextStyle songItemWidgetAlbumNameStyle =
      GoogleFonts.itim(fontSize: 12, color: Clrs.songItemWidgetAlbumNameColor);

  //
  static TextStyle favoriteWidgetTextStyle = GoogleFonts.fuzzyBubbles(
      color: Clrs.favoriteWidgetTextColor, fontSize: 11);

  static TextStyle recentlyWidgetTextStyle = GoogleFonts.fuzzyBubbles(
      color: Clrs.recentlyWidgetTextColor, fontSize: 11);

  static TextStyle playlistWidgetTextStyle = GoogleFonts.fuzzyBubbles(
      color: Clrs.playlistWidgetTextColor, fontSize: 11);

  static TextStyle shuffleButtonWidgetTextStyle = GoogleFonts.fuzzyBubbles(
      color: Clrs.shuffleButtonWidgetTextColor, fontSize: 11);

  static TextStyle tmp =
      GoogleFonts.fuzzyBubbles(color: Colors.white, fontSize: 11);

//
}
