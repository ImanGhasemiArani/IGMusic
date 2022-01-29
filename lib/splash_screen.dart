import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Image.asset("assets/splash.png")),
        Text(
          "IG Music",
          style: GoogleFonts.ubuntuMono(fontSize: 30,color: Colors.white),
        )
      ],
    );
  }
}
