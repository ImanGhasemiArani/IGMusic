import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ig_music/playlist_body.dart';

import 'bottom_navigation_bar.dart';
import 'widgets/main_body.dart';
import 'music_bottom_sheet.dart';
import 'my_graphics/my_colors.dart';
import 'my_graphics/MyIcons.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  static final currentBodyNotifier = ValueNotifier<int>(0);
  static final currentMusicTabNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        color: Colors.white,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/b22.jpg"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: myAppBar(),
          body: ValueListenableBuilder<int>(
            valueListenable: currentMusicTabNotifier,
            builder: (_, value1, __) {
              if (value1 == 0) {
                return ValueListenableBuilder<int>(
                  valueListenable: currentBodyNotifier,
                  builder: (_, value2, __) {
                    switch (value2) {
                      case 0:
                        return MainBody();
                      case 1:
                        return const PlaylistPage();
                    }
                    return MainPage();
                  },
                );
              } else {
                return const OnlineBody();
              }
            },
          ),
          bottomNavigationBar: const MyBottomNavigationBar(),
          // bottomSheet: const MusicBottomSheet(),
        ),
      );
    });
  }

  AppBar myAppBar() => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GlassContainer(
                child: Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  child: TextField(
                    onTap: () {
                      if (kDebugMode) {
                        print("CLick SearchBar");
                      }
                    },
                    autofocus: false,
                    readOnly: true,
                    textDirection: TextDirection.rtl,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          MyIcons.search,
                          color: MyColors.searchIcon,
                          size: 18,
                        )),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.ubuntuMono(
                        color: Colors.black, fontSize: 14),
                  ),
                ),
                borderRadius: BorderRadius.circular(10),
                height: 40,
                width: double.infinity,
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
                blur: 15,
                borderWidth: 0,
                elevation: 3.0,
                shadowColor: Colors.black.withOpacity(0.20),
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              ),
            ),
            ValueListenableBuilder<int>(
                valueListenable: MainPage.currentBodyNotifier,
                builder: (_, value, __) {
                  if (value == 0) {
                    return GestureDetector(
                      child: const Icon(
                        MyIcons.sliders,
                        color: Colors.grey,
                        size: 25,
                      ),
                      onTap: () {},
                    );
                  } else {
                    return GestureDetector(
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.grey,
                        size: 25,
                      ),
                      onTap: () {
                        MainPage.currentBodyNotifier.value = 0;
                      },
                    );
                  }
                }),
          ],
        ),
      );
}

class OnlineBody extends StatelessWidget {
  const OnlineBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.transparent);
  }
}
