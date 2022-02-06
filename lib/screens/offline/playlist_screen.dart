import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ig_music/assets/clrs.dart';

import '../../widgets/button/btn_audio_control.dart';
import '../../widgets/card/glass_container.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 14,
                  child: MyGlassContainer(
                      child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: AutoSizeText(
                              "All Local Songs",
                              style: GoogleFonts.ubuntuMono(
                                fontSize: 25,
                                fontWeight: FontWeight.normal,
                                color: Clrs.tmp,
                              ),
                              minFontSize: 16,
                              maxFontSize: 30,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const PlayPauseAllLocalSongsButton(),
                        ],
                      ),
                    ),
                  ))),
            ),
          ],
        ));
  }
}
