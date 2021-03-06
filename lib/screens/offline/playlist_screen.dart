import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../assets/fonts.dart';
import '../../controllers/btn_controllers.dart';
import '../../widgets/button/btn_play_pause.dart';

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
                    margin: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 40),
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 14,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Flexible(
                              child: AutoSizeText(
                                "All Local Songs",
                                style: Fonts.s14,
                                minFontSize: 16,
                                maxFontSize: 30,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            BtnPlayPause(onPlayTap: btnPlayAllTaped),
                          ],
                        ),
                      ),
                    ))),
          ],
        ));
  }
}
