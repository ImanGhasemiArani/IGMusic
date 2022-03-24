import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../assets/fonts.dart';
import '../../assets/icos.dart';
import '../../controllers/btn_controllers.dart';

class MenuContainerMainBody extends StatelessWidget {
  const MenuContainerMainBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).colorScheme.surface
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Card(
            elevation: 5,
            color: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: InkWell(
              enableFeedback: false,
              borderRadius: BorderRadius.circular(5),
              onTap: btnShufflePlaybackTaped,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icos.shuffle,
                        size: 14,
                      ),
                    ),
                    AutoSizeText(
                      "Shuffle Playback",
                      style: Fonts.overlock_11,
                      maxLines: 1,
                      maxFontSize: 11,
                      minFontSize: 9,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    color: color,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: InkWell(
                      enableFeedback: false,
                      borderRadius: BorderRadius.circular(5),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icos.grid_menu,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      elevation: 5,
                      color: color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: InkWell(
                        enableFeedback: false,
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icos.sort,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    color: color,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: InkWell(
                      enableFeedback: false,
                      borderRadius: BorderRadius.circular(5),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icos.check_list_1,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
