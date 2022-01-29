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
                          style: TextButton.styleFrom(
                            alignment: Alignment.center,
                            enableFeedback: false,
                            backgroundColor: Colors.transparent,
                            primary: Colors.transparent,
                            side: BorderSide(
                              color: MyColors.musicListTopIconText
                                  .withOpacity(0.5),
                            ),
                          ),
                          onPressed: () {},
                          icon: const Icon(
                            MyIcons.shuffle,
                            color: MyColors.musicListTopIconText,
                            size: 17,
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
                        children: const [
                          Icon(
                            MyIcons.grid_menu,
                            color: MyColors.musicListTopIconText,
                            size: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              MyIcons.sort,
                              color: MyColors.musicListTopIconText,
                              size: 20,
                            ),
                          ),
                          Icon(
                            MyIcons.check_list_1,
                            color: MyColors.musicListTopIconText,
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
        height: MediaQuery.of(context).size.height / 20,
        width: MediaQuery.of(context).size.width,
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.40),
            Colors.white.withOpacity(0.10),
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
        elevation: 5,
        shadowColor: Colors.black,
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(35, 0, 35, 5),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      ),
    );
  }
}
