import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../assets/icos.dart';
import '../screens/offline/offline_screen.dart';

AppBar searchAppBar(BuildContext context, Size size) => AppBar(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(5),
      )),
      centerTitle: true,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
            child: ValueListenableBuilder<int>(
                valueListenable: OfflineScreen.currentBodyNotifier,
                builder: (_, value, __) {
                  if (value == 0) {
                    return GestureDetector(
                      child: const Icon(
                        Icos.sliders,
                        //   color: Clrs.tmp,
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
                        OfflineScreen.currentBodyNotifier.value = 0;
                      },
                    );
                  }
                }),
          ),
          Expanded(
            child: SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  TextField(
                    //   readOnly: true,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      suffixIcon: Icon(
                        Icos.search,
                        color: Theme.of(context).colorScheme.primary,
                        size: 25,
                      ),
                    ),
                    maxLines: 1,
                    minLines: 1,
                    style: GoogleFonts.itim(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
