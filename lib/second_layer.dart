import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'my_graphics/MyColors.dart';
import 'my_graphics/MyIcons.dart';

class SecondLayer extends StatelessWidget {
  const SecondLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassContainer(
        child: Container(
          height: 30,
          // color: Colors.green,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  // Colors.lightBlueAccent.withOpacity(0.05),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton.icon(
                          style: const ButtonStyle(
                            alignment: Alignment.center,
                            enableFeedback: false,
                          ),
                          onPressed: () {},
                          icon: const Icon(
                            MyIcons.shuffle,
                            color: MyColors.musicListTopIconText,
                            size: 18,
                          ),
                          label: Text(
                            "Shuffle Playback",
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.ubuntuMono(
                                color: MyColors.musicListTopIconText,
                                fontSize: 15),
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            MyIcons.grid_menu,
                            color: Colors.white.withOpacity(0.5),
                            size: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              MyIcons.sort,
                              color: Colors.white.withOpacity(0.5),
                              size: 20,
                            ),
                          ),
                          Icon(
                            MyIcons.check_list_1,
                            color: Colors.white.withOpacity(0.5),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(10),
        height: double.infinity,
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
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      ),
    );
  }
}
