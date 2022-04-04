// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Fonts {
  Fonts._();

  //righteous
  //overlock

  static const bold_30 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 30,
  );

  static const w900_20_ff121212 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: Color(0xff121212),
  );

  static const regular_11 = TextStyle(
    fontSize: 11,
  );

  static const regular_16_2 = TextStyle(
    fontSize: 16,
    height: 2,
  );

  static const w700_20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const bold_14_ff000000 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Color(0xFF000000),
  );

  static final rajdhani_16_w900 = GoogleFonts.rajdhani(
    fontSize: 16,
    fontWeight: FontWeight.w900,
  );

  static final rajdhani_30_ffffffff = GoogleFonts.rajdhani(
    fontSize: 30,
    color: const Color(0xFFFFFFFF),
  );

  static final rajdhani_16_w900_ffffffff = GoogleFonts.rajdhani(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: const Color(0xFFFFFFFF),
  );

  static final overlock_15_ffffffff = GoogleFonts.overlock(
    fontSize: 15,
    color: const Color(0xFFFFFFFF),
  );

  static final overlock_14_w700 = GoogleFonts.overlock(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static final overlock_18_w700 = GoogleFonts.overlock(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static final itim_12 = GoogleFonts.itim(
    fontSize: 12,
  );

  static final fuzzyBubbles_14 = GoogleFonts.fuzzyBubbles(
    fontSize: 14,
  );

  static final fuzzyBubbles_11_ffffffff = GoogleFonts.fuzzyBubbles(
    fontSize: 11,
    color: const Color(0xFFFFFFFF),
  );

  static final fuzzyBubbles_4bffffff = GoogleFonts.fuzzyBubbles(
    color: const Color(0x4AFFFFFF),
  );

  static final supermercadoOne_18_ffffffff = GoogleFonts.supermercadoOne(
    fontSize: 18,
    color: const Color(0xFFFFFFFF),
  );

  static final pompiere_14_ffffffff = GoogleFonts.pompiere(
    fontSize: 14,
    color: const Color(0xFFFFFFFF),
  );
}
