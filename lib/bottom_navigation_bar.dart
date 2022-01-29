import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'my_graphics/MyIcons.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: 60,
      width: MediaQuery.of(context).size.width,
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
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.20),
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: SalomonBottomBar(
        itemShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        curve: Curves.bounceOut,
        unselectedItemColor: Colors.grey,
        margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 8),
        itemPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(MyIcons.headphones_1),
            title: Text(
              "My Music",
              style: GoogleFonts.ubuntuMono(),
            ),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.online_prediction_rounded),
            title: Text(
              "Online",
              style: GoogleFonts.ubuntuMono(),
            ),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
